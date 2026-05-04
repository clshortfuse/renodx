// ---- Created with 3Dmigoto v1.3.16 on Tue Mar 10 21:23:52 2026

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[9];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[3];
}

cbuffer cb11 : register(b11)
{
  float4 cb11[1];
}

#define cmp -

bool IsNotLightSpellTexture() {
  float4 center = t0.SampleLevel(s0_s, float2(0.5f, 0.5f), 0);
  if (center.a < 0.9f) return false;

  float4 corner = t0.SampleLevel(s0_s, float2(0.02f, 0.02f), 0);
  if (corner.a > 0.05f) return false;

  float4 corner2 = t0.SampleLevel(s0_s, float2(0.98f, 0.98f), 0);
  if (corner2.a > 0.05f) return false;

  float4 edge = t0.SampleLevel(s0_s, float2(0.1f, 0.5f), 0);
  if (edge.a > 0.05f) return false;

  return true;
}

bool IsNorthenLightsTexture() {
  float w, h;
  t0.GetDimensions(w, h);
  if (w == 512.f && h == 256.f) return true;

  return false;
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : COLOR0,
  float4 v3 : COLOR1,
  float v4 : TEXCOORD5,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1,
  out float4 o2 : SV_Target2)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Apply particle system color multiplier to vertex color
  r0.xyzw = cb1[0].xyzw * v2.xyzw;

  // Sample particle texture — clamp to 0-1 to handle R16F precision issues
  r1.xyzw = saturate(t0.Sample(s0_s, v1.xy).xyzw);

  // Scale texture alpha by particle depth/age
  r1.w = v1.z * r1.w;

  // Combine texture with particle color
  r0.xyzw = r1.xyzw * r0.xyzw;

  // Alpha test with epsilon tolerance for R16F precision
  r1.w = cb2[8].w * r0.w;
  r2.w = 1;
  float alphaTest = r1.w * r2.w - cb11[0].x;
  if (alphaTest < 0.001) discard;

  // Apply fog/tint color blend
  r3.xyz = cb2[8].xyz * r0.xyz + -r0.xyz;
  r0.xyz = cb1[2].xxx * r3.xyz + r0.xyz;

  // Apply fog opacity
  r0.w = 1 + -v3.w;
  r1.xyz = r0.xyz * r0.www;

  // Apply distance fade / intensity
  r2.x = v4.x;
  r0.xyzw = r2.xxxw * r1.xyzw;

  // Clamp before boost to clean up any R16F artifacts
  r0.xyzw = max(r0.xyzw, 0.0);

  // Save unboosted color
  float4 unboosted = r0;
  if (IsNorthenLightsTexture()) {
    // Northern lights texture is already bright and colorful, so just do a mild boost
    r0.xyz = sqrt(r0.xyz) * 1.2f;  // TUNE: was 2.0, try 2.5-3.5
  } 
  float3 capped = min(r0.xyz, 1.2f);
  // Output
  o0.xyz = capped;
  o0.w = saturate(unboosted.w);  // Clamp alpha output
  o1.w = saturate(unboosted.w);
  o2.xyzw = float4(r0.xyz, saturate(r0.w));
  o1.xyz = float3(1, 0, 0);
  return;
}