#include "../common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[147];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.zw = float2(0,0);
  r1.xy = cb0[141].xy * v1.xy;
  r1.xy = (uint2)r1.xy;
  r2.xyzw = (int4)r1.xyxy + int4(0,-1,-1,0);
  r0.xy = r2.zw;
  r0.xyz = t0.Load(r0.xyz).xyz;
  r3.xyzw = (int4)r1.xyxy + int4(0,1,1,0);
  r4.xy = r3.zw;
  r4.zw = float2(0,0);
  r4.xyz = t0.Load(r4.xyz).xyz;
  r2.zw = float2(0,0);
  r2.xyz = t0.Load(r2.xyz).xyz;
  r3.zw = float2(0,0);
  r3.xyz = t0.Load(r3.xyz).xyz;
  r1.zw = float2(0,0);
  r1.xyzw = t0.Load(r1.xyz).xyzw;
  if(injectedData.toneMapType >= 2.f){
    r0.xyz /= (injectedData.toneMapPeakNits / injectedData.toneMapGameNits);
    r4.xyz /= (injectedData.toneMapPeakNits / injectedData.toneMapGameNits);
    r2.xyz /= (injectedData.toneMapPeakNits / injectedData.toneMapGameNits);
    r3.xyz /= (injectedData.toneMapPeakNits / injectedData.toneMapGameNits);
    r1.xyz /= (injectedData.toneMapPeakNits / injectedData.toneMapGameNits);
  } else if(injectedData.toneMapType == 1.f){
    r0.xyz /= 50.f;
    r4.xyz /= 50.f;
    r2.xyz /= 50.f;
    r3.xyz /= 50.f;
    r1.xyz /= 50.f;
  }
  r5.xyz = min(r4.xyz, r0.xyz);
  r5.xyz = min(r2.xyz, r5.xyz);
  r5.xyz = min(r5.xyz, r3.xyz);
  r6.xyz = r5.xyz * float3(4,4,4) + float3(-4,-4,-4);
  r6.xyz = rcp(r6.xyz);
  r7.xyz = max(r4.xyz, r0.xyz);
  r7.xyz = max(r7.xyz, r2.xyz);
  r7.xyz = max(r7.xyz, r3.xyz);
  r8.xyz = max(r7.xyz, r1.xyz);
  r7.xyz = float3(4,4,4) * r7.xyz;
  r7.xyz = rcp(r7.xyz);
  r8.xyz = float3(1,1,1) + -r8.xyz;
  r6.xyz = r8.xyz * r6.xyz;
  r5.xyz = min(r5.xyz, r1.xyz);
  r5.xyz = r5.xyz * r7.xyz;
  r5.xyz = max(-r5.xyz, r6.xyz);
  r0.w = max(r5.y, r5.z);
  r0.w = max(r5.x, r0.w);
  r0.w = min(0, r0.w);
  r0.w = max(-0.1875, r0.w);
  r0.w = cb0[146].x * r0.w;
  r0.xyz = r0.www * r0.xyz;
  r0.xyz = r0.www * r2.xyz + r0.xyz;
  r0.xyz = r0.www * r3.xyz + r0.xyz;
  r0.xyz = r0.www * r4.xyz + r0.xyz;
  r0.w = r0.w * 4 + 1;
  r0.xyz = r0.xyz + r1.xyz;
  o0.w = r1.w;
  r1.x = asfloat(2129764351u - asuint(r0.w));
  r0.w = -r1.x * r0.w + 2;
  r0.w = r1.x * r0.w;
  r0.xyz = r0.xyz * r0.www;
  if(injectedData.toneMapType >= 2.f){
    r0.xyz *= (injectedData.toneMapPeakNits / injectedData.toneMapGameNits);
  } else if(injectedData.toneMapType == 1.f){
    r0.xyz *= 50.f;
  }
  r1.xy = v1.xy * cb0[140].xy + cb0[140].zw;
  r0.w = t2.SampleBias(s1_s, r1.xy, cb0[29].x).w;
  r0.w = r0.w * 2 + -1;
  r1.x = 1 + -abs(r0.w);
  r0.w = r0.w >= 0 ? 1 : -1;
  r1.x = sqrt(r1.x);
  r1.x = 1 + -r1.x;
  r0.w = r1.x * r0.w;
  r0.xyz = applyDither(r0.xyz, r0.w * (1.0 / 255.0));
  if(injectedData.fxFilmGrainType == 0.f){
  r1.xy = v1.xy * cb0[139].xy + cb0[139].zw;
  r0.w = t1.SampleBias(s0_s, r1.xy, cb0[29].x).w;
  r0.w = -0.5 + r0.w;
  r0.w = r0.w + r0.w;
  r1.xyz = r0.xyz * r0.www;
  r1.xyz = cb0[138].xxx * r1.xyz * injectedData.fxFilmGrain;
  r0.w = renodx::color::y::from::BT709(saturate(r0.xyz));
  r0.w = sqrt(r0.w);
  r0.w = cb0[138].y * -r0.w + 1;
  r0.xyz = r1.xyz * r0.www + r0.xyz;
  } else {
    r0.xyz = applyFilmGrain(r0.xyz, v1);
  }
  if(injectedData.toneMapType != 0.f){
    r0.xyz = renodx::color::bt709::clamp::AP1(r0.xyz);
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz, true);
  } else {
    r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  }
  if(injectedData.toneMapType == 0.f){
    r0.xyz = ((asuint(r0.x) & 0x7FFFFFFF) > 0x7F800000) || ((asuint(r0.y) & 0x7FFFFFFF) > 0x7F800000) || ((asuint(r0.z) & 0x7FFFFFFF) > 0x7F800000) ? float3(0,0,0) : r0.xyz;
  }
  o0.xyz = r0.xyz;
  return;
}