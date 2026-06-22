extends HannibalState

@onready var idle_time: Timer = $"../../idleTime"
@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

var idleOver: bool
var cutCheck: bool
var KB: bool = false
var t: Tween
var dir: float

func enter() -> void:
	idleOver = false
	if parent.phase2S:
		phase2start()
		return
	else:
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
		cutCheck = false
		idle_time.start(1.3)
		
	if parent.phase2S:
		return null
		
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
	if KB:
		parent.velocity.x = 10 * dir
		parent.velocity.y = -50
		KB = false
	return null

func _on_idle_time_timeout() -> void:
	idleOver = true

func phase2start():
	as2d.play("hit")
	
	dir = parent.global_position.x - Global.player.global_position.x
	if dir >= 0:
		dir = 1
	else:
		dir = -1
	await freezeFrame()
	Engine.time_scale = 1.0
	KB = true
	if t:
		t.kill()
	t = create_tween()
	t.tween_property(Engine, "time_scale", 0.2, 0.4)
	await get_tree().create_timer(0.35, true).timeout
	FadeS.fade_out()
	Global.startCutscene("res://dialogues/Hannibal.dialogue", "P2", "phase2S")
	
func freezeFrame(duration: float = 0.08) -> void:
	get_tree().paused = true
	await get_tree().create_timer(duration, true).timeout
	get_tree().paused = false
