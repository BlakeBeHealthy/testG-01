extends Area2D

@onready var marker_2d: Marker2D = $Marker2D

func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.get_parent() is Player:
		var player = area.get_parent()
		player.respawnCoord = marker_2d.global_position + Vector2(0, 20)
