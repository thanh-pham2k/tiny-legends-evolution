extends Control

var _app: Control
var _panel: PanelContainer
var _chest: TextureRect
var _gold_lbl: Label
var _exp_lbl: Label
var _gem_lbl: Label
var _time_lbl: Label
var _claimed: bool = false


func setup_popup(app: Control) -> void:
	_app = app


func _ready() -> void:
	var dim := ColorRect.new()
	dim.color = Color(0.02, 0.02, 0.06, 0.72)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(dim)

	_panel = PanelContainer.new()
	_panel.position = Vector2(55, 220)
	_panel.size = Vector2(610, 790)
	_panel.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.11, 0.10, 0.19, 0.98), Color(1.0, 0.80, 0.34), 26, 3))
	add_child(_panel)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 16)
	_panel.add_child(vbox)

	# Top backdrop banner
	var stage_wrap := Control.new()
	stage_wrap.custom_minimum_size = Vector2(580, 300)
	vbox.add_child(stage_wrap)

	var stage_bg := TextureRect.new()
	stage_bg.texture = load("res://assets/sprites/backgrounds/bg_idle_rewards_stage.png")
	stage_bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stage_bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	stage_bg.size = Vector2(580, 300)
	stage_wrap.add_child(stage_bg)

	var header := Label.new()
	header.text = "IDLE REWARDS"
	header.position = Vector2(0, 14)
	header.size = Vector2(580, 42)
	header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	header.add_theme_font_size_override("font_size", 30)
	header.add_theme_color_override("font_color", Color(1.0, 0.88, 0.40))
	header.add_theme_color_override("font_outline_color", Color(0.06, 0.05, 0.12))
	header.add_theme_constant_override("outline_size", 6)
	stage_wrap.add_child(header)

	_chest = TextureRect.new()
	_chest.texture = load("res://assets/sprites/items/item_treasure_chest.png")
	_chest.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_chest.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_chest.position = Vector2(195, 76)
	_chest.size = Vector2(190, 190)
	_chest.pivot_offset = Vector2(95, 95)
	stage_wrap.add_child(_chest)

	# Subtle idle chest shake loop
	var ct := create_tween().set_loops()
	ct.tween_property(_chest, "rotation", 0.05, 0.12)
	ct.tween_property(_chest, "rotation", -0.05, 0.12)
	ct.tween_property(_chest, "rotation", 0.0, 0.12)
	ct.tween_interval(1.1)

	var pending := PlayerState.get_pending_idle_rewards()
	var mins := int(pending["elapsed_sec"]) / 60
	_time_lbl = Label.new()
	_time_lbl.text = "Tích lũy: %dh %02dm  (Stage %d Bonus)" % [mins / 60, mins % 60, PlayerState.max_stage_unlocked]
	_time_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_time_lbl.add_theme_font_size_override("font_size", 19)
	_time_lbl.add_theme_color_override("font_color", Color(0.84, 0.90, 1.0))
	vbox.add_child(_time_lbl)

	# Reward cards row
	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 18)
	vbox.add_child(row)

	_gold_lbl = _make_reward_tile(row, "res://assets/sprites/items/item_gold_coin.png", "+%d" % int(pending["gold"]), "Gold")
	_exp_lbl = _make_reward_tile(row, "res://assets/sprites/items/item_skill_scroll.png", "+%d" % int(pending["exp"]), "EXP")
	_gem_lbl = _make_reward_tile(row, "res://assets/sprites/items/item_purple_gem.png", "+%d" % int(pending["gems"]), "Gems")

	var btn_row := HBoxContainer.new()
	btn_row.alignment = BoxContainer.ALIGNMENT_CENTER
	btn_row.add_theme_constant_override("separation", 20)
	vbox.add_child(btn_row)

	var claim_btn := UiFx.make_styled_button("CLAIM REWARDS", Color(0.82, 0.56, 0.12), Vector2(260, 70), 22)
	claim_btn.pressed.connect(func() -> void:
		if _claimed:
			queue_free()
			return
		_claimed = true
		var rew := PlayerState.claim_idle_rewards()
		AudioManager.play_sfx("chest_open")
		UiFx.spawn_flying_coins(self, Vector2(360, 420), Vector2(210, 60), "res://assets/sprites/items/item_gold_coin.png", 10)
		UiFx.spawn_flying_coins(self, Vector2(360, 420), Vector2(440, 60), "res://assets/sprites/items/item_purple_gem.png", 6)
		UiFx.animate_rolling_number(_gold_lbl, int(rew["gold"]), 0, 0.45, "+")
		UiFx.animate_rolling_number(_exp_lbl, int(rew["exp"]), 0, 0.45, "+")
		UiFx.animate_rolling_number(_gem_lbl, int(rew["gems"]), 0, 0.45, "+")
		_time_lbl.text = "Đã nhận toàn bộ tài nguyên!"
		claim_btn.text = "CLOSE"
		var close_t := create_tween()
		close_t.tween_interval(0.95)
		close_t.tween_callback(queue_free)
	)
	btn_row.add_child(claim_btn)

	var close_btn := UiFx.make_styled_button("LATER", Color(0.26, 0.28, 0.38), Vector2(150, 70), 20)
	close_btn.pressed.connect(queue_free)
	btn_row.add_child(close_btn)


func _make_reward_tile(parent: HBoxContainer, icon_path: String, val_str: String, title_str: String) -> Label:
	var pc := PanelContainer.new()
	pc.custom_minimum_size = Vector2(158, 170)
	pc.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.16, 0.15, 0.28), Color(0.55, 0.50, 0.78), 16, 2))
	parent.add_child(pc)

	var vb := VBoxContainer.new()
	vb.alignment = BoxContainer.ALIGNMENT_CENTER
	vb.add_theme_constant_override("separation", 6)
	pc.add_child(vb)

	var tr := TextureRect.new()
	tr.texture = load(icon_path)
	tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	tr.custom_minimum_size = Vector2(74, 74)
	vb.add_child(tr)

	var val_lbl := Label.new()
	val_lbl.text = val_str
	val_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	val_lbl.add_theme_font_size_override("font_size", 22)
	val_lbl.add_theme_color_override("font_color", Color(1.0, 0.90, 0.44))
	vb.add_child(val_lbl)

	var t_lbl := Label.new()
	t_lbl.text = title_str
	t_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	t_lbl.add_theme_font_size_override("font_size", 14)
	t_lbl.add_theme_color_override("font_color", Color(0.76, 0.80, 0.92))
	vb.add_child(t_lbl)
	return val_lbl
