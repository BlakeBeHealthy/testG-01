extends Area2D
#This is for the chest in Level 2, forgot to mention if the player dies it is a checkpoint

@onready var m2d: Marker2D = $Marker2D
@onready var a2d: AnimatedSprite2D = $AnimatedSprite2D
@export var current_scene_path: String

func _ready() -> void:
	update_sprite()
	
func _on_area_entered(area: Area2D) -> void:
	#Once the player enters
	a2d.play("activate")
	update_checkpoint()
	update_sprite()
	
func update_sprite() -> void:
	#Ensuring the activate animation doesn't play multiple times
	if m2d.global_position == Global.saveData.checkpoint_pos:
		a2d.play("active")
	else:
		a2d.play("idle")
		
func update_checkpoint() -> void:
	#Using a scene path and X, Y coordinate for the saved position, ensuring its not there already
	if Global.saveData.checkpoint_pos == m2d.global_position and Global.saveData.checkpoint_scene == current_scene_path:
		return
	
	Global.saveData.checkpoint_pos = m2d.global_position
	Global.saveData.checkpoint_scene = current_scene_path
