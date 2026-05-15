class_name TEnemy extends Node2D

@export var hit_state: TEnemyState
@export var attack_state: TEnemyState
@export var death_state: TEnemyState
@export var patrol_state: TEnemyState
@export var stun_state: TEnemyState
@export var patrol : bool
@onready var state_mac: Node = $StateMac
@onready var ait: Timer = $AItimer
@onready var attack_box: Area2D = $AttackBox


var spawn_position: Vector2
var attack := false
var hit := false
var parried := false
var afterAtt := false
var dir := 0
var healthCount := 2

func _ready() -> void:
	dir = 1
	spawn_position = global_position
	state_mac.init(self)

func _unhandled_input(event: InputEvent) -> void:
	state_mac.process_input(event)

func _physics_process(delta: float) -> void:	
	state_mac.process_physics(delta)

func _process(delta: float) -> void:
	state_mac.process_frame(delta)

func _on_detection_box_area_entered(area: Area2D) -> void:
	if ait.is_stopped():
		attack = true
	
func stun():
	parried = true


func _on_hurt_box_area_entered(area: Area2D) -> void:
	if state_mac.current_state == attack_state:
		afterAtt = true
		return
	else:
		hit = true
