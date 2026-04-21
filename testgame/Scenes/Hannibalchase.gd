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
	if chaseDir > 0:
		chaseDir = 1
	elif chaseDir < 0:
		chaseDir = -1
	
	parent.velocity.x = chaseDir * parent.MovementSpeed
	parent.move_and_slide()
	return null
