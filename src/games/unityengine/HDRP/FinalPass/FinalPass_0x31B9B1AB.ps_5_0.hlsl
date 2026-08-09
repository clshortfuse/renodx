#include "../../common.hlsl"

Texture2DArray<float4> t4 : register(t4);
Texture2DArray<float4> t3 : register(t3);
Texture2DArray<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2DArray<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[55];
}
cbuffer cb0 : register(b0){
  float4 cb0[6];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb1[50].xy * v1.xy;
  r0.xy = (uint2)r0.xy;
  r0.xy = (uint2)r0.xy;
  r0.zw = float2(-1,-1) + cb1[50].xy;
  r0.zw = cb0[3].zw * r0.zw;
  r0.xy = r0.xy * cb0[3].xy + r0.zw;
  r0.xy = (uint2)r0.xy;
  r1.xyzw = (int4)r0.xyxy + int4(-1,-1,1,-1);
  r1.xyzw = (int4)r1.xyzw;
  r2.xyzw = float4(-1,-1,-1,-1) + cb1[51].xyxy;
  r1.xyzw = min(r2.xyzw, r1.xyzw);
  r1.xyzw = (int4)r1.zwxy;
  r3.xy = r1.zw;
  r3.zw = float2(0,0);
  r3.xyz = t0.Load(r3.xyzw).xyz;
  r3.x = renodx::color::y::from::BT709(saturate(r3.xyz));
  r4.xyzw = (int4)r0.xyxy + int4(-1,1,1,1);
  r4.xyzw = (int4)r4.xyzw;
  r2.xyzw = min(r4.xyzw, r2.xyzw);
  r2.xyzw = (int4)r2.zwxy;
  r4.xy = r2.zw;
  r4.zw = float2(0,0);
  r3.yzw = t0.Load(r4.xyzw).xyz;
  r3.y = renodx::color::y::from::BT709(saturate(r3.yzw));
  r3.z = r3.x + r3.y;
  r1.zw = float2(0,0);
  r1.xyz = t0.Load(r1.xyzw).xyz;
  r1.x = renodx::color::y::from::BT709(saturate(r1.xyz));
  r2.zw = float2(0,0);
  r1.yzw = t0.Load(r2.xyzw).xyz;
  r1.y = renodx::color::y::from::BT709(saturate(r1.yzw));
  r1.z = r1.x + r1.y;
  r2.yw = r3.zz + -r1.zz;
  r1.zw = r3.xy + r1.xy;
  r1.w = r1.z + -r1.w;
  r1.z = r1.z + r3.y;
  r1.z = r1.z + r1.y;
  r1.z = 0.03125 * r1.z;
  r1.z = max(0.0078125, r1.z);
  r3.z = min(abs(r1.w), abs(r2.w));
  r2.xz = -r1.ww;
  r1.z = r3.z + r1.z;
  r1.z = rcp(r1.z);
  r2.xyzw = r2.xyzw * r1.zzzz;
  r2.xyzw = max(float4(-8,-8,-8,-8), r2.xyzw);
  r2.xyzw = min(float4(8,8,8,8), r2.xyzw);
  r2.xyzw = cb1[50].zwzw * r2.xyzw;
  r1.zw = v1.xy * cb0[3].xy + cb0[3].zw;
  r4.xyzw = saturate(r2.zwzw * float4(-0.5,-0.5,-0.166666672,-0.166666672) + r1.zwzw);
  r2.xyzw = saturate(r2.xyzw * float4(0.166666672,0.166666672,0.5,0.5) + r1.zwzw);
  r2.xyzw = cb1[54].xyxy * r2.xyzw;
  r4.xyzw = cb1[54].xyxy * r4.zwxy;
  r5.xy = r4.zw;
  r5.z = 0;
  r5.xyz = t0.SampleLevel(s2_s, r5.xyz, 0).xyz;
  r6.xy = r2.zw;
  r6.z = 0;
  r6.xyz = t0.SampleLevel(s2_s, r6.xyz, 0).xyz;
  r5.xyz = r6.xyz + r5.xyz;
  r5.xyz = float3(0.25,0.25,0.25) * r5.xyz;
  r4.z = 0;
  r4.xyz = t0.SampleLevel(s2_s, r4.xyz, 0).xyz;
  r2.z = 0;
  r2.xyz = t0.SampleLevel(s2_s, r2.xyz, 0).xyz;
  r2.xyz = r4.xyz + r2.xyz;
  r4.xyz = r2.xyz * float3(0.25,0.25,0.25) + r5.xyz;
  r2.xyz = float3(0.5,0.5,0.5) * r2.xyz;
  r2.w = renodx::color::y::from::BT709(saturate(r4.xyz));
  r3.z = min(r1.x, r3.y);
  r1.x = max(r1.x, r3.y);
  r1.x = max(r1.x, r1.y);
  r1.y = min(r3.z, r1.y);
  r0.zw = float2(0,0);
  r3.yzw = t0.Load(r0.xyww).xyz;
  r0.x = t4.Load(r0.xyzw).x;
  r0.y = renodx::color::y::from::BT709(saturate(r3.yzw));
  r0.z = min(r0.y, r3.x);
  r0.y = max(r0.y, r3.x);
  r0.y = max(r0.y, r1.x);
  r0.z = min(r0.z, r1.y);
  r0.yzw = (r2.w > r0.y) || (r2.w < r0.z) ? r2.xyz : r4.xyz;
  if(injectedData.fxFilmGrainType == 0.f){
  r1.xy = r1.zw * cb0[1].xy + cb0[1].zw;
  r1.x = t1.Sample(s1_s, r1.xy).w;
  r1.x = -0.5 + r1.x;
  r1.x = r1.x + r1.x;
  r2.xyz = r1.xxx * r0.yzw;
  r2.xyz = cb0[0].xxx * r2.xyz * injectedData.fxFilmGrain;
  r1.x = renodx::color::y::from::BT709(saturate(r0.yzw));
  r1.x = sqrt(r1.x);
  r1.x = cb0[0].y * -r1.x + 1;
  r0.yzw = r2.xyz * r1.xxx + r0.yzw;
  } else {
    r0.yzw = applyFilmGrain(r0.yzw, v1);
  }
  r2.xy = cb0[2].xy * r1.zw;
  r1.xy = cb1[52].xy * r1.zw;
  r2.z = cb0[2].z;
  r1.w = t3.Sample(s1_s, r2.xyz).w;
  r1.w = r1.w * 2 + -1;
  r2.x = 1 + -abs(r1.w);
  r1.w = r1.w >= 0 ? 1 : -1;
  r2.x = sqrt(r2.x);
  r2.x = 1 + -r2.x;
  r1.w = r2.x * r1.w;
  r0.yzw = applyDither(r0.yzw, r1.w * (1.0 / 255.0));
  r1.z = 0;
  r1.xyzw = t2.SampleLevel(s0_s, r1.xyz, 0).xyzw;
  o0.xyz = r1.www * r0.yzw + r1.xyz;
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = PostToneMapScale(o0.xyz);
  }
  o0.w = cb0[5].x == 1.0 ? r0.x : 1;
  return;
}