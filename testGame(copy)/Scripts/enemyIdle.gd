extends EnemyState

@onready var t3: Timer = $"../../Timer"
@onready var state_mac: Node = $".."
@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@export var death_state: EnemyState
@export var patrol_state: EnemyState

var dead := false
var patrol := false 

func enter() -> void:
	as2d.play("idle")
	parent.velocity.x = 0
	patrol = true

func exit() -> void:
	patrol = false
	
func _on_killzone_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	dead = true
	
func process_input(event: InputEvent) -> EnemyState:
	return null
	
func _on_timer_timeout() -> void:
	t3.stop()
	patrol = true
	
func process_frame(delta: float) -> EnemyState:
	if healthCount == 0:
		return death_state
		
	if patrol:
		return patrol_state
	return null

func process_physics(delta: float) -> EnemyState:
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	if dead:
		dead = false
		return death_state
	return null
