// ---- Created with 3Dmigoto v1.3.16 on Thu Apr 09 16:13:30 2026
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[23];
}

cbuffer cb12 : register(b12)
{
  float4 cb12[45];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cmp(0.5 < cb2[0].x);
  r0.yzw = float3(0,9999999,-9999999);
  r1.x = 0;
  while (true) {
    r1.y = cmp((int)r1.x >= 16);
    if (r1.y != 0) break;
    r1.yz = cb2[r1.x+7].xy * cb2[6].xy + v1.xy;
    if (r0.x != 0) {
      r2.xy = cb12[43].xy * r1.yz;
      r2.xy = max(float2(0,0), r2.xy);
      r3.x = min(cb12[44].z, r2.x);
      r3.y = min(cb12[43].y, r2.y);
      r1.w = t0.Sample(s0_s, r3.xy).x;
    } else {
      r1.w = t0.Sample(s0_s, r1.yz).x;
    }
    r0.yzw = r1.www * cb2[r1.x+7].zzz + r0.yyy;
    r1.x = (int)r1.x + 1;
  }
  r1.xy = t1.Sample(s1_s, v1.xy).xy;

  // Clamp accumulator to finite range before NaN/Inf check.
  // This prevents depth-filter swings on high-contrast particle edges
  // from producing Inf, which would flip between dilated and raw velocity
  // frame-to-frame and cause flicker on boosted fire.
  r0.yzw = clamp(r0.yzw, -1e6f, 1e6f);

  // NaN check — now only catches actual NaN, not Inf from big swings
  r2.xyz = cmp(r0.yzw != r0.yzw);
  r0.x = (int)r2.y | (int)r2.x;
  r0.x = (int)r2.z | (int)r0.x;

  r0.yz = -r1.xy + r0.yz;  // delta = new - old

  // Slow down adaptation speed to prevent fire from yanking exposure
  r1.zw = cb2[2].wz * r0.yz;

  // Sign of the delta
  r2.xy = cmp(float2(0, 0) < r1.zw);
  r2.zw = cmp(r1.zw < float2(0, 0));
  r2.xy = (int2)-r2.xy + (int2)r2.zw;
  r2.xy = (int2)r2.xy;

  // Original: 0.00390625 (1/256). We lower the floor so adaptation can be slower.
  float maxAdaptRate = 0.00001f;  // TUNE: lower = slower adaptation = less flicker
  r1.zw = max(float2(maxAdaptRate, maxAdaptRate), abs(r1.zw));

  // Also cap the maximum step so a single bright frame can't move exposure far
  float maxStep = 0.00002f;  // TUNE: lower = more stable, higher = more responsive
  r1.zw = min(float2(maxStep, maxStep), r1.zw);

  r0.yz = min(r1.zw, abs(r0.yz));
  r0.yz = r0.yz * r2.xy + r1.xy;
  o0.xy = r0.xx ? r1.xy : r0.yz;
  o0.z = r0.w;
  o0.w = cb2[6].z;
  return;
}