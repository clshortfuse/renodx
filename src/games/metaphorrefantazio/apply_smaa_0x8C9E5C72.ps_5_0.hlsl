// ---- Created with 3Dmigoto v1.4.1 on Fri May 30 00:59:12 2025

SamplerState PointSampler_s : register(s0);
Texture2D<float4> colorBuffer : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float4 v4 : TEXCOORD3,
  out float2 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = colorBuffer.Sample(PointSampler_s, v1.xy).xyz;
  // r0.rgb = renodx::draw::InvertIntermediatePass(r0.rgb);

  r0.x = dot(r0.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r0.yzw = colorBuffer.Sample(PointSampler_s, v2.xy).xyz;
  // r0.yzw = renodx::draw::InvertIntermediatePass(r0.yzw);

  r1.x = dot(r0.yzw, float3(0.212599993,0.715200007,0.0722000003));
  r0.yzw = colorBuffer.Sample(PointSampler_s, v2.zw).xyz;
  // r0.yzw = renodx::draw::InvertIntermediatePass(r0.yzw);

  r1.y = dot(r0.yzw, float3(0.212599993,0.715200007,0.0722000003));
  r0.yz = -r1.xy + r0.xx;
  r1.zw = cmp(abs(r0.yz) >= float2(0.0500000007,0.0500000007));
  r1.zw = r1.zw ? float2(1,1) : 0;
  r0.w = dot(r1.zw, float2(1,1));
  r0.w = cmp(r0.w == 0.000000);
  if (r0.w != 0) discard;
  r2.xyz = colorBuffer.Sample(PointSampler_s, v3.xy).xyz;
  // r2.xyz = renodx::draw::InvertIntermediatePass(r2.xyz);

  r2.x = dot(r2.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r3.xyz = colorBuffer.Sample(PointSampler_s, v3.zw).xyz;
  // r3.xyz = renodx::draw::InvertIntermediatePass(r3.xyz);

  r2.y = dot(r3.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r0.xw = -r2.xy + r0.xx;
  r0.xw = max(abs(r0.yz), abs(r0.xw));
  r2.xyz = colorBuffer.Sample(PointSampler_s, v4.xy).xyz;
  // r2.xyz = renodx::draw::InvertIntermediatePass(r2.xyz);

  r2.x = dot(r2.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r3.xyz = colorBuffer.Sample(PointSampler_s, v4.zw).xyz;
  // r3.xyz = renodx::draw::InvertIntermediatePass(r3.xyz);

  r2.y = dot(r3.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r1.xy = -r2.xy + r1.xy;
  r0.xw = max(abs(r1.xy), r0.xw);
  r0.x = max(r0.x, r0.w);
  r0.yz = abs(r0.yz) + abs(r0.yz);
  r0.xy = cmp(r0.yz >= r0.xx);
  r0.xy = r0.xy ? float2(1,1) : 0;
  o0.xy = r1.zw * r0.xy;

  return;
}