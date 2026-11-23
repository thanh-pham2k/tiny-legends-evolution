extends Control

const SCREENS := {
	"title": preload("res://scripts/screens/title_screen.gd"),
	"lobby": preload("res://scripts/screens/lobby_screen.gd"),
	"heroes": preload("res://scripts/screens/heroes_screen.gd"),
	"summon": preload("res://scripts/screens/summon_screen.gd"),
	"campaign": preload("res://scripts/screens/campaign_screen.gd"),
	"battle": preload("res://scripts/screens/battle_screen.gd"),
}

const POPUP_IDLE := preload("res://scripts/screens/idle_rewards_popup.gd")

var _screen_host: Control
var _popup_host: Control
var _fade_overlay: ColorRect
var _current_screen: Control
var _current_name: String = ""
var _transitioning: bool = false


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	_screen_host = Control.new()
	_screen_host.name = "ScreenHost"
	add_child(_screen_host)

	_popup_host = Control.new()
	_popup_host.name = "PopupHost"
	_popup_host.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_popup_host)

	_fade_overlay = ColorRect.new()
	_fade_overlay.name = "FadeOverlay"
	_fade_overlay.color = Color(0.04, 0.04, 0.08, 0.0)
	_fade_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_fade_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_fade_overlay)
	resized.connect(_layout_hosts)
	_layout_hosts()

	navigate_to("title", {}, true)


func _layout_hosts() -> void:
	for host in [_screen_host, _popup_host]:
		if UiFx.is_wide(size):
			host.position = Vector2.ZERO
			host.scale = Vector2.ONE
			host.size = size
		else:
			UiFx.fit_control(host, Vector2(720, 1280), Rect2(Vector2.ZERO, size))


func navigate_to(screen_name: String, params: Dictionary = {}, instant: bool = false) -> void:
	if _transitioning or not SCREENS.has(screen_name):
		return
	Engine.time_scale = 1.0
	if instant or _current_screen == null:
		_swap_screen(screen_name, params)
		return

	_transitioning = true
	_fade_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	var t := create_tween()
	t.tween_property(_fade_overlay, "color:a", 1.0, 0.14)
	t.tween_callback(func() -> void:
		_swap_screen(screen_name, params)
	)
	t.tween_property(_fade_overlay, "color:a", 0.0, 0.18)
	t.tween_callback(func() -> void:
		_fade_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_transitioning = false
	)


func _swap_screen(screen_name: String, params: Dictionary) -> void:
	if _current_screen != null and is_instance_valid(_current_screen):
		_current_screen.queue_free()
	var scr: Control = SCREENS[screen_name].new()
	scr.name = screen_name.capitalize() + "Screen"
	scr.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	if scr.has_method("setup_screen"):
		scr.setup_screen(self, params)
	_screen_host.add_child(scr)
	_current_screen = scr
	_current_name = screen_name


func open_idle_rewards() -> void:
	for c in _popup_host.get_children():
		c.queue_free()
	var pop: Control = POPUP_IDLE.new()
	pop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	pop.setup_popup(self)
	_popup_host.add_child(pop)
