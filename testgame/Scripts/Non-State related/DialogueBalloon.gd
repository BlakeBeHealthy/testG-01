extends Control

@onready var as2d: AnimatedSprite2D = $HBoxContainer/Control/AnimatedSprite2D
@onready var dialogue_label: DialogueLabel = $HBoxContainer/MarginContainer/Panel/MarginContainer/DialogueLabel
@onready var color_rect: ColorRect = $ColorRect
@onready var charName: Label = $HBoxContainer/MarginContainer/Panel/MarginContainer2/Label
@onready var dialogue_responses_menu: DialogueResponsesMenu = $MarginContainer/DialogueResponsesMenu

@onready var portraitM: ShaderMaterial = $HBoxContainer/Control/AnimatedSprite2D.material
@onready var panelM: ShaderMaterial = $HBoxContainer/MarginContainer/Panel.material

var game_states
var tween = null
var dialogueResource
var check := false
var isMoving := false
var dialogue_line: DialogueLine:
	set(value):
		if value:
			dialogue_line = value
			apply_dialogue_line()
		else:
			await wipeOut()
			self.visible = false
			check = false
			currentSpeaker = ""
			
var speed = 0.05:
	set(value):
		speed = value
		dialogue_label.seconds_per_step = value
			
var currentSpeaker = ""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dialogue_responses_menu.add_theme_constant_override("separation", 100)
	
func start(resource: DialogueResource, title: String) -> void:
	dialogue_label.modulate.a = 0
	charName.modulate.a = 0
	dialogueResource = resource
	portraitM.set_shader_parameter("progress", -0.2)
	panelM.set_shader_parameter("progress", -0.2)
	game_states = [self]
	self.visible = true
	dialogue_line = await resource.get_next_dialogue_line(title, game_states)

func apply_dialogue_line():
	if dialogue_line.character != currentSpeaker:
		if check:
			await wipeOut()
		else:
			check = true
			
		var mood = "idle"
		currentSpeaker = dialogue_line.character
		as2d.play(currentSpeaker + "_" + mood)
		dialogue_label.modulate.a = 0
		dialogue_label.visible_ratio = 0
		charName.text = dialogue_line.character
		await wipeIn()
		
	dialogue_label.dialogue_line = dialogue_line
	dialogue_label.type_out()
	
	await dialogue_label.finished_typing
	if dialogue_line.responses.size() > 0:
		dialogue_responses_menu.responses = dialogue_line.responses
		dialogue_responses_menu.add_theme_constant_override("separation", 100)
		dialogue_responses_menu.show()
	else:
		dialogue_responses_menu.hide()
	
func next(next_id: String) -> void:
	dialogue_line = await dialogueResource.get_next_dialogue_line(next_id, game_states)
	
func _input(event: InputEvent) -> void:
	if dialogue_line == null or isMoving:
		return
	
	if Input.is_action_just_pressed("dialogueSkip") or Input.is_action_just_pressed("leftC"):
		if dialogue_label.is_typing:
			dialogue_label.skip_typing()
		else:
			next(dialogue_line.next_id)

func wipeIn():
	isMoving = true
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_interval(0.2)
	tween.tween_method(func(val): portraitM.set_shader_parameter("progress", val), -0.2, 1.2, 0.4)
	tween.tween_interval(0.2)
	tween.tween_method(func(val): panelM.set_shader_parameter("progress", val), -0.2, 1.2, 0.15)
	tween.tween_property(charName, "modulate:a", 1.0, 0.1)
	tween.tween_interval(0.2)
	tween.tween_property(dialogue_label, "modulate:a", 1.0, 0.1)
	await tween.finished
	isMoving = false
	return

func wipeOut():
	isMoving = true
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(dialogue_label, "modulate:a", 0.0, 0.1)
	tween.tween_property(charName, "modulate:a", 0.0, 0.1)
	tween.tween_method(func(val): panelM.set_shader_parameter("progress", val), 1.2, -0.2, 0.15)
	tween.tween_interval(0.2)
	tween.tween_method(func(val): portraitM.set_shader_parameter("progress", val), 1.2, -0.2, 0.15)
	await tween.finished
	isMoving = false
	return
