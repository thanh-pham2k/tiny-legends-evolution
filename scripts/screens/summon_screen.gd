extends Control

const FEATURED_HEROES := ["ninja", "samurai", "knight", "paladin"]

var _app: Control
var _bg: TextureRect
var _gem_lbl: Label
var _ticket_lbl: Label
var _pity_lbl: Label
var _pity_bar: ProgressBar
var _beam: TextureRect
var _vfx_seal: TextureRect
var _vfx_pillar: TextureRect
var _vfx_burst: TextureRect
var _banner_panel: Control
var _feat_standee: TextureRect
var _feat_name: Label
var _feat_rar: Label
var _feat_el: TextureRect
var _feat_idx: int = 0
var _results_wrap: Control
var _results_grid: GridContainer
var _back_banner_btn: Button
var _status_lbl: Label
var _summoning: bool = false
var _tex_banner: Texture2D
var _tex_result: Texture2D


func setup_screen(app: Control, _params: Dictionary = {}) -> void:
	_app = app


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	PlayerState.resources_changed.connect(_refresh_header)

	_tex_banner = load("res://assets/sprites/backgrounds/gacha_summon_banner.png")
	_tex_result = load("res://assets/sprites/backgrounds/gacha_result_bg.png")

	_bg = TextureRect.new()
	_bg.texture = _tex_banner
	_bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	_bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_bg)

	var shade := ColorRect.new()
	shade.color = Color(0.03, 0.02, 0.08, 0.32)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(shade)

	_build_vfx_layers()
	_build_top_bar()
	_build_banner_view()
	_build_results_area()
	_build_bottom_buttons()
	_show_banner_state()
	_refresh_header()


func _fmt_num(n: int) -> String:
	var s: String = str(abs(n))
	var out: String = ""
	var cnt: int = 0
	for i in range(s.length() - 1, -1, -1):
		if cnt > 0 and cnt % 3 == 0:
			out = "," + out
		out = s[i] + out
		cnt += 1
	return out


func _build_vfx_layers() -> void:
	var add_mat := CanvasItemMaterial.new()
	add_mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD

	_vfx_seal = TextureRect.new()
	_vfx_seal.texture = load("res://assets/sprites/vfx/vfx_gacha_seal.png")
	_vfx_seal.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_vfx_seal.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_vfx_seal.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	_vfx_seal.offset_left = -210.0
	_vfx_seal.offset_top = -210.0
	_vfx_seal.offset_right = 210.0
	_vfx_seal.offset_bottom = 210.0
	_vfx_seal.pivot_offset = Vector2(210.0, 210.0)
	_vfx_seal.modulate = Color(1.0, 1.0, 1.0, 0.0)
	_vfx_seal.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_vfx_seal)

	_beam = TextureRect.new()
	_beam.texture = load("res://assets/sprites/ui/ui_gacha_beam.png")
	_beam.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_beam.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_beam.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	_beam.offset_left = -250.0
	_beam.offset_top = -360.0
	_beam.offset_right = 250.0
	_beam.offset_bottom = 360.0
	_beam.material = add_mat
	_beam.modulate = Color(0.7, 0.5, 1.0, 0.0)
	_beam.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_beam)

	_vfx_pillar = TextureRect.new()
	_vfx_pillar.texture = load("res://assets/sprites/vfx/vfx_gacha_pillar.png")
	_vfx_pillar.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_vfx_pillar.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_vfx_pillar.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	_vfx_pillar.offset_left = -220.0
	_vfx_pillar.offset_top = -320.0
	_vfx_pillar.offset_right = 220.0
	_vfx_pillar.offset_bottom = 260.0
	_vfx_pillar.pivot_offset = Vector2(220.0, 290.0)
	_vfx_pillar.material = add_mat
	_vfx_pillar.modulate.a = 0.0
	_vfx_pillar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_vfx_pillar)

	_vfx_burst = TextureRect.new()
	_vfx_burst.texture = load("res://assets/sprites/vfx/vfx_gacha_ssr_ring.png")
	_vfx_burst.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_vfx_burst.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_vfx_burst.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	_vfx_burst.offset_left = -260.0
	_vfx_burst.offset_top = -260.0
	_vfx_burst.offset_right = 260.0
	_vfx_burst.offset_bottom = 260.0
	_vfx_burst.pivot_offset = Vector2(260.0, 260.0)
	_vfx_burst.material = add_mat
	_vfx_burst.modulate.a = 0.0
	_vfx_burst.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_vfx_burst)


func _build_top_bar() -> void:
	var top_vbox := VBoxContainer.new()
	top_vbox.set_anchors_preset(Control.PRESET_TOP_WIDE)
	top_vbox.offset_left = 14.0
	top_vbox.offset_top = 10.0
	top_vbox.offset_right = -14.0
	top_vbox.offset_bottom = 148.0
	top_vbox.add_theme_constant_override("separation", 6)
	top_vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(top_vbox)

	var bar := PanelContainer.new()
	bar.custom_minimum_size = Vector2(0, 62)
	var bar_sb := UiFx.make_panel_style(Color(0.08, 0.07, 0.16, 0.88), Color(0.92, 0.72, 1.0, 0.75), 16, 2)
	bar_sb.content_margin_left = 12
	bar_sb.content_margin_right = 14
	bar.add_theme_stylebox_override("panel", bar_sb)
	top_vbox.add_child(bar)

	var hb := HBoxContainer.new()
	hb.add_theme_constant_override("separation", 10)
	bar.add_child(hb)

	var back_btn := Button.new()
	back_btn.custom_minimum_size = Vector2(46, 46)
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
	title.text = "SUMMON PORTAL"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 22)
	title.add_theme_color_override("font_color", Color(1.0, 0.88, 0.44))
	hb.add_child(title)

	_ticket_lbl = _make_currency_pill(hb, "res://assets/sprites/items/item_summon_ticket.png", Color(0.68, 0.96, 1.0))
	_gem_lbl = _make_currency_pill(hb, "res://assets/sprites/items/item_purple_gem.png", Color(0.90, 0.72, 1.0))

	# Pity Progress & Status Row
	var pity_row := HBoxContainer.new()
	pity_row.alignment = BoxContainer.ALIGNMENT_CENTER
	pity_row.add_theme_constant_override("separation", 12)
	pity_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top_vbox.add_child(pity_row)

	var pity_card := PanelContainer.new()
	pity_card.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.06, 0.05, 0.14, 0.78), Color(0.88, 0.68, 0.34, 0.65), 12, 1))
	pity_row.add_child(pity_card)

	var p_mc := MarginContainer.new()
	p_mc.add_theme_constant_override("margin_left", 12)
	p_mc.add_theme_constant_override("margin_right", 12)
	p_mc.add_theme_constant_override("margin_top", 4)
	p_mc.add_theme_constant_override("margin_bottom", 4)
	pity_card.add_child(p_mc)

	var p_hb := HBoxContainer.new()
	p_hb.add_theme_constant_override("separation", 10)
	p_mc.add_child(p_hb)

	_pity_lbl = Label.new()
	_pity_lbl.add_theme_font_size_override("font_size", 14)
	_pity_lbl.add_theme_color_override("font_color", Color(1.0, 0.90, 0.48))
	p_hb.add_child(_pity_lbl)

	_pity_bar = ProgressBar.new()
	_pity_bar.custom_minimum_size = Vector2(150, 14)
	_pity_bar.max_value = PlayerState.PITY_THRESHOLD
	_pity_bar.show_percentage = false
	var bar_bg := StyleBoxFlat.new()
	bar_bg.bg_color = Color(0.14, 0.12, 0.24)
	bar_bg.set_corner_radius_all(7)
	var bar_fill := StyleBoxFlat.new()
	bar_fill.bg_color = Color(1.0, 0.76, 0.24)
	bar_fill.set_corner_radius_all(7)
	_pity_bar.add_theme_stylebox_override("background", bar_bg)
	_pity_bar.add_theme_stylebox_override("fill", bar_fill)
	p_hb.add_child(_pity_bar)

	_status_lbl = Label.new()
	_status_lbl.text = "Triệu hồi tướng R / SR / SSR / UR!"
	_status_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_status_lbl.add_theme_font_size_override("font_size", 18)
	_status_lbl.add_theme_color_override("font_color", Color(0.95, 0.97, 1.0))
	_status_lbl.add_theme_color_override("font_outline_color", Color(0.06, 0.04, 0.12))
	_status_lbl.add_theme_constant_override("outline_size", 4)
	top_vbox.add_child(_status_lbl)


func _make_currency_pill(parent: HBoxContainer, icon_path: String, text_col: Color) -> Label:
	var pc := PanelContainer.new()
	pc.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.05, 0.05, 0.12, 0.88), Color(0.76, 0.62, 0.36, 0.55), 12, 1))
	parent.add_child(pc)

	var mc := MarginContainer.new()
	mc.add_theme_constant_override("margin_left", 10)
	mc.add_theme_constant_override("margin_right", 12)
	mc.add_theme_constant_override("margin_top", 4)
	mc.add_theme_constant_override("margin_bottom", 4)
	pc.add_child(mc)

	var hb := HBoxContainer.new()
	hb.add_theme_constant_override("separation", 6)
	mc.add_child(hb)

	var ic := TextureRect.new()
	ic.texture = load(icon_path)
	ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	ic.custom_minimum_size = Vector2(22, 22)
	hb.add_child(ic)

	var lbl := Label.new()
	lbl.add_theme_font_size_override("font_size", 15)
	lbl.add_theme_color_override("font_color", text_col)
	hb.add_child(lbl)
	return lbl


func _build_banner_view() -> void:
	_banner_panel = Control.new()
	_banner_panel.name = "BannerView"
	_banner_panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_banner_panel.offset_top = 132.0
	_banner_panel.offset_bottom = -114.0
	_banner_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_banner_panel)

	var hbox := HBoxContainer.new()
	hbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	hbox.offset_left = 36.0
	hbox.offset_right = -36.0
	hbox.add_theme_constant_override("separation", 20)
	hbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_banner_panel.add_child(hbox)

	# Left: Banner Info & Drop Rates Card
	var left_wrap := VBoxContainer.new()
	left_wrap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left_wrap.size_flags_stretch_ratio = 0.9
	left_wrap.alignment = BoxContainer.ALIGNMENT_END
	left_wrap.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hbox.add_child(left_wrap)

	var info_card := PanelContainer.new()
	info_card.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.06, 0.05, 0.14, 0.80), Color(0.94, 0.76, 0.36, 0.65), 16, 2))
	left_wrap.add_child(info_card)

	var ic_mc := MarginContainer.new()
	ic_mc.add_theme_constant_override("margin_left", 16)
	ic_mc.add_theme_constant_override("margin_right", 16)
	ic_mc.add_theme_constant_override("margin_top", 12)
	ic_mc.add_theme_constant_override("margin_bottom", 12)
	info_card.add_child(ic_mc)

	var ic_vb := VBoxContainer.new()
	ic_vb.add_theme_constant_override("separation", 6)
	ic_mc.add_child(ic_vb)

	var b_title := Label.new()
	b_title.text = "CELESTIAL SUMMON BANNER"
	b_title.add_theme_font_size_override("font_size", 18)
	b_title.add_theme_color_override("font_color", Color(1.0, 0.90, 0.46))
	ic_vb.add_child(b_title)

	var rates := Label.new()
	rates.text = "Tỷ lệ:  UR 1.5%  •  SSR 8.5%  •  SR 28%  •  R 62%\nBảo đảm: x10 có ít nhất 1 SR+  |  Pity 30 lượt chắc chắn SSR / UR"
	rates.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	rates.add_theme_font_size_override("font_size", 13)
	rates.add_theme_color_override("font_color", Color(0.86, 0.92, 1.0))
	ic_vb.add_child(rates)

	# Right: Featured Hero Standee Showcase
	var right_stage := Control.new()
	right_stage.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right_stage.size_flags_stretch_ratio = 1.25
	right_stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hbox.add_child(right_stage)

	_feat_standee = TextureRect.new()
	_feat_standee.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_feat_standee.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_feat_standee.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_feat_standee.offset_left = 40
	_feat_standee.offset_right = -40
	_feat_standee.offset_top = 4
	_feat_standee.offset_bottom = -48
	_feat_standee.mouse_filter = Control.MOUSE_FILTER_IGNORE
	right_stage.add_child(_feat_standee)

	var s_tw := _feat_standee.create_tween().set_loops()
	s_tw.tween_property(_feat_standee, "offset_top", -4.0, 1.9).set_trans(Tween.TRANS_SINE)
	s_tw.parallel().tween_property(_feat_standee, "offset_bottom", -56.0, 1.9).set_trans(Tween.TRANS_SINE)
	s_tw.tween_property(_feat_standee, "offset_top", 6.0, 1.9).set_trans(Tween.TRANS_SINE)
	s_tw.parallel().tween_property(_feat_standee, "offset_bottom", -46.0, 1.9).set_trans(Tween.TRANS_SINE)

	var feat_plate := PanelContainer.new()
	feat_plate.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	feat_plate.offset_left = 80
	feat_plate.offset_right = -80
	feat_plate.offset_top = -46
	feat_plate.offset_bottom = -4
	feat_plate.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.06, 0.05, 0.14, 0.84), Color(0.94, 0.76, 0.36, 0.72), 12, 1))
	right_stage.add_child(feat_plate)

	var fp_hb := HBoxContainer.new()
	fp_hb.alignment = BoxContainer.ALIGNMENT_CENTER
	fp_hb.add_theme_constant_override("separation", 8)
	feat_plate.add_child(fp_hb)

	var prev_f := UiFx.make_styled_button("◀", Color(0.24, 0.24, 0.40), Vector2(36, 30), 13)
	prev_f.pressed.connect(func() -> void:
		_feat_idx = (_feat_idx - 1 + FEATURED_HEROES.size()) % FEATURED_HEROES.size()
		_update_featured_hero()
	)
	fp_hb.add_child(prev_f)

	_feat_el = TextureRect.new()
	_feat_el.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_feat_el.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_feat_el.custom_minimum_size = Vector2(24, 24)
	fp_hb.add_child(_feat_el)

	_feat_rar = Label.new()
	_feat_rar.add_theme_font_size_override("font_size", 15)
	fp_hb.add_child(_feat_rar)

	_feat_name = Label.new()
	_feat_name.add_theme_font_size_override("font_size", 16)
	_feat_name.add_theme_color_override("font_color", Color(1.0, 0.94, 0.72))
	fp_hb.add_child(_feat_name)

	var next_f := UiFx.make_styled_button("▶", Color(0.24, 0.24, 0.40), Vector2(36, 30), 13)
	next_f.pressed.connect(func() -> void:
		_feat_idx = (_feat_idx + 1) % FEATURED_HEROES.size()
		_update_featured_hero()
	)
	fp_hb.add_child(next_f)

	_update_featured_hero()


func _update_featured_hero() -> void:
	var hid: String = FEATURED_HEROES[_feat_idx % FEATURED_HEROES.size()]
	var info: Dictionary = GameData.HEROES[hid]
	var rar: String = String(info["rarity"])
	var el_id: String = String(info["element"])
	_feat_standee.texture = load(GameData.get_hero_standee_path(hid))
	_feat_el.texture = load(String(GameData.ELEMENTS[el_id]["icon"]))
	_feat_rar.text = "[%s]" % rar
	_feat_rar.add_theme_color_override("font_color", GameData.RARITIES[rar]["color"])
	_feat_name.text = String(info["name"])


func _build_results_area() -> void:
	_results_wrap = Control.new()
	_results_wrap.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_results_wrap.offset_top = 136.0
	_results_wrap.offset_bottom = -114.0
	_results_wrap.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_results_wrap)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_results_wrap.add_child(center)

	_results_grid = GridContainer.new()
	_results_grid.columns = 5
	_results_grid.add_theme_constant_override("h_separation", 14)
	_results_grid.add_theme_constant_override("v_separation", 14)
	center.add_child(_results_grid)

	_back_banner_btn = UiFx.make_styled_button("◀ BACK TO BANNER", Color(0.24, 0.28, 0.46), Vector2(180, 38), 13)
	_back_banner_btn.position = Vector2(22, 6)
	_back_banner_btn.pressed.connect(_show_banner_state)
	_results_wrap.add_child(_back_banner_btn)


func _build_bottom_buttons() -> void:
	var bottom_wrap := CenterContainer.new()
	bottom_wrap.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	bottom_wrap.offset_top = -104.0
	bottom_wrap.offset_bottom = -14.0
	add_child(bottom_wrap)

	var hb := HBoxContainer.new()
	hb.alignment = BoxContainer.ALIGNMENT_CENTER
	hb.add_theme_constant_override("separation", 24)
	bottom_wrap.add_child(hb)

	var b1 := _make_summon_btn("SUMMON x1\n(1 Ticket / 300 Gems)", "res://assets/sprites/ui/ui_btn_blue.png", Color(0.05, 0.14, 0.34))
	b1.pressed.connect(func() -> void: _do_summon(1))
	hb.add_child(b1)

	var b10 := _make_summon_btn("SUMMON x10\n(10 Tickets / 2,700 Gems)", "res://assets/sprites/ui/ui_btn_gold.png", Color(0.30, 0.14, 0.02))
	b10.pressed.connect(func() -> void: _do_summon(10))
	hb.add_child(b10)


func _make_summon_btn(text: String, tex_path: String, outline_col: Color) -> Button:
	var btn := Button.new()
	btn.text = text
	btn.custom_minimum_size = Vector2(280, 76)
	btn.add_theme_font_size_override("font_size", 16)
	btn.add_theme_color_override("font_color", Color(1.0, 0.98, 0.92))
	btn.add_theme_color_override("font_outline_color", outline_col)
	btn.add_theme_constant_override("outline_size", 4)
	var sb := StyleBoxTexture.new()
	sb.texture = load(tex_path)
	sb.texture_margin_left = 48
	sb.texture_margin_right = 48
	sb.texture_margin_top = 28
	sb.texture_margin_bottom = 28
	var sb_h := sb.duplicate()
	sb_h.modulate_color = Color(1.10, 1.07, 1.02)
	var sb_p := sb.duplicate()
	sb_p.modulate_color = Color(0.86, 0.84, 0.80)
	btn.add_theme_stylebox_override("normal", sb)
	btn.add_theme_stylebox_override("hover", sb_h)
	btn.add_theme_stylebox_override("pressed", sb_p)
	btn.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	UiFx.attach_press_bounce(btn)
	return btn


func _show_banner_state() -> void:
	if is_instance_valid(_bg):
		_bg.texture = _tex_banner
	if is_instance_valid(_banner_panel):
		_banner_panel.visible = true
	if is_instance_valid(_results_wrap):
		_results_wrap.visible = false
	if is_instance_valid(_vfx_seal):
		_vfx_seal.modulate.a = 0.0
	if is_instance_valid(_vfx_burst):
		_vfx_burst.modulate.a = 0.0
	if is_instance_valid(_vfx_pillar):
		_vfx_pillar.modulate.a = 0.0
	if is_instance_valid(_status_lbl):
		_status_lbl.text = "Triệu hồi tướng R / SR / SSR / UR!"


func _do_summon(count: int) -> void:
	if _summoning:
		return
	if not PlayerState.can_afford_summon(count):
		_status_lbl.text = "Không đủ Vé hoặc Gems!"
		_status_lbl.add_theme_color_override("font_color", Color(1.0, 0.52, 0.46))
		return
	_status_lbl.add_theme_color_override("font_color", Color(0.95, 0.97, 1.0))

	var pulls: Array = PlayerState.summon_gacha(count)
	if pulls.is_empty():
		return
	_summoning = true
	for c in _results_grid.get_children():
		c.queue_free()

	if is_instance_valid(_banner_panel):
		_banner_panel.visible = false
	if is_instance_valid(_bg):
		_bg.texture = _tex_result
	if is_instance_valid(_results_wrap):
		_results_wrap.visible = true
	if is_instance_valid(_back_banner_btn):
		_back_banner_btn.visible = false

	var best_rar := "R"
	var rank := {"R": 0, "SR": 1, "SSR": 2, "UR": 3}
	for p in pulls:
		if int(rank[p["rarity"]]) > int(rank[best_rar]):
			best_rar = String(p["rarity"])

	var beam_col: Color = GameData.RARITIES[best_rar]["color"]
	AudioManager.play_sfx("gacha_ssr" if best_rar in ["SSR", "UR"] else "gacha_pull")
	_status_lbl.text = "Đang triệu hồi..."

	_vfx_burst.texture = load("res://assets/sprites/vfx/vfx_gacha_ur_starburst.png" if best_rar == "UR" else "res://assets/sprites/vfx/vfx_gacha_ssr_ring.png")
	_vfx_seal.rotation = 0.0
	_vfx_seal.scale = Vector2(0.75, 0.75)
	_vfx_pillar.scale = Vector2(0.7, 0.25)
	_vfx_burst.scale = Vector2(0.45, 0.45)

	var bt := create_tween()
	bt.set_parallel(true)
	bt.tween_property(_beam, "modulate", Color(beam_col.r, beam_col.g, beam_col.b, 0.92), 0.22)
	bt.tween_property(_vfx_seal, "modulate:a", 0.78, 0.22)
	bt.tween_property(_vfx_seal, "scale", Vector2(1.05, 1.05), 0.26)
	bt.tween_property(_vfx_seal, "rotation", 1.2, 0.55)
	bt.tween_property(_vfx_pillar, "modulate:a", 0.85, 0.20)
	bt.tween_property(_vfx_pillar, "scale", Vector2(1.05, 1.15), 0.28).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

	var seq := create_tween()
	seq.tween_interval(0.24)
	seq.tween_callback(func() -> void:
		if best_rar in ["SSR", "UR"]:
			var b_tw := create_tween().set_parallel(true)
			b_tw.tween_property(_vfx_burst, "modulate:a", 0.92, 0.14)
			b_tw.tween_property(_vfx_burst, "scale", Vector2(1.25, 1.25), 0.34).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			b_tw.tween_property(_vfx_burst, "modulate:a", 0.0, 0.32).set_delay(0.22)
		_reveal_cards(pulls, best_rar)
	)
	seq.tween_interval(0.32)
	seq.tween_property(_beam, "modulate", Color(beam_col.r, beam_col.g, beam_col.b, 0.18), 0.32)
	seq.parallel().tween_property(_vfx_pillar, "modulate:a", 0.0, 0.28)
	seq.parallel().tween_property(_vfx_seal, "modulate:a", 0.22, 0.35)


func _reveal_cards(pulls: Array, best_rar: String) -> void:
	if is_instance_valid(_banner_panel):
		_banner_panel.visible = false
	if is_instance_valid(_bg):
		_bg.texture = _tex_result
	if is_instance_valid(_results_wrap):
		_results_wrap.visible = true

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
		if is_instance_valid(_back_banner_btn):
			_back_banner_btn.visible = true
	)


func _build_flip_card(pull: Dictionary, big: bool) -> Control:
	var w: int = 248 if big else 132
	var h: int = 336 if big else 184
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

	# Frame FIRST, Portrait ON TOP inside card window!
	var frame := TextureRect.new()
	frame.name = "Frame"
	frame.texture = load(String(GameData.RARITIES[rar]["frame"]))
	frame.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	frame.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	frame.size = Vector2(w, h)
	front.add_child(frame)

	var port := TextureRect.new()
	port.name = "Portrait"
	port.texture = load(GameData.get_hero_standee_path(hid) if big else GameData.get_hero_portrait_path(hid, "basic"))
	port.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	port.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	if big:
		port.position = Vector2(w * 0.14, h * 0.18)
		port.size = Vector2(w * 0.72, h * 0.58)
	else:
		port.position = Vector2(w * 0.16, h * 0.21)
		port.size = Vector2(w * 0.68, h * 0.53)
	front.add_child(port)

	var el_ic := TextureRect.new()
	el_ic.name = "ElementIcon"
	el_ic.texture = load(String(GameData.ELEMENTS[hinfo["element"]]["icon"]))
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
	tag_lbl.position = Vector2(6, h - (56 if big else 40))
	tag_lbl.size = Vector2(w - 12, 48 if big else 34)
	tag_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tag_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	tag_lbl.clip_text = true
	tag_lbl.add_theme_font_size_override("font_size", 18 if big else 10)
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
	_ticket_lbl.text = _fmt_num(PlayerState.tickets)
	_gem_lbl.text = _fmt_num(PlayerState.gems)
	_pity_lbl.text = "Pity: %d / %d (SSR / UR)" % [PlayerState.pity_counter, PlayerState.PITY_THRESHOLD]
	if is_instance_valid(_pity_bar):
		_pity_bar.value = PlayerState.pity_counter
