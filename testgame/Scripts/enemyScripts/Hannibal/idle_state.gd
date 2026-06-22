extends HannibalState

@onready var idle_time: Timer = $"../../idleTime"
@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

var idleOver: bool
var cutCheck: bool
var KB: bool = false
var t: Tween
var dir: float
var dialogue_manager = Engine.get_singleton("DialogueManager")

func enter() -> void:
	print("3", parent.phase2S)
	if parent.phase2S and !parent.phase2:
		parent.phase2 = false
		cutCheck = true
		phase2start()
	else:
		as2d.play("idle")
		idleOver = false
		if Global.cutsceneStarted:
			cutCheck = true
			as2d.frame = 0
			as2d.stop()
			
		elif parent.idle_time == 0:
			idle_time.start()
		else:
			idle_time.start(parent.idle_time)
	
	
func exit() -> void:
	if parent.phase2S:
		parent.phase2S = false

func process_input(event: InputEvent) -> States:
	return null

func process_frame(delta: float) -> States:
	if parent.phase2S and !parent.phase2 and parent.healthCount <= 20:
		parent.phase2 = false
		cutCheck = true
		phase2start()
		
	if Global.cutsceneStarted and !cutCheck:
		cutCheck = true
		
	if !Global.cutsceneStarted and cutCheck:
		cutCheck = false
		idle_time.start(1.3)
		
	if idleOver and !Global.cutsceneStarted and !cutCheck:
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
	if KB:
		parent.velocity.x = 100 * dir
		parent.velocity.y = -200
		KB = false
	return null

func _on_idle_time_timeout() -> void:
	idleOver = true

func phase2start():
	print("hello")
	as2d.play("hit")
	if Global.camera.shaking:
		Global.camera.shaking = false
	dir = parent.global_position.x - Global.player.global_position.x
	if dir >= 0:
		dir = 1
	else:
		dir = -1
	KB = true
	await FadeS.fade_out()
	parent.phase2S = false
	parent.phase2 = true
	Global.startCutscene("res://dialogues/Hannibal.dialogue", "P2", "P2")
	await dialogue_manager.dialogue_ended
	
func freezeFrame(duration: float = 3.0) -> void:
	get_tree().paused = true
	await get_tree().create_timer(duration, true).timeout
	get_tree().paused = false
