extends Control

@onready var bar: ProgressBar = $PB
signal timeout
var action: String = ""

func _ready() -> void:
	Global.QTEBar = self

func startBar(duration: float, act: String) -> void:
	action = act
	bar.max_value = 100.0
	bar.value = 100.0
	visible = true
	var t = create_tween()
	t.tween_property(bar, "value", 0.0, duration)
	await t.finished
	visible = false
	timeout.emit()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed(action) and visible:
		visible = false
