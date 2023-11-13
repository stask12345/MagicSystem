shader_type canvas_item;

uniform vec4 color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
	vec4 pixel = texture(TEXTURE,UV);
	float brightness = float(((pixel.r)*0.3) + ((pixel.g) * 0.6) + ((pixel.b)*0.1));
	vec4 greyScale = vec4(brightness,brightness,brightness,pixel.a);
	
	COLOR = greyScale * color;
}
