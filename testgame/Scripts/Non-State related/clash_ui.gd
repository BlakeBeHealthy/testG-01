extends Control

@onready var bar: ProgressBar = $PB
var drain_speed: float = 2.0
var mash_count: int = 0
var active: bool = false
var clashingNow : bool = false
var waitFade: bool = false
var clash_tween = null
@onready var ct: Timer = $CT
var fade_tween = null
var winAnim: String = ""
var loseAnim: String = ""
var DM3Check: String = ""

func _ready() -> void:
	Global.Clash = self
	visible = false
	bar.min_value = 0
	bar.max_value = 100
	bar.value = 40
	
func Start(preAnim: String, clashAnim: String, winA: String, loseA: String, DM3Checkpoint: String, resetAnim: String):
	if FadeS.fade:
		Global.camera.reset(0.1)
		FadeS.fade_in(1.0, true)
		
		
	clashingNow = true
	winAnim = winA
	loseAnim = loseA
	DM3Check = DM3Checkpoint
	await Global.UI.balloon.playResume(preAnim, true)
	Global.camera.start_shake(2.0)
	Global.ap.play(clashAnim)
	Global.inputBlocked = true
	barStart()
	
	while clashingNow:
		await get_tree().process_frame
		
	if Global.clash_won:
		Global.inputBlocked = false
		Global.UI.balloon.playResume(winAnim, false, false, DM3Check)
	else:
		Global.ap.play(loseAnim)
		await Global.ap.animation_finished
		await FadeS.fade_out(0.8, true)
		Start(preAnim, clashAnim, winA, loseA, DM3Checkpoint, resetAnim)
		
func barStart(fade_before: bool = true, timeout: bool = false, countdown: float = 0.0) -> void:
	mash_count = 0
	bar.value = 40
	bar.modulate.a = 1.0
	visible = true
	scale = Vector2(0, 0)
	if clash_tween:
		clash_tween.kill()
	clash_tween = create_tween()
	clash_tween.tween_property(self, "scale", Vector2(1,1), 0.3)
	await clash_tween.finished
	active = true
	waitFade = fade_before
	if timeout:
		ct.start(countdown)
	
	
func endClash(win: bool) -> void:
	active = false
	Global.camera.shake_end()
	if win == null:
		print("No outcome!")
		return
	
	Global.clash_won = win
	if waitFade:
		await barFade()
	else:
		barFade()
	clashingNow = false
	Global.clash_over.emit()
		
func _input(event) -> void:
	if !active:
		return
	if Input.is_action_just_pressed("jump"):
		var power = max(10.0 - mash_count * 0.5, 1.0)
		bar.value += power
		mash_count += 1
	
func _process(delta: float) -> void:
	if !active:
		return
		
	if bar.value >= 98:
		bar.value = 100
	else:
		bar.value -= drain_speed * delta
	if bar.value <= 0:
		endClash(false)
	elif bar.value >= 98:
		endClash(true)
	
func _on_ct_timeout() -> void:
	endClash(false)

func barFade() -> void:
	if fade_tween:
		fade_tween.kill()
	fade_tween = create_tween()
	fade_tween.tween_property(bar, "modulate:a", 0.0, 0.3)
	await fade_tween.finished
