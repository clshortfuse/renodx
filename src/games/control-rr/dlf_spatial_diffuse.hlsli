// Shared body for the DIFFUSE DLF passes (0x9018E4F2 X / 0x2A6F7863 Y).
// Identified by Remedy's deferredlight_filtering_diffuse.obj and t7 = g_tHitInfo,
// written by the diffuse-GI pass (rt_deferred_diffusegi's g_rwtHitInfo UAV).
// Behaviour-matched against the original pass's disassembly.
// TEMPORAL_WEIGHT scales the final-iteration history blend:
//   0.7 = vanilla, 0.0 = spatial only (blend compiled out).

#ifndef TEMPORAL_WEIGHT
#define TEMPORAL_WEIGHT 0.0
#endif

cbuffer sys_constants : register(b0) {
  float2 g_vInvOutputRes : packoffset(c1.z);
  float4 g_vPrevViewToViewCol3 : packoffset(c37);  // .z = camera fwd depth delta
};

cbuffer deferredlight_filtering : register(b1) {
  uint g_DLF_iFilterPass : packoffset(c1.x);
  uint g_DLF_iFilterPassCount : packoffset(c1.y);
  uint g_uCameraCut : packoffset(c1.z);
};

SamplerState linear_clamp : register(s6, space1);
Texture2D<float4> gbuffer1 : register(t0);
Texture2D<float4> gbuffer2 : register(t1);
Texture2D<float4> linear_depth : register(t2);
Texture2D<float4> prev_linear_depth : register(t3);
Texture2D<float4> velocity_tex : register(t4);
Texture2D<float3> source : register(t5);
Texture2D<float3> history_tex : register(t6);
Texture2D<float> hit_info : register(t7);
RWTexture2D<float3> target : register(u0);

float3 DecodeNormal(float4 g) {
  // Stereographic unpack, matching the game's encoding (11/12-bit fields).
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

  float zc = linear_depth[p].x;
  float4 zn = float4(linear_depth[q0].x, linear_depth[q1].x,
                     linear_depth[q2].x, linear_depth[q3].x);

  float3 nc = DecodeNormal(gbuffer1[p]);
  float4 ndot = float4(dot(nc, DecodeNormal(gbuffer1[q0])),
                       dot(nc, DecodeNormal(gbuffer1[q1])),
                       dot(nc, DecodeNormal(gbuffer1[q2])),
                       dot(nc, DecodeNormal(gbuffer1[q3])));

  uint mc = MatId(p);
  float4 wm = float4(mc == MatId(q0), mc == MatId(q1), mc == MatId(q2), mc == MatId(q3));

  // depth weight: 1 - 10*|dz|
  float4 wz = max(max(1.0 - 10.0 * abs(zc - zn), 0.0), 0.001);
  // normal weight: 1 - 35*saturate(0.5 - 0.5*dot)
  float4 wn = max(max(1.0 - 35.0 * saturate(0.5 - 0.5 * ndot), 0.0), 0.001);
  float4 w = wz * wn * wm * float4(0.0625, 0.25, 0.25, 0.0625);

  // hit-distance-scaled kernel footprint
  float hit = hit_info[p];
  float t = hit / (1.0 + 0.8 * (float)g_DLF_iFilterPass);
  w *= min(1.6 * pow(max(t, 0.0), 0.7) + 0.1, 1.0);

  float3 cc = source[p];
  float3 c0 = source[q0];
  float3 c1 = source[q1];
  float3 c2 = source[q2];
  float3 c3 = source[q3];

  // local contrast adaptation (variance of weighted luma diffs)
  const float3 kLuma = float3(0.3333, 0.3333, 0.3333);
  float lc = dot(cc, kLuma);
  float4 ln = float4(dot(c0, kLuma), dot(c1, kLuma), dot(c2, kLuma), dot(c3, kLuma));
  float lsum = lc + ln.x + ln.y + ln.z + ln.w;
  float inv_mean = (lsum != 0.0) ? 1.0 / (lsum * 0.2) : 0.0;
  float4 nd = w * abs(lc - ln) * inv_mean;
  float mean_nd = 0.25 * (nd.x + nd.y + nd.z + nd.w);
  float variance = 0.25 * dot(nd, nd) - mean_nd * mean_nd;
  w *= min(10.0 * sqrt(abs(variance)), 1.0);

  float3 result = (c0 * w.x + c1 * w.y + c2 * w.z + c3 * w.w + cc * 0.375)
                / (w.x + w.y + w.z + w.w + 0.375);


#ifndef SPATIAL_SCALE
#define SPATIAL_SCALE 1.0
#endif
  // Spatial strength: 1 = vanilla kernel, 0 = passthrough (no spatial).
  result = lerp(cc, result, (float)SPATIAL_SCALE);

  // Final-iteration temporal history blend (vanilla: weight 0.7).
  static const float kTemporalWeight = TEMPORAL_WEIGHT;
  if (kTemporalWeight > 0.0 && g_DLF_iFilterPass + 1u == g_DLF_iFilterPassCount) {
    float2 pix = (float2)p + 0.5;
    float2 uv = pix * g_vInvOutputRes;
    float conf = (1.0 - (float)g_uCameraCut) * kTemporalWeight;
    float2 prev_uv = pix * g_vInvOutputRes + velocity_tex.SampleLevel(linear_clamp, uv, 0).xy;
    float cur_z = linear_depth.SampleLevel(linear_clamp, uv, 0).x;
    float prev_z = prev_linear_depth.SampleLevel(linear_clamp, prev_uv, 0).x
                 + g_vPrevViewToViewCol3.z;
    conf *= (abs(prev_z - cur_z) / abs(cur_z) <= 0.03) ? 1.0 : 0.0;
    conf *= max(1.0 - 40.0 * length(uv - prev_uv), 0.0);
    float3 hist = history_tex.SampleLevel(linear_clamp, prev_uv, 0);
    result = lerp(result, hist, conf);
  }

  if (any(isnan(result))) result = 0.0;
  target[p] = result;
}
