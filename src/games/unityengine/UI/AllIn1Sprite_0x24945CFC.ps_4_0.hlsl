#include "../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[1];
}
cbuffer cb0 : register(b0){
  float4 cb0[10];
}

void main(
  float2 v0 : TEXCOORD0,
  float2 w0 : TEXCOORD1,
  float4 v1 : SV_POSITION0,
  float4 v2 : COLOR0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = asint(cb0[7].w);
  r0.xy = cb0[3].xy * r0.xx;
  r0.z = 0;
  r1.xyzw = v0.xyxy + r0.xzzy;
  r0.xyzw = v0.xyxy + -r0.xzzy;
  r2.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  r3.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  r0.x = r3.w + r2.w;
  r0.x = r0.x + r1.w;
  r0.x = saturate(r0.x + r0.w);
  r0.x = step(0.05, r0.x);
  r1.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r0.y = -r1.w * v2.w + 1;
  r1.xyzw = v2.xyzw * r1.xyzw;
  r0.y = cb0[7].x * r0.y;
  r0.x = r0.x * r0.y;
  r0.yz = cb1[0].xx * cb0[9].xy;
  r2.xy = r0.yz >= -r0.yz ? float2(1,1) : float2(-1,-1);
  r0.yz = r2.xy * r0.yz;
  r0.yz = frac(r0.yz);
  r0.yz = r2.xy * r0.yz + w0.xy;
  r2.xyzw = t1.Sample(s1_s, r0.yz).xyzw;
  r2.xyzw = cb0[6].xyzw * r2.xyzw;
  r0.xyzw = r2.xyzw * r0.xxxx;
  r2.x = cb0[7].y + cb0[7].y;
  r0.xyz = r2.xxx * r0.xyz;
  r1.xyz = r1.xyz * r1.www;
  r0.xyzw = r1.xyzw + r0.xyzw;
  r0.w = cb0[5].x * r0.w;
  o0.xyzw = cb0[4].xyzw * r0.xyzw;
  o0.w = saturate(o0.w);
  if (injectedData.countOld == injectedData.countNew) {
    if(injectedData.rolloffUI == 1.f){
      o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
      o0.xyz = rolloff(o0.xyz, 0.85f, true);
      o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(o0.xyz) : o0.xyz;
    } else if(injectedData.rolloffUI == 2.f){
      o0.xyz = saturate(o0.xyz);
    }
  }
  return;
}