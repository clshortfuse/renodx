#include "./common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0) {
  float4 cb0[5];
}

#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: COLOR0,
    float2 v2: TEXCOORD0,
    float2 w2: TEXCOORD3,
    float4 v3: TEXCOORD1,
    float4 v4: TEXCOORD2,
    out float4 o0: SV_Target0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = v4.x + -w2.x;
  r0.x = r0.x / v4.z;
  r0.x = min(1, abs(r0.x));
  r0.x = 1 + -r0.x;
  r0.y = v4.y + v4.y;
  r0.y = 1 / r0.y;
  r0.x = saturate(r0.x * r0.y);
  r0.y = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.x = r0.y * r0.x;
  r0.x = 0.5 * r0.x;
  r1.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r1.xyzw = cb0[3].xyzw + r1.xyzw;
  r0.x = r1.w * r0.x;
  r1.xyzw = v1.xyzw * r1.xyzw;
  r0.x = v4.w * r0.x;
  r0.yzw = r1.xyz * float3(10, 10, 10) + float3(-1, -1, -1);
  r0.yzw = w2.yyy * r0.yzw + float3(1, 1, 1);
  r1.rgb = UIScale(r1.rgb);
  o0.xyz = r0.xxx * r0.yzw + r1.xyz;
  r0.xy = cmp(v3.xy >= cb0[4].xy);
  r0.zw = cmp(cb0[4].zw >= v3.xy);
  r0.xyzw = r0.xyzw ? float4(1, 1, 1, 1) : 0;
  r0.xy = r0.xy * r0.zw;
  r0.x = r0.x * r0.y;
  o0.w = saturate(r1.w * r0.x);
  return;
}
