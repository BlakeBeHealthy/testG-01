extends State
class_name Fall

@onready var c: CollisionShape2D = $"../../c"
@onready var attack_delay: Timer = $"../../attackDelay"
@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var a2d2: Area2D = $"../../Area2D2"
@onready var a2d: Area2D = $"../../Area2D"
@onready var cTime: Timer = $"../../CoyoteTime"

#Sometimes exported variables are written in this fashion, if its easier for you
	#I dont mind if you adjust the code in the states, Im good either way

var hit:= false

func enter() -> void:
	if !parent.jumpCheck or parent.wall_state != parent.WallState.NONE:
		cTime.start()
	as2d.play("fall")
	parent.c_check_1.enabled = true
	parent.c_check_2.enabled = true
	
func exit() -> void:
	parent.c_check_1.enabled = false
	parent.c_check_2.enabled = false
	
func process_input(event: InputEvent) -> State:
	return null #Every path must have a return statement, dont forget or the engine
					#will yell at you

func process_frame(delta: float) -> State:
	if parent.takeHit:
		return parent.hit_state
		
	if parent.parryCheck:
		return parent.parry_state
	
	if parent.dash:
		return parent.dash_state
		
	if parent.wall_state == parent.WallState.SLIDING and cTime.is_stopped():
		return parent.wallSlide_state
		
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
			
	if parent.pogoCheck:
		return parent.pogo_state
		
	return null
	
func process_physics(delta: float) -> State:
	if parent.velocity.y < 380:
		parent.velocity.y += gravity * 1.5 * delta
	else:
		parent.velocity.y = parent.velocity.y
	
	var direction = Input.get_axis("runL", "runR")
	parent.apply_horizontal_air_control(move_speed)
	parent.move_and_slide()
	if Input.is_action_just_pressed("jump"):
		if !cTime.is_stopped():
			cTime.stop()
			return parent.jump_state
		elif parent.moveCheck:
			parent.jumpCheck = false
			parent.moveCheck = false
			return parent.jump_state
	if parent.is_on_floor():
		if direction != 0:
			return parent.run_state
		elif direction == 0:
			return parent.idle_state
	return null


func _on_coyote_time_timeout() -> void:
	parent.wall_state = parent.WallState.NONE
