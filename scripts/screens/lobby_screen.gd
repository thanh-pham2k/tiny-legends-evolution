extends Control

var _app: Control
var _gold_lbl: Label
var _gem_lbl: Label
var _ticket_lbl: Label
var _power_lbl: Label
var _idle_dot: ColorRect
var _settings_modal: Control


func setup_screen(app: Control, _params: Dictionary = {}) -> void:
	_app = app


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	PlayerState.resources_changed.connect(_refresh_hud)
	PlayerState.roster_changed.connect(_refresh_hud)

	var bg := TextureRect.new()
	bg.texture = load("res://assets/sprites/backgrounds/bg_lobby_town.png")
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	add_child(UiFx.create_ambient_particles("plains", 720.0))

	_build_top_hud()
	_build_hub_buttons()
	_build_bottom_dock()
	_refresh_hud()


func _build_top_hud() -> void:
	var top_bar := PanelContainer.new()
	top_bar.position = Vector2(14, 18)
	top_bar.size = Vector2(692, 108)
	top_bar.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.10, 0.09, 0.17, 0.88), Color(0.95, 0.78, 0.34), 20, 2))
	add_child(top_bar)

	var hb := HBoxContainer.new()
	hb.add_theme_constant_override("separation", 12)
	top_bar.add_child(hb)

	# Avatar frame + Knight portrait
	var av_wrap := Control.new()
	av_wrap.custom_minimum_size = Vector2(84, 84)
	hb.add_child(av_wrap)

	var port := TextureRect.new()
	port.texture = load(GameData.get_hero_portrait_path("knight", String(PlayerState.get_hero_record("knight").get("evo", "basic"))))
	port.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	port.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	port.position = Vector2(12, 12)
	port.size = Vector2(60, 60)
	av_wrap.add_child(port)

	var frame := TextureRect.new()
	frame.texture = load("res://assets/sprites/ui/ui_avatar_frame.png")
	frame.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	frame.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	frame.size = Vector2(84, 84)
	av_wrap.add_child(frame)

	var info_vb := VBoxContainer.new()
	info_vb.custom_minimum_size = Vector2(170, 84)
	info_vb.alignment = BoxContainer.ALIGNMENT_CENTER
	hb.add_child(info_vb)

	var pname := Label.new()
	pname.text = "Commander"
	pname.add_theme_font_size_override("font_size", 18)
	pname.add_theme_color_override("font_color", Color(1.0, 0.92, 0.65))
	info_vb.add_child(pname)

	_power_lbl = Label.new()
	_power_lbl.add_theme_font_size_override("font_size", 15)
	_power_lbl.add_theme_color_override("font_color", Color(0.75, 0.92, 1.0))
	info_vb.add_child(_power_lbl)

	_gold_lbl = _make_res_pill(hb, "res://assets/sprites/items/item_gold_coin.png", Color(1.0, 0.88, 0.42))
	_gem_lbl = _make_res_pill(hb, "res://assets/sprites/items/item_purple_gem.png", Color(0.88, 0.72, 1.0))
	_ticket_lbl = _make_res_pill(hb, "res://assets/sprites/items/item_summon_ticket.png", Color(0.68, 0.96, 1.0))


func _make_res_pill(parent: HBoxContainer, icon_path: String, text_col: Color) -> Label:
	var pc := PanelContainer.new()
	pc.custom_minimum_size = Vector2(126, 44)
	pc.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	pc.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.06, 0.06, 0.12, 0.92), Color(0.62, 0.52, 0.30), 14, 2))
	parent.add_child(pc)

	var hb := HBoxContainer.new()
	hb.alignment = BoxContainer.ALIGNMENT_CENTER
	hb.add_theme_constant_override("separation", 6)
	pc.add_child(hb)

	var ic := TextureRect.new()
	ic.texture = load(icon_path)
	ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	ic.custom_minimum_size = Vector2(28, 28)
	hb.add_child(ic)

	var lbl := Label.new()
	lbl.add_theme_font_size_override("font_size", 16)
	lbl.add_theme_color_override("font_color", text_col)
	hb.add_child(lbl)
	return lbl


func _build_hub_buttons() -> void:
	# Floating main hub plaques matching the Town Hub illustration
	_make_hub_plaque(
		"SUMMON", "Gacha x1/x10", "res://assets/sprites/ui/ui_nav_summon.png",
		Vector2(54, 480), func() -> void: _app.navigate_to("summon")
	)
	_make_hub_plaque(
		"HEROES", "12 Heroes & Evo", "res://assets/sprites/ui/ui_nav_heroes.png",
		Vector2(476, 480), func() -> void: _app.navigate_to("heroes")
	)
	_make_hub_plaque(
		"CAMPAIGN", "Stage %d / 20" % PlayerState.max_stage_unlocked, "res://assets/sprites/ui/ui_nav_campaign.png",
		Vector2(252, 650), func() -> void: _app.navigate_to("campaign"), 1.18
	)
	_make_hub_plaque(
		"QUICK BATTLE", "Auto 5v5", "res://assets/sprites/ui/ui_nav_tower.png",
		Vector2(54, 855), func() -> void: _app.navigate_to("battle", {"stage": PlayerState.selected_stage})
	)
	_make_hub_plaque(
		"IDLE CHEST", "Offline Loot", "res://assets/sprites/ui/ui_nav_events.png",
		Vector2(476, 855), func() -> void: _app.open_idle_rewards()
	)


func _make_hub_plaque(title_str: String, sub_str: String, icon_path: String, pos: Vector2, cb: Callable, sc_mult: float = 1.0) -> void:
	var btn := Button.new()
	btn.position = pos
	btn.size = Vector2(190, 178) * sc_mult
	btn.flat = true
	btn.pressed.connect(cb)
	UiFx.attach_press_bounce(btn)
	add_child(btn)

	var ic := TextureRect.new()
	ic.texture = load(icon_path)
	ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	ic.size = Vector2(146, 146) * sc_mult
	ic.position = Vector2(22, 0) * sc_mult
	ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
	btn.add_child(ic)

	# Gentle float animation
	var ft := create_tween().set_loops()
	ft.tween_property(ic, "position:y", ic.position.y - 6.0, randf_range(1.1, 1.5)).set_trans(Tween.TRANS_SINE)
	ft.tween_property(ic, "position:y", ic.position.y, randf_range(1.1, 1.5)).set_trans(Tween.TRANS_SINE)

	var lbl_bg := PanelContainer.new()
	lbl_bg.position = Vector2(6, 128) * sc_mult
	lbl_bg.size = Vector2(178, 46) * sc_mult
	lbl_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	lbl_bg.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.11, 0.08, 0.16, 0.92), Color(1.0, 0.82, 0.36), 12, 2))
	btn.add_child(lbl_bg)

	var vb := VBoxContainer.new()
	vb.alignment = BoxContainer.ALIGNMENT_CENTER
	vb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	lbl_bg.add_child(vb)

	var t := Label.new()
	t.text = title_str
	t.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	t.add_theme_font_size_override("font_size", int(16 * sc_mult))
	t.add_theme_color_override("font_color", Color(1.0, 0.92, 0.50))
	vb.add_child(t)

	var s := Label.new()
	s.text = sub_str
	s.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	s.add_theme_font_size_override("font_size", int(12 * sc_mult))
	s.add_theme_color_override("font_color", Color(0.84, 0.92, 1.0))
	vb.add_child(s)


func _build_bottom_dock() -> void:
	var dock := PanelContainer.new()
	dock.position = Vector2(24, 1138)
	dock.size = Vector2(672, 116)
	dock.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.10, 0.09, 0.18, 0.90), Color(0.92, 0.74, 0.34), 22, 2))
	add_child(dock)

	var hb := HBoxContainer.new()
	hb.alignment = BoxContainer.ALIGNMENT_CENTER
	hb.add_theme_constant_override("separation", 26)
	dock.add_child(hb)

	_make_dock_icon(hb, "res://assets/sprites/ui/ui_icon_bag.png", "Heroes", func() -> void: _app.navigate_to("heroes"))
	var idle_btn := _make_dock_icon(hb, "res://assets/sprites/ui/ui_icon_idle_chest.png", "Idle", func() -> void: _app.open_idle_rewards())
	_idle_dot = ColorRect.new()
	_idle_dot.color = Color(1.0, 0.24, 0.28)
	_idle_dot.position = Vector2(56, 2)
	_idle_dot.size = Vector2(14, 14)
	idle_btn.add_child(_idle_dot)

	_make_dock_icon(hb, "res://assets/sprites/ui/ui_icon_quests.png", "Campaign", func() -> void: _app.navigate_to("campaign"))
	_make_dock_icon(hb, "res://assets/sprites/ui/ui_icon_settings.png", "Settings", _open_settings)


func _make_dock_icon(parent: HBoxContainer, icon_path: String, cap: String, cb: Callable) -> Button:
	var btn := Button.new()
	btn.custom_minimum_size = Vector2(84, 92)
	btn.flat = true
	btn.pressed.connect(cb)
	UiFx.attach_press_bounce(btn)
	parent.add_child(btn)

	var ic := TextureRect.new()
	ic.texture = load(icon_path)
	ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	ic.position = Vector2(9, 2)
	ic.size = Vector2(66, 66)
	ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
	btn.add_child(ic)

	var l := Label.new()
	l.text = cap
	l.position = Vector2(-6, 68)
	l.size = Vector2(96, 22)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.add_theme_font_size_override("font_size", 14)
	l.add_theme_color_override("font_color", Color(0.96, 0.94, 0.88))
	btn.add_child(l)
	return btn


func _open_settings() -> void:
	if _settings_modal != null and is_instance_valid(_settings_modal):
		_settings_modal.queue_free()

	_settings_modal = Control.new()
	_settings_modal.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(_settings_modal)

	var dim := ColorRect.new()
	dim.color = Color(0.02, 0.02, 0.06, 0.72)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_settings_modal.add_child(dim)

	var pc := PanelContainer.new()
	pc.position = Vector2(110, 380)
	pc.size = Vector2(500, 420)
	pc.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.12, 0.11, 0.20, 0.98), Color(1.0, 0.82, 0.36), 22, 3))
	_settings_modal.add_child(pc)

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

	var fps_btn := UiFx.make_styled_button("Target FPS: %d FPS" % PlayerState.fps_cap, Color(0.20, 0.46, 0.74), Vector2(340, 66), 22)
	fps_btn.pressed.connect(func() -> void:
		var next_fps := 30 if PlayerState.fps_cap == 60 else 60
		PlayerState.set_fps_cap(next_fps)
		fps_btn.text = "Target FPS: %d FPS%s" % [next_fps, " (Battery Saver)" if next_fps == 30 else " (Smooth)"]
	)
	vb.add_child(fps_btn)

	var mute_btn := UiFx.make_styled_button("Sound FX: %s" % ("MUTED" if AudioManager.muted else "ON"), Color(0.32, 0.42, 0.32), Vector2(340, 66), 22)
	mute_btn.pressed.connect(func() -> void:
		AudioManager.set_muted(not AudioManager.muted)
		mute_btn.text = "Sound FX: %s" % ("MUTED" if AudioManager.muted else "ON")
	)
	vb.add_child(mute_btn)

	var close_btn := UiFx.make_styled_button("CLOSE", Color(0.46, 0.24, 0.28), Vector2(220, 60), 20)
	close_btn.pressed.connect(func() -> void:
		_settings_modal.queue_free()
	)
	vb.add_child(close_btn)


func _refresh_hud() -> void:
	if not is_instance_valid(_gold_lbl):
		return
	_gold_lbl.text = str(PlayerState.gold)
	_gem_lbl.text = str(PlayerState.gems)
	_ticket_lbl.text = str(PlayerState.tickets)
	_power_lbl.text = "Power: %d" % PlayerState.get_team_power()
	var pend := PlayerState.get_pending_idle_rewards()
	if _idle_dot != null:
		_idle_dot.visible = int(pend["gold"]) >= 50
