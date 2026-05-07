Texture2D<float4> t0 : register(t0);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t7 : register(t7);
Texture2D<float4> t12 : register(t12);

SamplerState s0_s : register(s0);
SamplerState s1_s : register(s1);
SamplerState s2_s : register(s2);
SamplerState s7_s : register(s7);
SamplerState s12_s : register(s12);

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
    noperspective float4 v0 : SV_POSITION0,
    float4 v1 : TEXCOORD8,
    float4 v2 : COLOR0,
    float4 v3 : COLOR1,
    float4 v4 : TEXCOORD9,
    float4 v5 : TEXCOORD0,
    float4 v6 : TEXCOORD1,
    float3 v7 : TEXCOORD2,
    float3 v8 : TEXCOORD3,
    float3 v9 : TEXCOORD4,
    float4 v10 : TEXCOORD5,
    float4 v11 : TEXCOORD6,
    float4 v12 : TEXCOORD7,
    out float4 o0 : SV_TARGET0,
    out float4 o1 : SV_TARGET1) {
  float2 screen_uv = (v0.xy - 0.5f.xx) * cb3[76].xy;

  if (any(v6.www < 0.f.xxx)) {
    discard;
  }

  float4 nrm_sample = BitNorm(t0.Sample(s0_s, v5.xy), cb3[44], cb3[45]);
  nrm_sample.x = nrm_sample.w * nrm_sample.x;
  nrm_sample.xy = (nrm_sample.xy - 0.5f.xx) * 2.f;

  float inv_z = DXBCRcp(rsqrt(abs(1.f - dot(nrm_sample.xy, -nrm_sample.xy))));
  float3 t = NormalizeSafe(v7);
  float3 b = NormalizeSafe(v8);
  float3 n = NormalizeSafe(v9);
  float3 normal = NormalizeSafe(nrm_sample.x * t + nrm_sample.y * b + inv_z * n);

  float3 view_dir = cb4[20].xyz - v6.xyz;

  float3 proj = float3(v5.xy, 0.f);
  proj.z = 1.f;
  proj += float3(0.f, 0.f, -2.f);

  float2 uv0;
  uv0.x = dot(proj, cb4[138].xyz);
  uv0.y = dot(proj, cb4[139].xyz);
  float4 s0 = BitNorm(t1.Sample(s1_s, uv0), cb3[46], cb3[47]);

  float2 uv1;
  uv1.x = dot(proj, cb4[141].xyz);
  uv1.y = dot(proj, cb4[142].xyz);
  float4 s1 = BitNorm(t1.Sample(s1_s, uv1), cb3[46], cb3[47]);

  float bloom_shape = s1.y + s0.y;
  float shaped = mad(bloom_shape, -2.f, 1.f);
  bloom_shape = mad(max(cb4[144].x, 0.f), shaped, bloom_shape);

  float4 mask = BitNorm(t2.Sample(s2_s, v5.xy), cb3[48], cb3[49]);
  bloom_shape *= max(mask.w, 0.f);

  float focus = dot(normal, cb4[23].xyz);
  focus = 1.f - PowLog(focus, cb4[145].x);
  bloom_shape *= max(focus, 0.f);
  bloom_shape *= max(cb4[137].x, 0.f);
  bloom_shape *= max(cb4[110].x, 0.f);

  float3 basis = cb4[136].xyz * v2.x;
  float3 sqn = normal * normal;
  float3 pos_mask = step(0.f.xxx, normal);
  float3 neg_mask = step(0.f.xxx, -normal);

  float4 hemi =
      pos_mask.x * (sqn.x * cb4[32]) +
      neg_mask.x * (sqn.x * cb4[33]) +
      pos_mask.y * (sqn.y * cb4[34]) +
      neg_mask.y * (sqn.y * cb4[35]) +
      pos_mask.z * (sqn.z * cb4[36]) +
      neg_mask.z * (sqn.z * cb4[37]);
  float3 hemi_rgb = hemi.www * hemi.xyz * basis;

  float2 proj_uv = mad(normal.xy, cb4[95].xx, v6.xy);
  proj_uv = mad(proj_uv, cb4[96].zz, 0.5f.xx);

  float dist2 = dot(view_dir, view_dir);
  float proj_lod = saturate((DXBCRcp(dist2) - cb4[97].x) * DXBCRcp(cb4[97].y));
  float4 proj_sample = BitNorm(t12.SampleLevel(s12_s, proj_uv, proj_lod), cb3[68], cb3[69]);
  float3 proj_rgb = proj_sample.xyz * cb4[96].x;

  float depth_fade = saturate(mad(abs(mad(proj_sample.w, cb4[95].w, cb4[95].y) - v6.z), -cb4[95].z, 1.f));
  proj_rgb *= depth_fade;

  float3 proj_mod = basis * proj_rgb;
  float proj_dot = saturate(dot(proj_mod, cb4[96].yyy));
  proj_rgb = saturate(mad(proj_dot, proj_rgb * basis - hemi_rgb, hemi_rgb));

  float3 aux = 0.f.xxx;
  float aux_alpha = 0.f;
  float aux_mix = 0.f;

  if (cb4[232].w != 0.f) {
    float2 noise_uv = mad((0.5f.xx + screen_uv) * cb4[108].xy, cb4[108].zw, 0.5f.xx);

    float4 sample_a = BitNorm(t7.Sample(s7_s, float2(noise_uv.x * 0.5f, noise_uv.y)), cb3[58], cb3[59]);
    float4 sample_b = BitNorm(t7.Sample(s7_s, float2(noise_uv.x * 0.5f + 0.5f, noise_uv.y)), cb3[58], cb3[59]);

    aux_alpha = sample_b.w;
    float zfade = saturate(mad(min(cb4[20].z, v6.z), cb4[98].z, cb4[98].w));
    float4 zshape = mad(bloom_shape.xxxx, cb4[98].yyyx, cb4[25].yzwx);
    zfade *= saturate(zshape.w);

    aux = mad(sample_a.xxx, -cb4[208].xyz, sample_a.yzw);
    aux_mix = zfade * saturate(sample_b.x + dot(zshape.xyz, sample_a.yzw));
  }

  float stage0 = saturate(mad(cb4[24].x, dist2, cb4[24].y));
  float stage1 = stage0 * cb4[208].w;
  float3 out_rgb = stage1 * cb4[208].xyz;

  if (cb4[232].w != 0.f) {
    out_rgb = mad(aux_mix.xxx, aux, out_rgb);
    stage0 = mad(stage0, cb4[208].w, aux_mix);
    stage1 = saturate(mad(aux_mix, -stage1, stage0));
  }

  float3 final_rgb = mad((1.f - stage1).xxx, proj_rgb, out_rgb);
  final_rgb += cb4[26].xyz;
  final_rgb = max(final_rgb, 0.f.xxx);
  final_rgb = 1.f.xxx - exp2(-final_rgb);

  float inv_v2w = DXBCRcp(v2.w);
  o1.xyz = inv_v2w * v2.zzz;
  o1.w = max(bloom_shape, 0.f);

  uint alpha_test = (uint)mad(max(bloom_shape, 0.f), 255.f, 0.0001f);
  if (alpha_test < cb3[8].z) {
    discard;
  }

  o0 = float4(final_rgb, max(bloom_shape, 0.f));
}
