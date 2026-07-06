shader_type canvas_item;

uniform vec3 a: source_color;
uniform vec3 b: source_color;
vec3 hue(float h)
{
    return clamp(abs(mod(h * 6.0 + vec3(0.0, 4.0, 2.0), 6.0) - 3.0) - 1.0,
                 0.0, 1.0);
}

void fragment() {
	float ar = 1728. / 972.;
	vec2 uv = UV;
	uv -= vec2(0.5);
	uv.x *= ar;
	vec3 c = vec3(step(distance(uv, vec2(0.)), 0.425));
	
	float m = (atan(uv.y, uv.x) + PI) / (PI * 2.0);
	float n = 1.0 - smoothstep(0.4, 0.405, distance(uv, vec2(0.0)));
	float m1 = distance(uv, vec2(0.));
	float m2 = fract(m - TIME * 2.0);
	float mm = m2 + m1 * PI * (0.2 + 2.0 * (sin(TIME) / 2.0 + 0.5));
	c = hue(mm);
	COLOR.rgb = c;
}
