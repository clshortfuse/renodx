Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[1];
}
cbuffer cb0 : register(b0){
  float4 cb0[17];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  float2 w2 : TEXCOORD3,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.x = cmp(cb0[15].x >= v1.y);
  if (r1.x == 0) {
    r1.y = cmp(0 >= r0.w);
    if (r1.y != 0) discard;
    o0.xyzw = r0.xyzw;
    return;
  }
  if (r1.x != 0) {
    r1.x = 2.44444394 * cb0[11].y;
    r1.y = 30 * cb1[0].x;
    r1.y = v1.x * 3 + r1.y;
    r1.y = sin(r1.y);
    r1.x = r1.y * r1.x;
    r1.x = cb0[10].w * r1.x;
    r1.y = cb0[11].x * cb0[6].x;
    r1.xy = float2(0.00499999989,10) * r1.xy;
    r1.z = -cb0[6].x + v1.y;
    r1.z = r1.z / -cb0[6].x;
    r1.y = r1.z * r1.y;
    r1.z = 1 + -v1.y;
    r1.w = -cb0[15].x * 2 + 1;
    r1.z = r1.z + -r1.w;
    r1.w = v1.y / cb0[15].x;
    r2.xyzw = t1.Sample(s1_s, w1.xy).xyzw;
    r2.x = -0.5 + r2.x;
    r2.x = cb0[9].z * r2.x;
    r2.y = cb0[15].x + -v1.y;
    r1.z = r2.y * cb0[5].y + r1.z;
    r1.w = 1 + -r1.w;
    r3.x = r2.x * r1.w + v1.x;
    r3.y = r1.x * r1.y + r1.z;
    r1.xyzw = t0.Sample(s0_s, r3.xy).xyzw;
    r2.x = cmp(0 >= r1.w);
    if (r2.x != 0) discard;
    r2.x = cb0[5].z + -v1.y;
    r2.z = cb0[5].z + -cb0[5].w;
    r2.x = r2.x / r2.z;
    r2.x = min(1, r2.x);
    r3.xyzw = -cb0[8].xyzw + cb0[7].xyzw;
    r3.xyzw = r2.xxxx * r3.xyzw + cb0[8].xyzw;
    r1.xyz = -r3.xyz + r1.xyz;
    r1.xyz = r1.www * r1.xyz + r3.xyz;
    r4.w = cb0[15].w + r1.w;
    r1.w = 1 + -r3.w;
    r2.x = r2.y / cb0[5].x;
    r2.x = min(1, r2.x);
    r1.w = r1.w * r2.x + r3.w;
    r2.xyz = r3.xyz + -r1.xyz;
    r4.xyz = r1.www * r2.xyz + r1.xyz;
    r1.x = cb0[16].x * r0.w;
    r2.xyzw = -r4.xyzw + r0.xyzw;
    o0.xyzw = r1.xxxx * r2.xyzw + r4.xyzw;
  } else {
    r1.x = cmp(0 >= r0.w);
    if (r1.x != 0) discard;
    o0.xyzw = r0.xyzw;
  }
  o0.w = saturate(o0.w);
  return;
}