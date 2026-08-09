#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[128];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = cb0[125].xxxx * float4(-0.5,-0.5,0.5,-0.5) + v1.xyxy;
  r1.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  if(injectedData.countOld == injectedData.countNew){
    r1.xyz = InvertToneMapScale(r1.xyz, injectedData.gammaSpace != 0.f);
    r0.xyz = InvertToneMapScale(r0.xyz, injectedData.gammaSpace != 0.f);
  } else if(injectedData.gammaSpace != 0.f){
    r1.xyz = renodx::color::srgb::DecodeSafe(r1.xyz);
    r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  }
  if(injectedData.isClamped != 0.f){
    r1.xyz = rolloffSdr(r1.xyz);
    r0.xyz = rolloffSdr(r0.xyz);
  }
  if(injectedData.gammaSpace != 0.f){
    r1.xyz = renodx::color::srgb::EncodeSafe(r1.xyz);
    r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  }
  r0.xyz = r1.xyz + r0.xyz;
  r1.xyzw = cb0[125].xxxx * float4(-0.5,0.5,0.5,0.5) + v1.xyxy;
  r2.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  if(injectedData.countOld == injectedData.countNew){
    r2.xyz = InvertToneMapScale(r2.xyz, injectedData.gammaSpace != 0.f);
    r1.xyz = InvertToneMapScale(r1.xyz, injectedData.gammaSpace != 0.f);
  } else if(injectedData.gammaSpace != 0.f){
    r2.xyz = renodx::color::srgb::DecodeSafe(r2.xyz);
    r1.xyz = renodx::color::srgb::DecodeSafe(r1.xyz);
  }
  if(injectedData.isClamped != 0.f){
    r2.xyz = rolloffSdr(r2.xyz);
    r1.xyz = rolloffSdr(r1.xyz);
  }
  if(injectedData.gammaSpace != 0.f){
    r2.xyz = renodx::color::srgb::EncodeSafe(r2.xyz);
    r1.xyz = renodx::color::srgb::EncodeSafe(r1.xyz);
  }
  r0.xyz = r2.xyz + r0.xyz;
  r0.xyz = r0.xyz + r1.xyz;
  r1.xy = -cb0[125].xx + v1.xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r2.xyzw = cb0[125].xxxx * float4(0,-1,1,-1) + v1.xyxy;
  r3.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
  r2.xyzw = t0.Sample(s0_s, r2.zw).xyzw;
  if(injectedData.countOld == injectedData.countNew){
    r1.xyz = InvertToneMapScale(r1.xyz, injectedData.gammaSpace != 0.f);
    r3.xyz = InvertToneMapScale(r3.xyz, injectedData.gammaSpace != 0.f);
    r2.xyz = InvertToneMapScale(r2.xyz, injectedData.gammaSpace != 0.f);
  } else if(injectedData.gammaSpace != 0.f){
    r1.xyz = renodx::color::srgb::DecodeSafe(r1.xyz);
    r3.xyz = renodx::color::srgb::DecodeSafe(r3.xyz);
    r2.xyz = renodx::color::srgb::DecodeSafe(r2.xyz);
  }
  if(injectedData.isClamped != 0.f){
    r1.xyz = rolloffSdr(r1.xyz);
    r3.xyz = rolloffSdr(r3.xyz);
    r2.xyz = rolloffSdr(r2.xyz);
  }
  if(injectedData.gammaSpace != 0.f){
    r1.xyz = renodx::color::srgb::EncodeSafe(r1.xyz);
    r3.xyz = renodx::color::srgb::EncodeSafe(r3.xyz);
    r2.xyz = renodx::color::srgb::EncodeSafe(r2.xyz);
  }
  r2.xyz = r3.xyz + r2.xyz;
  r1.xyz = r3.xyz + r1.xyz;
  r3.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  if(injectedData.countOld == injectedData.countNew){
    r3.xyz = InvertToneMapScale(r3.xyz, injectedData.gammaSpace != 0.f);
  } else if(injectedData.gammaSpace != 0.f){
    r3.xyz = renodx::color::srgb::DecodeSafe(r3.xyz);
  }
  if(injectedData.isClamped != 0.f){
    r3.xyz = rolloffSdr(r3.xyz);
  }
  if(injectedData.gammaSpace != 0.f){
    r3.xyz = renodx::color::srgb::EncodeSafe(r3.xyz);
  }
  r1.xyz = r3.xyz + r1.xyz;
  r4.xyzw = cb0[125].xxxx * float4(-1,0,-1,1) + v1.xyxy;
  r5.xyzw = t0.Sample(s0_s, r4.xy).xyzw;
  r4.xyzw = t0.Sample(s0_s, r4.zw).xyzw;
  if(injectedData.countOld == injectedData.countNew){
    r5.xyz = InvertToneMapScale(r5.xyz, injectedData.gammaSpace != 0.f);
    r4.xyz = InvertToneMapScale(r4.xyz, injectedData.gammaSpace != 0.f);
  } else if(injectedData.gammaSpace != 0.f){
    r5.xyz = renodx::color::srgb::DecodeSafe(r5.xyz);
    r4.xyz = renodx::color::srgb::DecodeSafe(r4.xyz);
  }
  if(injectedData.isClamped != 0.f){
    r5.xyz = rolloffSdr(r5.xyz);
    r4.xyz = rolloffSdr(r4.xyz);
  }
  if(injectedData.gammaSpace != 0.f){
    r5.xyz = renodx::color::srgb::EncodeSafe(r5.xyz);
    r4.xyz = renodx::color::srgb::EncodeSafe(r4.xyz);
  }
  r1.xyz = r5.xyz + r1.xyz;
  r5.xyz = r5.xyz + r3.xyz;
  r1.xyz = float3(0.03125,0.03125,0.03125) * r1.xyz;
  r0.xyz = r0.xyz * float3(0.125,0.125,0.125) + r1.xyz;
  r1.xyzw = cb0[125].xxxx * float4(1,0,0,1) + v1.xyxy;
  r6.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  if(injectedData.countOld == injectedData.countNew){
    r6.xyz = InvertToneMapScale(r6.xyz, injectedData.gammaSpace != 0.f);
    r1.xyz = InvertToneMapScale(r1.xyz, injectedData.gammaSpace != 0.f);
  } else if(injectedData.gammaSpace != 0.f){
    r6.xyz = renodx::color::srgb::DecodeSafe(r6.xyz);
    r1.xyz = renodx::color::srgb::DecodeSafe(r1.xyz);
  }
  if(injectedData.isClamped != 0.f){
    r6.xyz = rolloffSdr(r6.xyz);
    r1.xyz = rolloffSdr(r1.xyz);
  }
  if(injectedData.gammaSpace != 0.f){
    r6.xyz = renodx::color::srgb::EncodeSafe(r6.xyz);
    r1.xyz = renodx::color::srgb::EncodeSafe(r1.xyz);
  }
  r2.xyz = r6.xyz + r2.xyz;
  r6.xyz = r6.xyz + r3.xyz;
  r2.xyz = r2.xyz + r3.xyz;
  r0.xyz = r2.xyz * float3(0.03125,0.03125,0.03125) + r0.xyz;
  r2.xyz = r5.xyz + r1.xyz;
  r2.xyz = r2.xyz + r4.xyz;
  r0.xyz = r2.xyz * float3(0.03125,0.03125,0.03125) + r0.xyz;
  r2.xy = cb0[125].xx + v1.xy;
  r2.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
  if(injectedData.countOld == injectedData.countNew){
    r2.xyz = InvertToneMapScale(r2.xyz, injectedData.gammaSpace != 0.f);
  } else if(injectedData.gammaSpace != 0.f){
    r2.xyz = renodx::color::srgb::DecodeSafe(r2.xyz);
  }
  if(injectedData.isClamped != 0.f){
    r2.xyz = rolloffSdr(r2.xyz);
  }
  if(injectedData.gammaSpace != 0.f){
    r2.xyz = renodx::color::srgb::EncodeSafe(r2.xyz);
  }
  r2.xyz = r6.xyz + r2.xyz;
  r1.xyz = r2.xyz + r1.xyz;
  r0.xyz = r1.xyz * float3(0.03125,0.03125,0.03125) + r0.xyz;
  r0.xyz = min(cb0[127].yyy, r0.xyz);
  r0.w = max(r0.x, r0.y);
  r0.w = max(r0.w, r0.z);
  r1.x = -cb0[127].z + r0.w;
  r0.w = max(0.0001, r0.w);
  r1.y = cb0[127].w + r1.x;
  r1.y = max(0, r1.y);
  r1.z = cb0[127].w + cb0[127].w;
  r1.y = min(r1.y, r1.z);
  r1.y = r1.y * r1.y;
  r1.z = cb0[127].w * 4.0 + 0.0001;
  r1.y = r1.y / r1.z;
  r1.x = max(r1.x, r1.y);
  r0.w = r1.x / r0.w;
  r0.xyz = r0.xyz * r0.www;
  o0.xyz = sqrt(r0.xyz);
  o0.w = 1;
  return;
}