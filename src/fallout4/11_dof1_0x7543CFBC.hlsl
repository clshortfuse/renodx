Texture2D<float4> t0 : register(t0);  // previous pass

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
  r1.xyzw = r0.xyzw;
  r2.xy = v1.xy;
  r2.zw = float2(1, 0);
  while (true) {
    r3.x = cmp((int)r2.w >= 6);
    if (r3.x != 0) break;
    r2.xy = cb2[1].yz + r2.xy;
    r3.x = (int)r2.w;
    r3.x = saturate(-r3.x + abs(r0.w));
    r3.y = r3.x * r0.w;
    r4.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
    r3.y = r4.w * r3.y;
    r3.y = cmp(0 < r3.y);
    r3.x = r3.y ? r3.x : 0;
    r2.z = r3.x + r2.z;
    r1.xyzw = r4.xyzw * r3.xxxx + r1.xyzw;
    r2.w = (int)r2.w + 1;
  }
  r3.xyzw = r1.xyzw;
  r2.xy = v1.xy;
  r2.w = r2.z;
  r4.x = 0;
  while (true) {
    r4.y = cmp((int)r4.x >= 6);
    if (r4.y != 0) break;
    r2.xy = -cb2[1].yz + r2.xy;
    r4.y = (int)r4.x;
    r4.y = saturate(-r4.y + abs(r0.w));
    r4.z = r4.y * r0.w;
    r5.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
    r4.z = r5.w * r4.z;
    r4.z = cmp(0 < r4.z);
    r4.y = r4.z ? r4.y : 0;
    r2.w = r4.y + r2.w;
    r3.xyzw = r5.xyzw * r4.yyyy + r3.xyzw;
    r4.x = (int)r4.x + 1;
  }
  r1.xyzw = r3.xyzw / r2.wwww;
  r2.xyzw = r0.xyzw;
  r3.xy = v1.xy;
  r3.zw = float2(1, 0);
  while (true) {
    r4.x = cmp((int)r3.w >= 6);
    if (r4.x != 0) break;
    r3.xy = cb2[1].yz * float2(1, -1) + r3.xy;
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
  r3.x = 0;
  while (true) {
    r3.y = cmp((int)r3.x >= 6);
    if (r3.y != 0) break;
    r0.xy = -cb2[1].yz * float2(1, -1) + r0.xy;
    r3.y = (int)r3.x;
    r3.y = saturate(-r3.y + abs(r0.w));
    r3.w = r3.y * r0.w;
    r5.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
    r3.w = r5.w * r3.w;
    r3.w = cmp(0 < r3.w);
    r3.y = r3.w ? r3.y : 0;
    r0.z = r3.y + r0.z;
    r4.xyzw = r5.xyzw * r3.yyyy + r4.xyzw;
    r3.x = (int)r3.x + 1;
  }
  r0.xyzw = r4.xyzw / r0.zzzz;
  o0.xyzw = min(r1.xyzw, r0.xyzw);
  return;
}
