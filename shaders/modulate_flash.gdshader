shader_type canvas_item;


uniform bool is_white = false;


void fragment() {
    vec4 original_color = texture(TEXTURE, UV);
    
    if (is_white) {
        COLOR = vec4(1.0, 1.0, 1.0, original_color.a);
    } else {
        COLOR = original_color;
    }
}