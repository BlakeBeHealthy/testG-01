extends State
@onready var parry_time: Timer = $"../../parryTime"
@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

var parried := false
var parryOver := false
# Called when the node enters the scene tree for the first time.
func enter() -> void:
	parry_time.start()
	as2d.play("parry")
	
func exit() -> void:
	if !parry_time.stopped():
		parry_time.stop()
	parried = false
	
func process_frame(delta: float) -> State:
	if parryOver:
		pass
	
	return null


func _on_parry_zone_area_entered(area: Area2D) -> void:
	parried = true


func _on_parry_time_timeout() -> void:
	parryOver = true
	
func process_physics(delta: float) -> State:
	return null
