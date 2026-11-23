class_name UiFx
extends RefCounted


static func make_panel_style(bg_col: Color, border_col: Color = Color(0.92, 0.76, 0.36, 0.9), radius: int = 16, border_w: int = 2) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = bg_col
	sb.border_color = border_col
	sb.set_border_width_all(border_w)
	sb.set_corner_radius_all(radius)
	return sb


static func make_styled_button(text: String, bg_col: Color, min_size: Vector2 = Vector2(180, 56), font_size: int = 20) -> Button:
	var btn := Button.new()
	btn.text = text
	btn.custom_minimum_size = min_size
	btn.add_theme_font_size_override("font_size", font_size)
	btn.add_theme_color_override("font_color", Color(1.0, 0.98, 0.92))
	var sb := make_panel_style(bg_col, Color(1.0, 0.86, 0.48, 0.9), 14, 2)
	btn.add_theme_stylebox_override("normal", sb)
	var sb_hover := sb.duplicate()
	sb_hover.bg_color = bg_col.lightened(0.14)
	btn.add_theme_stylebox_override("hover", sb_hover)
	var sb_press := sb.duplicate()
	sb_press.bg_color = bg_col.darkened(0.15)
	btn.add_theme_stylebox_override("pressed", sb_press)
	attach_press_bounce(btn)
	return btn


static func attach_press_bounce(btn: BaseButton) -> void:
	btn.resized.connect(func() -> void:
		btn.pivot_offset = btn.size * 0.5
	)
	btn.button_down.connect(func() -> void:
		btn.pivot_offset = btn.size * 0.5
		var t := btn.create_tween()
		t.tween_property(btn, "scale", Vector2(0.93, 0.93), 0.06).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	)
	btn.button_up.connect(func() -> void:
		var t := btn.create_tween()
		t.tween_property(btn, "scale", Vector2.ONE, 0.14).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	)
	btn.pressed.connect(func() -> void:
		var tree := Engine.get_main_loop() as SceneTree
		var audio: Node = tree.root.get_node_or_null("AudioManager") if tree != null else null
		if audio != null:
			audio.play_sfx("ui_click")
	)


static func animate_rolling_number(lbl: Label, from_val: int, to_val: int, duration: float = 0.55, prefix: String = "", suffix: String = "") -> void:
	if not is_instance_valid(lbl):
		return
	var t := lbl.create_tween()
	t.tween_method(func(v: float) -> void:
		if is_instance_valid(lbl):
			lbl.text = "%s%d%s" % [prefix, int(round(v)), suffix]
	, float(from_val), float(to_val), duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


static func spawn_flying_coins(parent: Node, from_pos: Vector2, to_pos: Vector2, tex_path: String, count: int = 8) -> void:
	var tex: Texture2D = load(tex_path)
	if tex == null or not is_instance_valid(parent):
		return
	for i in count:
		var icon := TextureRect.new()
		icon.texture = tex
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.size = Vector2(42, 42)
		icon.position = from_pos + Vector2(randf_range(-40, 40), randf_range(-25, 25))
		icon.z_index = 90
		parent.add_child(icon)

		var mid_pos := icon.position + Vector2(randf_range(-70, 70), randf_range(-90, -40))
		var t := icon.create_tween()
		t.tween_interval(float(i) * 0.045)
		t.tween_property(icon, "position", mid_pos, 0.18).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		t.tween_property(icon, "position", to_pos, 0.36).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
		t.parallel().tween_property(icon, "scale", Vector2(0.55, 0.55), 0.36)
		t.tween_callback(icon.queue_free)


static func create_ambient_particles(biome_id: String, area_width: float = 720.0) -> CPUParticles2D:
	var p := CPUParticles2D.new()
	p.name = "AmbientParticles"
	p.amount = 22
	p.lifetime = 4.2
	p.preprocess = 1.8
	p.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	p.emission_rect_extents = Vector2(area_width * 0.55, 20.0)

	match biome_id:
		"desert":
			p.position = Vector2(area_width * 0.5, 420.0)
			p.direction = Vector2(-1.0, -0.1)
			p.gravity = Vector2(-28, 6)
			p.initial_velocity_min = 35.0
			p.initial_velocity_max = 75.0
			p.scale_amount_min = 3.0
			p.scale_amount_max = 6.0
			p.color = Color(1.0, 0.88, 0.56, 0.45)
		"tundra":
			p.position = Vector2(area_width * 0.5, -10.0)
			p.direction = Vector2(-0.25, 1.0)
			p.gravity = Vector2(-8, 18)
			p.initial_velocity_min = 40.0
			p.initial_velocity_max = 85.0
			p.scale_amount_min = 4.0
			p.scale_amount_max = 8.0
			p.color = Color(0.90, 0.97, 1.0, 0.72)
		"demon":
			p.position = Vector2(area_width * 0.5, 580.0)
			p.direction = Vector2(0.15, -1.0)
			p.gravity = Vector2(12, -26)
			p.initial_velocity_min = 35.0
			p.initial_velocity_max = 85.0
			p.scale_amount_min = 3.5
			p.scale_amount_max = 7.5
			p.color = Color(1.0, 0.45, 0.16, 0.75)
		_:
			p.position = Vector2(area_width * 0.5, -10.0)
			p.direction = Vector2(-0.35, 1.0)
			p.gravity = Vector2(-10, 14)
			p.initial_velocity_min = 35.0
			p.initial_velocity_max = 75.0
			p.scale_amount_min = 5.0
			p.scale_amount_max = 9.0
			p.color = Color(1.0, 0.72, 0.84, 0.78)
	return p


static func is_wide(area: Vector2) -> bool:
	return area.x >= area.y * 1.15


static func fit_rect(content: Vector2, bounds: Rect2) -> Rect2:
	var factor := maxf(0.0, minf(bounds.size.x / content.x, bounds.size.y / content.y))
	var fitted := content * factor
	return Rect2(bounds.get_center() - fitted * 0.5, fitted)


static func fit_control(control: Control, content: Vector2, bounds: Rect2) -> void:
	var fitted := fit_rect(content, bounds)
	control.size = content
	control.scale = Vector2.ONE * (fitted.size.x / content.x)
	control.position = fitted.position


static func center_modal(host: Control, panel: Control) -> void:
	var content := panel.size
	var layout := func() -> void:
		fit_control(panel, content.max(panel.get_combined_minimum_size()), Rect2(Vector2(16, 16), host.size - Vector2(32, 32)))
	host.resized.connect(layout)
	panel.minimum_size_changed.connect(layout)
	layout.call()
