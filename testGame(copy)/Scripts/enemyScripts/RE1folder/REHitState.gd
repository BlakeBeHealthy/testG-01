extends REnemyState

@onready var hitCheck: Timer = $"../../hitCheck"
@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"


@export var knockback_strength := 0
@export var decayRate := 0

var flashing := false
var direction
var player
var hit := false

func enter() -> void:
	hitCheck.start()
	player = Global.get_player()
	flash_white()
	healthCount -= 1
	if player.position.x - parent.position.x >= 0:
		direction = 1
	else:
		direction = -1
	as2d.play("hit")
	hit = true

func exit() -> void:
	hitCheck.start()

func process_input(event: InputEvent) -> REnemyState:
	return null

func process_frame(delta: float) -> REnemyState:
	if healthCount <= 0:
		return parent.death_state

	if !hitCheck.is_stopped():
		as2d.play("walk")
	else:
		return parent.chase_state
		
	return null

func process_physics(delta: float) -> REnemyState:
	if hit:
		parent.velocity.x = -direction * knockback_strength
		hit = false
	else:
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
	
