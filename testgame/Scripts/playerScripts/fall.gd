extends State
class_name Fall

@onready var attack_delay: Timer = $"../../attackDelay"
@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var a2d2: Area2D = $"../../Area2D2"
@onready var a2d: Area2D = $"../../Area2D"
@onready var cTime: Timer = $"../../CoyoteTime"

#Sometimes exported variables are written in this fashion, if its easier for you
	#I dont mind if you adjust the code in the states, Im good either way

var hit:= false

func enter() -> void:
	if !parent.jumpCheck:
		cTime.start()
	as2d.play("fall")
	
func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null #Every path must have a return statement, dont forget or the engine
					#will yell at you

func process_frame(delta: float) -> State:
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
	if Input.is_action_pressed("jump"):
		parent.velocity.y += gravity * delta * 0.9
	elif parent.velocity.y < 405:
		parent.velocity.y += gravity * 1.7 * delta
	else:
		parent.velocity.y = parent.velocity.y
	
	var direction = Input.get_axis("runL", "runR")
	parent.velocity.x = direction * move_speed
	parent.move_and_slide()
	
	if direction > 0:
		parent.flip_direction(1)
		a2d2.position.x = 3
		a2d.position.x = 21
	elif direction < 0:
		parent.flip_direction(-1)
		a2d.position.x = -21
		a2d2.position.x = -3
	
	if !cTime.is_stopped() and Input.is_action_pressed("jump"):
		cTime.stop()
		return parent.jump_state
	if direction != 0 and parent.is_on_floor():
		return parent.run_state
	elif direction == 0 and parent.is_on_floor():
		return parent.idle_state
	
	return null
	
	
func _on_area_2d_2_area_entered(area: Area2D) -> void:
	pass
