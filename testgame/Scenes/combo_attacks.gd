extends HannibalState

@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@export var knockbackStrength: float = 0
@export var decayRate: float = 0

var currentAttack = ""
var dir : int = 0  
var done: bool = false
var attacking: bool = false
var check: bool = false
var attackDir: float = 0

func enter() -> void:
	dir = parent.direction
	if parent.phase2 and parent.leap:
		currentAttack = "a3"
	else:
		currentAttack = "a1"
	
	as2d.play(currentAttack)
func exit() -> void:
	pass

func process_input(event: InputEvent) -> States:
	return null

func process_frame(delta: float) -> States:
	if done:
		done = false
		parent.idle_time = 1.0
		return parent.idle_state
		
	return null

func process_physics(delta: float) -> States:
	attackDir = Global.player.position.x - parent.position.x
		
	if attacking:
		dir = parent.direction
		parent.velocity.x += dir * knockbackStrength
		attacking = false
		check = true
	elif check:
		parent.velocity.x = move_toward(parent.velocity.x, 0, decayRate * delta)
		if parent.velocity.x == 0:
			check = false
	else:
		parent.velocity.x = 0
		
	if dir > 0 and parent.direction == -1:
		parent.flip_direction(1)
	elif dir < 0 and parent.direction == 1:
		parent.flip_direction(-1)
		
	parent.move_and_slide()
	return null


func _on_animated_sprite_2d_frame_changed() -> void:
	if as2d.animation != "a1" and as2d.animation != "a2" \
		and as2d.animation != "a3":
		return
		
	if as2d.animation == "a1":
		if as2d.frame == 3:
			attacking = true
		if as2d.frame == 6:
			dir = attackDir
			as2d.play("a2")
		
	if as2d.animation == "a2":
		if as2d.frame == 3:
			attacking = true
		if as2d.frame == 5:
			if parent.phase2:
				dir = attackDir
				as2d.play("a3")
			else:
				done = true
			
	if as2d.animation == "a3":
		if parent.leap and as2d.frame == 4:
			pass
		if as2d.frame == 4:
			pass
		elif as2d.frame == 8:
			done = true
