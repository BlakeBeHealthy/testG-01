extends TEnemyState
@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"


func enter() -> void:
	as2d.play("idle")
	pass

func exit() -> void:
	pass

func process_input(event: InputEvent) -> TEnemyState:
	return null

func process_frame(delta: float) -> TEnemyState:
	if parent.patrol:
		return parent.patrol_state
	if parent.attack:
		return parent.attack_state
	return null

func process_physics(delta: float) -> TEnemyState:
	return null
