extends Control

var _app: Control
var _modal: Control
var _card_root: Control
var _grid: GridContainer
var _scroll: ScrollContainer
var _time_lbl: Label
var _collect_btn: Button
var _slot_labels: Dictionary = {}
var _pending_entries: Array = []
var _claimed: bool = false
var _is_empty: bool = false


func setup_popup(app: Control) -> void:
	_app = app


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var dim := ColorRect.new()
	dim.color = Color(0.02, 0.02, 0.06, 0.72)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.gui_input.connect(func(ev: InputEvent) -> void:
		if ev is InputEventMouseButton and ev.pressed and not _claimed:
			queue_free()
	)
	add_child(dim)

	_modal = Control.new()
	_modal.custom_minimum_size = Vector2(580, 490)
	_modal.size = Vector2(580, 490)
	_modal.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_modal)
	UiFx.center_modal(self, _modal)

	_card_root = Control.new()
	_card_root.size = Vector2(580, 490)
	_card_root.pivot_offset = Vector2(290, 245)
	_card_root.modulate.a = 0.0
	_card_root.scale = Vector2(0.88, 0.88)
	_modal.add_child(_card_root)

	# Subtle warm magical radial glow behind the parchment frame
	var glow_grad := Gradient.new()
	glow_grad.colors = PackedColorArray([
		Color(1.0, 0.84, 0.38, 0.24),
		Color(1.0, 0.72, 0.25, 0.08),
		Color(1.0, 0.72, 0.25, 0.0),
	])
	glow_grad.offsets = PackedFloat32Array([0.0, 0.55, 1.0])
	var glow_tex := GradientTexture2D.new()
	glow_tex.gradient = glow_grad
	glow_tex.fill = GradientTexture2D.FILL_RADIAL
	glow_tex.fill_from = Vector2(0.5, 0.5)
	glow_tex.fill_to = Vector2(0.5, 0.0)
	var glow_bg := TextureRect.new()
	glow_bg.texture = glow_tex
	glow_bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	glow_bg.position = Vector2(-40, -40)
	glow_bg.size = Vector2(660, 570)
	glow_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_card_root.add_child(glow_bg)

	# Parchment base panel
	var parchment := TextureRect.new()
	parchment.texture = load("res://assets/sprites/ui/ui_parchment_panel.png")
	parchment.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	parchment.stretch_mode = TextureRect.STRETCH_SCALE
	parchment.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	parchment.mouse_filter = Control.MOUSE_FILTER_STOP
	_card_root.add_child(parchment)

	# Ornate top ribbon banner
	var ribbon := TextureRect.new()
	ribbon.texture = load("res://assets/sprites/ui/ui_ribbon_red.png")
	ribbon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	ribbon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	ribbon.position = Vector2(125, -4)
	ribbon.size = Vector2(330, 84)
	ribbon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_card_root.add_child(ribbon)

	var title := Label.new()
	title.text = "IDLE REWARDS"
	title.position = Vector2(0, 12)
	title.size = Vector2(330, 42)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 21)
	title.add_theme_color_override("font_color", Color(1.0, 0.96, 0.84))
	title.add_theme_color_override("font_outline_color", Color(0.24, 0.08, 0.04))
	title.add_theme_constant_override("outline_size", 5)
	ribbon.add_child(title)

	# Compact top-right close button
	var close_btn := Button.new()
	close_btn.text = "✕"
	close_btn.position = Vector2(524, 24)
	close_btn.size = Vector2(34, 34)
	close_btn.add_theme_font_size_override("font_size", 17)
	close_btn.add_theme_color_override("font_color", Color(1.0, 0.94, 0.78))
	var close_sb := UiFx.make_panel_style(Color(0.32, 0.16, 0.08, 0.95), Color(0.95, 0.76, 0.34), 17, 2)
	close_btn.add_theme_stylebox_override("normal", close_sb)
	var close_hover := close_sb.duplicate()
	close_hover.bg_color = Color(0.46, 0.22, 0.12, 0.98)
	close_btn.add_theme_stylebox_override("hover", close_hover)
	close_btn.add_theme_stylebox_override("pressed", close_sb)
	UiFx.attach_press_bounce(close_btn)
	close_btn.pressed.connect(queue_free)
	_card_root.add_child(close_btn)

	# Inner parchment content area
	var inner := Control.new()
	inner.position = Vector2(46, 76)
	inner.size = Vector2(488, 370)
	inner.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_card_root.add_child(inner)

	var vbox := VBoxContainer.new()
	vbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	vbox.add_theme_constant_override("separation", 10)
	inner.add_child(vbox)

	# Compact Header Strip: accumulated time & stage bonus (inset cleanly inside corner ornaments)
	var hdr_wrap := MarginContainer.new()
	hdr_wrap.add_theme_constant_override("margin_left", 24)
	hdr_wrap.add_theme_constant_override("margin_right", 24)
	vbox.add_child(hdr_wrap)

	var hdr_panel := PanelContainer.new()
	hdr_panel.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.24, 0.14, 0.08, 0.86), Color(0.86, 0.66, 0.28, 0.65), 12, 1))
	hdr_wrap.add_child(hdr_panel)

	var hdr_mc := MarginContainer.new()
	hdr_mc.add_theme_constant_override("margin_left", 12)
	hdr_mc.add_theme_constant_override("margin_right", 12)
	hdr_mc.add_theme_constant_override("margin_top", 6)
	hdr_mc.add_theme_constant_override("margin_bottom", 6)
	hdr_panel.add_child(hdr_mc)

	var pending: Dictionary = PlayerState.get_pending_idle_rewards()
	var mins: int = int(pending["elapsed_sec"]) / 60
	var bonus_pct: int = int(round(float(PlayerState.max_stage_unlocked - 1) * 15.0))
	_time_lbl = Label.new()
	_time_lbl.text = "Tích lũy: %dh %02dm / 12h   •   Stage %d (+%d%% Bonus)" % [mins / 60, mins % 60, PlayerState.max_stage_unlocked, bonus_pct]
	_time_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_time_lbl.add_theme_font_size_override("font_size", 14)
	_time_lbl.add_theme_color_override("font_color", Color(1.0, 0.94, 0.78))
	hdr_mc.add_child(_time_lbl)

	# Recessed 4-column reward tray
	var tray := PanelContainer.new()
	tray.size_flags_vertical = Control.SIZE_EXPAND_FILL
	tray.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.24, 0.15, 0.08, 0.22), Color(0.58, 0.40, 0.20, 0.45), 14, 2))
	vbox.add_child(tray)

	var tray_mc := MarginContainer.new()
	tray_mc.add_theme_constant_override("margin_left", 10)
	tray_mc.add_theme_constant_override("margin_right", 10)
	tray_mc.add_theme_constant_override("margin_top", 10)
	tray_mc.add_theme_constant_override("margin_bottom", 10)
	tray.add_child(tray_mc)

	_scroll = ScrollContainer.new()
	_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	tray_mc.add_child(_scroll)

	var center_wrap := CenterContainer.new()
	center_wrap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	center_wrap.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_scroll.add_child(center_wrap)

	_grid = GridContainer.new()
	_grid.columns = 4
	_grid.add_theme_constant_override("h_separation", 12)
	_grid.add_theme_constant_override("v_separation", 12)
	center_wrap.add_child(_grid)

	# Prominent Centered COLLECT Button
	var btn_row := HBoxContainer.new()
	btn_row.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_child(btn_row)

	_collect_btn = Button.new()
	_collect_btn.custom_minimum_size = Vector2(236, 62)
	_collect_btn.add_theme_font_size_override("font_size", 22)
	_collect_btn.add_theme_color_override("font_color", Color(1.0, 0.98, 0.90))
	_collect_btn.add_theme_color_override("font_outline_color", Color(0.32, 0.14, 0.02))
	_collect_btn.add_theme_constant_override("outline_size", 5)

	var gold_tex: Texture2D = load("res://assets/sprites/ui/ui_btn_gold.png")
	var btn_norm := StyleBoxTexture.new()
	btn_norm.texture = gold_tex
	btn_norm.texture_margin_left = 48
	btn_norm.texture_margin_right = 48
	btn_norm.texture_margin_top = 30
	btn_norm.texture_margin_bottom = 30
	var btn_hover := btn_norm.duplicate()
	btn_hover.modulate_color = Color(1.08, 1.05, 1.0)
	var btn_press := btn_norm.duplicate()
	btn_press.modulate_color = Color(0.86, 0.82, 0.78)
	_collect_btn.add_theme_stylebox_override("normal", btn_norm)
	_collect_btn.add_theme_stylebox_override("hover", btn_hover)
	_collect_btn.add_theme_stylebox_override("pressed", btn_press)
	_collect_btn.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	UiFx.attach_press_bounce(_collect_btn)
	_collect_btn.pressed.connect(_on_collect_pressed)
	btn_row.add_child(_collect_btn)

	# Populate real accumulated rewards
	populate_entries(_build_reward_entries(pending))

	# Subtle open animation
	var open_tw := create_tween()
	open_tw.set_parallel(true)
	open_tw.tween_property(_card_root, "scale", Vector2.ONE, 0.22).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	open_tw.tween_property(_card_root, "modulate:a", 1.0, 0.18).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


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


func _build_reward_entries(pending: Dictionary) -> Array:
	var entries: Array = []
	var gold_amt: int = int(pending.get("gold", 0))
	var exp_amt: int = int(pending.get("exp", 0))
	var gem_amt: int = int(pending.get("gems", 0))

	if gold_amt > 0:
		entries.append({
			"key": "gold",
			"name": "Gold",
			"icon": "res://assets/sprites/items/item_gold_coin.png",
			"amount": gold_amt,
			"rarity": "SSR",
		})
	if exp_amt > 0:
		entries.append({
			"key": "exp",
			"name": "EXP",
			"icon": "res://assets/sprites/items/res_mana_crystals.png",
			"amount": exp_amt,
			"rarity": "R",
		})
	if gem_amt > 0:
		entries.append({
			"key": "gems",
			"name": "Gems",
			"icon": "res://assets/sprites/items/item_purple_gem.png",
			"amount": gem_amt,
			"rarity": "SR",
		})
	return entries


func populate_entries(entries: Array) -> void:
	_pending_entries = entries.duplicate(true)
	_slot_labels.clear()
	for c in _grid.get_children():
		c.queue_free()

	_is_empty = entries.is_empty()
	if _is_empty:
		_grid.columns = 1
		var empty_lbl := Label.new()
		empty_lbl.text = "Đang tích lũy tài nguyên...\nHãy quay lại sau ít phút!"
		empty_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		empty_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		empty_lbl.add_theme_font_size_override("font_size", 16)
		empty_lbl.add_theme_color_override("font_color", Color(0.30, 0.18, 0.09))
		_grid.add_child(empty_lbl)
		if is_instance_valid(_collect_btn):
			_collect_btn.text = "CLOSE"
		return

	_grid.columns = mini(4, entries.size())
	if is_instance_valid(_collect_btn):
		_collect_btn.text = "COLLECT"

	for i in entries.size():
		var item: Dictionary = entries[i]
		var slot := _create_reward_slot(item)
		_grid.add_child(slot)

		slot.modulate.a = 0.0
		slot.scale = Vector2(0.78, 0.78)
		var stw := slot.create_tween()
		stw.tween_interval(float(i) * 0.04)
		stw.set_parallel(true)
		stw.tween_property(slot, "scale", Vector2.ONE, 0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		stw.tween_property(slot, "modulate:a", 1.0, 0.15)


func _create_reward_slot(item: Dictionary) -> Control:
	var rar: String = String(item.get("rarity", "R"))
	var rar_col: Color = GameData.RARITIES.get(rar, GameData.RARITIES["R"])["color"]

	var slot := Panel.new()
	slot.custom_minimum_size = Vector2(96, 96)
	slot.pivot_offset = Vector2(48, 48)
	slot.tooltip_text = String(item.get("name", ""))

	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.13, 0.10, 0.18, 0.92)
	sb.border_color = rar_col
	sb.set_border_width_all(3)
	sb.set_corner_radius_all(12)
	sb.shadow_color = Color(0.16, 0.08, 0.03, 0.42)
	sb.shadow_size = 5
	sb.shadow_offset = Vector2(0, 3)
	slot.add_theme_stylebox_override("panel", sb)

	var inner_glow := Panel.new()
	inner_glow.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	inner_glow.offset_left = 3
	inner_glow.offset_right = -3
	inner_glow.offset_top = 3
	inner_glow.offset_bottom = -3
	inner_glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	inner_glow.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(rar_col.r, rar_col.g, rar_col.b, 0.12), Color(1, 1, 1, 0.14), 9, 1))
	slot.add_child(inner_glow)

	var ic := TextureRect.new()
	ic.texture = load(String(item.get("icon", "res://assets/sprites/items/item_gold_coin.png")))
	ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	ic.position = Vector2(16, 10)
	ic.size = Vector2(64, 64)
	ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
	slot.add_child(ic)

	var qty := Label.new()
	var amt: int = int(item.get("amount", 0))
	qty.text = _fmt_num(amt)
	qty.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	qty.offset_left = 4
	qty.offset_right = -6
	qty.offset_top = -24
	qty.offset_bottom = -3
	qty.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	qty.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	qty.add_theme_font_size_override("font_size", 15)
	qty.add_theme_color_override("font_color", Color(1.0, 0.98, 0.92))
	qty.add_theme_color_override("font_outline_color", Color(0.05, 0.03, 0.08))
	qty.add_theme_constant_override("outline_size", 4)
	qty.mouse_filter = Control.MOUSE_FILTER_IGNORE
	slot.add_child(qty)

	var key: String = String(item.get("key", ""))
	if key != "":
		_slot_labels[key] = qty
	return slot


func _on_collect_pressed() -> void:
	if _is_empty or _claimed:
		queue_free()
		return
	_claimed = true

	var rew: Dictionary = PlayerState.claim_idle_rewards()
	AudioManager.play_sfx("chest_open")

	var center_pt: Vector2 = size * 0.5
	var target_top: Vector2 = Vector2(size.x - 160.0, 42.0)
	if int(rew.get("gold", 0)) > 0:
		UiFx.spawn_flying_coins(self, center_pt, target_top - Vector2(180, 0), "res://assets/sprites/items/item_gold_coin.png", 8)
	if int(rew.get("exp", 0)) > 0:
		UiFx.spawn_flying_coins(self, center_pt, target_top - Vector2(90, 0), "res://assets/sprites/items/res_mana_crystals.png", 6)
	if int(rew.get("gems", 0)) > 0:
		UiFx.spawn_flying_coins(self, center_pt, target_top, "res://assets/sprites/items/item_purple_gem.png", 6)

	for key in ["gold", "exp", "gems"]:
		if _slot_labels.has(key) and is_instance_valid(_slot_labels[key]):
			var lbl: Label = _slot_labels[key]
			var start_val: int = int(rew.get(key, 0))
			var r_tw := lbl.create_tween()
			r_tw.tween_method(func(v: float) -> void:
				if is_instance_valid(lbl):
					lbl.text = _fmt_num(int(round(v)))
			, float(start_val), 0.0, 0.42).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	_time_lbl.text = "Đã nhận toàn bộ tài nguyên!"
	_collect_btn.text = "COLLECTED!"
	var close_t := create_tween()
	close_t.tween_interval(0.85)
	close_t.tween_callback(queue_free)
