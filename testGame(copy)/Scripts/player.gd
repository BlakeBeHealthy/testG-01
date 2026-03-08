class_name Player
extends CharacterBody2D

@onready var state_machine: Node = $StateMachine
@export var hit_state: State

var invincible := false

func _ready() -> void:
	Global.set_player(self)
	state_machine.init(self)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
