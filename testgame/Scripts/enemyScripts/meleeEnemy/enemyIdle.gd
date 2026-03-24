extends EnemyState

@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

var dead := false
var patrol := false 

func enter() -> void:
	as2d.play("idle")
	parent.velocity.x = 0
	patrol = true

func exit() -> void:
	patrol = false
	
func process_input(event: InputEvent) -> EnemyState:
	return null
	
func _on_timer_timeout() -> void:
	patrol = true
	
func process_frame(delta: float) -> EnemyState:
	if healthCount == 0:
		return parent.death_state
		
	if parent.hit:
		return parent.hit_state
			
	if patrol:
		return parent.patrol_state
	return null

func process_physics(delta: float) -> EnemyState:
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	return null
