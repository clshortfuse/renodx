#include "../tonemap.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[5];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = cb0[3].yyyy * float4(-0.006,-0.006,0,-0.006) + v1.xyxy;
  r1.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  if(injectedData.toneMapType != 0.f){
    r1 = saturate(r1);
    r0 = saturate(r0);
  }
  r1.xyz = r1.xyz * float3(2,2,2) + r0.xyz;
  r2.xyzw = cb0[3].yyyy * float4(0.006,-0.006,0.006,0) + v1.xyxy;
  r3.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
  r2.xyzw = t0.Sample(s0_s, r2.zw).xyzw;
  if(injectedData.toneMapType != 0.f){
    r3 = saturate(r3);
    r2 = saturate(r2);
  }
  r1.xyz = r3.xyz + r1.xyz;
  r0.xyz = -r3.xyz + r0.xyz;
  r3.xyzw = cb0[3].yyyy * float4(-0.006,0.006,0,0.006) + v1.xyxy;
  r4.xyzw = t0.Sample(s0_s, r3.xy).xyzw;
  r3.xyzw = t0.Sample(s0_s, r3.zw).xyzw;
  if(injectedData.toneMapType != 0.f){
    r4 = saturate(r4);
    r3 = saturate(r3);
  }
  r1.xyz = -r4.xyz + r1.xyz;
  r1.xyz = r3.xyz * float3(-2,-2,-2) + r1.xyz;
  r3.xy = cb0[3].yy * float2(0.006,0.006) + v1.xy;
  r3.xyzw = t0.Sample(s0_s, r3.xy).xyzw;
  if(injectedData.toneMapType != 0.f){
    r3 = saturate(r3);
  }
  r1.xyz = -r3.xyz + r1.xyz;
  r1.xyz = r1.xyz * r1.xyz;
  r5.xy = cb0[3].yy * float2(-0.006,0) + v1.xy;
  r5.xyzw = t0.Sample(s0_s, r5.xy).xyzw;
  if(injectedData.toneMapType != 0.f){
    r5 = saturate(r5);
  }
  r0.xyz = r5.xyz * float3(2,2,2) + r0.xyz;
  r0.xyz = r2.xyz * float3(-2,-2,-2) + r0.xyz;
  r0.xyz = r0.xyz + r4.xyz;
  r0.xyz = r0.xyz + -r3.xyz;
  r0.xyz = r0.xyz * r0.xyz + r1.xyz;
  r0.xyz = sqrt(r0.xyz);
  r0.w = step(r0.z, r0.y);
  r0.y = r0.y + -r0.z;
  r0.y = r0.w * r0.y + r0.z;
  r0.z = step(r0.y, r0.x);
  r0.x = r0.x + -r0.y;
  r0.x = r0.z * r0.x + r0.y;
  r0.yz = v1.xy * cb0[2].xy + cb0[2].zw;
  r1.xyzw = t0.Sample(s0_s, r0.yz).xyzw;    // sceneColor
  if(injectedData.toneMapType != 0.f){
    r0.yzw = saturate(r1.xyz) * saturate(r1.xyz) + -r1.xyz;
  } else {
    r0.yzw = r1.xyz * r1.xyz + -r1.xyz;
  }
  r0.yzw = cb0[3].xxx * r0.yzw + r1.xyz;
  r0.yzw = r0.yzw * cb0[4].xyz + -r1.xyz;
  o0.xyz = r0.xxx * r0.yzw + r1.xyz;
  o0.xyz = r1.xyz;
  o0.w = 1;
    o0.xyz = renodx::color::srgb::DecodeSafe(o0.xyz);
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
  o0.xyz = applyUserNoTonemap(o0.xyz);
  }
  if (injectedData.countOld == injectedData.countNew) {
  o0.xyz = PostToneMapScale(o0.xyz, true);
  } else {
    o0.xyz = renodx::color::srgb::EncodeSafe(o0.xyz);
  }
  return;
}