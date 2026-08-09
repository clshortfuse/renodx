#include "../../tonemap.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[41];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.yz = -cb0[30].yz + v1.xy;
  r1.x = cb0[30].x * r0.y;
  r0.x = frac(r1.x);
  r1.x = r0.x / cb0[30].x;
  r0.w = -r1.x + r0.y;
  r0.xyz = r0.xzw * cb0[30].www;
  r0.xyz = lutShaper(r0.xyz, true);
  float3 preCG = r0.xyz;
  r1.x = dot(float3(0.439700991,0.382977992,0.177334994), r0.xyz);
  r1.y = dot(float3(0.0897922963,0.813422978,0.0967615992), r0.xyz);
  r1.z = dot(float3(0.0175439995,0.111543998,0.870703995), r0.xyz);
  r0.xyz = acesccEncode(r1.xyz);
  r0.xyz = float3(-0.4135884,-0.4135884,-0.4135884) + r0.xyz;
  r0.xyz = r0.xyz * cb0[34].zzz + float3(0.4135884,0.4135884,0.4135884);
  r1.xyz = acescc::Decode(r0.xyz);
  r0.x = dot(float3(1.45143926,-0.236510754,-0.214928567), r1.xyz);
  r0.y = dot(float3(-0.0765537769,1.17622972,-0.0996759236), r1.xyz);
  r0.z = dot(float3(0.00831614807,-0.00603244966,0.997716308), r1.xyz);
  r1.x = dot(float3(0.390405,0.549941,0.00892632), r0.xyz);
  r1.y = dot(float3(0.0708416,0.963172,0.00135775), r0.xyz);
  r1.z = dot(float3(0.0231082,0.128021,0.936245), r0.xyz);
  r0.xyz = cb0[32].xyz * r1.xyz;
  r1.x = dot(float3(2.858470,-1.628790,-0.024891), r0.xyz);
  r1.y = dot(float3(-0.210182,1.158200,0.000324281), r0.xyz);
  r1.z = dot(float3(-0.041812,-0.118169,1.068670), r0.xyz);
  r0.xyz = cb0[33].xyz * r1.xyz;
  r1.x = dot(r0.xyz, cb0[35].xyz);
  r1.y = dot(r0.xyz, cb0[36].xyz);
  r1.z = dot(r0.xyz, cb0[37].xyz);
  float3 preLGG = r1.xyz;
  r0.xyz = r1.xyz * cb0[40].xyz + cb0[38].xyz;
  r1.xyz = log2(abs(r0.xyz));
  r0.xyz = saturate(r0.xyz * renodx::math::FLT_MAX + float3(0.5,0.5,0.5));
  r0.xyz = r0.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r1.xyz = cb0[39].xyz * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = liftGammaGainScaling(r0.xyz, preLGG, cb0[38].xyz, cb0[39].xyz, cb0[40].xyz, 1);
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.w = step(r0.z, r0.y);
  r1.xy = r0.zy;
  r2.xy = -r1.xy + r0.yz;
  r1.zw = float2(-1.0, 2.0 / 3.0);
  r2.zw = float2(1,-1);
  r1.xyzw = r0.wwww * r2.xywz + r1.xywz;
  r0.w = step(r1.x, r0.x);
  r2.z = r1.w;
  r1.w = r0.x;
  r3.x = dot(r0.xyz, float3(0.212672904,0.715152204,0.0721750036));
  r2.xyw = r1.wyx;
  r2.xyzw = r2.xyzw + -r1.xyzw;
  r0.xyzw = r0.wwww * r2.xyzw + r1.xyzw;
  r1.x = min(r0.w, r0.y);
  r1.x = -r1.x + r0.x;
  r1.y = r1.x * 6.0 + 0.0001;
  r0.y = r0.w + -r0.y;
  r0.y = r0.y / r1.y;
  r0.y = r0.z + r0.y;
  r2.x = abs(r0.y);
  r3.z = cb0[34].x + r2.x;
  r3.yw = float2(0.25,0.25);
  r4.xyzw = t0.SampleLevel(s0_s, r3.zw, 0).xyzw;
  r5.xyzw = t0.SampleLevel(s0_s, r3.xy, 0).wxyz;
  r5.x = saturate(r5.x);
  r0.y = r5.x + r5.x;
  r4.x = saturate(r4.x);
  r0.z = r4.x + r3.z;
  r1.yzw = float3(-0.5,0.5,-1.5) + r0.zzz;
  r0.z = (r1.y > 1) ? r1.w : r1.y;
  r0.z = (r1.y < 0) ? r1.z : r0.z;
  r1.yzw = float3(1.0, 2.0 / 3.0, 1.0 / 3.0) + r0.zzz;
  r1.yzw = frac(r1.yzw);
  r1.yzw = r1.yzw * float3(6,6,6) + float3(-3,-3,-3);
  r1.yzw = saturate(float3(-1,-1,-1) + abs(r1.yzw));
  r1.yzw = float3(-1,-1,-1) + r1.yzw;
  r0.z = 0.0001 + r0.x;
  r2.z = r1.x / r0.z;
  r1.xyz = r2.zzz * r1.yzw + float3(1,1,1);
  r3.xyz = r1.xyz * r0.xxx;
  r0.z = dot(r3.xyz, float3(0.212672904,0.715152204,0.0721750036));
  r1.xyz = r0.xxx * r1.xyz + -r0.zzz;
  r2.yw = float2(0.25,0.25);
  r3.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).yxzw;
  r2.xyzw = t0.SampleLevel(s0_s, r2.zw, 0).zxyw;
  r2.x = saturate(r2.x);
  r0.x = r2.x + r2.x;
  r3.x = saturate(r3.x);
  r0.w = r3.x + r3.x;
  r0.x = r0.w * r0.x;
  r0.x = r0.x * r0.y;
  r0.x = cb0[34].y * r0.x;
  r0.xyz = r0.xxx * r1.xyz + r0.zzz;
  r1.y = dot(float3(0.695452213,0.140678704,0.163869068), r0.xyz);
  r1.z = dot(float3(0.0447945632,0.859671116,0.0955343172), r0.xyz);
  r1.w = dot(float3(-0.00552588282,0.00402521016,1.00150073), r0.xyz);
  r0.xyz = mul(ACES_to_SRGB_MAT, r1.yzw);
  r0.xyz = lerp(preCG, r0.xyz, injectedData.colorGradeInternalLUTStrength);
  r0.xyz = applyUserTonemapACES(r0.xyz, 0);
  float3 hdrColor = r0.xyz;
  float3 sdrColor = renodx::tonemap::renodrt::NeutralSDR(hdrColor);
  float3 curvesInput = injectedData.toneMapType <= 1.f ? hdrColor : sdrColor;
  r1.xyz = curvesInput;
  bool isWCG = r1.x < 0.0 || r1.y < 0.0 || r1.z < 0.0;
  if(injectedData.toneMapType != 0.f){
    r1.xyz = isWCG ? renodx::color::bt2020::from::BT709(r1.xyz) : r1.xyz;
  }
  r0.xyz = float3(0.00390625,0.00390625,0.00390625) + r1.xyz;
  r0.w = 0.75;
  r1.xyzw = t0.Sample(s0_s, r0.xw).wxyz;
  r1.x = saturate(r1.x);
  r2.xyzw = t0.Sample(s0_s, r0.yw).xyzw;
  r0.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  r1.z = saturate(r0.w);
  r1.y = saturate(r2.w);
  r0.xyz = float3(0.00390625,0.00390625,0.00390625) + r1.xyz;
  r0.w = 0.75;
  r1.xyzw = t0.Sample(s0_s, r0.xw).xyzw;
  o0.x = saturate(r1.x);
  r1.xyzw = t0.Sample(s0_s, r0.yw).xyzw;
  r0.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  o0.z = saturate(r0.z);
  o0.y = saturate(r1.y);
  o0.w = 1;
  if(injectedData.toneMapType != 0.f){
    o0.xyz = isWCG ? renodx::color::bt709::from::BT2020(o0.xyz) : o0.xyz;
  }
  if (injectedData.toneMapType != 0.f) {
    o0.xyz = renodx::tonemap::UpgradeToneMap(hdrColor, min(1.f, curvesInput), o0.xyz, injectedData.colorGradeInternalLUTStrength);
  } else {
    o0.xyz = lerp(curvesInput, o0.xyz, injectedData.colorGradeInternalLUTStrength);
  }
  return;
}