extends HannibalState

@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var slash_projectile = preload("uid://lbvmh8hgo4xg")

var readyProjectiles: bool = false

func enter() -> void:
	as2d.play("fall_attack_land")
	
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
			
			slash1.rotate = 90
			slash2.rotate = -45
			slash3.rotate = 45
			slash1.direction = 0
			slash2.direction = 1
			slash3.direction = -1
			slash1.global_position = parent.global_position + Vector2(3 * slash1.direction, -3)
			slash2.global_position = parent.global_position + Vector2(3 * slash2.direction, -3)
			slash3.global_position = parent.global_position + Vector2(3 * slash2.direction, -3)
			slash1.yChange = true
			slash2.yChange = true
			slash3.yChange = true
			add_child(slash1)
			add_child(slash2)
			add_child(slash3)
			parent.playerAbove = false
	else:
		parent.idle_time = 1.0
		return parent.idle_state
	return null

func process_physics(delta: float) -> States:
	return null


func _on_animated_sprite_2d_frame_changed() -> void:
	if as2d.animation != "fall_attack_land" and parent.state_machine.current_state != parent.airAttack_State:
		return
		
	if as2d.frame == 1:
		readyProjectiles = true
