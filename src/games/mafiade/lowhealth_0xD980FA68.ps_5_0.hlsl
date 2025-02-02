#include "./common.hlsl"

Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[4];
}
cbuffer cb0 : register(b0){
  float4 cb0[4];
}

#define cmp -

void main(
  float4 v0 : SV_Position0,
  float4 v1 : VDATA0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb1[0].y * 7 + 1;
  r0.yz = -v1.yz * cb1[3].xy + v1.yz;
  r1.xy = cb1[3].xy + r0.yz;
  r2.xyz = t0.Sample(s0_s, r1.xy).xyz;
  r3.xyz = t5.Sample(s0_s, r1.xy).xyz;
  r4.xyz = t1.Sample(s0_s, r1.xy).xyz;
  r1.xyz = t3.Sample(s0_s, r1.xy).xyz;
  r5.xyz = saturate(r0.xxx * float3(1,0.5,0.25) + float3(-1,-1,-1));
  r3.xyz = r3.xyz + -r2.xyz;
  r2.xyz = r5.xxx * r3.xyz + r2.xyz;
  r3.xyz = r4.xyz + -r2.xyz;
  r2.xyz = r5.yyy * r3.xyz + r2.xyz;
  r1.xyz = -r2.xyz + r1.xyz;
  r1.xyz = r5.zzz * r1.xyz + r2.xyz;
  r2.xyz = t0.Sample(s0_s, r0.yz).xyz;
  r3.xyz = t5.Sample(s0_s, r0.yz).xyz;
  r4.xyz = t1.Sample(s0_s, r0.yz).xyz;
  r0.xyz = t3.Sample(s0_s, r0.yz).xyz;
  r3.xyz = r3.xyz + -r2.xyz;
  r2.xyz = r5.xxx * r3.xyz + r2.xyz;
  r3.xyz = r4.xyz + -r2.xyz;
  r2.xyz = r5.yyy * r3.xyz + r2.xyz;
  r0.xyz = -r2.xyz + r0.xyz;
  r0.xyz = r5.zzz * r0.xyz + r2.xyz;
  r0.xyz = r1.xyz + r0.xyz;
  r0.xyz = float3(0.5,0.5,0.5) * r0.xyz;
  r0.w = 1;
  r1.x = dot(cb0[1].xyzw, r0.xyzw);
  r1.y = dot(cb0[2].xyzw, r0.xyzw);
  r1.z = dot(cb0[3].xyzw, r0.xyzw);
  r0.xyz = max(float3(0,0,0), r1.xyz);
  r0.xyz = cb1[1].xyz * r0.xyz;
  r1.xyz = float3(-1,-1,-1) + cb1[2].xyz;
  r1.xyz = saturate(v1.xxx * r1.xyz + float3(1,1,1));
  r0.xyz = r1.xyz * r0.xyz;
  r1.x = t4.Sample(s0_s, v1.yz).x;
  r2.xyzw = t0.Sample(s0_s, v1.yz).xyzw;
  r1.x = 1 + -r1.x;
  r1.x = saturate(cb1[0].x * r1.x);
  r0.w = 1;
  r0.xyzw = -r2.xyzw + r0.xyzw;
  r0.xyzw = r1.xxxx * r0.xyzw + r2.xyzw;
  // Sensor Noise
  r1.x = cmp(0 < cb0[0].z);
  if (r1.x != 0) {
    r1.xy = cb0[0].xy + v0.xy;
    r1.xy = (int2)r1.xy;
    r1.xy = (int2)r1.xy & int2(63,63);
    r1.zw = float2(0,0);
    r1.xyz = t2.Load(r1.xyz).xyz;
    r1.xyz = r1.xyz * float3(2,2,2) + float3(-1,-1,-1);
      r2.rgb = renodx::math::SignSqrt(r0.rgb);
    r3.xyz = cb0[0].www + r2.xyz;
    r3.xyz = min(cb0[0].zzz, r3.xyz);
    r1.xyz = r1.xyz * r3.xyz * injectedData.fxNoise + r2.xyz;
      r0.rgb = renodx::color::gamma::DecodeSafe(r1.rgb, 2.f);
  }
      r0.rgb = PostToneMapScale(r0.rgb);
  o0.xyzw = r0.xyzw;
  return;
}