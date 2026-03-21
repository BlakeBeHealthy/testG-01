extends Control

@onready var animated_sprite_2d: AnimatedSprite2D = $HBoxContainer/Control/AnimatedSprite2D
@onready var label: Label = $HBoxContainer/MarginContainer/Panel/MarginContainer/Label
@onready var dialogue_label: DialogueLabel = $HBoxContainer/MarginContainer/Panel/MarginContainer/DialogueLabel
@onready var dialogue_responses_menu: DialogueResponsesMenu = $DialogueResponsesMenu
@onready var color_rect: ColorRect = $ColorRect
@onready var balloon: Control = $"."


# Called when the node enters the scene tree for the first time.
func start(resource: DialogueResource, title: String) -> void:
	balloon.visible = true
