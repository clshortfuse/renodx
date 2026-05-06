Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

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
    out float4 o0 : SV_TARGET0) {
  float4 r0, r1, r2, r3, r4;

  r1.x = dot(v5.xy, v5.xy);
  r0.x = r1.x + 0.f;

  r1.y = rsqrt(abs(r0.x));
  r1.x = (r1.y == asfloat(0x7f800000u)) ? 1.f : 0.f;
  r0.x = (r1.x != 0.f) ? kHuge : r1.y;

  r1.y = (0.f < abs(r0.x)) ? 1.f : 0.f;
  r1.x = rcp(r0.x);
  r0.y = (r1.y != 0.f) ? r1.x : kHuge;

  float inv_len = r0.x;
  float inv_radius2 = r0.y;

  r0.x = inv_len * v5.x;
  r0.z = inv_len * v5.y;
  r0.w = inv_radius2 - cb4[9].x;

  r1.x = min(cb4[9].x, inv_radius2);
  float clamp_radius = r1.x;

  r1.x = r0.x * clamp_radius + cb4[8].x;
  r1.y = r0.z * clamp_radius + cb4[8].y;
  r1.z = max(r0.w, 0.f);

  r0.y = r0.x * r1.z + r1.x;
  r0.w = r0.z * r1.z + r1.y;
  r0.x = r0.x * r1.z;
  r0.z = r0.z * r1.z;

  r2 = t0.Sample(s0_s, r0.yw);

  r3.y = 0.142857f;
  r3.z = 1.f;

  r0.y = cb4[10].x * r3.y + r3.z;
  r1.z = r0.x * r0.y + r1.x;
  r1.w = r0.z * r0.y + r1.y;
  r0.y = cb4[10].x * r3.y + r0.y;
  r4 = t0.Sample(s0_s, r1.zw);
  r2 += r4;

  r1.z = r0.x * r0.y + r1.x;
  r1.w = r0.z * r0.y + r1.y;
  r0.y = cb4[10].x * r3.y + r0.y;
  r4 = t0.Sample(s0_s, r1.zw);
  r2 += r4;

  r1.z = r0.x * r0.y + r1.x;
  r1.w = r0.z * r0.y + r1.y;
  r0.y = cb4[10].x * r3.y + r0.y;
  r4 = t0.Sample(s0_s, r1.zw);
  r2 += r4;

  r1.z = r0.x * r0.y + r1.x;
  r1.w = r0.z * r0.y + r1.y;
  r0.y = cb4[10].x * r3.y + r0.y;
  r4 = t0.Sample(s0_s, r1.zw);
  r2 += r4;

  r1.z = r0.x * r0.y + r1.x;
  r1.w = r0.z * r0.y + r1.y;
  r0.y = cb4[10].x * r3.y + r0.y;
  r4 = t0.Sample(s0_s, r1.zw);
  r2 += r4;

  r1.z = r0.x * r0.y + r1.x;
  r1.w = r0.z * r0.y + r1.y;
  r0.y = cb4[10].x * r3.y + r0.y;

  r0.x = r0.x * r0.y + r1.x;
  r0.y = r0.z * r0.y + r1.y;

  r0 = t0.Sample(s0_s, r0.xy);
  r1 = t0.Sample(s0_s, r1.zw);
  r1 += r2;
  r0 += r1;

  o0 = r0 * 0.125f;
}
