extends REnemyState

@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var r2d2: RayCast2D = $"../../RayCast2D2"
@onready var r2d: RayCast2D = $"../../RayCast2D"
@onready var r2h: RayCast2D = $"../../Hit-Ray"
@onready var pti: Timer = $"../../PatTime"
@onready var abox: Area2D = $"../../Attackbox"
@onready var flash_mat := as2d.material as ShaderMaterial
@onready var hitCheck: Timer = $"../../hitCheck"
@onready var wall_ray: RayCast2D = $"../../wallRay"

@export var pauseTime := 0.4

var direction: int = -1
var pausing := false  
var dead := false
var justOpen:= true
var wallCheck := true
var flashing := false
var hitboxOffX: float

func enter() -> void:
	if as2d.flip_h:
		direction = -1
	else:
		direction = 1
	if as2d.animation == "walk":
		as2d.play("walk")
	pausing = false
	parent.velocity.x = direction * move_speed
	as2d.flip_h = direction < 0
	hitboxOffX = abs(abox.position.x)
	update_ray()
	
func exit() -> void:
	pti.stop()

func process_input(event: InputEvent) -> REnemyState:
	return null

func process_frame(delta: float) -> REnemyState:
	if healthCount <= 0:
		return parent.death_state
		
	if dead:
		dead = false
		
	
	var collider = r2d2.get_collider()
	if collider and collider is Player:
		var player_x = collider.global_position.x
		if player_x >= parent.Lbound and player_x <= parent.Rbound:
			return parent.chase_state
			
	var wall = wall_ray.get_collider()
	if wall and !(wall is Player):
		wallCheck = true
	else:
		wallCheck = false
		
	return null
		
func _on_killzone_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if hitCheck.is_stopped():
		dead = true

func process_physics(delta: float) -> REnemyState:
	if parent.velocity.x != 0 and (!r2d.is_colliding() or wallCheck):
		if wallCheck:
			wallCheck = false
		pausing = true
		parent.velocity.x = 0
		if as2d.animation != "idle":
			as2d.play("idle")
		pti.start(pauseTime)
	elif not pausing:
		parent.velocity.x = direction * move_speed
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	return null
	
func _on_pat_time_timeout() -> void:
	pauseTime = 3.5
	pausing = false
	turn_around()
	as2d.play("walk")
	
func turn_around() -> void:
	direction *= -1
	as2d.flip_h = direction < 0
	abox.position.x = direction * hitboxOffX
	update_ray()
	
func update_ray() -> void:
	r2d.target_position.x = abs(r2d.target_position.x) * direction
	r2d2.target_position.x = abs(r2d2.target_position.x) * direction
	r2h.target_position.x = abs(r2h.target_position.x) * direction
	wall_ray.target_position.x = abs(wall_ray.target_position.x) * direction
