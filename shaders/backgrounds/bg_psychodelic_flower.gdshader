shader_type canvas_item;

uniform vec3 a: source_color;
uniform vec3 b: source_color;

vec3 hue(float h) { return clamp(abs(mod(h * 6.0 + vec3(0.0, 4.0, 2.0), 6.0) - 3.0) - 1.0, 0.0, 1.0); }
vec3 hsv(vec3 hsv) { vec3 rgb = clamp(abs(mod(hsv.x * 6.0 + vec3(0.0, 4.0, 2.0), 6.0) - 3.0) - 1.0, 0.0, 1.0); return hsv.z * mix(vec3(1.0), rgb, hsv.y); }
float stairs(float value, float times) {
	return floor(fract(value) * times) / times;
}

void fragment() {
	float ar = 1728. / 972.;
	vec2 uv = UV;
	uv -= vec2(0.5);
	uv.x *= ar;
	vec2 dir = normalize(uv - vec2(0.));
	vec2 pv = vec2(
		(atan(dir.y, dir.x) + PI) / PI / 2.0,
		distance(uv, vec2(0.)) / 0.5
	);
	uv += vec2(0.5);
	// pv = uv;
	pv.x -= TIME * 0.3;
	float m = step(
		(sin(pv.x * PI * 2.0 * 15.0 + PI * 1.5) / 2.0 + 0.5) * 0.1 + 0.8,
		pv.y
	);
	float c = distance(uv, vec2(0.));
	COLOR.rgb = vec3((1.0 - m) * hue(c + TIME)) * (1.0 - step(distance(uv, vec2(0.5)) * 2.0, 0.7));
}
