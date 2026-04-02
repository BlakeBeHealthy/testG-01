extends Node
class_name TEnemyState

@export var move_speed: float = -75
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var parent: TEnemy
var healthCount = 2

func enter() -> void:
	pass

func exit() -> void:
	pass

func process_input(event: InputEvent) -> TEnemyState:
	return null

func process_frame(delta: float) -> TEnemyState:
	return null

func process_physics(delta: float) -> TEnemyState:
	return null
