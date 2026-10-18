#include "../common.hlsli"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[5];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  float4 v3 : TEXCOORD1,
  float4 v4 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[4].zw + -cb0[4].xy;
  r0.xy = -abs(v4.xy) + r0.xy;
  r0.xy = saturate(v4.zw * r0.xy);
  r0.x = r0.x * r0.y;
  r1.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  if (CUSTOM_UNORM_BOUNDS != 0.f) {
    // Upgraded render textures can carry alpha above 1 (additive model lighting reaches 6 in SIGNALIS's item
    // preview). Restore the UNORM opacity before tinting and premultiplying; RGB stays unclamped.
    r1.w = saturate(r1.w);
  }
  r1.xyzw = cb0[3].xyzw + r1.xyzw;
  r1.xyzw = v1.xyzw * r1.xyzw;
  r0.x = r1.w * r0.x;
  o0.xyz = r1.xyz * r0.xxx;
  o0.w = r0.x;
  o0.w = saturate(o0.w);
  if(CUSTOM_ROLLOFF_UI == 1.f){
    o0.xyz = CUSTOM_GAMMA_SPACE != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
    o0.xyz = rolloff(o0.xyz, 0.85f, true);
    o0.xyz = CUSTOM_GAMMA_SPACE != 0.f ? renodx::color::srgb::EncodeSafe(o0.xyz) : o0.xyz;
  } else if(CUSTOM_ROLLOFF_UI == 2.f){
    o0.xyz = saturate(o0.xyz);
  }
  return;
}
