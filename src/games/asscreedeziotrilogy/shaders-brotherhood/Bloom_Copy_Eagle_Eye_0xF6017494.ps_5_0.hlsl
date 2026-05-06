Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb3 : register(b3) {
  float4 cb3[77];
}

cbuffer cb4 : register(b4) {
  float4 cb4[236];
}

static const float kHuge = 9.9999999338158125e+33f;
static const float kHugeNeg = -9.9999999338158125e+33f;

float DXBCRcp(float x) {
  return abs(x) > 0.f ? rcp(x) : kHuge;
}

float4 BitNorm(float4 c, float4 mask, float4 set) {
  return asfloat((asuint(c) & asuint(mask)) | asuint(set));
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
  float4 r0, r1, r2;

  r0.xyz = cb4[20].xyz - v6.xyz;
  r0.x = dot(r0.xyz, r0.xyz);

  r1.y = rsqrt(abs(r0.x));
  r1.x = (r1.y == asfloat(0x7f800000u)) ? 1.f : 0.f;
  r0.x = (r1.x != 0.f) ? kHuge : r1.y;

  r1.y = (0.f < abs(r0.x)) ? 1.f : 0.f;
  r1.x = rcp(r0.x);
  r0.x = (r1.y != 0.f) ? r1.x : kHuge;

  r0.x = saturate(r0.x * 0.083333f);
  r0.x *= r0.x;
  r0.y = r0.x * r0.x;
  r0.x = r0.y * r0.x;

  r2.x = dot(v9.xyz, v9.xyz);
  r2.x = rsqrt(r2.x);
  r2.y = (r2.x != asfloat(0x7f800000u)) ? 1.f : 0.f;
  r2.x = r2.x * r2.y;
  r1.xyz = r2.x * v9.xyz;

  r0.y = dot(cb4[23].xyz, r1.xyz);
  r2.y = log(abs(r0.y));
  r2.x = (r2.y == asfloat(0xff800000u)) ? 1.f : 0.f;
  r0.y = (r2.x != 0.f) ? kHugeNeg : r2.y;

  r0.yz = r0.y * float2(0.12f, 0.7f);
  r0.z = exp(r0.z);
  r0.y = exp(r0.y);
  r0.z = r0.z - r0.y;
  r0.x = max(r0.z * r0.x, 0.f);
  r0.x = saturate(cb4[136].x * r0.x + r0.y);
  r0.x = 1.f - r0.x;
  r0.x *= max(cb4[137].x, 0.f);

  r1 = BitNorm(t0.Sample(s0_s, v5.xy), cb3[44], cb3[45]);
  r0.y = max(r1.w * v2.w, 0.f);
  r0.z = r1.w - 0.1f;
  r0.w = abs(r0.y) * abs(r0.y);
  r0.w *= r0.w;
  r0.y = r0.w * abs(r0.y);
  r0.w = frac(-r0.z);
  r0.z = saturate(r0.w + r0.z);
  r2.y = (-r0.z >= 0.f) ? 1.f : 0.f;
  r0.y = (r2.y != 0.f) ? 1.f : r0.y;

  r0.x *= max(r0.y, 0.f);
  r2 = max(12.f * r0.xxxx, 0.f);

  r0.w = r2.w * 255.f + 0.0001f;
  r0.w = (uint)r0.w;
  r0.w = ((uint)r0.w < asuint(cb3[8].z)) ? 1.f : 0.f;
  if (r0.w != 0.f) discard;

  o0 = r2;
}
