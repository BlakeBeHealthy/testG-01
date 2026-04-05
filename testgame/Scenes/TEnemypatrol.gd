extends TEnemyState

@onready var r2d: RayCast2D = $"../../RayCast2D"
@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var pti: Timer = $"../../pti"

@export var pauseTime := 0.4
@export var strength := 5.0
@export var decay := 2

var pausing := false  
var dead := false
var justOpen:= true
var flashing := false
var hitboxOffX: float
var combat

func enter() -> void:
	as2d.play("idle")
	pausing = false
	parent.velocity.x = parent.dir * move_speed
	as2d.flip_h = parent.dir < 0
	combat = false

func exit() -> void:
	pti.stop()

func process_input(event: InputEvent) -> TEnemyState:
	return null

func process_frame(delta: float) -> TEnemyState:
	if parent.healthCount <= 0:
		return parent.death_state
	if parent.hit:
		return parent.hit_state
	if parent.attack:
		return parent.attack_state
	return null

func process_physics(delta: float) -> TEnemyState:
	#So this design is temporary, Im gonna eventually make it to where if the left/right bound
	#Is colliding, then they pause and turn around, BUT for now its if the edge detection raycast
	#detects an edge, then they stop and turn around
	
	#Honestly making the patrol pause was a bit of a bitch, but lmk if you need help understanding it all
	if parent.velocity.x != 0 and !r2d.is_colliding() and !pausing:
		pausing = true
		parent.velocity.x = 0
		if as2d.animation != "idle":
			as2d.play("idle")
		pti.start(pauseTime)
	elif not pausing:
		parent.velocity.x = parent.dir * move_speed
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	return null
	
func turn_around() -> void:
	parent.dir *= -1
	r2d.target_position.x = abs(r2d.target_position.x) * -parent.dir


func _on_pti_timeout() -> void:
	pauseTime = 3.5
	pausing = false
	turn_around()
