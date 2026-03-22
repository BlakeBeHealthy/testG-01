extends Control

@onready var as2d: AnimatedSprite2D = $HBoxContainer/Control/AnimatedSprite2D
@onready var dialogue_label: DialogueLabel = $HBoxContainer/MarginContainer/Panel/MarginContainer/DialogueLabel
@onready var dialogue_responses_menu: DialogueResponsesMenu = $DialogueResponsesMenu
@onready var color_rect: ColorRect = $ColorRect
@onready var charName: Label = $HBoxContainer/MarginContainer/Panel/MarginContainer2/Label

@onready var portraitM: ShaderMaterial = $HBoxContainer/Control/AnimatedSprite2D.material
@onready var panelM: ShaderMaterial = $HBoxContainer/MarginContainer/Panel.material

var game_states
var tween = null
var dialogueResource
var dialogue_line: DialogueLine:
	set(value):
		if value:
			dialogue_line = value
			apply_dialogue_line()
		else:
			# dialogue finished
			queue_free()
			
var speed = 0.05:
	set(value):
		speed = value
		dialogue_label.seconds_per_step = value
			
var currentSpeaker = ""
# Called when the node enters the scene tree for the first time.
func start(resource: DialogueResource, title: String) -> void:
	dialogueResource = resource
	portraitM.set_shader_parameter("progress", -0.2)
	panelM.set_shader_parameter("progress", -0.2)
	game_states = [self]
	self.visible = true
	dialogue_line = await resource.get_next_dialogue_line(title, game_states)

func apply_dialogue_line():
	if dialogue_line.character != currentSpeaker:
		var mood = "idle"
		currentSpeaker = dialogue_line.character
		as2d.play(currentSpeaker + "_" + mood)
		await wipeIn()
		charName.text = dialogue_line.character
		
	dialogue_label.dialogue_line = dialogue_line
	dialogue_label.type_out()
	
func next(next_id: String) -> void:
	dialogue_line = await dialogueResource.get_next_dialogue_line(next_id, game_states)
	
func _input(event: InputEvent) -> void:
	if dialogue_line == null:
		return
		
	if Input.is_action_just_pressed("dialogueSkip") or Input.is_action_just_pressed("leftC"):
		if dialogue_label.is_typing:
			dialogue_label.skip_typing()
		else:
			next(dialogue_line.next_id)

func wipeIn():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_method(func(val): portraitM.set_shader_parameter("progress", val), -0.2, 1.2, 0.4)
	tween.tween_interval(0.2)
	tween.tween_method(func(val): panelM.set_shader_parameter("progress", val), -0.2, 1.2, 0.4)
	tween.tween_property(dialogue_label, "modulate:a", 1.0, 0.1)
	tween.tween_property(charName, "modulate:a", 1.0, 0.1)

func wipeOut():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_method(func(val): panelM.set_shader_parameter("progress", val), 1.2, -0.2, 0.4)
	tween.tween_property(dialogue_label, "modulate:a", 0.0, 0.1)
	tween.tween_property(charName, "modulate:a", 0.0, 0.1)
	tween.tween_interval(0.2)
	tween.tween_method(func(val): portraitM.set_shader_parameter("progress", val), 1.2, -0.2, 0.4)
	await tween.finished
	return
