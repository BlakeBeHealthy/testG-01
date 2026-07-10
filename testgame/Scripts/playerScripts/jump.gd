extends State
class_name Jump

#Basic jump class
@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var a2d2: Area2D = $"../../Area2D2"
@onready var attack_delay: Timer = $"../../attackDelay"
@onready var a2d: Area2D = $"../../Area2D"
@onready var c: CollisionShape2D = $"../../c"
@export var wall_jump_force: float
@export var wall_jump_forceY: float
@export var decayRate: float
@onready var wall_jump_buffer: Timer = $"../../WallJumpBuffer"
@export var air_control_lockout: float = 0.05
@onready var buff_delay: Timer = $"../../buffDelay"

var wallJumpOver := true
var dir := 0
var counter := 0
var direction: = 0.0

func enter() -> void:
	wall_jump_buffer.start()
	buff_delay.start()
	dir = Input.get_axis("runL", "runR")
	if parent.wall_state == parent.WallState.NONE:
		if !parent.jumpCheck:
			as2d.play("jump")
			parent.air_control_timer.start(0.1)
			parent.velocity.y = -parent.JUMP
			parent.jumpCheck = true
	else:
		as2d.play("jump")
		parent.wall_slide_fall.start()
		parent.velocity.x = -parent.Jdirection * wall_jump_force
		parent.velocity.y = -wall_jump_forceY
		parent.air_control_timer.start(air_control_lockout)
		parent.wall_state = parent.WallState.JUMPING
		parent.Jdirection = -parent.Jdirection
		
		
func exit() -> void:
	if !buff_delay.is_stopped():
		buff_delay.stop()

func process_input(event: InputEvent) -> State:
	if parent.state_machine.current_state != parent.jump_state:
		return
		
	if parent.wall_state == parent.WallState.JUMPING:
		if Input.is_action_just_pressed("jump") and parent.moveCheck:
			parent.air_control_timer.stop()
			parent.wall_state = parent.WallState.NONE
			parent.moveCheck = false
			parent.velocity.y = -parent.JUMP
			return null  # stay in jump state, just reset the arc
	
	if Input.is_action_just_pressed("jump") and buff_delay.is_stopped():
		parent.wantJump = true
	return null

		
func process_frame(delta: float) -> State:
	if parent.takeHit:
		return parent.hit_state
		
	if parent.wall_state == parent.WallState.SLIDING:
		return parent.wallSlide_state
		
	if parent.dash:
		return parent.dash_state
		
	if parent.parryCheck:
		return parent.parry_state
		
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
	if parent.wall_state != parent.WallState.JUMPING:
		if Input.is_action_just_released("jump"):
			parent.velocity.y *= parent.jumpCut
		
	
	parent.velocity.y += gravity * delta
	
	direction = Input.get_axis("runL", "runR")
	parent.apply_horizontal_air_control(move_speed)
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if direction != 0:
			return parent.run_state
		elif direction == 0:
			return parent.idle_state
	if !parent.is_on_floor() and parent.velocity.y > 0:
		return parent.fall_state
	return null


func _on_wall_slide_fall_timeout() -> void:
	if parent.wallJump:
		parent.wallJump = false
