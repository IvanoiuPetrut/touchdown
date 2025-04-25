shader_type canvas_item;

uniform vec4 color_a: source_color = vec4(0.2, 0.5, 1.0, 1.0);
uniform vec4 color_b: source_color = vec4(0.8, 0.2, 1.0, 1.0);
uniform float speed: hint_range(0.1, 5.0) = 1.0;
uniform float pulse_intensity: hint_range(0.0, 1.0) = 0.2;
uniform float line_thickness: hint_range(0.0, 1.0) = 0.6;
uniform float wave_amplitude: hint_range(0.0, 0.3) = 0.1;
uniform float wave_frequency: hint_range(1.0, 10.0) = 5.0;
uniform float wave_speed: hint_range(0.1, 5.0) = 2.0;

void fragment() {
	// Called for every pixel the material is visible on.

	// Flowing gradient effect
	float time_offset = TIME * speed;
	float position = UV.x + time_offset;

	// Create gradient between two colors
	vec4 gradient_color = mix(color_a, color_b, fract(position));

	// Add subtle pulsing effect
	float pulse = sin(TIME * 2.0) * pulse_intensity;
	gradient_color.a *= (1.0 + pulse);

	// Create wave effect
	float wave = sin(UV.x * wave_frequency + TIME * wave_speed) * wave_amplitude;
	float adjusted_y = UV.y + wave;

	// Create line with soft edges and wave effect
	float dist_from_center = abs(adjusted_y - 0.5) * 2.0;
	float line_alpha = smoothstep(line_thickness, line_thickness + 0.1, 1.0 - dist_from_center);

	// Apply final color and alpha
	COLOR = gradient_color;
	COLOR.a *= line_alpha;
}
