extends State

#I plan to add an attack three at some point

@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var a2d2: Area2D = $"../../Area2D2"
@onready var a2d: Area2D = $"../../Area2D"
@onready var ComboTime: Timer = $"../../Timer"
@onready var attack_delay: Timer = $"../../attackDelay"

@export var fall_state: State
@export var run_state: State
@export var idle_state: State
@export var hit_state: State
@export var jump_state: State
@export var att3_state: State
@export var hit_timeStop: float
@export var hit_duration: float
@export var decayRate := 0
@export var playerKnockback := 0


#I'm 90% one of these is useless lmao
var checkHit := true
var timeSlow := false
var checkAttack := false
var KB = false
var ComboCheck = false
var direction
var jumpBuff := 0
var attackDir := 0

func enter() -> void:
	as2d.play("a2")
	#Ensuring the player can't just spam attacks over and over again, however
		#I'm debating having the timer just start in the last combo move,
		#because if they do click in quick succession it will do the combo move so have attack
		#delay this is kinda useless, but you can test it if you feel like it.
	if !attack_delay.is_stopped():
		attack_delay.stop()
		
	attack_delay.start()
	attackDir = Input.get_axis("runL", "runR")
	checkAttack = false
	
	if checkHit:
		checkHit = false
		
	as2d.play("a2")
func _on_animated_sprite_2d_frame_changed() -> void:
	if as2d.animation != "a2":
		return
		
	if as2d.frame == 1:
		pass
		
	if as2d.frame == 3:
		a2d.monitorable = true
		a2d.monitoring = true
		parent.comboCount = 2
	if as2d.frame == 5:
		a2d.monitorable = false
		a2d.monitoring = false
func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	KB = true
	parent.velocity.x = -attackDir * playerKnockback
	apply_timeSlow(hit_timeStop, hit_duration)
	
func exit() -> void:
	KB = false
	checkHit = true
	a2d.monitorable = false
	a2d.monitoring = false
	attackDir = 0
	
func process_input(event: InputEvent) -> State:
	return null
# Decide state when attack animation ends
func process_frame(delta: float) -> State:
	if parent.takeHit:
		return hit_state
	
	if not as2d.is_playing() and !KB:
		if parent.is_on_floor():
			if Input.is_action_pressed("jump"):
				return jump_state
			
			if direction != 0:
				return run_state
				
			if direction == 0:
				return idle_state
		else:
			return fall_state
	return null
	
func process_physics(delta: float) -> State:
	direction = Input.get_axis("runL", "runR")
		
	if direction < 0:
		as2d.flip_h = true
		a2d.position.x = -21
	elif direction > 0:
		as2d.flip_h = false
		a2d.position.x = 21
	else:
		if as2d.flip_h:
			a2d.position.x = -21
		elif !as2d.flip_h:
			a2d.position.x = 21
			
	if KB: #This works here but not in the first attack, no idea why.
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

#Should have mentioned this, this is for hitstop
func apply_timeSlow(timeScale: float, duration: float) -> void:
	if timeSlow:
		return
		
	timeSlow = true
	Engine.time_scale = timeScale 
	await get_tree().create_timer(duration, false, false, true).timeout 
	Engine.time_scale = 1.0
	timeSlow = false
