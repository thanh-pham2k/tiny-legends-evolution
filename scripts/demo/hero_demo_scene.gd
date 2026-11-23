extends Node2D

const TEX_BG_PLAINS := preload("res://assets/sprites/backgrounds/bg_plains_kingdom.png")

var _arena_root: Node2D
var _control_deck: PanelContainer
var _wide_background: TextureRect
var _arena_background: Sprite2D
var _lane: Polygon2D
var _knight: UnitVisual
var _goblin: UnitVisual

var _knight_hp_bar: ProgressBar
var _goblin_hp_bar: ProgressBar
var _status_label: Label
var _btn_auto: Button
var _btn_speed: Button
var _btn_juice: Button

var _auto_battle: bool = true
var _speed_scale: float = 1.0
var _juice_enabled: bool = true
var _auto_timer: float = 0.65
var _auto_step: int = 0
var _goblin_hp: float = 100.0
var _knight_hp: float = 100.0


func _ready() -> void:
	Engine.time_scale = _speed_scale
	_build_scene()
	_configure_units()
	get_viewport().size_changed.connect(_layout)
	_layout()
	_update_ui_labels()


func _build_scene() -> void:
	var background_layer := CanvasLayer.new()
	background_layer.layer = -1
	add_child(background_layer)
	_wide_background = TextureRect.new()
	_wide_background.texture = TEX_BG_PLAINS
	_wide_background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_wide_background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	_wide_background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_wide_background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background_layer.add_child(_wide_background)

	# Upper Battle Arena (720 x 740)
	_arena_root = Node2D.new()
	_arena_root.name = "ArenaRoot"
	add_child(_arena_root)

	var bg := Sprite2D.new()
	_arena_background = bg
	bg.name = "BattleBackground"
	bg.texture = TEX_BG_PLAINS
	bg.centered = false
	bg.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	if TEX_BG_PLAINS != null:
		var tw := float(TEX_BG_PLAINS.get_width())
		var th := float(TEX_BG_PLAINS.get_height())
		var sc := maxf(720.0 / tw, 740.0 / th)
		bg.scale = Vector2(sc, sc)
		bg.position = Vector2((720.0 - tw * sc) * 0.5, (740.0 - th * sc) * 0.5)
	_arena_root.add_child(bg)

	# Ground lane tint strip for clear unit readability
	var lane := Polygon2D.new()
	_lane = lane
	lane.polygon = PackedVector2Array([
		Vector2(-40, 520),
		Vector2(760, 520),
		Vector2(760, 740),
		Vector2(-40, 740),
	])
	lane.color = Color(0.08, 0.14, 0.08, 0.28)
	_arena_root.add_child(lane)

	# Knight (left, facing right)
	_knight = UnitVisual.new()
	_knight.name = "Knight"
	_knight.facing_sign = 1.0
	_knight.unit_scale = 2.0
	_knight.position = Vector2(200, 625)
	_knight.impact_hit.connect(_on_knight_impact)
	_knight.state_changed.connect(_on_knight_state_changed)
	_arena_root.add_child(_knight)

	# Goblin dummy (right, facing left)
	_goblin = UnitVisual.new()
	_goblin.name = "Goblin"
	_goblin.facing_sign = -1.0
	_goblin.art_facing = -1.0
	_goblin.unit_scale = 1.75
	_goblin.position = Vector2(530, 625)
	_arena_root.add_child(_goblin)

	# Overhead HP bars inside ArenaRoot
	_knight_hp_bar = _create_hp_bar(Vector2(130, 385), Color(0.22, 0.78, 0.42))
	_goblin_hp_bar = _create_hp_bar(Vector2(460, 410), Color(0.90, 0.28, 0.28))

	# Lower Control Deck (y: 740..1280)
	var ui_layer := CanvasLayer.new()
	ui_layer.name = "ControlDeck"
	add_child(ui_layer)

	var panel := PanelContainer.new()
	_control_deck = panel
	panel.position = Vector2(0, 740)
	panel.size = Vector2(720, 540)
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.11, 0.12, 0.18, 1.0)
	style.border_color = Color(0.86, 0.68, 0.28, 1.0)
	style.border_width_top = 4
	style.content_margin_left = 24
	style.content_margin_right = 24
	style.content_margin_top = 20
	style.content_margin_bottom = 20
	panel.add_theme_stylebox_override("panel", style)
	ui_layer.add_child(panel)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 14)
	panel.add_child(vbox)

	var title := Label.new()
	title.text = "TINY LEGENDS: EVOLUTION — KNIGHT 60 FPS DEMO"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 22)
	title.add_theme_color_override("font_color", Color(1.0, 0.88, 0.45))
	vbox.add_child(title)

	_status_label = Label.new()
	_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_status_label.add_theme_font_size_override("font_size", 18)
	_status_label.add_theme_color_override("font_color", Color(0.80, 0.90, 1.0))
	vbox.add_child(_status_label)

	# Row 1: Mode toggles
	var row1 := HBoxContainer.new()
	row1.add_theme_constant_override("separation", 12)
	row1.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_child(row1)

	_btn_auto = _make_button("Auto Battle: ON", Color(0.18, 0.50, 0.32), _on_toggle_auto)
	_btn_speed = _make_button("Speed: 1x", Color(0.22, 0.42, 0.68), _on_toggle_speed)
	_btn_juice = _make_button("60 FPS Juice: ON", Color(0.56, 0.34, 0.68), _on_toggle_juice)
	row1.add_child(_btn_auto)
	row1.add_child(_btn_speed)
	row1.add_child(_btn_juice)

	# Row 2 & 3: Manual action triggers
	var row2 := HBoxContainer.new()
	row2.add_theme_constant_override("separation", 12)
	row2.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_child(row2)
	row2.add_child(_make_button("Idle (4f)", Color(0.24, 0.27, 0.36), func() -> void: _trigger_manual("idle")))
	row2.add_child(_make_button("Run (6f)", Color(0.24, 0.27, 0.36), func() -> void: _trigger_manual("run")))
	row2.add_child(_make_button("Attack (6f)", Color(0.70, 0.38, 0.16), func() -> void: _trigger_manual("attack")))

	var row3 := HBoxContainer.new()
	row3.add_theme_constant_override("separation", 12)
	row3.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_child(row3)
	row3.add_child(_make_button("Skill (6f)", Color(0.14, 0.54, 0.72), func() -> void: _trigger_manual("skill")))
	row3.add_child(_make_button("Hit Flash", Color(0.62, 0.24, 0.28), func() -> void: _trigger_manual("hit")))
	row3.add_child(_make_button("Death / Reset", Color(0.36, 0.22, 0.26), func() -> void: _trigger_manual("death")))

	var hint := Label.new()
	hint.text = "Bat/tat '60 FPS Juice' de so sanh Sprite Sheet tho vs Hybrid 60 FPS"
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.add_theme_font_size_override("font_size", 15)
	hint.add_theme_color_override("font_color", Color(0.68, 0.72, 0.80))
	vbox.add_child(hint)


func _create_hp_bar(pos: Vector2, fill_color: Color) -> ProgressBar:
	var bar := ProgressBar.new()
	bar.position = pos
	bar.size = Vector2(140, 18)
	bar.max_value = 100.0
	bar.value = 100.0
	bar.show_percentage = false

	var bg_sb := StyleBoxFlat.new()
	bg_sb.bg_color = Color(0.10, 0.10, 0.14, 0.85)
	bg_sb.border_color = Color(0.95, 0.85, 0.50, 0.9)
	bg_sb.set_border_width_all(2)
	bg_sb.set_corner_radius_all(6)

	var fill_sb := StyleBoxFlat.new()
	fill_sb.bg_color = fill_color
	fill_sb.set_corner_radius_all(4)

	bar.add_theme_stylebox_override("background", bg_sb)
	bar.add_theme_stylebox_override("fill", fill_sb)
	_arena_root.add_child(bar)
	return bar


func _make_button(label_text: String, base_col: Color, callback: Callable) -> Button:
	var btn := Button.new()
	btn.text = label_text
	btn.custom_minimum_size = Vector2(204, 68)
	btn.add_theme_font_size_override("font_size", 18)
	var sb := StyleBoxFlat.new()
	sb.bg_color = base_col
	sb.border_color = Color(0.95, 0.85, 0.55, 0.65)
	sb.set_border_width_all(2)
	sb.set_corner_radius_all(12)
	btn.add_theme_stylebox_override("normal", sb)
	var sb_hover := sb.duplicate()
	sb_hover.bg_color = base_col.lightened(0.14)
	btn.add_theme_stylebox_override("hover", sb_hover)
	btn.pressed.connect(callback)
	return btn


func _configure_units() -> void:
	_knight.configure_animations(GameData.get_hero_anim_map("knight"))
	_goblin.configure_animations(GameData.get_enemy_anim_map("goblin"))


func _process(delta: float) -> void:
	if not _auto_battle or _knight.is_dead:
		return
	_auto_timer -= delta
	if _auto_timer <= 0.0:
		_auto_step = (_auto_step + 1) % 3
		if _auto_step == 2:
			_knight.play_skill(_goblin.global_position.x)
			_auto_timer = 1.6
		else:
			_knight.play_attack(_goblin.global_position.x)
			_auto_timer = 1.25


func _on_knight_impact(is_skill: bool) -> void:
	var dmg: int = 38 if is_skill else 18
	_goblin_hp -= float(dmg)
	_goblin_hp_bar.value = maxf(0.0, _goblin_hp)
	_spawn_damage_popup(_goblin.position + Vector2(0, -175), dmg, is_skill)

	if _juice_enabled:
		var stop := 0.068 if is_skill else 0.033
		_knight.freeze_pose(stop)
		_goblin.freeze_pose(stop)
		_shake_arena(6.0 if is_skill else 2.5)

	if _goblin_hp <= 0.0:
		_goblin.play_death()
		var t := get_tree().create_timer(1.1)
		t.timeout.connect(func() -> void:
			if is_instance_valid(_goblin):
				_goblin_hp = 100.0
				_goblin_hp_bar.value = 100.0
				_goblin.respawn()
		)
	else:
		_goblin.play_hit(is_skill)


func _shake_arena(strength: float) -> void:
	var st := create_tween()
	st.tween_property(_arena_root, "position", Vector2(-strength, strength * 0.5), 0.03)
	st.tween_property(_arena_root, "position", Vector2(strength, -strength * 0.4), 0.03)
	st.tween_property(_arena_root, "position", Vector2.ZERO, 0.04)


func _spawn_damage_popup(world_pos: Vector2, dmg: int, is_crit: bool) -> void:
	var lbl := Label.new()
	lbl.text = "-%d%s" % [dmg, "!" if is_crit else ""]
	lbl.position = world_pos - Vector2(40, 0)
	lbl.add_theme_font_size_override("font_size", 36 if is_crit else 28)
	lbl.add_theme_color_override("font_color", Color(0.35, 0.95, 1.0) if is_crit else Color(1.0, 0.92, 0.45))
	lbl.add_theme_color_override("font_outline_color", Color(0.08, 0.08, 0.12))
	lbl.add_theme_constant_override("outline_size", 6)
	_arena_root.add_child(lbl)

	var dt := create_tween()
	dt.tween_property(lbl, "position:y", lbl.position.y - 54.0, 0.55).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	dt.parallel().tween_property(lbl, "modulate:a", 0.0, 0.55)
	dt.tween_callback(lbl.queue_free)


func _trigger_manual(action: String) -> void:
	_auto_battle = false
	_update_ui_labels()
	if action != "death" and _knight.is_dead:
		_knight.respawn()

	match action:
		"idle":
			_knight.play_idle()
		"run":
			_knight.play_run()
		"attack":
			_knight.play_attack(_goblin.global_position.x)
		"skill":
			_knight.play_skill(_goblin.global_position.x)
		"hit":
			_knight.play_hit(false)
			_knight_hp = maxf(20.0, _knight_hp - 12.0)
			_knight_hp_bar.value = _knight_hp
		"death":
			if _knight.is_dead:
				_knight.respawn()
				_knight_hp = 100.0
				_knight_hp_bar.value = 100.0
			else:
				_knight.play_death()


func _on_toggle_auto() -> void:
	_auto_battle = not _auto_battle
	if _auto_battle and _knight.is_dead:
		_knight.respawn()
	_auto_timer = 0.25
	_update_ui_labels()


func _on_toggle_speed() -> void:
	_speed_scale = 2.0 if is_equal_approx(_speed_scale, 1.0) else 1.0
	Engine.time_scale = _speed_scale
	_update_ui_labels()


func _on_toggle_juice() -> void:
	_juice_enabled = not _juice_enabled
	_knight.set_juice_enabled(_juice_enabled)
	_goblin.set_juice_enabled(_juice_enabled)
	_update_ui_labels()


func _on_knight_state_changed(_state_name: String) -> void:
	_update_ui_labels()


func _update_ui_labels() -> void:
	if _status_label == null:
		return
	var state_str := _knight.current_state.to_upper() if _knight != null else "IDLE"
	var mode_str := "AUTO BATTLE" if _auto_battle else "MANUAL"
	var juice_str := "HYBRID 60 FPS" if _juice_enabled else "RAW SPRITE SHEET"
	_status_label.text = "State: %s  |  %s  |  %s  |  %dx" % [state_str, mode_str, juice_str, int(_speed_scale)]
	_btn_auto.text = "Auto Battle: %s" % ("ON" if _auto_battle else "OFF")
	_btn_speed.text = "Speed: %dx" % int(_speed_scale)
	_btn_juice.text = "60 FPS Juice: %s" % ("ON" if _juice_enabled else "OFF")


func _layout() -> void:
	var area := get_viewport_rect().size
	var wide := UiFx.is_wide(area)
	_wide_background.visible = wide
	_arena_background.visible = not wide
	_lane.visible = not wide
	if wide:
		var stage_width := (area.x - 32.0) * 0.62
		var fit := UiFx.fit_rect(Vector2(720, 640), Rect2(8, 8, stage_width, area.y - 16))
		var zoom := fit.size.x / 720.0
		scale = Vector2.ONE * zoom
		position = fit.position - Vector2(0, 100.0 * zoom)
		UiFx.fit_control(_control_deck, Vector2(720, 420), Rect2(16 + stage_width, 8, area.x - stage_width - 24, area.y - 16))
	else:
		var fit := UiFx.fit_rect(Vector2(720, 1280), Rect2(Vector2.ZERO, area))
		scale = Vector2.ONE * (fit.size.x / 720.0)
		position = fit.position
		UiFx.fit_control(_control_deck, Vector2(720, 540), Rect2(position + Vector2(0, 740) * scale, Vector2(720, 540) * scale))


func _exit_tree() -> void:
	Engine.time_scale = 1.0
