class_name States
extends Node

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")


func enter() -> void:
	pass

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	return null
