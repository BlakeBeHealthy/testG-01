extends State
class_name Fall

@onready var attack_delay: Timer = $"../../attackDelay"
@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

@export
var fall_state: State
@export
var run_state: State
@export
var idle_state: State
@export
var attack_state: State
@export 
var hit_state: State

var hit:= false

func enter() -> void:
	as2d.play("fall")
	
func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	if hit:
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
	elif direction < 0:
		as2d.flip_h = true
	
	if direction != 0 and parent.is_on_floor():
		return run_state
	elif direction == 0 and parent.is_on_floor():
		return idle_state
	
	return null
	
	
func _on_area_2d_2_area_entered(area: Area2D) -> void:
	pass
