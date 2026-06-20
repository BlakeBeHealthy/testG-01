extends Area2D

@onready var as2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var a2d: Area2D = $"."
@onready var c2d: CollisionShape2D = $CollisionShape2D


@export var knockback_strength := 200
@export var stun_time := 0.2
@export var timeStop := 0.0
@export var duration := 0.2
@export var camShakeStrength := 2
@export var shakeDuration := 0.2
@export var dmg := 1

var speed: float = 300
var direction: float = 0
var y_direction: float = -1
var rotate: float = 0
var yChange: bool = false
var x: bool = true
var hit: bool = false

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	if direction >= 0:
		as2d.flip_h = false
		as2d.position.x = -1
	if direction <= 0:
		as2d.flip_h = true
		as2d.position.x = 1
	as2d.rotation_degrees = rotate
	c2d.rotation_degrees = rotate
	if !hit:
		position.x += speed * direction * delta
	else:
		position.x = position.x
	if direction == 0 and x:
		x = false
		c2d.position.x += 2
	if yChange:
		position.y += speed * y_direction * delta
		
func _on_animated_sprite_2d_frame_changed() -> void:
	
	if as2d == null or as2d.animation != "hit":
		return
		
	if as2d.frame == 3:
		as2d.visible = false
		queue_free()

func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.get_parent() is Player:
		var player = area.get_parent()
		if !player.invincible:
			hit = true
			as2d.play("hit")
			a2d.monitorable = false
			a2d.monitoring = false
			c2d.disabled = true
			player.hit(
				dmg,
				sign(player.global_position.x - global_position.x),
				knockback_strength,
				stun_time,
				timeStop,
				duration,
				camShakeStrength,
				shakeDuration
			)
