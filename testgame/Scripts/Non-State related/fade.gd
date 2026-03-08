class_name Fade extends CanvasLayer

@onready var c_r: ColorRect = $cR
@onready var aP: AnimationPlayer = $AnimationPlayer

func _ready():
	if c_r == null:
		return
	
	c_r.visible = false
	
func fade_out():
	c_r.visible = true
	aP.play("fadeOut")
	
func fade_in():
	c_r.visible = true
	aP.play("fadeIn")
	aP.animation_finished.connect(_on_fade_in_finished)

func _on_fade_in_finished(anim_name: String) -> void:
	if anim_name == "fadeIn":
		c_r.visible = false
		aP.animation_finished.disconnect(_on_fade_in_finished)

	
	

	
	
