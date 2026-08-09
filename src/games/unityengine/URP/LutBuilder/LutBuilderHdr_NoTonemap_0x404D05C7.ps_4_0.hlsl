#include "../../tonemap.hlsl"

Texture2D<float4> t7 : register(t7);
Texture2D<float4> t6 : register(t6);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[147];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.yz = -cb0[131].yz + v1.xy;
  r1.x = cb0[131].x * r0.y;
  r0.x = frac(r1.x);
  r1.x = r0.x / cb0[131].x;
  r0.w = -r1.x + r0.y;
  r0.xyz = r0.xzw * cb0[131].www;
  r0.xyz = lutShaper(r0.xyz, true);
  float3 preCG = r0.xyz;
  r1.x = dot(float3(0.390405,0.549941,0.00892632), r0.xyz);
  r1.y = dot(float3(0.0708416,0.963172,0.00135775), r0.xyz);
  r1.z = dot(float3(0.0231082,0.128021,0.936245), r0.xyz);
  r0.xyz = cb0[132].xyz * r1.xyz;
  r1.x = dot(float3(2.85847,-1.62879,-0.0248910), r0.xyz);
  r1.y = dot(float3(-0.210182,1.15820,0.000324281), r0.xyz);
  r1.z = dot(float3(-0.0418120,-0.118169,1.06867), r0.xyz);
  r0.xyz = renodx::color::arri::logc::c1000::Encode(r1.xyz, true);
  r0.xyz = float3(-0.4135884,-0.4135884,-0.4135884) + r0.xyz;
  r0.xyz = r0.xyz * cb0[137].zzz + float3(0.4135884,0.4135884,0.4135884);
  r0.xyz = renodx::color::arri::logc::c1000::Decode(r0.xyz, true);
  r0.xyz = cb0[133].xyz * r0.xyz;
  bool isWCG = r0.x < 0.0 || r0.y < 0.0 || r0.z < 0.0;
  if(injectedData.toneMapType != 0.f){
    r0.xyz = isWCG ? renodx::color::bt2020::from::BT709(r0.xyz) : r0.xyz;
  }
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.xyz = pow(r0.xyz, 1.f / 2.2f);
  r1.xyz = r0.xyz + r0.xyz;
  r2.xyz = r0.xyz * r0.xyz;
  r3.xyz = min(float3(1,1,1), r0.xyz);
  r0.xyz = sqrt(r0.xyz);
  r0.w = dot(r3.xyz, float3(0.212672904,0.715152204,0.0721750036));
  r0.w = saturate(cb0[145].w + r0.w);
  r1.w = 1 + -r0.w;
  r3.xyz = float3(-0.5,-0.5,-0.5) + cb0[145].xyz;
  r3.xyz = r1.www * r3.xyz + float3(0.5,0.5,0.5);
  r4.xyz = -r3.xyz * float3(2,2,2) + float3(1,1,1);
  r2.xyz = r4.xyz * r2.xyz;
  r2.xyz = r1.xyz * r3.xyz + r2.xyz;
  r4.xyz = step(0.5, r3.xyz);
  r5.xyz = 1.0 - r4.xyz;
  r2.xyz = r5.xyz * r2.xyz;
  r5.xyz = float3(1,1,1) + -r3.xyz;
  r3.xyz = r3.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r1.xyz = r5.xyz * r1.xyz;
  r0.xyz = r0.xyz * r3.xyz + r1.xyz;
  r0.xyz = r0.xyz * r4.xyz + r2.xyz;
  r1.xyz = r0.xyz + r0.xyz;
  r2.xyz = r0.xyz * r0.xyz;
  r0.xyz = sqrt(r0.xyz);
  r3.xyz = float3(-0.5,-0.5,-0.5) + cb0[146].xyz;
  r3.xyz = r0.www * r3.xyz + float3(0.5,0.5,0.5);
  r4.xyz = -r3.xyz * float3(2,2,2) + float3(1,1,1);
  r2.xyz = r4.xyz * r2.xyz;
  r2.xyz = r1.xyz * r3.xyz + r2.xyz;
  r4.xyz = step(0.5, r3.xyz);
  r5.xyz = 1.0 - r4.xyz;
  r2.xyz = r5.xyz * r2.xyz;
  r5.xyz = float3(1,1,1) + -r3.xyz;
  r3.xyz = r3.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r1.xyz = r5.xyz * r1.xyz;
  r0.xyz = r0.xyz * r3.xyz + r1.xyz;
  r0.xyz = r0.xyz * r4.xyz + r2.xyz;
  r0.xyz = pow(abs(r0.xyz), 2.2f);
  if(injectedData.toneMapType != 0.f){
    r0.xyz = isWCG ? renodx::color::bt709::from::BT2020(r0.xyz) : r0.xyz;
  }
  r1.x = dot(r0.xyz, cb0[134].xyz);
  r1.y = dot(r0.xyz, cb0[135].xyz);
  r1.z = dot(r0.xyz, cb0[136].xyz);
  r0.xyz = cb0[142].xyz * r1.xyz;
  r0.w = dot(r1.xyz, float3(0.212672904,0.715152204,0.0721750036));
  r2.xy = -cb0[144].xz + r0.ww;
  r2.zw = cb0[144].yw + -cb0[144].xz;
  r2.zw = float2(1,1) / r2.zw;
  r2.xy = saturate(r2.xy * r2.zw);
  r2.zw = r2.xy * float2(-2,-2) + float2(3,3);
  r2.xy = r2.xy * r2.xy;
  r0.w = -r2.z * r2.x + 1;
  r1.w = 1 + -r0.w;
  r1.w = -r2.w * r2.y + r1.w;
  r2.x = r2.w * r2.y;
  r0.xyz = r1.www * r0.xyz;
  r2.yzw = cb0[141].xyz * r1.xyz;
  r1.xyz = cb0[143].xyz * r1.xyz;
  r0.xyz = r2.yzw * r0.www + r0.xyz;
  r0.xyz = r1.xyz * r2.xxx + r0.xyz;
  float3 preLGG = r0.xyz;
  r0.xyz = r0.xyz * cb0[140].xyz + cb0[138].xyz;
  r2.xyz = sign(r0.xyz) * pow(abs(r0.xyz), cb0[139].xyz);
  r2.xyz = liftGammaGainScaling(r2.xyz, preLGG, cb0[138].xyz, cb0[139].xyz, cb0[140].xyz);
  isWCG = r2.x < 0.0 || r2.y < 0.0 || r2.z < 0.0;
  if(injectedData.toneMapType != 0.f){
    r2.xyz = isWCG ? renodx::color::bt2020::from::BT709(r2.xyz) : r2.xyz;
  }
  r3.xy = r2.zy;
  r0.xy = r2.yz + -r3.xy;
  r1.x = step(r2.z, r3.y);
  r3.zw = float2(-1.0, 2.0 / 3.0);
  r0.zw = float2(1,-1);
  r0.xyzw = r1.xxxx * r0.xywz + r3.xywz;
  r1.x = step(r0.x, r2.x);
  r3.z = r0.w;
  r0.w = r2.x;
  r2.x = dot(r2.xyz, float3(0.212672904,0.715152204,0.0721750036));
  r3.xyw = r0.wyx;
  r3.xyzw = r3.xyzw + -r0.xyzw;
  r0.xyzw = r1.xxxx * r3.xyzw + r0.xyzw;
  r1.x = min(r0.w, r0.y);
  r1.x = -r1.x + r0.x;
  r1.y = r1.x * 6.0 + 0.0001;
  r0.y = r0.w + -r0.y;
  r0.y = r0.y / r1.y;
  r0.y = r0.z + r0.y;
  r3.x = abs(r0.y);
  r2.z = cb0[137].x + r3.x;
  r2.yw = float2(0,0);
  r4.xyzw = t4.SampleBias(s0_s, r2.zw, cb0[5].x).xyzw;
  r5.xyzw = t7.SampleBias(s0_s, r2.xy, cb0[5].x).xyzw;
  r5.x = saturate(r5.x);
  r4.x = saturate(r4.x);
  r0.y = r4.x + r2.z;
  r0.yzw = float3(-0.5,0.5,-1.5) + r0.yyy;
  r0.w = (r0.y > 1) ? r0.w : r0.y;
  r0.y = (r0.y < 0) ? r0.z : r0.w;
  r0.yzw = float3(1.0, 2.0 / 3.0, 1.0 / 3.0) + r0.yyy;
  r0.yzw = frac(r0.yzw);
  r0.yzw = r0.yzw * float3(6,6,6) + float3(-3,-3,-3);
  r0.yzw = saturate(float3(-1,-1,-1) + abs(r0.yzw));
  r0.yzw = float3(-1,-1,-1) + r0.yzw;
  r1.y = 0.0001 + r0.x;
  r3.z = r1.x / r1.y;
  r0.yzw = r3.zzz * r0.yzw + float3(1,1,1);
  r1.xyz = r0.xxx * r0.yzw;
  r1.x = dot(r1.xyz, float3(0.212672904,0.715152204,0.0721750036));
  r0.xyz = r0.xxx * r0.yzw + -r1.xxx;
  r3.yw = float2(0,0);
  r2.xyzw = t5.SampleBias(s0_s, r3.xy, cb0[5].x).xyzw;
  r3.xyzw = t6.SampleBias(s0_s, r3.zw, cb0[5].x).xyzw;
  r3.x = saturate(r3.x);
  r2.x = saturate(r2.x);
  r0.w = r2.x + r2.x;
  r0.w = dot(r3.xx, r0.ww);
  r0.w = r5.x * r0.w;
  r0.w = dot(cb0[137].yy, r0.ww);
  r0.xyz = r0.www * r0.xyz + r1.xxx;
  r0.w = max(r0.x, r0.y);
  r0.w = max(r0.w, r0.z);
  r0.w = 1 + r0.w;
  r0.w = 1 / r0.w;
  r0.xyz = r0.xyz * r0.www + float3(0.00390625,0.00390625,0.00390625);
  r0.w = 0;
  r1.xyzw = t0.SampleBias(s0_s, r0.xw, cb0[5].x).xyzw;
  r1.x = saturate(r1.x);
  r2.xyzw = t0.SampleBias(s0_s, r0.yw, cb0[5].x).xyzw;
  r0.xyzw = t0.SampleBias(s0_s, r0.zw, cb0[5].x).xyzw;
  r1.z = saturate(r0.x);
  r1.y = saturate(r2.x);
  r0.xyz = float3(0.00390625,0.00390625,0.00390625) + r1.xyz;
  r0.w = 0;
  r1.xyzw = t1.SampleBias(s0_s, r0.xw, cb0[5].x).xyzw;
  r1.x = saturate(r1.x);
  r2.xyzw = t2.SampleBias(s0_s, r0.yw, cb0[5].x).xyzw;
  r0.xyzw = t3.SampleBias(s0_s, r0.zw, cb0[5].x).xyzw;
  r1.z = saturate(r0.x);
  r1.y = saturate(r2.x);
  r0.x = max(r1.x, r1.y);
  r0.x = max(r0.x, r1.z);
  r0.x = 1 + -r0.x;
  r0.x = 1 / r0.x;
  r0.xyz = r1.xyz * r0.xxx;
  if(injectedData.toneMapType != 0.f){
    r0.xyz = isWCG ? renodx::color::bt709::from::BT2020(r0.xyz) : r0.xyz;
  }
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
    r0.xyz = applyUserNoTonemap(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}