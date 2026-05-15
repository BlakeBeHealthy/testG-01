extends State

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
var timeSlow := false
var checkAttack := false
var KB = false
var startKB := false
var ComboCheck = false
var worldHit := false
var direction := 0
var jumpBuff := 0
var attackDir := 0

func enter() -> void:
	attack_delay.start()
	as2d.play("a2")
	if !ComboTime.is_stopped():
		ComboTime.stop()
	#Ensuring the player can't just spam attacks over and over again, however
		#I'm debating having the timer just start in the last combo move,
		#because if they do click in quick succession it will do the combo move so have attack
		#delay this is kinda useless, but you can test it if you feel like it.
	checkAttack = false
	
	if checkHit:
		checkHit = false
		
func _on_animated_sprite_2d_frame_changed() -> void:
	if as2d.animation != "a2" or parent.takeHit:
		return
		
		
	if as2d.frame == 3:
		a2d.monitorable = true
		a2d.monitoring = true
		parent.comboCount = 2
	if as2d.frame == 5:
		a2d.monitorable = false
		a2d.monitoring = false
		
func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if parent.state_machine.current_state != parent.att2_state or KB:
		return
		
	startKB = true
	if !area.is_in_group("World") or !area.is_in_group("Spikes"):
		apply_timeSlow(hit_timeStop, hit_duration)
	else:
		worldHit = true
		
	if as2d.flip_h:
		attackDir = -1
	else:
		attackDir = 1
	

func exit() -> void:
	KB = false
	checkHit = true
	a2d.monitorable = false
	a2d.monitoring = false
	attackDir = 0
	if parent.attackCheck:
		parent.attackCheck = false
	
func process_input(event: InputEvent) -> State:
	return null
# Decide state when attack animation ends
func process_frame(delta: float) -> State:
	if parent.takeHit:
		return parent.hit_state
	
	if !as2d.is_playing() and !KB:
		if parent.wallSlide:
			return parent.wallSlide_state
		if parent.parryCheck:
				return parent.parry_state
		if parent.dash:
			return parent.dash_state
		
		if parent.is_on_floor():
			if Input.is_action_pressed("jump"):
				return parent.jump_state
			
			if direction != 0:
				return parent.run_state
				
			if direction == 0:
				return parent.idle_state
		else:
				return parent.fall_state
	return null
	
func process_physics(delta: float) -> State:
	direction = Input.get_axis("runL", "runR")
		
			
	if startKB:
		if worldHit:
			worldHit = false
			parent.velocity.x += -attackDir * 250
		else:
			parent.velocity.x += -attackDir * playerKnockback
		KB = true
		startKB = false
	elif KB:
		parent.velocity.x = move_toward(parent.velocity.x, 0, decayRate * delta)
		if parent.velocity.x == 0:
			KB = false
	else:
		if direction != 0:
			parent.velocity.x = direction * move_speed
			parent.wallslide_chest.target_position.x = abs(parent.wallslide_chest.target_position.x) * direction
			parent.wallslide_chest.position.x = 3.7 * direction
			a2d.position = Vector2(2 * direction, 0)
			parent.wallslide_legs.target_position.x = abs(parent.wallslide_legs.target_position.x) * direction
			parent.wallslide_legs.position.x = 3.7 * direction
			a2d.position = Vector2(18 * direction, 4)
		elif direction == 0:
			if as2d.flip_h:
				a2d.position = Vector2(18 * -1, 4)
			else:
				a2d.position = Vector2(18 * 1, 4)
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
	Engine.time_scale = max(timeScale, 0.05)
	await get_tree().create_timer(duration, false, false, true).timeout 
	Engine.time_scale = 1.0
	timeSlow = false
