extends CanvasLayer

@onready var balloon: Control = $Balloon
@onready var bars: bars = $bars

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.UI = self
