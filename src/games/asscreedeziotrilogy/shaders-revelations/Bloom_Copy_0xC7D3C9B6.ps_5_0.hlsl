Texture2D<float4> t0 : register(t0);
Texture2D<float4> t1 : register(t1);

SamplerState s0_s : register(s0);
SamplerState s1_s : register(s1);

cbuffer cb3 : register(b3) {
  uint4 cb3[77];
}

cbuffer cb4 : register(b4) {
  float4 cb4[236];
}

float4 BitNorm(float4 value, uint4 bit_and, uint4 bit_or) {
  return asfloat((asuint(value) & bit_and) | bit_or);
}

float DXBCRcp(float x) {
  return abs(x) > 0.f ? rcp(x) : 9.99999993e+36f;
}

float3 NormalizeSafe(float3 v) {
  float len2 = dot(v, v);
  if (len2 <= 0.f) return 0.f.xxx;
  float inv_len = rsqrt(len2);
  return isinf(inv_len) ? 0.f.xxx : v * inv_len;
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
    float4 v7 : TEXCOORD2,
    float4 v8 : TEXCOORD3,
    float3 v9 : TEXCOORD4,
    float4 v10 : TEXCOORD5,
    float4 v11 : TEXCOORD6,
    float4 v12 : TEXCOORD7,
    out float4 o0 : SV_TARGET0) {
  float3 to_camera = cb4[20].xyz - v6.xyz;
  float inv_dist = DXBCRcp(rsqrt(abs(dot(to_camera, to_camera))));

  float fade = (inv_dist - cb4[146].x) * DXBCRcp(cb4[147].x - cb4[146].x);
  fade = saturate(fade);

  float4 tmp = float4(v6.xyz - cb4[20].xyz, -cb4[20].w);
  float inv_len = rsqrt(abs(dot(tmp, tmp)));
  float3 view_dir = inv_len * tmp.xxy;
  float3 normal = NormalizeSafe(v9);

  float ndotv = dot(normal, view_dir);
  float focus = PowLog(ndotv, cb4[148].x);
  focus = mad(cb4[149].x, focus - 1.f, 1.f);

  float focus_sat = saturate(focus);
  float inv_focus_sat = 1.f - focus_sat;
  float focus_mix = mad(cb4[150].x, inv_focus_sat - focus, focus);

  float4 proj = 0.f.xxxx;
  proj.y = v5.x;
  proj.z = v5.y;
  proj.w = 1.f;

  float2 uv0;
  uv0.x = dot(proj.yzww, cb4[136]);
  uv0.y = dot(proj.yzww, cb4[137]);
  float4 s0 = BitNorm(t0.Sample(s0_s, uv0), cb3[44], cb3[45]);

  float2 uv1;
  uv1.x = dot(proj.yzww, cb4[139]);
  uv1.y = dot(proj.yzww, cb4[140]);
  float4 s1 = BitNorm(t1.Sample(s1_s, uv1), cb3[46], cb3[47]);

  float mix0 = mad(max(cb4[142].x, 0.f), s1.w - s0.w, s0.w);
  float avg = dot(s1.xyz, 0.33f.xxx);
  float mix1 = mad(max(cb4[143].x, 0.f), avg - mix0, mix0);

  float bloom = max(mix1, 0.f) * max(cb4[151].x, 0.f);
  bloom *= max(focus_mix, 0.f);

  float vtx = mad(max(cb4[152].x, 0.f), v2.w - 1.f, 1.f);
  bloom *= vtx;
  bloom *= max(fade, 0.f);

  float gate0 = 1.f - mix1;
  float gate1 = saturate(mix1 - cb4[145].x);
  float gate2 = saturate(gate0 - (1.f - cb4[144].x));
  bloom *= min(gate1, gate2);

  float out_y = max(cb4[151].x, 0.f) * max(cb4[153].x, 0.f) * max(focus_mix, 0.f);
  float4 out_color = max(bloom.xxxx * out_y.xxxx, 0.f.xxxx);
  out_color = 1.f.xxxx - exp2(-out_color);

  uint alpha_test = (uint)mad(out_color.w, 255.f, 0.0001f);
  if (alpha_test < cb3[8].z) {
    discard;
  }

  o0 = out_color;
}
