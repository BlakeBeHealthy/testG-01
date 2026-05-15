extends StaticBody2D

@onready var as2d: AnimatedSprite2D = $as2d
@onready var C2: CollisionShape2D = $CollisionShape2D

@export var fliph: bool = false
@export var closed: bool = false

var open: bool = true

func _ready() -> void:
	C2.disabled = true
	
	if closed:
		playOpenClose()
		
	if !Global.DoorChange.is_connected(playOpenClose):
		Global.DoorChange.connect(playOpenClose)
	
	if fliph:
		as2d.flip_h = true
		C2.position.x = -10
	else:
		as2d.flip_h = false
		C2.position.x = 2
		
func playOpenClose() -> void:
	open = !open
	if !open:
		as2d.play("Close")
		C2.disabled = false
	else:
		as2d.play("Open")
		C2.disabled = true

func gateSignal():
	Global.DoorChange.emit()
