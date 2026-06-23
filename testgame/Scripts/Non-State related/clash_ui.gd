extends Control

@onready var bar: ProgressBar = $PB
var drain_speed: float = 2.0
var mash_count: int = 0
var active: bool = false
var waitFade: bool = false
var clash_tween = null
@onready var ct: Timer = $CT
var fade_tween = null

func _ready() -> void:
	Global.clash_over.connect(clash_end)
	Global.Clash = self
	visible = false
	bar.min_value = 0
	bar.max_value = 100
	bar.value = 40
	
func Start(a: String = ""):
	await Global.UI.balloon.playResume(a, true)
	Global.ap.play("clashing")
	barStart()
	
func barStart(fade_before: bool = true, timeout: bool = false, countdown: float = 0.0) -> void:
	mash_count = 0
	bar.value = 40
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
	if win == null:
		print("No outcome!")
		return
		
	Global.clash_won = win
	if waitFade:
		await barFade()
	else:
		barFade()
	Global.clash_over.emit()
	clash_end()
		
func _input(event) -> void:
	if !active:
		return
	if Input.is_action_just_pressed("clash"):
		var power = max(10.0 - mash_count * 0.5, 1.0)
		bar.value += power
		mash_count += 1
	
func _process(delta: float) -> void:
	if !active:
		return
	bar.value -= drain_speed * delta
	if bar.value <= 0:
		endClash(false)
	elif bar.value >= 100:
		endClash(true)


func _on_ct_timeout() -> void:
	endClash(false)

func barFade() -> void:
	if fade_tween:
		fade_tween.kill()
	fade_tween = create_tween()
	fade_tween.tween_property(bar, "modulate:a", 0.0, 0.3)
	await fade_tween.finished
	
func clash_end():
	if Global.clash_won:
		Global.ap.play("clashW")
	else:
		Global.ap.play("ClashL")
	await Global.ap.animation_finished
	await Global.UI.balloon.Resume("clash_result")
