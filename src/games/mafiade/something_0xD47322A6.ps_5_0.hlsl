#include "./common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[1];
}
cbuffer cb0 : register(b0){
  float4 cb0[2];
}

#define cmp -

void main(
  float4 v0 : SV_Position0,
  float4 v1 : VDATA0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 0.5 + cb1[0].y;
  r0.xy = -cb0[0].xy * r0.xx + v1.xy;
  r1.xyz = t0.SampleLevel(s0_s, r0.xy, 0).xyz;
  r2.xyz = t0.SampleLevel(s0_s, r0.xy, 0, int2(1, 0)).xyz;
  r3.xyz = t0.SampleLevel(s0_s, r0.xy, 0, int2(0, 1)).xyz;
  r0.xyz = t0.SampleLevel(s0_s, r0.xy, 0, int2(1, 1)).xyz;
  r4.xyz = t0.SampleLevel(s0_s, v1.xy, 0).xyz;
    r0.w = renodx::color::y::from::BT709(r1.rgb);
    r1.x = renodx::color::y::from::BT709(r2.rgb);
    r1.y = renodx::color::y::from::BT709(r3.rgb);
    r0.x = renodx::color::y::from::BT709(r0.rgb);
    r0.y = renodx::color::y::from::BT709(r4.rgb);
  r0.z = min(r1.x, r0.w);
  r1.z = min(r1.y, r0.x);
  r0.z = min(r1.z, r0.z);
  r0.z = min(r0.y, r0.z);
  r1.z = max(r1.x, r0.w);
  r1.w = max(r1.y, r0.x);
  r1.z = max(r1.z, r1.w);
  r0.y = max(r1.z, r0.y);
  r1.z = r1.x + r0.w;
  r1.xw = r1.xy + r0.xx;
  r1.w = r1.z + -r1.w;
  r2.xz = -r1.ww;
  r0.w = r1.y + r0.w;
  r2.yw = r0.ww + -r1.xx;
  r0.w = r1.z + r1.y;
  r0.x = r0.w + r0.x;
  r0.x = 0.03125 * r0.x;
  r0.x = max(0.0078125, r0.x);
  r0.w = min(abs(r2.w), abs(r1.w));
  r0.x = r0.w + r0.x;
  r0.x = 1 / r0.x;
  r1.xyzw = r2.xyzw * r0.xxxx;
  r1.xyzw = max(float4(-8,-8,-8,-8), r1.xyzw);
  r1.xyzw = min(float4(8,8,8,8), r1.xyzw);
  r1.xyzw = cb0[0].xyxy * r1.xyzw;
  r2.xyzw = r1.zwzw * float4(-0.166666672,-0.166666672,0.166666672,0.166666672) + v1.xyxy;
  r3.xyz = t0.SampleLevel(s0_s, r2.xy, 0).xyz;
  r2.xyz = t0.SampleLevel(s0_s, r2.zw, 0).xyz;
  r2.xyz = r3.xyz + r2.xyz;
  r3.xyz = float3(0.5,0.5,0.5) * r2.xyz;
  r1.xyzw = r1.xyzw * float4(-0.5,-0.5,0.5,0.5) + v1.xyxy;
  r4.xyz = t0.SampleLevel(s0_s, r1.xy, 0).xyz;
  r1.xyz = t0.SampleLevel(s0_s, r1.zw, 0).xyz;
  r1.xyz = r4.xyz + r1.xyz;
  r1.xyz = float3(0.25,0.25,0.25) * r1.xyz;
  r1.xyz = r2.xyz * float3(0.25,0.25,0.25) + r1.xyz;
    r0.x = renodx::color::y::from::BT709(r1.rgb);
  r0.z = cmp(r0.x < r0.z);
  r0.x = cmp(r0.y < r0.x);
  r0.x = (int)r0.x | (int)r0.z;
  r0.xyz = r0.xxx ? r3.xyz : r1.xyz;
  r0.w = cmp(0 < cb0[1].z);
  if (r0.w != 0) {
    r1.xy = cb0[1].xy + v0.xy;
    r1.xy = (int2)r1.xy;
    r1.xy = (int2)r1.xy & int2(63,63);
    r1.zw = float2(0,0);
    r1.xyz = t1.Load(r1.xyz).xyz;
    r1.xyz = r1.xyz * float3(2,2,2) + float3(-1,-1,-1);
      r2.rgb = renodx::math::SignSqrt(r0.rgb);
    r3.xyz = cb0[1].www + r2.xyz;
    r3.xyz = min(cb0[1].zzz, r3.xyz);
    r1.xyz = r1.xyz * r3.xyz * injectedData.fxNoise + r2.xyz;
      r0.rgb = renodx::color::gamma::DecodeSafe(r1.rgb, 2.f);
  }
      r0.rgb = PostToneMapScale(r0.rgb);
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}