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

ByteAddressBuffer t2 : register(t2);

Texture2D<float3> t3 : register(t3);

Texture2D<float3> t4 : register(t4);

Texture2D<float4> t5 : register(t5);

Texture2D<float4> t6 : register(t6);

Texture3D<float4> t7 : register(t7);

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
  float _28;
  float _29;
  float _39;
  float3 _51;
  float _56;
  float _57;
  float _58;
  float _67;
  float _79;
  float _83;
  float _84;
  float _85;
  float _87;
  float _94;
  float4 _99;
  float _118;
  float _123;
  int _140;
  float _146;
  float _163;
  float _165;
  float _167;
  float4 _203;
  float _215;
  float _224;
  float _234;
  float _235;
  float _236;
  float _237;
  float4 _249;
  _28 = (TEXCOORD0_centroid.x + -0.5f) * 2.0f;
  _29 = _28 * _28;
  _39 = saturate(TEXCOORD0_centroid.y);
  _51 = t3.SampleLevel(s0, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  _56 = t0[0].SSkyLightingBuffer_000.x;
  _57 = t0[0].SSkyLightingBuffer_000.y;
  _58 = t0[0].SSkyLightingBuffer_000.z;
  _67 = (TEXCOORD0_centroid.x * 2.0f) + -1.0f;
  _79 = (TEXCOORD0_centroid.y * 2.0f) + -1.0f;
  _83 = (HDRLighting_144.x - (HDRLighting_112.x * _67)) - (HDRLighting_128.x * _79);
  _84 = (HDRLighting_144.y - (HDRLighting_112.y * _67)) - (HDRLighting_128.y * _79);
  _85 = (HDRLighting_144.z - (HDRLighting_112.z * _67)) - (HDRLighting_128.z * _79);
  _87 = rsqrt(dot(float3(_83, _84, _85), float3(_83, _84, _85)));
  _94 = saturate((dot(float3((_83 * _87), (_84 * _87), (_85 * _87)), float3(_56, _57, _58)) + -0.699999988079071f) * 3.3333332538604736f);
  _99 = t5.Sample(s0, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y));
  _118 = saturate((dot(float3((_51.x / cb1_836w), (_51.y / cb1_836w), (_51.z / cb1_836w)), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f)) - (HDRLighting_048.z * 100.0f)) / (HDRLighting_048.z * 900.0f));
  _123 = min(((_118 * _118) * (3.0f - (_118 * 2.0f))), ((_94 * _94) * (3.0f - (_94 * 2.0f))));
  _140 = t2.Load4(28).x;
  _146 = ((asfloat(_140) - cb1_836w) * HDRLighting_172) + cb1_836w;
  _163 = ((((max(((((HDRLighting_048.x * _99.x) * _123) + 1.0f) * _51.x), 0.0f) + (((float3)(t4.SampleLevel(s0, float2(saturate(saturate(((((HDRLighting_124 * 8.0f) * _29) * cb1_092z) * cb1_836y) + TEXCOORD0_centroid.x)), _39), 0.0f))).x)) / cb1_836w) * 1.0f) * _146);
  _165 = ((((max(((((HDRLighting_048.x * _99.y) * _123) + 1.0f) * _51.y), 0.0f) + (((float3)(t4.SampleLevel(s0, float2(saturate(saturate(TEXCOORD0_centroid.x)), _39), 0.0f))).y)) / cb1_836w) * 1.0f) * _146);
  _167 = ((_146 * 1.0f) * ((max(((((HDRLighting_048.x * _99.z) * _123) + 1.0f) * _51.z), 0.0f) + (((float3)(t4.SampleLevel(s0, float2(saturate(saturate(((((HDRLighting_124 * -8.0f) * _29) * cb1_092z) * cb1_836y) + TEXCOORD0_centroid.x)), _39), 0.0f))).z)) / cb1_836w));
  _163 = EncodeARRILUT(_163, cb2_005x, cb2_005y, cb2_005z);
  _165 = EncodeARRILUT(_165, cb2_005x, cb2_005y, cb2_005z);
  _167 = EncodeARRILUT(_167, cb2_005x, cb2_005y, cb2_005z);
  _203 = t7.SampleLevel(s1,
                        float3(((cb2_007x * _163) + cb2_006w),
                               ((cb2_007x * _165) + cb2_006w),
                               ((cb2_007x * _167) + cb2_006w)),
                        0.0f);
  _215 = ((HDRLighting_064.w * _79) * HDRLighting_048.w) * cb1_836y;
  _224 = log2(saturate(((sqrt((_215 * _215) + (_67 * _67)) - HDRLighting_064.x) / HDRLighting_064.y) + 0.5f));
  _234 = 1.0f - ((HDRLighting_064.z * 0.25f) * ((exp2(_224 * 2.0f) * 3.0f) - (exp2(_224 * 3.0f) * 2.0f)));
  _235 = _234 * _203.x;
  _236 = _234 * _203.y;
  _237 = _234 * _203.z;
#if 1  // custom code
  SV_Target.rgb = ApplyVanillaPQNoise(float3(_235, _236, _237), t1, SV_Position.xy, Global_1168.x, Global_1168.y);
#else  // original code
  _249 = t1.Load(int3(int(frac(Global_1168.y * SV_Position.x) * Global_1168.x), int(frac(Global_1168.y * SV_Position.y) * Global_1168.x), 0));
  SV_Target.x = (((0.03125f - (saturate(_235) * 0.015625f)) * (_249.x + -0.5f)) + _235);
  SV_Target.y = (((0.03125f - (saturate(_236) * 0.015625f)) * (_249.y + -0.5f)) + _236);
  SV_Target.z = (((0.03125f - (saturate(_237) * 0.015625f)) * (_249.z + -0.5f)) + _237);
#endif
  SV_Target.w = (1.0f - (((float4)(t6.Load(int3(int(SV_Position.x), int(SV_Position.y), 0)))).w));
  return SV_Target;
}
