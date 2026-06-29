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

layout(location = 0) in vec4 _23;
layout(location = 0) out vec4 _26;

void main()
{
    float _33 = gl_FragCoord.w;
    float _35 = _23.x;
    float _37 = gl_FragCoord.w;
    precise float _90 = _35 * _37;
    float _39 = _90;
    float _41 = _23.y;
    float _43 = gl_FragCoord.w;
    precise float _98 = _41 * _43;
    float _45 = _98;
    precise float _101 = 1.0 / _33;
    float _47 = _101;
    precise float _104 = _47 * _39;
    float _49 = _104;
    precise float _107 = _47 * _45;
    float _51 = _107;
    vec4 _54 = texture(fp_t_tcb_8, vec2(_49, _51)).xyzw;
    float _56 = _54.x;
    float _58 = _54.y;
    float _60 = _54.z;
    float _62 = _54.w;
    precise float _125 = _56 + (-0.0);
    float _64 = _125;
    float _66 = clamp(_64, 0.0, 1.0);
    precise float _131 = _58 + (-0.0);
    float _68 = _131;
    float _70 = clamp(_68, 0.0, 1.0);
    precise float _135 = _60 + (-0.0);
    float _72 = _135;
    float _74 = clamp(_72, 0.0, 1.0);
    precise float _139 = _62 + (-0.0);
    float _76 = _139;
    float _78 = clamp(_76, 0.0, 1.0);
    _26.x = _66;
    _26.y = _70;
    _26.z = _74;
    _26.w = _78;

    //_26.xyz = 10;
}

