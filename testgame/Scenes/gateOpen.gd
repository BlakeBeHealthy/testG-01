extends Node2D
@onready var gate: StaticBody2D = $Gate


func _ready() -> void:
	if Global.hannible:
		gate.playOpenClose()
