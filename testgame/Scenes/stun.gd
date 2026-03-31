extends EnemyState

@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"



func enter() -> void:
	as2d.play("stun")
	

func exit() -> void:
	pass

func process_input(event: InputEvent) -> EnemyState:
	return null

func process_frame(delta: float) -> EnemyState:
	return null

func process_physics(delta: float) -> EnemyState:
	return null
