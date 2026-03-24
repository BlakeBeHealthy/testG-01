extends EnemyState

@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var r2d: RayCast2D = $"../../RayCast2D"
@onready var r2d2: RayCast2D = $"../../RayCast2D2"
@onready var r2h: RayCast2D = $"../../Hit-Ray"
@onready var abox: Area2D = $"../../Attackbox"

var abox_base_scale_x: float
var player
var dead = false
var patrol = false
var flashing := false
var direction
var hitboxOffX

func enter() -> void:
	player = Global.get_player()
	abox_base_scale_x = abs(abox.scale.x)
	if as2d.animation != "walk":
		as2d.play("walk")
	hitboxOffX = abs(abox.position.x)
	
func exit() -> void:
	patrol = false

func process_input(event: InputEvent) -> EnemyState:
	return null

func process_frame(delta: float) -> EnemyState:
	if healthCount <= 0:
		return parent.death_state
	if parent.hit:
		return parent.hit_state
	if patrol:
		return parent.patrol_state
	return null
	
func process_physics(delta: float) -> EnemyState:
	if not player:
		return parent.patrol_state
	
	var collider = r2h.get_collider() #This is the attack range detector, if the player is close it attacks
	if collider and collider is Player:
		var player_x = collider.global_position.x
		if player_x >= parent.Lbound and player_x <= parent.Rbound:
			return parent.attack_state
	#Direction is now based on the player
	direction = sign(player.global_position.x - parent.global_position.x)
	if !player.invincible:
		parent.velocity.x = direction * move_speed
	#Ensuring the enemy doesnt walk in the middle of the player during its invincibile
	#time and spam walk left and right, tho that bug may have started once more...
	if player.invincible and \
	(player.global_position.x - parent.global_position.x) <= -0.01 and \
	(player.global_position.x - parent.global_position.x) <= -0.01:
		parent.velocity.x = 0
		as2d.play("idle")
	else:
		parent.velocity.x = direction * move_speed
		if as2d.animation != "walk":
			as2d.play("walk")
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	
	if direction < 0:
		as2d.flip_h = true
		abox.position.x = direction * hitboxOffX
		update_ray()
	elif direction > 0:
		as2d.flip_h = false
		abox.position.x = direction * hitboxOffX
		update_ray()
		
	
	if !r2d.is_colliding():
			parent.velocity.x = 0
			
	if !r2d.is_colliding():
		return parent.idle_state
	return null
	
func update_ray() -> void:
		r2d.target_position.x = abs(r2d.target_position.x) * direction
		r2d2.target_position.x = abs(r2d2.target_position.x) * direction
		r2h.target_position.x = abs(r2h.target_position.x) * direction
		
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
