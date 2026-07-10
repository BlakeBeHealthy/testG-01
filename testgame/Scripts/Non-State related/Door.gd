class_name Door extends Area2D

signal player_entered_door(door: Door)

#Door configuration
@export_enum("north", "south", "east", "west") var entry_direction  # Direction player is coming from         # How far player is pushed into the new level
@export var path_to_new_scene: String          # Scene to load when entering
@export var entry_door_name: String            # Name of the door in the next level

func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	Global.player.visible = false
	Gameplay.enter_door(path_to_new_scene, entry_door_name, entry_direction)
