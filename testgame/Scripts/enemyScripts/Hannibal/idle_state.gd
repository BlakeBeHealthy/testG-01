extends HannibalState

@onready var idle_time: Timer = $"../../idleTime"
@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

var idleOver: bool
var cutCheck: bool
var KB: bool = false
var P2: bool = false
var t: Tween
var dir: float
var dialogue_manager = Engine.get_singleton("DialogueManager")

func enter() -> void:
	if parent.phase2S and !parent.phase2 and parent.healthCount <= 20 and !P2:
		parent.phase2S = false
		P2 = true
		cutCheck = true
		phase2start()
	elif !P2:
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
	if parent.phase2S and !parent.phase2 and parent.healthCount <= 20 and !P2:
		parent.phase2S = false
		P2 = true
		cutCheck = true
		phase2start()
		
	if Global.cutsceneStarted and !cutCheck:
		cutCheck = true
		
	if !Global.cutsceneStarted and cutCheck:
		cutCheck = false
		idleOver = false
		if parent.chase:
			parent.chase = false
		if parent.playerAbove:
			parent.playerAbove = false
		idle_time.start(1.3)
		
	if idleOver and !Global.cutsceneStarted and !cutCheck and !P2:
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
		parent.velocity.y = -30
		KB = false
	if P2:
		parent.move_and_slide()
	else:
		parent.velocity = Vector2(0, 0)
	return null

func _on_idle_time_timeout() -> void:
	idleOver = true

func phase2start():
	Global.inputBlocked = true
	Global.player.anim()
	
	if Global.camera.shaking:
		Global.camera.shaking = false
	dir = parent.global_position.x - Global.player.global_position.x
	
	if dir >= 0:
		dir = 1
		as2d.flip_h = true
	else:
		dir = -1
	as2d.play("hit")
	KB = true
	await freezeFrame()
	Engine.time_scale = 1.0
	if t:
		t.kill()
	t = create_tween()
	t.tween_property(Engine, "time_scale", 0.5, 0.7)
	await FadeS.fade_out(0.5, true)
	Engine.time_scale = 1.0
	if as2d.flip_h == true:
		as2d.flip_h = false
	await get_tree().create_timer(2.0, true, false, true).timeout
	Global.startCutscene("res://dialogues/Hannibal.dialogue", "P2", "P2")
	Global.inputBlocked = false
	as2d.play("idle")
	as2d.frame = 1
	as2d.stop()
	await dialogue_manager.dialogue_ended
	parent.phase2 = true
	P2 = false
	
func freezeFrame(duration: float = 0.3) -> void:
	get_tree().paused = true
	await get_tree().create_timer(duration, true, false, true).timeout
	get_tree().paused = false
