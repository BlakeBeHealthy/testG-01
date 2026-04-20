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

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	if idleOver:
		pass
	
	return null

func process_physics(delta: float) -> State:
	return null


func _on_idle_timer_timeout() -> void:
	idleOver = true
