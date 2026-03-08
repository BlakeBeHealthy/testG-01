extends REnemyState

@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var r2d2: RayCast2D = $"../../RayCast2D2"
@onready var r2d: RayCast2D = $"../../RayCast2D"
@onready var r2h: RayCast2D = $"../../Hit-Ray"
@onready var pti: Timer = $"../../PatTime"
@onready var abox: Area2D = $"../../Attackbox"
@onready var flash_mat := as2d.material as ShaderMaterial

@export var pauseTime := 0.4
@export var chase_state: REnemyState
@export var death_state: REnemyState

var direction: int = -1
var pausing := false  
var dead := false
var justOpen:= true
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
		return death_state
	
	
	var collider = r2d2.get_collider()
	if collider and collider is Player:
		var player_x = collider.global_position.x
		if player_x >= parent.Lbound and player_x <= parent.Rbound:
			return chase_state
	return null
		
func _on_killzone_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	flash_white()
	healthCount -= 1

func process_physics(delta: float) -> REnemyState:
	if parent.velocity.x != 0 and !r2d.is_colliding():
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
