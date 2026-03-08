extends EnemyState

@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var killzone: Area2D = $"../../Killzone"
@onready var hitB: CollisionShape2D = $"../../CollisionShape2D"
@onready var r2d: RayCast2D = $"../../RayCast2D"
@onready var r2d2: RayCast2D = $"../../RayCast2D2"
@onready var t5: Timer = $"../../attackTim"
@onready var t4: Timer = $"../../AITIME"
@onready var t3: Timer = $"../../idleTime"
@onready var t2: Timer = $"../../AttackTimer"
@onready var t1: Timer = $"../../PatTime"
@onready var abox: Area2D = $"../../AttackHitBox"
@onready var r2h: RayCast2D = $"../../Hit-Ray"

var flashing = false

func enter() -> void:
	flash_white()
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
	t1.stop()
	t2.stop()
	t3.stop()
	t4.stop()
	t5.stop()
	as2d.play("death")
	
func exit() -> void:
	pass

func process_input(event: InputEvent) -> EnemyState:
	return null

func process_frame(delta: float) -> EnemyState:
	return null

func process_physics(delta: float) -> EnemyState:
	return null
	
func flash_white():
	if flashing:
		return
		
	flashing = true
	var mat := as2d.material as ShaderMaterial
	var count := 0
	
	mat.set_shader_parameter("flash_strength", 1.0)
	await get_tree().create_timer(0.1).timeout
	mat.set_shader_parameter("flash_strength", 0.0)
	flashing = false
