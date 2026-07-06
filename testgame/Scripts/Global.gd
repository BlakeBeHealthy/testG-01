extends Node

var debug_dialogue: String = ""
var debug_start: String = ""
var debug_cutscene: String = ""
var debug_mode: bool = false
var knight_dead: bool = false
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
		Gameplay.Knightgrandma = false
		Gameplay.Knight = false
		SceneM.load_level("res://Scenes/Level01.tscn")
		
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
