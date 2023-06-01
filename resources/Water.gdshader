shader_type canvas_item;

uniform float amplitude = 0.2;
uniform float frequency = 12.0;
uniform vec2 speed = vec2(0.7, 0.7);
uniform sampler2D texture;
uniform mat3 transform;

void fragment() {
    vec2 uv = UV;
    
    // Transform the UV coordinates to screen space
    vec2 screen_uv = (vec3(uv, 1.0) * transform).xy;
    
    // Apply the distortion effect
    screen_uv += sin((screen_uv.y * frequency + TIME) * speed) * amplitude;
    
    // Transform the distorted screen UV coordinates back to object's local space
    vec2 distorted_uv = (vec3(screen_uv, 1.0) * inverse(transform)).xy;
    
    // Get the color from the original texture
    COLOR = texture(TEXTURE, distorted_uv);
}