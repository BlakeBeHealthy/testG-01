class_name Fade extends CanvasLayer

#This is just to add the fade in/out
@onready var c_r: ColorRect = $cR
@onready var aP: AnimationPlayer = $AnimationPlayer

var fade: bool = false

func _ready():
	if c_r == null:
		return
	
	c_r.visible = false
#Fade functions are called by other scripts, this script is global, this is just the
	#actual logic of it
func fade_out(speed: float = 1.0, wait: bool = false):
	c_r.visible = true
	aP.play("fadeOut", -1, speed)
	fade = true
	if wait:
		await aP.animation_finished
	
	
func fade_in(speed: float = 1.0, wait: bool = false):
	c_r.visible = true
	aP.play("fadeIn", -1, speed)
	aP.animation_finished.connect(_on_fade_in_finished)
	if wait:
		await aP.animation_finished
		print("finished")
	
#Ending the fade
func _on_fade_in_finished(anim_name: String) -> void:
	if anim_name == "fadeIn":
		fade = false
		c_r.visible = false
		aP.animation_finished.disconnect(_on_fade_in_finished)

	
	

	
	
