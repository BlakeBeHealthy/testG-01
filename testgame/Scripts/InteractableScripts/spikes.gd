extends Area2D

@export var spawn: bool 
@export var dmg: int
@export var stre: float
@export var StunTime: float
@export var TimeScale: float
@export var dur: float
@export var CAMShake: float
@export var shakeDur: float
@export var SpikeNumber: String
@onready var as2d: AnimatedSprite2D = $AnimatedSprite2D

var direction: int 
var player

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	direction = (Global.player.global_position.x - self.global_position.x)
	
	if direction >= 1:
		direction = 1
	elif direction <= -1:
		direction = -1
	
func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.get_parent() is Player:
		print("Checkpoint recieved")
	print("hitting")
	hitPlayer()
	
	
func hitPlayer():
	player = Global.player
	
	print("Hitting Sent")
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
		FadeS.fade_out()
		await get_tree().create_timer(0.4).timeout
		print("Spawning")
		player.respawn()
		await get_tree().create_timer(0.2).timeout
		FadeS.fade_in()
