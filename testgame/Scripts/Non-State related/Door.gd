class_name Door extends Area2D

signal player_entered_door(door: Door)

#Door configuration
@export_enum("north", "south", "east", "west") var entry_direction  # Direction player is coming from         # How far player is pushed into the new level
@export var path_to_new_scene: String          # Scene to load when entering
@export var entry_door_name: String            # Name of the door in the next level

#Body enter event
func _on_body_entered(body: Node2D) -> void:
	if body != Global.player:
		return
	print("entered")
	# Signal Gameplay (or whoever is listening) that the player entered this door
	Gameplay.enter_door(path_to_new_scene, entry_door_name, entry_direction)
