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
    uint v13 : SV_IsFrontFace,
    out float4 o0 : SV_TARGET0) {
  float4 r0, r1, r2, r3, r4, r5;

  r0.xyz = cb4[20].xyz - v6.xyz;
  r0.x = dot(r0.xyz, r0.xyz);

  r1.y = rsqrt(abs(r0.x));
  r1.x = (r1.y == asfloat(0x7f800000u)) ? 1.f : 0.f;
  r0.x = (r1.x != 0.f) ? kHuge : r1.y;

  r1.y = (0.f < abs(r0.x)) ? 1.f : 0.f;
  r1.x = rcp(r0.x);
  r0.x = (r1.y != 0.f) ? r1.x : kHuge;

  r0.x = r0.x - cb4[146].x;
  r1.x = cb4[146].x;
  r0.y = cb4[147].x - r1.x;

  r2.y = (0.f < abs(r0.y)) ? 1.f : 0.f;
  r2.x = rcp(r0.y);
  r0.y = (r2.y != 0.f) ? r2.x : kHuge;

  r0.x = saturate(r0.y * r0.x);

  r2.x = (v13 != 0u) ? 1.f : -1.f;
  r3.y = (r2.x >= 0.f) ? 1.f : 0.f;
  r0.y = (r3.y != 0.f) ? 1.f : -1.f;

  r3.x = dot(v9.xyz, v9.xyz);
  r3.x = rsqrt(r3.x);
  r3.y = (r3.x != asfloat(0x7f800000u)) ? 1.f : 0.f;
  r3.x = r3.x * r3.y;
  r1.xyz = r3.xxx * v9.xyz;
  r3.xyz = r1.xyz * (-cb4[102].x);

  r4.y = (-r0.y >= 0.f) ? 1.f : 0.f;
  r4.z = (-r0.y >= 0.f) ? 1.f : 0.f;
  r4.w = (-r0.y >= 0.f) ? 1.f : 0.f;
  r0.y = (r4.y != 0.f) ? r1.x : r3.x;
  r0.z = (r4.z != 0.f) ? r1.y : r3.y;
  r0.w = (r4.w != 0.f) ? r1.z : r3.z;

  r1.x = 1.f;
  r1.z = 0.f;
  r3.xyzw = v6.xyzx * r1.xxxz + (-cb4[20].xyzw);
  r1.y = dot(r3, r3);

  r4.y = rsqrt(abs(r1.y));
  r4.x = (r4.y == asfloat(0x7f800000u)) ? 1.f : 0.f;
  r1.y = (r4.x != 0.f) ? kHuge : r4.y;
  r2.z = r1.y;

  r1.y = r2.z * r3.x;
  r1.z = r2.z * r3.y;
  r1.w = r2.z * r3.z;
  r0.y = dot(float3(r0.y, r0.z, r0.w), float3(r1.y, r1.z, r1.w));

  r4.x = log2(abs(r0.y));
  r4.x = r4.x * cb4[148].x;
  r4.y = (r4.x != r4.x) ? 1.f : 0.f;
  r4.x = (r4.y != 0.f) ? 0.f : r4.x;
  r1.y = exp2(r4.x);

  r0.y = r1.y - 1.f;
  r0.y = cb4[149].x * r0.y + r1.x;
  r0.z = saturate(r0.y);
  r0.z = 1.f - r0.z;
  r4.y = r0.z - r0.y;
  r1.y = cb4[150].x * r4.y + r0.y;

  r0.y = v5.x;
  r0.z = v5.y;
  r0.w = 1.f;

  r3.x = dot(float3(r0.y, r0.z, r0.w), cb4[136].xyz);
  r3.y = dot(float3(r0.y, r0.z, r0.w), cb4[137].xyz);
  r3 = BitNorm(t0.Sample(s0_s, r3.xy), cb3[44], cb3[45]);

  r3.x = dot(float3(r0.y, r0.z, r0.w), cb4[139].xyz);
  r3.y = dot(float3(r0.y, r0.z, r0.w), cb4[140].xyz);
  r4 = BitNorm(t1.Sample(s1_s, r3.xy), cb3[46], cb3[47]);

  r5.y = r4.w - r3.w;
  r0.y = max(cb4[142].x * r5.y + r3.w, 0.f);
  r0.z = dot(float3(0.33f, 0.33f, 0.33f), r4.xyz);
  r5.z = r0.z - r0.y;
  r1.z = max(cb4[143].x * r5.z + r0.y, 0.f);

  r0.y = r1.z * max(cb4[151].x, 0.f);
  r0.y = r0.y * r1.y;
  r0.z = v2.w - 1.f;
  r0.z = max(cb4[152].x * r0.z + r1.x, 0.f);
  r0.y = r0.z * r0.y;
  r0.x = r0.y * r0.x;

  r0.y = 1.f - r1.z;
  r0.z = saturate(r1.z - cb4[145].x);
  r0.w = r1.x - cb4[144].x;
  r0.y = saturate(r0.y - r0.w);
  r1.x = min(r0.z, r0.y);
  r0.x = r0.x * r1.x;

  r1.x = cb4[151].x;
  r0.y = r1.x * max(cb4[153].x, 0.f);
  r0.y = r0.y * r1.y;

  r5 = max(r0.xxxx * r0.yyyy, 0.f);
  r5 = 1.f - exp2(-r5);

  r0.w = r5.w * 255.f + 0.0001f;
  r0.w = (uint)r0.w;
  r0.w = ((uint)r0.w < asuint(cb3[8].z)) ? 1.f : 0.f;
  if (r0.w != 0.f) discard;

  o0 = r5;
}
