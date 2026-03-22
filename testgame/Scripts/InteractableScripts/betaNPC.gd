class_name BetaNPC extends Node2D

@onready var prompt: Node2D = $ButtonPrompt
@onready var as2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var c2d: CollisionShape2D = $CollisionShape2D

@export var button_prompt: String
@export var animationName: String
@export var dialogueScene: String
@export var startingPoint: String
var scaleNumber: Vector2 = Vector2(1, 1)

var areaCheck := false
var speak := false
var promptScale

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	prompt.hidePrompt()
	as2d.play(animationName)
	as2d.scale = scaleNumber
	print("Global.UI: ", Global.UI)

func _on_area_entered(area: Area2D) -> void:
	if !areaCheck:
		areaCheck = true
		Global.player.current_interactable = self
		promptScale = Vector2(1.0 / self.scale.x, 1.0 / self.scale.y)
		prompt.showPrompt(button_prompt, promptScale)
	if !Global.player.speaking.is_connected(speaking):
		Global.player.speaking.connect(speaking)
			
func _on_area_exited(area: Area2D) -> void:
	Global.player.current_interactable = null
	areaCheck = false
	prompt.hidePrompt()
	
func speaking(endCheck: int):
	if endCheck != 0:
		prompt.hidePrompt()
		if !speak:
			speak = true
		else:
			return
			
		if Global.player.current_interactable != self:
			return
			
		if startingPoint == "":
			startingPoint = "start"
		
		print("SPEAK")
		
		if dialogueScene == "":
			push_error("Dialogue Scene tree is empty!")
			
		Global.UI.get_node("Balloon").start(load(dialogueScene), startingPoint)
	else:
		speak = false
		prompt.showPrompt(button_prompt, promptScale)
	
