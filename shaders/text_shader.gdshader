shader_type canvas_item;

uniform float aberration_amount : hint_range(0.0, 0.1) = 0.01;
uniform vec4 glow_color : source_color = vec4(0.1, 0.4, 1.0, 1.0);
uniform float glow_intensity : hint_range(0.0, 1.0) = 0.4;
uniform float time_scale : hint_range(0.0, 2.0) = 0.2;
uniform float noise_scale : hint_range(0.0, 10.0) = 5.0;
uniform float distortion_strength : hint_range(0.0, 0.1) = 0.005;

// Simplex 2D noise
vec3 permute(vec3 x) { return mod(((x*34.0)+1.0)*x, 289.0); }

float snoise(vec2 v) {
  const vec4 C = vec4(0.211324865405187, 0.366025403784439,
           -0.577350269189626, 0.024390243902439);
  vec2 i  = floor(v + dot(v, C.yy));
  vec2 x0 = v -   i + dot(i, C.xx);
  vec2 i1;
  i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
  vec4 x12 = x0.xyxy + C.xxzz;
  x12.xy -= i1;
  i = mod(i, 289.0);
  vec3 p = permute(permute(i.y + vec3(0.0, i1.y, 1.0))
  + i.x + vec3(0.0, i1.x, 1.0));
  vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy),
    dot(x12.zw,x12.zw)), 0.0);
  m = m*m;
  m = m*m;
  vec3 x = 2.0 * fract(p * C.www) - 1.0;
  vec3 h = abs(x) - 0.5;
  vec3 ox = floor(x + 0.5);
  vec3 a0 = x - ox;
  m *= 1.79284291400159 - 0.85373472095314 * (a0*a0 + h*h);
  vec3 g;
  g.x = a0.x * x0.x + h.x * x0.y;
  g.yz = a0.yz * x12.xz + h.yz * x12.yw;
  return 130.0 * dot(m, g);
}

void fragment() {
	// Called for every pixel the material is visible on.

	// Time-based animation
	float time = TIME * time_scale;

	// Get base UV with subtle distortion
	vec2 uv = UV;
	float noise = snoise(uv * noise_scale + time * 0.1) * distortion_strength;
	uv += vec2(noise, noise * 0.5);

	// Chromatic aberration effect
	float r = texture(TEXTURE, uv + vec2(aberration_amount, 0.0)).r;
	float g = texture(TEXTURE, uv).g;
	float b = texture(TEXTURE, uv - vec2(aberration_amount, 0.0)).b;
	float a = texture(TEXTURE, uv).a;

	// Combine channels with original alpha
	vec4 text_color = vec4(r, g, b, a);

	// Apply subtle glow effect
	float glow_mask = a;
	vec4 glow_effect = glow_color * glow_intensity * glow_mask;

	// Add subtle pulsating effect to the glow
	float pulse = (sin(time * 3.0) * 0.5 + 0.5) * 0.3 + 0.7;
	glow_effect *= pulse;

	// Combine text with glow
	COLOR = mix(glow_effect, text_color, text_color.a);

	// Ensure proper alpha
	COLOR.a = max(text_color.a, glow_effect.a * 0.7);
}
