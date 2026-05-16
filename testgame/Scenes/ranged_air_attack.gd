extends HannibalState

@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var slash_projectile = preload("res://Scenes/slash_projectile.tscn")

var readyProjectiles: bool = false

func enter() -> void:
	as2d.play("projectileAttack")
	
func exit() -> void:
	pass

func process_input(event: InputEvent) -> States:
	return null

func process_frame(delta: float) -> States:
	if readyProjectiles:
		if parent.playerAbove:
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
			if parent.middleAttack:
				parent.middleAttack = false
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
				slash6.speed = 400
				slash7.speed = 400
				slash8.speed = 400
				slash9.speed = 400
				slash10.speed = 400
				add_child(slash6)
				add_child(slash7)
				add_child(slash8)
				add_child(slash9)
				add_child(slash10)
			else:
				parent.lunge = true
				parent.chase = true
			add_child(slash1)
			add_child(slash2)
			add_child(slash3)
			add_child(slash4)
			add_child(slash5)
			parent.playerAbove = false
			readyProjectiles = false
	if as2d.frame == 5:
		parent.idle_time = 1.0
		return parent.idle_state
	return null

func process_physics(delta: float) -> States:
	return null


func _on_animated_sprite_2d_frame_changed() -> void:
	if as2d.animation != "projectileAttack" and parent.state_machine.current_state != parent.airAttack_State:
		return
		
	if as2d.frame == 3 and !readyProjectiles:
		readyProjectiles = true
