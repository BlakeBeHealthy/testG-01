extends Node2D

@export var debug_dialogue: String = ""
@export var debug_start: String = ""
@export var debug_cutscene: String = ""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.ap = $AnimationPlayer
	Global.debug_dialogue = debug_dialogue
	Global.debug_start = debug_start
	Global.debug_cutscene = debug_cutscene
