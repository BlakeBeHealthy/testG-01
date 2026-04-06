extends State
@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var a2d: Area2D = $"../../Area2D"

var pogo := false
var transitionCheck := false
var nextAttack := false
var Attack := false
func enter() -> void:
	parent.attack_delay.start()
	parent.jumpCheck = true
	if transitionCheck:
		transitionCheck = false
	if parent.pogoCheck:
		parent.pogoCheck = false
	
	as2d.play("pogo")
	a2d.position.x = 0
	a2d.position.y = 15.0
	a2d.scale.x = 1.3
	a2d.scale.y = -0.5
	a2d. set_collision_mask_value(11, true)
	pass

func exit() -> void:
	a2d.position.x = parent.direction * 18
	a2d.position.y = 4.0
	a2d.scale.x = 1.4
	a2d.scale.y = 1.0
	transitionCheck = false
	a2d. set_collision_mask_value(11, false)
	a2d.monitorable = false
	a2d.monitoring = false
	pass
	
func _on_animated_sprite_2d_frame_changed() -> void:
	if as2d.animation != "pogo":
		return
	
	if as2d.frame == 1:
		nextAttack = true
		a2d.monitorable = true
		a2d.monitoring = true
	if as2d.frame == 2:
		a2d.monitorable = false
		a2d.monitoring = false
		
func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	if parent.takeHit:
		return parent.hit_state
	if nextAttack:
		if Input.is_action_just_pressed("leftC"):
			Attack = true
			
	if !as2d.is_playing():
		if parent.parryCheck:
			return parent.parry_state
		if parent.attackCheck:
			return parent.att2_state
		if parent.dash:
			return parent.dash_state
		if parent.velocity.y > 0:
			return parent.fall_state
		elif parent.is_on_floor():
			return parent.idle_state
	
	return null

func process_physics(delta: float) -> State:
	if pogo:
		pogo = false
		parent.velocity.y = -300
	else:
		parent.velocity.y += gravity * delta
		
	var direction = Input.get_axis("runL", "runR")
	if direction > 0:
		parent.flip_direction(1)
	elif direction < 0:
		parent.flip_direction(-1)
	parent.velocity.x = direction * move_speed
	parent.move_and_slide()
	return null
	
func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	pogo = true
