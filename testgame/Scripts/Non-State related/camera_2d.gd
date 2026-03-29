extends Camera2D

@export var FOLLOW_SPEED := 0.0

var shake_strength := 0.0
var shaking := false
var currentOffset := 0.0
var target: Vector2 = Vector2()
var horizontalOffset: float = 60
var verticalOffset: float = 40

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
	var weight = 1 - exp(-FOLLOW_SPEED * delta)
	currentOffset = lerp(currentOffset, float(Global.player.direction), weight)
	print(Global.player.direction)
	target = Vector2(Global.player.global_position.x + (horizontalOffset * currentOffset), \
	Global.player.global_position.y - verticalOffset)
	
	self.global_position = round(self.global_position.lerp(target, weight))
	
	
	
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
