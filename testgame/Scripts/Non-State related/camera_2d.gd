extends Camera2D

var shake_strength := 0.0
var shaking := false

@onready var shake_timer: Timer = Timer.new()

func _ready():
	Global.set_camera(self)
	
	shake_timer.one_shot = true
	shake_timer.ignore_time_scale = true
	add_child(shake_timer)
	shake_timer.timeout.connect(_on_shake_timeout)

func _process(delta):
	if shaking:
		offset = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)

func start_shake(strength: float, duration: float):
	shake_strength = strength
	shaking = true
	shake_timer.start(duration)

func _on_shake_timeout():
	shaking = false
	offset = Vector2.ZERO
