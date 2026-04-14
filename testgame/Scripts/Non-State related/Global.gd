extends Node

var player: CharacterBody2D
var camera: Camera2D
var UI: CanvasLayer
var ap: AnimationPlayer
signal playerDone
signal healthUp
var saveData = {
	"checkpoint_pos": Vector2(-1505, -597),
	"checkpoint_scene": "res://Scenes/Level01.tscn",
	"gold": 0,
	"maxHealth": 3,
	"maxMana": 3,
	"bosses": [],
	"abilities": [],
	"collectibles": [],
	"trinkets_collected": [],
	"trinkets_equipped": [],
}
#Accessing the camera and the player, some scripts are global however, check project settings
# Called when the node enters the scene tree for the first time.
func set_player(node):
	player = node
	playerDone.emit()

func get_player():
	return player
	
func set_camera(c: Camera2D):
	camera = c

func get_camera() -> Camera2D:
	return camera

func set_UI(node):
	UI = node

func get_UI():
	return UI
