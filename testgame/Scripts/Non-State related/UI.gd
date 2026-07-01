extends CanvasLayer

@onready var balloon: Control = $Balloon
@onready var bars: bars = $bars
@onready var as2d: AnimatedSprite2D = $AnimatedSprite2D

var playAs2d: bool = false

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
