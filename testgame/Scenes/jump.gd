extends HannibalState

@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var jump_timer: Timer = $"../../JumpTimer"

var moveCheck = false


func enter() -> void:
	as2d.play("jump")
	jump_timer.start()
	moveCheck = true
	
	
func exit() -> void:
	pass

func process_input(event: InputEvent) -> States:
	return null

func process_frame(delta: float) -> States:
	if jump_timer.is_stopped():
		if parent.is_on_floor():
			print("idle")
			return parent.idle_state
	return null
	
func process_physics(delta: float) -> States:
	if moveCheck:
		parent.velocity.y = -parent.jumpStrength
		moveCheck = false
	else:
		parent.velocity.y += gravity * delta
	parent.move_and_slide()
	return null


func _on_jump_timer_timeout() -> void:
	print("ended")
