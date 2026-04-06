extends CharacterBody2D
class_name Enemy
#Base enemy class defining the state machine and grabbing the values of delta and event
@onready var state_mac: Node = $StateMac
@export var idle_state: EnemyState
@export var hit_state: EnemyState
@export var attack_state: EnemyState
@export var death_state: EnemyState
@export var patrol_state: EnemyState
@export var stun_state: EnemyState
@export var chase_state: EnemyState
@onready var as2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var killzone: Area2D = $Killzone

var spawn_position: Vector2
@export var Lbound := -99999999999999999999
@export var Rbound := 99999999999999999999

var check := false
var healthCount := 6
var afterAtt := 6
var hit := false
var parried := false

func _ready() -> void:
	spawn_position = global_position
	state_mac.init(self)
	Global.player.goodParry.connect(stun)

func _unhandled_input(event: InputEvent) -> void:
	state_mac.process_input(event)

func _physics_process(delta: float) -> void:	
	state_mac.process_physics(delta)

func _process(delta: float) -> void:
	state_mac.process_frame(delta)
	if as2d.animation == "idle":
		killzone.position.x = -2
	else:
		killzone.position.x = -1


func _on_killzone_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if state_mac.current_state == attack_state:
		afterAtt = true
		return
	else:
		hit = true
		
func stun():
	if state_mac.current_state == attack_state or state_mac.current_state == chase_state:
		parried = true
