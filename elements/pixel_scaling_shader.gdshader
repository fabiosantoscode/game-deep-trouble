shader_type canvas_item;

varying vec2 UV_;
uniform sampler2D scaled_subviewport;

// Implements a shader by t3ssel8r that stretches pixel art in a way
// that doesn't lose too much quality, clarity, consistency or sharpness
// https://www.youtube.com/watch?v=d6tp43wZqps
// https://www.patreon.com/posts/83276362
// Rewritten to godot shader lang by user samwise970 on Reddit
// https://www.reddit.com/r/godot/comments/1dazqgj/heres_a_shader_to_upscale_pixel_art_to_noninteger/

void vertex() {
	// I can't get UV coordinates to work for some reason. Use vertex coordinates, will also be [0,1]w
	UV_ = vec2(VERTEX);
}

void fragment() {
	// Get the texture size
    vec2 texture_size = vec2(textureSize(scaled_subviewport, 0));
    // Calculate the box filter size in texel units
    vec2 box_size = clamp(fwidth(UV_) * texture_size, vec2(1e-5), vec2(1.0));
    // Scale UV by texture size to get texel coordinate
    vec2 tx = UV_ * texture_size - 0.5 * box_size;
    // Compute offset for pixel-sized box filter
    vec2 tx_offset = clamp((fract(tx) - (vec2(1.0) - box_size)) / box_size, vec2(0.0), vec2(1.0));
    // Compute bilinear sample UV coordinates
    vec2 uv = (floor(tx) + vec2(0.5) + tx_offset) / texture_size;
    // Sample the texture using the original UV coordinates
    vec4 color = texture(scaled_subviewport, uv);
    // Set the output color
    COLOR = color;
}
