#include "../../common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[8];
}
cbuffer cb0 : register(b0){
  float4 cb0[23];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.xw = float2(0,0);
  r1.yz = cb0[2].yx;
  r2.xyz = v2.xyw + -r1.xyx;
  r2.xyzw = t1.SampleLevel(s1_s, r2.xy, r2.z).xyzw;
  r2.x = cb1[7].x * r2.x + cb1[7].y;
  r2.x = 1 / r2.x;
  r2.yzw = v2.xyw + -r1.zww;
  r3.xyzw = t1.SampleLevel(s1_s, r2.yz, r2.w).xyzw;
  r2.y = cb1[7].x * r3.x + cb1[7].y;
  r2.y = 1 / r2.y;
  r3.xyz = v2.xyw + r1.zww;
  r3.xyzw = t1.SampleLevel(s1_s, r3.xy, r3.z).xyzw;
  r2.z = cb1[7].x * r3.x + cb1[7].y;
  r2.z = 1 / r2.z;
  r3.xyz = v2.xyw + r1.xyx;
  r3.xyzw = t1.SampleLevel(s1_s, r3.xy, r3.z).xyzw;
  r2.w = cb1[7].x * r3.x + cb1[7].y;
  r2.w = 1 / r2.w;
  r3.x = max(r2.w, r2.x);
  r3.x = max(r3.x, r2.y);
  r3.x = max(r3.x, r2.z);
  r2.x = min(r2.w, r2.x);
  r2.x = min(r2.x, r2.y);
  r2.x = min(r2.x, r2.z);
  r2.x = r3.x + -r2.x;
  r3.xyzw = v1.xyxy + -r1.xyzw;
  r4.xyzw = t0.Sample(s0_s, r3.xy).xyzw;
  r3.xyzw = t0.Sample(s0_s, r3.zw).xyzw;
  r1.xyzw = v1.xyxy + r1.zwxy;
  r5.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  r1.x = renodx::color::y::from::NTSC1953(r1.xyz);
  r1.y = renodx::color::y::from::NTSC1953(r5.xyz);
  r1.z = renodx::color::y::from::NTSC1953(r3.xyz);
  r1.w = renodx::color::y::from::NTSC1953(r4.xyz);
  r2.z = max(r1.x, r1.w);
  r2.z = max(r2.z, r1.z);
  r2.z = max(r2.z, r1.y);
  r3.x = min(r1.x, r1.w);
  r3.x = min(r3.x, r1.z);
  r3.x = min(r3.x, r1.y);
  r3.x = -9.99999997e-07 + r3.x;
  if (cb0[22].y < r2.x) {
    r4.xyzw = r1.xzxz + -r1.wywy;
    r1.xyzw = cb0[22].xxxx * r4.xyzw;
    r1.xyzw = max(-cb0[22].wwww, r1.xyzw);
    r1.xyzw = min(cb0[22].wwww, r1.xyzw);
    r2.w = saturate(cb0[22].z * r2.w);
    r2.w = 1 + -r2.w;
    r4.xyzw = cb0[2].xyxy * r2.wwww;
    r1.xyzw = r4.xyzw * r1.xyzw;
    r4.xyzw = -r1.xyzw * float4(0.166666999,0.166666999,0.5,0.5) + v1.xyxy;
    r5.xyzw = t0.Sample(s0_s, r4.xy).xyzw;
    r1.xyzw = r1.xyzw * float4(0.166666999,0.166666999,0.5,0.5) + v1.xyxy;
    r6.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
    r3.yzw = r6.xyz + r5.xyz;
    r4.xyzw = t0.Sample(s0_s, r4.zw).xyzw;
    r4.xyz = r4.xyz + r3.yzw;
    r1.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
    r1.xyz = r4.xyz + r1.xyz;
    r1.xyz = float3(0.25,0.25,0.25) * r1.xyz;
    r1.w = renodx::color::y::from::NTSC1953(r1.xyz);
    r3.yzw = float3(0.5,0.5,0.5) * r3.yzw;
    r1.xyz = (r1.w < r3.x) || (r1.w > r2.z) ? r3.yzw : r1.xyz;
  } else {
    if(injectedData.toneMapType == 0.f){
    r0.xyz = max(float3(0,0,0), r0.xyz);
    r1.xyz = min(float3(8,8,8), r0.xyz);
    } else {
      r1.xyz = min(8.f, max(0.f, r0.xyz));
    }
  }
  r0.x = renodx::color::y::from::NTSC1953(r1.xyz);
  r0.x = r0.x * 2 + -r3.x;
  r0.x = r0.x + -r2.z;
  r0.y = -r3.x + r2.z;
  r0.y = saturate(cb0[9].w / r0.y);
  r0.z = -cb0[10].z + r2.y;
  r0.z = cb0[10].w / abs(r0.z);
  r1.w = r0.z > 1 ? 1.000000 : 0;
  r0.z = saturate(cb0[17].z * r0.z);
  r0.z = max(r1.w, r0.z);
  r1.w = 9.99999975e-06 + r2.x;
  r1.w = saturate(cb0[9].y / r1.w);
  r0.x = r0.x * r0.y;
  r0.x = r0.x * r1.w;
  r0.x = cb0[9].x * r0.x;
  r0.x = max(-cb0[9].z, r0.x);
  r0.x = min(cb0[9].z, r0.x);
  r0.x = r0.x * r0.z + 1;
  r0.xyz = r1.xyz * r0.xxx;
  r3.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r2.xzw = cb0[15].xxx * r3.xyz * injectedData.fxBloom;
  r0.xyz = r0.xyz + r2.xzw;
  r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  r1.x = max(r0.y, r0.z);
  r1.x = max(r1.x, r0.x);
  r1.y = min(r0.y, r0.z);
  r1.y = min(r1.y, r0.x);
  if(injectedData.toneMapType != 0.f){
    r1.y = max(0.f, r1.y);
  }
  r1.x = saturate(r1.x + -r1.y);
  r1.x = 1 + -r1.x;
  r1.x = cb0[7].z * r1.x;
  r1.y = renodx::color::y::from::NTSC1953(r0.xyz);
  r1.yzw = -r1.yyy + r0.xyz;
  r1.xyz = r1.xxx * r1.yzw + float3(1,1,1);
  r0.xyz = r1.xyz * r0.xyz;
  r1.xyz = r0.xyz * cb0[12].xyz + -r0.xyz;
  r0.xyz = cb0[12].www * r1.xyz + r0.xyz;
  r0.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
  r0.xyz = r0.xyz * cb0[7].yyy + float3(0.5,0.5,0.5);
  r0.xyz = cb0[7].xxx * r0.xyz;
  r1.xy = cb1[6].xy * v1.xy;
  r1.x = dot(float2(171,231), r1.xy);
  r1.xyz = float3(0.00970873795,0.0140845068,0.010309278) * r1.xxx;
  r1.xyz = frac(r1.xyz);
  r1.xyz = float3(-0.5,-0.5,-0.5) + r1.xyz;
  r1.w = step(cb0[10].y, r2.y);
  r1.xyz = r1.xyz * r1.www;
  r1.xyz = cb0[10].xxx * r1.xyz + float3(1,1,1);
  o0.xyz = r1.xyz * r0.xyz;
  o0.w = r0.w;
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = renodx::color::srgb::DecodeSafe(o0.xyz);
    o0.xyz = PostToneMapScale(o0.xyz, true);
  }
  return;
}