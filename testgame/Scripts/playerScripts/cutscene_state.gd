extends State
@onready var interact_area: Area2D = $"../../InteractArea"
@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

var done := false
var checkpoint := false
var speaking := false
var dialogueActive := false
var started := false
var resource := ""
var title := ""
var dialogue_manager = Engine.get_singleton("DialogueManager")

func enter() -> void:
	if !dialogue_manager.dialogue_ended.is_connected(_on_dialogue_ended):
		dialogue_manager.dialogue_ended.connect(_on_dialogue_ended)
		
	if parent.current_interactable is Checkpoint:
		checkpoint = true
	elif parent.current_interactable is BetaNPC or Global.cutsceneStarted:
		speaking = true
	else:
		parent.camLook = true
		
func exit() -> void:
	dialogueActive = false
	speaking = false
	done = false
	checkpoint = false
	started = false
	
func process_input(event: InputEvent) -> State:
	return null
	
func _on_dialogue_ended(_resource: DialogueResource):
	if !dialogueActive:
		return
		
	speaking = false
	await get_tree().create_timer(0.4).timeout
	done = true
	parent.speaking.emit(0)
	
func process_frame(delta: float) -> State:
	if checkpoint and !started:
		started = true
		parent.saving.emit(0)
		as2d.play("save1")
		
	if speaking:
		speaking = false
		as2d.play("idle")
		dialogueActive = true
		parent.speaking.emit(1)
		
	if parent.camLook:
		if !Input.is_action_pressed("PlayerLock"):
			parent.camLook = false
			done = true
		
	if done:
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
	return null
	
