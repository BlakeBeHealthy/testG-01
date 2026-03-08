extends State

@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var timer: Timer = $"../../Timer"
@onready var tim_2: Timer = $"../../tim2"
@onready var a2d: Area2D = $"../../Area2D"
@onready var hitstuntimer: Timer = $"../../hitstuntimer"
@onready var it3: Timer = $"../../InvincibleTime"
@onready var a2d2: Area2D = $"../../Area2D2"

@export var fall_state: State
@export var run_state: State
@export var idle_state: State 
@export var jump_state: State
@export var attack_state: State
@export var death_state: State

var hit_over
var dead := false
var deadCount := 4

func enter() -> void:
	deadCount -= 1
	parent.invincible = true
	a2d2.monitoring = false
	a2d2.monitorable = false
	print(a2d2.monitoring)
	it3.start()
	hit_over = false
	
func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	if hit_over:
		if Input.is_action_just_pressed('jump') and parent.is_on_floor():
			return jump_state
		if Input.is_action_just_pressed('runL') or Input.is_action_just_pressed('runR'):
			return run_state
		if Input.is_action_just_pressed('leftC'):
			return attack_state
		else:
			return idle_state
			
	return null
	
func _on_hitstuntimer_timeout() -> void:
	hit_over = true
	
func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	return null
	
func apply_knockback(direction: int, strength: float, stun_time: float) -> void:
	if !dead:
		parent.velocity.x = direction * strength
		parent.velocity.y = -strength * 0.5
		hitstuntimer.start(stun_time)
		as2d.play("hit")


func _on_invincible_time_timeout() -> void:
	parent.invincible = false
	a2d2.monitoring = true
	a2d2.monitorable = true
