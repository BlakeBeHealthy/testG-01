extends Node
class_name EnemyState

@export var move_speed: float = -75
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var parent: Enemy
var healthCount = 3

func enter() -> void:
	pass

func exit() -> void:
	pass

func process_input(event: InputEvent) -> EnemyState:
	return null

func process_frame(delta: float) -> EnemyState:
	return null

func process_physics(delta: float) -> EnemyState:
	return null
