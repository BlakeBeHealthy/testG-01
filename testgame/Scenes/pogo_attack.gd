extends State
@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var a2d: Area2D = $"../../Area2D"

func enter() -> void:
	as2d.play("pogo")
	a2d.position.x = 0
	a2d.position.y = 4.0
	a2d.scale.x = 1.3
	a2d.scale.y = -0.5
	pass

func exit() -> void:
	a2d.position.x = parent.direction * 18
	a2d.position.y = 4.0
	a2d.scale.x = 1.4
	a2d.scale.y = 1.0
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	return null
