class_name TEnemy extends Node2D

@export var idle_state: TEnemyState
@export var hit_state: TEnemyState
@export var attack_state: TEnemyState
@export var death_state: TEnemyState
@export var patrol_state: TEnemyState
@export var stun_state: TEnemyState
@export var patrol : bool
@onready var state_mac: Node = $StateMac

var spawn_position: Vector2
var attack := false
var hit := false

func _ready() -> void:
	spawn_position = global_position
	state_mac.init(self)

func _unhandled_input(event: InputEvent) -> void:
	state_mac.process_input(event)

func _physics_process(delta: float) -> void:	
	state_mac.process_physics(delta)

func _process(delta: float) -> void:
	state_mac.process_frame(delta)

func _on_detection_box_area_entered(area: Area2D) -> void:
	attack = true
