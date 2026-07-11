extends State

@onready var wall_slide_fall: Timer = $"../../wallSlideFall"
@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var c: CollisionShape2D = $"../../c"
@onready var wall_jump: Timer = $"../../wallJump"
@export var wall_slide_terminal: float
@export var freeze_threshold: float = 150.0
@export var freeze_duration: float = 1.5
@onready var wall_touch_timer: Timer = $"../../wall_touch_timer"
@export var decay: float

var fall: bool = false
var direction: = 0.0

func enter() -> void:
	parent.Jdir = parent.Jdirection
	as2d.play("wallSlide")
	parent.wall_state = parent.WallState.SLIDING
	parent.as2d.position = Vector2(0, 3)
	if parent.velocity.y < freeze_threshold:
		parent.wall_state = parent.WallState.TOUCH
		parent.velocity = Vector2.ZERO
		wall_touch_timer.start(freeze_duration)
		
func _on_wall_touch_timer_timeout() -> void:
	if parent.wall_state == parent.WallState.TOUCH:
		parent.wall_state = parent.WallState.SLIDING
		
func exit() -> void:
	pass
	
func process_input(event: InputEvent) -> State:
	if (parent.wall_state == parent.WallState.TOUCH or parent.wall_state == parent.WallState.SLIDING) \
	and Input.is_action_just_pressed("jump"):
		wall_touch_timer.stop()
		parent.update_air_visuals(-parent.Jdir)
		return parent.jump_state
	return null

func process_frame(delta: float) -> State:
	direction = Input.get_axis("runL", "runR")
			
	if (as2d.flip_h and Input.is_action_pressed("runR")) or (!as2d.flip_h and Input.is_action_pressed("runL")):
		parent.update_air_visuals(-parent.Jdir)
		return parent.fall_state
		
	elif !parent.wallslide_chest.is_colliding() or !parent.wallslide_legs.is_colliding(): 
		if !parent.is_on_floor():
			parent.update_air_visuals(-parent.Jdir)
			return parent.fall_state
		
	if parent.is_on_floor():
		parent.wall_state = parent.WallState.NONE
		if direction != 0:
			return parent.run_state
		else:
			return parent.idle_state
	
	return null

func process_physics(delta: float) -> State:
	if parent.wall_state == parent.WallState.TOUCH:
		return null
		
	parent.velocity.y = lerp(parent.velocity.y, wall_slide_terminal * gravity, decay * delta)
	parent.move_and_slide()
	return null
