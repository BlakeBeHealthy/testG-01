extends HannibalState

@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

var currentAttack = ""

func enter() -> void:
	if parent.phase2 and parent.leap:
		currentAttack = "a3"
	else:
		currentAttack = "a1"
	
	
	as2d.play(currentAttack)
	
	
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
