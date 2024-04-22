
Texture2D<float4> t0 : register(t0);  // // previous pass

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2) {
  float4 cb2[2];
}

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : SV_POSITION0, float2 v1 : TEXCOORD0, out float4 o0 : SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.xz = cb2[1].xx;
  r1.yw = float2(0, 0);
  r2.xyzw = r0.xyzw;
  r3.xy = v1.xy;
  r3.zw = float2(1, 0);
  while (true) {
    r4.x = cmp((int)r3.w >= 6);
    if (r4.x != 0) break;
    r3.xy = r3.xy + r1.xy;
    r4.x = (int)r3.w;
    r4.x = saturate(-r4.x + abs(r0.w));
    r4.y = r4.x * r0.w;
    r5.xyzw = t0.Sample(s0_s, r3.xy).xyzw;
    r4.y = r5.w * r4.y;
    r4.y = cmp(0 < r4.y);
    r4.x = r4.y ? r4.x : 0;
    r3.z = r4.x + r3.z;
    r2.xyzw = r5.xyzw * r4.xxxx + r2.xyzw;
    r3.w = (int)r3.w + 1;
  }
  r4.xyzw = r2.xyzw;
  r0.xy = v1.xy;
  r0.z = r3.z;
  r1.x = 0;
  while (true) {
    r1.y = cmp((int)r1.x >= 6);
    if (r1.y != 0) break;
    r0.xy = r0.xy + -r1.zw;
    r1.y = (int)r1.x;
    r1.y = saturate(-r1.y + abs(r0.w));
    r3.x = r1.y * r0.w;
    r5.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
    r3.x = r5.w * r3.x;
    r3.x = cmp(0 < r3.x);
    r1.y = r3.x ? r1.y : 0;
    r0.z = r1.y + r0.z;
    r4.xyzw = r5.xyzw * r1.yyyy + r4.xyzw;
    r1.x = (int)r1.x + 1;
  }
  o0.xyzw = r4.xyzw / r0.zzzz;
  return;
}
