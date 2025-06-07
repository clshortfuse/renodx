#include "./common.hlsl"

Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[11];
}

void main(
  float4 v0 : TEXCOORD0,
  float2 v1 : TEXCOORD1,
  float4 v2 : SV_POSITION0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = -cb0[2].x + cb0[0].w;
  if (r0.x < 0) discard;
  r0.xyzw = float4(0.00048828125,0.00048828125,0.00048828125,-0.00048828125) + v1.xyxy;
  r0.z = t5.Sample(s5_s, r0.zw).x;
  r0.x = t5.Sample(s5_s, r0.xy).x;
  r0.y = 0.25 * r0.z;
  r0.x = r0.x * 0.25 + r0.y;
  r1.xyzw = float4(-0.00048828125,-0.00048828125,-0.00048828125,0.00048828125) + v1.xyxy;
  r0.y = t5.Sample(s5_s, r1.zw).x;
  r0.z = t5.Sample(s5_s, r1.xy).x;
  r0.y = 0.25 * r0.y;
  r0.y = r0.z * 0.25 + r0.y;
  r0.x = r0.x + r0.y;
  r0.x = saturate(1 + -r0.x);
  r0.y = r0.x * -2 + 3;
  r0.z = r0.x * r0.x;
  r0.x = 1.25 * r0.x;
  r0.x = min(1, r0.x);
  r0.y = r0.y * r0.z;
  r0.z = t3.Sample(s3_s, v0.xy).x;
  r0.w = 1 + -r0.z;
  r0.y = r0.y * r0.w + r0.z;
  r0.z = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.x = r0.z * r0.x;
  r0.x = r0.y * r0.x;
  r0.y = min(0, cb0[10].x);
  r0.y = min(1, -r0.y);
  r0.zw = cb0[3].xx + v2.xy;
  r0.zw = r0.zw * cb0[1].xy + -cb0[7].xy;
  r0.zw = r0.zw * cb0[8].xy + float2(0.5,0.5);
  r0.z = t2.Sample(s2_s, r0.zw).w;
  r0.w = saturate(1 + -r0.z);
  r0.y = r0.w * r0.y;
  r0.x = saturate(r0.y * 0.649999976 + r0.x);
  r0.y = saturate(-cb0[6].x * r0.z + 1);
  r0.z = saturate(cb0[9].x + r0.z);
  r1.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r0.w = ceil(r1.w);
  r0.y = r0.y * r0.w;
  r2.x = 3.33333325 * r1.w;
  r2.x = saturate(r2.x);
  r0.y = r2.x * r0.y;
  r0.w = dot(r1.xyz, float3(0.300000012,0.589999974,0.109999999));
  r1.xyz = r1.xyz + -r0.www;
  r1.xyz = cb0[5].xxx * r1.xyz + r0.www;
  r2.xyz = r1.www * float3(-0.345098197,-0.313724995,-0.211764991) + float3(0.392156988,0.560783982,0.419607997);
  r2.xyz = r2.xyz + -r1.xyz;
  r1.xyz = r0.yyy * r2.xyz + r1.xyz;
  r2.xyzw = t4.Sample(s4_s, v0.xy).xyzw;
  r2.xyz = r2.xyz + -r1.xyz;
  r0.y = r2.w * r0.z;
  r0.yzw = r0.yyy * r2.xyz + r1.xyz;
  r1.xyz = t1.Sample(s1_s, v0.zw).xyz;
  r1.w = dot(r1.xyz, float3(0.300000012,0.589999974,0.109999999));
  r1.xyz = r1.xyz + -r1.www;
  r1.xyz = cb0[5].xxx * r1.xyz + r1.www;
  r1.xyz = r1.xyz + -r0.yzw;
  r0.xyz = r0.xxx * r1.xyz + r0.yzw;
  o0.w = cb0[0].w;
  r0.rgb = renodx::color::srgb::DecodeSafe(r0.rgb);
  o0.rgb = HalfWayScale(r0.xyz);
  return;
}