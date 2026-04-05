extends State

@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var dash_delay: Timer = $"../../DashDelay"

# Called when the node enters the scene tree for the first time.
func enter() -> void:
	dash_delay.start
	pass

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	return null
