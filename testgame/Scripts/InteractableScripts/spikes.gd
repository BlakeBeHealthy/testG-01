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
var player: CharacterBody2D
var hit: bool

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	if !is_instance_valid(Global.player):
		return
	
	direction = (Global.player.global_position.x - self.global_position.x)
	if direction >= 1:
		direction = 1
	elif direction <= -1:
		direction = -1
	
func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	var hittingPlayer: bool = true
	if area.is_in_group("PlayerInteract") and Global.player:
		hittingPlayer = false
	else:
		hittingPlayer = true
		
	hitPlayer(hittingPlayer)
	
func hitPlayer(hitting: bool = true):
	if !hit and !hitting:
		return
	
	player = Global.player
	if hitting and !hit:
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
		
		if Global.maxHealth < 1:
			spawn = false
		
	elif spawn and !hitting:
		FadeS.fade_out()
		await get_tree().create_timer(0.4).timeout
		player.respawn()
		await get_tree().create_timer(0.2).timeout
		FadeS.fade_in()
	hit = false
