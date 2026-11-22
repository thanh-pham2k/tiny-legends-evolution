extends Control

var _app: Control
var _filter_el: String = "all"
var _selected_hero: String = "knight"
var _grid: GridContainer
var _detail_host: Control
var _gold_lbl: Label
var _exp_lbl: Label


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
	add_child(bg)

	_build_top_bar()
	_build_filter_bar()
	_build_roster_grid()
	_detail_host = Control.new()
	_detail_host.position = Vector2(18, 560)
	_detail_host.size = Vector2(684, 700)
	add_child(_detail_host)

	_rebuild_all()


func _build_top_bar() -> void:
	var bar := PanelContainer.new()
	bar.position = Vector2(14, 16)
	bar.size = Vector2(692, 80)
	bar.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.10, 0.09, 0.18, 0.90), Color(0.95, 0.78, 0.36), 18, 2))
	add_child(bar)

	var hb := HBoxContainer.new()
	hb.add_theme_constant_override("separation", 12)
	bar.add_child(hb)

	var back_btn := Button.new()
	back_btn.custom_minimum_size = Vector2(60, 60)
	back_btn.flat = true
	back_btn.pressed.connect(func() -> void: _app.navigate_to("lobby"))
	UiFx.attach_press_bounce(back_btn)
	hb.add_child(back_btn)

	var back_ic := TextureRect.new()
	back_ic.texture = load("res://assets/sprites/ui/ui_btn_back.png")
	back_ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	back_ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	back_ic.size = Vector2(56, 56)
	back_ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
	back_btn.add_child(back_ic)

	var title := Label.new()
	title.text = "HEROES & EVOLUTION"
	title.custom_minimum_size = Vector2(280, 60)
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 24)
	title.add_theme_color_override("font_color", Color(1.0, 0.88, 0.44))
	hb.add_child(title)

	_gold_lbl = Label.new()
	_gold_lbl.custom_minimum_size = Vector2(140, 60)
	_gold_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_gold_lbl.add_theme_font_size_override("font_size", 17)
	_gold_lbl.add_theme_color_override("font_color", Color(1.0, 0.88, 0.42))
	hb.add_child(_gold_lbl)

	_exp_lbl = Label.new()
	_exp_lbl.custom_minimum_size = Vector2(140, 60)
	_exp_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_exp_lbl.add_theme_font_size_override("font_size", 17)
	_exp_lbl.add_theme_color_override("font_color", Color(0.68, 0.96, 1.0))
	hb.add_child(_exp_lbl)


func _build_filter_bar() -> void:
	var hb := HBoxContainer.new()
	hb.position = Vector2(20, 108)
	hb.size = Vector2(680, 56)
	hb.alignment = BoxContainer.ALIGNMENT_CENTER
	hb.add_theme_constant_override("separation", 10)
	add_child(hb)

	var all_btn := UiFx.make_styled_button("ALL", Color(0.28, 0.30, 0.46), Vector2(86, 50), 16)
	all_btn.pressed.connect(func() -> void:
		_filter_el = "all"
		_rebuild_roster_only()
	)
	hb.add_child(all_btn)

	for el in ["fire", "water", "wind", "earth", "light", "dark"]:
		var btn := Button.new()
		btn.custom_minimum_size = Vector2(54, 54)
		btn.flat = true
		btn.pressed.connect(func() -> void:
			_filter_el = el
			_rebuild_roster_only()
		)
		UiFx.attach_press_bounce(btn)
		hb.add_child(btn)

		var ic := TextureRect.new()
		ic.texture = load(GameData.ELEMENTS[el]["icon"])
		ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		ic.size = Vector2(48, 48)
		ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
		btn.add_child(ic)


func _build_roster_grid() -> void:
	var scroll := ScrollContainer.new()
	scroll.position = Vector2(20, 174)
	scroll.size = Vector2(680, 372)
	add_child(scroll)

	_grid = GridContainer.new()
	_grid.columns = 4
	_grid.add_theme_constant_override("h_separation", 14)
	_grid.add_theme_constant_override("v_separation", 14)
	scroll.add_child(_grid)


func _rebuild_all() -> void:
	_refresh_top()
	_rebuild_roster_only()
	_rebuild_detail()


func _refresh_top() -> void:
	if is_instance_valid(_gold_lbl):
		_gold_lbl.text = "Gold: %d" % PlayerState.gold
		_exp_lbl.text = "EXP: %d" % PlayerState.exp_pool


func _rebuild_roster_only() -> void:
	for c in _grid.get_children():
		c.queue_free()

	for hid in GameData.HEROES:
		var info: Dictionary = GameData.HEROES[hid]
		if _filter_el != "all" and String(info["element"]) != _filter_el:
			continue
		var owned := PlayerState.owned_heroes.has(hid)
		var rec: Dictionary = PlayerState.get_hero_record(hid)
		var evo := String(rec.get("evo", "basic"))
		var rar := String(info["rarity"])

		var card := Button.new()
		card.custom_minimum_size = Vector2(156, 174)
		card.flat = true
		card.modulate = Color.WHITE if owned else Color(0.42, 0.44, 0.52, 0.72)
		card.pressed.connect(func() -> void:
			_selected_hero = hid
			_rebuild_detail()
		)
		UiFx.attach_press_bounce(card)
		_grid.add_child(card)

		var port := TextureRect.new()
		port.texture = load(GameData.get_hero_portrait_path(hid, evo))
		port.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		port.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		port.position = Vector2(22, 24)
		port.size = Vector2(112, 98)
		port.mouse_filter = Control.MOUSE_FILTER_IGNORE
		card.add_child(port)

		var frame := TextureRect.new()
		frame.texture = load(GameData.RARITIES[rar]["frame"])
		frame.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		frame.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		frame.size = Vector2(156, 174)
		frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
		card.add_child(frame)

		var el_ic := TextureRect.new()
		el_ic.texture = load(GameData.ELEMENTS[info["element"]]["icon"])
		el_ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		el_ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		el_ic.position = Vector2(114, 8)
		el_ic.size = Vector2(32, 32)
		el_ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
		card.add_child(el_ic)

		var lbl := Label.new()
		lbl.text = ("%s\nLv.%d" % [GameData.get_hero_display_name(hid, evo), int(rec.get("level", 1))]) if owned else ("Locked\n" + String(info["name"]))
		lbl.position = Vector2(6, 126)
		lbl.size = Vector2(144, 42)
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lbl.add_theme_font_size_override("font_size", 12)
		lbl.add_theme_color_override("font_color", Color(1.0, 0.94, 0.56) if hid == _selected_hero else Color.WHITE)
		lbl.add_theme_color_override("font_outline_color", Color.BLACK)
		lbl.add_theme_constant_override("outline_size", 3)
		card.add_child(lbl)


func _rebuild_detail() -> void:
	for c in _detail_host.get_children():
		c.queue_free()

	var info: Dictionary = GameData.HEROES.get(_selected_hero, GameData.HEROES["knight"])
	var owned := PlayerState.owned_heroes.has(_selected_hero)
	var rec: Dictionary = PlayerState.get_hero_record(_selected_hero)
	var lv := int(rec.get("level", 1))
	var stars := int(rec.get("stars", 1))
	var shards := int(rec.get("shards", 0))
	var evo := String(rec.get("evo", "basic"))
	var st := GameData.get_hero_stats(_selected_hero, lv, stars, evo)
	var sk := GameData.get_hero_skill_info(_selected_hero, evo)

	var pc := PanelContainer.new()
	pc.size = Vector2(684, 700)
	pc.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.11, 0.10, 0.19, 0.94), Color(1.0, 0.80, 0.36), 22, 2))
	_detail_host.add_child(pc)

	# Left: Live UnitVisual showcase
	var stage_panel := PanelContainer.new()
	stage_panel.position = Vector2(18, 18)
	stage_panel.size = Vector2(248, 300)
	stage_panel.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.16, 0.13, 0.28), Color(0.68, 0.56, 0.95), 16, 2))
	_detail_host.add_child(stage_panel)

	var stage_bg := TextureRect.new()
	stage_bg.texture = load("res://assets/sprites/backgrounds/bg_evolution_stage.png")
	stage_bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stage_bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	stage_bg.position = Vector2(20, 20)
	stage_bg.size = Vector2(244, 296)
	_detail_host.add_child(stage_bg)

	var vis := UnitVisual.new()
	vis.facing_sign = 1.0
	vis.unit_scale = 1.85
	vis.position = Vector2(142, 275)
	_detail_host.add_child(vis)
	vis.configure_animations(GameData.get_hero_anim_map(_selected_hero, evo))
	if _selected_hero == "knight" and evo == "fire":
		vis.set_aura(Color(1.0, 0.36, 0.14), true)
	elif _selected_hero == "knight" and evo == "holy":
		vis.set_aura(Color(1.0, 0.88, 0.32), true)

	var preview_btn := UiFx.make_styled_button("Preview Skill", Color(0.24, 0.46, 0.72), Vector2(180, 44), 15)
	preview_btn.position = Vector2(52, 326)
	preview_btn.pressed.connect(func() -> void:
		vis.play_skill(vis.global_position.x + 140.0)
	)
	_detail_host.add_child(preview_btn)

	# Right: Stats & Skill Info
	var d_name := Label.new()
	d_name.text = "%s  [%s]  %s" % [GameData.get_hero_display_name(_selected_hero, evo), String(info["rarity"]), "★".repeat(stars)]
	d_name.position = Vector2(284, 20)
	d_name.size = Vector2(384, 38)
	d_name.add_theme_font_size_override("font_size", 24)
	d_name.add_theme_color_override("font_color", Color(1.0, 0.90, 0.44))
	_detail_host.add_child(d_name)

	var stats_lbl := Label.new()
	stats_lbl.text = "Lv.%d / 50   •   Shards: %d\nHP: %d   |   ATK: %d\nDEF: %d   |   SPD: %d\nPower: %d" % [
		lv, shards, int(st["hp"]), int(st["atk"]), int(st["def"]), int(st["spd"]), int(st["power"])
	]
	stats_lbl.position = Vector2(284, 68)
	stats_lbl.size = Vector2(384, 120)
	stats_lbl.add_theme_font_size_override("font_size", 17)
	stats_lbl.add_theme_color_override("font_color", Color(0.88, 0.94, 1.0))
	_detail_host.add_child(stats_lbl)

	var sk_ic := TextureRect.new()
	sk_ic.texture = load(String(sk["icon"]))
	sk_ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	sk_ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	sk_ic.position = Vector2(284, 198)
	sk_ic.size = Vector2(64, 64)
	_detail_host.add_child(sk_ic)

	var sk_lbl := Label.new()
	sk_lbl.text = "%s\n%s" % [String(sk["name"]), String(sk["desc"])]
	sk_lbl.position = Vector2(358, 194)
	sk_lbl.size = Vector2(310, 120)
	sk_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	sk_lbl.add_theme_font_size_override("font_size", 14)
	sk_lbl.add_theme_color_override("font_color", Color(0.95, 0.88, 0.72))
	_detail_host.add_child(sk_lbl)

	if not owned:
		var lock_lbl := Label.new()
		lock_lbl.text = "Triệu hồi tướng này ở Summon Portal để mở khóa!"
		lock_lbl.position = Vector2(40, 420)
		lock_lbl.size = Vector2(600, 60)
		lock_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lock_lbl.add_theme_font_size_override("font_size", 20)
		lock_lbl.add_theme_color_override("font_color", Color(1.0, 0.65, 0.55))
		_detail_host.add_child(lock_lbl)
		return

	# Upgrade Buttons Row
	var lv_cost := PlayerState.get_level_cost(lv)
	var sh_need := PlayerState.get_star_shard_cost(stars)
	var lv_btn := UiFx.make_styled_button(
		"LEVEL UP\n(%d G / %d EXP)" % [int(lv_cost["gold"]), int(lv_cost["exp"])] if lv < 50 else "MAX LEVEL",
		Color(0.18, 0.54, 0.34), Vector2(290, 74), 16
	)
	lv_btn.position = Vector2(36, 392)
	lv_btn.pressed.connect(func() -> void:
		if PlayerState.level_up_hero(_selected_hero):
			AudioManager.play_sfx("level_up")
			vis.spawn_vfx_sprite("res://assets/sprites/vfx/vfx_heal_aura.png", Vector2(0, -40), 1.3)
	)
	_detail_host.add_child(lv_btn)

	var star_btn := UiFx.make_styled_button(
		"STAR UP (%d/%d Shards)" % [shards, sh_need] if stars < 3 else "MAX STARS (★★★)",
		Color(0.76, 0.52, 0.14), Vector2(290, 74), 16
	)
	star_btn.position = Vector2(356, 392)
	star_btn.pressed.connect(func() -> void:
		if PlayerState.star_up_hero(_selected_hero):
			AudioManager.play_sfx("gacha_ssr")
			vis.spawn_vfx_sprite("res://assets/sprites/vfx/vfx_holy_shield.png", Vector2(0, -48), 1.4)
	)
	_detail_host.add_child(star_btn)

	# USP Branching Evolution Panel for Knight
	if _selected_hero == "knight":
		var evo_title := Label.new()
		evo_title.text = "EVOLUTION TREE (USP — Thay đổi AI tự chiến đấu):"
		evo_title.position = Vector2(36, 484)
		evo_title.size = Vector2(612, 30)
		evo_title.add_theme_font_size_override("font_size", 17)
		evo_title.add_theme_color_override("font_color", Color(1.0, 0.86, 0.42))
		_detail_host.add_child(evo_title)

		var adv_btn := UiFx.make_styled_button("Iron Knight\n(Lv.5, 1200 G)", Color(0.28, 0.42, 0.68), Vector2(186, 86), 15)
		adv_btn.position = Vector2(36, 524)
		adv_btn.pressed.connect(func() -> void:
			if PlayerState.evolve_hero("knight", "advance"):
				AudioManager.play_sfx("gacha_ssr")
		)
		_detail_host.add_child(adv_btn)

		var fire_btn := UiFx.make_styled_button("Fire Knight\nAoE AI (Lv.10, 2500 G)", Color(0.78, 0.24, 0.16), Vector2(204, 86), 15)
		fire_btn.position = Vector2(238, 524)
		fire_btn.pressed.connect(func() -> void:
			if PlayerState.evolve_hero("knight", "fire"):
				AudioManager.play_sfx("gacha_ssr")
		)
		_detail_host.add_child(fire_btn)

		var holy_btn := UiFx.make_styled_button("Holy Guardian\nProtect AI (Lv.10, 2500 G)", Color(0.80, 0.62, 0.14), Vector2(204, 86), 15)
		holy_btn.position = Vector2(456, 524)
		holy_btn.pressed.connect(func() -> void:
			if PlayerState.evolve_hero("knight", "holy"):
				AudioManager.play_sfx("gacha_ssr")
		)
		_detail_host.add_child(holy_btn)

		var tip := Label.new()
		tip.text = "Hiện tại: %s" % String(GameData.KNIGHT_EVOLUTIONS[evo]["ai_label"])
		tip.position = Vector2(36, 622)
		tip.size = Vector2(620, 56)
		tip.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		tip.add_theme_font_size_override("font_size", 15)
		tip.add_theme_color_override("font_color", Color(0.76, 0.96, 1.0))
		_detail_host.add_child(tip)
