class_name Player
extends CharacterBody2D

#Base plsyer class defining the state machine and grabbing the values of delta and event
@onready var attack_delay: Timer = $attackDelay
@onready var state_machine: Node = $StateMachine
@onready var ComboTime: Timer = $Timer
@onready var as2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var a2d: Area2D = $Area2D
@onready var a2d2: Area2D = $Area2D2
@onready var parry_cooldown: Timer = $parryCooldown


@export var jump_state: State
@export var hit_state: State
@export var attack_state: State
@export var att2_state: State
@export var parry_state: State
@export var parryAttack_state: State
@export var fall_state: State
@export var run_state: State
@export var idle_state: State
@export var death_state: State
@export var cut_state: State
@export var pogo_state: State
@export var JUMP := 0
@export var jumpCut := 0.0
@onready var interactC2D: CollisionShape2D = $InteractArea/CollisionShape2D
@onready var parry_zone: Area2D = $ParryZone
@onready var dash_delay: Timer = $DashDelay


@warning_ignore("unused_signal")
signal playerHit
@warning_ignore("unused_signal")
signal saving
@warning_ignore("unused_signal")
signal speaking
@warning_ignore("unused_signal")
signal landed
@warning_ignore("unused_signal")
signal inAir
@warning_ignore("unused_signal")
signal goodParry

var invincible := false
var control_locked = false
var direction := 0
var upwardDoor = false
var knockback_velocity := 0.0
var knockback_decay := 50.0
var jumpCheck := false
var attackCheck := false
var pogoCheck := false
var parryCheck := false
var parried := false
var interactCheck := false
var camLook := false
var dash := false
var comboCount := 0
var health := 3
var current_interactable: Node = null
var takeHit: bool
var dir: int
var stre: float
var stunT: float
var TScale: float 
var dur: float
var CAMshake: float
var shakeDur: float
var damage: int
var respawnCoord: Vector2 = Vector2(0, 0)

func _ready() -> void:
	Global.set_player(self)
	state_machine.init(self)
		
func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	if is_on_floor() and jumpCheck and state_machine.current_state != pogo_state:
		jumpCheck = false
	
func _process(delta: float) -> void:
	state_machine.process_frame(delta)
	if state_machine.current_state == jump_state or state_machine.current_state == fall_state:
		interactC2D.disabled = true
	else:
		interactC2D.disabled = false
		landed.emit()
		
func flip_direction(dire: int):
	direction = dire
	parry_zone.position.x *= direction
	if direction >= 1:
		as2d.flip_h = false
	elif direction <= -1:
		as2d.flip_h = true
		pass
	
func enter_from_transition(direct: Vector2) -> void:
	upwardDoor = true
	velocity = direct * 120
	state_machine.change_state(jump_state)

func _on_landed(): #This will be for cutscenes when the player cant move
	upwardDoor = false

func hit(dmg: int, direction: int, strength: float, stun_time: float, timeScale: float, duration: float, camShakeStrength: float, shakeDuration: float):
	if !invincible:
		damage = dmg
		dir = direction
		stre = strength
		stunT = stun_time
		TScale = timeScale
		dur = duration
		CAMshake = camShakeStrength
		shakeDur = shakeDuration
		ComboTime.stop()
		comboCount = 0
		takeHit = true
		attack_delay.stop()
	
func _input(event): #allowing the player to attack
	if (state_machine.current_state != hit_state and state_machine.current_state != cut_state) and event.is_action_pressed("Parry") and parry_cooldown.is_stopped():
			parryCheck = true
	elif (state_machine.current_state != hit_state and state_machine.current_state != cut_state) and event.is_action_pressed("leftC"):
			if !is_on_floor() and Input.is_action_pressed("down") and attack_delay.is_stopped():
				pogoCheck = true
			elif !ComboTime.is_stopped() or attack_delay.is_stopped():
				if ComboTime.is_stopped() or !state_machine.current_state == parryAttack_state:
					attackCheck = true 
				elif !ComboTime.is_stopped(): 
					attackCheck = true
					attack_delay.start()
				
	elif ((Input.is_action_just_pressed("interact") and current_interactable != null) or Input.is_action_pressed("PlayerLock")) and is_on_floor() and !Global.UI.get_node("Balloon").visible:
		control_locked = true
	elif Input.is_action_just_pressed("Dash") and state_machine.current_state != hit_state and state_machine.current_state != cut_state and dash_delay.is_stopped():
		dash = true
		
func _on_timer_timeout() -> void:
	comboCount = 0

func respawn():
	self.global_position = respawnCoord

func _on_parry_cooldown_timeout() -> void:
	parried = false
