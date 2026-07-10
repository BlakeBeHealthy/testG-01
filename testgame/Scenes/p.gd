extends AnimatedSprite2D

var flashing = false

func flash_white(): #I am slightly iffy about my understanding of shaders, but it works
	if flashing:
		return
		
	flashing = true
	var mat := self.material as ShaderMaterial
	var count := 0
	
	mat.set_shader_parameter("flash_strength", 1.0)
	await get_tree().create_timer(0.1).timeout
	mat.set_shader_parameter("flash_strength", 0.0)
	flashing = false
