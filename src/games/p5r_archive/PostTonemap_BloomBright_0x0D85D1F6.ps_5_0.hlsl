
cbuffer GFD_PSCONST_CORRECT : register(b12) {
  float3 colorBalance : packoffset(c0);
  float _reserve00 : packoffset(c0.w);
  float2 colorBlend : packoffset(c1);
}

cbuffer GFD_PSCONST_HDR : register(b11) {
  float middleGray : packoffset(c0);
  float adaptedLum : packoffset(c0.y);
  float bloomScale : packoffset(c0.z);
  float starScale : packoffset(c0.w);
}

SamplerState opaueSampler_s : register(s0);
SamplerState bloomSampler_s : register(s1);
SamplerState brightSampler_s : register(s2);
Texture2D<float4> opaueTexture : register(t0);
Texture2D<float4> bloomTexture : register(t1);
Texture2D<float4> brightTexture : register(t2);

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : SV_POSITION0, float2 v1 : TEXCOORD0, out float4 o0 : SV_TARGET0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = bloomTexture.Sample(bloomSampler_s, v1.xy).xyz;
  r0.xyz = bloomScale * r0.xyz;
  r1.xyz = brightTexture.Sample(brightSampler_s, v1.xy).xyz;
  r1.xyz = bloomScale * r1.xyz;
  r2.xyz = opaueTexture.Sample(opaueSampler_s, v1.xy).xyz;
  r2.xyz = r2.xyz;
  r3.xyz = r1.xyz + r0.xyz;
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = -r0.xyz;
  r0.xyz = r3.xyz + r0.xyz;
  r1.xyz = -r1.xyz;
  r1.xyz = r2.xyz + r1.xyz;
  r3.xyz = int3(0, 0, 0);
  r1.xyz = max(r3.xyz, r1.xyz);
  r3.xyz = r1.xyz + r0.xyz;
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = -r0.xyz;
  r0.xyz = r3.xyz + r0.xyz;
  r0.xyz = max(r2.xyz, r0.xyz);
  r1.w = 1;
  r0.w = max(r0.x, r0.y);
  r0.w = max(r0.w, r0.z);
  r2.x = -r0.w;
  r2.x = 1 + r2.x;
  r0.xyz = -r0.xyz;
  r0.xyz = float3(1, 1, 1) + r0.xyz;
  r2.yzw = -r2.xxx;
  r0.xyz = r2.yzw + r0.xyz;
  r0.xyz = r0.xyz / r0.www;
  r0.xyz = colorBalance.xyz + r0.xyz;
  r0.xyz = r0.xyz * r0.www;
  r0.xyz = r0.xyz + r2.xxx;
  r0.xyz = -r0.xyz;
  r0.xyz = float3(1, 1, 1) + r0.xyz;
  r0.xyz = r0.xyz / colorBlend.xxx;
  r0.xyz = -r0.xyz;
  r0.xyz = float3(1, 1, 1) + r0.xyz;
  r0.xyz = r0.xyz / colorBlend.yyy;
  r0.xyz = -r0.xyz;
  r1.xyz = float3(1, 1, 1) + r0.xyz;
  r1.xyz = r1.xyz;
  r1.w = r1.w;
  o0.xyzw = r1.xyzw;
  return;
}