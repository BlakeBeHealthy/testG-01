@tool
extends Node2D

@onready var cam: Camera2D = $".."

func _draw() -> void:
	if !Engine.is_editor_hint() or !cam:
		return
	var rect = Rect2(
		Vector2(cam.limit_left, cam.limit_top) - global_position,
		Vector2(cam.limit_right - cam.limit_left, cam.limit_bottom - cam.limit_top)
	)
	draw_rect(rect, Color(0.4, 1.0, 0.6), false, 4.0)

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		queue_redraw()
