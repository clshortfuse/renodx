Texture2D<float4> t0 : register(t0);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t2 : register(t2);

SamplerState s0_s : register(s0);
SamplerState s1_s : register(s1);
SamplerState s2_s : register(s2);

cbuffer cb3 : register(b3) {
  uint4 cb3[77];
}

cbuffer cb4 : register(b4) {
  float4 cb4[236];
}

float4 BitNorm(float4 value, uint4 bit_and, uint4 bit_or) {
  return asfloat((asuint(value) & bit_and) | bit_or);
}

float3 NormalizeSafe(float3 v) {
  float len2 = dot(v, v);
  if (len2 <= 0.f) return 0.f.xxx;
  float inv_len = rsqrt(len2);
  return isinf(inv_len) ? 0.f.xxx : v * inv_len;
}

float DXBCRcp(float x) {
  return abs(x) > 0.f ? rcp(x) : 9.99999993e+36f;
}

float PowLog(float x, float exponent) {
  float p = log2(abs(x)) * exponent;
  return (p == p) ? exp2(p) : 0.f;
}

void main(
    float4 v0 : SV_POSITION0,
    float4 v1 : TEXCOORD8,
    float4 v2 : COLOR0,
    float4 v3 : COLOR1,
    float4 v4 : TEXCOORD9,
    float4 v5 : TEXCOORD0,
    float3 v6 : TEXCOORD1,
    float3 v7 : TEXCOORD2,
    float3 v8 : TEXCOORD3,
    float4 v9 : TEXCOORD4,
    float4 v10 : TEXCOORD5,
    float4 v11 : TEXCOORD6,
    float4 v12 : TEXCOORD7,
    out float4 o0 : SV_TARGET0) {
  float4 r0 = BitNorm(t2.Sample(s2_s, v5.xy), cb3[48], cb3[49]);
  r0.x = r0.w * r0.x;
  r0.xy = (r0.xy - 0.5f.xx) * 2.f;

  float3 n1 = NormalizeSafe(v7);
  float3 n2 = NormalizeSafe(v6);
  float3 n3 = NormalizeSafe(v8);

  float3 blended = r0.y * n1 + r0.x * n2;
  float inv_w = DXBCRcp(rsqrt(abs(1.f - dot(r0.xy, -r0.xy))));
  blended = mad(inv_w, n3, blended);
  float3 normal = NormalizeSafe(blended);

  float focus = dot(normal, cb4[23].xyz);
  focus = 1.f - PowLog(focus, cb4[144].x);

  float4 proj = 0.f.xxxx;
  proj.y = v5.x + 1.f;
  proj.z = v5.y;
  proj.w = 1.f;

  float2 uv0;
  uv0.x = dot(proj.yzww, cb4[137]);
  uv0.y = dot(proj.yzww, cb4[138]);
  float4 s0 = BitNorm(t0.Sample(s0_s, uv0), cb3[44], cb3[45]);

  float2 uv1;
  uv1.x = dot(proj.yzww, cb4[140]);
  uv1.y = dot(proj.yzww, cb4[141]);
  float4 s1 = BitNorm(t0.Sample(s0_s, uv1), cb3[44], cb3[45]);

  float accum = s0.y + s1.y;
  float shaped = mad(accum, -2.f, 1.f);
  accum = mad(max(cb4[143].x, 0.f), shaped, accum);

  float4 mask = BitNorm(t1.Sample(s1_s, v5.xy), cb3[46], cb3[47]);
  accum *= max(mask.w, 0.f);

  float bloom = max(focus, 0.f) * max(accum, 0.f);
  float out_x = bloom * max(cb4[145].x, 0.f);
  float out_y = bloom * max(cb4[136].x, 0.f);
  float4 out_color = max(out_y * out_x.xxxx, 0.f.xxxx);
  out_color = 1.f.xxxx - exp2(-out_color);

  uint alpha_test = (uint)mad(out_color.w, 255.f, 0.0001f);
  if (alpha_test < cb3[8].z) {
    discard;
  }

  o0 = out_color;
}
