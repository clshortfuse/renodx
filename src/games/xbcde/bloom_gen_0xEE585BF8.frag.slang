#version 450

layout(set = 0, binding = 0, std140) uniform support_buffer
{
    uint _m0;
    uint _m1[8];
    vec4 _m2;
    vec4 _m3;
    int _m4;
    float _m5[73];
    ivec4 _m6;
    int _m7;
} support_buffer_1;

layout(set = 0, binding = 22, std140) uniform fp_c3
{
    vec4 _m0[4096];
} fp_c3_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;

layout(location = 0) in vec4 _27;
layout(location = 0) out vec4 _30;

void main()
{
    float _37 = _27.x;
    float _39 = _27.y;
    precise float _122 = _37 + fp_c3_1._m0[1].z;
    float _41 = _122;
    precise float _127 = _39 + fp_c3_1._m0[1].w;
    float _43 = _127;
    float _45 = -fp_c3_1._m0[1].w;
    precise float _133 = _39 + _45;
    float _47 = _133;
    float _49 = -fp_c3_1._m0[1].z;
    precise float _139 = _37 + _49;
    float _51 = _139;
    vec3 _55 = texture(fp_t_tcb_8, vec2(_41, _43)).xyz;
    float _57 = _55.x;
    float _59 = _55.y;
    float _61 = _55.z;
    vec3 _63 = texture(fp_t_tcb_8, vec2(_41, _47)).xyz;
    float _65 = _63.x;
    float _67 = _63.y;
    float _69 = _63.z;
    vec3 _71 = texture(fp_t_tcb_8, vec2(_51, _47)).xyz;
    float _73 = _71.x;
    float _75 = _71.y;
    float _77 = _71.z;
    vec3 _79 = texture(fp_t_tcb_8, vec2(_51, _43)).xyz;
    float _81 = _79.x;
    float _83 = _79.y;
    float _85 = _79.z;
    precise float _191 = _57 + _73;
    float _87 = _191;
    precise float _194 = _59 + _75;
    float _89 = _194;
    precise float _197 = _61 + _77;
    float _91 = _197;
    precise float _200 = _87 + _65;
    float _93 = _200;
    precise float _203 = _89 + _67;
    float _95 = _203;
    precise float _206 = _91 + _69;
    float _97 = _206;
    precise float _209 = _81 + _93;
    float _99 = _209;
    precise float _212 = _83 + _95;
    float _101 = _212;
    precise float _215 = _85 + _97;
    float _103 = _215;
    precise float _218 = _99 * 0.25;
    float _105 = _218;
    precise float _220 = _101 * 0.25;
    float _107 = _220;
    precise float _222 = _103 * 0.25;
    float _109 = _222;
    _30.x = _105;
    _30.y = _107;
    _30.z = _109;
    _30.w = 1.0;
}

