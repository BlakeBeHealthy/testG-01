extends State
@export var dashSpeed: float
@export var decayRate: float
@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var dash_delay: Timer = $"../../DashDelay"
@onready var dash_time: Timer = $"../../DashTime"
@onready var hurtbox: Area2D = $"../../Area2D2"
@onready var jump_buff: Timer = $"../../jumpBuff"

var dashDone
var dashCheck := false
var dashDir := 0.0
var jumpBuff := false
var jump := false
# Called when the node enters the scene tree for the first time.
func enter() -> void:
	jump_buff.start()
	hurtbox.monitorable = false
	hurtbox.monitoring = false
	dash_time.start()
	dashCheck = true
	if parent.dash:
		parent.dash = false
	dash_delay.start()
	as2d.play("dash")
	dashDir = Input.get_axis("runL","runR" )
	if Input.is_action_just_pressed("runL"):
		as2d.flip_h = true
	elif Input.is_action_just_pressed("runR"):
		as2d.flip_h = false
	
		
		
func exit() -> void:
	if parent.dashAllow:
		parent.dashAllow = false
	hurtbox.monitorable = true
	hurtbox.monitoring = true
	if jumpBuff:
		jumpBuff = false
	if !jump_buff.is_stopped():
		jump_buff.stop()

func process_input(event: InputEvent) -> State:
	if jumpBuff:
		if Input.is_action_just_pressed("jump"):
			jump = true
	return null

func process_frame(delta: float) -> State:
	
	if dashDone:
		dashDone = false
		if parent.parryCheck:
			return parent.parry_state 
		elif parent.attackCheck:
			return parent.attack_state
		elif parent.pogoCheck:
			return parent.pogo_state
		elif !parent.is_on_floor() and parent.velocity.y > 0:
			return parent.fall_state
		elif (Input.is_action_just_pressed('jump') or jump) and (parent.is_on_floor() or parent.moveCheck):
			if jump:
				jump = false
			return parent.jump_state
		elif Input.is_action_pressed('runL') or Input.is_action_pressed('runR'):
			return parent.run_state
		else:
			return parent.idle_state
	return null

func process_physics(delta: float) -> State:
	if dashCheck:
		if as2d.flip_h == false:
			dashDir = 1
		elif as2d.flip_h == true:
			dashDir = -1
		parent.velocity.x = dashDir * dashSpeed
	else:
		parent.velocity.x = move_toward(parent.velocity.x, move_speed, decayRate * delta)
	parent.velocity.y = 0
	parent.move_and_slide()
	return null


func _on_dash_time_timeout() -> void:
	dashCheck = false
	dashDone = true


func _on_jump_buff_timeout() -> void:
	jumpBuff = true 
