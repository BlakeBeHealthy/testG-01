extends HannibalState

var moveCheck = false

func enter() -> void:
	moveCheck = true
	pass
	
	
func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	pass
	
	return null

func process_physics(delta: float) -> State:
	if moveCheck:
		parent.velocity.y = parent.wallJump
	return null
