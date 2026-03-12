extends Node

var player
var camera
#Accessing the camera and the player, some scripts are global however, check project settings
var checkpoint_pos: Vector2 = Vector2(-1134, -1)
var checkpoint_scene = "res://Scenes/Level01.tscn"
# Called when the node enters the scene tree for the first time.
func set_player(node):
	player = node

func get_player():
	return player
	
func set_camera(c: Camera2D):
	camera = c

func get_camera() -> Camera2D:
	return camera
