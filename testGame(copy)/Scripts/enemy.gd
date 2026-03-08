extends CharacterBody2D
class_name Enemy

@onready var state_mac: Node = $StateMac

var spawn_position: Vector2

func _ready() -> void:
	spawn_position = global_position
	state_mac.init(self)

func _unhandled_input(event: InputEvent) -> void:
	state_mac.process_input(event)

func _physics_process(delta: float) -> void:	
	state_mac.process_physics(delta)

func _process(delta: float) -> void:
	state_mac.process_frame(delta)
