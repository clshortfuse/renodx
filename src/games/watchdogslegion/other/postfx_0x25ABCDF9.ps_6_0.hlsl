#include "other.hlsli"

struct SCameraDistances {
  float SCameraDistances_000;
  float SCameraDistances_004;
  float SCameraDistances_008;
  float SCameraDistances_012;
};

struct SLCMFrustumPlanes {
  float4 SLCMFrustumPlanes_000[6];
};


Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

cbuffer cb0 : register(b0) {
  float cb0_092z : packoffset(c092.z);
  float cb0_092w : packoffset(c092.w);
};

cbuffer cb1 : register(b1) {
  float4 PostFxGeneric_000 : packoffset(c000.x);
  float4 PostFxGeneric_016 : packoffset(c001.x);
  float4 PostFxGeneric_032 : packoffset(c002.x);
  float4 PostFxGeneric_048 : packoffset(c003.x);
  float2 PostFxGeneric_064 : packoffset(c004.x);
  float PostFxGeneric_072 : packoffset(c004.z);
  float PostFxGeneric_076 : packoffset(c004.w);
  float PostFxGeneric_080 : packoffset(c005.x);
  float PostFxGeneric_084 : packoffset(c005.y);
  float PostFxGeneric_088 : packoffset(c005.z);
  float PostFxGeneric_092 : packoffset(c005.w);
  int PostFxGeneric_096 : packoffset(c006.x);
};

cbuffer cb2 : register(b2) {
  float4 HDROutput_000 : packoffset(c000.x);
  float4 HDROutput_016 : packoffset(c001.x);
  float HDROutput_032 : packoffset(c002.x);
  float HDROutput_036 : packoffset(c002.y);
  float HDROutput_040 : packoffset(c002.z);
  float HDROutput_044 : packoffset(c002.w);
  float HDROutput_048 : packoffset(c003.x);
  float HDROutput_052 : packoffset(c003.y);
  float HDROutput_056 : packoffset(c003.z);
  float HDROutput_060 : packoffset(c003.w);
  float HDROutput_064 : packoffset(c004.x);
  float HDROutput_068 : packoffset(c004.y);
  float HDROutput_072 : packoffset(c004.z);
  float HDROutput_076 : packoffset(c004.w);
  float HDROutput_080 : packoffset(c005.x);
  float HDROutput_084 : packoffset(c005.y);
};

SamplerState s0 : register(s0);

SamplerState s1 : register(s1);

SamplerState s2 : register(s2);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  linear float2 TEXCOORD0_centroid : TEXCOORD0_centroid,
  precise noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float _69;
  float _70;
  float _71;
  float _34;
  float _35;
  float _40;
  float _41;
  float _42;
  float _43;
  float _44;
  float _45;
  float _61;
  float _85;
  float _86;
  float _89;
  float _93;
  float _95;
  float _96;
  float _104;
  float _105;
  float _106;
  float _109;
  float _110;
  float _114;
  float _118;
  float _119;
  float _120;
  float _121;
  float _126;
  float _129;
  float _135;
  float _161;
  float _162;
  float _163;
  float _196;
  float _197;
  float _198;
  float _209;
  float _210;
  float _211;
  float _212;
  float _213;
  float _214;
  float _235;
  float _236;
  float _239;
  float _242;
  float _245;
  float _264;
  float _277;
  float _290;
  if (PostFxGeneric_088 > 0.0f) {
    _34 = PostFxGeneric_088 * 0.00390625f;
    _35 = PostFxGeneric_088 * 0.0069444444961845875f;
    _40 = (PostFxGeneric_088 * 0.0078125f) * floor((128.0f / PostFxGeneric_088) * TEXCOORD0_centroid.x);
    _41 = (PostFxGeneric_088 * 0.013888888992369175f) * floor((72.0f / PostFxGeneric_088) * TEXCOORD0_centroid.y);
    _42 = _40 + _34;
    _43 = _41 + _35;
    _44 = _42 + _34;
    _45 = _43 + _35;
    _61 = select(((((((((float4)(t0.Sample(s1, float2(_44, _41)))).x) + (((float4)(t0.Sample(s1, float2(_40, _41)))).x)) + (((float4)(t0.Sample(s1, float2(_40, _45)))).x)) + (((float4)(t0.Sample(s1, float2(_44, _45)))).x)) + (((float4)(t0.Sample(s1, float2(_42, _43)))).x)) < 0.10000000149011612f), 0.0f, 1.0f);
    _69 = ((_61 * (_42 - TEXCOORD0_centroid.x)) + TEXCOORD0_centroid.x);
    _70 = ((_61 * (_43 - TEXCOORD0_centroid.y)) + TEXCOORD0_centroid.y);
    _71 = _61;
  } else {
    _69 = TEXCOORD0_centroid.x;
    _70 = TEXCOORD0_centroid.y;
    _71 = 0.0f;
  }
  _85 = (_69 * 2.0f) + -1.0f;
  _86 = (_70 * 2.0f) + -1.0f;
  _89 = saturate(PostFxGeneric_076);
  _93 = ((_86 * _86) + (_85 * _85)) + _89;
  _95 = select((_93 > 1.9900000095367432f), 1.9900000095367432f, _93);
  _96 = 2.0f - _95;
  _104 = (((_89 * _89) * _95) * select((_96 > 0.009999999776482582f), ((0.11342184245586395f / _96) + -1.0f), -1.0f)) + 1.0f;
  _105 = _104 * _85;
  _106 = _104 * _86;
  _109 = (_105 * 0.5f) + 0.5f;
  _110 = (_106 * 0.5f) + 0.5f;
  _114 = select((_96 < 0.009999999776482582f), -0.055000003427267075f, ((1.9500000476837158f - _95) * 1.100000023841858f));
  _118 = 1.0f - saturate(PostFxGeneric_076);
  _119 = _118 * _118;
  _120 = _119 * _119;
  _121 = _120 * _120;
  _126 = abs(_105);
  _129 = abs(_106);
  _135 = 1.0f - _71;

  float diffuse_white = (RENODX_TONE_MAP_TYPE == 0.f) ? HDROutput_064 : RENODX_DIFFUSE_WHITE_NITS; 

  _161 = exp2(log2(abs(((float4)(t1.Sample(s0, float2((_109 - (((_135 * 2.0f) * _95) * cb0_092z)), _110)))).x)) * 0.012683313339948654f);
  _162 = exp2(log2(abs(((float4)(t1.Sample(s0, float2(_109, _110)))).y)) * 0.012683313339948654f);
  _163 = exp2(log2(abs(((float4)(t1.Sample(s0, float2(((((_135 * 4.0f) * _95) * cb0_092z) + _109), _110)))).z)) * 0.012683313339948654f);
  _196 = (exp2(log2(abs(max((_161 + -0.8359375f), 0.0f) / (18.8515625f - (_161 * 18.6875f)))) * 6.277394771575928f) * 10000.0f) / diffuse_white;
  _197 = (exp2(log2(abs(max((_162 + -0.8359375f), 0.0f) / (18.8515625f - (_162 * 18.6875f)))) * 6.277394771575928f) * 10000.0f) / diffuse_white;
  _198 = (exp2(log2(abs(max((_163 + -0.8359375f), 0.0f) / (18.8515625f - (_163 * 18.6875f)))) * 6.277394771575928f) * 10000.0f) / diffuse_white;
  _209 = ((((float4)(t2.Sample(s2, float2((PostFxGeneric_032.x + (TEXCOORD0_centroid.x * 5.0f)), (PostFxGeneric_032.y + (TEXCOORD0_centroid.y * 5.0f)))))).x) * 0.10000000149011612f) + 0.949999988079071f;
  _210 = mad(-0.07280000299215317f, _198, mad(-0.5875999927520752f, _197, (_196 * 1.6605000495910645f))) * _209;
  _211 = mad(-0.008299999870359898f, _198, mad(1.1328999996185303f, _197, (_196 * -0.12460000067949295f))) * _209;
  _212 = mad(1.1187000274658203f, _198, mad(-0.1005999967455864f, _197, (_196 * -0.018200000748038292f))) * _209;
  _213 = saturate(PostFxGeneric_000.w);
  _214 = dot(float3(_210, _211, _212), float3(0.30000001192092896f, 0.10999999940395355f, 0.5899999737739563f));
  _235 = (saturate(saturate((1.0f - (_129 * _129)) * (1.0f - (_126 * _126)))) * 0.7200000286102295f) + 0.4000000059604645f;
  _236 = (((_121 * _121) * (1.0f - _114)) + _114) * (((frac((_70 / cb0_092w) * 0.25f) * 0.20000000298023224f) * ((floor(frac((_69 / cb0_092z) * 0.5f) * 2.0f) * 0.20000000298023224f) + 0.800000011920929f)) + 0.800000011920929f);
  _239 = ((_236 * saturate(PostFxGeneric_000.x)) * (lerp(_210, _214, _213))) * _235;
  _242 = ((_236 * saturate(PostFxGeneric_000.y)) * (lerp(_211, _214, _213))) * _235;
  _245 = ((_236 * saturate(PostFxGeneric_000.z)) * (lerp(_212, _214, _213))) * _235;
  _264 = exp2(log2(abs((mad(0.043299999088048935f, _245, mad(0.3292999863624573f, _242, (_239 * 0.6273999810218811f))) * 9.999999747378752e-05f) * diffuse_white)) * 0.1593017578125f);
  _277 = exp2(log2(abs((mad(0.01140000019222498f, _245, mad(0.9194999933242798f, _242, (_239 * 0.06909999996423721f))) * 9.999999747378752e-05f) * diffuse_white)) * 0.1593017578125f);
  _290 = exp2(log2(abs((mad(0.8956000208854675f, _245, mad(0.08799999952316284f, _242, (_239 * 0.01640000008046627f))) * 9.999999747378752e-05f) * diffuse_white)) * 0.1593017578125f);
  SV_Target.x = exp2(log2(abs(((_264 * 18.8515625f) + 0.8359375f) / ((_264 * 18.6875f) + 1.0f))) * 78.84375f);
  SV_Target.y = exp2(log2(abs(((_277 * 18.8515625f) + 0.8359375f) / ((_277 * 18.6875f) + 1.0f))) * 78.84375f);
  SV_Target.z = exp2(log2(abs(((_290 * 18.8515625f) + 0.8359375f) / ((_290 * 18.6875f) + 1.0f))) * 78.84375f);
  SV_Target.w = 1.0f;
  return SV_Target;
}