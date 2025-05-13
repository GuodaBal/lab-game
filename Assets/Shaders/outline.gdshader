shader_type canvas_item;

uniform vec4 line_color : source_color = vec4(1.0);
uniform float line_thickness : hint_range(0.0, 20.0) = 2.0;
uniform float blur_strength : hint_range(0.0, 1.0) = 0.2;
uniform float scale : hint_range(0.01, 10.0) = 1.0;  // your node’s scale factor

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    // Adjust thickness by inverse of object scale
    float factor = 1.0 / scale;
    float radius = line_thickness * factor;

    // Accumulate alpha with a radial falloff kernel (5×5)
    float alpha_accum = 0.0;
    float weight_accum = 0.0;
    for (int x = -2; x <= 2; x++) {
        for (int y = -2; y <= 2; y++) {
            vec2 offset = vec2(float(x), float(y)) * TEXTURE_PIXEL_SIZE * radius;
            // radial falloff: center stronger, edges weaker
            float w = 1.0 - length(vec2(float(x), float(y))) / 3.0;
            alpha_accum  += texture(TEXTURE, UV + offset).a * w;
            weight_accum += w;
        }
    }
    float blurred_alpha = alpha_accum / weight_accum;

    // Outline only where blurred_alpha exceeds original alpha
    float outline_alpha = clamp((blurred_alpha - tex.a) * (1.0 / blur_strength), 0.0, 1.0);

    // Mix between original and outline color
    COLOR = mix(tex, line_color, outline_alpha);
}
