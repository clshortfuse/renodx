#include "../postfx.hlsli"

// ---- Created with 3Dmigoto v1.4.1 on Fri Jul 17 03:09:38 2026
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[3];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[164];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[11];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = asuint(cb0[10].xy);
  r0.xy = v0.xy + -r0.xy;
  r1.xyzw = -r0.xyxy * cb0[10].zwzw + float4(0.5,0.5,0.5,0.5);
  r1.xyzw = cb2[0].xxxx * r1.xyzw;
  r0.zw = cb0[10].zw * r0.xy;
  r0.xy = r0.xy * cb0[10].zw + float2(-0.5,-0.5);
  r0.x = dot(r0.xy, r0.xy);
  r0.x = sqrt(r0.x);
  r2.xyzw = saturate(r1.zwzw * float4(-0.0799999982,-0.0799999982,-0.0500000007,-0.0500000007) + r0.zwzw);
  r2.xyzw = r2.xyzw * cb0[0].zwzw + cb0[0].xyxy;
  r3.xyz = t0.Sample(s0_s, r2.zw).xyz;
  r2.xyzw = t0.Sample(s0_s, r2.xy).xyzw;

  r3.xyz = InvertLUTEncode(r3.xyz);
  r2.xyz = InvertLUTEncode(r2.xyz);

  r2.xyz = r2.xyz + r3.xyz;
  o0.w = r2.w;
  r3.xyzw = saturate(r1.zwzw * float4(-0.0299999993,-0.0299999993,-0.0199999996,-0.0199999996) + r0.zwzw);
  r3.xyzw = r3.xyzw * cb0[0].zwzw + cb0[0].xyxy;
  r4.xyz = t0.Sample(s0_s, r3.xy).xyz;
  r3.xyz = t0.Sample(s0_s, r3.zw).xyz;

  r4.xyz = InvertLUTEncode(r4.xyz);
  r3.xyz = InvertLUTEncode(r3.xyz);

  r2.xyz = r4.xyz + r2.xyz;
  r2.xyz = r2.xyz + r3.xyz;
  r3.xyzw = saturate(r1.zwzw * float4(-0.00999999978,-0.00999999978,0.00999999978,0.00999999978) + r0.zwzw);
  r3.xyzw = r3.xyzw * cb0[0].zwzw + cb0[0].xyxy;
  r4.xyz = t0.Sample(s0_s, r3.xy).xyz;
  r3.xyz = t0.Sample(s0_s, r3.zw).xyz;

  r4.xyz = InvertLUTEncode(r4.xyz);
  r3.xyz = InvertLUTEncode(r3.xyz);

  r2.xyz = r4.xyz + r2.xyz;
  r4.xy = saturate(r0.zw);
  r4.xy = r4.xy * cb0[0].zw + cb0[0].xy;
  r4.xyz = t0.Sample(s0_s, r4.xy).xyz;

  r4.xyz = InvertLUTEncode(r4.xyz);

  r2.xyz = r4.xyz + r2.xyz;
  r2.xyz = r2.xyz + r3.xyz;
  r3.xyzw = saturate(r1.zwzw * float4(0.0199999996,0.0199999996,0.0299999993,0.0299999993) + r0.zwzw);
  r1.xyzw = saturate(r1.xyzw * float4(0.0500000007,0.0500000007,0.0799999982,0.0799999982) + r0.zwzw);
  r0.yz = r0.zw * cb0[0].zw + cb0[0].xy;
  r0.yz = max(cb0[1].xy, r0.yz);
  r0.yz = min(cb0[1].zw, r0.yz);
  r0.yzw = t0.Sample(s0_s, r0.yz).xyz;

  r0.yzw = InvertLUTEncode(r0.yzw);

  r1.xyzw = r1.xyzw * cb0[0].zwzw + cb0[0].xyxy;
  r3.xyzw = r3.xyzw * cb0[0].zwzw + cb0[0].xyxy;
  r4.xyz = t0.Sample(s0_s, r3.xy).xyz;
  r3.xyz = t0.Sample(s0_s, r3.zw).xyz;

  r4.xyz = InvertLUTEncode(r4.xyz);
  r3.xyz = InvertLUTEncode(r3.xyz);

  r2.xyz = r4.xyz + r2.xyz;
  r2.xyz = r2.xyz + r3.xyz;
  r3.xyz = t0.Sample(s0_s, r1.xy).xyz;
  r1.xyz = t0.Sample(s0_s, r1.zw).xyz;

  r3.xyz = InvertLUTEncode(r3.xyz);
  r1.xyz = InvertLUTEncode(r1.xyz);

  r2.xyz = r3.xyz + r2.xyz;
  r1.xyz = r2.xyz + r1.xyz;
  r1.xyz = cb2[0].yzw * r1.xyz;
  r2.xyz = float3(0.0909090936,0.0909090936,0.0909090936) * r1.xyz;
  r1.xyz = -r1.xyz * float3(0.0909090936,0.0909090936,0.0909090936) + r0.yzw;
  r1.xyz = r1.xyz * float3(0.5,0.5,0.5) + r2.xyz;
  r1.w = dot(r0.yzw, float3(0.212639004,0.715168655,0.0721923187));
  r2.xyz = r1.www + -r0.yzw;
  r0.yzw = cb2[1].xxx * r2.xyz + r0.yzw;
  r0.yzw = r0.yzw + -r1.xyz;
  r1.w = 25.1327419 * cb1[163].z;
  r1.w = sin(r1.w);
  r1.w = 1 + r1.w;
  r1.w = r1.w * -0.100000016 + 1.10000002;
  r1.w = cb2[1].y * r1.w;
  r0.x = r0.x / r1.w;
  r0.x = 1 + -r0.x;
  r1.w = cb2[1].z * r0.x;
  r1.w = r1.w * r1.w;
  r1.w = 1.44269514 * r1.w;
  r1.w = exp2(r1.w);
  r1.w = 1 / r1.w;
  r1.w = 1 + -r1.w;
  r2.x = cmp(r0.x >= 0);
  r0.x = cmp(9.99999975e-06 < abs(r0.x));
  r1.w = r2.x ? r1.w : 0;
  r0.x = r0.x ? r1.w : 0;
  r0.xyz = r0.xxx * r0.yzw + r1.xyz;
  r1.xyz = cb2[2].xyz + -r0.xyz;
  r0.xyz = cb2[1].www * r1.xyz + r0.xyz;

  r0.xyz = renodx::math::Select(RENODX_TONE_MAP_TYPE == 0, max(0, r0.xyz), r0.xyz);
  o0.xyz = ApplyLUTEncode(r0.xyz);
  return;
}