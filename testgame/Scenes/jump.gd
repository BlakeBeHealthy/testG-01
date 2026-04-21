extends HannibalState

@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var jump_timer: Timer = $"../../JumpTimer"

var moveCheck: bool = false
var landOver: bool = false
var GravityReduction: float = 0.2
var forwardMomentum: float = 300

func enter() -> void:
	as2d.play("jump")
	jump_timer.start()
	moveCheck = true
	
	
func exit() -> void:
	pass

func process_input(event: InputEvent) -> States:
	return null

func process_frame(delta: float) -> States:
	if parent.wallDetection.is_colliding() and !parent.is_on_floor():
		walljump()
		
	if landOver:
		return parent.idle_state
	return null
	
func process_physics(delta: float) -> States:
	if moveCheck:
		parent.velocity.y = -parent.jumpStrength
		parent.velocity.y = -parent.jumpStrength
		moveCheck = false
	elif !parent.wallDetection.is_colliding():
		parent.velocity.y += gravity * delta
	else:
		parent.velocity.y += (gravity * 0.3) * delta
	
	parent.velocity.x = forwardMomentum * parent.direction
	parent.move_and_slide()
	return null
	
func _on_jump_timer_timeout() -> void:
	pass
	
func walljump():
	if parent.wallJump:
		return
		
	parent.wallJump = true
	as2d.play("wallhang")
	await get_tree().create_timer(0.1).timeout
	parent.flip_direction()
	as2d.play("jump")
	if !jump_timer.is_stopped():
		jump_timer.stop()
	jump_timer.start()
	moveCheck = true
	
func _on_animated_sprite_2d_animation_finished() -> void:
	if as2d.animation != "fall_attack_land":
		return
	landOver = true
