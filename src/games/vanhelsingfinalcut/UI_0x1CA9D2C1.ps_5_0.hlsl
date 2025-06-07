#include "./common.hlsl"

cbuffer _Globals : register(b0){
  float _g_fMBTimer : packoffset(c0);
  float _g_fMBRatio : packoffset(c1);
}
SamplerState _g_sSlot0_s : register(s0);
SamplerState _g_sSlot1_s : register(s1);
Texture2D<float4> _TMP49 : register(t0);
Texture2D<float4> _TMP50 : register(t1);

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * float2(2,2) + float2(-1,-1);
  r0.z = dot(r0.xy, r0.xy);
  r0.z = rsqrt(r0.z);
  r0.w = 1 / r0.z;
  r0.xy = r0.zz * r0.xy;
  r0.z = 1 + -r0.w;
  r0.z = log2(r0.z);
  r1.xyz = float3(0.100000001,0.200000003,0.300000012) * r0.zzz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = float3(1,1,1) + -r1.xyz;
  r2.xyzw = _g_fMBTimer * float4(-3.60000013e-06,1.80000006e-05,2.40000008e-06,2.40000008e-05);
  r2.xyzw = r0.xyxy * r1.xxyy + r2.xyzw;
  r0.zw = float2(0.300000012,0.300000012) + r2.zw;
  r1.xyw = _TMP49.Sample(_g_sSlot0_s, r2.xy).xyz;
  r1.xyw = log2(r1.xyw);
  r1.xyw = float3(2.20000005,2.20000005,2.20000005) * r1.xyw;
  r1.xyw = exp2(r1.xyw);
  r2.xyz = _TMP49.Sample(_g_sSlot0_s, r0.zw).xyz;
  r2.xyz = log2(r2.xyz);
  r2.xyz = float3(2.20000005,2.20000005,2.20000005) * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r1.xyw = r2.xyz + r1.xyw;
  r2.xyz = _g_fMBTimer * float3(1.80000006e-05,6.00000021e-05,3.9999999e-05);
  r0.xy = r0.xy * r1.zz + r2.xy;
  r0.xy = float2(0.600000024,0.600000024) + r0.xy;
  r0.xyz = _TMP49.Sample(_g_sSlot0_s, r0.xy).xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(2.20000005,2.20000005,2.20000005) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = r1.xyw + r0.xyz;
  r0.xyz = float3(0.400000006,0.400000006,0.400000006) * r0.xyz;
  r1.x = _g_fMBRatio + v1.y;
  r1.x = -0.5 + r1.x;
  r1.x = min(0.800000012, r1.x);
  r1.y = max(0.200000003, r1.x);
  r2.yw = float2(0,0);
  r1.x = v1.x;
  r1.zw = r2.zw + r1.xy;
  r1.z = _TMP50.Sample(_g_sSlot1_s, r1.zw).y;
  r2.x = _g_fMBTimer * 7.00000019e-05;
  r1.xy = -r2.xy + r1.xy;
  r1.x = _TMP50.Sample(_g_sSlot1_s, r1.xy).y;
  r1.x = r1.z + r1.x;
  r1.x = r1.x + r1.x;
  r1.x = r1.x * r1.x;
  r0.w = 1;
  r0.xyzw = r1.xxxx * r0.xyzw;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(0.454544991,0.454544991,0.454544991) * r0.xyz;
  o0.xyz = exp2(r0.xyz);
  r0.x = _TMP50.Sample(_g_sSlot1_s, v1.xy).w;
  o0.w = saturate(r0.w * r0.x);
  o0.rgb = UIScale(o0.rgb);
  return;
}