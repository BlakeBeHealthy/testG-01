class_name Hannibal extends CharacterBody2D

@onready var as2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: Node = $stateMachine
@onready var wallDetection: RayCast2D = $RayCast2D
@onready var c2d: CollisionShape2D = $CollisionShape2D
@onready var player_detect: RayCast2D = $PlayerDetect
@onready var player_chase_detect: RayCast2D = $playerChaseDetect
@onready var hannibal_ahh: Area2D = $hannibalAHH
@onready var hurtbox: Area2D = $Hurtbox
@onready var hitbox: Area2D = $hitbox

@export var idle_state: HannibalState
@export var jump_state: HannibalState
@export var chase_state: HannibalState
@export var attack_state: HannibalState
@export var airAttack_State: HannibalState
@export var jumpStrength: float = 565
@export var MovementSpeed: float = 250
@export var knockback_strength := 200
@export var stun_time := 0.2
@export var timeStop := 0.0
@export var duration := 0.2
@export var camShakeStrength := 2
@export var shakeDuration := 0.2
@export var dmg := 0

var direction: float = 1
var wallJump: bool = false
var phase2: bool = false
var phase2S: bool = false
var death: bool = false
var hittin: bool = false
var lunge: bool = false
var chase: bool = false
var middleAttack: bool = false
var jump2: int = 0
var healthCount: int = 35
var playerAbove: bool = false
var pray: PrayMove
enum PrayMove { NONE, ACTIVE, DONE}
var flashing: bool = false
var cut: bool = false
var idle_time: float = 0

func _ready() -> void:
	pray = PrayMove.NONE
	state_machine.init(self)
		
func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)
	

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

		
func _process(delta: float) -> void:
	state_machine.process_frame(delta)
	
	if healthCount <= 21  and healthCount % 7 == 0 and pray == PrayMove.NONE:
		pray = PrayMove.ACTIVE
		
	if healthCount == 25 and !phase2 and !phase2S:
		phase2S = true
		jump2 = 1
		
	elif healthCount <= 0 and !death and !phase2S:
		phase2S = true
		death = true
		
		
	if Global.cutsceneStarted and !phase2S and !death:
		phase2S = true
		
func flip_direction(dir: int = 0, cutCheck: bool = false):
	if dir != 0:
		direction = dir
	else:
		direction *= -1
	wallDetection.target_position.x *= -1
	if direction == 1:
		hurtbox.position.x = 2.3
		hannibal_ahh.position.x = 1.5
		player_chase_detect.target_position.x = 40
	elif direction == -1:
		hurtbox.position.x = -0.76
		hannibal_ahh.position.x = -2.3
		player_chase_detect.target_position.x = -39
	c2d.position.x *= -1
	if !cutCheck:
		if as2d.flip_h:
			as2d.flip_h = false
		else:
			as2d.flip_h = true

func hit():
	Global.player.hit(
				dmg,
				sign(Global.player.global_position.x - global_position.x),
				knockback_strength,
				stun_time,
				timeStop,
				duration,
				camShakeStrength,
				shakeDuration
			)
func flash_white():
	if flashing:
		return
	if healthCount <= 0:
		return
		
	flashing = true
	var mat := as2d.material as ShaderMaterial
	mat.set_shader_parameter("flash_strength", 1.0)
	await get_tree().create_timer(0.04).timeout
	mat.set_shader_parameter("flash_strength", 0.0)
	flashing = false

func _on_hitbox_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	hit()
	
func _on_hannibal_ahh_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	hit()
	
func _on_hurtbox_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	hittin = true
	await flash_white()
	healthCount -= 1
	if pray == PrayMove.DONE:
		pray = PrayMove.NONE
	hittin = false
