class_name Player
extends CharacterBody2D

#Base plsyer class defining the state machine and grabbing the values of delta and event
@onready var attack_delay: Timer = $attackDelay
@onready var state_machine: Node = $StateMachine
@export var jump_state: State
@export var hit_state: State
@export var attack_state: State
@export var att2_state: State
@export var att3_state: State

var health := 5
var invincible := false
var control_locked = false
var knockback_velocity := 0.0
var knockback_decay := 50.0
var jumpCheck := false
var takeHit: bool
var dir: int
var str: float
var stunT: float
var TScale: float
var dur: float
var CAMshake: float
var shakeDur: float

func _ready() -> void:
	Global.set_player(self)
	state_machine.init(self)
		
func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	
func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func enter_from_transition(direction: Vector2) -> void:
	control_locked = true
	velocity = direction * 120
	state_machine.change_state(jump_state)

func _on_landed(): #This will be for cutscenes when the player cant move
	control_locked = false

func hit(direction: int, strength: float, stun_time: float, timeScale: float, duration: float, camShakeStrength: float, shakeDuration: float):
	if !invincible:
		dir = direction
		str = strength
		stunT = stun_time
		TScale = timeScale
		dur = duration
		CAMshake = camShakeStrength
		shakeDur = shakeDuration
		takeHit = true
	
func _input(event): #allowing the player to attack
	if state_machine.current_state != hit_state and event.is_action_pressed("leftC") and attack_delay.is_stopped():
		state_machine.change_state(attack_state)
	if is_on_floor():
		jumpCheck = false
	if state_machine.current_state != attack_state or state_machine.current_state != att2_state \
	or state_machine.current_state != att3_state: 
		pass
