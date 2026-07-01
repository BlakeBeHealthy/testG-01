extends CanvasLayer

@onready var balloon: Control = $Balloon
@onready var bars: bars = $bars
@onready var as2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var top_bar: ColorRect = $topBar
@onready var bottom_bar: ColorRect = $bottomBar

var playAs2d: bool = false
var barsActive: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.UI = self
	
func keyPlay():
	if !playAs2d:
		print("hello")
		as2d.visible = true
		as2d.play("space")
	else:
		as2d.stop()
		as2d.visible = false
	playAs2d = !playAs2d


func moveBars(dur: float = 0.3, stayOpen: bool = false, wait: bool = false):
	print(stayOpen)
	print(wait)
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
			await t.finished
			top_bar.visible = true
			bottom_bar.visible = true
		elif !barsActive:
			top_bar.visible = true
			bottom_bar.visible = true
			t.tween_property(top_bar, "position:y", (top_bar.position.y + top_bar.size.y), dur)
			t.tween_property(bottom_bar, "position:y", (bottom_bar.position.y - bottom_bar.size.y), dur)
			
	barsActive = !barsActive
