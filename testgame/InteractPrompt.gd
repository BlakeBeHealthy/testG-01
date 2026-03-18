extends Node2D

@onready var prompt: Label = $PanelContainer/MarginContainer/Label

var tween = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(prompt)
	self.scale = Vector2(0, 0)
	
func update_func(keybind):
	var events = InputMap.action_get_events(keybind)
	updateText(events)
	
func updateText(text):
	prompt.text = "E"

func showPrompt(keybind: String = "interact"):
	print("showPrompt called from: ", self)
	print(get_stack())
	print(keybind.length())
	if tween:
		tween.kill()
	print(keybind)
	tween = create_tween()
	update_func(keybind)
	self.visible = true
	tween.tween_property(self, "scale", Vector2(1, 1), 0.07)
	
func hidePrompt():
	print("hide")
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0, 0), 0.07)
	await tween.finished
	self.visible = false
