extends State
class_name Fall

@onready var attack_delay: Timer = $"../../attackDelay"
@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var a2d2: Area2D = $"../../Area2D2"
@onready var a2d: Area2D = $"../../Area2D"
@onready var cTime: Timer = $"../../CoyoteTime"

#Sometimes exported variables are written in this fashion, if its easier for you
	#I dont mind if you adjust the code in the states, Im good either way
@export
var fall_state: State
@export
var run_state: State
@export 
var jump_state: State
@export
var idle_state: State
@export
var attack_state: State
@export 
var hit_state: State

var hit:= false

func enter() -> void:
	print(parent.jumpCheck, " fall")
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
		return hit_state
	return null
	
	if Input.is_action_just_pressed("leftC") and attack_delay.is_stopped():
		return attack_state
	return null
func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	var direction = Input.get_axis("runL", "runR")
	parent.velocity.x = direction * move_speed
	parent.move_and_slide()
	
	if direction > 0:
		as2d.flip_h = false
		a2d2.position.x = 3
		a2d.position.x = 21
	elif direction < 0:
		a2d.position.x = -21
		as2d.flip_h = true
		a2d2.position.x = -3
	
	if !cTime.is_stopped() and Input.is_action_pressed("jump"):
		cTime.stop()
		return jump_state
	if direction != 0 and parent.is_on_floor():
		return run_state
	elif direction == 0 and parent.is_on_floor():
		return idle_state
	
	return null
	
	
func _on_area_2d_2_area_entered(area: Area2D) -> void:
	pass
