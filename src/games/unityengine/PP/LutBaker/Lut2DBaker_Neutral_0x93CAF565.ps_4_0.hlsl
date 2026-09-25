#include "../../common.hlsli"

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
  float3 preCG;
  float compression_scale;
  if (CUSTOM_INTERNAL_LUT_SHAPER == 0.f) {
  preCG = arriDecode(r0.xyz);
  r0.xyz = r0.xyz + float3(-0.4135884,-0.4135884,-0.4135884);
  r0.xyz = r0.xyz * cb0[34].zzz + float3(0.4135884,0.4135884,0.4135884);
  r0.xyz = arriDecode(r0.xyz);
  } else {
    r0.xyz = lutShaper(r0.xyz, true);
    preCG = r0.xyz;
    GamutCompression(r0.xyz, compression_scale);
    r0.xyz = renodx::color::arri::logc::c1000::Encode(r0.xyz, false);
    r0.xyz = r0.xyz + float3(-0.4135884,-0.4135884,-0.4135884);
    r0.xyz = r0.xyz * cb0[34].zzz + float3(0.4135884,0.4135884,0.4135884);
    r0.xyz = renodx::color::arri::logc::c1000::Decode(r0.xyz, false);
    GamutDecompression(r0.xyz, compression_scale);
  }
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
  r0.xyz = liftGammaGainScaling(r0.xyz, preLGG, cb0[38].xyz, cb0[39].xyz, cb0[40].xyz);
  GamutCompression(r0.xyz, compression_scale);
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
  r4.x = saturate(r4.x);
  r0.y = r4.x + r3.z;
  r0.yzw = float3(-0.5,0.5,-1.5) + r0.yyy;
  r0.w = (r0.y > 1) ? r0.w : r0.y;
  r0.y = (r0.y < 0) ? r0.z : r0.w;
  r0.yzw = float3(1.0, 2.0 / 3.0, 1.0 / 3.0) + r0.yyy;
  r0.yzw = frac(r0.yzw);
  r0.yzw = r0.yzw * float3(6,6,6) + float3(-3,-3,-3);
  r0.yzw = saturate(float3(-1,-1,-1) + abs(r0.yzw));
  r0.yzw = float3(-1,-1,-1) + r0.yzw;
  r1.y = 0.0001 + r0.x;
  r2.z = r1.x / r1.y;
  r0.yzw = r2.zzz * r0.yzw + float3(1,1,1);
  r1.xyz = r0.xxx * r0.yzw;
  r1.x = dot(r1.xyz, float3(0.212672904,0.715152204,0.0721750036));
  r0.xyz = r0.xxx * r0.yzw + -r1.xxx;
  r2.yw = float2(0.25,0.25);
  r3.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).yxzw;
  r2.xyzw = t0.SampleLevel(s0_s, r2.zw, 0).zxyw;
  r2.x = saturate(r2.x);
  r3.x = saturate(r3.x);
  r0.w = r3.x + r3.x;
  r0.w = dot(r2.xx, r0.ww);
  r0.w = r5.x * r0.w;
  r0.w = dot(cb0[34].yy, r0.ww);
  r0.xyz = r0.www * r0.xyz + r1.xxx;
  GamutDecompression(r0.xyz, compression_scale);
  r0.xyz = lerp(preCG, r0.xyz, CUSTOM_INTERNAL_LUT_STRENGTH);
  r0.xyz = NeutralTonemap(r0.xyz);
  float max_channel_scale;
  NeutwoMaxCh(r0.xyz, max_channel_scale);
  r0.xyz = float3(0.00390625,0.00390625,0.00390625) + r0.xyz;
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
  NeutwoMaxChInverse(o0.xyz, max_channel_scale);
  GamutDecompression(o0.xyz, compression_scale);
  return;
}