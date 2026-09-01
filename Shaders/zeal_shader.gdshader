shader_type canvas_item;

uniform float wave_speed : hint_range(0.0, 5.0) = 1.5;
uniform float wave_amplitude : hint_range(0.0, 0.05) = 0.015;
uniform float wave_frequency : hint_range(0.0, 50.0) = 12.0;
uniform vec4 liquid_color : source_color = vec4(0.4, 0.9, 1.0, 1.0);
uniform vec4 highlight_color : source_color = vec4(0.8, 1.0, 1.0, 1.0);
uniform float highlight_width : hint_range(0.0, 0.1) = 0.02;

void fragment() {
	vec2 uv = UV;

	// Wobble the fill's top edge over time using layered sine waves,
	// so it doesn't look like a perfectly flat liquid surface.
	float wave = sin(uv.x * wave_frequency + TIME * wave_speed) * wave_amplitude;
	wave += sin(uv.x * wave_frequency * 2.3 - TIME * wave_speed * 1.7) * wave_amplitude * 0.5;

	vec4 tex_color = texture(TEXTURE, uv);

	// Distance from the (wobbled) top edge, in the texture's own alpha mask.
	// TextureProgressBar already clips via `value`, so we only need to
	// add a bright "surface line" near wherever the alpha cuts off.
	float alpha = tex_color.a;

	COLOR = tex_color * liquid_color;

	// Add a highlight band near the top surface of the liquid using
	// screen-space derivative to detect the edge of the alpha mask.
	float edge = fwidth(alpha) * 4.0;
	if (alpha > 0.0 && alpha < 1.0 - edge) {
		COLOR = mix(COLOR, highlight_color, smoothstep(0.0, highlight_width, edge));
	}
}