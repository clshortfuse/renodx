#include "./common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[6];
}
cbuffer cb0 : register(b0){
  float4 cb0[36];
}

void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = float4(0.0078125,0.013888889,0.00390625,0.0069444445) * cb1[5].yyyy;
  r1.xy = float2(1,1) / r0.xy;
  r1.xy = v0.xy * r1.xy;
  r1.xy = floor(r1.xy);
  r1.zw = r1.xy * r0.xy;
  r0.xy = r1.xy * r0.xy + r0.zw;
  r0.z = t1.Sample(s1_s, r1.zw).x;
  r1.xyzw = cb1[5].yyyy * float4(0.00390625,-0.0069444445,-0.00390625,0.0069444445) + r0.xyxy;
  r0.w = t1.Sample(s1_s, r1.xy).x;
  r1.x = t1.Sample(s1_s, r1.zw).x;
  r0.z = r0.z + r0.w;
  r0.z = r0.z + r1.x;
  r1.xy = cb1[5].yy * float2(0.00390625,0.0069444445) + r0.xy;
  r0.w = t1.Sample(s1_s, r1.xy).x;
  r0.z = r0.z + r0.w;
  r0.w = t1.Sample(s1_s, r0.xy).x;
  r0.xy = -v0.xy + r0.xy;
  r0.z = r0.z + r0.w;
  r1.z = step(0.10, r0.z);
  r1.xy = r1.zz * r0.xy + v0.xy;
  r2.xy = v0.xy;
  r2.z = 0;
  r0.xyz = (cb1[5].y > 0) ? r1.xyz : r2.xyz;
  r1.xy = r0.yx / cb0[35].wz;
  r1.xy = float2(0.25,0.5) * r1.xy;
  r1.xy = frac(r1.xy);
  r0.w = r1.y + r1.y;
  r1.x = 0.20 * r1.x;
  r0.w = floor(r0.w);
  r0.w = r0.w * 0.20 + 0.80;
  r0.w = r1.x * r0.w + 0.80;
  r0.z = 1 + -r0.z;
  r0.xy = r0.xy * float2(2,2) + float2(-1,-1);
  r1.x = saturate(cb1[4].z);
  r1.y = r0.x * r0.x + r1.x;
  r1.y = r0.y * r0.y + r1.y;
  r1.y = min(1.99, r1.y);
  r1.z = cb0[35].z * r1.y;
  r1.w = r1.z * r0.z;
  r2.xz = float2(2,4) * r1.zw;
  r1.zw = float2(2,1.95) + -r1.yy;
  r2.y = r1.z;
  r3.yz = float2(8.81664467,1.10) * r1.zw;
  r1.z = -r1.w * 1.10 + 1;
  r1.w = 1 / r3.y;
  r1.w = (r2.y > 0.01) ? r1.w : 0;
  r1.w = -1 + r1.w;
  r1.y = r1.y * r1.w;
  r1.w = r1.x * r1.x;
  r1.x = 1 + -r1.x;
  r1.x = r1.x * r1.x;
  r1.x = r1.x * r1.x;
  r1.x = r1.x * r1.x;
  r1.x = r1.x * r1.x;
  r1.x = r1.x * r1.z + r3.z;
  r1.y = r1.y * r1.w + 1;
  r0.xy = r1.yy * r0.xy;
  r1.yz = r0.xy * float2(0.5,0.5) + float2(0.5,0.5);
  r0.xy = -abs(r0.xy) * abs(r0.xy) + float2(1,1);
  r0.x = saturate(r0.x * r0.y);
  r0.x = r0.x * 0.72 + 0.40;
  r2.yw = float2(0,0);
  r2.zw = r2.zw + r1.yz;
  r0.yz = -r2.xy * r0.zz + r1.yz;
  r1.z = t2.Sample(s2_s, r1.yz).y;
  r1.y = t2.Sample(s2_s, r0.yz).x;
  r1.w = t2.Sample(s2_s, r2.zw).z;
  r1.gba = InvertToneMapScale(r1.gba);
  r0.yz = v0.xy * float2(5,5) + cb1[2].xy;
  r0.y = t0.Sample(s0_s, r0.yz).x;
  r0.y = r0.y * 0.10 + 0.95;
  r2.xyz = r1.yzw * r0.yyy;
  r0.z = dot(r2.xyz, float3(0.3,0.1,0.59));
  r1.yzw = -r1.yzw * r0.yyy + r0.zzz;
  r3.xyzw = saturate(cb1[0].wxyz);
  r1.yzw = r3.xxx * r1.yzw + r2.xyz;
  r1.yzw = r1.yzw * r3.yzw;
  r0.yzw = r1.yzw * r0.www;
  r0.xyz = r0.yzw * r0.xxx;
  r0.xyz = r0.xyz * r1.xxx;
  o0.w = 1;
  if (injectedData.toneMapType == 0.f) {
    r0.rgb = saturate(r0.rgb);
  } else {
    float y_max = injectedData.toneMapPeakNits / injectedData.toneMapGameNits;
    if (injectedData.toneMapGammaCorrection != 0.f) {
      y_max = renodx::color::correct::Gamma(y_max, true, injectedData.toneMapGammaCorrection == 1.f ? 2.2f : 2.4f);
    }
    float y = renodx::color::y::from::BT709(abs(r0.rgb));
    if (y > y_max) {
      r0.rgb = renodx::tonemap::ExponentialRollOff(r0.rgb, 1.f, max(1.005f, y_max));
    }
  }
  o0.rgb = PostToneMapScale(r0.rgb);
  return;
}