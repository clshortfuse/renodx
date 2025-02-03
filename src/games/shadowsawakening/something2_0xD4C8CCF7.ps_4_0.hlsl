Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0) {
  float4 cb0[7];
}

#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: TEXCOORD0,
    float4 v2: TEXCOORD1,
    float v3: TEXCOORD2,
    out float4 o0: SV_Target0,
    out float4 o1: SV_Target1) {
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s1_s, v2.xy).xyzw;
  r0.x = -0.00999999978 + r0.x;
  r0.x = cmp(r0.x < 0);
  if (r0.x != 0) discard;
  r0.xyzw = t1.Sample(s0_s, v2.xy).xyzw;
  r0.x = -0.899999976 + r0.w;
  r0.x = cmp(r0.x < 0);
  if (r0.x != 0) discard;
  r0.xy = v2.xy * cb0[2].xy + cb0[2].zw;
  r0.xyzw = t2.Sample(s2_s, r0.xy).xyzw;
  r0.x = -cb0[3].x + r0.x;
  r0.x = cmp(r0.x < 0);
  if (r0.x != 0) discard;
  r0.x = 1 + v1.z;
  r0.xy = v1.xy / r0.xx;
  o0.xy = r0.xy * float2(0.281262308, 0.281262308) + float2(0.5, 0.5);
  r0.xy = float2(1, 255) * v1.ww;
  r0.xy = frac(r0.xy);
  o0.z = -r0.y * 0.00392156886 + r0.x;
  o0.w = r0.y;
  r0.x = cmp(0 < v3.x);
  r0.y = cmp(v3.x < 0);
  r0.x = (int)-r0.x + (int)r0.y;
  r0.x = (int)r0.x;
  r0.x = saturate(1 + r0.x);
  r0.y = cb0[6].x * r0.x;
  o1.y = cb0[3].w * r0.x;
  r0.x = -1 + v3.x;
  r0.x = cb0[5].w * r0.x + 1;
  o1.w = r0.x * r0.y;
  o1.x = dot(cb0[3].zy, float2(0.100000001, 0.899999976));
  o1.z = 1 + -cb0[4].x;
  o1.a = saturate(o1.a);
  return;
}
