shader_type canvas_item;

uniform vec4 first_color: source_color;
uniform vec4 second_color: source_color;


void fragment() {
	vec4 curr_color = texture(TEXTURE, UV);
	// Fade between first_color and second_color based on vertical position (UV.y)
	vec4 gradient_color = mix(first_color, second_color, UV.y);
	COLOR = gradient_color * curr_color;
}