#include "tonemap.hlsli"

struct SCameraDistances {
  float SCameraDistances_000;
  float SCameraDistances_004;
  float SCameraDistances_008;
  float SCameraDistances_012;
};

struct SGlobalDebugValues {
  float SGlobalDebugValues_000;
  float SGlobalDebugValues_004;
  float SGlobalDebugValues_008;
  float SGlobalDebugValues_012;
};

struct SGlobalScalars {
  float SGlobalScalars_000;
  float SGlobalScalars_004;
  float SGlobalScalars_008;
};

struct SLCMFrustumPlanes {
  float4 SLCMFrustumPlanes_000[6];
};

struct SSkyLightingBuffer {
  float4 SSkyLightingBuffer_000;
  float4 SSkyLightingBuffer_016;
  float4 SSkyLightingBuffer_032;
  float4 SSkyLightingBuffer_048;
  float4 SSkyLightingBuffer_064;
  float4 SSkyLightingBuffer_080;
  float3 SSkyLightingBuffer_096[6];
  float2 SSkyLightingBuffer_168;
  float3 SSkyLightingBuffer_176[6];
  float2 SSkyLightingBuffer_248;
  float4 SSkyLightingBuffer_256[3];
  float4 SSkyLightingBuffer_304[9];
  float4 SSkyLightingBuffer_448[9];
  float4 SSkyLightingBuffer_592[3];
  float4 SSkyLightingBuffer_640[6];
};

StructuredBuffer<SSkyLightingBuffer> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float3> t2 : register(t2);

Texture2D<float3> t3 : register(t3);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t5 : register(t5);

Texture3D<float4> t6 : register(t6);

cbuffer cb0 : register(b0) {
  float4 Global_000 : packoffset(c000.x);
  float4 Global_016 : packoffset(c001.x);
  float4 Global_032 : packoffset(c002.x);
  float4 Global_048[29] : packoffset(c003.x);
  float4 Global_512[29] : packoffset(c032.x);
  float4 Global_976 : packoffset(c061.x);
  float4 Global_992 : packoffset(c062.x);
  float4 Global_1008 : packoffset(c063.x);
  float4 Global_1024[2] : packoffset(c064.x);
  SGlobalDebugValues Global_1056 : packoffset(c066.x);
  float3 Global_1072 : packoffset(c067.x);
  float Global_1084 : packoffset(c067.w);
  float3 Global_1088 : packoffset(c068.x);
  float Global_1100 : packoffset(c068.w);
  float3 Global_1104 : packoffset(c069.x);
  float Global_1116 : packoffset(c069.w);
  float3 Global_1120 : packoffset(c070.x);
  float Global_1132 : packoffset(c070.w);
  float3 Global_1136 : packoffset(c071.x);
  float Global_1148 : packoffset(c071.w);
  SGlobalScalars Global_1152 : packoffset(c072.x);
  float Global_1164 : packoffset(c072.w);
  float2 Global_1168 : packoffset(c073.x);
  float Global_1176 : packoffset(c073.z);
  float Global_1180 : packoffset(c073.w);
  float2 Global_1184 : packoffset(c074.x);
  float Global_1192 : packoffset(c074.z);
  float Global_1196 : packoffset(c074.w);
  float2 Global_1200 : packoffset(c075.x);
  float Global_1208 : packoffset(c075.z);
  float Global_1212 : packoffset(c075.w);
  float2 Global_1216 : packoffset(c076.x);
  float Global_1224 : packoffset(c076.z);
  float2 Global_1232 : packoffset(c077.x);
};

cbuffer cb1 : register(b1) {
  float cb1_092x : packoffset(c092.x);
  float cb1_092z : packoffset(c092.z);
  float cb1_836y : packoffset(c836.y);
  float cb1_836w : packoffset(c836.w);
};

cbuffer cb2 : register(b2) {
  float cb2_005x : packoffset(c005.x);
  float cb2_005y : packoffset(c005.y);
  float cb2_005z : packoffset(c005.z);
  float cb2_006w : packoffset(c006.w);
  float cb2_007x : packoffset(c007.x);
};

cbuffer cb3 : register(b3) {
  float4 HDRLighting_000 : packoffset(c000.x);
  float4 HDRLighting_016 : packoffset(c001.x);
  float4 HDRLighting_032 : packoffset(c002.x);
  float4 HDRLighting_048 : packoffset(c003.x);
  float4 HDRLighting_064 : packoffset(c004.x);
  float4 HDRLighting_080 : packoffset(c005.x);
  float4 HDRLighting_096 : packoffset(c006.x);
  float3 HDRLighting_112 : packoffset(c007.x);
  float HDRLighting_124 : packoffset(c007.w);
  float3 HDRLighting_128 : packoffset(c008.x);
  float HDRLighting_140 : packoffset(c008.w);
  float3 HDRLighting_144 : packoffset(c009.x);
  float HDRLighting_156 : packoffset(c009.w);
  float3 HDRLighting_160 : packoffset(c010.x);
  float HDRLighting_172 : packoffset(c010.w);
  float3 HDRLighting_176 : packoffset(c011.x);
  float HDRLighting_188 : packoffset(c011.w);
  float HDRLighting_192 : packoffset(c012.x);
  float HDRLighting_196 : packoffset(c012.y);
  float HDRLighting_200 : packoffset(c012.z);
  float HDRLighting_204 : packoffset(c012.w);
  float HDRLighting_208 : packoffset(c013.x);
  float HDRLighting_212 : packoffset(c013.y);
  float HDRLighting_216 : packoffset(c013.z);
  float HDRLighting_220 : packoffset(c013.w);
  float HDRLighting_224 : packoffset(c014.x);
  float HDRLighting_228 : packoffset(c014.y);
};

SamplerState s0 : register(s0);

SamplerState s1 : register(s1);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}
uint firstbithigh_msb(uint value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}

float4 main(
    linear float2 TEXCOORD0_centroid: TEXCOORD0_centroid,
    precise noperspective float4 SV_Position: SV_Position) : SV_Target {
  float4 SV_Target;
  float _20;
  float _22;
  float _24;
  float _44;
  float _47;
  float _48;
  float _61;
  float _62;
  float _66;
  float _72;
  float3 _84;
  float _89;
  float _90;
  float _91;
  float _100;
  float _112;
  float _116;
  float _117;
  float _118;
  float _120;
  float _127;
  float4 _132;
  float _151;
  float _156;
  float _182;
  float _184;
  float _186;
  float4 _222;
  float _233;
  float _238;
  float _247;
  float _256;
  float _257;
  uint _262;
  uint _264;
  uint _267;
  uint _270;
  uint _274;
  uint _277;
  uint _287;
  uint _291;
  uint _294;
  float _312;
  float _313;
  float _314;
  float _315;
  float4 _327;
  _20 = TEXCOORD0_centroid.x + -0.5f;
  _22 = TEXCOORD0_centroid.y + -0.5f;
  _24 = (_22 * _22) + (_20 * _20);
  _44 = (1.0f / max(((((HDRLighting_140 * 0.7071067690849304f) + HDRLighting_156) * 0.5f) + 1.0f), ((((HDRLighting_140 * 0.5f) + HDRLighting_156) * 0.25f) + 1.0f))) * ((((HDRLighting_140 * sqrt(_24)) + HDRLighting_156) * _24) + 1.0f);
  _47 = (_44 * _20) + 0.5f;
  _48 = (_44 * _22) + 0.5f;
  _61 = _47 - TEXCOORD0_centroid.x;
  _62 = _48 - TEXCOORD0_centroid.y;
  _66 = (dot(float2(_61, _62), float2(_61, _62)) * 0.5f) * cb1_092x;
  _72 = saturate(_48);
  _84 = t2.SampleLevel(s0, float2(_47, _48), 0.0f);
  _89 = t0[0].SSkyLightingBuffer_000.x;
  _90 = t0[0].SSkyLightingBuffer_000.y;
  _91 = t0[0].SSkyLightingBuffer_000.z;
  _100 = (_47 * 2.0f) + -1.0f;
  _112 = (_48 * 2.0f) + -1.0f;
  _116 = (HDRLighting_144.x - (HDRLighting_112.x * _100)) - (HDRLighting_128.x * _112);
  _117 = (HDRLighting_144.y - (HDRLighting_112.y * _100)) - (HDRLighting_128.y * _112);
  _118 = (HDRLighting_144.z - (HDRLighting_112.z * _100)) - (HDRLighting_128.z * _112);
  _120 = rsqrt(dot(float3(_116, _117, _118), float3(_116, _117, _118)));
  _127 = saturate((dot(float3((_116 * _120), (_117 * _120), (_118 * _120)), float3(_89, _90, _91)) + -0.699999988079071f) * 3.3333332538604736f);
  _132 = t4.Sample(s0, float2(_47, _48));
  _151 = saturate((dot(float3((_84.x / cb1_836w), (_84.y / cb1_836w), (_84.z / cb1_836w)), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f)) - (HDRLighting_048.z * 100.0f)) / (HDRLighting_048.z * 900.0f));
  _156 = min(((_151 * _151) * (3.0f - (_151 * 2.0f))), ((_127 * _127) * (3.0f - (_127 * 2.0f))));
  _182 = ((max(((((HDRLighting_048.x * _132.x) * _156) + 1.0f) * _84.x), 0.0f) + (((float3)(t3.SampleLevel(s0, float2(saturate(saturate(((((HDRLighting_124 * 8.0f) * cb1_092z) * cb1_836y) * _66) + _47)), _72), 0.0f))).x)));
  _184 = ((max(((((HDRLighting_048.x * _132.y) * _156) + 1.0f) * _84.y), 0.0f) + (((float3)(t3.SampleLevel(s0, float2(saturate(saturate(_47)), _72), 0.0f))).y)));
  _186 = ((max(((((HDRLighting_048.x * _132.z) * _156) + 1.0f) * _84.z), 0.0f) + (((float3)(t3.SampleLevel(s0, float2(saturate(saturate(((((HDRLighting_124 * -8.0f) * cb1_092z) * cb1_836y) * _66) + _47)), _72), 0.0f))).z)));
  _182 = EncodeARRILUT(_182, cb2_005x, cb2_005y, cb2_005z);
  _184 = EncodeARRILUT(_184, cb2_005x, cb2_005y, cb2_005z);
  _186 = EncodeARRILUT(_186, cb2_005x, cb2_005y, cb2_005z);
  _222 = t6.SampleLevel(s1,
                        float3(((cb2_007x * _182) + cb2_006w),
                               ((cb2_007x * _184) + cb2_006w),
                               ((cb2_007x * _186) + cb2_006w)),
                        0.0f);
  _233 = (TEXCOORD0_centroid.x * 2.0f) + -1.0f;
  _238 = ((HDRLighting_064.w * ((TEXCOORD0_centroid.y * 2.0f) + -1.0f)) * HDRLighting_048.w) * cb1_836y;
  _247 = log2(saturate(((sqrt((_238 * _238) + (_233 * _233)) - HDRLighting_064.x) / HDRLighting_064.y) + 0.5f));
  _256 = (HDRLighting_064.z * -0.25f) * ((exp2(_247 * 2.0f) * 3.0f) - (exp2(_247 * 3.0f) * 2.0f));
  _257 = _256 + 1.0f;
  _262 = uint(floor(SV_Position.y) * 9973.0f);
  _264 = uint(Global_1152.SGlobalScalars_000 * 10.0f);
  _267 = (int)(uint(floor(SV_Position.x))) * 1664525;
  _270 = ((_264 + 11u) + _267) + _262;
  _274 = ((_270 ^ 61) ^ ((uint)(_270) >> 16)) * 9;
  _277 = (((uint)(_274) >> 4) ^ _274) * 668265261;
  _287 = (_267 + _264) + _262;
  _291 = ((_287 ^ 61) ^ ((uint)(_287) >> 16)) * 9;
  _294 = (((uint)(_291) >> 4) ^ _291) * 668265261;
  _312 = ((HDRLighting_188 * 0.5f) * ((HDRLighting_192 * ((-0.0f - _256) - _257)) + _257)) * ((((((float)((uint)((uint)(((uint)(_277) >> 15) ^ _277)))) * 4.656612873077393e-10f) + -1.0f) * saturate(1.0f - _256)) + ((((float)((uint)((uint)(((uint)(_294) >> 15) ^ _294)))) * 4.656612873077393e-10f) + -1.0f));
  _313 = _312 + (_257 * _222.x);
  _314 = _312 + (_257 * _222.y);
  _315 = _312 + (_257 * _222.z);
#if 1  // custom code
  SV_Target.rgb = ApplyVanillaPQNoise(float3(_313, _314, _315), t1, SV_Position.xy, Global_1168.x, Global_1168.y);
#else  // original code
  _327 = t1.Load(int3(int(frac(Global_1168.y * SV_Position.x) * Global_1168.x), int(frac(Global_1168.y * SV_Position.y) * Global_1168.x), 0));
  SV_Target.x = (_313 + ((0.03125f - (saturate(_313) * 0.015625f)) * (_327.x + -0.5f)));
  SV_Target.y = (_314 + ((0.03125f - (saturate(_314) * 0.015625f)) * (_327.y + -0.5f)));
  SV_Target.z = (_315 + ((0.03125f - (saturate(_315) * 0.015625f)) * (_327.z + -0.5f)));
#endif
  SV_Target.w = (1.0f - (((float4)(t5.Load(int3(int(SV_Position.x), int(SV_Position.y), 0)))).w));
  return SV_Target;
}
