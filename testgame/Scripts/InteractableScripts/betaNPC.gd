class_name BetaNPC extends Node2D

@onready var prompt: Node2D = $ButtonPrompt
@onready var as2d: AnimatedSprite2D = $AnimatedSprite2D

@export var button_prompt: String
@export var animationName: String

var areaCheck := false
var speak := false
signal betaNPCSpeaking
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	as2d.play(animationName)

func _on_area_entered(area: Area2D) -> void:
	if !areaCheck:
		areaCheck = true
		Global.player.current_interactable = self
		prompt.showPrompt(button_prompt)
		if !Global.player.speaking.is_connected(speaking):
			Global.player.speaking.connect(speaking)
			
func _on_area_exited(area: Area2D) -> void:
	Global.player.current_interactable = null
	areaCheck = false
	prompt.hidePrompt()
	
func speaking():
	prompt.hidePrompt()
	if !speak:
		speak = true
	else:
		return
		
	if !Global.player.current_interactable != self:
		return
		
	print("kys")
