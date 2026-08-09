#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[6];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = -cb0[3].x;
  r0.yw = float2(0,0);
  r0.xy = v1.xy + r0.xy;
  r1.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  if(injectedData.countOld == injectedData.countNew){
    r1.xyz = InvertToneMapScale(r1.xyz, injectedData.gammaSpace != 0.f);
    r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r1.xyz) : r1.xyz;
  }
  r2.xyzw = cb0[3].xyxy * float4(1,-1,-1,1) + v1.xyxy;
  r3.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
  r2.xyzw = t0.Sample(s0_s, r2.zw).xyzw;
  if(injectedData.countOld == injectedData.countNew){
    r3.xyz = InvertToneMapScale(r3.xyz, injectedData.gammaSpace != 0.f);
    r3.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r3.xyz) : r3.xyz;
    r2.xyz = InvertToneMapScale(r2.xyz, injectedData.gammaSpace != 0.f);
    r2.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r2.xyz) : r2.xyz;
  }
  r4.xyw = -cb0[3].xyy;
  r0.xy = v1.xy + r4.xy;
  r5.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r4.z = 0;
  r0.xy = v1.xy + r4.zw;
  r4.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  if(injectedData.countOld == injectedData.countNew){
    r5.xyz = InvertToneMapScale(r5.xyz, injectedData.gammaSpace != 0.f);
    r5.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r5.xyz) : r5.xyz;
    r4.xyz = InvertToneMapScale(r4.xyz, injectedData.gammaSpace != 0.f);
    r4.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r4.xyz) : r4.xyz;
  }
  r6.xyz = cb0[4].xxy * cb0[4].xyy;
  r4.xyz = r6.yyy * r4.xyz;
  r4.xyz = r5.xyz * r6.xxx + r4.xyz;
  r3.xyz = r3.xyz * r6.xxx + r4.xyz;
  r1.xyz = r1.xyz * r6.yyy + r3.xyz;
  r3.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  if(injectedData.countOld == injectedData.countNew){
    r3.xyz = InvertToneMapScale(r3.xyz, injectedData.gammaSpace != 0.f);
    r3.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r3.xyz) : r3.xyz;
  }
  r1.xyz = r3.xyz * r6.zzz + r1.xyz;
  r0.z = cb0[3].x;
  r0.xy = v1.xy + r0.zw;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  if(injectedData.countOld == injectedData.countNew){
    r0.xyz = InvertToneMapScale(r0.xyz, injectedData.gammaSpace != 0.f);
    r0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r0.xyz) : r0.xyz;
  }
  r0.xyz = r0.xyz * r6.yyy + r1.xyz;
  r0.xyz = r2.xyz * r6.xxx + r0.xyz;
  r1.x = 0;
  r1.y = cb0[3].y;
  r1.xy = v1.xy + r1.xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  if(injectedData.countOld == injectedData.countNew){
    r1.xyz = InvertToneMapScale(r1.xyz, injectedData.gammaSpace != 0.f);
    r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r1.xyz) : r1.xyz;
  }
  r0.xyz = r1.xyz * r6.yyy + r0.xyz;
  r1.xy = cb0[3].xy + v1.xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  if(injectedData.countOld == injectedData.countNew){
    r1.xyz = InvertToneMapScale(r1.xyz, injectedData.gammaSpace != 0.f);
    r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r1.xyz) : r1.xyz;
  }
  r0.xyz = r1.xyz * r6.xxx + r0.xyz;
  o0.xyz = r0.xyz / cb0[5].xxx;
  o0.w = 1;
  return;
}