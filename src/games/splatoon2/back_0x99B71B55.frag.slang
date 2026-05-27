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

layout(location = 1) in vec4 _21;
layout(location = 0) in vec4 _23;
layout(location = 0) out vec4 _26;

void main()
{
    float _33 = _21.y;
    float _35 = _23.z;
    float _37 = _23.x;
    float _39 = _21.w;
    vec4 _42 = texture(fp_t_tcb_8, vec2(_35, _33)).xyzw;
    float _44 = _42.x;
    float _46 = _42.y;
    float _48 = _42.z;
    float _50 = _42.w;
    vec4 _52 = texture(fp_t_tcb_8, vec2(_37, _33)).xyzw;
    float _54 = _52.x;
    float _56 = _52.y;
    float _58 = _52.z;
    float _60 = _52.w;
    vec4 _62 = texture(fp_t_tcb_8, vec2(_37, _39)).xyzw;
    float _64 = _62.x;
    float _66 = _62.y;
    float _68 = _62.z;
    float _70 = _62.w;
    vec4 _72 = texture(fp_t_tcb_8, vec2(_35, _39)).xyzw;
    float _74 = _72.x;
    float _76 = _72.y;
    float _78 = _72.z;
    float _80 = _72.w;
    precise float _185 = _44 + _54;
    float _82 = _185;
    precise float _188 = _46 + _56;
    float _84 = _188;
    precise float _191 = _48 + _58;
    float _86 = _191;
    precise float _194 = _50 + _60;
    float _88 = _194;
    precise float _197 = _82 + _64;
    float _90 = _197;
    precise float _200 = _84 + _66;
    float _92 = _200;
    precise float _203 = _86 + _68;
    float _94 = _203;
    precise float _206 = _88 + _70;
    float _96 = _206;
    precise float _209 = _74 + _90;
    float _98 = _209;
    precise float _212 = _76 + _92;
    float _100 = _212;
    precise float _215 = _78 + _94;
    float _102 = _215;
    precise float _218 = _80 + _96;
    float _104 = _218;
    precise float _221 = _98 * 0.25;
    float _106 = _221;
    precise float _223 = _100 * 0.25;
    float _108 = _223;
    precise float _225 = _102 * 0.25;
    float _110 = _225;
    precise float _227 = _104 * 0.25;
    float _112 = _227;
    _26.x = 0;
    _26.y = 0;
    _26.z = 0;
    _26.w = 0;
}

