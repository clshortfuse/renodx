#version 330 compatibility
// Adapt this interface into the original shader; retain its inputs/outputs.
layout(std140) uniform RenoDX {
    vec4 renodx_params[16];
};
out vec4 color;
void main() {
    vec3 scene = gl_Color.rgb * renodx_params[0].x;
    float gray = dot(scene, vec3(0.2126, 0.7152, 0.0722));
    color = vec4(mix(vec3(gray), scene, renodx_params[0].y), gl_Color.a);
}
