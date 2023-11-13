shader_type canvas_item;

uniform float amplitude : hint_range(0.0, 0.1) = 0.03;
uniform float frequency : hint_range(0.0, 15.0) = 1.0;
uniform float time_scale : hint_range(0.0, 5.0) = 0.1;

void fragment() {
	vec2 uv = UV;
	
	uv.y += amplitude * sin(uv.y * frequency + TIME * time_scale);
	uv.x += amplitude * sin(uv.x * frequency + TIME * time_scale);
	
	COLOR = texture(TEXTURE,uv);
}
