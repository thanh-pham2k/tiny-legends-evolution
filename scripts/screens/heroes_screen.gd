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
var _el_bg_glow: TextureRect
var _filter_btns: Dictionary = {}


func setup_screen(app: Control, params: Dictionary = {}) -> void:
	_app = app
	if params.has("hero_id"):
		_selected_hero = String(params["hero_id"])


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	PlayerState.roster_changed.connect(_rebuild_all)
	PlayerState.resources_changed.connect(_refresh_top)

	var bg := TextureRect.new()
	bg.texture = load("res://assets/sprites/backgrounds/bg_hero_detail_starry.png")
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	var shade := ColorRect.new()
	shade.color = Color(0.03, 0.04, 0.09, 0.62)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(shade)

	_el_bg_glow = TextureRect.new()
	_el_bg_glow.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_el_bg_glow.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_el_bg_glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_el_bg_glow)

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


func _update_bg_element_glow(el_col: Color) -> void:
	if not is_instance_valid(_el_bg_glow):
		return
	var grad := Gradient.new()
	grad.colors = PackedColorArray([
		Color(el_col.r, el_col.g, el_col.b, 0.28),
		Color(el_col.r, el_col.g, el_col.b, 0.09),
		Color(el_col.r, el_col.g, el_col.b, 0.0),
	])
	grad.offsets = PackedFloat32Array([0.0, 0.48, 1.0])
	var gtex := GradientTexture2D.new()
	gtex.gradient = grad
	gtex.fill = GradientTexture2D.FILL_RADIAL
	gtex.fill_from = Vector2(0.64, 0.50)
	gtex.fill_to = Vector2(0.64, 0.0)
	_el_bg_glow.texture = gtex


func _build_top_bar() -> void:
	var bar := PanelContainer.new()
	_top_bar = bar
	bar.set_anchors_preset(Control.PRESET_TOP_WIDE)
	bar.offset_left = 14
	bar.offset_right = -14
	bar.offset_top = 10
	bar.offset_bottom = 68
	bar.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.06, 0.07, 0.14, 0.82), Color(0.95, 0.78, 0.36, 0.55), 14, 1))
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
	pill.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.04, 0.05, 0.11, 0.80), Color(0.75, 0.65, 0.36, 0.45), 12, 1))
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
	_roster_panel.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.06, 0.07, 0.14, 0.78), Color(0.48, 0.52, 0.72, 0.36), 16, 1))
	add_child(_roster_panel)

	var mc := MarginContainer.new()
	mc.add_theme_constant_override("margin_left", 12)
	mc.add_theme_constant_override("margin_right", 12)
	mc.add_theme_constant_override("margin_top", 10)
	mc.add_theme_constant_override("margin_bottom", 10)
	_roster_panel.add_child(mc)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	mc.add_child(vbox)

	var filter_row := HBoxContainer.new()
	filter_row.add_theme_constant_override("separation", 6)
	vbox.add_child(filter_row)

	var all_btn := UiFx.make_styled_button("ALL", Color(0.28, 0.30, 0.46), Vector2(50, 34), 13)
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
		btn.custom_minimum_size = Vector2(36, 36)
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
		ic.offset_left = 3
		ic.offset_right = -3
		ic.offset_top = 3
		ic.offset_bottom = -3
		ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
		btn.add_child(ic)
		_filter_btns[el_key] = btn

	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	filter_row.add_child(spacer)

	_owned_count_lbl = Label.new()
	_owned_count_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_owned_count_lbl.add_theme_font_size_override("font_size", 15)
	_owned_count_lbl.add_theme_color_override("font_color", Color(0.88, 0.90, 0.96))
	filter_row.add_child(_owned_count_lbl)

	var div := ColorRect.new()
	div.custom_minimum_size = Vector2(0, 1)
	div.color = Color(1.0, 1.0, 1.0, 0.14)
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
	_grid.add_theme_constant_override("h_separation", 10)
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
		card.custom_minimum_size = Vector2(138, 152)
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
		frame.size = Vector2(138, 152)
		frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
		card.add_child(frame)

		var port := TextureRect.new()
		port.name = "Portrait"
		port.texture = load(GameData.get_hero_portrait_path(hero_id, evo))
		port.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		port.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		port.position = Vector2(22, 24)
		port.size = Vector2(94, 80)
		port.mouse_filter = Control.MOUSE_FILTER_IGNORE
		card.add_child(port)

		var el_ic := TextureRect.new()
		el_ic.texture = load(String(GameData.ELEMENTS[String(info["element"])]["icon"]))
		el_ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		el_ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		el_ic.position = Vector2(104, 8)
		el_ic.size = Vector2(26, 26)
		el_ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
		card.add_child(el_ic)

		if is_sel:
			var sel_ring := Panel.new()
			sel_ring.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
			sel_ring.mouse_filter = Control.MOUSE_FILTER_IGNORE
			sel_ring.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0, 0, 0, 0), Color(1.0, 0.90, 0.38, 0.95), 14, 3))
			card.add_child(sel_ring)

		var lbl := Label.new()
		lbl.text = ("%s\nLv.%d" % [GameData.get_hero_display_name(hero_id, evo), int(rec.get("level", 1))]) if owned else ("LOCKED\n????")
		lbl.position = Vector2(6, 108)
		lbl.size = Vector2(126, 38)
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

	_update_bg_element_glow(el_col)

	var mc := MarginContainer.new()
	mc.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mc.add_theme_constant_override("margin_left", 8)
	mc.add_theme_constant_override("margin_right", 8)
	mc.add_theme_constant_override("margin_top", 4)
	mc.add_theme_constant_override("margin_bottom", 4)
	_detail_host.add_child(mc)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	mc.add_child(vbox)

	# 1. Floating Cinematic Header: Hero Name [Rarity] ★  |  Lv.X / 50   POWER X   Shards: X
	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 10)
	vbox.add_child(header)

	var d_name := Label.new()
	d_name.text = GameData.get_hero_display_name(_selected_hero, evo).to_upper()
	d_name.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	d_name.add_theme_font_size_override("font_size", 26)
	d_name.add_theme_color_override("font_color", Color(1.0, 0.95, 0.72))
	d_name.add_theme_color_override("font_outline_color", Color(0.03, 0.03, 0.08, 0.95))
	d_name.add_theme_constant_override("outline_size", 4)
	header.add_child(d_name)

	var rar_pill := PanelContainer.new()
	rar_pill.add_theme_stylebox_override("panel", UiFx.make_panel_style(rar_col.darkened(0.62), Color(rar_col.r, rar_col.g, rar_col.b, 0.90), 8, 1))
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

	var stars_lbl := Label.new()
	stars_lbl.text = "★".repeat(stars)
	stars_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	stars_lbl.add_theme_font_size_override("font_size", 18)
	stars_lbl.add_theme_color_override("font_color", Color(1.0, 0.84, 0.28))
	stars_lbl.add_theme_color_override("font_outline_color", Color(0.03, 0.03, 0.08, 0.95))
	stars_lbl.add_theme_constant_override("outline_size", 3)
	header.add_child(stars_lbl)

	var h_spacer := Control.new()
	h_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h_spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	header.add_child(h_spacer)

	var lv_hdr := Label.new()
	lv_hdr.text = "Lv.%d / 50" % lv
	lv_hdr.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	lv_hdr.add_theme_font_size_override("font_size", 15)
	lv_hdr.add_theme_color_override("font_color", Color(0.84, 0.93, 1.0))
	lv_hdr.add_theme_color_override("font_outline_color", Color(0.03, 0.03, 0.08, 0.95))
	lv_hdr.add_theme_constant_override("outline_size", 3)
	header.add_child(lv_hdr)

	var pwr_hdr := Label.new()
	pwr_hdr.text = "POWER %s" % _fmt_num(int(st["power"]))
	pwr_hdr.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	pwr_hdr.add_theme_font_size_override("font_size", 16)
	pwr_hdr.add_theme_color_override("font_color", Color(1.0, 0.86, 0.34))
	pwr_hdr.add_theme_color_override("font_outline_color", Color(0.03, 0.03, 0.08, 0.95))
	pwr_hdr.add_theme_constant_override("outline_size", 3)
	header.add_child(pwr_hdr)

	var shard_hdr := Label.new()
	shard_hdr.text = "Shards: %d" % shards
	shard_hdr.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	shard_hdr.add_theme_font_size_override("font_size", 14)
	shard_hdr.add_theme_color_override("font_color", Color(0.78, 0.84, 0.94))
	shard_hdr.add_theme_color_override("font_outline_color", Color(0.03, 0.03, 0.08, 0.95))
	shard_hdr.add_theme_constant_override("outline_size", 2)
	header.add_child(shard_hdr)

	var div := ColorRect.new()
	div.custom_minimum_size = Vector2(0, 2)
	div.color = Color(rar_col.r, rar_col.g, rar_col.b, 0.45)
	div.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vbox.add_child(div)

	# 2. Open Showcase Middle Row: Borderless Live Character (~58%) + Floating Glass Info Stack (~42%)
	var center_row := HBoxContainer.new()
	center_row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	center_row.add_theme_constant_override("separation", 14)
	vbox.add_child(center_row)

	# Open borderless hero stage (no rectangular card frame)
	var stage_host := Control.new()
	stage_host.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	stage_host.size_flags_vertical = Control.SIZE_EXPAND_FILL
	stage_host.size_flags_stretch_ratio = 1.55
	stage_host.clip_contents = true
	stage_host.mouse_filter = Control.MOUSE_FILTER_IGNORE
	center_row.add_child(stage_host)

	# Rarity aura intensity behind hero
	var rar_alpha: float = 0.14
	match rar:
		"SR":
			rar_alpha = 0.22
		"SSR":
			rar_alpha = 0.30
		"UR":
			rar_alpha = 0.38

	var aura_grad := Gradient.new()
	aura_grad.colors = PackedColorArray([
		Color(rar_col.r, rar_col.g, rar_col.b, rar_alpha),
		Color(el_col.r, el_col.g, el_col.b, 0.14),
		Color(el_col.r, el_col.g, el_col.b, 0.0),
	])
	aura_grad.offsets = PackedFloat32Array([0.0, 0.46, 1.0])
	var aura_tex := GradientTexture2D.new()
	aura_tex.gradient = aura_grad
	aura_tex.fill = GradientTexture2D.FILL_RADIAL
	aura_tex.fill_from = Vector2(0.5, 0.54)
	aura_tex.fill_to = Vector2(0.5, 0.04)

	var aura_bg := TextureRect.new()
	aura_bg.texture = aura_tex
	aura_bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	aura_bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	aura_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage_host.add_child(aura_bg)

	# Faint rotating vertical magic seal behind hero
	var back_seal := TextureRect.new()
	back_seal.texture = load("res://assets/sprites/vfx/vfx_arcane_circle.png")
	back_seal.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	back_seal.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	back_seal.modulate = Color(el_col.r, el_col.g, el_col.b, 0.17)
	back_seal.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	back_seal.offset_left = -145
	back_seal.offset_right = 145
	back_seal.offset_top = -155
	back_seal.offset_bottom = 135
	back_seal.pivot_offset = Vector2(145, 145)
	back_seal.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage_host.add_child(back_seal)

	var seal_tw := back_seal.create_tween().set_loops()
	seal_tw.tween_property(back_seal, "rotation", TAU, 32.0)

	var stage_view := SubViewportContainer.new()
	stage_view.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	stage_view.stretch = true
	stage_view.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage_host.add_child(stage_view)

	var stage := SubViewport.new()
	stage.transparent_bg = true
	stage_view.add_child(stage)

	var stage_world := Node2D.new()
	stage.add_child(stage_world)

	# Isometric perspective magic pedestal under hero's feet
	var pedestal_wrap := Node2D.new()
	pedestal_wrap.position = Vector2(210, 320)
	pedestal_wrap.scale = Vector2(1.0, 0.34)
	stage_world.add_child(pedestal_wrap)

	var floor_ring := Sprite2D.new()
	floor_ring.texture = load("res://assets/sprites/vfx/vfx_arcane_circle.png")
	floor_ring.modulate = Color(el_col.r, el_col.g, el_col.b, 0.44)
	floor_ring.scale = Vector2(1.05, 1.05)
	pedestal_wrap.add_child(floor_ring)

	var ring_tw := floor_ring.create_tween().set_loops()
	ring_tw.tween_property(floor_ring, "rotation", -TAU, 28.0)

	# Subtle rising elemental particles
	var motes := CPUParticles2D.new()
	motes.amount = 18
	motes.lifetime = 3.4
	motes.preprocess = 1.2
	motes.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	motes.emission_rect_extents = Vector2(96.0, 14.0)
	motes.position = Vector2(210, 315)
	motes.direction = Vector2(0.0, -1.0)
	motes.spread = 18.0
	motes.gravity = Vector2(0.0, -10.0)
	motes.initial_velocity_min = 14.0
	motes.initial_velocity_max = 32.0
	motes.scale_amount_min = 2.8
	motes.scale_amount_max = 5.6
	motes.color = Color(el_col.lightened(0.28).r, el_col.lightened(0.28).g, el_col.lightened(0.28).b, 0.55)
	stage_world.add_child(motes)

	var vis := UnitVisual.new()
	vis.facing_sign = 1.0
	vis.unit_scale = 2.6
	vis.idle_speed_scale = 0.85
	vis.position = Vector2(210, 320)
	stage_world.add_child(vis)
	vis.configure_animations(GameData.get_hero_anim_map(_selected_hero, evo))
	if _selected_hero == "knight" and evo == "fire":
		vis.set_aura(Color(1.0, 0.36, 0.14), true)
	elif _selected_hero == "knight" and evo == "holy":
		vis.set_aura(Color(1.0, 0.88, 0.32), true)
	if not owned:
		vis.modulate = Color(0.50, 0.54, 0.64, 0.88)

	var target := Marker2D.new()
	target.position = Vector2(360, 190)
	stage_world.add_child(target)

	var sync_stage := func() -> void:
		if not is_instance_valid(stage_view) or not is_instance_valid(vis):
			return
		var sw: float = maxf(stage_view.size.x, 220.0)
		var sh: float = maxf(stage_view.size.y, 200.0)
		var new_scale: float = clampf((sh * 0.72) / 104.0, 1.50, 3.10)
		var foot_pos := Vector2(sw * 0.50, sh * 0.86)
		vis.unit_scale = new_scale
		vis.position = foot_pos
		vis.home_position = foot_pos
		var piv: Node2D = vis.get_node_or_null("VisualPivot")
		if piv != null:
			piv.scale = Vector2(new_scale, new_scale)
		pedestal_wrap.position = foot_pos + Vector2(0, 6)
		var ring_scale: float = clampf(new_scale * 0.36, 0.68, 1.18)
		floor_ring.scale = Vector2(ring_scale, ring_scale)
		motes.position = foot_pos - Vector2(0, 8)
		motes.emission_rect_extents = Vector2(clampf(sw * 0.24, 56.0, 120.0), 14.0)
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

	# Right floating glassmorphic Info Stack (~42% width)
	var info_stack := VBoxContainer.new()
	info_stack.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info_stack.size_flags_vertical = Control.SIZE_EXPAND_FILL
	info_stack.size_flags_stretch_ratio = 1.0
	info_stack.custom_minimum_size = Vector2(256, 0)
	info_stack.alignment = BoxContainer.ALIGNMENT_CENTER
	info_stack.add_theme_constant_override("separation", 10)
	center_row.add_child(info_stack)

	# Card 1: Glassmorphic Attributes Card
	var attr_panel := PanelContainer.new()
	attr_panel.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.05, 0.06, 0.13, 0.68), Color(0.70, 0.76, 0.94, 0.22), 14, 1))
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
	attr_title.add_theme_color_override("font_color", Color(0.96, 0.84, 0.48))
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
	role_lbl.add_theme_color_override("font_color", Color(0.76, 0.84, 0.96))
	attr_hdr.add_child(role_lbl)

	var attr_div := ColorRect.new()
	attr_div.custom_minimum_size = Vector2(0, 1)
	attr_div.color = Color(1.0, 1.0, 1.0, 0.12)
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
		k_lbl.add_theme_color_override("font_color", Color(0.70, 0.76, 0.88))
		r_hb.add_child(k_lbl)

		var v_lbl := Label.new()
		v_lbl.text = String(sr[1])
		v_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		v_lbl.add_theme_font_size_override("font_size", 16)
		v_lbl.add_theme_color_override("font_color", Color(0.96, 0.98, 1.0))
		r_hb.add_child(v_lbl)

	# Card 2: Glassmorphic Skill Card beside character
	var sk_panel := PanelContainer.new()
	sk_panel.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.05, 0.06, 0.13, 0.68), Color(el_col.r, el_col.g, el_col.b, 0.38), 14, 1))
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

	var preview_btn := UiFx.make_styled_button("PREVIEW SKILL", Color(0.20, 0.42, 0.72), Vector2(0, 38), 13)
	preview_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	preview_btn.pressed.connect(func() -> void:
		var destination: Vector2 = vis.global_position if ranged else vis.global_position + Vector2(22.0, 0.0)
		vis.play_action(true, destination, false, ranged)
	)
	sk_vbox.add_child(preview_btn)

	# 3. USP Branching Evolution Strip (Knight only, when owned)
	if owned and _selected_hero == "knight":
		var evo_panel := PanelContainer.new()
		evo_panel.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.08, 0.07, 0.17, 0.76), Color(0.95, 0.78, 0.36, 0.52), 12, 1))
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
			Vector2(0, 38), 11
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
			Vector2(0, 38), 11
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
			Vector2(0, 38), 11
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
		lock_panel.custom_minimum_size = Vector2(0, 50)
		lock_panel.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.10, 0.07, 0.12, 0.76), Color(0.95, 0.52, 0.44, 0.45), 14, 1))
		vbox.add_child(lock_panel)

		var lock_lbl := Label.new()
		lock_lbl.text = "Triệu hồi tướng này ở Summon Portal để mở khóa!"
		lock_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lock_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		lock_lbl.add_theme_font_size_override("font_size", 16)
		lock_lbl.add_theme_color_override("font_color", Color(1.0, 0.70, 0.60))
		lock_panel.add_child(lock_lbl)
		return

	var action_hb := HBoxContainer.new()
	action_hb.add_theme_constant_override("separation", 14)
	vbox.add_child(action_hb)

	var lv_cost: Dictionary = PlayerState.get_level_cost(lv)
	var sh_need: int = PlayerState.get_star_shard_cost(stars)

	var lv_btn := UiFx.make_styled_button(
		"LEVEL UP  (%s G / %s EXP)" % [_fmt_num(int(lv_cost["gold"])), _fmt_num(int(lv_cost["exp"]))] if lv < 50 else "MAX LEVEL",
		Color(0.16, 0.54, 0.34), Vector2(0, 50), 15
	)
	lv_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lv_btn.pressed.connect(func() -> void:
		if PlayerState.level_up_hero(_selected_hero):
			AudioManager.play_sfx("level_up")
			vis.spawn_vfx_sprite("res://assets/sprites/vfx/vfx_heal_aura.png", Vector2(0, -40), 1.3)
	)
	action_hb.add_child(lv_btn)

	var star_btn := UiFx.make_styled_button(
		"★ STAR UP  (%d/%d Shards)" % [shards, sh_need] if stars < 3 else "MAX STARS (★★★)",
		Color(0.78, 0.52, 0.14), Vector2(0, 50), 15
	)
	star_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	star_btn.pressed.connect(func() -> void:
		if PlayerState.star_up_hero(_selected_hero):
			AudioManager.play_sfx("gacha_ssr")
			vis.spawn_vfx_sprite("res://assets/sprites/vfx/vfx_holy_shield.png", Vector2(0, -48), 1.4)
	)
	action_hb.add_child(star_btn)


func _layout() -> void:
	if not is_instance_valid(_roster_panel) or not is_instance_valid(_detail_host):
		return
	var top_y: float = 78.0
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
