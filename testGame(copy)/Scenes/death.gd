extends State
@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var t3: Timer = $"../../InvincibleTime"
@onready var t1: Timer = $"../../Timer"
@onready var t2: Timer = $"../../tim2"


func enter() -> void:
	as2d.play("death")
	t1.stop()
	t2.stop()
	t3.stop()
func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	return null
