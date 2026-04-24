extends HannibalState

@onready var idle_time: Timer = $"../../idleTime"
@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

var idleOver

func enter() -> void:
	idleOver = false
	as2d.play("idle")
	if parent.idle_time == 0:
		idle_time.start()
	else:
		idle_time.start(parent.idle_time)
	
	
func exit() -> void:
	pass

func process_input(event: InputEvent) -> States:
	return null

func process_frame(delta: float) -> States:
	if idleOver:
		idleOver = false
		if parent.chase:
			parent.chase = false
			return parent.chase_state
		elif parent.playerAbove:
			return parent.airAttack_State
		else:
			return parent.jump_state
	
	return null

func process_physics(delta: float) -> States:
	return null

func _on_idle_time_timeout() -> void:
	idleOver = true
