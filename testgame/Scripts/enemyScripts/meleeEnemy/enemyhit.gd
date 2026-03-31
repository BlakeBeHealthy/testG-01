extends EnemyState
@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var hitCheck: Timer = $"../../HitCheck"

@export var knockback_strength := 0
@export var decayRate := 0

var flashing := false
var direction
var player

func enter() -> void:
	parent.hit = false
	hitCheck.start()
	player = Global.get_player()
	as2d.play("hit")
	healthCount -= 1
	if player.position.x - parent.position.x >= 0:
		direction = -1
	else:
		direction = 1
	flash_white()
	take_hit(direction)

func exit() -> void:
	pass

func process_input(event: InputEvent) -> EnemyState:
	return null

func process_frame(delta: float) -> EnemyState:
	if healthCount <= 0:
		return parent.death_state
		
	if !hitCheck.is_stopped():
		if !as2d.is_playing():
			if parent.parried:
				return parent.stun_state
			else:
				as2d.play("idle")
	else:
		return parent.chase_state
		
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
	await get_tree().create_timer(0.04).timeout
	mat.set_shader_parameter("flash_strength", 0.0)
	flashing = false
	
func take_hit(dir):
	parent.velocity.x = dir * knockback_strength
	
