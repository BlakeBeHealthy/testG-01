extends State
class_name Run

@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var a2d: Area2D = $"../../Area2D"
@onready var a2d2: Area2D = $"../../Area2D2"
@onready var attack_delay: Timer = $"../../attackDelay"

@export var fall_state: State
@export var jump_state: State
@export var idle_state: State
@export var attack_state: State
@export var hit_state: State

var hitboxOffX: float
var hitboxOffX2: float
var facingR := true
var hit := false

func enter() -> void:
	a2d2.position.x = 5
	a2d2.position.y = 9
	as2d.play("run")
	hitboxOffX = abs(a2d.position.x)
	hitboxOffX2 = abs(a2d2.position.x)

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('jump') and parent.is_on_floor():
		return jump_state
	if Input.is_action_just_pressed("leftC") and attack_delay.is_stopped():
		return attack_state
	return null

func process_frame(delta: float) -> State:
	if hit:
		return hit_state
	return null
	
func process_physics(delta: float) -> State:
	var direction = 0
	
	if Input.is_action_pressed("runR"):
		facingR = true
		as2d.flip_h = false
		a2d.position.x = hitboxOffX
		a2d2.position.x = hitboxOffX2
		direction = 1
	elif Input.is_action_pressed("runL"):
		facingR = false
		as2d.flip_h = true
		a2d.position.x = -hitboxOffX
		a2d2.position.x = -hitboxOffX2
		direction = -1
		
	parent.velocity.x = direction * move_speed
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	
	if !parent.is_on_floor() and parent.velocity.y > 0:
		return fall_state
	if direction == 0:
		return idle_state
	
	return null


func _on_area_2d_2_area_entered(area: Area2D) -> void:
	pass
