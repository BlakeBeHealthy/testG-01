extends HannibalState

@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

var chaseDir: float

func enter() -> void:
	as2d.play("run")
	
func exit() -> void:
	pass

func process_input(event: InputEvent) -> States:
	return null

func process_frame(delta: float) -> States:
	return null

func process_physics(delta: float) -> States:
	chaseDir = Global.player.position.x - parent.position.x
	
	if parent.player_chase_detect.is_colliding():
		return parent.attack_state
		
	if chaseDir > 5 and parent.direction == -1:
		parent.flip_direction(1)
	elif chaseDir < -5 and parent.direction == 1:
		parent.flip_direction(-1)
	elif chaseDir < 5 and chaseDir > -5:
		parent.playerAbove = true
		parent.idle_time = 0.2
		return parent.idle_state
	
	parent.velocity.y += gravity * delta
	parent.velocity.x = parent.direction * parent.MovementSpeed
	parent.move_and_slide()
	return null
