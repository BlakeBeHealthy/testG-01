extends Area2D

@onready var m2d: Marker2D = $Marker2D
@onready var a2d: AnimatedSprite2D = $AnimatedSprite2D
@export var current_scene_path: String

func _ready() -> void:
	update_sprite()
	
func _on_area_entered(area: Area2D) -> void:
	a2d.play("activate")
	update_checkpoint()
	update_sprite()
	
func update_sprite() -> void:
	if m2d.global_position == Global.checkpoint_pos:
		a2d.play("active")
	else:
		a2d.play("idle")
		
func update_checkpoint() -> void:
	if Global.checkpoint_pos == m2d.global_position and Global.checkpoint_scene == current_scene_path:
		return
	
	Global.checkpoint_pos = m2d.global_position
	Global.checkpoint_scene = current_scene_path
