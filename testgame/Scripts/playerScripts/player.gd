class_name Player
extends CharacterBody2D

#Base plsyer class defining the state machine and grabbing the values of delta and event
@onready var attack_delay: Timer = $attackDelay
@onready var state_machine: Node = $StateMachine
@onready var ComboTime: Timer = $Timer
@onready var as2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var a2d: Area2D = $Area2D
@onready var a2d2: Area2D = $Area2D2
@onready var parry_cooldown: Timer = $parryCooldown


@export var jump_state: State
@export var hit_state: State
@export var attack_state: State
@export var att2_state: State
@export var parry_state: State
@export var parryAttack_state: State
@export var fall_state: State
@export var run_state: State
@export var idle_state: State
@export var dash_state: State
@export var death_state: State
@export var cut_state: State
@export var pogo_state: State
@export var wallSlide_state: State
@export var JUMP := 0
@export var jumpCut := 0.0
@onready var interactC2D: CollisionShape2D = $InteractArea/CollisionShape2D
@onready var parry_zone: Area2D = $ParryZone
@onready var dash_delay: Timer = $DashDelay
@onready var wallslide_legs: RayCast2D = $wallslideLegs
@onready var wallslide_chest: RayCast2D = $wallslideChest
@onready var wall_slide_fall: Timer = $wallSlideFall


@warning_ignore("unused_signal")
signal playerHit
@warning_ignore("unused_signal")
signal saving
@warning_ignore("unused_signal")
signal speaking
@warning_ignore("unused_signal")
signal landed
@warning_ignore("unused_signal")
signal inAir
@warning_ignore("unused_signal")
signal goodParry

var invincible := false
var control_locked = false
var stickState := false
var direction := 0
var Jdirection := 0
var upwardDoor = false
var knockback_velocity := 0.0
var knockback_decay := 50.0
var jumpCheck := false
var jumpBuff := false
var wallJumpBuff := false
var attackCheck := false
var pogoCheck := false
var parryCheck := false
var parried := false
var interactCheck := false
var moveCheck := false
var dashAllow := true
var camLook := false
var animate := false
var dash := false
var wallSlide := false
var wallJump := false
var comboCount := 0
var health := 3
var current_interactable: Node = null
var takeHit: bool
var dir: int
var stre: float
var stunT: float
var TScale: float 
var dur: float
var CAMshake: float
var shakeDur: float
var damage: int
var respawnCoord: Vector2 = Vector2(0, 0)

func _ready() -> void:
	Global.set_player(self)
	state_machine.init(self)
		
func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	if is_on_floor() and jumpCheck and state_machine.current_state != pogo_state:
		jumpCheck = false
	if wallslide_chest.is_colliding() and wallslide_legs.is_colliding() and !is_on_floor() and !wallJump and state_machine.current_state != wallSlide_state:
		if as2d.flip_h == true:
			if Input.is_action_pressed("runL"):
				Jdirection = -1
				wallSlide = true
		elif as2d.flip_h == false:
			if Input.is_action_pressed("runR"):
				Jdirection = 1
				wallSlide = true
	elif is_on_floor():
		wallSlide = false
		wallJump = false
		wallJumpBuff = false
		
func _process(delta: float) -> void:
	state_machine.process_frame(delta)
	if state_machine.current_state == jump_state or state_machine.current_state == fall_state:
		interactC2D.disabled = true
	else:
		interactC2D.disabled = false
	if is_on_floor():
		landed.emit()
		dashAllow = true
		if Gameplay.DJ:
			moveCheck = true
	if state_machine.current_state == hit_state and state_machine.current_state == cut_state or state_machine.current_state == wallSlide_state:
		stickState = true
	else:
		stickState = false
		

func flip_direction(dire: int):
	direction = dire
	parry_zone.position.x *= direction
	if direction >= 1:
		as2d.flip_h = false
	elif direction <= -1:
		as2d.flip_h = true
		pass
	
func enter_from_transition(direct: Vector2) -> void:
	upwardDoor = true
	velocity = direct * 120
	state_machine.change_state(jump_state)

func _on_landed(): #This will be for cutscenes when the player cant move
	upwardDoor = false

func hit(dmg: int, direction: int, strength: float, stun_time: float, timeScale: float, duration: float, camShakeStrength: float, shakeDuration: float):
	if !invincible:
		damage = dmg
		dir = direction
		stre = strength
		stunT = stun_time
		TScale = timeScale
		dur = duration
		CAMshake = camShakeStrength
		shakeDur = shakeDuration
		ComboTime.stop()
		comboCount = 0
		takeHit = true
		attack_delay.stop()
		
func _unhandled_key_input(event: InputEvent) -> void:
	if Global.inputBlocked:
		return
		
func _input(event): #allowing the player to attack
	if Global.inputBlocked:
		return
		
	if (!stickState) and event.is_action_pressed("Parry") and parry_cooldown.is_stopped():
			parryCheck = true
	elif (!stickState) and event.is_action_pressed("leftC"):
			if !is_on_floor() and Input.is_action_pressed("down") and attack_delay.is_stopped():
				pogoCheck = true
			elif !ComboTime.is_stopped() or attack_delay.is_stopped():
				if ComboTime.is_stopped() or state_machine.current_state != parryAttack_state or state_machine.current_state != parry_state:
					attackCheck = true 
				elif !ComboTime.is_stopped(): 
					attackCheck = true
					attack_delay.start()
				
	if ((Input.is_action_just_pressed("interact") and current_interactable != null) or (Input.is_action_pressed("PlayerLock")) and is_on_floor() and !Global.UI.get_node("Balloon").visible):
		control_locked = true
	elif Input.is_action_just_pressed("Dash") and !stickState and dash_delay.is_stopped() and dashAllow:
		dash = true
				
func _on_timer_timeout() -> void:
	comboCount = 0

func respawn():
	self.global_position = respawnCoord

func _on_parry_cooldown_timeout() -> void:
	parried = false


func _on_parry_inv_timeout() -> void:
	a2d2.set_collision_layer_value(4, true)
	
func playAnim(anim: String):
	as2d.play(anim)

func anim():
	a2d2.monitorable = false
	a2d2.monitorable = false
	control_locked = true
	if !animate:
		animate = true
	else:
		animate = false
