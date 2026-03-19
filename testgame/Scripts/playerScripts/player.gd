class_name Player
extends CharacterBody2D

#Base plsyer class defining the state machine and grabbing the values of delta and event
@onready var attack_delay: Timer = $attackDelay
@onready var state_machine: Node = $StateMachine
@onready var ComboTime: Timer = $Timer
@export var jump_state: State
@export var hit_state: State
@export var attack_state: State
@export var att2_state: State
@export var att3_state: State
@export var fall_state: State
@export var run_state: State
@export var idle_state: State
@export var death_state: State
@export var cut_state: State
@export var JUMP := 0
@export var jumpCut := 0.0
@onready var interactC2D: CollisionShape2D = $InteractArea/CollisionShape2D


var health := 5
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

var invincible := false
var control_locked = false
var direction := 0
var upwardDoor = false
var knockback_velocity := 0.0
var knockback_decay := 50.0
var jumpCheck := false
var attackCheck := false
var interactCheck := false
var comboCount := 0
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

func _ready() -> void:
	Global.set_player(self)
	state_machine.init(self)
		
func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	if is_on_floor() and jumpCheck:
		jumpCheck = false
	
func _process(delta: float) -> void:
	state_machine.process_frame(delta)
	if state_machine.current_state == jump_state or state_machine.current_state == fall_state:
		interactC2D.disabled = true
	else:
		interactC2D.disabled = false
		
func change_directon(dire: int):
	direction = dire
	if direction == 1:
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
	if state_machine.current_state != hit_state and event.is_action_pressed("leftC"):
		if attack_delay.is_stopped() or !ComboTime.is_stopped():
			if ComboTime.is_stopped():
				attackCheck = true 
			elif !ComboTime.is_stopped(): 
				attackCheck = true
				attack_delay.start()
				
	if Input.is_action_just_pressed("interact") and current_interactable != null and is_on_floor():
		control_locked = true
				
func _on_timer_timeout() -> void:
	comboCount = 0
