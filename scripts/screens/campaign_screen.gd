extends Control

var _app: Control
var _selected_stage: int = 1
var _stage_info_lbl: Label
var _synergy_lbl: Label
var _power_lbl: Label
var _slot_row: HBoxContainer
var _pin_buttons: Array[Button] = []
var _picker_modal: Control
var _map_wrap: Control
var _map_backdrop: TextureRect
var _top_bar: PanelContainer
var _formation_panel: PanelContainer


func setup_screen(app: Control, _params: Dictionary = {}) -> void:
	_app = app
	_selected_stage = PlayerState.selected_stage


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	PlayerState.roster_changed.connect(_refresh_formation)

	_map_backdrop = TextureRect.new()
	_map_backdrop.texture = load("res://assets/sprites/backgrounds/bg_campaign_map.png")
	_map_backdrop.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_map_backdrop.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	_map_backdrop.modulate = Color(0.34, 0.31, 0.43)
	_map_backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_map_backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(_map_backdrop)

	var map_wrap := Control.new()
	_map_wrap = map_wrap
	map_wrap.position = Vector2(0, 0)
	map_wrap.size = Vector2(720, 845)
	add_child(map_wrap)

	var map_bg := TextureRect.new()
	map_bg.texture = _map_backdrop.texture
	map_bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	map_bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	map_bg.size = Vector2(720, 845)
	map_wrap.add_child(map_bg)

	# Trail line connecting 20 stages
	var trail := Line2D.new()
	trail.width = 4.0
	trail.default_color = Color(1.0, 0.92, 0.66, 0.65)
	for pos_norm in GameData.STAGE_MAP_POSITIONS:
		trail.add_point(Vector2(pos_norm.x * 720.0, 95.0 + pos_norm.y * 710.0))
	map_wrap.add_child(trail)

	_build_top_bar()
	_build_stage_pins(map_wrap)
	_build_formation_panel()
	_refresh_stage_info()
	_refresh_formation()
	resized.connect(_layout)
	_layout()


func _build_top_bar() -> void:
	var bar := PanelContainer.new()
	_top_bar = bar
	bar.position = Vector2(14, 14)
	bar.size = Vector2(692, 74)
	bar.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.10, 0.08, 0.16, 0.88), Color(0.95, 0.78, 0.36), 18, 2))
	add_child(bar)

	var hb := HBoxContainer.new()
	hb.add_theme_constant_override("separation", 14)
	bar.add_child(hb)

	var back_btn := Button.new()
	back_btn.custom_minimum_size = Vector2(56, 56)
	back_btn.flat = true
	back_btn.pressed.connect(func() -> void: _app.navigate_to("lobby"))
	UiFx.attach_press_bounce(back_btn)
	hb.add_child(back_btn)

	var back_ic := TextureRect.new()
	back_ic.texture = load("res://assets/sprites/ui/ui_btn_back.png")
	back_ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	back_ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	back_ic.size = Vector2(54, 54)
	back_ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
	back_btn.add_child(back_ic)

	var title := Label.new()
	title.text = "CAMPAIGN MAP (20 STAGES • 3 BOSSES)"
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 22)
	title.add_theme_color_override("font_color", Color(1.0, 0.88, 0.44))
	hb.add_child(title)


func _build_stage_pins(map_wrap: Control) -> void:
	_pin_buttons.clear()
	for i in 20:
		var stage_num := i + 1
		var st := GameData.get_stage_data(stage_num)
		var norm: Vector2 = st["map_pos"]
		var is_boss := bool(st["is_boss"])
		var unlocked := stage_num <= PlayerState.max_stage_unlocked

		var btn := Button.new()
		var sz := 58 if is_boss else 46
		btn.size = Vector2(sz, sz)
		btn.position = Vector2(norm.x * 720.0 - sz * 0.5, 95.0 + norm.y * 710.0 - sz * 0.5)
		btn.flat = true
		btn.disabled = not unlocked
		btn.modulate = Color.WHITE if unlocked else Color(0.45, 0.45, 0.52, 0.72)
		btn.pressed.connect(func() -> void:
			_selected_stage = stage_num
			PlayerState.selected_stage = stage_num
			_refresh_stage_info()
			_update_pin_styles()
		)
		UiFx.attach_press_bounce(btn)
		map_wrap.add_child(btn)
		_pin_buttons.append(btn)

		var ic := TextureRect.new()
		ic.name = "PinIcon"
		ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		ic.size = Vector2(sz, sz)
		ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
		btn.add_child(ic)

		var num_lbl := Label.new()
		num_lbl.text = "%d-%d" % [int(st["chapter"]), ((stage_num - 1) % 5) + 1]
		num_lbl.position = Vector2(-10, sz - 2)
		num_lbl.size = Vector2(sz + 20, 18)
		num_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		num_lbl.add_theme_font_size_override("font_size", 11)
		num_lbl.add_theme_color_override("font_color", Color(1.0, 0.94, 0.65) if unlocked else Color(0.75, 0.75, 0.80))
		num_lbl.add_theme_color_override("font_outline_color", Color.BLACK)
		num_lbl.add_theme_constant_override("outline_size", 3)
		btn.add_child(num_lbl)

	_update_pin_styles()


func _update_pin_styles() -> void:
	for i in _pin_buttons.size():
		var stage_num := i + 1
		var is_boss := (stage_num % 5 == 0)
		var btn := _pin_buttons[i]
		var ic: TextureRect = btn.get_node("PinIcon")
		if stage_num == _selected_stage:
			ic.texture = load("res://assets/sprites/ui/ui_pin_stage_active.png")
		elif is_boss:
			ic.texture = load("res://assets/sprites/ui/ui_pin_stage_boss.png")
		else:
			ic.texture = load("res://assets/sprites/ui/ui_pin_stage_normal.png")


func _build_formation_panel() -> void:
	var pc := PanelContainer.new()
	_formation_panel = pc
	pc.position = Vector2(0, 845)
	pc.size = Vector2(720, 435)
	pc.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.10, 0.09, 0.17, 0.98), Color(0.95, 0.78, 0.36), 0, 3))
	add_child(pc)

	var vb := VBoxContainer.new()
	vb.add_theme_constant_override("separation", 10)
	pc.add_child(vb)

	_stage_info_lbl = Label.new()
	_stage_info_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_stage_info_lbl.add_theme_font_size_override("font_size", 20)
	_stage_info_lbl.add_theme_color_override("font_color", Color(1.0, 0.88, 0.44))
	vb.add_child(_stage_info_lbl)

	var sub_hb := HBoxContainer.new()
	sub_hb.alignment = BoxContainer.ALIGNMENT_CENTER
	sub_hb.add_theme_constant_override("separation", 24)
	vb.add_child(sub_hb)

	_power_lbl = Label.new()
	_power_lbl.add_theme_font_size_override("font_size", 16)
	_power_lbl.add_theme_color_override("font_color", Color(0.74, 0.94, 1.0))
	sub_hb.add_child(_power_lbl)

	_synergy_lbl = Label.new()
	_synergy_lbl.add_theme_font_size_override("font_size", 16)
	_synergy_lbl.add_theme_color_override("font_color", Color(0.56, 0.96, 0.64))
	sub_hb.add_child(_synergy_lbl)

	var hint := Label.new()
	hint.text = "Đội hình 5 tướng: [2 Trước] + [3 Sau]  —  Chạm ô để đổi tướng"
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.add_theme_font_size_override("font_size", 14)
	hint.add_theme_color_override("font_color", Color(0.78, 0.82, 0.92))
	vb.add_child(hint)

	_slot_row = HBoxContainer.new()
	_slot_row.alignment = BoxContainer.ALIGNMENT_CENTER
	_slot_row.add_theme_constant_override("separation", 12)
	vb.add_child(_slot_row)

	var fight_btn := UiFx.make_styled_button("START 5v5 AUTO BATTLE", Color(0.84, 0.34, 0.14), Vector2(460, 74), 24)
	fight_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	fight_btn.pressed.connect(func() -> void:
		_app.navigate_to("battle", {"stage": _selected_stage})
	)
	vb.add_child(fight_btn)


func _refresh_stage_info() -> void:
	var st := GameData.get_stage_data(_selected_stage)
	_stage_info_lbl.text = "%s   •   Reward: %d G / %d EXP / %d Gems" % [
		String(st["name"]), int(st["reward_gold"]), int(st["reward_exp"]), int(st["reward_gems"])
	]


func _refresh_formation() -> void:
	for c in _slot_row.get_children():
		c.queue_free()

	_power_lbl.text = "Team Power: %d" % PlayerState.get_team_power()
	var syn := GameData.get_synergy_bonus(PlayerState.team_slots)
	_synergy_lbl.text = "Synergy: %s" % String(syn["label"])

	for i in 5:
		var hid := PlayerState.team_slots[i]
		var slot_btn := Button.new()
		slot_btn.custom_minimum_size = Vector2(122, 168)
		slot_btn.flat = true
		slot_btn.pressed.connect(func() -> void: _open_hero_picker(i))
		UiFx.attach_press_bounce(slot_btn)
		_slot_row.add_child(slot_btn)

		if hid != "" and PlayerState.owned_heroes.has(hid):
			var rec: Dictionary = PlayerState.get_hero_record(hid)
			var info: Dictionary = GameData.HEROES[hid]
			var evo := String(rec["evo"])
			var rar := String(info["rarity"])

			var frame := TextureRect.new()
			frame.name = "Frame"
			frame.texture = load(GameData.RARITIES[rar]["frame"])
			frame.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			frame.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			frame.size = Vector2(122, 152)
			frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
			slot_btn.add_child(frame)

			var port := TextureRect.new()
			port.name = "Portrait"
			port.texture = load(GameData.get_hero_portrait_path(hid, evo))
			port.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			port.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			port.position = Vector2(20, 30)
			port.size = Vector2(82, 74)
			port.mouse_filter = Control.MOUSE_FILTER_IGNORE
			slot_btn.add_child(port)

			var el_ic := TextureRect.new()
			el_ic.texture = load(GameData.ELEMENTS[info["element"]]["icon"])
			el_ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			el_ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			el_ic.position = Vector2(88, 6)
			el_ic.size = Vector2(26, 26)
			el_ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
			slot_btn.add_child(el_ic)

		var role_tag := Label.new()
		role_tag.text = ("FRONT %d" % (i + 1)) if i < 2 else ("BACK %d" % (i - 1))
		role_tag.position = Vector2(0, 148)
		role_tag.size = Vector2(122, 20)
		role_tag.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		role_tag.add_theme_font_size_override("font_size", 12)
		role_tag.add_theme_color_override("font_color", Color(1.0, 0.78, 0.36) if i < 2 else Color(0.62, 0.90, 1.0))
		slot_btn.add_child(role_tag)


func _open_hero_picker(slot_idx: int) -> void:
	if _picker_modal != null and is_instance_valid(_picker_modal):
		_picker_modal.queue_free()

	_picker_modal = Control.new()
	_picker_modal.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(_picker_modal)

	var dim := ColorRect.new()
	dim.color = Color(0.02, 0.02, 0.06, 0.74)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_picker_modal.add_child(dim)

	var pc := PanelContainer.new()
	pc.position = Vector2(40, 260)
	pc.size = Vector2(640, 720)
	pc.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.11, 0.10, 0.19, 0.98), Color(1.0, 0.80, 0.36), 22, 3))
	_picker_modal.add_child(pc)
	UiFx.center_modal(_picker_modal, pc)

	var vb := VBoxContainer.new()
	vb.add_theme_constant_override("separation", 14)
	pc.add_child(vb)

	var h := Label.new()
	h.text = "CHỌN TƯỚNG CHO VỊ TRÍ %s" % (("FRONT %d" % (slot_idx + 1)) if slot_idx < 2 else ("BACK %d" % (slot_idx - 1)))
	h.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	h.add_theme_font_size_override("font_size", 22)
	h.add_theme_color_override("font_color", Color(1.0, 0.88, 0.44))
	vb.add_child(h)

	var sc := ScrollContainer.new()
	sc.custom_minimum_size = Vector2(600, 560)
	vb.add_child(sc)

	var grid := GridContainer.new()
	grid.columns = 4
	grid.add_theme_constant_override("h_separation", 12)
	grid.add_theme_constant_override("v_separation", 12)
	sc.add_child(grid)

	for hid in PlayerState.owned_heroes:
		var rec: Dictionary = PlayerState.get_hero_record(hid)
		var evo := String(rec["evo"])
		var btn := UiFx.make_styled_button(
			"%s\nLv.%d" % [GameData.get_hero_display_name(hid, evo), int(rec["level"])],
			Color(0.22, 0.24, 0.38), Vector2(138, 130), 13
		)
		btn.icon = load(GameData.get_hero_portrait_path(hid, evo))
		btn.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		btn.vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
		btn.expand_icon = true
		btn.pressed.connect(func() -> void:
			PlayerState.set_team_slot(slot_idx, hid)
			_picker_modal.queue_free()
		)
		grid.add_child(btn)

	var cancel := UiFx.make_styled_button("CLOSE", Color(0.46, 0.24, 0.28), Vector2(200, 52), 18)
	cancel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	cancel.pressed.connect(_picker_modal.queue_free)
	vb.add_child(cancel)


func _layout() -> void:
	var wide := UiFx.is_wide(size)
	_map_backdrop.visible = wide
	_top_bar.position.x = (size.x - _top_bar.size.x) * 0.5
	if wide:
		var height := size.y - 106.0
		var map_width := (size.x - 54.0) * 0.46
		UiFx.fit_control(_map_wrap, Vector2(720, 845), Rect2(18, 90, map_width, height))
		UiFx.fit_control(_formation_panel, Vector2(720, 435), Rect2(36 + map_width, 90, size.x - 54 - map_width, height))
	else:
		UiFx.fit_control(_map_wrap, Vector2(720, 845), Rect2(0, 0, 720, 845))
		UiFx.fit_control(_formation_panel, Vector2(720, 435), Rect2(0, 845, 720, 435))
