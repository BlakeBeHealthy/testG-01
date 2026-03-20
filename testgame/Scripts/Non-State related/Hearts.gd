extends Control
@onready var as2d: AnimatedSprite2D = $MarginContainer/SubViewportContainer/SubViewport/AnimatedSprite2D
@onready var hearts_ui: Control = $"."
var dead
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func die() -> void:
	hearts_ui.visible = true
	as2d.play("die")
	dead = true
	
func live() -> void:
	as2d.play("die")

func _on_animated_sprite_2d_animation_finished() -> void:
	if as2d.animation != "die":
		return
		
	hearts_ui.visible = false
