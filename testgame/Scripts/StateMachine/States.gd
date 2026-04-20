class_name States
extends Node

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")


func enter() -> void:
	pass

func exit() -> void:
	pass

func process_input(event: InputEvent) -> States:
	return null

func process_frame(delta: float) -> States:
	return null

func process_physics(delta: float) -> States:
	return null
