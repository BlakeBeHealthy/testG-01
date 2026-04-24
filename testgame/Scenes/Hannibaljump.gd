extends HannibalState

@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var jump_timer: Timer = $"../../JumpTimer"
@onready var fall_attack_timer: Timer = $"../../fallAttackTimer"
@onready var slash_projectile = preload("uid://lbvmh8hgo4xg")

var moveCheck: bool = false
var landOver: bool = false
var fallAttack: bool = false
var flip: bool = false
var fallAttackCheck: bool = false
var GravityReduction: float = 5
var decayRate: float = 4000
var forwardMomentum: float = 25000
var walljumpMomentum: float = 480

func enter() -> void:
	if !flip:
		parent.flip_direction()
		flip = true
	as2d.play("jump")
	jump_timer.start()
	moveCheck = true
	
	
func exit() -> void:
	pass

func process_input(event: InputEvent) -> States:
	return null

func process_frame(delta: float) -> States:
	if parent.wallDetection.is_colliding() and !parent.is_on_floor() and !fallAttack:
		walljump()
	
	if parent.wallJump and (parent.player_detect.is_colliding() \
	or fall_attack_timer.is_stopped()):
		if !fall_attack_timer.is_stopped():
			fall_attack_timer.stop()
		parent.wallJump = false
		fallAttacking()
		
	if landOver:
		landOver = false
		parent.idle_time = 1.4
		parent.chase = true
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
	
	fall_attack_timer.start()
	parent.wallJump = true
	as2d.play("wallhang")
	await get_tree().create_timer(0.1).timeout
	fallAttackCheck = true
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
	while !parent.is_on_floor():
		await get_tree().process_frame
	as2d.play("fall_attack_land")
	var projectile : bool = true
	if projectile:
		var slash1 = slash_projectile.instantiate()
		var slash2 = slash_projectile.instantiate()
		print(slash1)
		print(slash2)
		slash1.direction = 1
		slash2.direction = -1
		slash2.rotation = 60
		slash1.global_position = parent.global_position + Vector2(5 * slash1.direction, 3)
		slash2.global_position = parent.global_position + Vector2(5 * slash2.direction, 3)
		add_child(slash1)
		add_child(slash2)
		projectile = false
	await as2d.animation_finished
	fallAttack = false
	
