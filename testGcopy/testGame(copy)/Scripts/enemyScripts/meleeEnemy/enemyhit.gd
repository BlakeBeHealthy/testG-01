extends EnemyState
@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var hitCheck: Timer = $"../../HitCheck"

@export var knockback_strength := 0
@export var decayRate := 0
@export var chase_state: EnemyState
@export var death_state: EnemyState

var hit_knockback := 200
var flashing := false
var direction
var player

func enter() -> void:
	hitCheck.start()
	player = Global.get_player()
	healthCount -= 1
	if player.position.x - parent.position.x >= 0:
		direction = -1
	else:
		direction = 1
	flash_white()
	as2d.play("hit")
	take_hit(direction)

func exit() -> void:
	pass

func process_input(event: InputEvent) -> EnemyState:
	return null

func process_frame(delta: float) -> EnemyState:
	if healthCount <= 0:
		return death_state

	if !hitCheck.is_stopped():
		as2d.play("idle")
	else:
		return chase_state
		
	return null

func process_physics(delta: float) -> EnemyState:
	
	parent.velocity.x = move_toward(parent.velocity.x, 0, decayRate * delta)
	
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	return null

func flash_white():
	if flashing:
		return
	if healthCount <= 0:
		return
		
	flashing = true
	var mat := as2d.material as ShaderMaterial
	mat.set_shader_parameter("flash_strength", 1.0)
	await get_tree().create_timer(0.08).timeout
	mat.set_shader_parameter("flash_strength", 0.0)
	flashing = false
	
func take_hit(dir):
	parent.velocity.x = dir * hit_knockback
	
