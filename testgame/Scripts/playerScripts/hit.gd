extends State

@onready var as2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var timer: Timer = $"../../Timer"
@onready var tim_2: Timer = $"../../tim2"
@onready var a2d: Area2D = $"../../Area2D"
@onready var hitstuntimer: Timer = $"../../hitstuntimer"
@onready var it3: Timer = $"../../InvincibleTime"
@onready var a2d2: Area2D = $"../../Area2D2"


var newHealth := 0
var hit_over
var dead := false
var dead2 := false
var deadCount = 3
var timeSlow := false
var flashing := false

func enter() -> void:
	if !parent.invincible:
		parent.health -= parent.damage
	if parent.health <= 0:
		dead = true
	flash_white()
	apply_knockback()
	a2d2.monitoring = false
	a2d2.monitorable = false
	it3.start()
	hit_over = false
	parent.playerHit.emit(deadCount)
func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	if hit_over and !dead:
		parent.takeHit = false
		if Input.is_action_just_pressed('jump') and parent.is_on_floor():
			return parent.jump_state
		elif Input.is_action_just_pressed('runL') or Input.is_action_just_pressed('runR'):
			return parent.run_state
		elif parent.attackCheck:
			return parent.attack_state
		else:
			return parent.idle_state
			
	if dead2:
		return parent.death_state
			
	return null
	
func _on_hitstuntimer_timeout() -> void:
	hit_over = true
	
func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	return null
	

func apply_knockback():
	if !parent.invincible:
		apply_timeSlow(parent.TScale, parent.dur)
		Global.get_camera().start_shake(parent.CAMshake, parent.shakeDur)
		if !dead:
			parent.velocity.x = parent.dir * parent.stre
			parent.velocity.y = -parent.stre * 0.5
			parent.invincible = true
			hitstuntimer.start(parent.stunT)
		as2d.play("hit")
		
		if dead:
			dead2 = true
			
func apply_timeSlow(timeScale: float, duration: float) -> void:
	if timeSlow:
		return
		
	timeSlow = true
	Engine.time_scale = timeScale
	await get_tree().create_timer(duration, false, false, true).timeout
	Engine.time_scale = 1.0
	timeSlow = false

func flash_white(): #I am slightly iffy about my understanding of shaders, but it works
	if flashing:
		return
		
	flashing = true
	var mat := as2d.material as ShaderMaterial
	var count := 0
	
	mat.set_shader_parameter("flash_strength", 1.0)
	await get_tree().create_timer(0.1).timeout
	mat.set_shader_parameter("flash_strength", 0.0)
	flashing = false
	
	if !dead:
		while count <= 8:
			as2d.visible = false
			await get_tree().create_timer(0.1).timeout
			as2d.visible = true
			await get_tree().create_timer(0.1).timeout
			count += 1
			
	#Player invincibility
func _on_invincible_time_timeout() -> void:
	parent.invincible = false
	a2d2.monitoring = true
	a2d2.monitorable = true
