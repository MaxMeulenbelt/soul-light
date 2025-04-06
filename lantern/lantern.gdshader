shader_type canvas_item;
uniform sampler2D glow_texture;
uniform float glow_strength = 1.0;
uniform float glow_speed = 1.0;

void fragment() {
COLOR = texture(TEXTURE, UV);
float time = cos(TIME * glow_speed);
COLOR = COLOR + (texture(glow_texture, UV) * time * glow_strength);
}