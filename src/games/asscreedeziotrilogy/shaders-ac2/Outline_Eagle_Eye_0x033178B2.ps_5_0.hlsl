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
    out float4 o0 : SV_TARGET0,
    out float4 o1 : SV_TARGET1) {
  float4 r0, r1, r2, r3, r4;

  r0 = v7.wwww;
  if (r0.x < 0.f || r0.y < 0.f || r0.z < 0.f) discard;

  r0.xyz = cb4[20].xyz - v7.xyz;
  r0.x = dot(r0.xyz, r0.xyz);
  r1.y = rsqrt(abs(r0.x));
  r0.x = (r1.y == asfloat(0x7f800000u)) ? kHuge : r1.y;
  r0.x = abs(r0.x) > 0.f ? rcp(r0.x) : kHuge;
  r0.x = saturate(r0.x * 0.083333f);
  r0.x *= r0.x;
  r0.y = r0.x * r0.x;
  r0.x = r0.y * r0.x;

  r2.x = dot(v10.xyz, v10.xyz);
  r2.x = rsqrt(r2.x);
  r2.x = (r2.x != asfloat(0x7f800000u)) ? r2.x : 0.f;
  r1.xyz = r2.x * v10.xyz;

  r0.y = dot(v11.xyz, v11.xyz);
  r2.y = rsqrt(abs(r0.y));
  r0.y = (r2.y == asfloat(0x7f800000u)) ? kHuge : r2.y;
  r2.xyz = r0.y * v11.xyz;
  r0.y = DXBCRcp(r0.y);
  r0.y = saturate((r0.y - cb4[25].x) * cb4[25].y);
  r0.y *= cb4[25].z;

  r0.z = dot(r2.xyz, r1.xyz);
  r3.y = log(abs(r0.z));
  r0.z = (r3.y == asfloat(0xff800000u)) ? kHugeNeg : r3.y;
  r0.zw = r0.z * float2(0.12f, 0.7f);
  r0.w = exp(r0.w);
  r0.z = exp(r0.z);
  r0.w = r0.w - r0.z;
  r0.x = max(r0.w * r0.x, 0.f);
  r0.x = saturate(cb4[136].x * r0.x + r0.z);
  r0.x = 1.f - r0.x;
  r0.x *= max(cb4[137].x, 0.f);

  r1.xyz = r0.xxx * cb4[138].xyz;
  r2.xyz = cb4[138].xyz - cb4[138].xyz * r0.xxx + cb4[24].xyz * r0.xxx;
  r3.xyz = r0.yyy * r2.xyz + r1.xyz;

  r0.y = DXBCRcp(v6.w);
  o1.xyz = r0.yyy * v6.zzz;

  r1 = BitNorm(t0.Sample(s0_s, v5.xy), cb3[44], cb3[45]);
  r0.y = max(r1.w * v2.w, 0.f);
  r0.z = r1.w - 0.1f;
  r0.w = abs(r0.y) * abs(r0.y);
  r0.w *= r0.w;
  r0.y = r0.w * abs(r0.y);
  r0.w = frac(-r0.z);
  r0.z = saturate(r0.w + r0.z);
  r0.y = (-r0.z >= 0.f) ? 1.f : r0.y;
  r0.x *= max(r0.y, 0.f);
  r3.w = r0.x;
  o1.w = r0.x;

  r0.w = r3.w * 255.f + 0.0001f;
  if ((uint)r0.w < asuint(cb3[8].z)) discard;

  o0 = r3;
}
