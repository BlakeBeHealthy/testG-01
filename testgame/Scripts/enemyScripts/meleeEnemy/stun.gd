extends EnemyState

@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var stun_time: Timer = $"../../StunTime"
@export var knockback_strength := 0
@export var decayRate := 0
var direction := 0
var takehit:= false

func enter() -> void:
	as2d.play("stun")
	if stun_time.is_stopped():
		if Global.player.position.x - parent.position.x >= 0:
			direction = -1
		else:
			direction = 1
		take_hit(direction)
	stun_time.start()
func exit() -> void:
	pass

func process_input(event: InputEvent) -> EnemyState:
	return null

func process_frame(delta: float) -> EnemyState:
	if parent.hit:
		return parent.hit_state
	
	if stun_time.is_stopped():
		parent.parried = false
		return parent.chase_state
		
	return null

func process_physics(delta: float) -> EnemyState:
	parent.velocity.x = move_toward(parent.velocity.x, 0, decayRate * delta)
	
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	return null

func take_hit(dir):
	parent.velocity.x = dir * knockback_strength
	takehit = true
