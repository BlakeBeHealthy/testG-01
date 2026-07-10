extends Control
@onready var as2d: AnimatedSprite2D = $MarginContainer/SubViewportContainer/SubViewport/AnimatedSprite2D
@onready var hearts_ui: Control = $"."
var dead := false
var reviving := false

func die() -> void:
	dead = true
	reviving = false
	as2d.play("die")

func revive() -> void:
	dead = false
	reviving = true
	visible = true
	as2d.play("die")
	await as2d.animation_finished
	as2d.play("alive")  # same animation, different end-state handling

func _on_animated_sprite_2d_animation_finished() -> void:
	if as2d.animation != "die":
		return
		
	if reviving:
		visible = true  # stay visible, ended on full-heart frame
	else:
		visible = false  # hide, ended on empty-heart frame
