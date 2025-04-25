shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(0.2, 0.5, 0.9, 1.0);
uniform float pulse_speed : hint_range(0.1, 5.0) = 1.0;
uniform float glow_intensity : hint_range(0.1, 2.0) = 0.5;
uniform float star_density : hint_range(0.1, 10.0) = 3.0;

float random(vec2 uv) {
	return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453123);
}

void fragment() {
	// Get base texture color
	vec4 base_color = texture(TEXTURE, UV);

	// Create pulsing glow effect
	float pulse = (sin(TIME * pulse_speed) * 0.5 + 0.5) * glow_intensity;

	// Add subtle stars
	float star = 0.0;
	if (random(UV) > (1.0 - 0.002 * star_density)) {
		star = pow(random(UV + TIME * 0.1), 20.0) * pulse * 5.0;
	}

	// Mix original color with space effects
	vec4 final_color = base_color;

	// Add edge glow effect
	float edge = 1.0 - smoothstep(0.4, 0.5, distance(UV, vec2(0.5)));
	final_color = mix(final_color, glow_color, edge * pulse * 0.3);

	// Add stars
	final_color.rgb += vec3(star);

	COLOR = final_color;
}