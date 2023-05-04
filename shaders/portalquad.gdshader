shader_type spatial;
render_mode unshaded;

uniform sampler2D viewport_texture;

void fragment() {
	vec4 n_out4p0 = texture(viewport_texture, SCREEN_UV);
	ALBEDO = vec3(n_out4p0.xyz);
}