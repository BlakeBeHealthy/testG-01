extends Camera2D

var shake_strength := 0.0
var shaking := false

@onready var shake_timer: Timer = Timer.new()

func _ready():
	Global.set_camera(self)
	#Could've made a new scene but just used code, so the screenshake wont 
		#be slower if we slow down time in the engine and it doesnt repeat
	shake_timer.one_shot = true
	shake_timer.ignore_time_scale = true
	add_child(shake_timer)
	shake_timer.timeout.connect(_on_shake_timeout)

func _process(delta):
	#Starting the shake
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
