extends State
class_name Jump

#Basic jump class
@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var a2d2: Area2D = $"../../Area2D2"
@onready var attack_delay: Timer = $"../../attackDelay"
@onready var a2d: Area2D = $"../../Area2D"

@export var JUMP := 0
@export var jumpCut := 0.0
@export var fall_state: State
@export var run_state: State
@export var idle_state: State
@export var attack_state: State
@export var hit_state: State

var hit := false

func enter() -> void:
	parent.jumpCheck = true
	print(parent.jumpCheck, " jump")
	as2d.play("jump")
	parent.velocity.y = -JUMP
	if !Input.is_action_pressed("jump"):
		parent.velocity.y *= jumpCut
	#You will probably see some stuff like this, its just basic hitbox adustments based on as2d
	a2d2.position.y = -1
		
func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	#This is declared in player but IDK if i remove this if it will break
	#You can test if feel up to it, this might be useless as well as other calls for this
	#state change bc of player

	return null

func process_frame(delta: float) -> State:
	if parent.takeHit:
		return hit_state
	return null
	
func process_physics(delta: float) -> State:
	if Input.is_action_just_released("jump"):
		parent.velocity.y *= jumpCut
	
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
	if parent.is_on_floor():
		if direction != 0:
			return run_state
		elif direction == 0:
			return idle_state
	if !parent.is_on_floor() and parent.velocity.y > 0:
		return fall_state
	
	return null
