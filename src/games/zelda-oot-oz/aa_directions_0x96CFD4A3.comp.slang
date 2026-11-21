// Generated from observed original SPIR-V by .dev/port_fov_variant.py.
#version 450
// CUSTOM: Slang integer support replaces the GLSL driver feature guard.
// ORIGINAL: #if defined(GL_ARB_gpu_shader_int64)
// ORIGINAL: #extension GL_ARB_gpu_shader_int64 : require
// ORIGINAL: #else
// ORIGINAL: #error No extension available for 64-bit integers.
// ORIGINAL: #endif
#extension GL_EXT_shader_explicit_arithmetic_types_int64 : require
#extension GL_EXT_scalar_block_layout : require
// CUSTOM: Scalar NMin/NMax intrinsics are implemented by the adapters below.
// ORIGINAL: #extension GL_EXT_spirv_intrinsics : require
layout(local_size_x = 96, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, scalar) uniform cs_cbuf_block_5u
{
    uint data[16384];
} c0;

layout(set = 0, binding = 0, scalar) uniform cs_cbuf_block_5f
{
    float data[16384];
} c0_1;

layout(set = 0, binding = 0, scalar) uniform c0_2
{
    uvec2 data[8192];
} c0_3;

layout(set = 0, binding = 1, std430) buffer ssbo0
{
    uint _m0[];
} ssbo0_1;

layout(set = 0, binding = 2, std430) buffer ssbo1
{
    uint _m0[];
} ssbo1_1;

layout(set = 0, binding = 3) uniform usampler2D cs_tex0_1f0;
layout(set = 0, binding = 4) uniform sampler2D cs_tex0_200;
layout(set = 0, binding = 5, r32ui) uniform uimage2D cs_img0_210;


// CUSTOM: Native new direction body, sharing only AA-off control and integer adapters.
#include "./aa_controls.slangi"
#include "./aa_integer_compat.slangi"
// CUSTOM COMPAT BEGIN: Every CustomNumericMin/Max call below replaces the
// corresponding spvNMin/Max call; all original operands and nesting are retained.
// ORIGINAL: spirv_instruction(set = "GLSL.std.450", id = 79) float spvNMin(float, float);
// ORIGINAL: spirv_instruction(set = "GLSL.std.450", id = 79) vec2 spvNMin(vec2, vec2);
// ORIGINAL: spirv_instruction(set = "GLSL.std.450", id = 79) vec3 spvNMin(vec3, vec3);
// ORIGINAL: spirv_instruction(set = "GLSL.std.450", id = 79) vec4 spvNMin(vec4, vec4);
// ORIGINAL: spirv_instruction(set = "GLSL.std.450", id = 80) float spvNMax(float, float);
// ORIGINAL: spirv_instruction(set = "GLSL.std.450", id = 80) vec2 spvNMax(vec2, vec2);
// ORIGINAL: spirv_instruction(set = "GLSL.std.450", id = 80) vec3 spvNMax(vec3, vec3);
// ORIGINAL: spirv_instruction(set = "GLSL.std.450", id = 80) vec4 spvNMax(vec4, vec4);
// Only scalar overloads are used by this shader. Select the numeric NaN operand.
float CustomNumericMin(float a, float b) {
    return isnan(a) ? b : (isnan(b) ? a : min(a, b));
}
float CustomNumericMax(float a, float b) {
    return isnan(a) ? b : (isnan(b) ? a : max(a, b));
}
void main()
{
    // CUSTOM: This metadata-only pass is unnecessary when filtering is disabled.
    if (custom_aa.aa_strength == 0.f) return;
    uint _931 = ((bitfieldExtract(gl_WorkGroupID.x, int(16u), int(16u)) * 96u) << 16u) + ((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * 96u) + gl_LocalInvocationID.x);
    if (_931 >= ssbo0_1._m0[(c0_3.data[38u].x - (c0.data[76u] & 4294967280u)) >> 2u])
    {
        return;
    }
    uint _943 = (((_931 << 2u) + c0.data[112u]) - (c0.data[112u] & 4294967280u)) >> 2u;
    uint _945 = ssbo1_1._m0[_943];
    uint _947 = _945 & 65535u;
    uint _949 = _945 >> 18u;
    uint _950 = _947 >> 2u;
    vec4 _955 = uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_950, _949)), int(0u)));
    uint _957 = floatBitsToUint(_955.x);
    uint _959 = floatBitsToUint(_955.y);
    uint _960 = _945 >> 16u;
    uint _963 = 3u & (~_945);
    uint _965 = 3u & (~_960);
    uint _966 = _945 & 3u;
    uint _967 = _960 & 3u;
    uint _975 = ((bitfieldExtract(_965, int(16u), int(16u)) * 4u) << 16u) + ((bitfieldExtract(_965, int(0u), int(16u)) * 4u) + _963);
    uint _978 = 1u << (_975 & 31u);
    bool _980 = (_959 & _978) != 0u;
    uint _982;
    if (!_980)
    {
        _982 = 0u;
    }
    else
    {
        _982 = gl_LocalInvocationID.x;
    }
    uint _984;
    if (!_980)
    {
        _984 = 0u;
    }
    else
    {
        _984 = 0u;
    }
    uint _2191;
    bool _2192;
    uint _2193;
    uint _2194;
    uint _2195;
    uint _2196;
    uint _2197;
    uint _2198;
    uint _2199;
    uint _2200;
    uint _2201;
    uint _2202;
    uint _2203;
    bool _2204;
    uint _2205;
    uint _2206;
    uint _2207;
    if (_980)
    {
        uint _985 = _966 + _967;
        bool _987 = (_957 & _978) != 0u;
        uint _990 = (0u << 16u) + 19169280u;
        uint _992 = _985 << 2u;
        uint _994 = (0u << 16u) + 19169280u;
        uint _1003 = (((_985 + 4u) << 2u) | (~28u)) & 28u;
        uint _1005;
        if (!_987)
        {
            _1005 = 1u;
        }
        else
        {
            _1005 = 0u;
        }
        uint _1006 = ((_992 < 32u) ? (_990 >> _992) : 0u) & 65535u;
        uint _1009 = (_1003 < 32u) ? (_994 >> _1003) : 0u;
        uint _1010 = uint(bitCount(_1006));
        uint _1011 = _1009 & 65535u;
        uint _1013;
        if (!_987)
        {
            _1013 = 0u;
        }
        else
        {
            _1013 = _1009;
        }
        uint _1014 = uint(bitCount(_1011));
        uint _1173;
        uint _1174;
        uint _1175;
        uint _1176;
        uint _1177;
        if (_987)
        {
            uint _1016 = (-_975) + 16u;
            uint _1021 = (_1016 < 32u) ? (((0u << 16u) + 65535u) >> _1016) : 0u;
            uint _1022 = _1006 & _1021;
            bool _1023 = _1022 != 0u;
            uint _1025;
            if (!_1023)
            {
                _1025 = 0u;
            }
            else
            {
                _1025 = _1016;
            }
            uint _1032;
            uint _1033;
            uint _1034;
            bool _1035;
            if (_1023)
            {
                uint _1028 = _1022 & (_957 & _959);
                bool _1029 = _1028 != _1022;
                uint _1030;
                if (_1029)
                {
                    _1030 = 0u;
                }
                else
                {
                    _1030 = _1025;
                }
                uint _1031;
                if (_1029)
                {
                    _1031 = _959;
                }
                else
                {
                    _1031 = _990;
                }
                _1032 = _1031;
                _1033 = _1028;
                _1034 = _1030;
                _1035 = _1029;
            }
            else
            {
                _1032 = _990;
                _1033 = _994;
                _1034 = _1025;
                _1035 = _1023;
            }
            uint _1130;
            uint _1131;
            uint _1132;
            uint _1133;
            uint _1134;
            uint _1135;
            if ((!_1023) || (!_1035))
            {
                uint _1039;
                if (_1023)
                {
                    _1039 = uint(bitCount(_1022));
                }
                else
                {
                    _1039 = _1034;
                }
                bool _1040 = _985 >= 4u;
                uint _1042 = _1040 ? 0u : 4294967295u;
                uint _1043 = uint(_1040);
                uint _1045 = _949 + _1043;
                vec4 _1050 = uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_950 + _1042, _1045)), int(0u)));
                uint _1054 = floatBitsToUint(_1050.y);
                uint _1056 = _1011 & (floatBitsToUint(_1050.x) & _1054);
                bool _1057 = _1056 != _1011;
                uint _1058;
                if (_1057)
                {
                    _1058 = _1011;
                }
                else
                {
                    _1058 = _1022;
                }
                uint _1124;
                uint _1125;
                uint _1126;
                uint _1127;
                uint _1128;
                uint _1129;
                if (!_1057)
                {
                    uint _1060 = _950 + 4294967295u;
                    uint _1061 = _949 + 1u;
                    vec4 _1066 = uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_1060, _1061)), int(0u)));
                    uint _1070 = floatBitsToUint(_1066.y);
                    uint _1071 = _1014 + _1039;
                    uint _1073 = _1006 & (floatBitsToUint(_1066.x) & _1070);
                    bool _1074 = _1073 != _1006;
                    uint _1075;
                    if (_1074)
                    {
                        _1075 = _1006;
                    }
                    else
                    {
                        _1075 = _1058;
                    }
                    uint _1118;
                    uint _1119;
                    uint _1120;
                    uint _1121;
                    uint _1122;
                    uint _1123;
                    if (!_1074)
                    {
                        uint _1078 = _1043 + _1061;
                        vec4 _1083 = uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_1042 + _1060, _1078)), int(0u)));
                        uint _1087 = floatBitsToUint(_1083.y);
                        uint _1088 = _1010 + _1071;
                        uint _1090 = _1011 & (floatBitsToUint(_1083.x) & _1087);
                        bool _1091 = _1090 != _1011;
                        uint _1112;
                        uint _1113;
                        uint _1114;
                        uint _1115;
                        uint _1116;
                        if (!_1091)
                        {
                            uint _1095 = _949 + 2u;
                            vec4 _1100 = uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_950 + 4294967294u, _1095)), int(0u)));
                            uint _1104 = floatBitsToUint(_1100.y);
                            uint _1105 = _1014 + _1088;
                            uint _1107 = _1006 & (floatBitsToUint(_1100.x) & _1104);
                            uint _1111;
                            if (!(_1107 != _1006))
                            {
                                _1111 = _1010 + _1105;
                            }
                            else
                            {
                                _1111 = _1105;
                            }
                            _1112 = _1104;
                            _1113 = _1095;
                            _1114 = _1111;
                            _1115 = _1006;
                            _1116 = _1107;
                        }
                        else
                        {
                            _1112 = _1087;
                            _1113 = _1043;
                            _1114 = _1088;
                            _1115 = _1075;
                            _1116 = _1090;
                        }
                        uint _1117;
                        if (_1091)
                        {
                            _1117 = _1011;
                        }
                        else
                        {
                            _1117 = _1115;
                        }
                        _1118 = _1078;
                        _1119 = _1112;
                        _1120 = _1113;
                        _1121 = _1114;
                        _1122 = _1117;
                        _1123 = _1116;
                    }
                    else
                    {
                        _1118 = _1061;
                        _1119 = _1070;
                        _1120 = _1043;
                        _1121 = _1071;
                        _1122 = _1075;
                        _1123 = _1073;
                    }
                    _1124 = _1118;
                    _1125 = _1119;
                    _1126 = _1120;
                    _1127 = _1121;
                    _1128 = _1122;
                    _1129 = _1123;
                }
                else
                {
                    _1124 = _1045;
                    _1125 = _1054;
                    _1126 = _1043;
                    _1127 = _1039;
                    _1128 = _1058;
                    _1129 = _1056;
                }
                _1130 = _1124;
                _1131 = _1125;
                _1132 = _1126;
                _1133 = _1127;
                _1134 = _1129;
                _1135 = _1128;
            }
            else
            {
                _1130 = 0u;
                _1131 = _1032;
                _1132 = _1021;
                _1133 = _1034;
                _1134 = _1033;
                _1135 = _1022;
            }
            bool _1136 = _1134 != _1135;
            uint _1138;
            if (!_1136)
            {
                _1138 = 0u;
            }
            else
            {
                _1138 = _1132;
            }
            uint _1148;
            uint _1149;
            uint _1150;
            uint _1151;
            uint _1152;
            if (_1136)
            {
                uint _1143 = 1u << (uint(findMSB(_1134 ^ _1135)) & 31u);
                uint _1144 = -_1143;
                uint _1146 = uint(bitCount(_1134 & _1144));
                _1148 = _1146;
                _1149 = _1144;
                _1150 = 1u;
                _1151 = _1146 + _1133;
                _1152 = _1143;
            }
            else
            {
                _1148 = _1134;
                _1149 = _1135;
                _1150 = 65535u;
                _1151 = _1133;
                _1152 = _1138;
            }
            uint _1156 = min(_1151, 7u);
            bool _1158 = (_1151 > 7u) || ((_1152 & _1131) != 0u);
            uint _1164;
            if (!_1158)
            {
                _1164 = _1156;
            }
            else
            {
                _1164 = _1150;
            }
            uint _1166;
            if (!_1158)
            {
                _1166 = 0u;
            }
            else
            {
                _1166 = 1u;
            }
            uint _1168;
            if (!_1158)
            {
                _1168 = _1166;
            }
            else
            {
                _1168 = _1166;
            }
            uint _1172;
            if (!_1158)
            {
                _1172 = (_1168 << 16u) + _1164;
            }
            else
            {
                _1172 = _1156 + 1u;
            }
            _1173 = _1130;
            _1174 = (_1151 >= 8u) ? 0u : 1u;
            _1175 = _1172;
            _1176 = _1148;
            _1177 = _1149;
        }
        else
        {
            _1173 = 0u;
            _1174 = _1005;
            _1175 = _1013;
            _1176 = _994;
            _1177 = 0u;
        }
        uint _1180 = 65535u << ((_975 + 1u) & 31u);
        uint _1181 = _1006 & _1180;
        bool _1182 = _1181 != 0u;
        uint _1184;
        if (!_1182)
        {
            _1184 = 0u;
        }
        else
        {
            _1184 = 0u;
        }
        uint _1190;
        uint _1191;
        bool _1192;
        if (_1182)
        {
            uint _1187 = _1181 & (_957 & _959);
            bool _1188 = _1187 != _1181;
            uint _1189;
            if (_1188)
            {
                _1189 = 0u;
            }
            else
            {
                _1189 = _1176;
            }
            _1190 = _1189;
            _1191 = _1187;
            _1192 = _1188;
        }
        else
        {
            _1190 = _1176;
            _1191 = 0u;
            _1192 = _1182;
        }
        uint _1285;
        uint _1286;
        uint _1287;
        uint _1288;
        uint _1289;
        uint _1290;
        if ((!_1182) || (!_1192))
        {
            uint _1196;
            if (_1182)
            {
                _1196 = uint(bitCount(_1181));
            }
            else
            {
                _1196 = _1184;
            }
            bool _1197 = _985 > 2u;
            uint _1198 = uint(_1197);
            uint _1199 = _1197 ? 0u : 4294967295u;
            uint _1201 = _949 + _1199;
            vec4 _1206 = uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_950 + _1198, _1201)), int(0u)));
            uint _1208 = floatBitsToUint(_1206.x);
            uint _1210 = floatBitsToUint(_1206.y);
            uint _1212 = _1011 & (_1208 & _1210);
            bool _1213 = _1212 != _1011;
            uint _1214;
            if (_1213)
            {
                _1214 = _1011;
            }
            else
            {
                _1214 = _1210;
            }
            uint _1215;
            if (_1213)
            {
                _1215 = _1196;
            }
            else
            {
                _1215 = _1208;
            }
            uint _1279;
            uint _1280;
            uint _1281;
            uint _1282;
            uint _1283;
            uint _1284;
            if (!_1213)
            {
                uint _1217 = _950 + 1u;
                uint _1218 = _949 + 4294967295u;
                vec4 _1223 = uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_1217, _1218)), int(0u)));
                uint _1227 = floatBitsToUint(_1223.y);
                uint _1229 = _1006 & (floatBitsToUint(_1223.x) & _1227);
                uint _1230 = _1014 + _1196;
                bool _1231 = _1229 != _1006;
                uint _1232;
                if (_1231)
                {
                    _1232 = _1006;
                }
                else
                {
                    _1232 = _1227;
                }
                uint _1274;
                uint _1275;
                uint _1276;
                uint _1277;
                uint _1278;
                if (!_1231)
                {
                    vec4 _1240 = uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_1198 + _1217, _1199 + _1218)), int(0u)));
                    uint _1244 = floatBitsToUint(_1240.y);
                    uint _1245 = _1010 + _1230;
                    uint _1247 = _1011 & (floatBitsToUint(_1240.x) & _1244);
                    bool _1248 = _1247 != _1011;
                    uint _1268;
                    uint _1269;
                    uint _1270;
                    uint _1271;
                    uint _1272;
                    if (!_1248)
                    {
                        uint _1251 = _950 + 2u;
                        vec4 _1256 = uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_1251, _949 + 4294967294u)), int(0u)));
                        uint _1260 = floatBitsToUint(_1256.y);
                        uint _1261 = _1014 + _1245;
                        uint _1263 = _1006 & (floatBitsToUint(_1256.x) & _1260);
                        uint _1267;
                        if (!(_1263 != _1006))
                        {
                            _1267 = _1010 + _1261;
                        }
                        else
                        {
                            _1267 = _1261;
                        }
                        _1268 = _1267;
                        _1269 = _1263;
                        _1270 = _1006;
                        _1271 = _1260;
                        _1272 = _1251;
                    }
                    else
                    {
                        _1268 = _1245;
                        _1269 = _1247;
                        _1270 = _1232;
                        _1271 = _1244;
                        _1272 = _1011;
                    }
                    uint _1273;
                    if (_1248)
                    {
                        _1273 = _1272;
                    }
                    else
                    {
                        _1273 = _1270;
                    }
                    _1274 = _1272;
                    _1275 = _1268;
                    _1276 = _1269;
                    _1277 = _1273;
                    _1278 = _1271;
                }
                else
                {
                    _1274 = _1011;
                    _1275 = _1230;
                    _1276 = _1229;
                    _1277 = _1232;
                    _1278 = _1198;
                }
                _1279 = _1217;
                _1280 = _1274;
                _1281 = _1275;
                _1282 = _1276;
                _1283 = _1277;
                _1284 = _1278;
            }
            else
            {
                _1279 = _1201;
                _1280 = _1011;
                _1281 = _1215;
                _1282 = _1212;
                _1283 = _1214;
                _1284 = _1198;
            }
            _1285 = _1279;
            _1286 = _1280;
            _1287 = _1281;
            _1288 = _1282;
            _1289 = _1283;
            _1290 = _1284;
        }
        else
        {
            _1285 = 0u;
            _1286 = _1011;
            _1287 = _1190;
            _1288 = _1191;
            _1289 = _1181;
            _1290 = _1177;
        }
        uint _1291 = _967 + _963;
        bool _1292 = _1291 >= 4u;
        uint _1293;
        if (_1292)
        {
            _1293 = 0u;
        }
        else
        {
            _1293 = _1286;
        }
        uint _1295;
        if (!_1292)
        {
            _1295 = 1u;
        }
        else
        {
            _1295 = _1290;
        }
        uint _1308;
        if (!_1292)
        {
            _1308 = floatBitsToUint(uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_950, _949) + uvec2(uint(bitfieldExtract(int(_1295), int(0u), int(4u))), uint(bitfieldExtract(int(_1295), int(4u), int(4u))))), int(0u))).x);
        }
        else
        {
            _1308 = _1293;
        }
        bool _1309 = _1288 != _1289;
        uint _1311;
        if (!_1309)
        {
            _1311 = _1287;
        }
        else
        {
            _1311 = _1014;
        }
        uint _1325;
        uint _1326;
        if (_1309)
        {
            uint _1314 = bitfieldReverse(_1288 ^ _1289) >> 0u;
            uint _1315 = uint(findMSB(_1314));
            _1325 = _1314;
            _1326 = uint(bitCount(_1288 & (~(4294967295u << (((_1315 == 4294967295u) ? _1315 : (_1315 ^ 31u)) & 31u))))) + _1287;
        }
        else
        {
            _1325 = _1289;
            _1326 = _1311;
        }
        uint _1327 = min(_1326, 7u);
        uint _1328 = _1327 + _1175;
        bool _1329 = _1328 > 2u;
        uint _1331;
        if (!_1329)
        {
            _1331 = 0u;
        }
        else
        {
            _1331 = _1328;
        }
        uint _1333;
        if (!_1329)
        {
            _1333 = 0u;
        }
        else
        {
            _1333 = _1325;
        }
        uint _1502;
        uint _1503;
        uint _1504;
        uint _1505;
        uint _1506;
        uint _1507;
        uint _1508;
        uint _1509;
        uint _1510;
        uint _1511;
        if (_1329)
        {
            bool _1334 = _1174 != 0u;
            uint _1335 = _960 + _1175;
            bool _1336 = _1326 > 7u;
            uint _1338 = _947 + (-_1175);
            uint _1339 = ~_1175;
            uint _1341 = _960 + (-_1327);
            uint _1342 = ~_1327;
            uint _1344 = (_947 + 1u) + _1327;
            uint _1345 = _947 + _1339;
            uint _1346 = _960 + _1342;
            uint _1348;
            if (!_1334)
            {
                _1348 = 0u;
            }
            else
            {
                _1348 = _1010;
            }
            uint _1350;
            if (_1334)
            {
                _1350 = _1338 >> 2u;
            }
            else
            {
                _1350 = 0u;
            }
            uint _1352;
            if (!_1334)
            {
                _1352 = 0u;
            }
            else
            {
                _1352 = _1326;
            }
            uint _1354;
            if (_1334)
            {
                _1354 = _1335 >> 2u;
            }
            else
            {
                _1354 = 0u;
            }
            uint _1355;
            if (_1336)
            {
                _1355 = 0u;
            }
            else
            {
                _1355 = _1342;
            }
            uint _1356;
            if (_1336)
            {
                _1356 = 0u;
            }
            else
            {
                _1356 = _1339;
            }
            uint _1358;
            if (_1334)
            {
                _1358 = _1335 >> 2u;
            }
            else
            {
                _1358 = 0u;
            }
            uint _1360;
            if (_1334)
            {
                _1360 = _1345 >> 2u;
            }
            else
            {
                _1360 = _1173;
            }
            uint _1368;
            if (_1334)
            {
                _1368 = floatBitsToUint(uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_1350, _1354)), int(0u))).x);
            }
            else
            {
                _1368 = _1348;
            }
            uint _1371;
            if (!_1336)
            {
                _1371 = _1344 >> 2u;
            }
            else
            {
                _1371 = 0u;
            }
            uint _1374;
            if (!_1336)
            {
                _1374 = _1341 >> 2u;
            }
            else
            {
                _1374 = 0u;
            }
            uint _1382;
            if (_1334)
            {
                _1382 = floatBitsToUint(uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_1360, _1358)), int(0u))).y);
            }
            else
            {
                _1382 = _1352;
            }
            uint _1385;
            if (!_1336)
            {
                _1385 = _1344 >> 2u;
            }
            else
            {
                _1385 = 0u;
            }
            uint _1388;
            if (!_1336)
            {
                _1388 = _1346 >> 2u;
            }
            else
            {
                _1388 = 0u;
            }
            uint _1397;
            if (!_1336)
            {
                _1397 = floatBitsToUint(uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_1371, _1374)), int(0u))).y);
            }
            else
            {
                _1397 = _1356;
            }
            uint _1406;
            if (!_1336)
            {
                _1406 = floatBitsToUint(uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_1385, _1388)), int(0u))).x);
            }
            else
            {
                _1406 = _1355;
            }
            uint _1408 = 3u & (~_1335);
            uint _1414 = 3u & (~_1341);
            uint _1423 = 3u & (~_1344);
            uint _1430 = ((bitfieldExtract(_1408, int(16u), int(16u)) * 4u) << 16u) + ((bitfieldExtract(_1408, int(0u), int(16u)) * 4u) + (3u & (~_1338)));
            uint _1432 = 3u & (~_1346);
            uint _1482 = ((unpackUint2x32(packUint2x32(uvec2(_1397, 0u)) >> ((((bitfieldExtract(_1414, int(16u), int(16u)) * 4u) << 16u) + ((bitfieldExtract(_1414, int(0u), int(16u)) * 4u) + _1423)) & 31u)).x << 1u) | (~2u)) & (2u | (unpackUint2x32(packUint2x32(uvec2(_1406, 0u)) >> ((((bitfieldExtract(_1432, int(16u), int(16u)) * 4u) << 16u) + ((bitfieldExtract(_1432, int(0u), int(16u)) * 4u) + _1423)) & 31u)).x & 1u));
            vec4 _1497 = texelFetch(cs_tex0_200, ivec2(uvec2((((((unpackUint2x32(packUint2x32(uvec2(_1382, 0u)) >> ((((bitfieldExtract(_1408, int(16u), int(16u)) * 4u) << 16u) + ((bitfieldExtract(_1408, int(0u), int(16u)) * 4u) + (3u & (~_1345)))) & 31u)).x << 1u) | (~2u)) & (2u | (unpackUint2x32(packUint2x32(uvec2(_1368, 0u)) >> (_1430 & 31u)).x & 1u))) << 4u) + 128u) + _1175, ((bitfieldExtract(_1482, int(16u), int(16u)) * 16u) << 16u) + ((bitfieldExtract(_1482, int(0u), int(16u)) * 16u) + _1327))), int(0u));
            _1502 = _1374;
            _1503 = _1408;
            _1504 = _1360;
            _1505 = floatBitsToUint(_1497.y);
            _1506 = floatBitsToUint(_1497.x);
            _1507 = _1358;
            _1508 = _1423;
            _1509 = _1371;
            _1510 = _1430;
            _1511 = _1350;
        }
        else
        {
            _1502 = 0u;
            _1503 = 0u;
            _1504 = _1173;
            _1505 = _1333;
            _1506 = _1331;
            _1507 = 0u;
            _1508 = _1174;
            _1509 = 0u;
            _1510 = _1285;
            _1511 = 0u;
        }
        uint _1512 = _1291 << 2u;
        uint _1520 = (_1512 < 32u) ? (((0u << 16u) + 138547200u) >> _1512) : 0u;
        uint _1522 = _1520 & 65535u;
        uint _1524 = _1522 & _1180;
        bool _1525 = _1524 != 0u;
        uint _1530 = (((_1291 + 4u) << 2u) | (~28u)) & 28u;
        uint _1535 = (_1530 < 32u) ? (((0u << 16u) + 138547200u) >> _1530) : 0u;
        uint _1536 = _1308 >> 3u;
        uint _1538;
        if (!_1525)
        {
            _1538 = 0u;
        }
        else
        {
            _1538 = _1510;
        }
        uint _1541 = ((_957 << 1u) & 61166u) | (4369u & _1536);
        uint _1542 = _1535 & 65535u;
        uint _1544 = (-uint(bitCount(_1522))) + 4u;
        uint _1550;
        uint _1551;
        bool _1552;
        if (_1525)
        {
            uint _1547 = _1524 & (_1541 & _959);
            bool _1548 = _1547 != _1524;
            uint _1549;
            if (_1548)
            {
                _1549 = 0u;
            }
            else
            {
                _1549 = _1508;
            }
            _1550 = _1549;
            _1551 = _1547;
            _1552 = _1548;
        }
        else
        {
            _1550 = _1508;
            _1551 = _1509;
            _1552 = _1525;
        }
        uint _1730;
        uint _1731;
        uint _1732;
        uint _1733;
        uint _1734;
        uint _1735;
        uint _1736;
        uint _1737;
        uint _1738;
        uint _1739;
        if ((!_1525) || (!_1552))
        {
            uint _1556;
            if (_1525)
            {
                _1556 = uint(bitCount(_1524));
            }
            else
            {
                _1556 = _1538;
            }
            bool _1557 = _1291 > 2u;
            uint _1559;
            if (!_1292)
            {
                _1559 = 0u;
            }
            else
            {
                _1559 = _1511;
            }
            uint _1560;
            if (_1292)
            {
                _1560 = 1u;
            }
            else
            {
                _1560 = _1291;
            }
            uint _1561 = _1557 ? 4294967295u : 0u;
            uint _1562 = _1557 ? 0u : 4294967295u;
            uint _1563 = _950 + _1561;
            uint _1564 = _949 + _1562;
            vec4 _1569 = uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_1563, _1564)), int(0u)));
            uint _1573 = floatBitsToUint(_1569.y);
            uint _1585;
            if (_1292)
            {
                _1585 = floatBitsToUint(uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_1563, _1564) + uvec2(uint(bitfieldExtract(int(_1560), int(0u), int(4u))), uint(bitfieldExtract(int(_1560), int(4u), int(4u))))), int(0u))).x);
            }
            else
            {
                _1585 = _1559;
            }
            uint _1587 = _1585 >> 3u;
            uint _1590 = ((floatBitsToUint(_1569.x) << 1u) & 61166u) | (4369u & _1587);
            uint _1592 = _1535 & (_1590 & _1573);
            bool _1593 = _1542 != _1592;
            uint _1594;
            if (_1593)
            {
                _1594 = _1542;
            }
            else
            {
                _1594 = _1573;
            }
            uint _1595;
            if (_1593)
            {
                _1595 = _1556;
            }
            else
            {
                _1595 = _1590;
            }
            uint _1721;
            uint _1722;
            uint _1723;
            uint _1724;
            uint _1725;
            uint _1726;
            uint _1727;
            uint _1728;
            uint _1729;
            if (!_1593)
            {
                uint _1597 = _950 + 4294967295u;
                uint _1598;
                if (_1292)
                {
                    _1598 = 0u;
                }
                else
                {
                    _1598 = _1587;
                }
                uint _1599 = _949 + 4294967295u;
                vec4 _1604 = uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_1597, _1599)), int(0u)));
                uint _1608 = floatBitsToUint(_1604.y);
                uint _1621;
                if (!_1292)
                {
                    _1621 = floatBitsToUint(uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_1597, _1599) + uvec2(uint(bitfieldExtract(int(_1295), int(0u), int(4u))), uint(bitfieldExtract(int(_1295), int(4u), int(4u))))), int(0u))).x);
                }
                else
                {
                    _1621 = _1598;
                }
                uint _1623 = _1621 >> 3u;
                uint _1626 = ((floatBitsToUint(_1604.x) << 1u) & 61166u) | (4369u & _1623);
                uint _1628 = _1520 & (_1626 & _1608);
                bool _1629 = _1522 != _1628;
                uint _1631;
                if (_1629)
                {
                    _1631 = _1544 + _1556;
                }
                else
                {
                    _1631 = _1626;
                }
                uint _1632;
                if (_1629)
                {
                    _1632 = _1522;
                }
                else
                {
                    _1632 = _1608;
                }
                uint _1713;
                uint _1714;
                uint _1715;
                uint _1716;
                uint _1717;
                uint _1718;
                uint _1719;
                uint _1720;
                if (!_1629)
                {
                    uint _1634 = _1597 + _1561;
                    uint _1635 = _1599 + _1562;
                    uint _1637;
                    if (!_1292)
                    {
                        _1637 = 0u;
                    }
                    else
                    {
                        _1637 = _1561;
                    }
                    vec4 _1642 = uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_1634, _1635)), int(0u)));
                    uint _1646 = floatBitsToUint(_1642.y);
                    uint _1658;
                    if (_1292)
                    {
                        _1658 = floatBitsToUint(uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_1634, _1635) + uvec2(uint(bitfieldExtract(int(_1560), int(0u), int(4u))), uint(bitfieldExtract(int(_1560), int(4u), int(4u))))), int(0u))).x);
                    }
                    else
                    {
                        _1658 = _1637;
                    }
                    uint _1659 = _1556 + 4u;
                    uint _1661 = _1658 >> 3u;
                    uint _1664 = ((floatBitsToUint(_1642.x) << 1u) & 61166u) | (4369u & _1661);
                    uint _1666 = _1535 & (_1664 & _1646);
                    bool _1667 = _1542 != _1666;
                    uint _1668;
                    if (_1667)
                    {
                        _1668 = _1542;
                    }
                    else
                    {
                        _1668 = _1646;
                    }
                    uint _1669;
                    if (_1667)
                    {
                        _1669 = _1659;
                    }
                    else
                    {
                        _1669 = _1664;
                    }
                    uint _1707;
                    uint _1708;
                    uint _1709;
                    uint _1710;
                    uint _1711;
                    uint _1712;
                    if (!_1667)
                    {
                        uint _1671 = _950 + 4294967294u;
                        uint _1672;
                        if (_1292)
                        {
                            _1672 = 0u;
                        }
                        else
                        {
                            _1672 = _1560;
                        }
                        uint _1673 = _949 + 4294967294u;
                        vec4 _1678 = uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_1671, _1673)), int(0u)));
                        uint _1695;
                        if (!_1292)
                        {
                            _1695 = floatBitsToUint(uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_1671, _1673) + uvec2(uint(bitfieldExtract(int(_1295), int(0u), int(4u))), uint(bitfieldExtract(int(_1295), int(4u), int(4u))))), int(0u))).x);
                        }
                        else
                        {
                            _1695 = _1672;
                        }
                        uint _1697 = _1695 >> 3u;
                        uint _1702 = _1520 & ((((floatBitsToUint(_1678.x) << 1u) & 61166u) | (4369u & _1697)) & floatBitsToUint(_1678.y));
                        uint _1706;
                        if (_1522 != _1702)
                        {
                            _1706 = _1544 + _1659;
                        }
                        else
                        {
                            _1706 = _1556 + 8u;
                        }
                        _1707 = _1673;
                        _1708 = _1671;
                        _1709 = _1697;
                        _1710 = _1706;
                        _1711 = _1702;
                        _1712 = _1522;
                    }
                    else
                    {
                        _1707 = _1635;
                        _1708 = _1634;
                        _1709 = _1560;
                        _1710 = _1669;
                        _1711 = _1666;
                        _1712 = _1668;
                    }
                    _1713 = _1707;
                    _1714 = _1661;
                    _1715 = _1708;
                    _1716 = _1659;
                    _1717 = _1709;
                    _1718 = _1710;
                    _1719 = _1711;
                    _1720 = _1712;
                }
                else
                {
                    _1713 = _1599;
                    _1714 = _1561;
                    _1715 = _1597;
                    _1716 = _1562;
                    _1717 = _1560;
                    _1718 = _1631;
                    _1719 = _1628;
                    _1720 = _1632;
                }
                _1721 = _1623;
                _1722 = _1713;
                _1723 = _1714;
                _1724 = _1715;
                _1725 = _1716;
                _1726 = _1717;
                _1727 = _1718;
                _1728 = _1719;
                _1729 = _1720;
            }
            else
            {
                _1721 = _1587;
                _1722 = _1564;
                _1723 = _1561;
                _1724 = _1563;
                _1725 = _1562;
                _1726 = _1560;
                _1727 = _1595;
                _1728 = _1592;
                _1729 = _1594;
            }
            _1730 = _1721;
            _1731 = _1722;
            _1732 = _1723;
            _1733 = _1724;
            _1734 = _1556;
            _1735 = _1725;
            _1736 = _1726;
            _1737 = _1727;
            _1738 = _1728;
            _1739 = _1729;
        }
        else
        {
            _1730 = _1511;
            _1731 = _1536;
            _1732 = _1504;
            _1733 = _1308;
            _1734 = _1538;
            _1735 = _1507;
            _1736 = _1291;
            _1737 = _1550;
            _1738 = _1551;
            _1739 = _1524;
        }
        bool _1740 = _1738 != _1739;
        bool _1742 = (_1541 & _978) != 0u;
        uint _1744;
        if (!_1740)
        {
            _1744 = _1737;
        }
        else
        {
            _1744 = _1736;
        }
        uint _1758;
        uint _1759;
        uint _1760;
        if (_1740)
        {
            uint _1747 = bitfieldReverse(_1738 ^ _1739) >> 0u;
            uint _1748 = uint(findMSB(_1747));
            uint _1756 = uint(bitCount(_1738 & (~(4294967295u << (((_1748 == 4294967295u) ? _1748 : (_1748 ^ 31u)) & 31u)))));
            _1758 = _1756;
            _1759 = _1747;
            _1760 = _1756 + _1737;
        }
        else
        {
            _1758 = _1731;
            _1759 = _1733;
            _1760 = _1744;
        }
        bool _1761 = _1760 >= 8u;
        uint _1763;
        if (!_1742)
        {
            _1763 = 1u;
        }
        else
        {
            _1763 = _1759;
        }
        uint _1764 = min(_1760, 7u);
        uint _1766;
        if (!_1742)
        {
            _1766 = 0u;
        }
        else
        {
            _1766 = _1737;
        }
        bool _2005;
        uint _2006;
        uint _2007;
        uint _2008;
        uint _2009;
        uint _2010;
        uint _2011;
        uint _2012;
        uint _2013;
        uint _2014;
        uint _2015;
        if (_1742)
        {
            uint _1768 = (-_975) + 16u;
            uint _1774 = _1522 & ((_1768 < 32u) ? (((0u << 16u) + 65535u) >> _1768) : 0u);
            bool _1775 = _1774 != 0u;
            uint _1777;
            if (!_1775)
            {
                _1777 = 0u;
            }
            else
            {
                _1777 = _1734;
            }
            uint _1784;
            uint _1785;
            uint _1786;
            bool _1787;
            if (_1775)
            {
                uint _1780 = _1774 & (_1541 & _959);
                bool _1781 = _1780 != _1774;
                uint _1782;
                if (_1781)
                {
                    _1782 = 0u;
                }
                else
                {
                    _1782 = _1735;
                }
                uint _1783;
                if (_1781)
                {
                    _1783 = _959;
                }
                else
                {
                    _1783 = _1739;
                }
                _1784 = _1783;
                _1785 = _1780;
                _1786 = _1782;
                _1787 = _1781;
            }
            else
            {
                _1784 = _1739;
                _1785 = _1766;
                _1786 = _1735;
                _1787 = _1775;
            }
            uint _1963;
            uint _1964;
            uint _1965;
            uint _1966;
            uint _1967;
            uint _1968;
            uint _1969;
            uint _1970;
            uint _1971;
            if ((!_1775) || (!_1787))
            {
                uint _1791;
                if (_1775)
                {
                    _1791 = uint(bitCount(_1774));
                }
                else
                {
                    _1791 = _1777;
                }
                uint _1792 = _1292 ? 0u : 1u;
                uint _1794;
                if (!_1292)
                {
                    _1794 = 0u;
                }
                else
                {
                    _1794 = _1786;
                }
                uint _1795 = uint(_1292);
                uint _1796;
                if (_1292)
                {
                    _1796 = 1u;
                }
                else
                {
                    _1796 = _1768;
                }
                uint _1797 = _950 + _1792;
                uint _1798 = _949 + _1795;
                vec4 _1803 = uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_1797, _1798)), int(0u)));
                uint _1807 = floatBitsToUint(_1803.y);
                uint _1819;
                if (_1292)
                {
                    _1819 = floatBitsToUint(uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_1797, _1798) + uvec2(uint(bitfieldExtract(int(_1796), int(0u), int(4u))), uint(bitfieldExtract(int(_1796), int(4u), int(4u))))), int(0u))).x);
                }
                else
                {
                    _1819 = _1794;
                }
                uint _1821 = _1819 >> 3u;
                uint _1826 = _1535 & ((((floatBitsToUint(_1803.x) << 1u) & 61166u) | (4369u & _1821)) & _1807);
                bool _1827 = _1542 != _1826;
                uint _1828;
                if (_1827)
                {
                    _1828 = _1542;
                }
                else
                {
                    _1828 = _1821;
                }
                uint _1829;
                if (_1827)
                {
                    _1829 = _1791;
                }
                else
                {
                    _1829 = _1819;
                }
                uint _1955;
                uint _1956;
                uint _1957;
                uint _1958;
                uint _1959;
                uint _1960;
                uint _1961;
                uint _1962;
                if (!_1827)
                {
                    uint _1831 = _950 + 1u;
                    uint _1832;
                    if (_1292)
                    {
                        _1832 = 0u;
                    }
                    else
                    {
                        _1832 = _1829;
                    }
                    uint _1833 = _949 + 1u;
                    vec4 _1838 = uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_1831, _1833)), int(0u)));
                    uint _1842 = floatBitsToUint(_1838.y);
                    uint _1855;
                    if (!_1292)
                    {
                        _1855 = floatBitsToUint(uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_1831, _1833) + uvec2(uint(bitfieldExtract(int(_1295), int(0u), int(4u))), uint(bitfieldExtract(int(_1295), int(4u), int(4u))))), int(0u))).x);
                    }
                    else
                    {
                        _1855 = _1832;
                    }
                    uint _1857 = _1855 >> 3u;
                    uint _1862 = _1520 & ((((floatBitsToUint(_1838.x) << 1u) & 61166u) | (4369u & _1857)) & _1842);
                    bool _1863 = _1522 != _1862;
                    uint _1865;
                    if (_1863)
                    {
                        _1865 = _1544 + _1791;
                    }
                    else
                    {
                        _1865 = _1855;
                    }
                    uint _1866;
                    if (_1863)
                    {
                        _1866 = _1522;
                    }
                    else
                    {
                        _1866 = _1857;
                    }
                    uint _1947;
                    uint _1948;
                    uint _1949;
                    uint _1950;
                    uint _1951;
                    uint _1952;
                    uint _1953;
                    uint _1954;
                    if (!_1863)
                    {
                        uint _1868 = _1831 + _1792;
                        uint _1869 = _1833 + _1795;
                        uint _1871;
                        if (!_1292)
                        {
                            _1871 = 0u;
                        }
                        else
                        {
                            _1871 = _1795;
                        }
                        vec4 _1876 = uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_1868, _1869)), int(0u)));
                        uint _1880 = floatBitsToUint(_1876.y);
                        uint _1892;
                        if (_1292)
                        {
                            _1892 = floatBitsToUint(uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_1868, _1869) + uvec2(uint(bitfieldExtract(int(_1796), int(0u), int(4u))), uint(bitfieldExtract(int(_1796), int(4u), int(4u))))), int(0u))).x);
                        }
                        else
                        {
                            _1892 = _1871;
                        }
                        uint _1893 = _1791 + 4u;
                        uint _1895 = _1892 >> 3u;
                        uint _1900 = _1535 & ((((floatBitsToUint(_1876.x) << 1u) & 61166u) | (4369u & _1895)) & _1880);
                        bool _1901 = _1542 != _1900;
                        uint _1902;
                        if (_1901)
                        {
                            _1902 = _1542;
                        }
                        else
                        {
                            _1902 = _1866;
                        }
                        uint _1941;
                        uint _1942;
                        uint _1943;
                        uint _1944;
                        uint _1945;
                        uint _1946;
                        if (!_1901)
                        {
                            uint _1904 = _950 + 2u;
                            uint _1905;
                            if (_1292)
                            {
                                _1905 = 0u;
                            }
                            else
                            {
                                _1905 = _1542;
                            }
                            uint _1906 = _949 + 2u;
                            vec4 _1911 = uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_1904, _1906)), int(0u)));
                            uint _1915 = floatBitsToUint(_1911.y);
                            uint _1928;
                            if (!_1292)
                            {
                                _1928 = floatBitsToUint(uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_1904, _1906) + uvec2(uint(bitfieldExtract(int(_1295), int(0u), int(4u))), uint(bitfieldExtract(int(_1295), int(4u), int(4u))))), int(0u))).x);
                            }
                            else
                            {
                                _1928 = _1905;
                            }
                            uint _1936 = _1520 & ((((floatBitsToUint(_1911.x) << 1u) & 61166u) | (4369u & (_1928 >> 3u))) & _1915);
                            uint _1940;
                            if (!(_1522 != _1936))
                            {
                                _1940 = _1791 + 8u;
                            }
                            else
                            {
                                _1940 = _1544 + _1893;
                            }
                            _1941 = _1906;
                            _1942 = _1915;
                            _1943 = _1928;
                            _1944 = _1940;
                            _1945 = _1522;
                            _1946 = _1936;
                        }
                        else
                        {
                            _1941 = _1869;
                            _1942 = _1880;
                            _1943 = _1542;
                            _1944 = _1893;
                            _1945 = _1902;
                            _1946 = _1900;
                        }
                        _1947 = _1941;
                        _1948 = _1895;
                        _1949 = _1892;
                        _1950 = _1942;
                        _1951 = _1943;
                        _1952 = _1944;
                        _1953 = _1945;
                        _1954 = _1946;
                    }
                    else
                    {
                        _1947 = _1833;
                        _1948 = _1792;
                        _1949 = _1795;
                        _1950 = _1842;
                        _1951 = _1542;
                        _1952 = _1865;
                        _1953 = _1866;
                        _1954 = _1862;
                    }
                    _1955 = _1947;
                    _1956 = _1948;
                    _1957 = _1949;
                    _1958 = _1950;
                    _1959 = _1951;
                    _1960 = _1952;
                    _1961 = _1953;
                    _1962 = _1954;
                }
                else
                {
                    _1955 = _1798;
                    _1956 = _1792;
                    _1957 = _1795;
                    _1958 = _1807;
                    _1959 = _1542;
                    _1960 = _1829;
                    _1961 = _1828;
                    _1962 = _1826;
                }
                _1963 = _1791;
                _1964 = _1955;
                _1965 = _1956;
                _1966 = _1957;
                _1967 = _1958;
                _1968 = _1959;
                _1969 = _1960;
                _1970 = _1962;
                _1971 = _1961;
            }
            else
            {
                _1963 = _1777;
                _1964 = _1758;
                _1965 = _1732;
                _1966 = _1541;
                _1967 = _1784;
                _1968 = _1542;
                _1969 = _1786;
                _1970 = _1785;
                _1971 = _1774;
            }
            bool _1972 = _1970 != _1971;
            uint _1974;
            if (!_1972)
            {
                _1974 = 0u;
            }
            else
            {
                _1974 = _1968;
            }
            uint _1983;
            uint _1984;
            uint _1985;
            uint _1986;
            if (_1972)
            {
                uint _1976 = uint(findMSB(_1970 ^ _1971));
                uint _1978 = 1u << (_1976 & 31u);
                _1983 = _1976;
                _1984 = 1u;
                _1985 = uint(bitCount(_1970 & (-_1978))) + _1969;
                _1986 = _1978;
            }
            else
            {
                _1983 = _1971;
                _1984 = 65535u;
                _1985 = _1969;
                _1986 = _1974;
            }
            uint _1989 = min(_1985, 7u);
            bool _1991 = (_1985 > 7u) || ((_1986 & _1967) != 0u);
            bool _1992 = _1985 >= 8u;
            uint _1996;
            if (!_1991)
            {
                _1996 = _1989;
            }
            else
            {
                _1996 = _1984;
            }
            uint _1998;
            if (!_1991)
            {
                _1998 = 0u;
            }
            else
            {
                _1998 = 1u;
            }
            uint _2000;
            if (!_1991)
            {
                _2000 = _1998;
            }
            else
            {
                _2000 = _1998;
            }
            uint _2004;
            if (!_1991)
            {
                _2004 = (_2000 << 16u) + _1996;
            }
            else
            {
                _2004 = _1989 + 1u;
            }
            _2005 = _1992;
            _2006 = _1983;
            _2007 = _1967;
            _2008 = _1963;
            _2009 = _1964;
            _2010 = _1986;
            _2011 = _1985;
            _2012 = _1965;
            _2013 = _1966;
            _2014 = _1992 ? 0u : 1u;
            _2015 = _2004;
        }
        else
        {
            _2005 = _1742;
            _2006 = _1730;
            _2007 = _1739;
            _2008 = _1734;
            _2009 = _1758;
            _2010 = _1542;
            _2011 = _1735;
            _2012 = _1732;
            _2013 = _1541;
            _2014 = _1763;
            _2015 = _1766;
        }
        uint _2016 = _1764 + _2015;
        bool _2017 = _2016 > 2u;
        uint _2019;
        if (!_2017)
        {
            _2019 = _1506;
        }
        else
        {
            _2019 = _2016;
        }
        uint _2021;
        if (!_2017)
        {
            _2021 = _1505;
        }
        else
        {
            _2021 = _2010;
        }
        uint _2178;
        uint _2179;
        uint _2180;
        uint _2181;
        uint _2182;
        uint _2183;
        uint _2184;
        uint _2185;
        uint _2186;
        uint _2187;
        uint _2188;
        uint _2189;
        uint _2190;
        if (_2017)
        {
            bool _2022 = _2014 != 0u;
            uint _2024 = _960 + (-_1764);
            uint _2025 = ~_1764;
            uint _2027 = _947 + (-_1764);
            uint _2029 = (_947 + 1u) + _2015;
            uint _2030 = _960 + _2015;
            uint _2033;
            if (!_1761)
            {
                _2033 = _2024 >> 2u;
            }
            else
            {
                _2033 = _1535;
            }
            uint _2034 = _947 + _2025;
            uint _2037;
            if (!_1761)
            {
                _2037 = _2027 >> 2u;
            }
            else
            {
                _2037 = _1295;
            }
            uint _2038 = _960 + _2025;
            uint _2039;
            if (_1761)
            {
                _2039 = 0u;
            }
            else
            {
                _2039 = _2021;
            }
            uint _2042;
            if (!_1761)
            {
                _2042 = _2034 >> 2u;
            }
            else
            {
                _2042 = _2025;
            }
            uint _2043;
            if (_1761)
            {
                _2043 = 0u;
            }
            else
            {
                _2043 = _2019;
            }
            uint _2045;
            if (!_2022)
            {
                _2045 = 0u;
            }
            else
            {
                _2045 = _2014;
            }
            uint _2047;
            if (!_2022)
            {
                _2047 = 0u;
            }
            else
            {
                _2047 = _2009;
            }
            uint _2050;
            if (!_1761)
            {
                _2050 = _2038 >> 2u;
            }
            else
            {
                _2050 = _2013;
            }
            uint _2052;
            if (_2022)
            {
                _2052 = _2029 >> 2u;
            }
            else
            {
                _2052 = _2012;
            }
            uint _2054;
            if (_2022)
            {
                _2054 = _2030 >> 2u;
            }
            else
            {
                _2054 = _2011;
            }
            uint _2063;
            if (!_1761)
            {
                _2063 = floatBitsToUint(uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_2042, _2033)), int(0u))).y);
            }
            else
            {
                _2063 = _2039;
            }
            uint _2072;
            if (!_1761)
            {
                _2072 = floatBitsToUint(uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_2037, _2050)), int(0u))).x);
            }
            else
            {
                _2072 = _2043;
            }
            uint _2082;
            uint _2083;
            if (_2022)
            {
                vec4 _2077 = uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_2052, _2054)), int(0u)));
                _2082 = floatBitsToUint(_2077.x);
                _2083 = floatBitsToUint(_2077.y);
            }
            else
            {
                _2082 = _2045;
                _2083 = _2047;
            }
            uint _2087 = 3u & (~_2030);
            uint _2089 = 3u & (~_2024);
            uint _2102 = 3u & (~_2038);
            uint _2110 = (((bitfieldExtract(_2087, int(16u), int(16u)) * 4u) << 16u) + ((bitfieldExtract(_2087, int(0u), int(16u)) * 4u) + (3u & (~_2029)))) & 31u;
            uint _2117 = ((bitfieldExtract(_2102, int(16u), int(16u)) * 4u) << 16u) + ((bitfieldExtract(_2102, int(0u), int(16u)) * 4u) + (3u & (~_2027)));
            uint _2145 = unpackUint2x32(packUint2x32(uvec2(_2082, 0u)) >> min(_2110, 32u)).x & 1u;
            uint _2153 = ((unpackUint2x32(packUint2x32(uvec2(_2083, 0u)) >> min(_2110, 32u)).x << 1u) | (~2u)) & (2u | _2145);
            vec4 _2167 = texelFetch(cs_tex0_200, ivec2(uvec2(_1764 + (((((unpackUint2x32(packUint2x32(uvec2(_2063, 0u)) >> ((((bitfieldExtract(_2089, int(16u), int(16u)) * 4u) << 16u) + ((bitfieldExtract(_2089, int(0u), int(16u)) * 4u) + (3u & (~_2034)))) & 31u)).x << 1u) | (~2u)) & (2u | (unpackUint2x32(packUint2x32(uvec2(_2072, 0u)) >> (_2117 & 31u)).x & 1u))) << 4u) + 128u), ((bitfieldExtract(_2153, int(16u), int(16u)) * 16u) << 16u) + ((bitfieldExtract(_2153, int(0u), int(16u)) * 16u) + _2015))), int(0u));
            float _2168 = _2167.x;
            float _2170 = _2167.y;
            precise float _2173 = _2170 + uintBitsToFloat(_1506);
            precise float _2176 = _2168 + uintBitsToFloat(_1505);
            _2178 = _2153;
            _2179 = _2037;
            _2180 = _2033;
            _2181 = _2110;
            _2182 = _2087;
            _2183 = _2054;
            _2184 = floatBitsToUint(_2170);
            _2185 = floatBitsToUint(_2168);
            _2186 = _2052;
            _2187 = _2117;
            _2188 = _2145;
            _2189 = floatBitsToUint(_2176);
            _2190 = floatBitsToUint(_2173);
        }
        else
        {
            _2178 = _1522;
            _2179 = _1295;
            _2180 = _1535;
            _2181 = _2006;
            _2182 = _1738;
            _2183 = _2011;
            _2184 = _2007;
            _2185 = _2015;
            _2186 = _2012;
            _2187 = _2008;
            _2188 = _2014;
            _2189 = _2021;
            _2190 = _2019;
        }
        _2191 = _1502;
        _2192 = _2005;
        _2193 = _2178;
        _2194 = _2179;
        _2195 = _2180;
        _2196 = _2181;
        _2197 = _1503;
        _2198 = _2182;
        _2199 = _2183;
        _2200 = _2184;
        _2201 = _2185;
        _2202 = _2186;
        _2203 = _2187;
        _2204 = _1761;
        _2205 = _2188;
        _2206 = _2190;
        _2207 = _2189;
    }
    else
    {
        _2191 = 0u;
        _2192 = false;
        _2193 = 0u;
        _2194 = 0u;
        _2195 = 0u;
        _2196 = 0u;
        _2197 = 0u;
        _2198 = 0u;
        _2199 = 0u;
        _2200 = 0u;
        _2201 = 0u;
        _2202 = 0u;
        _2203 = 0u;
        _2204 = false;
        _2205 = 0u;
        _2206 = _982;
        _2207 = _984;
    }
    bool _2212 = uintBitsToFloat(_2206) != uintBitsToFloat(_2207 ^ 2147483648u);
    uint _2213;
    if (_2212)
    {
        _2213 = 0u;
    }
    else
    {
        _2213 = _2205;
    }
    uint _2214;
    if (_2212)
    {
        _2214 = 0u;
    }
    else
    {
        _2214 = _2193;
    }
    uint _4520;
    uint _4521;
    uint _4522;
    uint _4523;
    uint _4524;
    if (!_2212)
    {
        float _2216 = float(int(_949));
        float _2218 = float(int(_950));
        precise float _2222 = _2216 + 1.0;
        uint _2224;
        if (!_980)
        {
            _2224 = 0u;
        }
        else
        {
            _2224 = floatBitsToUint(_2216);
        }
        precise float _2225 = _2218 + 1.0;
        uint _2227;
        if (!_980)
        {
            _2227 = 0u;
        }
        else
        {
            _2227 = floatBitsToUint(_2218);
        }
        precise float _2231 = _2222 * c0_1.data[9u];
        uint _2232 = floatBitsToUint(_2231);
        precise float _2235 = _2225 * c0_1.data[8u];
        uint _2236 = floatBitsToUint(_2235);
        uint _3341;
        uint _3342;
        uint _3343;
        uint _3344;
        uint _3345;
        uint _3346;
        uint _3347;
        uint _3348;
        uint _3349;
        uint _3350;
        uint _3351;
        uint _3352;
        uint _3353;
        bool _3354;
        if (_980)
        {
            bool _2237 = _967 != 0u;
            uint _2238;
            if (_2237)
            {
                _2238 = 0u;
            }
            else
            {
                _2238 = _2224;
            }
            uint _2240;
            if (!_2237)
            {
                _2240 = 240u;
            }
            else
            {
                _2240 = _2213;
            }
            uint _2253;
            if (!_2237)
            {
                _2253 = floatBitsToUint(uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_950, _949) + uvec2(uint(bitfieldExtract(int(_2240), int(0u), int(4u))), uint(bitfieldExtract(int(_2240), int(4u), int(4u))))), int(0u))).x);
            }
            else
            {
                _2253 = _2238;
            }
            bool _2254 = _966 != 0u;
            uint _2255 = _967 << 2u;
            uint _2259 = (0u << 16u) + 61440u;
            uint _2264 = (_2255 < 32u) ? (_2259 >> _2255) : 0u;
            uint _2266;
            if (!_2254)
            {
                _2266 = 0u;
            }
            else
            {
                _2266 = _2255;
            }
            uint _2268 = _957 | ((_2253 << 12u) | (_957 >> 4u));
            uint _2287;
            uint _2288;
            bool _2289;
            uint _2290;
            uint _2291;
            uint _2292;
            bool _2293;
            if (_2254)
            {
                uint _2273 = (_2268 & _2264) << 1u;
                uvec2 _2278 = unpackUint2x32(packUint2x32(uvec2(0u, _2264)) << min(((-_966) + 4u), 32u));
                uint _2279 = _2278.y;
                uint _2280 = _2264 & _2279;
                uint _2283 = (_2273 | (~_959)) & _2280;
                bool _2284 = _2283 != 0u;
                bool _2285;
                if (_2284)
                {
                    _2285 = true;
                }
                else
                {
                    _2285 = _2254;
                }
                uint _2286;
                if (_2284)
                {
                    _2286 = 0u;
                }
                else
                {
                    _2286 = _2198;
                }
                _2287 = _2286;
                _2288 = _2283;
                _2289 = _2285;
                _2290 = _2273;
                _2291 = _2279;
                _2292 = _2280;
                _2293 = _2284;
            }
            else
            {
                _2287 = _2198;
                _2288 = _2199;
                _2289 = _2254;
                _2290 = _2240;
                _2291 = _2266;
                _2292 = _2203;
                _2293 = _2204;
            }
            uint _2736;
            uint _2737;
            uint _2738;
            uint _2739;
            uint _2740;
            uint _2741;
            uint _2742;
            uint _2743;
            uint _2744;
            bool _2745;
            if ((!_2254) || (!_2293))
            {
                uint _2296;
                if (_2254)
                {
                    _2296 = _966;
                }
                else
                {
                    _2296 = _2291;
                }
                uint _2297;
                if (_2237)
                {
                    _2297 = 0u;
                }
                else
                {
                    _2297 = _2292;
                }
                uint _2298;
                if (_2237)
                {
                    _2298 = 0u;
                }
                else
                {
                    _2298 = _2202;
                }
                uint _2299;
                if (_2237)
                {
                    _2299 = 0u;
                }
                else
                {
                    _2299 = _2290;
                }
                uint _2300;
                if (_2237)
                {
                    _2300 = 0u;
                }
                else
                {
                    _2300 = _2259;
                }
                uint _2302;
                if (!_2237)
                {
                    _2302 = 4294901759u;
                }
                else
                {
                    _2302 = _2201;
                }
                uint _2304;
                if (!_2237)
                {
                    _2304 = 4294770685u;
                }
                else
                {
                    _2304 = _2200;
                }
                uint _2306;
                if (!_2237)
                {
                    _2306 = _2236;
                }
                else
                {
                    _2306 = 61440u;
                }
                uint _2308;
                if (!_2237)
                {
                    _2308 = _2232;
                }
                else
                {
                    _2308 = 0u;
                }
                uint _2340;
                uint _2341;
                uint _2342;
                uint _2343;
                if (!_2237)
                {
                    vec4 _2331 = uintBitsToFloat(textureGatherOffsets(cs_tex0_1f0, vec2(uintBitsToFloat(_2306), uintBitsToFloat(_2308)), ivec2[](ivec2(-1), ivec2(-2, -1), ivec2(-3, -1), ivec2(-4, -1))));
                    _2340 = floatBitsToUint(_2331.w);
                    _2341 = floatBitsToUint(_2331.z);
                    _2342 = floatBitsToUint(_2331.y);
                    _2343 = floatBitsToUint(_2331.x);
                }
                else
                {
                    _2340 = 0u;
                    _2341 = 1065353216u;
                    _2342 = _2308;
                    _2343 = _2306;
                }
                uint _2345;
                if (!_2237)
                {
                    _2345 = _2343;
                }
                else
                {
                    _2345 = _2297;
                }
                uint _2347;
                if (!_2237)
                {
                    _2347 = _2342;
                }
                else
                {
                    _2347 = _2298;
                }
                uint _2349;
                if (!_2237)
                {
                    _2349 = _2341;
                }
                else
                {
                    _2349 = _2299;
                }
                uint _2351;
                if (!_2237)
                {
                    _2351 = _2340;
                }
                else
                {
                    _2351 = _2300;
                }
                vec4 _2365 = uintBitsToFloat(textureGatherOffsets(cs_tex0_1f0, vec2(_2235, _2231), ivec2[](ivec2(-1, 0), ivec2(-2, 0), ivec2(-3, 0), ivec2(-4, 0))));
                uint _2367 = floatBitsToUint(_2365.x);
                uint _2369 = floatBitsToUint(_2365.y);
                uint _2371 = floatBitsToUint(_2365.z);
                uint _2373 = floatBitsToUint(_2365.w);
                vec4 _2379 = uintBitsToFloat(textureGatherOffsets(cs_tex0_1f0, vec2(_2235, _2231), ivec2[](ivec2(-1, 0), ivec2(-2, 0), ivec2(-3, 0), ivec2(-4, 0)), int(1u)));
                uint _2381 = floatBitsToUint(_2379.x);
                uint _2383 = floatBitsToUint(_2379.y);
                uint _2385 = floatBitsToUint(_2379.z);
                uint _2387 = floatBitsToUint(_2379.w);
                uint _2389 = (_2268 & _2264) >> 3u;
                uint _2393 = _2367 | ((_2345 << 12u) | (_2367 >> 4u));
                uint _2394 = _2393 & _2264;
                uint _2398 = ((_2394 << 1u) | (65535u ^ _2381)) | _2389;
                uint _2399 = _2398 & _2264;
                bool _2400 = _2399 != 0u;
                bool _2401;
                if (_2400)
                {
                    _2401 = true;
                }
                else
                {
                    _2401 = _2289;
                }
                uint _2402;
                if (_2400)
                {
                    _2402 = _2264;
                }
                else
                {
                    _2402 = _2393;
                }
                uint _2403;
                if (_2400)
                {
                    _2403 = _2296;
                }
                else
                {
                    _2403 = _2398;
                }
                uint _2727;
                uint _2728;
                uint _2729;
                uint _2730;
                uint _2731;
                uint _2732;
                uint _2733;
                uint _2734;
                bool _2735;
                if (!_2400)
                {
                    uint _2407 = _2394 >> 3u;
                    uint _2411 = (_2369 | ((_2347 << 12u) | (_2369 >> 4u))) & _2264;
                    uint _2416 = (((_2411 << 1u) | (65535u ^ _2383)) | _2407) & _2264;
                    bool _2417 = _2416 != 0u;
                    uint _2457;
                    uint _2458;
                    uint _2459;
                    bool _2460;
                    uint _2461;
                    uint _2462;
                    uint _2463;
                    uint _2464;
                    bool _2465;
                    bool _2466;
                    if (!_2417)
                    {
                        uint _2423 = _2371 | ((_2349 << 12u) | (_2371 >> 4u));
                        uint _2425 = _2423 & _2264;
                        uint _2428 = (_2425 << 1u) | (65535u ^ _2385);
                        uint _2429 = _2428 | (_2411 >> 3u);
                        uint _2430 = _2429 & _2264;
                        bool _2431 = _2430 != 0u;
                        uint _2448;
                        uint _2449;
                        uint _2450;
                        bool _2451;
                        uint _2452;
                        uint _2453;
                        uint _2454;
                        uint _2455;
                        bool _2456;
                        if (!_2431)
                        {
                            uint _2438 = (_2373 | ((_2351 << 12u) | (_2373 >> 4u))) & _2264;
                            uint _2440 = _2438 << 1u;
                            uint _2442 = _2440 | (65535u ^ _2387);
                            uint _2443 = _2442 | (_2425 >> 3u);
                            uint _2444 = _2443 & _2264;
                            bool _2445 = _2444 != 0u;
                            bool _2446;
                            if (_2445)
                            {
                                _2446 = true;
                            }
                            else
                            {
                                _2446 = _2431;
                            }
                            uint _2447;
                            if (_2445)
                            {
                                _2447 = _2264;
                            }
                            else
                            {
                                _2447 = _2429;
                            }
                            _2448 = _2296 + 12u;
                            _2449 = _2444;
                            _2450 = _2447;
                            _2451 = _2446;
                            _2452 = _2443;
                            _2453 = _2442;
                            _2454 = _2440;
                            _2455 = _2438;
                            _2456 = _2445;
                        }
                        else
                        {
                            _2448 = _2296 + 8u;
                            _2449 = _2430;
                            _2450 = _2429;
                            _2451 = _2431;
                            _2452 = _2423;
                            _2453 = _2387;
                            _2454 = _2371;
                            _2455 = _2428;
                            _2456 = _2400;
                        }
                        _2457 = _2448;
                        _2458 = _2449;
                        _2459 = _2450;
                        _2460 = _2451;
                        _2461 = _2452;
                        _2462 = _2453;
                        _2463 = _2454;
                        _2464 = _2455;
                        _2465 = _2456;
                        _2466 = _2431;
                    }
                    else
                    {
                        _2457 = _2296 + 4u;
                        _2458 = _2416;
                        _2459 = _2411;
                        _2460 = _2417;
                        _2461 = _2349;
                        _2462 = _2387;
                        _2463 = _2371;
                        _2464 = _2407;
                        _2465 = _2400;
                        _2466 = false;
                    }
                    uint _2718;
                    uint _2719;
                    uint _2720;
                    uint _2721;
                    uint _2722;
                    uint _2723;
                    uint _2724;
                    uint _2725;
                    bool _2726;
                    if (_2417 || (_2466 || (!_2465)))
                    {
                        uint _2581;
                        uint _2582;
                        uint _2583;
                        uint _2584;
                        uint _2585;
                        uint _2586;
                        uint _2587;
                        bool _2588;
                        uint _2589;
                        uint _2590;
                        uint _2591;
                        uint _2592;
                        uint _2593;
                        uint _2594;
                        uint _2595;
                        uint _2596;
                        uint _2597;
                        uint _2598;
                        bool _2599;
                        if (!_2417)
                        {
                            uint _2562;
                            uint _2563;
                            uint _2564;
                            uint _2565;
                            uint _2566;
                            uint _2567;
                            uint _2568;
                            bool _2569;
                            uint _2570;
                            uint _2571;
                            uint _2572;
                            uint _2573;
                            uint _2574;
                            uint _2575;
                            uint _2576;
                            uint _2577;
                            uint _2578;
                            uint _2579;
                            bool _2580;
                            if (!_2466)
                            {
                                uint _2474;
                                if (_2237)
                                {
                                    _2474 = 0u;
                                }
                                else
                                {
                                    _2474 = _2463;
                                }
                                uint _2475;
                                if (_2237)
                                {
                                    _2475 = 0u;
                                }
                                else
                                {
                                    _2475 = _2373;
                                }
                                precise float _2480 = fma(c0_1.data[8u], -4.0, _2235);
                                uint _2481 = floatBitsToUint(_2480);
                                uint _2482;
                                if (_2237)
                                {
                                    _2482 = 0u;
                                }
                                else
                                {
                                    _2482 = _2461;
                                }
                                uint _2483;
                                if (_2237)
                                {
                                    _2483 = 0u;
                                }
                                else
                                {
                                    _2483 = c0.data[8u];
                                }
                                uint _2485;
                                if (!_2237)
                                {
                                    _2485 = _2481;
                                }
                                else
                                {
                                    _2485 = _2381;
                                }
                                uint _2487;
                                if (!_2237)
                                {
                                    _2487 = _2232;
                                }
                                else
                                {
                                    _2487 = 3229614080u;
                                }
                                uint _2505;
                                uint _2506;
                                uint _2507;
                                uint _2508;
                                if (!_2237)
                                {
                                    vec4 _2496 = uintBitsToFloat(textureGatherOffsets(cs_tex0_1f0, vec2(uintBitsToFloat(_2485), uintBitsToFloat(_2487)), ivec2[](ivec2(-1), ivec2(-2, -1), ivec2(-3, -1), ivec2(-4, -1))));
                                    _2505 = floatBitsToUint(_2496.w);
                                    _2506 = floatBitsToUint(_2496.z);
                                    _2507 = floatBitsToUint(_2496.y);
                                    _2508 = floatBitsToUint(_2496.x);
                                }
                                else
                                {
                                    _2505 = _2387;
                                    _2506 = _2385;
                                    _2507 = _2487;
                                    _2508 = _2485;
                                }
                                uint _2510;
                                if (!_2237)
                                {
                                    _2510 = _2508;
                                }
                                else
                                {
                                    _2510 = _2474;
                                }
                                uint _2512;
                                if (!_2237)
                                {
                                    _2512 = _2507;
                                }
                                else
                                {
                                    _2512 = _2475;
                                }
                                uint _2514;
                                if (!_2237)
                                {
                                    _2514 = _2506;
                                }
                                else
                                {
                                    _2514 = _2482;
                                }
                                uint _2516;
                                if (!_2237)
                                {
                                    _2516 = _2505;
                                }
                                else
                                {
                                    _2516 = _2483;
                                }
                                vec4 _2522 = uintBitsToFloat(textureGatherOffsets(cs_tex0_1f0, vec2(_2480, _2231), ivec2[](ivec2(-1, 0), ivec2(-2, 0), ivec2(-3, 0), ivec2(-4, 0))));
                                uint _2524 = floatBitsToUint(_2522.x);
                                vec4 _2536 = uintBitsToFloat(textureGatherOffsets(cs_tex0_1f0, vec2(_2480, _2231), ivec2[](ivec2(-1, 0), ivec2(-2, 0), ivec2(-3, 0), ivec2(-4, 0)), int(1u)));
                                uint _2538 = floatBitsToUint(_2536.x);
                                uint _2542 = floatBitsToUint(_2536.z);
                                uint _2544 = floatBitsToUint(_2536.w);
                                uint _2550 = (_2524 | ((_2510 << 12u) | (_2524 >> 4u))) & _2264;
                                uint _2553 = (_2550 << 1u) | (65535u ^ _2538);
                                uint _2555 = (_2553 | (_2464 >> 3u)) & _2264;
                                bool _2556 = _2555 != 0u;
                                uint _2557;
                                if (_2556)
                                {
                                    _2557 = _2555;
                                }
                                else
                                {
                                    _2557 = _2538;
                                }
                                bool _2558;
                                if (_2556)
                                {
                                    _2558 = true;
                                }
                                else
                                {
                                    _2558 = _2460;
                                }
                                uint _2559;
                                if (_2556)
                                {
                                    _2559 = _2264;
                                }
                                else
                                {
                                    _2559 = _2481;
                                }
                                uint _2561;
                                if (_2556)
                                {
                                    _2561 = _2296 + 16u;
                                }
                                else
                                {
                                    _2561 = _2555;
                                }
                                _2562 = _2553;
                                _2563 = _2544;
                                _2564 = _2542;
                                _2565 = _2538;
                                _2566 = _2561;
                                _2567 = _2557;
                                _2568 = _2559;
                                _2569 = _2558;
                                _2570 = _2544;
                                _2571 = floatBitsToUint(_2522.w);
                                _2572 = _2516;
                                _2573 = _2542;
                                _2574 = floatBitsToUint(_2522.z);
                                _2575 = _2514;
                                _2576 = floatBitsToUint(_2536.y);
                                _2577 = floatBitsToUint(_2522.y);
                                _2578 = _2512;
                                _2579 = _2550;
                                _2580 = _2556;
                            }
                            else
                            {
                                _2562 = _2383;
                                _2563 = _2387;
                                _2564 = _2385;
                                _2565 = _2381;
                                _2566 = _2457;
                                _2567 = _2458;
                                _2568 = _2459;
                                _2569 = _2460;
                                _2570 = 16515325u;
                                _2571 = _2304;
                                _2572 = _2351;
                                _2573 = 16646399u;
                                _2574 = _2302;
                                _2575 = _2461;
                                _2576 = _2369;
                                _2577 = _2462;
                                _2578 = _2373;
                                _2579 = _2463;
                                _2580 = _2465;
                            }
                            _2581 = _2562;
                            _2582 = _2563;
                            _2583 = _2564;
                            _2584 = _2565;
                            _2585 = _2566;
                            _2586 = _2567;
                            _2587 = _2568;
                            _2588 = _2569;
                            _2589 = _2570;
                            _2590 = _2571;
                            _2591 = _2572;
                            _2592 = _2573;
                            _2593 = _2574;
                            _2594 = _2575;
                            _2595 = _2576;
                            _2596 = _2577;
                            _2597 = _2578;
                            _2598 = _2579;
                            _2599 = _2580;
                        }
                        else
                        {
                            _2581 = _2383;
                            _2582 = _2387;
                            _2583 = _2385;
                            _2584 = _2381;
                            _2585 = _2457;
                            _2586 = _2458;
                            _2587 = _2459;
                            _2588 = _2460;
                            _2589 = 16515325u;
                            _2590 = _2304;
                            _2591 = _2351;
                            _2592 = 16646399u;
                            _2593 = _2302;
                            _2594 = _2461;
                            _2595 = _2369;
                            _2596 = _2462;
                            _2597 = _2373;
                            _2598 = _2463;
                            _2599 = _2465;
                        }
                        uint _2713;
                        uint _2714;
                        uint _2715;
                        uint _2716;
                        bool _2717;
                        if (_2417 || (_2466 || (!_2599)))
                        {
                            uint _2628;
                            uint _2629;
                            uint _2630;
                            uint _2631;
                            bool _2632;
                            uint _2633;
                            bool _2634;
                            if (!_2417)
                            {
                                uint _2621;
                                uint _2622;
                                uint _2623;
                                uint _2624;
                                bool _2625;
                                uint _2626;
                                bool _2627;
                                if (!_2466)
                                {
                                    uint _2612 = (_2596 | ((_2597 << 12u) | (_2596 >> 4u))) & _2264;
                                    uint _2615 = (_2612 << 1u) | (65535u ^ _2595);
                                    uint _2617 = (_2615 | (_2598 >> 3u)) & _2264;
                                    bool _2618 = _2617 != 0u;
                                    bool _2619;
                                    if (_2618)
                                    {
                                        _2619 = true;
                                    }
                                    else
                                    {
                                        _2619 = _2588;
                                    }
                                    uint _2620;
                                    if (_2618)
                                    {
                                        _2620 = _2264;
                                    }
                                    else
                                    {
                                        _2620 = _2587;
                                    }
                                    _2621 = _2615;
                                    _2622 = _2296 + 20u;
                                    _2623 = _2617;
                                    _2624 = _2620;
                                    _2625 = _2619;
                                    _2626 = _2612;
                                    _2627 = _2618;
                                }
                                else
                                {
                                    _2621 = _2595;
                                    _2622 = _2585;
                                    _2623 = _2586;
                                    _2624 = _2587;
                                    _2625 = _2588;
                                    _2626 = _2464;
                                    _2627 = _2599;
                                }
                                _2628 = _2621;
                                _2629 = _2622;
                                _2630 = _2623;
                                _2631 = _2624;
                                _2632 = _2625;
                                _2633 = _2626;
                                _2634 = _2627;
                            }
                            else
                            {
                                _2628 = _2595;
                                _2629 = _2585;
                                _2630 = _2586;
                                _2631 = _2587;
                                _2632 = _2588;
                                _2633 = _2464;
                                _2634 = _2599;
                            }
                            uint _2709;
                            uint _2710;
                            uint _2711;
                            bool _2712;
                            if (_2417 || (_2466 || (!_2634)))
                            {
                                uint _2662;
                                uint _2663;
                                uint _2664;
                                bool _2665;
                                uint _2666;
                                bool _2667;
                                if (!_2417)
                                {
                                    uint _2656;
                                    uint _2657;
                                    uint _2658;
                                    bool _2659;
                                    uint _2660;
                                    bool _2661;
                                    if (!_2466)
                                    {
                                        uint _2647 = (_2593 | ((_2594 << 12u) | (_2593 >> 4u))) & _2264;
                                        uint _2652 = (((_2647 << 1u) | (65535u ^ _2592)) | (_2633 >> 3u)) & _2264;
                                        bool _2653 = _2652 != 0u;
                                        bool _2654;
                                        if (_2653)
                                        {
                                            _2654 = true;
                                        }
                                        else
                                        {
                                            _2654 = _2632;
                                        }
                                        uint _2655;
                                        if (_2653)
                                        {
                                            _2655 = _2264;
                                        }
                                        else
                                        {
                                            _2655 = _2631;
                                        }
                                        _2656 = _2296 + 24u;
                                        _2657 = _2652;
                                        _2658 = _2655;
                                        _2659 = _2654;
                                        _2660 = _2647;
                                        _2661 = _2653;
                                    }
                                    else
                                    {
                                        _2656 = _2629;
                                        _2657 = _2630;
                                        _2658 = _2631;
                                        _2659 = _2632;
                                        _2660 = _2593;
                                        _2661 = _2634;
                                    }
                                    _2662 = _2656;
                                    _2663 = _2657;
                                    _2664 = _2658;
                                    _2665 = _2659;
                                    _2666 = _2660;
                                    _2667 = _2661;
                                }
                                else
                                {
                                    _2662 = _2629;
                                    _2663 = _2630;
                                    _2664 = _2631;
                                    _2665 = _2632;
                                    _2666 = _2593;
                                    _2667 = _2634;
                                }
                                uint _2705;
                                uint _2706;
                                uint _2707;
                                bool _2708;
                                if (_2417 || (_2466 || (!_2667)))
                                {
                                    uint _2693;
                                    uint _2694;
                                    uint _2695;
                                    bool _2696;
                                    if (!_2417)
                                    {
                                        uint _2689;
                                        uint _2690;
                                        uint _2691;
                                        bool _2692;
                                        if (!_2466)
                                        {
                                            uint _2684 = (((((_2590 | ((_2591 << 12u) | (_2590 >> 4u))) & _2264) << 1u) | (65535u ^ _2589)) | (_2666 >> 3u)) & _2264;
                                            bool _2685 = _2684 != 0u;
                                            uint _2688;
                                            if (!_2685)
                                            {
                                                _2688 = _2296 + 32u;
                                            }
                                            else
                                            {
                                                _2688 = _2296 + 28u;
                                            }
                                            _2689 = _2688;
                                            _2690 = _2684;
                                            _2691 = _2264;
                                            _2692 = _2685;
                                        }
                                        else
                                        {
                                            _2689 = _2662;
                                            _2690 = _2663;
                                            _2691 = _2664;
                                            _2692 = _2665;
                                        }
                                        _2693 = _2689;
                                        _2694 = _2690;
                                        _2695 = _2691;
                                        _2696 = _2692;
                                    }
                                    else
                                    {
                                        _2693 = _2662;
                                        _2694 = _2663;
                                        _2695 = _2664;
                                        _2696 = _2665;
                                    }
                                    uint _2703;
                                    bool _2704;
                                    if (_2417 || _2466)
                                    {
                                        uint _2699;
                                        bool _2700;
                                        if (!_2417)
                                        {
                                            _2699 = _2264;
                                            _2700 = true;
                                        }
                                        else
                                        {
                                            _2699 = _2695;
                                            _2700 = _2696;
                                        }
                                        uint _2701;
                                        bool _2702;
                                        if (_2417)
                                        {
                                            _2701 = _2264;
                                            _2702 = true;
                                        }
                                        else
                                        {
                                            _2701 = _2699;
                                            _2702 = _2700;
                                        }
                                        _2703 = _2701;
                                        _2704 = _2702;
                                    }
                                    else
                                    {
                                        _2703 = _2695;
                                        _2704 = _2696;
                                    }
                                    _2705 = _2693;
                                    _2706 = _2694;
                                    _2707 = _2703;
                                    _2708 = _2704;
                                }
                                else
                                {
                                    _2705 = _2662;
                                    _2706 = _2663;
                                    _2707 = _2664;
                                    _2708 = _2665;
                                }
                                _2709 = _2705;
                                _2710 = _2706;
                                _2711 = _2707;
                                _2712 = _2708;
                            }
                            else
                            {
                                _2709 = _2629;
                                _2710 = _2630;
                                _2711 = _2631;
                                _2712 = _2632;
                            }
                            _2713 = _2628;
                            _2714 = _2709;
                            _2715 = _2710;
                            _2716 = _2711;
                            _2717 = _2712;
                        }
                        else
                        {
                            _2713 = _2595;
                            _2714 = _2585;
                            _2715 = _2586;
                            _2716 = _2587;
                            _2717 = _2588;
                        }
                        _2718 = _2581;
                        _2719 = _2713;
                        _2720 = _2582;
                        _2721 = _2583;
                        _2722 = _2584;
                        _2723 = _2714;
                        _2724 = _2715;
                        _2725 = _2716;
                        _2726 = _2717;
                    }
                    else
                    {
                        _2718 = _2383;
                        _2719 = _2369;
                        _2720 = _2387;
                        _2721 = _2385;
                        _2722 = _2381;
                        _2723 = _2457;
                        _2724 = _2458;
                        _2725 = _2459;
                        _2726 = _2460;
                    }
                    _2727 = _2718;
                    _2728 = _2719;
                    _2729 = _2720;
                    _2730 = _2721;
                    _2731 = _2722;
                    _2732 = _2723;
                    _2733 = _2724;
                    _2734 = _2725;
                    _2735 = _2726;
                }
                else
                {
                    _2727 = _2383;
                    _2728 = _2369;
                    _2729 = _2387;
                    _2730 = _2385;
                    _2731 = _2381;
                    _2732 = _2403;
                    _2733 = _2399;
                    _2734 = _2402;
                    _2735 = _2401;
                }
                _2736 = _2727;
                _2737 = _2728;
                _2738 = _2389;
                _2739 = _2729;
                _2740 = _2730;
                _2741 = _2731;
                _2742 = _2732;
                _2743 = _2733;
                _2744 = _2734;
                _2745 = _2735;
            }
            else
            {
                _2736 = _2191;
                _2737 = _2196;
                _2738 = _2197;
                _2739 = 0u;
                _2740 = 1065353216u;
                _2741 = 61440u;
                _2742 = _2287;
                _2743 = _2288;
                _2744 = _2292;
                _2745 = _2289;
            }
            bool _2746 = _967 != 3u;
            uint _2762;
            uint _2763;
            uint _2764;
            if (_2745)
            {
                uint _2750 = bitfieldReverse(_2743) >> 0u;
                uint _2751 = uint(findMSB(bitfieldReverse(_2744) >> 0u));
                uint _2755 = uint(findMSB(_2750));
                uint _2759 = _2742 + ((_2755 == 4294967295u) ? _2755 : (_2755 ^ 31u));
                _2762 = _2750;
                _2763 = _2759;
                _2764 = _2759 + (-((_2751 == 4294967295u) ? _2751 : (_2751 ^ 31u)));
            }
            else
            {
                _2762 = _2743;
                _2763 = _2741;
                _2764 = _2742;
            }
            uint _2765 = min(_2764, 31u);
            uint _2767;
            if (_2746)
            {
                _2767 = _949;
            }
            else
            {
                _2767 = _2763;
            }
            uint _2768;
            if (_2746)
            {
                _2768 = 0u;
            }
            else
            {
                _2768 = 3u;
            }
            uint _2769;
            if (_2746)
            {
                _2769 = _2768;
            }
            else
            {
                _2769 = _2768;
            }
            uint _2772;
            if (_2746)
            {
                _2772 = (_2769 << 16u) + _2767;
            }
            else
            {
                _2772 = _949 + 1u;
            }
            uint _2775 = _947 + (-_2765);
            uint _2776 = _2775 >> 2u;
            uint _2792 = floatBitsToUint(uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_2776, _2772)), int(0u))).x);
            bool _2793 = _966 != 3u;
            uint _2794 = _965 << 2u;
            uint _2797 = 3u & (~_2775);
            uint _2802;
            if (_2746)
            {
                _2802 = _2794 + 28u;
            }
            else
            {
                _2802 = _2767;
            }
            uint _2803;
            if (_2746)
            {
                _2803 = 0u;
            }
            else
            {
                _2803 = 44u;
            }
            uint _2804;
            if (_2746)
            {
                _2804 = _2803;
            }
            else
            {
                _2804 = _2803;
            }
            uint _2807;
            if (_2746)
            {
                _2807 = (_2804 << 16u) + _2802;
            }
            else
            {
                _2807 = (_965 << 2u) + 44u;
            }
            uint _2809;
            if (!_2793)
            {
                _2809 = 0u;
            }
            else
            {
                _2809 = _2738;
            }
            uint _2811 = (floatBitsToUint(uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_2776, _2772) + uvec2(0u, 4294967295u)), int(0u))).x) << 16u) | _2792;
            uint _2832;
            uint _2833;
            uint _2834;
            uint _2835;
            uint _2836;
            bool _2837;
            if (_2793)
            {
                uint _2821 = _2268 | (~_959);
                uvec2 _2826 = unpackUint2x32(packUint2x32(uvec2(_2264, 0u)) >> min((_966 + 1u), 32u));
                uint _2827 = _2826.x;
                uint _2828 = _2264 & _2827;
                uint _2829 = _2821 & _2828;
                bool _2830 = _2829 != 0u;
                uint _2831;
                if (_2830)
                {
                    _2831 = 0u;
                }
                else
                {
                    _2831 = _2268;
                }
                _2832 = _2831;
                _2833 = _2829;
                _2834 = _2821;
                _2835 = _2827;
                _2836 = _2828;
                _2837 = _2830;
            }
            else
            {
                _2832 = _2268;
                _2833 = _2764;
                _2834 = _2811;
                _2835 = _2797;
                _2836 = _2762;
                _2837 = _2793;
            }
            uint _3193;
            uint _3194;
            uint _3195;
            uint _3196;
            uint _3197;
            if ((!_2793) || (!_2837))
            {
                uint _2840;
                if (_2793)
                {
                    _2840 = _963;
                }
                else
                {
                    _2840 = _2809;
                }
                uint _2841;
                if (_2237)
                {
                    _2841 = 0u;
                }
                else
                {
                    _2841 = _2836;
                }
                uint _2842;
                if (_2237)
                {
                    _2842 = 0u;
                }
                else
                {
                    _2842 = _2737;
                }
                uint _2843;
                if (_2237)
                {
                    _2843 = 0u;
                }
                else
                {
                    _2843 = _2835;
                }
                uint _2844;
                if (_2237)
                {
                    _2844 = 0u;
                }
                else
                {
                    _2844 = _2834;
                }
                uint _2846;
                if (!_2237)
                {
                    _2846 = 4278386433u;
                }
                else
                {
                    _2846 = _2792;
                }
                uint _2848;
                if (!_2237)
                {
                    _2848 = 4278517507u;
                }
                else
                {
                    _2848 = _2794 + 28u;
                }
                uint _2850;
                if (!_2237)
                {
                    _2850 = _2236;
                }
                else
                {
                    _2850 = _2802;
                }
                uint _2852;
                if (!_2237)
                {
                    _2852 = _2232;
                }
                else
                {
                    _2852 = _2804;
                }
                uint _2881;
                uint _2882;
                uint _2883;
                uint _2884;
                if (!_2237)
                {
                    vec4 _2872 = uintBitsToFloat(textureGatherOffsets(cs_tex0_1f0, vec2(uintBitsToFloat(_2850), uintBitsToFloat(_2852)), ivec2[](ivec2(1, -1), ivec2(2, -1), ivec2(3, -1), ivec2(4, -1))));
                    _2881 = floatBitsToUint(_2872.w);
                    _2882 = floatBitsToUint(_2872.z);
                    _2883 = floatBitsToUint(_2872.y);
                    _2884 = floatBitsToUint(_2872.x);
                }
                else
                {
                    _2881 = _2739;
                    _2882 = _2740;
                    _2883 = _2852;
                    _2884 = _2850;
                }
                uint _2886;
                if (!_2237)
                {
                    _2886 = _2884;
                }
                else
                {
                    _2886 = _2841;
                }
                uint _2888;
                if (!_2237)
                {
                    _2888 = _2883;
                }
                else
                {
                    _2888 = _2842;
                }
                uint _2890;
                if (!_2237)
                {
                    _2890 = _2882;
                }
                else
                {
                    _2890 = _2843;
                }
                uint _2892;
                if (!_2237)
                {
                    _2892 = _2881;
                }
                else
                {
                    _2892 = _2844;
                }
                vec4 _2905 = uintBitsToFloat(textureGatherOffsets(cs_tex0_1f0, vec2(_2235, _2231), ivec2[](ivec2(1, 0), ivec2(2, 0), ivec2(3, 0), ivec2(4, 0))));
                uint _2907 = floatBitsToUint(_2905.x);
                uint _2909 = floatBitsToUint(_2905.y);
                uint _2911 = floatBitsToUint(_2905.z);
                uint _2913 = floatBitsToUint(_2905.w);
                vec4 _2919 = uintBitsToFloat(textureGatherOffsets(cs_tex0_1f0, vec2(_2235, _2231), ivec2[](ivec2(1, 0), ivec2(2, 0), ivec2(3, 0), ivec2(4, 0)), int(1u)));
                uint _2921 = floatBitsToUint(_2919.x);
                uint _2925 = floatBitsToUint(_2919.z);
                uint _2927 = floatBitsToUint(_2919.w);
                uint _2929 = _2907 >> 4u;
                uint _2933 = (_2907 | ((_2886 << 12u) | _2929)) | (65535u ^ _2921);
                uint _2934 = _2933 & _2264;
                bool _2935 = _2934 != 0u;
                uint _2936;
                if (_2935)
                {
                    _2936 = _2264;
                }
                else
                {
                    _2936 = _2929;
                }
                uint _2937;
                if (_2935)
                {
                    _2937 = _2840;
                }
                else
                {
                    _2937 = _2933;
                }
                uint _3188;
                uint _3189;
                uint _3190;
                uint _3191;
                uint _3192;
                if (!_2935)
                {
                    uint _2945 = (_2909 | ((_2888 << 12u) | (_2909 >> 4u))) | (65535u ^ floatBitsToUint(_2919.y));
                    uint _2946 = _2945 & _2264;
                    bool _2947 = _2946 != 0u;
                    uint _2975;
                    uint _2976;
                    uint _2977;
                    uint _2978;
                    uint _2979;
                    bool _2980;
                    bool _2981;
                    if (!_2947)
                    {
                        uint _2950 = _2911 >> 4u;
                        uint _2956 = ((_2911 | ((_2890 << 12u) | _2950)) | (65535u ^ _2925)) & _2264;
                        bool _2957 = _2956 != 0u;
                        uint _2969;
                        uint _2970;
                        uint _2971;
                        uint _2972;
                        uint _2973;
                        bool _2974;
                        if (!_2957)
                        {
                            uint _2960 = _2913 >> 4u;
                            uint _2965 = (_2913 | ((_2892 << 12u) | _2960)) | (65535u ^ _2927);
                            uint _2966 = _2965 & _2264;
                            bool _2967 = _2966 != 0u;
                            uint _2968;
                            if (_2967)
                            {
                                _2968 = _2264;
                            }
                            else
                            {
                                _2968 = _2945;
                            }
                            _2969 = _2840 + 12u;
                            _2970 = _2966;
                            _2971 = _2968;
                            _2972 = _2960;
                            _2973 = _2965;
                            _2974 = _2967;
                        }
                        else
                        {
                            _2969 = _2840 + 8u;
                            _2970 = _2956;
                            _2971 = _2945;
                            _2972 = _2892;
                            _2973 = _2950;
                            _2974 = _2957;
                        }
                        _2975 = _2969;
                        _2976 = _2970;
                        _2977 = _2971;
                        _2978 = _2972;
                        _2979 = _2973;
                        _2980 = _2974;
                        _2981 = _2957;
                    }
                    else
                    {
                        _2975 = _2840 + 4u;
                        _2976 = _2946;
                        _2977 = _2945;
                        _2978 = _2892;
                        _2979 = _2890;
                        _2980 = _2947;
                        _2981 = false;
                    }
                    uint _3183;
                    uint _3184;
                    uint _3185;
                    uint _3186;
                    uint _3187;
                    if (_2947 || (_2981 || (!_2980)))
                    {
                        uint _3086;
                        uint _3087;
                        uint _3088;
                        uint _3089;
                        uint _3090;
                        uint _3091;
                        uint _3092;
                        uint _3093;
                        uint _3094;
                        uint _3095;
                        uint _3096;
                        uint _3097;
                        uint _3098;
                        bool _3099;
                        if (!_2947)
                        {
                            uint _3072;
                            uint _3073;
                            uint _3074;
                            uint _3075;
                            uint _3076;
                            uint _3077;
                            uint _3078;
                            uint _3079;
                            uint _3080;
                            uint _3081;
                            uint _3082;
                            uint _3083;
                            uint _3084;
                            bool _3085;
                            if (!_2981)
                            {
                                uint _2989;
                                if (_2237)
                                {
                                    _2989 = 0u;
                                }
                                else
                                {
                                    _2989 = _2911;
                                }
                                uint _2990;
                                if (_2237)
                                {
                                    _2990 = 0u;
                                }
                                else
                                {
                                    _2990 = _2913;
                                }
                                precise float _2995 = fma(c0_1.data[8u], 4.0, _2235);
                                uint _2996 = floatBitsToUint(_2995);
                                uint _2997;
                                if (_2237)
                                {
                                    _2997 = 0u;
                                }
                                else
                                {
                                    _2997 = _2979;
                                }
                                uint _2998;
                                if (_2237)
                                {
                                    _2998 = 0u;
                                }
                                else
                                {
                                    _2998 = c0.data[8u];
                                }
                                uint _3000;
                                if (!_2237)
                                {
                                    _3000 = _2996;
                                }
                                else
                                {
                                    _3000 = _2921;
                                }
                                uint _3002;
                                if (!_2237)
                                {
                                    _3002 = _2232;
                                }
                                else
                                {
                                    _3002 = 1082130432u;
                                }
                                uint _3020;
                                uint _3021;
                                uint _3022;
                                uint _3023;
                                if (!_2237)
                                {
                                    vec4 _3011 = uintBitsToFloat(textureGatherOffsets(cs_tex0_1f0, vec2(uintBitsToFloat(_3000), uintBitsToFloat(_3002)), ivec2[](ivec2(1, -1), ivec2(2, -1), ivec2(3, -1), ivec2(4, -1))));
                                    _3020 = floatBitsToUint(_3011.w);
                                    _3021 = floatBitsToUint(_3011.z);
                                    _3022 = floatBitsToUint(_3011.y);
                                    _3023 = floatBitsToUint(_3011.x);
                                }
                                else
                                {
                                    _3020 = _2927;
                                    _3021 = _2925;
                                    _3022 = _3002;
                                    _3023 = _3000;
                                }
                                uint _3025;
                                if (!_2237)
                                {
                                    _3025 = _3023;
                                }
                                else
                                {
                                    _3025 = _2989;
                                }
                                uint _3027;
                                if (!_2237)
                                {
                                    _3027 = _3022;
                                }
                                else
                                {
                                    _3027 = _2990;
                                }
                                uint _3029;
                                if (!_2237)
                                {
                                    _3029 = _3021;
                                }
                                else
                                {
                                    _3029 = _2997;
                                }
                                uint _3031;
                                if (!_2237)
                                {
                                    _3031 = _3020;
                                }
                                else
                                {
                                    _3031 = _2998;
                                }
                                vec4 _3037 = uintBitsToFloat(textureGatherOffsets(cs_tex0_1f0, vec2(_2995, _2231), ivec2[](ivec2(1, 0), ivec2(2, 0), ivec2(3, 0), ivec2(4, 0))));
                                uint _3039 = floatBitsToUint(_3037.x);
                                vec4 _3051 = uintBitsToFloat(textureGatherOffsets(cs_tex0_1f0, vec2(_2995, _2231), ivec2[](ivec2(1, 0), ivec2(2, 0), ivec2(3, 0), ivec2(4, 0)), int(1u)));
                                uint _3053 = floatBitsToUint(_3051.x);
                                uint _3059 = floatBitsToUint(_3051.w);
                                uint _3066 = ((_3039 | ((_3025 << 12u) | (_3039 >> 4u))) | (65535u ^ _3053)) & _2264;
                                bool _3067 = _3066 != 0u;
                                uint _3068;
                                if (_3067)
                                {
                                    _3068 = _3066;
                                }
                                else
                                {
                                    _3068 = _3053;
                                }
                                uint _3070;
                                if (_3067)
                                {
                                    _3070 = _2840 + 16u;
                                }
                                else
                                {
                                    _3070 = _2975;
                                }
                                uint _3071;
                                if (_3067)
                                {
                                    _3071 = _2264;
                                }
                                else
                                {
                                    _3071 = _2996;
                                }
                                _3072 = _3059;
                                _3073 = _3070;
                                _3074 = _3068;
                                _3075 = _3071;
                                _3076 = _3059;
                                _3077 = floatBitsToUint(_3037.w);
                                _3078 = _3031;
                                _3079 = floatBitsToUint(_3051.z);
                                _3080 = floatBitsToUint(_3037.z);
                                _3081 = _3029;
                                _3082 = floatBitsToUint(_3051.y);
                                _3083 = floatBitsToUint(_3037.y);
                                _3084 = _3027;
                                _3085 = _3067;
                            }
                            else
                            {
                                _3072 = _2927;
                                _3073 = _2975;
                                _3074 = _2976;
                                _3075 = _2977;
                                _3076 = 262147u;
                                _3077 = _2848;
                                _3078 = _2978;
                                _3079 = 131073u;
                                _3080 = _2846;
                                _3081 = _2979;
                                _3082 = _2909;
                                _3083 = _2927;
                                _3084 = _2913;
                                _3085 = _2980;
                            }
                            _3086 = _3072;
                            _3087 = _3073;
                            _3088 = _3074;
                            _3089 = _3075;
                            _3090 = _3076;
                            _3091 = _3077;
                            _3092 = _3078;
                            _3093 = _3079;
                            _3094 = _3080;
                            _3095 = _3081;
                            _3096 = _3082;
                            _3097 = _3083;
                            _3098 = _3084;
                            _3099 = _3085;
                        }
                        else
                        {
                            _3086 = _2927;
                            _3087 = _2975;
                            _3088 = _2976;
                            _3089 = _2977;
                            _3090 = 262147u;
                            _3091 = _2848;
                            _3092 = _2978;
                            _3093 = 131073u;
                            _3094 = _2846;
                            _3095 = _2979;
                            _3096 = _2909;
                            _3097 = _2927;
                            _3098 = _2913;
                            _3099 = _2980;
                        }
                        uint _3180;
                        uint _3181;
                        uint _3182;
                        if (_2947 || (_2981 || (!_3099)))
                        {
                            uint _3119;
                            uint _3120;
                            uint _3121;
                            bool _3122;
                            if (!_2947)
                            {
                                uint _3115;
                                uint _3116;
                                uint _3117;
                                bool _3118;
                                if (!_2981)
                                {
                                    uint _3112 = ((_3097 | ((_3098 << 12u) | (_3097 >> 4u))) | (65535u ^ _3096)) & _2264;
                                    bool _3113 = _3112 != 0u;
                                    uint _3114;
                                    if (_3113)
                                    {
                                        _3114 = _2264;
                                    }
                                    else
                                    {
                                        _3114 = _3089;
                                    }
                                    _3115 = _2840 + 20u;
                                    _3116 = _3112;
                                    _3117 = _3114;
                                    _3118 = _3113;
                                }
                                else
                                {
                                    _3115 = _3087;
                                    _3116 = _3088;
                                    _3117 = _3089;
                                    _3118 = _3099;
                                }
                                _3119 = _3115;
                                _3120 = _3116;
                                _3121 = _3117;
                                _3122 = _3118;
                            }
                            else
                            {
                                _3119 = _3087;
                                _3120 = _3088;
                                _3121 = _3089;
                                _3122 = _3099;
                            }
                            uint _3177;
                            uint _3178;
                            uint _3179;
                            if (_2947 || (_2981 || (!_3122)))
                            {
                                uint _3142;
                                uint _3143;
                                uint _3144;
                                bool _3145;
                                if (!_2947)
                                {
                                    uint _3138;
                                    uint _3139;
                                    uint _3140;
                                    bool _3141;
                                    if (!_2981)
                                    {
                                        uint _3135 = ((_3094 | ((_3095 << 12u) | (_3094 >> 4u))) | (65535u ^ _3093)) & _2264;
                                        bool _3136 = _3135 != 0u;
                                        uint _3137;
                                        if (_3136)
                                        {
                                            _3137 = _2264;
                                        }
                                        else
                                        {
                                            _3137 = _3121;
                                        }
                                        _3138 = _2840 + 24u;
                                        _3139 = _3135;
                                        _3140 = _3137;
                                        _3141 = _3136;
                                    }
                                    else
                                    {
                                        _3138 = _3119;
                                        _3139 = _3120;
                                        _3140 = _3121;
                                        _3141 = _3122;
                                    }
                                    _3142 = _3138;
                                    _3143 = _3139;
                                    _3144 = _3140;
                                    _3145 = _3141;
                                }
                                else
                                {
                                    _3142 = _3119;
                                    _3143 = _3120;
                                    _3144 = _3121;
                                    _3145 = _3122;
                                }
                                uint _3174;
                                uint _3175;
                                uint _3176;
                                if (_2947 || (_2981 || (!_3145)))
                                {
                                    uint _3166;
                                    uint _3167;
                                    uint _3168;
                                    if (!_2947)
                                    {
                                        uint _3163;
                                        uint _3164;
                                        uint _3165;
                                        if (!_2981)
                                        {
                                            uint _3158 = ((_3091 | ((_3092 << 12u) | (_3091 >> 4u))) | (65535u ^ _3090)) & _2264;
                                            uint _3162;
                                            if (!(_3158 != 0u))
                                            {
                                                _3162 = _2840 + 32u;
                                            }
                                            else
                                            {
                                                _3162 = _2840 + 28u;
                                            }
                                            _3163 = _3162;
                                            _3164 = _3158;
                                            _3165 = _2264;
                                        }
                                        else
                                        {
                                            _3163 = _3142;
                                            _3164 = _3143;
                                            _3165 = _3144;
                                        }
                                        _3166 = _3163;
                                        _3167 = _3164;
                                        _3168 = _3165;
                                    }
                                    else
                                    {
                                        _3166 = _3142;
                                        _3167 = _3143;
                                        _3168 = _3144;
                                    }
                                    uint _3173;
                                    if (_2947 || _2981)
                                    {
                                        uint _3171;
                                        if (!_2947)
                                        {
                                            _3171 = _2264;
                                        }
                                        else
                                        {
                                            _3171 = _3168;
                                        }
                                        uint _3172;
                                        if (_2947)
                                        {
                                            _3172 = _2264;
                                        }
                                        else
                                        {
                                            _3172 = _3171;
                                        }
                                        _3173 = _3172;
                                    }
                                    else
                                    {
                                        _3173 = _3168;
                                    }
                                    _3174 = _3166;
                                    _3175 = _3167;
                                    _3176 = _3173;
                                }
                                else
                                {
                                    _3174 = _3142;
                                    _3175 = _3143;
                                    _3176 = _3144;
                                }
                                _3177 = _3174;
                                _3178 = _3175;
                                _3179 = _3176;
                            }
                            else
                            {
                                _3177 = _3119;
                                _3178 = _3120;
                                _3179 = _3121;
                            }
                            _3180 = _3177;
                            _3181 = _3178;
                            _3182 = _3179;
                        }
                        else
                        {
                            _3180 = _3087;
                            _3181 = _3088;
                            _3182 = _3089;
                        }
                        _3183 = _3096;
                        _3184 = _3086;
                        _3185 = _3180;
                        _3186 = _3181;
                        _3187 = _3182;
                    }
                    else
                    {
                        _3183 = _2909;
                        _3184 = _2927;
                        _3185 = _2975;
                        _3186 = _2976;
                        _3187 = _2977;
                    }
                    _3188 = _3183;
                    _3189 = _3184;
                    _3190 = _3185;
                    _3191 = _3186;
                    _3192 = _3187;
                }
                else
                {
                    _3188 = _2909;
                    _3189 = _2927;
                    _3190 = _2937;
                    _3191 = _2934;
                    _3192 = _2936;
                }
                _3193 = _3188;
                _3194 = _3189;
                _3195 = _3190;
                _3196 = _3191;
                _3197 = _3192;
            }
            else
            {
                _3193 = _2736;
                _3194 = _2739;
                _3195 = _2832;
                _3196 = _2833;
                _3197 = _2836;
            }
            uint _3198 = uint(findMSB(_3197));
            uint _3203 = min(((_3198 + (-uint(findMSB(_3196)))) + _3195), 31u);
            uint _3204 = _947 + _3203;
            uint _3206 = (_3204 & 3u) + 1u;
            uint _3209 = (_3204 >> 2u) + (_3206 >> 2u);
            uint _3225 = floatBitsToUint(uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_3209, _2772)), int(0u))).x);
            uint _3228 = _2807 & 31u;
            uvec2 _3233 = unpackUint2x32(packUint2x32(uvec2(unpackUint2x32(packUint2x32(uvec2(_2811, 0u)) >> min(_2797, 32u)).x, 0u)) >> min(_3228, 32u));
            uint _3234 = _3233.x;
            uvec2 _3249 = unpackUint2x32(packUint2x32(uvec2(unpackUint2x32(packUint2x32(uvec2((floatBitsToUint(uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_3209, _2772) + uvec2(0u, 4294967295u)), int(0u))).x) << 16u) | _3225, 0u)) >> min((3u & (~_3206)), 32u)).x, 0u)) >> min(_3228, 32u));
            uint _3250 = _3249.x;
            uint _3260 = (((_3234 >> 4u) << 1u) | (~2u)) & (2u | ((_3234 >> 8u) & 1u));
            uint _3264 = (((_3250 >> 4u) << 1u) | (~2u)) & (2u | ((_3250 >> 8u) & 1u));
            vec4 _3282 = texelFetch(cs_tex0_200, ivec2(uvec2(((bitfieldExtract(_3260, int(16u), int(16u)) * 32u) << 16u) + ((bitfieldExtract(_3260, int(0u), int(16u)) * 32u) + _2765), ((bitfieldExtract(_3264, int(16u), int(16u)) * 32u) << 16u) + ((bitfieldExtract(_3264, int(0u), int(16u)) * 32u) + _3203))), int(0u));
            float _3283 = _3282.x;
            float _3286 = float(_2765);
            float _3287 = float(_3203);
            uint _3289 = (!(_3287 < _3286)) ? 1065353216u : 0u;
            uint _3291 = (!(_3286 < _3287)) ? 1065353216u : 0u;
            precise float _3296 = uintBitsToFloat(_3289) + uintBitsToFloat(_3291);
            float _3299 = float(_3234 & 1u);
            float _3303 = float((_3234 >> 12u) & 1u);
            float _3306 = float(_3250 & 1u);
            precise float _3311 = (1.0 / _3296) * 0.75;
            precise float _3314 = uintBitsToFloat(_3289) * _3311;
            uint _3315 = floatBitsToUint(_3314);
            precise float _3317 = uintBitsToFloat(_3291) * _3311;
            uint _3318 = floatBitsToUint(_3317);
            precise float _3324 = fma(uintBitsToFloat(_3315 ^ 2147483648u), _3303, 1.0);
            float _3330 = CustomNumericMin(CustomNumericMax(fma(uintBitsToFloat(_3318 ^ 2147483648u), _3306, fma(uintBitsToFloat(_3315 ^ 2147483648u), _3299, 1.0)), 0.0), 1.0);
            precise float _3337 = _3283 * _3330;
            precise float _3339 = _3282.y * CustomNumericMin(CustomNumericMax(fma(uintBitsToFloat(_3318 ^ 2147483648u), float((_3250 >> 12u) & 1u), _3324), 0.0), 1.0);
            _3341 = floatBitsToUint(_3283);
            _3342 = floatBitsToUint(_3339);
            _3343 = floatBitsToUint(_3337);
            _3344 = floatBitsToUint(_3330);
            _3345 = floatBitsToUint(_3306);
            _3346 = _3193;
            _3347 = _3194;
            _3348 = _3198;
            _3349 = floatBitsToUint(_3324);
            _3350 = floatBitsToUint(_3311);
            _3351 = floatBitsToUint(_3303);
            _3352 = _3225;
            _3353 = floatBitsToUint(_3299);
            _3354 = _2746;
        }
        else
        {
            _3341 = _2213;
            _3342 = _2227;
            _3343 = _2224;
            _3344 = _2200;
            _3345 = _2201;
            _3346 = _2191;
            _3347 = 0u;
            _3348 = _2199;
            _3349 = _2214;
            _3350 = _2194;
            _3351 = _2195;
            _3352 = _2202;
            _3353 = _2203;
            _3354 = _2204;
        }
        bool _3356 = (_957 & _978) != 0u;
        uint _3358;
        if (!_3356)
        {
            _3358 = 0u;
        }
        else
        {
            _3358 = _3341;
        }
        uint _3360;
        if (!_3356)
        {
            _3360 = 0u;
        }
        else
        {
            _3360 = _3349;
        }
        uint _4517;
        uint _4518;
        uint _4519;
        if (_3356)
        {
            bool _3361 = _966 != 0u;
            bool _3362 = _967 != 0u;
            uint _3363;
            if (_3361)
            {
                _3363 = 0u;
            }
            else
            {
                _3363 = _978;
            }
            uint _3375;
            if (!_3361)
            {
                _3375 = floatBitsToUint(uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_950, _949) + uvec2(4294967295u, 0u)), int(0u))).y);
            }
            else
            {
                _3375 = _3363;
            }
            uint _3380 = (_963 < 32u) ? (4369u << _963) : 0u;
            uint _3382 = (_3375 << 3u) & 34952u;
            uint _3387;
            if (!_3362)
            {
                _3387 = 0u;
            }
            else
            {
                _3387 = _3382;
            }
            uint _3388 = (_3382 | (30583u & (_959 >> 1u))) | _959;
            uint _3412;
            uint _3413;
            uint _3414;
            uint _3415;
            bool _3416;
            uint _3417;
            uint _3418;
            bool _3419;
            if (_3362)
            {
                uint _3401 = (((bitfieldExtract(_967, int(0u), int(16u)) * 65535u) + (bitfieldExtract(_967, int(16u), int(16u)) * 65532u)) << 16u) + ((bitfieldExtract(_967, int(0u), int(16u)) * 65532u) + 16u);
                uint _3403 = (_3388 << 4u) | (~_957);
                uint _3407 = _3380 & ((_3401 < 32u) ? (65535u << _3401) : 0u);
                uint _3408 = _3403 & _3407;
                bool _3409 = _3408 != 0u;
                bool _3410;
                if (_3409)
                {
                    _3410 = true;
                }
                else
                {
                    _3410 = _3362;
                }
                uint _3411;
                if (_3409)
                {
                    _3411 = 0u;
                }
                else
                {
                    _3411 = _3403;
                }
                _3412 = 16u;
                _3413 = 65535u;
                _3414 = _3407;
                _3415 = _3411;
                _3416 = _3410;
                _3417 = _3401;
                _3418 = _3408;
                _3419 = _3409;
            }
            else
            {
                _3412 = 1065353216u;
                _3413 = 4369u;
                _3414 = _3348;
                _3415 = _3360;
                _3416 = _3362;
                _3417 = _3387;
                _3418 = _3353;
                _3419 = _3354;
            }
            uint _3864;
            uint _3865;
            uint _3866;
            uint _3867;
            uint _3868;
            uint _3869;
            uint _3870;
            uint _3871;
            uint _3872;
            bool _3873;
            if ((!_3362) || (!_3419))
            {
                uint _3422;
                if (_3362)
                {
                    _3422 = _967;
                }
                else
                {
                    _3422 = _3417;
                }
                uint _3423;
                if (_3361)
                {
                    _3423 = 0u;
                }
                else
                {
                    _3423 = _3418;
                }
                uint _3424;
                if (_3361)
                {
                    _3424 = 0u;
                }
                else
                {
                    _3424 = _3352;
                }
                uint _3425;
                if (_3361)
                {
                    _3425 = 0u;
                }
                else
                {
                    _3425 = _3351;
                }
                uint _3426;
                if (_3361)
                {
                    _3426 = 0u;
                }
                else
                {
                    _3426 = _3350;
                }
                if (!_3361)
                {
                }
                if (!_3361)
                {
                }
                vec4 _3441 = uintBitsToFloat(textureGatherOffsets(cs_tex0_1f0, vec2(_2235, _2231), ivec2[](ivec2(0, -1), ivec2(0, -2), ivec2(0, -3), ivec2(0, -4))));
                uint _3443 = floatBitsToUint(_3441.x);
                uint _3447 = floatBitsToUint(_3441.z);
                uint _3449 = floatBitsToUint(_3441.w);
                vec4 _3455 = uintBitsToFloat(textureGatherOffsets(cs_tex0_1f0, vec2(_2235, _2231), ivec2[](ivec2(0, -1), ivec2(0, -2), ivec2(0, -3), ivec2(0, -4)), int(1u)));
                uint _3457 = floatBitsToUint(_3455.x);
                uint _3459 = floatBitsToUint(_3455.y);
                uint _3461 = floatBitsToUint(_3455.z);
                uint _3463 = floatBitsToUint(_3455.w);
                uint _3465;
                if (!_3361)
                {
                    _3465 = _2236;
                }
                else
                {
                    _3465 = _3457;
                }
                uint _3467;
                if (!_3361)
                {
                    _3467 = _2232;
                }
                else
                {
                    _3467 = _3459;
                }
                uint _3491;
                uint _3492;
                uint _3493;
                uint _3494;
                if (!_3361)
                {
                    vec4 _3482 = uintBitsToFloat(textureGatherOffsets(cs_tex0_1f0, vec2(uintBitsToFloat(_3465), uintBitsToFloat(_3467)), ivec2[](ivec2(-1), ivec2(-1, -2), ivec2(-1, -3), ivec2(-1, -4)), int(1u)));
                    _3491 = floatBitsToUint(_3482.w);
                    _3492 = floatBitsToUint(_3482.z);
                    _3493 = floatBitsToUint(_3482.y);
                    _3494 = floatBitsToUint(_3482.x);
                }
                else
                {
                    _3491 = _3463;
                    _3492 = _3461;
                    _3493 = _3467;
                    _3494 = _3465;
                }
                uint _3496;
                if (!_3361)
                {
                    _3496 = _3494;
                }
                else
                {
                    _3496 = _3423;
                }
                uint _3498;
                if (!_3361)
                {
                    _3498 = _3493;
                }
                else
                {
                    _3498 = _3424;
                }
                uint _3500;
                if (!_3361)
                {
                    _3500 = _3492;
                }
                else
                {
                    _3500 = _3425;
                }
                uint _3502;
                if (!_3361)
                {
                    _3502 = _3491;
                }
                else
                {
                    _3502 = _3426;
                }
                uint _3509 = (((_3496 << 3u) & 34952u) | (30583u & (_3457 >> 1u))) | _3457;
                uint _3514 = ((_3509 << 4u) | (65535u ^ _3443)) | (15u & (_3388 >> 12u));
                uint _3515 = _3514 & _3380;
                bool _3516 = _3515 != 0u;
                bool _3517;
                if (_3516)
                {
                    _3517 = true;
                }
                else
                {
                    _3517 = _3416;
                }
                uint _3518;
                if (_3516)
                {
                    _3518 = _3422;
                }
                else
                {
                    _3518 = _3415;
                }
                uint _3519;
                if (_3516)
                {
                    _3519 = _3380;
                }
                else
                {
                    _3519 = _3443;
                }
                uint _3854;
                uint _3855;
                uint _3856;
                uint _3857;
                uint _3858;
                uint _3859;
                uint _3860;
                uint _3861;
                uint _3862;
                bool _3863;
                if (!_3516)
                {
                    uint _3528 = (((_3498 << 3u) & 34952u) | (30583u & (_3459 >> 1u))) | _3459;
                    uint _3533 = ((_3528 << 4u) | (65535u ^ floatBitsToUint(_3441.y))) | (15u & (_3509 >> 12u));
                    uint _3534 = _3533 & _3380;
                    bool _3535 = _3534 != 0u;
                    uint _3578;
                    uint _3579;
                    uint _3580;
                    bool _3581;
                    uint _3582;
                    uint _3583;
                    uint _3584;
                    uint _3585;
                    uint _3586;
                    uint _3587;
                    bool _3588;
                    bool _3589;
                    if (!_3535)
                    {
                        uint _3540 = (_3500 << 3u) & 34952u;
                        uint _3544 = (_3540 | (30583u & (_3461 >> 1u))) | _3461;
                        uint _3545 = _3544 << 4u;
                        uint _3547 = _3545 | (65535u ^ _3447);
                        uint _3549 = _3547 | (15u & (_3528 >> 12u));
                        uint _3550 = _3549 & _3380;
                        bool _3551 = _3550 != 0u;
                        uint _3570;
                        uint _3571;
                        uint _3572;
                        bool _3573;
                        uint _3574;
                        uint _3575;
                        uint _3576;
                        bool _3577;
                        if (!_3551)
                        {
                            uint _3556 = (_3502 << 3u) & 34952u;
                            uint _3559 = (_3556 | (30583u & (_3463 >> 1u))) | _3463;
                            uint _3562 = (_3559 << 4u) | (65535u ^ _3449);
                            uint _3565 = (_3562 | (15u & (_3544 >> 12u))) & _3380;
                            bool _3566 = _3565 != 0u;
                            bool _3568;
                            if (_3566)
                            {
                                _3568 = true;
                            }
                            else
                            {
                                _3568 = _3551;
                            }
                            uint _3569;
                            if (_3566)
                            {
                                _3569 = _3380;
                            }
                            else
                            {
                                _3569 = _3519;
                            }
                            _3570 = _3569;
                            _3571 = _3565;
                            _3572 = _3422 + 12u;
                            _3573 = _3568;
                            _3574 = _3556;
                            _3575 = _3562;
                            _3576 = _3559;
                            _3577 = _3566;
                        }
                        else
                        {
                            _3570 = _3519;
                            _3571 = _3550;
                            _3572 = _3422 + 8u;
                            _3573 = _3551;
                            _3574 = _3502;
                            _3575 = _3540;
                            _3576 = _3545;
                            _3577 = _3516;
                        }
                        _3578 = _3570;
                        _3579 = _3571;
                        _3580 = _3572;
                        _3581 = _3573;
                        _3582 = _3574;
                        _3583 = _3547;
                        _3584 = _3575;
                        _3585 = _3549;
                        _3586 = _3544;
                        _3587 = _3576;
                        _3588 = _3577;
                        _3589 = _3551;
                    }
                    else
                    {
                        _3578 = _3519;
                        _3579 = _3534;
                        _3580 = _3422 + 4u;
                        _3581 = _3535;
                        _3582 = _3502;
                        _3583 = _3447;
                        _3584 = _3500;
                        _3585 = _3528;
                        _3586 = _3461;
                        _3587 = _3514;
                        _3588 = _3516;
                        _3589 = false;
                    }
                    uint _3844;
                    uint _3845;
                    uint _3846;
                    uint _3847;
                    uint _3848;
                    uint _3849;
                    uint _3850;
                    uint _3851;
                    uint _3852;
                    bool _3853;
                    if (_3535 || (_3589 || (!_3588)))
                    {
                        uint _3702;
                        uint _3703;
                        uint _3704;
                        uint _3705;
                        uint _3706;
                        uint _3707;
                        bool _3708;
                        uint _3709;
                        uint _3710;
                        uint _3711;
                        uint _3712;
                        uint _3713;
                        uint _3714;
                        uint _3715;
                        uint _3716;
                        uint _3717;
                        uint _3718;
                        bool _3719;
                        if (!_3535)
                        {
                            uint _3684;
                            uint _3685;
                            uint _3686;
                            uint _3687;
                            uint _3688;
                            uint _3689;
                            bool _3690;
                            uint _3691;
                            uint _3692;
                            uint _3693;
                            uint _3694;
                            uint _3695;
                            uint _3696;
                            uint _3697;
                            uint _3698;
                            uint _3699;
                            uint _3700;
                            bool _3701;
                            if (!_3589)
                            {
                                uint _3597;
                                if (_3361)
                                {
                                    _3597 = 0u;
                                }
                                else
                                {
                                    _3597 = _3586;
                                }
                                uint _3598;
                                if (_3361)
                                {
                                    _3598 = 0u;
                                }
                                else
                                {
                                    _3598 = _3463;
                                }
                                precise float _3601 = fma(c0_1.data[9u], -4.0, _2231);
                                uint _3603;
                                if (_3361)
                                {
                                    _3603 = 0u;
                                }
                                else
                                {
                                    _3603 = c0.data[9u];
                                }
                                uint _3604;
                                if (_3361)
                                {
                                    _3604 = 0u;
                                }
                                else
                                {
                                    _3604 = _3582;
                                }
                                vec4 _3610 = uintBitsToFloat(textureGatherOffsets(cs_tex0_1f0, vec2(_2235, _3601), ivec2[](ivec2(0, -1), ivec2(0, -2), ivec2(0, -3), ivec2(0, -4))));
                                uint _3612 = floatBitsToUint(_3610.x);
                                uint _3614 = floatBitsToUint(_3610.y);
                                uint _3616 = floatBitsToUint(_3610.z);
                                uint _3618 = floatBitsToUint(_3610.w);
                                uint _3620;
                                if (!_3361)
                                {
                                    _3620 = _2236;
                                }
                                else
                                {
                                    _3620 = _3612;
                                }
                                uint _3622;
                                if (!_3361)
                                {
                                    _3622 = floatBitsToUint(_3601);
                                }
                                else
                                {
                                    _3622 = _3614;
                                }
                                uint _3640;
                                uint _3641;
                                uint _3642;
                                uint _3643;
                                if (!_3361)
                                {
                                    vec4 _3631 = uintBitsToFloat(textureGatherOffsets(cs_tex0_1f0, vec2(uintBitsToFloat(_3620), uintBitsToFloat(_3622)), ivec2[](ivec2(-1), ivec2(-1, -2), ivec2(-1, -3), ivec2(-1, -4)), int(1u)));
                                    _3640 = floatBitsToUint(_3631.w);
                                    _3641 = floatBitsToUint(_3631.z);
                                    _3642 = floatBitsToUint(_3631.y);
                                    _3643 = floatBitsToUint(_3631.x);
                                }
                                else
                                {
                                    _3640 = _3618;
                                    _3641 = _3616;
                                    _3642 = _3622;
                                    _3643 = _3620;
                                }
                                uint _3645;
                                if (!_3361)
                                {
                                    _3645 = _3643;
                                }
                                else
                                {
                                    _3645 = _3597;
                                }
                                uint _3647;
                                if (!_3361)
                                {
                                    _3647 = _3642;
                                }
                                else
                                {
                                    _3647 = _3598;
                                }
                                uint _3649;
                                if (!_3361)
                                {
                                    _3649 = _3641;
                                }
                                else
                                {
                                    _3649 = _3603;
                                }
                                uint _3651;
                                if (!_3361)
                                {
                                    _3651 = _3640;
                                }
                                else
                                {
                                    _3651 = _3604;
                                }
                                vec4 _3657 = uintBitsToFloat(textureGatherOffsets(cs_tex0_1f0, vec2(_2235, _3601), ivec2[](ivec2(0, -1), ivec2(0, -2), ivec2(0, -3), ivec2(0, -4)), int(1u)));
                                uint _3659 = floatBitsToUint(_3657.x);
                                uint _3663 = floatBitsToUint(_3657.z);
                                uint _3665 = floatBitsToUint(_3657.w);
                                uint _3672 = (((_3645 << 3u) & 34952u) | (30583u & (_3659 >> 1u))) | _3659;
                                uint _3677 = ((_3672 << 4u) | (65535u ^ _3612)) | (15u & (_3587 >> 12u));
                                uint _3678 = _3677 & _3380;
                                bool _3679 = _3678 != 0u;
                                bool _3680;
                                if (_3679)
                                {
                                    _3680 = true;
                                }
                                else
                                {
                                    _3680 = _3581;
                                }
                                uint _3681;
                                if (_3679)
                                {
                                    _3681 = _3380;
                                }
                                else
                                {
                                    _3681 = _3659;
                                }
                                uint _3683;
                                if (_3679)
                                {
                                    _3683 = _3422 + 16u;
                                }
                                else
                                {
                                    _3683 = _3677;
                                }
                                _3684 = _3665;
                                _3685 = _3663;
                                _3686 = _3659;
                                _3687 = _3681;
                                _3688 = _3678;
                                _3689 = _3683;
                                _3690 = _3680;
                                _3691 = _3618;
                                _3692 = _3651;
                                _3693 = _3665;
                                _3694 = _3616;
                                _3695 = _3649;
                                _3696 = _3663;
                                _3697 = _3614;
                                _3698 = floatBitsToUint(_3657.y);
                                _3699 = _3647;
                                _3700 = _3672;
                                _3701 = _3679;
                            }
                            else
                            {
                                _3684 = _3491;
                                _3685 = _3492;
                                _3686 = _3494;
                                _3687 = _3578;
                                _3688 = _3579;
                                _3689 = _3580;
                                _3690 = _3581;
                                _3691 = _3449;
                                _3692 = _3582;
                                _3693 = 4227923200u;
                                _3694 = _3583;
                                _3695 = _3584;
                                _3696 = 4261478144u;
                                _3697 = _3585;
                                _3698 = _3533;
                                _3699 = _3463;
                                _3700 = _3586;
                                _3701 = _3588;
                            }
                            _3702 = _3684;
                            _3703 = _3685;
                            _3704 = _3686;
                            _3705 = _3687;
                            _3706 = _3688;
                            _3707 = _3689;
                            _3708 = _3690;
                            _3709 = _3691;
                            _3710 = _3692;
                            _3711 = _3693;
                            _3712 = _3694;
                            _3713 = _3695;
                            _3714 = _3696;
                            _3715 = _3697;
                            _3716 = _3698;
                            _3717 = _3699;
                            _3718 = _3700;
                            _3719 = _3701;
                        }
                        else
                        {
                            _3702 = _3491;
                            _3703 = _3492;
                            _3704 = _3494;
                            _3705 = _3578;
                            _3706 = _3579;
                            _3707 = _3580;
                            _3708 = _3581;
                            _3709 = _3449;
                            _3710 = _3582;
                            _3711 = 4227923200u;
                            _3712 = _3583;
                            _3713 = _3584;
                            _3714 = 4261478144u;
                            _3715 = _3585;
                            _3716 = _3533;
                            _3717 = _3463;
                            _3718 = _3586;
                            _3719 = _3588;
                        }
                        uint _3838;
                        uint _3839;
                        uint _3840;
                        uint _3841;
                        uint _3842;
                        bool _3843;
                        if (_3535 || (_3589 || (!_3719)))
                        {
                            uint _3749;
                            uint _3750;
                            uint _3751;
                            uint _3752;
                            bool _3753;
                            uint _3754;
                            bool _3755;
                            if (!_3535)
                            {
                                uint _3742;
                                uint _3743;
                                uint _3744;
                                uint _3745;
                                bool _3746;
                                uint _3747;
                                bool _3748;
                                if (!_3589)
                                {
                                    uint _3732 = (((_3717 << 3u) & 34952u) | (30583u & (_3716 >> 1u))) | _3716;
                                    uint _3737 = ((_3732 << 4u) | (65535u ^ _3715)) | (15u & (_3718 >> 12u));
                                    uint _3738 = _3737 & _3380;
                                    bool _3739 = _3738 != 0u;
                                    bool _3740;
                                    if (_3739)
                                    {
                                        _3740 = true;
                                    }
                                    else
                                    {
                                        _3740 = _3708;
                                    }
                                    uint _3741;
                                    if (_3739)
                                    {
                                        _3741 = _3380;
                                    }
                                    else
                                    {
                                        _3741 = _3705;
                                    }
                                    _3742 = _3737;
                                    _3743 = _3741;
                                    _3744 = _3738;
                                    _3745 = _3422 + 20u;
                                    _3746 = _3740;
                                    _3747 = _3732;
                                    _3748 = _3739;
                                }
                                else
                                {
                                    _3742 = _3715;
                                    _3743 = _3705;
                                    _3744 = _3706;
                                    _3745 = _3707;
                                    _3746 = _3708;
                                    _3747 = _3716;
                                    _3748 = _3719;
                                }
                                _3749 = _3742;
                                _3750 = _3743;
                                _3751 = _3744;
                                _3752 = _3745;
                                _3753 = _3746;
                                _3754 = _3747;
                                _3755 = _3748;
                            }
                            else
                            {
                                _3749 = _3715;
                                _3750 = _3705;
                                _3751 = _3706;
                                _3752 = _3707;
                                _3753 = _3708;
                                _3754 = _3716;
                                _3755 = _3719;
                            }
                            uint _3833;
                            uint _3834;
                            uint _3835;
                            uint _3836;
                            bool _3837;
                            if (_3535 || (_3589 || (!_3755)))
                            {
                                uint _3784;
                                uint _3785;
                                uint _3786;
                                bool _3787;
                                uint _3788;
                                bool _3789;
                                if (!_3535)
                                {
                                    uint _3778;
                                    uint _3779;
                                    uint _3780;
                                    bool _3781;
                                    uint _3782;
                                    bool _3783;
                                    if (!_3589)
                                    {
                                        uint _3766 = (((_3713 << 3u) & 34952u) | (30583u & (_3714 >> 1u))) | _3714;
                                        uint _3774 = (((_3766 << 4u) | (65535u ^ _3712)) | (15u & (_3754 >> 12u))) & _3380;
                                        bool _3775 = _3774 != 0u;
                                        bool _3776;
                                        if (_3775)
                                        {
                                            _3776 = true;
                                        }
                                        else
                                        {
                                            _3776 = _3753;
                                        }
                                        uint _3777;
                                        if (_3775)
                                        {
                                            _3777 = _3380;
                                        }
                                        else
                                        {
                                            _3777 = _3750;
                                        }
                                        _3778 = _3777;
                                        _3779 = _3774;
                                        _3780 = _3422 + 24u;
                                        _3781 = _3776;
                                        _3782 = _3766;
                                        _3783 = _3775;
                                    }
                                    else
                                    {
                                        _3778 = _3750;
                                        _3779 = _3751;
                                        _3780 = _3752;
                                        _3781 = _3753;
                                        _3782 = _3714;
                                        _3783 = _3755;
                                    }
                                    _3784 = _3778;
                                    _3785 = _3779;
                                    _3786 = _3780;
                                    _3787 = _3781;
                                    _3788 = _3782;
                                    _3789 = _3783;
                                }
                                else
                                {
                                    _3784 = _3750;
                                    _3785 = _3751;
                                    _3786 = _3752;
                                    _3787 = _3753;
                                    _3788 = _3714;
                                    _3789 = _3755;
                                }
                                uint _3829;
                                uint _3830;
                                uint _3831;
                                bool _3832;
                                if (_3535 || (_3589 || (!_3789)))
                                {
                                    uint _3817;
                                    uint _3818;
                                    uint _3819;
                                    bool _3820;
                                    if (!_3535)
                                    {
                                        uint _3813;
                                        uint _3814;
                                        uint _3815;
                                        bool _3816;
                                        if (!_3589)
                                        {
                                            uint _3808 = (((((((_3710 << 3u) & 34952u) | (30583u & (_3711 >> 1u))) | _3711) << 4u) | (65535u ^ _3709)) | (15u & (_3788 >> 12u))) & _3380;
                                            bool _3809 = _3808 != 0u;
                                            uint _3812;
                                            if (!_3809)
                                            {
                                                _3812 = _3422 + 32u;
                                            }
                                            else
                                            {
                                                _3812 = _3422 + 28u;
                                            }
                                            _3813 = _3380;
                                            _3814 = _3808;
                                            _3815 = _3812;
                                            _3816 = _3809;
                                        }
                                        else
                                        {
                                            _3813 = _3784;
                                            _3814 = _3785;
                                            _3815 = _3786;
                                            _3816 = _3787;
                                        }
                                        _3817 = _3813;
                                        _3818 = _3814;
                                        _3819 = _3815;
                                        _3820 = _3816;
                                    }
                                    else
                                    {
                                        _3817 = _3784;
                                        _3818 = _3785;
                                        _3819 = _3786;
                                        _3820 = _3787;
                                    }
                                    uint _3827;
                                    bool _3828;
                                    if (_3535 || _3589)
                                    {
                                        uint _3823;
                                        bool _3824;
                                        if (!_3535)
                                        {
                                            _3823 = _3380;
                                            _3824 = true;
                                        }
                                        else
                                        {
                                            _3823 = _3817;
                                            _3824 = _3820;
                                        }
                                        uint _3825;
                                        bool _3826;
                                        if (_3535)
                                        {
                                            _3825 = _3380;
                                            _3826 = true;
                                        }
                                        else
                                        {
                                            _3825 = _3823;
                                            _3826 = _3824;
                                        }
                                        _3827 = _3825;
                                        _3828 = _3826;
                                    }
                                    else
                                    {
                                        _3827 = _3817;
                                        _3828 = _3820;
                                    }
                                    _3829 = _3827;
                                    _3830 = _3818;
                                    _3831 = _3819;
                                    _3832 = _3828;
                                }
                                else
                                {
                                    _3829 = _3784;
                                    _3830 = _3785;
                                    _3831 = _3786;
                                    _3832 = _3787;
                                }
                                _3833 = _3788;
                                _3834 = _3829;
                                _3835 = _3830;
                                _3836 = _3831;
                                _3837 = _3832;
                            }
                            else
                            {
                                _3833 = _3714;
                                _3834 = _3750;
                                _3835 = _3751;
                                _3836 = _3752;
                                _3837 = _3753;
                            }
                            _3838 = _3833;
                            _3839 = _3749;
                            _3840 = _3834;
                            _3841 = _3835;
                            _3842 = _3836;
                            _3843 = _3837;
                        }
                        else
                        {
                            _3838 = _3714;
                            _3839 = _3715;
                            _3840 = _3705;
                            _3841 = _3706;
                            _3842 = _3707;
                            _3843 = _3708;
                        }
                        _3844 = _3711;
                        _3845 = _3838;
                        _3846 = _3839;
                        _3847 = _3702;
                        _3848 = _3703;
                        _3849 = _3704;
                        _3850 = _3840;
                        _3851 = _3841;
                        _3852 = _3842;
                        _3853 = _3843;
                    }
                    else
                    {
                        _3844 = 4227923200u;
                        _3845 = 4261478144u;
                        _3846 = _3585;
                        _3847 = _3491;
                        _3848 = _3492;
                        _3849 = _3494;
                        _3850 = _3578;
                        _3851 = _3579;
                        _3852 = _3580;
                        _3853 = _3581;
                    }
                    _3854 = _3844;
                    _3855 = _3845;
                    _3856 = _3846;
                    _3857 = _3847;
                    _3858 = _3848;
                    _3859 = _3849;
                    _3860 = _3850;
                    _3861 = _3851;
                    _3862 = _3852;
                    _3863 = _3853;
                }
                else
                {
                    _3854 = 4227923200u;
                    _3855 = 4261478144u;
                    _3856 = _3459;
                    _3857 = _3491;
                    _3858 = _3492;
                    _3859 = _3494;
                    _3860 = _3519;
                    _3861 = _3515;
                    _3862 = _3518;
                    _3863 = _3517;
                }
                _3864 = _3854;
                _3865 = _3855;
                _3866 = _3856;
                _3867 = _3857;
                _3868 = _3858;
                _3869 = _3859;
                _3870 = _3860;
                _3871 = _3861;
                _3872 = _3862;
                _3873 = _3863;
            }
            else
            {
                _3864 = _3344;
                _3865 = _3345;
                _3866 = _3346;
                _3867 = _3347;
                _3868 = _3412;
                _3869 = _3413;
                _3870 = _3414;
                _3871 = _3418;
                _3872 = _3415;
                _3873 = _3416;
            }
            bool _3874 = _966 != 3u;
            uint _3898;
            uint _3899;
            uint _3900;
            uint _3901;
            if (_3873)
            {
                uint _3878 = bitfieldReverse(_3871) >> 0u;
                uint _3879 = uint(findMSB(bitfieldReverse(_3870) >> 0u));
                uint _3882 = (_3879 == 4294967295u) ? _3879 : (_3879 ^ 31u);
                uint _3883 = uint(findMSB(_3878));
                uint _3886 = (_3883 == 4294967295u) ? _3883 : (_3883 ^ 31u);
                uint _3891 = uint(int(_3886) >> int(31u)) & 3u;
                uint _3895 = _3872 + uint(int(_3886 + _3891) >> int(2u));
                _3898 = _3878;
                _3899 = _3891;
                _3900 = _3895;
                _3901 = _3895 + (-uint(int(_3882 + (uint(int(_3882) >> int(31u)) & 3u)) >> int(2u)));
            }
            else
            {
                _3898 = _3871;
                _3899 = _3865;
                _3900 = _3869;
                _3901 = _3872;
            }
            uint _3902 = min(_3901, 31u);
            uint _3904;
            if (_3874)
            {
                _3904 = _950;
            }
            else
            {
                _3904 = _3900;
            }
            uint _3905;
            if (_3874)
            {
                _3905 = 0u;
            }
            else
            {
                _3905 = 3u;
            }
            uint _3906;
            if (_3874)
            {
                _3906 = _3905;
            }
            else
            {
                _3906 = _3905;
            }
            uint _3909;
            if (_3874)
            {
                _3909 = (_3906 << 16u) + _3904;
            }
            else
            {
                _3909 = _950 + 1u;
            }
            uint _3911 = _960 + (-_3902);
            uint _3912 = _3911 >> 2u;
            bool _3931 = _967 != 3u;
            uint _3932 = (3u & (~_3911)) << 2u;
            uint _3934;
            if (!_3931)
            {
                _3934 = 0u;
            }
            else
            {
                _3934 = _3866;
            }
            uint _3947 = unpackUint2x32(packUint2x32(uvec2(floatBitsToUint(uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_3909, _3912) + uvec2(4294967295u, 0u)), int(0u))).y), 0u)) >> min(_3932, 32u)).x << 4u;
            uint _3948 = unpackUint2x32(packUint2x32(uvec2(floatBitsToUint(uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_3909, _3912)), int(0u))).y), 0u)) >> min(_3932, 32u)).x & 15u;
            uint _3968;
            uint _3969;
            bool _3970;
            uint _3971;
            uint _3972;
            uint _3973;
            uint _3974;
            uint _3975;
            bool _3976;
            if (_3931)
            {
                uint _3954 = _967 << 2u;
                uint _3956 = _3388 | (~_957);
                uint _3962 = (_3954 < 32u) ? (((0u << 16u) + 4095u) >> _3954) : 0u;
                uint _3963 = _3380 & _3962;
                uint _3964 = _3956 & _3963;
                bool _3965 = _3964 != 0u;
                bool _3966;
                if (_3965)
                {
                    _3966 = true;
                }
                else
                {
                    _3966 = _3931;
                }
                uint _3967;
                if (_3965)
                {
                    _3967 = 0u;
                }
                else
                {
                    _3967 = _957;
                }
                _3968 = _3963;
                _3969 = _3964;
                _3970 = _3966;
                _3971 = _3962;
                _3972 = _3956;
                _3973 = _3967;
                _3974 = 0u;
                _3975 = 4095u;
                _3976 = _3965;
            }
            else
            {
                _3968 = _3898;
                _3969 = _3932;
                _3970 = _3931;
                _3971 = _3947;
                _3972 = _3388;
                _3973 = _957;
                _3974 = 240u;
                _3975 = _3904;
                _3976 = _2192;
            }
            uint _4357;
            uint _4358;
            uint _4359;
            bool _4360;
            if ((!_3931) || (!_3976))
            {
                uint _3979;
                if (_3931)
                {
                    _3979 = _965;
                }
                else
                {
                    _3979 = _3934;
                }
                uint _3980;
                if (_3361)
                {
                    _3980 = 0u;
                }
                else
                {
                    _3980 = _3973;
                }
                uint _3981;
                if (_3361)
                {
                    _3981 = 0u;
                }
                else
                {
                    _3981 = _3972;
                }
                uint _3982;
                if (_3361)
                {
                    _3982 = 0u;
                }
                else
                {
                    _3982 = _3948;
                }
                uint _3983;
                if (_3361)
                {
                    _3983 = 0u;
                }
                else
                {
                    _3983 = _3971;
                }
                uint _3985;
                if (!_3361)
                {
                    _3985 = 50266623u;
                }
                else
                {
                    _3985 = _3899;
                }
                uint _3987;
                if (!_3361)
                {
                    _3987 = 83821567u;
                }
                else
                {
                    _3987 = _3864;
                }
                uint _3989;
                if (!_3361)
                {
                    _3989 = _2236;
                }
                else
                {
                    _3989 = _3975;
                }
                uint _3991;
                if (!_3361)
                {
                    _3991 = _2232;
                }
                else
                {
                    _3991 = _3974;
                }
                uint _4016;
                uint _4017;
                uint _4018;
                uint _4019;
                if (!_3361)
                {
                    vec4 _4007 = uintBitsToFloat(textureGatherOffsets(cs_tex0_1f0, vec2(uintBitsToFloat(_3989), uintBitsToFloat(_3991)), ivec2[](ivec2(-1, 1), ivec2(-1, 2), ivec2(-1, 3), ivec2(-1, 4)), int(1u)));
                    _4016 = floatBitsToUint(_4007.w);
                    _4017 = floatBitsToUint(_4007.z);
                    _4018 = floatBitsToUint(_4007.y);
                    _4019 = floatBitsToUint(_4007.x);
                }
                else
                {
                    _4016 = _3867;
                    _4017 = _3868;
                    _4018 = _3991;
                    _4019 = _3989;
                }
                uint _4021;
                if (!_3361)
                {
                    _4021 = _4019;
                }
                else
                {
                    _4021 = _3980;
                }
                uint _4023;
                if (!_3361)
                {
                    _4023 = _4018;
                }
                else
                {
                    _4023 = _3981;
                }
                uint _4025;
                if (!_3361)
                {
                    _4025 = _4017;
                }
                else
                {
                    _4025 = _3982;
                }
                uint _4027;
                if (!_3361)
                {
                    _4027 = _4016;
                }
                else
                {
                    _4027 = _3983;
                }
                vec4 _4040 = uintBitsToFloat(textureGatherOffsets(cs_tex0_1f0, vec2(_2235, _2231), ivec2[](ivec2(0, 1), ivec2(0, 2), ivec2(0, 3), ivec2(0, 4))));
                uint _4042 = floatBitsToUint(_4040.x);
                uint _4048 = floatBitsToUint(_4040.w);
                vec4 _4054 = uintBitsToFloat(textureGatherOffsets(cs_tex0_1f0, vec2(_2235, _2231), ivec2[](ivec2(0, 1), ivec2(0, 2), ivec2(0, 3), ivec2(0, 4)), int(1u)));
                uint _4056 = floatBitsToUint(_4054.x);
                uint _4058 = floatBitsToUint(_4054.y);
                uint _4060 = floatBitsToUint(_4054.z);
                uint _4062 = floatBitsToUint(_4054.w);
                uint _4065 = (_4021 << 3u) & 34952u;
                uint _4071 = (((_4065 | (30583u & (_4056 >> 1u))) | _4056) | (65535u ^ _4042)) & _3380;
                bool _4072 = _4071 != 0u;
                bool _4073;
                if (_4072)
                {
                    _4073 = true;
                }
                else
                {
                    _4073 = _3970;
                }
                uint _4074;
                if (_4072)
                {
                    _4074 = _3979;
                }
                else
                {
                    _4074 = _4065;
                }
                uint _4075;
                if (_4072)
                {
                    _4075 = _3380;
                }
                else
                {
                    _4075 = _4042;
                }
                uint _4353;
                uint _4354;
                uint _4355;
                bool _4356;
                if (!_4072)
                {
                    uint _4080 = (_4023 << 3u) & 34952u;
                    uint _4086 = (((_4080 | (30583u & (_4058 >> 1u))) | _4058) | (65535u ^ floatBitsToUint(_4040.y))) & _3380;
                    bool _4087 = _4086 != 0u;
                    uint _4121;
                    uint _4122;
                    bool _4123;
                    uint _4124;
                    uint _4125;
                    uint _4126;
                    uint _4127;
                    bool _4128;
                    bool _4129;
                    if (!_4087)
                    {
                        uint _4092 = (_4025 << 3u) & 34952u;
                        uint _4098 = (((_4092 | (30583u & (_4060 >> 1u))) | _4060) | (65535u ^ floatBitsToUint(_4040.z))) & _3380;
                        bool _4099 = _4098 != 0u;
                        uint _4114;
                        uint _4115;
                        bool _4116;
                        uint _4117;
                        uint _4118;
                        uint _4119;
                        bool _4120;
                        if (!_4099)
                        {
                            uint _4104 = (_4027 << 3u) & 34952u;
                            uint _4109 = ((_4104 | (30583u & (_4062 >> 1u))) | _4062) | (65535u ^ _4048);
                            uint _4110 = _4109 & _3380;
                            bool _4111 = _4110 != 0u;
                            bool _4112;
                            if (_4111)
                            {
                                _4112 = true;
                            }
                            else
                            {
                                _4112 = _4099;
                            }
                            uint _4113;
                            if (_4111)
                            {
                                _4113 = _3380;
                            }
                            else
                            {
                                _4113 = _4075;
                            }
                            _4114 = _4113;
                            _4115 = _4110;
                            _4116 = _4112;
                            _4117 = _4104;
                            _4118 = _4109;
                            _4119 = _3979 + 12u;
                            _4120 = _4111;
                        }
                        else
                        {
                            _4114 = _4075;
                            _4115 = _4098;
                            _4116 = _4099;
                            _4117 = _4027;
                            _4118 = _4048;
                            _4119 = _3979 + 8u;
                            _4120 = _4072;
                        }
                        _4121 = _4114;
                        _4122 = _4115;
                        _4123 = _4116;
                        _4124 = _4117;
                        _4125 = _4092;
                        _4126 = _4118;
                        _4127 = _4119;
                        _4128 = _4120;
                        _4129 = _4099;
                    }
                    else
                    {
                        _4121 = _4075;
                        _4122 = _4086;
                        _4123 = _4087;
                        _4124 = _4027;
                        _4125 = _4025;
                        _4126 = _4048;
                        _4127 = _3979 + 4u;
                        _4128 = _4072;
                        _4129 = false;
                    }
                    uint _4349;
                    uint _4350;
                    uint _4351;
                    bool _4352;
                    if (_4087 || (_4129 || (!_4128)))
                    {
                        uint _4232;
                        uint _4233;
                        uint _4234;
                        bool _4235;
                        uint _4236;
                        uint _4237;
                        uint _4238;
                        uint _4239;
                        uint _4240;
                        uint _4241;
                        uint _4242;
                        uint _4243;
                        uint _4244;
                        bool _4245;
                        if (!_4087)
                        {
                            uint _4218;
                            uint _4219;
                            uint _4220;
                            bool _4221;
                            uint _4222;
                            uint _4223;
                            uint _4224;
                            uint _4225;
                            uint _4226;
                            uint _4227;
                            uint _4228;
                            uint _4229;
                            uint _4230;
                            bool _4231;
                            if (!_4129)
                            {
                                uint _4135;
                                if (_3361)
                                {
                                    _4135 = 0u;
                                }
                                else
                                {
                                    _4135 = _4127;
                                }
                                uint _4136;
                                if (_3361)
                                {
                                    _4136 = 0u;
                                }
                                else
                                {
                                    _4136 = _4080;
                                }
                                uint _4137;
                                if (_3361)
                                {
                                    _4137 = 0u;
                                }
                                else
                                {
                                    _4137 = _4125;
                                }
                                uint _4138;
                                if (_3361)
                                {
                                    _4138 = 0u;
                                }
                                else
                                {
                                    _4138 = _4124;
                                }
                                precise float _4141 = fma(c0_1.data[9u], 4.0, _2231);
                                vec4 _4148 = uintBitsToFloat(textureGatherOffsets(cs_tex0_1f0, vec2(_2235, _4141), ivec2[](ivec2(0, 1), ivec2(0, 2), ivec2(0, 3), ivec2(0, 4))));
                                uint _4150 = floatBitsToUint(_4148.x);
                                uint _4152 = floatBitsToUint(_4148.y);
                                uint _4154 = floatBitsToUint(_4148.z);
                                uint _4156 = floatBitsToUint(_4148.w);
                                uint _4158;
                                if (!_3361)
                                {
                                    _4158 = _2236;
                                }
                                else
                                {
                                    _4158 = _4150;
                                }
                                uint _4160;
                                if (!_3361)
                                {
                                    _4160 = floatBitsToUint(_4141);
                                }
                                else
                                {
                                    _4160 = _4152;
                                }
                                uint _4178;
                                uint _4179;
                                uint _4180;
                                uint _4181;
                                if (!_3361)
                                {
                                    vec4 _4169 = uintBitsToFloat(textureGatherOffsets(cs_tex0_1f0, vec2(uintBitsToFloat(_4158), uintBitsToFloat(_4160)), ivec2[](ivec2(-1, 1), ivec2(-1, 2), ivec2(-1, 3), ivec2(-1, 4)), int(1u)));
                                    _4178 = floatBitsToUint(_4169.w);
                                    _4179 = floatBitsToUint(_4169.z);
                                    _4180 = floatBitsToUint(_4169.y);
                                    _4181 = floatBitsToUint(_4169.x);
                                }
                                else
                                {
                                    _4178 = _4156;
                                    _4179 = _4154;
                                    _4180 = _4160;
                                    _4181 = _4158;
                                }
                                uint _4183;
                                if (!_3361)
                                {
                                    _4183 = _4181;
                                }
                                else
                                {
                                    _4183 = _4135;
                                }
                                uint _4185;
                                if (!_3361)
                                {
                                    _4185 = _4180;
                                }
                                else
                                {
                                    _4185 = _4136;
                                }
                                uint _4187;
                                if (!_3361)
                                {
                                    _4187 = _4179;
                                }
                                else
                                {
                                    _4187 = _4137;
                                }
                                uint _4189;
                                if (!_3361)
                                {
                                    _4189 = _4178;
                                }
                                else
                                {
                                    _4189 = _4138;
                                }
                                vec4 _4195 = uintBitsToFloat(textureGatherOffsets(cs_tex0_1f0, vec2(_2235, _4141), ivec2[](ivec2(0, 1), ivec2(0, 2), ivec2(0, 3), ivec2(0, 4)), int(1u)));
                                uint _4197 = floatBitsToUint(_4195.x);
                                uint _4206 = (_4183 << 3u) & 34952u;
                                uint _4212 = (((_4206 | (30583u & (_4197 >> 1u))) | _4197) | (65535u ^ _4150)) & _3380;
                                bool _4213 = _4212 != 0u;
                                bool _4214;
                                if (_4213)
                                {
                                    _4214 = true;
                                }
                                else
                                {
                                    _4214 = _4123;
                                }
                                uint _4215;
                                if (_4213)
                                {
                                    _4215 = _3380;
                                }
                                else
                                {
                                    _4215 = _2236;
                                }
                                uint _4217;
                                if (_4213)
                                {
                                    _4217 = _3979 + 16u;
                                }
                                else
                                {
                                    _4217 = _4206;
                                }
                                _4218 = _4215;
                                _4219 = _4217;
                                _4220 = _4212;
                                _4221 = _4214;
                                _4222 = floatBitsToUint(_4195.w);
                                _4223 = _4189;
                                _4224 = _4156;
                                _4225 = floatBitsToUint(_4195.z);
                                _4226 = _4187;
                                _4227 = _4154;
                                _4228 = _4152;
                                _4229 = floatBitsToUint(_4195.y);
                                _4230 = _4185;
                                _4231 = _4213;
                            }
                            else
                            {
                                _4218 = _4121;
                                _4219 = _4127;
                                _4220 = _4122;
                                _4221 = _4123;
                                _4222 = _3987;
                                _4223 = _4124;
                                _4224 = _2232;
                                _4225 = _3985;
                                _4226 = _4125;
                                _4227 = _2236;
                                _4228 = _4126;
                                _4229 = 67109632u;
                                _4230 = _4080;
                                _4231 = _3361;
                            }
                            _4232 = _4218;
                            _4233 = _4219;
                            _4234 = _4220;
                            _4235 = _4221;
                            _4236 = _4222;
                            _4237 = _4223;
                            _4238 = _4224;
                            _4239 = _4225;
                            _4240 = _4226;
                            _4241 = _4227;
                            _4242 = _4228;
                            _4243 = _4229;
                            _4244 = _4230;
                            _4245 = _4231;
                        }
                        else
                        {
                            _4232 = _4121;
                            _4233 = _4127;
                            _4234 = _4122;
                            _4235 = _4123;
                            _4236 = _3987;
                            _4237 = _4124;
                            _4238 = _2232;
                            _4239 = _3985;
                            _4240 = _4125;
                            _4241 = _2236;
                            _4242 = _4126;
                            _4243 = 67109632u;
                            _4244 = _4080;
                            _4245 = _3361;
                        }
                        uint _4345;
                        uint _4346;
                        uint _4347;
                        bool _4348;
                        if (_4087 || (_4129 || (!_4245)))
                        {
                            uint _4269;
                            uint _4270;
                            uint _4271;
                            bool _4272;
                            bool _4273;
                            if (!_4087)
                            {
                                uint _4264;
                                uint _4265;
                                uint _4266;
                                bool _4267;
                                bool _4268;
                                if (!_4129)
                                {
                                    uint _4260 = (((((_4244 << 3u) & 34952u) | (30583u & (_4243 >> 1u))) | _4243) | (65535u ^ _4242)) & _3380;
                                    bool _4261 = _4260 != 0u;
                                    bool _4262;
                                    if (_4261)
                                    {
                                        _4262 = true;
                                    }
                                    else
                                    {
                                        _4262 = _4235;
                                    }
                                    uint _4263;
                                    if (_4261)
                                    {
                                        _4263 = _3380;
                                    }
                                    else
                                    {
                                        _4263 = _4232;
                                    }
                                    _4264 = _4263;
                                    _4265 = _3979 + 20u;
                                    _4266 = _4260;
                                    _4267 = _4262;
                                    _4268 = _4261;
                                }
                                else
                                {
                                    _4264 = _4232;
                                    _4265 = _4233;
                                    _4266 = _4234;
                                    _4267 = _4235;
                                    _4268 = _4245;
                                }
                                _4269 = _4264;
                                _4270 = _4265;
                                _4271 = _4266;
                                _4272 = _4267;
                                _4273 = _4268;
                            }
                            else
                            {
                                _4269 = _4232;
                                _4270 = _4233;
                                _4271 = _4234;
                                _4272 = _4235;
                                _4273 = _4245;
                            }
                            uint _4341;
                            uint _4342;
                            uint _4343;
                            bool _4344;
                            if (_4087 || (_4129 || (!_4273)))
                            {
                                uint _4297;
                                uint _4298;
                                uint _4299;
                                bool _4300;
                                bool _4301;
                                if (!_4087)
                                {
                                    uint _4292;
                                    uint _4293;
                                    uint _4294;
                                    bool _4295;
                                    bool _4296;
                                    if (!_4129)
                                    {
                                        uint _4288 = (((((_4240 << 3u) & 34952u) | (30583u & (_4239 >> 1u))) | _4239) | (65535u ^ _4241)) & _3380;
                                        bool _4289 = _4288 != 0u;
                                        bool _4290;
                                        if (_4289)
                                        {
                                            _4290 = true;
                                        }
                                        else
                                        {
                                            _4290 = _4272;
                                        }
                                        uint _4291;
                                        if (_4289)
                                        {
                                            _4291 = _3380;
                                        }
                                        else
                                        {
                                            _4291 = _4269;
                                        }
                                        _4292 = _4291;
                                        _4293 = _3979 + 24u;
                                        _4294 = _4288;
                                        _4295 = _4290;
                                        _4296 = _4289;
                                    }
                                    else
                                    {
                                        _4292 = _4269;
                                        _4293 = _4270;
                                        _4294 = _4271;
                                        _4295 = _4272;
                                        _4296 = _4273;
                                    }
                                    _4297 = _4292;
                                    _4298 = _4293;
                                    _4299 = _4294;
                                    _4300 = _4295;
                                    _4301 = _4296;
                                }
                                else
                                {
                                    _4297 = _4269;
                                    _4298 = _4270;
                                    _4299 = _4271;
                                    _4300 = _4272;
                                    _4301 = _4273;
                                }
                                uint _4337;
                                uint _4338;
                                uint _4339;
                                bool _4340;
                                if (_4087 || (_4129 || (!_4301)))
                                {
                                    uint _4325;
                                    uint _4326;
                                    uint _4327;
                                    bool _4328;
                                    if (!_4087)
                                    {
                                        uint _4321;
                                        uint _4322;
                                        uint _4323;
                                        bool _4324;
                                        if (!_4129)
                                        {
                                            uint _4316 = (((((_4237 << 3u) & 34952u) | (30583u & (_4236 >> 1u))) | _4236) | (65535u ^ _4238)) & _3380;
                                            bool _4317 = _4316 != 0u;
                                            uint _4320;
                                            if (!_4317)
                                            {
                                                _4320 = _3979 + 32u;
                                            }
                                            else
                                            {
                                                _4320 = _3979 + 28u;
                                            }
                                            _4321 = _3380;
                                            _4322 = _4320;
                                            _4323 = _4316;
                                            _4324 = _4317;
                                        }
                                        else
                                        {
                                            _4321 = _4297;
                                            _4322 = _4298;
                                            _4323 = _4299;
                                            _4324 = _4300;
                                        }
                                        _4325 = _4321;
                                        _4326 = _4322;
                                        _4327 = _4323;
                                        _4328 = _4324;
                                    }
                                    else
                                    {
                                        _4325 = _4297;
                                        _4326 = _4298;
                                        _4327 = _4299;
                                        _4328 = _4300;
                                    }
                                    uint _4335;
                                    bool _4336;
                                    if (_4087 || _4129)
                                    {
                                        uint _4331;
                                        bool _4332;
                                        if (!_4087)
                                        {
                                            _4331 = _3380;
                                            _4332 = true;
                                        }
                                        else
                                        {
                                            _4331 = _4325;
                                            _4332 = _4328;
                                        }
                                        uint _4333;
                                        bool _4334;
                                        if (_4087)
                                        {
                                            _4333 = _3380;
                                            _4334 = true;
                                        }
                                        else
                                        {
                                            _4333 = _4331;
                                            _4334 = _4332;
                                        }
                                        _4335 = _4333;
                                        _4336 = _4334;
                                    }
                                    else
                                    {
                                        _4335 = _4325;
                                        _4336 = _4328;
                                    }
                                    _4337 = _4335;
                                    _4338 = _4326;
                                    _4339 = _4327;
                                    _4340 = _4336;
                                }
                                else
                                {
                                    _4337 = _4297;
                                    _4338 = _4298;
                                    _4339 = _4299;
                                    _4340 = _4300;
                                }
                                _4341 = _4337;
                                _4342 = _4338;
                                _4343 = _4339;
                                _4344 = _4340;
                            }
                            else
                            {
                                _4341 = _4269;
                                _4342 = _4270;
                                _4343 = _4271;
                                _4344 = _4272;
                            }
                            _4345 = _4341;
                            _4346 = _4342;
                            _4347 = _4343;
                            _4348 = _4344;
                        }
                        else
                        {
                            _4345 = _4232;
                            _4346 = _4233;
                            _4347 = _4234;
                            _4348 = _4235;
                        }
                        _4349 = _4345;
                        _4350 = _4346;
                        _4351 = _4347;
                        _4352 = _4348;
                    }
                    else
                    {
                        _4349 = _4121;
                        _4350 = _4127;
                        _4351 = _4122;
                        _4352 = _4123;
                    }
                    _4353 = _4349;
                    _4354 = _4350;
                    _4355 = _4351;
                    _4356 = _4352;
                }
                else
                {
                    _4353 = _4075;
                    _4354 = _4074;
                    _4355 = _4071;
                    _4356 = _4073;
                }
                _4357 = _4353;
                _4358 = _4354;
                _4359 = _4355;
                _4360 = _4356;
            }
            else
            {
                _4357 = _3968;
                _4358 = _3973;
                _4359 = _3969;
                _4360 = _3970;
            }
            uint _4372;
            if (_4360)
            {
                _4372 = ((((-uint(findMSB(_4359))) + 31u) >> 2u) + (-(((-uint(findMSB(_4357))) + 31u) >> 2u))) + _4358;
            }
            else
            {
                _4372 = _4358;
            }
            uint _4373 = min(_4372, 31u);
            uint _4374 = _960 + _4373;
            uint _4376 = (_4374 & 3u) + 1u;
            uint _4378 = _4374 >> 2u;
            uint _4379 = _4378 + (_4376 >> 2u);
            uint _4402 = (3u & (~_4376)) << 2u;
            uint _4404;
            if (_3874)
            {
                _4404 = (-_966) + 2u;
            }
            else
            {
                _4404 = _4378;
            }
            uint _4405;
            if (_3874)
            {
                _4405 = 0u;
            }
            else
            {
                _4405 = 3u;
            }
            uint _4406;
            if (_3874)
            {
                _4406 = _4405;
            }
            else
            {
                _4406 = _4405;
            }
            uint _4409;
            if (_3874)
            {
                _4409 = (_4406 << 16u) + _4404;
            }
            else
            {
                _4409 = (-_966) + 6u;
            }
            uint _4424 = _4409 & 31u;
            uvec2 _4433 = unpackUint2x32(packUint2x32(uvec2((_3947 | (~240u)) & (240u | _3948), 0u)) >> min(_4424, 32u));
            uint _4434 = _4433.x;
            uvec2 _4439 = unpackUint2x32(packUint2x32(uvec2(((unpackUint2x32(packUint2x32(uvec2(floatBitsToUint(uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_3909, _4379) + uvec2(4294967295u, 0u)), int(0u))).y), 0u)) >> min(_4402, 32u)).x << 4u) | (~240u)) & (240u | (unpackUint2x32(packUint2x32(uvec2(floatBitsToUint(uintBitsToFloat(texelFetch(cs_tex0_1f0, ivec2(uvec2(_3909, _4379)), int(0u))).y), 0u)) >> min(_4402, 32u)).x & 15u)), 0u)) >> min(_4424, 32u));
            uint _4440 = _4439.x;
            uint _4447 = ((_4434 >> 2u) & 1u) + (_4434 & 2u);
            uint _4448 = ((_4440 >> 2u) & 1u) + (_4440 & 2u);
            vec4 _4466 = texelFetch(cs_tex0_200, ivec2(uvec2(((bitfieldExtract(_4447, int(16u), int(16u)) * 32u) << 16u) + ((bitfieldExtract(_4447, int(0u), int(16u)) * 32u) + _3902), ((bitfieldExtract(_4448, int(16u), int(16u)) * 32u) << 16u) + ((bitfieldExtract(_4448, int(0u), int(16u)) * 32u) + _4373))), int(0u));
            float _4468 = _4466.y;
            float _4470 = float(_3902);
            float _4471 = float(_4373);
            uint _4473 = (!(_4471 < _4470)) ? 1065353216u : 0u;
            uint _4475 = (!(_4470 < _4471)) ? 1065353216u : 0u;
            precise float _4480 = uintBitsToFloat(_4473) + uintBitsToFloat(_4475);
            precise float _4490 = (1.0 / _4480) * 0.75;
            precise float _4492 = uintBitsToFloat(_4473) * _4490;
            uint _4493 = floatBitsToUint(_4492);
            precise float _4495 = uintBitsToFloat(_4475) * _4490;
            uint _4496 = floatBitsToUint(_4495);
            precise float _4513 = _4466.x * CustomNumericMin(CustomNumericMax(fma(uintBitsToFloat(_4496 ^ 2147483648u), float(_4440 & 1u), fma(uintBitsToFloat(_4493 ^ 2147483648u), float(_4434 & 1u), 1.0)), 0.0), 1.0);
            precise float _4515 = _4468 * CustomNumericMin(CustomNumericMax(fma(uintBitsToFloat(_4496 ^ 2147483648u), float((_4440 >> 3u) & 1u), fma(uintBitsToFloat(_4493 ^ 2147483648u), float((_4434 >> 3u) & 1u), 1.0)), 0.0), 1.0);
            _4517 = floatBitsToUint(_4468);
            _4518 = floatBitsToUint(_4513);
            _4519 = floatBitsToUint(_4515);
        }
        else
        {
            _4517 = _965;
            _4518 = _3358;
            _4519 = _3360;
        }
        _4520 = _4517;
        _4521 = _4518;
        _4522 = _4519;
        _4523 = _3342;
        _4524 = _3343;
    }
    else
    {
        _4520 = _965;
        _4521 = _2213;
        _4522 = _2214;
        _4523 = _2207;
        _4524 = _2206;
    }
    precise float _4528 = uintBitsToFloat(_4524) * 255.0;
    precise float _4531 = uintBitsToFloat(_4523) * 255.0;
    precise float _4534 = uintBitsToFloat(_4522) * 255.0;
    precise float _4537 = uintBitsToFloat(_4521) * 255.0;
    uint _4545 = floatBitsToUint(_4528) & (((!isnan(_4528)) && (!isnan(_4528))) ? 4294967295u : 0u);
    uint _4559 = uint(CustomNumericMin(CustomNumericMax(roundEven(CustomNumericMin(uintBitsToFloat(_4545), 4294967040.0)), 0.0), 4294967296.0)) | ((uintBitsToFloat(_4545) >= 4294967296.0) ? 4294967295u : 0u);
    uint _4566 = floatBitsToUint(_4531) & (((!isnan(_4531)) && (!isnan(_4531))) ? 4294967295u : 0u);
    uint _4576 = uint(CustomNumericMin(CustomNumericMax(roundEven(CustomNumericMin(uintBitsToFloat(_4566), 4294967040.0)), 0.0), 4294967296.0)) | ((uintBitsToFloat(_4566) >= 4294967296.0) ? 4294967295u : 0u);
    uint _4583 = floatBitsToUint(_4534) & (((!isnan(_4534)) && (!isnan(_4534))) ? 4294967295u : 0u);
    uint _4593 = uint(CustomNumericMin(CustomNumericMax(roundEven(CustomNumericMin(uintBitsToFloat(_4583), 4294967040.0)), 0.0), 4294967296.0)) | ((uintBitsToFloat(_4583) >= 4294967296.0) ? 4294967295u : 0u);
    uint _4601 = floatBitsToUint(_4537) & (((!isnan(_4537)) && (!isnan(_4537))) ? 4294967295u : 0u);
    uint _4611 = uint(CustomNumericMin(CustomNumericMax(roundEven(CustomNumericMin(uintBitsToFloat(_4601), 4294967040.0)), 0.0), 4294967296.0)) | ((uintBitsToFloat(_4601) >= 4294967296.0) ? 4294967295u : 0u);
    bool _4612 = _4576 != 0u;
    bool _4613 = _4593 != 0u;
    uint _4615;
    if (_4612)
    {
        _4615 = _4576 << 8u;
    }
    else
    {
        _4615 = _4520;
    }
    uint _4617;
    if (_4612)
    {
        _4617 = _960 + 4294967295u;
    }
    else
    {
        _4617 = _4522;
    }
    uint _4624;
    if (_4613)
    {
        _4624 = _947 + 4294967295u;
    }
    else
    {
        _4624 = _4576;
    }
    if (_4613)
    {
        uint _4627 = imageAtomicOr(cs_img0_210, ivec2(uvec2(_4624, _960)), _4593);
    }
    if (_4612)
    {
        uint _4630 = imageAtomicOr(cs_img0_210, ivec2(uvec2(_947, _4617)), _4615);
    }
    if (!((_4559 != 0u) || ((_4611 != 0u) && (!(_4559 != 0u)))))
    {
        return;
    }
    uint _4637 = imageAtomicOr(cs_img0_210, ivec2(uvec2(_947, _960)), (_4611 << 16u) | (_4559 << 24u));
}
// CUSTOM COMPAT END: NMin/NMax call-name substitutions.

