extends State

@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D" #as2d is ALWAYS the animation player
@onready var a2d: Area2D = $"../../Area2D" #a2d is the attack hitbox
@onready var a2d2: Area2D = $"../../Area2D2" #a2d2 is the attack hurtbox

#Small explination, each state must be a child of State class, or they are not allowed
	#in the state machine logic. For each state that interacts with one another
	#(for example jump would with fall). We make an exported variable of type "State". We then drag the 
	#respected node into the spot it goes in, for example if you select the idle node(if you
	#haven't already) You will see the list of states to the right. We do this for each state and while
	#tedious, makes the actual logic much more simple in terms of interaction, and much easier to read
	#instead of using one long class.
	
var jump := false
var run := false
var hitboxCheck = true
var hit := false 

#Enter and exit functions are just as they sound, when entering vs exiting states
func enter() -> void:
	as2d.play("idle")
	a2d2.position.x = 0
	a2d2.position.y = 9

func exit() -> void:
	hit = false

#Now The next three must return something of type State, or null. If null is returned
	#The state machine knows not to change states

#Honeslty I use this methods not in the greatest fashion, you may find some of my
	#code badly written in terms of some aspects bc I sometimes have input checks
	#in process_frame and other examples, fix as you see fit. Definately check for variables or
	#Any other code that is useless if you can, IK they are somewhere just havent had time to check
func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('jump') and parent.is_on_floor():
		return parent.jump_state
	elif Input.is_action_pressed('runL') and Input.is_action_pressed('runR'):
		return null
	elif Input.is_action_pressed('runL') or Input.is_action_pressed('runR'):
		return parent.run_state
	return null
	
func process_frame(delta: float) -> State:
	if parent.control_locked:
		parent.control_locked = false
		return parent.cut_state 
	
	if parent.takeHit:
		return parent.hit_state
	if parent.dash:
		return parent.dash_state
	if parent.parryCheck:
		return parent.parry_state
		
	if parent.attackCheck:
		parent.attackCheck = false
		if parent.parried:
			parent.parried = false
			return parent.parryAttack_state
		elif !parent.ComboTime.is_stopped():
			parent.ComboTime.stop()
			return parent.att2_state
		else:
			parent.ComboTime.start()
			return parent.attack_state
	return null
	
func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	if !parent.is_on_floor() and parent.velocity.y > 0:
		return parent.fall_state
	return null
	
func _on_area_2d_2_area_entered(area: Area2D) -> void:
	hit = true
