#include "../common.hlsli"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[171];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * cb0[163].zw + float2(0.5,0.5);
  r0.zw = frac(r0.xy);
  r0.xy = floor(r0.xy);
  r1.xy = r0.zw * float2(0.5,0.5) + float2(-1,-1);
  r1.zw = r0.zw * r0.zw;
  r1.xy = r1.zw * r1.xy + float2(0.666666687,0.666666687);
  r1.zw = float2(1,1) + -r1.xy;
  r2.xyzw = -r0.zwzw * float4(0.5,0.5,0.166666672,0.166666672) + float4(0.5,0.5,0.5,0.5);
  r2.xyzw = r0.zwzw * r2.xyzw + float4(0.5,0.5,-0.5,-0.5);
  r2.xyzw = r0.zwzw * r2.xyzw + float4(0.166666672,0.166666672,0.166666672,0.166666672);
  r0.zw = -r2.xy + r1.zw;
  r0.zw = r0.zw + -r2.zw;
  r1.zw = r2.xy + r0.zw;
  r2.xy = r2.zw + r1.xy;
  r2.zw = float2(1,1) / r1.zw;
  r3.xy = r0.zw * r2.zw + float2(1,1);
  r0.zw = float2(1,1) / r2.xy;
  r3.zw = r1.xy * r0.zw + float2(-1,-1);
  r4.xyzw = r3.zyxy + r0.xyxy;
  r0.xyzw = r3.zwxw + r0.xyxy;
  r0.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r0.xyzw;
  r0.xyzw = cb0[163].xyxy * r0.xyzw;
  r3.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r4.xyzw;
  r3.xyzw = cb0[163].xyxy * r3.xyzw;
  r4.xyzw = t2.SampleLevel(s2_s, r3.zw, 0).xyzw;
  r3.xyzw = t2.SampleLevel(s2_s, r3.xy, 0).xyzw;
  r4.xyz = r4.xyz * r1.zzz;
  r3.xyz = r2.xxx * r3.xyz + r4.xyz;
  r1.xyw = r3.xyz * r1.www;
  r3.xyzw = t2.SampleLevel(s2_s, r0.zw, 0).xyzw;
  r0.xyzw = t2.SampleLevel(s2_s, r0.xy, 0).xyzw;
  r3.xyz = r3.xyz * r1.zzz;
  r0.xyz = r2.xxx * r0.xyz + r3.xyz;
  r0.xyz = r2.yyy * r0.xyz + r1.xyw;
  r1.xyzw = t1.SampleBias(s1_s, v1.xy, cb0[5].x).xyzw;
  r0.xyz = r0.xyz * cb0[164].xxx * CUSTOM_BLOOM + r1.xyz;
  o0.w = max(cb0[169].w, r1.w);
  r0.xyz = cb0[170].xxx * r0.xyz;
  r0.xyz = cb0[166].yyy * r0.xyz;
  if(RENODX_TONE_MAP_TYPE == 0.f){
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.xyz = log2(r0.xyz);
  r0.xyz = cb0[166].xxx * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  } else {
    r0.xyz = renodx::math::SignPow(r0.xyz, cb0[166].x);
  }
  float3 untonemapped = r0.xyz;
  r0.xyz = Bt709AcesTonemap(r0.xyz);
  float y = renodx::color::y::from::BT709(untonemapped);
  r0.xyz = lerp(r0.xyz, untonemapped, exp(-y * cb0[165].w));
  r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  r1.xy = v1.xy * cb0[162].zw + cb0[131].xy;
  r1.xy = cb0[130].xy * r1.xy;
  r1.xyzw = t0.SampleBias(s0_s, r1.xy, cb0[5].x).xyzw;
  r1.xyz = float3(-0.5,-0.5,-0.5) + r1.xyz;
  r1.xyz = cb0[167].xxx * r1.xyz * CUSTOM_NOISE;
  r0.xyz = r1.xyz * (1.0 / 255.0) + r0.xyz;
  if(RENODX_TONE_MAP_TYPE == 0.f){
    r0.xyz = saturate(r0.xyz);
  }
  r1.xyz = cb0[169].xyz + -r0.xyz;
  r0.xyz = cb0[169].www * r1.xyz + r0.xyz;
  r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  r0.xyz = handleUserLUT(r0.xyz, t3, s2_s, float3(1 / 1024, 1 / 32, 31), 0, true);
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    r0.xyz = GradeAndDisplayMap(r0.xyz);
  }
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  return;
}