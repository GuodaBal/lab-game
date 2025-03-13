shader_type canvas_item;

uniform float intensity = 0.001; 
void fragment() {
	vec2 uv = vec2(UV.x, UV.y + sin(TIME*10.0*UV.x)*intensity);
	COLOR *= texture(TEXTURE, uv);
	
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
