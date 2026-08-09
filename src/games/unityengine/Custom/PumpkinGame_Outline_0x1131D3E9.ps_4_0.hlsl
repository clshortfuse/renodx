Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[134];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.SampleBias(s0_s, v1.xy, cb0[5].x).xyzw;
  r0.x = cmp(asint(cb0[129].y) >= 1);
  if (r0.x != 0) {
    r0.x = 0;
    r0.y = cb0[127].y;
    r1.xy = v1.xy + r0.xy;
    r1.xyzw = t1.SampleBias(s1_s, r1.xy, cb0[5].x).xyzw;
    r0.xy = v1.xy + -r0.xy;
    r2.xyzw = t1.SampleBias(s1_s, r0.xy, cb0[5].x).xyzw;
    r0.x = cb0[131].x * r2.w;
    r0.x = r1.w * cb0[131].x + r0.x;
    r0.y = 2;
  } else {
    r0.xy = float2(0,1.40129846e-45);
  }
  r0.z = cmp(asint(cb0[129].y) >= (int)r0.y);
  if (r0.z != 0) {
    r1.x = 0;
    r1.y = cb0[127].y;
    r1.zw = float2(2,2) * r1.xy + v1.xy;
    r2.xyzw = t1.SampleBias(s1_s, r1.zw, cb0[5].x).xyzw;
    r1.z = r2.w * cb0[132].x + r0.x;
    r1.xy = float2(-2,-2) * r1.xy + v1.xy;
    r2.xyzw = t1.SampleBias(s1_s, r1.xy, cb0[5].x).xyzw;
    r0.x = r2.w * cb0[132].x + r1.z;
    r0.y = 3;
  }
  r0.y = cmp(asint(cb0[129].y) >= (int)r0.y);
  r0.y = r0.y ? r0.z : 0;
  if (r0.y != 0) {
    r1.x = 0;
    r1.y = cb0[127].y;
    r0.yz = float2(3,3) * r1.xy + v1.xy;
    r2.xyzw = t1.SampleBias(s1_s, r0.yz, cb0[5].x).xyzw;
    r0.y = r2.w * cb0[133].x + r0.x;
    r1.xy = float2(-3,-3) * r1.xy + v1.xy;
    r1.xyzw = t1.SampleBias(s1_s, r1.xy, cb0[5].x).xyzw;
    r0.x = r1.w * cb0[133].x + r0.y;
  }
  r1.xyzw = t1.SampleBias(s1_s, v1.xy, cb0[5].x).xyzw;
  r0.x = r1.w * cb0[130].x + r0.x;
  r0.x = r0.x + -r0.w;
  r0.xyzw = cb0[128].xyzw * r0.xxxx;
  r0.xyzw = cb0[129].xxxx * r0.xyzw;
  o0.xyzw = r0.xyzw + r0.xyzw;
  o0.w = saturate(o0.w);
  return;
}