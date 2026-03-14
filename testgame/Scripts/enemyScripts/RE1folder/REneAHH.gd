extends Area2D

@export var knockback_strength := 200
@export var stun_time := 0.2
@export var timeStop := 0.0
@export var duration := 0.2
@export var camShakeStrength := 2
@export var shakeDuration := 0.2

#RANGED ENEMY
func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.get_parent() is Player:
		var player = area.get_parent()

		if !player.invincible:
			player.hit(
				sign(player.global_position.x - global_position.x),
				knockback_strength,
				stun_time,
				timeStop,
				duration,
				camShakeStrength,
				shakeDuration
			)
