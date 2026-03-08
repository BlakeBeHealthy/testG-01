class_name Player
extends CharacterBody2D

@onready var state_machine: Node = $StateMachine
@export var jump_state: State
@export var hit_state: State
@export var attack_state: State

var health := 5
var invincible := false
var control_locked = false
var knockback_velocity := 0.0
var knockback_decay := 50.0

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

func _on_landed():
	control_locked = false
	
func _input(event):
	if state_machine.current_state != hit_state and event.is_action_pressed("leftC"):
		state_machine.change_state(attack_state)
