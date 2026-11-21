#version 450
#extension GL_EXT_shader_explicit_arithmetic_types_int16 : require
#extension GL_EXT_shader_16bit_storage : require
#extension GL_EXT_scalar_block_layout : require
#extension GL_KHR_shader_subgroup_basic : require
#if defined(GL_EXT_control_flow_attributes)
#extension GL_EXT_control_flow_attributes : require
#define SPIRV_CROSS_FLATTEN [[flatten]]
#define SPIRV_CROSS_BRANCH [[dont_flatten]]
#define SPIRV_CROSS_UNROLL [[unroll]]
#define SPIRV_CROSS_LOOP [[dont_unroll]]
#else
#define SPIRV_CROSS_FLATTEN
#define SPIRV_CROSS_BRANCH
#define SPIRV_CROSS_UNROLL
#define SPIRV_CROSS_LOOP
#endif
#extension GL_KHR_shader_subgroup_shuffle : require
layout(local_size_x = 128, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, scalar) uniform cs_cbuf_block_5u
{
    uint data[16384];
} c0;

layout(set = 0, binding = 0, scalar) uniform cs_cbuf_block_5f
{
    float data[16384];
} c0_1;

layout(set = 0, binding = 1, std430) buffer ssbo0
{
    uint _m0[];
} ssbo0_1;

layout(set = 0, binding = 1, std430) buffer ssbo0_2
{
    uvec4 _m0[];
} ssbo0_3;

layout(set = 0, binding = 2) uniform sampler2D cs_tex0_c0;
layout(set = 0, binding = 3) uniform writeonly image2D cs_img0_d0;

// CUSTOM: Instrument native stores without modifying reconstruction arithmetic.
#include "./reconstruction.slangi"
// CUSTOM: Width-specific proxies address one shared backing allocation.
// ORIGINAL: shared _33 _36;
// ORIGINAL: shared _39 _42;
// ORIGINAL: shared _45 _48;
// ORIGINAL: shared _51 _54;
static _33 _36;
static _39 _42;
// Unused original views: shared _45 _48; shared _51 _54;

uvec2 _84(uvec4 _85, uvec2 _86, uvec2 _87)
{
    vec2 _105 = unpackHalf2x16(_87.x);
    float _92 = _105.x;
    float _93 = _105.y;
    vec2 _108 = unpackHalf2x16(_87.y);
    float _94 = _108.x;
    float _95 = _108.y;
    uint _90 = 0u;
    uint _113 = gl_SubgroupInvocationID & 4294967264u;
    uint _115 = gl_SubgroupInvocationID & 28u;
    uint _118 = (gl_SubgroupInvocationID & 3u) << 3u;
    uint _123;
    SPIRV_CROSS_LOOP
    for (;;)
    {
        _123 = _90;
        if (_123 < 8u)
        {
            bool _127 = _123 >= 4u;
            uint _128 = _123 & 3u;
            uint _130 = _113 + (_115 + _128);
            uint _132 = _113 + (_118 + _128);
            uint _133 = _127 ? _86.y : _86.x;
            vec2 _136 = unpackHalf2x16(subgroupShuffle(_133, _132 + 0u));
            vec2 _139 = unpackHalf2x16(subgroupShuffle(_133, _132 + 4u));
            vec2 _143 = unpackHalf2x16(subgroupShuffle(_127 ? _85.z : _85.x, _130));
            _92 = fma(_143.y, _136.y, fma(_143.x, _136.x, _92));
            _93 = fma(_143.y, _139.y, fma(_143.x, _139.x, _93));
            vec2 _160 = unpackHalf2x16(subgroupShuffle(_127 ? _85.w : _85.y, _130));
            _94 = fma(_160.y, _136.y, fma(_160.x, _136.x, _94));
            _95 = fma(_160.y, _139.y, fma(_160.x, _139.x, _95));
            SPIRV_CROSS_BRANCH
            if (_128 == 3u)
            {
                uint _178 = floatBitsToUint(_92);
                uint _180 = _178 & 2147483647u;
                uint _189 = ((_180 + 4095u) + ((_180 >> 13u) & 1u)) & 4294959104u;
                _92 = uintBitsToFloat(((_180 >= 2139095040u) ? _180 : ((_180 >= 947912704u) ? ((_189 >= 1199570944u) ? 2139095040u : _189) : floatBitsToUint(roundEven(uintBitsToFloat(_180) * 16777216.0) * 5.9604644775390625e-08))) | (_178 & 2147483648u));
                uint _211 = floatBitsToUint(_93);
                uint _212 = _211 & 2147483647u;
                uint _217 = ((_212 + 4095u) + ((_212 >> 13u) & 1u)) & 4294959104u;
                _93 = uintBitsToFloat(((_212 >= 2139095040u) ? _212 : ((_212 >= 947912704u) ? ((_217 >= 1199570944u) ? 2139095040u : _217) : floatBitsToUint(roundEven(uintBitsToFloat(_212) * 16777216.0) * 5.9604644775390625e-08))) | (_211 & 2147483648u));
                uint _233 = floatBitsToUint(_94);
                uint _234 = _233 & 2147483647u;
                uint _239 = ((_234 + 4095u) + ((_234 >> 13u) & 1u)) & 4294959104u;
                _94 = uintBitsToFloat(((_234 >= 2139095040u) ? _234 : ((_234 >= 947912704u) ? ((_239 >= 1199570944u) ? 2139095040u : _239) : floatBitsToUint(roundEven(uintBitsToFloat(_234) * 16777216.0) * 5.9604644775390625e-08))) | (_233 & 2147483648u));
                uint _255 = floatBitsToUint(_95);
                uint _256 = _255 & 2147483647u;
                uint _261 = ((_256 + 4095u) + ((_256 >> 13u) & 1u)) & 4294959104u;
                _95 = uintBitsToFloat(((_256 >= 2139095040u) ? _256 : ((_256 >= 947912704u) ? ((_261 >= 1199570944u) ? 2139095040u : _261) : floatBitsToUint(roundEven(uintBitsToFloat(_256) * 16777216.0) * 5.9604644775390625e-08))) | (_255 & 2147483648u));
            }
            _90 = _123 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return uvec2(packHalf2x16(vec2(_92, _93)), packHalf2x16(vec2(_94, _95)));
}

void main()
{
    // CUSTOM: Uniform branch before any native workgroup synchronization.
    if (custom_aa.aa_strength == 0.f) {
        CustomLinearReconstruction();
        return;
    }
    uint _626 = gl_LocalInvocationID.x + 128u;
    uint _628 = gl_LocalInvocationID.x >> 4u;
    uint _631 = _626 >> 4u;
    uint _636 = ((gl_LocalInvocationID.x << 1u) | (~30u)) & 30u;
    uint _637 = gl_WorkGroupID.x << 2u;
    uint _639 = (gl_WorkGroupID.y << 2u) * 5u;
    uint _642 = ((_626 << 1u) | (~30u)) & 30u;
    precise float _682 = float(int((((bitfieldExtract(_637, int(16u), int(16u)) * 5u) << 16u) + ((bitfieldExtract(_637, int(0u), int(16u)) * 5u) + _636)) + 4294967291u)) + 1.0;
    precise float _684 = float(int((((bitfieldExtract(_628, int(16u), int(16u)) * 2u) << 16u) + ((bitfieldExtract(_628, int(0u), int(16u)) * 2u) + _639)) + 4294967291u)) + 1.0;
    precise float _685 = float(int((((bitfieldExtract(_631, int(16u), int(16u)) * 2u) << 16u) + ((bitfieldExtract(_631, int(0u), int(16u)) * 2u) + _639)) + 4294967291u)) + 1.0;
    precise float _689 = _682 * c0_1.data[12u];
    precise float _690 = float(int((((bitfieldExtract(_637, int(16u), int(16u)) * 5u) << 16u) + ((bitfieldExtract(_637, int(0u), int(16u)) * 5u) + _642)) + 4294967291u)) + 1.0;
    precise float _693 = _684 * c0_1.data[13u];
    precise float _696 = _685 * c0_1.data[13u];
    precise float _699 = _690 * c0_1.data[12u];
    vec4 _714 = textureGatherOffsets(cs_tex0_c0, vec2(_689, _693), ivec2[](ivec2(0), ivec2(1, 0), ivec2(0, 1), ivec2(1)));
    vec4 _735 = textureGatherOffsets(cs_tex0_c0, vec2(_699, _696), ivec2[](ivec2(0), ivec2(1, 0), ivec2(0, 1), ivec2(1)));
    vec4 _756 = textureGatherOffsets(cs_tex0_c0, vec2(_689, _693), ivec2[](ivec2(0), ivec2(1, 0), ivec2(0, 1), ivec2(1)), int(1u));
    vec4 _777 = textureGatherOffsets(cs_tex0_c0, vec2(_699, _696), ivec2[](ivec2(0), ivec2(1, 0), ivec2(0, 1), ivec2(1)), int(1u));
    vec4 _798 = textureGatherOffsets(cs_tex0_c0, vec2(_689, _693), ivec2[](ivec2(0), ivec2(1, 0), ivec2(0, 1), ivec2(1)), int(2u));
    vec4 _819 = textureGatherOffsets(cs_tex0_c0, vec2(_699, _696), ivec2[](ivec2(0), ivec2(1, 0), ivec2(0, 1), ivec2(1)), int(2u));
    uint _849 = (gl_SubgroupInvocationID << 4u) + c0.data[44u];
    uint _855 = (_849 - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec4 _857 = ssbo0_3._m0[_855];
    uint _868 = ((_849 + 512u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec4 _870 = ssbo0_3._m0[_868];
    uint _881 = ((_849 + 1024u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec4 _883 = ssbo0_3._m0[_881];
    uint _894 = ((_849 + 1536u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec4 _896 = ssbo0_3._m0[_894];
    uint _907 = ((_849 + 2048u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec4 _909 = ssbo0_3._m0[_907];
    uint _919 = ((_849 + 2560u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec4 _921 = ssbo0_3._m0[_919];
    uint _932 = ((_849 + 3072u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec4 _934 = ssbo0_3._m0[_932];
    uint _946 = gl_SubgroupInvocationID & 3u;
    uint _947 = gl_LocalInvocationID.x >> 5u;
    vec2 _949 = unpackHalf2x16((packHalf2x16(vec2(_819.w, 0.0)) << 16u) + packHalf2x16(vec2(_819.z, 0.0)));
    vec2 _952 = unpackHalf2x16(748563614u);
    precise float _955 = _949.x * _952.x;
    precise float _956 = _949.y * _952.y;
    vec2 _957 = unpackHalf2x16((packHalf2x16(vec2(_798.w, 0.0)) << 16u) + packHalf2x16(vec2(_798.z, 0.0)));
    vec2 _960 = unpackHalf2x16(748563614u);
    precise float _963 = _957.x * _960.x;
    precise float _964 = _957.y * _960.y;
    vec2 _965 = unpackHalf2x16((packHalf2x16(vec2(_798.y, 0.0)) << 16u) + packHalf2x16(vec2(_798.x, 0.0)));
    vec2 _968 = unpackHalf2x16(748563614u);
    precise float _971 = _965.x * _968.x;
    precise float _972 = _965.y * _968.y;
    vec2 _973 = unpackHalf2x16((packHalf2x16(vec2(_819.y, 0.0)) << 16u) + packHalf2x16(vec2(_819.x, 0.0)));
    vec2 _976 = unpackHalf2x16(748563614u);
    precise float _979 = _973.x * _976.x;
    precise float _980 = _973.y * _976.y;
    uint _981 = (((bitfieldExtract(_628, int(16u), int(16u)) * 80u) << 16u) + ((bitfieldExtract(_628, int(0u), int(16u)) * 80u) + _636)) << 1u;
    vec2 _983 = unpackHalf2x16((packHalf2x16(vec2(_735.w, 0.0)) << 16u) + packHalf2x16(vec2(_735.z, 0.0)));
    vec2 _986 = unpackHalf2x16(852308685u);
    uint _991 = (((bitfieldExtract(_631, int(16u), int(16u)) * 80u) << 16u) + ((bitfieldExtract(_631, int(0u), int(16u)) * 80u) + _642)) << 1u;
    uint _998 = ((_849 + 3584u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec4 _1000 = ssbo0_3._m0[_998];
    vec2 _1005 = unpackHalf2x16((packHalf2x16(vec2(_714.w, 0.0)) << 16u) + packHalf2x16(vec2(_714.z, 0.0)));
    vec2 _1008 = unpackHalf2x16(852308685u);
    uint _1013 = _946 << 1u;
    vec2 _1014 = unpackHalf2x16((packHalf2x16(vec2(_714.y, 0.0)) << 16u) + packHalf2x16(vec2(_714.x, 0.0)));
    vec2 _1017 = unpackHalf2x16(852308685u);
    vec2 _1022 = unpackHalf2x16((packHalf2x16(vec2(_735.y, 0.0)) << 16u) + packHalf2x16(vec2(_735.x, 0.0)));
    vec2 _1025 = unpackHalf2x16(852308685u);
    vec2 _1031 = unpackHalf2x16((packHalf2x16(vec2(_756.w, 0.0)) << 16u) + packHalf2x16(vec2(_756.z, 0.0)));
    vec2 _1034 = unpackHalf2x16(968374712u);
    vec2 _1041 = unpackHalf2x16((packHalf2x16(vec2(_756.y, 0.0)) << 16u) + packHalf2x16(vec2(_756.x, 0.0)));
    vec2 _1044 = unpackHalf2x16(968374712u);
    vec2 _1051 = unpackHalf2x16((packHalf2x16(vec2(_777.y, 0.0)) << 16u) + packHalf2x16(vec2(_777.x, 0.0)));
    vec2 _1054 = unpackHalf2x16(968374712u);
    vec2 _1061 = unpackHalf2x16((packHalf2x16(vec2(_777.w, 0.0)) << 16u) + packHalf2x16(vec2(_777.z, 0.0)));
    vec2 _1064 = unpackHalf2x16(968374712u);
    _42._m0[uint(int(_981) >> int(2u))] = packHalf2x16(vec2(fma(_1041.x, _1044.x, fma(_1014.x, _1017.x, _971)), fma(_1041.y, _1044.y, fma(_1014.y, _1017.y, _972))));
    _42._m0[uint(int(_981 + 80u) >> int(2u))] = packHalf2x16(vec2(fma(_1031.x, _1034.x, fma(_1005.x, _1008.x, _963)), fma(_1031.y, _1034.y, fma(_1005.y, _1008.y, _964))));
    _42._m0[uint(int(_991) >> int(2u))] = packHalf2x16(vec2(fma(_1051.x, _1054.x, fma(_1022.x, _1025.x, _979)), fma(_1051.y, _1054.y, fma(_1022.y, _1025.y, _980))));
    _42._m0[uint(int(_991 + 80u) >> int(2u))] = packHalf2x16(vec2(fma(_1061.x, _1064.x, fma(_983.x, _986.x, _955)), fma(_1061.y, _1064.y, fma(_983.y, _986.y, _956))));
    uint _1081 = gl_SubgroupInvocationID >> 2u;
    uint _1097 = (((bitfieldExtract(_1081, int(16u), int(16u)) * 40u) << 16u) + ((bitfieldExtract(_1081, int(0u), int(16u)) * 40u) + (((bitfieldExtract(_947, int(16u), int(16u)) * 5u) << 16u) + ((bitfieldExtract(_947, int(0u), int(16u)) * 5u) + _1013)))) << 1u;
    barrier();
    uint _1105 = ((_849 + 4096u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec4 _1107 = ssbo0_3._m0[_1105];
    uint16_t _1114 = _36._m0[uint(int(_1097) >> int(1u))];
    uint16_t _1119 = _36._m0[uint(int(_1097 + 2u) >> int(1u))];
    uint16_t _1124 = _36._m0[uint(int(_1097 + 16u) >> int(1u))];
    uint16_t _1130 = _36._m0[uint(int(_1097 + 18u) >> int(1u))];
    uint16_t _1135 = _36._m0[uint(int(_1097 + 640u) >> int(1u))];
    uint16_t _1141 = _36._m0[uint(int(_1097 + 642u) >> int(1u))];
    uint16_t _1147 = _36._m0[uint(int(_1097 + 656u) >> int(1u))];
    uint16_t _1153 = _36._m0[uint(int(_1097 + 658u) >> int(1u))];
    uint16_t _1159 = _36._m0[uint(int(_1097 + 400u) >> int(1u))];
    uint16_t _1165 = _36._m0[uint(int(_1097 + 402u) >> int(1u))];
    uint16_t _1171 = _36._m0[uint(int(_1097 + 416u) >> int(1u))];
    uint _1176 = (uint(_1119) << 16u) + (uint(_1114) & 65535u);
    uint16_t _1181 = _36._m0[uint(int(_1097 + 418u) >> int(1u))];
    uint16_t _1187 = _36._m0[uint(int(_1097 + 1040u) >> int(1u))];
    uint _1191 = (uint(_1130) << 16u) + (uint(_1124) & 65535u);
    uint16_t _1196 = _36._m0[uint(int(_1097 + 1042u) >> int(1u))];
    uint16_t _1202 = _36._m0[uint(int(_1097 + 1056u) >> int(1u))];
    uint16_t _1208 = _36._m0[uint(int(_1097 + 1058u) >> int(1u))];
    uint16_t _1214 = _36._m0[uint(int(_1097 + 800u) >> int(1u))];
    uint16_t _1220 = _36._m0[uint(int(_1097 + 802u) >> int(1u))];
    uint16_t _1226 = _36._m0[uint(int(_1097 + 816u) >> int(1u))];
    uint16_t _1232 = _36._m0[uint(int(_1097 + 818u) >> int(1u))];
    uint16_t _1238 = _36._m0[uint(int(_1097 + 1440u) >> int(1u))];
    uint16_t _1244 = _36._m0[uint(int(_1097 + 1442u) >> int(1u))];
    uint16_t _1250 = _36._m0[uint(int(_1097 + 1456u) >> int(1u))];
    uint16_t _1256 = _36._m0[uint(int(_1097 + 1458u) >> int(1u))];
    uint16_t _1262 = _36._m0[uint(int(_1097 + 1200u) >> int(1u))];
    uint16_t _1268 = _36._m0[uint(int(_1097 + 1202u) >> int(1u))];
    uint16_t _1274 = _36._m0[uint(int(_1097 + 1216u) >> int(1u))];
    uint16_t _1280 = _36._m0[uint(int(_1097 + 1218u) >> int(1u))];
    uint16_t _1286 = _36._m0[uint(int(_1097 + 1840u) >> int(1u))];
    uint16_t _1292 = _36._m0[uint(int(_1097 + 1842u) >> int(1u))];
    uint16_t _1298 = _36._m0[uint(int(_1097 + 1856u) >> int(1u))];
    uint16_t _1304 = _36._m0[uint(int(_1097 + 1858u) >> int(1u))];
    barrier();
    uint _1308 = (uint(_1141) << 16u) + (uint(_1135) & 65535u);
    uvec2 _1312 = _84(uvec4(_857), uvec2(_1176, _1191), uvec2(0u));
    uint _1313 = _1312.x;
    uint _1317 = (uint(_1153) << 16u) + (uint(_1147) & 65535u);
    uint _1324 = ((_849 + 5120u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uint _1333 = (uint(_1165) << 16u) + (uint(_1159) & 65535u);
    uint _1336 = (uint(_1181) << 16u) + (uint(_1171) & 65535u);
    uint _1343 = ((_849 + 4608u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec2 _1353 = _84(uvec4(_857), uvec2(_1308, _1317), uvec2(0u));
    uint _1354 = _1353.x;
    uint _1358 = (uint(_1196) << 16u) + (uint(_1187) & 65535u);
    uint _1361 = (uint(_1208) << 16u) + (uint(_1202) & 65535u);
    uint _1364 = (uint(_1220) << 16u) + (uint(_1214) & 65535u);
    uint _1367 = (uint(_1232) << 16u) + (uint(_1226) & 65535u);
    uvec2 _1371 = _84(uvec4(_857), uvec2(_1333, _1336), uvec2(0u));
    uint _1372 = _1371.x;
    uint _1376 = (uint(_1244) << 16u) + (uint(_1238) & 65535u);
    uint _1379 = (uint(_1256) << 16u) + (uint(_1250) & 65535u);
    uint _1382 = (uint(_1268) << 16u) + (uint(_1262) & 65535u);
    uint _1385 = (uint(_1280) << 16u) + (uint(_1274) & 65535u);
    uint _1388 = (uint(_1292) << 16u) + (uint(_1286) & 65535u);
    uint _1391 = (uint(_1304) << 16u) + (uint(_1298) & 65535u);
    uvec2 _1395 = _84(uvec4(_857), uvec2(_1358, _1361), uvec2(0u));
    uint _1396 = _1395.x;
    uvec2 _1401 = _84(uvec4(_857), uvec2(_1364, _1367), uvec2(0u));
    uint _1402 = _1401.x;
    uvec2 _1407 = _84(uvec4(_857), uvec2(_1376, _1379), uvec2(0u));
    uint _1408 = _1407.x;
    uvec2 _1413 = _84(uvec4(_857), uvec2(_1382, _1385), uvec2(0u));
    uint _1414 = _1413.x;
    uvec2 _1419 = _84(uvec4(_857), uvec2(_1388, _1391), uvec2(0u));
    uint _1420 = _1419.x;
    uint _1440 = ((_849 + 5632u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec2 _1486 = _84(uvec4(_883), uvec2(_1333, _1336), uvec2(0u));
    uint _1487 = _1486.x;
    uvec2 _1492 = _84(uvec4(_883), uvec2(_1358, _1361), uvec2(0u));
    uint _1493 = _1492.x;
    uvec2 _1498 = _84(uvec4(_883), uvec2(_1176, _1191), uvec2(0u));
    uint _1499 = _1498.x;
    uvec2 _1504 = _84(uvec4(_883), uvec2(_1308, _1317), uvec2(0u));
    uint _1505 = _1504.x;
    uvec2 _1510 = _84(uvec4(_883), uvec2(_1364, _1367), uvec2(0u));
    uint _1511 = _1510.x;
    uvec2 _1516 = _84(uvec4(_883), uvec2(_1376, _1379), uvec2(0u));
    uint _1517 = _1516.x;
    uvec2 _1522 = _84(uvec4(_883), uvec2(_1382, _1385), uvec2(0u));
    uint _1523 = _1522.x;
    uvec2 _1528 = _84(uvec4(_883), uvec2(_1388, _1391), uvec2(0u));
    uint _1529 = _1528.x;
    uint _1537 = ((_849 + 6144u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec2 _1547 = _84(uvec4(_1487, _1486.y, _1493, _1492.y), uvec2(_896.zw), uvec2(_84(uvec4(_1372, _1371.y, _1396, _1395.y), uvec2(_870.zw), uvec2(0u))));
    uint _1548 = _1547.x;
    uint _1549 = _1547.y;
    uvec2 _1553 = _84(uvec4(_1499, _1498.y, _1505, _1504.y), uvec2(_896.xy), uvec2(_84(uvec4(_1313, _1312.y, _1354, _1353.y), uvec2(_870.xy), uvec2(0u))));
    uint _1554 = _1553.x;
    uint _1555 = _1553.y;
    uvec2 _1559 = _84(uvec4(_1487, _1486.y, _1493, _1492.y), uvec2(_896.xy), uvec2(_84(uvec4(_1372, _1371.y, _1396, _1395.y), uvec2(_870.xy), uvec2(0u))));
    uint _1560 = _1559.x;
    uint _1561 = _1559.y;
    uvec2 _1565 = _84(uvec4(_1511, _1510.y, _1517, _1516.y), uvec2(_896.xy), uvec2(_84(uvec4(_1402, _1401.y, _1408, _1407.y), uvec2(_870.xy), uvec2(0u))));
    uint _1566 = _1565.x;
    uint _1567 = _1565.y;
    uvec2 _1571 = _84(uvec4(_1523, _1522.y, _1529, _1528.y), uvec2(_896.xy), uvec2(_84(uvec4(_1414, _1413.y, _1420, _1419.y), uvec2(_870.xy), uvec2(0u))));
    uint _1572 = _1571.x;
    uint _1573 = _1571.y;
    uvec2 _1577 = _84(uvec4(_1523, _1522.y, _1529, _1528.y), uvec2(_896.zw), uvec2(_84(uvec4(_1414, _1413.y, _1420, _1419.y), uvec2(_870.zw), uvec2(0u))));
    uint _1578 = _1577.x;
    uint _1579 = _1577.y;
    uint _1586 = ((_849 + 6656u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec2 _1596 = _84(uvec4(_1499, _1498.y, _1505, _1504.y), uvec2(_896.zw), uvec2(_84(uvec4(_1313, _1312.y, _1354, _1353.y), uvec2(_870.zw), uvec2(0u))));
    uint _1597 = _1596.x;
    uint _1598 = _1596.y;
    uint _1605 = ((_849 + 7168u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec2 _1615 = _84(uvec4(_1511, _1510.y, _1517, _1516.y), uvec2(_896.zw), uvec2(_84(uvec4(_1402, _1401.y, _1408, _1407.y), uvec2(_870.zw), uvec2(0u))));
    uint _1616 = _1615.x;
    uint _1617 = _1615.y;
    vec2 _1620 = unpackHalf2x16(0u);
    vec2 _1627 = unpackHalf2x16(0u);
    uint _1633 = (packHalf2x16(vec2(max(unpackHalf2x16(_1554).y, _1627.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1554).x, _1620.x), 0.0));
    vec2 _1636 = unpackHalf2x16(0u);
    vec2 _1643 = unpackHalf2x16(0u);
    uint _1649 = (packHalf2x16(vec2(max(unpackHalf2x16(_1560).y, _1643.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1560).x, _1636.x), 0.0));
    vec2 _1652 = unpackHalf2x16(0u);
    vec2 _1659 = unpackHalf2x16(0u);
    uint _1665 = (packHalf2x16(vec2(max(unpackHalf2x16(_1548).y, _1659.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1548).x, _1652.x), 0.0));
    vec2 _1668 = unpackHalf2x16(0u);
    vec2 _1675 = unpackHalf2x16(0u);
    uint _1681 = (packHalf2x16(vec2(max(unpackHalf2x16(_1561).y, _1675.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1561).x, _1668.x), 0.0));
    vec2 _1684 = unpackHalf2x16(0u);
    vec2 _1691 = unpackHalf2x16(0u);
    uint _1697 = (packHalf2x16(vec2(max(unpackHalf2x16(_1549).y, _1691.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1549).x, _1684.x), 0.0));
    vec2 _1700 = unpackHalf2x16(0u);
    vec2 _1707 = unpackHalf2x16(0u);
    uint _1713 = (packHalf2x16(vec2(max(unpackHalf2x16(_1566).y, _1707.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1566).x, _1700.x), 0.0));
    vec2 _1716 = unpackHalf2x16(0u);
    vec2 _1723 = unpackHalf2x16(0u);
    uint _1729 = (packHalf2x16(vec2(max(unpackHalf2x16(_1567).y, _1723.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1567).x, _1716.x), 0.0));
    vec2 _1732 = unpackHalf2x16(0u);
    vec2 _1739 = unpackHalf2x16(0u);
    uint _1745 = (packHalf2x16(vec2(max(unpackHalf2x16(_1597).y, _1739.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1597).x, _1732.x), 0.0));
    vec2 _1748 = unpackHalf2x16(0u);
    vec2 _1755 = unpackHalf2x16(0u);
    uint _1761 = (packHalf2x16(vec2(max(unpackHalf2x16(_1555).y, _1755.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1555).x, _1748.x), 0.0));
    vec2 _1764 = unpackHalf2x16(0u);
    vec2 _1771 = unpackHalf2x16(0u);
    uint _1777 = (packHalf2x16(vec2(max(unpackHalf2x16(_1598).y, _1771.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1598).x, _1764.x), 0.0));
    vec2 _1780 = unpackHalf2x16(0u);
    vec2 _1787 = unpackHalf2x16(0u);
    uint _1793 = (packHalf2x16(vec2(max(unpackHalf2x16(_1616).y, _1787.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1616).x, _1780.x), 0.0));
    vec2 _1796 = unpackHalf2x16(0u);
    vec2 _1803 = unpackHalf2x16(0u);
    uint _1809 = (packHalf2x16(vec2(max(unpackHalf2x16(_1617).y, _1803.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1617).x, _1796.x), 0.0));
    vec2 _1812 = unpackHalf2x16(0u);
    vec2 _1819 = unpackHalf2x16(0u);
    uint _1825 = (packHalf2x16(vec2(max(unpackHalf2x16(_1572).y, _1819.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1572).x, _1812.x), 0.0));
    vec2 _1828 = unpackHalf2x16(0u);
    vec2 _1835 = unpackHalf2x16(0u);
    uint _1841 = (packHalf2x16(vec2(max(unpackHalf2x16(_1573).y, _1835.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1573).x, _1828.x), 0.0));
    vec2 _1844 = unpackHalf2x16(0u);
    vec2 _1851 = unpackHalf2x16(0u);
    uint _1857 = (packHalf2x16(vec2(max(unpackHalf2x16(_1578).y, _1851.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1578).x, _1844.x), 0.0));
    vec2 _1860 = unpackHalf2x16(0u);
    vec2 _1867 = unpackHalf2x16(0u);
    uint _1873 = (packHalf2x16(vec2(max(unpackHalf2x16(_1579).y, _1867.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1579).x, _1860.x), 0.0));
    uvec2 _1877 = _84(uvec4(_909), uvec2(_1633, _1745), uvec2(0u));
    uint _1878 = _1877.x;
    uvec2 _1883 = _84(uvec4(_909), uvec2(_1761, _1777), uvec2(0u));
    uint _1884 = _1883.x;
    uvec2 _1889 = _84(uvec4(_909), uvec2(_1649, _1665), uvec2(0u));
    uint _1890 = _1889.x;
    uvec2 _1895 = _84(uvec4(_909), uvec2(_1681, _1697), uvec2(0u));
    uint _1896 = _1895.x;
    uvec2 _1901 = _84(uvec4(_909), uvec2(_1713, _1793), uvec2(0u));
    uint _1902 = _1901.x;
    uvec2 _1907 = _84(uvec4(_909), uvec2(_1729, _1809), uvec2(0u));
    uint _1908 = _1907.x;
    uvec2 _1913 = _84(uvec4(_909), uvec2(_1825, _1857), uvec2(0u));
    uint _1914 = _1913.x;
    uvec2 _1919 = _84(uvec4(_909), uvec2(_1841, _1873), uvec2(0u));
    uint _1920 = _1919.x;
    uint _1928 = ((_849 + 7680u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec2 _1962 = _84(uvec4(_934), uvec2(_1633, _1745), uvec2(0u));
    uint _1963 = _1962.x;
    uvec2 _1968 = _84(uvec4(_934), uvec2(_1761, _1777), uvec2(0u));
    uint _1969 = _1968.x;
    uvec2 _1986 = _84(uvec4(_934), uvec2(_1649, _1665), uvec2(0u));
    uint _1987 = _1986.x;
    uvec2 _1992 = _84(uvec4(_934), uvec2(_1681, _1697), uvec2(0u));
    uint _1993 = _1992.x;
    uvec2 _2010 = _84(uvec4(_934), uvec2(_1713, _1793), uvec2(0u));
    uint _2011 = _2010.x;
    uvec2 _2016 = _84(uvec4(_934), uvec2(_1729, _1809), uvec2(0u));
    uint _2017 = _2016.x;
    uvec2 _2022 = _84(uvec4(_934), uvec2(_1825, _1857), uvec2(0u));
    uint _2023 = _2022.x;
    uvec2 _2028 = _84(uvec4(_934), uvec2(_1841, _1873), uvec2(0u));
    uint _2029 = _2028.x;
    uint _2037 = ((_849 + 8192u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uint _2050 = ((_849 + 8704u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec2 _2060 = _84(uvec4(_1963, _1962.y, _1969, _1968.y), uvec2(_1000.zw), uvec2(_84(uvec4(_1878, _1877.y, _1884, _1883.y), uvec2(_921.zw), uvec2(0u))));
    uint _2061 = _2060.x;
    uint _2062 = _2060.y;
    uvec2 _2066 = _84(uvec4(_1963, _1962.y, _1969, _1968.y), uvec2(_1000.xy), uvec2(_84(uvec4(_1878, _1877.y, _1884, _1883.y), uvec2(_921.xy), uvec2(0u))));
    uint _2067 = _2066.x;
    uint _2068 = _2066.y;
    uvec2 _2072 = _84(uvec4(_1987, _1986.y, _1993, _1992.y), uvec2(_1000.xy), uvec2(_84(uvec4(_1890, _1889.y, _1896, _1895.y), uvec2(_921.xy), uvec2(0u))));
    uint _2073 = _2072.x;
    uint _2074 = _2072.y;
    uvec2 _2078 = _84(uvec4(_1987, _1986.y, _1993, _1992.y), uvec2(_1000.zw), uvec2(_84(uvec4(_1890, _1889.y, _1896, _1895.y), uvec2(_921.zw), uvec2(0u))));
    uint _2079 = _2078.x;
    uint _2080 = _2078.y;
    uvec2 _2084 = _84(uvec4(_2011, _2010.y, _2017, _2016.y), uvec2(_1000.xy), uvec2(_84(uvec4(_1902, _1901.y, _1908, _1907.y), uvec2(_921.xy), uvec2(0u))));
    uint _2085 = _2084.x;
    uint _2086 = _2084.y;
    uvec2 _2090 = _84(uvec4(_2011, _2010.y, _2017, _2016.y), uvec2(_1000.zw), uvec2(_84(uvec4(_1902, _1901.y, _1908, _1907.y), uvec2(_921.zw), uvec2(0u))));
    uint _2091 = _2090.x;
    uint _2092 = _2090.y;
    uvec2 _2096 = _84(uvec4(_2023, _2022.y, _2029, _2028.y), uvec2(_1000.xy), uvec2(_84(uvec4(_1914, _1913.y, _1920, _1919.y), uvec2(_921.xy), uvec2(0u))));
    uint _2097 = _2096.x;
    uint _2098 = _2096.y;
    uvec2 _2102 = _84(uvec4(_2023, _2022.y, _2029, _2028.y), uvec2(_1000.zw), uvec2(_84(uvec4(_1914, _1913.y, _1920, _1919.y), uvec2(_921.zw), uvec2(0u))));
    uint _2103 = _2102.x;
    uint _2104 = _2102.y;
    vec2 _2107 = unpackHalf2x16(0u);
    vec2 _2114 = unpackHalf2x16(0u);
    uint _2120 = (packHalf2x16(vec2(max(unpackHalf2x16(_2061).y, _2114.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2061).x, _2107.x), 0.0));
    vec2 _2123 = unpackHalf2x16(0u);
    vec2 _2130 = unpackHalf2x16(0u);
    uint _2136 = (packHalf2x16(vec2(max(unpackHalf2x16(_2067).y, _2130.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2067).x, _2123.x), 0.0));
    vec2 _2139 = unpackHalf2x16(0u);
    vec2 _2146 = unpackHalf2x16(0u);
    uint _2152 = (packHalf2x16(vec2(max(unpackHalf2x16(_2068).y, _2146.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2068).x, _2139.x), 0.0));
    vec2 _2155 = unpackHalf2x16(0u);
    vec2 _2162 = unpackHalf2x16(0u);
    uint _2168 = (packHalf2x16(vec2(max(unpackHalf2x16(_2062).y, _2162.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2062).x, _2155.x), 0.0));
    vec2 _2171 = unpackHalf2x16(0u);
    vec2 _2178 = unpackHalf2x16(0u);
    uint _2184 = (packHalf2x16(vec2(max(unpackHalf2x16(_2073).y, _2178.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2073).x, _2171.x), 0.0));
    uint _2191 = ((_849 + 9216u) - (c0.data[44u] & 4294967280u)) >> 4u;
    vec2 _2200 = unpackHalf2x16(0u);
    vec2 _2207 = unpackHalf2x16(0u);
    uint _2213 = (packHalf2x16(vec2(max(unpackHalf2x16(_2079).y, _2207.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2079).x, _2200.x), 0.0));
    vec2 _2216 = unpackHalf2x16(0u);
    vec2 _2223 = unpackHalf2x16(0u);
    uint _2229 = (packHalf2x16(vec2(max(unpackHalf2x16(_2074).y, _2223.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2074).x, _2216.x), 0.0));
    vec2 _2232 = unpackHalf2x16(0u);
    vec2 _2239 = unpackHalf2x16(0u);
    uint _2245 = (packHalf2x16(vec2(max(unpackHalf2x16(_2080).y, _2239.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2080).x, _2232.x), 0.0));
    vec2 _2248 = unpackHalf2x16(0u);
    vec2 _2255 = unpackHalf2x16(0u);
    uint _2261 = (packHalf2x16(vec2(max(unpackHalf2x16(_2085).y, _2255.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2085).x, _2248.x), 0.0));
    vec2 _2264 = unpackHalf2x16(0u);
    vec2 _2271 = unpackHalf2x16(0u);
    uint _2277 = (packHalf2x16(vec2(max(unpackHalf2x16(_2091).y, _2271.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2091).x, _2264.x), 0.0));
    vec2 _2280 = unpackHalf2x16(0u);
    vec2 _2287 = unpackHalf2x16(0u);
    uint _2293 = (packHalf2x16(vec2(max(unpackHalf2x16(_2086).y, _2287.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2086).x, _2280.x), 0.0));
    vec2 _2296 = unpackHalf2x16(0u);
    vec2 _2303 = unpackHalf2x16(0u);
    uint _2309 = (packHalf2x16(vec2(max(unpackHalf2x16(_2092).y, _2303.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2092).x, _2296.x), 0.0));
    vec2 _2312 = unpackHalf2x16(0u);
    vec2 _2319 = unpackHalf2x16(0u);
    uint _2325 = (packHalf2x16(vec2(max(unpackHalf2x16(_2103).y, _2319.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2103).x, _2312.x), 0.0));
    vec2 _2328 = unpackHalf2x16(0u);
    vec2 _2335 = unpackHalf2x16(0u);
    uint _2341 = (packHalf2x16(vec2(max(unpackHalf2x16(_2097).y, _2335.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2097).x, _2328.x), 0.0));
    vec2 _2344 = unpackHalf2x16(0u);
    vec2 _2351 = unpackHalf2x16(0u);
    uint _2357 = (packHalf2x16(vec2(max(unpackHalf2x16(_2098).y, _2351.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2098).x, _2344.x), 0.0));
    vec2 _2360 = unpackHalf2x16(0u);
    vec2 _2367 = unpackHalf2x16(0u);
    uint _2373 = (packHalf2x16(vec2(max(unpackHalf2x16(_2104).y, _2367.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2104).x, _2360.x), 0.0));
    uvec2 _2377 = _84(uvec4(_1107), uvec2(_2136, _2120), uvec2(0u));
    uint _2378 = _2377.x;
    uvec2 _2383 = _84(uvec4(_1107), uvec2(_2152, _2168), uvec2(0u));
    uint _2384 = _2383.x;
    uvec2 _2389 = _84(uvec4(_1107), uvec2(_2184, _2213), uvec2(0u));
    uint _2390 = _2389.x;
    uvec2 _2395 = _84(uvec4(_1107), uvec2(_2229, _2245), uvec2(0u));
    uint _2396 = _2395.x;
    uvec2 _2401 = _84(uvec4(_1107), uvec2(_2261, _2277), uvec2(0u));
    uint _2402 = _2401.x;
    uvec2 _2407 = _84(uvec4(_1107), uvec2(_2293, _2309), uvec2(0u));
    uint _2408 = _2407.x;
    uvec2 _2413 = _84(uvec4(_1107), uvec2(_2341, _2325), uvec2(0u));
    uint _2414 = _2413.x;
    uvec2 _2419 = _84(uvec4(_1107), uvec2(_2357, _2373), uvec2(0u));
    uint _2420 = _2419.x;
    uint _2428 = ((_849 + 9728u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec2 _2474 = _84(uvec4(ssbo0_3._m0[_1324]), uvec2(_2136, _2120), uvec2(0u));
    uint _2475 = _2474.x;
    uvec2 _2480 = _84(uvec4(ssbo0_3._m0[_1324]), uvec2(_2152, _2168), uvec2(0u));
    uint _2481 = _2480.x;
    uint _2501 = ((_849 + 10240u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec2 _2511 = _84(uvec4(ssbo0_3._m0[_1324]), uvec2(_2184, _2213), uvec2(0u));
    uint _2512 = _2511.x;
    uvec2 _2517 = _84(uvec4(ssbo0_3._m0[_1324]), uvec2(_2229, _2245), uvec2(0u));
    uint _2518 = _2517.x;
    uvec2 _2523 = _84(uvec4(ssbo0_3._m0[_1324]), uvec2(_2261, _2277), uvec2(0u));
    uint _2524 = _2523.x;
    uvec2 _2529 = _84(uvec4(ssbo0_3._m0[_1324]), uvec2(_2293, _2309), uvec2(0u));
    uint _2530 = _2529.x;
    uvec2 _2535 = _84(uvec4(ssbo0_3._m0[_1324]), uvec2(_2341, _2325), uvec2(0u));
    uint _2536 = _2535.x;
    uvec2 _2541 = _84(uvec4(ssbo0_3._m0[_1324]), uvec2(_2357, _2373), uvec2(0u));
    uint _2542 = _2541.x;
    uvec2 _2547 = _84(uvec4(_2475, _2474.y, _2481, _2480.y), uvec2(ssbo0_3._m0[_1440].xy), uvec2(_84(uvec4(_2378, _2377.y, _2384, _2383.y), uvec2(ssbo0_3._m0[_1343].xy), uvec2(0u))));
    uint _2548 = _2547.x;
    uint _2549 = _2547.y;
    uvec2 _2553 = _84(uvec4(_2475, _2474.y, _2481, _2480.y), uvec2(ssbo0_3._m0[_1440].zw), uvec2(_84(uvec4(_2378, _2377.y, _2384, _2383.y), uvec2(ssbo0_3._m0[_1343].zw), uvec2(0u))));
    uint _2554 = _2553.x;
    uint _2555 = _2553.y;
    uint _2562 = ((_849 + 10752u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec2 _2572 = _84(uvec4(_2512, _2511.y, _2518, _2517.y), uvec2(ssbo0_3._m0[_1440].xy), uvec2(_84(uvec4(_2390, _2389.y, _2396, _2395.y), uvec2(ssbo0_3._m0[_1343].xy), uvec2(0u))));
    uint _2573 = _2572.x;
    uint _2574 = _2572.y;
    uvec2 _2578 = _84(uvec4(_2512, _2511.y, _2518, _2517.y), uvec2(ssbo0_3._m0[_1440].zw), uvec2(_84(uvec4(_2390, _2389.y, _2396, _2395.y), uvec2(ssbo0_3._m0[_1343].zw), uvec2(0u))));
    uint _2579 = _2578.x;
    uint _2580 = _2578.y;
    uvec2 _2584 = _84(uvec4(_2524, _2523.y, _2530, _2529.y), uvec2(ssbo0_3._m0[_1440].xy), uvec2(_84(uvec4(_2402, _2401.y, _2408, _2407.y), uvec2(ssbo0_3._m0[_1343].xy), uvec2(0u))));
    uint _2585 = _2584.x;
    uint _2586 = _2584.y;
    uvec2 _2590 = _84(uvec4(_2524, _2523.y, _2530, _2529.y), uvec2(ssbo0_3._m0[_1440].zw), uvec2(_84(uvec4(_2402, _2401.y, _2408, _2407.y), uvec2(ssbo0_3._m0[_1343].zw), uvec2(0u))));
    uint _2591 = _2590.x;
    uint _2592 = _2590.y;
    vec2 _2595 = unpackHalf2x16(0u);
    vec2 _2602 = unpackHalf2x16(0u);
    uint _2608 = (packHalf2x16(vec2(max(unpackHalf2x16(_2573).y, _2602.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2573).x, _2595.x), 0.0));
    uvec2 _2612 = _84(uvec4(_2536, _2535.y, _2542, _2541.y), uvec2(ssbo0_3._m0[_1440].xy), uvec2(_84(uvec4(_2414, _2413.y, _2420, _2419.y), uvec2(ssbo0_3._m0[_1343].xy), uvec2(0u))));
    uint _2613 = _2612.x;
    uint _2614 = _2612.y;
    vec2 _2617 = unpackHalf2x16(0u);
    vec2 _2624 = unpackHalf2x16(0u);
    uint _2630 = (packHalf2x16(vec2(max(unpackHalf2x16(_2579).y, _2624.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2579).x, _2617.x), 0.0));
    vec2 _2633 = unpackHalf2x16(0u);
    vec2 _2640 = unpackHalf2x16(0u);
    uint _2646 = (packHalf2x16(vec2(max(unpackHalf2x16(_2548).y, _2640.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2548).x, _2633.x), 0.0));
    uvec2 _2650 = _84(uvec4(_2536, _2535.y, _2542, _2541.y), uvec2(ssbo0_3._m0[_1440].zw), uvec2(_84(uvec4(_2414, _2413.y, _2420, _2419.y), uvec2(ssbo0_3._m0[_1343].zw), uvec2(0u))));
    uint _2651 = _2650.x;
    uint _2652 = _2650.y;
    vec2 _2655 = unpackHalf2x16(0u);
    vec2 _2662 = unpackHalf2x16(0u);
    uint _2668 = (packHalf2x16(vec2(max(unpackHalf2x16(_2554).y, _2662.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2554).x, _2655.x), 0.0));
    vec2 _2671 = unpackHalf2x16(0u);
    vec2 _2678 = unpackHalf2x16(0u);
    uint _2684 = (packHalf2x16(vec2(max(unpackHalf2x16(_2549).y, _2678.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2549).x, _2671.x), 0.0));
    vec2 _2687 = unpackHalf2x16(0u);
    vec2 _2694 = unpackHalf2x16(0u);
    uint _2700 = (packHalf2x16(vec2(max(unpackHalf2x16(_2555).y, _2694.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2555).x, _2687.x), 0.0));
    vec2 _2703 = unpackHalf2x16(0u);
    vec2 _2710 = unpackHalf2x16(0u);
    uint _2716 = (packHalf2x16(vec2(max(unpackHalf2x16(_2574).y, _2710.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2574).x, _2703.x), 0.0));
    vec2 _2719 = unpackHalf2x16(0u);
    vec2 _2726 = unpackHalf2x16(0u);
    uint _2732 = (packHalf2x16(vec2(max(unpackHalf2x16(_2580).y, _2726.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2580).x, _2719.x), 0.0));
    vec2 _2735 = unpackHalf2x16(0u);
    vec2 _2742 = unpackHalf2x16(0u);
    uint _2748 = (packHalf2x16(vec2(max(unpackHalf2x16(_2591).y, _2742.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2591).x, _2735.x), 0.0));
    uvec2 _2752 = _84(uvec4(ssbo0_3._m0[_1537]), uvec2(_2646, _2668), uvec2(0u));
    uint _2753 = _2752.x;
    vec2 _2757 = unpackHalf2x16(0u);
    vec2 _2764 = unpackHalf2x16(0u);
    uint _2770 = (packHalf2x16(vec2(max(unpackHalf2x16(_2585).y, _2764.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2585).x, _2757.x), 0.0));
    vec2 _2773 = unpackHalf2x16(0u);
    vec2 _2780 = unpackHalf2x16(0u);
    uint _2786 = (packHalf2x16(vec2(max(unpackHalf2x16(_2586).y, _2780.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2586).x, _2773.x), 0.0));
    uint _2793 = ((_849 + 11264u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec2 _2803 = _84(uvec4(ssbo0_3._m0[_1537]), uvec2(_2684, _2700), uvec2(0u));
    uint _2804 = _2803.x;
    uvec2 _2809 = _84(uvec4(ssbo0_3._m0[_1537]), uvec2(_2608, _2630), uvec2(0u));
    uint _2810 = _2809.x;
    uvec2 _2815 = _84(uvec4(ssbo0_3._m0[_1537]), uvec2(_2716, _2732), uvec2(0u));
    uint _2816 = _2815.x;
    vec2 _2820 = unpackHalf2x16(0u);
    vec2 _2827 = unpackHalf2x16(0u);
    uint _2833 = (packHalf2x16(vec2(max(unpackHalf2x16(_2613).y, _2827.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2613).x, _2820.x), 0.0));
    vec2 _2836 = unpackHalf2x16(0u);
    vec2 _2843 = unpackHalf2x16(0u);
    uint _2849 = (packHalf2x16(vec2(max(unpackHalf2x16(_2614).y, _2843.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2614).x, _2836.x), 0.0));
    vec2 _2852 = unpackHalf2x16(0u);
    vec2 _2859 = unpackHalf2x16(0u);
    uint _2865 = (packHalf2x16(vec2(max(unpackHalf2x16(_2592).y, _2859.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2592).x, _2852.x), 0.0));
    vec2 _2868 = unpackHalf2x16(0u);
    vec2 _2875 = unpackHalf2x16(0u);
    uint _2881 = (packHalf2x16(vec2(max(unpackHalf2x16(_2651).y, _2875.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2651).x, _2868.x), 0.0));
    vec2 _2884 = unpackHalf2x16(0u);
    vec2 _2891 = unpackHalf2x16(0u);
    uint _2897 = (packHalf2x16(vec2(max(unpackHalf2x16(_2652).y, _2891.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2652).x, _2884.x), 0.0));
    uvec2 _2901 = _84(uvec4(ssbo0_3._m0[_1537]), uvec2(_2770, _2748), uvec2(0u));
    uint _2902 = _2901.x;
    uvec2 _2907 = _84(uvec4(ssbo0_3._m0[_1537]), uvec2(_2786, _2865), uvec2(0u));
    uint _2908 = _2907.x;
    uvec2 _2913 = _84(uvec4(ssbo0_3._m0[_1537]), uvec2(_2833, _2881), uvec2(0u));
    uint _2914 = _2913.x;
    uvec2 _2919 = _84(uvec4(ssbo0_3._m0[_1537]), uvec2(_2849, _2897), uvec2(0u));
    uint _2920 = _2919.x;
    uvec2 _2949 = _84(uvec4(ssbo0_3._m0[_1605]), uvec2(_2684, _2700), uvec2(0u));
    uint _2950 = _2949.x;
    uint _2958 = ((_849 + 11776u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec2 _2968 = _84(uvec4(ssbo0_3._m0[_1605]), uvec2(_2646, _2668), uvec2(0u));
    uint _2969 = _2968.x;
    uvec2 _2986 = _84(uvec4(ssbo0_3._m0[_1605]), uvec2(_2608, _2630), uvec2(0u));
    uint _2987 = _2986.x;
    uvec2 _2992 = _84(uvec4(ssbo0_3._m0[_1605]), uvec2(_2716, _2732), uvec2(0u));
    uint _2993 = _2992.x;
    uvec2 _2998 = _84(uvec4(ssbo0_3._m0[_1605]), uvec2(_2770, _2748), uvec2(0u));
    uint _2999 = _2998.x;
    uvec2 _3004 = _84(uvec4(ssbo0_3._m0[_1605]), uvec2(_2786, _2865), uvec2(0u));
    uint _3005 = _3004.x;
    uvec2 _3016 = _84(uvec4(ssbo0_3._m0[_1605]), uvec2(_2833, _2881), uvec2(0u));
    uint _3017 = _3016.x;
    uvec2 _3022 = _84(uvec4(ssbo0_3._m0[_1605]), uvec2(_2849, _2897), uvec2(0u));
    uint _3023 = _3022.x;
    uvec2 _3034 = _84(uvec4(_2969, _2968.y, _2950, _2949.y), uvec2(ssbo0_3._m0[_1928].zw), uvec2(_84(uvec4(_2753, _2752.y, _2804, _2803.y), uvec2(ssbo0_3._m0[_1586].zw), uvec2(0u))));
    uint _3035 = _3034.x;
    uint _3036 = _3034.y;
    uvec2 _3040 = _84(uvec4(_2969, _2968.y, _2950, _2949.y), uvec2(ssbo0_3._m0[_1928].xy), uvec2(_84(uvec4(_2753, _2752.y, _2804, _2803.y), uvec2(ssbo0_3._m0[_1586].xy), uvec2(0u))));
    uint _3041 = _3040.x;
    uint _3042 = _3040.y;
    uvec2 _3046 = _84(uvec4(_2987, _2986.y, _2993, _2992.y), uvec2(ssbo0_3._m0[_1928].zw), uvec2(_84(uvec4(_2810, _2809.y, _2816, _2815.y), uvec2(ssbo0_3._m0[_1586].zw), uvec2(0u))));
    uint _3047 = _3046.x;
    uint _3048 = _3046.y;
    uvec2 _3052 = _84(uvec4(_2987, _2986.y, _2993, _2992.y), uvec2(ssbo0_3._m0[_1928].xy), uvec2(_84(uvec4(_2810, _2809.y, _2816, _2815.y), uvec2(ssbo0_3._m0[_1586].xy), uvec2(0u))));
    uint _3053 = _3052.x;
    uint _3054 = _3052.y;
    uvec2 _3058 = _84(uvec4(_2999, _2998.y, _3005, _3004.y), uvec2(ssbo0_3._m0[_1928].zw), uvec2(_84(uvec4(_2902, _2901.y, _2908, _2907.y), uvec2(ssbo0_3._m0[_1586].zw), uvec2(0u))));
    uint _3059 = _3058.x;
    uint _3060 = _3058.y;
    uvec2 _3064 = _84(uvec4(_2999, _2998.y, _3005, _3004.y), uvec2(ssbo0_3._m0[_1928].xy), uvec2(_84(uvec4(_2902, _2901.y, _2908, _2907.y), uvec2(ssbo0_3._m0[_1586].xy), uvec2(0u))));
    uint _3065 = _3064.x;
    uint _3066 = _3064.y;
    uvec2 _3070 = _84(uvec4(_3017, _3016.y, _3023, _3022.y), uvec2(ssbo0_3._m0[_1928].zw), uvec2(_84(uvec4(_2914, _2913.y, _2920, _2919.y), uvec2(ssbo0_3._m0[_1586].zw), uvec2(0u))));
    uint _3071 = _3070.x;
    uint _3072 = _3070.y;
    uvec2 _3076 = _84(uvec4(_3017, _3016.y, _3023, _3022.y), uvec2(ssbo0_3._m0[_1928].xy), uvec2(_84(uvec4(_2914, _2913.y, _2920, _2919.y), uvec2(ssbo0_3._m0[_1586].xy), uvec2(0u))));
    uint _3077 = _3076.x;
    uint _3078 = _3076.y;
    vec2 _3081 = unpackHalf2x16(0u);
    vec2 _3088 = unpackHalf2x16(0u);
    uint _3094 = (packHalf2x16(vec2(max(unpackHalf2x16(_3035).y, _3088.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3035).x, _3081.x), 0.0));
    vec2 _3097 = unpackHalf2x16(0u);
    vec2 _3104 = unpackHalf2x16(0u);
    uint _3110 = (packHalf2x16(vec2(max(unpackHalf2x16(_3041).y, _3104.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3041).x, _3097.x), 0.0));
    vec2 _3113 = unpackHalf2x16(0u);
    vec2 _3120 = unpackHalf2x16(0u);
    uint _3126 = (packHalf2x16(vec2(max(unpackHalf2x16(_3042).y, _3120.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3042).x, _3113.x), 0.0));
    vec2 _3129 = unpackHalf2x16(0u);
    vec2 _3136 = unpackHalf2x16(0u);
    uint _3142 = (packHalf2x16(vec2(max(unpackHalf2x16(_3036).y, _3136.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3036).x, _3129.x), 0.0));
    vec2 _3145 = unpackHalf2x16(0u);
    vec2 _3152 = unpackHalf2x16(0u);
    uint _3158 = (packHalf2x16(vec2(max(unpackHalf2x16(_3047).y, _3152.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3047).x, _3145.x), 0.0));
    vec2 _3161 = unpackHalf2x16(0u);
    vec2 _3168 = unpackHalf2x16(0u);
    uint _3174 = (packHalf2x16(vec2(max(unpackHalf2x16(_3053).y, _3168.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3053).x, _3161.x), 0.0));
    vec2 _3177 = unpackHalf2x16(0u);
    vec2 _3184 = unpackHalf2x16(0u);
    uint _3190 = (packHalf2x16(vec2(max(unpackHalf2x16(_3054).y, _3184.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3054).x, _3177.x), 0.0));
    vec2 _3193 = unpackHalf2x16(0u);
    vec2 _3200 = unpackHalf2x16(0u);
    uint _3206 = (packHalf2x16(vec2(max(unpackHalf2x16(_3048).y, _3200.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3048).x, _3193.x), 0.0));
    vec2 _3209 = unpackHalf2x16(0u);
    vec2 _3216 = unpackHalf2x16(0u);
    uint _3222 = (packHalf2x16(vec2(max(unpackHalf2x16(_3059).y, _3216.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3059).x, _3209.x), 0.0));
    vec2 _3225 = unpackHalf2x16(0u);
    vec2 _3232 = unpackHalf2x16(0u);
    uint _3238 = (packHalf2x16(vec2(max(unpackHalf2x16(_3065).y, _3232.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3065).x, _3225.x), 0.0));
    vec2 _3241 = unpackHalf2x16(0u);
    vec2 _3248 = unpackHalf2x16(0u);
    uint _3254 = (packHalf2x16(vec2(max(unpackHalf2x16(_3066).y, _3248.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3066).x, _3241.x), 0.0));
    vec2 _3257 = unpackHalf2x16(0u);
    vec2 _3264 = unpackHalf2x16(0u);
    uint _3270 = (packHalf2x16(vec2(max(unpackHalf2x16(_3060).y, _3264.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3060).x, _3257.x), 0.0));
    vec2 _3273 = unpackHalf2x16(0u);
    vec2 _3280 = unpackHalf2x16(0u);
    uint _3286 = (packHalf2x16(vec2(max(unpackHalf2x16(_3071).y, _3280.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3071).x, _3273.x), 0.0));
    uvec2 _3290 = _84(uvec4(ssbo0_3._m0[_2037]), uvec2(_3110, _3094), uvec2(0u));
    uint _3291 = _3290.x;
    vec2 _3295 = unpackHalf2x16(0u);
    vec2 _3302 = unpackHalf2x16(0u);
    uint _3308 = (packHalf2x16(vec2(max(unpackHalf2x16(_3077).y, _3302.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3077).x, _3295.x), 0.0));
    vec2 _3311 = unpackHalf2x16(0u);
    vec2 _3318 = unpackHalf2x16(0u);
    uint _3324 = (packHalf2x16(vec2(max(unpackHalf2x16(_3078).y, _3318.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3078).x, _3311.x), 0.0));
    vec2 _3327 = unpackHalf2x16(0u);
    vec2 _3334 = unpackHalf2x16(0u);
    uint _3340 = (packHalf2x16(vec2(max(unpackHalf2x16(_3072).y, _3334.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3072).x, _3327.x), 0.0));
    uvec2 _3344 = _84(uvec4(ssbo0_3._m0[_2037]), uvec2(_3126, _3142), uvec2(0u));
    uint _3345 = _3344.x;
    uvec2 _3350 = _84(uvec4(ssbo0_3._m0[_2037]), uvec2(_3174, _3158), uvec2(0u));
    uint _3351 = _3350.x;
    uvec2 _3356 = _84(uvec4(ssbo0_3._m0[_2037]), uvec2(_3190, _3206), uvec2(0u));
    uint _3357 = _3356.x;
    uvec2 _3362 = _84(uvec4(ssbo0_3._m0[_2037]), uvec2(_3238, _3222), uvec2(0u));
    uint _3363 = _3362.x;
    uvec2 _3368 = _84(uvec4(ssbo0_3._m0[_2037]), uvec2(_3254, _3270), uvec2(0u));
    uint _3369 = _3368.x;
    uvec2 _3374 = _84(uvec4(ssbo0_3._m0[_2037]), uvec2(_3308, _3286), uvec2(0u));
    uint _3375 = _3374.x;
    uvec2 _3380 = _84(uvec4(ssbo0_3._m0[_2037]), uvec2(_3324, _3340), uvec2(0u));
    uint _3381 = _3380.x;
    uvec2 _3386 = _84(uvec4(ssbo0_3._m0[_2191]), uvec2(_3110, _3094), uvec2(0u));
    uint _3387 = _3386.x;
    uvec2 _3392 = _84(uvec4(ssbo0_3._m0[_2191]), uvec2(_3126, _3142), uvec2(0u));
    uint _3393 = _3392.x;
    uvec2 _3422 = _84(uvec4(ssbo0_3._m0[_2191]), uvec2(_3174, _3158), uvec2(0u));
    uint _3423 = _3422.x;
    uvec2 _3428 = _84(uvec4(ssbo0_3._m0[_2191]), uvec2(_3190, _3206), uvec2(0u));
    uint _3429 = _3428.x;
    uvec2 _3446 = _84(uvec4(ssbo0_3._m0[_2191]), uvec2(_3238, _3222), uvec2(0u));
    uint _3447 = _3446.x;
    uvec2 _3452 = _84(uvec4(ssbo0_3._m0[_2191]), uvec2(_3254, _3270), uvec2(0u));
    uint _3453 = _3452.x;
    uvec2 _3470 = _84(uvec4(ssbo0_3._m0[_2191]), uvec2(_3308, _3286), uvec2(0u));
    uint _3471 = _3470.x;
    uvec2 _3476 = _84(uvec4(ssbo0_3._m0[_2191]), uvec2(_3324, _3340), uvec2(0u));
    uint _3477 = _3476.x;
    uvec2 _3482 = _84(uvec4(_3387, _3386.y, _3393, _3392.y), uvec2(ssbo0_3._m0[_2428].xy), uvec2(_84(uvec4(_3291, _3290.y, _3345, _3344.y), uvec2(ssbo0_3._m0[_2050].xy), uvec2(0u))));
    uint _3483 = _3482.x;
    uint _3484 = _3482.y;
    uvec2 _3488 = _84(uvec4(_3387, _3386.y, _3393, _3392.y), uvec2(ssbo0_3._m0[_2428].zw), uvec2(_84(uvec4(_3291, _3290.y, _3345, _3344.y), uvec2(ssbo0_3._m0[_2050].zw), uvec2(0u))));
    uint _3489 = _3488.x;
    uint _3490 = _3488.y;
    uvec2 _3494 = _84(uvec4(_3423, _3422.y, _3429, _3428.y), uvec2(ssbo0_3._m0[_2428].xy), uvec2(_84(uvec4(_3351, _3350.y, _3357, _3356.y), uvec2(ssbo0_3._m0[_2050].xy), uvec2(0u))));
    uint _3495 = _3494.x;
    uint _3496 = _3494.y;
    uvec2 _3500 = _84(uvec4(_3423, _3422.y, _3429, _3428.y), uvec2(ssbo0_3._m0[_2428].zw), uvec2(_84(uvec4(_3351, _3350.y, _3357, _3356.y), uvec2(ssbo0_3._m0[_2050].zw), uvec2(0u))));
    uint _3501 = _3500.x;
    uint _3502 = _3500.y;
    uvec2 _3506 = _84(uvec4(_3447, _3446.y, _3453, _3452.y), uvec2(ssbo0_3._m0[_2428].xy), uvec2(_84(uvec4(_3363, _3362.y, _3369, _3368.y), uvec2(ssbo0_3._m0[_2050].xy), uvec2(0u))));
    uint _3507 = _3506.x;
    uint _3508 = _3506.y;
    uvec2 _3512 = _84(uvec4(_3447, _3446.y, _3453, _3452.y), uvec2(ssbo0_3._m0[_2428].zw), uvec2(_84(uvec4(_3363, _3362.y, _3369, _3368.y), uvec2(ssbo0_3._m0[_2050].zw), uvec2(0u))));
    uint _3513 = _3512.x;
    uint _3514 = _3512.y;
    uvec2 _3518 = _84(uvec4(_3471, _3470.y, _3477, _3476.y), uvec2(ssbo0_3._m0[_2428].xy), uvec2(_84(uvec4(_3375, _3374.y, _3381, _3380.y), uvec2(ssbo0_3._m0[_2050].xy), uvec2(0u))));
    uint _3519 = _3518.x;
    uint _3520 = _3518.y;
    uvec2 _3524 = _84(uvec4(_3471, _3470.y, _3477, _3476.y), uvec2(ssbo0_3._m0[_2428].zw), uvec2(_84(uvec4(_3375, _3374.y, _3381, _3380.y), uvec2(ssbo0_3._m0[_2050].zw), uvec2(0u))));
    uint _3525 = _3524.x;
    uint _3526 = _3524.y;
    vec2 _3529 = unpackHalf2x16(0u);
    vec2 _3536 = unpackHalf2x16(0u);
    uint _3542 = (packHalf2x16(vec2(max(unpackHalf2x16(_3483).y, _3536.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3483).x, _3529.x), 0.0));
    vec2 _3545 = unpackHalf2x16(0u);
    vec2 _3552 = unpackHalf2x16(0u);
    uint _3558 = (packHalf2x16(vec2(max(unpackHalf2x16(_3489).y, _3552.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3489).x, _3545.x), 0.0));
    vec2 _3561 = unpackHalf2x16(0u);
    vec2 _3568 = unpackHalf2x16(0u);
    uint _3574 = (packHalf2x16(vec2(max(unpackHalf2x16(_3484).y, _3568.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3484).x, _3561.x), 0.0));
    vec2 _3577 = unpackHalf2x16(0u);
    vec2 _3584 = unpackHalf2x16(0u);
    uint _3590 = (packHalf2x16(vec2(max(unpackHalf2x16(_3490).y, _3584.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3490).x, _3577.x), 0.0));
    vec2 _3593 = unpackHalf2x16(0u);
    vec2 _3600 = unpackHalf2x16(0u);
    uint _3606 = (packHalf2x16(vec2(max(unpackHalf2x16(_3495).y, _3600.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3495).x, _3593.x), 0.0));
    vec2 _3609 = unpackHalf2x16(0u);
    vec2 _3616 = unpackHalf2x16(0u);
    uint _3622 = (packHalf2x16(vec2(max(unpackHalf2x16(_3501).y, _3616.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3501).x, _3609.x), 0.0));
    vec2 _3625 = unpackHalf2x16(0u);
    vec2 _3632 = unpackHalf2x16(0u);
    uint _3638 = (packHalf2x16(vec2(max(unpackHalf2x16(_3496).y, _3632.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3496).x, _3625.x), 0.0));
    vec2 _3641 = unpackHalf2x16(0u);
    vec2 _3648 = unpackHalf2x16(0u);
    uint _3654 = (packHalf2x16(vec2(max(unpackHalf2x16(_3502).y, _3648.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3502).x, _3641.x), 0.0));
    vec2 _3657 = unpackHalf2x16(0u);
    vec2 _3664 = unpackHalf2x16(0u);
    uint _3670 = (packHalf2x16(vec2(max(unpackHalf2x16(_3507).y, _3664.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3507).x, _3657.x), 0.0));
    vec2 _3673 = unpackHalf2x16(0u);
    vec2 _3680 = unpackHalf2x16(0u);
    uint _3686 = (packHalf2x16(vec2(max(unpackHalf2x16(_3513).y, _3680.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3513).x, _3673.x), 0.0));
    vec2 _3689 = unpackHalf2x16(0u);
    vec2 _3696 = unpackHalf2x16(0u);
    uint _3702 = (packHalf2x16(vec2(max(unpackHalf2x16(_3508).y, _3696.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3508).x, _3689.x), 0.0));
    vec2 _3705 = unpackHalf2x16(0u);
    vec2 _3712 = unpackHalf2x16(0u);
    uint _3718 = (packHalf2x16(vec2(max(unpackHalf2x16(_3514).y, _3712.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3514).x, _3705.x), 0.0));
    uvec2 _3722 = _84(uvec4(ssbo0_3._m0[_2501]), uvec2(_3542, _3558), uvec2(0u));
    uint _3723 = _3722.x;
    vec2 _3727 = unpackHalf2x16(0u);
    vec2 _3734 = unpackHalf2x16(0u);
    uint _3740 = (packHalf2x16(vec2(max(unpackHalf2x16(_3519).y, _3734.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3519).x, _3727.x), 0.0));
    vec2 _3743 = unpackHalf2x16(0u);
    vec2 _3750 = unpackHalf2x16(0u);
    uint _3756 = (packHalf2x16(vec2(max(unpackHalf2x16(_3525).y, _3750.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3525).x, _3743.x), 0.0));
    vec2 _3759 = unpackHalf2x16(0u);
    vec2 _3766 = unpackHalf2x16(0u);
    uint _3772 = (packHalf2x16(vec2(max(unpackHalf2x16(_3520).y, _3766.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3520).x, _3759.x), 0.0));
    vec2 _3775 = unpackHalf2x16(0u);
    vec2 _3782 = unpackHalf2x16(0u);
    uint _3788 = (packHalf2x16(vec2(max(unpackHalf2x16(_3526).y, _3782.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3526).x, _3775.x), 0.0));
    uvec2 _3792 = _84(uvec4(ssbo0_3._m0[_2501]), uvec2(_3574, _3590), uvec2(0u));
    uint _3793 = _3792.x;
    uvec2 _3800 = _84(uvec4(ssbo0_3._m0[_2501]), uvec2(_3606, _3622), uvec2(0u));
    uint _3801 = _3800.x;
    uvec2 _3806 = _84(uvec4(ssbo0_3._m0[_2501]), uvec2(_3638, _3654), uvec2(0u));
    uint _3807 = _3806.x;
    uvec2 _3812 = _84(uvec4(ssbo0_3._m0[_2501]), uvec2(_3670, _3686), uvec2(0u));
    uint _3813 = _3812.x;
    uvec2 _3818 = _84(uvec4(ssbo0_3._m0[_2501]), uvec2(_3702, _3718), uvec2(0u));
    uint _3819 = _3818.x;
    uvec2 _3824 = _84(uvec4(ssbo0_3._m0[_2501]), uvec2(_3740, _3756), uvec2(0u));
    uint _3825 = _3824.x;
    uvec2 _3830 = _84(uvec4(ssbo0_3._m0[_2501]), uvec2(_3772, _3788), uvec2(0u));
    uint _3831 = _3830.x;
    uint _3834 = gl_SubgroupInvocationID & 7u;
    uint _3836 = _3834 + 8u;
    uint _3853 = _3834 + 16u;
    uint _3855 = _3834 + 24u;
    uint _3857 = _3834 + 32u;
    uint _3858 = _3834 + 40u;
    uint _3866 = (gl_SubgroupInvocationID >> 3u) + (_947 * 12u);
    uint _3881 = (((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.x, int(16u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u)))) << 16u) + ((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u))) + _3836);
    uint _3897 = (((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.x, int(16u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u)))) << 16u) + ((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u))) + _3853);
    uint _3898 = _3866 + 4u;
    uint _3913 = (((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.x, int(16u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u)))) << 16u) + ((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u))) + _3855);
    uint _3934 = (((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.x, int(16u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u)))) << 16u) + ((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u))) + _3857);
    uint _3950 = _3866 + 8u;
    uint _3966 = (((bitfieldExtract(gl_WorkGroupID.y, int(0u), int(16u)) * bitfieldExtract(c0.data[23u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.y, int(16u), int(16u)) * bitfieldExtract(c0.data[23u], int(0u), int(16u)))) << 16u) + ((bitfieldExtract(gl_WorkGroupID.y, int(0u), int(16u)) * bitfieldExtract(c0.data[23u], int(0u), int(16u))) + _3866);
    precise float _3998 = 0.5 * c0_1.data[30u];
    precise float _4009 = 0.5 * c0_1.data[31u];
    uvec2 _4034 = _84(uvec4(ssbo0_3._m0[_2793]), uvec2(_3702, _3718), uvec2(0u));
    uint _4035 = _4034.x;
    uvec2 _4056 = _84(uvec4(ssbo0_3._m0[_2793]), uvec2(_3670, _3686), uvec2(0u));
    uint _4057 = _4056.x;
    precise float _4061 = fma(float((((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.x, int(16u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u)))) << 16u) + ((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u))) + _3834)), c0_1.data[30u], _3998);
    precise float _4065 = fma(float(_3966), c0_1.data[31u], _4009);
    uvec2 _4071 = _84(uvec4(ssbo0_3._m0[_2793]), uvec2(_3740, _3756), uvec2(0u));
    uint _4072 = _4071.x;
    precise float _4076 = fma(float(_3897), c0_1.data[30u], _3998);
    precise float _4079 = fma(float(_3913), c0_1.data[30u], _3998);
    precise float _4082 = fma(float(_3881), c0_1.data[30u], _3998);
    uvec2 _4086 = _84(uvec4(ssbo0_3._m0[_2793]), uvec2(_3772, _3788), uvec2(0u));
    uint _4087 = _4086.x;
    precise float _4091 = fma(float((((bitfieldExtract(gl_WorkGroupID.y, int(0u), int(16u)) * bitfieldExtract(c0.data[23u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.y, int(16u), int(16u)) * bitfieldExtract(c0.data[23u], int(0u), int(16u)))) << 16u) + ((bitfieldExtract(gl_WorkGroupID.y, int(0u), int(16u)) * bitfieldExtract(c0.data[23u], int(0u), int(16u))) + _3898)), c0_1.data[31u], _4009);
    precise float _4094 = fma(float(_3934), c0_1.data[30u], _3998);
    uvec2 _4098 = _84(uvec4(ssbo0_3._m0[_2793]), uvec2(_3542, _3558), uvec2(0u));
    uint _4099 = _4098.x;
    precise float _4103 = fma(float((((bitfieldExtract(gl_WorkGroupID.y, int(0u), int(16u)) * bitfieldExtract(c0.data[23u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.y, int(16u), int(16u)) * bitfieldExtract(c0.data[23u], int(0u), int(16u)))) << 16u) + ((bitfieldExtract(gl_WorkGroupID.y, int(0u), int(16u)) * bitfieldExtract(c0.data[23u], int(0u), int(16u))) + _3950)), c0_1.data[31u], _4009);
    vec4 _4106 = textureLod(cs_tex0_c0, vec2(_4061, _4065), 0.0);
    uvec2 _4125 = _84(uvec4(ssbo0_3._m0[_2793]), uvec2(_3574, _3590), uvec2(0u));
    uint _4126 = _4125.x;
    precise float _4130 = fma(float((((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.x, int(16u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u)))) << 16u) + ((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u))) + _3858)), c0_1.data[30u], _3998);
    uvec2 _4134 = _84(uvec4(ssbo0_3._m0[_2793]), uvec2(_3606, _3622), uvec2(0u));
    uint _4135 = _4134.x;
    uvec2 _4140 = _84(uvec4(ssbo0_3._m0[_2793]), uvec2(_3638, _3654), uvec2(0u));
    uint _4141 = _4140.x;
    vec4 _4145 = textureLod(cs_tex0_c0, vec2(_4082, _4065), 0.0);
    vec4 _4163 = textureLod(cs_tex0_c0, vec2(_4076, _4065), 0.0);
    vec4 _4181 = textureLod(cs_tex0_c0, vec2(_4079, _4065), 0.0);
    vec4 _4199 = textureLod(cs_tex0_c0, vec2(_4094, _4065), 0.0);
    vec4 _4217 = textureLod(cs_tex0_c0, vec2(_4130, _4065), 0.0);
    vec4 _4235 = textureLod(cs_tex0_c0, vec2(_4061, _4091), 0.0);
    vec4 _4253 = textureLod(cs_tex0_c0, vec2(_4082, _4091), 0.0);
    vec4 _4271 = textureLod(cs_tex0_c0, vec2(_4076, _4091), 0.0);
    vec4 _4289 = textureLod(cs_tex0_c0, vec2(_4079, _4091), 0.0);
    vec4 _4307 = textureLod(cs_tex0_c0, vec2(_4094, _4091), 0.0);
    vec4 _4325 = textureLod(cs_tex0_c0, vec2(_4130, _4091), 0.0);
    vec4 _4343 = textureLod(cs_tex0_c0, vec2(_4061, _4103), 0.0);
    vec4 _4361 = textureLod(cs_tex0_c0, vec2(_4082, _4103), 0.0);
    vec4 _4379 = textureLod(cs_tex0_c0, vec2(_4076, _4103), 0.0);
    vec4 _4397 = textureLod(cs_tex0_c0, vec2(_4079, _4103), 0.0);
    vec4 _4415 = textureLod(cs_tex0_c0, vec2(_4094, _4103), 0.0);
    vec4 _4433 = textureLod(cs_tex0_c0, vec2(_4130, _4103), 0.0);
    uvec2 _4452 = _84(uvec4(_4072, _4071.y, _4087, _4086.y), uvec2(ssbo0_3._m0[_2958].xy), uvec2(_84(uvec4(_3825, _3824.y, _3831, _3830.y), uvec2(ssbo0_3._m0[_2562].xy), uvec2(0u))));
    uvec2 _4459 = _84(uvec4(_4072, _4071.y, _4087, _4086.y), uvec2(ssbo0_3._m0[_2958].zw), uvec2(_84(uvec4(_3825, _3824.y, _3831, _3830.y), uvec2(ssbo0_3._m0[_2562].zw), uvec2(0u))));
    uvec2 _4466 = _84(uvec4(_4099, _4098.y, _4126, _4125.y), uvec2(ssbo0_3._m0[_2958].xy), uvec2(_84(uvec4(_3723, _3722.y, _3793, _3792.y), uvec2(ssbo0_3._m0[_2562].xy), uvec2(0u))));
    uvec2 _4473 = _84(uvec4(_4099, _4098.y, _4126, _4125.y), uvec2(ssbo0_3._m0[_2958].zw), uvec2(_84(uvec4(_3723, _3722.y, _3793, _3792.y), uvec2(ssbo0_3._m0[_2562].zw), uvec2(0u))));
    precise float _4482 = fma(float(_3866), c0_1.data[25u], c0_1.data[27u]);
    uvec2 _4489 = _84(uvec4(_4135, _4134.y, _4141, _4140.y), uvec2(ssbo0_3._m0[_2958].xy), uvec2(_84(uvec4(_3801, _3800.y, _3807, _3806.y), uvec2(ssbo0_3._m0[_2562].xy), uvec2(0u))));
    uvec2 _4497 = _84(uvec4(_4057, _4056.y, _4035, _4034.y), uvec2(ssbo0_3._m0[_2958].xy), uvec2(_84(uvec4(_3813, _3812.y, _3819, _3818.y), uvec2(ssbo0_3._m0[_2562].xy), uvec2(0u))));
    precise float _4505 = fma(float(_3834), c0_1.data[24u], c0_1.data[26u]);
    precise float _4511 = fma(float(_3853), c0_1.data[24u], c0_1.data[26u]);
    uvec2 _4517 = _84(uvec4(_4057, _4056.y, _4035, _4034.y), uvec2(ssbo0_3._m0[_2958].zw), uvec2(_84(uvec4(_3813, _3812.y, _3819, _3818.y), uvec2(ssbo0_3._m0[_2562].zw), uvec2(0u))));
    precise float _4524 = fma(float(_3855), c0_1.data[24u], c0_1.data[26u]);
    uvec2 _4530 = _84(uvec4(_4135, _4134.y, _4141, _4140.y), uvec2(ssbo0_3._m0[_2958].zw), uvec2(_84(uvec4(_3801, _3800.y, _3807, _3806.y), uvec2(ssbo0_3._m0[_2562].zw), uvec2(0u))));
    precise float _4537 = fma(float(_3858), c0_1.data[24u], c0_1.data[26u]);
    uint _4545 = ((bitfieldExtract(_947, int(16u), int(16u)) * 12u) << 16u) + ((bitfieldExtract(_947, int(0u), int(16u)) * 12u) + _1013);
    precise float _4550 = fma(float(_3857), c0_1.data[24u], c0_1.data[26u]);
    precise float _4564 = fma(float(_3836), c0_1.data[24u], c0_1.data[26u]);
    precise float _4586 = fma(float(_3898), c0_1.data[25u], c0_1.data[27u]);
    precise float _4592 = fma(float(_3950), c0_1.data[25u], c0_1.data[27u]);
    uint _4598 = (_4545 >> 1u) + (((bitfieldExtract(_1081, int(16u), int(16u)) * 26u) << 16u) + ((bitfieldExtract(_1081, int(0u), int(16u)) * 26u) + 312u));
    uint _4600 = (_4545 >> 1u) + (((bitfieldExtract(_1081, int(16u), int(16u)) * 26u) << 16u) + ((bitfieldExtract(_1081, int(0u), int(16u)) * 26u) + 624u));
    uint _4602 = (_4545 >> 1u) + (((bitfieldExtract(_1081, int(16u), int(16u)) * 26u) << 16u) + ((bitfieldExtract(_1081, int(0u), int(16u)) * 26u) + 936u));
    bool _4605 = gl_SubgroupInvocationID >= 16u;
    bool _4608 = _946 >= 2u;
    bool _4611 = (_946 < 2u) && (!_4605);
    precise float _4614 = _4505 + uintBitsToFloat(floatBitsToUint(floor(_4505)) ^ 2147483648u);
    uint _4623 = floatBitsToUint(_4505) & (((!isnan(_4505)) && (!isnan(_4505))) ? 4294967295u : 0u);
    uint _4636 = uint(clamp(floor(min(uintBitsToFloat(_4623), 4294967040.0)), 0.0, 4294967296.0)) | ((uintBitsToFloat(_4623) >= 4294967296.0) ? 4294967295u : 0u);
    uint _4643 = ((bitfieldExtract(_1081, int(16u), int(16u)) * 26u) << 16u) + ((bitfieldExtract(_1081, int(0u), int(16u)) * 26u) + (_4545 >> 1u));
    precise float _4646 = _4586 + uintBitsToFloat(floatBitsToUint(floor(_4586)) ^ 2147483648u);
    precise float _4652 = _4592 + uintBitsToFloat(floatBitsToUint(floor(_4592)) ^ 2147483648u);
    _42._m0[uint(int(_4643 << 2u) >> int(2u))] = _4466.x;
    uint _4665 = floatBitsToUint(_4482) & (((!isnan(_4482)) && (!isnan(_4482))) ? 4294967295u : 0u);
    float _4670 = min(uintBitsToFloat(_4665), 4294967040.0);
    uint _4675 = uint(clamp(floor(_4670), 0.0, 4294967296.0)) | ((uintBitsToFloat(_4665) >= 4294967296.0) ? 4294967295u : 0u);
    uint _4678;
    if (!_4608)
    {
        _4678 = _4643 << 2u;
    }
    else
    {
        _4678 = floatBitsToUint(_4670);
    }
    if (!_4608)
    {
        _42._m0[uint(int(_4678 + 16u) >> int(2u))] = _4473.x;
    }
    uint _4689 = floatBitsToUint(_4586) & (((!isnan(_4586)) && (!isnan(_4586))) ? 4294967295u : 0u);
    float _4694 = min(uintBitsToFloat(_4689), 4294967040.0);
    uint _4699 = uint(clamp(floor(_4694), 0.0, 4294967296.0)) | ((uintBitsToFloat(_4689) >= 4294967296.0) ? 4294967295u : 0u);
    uint _4702;
    if (!_4605)
    {
        _4702 = _4643 << 2u;
    }
    else
    {
        _4702 = floatBitsToUint(_4694);
    }
    if (!_4605)
    {
        _42._m0[uint(int(_4702 + 832u) >> int(2u))] = _4466.y;
    }
    uint _4714 = floatBitsToUint(_4592) & (((!isnan(_4592)) && (!isnan(_4592))) ? 4294967295u : 0u);
    float _4719 = min(uintBitsToFloat(_4714), 4294967040.0);
    uint _4724 = uint(clamp(floor(_4719), 0.0, 4294967296.0)) | ((uintBitsToFloat(_4714) >= 4294967296.0) ? 4294967295u : 0u);
    uint _4726;
    if (_4611)
    {
        _4726 = _4643 << 2u;
    }
    else
    {
        _4726 = floatBitsToUint(_4719);
    }
    if (_4611)
    {
        _42._m0[uint(int(_4726 + 848u) >> int(2u))] = _4473.y;
    }
    _42._m0[uint(int(_4598 << 2u) >> int(2u))] = _4489.x;
    uint _4740 = floatBitsToUint(_4564) & (((!isnan(_4564)) && (!isnan(_4564))) ? 4294967295u : 0u);
    float _4745 = min(uintBitsToFloat(_4740), 4294967040.0);
    uint _4750 = uint(clamp(floor(_4745), 0.0, 4294967296.0)) | ((uintBitsToFloat(_4740) >= 4294967296.0) ? 4294967295u : 0u);
    uint _4753;
    if (!_4608)
    {
        _4753 = _4598 << 2u;
    }
    else
    {
        _4753 = floatBitsToUint(_4745);
    }
    if (!_4608)
    {
        _42._m0[uint(int(_4753 + 16u) >> int(2u))] = _4530.x;
    }
    uint _4760;
    if (!_4605)
    {
        _4760 = _4598 << 2u;
    }
    else
    {
        _4760 = _4753;
    }
    if (!_4605)
    {
        _42._m0[uint(int(_4760 + 832u) >> int(2u))] = _4489.y;
    }
    uint _4768;
    if (_4611)
    {
        _4768 = _4598 << 2u;
    }
    else
    {
        _4768 = _4760;
    }
    if (_4611)
    {
        _42._m0[uint(int(_4768 + 848u) >> int(2u))] = _4530.y;
    }
    uint _4772 = _4600 << 2u;
    _42._m0[uint(int(_4772) >> int(2u))] = _4497.x;
    uint _4779;
    if (!_4608)
    {
        _4779 = _4600 << 2u;
    }
    else
    {
        _4779 = _4772;
    }
    if (!_4608)
    {
        _42._m0[uint(int(_4779 + 16u) >> int(2u))] = _4517.x;
    }
    uint _4786;
    if (!_4605)
    {
        _4786 = _4600 << 2u;
    }
    else
    {
        _4786 = _4779;
    }
    if (!_4605)
    {
        _42._m0[uint(int(_4786 + 832u) >> int(2u))] = _4497.y;
    }
    uint _4792;
    if (_4611)
    {
        _4792 = _4600 << 2u;
    }
    else
    {
        _4792 = _4786;
    }
    if (_4611)
    {
        _42._m0[uint(int(_4792 + 848u) >> int(2u))] = _4517.y;
    }
    uint _4798 = _4602 << 2u;
    _42._m0[uint(int(_4798) >> int(2u))] = _4452.x;
    uint _4803;
    if (!_4608)
    {
        _4803 = _4602 << 2u;
    }
    else
    {
        _4803 = _4798;
    }
    if (!_4608)
    {
        _42._m0[uint(int(_4803 + 16u) >> int(2u))] = _4459.x;
    }
    uint _4814 = floatBitsToUint(_4511) & (((!isnan(_4511)) && (!isnan(_4511))) ? 4294967295u : 0u);
    float _4819 = min(uintBitsToFloat(_4814), 4294967040.0);
    uint _4824 = uint(clamp(floor(_4819), 0.0, 4294967296.0)) | ((uintBitsToFloat(_4814) >= 4294967296.0) ? 4294967295u : 0u);
    uint _4827;
    if (!_4605)
    {
        _4827 = _4602 << 2u;
    }
    else
    {
        _4827 = floatBitsToUint(_4819);
    }
    if (!_4605)
    {
        _42._m0[uint(int(_4827 + 832u) >> int(2u))] = _4452.y;
    }
    uint _4833;
    if (_4611)
    {
        _4833 = _4602 << 2u;
    }
    else
    {
        _4833 = _4827;
    }
    if (_4611)
    {
        _42._m0[uint(int(_4833 + 848u) >> int(2u))] = _4459.y;
    }
    uint _4843 = floatBitsToUint(_4550) & (((!isnan(_4550)) && (!isnan(_4550))) ? 4294967295u : 0u);
    uint _4852 = uint(clamp(floor(min(uintBitsToFloat(_4843), 4294967040.0)), 0.0, 4294967296.0)) | ((uintBitsToFloat(_4843) >= 4294967296.0) ? 4294967295u : 0u);
    precise float _4855 = _4550 + uintBitsToFloat(floatBitsToUint(floor(_4550)) ^ 2147483648u);
    bool _4858 = _4636 > 46u;
    bool _4859 = _4675 > 46u;
    precise float _4865 = _4537 + uintBitsToFloat(floatBitsToUint(floor(_4537)) ^ 2147483648u);
    uint _4867 = _4858 ? 46u : _4636;
    bool _4868 = _4699 > 46u;
    uint _4875 = floatBitsToUint(_4524) & (((!isnan(_4524)) && (!isnan(_4524))) ? 4294967295u : 0u);
    uint _4884 = uint(clamp(floor(min(uintBitsToFloat(_4875), 4294967040.0)), 0.0, 4294967296.0)) | ((uintBitsToFloat(_4875) >= 4294967296.0) ? 4294967295u : 0u);
    bool _4885 = _4724 > 46u;
    uint _4892 = floatBitsToUint(_4537) & (((!isnan(_4537)) && (!isnan(_4537))) ? 4294967295u : 0u);
    uint _4901 = uint(clamp(floor(min(uintBitsToFloat(_4892), 4294967040.0)), 0.0, 4294967296.0)) | ((uintBitsToFloat(_4892) >= 4294967296.0) ? 4294967295u : 0u);
    uint _4902 = _4859 ? 46u : _4675;
    bool _4903 = _4750 > 46u;
    uint _4904 = _4868 ? 46u : _4699;
    uint _4905 = _4885 ? 46u : _4724;
    precise float _4908 = _4564 + uintBitsToFloat(floatBitsToUint(floor(_4564)) ^ 2147483648u);
    precise float _4912 = _4482 + uintBitsToFloat(floatBitsToUint(floor(_4482)) ^ 2147483648u);
    precise float _4916 = _4511 + uintBitsToFloat(floatBitsToUint(floor(_4511)) ^ 2147483648u);
    uint _4918 = _4903 ? 46u : _4750;
    barrier();
    bool _4927 = _4824 > 46u;
    uint _4943 = (((bitfieldExtract(_4902, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4902, int(0u), int(16u)) * 52u) + _4867)) << 1u;
    precise float _4946 = _4524 + uintBitsToFloat(floatBitsToUint(floor(_4524)) ^ 2147483648u);
    bool _4948 = _4884 > 46u;
    uint _4949 = (((bitfieldExtract(_4904, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4904, int(0u), int(16u)) * 52u) + _4867)) << 1u;
    bool _4950 = _4852 > 46u;
    uint _4951 = (((bitfieldExtract(_4905, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4905, int(0u), int(16u)) * 52u) + _4867)) << 1u;
    bool _4952 = _4901 > 46u;
    uint _4953 = _4927 ? 46u : _4824;
    uint _4965 = _4948 ? 46u : _4884;
    uint _5013 = (packHalf2x16(vec2(uintBitsToFloat(_4859 ? 1065353216u : floatBitsToUint(_4912)), 0.0)) << 16u) + packHalf2x16(vec2(uintBitsToFloat(_4858 ? 1065353216u : floatBitsToUint(_4614)), 0.0));
    uint _5027 = (((bitfieldExtract(_4902, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4902, int(0u), int(16u)) * 52u) + _4918)) << 1u;
    uint _5028 = _4950 ? 46u : _4852;
    uint _5029 = (((bitfieldExtract(_4904, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4904, int(0u), int(16u)) * 52u) + _4918)) << 1u;
    uint _5035 = (((bitfieldExtract(_4902, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4902, int(0u), int(16u)) * 52u) + _4953)) << 1u;
    uint _5042 = (((bitfieldExtract(_4905, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4905, int(0u), int(16u)) * 52u) + _4918)) << 1u;
    uint _5043 = _4952 ? 46u : _4901;
    uint _5069 = (packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(uintBitsToFloat(_4885 ? 1065353216u : floatBitsToUint(_4652)), 0.0));
    uint _5095 = (packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(uintBitsToFloat(_4903 ? 1065353216u : floatBitsToUint(_4908)), 0.0));
    uint _5141 = (packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(uintBitsToFloat(_4952 ? 1065353216u : floatBitsToUint(_4865)), 0.0));
    uint _5155 = (((bitfieldExtract(_4904, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4904, int(0u), int(16u)) * 52u) + _4953)) << 1u;
    uint _5163 = (uint(_36._m0[uint(int(_4949 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_4949) >> int(1u))]) & 65535u);
    uint _5164 = (((bitfieldExtract(_4905, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4905, int(0u), int(16u)) * 52u) + _4953)) << 1u;
    uint _5171 = (packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(uintBitsToFloat(_4868 ? 1065353216u : floatBitsToUint(_4646)), 0.0));
    uint _5182 = (packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(uintBitsToFloat(_4927 ? 1065353216u : floatBitsToUint(_4916)), 0.0));
    vec2 _5183 = unpackHalf2x16(_5163);
    vec2 _5186 = unpackHalf2x16(_5013);
    float _5187 = _5186.x;
    vec2 _5188 = unpackHalf2x16(_5163);
    uint _5195 = (((bitfieldExtract(_4902, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4902, int(0u), int(16u)) * 52u) + _4965)) << 1u;
    uint _5204 = (((bitfieldExtract(_4905, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4905, int(0u), int(16u)) * 52u) + _4965)) << 1u;
    uint _5211 = (packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(uintBitsToFloat(_4948 ? 1065353216u : floatBitsToUint(_4946)), 0.0));
    vec2 _5212 = unpackHalf2x16((uint(_36._m0[uint(int(_4949 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_4949 + 2u) >> int(1u))]) & 65535u));
    vec2 _5215 = unpackHalf2x16(_5013);
    float _5216 = _5215.x;
    precise float _5217 = fma(_5212.x, _5216, fma(_5183.x, -_5187, _5188.x));
    uint _5230 = (packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(uintBitsToFloat(_4950 ? 1065353216u : floatBitsToUint(_4855)), 0.0));
    uint _5233 = (uint(_36._m0[uint(int(_4951 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_4951) >> int(1u))]) & 65535u);
    vec2 _5246 = unpackHalf2x16(_5233);
    vec2 _5249 = unpackHalf2x16(_5013);
    float _5250 = _5249.x;
    vec2 _5251 = unpackHalf2x16(_5233);
    precise float _5263 = fma(fma(_5212.y, _5216, fma(_5183.y, -_5187, _5188.y)), unpackHalf2x16(_5171).x, fma(_5217, -unpackHalf2x16(_5171).x, _5217));
    vec2 _5269 = unpackHalf2x16((uint(_36._m0[uint(int(_4951 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_4951 + 2u) >> int(1u))]) & 65535u));
    vec2 _5272 = unpackHalf2x16(_5013);
    float _5273 = _5272.x;
    precise float _5274 = fma(_5269.x, _5273, fma(_5246.x, -_5250, _5251.x));
    vec2 _5281 = unpackHalf2x16((packHalf2x16(vec2(_4235.y, 0.0)) << 16u) + packHalf2x16(vec2(_4235.x, 0.0)));
    precise float _5284 = _5281.x + _5263;
    precise float _5285 = _5281.y + _5263;
    uint _5288 = (uint(_36._m0[uint(int(_4943 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_4943) >> int(1u))]) & 65535u);
    precise float _5300 = _5284 * abs(_5284);
    precise float _5301 = _5285 * abs(_5285);
    uint _5303 = packHalf2x16(vec2(_5300, _5301));
    vec2 _5304 = unpackHalf2x16(_5288);
    vec2 _5307 = unpackHalf2x16(_5013);
    float _5308 = _5307.x;
    vec2 _5309 = unpackHalf2x16(_5288);
    precise float _5323 = fma(fma(_5269.y, _5273, fma(_5246.y, -_5250, _5251.y)), unpackHalf2x16(_5069).x, fma(_5274, -unpackHalf2x16(_5069).x, _5274));
    precise float _5329 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_4235.z, 0.0))).x + _5263;
    vec2 _5335 = unpackHalf2x16((uint(_36._m0[uint(int(_4943 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_4943 + 2u) >> int(1u))]) & 65535u));
    vec2 _5338 = unpackHalf2x16(_5013);
    float _5339 = _5338.x;
    precise float _5340 = fma(_5335.x, _5339, fma(_5304.x, -_5308, _5309.x));
    precise float _5358 = fma(fma(_5335.y, _5339, fma(_5304.y, -_5308, _5309.y)), unpackHalf2x16(_5013).y, fma(_5340, -unpackHalf2x16(_5013).y, _5340));
    vec2 _5364 = unpackHalf2x16((packHalf2x16(vec2(_4106.y, 0.0)) << 16u) + packHalf2x16(vec2(_4106.x, 0.0)));
    precise float _5367 = _5364.x + _5358;
    precise float _5368 = _5364.y + _5358;
    precise float _5376 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_4106.z, 0.0))).x + _5358;
    precise float _5379 = _5367 * abs(_5367);
    precise float _5380 = _5368 * abs(_5368);
    precise float _5388 = _5376 * abs(_5376);
    precise float _5389 = _5376 * abs(_5376);
    uint _5399 = (uint(_36._m0[uint(int(_5027 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5027) >> int(1u))]) & 65535u);
    uint _5402 = (uint(_36._m0[uint(int(_5035 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5035) >> int(1u))]) & 65535u);
    uint _5409 = (uint(_36._m0[uint(int(_5042 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5042) >> int(1u))]) & 65535u);
    vec2 _5410 = unpackHalf2x16(_5399);
    vec2 _5413 = unpackHalf2x16(_5095);
    float _5414 = _5413.x;
    vec2 _5415 = unpackHalf2x16(_5399);
    vec2 _5427 = unpackHalf2x16(_5402);
    vec2 _5430 = unpackHalf2x16(_5182);
    float _5431 = _5430.x;
    vec2 _5432 = unpackHalf2x16(_5402);
    vec2 _5439 = unpackHalf2x16(_5409);
    vec2 _5442 = unpackHalf2x16(_5095);
    float _5443 = _5442.x;
    vec2 _5444 = unpackHalf2x16(_5409);
    uint _5462 = (uint(_36._m0[uint(int(_5029 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5029) >> int(1u))]) & 65535u);
    vec2 _5471 = unpackHalf2x16(_5462);
    vec2 _5474 = unpackHalf2x16(_5095);
    float _5475 = _5474.x;
    vec2 _5476 = unpackHalf2x16(_5462);
    vec2 _5491 = unpackHalf2x16((uint(_36._m0[uint(int(_5027 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5027 + 2u) >> int(1u))]) & 65535u));
    vec2 _5494 = unpackHalf2x16(_5095);
    float _5495 = _5494.x;
    precise float _5496 = fma(_5491.x, _5495, fma(_5410.x, -_5414, _5415.x));
    vec2 _5503 = unpackHalf2x16((uint(_36._m0[uint(int(_5029 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5029 + 2u) >> int(1u))]) & 65535u));
    vec2 _5506 = unpackHalf2x16(_5095);
    float _5507 = _5506.x;
    precise float _5508 = fma(_5503.x, _5507, fma(_5471.x, -_5475, _5476.x));
    vec2 _5526 = unpackHalf2x16((uint(_36._m0[uint(int(_5035 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5035 + 2u) >> int(1u))]) & 65535u));
    vec2 _5529 = unpackHalf2x16(_5182);
    float _5530 = _5529.x;
    precise float _5531 = fma(_5526.x, _5530, fma(_5427.x, -_5431, _5432.x));
    vec2 _5545 = unpackHalf2x16((uint(_36._m0[uint(int(_5042 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5042 + 2u) >> int(1u))]) & 65535u));
    vec2 _5548 = unpackHalf2x16(_5095);
    float _5549 = _5548.x;
    precise float _5550 = fma(_5545.x, _5549, fma(_5439.x, -_5443, _5444.x));
    precise float _5551 = fma(_5545.y, _5549, fma(_5439.y, -_5443, _5444.y));
    uint _5563 = (uint(_36._m0[uint(int(_5155 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5155) >> int(1u))]) & 65535u);
    precise float _5567 = fma(_5550, -unpackHalf2x16(_5069).x, _5550);
    precise float _5575 = fma(fma(_5491.y, _5495, fma(_5410.y, -_5414, _5415.y)), unpackHalf2x16(_5013).y, fma(_5496, -unpackHalf2x16(_5013).y, _5496));
    precise float _5578 = fma(fma(_5503.y, _5507, fma(_5471.y, -_5475, _5476.y)), unpackHalf2x16(_5171).x, fma(_5508, -unpackHalf2x16(_5171).x, _5508));
    precise float _5586 = fma(fma(_5526.y, _5530, fma(_5427.y, -_5431, _5432.y)), unpackHalf2x16(_5013).y, fma(_5531, -unpackHalf2x16(_5013).y, _5531));
    uint _5589 = (uint(_36._m0[uint(int(_5164 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5164) >> int(1u))]) & 65535u);
    vec2 _5590 = unpackHalf2x16(_5563);
    vec2 _5593 = unpackHalf2x16(_5182);
    float _5594 = _5593.x;
    vec2 _5595 = unpackHalf2x16(_5563);
    uint _5602 = (((bitfieldExtract(_4904, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4904, int(0u), int(16u)) * 52u) + _4965)) << 1u;
    uint _5608 = (((bitfieldExtract(_4904, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4904, int(0u), int(16u)) * 52u) + _5028)) << 1u;
    vec2 _5609 = unpackHalf2x16(_5589);
    vec2 _5612 = unpackHalf2x16(_5182);
    float _5613 = _5612.x;
    vec2 _5614 = unpackHalf2x16(_5589);
    uint _5621 = (((bitfieldExtract(_4904, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4904, int(0u), int(16u)) * 52u) + _5043)) << 1u;
    vec2 _5630 = unpackHalf2x16(_5069);
    float _5631 = _5630.x;
    precise float _5632 = fma(_5551, _5631, _5567);
    vec2 _5640 = unpackHalf2x16((packHalf2x16(vec2(_4145.y, 0.0)) << 16u) + packHalf2x16(vec2(_4145.x, 0.0)));
    precise float _5643 = _5640.x + _5575;
    precise float _5644 = _5640.y + _5575;
    vec2 _5645 = unpackHalf2x16((uint(_36._m0[uint(int(_5155 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5155 + 2u) >> int(1u))]) & 65535u));
    vec2 _5648 = unpackHalf2x16(_5182);
    float _5649 = _5648.x;
    precise float _5650 = fma(_5645.x, _5649, fma(_5590.x, -_5594, _5595.x));
    uint _5660 = (((bitfieldExtract(_4902, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4902, int(0u), int(16u)) * 52u) + _5028)) << 1u;
    precise float _5671 = _5643 * abs(_5643);
    precise float _5672 = _5644 * abs(_5644);
    vec2 _5675 = unpackHalf2x16((uint(_36._m0[uint(int(_5164 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5164 + 2u) >> int(1u))]) & 65535u));
    vec2 _5678 = unpackHalf2x16(_5182);
    float _5679 = _5678.x;
    precise float _5680 = fma(_5675.x, _5679, fma(_5609.x, -_5613, _5614.x));
    uint _5687 = (((bitfieldExtract(_4905, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4905, int(0u), int(16u)) * 52u) + _5028)) << 1u;
    precise float _5690 = fma(fma(_5645.y, _5649, fma(_5590.y, -_5594, _5595.y)), unpackHalf2x16(_5171).x, fma(_5650, -unpackHalf2x16(_5171).x, _5650));
    uint _5691 = (((bitfieldExtract(_4902, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4902, int(0u), int(16u)) * 52u) + _5043)) << 1u;
    uint _5702 = (uint(_36._m0[uint(int(_5195 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5195) >> int(1u))]) & 65535u);
    uint _5703 = (((bitfieldExtract(_4905, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4905, int(0u), int(16u)) * 52u) + _5043)) << 1u;
    precise float _5711 = fma(fma(_5675.y, _5679, fma(_5609.y, -_5613, _5614.y)), unpackHalf2x16(_5069).x, fma(_5680, -unpackHalf2x16(_5069).x, _5680));
    uint _5714 = (packHalf2x16(vec2(_5671, _5672)) << 16u) + (packHalf2x16(vec2(_5388, _5389)) & 65535u);
    vec2 _5715 = unpackHalf2x16(_5702);
    vec2 _5718 = unpackHalf2x16(_5211);
    float _5719 = _5718.x;
    vec2 _5720 = unpackHalf2x16(_5702);
    vec2 _5735 = unpackHalf2x16((packHalf2x16(vec2(_4163.y, 0.0)) << 16u) + packHalf2x16(vec2(_4163.x, 0.0)));
    precise float _5738 = _5735.x + _5586;
    precise float _5739 = _5735.y + _5586;
    precise float _5747 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_4145.z, 0.0))).x + _5575;
    vec2 _5748 = unpackHalf2x16((uint(_36._m0[uint(int(_5195 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5195 + 2u) >> int(1u))]) & 65535u));
    vec2 _5751 = unpackHalf2x16(_5211);
    float _5752 = _5751.x;
    precise float _5753 = fma(_5748.x, _5752, fma(_5715.x, -_5719, _5720.x));
    precise float _5762 = _5738 * abs(_5738);
    precise float _5763 = _5739 * abs(_5739);
    uint _5765 = packHalf2x16(vec2(_5762, _5763));
    precise float _5779 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_4163.z, 0.0))).x + _5586;
    precise float _5787 = fma(fma(_5748.y, _5752, fma(_5715.y, -_5719, _5720.y)), unpackHalf2x16(_5013).y, fma(_5753, -unpackHalf2x16(_5013).y, _5753));
    vec2 _5788 = unpackHalf2x16((packHalf2x16(vec2(_4253.y, 0.0)) << 16u) + packHalf2x16(vec2(_4253.x, 0.0)));
    precise float _5791 = _5788.x + _5578;
    precise float _5792 = _5788.y + _5578;
    uint _5799 = (uint(_36._m0[uint(int(_5602 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5602) >> int(1u))]) & 65535u);
    vec2 _5800 = unpackHalf2x16((packHalf2x16(vec2(_4181.y, 0.0)) << 16u) + packHalf2x16(vec2(_4181.x, 0.0)));
    precise float _5803 = _5800.x + _5787;
    precise float _5804 = _5800.y + _5787;
    precise float _5812 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_4181.z, 0.0))).x + _5787;
    vec2 _5813 = unpackHalf2x16(_5799);
    vec2 _5816 = unpackHalf2x16(_5211);
    float _5817 = _5816.x;
    vec2 _5818 = unpackHalf2x16(_5799);
    precise float _5832 = _5803 * abs(_5803);
    precise float _5833 = _5804 * abs(_5804);
    uint _5835 = packHalf2x16(vec2(_5832, _5833));
    precise float _5838 = _5791 * abs(_5791);
    precise float _5839 = _5792 * abs(_5792);
    uint _5849 = (uint(_36._m0[uint(int(_5204 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5204) >> int(1u))]) & 65535u);
    vec2 _5850 = unpackHalf2x16((packHalf2x16(vec2(_4271.y, 0.0)) << 16u) + packHalf2x16(vec2(_4271.x, 0.0)));
    precise float _5853 = _5850.x + _5690;
    precise float _5854 = _5850.y + _5690;
    vec2 _5860 = unpackHalf2x16(968374712u);
    precise float _5863 = _5839 * _5860.x;
    precise float _5864 = _5839 * _5860.y;
    vec2 _5867 = unpackHalf2x16(_5849);
    vec2 _5870 = unpackHalf2x16(_5211);
    float _5871 = _5870.x;
    vec2 _5872 = unpackHalf2x16(_5849);
    precise float _5889 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_4253.z, 0.0))).x + _5578;
    vec2 _5894 = unpackHalf2x16((uint(_36._m0[uint(int(_5204 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5204 + 2u) >> int(1u))]) & 65535u));
    vec2 _5897 = unpackHalf2x16(_5211);
    float _5898 = _5897.x;
    precise float _5899 = fma(_5894.x, _5898, fma(_5867.x, -_5871, _5872.x));
    uint _5903 = (uint(_36._m0[uint(int(_5608 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5608) >> int(1u))]) & 65535u);
    vec2 _5904 = unpackHalf2x16((uint(_36._m0[uint(int(_5602 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5602 + 2u) >> int(1u))]) & 65535u));
    vec2 _5907 = unpackHalf2x16(_5211);
    float _5908 = _5907.x;
    precise float _5909 = fma(_5904.x, _5908, fma(_5813.x, -_5817, _5818.x));
    vec2 _5927 = unpackHalf2x16(_5903);
    vec2 _5930 = unpackHalf2x16(_5230);
    float _5931 = _5930.x;
    vec2 _5932 = unpackHalf2x16(_5903);
    precise float _5941 = _5853 * abs(_5853);
    precise float _5942 = _5854 * abs(_5854);
    uint _5952 = (uint(_36._m0[uint(int(_5660 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5660) >> int(1u))]) & 65535u);
    vec2 _5953 = unpackHalf2x16((uint(_36._m0[uint(int(_5608 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5608 + 2u) >> int(1u))]) & 65535u));
    vec2 _5956 = unpackHalf2x16(_5230);
    float _5957 = _5956.x;
    precise float _5958 = fma(_5953.x, _5957, fma(_5927.x, -_5931, _5932.x));
    vec2 _5969 = unpackHalf2x16(_5952);
    vec2 _5972 = unpackHalf2x16(_5230);
    float _5973 = _5972.x;
    vec2 _5974 = unpackHalf2x16(_5952);
    precise float _5988 = fma(fma(_5904.y, _5908, fma(_5813.y, -_5817, _5818.y)), unpackHalf2x16(_5171).x, fma(_5909, -unpackHalf2x16(_5171).x, _5909));
    precise float _5991 = fma(fma(_5894.y, _5898, fma(_5867.y, -_5871, _5872.y)), unpackHalf2x16(_5069).x, fma(_5899, -unpackHalf2x16(_5069).x, _5899));
    uint _5999 = (uint(_36._m0[uint(int(_5687 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5687) >> int(1u))]) & 65535u);
    vec2 _6012 = unpackHalf2x16(_5999);
    vec2 _6015 = unpackHalf2x16(_5230);
    float _6016 = _6015.x;
    vec2 _6017 = unpackHalf2x16(_5999);
    vec2 _6028 = unpackHalf2x16(968374712u);
    precise float _6031 = _5942 * _6028.x;
    precise float _6032 = _5942 * _6028.y;
    vec2 _6035 = unpackHalf2x16((uint(_36._m0[uint(int(_5660 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5660 + 2u) >> int(1u))]) & 65535u));
    vec2 _6038 = unpackHalf2x16(_5230);
    float _6039 = _6038.x;
    precise float _6040 = fma(_6035.x, _6039, fma(_5969.x, -_5973, _5974.x));
    vec2 _6050 = unpackHalf2x16((packHalf2x16(vec2(_4289.y, 0.0)) << 16u) + packHalf2x16(vec2(_4289.x, 0.0)));
    precise float _6053 = _6050.x + _5988;
    precise float _6054 = _6050.y + _5988;
    vec2 _6064 = unpackHalf2x16((uint(_36._m0[uint(int(_5687 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5687 + 2u) >> int(1u))]) & 65535u));
    vec2 _6067 = unpackHalf2x16(_5230);
    float _6068 = _6067.x;
    precise float _6069 = fma(_6064.x, _6068, fma(_6012.x, -_6016, _6017.x));
    uint _6078 = (uint(_36._m0[uint(int(_5621 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5621) >> int(1u))]) & 65535u);
    precise float _6081 = fma(fma(_6035.y, _6039, fma(_5969.y, -_5973, _5974.y)), unpackHalf2x16(_5013).y, fma(_6040, -unpackHalf2x16(_5013).y, _6040));
    precise float _6084 = fma(fma(_5953.y, _5957, fma(_5927.y, -_5931, _5932.y)), unpackHalf2x16(_5171).x, fma(_5958, -unpackHalf2x16(_5171).x, _5958));
    vec2 _6086 = unpackHalf2x16(_6078);
    vec2 _6089 = unpackHalf2x16(_5141);
    float _6090 = _6089.x;
    vec2 _6091 = unpackHalf2x16(_6078);
    uint _6100 = (uint(_36._m0[uint(int(_5691 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5691) >> int(1u))]) & 65535u);
    vec2 _6101 = unpackHalf2x16((packHalf2x16(vec2(_4199.y, 0.0)) << 16u) + packHalf2x16(vec2(_4199.x, 0.0)));
    precise float _6104 = _6101.x + _6081;
    precise float _6105 = _6101.y + _6081;
    precise float _6108 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_4199.z, 0.0))).x + _6081;
    vec2 _6109 = unpackHalf2x16(_6100);
    vec2 _6112 = unpackHalf2x16(_5141);
    float _6113 = _6112.x;
    vec2 _6114 = unpackHalf2x16(_6100);
    precise float _6123 = _6104 * abs(_6104);
    precise float _6124 = _6105 * abs(_6105);
    uint _6126 = packHalf2x16(vec2(_6123, _6124));
    precise float _6132 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_4271.z, 0.0))).x + _5690;
    vec2 _6133 = unpackHalf2x16(968374712u);
    precise float _6136 = _6124 * _6133.x;
    precise float _6137 = _6124 * _6133.y;
    vec2 _6140 = unpackHalf2x16((uint(_36._m0[uint(int(_5621 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5621 + 2u) >> int(1u))]) & 65535u));
    vec2 _6143 = unpackHalf2x16(_5141);
    float _6144 = _6143.x;
    precise float _6145 = fma(_6140.x, _6144, fma(_6086.x, -_6090, _6091.x));
    precise float _6149 = _6053 * abs(_6053);
    precise float _6150 = _6054 * abs(_6054);
    precise float _6158 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_4289.z, 0.0))).x + _5988;
    vec2 _6159 = unpackHalf2x16(968374712u);
    precise float _6162 = _6150 * _6159.x;
    precise float _6163 = _6150 * _6159.y;
    vec2 _6166 = unpackHalf2x16((uint(_36._m0[uint(int(_5691 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5691 + 2u) >> int(1u))]) & 65535u));
    vec2 _6169 = unpackHalf2x16(_5141);
    float _6170 = _6169.x;
    precise float _6171 = fma(_6166.x, _6170, fma(_6109.x, -_6113, _6114.x));
    uint _6173 = gl_SubgroupInvocationID & 7u;
    uint _6176 = (uint(_36._m0[uint(int(_5703 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5703) >> int(1u))]) & 65535u);
    vec2 _6185 = unpackHalf2x16(_6176);
    vec2 _6188 = unpackHalf2x16(_5141);
    float _6189 = _6188.x;
    vec2 _6190 = unpackHalf2x16(_6176);
    uint _6197 = (((bitfieldExtract(_3866, int(16u), int(16u)) * 48u) << 16u) + ((bitfieldExtract(_3866, int(0u), int(16u)) * 48u) + _6173)) << 1u;
    vec2 _6205 = unpackHalf2x16((uint(_36._m0[uint(int(_5703 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5703 + 2u) >> int(1u))]) & 65535u));
    vec2 _6208 = unpackHalf2x16(_5141);
    float _6209 = _6208.x;
    precise float _6210 = fma(_6205.x, _6209, fma(_6185.x, -_6189, _6190.x));
    precise float _6218 = fma(fma(_6140.y, _6144, fma(_6086.y, -_6090, _6091.y)), unpackHalf2x16(_5171).x, fma(_6145, -unpackHalf2x16(_5171).x, _6145));
    vec2 _6219 = unpackHalf2x16(968374712u);
    precise float _6221 = _5380 * _6219.x;
    precise float _6224 = fma(fma(_6166.y, _6170, fma(_6109.y, -_6113, _6114.y)), unpackHalf2x16(_5013).y, fma(_6171, -unpackHalf2x16(_5013).y, _6171));
    vec2 _6225 = unpackHalf2x16(852308685u);
    vec2 _6232 = unpackHalf2x16(968374712u);
    precise float _6235 = _5672 * _6232.x;
    precise float _6236 = _5672 * _6232.y;
    precise float _6252 = fma(fma(_6064.y, _6068, fma(_6012.y, -_6016, _6017.y)), unpackHalf2x16(_5069).x, fma(_6069, -unpackHalf2x16(_5069).x, _6069));
    precise float _6255 = fma(fma(_6205.y, _6209, fma(_6185.y, -_6189, _6190.y)), unpackHalf2x16(_5069).x, fma(_6210, -unpackHalf2x16(_5069).x, _6210));
    precise float _6258 = _5747 * abs(_5747);
    precise float _6259 = _5747 * abs(_5747);
    vec2 _6263 = unpackHalf2x16(_5714);
    vec2 _6266 = unpackHalf2x16(852307102u);
    vec2 _6269 = unpackHalf2x16((packHalf2x16(vec2(_6235, _6236)) << 16u) + (packHalf2x16(vec2(fma(_5379, _6225.x, _6221), fma(_5379, _6225.y, _6221))) & 65535u));
    uint _6275 = packHalf2x16(vec2(fma(_6263.x, _6266.x, _6269.x), fma(_6263.y, _6266.y, _6269.y)));
    vec2 _6276 = unpackHalf2x16(968374712u);
    precise float _6279 = _5763 * _6276.x;
    precise float _6280 = _5763 * _6276.y;
    uint _6285 = (_5765 << 16u) + (packHalf2x16(vec2(_6258, _6259)) & 65535u);
    precise float _6288 = _5779 * abs(_5779);
    precise float _6289 = _5779 * abs(_5779);
    vec2 _6292 = unpackHalf2x16((packHalf2x16(vec2(_4217.y, 0.0)) << 16u) + packHalf2x16(vec2(_4217.x, 0.0)));
    precise float _6295 = _6292.x + _6224;
    precise float _6296 = _6292.y + _6224;
    precise float _6302 = _5812 * abs(_5812);
    precise float _6303 = _5812 * abs(_5812);
    uint _6308 = (_5835 << 16u) + (packHalf2x16(vec2(_6288, _6289)) & 65535u);
    precise float _6311 = _6295 * abs(_6295);
    precise float _6312 = _6296 * abs(_6296);
    vec2 _6315 = unpackHalf2x16(_6285);
    vec2 _6318 = unpackHalf2x16(852307102u);
    vec2 _6321 = unpackHalf2x16((packHalf2x16(vec2(_6279, _6280)) << 16u) + (_6275 >> 16u));
    uint _6327 = packHalf2x16(vec2(fma(_6315.x, _6318.x, _6321.x), fma(_6315.y, _6318.y, _6321.y)));
    uint _6330 = (_6126 << 16u) + (packHalf2x16(vec2(_6302, _6303)) & 65535u);
    vec2 _6331 = unpackHalf2x16(968374712u);
    precise float _6334 = _5833 * _6331.x;
    precise float _6335 = _5833 * _6331.y;
    precise float _6340 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_4217.z, 0.0))).x + _6224;
    vec2 _6341 = unpackHalf2x16(968374712u);
    precise float _6344 = _5301 * _6341.x;
    precise float _6345 = _5301 * _6341.y;
    vec2 _6351 = unpackHalf2x16(_6308);
    vec2 _6354 = unpackHalf2x16(852307102u);
    vec2 _6357 = unpackHalf2x16((packHalf2x16(vec2(_6334, _6335)) << 16u) + (_6327 >> 16u));
    uint _6363 = packHalf2x16(vec2(fma(_6351.x, _6354.x, _6357.x), fma(_6351.y, _6354.y, _6357.y)));
    precise float _6366 = _6108 * abs(_6108);
    precise float _6367 = _6108 * abs(_6108);
    precise float _6375 = _6340 * abs(_6340);
    precise float _6376 = _6340 * abs(_6340);
    uint _6381 = (packHalf2x16(vec2(_6311, _6312)) << 16u) + (packHalf2x16(vec2(_6366, _6367)) & 65535u);
    vec2 _6382 = unpackHalf2x16(_6330);
    vec2 _6385 = unpackHalf2x16(852307102u);
    vec2 _6388 = unpackHalf2x16((packHalf2x16(vec2(_6136, _6137)) << 16u) + (_6363 >> 16u));
    uint _6394 = packHalf2x16(vec2(fma(_6382.x, _6385.x, _6388.x), fma(_6382.y, _6385.y, _6388.y)));
    uint _6397 = (_5303 << 16u) + (packHalf2x16(vec2(_6375, _6376)) & 65535u);
    vec2 _6398 = unpackHalf2x16(968374712u);
    precise float _6401 = _6312 * _6398.x;
    precise float _6402 = _6312 * _6398.y;
    precise float _6410 = _5329 * abs(_5329);
    precise float _6411 = _5329 * abs(_5329);
    vec2 _6414 = unpackHalf2x16(_6381);
    vec2 _6417 = unpackHalf2x16(852307102u);
    vec2 _6420 = unpackHalf2x16((packHalf2x16(vec2(_6401, _6402)) << 16u) + (_6394 >> 16u));
    uint _6426 = packHalf2x16(vec2(fma(_6414.x, _6417.x, _6420.x), fma(_6414.y, _6417.y, _6420.y)));
    uint _6429 = (packHalf2x16(vec2(_5838, _5839)) << 16u) + (packHalf2x16(vec2(_6410, _6411)) & 65535u);
    vec2 _6433 = unpackHalf2x16(_6397);
    vec2 _6436 = unpackHalf2x16(852307102u);
    vec2 _6439 = unpackHalf2x16((packHalf2x16(vec2(_6344, _6345)) << 16u) + (_6426 >> 16u));
    uint _6445 = packHalf2x16(vec2(fma(_6433.x, _6436.x, _6439.x), fma(_6433.y, _6436.y, _6439.y)));
    precise float _6448 = _5889 * abs(_5889);
    precise float _6449 = _5889 * abs(_5889);
    uint _6457 = (packHalf2x16(vec2(_5941, _5942)) << 16u) + (packHalf2x16(vec2(_6448, _6449)) & 65535u);
    vec2 _6458 = unpackHalf2x16(_6429);
    vec2 _6461 = unpackHalf2x16(852307102u);
    vec2 _6464 = unpackHalf2x16((packHalf2x16(vec2(_5863, _5864)) << 16u) + (_6445 >> 16u));
    uint _6470 = packHalf2x16(vec2(fma(_6458.x, _6461.x, _6464.x), fma(_6458.y, _6461.y, _6464.y)));
    precise float _6473 = _6132 * abs(_6132);
    precise float _6474 = _6132 * abs(_6132);
    vec2 _6480 = unpackHalf2x16(_6457);
    vec2 _6483 = unpackHalf2x16(852307102u);
    vec2 _6486 = unpackHalf2x16((packHalf2x16(vec2(_6031, _6032)) << 16u) + (_6470 >> 16u));
    uint _6492 = packHalf2x16(vec2(fma(_6480.x, _6483.x, _6486.x), fma(_6480.y, _6483.y, _6486.y)));
    barrier();
    vec2 _6493 = unpackHalf2x16((packHalf2x16(vec2(_4307.y, 0.0)) << 16u) + packHalf2x16(vec2(_4307.x, 0.0)));
    precise float _6496 = _6493.x + _6084;
    precise float _6497 = _6493.y + _6084;
    _36._m0[uint(int(_6197) >> int(1u))] = uint16_t(_6275);
    uint _6503 = (packHalf2x16(vec2(_6149, _6150)) << 16u) + (packHalf2x16(vec2(_6473, _6474)) & 65535u);
    precise float _6506 = _6158 * abs(_6158);
    precise float _6507 = _6158 * abs(_6158);
    precise float _6512 = _6496 * abs(_6496);
    precise float _6513 = _6497 * abs(_6497);
    _36._m0[uint(int(_6197 + 16u) >> int(1u))] = uint16_t(_6327);
    precise float _6522 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_4307.z, 0.0))).x + _6084;
    vec2 _6523 = unpackHalf2x16((packHalf2x16(vec2(_4343.y, 0.0)) << 16u) + packHalf2x16(vec2(_4343.x, 0.0)));
    precise float _6526 = _6523.x + _5323;
    precise float _6527 = _6523.y + _5323;
    uint _6530 = (packHalf2x16(vec2(_6512, _6513)) << 16u) + (packHalf2x16(vec2(_6506, _6507)) & 65535u);
    _36._m0[uint(int(_6197 + 32u) >> int(1u))] = uint16_t(_6363);
    precise float _6540 = _6522 * abs(_6522);
    precise float _6541 = _6522 * abs(_6522);
    _36._m0[uint(int(_6197 + 64u) >> int(1u))] = uint16_t(_6426);
    vec2 _6549 = unpackHalf2x16((packHalf2x16(vec2(_4325.y, 0.0)) << 16u) + packHalf2x16(vec2(_4325.x, 0.0)));
    precise float _6552 = _6549.x + _6218;
    precise float _6553 = _6549.y + _6218;
    vec2 _6554 = unpackHalf2x16(_6503);
    vec2 _6557 = unpackHalf2x16(852307102u);
    vec2 _6560 = unpackHalf2x16((packHalf2x16(vec2(_6162, _6163)) << 16u) + (_6492 >> 16u));
    uint _6566 = packHalf2x16(vec2(fma(_6554.x, _6557.x, _6560.x), fma(_6554.y, _6557.y, _6560.y)));
    _36._m0[uint(int(_6197 + 384u) >> int(1u))] = uint16_t(_6470);
    vec2 _6572 = unpackHalf2x16(968374712u);
    precise float _6575 = _6513 * _6572.x;
    precise float _6576 = _6513 * _6572.y;
    precise float _6581 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_4325.z, 0.0))).x + _6218;
    _36._m0[uint(int(_6197 + 48u) >> int(1u))] = uint16_t(_6394);
    vec2 _6586 = unpackHalf2x16((packHalf2x16(vec2(_4361.y, 0.0)) << 16u) + packHalf2x16(vec2(_4361.x, 0.0)));
    precise float _6589 = _6586.x + _5632;
    precise float _6590 = _6586.y + _5632;
    precise float _6596 = _6552 * abs(_6552);
    precise float _6597 = _6553 * abs(_6553);
    _36._m0[uint(int(_6197 + 80u) >> int(1u))] = uint16_t(_6445);
    precise float _6606 = _6581 * abs(_6581);
    precise float _6607 = _6581 * abs(_6581);
    vec2 _6610 = unpackHalf2x16(_6530);
    vec2 _6613 = unpackHalf2x16(852307102u);
    vec2 _6616 = unpackHalf2x16((packHalf2x16(vec2(_6575, _6576)) << 16u) + (_6566 >> 16u));
    uint _6622 = packHalf2x16(vec2(fma(_6610.x, _6613.x, _6616.x), fma(_6610.y, _6613.y, _6616.y)));
    uint _6625 = (packHalf2x16(vec2(_6596, _6597)) << 16u) + (packHalf2x16(vec2(_6540, _6541)) & 65535u);
    vec2 _6626 = unpackHalf2x16(968374712u);
    precise float _6629 = _6597 * _6626.x;
    precise float _6630 = _6597 * _6626.y;
    _36._m0[uint(int(_6197 + 400u) >> int(1u))] = uint16_t(_6492);
    precise float _6639 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_4343.z, 0.0))).x + _5323;
    precise float _6646 = _6589 * abs(_6589);
    precise float _6647 = _6590 * abs(_6590);
    precise float _6655 = _6526 * abs(_6526);
    precise float _6656 = _6527 * abs(_6527);
    precise float _6663 = _6639 * abs(_6639);
    precise float _6664 = _6639 * abs(_6639);
    vec2 _6667 = unpackHalf2x16(_6625);
    vec2 _6670 = unpackHalf2x16(852307102u);
    vec2 _6673 = unpackHalf2x16((packHalf2x16(vec2(_6629, _6630)) << 16u) + (_6622 >> 16u));
    uint _6679 = packHalf2x16(vec2(fma(_6667.x, _6670.x, _6673.x), fma(_6667.y, _6670.y, _6673.y)));
    uint _6682 = (packHalf2x16(vec2(_6655, _6656)) << 16u) + (packHalf2x16(vec2(_6606, _6607)) & 65535u);
    vec2 _6683 = unpackHalf2x16(968374712u);
    precise float _6686 = _6656 * _6683.x;
    precise float _6687 = _6656 * _6683.y;
    uint _6692 = (packHalf2x16(vec2(_6646, _6647)) << 16u) + (packHalf2x16(vec2(_6663, _6664)) & 65535u);
    vec2 _6693 = unpackHalf2x16(968374712u);
    precise float _6696 = _6647 * _6693.x;
    precise float _6697 = _6647 * _6693.y;
    _36._m0[uint(int(_6197 + 432u) >> int(1u))] = uint16_t((_6622 & 65535u) + (_6470 & 4294901760u));
    vec2 _6705 = unpackHalf2x16((packHalf2x16(vec2(_4379.y, 0.0)) << 16u) + packHalf2x16(vec2(_4379.x, 0.0)));
    precise float _6708 = _6705.x + _5711;
    precise float _6709 = _6705.y + _5711;
    precise float _6715 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_4361.z, 0.0))).x + _5632;
    vec2 _6719 = unpackHalf2x16((packHalf2x16(vec2(_4397.y, 0.0)) << 16u) + packHalf2x16(vec2(_4397.x, 0.0)));
    precise float _6722 = _6719.x + _5991;
    precise float _6723 = _6719.y + _5991;
    _36._m0[uint(int(_6197 + 416u) >> int(1u))] = uint16_t(_6566);
    vec2 _6728 = unpackHalf2x16(_6682);
    vec2 _6731 = unpackHalf2x16(852307102u);
    vec2 _6734 = unpackHalf2x16((packHalf2x16(vec2(_6686, _6687)) << 16u) + (_6679 >> 16u));
    uint _6740 = packHalf2x16(vec2(fma(_6728.x, _6731.x, _6734.x), fma(_6728.y, _6731.y, _6734.y)));
    precise float _6743 = _6708 * abs(_6708);
    precise float _6744 = _6709 * abs(_6709);
    _36._m0[uint(int(_6197 + 448u) >> int(1u))] = uint16_t((_6679 & 65535u) + (packHalf2x16(vec2(_5632, fma(_5551, _5631, _5567))) & 4294901760u));
    precise float _6754 = _6715 * abs(_6715);
    precise float _6755 = _6715 * abs(_6715);
    vec2 _6761 = unpackHalf2x16(968374712u);
    precise float _6764 = _6744 * _6761.x;
    precise float _6765 = _6744 * _6761.y;
    precise float _6770 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_4379.z, 0.0))).x + _5711;
    uint _6773 = (packHalf2x16(vec2(_6743, _6744)) << 16u) + (packHalf2x16(vec2(_6754, _6755)) & 65535u);
    vec2 _6774 = unpackHalf2x16(_6692);
    vec2 _6777 = unpackHalf2x16(852307102u);
    vec2 _6780 = unpackHalf2x16((packHalf2x16(vec2(_6696, _6697)) << 16u) + (_6740 >> 16u));
    uint _6786 = packHalf2x16(vec2(fma(_6774.x, _6777.x, _6780.x), fma(_6774.y, _6777.y, _6780.y)));
    precise float _6791 = _6722 * abs(_6722);
    precise float _6792 = _6723 * abs(_6723);
    precise float _6797 = _6770 * abs(_6770);
    precise float _6798 = _6770 * abs(_6770);
    vec2 _6804 = unpackHalf2x16((packHalf2x16(vec2(_4415.y, 0.0)) << 16u) + packHalf2x16(vec2(_4415.x, 0.0)));
    precise float _6807 = _6804.x + _6252;
    precise float _6808 = _6804.y + _6252;
    _36._m0[uint(int(_6197 + 768u) >> int(1u))] = uint16_t(_6786);
    precise float _6816 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_4397.z, 0.0))).x + _5991;
    uint _6819 = (packHalf2x16(vec2(_6791, _6792)) << 16u) + (packHalf2x16(vec2(_6797, _6798)) & 65535u);
    vec2 _6820 = unpackHalf2x16(_6773);
    vec2 _6823 = unpackHalf2x16(852307102u);
    vec2 _6826 = unpackHalf2x16((packHalf2x16(vec2(_6764, _6765)) << 16u) + (_6786 >> 16u));
    uint _6832 = packHalf2x16(vec2(fma(_6820.x, _6823.x, _6826.x), fma(_6820.y, _6823.y, _6826.y)));
    vec2 _6833 = unpackHalf2x16(968374712u);
    precise float _6836 = _6792 * _6833.x;
    precise float _6837 = _6792 * _6833.y;
    precise float _6842 = _6807 * abs(_6807);
    precise float _6843 = _6808 * abs(_6808);
    _36._m0[uint(int(_6197 + 784u) >> int(1u))] = uint16_t(_6832);
    precise float _6853 = _6816 * abs(_6816);
    precise float _6854 = _6816 * abs(_6816);
    vec2 _6860 = unpackHalf2x16((packHalf2x16(vec2(_4433.y, 0.0)) << 16u) + packHalf2x16(vec2(_4433.x, 0.0)));
    precise float _6863 = _6860.x + _6255;
    precise float _6864 = _6860.y + _6255;
    precise float _6867 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_4415.z, 0.0))).x + _6252;
    uint _6870 = (packHalf2x16(vec2(_6842, _6843)) << 16u) + (packHalf2x16(vec2(_6853, _6854)) & 65535u);
    vec2 _6871 = unpackHalf2x16(_6819);
    vec2 _6874 = unpackHalf2x16(852307102u);
    vec2 _6877 = unpackHalf2x16((packHalf2x16(vec2(_6836, _6837)) << 16u) + (_6832 >> 16u));
    uint _6883 = packHalf2x16(vec2(fma(_6871.x, _6874.x, _6877.x), fma(_6871.y, _6874.y, _6877.y)));
    vec2 _6884 = unpackHalf2x16(968374712u);
    precise float _6887 = _6843 * _6884.x;
    precise float _6888 = _6843 * _6884.y;
    precise float _6894 = _6863 * abs(_6863);
    precise float _6895 = _6864 * abs(_6864);
    precise float _6901 = _6867 * abs(_6867);
    precise float _6902 = _6867 * abs(_6867);
    vec2 _6908 = unpackHalf2x16(968374712u);
    precise float _6911 = _6895 * _6908.x;
    precise float _6912 = _6895 * _6908.y;
    uint _6915 = (gl_LocalInvocationID.x >> 3u) * 3u;
    precise float _6918 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_4433.z, 0.0))).x + _6255;
    uint _6921 = (packHalf2x16(vec2(_6894, _6895)) << 16u) + (packHalf2x16(vec2(_6901, _6902)) & 65535u);
    vec2 _6922 = unpackHalf2x16(_6870);
    vec2 _6925 = unpackHalf2x16(852307102u);
    vec2 _6928 = unpackHalf2x16((packHalf2x16(vec2(_6887, _6888)) << 16u) + (_6883 >> 16u));
    uint _6934 = packHalf2x16(vec2(fma(_6922.x, _6925.x, _6928.x), fma(_6922.y, _6925.y, _6928.y)));
    uint _6936 = (gl_LocalInvocationID.x & 7u) * 3u;
    precise float _6939 = _6918 * abs(_6918);
    uint _6944 = (gl_LocalInvocationID.x & 7u) * 6u;
    _36._m0[uint(int(_6197 + 800u) >> int(1u))] = uint16_t(_6883);
    uint _6950 = uint(max(int(0u), int(_6915 + 4294967295u)));
    vec2 _6951 = unpackHalf2x16(_6921);
    vec2 _6954 = unpackHalf2x16(852307102u);
    vec2 _6957 = unpackHalf2x16((packHalf2x16(vec2(_6911, _6912)) << 16u) + (_6934 >> 16u));
    precise float _6961 = fma(_6951.y, _6954.y, _6957.y);
    uint _6972 = ((bitfieldExtract(_6950, int(16u), int(16u)) * 24u) << 16u) + ((bitfieldExtract(_6950, int(0u), int(16u)) * 24u) + _6936);
    uint _6974 = uint(min(int(_6915 + 3u), int(47u)));
    _36._m0[uint(int(_6197 + 832u) >> int(1u))] = uint16_t(packHalf2x16(vec2(fma(_6951.x, _6954.x, _6957.x), _6961)));
    uint _6979 = gl_LocalInvocationID.x >> 3u;
    uint _6987 = ((bitfieldExtract(_6974, int(16u), int(16u)) * 24u) << 16u) + ((bitfieldExtract(_6974, int(0u), int(16u)) * 24u) + _6936);
    uint _6996 = ((bitfieldExtract(_6979, int(16u), int(16u)) * 72u) << 16u) + ((bitfieldExtract(_6979, int(0u), int(16u)) * 72u) + _6936);
    vec2 _7008 = unpackHalf2x16(748563614u);
    _36._m0[uint(int(_6197 + 464u) >> int(1u))] = uint16_t((_6740 & 65535u) + (_6974 & 4294901760u));
    uint _7030 = (((bitfieldExtract(_6979, int(16u), int(16u)) * 144u) << 16u) + ((bitfieldExtract(_6979, int(0u), int(16u)) * 144u) + uint(max(int(0u), int(_6944 + 4294967295u))))) << 1u;
    _36._m0[uint(int(_6197 + 816u) >> int(1u))] = uint16_t((_6934 & 65535u) + (_6979 & 4294901760u));
    _36._m0[uint(int(_6197 + 848u) >> int(1u))] = uint16_t(packHalf2x16(vec2(fma(_6939, _7008.x, _6961), fma(_6939, _7008.y, _6961))));
    uint _7039 = (((bitfieldExtract(_6979, int(16u), int(16u)) * 144u) << 16u) + ((bitfieldExtract(_6979, int(0u), int(16u)) * 144u) + uint(min(int(_6944 + 6u), int(47u))))) << 1u;
    barrier();
    precise float _7046 = c0_1.data[32u] * (-0.125);
    precise float _7049 = c0_1.data[32u] * 0.5;
    uint _7053 = uint(int(_6996 << 2u) >> int(2u));
    uint _7055 = _42._m0[_7053];
    uint _7063 = (packHalf2x16(vec2(_7049, 0.0)) << 16u) + packHalf2x16(vec2(_7046, 0.0));
    uint _7066 = uint(int((_6996 << 2u) + 4u) >> int(2u));
    uint _7068 = _42._m0[_7066];
    uint _7071 = uint(int((_6996 << 2u) + 8u) >> int(2u));
    uint _7073 = _42._m0[_7071];
    uint _7081 = uint(int((_6996 << 2u) + 96u) >> int(2u));
    uint _7083 = _42._m0[_7081];
    uint _7087 = uint(int((_6996 << 2u) + 100u) >> int(2u));
    uint _7089 = _42._m0[_7087];
    uint _7090 = -gl_WorkGroupID.x;
    uint _7112 = uint(int((_6996 << 2u) + 104u) >> int(2u));
    uint _7114 = _42._m0[_7112];
    uint _7117 = min(((((bitfieldExtract(_7090, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(16u), int(16u))) + (bitfieldExtract(_7090, int(16u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u)))) << 16u) + ((bitfieldExtract(_7090, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u))) + c0.data[28u])), c0.data[22u]);
    bool _7123 = _6173 >= _7117;
    uint _7125 = uint(int(_6987 << 2u) >> int(2u));
    uint _7131 = _42._m0[uint(int(_6972 << 2u) >> int(2u))];
    uint _7139 = (_7068 << 16u) + (_7055 >> 16u);
    uint _7144 = _42._m0[uint(int((_6972 << 2u) + 4u) >> int(2u))];
    uint _7147 = (_7073 << 16u) + (_7068 >> 16u);
    vec2 _7148 = unpackHalf2x16(_7139);
    vec2 _7151 = unpackHalf2x16(_7063);
    float _7152 = _7151.x;
    precise float _7153 = _7148.x * _7152;
    precise float _7154 = _7148.y * _7152;
    uint _7166 = uint(int((_6987 << 2u) + 8u) >> int(2u));
    vec2 _7169 = unpackHalf2x16((_7055 << 16u) + (uint(_36._m0[uint(int(_7030) >> int(1u))]) & 65535u));
    vec2 _7172 = unpackHalf2x16(_7063);
    float _7173 = _7172.x;
    vec2 _7178 = unpackHalf2x16(_7083);
    vec2 _7181 = unpackHalf2x16(_7063);
    float _7182 = _7181.x;
    precise float _7183 = _7178.x * _7182;
    precise float _7184 = _7178.y * _7182;
    uint _7189 = uint(int((_6987 << 2u) + 4u) >> int(2u));
    vec2 _7192 = unpackHalf2x16(_7055);
    vec2 _7195 = unpackHalf2x16(_7063);
    float _7196 = _7195.y;
    uint _7204 = uint(int((_6996 << 2u) + 192u) >> int(2u));
    uint _7206 = _42._m0[_7204];
    precise float _7207 = fma(_7192.x, _7196, _7183) + fma(_7169.x, _7173, _7153);
    precise float _7208 = fma(_7192.y, _7196, _7184) + fma(_7169.y, _7173, _7154);
    vec2 _7209 = unpackHalf2x16(_7114);
    vec2 _7212 = unpackHalf2x16(_7063);
    float _7213 = _7212.x;
    precise float _7214 = _7209.x * _7213;
    precise float _7215 = _7209.y * _7213;
    uint _7217 = packHalf2x16(vec2(_7214, _7215));
    uint _7221 = uint(int((_6996 << 2u) + 196u) >> int(2u));
    uint _7223 = _42._m0[_7221];
    vec2 _7224 = unpackHalf2x16(_7147);
    vec2 _7227 = unpackHalf2x16(_7063);
    float _7228 = _7227.x;
    precise float _7229 = _7224.x * _7228;
    precise float _7230 = _7224.y * _7228;
    vec2 _7231 = unpackHalf2x16((uint(_36._m0[uint(int(_7039) >> int(1u))]) << 16u) + (_7073 >> 16u));
    vec2 _7234 = unpackHalf2x16(_7063);
    float _7235 = _7234.x;
    precise float _7236 = _7231.x * _7235;
    precise float _7237 = _7231.y * _7235;
    vec2 _7243 = unpackHalf2x16(_7139);
    vec2 _7246 = unpackHalf2x16(_7063);
    float _7247 = _7246.x;
    vec2 _7253 = unpackHalf2x16(_7089);
    vec2 _7256 = unpackHalf2x16(_7063);
    float _7257 = _7256.x;
    precise float _7258 = _7253.x * _7257;
    precise float _7259 = _7253.y * _7257;
    uint _7261 = packHalf2x16(vec2(_7258, _7259));
    uint _7266 = _42._m0[uint(int((_6972 << 2u) + 8u) >> int(2u))];
    vec2 _7267 = unpackHalf2x16(_7131);
    vec2 _7270 = unpackHalf2x16(_7063);
    float _7271 = _7270.x;
    uint _7276 = -gl_WorkGroupID.y;
    uint _7280 = uint(int((_6996 << 2u) + 200u) >> int(2u));
    vec2 _7302 = unpackHalf2x16(_7068);
    vec2 _7305 = unpackHalf2x16(_7063);
    float _7306 = _7305.y;
    precise float _7315 = fma(_7302.x, _7306, _7258) + fma(_7243.x, _7247, _7229);
    precise float _7316 = fma(_7302.y, _7306, _7259) + fma(_7243.y, _7247, _7230);
    vec2 _7317 = unpackHalf2x16((_7083 << 16u) + (uint(_36._m0[uint(int(_7030 + 96u) >> int(1u))]) & 65535u));
    vec2 _7320 = unpackHalf2x16(_7063);
    float _7321 = _7320.x;
    vec2 _7322 = unpackHalf2x16((_7261 << 16u) + (packHalf2x16(vec2(_7183, _7184)) >> 16u));
    vec2 _7330 = unpackHalf2x16(_7144);
    vec2 _7333 = unpackHalf2x16(_7063);
    float _7334 = _7333.x;
    vec2 _7342 = unpackHalf2x16(_7147);
    vec2 _7345 = unpackHalf2x16(_7063);
    float _7346 = _7345.x;
    vec2 _7349 = unpackHalf2x16((_42._m0[_7125] << 16u) + (uint(_36._m0[uint(int(_7039 + 96u) >> int(1u))]) & 65535u));
    vec2 _7352 = unpackHalf2x16(_7063);
    float _7353 = _7352.x;
    precise float _7354 = _7349.x * _7353;
    precise float _7355 = _7349.y * _7353;
    uint _7357 = packHalf2x16(vec2(_7354, _7355));
    vec2 _7361 = unpackHalf2x16((_7089 << 16u) + (_7083 >> 16u));
    vec2 _7364 = unpackHalf2x16(_7063);
    float _7365 = _7364.x;
    vec2 _7366 = unpackHalf2x16((_7217 << 16u) + (_7261 >> 16u));
    vec2 _7374 = unpackHalf2x16((uint(_36._m0[uint(int(_7039 + 192u) >> int(1u))]) << 16u) + (_42._m0[_7166] >> 16u));
    vec2 _7377 = unpackHalf2x16(_7063);
    float _7378 = _7377.x;
    precise float _7379 = _7374.x * _7378;
    precise float _7380 = _7374.y * _7378;
    uint _7382 = packHalf2x16(vec2(_7379, _7380));
    vec2 _7386 = unpackHalf2x16(_7206);
    vec2 _7389 = unpackHalf2x16(_7063);
    float _7390 = _7389.x;
    precise float _7391 = _7386.x * _7390;
    precise float _7392 = _7386.y * _7390;
    vec2 _7398 = unpackHalf2x16((_42._m0[_7189] << 16u) + (_42._m0[_7125] >> 16u));
    vec2 _7401 = unpackHalf2x16(_7063);
    float _7402 = _7401.x;
    precise float _7403 = _7398.x * _7402;
    precise float _7404 = _7398.y * _7402;
    uint _7406 = packHalf2x16(vec2(_7403, _7404));
    vec2 _7407 = unpackHalf2x16((_7114 << 16u) + (_7089 >> 16u));
    vec2 _7410 = unpackHalf2x16(_7063);
    float _7411 = _7410.x;
    vec2 _7412 = unpackHalf2x16((_7357 << 16u) + (_7217 >> 16u));
    vec2 _7417 = unpackHalf2x16(_7223);
    vec2 _7420 = unpackHalf2x16(_7063);
    float _7421 = _7420.x;
    precise float _7422 = _7417.x * _7421;
    precise float _7423 = _7417.y * _7421;
    uint _7425 = packHalf2x16(vec2(_7422, _7423));
    vec2 _7429 = unpackHalf2x16(_7083);
    vec2 _7432 = unpackHalf2x16(_7063);
    float _7433 = _7432.y;
    vec2 _7439 = unpackHalf2x16(_7073);
    vec2 _7442 = unpackHalf2x16(_7063);
    float _7443 = _7442.y;
    vec2 _7449 = unpackHalf2x16(_7089);
    vec2 _7452 = unpackHalf2x16(_7063);
    float _7453 = _7452.y;
    precise float _7456 = fma(_7439.x, _7443, _7214) + fma(_7342.x, _7346, _7236);
    precise float _7457 = fma(_7439.y, _7443, _7215) + fma(_7342.y, _7346, _7237);
    vec2 _7458 = unpackHalf2x16((_7206 << 16u) + (uint(_36._m0[uint(int(_7030 + 192u) >> int(1u))]) & 65535u));
    vec2 _7461 = unpackHalf2x16(_7063);
    float _7462 = _7461.x;
    vec2 _7463 = unpackHalf2x16((_7425 << 16u) + (packHalf2x16(vec2(_7391, _7392)) >> 16u));
    vec2 _7468 = unpackHalf2x16((_42._m0[_7166] << 16u) + (_42._m0[_7189] >> 16u));
    vec2 _7471 = unpackHalf2x16(_7063);
    float _7472 = _7471.x;
    precise float _7473 = _7468.x * _7472;
    precise float _7474 = _7468.y * _7472;
    uint _7476 = packHalf2x16(vec2(_7473, _7474));
    vec2 _7477 = unpackHalf2x16(_7266);
    vec2 _7480 = unpackHalf2x16(_7063);
    float _7481 = _7480.x;
    uint _7485 = packHalf2x16(vec2(fma(_7477.x, _7481, _7456), fma(_7477.y, _7481, _7457)));
    precise float _7486 = fma(_7449.x, _7453, _7422) + fma(_7361.x, _7365, _7366.x);
    precise float _7487 = fma(_7449.y, _7453, _7423) + fma(_7361.y, _7365, _7366.y);
    vec2 _7491 = unpackHalf2x16(_42._m0[_7280]);
    vec2 _7494 = unpackHalf2x16(_7063);
    float _7495 = _7494.x;
    precise float _7496 = _7491.x * _7495;
    precise float _7497 = _7491.y * _7495;
    uint _7499 = packHalf2x16(vec2(_7496, _7497));
    vec2 _7503 = unpackHalf2x16(_7206);
    vec2 _7506 = unpackHalf2x16(_7063);
    float _7507 = _7506.y;
    vec2 _7508 = unpackHalf2x16((_7406 << 16u) + (_7357 >> 16u));
    vec2 _7513 = unpackHalf2x16(_42._m0[_7280]);
    vec2 _7516 = unpackHalf2x16(_7063);
    float _7517 = _7516.y;
    vec2 _7518 = unpackHalf2x16((_7382 << 16u) + (_7476 >> 16u));
    vec2 _7526 = unpackHalf2x16(_7223);
    vec2 _7529 = unpackHalf2x16(_7063);
    float _7530 = _7529.y;
    vec2 _7531 = unpackHalf2x16((_7476 << 16u) + (_7406 >> 16u));
    vec2 _7539 = unpackHalf2x16(_7068);
    vec2 _7542 = unpackHalf2x16(_7063);
    float _7543 = _7542.x;
    vec2 _7551 = unpackHalf2x16(_7114);
    vec2 _7554 = unpackHalf2x16(_7063);
    float _7555 = _7554.y;
    vec2 _7561 = unpackHalf2x16((_42._m0[_7280] << 16u) + (_7223 >> 16u));
    vec2 _7564 = unpackHalf2x16(_7063);
    float _7565 = _7564.x;
    vec2 _7566 = unpackHalf2x16((_7499 >> 16u) + (_7382 & 4294901760u));
    precise float _7571 = fma(_7429.x, _7433, _7391) + fma(_7317.x, _7321, _7322.x);
    precise float _7572 = fma(_7429.y, _7433, _7392) + fma(_7317.y, _7321, _7322.y);
    vec2 _7573 = unpackHalf2x16((_7223 << 16u) + (_7206 >> 16u));
    vec2 _7576 = unpackHalf2x16(_7063);
    float _7577 = _7576.x;
    vec2 _7578 = unpackHalf2x16((_7499 << 16u) + (_7425 >> 16u));
    precise float _7581 = fma(_7573.x, _7577, _7578.x);
    precise float _7582 = fma(_7573.y, _7577, _7578.y);
    precise float _7585 = fma(_7503.x, _7507, _7508.x) + fma(_7458.x, _7462, _7463.x);
    precise float _7586 = fma(_7503.y, _7507, _7508.y) + fma(_7458.y, _7462, _7463.y);
    precise float _7587 = fma(_7513.x, _7517, _7518.x) + fma(_7561.x, _7565, _7566.x);
    precise float _7588 = fma(_7513.y, _7517, _7518.y) + fma(_7561.y, _7565, _7566.y);
    precise float _7589 = fma(_7526.x, _7530, _7531.x) + _7581;
    precise float _7590 = fma(_7526.y, _7530, _7531.y) + _7582;
    precise float _7591 = fma(_7551.x, _7555, _7496) + fma(_7407.x, _7411, _7412.x);
    precise float _7592 = fma(_7551.y, _7555, _7497) + fma(_7407.y, _7411, _7412.y);
    vec2 _7593 = unpackHalf2x16(_7055);
    vec2 _7596 = unpackHalf2x16(_7063);
    float _7597 = _7596.x;
    vec2 _7602 = unpackHalf2x16(_7083);
    vec2 _7605 = unpackHalf2x16(_7063);
    float _7606 = _7605.x;
    vec2 _7611 = unpackHalf2x16(_7114);
    vec2 _7614 = unpackHalf2x16(_7063);
    float _7615 = _7614.x;
    vec2 _7620 = unpackHalf2x16(_7089);
    vec2 _7623 = unpackHalf2x16(_7063);
    float _7624 = _7623.x;
    vec2 _7629 = unpackHalf2x16(_7073);
    vec2 _7632 = unpackHalf2x16(_7063);
    float _7633 = _7632.x;
    uint _7637 = packHalf2x16(vec2(fma(_7629.x, _7633, _7591), fma(_7629.y, _7633, _7592)));
    barrier();
    _42._m0[uint(int(_6996 << 2u) >> int(2u))] = packHalf2x16(vec2(fma(_7267.x, _7271, _7207), fma(_7267.y, _7271, _7208)));
    uint _7643 = min(((((bitfieldExtract(_7276, int(0u), int(16u)) * bitfieldExtract(c0.data[23u], int(16u), int(16u))) + (bitfieldExtract(_7276, int(16u), int(16u)) * bitfieldExtract(c0.data[23u], int(0u), int(16u)))) << 16u) + ((bitfieldExtract(_7276, int(0u), int(16u)) * bitfieldExtract(c0.data[23u], int(0u), int(16u))) + c0.data[29u])), c0.data[23u]);
    _42._m0[uint(int((_6996 << 2u) + 4u) >> int(2u))] = packHalf2x16(vec2(fma(_7330.x, _7334, _7315), fma(_7330.y, _7334, _7316)));
    _42._m0[uint(int((_6996 << 2u) + 8u) >> int(2u))] = _7485;
    _42._m0[uint(int((_6996 << 2u) + 96u) >> int(2u))] = packHalf2x16(vec2(fma(_7593.x, _7597, _7571), fma(_7593.y, _7597, _7572)));
    _42._m0[uint(int((_6996 << 2u) + 100u) >> int(2u))] = packHalf2x16(vec2(fma(_7539.x, _7543, _7486), fma(_7539.y, _7543, _7487)));
    _42._m0[uint(int((_6996 << 2u) + 104u) >> int(2u))] = _7637;
    _42._m0[uint(int((_6996 << 2u) + 192u) >> int(2u))] = packHalf2x16(vec2(fma(_7602.x, _7606, _7585), fma(_7602.y, _7606, _7586)));
    _42._m0[uint(int((_6996 << 2u) + 196u) >> int(2u))] = packHalf2x16(vec2(fma(_7620.x, _7624, _7589), fma(_7620.y, _7624, _7590)));
    _42._m0[uint(int((_6996 << 2u) + 200u) >> int(2u))] = packHalf2x16(vec2(fma(_7611.x, _7615, _7587), fma(_7611.y, _7615, _7588)));
    uint _7679 = uint(_36._m0[uint(int(_6197) >> int(1u))]);
    bool _7680 = _3866 >= _7643;
    bool _7683 = (_3866 < _7643) && (!_7123);
    uint _7685 = _6173 + 40u;
    uint _7691 = uint(_36._m0[uint(int(_6197 + 16u) >> int(1u))]);
    uint _7696 = uint(_36._m0[uint(int(_6197 + 32u) >> int(1u))]);
    uint _7701 = uint(_36._m0[uint(int(_6197 + 48u) >> int(1u))]);
    uint _7705;
    if (_7683)
    {
        _7705 = c0.data[9u];
    }
    else
    {
        _7705 = c0.data[23u];
    }
    uint _7707;
    if (_7683)
    {
        _7707 = _3966 + _7705;
    }
    else
    {
        _7707 = packHalf2x16(vec2(_7581, _7582));
    }
    uint _7712 = uint(_36._m0[uint(int(_6197 + 64u) >> int(1u))]);
    uint _7717 = uint(_36._m0[uint(int(_6197 + 80u) >> int(1u))]);
    uint _7718 = gl_SubgroupInvocationID & 7u;
    uint _7723 = uint(_36._m0[uint(int(_6197 + 384u) >> int(1u))]);
    uint _7724 = _7718 + 8u;
    uint _7725 = _7718 + 16u;
    bool _7728 = (_7724 < _7117) && (!_7680);
    bool _7731 = (_7725 < _7117) && (!_7680);
    vec2 _7732 = unpackHalf2x16(_7679);
    float _7733 = _7732.x;
    precise float _7734 = _5379 + _7733;
    precise float _7735 = _5380 + _7733;
    uint _7752 = (((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.x, int(16u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u)))) << 16u) + ((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u))) + _7718);
    vec2 _7753 = unpackHalf2x16(_5714);
    float _7754 = _7753.x;
    vec2 _7755 = unpackHalf2x16(_7679);
    float _7756 = _7755.x;
    precise float _7757 = _7754 + _7756;
    precise float _7758 = _7754 + _7756;
    uint _7761;
    if (_7683)
    {
        _7761 = 1065353216u;
    }
    else
    {
        _7761 = _7679;
    }
    bool _7762 = _7725 >= _7117;
    uint _7764;
    if (_7683)
    {
        _7764 = floatBitsToUint(_7734);
    }
    else
    {
        _7764 = gl_SubgroupInvocationID;
    }
    uint _7765 = _7718 + 24u;
    uint _7778 = (bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.x, int(16u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u)));
    vec2 _7781 = unpackHalf2x16(_7691);
    float _7782 = _7781.x;
    precise float _7783 = _5671 + _7782;
    precise float _7784 = _5672 + _7782;
    uint _7789;
    if (_7728)
    {
        _7789 = c0.data[9u];
    }
    else
    {
        _7789 = _7778;
    }
    uint _7791;
    if (_7728)
    {
        _7791 = _3966 + _7789;
    }
    else
    {
        _7791 = _7637;
    }
    vec2 _7792 = unpackHalf2x16(_6285);
    float _7793 = _7792.x;
    vec2 _7794 = unpackHalf2x16(_7691);
    float _7795 = _7794.x;
    precise float _7796 = _7793 + _7795;
    precise float _7797 = _7793 + _7795;
    uint _7801;
    if (_7683)
    {
        _7801 = floatBitsToUint(_7735);
    }
    else
    {
        _7801 = _7691;
    }
    uint _7804;
    if (_7683)
    {
        _7804 = c0.data[8u];
    }
    else
    {
        _7804 = _7789;
    }
    uint _7806;
    if (_7683)
    {
        _7806 = _7752 + _7804;
    }
    else
    {
        _7806 = _6285;
    }
    uint _7808;
    if (_7683)
    {
        _7808 = floatBitsToUint(_7757);
    }
    else
    {
        _7808 = packHalf2x16(vec2(_7734, _7735));
    }
    uint _7811;
    if (_7728)
    {
        _7811 = c0.data[8u];
    }
    else
    {
        _7811 = _7804;
    }
    uint _7813;
    if (_7728)
    {
        _7813 = _3881 + _7811;
    }
    else
    {
        _7813 = _7485;
    }
    uint _7814;
    if (_7728)
    {
        _7814 = 1065353216u;
    }
    else
    {
        _7814 = _5714;
    }
    precise float _7819 = unpackHalf2x16(_6308).x + unpackHalf2x16(_7696).x;
    uint _7821;
    if (_7728)
    {
        _7821 = floatBitsToUint(_7783);
    }
    else
    {
        _7821 = packHalf2x16(vec2(_7757, _7758));
    }
    if (_7683)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_7806, _7707)), uintBitsToFloat(uvec4(_7764, _7801, _7808, _7761)));
    }
    uint _7827;
    if (_7728)
    {
        _7827 = floatBitsToUint(_7784);
    }
    else
    {
        _7827 = _7114;
    }
    bool _7828 = _7724 >= _7117;
    uint _7830;
    if (_7728)
    {
        _7830 = floatBitsToUint(_7796);
    }
    else
    {
        _7830 = packHalf2x16(vec2(_7796, _7797));
    }
    vec2 _7831 = unpackHalf2x16(_7696);
    float _7832 = _7831.x;
    precise float _7833 = _5762 + _7832;
    precise float _7834 = _5763 + _7832;
    uint _7837 = _7718 + 32u;
    vec2 _7838 = unpackHalf2x16(_6330);
    float _7839 = _7838.x;
    vec2 _7840 = unpackHalf2x16(_7701);
    float _7841 = _7840.x;
    precise float _7842 = _7839 + _7841;
    precise float _7843 = _7839 + _7841;
    if (_7728)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_7813, _7791)), uintBitsToFloat(uvec4(_7821, _7827, _7830, _7814)));
    }
    bool _7852 = (_7765 < _7117) && (!_7680);
    vec2 _7853 = unpackHalf2x16(_7717);
    float _7854 = _7853.x;
    precise float _7855 = _6311 + _7854;
    precise float _7856 = _6312 + _7854;
    uint _7859;
    if (_7731)
    {
        _7859 = c0.data[8u];
    }
    else
    {
        _7859 = _7811;
    }
    uint _7861;
    if (_7731)
    {
        _7861 = _3897 + _7859;
    }
    else
    {
        _7861 = packHalf2x16(vec2(_7783, _7784));
    }
    vec2 _7862 = unpackHalf2x16(_6397);
    float _7863 = _7862.x;
    vec2 _7864 = unpackHalf2x16(_7717);
    float _7865 = _7864.x;
    precise float _7866 = _7863 + _7865;
    precise float _7867 = _7863 + _7865;
    uint _7872;
    if (_7731)
    {
        _7872 = c0.data[9u];
    }
    else
    {
        _7872 = _7859;
    }
    uint _7874;
    if (_7731)
    {
        _7874 = _3966 + _7872;
    }
    else
    {
        _7874 = _5765;
    }
    bool _7877 = (_7837 < _7117) && (!_7680);
    bool _7880 = (_7685 < _7117) && (!_7680);
    uint _7882;
    if (_7731)
    {
        _7882 = floatBitsToUint(_7819);
    }
    else
    {
        _7882 = _7808;
    }
    uint _7887 = uint(_36._m0[uint(int(_6197 + 416u) >> int(1u))]);
    uint _7888;
    if (_7731)
    {
        _7888 = 1065353216u;
    }
    else
    {
        _7888 = _7761;
    }
    uint _7890;
    if (_7731)
    {
        _7890 = floatBitsToUint(_7833);
    }
    else
    {
        _7890 = _7764;
    }
    uint _7895 = uint(_36._m0[uint(int(_6197 + 400u) >> int(1u))]);
    uint _7897;
    if (_7731)
    {
        _7897 = floatBitsToUint(_7834);
    }
    else
    {
        _7897 = _7801;
    }
    vec2 _7898 = unpackHalf2x16(_7701);
    float _7899 = _7898.x;
    precise float _7900 = _5832 + _7899;
    precise float _7901 = _5833 + _7899;
    uint _7906;
    if (_7852)
    {
        _7906 = c0.data[8u];
    }
    else
    {
        _7906 = _7872;
    }
    uint _7908;
    if (_7852)
    {
        _7908 = _3913 + _7906;
    }
    else
    {
        _7908 = _5835;
    }
    vec2 _7909 = unpackHalf2x16(_7712);
    float _7910 = _7909.x;
    precise float _7911 = _6123 + _7910;
    precise float _7912 = _6124 + _7910;
    if (_7731)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_7861, _7874)), uintBitsToFloat(uvec4(_7890, _7897, _7882, _7888)));
    }
    uint _7921;
    if (_7852)
    {
        _7921 = c0.data[9u];
    }
    else
    {
        _7921 = _7906;
    }
    uint _7923;
    if (_7852)
    {
        _7923 = _3966 + _7921;
    }
    else
    {
        _7923 = _6126;
    }
    uint _7928 = uint(_36._m0[uint(int(_6197 + 432u) >> int(1u))]);
    bool _7931 = (_3898 < _7643) && (!_7123);
    vec2 _7932 = unpackHalf2x16(_6381);
    float _7933 = _7932.x;
    vec2 _7934 = unpackHalf2x16(_7712);
    float _7935 = _7934.x;
    precise float _7936 = _7933 + _7935;
    precise float _7937 = _7933 + _7935;
    uint _7941;
    if (_7880)
    {
        _7941 = floatBitsToUint(_7856);
    }
    else
    {
        _7941 = packHalf2x16(vec2(_7833, _7834));
    }
    uint _7944;
    if (_7877)
    {
        _7944 = c0.data[9u];
    }
    else
    {
        _7944 = _7921;
    }
    uint _7946;
    if (_7877)
    {
        _7946 = _3966 + _7944;
    }
    else
    {
        _7946 = _7707;
    }
    uint _7947;
    if (_7877)
    {
        _7947 = 1065353216u;
    }
    else
    {
        _7947 = _7814;
    }
    uint _7950;
    if (_7877)
    {
        _7950 = c0.data[8u];
    }
    else
    {
        _7950 = _7944;
    }
    uint _7952;
    if (_7877)
    {
        _7952 = _3934 + _7950;
    }
    else
    {
        _7952 = _7806;
    }
    uint _7954;
    if (_7877)
    {
        _7954 = floatBitsToUint(_7936);
    }
    else
    {
        _7954 = packHalf2x16(vec2(_7936, _7937));
    }
    bool _7957 = (_3950 < _7643) && (!_7123);
    uint _7958;
    if (_7880)
    {
        _7958 = 1065353216u;
    }
    else
    {
        _7958 = _6381;
    }
    uint _7960;
    if (_7880)
    {
        _7960 = floatBitsToUint(_7866);
    }
    else
    {
        _7960 = packHalf2x16(vec2(_7866, _7867));
    }
    uint _7963;
    if (_7931)
    {
        _7963 = c0.data[8u];
    }
    else
    {
        _7963 = _7950;
    }
    uint _7965;
    if (_7931)
    {
        _7965 = _7752 + _7963;
    }
    else
    {
        _7965 = _6397;
    }
    uint _7967;
    if (_7852)
    {
        _7967 = floatBitsToUint(_7900);
    }
    else
    {
        _7967 = _7890;
    }
    uint _7970;
    if (_7880)
    {
        _7970 = c0.data[9u];
    }
    else
    {
        _7970 = _7963;
    }
    uint _7972;
    if (_7880)
    {
        _7972 = _3966 + _7970;
    }
    else
    {
        _7972 = _7874;
    }
    uint _7973;
    if (_7852)
    {
        _7973 = 1065353216u;
    }
    else
    {
        _7973 = _7888;
    }
    uint _7976 = ((_7778 << 16u) + ((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u))) + (_6173 + 40u))) + c0.data[8u];
    uint _7978;
    if (_7852)
    {
        _7978 = floatBitsToUint(_7901);
    }
    else
    {
        _7978 = _7897;
    }
    uint _7980;
    if (_7852)
    {
        _7980 = floatBitsToUint(_7842);
    }
    else
    {
        _7980 = _7882;
    }
    uint _7982;
    if (_7877)
    {
        _7982 = floatBitsToUint(_7911);
    }
    else
    {
        _7982 = packHalf2x16(vec2(_7900, _7901));
    }
    if (_7852)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_7908, _7923)), uintBitsToFloat(uvec4(_7967, _7978, _7980, _7973)));
    }
    uint _7988;
    if (_7880)
    {
        _7988 = floatBitsToUint(_7855);
    }
    else
    {
        _7988 = packHalf2x16(vec2(_7842, _7843));
    }
    vec2 _7989 = unpackHalf2x16(_7723);
    float _7990 = _7989.x;
    precise float _7991 = _5300 + _7990;
    precise float _7992 = _5301 + _7990;
    uint _7996;
    if (_7877)
    {
        _7996 = floatBitsToUint(_7912);
    }
    else
    {
        _7996 = packHalf2x16(vec2(_7911, _7912));
    }
    precise float _8001 = unpackHalf2x16(_6429).x + unpackHalf2x16(_7723).x;
    uint _8014 = (bitfieldExtract(gl_WorkGroupID.y, int(0u), int(16u)) * bitfieldExtract(c0.data[23u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.y, int(16u), int(16u)) * bitfieldExtract(c0.data[23u], int(0u), int(16u)));
    uint _8016 = (_8014 << 16u) + ((bitfieldExtract(gl_WorkGroupID.y, int(0u), int(16u)) * bitfieldExtract(c0.data[23u], int(0u), int(16u))) + _3898);
    vec2 _8017 = unpackHalf2x16(_7895);
    float _8018 = _8017.x;
    precise float _8019 = _5838 + _8018;
    precise float _8020 = _5839 + _8018;
    if (_7877)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_7952, _7946)), uintBitsToFloat(uvec4(_7982, _7996, _7954, _7947)));
    }
    bool _8029 = (_3898 < _7643) && (!_7828);
    uint _8030;
    if (_7931)
    {
        _8030 = 1065353216u;
    }
    else
    {
        _8030 = _5303;
    }
    uint _8033;
    if (_7931)
    {
        _8033 = c0.data[9u];
    }
    else
    {
        _8033 = _8014;
    }
    uint _8035;
    if (_7931)
    {
        _8035 = _8016 + _8033;
    }
    else
    {
        _8035 = _6429;
    }
    if (_7880)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_7976, _7972)), uintBitsToFloat(uvec4(_7988, _7941, _7960, _7958)));
    }
    precise float _8044 = unpackHalf2x16(_6457).x + unpackHalf2x16(_7895).x;
    bool _8045 = _7765 >= _7117;
    vec2 _8046 = unpackHalf2x16(_7887);
    float _8047 = _8046.x;
    precise float _8048 = _5941 + _8047;
    precise float _8049 = _5942 + _8047;
    bool _8052 = _7837 >= _7117;
    vec2 _8053 = unpackHalf2x16(_6503);
    float _8054 = _8053.x;
    vec2 _8055 = unpackHalf2x16(_7887);
    float _8056 = _8055.x;
    precise float _8057 = _8054 + _8056;
    precise float _8058 = _8054 + _8056;
    bool _8063 = (_3950 < _7643) && (!_7828);
    vec2 _8064 = unpackHalf2x16(_7928);
    float _8065 = _8064.x;
    precise float _8066 = _6149 + _8065;
    precise float _8067 = _6150 + _8065;
    uint _8072 = uint(_36._m0[uint(int(_6197 + 448u) >> int(1u))]);
    uint _8074;
    if (_7931)
    {
        _8074 = floatBitsToUint(_7991);
    }
    else
    {
        _8074 = _7908;
    }
    uint _8077;
    if (_8029)
    {
        _8077 = c0.data[8u];
    }
    else
    {
        _8077 = _8033;
    }
    uint _8079;
    if (_8029)
    {
        _8079 = _3881 + _8077;
    }
    else
    {
        _8079 = _7980;
    }
    uint _8081;
    if (_7931)
    {
        _8081 = floatBitsToUint(_7992);
    }
    else
    {
        _8081 = _7923;
    }
    uint _8084;
    if (_8029)
    {
        _8084 = c0.data[9u];
    }
    else
    {
        _8084 = _8077;
    }
    uint _8086;
    if (_8029)
    {
        _8086 = _8016 + _8084;
    }
    else
    {
        _8086 = _7973;
    }
    uint _8088;
    if (_7931)
    {
        _8088 = floatBitsToUint(_8001);
    }
    else
    {
        _8088 = packHalf2x16(vec2(_7991, _7992));
    }
    precise float _8093 = unpackHalf2x16(_6530).x + unpackHalf2x16(_7928).x;
    uint _8098 = uint(_36._m0[uint(int(_6197 + 800u) >> int(1u))]);
    if (_7931)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_7965, _8035)), uintBitsToFloat(uvec4(_8074, _8081, _8088, _8030)));
    }
    bool _8105 = (_3898 < _7643) && (!_7762);
    uint _8110 = uint(_36._m0[uint(int(_6197 + 784u) >> int(1u))]);
    bool _8113 = (_3950 < _7643) && (!_7762);
    uint _8116;
    if (_8063)
    {
        _8116 = c0.data[8u];
    }
    else
    {
        _8116 = _8084;
    }
    uint _8118;
    if (_8063)
    {
        _8118 = _3881 + _8116;
    }
    else
    {
        _8118 = _7988;
    }
    uint _8123 = uint(_36._m0[uint(int(_6197 + 832u) >> int(1u))]);
    uint _8126;
    if (_8105)
    {
        _8126 = c0.data[8u];
    }
    else
    {
        _8126 = _8116;
    }
    uint _8128;
    if (_8105)
    {
        _8128 = _3897 + _8126;
    }
    else
    {
        _8128 = _7982;
    }
    uint _8131;
    if (_8105)
    {
        _8131 = c0.data[9u];
    }
    else
    {
        _8131 = _8126;
    }
    uint _8133;
    if (_8105)
    {
        _8133 = _8016 + _8131;
    }
    else
    {
        _8133 = _7996;
    }
    uint _8134;
    if (_8029)
    {
        _8134 = 1065353216u;
    }
    else
    {
        _8134 = _8030;
    }
    uint _8136;
    if (_8029)
    {
        _8136 = floatBitsToUint(_8019);
    }
    else
    {
        _8136 = _8074;
    }
    uint _8138;
    if (_8029)
    {
        _8138 = floatBitsToUint(_8020);
    }
    else
    {
        _8138 = _8081;
    }
    uint _8140;
    if (_8029)
    {
        _8140 = floatBitsToUint(_8044);
    }
    else
    {
        _8140 = _8088;
    }
    if (_8029)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_8079, _8086)), uintBitsToFloat(uvec4(_8136, _8138, _8140, _8134)));
    }
    bool _8147 = (_3898 < _7643) && (!_8045);
    vec2 _8148 = unpackHalf2x16(_8072);
    float _8149 = _8148.x;
    precise float _8150 = _6512 + _8149;
    precise float _8151 = _6513 + _8149;
    bool _8156 = (_3950 < _7643) && (!_8045);
    precise float _8161 = unpackHalf2x16(_6625).x + unpackHalf2x16(_8072).x;
    uint _8166 = uint(_36._m0[uint(int(_6197 + 816u) >> int(1u))]);
    vec2 _8167 = unpackHalf2x16(_8098);
    float _8168 = _8167.x;
    precise float _8169 = _6743 + _8168;
    precise float _8170 = _6744 + _8168;
    precise float _8175 = unpackHalf2x16(_6819).x + unpackHalf2x16(_8098).x;
    vec2 _8176 = unpackHalf2x16(_8110);
    float _8177 = _8176.x;
    precise float _8178 = _6646 + _8177;
    precise float _8179 = _6647 + _8177;
    uint _8182;
    if (_8147)
    {
        _8182 = c0.data[8u];
    }
    else
    {
        _8182 = _8131;
    }
    uint _8184;
    if (_8147)
    {
        _8184 = _3913 + _8182;
    }
    else
    {
        _8184 = packHalf2x16(vec2(_8019, _8020));
    }
    vec2 _8185 = unpackHalf2x16(_8123);
    float _8186 = _8185.x;
    precise float _8187 = _6842 + _8186;
    precise float _8188 = _6843 + _8186;
    uint _8191;
    if (_8156)
    {
        _8191 = c0.data[8u];
    }
    else
    {
        _8191 = _8182;
    }
    uint _8193;
    if (_8156)
    {
        _8193 = _3913 + _8191;
    }
    else
    {
        _8193 = _3913;
    }
    precise float _8198 = unpackHalf2x16(_6921).x + unpackHalf2x16(_8123).x;
    uint _8199;
    if (_8105)
    {
        _8199 = 1065353216u;
    }
    else
    {
        _8199 = _8134;
    }
    uint _8201;
    if (_8105)
    {
        _8201 = floatBitsToUint(_8048);
    }
    else
    {
        _8201 = _8136;
    }
    uint _8203;
    if (_8105)
    {
        _8203 = floatBitsToUint(_8049);
    }
    else
    {
        _8203 = _8138;
    }
    uint _8206;
    if (_8147)
    {
        _8206 = c0.data[9u];
    }
    else
    {
        _8206 = _8191;
    }
    uint _8208;
    if (_8147)
    {
        _8208 = _8016 + _8206;
    }
    else
    {
        _8208 = packHalf2x16(vec2(_8048, _8049));
    }
    uint _8210;
    if (_8105)
    {
        _8210 = floatBitsToUint(_8057);
    }
    else
    {
        _8210 = _8140;
    }
    uint _8213;
    if (_8113)
    {
        _8213 = c0.data[8u];
    }
    else
    {
        _8213 = _8206;
    }
    uint _8215;
    if (_8113)
    {
        _8215 = _3897 + _8213;
    }
    else
    {
        _8215 = packHalf2x16(vec2(_8057, _8058));
    }
    if (_8105)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_8128, _8133)), uintBitsToFloat(uvec4(_8201, _8203, _8210, _8199)));
    }
    bool _8222 = (_3898 < _7643) && (!_8052);
    bool _8225 = (_3950 < _7643) && (!_8052);
    uint _8228;
    if (_8222)
    {
        _8228 = c0.data[8u];
    }
    else
    {
        _8228 = _8213;
    }
    uint _8230;
    if (_8222)
    {
        _8230 = _3934 + _8228;
    }
    else
    {
        _8230 = _8079;
    }
    uint _8233;
    if (_8222)
    {
        _8233 = c0.data[9u];
    }
    else
    {
        _8233 = _8228;
    }
    uint _8235;
    if (_8222)
    {
        _8235 = _8016 + _8233;
    }
    else
    {
        _8235 = _8086;
    }
    vec2 _8236 = unpackHalf2x16(_8166);
    float _8237 = _8236.x;
    precise float _8238 = _6791 + _8237;
    precise float _8239 = _6792 + _8237;
    uint _8242;
    if (_8225)
    {
        _8242 = c0.data[8u];
    }
    else
    {
        _8242 = _8233;
    }
    uint _8244;
    if (_8225)
    {
        _8244 = _3934 + _8242;
    }
    else
    {
        _8244 = _7960;
    }
    precise float _8249 = unpackHalf2x16(_6870).x + unpackHalf2x16(_8166).x;
    uint _8250;
    if (_8147)
    {
        _8250 = 1065353216u;
    }
    else
    {
        _8250 = _8199;
    }
    uint _8253;
    if (_7957)
    {
        _8253 = c0.data[8u];
    }
    else
    {
        _8253 = _8242;
    }
    uint _8255;
    if (_7957)
    {
        _8255 = _7752 + _8253;
    }
    else
    {
        _8255 = _8128;
    }
    uint _8257;
    if (_8147)
    {
        _8257 = floatBitsToUint(_8066);
    }
    else
    {
        _8257 = _8201;
    }
    uint _8259;
    if (_8147)
    {
        _8259 = floatBitsToUint(_8067);
    }
    else
    {
        _8259 = _8203;
    }
    uint _8261;
    if (_8147)
    {
        _8261 = floatBitsToUint(_8093);
    }
    else
    {
        _8261 = _8210;
    }
    if (_8147)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_8184, _8208)), uintBitsToFloat(uvec4(_8257, _8259, _8261, _8250)));
    }
    bool _8281 = _7685 >= _7117;
    uint _8284 = ((((bitfieldExtract(gl_WorkGroupID.y, int(0u), int(16u)) * bitfieldExtract(c0.data[23u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.y, int(16u), int(16u)) * bitfieldExtract(c0.data[23u], int(0u), int(16u)))) << 16u) + ((bitfieldExtract(gl_WorkGroupID.y, int(0u), int(16u)) * bitfieldExtract(c0.data[23u], int(0u), int(16u))) + _3950)) + c0.data[9u];
    uint _8286;
    if (_8222)
    {
        _8286 = floatBitsToUint(_8161);
    }
    else
    {
        _8286 = _8261;
    }
    uint _8291 = uint(_36._m0[uint(int(_6197 + 464u) >> int(1u))]);
    uint _8292;
    if (_8222)
    {
        _8292 = 1065353216u;
    }
    else
    {
        _8292 = _8250;
    }
    uint _8294;
    if (_8222)
    {
        _8294 = floatBitsToUint(_8150);
    }
    else
    {
        _8294 = _8257;
    }
    uint _8299 = uint(_36._m0[uint(int(_6197 + 768u) >> int(1u))]);
    uint _8301;
    if (_8222)
    {
        _8301 = floatBitsToUint(_8151);
    }
    else
    {
        _8301 = _8259;
    }
    uint _8306 = uint(_36._m0[uint(int(_6197 + 848u) >> int(1u))]);
    if (_8222)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_8230, _8235)), uintBitsToFloat(uvec4(_8294, _8301, _8286, _8292)));
    }
    bool _8313 = (_3898 < _7643) && (!_8281);
    uint _8317;
    if (_8313)
    {
        _8317 = 1065353216u;
    }
    else
    {
        _8317 = packHalf2x16(vec2(_8150, _8151));
    }
    vec2 _8318 = unpackHalf2x16(_6773);
    float _8319 = _8318.x;
    vec2 _8320 = unpackHalf2x16(_8110);
    float _8321 = _8320.x;
    precise float _8322 = _8319 + _8321;
    precise float _8323 = _8319 + _8321;
    uint _8328;
    if (_8313)
    {
        _8328 = c0.data[9u];
    }
    else
    {
        _8328 = c0.data[9u];
    }
    uint _8330;
    if (_8313)
    {
        _8330 = _8016 + _8328;
    }
    else
    {
        _8330 = _8110;
    }
    uint _8331;
    if (_7957)
    {
        _8331 = 1065353216u;
    }
    else
    {
        _8331 = _8235;
    }
    uint _8332;
    if (_8063)
    {
        _8332 = 1065353216u;
    }
    else
    {
        _8332 = _8292;
    }
    uint _8334;
    if (_8063)
    {
        _8334 = floatBitsToUint(_8178);
    }
    else
    {
        _8334 = _8294;
    }
    uint _8336;
    if (_8063)
    {
        _8336 = floatBitsToUint(_8179);
    }
    else
    {
        _8336 = _8301;
    }
    uint _8338;
    if (_8063)
    {
        _8338 = floatBitsToUint(_8322);
    }
    else
    {
        _8338 = packHalf2x16(vec2(_8322, _8323));
    }
    vec2 _8339 = unpackHalf2x16(_8291);
    float _8340 = _8339.x;
    precise float _8341 = _6596 + _8340;
    precise float _8342 = _6597 + _8340;
    vec2 _8343 = unpackHalf2x16(_6682);
    float _8344 = _8343.x;
    vec2 _8345 = unpackHalf2x16(_8291);
    float _8346 = _8345.x;
    precise float _8347 = _8344 + _8346;
    precise float _8348 = _8344 + _8346;
    vec2 _8351 = unpackHalf2x16(_8299);
    float _8352 = _8351.x;
    precise float _8353 = _6655 + _8352;
    precise float _8354 = _6656 + _8352;
    uint _8356;
    if (_8313)
    {
        _8356 = floatBitsToUint(_8341);
    }
    else
    {
        _8356 = _8291;
    }
    vec2 _8357 = unpackHalf2x16(_6692);
    float _8358 = _8357.x;
    vec2 _8359 = unpackHalf2x16(_8299);
    float _8360 = _8359.x;
    precise float _8361 = _8358 + _8360;
    precise float _8362 = _8358 + _8360;
    uint _8366;
    if (_8313)
    {
        _8366 = floatBitsToUint(_8347);
    }
    else
    {
        _8366 = packHalf2x16(vec2(_8347, _8348));
    }
    vec2 _8367 = unpackHalf2x16(_8306);
    float _8368 = _8367.x;
    precise float _8369 = _6894 + _8368;
    precise float _8370 = _6895 + _8368;
    uint _8372;
    if (_8313)
    {
        _8372 = floatBitsToUint(_8342);
    }
    else
    {
        _8372 = _8208;
    }
    precise float _8375 = _6939 + unpackHalf2x16(_8306).x;
    uint _8377;
    if (_7957)
    {
        _8377 = floatBitsToUint(_8353);
    }
    else
    {
        _8377 = _8299;
    }
    uint _8379;
    if (_7957)
    {
        _8379 = floatBitsToUint(_8354);
    }
    else
    {
        _8379 = _7978;
    }
    if (_8313)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_7976, _8330)), uintBitsToFloat(uvec4(_8356, _8372, _8366, _8317)));
    }
    uint _8385;
    if (_7957)
    {
        _8385 = floatBitsToUint(_8361);
    }
    else
    {
        _8385 = packHalf2x16(vec2(_8361, _8362));
    }
    if (_7957)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_8255, _8284)), uintBitsToFloat(uvec4(_8377, _8379, _8385, _8331)));
    }
    if (_8063)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_8118, _8284)), uintBitsToFloat(uvec4(_8334, _8336, _8338, _8332)));
    }
    uint _8394;
    if (_8113)
    {
        _8394 = 1065353216u;
    }
    else
    {
        _8394 = _8317;
    }
    uint _8396;
    if (_8113)
    {
        _8396 = floatBitsToUint(_8169);
    }
    else
    {
        _8396 = _8356;
    }
    uint _8398;
    if (_8113)
    {
        _8398 = floatBitsToUint(_8170);
    }
    else
    {
        _8398 = _8372;
    }
    uint _8400;
    if (_8113)
    {
        _8400 = floatBitsToUint(_8175);
    }
    else
    {
        _8400 = _8366;
    }
    uint _8401;
    if (_8156)
    {
        _8401 = 1065353216u;
    }
    else
    {
        _8401 = _8332;
    }
    uint _8403;
    if (_8156)
    {
        _8403 = floatBitsToUint(_8238);
    }
    else
    {
        _8403 = _8334;
    }
    if (_8113)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_8215, _8284)), uintBitsToFloat(uvec4(_8396, _8398, _8400, _8394)));
    }
    uint _8409;
    if (_8156)
    {
        _8409 = floatBitsToUint(_8239);
    }
    else
    {
        _8409 = _8336;
    }
    uint _8411;
    if (_8156)
    {
        _8411 = floatBitsToUint(_8249);
    }
    else
    {
        _8411 = _8338;
    }
    uint _8412;
    if (_8225)
    {
        _8412 = 1065353216u;
    }
    else
    {
        _8412 = _8331;
    }
    uint _8414;
    if (_8225)
    {
        _8414 = floatBitsToUint(_8187);
    }
    else
    {
        _8414 = _8377;
    }
    if (_8156)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_8193, _8284)), uintBitsToFloat(uvec4(_8403, _8409, _8411, _8401)));
    }
    uint _8420;
    if (_8225)
    {
        _8420 = floatBitsToUint(_8188);
    }
    else
    {
        _8420 = _8379;
    }
    uint _8422;
    if (_8225)
    {
        _8422 = floatBitsToUint(_8198);
    }
    else
    {
        _8422 = _8385;
    }
    if (_8225)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_8244, _8284)), uintBitsToFloat(uvec4(_8414, _8420, _8422, _8412)));
    }
    if (!((_3950 < _7643) && (!_8281)))
    {
        return;
    }
    imageStore(cs_img0_d0, ivec2(uvec2(_7976, _8284)), uintBitsToFloat(uvec4(floatBitsToUint(_8369), floatBitsToUint(_8370), floatBitsToUint(_8375), 1065353216u)));
}

