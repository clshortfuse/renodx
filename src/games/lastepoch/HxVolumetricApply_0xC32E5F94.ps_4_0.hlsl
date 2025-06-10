#include "./common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy / v1.ww;
  r0.z = dot(r0.xy, float2(12.9898005,78.2330017));
  r1.xyzw = t0.Sample(s1_s, r0.xy).xyzw;
  r0.x = sin(r0.z);
  r0.x = 43758.5469 * r0.x;
  r0.x = frac(r0.x);
  r0.x = r0.x * 0.00065359479 + -0.000326797395;
  r0.xyzw = r1.xyzw + r0.xxxx;
  r1.x = 1 + -r0.w;
  r1.yz = v2.xy / v2.ww;
  r2.xyzw = t1.Sample(s0_s, r1.yz).xyzw;
  r0.w = 0;
  if (injectedData.stateCheck) {
  r2.rgb = InvertToneMapScale(r2.rgb);
  r0.xyzw = r2.xyzw * r1.xxxx + r0.xyzw;
  r0.rgb = PostToneMapScale(r0.rgb);
  } else {
    r0.xyzw = r2.xyzw * r1.xxxx + r0.xyzw;
  }
  o0.xyzw = r0.xyzw;
  return;
}