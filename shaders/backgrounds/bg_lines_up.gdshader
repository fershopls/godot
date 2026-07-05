shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

uniform float width = 1.0;
uniform vec3 a: source_color = vec3(0.0);
uniform vec3 b: source_color = vec3(1.0);

void fragment() {
	vec2 uv = UV;
	uv.x -= TIME * 0.33;
	uv = fract(uv * 6.0);
	float w = width / 2.0;
	float m = 1.0 - (step(uv.x + w, uv.y) + step(uv.y, uv.x - w));
	m += step(uv.x+(1.0 - w), uv.y) + step(uv.y, uv.x - (1.0 - w));
	vec3 c = m * a + (1.0 - m) * b;
	COLOR = vec4(c, 1.0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
