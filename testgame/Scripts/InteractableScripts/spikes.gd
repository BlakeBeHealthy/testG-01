extends Area2D

@onready var spikes: Area2D = $"."
@export var spawn: bool 
@export var dmg: int = 1
@export var stre: float = 200
@export var StunTime: float = 0.6
@export var TimeScale: float = 0.001
@export var dur: float = 0.01
@export var CAMShake: float = 0.02
@export var shakeDur: float = 0.02
@export var SpikeNumber: String
@onready var as2d: AnimatedSprite2D = $AnimatedSprite2D

var direction: int = 0
var health: int = 0
var player: CharacterBody2D
var hit: bool = false
var spawning: bool = false

func _ready() -> void:
	Global.spawning = false
	
func _process(delta: float) -> void:
	if !is_instance_valid(Global.player):
		return
	
	player = Global.player
	if player.invincible and !hit:
		hit = true
		spikes.set_collision_mask_value(7, true)
	elif hit:
		hit = false
		spikes.set_collision_mask_value(7, false)
		
	direction = (Global.player.global_position.x - self.global_position.x)
	if direction >= 1:
		direction = 1
	elif direction <= -1:
		direction = -1
	
func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if !hit:
		hitPlayer()
		
func hitPlayer():
	if !hit and !Global.spawning:
		hit = true
		player.hit(
				dmg,
				direction,
				stre,
				StunTime,
				TimeScale,
				dur,
				CAMShake,
				shakeDur,
		)
		if spawn:
			spawnPlayer()
		
func spawnPlayer():
	if !Global.spawning:
		Global.spawning = true
		FadeS.fade_out()
		await get_tree().create_timer(0.4).timeout
		if Global.saveData.maxHealth <= 0:
			return
		player.respawn()
		await player.landed
		await get_tree().create_timer(0.3).timeout
		Global.spawning = false
		player.control_locked = false
		FadeS.fade_in(0.8)
