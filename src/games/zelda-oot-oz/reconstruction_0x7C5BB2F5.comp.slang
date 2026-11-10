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

// CUSTOM: Original SPIR-V aliases 3456 half words and 1728 words in 6912 bytes.
// Preserve original arithmetic below; pair AA0 with the shared linear path.
// ORIGINAL: shared _33 _36;
// ORIGINAL: shared _39 _42;
// ORIGINAL: shared _45 _48;
// ORIGINAL: shared _51 _54;
#define CUSTOM_RECONSTRUCTION_SHARED_WORDS 1728
#include "./reconstruction.slangi"
static _33 _36;
static _39 _42;
// Unused original aliased views: shared _45 _48; shared _51 _54;

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
    // CUSTOM: Same AA-off bypass as the lower-resolution permutations.
    if (custom_aa.aa_strength == 0.f) {
        CustomLinearReconstruction();
        return;
    }
    uint _633 = ((bitfieldExtract(gl_LocalInvocationID.y, int(16u), int(16u)) * 128u) << 16u) + ((bitfieldExtract(gl_LocalInvocationID.y, int(0u), int(16u)) * 128u) + gl_LocalInvocationID.x);
    uint _642 = ((bitfieldExtract(_633, int(16u), int(16u)) * 12u) << 16u) + ((bitfieldExtract(_633, int(0u), int(16u)) * 12u) + 5152u);
    uint _649 = gl_LocalInvocationID.x + 128u;
    uint _656 = (bitfieldExtract(gl_LocalInvocationID.x, int(16u), int(16u)) * 17097u) + bitfieldExtract(bitfieldExtract(gl_LocalInvocationID.x, int(0u), int(16u)) * 17097u, int(16u), int(16u));
    uint _669 = gl_LocalInvocationID.x + 256u;
    uint _671 = gl_LocalInvocationID.x + 384u;
    uint _677 = (bitfieldExtract(_649, int(16u), int(16u)) * 17097u) + bitfieldExtract(bitfieldExtract(_649, int(0u), int(16u)) * 17097u, int(16u), int(16u));
    uint _688 = ((((bitfieldExtract(gl_LocalInvocationID.x, int(0u), int(16u)) * 45590u) + bitfieldExtract(_656, int(0u), int(16u))) >> 16u) + ((bitfieldExtract(gl_LocalInvocationID.x, int(16u), int(16u)) * 45590u) + bitfieldExtract(_656, int(16u), int(16u)))) >> 4u;
    uint _691 = ((((bitfieldExtract(_649, int(0u), int(16u)) * 45590u) + bitfieldExtract(_677, int(0u), int(16u))) >> 16u) + ((bitfieldExtract(_649, int(16u), int(16u)) * 45590u) + bitfieldExtract(_677, int(16u), int(16u)))) >> 4u;
    uint _697 = (bitfieldExtract(_669, int(16u), int(16u)) * 17097u) + bitfieldExtract(bitfieldExtract(_669, int(0u), int(16u)) * 17097u, int(16u), int(16u));
    uint _713 = (bitfieldExtract(_671, int(16u), int(16u)) * 17097u) + bitfieldExtract(bitfieldExtract(_671, int(0u), int(16u)) * 17097u, int(16u), int(16u));
    uint _724 = ((((bitfieldExtract(_669, int(0u), int(16u)) * 45590u) + bitfieldExtract(_697, int(0u), int(16u))) >> 16u) + ((bitfieldExtract(_669, int(16u), int(16u)) * 45590u) + bitfieldExtract(_697, int(16u), int(16u)))) >> 4u;
    uint _726 = (gl_WorkGroupID.y << 2u) * 10u;
    uint _727 = ((((bitfieldExtract(_671, int(0u), int(16u)) * 45590u) + bitfieldExtract(_713, int(0u), int(16u))) >> 16u) + ((bitfieldExtract(_671, int(16u), int(16u)) * 45590u) + bitfieldExtract(_713, int(16u), int(16u)))) >> 4u;
    uint _728 = gl_WorkGroupID.x << 2u;
    uint _805 = ((((bitfieldExtract(_688, int(0u), int(16u)) * 65535u) + (bitfieldExtract(_688, int(16u), int(16u)) * 65513u)) << 16u) + ((bitfieldExtract(_688, int(0u), int(16u)) * 65513u) + gl_LocalInvocationID.x)) << 1u;
    uint _807 = ((((bitfieldExtract(_691, int(0u), int(16u)) * 65535u) + (bitfieldExtract(_691, int(16u), int(16u)) * 65513u)) << 16u) + ((bitfieldExtract(_691, int(0u), int(16u)) * 65513u) + _649)) << 1u;
    uint _809 = ((((bitfieldExtract(_724, int(0u), int(16u)) * 65535u) + (bitfieldExtract(_724, int(16u), int(16u)) * 65513u)) << 16u) + ((bitfieldExtract(_724, int(0u), int(16u)) * 65513u) + _669)) << 1u;
    uint _811 = ((((bitfieldExtract(_727, int(0u), int(16u)) * 65535u) + (bitfieldExtract(_727, int(16u), int(16u)) * 65513u)) << 16u) + ((bitfieldExtract(_727, int(0u), int(16u)) * 65513u) + _671)) << 1u;
    precise float _814 = float(int((((bitfieldExtract(_688, int(16u), int(16u)) * 2u) << 16u) + ((bitfieldExtract(_688, int(0u), int(16u)) * 2u) + _726)) + 4294967293u)) + 1.0;
    precise float _822 = float(int((((bitfieldExtract(_724, int(16u), int(16u)) * 2u) << 16u) + ((bitfieldExtract(_724, int(0u), int(16u)) * 2u) + _726)) + 4294967293u)) + 1.0;
    precise float _830 = float(int((((bitfieldExtract(_727, int(16u), int(16u)) * 2u) << 16u) + ((bitfieldExtract(_727, int(0u), int(16u)) * 2u) + _726)) + 4294967293u)) + 1.0;
    precise float _849 = _814 * c0_1.data[13u];
    precise float _851 = float(int((((bitfieldExtract(_691, int(16u), int(16u)) * 2u) << 16u) + ((bitfieldExtract(_691, int(0u), int(16u)) * 2u) + _726)) + 4294967293u)) + 1.0;
    precise float _857 = _851 * c0_1.data[13u];
    precise float _859 = float(int((((bitfieldExtract(_728, int(16u), int(16u)) * 10u) << 16u) + ((bitfieldExtract(_728, int(0u), int(16u)) * 10u) + _805)) + 4294967293u)) + 1.0;
    precise float _861 = float(int((((bitfieldExtract(_728, int(16u), int(16u)) * 10u) << 16u) + ((bitfieldExtract(_728, int(0u), int(16u)) * 10u) + _807)) + 4294967293u)) + 1.0;
    precise float _864 = _822 * c0_1.data[13u];
    precise float _865 = float(int((((bitfieldExtract(_728, int(16u), int(16u)) * 10u) << 16u) + ((bitfieldExtract(_728, int(0u), int(16u)) * 10u) + _809)) + 4294967293u)) + 1.0;
    precise float _868 = _830 * c0_1.data[13u];
    precise float _869 = float(int((((bitfieldExtract(_728, int(16u), int(16u)) * 10u) << 16u) + ((bitfieldExtract(_728, int(0u), int(16u)) * 10u) + _811)) + 4294967293u)) + 1.0;
    precise float _872 = _859 * c0_1.data[12u];
    precise float _875 = _861 * c0_1.data[12u];
    precise float _878 = _865 * c0_1.data[12u];
    precise float _881 = _869 * c0_1.data[12u];
    vec4 _896 = textureGatherOffsets(cs_tex0_c0, vec2(_872, _849), ivec2[](ivec2(0), ivec2(1, 0), ivec2(0, 1), ivec2(1)));
    vec4 _917 = textureGatherOffsets(cs_tex0_c0, vec2(_875, _857), ivec2[](ivec2(0), ivec2(1, 0), ivec2(0, 1), ivec2(1)));
    vec4 _938 = textureGatherOffsets(cs_tex0_c0, vec2(_878, _864), ivec2[](ivec2(0), ivec2(1, 0), ivec2(0, 1), ivec2(1)));
    vec4 _959 = textureGatherOffsets(cs_tex0_c0, vec2(_881, _868), ivec2[](ivec2(0), ivec2(1, 0), ivec2(0, 1), ivec2(1)));
    vec4 _980 = textureGatherOffsets(cs_tex0_c0, vec2(_872, _849), ivec2[](ivec2(0), ivec2(1, 0), ivec2(0, 1), ivec2(1)), int(1u));
    vec4 _1001 = textureGatherOffsets(cs_tex0_c0, vec2(_875, _857), ivec2[](ivec2(0), ivec2(1, 0), ivec2(0, 1), ivec2(1)), int(1u));
    vec4 _1022 = textureGatherOffsets(cs_tex0_c0, vec2(_878, _864), ivec2[](ivec2(0), ivec2(1, 0), ivec2(0, 1), ivec2(1)), int(1u));
    vec4 _1043 = textureGatherOffsets(cs_tex0_c0, vec2(_881, _868), ivec2[](ivec2(0), ivec2(1, 0), ivec2(0, 1), ivec2(1)), int(1u));
    vec4 _1064 = textureGatherOffsets(cs_tex0_c0, vec2(_872, _849), ivec2[](ivec2(0), ivec2(1, 0), ivec2(0, 1), ivec2(1)), int(2u));
    vec4 _1085 = textureGatherOffsets(cs_tex0_c0, vec2(_875, _857), ivec2[](ivec2(0), ivec2(1, 0), ivec2(0, 1), ivec2(1)), int(2u));
    vec4 _1106 = textureGatherOffsets(cs_tex0_c0, vec2(_878, _864), ivec2[](ivec2(0), ivec2(1, 0), ivec2(0, 1), ivec2(1)), int(2u));
    vec4 _1127 = textureGatherOffsets(cs_tex0_c0, vec2(_881, _868), ivec2[](ivec2(0), ivec2(1, 0), ivec2(0, 1), ivec2(1)), int(2u));
    uint _1149 = (gl_SubgroupInvocationID << 4u) + c0.data[44u];
    uint _1155 = (_1149 - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec4 _1157 = ssbo0_3._m0[_1155];
    uint _1168 = ((_1149 + 512u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec4 _1170 = ssbo0_3._m0[_1168];
    uint _1181 = ((_1149 + 1024u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec4 _1183 = ssbo0_3._m0[_1181];
    uint _1206 = gl_LocalInvocationID.x >> 5u;
    uint _1214 = gl_SubgroupInvocationID >> 2u;
    uint _1222 = (((bitfieldExtract(_688, int(16u), int(16u)) * 112u) << 16u) + ((bitfieldExtract(_688, int(0u), int(16u)) * 112u) + _805)) << 1u;
    uint _1223 = (((bitfieldExtract(_691, int(16u), int(16u)) * 112u) << 16u) + ((bitfieldExtract(_691, int(0u), int(16u)) * 112u) + _807)) << 1u;
    uint _1224 = (((bitfieldExtract(_724, int(16u), int(16u)) * 112u) << 16u) + ((bitfieldExtract(_724, int(0u), int(16u)) * 112u) + _809)) << 1u;
    uint _1225 = (((bitfieldExtract(_727, int(16u), int(16u)) * 112u) << 16u) + ((bitfieldExtract(_727, int(0u), int(16u)) * 112u) + _811)) << 1u;
    vec2 _1227 = unpackHalf2x16((packHalf2x16(vec2(_1064.y, 0.0)) << 16u) + packHalf2x16(vec2(_1064.x, 0.0)));
    vec2 _1230 = unpackHalf2x16(748563614u);
    precise float _1233 = _1227.x * _1230.x;
    precise float _1234 = _1227.y * _1230.y;
    vec2 _1235 = unpackHalf2x16((packHalf2x16(vec2(_1064.w, 0.0)) << 16u) + packHalf2x16(vec2(_1064.z, 0.0)));
    vec2 _1238 = unpackHalf2x16(748563614u);
    precise float _1241 = _1235.x * _1238.x;
    precise float _1242 = _1235.y * _1238.y;
    vec2 _1243 = unpackHalf2x16((packHalf2x16(vec2(_1085.y, 0.0)) << 16u) + packHalf2x16(vec2(_1085.x, 0.0)));
    vec2 _1246 = unpackHalf2x16(748563614u);
    precise float _1249 = _1243.x * _1246.x;
    precise float _1250 = _1243.y * _1246.y;
    vec2 _1251 = unpackHalf2x16((packHalf2x16(vec2(_1085.w, 0.0)) << 16u) + packHalf2x16(vec2(_1085.z, 0.0)));
    vec2 _1254 = unpackHalf2x16(748563614u);
    precise float _1257 = _1251.x * _1254.x;
    precise float _1258 = _1251.y * _1254.y;
    vec2 _1259 = unpackHalf2x16((packHalf2x16(vec2(_1106.w, 0.0)) << 16u) + packHalf2x16(vec2(_1106.z, 0.0)));
    vec2 _1262 = unpackHalf2x16(748563614u);
    precise float _1265 = _1259.x * _1262.x;
    precise float _1266 = _1259.y * _1262.y;
    vec2 _1267 = unpackHalf2x16((packHalf2x16(vec2(_1106.y, 0.0)) << 16u) + packHalf2x16(vec2(_1106.x, 0.0)));
    vec2 _1270 = unpackHalf2x16(748563614u);
    precise float _1273 = _1267.x * _1270.x;
    precise float _1274 = _1267.y * _1270.y;
    vec2 _1275 = unpackHalf2x16((packHalf2x16(vec2(_1127.w, 0.0)) << 16u) + packHalf2x16(vec2(_1127.z, 0.0)));
    vec2 _1278 = unpackHalf2x16(748563614u);
    precise float _1281 = _1275.x * _1278.x;
    precise float _1282 = _1275.y * _1278.y;
    vec2 _1283 = unpackHalf2x16((packHalf2x16(vec2(_1127.y, 0.0)) << 16u) + packHalf2x16(vec2(_1127.x, 0.0)));
    vec2 _1286 = unpackHalf2x16(748563614u);
    precise float _1289 = _1283.x * _1286.x;
    precise float _1290 = _1283.y * _1286.y;
    vec2 _1292 = unpackHalf2x16((packHalf2x16(vec2(_896.y, 0.0)) << 16u) + packHalf2x16(vec2(_896.x, 0.0)));
    vec2 _1295 = unpackHalf2x16(852308685u);
    vec2 _1300 = unpackHalf2x16((packHalf2x16(vec2(_896.w, 0.0)) << 16u) + packHalf2x16(vec2(_896.z, 0.0)));
    vec2 _1303 = unpackHalf2x16(852308685u);
    vec2 _1308 = unpackHalf2x16((packHalf2x16(vec2(_917.y, 0.0)) << 16u) + packHalf2x16(vec2(_917.x, 0.0)));
    vec2 _1311 = unpackHalf2x16(852308685u);
    vec2 _1316 = unpackHalf2x16((packHalf2x16(vec2(_917.w, 0.0)) << 16u) + packHalf2x16(vec2(_917.z, 0.0)));
    vec2 _1319 = unpackHalf2x16(852308685u);
    vec2 _1324 = unpackHalf2x16((packHalf2x16(vec2(_938.w, 0.0)) << 16u) + packHalf2x16(vec2(_938.z, 0.0)));
    vec2 _1327 = unpackHalf2x16(852308685u);
    vec2 _1332 = unpackHalf2x16((packHalf2x16(vec2(_938.y, 0.0)) << 16u) + packHalf2x16(vec2(_938.x, 0.0)));
    vec2 _1335 = unpackHalf2x16(852308685u);
    vec2 _1340 = unpackHalf2x16((packHalf2x16(vec2(_959.w, 0.0)) << 16u) + packHalf2x16(vec2(_959.z, 0.0)));
    vec2 _1343 = unpackHalf2x16(852308685u);
    vec2 _1348 = unpackHalf2x16((packHalf2x16(vec2(_959.y, 0.0)) << 16u) + packHalf2x16(vec2(_959.x, 0.0)));
    vec2 _1351 = unpackHalf2x16(852308685u);
    vec2 _1357 = unpackHalf2x16((packHalf2x16(vec2(_980.y, 0.0)) << 16u) + packHalf2x16(vec2(_980.x, 0.0)));
    vec2 _1360 = unpackHalf2x16(968374712u);
    vec2 _1367 = unpackHalf2x16((packHalf2x16(vec2(_980.w, 0.0)) << 16u) + packHalf2x16(vec2(_980.z, 0.0)));
    vec2 _1370 = unpackHalf2x16(968374712u);
    vec2 _1377 = unpackHalf2x16((packHalf2x16(vec2(_1001.y, 0.0)) << 16u) + packHalf2x16(vec2(_1001.x, 0.0)));
    vec2 _1380 = unpackHalf2x16(968374712u);
    _42._m0[uint(int(_1222) >> int(2u))] = packHalf2x16(vec2(fma(_1357.x, _1360.x, fma(_1292.x, _1295.x, _1233)), fma(_1357.y, _1360.y, fma(_1292.y, _1295.y, _1234))));
    vec2 _1389 = unpackHalf2x16((packHalf2x16(vec2(_1001.w, 0.0)) << 16u) + packHalf2x16(vec2(_1001.z, 0.0)));
    vec2 _1392 = unpackHalf2x16(968374712u);
    vec2 _1399 = unpackHalf2x16((packHalf2x16(vec2(_1022.w, 0.0)) << 16u) + packHalf2x16(vec2(_1022.z, 0.0)));
    vec2 _1402 = unpackHalf2x16(968374712u);
    _42._m0[uint(int(_1222 + 112u) >> int(2u))] = packHalf2x16(vec2(fma(_1367.x, _1370.x, fma(_1300.x, _1303.x, _1241)), fma(_1367.y, _1370.y, fma(_1300.y, _1303.y, _1242))));
    vec2 _1412 = unpackHalf2x16((packHalf2x16(vec2(_1022.y, 0.0)) << 16u) + packHalf2x16(vec2(_1022.x, 0.0)));
    vec2 _1415 = unpackHalf2x16(968374712u);
    vec2 _1422 = unpackHalf2x16((packHalf2x16(vec2(_1043.w, 0.0)) << 16u) + packHalf2x16(vec2(_1043.z, 0.0)));
    vec2 _1425 = unpackHalf2x16(968374712u);
    _42._m0[uint(int(_1223) >> int(2u))] = packHalf2x16(vec2(fma(_1377.x, _1380.x, fma(_1308.x, _1311.x, _1249)), fma(_1377.y, _1380.y, fma(_1308.y, _1311.y, _1250))));
    vec2 _1434 = unpackHalf2x16((packHalf2x16(vec2(_1043.y, 0.0)) << 16u) + packHalf2x16(vec2(_1043.x, 0.0)));
    vec2 _1437 = unpackHalf2x16(968374712u);
    _42._m0[uint(int(_1223 + 112u) >> int(2u))] = packHalf2x16(vec2(fma(_1389.x, _1392.x, fma(_1316.x, _1319.x, _1257)), fma(_1389.y, _1392.y, fma(_1316.y, _1319.y, _1258))));
    _42._m0[uint(int(_1224) >> int(2u))] = packHalf2x16(vec2(fma(_1412.x, _1415.x, fma(_1332.x, _1335.x, _1273)), fma(_1412.y, _1415.y, fma(_1332.y, _1335.y, _1274))));
    uint _1453 = ((gl_SubgroupInvocationID << 1u) | (~6u)) & 6u;
    _42._m0[uint(int(_1224 + 112u) >> int(2u))] = packHalf2x16(vec2(fma(_1399.x, _1402.x, fma(_1324.x, _1327.x, _1265)), fma(_1399.y, _1402.y, fma(_1324.y, _1327.y, _1266))));
    _42._m0[uint(int(_1225) >> int(2u))] = packHalf2x16(vec2(fma(_1434.x, _1437.x, fma(_1348.x, _1351.x, _1289)), fma(_1434.y, _1437.y, fma(_1348.y, _1351.y, _1290))));
    _42._m0[uint(int(_1225 + 112u) >> int(2u))] = packHalf2x16(vec2(fma(_1422.x, _1425.x, fma(_1340.x, _1343.x, _1281)), fma(_1422.y, _1425.y, fma(_1340.y, _1343.y, _1282))));
    if (!(gl_LocalInvocationID.x >= 17u))
    {
        uint _1478 = gl_LocalInvocationID.x + 512u;
        uint _1484 = (bitfieldExtract(_1478, int(16u), int(16u)) * 17097u) + bitfieldExtract(bitfieldExtract(_1478, int(0u), int(16u)) * 17097u, int(16u), int(16u));
        uint _1495 = ((((bitfieldExtract(_1478, int(0u), int(16u)) * 45590u) + bitfieldExtract(_1484, int(0u), int(16u))) >> 16u) + ((bitfieldExtract(_1478, int(16u), int(16u)) * 45590u) + bitfieldExtract(_1484, int(16u), int(16u)))) >> 4u;
        uint _1513 = ((((bitfieldExtract(_1495, int(0u), int(16u)) * 65535u) + (bitfieldExtract(_1495, int(16u), int(16u)) * 65513u)) << 16u) + ((bitfieldExtract(_1495, int(0u), int(16u)) * 65513u) + _1478)) << 1u;
        precise float _1524 = float(int((((bitfieldExtract(_1495, int(16u), int(16u)) * 2u) << 16u) + ((bitfieldExtract(_1495, int(0u), int(16u)) * 2u) + _726)) + 4294967293u)) + 1.0;
        precise float _1528 = _1524 * c0_1.data[13u];
        precise float _1529 = float(int((((bitfieldExtract(_728, int(16u), int(16u)) * 10u) << 16u) + ((bitfieldExtract(_728, int(0u), int(16u)) * 10u) + _1513)) + 4294967293u)) + 1.0;
        precise float _1532 = _1529 * c0_1.data[12u];
        vec4 _1537 = textureGatherOffsets(cs_tex0_c0, vec2(_1532, _1528), ivec2[](ivec2(0), ivec2(1, 0), ivec2(0, 1), ivec2(1)));
        vec4 _1558 = textureGatherOffsets(cs_tex0_c0, vec2(_1532, _1528), ivec2[](ivec2(0), ivec2(1, 0), ivec2(0, 1), ivec2(1)), int(1u));
        vec4 _1579 = textureGatherOffsets(cs_tex0_c0, vec2(_1532, _1528), ivec2[](ivec2(0), ivec2(1, 0), ivec2(0, 1), ivec2(1)), int(2u));
        uint _1603 = (((bitfieldExtract(_1495, int(16u), int(16u)) * 112u) << 16u) + ((bitfieldExtract(_1495, int(0u), int(16u)) * 112u) + _1513)) << 1u;
        vec2 _1604 = unpackHalf2x16((packHalf2x16(vec2(_1579.y, 0.0)) << 16u) + packHalf2x16(vec2(_1579.x, 0.0)));
        vec2 _1607 = unpackHalf2x16(748563614u);
        precise float _1610 = _1604.x * _1607.x;
        precise float _1611 = _1604.y * _1607.y;
        vec2 _1612 = unpackHalf2x16((packHalf2x16(vec2(_1579.w, 0.0)) << 16u) + packHalf2x16(vec2(_1579.z, 0.0)));
        vec2 _1615 = unpackHalf2x16(748563614u);
        precise float _1618 = _1612.x * _1615.x;
        precise float _1619 = _1612.y * _1615.y;
        vec2 _1620 = unpackHalf2x16((packHalf2x16(vec2(_1537.y, 0.0)) << 16u) + packHalf2x16(vec2(_1537.x, 0.0)));
        vec2 _1623 = unpackHalf2x16(852308685u);
        vec2 _1628 = unpackHalf2x16((packHalf2x16(vec2(_1537.w, 0.0)) << 16u) + packHalf2x16(vec2(_1537.z, 0.0)));
        vec2 _1631 = unpackHalf2x16(852308685u);
        vec2 _1636 = unpackHalf2x16((packHalf2x16(vec2(_1558.y, 0.0)) << 16u) + packHalf2x16(vec2(_1558.x, 0.0)));
        vec2 _1639 = unpackHalf2x16(968374712u);
        vec2 _1646 = unpackHalf2x16((packHalf2x16(vec2(_1558.w, 0.0)) << 16u) + packHalf2x16(vec2(_1558.z, 0.0)));
        vec2 _1649 = unpackHalf2x16(968374712u);
        _42._m0[uint(int(_1603) >> int(2u))] = packHalf2x16(vec2(fma(_1636.x, _1639.x, fma(_1620.x, _1623.x, _1610)), fma(_1636.y, _1639.y, fma(_1620.y, _1623.y, _1611))));
        _42._m0[uint(int(_1603 + 112u) >> int(2u))] = packHalf2x16(vec2(fma(_1646.x, _1649.x, fma(_1628.x, _1631.x, _1618)), fma(_1646.y, _1649.y, fma(_1628.y, _1631.y, _1619))));
    }
    barrier();
    uint _1662 = (((bitfieldExtract(_1214, int(16u), int(16u)) * 56u) << 16u) + ((bitfieldExtract(_1214, int(0u), int(16u)) * 56u) + (((bitfieldExtract(_1206, int(16u), int(16u)) * 10u) << 16u) + ((bitfieldExtract(_1206, int(0u), int(16u)) * 10u) + _1453)))) << 1u;
    uint _1669 = ((_1149 + 1536u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec4 _1671 = ssbo0_3._m0[_1669];
    uint _1682 = ((_1149 + 2048u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec4 _1684 = ssbo0_3._m0[_1682];
    uint _1689 = uint(int(_1662) >> int(2u));
    uint _1691 = _42._m0[_1689];
    uint _1693 = uint(int(_1662 + 16u) >> int(2u));
    uint _1695 = _42._m0[_1693];
    uint _1698 = uint(int(_1662 + 896u) >> int(2u));
    uint _1700 = _42._m0[_1698];
    uint _1703 = uint(int(_1662 + 912u) >> int(2u));
    uint _1705 = _42._m0[_1703];
    uint _1708 = uint(int(_1662 + 1120u) >> int(2u));
    uint _1710 = _42._m0[_1708];
    uint _1713 = uint(int(_1662 + 1136u) >> int(2u));
    uint _1715 = _42._m0[_1713];
    uint _1718 = uint(int(_1662 + 2016u) >> int(2u));
    uint _1720 = _42._m0[_1718];
    uint _1723 = uint(int(_1662 + 2032u) >> int(2u));
    uint _1725 = _42._m0[_1723];
    uint _1728 = uint(int(_1662 + 2240u) >> int(2u));
    uint _1730 = _42._m0[_1728];
    uint _1733 = uint(int(_1662 + 2256u) >> int(2u));
    uint _1735 = _42._m0[_1733];
    uint _1738 = uint(int(_1662 + 3136u) >> int(2u));
    uint _1740 = _42._m0[_1738];
    uint _1743 = uint(int(_1662 + 3152u) >> int(2u));
    uint _1745 = _42._m0[_1743];
    uint _1748 = uint(int(_1662 + 3360u) >> int(2u));
    uint _1750 = _42._m0[_1748];
    uint _1753 = uint(int(_1662 + 3376u) >> int(2u));
    uint _1755 = _42._m0[_1753];
    uint _1758 = uint(int(_1662 + 4256u) >> int(2u));
    uint _1760 = _42._m0[_1758];
    uint _1763 = uint(int(_1662 + 4272u) >> int(2u));
    uint _1765 = _42._m0[_1763];
    barrier();
    uvec2 _1769 = _84(uvec4(_1157), uvec2(_1710, _1715), uvec2(0u));
    uint _1770 = _1769.x;
    uvec2 _1775 = _84(uvec4(_1157), uvec2(_1720, _1725), uvec2(0u));
    uint _1776 = _1775.x;
    uvec2 _1781 = _84(uvec4(_1157), uvec2(_1730, _1735), uvec2(0u));
    uint _1782 = _1781.x;
    uvec2 _1787 = _84(uvec4(_1157), uvec2(_1740, _1745), uvec2(0u));
    uint _1788 = _1787.x;
    uvec2 _1793 = _84(uvec4(_1157), uvec2(_1750, _1755), uvec2(0u));
    uint _1794 = _1793.x;
    uvec2 _1799 = _84(uvec4(_1157), uvec2(_1760, _1765), uvec2(0u));
    uint _1800 = _1799.x;
    uvec2 _1805 = _84(uvec4(_1157), uvec2(_1691, _1695), uvec2(0u));
    uint _1806 = _1805.x;
    uvec2 _1811 = _84(uvec4(_1157), uvec2(_1700, _1705), uvec2(0u));
    uint _1812 = _1811.x;
    uint _1856 = ((_1149 + 2560u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec2 _1878 = _84(uvec4(_1183), uvec2(_1691, _1695), uvec2(0u));
    uint _1879 = _1878.x;
    uvec2 _1884 = _84(uvec4(_1183), uvec2(_1700, _1705), uvec2(0u));
    uint _1885 = _1884.x;
    uvec2 _1890 = _84(uvec4(_1183), uvec2(_1710, _1715), uvec2(0u));
    uint _1891 = _1890.x;
    uvec2 _1896 = _84(uvec4(_1183), uvec2(_1720, _1725), uvec2(0u));
    uint _1897 = _1896.x;
    uvec2 _1902 = _84(uvec4(_1183), uvec2(_1730, _1735), uvec2(0u));
    uint _1903 = _1902.x;
    uvec2 _1908 = _84(uvec4(_1183), uvec2(_1740, _1745), uvec2(0u));
    uint _1909 = _1908.x;
    uvec2 _1914 = _84(uvec4(_1183), uvec2(_1750, _1755), uvec2(0u));
    uint _1915 = _1914.x;
    uvec2 _1920 = _84(uvec4(_1183), uvec2(_1760, _1765), uvec2(0u));
    uint _1921 = _1920.x;
    uint _1929 = ((_1149 + 3072u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uint _1942 = ((_1149 + 3584u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec2 _1952 = _84(uvec4(_1879, _1878.y, _1885, _1884.y), uvec2(_1671.xy), uvec2(_84(uvec4(_1806, _1805.y, _1812, _1811.y), uvec2(_1170.xy), uvec2(0u))));
    uint _1953 = _1952.x;
    uint _1954 = _1952.y;
    uvec2 _1958 = _84(uvec4(_1879, _1878.y, _1885, _1884.y), uvec2(_1671.zw), uvec2(_84(uvec4(_1806, _1805.y, _1812, _1811.y), uvec2(_1170.zw), uvec2(0u))));
    uint _1959 = _1958.x;
    uint _1960 = _1958.y;
    uvec2 _1964 = _84(uvec4(_1891, _1890.y, _1897, _1896.y), uvec2(_1671.zw), uvec2(_84(uvec4(_1770, _1769.y, _1776, _1775.y), uvec2(_1170.zw), uvec2(0u))));
    uint _1965 = _1964.x;
    uint _1966 = _1964.y;
    uvec2 _1970 = _84(uvec4(_1903, _1902.y, _1909, _1908.y), uvec2(_1671.xy), uvec2(_84(uvec4(_1782, _1781.y, _1788, _1787.y), uvec2(_1170.xy), uvec2(0u))));
    uint _1971 = _1970.x;
    uint _1972 = _1970.y;
    uvec2 _1976 = _84(uvec4(_1903, _1902.y, _1909, _1908.y), uvec2(_1671.zw), uvec2(_84(uvec4(_1782, _1781.y, _1788, _1787.y), uvec2(_1170.zw), uvec2(0u))));
    uint _1977 = _1976.x;
    uint _1978 = _1976.y;
    uvec2 _1982 = _84(uvec4(_1915, _1914.y, _1921, _1920.y), uvec2(_1671.xy), uvec2(_84(uvec4(_1794, _1793.y, _1800, _1799.y), uvec2(_1170.xy), uvec2(0u))));
    uint _1983 = _1982.x;
    uint _1984 = _1982.y;
    uvec2 _1988 = _84(uvec4(_1915, _1914.y, _1921, _1920.y), uvec2(_1671.zw), uvec2(_84(uvec4(_1794, _1793.y, _1800, _1799.y), uvec2(_1170.zw), uvec2(0u))));
    uint _1989 = _1988.x;
    uint _1990 = _1988.y;
    uvec2 _1994 = _84(uvec4(_1891, _1890.y, _1897, _1896.y), uvec2(_1671.xy), uvec2(_84(uvec4(_1770, _1769.y, _1776, _1775.y), uvec2(_1170.xy), uvec2(0u))));
    uint _1995 = _1994.x;
    uint _1996 = _1994.y;
    vec2 _1999 = unpackHalf2x16(0u);
    vec2 _2006 = unpackHalf2x16(0u);
    uint _2012 = (packHalf2x16(vec2(max(unpackHalf2x16(_1971).y, _2006.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1971).x, _1999.x), 0.0));
    uint _2019 = ((_1149 + 4096u) - (c0.data[44u] & 4294967280u)) >> 4u;
    vec2 _2028 = unpackHalf2x16(0u);
    vec2 _2035 = unpackHalf2x16(0u);
    uint _2041 = (packHalf2x16(vec2(max(unpackHalf2x16(_1972).y, _2035.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1972).x, _2028.x), 0.0));
    vec2 _2044 = unpackHalf2x16(0u);
    vec2 _2051 = unpackHalf2x16(0u);
    uint _2057 = (packHalf2x16(vec2(max(unpackHalf2x16(_1977).y, _2051.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1977).x, _2044.x), 0.0));
    vec2 _2060 = unpackHalf2x16(0u);
    vec2 _2067 = unpackHalf2x16(0u);
    uint _2073 = (packHalf2x16(vec2(max(unpackHalf2x16(_1959).y, _2067.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1959).x, _2060.x), 0.0));
    vec2 _2076 = unpackHalf2x16(0u);
    vec2 _2083 = unpackHalf2x16(0u);
    uint _2089 = (packHalf2x16(vec2(max(unpackHalf2x16(_1978).y, _2083.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1978).x, _2076.x), 0.0));
    vec2 _2092 = unpackHalf2x16(0u);
    vec2 _2099 = unpackHalf2x16(0u);
    uint _2105 = (packHalf2x16(vec2(max(unpackHalf2x16(_1984).y, _2099.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1984).x, _2092.x), 0.0));
    vec2 _2108 = unpackHalf2x16(0u);
    vec2 _2115 = unpackHalf2x16(0u);
    uint _2121 = (packHalf2x16(vec2(max(unpackHalf2x16(_1983).y, _2115.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1983).x, _2108.x), 0.0));
    vec2 _2124 = unpackHalf2x16(0u);
    vec2 _2131 = unpackHalf2x16(0u);
    uint _2137 = (packHalf2x16(vec2(max(unpackHalf2x16(_1953).y, _2131.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1953).x, _2124.x), 0.0));
    vec2 _2140 = unpackHalf2x16(0u);
    vec2 _2147 = unpackHalf2x16(0u);
    uint _2153 = (packHalf2x16(vec2(max(unpackHalf2x16(_1989).y, _2147.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1989).x, _2140.x), 0.0));
    vec2 _2156 = unpackHalf2x16(0u);
    vec2 _2163 = unpackHalf2x16(0u);
    uint _2169 = (packHalf2x16(vec2(max(unpackHalf2x16(_1990).y, _2163.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1990).x, _2156.x), 0.0));
    vec2 _2172 = unpackHalf2x16(0u);
    vec2 _2179 = unpackHalf2x16(0u);
    uint _2185 = (packHalf2x16(vec2(max(unpackHalf2x16(_1954).y, _2179.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1954).x, _2172.x), 0.0));
    vec2 _2188 = unpackHalf2x16(0u);
    vec2 _2195 = unpackHalf2x16(0u);
    uint _2201 = (packHalf2x16(vec2(max(unpackHalf2x16(_1960).y, _2195.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1960).x, _2188.x), 0.0));
    vec2 _2204 = unpackHalf2x16(0u);
    vec2 _2211 = unpackHalf2x16(0u);
    uint _2217 = (packHalf2x16(vec2(max(unpackHalf2x16(_1995).y, _2211.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1995).x, _2204.x), 0.0));
    vec2 _2220 = unpackHalf2x16(0u);
    vec2 _2227 = unpackHalf2x16(0u);
    uint _2233 = (packHalf2x16(vec2(max(unpackHalf2x16(_1965).y, _2227.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1965).x, _2220.x), 0.0));
    vec2 _2236 = unpackHalf2x16(0u);
    vec2 _2243 = unpackHalf2x16(0u);
    uint _2249 = (packHalf2x16(vec2(max(unpackHalf2x16(_1996).y, _2243.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1996).x, _2236.x), 0.0));
    vec2 _2252 = unpackHalf2x16(0u);
    vec2 _2259 = unpackHalf2x16(0u);
    uint _2265 = (packHalf2x16(vec2(max(unpackHalf2x16(_1966).y, _2259.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_1966).x, _2252.x), 0.0));
    uvec2 _2269 = _84(uvec4(_1684), uvec2(_2041, _2089), uvec2(0u));
    uint _2270 = _2269.x;
    uvec2 _2275 = _84(uvec4(_1684), uvec2(_2012, _2057), uvec2(0u));
    uint _2276 = _2275.x;
    uvec2 _2281 = _84(uvec4(_1684), uvec2(_2121, _2153), uvec2(0u));
    uint _2282 = _2281.x;
    uvec2 _2287 = _84(uvec4(_1684), uvec2(_2105, _2169), uvec2(0u));
    uint _2288 = _2287.x;
    uvec2 _2293 = _84(uvec4(_1684), uvec2(_2137, _2073), uvec2(0u));
    uint _2294 = _2293.x;
    uvec2 _2299 = _84(uvec4(_1684), uvec2(_2185, _2201), uvec2(0u));
    uint _2300 = _2299.x;
    uvec2 _2305 = _84(uvec4(_1684), uvec2(_2217, _2233), uvec2(0u));
    uint _2306 = _2305.x;
    uvec2 _2311 = _84(uvec4(_1684), uvec2(_2249, _2265), uvec2(0u));
    uint _2312 = _2311.x;
    uint _2368 = ((_1149 + 4608u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec2 _2378 = _84(uvec4(ssbo0_3._m0[_1929]), uvec2(_2249, _2265), uvec2(0u));
    uint _2379 = _2378.x;
    uvec2 _2384 = _84(uvec4(ssbo0_3._m0[_1929]), uvec2(_2185, _2201), uvec2(0u));
    uint _2385 = _2384.x;
    uvec2 _2390 = _84(uvec4(ssbo0_3._m0[_1929]), uvec2(_2012, _2057), uvec2(0u));
    uint _2391 = _2390.x;
    uvec2 _2396 = _84(uvec4(ssbo0_3._m0[_1929]), uvec2(_2137, _2073), uvec2(0u));
    uint _2397 = _2396.x;
    uvec2 _2402 = _84(uvec4(ssbo0_3._m0[_1929]), uvec2(_2217, _2233), uvec2(0u));
    uint _2403 = _2402.x;
    uvec2 _2408 = _84(uvec4(ssbo0_3._m0[_1929]), uvec2(_2041, _2089), uvec2(0u));
    uint _2409 = _2408.x;
    uvec2 _2414 = _84(uvec4(ssbo0_3._m0[_1929]), uvec2(_2121, _2153), uvec2(0u));
    uint _2415 = _2414.x;
    uvec2 _2420 = _84(uvec4(ssbo0_3._m0[_1929]), uvec2(_2105, _2169), uvec2(0u));
    uint _2421 = _2420.x;
    uint _2429 = ((_1149 + 5120u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uint _2442 = ((_1149 + 5632u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec2 _2452 = _84(uvec4(_2397, _2396.y, _2385, _2384.y), uvec2(ssbo0_3._m0[_1942].xy), uvec2(_84(uvec4(_2294, _2293.y, _2300, _2299.y), uvec2(ssbo0_3._m0[_1856].xy), uvec2(0u))));
    uint _2453 = _2452.x;
    uint _2454 = _2452.y;
    uvec2 _2458 = _84(uvec4(_2403, _2402.y, _2379, _2378.y), uvec2(ssbo0_3._m0[_1942].xy), uvec2(_84(uvec4(_2306, _2305.y, _2312, _2311.y), uvec2(ssbo0_3._m0[_1856].xy), uvec2(0u))));
    uint _2459 = _2458.x;
    uint _2460 = _2458.y;
    uvec2 _2464 = _84(uvec4(_2391, _2390.y, _2409, _2408.y), uvec2(ssbo0_3._m0[_1942].xy), uvec2(_84(uvec4(_2276, _2275.y, _2270, _2269.y), uvec2(ssbo0_3._m0[_1856].xy), uvec2(0u))));
    uint _2465 = _2464.x;
    uint _2466 = _2464.y;
    uvec2 _2470 = _84(uvec4(_2391, _2390.y, _2409, _2408.y), uvec2(ssbo0_3._m0[_1942].zw), uvec2(_84(uvec4(_2276, _2275.y, _2270, _2269.y), uvec2(ssbo0_3._m0[_1856].zw), uvec2(0u))));
    uint _2471 = _2470.x;
    uint _2472 = _2470.y;
    uvec2 _2476 = _84(uvec4(_2415, _2414.y, _2421, _2420.y), uvec2(ssbo0_3._m0[_1942].xy), uvec2(_84(uvec4(_2282, _2281.y, _2288, _2287.y), uvec2(ssbo0_3._m0[_1856].xy), uvec2(0u))));
    uint _2477 = _2476.x;
    uint _2478 = _2476.y;
    uvec2 _2482 = _84(uvec4(_2415, _2414.y, _2421, _2420.y), uvec2(ssbo0_3._m0[_1942].zw), uvec2(_84(uvec4(_2282, _2281.y, _2288, _2287.y), uvec2(ssbo0_3._m0[_1856].zw), uvec2(0u))));
    uint _2483 = _2482.x;
    uint _2484 = _2482.y;
    uvec2 _2488 = _84(uvec4(_2397, _2396.y, _2385, _2384.y), uvec2(ssbo0_3._m0[_1942].zw), uvec2(_84(uvec4(_2294, _2293.y, _2300, _2299.y), uvec2(ssbo0_3._m0[_1856].zw), uvec2(0u))));
    uint _2489 = _2488.x;
    uint _2490 = _2488.y;
    uvec2 _2494 = _84(uvec4(_2403, _2402.y, _2379, _2378.y), uvec2(ssbo0_3._m0[_1942].zw), uvec2(_84(uvec4(_2306, _2305.y, _2312, _2311.y), uvec2(ssbo0_3._m0[_1856].zw), uvec2(0u))));
    uint _2495 = _2494.x;
    uint _2496 = _2494.y;
    vec2 _2499 = unpackHalf2x16(0u);
    vec2 _2506 = unpackHalf2x16(0u);
    uint _2512 = (packHalf2x16(vec2(max(unpackHalf2x16(_2465).y, _2506.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2465).x, _2499.x), 0.0));
    uint _2519 = ((_1149 + 6144u) - (c0.data[44u] & 4294967280u)) >> 4u;
    vec2 _2528 = unpackHalf2x16(0u);
    vec2 _2535 = unpackHalf2x16(0u);
    uint _2541 = (packHalf2x16(vec2(max(unpackHalf2x16(_2466).y, _2535.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2466).x, _2528.x), 0.0));
    vec2 _2544 = unpackHalf2x16(0u);
    vec2 _2551 = unpackHalf2x16(0u);
    uint _2557 = (packHalf2x16(vec2(max(unpackHalf2x16(_2471).y, _2551.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2471).x, _2544.x), 0.0));
    vec2 _2560 = unpackHalf2x16(0u);
    vec2 _2567 = unpackHalf2x16(0u);
    uint _2573 = (packHalf2x16(vec2(max(unpackHalf2x16(_2472).y, _2567.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2472).x, _2560.x), 0.0));
    vec2 _2576 = unpackHalf2x16(0u);
    vec2 _2583 = unpackHalf2x16(0u);
    uint _2589 = (packHalf2x16(vec2(max(unpackHalf2x16(_2478).y, _2583.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2478).x, _2576.x), 0.0));
    vec2 _2592 = unpackHalf2x16(0u);
    vec2 _2599 = unpackHalf2x16(0u);
    uint _2605 = (packHalf2x16(vec2(max(unpackHalf2x16(_2477).y, _2599.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2477).x, _2592.x), 0.0));
    vec2 _2608 = unpackHalf2x16(0u);
    vec2 _2615 = unpackHalf2x16(0u);
    uint _2621 = (packHalf2x16(vec2(max(unpackHalf2x16(_2483).y, _2615.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2483).x, _2608.x), 0.0));
    vec2 _2624 = unpackHalf2x16(0u);
    vec2 _2631 = unpackHalf2x16(0u);
    uint _2637 = (packHalf2x16(vec2(max(unpackHalf2x16(_2484).y, _2631.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2484).x, _2624.x), 0.0));
    vec2 _2640 = unpackHalf2x16(0u);
    vec2 _2647 = unpackHalf2x16(0u);
    uint _2653 = (packHalf2x16(vec2(max(unpackHalf2x16(_2453).y, _2647.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2453).x, _2640.x), 0.0));
    vec2 _2656 = unpackHalf2x16(0u);
    vec2 _2663 = unpackHalf2x16(0u);
    uint _2669 = (packHalf2x16(vec2(max(unpackHalf2x16(_2489).y, _2663.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2489).x, _2656.x), 0.0));
    vec2 _2672 = unpackHalf2x16(0u);
    vec2 _2679 = unpackHalf2x16(0u);
    uint _2685 = (packHalf2x16(vec2(max(unpackHalf2x16(_2454).y, _2679.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2454).x, _2672.x), 0.0));
    vec2 _2688 = unpackHalf2x16(0u);
    vec2 _2695 = unpackHalf2x16(0u);
    uint _2701 = (packHalf2x16(vec2(max(unpackHalf2x16(_2490).y, _2695.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2490).x, _2688.x), 0.0));
    vec2 _2704 = unpackHalf2x16(0u);
    vec2 _2711 = unpackHalf2x16(0u);
    uint _2717 = (packHalf2x16(vec2(max(unpackHalf2x16(_2459).y, _2711.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2459).x, _2704.x), 0.0));
    vec2 _2720 = unpackHalf2x16(0u);
    vec2 _2727 = unpackHalf2x16(0u);
    uint _2733 = (packHalf2x16(vec2(max(unpackHalf2x16(_2495).y, _2727.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2495).x, _2720.x), 0.0));
    vec2 _2736 = unpackHalf2x16(0u);
    vec2 _2743 = unpackHalf2x16(0u);
    uint _2749 = (packHalf2x16(vec2(max(unpackHalf2x16(_2460).y, _2743.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2460).x, _2736.x), 0.0));
    vec2 _2752 = unpackHalf2x16(0u);
    vec2 _2759 = unpackHalf2x16(0u);
    uint _2765 = (packHalf2x16(vec2(max(unpackHalf2x16(_2496).y, _2759.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2496).x, _2752.x), 0.0));
    uvec2 _2769 = _84(uvec4(ssbo0_3._m0[_2019]), uvec2(_2512, _2557), uvec2(0u));
    uint _2770 = _2769.x;
    uvec2 _2775 = _84(uvec4(ssbo0_3._m0[_2019]), uvec2(_2541, _2573), uvec2(0u));
    uint _2776 = _2775.x;
    uvec2 _2781 = _84(uvec4(ssbo0_3._m0[_2019]), uvec2(_2605, _2621), uvec2(0u));
    uint _2782 = _2781.x;
    uvec2 _2787 = _84(uvec4(ssbo0_3._m0[_2019]), uvec2(_2589, _2637), uvec2(0u));
    uint _2788 = _2787.x;
    uvec2 _2793 = _84(uvec4(ssbo0_3._m0[_2019]), uvec2(_2653, _2669), uvec2(0u));
    uint _2794 = _2793.x;
    uvec2 _2799 = _84(uvec4(ssbo0_3._m0[_2019]), uvec2(_2685, _2701), uvec2(0u));
    uint _2800 = _2799.x;
    uvec2 _2805 = _84(uvec4(ssbo0_3._m0[_2019]), uvec2(_2717, _2733), uvec2(0u));
    uint _2806 = _2805.x;
    uvec2 _2811 = _84(uvec4(ssbo0_3._m0[_2019]), uvec2(_2749, _2765), uvec2(0u));
    uint _2812 = _2811.x;
    uint _2868 = ((_1149 + 6656u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec2 _2878 = _84(uvec4(ssbo0_3._m0[_2429]), uvec2(_2685, _2701), uvec2(0u));
    uint _2879 = _2878.x;
    uvec2 _2884 = _84(uvec4(ssbo0_3._m0[_2429]), uvec2(_2749, _2765), uvec2(0u));
    uint _2885 = _2884.x;
    uvec2 _2890 = _84(uvec4(ssbo0_3._m0[_2429]), uvec2(_2653, _2669), uvec2(0u));
    uint _2891 = _2890.x;
    uvec2 _2896 = _84(uvec4(ssbo0_3._m0[_2429]), uvec2(_2717, _2733), uvec2(0u));
    uint _2897 = _2896.x;
    uvec2 _2902 = _84(uvec4(ssbo0_3._m0[_2429]), uvec2(_2512, _2557), uvec2(0u));
    uint _2903 = _2902.x;
    uvec2 _2908 = _84(uvec4(ssbo0_3._m0[_2429]), uvec2(_2541, _2573), uvec2(0u));
    uint _2909 = _2908.x;
    uvec2 _2914 = _84(uvec4(ssbo0_3._m0[_2429]), uvec2(_2605, _2621), uvec2(0u));
    uint _2915 = _2914.x;
    uvec2 _2920 = _84(uvec4(ssbo0_3._m0[_2429]), uvec2(_2589, _2637), uvec2(0u));
    uint _2921 = _2920.x;
    uint _2929 = ((_1149 + 7168u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uint _2942 = ((_1149 + 7680u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec2 _2952 = _84(uvec4(_2891, _2890.y, _2879, _2878.y), uvec2(ssbo0_3._m0[_2442].xy), uvec2(_84(uvec4(_2794, _2793.y, _2800, _2799.y), uvec2(ssbo0_3._m0[_2368].xy), uvec2(0u))));
    uint _2953 = _2952.x;
    uint _2954 = _2952.y;
    uvec2 _2958 = _84(uvec4(_2897, _2896.y, _2885, _2884.y), uvec2(ssbo0_3._m0[_2442].xy), uvec2(_84(uvec4(_2806, _2805.y, _2812, _2811.y), uvec2(ssbo0_3._m0[_2368].xy), uvec2(0u))));
    uint _2959 = _2958.x;
    uint _2960 = _2958.y;
    uvec2 _2964 = _84(uvec4(_2903, _2902.y, _2909, _2908.y), uvec2(ssbo0_3._m0[_2442].xy), uvec2(_84(uvec4(_2770, _2769.y, _2776, _2775.y), uvec2(ssbo0_3._m0[_2368].xy), uvec2(0u))));
    uint _2965 = _2964.x;
    uint _2966 = _2964.y;
    uvec2 _2970 = _84(uvec4(_2903, _2902.y, _2909, _2908.y), uvec2(ssbo0_3._m0[_2442].zw), uvec2(_84(uvec4(_2770, _2769.y, _2776, _2775.y), uvec2(ssbo0_3._m0[_2368].zw), uvec2(0u))));
    uint _2971 = _2970.x;
    uint _2972 = _2970.y;
    uvec2 _2976 = _84(uvec4(_2915, _2914.y, _2921, _2920.y), uvec2(ssbo0_3._m0[_2442].xy), uvec2(_84(uvec4(_2782, _2781.y, _2788, _2787.y), uvec2(ssbo0_3._m0[_2368].xy), uvec2(0u))));
    uint _2977 = _2976.x;
    uint _2978 = _2976.y;
    uvec2 _2982 = _84(uvec4(_2915, _2914.y, _2921, _2920.y), uvec2(ssbo0_3._m0[_2442].zw), uvec2(_84(uvec4(_2782, _2781.y, _2788, _2787.y), uvec2(ssbo0_3._m0[_2368].zw), uvec2(0u))));
    uint _2983 = _2982.x;
    uint _2984 = _2982.y;
    uvec2 _2988 = _84(uvec4(_2891, _2890.y, _2879, _2878.y), uvec2(ssbo0_3._m0[_2442].zw), uvec2(_84(uvec4(_2794, _2793.y, _2800, _2799.y), uvec2(ssbo0_3._m0[_2368].zw), uvec2(0u))));
    uint _2989 = _2988.x;
    uint _2990 = _2988.y;
    uvec2 _2994 = _84(uvec4(_2897, _2896.y, _2885, _2884.y), uvec2(ssbo0_3._m0[_2442].zw), uvec2(_84(uvec4(_2806, _2805.y, _2812, _2811.y), uvec2(ssbo0_3._m0[_2368].zw), uvec2(0u))));
    uint _2995 = _2994.x;
    uint _2996 = _2994.y;
    vec2 _2999 = unpackHalf2x16(0u);
    vec2 _3006 = unpackHalf2x16(0u);
    uint _3012 = (packHalf2x16(vec2(max(unpackHalf2x16(_2965).y, _3006.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2965).x, _2999.x), 0.0));
    uint _3019 = ((_1149 + 8192u) - (c0.data[44u] & 4294967280u)) >> 4u;
    vec2 _3028 = unpackHalf2x16(0u);
    vec2 _3035 = unpackHalf2x16(0u);
    uint _3041 = (packHalf2x16(vec2(max(unpackHalf2x16(_2966).y, _3035.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2966).x, _3028.x), 0.0));
    vec2 _3044 = unpackHalf2x16(0u);
    vec2 _3051 = unpackHalf2x16(0u);
    uint _3057 = (packHalf2x16(vec2(max(unpackHalf2x16(_2971).y, _3051.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2971).x, _3044.x), 0.0));
    vec2 _3060 = unpackHalf2x16(0u);
    vec2 _3067 = unpackHalf2x16(0u);
    uint _3073 = (packHalf2x16(vec2(max(unpackHalf2x16(_2972).y, _3067.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2972).x, _3060.x), 0.0));
    vec2 _3076 = unpackHalf2x16(0u);
    vec2 _3083 = unpackHalf2x16(0u);
    uint _3089 = (packHalf2x16(vec2(max(unpackHalf2x16(_2978).y, _3083.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2978).x, _3076.x), 0.0));
    vec2 _3092 = unpackHalf2x16(0u);
    vec2 _3099 = unpackHalf2x16(0u);
    uint _3105 = (packHalf2x16(vec2(max(unpackHalf2x16(_2977).y, _3099.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2977).x, _3092.x), 0.0));
    vec2 _3108 = unpackHalf2x16(0u);
    vec2 _3115 = unpackHalf2x16(0u);
    uint _3121 = (packHalf2x16(vec2(max(unpackHalf2x16(_2983).y, _3115.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2983).x, _3108.x), 0.0));
    vec2 _3124 = unpackHalf2x16(0u);
    vec2 _3131 = unpackHalf2x16(0u);
    uint _3137 = (packHalf2x16(vec2(max(unpackHalf2x16(_2984).y, _3131.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2984).x, _3124.x), 0.0));
    vec2 _3140 = unpackHalf2x16(0u);
    vec2 _3147 = unpackHalf2x16(0u);
    uint _3153 = (packHalf2x16(vec2(max(unpackHalf2x16(_2953).y, _3147.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2953).x, _3140.x), 0.0));
    vec2 _3156 = unpackHalf2x16(0u);
    vec2 _3163 = unpackHalf2x16(0u);
    uint _3169 = (packHalf2x16(vec2(max(unpackHalf2x16(_2989).y, _3163.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2989).x, _3156.x), 0.0));
    vec2 _3172 = unpackHalf2x16(0u);
    vec2 _3179 = unpackHalf2x16(0u);
    uint _3185 = (packHalf2x16(vec2(max(unpackHalf2x16(_2954).y, _3179.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2954).x, _3172.x), 0.0));
    vec2 _3188 = unpackHalf2x16(0u);
    vec2 _3195 = unpackHalf2x16(0u);
    uint _3201 = (packHalf2x16(vec2(max(unpackHalf2x16(_2990).y, _3195.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2990).x, _3188.x), 0.0));
    vec2 _3204 = unpackHalf2x16(0u);
    vec2 _3211 = unpackHalf2x16(0u);
    uint _3217 = (packHalf2x16(vec2(max(unpackHalf2x16(_2959).y, _3211.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2959).x, _3204.x), 0.0));
    vec2 _3220 = unpackHalf2x16(0u);
    vec2 _3227 = unpackHalf2x16(0u);
    uint _3233 = (packHalf2x16(vec2(max(unpackHalf2x16(_2995).y, _3227.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2995).x, _3220.x), 0.0));
    vec2 _3236 = unpackHalf2x16(0u);
    vec2 _3243 = unpackHalf2x16(0u);
    uint _3249 = (packHalf2x16(vec2(max(unpackHalf2x16(_2960).y, _3243.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2960).x, _3236.x), 0.0));
    vec2 _3252 = unpackHalf2x16(0u);
    vec2 _3259 = unpackHalf2x16(0u);
    uint _3265 = (packHalf2x16(vec2(max(unpackHalf2x16(_2996).y, _3259.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_2996).x, _3252.x), 0.0));
    uvec2 _3269 = _84(uvec4(ssbo0_3._m0[_2519]), uvec2(_3012, _3057), uvec2(0u));
    uint _3270 = _3269.x;
    uvec2 _3275 = _84(uvec4(ssbo0_3._m0[_2519]), uvec2(_3041, _3073), uvec2(0u));
    uint _3276 = _3275.x;
    uvec2 _3281 = _84(uvec4(ssbo0_3._m0[_2519]), uvec2(_3105, _3121), uvec2(0u));
    uint _3282 = _3281.x;
    uvec2 _3287 = _84(uvec4(ssbo0_3._m0[_2519]), uvec2(_3089, _3137), uvec2(0u));
    uint _3288 = _3287.x;
    uvec2 _3293 = _84(uvec4(ssbo0_3._m0[_2519]), uvec2(_3153, _3169), uvec2(0u));
    uint _3294 = _3293.x;
    uvec2 _3299 = _84(uvec4(ssbo0_3._m0[_2519]), uvec2(_3185, _3201), uvec2(0u));
    uint _3300 = _3299.x;
    uvec2 _3305 = _84(uvec4(ssbo0_3._m0[_2519]), uvec2(_3217, _3233), uvec2(0u));
    uint _3306 = _3305.x;
    uvec2 _3311 = _84(uvec4(ssbo0_3._m0[_2519]), uvec2(_3249, _3265), uvec2(0u));
    uint _3312 = _3311.x;
    uint _3368 = ((_1149 + 8704u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec2 _3378 = _84(uvec4(ssbo0_3._m0[_2929]), uvec2(_3249, _3265), uvec2(0u));
    uint _3379 = _3378.x;
    uvec2 _3384 = _84(uvec4(ssbo0_3._m0[_2929]), uvec2(_3185, _3201), uvec2(0u));
    uint _3385 = _3384.x;
    uvec2 _3390 = _84(uvec4(ssbo0_3._m0[_2929]), uvec2(_3012, _3057), uvec2(0u));
    uint _3391 = _3390.x;
    uvec2 _3396 = _84(uvec4(ssbo0_3._m0[_2929]), uvec2(_3153, _3169), uvec2(0u));
    uint _3397 = _3396.x;
    uvec2 _3402 = _84(uvec4(ssbo0_3._m0[_2929]), uvec2(_3217, _3233), uvec2(0u));
    uint _3403 = _3402.x;
    uvec2 _3408 = _84(uvec4(ssbo0_3._m0[_2929]), uvec2(_3041, _3073), uvec2(0u));
    uint _3409 = _3408.x;
    uvec2 _3414 = _84(uvec4(ssbo0_3._m0[_2929]), uvec2(_3105, _3121), uvec2(0u));
    uint _3415 = _3414.x;
    uvec2 _3420 = _84(uvec4(ssbo0_3._m0[_2929]), uvec2(_3089, _3137), uvec2(0u));
    uint _3421 = _3420.x;
    uint _3429 = ((_1149 + 9216u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uint _3442 = ((_1149 + 9728u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec2 _3452 = _84(uvec4(_3403, _3402.y, _3379, _3378.y), uvec2(ssbo0_3._m0[_2942].xy), uvec2(_84(uvec4(_3306, _3305.y, _3312, _3311.y), uvec2(ssbo0_3._m0[_2868].xy), uvec2(0u))));
    uint _3453 = _3452.x;
    uint _3454 = _3452.y;
    uvec2 _3458 = _84(uvec4(_3403, _3402.y, _3379, _3378.y), uvec2(ssbo0_3._m0[_2942].zw), uvec2(_84(uvec4(_3306, _3305.y, _3312, _3311.y), uvec2(ssbo0_3._m0[_2868].zw), uvec2(0u))));
    uint _3459 = _3458.x;
    uint _3460 = _3458.y;
    uvec2 _3464 = _84(uvec4(_3391, _3390.y, _3409, _3408.y), uvec2(ssbo0_3._m0[_2942].xy), uvec2(_84(uvec4(_3270, _3269.y, _3276, _3275.y), uvec2(ssbo0_3._m0[_2868].xy), uvec2(0u))));
    uint _3465 = _3464.x;
    uint _3466 = _3464.y;
    uvec2 _3470 = _84(uvec4(_3391, _3390.y, _3409, _3408.y), uvec2(ssbo0_3._m0[_2942].zw), uvec2(_84(uvec4(_3270, _3269.y, _3276, _3275.y), uvec2(ssbo0_3._m0[_2868].zw), uvec2(0u))));
    uint _3471 = _3470.x;
    uint _3472 = _3470.y;
    uvec2 _3476 = _84(uvec4(_3397, _3396.y, _3385, _3384.y), uvec2(ssbo0_3._m0[_2942].xy), uvec2(_84(uvec4(_3294, _3293.y, _3300, _3299.y), uvec2(ssbo0_3._m0[_2868].xy), uvec2(0u))));
    uint _3477 = _3476.x;
    uint _3478 = _3476.y;
    uvec2 _3482 = _84(uvec4(_3397, _3396.y, _3385, _3384.y), uvec2(ssbo0_3._m0[_2942].zw), uvec2(_84(uvec4(_3294, _3293.y, _3300, _3299.y), uvec2(ssbo0_3._m0[_2868].zw), uvec2(0u))));
    uint _3483 = _3482.x;
    uint _3484 = _3482.y;
    uvec2 _3488 = _84(uvec4(_3415, _3414.y, _3421, _3420.y), uvec2(ssbo0_3._m0[_2942].xy), uvec2(_84(uvec4(_3282, _3281.y, _3288, _3287.y), uvec2(ssbo0_3._m0[_2868].xy), uvec2(0u))));
    uint _3489 = _3488.x;
    uint _3490 = _3488.y;
    uvec2 _3494 = _84(uvec4(_3415, _3414.y, _3421, _3420.y), uvec2(ssbo0_3._m0[_2942].zw), uvec2(_84(uvec4(_3282, _3281.y, _3288, _3287.y), uvec2(ssbo0_3._m0[_2868].zw), uvec2(0u))));
    uint _3495 = _3494.x;
    uint _3496 = _3494.y;
    vec2 _3499 = unpackHalf2x16(0u);
    vec2 _3506 = unpackHalf2x16(0u);
    uint _3512 = (packHalf2x16(vec2(max(unpackHalf2x16(_3453).y, _3506.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3453).x, _3499.x), 0.0));
    uint _3519 = ((_1149 + 10240u) - (c0.data[44u] & 4294967280u)) >> 4u;
    vec2 _3528 = unpackHalf2x16(0u);
    vec2 _3535 = unpackHalf2x16(0u);
    uint _3541 = (packHalf2x16(vec2(max(unpackHalf2x16(_3459).y, _3535.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3459).x, _3528.x), 0.0));
    vec2 _3544 = unpackHalf2x16(0u);
    vec2 _3551 = unpackHalf2x16(0u);
    uint _3557 = (packHalf2x16(vec2(max(unpackHalf2x16(_3454).y, _3551.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3454).x, _3544.x), 0.0));
    vec2 _3560 = unpackHalf2x16(0u);
    vec2 _3567 = unpackHalf2x16(0u);
    uint _3573 = (packHalf2x16(vec2(max(unpackHalf2x16(_3460).y, _3567.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3460).x, _3560.x), 0.0));
    vec2 _3576 = unpackHalf2x16(0u);
    vec2 _3583 = unpackHalf2x16(0u);
    uint _3589 = (packHalf2x16(vec2(max(unpackHalf2x16(_3465).y, _3583.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3465).x, _3576.x), 0.0));
    vec2 _3592 = unpackHalf2x16(0u);
    vec2 _3599 = unpackHalf2x16(0u);
    uint _3605 = (packHalf2x16(vec2(max(unpackHalf2x16(_3471).y, _3599.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3471).x, _3592.x), 0.0));
    vec2 _3608 = unpackHalf2x16(0u);
    vec2 _3615 = unpackHalf2x16(0u);
    uint _3621 = (packHalf2x16(vec2(max(unpackHalf2x16(_3466).y, _3615.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3466).x, _3608.x), 0.0));
    vec2 _3624 = unpackHalf2x16(0u);
    vec2 _3631 = unpackHalf2x16(0u);
    uint _3637 = (packHalf2x16(vec2(max(unpackHalf2x16(_3472).y, _3631.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3472).x, _3624.x), 0.0));
    vec2 _3640 = unpackHalf2x16(0u);
    vec2 _3647 = unpackHalf2x16(0u);
    uint _3653 = (packHalf2x16(vec2(max(unpackHalf2x16(_3477).y, _3647.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3477).x, _3640.x), 0.0));
    vec2 _3656 = unpackHalf2x16(0u);
    vec2 _3663 = unpackHalf2x16(0u);
    uint _3669 = (packHalf2x16(vec2(max(unpackHalf2x16(_3483).y, _3663.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3483).x, _3656.x), 0.0));
    vec2 _3672 = unpackHalf2x16(0u);
    vec2 _3679 = unpackHalf2x16(0u);
    uint _3685 = (packHalf2x16(vec2(max(unpackHalf2x16(_3478).y, _3679.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3478).x, _3672.x), 0.0));
    vec2 _3688 = unpackHalf2x16(0u);
    vec2 _3695 = unpackHalf2x16(0u);
    uint _3701 = (packHalf2x16(vec2(max(unpackHalf2x16(_3484).y, _3695.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3484).x, _3688.x), 0.0));
    vec2 _3704 = unpackHalf2x16(0u);
    vec2 _3711 = unpackHalf2x16(0u);
    uint _3717 = (packHalf2x16(vec2(max(unpackHalf2x16(_3490).y, _3711.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3490).x, _3704.x), 0.0));
    vec2 _3720 = unpackHalf2x16(0u);
    vec2 _3727 = unpackHalf2x16(0u);
    uint _3733 = (packHalf2x16(vec2(max(unpackHalf2x16(_3489).y, _3727.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3489).x, _3720.x), 0.0));
    vec2 _3736 = unpackHalf2x16(0u);
    vec2 _3743 = unpackHalf2x16(0u);
    uint _3749 = (packHalf2x16(vec2(max(unpackHalf2x16(_3495).y, _3743.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3495).x, _3736.x), 0.0));
    vec2 _3752 = unpackHalf2x16(0u);
    vec2 _3759 = unpackHalf2x16(0u);
    uint _3765 = (packHalf2x16(vec2(max(unpackHalf2x16(_3496).y, _3759.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3496).x, _3752.x), 0.0));
    uvec2 _3769 = _84(uvec4(ssbo0_3._m0[_3019]), uvec2(_3512, _3541), uvec2(0u));
    uint _3770 = _3769.x;
    uvec2 _3775 = _84(uvec4(ssbo0_3._m0[_3019]), uvec2(_3557, _3573), uvec2(0u));
    uint _3776 = _3775.x;
    uvec2 _3781 = _84(uvec4(ssbo0_3._m0[_3019]), uvec2(_3589, _3605), uvec2(0u));
    uint _3782 = _3781.x;
    uvec2 _3787 = _84(uvec4(ssbo0_3._m0[_3019]), uvec2(_3621, _3637), uvec2(0u));
    uint _3788 = _3787.x;
    uvec2 _3793 = _84(uvec4(ssbo0_3._m0[_3019]), uvec2(_3653, _3669), uvec2(0u));
    uint _3794 = _3793.x;
    uvec2 _3799 = _84(uvec4(ssbo0_3._m0[_3019]), uvec2(_3685, _3701), uvec2(0u));
    uint _3800 = _3799.x;
    uvec2 _3805 = _84(uvec4(ssbo0_3._m0[_3019]), uvec2(_3733, _3749), uvec2(0u));
    uint _3806 = _3805.x;
    uvec2 _3811 = _84(uvec4(ssbo0_3._m0[_3019]), uvec2(_3717, _3765), uvec2(0u));
    uint _3812 = _3811.x;
    uint _3868 = ((_1149 + 10752u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec2 _3878 = _84(uvec4(ssbo0_3._m0[_3429]), uvec2(_3512, _3541), uvec2(0u));
    uint _3879 = _3878.x;
    uvec2 _3884 = _84(uvec4(ssbo0_3._m0[_3429]), uvec2(_3621, _3637), uvec2(0u));
    uint _3885 = _3884.x;
    uvec2 _3890 = _84(uvec4(ssbo0_3._m0[_3429]), uvec2(_3733, _3749), uvec2(0u));
    uint _3891 = _3890.x;
    uvec2 _3896 = _84(uvec4(ssbo0_3._m0[_3429]), uvec2(_3557, _3573), uvec2(0u));
    uint _3897 = _3896.x;
    uvec2 _3902 = _84(uvec4(ssbo0_3._m0[_3429]), uvec2(_3717, _3765), uvec2(0u));
    uint _3903 = _3902.x;
    uint _3911 = ((_1149 + 11264u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec2 _3921 = _84(uvec4(ssbo0_3._m0[_3429]), uvec2(_3653, _3669), uvec2(0u));
    uint _3922 = _3921.x;
    uint _3930 = ((_1149 + 11776u) - (c0.data[44u] & 4294967280u)) >> 4u;
    uvec2 _3940 = _84(uvec4(ssbo0_3._m0[_3429]), uvec2(_3685, _3701), uvec2(0u));
    uint _3941 = _3940.x;
    uvec2 _3946 = _84(uvec4(ssbo0_3._m0[_3429]), uvec2(_3589, _3605), uvec2(0u));
    uint _3947 = _3946.x;
    uvec2 _3952 = _84(uvec4(_3879, _3878.y, _3897, _3896.y), uvec2(ssbo0_3._m0[_3442].zw), uvec2(_84(uvec4(_3770, _3769.y, _3776, _3775.y), uvec2(ssbo0_3._m0[_3368].zw), uvec2(0u))));
    uint _3953 = _3952.x;
    uint _3954 = _3952.y;
    uvec2 _3958 = _84(uvec4(_3922, _3921.y, _3941, _3940.y), uvec2(ssbo0_3._m0[_3442].xy), uvec2(_84(uvec4(_3794, _3793.y, _3800, _3799.y), uvec2(ssbo0_3._m0[_3368].xy), uvec2(0u))));
    uint _3959 = _3958.x;
    uint _3960 = _3958.y;
    uvec2 _3964 = _84(uvec4(_3922, _3921.y, _3941, _3940.y), uvec2(ssbo0_3._m0[_3442].zw), uvec2(_84(uvec4(_3794, _3793.y, _3800, _3799.y), uvec2(ssbo0_3._m0[_3368].zw), uvec2(0u))));
    uint _3965 = _3964.x;
    uint _3966 = _3964.y;
    uvec2 _3970 = _84(uvec4(_3879, _3878.y, _3897, _3896.y), uvec2(ssbo0_3._m0[_3442].xy), uvec2(_84(uvec4(_3770, _3769.y, _3776, _3775.y), uvec2(ssbo0_3._m0[_3368].xy), uvec2(0u))));
    uint _3971 = _3970.x;
    uint _3972 = _3970.y;
    uvec2 _3976 = _84(uvec4(_3947, _3946.y, _3885, _3884.y), uvec2(ssbo0_3._m0[_3442].xy), uvec2(_84(uvec4(_3782, _3781.y, _3788, _3787.y), uvec2(ssbo0_3._m0[_3368].xy), uvec2(0u))));
    uint _3977 = _3976.x;
    uint _3978 = _3976.y;
    uvec2 _3982 = _84(uvec4(_3947, _3946.y, _3885, _3884.y), uvec2(ssbo0_3._m0[_3442].zw), uvec2(_84(uvec4(_3782, _3781.y, _3788, _3787.y), uvec2(ssbo0_3._m0[_3368].zw), uvec2(0u))));
    uint _3983 = _3982.x;
    uint _3984 = _3982.y;
    uvec2 _3988 = _84(uvec4(_3891, _3890.y, _3903, _3902.y), uvec2(ssbo0_3._m0[_3442].xy), uvec2(_84(uvec4(_3806, _3805.y, _3812, _3811.y), uvec2(ssbo0_3._m0[_3368].xy), uvec2(0u))));
    uint _3989 = _3988.x;
    uint _3990 = _3988.y;
    uvec2 _3994 = _84(uvec4(_3891, _3890.y, _3903, _3902.y), uvec2(ssbo0_3._m0[_3442].zw), uvec2(_84(uvec4(_3806, _3805.y, _3812, _3811.y), uvec2(ssbo0_3._m0[_3368].zw), uvec2(0u))));
    uint _3995 = _3994.x;
    uint _3996 = _3994.y;
    vec2 _3999 = unpackHalf2x16(0u);
    vec2 _4006 = unpackHalf2x16(0u);
    uint _4012 = (packHalf2x16(vec2(max(unpackHalf2x16(_3959).y, _4006.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3959).x, _3999.x), 0.0));
    vec2 _4015 = unpackHalf2x16(0u);
    vec2 _4022 = unpackHalf2x16(0u);
    uint _4028 = (packHalf2x16(vec2(max(unpackHalf2x16(_3965).y, _4022.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3965).x, _4015.x), 0.0));
    vec2 _4031 = unpackHalf2x16(0u);
    vec2 _4038 = unpackHalf2x16(0u);
    uint _4044 = (packHalf2x16(vec2(max(unpackHalf2x16(_3960).y, _4038.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3960).x, _4031.x), 0.0));
    vec2 _4047 = unpackHalf2x16(0u);
    vec2 _4054 = unpackHalf2x16(0u);
    uint _4060 = (packHalf2x16(vec2(max(unpackHalf2x16(_3966).y, _4054.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3966).x, _4047.x), 0.0));
    vec2 _4063 = unpackHalf2x16(0u);
    vec2 _4070 = unpackHalf2x16(0u);
    uint _4076 = (packHalf2x16(vec2(max(unpackHalf2x16(_3953).y, _4070.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3953).x, _4063.x), 0.0));
    vec2 _4079 = unpackHalf2x16(0u);
    vec2 _4086 = unpackHalf2x16(0u);
    uint _4092 = (packHalf2x16(vec2(max(unpackHalf2x16(_3971).y, _4086.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3971).x, _4079.x), 0.0));
    vec2 _4095 = unpackHalf2x16(0u);
    vec2 _4102 = unpackHalf2x16(0u);
    uint _4108 = (packHalf2x16(vec2(max(unpackHalf2x16(_3972).y, _4102.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3972).x, _4095.x), 0.0));
    vec2 _4111 = unpackHalf2x16(0u);
    vec2 _4118 = unpackHalf2x16(0u);
    uint _4124 = (packHalf2x16(vec2(max(unpackHalf2x16(_3954).y, _4118.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3954).x, _4111.x), 0.0));
    uvec2 _4128 = _84(uvec4(ssbo0_3._m0[_3519]), uvec2(_4012, _4028), uvec2(0u));
    uint _4129 = _4128.x;
    vec2 _4133 = unpackHalf2x16(0u);
    vec2 _4140 = unpackHalf2x16(0u);
    uint _4146 = (packHalf2x16(vec2(max(unpackHalf2x16(_3977).y, _4140.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3977).x, _4133.x), 0.0));
    uvec2 _4150 = _84(uvec4(ssbo0_3._m0[_3519]), uvec2(_4044, _4060), uvec2(0u));
    uint _4151 = _4150.x;
    vec2 _4155 = unpackHalf2x16(0u);
    vec2 _4162 = unpackHalf2x16(0u);
    uint _4168 = (packHalf2x16(vec2(max(unpackHalf2x16(_3983).y, _4162.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3983).x, _4155.x), 0.0));
    vec2 _4171 = unpackHalf2x16(0u);
    vec2 _4178 = unpackHalf2x16(0u);
    uint _4184 = (packHalf2x16(vec2(max(unpackHalf2x16(_3978).y, _4178.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3978).x, _4171.x), 0.0));
    vec2 _4187 = unpackHalf2x16(0u);
    vec2 _4194 = unpackHalf2x16(0u);
    uint _4200 = (packHalf2x16(vec2(max(unpackHalf2x16(_3984).y, _4194.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3984).x, _4187.x), 0.0));
    uvec2 _4204 = _84(uvec4(ssbo0_3._m0[_3519]), uvec2(_4092, _4076), uvec2(0u));
    uint _4205 = _4204.x;
    vec2 _4209 = unpackHalf2x16(0u);
    vec2 _4216 = unpackHalf2x16(0u);
    uint _4222 = (packHalf2x16(vec2(max(unpackHalf2x16(_3989).y, _4216.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3989).x, _4209.x), 0.0));
    vec2 _4225 = unpackHalf2x16(0u);
    vec2 _4232 = unpackHalf2x16(0u);
    uint _4238 = (packHalf2x16(vec2(max(unpackHalf2x16(_3990).y, _4232.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3990).x, _4225.x), 0.0));
    uvec2 _4242 = _84(uvec4(ssbo0_3._m0[_3519]), uvec2(_4108, _4124), uvec2(0u));
    uint _4243 = _4242.x;
    vec2 _4247 = unpackHalf2x16(0u);
    vec2 _4254 = unpackHalf2x16(0u);
    uint _4260 = (packHalf2x16(vec2(max(unpackHalf2x16(_3995).y, _4254.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3995).x, _4247.x), 0.0));
    vec2 _4263 = unpackHalf2x16(0u);
    vec2 _4270 = unpackHalf2x16(0u);
    uint _4276 = (packHalf2x16(vec2(max(unpackHalf2x16(_3996).y, _4270.x), 0.0)) << 16u) + packHalf2x16(vec2(max(unpackHalf2x16(_3996).x, _4263.x), 0.0));
    bool _4277 = gl_SubgroupInvocationID >= 16u;
    uint _4278 = gl_SubgroupInvocationID & 3u;
    uvec2 _4282 = _84(uvec4(ssbo0_3._m0[_3519]), uvec2(_4146, _4168), uvec2(0u));
    uint _4283 = _4282.x;
    uint _4291 = ((bitfieldExtract(_1206, int(16u), int(16u)) * 12u) << 16u) + ((bitfieldExtract(_1206, int(0u), int(16u)) * 12u) + _1453);
    bool _4292 = _4278 >= 2u;
    uvec2 _4296 = _84(uvec4(ssbo0_3._m0[_3519]), uvec2(_4184, _4200), uvec2(0u));
    uint _4297 = _4296.x;
    bool _4301 = (_4278 < 2u) && (!_4277);
    uvec2 _4306 = _84(uvec4(ssbo0_3._m0[_3519]), uvec2(_4222, _4260), uvec2(0u));
    uint _4307 = _4306.x;
    uvec2 _4321 = _84(uvec4(ssbo0_3._m0[_3519]), uvec2(_4238, _4276), uvec2(0u));
    uint _4322 = _4321.x;
    uint _4325 = gl_SubgroupInvocationID & 7u;
    uint _4332 = ((bitfieldExtract(_1214, int(16u), int(16u)) * 26u) << 16u) + ((bitfieldExtract(_1214, int(0u), int(16u)) * 26u) + (_4291 >> 1u));
    uint _4334 = (_4291 >> 1u) + (((bitfieldExtract(_1214, int(16u), int(16u)) * 26u) << 16u) + ((bitfieldExtract(_1214, int(0u), int(16u)) * 26u) + 312u));
    uint _4336 = _4325 + 24u;
    uint _4352 = (_4291 >> 1u) + (((bitfieldExtract(_1214, int(16u), int(16u)) * 26u) << 16u) + ((bitfieldExtract(_1214, int(0u), int(16u)) * 26u) + 624u));
    uint _4367 = _4325 + 8u;
    uint _4375 = (_4291 >> 1u) + (((bitfieldExtract(_1214, int(16u), int(16u)) * 26u) << 16u) + ((bitfieldExtract(_1214, int(0u), int(16u)) * 26u) + 936u));
    uint _4383 = _4325 + 16u;
    uint _4386 = (gl_SubgroupInvocationID >> 3u) + (_1206 * 12u);
    precise float _4397 = fma(float(_4367), c0_1.data[24u], c0_1.data[26u]);
    precise float _4416 = fma(float(_4383), c0_1.data[24u], c0_1.data[26u]);
    uint _4433 = floatBitsToUint(_4416) & (((!isnan(_4416)) && (!isnan(_4416))) ? 4294967295u : 0u);
    uint _4446 = uint(clamp(floor(min(uintBitsToFloat(_4433), 4294967040.0)), 0.0, 4294967296.0)) | ((uintBitsToFloat(_4433) >= 4294967296.0) ? 4294967295u : 0u);
    precise float _4451 = _4416 + uintBitsToFloat(floatBitsToUint(floor(_4416)) ^ 2147483648u);
    uvec2 _4457 = _84(uvec4(ssbo0_3._m0[_3911]), uvec2(_4108, _4124), uvec2(0u));
    uint _4458 = _4457.x;
    bool _4461 = _4446 > 46u;
    uint _4468 = floatBitsToUint(_4397) & (((!isnan(_4397)) && (!isnan(_4397))) ? 4294967295u : 0u);
    uint _4477 = uint(clamp(floor(min(uintBitsToFloat(_4468), 4294967040.0)), 0.0, 4294967296.0)) | ((uintBitsToFloat(_4468) >= 4294967296.0) ? 4294967295u : 0u);
    uvec2 _4482 = _84(uvec4(ssbo0_3._m0[_3911]), uvec2(_4092, _4076), uvec2(0u));
    uint _4483 = _4482.x;
    precise float _4487 = _4397 + uintBitsToFloat(floatBitsToUint(floor(_4397)) ^ 2147483648u);
    precise float _4493 = fma(float(_4336), c0_1.data[24u], c0_1.data[26u]);
    uvec2 _4498 = _84(uvec4(ssbo0_3._m0[_3911]), uvec2(_4012, _4028), uvec2(0u));
    uint _4499 = _4498.x;
    uvec2 _4504 = _84(uvec4(ssbo0_3._m0[_3911]), uvec2(_4044, _4060), uvec2(0u));
    uint _4505 = _4504.x;
    uvec2 _4510 = _84(uvec4(ssbo0_3._m0[_3911]), uvec2(_4146, _4168), uvec2(0u));
    uint _4511 = _4510.x;
    uvec2 _4516 = _84(uvec4(ssbo0_3._m0[_3911]), uvec2(_4184, _4200), uvec2(0u));
    uint _4517 = _4516.x;
    uvec2 _4522 = _84(uvec4(ssbo0_3._m0[_3911]), uvec2(_4222, _4260), uvec2(0u));
    uint _4523 = _4522.x;
    uvec2 _4528 = _84(uvec4(ssbo0_3._m0[_3911]), uvec2(_4238, _4276), uvec2(0u));
    uint _4529 = _4528.x;
    uint _4532 = _4325 + 32u;
    precise float _4538 = fma(float(_4532), c0_1.data[24u], c0_1.data[26u]);
    uvec2 _4546 = _84(uvec4(_4499, _4498.y, _4505, _4504.y), uvec2(ssbo0_3._m0[_3930].xy), uvec2(_84(uvec4(_4129, _4128.y, _4151, _4150.y), uvec2(ssbo0_3._m0[_3868].xy), uvec2(0u))));
    uint _4555 = floatBitsToUint(_4538) & (((!isnan(_4538)) && (!isnan(_4538))) ? 4294967295u : 0u);
    uint _4564 = uint(clamp(floor(min(uintBitsToFloat(_4555), 4294967040.0)), 0.0, 4294967296.0)) | ((uintBitsToFloat(_4555) >= 4294967296.0) ? 4294967295u : 0u);
    uvec2 _4568 = _84(uvec4(_4499, _4498.y, _4505, _4504.y), uvec2(ssbo0_3._m0[_3930].zw), uvec2(_84(uvec4(_4129, _4128.y, _4151, _4150.y), uvec2(ssbo0_3._m0[_3868].zw), uvec2(0u))));
    precise float _4573 = _4538 + uintBitsToFloat(floatBitsToUint(floor(_4538)) ^ 2147483648u);
    precise float _4579 = fma(float(_4325), c0_1.data[24u], c0_1.data[26u]);
    uvec2 _4584 = _84(uvec4(_4483, _4482.y, _4458, _4457.y), uvec2(ssbo0_3._m0[_3930].xy), uvec2(_84(uvec4(_4205, _4204.y, _4243, _4242.y), uvec2(ssbo0_3._m0[_3868].xy), uvec2(0u))));
    uvec2 _4591 = _84(uvec4(_4483, _4482.y, _4458, _4457.y), uvec2(ssbo0_3._m0[_3930].zw), uvec2(_84(uvec4(_4205, _4204.y, _4243, _4242.y), uvec2(ssbo0_3._m0[_3868].zw), uvec2(0u))));
    precise float _4600 = fma(float(_4386), c0_1.data[25u], c0_1.data[27u]);
    uvec2 _4605 = _84(uvec4(_4511, _4510.y, _4517, _4516.y), uvec2(ssbo0_3._m0[_3930].xy), uvec2(_84(uvec4(_4283, _4282.y, _4297, _4296.y), uvec2(ssbo0_3._m0[_3868].xy), uvec2(0u))));
    uvec2 _4611 = _84(uvec4(_4511, _4510.y, _4517, _4516.y), uvec2(ssbo0_3._m0[_3930].zw), uvec2(_84(uvec4(_4283, _4282.y, _4297, _4296.y), uvec2(ssbo0_3._m0[_3868].zw), uvec2(0u))));
    uvec2 _4619 = _84(uvec4(_4523, _4522.y, _4529, _4528.y), uvec2(ssbo0_3._m0[_3930].zw), uvec2(_84(uvec4(_4307, _4306.y, _4322, _4321.y), uvec2(ssbo0_3._m0[_3868].zw), uvec2(0u))));
    uvec2 _4627 = _84(uvec4(_4523, _4522.y, _4529, _4528.y), uvec2(ssbo0_3._m0[_3930].xy), uvec2(_84(uvec4(_4307, _4306.y, _4322, _4321.y), uvec2(ssbo0_3._m0[_3868].xy), uvec2(0u))));
    uint _4636 = floatBitsToUint(_4579) & (((!isnan(_4579)) && (!isnan(_4579))) ? 4294967295u : 0u);
    uint _4645 = uint(clamp(floor(min(uintBitsToFloat(_4636), 4294967040.0)), 0.0, 4294967296.0)) | ((uintBitsToFloat(_4636) >= 4294967296.0) ? 4294967295u : 0u);
    uint _4652 = floatBitsToUint(_4600) & (((!isnan(_4600)) && (!isnan(_4600))) ? 4294967295u : 0u);
    uint _4661 = uint(clamp(floor(min(uintBitsToFloat(_4652), 4294967040.0)), 0.0, 4294967296.0)) | ((uintBitsToFloat(_4652) >= 4294967296.0) ? 4294967295u : 0u);
    uint _4662 = _4332 << 2u;
    _42._m0[uint(int(_4662) >> int(2u))] = _4546.x;
    precise float _4667 = _4579 + uintBitsToFloat(floatBitsToUint(floor(_4579)) ^ 2147483648u);
    uint _4671;
    if (!_4292)
    {
        _4671 = _4332 << 2u;
    }
    else
    {
        _4671 = _4662;
    }
    if (!_4292)
    {
        _42._m0[uint(int(_4671 + 16u) >> int(2u))] = _4568.x;
    }
    precise float _4678 = _4600 + uintBitsToFloat(floatBitsToUint(floor(_4600)) ^ 2147483648u);
    uint _4682;
    if (!_4277)
    {
        _4682 = _4332 << 2u;
    }
    else
    {
        _4682 = _4671;
    }
    if (!_4277)
    {
        _42._m0[uint(int(_4682 + 832u) >> int(2u))] = _4546.y;
    }
    uint _4689;
    if (_4301)
    {
        _4689 = _4332 << 2u;
    }
    else
    {
        _4689 = _4682;
    }
    if (_4301)
    {
        _42._m0[uint(int(_4689 + 848u) >> int(2u))] = _4568.y;
    }
    uint _4694 = _4334 << 2u;
    _42._m0[uint(int(_4694) >> int(2u))] = _4584.x;
    uint _4699;
    if (!_4292)
    {
        _4699 = _4334 << 2u;
    }
    else
    {
        _4699 = _4694;
    }
    if (!_4292)
    {
        _42._m0[uint(int(_4699 + 16u) >> int(2u))] = _4591.x;
    }
    uint _4706;
    if (!_4277)
    {
        _4706 = _4334 << 2u;
    }
    else
    {
        _4706 = _4699;
    }
    if (!_4277)
    {
        _42._m0[uint(int(_4706 + 832u) >> int(2u))] = _4584.y;
    }
    uint _4712;
    if (_4301)
    {
        _4712 = _4334 << 2u;
    }
    else
    {
        _4712 = _4706;
    }
    if (_4301)
    {
        _42._m0[uint(int(_4712 + 848u) >> int(2u))] = _4591.y;
    }
    uint _4716 = _4352 << 2u;
    _42._m0[uint(int(_4716) >> int(2u))] = _4605.x;
    uint _4721;
    if (!_4292)
    {
        _4721 = _4352 << 2u;
    }
    else
    {
        _4721 = _4716;
    }
    if (!_4292)
    {
        _42._m0[uint(int(_4721 + 16u) >> int(2u))] = _4611.x;
    }
    uint _4728;
    if (!_4277)
    {
        _4728 = _4352 << 2u;
    }
    else
    {
        _4728 = _4721;
    }
    if (!_4277)
    {
        _42._m0[uint(int(_4728 + 832u) >> int(2u))] = _4605.y;
    }
    uint _4734;
    if (_4301)
    {
        _4734 = _4352 << 2u;
    }
    else
    {
        _4734 = _4728;
    }
    if (_4301)
    {
        _42._m0[uint(int(_4734 + 848u) >> int(2u))] = _4611.y;
    }
    uint _4740;
    if (!_4292)
    {
        _4740 = _4375 << 2u;
    }
    else
    {
        _4740 = _4734;
    }
    if (!_4292)
    {
        _42._m0[uint(int(_4740 + 16u) >> int(2u))] = _4619.x;
    }
    bool _4745 = _4645 > 46u;
    uint _4748;
    if (!_4277)
    {
        _4748 = _4375 << 2u;
    }
    else
    {
        _4748 = _4740;
    }
    if (!_4277)
    {
        _42._m0[uint(int(_4748 + 832u) >> int(2u))] = _4627.y;
    }
    bool _4753 = _4661 > 46u;
    uint _4757 = _4325 + 40u;
    uint _4758 = _4386 + 4u;
    uint _4766 = (packHalf2x16(vec2(uintBitsToFloat(_4753 ? 1065353216u : floatBitsToUint(_4678)), 0.0)) << 16u) + packHalf2x16(vec2(uintBitsToFloat(_4745 ? 1065353216u : floatBitsToUint(_4667)), 0.0));
    uint _4769 = _4753 ? 46u : _4661;
    precise float _4774 = fma(float(_4757), c0_1.data[24u], c0_1.data[26u]);
    precise float _4780 = fma(float(_4758), c0_1.data[25u], c0_1.data[27u]);
    uint _4784 = _4386 + 8u;
    uint _4785 = _4375 << 2u;
    _42._m0[uint(int(_4785) >> int(2u))] = _4627.x;
    uint _4791;
    if (_4301)
    {
        _4791 = _4375 << 2u;
    }
    else
    {
        _4791 = _4785;
    }
    if (_4301)
    {
        _42._m0[uint(int(_4791 + 848u) >> int(2u))] = _4619.y;
    }
    _42._m0[uint(int(_642) >> int(2u))] = _4784;
    uint _4805 = floatBitsToUint(_4493) & (((!isnan(_4493)) && (!isnan(_4493))) ? 4294967295u : 0u);
    uint _4814 = uint(clamp(floor(min(uintBitsToFloat(_4805), 4294967040.0)), 0.0, 4294967296.0)) | ((uintBitsToFloat(_4805) >= 4294967296.0) ? 4294967295u : 0u);
    uint _4821 = floatBitsToUint(_4774) & (((!isnan(_4774)) && (!isnan(_4774))) ? 4294967295u : 0u);
    uint _4830 = uint(clamp(floor(min(uintBitsToFloat(_4821), 4294967040.0)), 0.0, 4294967296.0)) | ((uintBitsToFloat(_4821) >= 4294967296.0) ? 4294967295u : 0u);
    uint _4837 = floatBitsToUint(_4780) & (((!isnan(_4780)) && (!isnan(_4780))) ? 4294967295u : 0u);
    uint _4846 = uint(clamp(floor(min(uintBitsToFloat(_4837), 4294967040.0)), 0.0, 4294967296.0)) | ((uintBitsToFloat(_4837) >= 4294967296.0) ? 4294967295u : 0u);
    bool _4847 = _4477 > 46u;
    precise float _4850 = _4493 + uintBitsToFloat(floatBitsToUint(floor(_4493)) ^ 2147483648u);
    precise float _4854 = _4774 + uintBitsToFloat(floatBitsToUint(floor(_4774)) ^ 2147483648u);
    precise float _4858 = _4780 + uintBitsToFloat(floatBitsToUint(floor(_4780)) ^ 2147483648u);
    uint _4861 = _4847 ? 46u : _4477;
    barrier();
    bool _4862 = _4814 > 46u;
    bool _4863 = _4564 > 46u;
    bool _4864 = _4830 > 46u;
    bool _4865 = _4846 > 46u;
    uint _4878 = (((bitfieldExtract(_4769, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4769, int(0u), int(16u)) * 52u) + _4861)) << 1u;
    uint _4885 = (packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(uintBitsToFloat(_4847 ? 1065353216u : floatBitsToUint(_4487)), 0.0));
    uint _4892 = (packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(uintBitsToFloat(_4461 ? 1065353216u : floatBitsToUint(_4451)), 0.0));
    uint _4899 = (packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(uintBitsToFloat(_4862 ? 1065353216u : floatBitsToUint(_4850)), 0.0));
    uint _4906 = (packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(uintBitsToFloat(_4863 ? 1065353216u : floatBitsToUint(_4573)), 0.0));
    uint _4913 = (packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(uintBitsToFloat(_4864 ? 1065353216u : floatBitsToUint(_4854)), 0.0));
    uint _4920 = (packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(uintBitsToFloat(_4865 ? 1065353216u : floatBitsToUint(_4858)), 0.0));
    uint _4927 = _4863 ? 46u : _4564;
    uint _4934 = _4865 ? 46u : _4846;
    precise float _4939 = fma(float(_4784), c0_1.data[25u], c0_1.data[27u]);
    uint _4941 = _4862 ? 46u : _4814;
    uint _4959 = floatBitsToUint(_4939) & (((!isnan(_4939)) && (!isnan(_4939))) ? 4294967295u : 0u);
    uint _4968 = uint(clamp(floor(min(uintBitsToFloat(_4959), 4294967040.0)), 0.0, 4294967296.0)) | ((uintBitsToFloat(_4959) >= 4294967296.0) ? 4294967295u : 0u);
    uint _4969 = _4864 ? 46u : _4830;
    uint _4976 = (((bitfieldExtract(_4769, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4769, int(0u), int(16u)) * 52u) + _4927)) << 1u;
    uint _5002 = _4461 ? 46u : _4446;
    uint _5014 = (((bitfieldExtract(_4934, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4934, int(0u), int(16u)) * 52u) + _4861)) << 1u;
    bool _5015 = _4968 > 46u;
    uint _5021 = _5015 ? 46u : _4968;
    precise float _5028 = _4939 + uintBitsToFloat(floatBitsToUint(floor(_4939)) ^ 2147483648u);
    uint _5049 = (((bitfieldExtract(_4769, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4769, int(0u), int(16u)) * 52u) + _4941)) << 1u;
    uint _5055 = (((bitfieldExtract(_5021, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_5021, int(0u), int(16u)) * 52u) + _4861)) << 1u;
    uint _5100 = (packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(uintBitsToFloat(_5015 ? 1065353216u : floatBitsToUint(_5028)), 0.0));
    uint _5101 = (((bitfieldExtract(_4769, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4769, int(0u), int(16u)) * 52u) + _5002)) << 1u;
    uint _5121 = (((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.x, int(16u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u)))) << 16u) + ((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u))) + _4757);
    uint _5124 = (uint(_36._m0[uint(int(_4878 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_4878) >> int(1u))]) & 65535u);
    uint _5129 = _4745 ? 46u : _4645;
    vec2 _5130 = unpackHalf2x16(_5124);
    vec2 _5133 = unpackHalf2x16(_4885);
    float _5134 = _5133.x;
    vec2 _5135 = unpackHalf2x16(_5124);
    vec2 _5155 = unpackHalf2x16((uint(_36._m0[uint(int(_4878 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_4878 + 2u) >> int(1u))]) & 65535u));
    vec2 _5158 = unpackHalf2x16(_4885);
    float _5159 = _5158.x;
    precise float _5160 = fma(_5155.x, _5159, fma(_5130.x, -_5134, _5135.x));
    uint _5174 = (((bitfieldExtract(_4934, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4934, int(0u), int(16u)) * 52u) + _5129)) << 1u;
    uint _5187 = (((bitfieldExtract(_4769, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4769, int(0u), int(16u)) * 52u) + _5129)) << 1u;
    uint _5190 = (uint(_36._m0[uint(int(_4976 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_4976) >> int(1u))]) & 65535u);
    uint _5191 = (((bitfieldExtract(_5021, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_5021, int(0u), int(16u)) * 52u) + _5129)) << 1u;
    uint _5217 = (uint(_36._m0[uint(int(_5014 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5014) >> int(1u))]) & 65535u);
    vec2 _5225 = unpackHalf2x16(_5190);
    vec2 _5228 = unpackHalf2x16(_4906);
    float _5229 = _5228.x;
    vec2 _5230 = unpackHalf2x16(_5190);
    uint _5242 = (((bitfieldExtract(_4934, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4934, int(0u), int(16u)) * 52u) + _5002)) << 1u;
    vec2 _5243 = unpackHalf2x16(_5217);
    vec2 _5246 = unpackHalf2x16(_4885);
    float _5247 = _5246.x;
    vec2 _5248 = unpackHalf2x16(_5217);
    uint _5328 = (uint(_36._m0[uint(int(_5174 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5174) >> int(1u))]) & 65535u);
    vec2 _5334 = unpackHalf2x16(_5328);
    vec2 _5337 = unpackHalf2x16(_4766);
    float _5338 = _5337.x;
    vec2 _5339 = unpackHalf2x16(_5328);
    vec2 _5359 = unpackHalf2x16((uint(_36._m0[uint(int(_5174 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5174 + 2u) >> int(1u))]) & 65535u));
    vec2 _5362 = unpackHalf2x16(_4766);
    float _5363 = _5362.x;
    precise float _5364 = fma(_5359.x, _5363, fma(_5334.x, -_5338, _5339.x));
    uint _5373 = (uint(_36._m0[uint(int(_5191 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5191) >> int(1u))]) & 65535u);
    uint _5381 = (uint(_36._m0[uint(int(_5049 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5049) >> int(1u))]) & 65535u);
    vec2 _5382 = unpackHalf2x16(_5373);
    vec2 _5385 = unpackHalf2x16(_4766);
    float _5386 = _5385.x;
    vec2 _5387 = unpackHalf2x16(_5373);
    precise float _5407 = 0.5 * c0_1.data[30u];
    uint _5419 = (uint(_36._m0[uint(int(_5187 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5187) >> int(1u))]) & 65535u);
    vec2 _5425 = unpackHalf2x16(_5419);
    vec2 _5428 = unpackHalf2x16(_4766);
    float _5429 = _5428.x;
    vec2 _5430 = unpackHalf2x16(_5419);
    uint _5454 = (((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.x, int(16u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u)))) << 16u) + ((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u))) + _4532);
    uint _5460 = (((bitfieldExtract(_5021, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_5021, int(0u), int(16u)) * 52u) + _5002)) << 1u;
    uint _5463 = (uint(_36._m0[uint(int(_5101 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5101) >> int(1u))]) & 65535u);
    uint _5490 = (((bitfieldExtract(gl_WorkGroupID.y, int(0u), int(16u)) * bitfieldExtract(c0.data[23u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.y, int(16u), int(16u)) * bitfieldExtract(c0.data[23u], int(0u), int(16u)))) << 16u) + ((bitfieldExtract(gl_WorkGroupID.y, int(0u), int(16u)) * bitfieldExtract(c0.data[23u], int(0u), int(16u))) + _4386);
    uint _5494 = (((bitfieldExtract(_4934, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4934, int(0u), int(16u)) * 52u) + _4941)) << 1u;
    vec2 _5496 = unpackHalf2x16(_5463);
    vec2 _5499 = unpackHalf2x16(_4892);
    float _5500 = _5499.x;
    vec2 _5501 = unpackHalf2x16(_5463);
    vec2 _5509 = unpackHalf2x16((uint(_36._m0[uint(int(_5187 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5187 + 2u) >> int(1u))]) & 65535u));
    vec2 _5512 = unpackHalf2x16(_4766);
    float _5513 = _5512.x;
    precise float _5514 = fma(_5509.x, _5513, fma(_5425.x, -_5429, _5430.x));
    vec2 _5520 = unpackHalf2x16((uint(_36._m0[uint(int(_5101 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5101 + 2u) >> int(1u))]) & 65535u));
    vec2 _5523 = unpackHalf2x16(_4892);
    float _5524 = _5523.x;
    precise float _5525 = fma(_5520.x, _5524, fma(_5496.x, -_5500, _5501.x));
    vec2 _5553 = unpackHalf2x16((uint(_36._m0[uint(int(_5191 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5191 + 2u) >> int(1u))]) & 65535u));
    vec2 _5556 = unpackHalf2x16(_4766);
    float _5557 = _5556.x;
    precise float _5558 = fma(_5553.x, _5557, fma(_5382.x, -_5386, _5387.x));
    vec2 _5566 = unpackHalf2x16((uint(_36._m0[uint(int(_4976 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_4976 + 2u) >> int(1u))]) & 65535u));
    vec2 _5569 = unpackHalf2x16(_4906);
    float _5570 = _5569.x;
    precise float _5571 = fma(_5566.x, _5570, fma(_5225.x, -_5229, _5230.x));
    precise float _5603 = fma(float((((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.x, int(16u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u)))) << 16u) + ((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u))) + _4367)), c0_1.data[30u], _5407);
    vec2 _5605 = unpackHalf2x16((uint(_36._m0[uint(int(_5014 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5014 + 2u) >> int(1u))]) & 65535u));
    vec2 _5608 = unpackHalf2x16(_4885);
    float _5609 = _5608.x;
    precise float _5610 = fma(_5605.x, _5609, fma(_5243.x, -_5247, _5248.x));
    uint _5620 = (uint(_36._m0[uint(int(_5055 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5055) >> int(1u))]) & 65535u);
    precise float _5639 = 0.5 * c0_1.data[31u];
    uint _5659 = (((bitfieldExtract(_5021, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_5021, int(0u), int(16u)) * 52u) + _4941)) << 1u;
    precise float _5663 = fma(float(_5490), c0_1.data[31u], _5639);
    precise float _5672 = fma(float(_5454), c0_1.data[30u], _5407);
    vec2 _5673 = unpackHalf2x16(_5381);
    vec2 _5676 = unpackHalf2x16(_4899);
    float _5677 = _5676.x;
    vec2 _5678 = unpackHalf2x16(_5381);
    precise float _5687 = fma(float((((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.x, int(16u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u)))) << 16u) + ((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u))) + _4383)), c0_1.data[30u], _5407);
    precise float _5690 = fma(float((((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.x, int(16u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u)))) << 16u) + ((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u))) + (gl_SubgroupInvocationID & 7u))), c0_1.data[30u], _5407);
    precise float _5701 = fma(float(_5121), c0_1.data[30u], _5407);
    precise float _5709 = fma(fma(_5155.y, _5159, fma(_5130.y, -_5134, _5135.y)), unpackHalf2x16(_4766).y, fma(_5160, -unpackHalf2x16(_4766).y, _5160));
    uint _5712 = (uint(_36._m0[uint(int(_5494 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5494) >> int(1u))]) & 65535u);
    vec2 _5723 = unpackHalf2x16(_5712);
    vec2 _5726 = unpackHalf2x16(_4899);
    float _5727 = _5726.x;
    vec2 _5728 = unpackHalf2x16(_5712);
    uint _5747 = (uint(_36._m0[uint(int(_5460 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5460) >> int(1u))]) & 65535u);
    vec2 _5748 = unpackHalf2x16(_5620);
    vec2 _5751 = unpackHalf2x16(_4885);
    float _5752 = _5751.x;
    vec2 _5753 = unpackHalf2x16(_5620);
    _42._m0[uint(int(_642 + 4u) >> int(2u))] = _5490;
    vec2 _5763 = unpackHalf2x16(_5747);
    vec2 _5766 = unpackHalf2x16(_4892);
    float _5767 = _5766.x;
    vec2 _5768 = unpackHalf2x16(_5747);
    vec2 _5775 = unpackHalf2x16((uint(_36._m0[uint(int(_5055 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5055 + 2u) >> int(1u))]) & 65535u));
    vec2 _5778 = unpackHalf2x16(_4885);
    float _5779 = _5778.x;
    precise float _5780 = fma(_5775.x, _5779, fma(_5748.x, -_5752, _5753.x));
    precise float _5784 = fma(float((((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.x, int(16u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u)))) << 16u) + ((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u))) + _4336)), c0_1.data[30u], _5407);
    uint _5787 = (uint(_36._m0[uint(int(_5242 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5242) >> int(1u))]) & 65535u);
    vec2 _5788 = unpackHalf2x16((uint(_36._m0[uint(int(_5049 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5049 + 2u) >> int(1u))]) & 65535u));
    vec2 _5791 = unpackHalf2x16(_4899);
    float _5792 = _5791.x;
    precise float _5793 = fma(_5788.x, _5792, fma(_5673.x, -_5677, _5678.x));
    vec2 _5798 = unpackHalf2x16(_5787);
    vec2 _5801 = unpackHalf2x16(_4892);
    float _5802 = _5801.x;
    vec2 _5803 = unpackHalf2x16(_5787);
    vec2 _5811 = unpackHalf2x16((uint(_36._m0[uint(int(_5460 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5460 + 2u) >> int(1u))]) & 65535u));
    vec2 _5814 = unpackHalf2x16(_4892);
    float _5815 = _5814.x;
    precise float _5816 = fma(_5811.x, _5815, fma(_5763.x, -_5767, _5768.x));
    precise float _5820 = fma(float((((bitfieldExtract(gl_WorkGroupID.y, int(0u), int(16u)) * bitfieldExtract(c0.data[23u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.y, int(16u), int(16u)) * bitfieldExtract(c0.data[23u], int(0u), int(16u)))) << 16u) + ((bitfieldExtract(gl_WorkGroupID.y, int(0u), int(16u)) * bitfieldExtract(c0.data[23u], int(0u), int(16u))) + (_4386 + 8u))), c0_1.data[31u], _5639);
    precise float _5823 = fma(float((((bitfieldExtract(gl_WorkGroupID.y, int(0u), int(16u)) * bitfieldExtract(c0.data[23u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.y, int(16u), int(16u)) * bitfieldExtract(c0.data[23u], int(0u), int(16u)))) << 16u) + ((bitfieldExtract(gl_WorkGroupID.y, int(0u), int(16u)) * bitfieldExtract(c0.data[23u], int(0u), int(16u))) + _4758)), c0_1.data[31u], _5639);
    uint _5826 = (uint(_36._m0[uint(int(_5659 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5659) >> int(1u))]) & 65535u);
    vec2 _5830 = unpackHalf2x16(_5826);
    vec2 _5833 = unpackHalf2x16(_4899);
    float _5834 = _5833.x;
    vec2 _5835 = unpackHalf2x16(_5826);
    vec2 _5842 = unpackHalf2x16((uint(_36._m0[uint(int(_5494 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5494 + 2u) >> int(1u))]) & 65535u));
    vec2 _5845 = unpackHalf2x16(_4899);
    float _5846 = _5845.x;
    precise float _5847 = fma(_5842.x, _5846, fma(_5723.x, -_5727, _5728.x));
    vec4 _5854 = textureLod(cs_tex0_c0, vec2(_5690, _5663), 0.0);
    vec2 _5873 = unpackHalf2x16((uint(_36._m0[uint(int(_5659 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5659 + 2u) >> int(1u))]) & 65535u));
    vec2 _5876 = unpackHalf2x16(_4899);
    float _5877 = _5876.x;
    precise float _5878 = fma(_5873.x, _5877, fma(_5830.x, -_5834, _5835.x));
    vec4 _5882 = textureLod(cs_tex0_c0, vec2(_5603, _5663), 0.0);
    vec4 _5900 = textureLod(cs_tex0_c0, vec2(_5687, _5663), 0.0);
    vec4 _5918 = textureLod(cs_tex0_c0, vec2(_5784, _5663), 0.0);
    vec2 _5934 = unpackHalf2x16((uint(_36._m0[uint(int(_5242 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_5242 + 2u) >> int(1u))]) & 65535u));
    vec2 _5937 = unpackHalf2x16(_4892);
    float _5938 = _5937.x;
    precise float _5939 = fma(_5934.x, _5938, fma(_5798.x, -_5802, _5803.x));
    vec4 _5943 = textureLod(cs_tex0_c0, vec2(_5672, _5663), 0.0);
    vec4 _5961 = textureLod(cs_tex0_c0, vec2(_5701, _5663), 0.0);
    vec4 _5979 = textureLod(cs_tex0_c0, vec2(_5690, _5823), 0.0);
    vec4 _5997 = textureLod(cs_tex0_c0, vec2(_5603, _5823), 0.0);
    vec4 _6015 = textureLod(cs_tex0_c0, vec2(_5687, _5823), 0.0);
    vec4 _6033 = textureLod(cs_tex0_c0, vec2(_5784, _5823), 0.0);
    vec4 _6051 = textureLod(cs_tex0_c0, vec2(_5672, _5823), 0.0);
    vec4 _6069 = textureLod(cs_tex0_c0, vec2(_5701, _5823), 0.0);
    vec4 _6087 = textureLod(cs_tex0_c0, vec2(_5690, _5820), 0.0);
    vec4 _6105 = textureLod(cs_tex0_c0, vec2(_5603, _5820), 0.0);
    vec4 _6123 = textureLod(cs_tex0_c0, vec2(_5687, _5820), 0.0);
    vec4 _6141 = textureLod(cs_tex0_c0, vec2(_5784, _5820), 0.0);
    vec4 _6159 = textureLod(cs_tex0_c0, vec2(_5672, _5820), 0.0);
    vec4 _6177 = textureLod(cs_tex0_c0, vec2(_5701, _5820), 0.0);
    uint _6197 = (((bitfieldExtract(_4769, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4769, int(0u), int(16u)) * 52u) + _4969)) << 1u;
    uint _6202 = (((bitfieldExtract(_4934, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4934, int(0u), int(16u)) * 52u) + _4927)) << 1u;
    precise float _6205 = fma(fma(_5788.y, _5792, fma(_5673.y, -_5677, _5678.y)), unpackHalf2x16(_4766).y, fma(_5793, -unpackHalf2x16(_4766).y, _5793));
    uint _6206 = (((bitfieldExtract(_5021, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_5021, int(0u), int(16u)) * 52u) + _4927)) << 1u;
    precise float _6209 = fma(fma(_5520.y, _5524, fma(_5496.y, -_5500, _5501.y)), unpackHalf2x16(_4766).y, fma(_5525, -unpackHalf2x16(_4766).y, _5525));
    precise float _6220 = fma(fma(_5566.y, _5570, fma(_5225.y, -_5229, _5230.y)), unpackHalf2x16(_4766).y, fma(_5571, -unpackHalf2x16(_4766).y, _5571));
    precise float _6223 = fma(fma(_5509.y, _5513, fma(_5425.y, -_5429, _5430.y)), unpackHalf2x16(_4766).y, fma(_5514, -unpackHalf2x16(_4766).y, _5514));
    precise float _6248 = fma(fma(_5359.y, _5363, fma(_5334.y, -_5338, _5339.y)), unpackHalf2x16(_4920).x, fma(_5364, -unpackHalf2x16(_4920).x, _5364));
    precise float _6251 = fma(fma(_5553.y, _5557, fma(_5382.y, -_5386, _5387.y)), unpackHalf2x16(_5100).x, fma(_5558, -unpackHalf2x16(_5100).x, _5558));
    uint _6259 = (uint(_36._m0[uint(int(_6197 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_6197) >> int(1u))]) & 65535u);
    vec2 _6265 = unpackHalf2x16(_6259);
    vec2 _6268 = unpackHalf2x16(_4913);
    float _6269 = _6268.x;
    vec2 _6270 = unpackHalf2x16(_6259);
    vec2 _6289 = unpackHalf2x16((uint(_36._m0[uint(int(_6197 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_6197 + 2u) >> int(1u))]) & 65535u));
    vec2 _6292 = unpackHalf2x16(_4913);
    float _6293 = _6292.x;
    precise float _6294 = fma(_6289.x, _6293, fma(_6265.x, -_6269, _6270.x));
    precise float _6302 = fma(fma(_6289.y, _6293, fma(_6265.y, -_6269, _6270.y)), unpackHalf2x16(_4766).y, fma(_6294, -unpackHalf2x16(_4766).y, _6294));
    precise float _6313 = fma(fma(_5605.y, _5609, fma(_5243.y, -_5247, _5248.y)), unpackHalf2x16(_4920).x, fma(_5610, -unpackHalf2x16(_4920).x, _5610));
    precise float _6316 = fma(fma(_5775.y, _5779, fma(_5748.y, -_5752, _5753.y)), unpackHalf2x16(_5100).x, fma(_5780, -unpackHalf2x16(_5100).x, _5780));
    uint _6333 = (uint(_36._m0[uint(int(_6202 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_6202) >> int(1u))]) & 65535u);
    vec2 _6344 = unpackHalf2x16(_6333);
    vec2 _6347 = unpackHalf2x16(_4906);
    float _6348 = _6347.x;
    vec2 _6349 = unpackHalf2x16(_6333);
    vec2 _6359 = unpackHalf2x16((uint(_36._m0[uint(int(_6202 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_6202 + 2u) >> int(1u))]) & 65535u));
    vec2 _6362 = unpackHalf2x16(_4906);
    float _6363 = _6362.x;
    precise float _6364 = fma(_6359.x, _6363, fma(_6344.x, -_6348, _6349.x));
    precise float _6372 = fma(fma(_5934.y, _5938, fma(_5798.y, -_5802, _5803.y)), unpackHalf2x16(_4920).x, fma(_5939, -unpackHalf2x16(_4920).x, _5939));
    uint _6379 = (uint(_36._m0[uint(int(_6206 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_6206) >> int(1u))]) & 65535u);
    uint _6380 = (((bitfieldExtract(_4934, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_4934, int(0u), int(16u)) * 52u) + _4969)) << 1u;
    precise float _6383 = fma(fma(_5811.y, _5815, fma(_5763.y, -_5767, _5768.y)), unpackHalf2x16(_5100).x, fma(_5816, -unpackHalf2x16(_5100).x, _5816));
    vec2 _6387 = unpackHalf2x16(_6379);
    vec2 _6390 = unpackHalf2x16(_4906);
    float _6391 = _6390.x;
    vec2 _6392 = unpackHalf2x16(_6379);
    uint _6399 = (((bitfieldExtract(_5021, int(16u), int(16u)) * 52u) << 16u) + ((bitfieldExtract(_5021, int(0u), int(16u)) * 52u) + _4969)) << 1u;
    vec2 _6408 = unpackHalf2x16((uint(_36._m0[uint(int(_6206 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_6206 + 2u) >> int(1u))]) & 65535u));
    vec2 _6411 = unpackHalf2x16(_4906);
    float _6412 = _6411.x;
    precise float _6413 = fma(_6408.x, _6412, fma(_6387.x, -_6391, _6392.x));
    precise float _6422 = fma(fma(_5842.y, _5846, fma(_5723.y, -_5727, _5728.y)), unpackHalf2x16(_4920).x, fma(_5847, -unpackHalf2x16(_4920).x, _5847));
    precise float _6433 = fma(fma(_5873.y, _5877, fma(_5830.y, -_5834, _5835.y)), unpackHalf2x16(_5100).x, fma(_5878, -unpackHalf2x16(_5100).x, _5878));
    uint _6461 = (uint(_36._m0[uint(int(_6380 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_6380) >> int(1u))]) & 65535u);
    vec2 _6463 = unpackHalf2x16(_6461);
    vec2 _6466 = unpackHalf2x16(_4913);
    float _6467 = _6466.x;
    vec2 _6468 = unpackHalf2x16(_6461);
    uint _6477 = (uint(_36._m0[uint(int(_6399 + 104u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_6399) >> int(1u))]) & 65535u);
    vec2 _6478 = unpackHalf2x16(_6477);
    vec2 _6481 = unpackHalf2x16(_4913);
    float _6482 = _6481.x;
    vec2 _6483 = unpackHalf2x16(_6477);
    vec2 _6493 = unpackHalf2x16((uint(_36._m0[uint(int(_6380 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_6380 + 2u) >> int(1u))]) & 65535u));
    vec2 _6496 = unpackHalf2x16(_4913);
    float _6497 = _6496.x;
    precise float _6498 = fma(_6493.x, _6497, fma(_6463.x, -_6467, _6468.x));
    vec2 _6512 = unpackHalf2x16((uint(_36._m0[uint(int(_6399 + 106u) >> int(1u))]) << 16u) + (uint(_36._m0[uint(int(_6399 + 2u) >> int(1u))]) & 65535u));
    vec2 _6515 = unpackHalf2x16(_4913);
    float _6516 = _6515.x;
    precise float _6517 = fma(_6512.x, _6516, fma(_6478.x, -_6482, _6483.x));
    precise float _6521 = fma(fma(_6408.y, _6412, fma(_6387.y, -_6391, _6392.y)), unpackHalf2x16(_5100).x, fma(_6413, -unpackHalf2x16(_5100).x, _6413));
    precise float _6532 = fma(fma(_6512.y, _6516, fma(_6478.y, -_6482, _6483.y)), unpackHalf2x16(_5100).x, fma(_6517, -unpackHalf2x16(_5100).x, _6517));
    vec2 _6533 = unpackHalf2x16((packHalf2x16(vec2(_5854.y, 0.0)) << 16u) + packHalf2x16(vec2(_5854.x, 0.0)));
    precise float _6536 = _6533.x + _6223;
    precise float _6537 = _6533.y + _6223;
    precise float _6540 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_5854.z, 0.0))).x + _6223;
    precise float _6543 = _6536 * abs(_6536);
    precise float _6544 = _6537 * abs(_6537);
    vec2 _6545 = unpackHalf2x16((packHalf2x16(vec2(_5882.y, 0.0)) << 16u) + packHalf2x16(vec2(_5882.x, 0.0)));
    precise float _6548 = _6545.x + _5709;
    precise float _6549 = _6545.y + _5709;
    vec2 _6550 = unpackHalf2x16(968374712u);
    precise float _6552 = _6544 * _6550.x;
    precise float _6555 = _6548 * abs(_6548);
    precise float _6556 = _6549 * abs(_6549);
    uint _6558 = packHalf2x16(vec2(_6555, _6556));
    precise float _6561 = _6540 * abs(_6540);
    precise float _6562 = _6540 * abs(_6540);
    vec2 _6565 = unpackHalf2x16(852308685u);
    vec2 _6572 = unpackHalf2x16(968374712u);
    precise float _6575 = _6556 * _6572.x;
    precise float _6576 = _6556 * _6572.y;
    uint _6581 = (_6558 << 16u) + (packHalf2x16(vec2(_6561, _6562)) & 65535u);
    vec2 _6582 = unpackHalf2x16((packHalf2x16(vec2(_5900.y, 0.0)) << 16u) + packHalf2x16(vec2(_5900.x, 0.0)));
    precise float _6585 = _6582.x + _6209;
    precise float _6586 = _6582.y + _6209;
    precise float _6589 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_5882.z, 0.0))).x + _5709;
    precise float _6595 = _6585 * abs(_6585);
    precise float _6596 = _6586 * abs(_6586);
    precise float _6601 = _6589 * abs(_6589);
    precise float _6602 = _6589 * abs(_6589);
    vec2 _6606 = unpackHalf2x16(_6581);
    vec2 _6609 = unpackHalf2x16(852307102u);
    vec2 _6612 = unpackHalf2x16((packHalf2x16(vec2(_6575, _6576)) << 16u) + (packHalf2x16(vec2(fma(_6543, _6565.x, _6552), fma(_6543, _6565.y, _6552))) & 65535u));
    uint _6618 = packHalf2x16(vec2(fma(_6606.x, _6609.x, _6612.x), fma(_6606.y, _6609.y, _6612.y)));
    vec2 _6619 = unpackHalf2x16(968374712u);
    precise float _6622 = _6596 * _6619.x;
    precise float _6623 = _6596 * _6619.y;
    uint _6628 = (packHalf2x16(vec2(_6595, _6596)) << 16u) + (packHalf2x16(vec2(_6601, _6602)) & 65535u);
    precise float _6631 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_5900.z, 0.0))).x + _6209;
    vec2 _6632 = unpackHalf2x16((packHalf2x16(vec2(_5918.y, 0.0)) << 16u) + packHalf2x16(vec2(_5918.x, 0.0)));
    precise float _6635 = _6632.x + _6205;
    precise float _6636 = _6632.y + _6205;
    precise float _6642 = _6631 * abs(_6631);
    precise float _6643 = _6631 * abs(_6631);
    precise float _6648 = _6635 * abs(_6635);
    precise float _6649 = _6636 * abs(_6636);
    vec2 _6652 = unpackHalf2x16(_6628);
    vec2 _6655 = unpackHalf2x16(852307102u);
    vec2 _6658 = unpackHalf2x16((packHalf2x16(vec2(_6622, _6623)) << 16u) + (_6618 >> 16u));
    uint _6664 = packHalf2x16(vec2(fma(_6652.x, _6655.x, _6658.x), fma(_6652.y, _6655.y, _6658.y)));
    vec2 _6665 = unpackHalf2x16(968374712u);
    precise float _6668 = _6649 * _6665.x;
    precise float _6669 = _6649 * _6665.y;
    uint _6674 = (packHalf2x16(vec2(_6648, _6649)) << 16u) + (packHalf2x16(vec2(_6642, _6643)) & 65535u);
    vec2 _6675 = unpackHalf2x16((packHalf2x16(vec2(_5943.y, 0.0)) << 16u) + packHalf2x16(vec2(_5943.x, 0.0)));
    precise float _6678 = _6675.x + _6220;
    precise float _6679 = _6675.y + _6220;
    precise float _6682 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_5918.z, 0.0))).x + _6205;
    precise float _6688 = _6678 * abs(_6678);
    precise float _6689 = _6679 * abs(_6679);
    precise float _6694 = _6682 * abs(_6682);
    precise float _6695 = _6682 * abs(_6682);
    vec2 _6698 = unpackHalf2x16(_6674);
    vec2 _6701 = unpackHalf2x16(852307102u);
    vec2 _6704 = unpackHalf2x16((packHalf2x16(vec2(_6668, _6669)) << 16u) + (_6664 >> 16u));
    uint _6710 = packHalf2x16(vec2(fma(_6698.x, _6701.x, _6704.x), fma(_6698.y, _6701.y, _6704.y)));
    vec2 _6711 = unpackHalf2x16(968374712u);
    precise float _6714 = _6689 * _6711.x;
    precise float _6715 = _6689 * _6711.y;
    uint _6720 = (packHalf2x16(vec2(_6688, _6689)) << 16u) + (packHalf2x16(vec2(_6694, _6695)) & 65535u);
    vec2 _6721 = unpackHalf2x16((packHalf2x16(vec2(_5961.y, 0.0)) << 16u) + packHalf2x16(vec2(_5961.x, 0.0)));
    precise float _6724 = _6721.x + _6302;
    precise float _6725 = _6721.y + _6302;
    precise float _6728 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_5943.z, 0.0))).x + _6220;
    precise float _6734 = _6724 * abs(_6724);
    precise float _6735 = _6725 * abs(_6725);
    uint _6737 = packHalf2x16(vec2(_6734, _6735));
    precise float _6740 = _6728 * abs(_6728);
    precise float _6741 = _6728 * abs(_6728);
    vec2 _6744 = unpackHalf2x16(_6720);
    vec2 _6747 = unpackHalf2x16(852307102u);
    vec2 _6750 = unpackHalf2x16((packHalf2x16(vec2(_6714, _6715)) << 16u) + (_6710 >> 16u));
    uint _6756 = packHalf2x16(vec2(fma(_6744.x, _6747.x, _6750.x), fma(_6744.y, _6747.y, _6750.y)));
    vec2 _6757 = unpackHalf2x16(968374712u);
    precise float _6760 = _6735 * _6757.x;
    precise float _6761 = _6735 * _6757.y;
    uint _6766 = (_6737 << 16u) + (packHalf2x16(vec2(_6740, _6741)) & 65535u);
    vec2 _6767 = unpackHalf2x16((packHalf2x16(vec2(_5979.y, 0.0)) << 16u) + packHalf2x16(vec2(_5979.x, 0.0)));
    precise float _6770 = _6767.x + _6248;
    precise float _6771 = _6767.y + _6248;
    precise float _6774 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_5961.z, 0.0))).x + _6302;
    precise float _6780 = _6770 * abs(_6770);
    precise float _6781 = _6771 * abs(_6771);
    precise float _6786 = _6774 * abs(_6774);
    precise float _6787 = _6774 * abs(_6774);
    vec2 _6790 = unpackHalf2x16(_6766);
    vec2 _6793 = unpackHalf2x16(852307102u);
    vec2 _6796 = unpackHalf2x16((packHalf2x16(vec2(_6760, _6761)) << 16u) + (_6756 >> 16u));
    uint _6802 = packHalf2x16(vec2(fma(_6790.x, _6793.x, _6796.x), fma(_6790.y, _6793.y, _6796.y)));
    vec2 _6803 = unpackHalf2x16(968374712u);
    precise float _6806 = _6781 * _6803.x;
    precise float _6807 = _6781 * _6803.y;
    uint _6812 = (packHalf2x16(vec2(_6780, _6781)) << 16u) + (packHalf2x16(vec2(_6786, _6787)) & 65535u);
    vec2 _6813 = unpackHalf2x16((packHalf2x16(vec2(_5997.y, 0.0)) << 16u) + packHalf2x16(vec2(_5997.x, 0.0)));
    precise float _6816 = _6813.x + _6313;
    precise float _6817 = _6813.y + _6313;
    precise float _6820 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_5979.z, 0.0))).x + _6248;
    precise float _6826 = _6816 * abs(_6816);
    precise float _6827 = _6817 * abs(_6817);
    precise float _6832 = _6820 * abs(_6820);
    precise float _6833 = _6820 * abs(_6820);
    vec2 _6836 = unpackHalf2x16(_6812);
    vec2 _6839 = unpackHalf2x16(852307102u);
    vec2 _6842 = unpackHalf2x16((packHalf2x16(vec2(_6806, _6807)) << 16u) + (_6802 >> 16u));
    uint _6848 = packHalf2x16(vec2(fma(_6836.x, _6839.x, _6842.x), fma(_6836.y, _6839.y, _6842.y)));
    vec2 _6849 = unpackHalf2x16(968374712u);
    precise float _6852 = _6827 * _6849.x;
    precise float _6853 = _6827 * _6849.y;
    uint _6858 = (packHalf2x16(vec2(_6826, _6827)) << 16u) + (packHalf2x16(vec2(_6832, _6833)) & 65535u);
    vec2 _6859 = unpackHalf2x16((packHalf2x16(vec2(_6015.y, 0.0)) << 16u) + packHalf2x16(vec2(_6015.x, 0.0)));
    precise float _6862 = _6859.x + _6372;
    precise float _6863 = _6859.y + _6372;
    precise float _6866 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_5997.z, 0.0))).x + _6313;
    precise float _6872 = _6862 * abs(_6862);
    precise float _6873 = _6863 * abs(_6863);
    precise float _6878 = _6866 * abs(_6866);
    precise float _6879 = _6866 * abs(_6866);
    vec2 _6882 = unpackHalf2x16(_6858);
    vec2 _6885 = unpackHalf2x16(852307102u);
    vec2 _6888 = unpackHalf2x16((packHalf2x16(vec2(_6852, _6853)) << 16u) + (_6848 >> 16u));
    uint _6894 = packHalf2x16(vec2(fma(_6882.x, _6885.x, _6888.x), fma(_6882.y, _6885.y, _6888.y)));
    vec2 _6895 = unpackHalf2x16(968374712u);
    precise float _6898 = _6873 * _6895.x;
    precise float _6899 = _6873 * _6895.y;
    uint _6904 = (packHalf2x16(vec2(_6872, _6873)) << 16u) + (packHalf2x16(vec2(_6878, _6879)) & 65535u);
    precise float _6907 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_6015.z, 0.0))).x + _6372;
    vec2 _6908 = unpackHalf2x16((packHalf2x16(vec2(_6033.y, 0.0)) << 16u) + packHalf2x16(vec2(_6033.x, 0.0)));
    precise float _6911 = _6908.x + _6422;
    precise float _6912 = _6908.y + _6422;
    precise float _6918 = _6907 * abs(_6907);
    precise float _6919 = _6907 * abs(_6907);
    precise float _6924 = _6911 * abs(_6911);
    precise float _6925 = _6912 * abs(_6912);
    vec2 _6928 = unpackHalf2x16(_6904);
    vec2 _6931 = unpackHalf2x16(852307102u);
    vec2 _6934 = unpackHalf2x16((packHalf2x16(vec2(_6898, _6899)) << 16u) + (_6894 >> 16u));
    uint _6940 = packHalf2x16(vec2(fma(_6928.x, _6931.x, _6934.x), fma(_6928.y, _6931.y, _6934.y)));
    precise float _6943 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_6033.z, 0.0))).x + _6422;
    uint _6951 = ((bitfieldExtract(_4386, int(16u), int(16u)) * 48u) << 16u) + ((bitfieldExtract(_4386, int(0u), int(16u)) * 48u) + (gl_SubgroupInvocationID & 7u));
    vec2 _6952 = unpackHalf2x16(968374712u);
    precise float _6955 = _6925 * _6952.x;
    precise float _6956 = _6925 * _6952.y;
    uint _6958 = packHalf2x16(vec2(_6955, _6956));
    precise float _6961 = fma(fma(_6359.y, _6363, fma(_6344.y, -_6348, _6349.y)), unpackHalf2x16(_4920).x, fma(_6364, -unpackHalf2x16(_4920).x, _6364));
    precise float _6964 = _6943 * abs(_6943);
    precise float _6965 = _6943 * abs(_6943);
    uint _6968 = _6951 << 1u;
    precise float _6971 = fma(fma(_6493.y, _6497, fma(_6463.y, -_6467, _6468.y)), unpackHalf2x16(_4920).x, fma(_6498, -unpackHalf2x16(_4920).x, _6498));
    uint _6974 = (_6958 << 16u) + (_6940 >> 16u);
    barrier();
    vec2 _6979 = unpackHalf2x16((packHalf2x16(vec2(_6051.y, 0.0)) << 16u) + packHalf2x16(vec2(_6051.x, 0.0)));
    precise float _6982 = _6979.x + _6961;
    precise float _6983 = _6979.y + _6961;
    uint _6986 = (packHalf2x16(vec2(_6924, _6925)) << 16u) + (packHalf2x16(vec2(_6918, _6919)) & 65535u);
    vec2 _6987 = unpackHalf2x16((packHalf2x16(vec2(_6069.y, 0.0)) << 16u) + packHalf2x16(vec2(_6069.x, 0.0)));
    precise float _6990 = _6987.x + _6971;
    precise float _6991 = _6987.y + _6971;
    precise float _6997 = _6982 * abs(_6982);
    precise float _6998 = _6983 * abs(_6983);
    _36._m0[uint(int(_6968) >> int(1u))] = uint16_t((_6618 & 65535u) + (_6951 & 4294901760u));
    vec2 _7004 = unpackHalf2x16(_6986);
    vec2 _7007 = unpackHalf2x16(852307102u);
    vec2 _7010 = unpackHalf2x16(_6974);
    uint _7016 = packHalf2x16(vec2(fma(_7004.x, _7007.x, _7010.x), fma(_7004.y, _7007.y, _7010.y)));
    vec2 _7020 = unpackHalf2x16(968374712u);
    precise float _7023 = _6998 * _7020.x;
    precise float _7024 = _6998 * _7020.y;
    uint _7029 = (packHalf2x16(vec2(_6997, _6998)) << 16u) + (packHalf2x16(vec2(_6964, _6965)) & 65535u);
    precise float _7032 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_6051.z, 0.0))).x + _6961;
    precise float _7037 = _6990 * abs(_6990);
    precise float _7038 = _6991 * abs(_6991);
    precise float _7043 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_6069.z, 0.0))).x + _6971;
    _36._m0[uint(int(_6968 + 32u) >> int(1u))] = uint16_t((_6710 & 65535u) + (_6974 & 4294901760u));
    precise float _7050 = _7032 * abs(_7032);
    precise float _7051 = _7032 * abs(_7032);
    vec2 _7054 = unpackHalf2x16(968374712u);
    precise float _7057 = _7038 * _7054.x;
    precise float _7058 = _7038 * _7054.y;
    _36._m0[uint(int(_6968 + 80u) >> int(1u))] = uint16_t(_6848);
    vec2 _7066 = unpackHalf2x16((packHalf2x16(vec2(_6087.y, 0.0)) << 16u) + packHalf2x16(vec2(_6087.x, 0.0)));
    precise float _7069 = _7066.x + _6251;
    precise float _7070 = _7066.y + _6251;
    uint _7073 = (packHalf2x16(vec2(_7037, _7038)) << 16u) + (packHalf2x16(vec2(_7050, _7051)) & 65535u);
    precise float _7076 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_6087.z, 0.0))).x + _6251;
    _36._m0[uint(int(_6968 + 416u) >> int(1u))] = uint16_t(_7016);
    precise float _7084 = _7069 * abs(_7069);
    precise float _7085 = _7070 * abs(_7070);
    precise float _7093 = _7043 * abs(_7043);
    precise float _7094 = _7043 * abs(_7043);
    _36._m0[uint(int(_6968 + 384u) >> int(1u))] = uint16_t(_6894);
    vec2 _7101 = unpackHalf2x16(968374712u);
    precise float _7104 = _7085 * _7101.x;
    precise float _7105 = _7085 * _7101.y;
    vec2 _7108 = unpackHalf2x16(_7029);
    vec2 _7111 = unpackHalf2x16(852307102u);
    vec2 _7114 = unpackHalf2x16((packHalf2x16(vec2(_7023, _7024)) << 16u) + (_7016 >> 16u));
    uint _7120 = packHalf2x16(vec2(fma(_7108.x, _7111.x, _7114.x), fma(_7108.y, _7111.y, _7114.y)));
    uint _7123 = (packHalf2x16(vec2(_7084, _7085)) << 16u) + (packHalf2x16(vec2(_7093, _7094)) & 65535u);
    vec2 _7124 = unpackHalf2x16((packHalf2x16(vec2(_6105.y, 0.0)) << 16u) + packHalf2x16(vec2(_6105.x, 0.0)));
    precise float _7127 = _7124.x + _6316;
    precise float _7128 = _7124.y + _6316;
    _36._m0[uint(int(_6968 + 16u) >> int(1u))] = uint16_t((_6664 & 65535u) + (_6958 & 4294901760u));
    vec2 _7133 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_6105.z, 0.0)));
    float _7134 = _7133.x;
    precise float _7135 = _7134 + _6316;
    precise float _7136 = _7134 + _6316;
    precise float _7144 = _7127 * abs(_7127);
    precise float _7145 = _7128 * abs(_7128);
    uint _7147 = packHalf2x16(vec2(_7144, _7145));
    uint _7148 = gl_LocalInvocationID.x & 7u;
    vec2 _7149 = unpackHalf2x16((packHalf2x16(vec2(_6123.y, 0.0)) << 16u) + packHalf2x16(vec2(_6123.x, 0.0)));
    precise float _7152 = _7149.x + _6383;
    precise float _7153 = _7149.y + _6383;
    _36._m0[uint(int(_6968 + 48u) >> int(1u))] = uint16_t(_6756);
    vec2 _7158 = unpackHalf2x16(_7073);
    vec2 _7161 = unpackHalf2x16(852307102u);
    vec2 _7164 = unpackHalf2x16((packHalf2x16(vec2(_7057, _7058)) << 16u) + (_7120 >> 16u));
    uint _7170 = packHalf2x16(vec2(fma(_7158.x, _7161.x, _7164.x), fma(_7158.y, _7161.y, _7164.y)));
    precise float _7173 = _7076 * abs(_7076);
    precise float _7174 = _7076 * abs(_7076);
    _36._m0[uint(int(_6968 + 64u) >> int(1u))] = uint16_t(_6802);
    vec2 _7182 = unpackHalf2x16(968374712u);
    precise float _7185 = _7145 * _7182.x;
    precise float _7186 = _7145 * _7182.y;
    precise float _7194 = _7152 * abs(_7152);
    precise float _7195 = _7153 * abs(_7153);
    uint _7200 = (_7147 << 16u) + (packHalf2x16(vec2(_7173, _7174)) & 65535u);
    precise float _7203 = _7135 * abs(_7135);
    precise float _7204 = _7135 * abs(_7135);
    vec2 _7210 = unpackHalf2x16(_7123);
    vec2 _7213 = unpackHalf2x16(852307102u);
    vec2 _7216 = unpackHalf2x16((packHalf2x16(vec2(_7104, _7105)) << 16u) + (_7170 >> 16u));
    uint _7222 = packHalf2x16(vec2(fma(_7210.x, _7213.x, _7216.x), fma(_7210.y, _7213.y, _7216.y)));
    _36._m0[uint(int(_6968 + 400u) >> int(1u))] = uint16_t(_6940);
    precise float _7230 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_6123.z, 0.0))).x + _6383;
    uint _7233 = (packHalf2x16(vec2(_7194, _7195)) << 16u) + (packHalf2x16(vec2(_7203, _7204)) & 65535u);
    vec2 _7234 = unpackHalf2x16(968374712u);
    precise float _7237 = _7195 * _7234.x;
    precise float _7238 = _7195 * _7234.y;
    vec2 _7244 = unpackHalf2x16((packHalf2x16(vec2(_6141.y, 0.0)) << 16u) + packHalf2x16(vec2(_6141.x, 0.0)));
    precise float _7247 = _7244.x + _6433;
    precise float _7248 = _7244.y + _6433;
    _36._m0[uint(int(_6968 + 432u) >> int(1u))] = uint16_t((_7120 & 65535u) + (packHalf2x16(vec2(_7135, _7136)) & 4294901760u));
    precise float _7255 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_6141.z, 0.0))).x + _6433;
    vec2 _7256 = unpackHalf2x16(_7200);
    vec2 _7259 = unpackHalf2x16(852307102u);
    vec2 _7262 = unpackHalf2x16((packHalf2x16(vec2(_7185, _7186)) << 16u) + (_7222 >> 16u));
    uint _7268 = packHalf2x16(vec2(fma(_7256.x, _7259.x, _7262.x), fma(_7256.y, _7259.y, _7262.y)));
    _36._m0[uint(int(_6968 + 448u) >> int(1u))] = uint16_t(_7170);
    precise float _7276 = _7247 * abs(_7247);
    precise float _7277 = _7248 * abs(_7248);
    precise float _7282 = _7230 * abs(_7230);
    precise float _7283 = _7230 * abs(_7230);
    vec2 _7289 = unpackHalf2x16(968374712u);
    precise float _7292 = _7277 * _7289.x;
    precise float _7293 = _7277 * _7289.y;
    _36._m0[uint(int(_6968 + 464u) >> int(1u))] = uint16_t(_7222);
    vec2 _7301 = unpackHalf2x16((packHalf2x16(vec2(_6159.y, 0.0)) << 16u) + packHalf2x16(vec2(_6159.x, 0.0)));
    precise float _7304 = _7301.x + _6521;
    precise float _7305 = _7301.y + _6521;
    uint _7308 = (packHalf2x16(vec2(_7276, _7277)) << 16u) + (packHalf2x16(vec2(_7282, _7283)) & 65535u);
    vec2 _7309 = unpackHalf2x16(_7233);
    vec2 _7312 = unpackHalf2x16(852307102u);
    vec2 _7315 = unpackHalf2x16((packHalf2x16(vec2(_7237, _7238)) << 16u) + (_7268 >> 16u));
    uint _7321 = packHalf2x16(vec2(fma(_7309.x, _7312.x, _7315.x), fma(_7309.y, _7312.y, _7315.y)));
    _36._m0[uint(int(_6968 + 768u) >> int(1u))] = uint16_t(_7268);
    precise float _7329 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_6159.z, 0.0))).x + _6521;
    precise float _7332 = _7304 * abs(_7304);
    precise float _7333 = _7305 * abs(_7305);
    precise float _7341 = _7255 * abs(_7255);
    precise float _7342 = _7255 * abs(_7255);
    uint _7345 = _7148 * 6u;
    vec2 _7346 = unpackHalf2x16(968374712u);
    precise float _7349 = _7333 * _7346.x;
    precise float _7350 = _7333 * _7346.y;
    uint _7353 = _7148 * 3u;
    vec2 _7354 = unpackHalf2x16(_7308);
    vec2 _7357 = unpackHalf2x16(852307102u);
    vec2 _7360 = unpackHalf2x16((packHalf2x16(vec2(_7292, _7293)) << 16u) + (_7321 >> 16u));
    uint _7366 = packHalf2x16(vec2(fma(_7354.x, _7357.x, _7360.x), fma(_7354.y, _7357.y, _7360.y)));
    uint _7369 = (packHalf2x16(vec2(_7332, _7333)) << 16u) + (packHalf2x16(vec2(_7341, _7342)) & 65535u);
    precise float _7372 = _7329 * abs(_7329);
    precise float _7373 = _7329 * abs(_7329);
    uint _7376 = gl_LocalInvocationID.x >> 3u;
    vec2 _7377 = unpackHalf2x16((packHalf2x16(vec2(_6177.y, 0.0)) << 16u) + packHalf2x16(vec2(_6177.x, 0.0)));
    precise float _7380 = _7377.x + _6532;
    precise float _7381 = _7377.y + _6532;
    precise float _7385 = unpackHalf2x16((packHalf2x16(vec2(0.0)) << 16u) + packHalf2x16(vec2(_6177.z, 0.0))).x + _6532;
    precise float _7391 = _7380 * abs(_7380);
    precise float _7392 = _7381 * abs(_7381);
    uint _7395 = _7376 * 3u;
    precise float _7398 = _7385 * abs(_7385);
    _36._m0[uint(int(_6968 + 784u) >> int(1u))] = uint16_t(_7321);
    vec2 _7404 = unpackHalf2x16(_7369);
    vec2 _7407 = unpackHalf2x16(852307102u);
    vec2 _7410 = unpackHalf2x16((packHalf2x16(vec2(_7349, _7350)) << 16u) + (_7366 >> 16u));
    uint _7416 = packHalf2x16(vec2(fma(_7404.x, _7407.x, _7410.x), fma(_7404.y, _7407.y, _7410.y)));
    vec2 _7418 = unpackHalf2x16(968374712u);
    precise float _7421 = _7392 * _7418.x;
    precise float _7422 = _7392 * _7418.y;
    _36._m0[uint(int(_6968 + 800u) >> int(1u))] = uint16_t(_7366);
    uint _7442 = (packHalf2x16(vec2(_7391, _7392)) << 16u) + (packHalf2x16(vec2(_7372, _7373)) & 65535u);
    _36._m0[uint(int(_6968 + 816u) >> int(1u))] = uint16_t(_7416);
    uint _7451 = uint(max(int(0u), int(_7395 + 4294967295u)));
    uint _7453 = uint(min(int(_7395 + 3u), int(47u)));
    vec2 _7454 = unpackHalf2x16(_7442);
    vec2 _7457 = unpackHalf2x16(852307102u);
    vec2 _7460 = unpackHalf2x16((packHalf2x16(vec2(_7421, _7422)) << 16u) + (_7416 >> 16u));
    precise float _7464 = fma(_7454.y, _7457.y, _7460.y);
    uint _7474 = ((bitfieldExtract(_7451, int(16u), int(16u)) * 24u) << 16u) + ((bitfieldExtract(_7451, int(0u), int(16u)) * 24u) + _7353);
    uint _7481 = ((bitfieldExtract(_7453, int(16u), int(16u)) * 24u) << 16u) + ((bitfieldExtract(_7453, int(0u), int(16u)) * 24u) + _7353);
    _36._m0[uint(int(_6968 + 832u) >> int(1u))] = uint16_t(packHalf2x16(vec2(fma(_7454.x, _7457.x, _7460.x), _7464)));
    uint _7493 = ((bitfieldExtract(_7376, int(16u), int(16u)) * 72u) << 16u) + ((bitfieldExtract(_7376, int(0u), int(16u)) * 72u) + _7353);
    vec2 _7501 = unpackHalf2x16(748563614u);
    uint _7508 = (((bitfieldExtract(_7376, int(16u), int(16u)) * 144u) << 16u) + ((bitfieldExtract(_7376, int(0u), int(16u)) * 144u) + uint(min(int(_7345 + 6u), int(47u))))) << 1u;
    _36._m0[uint(int(_6968 + 848u) >> int(1u))] = uint16_t(packHalf2x16(vec2(fma(_7398, _7501.x, _7464), fma(_7398, _7501.y, _7464))));
    barrier();
    uint _7519 = (((bitfieldExtract(_7376, int(16u), int(16u)) * 144u) << 16u) + ((bitfieldExtract(_7376, int(0u), int(16u)) * 144u) + uint(max(int(0u), int(_7345 + 4294967295u))))) << 1u;
    uint _7521 = uint(int(_7481 << 2u) >> int(2u));
    precise float _7528 = c0_1.data[32u] * (-0.125);
    uint _7531 = uint(int((_7481 << 2u) + 4u) >> int(2u));
    precise float _7536 = c0_1.data[32u] * 0.5;
    uint _7540 = uint(int((_7493 << 2u) + 192u) >> int(2u));
    uint _7548 = (packHalf2x16(vec2(_7536, 0.0)) << 16u) + packHalf2x16(vec2(_7528, 0.0));
    uint _7557 = uint(int((_7493 << 2u) + 196u) >> int(2u));
    uint _7567 = uint(int((_7481 << 2u) + 8u) >> int(2u));
    uint _7573 = uint(int((_7493 << 2u) + 200u) >> int(2u));
    uint _7578 = uint(int((_7493 << 2u) + 104u) >> int(2u));
    uint _7580 = _42._m0[_7578];
    uint _7584 = uint(int((_7493 << 2u) + 100u) >> int(2u));
    uint _7586 = _42._m0[_7584];
    vec2 _7597 = unpackHalf2x16((_42._m0[_7521] << 16u) + (uint(_36._m0[uint(int(_7508 + 96u) >> int(1u))]) & 65535u));
    vec2 _7600 = unpackHalf2x16(_7548);
    float _7601 = _7600.x;
    precise float _7602 = _7597.x * _7601;
    precise float _7603 = _7597.y * _7601;
    uint _7605 = packHalf2x16(vec2(_7602, _7603));
    vec2 _7611 = unpackHalf2x16(_42._m0[_7540]);
    vec2 _7614 = unpackHalf2x16(_7548);
    float _7615 = _7614.x;
    precise float _7616 = _7611.x * _7615;
    precise float _7617 = _7611.y * _7615;
    vec2 _7620 = unpackHalf2x16((_42._m0[_7531] << 16u) + (_42._m0[_7521] >> 16u));
    vec2 _7623 = unpackHalf2x16(_7548);
    float _7624 = _7623.x;
    precise float _7625 = _7620.x * _7624;
    precise float _7626 = _7620.y * _7624;
    uint _7628 = packHalf2x16(vec2(_7625, _7626));
    vec2 _7637 = unpackHalf2x16(_42._m0[_7557]);
    vec2 _7640 = unpackHalf2x16(_7548);
    float _7641 = _7640.x;
    precise float _7642 = _7637.x * _7641;
    precise float _7643 = _7637.y * _7641;
    uint _7645 = packHalf2x16(vec2(_7642, _7643));
    vec2 _7648 = unpackHalf2x16(_42._m0[_7540]);
    vec2 _7651 = unpackHalf2x16(_7548);
    float _7652 = _7651.y;
    vec2 _7653 = unpackHalf2x16((_7628 << 16u) + (_7605 >> 16u));
    vec2 _7667 = unpackHalf2x16((_42._m0[_7540] << 16u) + (uint(_36._m0[uint(int(_7519 + 192u) >> int(1u))]) & 65535u));
    vec2 _7670 = unpackHalf2x16(_7548);
    float _7671 = _7670.x;
    vec2 _7672 = unpackHalf2x16((_7645 << 16u) + (packHalf2x16(vec2(_7616, _7617)) >> 16u));
    vec2 _7677 = unpackHalf2x16((uint(_36._m0[uint(int(_7508 + 192u) >> int(1u))]) << 16u) + (_42._m0[_7567] >> 16u));
    vec2 _7680 = unpackHalf2x16(_7548);
    float _7681 = _7680.x;
    precise float _7682 = _7677.x * _7681;
    precise float _7683 = _7677.y * _7681;
    uint _7685 = packHalf2x16(vec2(_7682, _7683));
    vec2 _7689 = unpackHalf2x16((_42._m0[_7567] << 16u) + (_42._m0[_7531] >> 16u));
    vec2 _7692 = unpackHalf2x16(_7548);
    float _7693 = _7692.x;
    precise float _7694 = _7689.x * _7693;
    precise float _7695 = _7689.y * _7693;
    uint _7697 = packHalf2x16(vec2(_7694, _7695));
    uint _7700 = uint(int((_7493 << 2u) + 96u) >> int(2u));
    uint _7702 = _42._m0[_7700];
    vec2 _7703 = unpackHalf2x16(_42._m0[_7573]);
    vec2 _7706 = unpackHalf2x16(_7548);
    float _7707 = _7706.x;
    precise float _7708 = _7703.x * _7707;
    precise float _7709 = _7703.y * _7707;
    uint _7711 = packHalf2x16(vec2(_7708, _7709));
    precise float _7712 = fma(_7648.x, _7652, _7653.x) + fma(_7667.x, _7671, _7672.x);
    precise float _7713 = fma(_7648.y, _7652, _7653.y) + fma(_7667.y, _7671, _7672.y);
    vec2 _7717 = unpackHalf2x16(_7586);
    vec2 _7720 = unpackHalf2x16(_7548);
    float _7721 = _7720.x;
    precise float _7722 = _7717.x * _7721;
    precise float _7723 = _7717.y * _7721;
    uint _7725 = packHalf2x16(vec2(_7722, _7723));
    vec2 _7732 = unpackHalf2x16(_42._m0[_7573]);
    vec2 _7735 = unpackHalf2x16(_7548);
    float _7736 = _7735.y;
    vec2 _7737 = unpackHalf2x16((_7685 << 16u) + (_7697 >> 16u));
    vec2 _7742 = unpackHalf2x16((_42._m0[_7573] << 16u) + (_42._m0[_7557] >> 16u));
    vec2 _7745 = unpackHalf2x16(_7548);
    float _7746 = _7745.x;
    vec2 _7747 = unpackHalf2x16((_7711 >> 16u) + (_7685 & 4294901760u));
    uint _7754 = uint(int((_7493 << 2u) + 8u) >> int(2u));
    uint _7756 = _42._m0[_7754];
    vec2 _7757 = unpackHalf2x16(_42._m0[_7557]);
    vec2 _7760 = unpackHalf2x16(_7548);
    float _7761 = _7760.y;
    vec2 _7762 = unpackHalf2x16((_7697 << 16u) + (_7628 >> 16u));
    precise float _7770 = fma(_7732.x, _7736, _7737.x) + fma(_7742.x, _7746, _7747.x);
    precise float _7771 = fma(_7732.y, _7736, _7737.y) + fma(_7742.y, _7746, _7747.y);
    uint _7777 = uint(int((_7493 << 2u) + 4u) >> int(2u));
    uint _7779 = _42._m0[_7777];
    vec2 _7780 = unpackHalf2x16(_7580);
    vec2 _7783 = unpackHalf2x16(_7548);
    float _7784 = _7783.y;
    vec2 _7787 = unpackHalf2x16(_7586);
    vec2 _7790 = unpackHalf2x16(_7548);
    float _7791 = _7790.y;
    vec2 _7798 = unpackHalf2x16((_42._m0[_7557] << 16u) + (_42._m0[_7540] >> 16u));
    vec2 _7801 = unpackHalf2x16(_7548);
    float _7802 = _7801.x;
    vec2 _7803 = unpackHalf2x16((_7711 << 16u) + (_7645 >> 16u));
    vec2 _7808 = unpackHalf2x16(_7580);
    vec2 _7811 = unpackHalf2x16(_7548);
    float _7812 = _7811.x;
    precise float _7813 = _7808.x * _7812;
    precise float _7814 = _7808.y * _7812;
    uint _7816 = packHalf2x16(vec2(_7813, _7814));
    precise float _7817 = fma(_7757.x, _7761, _7762.x) + fma(_7798.x, _7802, _7803.x);
    precise float _7818 = fma(_7757.y, _7761, _7762.y) + fma(_7798.y, _7802, _7803.y);
    uint _7820 = uint(int(_7493 << 2u) >> int(2u));
    uint _7822 = _42._m0[_7820];
    vec2 _7826 = unpackHalf2x16(_7580);
    vec2 _7829 = unpackHalf2x16(_7548);
    float _7830 = _7829.x;
    uint _7834 = packHalf2x16(vec2(fma(_7826.x, _7830, _7770), fma(_7826.y, _7830, _7771)));
    vec2 _7838 = unpackHalf2x16(_7586);
    vec2 _7841 = unpackHalf2x16(_7548);
    float _7842 = _7841.x;
    vec2 _7847 = unpackHalf2x16((_7580 << 16u) + (_7586 >> 16u));
    vec2 _7850 = unpackHalf2x16(_7548);
    float _7851 = _7850.x;
    vec2 _7852 = unpackHalf2x16((_7605 << 16u) + (_7816 >> 16u));
    uint _7860 = _42._m0[uint(int(_7474 << 2u) >> int(2u))];
    precise float _7864 = fma(_7780.x, _7784, _7708) + fma(_7847.x, _7851, _7852.x);
    precise float _7865 = fma(_7780.y, _7784, _7709) + fma(_7847.y, _7851, _7852.y);
    vec2 _7869 = unpackHalf2x16(_7702);
    vec2 _7872 = unpackHalf2x16(_7548);
    float _7873 = _7872.y;
    vec2 _7879 = unpackHalf2x16(_7702);
    vec2 _7882 = unpackHalf2x16(_7548);
    float _7883 = _7882.x;
    vec2 _7888 = unpackHalf2x16((_7586 << 16u) + (_7702 >> 16u));
    vec2 _7891 = unpackHalf2x16(_7548);
    float _7892 = _7891.x;
    vec2 _7893 = unpackHalf2x16((_7816 << 16u) + (_7725 >> 16u));
    precise float _7898 = fma(_7787.x, _7791, _7642) + fma(_7888.x, _7892, _7893.x);
    precise float _7899 = fma(_7787.y, _7791, _7643) + fma(_7888.y, _7892, _7893.y);
    uint _7907 = _42._m0[uint(int((_7474 << 2u) + 4u) >> int(2u))];
    vec2 _7908 = unpackHalf2x16(_7756);
    vec2 _7911 = unpackHalf2x16(_7548);
    float _7912 = _7911.y;
    vec2 _7915 = unpackHalf2x16(_7756);
    vec2 _7918 = unpackHalf2x16(_7548);
    float _7919 = _7918.x;
    uint _7923 = packHalf2x16(vec2(fma(_7915.x, _7919, _7864), fma(_7915.y, _7919, _7865)));
    uint _7926 = (_7756 << 16u) + (_7779 >> 16u);
    uint _7931 = _42._m0[uint(int((_7474 << 2u) + 8u) >> int(2u))];
    vec2 _7932 = unpackHalf2x16((uint(_36._m0[uint(int(_7508) >> int(1u))]) << 16u) + (_7756 >> 16u));
    vec2 _7935 = unpackHalf2x16(_7548);
    float _7936 = _7935.x;
    precise float _7937 = _7932.x * _7936;
    precise float _7938 = _7932.y * _7936;
    vec2 _7939 = unpackHalf2x16(_7779);
    vec2 _7942 = unpackHalf2x16(_7548);
    float _7943 = _7942.x;
    vec2 _7948 = unpackHalf2x16(_7926);
    vec2 _7951 = unpackHalf2x16(_7548);
    float _7952 = _7951.x;
    precise float _7955 = fma(_7908.x, _7912, _7813) + fma(_7948.x, _7952, _7937);
    precise float _7956 = fma(_7908.y, _7912, _7814) + fma(_7948.y, _7952, _7938);
    vec2 _7960 = unpackHalf2x16(_7926);
    vec2 _7963 = unpackHalf2x16(_7548);
    float _7964 = _7963.x;
    precise float _7965 = _7960.x * _7964;
    precise float _7966 = _7960.y * _7964;
    uint _7969 = (_7779 << 16u) + (_7822 >> 16u);
    vec2 _7970 = unpackHalf2x16(_7969);
    vec2 _7973 = unpackHalf2x16(_7548);
    float _7974 = _7973.x;
    vec2 _7977 = unpackHalf2x16(_7969);
    vec2 _7980 = unpackHalf2x16(_7548);
    float _7981 = _7980.x;
    precise float _7982 = _7977.x * _7981;
    precise float _7983 = _7977.y * _7981;
    vec2 _7984 = unpackHalf2x16((_7822 << 16u) + (uint(_36._m0[uint(int(_7519) >> int(1u))]) & 65535u));
    vec2 _7987 = unpackHalf2x16(_7548);
    float _7988 = _7987.x;
    vec2 _7991 = unpackHalf2x16(_7702);
    vec2 _7994 = unpackHalf2x16(_7548);
    float _7995 = _7994.x;
    precise float _7996 = _7991.x * _7995;
    precise float _7997 = _7991.y * _7995;
    vec2 _8003 = unpackHalf2x16(_7822);
    vec2 _8006 = unpackHalf2x16(_7548);
    float _8007 = _8006.y;
    vec2 _8010 = unpackHalf2x16(_7779);
    vec2 _8013 = unpackHalf2x16(_7548);
    float _8014 = _8013.y;
    vec2 _8017 = unpackHalf2x16((_7702 << 16u) + (uint(_36._m0[uint(int(_7519 + 96u) >> int(1u))]) & 65535u));
    vec2 _8020 = unpackHalf2x16(_7548);
    float _8021 = _8020.x;
    vec2 _8022 = unpackHalf2x16((_7725 << 16u) + (packHalf2x16(vec2(_7996, _7997)) >> 16u));
    precise float _8027 = fma(_8003.x, _8007, _7996) + fma(_7984.x, _7988, _7982);
    precise float _8028 = fma(_8003.y, _8007, _7997) + fma(_7984.y, _7988, _7983);
    precise float _8029 = fma(_7869.x, _7873, _7616) + fma(_8017.x, _8021, _8022.x);
    precise float _8030 = fma(_7869.y, _7873, _7617) + fma(_8017.y, _8021, _8022.y);
    vec2 _8031 = unpackHalf2x16(_7931);
    vec2 _8034 = unpackHalf2x16(_7548);
    float _8035 = _8034.x;
    vec2 _8042 = unpackHalf2x16(_7822);
    vec2 _8045 = unpackHalf2x16(_7548);
    float _8046 = _8045.x;
    uint _8051 = -gl_WorkGroupID.x;
    precise float _8052 = fma(_8010.x, _8014, _7722) + fma(_7970.x, _7974, _7965);
    precise float _8053 = fma(_8010.y, _8014, _7723) + fma(_7970.y, _7974, _7966);
    vec2 _8054 = unpackHalf2x16(_7860);
    vec2 _8057 = unpackHalf2x16(_7548);
    float _8058 = _8057.x;
    vec2 _8078 = unpackHalf2x16(_7907);
    vec2 _8081 = unpackHalf2x16(_7548);
    float _8082 = _8081.x;
    uint _8090 = -gl_WorkGroupID.y;
    barrier();
    _42._m0[uint(int(_7493 << 2u) >> int(2u))] = packHalf2x16(vec2(fma(_8054.x, _8058, _8027), fma(_8054.y, _8058, _8028)));
    uint _8110 = gl_SubgroupInvocationID & 7u;
    _42._m0[uint(int((_7493 << 2u) + 4u) >> int(2u))] = packHalf2x16(vec2(fma(_8078.x, _8082, _8052), fma(_8078.y, _8082, _8053)));
    _42._m0[uint(int((_7493 << 2u) + 8u) >> int(2u))] = packHalf2x16(vec2(fma(_8031.x, _8035, _7955), fma(_8031.y, _8035, _7956)));
    _42._m0[uint(int((_7493 << 2u) + 96u) >> int(2u))] = packHalf2x16(vec2(fma(_8042.x, _8046, _8029), fma(_8042.y, _8046, _8030)));
    _42._m0[uint(int((_7493 << 2u) + 100u) >> int(2u))] = packHalf2x16(vec2(fma(_7939.x, _7943, _7898), fma(_7939.y, _7943, _7899)));
    _42._m0[uint(int((_7493 << 2u) + 104u) >> int(2u))] = _7923;
    _42._m0[uint(int((_7493 << 2u) + 192u) >> int(2u))] = packHalf2x16(vec2(fma(_7879.x, _7883, _7712), fma(_7879.y, _7883, _7713)));
    _42._m0[uint(int((_7493 << 2u) + 196u) >> int(2u))] = packHalf2x16(vec2(fma(_7838.x, _7842, _7817), fma(_7838.y, _7842, _7818)));
    _42._m0[uint(int((_7493 << 2u) + 200u) >> int(2u))] = _7834;
    uint _8146 = uint(_36._m0[uint(int(_6968) >> int(1u))]);
    uint _8149 = min(((((bitfieldExtract(_8051, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(16u), int(16u))) + (bitfieldExtract(_8051, int(16u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u)))) << 16u) + ((bitfieldExtract(_8051, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u))) + c0.data[28u])), c0.data[22u]);
    uint _8164 = (((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.x, int(16u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u)))) << 16u) + ((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u))) + _8110);
    uint _8167 = min(((((bitfieldExtract(_8090, int(0u), int(16u)) * bitfieldExtract(c0.data[23u], int(16u), int(16u))) + (bitfieldExtract(_8090, int(16u), int(16u)) * bitfieldExtract(c0.data[23u], int(0u), int(16u)))) << 16u) + ((bitfieldExtract(_8090, int(0u), int(16u)) * bitfieldExtract(c0.data[23u], int(0u), int(16u))) + c0.data[29u])), c0.data[23u]);
    uint _8172 = uint(_36._m0[uint(int(_6968 + 16u) >> int(1u))]);
    bool _8173 = _8110 >= _8149;
    bool _8174 = _4386 >= _8167;
    uint _8176 = uint(int(_642 + 4u) >> int(2u));
    bool _8181 = (_4386 < _8167) && (!_8173);
    uint _8182 = _8110 + 8u;
    uint _8187 = uint(_36._m0[uint(int(_6968 + 32u) >> int(1u))]);
    uint _8188 = _8110 + 16u;
    bool _8191 = (_8182 < _8149) && (!_8174);
    uint _8196 = uint(_36._m0[uint(int(_6968 + 48u) >> int(1u))]);
    bool _8197 = _8182 >= _8149;
    uint _8210 = (bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.x, int(16u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u)));
    uint _8212 = (_8210 << 16u) + ((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u))) + _8182);
    bool _8215 = (_8188 < _8149) && (!_8174);
    uint _8220 = uint(_36._m0[uint(int(_6968 + 64u) >> int(1u))]);
    uint _8221 = _8110 + 32u;
    uint _8224;
    if (_8181)
    {
        _8224 = c0.data[8u];
    }
    else
    {
        _8224 = _8210;
    }
    uint _8226;
    if (_8181)
    {
        _8226 = _8164 + _8224;
    }
    else
    {
        _8226 = _7923;
    }
    uint _8231 = uint(_36._m0[uint(int(_6968 + 80u) >> int(1u))]);
    bool _8234 = (_4758 < _8167) && (!_8173);
    uint _8239 = uint(_36._m0[uint(int(_6968 + 384u) >> int(1u))]);
    uint _8242;
    if (_8191)
    {
        _8242 = c0.data[8u];
    }
    else
    {
        _8242 = _8224;
    }
    uint _8244;
    if (_8191)
    {
        _8244 = _8212 + _8242;
    }
    else
    {
        _8244 = _7834;
    }
    vec2 _8245 = unpackHalf2x16(_8146);
    float _8246 = _8245.x;
    precise float _8247 = _6543 + _8246;
    precise float _8248 = _6544 + _8246;
    vec2 _8251 = unpackHalf2x16(_6581);
    float _8252 = _8251.x;
    vec2 _8253 = unpackHalf2x16(_8146);
    float _8254 = _8253.x;
    precise float _8255 = _8252 + _8254;
    precise float _8256 = _8252 + _8254;
    uint _8259;
    if (_8181)
    {
        _8259 = 1065353216u;
    }
    else
    {
        _8259 = _6581;
    }
    vec2 _8260 = unpackHalf2x16(_8172);
    float _8261 = _8260.x;
    precise float _8262 = _6555 + _8261;
    precise float _8263 = _6556 + _8261;
    uint _8267;
    if (_8181)
    {
        _8267 = floatBitsToUint(_8247);
    }
    else
    {
        _8267 = _6558;
    }
    vec2 _8268 = unpackHalf2x16(_6628);
    float _8269 = _8268.x;
    vec2 _8270 = unpackHalf2x16(_8172);
    float _8271 = _8270.x;
    precise float _8272 = _8269 + _8271;
    precise float _8273 = _8269 + _8271;
    uint _8277;
    if (_8181)
    {
        _8277 = floatBitsToUint(_8248);
    }
    else
    {
        _8277 = _6628;
    }
    uint _8281;
    if (_8181)
    {
        _8281 = c0.data[9u];
    }
    else
    {
        _8281 = _8242;
    }
    uint _8283;
    if (_8181)
    {
        _8283 = _42._m0[_8176] + _8281;
    }
    else
    {
        _8283 = _7756;
    }
    uint _8285;
    if (_8181)
    {
        _8285 = floatBitsToUint(_8255);
    }
    else
    {
        _8285 = packHalf2x16(vec2(_8247, _8248));
    }
    uint _8288;
    if (_8191)
    {
        _8288 = c0.data[9u];
    }
    else
    {
        _8288 = _8281;
    }
    uint _8290;
    if (_8191)
    {
        _8290 = _42._m0[_8176] + _8288;
    }
    else
    {
        _8290 = _8146;
    }
    uint _8292;
    if (_8191)
    {
        _8292 = floatBitsToUint(_8262);
    }
    else
    {
        _8292 = packHalf2x16(vec2(_8255, _8256));
    }
    vec2 _8293 = unpackHalf2x16(_8187);
    float _8294 = _8293.x;
    precise float _8295 = _6595 + _8294;
    precise float _8296 = _6596 + _8294;
    if (_8181)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_8226, _8283)), uintBitsToFloat(uvec4(_8267, _8277, _8285, _8259)));
    }
    bool _8303 = _8188 >= _8149;
    uint _8304;
    if (_8191)
    {
        _8304 = 1065353216u;
    }
    else
    {
        _8304 = _8172;
    }
    precise float _8309 = unpackHalf2x16(_6674).x + unpackHalf2x16(_8187).x;
    uint _8311;
    if (_8191)
    {
        _8311 = floatBitsToUint(_8263);
    }
    else
    {
        _8311 = packHalf2x16(vec2(_8262, _8263));
    }
    uint _8312 = _8110 + 24u;
    uint _8314;
    if (_8191)
    {
        _8314 = floatBitsToUint(_8272);
    }
    else
    {
        _8314 = packHalf2x16(vec2(_8272, _8273));
    }
    uint _8327 = (bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.x, int(16u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u)));
    uint _8329 = (_8327 << 16u) + ((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u))) + _8188);
    if (_8191)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_8244, _8290)), uintBitsToFloat(uvec4(_8292, _8311, _8314, _8304)));
    }
    bool _8336 = (_8312 < _8149) && (!_8174);
    vec2 _8337 = unpackHalf2x16(_8239);
    float _8338 = _8337.x;
    precise float _8339 = _6780 + _8338;
    precise float _8340 = _6781 + _8338;
    precise float _8345 = unpackHalf2x16(_6858).x + unpackHalf2x16(_8239).x;
    uint _8346;
    if (_8215)
    {
        _8346 = 1065353216u;
    }
    else
    {
        _8346 = _8259;
    }
    vec2 _8347 = unpackHalf2x16(_6812);
    float _8348 = _8347.x;
    vec2 _8349 = unpackHalf2x16(_8231);
    float _8350 = _8349.x;
    precise float _8351 = _8348 + _8350;
    precise float _8352 = _8348 + _8350;
    uint _8356;
    if (_8215)
    {
        _8356 = floatBitsToUint(_8295);
    }
    else
    {
        _8356 = _8267;
    }
    uint _8358;
    if (_8215)
    {
        _8358 = floatBitsToUint(_8296);
    }
    else
    {
        _8358 = _8277;
    }
    uint _8360;
    if (_8215)
    {
        _8360 = floatBitsToUint(_8309);
    }
    else
    {
        _8360 = _8285;
    }
    uint _8361 = _8110 + 40u;
    uint _8366 = uint(_36._m0[uint(int(_6968 + 416u) >> int(1u))]);
    uint _8369;
    if (_8215)
    {
        _8369 = c0.data[8u];
    }
    else
    {
        _8369 = _8327;
    }
    uint _8371;
    if (_8215)
    {
        _8371 = _8329 + _8369;
    }
    else
    {
        _8371 = _8292;
    }
    vec2 _8372 = unpackHalf2x16(_6766);
    float _8373 = _8372.x;
    vec2 _8374 = unpackHalf2x16(_8220);
    float _8375 = _8374.x;
    precise float _8376 = _8373 + _8375;
    precise float _8377 = _8373 + _8375;
    uint _8382;
    if (_8215)
    {
        _8382 = c0.data[9u];
    }
    else
    {
        _8382 = _8369;
    }
    uint _8384;
    if (_8215)
    {
        _8384 = _42._m0[_8176] + _8382;
    }
    else
    {
        _8384 = _8311;
    }
    vec2 _8385 = unpackHalf2x16(_8231);
    float _8386 = _8385.x;
    precise float _8387 = _6734 + _8386;
    precise float _8388 = _6735 + _8386;
    uint _8393;
    if (_8336)
    {
        _8393 = c0.data[9u];
    }
    else
    {
        _8393 = _8382;
    }
    uint _8395;
    if (_8336)
    {
        _8395 = _42._m0[_8176] + _8393;
    }
    else
    {
        _8395 = _6737;
    }
    if (_8215)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_8371, _8384)), uintBitsToFloat(uvec4(_8356, _8358, _8360, _8346)));
    }
    bool _8402 = (_8221 < _8149) && (!_8174);
    bool _8405 = (_8361 < _8149) && (!_8174);
    uint _8408;
    if (_8402)
    {
        _8408 = c0.data[9u];
    }
    else
    {
        _8408 = _8393;
    }
    uint _8410;
    if (_8402)
    {
        _8410 = _42._m0[_8176] + _8408;
    }
    else
    {
        _8410 = packHalf2x16(vec2(_8295, _8296));
    }
    uint _8411;
    if (_8402)
    {
        _8411 = 1065353216u;
    }
    else
    {
        _8411 = _8304;
    }
    uint _8414;
    if (_8402)
    {
        _8414 = c0.data[8u];
    }
    else
    {
        _8414 = _8408;
    }
    uint _8416;
    if (_8402)
    {
        _8416 = _5454 + _8414;
    }
    else
    {
        _8416 = _6812;
    }
    uint _8418;
    if (_8402)
    {
        _8418 = floatBitsToUint(_8376);
    }
    else
    {
        _8418 = packHalf2x16(vec2(_8376, _8377));
    }
    uint _8420;
    if (_8405)
    {
        _8420 = floatBitsToUint(_8387);
    }
    else
    {
        _8420 = _8244;
    }
    vec2 _8421 = unpackHalf2x16(_8196);
    float _8422 = _8421.x;
    precise float _8423 = _6648 + _8422;
    precise float _8424 = _6649 + _8422;
    uint _8427;
    if (_8336)
    {
        _8427 = 1065353216u;
    }
    else
    {
        _8427 = _8346;
    }
    vec2 _8428 = unpackHalf2x16(_6720);
    float _8429 = _8428.x;
    vec2 _8430 = unpackHalf2x16(_8196);
    float _8431 = _8430.x;
    precise float _8432 = _8429 + _8431;
    precise float _8433 = _8429 + _8431;
    uint _8438 = _5121 + c0.data[8u];
    uint _8443 = uint(_36._m0[uint(int(_6968 + 400u) >> int(1u))]);
    vec2 _8444 = unpackHalf2x16(_8220);
    float _8445 = _8444.x;
    precise float _8446 = _6688 + _8445;
    precise float _8447 = _6689 + _8445;
    uint _8462 = (bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.x, int(16u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u)));
    uint _8464 = (_8462 << 16u) + ((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * bitfieldExtract(c0.data[22u], int(0u), int(16u))) + _8312);
    uint _8467;
    if (_8405)
    {
        _8467 = c0.data[9u];
    }
    else
    {
        _8467 = _8462;
    }
    uint _8469;
    if (_8405)
    {
        _8469 = _42._m0[_8176] + _8467;
    }
    else
    {
        _8469 = _6720;
    }
    uint _8471;
    if (_8336)
    {
        _8471 = floatBitsToUint(_8423);
    }
    else
    {
        _8471 = _8356;
    }
    uint _8476 = uint(_36._m0[uint(int(_6968 + 432u) >> int(1u))]);
    uint _8478;
    if (_8336)
    {
        _8478 = floatBitsToUint(_8424);
    }
    else
    {
        _8478 = packHalf2x16(vec2(_8423, _8424));
    }
    uint _8481;
    if (_8336)
    {
        _8481 = c0.data[8u];
    }
    else
    {
        _8481 = _8467;
    }
    uint _8483;
    if (_8336)
    {
        _8483 = _8464 + _8481;
    }
    else
    {
        _8483 = _6766;
    }
    uint _8485;
    if (_8336)
    {
        _8485 = floatBitsToUint(_8432);
    }
    else
    {
        _8485 = packHalf2x16(vec2(_8432, _8433));
    }
    vec2 _8486 = unpackHalf2x16(_8366);
    float _8487 = _8486.x;
    precise float _8488 = _6872 + _8487;
    precise float _8489 = _6873 + _8487;
    uint _8491;
    if (_8402)
    {
        _8491 = floatBitsToUint(_8446);
    }
    else
    {
        _8491 = _8371;
    }
    precise float _8496 = unpackHalf2x16(_6986).x + unpackHalf2x16(_8366).x;
    uint _8498;
    if (_8402)
    {
        _8498 = floatBitsToUint(_8447);
    }
    else
    {
        _8498 = packHalf2x16(vec2(_8446, _8447));
    }
    if (_8336)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_8483, _8395)), uintBitsToFloat(uvec4(_8471, _8478, _8485, _8427)));
    }
    uint _8515 = (bitfieldExtract(gl_WorkGroupID.y, int(0u), int(16u)) * bitfieldExtract(c0.data[23u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.y, int(16u), int(16u)) * bitfieldExtract(c0.data[23u], int(0u), int(16u)));
    uint _8517 = (_8515 << 16u) + ((bitfieldExtract(gl_WorkGroupID.y, int(0u), int(16u)) * bitfieldExtract(c0.data[23u], int(0u), int(16u))) + _4758);
    bool _8518 = _8312 >= _8149;
    uint _8519;
    if (_8405)
    {
        _8519 = 1065353216u;
    }
    else
    {
        _8519 = _8283;
    }
    if (_8402)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_8416, _8410)), uintBitsToFloat(uvec4(_8491, _8498, _8418, _8411)));
    }
    uint _8525;
    if (_8405)
    {
        _8525 = floatBitsToUint(_8388);
    }
    else
    {
        _8525 = packHalf2x16(vec2(_8387, _8388));
    }
    bool _8528 = (_4758 < _8167) && (!_8197);
    uint _8530;
    if (_8405)
    {
        _8530 = floatBitsToUint(_8351);
    }
    else
    {
        _8530 = packHalf2x16(vec2(_8351, _8352));
    }
    uint _8531 = uint(int(_642) >> int(2u));
    if (_8405)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_8438, _8469)), uintBitsToFloat(uvec4(_8420, _8525, _8530, _8519)));
    }
    bool _8538 = _8221 >= _8149;
    uint _8539;
    if (_8234)
    {
        _8539 = 1065353216u;
    }
    else
    {
        _8539 = _8427;
    }
    uint _8541;
    if (_8234)
    {
        _8541 = floatBitsToUint(_8339);
    }
    else
    {
        _8541 = _8471;
    }
    uint _8544;
    if (_8234)
    {
        _8544 = c0.data[8u];
    }
    else
    {
        _8544 = _8515;
    }
    uint _8546;
    if (_8234)
    {
        _8546 = _8164 + _8544;
    }
    else
    {
        _8546 = _8491;
    }
    uint _8548;
    if (_8234)
    {
        _8548 = floatBitsToUint(_8340);
    }
    else
    {
        _8548 = _8478;
    }
    uint _8551;
    if (_8234)
    {
        _8551 = c0.data[9u];
    }
    else
    {
        _8551 = _8544;
    }
    uint _8553;
    if (_8234)
    {
        _8553 = _8517 + _8551;
    }
    else
    {
        _8553 = _8498;
    }
    uint _8555;
    if (_8234)
    {
        _8555 = floatBitsToUint(_8345);
    }
    else
    {
        _8555 = _8485;
    }
    vec2 _8556 = unpackHalf2x16(_8443);
    float _8557 = _8556.x;
    precise float _8558 = _6826 + _8557;
    precise float _8559 = _6827 + _8557;
    precise float _8564 = unpackHalf2x16(_6904).x + unpackHalf2x16(_8443).x;
    if (_8234)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_8546, _8553)), uintBitsToFloat(uvec4(_8541, _8548, _8555, _8539)));
    }
    bool _8571 = (_4758 < _8167) && (!_8303);
    uint _8576 = uint(_36._m0[uint(int(_6968 + 448u) >> int(1u))]);
    vec2 _8577 = unpackHalf2x16(_8476);
    float _8578 = _8577.x;
    precise float _8579 = _6924 + _8578;
    precise float _8580 = _6925 + _8578;
    precise float _8585 = unpackHalf2x16(_7029).x + unpackHalf2x16(_8476).x;
    bool _8588 = (_42._m0[_8531] < _8167) && (!_8173);
    bool _8591 = (_42._m0[_8531] < _8167) && (!_8197);
    uint _8592;
    if (_8528)
    {
        _8592 = 1065353216u;
    }
    else
    {
        _8592 = _8539;
    }
    uint _8595;
    if (_8528)
    {
        _8595 = c0.data[8u];
    }
    else
    {
        _8595 = _8551;
    }
    uint _8597;
    if (_8528)
    {
        _8597 = _8212 + _8595;
    }
    else
    {
        _8597 = _8546;
    }
    uint _8599;
    if (_8528)
    {
        _8599 = floatBitsToUint(_8558);
    }
    else
    {
        _8599 = _8541;
    }
    uint _8602;
    if (_8528)
    {
        _8602 = c0.data[9u];
    }
    else
    {
        _8602 = _8595;
    }
    uint _8604;
    if (_8528)
    {
        _8604 = _8517 + _8602;
    }
    else
    {
        _8604 = _8553;
    }
    uint _8606;
    if (_8528)
    {
        _8606 = floatBitsToUint(_8559);
    }
    else
    {
        _8606 = _8548;
    }
    bool _8609 = (_42._m0[_8531] < _8167) && (!_8303);
    uint _8611;
    if (_8528)
    {
        _8611 = floatBitsToUint(_8564);
    }
    else
    {
        _8611 = _8555;
    }
    if (_8528)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_8597, _8604)), uintBitsToFloat(uvec4(_8599, _8606, _8611, _8592)));
    }
    bool _8618 = (_4758 < _8167) && (!_8518);
    bool _8621 = (_42._m0[_8531] < _8167) && (!_8518);
    vec2 _8622 = unpackHalf2x16(_8576);
    float _8623 = _8622.x;
    precise float _8624 = _6997 + _8623;
    precise float _8625 = _6998 + _8623;
    uint _8628;
    if (_8618)
    {
        _8628 = c0.data[9u];
    }
    else
    {
        _8628 = _8602;
    }
    uint _8630;
    if (_8618)
    {
        _8630 = _8517 + _8628;
    }
    else
    {
        _8630 = _8411;
    }
    precise float _8635 = unpackHalf2x16(_7073).x + unpackHalf2x16(_8576).x;
    uint _8638;
    if (_8618)
    {
        _8638 = c0.data[8u];
    }
    else
    {
        _8638 = _8628;
    }
    uint _8640;
    if (_8618)
    {
        _8640 = _8464 + _8638;
    }
    else
    {
        _8640 = _8418;
    }
    uint _8645 = uint(_36._m0[uint(int(_6968 + 800u) >> int(1u))]);
    uint _8648;
    if (_8621)
    {
        _8648 = c0.data[8u];
    }
    else
    {
        _8648 = _8638;
    }
    uint _8650;
    if (_8621)
    {
        _8650 = _8464 + _8648;
    }
    else
    {
        _8650 = _8464;
    }
    uint _8653;
    if (_8571)
    {
        _8653 = c0.data[8u];
    }
    else
    {
        _8653 = _8648;
    }
    uint _8655;
    if (_8571)
    {
        _8655 = _8329 + _8653;
    }
    else
    {
        _8655 = _8597;
    }
    uint _8656;
    if (_8571)
    {
        _8656 = 1065353216u;
    }
    else
    {
        _8656 = _8592;
    }
    uint _8659;
    if (_8571)
    {
        _8659 = c0.data[9u];
    }
    else
    {
        _8659 = _8653;
    }
    uint _8661;
    if (_8571)
    {
        _8661 = _8517 + _8659;
    }
    else
    {
        _8661 = _8604;
    }
    uint _8663;
    if (_8571)
    {
        _8663 = floatBitsToUint(_8488);
    }
    else
    {
        _8663 = _8599;
    }
    uint _8665;
    if (_8571)
    {
        _8665 = floatBitsToUint(_8489);
    }
    else
    {
        _8665 = _8606;
    }
    uint _8667;
    if (_8571)
    {
        _8667 = floatBitsToUint(_8496);
    }
    else
    {
        _8667 = _8611;
    }
    if (_8571)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_8655, _8661)), uintBitsToFloat(uvec4(_8663, _8665, _8667, _8656)));
    }
    bool _8674 = (_4758 < _8167) && (!_8538);
    bool _8677 = (_42._m0[_8531] < _8167) && (!_8538);
    uint _8680;
    if (_8674)
    {
        _8680 = c0.data[8u];
    }
    else
    {
        _8680 = _8659;
    }
    uint _8682;
    if (_8674)
    {
        _8682 = _5454 + _8680;
    }
    else
    {
        _8682 = _8530;
    }
    uint _8685;
    if (_8674)
    {
        _8685 = c0.data[9u];
    }
    else
    {
        _8685 = _8680;
    }
    uint _8687;
    if (_8674)
    {
        _8687 = _8517 + _8685;
    }
    else
    {
        _8687 = _8519;
    }
    uint _8690;
    if (_8677)
    {
        _8690 = c0.data[8u];
    }
    else
    {
        _8690 = _8685;
    }
    uint _8692;
    if (_8677)
    {
        _8692 = _5454 + _8690;
    }
    else
    {
        _8692 = _5454;
    }
    uint _8697 = uint(_36._m0[uint(int(_6968 + 768u) >> int(1u))]);
    uint _8698;
    if (_8618)
    {
        _8698 = 1065353216u;
    }
    else
    {
        _8698 = _8656;
    }
    uint _8700;
    if (_8618)
    {
        _8700 = floatBitsToUint(_8579);
    }
    else
    {
        _8700 = _8663;
    }
    uint _8705 = uint(_36._m0[uint(int(_6968 + 464u) >> int(1u))]);
    uint _8707;
    if (_8618)
    {
        _8707 = floatBitsToUint(_8580);
    }
    else
    {
        _8707 = _8665;
    }
    vec2 _8708 = unpackHalf2x16(_8645);
    float _8709 = _8708.x;
    precise float _8710 = _7194 + _8709;
    precise float _8711 = _7195 + _8709;
    uint _8713;
    if (_8618)
    {
        _8713 = floatBitsToUint(_8585);
    }
    else
    {
        _8713 = _8667;
    }
    uint _8718 = uint(_36._m0[uint(int(_6968 + 832u) >> int(1u))]);
    precise float _8723 = unpackHalf2x16(_7308).x + unpackHalf2x16(_8645).x;
    if (_8618)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_8640, _8630)), uintBitsToFloat(uvec4(_8700, _8707, _8713, _8698)));
    }
    bool _8728 = _8361 >= _8149;
    uint _8733 = uint(_36._m0[uint(int(_6968 + 784u) >> int(1u))]);
    uint _8735;
    if (_8674)
    {
        _8735 = floatBitsToUint(_8624);
    }
    else
    {
        _8735 = _8700;
    }
    uint _8737;
    if (_8674)
    {
        _8737 = floatBitsToUint(_8625);
    }
    else
    {
        _8737 = _8707;
    }
    uint _8742 = uint(_36._m0[uint(int(_6968 + 816u) >> int(1u))]);
    uint _8743;
    if (_8674)
    {
        _8743 = 1065353216u;
    }
    else
    {
        _8743 = _8698;
    }
    uint _8745;
    if (_8674)
    {
        _8745 = floatBitsToUint(_8635);
    }
    else
    {
        _8745 = _8713;
    }
    vec2 _8746 = unpackHalf2x16(_8697);
    float _8747 = _8746.x;
    precise float _8748 = _7084 + _8747;
    precise float _8749 = _7085 + _8747;
    uint _8756 = uint(_36._m0[uint(int(_6968 + 848u) >> int(1u))]);
    if (_8674)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_8682, _8687)), uintBitsToFloat(uvec4(_8735, _8737, _8745, _8743)));
    }
    bool _8763 = (_4758 < _8167) && (!_8728);
    vec2 _8764 = unpackHalf2x16(_7200);
    float _8765 = _8764.x;
    vec2 _8766 = unpackHalf2x16(_8697);
    float _8767 = _8766.x;
    precise float _8768 = _8765 + _8767;
    precise float _8769 = _8765 + _8767;
    vec2 _8787 = unpackHalf2x16(_8705);
    float _8788 = _8787.x;
    precise float _8789 = _7037 + _8788;
    precise float _8790 = _7038 + _8788;
    uint _8792;
    if (_8588)
    {
        _8792 = floatBitsToUint(_8748);
    }
    else
    {
        _8792 = _8697;
    }
    vec2 _8793 = unpackHalf2x16(_7123);
    float _8794 = _8793.x;
    vec2 _8795 = unpackHalf2x16(_8705);
    float _8796 = _8795.x;
    precise float _8797 = _8794 + _8796;
    precise float _8798 = _8794 + _8796;
    vec2 _8804 = unpackHalf2x16(_8718);
    float _8805 = _8804.x;
    precise float _8806 = _7332 + _8805;
    precise float _8807 = _7333 + _8805;
    uint _8810 = ((((bitfieldExtract(gl_WorkGroupID.y, int(0u), int(16u)) * bitfieldExtract(c0.data[23u], int(16u), int(16u))) + (bitfieldExtract(gl_WorkGroupID.y, int(16u), int(16u)) * bitfieldExtract(c0.data[23u], int(0u), int(16u)))) << 16u) + ((bitfieldExtract(gl_WorkGroupID.y, int(0u), int(16u)) * bitfieldExtract(c0.data[23u], int(0u), int(16u))) + _42._m0[_8531])) + c0.data[9u];
    precise float _8815 = unpackHalf2x16(_7442).x + unpackHalf2x16(_8718).x;
    uint _8818;
    if (_8609)
    {
        _8818 = c0.data[8u];
    }
    else
    {
        _8818 = c0.data[9u];
    }
    uint _8820;
    if (_8609)
    {
        _8820 = _8329 + _8818;
    }
    else
    {
        _8820 = _6968;
    }
    uint _8823;
    if (_8763)
    {
        _8823 = c0.data[9u];
    }
    else
    {
        _8823 = _8818;
    }
    uint _8825;
    if (_8763)
    {
        _8825 = _8517 + _8823;
    }
    else
    {
        _8825 = _8469;
    }
    uint _8827;
    if (_8763)
    {
        _8827 = floatBitsToUint(_8797);
    }
    else
    {
        _8827 = _8745;
    }
    uint _8829;
    if (_8588)
    {
        _8829 = floatBitsToUint(_8749);
    }
    else
    {
        _8829 = packHalf2x16(vec2(_8797, _8798));
    }
    uint _8830;
    if (_8763)
    {
        _8830 = 1065353216u;
    }
    else
    {
        _8830 = _8743;
    }
    uint _8832;
    if (_8763)
    {
        _8832 = floatBitsToUint(_8789);
    }
    else
    {
        _8832 = _8735;
    }
    vec2 _8833 = unpackHalf2x16(_8733);
    float _8834 = _8833.x;
    precise float _8835 = _7144 + _8834;
    precise float _8836 = _7145 + _8834;
    uint _8840;
    if (_8763)
    {
        _8840 = floatBitsToUint(_8790);
    }
    else
    {
        _8840 = _8737;
    }
    vec2 _8841 = unpackHalf2x16(_7233);
    float _8842 = _8841.x;
    vec2 _8843 = unpackHalf2x16(_8733);
    float _8844 = _8843.x;
    precise float _8845 = _8842 + _8844;
    precise float _8846 = _8842 + _8844;
    uint _8850;
    if (_8588)
    {
        _8850 = floatBitsToUint(_8768);
    }
    else
    {
        _8850 = packHalf2x16(vec2(_8748, _8749));
    }
    uint _8853;
    if (_8588)
    {
        _8853 = c0.data[8u];
    }
    else
    {
        _8853 = _8823;
    }
    uint _8855;
    if (_8588)
    {
        _8855 = _8164 + _8853;
    }
    else
    {
        _8855 = _7233;
    }
    uint _8856;
    if (_8588)
    {
        _8856 = 1065353216u;
    }
    else
    {
        _8856 = _8733;
    }
    uint _8859;
    if (_8591)
    {
        _8859 = c0.data[8u];
    }
    else
    {
        _8859 = _8853;
    }
    uint _8861;
    if (_8591)
    {
        _8861 = _8212 + _8859;
    }
    else
    {
        _8861 = _7147;
    }
    uint _8863;
    if (_8591)
    {
        _8863 = floatBitsToUint(_8835);
    }
    else
    {
        _8863 = packHalf2x16(vec2(_8768, _8769));
    }
    vec2 _8864 = unpackHalf2x16(_8742);
    float _8865 = _8864.x;
    precise float _8866 = _7276 + _8865;
    precise float _8867 = _7277 + _8865;
    uint _8868;
    if (_8591)
    {
        _8868 = 1065353216u;
    }
    else
    {
        _8868 = _8687;
    }
    precise float _8873 = unpackHalf2x16(_7369).x + unpackHalf2x16(_8742).x;
    uint _8875;
    if (_8591)
    {
        _8875 = floatBitsToUint(_8836);
    }
    else
    {
        _8875 = packHalf2x16(vec2(_8835, _8836));
    }
    if (_8763)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_8438, _8825)), uintBitsToFloat(uvec4(_8832, _8840, _8827, _8830)));
    }
    uint _8881;
    if (_8591)
    {
        _8881 = floatBitsToUint(_8845);
    }
    else
    {
        _8881 = packHalf2x16(vec2(_8845, _8846));
    }
    if (_8588)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_8855, _8810)), uintBitsToFloat(uvec4(_8792, _8829, _8850, _8856)));
    }
    vec2 _8886 = unpackHalf2x16(_8756);
    float _8887 = _8886.x;
    precise float _8888 = _7391 + _8887;
    precise float _8889 = _7392 + _8887;
    if (_8591)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_8861, _8810)), uintBitsToFloat(uvec4(_8863, _8875, _8881, _8868)));
    }
    precise float _8896 = _7398 + unpackHalf2x16(_8756).x;
    uint _8897;
    if (_8677)
    {
        _8897 = 1065353216u;
    }
    else
    {
        _8897 = _8830;
    }
    uint _8898;
    if (_8609)
    {
        _8898 = 1065353216u;
    }
    else
    {
        _8898 = _8856;
    }
    uint _8900;
    if (_8609)
    {
        _8900 = floatBitsToUint(_8710);
    }
    else
    {
        _8900 = _8792;
    }
    uint _8902;
    if (_8609)
    {
        _8902 = floatBitsToUint(_8711);
    }
    else
    {
        _8902 = _8829;
    }
    uint _8904;
    if (_8609)
    {
        _8904 = floatBitsToUint(_8723);
    }
    else
    {
        _8904 = _8850;
    }
    uint _8905;
    if (_8621)
    {
        _8905 = 1065353216u;
    }
    else
    {
        _8905 = _8868;
    }
    uint _8907;
    if (_8621)
    {
        _8907 = floatBitsToUint(_8866);
    }
    else
    {
        _8907 = _8863;
    }
    if (_8609)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_8820, _8810)), uintBitsToFloat(uvec4(_8900, _8902, _8904, _8898)));
    }
    uint _8913;
    if (_8621)
    {
        _8913 = floatBitsToUint(_8867);
    }
    else
    {
        _8913 = _8875;
    }
    uint _8915;
    if (_8621)
    {
        _8915 = floatBitsToUint(_8873);
    }
    else
    {
        _8915 = _8881;
    }
    uint _8917;
    if (_8677)
    {
        _8917 = floatBitsToUint(_8806);
    }
    else
    {
        _8917 = _8832;
    }
    uint _8919;
    if (_8677)
    {
        _8919 = floatBitsToUint(_8807);
    }
    else
    {
        _8919 = _8840;
    }
    if (_8621)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_8650, _8810)), uintBitsToFloat(uvec4(_8907, _8913, _8915, _8905)));
    }
    uint _8925;
    if (_8677)
    {
        _8925 = floatBitsToUint(_8815);
    }
    else
    {
        _8925 = _8827;
    }
    if (_8677)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_8692, _8810)), uintBitsToFloat(uvec4(_8917, _8919, _8925, _8897)));
    }
    if (!((_42._m0[_8531] < _8167) && (!_8728)))
    {
        return;
    }
    imageStore(cs_img0_d0, ivec2(uvec2(_8438, _8810)), uintBitsToFloat(uvec4(floatBitsToUint(_8888), floatBitsToUint(_8889), floatBitsToUint(_8896), 1065353216u)));
}

