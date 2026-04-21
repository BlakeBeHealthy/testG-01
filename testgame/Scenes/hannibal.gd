class_name Hannibal extends CharacterBody2D

@onready var state_machine: Node = $stateMachine

@export var idle_state: HannibalState
@export var jump_state: HannibalState
@export var jumpStrength: float = 400

var wallJump

func _ready() -> void:
	state_machine.init(self)
		
func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

		
func _process(delta: float) -> void:
	print(velocity.y)
	state_machine.process_frame(delta)
