extends Area2D

@export var knockback_strength := 200
@export var stun_time := 0.2
@export var timeStop := 0.0
@export var duration := 0.2
@export var camShakeStrength := 2
@export var shakeDuration := 0.2
@export var dmg: int

#MELEE ENEMY
func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		var player = area.get_parent()
		
		if !player.invincible and !player.parryCheck:
			player.hit(
				dmg,
				sign(player.global_position.x - global_position.x),
				knockback_strength,
				stun_time,
				timeStop,
				duration,
				camShakeStrength,
				shakeDuration
			)
