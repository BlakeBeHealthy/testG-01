extends EnemyState
@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

@export var knockback_strength := 0
@export var friction := 0
@export var chase_state: EnemyState
@export var death_state: EnemyState

var flashing := false
var direction
var player

func enter() -> void:
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
	
	if !as2d.is_playing():
		return chase_state
		
	return null

func process_physics(delta: float) -> EnemyState:
	
	parent.velocity.x = lerp(parent.velocity.x, 0.0, friction * delta)
	
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
	parent.velocity.x = dir * knockback_strength
	print("ENEMY", parent.velocity.x)
	
