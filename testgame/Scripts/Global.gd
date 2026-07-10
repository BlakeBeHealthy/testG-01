extends Node

var debug_dialogue: String = ""
var debug_start: String = ""
var debug_cutscene: String = ""
var debug_mode: bool = false
var cutsceneStarted: bool = false
var inputBlocked: bool = false
var cutWait: bool = false
var clash_won: bool = false
var qte: bool = true
var hannible: bool = false
var hannible1: bool = false
var han: bool = false
var spawning: bool = false
var inv: bool = false
var timeSlow: bool = false
var player: CharacterBody2D
var Clash: Control
var camera: Camera2D
var prompt: Node2D
var UI: CanvasLayer
var ap: AnimationPlayer
const SAVE_PATH = "user://save.json"
signal playerDone
signal healthUp
signal DoorChange
signal shakeDone
signal clash_over

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
	
func save_game() -> void:
	var data = {
		"checkpoint_pos_x": saveData.checkpoint_pos.x,
		"checkpoint_pos_y": saveData.checkpoint_pos.y,
		"checkpoint_scene": saveData.checkpoint_scene,
		"Rain": Gameplay.Rain,
		"DJ": Gameplay.DJ,
		"Knightgrandma": Gameplay.Knightgrandma,
		"Knight": Gameplay.Knight,
		"hannible": hannible,
		"hannible1": hannible1,
		"han": han
		}
		
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data, "\t"))
	file.close()
	print("saved!")
	
func load_game() -> void:
	if !FileAccess.file_exists(SAVE_PATH):
		print("no save file found, starting fresh")
		return
		
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()
		
	if data == null:
		print("save file corrupted, starting fresh")
		return
		
	saveData.checkpoint_pos.x = data["checkpoint_pos_x"]
	saveData.checkpoint_pos.y = data["checkpoint_pos_y"]
	saveData.checkpoint_scene = data["checkpoint_scene"]
	Gameplay.Rain = data["Rain"]
	Gameplay.DJ = data["DJ"]
	Gameplay.Knightgrandma = data["Knightgrandma"]
	Gameplay.Knight = data["Knight"]
	hannible = data["hannible"]
	hannible1 = data["hannible1"]
	han = data["han"]
	print("loaded!")
	
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
	
# in Global.gd
func startCutscene(dialogueFile: String, startingPoint: String, introAnim: String = "", skipStart: bool = false) -> void:
	if !cutsceneStarted:
		cutsceneStarted = true
		
	player.control_locked = true
	if introAnim != "":
		ap.play(introAnim)
		await ap.animation_finished
	UI.balloon.start(load(dialogueFile), startingPoint, skipStart)
	
func clashing() -> void:
	await clash_over
	
func apply_timeSlow(timeScale: float, duration: float) -> void:
	if timeSlow:
		return
		
	timeSlow = true
	Engine.time_scale = timeScale
	await get_tree().create_timer(duration, false, false, true).timeout
	Engine.time_scale = 1.0
	timeSlow = false

func apFinish(anim: String = "") -> void:
	ap.play(anim)
	await ap.animation_finished

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("ctrl") and Input.is_action_pressed("0"):
		Gameplay.DJ = true
		Gameplay.Knightgrandma = true
		Gameplay.Knight = true
		SceneM.load_level("res://Scenes/level_08.tscn")
		
	if Input.is_action_pressed("ctrl") and Input.is_action_pressed("9"):
		inv = !inv
		
	if Input.is_action_pressed("ctrl") and Input.is_action_pressed("8"):
		Gameplay.DJ = true
		Global.hannible = true

	if Input.is_action_pressed("ctrl") and Input.is_action_pressed("1"):
		var restartData = {
			"checkpoint_pos.x": -1505,
			"checkpoint_pos.y": -597,
			"checkpoint_scene": "res://Scenes/Level01.tscn",
			"Rain": false,
			"DJ": false,
			"Knightgrandma": false,
			"Knight": false,
			"hannible": false,
			"hannible1": false,
			"han": false
			}
		saveData.checkpoint_pos.x = restartData["checkpoint_pos.x"]
		saveData.checkpoint_pos.y = restartData["checkpoint_pos.y"]
		saveData.checkpoint_scene = restartData["checkpoint_scene"]
		Gameplay.Rain = restartData["Rain"]
		Gameplay.DJ = restartData["DJ"]
		Gameplay.Knightgrandma = restartData["Knightgrandma"]
		Gameplay.Knight = restartData["Knight"]
		hannible = restartData["hannible"]
		hannible1 = restartData["hannible1"]
		han = restartData["han"]
		save_game()
		await FadeS.fade_out(1.5, true)
		SceneM.load_level("res://Scenes/Level01.tscn")
		await FadeS.fade_in(1.5, true)
		
	if Input.is_action_pressed("ctrl") and Input.is_action_pressed("5"):
		SceneM.load_level("res://Scenes/level__05.tscn")
	
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
