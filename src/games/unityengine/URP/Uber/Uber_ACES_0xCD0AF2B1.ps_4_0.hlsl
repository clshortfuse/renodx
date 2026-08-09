#include "../../tonemap.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[149];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = -cb0[131].xy * float2(0.5,0.5) + cb0[28].xy;
  r0.xy = min(v1.xy, r0.xy);
  r0.xyzw = t0.SampleBias(s0_s, r0.xy, cb0[4].x).xyzw;
  r1.xy = -cb0[135].xy * float2(0.5,0.5) + cb0[28].xy;
  r1.xy = min(v1.xy, r1.xy);
  r1.xy = r1.xy * cb0[148].zw + float2(0.5,0.5);
  r1.zw = floor(r1.xy);
  r1.xy = frac(r1.xy);
  r2.xyzw = -r1.xyxy * float4(0.5,0.5,0.166666672,0.166666672) + float4(0.5,0.5,0.5,0.5);
  r2.xyzw = r1.xyxy * r2.xyzw + float4(0.5,0.5,-0.5,-0.5);
  r3.xy = r1.xy * float2(0.5,0.5) + float2(-1,-1);
  r3.zw = r1.xy * r1.xy;
  r3.xy = r3.zw * r3.xy + float2(0.666666687,0.666666687);
  r2.xyzw = r1.xyxy * r2.xyzw + float4(0.166666672,0.166666672,0.166666672,0.166666672);
  r1.xy = float2(1,1) + -r3.xy;
  r1.xy = r1.xy + -r2.xy;
  r1.xy = r1.xy + -r2.zw;
  r2.zw = r2.zw + r3.xy;
  r2.xy = r2.xy + r1.xy;
  r3.zw = float2(1,1) / r2.zw;
  r3.zw = r3.xy * r3.zw + float2(-1,-1);
  r4.xy = float2(1,1) / r2.xy;
  r3.xy = r1.xy * r4.xy + float2(1,1);
  r4.xyzw = r3.zwxw + r1.zwzw;
  r4.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r4.xyzw;
  r4.xyzw = cb0[148].xyxy * r4.xyzw;
  r4.xyzw = min(float4(1,1,1,1), r4.xyzw);
  r5.xyzw = t1.SampleLevel(s0_s, r4.xy, 0).xyzw;
  r4.xyzw = t1.SampleLevel(s0_s, r4.zw, 0).xyzw;
  r4.xyz = r4.xyz * r2.xxx;
  r4.xyz = r2.zzz * r5.xyz + r4.xyz;
  r1.xyzw = r3.zyxy + r1.zwzw;
  r1.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r1.xyzw;
  r1.xyzw = cb0[148].xyxy * r1.xyzw;
  r1.xyzw = min(float4(1,1,1,1), r1.xyzw);
  r3.xyzw = t1.SampleLevel(s0_s, r1.xy, 0).xyzw;
  r1.xyzw = t1.SampleLevel(s0_s, r1.zw, 0).xyzw;
  r1.xyz = r2.xxx * r1.xyz;
  r1.xyz = r2.zzz * r3.xyz + r1.xyz;
  r1.xyz = r2.yyy * r1.xyz;
  r1.xyz = r2.www * r4.xyz + r1.xyz;
  r1.xyz = cb0[138].xxx * r1.xyz * injectedData.fxBloom;
  r0.xyz = r1.xyz * cb0[138].yzw + r0.xyz;
  if (cb0[145].z > 0) {
    r1.xy = -cb0[145].xy + v1.xy;
    r1.yz = cb0[145].zz * abs(r1.xy) * min(1.f, injectedData.fxVignette);
    r1.x = cb0[144].w * r1.y;
    r0.w = dot(r1.xz, r1.xz);
    r0.w = 1 + -r0.w;
    r0.w = max(0, r0.w);
    r0.w = log2(r0.w);
    r0.w = cb0[145].w * r0.w * max(1.f, injectedData.fxVignette);
    r0.w = exp2(r0.w);
    r1.xyz = float3(1,1,1) + -cb0[144].xyz;
    r1.xyz = r0.www * r1.xyz + cb0[144].xyz;
    r0.xyz = r1.xyz * r0.xyz;
  }
  r0.xyz = cb0[136].www * r0.xyz;
  /*r1.y = dot(float3(0.439700991,0.382977992,0.177334994), r0.xyz);
  r1.z = dot(float3(0.0897922963,0.813422978,0.0967615992), r0.xyz);
  r1.w = dot(float3(0.0175439995,0.111543998,0.870703995), r0.xyz);
  r0.x = min(r1.y, r1.z);
  r0.x = min(r0.x, r1.w);
  r0.y = max(r1.y, r1.z);
  r0.y = max(r0.y, r1.w);
  r0.xyz = max(float3(9.99999975e-05,9.99999975e-05,0.00999999978), r0.xyy);
  r0.x = r0.y + -r0.x;
  r0.x = r0.x / r0.z;
  r0.yzw = r1.wzy + -r1.zyw;
  r0.yz = r1.wz * r0.yz;
  r0.y = r0.y + r0.z;
  r0.y = r1.y * r0.w + r0.y;
  r0.y = max(0, r0.y);
  r0.y = sqrt(r0.y);
  r0.z = r1.w + r1.z;
  r0.z = r0.z + r1.y;
  r0.y = r0.y * 1.75 + r0.z;
  r0.w = -0.400000006 + r0.x;
  r1.x = 2.5 * r0.w;
  r1.x = 1 + -abs(r1.x);
  r1.x = max(0, r1.x);
  r0.w = cmp(r0.w >= 0);
  r0.w = r0.w ? 1 : -1;
  r1.x = -r1.x * r1.x + 1;
  r0.w = r0.w * r1.x + 1;
  r0.zw = float2(0.333333343,0.0250000004) * r0.yw;
  r1.x = cmp(0.159999996 >= r0.y);
  r0.y = cmp(r0.y >= 0.479999989);
  r0.z = 0.0799999982 / r0.z;
  r0.z = -0.5 + r0.z;
  r0.z = r0.w * r0.z;
  r0.y = r0.y ? 0 : r0.z;
  r0.y = r1.x ? r0.w : r0.y;
  r0.y = 1 + r0.y;
  r2.yzw = r1.yzw * r0.yyy;
  r0.zw = cmp(r2.zw == r2.yz);
  r0.z = r0.w ? r0.z : 0;
  r0.w = r1.z * r0.y + -r2.w;
  r0.w = 1.73205078 * r0.w;
  r1.x = r2.y * 2 + -r2.z;
  r1.x = -r1.w * r0.y + r1.x;
  r1.z = min(abs(r1.x), abs(r0.w));
  r1.w = max(abs(r1.x), abs(r0.w));
  r1.w = 1 / r1.w;
  r1.z = r1.z * r1.w;
  r1.w = r1.z * r1.z;
  r3.x = r1.w * 0.0208350997 + -0.0851330012;
  r3.x = r1.w * r3.x + 0.180141002;
  r3.x = r1.w * r3.x + -0.330299497;
  r1.w = r1.w * r3.x + 0.999866009;
  r3.x = r1.z * r1.w;
  r3.y = cmp(abs(r1.x) < abs(r0.w));
  r3.x = r3.x * -2 + 1.57079637;
  r3.x = r3.y ? r3.x : 0;
  r1.z = r1.z * r1.w + r3.x;
  r1.w = cmp(r1.x < -r1.x);
  r1.w = r1.w ? -3.141593 : 0;
  r1.z = r1.z + r1.w;
  r1.w = min(r1.x, r0.w);
  r0.w = max(r1.x, r0.w);
  r1.x = cmp(r1.w < -r1.w);
  r0.w = cmp(r0.w >= -r0.w);
  r0.w = r0.w ? r1.x : 0;
  r0.w = r0.w ? -r1.z : r1.z;
  r0.w = 57.2957802 * r0.w;
  r0.z = r0.z ? 0 : r0.w;
  r0.w = cmp(r0.z < 0);
  r1.x = 360 + r0.z;
  r0.z = r0.w ? r1.x : r0.z;
  r0.w = cmp(r0.z < -180);
  r1.x = cmp(180 < r0.z);
  r1.zw = float2(360,-360) + r0.zz;
  r0.z = r1.x ? r1.w : r0.z;
  r0.z = r0.w ? r1.z : r0.z;
  r0.z = 0.0148148146 * r0.z;
  r0.z = 1 + -abs(r0.z);
  r0.z = max(0, r0.z);
  r0.w = r0.z * -2 + 3;
  r0.z = r0.z * r0.z;
  r0.z = r0.w * r0.z;
  r0.z = r0.z * r0.z;
  r0.x = r0.z * r0.x;
  r0.y = -r1.y * r0.y + 0.0299999993;
  r0.x = r0.x * r0.y;
  r2.x = r0.x * 0.180000007 + r2.y;
  r0.x = dot(float3(1.45143926,-0.236510754,-0.214928567), r2.xzw);
  r0.y = dot(float3(-0.0765537769,1.17622972,-0.0996759236), r2.xzw);
  r0.z = dot(float3(0.00831614807,-0.00603244966,0.997716308), r2.xzw);
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.w = dot(r0.xyz, float3(0.272228986,0.674081981,0.0536894985));
  r0.xyz = r0.xyz + -r0.www;
  r0.xyz = r0.xyz * float3(0.959999979,0.959999979,0.959999979) + r0.www;
  r1.xyz = float3(0.0245785993,0.0245785993,0.0245785993) + r0.xyz;
  r1.xyz = r0.xyz * r1.xyz + float3(-9.05370034e-05,-9.05370034e-05,-9.05370034e-05);
  r2.xyz = r0.xyz * float3(0.983729005,0.983729005,0.983729005) + float3(0.432951003,0.432951003,0.432951003);
  r0.xyz = r0.xyz * r2.xyz + float3(0.238080993,0.238080993,0.238080993);
  r0.xyz = r1.xyz / r0.xyz;
  r1.x = dot(float3(0.662454188,0.134004205,0.156187683), r0.xyz);
  r1.y = dot(float3(0.272228718,0.674081743,0.0536895171), r0.xyz);
  r1.z = dot(float3(-0.00557464967,0.0040607336,1.01033914), r0.xyz);
  r0.x = dot(r1.xyz, float3(1,1,1));
  r0.x = max(9.99999975e-05, r0.x);
  r0.xy = r1.xy / r0.xx;
  r0.w = max(0, r1.y);
  r0.w = min(65504, r0.w);
  r0.w = log2(r0.w);
  r0.w = 0.981100023 * r0.w;
  r1.y = exp2(r0.w);
  r0.w = max(9.99999975e-05, r0.y);
  r0.w = r1.y / r0.w;
  r1.w = 1 + -r0.x;
  r0.z = r1.w + -r0.y;
  r1.xz = r0.xz * r0.ww;
  r0.x = dot(float3(1.6410234,-0.324803293,-0.236424699), r1.xyz);
  r0.y = dot(float3(-0.663662851,1.61533165,0.0167563483), r1.xyz);
  r0.z = dot(float3(0.0117218941,-0.00828444213,0.988394856), r1.xyz);
  r0.w = dot(r0.xyz, float3(0.272228986,0.674081981,0.0536894985));
  r0.xyz = r0.xyz + -r0.www;
  r0.xyz = r0.xyz * float3(0.930000007,0.930000007,0.930000007) + r0.www;
  r1.x = dot(float3(0.662454188,0.134004205,0.156187683), r0.xyz);
  r1.y = dot(float3(0.272228718,0.674081743,0.0536895171), r0.xyz);
  r1.z = dot(float3(-0.00557464967,0.0040607336,1.01033914), r0.xyz);
  r0.x = dot(float3(0.987223983,-0.00611326983,0.0159533005), r1.xyz);
  r0.y = dot(float3(-0.00759836007,1.00186002,0.00533019984), r1.xyz);
  r0.z = dot(float3(0.00307257008,-0.00509594986,1.08168006), r1.xyz);
  r1.x = saturate(dot(float3(3.2409699,-1.5373832,-0.498610765), r0.xyz));
  r1.y = saturate(dot(float3(-0.969243646,1.8759675,0.0415550582), r0.xyz));
  r1.z = saturate(dot(float3(0.0556300804,-0.203976959,1.05697155), r0.xyz));*/
  r1.xyz = applyUserTonemapACES(r0.xyz, 2);
  if (cb0[137].w > 0) {
    r0.xyz = fastSrgbEncodeSafe(r1.xyz);
    r2.xyz = handleUserLUT(r1.xyz, t3, s0_s, cb0[137].xyz, 1);
    r2.xyz = r2.xyz + -r0.xyz;
    r0.xyz = cb0[137].www * r2.xyz + r0.xyz;
    r1.xyz = fastSrgbDecodeSafe(r0.xyz);
  }
  r1.xyz = lutShaper(r1.xyz, false, 1);
  if(injectedData.colorGradeLUTSampling == 0.f){
  r0.xyz = cb0[136].zzz * r1.zxy;
  r0.x = floor(r0.x);
  r1.xy = float2(0.5,0.5) * cb0[136].xy;
  r2.yz = r0.yz * cb0[136].xy + r1.xy;
  r2.x = r0.x * cb0[136].y + r2.y;
  r3.xyzw = t2.SampleLevel(s0_s, r2.xz, 0).xyzw;
  r1.x = cb0[136].y;
  r1.y = 0;
  r0.yz = r2.xz + r1.xy;
  r2.xyzw = t2.SampleLevel(s0_s, r0.yz, 0).xyzw;
  r0.x = r1.z * cb0[136].z + -r0.x;
  r0.yzw = r2.xyz + -r3.xyz;
  r0.xyz = r0.xxx * r0.yzw + r3.xyz;
  } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t2, r1.xyz, cb0[136].z + 1u);
  }
  float3 newPeak = renodx::lut::Sample(t2, s0_s, lutShaper((injectedData.toneMapPeakNits / injectedData.toneMapGameNits), false, 1), cb0[136].z + 1u) * injectedData.toneMapGameNits;
  float newPeakY = renodx::color::y::from::BT709(newPeak);
  float ratio = renodx::math::DivideSafe(injectedData.toneMapPeakNits / newPeakY, 1.f);
  if(ratio < 0.985f){
    r0.xyz = rolloff(r0.xyz, ratio);
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}