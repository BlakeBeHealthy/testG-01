extends REnemyState

@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

@export var death_state: REnemyState
@export var patrol_state: REnemyState

var dead := false
var patrol := false 
func enter() -> void:
	as2d.play("walk")
	parent.velocity.x = 0
	patrol = true

func exit() -> void:
	patrol = false
	
func process_input(event: InputEvent) -> REnemyState:
	return null
	
func _on_timer_timeout() -> void:
	patrol = true
	
func process_frame(delta: float) -> REnemyState:
	if healthCount == 0:
		return death_state
		
	if patrol:
		return patrol_state
	return null

func process_physics(delta: float) -> REnemyState:
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	return null
