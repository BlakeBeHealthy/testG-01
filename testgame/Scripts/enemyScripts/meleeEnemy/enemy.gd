extends CharacterBody2D
class_name Enemy
#Base enemy class defining the state machine and grabbing the values of delta and event
@onready var state_mac: Node = $StateMac
@export var hit_state: EnemyState
@export var attack_state: EnemyState

var spawn_position: Vector2
@export var Lbound := -690
@export var Rbound := -515

var check := false

func _ready() -> void:
	spawn_position = global_position
	state_mac.init(self)

func _unhandled_input(event: InputEvent) -> void:
	state_mac.process_input(event)

func _physics_process(delta: float) -> void:	
	state_mac.process_physics(delta)

func _process(delta: float) -> void:
	state_mac.process_frame(delta)


func _on_killzone_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	state_mac.change_state(hit_state)
