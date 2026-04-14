extends Node

var debug_dialogue: String = ""
var debug_start: String = ""
var debug_cutscene: String = ""
var debug_mode: bool = true
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

func _input(event: InputEvent) -> void:
	if !debug_mode:
		return
		
	if event.is_action_just_pressed("debug_superspeed"):
		Engine.time_scale = 1.5
	if event.is_action_just_pressed("debug_slow"):
		Engine.time_scale = 0.5
	if event.is_action_just_pressed("debug_superslow"):
		Engine.time_scale = 0.1
	if event.is_action_just_pressed("debug_normal"):
		Engine.time_scale = 1.0
	if event.is_action_just_pressed("debug_cutscene"):
		ap.play(debug_cutscene)
	if event.is_action_just_pressed("debug_restart"):
		ap.stop()
		ap.play(debug_cutscene)
	if event.is_action_just_pressed("debug_pause"):
		get_tree().paused = !get_tree().paused
	if event.is_action_just_pressed("debug_skip"):
		ap.stop()
		UI.dialogueBalloon.start(load(debug_dialogue), debug_start)
