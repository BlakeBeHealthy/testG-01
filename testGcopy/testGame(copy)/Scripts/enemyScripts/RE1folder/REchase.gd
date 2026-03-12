extends REnemyState

@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var abox: Area2D = $"../../Attackbox"
@onready var r2d2: RayCast2D = $"../../RayCast2D2"
@onready var r2d: RayCast2D = $"../../RayCast2D"
@onready var r2h: RayCast2D = $"../../Hit-Ray"
@onready var ati: Timer = $"../../attackTim"
@onready var hitCheck: Timer = $"../../hitCheck"


@export var patrol_state: REnemyState
@export var death_state: REnemyState
@export var idle_state: REnemyState
@export var attack_state: REnemyState
@export var hit_state: REnemyState

var abox_base_scale_x: float
var player
var dead = false
var patrol = false
var flashing := false
var direction
var hitboxOffX
# Called when the node enters the scene tree for the first time.
func enter() -> void:
	print("chase")
	player = Global.get_player()
	abox_base_scale_x = abs(abox.scale.x)
	if as2d.animation != "walk":
		as2d.play("walk")
	hitboxOffX = abs(abox.position.x)
	
func exit() -> void:
	patrol = false

func process_input(event: InputEvent) -> REnemyState:
	return null

func process_frame(delta: float) -> REnemyState:
	if dead:
		dead = false
		return hit_state
	if healthCount <= 0:
		return death_state
	if patrol:
		return patrol_state
	return null
	
func _on_killzone_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if ati.is_stopped():
		dead = true
	
func process_physics(delta: float) -> REnemyState:
	if not player:
		return patrol_state
	
	var collider = r2h.get_collider()
	if collider and collider is Player:
		var player_x = collider.global_position.x
		if player_x >= parent.Lbound and player_x <= parent.Rbound:
			return attack_state
		
	direction = sign(player.global_position.x - parent.global_position.x)
	if !player.invincible and hitCheck.is_stopped():
		print(parent.velocity.x)
		parent.velocity.x = direction * move_speed
		
	if player.invincible and \
	(player.global_position.x - parent.global_position.x) <= -0.01 and \
	(player.global_position.x - parent.global_position.x) <= -0.01:
		print(parent.velocity.x)
		parent.velocity.x = 0
		as2d.play("idle")
	elif !hitCheck.is_stopped():
		print(parent.velocity.x)
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
		return idle_state
	return null
	
func update_ray() -> void:
		r2d.target_position.x = abs(r2d.target_position.x) * direction
		r2d2.target_position.x = abs(r2d2.target_position.x) * direction
		r2h.target_position.x = abs(r2h.target_position.x) * direction
		
