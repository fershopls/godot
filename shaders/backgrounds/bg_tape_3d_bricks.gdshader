shader_type canvas_item;

uniform vec3 a: source_color;
uniform vec3 b: source_color;

void fragment() {
	float aspect_ratio = 1728. / 972.;
	vec2 uv = UV;
	uv.x += TIME / 20.0;
	
	uv -= vec2(0.5);
	float k = abs(UV.x - 0.5);
	k = sin(UV.x * PI);
	k = pow(k, 0.4);
	uv.y = mix(uv.y * 1.2, uv.y * 1.0, k);
	uv += vec2(0.5);
	
	// grid
	vec2 size = vec2(6.0, 5.0) * 1.6;
	float ty = 0.;
	float tx = PI;
	
	vec2 of = vec2(0.0);
	float ofx = sin(uv.x * PI * 2.0 * size.x * 0.5 + PI / 2.0) / 2.0 + 0.5;
	ofx = step(0.5, ofx);
	of.y = ofx * ty;
	
	float ofy = sin(uv.y * PI * 2.0 * size.y * 0.5 + PI / 2.0) / 2.0 + 0.5;
	ofy = step(0.5, ofy);
	of.x = ofy * tx;
	
	float mx = sin(uv.x * PI * 2.0 * size.x + PI / 2.0 - of.x) / 2.0 + 0.5;
	float my = sin(uv.y * PI * 2.0 * size.y + PI / 2.0 + of.y) / 2.0 + 0.5;
	float m = mx * my;
	m = step(0.001, m);
	vec3 c = mix(a,b,m);
	
	// shading
	float m1 = pow(1.0 - UV.x, 10.0);
	c = mix(c, c * (1.0 - 0.7), m1);
	//
	float m2 = pow(UV.x, 10.0);
	c = mix(c, c * (1.0 - 0.7), m2);
	//
	float m3 = sin(UV.x * PI * 2.0 + PI + PI / 2.0) / 2.0 + 0.5;
	m3 = pow(m3, 2.0);
	c = mix(c, clamp(c * 1.3, vec3(0.), vec3(1.0)), m3 * 0.4);
	
	COLOR.rgb = c;
}
