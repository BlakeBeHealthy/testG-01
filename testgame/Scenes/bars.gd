class_name bars extends Control


@onready var top_bar: ColorRect = $topBar
@onready var bottom_bar: ColorRect = $bottomBar
var barsActive: bool = false
	
func _ready() -> void:
	self.visible = true
	
func moveBars(dur: float = 0.3, stayOpen: bool = false):
	print("bars ", barsActive)
	print("stay ", stayOpen)
	var t = create_tween()
	t.set_trans(Tween.TRANS_SINE)
	t.set_ease(Tween.EASE_IN_OUT)
	t.set_parallel(true)
	
	if stayOpen and barsActive:
		return 
	else:
		if barsActive:
			t.tween_property(top_bar, "position:y", (top_bar.position.y - top_bar.size.y), dur)
			t.tween_property(bottom_bar, "position:y", (bottom_bar.position.y + bottom_bar.size.y), dur)
		elif !barsActive:
			t.tween_property(top_bar, "position:y", (top_bar.position.y + top_bar.size.y), dur)
			t.tween_property(bottom_bar, "position:y", (bottom_bar.position.y - bottom_bar.size.y), dur)

		barsActive = !barsActive
