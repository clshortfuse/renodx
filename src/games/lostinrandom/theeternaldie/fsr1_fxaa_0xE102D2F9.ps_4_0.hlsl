#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[133];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = cb0[132].xyxy * v1.xyxy;
  r0.xyzw = (int4)r0.xyzw;
  r1.xyzw = (int4)r0.zwzw + int4(-1,-1,1,-1);
  r0.xyzw = (int4)r0.xyzw + int4(-1,1,1,1);
  r0.xyzw = (int4)r0.xyzw;
  r0.xyzw = max(float4(0,0,0,0), r0.xyzw);
  r1.xyzw = (int4)r1.xyzw;
  r1.xyzw = max(float4(0,0,0,0), r1.xyzw);
  r2.xyzw = float4(-1,-1,-1,-1) + cb0[132].xyxy;
  r1.xyzw = min(r2.xyzw, r1.xyzw);
  r0.xyzw = min(r2.xyzw, r0.xyzw);
  r0.xyzw = (int4)r0.zwxy;
  r1.xyzw = (int4)r1.zwxy;
  r2.xy = r1.zw;
  r2.zw = float2(0,0);
  r2.xyzw = t0.Load(r2.xyz).xyzw;
  r2.x = renodx::color::y::from::BT709(r2.xyz);
  r3.xy = r0.zw;
  r3.zw = float2(0,0);
  r3.xyzw = t0.Load(r3.xyz).xyzw;
  r2.y = renodx::color::y::from::BT709(r3.xyz);
  r2.z = r2.x + r2.y;
  r1.zw = float2(0,0);
  r1.xyzw = t0.Load(r1.xyz).xyzw;
  r1.x = renodx::color::y::from::BT709(r1.xyz);
  r0.zw = float2(0,0);
  r0.xyzw = t0.Load(r0.xyz).xyzw;
  r0.x = renodx::color::y::from::BT709(r0.xyz);
  r0.y = r1.x + r0.x;
  r3.yw = r2.zz + -r0.yy;
  r0.y = r2.x + r1.x;
  r0.z = r2.y + r0.x;
  r0.z = r0.y + -r0.z;
  r0.y = r0.y + r2.y;
  r0.y = r0.y + r0.x;
  r0.y = 0.03125 * r0.y;
  r0.y = max(0.0078125, r0.y);
  r0.w = min(abs(r0.z), abs(r3.w));
  r3.xz = -r0.zz;
  r0.y = r0.w + r0.y;
  r0.y = 1 / r0.y;
  r3.xyzw = r3.xyzw * r0.yyyy;
  r3.xyzw = max(float4(-8,-8,-8,-8), r3.xyzw);
  r3.xyzw = min(float4(8,8,8,8), r3.xyzw);
  r3.xyzw = cb0[132].zwzw * r3.xyzw;
  r4.xyzw = r3.zwzw * float4(-0.5,-0.5,-0.166666672,-0.166666672) + v1.xyxy;
  r3.xyzw = r3.xyzw * float4(0.166666672,0.166666672,0.5,0.5) + v1.xyxy;
  r5.xyzw = t0.SampleBias(s1_s, r4.xy, cb0[5].x).xyzw;
  r4.xyzw = t0.SampleBias(s1_s, r4.zw, cb0[5].x).xyzw;
  r6.xyzw = t0.SampleBias(s1_s, r3.zw, cb0[5].x).xyzw;
  r3.xyzw = t0.SampleBias(s1_s, r3.xy, cb0[5].x).xyzw;
  r0.yzw = r4.xyz + r3.xyz;
  r1.yzw = r6.xyz + r5.xyz;
  r1.yzw = float3(0.25,0.25,0.25) * r1.yzw;
  r1.yzw = r0.yzw * float3(0.25,0.25,0.25) + r1.yzw;
  r0.yzw = float3(0.5,0.5,0.5) * r0.yzw;
  r2.z = renodx::color::y::from::BT709(r1.yzw);
  r2.w = min(r1.x, r2.y);
  r1.x = max(r1.x, r2.y);
  r1.x = max(r1.x, r0.x);
  r0.x = min(r2.w, r0.x);
  r3.xyzw = t0.SampleBias(s0_s, v1.xy, cb0[5].x).xyzw;
  r2.y = renodx::color::y::from::BT709(r3.xyz);
  r2.w = min(r2.y, r2.x);
  r2.x = max(r2.y, r2.x);
  r1.x = max(r2.x, r1.x);
  r0.x = min(r2.w, r0.x);
  r0.xyz = (r2.z > r1.x) || (r2.z < r0.x) ? r0.yzw : r1.yzw;
  r0.rgb = renodx::color::bt2020::from::BT709(r0.rgb);
  r0.rgb = renodx::color::pq::EncodeSafe(r0.rgb);
  o0.xyz = sqrt(r0.xyz);
  o0.w = 1;
  return;
}