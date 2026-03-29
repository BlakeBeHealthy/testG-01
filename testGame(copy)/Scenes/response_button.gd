extends Button


# Called when the node enters the scene tree for the first time.
func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("dialogueSkip"):
		get_viewport().set_input_as_handled()
