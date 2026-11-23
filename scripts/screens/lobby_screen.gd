extends Control

var _app: Control
var _gold_lbl: Label
var _gem_lbl: Label
var _ticket_lbl: Label
var _power_lbl: Label
var _idle_dot: ColorRect
var _settings_modal: Control
var _center_hero: UnitVisual


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

	_build_center_hero_showcase()
	_build_top_left_commander()
	_build_top_right_resources()
	_build_right_edge_shortcuts()
	_refresh_hud()


func _build_center_hero_showcase() -> void:
	# Center remains completely unobstructed for the Sakura Plaza and lead Hero!
	var center_anchor := Control.new()
	center_anchor.name = "CenterShowcase"
	center_anchor.set_anchors_preset(Control.PRESET_CENTER)
	center_anchor.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(center_anchor)

	_center_hero = UnitVisual.new()
	_center_hero.name = "LobbyLeadHero"
	_center_hero.facing_sign = 1.0
	_center_hero.unit_scale = 1.85
	_center_hero.position = Vector2(-20, 155)
	center_anchor.add_child(_center_hero)
	_sync_center_hero()


func _sync_center_hero() -> void:
	if _center_hero == null:
		return
	var evo := String(PlayerState.get_hero_record("knight").get("evo", "basic"))
	_center_hero.configure_animations(GameData.get_hero_anim_map("knight", evo))
	_center_hero.set_aura(Color(1.0, 0.36, 0.14), evo == "fire")
	if evo == "holy":
		_center_hero.set_aura(Color(1.0, 0.88, 0.32), true)


func _build_top_left_commander() -> void:
	var card := PanelContainer.new()
	card.name = "TopLeftCommander"
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
	if _idle_dot != null:
		_idle_dot.visible = int(pend["gold"]) >= 50
