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
    uint _627 = gl_LocalInvocationID.x >> 5u;
    uint _628 = gl_SubgroupInvocationID & 3u;
    uint _630 = _627 << 2u;
    uint _631 = gl_SubgroupInvocationID >> 2u;
    uint _632 = _628 << 1u;
    uint _641 = ((bitfieldExtract(_627, int(16u), int(16u)) * 8u) << 16u) + ((bitfieldExtract(_627, int(0u), int(16u)) * 8u) + _631);
    uint _650 = ((bitfieldExtract(gl_WorkGroupID.x, int(16u), int(16u)) * 16u) << 16u) + ((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * 16u) + _632);
    uint _651 = (_630 + 1u) >> 2u;
    uint _659 = (_630 + 2u) >> 2u;
    uint _660 = (_630 + 3u) >> 2u;
    uint _667 = ((bitfieldExtract(_651, int(16u), int(16u)) * 8u) << 16u) + ((bitfieldExtract(_651, int(0u), int(16u)) * 8u) + _631);
    uint _676 = ((bitfieldExtract(_659, int(16u), int(16u)) * 8u) << 16u) + ((bitfieldExtract(_659, int(0u), int(16u)) * 8u) + _631);
    uint _685 = ((bitfieldExtract(_660, int(16u), int(16u)) * 8u) << 16u) + ((bitfieldExtract(_660, int(0u), int(16u)) * 8u) + _631);
    uint _729 = uint(min(int(uint(max(int(0u), int((((bitfieldExtract(gl_WorkGroupID.y, int(16u), int(16u)) * 16u) << 16u) + ((bitfieldExtract(gl_WorkGroupID.y, int(0u), int(16u)) * 16u) + _641)) + 4294967290u)))), int(c0.data[7u])));
    vec4 _744 = texelFetch(cs_tex0_c0, ivec2(uvec2(uint(min(int(uint(max(int(0u), int(_650 + 4294967290u)))), int(c0.data[6u]))), _729)), int(0u));
    vec4 _751 = texelFetch(cs_tex0_c0, ivec2(uvec2(uint(min(int(uint(max(int(0u), int(_650 + 4294967291u)))), int(c0.data[6u]))), _729)), int(0u));
    uint _760 = uint(min(int(uint(max(int(0u), int((((bitfieldExtract(gl_WorkGroupID.y, int(16u), int(16u)) * 16u) << 16u) + ((bitfieldExtract(gl_WorkGroupID.y, int(0u), int(16u)) * 16u) + _667)) + 4294967290u)))), int(c0.data[7u])));
    vec4 _765 = texelFetch(cs_tex0_c0, ivec2(uvec2(uint(min(int(uint(max(int(0u), int(_650 + 2u)))), int(c0.data[6u]))), _760)), int(0u));
    vec4 _772 = texelFetch(cs_tex0_c0, ivec2(uvec2(uint(min(int(uint(max(int(0u), int(_650 + 3u)))), int(c0.data[6u]))), _760)), int(0u));
    uint _792 = uint(min(int(uint(max(int(0u), int((((bitfieldExtract(gl_WorkGroupID.y, int(16u), int(16u)) * 16u) << 16u) + ((bitfieldExtract(gl_WorkGroupID.y, int(0u), int(16u)) * 16u) + _676)) + 4294967290u)))), int(c0.data[7u])));
    uint _798 = uint(min(int(uint(max(int(0u), int((((bitfieldExtract(gl_WorkGroupID.y, int(16u), int(16u)) * 16u) << 16u) + ((bitfieldExtract(gl_WorkGroupID.y, int(0u), int(16u)) * 16u) + _685)) + 4294967290u)))), int(c0.data[7u])));
    vec4 _802 = texelFetch(cs_tex0_c0, ivec2(uvec2(uint(min(int(uint(max(int(0u), int(_650 + 10u)))), int(c0.data[6u]))), _792)), int(0u));
    vec4 _809 = texelFetch(cs_tex0_c0, ivec2(uvec2(uint(min(int(uint(max(int(0u), int(_650 + 11u)))), int(c0.data[6u]))), _792)), int(0u));
    vec4 _816 = texelFetch(cs_tex0_c0, ivec2(uvec2(uint(min(int(uint(max(int(0u), int(_650 + 18u)))), int(c0.data[6u]))), _798)), int(0u));
    vec4 _823 = texelFetch(cs_tex0_c0, ivec2(uvec2(uint(min(int(uint(max(int(0u), int(_650 + 19u)))), int(c0.data[6u]))), _798)), int(0u));
    uint _831 = (gl_SubgroupInvocationID << 4u) + c0.data[44u];
    uint _855 = ((_831 + 1024u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec4 _857 = ssbo0_3._m0[_855];
    uint _866 = (_831 - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec4 _868 = ssbo0_3._m0[_866];
    uint _879 = ((_831 + 512u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec4 _881 = ssbo0_3._m0[_879];
    uint _892 = ((_831 + 1536u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec4 _894 = ssbo0_3._m0[_892];
    uint _905 = ((_831 + 2048u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec4 _907 = ssbo0_3._m0[_905];
    precise float _914 = _744.y * 0.715200006961822509765625;
    precise float _915 = _751.y * 0.715200006961822509765625;
    precise float _920 = _765.y * 0.715200006961822509765625;
    precise float _921 = _772.y * 0.715200006961822509765625;
    _42._m0[uint(int((((bitfieldExtract(_641, int(16u), int(16u)) * 40u) << 16u) + ((bitfieldExtract(_641, int(0u), int(16u)) * 40u) + _632)) << 1u) >> int(2u))] = (packHalf2x16(vec2(fma(_751.z, 0.072200000286102294921875, fma(_751.x, 0.2125999927520751953125, _915)), 0.0)) << 16u) + packHalf2x16(vec2(fma(_744.z, 0.072200000286102294921875, fma(_744.x, 0.2125999927520751953125, _914)), 0.0));
    uint _950 = ((_831 + 2560u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec4 _952 = ssbo0_3._m0[_950];
    _42._m0[uint(int(((((bitfieldExtract(_667, int(16u), int(16u)) * 40u) << 16u) + ((bitfieldExtract(_667, int(0u), int(16u)) * 40u) + _632)) << 1u) + 16u) >> int(2u))] = (packHalf2x16(vec2(fma(_772.z, 0.072200000286102294921875, fma(_772.x, 0.2125999927520751953125, _921)), 0.0)) << 16u) + packHalf2x16(vec2(fma(_765.z, 0.072200000286102294921875, fma(_765.x, 0.2125999927520751953125, _920)), 0.0));
    uint _980 = ((_831 + 3072u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec4 _982 = ssbo0_3._m0[_980];
    precise float _987 = _802.y * 0.715200006961822509765625;
    precise float _988 = _809.y * 0.715200006961822509765625;
    precise float _989 = _816.y * 0.715200006961822509765625;
    precise float _990 = _823.y * 0.715200006961822509765625;
    _42._m0[uint(int(((((bitfieldExtract(_676, int(16u), int(16u)) * 40u) << 16u) + ((bitfieldExtract(_676, int(0u), int(16u)) * 40u) + _632)) << 1u) + 32u) >> int(2u))] = (packHalf2x16(vec2(fma(_809.z, 0.072200000286102294921875, fma(_809.x, 0.2125999927520751953125, _988)), 0.0)) << 16u) + packHalf2x16(vec2(fma(_802.z, 0.072200000286102294921875, fma(_802.x, 0.2125999927520751953125, _987)), 0.0));
    _42._m0[uint(int(((((bitfieldExtract(_685, int(16u), int(16u)) * 40u) << 16u) + ((bitfieldExtract(_685, int(0u), int(16u)) * 40u) + _632)) << 1u) + 48u) >> int(2u))] = (packHalf2x16(vec2(fma(_823.z, 0.072200000286102294921875, fma(_823.x, 0.2125999927520751953125, _990)), 0.0)) << 16u) + packHalf2x16(vec2(fma(_816.z, 0.072200000286102294921875, fma(_816.x, 0.2125999927520751953125, _989)), 0.0));
    uint _1035 = (((bitfieldExtract(_631, int(16u), int(16u)) * 40u) << 16u) + ((bitfieldExtract(_631, int(0u), int(16u)) * 40u) + (((bitfieldExtract(_627, int(16u), int(16u)) * 4u) << 16u) + ((bitfieldExtract(_627, int(0u), int(16u)) * 4u) + _632)))) << 1u;
    barrier();
    uint _1043 = ((_831 + 3584u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec4 _1045 = ssbo0_3._m0[_1043];
    uint _1056 = ((_831 + 4096u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec4 _1058 = ssbo0_3._m0[_1056];
    uint _1064 = uint(int(_1035 + 1280u) >> int(2u));
    uint _1066 = _42._m0[_1064];
    uint _1069 = uint(int(_1035 + 1296u) >> int(2u));
    uint _1071 = _42._m0[_1069];
    uint _1073 = uint(int(_1035 + 640u) >> int(2u));
    uint _1075 = _42._m0[_1073];
    uint _1078 = uint(int(_1035 + 656u) >> int(2u));
    uint _1080 = _42._m0[_1078];
    uint _1081 = uint(int(_1035) >> int(2u));
    uint _1083 = _42._m0[_1081];
    uint _1085 = uint(int(_1035 + 16u) >> int(2u));
    uint _1087 = _42._m0[_1085];
    uint _1089 = uint(int(_1035 + 320u) >> int(2u));
    uint _1091 = _42._m0[_1089];
    uint _1094 = uint(int(_1035 + 336u) >> int(2u));
    uint _1096 = _42._m0[_1094];
    uint _1099 = uint(int(_1035 + 960u) >> int(2u));
    uint _1101 = _42._m0[_1099];
    uint _1104 = uint(int(_1035 + 976u) >> int(2u));
    uint _1106 = _42._m0[_1104];
    uint _1109 = uint(int(_1035 + 1600u) >> int(2u));
    uint _1111 = _42._m0[_1109];
    uint _1114 = uint(int(_1035 + 1616u) >> int(2u));
    uint _1116 = _42._m0[_1114];
    barrier();
    uvec2 _1120 = _84(uvec4(_857), uvec2(_1066, _1071), uvec2(0u));
    uint _1121 = _1120.x;
    uvec2 _1126 = _84(uvec4(_857), uvec2(_1075, _1080), uvec2(0u));
    uint _1127 = _1126.x;
    uvec2 _1132 = _84(uvec4(_868), uvec2(_1075, _1080), uvec2(0u));
    uint _1133 = _1132.x;
    uvec2 _1138 = _84(uvec4(_857), uvec2(_1083, _1087), uvec2(0u));
    uint _1139 = _1138.x;
    uvec2 _1144 = _84(uvec4(_868), uvec2(_1083, _1087), uvec2(0u));
    uint _1145 = _1144.x;
    uvec2 _1150 = _84(uvec4(_857), uvec2(_1091, _1096), uvec2(0u));
    uint _1151 = _1150.x;
    uvec2 _1156 = _84(uvec4(_857), uvec2(_1101, _1106), uvec2(0u));
    uint _1157 = _1156.x;
    uvec2 _1162 = _84(uvec4(_868), uvec2(_1066, _1071), uvec2(0u));
    uint _1163 = _1162.x;
    uvec2 _1168 = _84(uvec4(_868), uvec2(_1091, _1096), uvec2(0u));
    uint _1169 = _1168.x;
    uvec2 _1174 = _84(uvec4(_868), uvec2(_1101, _1106), uvec2(0u));
    uint _1175 = _1174.x;
    uvec2 _1180 = _84(uvec4(_868), uvec2(_1111, _1116), uvec2(0u));
    uint _1181 = _1180.x;
    uvec2 _1186 = _84(uvec4(_857), uvec2(_1111, _1116), uvec2(0u));
    uint _1187 = _1186.x;
    uint _1219 = ((_831 + 4608u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uint _1238 = ((_831 + 5120u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec2 _1266 = _84(uvec4(_1139, _1138.y, _1127, _1126.y), uvec2(_894.zw), uvec2(_84(uvec4(_1145, _1144.y, _1133, _1132.y), uvec2(_881.zw), uvec2(0u))));
    uint _1267 = _1266.x;
    uint _1268 = _1266.y;
    uvec2 _1272 = _84(uvec4(_1151, _1150.y, _1157, _1156.y), uvec2(_894.xy), uvec2(_84(uvec4(_1169, _1168.y, _1175, _1174.y), uvec2(_881.xy), uvec2(0u))));
    uint _1273 = _1272.x;
    uint _1274 = _1272.y;
    uint _1281 = ((_831 + 5632u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec2 _1291 = _84(uvec4(_1151, _1150.y, _1157, _1156.y), uvec2(_894.zw), uvec2(_84(uvec4(_1169, _1168.y, _1175, _1174.y), uvec2(_881.zw), uvec2(0u))));
    uint _1292 = _1291.x;
    uint _1293 = _1291.y;
    uvec2 _1297 = _84(uvec4(_1139, _1138.y, _1127, _1126.y), uvec2(_894.xy), uvec2(_84(uvec4(_1145, _1144.y, _1133, _1132.y), uvec2(_881.xy), uvec2(0u))));
    uint _1298 = _1297.x;
    uint _1299 = _1297.y;
    uvec2 _1303 = _84(uvec4(_1127, _1126.y, _1121, _1120.y), uvec2(_894.xy), uvec2(_84(uvec4(_1133, _1132.y, _1163, _1162.y), uvec2(_881.xy), uvec2(0u))));
    uint _1304 = _1303.x;
    uint _1305 = _1303.y;
    uint _1312 = ((_831 + 7168u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec2 _1322 = _84(uvec4(_1157, _1156.y, _1187, _1186.y), uvec2(_894.xy), uvec2(_84(uvec4(_1175, _1174.y, _1181, _1180.y), uvec2(_881.xy), uvec2(0u))));
    uint _1323 = _1322.x;
    uint _1324 = _1322.y;
    uint _1331 = ((_831 + 6144u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec2 _1341 = _84(uvec4(_1127, _1126.y, _1121, _1120.y), uvec2(_894.zw), uvec2(_84(uvec4(_1133, _1132.y, _1163, _1162.y), uvec2(_881.zw), uvec2(0u))));
    uint _1342 = _1341.x;
    uint _1343 = _1341.y;
    uint _1350 = ((_831 + 6656u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec2 _1360 = _84(uvec4(_1157, _1156.y, _1187, _1186.y), uvec2(_894.zw), uvec2(_84(uvec4(_1175, _1174.y, _1181, _1180.y), uvec2(_881.zw), uvec2(0u))));
    uint _1361 = _1360.x;
    uint _1362 = _1360.y;
    vec2 _1365 = unpackHalf2x16(0u);
    vec2 _1372 = unpackHalf2x16(0u);
    uint _1378 = (packHalf2x16(vec2(max(unpackHalf2x16(_1267).y, _1372.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1267).x, _1365.x), 0.0));
    vec2 _1381 = unpackHalf2x16(0u);
    vec2 _1388 = unpackHalf2x16(0u);
    uint _1394 = (packHalf2x16(vec2(max(unpackHalf2x16(_1299).y, _1388.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1299).x, _1381.x), 0.0));
    vec2 _1397 = unpackHalf2x16(0u);
    vec2 _1404 = unpackHalf2x16(0u);
    uint _1410 = (packHalf2x16(vec2(max(unpackHalf2x16(_1298).y, _1404.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1298).x, _1397.x), 0.0));
    vec2 _1413 = unpackHalf2x16(0u);
    vec2 _1420 = unpackHalf2x16(0u);
    uint _1426 = (packHalf2x16(vec2(max(unpackHalf2x16(_1292).y, _1420.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1292).x, _1413.x), 0.0));
    vec2 _1429 = unpackHalf2x16(0u);
    vec2 _1436 = unpackHalf2x16(0u);
    uint _1442 = (packHalf2x16(vec2(max(unpackHalf2x16(_1268).y, _1436.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1268).x, _1429.x), 0.0));
    vec2 _1445 = unpackHalf2x16(0u);
    vec2 _1452 = unpackHalf2x16(0u);
    uint _1458 = (packHalf2x16(vec2(max(unpackHalf2x16(_1273).y, _1452.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1273).x, _1445.x), 0.0));
    vec2 _1461 = unpackHalf2x16(0u);
    vec2 _1468 = unpackHalf2x16(0u);
    uint _1474 = (packHalf2x16(vec2(max(unpackHalf2x16(_1274).y, _1468.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1274).x, _1461.x), 0.0));
    vec2 _1477 = unpackHalf2x16(0u);
    vec2 _1484 = unpackHalf2x16(0u);
    uint _1490 = (packHalf2x16(vec2(max(unpackHalf2x16(_1293).y, _1484.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1293).x, _1477.x), 0.0));
    vec2 _1493 = unpackHalf2x16(0u);
    vec2 _1500 = unpackHalf2x16(0u);
    uint _1506 = (packHalf2x16(vec2(max(unpackHalf2x16(_1342).y, _1500.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1342).x, _1493.x), 0.0));
    vec2 _1509 = unpackHalf2x16(0u);
    vec2 _1516 = unpackHalf2x16(0u);
    uint _1522 = (packHalf2x16(vec2(max(unpackHalf2x16(_1304).y, _1516.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1304).x, _1509.x), 0.0));
    vec2 _1525 = unpackHalf2x16(0u);
    vec2 _1532 = unpackHalf2x16(0u);
    uint _1538 = (packHalf2x16(vec2(max(unpackHalf2x16(_1305).y, _1532.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1305).x, _1525.x), 0.0));
    vec2 _1541 = unpackHalf2x16(0u);
    vec2 _1548 = unpackHalf2x16(0u);
    uint _1554 = (packHalf2x16(vec2(max(unpackHalf2x16(_1343).y, _1548.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1343).x, _1541.x), 0.0));
    vec2 _1557 = unpackHalf2x16(0u);
    vec2 _1564 = unpackHalf2x16(0u);
    uint _1570 = (packHalf2x16(vec2(max(unpackHalf2x16(_1361).y, _1564.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1361).x, _1557.x), 0.0));
    vec2 _1573 = unpackHalf2x16(0u);
    vec2 _1580 = unpackHalf2x16(0u);
    uint _1586 = (packHalf2x16(vec2(max(unpackHalf2x16(_1323).y, _1580.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1323).x, _1573.x), 0.0));
    vec2 _1589 = unpackHalf2x16(0u);
    vec2 _1596 = unpackHalf2x16(0u);
    uint _1602 = (packHalf2x16(vec2(max(unpackHalf2x16(_1324).y, _1596.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1324).x, _1589.x), 0.0));
    vec2 _1605 = unpackHalf2x16(0u);
    vec2 _1612 = unpackHalf2x16(0u);
    uint _1618 = (packHalf2x16(vec2(max(unpackHalf2x16(_1362).y, _1612.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1362).x, _1605.x), 0.0));
    uvec2 _1622 = _84(uvec4(_907), uvec2(_1410, _1378), uvec2(0u));
    uint _1623 = _1622.x;
    uvec2 _1628 = _84(uvec4(_907), uvec2(_1394, _1442), uvec2(0u));
    uint _1629 = _1628.x;
    uvec2 _1634 = _84(uvec4(_907), uvec2(_1458, _1426), uvec2(0u));
    uint _1635 = _1634.x;
    uvec2 _1640 = _84(uvec4(_907), uvec2(_1474, _1490), uvec2(0u));
    uint _1641 = _1640.x;
    uvec2 _1646 = _84(uvec4(_907), uvec2(_1522, _1506), uvec2(0u));
    uint _1647 = _1646.x;
    uvec2 _1652 = _84(uvec4(_907), uvec2(_1538, _1554), uvec2(0u));
    uint _1653 = _1652.x;
    uvec2 _1658 = _84(uvec4(_907), uvec2(_1586, _1570), uvec2(0u));
    uint _1659 = _1658.x;
    uvec2 _1664 = _84(uvec4(_907), uvec2(_1602, _1618), uvec2(0u));
    uint _1665 = _1664.x;
    uint _1673 = ((_831 + 7680u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec2 _1707 = _84(uvec4(_982), uvec2(_1410, _1378), uvec2(0u));
    uint _1708 = _1707.x;
    uvec2 _1713 = _84(uvec4(_982), uvec2(_1394, _1442), uvec2(0u));
    uint _1714 = _1713.x;
    uvec2 _1731 = _84(uvec4(_982), uvec2(_1458, _1426), uvec2(0u));
    uint _1732 = _1731.x;
    uvec2 _1737 = _84(uvec4(_982), uvec2(_1474, _1490), uvec2(0u));
    uint _1738 = _1737.x;
    uvec2 _1755 = _84(uvec4(_982), uvec2(_1522, _1506), uvec2(0u));
    uint _1756 = _1755.x;
    uvec2 _1761 = _84(uvec4(_982), uvec2(_1538, _1554), uvec2(0u));
    uint _1762 = _1761.x;
    uvec2 _1767 = _84(uvec4(_982), uvec2(_1586, _1570), uvec2(0u));
    uint _1768 = _1767.x;
    uvec2 _1773 = _84(uvec4(_982), uvec2(_1602, _1618), uvec2(0u));
    uint _1774 = _1773.x;
    uint _1782 = ((_831 + 8192u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uint _1795 = ((_831 + 8704u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec2 _1805 = _84(uvec4(_1708, _1707.y, _1714, _1713.y), uvec2(_1045.zw), uvec2(_84(uvec4(_1623, _1622.y, _1629, _1628.y), uvec2(_952.zw), uvec2(0u))));
    uint _1806 = _1805.x;
    uint _1807 = _1805.y;
    uvec2 _1811 = _84(uvec4(_1708, _1707.y, _1714, _1713.y), uvec2(_1045.xy), uvec2(_84(uvec4(_1623, _1622.y, _1629, _1628.y), uvec2(_952.xy), uvec2(0u))));
    uint _1812 = _1811.x;
    uint _1813 = _1811.y;
    uvec2 _1817 = _84(uvec4(_1732, _1731.y, _1738, _1737.y), uvec2(_1045.xy), uvec2(_84(uvec4(_1635, _1634.y, _1641, _1640.y), uvec2(_952.xy), uvec2(0u))));
    uint _1818 = _1817.x;
    uint _1819 = _1817.y;
    uvec2 _1823 = _84(uvec4(_1732, _1731.y, _1738, _1737.y), uvec2(_1045.zw), uvec2(_84(uvec4(_1635, _1634.y, _1641, _1640.y), uvec2(_952.zw), uvec2(0u))));
    uint _1824 = _1823.x;
    uint _1825 = _1823.y;
    uvec2 _1829 = _84(uvec4(_1756, _1755.y, _1762, _1761.y), uvec2(_1045.xy), uvec2(_84(uvec4(_1647, _1646.y, _1653, _1652.y), uvec2(_952.xy), uvec2(0u))));
    uint _1830 = _1829.x;
    uint _1831 = _1829.y;
    uvec2 _1835 = _84(uvec4(_1756, _1755.y, _1762, _1761.y), uvec2(_1045.zw), uvec2(_84(uvec4(_1647, _1646.y, _1653, _1652.y), uvec2(_952.zw), uvec2(0u))));
    uint _1836 = _1835.x;
    uint _1837 = _1835.y;
    uvec2 _1841 = _84(uvec4(_1768, _1767.y, _1774, _1773.y), uvec2(_1045.xy), uvec2(_84(uvec4(_1659, _1658.y, _1665, _1664.y), uvec2(_952.xy), uvec2(0u))));
    uint _1842 = _1841.x;
    uint _1843 = _1841.y;
    uvec2 _1847 = _84(uvec4(_1768, _1767.y, _1774, _1773.y), uvec2(_1045.zw), uvec2(_84(uvec4(_1659, _1658.y, _1665, _1664.y), uvec2(_952.zw), uvec2(0u))));
    uint _1848 = _1847.x;
    uint _1849 = _1847.y;
    vec2 _1852 = unpackHalf2x16(0u);
    vec2 _1859 = unpackHalf2x16(0u);
    uint _1865 = (packHalf2x16(vec2(max(unpackHalf2x16(_1806).y, _1859.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1806).x, _1852.x), 0.0));
    vec2 _1868 = unpackHalf2x16(0u);
    vec2 _1875 = unpackHalf2x16(0u);
    uint _1881 = (packHalf2x16(vec2(max(unpackHalf2x16(_1812).y, _1875.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1812).x, _1868.x), 0.0));
    vec2 _1884 = unpackHalf2x16(0u);
    vec2 _1891 = unpackHalf2x16(0u);
    uint _1897 = (packHalf2x16(vec2(max(unpackHalf2x16(_1813).y, _1891.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1813).x, _1884.x), 0.0));
    vec2 _1900 = unpackHalf2x16(0u);
    vec2 _1907 = unpackHalf2x16(0u);
    uint _1913 = (packHalf2x16(vec2(max(unpackHalf2x16(_1807).y, _1907.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1807).x, _1900.x), 0.0));
    vec2 _1916 = unpackHalf2x16(0u);
    vec2 _1923 = unpackHalf2x16(0u);
    uint _1929 = (packHalf2x16(vec2(max(unpackHalf2x16(_1818).y, _1923.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1818).x, _1916.x), 0.0));
    uint _1936 = ((_831 + 9216u) - (c0.data[44u] & 4294967280u)) >> 4u;
    vec2 _1945 = unpackHalf2x16(0u);
    vec2 _1952 = unpackHalf2x16(0u);
    uint _1958 = (packHalf2x16(vec2(max(unpackHalf2x16(_1824).y, _1952.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1824).x, _1945.x), 0.0));
    vec2 _1961 = unpackHalf2x16(0u);
    vec2 _1968 = unpackHalf2x16(0u);
    uint _1974 = (packHalf2x16(vec2(max(unpackHalf2x16(_1819).y, _1968.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1819).x, _1961.x), 0.0));
    vec2 _1977 = unpackHalf2x16(0u);
    vec2 _1984 = unpackHalf2x16(0u);
    uint _1990 = (packHalf2x16(vec2(max(unpackHalf2x16(_1825).y, _1984.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1825).x, _1977.x), 0.0));
    vec2 _1993 = unpackHalf2x16(0u);
    vec2 _2000 = unpackHalf2x16(0u);
    uint _2006 = (packHalf2x16(vec2(max(unpackHalf2x16(_1830).y, _2000.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1830).x, _1993.x), 0.0));
    vec2 _2009 = unpackHalf2x16(0u);
    vec2 _2016 = unpackHalf2x16(0u);
    uint _2022 = (packHalf2x16(vec2(max(unpackHalf2x16(_1836).y, _2016.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1836).x, _2009.x), 0.0));
    vec2 _2025 = unpackHalf2x16(0u);
    vec2 _2032 = unpackHalf2x16(0u);
    uint _2038 = (packHalf2x16(vec2(max(unpackHalf2x16(_1831).y, _2032.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1831).x, _2025.x), 0.0));
    vec2 _2041 = unpackHalf2x16(0u);
    vec2 _2048 = unpackHalf2x16(0u);
    uint _2054 = (packHalf2x16(vec2(max(unpackHalf2x16(_1837).y, _2048.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1837).x, _2041.x), 0.0));
    vec2 _2057 = unpackHalf2x16(0u);
    vec2 _2064 = unpackHalf2x16(0u);
    uint _2070 = (packHalf2x16(vec2(max(unpackHalf2x16(_1848).y, _2064.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1848).x, _2057.x), 0.0));
    vec2 _2073 = unpackHalf2x16(0u);
    vec2 _2080 = unpackHalf2x16(0u);
    uint _2086 = (packHalf2x16(vec2(max(unpackHalf2x16(_1842).y, _2080.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1842).x, _2073.x), 0.0));
    vec2 _2089 = unpackHalf2x16(0u);
    vec2 _2096 = unpackHalf2x16(0u);
    uint _2102 = (packHalf2x16(vec2(max(unpackHalf2x16(_1843).y, _2096.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1843).x, _2089.x), 0.0));
    vec2 _2105 = unpackHalf2x16(0u);
    vec2 _2112 = unpackHalf2x16(0u);
    uint _2118 = (packHalf2x16(vec2(max(unpackHalf2x16(_1849).y, _2112.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1849).x, _2105.x), 0.0));
    uvec2 _2122 = _84(uvec4(_1058), uvec2(_1881, _1865), uvec2(0u));
    uint _2123 = _2122.x;
    uvec2 _2128 = _84(uvec4(_1058), uvec2(_1897, _1913), uvec2(0u));
    uint _2129 = _2128.x;
    uvec2 _2134 = _84(uvec4(_1058), uvec2(_1929, _1958), uvec2(0u));
    uint _2135 = _2134.x;
    uvec2 _2140 = _84(uvec4(_1058), uvec2(_1974, _1990), uvec2(0u));
    uint _2141 = _2140.x;
    uvec2 _2146 = _84(uvec4(_1058), uvec2(_2006, _2022), uvec2(0u));
    uint _2147 = _2146.x;
    uvec2 _2152 = _84(uvec4(_1058), uvec2(_2038, _2054), uvec2(0u));
    uint _2153 = _2152.x;
    uvec2 _2158 = _84(uvec4(_1058), uvec2(_2086, _2070), uvec2(0u));
    uint _2159 = _2158.x;
    uvec2 _2164 = _84(uvec4(_1058), uvec2(_2102, _2118), uvec2(0u));
    uint _2165 = _2164.x;
    uint _2173 = ((_831 + 9728u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec2 _2219 = _84(uvec4(ssbo0_3._m0[_1238]), uvec2(_1881, _1865), uvec2(0u));
    uint _2220 = _2219.x;
    uvec2 _2225 = _84(uvec4(ssbo0_3._m0[_1238]), uvec2(_1897, _1913), uvec2(0u));
    uint _2226 = _2225.x;
    uint _2246 = ((_831 + 10240u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec2 _2256 = _84(uvec4(ssbo0_3._m0[_1238]), uvec2(_1929, _1958), uvec2(0u));
    uint _2257 = _2256.x;
    uvec2 _2262 = _84(uvec4(ssbo0_3._m0[_1238]), uvec2(_1974, _1990), uvec2(0u));
    uint _2263 = _2262.x;
    uvec2 _2268 = _84(uvec4(ssbo0_3._m0[_1238]), uvec2(_2006, _2022), uvec2(0u));
    uint _2269 = _2268.x;
    uvec2 _2274 = _84(uvec4(ssbo0_3._m0[_1238]), uvec2(_2038, _2054), uvec2(0u));
    uint _2275 = _2274.x;
    uvec2 _2280 = _84(uvec4(ssbo0_3._m0[_1238]), uvec2(_2086, _2070), uvec2(0u));
    uint _2281 = _2280.x;
    uvec2 _2286 = _84(uvec4(ssbo0_3._m0[_1238]), uvec2(_2102, _2118), uvec2(0u));
    uint _2287 = _2286.x;
    uvec2 _2292 = _84(uvec4(_2220, _2219.y, _2226, _2225.y), uvec2(ssbo0_3._m0[_1281].xy), uvec2(_84(uvec4(_2123, _2122.y, _2129, _2128.y), uvec2(ssbo0_3._m0[_1219].xy), uvec2(0u))));
    uint _2293 = _2292.x;
    uint _2294 = _2292.y;
    uvec2 _2298 = _84(uvec4(_2220, _2219.y, _2226, _2225.y), uvec2(ssbo0_3._m0[_1281].zw), uvec2(_84(uvec4(_2123, _2122.y, _2129, _2128.y), uvec2(ssbo0_3._m0[_1219].zw), uvec2(0u))));
    uint _2299 = _2298.x;
    uint _2300 = _2298.y;
    uint _2307 = ((_831 + 10752u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec2 _2317 = _84(uvec4(_2257, _2256.y, _2263, _2262.y), uvec2(ssbo0_3._m0[_1281].xy), uvec2(_84(uvec4(_2135, _2134.y, _2141, _2140.y), uvec2(ssbo0_3._m0[_1219].xy), uvec2(0u))));
    uint _2318 = _2317.x;
    uint _2319 = _2317.y;
    uvec2 _2323 = _84(uvec4(_2257, _2256.y, _2263, _2262.y), uvec2(ssbo0_3._m0[_1281].zw), uvec2(_84(uvec4(_2135, _2134.y, _2141, _2140.y), uvec2(ssbo0_3._m0[_1219].zw), uvec2(0u))));
    uint _2324 = _2323.x;
    uint _2325 = _2323.y;
    uvec2 _2329 = _84(uvec4(_2269, _2268.y, _2275, _2274.y), uvec2(ssbo0_3._m0[_1281].xy), uvec2(_84(uvec4(_2147, _2146.y, _2153, _2152.y), uvec2(ssbo0_3._m0[_1219].xy), uvec2(0u))));
    uint _2330 = _2329.x;
    uint _2331 = _2329.y;
    uvec2 _2335 = _84(uvec4(_2269, _2268.y, _2275, _2274.y), uvec2(ssbo0_3._m0[_1281].zw), uvec2(_84(uvec4(_2147, _2146.y, _2153, _2152.y), uvec2(ssbo0_3._m0[_1219].zw), uvec2(0u))));
    uint _2336 = _2335.x;
    uint _2337 = _2335.y;
    vec2 _2340 = unpackHalf2x16(0u);
    vec2 _2347 = unpackHalf2x16(0u);
    uint _2353 = (packHalf2x16(vec2(max(unpackHalf2x16(_2318).y, _2347.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2318).x, _2340.x), 0.0));
    uvec2 _2357 = _84(uvec4(_2281, _2280.y, _2287, _2286.y), uvec2(ssbo0_3._m0[_1281].xy), uvec2(_84(uvec4(_2159, _2158.y, _2165, _2164.y), uvec2(ssbo0_3._m0[_1219].xy), uvec2(0u))));
    uint _2358 = _2357.x;
    uint _2359 = _2357.y;
    vec2 _2362 = unpackHalf2x16(0u);
    vec2 _2369 = unpackHalf2x16(0u);
    uint _2375 = (packHalf2x16(vec2(max(unpackHalf2x16(_2324).y, _2369.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2324).x, _2362.x), 0.0));
    vec2 _2378 = unpackHalf2x16(0u);
    vec2 _2385 = unpackHalf2x16(0u);
    uint _2391 = (packHalf2x16(vec2(max(unpackHalf2x16(_2293).y, _2385.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2293).x, _2378.x), 0.0));
    uvec2 _2395 = _84(uvec4(_2281, _2280.y, _2287, _2286.y), uvec2(ssbo0_3._m0[_1281].zw), uvec2(_84(uvec4(_2159, _2158.y, _2165, _2164.y), uvec2(ssbo0_3._m0[_1219].zw), uvec2(0u))));
    uint _2396 = _2395.x;
    uint _2397 = _2395.y;
    vec2 _2400 = unpackHalf2x16(0u);
    vec2 _2407 = unpackHalf2x16(0u);
    uint _2413 = (packHalf2x16(vec2(max(unpackHalf2x16(_2299).y, _2407.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2299).x, _2400.x), 0.0));
    vec2 _2416 = unpackHalf2x16(0u);
    vec2 _2423 = unpackHalf2x16(0u);
    uint _2429 = (packHalf2x16(vec2(max(unpackHalf2x16(_2294).y, _2423.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2294).x, _2416.x), 0.0));
    vec2 _2432 = unpackHalf2x16(0u);
    vec2 _2439 = unpackHalf2x16(0u);
    uint _2445 = (packHalf2x16(vec2(max(unpackHalf2x16(_2300).y, _2439.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2300).x, _2432.x), 0.0));
    vec2 _2448 = unpackHalf2x16(0u);
    vec2 _2455 = unpackHalf2x16(0u);
    uint _2461 = (packHalf2x16(vec2(max(unpackHalf2x16(_2319).y, _2455.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2319).x, _2448.x), 0.0));
    vec2 _2464 = unpackHalf2x16(0u);
    vec2 _2471 = unpackHalf2x16(0u);
    uint _2477 = (packHalf2x16(vec2(max(unpackHalf2x16(_2325).y, _2471.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2325).x, _2464.x), 0.0));
    vec2 _2480 = unpackHalf2x16(0u);
    vec2 _2487 = unpackHalf2x16(0u);
    uint _2493 = (packHalf2x16(vec2(max(unpackHalf2x16(_2336).y, _2487.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2336).x, _2480.x), 0.0));
    uvec2 _2497 = _84(uvec4(ssbo0_3._m0[_1331]), uvec2(_2391, _2413), uvec2(0u));
    uint _2498 = _2497.x;
    vec2 _2502 = unpackHalf2x16(0u);
    vec2 _2509 = unpackHalf2x16(0u);
    uint _2515 = (packHalf2x16(vec2(max(unpackHalf2x16(_2330).y, _2509.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2330).x, _2502.x), 0.0));
    vec2 _2518 = unpackHalf2x16(0u);
    vec2 _2525 = unpackHalf2x16(0u);
    uint _2531 = (packHalf2x16(vec2(max(unpackHalf2x16(_2331).y, _2525.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2331).x, _2518.x), 0.0));
    uint _2538 = ((_831 + 11264u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec2 _2548 = _84(uvec4(ssbo0_3._m0[_1331]), uvec2(_2429, _2445), uvec2(0u));
    uint _2549 = _2548.x;
    uvec2 _2554 = _84(uvec4(ssbo0_3._m0[_1331]), uvec2(_2353, _2375), uvec2(0u));
    uint _2555 = _2554.x;
    uvec2 _2560 = _84(uvec4(ssbo0_3._m0[_1331]), uvec2(_2461, _2477), uvec2(0u));
    uint _2561 = _2560.x;
    vec2 _2565 = unpackHalf2x16(0u);
    vec2 _2572 = unpackHalf2x16(0u);
    uint _2578 = (packHalf2x16(vec2(max(unpackHalf2x16(_2358).y, _2572.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2358).x, _2565.x), 0.0));
    vec2 _2581 = unpackHalf2x16(0u);
    vec2 _2588 = unpackHalf2x16(0u);
    uint _2594 = (packHalf2x16(vec2(max(unpackHalf2x16(_2359).y, _2588.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2359).x, _2581.x), 0.0));
    vec2 _2597 = unpackHalf2x16(0u);
    vec2 _2604 = unpackHalf2x16(0u);
    uint _2610 = (packHalf2x16(vec2(max(unpackHalf2x16(_2337).y, _2604.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2337).x, _2597.x), 0.0));
    vec2 _2613 = unpackHalf2x16(0u);
    vec2 _2620 = unpackHalf2x16(0u);
    uint _2626 = (packHalf2x16(vec2(max(unpackHalf2x16(_2396).y, _2620.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2396).x, _2613.x), 0.0));
    vec2 _2629 = unpackHalf2x16(0u);
    vec2 _2636 = unpackHalf2x16(0u);
    uint _2642 = (packHalf2x16(vec2(max(unpackHalf2x16(_2397).y, _2636.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2397).x, _2629.x), 0.0));
    uvec2 _2646 = _84(uvec4(ssbo0_3._m0[_1331]), uvec2(_2515, _2493), uvec2(0u));
    uint _2647 = _2646.x;
    uvec2 _2652 = _84(uvec4(ssbo0_3._m0[_1331]), uvec2(_2531, _2610), uvec2(0u));
    uint _2653 = _2652.x;
    uvec2 _2658 = _84(uvec4(ssbo0_3._m0[_1331]), uvec2(_2578, _2626), uvec2(0u));
    uint _2659 = _2658.x;
    uvec2 _2664 = _84(uvec4(ssbo0_3._m0[_1331]), uvec2(_2594, _2642), uvec2(0u));
    uint _2665 = _2664.x;
    uvec2 _2694 = _84(uvec4(ssbo0_3._m0[_1312]), uvec2(_2429, _2445), uvec2(0u));
    uint _2695 = _2694.x;
    uint _2703 = ((_831 + 11776u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec2 _2713 = _84(uvec4(ssbo0_3._m0[_1312]), uvec2(_2391, _2413), uvec2(0u));
    uint _2714 = _2713.x;
    uvec2 _2731 = _84(uvec4(ssbo0_3._m0[_1312]), uvec2(_2353, _2375), uvec2(0u));
    uint _2732 = _2731.x;
    uvec2 _2737 = _84(uvec4(ssbo0_3._m0[_1312]), uvec2(_2461, _2477), uvec2(0u));
    uint _2738 = _2737.x;
    uvec2 _2743 = _84(uvec4(ssbo0_3._m0[_1312]), uvec2(_2515, _2493), uvec2(0u));
    uint _2744 = _2743.x;
    uvec2 _2749 = _84(uvec4(ssbo0_3._m0[_1312]), uvec2(_2531, _2610), uvec2(0u));
    uint _2750 = _2749.x;
    uvec2 _2761 = _84(uvec4(ssbo0_3._m0[_1312]), uvec2(_2578, _2626), uvec2(0u));
    uint _2762 = _2761.x;
    uvec2 _2767 = _84(uvec4(ssbo0_3._m0[_1312]), uvec2(_2594, _2642), uvec2(0u));
    uint _2768 = _2767.x;
    uvec2 _2779 = _84(uvec4(_2714, _2713.y, _2695, _2694.y), uvec2(ssbo0_3._m0[_1673].zw), uvec2(_84(uvec4(_2498, _2497.y, _2549, _2548.y), uvec2(ssbo0_3._m0[_1350].zw), uvec2(0u))));
    uint _2780 = _2779.x;
    uint _2781 = _2779.y;
    uvec2 _2785 = _84(uvec4(_2714, _2713.y, _2695, _2694.y), uvec2(ssbo0_3._m0[_1673].xy), uvec2(_84(uvec4(_2498, _2497.y, _2549, _2548.y), uvec2(ssbo0_3._m0[_1350].xy), uvec2(0u))));
    uint _2786 = _2785.x;
    uint _2787 = _2785.y;
    uvec2 _2791 = _84(uvec4(_2732, _2731.y, _2738, _2737.y), uvec2(ssbo0_3._m0[_1673].zw), uvec2(_84(uvec4(_2555, _2554.y, _2561, _2560.y), uvec2(ssbo0_3._m0[_1350].zw), uvec2(0u))));
    uint _2792 = _2791.x;
    uint _2793 = _2791.y;
    uvec2 _2797 = _84(uvec4(_2732, _2731.y, _2738, _2737.y), uvec2(ssbo0_3._m0[_1673].xy), uvec2(_84(uvec4(_2555, _2554.y, _2561, _2560.y), uvec2(ssbo0_3._m0[_1350].xy), uvec2(0u))));
    uint _2798 = _2797.x;
    uint _2799 = _2797.y;
    uvec2 _2803 = _84(uvec4(_2744, _2743.y, _2750, _2749.y), uvec2(ssbo0_3._m0[_1673].zw), uvec2(_84(uvec4(_2647, _2646.y, _2653, _2652.y), uvec2(ssbo0_3._m0[_1350].zw), uvec2(0u))));
    uint _2804 = _2803.x;
    uint _2805 = _2803.y;
    uvec2 _2809 = _84(uvec4(_2744, _2743.y, _2750, _2749.y), uvec2(ssbo0_3._m0[_1673].xy), uvec2(_84(uvec4(_2647, _2646.y, _2653, _2652.y), uvec2(ssbo0_3._m0[_1350].xy), uvec2(0u))));
    uint _2810 = _2809.x;
    uint _2811 = _2809.y;
    uvec2 _2815 = _84(uvec4(_2762, _2761.y, _2768, _2767.y), uvec2(ssbo0_3._m0[_1673].zw), uvec2(_84(uvec4(_2659, _2658.y, _2665, _2664.y), uvec2(ssbo0_3._m0[_1350].zw), uvec2(0u))));
    uint _2816 = _2815.x;
    uint _2817 = _2815.y;
    uvec2 _2821 = _84(uvec4(_2762, _2761.y, _2768, _2767.y), uvec2(ssbo0_3._m0[_1673].xy), uvec2(_84(uvec4(_2659, _2658.y, _2665, _2664.y), uvec2(ssbo0_3._m0[_1350].xy), uvec2(0u))));
    uint _2822 = _2821.x;
    uint _2823 = _2821.y;
    vec2 _2826 = unpackHalf2x16(0u);
    vec2 _2833 = unpackHalf2x16(0u);
    uint _2839 = (packHalf2x16(vec2(max(unpackHalf2x16(_2780).y, _2833.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2780).x, _2826.x), 0.0));
    vec2 _2842 = unpackHalf2x16(0u);
    vec2 _2849 = unpackHalf2x16(0u);
    uint _2855 = (packHalf2x16(vec2(max(unpackHalf2x16(_2786).y, _2849.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2786).x, _2842.x), 0.0));
    vec2 _2858 = unpackHalf2x16(0u);
    vec2 _2865 = unpackHalf2x16(0u);
    uint _2871 = (packHalf2x16(vec2(max(unpackHalf2x16(_2787).y, _2865.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2787).x, _2858.x), 0.0));
    vec2 _2874 = unpackHalf2x16(0u);
    vec2 _2881 = unpackHalf2x16(0u);
    uint _2887 = (packHalf2x16(vec2(max(unpackHalf2x16(_2781).y, _2881.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2781).x, _2874.x), 0.0));
    vec2 _2890 = unpackHalf2x16(0u);
    vec2 _2897 = unpackHalf2x16(0u);
    uint _2903 = (packHalf2x16(vec2(max(unpackHalf2x16(_2792).y, _2897.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2792).x, _2890.x), 0.0));
    vec2 _2906 = unpackHalf2x16(0u);
    vec2 _2913 = unpackHalf2x16(0u);
    uint _2919 = (packHalf2x16(vec2(max(unpackHalf2x16(_2798).y, _2913.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2798).x, _2906.x), 0.0));
    vec2 _2922 = unpackHalf2x16(0u);
    vec2 _2929 = unpackHalf2x16(0u);
    uint _2935 = (packHalf2x16(vec2(max(unpackHalf2x16(_2799).y, _2929.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2799).x, _2922.x), 0.0));
    vec2 _2938 = unpackHalf2x16(0u);
    vec2 _2945 = unpackHalf2x16(0u);
    uint _2951 = (packHalf2x16(vec2(max(unpackHalf2x16(_2793).y, _2945.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2793).x, _2938.x), 0.0));
    vec2 _2954 = unpackHalf2x16(0u);
    vec2 _2961 = unpackHalf2x16(0u);
    uint _2967 = (packHalf2x16(vec2(max(unpackHalf2x16(_2804).y, _2961.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2804).x, _2954.x), 0.0));
    vec2 _2970 = unpackHalf2x16(0u);
    vec2 _2977 = unpackHalf2x16(0u);
    uint _2983 = (packHalf2x16(vec2(max(unpackHalf2x16(_2810).y, _2977.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2810).x, _2970.x), 0.0));
    vec2 _2986 = unpackHalf2x16(0u);
    vec2 _2993 = unpackHalf2x16(0u);
    uint _2999 = (packHalf2x16(vec2(max(unpackHalf2x16(_2811).y, _2993.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2811).x, _2986.x), 0.0));
    vec2 _3002 = unpackHalf2x16(0u);
    vec2 _3009 = unpackHalf2x16(0u);
    uint _3015 = (packHalf2x16(vec2(max(unpackHalf2x16(_2805).y, _3009.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2805).x, _3002.x), 0.0));
    vec2 _3018 = unpackHalf2x16(0u);
    vec2 _3025 = unpackHalf2x16(0u);
    uint _3031 = (packHalf2x16(vec2(max(unpackHalf2x16(_2816).y, _3025.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2816).x, _3018.x), 0.0));
    uvec2 _3035 = _84(uvec4(ssbo0_3._m0[_1782]), uvec2(_2855, _2839), uvec2(0u));
    uint _3036 = _3035.x;
    vec2 _3040 = unpackHalf2x16(0u);
    vec2 _3047 = unpackHalf2x16(0u);
    uint _3053 = (packHalf2x16(vec2(max(unpackHalf2x16(_2822).y, _3047.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2822).x, _3040.x), 0.0));
    vec2 _3056 = unpackHalf2x16(0u);
    vec2 _3063 = unpackHalf2x16(0u);
    uint _3069 = (packHalf2x16(vec2(max(unpackHalf2x16(_2823).y, _3063.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2823).x, _3056.x), 0.0));
    vec2 _3072 = unpackHalf2x16(0u);
    vec2 _3079 = unpackHalf2x16(0u);
    uint _3085 = (packHalf2x16(vec2(max(unpackHalf2x16(_2817).y, _3079.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2817).x, _3072.x), 0.0));
    uvec2 _3089 = _84(uvec4(ssbo0_3._m0[_1782]), uvec2(_2871, _2887), uvec2(0u));
    uint _3090 = _3089.x;
    uvec2 _3095 = _84(uvec4(ssbo0_3._m0[_1782]), uvec2(_2919, _2903), uvec2(0u));
    uint _3096 = _3095.x;
    uvec2 _3101 = _84(uvec4(ssbo0_3._m0[_1782]), uvec2(_2935, _2951), uvec2(0u));
    uint _3102 = _3101.x;
    uvec2 _3107 = _84(uvec4(ssbo0_3._m0[_1782]), uvec2(_2983, _2967), uvec2(0u));
    uint _3108 = _3107.x;
    uvec2 _3113 = _84(uvec4(ssbo0_3._m0[_1782]), uvec2(_2999, _3015), uvec2(0u));
    uint _3114 = _3113.x;
    uvec2 _3119 = _84(uvec4(ssbo0_3._m0[_1782]), uvec2(_3053, _3031), uvec2(0u));
    uint _3120 = _3119.x;
    uvec2 _3125 = _84(uvec4(ssbo0_3._m0[_1782]), uvec2(_3069, _3085), uvec2(0u));
    uint _3126 = _3125.x;
    uvec2 _3131 = _84(uvec4(ssbo0_3._m0[_1936]), uvec2(_2855, _2839), uvec2(0u));
    uint _3132 = _3131.x;
    uvec2 _3137 = _84(uvec4(ssbo0_3._m0[_1936]), uvec2(_2871, _2887), uvec2(0u));
    uint _3138 = _3137.x;
    uvec2 _3167 = _84(uvec4(ssbo0_3._m0[_1936]), uvec2(_2919, _2903), uvec2(0u));
    uint _3168 = _3167.x;
    uvec2 _3173 = _84(uvec4(ssbo0_3._m0[_1936]), uvec2(_2935, _2951), uvec2(0u));
    uint _3174 = _3173.x;
    uvec2 _3191 = _84(uvec4(ssbo0_3._m0[_1936]), uvec2(_2983, _2967), uvec2(0u));
    uint _3192 = _3191.x;
    uvec2 _3197 = _84(uvec4(ssbo0_3._m0[_1936]), uvec2(_2999, _3015), uvec2(0u));
    uint _3198 = _3197.x;
    uvec2 _3215 = _84(uvec4(ssbo0_3._m0[_1936]), uvec2(_3053, _3031), uvec2(0u));
    uint _3216 = _3215.x;
    uvec2 _3221 = _84(uvec4(ssbo0_3._m0[_1936]), uvec2(_3069, _3085), uvec2(0u));
    uint _3222 = _3221.x;
    uvec2 _3227 = _84(uvec4(_3132, _3131.y, _3138, _3137.y), uvec2(ssbo0_3._m0[_2173].xy), uvec2(_84(uvec4(_3036, _3035.y, _3090, _3089.y), uvec2(ssbo0_3._m0[_1795].xy), uvec2(0u))));
    uint _3228 = _3227.x;
    uint _3229 = _3227.y;
    uvec2 _3233 = _84(uvec4(_3132, _3131.y, _3138, _3137.y), uvec2(ssbo0_3._m0[_2173].zw), uvec2(_84(uvec4(_3036, _3035.y, _3090, _3089.y), uvec2(ssbo0_3._m0[_1795].zw), uvec2(0u))));
    uint _3234 = _3233.x;
    uint _3235 = _3233.y;
    uvec2 _3239 = _84(uvec4(_3168, _3167.y, _3174, _3173.y), uvec2(ssbo0_3._m0[_2173].xy), uvec2(_84(uvec4(_3096, _3095.y, _3102, _3101.y), uvec2(ssbo0_3._m0[_1795].xy), uvec2(0u))));
    uint _3240 = _3239.x;
    uint _3241 = _3239.y;
    uvec2 _3245 = _84(uvec4(_3168, _3167.y, _3174, _3173.y), uvec2(ssbo0_3._m0[_2173].zw), uvec2(_84(uvec4(_3096, _3095.y, _3102, _3101.y), uvec2(ssbo0_3._m0[_1795].zw), uvec2(0u))));
    uint _3246 = _3245.x;
    uint _3247 = _3245.y;
    uvec2 _3251 = _84(uvec4(_3192, _3191.y, _3198, _3197.y), uvec2(ssbo0_3._m0[_2173].xy), uvec2(_84(uvec4(_3108, _3107.y, _3114, _3113.y), uvec2(ssbo0_3._m0[_1795].xy), uvec2(0u))));
    uint _3252 = _3251.x;
    uint _3253 = _3251.y;
    uvec2 _3257 = _84(uvec4(_3192, _3191.y, _3198, _3197.y), uvec2(ssbo0_3._m0[_2173].zw), uvec2(_84(uvec4(_3108, _3107.y, _3114, _3113.y), uvec2(ssbo0_3._m0[_1795].zw), uvec2(0u))));
    uint _3258 = _3257.x;
    uint _3259 = _3257.y;
    uvec2 _3263 = _84(uvec4(_3216, _3215.y, _3222, _3221.y), uvec2(ssbo0_3._m0[_2173].xy), uvec2(_84(uvec4(_3120, _3119.y, _3126, _3125.y), uvec2(ssbo0_3._m0[_1795].xy), uvec2(0u))));
    uint _3264 = _3263.x;
    uint _3265 = _3263.y;
    uvec2 _3269 = _84(uvec4(_3216, _3215.y, _3222, _3221.y), uvec2(ssbo0_3._m0[_2173].zw), uvec2(_84(uvec4(_3120, _3119.y, _3126, _3125.y), uvec2(ssbo0_3._m0[_1795].zw), uvec2(0u))));
    uint _3270 = _3269.x;
    uint _3271 = _3269.y;
    vec2 _3274 = unpackHalf2x16(0u);
    vec2 _3281 = unpackHalf2x16(0u);
    uint _3287 = (packHalf2x16(vec2(max(unpackHalf2x16(_3228).y, _3281.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3228).x, _3274.x), 0.0));
    vec2 _3290 = unpackHalf2x16(0u);
    vec2 _3297 = unpackHalf2x16(0u);
    uint _3303 = (packHalf2x16(vec2(max(unpackHalf2x16(_3234).y, _3297.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3234).x, _3290.x), 0.0));
    vec2 _3306 = unpackHalf2x16(0u);
    vec2 _3313 = unpackHalf2x16(0u);
    uint _3319 = (packHalf2x16(vec2(max(unpackHalf2x16(_3229).y, _3313.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3229).x, _3306.x), 0.0));
    vec2 _3322 = unpackHalf2x16(0u);
    vec2 _3329 = unpackHalf2x16(0u);
    uint _3335 = (packHalf2x16(vec2(max(unpackHalf2x16(_3235).y, _3329.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3235).x, _3322.x), 0.0));
    vec2 _3338 = unpackHalf2x16(0u);
    vec2 _3345 = unpackHalf2x16(0u);
    uint _3351 = (packHalf2x16(vec2(max(unpackHalf2x16(_3240).y, _3345.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3240).x, _3338.x), 0.0));
    vec2 _3354 = unpackHalf2x16(0u);
    vec2 _3361 = unpackHalf2x16(0u);
    uint _3367 = (packHalf2x16(vec2(max(unpackHalf2x16(_3246).y, _3361.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3246).x, _3354.x), 0.0));
    vec2 _3370 = unpackHalf2x16(0u);
    vec2 _3377 = unpackHalf2x16(0u);
    uint _3383 = (packHalf2x16(vec2(max(unpackHalf2x16(_3241).y, _3377.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3241).x, _3370.x), 0.0));
    vec2 _3386 = unpackHalf2x16(0u);
    vec2 _3393 = unpackHalf2x16(0u);
    uint _3399 = (packHalf2x16(vec2(max(unpackHalf2x16(_3247).y, _3393.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3247).x, _3386.x), 0.0));
    vec2 _3402 = unpackHalf2x16(0u);
    vec2 _3409 = unpackHalf2x16(0u);
    uint _3415 = (packHalf2x16(vec2(max(unpackHalf2x16(_3252).y, _3409.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3252).x, _3402.x), 0.0));
    vec2 _3418 = unpackHalf2x16(0u);
    vec2 _3425 = unpackHalf2x16(0u);
    uint _3431 = (packHalf2x16(vec2(max(unpackHalf2x16(_3258).y, _3425.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3258).x, _3418.x), 0.0));
    vec2 _3434 = unpackHalf2x16(0u);
    vec2 _3441 = unpackHalf2x16(0u);
    uint _3447 = (packHalf2x16(vec2(max(unpackHalf2x16(_3253).y, _3441.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3253).x, _3434.x), 0.0));
    vec2 _3450 = unpackHalf2x16(0u);
    vec2 _3457 = unpackHalf2x16(0u);
    uint _3463 = (packHalf2x16(vec2(max(unpackHalf2x16(_3259).y, _3457.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3259).x, _3450.x), 0.0));
    uvec2 _3467 = _84(uvec4(ssbo0_3._m0[_2246]), uvec2(_3287, _3303), uvec2(0u));
    uint _3468 = _3467.x;
    vec2 _3472 = unpackHalf2x16(0u);
    vec2 _3479 = unpackHalf2x16(0u);
    uint _3485 = (packHalf2x16(vec2(max(unpackHalf2x16(_3264).y, _3479.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3264).x, _3472.x), 0.0));
    vec2 _3488 = unpackHalf2x16(0u);
    vec2 _3495 = unpackHalf2x16(0u);
    uint _3501 = (packHalf2x16(vec2(max(unpackHalf2x16(_3270).y, _3495.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3270).x, _3488.x), 0.0));
    vec2 _3504 = unpackHalf2x16(0u);
    vec2 _3511 = unpackHalf2x16(0u);
    uint _3517 = (packHalf2x16(vec2(max(unpackHalf2x16(_3265).y, _3511.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3265).x, _3504.x), 0.0));
    vec2 _3520 = unpackHalf2x16(0u);
    vec2 _3527 = unpackHalf2x16(0u);
    uint _3533 = (packHalf2x16(vec2(max(unpackHalf2x16(_3271).y, _3527.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3271).x, _3520.x), 0.0));
    uvec2 _3537 = _84(uvec4(ssbo0_3._m0[_2246]), uvec2(_3319, _3335), uvec2(0u));
    uint _3538 = _3537.x;
    uvec2 _3545 = _84(uvec4(ssbo0_3._m0[_2246]), uvec2(_3351, _3367), uvec2(0u));
    uint _3546 = _3545.x;
    uvec2 _3551 = _84(uvec4(ssbo0_3._m0[_2246]), uvec2(_3383, _3399), uvec2(0u));
    uint _3552 = _3551.x;
    uvec2 _3557 = _84(uvec4(ssbo0_3._m0[_2246]), uvec2(_3415, _3431), uvec2(0u));
    uint _3558 = _3557.x;
    uvec2 _3563 = _84(uvec4(ssbo0_3._m0[_2246]), uvec2(_3447, _3463), uvec2(0u));
    uint _3564 = _3563.x;
    uvec2 _3569 = _84(uvec4(ssbo0_3._m0[_2246]), uvec2(_3485, _3501), uvec2(0u));
    uint _3570 = _3569.x;
    uvec2 _3575 = _84(uvec4(ssbo0_3._m0[_2246]), uvec2(_3517, _3533), uvec2(0u));
    uint _3576 = _3575.x;
    uint _3578 = gl_SubgroupInvocationID & 7u;
    uint _3581 = _3578 + 8u;
    uint _3598 = _3578 + 16u;
    uint _3606 = _3578 + 24u;
    uint _3607 = _3578 + 32u;
    uint _3608 = _3578 + 40u;
    uint _3610 = (gl_SubgroupInvocationID >> 3u) + (_627 * 12u);
    uint _3632 = (((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.x, int(16u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u)))) << 16u) + ((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u))) + _3581);
    uint _3633 = _3610 + 4u;
    uint _3648 = (((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.x, int(16u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u)))) << 16u) + ((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u))) + _3598);
    uint _3669 = (((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.x, int(16u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u)))) << 16u) + ((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u))) + _3606);
    uint _3684 = (((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.x, int(16u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u)))) << 16u) + ((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u))) + _3607);
    uint _3721 = (((bitfieldExtract(gl_WorkGroupID.y, int(0u), int(16u)) * bitfieldExtract(c0.data[23u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.y, int(16u), int(16u)) * bitfieldExtract(c0.data[23u], int(0u), int(16u)))) << 16u) + ((bitfieldExtract(gl_WorkGroupID.y, int(0u), int(16u)) * bitfieldExtract(c0.data[23u], int(0u), int(16u))) + _3610);
    uint _3722 = _3610 + 8u;
    precise float _3734 = 0.5 * c0_1.data[30u];
    precise float _3745 = 0.5 * c0_1.data[31u];
    uvec2 _3764 = _84(uvec4(ssbo0_3._m0[_2538]), uvec2(_3447, _3463), uvec2(0u));
    uint _3765 = _3764.x;
    precise float _3769 = fma(float((((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.x, int(16u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u)))) << 16u) + ((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u))) + _3578)), c0_1.data[30u], _3734);
    uvec2 _3788 = _84(uvec4(ssbo0_3._m0[_2538]), uvec2(_3415, _3431), uvec2(0u));
    uint _3789 = _3788.x;
    precise float _3794 = fma(float(_3721), c0_1.data[31u], _3745);
    uvec2 _3815 = _84(uvec4(ssbo0_3._m0[_2538]), uvec2(_3287, _3303), uvec2(0u));
    uint _3816 = _3815.x;
    precise float _3820 = fma(float(_3648), c0_1.data[30u], _3734);
    precise float _3823 = fma(float(_3632), c0_1.data[30u], _3734);
    uvec2 _3828 = _84(uvec4(ssbo0_3._m0[_2538]), uvec2(_3319, _3335), uvec2(0u));
    uint _3829 = _3828.x;
    precise float _3833 = fma(float(_3669), c0_1.data[30u], _3734);
    precise float _3836 = fma(float(_3684), c0_1.data[30u], _3734);
    uvec2 _3840 = _84(uvec4(ssbo0_3._m0[_2538]), uvec2(_3351, _3367), uvec2(0u));
    uint _3841 = _3840.x;
    precise float _3845 = fma(float((((bitfieldExtract(gl_WorkGroupID.y, int(0u), int(16u)) * bitfieldExtract(c0.data[23u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.y, int(16u), int(16u)) * bitfieldExtract(c0.data[23u], int(0u), int(16u)))) << 16u) + ((bitfieldExtract(gl_WorkGroupID.y, int(0u), int(16u)) * bitfieldExtract(c0.data[23u], int(0u), int(16u))) + _3633)), c0_1.data[31u], _3745);
    vec4 _3848 = textureLod(cs_tex0_c0, vec2(_3769, _3794), 0.0);
    uvec2 _3867 = _84(uvec4(ssbo0_3._m0[_2538]), uvec2(_3383, _3399), uvec2(0u));
    uint _3868 = _3867.x;
    precise float _3872 = fma(float((((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.x, int(16u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u)))) << 16u) + ((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u))) + _3608)), c0_1.data[30u], _3734);
    uvec2 _3876 = _84(uvec4(ssbo0_3._m0[_2538]), uvec2(_3485, _3501), uvec2(0u));
    uint _3877 = _3876.x;
    uvec2 _3882 = _84(uvec4(ssbo0_3._m0[_2538]), uvec2(_3517, _3533), uvec2(0u));
    uint _3883 = _3882.x;
    vec4 _3887 = textureLod(cs_tex0_c0, vec2(_3823, _3794), 0.0);
    vec4 _3905 = textureLod(cs_tex0_c0, vec2(_3820, _3794), 0.0);
    precise float _3923 = fma(float((((bitfieldExtract(gl_WorkGroupID.y, int(0u), int(16u)) * bitfieldExtract(c0.data[23u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.y, int(16u), int(16u)) * bitfieldExtract(c0.data[23u], int(0u), int(16u)))) << 16u) + ((bitfieldExtract(gl_WorkGroupID.y, int(0u), int(16u)) * bitfieldExtract(c0.data[23u], int(0u), int(16u))) + _3722)), c0_1.data[31u], _3745);
    vec4 _3926 = textureLod(cs_tex0_c0, vec2(_3833, _3794), 0.0);
    vec4 _3944 = textureLod(cs_tex0_c0, vec2(_3836, _3794), 0.0);
    vec4 _3962 = textureLod(cs_tex0_c0, vec2(_3872, _3794), 0.0);
    vec4 _3980 = textureLod(cs_tex0_c0, vec2(_3769, _3845), 0.0);
    vec4 _3998 = textureLod(cs_tex0_c0, vec2(_3823, _3845), 0.0);
    vec4 _4016 = textureLod(cs_tex0_c0, vec2(_3820, _3845), 0.0);
    vec4 _4034 = textureLod(cs_tex0_c0, vec2(_3833, _3845), 0.0);
    vec4 _4052 = textureLod(cs_tex0_c0, vec2(_3836, _3845), 0.0);
    vec4 _4070 = textureLod(cs_tex0_c0, vec2(_3872, _3845), 0.0);
    vec4 _4088 = textureLod(cs_tex0_c0, vec2(_3769, _3923), 0.0);
    vec4 _4106 = textureLod(cs_tex0_c0, vec2(_3823, _3923), 0.0);
    vec4 _4124 = textureLod(cs_tex0_c0, vec2(_3820, _3923), 0.0);
    vec4 _4142 = textureLod(cs_tex0_c0, vec2(_3833, _3923), 0.0);
    vec4 _4160 = textureLod(cs_tex0_c0, vec2(_3836, _3923), 0.0);
    vec4 _4178 = textureLod(cs_tex0_c0, vec2(_3872, _3923), 0.0);
    uvec2 _4197 = _84(uvec4(_3816, _3815.y, _3829, _3828.y), uvec2(ssbo0_3._m0[_2703].xy), uvec2(_84(uvec4(_3468, _3467.y, _3538, _3537.y), uvec2(ssbo0_3._m0[_2307].xy), uvec2(0u))));
    uvec2 _4204 = _84(uvec4(_3816, _3815.y, _3829, _3828.y), uvec2(ssbo0_3._m0[_2703].zw), uvec2(_84(uvec4(_3468, _3467.y, _3538, _3537.y), uvec2(ssbo0_3._m0[_2307].zw), uvec2(0u))));
    uvec2 _4211 = _84(uvec4(_3841, _3840.y, _3868, _3867.y), uvec2(ssbo0_3._m0[_2703].xy), uvec2(_84(uvec4(_3546, _3545.y, _3552, _3551.y), uvec2(ssbo0_3._m0[_2307].xy), uvec2(0u))));
    uvec2 _4219 = _84(uvec4(_3789, _3788.y, _3765, _3764.y), uvec2(ssbo0_3._m0[_2703].xy), uvec2(_84(uvec4(_3558, _3557.y, _3564, _3563.y), uvec2(ssbo0_3._m0[_2307].xy), uvec2(0u))));
    precise float _4227 = fma(float(_3578), c0_1.data[24u], c0_1.data[26u]);
    precise float _4233 = fma(float(_3598), c0_1.data[24u], c0_1.data[26u]);
    uvec2 _4238 = _84(uvec4(_3789, _3788.y, _3765, _3764.y), uvec2(ssbo0_3._m0[_2703].zw), uvec2(_84(uvec4(_3558, _3557.y, _3564, _3563.y), uvec2(ssbo0_3._m0[_2307].zw), uvec2(0u))));
    precise float _4245 = fma(float(_3606), c0_1.data[24u], c0_1.data[26u]);
    uvec2 _4251 = _84(uvec4(_3877, _3876.y, _3883, _3882.y), uvec2(ssbo0_3._m0[_2703].xy), uvec2(_84(uvec4(_3570, _3569.y, _3576, _3575.y), uvec2(ssbo0_3._m0[_2307].xy), uvec2(0u))));
    uvec2 _4258 = _84(uvec4(_3841, _3840.y, _3868, _3867.y), uvec2(ssbo0_3._m0[_2703].zw), uvec2(_84(uvec4(_3546, _3545.y, _3552, _3551.y), uvec2(ssbo0_3._m0[_2307].zw), uvec2(0u))));
    precise float _4265 = fma(float(_3607), c0_1.data[24u], c0_1.data[26u]);
    precise float _4271 = fma(float(_3608), c0_1.data[24u], c0_1.data[26u]);
    precise float _4277 = fma(float(_3581), c0_1.data[24u], c0_1.data[26u]);
    uvec2 _4282 = _84(uvec4(_3877, _3876.y, _3883, _3882.y), uvec2(ssbo0_3._m0[_2703].zw), uvec2(_84(uvec4(_3570, _3569.y, _3576, _3575.y), uvec2(ssbo0_3._m0[_2307].zw), uvec2(0u))));
    uint _4291 = ((bitfieldExtract(_627, int(16u), int(16u)) * 12u) << 16u) + ((bitfieldExtract(_627, int(0u), int(16u)) * 12u) + _632);
    precise float _4325 = fma(float(_3722), c0_1.data[25u], c0_1.data[27u]);
    precise float _4331 = fma(float(_3610), c0_1.data[25u], c0_1.data[27u]);
    uint _4334 = (_4291 >> 1u) + (((bitfieldExtract(_631, int(16u), int(16u)) * 26u) << 16u) + ((bitfieldExtract(_631, int(0u), int(16u)) * 26u) + 312u));
    precise float _4339 = fma(float(_3633), c0_1.data[25u], c0_1.data[27u]);
    uint _4345 = (_4291 >> 1u) + (((bitfieldExtract(_631, int(16u), int(16u)) * 26u) << 16u) + ((bitfieldExtract(_631, int(0u), int(16u)) * 26u) + 624u));
    uint _4347 = (_4291 >> 1u) + (((bitfieldExtract(_631, int(16u), int(16u)) * 26u) << 16u) + ((bitfieldExtract(_631, int(0u), int(16u)) * 26u) + 936u));
    bool _4350 = gl_SubgroupInvocationID >= 16u;
    bool _4353 = _628 >= 2u;
    bool _4356 = (_628 < 2u) && (!_4350);
    precise float _4359 = _4227 + uintBitsToFloat(floatBitsToUint(floor(_4227)) ^ 2147483648u);
    uint _4368 = floatBitsToUint(_4227) & (((!isnan(_4227)) && (!isnan(_4227))) ? 4294967295u : 0u);
    uint _4381 = uint(clamp(floor(min(uintBitsToFloat(_4368), 4294967040.0)), 0.0, 4294967296.0)) | ((uintBitsToFloat(_4368) >= 4294967296.0) ? 4294967295u : 0u);
    uint _4388 = ((bitfieldExtract(_631, int(16u), int(16u)) * 26u) << 16u) + ((bitfieldExtract(_631, int(0u), int(16u)) * 26u) + (_4291 >> 1u));
    precise float _4391 = _4233 + uintBitsToFloat(floatBitsToUint(floor(_4233)) ^ 2147483648u);
    precise float _4397 = _4325 + uintBitsToFloat(floatBitsToUint(floor(_4325)) ^ 2147483648u);
    _42._m0[uint(int(_4388 << 2u) >> int(2u))] = _4197.x;
    uint _4410 = floatBitsToUint(_4233) & (((!isnan(_4233)) && (!isnan(_4233))) ? 4294967295u : 0u);
    float _4415 = min(uintBitsToFloat(_4410), 4294967040.0);
    uint _4420 = uint(clamp(floor(_4415), 0.0, 4294967296.0)) | ((uintBitsToFloat(_4410) >= 4294967296.0) ? 4294967295u : 0u);
    uint _4423;
    if (!_4353)
    {
        _4423 = _4388 << 2u;
    }
    else
    {
        _4423 = floatBitsToUint(_4415);
    }
    if (!_4353)
    {
        _42._m0[uint(int(_4423 + 16u) >> int(2u))] = _4204.x;
    }
    uint _4434 = floatBitsToUint(_4331) & (((!isnan(_4331)) && (!isnan(_4331))) ? 4294967295u : 0u);
    float _4439 = min(uintBitsToFloat(_4434), 4294967040.0);
    uint _4444 = uint(clamp(floor(_4439), 0.0, 4294967296.0)) | ((uintBitsToFloat(_4434) >= 4294967296.0) ? 4294967295u : 0u);
    uint _4447;
    if (!_4350)
    {
        _4447 = _4388 << 2u;
    }
    else
    {
        _4447 = floatBitsToUint(_4439);
    }
    if (!_4350)
    {
        _42._m0[uint(int(_4447 + 832u) >> int(2u))] = _4197.y;
    }
    uint _4459 = floatBitsToUint(_4339) & (((!isnan(_4339)) && (!isnan(_4339))) ? 4294967295u : 0u);
    float _4464 = min(uintBitsToFloat(_4459), 4294967040.0);
    uint _4469 = uint(clamp(floor(_4464), 0.0, 4294967296.0)) | ((uintBitsToFloat(_4459) >= 4294967296.0) ? 4294967295u : 0u);
    uint _4471;
    if (_4356)
    {
        _4471 = _4388 << 2u;
    }
    else
    {
        _4471 = floatBitsToUint(_4464);
    }
    if (_4356)
    {
        _42._m0[uint(int(_4471 + 848u) >> int(2u))] = _4204.y;
    }
    uint _4482 = floatBitsToUint(_4325) & (((!isnan(_4325)) && (!isnan(_4325))) ? 4294967295u : 0u);
    uint _4491 = uint(clamp(floor(min(uintBitsToFloat(_4482), 4294967040.0)), 0.0, 4294967296.0)) | ((uintBitsToFloat(_4482) >= 4294967296.0) ? 4294967295u : 0u);
    uint _4492 = _4334 << 2u;
    _42._m0[uint(int(_4492) >> int(2u))] = _4211.x;
    uint _4497;
    if (!_4353)
    {
        _4497 = _4334 << 2u;
    }
    else
    {
        _4497 = _4492;
    }
    if (!_4353)
    {
        _42._m0[uint(int(_4497 + 16u) >> int(2u))] = _4258.x;
    }
    uint _4506;
    if (!_4350)
    {
        _4506 = _4334 << 2u;
    }
    else
    {
        _4506 = _4497;
    }
    if (!_4350)
    {
        _42._m0[uint(int(_4506 + 832u) >> int(2u))] = _4211.y;
    }
    uint _4512;
    if (_4356)
    {
        _4512 = _4334 << 2u;
    }
    else
    {
        _4512 = _4506;
    }
    if (_4356)
    {
        _42._m0[uint(int(_4512 + 848u) >> int(2u))] = _4258.y;
    }
    uint _4522 = floatBitsToUint(_4277) & (((!isnan(_4277)) && (!isnan(_4277))) ? 4294967295u : 0u);
    uint _4531 = uint(clamp(floor(min(uintBitsToFloat(_4522), 4294967040.0)), 0.0, 4294967296.0)) | ((uintBitsToFloat(_4522) >= 4294967296.0) ? 4294967295u : 0u);
    uint _4532 = _4345 << 2u;
    _42._m0[uint(int(_4532) >> int(2u))] = _4219.x;
    uint _4537;
    if (!_4353)
    {
        _4537 = _4345 << 2u;
    }
    else
    {
        _4537 = _4532;
    }
    if (!_4353)
    {
        _42._m0[uint(int(_4537 + 16u) >> int(2u))] = _4238.x;
    }
    uint _4546;
    if (!_4350)
    {
        _4546 = _4345 << 2u;
    }
    else
    {
        _4546 = _4537;
    }
    if (!_4350)
    {
        _42._m0[uint(int(_4546 + 832u) >> int(2u))] = _4219.y;
    }
    uint _4552;
    if (_4356)
    {
        _4552 = _4345 << 2u;
    }
    else
    {
        _4552 = _4546;
    }
    if (_4356)
    {
        _42._m0[uint(int(_4552 + 848u) >> int(2u))] = _4238.y;
    }
    uint _4556 = _4347 << 2u;
    _42._m0[uint(int(_4556) >> int(2u))] = _4251.x;
    uint _4561;
    if (!_4353)
    {
        _4561 = _4347 << 2u;
    }
    else
    {
        _4561 = _4556;
    }
    if (!_4353)
    {
        _42._m0[uint(int(_4561 + 16u) >> int(2u))] = _4282.x;
    }
    uint _4568;
    if (!_4350)
    {
        _4568 = _4347 << 2u;
    }
    else
    {
        _4568 = _4561;
    }
    if (!_4350)
    {
        _42._m0[uint(int(_4568 + 832u) >> int(2u))] = _4251.y;
    }
    uint _4574;
    if (_4356)
    {
        _4574 = _4347 << 2u;
    }
    else
    {
        _4574 = _4568;
    }
    if (_4356)
    {
        _42._m0[uint(int(_4574 + 848u) >> int(2u))] = _4282.y;
    }
    uint _4584 = floatBitsToUint(_4265) & (((!isnan(_4265)) && (!isnan(_4265))) ? 4294967295u : 0u);
    uint _4593 = uint(clamp(floor(min(uintBitsToFloat(_4584), 4294967040.0)), 0.0, 4294967296.0)) | ((uintBitsToFloat(_4584) >= 4294967296.0) ? 4294967295u : 0u);
    precise float _4596 = _4265 + uintBitsToFloat(floatBitsToUint(floor(_4265)) ^ 2147483648u);
    bool _4599 = _4381 > 46u;
    bool _4600 = _4444 > 46u;
    precise float _4607 = _4271 + uintBitsToFloat(floatBitsToUint(floor(_4271)) ^ 2147483648u);
    uint _4609 = _4599 ? 46u : _4381;
    bool _4610 = _4469 > 46u;
    uint _4617 = floatBitsToUint(_4245) & (((!isnan(_4245)) && (!isnan(_4245))) ? 4294967295u : 0u);
    uint _4626 = uint(clamp(floor(min(uintBitsToFloat(_4617), 4294967040.0)), 0.0, 4294967296.0)) | ((uintBitsToFloat(_4617) >= 4294967296.0) ? 4294967295u : 0u);
    bool _4627 = _4491 > 46u;
    precise float _4630 = _4339 + uintBitsToFloat(floatBitsToUint(floor(_4339)) ^ 2147483648u);
    uint _4634 = _4600 ? 46u : _4444;
    uint _4641 = floatBitsToUint(_4271) & (((!isnan(_4271)) && (!isnan(_4271))) ? 4294967295u : 0u);
    uint _4650 = uint(clamp(floor(min(uintBitsToFloat(_4641), 4294967040.0)), 0.0, 4294967296.0)) | ((uintBitsToFloat(_4641) >= 4294967296.0) ? 4294967295u : 0u);
    bool _4651 = _4531 > 46u;
    uint _4652 = _4610 ? 46u : _4469;
    uint _4653 = _4627 ? 46u : _4491;
    precise float _4656 = _4277 + uintBitsToFloat(floatBitsToUint(floor(_4277)) ^ 2147483648u);
    uint _4658 = _4651 ? 46u : _4531;
    bool _4667 = _4420 > 46u;
    uint _4683 = (((bitfieldExtract(_4634, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4634, int(0u), int(16u)) * 52u) + _4609)) << 1u;
    precise float _4686 = _4245 + uintBitsToFloat(floatBitsToUint(floor(_4245)) ^ 2147483648u);
    precise float _4690 = _4331 + uintBitsToFloat(floatBitsToUint(floor(_4331)) ^ 2147483648u);
    barrier();
    bool _4692 = _4626 > 46u;
    uint _4693 = (((bitfieldExtract(_4652, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4652, int(0u), int(16u)) * 52u) + _4609)) << 1u;
    bool _4694 = _4593 > 46u;
    uint _4695 = (((bitfieldExtract(_4653, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4653, int(0u), int(16u)) * 52u) + _4609)) << 1u;
    bool _4696 = _4650 > 46u;
    uint _4697 = _4667 ? 46u : _4420;
    uint _4709 = _4692 ? 46u : _4626;
    uint _4757 = (packHalf2x16(vec2(uintBitsToFloat(_4600 ? 1065353216u : floatBitsToUint(_4690)), 0.0)) << 16u) + packHalf2x16(vec2(uintBitsToFloat(_4599 ? 1065353216u : floatBitsToUint(_4359)), 0.0));
    uint _4772 = (((bitfieldExtract(_4634, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4634, int(0u), int(16u)) * 52u) + _4658)) << 1u;
    uint _4778 = _4694 ? 46u : _4593;
    uint _4779 = (((bitfieldExtract(_4652, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4652, int(0u), int(16u)) * 52u) + _4658)) << 1u;
    uint _4786 = (packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(uintBitsToFloat(_4627 ? 1065353216u : floatBitsToUint(_4397)), 0.0));
    uint _4792 = (((bitfieldExtract(_4634, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4634, int(0u), int(16u)) * 52u) + _4697)) << 1u;
    uint _4793 = _4696 ? 46u : _4650;
    uint _4819 = (packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(uintBitsToFloat(_4651 ? 1065353216u : floatBitsToUint(_4656)), 0.0));
    uint _4890 = (((bitfieldExtract(_4652, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4652, int(0u), int(16u)) * 52u) + _4697)) << 1u;
    uint _4899 = (uint(_36._m0[uint(int(_4693 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_4693) >> int(1u))]) & 65535u);
    uint _4900 = (((bitfieldExtract(_4653, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4653, int(0u), int(16u)) * 52u) + _4697)) << 1u;
    uint _4907 = (packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(uintBitsToFloat(_4610 ? 1065353216u : floatBitsToUint(_4630)), 0.0));
    uint _4908 = (((bitfieldExtract(_4653, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4653, int(0u), int(16u)) * 52u) + _4658)) << 1u;
    vec2 _4913 = unpackHalf2x16(_4899);
    vec2 _4916 = unpackHalf2x16(_4757);
    float _4917 = _4916.x;
    vec2 _4918 = unpackHalf2x16(_4899);
    uint _4931 = (packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(uintBitsToFloat(_4667 ? 1065353216u : floatBitsToUint(_4391)), 0.0));
    uint _4932 = (((bitfieldExtract(_4634, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4634, int(0u), int(16u)) * 52u) + _4709)) << 1u;
    uint _4941 = (((bitfieldExtract(_4653, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4653, int(0u), int(16u)) * 52u) + _4709)) << 1u;
    uint _4948 = (packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(uintBitsToFloat(_4692 ? 1065353216u : floatBitsToUint(_4686)), 0.0));
    vec2 _4949 = unpackHalf2x16((uint(_36._m0[uint(int(_4693 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_4693 + 2u) >> int(1u))]) & 65535u));
    vec2 _4952 = unpackHalf2x16(_4757);
    float _4953 = _4952.x;
    precise float _4954 = fma(_4949.x, _4953, fma(_4913.x, -_4917, _4918.x));
    uint _4963 = (uint(_36._m0[uint(int(_4695 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_4695) >> int(1u))]) & 65535u);
    uint _4978 = (packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(uintBitsToFloat(_4694 ? 1065353216u : floatBitsToUint(_4596)), 0.0));
    vec2 _4979 = unpackHalf2x16(_4963);
    vec2 _4982 = unpackHalf2x16(_4757);
    float _4983 = _4982.x;
    vec2 _4984 = unpackHalf2x16(_4963);
    precise float _5000 = fma(fma(_4949.y, _4953, fma(_4913.y, -_4917, _4918.y)), unpackHalf2x16(_4907).x, fma(_4954, -unpackHalf2x16(_4907).x, _4954));
    vec2 _5006 = unpackHalf2x16((uint(_36._m0[uint(int(_4695 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_4695 + 2u) >> int(1u))]) & 65535u));
    vec2 _5009 = unpackHalf2x16(_4757);
    float _5010 = _5009.x;
    precise float _5011 = fma(_5006.x, _5010, fma(_4979.x, -_4983, _4984.x));
    uint _5020 = (uint(_36._m0[uint(int(_4683 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_4683) >> int(1u))]) & 65535u);
    vec2 _5021 = unpackHalf2x16((packHalf2x16(vec2(_3980.y, 0.0)) << 16u) + packHalf2x16(vec2(_3980.x, 0.0)));
    precise float _5024 = _5021.x + _5000;
    precise float _5025 = _5021.y + _5000;
    precise float _5033 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_3980.z, 0.0))).x + _5000;
    vec2 _5034 = unpackHalf2x16(_5020);
    vec2 _5037 = unpackHalf2x16(_4757);
    float _5038 = _5037.x;
    vec2 _5039 = unpackHalf2x16(_5020);
    precise float _5056 = _5024 * abs(_5024);
    precise float _5057 = _5025 * abs(_5025);
    uint _5059 = packHalf2x16(vec2(_5056, _5057));
    vec2 _5070 = unpackHalf2x16((uint(_36._m0[uint(int(_4683 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_4683 + 2u) >> int(1u))]) & 65535u));
    vec2 _5073 = unpackHalf2x16(_4757);
    float _5074 = _5073.x;
    precise float _5075 = fma(_5070.x, _5074, fma(_5034.x, -_5038, _5039.x));
    precise float _5084 = fma(fma(_5006.y, _5010, fma(_4979.y, -_4983, _4984.y)), unpackHalf2x16(_4786).x, fma(_5011, -unpackHalf2x16(_4786).x, _5011));
    uint _5091 = (packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(uintBitsToFloat(_4696 ? 1065353216u : floatBitsToUint(_4607)), 0.0));
    precise float _5103 = fma(fma(_5070.y, _5074, fma(_5034.y, -_5038, _5039.y)), unpackHalf2x16(_4757).y, fma(_5075, -unpackHalf2x16(_4757).y, _5075));
    vec2 _5109 = unpackHalf2x16((packHalf2x16(vec2(_3848.y, 0.0)) << 16u) + packHalf2x16(vec2(_3848.x, 0.0)));
    precise float _5112 = _5109.x + _5103;
    precise float _5113 = _5109.y + _5103;
    precise float _5121 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_3848.z, 0.0))).x + _5103;
    precise float _5124 = _5112 * abs(_5112);
    precise float _5125 = _5113 * abs(_5113);
    precise float _5133 = _5121 * abs(_5121);
    precise float _5134 = _5121 * abs(_5121);
    uint _5144 = (uint(_36._m0[uint(int(_4772 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_4772) >> int(1u))]) & 65535u);
    uint _5147 = (uint(_36._m0[uint(int(_4792 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_4792) >> int(1u))]) & 65535u);
    uint _5154 = (uint(_36._m0[uint(int(_4908 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_4908) >> int(1u))]) & 65535u);
    vec2 _5155 = unpackHalf2x16(_5144);
    vec2 _5158 = unpackHalf2x16(_4819);
    float _5159 = _5158.x;
    vec2 _5160 = unpackHalf2x16(_5144);
    uint _5174 = (uint(_36._m0[uint(int(_4779 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_4779) >> int(1u))]) & 65535u);
    vec2 _5175 = unpackHalf2x16(_5147);
    vec2 _5178 = unpackHalf2x16(_4931);
    float _5179 = _5178.x;
    vec2 _5180 = unpackHalf2x16(_5147);
    vec2 _5191 = unpackHalf2x16(_5154);
    vec2 _5194 = unpackHalf2x16(_4819);
    float _5195 = _5194.x;
    vec2 _5196 = unpackHalf2x16(_5154);
    vec2 _5203 = unpackHalf2x16(_5174);
    vec2 _5206 = unpackHalf2x16(_4819);
    float _5207 = _5206.x;
    vec2 _5208 = unpackHalf2x16(_5174);
    vec2 _5228 = unpackHalf2x16((uint(_36._m0[uint(int(_4772 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_4772 + 2u) >> int(1u))]) & 65535u));
    vec2 _5231 = unpackHalf2x16(_4819);
    float _5232 = _5231.x;
    precise float _5233 = fma(_5228.x, _5232, fma(_5155.x, -_5159, _5160.x));
    vec2 _5248 = unpackHalf2x16((uint(_36._m0[uint(int(_4779 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_4779 + 2u) >> int(1u))]) & 65535u));
    vec2 _5251 = unpackHalf2x16(_4819);
    float _5252 = _5251.x;
    precise float _5253 = fma(_5248.x, _5252, fma(_5203.x, -_5207, _5208.x));
    vec2 _5271 = unpackHalf2x16((uint(_36._m0[uint(int(_4792 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_4792 + 2u) >> int(1u))]) & 65535u));
    vec2 _5274 = unpackHalf2x16(_4931);
    float _5275 = _5274.x;
    precise float _5276 = fma(_5271.x, _5275, fma(_5175.x, -_5179, _5180.x));
    vec2 _5290 = unpackHalf2x16((uint(_36._m0[uint(int(_4908 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_4908 + 2u) >> int(1u))]) & 65535u));
    vec2 _5293 = unpackHalf2x16(_4819);
    float _5294 = _5293.x;
    precise float _5295 = fma(_5290.x, _5294, fma(_5191.x, -_5195, _5196.x));
    precise float _5296 = fma(_5290.y, _5294, fma(_5191.y, -_5195, _5196.y));
    uint _5308 = (uint(_36._m0[uint(int(_4890 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_4890) >> int(1u))]) & 65535u);
    precise float _5312 = fma(_5295, -unpackHalf2x16(_4786).x, _5295);
    precise float _5320 = fma(fma(_5228.y, _5232, fma(_5155.y, -_5159, _5160.y)), unpackHalf2x16(_4757).y, fma(_5233, -unpackHalf2x16(_4757).y, _5233));
    precise float _5323 = fma(fma(_5248.y, _5252, fma(_5203.y, -_5207, _5208.y)), unpackHalf2x16(_4907).x, fma(_5253, -unpackHalf2x16(_4907).x, _5253));
    precise float _5331 = fma(fma(_5271.y, _5275, fma(_5175.y, -_5179, _5180.y)), unpackHalf2x16(_4757).y, fma(_5276, -unpackHalf2x16(_4757).y, _5276));
    uint _5334 = (uint(_36._m0[uint(int(_4900 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_4900) >> int(1u))]) & 65535u);
    vec2 _5335 = unpackHalf2x16(_5308);
    vec2 _5338 = unpackHalf2x16(_4931);
    float _5339 = _5338.x;
    vec2 _5340 = unpackHalf2x16(_5308);
    uint _5347 = (((bitfieldExtract(_4652, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4652, int(0u), int(16u)) * 52u) + _4709)) << 1u;
    uint _5353 = (((bitfieldExtract(_4652, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4652, int(0u), int(16u)) * 52u) + _4778)) << 1u;
    vec2 _5354 = unpackHalf2x16(_5334);
    vec2 _5357 = unpackHalf2x16(_4931);
    float _5358 = _5357.x;
    vec2 _5359 = unpackHalf2x16(_5334);
    uint _5366 = (((bitfieldExtract(_4652, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4652, int(0u), int(16u)) * 52u) + _4793)) << 1u;
    vec2 _5375 = unpackHalf2x16(_4786);
    float _5376 = _5375.x;
    precise float _5377 = fma(_5296, _5376, _5312);
    vec2 _5385 = unpackHalf2x16((packHalf2x16(vec2(_3887.y, 0.0)) << 16u) + packHalf2x16(vec2(_3887.x, 0.0)));
    precise float _5388 = _5385.x + _5320;
    precise float _5389 = _5385.y + _5320;
    vec2 _5390 = unpackHalf2x16((uint(_36._m0[uint(int(_4890 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_4890 + 2u) >> int(1u))]) & 65535u));
    vec2 _5393 = unpackHalf2x16(_4931);
    float _5394 = _5393.x;
    precise float _5395 = fma(_5390.x, _5394, fma(_5335.x, -_5339, _5340.x));
    uint _5405 = (((bitfieldExtract(_4634, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4634, int(0u), int(16u)) * 52u) + _4778)) << 1u;
    precise float _5416 = _5388 * abs(_5388);
    precise float _5417 = _5389 * abs(_5389);
    vec2 _5420 = unpackHalf2x16((uint(_36._m0[uint(int(_4900 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_4900 + 2u) >> int(1u))]) & 65535u));
    vec2 _5423 = unpackHalf2x16(_4931);
    float _5424 = _5423.x;
    precise float _5425 = fma(_5420.x, _5424, fma(_5354.x, -_5358, _5359.x));
    uint _5432 = (((bitfieldExtract(_4653, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4653, int(0u), int(16u)) * 52u) + _4778)) << 1u;
    precise float _5435 = fma(fma(_5390.y, _5394, fma(_5335.y, -_5339, _5340.y)), unpackHalf2x16(_4907).x, fma(_5395, -unpackHalf2x16(_4907).x, _5395));
    uint _5436 = (((bitfieldExtract(_4634, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4634, int(0u), int(16u)) * 52u) + _4793)) << 1u;
    uint _5447 = (uint(_36._m0[uint(int(_4932 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_4932) >> int(1u))]) & 65535u);
    uint _5448 = (((bitfieldExtract(_4653, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4653, int(0u), int(16u)) * 52u) + _4793)) << 1u;
    precise float _5456 = fma(fma(_5420.y, _5424, fma(_5354.y, -_5358, _5359.y)), unpackHalf2x16(_4786).x, fma(_5425, -unpackHalf2x16(_4786).x, _5425));
    uint _5459 = (packHalf2x16(vec2(_5416, _5417)) << 16u) + (packHalf2x16(vec2(_5133, _5134)) & 65535u);
    vec2 _5460 = unpackHalf2x16(_5447);
    vec2 _5463 = unpackHalf2x16(_4948);
    float _5464 = _5463.x;
    vec2 _5465 = unpackHalf2x16(_5447);
    vec2 _5480 = unpackHalf2x16((packHalf2x16(vec2(_3905.y, 0.0)) << 16u) + packHalf2x16(vec2(_3905.x, 0.0)));
    precise float _5483 = _5480.x + _5331;
    precise float _5484 = _5480.y + _5331;
    precise float _5492 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_3887.z, 0.0))).x + _5320;
    vec2 _5493 = unpackHalf2x16((uint(_36._m0[uint(int(_4932 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_4932 + 2u) >> int(1u))]) & 65535u));
    vec2 _5496 = unpackHalf2x16(_4948);
    float _5497 = _5496.x;
    precise float _5498 = fma(_5493.x, _5497, fma(_5460.x, -_5464, _5465.x));
    precise float _5507 = _5483 * abs(_5483);
    precise float _5508 = _5484 * abs(_5484);
    uint _5510 = packHalf2x16(vec2(_5507, _5508));
    precise float _5524 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_3905.z, 0.0))).x + _5331;
    precise float _5532 = fma(fma(_5493.y, _5497, fma(_5460.y, -_5464, _5465.y)), unpackHalf2x16(_4757).y, fma(_5498, -unpackHalf2x16(_4757).y, _5498));
    vec2 _5533 = unpackHalf2x16((packHalf2x16(vec2(_3998.y, 0.0)) << 16u) + packHalf2x16(vec2(_3998.x, 0.0)));
    precise float _5536 = _5533.x + _5323;
    precise float _5537 = _5533.y + _5323;
    uint _5544 = (uint(_36._m0[uint(int(_5347 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5347) >> int(1u))]) & 65535u);
    vec2 _5545 = unpackHalf2x16((packHalf2x16(vec2(_3926.y, 0.0)) << 16u) + packHalf2x16(vec2(_3926.x, 0.0)));
    precise float _5548 = _5545.x + _5532;
    precise float _5549 = _5545.y + _5532;
    precise float _5557 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_3926.z, 0.0))).x + _5532;
    vec2 _5558 = unpackHalf2x16(_5544);
    vec2 _5561 = unpackHalf2x16(_4948);
    float _5562 = _5561.x;
    vec2 _5563 = unpackHalf2x16(_5544);
    precise float _5577 = _5548 * abs(_5548);
    precise float _5578 = _5549 * abs(_5549);
    uint _5580 = packHalf2x16(vec2(_5577, _5578));
    precise float _5583 = _5536 * abs(_5536);
    precise float _5584 = _5537 * abs(_5537);
    uint _5594 = (uint(_36._m0[uint(int(_4941 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_4941) >> int(1u))]) & 65535u);
    vec2 _5595 = unpackHalf2x16((packHalf2x16(vec2(_4016.y, 0.0)) << 16u) + packHalf2x16(vec2(_4016.x, 0.0)));
    precise float _5598 = _5595.x + _5435;
    precise float _5599 = _5595.y + _5435;
    vec2 _5606 = unpackHalf2x16(968374712u);
    precise float _5609 = _5584 * _5606.x;
    precise float _5610 = _5584 * _5606.y;
    vec2 _5613 = unpackHalf2x16(_5594);
    vec2 _5616 = unpackHalf2x16(_4948);
    float _5617 = _5616.x;
    vec2 _5618 = unpackHalf2x16(_5594);
    precise float _5635 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_3998.z, 0.0))).x + _5323;
    vec2 _5640 = unpackHalf2x16((uint(_36._m0[uint(int(_4941 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_4941 + 2u) >> int(1u))]) & 65535u));
    vec2 _5643 = unpackHalf2x16(_4948);
    float _5644 = _5643.x;
    precise float _5645 = fma(_5640.x, _5644, fma(_5613.x, -_5617, _5618.x));
    uint _5649 = (uint(_36._m0[uint(int(_5353 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5353) >> int(1u))]) & 65535u);
    vec2 _5650 = unpackHalf2x16((uint(_36._m0[uint(int(_5347 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5347 + 2u) >> int(1u))]) & 65535u));
    vec2 _5653 = unpackHalf2x16(_4948);
    float _5654 = _5653.x;
    precise float _5655 = fma(_5650.x, _5654, fma(_5558.x, -_5562, _5563.x));
    vec2 _5673 = unpackHalf2x16(_5649);
    vec2 _5676 = unpackHalf2x16(_4978);
    float _5677 = _5676.x;
    vec2 _5678 = unpackHalf2x16(_5649);
    precise float _5687 = _5598 * abs(_5598);
    precise float _5688 = _5599 * abs(_5599);
    uint _5698 = (uint(_36._m0[uint(int(_5405 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5405) >> int(1u))]) & 65535u);
    vec2 _5699 = unpackHalf2x16((uint(_36._m0[uint(int(_5353 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5353 + 2u) >> int(1u))]) & 65535u));
    vec2 _5702 = unpackHalf2x16(_4978);
    float _5703 = _5702.x;
    precise float _5704 = fma(_5699.x, _5703, fma(_5673.x, -_5677, _5678.x));
    vec2 _5715 = unpackHalf2x16(_5698);
    vec2 _5718 = unpackHalf2x16(_4978);
    float _5719 = _5718.x;
    vec2 _5720 = unpackHalf2x16(_5698);
    precise float _5734 = fma(fma(_5650.y, _5654, fma(_5558.y, -_5562, _5563.y)), unpackHalf2x16(_4907).x, fma(_5655, -unpackHalf2x16(_4907).x, _5655));
    precise float _5737 = fma(fma(_5640.y, _5644, fma(_5613.y, -_5617, _5618.y)), unpackHalf2x16(_4786).x, fma(_5645, -unpackHalf2x16(_4786).x, _5645));
    uint _5745 = (uint(_36._m0[uint(int(_5432 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5432) >> int(1u))]) & 65535u);
    vec2 _5758 = unpackHalf2x16(_5745);
    vec2 _5761 = unpackHalf2x16(_4978);
    float _5762 = _5761.x;
    vec2 _5763 = unpackHalf2x16(_5745);
    vec2 _5774 = unpackHalf2x16(968374712u);
    precise float _5777 = _5688 * _5774.x;
    precise float _5778 = _5688 * _5774.y;
    vec2 _5781 = unpackHalf2x16((uint(_36._m0[uint(int(_5405 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5405 + 2u) >> int(1u))]) & 65535u));
    vec2 _5784 = unpackHalf2x16(_4978);
    float _5785 = _5784.x;
    precise float _5786 = fma(_5781.x, _5785, fma(_5715.x, -_5719, _5720.x));
    vec2 _5796 = unpackHalf2x16((packHalf2x16(vec2(_4034.y, 0.0)) << 16u) + packHalf2x16(vec2(_4034.x, 0.0)));
    precise float _5799 = _5796.x + _5734;
    precise float _5800 = _5796.y + _5734;
    vec2 _5810 = unpackHalf2x16((uint(_36._m0[uint(int(_5432 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5432 + 2u) >> int(1u))]) & 65535u));
    vec2 _5813 = unpackHalf2x16(_4978);
    float _5814 = _5813.x;
    precise float _5815 = fma(_5810.x, _5814, fma(_5758.x, -_5762, _5763.x));
    uint _5824 = (uint(_36._m0[uint(int(_5366 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5366) >> int(1u))]) & 65535u);
    precise float _5827 = fma(fma(_5781.y, _5785, fma(_5715.y, -_5719, _5720.y)), unpackHalf2x16(_4757).y, fma(_5786, -unpackHalf2x16(_4757).y, _5786));
    precise float _5830 = fma(fma(_5699.y, _5703, fma(_5673.y, -_5677, _5678.y)), unpackHalf2x16(_4907).x, fma(_5704, -unpackHalf2x16(_4907).x, _5704));
    vec2 _5832 = unpackHalf2x16(_5824);
    vec2 _5835 = unpackHalf2x16(_5091);
    float _5836 = _5835.x;
    vec2 _5837 = unpackHalf2x16(_5824);
    uint _5846 = (uint(_36._m0[uint(int(_5436 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5436) >> int(1u))]) & 65535u);
    vec2 _5847 = unpackHalf2x16((packHalf2x16(vec2(_3944.y, 0.0)) << 16u) + packHalf2x16(vec2(_3944.x, 0.0)));
    precise float _5850 = _5847.x + _5827;
    precise float _5851 = _5847.y + _5827;
    precise float _5854 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_3944.z, 0.0))).x + _5827;
    vec2 _5855 = unpackHalf2x16(_5846);
    vec2 _5858 = unpackHalf2x16(_5091);
    float _5859 = _5858.x;
    vec2 _5860 = unpackHalf2x16(_5846);
    precise float _5869 = _5850 * abs(_5850);
    precise float _5870 = _5851 * abs(_5851);
    uint _5872 = packHalf2x16(vec2(_5869, _5870));
    precise float _5878 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_4016.z, 0.0))).x + _5435;
    vec2 _5879 = unpackHalf2x16(968374712u);
    precise float _5882 = _5870 * _5879.x;
    precise float _5883 = _5870 * _5879.y;
    vec2 _5886 = unpackHalf2x16((uint(_36._m0[uint(int(_5366 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5366 + 2u) >> int(1u))]) & 65535u));
    vec2 _5889 = unpackHalf2x16(_5091);
    float _5890 = _5889.x;
    precise float _5891 = fma(_5886.x, _5890, fma(_5832.x, -_5836, _5837.x));
    precise float _5892 = fma(_5886.y, _5890, fma(_5832.y, -_5836, _5837.y));
    precise float _5897 = _5799 * abs(_5799);
    precise float _5898 = _5800 * abs(_5800);
    precise float _5906 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_4034.z, 0.0))).x + _5734;
    vec2 _5907 = unpackHalf2x16((uint(_36._m0[uint(int(_5436 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5436 + 2u) >> int(1u))]) & 65535u));
    vec2 _5910 = unpackHalf2x16(_5091);
    float _5911 = _5910.x;
    precise float _5912 = fma(_5907.x, _5911, fma(_5855.x, -_5859, _5860.x));
    uint _5914 = gl_SubgroupInvocationID & 7u;
    uint _5917 = (uint(_36._m0[uint(int(_5448 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5448) >> int(1u))]) & 65535u);
    vec2 _5925 = unpackHalf2x16(_5917);
    vec2 _5928 = unpackHalf2x16(_5091);
    float _5929 = _5928.x;
    vec2 _5930 = unpackHalf2x16(_5917);
    vec2 _5944 = unpackHalf2x16((uint(_36._m0[uint(int(_5448 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5448 + 2u) >> int(1u))]) & 65535u));
    vec2 _5947 = unpackHalf2x16(_5091);
    float _5948 = _5947.x;
    precise float _5949 = fma(_5944.x, _5948, fma(_5925.x, -_5929, _5930.x));
    precise float _5957 = fma(_5892, unpackHalf2x16(_4907).x, fma(_5891, -unpackHalf2x16(_4907).x, _5891));
    vec2 _5958 = unpackHalf2x16(968374712u);
    precise float _5960 = _5125 * _5958.x;
    precise float _5963 = fma(fma(_5907.y, _5911, fma(_5855.y, -_5859, _5860.y)), unpackHalf2x16(_4757).y, fma(_5912, -unpackHalf2x16(_4757).y, _5912));
    vec2 _5965 = unpackHalf2x16(852308685u);
    vec2 _5972 = unpackHalf2x16(968374712u);
    precise float _5975 = _5417 * _5972.x;
    precise float _5976 = _5417 * _5972.y;
    precise float _5992 = fma(fma(_5810.y, _5814, fma(_5758.y, -_5762, _5763.y)), unpackHalf2x16(_4786).x, fma(_5815, -unpackHalf2x16(_4786).x, _5815));
    precise float _5995 = fma(fma(_5944.y, _5948, fma(_5925.y, -_5929, _5930.y)), unpackHalf2x16(_4786).x, fma(_5949, -unpackHalf2x16(_4786).x, _5949));
    precise float _5998 = _5492 * abs(_5492);
    precise float _5999 = _5492 * abs(_5492);
    vec2 _6003 = unpackHalf2x16(_5459);
    vec2 _6006 = unpackHalf2x16(852307102u);
    vec2 _6009 = unpackHalf2x16((packHalf2x16(vec2(_5975, _5976)) << 16u) + (packHalf2x16(vec2(fma(_5124, _5965.x, _5960), fma(_5124, _5965.y, _5960))) & 65535u));
    uint _6015 = packHalf2x16(vec2(fma(_6003.x, _6006.x, _6009.x), fma(_6003.y, _6006.y, _6009.y)));
    vec2 _6016 = unpackHalf2x16(968374712u);
    precise float _6019 = _5508 * _6016.x;
    precise float _6020 = _5508 * _6016.y;
    uint _6025 = (_5510 << 16u) + (packHalf2x16(vec2(_5998, _5999)) & 65535u);
    precise float _6028 = _5524 * abs(_5524);
    precise float _6029 = _5524 * abs(_5524);
    vec2 _6036 = unpackHalf2x16((packHalf2x16(vec2(_3962.y, 0.0)) << 16u) + packHalf2x16(vec2(_3962.x, 0.0)));
    precise float _6039 = _6036.x + _5963;
    precise float _6040 = _6036.y + _5963;
    precise float _6046 = _5557 * abs(_5557);
    precise float _6047 = _5557 * abs(_5557);
    uint _6052 = (_5580 << 16u) + (packHalf2x16(vec2(_6028, _6029)) & 65535u);
    precise float _6055 = _6039 * abs(_6039);
    precise float _6056 = _6040 * abs(_6040);
    vec2 _6059 = unpackHalf2x16(_6025);
    vec2 _6062 = unpackHalf2x16(852307102u);
    vec2 _6065 = unpackHalf2x16((packHalf2x16(vec2(_6019, _6020)) << 16u) + (_6015 >> 16u));
    uint _6071 = packHalf2x16(vec2(fma(_6059.x, _6062.x, _6065.x), fma(_6059.y, _6062.y, _6065.y)));
    uint _6074 = (_5872 << 16u) + (packHalf2x16(vec2(_6046, _6047)) & 65535u);
    vec2 _6075 = unpackHalf2x16(968374712u);
    precise float _6078 = _5578 * _6075.x;
    precise float _6079 = _5578 * _6075.y;
    precise float _6084 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_3962.z, 0.0))).x + _5963;
    vec2 _6085 = unpackHalf2x16(968374712u);
    precise float _6088 = _5057 * _6085.x;
    precise float _6089 = _5057 * _6085.y;
    vec2 _6095 = unpackHalf2x16(_6052);
    vec2 _6098 = unpackHalf2x16(852307102u);
    vec2 _6101 = unpackHalf2x16((packHalf2x16(vec2(_6078, _6079)) << 16u) + (_6071 >> 16u));
    uint _6107 = packHalf2x16(vec2(fma(_6095.x, _6098.x, _6101.x), fma(_6095.y, _6098.y, _6101.y)));
    precise float _6110 = _5854 * abs(_5854);
    precise float _6111 = _5854 * abs(_5854);
    precise float _6119 = _6084 * abs(_6084);
    precise float _6120 = _6084 * abs(_6084);
    uint _6125 = (packHalf2x16(vec2(_6055, _6056)) << 16u) + (packHalf2x16(vec2(_6110, _6111)) & 65535u);
    vec2 _6126 = unpackHalf2x16(_6074);
    vec2 _6129 = unpackHalf2x16(852307102u);
    vec2 _6132 = unpackHalf2x16((packHalf2x16(vec2(_5882, _5883)) << 16u) + (_6107 >> 16u));
    uint _6138 = packHalf2x16(vec2(fma(_6126.x, _6129.x, _6132.x), fma(_6126.y, _6129.y, _6132.y)));
    uint _6141 = (_5059 << 16u) + (packHalf2x16(vec2(_6119, _6120)) & 65535u);
    vec2 _6142 = unpackHalf2x16(968374712u);
    precise float _6145 = _6056 * _6142.x;
    precise float _6146 = _6056 * _6142.y;
    precise float _6154 = _5033 * abs(_5033);
    precise float _6155 = _5033 * abs(_5033);
    vec2 _6158 = unpackHalf2x16(_6125);
    vec2 _6161 = unpackHalf2x16(852307102u);
    vec2 _6164 = unpackHalf2x16((packHalf2x16(vec2(_6145, _6146)) << 16u) + (_6138 >> 16u));
    uint _6170 = packHalf2x16(vec2(fma(_6158.x, _6161.x, _6164.x), fma(_6158.y, _6161.y, _6164.y)));
    uint _6173 = (packHalf2x16(vec2(_5583, _5584)) << 16u) + (packHalf2x16(vec2(_6154, _6155)) & 65535u);
    vec2 _6177 = unpackHalf2x16(_6141);
    vec2 _6180 = unpackHalf2x16(852307102u);
    vec2 _6183 = unpackHalf2x16((packHalf2x16(vec2(_6088, _6089)) << 16u) + (_6170 >> 16u));
    uint _6189 = packHalf2x16(vec2(fma(_6177.x, _6180.x, _6183.x), fma(_6177.y, _6180.y, _6183.y)));
    precise float _6192 = _5635 * abs(_5635);
    precise float _6193 = _5635 * abs(_5635);
    uint _6201 = (packHalf2x16(vec2(_5687, _5688)) << 16u) + (packHalf2x16(vec2(_6192, _6193)) & 65535u);
    vec2 _6202 = unpackHalf2x16(_6173);
    vec2 _6205 = unpackHalf2x16(852307102u);
    vec2 _6208 = unpackHalf2x16((packHalf2x16(vec2(_5609, _5610)) << 16u) + (_6189 >> 16u));
    uint _6214 = packHalf2x16(vec2(fma(_6202.x, _6205.x, _6208.x), fma(_6202.y, _6205.y, _6208.y)));
    precise float _6217 = _5878 * abs(_5878);
    precise float _6218 = _5878 * abs(_5878);
    precise float _6226 = _5906 * abs(_5906);
    precise float _6227 = _5906 * abs(_5906);
    vec2 _6230 = unpackHalf2x16(_6201);
    vec2 _6233 = unpackHalf2x16(852307102u);
    vec2 _6236 = unpackHalf2x16((packHalf2x16(vec2(_5777, _5778)) << 16u) + (_6214 >> 16u));
    uint _6242 = packHalf2x16(vec2(fma(_6230.x, _6233.x, _6236.x), fma(_6230.y, _6233.y, _6236.y)));
    vec2 _6243 = unpackHalf2x16(968374712u);
    precise float _6246 = _5898 * _6243.x;
    precise float _6247 = _5898 * _6243.y;
    uint _6252 = (packHalf2x16(vec2(_6246, _6247)) << 16u) + (_6242 >> 16u);
    uint _6253 = (((bitfieldExtract(_3610, int(16u), int(16u)) * 48u) << 16u) + ((bitfieldExtract(_3610, int(0u), int(16u)) * 48u) + _5914)) << 1u;
    barrier();
    vec2 _6254 = unpackHalf2x16((packHalf2x16(vec2(_4052.y, 0.0)) << 16u) + packHalf2x16(vec2(_4052.x, 0.0)));
    precise float _6257 = _6254.x + _5830;
    precise float _6258 = _6254.y + _5830;
    uint _6261 = (packHalf2x16(vec2(_5897, _5898)) << 16u) + (packHalf2x16(vec2(_6217, _6218)) & 65535u);
    precise float _6264 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_4052.z, 0.0))).x + _5830;
    _36._m0[uint(int(_6253 + 32u) >> int(1u))] = uint16_t(_6107);
    precise float _6271 = _6257 * abs(_6257);
    precise float _6272 = _6258 * abs(_6258);
    vec2 _6275 = unpackHalf2x16(_6261);
    vec2 _6278 = unpackHalf2x16(852307102u);
    vec2 _6281 = unpackHalf2x16(_6252);
    uint _6287 = packHalf2x16(vec2(fma(_6275.x, _6278.x, _6281.x), fma(_6275.y, _6278.y, _6281.y)));
    vec2 _6291 = unpackHalf2x16(968374712u);
    precise float _6294 = _6272 * _6291.x;
    precise float _6295 = _6272 * _6291.y;
    uint _6300 = (packHalf2x16(vec2(_6271, _6272)) << 16u) + (packHalf2x16(vec2(_6226, _6227)) & 65535u);
    vec2 _6301 = unpackHalf2x16((packHalf2x16(vec2(_4070.y, 0.0)) << 16u) + packHalf2x16(vec2(_4070.x, 0.0)));
    precise float _6304 = _6301.x + _5957;
    precise float _6305 = _6301.y + _5957;
    _36._m0[uint(int(_6253 + 48u) >> int(1u))] = uint16_t(_6138);
    precise float _6312 = _6264 * abs(_6264);
    precise float _6313 = _6264 * abs(_6264);
    precise float _6321 = _6304 * abs(_6304);
    precise float _6322 = _6305 * abs(_6305);
    _36._m0[uint(int(_6253 + 64u) >> int(1u))] = uint16_t(_6170);
    precise float _6332 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_4070.z, 0.0))).x + _5957;
    vec2 _6333 = unpackHalf2x16(_6300);
    vec2 _6336 = unpackHalf2x16(852307102u);
    vec2 _6339 = unpackHalf2x16((packHalf2x16(vec2(_6294, _6295)) << 16u) + (_6287 >> 16u));
    uint _6345 = packHalf2x16(vec2(fma(_6333.x, _6336.x, _6339.x), fma(_6333.y, _6336.y, _6339.y)));
    uint _6348 = (packHalf2x16(vec2(_6321, _6322)) << 16u) + (packHalf2x16(vec2(_6312, _6313)) & 65535u);
    vec2 _6349 = unpackHalf2x16(968374712u);
    precise float _6352 = _6322 * _6349.x;
    precise float _6353 = _6322 * _6349.y;
    _36._m0[uint(int(_6253 + 80u) >> int(1u))] = uint16_t(_6189);
    vec2 _6361 = unpackHalf2x16((packHalf2x16(vec2(_4088.y, 0.0)) << 16u) + packHalf2x16(vec2(_4088.x, 0.0)));
    precise float _6364 = _6361.x + _5084;
    precise float _6365 = _6361.y + _5084;
    precise float _6368 = _6332 * abs(_6332);
    precise float _6369 = _6332 * abs(_6332);
    precise float _6377 = _6364 * abs(_6364);
    precise float _6378 = _6365 * abs(_6365);
    vec2 _6384 = unpackHalf2x16((packHalf2x16(vec2(_4106.y, 0.0)) << 16u) + packHalf2x16(vec2(_4106.x, 0.0)));
    precise float _6387 = _6384.x + _5377;
    precise float _6388 = _6384.y + _5377;
    _36._m0[uint(int(_6253 + 400u) >> int(1u))] = uint16_t(_6242);
    vec2 _6396 = unpackHalf2x16(_6348);
    vec2 _6399 = unpackHalf2x16(852307102u);
    vec2 _6402 = unpackHalf2x16((packHalf2x16(vec2(_6352, _6353)) << 16u) + (_6345 >> 16u));
    uint _6408 = packHalf2x16(vec2(fma(_6396.x, _6399.x, _6402.x), fma(_6396.y, _6399.y, _6402.y)));
    uint _6411 = (packHalf2x16(vec2(_6377, _6378)) << 16u) + (packHalf2x16(vec2(_6368, _6369)) & 65535u);
    vec2 _6412 = unpackHalf2x16(968374712u);
    precise float _6415 = _6378 * _6412.x;
    precise float _6416 = _6378 * _6412.y;
    _36._m0[uint(int(_6253 + 432u) >> int(1u))] = uint16_t((_6345 & 65535u) + (_6170 & 4294901760u));
    precise float _6426 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_4088.z, 0.0))).x + _5084;
    vec2 _6427 = unpackHalf2x16((packHalf2x16(vec2(_4124.y, 0.0)) << 16u) + packHalf2x16(vec2(_4124.x, 0.0)));
    precise float _6430 = _6427.x + _5456;
    precise float _6431 = _6427.y + _5456;
    _36._m0[uint(int(_6253 + 384u) >> int(1u))] = uint16_t(_6214);
    precise float _6439 = _6426 * abs(_6426);
    precise float _6440 = _6426 * abs(_6426);
    precise float _6445 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_4106.z, 0.0))).x + _5377;
    vec2 _6448 = unpackHalf2x16((packHalf2x16(vec2(_4142.y, 0.0)) << 16u) + packHalf2x16(vec2(_4142.x, 0.0)));
    precise float _6451 = _6448.x + _5737;
    precise float _6452 = _6448.y + _5737;
    precise float _6458 = _6387 * abs(_6387);
    precise float _6459 = _6388 * abs(_6388);
    precise float _6467 = _6445 * abs(_6445);
    precise float _6468 = _6445 * abs(_6445);
    _36._m0[uint(int(_6253 + 416u) >> int(1u))] = uint16_t(_6287);
    vec2 _6476 = unpackHalf2x16(_6411);
    vec2 _6479 = unpackHalf2x16(852307102u);
    vec2 _6482 = unpackHalf2x16((packHalf2x16(vec2(_6415, _6416)) << 16u) + (_6408 >> 16u));
    uint _6488 = packHalf2x16(vec2(fma(_6476.x, _6479.x, _6482.x), fma(_6476.y, _6479.y, _6482.y)));
    uint _6491 = (packHalf2x16(vec2(_6458, _6459)) << 16u) + (packHalf2x16(vec2(_6439, _6440)) & 65535u);
    vec2 _6492 = unpackHalf2x16(968374712u);
    precise float _6495 = _6459 * _6492.x;
    precise float _6496 = _6459 * _6492.y;
    _36._m0[uint(int(_6253 + 448u) >> int(1u))] = uint16_t((_6408 & 65535u) + (packHalf2x16(vec2(_6387, _6388)) & 4294901760u));
    precise float _6506 = _6430 * abs(_6430);
    precise float _6507 = _6431 * abs(_6431);
    precise float _6515 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_4124.z, 0.0))).x + _5456;
    uint _6523 = (packHalf2x16(vec2(_6506, _6507)) << 16u) + (packHalf2x16(vec2(_6467, _6468)) & 65535u);
    precise float _6526 = _6451 * abs(_6451);
    precise float _6527 = _6452 * abs(_6452);
    vec2 _6530 = unpackHalf2x16(_6491);
    vec2 _6533 = unpackHalf2x16(852307102u);
    vec2 _6536 = unpackHalf2x16((packHalf2x16(vec2(_6495, _6496)) << 16u) + (_6488 >> 16u));
    uint _6542 = packHalf2x16(vec2(fma(_6530.x, _6533.x, _6536.x), fma(_6530.y, _6533.y, _6536.y)));
    _36._m0[uint(int(_6253) >> int(1u))] = uint16_t((_6015 & 65535u) + (packHalf2x16(vec2(_5891, _5892)) & 4294901760u));
    vec2 _6546 = unpackHalf2x16(968374712u);
    precise float _6549 = _6507 * _6546.x;
    precise float _6550 = _6507 * _6546.y;
    precise float _6555 = _6515 * abs(_6515);
    precise float _6556 = _6515 * abs(_6515);
    _36._m0[uint(int(_6253 + 16u) >> int(1u))] = uint16_t((_6071 & 65535u) + (_6252 & 4294901760u));
    vec2 _6563 = unpackHalf2x16(968374712u);
    precise float _6566 = _6527 * _6563.x;
    precise float _6567 = _6527 * _6563.y;
    vec2 _6573 = unpackHalf2x16((packHalf2x16(vec2(_4160.y, 0.0)) << 16u) + packHalf2x16(vec2(_4160.x, 0.0)));
    precise float _6576 = _6573.x + _5992;
    precise float _6577 = _6573.y + _5992;
    uint _6580 = (packHalf2x16(vec2(_6526, _6527)) << 16u) + (packHalf2x16(vec2(_6555, _6556)) & 65535u);
    precise float _6583 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_4142.z, 0.0))).x + _5737;
    _36._m0[uint(int(_6253 + 464u) >> int(1u))] = uint16_t((_6488 & 65535u) + (packHalf2x16(vec2(_5377, fma(_5296, _5376, _5312))) & 4294901760u));
    vec2 _6589 = unpackHalf2x16(_6523);
    vec2 _6592 = unpackHalf2x16(852307102u);
    vec2 _6595 = unpackHalf2x16((packHalf2x16(vec2(_6549, _6550)) << 16u) + (_6542 >> 16u));
    uint _6601 = packHalf2x16(vec2(fma(_6589.x, _6592.x, _6595.x), fma(_6589.y, _6592.y, _6595.y)));
    precise float _6604 = _6576 * abs(_6576);
    precise float _6605 = _6577 * abs(_6577);
    precise float _6610 = _6583 * abs(_6583);
    precise float _6611 = _6583 * abs(_6583);
    vec2 _6617 = unpackHalf2x16(968374712u);
    precise float _6620 = _6605 * _6617.x;
    precise float _6621 = _6605 * _6617.y;
    _36._m0[uint(int(_6253 + 784u) >> int(1u))] = uint16_t(_6601);
    vec2 _6629 = unpackHalf2x16((packHalf2x16(vec2(_4178.y, 0.0)) << 16u) + packHalf2x16(vec2(_4178.x, 0.0)));
    precise float _6632 = _6629.x + _5995;
    precise float _6633 = _6629.y + _5995;
    uint _6636 = (packHalf2x16(vec2(_6604, _6605)) << 16u) + (packHalf2x16(vec2(_6610, _6611)) & 65535u);
    vec2 _6637 = unpackHalf2x16(_6580);
    vec2 _6640 = unpackHalf2x16(852307102u);
    vec2 _6643 = unpackHalf2x16((packHalf2x16(vec2(_6566, _6567)) << 16u) + (_6601 >> 16u));
    uint _6649 = packHalf2x16(vec2(fma(_6637.x, _6640.x, _6643.x), fma(_6637.y, _6640.y, _6643.y)));
    precise float _6653 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_4160.z, 0.0))).x + _5992;
    precise float _6656 = _6632 * abs(_6632);
    precise float _6657 = _6633 * abs(_6633);
    precise float _6665 = _6653 * abs(_6653);
    precise float _6666 = _6653 * abs(_6653);
    vec2 _6670 = unpackHalf2x16(968374712u);
    precise float _6673 = _6657 * _6670.x;
    precise float _6674 = _6657 * _6670.y;
    uint _6677 = (gl_LocalInvocationID.x & 7u) * 3u;
    vec2 _6678 = unpackHalf2x16(_6636);
    vec2 _6681 = unpackHalf2x16(852307102u);
    vec2 _6684 = unpackHalf2x16((packHalf2x16(vec2(_6620, _6621)) << 16u) + (_6649 >> 16u));
    uint _6690 = packHalf2x16(vec2(fma(_6678.x, _6681.x, _6684.x), fma(_6678.y, _6681.y, _6684.y)));
    uint _6693 = (packHalf2x16(vec2(_6656, _6657)) << 16u) + (packHalf2x16(vec2(_6665, _6666)) & 65535u);
    uint _6694 = (gl_LocalInvocationID.x >> 3u) * 3u;
    precise float _6698 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_4178.z, 0.0))).x + _5995;
    _36._m0[uint(int(_6253 + 800u) >> int(1u))] = uint16_t(_6649);
    precise float _6709 = _6698 * abs(_6698);
    vec2 _6711 = unpackHalf2x16(_6693);
    vec2 _6714 = unpackHalf2x16(852307102u);
    vec2 _6717 = unpackHalf2x16((packHalf2x16(vec2(_6673, _6674)) << 16u) + (_6690 >> 16u));
    precise float _6721 = fma(_6711.y, _6714.y, _6717.y);
    uint _6724 = (gl_LocalInvocationID.x & 7u) * 6u;
    uint _6725 = uint(max(int(0u), int(_6694 + 4294967295u)));
    uint _6727 = uint(min(int(_6694 + 3u), int(47u)));
    _36._m0[uint(int(_6253 + 832u) >> int(1u))] = uint16_t(packHalf2x16(vec2(fma(_6711.x, _6714.x, _6717.x), _6721)));
    uint _6732 = _6724 + 4294967295u;
    uint _6739 = ((bitfieldExtract(_6725, int(16u), int(16u)) * 24u) << 16u) + ((bitfieldExtract(_6725, int(0u), int(16u)) * 24u) + _6677);
    uint _6747 = ((bitfieldExtract(_6727, int(16u), int(16u)) * 24u) << 16u) + ((bitfieldExtract(_6727, int(0u), int(16u)) * 24u) + _6677);
    uint _6748 = gl_LocalInvocationID.x >> 3u;
    uint _6758 = ((bitfieldExtract(_6748, int(16u), int(16u)) * 72u) << 16u) + ((bitfieldExtract(_6748, int(0u), int(16u)) * 72u) + _6677);
    vec2 _6771 = unpackHalf2x16(748563614u);
    _36._m0[uint(int(_6253 + 768u) >> int(1u))] = uint16_t((_6542 & 65535u) + (_6732 & 4294901760u));
    uint _6793 = (((bitfieldExtract(_6748, int(16u), int(16u)) * 144u) << 16u) + ((bitfieldExtract(_6748, int(0u), int(16u)) * 144u) + uint(max(int(0u), int(_6732))))) << 1u;
    _36._m0[uint(int(_6253 + 816u) >> int(1u))] = uint16_t((_6690 & 65535u) + (_6748 & 4294901760u));
    uint _6799 = (((bitfieldExtract(_6748, int(16u), int(16u)) * 144u) << 16u) + ((bitfieldExtract(_6748, int(0u), int(16u)) * 144u) + uint(min(int(_6724 + 6u), int(47u))))) << 1u;
    _36._m0[uint(int(_6253 + 848u) >> int(1u))] = uint16_t(packHalf2x16(vec2(fma(_6709, _6771.x, _6721), fma(_6709, _6771.y, _6721))));
    barrier();
    precise float _6810 = c0_1.data[32u] * (-0.125);
    precise float _6813 = c0_1.data[32u] * 0.5;
    uint _6818 = uint(int((_6758 << 2u) + 4u) >> int(2u));
    uint _6820 = _42._m0[_6818];
    uint _6828 = (packHalf2x16(vec2(_6813, 0.0)) << 16u) + packHalf2x16(vec2(_6810, 0.0));
    uint _6831 = uint(int((_6758 << 2u) + 8u) >> int(2u));
    uint _6833 = _42._m0[_6831];
    uint _6835 = uint(int(_6758 << 2u) >> int(2u));
    uint _6837 = _42._m0[_6835];
    uint _6845 = uint(int(_6747 << 2u) >> int(2u));
    uint _6852 = -gl_WorkGroupID.x;
    uint _6855 = uint(int((_6758 << 2u) + 96u) >> int(2u));
    uint _6857 = _42._m0[_6855];
    uint _6879 = min(((((bitfieldExtract(_6852, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(16u), int(16u))) + (bitfieldExtract(_6852, int(16u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u)))) << 16u) + ((bitfieldExtract(_6852, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u))) + c0.data[28u])), c0.data[22u]);
    uint _6883 = uint(int((_6758 << 2u) + 100u) >> int(2u));
    uint _6885 = _42._m0[_6883];
    bool _6886 = _5914 >= _6879;
    uint _6897 = uint(int((_6747 << 2u) + 8u) >> int(2u));
    uint _6902 = (_6833 << 16u) + (_6820 >> 16u);
    uint _6905 = uint(int((_6747 << 2u) + 4u) >> int(2u));
    uint _6910 = (_6820 << 16u) + (_6837 >> 16u);
    uint _6913 = uint(int((_6758 << 2u) + 104u) >> int(2u));
    uint _6915 = _42._m0[_6913];
    uint _6919 = _42._m0[uint(int(_6739 << 2u) >> int(2u))];
    vec2 _6920 = unpackHalf2x16(_6902);
    vec2 _6923 = unpackHalf2x16(_6828);
    float _6924 = _6923.x;
    precise float _6925 = _6920.x * _6924;
    precise float _6926 = _6920.y * _6924;
    uint _6932 = -gl_WorkGroupID.y;
    vec2 _6936 = unpackHalf2x16(_6910);
    vec2 _6939 = unpackHalf2x16(_6828);
    float _6940 = _6939.x;
    uint _6947 = _42._m0[uint(int((_6739 << 2u) + 4u) >> int(2u))];
    vec2 _6967 = unpackHalf2x16(_6910);
    vec2 _6970 = unpackHalf2x16(_6828);
    float _6971 = _6970.x;
    precise float _6972 = _6967.x * _6971;
    precise float _6973 = _6967.y * _6971;
    uint _6976 = uint(int((_6758 << 2u) + 192u) >> int(2u));
    uint _6978 = _42._m0[_6976];
    vec2 _6982 = unpackHalf2x16((_6837 << 16u) + (uint(_36._m0[uint(int(_6793) >> int(1u))]) & 65535u));
    vec2 _6985 = unpackHalf2x16(_6828);
    float _6986 = _6985.x;
    uint _6992 = uint(int((_6758 << 2u) + 196u) >> int(2u));
    uint _6994 = _42._m0[_6992];
    vec2 _6995 = unpackHalf2x16(_6857);
    vec2 _6998 = unpackHalf2x16(_6828);
    float _6999 = _6998.x;
    precise float _7000 = _6995.x * _6999;
    precise float _7001 = _6995.y * _6999;
    vec2 _7004 = unpackHalf2x16(_6885);
    vec2 _7007 = unpackHalf2x16(_6828);
    float _7008 = _7007.x;
    precise float _7009 = _7004.x * _7008;
    precise float _7010 = _7004.y * _7008;
    uint _7012 = packHalf2x16(vec2(_7009, _7010));
    vec2 _7018 = unpackHalf2x16(_6837);
    vec2 _7021 = unpackHalf2x16(_6828);
    float _7022 = _7021.y;
    vec2 _7025 = unpackHalf2x16((uint(_36._m0[uint(int(_6799) >> int(1u))]) << 16u) + (_6833 >> 16u));
    vec2 _7028 = unpackHalf2x16(_6828);
    float _7029 = _7028.x;
    precise float _7030 = _7025.x * _7029;
    precise float _7031 = _7025.y * _7029;
    uint _7036 = _42._m0[uint(int((_6739 << 2u) + 8u) >> int(2u))];
    vec2 _7037 = unpackHalf2x16(_6820);
    vec2 _7040 = unpackHalf2x16(_6828);
    float _7041 = _7040.y;
    precise float _7047 = fma(_7018.x, _7022, _7000) + fma(_6982.x, _6986, _6972);
    precise float _7048 = fma(_7018.y, _7022, _7001) + fma(_6982.y, _6986, _6973);
    uint _7052 = uint(int((_6758 << 2u) + 200u) >> int(2u));
    vec2 _7058 = unpackHalf2x16(_6902);
    vec2 _7061 = unpackHalf2x16(_6828);
    float _7062 = _7061.x;
    precise float _7068 = fma(_7037.x, _7041, _7009) + fma(_6936.x, _6940, _6925);
    precise float _7069 = fma(_7037.y, _7041, _7010) + fma(_6936.y, _6940, _6926);
    vec2 _7073 = unpackHalf2x16((_42._m0[_6845] << 16u) + (uint(_36._m0[uint(int(_6799 + 96u) >> int(1u))]) & 65535u));
    vec2 _7076 = unpackHalf2x16(_6828);
    float _7077 = _7076.x;
    precise float _7078 = _7073.x * _7077;
    precise float _7079 = _7073.y * _7077;
    uint _7081 = packHalf2x16(vec2(_7078, _7079));
    vec2 _7085 = unpackHalf2x16(_6915);
    vec2 _7088 = unpackHalf2x16(_6828);
    float _7089 = _7088.x;
    precise float _7090 = _7085.x * _7089;
    precise float _7091 = _7085.y * _7089;
    uint _7093 = packHalf2x16(vec2(_7090, _7091));
    vec2 _7094 = unpackHalf2x16((uint(_36._m0[uint(int(_6799 + 192u) >> int(1u))]) << 16u) + (_42._m0[_6897] >> 16u));
    vec2 _7097 = unpackHalf2x16(_6828);
    float _7098 = _7097.x;
    precise float _7099 = _7094.x * _7098;
    precise float _7100 = _7094.y * _7098;
    uint _7102 = packHalf2x16(vec2(_7099, _7100));
    vec2 _7103 = unpackHalf2x16(_6919);
    vec2 _7106 = unpackHalf2x16(_6828);
    float _7107 = _7106.x;
    vec2 _7118 = unpackHalf2x16((_42._m0[_6905] << 16u) + (_42._m0[_6845] >> 16u));
    vec2 _7121 = unpackHalf2x16(_6828);
    float _7122 = _7121.x;
    precise float _7123 = _7118.x * _7122;
    precise float _7124 = _7118.y * _7122;
    uint _7126 = packHalf2x16(vec2(_7123, _7124));
    vec2 _7130 = unpackHalf2x16(_6947);
    vec2 _7133 = unpackHalf2x16(_6828);
    float _7134 = _7133.x;
    vec2 _7142 = unpackHalf2x16((_6857 << 16u) + (uint(_36._m0[uint(int(_6793 + 96u) >> int(1u))]) & 65535u));
    vec2 _7145 = unpackHalf2x16(_6828);
    float _7146 = _7145.x;
    vec2 _7147 = unpackHalf2x16((_7012 << 16u) + (packHalf2x16(vec2(_7000, _7001)) >> 16u));
    vec2 _7155 = unpackHalf2x16((_6915 << 16u) + (_6885 >> 16u));
    vec2 _7158 = unpackHalf2x16(_6828);
    float _7159 = _7158.x;
    vec2 _7160 = unpackHalf2x16((_7081 << 16u) + (_7093 >> 16u));
    vec2 _7165 = unpackHalf2x16((_6885 << 16u) + (_6857 >> 16u));
    vec2 _7168 = unpackHalf2x16(_6828);
    float _7169 = _7168.x;
    vec2 _7170 = unpackHalf2x16((_7093 << 16u) + (_7012 >> 16u));
    vec2 _7175 = unpackHalf2x16(_6978);
    vec2 _7178 = unpackHalf2x16(_6828);
    float _7179 = _7178.x;
    precise float _7180 = _7175.x * _7179;
    precise float _7181 = _7175.y * _7179;
    vec2 _7184 = unpackHalf2x16(_6994);
    vec2 _7187 = unpackHalf2x16(_6828);
    float _7188 = _7187.x;
    precise float _7189 = _7184.x * _7188;
    precise float _7190 = _7184.y * _7188;
    uint _7192 = packHalf2x16(vec2(_7189, _7190));
    vec2 _7193 = unpackHalf2x16(_6857);
    vec2 _7196 = unpackHalf2x16(_6828);
    float _7197 = _7196.y;
    vec2 _7203 = unpackHalf2x16(_6833);
    vec2 _7206 = unpackHalf2x16(_6828);
    float _7207 = _7206.y;
    vec2 _7213 = unpackHalf2x16(_6885);
    vec2 _7216 = unpackHalf2x16(_6828);
    float _7217 = _7216.y;
    precise float _7220 = fma(_7203.x, _7207, _7090) + fma(_7058.x, _7062, _7030);
    precise float _7221 = fma(_7203.y, _7207, _7091) + fma(_7058.y, _7062, _7031);
    vec2 _7222 = unpackHalf2x16((_6978 << 16u) + (uint(_36._m0[uint(int(_6793 + 192u) >> int(1u))]) & 65535u));
    vec2 _7225 = unpackHalf2x16(_6828);
    float _7226 = _7225.x;
    vec2 _7227 = unpackHalf2x16((_7192 << 16u) + (packHalf2x16(vec2(_7180, _7181)) >> 16u));
    vec2 _7232 = unpackHalf2x16((_42._m0[_6897] << 16u) + (_42._m0[_6905] >> 16u));
    vec2 _7235 = unpackHalf2x16(_6828);
    float _7236 = _7235.x;
    precise float _7237 = _7232.x * _7236;
    precise float _7238 = _7232.y * _7236;
    uint _7240 = packHalf2x16(vec2(_7237, _7238));
    vec2 _7241 = unpackHalf2x16(_7036);
    vec2 _7244 = unpackHalf2x16(_6828);
    float _7245 = _7244.x;
    uint _7249 = packHalf2x16(vec2(fma(_7241.x, _7245, _7220), fma(_7241.y, _7245, _7221)));
    precise float _7250 = fma(_7213.x, _7217, _7189) + fma(_7165.x, _7169, _7170.x);
    precise float _7251 = fma(_7213.y, _7217, _7190) + fma(_7165.y, _7169, _7170.y);
    vec2 _7255 = unpackHalf2x16(_42._m0[_7052]);
    vec2 _7258 = unpackHalf2x16(_6828);
    float _7259 = _7258.x;
    precise float _7260 = _7255.x * _7259;
    precise float _7261 = _7255.y * _7259;
    uint _7263 = packHalf2x16(vec2(_7260, _7261));
    vec2 _7267 = unpackHalf2x16(_6978);
    vec2 _7270 = unpackHalf2x16(_6828);
    float _7271 = _7270.y;
    vec2 _7272 = unpackHalf2x16((_7126 << 16u) + (_7081 >> 16u));
    vec2 _7277 = unpackHalf2x16(_42._m0[_7052]);
    vec2 _7280 = unpackHalf2x16(_6828);
    float _7281 = _7280.y;
    vec2 _7282 = unpackHalf2x16((_7102 << 16u) + (_7240 >> 16u));
    vec2 _7290 = unpackHalf2x16(_6994);
    vec2 _7293 = unpackHalf2x16(_6828);
    float _7294 = _7293.y;
    vec2 _7295 = unpackHalf2x16((_7240 << 16u) + (_7126 >> 16u));
    vec2 _7303 = unpackHalf2x16(_6820);
    vec2 _7306 = unpackHalf2x16(_6828);
    float _7307 = _7306.x;
    vec2 _7315 = unpackHalf2x16(_6915);
    vec2 _7318 = unpackHalf2x16(_6828);
    float _7319 = _7318.y;
    vec2 _7325 = unpackHalf2x16((_42._m0[_7052] << 16u) + (_6994 >> 16u));
    vec2 _7328 = unpackHalf2x16(_6828);
    float _7329 = _7328.x;
    vec2 _7330 = unpackHalf2x16((_7263 >> 16u) + (_7102 & 4294901760u));
    precise float _7335 = fma(_7193.x, _7197, _7180) + fma(_7142.x, _7146, _7147.x);
    precise float _7336 = fma(_7193.y, _7197, _7181) + fma(_7142.y, _7146, _7147.y);
    vec2 _7337 = unpackHalf2x16((_6994 << 16u) + (_6978 >> 16u));
    vec2 _7340 = unpackHalf2x16(_6828);
    float _7341 = _7340.x;
    vec2 _7342 = unpackHalf2x16((_7263 << 16u) + (_7192 >> 16u));
    precise float _7345 = fma(_7337.x, _7341, _7342.x);
    precise float _7346 = fma(_7337.y, _7341, _7342.y);
    precise float _7349 = fma(_7267.x, _7271, _7272.x) + fma(_7222.x, _7226, _7227.x);
    precise float _7350 = fma(_7267.y, _7271, _7272.y) + fma(_7222.y, _7226, _7227.y);
    precise float _7351 = fma(_7277.x, _7281, _7282.x) + fma(_7325.x, _7329, _7330.x);
    precise float _7352 = fma(_7277.y, _7281, _7282.y) + fma(_7325.y, _7329, _7330.y);
    precise float _7353 = fma(_7290.x, _7294, _7295.x) + _7345;
    precise float _7354 = fma(_7290.y, _7294, _7295.y) + _7346;
    precise float _7355 = fma(_7315.x, _7319, _7260) + fma(_7155.x, _7159, _7160.x);
    precise float _7356 = fma(_7315.y, _7319, _7261) + fma(_7155.y, _7159, _7160.y);
    vec2 _7357 = unpackHalf2x16(_6837);
    vec2 _7360 = unpackHalf2x16(_6828);
    float _7361 = _7360.x;
    vec2 _7366 = unpackHalf2x16(_6857);
    vec2 _7369 = unpackHalf2x16(_6828);
    float _7370 = _7369.x;
    vec2 _7375 = unpackHalf2x16(_6915);
    vec2 _7378 = unpackHalf2x16(_6828);
    float _7379 = _7378.x;
    vec2 _7384 = unpackHalf2x16(_6885);
    vec2 _7387 = unpackHalf2x16(_6828);
    float _7388 = _7387.x;
    vec2 _7393 = unpackHalf2x16(_6833);
    vec2 _7396 = unpackHalf2x16(_6828);
    float _7397 = _7396.x;
    uint _7401 = packHalf2x16(vec2(fma(_7393.x, _7397, _7355), fma(_7393.y, _7397, _7356)));
    barrier();
    _42._m0[uint(int(_6758 << 2u) >> int(2u))] = packHalf2x16(vec2(fma(_7103.x, _7107, _7047), fma(_7103.y, _7107, _7048)));
    uint _7407 = min(((((bitfieldExtract(_6932, int(0u), int(16u)) * bitfieldExtract(c0.data[23u], int(16u), int(16u))) + (bitfieldExtract(_6932, int(16u), int(16u)) * bitfieldExtract(c0.data[23u], int(0u), int(16u)))) << 16u) + ((bitfieldExtract(_6932, int(0u), int(16u)) * bitfieldExtract(c0.data[23u], int(0u), int(16u))) + c0.data[29u])), c0.data[23u]);
    _42._m0[uint(int((_6758 << 2u) + 4u) >> int(2u))] = packHalf2x16(vec2(fma(_7130.x, _7134, _7068), fma(_7130.y, _7134, _7069)));
    _42._m0[uint(int((_6758 << 2u) + 8u) >> int(2u))] = _7249;
    _42._m0[uint(int((_6758 << 2u) + 96u) >> int(2u))] = packHalf2x16(vec2(fma(_7357.x, _7361, _7335), fma(_7357.y, _7361, _7336)));
    _42._m0[uint(int((_6758 << 2u) + 100u) >> int(2u))] = packHalf2x16(vec2(fma(_7303.x, _7307, _7250), fma(_7303.y, _7307, _7251)));
    _42._m0[uint(int((_6758 << 2u) + 104u) >> int(2u))] = _7401;
    _42._m0[uint(int((_6758 << 2u) + 192u) >> int(2u))] = packHalf2x16(vec2(fma(_7366.x, _7370, _7349), fma(_7366.y, _7370, _7350)));
    _42._m0[uint(int((_6758 << 2u) + 196u) >> int(2u))] = packHalf2x16(vec2(fma(_7384.x, _7388, _7353), fma(_7384.y, _7388, _7354)));
    _42._m0[uint(int((_6758 << 2u) + 200u) >> int(2u))] = packHalf2x16(vec2(fma(_7375.x, _7379, _7351), fma(_7375.y, _7379, _7352)));
    uint _7443 = uint(_36._m0[uint(int(_6253) >> int(1u))]);
    bool _7444 = _3610 >= _7407;
    bool _7447 = (_3610 < _7407) && (!_6886);
    uint _7449 = _5914 + 40u;
    uint _7455 = uint(_36._m0[uint(int(_6253 + 16u) >> int(1u))]);
    uint _7460 = uint(_36._m0[uint(int(_6253 + 32u) >> int(1u))]);
    uint _7465 = uint(_36._m0[uint(int(_6253 + 48u) >> int(1u))]);
    uint _7469;
    if (_7447)
    {
        _7469 = c0.data[9u];
    }
    else
    {
        _7469 = c0.data[23u];
    }
    uint _7471;
    if (_7447)
    {
        _7471 = _3721 + _7469;
    }
    else
    {
        _7471 = packHalf2x16(vec2(_7345, _7346));
    }
    uint _7476 = uint(_36._m0[uint(int(_6253 + 64u) >> int(1u))]);
    uint _7481 = uint(_36._m0[uint(int(_6253 + 80u) >> int(1u))]);
    uint _7482 = gl_SubgroupInvocationID & 7u;
    uint _7487 = uint(_36._m0[uint(int(_6253 + 384u) >> int(1u))]);
    uint _7488 = _7482 + 8u;
    uint _7489 = _7482 + 16u;
    bool _7492 = (_7488 < _6879) && (!_7444);
    bool _7495 = (_7489 < _6879) && (!_7444);
    vec2 _7496 = unpackHalf2x16(_7443);
    float _7497 = _7496.x;
    precise float _7498 = _5124 + _7497;
    precise float _7499 = _5125 + _7497;
    uint _7516 = (((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.x, int(16u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u)))) << 16u) + ((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u))) + _7482);
    vec2 _7517 = unpackHalf2x16(_5459);
    float _7518 = _7517.x;
    vec2 _7519 = unpackHalf2x16(_7443);
    float _7520 = _7519.x;
    precise float _7521 = _7518 + _7520;
    precise float _7522 = _7518 + _7520;
    uint _7525;
    if (_7447)
    {
        _7525 = 1065353216u;
    }
    else
    {
        _7525 = _7443;
    }
    bool _7526 = _7489 >= _6879;
    uint _7528;
    if (_7447)
    {
        _7528 = floatBitsToUint(_7498);
    }
    else
    {
        _7528 = gl_SubgroupInvocationID;
    }
    uint _7529 = _7482 + 24u;
    uint _7542 = (bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.x, int(16u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u)));
    vec2 _7545 = unpackHalf2x16(_7455);
    float _7546 = _7545.x;
    precise float _7547 = _5416 + _7546;
    precise float _7548 = _5417 + _7546;
    uint _7553;
    if (_7492)
    {
        _7553 = c0.data[9u];
    }
    else
    {
        _7553 = _7542;
    }
    uint _7555;
    if (_7492)
    {
        _7555 = _3721 + _7553;
    }
    else
    {
        _7555 = _7249;
    }
    vec2 _7556 = unpackHalf2x16(_6025);
    float _7557 = _7556.x;
    vec2 _7558 = unpackHalf2x16(_7455);
    float _7559 = _7558.x;
    precise float _7560 = _7557 + _7559;
    precise float _7561 = _7557 + _7559;
    uint _7565;
    if (_7447)
    {
        _7565 = floatBitsToUint(_7499);
    }
    else
    {
        _7565 = _7455;
    }
    uint _7568;
    if (_7447)
    {
        _7568 = c0.data[8u];
    }
    else
    {
        _7568 = _7553;
    }
    uint _7570;
    if (_7447)
    {
        _7570 = _7516 + _7568;
    }
    else
    {
        _7570 = _6025;
    }
    uint _7572;
    if (_7447)
    {
        _7572 = floatBitsToUint(_7521);
    }
    else
    {
        _7572 = packHalf2x16(vec2(_7498, _7499));
    }
    uint _7575;
    if (_7492)
    {
        _7575 = c0.data[8u];
    }
    else
    {
        _7575 = _7568;
    }
    uint _7577;
    if (_7492)
    {
        _7577 = _3632 + _7575;
    }
    else
    {
        _7577 = _7401;
    }
    uint _7578;
    if (_7492)
    {
        _7578 = 1065353216u;
    }
    else
    {
        _7578 = _5459;
    }
    precise float _7583 = unpackHalf2x16(_6052).x + unpackHalf2x16(_7460).x;
    uint _7585;
    if (_7492)
    {
        _7585 = floatBitsToUint(_7547);
    }
    else
    {
        _7585 = packHalf2x16(vec2(_7521, _7522));
    }
    if (_7447)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_7570, _7471)), uintBitsToFloat(uvec4(_7528, _7565, _7572, _7525)));
    }
    uint _7591;
    if (_7492)
    {
        _7591 = floatBitsToUint(_7548);
    }
    else
    {
        _7591 = _6915;
    }
    bool _7592 = _7488 >= _6879;
    uint _7594;
    if (_7492)
    {
        _7594 = floatBitsToUint(_7560);
    }
    else
    {
        _7594 = packHalf2x16(vec2(_7560, _7561));
    }
    vec2 _7595 = unpackHalf2x16(_7460);
    float _7596 = _7595.x;
    precise float _7597 = _5507 + _7596;
    precise float _7598 = _5508 + _7596;
    uint _7601 = _7482 + 32u;
    vec2 _7602 = unpackHalf2x16(_6074);
    float _7603 = _7602.x;
    vec2 _7604 = unpackHalf2x16(_7465);
    float _7605 = _7604.x;
    precise float _7606 = _7603 + _7605;
    precise float _7607 = _7603 + _7605;
    if (_7492)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_7577, _7555)), uintBitsToFloat(uvec4(_7585, _7591, _7594, _7578)));
    }
    bool _7616 = (_7529 < _6879) && (!_7444);
    vec2 _7617 = unpackHalf2x16(_7481);
    float _7618 = _7617.x;
    precise float _7619 = _6055 + _7618;
    precise float _7620 = _6056 + _7618;
    uint _7623;
    if (_7495)
    {
        _7623 = c0.data[8u];
    }
    else
    {
        _7623 = _7575;
    }
    uint _7625;
    if (_7495)
    {
        _7625 = _3648 + _7623;
    }
    else
    {
        _7625 = packHalf2x16(vec2(_7547, _7548));
    }
    vec2 _7626 = unpackHalf2x16(_6141);
    float _7627 = _7626.x;
    vec2 _7628 = unpackHalf2x16(_7481);
    float _7629 = _7628.x;
    precise float _7630 = _7627 + _7629;
    precise float _7631 = _7627 + _7629;
    uint _7636;
    if (_7495)
    {
        _7636 = c0.data[9u];
    }
    else
    {
        _7636 = _7623;
    }
    uint _7638;
    if (_7495)
    {
        _7638 = _3721 + _7636;
    }
    else
    {
        _7638 = _5510;
    }
    bool _7641 = (_7601 < _6879) && (!_7444);
    bool _7644 = (_7449 < _6879) && (!_7444);
    uint _7646;
    if (_7495)
    {
        _7646 = floatBitsToUint(_7583);
    }
    else
    {
        _7646 = _7572;
    }
    uint _7651 = uint(_36._m0[uint(int(_6253 + 416u) >> int(1u))]);
    uint _7652;
    if (_7495)
    {
        _7652 = 1065353216u;
    }
    else
    {
        _7652 = _7525;
    }
    uint _7654;
    if (_7495)
    {
        _7654 = floatBitsToUint(_7597);
    }
    else
    {
        _7654 = _7528;
    }
    uint _7659 = uint(_36._m0[uint(int(_6253 + 400u) >> int(1u))]);
    uint _7661;
    if (_7495)
    {
        _7661 = floatBitsToUint(_7598);
    }
    else
    {
        _7661 = _7565;
    }
    vec2 _7662 = unpackHalf2x16(_7465);
    float _7663 = _7662.x;
    precise float _7664 = _5577 + _7663;
    precise float _7665 = _5578 + _7663;
    uint _7670;
    if (_7616)
    {
        _7670 = c0.data[8u];
    }
    else
    {
        _7670 = _7636;
    }
    uint _7672;
    if (_7616)
    {
        _7672 = _3669 + _7670;
    }
    else
    {
        _7672 = _5580;
    }
    vec2 _7673 = unpackHalf2x16(_7476);
    float _7674 = _7673.x;
    precise float _7675 = _5869 + _7674;
    precise float _7676 = _5870 + _7674;
    if (_7495)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_7625, _7638)), uintBitsToFloat(uvec4(_7654, _7661, _7646, _7652)));
    }
    uint _7685;
    if (_7616)
    {
        _7685 = c0.data[9u];
    }
    else
    {
        _7685 = _7670;
    }
    uint _7687;
    if (_7616)
    {
        _7687 = _3721 + _7685;
    }
    else
    {
        _7687 = _5872;
    }
    uint _7692 = uint(_36._m0[uint(int(_6253 + 432u) >> int(1u))]);
    bool _7695 = (_3633 < _7407) && (!_6886);
    vec2 _7696 = unpackHalf2x16(_6125);
    float _7697 = _7696.x;
    vec2 _7698 = unpackHalf2x16(_7476);
    float _7699 = _7698.x;
    precise float _7700 = _7697 + _7699;
    precise float _7701 = _7697 + _7699;
    uint _7705;
    if (_7644)
    {
        _7705 = floatBitsToUint(_7620);
    }
    else
    {
        _7705 = packHalf2x16(vec2(_7597, _7598));
    }
    uint _7708;
    if (_7641)
    {
        _7708 = c0.data[9u];
    }
    else
    {
        _7708 = _7685;
    }
    uint _7710;
    if (_7641)
    {
        _7710 = _3721 + _7708;
    }
    else
    {
        _7710 = _7471;
    }
    uint _7711;
    if (_7641)
    {
        _7711 = 1065353216u;
    }
    else
    {
        _7711 = _7578;
    }
    uint _7714;
    if (_7641)
    {
        _7714 = c0.data[8u];
    }
    else
    {
        _7714 = _7708;
    }
    uint _7716;
    if (_7641)
    {
        _7716 = _3684 + _7714;
    }
    else
    {
        _7716 = _7570;
    }
    uint _7718;
    if (_7641)
    {
        _7718 = floatBitsToUint(_7700);
    }
    else
    {
        _7718 = packHalf2x16(vec2(_7700, _7701));
    }
    bool _7721 = (_3722 < _7407) && (!_6886);
    uint _7722;
    if (_7644)
    {
        _7722 = 1065353216u;
    }
    else
    {
        _7722 = _6125;
    }
    uint _7724;
    if (_7644)
    {
        _7724 = floatBitsToUint(_7630);
    }
    else
    {
        _7724 = packHalf2x16(vec2(_7630, _7631));
    }
    uint _7727;
    if (_7695)
    {
        _7727 = c0.data[8u];
    }
    else
    {
        _7727 = _7714;
    }
    uint _7729;
    if (_7695)
    {
        _7729 = _7516 + _7727;
    }
    else
    {
        _7729 = _6141;
    }
    uint _7731;
    if (_7616)
    {
        _7731 = floatBitsToUint(_7664);
    }
    else
    {
        _7731 = _7654;
    }
    uint _7734;
    if (_7644)
    {
        _7734 = c0.data[9u];
    }
    else
    {
        _7734 = _7727;
    }
    uint _7736;
    if (_7644)
    {
        _7736 = _3721 + _7734;
    }
    else
    {
        _7736 = _7638;
    }
    uint _7737;
    if (_7616)
    {
        _7737 = 1065353216u;
    }
    else
    {
        _7737 = _7652;
    }
    uint _7740 = ((_7542 << 16u) + ((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u))) + (_5914 + 40u))) + c0.data[8u];
    uint _7742;
    if (_7616)
    {
        _7742 = floatBitsToUint(_7665);
    }
    else
    {
        _7742 = _7661;
    }
    uint _7744;
    if (_7616)
    {
        _7744 = floatBitsToUint(_7606);
    }
    else
    {
        _7744 = _7646;
    }
    uint _7746;
    if (_7641)
    {
        _7746 = floatBitsToUint(_7675);
    }
    else
    {
        _7746 = packHalf2x16(vec2(_7664, _7665));
    }
    if (_7616)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_7672, _7687)), uintBitsToFloat(uvec4(_7731, _7742, _7744, _7737)));
    }
    uint _7752;
    if (_7644)
    {
        _7752 = floatBitsToUint(_7619);
    }
    else
    {
        _7752 = packHalf2x16(vec2(_7606, _7607));
    }
    vec2 _7753 = unpackHalf2x16(_7487);
    float _7754 = _7753.x;
    precise float _7755 = _5056 + _7754;
    precise float _7756 = _5057 + _7754;
    uint _7760;
    if (_7641)
    {
        _7760 = floatBitsToUint(_7676);
    }
    else
    {
        _7760 = packHalf2x16(vec2(_7675, _7676));
    }
    precise float _7765 = unpackHalf2x16(_6173).x + unpackHalf2x16(_7487).x;
    uint _7778 = (bitfieldExtract(gl_WorkGroupID.y, int(0u), int(16u)) * bitfieldExtract(c0.data[23u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.y, int(16u), int(16u)) * bitfieldExtract(c0.data[23u], int(0u), int(16u)));
    uint _7780 = (_7778 << 16u) + ((bitfieldExtract(gl_WorkGroupID.y, int(0u), int(16u)) * bitfieldExtract(c0.data[23u], int(0u), int(16u))) + _3633);
    vec2 _7781 = unpackHalf2x16(_7659);
    float _7782 = _7781.x;
    precise float _7783 = _5583 + _7782;
    precise float _7784 = _5584 + _7782;
    if (_7641)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_7716, _7710)), uintBitsToFloat(uvec4(_7746, _7760, _7718, _7711)));
    }
    bool _7793 = (_3633 < _7407) && (!_7592);
    uint _7794;
    if (_7695)
    {
        _7794 = 1065353216u;
    }
    else
    {
        _7794 = _5059;
    }
    uint _7797;
    if (_7695)
    {
        _7797 = c0.data[9u];
    }
    else
    {
        _7797 = _7778;
    }
    uint _7799;
    if (_7695)
    {
        _7799 = _7780 + _7797;
    }
    else
    {
        _7799 = _6173;
    }
    if (_7644)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_7740, _7736)), uintBitsToFloat(uvec4(_7752, _7705, _7724, _7722)));
    }
    precise float _7808 = unpackHalf2x16(_6201).x + unpackHalf2x16(_7659).x;
    bool _7809 = _7529 >= _6879;
    vec2 _7810 = unpackHalf2x16(_7651);
    float _7811 = _7810.x;
    precise float _7812 = _5687 + _7811;
    precise float _7813 = _5688 + _7811;
    bool _7816 = _7601 >= _6879;
    precise float _7821 = unpackHalf2x16(_6261).x + unpackHalf2x16(_7651).x;
    bool _7824 = (_3722 < _7407) && (!_7592);
    vec2 _7825 = unpackHalf2x16(_7692);
    float _7826 = _7825.x;
    precise float _7827 = _5897 + _7826;
    precise float _7828 = _5898 + _7826;
    uint _7833 = uint(_36._m0[uint(int(_6253 + 448u) >> int(1u))]);
    uint _7835;
    if (_7695)
    {
        _7835 = floatBitsToUint(_7755);
    }
    else
    {
        _7835 = _7672;
    }
    uint _7838;
    if (_7793)
    {
        _7838 = c0.data[8u];
    }
    else
    {
        _7838 = _7797;
    }
    uint _7840;
    if (_7793)
    {
        _7840 = _3632 + _7838;
    }
    else
    {
        _7840 = _7744;
    }
    uint _7842;
    if (_7695)
    {
        _7842 = floatBitsToUint(_7756);
    }
    else
    {
        _7842 = _7687;
    }
    uint _7845;
    if (_7793)
    {
        _7845 = c0.data[9u];
    }
    else
    {
        _7845 = _7838;
    }
    uint _7847;
    if (_7793)
    {
        _7847 = _7780 + _7845;
    }
    else
    {
        _7847 = _7737;
    }
    uint _7849;
    if (_7695)
    {
        _7849 = floatBitsToUint(_7765);
    }
    else
    {
        _7849 = packHalf2x16(vec2(_7755, _7756));
    }
    precise float _7854 = unpackHalf2x16(_6300).x + unpackHalf2x16(_7692).x;
    uint _7859 = uint(_36._m0[uint(int(_6253 + 800u) >> int(1u))]);
    if (_7695)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_7729, _7799)), uintBitsToFloat(uvec4(_7835, _7842, _7849, _7794)));
    }
    bool _7866 = (_3633 < _7407) && (!_7526);
    uint _7871 = uint(_36._m0[uint(int(_6253 + 784u) >> int(1u))]);
    bool _7874 = (_3722 < _7407) && (!_7526);
    uint _7877;
    if (_7824)
    {
        _7877 = c0.data[8u];
    }
    else
    {
        _7877 = _7845;
    }
    uint _7879;
    if (_7824)
    {
        _7879 = _3632 + _7877;
    }
    else
    {
        _7879 = _7752;
    }
    uint _7884 = uint(_36._m0[uint(int(_6253 + 832u) >> int(1u))]);
    uint _7887;
    if (_7866)
    {
        _7887 = c0.data[8u];
    }
    else
    {
        _7887 = _7877;
    }
    uint _7889;
    if (_7866)
    {
        _7889 = _3648 + _7887;
    }
    else
    {
        _7889 = _7746;
    }
    uint _7892;
    if (_7866)
    {
        _7892 = c0.data[9u];
    }
    else
    {
        _7892 = _7887;
    }
    uint _7894;
    if (_7866)
    {
        _7894 = _7780 + _7892;
    }
    else
    {
        _7894 = _7760;
    }
    uint _7897;
    if (_7874)
    {
        _7897 = c0.data[8u];
    }
    else
    {
        _7897 = _7892;
    }
    uint _7899;
    if (_7874)
    {
        _7899 = _3648 + _7897;
    }
    else
    {
        _7899 = _7724;
    }
    uint _7900;
    if (_7793)
    {
        _7900 = 1065353216u;
    }
    else
    {
        _7900 = _7794;
    }
    uint _7902;
    if (_7793)
    {
        _7902 = floatBitsToUint(_7783);
    }
    else
    {
        _7902 = _7835;
    }
    uint _7904;
    if (_7793)
    {
        _7904 = floatBitsToUint(_7784);
    }
    else
    {
        _7904 = _7842;
    }
    uint _7906;
    if (_7793)
    {
        _7906 = floatBitsToUint(_7808);
    }
    else
    {
        _7906 = _7849;
    }
    if (_7793)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_7840, _7847)), uintBitsToFloat(uvec4(_7902, _7904, _7906, _7900)));
    }
    bool _7913 = (_3633 < _7407) && (!_7809);
    vec2 _7914 = unpackHalf2x16(_7833);
    float _7915 = _7914.x;
    precise float _7916 = _6271 + _7915;
    precise float _7917 = _6272 + _7915;
    bool _7922 = (_3722 < _7407) && (!_7809);
    precise float _7927 = unpackHalf2x16(_6348).x + unpackHalf2x16(_7833).x;
    uint _7932 = uint(_36._m0[uint(int(_6253 + 816u) >> int(1u))]);
    vec2 _7933 = unpackHalf2x16(_7859);
    float _7934 = _7933.x;
    precise float _7935 = _6506 + _7934;
    precise float _7936 = _6507 + _7934;
    precise float _7941 = unpackHalf2x16(_6580).x + unpackHalf2x16(_7859).x;
    vec2 _7942 = unpackHalf2x16(_7871);
    float _7943 = _7942.x;
    precise float _7944 = _6458 + _7943;
    precise float _7945 = _6459 + _7943;
    uint _7948;
    if (_7913)
    {
        _7948 = c0.data[8u];
    }
    else
    {
        _7948 = _7897;
    }
    uint _7950;
    if (_7913)
    {
        _7950 = _3669 + _7948;
    }
    else
    {
        _7950 = packHalf2x16(vec2(_7783, _7784));
    }
    vec2 _7951 = unpackHalf2x16(_7884);
    float _7952 = _7951.x;
    precise float _7953 = _6604 + _7952;
    precise float _7954 = _6605 + _7952;
    uint _7957;
    if (_7922)
    {
        _7957 = c0.data[8u];
    }
    else
    {
        _7957 = _7948;
    }
    uint _7959;
    if (_7922)
    {
        _7959 = _3669 + _7957;
    }
    else
    {
        _7959 = _3669;
    }
    precise float _7964 = unpackHalf2x16(_6693).x + unpackHalf2x16(_7884).x;
    uint _7965;
    if (_7866)
    {
        _7965 = 1065353216u;
    }
    else
    {
        _7965 = _7900;
    }
    uint _7967;
    if (_7866)
    {
        _7967 = floatBitsToUint(_7812);
    }
    else
    {
        _7967 = _7902;
    }
    uint _7969;
    if (_7866)
    {
        _7969 = floatBitsToUint(_7813);
    }
    else
    {
        _7969 = _7904;
    }
    uint _7972;
    if (_7913)
    {
        _7972 = c0.data[9u];
    }
    else
    {
        _7972 = _7957;
    }
    uint _7974;
    if (_7913)
    {
        _7974 = _7780 + _7972;
    }
    else
    {
        _7974 = packHalf2x16(vec2(_7812, _7813));
    }
    uint _7976;
    if (_7866)
    {
        _7976 = floatBitsToUint(_7821);
    }
    else
    {
        _7976 = _7906;
    }
    if (_7866)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_7889, _7894)), uintBitsToFloat(uvec4(_7967, _7969, _7976, _7965)));
    }
    bool _7983 = (_3633 < _7407) && (!_7816);
    bool _7986 = (_3722 < _7407) && (!_7816);
    uint _7989;
    if (_7983)
    {
        _7989 = c0.data[8u];
    }
    else
    {
        _7989 = _7972;
    }
    uint _7991;
    if (_7983)
    {
        _7991 = _3684 + _7989;
    }
    else
    {
        _7991 = _7840;
    }
    uint _7994;
    if (_7983)
    {
        _7994 = c0.data[9u];
    }
    else
    {
        _7994 = _7989;
    }
    uint _7996;
    if (_7983)
    {
        _7996 = _7780 + _7994;
    }
    else
    {
        _7996 = _7847;
    }
    vec2 _7997 = unpackHalf2x16(_7932);
    float _7998 = _7997.x;
    precise float _7999 = _6526 + _7998;
    precise float _8000 = _6527 + _7998;
    uint _8003;
    if (_7986)
    {
        _8003 = c0.data[8u];
    }
    else
    {
        _8003 = _7994;
    }
    uint _8005;
    if (_7986)
    {
        _8005 = _3684 + _8003;
    }
    else
    {
        _8005 = _7729;
    }
    precise float _8010 = unpackHalf2x16(_6636).x + unpackHalf2x16(_7932).x;
    uint _8011;
    if (_7913)
    {
        _8011 = 1065353216u;
    }
    else
    {
        _8011 = _7965;
    }
    uint _8014;
    if (_7721)
    {
        _8014 = c0.data[8u];
    }
    else
    {
        _8014 = _8003;
    }
    uint _8016;
    if (_7721)
    {
        _8016 = _7516 + _8014;
    }
    else
    {
        _8016 = _7889;
    }
    uint _8018;
    if (_7913)
    {
        _8018 = floatBitsToUint(_7827);
    }
    else
    {
        _8018 = _7967;
    }
    uint _8020;
    if (_7913)
    {
        _8020 = floatBitsToUint(_7828);
    }
    else
    {
        _8020 = _7969;
    }
    uint _8022;
    if (_7913)
    {
        _8022 = floatBitsToUint(_7854);
    }
    else
    {
        _8022 = _7976;
    }
    if (_7913)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_7950, _7974)), uintBitsToFloat(uvec4(_8018, _8020, _8022, _8011)));
    }
    bool _8042 = _7449 >= _6879;
    uint _8045 = ((((bitfieldExtract(gl_WorkGroupID.y, int(0u), int(16u)) * bitfieldExtract(c0.data[23u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.y, int(16u), int(16u)) * bitfieldExtract(c0.data[23u], int(0u), int(16u)))) << 16u) + ((bitfieldExtract(gl_WorkGroupID.y, int(0u), int(16u)) * bitfieldExtract(c0.data[23u], int(0u), int(16u))) + _3722)) + c0.data[9u];
    uint _8047;
    if (_7983)
    {
        _8047 = floatBitsToUint(_7927);
    }
    else
    {
        _8047 = _8022;
    }
    uint _8052 = uint(_36._m0[uint(int(_6253 + 464u) >> int(1u))]);
    uint _8053;
    if (_7983)
    {
        _8053 = 1065353216u;
    }
    else
    {
        _8053 = _8011;
    }
    uint _8055;
    if (_7983)
    {
        _8055 = floatBitsToUint(_7916);
    }
    else
    {
        _8055 = _8018;
    }
    uint _8060 = uint(_36._m0[uint(int(_6253 + 768u) >> int(1u))]);
    uint _8062;
    if (_7983)
    {
        _8062 = floatBitsToUint(_7917);
    }
    else
    {
        _8062 = _8020;
    }
    uint _8067 = uint(_36._m0[uint(int(_6253 + 848u) >> int(1u))]);
    if (_7983)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_7991, _7996)), uintBitsToFloat(uvec4(_8055, _8062, _8047, _8053)));
    }
    bool _8074 = (_3633 < _7407) && (!_8042);
    uint _8078;
    if (_8074)
    {
        _8078 = 1065353216u;
    }
    else
    {
        _8078 = packHalf2x16(vec2(_7916, _7917));
    }
    vec2 _8079 = unpackHalf2x16(_6523);
    float _8080 = _8079.x;
    vec2 _8081 = unpackHalf2x16(_7871);
    float _8082 = _8081.x;
    precise float _8083 = _8080 + _8082;
    precise float _8084 = _8080 + _8082;
    uint _8089;
    if (_8074)
    {
        _8089 = c0.data[9u];
    }
    else
    {
        _8089 = c0.data[9u];
    }
    uint _8091;
    if (_8074)
    {
        _8091 = _7780 + _8089;
    }
    else
    {
        _8091 = _7871;
    }
    uint _8092;
    if (_7721)
    {
        _8092 = 1065353216u;
    }
    else
    {
        _8092 = _7996;
    }
    uint _8093;
    if (_7824)
    {
        _8093 = 1065353216u;
    }
    else
    {
        _8093 = _8053;
    }
    uint _8095;
    if (_7824)
    {
        _8095 = floatBitsToUint(_7944);
    }
    else
    {
        _8095 = _8055;
    }
    uint _8097;
    if (_7824)
    {
        _8097 = floatBitsToUint(_7945);
    }
    else
    {
        _8097 = _8062;
    }
    uint _8099;
    if (_7824)
    {
        _8099 = floatBitsToUint(_8083);
    }
    else
    {
        _8099 = packHalf2x16(vec2(_8083, _8084));
    }
    vec2 _8100 = unpackHalf2x16(_8052);
    float _8101 = _8100.x;
    precise float _8102 = _6321 + _8101;
    precise float _8103 = _6322 + _8101;
    vec2 _8104 = unpackHalf2x16(_6411);
    float _8105 = _8104.x;
    vec2 _8106 = unpackHalf2x16(_8052);
    float _8107 = _8106.x;
    precise float _8108 = _8105 + _8107;
    precise float _8109 = _8105 + _8107;
    vec2 _8112 = unpackHalf2x16(_8060);
    float _8113 = _8112.x;
    precise float _8114 = _6377 + _8113;
    precise float _8115 = _6378 + _8113;
    uint _8117;
    if (_8074)
    {
        _8117 = floatBitsToUint(_8102);
    }
    else
    {
        _8117 = _8052;
    }
    vec2 _8118 = unpackHalf2x16(_6491);
    float _8119 = _8118.x;
    vec2 _8120 = unpackHalf2x16(_8060);
    float _8121 = _8120.x;
    precise float _8122 = _8119 + _8121;
    precise float _8123 = _8119 + _8121;
    uint _8127;
    if (_8074)
    {
        _8127 = floatBitsToUint(_8108);
    }
    else
    {
        _8127 = packHalf2x16(vec2(_8108, _8109));
    }
    vec2 _8128 = unpackHalf2x16(_8067);
    float _8129 = _8128.x;
    precise float _8130 = _6656 + _8129;
    precise float _8131 = _6657 + _8129;
    uint _8133;
    if (_8074)
    {
        _8133 = floatBitsToUint(_8103);
    }
    else
    {
        _8133 = _7974;
    }
    precise float _8136 = _6709 + unpackHalf2x16(_8067).x;
    uint _8138;
    if (_7721)
    {
        _8138 = floatBitsToUint(_8114);
    }
    else
    {
        _8138 = _8060;
    }
    uint _8140;
    if (_7721)
    {
        _8140 = floatBitsToUint(_8115);
    }
    else
    {
        _8140 = _7742;
    }
    if (_8074)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_7740, _8091)), uintBitsToFloat(uvec4(_8117, _8133, _8127, _8078)));
    }
    uint _8146;
    if (_7721)
    {
        _8146 = floatBitsToUint(_8122);
    }
    else
    {
        _8146 = packHalf2x16(vec2(_8122, _8123));
    }
    if (_7721)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_8016, _8045)), uintBitsToFloat(uvec4(_8138, _8140, _8146, _8092)));
    }
    if (_7824)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_7879, _8045)), uintBitsToFloat(uvec4(_8095, _8097, _8099, _8093)));
    }
    uint _8155;
    if (_7874)
    {
        _8155 = 1065353216u;
    }
    else
    {
        _8155 = _8078;
    }
    uint _8157;
    if (_7874)
    {
        _8157 = floatBitsToUint(_7935);
    }
    else
    {
        _8157 = _8117;
    }
    uint _8159;
    if (_7874)
    {
        _8159 = floatBitsToUint(_7936);
    }
    else
    {
        _8159 = _8133;
    }
    uint _8161;
    if (_7874)
    {
        _8161 = floatBitsToUint(_7941);
    }
    else
    {
        _8161 = _8127;
    }
    uint _8162;
    if (_7922)
    {
        _8162 = 1065353216u;
    }
    else
    {
        _8162 = _8093;
    }
    uint _8164;
    if (_7922)
    {
        _8164 = floatBitsToUint(_7999);
    }
    else
    {
        _8164 = _8095;
    }
    if (_7874)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_7899, _8045)), uintBitsToFloat(uvec4(_8157, _8159, _8161, _8155)));
    }
    uint _8170;
    if (_7922)
    {
        _8170 = floatBitsToUint(_8000);
    }
    else
    {
        _8170 = _8097;
    }
    uint _8172;
    if (_7922)
    {
        _8172 = floatBitsToUint(_8010);
    }
    else
    {
        _8172 = _8099;
    }
    uint _8173;
    if (_7986)
    {
        _8173 = 1065353216u;
    }
    else
    {
        _8173 = _8092;
    }
    uint _8175;
    if (_7986)
    {
        _8175 = floatBitsToUint(_7953);
    }
    else
    {
        _8175 = _8138;
    }
    if (_7922)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_7959, _8045)), uintBitsToFloat(uvec4(_8164, _8170, _8172, _8162)));
    }
    uint _8181;
    if (_7986)
    {
        _8181 = floatBitsToUint(_7954);
    }
    else
    {
        _8181 = _8140;
    }
    uint _8183;
    if (_7986)
    {
        _8183 = floatBitsToUint(_7964);
    }
    else
    {
        _8183 = _8146;
    }
    if (_7986)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_8005, _8045)), uintBitsToFloat(uvec4(_8175, _8181, _8183, _8173)));
    }
    if (!((_3722 < _7407) && (!_8042)))
    {
        return;
    }
    imageStore(cs_img0_d0, ivec2(uvec2(_7740, _8045)), uintBitsToFloat(uvec4(floatBitsToUint(_8130), floatBitsToUint(_8131), floatBitsToUint(_8136), 1065353216u)));
}

