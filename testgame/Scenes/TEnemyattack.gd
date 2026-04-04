extends TEnemyState

@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var t3: Timer = $"../../attackTimer"
@onready var at3: Timer = $"../../AItimer"
@onready var abox: Area2D = $"../../AttackBox"


@export var knockback_strength: float
@export var knockback_stunTime: float
@export var hit_timeStop: float
@export var hit_duration: float
@export var camShakeStrength: float
@export var shakeDuration: float
@export var dmg: int

var waitT 
var flashing := false
var dead = false
var attDone = false


func enter() -> void:
	var player = Global.player
	
	at3.start()
	as2d.play("attack")
	waitT = true
	t3.start()

func exit() -> void:
	t3.stop()
	if abox.monitorable != false:
		abox.monitorable = false
	if abox.monitoring != false:
		abox.monitoring = false
	if parent.hit:
		parent.hit = false
	attDone = true

func process_input(event: InputEvent) -> TEnemyState:
	return null

func process_frame(delta: float) -> TEnemyState:
	if parent.parried:
		return parent.stun_state
		
	if !waitT:
		return parent.chase_state
		
	if healthCount <= 0:
		return parent.death_state
		
	return null
	
func _on_animated_sprite_2d_frame_changed() -> void:
	if as2d.animation != "attack" or parent.parried: 
		return
		
	if as2d.frame == 6:
		print("HITTING PLAYER")
		abox.monitorable = true
		abox.monitoring = true
	elif as2d.frame == 7:
		abox.monitorable = false
		abox.monitoring = false
	elif as2d.frame == 14:
		attDone = true
		
		
func process_physics(delta: float) -> TEnemyState:
	return null

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
	
func knockback(player):
	player.hit(
		dmg,
		sign(player.global_position.x - parent.global_position.x),
		knockback_strength,   # strength
		knockback_stunTime,
		hit_timeStop,
		hit_duration,
		camShakeStrength,
		shakeDuration
		)
	
func stun():
	print("EMMITED")
	parent.parried = true
	
func _on_hurt_box_area_entered(area: Area2D) -> void:
	flash_white()
	healthCount -= 1



func _on_attack_box_area_entered(area: Area2D) -> void:
	var player = area.get_parent()
	if player.parryCheck:
		pass
	elif !player.invincible:
		knockback(player)


func _on_attack_timer_timeout() -> void:
	waitT = false
