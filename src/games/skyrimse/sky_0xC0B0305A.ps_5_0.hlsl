Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[1];
}

cbuffer cb12 : register(b12)
{
  float4 cb12[20];
}

cbuffer cb13 : register(b13)
{
  float peak_white_nits;
  float diffuse_white_nits;
}

#define cmp -

float InverseLerp1(float a, float b, float v) {
  return saturate((v - a) / (b - a));
}

float3 Saturate1(float3 color, float amount) {
  float lum = dot(color, float3(0.2125, 0.7154, 0.0721));
  return lerp(lum.xxx, color, amount);
}

bool IsSunTexture() {
  float w, h;
  t0.GetDimensions(w, h);

  if (w != 512.f || h != 512.f) return false;

  float4 center = t0.SampleLevel(s0_s, float2(0.5f, 0.5f), 0);
  if (center.a < 0.9f) return false;

  float4 corner = t0.SampleLevel(s0_s, float2(0.02f, 0.02f), 0);
  if (corner.a > 0.05f) return false;

  float4 corner2 = t0.SampleLevel(s0_s, float2(0.98f, 0.98f), 0);
  if (corner2.a > 0.05f) return false;

  float4 edge = t0.SampleLevel(s0_s, float2(0.1f, 0.5f), 0);
  if (edge.a > 0.05f) return false;

  return true;
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float4 v2 : COLOR0,
  float4 v3 : POSITION1,
  float4 v4 : POSITION2,
  out float4 o0 : SV_Target0,
  out float2 o1 : SV_Target1,
  out float4 o2 : SV_Target2)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  o0.w = v2.w * r0.w;
  o0.xyz = (v2.xyz * r0.xyz + cb2[0].yyy);

  if (IsSunTexture()) {
    // ---- SIZE LOCK ---------------------------------------------------------
    // Distance-based mask. Boost is gated to a fixed radius regardless of
    // brightness, so the visible disk does not grow as we lift values.
    float dist = distance(float2(0.5, 0.5), v1.xy);
    float coreSize = 0.015;   // hard cutoff radius
    float coreSoft = 0.008;   // softening edge so it doesn't look like a hard disk

    float spatialMask = 1.0 - InverseLerp1(coreSize, coreSize + coreSoft, dist);
    spatialMask = pow(spatialMask, 5);

    // Skip all the work for pixels outside the disk.
    if (spatialMask > 0.0) {
      float pw = (peak_white_nits > 1.0) ? peak_white_nits : 1000.0;
      float dw = (diffuse_white_nits > 1.0) ? diffuse_white_nits : 203.0;
      float hdrScale = pw / dw;

      // Start from the already-modulated color.
      float3 lifted = o0.xyz;

      // ---- LUMINANCE-WEIGHTED LIFT (from the reference chunk) -------------
      // Dim edges stay calm, brighter texels get lifted toward HDR peak.
      float lum = dot(lifted, float3(0.2125f, 0.7154f, 0.0721f));
      float w = smoothstep(0.08f, 0.45f, lum);
      // Lift target scaled into HDR range.
      float3 liftTarget = lifted * hdrScale;
      lifted = lerp(lifted, liftTarget, w);

      // ---- CORE PUNCH on the brightest pixels only ------------------------
      // Temporally stable: only hits pixels that are already bright.
      float liftedLum = dot(lifted, float3(0.2125f, 0.7154f, 0.0721f));
      float corePunch = smoothstep(1.5f, 4.0f, liftedLum);
      lifted *= lerp(1.0f, 5.0f, corePunch);

      lifted = max(lifted, 0.0);
      lifted = min(lifted, hdrScale * 4.0); // clamp relative to HDR headroom

      // ---- APPLY through the fixed-radius spatial mask --------------------
      // This is what guarantees the sun doesn't grow with brightness.
      o0.xyz = lerp(o0.xyz, lifted, spatialMask);
    }
  }

  r0.x = dot(cb12[12].xyzw, v3.xyzw);
  r0.y = dot(cb12[13].xyzw, v3.xyzw);
  r0.z = dot(cb12[15].xyzw, v3.xyzw);
  r0.xy = r0.xy / r0.zz;
  r1.x = dot(cb12[16].xyzw, v4.xyzw);
  r1.y = dot(cb12[17].xyzw, v4.xyzw);
  r0.z = dot(cb12[19].xyzw, v4.xyzw);
  r0.zw = r1.xy / r0.zz;
  r0.xy = r0.xy + -r0.zw;
  o1.xy = float2(-0.5,0.5) * r0.xy;
  o2.xyzw = float4(0.5,0.5,0,0);
  return;
}