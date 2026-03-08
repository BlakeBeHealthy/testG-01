extends State
@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var T3: Timer = $"../../Timer"
@onready var a2d: Area2D = $"../../Area2D"
@onready var a2d2: Area2D = $"../../Area2D2"

@export
var fall_state: State
@export
var run_state: State
@export
var idle_state: State
@export 
var hit_state: State
@export
var jump_state: State

var checkHit := true
var hit := false

func enter() -> void:
	if parent.is_on_floor():
		parent.velocity.x = 0
	if checkHit:
		checkHit = false
		as2d.play("attack")
			
func _on_animated_sprite_2d_frame_changed() -> void:
	if as2d.animation != "attack":
		return
	if as2d.frame == 2:
		a2d.monitorable = true
		a2d.monitoring = true
	if as2d.frame == 3:
		a2d.monitorable = false
		a2d.monitoring = false
		
func exit() -> void:
	checkHit = true
	a2d.monitorable = false
	a2d.monitoring = false
# LOCK input during attack
func process_input(event: InputEvent) -> State:
	return null

# Decide state when attack animation ends
func process_frame(delta: float) -> State:
	if not as2d.is_playing():
		var direction = Input.get_axis("runL", "runR")
		if direction != 0:
			return run_state
		elif direction == 0:
			return idle_state
		elif parent.velocity.y > 0:
			return fall_state
		else:
			return jump_state
			
	if hit:
		return hit_state
		
	return null
	
func _on_area_2d_2_area_entered(area: Area2D) -> void:
	pass

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	
	return null
