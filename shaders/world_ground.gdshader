shader_type canvas_item;

uniform float aberration_amount : hint_range(0.0, 0.1) = 0.005;
uniform float speed : hint_range(0.0, 5.0) = 1.0;
uniform vec4 tint_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float tint_strength : hint_range(0.0, 1.0) = 0.5;

void fragment() {
	// Use UV instead of SCREEN_UV to work with individual tile cells
	vec2 uv = UV;
	float time_offset = TIME * speed;

	// Create shifting offset vectors for each color channel
	vec2 red_offset = vec2(cos(time_offset * 0.8) * aberration_amount, sin(time_offset * 0.7) * aberration_amount);
	vec2 green_offset = vec2(cos(time_offset * 0.5 + 1.2) * aberration_amount, sin(time_offset * 0.6) * aberration_amount);
	vec2 blue_offset = vec2(cos(time_offset * 0.7 + 2.5) * aberration_amount, sin(time_offset * 0.8) * aberration_amount);

	// Sample texture at different offsets for each channel
	float r = texture(TEXTURE, uv + red_offset).r;
	float g = texture(TEXTURE, uv + green_offset).g;
	float b = texture(TEXTURE, uv + blue_offset).b;
	float a = texture(TEXTURE, uv).a;

	// Create base color with chromatic aberration
	vec4 aberrated_color = vec4(r, g, b, a);

	// Apply tint
	vec4 final_color = mix(aberrated_color, aberrated_color * tint_color, tint_strength);

	// Set output color
	COLOR = final_color;
}