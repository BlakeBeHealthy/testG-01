class_name balloon extends Control

@onready var as2d: AnimatedSprite2D = $HBoxContainer/Control/AnimatedSprite2D
@onready var dialogue_label: DialogueLabel = $HBoxContainer/MarginContainer/Panel/MarginContainer/DialogueLabel
@onready var color_rect: ColorRect = $ColorRect
@onready var charName: Label = $HBoxContainer/MarginContainer/Panel/MarginContainer2/Label
@onready var dialogue_responses_menu: DialogueResponsesMenu = $Panel/MarginContainer/DialogueResponsesMenu
@onready var responsePanel: Panel = $Panel

@onready var portraitM: ShaderMaterial = $HBoxContainer/Control/AnimatedSprite2D.material
@onready var panelM: ShaderMaterial = $HBoxContainer/MarginContainer/Panel.material
var lastShownLine: DialogueLine = null

var debugCount = 0
var game_states
var tween = null
var dialogueResource: DialogueResource:
	set(value):
		if value == null:
			print("DIALOGUE SET TO NULL: ", get_stack())
		dialogueResource = value
var dRec: DialogueResource
var check := false
var responses_visible := false
var wiped : bool = false
var animEnd : bool = false
var response_tween = null
var overlay_tween = null
var isMoving := false
var dialogue_ended := false
var waiting_for_line := false
var current_line: DialogueLine:
	set(value):
		if value:
			current_line = value
		elif !Global.cutsceneStarted:
			dialogue_label.text = ""
			if is_instance_valid(dialogue_label):
				if dialogue_label.is_typing:
					dialogue_label.skip_typing()
				dialogue_label.modulate.a = 0
				dialogue_label.text = ""
			dialogue_ended = true
			if !animEnd:
				await wipeOut()
				if overlay_tween:
					overlay_tween.kill()
				overlay_tween = create_tween()
				overlay_tween.tween_property(color_rect, "modulate:a", 0.0, 0.3)
				await overlay_tween.finished
			self.visible = false
			check = false
			currentSpeaker = ""
			
var speed = 0.05:
	set(value):
		speed = value
		dialogue_label.seconds_per_step = value
			
var currentSpeaker = ""
# Called when the node enters the scene tree for the first time.
	
func start(resource: DialogueResource, title: String) -> void:
	if resource != null:
		dRec = resource
	dialogueResource = resource
	if dialogueResource == null:
		dialogueResource = dRec
	dialogue_ended = false
	dialogue_responses_menu.next_action = "interact"
	dialogue_label.modulate.a = 0
	charName.modulate.a = 0
	portraitM.set_shader_parameter("progress", -0.2)
	panelM.set_shader_parameter("progress", -0.2)
	game_states = [self]
	color_rect.modulate.a = 0
	if overlay_tween:
		overlay_tween.kill()
	overlay_tween = create_tween()
	overlay_tween.tween_property(color_rect, "modulate:a", 0.6, 0.3)
	self.visible = true
	if dialogueResource == null:
		dialogueResource = dRec
	current_line = await dialogueResource.get_next_dialogue_line(title, game_states)
	if current_line:
		apply_dialogue_line()
	if dialogue_responses_menu.response_selected.is_connected(_on_response_selected):
		dialogue_responses_menu.response_selected.disconnect(_on_response_selected)
	dialogue_responses_menu.response_selected.connect(_on_response_selected)

func apply_dialogue_line():
	if current_line == lastShownLine:
		return
	lastShownLine = current_line
	if Global.inputBlocked:
		return
		
	dialogue_label.visible_ratio = 0
	print("CALL #", debugCount, ": ", current_line.text)
	debugCount += 1
	if current_line.character != currentSpeaker:
		if check:
			await wipeOut()
		else:
			check = true
		
		var mood = "idle"
		currentSpeaker = current_line.character
		as2d.play(currentSpeaker + "_" + mood)
		dialogue_label.modulate.a = 0
		dialogue_label.visible_ratio = 0
		charName.text = current_line.character
		dialogue_label.visible_characters = 0
		await wipeIn()
		if responses_visible:
			if response_tween:
				response_tween.kill()
			response_tween = create_tween()
			await response_tween.tween_property(responsePanel, "modulate:a", 0.0, 0.2).finished
			responses_visible = false
			responsePanel.hide()
			
	dialogue_label.dialogue_line = current_line
	dialogue_label.visible_characters = 0
	dialogue_label.type_out()
	
	await dialogue_label.finished_typing
	show_responses()
	isMoving = false
	
func next(next_id: String) -> void:
	waiting_for_line = true
	if dialogue_label.is_typing:
		dialogue_label.skip_typing()
	current_line = await dialogueResource.get_next_dialogue_line(next_id, game_states)
	if current_line:
		apply_dialogue_line()
	waiting_for_line = false
	
func _on_response_selected(response: DialogueResponse) -> void:
	next(response.next_id)
	
func _input(event: InputEvent) -> void:
	if current_line == null or isMoving or dialogue_ended or waiting_for_line \
	or Global.inputBlocked:
		return
		
	if responses_visible and !dialogue_label.is_typing:
		if event.is_action_pressed("dialogueSkip"):
			get_viewport().set_input_as_handled()
		return
		
	if Input.is_action_just_pressed("dialogueSkip"):   
		if dialogue_label.is_typing:
			dialogue_label.skip_typing()
		else:
			next(current_line.next_id)

func wipeIn():
	wiped = true
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
	return

func wipeOut(fullWipe: bool = false):
	wiped = false
	isMoving = true
	
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_parallel(true)
	if responses_visible:
		if response_tween:
			response_tween.kill()
		tween.tween_property(responsePanel, "modulate:a", 0.0, 0.1)
		responses_visible = false
		
	tween.tween_property(dialogue_label, "modulate:a", 0.0, 0.1)
	tween.tween_property(charName, "modulate:a", 0.0, 0.1)
	tween.set_parallel(false)
	tween.tween_method(func(val): panelM.set_shader_parameter("progress", val), 1.2, -0.2, 0.15)
	tween.tween_interval(0.2)
	tween.tween_method(func(val): portraitM.set_shader_parameter("progress", val), 1.2, -0.2, 0.15)
	if animEnd:
		tween.tween_property(color_rect, "modulate:a", 0.0, 0.3)
	await tween.finished
	return

func show_responses():
	if current_line.responses.size() > 0:
		responses_visible = true
		dialogue_responses_menu.responses = current_line.responses
		dialogue_responses_menu.add_theme_constant_override("separation", 100)
		responsePanel.modulate.a = 0
		responsePanel.show()
		
		if response_tween:
			response_tween.kill()
		response_tween = create_tween()
		response_tween.tween_interval(0.4)
		response_tween.tween_property(responsePanel, "modulate:a", 1.0, 0.3)
	else:
		responsePanel.hide()
		responses_visible = false
		
func playResume(animation: String = "",  waitForFlag: bool = false) -> void:
	Global.inputBlocked = true
	dialogue_label.text = ""
	if is_instance_valid(dialogue_label):
		if dialogue_label.is_typing:
			dialogue_label.skip_typing()
		dialogue_label.modulate.a = 0
		dialogue_label.text = ""
	if wiped:
		await wipeOut()
	if overlay_tween:
		overlay_tween.kill()
	overlay_tween = create_tween()
	await overlay_tween.tween_property(color_rect, "modulate:a", 0.0, 0.3)
	if animation != "":
		Global.ap.play(animation)
		await Global.ap.animation_finished
	if waitForFlag:
		pass
	else:
		Global.inputBlocked = false
		await Resume()
		
func Resume(jump: String = ""):
		if overlay_tween:
			overlay_tween.kill()
		overlay_tween = create_tween()
		await overlay_tween.tween_property(color_rect, "modulate:a", 0.6, 0.2)
		check = false
		currentSpeaker = ""
		Global.inputBlocked = false
		dialogue_label.text = ""
		current_line = await dialogueResource.get_next_dialogue_line(jump, game_states)
		if current_line:
			wipeIn()
		else:
			apply_dialogue_line()
func playEnd(animation: String) -> void:
	animEnd = true
	if wiped:
		await wipeOut()
	Global.ap.play(animation)
	await Global.ap.animation_finished
	
	
