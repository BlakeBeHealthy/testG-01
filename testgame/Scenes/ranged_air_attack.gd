extends HannibalState


@onready var slash_projectile = preload("uid://lbvmh8hgo4xg")

func enter() -> void:
	pass
	
func exit() -> void:
	pass

func process_input(event: InputEvent) -> States:
	return null

func process_frame(delta: float) -> States:
	return null

func process_physics(delta: float) -> States:
	return null


func _on_animated_sprite_2d_frame_changed() -> void:
	pass # Replace with function body.
