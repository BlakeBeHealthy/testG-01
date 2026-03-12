extends CharacterBody2D
class_name REnemy

@onready var state_mach: Node = $StateMach

var spawn_position: Vector2
#Lbound and Rbound are just barriers in which the player can be spotted currently, in patrol state,
	#same with the first enemy
@export var Lbound := -300
@export var Rbound := 10

func _ready() -> void:
	spawn_position = global_position
	state_mach.init(self)

func _unhandled_input(event: InputEvent) -> void:
	state_mach.process_input(event)

func _physics_process(delta: float) -> void:	
	state_mach.process_physics(delta)

func _process(delta: float) -> void:
	state_mach.process_frame(delta)
