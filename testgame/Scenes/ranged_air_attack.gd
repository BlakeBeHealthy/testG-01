extends HannibalState

@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var slash_projectile = preload("res://Scenes/slash_projectile.tscn")

var readyProjectiles: bool = false
var shooting: bool = false
var pattern: int = 2
var projectileWindow: float = 1.0

func enter() -> void:
	if !parent.lunge:
		as2d.play("projectileAttack")
	else:
		parent.flip_direction()
		as2d.play("pray_start")
	
func exit() -> void:
	if !parent.lunge:
		parent.lunge = true
	else:
		parent.lunge = false
	parent.playerAbove = false
	readyProjectiles = false

func process_input(event: InputEvent) -> States:
	return null

func process_frame(delta: float) -> States:
	if readyProjectiles:
		if !parent.lunge:
			var slash1 = slash_projectile.instantiate()
			var slash2 = slash_projectile.instantiate()
			var slash3 = slash_projectile.instantiate()
			var slash4 = slash_projectile.instantiate()
			var slash5 = slash_projectile.instantiate()
			slash1.rotate = 90
			slash2.rotate = -45
			slash3.rotate = 45
			slash1.direction = 0
			slash2.direction = 1
			slash3.direction = -1
			slash4.direction = 1
			slash5.direction = -1
			slash1.global_position = parent.global_position + Vector2(3 * slash1.direction, -3)
			slash2.global_position = parent.global_position + Vector2(3 * slash2.direction, -3)
			slash3.global_position = parent.global_position + Vector2(3 * slash3.direction, -3)
			slash4.global_position = parent.global_position + Vector2(3 * slash4.direction, 3)
			slash5.global_position = parent.global_position + Vector2(3 * slash5.direction, 3)
			slash1.yChange = true
			slash2.yChange = true
			slash3.yChange = true
			if parent.phase2:
				var slash6 = slash_projectile.instantiate()
				var slash7 = slash_projectile.instantiate()
				var slash8 = slash_projectile.instantiate()
				var slash9 = slash_projectile.instantiate()
				var slash10 = slash_projectile.instantiate()
				slash6.rotate = 90
				slash7.rotate = -45
				slash8.rotate = 45
				slash6.direction = 0
				slash7.direction = 1
				slash8.direction = -1
				slash9.direction = 1
				slash10.direction = -1
				slash6.global_position = parent.global_position + Vector2(3 * slash6.direction, -3)
				slash7.global_position = parent.global_position + Vector2(3 * slash7.direction, -3)
				slash8.global_position = parent.global_position + Vector2(3 * slash8.direction, -3)
				slash9.global_position = parent.global_position + Vector2(3 * slash9.direction, 3)
				slash10.global_position = parent.global_position + Vector2(3 * slash10.direction, 3)
				slash6.yChange = true
				slash7.yChange = true
				slash8.yChange = true
				slash6.speed = 350
				slash7.speed = 350
				slash8.speed = 350
				slash9.speed = 350
				slash10.speed = 350
				add_child(slash6)
				add_child(slash7)
				add_child(slash8)
				add_child(slash9)
				add_child(slash10)
			add_child(slash1)
			add_child(slash2)
			add_child(slash3)
			add_child(slash4)
			add_child(slash5)
			if as2d.frame == 5:
				parent.idle_time = 1.0
				parent.chase = true
				return parent.idle_state
		else:
			if !shooting:
				shooting = true
				diagonalShoot()
				shootingout()
			elif as2d.animation == "pray_end" and as2d.frame == 2:
				shooting = false
				parent.idle_time = 2.0
				return parent.idle_state
	return null

func process_physics(delta: float) -> States:
	return null

func shoot(loopcount: int = 1, duration: float = 0, wait: float = 1.0, speed: float = 400) -> void:
	if wait == 0:
		wait = projectileWindow
	
	while loopcount > 0:
		print(loopcount)
		var slash1 = slash_projectile.instantiate()
		slash1.speed = speed
		slash1.direction = parent.direction
		slash1.global_position = parent.global_position + Vector2(3 * slash1.direction, -3)
		add_child(slash1)
		await get_tree().create_timer(duration).timeout
		loopcount -= 1
	await get_tree().create_timer(wait).timeout
	
func shootingout():
	if pattern == 0:
		await shoot(5, 1.0, 2.5, 300)
		await shoot(5, 0.7, 1.0)
		await shoot(50, 0.001, 1.0, 300)
		await shoot(50, 0.001, 1.0)
		await shoot(50, 0.001, 1.0)
		pattern = 1
	elif pattern == 1:
		await shoot(70, 0.001, 0.4)
		await shoot(30, 0.001, 0.5)
		await shoot(100, 0.001, 1.5)
		await shoot(5, 0.5, 1.0, 300)
		await shoot(130, 0.001, 1.5)
		pattern = 2
	elif pattern == 2:
		await shoot(100, 0.001, 0.5)
		await shoot(100, 0.001, 1.0)
		await shoot(150, 0.001, 1.0)
		await shoot(15, 0.6, 1.0, 300)
		pattern = 3
	elif pattern == 3:
		await shoot(30, 0.001, 0.5, 100)
		await shoot(5, 0.7, 2.0, 300)
		await shoot(90, 0.001, 0.5, 100)
		await shoot(2, 0.8, 0.05, 300)
		await shoot(120, 0.001, 0.2, 100)
		await shoot(3, 0.8, 0.5, 300)
		await shoot(2, 0.8, 0.05, 300)
		await shoot(140, 0.001, 0.2, 100)
		await shoot(5, 0.5, 0.1, 300)
		pattern = 1
	as2d.play("pray_end")
	
func diagonalShoot():
	while shooting:
		var slash1 = slash_projectile.instantiate()
		var slash3 = slash_projectile.instantiate()
		slash1.rotate = 90
		if parent.direction == 1:
			slash3.rotate = -45
		else:
			slash3.rotate = 45
		slash1.direction = 0
		slash3.direction = parent.direction * 1
		slash1.global_position = parent.global_position + Vector2(3 * slash1.direction, -3)
		slash3.global_position = parent.global_position + Vector2(3 * slash3.direction, 3)
		slash1.yChange = true
		slash3.yChange = true
		add_child(slash1)
		add_child(slash3)
		await get_tree().create_timer(0.15).timeout
		var slash2 = slash_projectile.instantiate()
		if parent.direction == 1:
			slash2.rotate = -67.5
		else:
			slash2.rotate = 67.5
		slash2.direction = parent.direction * 0.5
		slash2.global_position = parent.global_position + Vector2(3 * slash2.direction, 3)
		slash2.yChange = true
		add_child(slash2)
		await get_tree().create_timer(0.15).timeout
		var slash5 = slash_projectile.instantiate()
		if parent.direction == 1:
			slash5.rotate = -56
		else:
			slash5.rotate = 56
		slash5.direction = parent.direction * 0.75
		slash5.global_position = parent.global_position + Vector2(3 * slash2.direction, 3)
		slash5.yChange = true
		add_child(slash5)
		var slash6 = slash_projectile.instantiate()
		if parent.direction == 1:
			slash6.rotate = -79
		else:
			slash6.rotate = 79
		slash6.direction = parent.direction * 0.25
		slash6.global_position = parent.global_position + Vector2(3 * slash2.direction, 3)
		slash6.yChange = true
		add_child(slash6)
		await get_tree().create_timer(0.15).timeout
		
func _on_animated_sprite_2d_frame_changed() -> void:
	if (as2d.animation != "pray_start" and as2d.animation != "projectileAttack") and \
	parent.state_machine.current_state != parent.airAttack_State and !readyProjectiles:
		return
		
	if as2d.frame == 3 and !readyProjectiles:
		readyProjectiles = true
