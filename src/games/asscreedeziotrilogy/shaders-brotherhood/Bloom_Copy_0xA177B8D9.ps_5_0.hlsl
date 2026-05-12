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

float DXBCRcp(float x) {
  return abs(x) > 0.f ? rcp(x) : kHuge;
}

float SafePositiveRcp(float x) {
  return x > 1e-6f ? rcp(x) : 0.f;
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

  r0 = v6.wwww;

  r1.xyz = (r0.xyz < 0.f.xxx) ? 1.f.xxx : 0.f.xxx;
  r1.x = (r1.y != 0.f || r1.x != 0.f) ? 1.f : 0.f;
  r1.x = (r1.z != 0.f || r1.x != 0.f) ? 1.f : 0.f;
  if (r1.x != 0.f) discard;

  r0.x = 1.f;
  r0.y = 0.f;
  r1 = v6.xyzx * float4(r0.x, r0.x, r0.x, r0.y) - cb4[20];
  r0.y = dot(r1, r1);

  r2.y = rsqrt(abs(r0.y));
  r2.x = (r2.y == asfloat(0x7f800000u)) ? 1.f : 0.f;
  r0.y = (r2.x != 0.f) ? kHuge : r2.y;
  r0.yzw = r0.y * float3(r1.x, r1.y, r1.z);

  r2.x = dot(v9.xyz, v9.xyz);
  r2.x = rsqrt(r2.x);
  r2.y = (r2.x != asfloat(0x7f800000u)) ? 1.f : 0.f;
  r2.x = (r2.y != 0.f) ? r2.x : 0.f;
  r1.xyz = r2.x * v9.xyz;

  r0.y = dot(r1.xyz, r0.yzw);
  r2.x = log2(abs(r0.y));
  r2.x = r2.x * cb4[148].x;
  r2.y = (r2.x != r2.x) ? 1.f : 0.f;
  r2.x = (r2.y != 0.f) ? 0.f : r2.x;
  r1.x = exp2(r2.x);

  r0.y = r1.x - 1.f;
  r0.y = cb4[149].x * r0.y + r0.x;
  r0.z = saturate(r0.y);
  r0.z = 1.f - r0.z;
  r2.x = r0.z - r0.y;
  r1.x = cb4[150].x * r2.x + r0.y;

  r0.y = v5.x;
  r0.z = v5.y;
  r0.w = 1.f;

  r2.x = dot(r0.yzw, cb4[136].xyz);
  r2.y = dot(r0.yzw, cb4[137].xyz);
  r2 = t0.Sample(s0_s, r2.xy);
  r2 = BitNorm(r2, cb3[44], cb3[45]);

  r3.x = dot(r0.yzw, cb4[139].xyz);
  r3.y = dot(r0.yzw, cb4[140].xyz);
  r3 = t1.Sample(s1_s, r3.xy);
  r3 = BitNorm(r3, cb3[46], cb3[47]);

  r4.y = r3.w - r2.w;
  r0.y = max(cb4[142].x * r4.y + r2.w, 0.f);

  r1.y = max(r2.x, 0.f) * max(cb4[153].x, 0.f);
  r1.z = max(r2.y, 0.f) * max(cb4[153].y, 0.f);
  r1.w = max(r2.z, 0.f) * max(cb4[153].z, 0.f);
  r0.z = dot(r3.xyz, 0.33f.xxx);
  r4.x = r0.z - r0.y;
  r2.x = max(cb4[143].x * r4.x + r0.y, 0.f);

  r0.y = r2.x * max(cb4[151].x, 0.f);
  r0.y = r0.y * r1.x;

  r3 = v3.wxyz - 1.f.xxxx;
  r0.z = max(cb4[152].x * r3.x + r0.x, 0.f);
  r2.y = max(cb4[154].x * r3.y + r0.x, 0.f);
  r2.z = max(cb4[154].x * r3.z + r0.x, 0.f);
  r2.w = max(cb4[154].x * r3.w + r0.x, 0.f);
  r0.y = r0.z * r0.y;

  r3.xyz = cb4[20].xyz - v6.xyz;
  r0.z = dot(r3.xyz, r3.xyz);

  r4.y = rsqrt(abs(r0.z));
  r4.x = (r4.y == asfloat(0x7f800000u)) ? 1.f : 0.f;
  r0.z = (r4.x != 0.f) ? kHuge : r4.y;
  r4.y = (0.f < abs(r0.z)) ? 1.f : 0.f;
  r4.x = rcp(r0.z);
  r0.z = (r4.y != 0.f) ? r4.x : kHuge;

  r0.w = r0.z - cb4[146].x;
  r0.z = r0.z - cb4[25].x;
  r0.z = saturate(r0.z * cb4[25].y);
  r0.z = r0.z * cb4[25].z;

  r1.x = cb4[146].x;
  r1.x = cb4[147].x - r1.x;
  r4.y = (0.f < abs(r1.x)) ? 1.f : 0.f;
  r4.x = rcp(r1.x);
  r1.x = (r4.y != 0.f) ? r4.x : kHuge;
  r0.w = saturate(r0.w * r1.x);

  r0.y = max(r0.y * r0.w, 0.f);
  r0.w = 1.f - r2.x;
  r1.x = saturate(r2.x - cb4[145].x);
  r0.x = r0.x - cb4[144].x;
  r0.x = saturate(r0.w - r0.x);
  r2.x = min(r1.x, r0.x);
  r0.x = max(r0.y * r2.x, 0.f);

  r3.x = r1.y * r2.y - 1.f;
  r3.y = r1.z * r2.z - 1.f;
  r3.z = r1.w * r2.w - 1.f;
  r3.xyz = r0.x * r3.xyz + 1.f.xxx;
  r3.x = r3.x - r1.y * r2.y;
  r3.y = r3.y - r1.z * r2.z;
  r3.z = r3.z - r1.w * r2.w;
  r1.x = r1.y * r2.y;
  r1.y = r1.z * r2.z;
  r1.z = r1.w * r2.w;
  r1.xyz = saturate(cb4[155].x * r3.xyz + r1.xyz);

  r2.xyz = cb4[24].xyz - r1.xyz;
  o0.xyz = max(r0.z * r2.xyz + r1.xyz, 0.f.xxx);
  o0.xyz = 1.f.xxx - exp2(-o0.xyz);

  r0.y = SafePositiveRcp(v2.w);
  o1.xyz = max(r0.y * v2.zzz, 0.f.xxx);
  o1.xyz = 1.f.xxx - exp2(-o1.xyz);

  r0.x = 1.f - exp2(-r0.x);
  o0.w = r0.x;
  o1.w = r0.x;
}
