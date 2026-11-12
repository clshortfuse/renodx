// Shared body for the SPECULAR DLF passes (0xBA41374D X / 0x87EDDD47 Y).
// Identified by Remedy's deferredlight_filtering_specular.obj and
// t8 = g_tPosition_TexcoordY, the reflection trace's per-ray hit positions.
// Behaviour-matched against the original pass's disassembly.
// TEMPORAL_WEIGHT scales the final-iteration history blend:
//   0.6 = vanilla, 0.0 = spatial only (blend compiled out).

#ifndef TEMPORAL_WEIGHT
#define TEMPORAL_WEIGHT 0.0
#endif

cbuffer sys_constants : register(b0) {
  float2 g_vInvScreenRes : packoffset(c0.z);
  float4x4 g_mClipToView : packoffset(c14);
  float4 g_vPrevViewToViewCol3 : packoffset(c37);  // .z = camera fwd depth delta
};

cbuffer deferredlight_filtering : register(b1) {
  uint g_DLF_iFilterPass : packoffset(c1.z);
  uint g_DLF_iFilterPassCount : packoffset(c1.w);
  uint g_uCameraCut : packoffset(c2.x);
};

SamplerState linear_clamp : register(s6, space1);
Texture2D<float4> gbuffer1 : register(t0);
Texture2D<float4> gbuffer2 : register(t1);
Texture2D<float4> linear_depth : register(t2);
Texture2D<float4> prev_linear_depth : register(t3);
Texture2D<float4> clip_depth : register(t4);
Texture2D<float4> velocity_tex : register(t5);
Texture2D<float3> source : register(t6);
Texture2D<float3> history_tex : register(t7);
Texture2DArray<float4> position_tex : register(t8);
RWTexture2D<float3> target : register(u0);

float3 DecodeNormal(float4 g) {
  uint pw = (uint)(g.w * 255.0 + 0.5) & 254u;
  int3 v = (int3)floor(float3(g.x * 255.0 + 0.5, g.y * 255.0 + 0.5, (float)pw + 0.5));
  int e1 = (v.z >> 1) & 0x7;
  int e2 = (v.z >> 4) & 0xF;
  float fx = (float)((v.x << 3) | e1) * 0.000977 - 1.0;
  float fy = (float)((v.y << 4) | e2) * 0.000488 - 1.0;
  float2 p13 = float2(fx, fy) * 1.3;
  float d = dot(p13, p13);
  return float3(fx * 2.6, fy * 2.6, d - 1.0) / (d + 1.0);
}

uint MatId(int2 p) {
  float2 zw = gbuffer2[p].zw;
  return ((uint)(zw.x * 255.0) << 8) | (uint)(zw.y * 255.0);
}

[numthreads(8, 8, 1)]
void main(uint3 id: SV_DispatchThreadID) {
  int2 p = int2(id.xy);
  int step_size = (int)(1u << (g_DLF_iFilterPass >> 1));
#ifdef AXIS_X
  int2 dir = int2(1, 0);
#else
  int2 dir = int2(0, 1);
#endif
  int2 q0 = p - dir * step_size * 2;
  int2 q1 = p - dir * step_size;
  int2 q2 = p + dir * step_size;
  int2 q3 = p + dir * step_size * 2;

  float3 cc = source[p];
  float zc = linear_depth[p].x;
  float4 zn = float4(linear_depth[q0].x, linear_depth[q1].x,
                     linear_depth[q2].x, linear_depth[q3].x);

  float4 g1c = gbuffer1[p];
  float3 nc = DecodeNormal(g1c);
  float4 ndot = float4(dot(nc, DecodeNormal(gbuffer1[q0])),
                       dot(nc, DecodeNormal(gbuffer1[q1])),
                       dot(nc, DecodeNormal(gbuffer1[q2])),
                       dot(nc, DecodeNormal(gbuffer1[q3])));
  // GBuffer1.z similarity weight (per-material channel)
  float4 gz = float4(gbuffer1[q0].z, gbuffer1[q1].z, gbuffer1[q2].z, gbuffer1[q3].z);

  uint mc = MatId(p);
  float4 wm = float4(mc == MatId(q0), mc == MatId(q1), mc == MatId(q2), mc == MatId(q3));

  // relative depth weight: 1 - |dz| * 100/z
  float4 wz = max(saturate(1.0 - abs(zc - zn) * (100.0 / zc)), 0.001);
  // normal weight: factor 10 (softer than diffuse's 35)
  float4 wn = max(max(1.0 - 10.0 * saturate(0.5 - 0.5 * ndot), 0.0), 0.001);
  float4 wg = max(max(1.0 - 15.0 * abs(g1c.z - gz), 0.0), 0.001);
  float4 w = wz * wn * wg * wm * float4(0.0625, 0.25, 0.25, 0.0625);

  // per-pass falloff scaled by GBuffer1.z
  float pass1 = (float)(g_DLF_iFilterPass + 1u);
  float f = saturate(1.0 - g1c.z * 0.26 * pass1);
  w *= f * f;

  // position-mismatch falloff: reconstructed view pos vs stored GI position
  float2 uv = ((float2)p + 0.5) * g_vInvScreenRes;
  float2 ndc = float2(uv.x * 2.0 - 1.0, 1.0 - uv.y * 2.0);
  float4 vpos = mul(g_mClipToView, float4(ndc, clip_depth[p].x, 1.0));
  float3 pos_diff = vpos.xyz / vpos.w - position_tex.Load(int4(p, 0, 0)).xyz;
  w *= saturate(length(pos_diff) * 3.0 / (pass1 * pass1));

  float3 c0 = source[q0];
  float3 c1 = source[q1];
  float3 c2 = source[q2];
  float3 c3 = source[q3];

  float3 result = (c0 * w.x + c1 * w.y + c2 * w.z + c3 * w.w + cc * 0.375)
                / (w.x + w.y + w.z + w.w + 0.375);


#ifndef SPATIAL_SCALE
#define SPATIAL_SCALE 1.0
#endif
  // Spatial strength: 1 = vanilla kernel, 0 = passthrough (no spatial).
  result = lerp(cc, result, (float)SPATIAL_SCALE);

  // Final-iteration temporal history blend (vanilla: weight 0.6).
  static const float kTemporalWeight = TEMPORAL_WEIGHT;
  if (kTemporalWeight > 0.0 && g_DLF_iFilterPass + 1u == g_DLF_iFilterPassCount) {
    float2 pix = (float2)p + 0.5;
    float conf = (1.0 - (float)g_uCameraCut) * kTemporalWeight;
    float2 prev_uv = pix * g_vInvScreenRes + velocity_tex.SampleLevel(linear_clamp, uv, 0).xy;
    float cur_z = linear_depth.SampleLevel(linear_clamp, uv, 0).x;
    float prev_z = prev_linear_depth.SampleLevel(linear_clamp, prev_uv, 0).x
                 + g_vPrevViewToViewCol3.z;
    conf *= (abs(prev_z - cur_z) / abs(cur_z) <= 0.04) ? 1.0 : 0.0;
    conf *= max(1.0 - 40.0 * length(uv - prev_uv), 0.0);
    float3 hist = history_tex.SampleLevel(linear_clamp, prev_uv, 0);
    result = lerp(result, hist, conf);
  }

  if (any(isnan(result))) result = 0.0;
  target[p] = result;
}
