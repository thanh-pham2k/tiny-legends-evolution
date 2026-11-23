extends Control

var _app: Control
var _gem_lbl: Label
var _ticket_lbl: Label
var _pity_lbl: Label
var _beam: TextureRect
var _results_grid: GridContainer
var _status_lbl: Label
var _summoning: bool = false


func setup_screen(app: Control, _params: Dictionary = {}) -> void:
	_app = app


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	PlayerState.resources_changed.connect(_refresh_header)

	var bg := TextureRect.new()
	bg.texture = load("res://assets/sprites/backgrounds/bg_summon_portal.png")
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	_beam = TextureRect.new()
	_beam.texture = load("res://assets/sprites/ui/ui_gacha_beam.png")
	_beam.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_beam.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_beam.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	_beam.offset_left = -250.0
	_beam.offset_top = -360.0
	_beam.offset_right = 250.0
	_beam.offset_bottom = 360.0
	_beam.modulate = Color(0.7, 0.5, 1.0, 0.22)
	add_child(_beam)

	_build_top_bar()
	_build_results_area()
	_build_bottom_buttons()
	_refresh_header()


func _build_top_bar() -> void:
	var top_vbox := VBoxContainer.new()
	top_vbox.set_anchors_preset(Control.PRESET_TOP_WIDE)
	top_vbox.offset_left = 16.0
	top_vbox.offset_top = 16.0
	top_vbox.offset_right = -16.0
	top_vbox.offset_bottom = 190.0
	top_vbox.add_theme_constant_override("separation", 8)
	add_child(top_vbox)

	var bar := PanelContainer.new()
	bar.custom_minimum_size = Vector2(0, 82)
	var bar_sb := UiFx.make_panel_style(Color(0.10, 0.08, 0.18, 0.90), Color(0.86, 0.62, 1.0), 18, 2)
	bar_sb.content_margin_left = 14
	bar_sb.content_margin_right = 18
	bar.add_theme_stylebox_override("panel", bar_sb)
	top_vbox.add_child(bar)

	var hb := HBoxContainer.new()
	hb.add_theme_constant_override("separation", 12)
	bar.add_child(hb)

	var back_btn := Button.new()
	back_btn.custom_minimum_size = Vector2(62, 62)
	back_btn.flat = true
	back_btn.pressed.connect(func() -> void: _app.navigate_to("lobby"))
	UiFx.attach_press_bounce(back_btn)
	hb.add_child(back_btn)

	var back_ic := TextureRect.new()
	back_ic.texture = load("res://assets/sprites/ui/ui_btn_back.png")
	back_ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	back_ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	back_ic.size = Vector2(58, 58)
	back_ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
	back_btn.add_child(back_ic)

	var title := Label.new()
	title.text = "SUMMON PORTAL"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 24)
	title.add_theme_color_override("font_color", Color(1.0, 0.88, 0.44))
	hb.add_child(title)

	_ticket_lbl = Label.new()
	_ticket_lbl.custom_minimum_size = Vector2(120, 62)
	_ticket_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_ticket_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_ticket_lbl.add_theme_font_size_override("font_size", 18)
	_ticket_lbl.add_theme_color_override("font_color", Color(0.68, 0.96, 1.0))
	hb.add_child(_ticket_lbl)

	_gem_lbl = Label.new()
	_gem_lbl.custom_minimum_size = Vector2(130, 62)
	_gem_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_gem_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_gem_lbl.add_theme_font_size_override("font_size", 18)
	_gem_lbl.add_theme_color_override("font_color", Color(0.90, 0.72, 1.0))
	hb.add_child(_gem_lbl)

	_pity_lbl = Label.new()
	_pity_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_pity_lbl.add_theme_font_size_override("font_size", 17)
	_pity_lbl.add_theme_color_override("font_color", Color(1.0, 0.88, 0.46))
	_pity_lbl.add_theme_color_override("font_outline_color", Color(0.06, 0.04, 0.12))
	_pity_lbl.add_theme_constant_override("outline_size", 4)
	top_vbox.add_child(_pity_lbl)

	_status_lbl = Label.new()
	_status_lbl.text = "Triệu hồi tướng R / SR / SSR / UR!"
	_status_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_status_lbl.add_theme_font_size_override("font_size", 20)
	_status_lbl.add_theme_color_override("font_color", Color(0.95, 0.97, 1.0))
	_status_lbl.add_theme_color_override("font_outline_color", Color(0.06, 0.04, 0.12))
	_status_lbl.add_theme_constant_override("outline_size", 5)
	top_vbox.add_child(_status_lbl)


func _build_results_area() -> void:
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	center.offset_top = 175.0
	center.offset_bottom = -132.0
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(center)

	_results_grid = GridContainer.new()
	_results_grid.columns = 5
	_results_grid.add_theme_constant_override("h_separation", 14)
	_results_grid.add_theme_constant_override("v_separation", 18)
	center.add_child(_results_grid)


func _build_bottom_buttons() -> void:
	var bottom_wrap := CenterContainer.new()
	bottom_wrap.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	bottom_wrap.offset_top = -142.0
	bottom_wrap.offset_bottom = -24.0
	add_child(bottom_wrap)

	var hb := HBoxContainer.new()
	hb.alignment = BoxContainer.ALIGNMENT_CENTER
	hb.add_theme_constant_override("separation", 24)
	bottom_wrap.add_child(hb)

	var b1 := UiFx.make_styled_button("SUMMON x1\n(1 Ticket / 300 Gems)", Color(0.20, 0.48, 0.84), Vector2(290, 92), 18)
	b1.pressed.connect(func() -> void: _do_summon(1))
	hb.add_child(b1)

	var b10 := UiFx.make_styled_button("SUMMON x10\n(10 Tickets / 2700 Gems)", Color(0.84, 0.56, 0.14), Vector2(290, 92), 18)
	b10.pressed.connect(func() -> void: _do_summon(10))
	hb.add_child(b10)


func _do_summon(count: int) -> void:
	if _summoning:
		return
	if not PlayerState.can_afford_summon(count):
		_status_lbl.text = "Không đủ Vé hoặc Gems!"
		return
	var pulls := PlayerState.summon_gacha(count)
	if pulls.is_empty():
		return
	_summoning = true
	for c in _results_grid.get_children():
		c.queue_free()

	var best_rar := "R"
	var rank := {"R": 0, "SR": 1, "SSR": 2, "UR": 3}
	for p in pulls:
		if int(rank[p["rarity"]]) > int(rank[best_rar]):
			best_rar = String(p["rarity"])

	var beam_col: Color = GameData.RARITIES[best_rar]["color"]
	AudioManager.play_sfx("gacha_ssr" if best_rar in ["SSR", "UR"] else "gacha_pull")
	_status_lbl.text = "Đang triệu hồi..."

	var bt := create_tween()
	bt.tween_property(_beam, "modulate", Color(beam_col.r, beam_col.g, beam_col.b, 0.95), 0.24)
	bt.tween_property(_beam, "modulate", Color(beam_col.r, beam_col.g, beam_col.b, 0.20), 0.40)
	bt.tween_callback(func() -> void:
		_reveal_cards(pulls, best_rar)
	)


func _reveal_cards(pulls: Array, best_rar: String) -> void:
	for c in _results_grid.get_children():
		c.queue_free()
	_results_grid.columns = 1 if pulls.size() == 1 else 5
	for i in pulls.size():
		var pull: Dictionary = pulls[i]
		var card := _build_flip_card(pull, pulls.size() == 1)
		_results_grid.add_child(card)
		_animate_card_flip(card, pull, float(i) * 0.08)

	var done_t := create_tween()
	done_t.tween_interval(float(pulls.size()) * 0.08 + 0.38)
	done_t.tween_callback(func() -> void:
		_summoning = false
		_status_lbl.text = "Triệu hồi hoàn tất! Độ hiếm cao nhất: %s" % best_rar
	)


func _build_flip_card(pull: Dictionary, big: bool) -> Control:
	var w := 230 if big else 120
	var h := 316 if big else 172
	var wrap := Control.new()
	wrap.custom_minimum_size = Vector2(w, h)
	wrap.pivot_offset = Vector2(w * 0.5, h * 0.5)

	var back := TextureRect.new()
	back.name = "Back"
	back.texture = load("res://assets/sprites/ui/ui_gacha_card_back.png")
	back.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	back.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	back.size = Vector2(w, h)
	wrap.add_child(back)

	var front := Control.new()
	front.name = "Front"
	front.visible = false
	front.size = Vector2(w, h)
	wrap.add_child(front)

	var hid := String(pull["hero_id"])
	var rar := String(pull["rarity"])
	var hinfo: Dictionary = GameData.HEROES[hid]

	# Frame FIRST, Portrait ON TOP inside the card inner window!
	var frame := TextureRect.new()
	frame.name = "Frame"
	frame.texture = load(GameData.RARITIES[rar]["frame"])
	frame.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	frame.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	frame.size = Vector2(w, h)
	front.add_child(frame)

	var port := TextureRect.new()
	port.name = "Portrait"
	port.texture = load(GameData.get_hero_portrait_path(hid, "basic"))
	port.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	port.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	port.position = Vector2(w * 0.16, h * 0.21)
	port.size = Vector2(w * 0.68, h * 0.53)
	front.add_child(port)

	var el_ic := TextureRect.new()
	el_ic.name = "ElementIcon"
	el_ic.texture = load(GameData.ELEMENTS[hinfo["element"]]["icon"])
	el_ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	el_ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	el_ic.position = Vector2(w - (52 if big else 32), 10 if big else 6)
	el_ic.size = Vector2(40, 40) if big else Vector2(24, 24)
	front.add_child(el_ic)

	var r_lbl := Label.new()
	r_lbl.name = "RarityLabel"
	r_lbl.text = rar
	r_lbl.position = Vector2(12 if big else 6, 8 if big else 4)
	r_lbl.add_theme_font_size_override("font_size", 26 if big else 14)
	r_lbl.add_theme_color_override("font_color", GameData.RARITIES[rar]["color"])
	r_lbl.add_theme_color_override("font_outline_color", Color.BLACK)
	r_lbl.add_theme_constant_override("outline_size", 4)
	front.add_child(r_lbl)

	var tag_lbl := Label.new()
	tag_lbl.name = "TagLabel"
	if bool(pull["is_new"]):
		tag_lbl.text = ("NEW! " + String(hinfo["name"])) if big else ("NEW!\n" + String(hinfo["name"]))
	else:
		tag_lbl.text = "%s\n+%d Shards" % [String(hinfo["name"]), int(pull["shards_gained"])]
	tag_lbl.position = Vector2(6, h - (56 if big else 38))
	tag_lbl.size = Vector2(w - 12, 46 if big else 34)
	tag_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tag_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	tag_lbl.clip_text = true
	tag_lbl.add_theme_font_size_override("font_size", 18 if big else 9)
	tag_lbl.add_theme_color_override("font_color", Color(1.0, 0.94, 0.45) if bool(pull["is_new"]) else Color(0.88, 0.96, 1.0))
	tag_lbl.add_theme_color_override("font_outline_color", Color.BLACK)
	tag_lbl.add_theme_constant_override("outline_size", 4)
	front.add_child(tag_lbl)

	return wrap


func _animate_card_flip(card: Control, pull: Dictionary, delay: float) -> void:
	var back := card.get_node("Back")
	var front := card.get_node("Front")
	var t := card.create_tween()
	t.tween_interval(delay)
	t.tween_property(card, "scale:x", 0.02, 0.14).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	t.tween_callback(func() -> void:
		back.visible = false
		front.visible = true
		if String(pull["rarity"]) in ["SSR", "UR"]:
			AudioManager.play_sfx("gacha_ssr")
	)
	t.tween_property(card, "scale:x", 1.06, 0.16).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	t.tween_property(card, "scale:x", 1.0, 0.08)


func _refresh_header() -> void:
	if not is_instance_valid(_ticket_lbl):
		return
	_ticket_lbl.text = "Tickets: %d" % PlayerState.tickets
	_gem_lbl.text = "Gems: %d" % PlayerState.gems
	_pity_lbl.text = "Pity Counter: %d / %d (Chắc chắn SSR / UR)" % [PlayerState.pity_counter, PlayerState.PITY_THRESHOLD]
