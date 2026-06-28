extends Camera2D

@export var FOLLOW_SPEED := 10.0
@export var boss_room := false
var boss_room_placement: Vector2
var default_position: Vector2
var default_zoom: Vector2
var horizontalOffset: float = 20
var verticalOffset: float = 30
var voffset: float = 80

var shake_strength := 0.0
var shaking := false
var offsetting :bool = false
var move_tween: Tween
var currentOffset := 0.0
var target: Vector2 = Vector2()


@onready var shake_timer: Timer = Timer.new()
	
func _ready():
	default_zoom = self.zoom
	print(default_zoom)
	default_position = global_position
	print(default_position)
	Global.set_camera(self)
	boss_room_placement = self.global_position
	#Could've made a new scene but just used code, so the screenshake wont 
		#be slower if we slow down time in the engine and it doesnt repeat
	shake_timer.one_shot = true
	shake_timer.ignore_time_scale = true
	add_child(shake_timer)
	shake_timer.timeout.connect(_on_shake_timeout)
	Global.shakeDone.connect(_on_shake_timeout)

func _process(delta):
	if !is_instance_valid(Global.player):
		return
		
	var weight = 1 - exp(-FOLLOW_SPEED * delta)
	currentOffset = lerp(currentOffset, float(Global.player.direction), weight)
	if !offsetting:
		if !boss_room:
			if Global.player.camLook == true:
				if Input.is_action_pressed("down") and !Input.is_action_pressed("up"):
					target = Vector2(Global.player.global_position.x + (horizontalOffset * currentOffset), \
					Global.player.global_position.y - verticalOffset + (voffset + 20))
				elif Input.is_action_pressed("up") and !Input.is_action_pressed("down"):
					target = Vector2(Global.player.global_position.x + (horizontalOffset * currentOffset), \
					Global.player.global_position.y - verticalOffset - voffset)
				else:
					target = Vector2(Global.player.global_position.x + (horizontalOffset * currentOffset), \
					Global.player.global_position.y - verticalOffset)
			else:
				target = Vector2(Global.player.global_position.x + (horizontalOffset * currentOffset), \
				Global.player.global_position.y - verticalOffset)
		else:
			target = boss_room_placement
		self.global_position = round(self.global_position.lerp(target, weight))
	
	
	if shaking:
		offset = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)

func start_shake(strength: float, duration: float = 0):
	shake_strength = strength
	shaking = true
	if duration != 0:
		shake_timer.start(duration)

func _on_shake_timeout():
	shake_end()
	
func shake_end():
	shaking = false
	offset = Vector2.ZERO
	
func move(new_position: Vector2 = default_position, \
	new_zoom: Vector2 = default_zoom, duration: float = 1.0, time_scale: float = 0.0):
	if move_tween:
		move_tween.kill()
	offsetting = true
	move_tween = create_tween()
	move_tween.set_trans(Tween.TRANS_SINE)
	move_tween.set_ease(Tween.EASE_IN_OUT)
	move_tween.set_parallel(true)
	move_tween.tween_property(self, "global_position", new_position, duration)
	move_tween.tween_property(self, "zoom", new_zoom, duration)
	if time_scale != 0.0:
		move_tween.tween_property(Engine, "time_scale", time_scale, duration)

func reset(duration):
	move(default_position, default_zoom, duration, 1.0)

func APmove():
	offsetting = true
	
func startBars(dur: float = 0.3, stayOpen: bool = false):
	Global.UI.bars.moveBars(dur, stayOpen)
	
func fade_in(speed: float = 1.0, wait = false):
	FadeS.fade_in(speed, wait)
	
func fade_out(speed: float = 1.0, wait = false):
	FadeS.fade_out(speed, wait)
