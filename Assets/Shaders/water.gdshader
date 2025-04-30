shader_type canvas_item;

uniform sampler2D wave_texture : hint_default_white;
uniform float water_height = 0.1;
uniform float edge_width: hint_range(0.0, 0.1) = 0.01;
uniform float texture_blend: hint_range(0.0, 1.0) = 0.5;
uniform float speed: hint_range(0.1, 3.0) = 1.0;
uniform float wave_scale_horizontal = 1.0;
uniform float wave_scale_vertical = 1.0;
uniform float random_start = 0.0;
uniform float object_rotation = 0.0;

void fragment() {
    // Transparent background
    vec4 col = vec4(0.0, 0.0, 0.0, 0.0);

    // Center UV coordinates (pivot at center)
    vec2 centered_uv = UV - vec2(0.5);

    // Apply inverse rotation matrix
    float cos_r = cos(-object_rotation);
    float sin_r = sin(-object_rotation);
    mat2 rotation_matrix = mat2(vec2(cos_r, -sin_r), vec2(sin_r, cos_r));

    // Rotate UV and shift back
    vec2 rotated_uv = rotation_matrix * centered_uv + vec2(0.5);

    // Use rotated UV for wave calculations
    float wave_x = rotated_uv.x;
    float wave_y = rotated_uv.y;

    // Smooth wave animation
    float sine = sin(wave_x * 1.0 * wave_scale_horizontal + (TIME * 0.1 * speed + random_start)) * 0.03 * wave_scale_vertical + water_height;
    float sine_2 = sin(wave_x * 2.0 * wave_scale_horizontal + (TIME * 0.6 * speed + random_start)) * 0.01 * wave_scale_vertical;
    float sine_3 = sin(wave_x * 12.0 * wave_scale_horizontal + (TIME * 0.9 * speed + random_start)) * 0.02 * wave_scale_vertical;
    float wave_height = sine + sine_2 + sine_3;

    // Determine the wave and edge areas
    float edge_mask = smoothstep(wave_height - edge_width * 0.2, wave_height, wave_y);
    float wave_mask = smoothstep(wave_height, wave_height + edge_width * 0.9, wave_y);

    // Add alpha for non-background areas
    col.a = max(edge_mask, wave_mask);

    // Apply static texture to the wave mask
    vec4 texture_color = texture(wave_texture, rotated_uv);

    // Blend texture with the wave
    col.rgb = mix(col.rgb, texture_color.rgb, texture_blend * wave_mask);

    COLOR *= col;
}
