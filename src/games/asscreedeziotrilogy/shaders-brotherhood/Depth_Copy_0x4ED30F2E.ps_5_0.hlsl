Texture2D<float4> t0 : register(t0);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t3 : register(t3);

SamplerState s0_s : register(s0);
SamplerState s1_s : register(s1);
SamplerState s2_s : register(s2);
SamplerState s3_s : register(s3);

cbuffer cb3 : register(b3) {
  float4 cb3[77];
}

cbuffer cb4 : register(b4) {
  float4 cb4[236];
}

static const float kHuge = 9.9999999338158125e+33f;

float4 BitNorm(float4 value, float4 bit_and, float4 bit_or) {
  return asfloat((asuint(value) & asuint(bit_and)) | asuint(bit_or));
}

float DXBCRcp(float x) {
  return abs(x) > 0.f ? rcp(x) : kHuge;
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
  o0.xyz = 1.f.xxx;
  o0.w = 1.f;
}
