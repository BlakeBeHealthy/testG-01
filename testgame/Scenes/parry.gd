extends State
@onready var parry_time: Timer = $"../../parryTime"
@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var parry_zone: Area2D = $"../../ParryZone"
@onready var parry_cooldown: Timer = $"../../parryCooldown"
@onready var a2d2: Area2D = $"../../Area2D2"

var parried := false
var parryOver := false
var timeSlow := false
@export var hit_timeStop: float
@export var hit_duration: float
# Called when the node enters the scene tree for the first time.
func enter() -> void:
	parry_time.start()
	as2d.play("parry")
	parry_zone.monitorable = true
	parry_zone.monitoring = true
	parry_cooldown.start()

	
func exit() -> void:
	parent.parryCheck = false
	if !parry_time.is_stopped():
		parry_time.stop()
	parried = false
	parry_zone.monitorable = false
	parry_zone.monitoring = false
	
func process_frame(delta: float) -> State:
	if parent.takeHit:
		return parent.hit_state
		
	if parry_time.is_stopped():
		if parent.attackCheck:
			if parried:
				return parent.parryAttack_state
			else:
				return parent.attack_state
		elif parent.pogoCheck:
			return parent.pogo_state
		elif !parent.is_on_floor() and parent.velocity.y > 0:
			return parent.fall_state
		elif Input.is_action_just_pressed('jump') and parent.is_on_floor():
			return parent.jump_state
		elif Input.is_action_pressed('runL') or Input.is_action_pressed('runR'):
			return parent.run_state
		else:
			return parent.idle_state
	return null


func _on_parry_zone_area_entered(area: Area2D) -> void:
	parried = true
	parent.goodParry.emit()
	apply_timeSlow(hit_timeStop, hit_duration)


func _on_parry_time_timeout() -> void:
	parryOver = true
	
func process_physics(delta: float) -> State:
	var direction = Input.get_axis("runL","runR" )
	if !parent.is_on_floor():
		parent.velocity.x = direction * move_speed
	else:
		parent.velocity.x = 0
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	return null
	
func apply_timeSlow(timeScale: float, duration: float) -> void:
	if timeSlow:
		return
		
	timeSlow = true
	Engine.time_scale = timeScale
	await get_tree().create_timer(duration, false, false, true).timeout
	Engine.time_scale = 1.0
	timeSlow = false
