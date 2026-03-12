class_name Fade extends CanvasLayer

#This is just to add the fade in/out

@onready var c_r: ColorRect = $cR
@onready var aP: AnimationPlayer = $AnimationPlayer #I probably should use animation player more but I like AnimatedSprite2d

func _ready():
	if c_r == null:
		return
	
	c_r.visible = false
#Fade functions are called by other scripts, this script is global, this is just the
	#actual logic of it
func fade_out():
	c_r.visible = true
	aP.play("fadeOut")
	
func fade_in():
	c_r.visible = true
	aP.play("fadeIn")
	aP.animation_finished.connect(_on_fade_in_finished)
#Ending the fade
func _on_fade_in_finished(anim_name: String) -> void:
	if anim_name == "fadeIn":
		c_r.visible = false
		aP.animation_finished.disconnect(_on_fade_in_finished)

	
	

	
	
