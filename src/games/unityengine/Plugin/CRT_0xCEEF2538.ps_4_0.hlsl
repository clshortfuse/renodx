#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[133];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = -0.633 * cb0[129].x;
  r0.y = 0;
  r0.xy = v1.xy + r0.xy;
  r1.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  if(injectedData.countOld < injectedData.countNew){
  r1.xyz = InvertToneMapScale(r1.xyz, injectedData.gammaSpace != 0.f);
  r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r1.xyz) : r1.xyz;
  }
  r2.w = 0;
  r2.yz = float2(25,0.633) * cb0[129].yx;
  r3.xy = v1.xy + r2.zw;
  r0.y = v1.y / r2.y;
  r2.xyzw = t0.Sample(s0_s, r3.xy).xyzw;
  if(injectedData.countOld < injectedData.countNew){
  r2.xyz = InvertToneMapScale(r2.xyz, injectedData.gammaSpace != 0.f);
  r2.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r2.xyz) : r2.xyz;
  }
  r0.z = v1.y;
  r4.xz = float2(0.5,-0.5) * cb0[129].xx;
  r4.yw = float2(0,0);
  r5.xyzw = r4.xyzw + r0.xzxz;
  r6.xyzw = t0.Sample(s0_s, r5.xy).xyzw;
  r5.xyzw = t0.Sample(s0_s, r5.zw).xyzw;
  if(injectedData.countOld < injectedData.countNew){
  r6.xyz = InvertToneMapScale(r6.xyz, injectedData.gammaSpace != 0.f);
  r5.xyz = InvertToneMapScale(r5.xyz, injectedData.gammaSpace != 0.f);
  r6.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r6.xyz) : r6.xyz;
  r5.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r5.xyz) : r5.xyz;
  }
  r1.z = r5.z;
  r1.x = r6.x;
  r3.z = v1.y;
  r3.xyzw = r4.xyzw + r3.xzxz;
  r5.xyzw = t0.Sample(s0_s, r3.xy).xyzw;
  r3.xyzw = t0.Sample(s0_s, r3.zw).xyzw;
  if(injectedData.countOld < injectedData.countNew){
  r5.xyz = InvertToneMapScale(r5.xyz, injectedData.gammaSpace != 0.f);
  r3.xyz = InvertToneMapScale(r3.xyz, injectedData.gammaSpace != 0.f);
  r5.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r5.xyz) : r5.xyz;
  r3.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r3.xyz) : r3.xyz;
  }
  r2.z = r3.z;
  r2.x = r5.x;
  r0.xzw = max(r2.xyz, r1.xyz);
  r1.xz = float2(0,0);
  r1.yw = float2(0.633,-0.633) * cb0[129].yy;
  r1.xyzw = v1.xyxy + r1.xyzw;
  r2.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r3.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  if(injectedData.countOld < injectedData.countNew){
  r2.xyz = InvertToneMapScale(r2.xyz, injectedData.gammaSpace != 0.f);
  r3.xyz = InvertToneMapScale(r3.xyz, injectedData.gammaSpace != 0.f);
  r2.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r2.xyz) : r2.xyz;
  r3.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r3.xyz) : r3.xyz;
  }
  r5.xyzw = r1.xyxy + r4.xyzw;
  r1.xyzw = r1.zwzw + r4.xyzw;
  r4.xyzw = v1.xyxy + r4.xyzw;
  r6.xyzw = t0.Sample(s0_s, r5.xy).xyzw;
  r5.xyzw = t0.Sample(s0_s, r5.zw).xyzw;
  if(injectedData.countOld < injectedData.countNew){
  r6.xyz = InvertToneMapScale(r6.xyz, injectedData.gammaSpace != 0.f);
  r5.xyz = InvertToneMapScale(r5.xyz, injectedData.gammaSpace != 0.f);
  r6.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r6.xyz) : r6.xyz;
  r5.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r5.xyz) : r5.xyz;
  }
  r2.z = r5.z;
  r2.x = r6.x;
  r5.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  if(injectedData.countOld < injectedData.countNew){
  r5.xyz = InvertToneMapScale(r5.xyz, injectedData.gammaSpace != 0.f);
  r1.xyz = InvertToneMapScale(r1.xyz, injectedData.gammaSpace != 0.f);
  r5.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r5.xyz) : r5.xyz;
  r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r1.xyz) : r1.xyz;
  }
  r3.z = r1.z;
  r3.x = r5.x;
  r1.xyz = max(r3.xyz, r2.xyz);
  r0.xzw = max(r1.xyz, r0.xzw);
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r2.xyzw = t0.Sample(s0_s, r4.xy).xyzw;
  r3.xyzw = t0.Sample(s0_s, r4.zw).xyzw;
  if(injectedData.countOld < injectedData.countNew){
  r1.xyz = InvertToneMapScale(r1.xyz, injectedData.gammaSpace != 0.f);
  r2.xyz = InvertToneMapScale(r2.xyz, injectedData.gammaSpace != 0.f);
  r3.xyz = InvertToneMapScale(r3.xyz, injectedData.gammaSpace != 0.f);
  r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r1.xyz) : r1.xyz;
  r2.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r2.xyz) : r2.xyz;
  r3.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r3.xyz) : r3.xyz;
  }
  r1.z = r3.z;
  r1.x = r2.x;
  r0.xzw = max(r1.xyz, r0.xzw);
  r1.xyz = float3(0.579,0.579,0.579) * r1.xyz;
  r0.xzw = r0.xzw * float3(0.421,0.421,0.421) + r1.xyz;
  r1.x = frac(cb0[8].x);
  r1.yz = sin(w1.xy);
  r2.xy = r1.yz * w1.xy + r1.xx;
  r1.x = r1.y * r1.z + r1.x;
  r1.x = 89.419998 * r1.x;
  r1.x = cos(r1.x);
  r1.x = 343.420013 * r1.x;
  r1.z = frac(r1.x);
  r2.xy = float2(89.419998,89.419998) * r2.xy;
  r2.xy = cos(r2.xy);
  r2.xy = float2(343.420013,343.420013) * r2.xy;
  r1.xy = frac(r2.xy);
  r1.xyz = r1.xyz * r0.xzw;
  if(injectedData.toneMapType == 0.f){
    r1.xyz = saturate(r1.xyz);
  }
  r0.xzw = float3(0.945200,0.945200,0.945200) * r0.xzw;
  r0.xzw = r1.xyz * float3(0.054800,0.054800,0.054800) + r0.xzw;
  r1.x = (1.0 / 3.0) * w1.x;
  r1.x = floor(r1.x);
  r1.x = -r1.x * 3 + w1.x;
  r1.x = floor(r1.x);
  r1.x = (int)r1.x;
  r1.xyz = -cb0[r1.x+130].xyz + r0.xzw;
  r0.xzw = float3(0.91,0.91,0.91) * r0.xzw;
  r0.xzw = r1.xyz * float3(0.09,0.09,0.09) + r0.xzw;
  r1.w = cb0[129].y * 0.25 + r0.y;
  r1.w = cb0[8].x * 3 + r1.w;
  r1.w = sin(r1.w);
  r0.x = saturate(r1.w * 0.001 + r0.x);
  r1.w = cb0[8].x * 3 + r0.y;
  r0.y = -0.25 + r0.y;
  r0.y = cb0[8].x * 3 + r0.y;
  r0.y = sin(r0.y);
  r0.y = saturate(r0.y * 0.001 + r0.w);
  r0.w = sin(r1.w);
  r0.z = saturate(r0.w * 0.001 + r0.z);
  r2.xyzw = cb0[126].xyzw * r0.zzzz;
  r2.xyzw = cb0[125].xyzw * r0.xxxx + r2.xyzw;
  r0.xyzw = cb0[127].xyzw * r0.yyyy + r2.xyzw;
  r0.xyzw = cb0[128].xyzw + r0.xyzw;
  r1.xyz = r1.xyz * r0.xyz;
  r0.xyz = r0.xyz * r0.www;
  r0.xyz = float3(0.93,0.93,0.93) * r0.xyz;
  r0.xyz = r1.xyz * float3(0.07,0.07,0.07) + r0.xyz;
  r1.x = r0.w * 0.93 + 0.07;
  o0.w = r0.w;
  o0.xyz = r0.xyz / r1.xxx;
  if(injectedData.countOld <= injectedData.countNew){
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
    o0.xyz = PostToneMapScale(o0.xyz, injectedData.gammaSpace != 0.f);
  }
  return;
}