#include "./common.hlsl"

Texture2DArray<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
RWTexture2DArray<float4> u0 : register(u0);
cbuffer cb0 : register(b0){
  float4 cb0[51];
}

[numthreads(8, 8, 1)]
void main(uint3 vThreadID: SV_DispatchThreadID) {
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = (int4)vThreadID.xyxy + int4(-1,-1,1,-1);
  r0.xyzw = (int4)r0.xyzw;
  r1.xyzw = float4(-1,-1,-1,-1) + cb0[47].xyxy;
  r0.xyzw = min(r1.xyzw, r0.xyzw);
  r0.xyzw = (int4)r0.xyzw;
  r2.xy = r0.zw;
  r0.z = vThreadID.z;
  r0.w = 0;
  r2.zw = r0.zw;
  r3.xyz = t0.Load(r0.xyzw).xyz;
  r3.x = renodx::color::y::from::BT709(r3.xyz);
  r3.yzw = t0.Load(r2.xyzw).xyz;
  r3.y = renodx::color::y::from::BT709(r3.yzw);
  r4.xyzw = (int4)vThreadID.xyxy + int4(-1,1,1,1);
  r4.xyzw = (int4)r4.xyzw;
  r4.xyzw = min(r4.xyzw, r1.xyzw);
  r4.xyzw = (int4)r4.zwxy;
  r2.xy = r4.zw;
  r5.xyz = t0.Load(r2.xyzw).xyz;
  r4.zw = r2.zw;
  r2.xyz = t0.Load(r4.xyzw).xyz;
  r1.z = renodx::color::y::from::BT709(r2.xyz);
  r1.w = renodx::color::y::from::BT709(r5.xyz);
  r2.xy = r3.yx + r1.zw;
  r2.yw = r2.yy + -r2.xx;
  r3.z = r3.x + r3.y;
  r3.w = r1.w + r1.z;
  r3.w = r3.z + -r3.w;
  r3.z = r3.z + r1.w;
  r3.z = r3.z + r1.z;
  r3.z = 0.03125 * r3.z;
  r3.z = max(0.0078125, r3.z);
  r4.x = min(abs(r3.w), abs(r2.w));
  r2.xz = -r3.ww;
  r3.z = r4.x + r3.z;
  r3.z = rcp(r3.z);
  r2.xyzw = r3.zzzz * r2.xyzw;
  r2.xyzw = max(float4(-8,-8,-8,-8), r2.xyzw);
  r2.xyzw = min(float4(8,8,8,8), r2.xyzw);
  r2.xyzw = cb0[46].zwzw * r2.xyzw;
  r4.xyzw = float4(0.5,0.5,0.5,0.5) * cb0[47].zwzw;
  r5.xyz = (uint3)vThreadID.xyz;
  r4.xyzw = r5.xyxy * cb0[47].zwzw + r4.xyzw;
  r6.xyzw = saturate(r2.zwzw * float4(-0.5,-0.5,-0.166666672,-0.166666672) + r4.zwzw);
  r2.xyzw = saturate(r2.xyzw * float4(0.166666672,0.166666672,0.5,0.5) + r4.xyzw);
  r2.xyzw = cb0[50].xyxy * r2.xyzw;
  r4.xyzw = cb0[50].xyxy * r6.zwxy;
  r5.xy = r4.zw;
  r5.xyw = t0.SampleLevel(s0_s, r5.xyz, 0).xyz;
  r4.z = r5.z;
  r5.xyzw = r5.xywx;
  r6.xy = r2.zw;
  r2.z = r4.z;
  r4.xyz = t0.SampleLevel(s0_s, r4.xyz, 0).xyz;
  r4.xyzw = r4.xyzx;
  r6.z = r2.z;
  r2.xyz = t0.SampleLevel(s0_s, r2.xyz, 0).xyz;
  r2.xyzw = r2.xyzx;
  r2.xyzw = r4.xyzw + r2.xyzw;
  r4.xyz = t0.SampleLevel(s0_s, r6.xyz, 0).xyz;
  r4.xyzw = r4.xyzx;
  r4.xyzw = r5.xyzw + r4.xyzw;
  r4.xyzw = float4(0.25,0.25,0.25,0.25) * r4.xyzw;
  r4.xyzw = r2.xyzw * float4(0.25,0.25,0.25,0.25) + r4.xyzw;
  r2.xyzw = float4(0.5,0.5,0.5,0.5) * r2.wyzw;
  r3.z = renodx::color::y::from::BT709(r4.wyz);
  r5.xy = (int2)vThreadID.xy;
  r1.xy = min(r5.xy, r1.xy);
  r0.xy = (int2)r1.xy;
  r0.xyz = t0.Load(r0.xyzw).xyz;
  r0.x = renodx::color::y::from::BT709(r0.xyz);
  r0.y = min(r0.x, r3.x);
  r0.x = max(r0.x, r3.x);
  r0.z = min(r3.y, r1.w);
  r0.w = max(r3.y, r1.w);
  r0.w = max(r0.w, r1.z);
  r0.z = min(r0.z, r1.z);
  r0.y = min(r0.y, r0.z);
  r0.x = max(r0.x, r0.w);
  r0.xyzw = (r3.z > r0.x) || (r3.z < r0.y) ? r2.xyzw : r4.xyzw;
  u0[vThreadID] = r0;
  return;
}