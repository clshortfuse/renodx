
// ---- Created with 3Dmigoto v1.4.1 on Fri May 30 01:02:10 2025

cbuffer GFD_PSCONST_SYSTEM : register(b0)
{
  float2 gfdResolution : packoffset(c0);
  float2 gfdResolutionRev : packoffset(c0.z);
  float4x4 gfdMtxInvView : packoffset(c1);
  float4 gfdInvProjParams : packoffset(c5);
}

SamplerState LinearSampler_s : register(s0);
Texture2D<float4> colorBuffer : register(t0);
Texture2D<float4> blendBuffer : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = blendBuffer.Sample(LinearSampler_s, v2.xy).w;
  r0.y = blendBuffer.Sample(LinearSampler_s, v2.zw).y;
  r0.zw = blendBuffer.Sample(LinearSampler_s, v1.xy).zx;
  
  r1.x = dot(r0.xyzw, float4(1,1,1,1));
  r1.x = cmp(r1.x < 9.99999975e-06);
  if (r1.x != 0) {
    o0.xyzw = colorBuffer.SampleLevel(LinearSampler_s, v1.xy, 0).xyzw;
  } else {
    r1.xy = max(r0.xy, r0.zw);
    r1.x = cmp(r1.y < r1.x);
    r2.xz = r1.xx ? r0.xz : 0;
    r2.yw = r1.xx ? float2(0,0) : r0.yw;
    r0.x = r1.x ? r0.x : r0.y;
    r0.y = r1.x ? r0.z : r0.w;
    r0.z = dot(r0.xy, float2(1,1));
    r0.xy = r0.xy / r0.zz;
    r1.xyzw = float4(1,1,-1,-1) * gfdResolutionRev.xyxy;
    r1.xyzw = r2.xyzw * r1.xyzw + v1.xyxy;
    r2.xyzw = colorBuffer.SampleLevel(LinearSampler_s, r1.xy, 0).xyzw;
    // r2.rgb = renodx::draw::InvertIntermediatePass(r2.rgb);
    r1.xyzw = colorBuffer.SampleLevel(LinearSampler_s, r1.zw, 0).xyzw;
    // r1.rgb = renodx::draw::InvertIntermediatePass(r1.rgb);
    r1.xyzw = r1.xyzw * r0.yyyy;
    o0.xyzw = r0.xxxx * r2.xyzw + r1.xyzw;
  }
  return;
}