extends EnemyState

@onready var r2d2: RayCast2D = $"../../RayCast2D2"
@onready var r2d: RayCast2D = $"../../RayCast2D"
@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var pti: Timer = $"../../PatTime"
@onready var r2h: RayCast2D = $"../../Hit-Ray"
@onready var abox: Area2D = $"../../Attackbox"
@onready var hit_ray: RayCast2D = $"../../Hit-Ray"

@export var pauseTime := 0.4
@export var chase_state: EnemyState
@export var death_state: EnemyState
@export var strength := 5.0
@export var decay := 2

var direction
var pausing := false  
var dead := false
var justOpen:= true
var flashing := false
var wallCheck := false
var hitboxOffX: float
var combat

func enter() -> void:
	if as2d.flip_h:
		direction = -1
	else:
		direction = 1
	as2d.play("walk")
	pausing = false
	parent.velocity.x = direction * move_speed
	as2d.flip_h = direction < 0
	hitboxOffX = abs(abox.position.x)
	update_ray()
	combat = false

func exit() -> void:
	pti.stop()

func process_input(event: InputEvent) -> EnemyState:
	return null

func process_frame(delta: float) -> EnemyState:
	if healthCount <= 0:
		return parent.death_state
	if parent.hit:
		return parent.hit_state
		
	var collider = r2d2.get_collider() #Test if player is in range and if so, it begins chase
	if collider and collider is Player:
		var player_x = collider.global_position.x
		if player_x >= parent.Lbound and player_x <= parent.Rbound:
			return parent.chase_state
			
	var wall = hit_ray.get_collider()
	if wall and !(wall is Player):
		wallCheck = true
	else:
		wallCheck = false
	return null
	
		
func process_physics(delta: float) -> EnemyState:
	#So this design is temporary, Im gonna eventually make it to where if the left/right bound
	#Is colliding, then they pause and turn around, BUT for now its if the edge detection raycast
	#detects an edge, then they stop and turn around
	
	#Honestly making the patrol pause was a bit of a bitch, but lmk if you need help understanding it all
	if parent.velocity.x != 0 and (!r2d.is_colliding() or wallCheck) and !pausing:
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
