extends Node2D

var _source: Vector2
var _destination: Vector2
var _head: Vector2
var _tangent := Vector2.RIGHT
var _target: Node2D
var _target_offset: Vector2
var _color: Color
var _kind: String
var _heavy: bool
var _arc: float
var _trail: Line2D


func launch(origin: Vector2, target: Node2D, target_offset: Vector2, tint: Color,
		kind: String, heavy: bool, arrived: Callable) -> void:
	top_level = true
	global_position = Vector2.ZERO
	z_index = 24
	_source = origin
	_target = target
	_target_offset = target_offset
	_destination = target.to_global(target_offset)
	_color = tint
	_kind = kind
	_heavy = heavy
	_arc = 6.0 if kind == "round" else (25.0 if kind == "arrow" else 18.0)

	_trail = Line2D.new()
	_trail.antialiased = true
	_trail.width = 13.0 if heavy else 8.0
	var decay := Gradient.new()
	decay.colors = PackedColorArray([Color(tint, 0.0), Color(tint, 0.82)])
	_trail.gradient = decay
	_trail.end_cap_mode = Line2D.LINE_CAP_ROUND
	add_child(_trail)
	_update_flight(0.0)
	var speed := 1770.0 if kind == "round" else 1240.0
	var duration := clampf(_source.distance_to(_destination) / speed, 0.12, 0.43)
	var flight := create_tween()
	flight.tween_method(_update_flight, 0.0, 1.0, duration)
	flight.tween_callback(arrived)
	flight.tween_property(self, "modulate:a", 0.0, 0.095)
	flight.tween_callback(queue_free)


func _at(progress: float) -> Vector2:
	return _source.lerp(_destination, progress) + Vector2(0.0, -sin(progress * PI) * _arc)


func _update_flight(progress: float) -> void:
	if is_instance_valid(_target):
		_destination = _target.to_global(_target_offset)
	_head = _at(progress)
	var direction := _at(progress + 0.008) - _at(progress - 0.008)
	_tangent = direction.normalized() if direction.length_squared() > 0.0001 else Vector2.RIGHT
	var points := PackedVector2Array()
	var tail := maxf(0.0, progress - (0.34 if _heavy else 0.24))
	for i in range(8):
		points.append(_at(lerpf(tail, progress, i / 7.0)))
	_trail.points = points
	queue_redraw()


func _draw() -> void:
	var width := 1.4 if _heavy else 1.0
	var side := _tangent.orthogonal() * width
	if _kind == "arrow":
		draw_line(_head - _tangent * 25.0, _head, _color.lightened(0.48), 3.0 * width, true)
		draw_colored_polygon(PackedVector2Array([_head + _tangent * 4.0,
			_head - _tangent * 7.0 + side * 4.0, _head - _tangent * 7.0 - side * 4.0]), Color.WHITE)
	elif _kind == "round":
		draw_line(_head - _tangent * 22.0, _head, _color.lightened(0.55), 4.0 * width, true)
		draw_circle(_head, 2.5 * width, Color.WHITE, true, -1.0, true)
	else:
		draw_circle(_head, 9.0 * width, Color(_color, 0.38), true, -1.0, true)
		draw_circle(_head, 5.0 * width, _color.lightened(0.4), true, -1.0, true)
		draw_circle(_head, 2.25 * width, Color.WHITE, true, -1.0, true)
