#include "./postprocess.hlsl"
#include "./shared.h"

struct _WhitePtSrv {
  float data[1];
};
Buffer<uint4> WhitePtSrv : register(t0);

Texture3D<float2> BilateralLuminanceSRV : register(t1);

Texture2D<float> BlurredLogLumSRV : register(t2);

Texture2D<float4> RE_POSTPROCESS_Color : register(t3);

RWTexture2D<float3> OutputTex : register(u0);

cbuffer SceneInfo : register(b0) {
  float SceneInfo_023x : packoffset(c023.x);
  float SceneInfo_023y : packoffset(c023.y);
  float SceneInfo_023z : packoffset(c023.z);
  float SceneInfo_023w : packoffset(c023.w);
};

cbuffer RangeCompressInfo : register(b1) {
  float RangeCompressInfo_000x : packoffset(c000.x);
  float RangeCompressInfo_000y : packoffset(c000.y);
};

cbuffer Tonemap : register(b2) {
  float Tonemap_000x : packoffset(c000.x);
  uint Tonemap_001y : packoffset(c001.y);
  float Tonemap_003z : packoffset(c003.z);
  float Tonemap_003w : packoffset(c003.w);
  float Tonemap_004x : packoffset(c004.x);
  float Tonemap_004y : packoffset(c004.y);
  float Tonemap_004z : packoffset(c004.z);
  float Tonemap_004w : packoffset(c004.w);
  float Tonemap_005x : packoffset(c005.x);
};

SamplerState BilinearClamp : register(s5, space32);

/*
This shader is loaded in specific scenarios e.g: Sekiret gliding
It's used alongside postprocess_flatexposure
*/
[numthreads(8, 8, 1)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _14 = float((uint)SV_DispatchThreadID.x);
  float _15 = float((uint)SV_DispatchThreadID.y);
  float _45;
  if (((bool)(_14 < SceneInfo_023x)) && ((bool)(_15 < SceneInfo_023y))) {
    float4 _25 = RE_POSTPROCESS_Color.Load(int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), 0));
    // It'll be used alongside pp_flatexposure so we can't adjust scaling using vanilla
    if (CUSTOM_EXPOSURE_TYPE > 0.f) {
      // Return original without adjustments
      OutputTex[int2((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y))] = _25.rgb;
      return;
    }
    float _31 = RangeCompressInfo_000y * _25.x;
    float _32 = RangeCompressInfo_000y * _25.y;
    float _33 = RangeCompressInfo_000y * _25.z;
    do {
      if (!((uint)(Tonemap_001y) == 0)) {
        _45 = (asfloat((((int4)(asint(WhitePtSrv[0 / 4]))).x)));
      } else {
        _45 = 1.0f;
      }
      float _46 = _45 * Tonemap_000x;
      float _52 = log2((dot(float3((_46 * _31), (_46 * _32), (_46 * _33)), float3(0.25f, 0.5f, 0.25f))) + 9.999999747378752e-06f);
      float _58 = SceneInfo_023z * (_14 + 0.5f);
      float _59 = SceneInfo_023w * (_15 + 0.5f);
      float2 _69 = BilateralLuminanceSRV.SampleLevel(BilinearClamp, float3(_58, _59, ((((Tonemap_004z * _52) + Tonemap_004w) * 0.984375f) + 0.0078125f)), 0.0f);
      float _77 = (((bool)((_69.y) < 0.0010000000474974513f)) ? ((BlurredLogLumSRV.SampleLevel(BilinearClamp, float2(_58, _59), 0.0f)).x) : ((_69.x) / (_69.y)));
      float _83 = (Tonemap_005x + _77) + ((((BlurredLogLumSRV.SampleLevel(BilinearClamp, float2(_58, _59), 0.0f)).x) - _77) * 0.6000000238418579f);
      float _84 = Tonemap_005x + _52;
      float _87 = _83 - Tonemap_004y;
      float _99 = exp2(((((((bool)(_87 > 0.0f)) ? Tonemap_003z : Tonemap_003w) * _87) - _84) + Tonemap_004y) + (Tonemap_004x * (_84 - _83)));
      float _104 = (_99 * _31) * RangeCompressInfo_000x;
      OutputTex[int2((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y))] = float3(_104, ((_99 * _32) * RangeCompressInfo_000x), ((_99 * _33) * RangeCompressInfo_000x));

    } while (false);
  }
}
