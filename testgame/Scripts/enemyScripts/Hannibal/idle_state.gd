extends HannibalState

@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var idle_time: Timer = $"../../idleTime"

var idleOver

func enter() -> void:
	idleOver = false
	as2d.play("idle")
	idle_time.start()
	
	
func exit() -> void:
	pass

func process_input(event: InputEvent) -> States:
	return null

func process_frame(delta: float) -> States:
	if idleOver:
		idleOver = false
		print("jump")
		return parent.jump_state
	
	return null

func process_physics(delta: float) -> States:
	return null

func _on_idle_time_timeout() -> void:
	idleOver = true
