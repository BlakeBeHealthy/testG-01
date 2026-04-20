extends HannibalState

var moveCheck = false


func enter() -> void:
	moveCheck = true
	pass
	
	
func exit() -> void:
	pass

func process_input(event: InputEvent) -> States:
	return null

func process_frame(delta: float) -> States:
	return null
	
func process_physics(delta: float) -> States:
	if moveCheck:
		parent.velocity.y = parent.wallJump
		await get_tree().create_timer(0.2).timeout
	return null
