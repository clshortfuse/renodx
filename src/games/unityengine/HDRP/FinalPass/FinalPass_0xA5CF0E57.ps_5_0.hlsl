#include "../../common.hlsl"

Texture2DArray<float4> t3 : register(t3);
Texture2DArray<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2DArray<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[44];
}
cbuffer cb0 : register(b0){
  float4 cb0[5];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.zw = float2(0,0);
  r1.xy = cb1[42].xy * v1.xy;
  r1.xy = (uint2)r1.xy;
  r1.xy = (uint2)r1.xy;
  r2.xyzw = float4(-1,-1,-1,-1) + cb1[42].xyxy;
  r1.zw = cb0[3].zw * r2.zw;
  r1.xy = r1.xy * cb0[3].xy + r1.zw;
  r1.xy = (uint2)r1.xy;
  r3.xyzw = (int4)r1.xyxy + int4(-1,-1,1,-1);
  r3.xyzw = (int4)r3.xyzw;
  r3.xyzw = min(r3.xyzw, r2.xyzw);
  r3.xyzw = (int4)r3.zwxy;
  r0.xy = r3.zw;
  r0.xyz = t0.Load(r0.xyzw).xyz;
  r0.x = renodx::color::y::from::BT709(saturate(r0.xyz));
  r4.xyzw = (int4)r1.xyxy + int4(-1,1,1,1);
  r4.xyzw = (int4)r4.xyzw;
  r2.xyzw = min(r4.xyzw, r2.xyzw);
  r2.xyzw = (int4)r2.zwxy;
  r4.xy = r2.zw;
  r4.zw = float2(0,0);
  r0.yzw = t0.Load(r4.xyzw).xyz;
  r0.y = renodx::color::y::from::BT709(saturate(r0.yzw));
  r0.z = r0.x + r0.y;
  r3.zw = float2(0,0);
  r3.xyz = t0.Load(r3.xyzw).xyz;
  r0.w = renodx::color::y::from::BT709(saturate(r3.xyz));
  r2.zw = float2(0,0);
  r2.xyz = t0.Load(r2.xyzw).xyz;
  r2.x = renodx::color::y::from::BT709(saturate(r2.xyz));
  r2.y = r2.x + r0.w;
  r3.yw = -r2.yy + r0.zz;
  r0.z = r0.x + r0.w;
  r2.y = r2.x + r0.y;
  r2.y = -r2.y + r0.z;
  r0.z = r0.z + r0.y;
  r0.z = r0.z + r2.x;
  r0.z = 0.03125 * r0.z;
  r0.z = max(0.0078125, r0.z);
  r2.z = min(abs(r2.y), abs(r3.w));
  r3.xz = -r2.yy;
  r0.z = r2.z + r0.z;
  r0.z = rcp(r0.z);
  r3.xyzw = r3.xyzw * r0.zzzz;
  r3.xyzw = max(float4(-8,-8,-8,-8), r3.xyzw);
  r3.xyzw = min(float4(8,8,8,8), r3.xyzw);
  r3.xyzw = cb1[42].zwzw * r3.xyzw;
  r2.yz = v1.xy * cb0[3].xy + cb0[3].zw;
  r4.xyzw = saturate(r3.zwzw * float4(-0.5,-0.5,-0.166666672,-0.166666672) + r2.yzyz);
  r3.xyzw = saturate(r3.xyzw * float4(0.166666672,0.166666672,0.5,0.5) + r2.yzyz);
  r5.xy = cb1[43].xy * r2.yz;
  r3.xyzw = cb1[43].xyxy * r3.xyzw;
  r4.xyzw = cb1[43].xyxy * r4.zwxy;
  r6.xy = r4.zw;
  r6.z = 0;
  r2.yzw = t0.SampleLevel(s1_s, r6.xyz, 0).xyz;
  r6.xy = r3.zw;
  r6.z = 0;
  r6.xyz = t0.SampleLevel(s1_s, r6.xyz, 0).xyz;
  r2.yzw = r6.xyz + r2.yzw;
  r2.yzw = float3(0.25,0.25,0.25) * r2.yzw;
  r4.z = 0;
  r4.xyz = t0.SampleLevel(s1_s, r4.xyz, 0).xyz;
  r3.z = 0;
  r3.xyz = t0.SampleLevel(s1_s, r3.xyz, 0).xyz;
  r3.xyz = r4.xyz + r3.xyz;
  r2.yzw = r3.xyz * float3(0.25,0.25,0.25) + r2.yzw;
  r3.xyz = float3(0.5,0.5,0.5) * r3.xyz;
  r0.z = renodx::color::y::from::BT709(saturate(r2.yzw));
  r3.w = min(r0.w, r0.y);
  r0.y = max(r0.w, r0.y);
  r0.y = max(r0.y, r2.x);
  r0.w = min(r3.w, r2.x);
  r1.zw = float2(0,0);
  r4.xyz = t0.Load(r1.xyww).xyz;
  r1.z = t3.Load(r1.xyzw).x;
  r1.xy = (uint2)r1.xy;
  r1.xy = cb0[1].zw + r1.xy;
  r1.xy = r1.xy / cb0[1].xy;
  r1.w = renodx::color::y::from::BT709(saturate(r4.xyz));
  r2.x = min(r1.w, r0.x);
  r0.x = max(r1.w, r0.x);
  r0.x = max(r0.x, r0.y);
  r0.y = min(r2.x, r0.w);
  r0.xyz = (r0.z > r0.x) || (r0.z < r0.y) ? r3.xyz : r2.yzw;
  r1.xy = (r1.xy >= -r1.xy) ? frac(abs(r1.xy)) : -frac(abs(r1.xy));
  r1.xy = cb0[1].xy * r1.xy;
  r2.xy = (uint2)r1.xy;
  r2.zw = float2(0, 0);
  if (injectedData.fxFilmGrainType == 0.f) {
  r0.w = t1.Load(r2.xyz).w;
  r0.w = -0.5 + r0.w;
  r0.w = r0.w + r0.w;
  r1.xyw = r0.xyz * r0.www;
  r1.xyw = cb0[0].xxx * r1.xyw * injectedData.fxFilmGrain;
  r0.w = renodx::color::y::from::BT709(saturate(r0.xyz));
  r0.w = sqrt(r0.w);
  r0.w = cb0[0].y * -r0.w + 1;
  r0.xyz = r1.xyw * r0.www + r0.xyz;
  } else {
    r0.xyz = applyFilmGrain(r0.xyz, v1);
  }
  r5.z = 0;
  r2.xyzw = t2.SampleLevel(s0_s, r5.xyz, 0).xyzw;
  o0.xyz = r2.www * r0.xyz + r2.xyz;
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = PostToneMapScale(o0.xyz);
  }
  o0.w = cb0[4].x == 1.0 ? r1.z : 1;
  return;
}