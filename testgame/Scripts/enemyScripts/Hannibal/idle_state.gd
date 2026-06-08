extends HannibalState

@onready var idle_time: Timer = $"../../idleTime"
@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

var idleOver
var cutCheck

func enter() -> void:
	idleOver = false
	as2d.play("idle")
	if Global.cutsceneStarted:
		cutCheck = true
		as2d.frame = 0
		as2d.stop()
		
	elif parent.idle_time == 0:
		idle_time.start()
	else:
		idle_time.start(parent.idle_time)
	
	
func exit() -> void:
	pass

func process_input(event: InputEvent) -> States:
	return null

func process_frame(delta: float) -> States:
	if Global.cutsceneStarted:
		cutCheck = true
		
	if !Global.cutsceneStarted and cutCheck:
		print(cutCheck)
		cutCheck = false
		idle_time.start(1.3)
		
	if idleOver and !Global.cutsceneStarted:
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
