cbuffer cb3 : register(b3) {
  uint4 cb3[77];
}

cbuffer cb4 : register(b4) {
  float4 cb4[236];
}

SamplerState s0_s : register(s0);

Texture2D<float4> t0 : register(t0);

float SafeRcp(float x) {
  return abs(x) > 0.f ? rcp(x) : 0.f;
}

float4 BitNorm(float4 value, uint4 bit_and, uint4 bit_or) {
  return asfloat((asuint(value) & bit_and) | bit_or);
}

void main(
    float4 v0 : SV_POSITION0,
    float4 v1 : TEXCOORD8,
    float4 v2 : COLOR0,
    float4 v3 : COLOR1,
    float4 v4 : TEXCOORD9,
    float4 v5 : TEXCOORD0,
    float4 v6 : TEXCOORD1,
    float4 v7 : TEXCOORD2,
    float4 v8 : TEXCOORD3,
    float4 v9 : TEXCOORD4,
    float4 v10 : TEXCOORD5,
    float4 v11 : TEXCOORD6,
    float4 v12 : TEXCOORD7,
    out float4 o0 : SV_TARGET0) {
  float2 uv = v5.xy;
  float4 sample0 = BitNorm(t0.Sample(s0_s, uv), cb3[44], cb3[45]);

  float base = max(sample0.w * v2.w, 0.f);
  float luminance = max(dot(sample0.rgb, float3(0.33f, 0.33f, 0.33f)), 0.f);
  float mixed = max(lerp(base, luminance, cb4[143].x), 0.f);

  float edge_fade = cb4[152].x * (v2.w - 1.f) + 1.f;
  float highlight = max(mixed * cb4[151].x * edge_fade, 0.f);

  float fade_out = saturate(1.f - luminance);
  float fade_in = saturate(luminance - cb4[145].x);
  float fade_gate = min(fade_in, saturate(fade_out + (cb4[144].x - 1.f)));

  float intensity = max(highlight * fade_gate, 0.f);
  float gain = max(cb4[151].x * cb4[153].x, 0.f);
  float bloom = max(intensity * gain, 0.f);

  float bloom_out = 1.f - exp2(-bloom);
  o0 = bloom_out.xxxx;
}
