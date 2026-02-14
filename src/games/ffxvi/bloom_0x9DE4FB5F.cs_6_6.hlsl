#include "./shared.h"

// clang-format off
struct cCommon_Struct {
  float4 cCommon_Struct_000[3];
  int2 cCommon_Struct_048;
  float2 cCommon_Struct_056;
  int2 cCommon_Struct_064;
  float2 cCommon_Struct_072;
  int2 cCommon_Struct_080;
  float2 cCommon_Struct_088;
  float2 cCommon_Struct_096;
  float2 cCommon_Struct_104;
  float2 cCommon_Struct_112;
  float2 cCommon_Struct_120;
  float cCommon_Struct_128;
  float cCommon_Struct_132;
  float cCommon_Struct_136;
  int cCommon_Struct_140;
  int cCommon_Struct_144;
  int cCommon_Struct_148;
  float cCommon_Struct_152;
  float cCommon_Struct_156;
  float cCommon_Struct_160;
  float3 cCommon_Struct_164;
  float3 cCommon_Struct_176;
  float cCommon_Struct_188;
  float cCommon_Struct_192;
  float cCommon_Struct_196;
  int cCommon_Struct_200;
  float cCommon_Struct_204;
  float cCommon_Struct_208;
  float cCommon_Struct_212;
  float cCommon_Struct_216;
  float cCommon_Struct_220;
  float cCommon_Struct_224;
  int cCommon_Struct_228;
  int cCommon_Struct_232;
  float cCommon_Struct_236;
  float cCommon_Struct_240;
  float3 cCommon_Struct_244;
  struct CharaLight {
    float3 CharaLight_000;
    float CharaLight_012;
    float3 CharaLight_016;
    float CharaLight_028;
  } cCommon_Struct_256[4];
  float4 cCommon_Struct_384;
  float3 cCommon_Struct_400;
  float cCommon_Struct_412;
  float4 cCommon_Struct_416;
  float4 cCommon_Struct_432;
  float3 cCommon_Struct_448;
  float cCommon_Struct_460;
  float cCommon_Struct_464;
  int cCommon_Struct_468;
  int cCommon_Struct_472;
  int cCommon_Struct_476;
  int2 cCommon_Struct_480;
  int2 cCommon_Struct_488;
  float cCommon_Struct_496;
  float cCommon_Struct_500;
  float cCommon_Struct_504;
  int cCommon_Struct_508;
  int cCommon_Struct_512;
  int cCommon_Struct_516;
  int cCommon_Struct_520;
  float cCommon_Struct_524;
  struct TranslucentApproximateDepthParameter {
    int TranslucentApproximateDepthParameter_000;
    float TranslucentApproximateDepthParameter_004;
    int TranslucentApproximateDepthParameter_008;
    int TranslucentApproximateDepthParameter_012;
  } cCommon_Struct_528;
  int4 cCommon_Struct_544[1];
  float cCommon_Struct_560;
  int cCommon_Struct_564;
  float2 cCommon_Struct_568;
};
// clang-format on

Texture2D<float4> t0 : register(t0);

RWTexture2D<float4> u0 : register(u0);

cbuffer cb0 : register(b0) {
  cCommon_Struct cCommon_000 : packoffset(c000.x);
};

// clang-format off
cbuffer cb1 : register(b1) {
  struct cConstant0_Struct {
    struct BrightParameter {
      float BrightParameter_000;
      float BrightParameter_004;
      int2 BrightParameter_008;
    } cConstant0_Struct_000;
    struct BloomParameter {
      float BloomParameter_000;
      int3 BloomParameter_004;
    } cConstant0_Struct_016;
    struct StarParameter {
      float4 StarParameter_000[8];
      float StarParameter_128;
      int StarParameter_132;
      int StarParameter_136;
      int StarParameter_140;
    } cConstant0_Struct_032;
  } cConstant0_000 : packoffset(c000.x);
};
// clang-format on

SamplerState s0 : register(s0);

[numthreads(8, 8, 1)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  bool _12 = ((uint)cCommon_000.cCommon_Struct_064.x <= (uint)(uint)(SV_DispatchThreadID.x));
  bool _13 = ((uint)cCommon_000.cCommon_Struct_064.y <= (uint)(uint)(SV_DispatchThreadID.y));
  bool _14 = _12 || _13;
  if (!_14) {
    float _17 = float((uint)(SV_DispatchThreadID.x));
    float _18 = float((uint)(SV_DispatchThreadID.y));
    float _19 = _17 + 0.5f;
    float _20 = _18 + 0.5f;
    float _24 = cCommon_000.cCommon_Struct_088.x * _19;
    float _25 = cCommon_000.cCommon_Struct_088.y * _20;
    float _29 = _24 * cCommon_000.cCommon_Struct_104.x;
    float _30 = _25 * cCommon_000.cCommon_Struct_104.y;
    float4 _33 = t0.SampleLevel(s0, float2(_29, _30), 0.0f);
    float4 _37 = t0.SampleLevel(s0, float2(_29, _30), 1.0f);
    float _41 = _37.x + _33.x;
    float _42 = _37.y + _33.y;
    float _43 = _37.z + _33.z;
    float4 _44 = t0.SampleLevel(s0, float2(_29, _30), 2.0f);
    float _48 = _41 + _44.x;
    float _49 = _42 + _44.y;
    float _50 = _43 + _44.z;
    float4 _51 = t0.SampleLevel(s0, float2(_29, _30), 3.0f);
    float _55 = _48 + _51.x;
    float _56 = _49 + _51.y;
    float _57 = _50 + _51.z;
    float4 _58 = t0.SampleLevel(s0, float2(_29, _30), 4.0f);
    float _62 = _55 + _58.x;
    float _63 = _56 + _58.y;
    float _64 = _57 + _58.z;
    float4 _65 = t0.SampleLevel(s0, float2(_29, _30), 5.0f);
    float _69 = _62 + _65.x;
    float _70 = _63 + _65.y;
    float _71 = _64 + _65.z;
    float _72 = _69 * 0.1666666716337204f;
    float _73 = _70 * 0.1666666716337204f;
    float _74 = _71 * 0.1666666716337204f;
    float _77 = _72 * cConstant0_000.cConstant0_Struct_016.BloomParameter_000;
    float _78 = _73 * cConstant0_000.cConstant0_Struct_016.BloomParameter_000;
    float _79 = _74 * cConstant0_000.cConstant0_Struct_016.BloomParameter_000;

    float3 bloom_color = float3(_77, _78, _79) * CUSTOM_BLOOM;

    float4 _81 = u0.Load(int2((uint2)(SV_DispatchThreadID.xy)));

    if (cConstant0_000.cConstant0_Struct_016.BloomParameter_000 > 0.f) {
      float mid_gray_bloomed = (0.18 + renodx::color::y::from::BT709(bloom_color)) / 0.18;

      float scene_luminance = renodx::color::y::from::BT709(_81.rgb) * mid_gray_bloomed;
      float bloom_blend = saturate(smoothstep(0.f, 0.18f, scene_luminance));
      float3 bloom_scaled = lerp(0.f, bloom_color, bloom_blend);
      bloom_color = lerp(bloom_color, bloom_scaled, CUSTOM_BLOOM_SCALING * 0.5f);
    }

    float3 bloom_output = _81.rgb + bloom_color;

    u0[int2((uint2)(SV_DispatchThreadID.xy))] = float4(bloom_output, _81.w);
  }
}
