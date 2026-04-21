extends HannibalState

@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var jump_timer: Timer = $"../../JumpTimer"

var moveCheck: bool = false
var landOver: bool = false
var fallAttack: bool = false
var GravityReduction: float = 5
var decayRate: float = 4000
var forwardMomentum: float = 21000
var walljumpMomentum: float = 480

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
	
	if parent.wallJump and parent.player_detect.is_colliding():
		fallAttacking()
		
	if landOver:
		return parent.idle_state
	return null
	
func process_physics(delta: float) -> States:
	if moveCheck:
		if parent.wallJump:
			parent.velocity.y = -walljumpMomentum
		else:
			parent.velocity.y = -parent.jumpStrength
		moveCheck = false
	elif !parent.wallDetection.is_colliding() and !fallAttack:
		parent.velocity.y += gravity * delta
	elif fallAttack:
		parent.velocity.y = move_toward(parent.velocity.y, abs(GravityReduction * gravity), decayRate * delta)
		print(parent.velocity.y)
	else:
		parent.velocity.y += (gravity * 0.3) * delta
	
	if fallAttack:
		parent.velocity.x = 0
	else:
		parent.velocity.x = forwardMomentum * parent.direction * delta
	
	
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
	
func fallAttacking() -> void:
	fallAttack = true
	as2d.play("fall_attack")
	pass
