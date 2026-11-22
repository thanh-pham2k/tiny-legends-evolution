class_name UnitVisual
extends Node2D

signal impact_hit(is_skill: bool)
signal state_changed(state_name: String)

@export var facing_sign: float = 1.0
@export var unit_scale: float = 2.2
@export var juice_enabled: bool = true

var current_state: String = "idle"
var is_dead: bool = false

var _anims: Dictionary = {}
var _frame_timer: float = 0.0
var _frame_index: int = 0
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
		_pivot.position = Vector2.ZERO
		_pivot.rotation = 0.0
		_pivot.scale = Vector2(unit_scale, unit_scale)
		_shadow.scale = Vector2.ONE
		_dust_particles.emitting = false


func _apply_anim_texture(anim_key: String) -> Dictionary:
	var fallback_key := anim_key
	if not _anims.has(fallback_key):
		fallback_key = "idle" if _anims.has("idle") else _anims.keys()[0]
	var cfg: Dictionary = _anims[fallback_key]
	_sprite.texture = cfg.get("texture", null)
	_sprite.hframes = int(cfg.get("hframes", 1))
	_sprite.vframes = int(cfg.get("vframes", 1))
	if _sprite.texture != null:
		var cell_h: float = float(_sprite.texture.get_height()) / float(maxi(1, _sprite.vframes))
		var margin_b: float = 14.0 if cell_h >= 256.0 else (12.0 if cell_h >= 192.0 else 6.0)
		_sprite.offset = Vector2(0.0, -(cell_h * 0.5 - margin_b))
	_frame_index = 0
	_frame_timer = 0.0
	_sprite.frame = 0
	return cfg


func _kill_active_tween() -> void:
	if _active_tween != null and _active_tween.is_valid():
		_active_tween.kill()
	_active_tween = null


func play_idle() -> void:
	_ensure_nodes()
	if is_dead:
		return
	_kill_active_tween()
	current_state = "idle"
	_apply_anim_texture("idle")
	_dust_particles.emitting = false
	_pivot.position = Vector2.ZERO
	_pivot.rotation = 0.0
	_pivot.scale = Vector2(unit_scale, unit_scale)
	_sprite.modulate = Color.WHITE
	_shadow.scale = Vector2.ONE
	state_changed.emit("idle")


func play_run() -> void:
	_ensure_nodes()
	if is_dead:
		return
	_kill_active_tween()
	current_state = "run"
	_apply_anim_texture("run")
	_dust_particles.emitting = juice_enabled
	_pivot.position = Vector2.ZERO
	_pivot.rotation = 0.0
	_pivot.scale = Vector2(unit_scale, unit_scale)
	state_changed.emit("run")


func play_attack(target_global_x: float) -> void:
	_ensure_nodes()
	if is_dead:
		return
	_kill_active_tween()
	current_state = "attack"
	_apply_anim_texture("attack")
	_dust_particles.emitting = false
	state_changed.emit("attack")

	var lunge_dx: float = (target_global_x - global_position.x) - facing_sign * 115.0
	lunge_dx = clampf(lunge_dx, -260.0, 260.0)

	_active_tween = create_tween()
	if juice_enabled:
		_active_tween.tween_property(_pivot, "position", Vector2(-facing_sign * 18.0, 0.0), 0.07).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		_active_tween.parallel().tween_property(_pivot, "scale", Vector2(unit_scale * 1.10, unit_scale * 0.90), 0.07)
		_active_tween.parallel().tween_property(_pivot, "rotation", -facing_sign * 0.08, 0.07)

		_active_tween.tween_property(_pivot, "position", Vector2(lunge_dx, -10.0), 0.11).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		_active_tween.parallel().tween_property(_pivot, "scale", Vector2(unit_scale * 1.16, unit_scale * 0.88), 0.11)
		_active_tween.parallel().tween_property(_pivot, "rotation", facing_sign * 0.14, 0.11)

		_active_tween.tween_callback(func() -> void:
			_emit_burst(Color(1.0, 0.92, 0.55, 0.95), lunge_dx)
			impact_hit.emit(false)
		)
		_active_tween.tween_property(_pivot, "position", Vector2(lunge_dx, 0.0), 0.09)
		_active_tween.parallel().tween_property(_pivot, "scale", Vector2(unit_scale, unit_scale), 0.09)

		_active_tween.tween_property(_pivot, "position", Vector2.ZERO, 0.18).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
		_active_tween.parallel().tween_property(_pivot, "rotation", 0.0, 0.18)
	else:
		_active_tween.tween_interval(0.18)
		_active_tween.tween_callback(func() -> void:
			impact_hit.emit(false)
		)
		_active_tween.tween_interval(0.25)

	_active_tween.tween_callback(func() -> void:
		if not is_dead and current_state == "attack":
			play_idle()
	)


func play_skill(target_global_x: float) -> void:
	_ensure_nodes()
	if is_dead:
		return
	_kill_active_tween()
	current_state = "skill"
	_apply_anim_texture("skill")
	_dust_particles.emitting = false
	state_changed.emit("skill")

	var lunge_dx: float = (target_global_x - global_position.x) - facing_sign * 130.0
	lunge_dx = clampf(lunge_dx, -260.0, 260.0)

	_active_tween = create_tween()
	if juice_enabled:
		# Jump & cyan-gold charge
		_active_tween.tween_property(_pivot, "position", Vector2(-facing_sign * 20.0, -44.0), 0.16).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		_active_tween.parallel().tween_property(_pivot, "scale", Vector2(unit_scale * 0.92, unit_scale * 1.14), 0.16)
		_active_tween.parallel().tween_property(_sprite, "modulate", Color(0.82, 1.0, 1.18, 1.0), 0.16)

		# Heavy cleave forward
		_active_tween.tween_property(_pivot, "position", Vector2(lunge_dx, 0.0), 0.12).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
		_active_tween.parallel().tween_property(_pivot, "scale", Vector2(unit_scale * 1.22, unit_scale * 0.84), 0.12)
		_active_tween.parallel().tween_property(_pivot, "rotation", facing_sign * 0.16, 0.12)

		_active_tween.tween_callback(func() -> void:
			_emit_burst(Color(0.32, 0.90, 1.0, 1.0), lunge_dx)
			_spawn_skill_wave(lunge_dx)
			impact_hit.emit(true)
		)
		_active_tween.tween_property(_pivot, "scale", Vector2(unit_scale, unit_scale), 0.12)
		_active_tween.parallel().tween_property(_sprite, "modulate", Color.WHITE, 0.12)

		_active_tween.tween_property(_pivot, "position", Vector2.ZERO, 0.22).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
		_active_tween.parallel().tween_property(_pivot, "rotation", 0.0, 0.22)
	else:
		_active_tween.tween_interval(0.24)
		_active_tween.tween_callback(func() -> void:
			impact_hit.emit(true)
		)
		_active_tween.tween_interval(0.32)

	_active_tween.tween_callback(func() -> void:
		if not is_dead and current_state == "skill":
			play_idle()
	)


func play_hit(heavy: bool = false) -> void:
	_ensure_nodes()
	if is_dead:
		return
	_kill_active_tween()
	current_state = "hit"
	if _anims.has("hit"):
		_apply_anim_texture("hit")
	_dust_particles.emitting = false
	state_changed.emit("hit")

	if _shader_mat != null:
		if _flash_tween != null and _flash_tween.is_valid():
			_flash_tween.kill()
		_shader_mat.set_shader_parameter("flash_amount", 1.0)
		_flash_tween = create_tween()
		_flash_tween.tween_method(
			func(v: float) -> void: _shader_mat.set_shader_parameter("flash_amount", v),
			1.0, 0.0, 0.14 if heavy else 0.10
		)

	var kb_dist: float = -facing_sign * (36.0 if heavy else 20.0)
	_active_tween = create_tween()
	if juice_enabled:
		_active_tween.tween_property(_pivot, "position", Vector2(kb_dist, -8.0 if heavy else -4.0), 0.07).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		_active_tween.parallel().tween_property(_pivot, "scale", Vector2(unit_scale * 0.86, unit_scale * 1.12), 0.07)
		_active_tween.parallel().tween_property(_pivot, "rotation", -facing_sign * 0.16, 0.07)

		_active_tween.tween_property(_pivot, "position", Vector2.ZERO, 0.16).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		_active_tween.parallel().tween_property(_pivot, "scale", Vector2(unit_scale, unit_scale), 0.16)
		_active_tween.parallel().tween_property(_pivot, "rotation", 0.0, 0.16)
	else:
		_active_tween.tween_interval(0.22)

	_active_tween.tween_callback(func() -> void:
		if not is_dead and current_state == "hit":
			play_idle()
	)


func play_death() -> void:
	_ensure_nodes()
	if is_dead:
		return
	is_dead = true
	_kill_active_tween()
	current_state = "death"
	_dust_particles.emitting = false
	state_changed.emit("death")

	if _anims.has("death"):
		_apply_anim_texture("death")

	_emit_burst(Color(0.85, 0.85, 0.90, 0.75), 0.0)
	_active_tween = create_tween()
	_active_tween.tween_property(_pivot, "rotation", -facing_sign * 1.48, 0.28).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	_active_tween.parallel().tween_property(_pivot, "position", Vector2(-facing_sign * 28.0, 12.0), 0.28)
	_active_tween.parallel().tween_property(_sprite, "modulate:a", 0.35, 0.45)
	_active_tween.parallel().tween_property(_shadow, "scale", Vector2(1.25, 0.75), 0.28)


func respawn() -> void:
	is_dead = false
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


func _spawn_skill_wave(x_offset: float) -> void:
	var wave := Polygon2D.new()
	wave.polygon = PackedVector2Array([
		Vector2(-18, -76),
		Vector2(28, -42),
		Vector2(42, 0),
		Vector2(28, 42),
		Vector2(-18, 76),
		Vector2(6, 26),
		Vector2(14, 0),
		Vector2(6, -26),
	])
	wave.color = Color(0.28, 0.92, 1.0, 0.92)
	wave.position = Vector2(x_offset + facing_sign * 50.0, -68.0)
	wave.scale = Vector2(facing_sign * 1.1, 1.1)
	add_child(wave)

	var wt := create_tween()
	wt.tween_property(wave, "position:x", wave.position.x + facing_sign * 170.0, 0.24).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	wt.parallel().tween_property(wave, "scale", Vector2(facing_sign * 1.8, 1.65), 0.24)
	wt.parallel().tween_property(wave, "modulate:a", 0.0, 0.24)
	wt.tween_callback(wave.queue_free)


func _process(delta: float) -> void:
	if _sprite == null or _anims.is_empty():
		return

	# Advance Sprite Sheet frames
	var anim_key := current_state if _anims.has(current_state) else "idle"
	if _anims.has(anim_key):
		var cfg: Dictionary = _anims[anim_key]
		var total_frames := int(cfg.get("frames", _sprite.hframes * _sprite.vframes))
		var fps := float(cfg.get("fps", 8.0))
		var loop := bool(cfg.get("loop", true))
		_frame_timer += delta
		var step := 1.0 / maxf(1.0, fps)
		while _frame_timer >= step:
			_frame_timer -= step
			if _frame_index + 1 < total_frames:
				_frame_index += 1
			elif loop:
				_frame_index = 0
			_sprite.frame = _frame_index

	# Apply continuous 60 FPS procedural juice on Idle & Run
	if not juice_enabled or is_dead:
		return

	if current_state == "idle":
		_idle_time += delta * 4.2
		var breath := sin(_idle_time) * 0.032
		_pivot.scale = Vector2(unit_scale * (1.0 - breath * 0.55), unit_scale * (1.0 + breath))
		_pivot.position = Vector2.ZERO
		_pivot.rotation = sin(_idle_time * 0.5) * 0.015
		_shadow.scale = Vector2(1.0 - breath * 0.4, 1.0)
	elif current_state == "run":
		_run_time += delta * 14.0
		var hop := absf(sin(_run_time)) * -14.0
		_pivot.position = Vector2(0.0, hop)
		_pivot.rotation = facing_sign * (0.09 + sin(_run_time) * 0.04)
		var stretch := (hop / -14.0) * 0.06
		_pivot.scale = Vector2(unit_scale * (1.0 - stretch * 0.5), unit_scale * (1.0 + stretch))
		_shadow.scale = Vector2(1.0 + hop * 0.014, 1.0 + hop * 0.01)
