extends State

#I plan to add an attack three at some point
@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var a2d2: Area2D = $"../../Area2D2"
@onready var a2d: Area2D = $"../../Area2D"
@onready var ComboTime: Timer = $"../../Timer"
@onready var attack_delay: Timer = $"../../attackDelay"

@export var hit_timeStop: float
@export var hit_duration: float
@export var decayRate := 0
@export var playerKnockback := 0


#I'm 90% one of these is useless lmao

var checkHit := true
var startKB := false
var hit := false
var timeSlow := false
var checkAttack := false
var KB = false
var jumpBuff := false
var attackDir := 0

func enter() -> void:
	as2d.play("parryAtt")
	parent.attack_delay.start()
	if parent.parried:
		parent.parried = false
	attackDir = Input.get_axis("runL", "runR")
	if attackDir > 0:
		as2d.flip_h = false
	elif attackDir < 0:
		as2d.flip_h = true
	startKB = false
	if checkHit:
		checkHit = false
				
func _on_animated_sprite_2d_frame_changed() -> void:
	if as2d.animation != "parryAtt" or parent.takeHit:
		return
		
	if as2d.frame == 3:
		a2d.monitorable = true
		a2d.monitoring = true
	if as2d.frame == 6:
		a2d.monitorable = false
		a2d.monitoring = false
		
func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if parent.state_machine.current_state != parent.attack_state:
		pass
		
	startKB = true
	apply_timeSlow(hit_timeStop, hit_duration)

func exit() -> void:
	checkHit = true
	a2d.monitorable = false
	a2d.monitoring = false
	attackDir = 0
	KB = false
	
func process_input(event: InputEvent) -> State:
	return null
# Decide state when attack animation ends
func process_frame(delta: float) -> State:
	var direction = Input.get_axis("runL", "runR")
	if parent.takeHit:
		return parent.hit_state
	
	if !as2d.is_playing() and !KB and !timeSlow:
		if parent.parryCheck:
			return parent.parry_state
		elif parent.attackCheck:
			return parent.att2_state
		if parent.dash:
			return parent.dash_state
		if parent.is_on_floor():
			if Input.is_action_pressed("jump"):
				jumpBuff = 0
				return parent.jump_state
			
			if direction != 0:
				return parent.run_state
				
			if direction == 0:
				return parent.idle_state
		else:
			return parent.fall_state
		
	return null
	
func process_physics(delta: float) -> State:
	var direction = Input.get_axis("runL","runR" )
		
	if startKB:
		parent.velocity.x += -attackDir * playerKnockback
		startKB = false
		KB = true
	elif KB:
		parent.velocity.x = move_toward(parent.velocity.x, 0, decayRate * delta)
		if parent.velocity.x == 0:
			KB = false
	else:
		if direction != 0:
			parent.velocity.x = direction * move_speed
		elif direction == 0:
			parent.velocity.x *= 0
			
	if Input.is_action_pressed("jump") and !parent.jumpCheck:
		parent.jumpCheck = true
		parent.velocity.y = -parent.JUMP
	elif Input.is_action_just_released("jump") and !parent.is_on_floor():
		parent.velocity.y *= parent.jumpCut
	else:
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
