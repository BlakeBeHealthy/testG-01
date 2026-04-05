extends State
@export var dashSpeed: float
@export var decayRate: float
@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var dash_delay: Timer = $"../../DashDelay"

var dashCheck := false
var dashDir := 0.0
# Called when the node enters the scene tree for the first time.
func enter() -> void:
	dash_delay.start()
	as2d.play("dash")
	dashDir = Input.get_axis("runL", "runR")
	if dashDir > 0:
		as2d.flip_h = false
	elif dashDir < 0:
		as2d.flip_h = true
	pass

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	var dir = Input.get_axis("runL", "runR")

	if !as2d.is_playing():
		if parent.parryCheck:
			return parent.parry_state 
		elif parent.attackCheck:
			return parent.attack_state
		elif parent.pogoCheck:
			return parent.pogo_state
		elif !parent.is_on_floor() and parent.velocity.y > 0:
			return parent.fall_state
		elif Input.is_action_just_pressed('jump') and parent.is_on_floor():
			return parent.jump_state
		elif Input.is_action_pressed('runL') or Input.is_action_pressed('runR'):
			return parent.run_state
		else:
			return parent.idle_state
	return null

func process_physics(delta: float) -> State:
	if dashCheck:
		dashCheck = false
		parent.velocity.x += dashDir * dashSpeed
	else:
		parent.velocity.x = move_toward(parent.velocity.x, move_speed, decayRate * delta)
	return null
