// ---- Created with 3Dmigoto v1.3.16 on Thu Sep 26 18:26:27 2024
#include "./shared.h"
#include "./tonemapper.hlsl"

cbuffer GFD_PSCONST_TONEMAP : register(b12) {
  float FilmSlope : packoffset(c0);
  float FilmToe : packoffset(c0.y);
  float FilmShoulder : packoffset(c0.z);
  float FilmBlackClip : packoffset(c0.w);
  float FilmWhiteClip : packoffset(c1);
  float FilmAlpha : packoffset(c1.y);
}

cbuffer GFD_PSCONST_SYSTEM : register(b0) {
  float2 resolution : packoffset(c0);
  float2 resolutionRev : packoffset(c0.z);
  float4x4 mtxView : packoffset(c1);
  float4x4 mtxInvView : packoffset(c5);
  float4x4 mtxProj : packoffset(c9);
  float4x4 mtxInvProj : packoffset(c13);
  float4 invProjParams : packoffset(c17);
}

cbuffer GFD_PSCONST_HDR : register(b11) {
  float middleGray : packoffset(c0);
  float adaptedLum : packoffset(c0.y);
  float bloomScale : packoffset(c0.z);
  float starScale : packoffset(c0.w);
  float elapsedTime : packoffset(c1);
  float toonBloomScale : packoffset(c1.y);
  float adaptedLumAdjust : packoffset(c1.z);
  float adaptedLumLimit : packoffset(c1.w);
  float pbrIntensity : packoffset(c2);
}

SamplerState opaueSampler_s : register(s0);
SamplerState bloomSampler_s : register(s1);
SamplerState toneSampler_s : register(s3);
Texture2D<float4> opaueTexture : register(t0);
Texture2D<float4> bloomTexture : register(t1);
Texture2D<float4> toneTexture : register(t3);
Texture2D<float4> gbuffer1Texture : register(t4);

// 3Dmigoto declarations
#define cmp -

void main(float4 v0
          : SV_POSITION0, float2 v1
          : TEXCOORD0, out float4 o0
          : SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9;
  uint4 bitmask, uiDest;
  float4 fDest;
  float3 untonemapped, vanilla, outputColor;

  r0.xyzw = bloomTexture.Sample(bloomSampler_s, v1.xy).xyzw;
  r1.xyz = opaueTexture.Sample(opaueSampler_s, v1.xy).xyz;
  untonemapped.rgb = r1.rgb;
  vanilla.rgb = r1.rgb;

  r2.xy = resolution.xy * v1.xy;
  r2.xy = (int2)r2.xy;
  r2.zw = float2(0, 0);
  r2.xy = gbuffer1Texture.Load(r2.xyz).zw;
  r1.w = 255 * r2.y;
  r1.w = (uint)r1.w;
  r1.w = (int)r1.w & 8;
  if (r1.w == 0) {
    r1.w = 255 * r2.x;
    r1.w = (uint)r1.w;
    r1.w = (uint)r1.w >> 4;
    r1.w = (uint)r1.w;
    r1.w = 0.0666666701 * r1.w;
    r2.x = toneTexture.Sample(toneSampler_s, float2(0.5, 0.5)).x;
    r2.y = 1 + -middleGray;
    r1.w = r2.y * r1.w + middleGray;
    r2.yzw = r1.xyz * r1.www;
    r2.yzw = adaptedLum * r2.yzw;
    r1.w = max(adaptedLumLimit, r2.x);
    r1.w = 9.99999975e-05 + r1.w;
    r1.w = -adaptedLum + r1.w;
    r1.w = adaptedLumAdjust * r1.w + adaptedLum;
    r2.xyz = r2.yzw / r1.www;
    untonemapped = r2.rgb;

    // Can we extract more colors by using AP0 below?
    r1.w = dot(float3(0.439700812, 0.382978052, 0.1773348), r2.xyz);
    r3.y = dot(float3(0.0897923037, 0.813423157, 0.096761629), r2.xyz);
    r3.z = dot(float3(0.0175439864, 0.111544058, 0.870704114), r2.xyz);
    r2.w = min(r3.y, r1.w);
    r2.w = min(r2.w, r3.z);
    r3.w = max(r3.y, r1.w);
    r3.w = max(r3.w, r3.z);
    r4.xy = max(float2(1.00000001e-10, 0.00999999978), r3.ww);
    r2.w = max(1.00000001e-10, r2.w);
    r2.w = r4.x + -r2.w;
    r2.w = r2.w / r4.y;
    r3.w = cmp(r1.w == r3.y);
    r4.x = cmp(r3.z == r3.y);
    r3.w = r3.w ? r4.x : 0;
    r4.x = r3.y + -r3.z;
    r4.x = 1.73205078 * r4.x;
    r4.y = r1.w * 2 + -r3.y;
    r4.y = r4.y + -r3.z;
    r4.z = min(abs(r4.x), abs(r4.y));
    r4.w = max(abs(r4.x), abs(r4.y));
    r4.w = 1 / r4.w;
    r4.z = r4.z * r4.w;
    r4.w = r4.z * r4.z;
    r5.x = r4.w * 0.0208350997 + -0.0851330012;
    r5.x = r4.w * r5.x + 0.180141002;
    r5.x = r4.w * r5.x + -0.330299497;
    r4.w = r4.w * r5.x + 0.999866009;
    r5.x = r4.z * r4.w;
    r5.y = cmp(abs(r4.y) < abs(r4.x));
    r5.x = r5.x * -2 + 1.57079637;
    r5.x = r5.y ? r5.x : 0;
    r4.z = r4.z * r4.w + r5.x;
    r4.w = cmp(r4.y < -r4.y);
    r4.w = r4.w ? -3.141593 : 0;
    r4.z = r4.z + r4.w;
    r4.w = min(r4.x, r4.y);
    r4.x = max(r4.x, r4.y);
    r4.y = cmp(r4.w < -r4.w);
    r4.x = cmp(r4.x >= -r4.x);
    r4.x = r4.x ? r4.y : 0;
    r4.x = r4.x ? -r4.z : r4.z;
    r4.x = 57.2957802 * r4.x;
    r3.w = r3.w ? 0 : r4.x;
    r4.x = cmp(r3.w < 0);
    r4.y = 360 + r3.w;
    r3.w = r4.x ? r4.y : r3.w;
    r3.w = max(0, r3.w);
    r3.w = min(360, r3.w);
    r4.x = cmp(180 < r3.w);
    r4.y = -360 + r3.w;
    r3.w = r4.x ? r4.y : r3.w;
    r3.w = 0.0148148146 * r3.w;
    r3.w = 1 + -abs(r3.w);
    r3.w = max(0, r3.w);
    r4.x = r3.w * -2 + 3;
    r3.w = r3.w * r3.w;
    r3.w = r4.x * r3.w;
    r3.w = r3.w * r3.w;
    r2.w = r3.w * r2.w;
    r3.w = 0.0299999993 + -r1.w;
    r2.w = r3.w * r2.w;
    r3.x = r2.w * 0.180000007 + r1.w;
    r4.x = dot(float3(1.45143926, -0.236510754, -0.214928567), r3.xyz);
    r4.y = dot(float3(-0.0765537769, 1.17622972, -0.0996759236), r3.xyz);
    r4.z = dot(float3(0.00831614807, -0.00603244966, 0.997716308), r3.xyz);
    r3.xyz = max(float3(0, 0, 0), r4.xyz);
    r1.w = dot(r3.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
    r3.xyz = r3.xyz + -r1.www;
    r3.xyz = r3.xyz * float3(0.959999979, 0.959999979, 0.959999979) + r1.www;

    r4.xy = float2(1, 0.180000007) + FilmBlackClip;
    r1.w = -FilmToe + r4.x;
    r2.w = 1 + FilmWhiteClip;
    r3.w = -FilmShoulder + r2.w;
    r4.x = cmp(0.800000012 < FilmToe);
    r4.zw = float2(0.819999993, 1) + -FilmToe;
    r4.zw = r4.zw / FilmSlope;
    r4.z = -0.744727492 + r4.z;
    r4.y = r4.y / r1.w;
    r5.x = -1 + r4.y;
    r5.x = 1 + -r5.x;
    r4.y = r4.y / r5.x;
    r4.y = log2(r4.y);
    r4.y = 0.346573591 * r4.y;
    r5.x = r1.w / FilmSlope;
    r4.y = -r4.y * r5.x + -0.744727492;
    r4.x = r4.x ? r4.z : r4.y;
    r4.y = r4.w + -r4.x;
    r4.z = FilmShoulder / FilmSlope;
    r4.z = r4.z + -r4.y;
    r3.xyz = log2(r3.xyz);
    r5.xyz = float3(0.30103001, 0.30103001, 0.30103001) * r3.xyz;
    r6.xyz = r3.xyz * float3(0.30103001, 0.30103001, 0.30103001) + r4.yyy;
    r6.xyz = FilmSlope * r6.xyz;
    r4.y = r1.w + r1.w;
    r4.w = -2 * FilmSlope;
    r1.w = r4.w / r1.w;
    r7.xyz = r3.xyz * float3(0.30103001, 0.30103001, 0.30103001) + -r4.xxx;
    r8.xyz = r7.xyz * r1.www;
    r8.xyz = float3(1.44269502, 1.44269502, 1.44269502) * r8.xyz;
    r8.xyz = exp2(r8.xyz);
    r8.xyz = float3(1, 1, 1) + r8.xyz;
    r8.xyz = r4.yyy / r8.xyz;
    r8.xyz = -FilmBlackClip + r8.xyz;
    r1.w = r3.w + r3.w;
    r4.y = FilmSlope + FilmSlope;
    r3.w = r4.y / r3.w;
    r3.xyz = r3.xyz * float3(0.30103001, 0.30103001, 0.30103001) + -r4.zzz;
    r3.xyz = r3.www * r3.xyz;
    r3.xyz = float3(1.44269502, 1.44269502, 1.44269502) * r3.xyz;
    r3.xyz = exp2(r3.xyz);
    r3.xyz = float3(1, 1, 1) + r3.xyz;
    r3.xyz = r1.www / r3.xyz;
    r3.xyz = -r3.xyz + r2.www;
    r9.xyz = cmp(r5.xyz < r4.xxx);
    r8.xyz = r9.xyz ? r8.xyz : r6.xyz;
    r5.xyz = cmp(r4.zzz < r5.xyz);
    r3.xyz = r5.xyz ? r3.xyz : r6.xyz;
    r1.w = r4.z + -r4.x;
    r5.xyz = saturate(r7.xyz / r1.www);
    r1.w = cmp(r4.z < r4.x);
    r4.xyz = float3(1, 1, 1) + -r5.xyz;
    r4.xyz = r1.www ? r4.xyz : r5.xyz;
    r5.xyz = -r4.xyz * float3(2, 2, 2) + float3(3, 3, 3);
    r4.xyz = r4.xyz * r4.xyz;
    r4.xyz = r4.xyz * r5.xyz;
    r3.xyz = r3.xyz + -r8.xyz;
    r3.xyz = r4.xyz * r3.xyz + r8.xyz;
    r1.w = dot(r3.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
    r3.xyz = r3.xyz + -r1.www;
    r3.xyz = r3.xyz * float3(0.930000007, 0.930000007, 0.930000007) + r1.www;
    r3.xyz = max(float3(0, 0, 0), r3.xyz);
    r3.xyz = r3.xyz + -r2.xyz;
    r1.xyz = FilmAlpha * r3.xyz + r2.xyz;
    vanilla = r1.rgb;
  }

  if (injectedData.toneMapType == 3.f) {
    outputColor.rgb = renodx::color::correct::Hue(
        untonemapped, renodx::tonemap::ACESFittedAP1(untonemapped));
  } else {
    outputColor.rgb = untonemapped;
  }

  // Add bloom
  // We add it to vanilla cause devs add linear bloom to tonemapped image
  // o0.xyz = r0.xyz * r0.www + r1.xyz;
  vanilla = r0.xyz * r0.www + vanilla.rgb;

  outputColor = applyUserTonemap(outputColor);

  if (injectedData.toneMapType > 1) {
    // We don't get a lot of WCG colors but might as well ig
    // blend HDR with SDR
    float3 negHDR = min(0, outputColor);  // save WCG
    outputColor = lerp(saturate(vanilla), max(0, outputColor), saturate(vanilla));
    outputColor += negHDR;  // add back WCG
  } else {
    outputColor = vanilla;
  }

  o0.xyz = outputColor.rgb;
  o0.w = 1;
  return;
}