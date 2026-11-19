// ---- Created with 3Dmigoto v1.3.16 on Mon Nov 02 10:13:08 2026

cbuffer _Globals : register(b0)
{
  float4 TextureComponentReplicate : packoffset(c0);
  float Gamma : packoffset(c1);
  float ClipRef : packoffset(c1.y);
}

SamplerState Texture_s : register(s0);
Texture2D<float4> Texture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = dot(TextureComponentReplicate.xyzw, TextureComponentReplicate.xyzw);
  r0.x = cmp(r0.x != 0.000000);
  r1.xyzw = Texture.Sample(Texture_s, v0.xy).xyzw;
  r0.y = dot(r1.xyzw, TextureComponentReplicate.xyzw);
  r0.xyzw = r0.xxxx ? r0.yyyy : r1.xyzw;
  r0.xyzw = v1.xyzw * r0.xyzw;
  r1.xyz = saturate(r0.xyz);
  r1.xyz = max(float3(9.99999975e-005,9.99999975e-005,9.99999975e-005), r1.xyz);
  r1.xyz = log2(r1.xyz);
  r1.xyz = Gamma * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.w = cmp(Gamma != 1.000000);
  o0.xyz = r1.www ? r1.xyz : r0.xyz;
  // Restore the original UNORM UI bound on the floating-point HDR target.
  // The output proxy scales this SDR-shaped UI by UI Brightness.
  o0.rgb = saturate(o0.rgb);
  o0.w = r0.w;
  return;
}