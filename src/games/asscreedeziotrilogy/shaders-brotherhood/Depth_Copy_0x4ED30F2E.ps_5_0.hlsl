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

float4 BitNorm(float4 c, float4 mask, float4 set) {
  return asfloat((asuint(c) & asuint(mask)) | asuint(set));
}

float DXBCRcp(float x) {
  return abs(x) > 0.f ? rcp(x) : kHuge;
}

float SafeDepthRcp(float x) {
  return abs(x) > 1e-6f ? rcp(x) : 0.f;
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
  float4 r0, r1, r2, r3;

  r0 = saturate(t2.Sample(s2_s, v7.xy));
  r0.x = (r0.x + cb4[10].x);
  r0.x = SafeDepthRcp(r0.x);
  r0.x *= cb4[10].y;

  r1 = saturate(t2.Sample(s2_s, v7.zw));
  r1.x = (r1.x + cb4[10].x);
  r1.x = SafeDepthRcp(r1.x);
  r0.y = r1.x * cb4[10].y;

  r1 = saturate(t2.Sample(s2_s, v8.xy));
  r1.x = (r1.x + cb4[10].x);
  r1.x = SafeDepthRcp(r1.x);
  r0.z = r1.x * cb4[10].y;

  r1 = saturate(t2.Sample(s2_s, v8.zw));
  r1.x = (r1.x + cb4[10].x);
  r1.x = SafeDepthRcp(r1.x);
  r0.w = r1.x * cb4[10].y;

  r1 = saturate(t0.Sample(s0_s, v5.xy));
  r1.x = (r1.x + cb4[10].x);
  r1.x = SafeDepthRcp(r1.x);
  r0 = mad(cb4[10].y, -r1.xxxx, r0);

  r1.x *= cb4[10].y;
  r1.x = SafeDepthRcp(r1.x);
  r1.x *= 50.f;
  r1.x = min(r1.x, 8.f);
  r0 = saturate(1.f - abs(r0) * r1.xxxx);
  r0 = max(r0, 0.5f.xxxx);

  r1 = saturate(t1.Sample(s1_s, v6.xy));
  r2 = r0 * r1;
  r2 = (0.f <= r2.x) ? r1 : 0.f.xxxx;
  r0 = mad(r1, r0, r2);

  r1.x = max(dot(r0, 1.f.xxxx), 0.05f);
  r1.x = rcp(r1.x);
  r0 *= r1.xxxx;

  r1 = saturate(t3.Sample(s3_s, v7.xy));
  r2 = saturate(t3.Sample(s3_s, v7.zw));
  r1.x = saturate(r1.x);
  r1.y = saturate(r2.x);
  r2 = saturate(t3.Sample(s3_s, v8.xy));
  r1.z = saturate(r2.x);
  r2 = saturate(t3.Sample(s3_s, v8.zw));
  r1.w = saturate(r2.x);

  r0.x = dot(r1, r0);
  r3.x = log2(max(abs(r0.x), 1e-6f));
  r3.x *= cb4[12].y;
  r3.y = (r3.x != r3.x) ? 1.f : 0.f;
  r3.x = (r3.y != 0.f) ? 0.f : r3.x;
  r1.x = exp2(r3.x);

  r0.x = r1.x - 1.f;
  o0.xyz = cb4[12].x * r0.xxx + 1.f.xxx;
  o0.w = 1.f;
}
