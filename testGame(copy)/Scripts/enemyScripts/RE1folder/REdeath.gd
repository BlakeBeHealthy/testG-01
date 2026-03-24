extends REnemyState

@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var killzone: Area2D = $"../../Killzone"
@onready var abox: Area2D = $"../../AttackHitBox"
@onready var hitB: CollisionShape2D = $"../../CollisionShape2D"
@onready var r2d2: RayCast2D = $"../../RayCast2D2"
@onready var r2d: RayCast2D = $"../../RayCast2D"
@onready var r2h: RayCast2D = $"../../Hit-Ray"
@onready var ati: Timer = $"../../attackTim"
@onready var pti: Timer = $"../../PatTime"
@onready var aiti: Timer = $"../../AITIME"
@onready var atti: Timer = $"../../AttackTimer"


func enter() -> void:
	parent.velocity = Vector2.ZERO
	parent.set_physics_process(false)
	r2d.enabled = false
	r2d2.enabled = false
	r2h.enabled = false
	hitB.disabled = true
	abox.monitorable = false
	abox.monitoring = false
	killzone.monitorable = false
	killzone.monitoring = false
	ati.stop()
	pti.stop()
	aiti.stop()
	atti.stop()
	as2d.play("death")
	
func exit() -> void:
	pass

func process_input(event: InputEvent) -> REnemyState:
	return null

func process_frame(delta: float) -> REnemyState:
	return null

func process_physics(delta: float) -> REnemyState:
	return null
