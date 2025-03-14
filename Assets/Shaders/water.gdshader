shader_type canvas_item;

uniform sampler2D wave_texture : hint_default_white;         // Texture for the wave
uniform float water_height = 0.1;
uniform float edge_width: hint_range(0.0, 0.1) = 0.01;       // Thickness of the edge
uniform float texture_blend: hint_range(0.0, 1.0) = 0.5;     // Blend factor for the texture
uniform float speed: hint_range(0.1, 3.0) = 1.0;             // Speed of wave motion
uniform float wave_scale_horizontal = 1.0;
uniform float wave_scale_vertical = 1.0;
uniform float random_start = 0.0;


void fragment() {
    // Transparent background
    vec4 col = vec4(0.0, 0.0, 0.0, 0.0);

    // Smooth wave animation
    float sine = sin(UV.x * 1.0 * wave_scale_horizontal + (TIME * 0.1 * speed + random_start)) * 0.03 * wave_scale_vertical + water_height;
    float sine_2 = sin(UV.x * 2.0 * wave_scale_horizontal + (TIME * 0.6 * speed + random_start)) * 0.01 * wave_scale_vertical;
    float sine_3 = sin(UV.x * 12.0 * wave_scale_horizontal + (TIME * 0.9 * speed + random_start)) * 0.02 * wave_scale_vertical;
    float wave_height = sine + sine_2 + sine_3;

    // Determine the wave and edge areas
    float edge_mask = smoothstep(wave_height - edge_width * 0.2, wave_height, UV.y);
    float wave_mask = smoothstep(wave_height, wave_height + edge_width * 0.9, UV.y);

    // Add alpha for non-background areas
    col.a = max(edge_mask, wave_mask);

    // Apply static texture to the wave mask
    vec2 texture_coords = vec2(UV.x, UV.y); // Static texture without TIME offset
    vec4 texture_color = texture(wave_texture, texture_coords);

    // Blend texture with the wave
    col.rgb = mix(col.rgb, texture_color.rgb, texture_blend * wave_mask);

    COLOR *= col;
}