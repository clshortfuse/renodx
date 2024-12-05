// ---- Created with 3Dmigoto v1.3.16 on Tue Dec  3 16:00:16 2024

SamplerState ColorBufferState_s : register(s0);
SamplerState ColorCorrectionBufferState_s : register(s1);
Texture2D<float4> ColorBuffer : register(t0);
Texture2D<float4> ColorCorrectionBuffer : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  o0.w = 1;
  r0.xy = v1.xy * float2(1,-1) + float2(0,1);
  r0.xyzw = ColorBuffer.Sample(ColorBufferState_s, r0.xy).xyzw;

  {
    // Disable color correction
    o0.rgb = r0.rgb;
    r0.w = 0; // Likely strength
    return;
  }

  r0.xyz = saturate(r0.xyz);
  r0.w = 0.5;
  r1.xyzw = ColorCorrectionBuffer.Sample(ColorCorrectionBufferState_s, r0.xw).xyzw;
  o0.x = r1.x;
  r1.xyzw = ColorCorrectionBuffer.Sample(ColorCorrectionBufferState_s, r0.yw).xyzw;
  r0.xyzw = ColorCorrectionBuffer.Sample(ColorCorrectionBufferState_s, r0.zw).xyzw;
  o0.z = r0.z;
  o0.y = r1.y;
  return;
}