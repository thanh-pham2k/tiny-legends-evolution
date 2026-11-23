extends Control

const WORLD_WIDTH: float = 2880.0
const DISTRICT_CENTERS := [480.0, 1420.0, 2340.0]

var _app: Control
var _gold_lbl: Label
var _gem_lbl: Label
var _ticket_lbl: Label
var _power_lbl: Label
var _idle_dot: ColorRect
var _treasury_badge: Control
var _settings_modal: Control
var _center_showcase: Control
var _center_hero: UnitVisual

var _world_clip: Control
var _far_layer: Control
var _mid_layer: Control
var _town_world: Control
var _ground_layer: Control
var _props_layer: Control
var _ambient_layer: CPUParticles2D

var _sky_tiles: Array[TextureRect] = []
var _mid_tiles: Array[TextureRect] = []
var _ground_tiles: Array = []
var _transition_tiles: Array[TextureRect] = []
var _world_items: Array = []
var _district_btns: Array[Button] = []

var _cam_x: float = 780.0
var _cam_target_x: float = 780.0
var _pointer_down: bool = false
var _drag_accum: float = 0.0
var _active_district: int = 1
var _last_hero_x: float = -1.0


func setup_screen(app: Control, _params: Dictionary = {}) -> void:
	_app = app


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	PlayerState.resources_changed.connect(_refresh_hud)
	PlayerState.roster_changed.connect(_refresh_hud)

	_build_town_layers()
	_build_center_hero_showcase()
	_build_top_left_commander()
	_build_top_right_resources()
	_build_right_edge_shortcuts()
	_build_district_nav_bar()

	resized.connect(_on_resized)
	_on_resized()
	_cam_x = _district_target_x(1)
	_cam_target_x = _cam_x
	_apply_camera_positions()
	_refresh_hud()


func _max_scroll() -> float:
	return maxf(0.0, WORLD_WIDTH - maxf(size.x, 720.0))


func _district_target_x(idx: int) -> float:
	var c: float = DISTRICT_CENTERS[clampi(idx, 0, DISTRICT_CENTERS.size() - 1)]
	return clampf(c - maxf(size.x, 720.0) * 0.5, 0.0, _max_scroll())


func _build_town_layers() -> void:
	_world_clip = Control.new()
	_world_clip.name = "TownViewportClip"
	_world_clip.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_world_clip.clip_contents = true
	_world_clip.mouse_filter = Control.MOUSE_FILTER_PASS
	add_child(_world_clip)

	_far_layer = Control.new()
	_far_layer.name = "ParallaxFar"
	_far_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_world_clip.add_child(_far_layer)

	var sky_tex: Texture2D = load("res://assets/sprites/town/town_bg_sky_far.png")
	for i in 2:
		var t := TextureRect.new()
		t.texture = sky_tex
		t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		t.flip_h = (i % 2 == 1)
		t.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_far_layer.add_child(t)
		_sky_tiles.append(t)

	_mid_layer = Control.new()
	_mid_layer.name = "ParallaxMid"
	_mid_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_world_clip.add_child(_mid_layer)

	var mid_tex: Texture2D = load("res://assets/sprites/town/town_bg_mid_horizon.png")
	for i in 3:
		var t := TextureRect.new()
		t.texture = mid_tex
		t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		t.stretch_mode = TextureRect.STRETCH_SCALE
		t.flip_h = (i % 2 == 1)
		t.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_mid_layer.add_child(t)
		_mid_tiles.append(t)

	_town_world = Control.new()
	_town_world.name = "TownWorld"
	_town_world.size = Vector2(WORLD_WIDTH, 720.0)
	_town_world.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_world_clip.add_child(_town_world)

	_ground_layer = Control.new()
	_ground_layer.name = "GroundLayer"
	_ground_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_town_world.add_child(_ground_layer)

	var ground_specs := [
		["res://assets/sprites/town/town_ground_sakura.png", 0.0, false],
		["res://assets/sprites/town/town_ground_sakura.png", 480.0, true],
		["res://assets/sprites/town/town_ground_plaza.png", 960.0, false],
		["res://assets/sprites/town/town_ground_plaza.png", 1440.0, true],
		["res://assets/sprites/town/town_ground_road.png", 1920.0, false],
		["res://assets/sprites/town/town_ground_road.png", 2400.0, true],
	]
	for gs in ground_specs:
		var gt := TextureRect.new()
		gt.texture = load(String(gs[0]))
		gt.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		gt.stretch_mode = TextureRect.STRETCH_SCALE
		gt.flip_h = bool(gs[2])
		gt.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_ground_layer.add_child(gt)
		_ground_tiles.append({"node": gt, "x": float(gs[1]), "w": 484.0})

	var trans_tex: Texture2D = load("res://assets/sprites/town/town_ground_transition.png")
	var fade_shader := Shader.new()
	fade_shader.code = """
shader_type canvas_item;
void fragment() {
	vec4 col = texture(TEXTURE, UV);
	float edge = smoothstep(0.0, 0.30, UV.x) * smoothstep(1.0, 0.70, UV.x);
	col.a *= edge;
	COLOR = col;
}
"""
	for tx in [820.0, 1780.0]:
		var tr := TextureRect.new()
		tr.texture = trans_tex
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tr.stretch_mode = TextureRect.STRETCH_SCALE
		var fmat := ShaderMaterial.new()
		fmat.shader = fade_shader
		tr.material = fmat
		tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_ground_layer.add_child(tr)
		_transition_tiles.append(tr)

	_props_layer = Control.new()
	_props_layer.name = "PropsAndBuildings"
	_props_layer.y_sort_enabled = true
	_props_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_town_world.add_child(_props_layer)

	# 4 Interactive Core Buildings + 2 Landmarks + Trees + Props + Living NPCs/Pets
	# --- WEST DISTRICT (Sakura & Summon) ---
	_add_scenic_sprite("res://assets/sprites/town/town_tree_sakura_large.png", 95.0, 0.42, 225.0)
	_add_scenic_sprite("res://assets/sprites/town/town_tree_sakura_weeping.png", 475.0, 0.25, 192.0)
	_add_scenic_sprite("res://assets/sprites/town/town_tree_sakura_large.png", 925.0, 0.34, 210.0, true)
	_add_interactive_building(
		"Summon Portal", "summon_bldg",
		"res://assets/sprites/town/town_building_summon.png",
		275.0, 0.46, 252.0,
		func() -> void: _app.navigate_to("summon"),
		true
	)
	_add_interactive_building(
		"Heroes Hall", "heroes_bldg",
		"res://assets/sprites/town/town_building_heroes.png",
		675.0, 0.44, 252.0,
		func() -> void: _app.navigate_to("heroes")
	)
	_add_scenic_sprite("res://assets/sprites/town/town_prop_lantern.png", 435.0, 0.56, 102.0)
	_add_scenic_sprite("res://assets/sprites/town/town_bush_bamboo.png", 125.0, 0.68, 128.0)
	_add_scenic_sprite("res://assets/sprites/town/town_bush_bamboo.png", 830.0, 0.64, 120.0, true)
	_add_animated_critter("res://assets/sprites/town/town_pet_fox.png", 485.0, 0.66, 94.0, 8.0, 1.9)

	# --- CENTRAL PLAZA (Hero Fountain & Lead Knight) ---
	_add_scenic_sprite("res://assets/sprites/town/town_prop_stairs.png", 1420.0, 0.20, 96.0)
	_add_scenic_sprite("res://assets/sprites/town/town_tree_sakura_large.png", 1045.0, 0.35, 205.0)
	_add_scenic_sprite("res://assets/sprites/town/town_landmark_fountain.png", 1420.0, 0.45, 245.0)
	_add_scenic_sprite("res://assets/sprites/town/town_prop_bench.png", 1155.0, 0.56, 104.0)
	_add_scenic_sprite("res://assets/sprites/town/town_prop_signpost.png", 1690.0, 0.57, 114.0)
	_add_scenic_sprite("res://assets/sprites/town/town_prop_lantern.png", 1775.0, 0.44, 98.0)
	_add_animated_critter("res://assets/sprites/town/town_pet_cat.png", 1265.0, 0.68, 82.0, 3.0, 2.4)

	# --- EAST DISTRICT (Battle Arena, Idle Treasury & Eastern Gate) ---
	_add_scenic_sprite("res://assets/sprites/town/town_tree_maple.png", 1905.0, 0.35, 212.0)
	_add_scenic_sprite("res://assets/sprites/town/town_tree_maple.png", 2610.0, 0.36, 198.0, true)
	_add_interactive_building(
		"Battle Arena", "arena_bldg",
		"res://assets/sprites/town/town_building_arena.png",
		2075.0, 0.46, 250.0,
		func() -> void: _app.navigate_to("campaign")
	)
	_treasury_badge = _add_interactive_building(
		"Idle Treasury", "treasury_bldg",
		"res://assets/sprites/town/town_building_treasury.png",
		2445.0, 0.47, 238.0,
		func() -> void: _app.open_idle_rewards(),
		false, true
	)
	_add_scenic_sprite("res://assets/sprites/town/town_landmark_gate.png", 2745.0, 0.38, 245.0)
	_add_scenic_sprite("res://assets/sprites/town/town_prop_stall.png", 2265.0, 0.60, 134.0)
	_add_animated_critter("res://assets/sprites/town/town_npc_merchant.png", 2188.0, 0.66, 114.0, 3.0, 2.2)
	_add_scenic_sprite("res://assets/sprites/town/town_prop_barrels.png", 2600.0, 0.68, 94.0)

	_ambient_layer = UiFx.create_ambient_particles("plains", WORLD_WIDTH)
	_ambient_layer.amount = 38
	_town_world.add_child(_ambient_layer)


func _add_scenic_sprite(tex_path: String, world_x: float, ground_t: float, target_h: float, flip_x: bool = false) -> TextureRect:
	var tex: Texture2D = load(tex_path)
	var tr := TextureRect.new()
	tr.texture = tex
	tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	tr.flip_h = flip_x
	tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var w: float = target_h * (float(tex.get_width()) / maxf(1.0, float(tex.get_height()))) if tex != null else target_h
	tr.size = Vector2(w, target_h)
	_props_layer.add_child(tr)
	_world_items.append({"node": tr, "x": world_x, "gt": ground_t, "w": w, "h": target_h})
	return tr


func _add_animated_critter(tex_path: String, world_x: float, ground_t: float, target_h: float, bob_px: float, period_s: float) -> TextureRect:
	var tr := _add_scenic_sprite(tex_path, world_x, ground_t, target_h)
	tr.pivot_offset = Vector2(tr.size.x * 0.5, tr.size.y)
	var tw := tr.create_tween().set_loops()
	tw.tween_property(tr, "scale", Vector2(1.02, 0.97), period_s * 0.5).set_trans(Tween.TRANS_SINE)
	tw.parallel().tween_property(tr, "rotation", 0.018 if bob_px < 5.0 else 0.0, period_s * 0.5)
	tw.tween_property(tr, "scale", Vector2(0.99, 1.02), period_s * 0.5).set_trans(Tween.TRANS_SINE)
	tw.parallel().tween_property(tr, "rotation", -0.018 if bob_px < 5.0 else 0.0, period_s * 0.5)
	return tr


func _add_interactive_building(
	label_text: String,
	node_name: String,
	tex_path: String,
	world_x: float,
	ground_t: float,
	target_h: float,
	on_click: Callable,
	portal_glow: bool = false,
	has_badge: bool = false
) -> Control:
	var tex: Texture2D = load(tex_path)
	var w: float = target_h * (float(tex.get_width()) / maxf(1.0, float(tex.get_height()))) if tex != null else target_h

	var holder := Control.new()
	holder.name = node_name
	holder.size = Vector2(w, target_h)
	holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_props_layer.add_child(holder)

	var btn := Button.new()
	btn.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	btn.flat = true
	btn.action_mode = BaseButton.ACTION_MODE_BUTTON_RELEASE
	btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	btn.mouse_filter = Control.MOUSE_FILTER_PASS
	btn.pivot_offset = Vector2(w * 0.5, target_h)
	btn.button_down.connect(func() -> void:
		var tw := btn.create_tween()
		tw.tween_property(btn, "scale", Vector2(0.96, 0.96), 0.06)
	)
	btn.button_up.connect(func() -> void:
		var tw := btn.create_tween()
		tw.tween_property(btn, "scale", Vector2.ONE, 0.14).set_trans(Tween.TRANS_BACK)
	)
	btn.pressed.connect(func() -> void:
		if _drag_accum > 14.0:
			return
		AudioManager.play_sfx("ui_click")
		on_click.call()
	)
	holder.add_child(btn)

	if portal_glow:
		var seal := TextureRect.new()
		seal.texture = load("res://assets/sprites/vfx/vfx_gacha_seal.png")
		seal.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		seal.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		seal.position = Vector2(w * 0.24, target_h * 0.22)
		seal.size = Vector2(w * 0.52, w * 0.52)
		seal.pivot_offset = seal.size * 0.5
		seal.modulate = Color(0.86, 0.72, 1.0, 0.62)
		seal.mouse_filter = Control.MOUSE_FILTER_IGNORE
		btn.add_child(seal)
		var stw := seal.create_tween().set_loops()
		stw.tween_property(seal, "rotation", TAU, 16.0)

	var b_img := TextureRect.new()
	b_img.texture = tex
	b_img.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	b_img.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	b_img.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	b_img.mouse_filter = Control.MOUSE_FILTER_IGNORE
	btn.add_child(b_img)

	# Floating blue diamond interaction pin above roof
	var pin := TextureRect.new()
	pin.texture = load("res://assets/sprites/ui/ui_town_interact_pin.png")
	pin.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	pin.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	pin.position = Vector2(w * 0.5 - 16.0, -34.0)
	pin.size = Vector2(32.0, 44.0)
	pin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	holder.add_child(pin)
	var ptw := pin.create_tween().set_loops()
	ptw.tween_property(pin, "position:y", -42.0, 0.9).set_trans(Tween.TRANS_SINE)
	ptw.tween_property(pin, "position:y", -32.0, 0.9).set_trans(Tween.TRANS_SINE)

	# Ornate building nameplate banner at base
	var plate := TextureRect.new()
	plate.texture = load("res://assets/sprites/ui/ui_town_nameplate.png")
	plate.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	plate.stretch_mode = TextureRect.STRETCH_SCALE
	plate.position = Vector2(w * 0.5 - 86.0, target_h - 14.0)
	plate.size = Vector2(172.0, 46.0)
	plate.mouse_filter = Control.MOUSE_FILTER_IGNORE
	holder.add_child(plate)

	var lbl := Label.new()
	lbl.text = label_text
	lbl.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	lbl.offset_top = 4
	lbl.offset_bottom = -2
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	lbl.add_theme_font_size_override("font_size", 14)
	lbl.add_theme_color_override("font_color", Color(1.0, 0.94, 0.76))
	lbl.add_theme_color_override("font_outline_color", Color(0.14, 0.06, 0.02))
	lbl.add_theme_constant_override("outline_size", 4)
	lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	plate.add_child(lbl)

	var badge: Control = null
	if has_badge:
		badge = Panel.new()
		badge.position = Vector2(w * 0.72, target_h * 0.12)
		badge.size = Vector2(18, 18)
		badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
		badge.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(1.0, 0.22, 0.26), Color(1.0, 0.92, 0.65), 9, 2))
		holder.add_child(badge)

	_world_items.append({"node": holder, "x": world_x, "gt": ground_t, "w": w, "h": target_h})
	return badge


func _build_center_hero_showcase() -> void:
	# Preserve exact node path CenterShowcase/LobbyLeadHero for tests while tracking Central Plaza scroll!
	_center_showcase = Control.new()
	_center_showcase.name = "CenterShowcase"
	_center_showcase.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_center_showcase)

	_center_hero = UnitVisual.new()
	_center_hero.name = "LobbyLeadHero"
	_center_hero.facing_sign = 1.0
	_center_hero.unit_scale = 1.68
	_center_hero.idle_speed_scale = 0.88
	_center_hero.position = Vector2.ZERO
	_center_showcase.add_child(_center_hero)
	_sync_center_hero()


func _sync_center_hero() -> void:
	if _center_hero == null:
		return
	var evo := String(PlayerState.get_hero_record("knight").get("evo", "basic"))
	_center_hero.configure_animations(GameData.get_hero_anim_map("knight", evo))
	_center_hero.set_aura(Color(1.0, 0.36, 0.14), evo == "fire")
	if evo == "holy":
		_center_hero.set_aura(Color(1.0, 0.88, 0.32), true)


func _on_resized() -> void:
	if not is_instance_valid(_world_clip):
		return
	var view_w: float = maxf(size.x, 720.0)
	var view_h: float = maxf(size.y, 720.0)
	var horizon_y: float = floorf(view_h * 0.43)
	var ground_h: float = view_h - horizon_y

	_town_world.size = Vector2(WORLD_WIDTH, view_h)

	# Far Sky Parallax
	var sky_h: float = horizon_y + 110.0
	var sky_w: float = maxf(1440.0, sky_h * (1440.0 / 810.0))
	_far_layer.size = Vector2(sky_w * 2.0, sky_h)
	for i in _sky_tiles.size():
		_sky_tiles[i].position = Vector2(float(i) * sky_w, 0.0)
		_sky_tiles[i].size = Vector2(sky_w + 4.0, sky_h)

	# Midground Horizon Parallax (flush at horizon_y + 24)
	var mid_h: float = clampf(view_h * 0.31, 210.0, 310.0)
	var mid_w: float = mid_h * (1600.0 / 335.0)
	_mid_layer.size = Vector2(mid_w * 3.0, horizon_y + 28.0)
	for i in _mid_tiles.size():
		_mid_tiles[i].position = Vector2(float(i) * mid_w, horizon_y + 24.0 - mid_h)
		_mid_tiles[i].size = Vector2(mid_w + 4.0, mid_h)

	# Ground Tiles & Transition Strips
	_ground_layer.position = Vector2(0.0, horizon_y)
	_ground_layer.size = Vector2(WORLD_WIDTH, ground_h)
	for spec in _ground_tiles:
		var gt: TextureRect = spec["node"]
		gt.position = Vector2(float(spec["x"]) - 2.0, 0.0)
		gt.size = Vector2(float(spec["w"]), ground_h + 4.0)
	for idx in _transition_tiles.size():
		var tr_x: float = 820.0 if idx == 0 else 1780.0
		_transition_tiles[idx].position = Vector2(tr_x, 0.0)
		_transition_tiles[idx].size = Vector2(280.0, ground_h + 4.0)

	# Props, Trees, Buildings & Landmarks (Y-sorted by ground contact foot_y)
	var scale_f: float = clampf(ground_h / 410.0, 0.90, 1.35)
	for item in _world_items:
		var node: Control = item["node"]
		var w: float = float(item["w"]) * scale_f
		var h: float = float(item["h"]) * scale_f
		var foot_y: float = horizon_y + float(item["gt"]) * ground_h
		node.position = Vector2(float(item["x"]) - w * 0.5, foot_y - h)
		node.size = Vector2(w, h)
		node.z_index = int(foot_y)

	_cam_target_x = clampf(_cam_target_x, 0.0, _max_scroll())
	_cam_x = clampf(_cam_x, 0.0, _max_scroll())
	_apply_camera_positions()


func _apply_camera_positions() -> void:
	if not is_instance_valid(_town_world):
		return
	var view_h: float = maxf(size.y, 720.0)
	var horizon_y: float = floorf(view_h * 0.43)
	var ground_h: float = view_h - horizon_y

	_far_layer.position = Vector2(-_cam_x * 0.18, 0.0)
	_mid_layer.position = Vector2(-_cam_x * 0.45, 0.0)
	_town_world.position = Vector2(-_cam_x, 0.0)

	if is_instance_valid(_center_showcase):
		var hero_world_x: float = 1420.0
		var hero_foot_y: float = horizon_y + 0.68 * ground_h
		_center_showcase.position = Vector2(hero_world_x - _cam_x, hero_foot_y)
		_center_showcase.z_index = int(hero_foot_y) + 10
		_last_hero_x = hero_world_x - _cam_x

	# Highlight nearest district tab
	var screen_center_world: float = _cam_x + maxf(size.x, 720.0) * 0.5
	var nearest: int = 1
	var best_dist: float = 1e9
	for i in DISTRICT_CENTERS.size():
		var d: float = absf(screen_center_world - float(DISTRICT_CENTERS[i]))
		if d < best_dist:
			best_dist = d
			nearest = i
	if nearest != _active_district:
		_active_district = nearest
		_refresh_district_tabs()


func _process(delta: float) -> void:
	if absf(_cam_x - _cam_target_x) > 0.35:
		_cam_x = lerpf(_cam_x, _cam_target_x, 1.0 - exp(-delta * 10.0))
		_apply_camera_positions()
	elif not is_equal_approx(_cam_x, _cam_target_x):
		_cam_x = _cam_target_x
		_apply_camera_positions()


func _input(event: InputEvent) -> void:
	if _settings_modal != null and is_instance_valid(_settings_modal):
		return
	var app_pop: Node = _app.get_node_or_null("PopupHost") if _app != null else null
	if app_pop != null and app_pop.get_child_count() > 0:
		return

	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_LEFT:
			if mb.pressed:
				_pointer_down = true
				_drag_accum = 0.0
			else:
				_pointer_down = false
	elif event is InputEventMouseMotion and _pointer_down:
		var mm := event as InputEventMouseMotion
		_cam_target_x = clampf(_cam_target_x - mm.relative.x, 0.0, _max_scroll())
		_drag_accum += absf(mm.relative.x)
	elif event is InputEventScreenTouch:
		var st := event as InputEventScreenTouch
		if st.pressed:
			_pointer_down = true
			_drag_accum = 0.0
		else:
			_pointer_down = false
	elif event is InputEventScreenDrag:
		var sd := event as InputEventScreenDrag
		_cam_target_x = clampf(_cam_target_x - sd.relative.x, 0.0, _max_scroll())
		_drag_accum += absf(sd.relative.x)


func _build_district_nav_bar() -> void:
	var bar := PanelContainer.new()
	bar.name = "BottomDistrictBar"
	bar.z_index = 2000
	bar.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	bar.offset_left = 140.0
	bar.offset_right = -140.0
	bar.offset_top = -66.0
	bar.offset_bottom = -10.0
	bar.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	add_child(bar)

	var hb := HBoxContainer.new()
	hb.alignment = BoxContainer.ALIGNMENT_CENTER
	hb.add_theme_constant_override("separation", 10)
	bar.add_child(hb)

	var arrow_tex: Texture2D = load("res://assets/sprites/ui/ui_town_arrow_right.png")
	var left_btn := _make_arrow_btn(arrow_tex, true, func() -> void:
		_cam_target_x = clampf(_cam_target_x - 680.0, 0.0, _max_scroll())
	)
	hb.add_child(left_btn)

	var tab_tex: Texture2D = load("res://assets/sprites/ui/ui_town_district_tab.png")
	var tab_labels := ["West · Sakura", "Central · Plaza", "East · Arena"]
	for i in tab_labels.size():
		var idx: int = i
		var tbtn := Button.new()
		tbtn.custom_minimum_size = Vector2(156, 48)
		tbtn.text = tab_labels[i]
		tbtn.add_theme_font_size_override("font_size", 14)
		tbtn.add_theme_color_override("font_color", Color(1.0, 0.95, 0.80))
		tbtn.add_theme_color_override("font_outline_color", Color(0.08, 0.05, 0.14))
		tbtn.add_theme_constant_override("outline_size", 4)
		var sb := StyleBoxTexture.new()
		sb.texture = tab_tex
		sb.texture_margin_left = 36
		sb.texture_margin_right = 36
		sb.texture_margin_top = 14
		sb.texture_margin_bottom = 14
		tbtn.add_theme_stylebox_override("normal", sb)
		var sb_h := sb.duplicate()
		sb_h.modulate_color = Color(1.12, 1.10, 1.04)
		tbtn.add_theme_stylebox_override("hover", sb_h)
		tbtn.add_theme_stylebox_override("pressed", sb)
		tbtn.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
		UiFx.attach_press_bounce(tbtn)
		tbtn.pressed.connect(func() -> void:
			_cam_target_x = _district_target_x(idx)
		)
		hb.add_child(tbtn)
		_district_btns.append(tbtn)

	var right_btn := _make_arrow_btn(arrow_tex, false, func() -> void:
		_cam_target_x = clampf(_cam_target_x + 680.0, 0.0, _max_scroll())
	)
	hb.add_child(right_btn)
	_refresh_district_tabs()


func _make_arrow_btn(tex: Texture2D, flip_left: bool, cb: Callable) -> Button:
	var btn := Button.new()
	btn.custom_minimum_size = Vector2(50, 44)
	btn.flat = true
	btn.pressed.connect(cb)
	UiFx.attach_press_bounce(btn)
	var ic := TextureRect.new()
	ic.texture = tex
	ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	ic.flip_h = flip_left
	ic.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
	btn.add_child(ic)
	return btn


func _refresh_district_tabs() -> void:
	for i in _district_btns.size():
		if is_instance_valid(_district_btns[i]):
			_district_btns[i].modulate = Color(1.18, 1.12, 1.0) if i == _active_district else Color(0.74, 0.78, 0.90, 0.88)


func _build_top_left_commander() -> void:
	var card := PanelContainer.new()
	card.name = "TopLeftCommander"
	card.z_index = 2000
	card.set_anchors_preset(Control.PRESET_TOP_LEFT)
	card.offset_left = 14.0
	card.offset_top = 14.0
	card.offset_right = 278.0
	card.offset_bottom = 104.0
	card.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.09, 0.08, 0.17, 0.90), Color(0.95, 0.78, 0.34), 18, 2))
	add_child(card)

	var hb := HBoxContainer.new()
	hb.add_theme_constant_override("separation", 10)
	card.add_child(hb)

	var av_wrap := Control.new()
	av_wrap.name = "AvatarWrap"
	av_wrap.custom_minimum_size = Vector2(76, 76)
	hb.add_child(av_wrap)

	# Frame FIRST, Portrait ON TOP inside circular opening!
	var frame := TextureRect.new()
	frame.name = "AvatarFrame"
	frame.texture = load("res://assets/sprites/ui/ui_avatar_frame.png")
	frame.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	frame.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	frame.size = Vector2(76, 76)
	av_wrap.add_child(frame)

	var port := TextureRect.new()
	port.name = "AvatarPortrait"
	port.texture = load(GameData.get_hero_portrait_path("knight", String(PlayerState.get_hero_record("knight").get("evo", "basic"))))
	port.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	port.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	port.position = Vector2(14, 14)
	port.size = Vector2(48, 48)
	av_wrap.add_child(port)

	var vb := VBoxContainer.new()
	vb.alignment = BoxContainer.ALIGNMENT_CENTER
	vb.add_theme_constant_override("separation", 2)
	hb.add_child(vb)

	var cname := Label.new()
	cname.text = "Commander"
	cname.add_theme_font_size_override("font_size", 18)
	cname.add_theme_color_override("font_color", Color(1.0, 0.92, 0.62))
	vb.add_child(cname)

	_power_lbl = Label.new()
	_power_lbl.add_theme_font_size_override("font_size", 15)
	_power_lbl.add_theme_color_override("font_color", Color(0.75, 0.93, 1.0))
	vb.add_child(_power_lbl)


func _build_top_right_resources() -> void:
	var res_box := VBoxContainer.new()
	res_box.name = "TopRightResources"
	res_box.z_index = 2000
	res_box.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	res_box.offset_left = -286.0
	res_box.offset_top = 14.0
	res_box.offset_right = -14.0
	res_box.offset_bottom = 112.0
	res_box.add_theme_constant_override("separation", 8)
	add_child(res_box)

	var row1 := HBoxContainer.new()
	row1.alignment = BoxContainer.ALIGNMENT_END
	row1.add_theme_constant_override("separation", 8)
	res_box.add_child(row1)

	_gold_lbl = _make_res_pill(row1, "res://assets/sprites/items/item_gold_coin.png", Color(1.0, 0.88, 0.42))
	_gem_lbl = _make_res_pill(row1, "res://assets/sprites/items/item_purple_gem.png", Color(0.88, 0.72, 1.0))

	var row2 := HBoxContainer.new()
	row2.alignment = BoxContainer.ALIGNMENT_END
	res_box.add_child(row2)

	_ticket_lbl = _make_res_pill(row2, "res://assets/sprites/items/item_summon_ticket.png", Color(0.68, 0.96, 1.0))


func _make_res_pill(parent: HBoxContainer, icon_path: String, text_col: Color) -> Label:
	var pc := PanelContainer.new()
	pc.custom_minimum_size = Vector2(128, 42)
	pc.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.08, 0.08, 0.15, 0.90), Color(0.78, 0.64, 0.34), 14, 2))
	parent.add_child(pc)

	var hb := HBoxContainer.new()
	hb.alignment = BoxContainer.ALIGNMENT_CENTER
	hb.add_theme_constant_override("separation", 6)
	pc.add_child(hb)

	var ic := TextureRect.new()
	ic.texture = load(icon_path)
	ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	ic.custom_minimum_size = Vector2(26, 26)
	hb.add_child(ic)

	var lbl := Label.new()
	lbl.add_theme_font_size_override("font_size", 15)
	lbl.add_theme_color_override("font_color", text_col)
	hb.add_child(lbl)
	return lbl


func _build_right_edge_shortcuts() -> void:
	var rail := PanelContainer.new()
	rail.name = "RightEdgeShortcuts"
	rail.z_index = 2000
	rail.set_anchors_preset(Control.PRESET_CENTER_RIGHT)
	rail.offset_left = -112.0
	rail.offset_top = -170.0
	rail.offset_right = -14.0
	rail.offset_bottom = 265.0
	rail.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.09, 0.08, 0.17, 0.84), Color(0.92, 0.74, 0.34), 20, 2))
	add_child(rail)

	var vb := VBoxContainer.new()
	vb.alignment = BoxContainer.ALIGNMENT_CENTER
	vb.add_theme_constant_override("separation", 6)
	rail.add_child(vb)

	_make_shortcut_btn(vb, "res://assets/sprites/ui/ui_nav_heroes.png", "Heroes", func() -> void: _app.navigate_to("heroes"))
	_make_shortcut_btn(vb, "res://assets/sprites/ui/ui_nav_summon.png", "Summon", func() -> void: _app.navigate_to("summon"))
	_make_shortcut_btn(vb, "res://assets/sprites/ui/ui_nav_campaign.png", "Battle", func() -> void: _app.navigate_to("campaign"))
	var idle_btn := _make_shortcut_btn(vb, "res://assets/sprites/ui/ui_icon_idle_chest.png", "Idle", func() -> void: _app.open_idle_rewards())
	_idle_dot = ColorRect.new()
	_idle_dot.color = Color(1.0, 0.24, 0.28)
	_idle_dot.position = Vector2(62, 2)
	_idle_dot.size = Vector2(12, 12)
	idle_btn.add_child(_idle_dot)
	_make_shortcut_btn(vb, "res://assets/sprites/ui/ui_icon_settings.png", "Settings", _open_settings)


func _make_shortcut_btn(parent: VBoxContainer, icon_path: String, cap: String, cb: Callable) -> Button:
	var btn := Button.new()
	btn.custom_minimum_size = Vector2(84, 78)
	btn.flat = true
	btn.pressed.connect(cb)
	UiFx.attach_press_bounce(btn)
	parent.add_child(btn)

	var ic := TextureRect.new()
	ic.texture = load(icon_path)
	ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	ic.position = Vector2(14, 2)
	ic.size = Vector2(56, 56)
	ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
	btn.add_child(ic)

	var l := Label.new()
	l.text = cap
	l.position = Vector2(0, 58)
	l.size = Vector2(84, 20)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.add_theme_font_size_override("font_size", 13)
	l.add_theme_color_override("font_color", Color(1.0, 0.94, 0.72))
	l.add_theme_color_override("font_outline_color", Color(0.06, 0.05, 0.12))
	l.add_theme_constant_override("outline_size", 4)
	btn.add_child(l)
	return btn


func _open_settings() -> void:
	if _settings_modal != null and is_instance_valid(_settings_modal):
		_settings_modal.queue_free()

	_settings_modal = Control.new()
	_settings_modal.z_index = 2500
	_settings_modal.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(_settings_modal)

	var dim := ColorRect.new()
	dim.color = Color(0.02, 0.02, 0.06, 0.72)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_settings_modal.add_child(dim)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_settings_modal.add_child(center)

	var pc := PanelContainer.new()
	pc.custom_minimum_size = Vector2(480, 380)
	pc.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.12, 0.11, 0.20, 0.98), Color(1.0, 0.82, 0.36), 22, 3))
	center.add_child(pc)

	var vb := VBoxContainer.new()
	vb.alignment = BoxContainer.ALIGNMENT_CENTER
	vb.add_theme_constant_override("separation", 20)
	pc.add_child(vb)

	var h := Label.new()
	h.text = "SETTINGS (ANDROID)"
	h.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	h.add_theme_font_size_override("font_size", 26)
	h.add_theme_color_override("font_color", Color(1.0, 0.88, 0.42))
	vb.add_child(h)

	var fps_btn := UiFx.make_styled_button("Target FPS: %d FPS" % PlayerState.fps_cap, Color(0.20, 0.46, 0.74), Vector2(340, 66), 20)
	fps_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	fps_btn.pressed.connect(func() -> void:
		var next_fps := 30 if PlayerState.fps_cap == 60 else 60
		PlayerState.set_fps_cap(next_fps)
		fps_btn.text = "Target FPS: %d FPS%s" % [next_fps, " (Battery Saver)" if next_fps == 30 else " (Smooth)"]
	)
	vb.add_child(fps_btn)

	var mute_btn := UiFx.make_styled_button("Sound FX: %s" % ("MUTED" if AudioManager.muted else "ON"), Color(0.32, 0.42, 0.32), Vector2(340, 66), 20)
	mute_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	mute_btn.pressed.connect(func() -> void:
		AudioManager.set_muted(not AudioManager.muted)
		mute_btn.text = "Sound FX: %s" % ("MUTED" if AudioManager.muted else "ON")
	)
	vb.add_child(mute_btn)

	var close_btn := UiFx.make_styled_button("CLOSE", Color(0.46, 0.24, 0.28), Vector2(220, 60), 20)
	close_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	close_btn.pressed.connect(func() -> void:
		_settings_modal.queue_free()
	)
	vb.add_child(close_btn)


func _fmt_num(val: int) -> String:
	var s := str(val)
	var out := ""
	var cnt := 0
	for i in range(s.length() - 1, -1, -1):
		if cnt > 0 and cnt % 3 == 0:
			out = "," + out
		out = s[i] + out
		cnt += 1
	return out


func _refresh_hud() -> void:
	if not is_instance_valid(_gold_lbl):
		return
	_gold_lbl.text = _fmt_num(PlayerState.gold)
	_gem_lbl.text = _fmt_num(PlayerState.gems)
	_ticket_lbl.text = _fmt_num(PlayerState.tickets)
	_power_lbl.text = "Power: %s" % _fmt_num(PlayerState.get_team_power())
	_sync_center_hero()
	var pend := PlayerState.get_pending_idle_rewards()
	var has_rew: bool = int(pend["gold"]) >= 50
	if _idle_dot != null:
		_idle_dot.visible = has_rew
	if is_instance_valid(_treasury_badge):
		_treasury_badge.visible = has_rew
