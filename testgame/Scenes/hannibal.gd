class_name Hannibal extends CharacterBody2D

@onready var as2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: Node = $stateMachine
@onready var wallDetection: RayCast2D = $RayCast2D
@onready var c2d: CollisionShape2D = $CollisionShape2D
@onready var player_detect: RayCast2D = $PlayerDetect
@onready var player_chase_detect: RayCast2D = $playerChaseDetect

@export var idle_state: HannibalState
@export var jump_state: HannibalState
@export var chase_state: HannibalState
@export var attack_state: HannibalState
@export var airAttack_State: HannibalState
@export var jumpStrength: float = 565
@export var MovementSpeed: float = 250

var direction: float = 1
var wallJump: bool = false
var phase2: bool = false
var leap: bool = false

func _ready() -> void:
	state_machine.init(self)
		
func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)
	

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

		
func _process(delta: float) -> void:
	state_machine.process_frame(delta)


func flip_direction(dir: int = 0):
	if dir != 0:
		direction = dir
	else:
		direction *= -1
	wallDetection.target_position.x *= -1
	if direction == 1:
		player_chase_detect.target_position.x = 20
	elif direction == -1:
		player_chase_detect.target_position.x = -19
	c2d.position.x *= -1
	if as2d.flip_h:
		as2d.flip_h = false
	else:
		as2d.flip_h = true
