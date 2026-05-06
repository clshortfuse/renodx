// Hand-decompiled from DXBC.
//
// Material shader for a shoe / leather surface with two render targets:
// - RT0: shaded material color
// - RT1: auxiliary payload carrying scaled v2.z and final alpha
//
// The shader:
// 1. Rejects pixels when v5.w is negative.
// 2. Builds a directional material tint from normalized v8 against cb4[32..37].
// 3. Scales that tint by vertex color v2.x and cb4[136].
// 4. Applies distance- and range-based modulation from cb4[20], cb4[25], cb4[97].
// 5. Samples t12 as a projected modulation texture and mixes toward cb4[24].
// 6. Samples t8 as an auxiliary lookup used to derive a soft alpha/fade term.

Texture2D<float4> t8 : register(t8);
Texture2D<float4> t12 : register(t12);

SamplerState s8_s : register(s8);
SamplerState s12_s : register(s12);

cbuffer cb4 : register(b4) {
  float4 cb4[236];
}

cbuffer cb3 : register(b3) {
  float4 cb3[77];
}

float4 BitNorm(float4 c, float4 mask, float4 set) {
  return asfloat((asuint(c) & asuint(mask)) | asuint(set));
}

float SafeLength(float3 v) {
  float d = dot(v, v);
  return (d > 0.f) ? sqrt(d) : 0.f;
}

float3 SafeNormalize(float3 v) {
  float d = dot(v, v);
  return (d > 0.f) ? v * rsqrt(d) : 0.f;
}

float SafeRcp(float x) {
  return (abs(x) > 0.f) ? rcp(x) : 0.f;
}

void main(
    noperspective float4 v0 : SV_POSITION0,
    float4 v1 : TEXCOORD8,
    linear centroid float4 v2 : COLOR0,
    linear centroid float4 v3 : COLOR1,
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
  if (any(v5.w < 0.f)) discard;

  float3 n = SafeNormalize(v8.xyz);
  float3 neg_mask = step(0.f, -n);
  float3 pos_mask = step(0.f, n);
  float3 n2 = n * n;

  float4 basis =
      neg_mask.x * (n2.x * cb4[33]) +
      pos_mask.x * (n2.x * cb4[32]) +
      pos_mask.y * (n2.y * cb4[34]) +
      neg_mask.y * (n2.y * cb4[35]) +
      pos_mask.z * (n2.z * cb4[36]) +
      neg_mask.z * (n2.z * cb4[37]);

  float3 basis_rgb = basis.www * basis.xyz;
  basis_rgb *= cb4[136].xyz * v2.x;

  float dist_anchor = SafeLength(cb4[20].xyz - v5.xyz);
  float range_mask = (dist_anchor - cb4[25].x) * cb4[25].y * cb4[25].z;

  float projected_depth = dist_anchor - cb4[97].x;
  float lod = projected_depth * SafeRcp(cb4[97].y);

  float2 projected_uv = mad(n.xy, cb4[95].x, v5.xy);
  projected_uv = projected_uv * cb4[96].xy + 0.5f;

  float4 proj = BitNorm(t12.SampleLevel(s12_s, projected_uv, lod), cb3[68], cb3[69]);
  float proj_scale = proj.a * cb4[95].w + cb4[95].y;
  float3 proj_rgb = proj.rgb * cb4[96].x;

  float fade = saturate(1.f - abs(proj_scale - v5.z) * cb4[95].z);
  proj_rgb *= fade;

  float3 mixed_basis = mad(proj_rgb, cb4[136].xyz * v2.x - basis_rgb, basis_rgb);
  float proj_dot = dot(proj_rgb * cb4[136].xyz * v2.x, cb4[96].y);
  float3 modulated = mad(proj_dot, cb4[24].xyz - mixed_basis, mixed_basis);
  o0.xyz = mad(range_mask, cb4[24].xyz - modulated, modulated);

  o1.xyz = SafeRcp(v2.w) * v2.z;

  float2 screen_uv = (v0.xy - 0.5f) * cb3[76].xy + 0.5f;
  float2 aux_uv = mad(screen_uv, cb4[108].xy, -0.5f);
  aux_uv = aux_uv * cb4[108].zw;
  float4 aux = BitNorm(t8.Sample(s8_s, aux_uv), cb3[60], cb3[61]);

  float depth_term = SafeRcp(aux.r + cb4[8].z) * cb4[8].w;
  float2 offset_uv = ((screen_uv * cb4[108].zw) * float2(2.f, -2.f) + cb4[9].xy) * cb4[8].xy;
  float2 scaled_offset = depth_term * offset_uv;

  float4 clip_vec = float4(scaled_offset, 1.f, 1.f);
  float3 projected =
      float3(
          dot(clip_vec, cb4[10]),
          dot(clip_vec, cb4[11]),
          dot(clip_vec, cb4[12]));

  float2 delta_xy = projected.xy - cb4[21].xy;
  float delta_z = v5.z - projected.z;
  float depth_fade = delta_z * cb4[139].x + cb4[140].x;

  float radial = 1.f - (cb4[137].x * dot(float3(delta_xy, projected.z - cb4[21].z), float3(delta_xy, projected.z - cb4[21].z)) + cb4[138].x);
  float final_alpha = radial * depth_fade * v3.w;

  o0.a = saturate(final_alpha);
  o1.a = saturate(final_alpha);
}
