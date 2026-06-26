extends Node2D

@onready var has2d: AnimatedSprite2D = $hannibal
@export var debug_dialogue: String = ""
@export var debug_start: String = ""
@export var debug_cutscene: String = ""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.ap = $AnimationPlayer
	Global.debug_dialogue = debug_dialogue
	Global.debug_start = debug_start
	Global.debug_cutscene = debug_cutscene

func _process(delta: float) -> void:
	if Global.hannible and !Global.cutsceneStarted:
		has2d.position = Vector2(451.005, 151.0)
		has2d.play("dead")
