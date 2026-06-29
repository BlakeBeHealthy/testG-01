extends Area2D
class_name Checkpoint
#This is for the chest in Level 2, forgot to mention if the player dies it is a checkpoint
@onready var m2d: Marker2D = $Marker2D
@onready var as2d: AnimatedSprite2D = $AnimatedSprite2D
@export var current_scene_path: String = "null"
@export var button_prompt: String
@export var flipH: bool
@onready var prompt: Node2D = $ButtonPrompt

signal saveActivated
var areaCheck := false

func _ready() -> void:
	if current_scene_path == "null":
		current_scene_path = get_level_scene_path()
		
	update_sprite()
	if flipH:
		as2d.flip_h = true
		
func _on_area_entered(area: Area2D) -> void:
	#Once the player enters
	Global.player.current_interactable = self
	prompt.showPrompt(button_prompt)
	if !Global.player.saving.is_connected(saving):
		Global.player.saving.connect(saving)
	
func _on_area_exited(area: Area2D) -> void:
	Global.player.current_interactable = null
	areaCheck = false
	prompt.hidePrompt()

func saving(check: int):
	if check == 0:
		prompt.hidePrompt()
	elif check == 1:
		as2d.play("activate")
		update_checkpoint()
		update_sprite()
	elif check == 2:
		prompt.showPrompt(button_prompt)
func update_sprite() -> void:
	#Ensuring the activate animation doesn't play multiple times
	if m2d.global_position == Global.saveData.checkpoint_pos:
		as2d.play("active")
	else:
		as2d.play("idle")
		
func update_checkpoint() -> void:
	if Global.saveData.maxHealth != 3:
		Global.saveData.maxHealth = 3
		Global.healthUp.emit()
	#Using a scene path and X, Y coordinate for the saved position, ensuring its not there already
	if Global.saveData.checkpoint_pos == m2d.global_position and Global.saveData.checkpoint_scene == current_scene_path:
		return
		
	Global.saveData.checkpoint_pos = m2d.global_position
	Global.saveData.checkpoint_scene = current_scene_path
	
func get_level_scene_path() -> String:
	var node = get_parent()
	while node:
		if node.name != "Checkpoints" and node.scene_file_path != "" and node != get_tree().current_scene:
			return node.scene_file_path
		node = node.get_parent()
	return ""
