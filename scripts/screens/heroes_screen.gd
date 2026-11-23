extends Control

var _app: Control
var _filter_el: String = "all"
var _selected_hero: String = "knight"
var _grid: GridContainer
var _detail_host: Control
var _gold_lbl: Label
var _exp_lbl: Label
var _owned_count_lbl: Label
var _top_bar: PanelContainer
var _roster_panel: PanelContainer
var _roster_scroll: ScrollContainer
var _bg_showcase: TextureRect
var _filter_btns: Dictionary = {}


func setup_screen(app: Control, params: Dictionary = {}) -> void:
	_app = app
	if params.has("hero_id"):
		_selected_hero = String(params["hero_id"])


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	PlayerState.roster_changed.connect(_rebuild_all)
	PlayerState.resources_changed.connect(_refresh_top)

	var bg_base := TextureRect.new()
	bg_base.texture = load("res://assets/sprites/backgrounds/bg_hero_detail_starry.png")
	bg_base.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg_base.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	bg_base.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg_base.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg_base)

	# Dynamic elemental showcase backdrop covering the stage cleanly
	_bg_showcase = TextureRect.new()
	_bg_showcase.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_bg_showcase.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	_bg_showcase.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_bg_showcase.modulate = Color(0.88, 0.90, 0.96, 0.86)
	_bg_showcase.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_bg_showcase)

	var shade := ColorRect.new()
	shade.color = Color(0.03, 0.04, 0.09, 0.42)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(shade)

	_build_top_bar()
	_build_roster_panel()

	_detail_host = Control.new()
	_detail_host.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_detail_host)

	resized.connect(_layout)
	_layout()
	_rebuild_all()


func _fmt_num(n: int) -> String:
	var neg: bool = n < 0
	var s: String = str(abs(n))
	var out: String = ""
	var cnt: int = 0
	for i in range(s.length() - 1, -1, -1):
		if cnt > 0 and cnt % 3 == 0:
			out = "," + out
		out = s[i] + out
		cnt += 1
	return ("-" + out) if neg else out


func _make_tex_btn(text: String, tex_path: String, min_size: Vector2, font_size: int, outline_col: Color) -> Button:
	var btn := Button.new()
	btn.text = text
	btn.custom_minimum_size = min_size
	btn.add_theme_font_size_override("font_size", font_size)
	btn.add_theme_color_override("font_color", Color(1.0, 0.98, 0.92))
	btn.add_theme_color_override("font_outline_color", outline_col)
	btn.add_theme_constant_override("outline_size", 4)
	var sb := StyleBoxTexture.new()
	sb.texture = load(tex_path)
	sb.texture_margin_left = 44
	sb.texture_margin_right = 44
	sb.texture_margin_top = 24
	sb.texture_margin_bottom = 24
	var sb_h := sb.duplicate()
	sb_h.modulate_color = Color(1.10, 1.08, 1.04)
	var sb_p := sb.duplicate()
	sb_p.modulate_color = Color(0.86, 0.84, 0.80)
	btn.add_theme_stylebox_override("normal", sb)
	btn.add_theme_stylebox_override("hover", sb_h)
	btn.add_theme_stylebox_override("pressed", sb_p)
	btn.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	UiFx.attach_press_bounce(btn)
	return btn


func _build_top_bar() -> void:
	var bar := PanelContainer.new()
	_top_bar = bar
	bar.set_anchors_preset(Control.PRESET_TOP_WIDE)
	bar.offset_left = 14
	bar.offset_right = -14
	bar.offset_top = 10
	bar.offset_bottom = 68
	bar.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.06, 0.07, 0.14, 0.84), Color(0.95, 0.78, 0.36, 0.58), 14, 1))
	add_child(bar)

	var mc := MarginContainer.new()
	mc.add_theme_constant_override("margin_left", 12)
	mc.add_theme_constant_override("margin_right", 12)
	mc.add_theme_constant_override("margin_top", 4)
	mc.add_theme_constant_override("margin_bottom", 4)
	bar.add_child(mc)

	var hb := HBoxContainer.new()
	hb.add_theme_constant_override("separation", 12)
	mc.add_child(hb)

	var back_btn := Button.new()
	back_btn.custom_minimum_size = Vector2(44, 44)
	back_btn.flat = true
	back_btn.pressed.connect(func() -> void: _app.navigate_to("lobby"))
	UiFx.attach_press_bounce(back_btn)
	hb.add_child(back_btn)

	var back_ic := TextureRect.new()
	back_ic.texture = load("res://assets/sprites/ui/ui_btn_back.png")
	back_ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	back_ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	back_ic.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	back_ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
	back_btn.add_child(back_ic)

	var title := Label.new()
	title.text = "HEROES & EVOLUTION"
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 21)
	title.add_theme_color_override("font_color", Color(1.0, 0.90, 0.48))
	hb.add_child(title)

	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hb.add_child(spacer)

	_gold_lbl = _make_resource_pill(hb, "res://assets/sprites/items/item_gold_coin.png", Color(1.0, 0.88, 0.42))
	_exp_lbl = _make_resource_pill(hb, "res://assets/sprites/items/res_mana_crystals.png", Color(0.68, 0.96, 1.0))


func _make_resource_pill(parent_hb: HBoxContainer, icon_path: String, text_col: Color) -> Label:
	var pill := PanelContainer.new()
	pill.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.04, 0.05, 0.11, 0.84), Color(0.75, 0.65, 0.36, 0.48), 12, 1))
	parent_hb.add_child(pill)

	var mc := MarginContainer.new()
	mc.add_theme_constant_override("margin_left", 10)
	mc.add_theme_constant_override("margin_right", 12)
	mc.add_theme_constant_override("margin_top", 3)
	mc.add_theme_constant_override("margin_bottom", 3)
	pill.add_child(mc)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	mc.add_child(row)

	var ic := TextureRect.new()
	ic.texture = load(icon_path)
	ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	ic.custom_minimum_size = Vector2(22, 22)
	ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(ic)

	var lbl := Label.new()
	lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	lbl.add_theme_font_size_override("font_size", 15)
	lbl.add_theme_color_override("font_color", text_col)
	row.add_child(lbl)
	return lbl


func _build_roster_panel() -> void:
	_roster_panel = PanelContainer.new()
	var frame_sb := StyleBoxTexture.new()
	frame_sb.texture = load("res://assets/sprites/ui/ui_showcase_panel_frame.png")
	frame_sb.texture_margin_left = 88
	frame_sb.texture_margin_right = 88
	frame_sb.texture_margin_top = 88
	frame_sb.texture_margin_bottom = 80
	frame_sb.modulate_color = Color(1.0, 1.0, 1.0, 0.94)
	_roster_panel.add_theme_stylebox_override("panel", frame_sb)
	add_child(_roster_panel)

	var mc := MarginContainer.new()
	mc.add_theme_constant_override("margin_left", 22)
	mc.add_theme_constant_override("margin_right", 22)
	mc.add_theme_constant_override("margin_top", 34)
	mc.add_theme_constant_override("margin_bottom", 24)
	_roster_panel.add_child(mc)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	mc.add_child(vbox)

	var filter_row := HBoxContainer.new()
	filter_row.add_theme_constant_override("separation", 5)
	vbox.add_child(filter_row)

	var all_btn := UiFx.make_styled_button("ALL", Color(0.28, 0.30, 0.46), Vector2(46, 32), 12)
	all_btn.pressed.connect(func() -> void:
		_filter_el = "all"
		_update_filter_styles()
		_rebuild_roster_only()
	)
	filter_row.add_child(all_btn)
	_filter_btns["all"] = all_btn

	for el in ["fire", "water", "wind", "earth", "light", "dark"]:
		var el_key: String = String(el)
		var btn := Button.new()
		btn.custom_minimum_size = Vector2(34, 34)
		btn.flat = true
		btn.pressed.connect(func() -> void:
			_filter_el = el_key
			_update_filter_styles()
			_rebuild_roster_only()
		)
		UiFx.attach_press_bounce(btn)
		filter_row.add_child(btn)

		var ic := TextureRect.new()
		ic.texture = load(String(GameData.ELEMENTS[el_key]["icon"]))
		ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		ic.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ic.offset_left = 2
		ic.offset_right = -2
		ic.offset_top = 2
		ic.offset_bottom = -2
		ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
		btn.add_child(ic)
		_filter_btns[el_key] = btn

	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	filter_row.add_child(spacer)

	_owned_count_lbl = Label.new()
	_owned_count_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_owned_count_lbl.add_theme_font_size_override("font_size", 14)
	_owned_count_lbl.add_theme_color_override("font_color", Color(0.92, 0.94, 0.98))
	filter_row.add_child(_owned_count_lbl)

	var div := TextureRect.new()
	div.texture = load("res://assets/sprites/ui/ui_divider_flower.png")
	div.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	div.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	div.custom_minimum_size = Vector2(0, 12)
	div.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vbox.add_child(div)

	var scroll := ScrollContainer.new()
	_roster_scroll = scroll
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	vbox.add_child(scroll)

	var center_wrap := CenterContainer.new()
	center_wrap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(center_wrap)

	_grid = GridContainer.new()
	_grid.columns = 3
	_grid.add_theme_constant_override("h_separation", 8)
	_grid.add_theme_constant_override("v_separation", 10)
	center_wrap.add_child(_grid)

	_update_filter_styles()


func _update_filter_styles() -> void:
	for k in _filter_btns:
		var key: String = String(k)
		var btn: Button = _filter_btns[key]
		if not is_instance_valid(btn):
			continue
		var active: bool = (_filter_el == key)
		if key == "all":
			btn.modulate = Color(1.0, 1.0, 1.0) if active else Color(0.68, 0.72, 0.84)
		else:
			btn.modulate = Color(1.18, 1.18, 1.18) if active else Color(0.55, 0.58, 0.68, 0.82)


func _rebuild_all() -> void:
	_refresh_top()
	_rebuild_roster_only()
	_rebuild_detail()


func _refresh_top() -> void:
	if is_instance_valid(_gold_lbl):
		_gold_lbl.text = _fmt_num(PlayerState.gold)
	if is_instance_valid(_exp_lbl):
		_exp_lbl.text = "EXP %s" % _fmt_num(PlayerState.exp_pool)
	if is_instance_valid(_owned_count_lbl):
		_owned_count_lbl.text = "%d/%d" % [PlayerState.owned_heroes.size(), GameData.HEROES.size()]


func _rebuild_roster_only() -> void:
	if not is_instance_valid(_grid):
		return
	for c in _grid.get_children():
		c.queue_free()

	for hid in GameData.HEROES:
		var hero_id: String = String(hid)
		var info: Dictionary = GameData.HEROES[hero_id]
		if _filter_el != "all" and String(info["element"]) != _filter_el:
			continue
		var owned: bool = PlayerState.owned_heroes.has(hero_id)
		var rec: Dictionary = PlayerState.get_hero_record(hero_id)
		var evo: String = String(rec.get("evo", "basic"))
		var rar: String = String(info["rarity"])
		var is_sel: bool = (hero_id == _selected_hero)

		var card := Button.new()
		card.custom_minimum_size = Vector2(132, 146)
		card.flat = true
		card.modulate = Color.WHITE if owned else Color(0.46, 0.48, 0.56, 0.78)
		card.pressed.connect(func() -> void:
			_selected_hero = hero_id
			_rebuild_roster_only()
			_rebuild_detail()
		)
		UiFx.attach_press_bounce(card)
		_grid.add_child(card)

		# Frame MUST be added before Portrait so Portrait renders on top of opaque frame interior.
		var frame := TextureRect.new()
		frame.name = "Frame"
		frame.texture = load(String(GameData.RARITIES[rar]["frame"]))
		frame.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		frame.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		frame.size = Vector2(132, 146)
		frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
		card.add_child(frame)

		var port := TextureRect.new()
		port.name = "Portrait"
		port.texture = load(GameData.get_hero_portrait_path(hero_id, evo))
		port.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		port.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		port.position = Vector2(21, 23)
		port.size = Vector2(90, 76)
		port.mouse_filter = Control.MOUSE_FILTER_IGNORE
		card.add_child(port)

		var el_ic := TextureRect.new()
		el_ic.texture = load(String(GameData.ELEMENTS[String(info["element"])]["icon"]))
		el_ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		el_ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		el_ic.position = Vector2(99, 8)
		el_ic.size = Vector2(25, 25)
		el_ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
		card.add_child(el_ic)

		if is_sel:
			var sel_ring := TextureRect.new()
			sel_ring.texture = load("res://assets/sprites/ui/ui_selection_glow_frame.png")
			sel_ring.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			sel_ring.stretch_mode = TextureRect.STRETCH_SCALE
			sel_ring.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
			sel_ring.offset_left = -5
			sel_ring.offset_right = 5
			sel_ring.offset_top = -5
			sel_ring.offset_bottom = 5
			sel_ring.mouse_filter = Control.MOUSE_FILTER_IGNORE
			card.add_child(sel_ring)

		var lbl := Label.new()
		lbl.text = ("%s\nLv.%d" % [GameData.get_hero_display_name(hero_id, evo), int(rec.get("level", 1))]) if owned else ("LOCKED\n????")
		lbl.position = Vector2(6, 104)
		lbl.size = Vector2(120, 36)
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		lbl.clip_text = true
		lbl.add_theme_font_size_override("font_size", 11)
		lbl.add_theme_color_override("font_color", Color(1.0, 0.94, 0.56) if is_sel else Color.WHITE)
		lbl.add_theme_color_override("font_outline_color", Color.BLACK)
		lbl.add_theme_constant_override("outline_size", 3)
		card.add_child(lbl)


func _rebuild_detail() -> void:
	if not is_instance_valid(_detail_host):
		return
	for c in _detail_host.get_children():
		c.queue_free()

	var info: Dictionary = GameData.HEROES.get(_selected_hero, GameData.HEROES["knight"])
	var owned: bool = PlayerState.owned_heroes.has(_selected_hero)
	var rec: Dictionary = PlayerState.get_hero_record(_selected_hero)
	var lv: int = int(rec.get("level", 1))
	var stars: int = int(rec.get("stars", 1))
	var shards: int = int(rec.get("shards", 0))
	var evo: String = String(rec.get("evo", "basic"))
	var rar: String = String(info["rarity"])
	var el_id: String = String(info["element"])
	var el_col: Color = GameData.ELEMENTS[el_id]["color"]
	var rar_col: Color = GameData.RARITIES[rar]["color"]
	var st: Dictionary = GameData.get_hero_stats(_selected_hero, lv, stars, evo)
	var sk: Dictionary = GameData.get_hero_skill_info(_selected_hero, evo)

	if is_instance_valid(_bg_showcase):
		_bg_showcase.texture = load(GameData.get_showcase_bg_path(el_id))

	var mc := MarginContainer.new()
	mc.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mc.add_theme_constant_override("margin_left", 6)
	mc.add_theme_constant_override("margin_right", 6)
	mc.add_theme_constant_override("margin_top", 2)
	mc.add_theme_constant_override("margin_bottom", 4)
	_detail_host.add_child(mc)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	mc.add_child(vbox)

	# 1. Floating Header: Hero Name [Rarity] + Glossy Stars | Lv.X / 50   POWER X   Shards: X
	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 10)
	vbox.add_child(header)

	var d_name := Label.new()
	d_name.text = GameData.get_hero_display_name(_selected_hero, evo).to_upper()
	d_name.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	d_name.add_theme_font_size_override("font_size", 25)
	d_name.add_theme_color_override("font_color", Color(1.0, 0.95, 0.72))
	d_name.add_theme_color_override("font_outline_color", Color(0.03, 0.03, 0.08, 0.96))
	d_name.add_theme_constant_override("outline_size", 5)
	header.add_child(d_name)

	var rar_pill := PanelContainer.new()
	rar_pill.add_theme_stylebox_override("panel", UiFx.make_panel_style(rar_col.darkened(0.62), Color(rar_col.r, rar_col.g, rar_col.b, 0.92), 8, 1))
	header.add_child(rar_pill)
	var rar_mc := MarginContainer.new()
	rar_mc.add_theme_constant_override("margin_left", 8)
	rar_mc.add_theme_constant_override("margin_right", 8)
	rar_mc.add_theme_constant_override("margin_top", 2)
	rar_mc.add_theme_constant_override("margin_bottom", 2)
	rar_pill.add_child(rar_mc)
	var rar_lbl := Label.new()
	rar_lbl.text = rar
	rar_lbl.add_theme_font_size_override("font_size", 13)
	rar_lbl.add_theme_color_override("font_color", rar_col.lightened(0.38))
	rar_mc.add_child(rar_lbl)

	var stars_hb := HBoxContainer.new()
	stars_hb.alignment = BoxContainer.ALIGNMENT_CENTER
	stars_hb.add_theme_constant_override("separation", 2)
	header.add_child(stars_hb)
	var star_full_tex: Texture2D = load("res://assets/sprites/ui/ui_star_filled.png")
	var star_empty_tex: Texture2D = load("res://assets/sprites/ui/ui_star_empty.png")
	for si in 3:
		var st_ic := TextureRect.new()
		st_ic.texture = star_full_tex if si < stars else star_empty_tex
		st_ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		st_ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		st_ic.custom_minimum_size = Vector2(20, 20)
		st_ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
		stars_hb.add_child(st_ic)

	var h_spacer := Control.new()
	h_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h_spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	header.add_child(h_spacer)

	var lv_hdr := Label.new()
	lv_hdr.text = "Lv.%d / 50" % lv
	lv_hdr.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	lv_hdr.add_theme_font_size_override("font_size", 15)
	lv_hdr.add_theme_color_override("font_color", Color(0.86, 0.94, 1.0))
	lv_hdr.add_theme_color_override("font_outline_color", Color(0.03, 0.03, 0.08, 0.95))
	lv_hdr.add_theme_constant_override("outline_size", 3)
	header.add_child(lv_hdr)

	var pwr_hdr := Label.new()
	pwr_hdr.text = "POWER %s" % _fmt_num(int(st["power"]))
	pwr_hdr.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	pwr_hdr.add_theme_font_size_override("font_size", 16)
	pwr_hdr.add_theme_color_override("font_color", Color(1.0, 0.86, 0.34))
	pwr_hdr.add_theme_color_override("font_outline_color", Color(0.03, 0.03, 0.08, 0.95))
	pwr_hdr.add_theme_constant_override("outline_size", 4)
	header.add_child(pwr_hdr)

	var shard_hdr := Label.new()
	shard_hdr.text = "Shards: %d" % shards
	shard_hdr.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	shard_hdr.add_theme_font_size_override("font_size", 14)
	shard_hdr.add_theme_color_override("font_color", Color(0.82, 0.88, 0.96))
	shard_hdr.add_theme_color_override("font_outline_color", Color(0.03, 0.03, 0.08, 0.95))
	shard_hdr.add_theme_constant_override("outline_size", 3)
	header.add_child(shard_hdr)

	var hdr_div := TextureRect.new()
	hdr_div.texture = load("res://assets/sprites/ui/ui_divider_gem.png")
	hdr_div.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	hdr_div.stretch_mode = TextureRect.STRETCH_SCALE
	hdr_div.custom_minimum_size = Vector2(0, 18)
	hdr_div.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vbox.add_child(hdr_div)

	# 2. Open Showcase Middle Row: Pedestal + High-Res Standee (~58%) | Floating Info Cards (~42%)
	var center_row := HBoxContainer.new()
	center_row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	center_row.add_theme_constant_override("separation", 12)
	vbox.add_child(center_row)

	var stage_host := Control.new()
	stage_host.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	stage_host.size_flags_vertical = Control.SIZE_EXPAND_FILL
	stage_host.size_flags_stretch_ratio = 1.55
	stage_host.clip_contents = true
	stage_host.mouse_filter = Control.MOUSE_FILTER_IGNORE
	center_row.add_child(stage_host)

	# Rarity glow halo behind hero
	var rar_alpha: float = 0.16 if rar == "R" else (0.24 if rar == "SR" else (0.32 if rar == "SSR" else 0.42))
	var aura_grad := Gradient.new()
	aura_grad.colors = PackedColorArray([
		Color(rar_col.r, rar_col.g, rar_col.b, rar_alpha),
		Color(el_col.r, el_col.g, el_col.b, 0.14),
		Color(el_col.r, el_col.g, el_col.b, 0.0),
	])
	aura_grad.offsets = PackedFloat32Array([0.0, 0.48, 1.0])
	var aura_tex := GradientTexture2D.new()
	aura_tex.gradient = aura_grad
	aura_tex.fill = GradientTexture2D.FILL_RADIAL
	aura_tex.fill_from = Vector2(0.5, 0.48)
	aura_tex.fill_to = Vector2(0.5, 0.04)

	var aura_bg := TextureRect.new()
	aura_bg.texture = aura_tex
	aura_bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	aura_bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	aura_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage_host.add_child(aura_bg)

	# Matching Elemental Showcase Pedestal at base
	var pedestal := TextureRect.new()
	pedestal.texture = load(GameData.get_showcase_pedestal_path(el_id))
	pedestal.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	pedestal.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	pedestal.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	pedestal.offset_top = -152
	pedestal.offset_bottom = 0
	pedestal.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if not owned:
		pedestal.modulate = Color(0.55, 0.58, 0.68, 0.85)
	stage_host.add_child(pedestal)

	# High-Resolution Hero Standee dominating ~78% of stage height!
	var standee := TextureRect.new()
	standee.name = "HeroStandee"
	standee.texture = load(GameData.get_hero_standee_path(_selected_hero))
	standee.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	standee.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	standee.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	standee.offset_left = 10
	standee.offset_right = -10
	standee.offset_top = 4
	standee.offset_bottom = -48
	standee.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if not owned:
		standee.modulate = Color(0.45, 0.48, 0.58, 0.88)
	elif _selected_hero == "knight" and evo == "fire":
		standee.modulate = Color(1.06, 0.92, 0.86)
	elif _selected_hero == "knight" and evo == "holy":
		standee.modulate = Color(1.05, 1.03, 0.90)
	stage_host.add_child(standee)

	# Gentle serene idle float on standee
	var st_tw := standee.create_tween().set_loops()
	st_tw.tween_property(standee, "offset_top", 0.0, 1.8).set_trans(Tween.TRANS_SINE)
	st_tw.parallel().tween_property(standee, "offset_bottom", -48.0, 1.8).set_trans(Tween.TRANS_SINE)
	st_tw.tween_property(standee, "offset_top", 8.0, 1.8).set_trans(Tween.TRANS_SINE)
	st_tw.parallel().tween_property(standee, "offset_bottom", -40.0, 1.8).set_trans(Tween.TRANS_SINE)

	# On-demand UnitVisual viewport for live [PREVIEW SKILL] & Upgrade VFX!
	var stage_view := SubViewportContainer.new()
	stage_view.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	stage_view.stretch = true
	stage_view.visible = false
	stage_view.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage_host.add_child(stage_view)

	var stage := SubViewport.new()
	stage.transparent_bg = true
	stage_view.add_child(stage)

	var stage_world := Node2D.new()
	stage.add_child(stage_world)

	var vis := UnitVisual.new()
	vis.facing_sign = 1.0
	vis.unit_scale = 2.4
	vis.idle_speed_scale = 0.85
	vis.position = Vector2(200, 320)
	stage_world.add_child(vis)
	vis.configure_animations(GameData.get_hero_anim_map(_selected_hero, evo))
	if _selected_hero == "knight" and evo == "fire":
		vis.set_aura(Color(1.0, 0.36, 0.14), true)
	elif _selected_hero == "knight" and evo == "holy":
		vis.set_aura(Color(1.0, 0.88, 0.32), true)

	var target := Marker2D.new()
	target.position = Vector2(360, 190)
	stage_world.add_child(target)

	var sync_stage := func() -> void:
		if not is_instance_valid(stage_view) or not is_instance_valid(vis):
			return
		var sw: float = maxf(stage_view.size.x, 220.0)
		var sh: float = maxf(stage_view.size.y, 200.0)
		var new_scale: float = clampf((sh * 0.70) / 104.0, 1.50, 2.90)
		var foot_pos := Vector2(sw * 0.48, sh * 0.84)
		vis.unit_scale = new_scale
		vis.position = foot_pos
		vis.home_position = foot_pos
		var piv: Node2D = vis.get_node_or_null("VisualPivot")
		if piv != null:
			piv.scale = Vector2(new_scale, new_scale)
		target.position = Vector2(sw * 0.88, sh * 0.50)

	stage_view.resized.connect(sync_stage)
	sync_stage.call_deferred()

	var ranged: bool = String(info["range"]) == "ranged"
	var preview_hero: String = _selected_hero
	vis.impact_hit.connect(func(_skill: bool) -> void:
		var show_impact := func() -> void:
			vis.spawn_vfx_sprite(String(sk["vfx"]), vis.to_local(target.global_position), 0.78)
		if ranged:
			vis.fire_projectile(target, Vector2.ZERO, preview_hero, el_id, true, show_impact)
		else:
			show_impact.call()
	)
	vis.action_finished.connect(func() -> void:
		if is_instance_valid(stage_view) and is_instance_valid(standee):
			stage_view.visible = false
			standee.visible = true
	)

	# Right floating glassmorphic Info Stack (~42% width)
	var info_stack := VBoxContainer.new()
	info_stack.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info_stack.size_flags_vertical = Control.SIZE_EXPAND_FILL
	info_stack.size_flags_stretch_ratio = 1.0
	info_stack.custom_minimum_size = Vector2(258, 0)
	info_stack.alignment = BoxContainer.ALIGNMENT_CENTER
	info_stack.add_theme_constant_override("separation", 10)
	center_row.add_child(info_stack)

	# Card 1: Attributes Card
	var attr_panel := PanelContainer.new()
	attr_panel.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.05, 0.06, 0.13, 0.80), Color(0.86, 0.72, 0.38, 0.48), 14, 1))
	info_stack.add_child(attr_panel)

	var attr_mc := MarginContainer.new()
	attr_mc.add_theme_constant_override("margin_left", 14)
	attr_mc.add_theme_constant_override("margin_right", 14)
	attr_mc.add_theme_constant_override("margin_top", 10)
	attr_mc.add_theme_constant_override("margin_bottom", 10)
	attr_panel.add_child(attr_mc)

	var attr_vbox := VBoxContainer.new()
	attr_vbox.add_theme_constant_override("separation", 6)
	attr_mc.add_child(attr_vbox)

	var attr_hdr := HBoxContainer.new()
	attr_hdr.add_theme_constant_override("separation", 6)
	attr_vbox.add_child(attr_hdr)

	var attr_title := Label.new()
	attr_title.text = "ATTRIBUTES"
	attr_title.add_theme_font_size_override("font_size", 13)
	attr_title.add_theme_color_override("font_color", Color(0.98, 0.86, 0.50))
	attr_hdr.add_child(attr_title)

	var attr_hdr_sp := Control.new()
	attr_hdr_sp.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	attr_hdr_sp.mouse_filter = Control.MOUSE_FILTER_IGNORE
	attr_hdr.add_child(attr_hdr_sp)

	var el_badge := TextureRect.new()
	el_badge.texture = load(String(GameData.ELEMENTS[el_id]["icon"]))
	el_badge.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	el_badge.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	el_badge.custom_minimum_size = Vector2(18, 18)
	el_badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	attr_hdr.add_child(el_badge)

	var role_lbl := Label.new()
	role_lbl.text = "%s • %s" % [String(GameData.ELEMENTS[el_id]["name"]), String(info["role"]).capitalize()]
	role_lbl.add_theme_font_size_override("font_size", 12)
	role_lbl.add_theme_color_override("font_color", Color(0.78, 0.86, 0.96))
	attr_hdr.add_child(role_lbl)

	var attr_div := TextureRect.new()
	attr_div.texture = load("res://assets/sprites/ui/ui_divider_flower.png")
	attr_div.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	attr_div.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	attr_div.custom_minimum_size = Vector2(0, 10)
	attr_div.mouse_filter = Control.MOUSE_FILTER_IGNORE
	attr_vbox.add_child(attr_div)

	var stat_rows: Array = [
		["HP", _fmt_num(int(st["hp"]))],
		["ATK", _fmt_num(int(st["atk"]))],
		["DEF", _fmt_num(int(st["def"]))],
		["SPD", _fmt_num(int(st["spd"]))],
	]
	for sr in stat_rows:
		var r_hb := HBoxContainer.new()
		attr_vbox.add_child(r_hb)

		var k_lbl := Label.new()
		k_lbl.text = String(sr[0])
		k_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		k_lbl.add_theme_font_size_override("font_size", 14)
		k_lbl.add_theme_color_override("font_color", Color(0.72, 0.78, 0.90))
		r_hb.add_child(k_lbl)

		var v_lbl := Label.new()
		v_lbl.text = String(sr[1])
		v_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		v_lbl.add_theme_font_size_override("font_size", 16)
		v_lbl.add_theme_color_override("font_color", Color(0.96, 0.98, 1.0))
		r_hb.add_child(v_lbl)

	# Card 2: Active Skill Card
	var sk_panel := PanelContainer.new()
	sk_panel.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.05, 0.06, 0.13, 0.80), Color(el_col.r, el_col.g, el_col.b, 0.48), 14, 1))
	info_stack.add_child(sk_panel)

	var sk_mc := MarginContainer.new()
	sk_mc.add_theme_constant_override("margin_left", 14)
	sk_mc.add_theme_constant_override("margin_right", 14)
	sk_mc.add_theme_constant_override("margin_top", 10)
	sk_mc.add_theme_constant_override("margin_bottom", 10)
	sk_panel.add_child(sk_mc)

	var sk_vbox := VBoxContainer.new()
	sk_vbox.add_theme_constant_override("separation", 8)
	sk_mc.add_child(sk_vbox)

	var sk_top := HBoxContainer.new()
	sk_top.add_theme_constant_override("separation", 10)
	sk_vbox.add_child(sk_top)

	var sk_ic := TextureRect.new()
	sk_ic.texture = load(String(sk["icon"]))
	sk_ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	sk_ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	sk_ic.custom_minimum_size = Vector2(42, 42)
	sk_ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
	sk_top.add_child(sk_ic)

	var sk_names := VBoxContainer.new()
	sk_names.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sk_names.add_theme_constant_override("separation", 1)
	sk_top.add_child(sk_names)

	var sk_tag := Label.new()
	sk_tag.text = "ACTIVE SKILL"
	sk_tag.add_theme_font_size_override("font_size", 10)
	sk_tag.add_theme_color_override("font_color", Color(0.68, 0.78, 0.92))
	sk_names.add_child(sk_tag)

	var sk_title := Label.new()
	sk_title.text = String(sk["name"])
	sk_title.add_theme_font_size_override("font_size", 15)
	sk_title.add_theme_color_override("font_color", Color(1.0, 0.88, 0.44))
	sk_names.add_child(sk_title)

	var sk_desc := Label.new()
	sk_desc.text = String(sk["desc"])
	sk_desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	sk_desc.add_theme_font_size_override("font_size", 12)
	sk_desc.add_theme_color_override("font_color", Color(0.88, 0.89, 0.86))
	sk_vbox.add_child(sk_desc)

	var preview_btn := _make_tex_btn("PREVIEW SKILL", "res://assets/sprites/ui/ui_btn_blue.png", Vector2(0, 42), 13, Color(0.05, 0.14, 0.34))
	preview_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	preview_btn.pressed.connect(func() -> void:
		standee.visible = false
		stage_view.visible = true
		sync_stage.call()
		var destination: Vector2 = vis.global_position if ranged else vis.global_position + Vector2(22.0, 0.0)
		vis.play_action(true, destination, false, ranged)
	)
	sk_vbox.add_child(preview_btn)

	# 3. USP Branching Evolution Strip (Knight only, when owned)
	if owned and _selected_hero == "knight":
		var evo_panel := PanelContainer.new()
		evo_panel.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.08, 0.07, 0.17, 0.82), Color(0.95, 0.78, 0.36, 0.56), 12, 1))
		vbox.add_child(evo_panel)

		var evo_mc := MarginContainer.new()
		evo_mc.add_theme_constant_override("margin_left", 10)
		evo_mc.add_theme_constant_override("margin_right", 10)
		evo_mc.add_theme_constant_override("margin_top", 6)
		evo_mc.add_theme_constant_override("margin_bottom", 8)
		evo_panel.add_child(evo_mc)

		var evo_vbox := VBoxContainer.new()
		evo_vbox.add_theme_constant_override("separation", 6)
		evo_mc.add_child(evo_vbox)

		var evo_hdr := HBoxContainer.new()
		evo_vbox.add_child(evo_hdr)

		var evo_title := Label.new()
		evo_title.text = "EVOLUTION TREE"
		evo_title.add_theme_font_size_override("font_size", 12)
		evo_title.add_theme_color_override("font_color", Color(1.0, 0.86, 0.42))
		evo_hdr.add_child(evo_title)

		var evo_sp := Control.new()
		evo_sp.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		evo_sp.mouse_filter = Control.MOUSE_FILTER_IGNORE
		evo_hdr.add_child(evo_sp)

		var tip := Label.new()
		tip.text = String(GameData.KNIGHT_EVOLUTIONS[evo]["ai_label"])
		tip.add_theme_font_size_override("font_size", 11)
		tip.add_theme_color_override("font_color", Color(0.76, 0.96, 1.0))
		evo_hdr.add_child(tip)

		var evo_btns := HBoxContainer.new()
		evo_btns.add_theme_constant_override("separation", 8)
		evo_vbox.add_child(evo_btns)

		var adv_btn := UiFx.make_styled_button(
			"Iron Knight (Lv.5 · 1,200 G)",
			Color(0.28, 0.42, 0.68) if evo != "advance" else Color(0.36, 0.56, 0.86),
			Vector2(0, 36), 11
		)
		adv_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		adv_btn.pressed.connect(func() -> void:
			if PlayerState.evolve_hero("knight", "advance"):
				AudioManager.play_sfx("gacha_ssr")
		)
		evo_btns.add_child(adv_btn)

		var fire_btn := UiFx.make_styled_button(
			"Fire Knight · AoE AI (Lv.10 · 2,500 G)",
			Color(0.72, 0.24, 0.16) if evo != "fire" else Color(0.92, 0.34, 0.20),
			Vector2(0, 36), 11
		)
		fire_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		fire_btn.pressed.connect(func() -> void:
			if PlayerState.evolve_hero("knight", "fire"):
				AudioManager.play_sfx("gacha_ssr")
		)
		evo_btns.add_child(fire_btn)

		var holy_btn := UiFx.make_styled_button(
			"Holy Guardian · Protect AI (Lv.10 · 2,500 G)",
			Color(0.74, 0.56, 0.14) if evo != "holy" else Color(0.94, 0.72, 0.20),
			Vector2(0, 36), 11
		)
		holy_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		holy_btn.pressed.connect(func() -> void:
			if PlayerState.evolve_hero("knight", "holy"):
				AudioManager.play_sfx("gacha_ssr")
		)
		evo_btns.add_child(holy_btn)

	# 4. Prominent Bottom Action Bar
	if not owned:
		var lock_panel := PanelContainer.new()
		lock_panel.custom_minimum_size = Vector2(0, 52)
		lock_panel.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.10, 0.07, 0.12, 0.82), Color(0.95, 0.52, 0.44, 0.55), 14, 1))
		vbox.add_child(lock_panel)

		var lock_lbl := Label.new()
		lock_lbl.text = "Triệu hồi tướng này ở Summon Portal để mở khóa!"
		lock_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lock_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		lock_lbl.add_theme_font_size_override("font_size", 16)
		lock_lbl.add_theme_color_override("font_color", Color(1.0, 0.72, 0.62))
		lock_panel.add_child(lock_lbl)
		return

	var action_hb := HBoxContainer.new()
	action_hb.add_theme_constant_override("separation", 14)
	vbox.add_child(action_hb)

	var lv_cost: Dictionary = PlayerState.get_level_cost(lv)
	var sh_need: int = PlayerState.get_star_shard_cost(stars)

	var lv_btn := _make_tex_btn(
		"LEVEL UP  (%s G / %s EXP)" % [_fmt_num(int(lv_cost["gold"])), _fmt_num(int(lv_cost["exp"]))] if lv < 50 else "MAX LEVEL",
		"res://assets/sprites/ui/ui_btn_green.png", Vector2(0, 54), 14, Color(0.05, 0.24, 0.10)
	)
	lv_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lv_btn.pressed.connect(func() -> void:
		if PlayerState.level_up_hero(_selected_hero):
			AudioManager.play_sfx("level_up")
	)
	action_hb.add_child(lv_btn)

	var star_btn := _make_tex_btn(
		"★ STAR UP  (%d/%d Shards)" % [shards, sh_need] if stars < 3 else "MAX STARS (★★★)",
		"res://assets/sprites/ui/ui_btn_gold.png", Vector2(0, 54), 14, Color(0.30, 0.14, 0.02)
	)
	star_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	star_btn.pressed.connect(func() -> void:
		if PlayerState.star_up_hero(_selected_hero):
			AudioManager.play_sfx("gacha_ssr")
	)
	action_hb.add_child(star_btn)


func _layout() -> void:
	if not is_instance_valid(_roster_panel) or not is_instance_valid(_detail_host):
		return
	var top_y: float = 76.0
	var pad: float = 14.0
	var gap: float = 14.0
	var usable_w: float = maxf(size.x - pad * 2.0, 320.0)
	var usable_h: float = maxf(size.y - top_y - pad, 300.0)

	if UiFx.is_wide(size):
		var left_w: float = floorf((usable_w - gap) * 0.40)
		var right_w: float = usable_w - gap - left_w
		_roster_panel.position = Vector2(pad, top_y)
		_roster_panel.size = Vector2(left_w, usable_h)
		_detail_host.position = Vector2(pad + left_w + gap, top_y)
		_detail_host.size = Vector2(right_w, usable_h)
		if is_instance_valid(_grid):
			_grid.columns = 3
	else:
		var top_h: float = floorf((usable_h - gap) * 0.36)
		_roster_panel.position = Vector2(pad, top_y)
		_roster_panel.size = Vector2(usable_w, top_h)
		_detail_host.position = Vector2(pad, top_y + top_h + gap)
		_detail_host.size = Vector2(usable_w, usable_h - top_h - gap)
		if is_instance_valid(_grid):
			_grid.columns = 4
