extends Control

@onready var bar: ProgressBar = $QTE
signal timeout
var action: String = "jump"
var currentQTEbind: String = ""
var active: bool = false
var t: Tween
var tw: Tween

func startBar(duration: float, act: String) -> void:
	action = act
	bar.max_value = 100.0
	bar.value = 100.0
	visible = true
	if t:
		t.kill()
	t = create_tween()
	t.tween_property(bar, "value", 0.0, duration)
	await t.finished
	timeout.emit()
	t.kill()
	bar.value = 100.0
	
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed(action) and visible and (currentQTEbind == action)) or bar.value == 0.0:
		self.visible = false
		
func flashWrong() -> void:
	if t:
		t.kill()
	t = create_tween()
	t.tween_property(bar, "modulate", Color("bf352cff"), 0.1)
	await t.finished
	if t:
		t.kill()
	t = create_tween()
	t.tween_property(bar, "modulate", Color("dfa031"), 0.1)
	await t.finished
	print("visible")
	self.visible = false
	
func flashRight() -> void:
	if tw:
		tw.kill()
	tw = create_tween()
	tw.tween_property(bar, "modulate", Color("86c544ff"), 0.05)
	await tw.finished
	
	if tw:
		tw.kill()
	tw = create_tween()
	tw.tween_property(bar, "modulate", Color("ffffffff"), 0.15)
	await tw.finished
	
func setQTEBind(act: String):
	currentQTEbind = act
	
