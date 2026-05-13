// ---- Created with 3Dmigoto v1.3.16 on Wed May 13 18:56:48 2026

cbuffer _Globals : register(b0)
{
  float4 g_ConstColor : packoffset(c128);
  float4 g_ConstColorAdd : packoffset(c129);
  float4 g_TextBlurWeights : packoffset(c12);
  float4 g_ConstColorMul : packoffset(c130);
  float4 g_DistanceFieldFloatArray[5] : packoffset(c131);
  float4x4 g_WorldViewProj : packoffset(c0);
  float4x4 g_World : packoffset(c8);
}

SamplerState s0_s : register(s0);
Texture2D<float4> s0 : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cmp(g_DistanceFieldFloatArray[0].x == -1.000000);
  if (r0.x != 0) {
    r0.xyzw = s0.Sample(s0_s, v1.xy).xyzw;
    r0.x = 1;
    o0.xyzw = r0.xxxw * g_ConstColorMul.xyzw + g_ConstColorAdd.xyzw;
    return;
  }
  r0.xyzw = s0.Sample(s0_s, v1.xy).xyzw;
  r0.x = 1 + -r0.w;
  r0.y = cmp(g_DistanceFieldFloatArray[1].x != -1.000000);
  if (r0.y != 0) {
    r0.yz = cmp(g_DistanceFieldFloatArray[1].zw != float2(0,0));
    r0.y = (int)r0.z | (int)r0.y;
    if (r0.y != 0) {
      r0.yz = g_DistanceFieldFloatArray[1].zw + v1.xy;
      r1.xyzw = s0.Sample(s0_s, r0.yz).xyzw;
      r0.y = 1 + -r1.w;
    } else {
      r0.y = r0.x;
    }
    r0.z = cmp(r0.y >= g_DistanceFieldFloatArray[1].x);
    r0.w = cmp(r0.y < g_DistanceFieldFloatArray[1].y);
    r1.x = g_DistanceFieldFloatArray[1].y + -g_DistanceFieldFloatArray[1].x;
    r0.y = -g_DistanceFieldFloatArray[1].x + r0.y;
    r1.x = 1 / r1.x;
    r0.y = saturate(r1.x * r0.y);
    r1.x = r0.y * -2 + 3;
    r0.y = r0.y * r0.y;
    r0.y = r1.x * r0.y;
    r0.y = r0.w ? r0.y : 1;
    r1.xyz = g_DistanceFieldFloatArray[3].xyz + -g_ConstColor.xyz;
    r1.xyz = r0.yyy * r1.xyz + g_ConstColor.xyz;
    r1.xyz = r0.zzz ? r1.xyz : g_ConstColor.xyz;
  } else {
    r1.xyz = g_ConstColor.xyz;
  }
  r0.y = cmp(g_DistanceFieldFloatArray[0].x != g_DistanceFieldFloatArray[0].y);
  r0.z = g_DistanceFieldFloatArray[0].x + -g_DistanceFieldFloatArray[0].y;
  r0.w = -g_DistanceFieldFloatArray[0].y + r0.x;
  r0.z = 1 / r0.z;
  r0.z = saturate(r0.w * r0.z);
  r0.w = r0.z * -2 + 3;
  r0.z = r0.z * r0.z;
  r0.z = r0.w * r0.z;
  r0.w = cmp(g_DistanceFieldFloatArray[0].y >= r0.x);
  r0.w = r0.w ? 1.000000 : 0;
  r1.w = r0.y ? r0.z : r0.w;
  r0.y = cmp(g_DistanceFieldFloatArray[2].x != -1.000000);
  if (r0.y != 0) {
    r0.yz = cmp(g_DistanceFieldFloatArray[2].zw != float2(0,0));
    r0.y = (int)r0.z | (int)r0.y;
    if (r0.y != 0) {
      r0.yz = g_DistanceFieldFloatArray[2].zw + v1.xy;
      r2.xyzw = s0.Sample(s0_s, r0.yz).xyzw;
      r0.x = 1 + -r2.w;
    }
    r0.y = cmp(g_DistanceFieldFloatArray[2].y >= r0.x);
    r0.z = cmp(g_DistanceFieldFloatArray[2].x < r0.x);
    r0.w = g_DistanceFieldFloatArray[2].x + -g_DistanceFieldFloatArray[2].y;
    r0.x = -g_DistanceFieldFloatArray[2].y + r0.x;
    r0.w = 1 / r0.w;
    r0.x = saturate(r0.x * r0.w);
    r0.w = r0.x * -2 + 3;
    r0.x = r0.x * r0.x;
    r0.x = r0.w * r0.x;
    r2.w = r0.z ? r0.x : 1;
    r2.xyz = g_DistanceFieldFloatArray[4].xyz;
    r3.xyzw = -r2.xyzw + r1.xyzw;
    r2.xyzw = r1.wwww * r3.xyzw + r2.xyzw;
    r1.xyzw = r0.yyyy ? r2.xyzw : r1.xyzw;
  }
  o0.xyzw = r1.xyzw * g_ConstColorMul.xyzw + g_ConstColorAdd.xyzw;
  return;
}