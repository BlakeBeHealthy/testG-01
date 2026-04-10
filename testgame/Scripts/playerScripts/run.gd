extends State
class_name Run

@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var a2d: Area2D = $"../../Area2D"
@onready var a2d2: Area2D = $"../../Area2D2"
@onready var attack_delay: Timer = $"../../attackDelay"
@onready var cTime: Timer = $"../../CoyoteTime"


var hitboxOffX: float
var hitboxOffX2: float
var facingR := true
var hit := false

func enter() -> void:
	as2d.play("run")
	a2d2.position.y = 9

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('jump') and parent.is_on_floor():
		return parent.jump_state
	return null

func process_frame(delta: float) -> State:
	if parent.control_locked:
		parent.control_locked = false
		return parent.cut_state
	if parent.takeHit:
		return parent.hit_state
	if parent.parryCheck:
		return parent.parry_state
	if parent.attackCheck:
		parent.attackCheck = false
		if parent.parried:
			parent.parried = false
			return parent.parryAttack_state
		elif !parent.ComboTime.is_stopped():
			parent.ComboTime.stop()
			return parent.att2_state
		else:
			parent.ComboTime.start()
			return parent.attack_state
	return null
	
func process_physics(delta: float) -> State:
	var direction = Input.get_axis("runL", "runR")
	
	if direction > 0:
		parent.flip_direction(1)
		parent.wallslide_chest.target_position.x = abs(parent.wallslide_chest.target_position.x) * direction
		parent.wallslide_chest.position.x = 3.2
		parent.wallslide_legs.target_position.x = abs(parent.wallslide_legs.target_position.x) * direction
		parent.wallslide_legs.position.x = 3.2
		a2d2.position.x = 5 * direction
		a2d.position.x = 18
		facingR = true
	elif direction < 0:
		parent.flip_direction(-1)
		parent.wallslide_chest.target_position.x = abs(parent.wallslide_chest.target_position.x) * direction
		parent.wallslide_chest.position.x = -3.2
		parent.wallslide_legs.target_position.x = abs(parent.wallslide_legs.target_position.x) * direction
		parent.wallslide_legs.position.x = -3.2
		a2d2.position.x = 5 * direction
		a2d.position.x = -18
		facingR = false
		
	parent.velocity.x = parent.direction * move_speed
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	if parent.dash:
		return parent.dash_state
	if !parent.is_on_floor() and parent.velocity.y > 0:
		return parent.fall_state
	if direction == 0:
		return parent.idle_state
	
	return null
