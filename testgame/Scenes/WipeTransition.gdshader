shader_type canvas_item;

uniform float progress : hint_range(-0.2, 1.2) = 0.0;
uniform float edge_width = 0;
uniform float horizontal_weight = 0;
uniform float vertical_weight = 0;

void fragment() {
	float edge = 1.0 - edge_width;
	float pos = UV.x * horizontal_weight + (1.0 - UV.y) * vertical_weight;
	float alpha = smoothstep((progress - edge), (progress + edge), pos);
	COLOR = vec4(COLOR.rgb, COLOR.a * (1.0 - alpha));
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
