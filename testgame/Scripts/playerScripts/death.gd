extends State
@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var t3: Timer = $"../../InvincibleTime"
@onready var t1: Timer = $"../../Timer"
@onready var t2: Timer = $"../../jumpBuff"
@onready var t4: Timer = $"../../hitstuntimer"
@onready var t5: Timer = $"../../attackDelay"
@onready var hurtbox: Area2D = $"../../Area2D2"


func enter() -> void:
	#Make sure every timer is stopped. and the hurtbox is disabled.
	t1.stop()
	t2.stop()
	t3.stop()
	t4.stop()
	t5.stop()
	hurtbox.monitorable = false
	hurtbox.monitoring = false
	as2d.play("death")
	
	await get_tree().create_timer(0.5).timeout
	if !FadeS.fade:
		FadeS.fade_out()
	await get_tree().create_timer(1).timeout
	Gameplay.game_respawn()
	print("scene")
	SceneM.load_level(Global.saveData.checkpoint_scene) #Set up first level load and put a checkpoint in level 2
	Global.saveData.maxHealth = 3
	Global.cutsceneStarted = true
	
func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	return null
