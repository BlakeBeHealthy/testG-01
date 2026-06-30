extends Area2D

func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.get_parent() is Player:
		print("IT WORKED!")
		var player = area.get_parent()
		player.respawnCoord = self.global_position
