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

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_A;
layout(set = 2, binding = 130) uniform sampler2D fp_t_tcb_C;

layout(location = 0) noperspective in vec4 _25;
layout(location = 0) out vec4 _28;

void main()
{
    float _35 = _25.x;
    float _37 = _25.y;
    float _39 = texture(fp_t_tcb_8, vec2(_35, _37)).x;
    float _41 = texture(fp_t_tcb_A, vec2(_35, _37)).x;
    vec3 _45 = texture(fp_t_tcb_C, vec2(_35, _37)).xyz;
    float _47 = _45.x;
    float _49 = _45.y;
    float _51 = _45.z;
    precise float _94 = _39 * _41;
    float _53 = _94;
    precise float _97 = _53 * _47;
    float _55 = _97;
    precise float _100 = _53 * _49;
    float _57 = _100;
    precise float _103 = _53 * _51;
    float _59 = _103;
    _28.x = _55;
    _28.y = _57;
    _28.z = _59;
    _28.w = 1.0;
}

