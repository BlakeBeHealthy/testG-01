extends HannibalState

@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

var chaseDir: float
var Dircheck: bool = false

func enter() -> void:
	as2d.play("startRun")
	await as2d.animation_finished
	if parent.lunge:
		parent.wallDetection.enabled = true
	as2d.play("run")
	
func exit() -> void:
	parent.wallDetection.enabled = false

func process_input(event: InputEvent) -> States:
	return null

func process_frame(delta: float) -> States:
	if parent.phase2S:
		if Dircheck:
			Dircheck = false
		return parent.idle_state
	
	if parent.wallDetection.is_colliding() and parent.lunge:
		return parent.attack_state
	
	return null

func process_physics(delta: float) -> States:
	if as2d.animation == "startRun":
		return
		
	if parent.middleAttack or parent.lunge:
		chaseDir = 568 - parent.position.x
		if abs(chaseDir) < 3.0 and parent.middleAttack:
			parent.idle_time = 0.2
			return parent.idle_state
		else:
			if Dircheck:
				if abs(chaseDir) < 0:
					parent.flip_direction(1)
				else:
					parent.flip_direction(-1)
			Dircheck = false
	else:
		chaseDir = Global.player.position.x - parent.position.x
		
		if parent.player_chase_detect.is_colliding():
			return parent.attack_state
			
		if chaseDir > 5 and parent.direction == -1:
			parent.flip_direction(1)
		elif chaseDir < -5 and parent.direction == 1:
			parent.flip_direction(-1)
		elif chaseDir < 5 and chaseDir > -5:
			parent.playerAbove = true
			parent.idle_time = 0.05
			return parent.idle_state
	
	parent.velocity.y += gravity * delta
	if parent.phase2:
		parent.velocity.x = parent.direction * parent.MovementSpeed * 1.2
	else:
		parent.velocity.x = parent.direction * parent.MovementSpeed
	parent.move_and_slide()
	return null
