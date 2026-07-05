shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

uniform vec2 pos = vec2(0.5, 0.5);
uniform float aspect_ratio = 1.77777777778;
uniform float progress = 0.5;
uniform float alpha = 1.0;
uniform float force = 0.5;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	float radius = sin(TIME) / 2.0 + 0.5;
	radius = progress;
	float width = 0.05;
	//radius = 0.4;
	width = 0.4;
	
	vec2 ar = vec2(aspect_ratio, 1.0);
	//vec2 pos = vec2(0.5, 0.5);
	vec2 posar = pos * ar;
	vec2 uv = UV;
	vec2 uvar = uv * ar;
	float m = step(distance(uvar, posar), radius); // outer
	m *= 1.0 - step(distance(uvar, posar), radius - width); // inner
	// COLOR.rgb = vec3(m);
	
	vec2 d = normalize(uvar - posar);
	vec2 a = posar + d * radius; // outer
	vec2 b = posar + d * (radius - width); // inner
	float dm = distance(uvar, b) / width * m;
	dm = pow(dm, 2.0);
	float zoom = dm * alpha * force;
	
	vec2 displacement = uv - normalize(uv - pos) * distance(uv, pos) * zoom;
	
	COLOR.rgb = mix(
		texture(screen_texture, uv).rgb,
		texture(screen_texture, displacement).rgb,
		m
	);
	//COLOR.rgb = mix(c, vec3(dm), m);
	//COLOR.rgb = vec3(dm);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
