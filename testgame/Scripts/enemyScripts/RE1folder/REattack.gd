extends REnemyState

@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var ati: Timer = $"../../attackTim"
@onready var r2h: RayCast2D = $"../../Hit-Ray"
@onready var aiti: Timer = $"../../AITIME"
@onready var killzone: Area2D = $"../../Killzone"
@onready var abox: Area2D = $"../../Attackbox"
@onready var bullet = preload("res://Scenes/fireball.tscn")

@export var death_state: REnemyState
@export var patrol_state: REnemyState
@export var chase_state: REnemyState
@export var knockback_strength: float
@export var knockback_stunTime: float
@export var hit_timeStop: float
@export var hit_duration: float

var player
var waitT 
var flashing := false
var dead = false
var bulletCheck

func enter() -> void:
	player = Global.get_player()
	aiti.start()
	as2d.play("attack")
	waitT = true
	ati.start()

func exit() -> void:
	ati.stop()

func process_input(event: InputEvent) -> REnemyState:
	return null

func process_frame(delta: float) -> REnemyState:
	if !waitT:
		return chase_state
		
	if healthCount <= 0:
		return death_state
		
	return null
	
func _on_animated_sprite_2d_frame_changed() -> void:
	if as2d.animation != "attack":
		return
		
	if as2d.frame == 6:
		bulletCheck = true
		
func process_physics(delta: float) -> REnemyState:
	if bulletCheck:
		var bullet_temp = bullet.instantiate()
		bullet_temp.direction = sign(player.global_position.x - parent.global_position.x)
		bullet_temp.global_position = parent.global_position + Vector2(3 * bullet_temp.direction, 0)
		bullet_temp.speed = 100
		add_child(bullet_temp)
		bulletCheck = false
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


func _on_attack_tim_timeout() -> void:
	waitT = false

func _on_aitime_timeout() -> void:
	as2d.play("idle")


func _on_attackbox_area_entered(area: Area2D) -> void:
	var player = area.get_parent()
	if !player.invincible:
		knockback(player)
	
func knockback(player):
	player.state_machine.change_state(player.hit_state) # switch state first
	# Call knockback function with parameters
	player.state_machine.current_state.apply_knockback(
		sign(player.global_position.x - parent.global_position.x),
		knockback_strength,   # strength
		knockback_stunTime,
		hit_timeStop,
		hit_duration,
		0,
		0
		)
		
func _on_killzone_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	flash_white()
	healthCount -= 1
