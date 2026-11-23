class_name UnitVisual
extends Node2D

signal impact_hit(is_skill: bool)
signal state_changed(state_name: String)
signal action_finished

const CombatProjectile = preload("res://scripts/entities/combat_projectile.gd")
const ELEMENT_COLORS := {
	"fire": Color(1.0, 0.52, 0.28), "water": Color(0.40, 0.83, 1.0),
	"wind": Color(0.64, 0.98, 0.36), "earth": Color(0.90, 0.72, 0.34),
	"light": Color(1.0, 0.93, 0.56), "dark": Color(0.81, 0.45, 1.0),
}
# Weapon or mouth location in normalized sprite pixels, facing right.
const MUZZLES := {
	"archer": Vector2(47, -57), "sniper": Vector2(48, -63),
	"mage": Vector2(42, -59), "enchanter": Vector2(44, -62),
	"priest": Vector2(39, -60), "druid": Vector2(43, -66),
	"dark_mage": Vector2(46, -61), "boss_ice_dragon": Vector2(69, -113),
}
const ATTACK_BEATS := [0.082, 0.096, 0.065, 0.078, 0.096, 0.120]
const SKILL_BEATS := [0.105, 0.150, 0.092, 0.102, 0.135, 0.160]

@export var facing_sign: float = 1.0
@export var unit_scale: float = 2.2
@export var juice_enabled: bool = true
@export var idle_speed_scale: float = 1.0

var art_facing: float = 1.0
var motion_root: Node2D
var home_position: Vector2

var current_state: String = "idle"
var is_dead: bool = false

var _anims: Dictionary = {}
var _current_anim: Dictionary = {}
var _is_action: bool = false
var _freeze_until: int = 0
var _frozen_tween: Tween
var _blend: float = 1.0
var _blend_origin := Transform2D.IDENTITY
var _blend_tween: Tween
var _ghost_budget: int = 0
var _ghost_timer: float = 0.0
var _ghost_origin: Vector2
var _home_tween: Tween
var _formation_facing: float
var _frame_timer: float = 0.0
var _frame_index: int = 0
var _frame_dir: int = 1
var _idle_time: float = 0.0
var _run_time: float = 0.0
var _active_tween: Tween
var _flash_tween: Tween

var _shadow: Polygon2D
var _aura_ring: Polygon2D
var _pivot: Node2D
var _sprite: Sprite2D
var _dust_particles: CPUParticles2D
var _burst_particles: CPUParticles2D
var _shader_mat: ShaderMaterial


func _ready() -> void:
	_ensure_nodes()
	_idle_time = randf_range(0.0, TAU)
	_formation_facing = facing_sign
	if motion_root == null:
		motion_root = self
		home_position = position


func _ensure_nodes() -> void:
	if _pivot != null:
		return

	_shadow = Polygon2D.new()
	_shadow.name = "Shadow"
	_shadow.color = Color(0.05, 0.06, 0.10, 0.42)
	var pts := PackedVector2Array()
	for i in 16:
		var ang := (float(i) / 16.0) * TAU
		pts.append(Vector2(cos(ang) * 44.0, sin(ang) * 12.0))
	_shadow.polygon = pts
	_shadow.position = Vector2(0, 4)
	add_child(_shadow)

	_aura_ring = Polygon2D.new()
	_aura_ring.name = "AuraRing"
	_aura_ring.visible = false
	var aura_pts := PackedVector2Array()
	for i in 20:
		var ang := (float(i) / 20.0) * TAU
		aura_pts.append(Vector2(cos(ang) * 56.0, sin(ang) * 18.0))
	_aura_ring.polygon = aura_pts
	_aura_ring.position = Vector2(0, 3)
	add_child(_aura_ring)

	_pivot = Node2D.new()
	_pivot.name = "VisualPivot"
	_pivot.scale = Vector2(unit_scale, unit_scale)
	add_child(_pivot)

	_sprite = Sprite2D.new()
	_sprite.name = "Sprite"
	_sprite.centered = true
	_sprite.offset = Vector2(0, -58)
	_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR

	var sh: Shader = load("res://assets/shaders/hit_flash.gdshader")
	if sh != null:
		_shader_mat = ShaderMaterial.new()
		_shader_mat.shader = sh
		_shader_mat.set_shader_parameter("flash_amount", 0.0)
		_sprite.material = _shader_mat
	_pivot.add_child(_sprite)

	_dust_particles = CPUParticles2D.new()
	_dust_particles.name = "DustParticles"
	_dust_particles.emitting = false
	_dust_particles.amount = 14
	_dust_particles.lifetime = 0.42
	_dust_particles.one_shot = false
	_dust_particles.direction = Vector2(-facing_sign, -0.45)
	_dust_particles.spread = 28.0
	_dust_particles.initial_velocity_min = 40.0
	_dust_particles.initial_velocity_max = 95.0
	_dust_particles.gravity = Vector2(0, 60)
	_dust_particles.scale_amount_min = 4.0
	_dust_particles.scale_amount_max = 9.0
	_dust_particles.color = Color(0.92, 0.88, 0.78, 0.65)
	add_child(_dust_particles)

	_burst_particles = CPUParticles2D.new()
	_burst_particles.name = "BurstParticles"
	_burst_particles.emitting = false
	_burst_particles.one_shot = true
	_burst_particles.explosiveness = 0.92
	_burst_particles.amount = 22
	_burst_particles.lifetime = 0.36
	_burst_particles.position = Vector2(facing_sign * 42.0, -56.0)
	_burst_particles.direction = Vector2(facing_sign, -0.25)
	_burst_particles.spread = 65.0
	_burst_particles.initial_velocity_min = 140.0
	_burst_particles.initial_velocity_max = 310.0
	_burst_particles.gravity = Vector2(0, 260)
	_burst_particles.scale_amount_min = 5.0
	_burst_particles.scale_amount_max = 11.0
	_burst_particles.color = Color(0.45, 0.92, 1.0, 0.95)
	add_child(_burst_particles)


func configure_animations(anim_map: Dictionary) -> void:
	_ensure_nodes()
	_anims = anim_map.duplicate(true)
	play_idle()


func set_juice_enabled(enabled: bool) -> void:
	juice_enabled = enabled
	if not juice_enabled and _pivot != null:
		if not _is_action and not is_dead:
			_begin_blend()
		_dust_particles.emitting = false


func _apply_anim_texture(anim_key: String) -> Dictionary:
	if _anims.is_empty():
		return {}
	var fallback_key := anim_key
	if not _anims.has(fallback_key):
		fallback_key = "idle" if _anims.has("idle") else _anims.keys()[0]
	var cfg: Dictionary = _anims[fallback_key]
	_sprite.texture = cfg.get("texture", null)
	_sprite.hframes = int(cfg.get("hframes", 1))
	_sprite.vframes = int(cfg.get("vframes", 1))
	if _sprite.texture != null:
		var cell_h: float = float(_sprite.texture.get_height()) / float(maxi(1, _sprite.vframes))
		var margin_b := float(cfg.get("ground_margin", 48.0))
		_sprite.flip_h = facing_sign != art_facing
		_sprite.offset = Vector2(0.0, -(cell_h * 0.5 - margin_b))
	_frame_index = 0
	_frame_dir = 1
	_frame_timer = 0.0
	_sprite.frame = 0
	_current_anim = cfg
	return cfg


func _kill_active_tween() -> void:
	if _active_tween != null and _active_tween.is_valid():
		_active_tween.kill()
	_active_tween = null
	_frozen_tween = null


func _enter_state(state: String) -> void:
	current_state = state
	_apply_anim_texture(state)
	_dust_particles.emitting = state == "run" and juice_enabled
	state_changed.emit(state)


func _begin_blend() -> void:
	if _blend_tween != null:
		_blend_tween.kill()
	_blend_origin = _pivot.transform
	_blend = 0.0
	_blend_tween = create_tween()
	_blend_tween.tween_property(self, "_blend", 1.0, 0.115).set_trans(Tween.TRANS_SINE)


func _enter_locomotion(state: String) -> void:
	_enter_state(state)
	_begin_blend()


func play_idle() -> void:
	_ensure_nodes()
	if is_dead:
		return
	_cancel_motion()
	_sprite.modulate = Color.WHITE
	_enter_locomotion("idle")


func play_run() -> void:
	_ensure_nodes()
	if is_dead:
		return
	_cancel_motion()
	_enter_locomotion("run")


func _cancel_motion() -> void:
	_kill_active_tween()
	_is_action = false
	_ghost_budget = 0
	_face(_formation_facing)
	if motion_root != null and not motion_root.position.is_equal_approx(home_position):
		if _home_tween != null:
			_home_tween.kill()
		_home_tween = create_tween()
		_home_tween.tween_property(motion_root, "position", home_position, 0.21).set_trans(Tween.TRANS_SINE)


func play_attack(target_global_x: float) -> void:
	_play_demo_action(false, target_global_x)


func play_skill(target_global_x: float) -> void:
	_play_demo_action(true, target_global_x)


func _play_demo_action(skill: bool, target_x: float) -> void:
	var clearance := 74.0 * unit_scale * global_transform.x.length()
	var x := maxf(0.0, (target_x - global_position.x) * facing_sign - clearance)
	var destination := global_position + Vector2(x * facing_sign, 0)
	play_action(skill, destination, false, false)


func play_action(skill: bool, destination: Vector2, flank: bool, ranged: bool,
		follow_target: Node2D = null) -> void:
	_ensure_nodes()
	if is_dead or _is_action or _anims.is_empty():
		return
	_kill_active_tween()
	if _home_tween != null:
		_home_tween.kill()
	_is_action = true
	_ghost_budget = 4 if juice_enabled and (not ranged or skill) else 0
	_ghost_timer = 0.0
	_ghost_origin = _pivot.global_position
	var tween := create_tween()
	_active_tween = tween
	var start := motion_root.global_position
	# Layout can scale the arena without changing the movement speed in arena units.
	var world_scale := motion_root.global_transform.x.length()
	var distance := start.distance_to(destination) / world_scale
	var travel := juice_enabled and not ranged and distance > 15.0
	var formation_facing := _formation_facing
	if travel:
		_enter_locomotion("run")
		var duration := clampf(distance / (1120.0 if flank else 900.0), 0.12, 0.53)
		_add_travel(tween, destination, duration, -68.0 if flank else 0.0, follow_target)
	tween.tween_callback(func() -> void:
		if flank and travel:
			_face(-formation_facing)
		_enter_state("skill" if skill else "attack")
	)

	var key := "skill" if skill else "attack"
	var cfg: Dictionary = _anims.get(key, _anims.get("idle", {}))
	var frame_count := int(cfg.get("frames", 1))
	var contact := clampi(int(cfg.get("contact", 3)), 0, frame_count - 1)
	var beats: Array = SKILL_BEATS if skill else ATTACK_BEATS
	for frame in frame_count:
		var time := float(beats[mini(frame, beats.size() - 1)])
		# The cel and impact callback are in the same tween step. This also
		# couples local hitstop to frame timing instead of a separate FPS clock.
		tween.tween_callback(_show_action_frame.bind(frame, contact, skill, ranged))
		if juice_enabled:
			var pose_facing := -formation_facing if flank and travel else formation_facing
			var pose := _action_pose(frame, contact, frame_count, skill, ranged, pose_facing)
			tween.tween_property(_pivot, "transform", pose, time).set_trans(Tween.TRANS_SINE)
		else:
			tween.tween_interval(time)

	if travel:
		var home_global := (motion_root.get_parent() as CanvasItem).get_global_transform() * home_position
		tween.tween_callback(_enter_locomotion.bind("run"))
		var duration := clampf(destination.distance_to(home_global) / (1000.0 * world_scale), 0.16, 0.48)
		_add_travel(tween, home_global, duration, -34.0 if flank else 0.0)
	tween.tween_callback(func() -> void:
		_active_tween = null
		_face(formation_facing)
		play_idle()
		action_finished.emit()
	)


func _face(direction: float) -> void:
	facing_sign = direction
	_sprite.flip_h = facing_sign != art_facing
	_dust_particles.direction = Vector2(-direction, -0.45)


func _add_travel(tween: Tween, destination: Vector2, duration: float, arc: float,
		follow_target: Node2D = null) -> void:
	# Use arena coordinates so camera shake leaves the route intact.
	var arena := motion_root.get_parent() as CanvasItem
	var to_local := arena.get_global_transform().affine_inverse()
	var endpoint := to_local * destination
	var follow_origin := to_local * follow_target.global_position if follow_target != null else endpoint
	var start: Array[Vector2] = []
	tween.tween_callback(func() -> void: start.append(motion_root.position))
	tween.tween_method(func(progress: float) -> void:
		var current_end := endpoint
		if is_instance_valid(follow_target):
			current_end += arena.get_global_transform().affine_inverse() * follow_target.global_position - follow_origin
			current_end.x = clampf(current_end.x, 45.0, 675.0)
		motion_root.position = start[0].lerp(current_end, progress)
		motion_root.position.y += sin(progress * PI) * arc
	, 0.0, 1.0, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func _action_pose(frame: int, contact: int, frame_count: int, skill: bool, ranged: bool, side: float) -> Transform2D:
	var weight := 1.0 if skill else 0.68
	var stretch := Vector2.ONE
	var shift := Vector2.ZERO
	var lean := 0.0
	if frame < contact - 1:
		shift = Vector2(-6.0 * side, -4.0 if skill else 1.0) * weight
		lean = -side * 0.065 * weight
		stretch = Vector2(1.035, 0.955)
	elif frame <= contact:
		shift = Vector2(side * (-9.0 if ranged else 13.0), -2.0) * weight
		lean = side * (-0.085 if ranged else 0.115) * weight
		stretch = Vector2(1.0 + 0.105 * weight, 1.0 - 0.075 * weight)
	elif frame < frame_count - 1:
		shift.x = side * (2.0 if ranged else 5.0) * weight
		lean = side * 0.034
	return Transform2D(lean, stretch * unit_scale, 0.0, shift)


func _show_action_frame(frame: int, contact: int, skill: bool, ranged: bool) -> void:
	_sprite.frame = frame
	if skill and frame == contact - 1 and ranged:
		_spawn_ghost()
	if frame != contact:
		return
	if not ranged:
		_emit_burst(Color(0.37, 0.85, 1.0, 0.96) if skill else Color(1.0, 0.91, 0.58, 0.88), 0.0)
	if skill:
		_spawn_ghost()
	impact_hit.emit(skill)


func freeze_pose(seconds: float) -> void:
	if not juice_enabled:
		return
	_freeze_until = maxi(_freeze_until, Time.get_ticks_usec() + int(seconds * 1000000.0))


func _spawn_ghost() -> void:
	if _ghost_budget <= 0 or _sprite.texture == null:
		return
	_ghost_budget -= 1
	_ghost_origin = _pivot.global_position
	var ghost := Sprite2D.new()
	ghost.texture = _sprite.texture
	ghost.hframes = _sprite.hframes
	ghost.vframes = _sprite.vframes
	ghost.frame = _sprite.frame
	ghost.offset = _sprite.offset
	ghost.flip_h = _sprite.flip_h
	ghost.texture_filter = _sprite.texture_filter
	ghost.modulate = Color(0.64, 0.84, 1.0, 0.28)
	# Keep a motion sample in world space while the unit continues its dash.
	ghost.top_level = true
	add_child(ghost)
	ghost.global_transform = _sprite.global_transform
	ghost.z_index = 1
	var fade := ghost.create_tween()
	fade.tween_property(ghost, "modulate:a", 0.0, 0.155).set_trans(Tween.TRANS_QUAD)
	fade.tween_callback(ghost.queue_free)


func play_hit(heavy: bool = false) -> void:
	_ensure_nodes()
	if is_dead:
		return
	_cancel_motion()
	current_state = "hit"
	_is_action = false
	_ghost_budget = 0
	if _anims.has("hit"):
		_apply_anim_texture("hit")
	else:
		_apply_anim_texture("idle")
	_dust_particles.emitting = false
	state_changed.emit("hit")

	flash_hit(heavy)

	var kb_dist: float = -facing_sign * (36.0 if heavy else 20.0)
	_active_tween = create_tween()
	if juice_enabled:
		_active_tween.tween_property(_pivot, "position", Vector2(kb_dist, -8.0 if heavy else -4.0), 0.07).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		_active_tween.parallel().tween_property(_pivot, "scale", Vector2(unit_scale * 0.86, unit_scale * 1.12), 0.07)
		_active_tween.parallel().tween_property(_pivot, "rotation", -facing_sign * 0.16, 0.07)

		_active_tween.tween_property(_pivot, "position", Vector2.ZERO, 0.16).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		_active_tween.parallel().tween_property(_pivot, "scale", Vector2(unit_scale, unit_scale), 0.16)
		_active_tween.parallel().tween_property(_pivot, "rotation", 0.0, 0.16)
	else:
		_active_tween.tween_interval(0.22)

	_active_tween.tween_callback(func() -> void:
		if not is_dead and current_state == "hit":
			play_idle()
	)


func flash_hit(heavy: bool) -> void:
	if _shader_mat != null:
		if _flash_tween != null and _flash_tween.is_valid():
			_flash_tween.kill()
		_shader_mat.set_shader_parameter("flash_amount", 1.0)
		_flash_tween = create_tween()
		_flash_tween.tween_method(
			func(v: float) -> void: _shader_mat.set_shader_parameter("flash_amount", v),
			1.0, 0.0, 0.14 if heavy else 0.10
		)


func play_death() -> void:
	_ensure_nodes()
	if is_dead:
		return
	is_dead = true
	_is_action = false
	_ghost_budget = 0
	_kill_active_tween()
	if _home_tween != null:
		_home_tween.kill()
	current_state = "death"
	_dust_particles.emitting = false
	state_changed.emit("death")

	var has_death := _anims.has("death")
	_apply_anim_texture("death" if has_death else "idle")

	_emit_burst(Color(0.85, 0.85, 0.90, 0.75), 0.0)
	_active_tween = create_tween()
	_active_tween.tween_property(_pivot, "rotation", 0.0 if has_death else -facing_sign * 1.36, 0.28).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	_active_tween.parallel().tween_property(_pivot, "position", Vector2(-facing_sign * 28.0, 12.0), 0.28)
	_active_tween.parallel().tween_property(_sprite, "modulate:a", 0.35, 0.45)
	_active_tween.parallel().tween_property(_shadow, "scale", Vector2(1.25, 0.75), 0.28)


func respawn() -> void:
	is_dead = false
	_freeze_until = 0
	_sprite.modulate = Color.WHITE
	play_idle()


func set_aura(col: Color, active: bool) -> void:
	_ensure_nodes()
	_aura_ring.visible = active
	if active:
		_aura_ring.color = Color(col.r, col.g, col.b, 0.48)


func spawn_vfx_sprite(tex_path: String, local_pos: Vector2, target_scale: float = 1.25, tint: Color = Color.WHITE) -> void:
	var tex: Texture2D = load(tex_path)
	if tex == null:
		return
	var sp := Sprite2D.new()
	sp.texture = tex
	sp.position = local_pos
	sp.scale = Vector2(target_scale * 0.65, target_scale * 0.65)
	sp.modulate = tint
	sp.z_index = 25
	add_child(sp)
	var vt := sp.create_tween()
	vt.tween_property(sp, "scale", Vector2(target_scale * 1.25, target_scale * 1.25), 0.24).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	vt.parallel().tween_property(sp, "modulate:a", 0.0, 0.34).set_delay(0.10)
	vt.tween_callback(sp.queue_free)


func _emit_burst(col: Color, x_offset: float) -> void:
	if not juice_enabled:
		return
	_burst_particles.position = Vector2(x_offset + facing_sign * 42.0, -56.0)
	_burst_particles.color = col
	_burst_particles.restart()
	_burst_particles.emitting = true


func fire_projectile(target: Node2D, target_offset: Vector2, unit_id: String, element: String,
		heavy: bool, arrived: Callable) -> void:
	var shot := CombatProjectile.new()
	add_child(shot)
	var muzzle_offset: Vector2 = MUZZLES.get(unit_id, Vector2(34.0, -62.0))
	muzzle_offset.x *= facing_sign
	var muzzle := _pivot.to_global(muzzle_offset)
	var kind := "arrow" if unit_id == "archer" else ("round" if unit_id == "sniper" else "magic")
	var tint: Color = ELEMENT_COLORS.get(element, Color.WHITE)
	shot.launch(muzzle, target, target_offset, tint, kind, heavy, arrived)


func _process(delta: float) -> void:
	if _sprite == null or _current_anim.is_empty():
		return
	var frozen := Time.get_ticks_usec() < _freeze_until
	if frozen:
		if _active_tween != null and _active_tween.is_running():
			_frozen_tween = _active_tween
			_frozen_tween.pause()
		return
	if _frozen_tween != null:
		if _frozen_tween.is_valid():
			_frozen_tween.play()
		_frozen_tween = null

	if not _is_action or current_state == "run":
		var count := int(_current_anim.get("frames", 1))
		var fps := float(_current_anim.get("fps", 8.0)) * (idle_speed_scale if current_state == "idle" else 1.0)
		var step := 1.0 / maxf(0.1, fps)
		var loop := bool(_current_anim.get("loop", false))
		var ping_pong := loop and bool(_current_anim.get("ping_pong", false))
		if current_state == "run" and _sprite.texture == _anims.get("idle", {}).get("texture"):
			count = 1
		if current_state == "idle":
			count = int(_current_anim.get("idle_frames", count))
		_frame_timer += delta
		while _frame_timer >= step:
			_frame_timer -= step
			if ping_pong and count > 1:
				var next_idx := _frame_index + _frame_dir
				if next_idx >= count:
					_frame_dir = -1
					next_idx = count - 2
				elif next_idx < 0:
					_frame_dir = 1
					next_idx = 1
				_frame_index = next_idx
			else:
				_frame_index = (_frame_index + 1) % count if loop else mini(_frame_index + 1, count - 1)
		_sprite.frame = _frame_index

	if _is_action and _ghost_budget > 0:
		_ghost_timer -= delta
		if _ghost_timer <= 0.0 and _ghost_origin.distance_to(_pivot.global_position) > 19.0:
			_spawn_ghost()
			_ghost_timer = 0.048

	if is_dead or current_state not in ["idle", "run"]:
		return
	var size := Vector2.ONE
	var shift := Vector2.ZERO
	var lean := 0.0
	var shadow_width := 1.0
	if juice_enabled and current_state == "idle":
		_idle_time += delta * 1.85 * idle_speed_scale
		var breath := sin(_idle_time) * 0.015
		size = Vector2(1.0 - breath * 0.45, 1.0 + breath)
		shift.y = -sin(_idle_time) * 1.2
		lean = sin(_idle_time * 0.7) * 0.007
	elif juice_enabled:
		_run_time += delta * 26.0
		var hop := absf(sin(_run_time))
		shift.y = -hop * 5.0
		lean = facing_sign * (0.09 + sin(_run_time) * 0.022)
		size = Vector2(1.015 - hop * 0.035, 0.975 + hop * 0.049)
		shadow_width = 1.0 - hop * 0.075
	var pose := Transform2D(lean, size * unit_scale, 0.0, shift)
	_pivot.transform = _blend_origin.interpolate_with(pose, _blend)
	_shadow.scale = _shadow.scale.lerp(Vector2(shadow_width, 1.0), 1.0 - exp(-delta * 16.0))
