shader_type canvas_item;

uniform vec4 first_color: source_color;
uniform vec4 second_color: source_color;


void fragment() {
	vec4 curr_color = texture(TEXTURE, UV);
	// Fade between first_color and second_color based on vertical position (UV.y)
	vec4 gradient_color = mix(first_color, second_color, UV.y);
	// Make gradient more predominant by adjusting the mix ratio (0.7 gradient, 0.3 texture)
	COLOR = mix(gradient_color, gradient_color * curr_color, 0.9);
}