#version 450
// CUSTOM: Slang supports explicit int64 without GLSL driver feature macros.
// ORIGINAL: #if defined(GL_ARB_gpu_shader_int64)
// ORIGINAL: #extension GL_ARB_gpu_shader_int64 : require
// ORIGINAL: #else
// ORIGINAL: #error No extension available for 64-bit integers.
// ORIGINAL: #endif
#extension GL_EXT_shader_explicit_arithmetic_types_int64 : require
#extension GL_EXT_scalar_block_layout : require
#extension GL_KHR_shader_subgroup_basic : require
#extension GL_KHR_shader_subgroup_ballot : require
#extension GL_KHR_shader_subgroup_shuffle : require
// CUSTOM: Implement native packUint2x32/unpackUint2x32 for Slang and add AA RGB conversion.
#include "./aa_integer_compat.slangi"
#include "./aa_color.slangi"
layout(local_size_x = 192, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, scalar) uniform cs_cbuf_block_5u
{
    uint data[16384];
} c0;

layout(set = 0, binding = 0, scalar) uniform c0_1
{
    uvec2 data[8192];
} c0_2;

layout(set = 0, binding = 1, std430) buffer ssbo0
{
    uint _m0[];
} ssbo0_1;

layout(set = 0, binding = 2, std430) buffer ssbo1
{
    uint _m0[];
} ssbo1_1;

layout(set = 0, binding = 3) uniform sampler2D cs_tex0_148;
layout(set = 0, binding = 4) uniform writeonly uimage2D cs_img0_150;

// CUSTOM: Only the uint2 view is accessed by this native shader. Retain its
// original 7936-byte allocation; do not create disconnected aliased views.
// ORIGINAL: shared _38 _41;
// ORIGINAL: shared _44 _47;
// ORIGINAL: shared _49 _52;
// ORIGINAL: shared _55 _58;
struct _49 { uvec2 _m0[992]; };
shared _49 _52;
// Unused native views: shared _38 _41; shared _44 _47; shared _55 _58;

void main()
{
    uint _233 = (bitfieldExtract(gl_LocalInvocationID.x, int(16u), int(16u)) * 16853u) + bitfieldExtract(bitfieldExtract(gl_LocalInvocationID.x, int(0u), int(16u)) * 16853u, int(16u), int(16u));
    uint _244 = (((bitfieldExtract(gl_LocalInvocationID.x, int(0u), int(16u)) * 54301u) + bitfieldExtract(_233, int(0u), int(16u))) >> 16u) + ((bitfieldExtract(gl_LocalInvocationID.x, int(16u), int(16u)) * 54301u) + bitfieldExtract(_233, int(16u), int(16u)));
    uint _246 = gl_LocalInvocationID.x + 192u;
    uint _248 = gl_LocalInvocationID.x + 384u;
    uint _252 = gl_LocalInvocationID.x + 576u;
    uint _254 = gl_LocalInvocationID.x + 768u;
    uint _260 = (bitfieldExtract(_248, int(16u), int(16u)) * 16853u) + bitfieldExtract(bitfieldExtract(_248, int(0u), int(16u)) * 16853u, int(16u), int(16u));
    uint _270 = (((bitfieldExtract(_248, int(0u), int(16u)) * 54301u) + bitfieldExtract(_260, int(0u), int(16u))) >> 16u) + ((bitfieldExtract(_248, int(16u), int(16u)) * 54301u) + bitfieldExtract(_260, int(16u), int(16u)));
    uint _279 = (bitfieldExtract(_246, int(16u), int(16u)) * 16853u) + bitfieldExtract(bitfieldExtract(_246, int(0u), int(16u)) * 16853u, int(16u), int(16u));
    uint _289 = (((bitfieldExtract(_246, int(0u), int(16u)) * 54301u) + bitfieldExtract(_279, int(0u), int(16u))) >> 16u) + ((bitfieldExtract(_246, int(16u), int(16u)) * 54301u) + bitfieldExtract(_279, int(16u), int(16u)));
    uint _291 = (((gl_LocalInvocationID.x + (-_244)) >> 1u) + _244) >> 5u;
    uint _294 = (gl_WorkGroupID.x << 5u) + 4294967294u;
    uint _304 = (bitfieldExtract(_252, int(16u), int(16u)) * 16853u) + bitfieldExtract(bitfieldExtract(_252, int(0u), int(16u)) * 16853u, int(16u), int(16u));
    uint _314 = (((bitfieldExtract(_252, int(0u), int(16u)) * 54301u) + bitfieldExtract(_304, int(0u), int(16u))) >> 16u) + ((bitfieldExtract(_252, int(16u), int(16u)) * 54301u) + bitfieldExtract(_304, int(16u), int(16u)));
    uint _324 = (bitfieldExtract(_254, int(16u), int(16u)) * 16853u) + bitfieldExtract(bitfieldExtract(_254, int(0u), int(16u)) * 16853u, int(16u), int(16u));
    uint _334 = (((bitfieldExtract(_254, int(0u), int(16u)) * 54301u) + bitfieldExtract(_324, int(0u), int(16u))) >> 16u) + ((bitfieldExtract(_254, int(16u), int(16u)) * 54301u) + bitfieldExtract(_324, int(16u), int(16u)));
    uint _335 = (((_246 + (-_289)) >> 1u) + _289) >> 5u;
    uint _336 = (((_248 + (-_270)) >> 1u) + _270) >> 5u;
    uint _348 = ((bitfieldExtract(gl_WorkGroupID.y, int(16u), int(16u)) * 24u) << 16u) + ((bitfieldExtract(gl_WorkGroupID.y, int(0u), int(16u)) * 24u) + 4294967294u);
    uint _362 = (((bitfieldExtract(_291, int(0u), int(16u)) * 65535u) + (bitfieldExtract(_291, int(16u), int(16u)) * 65501u)) << 16u) + ((bitfieldExtract(_291, int(0u), int(16u)) * 65501u) + gl_LocalInvocationID.x);
    uint _366 = (((_252 + (-_314)) >> 1u) + _314) >> 5u;
    uint _376 = (((bitfieldExtract(_335, int(0u), int(16u)) * 65535u) + (bitfieldExtract(_335, int(16u), int(16u)) * 65501u)) << 16u) + ((bitfieldExtract(_335, int(0u), int(16u)) * 65501u) + _246);
    uint _377 = (((_254 + (-_334)) >> 1u) + _334) >> 5u;
    uint _396 = (((bitfieldExtract(_336, int(0u), int(16u)) * 65535u) + (bitfieldExtract(_336, int(16u), int(16u)) * 65501u)) << 16u) + ((bitfieldExtract(_336, int(0u), int(16u)) * 65501u) + _248);
    uint _407 = (((bitfieldExtract(_366, int(0u), int(16u)) * 65535u) + (bitfieldExtract(_366, int(16u), int(16u)) * 65501u)) << 16u) + ((bitfieldExtract(_366, int(0u), int(16u)) * 65501u) + _252);
    uint _418 = (((bitfieldExtract(_377, int(0u), int(16u)) * 65535u) + (bitfieldExtract(_377, int(16u), int(16u)) * 65501u)) << 16u) + ((bitfieldExtract(_377, int(0u), int(16u)) * 65501u) + _254);
    vec4 _473 = texelFetch(cs_tex0_148, ivec2(uvec2(uint(min(int(uint(max(int(0u), int(_294 + _362)))), int(c0.data[26u]))) + c0.data[24u], uint(min(int(uint(max(int(0u), int(_348 + _291)))), int(c0.data[27u]))) + c0.data[25u])), int(0u));
    vec4 _502 = texelFetch(cs_tex0_148, ivec2(uvec2(uint(min(int(uint(max(int(0u), int(_294 + _376)))), int(c0.data[26u]))) + c0.data[24u], uint(min(int(uint(max(int(0u), int(_348 + _335)))), int(c0.data[27u]))) + c0.data[25u])), int(0u));
    vec4 _510 = texelFetch(cs_tex0_148, ivec2(uvec2(uint(min(int(uint(max(int(0u), int(_294 + _396)))), int(c0.data[26u]))) + c0.data[24u], uint(min(int(uint(max(int(0u), int(_348 + _336)))), int(c0.data[27u]))) + c0.data[25u])), int(0u));
    vec4 _518 = texelFetch(cs_tex0_148, ivec2(uvec2(uint(min(int(uint(max(int(0u), int(_294 + _407)))), int(c0.data[26u]))) + c0.data[24u], uint(min(int(uint(max(int(0u), int(_348 + _366)))), int(c0.data[27u]))) + c0.data[25u])), int(0u));
    vec4 _526 = texelFetch(cs_tex0_148, ivec2(uvec2(uint(min(int(uint(max(int(0u), int(_294 + _418)))), int(c0.data[26u]))) + c0.data[24u], uint(min(int(uint(max(int(0u), int(_348 + _377)))), int(c0.data[27u]))) + c0.data[25u])), int(0u));
    // CUSTOM: Edge analysis and AA must use the same RGB basis. Preserve signed
    // BT.709 scene samples by converting, not clamping them before native sqrt.
    _473.rgb = CustomAaWorkingRgb(_473.rgb);
    _502.rgb = CustomAaWorkingRgb(_502.rgb);
    _510.rgb = CustomAaWorkingRgb(_510.rgb);
    _518.rgb = CustomAaWorkingRgb(_518.rgb);
    _526.rgb = CustomAaWorkingRgb(_526.rgb);
    uint _584 = (((gl_LocalInvocationID.x >> 5u) << 4u) | (~16u)) & (16u | ((gl_SubgroupInvocationID << 2u) & 12u));
    uint _586 = gl_LocalInvocationID.x >> 6u;
    uint _601 = ((bitfieldExtract(gl_WorkGroupID.x, int(16u), int(16u)) * 32u) << 16u) + ((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * 32u) + _584);
    uint _609 = ((bitfieldExtract(_586, int(16u), int(16u)) * 8u) << 16u) + ((bitfieldExtract(_586, int(0u), int(16u)) * 8u) + ((gl_SubgroupInvocationID >> 2u) & 268435455u));
    uint _616 = ((bitfieldExtract(gl_WorkGroupID.y, int(16u), int(16u)) * 24u) << 16u) + ((bitfieldExtract(gl_WorkGroupID.y, int(0u), int(16u)) * 24u) + _609);
    uint _624 = ((bitfieldExtract(_609, int(16u), int(16u)) * 35u) << 16u) + ((bitfieldExtract(_609, int(0u), int(16u)) * 35u) + _584);
    _52._m0[uint(int((((bitfieldExtract(_291, int(16u), int(16u)) * 35u) << 16u) + ((bitfieldExtract(_291, int(0u), int(16u)) * 35u) + _362)) << 3u) >> int(3u))] = uvec2((packHalf2x16(vec2(sqrt(_473.y), 0.0)) << 16u) + packHalf2x16(vec2(sqrt(_473.x), 0.0)), (packHalf2x16(vec2(_473.w, 0.0)) << 16u) + packHalf2x16(vec2(sqrt(_473.z), 0.0)));
    _52._m0[uint(int((((bitfieldExtract(_335, int(16u), int(16u)) * 35u) << 16u) + ((bitfieldExtract(_335, int(0u), int(16u)) * 35u) + _376)) << 3u) >> int(3u))] = uvec2((packHalf2x16(vec2(sqrt(_502.y), 0.0)) << 16u) + packHalf2x16(vec2(sqrt(_502.x), 0.0)), (packHalf2x16(vec2(_502.w, 0.0)) << 16u) + packHalf2x16(vec2(sqrt(_502.z), 0.0)));
    _52._m0[uint(int((((bitfieldExtract(_336, int(16u), int(16u)) * 35u) << 16u) + ((bitfieldExtract(_336, int(0u), int(16u)) * 35u) + _396)) << 3u) >> int(3u))] = uvec2((packHalf2x16(vec2(sqrt(_510.y), 0.0)) << 16u) + packHalf2x16(vec2(sqrt(_510.x), 0.0)), (packHalf2x16(vec2(_510.w, 0.0)) << 16u) + packHalf2x16(vec2(sqrt(_510.z), 0.0)));
    _52._m0[uint(int((((bitfieldExtract(_366, int(16u), int(16u)) * 35u) << 16u) + ((bitfieldExtract(_366, int(0u), int(16u)) * 35u) + _407)) << 3u) >> int(3u))] = uvec2((packHalf2x16(vec2(sqrt(_518.y), 0.0)) << 16u) + packHalf2x16(vec2(sqrt(_518.x), 0.0)), (packHalf2x16(vec2(_518.w, 0.0)) << 16u) + packHalf2x16(vec2(sqrt(_518.z), 0.0)));
    _52._m0[uint(int((((bitfieldExtract(_377, int(16u), int(16u)) * 35u) << 16u) + ((bitfieldExtract(_377, int(0u), int(16u)) * 35u) + _418)) << 3u) >> int(3u))] = uvec2((packHalf2x16(vec2(sqrt(_526.y), 0.0)) << 16u) + packHalf2x16(vec2(sqrt(_526.x), 0.0)), (packHalf2x16(vec2(_526.w, 0.0)) << 16u) + packHalf2x16(vec2(sqrt(_526.z), 0.0)));
    barrier();
    uint _714 = uint(int((_624 << 3u) + 568u) >> int(3u));
    uint _722 = uint(int((_624 << 3u) + 296u) >> int(3u));
    uvec2 _724 = _52._m0[_722];
    uint _729 = uint(int((_624 << 3u) + 576u) >> int(3u));
    uvec2 _731 = _52._m0[_729];
    uint _737 = uint(int((_624 << 3u) + 304u) >> int(3u));
    uvec2 _739 = _52._m0[_737];
    uint _745 = uint(int((_624 << 3u) + 584u) >> int(3u));
    uint _753 = uint(int((_624 << 3u) + 592u) >> int(3u));
    uvec2 _755 = _52._m0[_753];
    uint _761 = uint(int((_624 << 3u) + 864u) >> int(3u));
    uint _768 = uint(int((_624 << 3u) + 24u) >> int(3u));
    uint _776 = uint(int((_624 << 3u) + 312u) >> int(3u));
    uint _784 = uint(int((_624 << 3u) + 600u) >> int(3u));
    uint _792 = uint(int((_624 << 3u) + 320u) >> int(3u));
    uvec2 _794 = _52._m0[_792];
    uint _799 = (_724.y << 16u) + (_52._m0[_714].y & 65535u);
    vec2 _800 = unpackHalf2x16(_731.x);
    vec2 _803 = unpackHalf2x16(_52._m0[_714].x);
    precise float _808 = _800.x + (-_803.x);
    precise float _809 = _800.y + (-_803.y);
    uint _813 = (_731.y & 65535u) + (_724.y & 4294901760u);
    vec2 _814 = unpackHalf2x16(_731.x);
    vec2 _817 = unpackHalf2x16(_724.x);
    precise float _822 = _814.x + (-_817.x);
    precise float _823 = _814.y + (-_817.y);
    vec2 _839 = unpackHalf2x16(_813);
    float _840 = _839.x;
    vec2 _841 = unpackHalf2x16(_799);
    precise float _846 = _840 + (-_841.x);
    precise float _847 = _840 + (-_841.y);
    vec2 _860 = unpackHalf2x16(_52._m0[_745].x);
    vec2 _863 = unpackHalf2x16(_731.x);
    precise float _868 = _860.x + (-_863.x);
    precise float _869 = _860.y + (-_863.y);
    uint _872 = (_813 & 65535u) + (((_739.y << 16u) + (_739.y & 65535u)) & 4294901760u);
    vec2 _873 = unpackHalf2x16(_52._m0[_745].x);
    vec2 _876 = unpackHalf2x16(_739.x);
    precise float _881 = _873.x + (-_876.x);
    precise float _882 = _873.y + (-_876.y);
    uint _885 = (((packHalf2x16(vec2(max(abs(_822), abs(_823)), 0.0)) << 16u) + packHalf2x16(vec2(max(abs(_822), abs(_823)), 0.0))) << 16u) + (((packHalf2x16(vec2(max(abs(_808), abs(_809)), 0.0)) << 16u) + packHalf2x16(vec2(max(abs(_808), abs(_809)), 0.0))) & 65535u);
    vec2 _898 = unpackHalf2x16(_52._m0[_745].y);
    float _899 = _898.x;
    vec2 _900 = unpackHalf2x16(_872);
    precise float _905 = _899 + (-_900.x);
    precise float _906 = _899 + (-_900.y);
    uint _932 = (packHalf2x16(vec2(max(unpackHalf2x16(_885).y, abs(_847)), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_885).x, abs(_846)), 0.0));
    vec2 _934 = unpackHalf2x16(_932);
    vec2 _937 = unpackHalf2x16(778448486u);
    bool _941 = _934.y > _937.y;
    vec2 _944 = unpackHalf2x16(778448486u);
    bool _947 = (unpackHalf2x16(_932).x > _944.x) || _941;
    uint _949;
    if (!_947)
    {
        _949 = 0u;
    }
    else
    {
        _949 = _291;
    }
    uint _951;
    if (!_947)
    {
        _951 = 0u;
    }
    else
    {
        _951 = _336;
    }
    uint _1224;
    uint _1225;
    if (_947)
    {
        uint _955 = uint(int((_624 << 3u) + 856u) >> int(3u));
        uint _963 = uint(int((_624 << 3u) + 560u) >> int(3u));
        uint _970 = uint(int((_624 << 3u) + 16u) >> int(3u));
        vec2 _975 = unpackHalf2x16(_731.x);
        vec2 _978 = unpackHalf2x16(_52._m0[_955].x);
        precise float _983 = _975.x + (-_978.x);
        precise float _984 = _975.y + (-_978.y);
        uint _986 = packHalf2x16(vec2(_983, _984));
        vec2 _987 = unpackHalf2x16(_731.x);
        vec2 _990 = unpackHalf2x16(_52._m0[_745].x);
        precise float _995 = _987.x + (-_990.x);
        precise float _996 = _987.y + (-_990.y);
        uint _998 = packHalf2x16(vec2(_995, _996));
        vec2 _999 = unpackHalf2x16(_813);
        float _1000 = _999.x;
        vec2 _1001 = unpackHalf2x16(_52._m0[_955].y);
        float _1002 = _1001.x;
        precise float _1005 = _1000 + (-_1002);
        precise float _1006 = _1000 + (-_1002);
        vec2 _1009 = unpackHalf2x16(_813);
        float _1010 = _1009.x;
        vec2 _1011 = unpackHalf2x16(_52._m0[_745].y);
        float _1012 = _1011.x;
        precise float _1015 = _1010 + (-_1012);
        precise float _1016 = _1010 + (-_1012);
        vec2 _1019 = unpackHalf2x16(_52._m0[_714].x);
        vec2 _1022 = unpackHalf2x16(_52._m0[_963].x);
        precise float _1027 = _1019.x + (-_1022.x);
        precise float _1028 = _1019.y + (-_1022.y);
        uint _1030 = packHalf2x16(vec2(_1027, _1028));
        vec2 _1031 = unpackHalf2x16(_799);
        float _1032 = _1031.x;
        vec2 _1033 = unpackHalf2x16(_52._m0[_963].y);
        float _1034 = _1033.x;
        precise float _1037 = _1032 + (-_1034);
        precise float _1038 = _1032 + (-_1034);
        uint _1043 = (packHalf2x16(vec2(_1005, _1006)) << 16u) + (packHalf2x16(vec2(_1015, _1016)) & 65535u);
        vec2 _1044 = unpackHalf2x16(_724.x);
        vec2 _1047 = unpackHalf2x16(_52._m0[_970].x);
        precise float _1052 = _1044.x + (-_1047.x);
        precise float _1053 = _1044.y + (-_1047.y);
        uint _1055 = packHalf2x16(vec2(_1052, _1053));
        vec2 _1056 = unpackHalf2x16(_799);
        float _1057 = _1056.y;
        vec2 _1058 = unpackHalf2x16(_52._m0[_970].y);
        float _1059 = _1058.x;
        precise float _1062 = _1057 + (-_1059);
        precise float _1063 = _1057 + (-_1059);
        uint _1068 = (_986 << 16u) + (_998 & 65535u);
        uint _1071 = (_998 >> 16u) + (_986 & 4294901760u);
        uint _1074 = (_1055 << 16u) + (_1030 & 65535u);
        uint _1077 = (_1030 >> 16u) + (_1055 & 4294901760u);
        uint _1097 = (packHalf2x16(vec2(max(abs(unpackHalf2x16(_1068).y), abs(unpackHalf2x16(_1071).y)), 0.0)) << 16u) + packHalf2x16(vec2(max(abs(unpackHalf2x16(_1068).x), abs(unpackHalf2x16(_1071).x)), 0.0));
        uint _1100 = (packHalf2x16(vec2(_1062, _1063)) << 16u) + (packHalf2x16(vec2(_1037, _1038)) & 65535u);
        uint _1120 = (packHalf2x16(vec2(max(abs(unpackHalf2x16(_1074).y), abs(unpackHalf2x16(_1077).y)), 0.0)) << 16u) + packHalf2x16(vec2(max(abs(unpackHalf2x16(_1074).x), abs(unpackHalf2x16(_1077).x)), 0.0));
        uint _1138 = (packHalf2x16(vec2(max(unpackHalf2x16(_1097).y, abs(unpackHalf2x16(_1043).y)), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1097).x, abs(unpackHalf2x16(_1043).x)), 0.0));
        uint _1156 = (packHalf2x16(vec2(max(unpackHalf2x16(_1120).y, abs(unpackHalf2x16(_1100).y)), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1120).x, abs(unpackHalf2x16(_1100).x)), 0.0));
        uint _1172 = (packHalf2x16(vec2(max(unpackHalf2x16(_932).y, unpackHalf2x16(_1138).y), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_932).x, unpackHalf2x16(_1138).x), 0.0));
        uint _1188 = (packHalf2x16(vec2(max(unpackHalf2x16(_1172).y, unpackHalf2x16(_1156).y), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1172).x, unpackHalf2x16(_1156).x), 0.0));
        vec2 _1190 = unpackHalf2x16(_932);
        vec2 _1193 = unpackHalf2x16(1073758208u);
        precise float _1196 = _1190.x * _1193.x;
        precise float _1197 = _1190.y * _1193.y;
        uint _1213 = (packHalf2x16(vec2(max(unpackHalf2x16(_1188).x, unpackHalf2x16(_1188).y), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1188).x, unpackHalf2x16(_1188).y), 0.0));
        _1224 = ((unpackHalf2x16(_1213).x < _1197) && _941) ? 8u : 0u;
        _1225 = ((unpackHalf2x16(_1213).x < _1196) && (_934.x > _937.x)) ? 8u : 0u;
    }
    else
    {
        _1224 = _949;
        _1225 = _951;
    }
    uint _1228 = (((packHalf2x16(vec2(max(abs(_881), abs(_882)), 0.0)) << 16u) + packHalf2x16(vec2(max(abs(_881), abs(_882)), 0.0))) << 16u) + (((packHalf2x16(vec2(max(abs(_868), abs(_869)), 0.0)) << 16u) + packHalf2x16(vec2(max(abs(_868), abs(_869)), 0.0))) & 65535u);
    vec2 _1229 = unpackHalf2x16(_755.x);
    vec2 _1232 = unpackHalf2x16(_52._m0[_776].x);
    precise float _1237 = _1229.x + (-_1232.x);
    precise float _1238 = _1229.y + (-_1232.y);
    uint _1241 = (_52._m0[_776].y << 16u) + (_52._m0[_745].y & 65535u);
    vec2 _1242 = unpackHalf2x16(_755.x);
    vec2 _1245 = unpackHalf2x16(_52._m0[_745].x);
    precise float _1250 = _1242.x + (-_1245.x);
    precise float _1251 = _1242.y + (-_1245.y);
    uint _1254 = (_794.y << 16u) + (_755.y & 65535u);
    vec2 _1255 = unpackHalf2x16(_52._m0[_784].x);
    vec2 _1258 = unpackHalf2x16(_794.x);
    precise float _1263 = _1255.x + (-_1258.x);
    precise float _1264 = _1255.y + (-_1258.y);
    uint _1278 = (packHalf2x16(vec2(max(unpackHalf2x16(_1228).y, abs(_906)), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1228).x, abs(_905)), 0.0));
    vec2 _1279 = unpackHalf2x16(_52._m0[_784].x);
    vec2 _1282 = unpackHalf2x16(_755.x);
    precise float _1287 = _1279.x + (-_1282.x);
    precise float _1288 = _1279.y + (-_1282.y);
    uint _1304 = uint(int((_624 << 3u) + 872u) >> int(3u));
    vec2 _1309 = unpackHalf2x16(_1278);
    vec2 _1312 = unpackHalf2x16(778448486u);
    bool _1316 = _1309.y > _1312.y;
    vec2 _1317 = unpackHalf2x16(_52._m0[_784].y);
    float _1318 = _1317.x;
    vec2 _1319 = unpackHalf2x16(_1254);
    precise float _1324 = _1318 + (-_1319.x);
    precise float _1325 = _1318 + (-_1319.y);
    uint _1340 = uint(int((_624 << 3u) + 32u) >> int(3u));
    vec2 _1359 = unpackHalf2x16(778448486u);
    bool _1362 = (unpackHalf2x16(_1278).x > _1359.x) || _1316;
    uint _1366 = uint(int((_624 << 3u) + 608u) >> int(3u));
    uint _1382 = (packHalf2x16(vec2(max(abs(_1263), abs(_1264)), 0.0)) << 16u) + packHalf2x16(vec2(max(abs(_1263), abs(_1264)), 0.0));
    uint _1385 = (((packHalf2x16(vec2(max(abs(_1237), abs(_1238)), 0.0)) << 16u) + packHalf2x16(vec2(max(abs(_1237), abs(_1238)), 0.0))) << 16u) + (((packHalf2x16(vec2(max(abs(_1250), abs(_1251)), 0.0)) << 16u) + packHalf2x16(vec2(max(abs(_1250), abs(_1251)), 0.0))) & 65535u);
    uint _1389 = uint(int((_624 << 3u) + 880u) >> int(3u));
    uint _1399 = (_1382 << 16u) + (((packHalf2x16(vec2(max(abs(_1287), abs(_1288)), 0.0)) << 16u) + packHalf2x16(vec2(max(abs(_1287), abs(_1288)), 0.0))) & 65535u);
    uint _1403 = uint(int((_624 << 3u) + 40u) >> int(3u));
    uint _1421 = (packHalf2x16(vec2(max(unpackHalf2x16(_1399).y, abs(_1325)), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1399).x, abs(_1324)), 0.0));
    uint _1423;
    if (!_1362)
    {
        _1423 = 0u;
    }
    else
    {
        _1423 = _1399;
    }
    uint _1425;
    if (!_1362)
    {
        _1425 = 0u;
    }
    else
    {
        _1425 = _1382;
    }
    vec2 _1426 = unpackHalf2x16(_1254);
    float _1427 = _1426.x;
    vec2 _1428 = unpackHalf2x16(_1241);
    precise float _1433 = _1427 + (-_1428.x);
    precise float _1434 = _1427 + (-_1428.y);
    vec2 _1435 = unpackHalf2x16(_1421);
    vec2 _1438 = unpackHalf2x16(778448486u);
    bool _1442 = _1435.y > _1438.y;
    uint _1456 = (packHalf2x16(vec2(max(unpackHalf2x16(_1385).y, abs(_1434)), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1385).x, abs(_1433)), 0.0));
    vec2 _1460 = unpackHalf2x16(_1456);
    vec2 _1463 = unpackHalf2x16(778448486u);
    bool _1466 = _1460.x > _1463.x;
    bool _1467 = _1460.y > _1463.y;
    vec2 _1470 = unpackHalf2x16(778448486u);
    bool _1473 = (unpackHalf2x16(_1456).x > _1470.x) || _1467;
    uint _1663;
    uint _1664;
    uint _1665;
    uint _1666;
    uint _1667;
    if (_1362)
    {
        vec2 _1474 = unpackHalf2x16(_52._m0[_745].x);
        vec2 _1477 = unpackHalf2x16(_52._m0[_761].x);
        precise float _1482 = _1474.x + (-_1477.x);
        precise float _1483 = _1474.y + (-_1477.y);
        vec2 _1487 = unpackHalf2x16(_52._m0[_745].x);
        vec2 _1490 = unpackHalf2x16(_755.x);
        precise float _1495 = _1487.x + (-_1490.x);
        precise float _1496 = _1487.y + (-_1490.y);
        vec2 _1498 = unpackHalf2x16(_739.x);
        vec2 _1501 = unpackHalf2x16(_52._m0[_768].x);
        precise float _1506 = _1498.x + (-_1501.x);
        precise float _1507 = _1498.y + (-_1501.y);
        vec2 _1520 = unpackHalf2x16(_872);
        float _1521 = _1520.y;
        vec2 _1522 = unpackHalf2x16(_52._m0[_768].y);
        float _1523 = _1522.x;
        precise float _1526 = _1521 + (-_1523);
        precise float _1527 = _1521 + (-_1523);
        vec2 _1542 = unpackHalf2x16(_1241);
        float _1543 = _1542.x;
        vec2 _1544 = unpackHalf2x16((_1254 & 65535u) + (((_52._m0[_761].y << 16u) + (_1385 & 65535u)) & 4294901760u));
        precise float _1549 = _1543 + (-_1544.x);
        precise float _1550 = _1543 + (-_1544.y);
        uint _1562 = (packHalf2x16(vec2(max(abs(_1506), abs(_1507)), 0.0)) << 16u) + packHalf2x16(vec2(max(abs(_1506), abs(_1507)), 0.0));
        uint _1565 = (((packHalf2x16(vec2(max(abs(_1482), abs(_1483)), 0.0)) << 16u) + packHalf2x16(vec2(max(abs(_1482), abs(_1483)), 0.0))) << 16u) + (((packHalf2x16(vec2(max(abs(_1495), abs(_1496)), 0.0)) << 16u) + packHalf2x16(vec2(max(abs(_1495), abs(_1496)), 0.0))) & 65535u);
        vec2 _1566 = unpackHalf2x16(_1278);
        vec2 _1569 = unpackHalf2x16(1073758208u);
        precise float _1572 = _1566.x * _1569.x;
        precise float _1573 = _1566.y * _1569.y;
        uint _1587 = (packHalf2x16(vec2(max(unpackHalf2x16(_1562).x, abs(_1526)), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1562).x, abs(_1526)), 0.0));
        uint _1601 = (packHalf2x16(vec2(max(unpackHalf2x16(_1565).y, abs(_1550)), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1565).x, abs(_1549)), 0.0));
        uint _1604 = (_1587 << 16u) + (_932 & 65535u);
        uint _1620 = (packHalf2x16(vec2(max(unpackHalf2x16(_1278).y, unpackHalf2x16(_1601).y), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1278).x, unpackHalf2x16(_1601).x), 0.0));
        uint _1636 = (packHalf2x16(vec2(max(unpackHalf2x16(_1620).y, unpackHalf2x16(_1604).y), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1620).x, unpackHalf2x16(_1604).x), 0.0));
        uint _1652 = (packHalf2x16(vec2(max(unpackHalf2x16(_1636).x, unpackHalf2x16(_1636).y), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1636).x, unpackHalf2x16(_1636).y), 0.0));
        _1663 = _1604;
        _1664 = packHalf2x16(vec2(_1526, _1527));
        _1665 = _1587;
        _1666 = ((unpackHalf2x16(_1652).x < _1573) && _1316) ? 4u : 0u;
        _1667 = ((unpackHalf2x16(_1652).x < _1572) && ((0u | (0u | ((_1309.x > _1312.x) ? 2u : 0u))) != 0u)) ? 4u : 0u;
    }
    else
    {
        _1663 = _932;
        _1664 = _52._m0[_761].x;
        _1665 = _52._m0[_768].x;
        _1666 = _1425;
        _1667 = _1423;
    }
    vec2 _1670 = unpackHalf2x16(778448486u);
    bool _1673 = (unpackHalf2x16(_1421).x > _1670.x) || _1442;
    uint _1675;
    if (!_1473)
    {
        _1675 = 0u;
    }
    else
    {
        _1675 = _1664;
    }
    uint _1678;
    if (!_1473)
    {
        _1678 = 0u;
    }
    else
    {
        _1678 = _1665;
    }
    uint _1682 = (_52._m0[_1304].y << 16u) + (_52._m0[_784].y & 65535u);
    bool _1864;
    bool _1865;
    uint _1866;
    uint _1867;
    uint _1868;
    if (_1473)
    {
        vec2 _1683 = unpackHalf2x16(_755.x);
        vec2 _1686 = unpackHalf2x16(_52._m0[_1304].x);
        precise float _1691 = _1683.x + (-_1686.x);
        precise float _1692 = _1683.y + (-_1686.y);
        vec2 _1693 = unpackHalf2x16(_755.x);
        vec2 _1696 = unpackHalf2x16(_52._m0[_784].x);
        precise float _1701 = _1693.x + (-_1696.x);
        precise float _1702 = _1693.y + (-_1696.y);
        vec2 _1703 = unpackHalf2x16(_52._m0[_776].x);
        vec2 _1706 = unpackHalf2x16(_52._m0[_1340].x);
        precise float _1711 = _1703.x + (-_1706.x);
        precise float _1712 = _1703.y + (-_1706.y);
        precise float _1730 = unpackHalf2x16(_1241).y + (-unpackHalf2x16(_52._m0[_1340].y).x);
        vec2 _1743 = unpackHalf2x16(_1254);
        float _1744 = _1743.x;
        vec2 _1745 = unpackHalf2x16(_1682);
        precise float _1750 = _1744 + (-_1745.x);
        precise float _1751 = _1744 + (-_1745.y);
        uint _1763 = (packHalf2x16(vec2(max(abs(_1711), abs(_1712)), 0.0)) << 16u) + packHalf2x16(vec2(max(abs(_1711), abs(_1712)), 0.0));
        uint _1766 = (((packHalf2x16(vec2(max(abs(_1691), abs(_1692)), 0.0)) << 16u) + packHalf2x16(vec2(max(abs(_1691), abs(_1692)), 0.0))) << 16u) + (((packHalf2x16(vec2(max(abs(_1701), abs(_1702)), 0.0)) << 16u) + packHalf2x16(vec2(max(abs(_1701), abs(_1702)), 0.0))) & 65535u);
        vec2 _1767 = unpackHalf2x16(_1456);
        vec2 _1770 = unpackHalf2x16(1073758208u);
        precise float _1773 = _1767.x * _1770.x;
        precise float _1774 = _1767.y * _1770.y;
        uint _1802 = (packHalf2x16(vec2(max(unpackHalf2x16(_1766).y, abs(_1751)), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1766).x, abs(_1750)), 0.0));
        uint _1805 = (((packHalf2x16(vec2(max(unpackHalf2x16(_1763).x, abs(_1730)), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1763).x, abs(_1730)), 0.0))) << 16u) + (_1278 & 65535u);
        uint _1821 = (packHalf2x16(vec2(max(unpackHalf2x16(_1456).y, unpackHalf2x16(_1802).y), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1456).x, unpackHalf2x16(_1802).x), 0.0));
        uint _1837 = (packHalf2x16(vec2(max(unpackHalf2x16(_1821).y, unpackHalf2x16(_1805).y), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1821).x, unpackHalf2x16(_1805).x), 0.0));
        uint _1853 = (packHalf2x16(vec2(max(unpackHalf2x16(_1837).x, unpackHalf2x16(_1837).y), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1837).x, unpackHalf2x16(_1837).y), 0.0));
        bool _1857 = (unpackHalf2x16(_1853).x < _1773) && _1466;
        bool _1861 = (unpackHalf2x16(_1853).x < _1774) && _1467;
        _1864 = _1861;
        _1865 = _1857;
        _1866 = _1853;
        _1867 = _1857 ? 2u : 0u;
        _1868 = _1861 ? 2u : 0u;
    }
    else
    {
        _1864 = _1467;
        _1865 = _1466;
        _1866 = _52._m0[_776].x;
        _1867 = _1675;
        _1868 = _1678;
    }
    uint _1871;
    if (!_1673)
    {
        _1871 = 0u;
    }
    else
    {
        _1871 = _1868;
    }
    uint _1874;
    if (!_1673)
    {
        _1874 = 0u;
    }
    else
    {
        _1874 = _1866;
    }
    uint _2059;
    uint _2060;
    if (_1673)
    {
        vec2 _1878 = unpackHalf2x16(_52._m0[_784].x);
        vec2 _1881 = unpackHalf2x16(_52._m0[_1366].x);
        precise float _1886 = _1878.x + (-_1881.x);
        precise float _1887 = _1878.y + (-_1881.y);
        vec2 _1888 = unpackHalf2x16(_52._m0[_784].x);
        vec2 _1891 = unpackHalf2x16(_52._m0[_1389].x);
        precise float _1896 = _1888.x + (-_1891.x);
        precise float _1897 = _1888.y + (-_1891.y);
        vec2 _1898 = unpackHalf2x16(_794.x);
        vec2 _1901 = unpackHalf2x16(_52._m0[_1403].x);
        precise float _1906 = _1898.x + (-_1901.x);
        precise float _1907 = _1898.y + (-_1901.y);
        uint _1943 = (packHalf2x16(vec2(max(abs(_1906), abs(_1907)), 0.0)) << 16u) + packHalf2x16(vec2(max(abs(_1906), abs(_1907)), 0.0));
        uint _1946 = (((packHalf2x16(vec2(max(abs(_1896), abs(_1897)), 0.0)) << 16u) + packHalf2x16(vec2(max(abs(_1896), abs(_1897)), 0.0))) << 16u) + (((packHalf2x16(vec2(max(abs(_1886), abs(_1887)), 0.0)) << 16u) + packHalf2x16(vec2(max(abs(_1886), abs(_1887)), 0.0))) & 65535u);
        vec2 _1947 = unpackHalf2x16(_1682);
        float _1948 = _1947.x;
        vec2 _1949 = unpackHalf2x16((_52._m0[_1389].y << 16u) + (_52._m0[_1366].y & 65535u));
        precise float _1954 = _1948 + (-_1949.x);
        precise float _1955 = _1948 + (-_1949.y);
        precise float _1961 = unpackHalf2x16(_1254).y + (-unpackHalf2x16(_52._m0[_1403].y).x);
        uint _1975 = (packHalf2x16(vec2(max(unpackHalf2x16(_1946).y, abs(_1955)), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1946).x, abs(_1954)), 0.0));
        uint _2005 = (packHalf2x16(vec2(max(unpackHalf2x16(_1421).y, unpackHalf2x16(_1975).y), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1421).x, unpackHalf2x16(_1975).x), 0.0));
        vec2 _2006 = unpackHalf2x16(_1421);
        vec2 _2009 = unpackHalf2x16(1073758208u);
        precise float _2012 = _2006.x * _2009.x;
        precise float _2013 = _2006.y * _2009.y;
        uint _2016 = (((packHalf2x16(vec2(max(unpackHalf2x16(_1943).x, abs(_1961)), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1943).x, abs(_1961)), 0.0))) << 16u) + (_1456 & 65535u);
        uint _2032 = (packHalf2x16(vec2(max(unpackHalf2x16(_2005).y, unpackHalf2x16(_2016).y), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2005).x, unpackHalf2x16(_2016).x), 0.0));
        uint _2048 = (packHalf2x16(vec2(max(unpackHalf2x16(_2032).x, unpackHalf2x16(_2032).y), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2032).x, unpackHalf2x16(_2032).y), 0.0));
        _2059 = uint((unpackHalf2x16(_2048).x < _2013) && _1442);
        _2060 = uint((unpackHalf2x16(_2048).x < _2012) && (_1435.x > _1438.x));
    }
    else
    {
        _2059 = _1874;
        _2060 = _1871;
    }
    uint _2061 = ((_1225 | _1667) | _1867) | _2060;
    uint _2062 = ((_1224 | _1666) | _1868) | _2059;
    uint _2063 = _2061 | _2062;
    uint _2064 = uint(bitCount(_2063));
    uvec4 _2065 = subgroupBallot(true);
    uint _2066 = _2065.x;
    uint _2068 = ~0u;
    uint _2070 = gl_SubgroupInvocationID & 0u;
    uint _2083 = ~0u;
    uint _2085 = gl_SubgroupInvocationID & 0u;
    uint _2099 = ~0u;
    uint _2101 = gl_SubgroupInvocationID & 0u;
    uint _2115 = ~0u;
    uint _2117 = gl_SubgroupInvocationID & 0u;
    uint _2131 = ~0u;
    uint _2133 = gl_SubgroupInvocationID & 0u;
    uint _2147 = ~0u;
    uint _2149 = gl_SubgroupInvocationID & 0u;
    uint _2162 = (((((((int(((0u & 31u) & _2068) | _2070) <= int(_2070 | (31u & _2068))) ? subgroupBroadcast(_2064, 0u) : _2064) & (-((_2066 >> 0u) & 1u))) + (((int(((1u & 31u) & _2083) | _2085) <= int(_2085 | (31u & _2083))) ? subgroupBroadcast(_2064, 1u) : _2064) & (-((_2066 >> 1u) & 1u)))) + (((int(((2u & 31u) & _2099) | _2101) <= int(_2101 | (31u & _2099))) ? subgroupBroadcast(_2064, 2u) : _2064) & (-((_2066 >> 2u) & 1u)))) + (((int(((3u & 31u) & _2115) | _2117) <= int(_2117 | (31u & _2115))) ? subgroupBroadcast(_2064, 3u) : _2064) & (-((_2066 >> 3u) & 1u)))) + (((int(((4u & 31u) & _2131) | _2133) <= int(_2133 | (31u & _2131))) ? subgroupBroadcast(_2064, 4u) : _2064) & (-((_2066 >> 4u) & 1u)))) + (((int(((5u & 31u) & _2147) | _2149) <= int(_2149 | (31u & _2147))) ? subgroupBroadcast(_2064, 5u) : _2064) & (-((_2066 >> 5u) & 1u)));
    uint _2163 = ~0u;
    uint _2165 = gl_SubgroupInvocationID & 0u;
    uint _2180 = ~0u;
    uint _2182 = gl_SubgroupInvocationID & 0u;
    uint _2196 = ~0u;
    uint _2198 = gl_SubgroupInvocationID & 0u;
    uint _2213 = ~0u;
    uint _2215 = gl_SubgroupInvocationID & 0u;
    uint _2230 = ~0u;
    uint _2232 = gl_SubgroupInvocationID & 0u;
    uint _2247 = ~0u;
    uint _2249 = gl_SubgroupInvocationID & 0u;
    uint _2262 = (((((_2162 + (((int(((6u & 31u) & _2163) | _2165) <= int(_2165 | (31u & _2163))) ? subgroupBroadcast(_2064, 6u) : _2064) & (-((_2066 >> 6u) & 1u)))) + (((int(((7u & 31u) & _2180) | _2182) <= int(_2182 | (31u & _2180))) ? subgroupBroadcast(_2064, 7u) : _2064) & (-((_2066 >> 7u) & 1u)))) + (((int(((8u & 31u) & _2196) | _2198) <= int(_2198 | (31u & _2196))) ? subgroupBroadcast(_2064, 8u) : _2064) & (-((_2066 >> 8u) & 1u)))) + (((int(((9u & 31u) & _2213) | _2215) <= int(_2215 | (31u & _2213))) ? subgroupBroadcast(_2064, 9u) : _2064) & (-((_2066 >> 9u) & 1u)))) + (((int(((10u & 31u) & _2230) | _2232) <= int(_2232 | (31u & _2230))) ? subgroupBroadcast(_2064, 10u) : _2064) & (-((_2066 >> 10u) & 1u)))) + (((int(((11u & 31u) & _2247) | _2249) <= int(_2249 | (31u & _2247))) ? subgroupBroadcast(_2064, 11u) : _2064) & (-((_2066 >> 11u) & 1u)));
    uint _2263 = ~0u;
    uint _2265 = gl_SubgroupInvocationID & 0u;
    uint _2280 = ~0u;
    uint _2282 = gl_SubgroupInvocationID & 0u;
    uint _2297 = ~0u;
    uint _2299 = gl_SubgroupInvocationID & 0u;
    uint _2314 = ~0u;
    uint _2316 = gl_SubgroupInvocationID & 0u;
    uint _2330 = ~0u;
    uint _2332 = gl_SubgroupInvocationID & 0u;
    uint _2347 = ~0u;
    uint _2349 = gl_SubgroupInvocationID & 0u;
    uint _2362 = (((((_2262 + (((int(((12u & 31u) & _2263) | _2265) <= int(_2265 | (31u & _2263))) ? subgroupBroadcast(_2064, 12u) : _2064) & (-((_2066 >> 12u) & 1u)))) + (((int(((13u & 31u) & _2280) | _2282) <= int(_2282 | (31u & _2280))) ? subgroupBroadcast(_2064, 13u) : _2064) & (-((_2066 >> 13u) & 1u)))) + (((int(((14u & 31u) & _2297) | _2299) <= int(_2299 | (31u & _2297))) ? subgroupBroadcast(_2064, 14u) : _2064) & (-((_2066 >> 14u) & 1u)))) + (((int(((15u & 31u) & _2314) | _2316) <= int(_2316 | (31u & _2314))) ? subgroupBroadcast(_2064, 15u) : _2064) & (-((_2066 >> 15u) & 1u)))) + (((int(((16u & 31u) & _2330) | _2332) <= int(_2332 | (31u & _2330))) ? subgroupBroadcast(_2064, 16u) : _2064) & (-((_2066 >> 16u) & 1u)))) + (((int(((17u & 31u) & _2347) | _2349) <= int(_2349 | (31u & _2347))) ? subgroupBroadcast(_2064, 17u) : _2064) & (-((_2066 >> 17u) & 1u)));
    uint _2364 = ~0u;
    uint _2366 = gl_SubgroupInvocationID & 0u;
    uint _2381 = ~0u;
    uint _2383 = gl_SubgroupInvocationID & 0u;
    uint _2398 = ~0u;
    uint _2400 = gl_SubgroupInvocationID & 0u;
    uint _2415 = ~0u;
    uint _2417 = gl_SubgroupInvocationID & 0u;
    uint _2432 = ~0u;
    uint _2434 = gl_SubgroupInvocationID & 0u;
    uint _2449 = ~0u;
    uint _2451 = gl_SubgroupInvocationID & 0u;
    uint _2464 = (((((_2362 + (((int(((18u & 31u) & _2364) | _2366) <= int(_2366 | (31u & _2364))) ? subgroupBroadcast(_2064, 18u) : _2064) & (-((_2066 >> 18u) & 1u)))) + (((int(((19u & 31u) & _2381) | _2383) <= int(_2383 | (31u & _2381))) ? subgroupBroadcast(_2064, 19u) : _2064) & (-((_2066 >> 19u) & 1u)))) + (((int(((20u & 31u) & _2398) | _2400) <= int(_2400 | (31u & _2398))) ? subgroupBroadcast(_2064, 20u) : _2064) & (-((_2066 >> 20u) & 1u)))) + (((int(((21u & 31u) & _2415) | _2417) <= int(_2417 | (31u & _2415))) ? subgroupBroadcast(_2064, 21u) : _2064) & (-((_2066 >> 21u) & 1u)))) + (((int(((22u & 31u) & _2432) | _2434) <= int(_2434 | (31u & _2432))) ? subgroupBroadcast(_2064, 22u) : _2064) & (-((_2066 >> 22u) & 1u)))) + (((int(((23u & 31u) & _2449) | _2451) <= int(_2451 | (31u & _2449))) ? subgroupBroadcast(_2064, 23u) : _2064) & (-((_2066 >> 23u) & 1u)));
    uint _2465 = ~0u;
    uint _2467 = gl_SubgroupInvocationID & 0u;
    uint _2481 = ~0u;
    uint _2483 = gl_SubgroupInvocationID & 0u;
    uint _2497 = ~0u;
    uint _2499 = gl_SubgroupInvocationID & 0u;
    uint _2513 = ~0u;
    uint _2515 = gl_SubgroupInvocationID & 0u;
    uint _2530 = ~0u;
    uint _2532 = gl_SubgroupInvocationID & 0u;
    uint _2547 = ~0u;
    uint _2549 = gl_SubgroupInvocationID & 0u;
    uint _2562 = (((((_2464 + (((int(((24u & 31u) & _2465) | _2467) <= int(_2467 | (31u & _2465))) ? subgroupBroadcast(_2064, 24u) : _2064) & (-((_2066 >> 24u) & 1u)))) + (((int(((25u & 31u) & _2481) | _2483) <= int(_2483 | (31u & _2481))) ? subgroupBroadcast(_2064, 25u) : _2064) & (-((_2066 >> 25u) & 1u)))) + (((int(((26u & 31u) & _2497) | _2499) <= int(_2499 | (31u & _2497))) ? subgroupBroadcast(_2064, 26u) : _2064) & (-((_2066 >> 26u) & 1u)))) + (((int(((27u & 31u) & _2513) | _2515) <= int(_2515 | (31u & _2513))) ? subgroupBroadcast(_2064, 27u) : _2064) & (-((_2066 >> 27u) & 1u)))) + (((int(((28u & 31u) & _2530) | _2532) <= int(_2532 | (31u & _2530))) ? subgroupBroadcast(_2064, 28u) : _2064) & (-((_2066 >> 28u) & 1u)))) + (((int(((29u & 31u) & _2547) | _2549) <= int(_2549 | (31u & _2547))) ? subgroupBroadcast(_2064, 29u) : _2064) & (-((_2066 >> 29u) & 1u)));
    uint _2564 = ~0u;
    uint _2566 = gl_SubgroupInvocationID & 0u;
    uint _2573 = subgroupBroadcast(_2064, 30u);
    uint _2580 = ~0u;
    uint _2582 = gl_SubgroupInvocationID & 0u;
    uint _2589 = subgroupBroadcast(_2064, 31u);
    uint _2597 = (0u << 16u) + ((_2562 + (((int(((30u & 31u) & _2564) | _2566) <= int(_2566 | (31u & _2564))) ? _2573 : _2064) & (-((_2066 >> 30u) & 1u)))) + (((int(((31u & 31u) & _2580) | _2582) <= int(_2582 | (31u & _2580))) ? _2589 : _2064) & (-((_2066 >> 31u) & 1u))));
    bool _2598 = _2597 != 0u;
    if (!_2598)
    {
        return;
    }
    uint _2622 = bitfieldExtract(gl_LocalInvocationID.x >> 2u, int(0u), int(2u));
    uint _2638 = ((((bitfieldExtract(_2622, int(0u), int(16u)) * 65535u) + (bitfieldExtract(_2622, int(16u), int(16u)) * 65532u)) << 16u) + ((bitfieldExtract(_2622, int(0u), int(16u)) * 65532u) + 12u)) & 28u;
    uvec4 _2639 = subgroupBallot((bitfieldExtract(7u, int(1u), int(1u)) == 0u) ? _1865 : (!(bitfieldExtract(_2064, int(1u), int(1u)) == 0u)));
    uvec2 _2645 = unpackUint2x32(packUint2x32(uvec2(0u, (bitfieldExtract(_2061, int(0u), int(16u)) << 16u) + _2062)) << min(_2638, 32u));
    uint _2646 = _2645.y;
    uvec4 _2647 = subgroupBallot((bitfieldExtract(7u, int(0u), int(1u)) == 0u) ? _2598 : (!(bitfieldExtract(_2064, int(0u), int(1u)) == 0u)));
    bool _2649 = gl_SubgroupInvocationID != 0u;
    uvec4 _2650 = subgroupBallot((bitfieldExtract(7u, int(2u), int(1u)) == 0u) ? _1864 : (!(bitfieldExtract(_2064, int(2u), int(1u)) == 0u)));
    uint _2652;
    if (_2649)
    {
        _2652 = 0u;
    }
    else
    {
        _2652 = _2638;
    }
    uint _2703;
    if (!_2649)
    {
        uint _2667 = atomicAdd(ssbo1_1._m0[(c0_2.data[36u].x - (c0.data[72u] & 4294967280u)) >> 2u], _2597);
        uint _2672 = min(_2667, ((-_2597) + c0.data[30u]));
        uint _2675 = (_2672 + 95u) + _2597;
        uint _2682 = (bitfieldExtract(_2675, int(16u), int(16u)) * 43691u) + bitfieldExtract(bitfieldExtract(_2675, int(0u), int(16u)) * 43691u, int(16u), int(16u));
        uint _2702 = atomicMax(ssbo1_1._m0[((c0_2.data[36u].x + 4u) - (c0.data[72u] & 4294967280u)) >> 2u], ((((bitfieldExtract(_2675, int(0u), int(16u)) * 43690u) + bitfieldExtract(_2682, int(0u), int(16u))) >> 16u) + ((bitfieldExtract(_2675, int(16u), int(16u)) * 43690u) + bitfieldExtract(_2682, int(16u), int(16u)))) >> 6u);
        _2703 = _2672;
    }
    else
    {
        _2703 = _2652;
    }
    uint _2704 = 4u & 31u;
    // CUSTOM: Equivalent lane selection; Slang omits the capability for ShuffleXor.
    // Native: uint _2712 = subgroupShuffleXor(_2646, _2704);
    uint _2712 = subgroupShuffle(_2646, gl_SubgroupInvocationID ^ _2704);
    uint _2716 = ~0u;
    uint _2718 = gl_SubgroupInvocationID & 0u;
    uint _2725 = subgroupBroadcast(_2703, 0u);
    uint _2726 = (int(((0u & 31u) & _2716) | _2718) <= int(_2718 | (31u & _2716))) ? _2725 : _2703;
    bool _2730 = (_2063 & 4u) != 0u;
    bool _2732 = (_2063 & 8u) != 0u;
    bool _2734 = (_2063 & 2u) != 0u;
    bool _2736 = (_2063 & 1u) != 0u;
    uint _2737 = uint(bitCount(_2639.x & gl_SubgroupLtMask.x));
    uint _2738 = uint(bitCount(_2650.x & gl_SubgroupLtMask.x));
    uint _2739 = _2646 | ((int(gl_SubgroupInvocationID ^ _2704) <= int((gl_SubgroupInvocationID & 0u) | (31u & (~0u)))) ? _2712 : _2646);
    uint _2741;
    if (_2734)
    {
        _2741 = _616 << 16u;
    }
    else
    {
        _2741 = _872;
    }
    uint _2743;
    if (_2736)
    {
        _2743 = _616 << 16u;
    }
    else
    {
        _2743 = _2597;
    }
    uint _2744 = 8u & 31u;
    // CUSTOM: Native: uint _2752 = subgroupShuffleXor(_2739, _2744);
    uint _2752 = subgroupShuffle(_2739, gl_SubgroupInvocationID ^ _2744);
    uint _2762;
    if (_2736)
    {
        _2762 = _601 + 3u;
    }
    else
    {
        _2762 = _2737;
    }
    uint _2764;
    if (_2736)
    {
        _2764 = _2762 | _2743;
    }
    else
    {
        _2764 = _1663;
    }
    uint _2769 = bitfieldExtract(_2738, int(16u), int(16u)) * 4u;
    uint _2771 = (_2769 << 16u) + ((bitfieldExtract(_2738, int(0u), int(16u)) * 4u) + (((bitfieldExtract(_2737, int(16u), int(16u)) * 2u) << 16u) + ((bitfieldExtract(_2737, int(0u), int(16u)) * 2u) + uint(bitCount(_2647.x & gl_SubgroupLtMask.x)))));
    uint _2772 = _2771 + _2726;
    uint _2774;
    if (_2730)
    {
        _2774 = _601 + 1u;
    }
    else
    {
        _2774 = _2726;
    }
    uint _2776;
    if (_2730)
    {
        _2776 = _616 << 16u;
    }
    else
    {
        _2776 = _2771;
    }
    uint _2778;
    if (!_2732)
    {
        _2778 = _2772;
    }
    else
    {
        _2778 = _2738;
    }
    uint _2780;
    if (_2732)
    {
        _2780 = _2772 + 1u;
    }
    else
    {
        _2780 = _2778;
    }
    uint _2782;
    if (_2730)
    {
        _2782 = _2774 | _2776;
    }
    else
    {
        _2782 = _1254;
    }
    uint _2784;
    if (_2734)
    {
        _2784 = _601 + 2u;
    }
    else
    {
        _2784 = _2776;
    }
    uint _2786;
    if (!_2730)
    {
        _2786 = _2780;
    }
    else
    {
        _2786 = _2774;
    }
    uint _2787 = _2739 | ((int(gl_SubgroupInvocationID ^ _2744) <= int((gl_SubgroupInvocationID & 0u) | (31u & (~0u)))) ? _2752 : _2739);
    uint _2790;
    if (_2730)
    {
        _2790 = _2780 + 1u;
    }
    else
    {
        _2790 = _2786;
    }
    uint _2792;
    if (_2734)
    {
        _2792 = _2784 | _2741;
    }
    else
    {
        _2792 = _2741;
    }
    uint _2796;
    if (_2732)
    {
        _2796 = c0.data[68u];
    }
    else
    {
        _2796 = _2769;
    }
    uint _2799;
    if (_2732)
    {
        _2799 = (_2772 << 2u) + _2796;
    }
    else
    {
        _2799 = _2784;
    }
    if (_2732)
    {
    }
    uint _2801;
    if (!_2734)
    {
        _2801 = _2790;
    }
    else
    {
        _2801 = _2739;
    }
    uint _2805;
    if (_2732)
    {
        _2805 = _616 << 16u;
    }
    else
    {
        _2805 = _2772;
    }
    uint _2808;
    if (_2730)
    {
        _2808 = c0.data[68u];
    }
    else
    {
        _2808 = _2796;
    }
    uint _2811;
    if (_2730)
    {
        _2811 = (_2780 << 2u) + _2808;
    }
    else
    {
        _2811 = _2622;
    }
    if (_2730)
    {
    }
    if (_2732)
    {
    }
    if (_2732)
    {
    }
    if (_2732)
    {
    }
    if (_2732)
    {
    }
    uint _2813;
    if (_2734)
    {
        _2813 = _2790 + 1u;
    }
    else
    {
        _2813 = _2801;
    }
    uint _2816;
    if (_2734)
    {
        _2816 = c0.data[68u];
    }
    else
    {
        _2816 = _2808;
    }
    uint _2819;
    if (_2734)
    {
        _2819 = (_2790 << 2u) + _2816;
    }
    else
    {
        _2819 = _2780;
    }
    if (_2734)
    {
    }
    if (_2730)
    {
    }
    if (_2730)
    {
    }
    if (_2730)
    {
    }
    if (_2730)
    {
    }
    uint _2822;
    if (_2736)
    {
        _2822 = c0.data[68u];
    }
    else
    {
        _2822 = _2816;
    }
    uint _2825;
    if (_2736)
    {
        _2825 = (_2813 << 2u) + _2822;
    }
    else
    {
        _2825 = _2813;
    }
    if (_2736)
    {
    }
    uint _2827;
    if (_2732)
    {
        _2827 = _601 | _2805;
    }
    else
    {
        _2827 = gl_SubgroupLtMask.x;
    }
    if (_2734)
    {
    }
    if (_2734)
    {
    }
    if (_2734)
    {
    }
    if (_2734)
    {
    }
    if (_2736)
    {
    }
    if (_2736)
    {
    }
    if (_2736)
    {
    }
    if (_2736)
    {
    }
    if (_2732)
    {
        ssbo0_1._m0[(_2799 - (c0.data[68u] & 4294967280u)) >> 2u] = _2827;
    }
    if (_2730)
    {
        ssbo0_1._m0[(_2811 - (c0.data[68u] & 4294967280u)) >> 2u] = _2782;
    }
    if (_2734)
    {
        ssbo0_1._m0[(_2819 - (c0.data[68u] & 4294967280u)) >> 2u] = _2792;
    }
    if (_2736)
    {
        ssbo0_1._m0[(_2825 - (c0.data[68u] & 4294967280u)) >> 2u] = _2764;
    }
    if (!((_2622 == 0u) && (_2787 != 0u)))
    {
        return;
    }
    imageStore(cs_img0_150, ivec2(uvec2(_601 >> 2u, _616 >> 2u)), uvec4(_2787 >> 16u, _2787 & 65535u, 0u, 0u));
}

