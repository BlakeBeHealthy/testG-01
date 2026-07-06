extends Node2D
@onready var gate: StaticBody2D = $Gate


func _ready() -> void:
	if Global.hannible and Global.hannible1:
		gate.playOpenClose()
