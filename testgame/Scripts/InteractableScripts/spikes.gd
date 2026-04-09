extends Area2D

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

var direction: int 
var player
var hit: bool

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	direction = (Global.player.global_position.x - self.global_position.x)
	
	if direction >= 1:
		direction = 1
	elif direction <= -1:
		direction = -1
	
func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	hitPlayer()
	
func hitPlayer():
	if hit:
		return
		
	hit = true
	player = Global.player
	
	
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
	if player.health <= 1:
		spawn = false
		
	elif spawn:
		FadeS.fade_out()
		await get_tree().create_timer(0.4).timeout
		player.respawn()
		await get_tree().create_timer(0.2).timeout
		FadeS.fade_in()
	hit = false
