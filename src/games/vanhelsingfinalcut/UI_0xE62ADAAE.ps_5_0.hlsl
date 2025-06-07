#include "./common.hlsl"

cbuffer _Globals : register(b0){
  float _g_fMBTimer : packoffset(c0);
  float _g_fMBRatio : packoffset(c1);
}
SamplerState _g_sSlot0_s : register(s0);
SamplerState _g_sSlot1_s : register(s1);
Texture2D<float4> _TMP38 : register(t0);
Texture2D<float4> _TMP39 : register(t1);

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = _g_fMBTimer * 9.99999975e-05;
  r0.x = sin(r0.x);
  r0.x = r0.x * 0.5 + 0.5;
  r0.x = r0.x * 0.400000006 + 0.200000003;
  r0.yzw = _TMP38.Sample(_g_sSlot1_s, v1.xy).xyw;
  r0.yz = r0.yz * float2(2,2) + float2(-1,-1);
  r0.xy = r0.yz * r0.xx;
  r1.xyzw = r0.xyxy * float4(0.100000001,0.100000001,0.200000003,0.200000003) + v1.xyxy;
  r0.xy = r0.xy * float2(0.400000006,0.400000006) + v1.xy;
  r0.xy = _g_fMBTimer * float2(9.00000032e-06,3.00000011e-05) + r0.xy;
  r0.xy = float2(0.600000024,0.600000024) + r0.xy;
  r2.xyzw = _TMP39.Sample(_g_sSlot0_s, r0.xy).xyzw;
  r0.xy = _g_fMBTimer * float2(1.20000004e-06,1.20000004e-05) + r1.zw;
  r1.xy = _g_fMBTimer * float2(-1.80000006e-06,9.00000032e-06) + r1.xy;
  r1.xyzw = _TMP39.Sample(_g_sSlot0_s, r1.xy).xyzw;
  r0.xy = float2(0.300000012,0.300000012) + r0.xy;
  r3.xyzw = _TMP39.Sample(_g_sSlot0_s, r0.xy).xyzw;
  r0.xyz = log2(r3.xyz);
  r0.xyz = float3(2.20000005,2.20000005,2.20000005) * r0.xyz;
  r3.xyz = exp2(r0.xyz);
  r0.xyz = log2(r1.xyz);
  r0.xyz = float3(2.20000005,2.20000005,2.20000005) * r0.xyz;
  r1.xyz = exp2(r0.xyz);
  r1.xyzw = r1.xyzw + r3.xyzw;
  r0.xyz = log2(r2.xyz);
  r0.xyz = float3(2.20000005,2.20000005,2.20000005) * r0.xyz;
  r2.xyz = exp2(r0.xyz);
  r1.xyzw = r2.xyzw + r1.xyzw;
  r1.xyzw = float4(0.333333343,0.333333343,0.333333343,0.300000012) * r1.xyzw;
  r1.xyz = r1.xyz + r1.www;
  r0.x = _g_fMBRatio + v1.y;
  r0.x = -0.5 + r0.x;
  r0.x = min(0.800000012, r0.x);
  r0.y = max(0.200000003, r0.x);
  r0.x = v1.x;
  r2.xz = _g_fMBTimer * float2(3.9999999e-05,7.00000019e-05);
  r2.yw = float2(0,0);
  r2.xy = r2.xy + r0.xy;
  r0.xy = -r2.zw + r0.xy;
  r0.x = _TMP38.Sample(_g_sSlot1_s, r0.xy).z;
  r0.y = _TMP38.Sample(_g_sSlot1_s, r2.xy).z;
  r0.x = r0.y + r0.x;
  r0.x = r0.x + r0.x;
  r0.x = r0.x * r0.x;
  r1.w = 1;
  r1.xyzw = r1.xyzw * r0.xxxx;
  o0.w = saturate(r1.w * r0.w);
  r0.xyz = log2(r1.xyz);
  r0.xyz = float3(0.454544991,0.454544991,0.454544991) * r0.xyz;
  o0.xyz = exp2(r0.xyz);
  o0.rgb = UIScale(o0.rgb);
  return;
}