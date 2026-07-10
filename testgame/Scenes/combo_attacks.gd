extends HannibalState

@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@export var knockbackStrength: float = 0
@export var decayRate: float = 0
@export var lungeSpeed: float = 0
@onready var slash_projectile = preload("res://Scenes/slash_projectile.tscn")

var currentAttack = ""
var dir : int = 0  
var done: bool = false
var attacking: bool = false
var check: bool = false
var lungeCheck: bool = false
var attackDir: float = 0

func enter() -> void:
	if parent.phase2:
		knockbackStrength = 700
		lungeSpeed = 800
	dir = parent.direction
	if parent.lunge:
		if parent.chase:
			parent.chase = false
		currentAttack = "a3"
		lungeCheck = true
		parent.flip_direction()
	else:
		currentAttack = "a1"
	as2d.play(currentAttack)
	
func exit() -> void:
	done = false
	if lungeCheck:
		if parent.pray == parent.PrayMove.ACTIVE:
			parent.playerAbove = true
		else:        
			parent.lunge = false
			parent.chase = false
			lungeCheck = false
	else:
		parent.chase = true
		parent.lunge = true

func process_input(event: InputEvent) -> States:
	return null

func process_frame(delta: float) -> States:
	if parent.phase2S:
		lungeCheck = true
		return parent.idle_state
	
	
	if done:
		parent.idle_time = 1.0
		return parent.idle_state
	return null

func process_physics(delta: float) -> States:
	attackDir = Global.player.position.x - parent.position.x
	
	if done:
		return
		
	if attacking:
		dir = parent.direction
		parent.velocity.x += dir * knockbackStrength
		attacking = false
		check = true
	elif check:
		parent.velocity.x = move_toward(parent.velocity.x, 0, decayRate * delta)
		if parent.velocity.x == 0:
			check = false
	elif !lungeCheck:
		parent.velocity.x = 0
		
	if !lungeCheck:
		if dir > 0 and parent.direction == -1:
			parent.flip_direction(1)
		elif dir < 0 and parent.direction == 1:
			parent.flip_direction(-1)
		
	if parent.lunge and as2d.frame == 4 and as2d.animation == "a3":
		parent.velocity.x = parent.direction * lungeSpeed
		parent.wallDetection.enabled = true
	elif parent.wallDetection.is_colliding() and as2d.animation == "a3" and as2d.frame > 2:
		if parent.phase2:
			var slash1 = slash_projectile.instantiate()
			var slash3 = slash_projectile.instantiate()
			var slash5 = slash_projectile.instantiate()
			slash1.rotate = 90
			if parent.direction == -1:
				slash3.rotate = -45
			else:
				slash3.rotate = 45
			slash1.direction = 0
			slash3.direction = parent.direction * -1
			slash5.direction = parent.direction * -1
			slash1.global_position = parent.global_position + Vector2(3 * slash1.direction, -3)
			slash5.global_position = parent.global_position + Vector2(3 * slash5.direction, 3)
			slash3.global_position = parent.global_position + Vector2(3 * slash3.direction, 3)
			slash1.yChange = true
			slash3.yChange = true
			add_child(slash1)
			add_child(slash3)
			add_child(slash5)
		parent.hitbox.monitorable = false
		parent.hitbox.monitoring = false
		parent.idle_time = 1.2
		done = true
		
	parent.move_and_slide()
	return null


func _on_animated_sprite_2d_frame_changed() -> void:
	if as2d.animation != "a1" and as2d.animation != "a2" \
		and as2d.animation != "a3":
		return
		
	if as2d.animation == "a1":
		if as2d.frame == 3:
			parent.hitbox.position = Vector2(18.4, 6.9) * Vector2(parent.direction, 1)
			parent.hitbox.scale = Vector2(1.5, 1.1)
			parent.hitbox.monitorable = true
			parent.hitbox.monitoring = true
			attacking = true
		if as2d.frame == 6:
			parent.hitbox.monitorable = false
			parent.hitbox.monitoring = false
			dir = attackDir
			as2d.play("a2")
		
	if as2d.animation == "a2":
		if as2d.frame == 3:
			if parent.direction == 1:
				parent.hitbox.position.x = 18.4
			elif parent.direction == -1:
				parent.hitbox.position.x = -18.4
			attacking = true
			parent.hitbox.monitorable = true
			parent.hitbox.monitoring = true
		if as2d.frame == 5:
			parent.hitbox.monitorable = false
			parent.hitbox.monitoring = false
			done = true
			
	if as2d.animation == "a3":
		if as2d.frame == 4:
			parent.hitbox.position = Vector2(24, 6) * Vector2(parent.direction, 1)
			parent.hitbox.scale = Vector2(2, 0.2)
			parent.hitbox.monitorable = true
			parent.hitbox.monitoring = true
		elif as2d.frame == 8 and !lungeCheck:
			parent.hitbox.monitorable = false
			parent.hitbox.monitoring = false
