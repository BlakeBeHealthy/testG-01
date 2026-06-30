extends State
@onready var interact_area: Area2D = $"../../InteractArea"
@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

var done := false
var checkpoint := false
var smallKB := false
var speaking := false
var dialogueActive := false
var started := false
var resource := ""
var title := ""
var dialogue_manager = Engine.get_singleton("DialogueManager")

func enter() -> void:
	if parent.a2d2.monitorable:
		parent.a2d2.monitorable = false
		parent.a2d2.monitorable = false
		
	if parent.current_interactable is Checkpoint:
		checkpoint = true
	elif parent.current_interactable is BetaNPC or Global.cutsceneStarted:
		print("1")
		speaking = true
	elif !parent.animate:
		parent.camLook = true
		
func exit() -> void:
	print("5")
	dialogueActive = false
	speaking = false
	done = false
	checkpoint = false
	started = false
	if !parent.a2d2.monitorable:
		parent.a2d2.monitorable = true
		parent.a2d2.monitorable = true
	
func process_input(event: InputEvent) -> State:
	return null
	
func _on_dialogue_done():
	if !dialogueActive:
		return
	
	print("2")
	dialogueActive = false
	await get_tree().create_timer(0.4).timeout
	done = true
	parent.speaking.emit(0)
	
func process_frame(delta: float) -> State:
	if parent.cutDeath:
		return parent.death_state
	
	if parent.animate and !Global.cutsceneStarted:
		return null
	elif Global.cutsceneStarted and !dialogueActive:
		speaking = true
	elif !Global.cutsceneStarted and dialogueActive:
		_on_dialogue_done()
		
	if checkpoint and !started:
		started = true
		parent.saving.emit(0)
		as2d.play("save1")
		
	if speaking:
		print("3")
		speaking = false
		as2d.play("idle")
		if Global.cutsceneStarted:
			as2d.frame = 1
			as2d.stop()
		dialogueActive = true
		parent.speaking.emit(1)
		
	if parent.camLook:
		if !Input.is_action_pressed("PlayerLock"):
			parent.camLook = false
			done = true
		
	if done and !Global.cutsceneStarted:
		print("4")
		started = false
		done = false
		return parent.idle_state
		
	return null
	
func _on_animated_sprite_2d_animation_finished() -> void:
	if as2d.animation == "save2":
		checkpoint = false
		done = true
		parent.saving.emit(2)
	elif as2d.animation == "save1":
		parent.saving.emit(1)
		as2d.play("save2")
		
func process_physics(delta: float) -> State:
	if parent.animate:
		if !parent.is_on_floor():
			as2d.play("fall")
			parent.velocity.y = (gravity * 1.5) * delta 
			if !smallKB:
				parent.velocity.x += -parent.direction * 12
				smallKB = true
			parent.move_and_slide()
		else:
			smallKB = false
			as2d.play("idle")
		
	return null
	
