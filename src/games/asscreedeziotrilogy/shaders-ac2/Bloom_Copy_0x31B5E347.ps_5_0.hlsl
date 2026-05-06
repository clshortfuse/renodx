Texture2D<float4> t0 : register(t0);
Texture2D<float4> t1 : register(t1);

SamplerState s0_s : register(s0);
SamplerState s1_s : register(s1);

cbuffer cb3 : register(b3) {
  float4 cb3[77];
}

cbuffer cb4 : register(b4) {
  float4 cb4[236];
}

static const float kHuge = 9.9999999338158125e+33f;

float DXBCRcp(float x) {
  return abs(x) > 0.f ? rcp(x) : kHuge;
}

float4 BitNorm(float4 sample_value, float4 and_mask, float4 or_mask) {
  uint4 bits = asuint(sample_value);
  bits &= asuint(and_mask);
  bits |= asuint(or_mask);
  return asfloat(bits);
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
  float4 r0, r1, r2, r3, r4, r5;

  r0.xyz = float3(v5.x + 0.f, v5.x + 0.f, 1.f);
  r0.x = v5.x * 1.f + 0.f;
  r0.y = v5.y * 1.f + 0.f;
  r0.z = v5.x * 0.f + 1.f;

  r1.x = dot(r0.xyz, cb4[136].xyz);
  r1.y = dot(r0.xyz, cb4[137].xyz);
  r1 = BitNorm(t0.Sample(s0_s, r1.xy), cb3[44], cb3[45]);

  r1.x = dot(r0.xyz, cb4[139].xyz);
  r1.y = dot(r0.xyz, cb4[140].xyz);
  r0 = BitNorm(t1.Sample(s1_s, r1.xy), cb3[46], cb3[47]);

  r3.x = r0.w - r1.w;
  r2.x = cb4[142].x * r3.x + r1.w;
  r0.x = dot(float3(0.33f, 0.33f, 0.33f), r0.xyz);
  r3.x = r0.x - r2.x;
  r1.x = cb4[143].x * r3.x + r2.x;
  r0.x = 1.f - r1.x;
  r2.x = 1.f;
  r0.y = r2.x - cb4[144].x;
  r0.x = saturate(r0.x - r0.y);
  r0.y = saturate(r1.x - cb4[145].x);
  r0.z = max(r1.x * cb4[151].x, 0.f);
  r1.x = min(r0.y, r0.x);

  r4.x = dot(v9.xyz, v9.xyz);
  r4.x = rsqrt(r4.x);
  r4.x = (r4.x != asfloat(0x7f800000u)) ? r4.x : 0.f;
  r3.xyz = r4.x * v9.xyz;

  r5.x = dot(v10.xyz, v10.xyz);
  r5.x = rsqrt(r5.x);
  r5.x = (r5.x != asfloat(0x7f800000u)) ? r5.x : 0.f;
  r4.xyz = r5.x * v10.xyz;

  r0.x = dot(r3.xyz, r4.xyz);
  r5.x = log(abs(r0.x));
  r5.x *= cb4[148].x;
  r5.x = (r5.x != r5.x) ? 0.f : r5.x;
  r1.y = exp(r5.x);
  r0.x = r1.y - 1.f;
  r0.x = cb4[149].x * r0.x + r2.x;
  r0.y = saturate(r0.x);
  r0.y = 1.f - r0.y;
  r5.y = r0.y - r0.x;
  r1.y = max(cb4[150].x * r5.y + r0.x, 0.f);
  r0.x = max(r0.z * r1.y, 0.f);
  r0.x *= max(v2.w, 0.f);

  r0.yzw = cb4[20].xyz - v6.xyz;
  r0.y = dot(r0.yzw, r0.yzw);
  r5.y = rsqrt(abs(r0.y));
  r0.y = (r5.y == asfloat(0x7f800000u)) ? kHuge : r5.y;
  r0.y = abs(r0.y) > 0.f ? rcp(r0.y) : kHuge;
  r0.y -= cb4[146].x;
  r2.x = cb4[146].x;
  r0.z = cb4[147].x - r2.x;
  r0.z = DXBCRcp(r0.z);
  r0.y = saturate(r0.z * r0.y);
  r0.x *= max(r0.y, 0.f);
  r0.x *= max(r1.x, 0.f);
  r1.x = cb4[151].x;
  r0.y = max(r1.x * cb4[152].x, 0.f);
  r0.y *= max(r1.y, 0.f);

  o0 = r0.xxxx * r0.yyyy;
  o0.rgb = saturate(o0.rgb);
  o0.a = saturate(o0.a);
}
