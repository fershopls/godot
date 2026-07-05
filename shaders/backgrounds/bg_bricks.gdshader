shader_type canvas_item;

uniform vec3 a: source_color;
uniform vec3 b: source_color;

void fragment() {
	float aspect_ratio = 1728. / 972.;
	vec2 uv = UV;
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
	COLOR.rgb = vec3(m);
	COLOR.rgb = mix(a,b,m);
}
