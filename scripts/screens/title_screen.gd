extends Control

var _app: Control
var _banner: PanelContainer
var _start_btn: Button


func setup_screen(app: Control, _params: Dictionary = {}) -> void:
	_app = app


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var bg := TextureRect.new()
	bg.texture = load("res://assets/sprites/backgrounds/bg_title_splash.png")
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	# Ambient sakura petals at 60 FPS
	var petals := UiFx.create_ambient_particles("plains", 720.0)
	add_child(petals)

	# Title Crest Banner
	var banner := PanelContainer.new()
	_banner = banner
	banner.position = Vector2(50, 74)
	banner.size = Vector2(620, 170)
	banner.add_theme_stylebox_override("panel", UiFx.make_panel_style(Color(0.10, 0.08, 0.18, 0.82), Color(1.0, 0.82, 0.34, 0.95), 24, 3))
	add_child(banner)

	var bv := VBoxContainer.new()
	bv.alignment = BoxContainer.ALIGNMENT_CENTER
	bv.add_theme_constant_override("separation", 6)
	banner.add_child(bv)

	var title := Label.new()
	title.text = "TINY LEGENDS"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 46)
	title.add_theme_color_override("font_color", Color(1.0, 0.90, 0.42))
	title.add_theme_color_override("font_outline_color", Color(0.18, 0.08, 0.04))
	title.add_theme_constant_override("outline_size", 8)
	bv.add_child(title)

	var sub := Label.new()
	sub.text = "E V O L U T I O N"
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sub.add_theme_font_size_override("font_size", 24)
	sub.add_theme_color_override("font_color", Color(0.86, 0.95, 1.0))
	sub.add_theme_color_override("font_outline_color", Color(0.08, 0.06, 0.16))
	sub.add_theme_constant_override("outline_size", 5)
	bv.add_child(sub)

	var tag := Label.new()
	tag.text = "5v5 Full Auto RPG  •  Evolution Changes Combat AI"
	tag.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tag.add_theme_font_size_override("font_size", 15)
	tag.add_theme_color_override("font_color", Color(0.95, 0.84, 0.92))
	bv.add_child(tag)

	# Tap to Start button
	var start_btn := UiFx.make_styled_button("TAP TO START", Color(0.84, 0.46, 0.14), Vector2(360, 82), 28)
	_start_btn = start_btn
	start_btn.position = Vector2(180, 1080)
	start_btn.pressed.connect(func() -> void:
		if _app != null:
			_app.navigate_to("lobby")
	)
	add_child(start_btn)
	resized.connect(_layout)
	_layout()

	# Gentle pulse animation on Tap to Start
	start_btn.pivot_offset = start_btn.size * 0.5
	var pt := create_tween().set_loops()
	pt.tween_property(start_btn, "scale", Vector2(1.05, 1.05), 0.75).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	pt.tween_property(start_btn, "scale", Vector2(0.98, 0.98), 0.75).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func _layout() -> void:
	_banner.position.x = (size.x - _banner.size.x) * 0.5
	_start_btn.position = Vector2((size.x - _start_btn.size.x) * 0.5,
		size.y - (132.0 if UiFx.is_wide(size) else 200.0))
