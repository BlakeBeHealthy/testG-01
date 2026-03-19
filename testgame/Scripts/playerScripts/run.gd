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
var c = 0 

func enter() -> void:
	a2d2.position.x = 5
	a2d2.position.y = 9
	as2d.play("run")
	hitboxOffX = abs(a2d.position.x)
	hitboxOffX2 = abs(a2d2.position.x)

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
	if parent.attackCheck:
		parent.attackCheck = false
		if !parent.ComboTime.is_stopped():
			parent.ComboTime.stop()
			return parent.att2_state
		else:
			parent.ComboTime.start()
			return parent.attack_state
	return null
	
func process_physics(delta: float) -> State:
	var direction = Input.get_axis("runL", "runR")
	
	if direction > 0:
		facingR = true
		as2d.flip_h = false
		a2d.position.x = hitboxOffX
		a2d2.position.x = hitboxOffX2
		direction = 1
	elif direction < 0:
		facingR = false
		as2d.flip_h = true
		a2d.position.x = -hitboxOffX
		a2d2.position.x = -hitboxOffX2
		direction = -1
		
	parent.velocity.x = direction * move_speed
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	
	if !parent.is_on_floor() and parent.velocity.y > 0:
		return parent.fall_state
	if direction == 0:
		return parent.idle_state
	
	return null
