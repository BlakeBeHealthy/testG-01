extends CanvasLayer

@onready var balloon: Control = $Balloon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.UI = self


func fade_in(speed: float = 1.0):
	FadeS.fade_in(speed)
	
func fade_out(speed: float = 1.0):
	FadeS.fade_out(speed)
