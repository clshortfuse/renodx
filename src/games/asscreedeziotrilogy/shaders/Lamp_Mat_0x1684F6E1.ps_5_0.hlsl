// Hand-decompiled from DXBC.

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb3 : register(b3) {
  uint4 cb3[77];
}

cbuffer cb4 : register(b4) {
  float4 cb4[236];
}

float4 BitNorm(float4 value, uint4 bit_and, uint4 bit_or) {
  return asfloat((asuint(value) & bit_and) | bit_or);
}

float SafeRcp(float x) {
  return abs(x) > 0.f ? rcp(x) : 0.f;
}

void main(
    float4 v0 : SV_POSITION0,
    float4 v1 : TEXCOORD8,
    linear centroid float4 v2 : COLOR0,
    linear centroid float4 v3 : COLOR1,
    float4 v4 : TEXCOORD9,
    float4 v5 : TEXCOORD0,
    float4 v6 : TEXCOORD1,
    float4 v7 : TEXCOORD2,
    float4 v8 : TEXCOORD3,
    float4 v9 : TEXCOORD4,
    float4 v10 : TEXCOORD5,
    float4 v11 : TEXCOORD6,
    float4 v12 : TEXCOORD7,
    out float4 o0 : SV_TARGET0,
    out float4 o1 : SV_TARGET1) {
  if (any(v6.w < 0.f)) discard;

  float3 to_light = cb4[20].xyz - v6.xyz;
  float dist2 = dot(to_light, to_light);
  float dist = dist2 > 0.f ? sqrt(dist2) : 0.f;
  float falloff = saturate((dist - cb4[25].x) * cb4[25].y) * cb4[25].z;

  float4 sample0 = BitNorm(t0.Sample(s0_s, v5.xy), cb3[44], cb3[45]) * cb4[136];

  float4 material = float4(sample0.xyz, 1.f) * v3;
  float4 emissive = float4(2.f, 2.f, 2.f, sample0.w) * material;
  emissive.xyz = saturate(emissive.xyz);

  float3 target = cb4[24].xyz;
  o0.xyz = mad(falloff.xxx, target - emissive.xyz, emissive.xyz);

  float aux = 0.f;
  if (abs(v2.w) > 0.f) {
    aux = v2.z / v2.w;
  }
  o1.xyz = aux.xxx;

  o0.xyz = saturate(o0.xyz);
  o0.w = saturate(emissive.w);
  o1.w = saturate(emissive.w);
}
