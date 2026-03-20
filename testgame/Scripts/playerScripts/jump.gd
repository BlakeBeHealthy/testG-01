extends State
class_name Jump

#Basic jump class
@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var a2d2: Area2D = $"../../Area2D2"
@onready var attack_delay: Timer = $"../../attackDelay"
@onready var a2d: Area2D = $"../../Area2D"

var hit := false

func enter() -> void:
	as2d.play("jump")
	if !parent.jumpCheck:
		parent.velocity.y = -parent.JUMP
		parent.jumpCheck = true
	#You will probably see some stuff like this, its just basic hitbox adustments based on as2d
	if parent.direction == -1:
		a2d2.position.y = 0
		a2d2.position.x = -4
	elif parent.direction == 1:
		a2d2.position.x = 4
		a2d2.position.y = 0
		
func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null
	
func process_frame(delta: float) -> State:
	if parent.control_locked:
		await parent.is_on_floor()
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
	if Input.is_action_just_released("jump"):
		parent.velocity.y *= parent.jumpCut
	
	parent.velocity.y += gravity * delta
	
	var direction = Input.get_axis("runL", "runR")
	parent.velocity.x = direction * move_speed
	parent.move_and_slide()
	
	if direction > 0:
		parent.flip_direction(1)
		a2d2.position.x = 3
		a2d.position.x = 21
	elif direction < 0:
		parent.flip_direction(-1)
		parent.a2d.position.x = -21
		parent.a2d2.position.x = -3
	if parent.is_on_floor():
		if direction != 0:
			return parent.run_state
		elif direction == 0:
			return parent.idle_state
	if !parent.is_on_floor() and parent.velocity.y > 0:
		return parent.fall_state
	
	return null
