extends Node2D

@onready var prompt: Label = $PanelContainer/MarginContainer/Label
var tween = null
var action: String = ""
var winA: String = ""
var loseA: String = ""
var DM3Check: String = ""
var lastPrompt: String = ""
var PlayerInAir = false
var showP := true
var win := false
var activeQTE := false
var resolved := false
var PD: Dictionary = {}
var promptTraits: Array = []
var events
var Pscale: Vector2
var keyCount: int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.prompt = self
	self.scale = Vector2(0, 0)
	Global.playerDone.connect(_on_player_ready)
	
func _on_player_ready():
	if !Global.player.inAir.is_connected(hidePromptJump):
		Global.player.inAir.connect(hidePromptJump)
	
func update_func(keybind: String):
	if keybind.is_empty():
		keybind = "interact"
	
	events = InputMap.action_get_events(keybind)
	
	if events.is_empty():
		updateText("?")
		return
		
	var text = OS.get_keycode_string(events[0].physical_keycode)
	updateText(text)
	
func updateText(text):
	prompt.text = text

func showPrompt(keybind: String = "interact", scaleP: Vector2 = Vector2(1, 1), position: Vector2 = Vector2(1, 1)):
	Pscale = scaleP
	if tween:
		tween.kill()
	tween = create_tween()
	update_func(keybind)
	self.visible = true
	if position != Vector2(1, 1):
		self.global_position = position
	tween.tween_property(self, "scale", Pscale, 0.05)
	
func hidePrompt():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0, 0), 0.05)
	await tween.finished
	self.visible = false
	
func hidePromptJump():
	PlayerInAir = true
	hidePrompt()
	
func QTE(act: String, position: Vector2 = Vector2(1,1), scale: Vector2 = Vector2(1, 1)) -> void:
	action = act
	showPrompt(act, scale, position)
	activeQTE = true
	win = false
	while !resolved and activeQTE:
		await get_tree().process_frame
	await hidePrompt()
	if resolved:
		resolved = false
	
	
func _input(event: InputEvent) -> void:
	if !activeQTE or !event.is_pressed() or event.is_echo():
		return
		
	if event.is_action(action):
		win = true
		Global.QTEBar.flashRight()
	else:
		win  = false
		Global.QTEBar.flashWrong()
	resolved = true
	activeQTE = false
	
func holdPrompt(key: String = "", PT: Array = [Vector2(0,0), Vector2(0,0)]):
	action = key
	PD[key] = PT

func startQTE(dur: float, anim: String, winAnim: String, LoseAnim: String, DM3Checkpoint: String, preAnim: String = "",):
	winA = winAnim
	loseA = LoseAnim
	DM3Check = DM3Checkpoint
	Global.ap.play(anim)
	Global.QTEBar.startBar(dur, action)
	while keyCount != PD.size():
		var key = PD.keys()[keyCount]
		var position = PD[key][0]
		var scale = PD[key][1]
		await QTE(key, position, scale)
		if win:
			keyCount += 1
		else:
			break
			
	action = ""
	PD.clear()
	keyCount = 0
	await QTEOutcome()
	
func QTEOutcome():
	if win:
		Global.ap.play(winA)
	else:
		Global.ap.play(loseA)
		
	await Global.ap.animation_finished
	await Global.UI.balloon.Resume(DM3Check)
	
