extends CharacterBody2D
class_name REnemy

@onready var state_mach: Node = $StateMach
@export var idle_state: REnemyState
@export var hit_state: REnemyState
@export var attack_state: REnemyState
@export var death_state: REnemyState
@export var patrol_state: REnemyState
@export var chase_state: REnemyState
var spawn_position: Vector2
@export var Lbound := -99999999
@export var Rbound := 99999999

func _ready() -> void:
	spawn_position = global_position
	state_mach.init(self)

func _unhandled_input(event: InputEvent) -> void:
	state_mach.process_input(event)

func _physics_process(delta: float) -> void:	
	state_mach.process_physics(delta)

func _process(delta: float) -> void:
	state_mach.process_frame(delta)
	
func _on_killzone_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	state_mach.change_state(hit_state)
