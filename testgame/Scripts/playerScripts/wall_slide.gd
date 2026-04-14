extends State

@onready var wall_slide_fall: Timer = $"../../wallSlideFall"
@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var c: CollisionShape2D = $"../../c"
@onready var wall_jump: Timer = $"../../wallJump"
@export var wall_slide_terminal: float

@export var decay: float

var jumpC := false
var fall := false

func enter() -> void:
	print("WALLSLIDE")
	as2d.play("wallSlide")
	parent.wallSlide = false
	if !as2d.flip_h:
		c.position = Vector2(-1, 8)
	else:
		c.position = Vector2(1, 8)
	

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	var direction = Input.get_axis("runL", "runR")
	
	if Input.is_action_just_released("jump"):
		jumpC = true
	

			
	if as2d.flip_h:
		if Input.is_action_pressed("runR") or (!Input.is_action_pressed("runL") and fall):
			parent.wallJump = true
			return parent.fall_state
	else:
		if Input.is_action_pressed("runL") or (!Input.is_action_pressed("runR") and fall):
			parent.wallJump = true
			return parent.fall_state
			
	if Input.is_action_just_pressed("jump") or parent.wallJumpBuff:
			parent.wallJump = true
			parent.wallJumpBuff = false
			return parent.jump_state
			
	elif !parent.wallslide_chest.is_colliding() or !parent.wallslide_legs.is_colliding(): 
		if !parent.is_on_floor():
			print("FALL")
			parent.wallJump = true
			return parent.fall_state
		
	if parent.is_on_floor():
		if direction != 0:
			return parent.run_state
		else:
			return parent.idle_state
	
	return null

func process_physics(delta: float) -> State:
	
	parent.velocity.y = lerp(parent.velocity.y, wall_slide_terminal * gravity, decay * delta)
	parent.move_and_slide()
	return null
