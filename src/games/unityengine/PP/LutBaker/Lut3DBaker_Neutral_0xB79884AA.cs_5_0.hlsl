#include "../../tonemap.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
RWTexture3D<float4> u0 : register(u0);
cbuffer cb0 : register(b0){
  float4 cb0[10];
}

[numthreads(8, 8, 8)]
void main(uint3 vThreadID: SV_DispatchThreadID) {
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  if (float(vThreadID.x) < cb0[0].x && float(vThreadID.y) < cb0[0].x && float(vThreadID.z) < cb0[0].x) {
    r0.xyz = float3(vThreadID) * cb0[0].yyy;
    float3 preCG;
    if (injectedData.colorGradeInternalLUTShaper == 0.f) {
      preCG = arriDecode(r0.xyz);
      r0.xyz = r0.xyz + float3(-0.4135884,-0.4135884,-0.4135884);
      r0.xyz = r0.xyz * cb0[3].zzz + float3(0.4135884,0.4135884,0.4135884);
      r0.xyz = arriDecode(r0.xyz);
    } else {
      r0.xyz = lutShaper(r0.xyz, true);
      preCG = r0.xyz;
      r0.xyz = renodx::color::arri::logc::c1000::Encode(r0.xyz, true);
      r0.xyz = r0.xyz + float3(-0.4135884,-0.4135884,-0.4135884);
      r0.xyz = r0.xyz * cb0[3].zzz + float3(0.4135884,0.4135884,0.4135884);
      r0.xyz = renodx::color::arri::logc::c1000::Decode(r0.xyz, true);
    }
    r1.x = dot(float3(0.390405,0.549941,0.00892632), r0.xyz);
    r1.y = dot(float3(0.0708416,0.963172,0.00135775), r0.xyz);
    r1.z = dot(float3(0.0231082,0.128021,0.936245), r0.xyz);
    r0.xyz = cb0[1].xyz * r1.xyz;
    r1.x = dot(float3(2.858470,-1.628790,-0.024891), r0.xyz);
    r1.y = dot(float3(-0.210182,1.158200,0.000324281), r0.xyz);
    r1.z = dot(float3(-0.041812,-0.118169,1.068670), r0.xyz);
    r0.xyz = cb0[2].xyz * r1.xyz;
    r1.x = dot(r0.xyz, cb0[4].xyz);
    r1.y = dot(r0.xyz, cb0[5].xyz);
    r1.z = dot(r0.xyz, cb0[6].xyz);
    float3 preLGG = r1.xyz;
    r0.xyz = r1.xyz * cb0[9].xyz + cb0[7].xyz;
    r1.xyz = saturate(r0.xyz * renodx::math::FLT_MAX + float3(0.5,0.5,0.5));
    r1.xyz = r1.xyz * float3(2,2,2) + float3(-1,-1,-1);
    r0.xyz = log2(abs(r0.xyz));
    r0.xyz = cb0[8].xyz * r0.xyz;
    r0.xyz = exp2(r0.xyz);
    r0.xyz = r1.xyz * r0.xyz;
    r0.xyz = liftGammaGainScaling(r0.xyz, preLGG, cb0[7].xyz, cb0[8].xyz, cb0[9].xyz);
    bool isWCG = r0.x < 0.0 || r0.y < 0.0 || r0.z < 0.0;
    if(injectedData.toneMapType != 0.f){
      r0.xyz = isWCG ? renodx::color::bt2020::from::BT709(r0.xyz) : r0.xyz;
    }
    r0.xyz = max(float3(0,0,0), r0.xyz);
    r0.w = step(r0.z, r0.y);
    r1.xy = r0.zy;
    r1.zw = float2(-1.0, 2.0 / 3.0);
    r2.xy = -r1.xy + r0.yz;
    r2.zw = float2(1,-1);
    r1.xyzw = r0.wwww * r2.xyzw + r1.xyzw;
    r0.w = step(r1.x, r0.x);
    r2.xyz = r1.xyw;
    r2.w = r0.x;
    r1.xyw = r2.wyx;
    r1.xyzw = r1.xyzw + -r2.xyzw;
    r1.xyzw = r0.wwww * r1.xyzw + r2.xyzw;
    r0.w = min(r1.w, r1.y);
    r0.w = r1.x + -r0.w;
    r1.y = r1.w + -r1.y;
    r1.w = r0.w * 6.0 + 0.0001;
    r1.y = r1.y / r1.w;
    r1.y = r1.z + r1.y;
    r2.x = abs(r1.y);
    r1.y = 0.0001 + r1.x;
    r2.z = r0.w / r1.y;
    r2.yw = float2(0.25,0.25);
    r0.w = t0.SampleLevel(s0_s, r2.xy, 0).y;
    r0.w = saturate(r0.w);
    r0.w = r0.w + r0.w;
    r1.y = t0.SampleLevel(s0_s, r2.zw, 0).z;
    r1.y = saturate(r1.y);
    r0.w = dot(r1.yy, r0.ww);
    r3.x = dot(r0.xyz, float3(0.212672904,0.715152204,0.0721750036));
    r3.yw = float2(0.25,0.25);
    r0.x = t0.SampleLevel(s0_s, r3.xy, 0).w;
    r0.x = saturate(r0.x);
    r0.x = r0.x * r0.w;
    r3.z = cb0[3].x + r2.x;
    r0.y = t0.SampleLevel(s0_s, r3.zw, 0).x;
    r0.y = saturate(r0.y);
    r0.y = r0.y + r3.z;
    r0.yzw = float3(-0.5,0.5,-1.5) + r0.yyy;
    float value = r0.y;
    r0.y = (value > 1) ? r0.w : r0.y;
    r0.y = (value < 0) ? r0.z : r0.y;
    r0.yzw = float3(1.0, 2.0 / 3.0, 1.0 / 3.0) + r0.yyy;
    r0.yzw = frac(r0.yzw);
    r0.yzw = r0.yzw * float3(6,6,6) + float3(-3,-3,-3);
    r0.yzw = saturate(float3(-1,-1,-1) + abs(r0.yzw));
    r0.yzw = float3(-1,-1,-1) + r0.yzw;
    r0.yzw = r2.zzz * r0.yzw + float3(1,1,1);
    r1.yzw = r1.xxx * r0.yzw;
    r0.x = dot(cb0[3].yy, r0.xx);
    r1.y = dot(r1.yzw, float3(0.212672904,0.715152204,0.0721750036));
    r0.yzw = r1.xxx * r0.yzw + -r1.yyy;
    r0.xyz = r0.xxx * r0.yzw + r1.yyy;
    if(injectedData.toneMapType != 0.f){
      r0.xyz = isWCG ? renodx::color::bt709::from::BT2020(r0.xyz) : r0.xyz;
    }
    r0.xyz = lerp(preCG, r0.xyz, injectedData.colorGradeInternalLUTStrength);
    r0.xyz = applyUserTonemapNeutral(r0.xyz);
    r0.w = 1;
    u0[vThreadID] = r0;
  }
  return;
}