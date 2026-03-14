extends State
@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var ComboTime: Timer = $"../../Timer"
@onready var a2d: Area2D = $"../../Area2D"
@onready var a2d2: Area2D = $"../../Area2D2"
@onready var attack_delay: Timer = $"../../attackDelay"


@export var fall_state: State
@export var run_state: State
@export var idle_state: State
@export var att2_state: State
@export var hit_state: State
@export var jump_state: State
@export var hit_timeStop: float
@export var hit_duration: float
@export var decayRate := 0
@export var playerKnockback := 0

var checkHit := true
var startKB := false
var hit := false
var timeSlow := false
var checkAttack := false
var KB = false
var jumpBuff := 0
var moveBuffDir := 0
var moveBuffTime := 0
var attackDir := 0

func enter() -> void:
	attack_delay.start()
	attackDir = Input.get_axis("runL", "runR")
	startKB = false
	if checkHit:
		checkHit = false
		
	if checkAttack == false:
		as2d.play("attack")
	
func _on_animated_sprite_2d_frame_changed() -> void:
	if as2d.animation != "attack":
		return
		
	if as2d.frame == 2:
		ComboTime.start()
	
	if as2d.frame == 3:
		a2d.monitorable = true
		a2d.monitoring = true
	if as2d.frame == 5:
		a2d.monitorable = false
		a2d.monitoring = false
		
func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	startKB = true
		
func exit() -> void:
	checkHit = true
	a2d.monitorable = false
	a2d.monitoring = false
	attackDir = 0
	KB = false
	
func process_input(event: InputEvent) -> State:
	if !ComboTime.is_stopped() and Input.is_action_just_pressed("leftC"):
		checkAttack = true
		
	if Input.is_action_pressed("jump"):
		jumpBuff = 1
		
	return null
# Decide state when attack animation ends
func process_frame(delta: float) -> State:
	var direction = Input.get_axis("runL", "runR")
	if not as2d.is_playing() and !KB:
		if checkAttack:
			checkAttack = false
			return att2_state
			
		if jumpBuff != 0 and parent.is_on_floor():
			jumpBuff = 0
			return jump_state
		
		if attackDir != 0:
			return run_state
			
		if direction == 0:
			return idle_state

			
	if hit:
		return hit_state
		
	return null
	
func process_physics(delta: float) -> State:
	if startKB:
		parent.velocity.x = -attackDir * playerKnockback
		KB = true
		startKB = false
		
	if KB:
		print(parent.velocity.x)
		parent.velocity.x = move_toward(parent.velocity.x, 0, decayRate * delta)
		print(parent.velocity.x)
		if parent.velocity.x == 0:
			KB = false 
	
	if attackDir != 0 and !KB:
		parent.velocity.x = attackDir * move_speed
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
