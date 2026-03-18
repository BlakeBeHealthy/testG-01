extends State
@onready var interact_area: Area2D = $"../../InteractArea"
@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

var done := false
var checkpoint := false
var speaking := false
var started := false

func enter() -> void:
	if parent.current_interactable is Checkpoint:
		checkpoint = true
	if parent.current_interactable is BetaNPC:
		speaking = true
		
func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	if checkpoint and !started:
		started = true
		parent.saving.emit(0)
		as2d.play("save1")
		
	if speaking:
		as2d.play("idle")
		parent.speaking.emit()
		
	if done:
		done = false
		return parent.idle_state
		
	return null
	
func _on_animated_sprite_2d_animation_finished() -> void:
	if as2d.animation == "save2":
		checkpoint = false
		done = true
	elif as2d.animation == "save1":
		parent.saving.emit(1)
		as2d.play("save2")
		
func process_physics(delta: float) -> State:
	return null
