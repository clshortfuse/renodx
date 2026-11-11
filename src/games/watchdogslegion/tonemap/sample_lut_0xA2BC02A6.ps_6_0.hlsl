#include "tonemap.hlsli"

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

Texture2D<float4> t0 : register(t0);

Texture2D<float3> t1 : register(t1);

Texture2D<float3> t2 : register(t2);

Texture2D<float4> t3 : register(t3);

Texture3D<float4> t4 : register(t4);

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
  float cb1_005x : packoffset(c005.x);
  float cb1_005y : packoffset(c005.y);
  float cb1_005z : packoffset(c005.z);
  float cb1_006w : packoffset(c006.w);
  float cb1_007x : packoffset(c007.x);
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
  float3 _14;
  float3 _18;
  float _38;
  float _40;
  float _42;
  float4 _78;
  float4 _93;
  _14 = t2.SampleLevel(s0, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  _18 = t1.SampleLevel(s0, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  _38 = ((max(_18.x, 0.0f) + _14.x));
  _40 = ((max(_18.y, 0.0f) + _14.y));
  _42 = ((max(_18.z, 0.0f) + _14.z));
  _38 = EncodeARRILUT(_38, cb1_005x, cb1_005y, cb1_005z);
  _40 = EncodeARRILUT(_40, cb1_005x, cb1_005y, cb1_005z);
  _42 = EncodeARRILUT(_42, cb1_005x, cb1_005y, cb1_005z);
  _78 = t4.SampleLevel(s1,
                       float3(((cb1_007x * _38) + cb1_006w),
                              ((cb1_007x * _40) + cb1_006w),
                              ((cb1_007x * _42) + cb1_006w)),
                       0.0f);
#if 1  // custom code
  SV_Target.rgb = ApplyVanillaPQNoise(float3(_78.x, _78.y, _78.z), t0, SV_Position.xy, Global_1168.x, Global_1168.y);
#else  // original code
  _93 = t0.Load(int3(int(frac(Global_1168.y * SV_Position.x) * Global_1168.x), int(frac(Global_1168.y * SV_Position.y) * Global_1168.x), 0));
  SV_Target.x = (((0.03125f - (saturate(_78.x) * 0.015625f)) * (_93.x + -0.5f)) + _78.x);
  SV_Target.y = (((0.03125f - (saturate(_78.y) * 0.015625f)) * (_93.y + -0.5f)) + _78.y);
  SV_Target.z = (((0.03125f - (saturate(_78.z) * 0.015625f)) * (_93.z + -0.5f)) + _78.z);
#endif
  SV_Target.w = (1.0f - (((float4)(t3.Load(int3(int(SV_Position.x), int(SV_Position.y), 0)))).w));
  return SV_Target;
}
