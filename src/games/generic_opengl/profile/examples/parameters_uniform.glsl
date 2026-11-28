#version 120
// Teaching template for a fixed-function custom fragment, or adapt its math
// into a captured shader. Input color must already be in the intended domain.
uniform vec4 renodx_params[16];
void main() {
    vec3 color = gl_Color.rgb * renodx_params[0].x;
    float gray = dot(color, vec3(0.2126, 0.7152, 0.0722));
    color = mix(vec3(gray), color, renodx_params[0].y);
    gl_FragColor = vec4(color, gl_Color.a);
}
