Texture2DMS<float4,8> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb2 : register(b2){
  float4 cb2[3];
}
cbuffer cb1 : register(b1){
  float4 cb1[27];
}
cbuffer cb0 : register(b0){
  float4 cb0[19];
}

#define cmp -

void main(
  float4 v0 : SV_Position0,
  float v1 : SV_ClipDistance0,
  linear centroid float4 v2 : TEXCOORD0,
  float4 v3 : TEXCOORD1,
  float4 v4 : TEXCOORD2,
  float4 v5 : TEXCOORD3,
  float3 v6 : TEXCOORD4,
  uint v7 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  t2.GetDimensions(uiDest.x, uiDest.y, uiDest.z);
  r0.xy = uiDest.xy;
  r0.xy = (uint2)r0.xy;
  r0.zw = v5.xy / v5.zz;
  r0.xy = r0.zw * r0.xy;
  r0.xy = (int2)r0.xy;
  r0.zw = float2(0,0);
  r1.x = t2.Load(r0.xy, 0).x;
  r1.x = cb1[26].y * r1.x + cb1[26].x;
  r1.x = 1 / r1.x;
  r1.x = max(0, r1.x);
  r1.y = t2.Load(r0.xy, 1).x;
  r1.y = cb1[26].y * r1.y + cb1[26].x;
  r1.y = 1 / r1.y;
  r1.x = max(r1.x, r1.y);
  r1.y = t2.Load(r0.xy, 2).x;
  r1.y = cb1[26].y * r1.y + cb1[26].x;
  r1.y = 1 / r1.y;
  r1.x = max(r1.x, r1.y);
  r1.y = t2.Load(r0.xy, 3).x;
  r1.y = cb1[26].y * r1.y + cb1[26].x;
  r1.y = 1 / r1.y;
  r1.x = max(r1.x, r1.y);
  r1.y = t2.Load(r0.xy, 4).x;
  r1.y = cb1[26].y * r1.y + cb1[26].x;
  r1.y = 1 / r1.y;
  r1.x = max(r1.x, r1.y);
  r1.y = t2.Load(r0.xy, 5).x;
  r1.y = cb1[26].y * r1.y + cb1[26].x;
  r1.y = 1 / r1.y;
  r1.x = max(r1.x, r1.y);
  r1.y = t2.Load(r0.xy, 6).x;
  r0.x = t2.Load(r0.xy, 7).x;
  r0.x = cb1[26].y * r0.x + cb1[26].x;
  r0.x = 1 / r0.x;
  r0.y = cb1[26].y * r1.y + cb1[26].x;
  r0.y = 1 / r0.y;
  r0.y = max(r1.x, r0.y);
  r0.x = max(r0.y, r0.x);
  r0.x = -v6.z + r0.x;
  r0.y = cmp(r0.x < 0);
  if (r0.y != 0) discard;
  r0.y = -cb0[16].x + r0.x;
  r0.x = saturate(cb0[13].w * r0.x);
  r0.y = saturate(cb0[16].y * r0.y);
  r0.y = 1 + -r0.y;
  r0.x = r0.x * r0.y;
  r0.y = t0.Sample(s0_s, v6.xy).x;
  r0.y = r0.y * r0.y;
  r0.y = min(v3.w, r0.y);
  r0.y = v2.w * r0.y;
  r0.z = v5.w * v4.w;
  r0.y = r0.y * r0.z;
  o0.z = saturate(cb0[9].x * r0.z);
  r0.x = r0.y * r0.x;
  r0.x = saturate(cb0[18].w * r0.x);
  r0.y = -cb0[0].x + r0.x;
  o0.w = saturate(r0.x);
  r0.x = cmp(r0.y < 0);
  if (r0.x != 0) discard;
  r0.xy = cb2[2].yy * cb0[8].xy;
  r0.xy = v6.xy * cb0[8].zw + r0.xy;
  r0.xy = t1.Sample(s1_s, r0.xy).xy;
  o0.y = saturate(cb0[13].x * r0.y);
  o0.x = saturate(r0.x);
  return;
}