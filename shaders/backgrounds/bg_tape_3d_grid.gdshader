shader_type canvas_item;

uniform vec3 a: source_color;
uniform vec3 b: source_color;

void fragment() {
	float aspect_ratio = 1728. / 972.;
	vec2 size = vec2(5.0) * vec2(aspect_ratio, 1.0);
	vec2 uv = UV;
	uv.x += TIME / 20.0;
	
	uv -= vec2(0.5);
	float k = abs(UV.x - 0.5);
	k = sin(UV.x * PI);
	k = pow(k, 0.15);
	uv.y = mix(uv.y * 2.5, uv.y * 1.0, k);
	uv += vec2(0.5);
	
	// grid
	float mx = sin(uv.x * PI * 2.0 * size.x + PI * 1.0) / 2.0 + 0.5;
	mx = step(mx, 0.5);
	float my = sin(uv.y * PI * 2.0 * size.y + PI * 1.0) / 2.0 + 0.5;
	my = step(my, 0.5);
	float m = mix(1.0, 0., my) - mx * mix(1.0, -1.0, my);
	
	// shading
	vec3 c = vec3(m);
	float m1 = pow(1.0 - UV.x, 10.0);
	c = mix(c, c * (1.0 - 0.7), m1);
	//
	float m2 = pow(UV.x, 10.0);
	c = mix(c, c * (1.0 - 0.7), m2);
	//
	float m3 = sin(UV.x * PI * 2.0 + PI + PI / 2.0) / 2.0 + 0.5;
	m3 = pow(m3, 4.0);
	c = mix(c, clamp(c * 1.8, vec3(0.), vec3(1.0)), m3 * 0.5);
	
	COLOR.rgb = c;
}
