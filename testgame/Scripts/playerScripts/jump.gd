extends State
class_name Jump

#Basic jump class
@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var a2d2: Area2D = $"../../Area2D2"
@onready var attack_delay: Timer = $"../../attackDelay"
@onready var a2d: Area2D = $"../../Area2D"
@onready var c: CollisionShape2D = $"../../c"
@export var wall_jump_force: float
@export var decayRate: float
@onready var wall_jump_buffer: Timer = $"../../WallJumpBuffer"
@export var air_control_lockout: float = 0.05


var wallJumpOver := true
var dir := 0
var counter := 0
var direction: = 0.0

func enter() -> void:
	wall_jump_buffer.start()
	dir = Input.get_axis("runL", "runR")
	if parent.wall_state == parent.WallState.NONE:
		if !parent.jumpCheck:
			as2d.play("jump")
			parent.velocity.y = -parent.JUMP
			parent.jumpCheck = true
	else:
		as2d.play("jump")
		parent.wall_slide_fall.start()
		print("Jdirection at launch: ", parent.Jdirection)
		parent.velocity.x = -parent.Jdirection * wall_jump_force
		parent.velocity.y = -wall_jump_force
		parent.air_control_timer.start(air_control_lockout)
		parent.wall_state = parent.WallState.JUMPING
		
		
func exit() -> void:
	c.position = Vector2(-0.5, 8)

func process_input(event: InputEvent) -> State:
	if !wallJumpOver and Input.is_action_just_pressed("jump"):
		parent.wallJumpBuff = true
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
	
	if direction > 0:
		parent.wallslide_chest.target_position.x = abs(parent.wallslide_chest.target_position.x) * direction
		parent.wallslide_chest.position.x = 3.5
		parent.wallslide_legs.target_position.x = abs(parent.wallslide_legs.target_position.x) * direction
		parent.wallslide_legs.position.x = 3.5
		parent.flip_direction(1)
		a2d2.position.x = 3
		a2d.position.x = 21
	elif direction < 0:
		parent.wallslide_chest.target_position.x = abs(parent.wallslide_chest.target_position.x) * direction
		parent.wallslide_chest.position.x = -1.55
		parent.wallslide_legs.target_position.x = abs(parent.wallslide_legs.target_position.x) * direction
		parent.wallslide_legs.position.x = -1.55
		parent.flip_direction(-1)
		parent.a2d.position.x = -21
		parent.a2d2.position.x = -3
	elif direction == 0:
		if as2d.flip_h:
			c.position = Vector2(-3, 0)
			parent.wallslide_chest.target_position.x = abs(parent.wallslide_chest.target_position.x) * direction
			parent.wallslide_chest.position.x = -1.55
			parent.wallslide_legs.target_position.x = abs(parent.wallslide_legs.target_position.x) * direction
			parent.wallslide_legs.position.x = -1.55
			parent.flip_direction(-1)
			parent.a2d.position.x = -21
			parent.a2d2.position.x = -3
		else:
			c.position = Vector2(3, 0)
			parent.wallslide_chest.target_position.x = abs(parent.wallslide_chest.target_position.x) * direction
			parent.wallslide_chest.position.x = 3.5
			parent.wallslide_legs.target_position.x = abs(parent.wallslide_legs.target_position.x) * direction
			parent.wallslide_legs.position.x = 3.5
			parent.flip_direction(1)
			a2d2.position.x = 3
			a2d.position.x = 21
	if parent.is_on_floor():
		if direction != 0:
			return parent.run_state
		elif direction == 0:
			return parent.idle_state
	if !parent.is_on_floor() and parent.velocity.y > 0:
		return parent.fall_state
		
	if direction == -1:
		c.position = Vector2(-3, 2)
		a2d2.position.y = 0
		a2d2.position.x = -4
	elif direction == 1:
		c.position = Vector2(3, 2)
		a2d2.position.x = 4
		a2d2.position.y = 0
	return null


func _on_wall_slide_fall_timeout() -> void:
	if parent.wallJump:
		parent.wallJump = false
