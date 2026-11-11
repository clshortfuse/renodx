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
  float _27;
  float _28;
  float _38;
  float3 _50;
  float _55;
  float _56;
  float _57;
  float _66;
  float _78;
  float _82;
  float _83;
  float _84;
  float _86;
  float _93;
  float4 _98;
  float _117;
  float _122;
  float _148;
  float _150;
  float _152;
  float4 _188;
  float _200;
  float _209;
  float _219;
  float _220;
  float _221;
  float _222;
  float4 _234;
  _27 = (TEXCOORD0_centroid.x + -0.5f) * 2.0f;
  _28 = _27 * _27;
  _38 = saturate(TEXCOORD0_centroid.y);
  _50 = t2.SampleLevel(s0, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  _55 = t0[0].SSkyLightingBuffer_000.x;
  _56 = t0[0].SSkyLightingBuffer_000.y;
  _57 = t0[0].SSkyLightingBuffer_000.z;
  _66 = (TEXCOORD0_centroid.x * 2.0f) + -1.0f;
  _78 = (TEXCOORD0_centroid.y * 2.0f) + -1.0f;
  _82 = (HDRLighting_144.x - (HDRLighting_112.x * _66)) - (HDRLighting_128.x * _78);
  _83 = (HDRLighting_144.y - (HDRLighting_112.y * _66)) - (HDRLighting_128.y * _78);
  _84 = (HDRLighting_144.z - (HDRLighting_112.z * _66)) - (HDRLighting_128.z * _78);
  _86 = rsqrt(dot(float3(_82, _83, _84), float3(_82, _83, _84)));
  _93 = saturate((dot(float3((_82 * _86), (_83 * _86), (_84 * _86)), float3(_55, _56, _57)) + -0.699999988079071f) * 3.3333332538604736f);
  _98 = t4.Sample(s0, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y));
  _117 = saturate((dot(float3((_50.x / cb1_836w), (_50.y / cb1_836w), (_50.z / cb1_836w)), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f)) - (HDRLighting_048.z * 100.0f)) / (HDRLighting_048.z * 900.0f));
  _122 = min(((_117 * _117) * (3.0f - (_117 * 2.0f))), ((_93 * _93) * (3.0f - (_93 * 2.0f))));
  _148 = (max(((((HDRLighting_048.x * _98.x) * _122) + 1.0f) * _50.x), 0.0f) + (((float3)(t3.SampleLevel(s0, float2(saturate(saturate(((((HDRLighting_124 * 8.0f) * _28) * cb1_092z) * cb1_836y) + TEXCOORD0_centroid.x)), _38), 0.0f))).x));
  _150 = (max(((((HDRLighting_048.x * _98.y) * _122) + 1.0f) * _50.y), 0.0f) + (((float3)(t3.SampleLevel(s0, float2(saturate(saturate(TEXCOORD0_centroid.x)), _38), 0.0f))).y));
  _152 = (max(((((HDRLighting_048.x * _98.z) * _122) + 1.0f) * _50.z), 0.0f) + (((float3)(t3.SampleLevel(s0, float2(saturate(saturate(((((HDRLighting_124 * -8.0f) * _28) * cb1_092z) * cb1_836y) + TEXCOORD0_centroid.x)), _38), 0.0f))).z));
  _148 = EncodeARRILUT(_148, cb2_005x, cb2_005y, cb2_005z);
  _150 = EncodeARRILUT(_150, cb2_005x, cb2_005y, cb2_005z);
  _152 = EncodeARRILUT(_152, cb2_005x, cb2_005y, cb2_005z);
  _188 = t6.SampleLevel(s1,
                        float3((cb2_007x * _148) + cb2_006w,
                               (cb2_007x * _150) + cb2_006w,
                               (cb2_007x * _152) + cb2_006w),
                        0.0f);
  _200 = ((HDRLighting_064.w * _78) * HDRLighting_048.w) * cb1_836y;
  _209 = log2(saturate(((sqrt((_200 * _200) + (_66 * _66)) - HDRLighting_064.x) / HDRLighting_064.y) + 0.5f));
  _219 = 1.0f - ((HDRLighting_064.z * 0.25f) * ((exp2(_209 * 2.0f) * 3.0f) - (exp2(_209 * 3.0f) * 2.0f)));
  _220 = _219 * _188.x;
  _221 = _219 * _188.y;
  _222 = _219 * _188.z;
#if 1  // custom code
  SV_Target.rgb = ApplyVanillaPQNoise(float3(_220, _221, _222), t1, SV_Position.xy, Global_1168.x, Global_1168.y);
#else  // original code
  _234 = t1.Load(int3(int(frac(Global_1168.y * SV_Position.x) * Global_1168.x), int(frac(Global_1168.y * SV_Position.y) * Global_1168.x), 0));
  SV_Target.x = (((0.03125f - (saturate(_220) * 0.015625f)) * (_234.x + -0.5f)) + _220);
  SV_Target.y = (((0.03125f - (saturate(_221) * 0.015625f)) * (_234.y + -0.5f)) + _221);
  SV_Target.z = (((0.03125f - (saturate(_222) * 0.015625f)) * (_234.z + -0.5f)) + _222);
#endif
  SV_Target.w = (1.0f - (((float4)(t5.Load(int3(int(SV_Position.x), int(SV_Position.y), 0)))).w));

  return SV_Target;
}
