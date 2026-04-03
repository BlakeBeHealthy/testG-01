extends TEnemyState
@onready var attack_hitbox: Area2D = $"../../AttackHitbox"
@onready var hurt_box: Area2D = $"../../HurtBox"
@onready var detection_box: Area2D = $"../../DetectionBox"
@onready var attack_box: Area2D = $"../../AttackBox"
@onready var ray_cast_2d: RayCast2D = $"../../RayCast2D"
@onready var pti: Timer = $"../../pti"
@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

func enter() -> void:
	pass

func exit() -> void:
	pass

func process_input(event: InputEvent) -> TEnemyState:
	return null

func process_frame(delta: float) -> TEnemyState:
	return null

func process_physics(delta: float) -> TEnemyState:
	return null
