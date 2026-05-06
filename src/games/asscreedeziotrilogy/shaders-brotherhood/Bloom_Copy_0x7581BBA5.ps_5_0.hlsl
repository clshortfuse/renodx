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
    uint v13 : SV_IsFrontFace,
    out float4 o0 : SV_TARGET0) {
  float4 r0, r1, r2, r3, r4;

  r0.xy = cb4[136].xx * v5.xy;
  r0 = BitNorm(t1.Sample(s1_s, r0.xy), cb3[46], cb3[47]);
  r0.x = r0.w * r0.x;
  r0.xy = (r0.xy - 0.5f) * 2.f;
  r1.w = dot(r0.xy, -r0.xy);
  r0.w = 1.f + r1.w;

  r1.y = rsqrt(abs(r0.w));
  r1.x = (r1.y == asfloat(0x7f800000u)) ? 1.f : 0.f;
  r0.w = (r1.x != 0.f) ? kHuge : r1.y;

  r1.y = (0.f < abs(r0.w)) ? 1.f : 0.f;
  r1.x = rcp(r0.w);
  r0.z = (r1.y != 0.f) ? r1.x : kHuge;

  r1 = BitNorm(t2.Sample(s2_s, v5.xy), cb3[48], cb3[49]);
  r3.xyz = r0.xyz + float3(0.f, 0.f, -1.f);
  r2.xyz = r1.zzz * r3.xyz + float3(0.f, 0.f, 1.f);

  r0 = BitNorm(t3.Sample(s3_s, v5.xy), cb3[50], cb3[51]);
  r0.x = r0.w * r0.x;
  r0.xy = (r0.xy - 0.5f) * 2.f;
  r3.w = dot(r0.xy, -r0.xy);
  r0.w = 1.f + r3.w;

  r3.y = rsqrt(abs(r0.w));
  r3.x = (r3.y == asfloat(0x7f800000u)) ? 1.f : 0.f;
  r0.w = (r3.x != 0.f) ? kHuge : r3.y;

  r3.y = (0.f < abs(r0.w)) ? 1.f : 0.f;
  r3.x = rcp(r0.w);
  r0.z = (r3.y != 0.f) ? r3.x : kHuge;

  r0.xyz = r0.xyz + r2.xyz;
  r0.xyz *= float3(1.f, 1.f, 0.7f);

  r3.x = dot(r0.xyz, r0.xyz);
  r3.x = rsqrt(r3.x);
  r3.y = (r3.x != asfloat(0x7f800000u)) ? 1.f : 0.f;
  r3.x *= r3.y;
  r1.xyz = r3.xxx * r0.xyz;

  r3.x = dot(v8.xyz, v8.xyz);
  r3.x = rsqrt(r3.x);
  r3.y = (r3.x != asfloat(0x7f800000u)) ? 1.f : 0.f;
  r3.x *= r3.y;
  r0.xyz = r3.xxx * v8.xyz;
  r0.xyz *= r1.yyy;

  r3.x = dot(v7.xyz, v7.xyz);
  r3.x = rsqrt(r3.x);
  r3.y = (r3.x != asfloat(0x7f800000u)) ? 1.f : 0.f;
  r3.x *= r3.y;
  r2.xyz = r3.xxx * v7.xyz;
  r0.xyz = r1.xxx * r2.xyz + r0.xyz;

  r3.x = dot(v9.xyz, v9.xyz);
  r3.x = rsqrt(r3.x);
  r3.y = (r3.x != asfloat(0x7f800000u)) ? 1.f : 0.f;
  r3.x *= r3.y;
  r2.xyz = r3.xxx * v9.xyz;
  r0.xyz = r1.zzz * r2.xyz + r0.xyz;

  r3.x = dot(r0.xyz, r0.xyz);
  r3.x = rsqrt(r3.x);
  r3.y = (r3.x != asfloat(0x7f800000u)) ? 1.f : 0.f;
  r3.x *= r3.y;
  r1.xyz = r3.xxx * r0.xyz;

  r0.xyz = r1.xyz * (-cb4[102].x);

  r3.x = (v13 != 0u) ? 1.f : -1.f;
  r4.w = (r3.x >= 0.f) ? 1.f : 0.f;
  r0.w = (r4.w != 0.f) ? 1.f : -1.f;
  r4.xyz = (-r0.www >= 0.f) ? 1.f : 0.f;
  r0.xyz = (r4.xyz != 0.f) ? r1.xyz : r0.xyz;

  r1.x = 1.f;
  r1.z = 0.f;
  r1 = v6.xyzx * (-r1.xxxz) + cb4[20];
  r0.w = dot(r1, r1);

  r4.y = rsqrt(abs(r0.w));
  r4.x = (r4.y == asfloat(0x7f800000u)) ? 1.f : 0.f;
  r0.w = (r4.x != 0.f) ? kHuge : r4.y;

  r1.xyz = r0.www * r1.xyz;
  r0.x = saturate(dot(r1.xyz, r0.xyz));

  r4.x = log(abs(r0.x));
  r4.x *= 0.3f;
  r4.y = (r4.x != r4.x) ? 1.f : 0.f;
  r4.x = (r4.y != 0.f) ? 0.f : r4.x;
  r1.x = exp(r4.x);

  r0.x *= r0.x;
  r0.x *= 16.f;

  r2 = BitNorm(t0.Sample(s0_s, v5.xy), cb3[44], cb3[45]);
  r0.y = r2.w * v2.w;
  r0.y = r1.x * r0.y;
  r0.y *= max(cb4[137].x, 0.f);

  r0.z = v6.z * 111.408455f + 0.5f;
  r0.z = frac(r0.z);
  r0.z = r0.z * 6.283185f - 3.141593f;
  sincos(r0.z, r1.y, r4.x);
  r0.z = r1.y * cb4[138].x;
  r0.w = frac(r0.z);
  r0.z = saturate(r0.z - r0.w);
  r4.y = (-r0.z >= 0.f) ? 1.f : 0.f;
  r0.y = (r4.y != 0.f) ? 12.f : r0.y;
  r0.y *= max(r2.w, 0.f);
  r0.y *= max(cb4[139].x, 0.f);

  r0.z = frac(r0.x);
  r0.x = r0.x - r0.z;
  r0.x *= 0.0625f;
  r1.x = cb4[140].x;
  r0.z = cb4[141].x - r1.x;
  r0.x = r0.x * r0.z + cb4[140].x;

  r4 = max(r0.yyyy * r0.xxxx, 0.f);
  r4 = 1.f - exp2(-r4);

  r0.w = r4.w * 255.f + 0.0001f;
  r0.w = (uint)r0.w;
  r0.w = ((uint)r0.w < asuint(cb3[8].z)) ? 1.f : 0.f;
  if (r0.w != 0.f) discard;

  o0 = r4;
}
