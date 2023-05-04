shader_type canvas_item;

uniform sampler2D stencil_tex;

void fragment() {
	//vec2 uv = UV - 0.5;
	//float dist = sqrt(uv.x * uv.x + uv.y * uv.y);
	//COLOR.a = smoothstep(0.5, 0.4, dist);
	COLOR.a = texture(stencil_tex, UV).g;
}
