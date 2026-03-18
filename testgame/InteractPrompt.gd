extends Node2D

@onready var prompt: Label = $PanelContainer/MarginContainer/Label

var tween = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.scale = Vector2(0, 0)
	
func update_func(keybind):
	var events = InputMap.action_get_events(keybind)
	var text = OS.get_keycode_string(events[0].physical_keycode)
	updateText(text)
	
func updateText(text):
	prompt.text = text

func showPrompt(keybind: String = "interact"):
	if tween:
		tween.kill()
	tween = create_tween()
	update_func(keybind)
	self.visible = true
	tween.tween_property(self, "scale", Vector2(1, 1), 0.07)
	
func hidePrompt():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0, 0), 0.07)
	await tween.finished
	self.visible = false
