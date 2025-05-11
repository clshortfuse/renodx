#include "./common.hlsl"

Texture2DArray<float4> t2 : register(t2);
Texture2DArray<float4> t1 : register(t1);
Texture2DArray<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1) {
  float4 cb1[51];
}
cbuffer cb0 : register(b0) {
  float4 cb0[6];
}

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5, r6, r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb1[46].xy * v1.xy;
  r0.xy = (uint2)r0.xy;
  r0.xy = (uint2)r0.xy;
  r0.zw = float2(-1, -1) + cb1[46].xy;
  r0.zw = cb0[3].zw * r0.zw;
  r0.xy = r0.xy * cb0[3].xy + r0.zw;
  r0.xy = (uint2)r0.xy;
  r1.xyzw = (int4)r0.xyxy + int4(-1, -1, 1, -1);
  r1.xyzw = (int4)r1.xyzw;
  r2.xyzw = float4(-1, -1, -1, -1) + cb1[47].xyxy;
  r1.xyzw = min(r2.xyzw, r1.xyzw);
  r1.xyzw = (int4)r1.zwxy;
  r3.xy = r1.zw;
  r3.zw = float2(0, 0);
  r3.xyz = t0.Load(r3.xyzw).xyz;
  r3.x = renodx::color::y::from::BT709(r3.rgb);
  r4.xyzw = (int4)r0.xyxy + int4(-1, 1, 1, 1);
  r4.xyzw = (int4)r4.xyzw;
  r2.xyzw = min(r4.xyzw, r2.xyzw);
  r2.xyzw = (int4)r2.zwxy;
  r4.xy = r2.zw;
  r4.zw = float2(0, 0);
  r3.yzw = t0.Load(r4.xyzw).xyz;
  r3.y = renodx::color::y::from::BT709(r3.gba);
  r3.z = r3.x + r3.y;
  r1.zw = float2(0, 0);
  r1.xyz = t0.Load(r1.xyzw).xyz;
  r1.x = renodx::color::y::from::BT709(r1.rgb);
  r2.zw = float2(0, 0);
  r1.yzw = t0.Load(r2.xyzw).xyz;
  r1.y = renodx::color::y::from::BT709(r1.gba);
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
  r2.xyzw = max(float4(-8, -8, -8, -8), r2.xyzw);
  r2.xyzw = min(float4(8, 8, 8, 8), r2.xyzw);
  r2.xyzw = cb1[46].zwzw * r2.xyzw;
  r1.zw = v1.xy * cb0[3].xy + cb0[3].zw;
  r4.xyzw = saturate(r2.zwzw * float4(-0.5, -0.5, -0.166666672, -0.166666672) + r1.zwzw);
  r2.xyzw = saturate(r2.xyzw * float4(0.166666672, 0.166666672, 0.5, 0.5) + r1.zwzw);
  r5.xy = cb1[48].xy * r1.zw;
  r2.xyzw = cb1[50].xyxy * r2.xyzw;
  r4.xyzw = cb1[50].xyxy * r4.zwxy;
  r6.xy = r4.zw;
  r6.z = 0;
  r6.xyz = t0.SampleLevel(s1_s, r6.xyz, 0).xyz;
  r7.xy = r2.zw;
  r7.z = 0;
  r7.xyz = t0.SampleLevel(s1_s, r7.xyz, 0).xyz;
  r6.xyz = r7.xyz + r6.xyz;
  r6.xyz = float3(0.25, 0.25, 0.25) * r6.xyz;
  r4.z = 0;
  r4.xyz = t0.SampleLevel(s1_s, r4.xyz, 0).xyz;
  r2.z = 0;
  r2.xyz = t0.SampleLevel(s1_s, r2.xyz, 0).xyz;
  r2.xyz = r4.xyz + r2.xyz;
  r4.xyz = r2.xyz * float3(0.25, 0.25, 0.25) + r6.xyz;
  r2.xyz = float3(0.5, 0.5, 0.5) * r2.xyz;
  r1.z = renodx::color::y::from::BT709(r4.rgb);
  r1.w = min(r1.x, r3.y);
  r1.x = max(r1.x, r3.y);
  r1.x = max(r1.x, r1.y);
  r1.y = min(r1.w, r1.y);
  r0.zw = float2(0, 0);
  r3.yzw = t0.Load(r0.xyww).xyz;
  r0.x = t2.Load(r0.xyzw).x;
  r0.y = renodx::color::y::from::BT709(r3.gba);
  r0.z = min(r0.y, r3.x);
  r0.y = max(r0.y, r3.x);
  float max1 = max(r0.y, r1.x);
  float min1 = min(r0.z, r1.y);
  r0.yzw = (r1.z < min1) || (r1.z > max1) ? r2.xyz : r4.xyz;
  r5.z = 0;
  r1.xyzw = t1.SampleLevel(s0_s, r5.xyz, 0).xyzw;
  o0.xyz = r1.www * r0.yzw + r1.xyz;
  if (injectedData.fxFilmGrainType == 1.f) {
    o0.rgb = applyFilmGrain(o0.rgb, v1);
  }
  o0.rgb = PostToneMapScale(o0.rgb);
  o0.w = (cb0[5].x == 1.0) ? r0.x : 1;
  return;
}
