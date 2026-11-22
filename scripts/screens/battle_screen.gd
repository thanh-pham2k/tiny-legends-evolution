extends Control

var _app: Control
var _stage_num: int = 1
var _stage_data: Dictionary = {}

var _arena: Node2D
var _spotlight_dim: ColorRect
var _ult_banner: Label
var _timer_lbl: Label
var _speed_lbl: Label
var _pause_lbl: Label
var _ai_feed_lbl: Label

var _heroes: Array = []
var _enemies: Array = []
var _hud_cards: Dictionary = {}

var _battle_time: float = 90.0
var _speed_mult: float = 1.0
var _paused: bool = false
var _finished: bool = false
var _hitstop_active: bool = false

# Hero 2 Front (index 0..1) + 3 Back (index 2..4)
const HERO_SLOTS := [
	Vector2(245, 515),
	Vector2(235, 650),
	Vector2(108, 455),
	Vector2(98, 585),
	Vector2(115, 715),
]

const ENEMY_SLOTS := [
	Vector2(475, 515),
	Vector2(485, 650),
	Vector2(612, 455),
	Vector2(622, 585),
	Vector2(605, 715),
]


func setup_screen(app: Control, params: Dictionary = {}) -> void:
	_app = app
	_stage_num = clampi(int(params.get("stage", PlayerState.selected_stage)), 1, 20)


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_stage_data = GameData.get_stage_data(_stage_num)

	_build_arena()
	_build_top_hud()
	_build_bottom_squad_hud()
	_spawn_combatants()


func _build_arena() -> void:
	_arena = Node2D.new()
	_arena.name = "BattleArena"
	add_child(_arena)

	var bg := Sprite2D.new()
	var bg_tex: Texture2D = load(String(_stage_data["bg_path"]))
	bg.texture = bg_tex
	bg.centered = false
	if bg_tex != null:
		var sc := maxf(720.0 / float(bg_tex.get_width()), 880.0 / float(bg_tex.get_height()))
		bg.scale = Vector2(sc, sc)
		bg.position = Vector2((720.0 - float(bg_tex.get_width()) * sc) * 0.5, 0.0)
	_arena.add_child(bg)

	# Ground lane readability tint
	var lane := Polygon2D.new()
	lane.polygon = PackedVector2Array([
		Vector2(-30, 410), Vector2(750, 410), Vector2(750, 880), Vector2(-30, 880)
	])
	lane.color = Color(0.06, 0.08, 0.10, 0.25)
	_arena.add_child(lane)

	_spotlight_dim = ColorRect.new()
	_spotlight_dim.color = Color(0.02, 0.02, 0.06, 0.0)
	_spotlight_dim.position = Vector2(-20, -20)
	_spotlight_dim.size = Vector2(760, 920)
	_spotlight_dim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_arena.add_child(_spotlight_dim)

	_arena.add_child(UiFx.create_ambient_particles(String(_stage_data["biome"]), 720.0))

	_ult_banner = Label.new()
	_ult_banner.position = Vector2(40, 210)
	_ult_banner.size = Vector2(640, 50)
	_ult_banner.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_ult_banner.modulate.a = 0.0
	_ult_banner.add_theme_font_size_override("font_size", 28)
	_ult_banner.add_theme_color_override("font_color", Color(1.0, 0.92, 0.42))
	_ult_banner.add_theme_color_override("font_outline_color", Color.BLACK)
	_ult_banner.add_theme_constant_override("outline_size", 6)
	_arena.add_child(_ult_banner)


func _build_top_hud() -> void:
	var bar := PanelContainer.new()
	bar.position = Vector2(12, 14)
	bar.size = Vector2(696, 78)
	bar.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.09, 0.08, 0.16, 0.88), Color(0.95, 0.78, 0.36), 18, 2))
	add_child(bar)

	var hb := HBoxContainer.new()
	hb.add_theme_constant_override("separation", 10)
	bar.add_child(hb)

	var back_btn := _make_hud_icon_btn("res://assets/sprites/ui/ui_btn_back.png", func() -> void:
		Engine.time_scale = 1.0
		_app.navigate_to("campaign")
	)
	hb.add_child(back_btn)

	var st_lbl := Label.new()
	st_lbl.text = String(_stage_data["name"])
	st_lbl.custom_minimum_size = Vector2(260, 58)
	st_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	st_lbl.add_theme_font_size_override("font_size", 20)
	st_lbl.add_theme_color_override("font_color", Color(1.0, 0.90, 0.45))
	hb.add_child(st_lbl)

	_timer_lbl = Label.new()
	_timer_lbl.text = "01:30"
	_timer_lbl.custom_minimum_size = Vector2(110, 58)
	_timer_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_timer_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_timer_lbl.add_theme_font_size_override("font_size", 22)
	_timer_lbl.add_theme_color_override("font_color", Color.WHITE)
	hb.add_child(_timer_lbl)

	var spd_btn := _make_hud_icon_btn("res://assets/sprites/ui/ui_btn_speed_x2.png", _toggle_speed)
	hb.add_child(spd_btn)
	_speed_lbl = Label.new()
	_speed_lbl.text = "1x"
	_speed_lbl.position = Vector2(18, 40)
	_speed_lbl.add_theme_font_size_override("font_size", 14)
	_speed_lbl.add_theme_color_override("font_color", Color(1.0, 0.95, 0.45))
	_speed_lbl.add_theme_color_override("font_outline_color", Color.BLACK)
	_speed_lbl.add_theme_constant_override("outline_size", 3)
	spd_btn.add_child(_speed_lbl)

	var pause_btn := _make_hud_icon_btn("res://assets/sprites/ui/ui_btn_pause.png", _toggle_pause)
	hb.add_child(pause_btn)
	_pause_lbl = Label.new()
	_pause_lbl.text = ""
	_pause_lbl.position = Vector2(10, 40)
	_pause_lbl.add_theme_font_size_override("font_size", 12)
	pause_btn.add_child(_pause_lbl)


func _make_hud_icon_btn(icon_path: String, cb: Callable) -> Button:
	var btn := Button.new()
	btn.custom_minimum_size = Vector2(60, 60)
	btn.flat = true
	btn.pressed.connect(cb)
	UiFx.attach_press_bounce(btn)
	var ic := TextureRect.new()
	ic.texture = load(icon_path)
	ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	ic.size = Vector2(58, 58)
	ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
	btn.add_child(ic)
	return btn


func _build_bottom_squad_hud() -> void:
	var panel := PanelContainer.new()
	panel.position = Vector2(0, 860)
	panel.size = Vector2(720, 420)
	panel.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.09, 0.08, 0.16, 0.98), Color(0.95, 0.78, 0.36), 0, 3))
	add_child(panel)

	var vb := VBoxContainer.new()
	vb.add_theme_constant_override("separation", 12)
	panel.add_child(vb)

	var syn := GameData.get_synergy_bonus(PlayerState.team_slots)
	var top_info := Label.new()
	top_info.text = "FULL AUTO 5v5  •  Synergy: %s" % String(syn["label"])
	top_info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	top_info.add_theme_font_size_override("font_size", 16)
	top_info.add_theme_color_override("font_color", Color(0.62, 0.96, 0.68))
	vb.add_child(top_info)

	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 10)
	vb.add_child(row)

	for i in 5:
		var hid := PlayerState.team_slots[i]
		if hid == "" or not PlayerState.owned_heroes.has(hid):
			continue
		var rec: Dictionary = PlayerState.get_hero_record(hid)
		var evo := String(rec["evo"])

		var card := Control.new()
		card.custom_minimum_size = Vector2(128, 178)
		row.add_child(card)

		var port := TextureRect.new()
		port.texture = load(GameData.get_hero_portrait_path(hid, evo))
		port.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		port.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		port.position = Vector2(18, 18)
		port.size = Vector2(92, 92)
		card.add_child(port)

		var frame := TextureRect.new()
		frame.texture = load("res://assets/sprites/ui/ui_battle_portrait_frame.png")
		frame.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		frame.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		frame.size = Vector2(128, 140)
		card.add_child(frame)

		var ult_glow := TextureRect.new()
		ult_glow.texture = load("res://assets/sprites/ui/ui_battle_ult_ready_glow.png")
		ult_glow.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		ult_glow.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		ult_glow.size = Vector2(128, 140)
		ult_glow.visible = false
		card.add_child(ult_glow)

		var hp_bar := ProgressBar.new()
		hp_bar.position = Vector2(10, 144)
		hp_bar.size = Vector2(108, 12)
		hp_bar.show_percentage = false
		hp_bar.max_value = 100.0
		hp_bar.value = 100.0
		hp_bar.add_theme_stylebox_override("fill", UiFx.make_panel_style(Color(0.24, 0.86, 0.46), Color.TRANSPARENT, 4, 0))
		card.add_child(hp_bar)

		var en_bar := ProgressBar.new()
		en_bar.position = Vector2(10, 159)
		en_bar.size = Vector2(108, 9)
		en_bar.show_percentage = false
		en_bar.max_value = 100.0
		en_bar.value = 25.0
		en_bar.add_theme_stylebox_override("fill", UiFx.make_panel_style(Color(0.28, 0.84, 1.0), Color.TRANSPARENT, 3, 0))
		card.add_child(en_bar)

		_hud_cards[hid] = {"card": card, "hp": hp_bar, "en": en_bar, "glow": ult_glow}

	_ai_feed_lbl = Label.new()
	_ai_feed_lbl.text = "Combat AI Active — Quan sát kỹ năng & hành vi tiến hóa!"
	_ai_feed_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_ai_feed_lbl.add_theme_font_size_override("font_size", 16)
	_ai_feed_lbl.add_theme_color_override("font_color", Color(0.88, 0.92, 1.0))
	vb.add_child(_ai_feed_lbl)


func _spawn_combatants() -> void:
	var syn := GameData.get_synergy_bonus(PlayerState.team_slots)
	for i in 5:
		var hid := PlayerState.team_slots[i]
		if hid == "" or not PlayerState.owned_heroes.has(hid):
			continue
		var rec: Dictionary = PlayerState.get_hero_record(hid)
		var unit := BattleUnit.new()
		_arena.add_child(unit)
		unit.setup_hero(hid, rec, i, syn, HERO_SLOTS[i])
		unit.action_resolved.connect(_on_unit_action_resolved)
		unit.died.connect(_on_unit_died)
		unit.bars_updated.connect(_on_hero_bars_updated)
		_heroes.append(unit)
		_on_hero_bars_updated(unit)

	var enemy_ids: Array = _stage_data["enemies"]
	var stat_scale := float(_stage_data["stat_scale"])
	for j in enemy_ids.size():
		var eid := String(enemy_ids[j])
		var unit := BattleUnit.new()
		_arena.add_child(unit)
		unit.setup_enemy(eid, j, stat_scale, ENEMY_SLOTS[j])
		unit.action_resolved.connect(_on_unit_action_resolved)
		unit.died.connect(_on_unit_died)
		_enemies.append(unit)


func _process(delta: float) -> void:
	if _paused or _finished:
		return
	_battle_time = maxf(0.0, _battle_time - delta)
	var secs := int(ceil(_battle_time))
	_timer_lbl.text = "%02d:%02d" % [secs / 60, secs % 60]

	for h in _heroes:
		h.tick_combat(delta, _heroes, _enemies)
	for e in _enemies:
		e.tick_combat(delta, _enemies, _heroes)

	if _battle_time <= 0.0:
		_finish_battle(false)


func _on_unit_action_resolved(caster: BattleUnit, _target: BattleUnit, is_skill: bool, events: Array) -> void:
	if is_skill:
		AudioManager.play_sfx("skill_cast")
		_show_ult_spotlight("%s: %s!" % [caster.display_name, caster.skill_name])
		_ai_feed_lbl.text = "[%s] %s (%s)" % [caster.display_name, caster.skill_name, caster.ai_profile]
		_trigger_hitstop(0.08)
		_shake_arena(10.0)
	else:
		AudioManager.play_sfx("sword_hit")
		_trigger_hitstop(0.035)
		_shake_arena(3.5)

	for ev in events:
		var u: BattleUnit = ev["unit"]
		if is_instance_valid(u):
			_spawn_combat_popup(u.position + Vector2(0, -135), String(ev["kind"]), int(ev["amount"]), bool(ev.get("crit", false)), bool(ev.get("effective", false)))


func _on_hero_bars_updated(u: BattleUnit) -> void:
	if not u.is_hero or not _hud_cards.has(u.unit_id):
		return
	var d: Dictionary = _hud_cards[u.unit_id]
	d["hp"].value = (u.hp / maxf(1.0, u.max_hp)) * 100.0
	d["en"].value = (u.energy / u.max_energy) * 100.0
	d["glow"].visible = (not u.is_dead and u.energy >= u.max_energy)
	d["card"].modulate = Color(0.4, 0.4, 0.45, 0.65) if u.is_dead else Color.WHITE


func _on_unit_died(_unit: BattleUnit) -> void:
	var live_h := _heroes.filter(func(u: BattleUnit) -> bool: return not u.is_dead)
	var live_e := _enemies.filter(func(u: BattleUnit) -> bool: return not u.is_dead)
	if live_e.is_empty():
		_finish_battle(true)
	elif live_h.is_empty():
		_finish_battle(false)


func _finish_battle(won: bool) -> void:
	if _finished:
		return
	_finished = true
	Engine.time_scale = 1.0
	AudioManager.play_sfx("victory" if won else "defeat")
	var rew := PlayerState.complete_stage(_stage_num) if won else {}
	_show_result_modal(won, rew)


func _show_result_modal(won: bool, rew: Dictionary) -> void:
	var dim := ColorRect.new()
	dim.color = Color(0.02, 0.02, 0.06, 0.72)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(dim)

	var pc := PanelContainer.new()
	pc.position = Vector2(90, 320)
	pc.size = Vector2(540, 560)
	pc.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.11, 0.10, 0.19, 0.98), Color(1.0, 0.82, 0.36) if won else Color(0.86, 0.32, 0.34), 24, 3))
	add_child(pc)

	var vb := VBoxContainer.new()
	vb.alignment = BoxContainer.ALIGNMENT_CENTER
	vb.add_theme_constant_override("separation", 18)
	pc.add_child(vb)

	var crest := TextureRect.new()
	crest.texture = load("res://assets/sprites/ui/ui_banner_victory.png" if won else "res://assets/sprites/ui/ui_banner_defeat.png")
	crest.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	crest.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	crest.custom_minimum_size = Vector2(180, 180)
	vb.add_child(crest)

	var ttl := Label.new()
	ttl.text = "VICTORY!" if won else "DEFEAT"
	ttl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	ttl.add_theme_font_size_override("font_size", 38)
	ttl.add_theme_color_override("font_color", Color(1.0, 0.88, 0.38) if won else Color(1.0, 0.45, 0.45))
	vb.add_child(ttl)

	var desc := Label.new()
	desc.text = ("+%d Gold   •   +%d EXP   •   +%d Gems" % [int(rew["reward_gold"]), int(rew["reward_exp"]), int(rew["reward_gems"])]) if won else "Nâng cấp tướng hoặc đổi đội hình rồi thử lại!"
	desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	desc.add_theme_font_size_override("font_size", 20)
	desc.add_theme_color_override("font_color", Color(0.90, 0.94, 1.0))
	vb.add_child(desc)

	var hb := HBoxContainer.new()
	hb.alignment = BoxContainer.ALIGNMENT_CENTER
	hb.add_theme_constant_override("separation", 20)
	vb.add_child(hb)

	if won and _stage_num < 20:
		var next_btn := UiFx.make_styled_button("NEXT STAGE", Color(0.20, 0.56, 0.34), Vector2(210, 68), 20)
		next_btn.pressed.connect(func() -> void: _app.navigate_to("battle", {"stage": _stage_num + 1}))
		hb.add_child(next_btn)
	else:
		var retry_btn := UiFx.make_styled_button("RETRY", Color(0.76, 0.44, 0.16), Vector2(210, 68), 20)
		retry_btn.pressed.connect(func() -> void: _app.navigate_to("battle", {"stage": _stage_num}))
		hb.add_child(retry_btn)

	var map_btn := UiFx.make_styled_button("CAMPAIGN MAP", Color(0.28, 0.34, 0.56), Vector2(210, 68), 20)
	map_btn.pressed.connect(func() -> void: _app.navigate_to("campaign"))
	hb.add_child(map_btn)


func _show_ult_spotlight(msg: String) -> void:
	_ult_banner.text = msg
	_ult_banner.modulate.a = 1.0
	var dt := create_tween()
	dt.tween_property(_spotlight_dim, "color:a", 0.38, 0.08)
	dt.tween_property(_spotlight_dim, "color:a", 0.0, 0.28)
	var bt := create_tween()
	bt.tween_interval(0.55)
	bt.tween_property(_ult_banner, "modulate:a", 0.0, 0.35)


func _trigger_hitstop(dur: float) -> void:
	if _hitstop_active or _paused:
		return
	_hitstop_active = true
	Engine.time_scale = 0.08
	await get_tree().create_timer(dur, true, false, true).timeout
	if is_instance_valid(self) and not _paused and not _finished:
		Engine.time_scale = _speed_mult
	_hitstop_active = false


func _shake_arena(strength: float) -> void:
	var st := create_tween()
	st.tween_property(_arena, "position", Vector2(-strength, strength * 0.5), 0.03)
	st.tween_property(_arena, "position", Vector2(strength, -strength * 0.4), 0.03)
	st.tween_property(_arena, "position", Vector2.ZERO, 0.04)


func _spawn_combat_popup(pos: Vector2, kind: String, amt: int, is_crit: bool, effective: bool) -> void:
	var lbl := Label.new()
	var col := Color.WHITE
	var txt := "-%d" % amt
	if kind == "heal":
		txt = "+%d" % amt
		col = Color(0.36, 0.96, 0.56)
	elif kind == "shield":
		txt = "+%d SHIELD" % amt
		col = Color(1.0, 0.88, 0.34)
	elif effective:
		txt = "-%d WEAK!" % amt
		col = Color(1.0, 0.54, 0.24)
	elif is_crit:
		txt = "-%d!" % amt
		col = Color(1.0, 0.92, 0.36)

	lbl.text = txt
	lbl.position = pos + Vector2(randf_range(-24, 24) - 48, 0)
	lbl.add_theme_font_size_override("font_size", 30 if is_crit else 22)
	lbl.add_theme_color_override("font_color", col)
	lbl.add_theme_color_override("font_outline_color", Color.BLACK)
	lbl.add_theme_constant_override("outline_size", 5)
	_arena.add_child(lbl)

	var t := create_tween()
	t.tween_property(lbl, "position:y", lbl.position.y - 46.0, 0.24).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	t.tween_property(lbl, "position:y", lbl.position.y - 26.0, 0.28).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	t.parallel().tween_property(lbl, "modulate:a", 0.0, 0.28)
	t.tween_callback(lbl.queue_free)


func _toggle_speed() -> void:
	_speed_mult = 2.0 if is_equal_approx(_speed_mult, 1.0) else 1.0
	_speed_lbl.text = "%dx" % int(_speed_mult)
	if not _paused and not _hitstop_active:
		Engine.time_scale = _speed_mult


func _toggle_pause() -> void:
	_paused = not _paused
	Engine.time_scale = 0.0 if _paused else _speed_mult
	_pause_lbl.text = "PAUSED" if _paused else ""


func _exit_tree() -> void:
	Engine.time_scale = 1.0
