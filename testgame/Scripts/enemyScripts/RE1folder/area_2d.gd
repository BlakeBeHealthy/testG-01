extends Area2D

@onready var as2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var c2d: CollisionShape2D = $CollisionShape2D
@onready var a2d: Area2D = $"."

@export var knockback_strength := 200
@export var stun_time := 0.2
@export var timeStop := 0.0
@export var duration := 0.2
@export var camShakeStrength := 2
@export var shakeDuration := 0.2


var speed
var direction

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	if direction >= 0:
		as2d.flip_h = false
		as2d.position.x = -1
	if direction <= 0:
		as2d.flip_h = true
		as2d.position.x = 1
	position.x += speed * direction * delta
	
func _on_animated_sprite_2d_frame_changed() -> void:
	if as2d == null:
		return
	
	if as2d.animation != "blast":
		pass
		
	if as2d.frame == 4:
		as2d.visible = false
		queue_free()

func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.get_parent() is Player:
		var player = area.get_parent()
		if !player.invincible:
			as2d.play("blast")
			a2d.monitorable = false
			a2d.monitoring = false
			c2d.disabled = true
			player.hit(
				sign(player.global_position.x - global_position.x),
				knockback_strength,
				stun_time,
				timeStop,
				duration,
				camShakeStrength,
				shakeDuration
			)
