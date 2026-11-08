Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[2];
}

cbuffer cb12 : register(b12)
{
  float4 cb12[45];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb2[1].xy + -v1.xy;
  r0.z = dot(r0.xy, r0.xy);
  r0.w = sqrt(r0.z);

  r1.x = -cb2[0].z + r0.w;
  r1.x = max(0, r1.x);
  r1.y = cmp(0 < r1.x);
  r1.x = cb2[0].y * r1.x + 1;
  r1.x = -1 / r1.x;
  r1.x = 1 + r1.x;
  r1.x = cb2[0].x * r1.x;
  r1.x = r1.y ? r1.x : 0;

  r0.w = -cb2[1].z + r0.w;
  r0.w = max(0, r0.w);
  r1.y = cmp(0 < r0.w);
  r0.w = cb2[0].w * r0.w + 1;
  r0.w = -1 / r0.w;
  r0.w = 1 + r0.w;
  r0.w = cb2[0].x * r0.w;
  r0.w = r1.y ? r0.w : 0;

  r0.z = rsqrt(r0.z);
  r0.xy = r0.xy * r0.zz;
  r0.z = r1.x + -r0.w;
  r0.z = max(0, r0.z);
  r0.xy = r0.xy * r0.zz;
  r0.xy = float2(0.100000001, 0.100000001) * r0.xy;

  // FIX: Ensure minimum blur step size.
  // When step is near-zero, all 21 samples hit the same texel
  // and HDR highlights pass through unblurred.
  float stepLen = length(r0.xy);
  float minStep = 0.0002;  // minimum step in UV space
  if (stepLen < minStep && stepLen > 0.00001) {
    r0.xy = r0.xy * (minStep / stepLen);
  } else if (stepLen <= 0.00001) {
    // Direction is degenerate (pixel at/near center) — use horizontal fallback
    r0.xy = float2(minStep, 0.0);
  }

  r1.xyzw = float4(0, 0, 0, 0);
  r0.z = -10;

  while (true) {
    r0.w = cmp(10 < r0.z);
    if (r0.w != 0) break;

    r2.xy = r0.xy * r0.zz + v1.xy;
    r2.xy = cb12[43].xy * r2.xy;
    r2.xy = max(float2(0, 0), r2.xy);
    r3.x = min(cb12[44].z, r2.x);
    r3.y = min(cb12[43].y, r2.y);

    r2.xyzw = t0.SampleLevel(s0_s, r3.xy, 0).xyzw;
    r1.xyzw = r2.xyzw + r1.xyzw;
    r0.z = 1 + r0.z;
  }

  o0.xyzw = float4(0.0476190485, 0.0476190485, 0.0476190485, 0.0476190485) * r1.xyzw;
  return;
}