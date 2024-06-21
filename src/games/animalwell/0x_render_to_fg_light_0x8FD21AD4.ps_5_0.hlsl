#include "./shared.h"

cbuffer PS_CONSTANT_BUFFER : register(b0)
{

  struct
  {
    float x;
    float y;
    float z;
    float rx;
    float ry;
    float rz;
    float sx;
    float sy;
    float sz;
    float pad;
    float pad2;
    float pad3;
  } boxes[4] : packoffset(c0);


  struct
  {
    float4 s;
  } spheres[4] : packoffset(c12);


  struct
  {
    float x;
    float y;
    float z;
    float rx;
    float ry;
    float rz;
    float rInner;
    float rOuter;
  } toruses[4] : packoffset(c16);


  struct
  {
    float4 s;
  } bgSpheres[21] : packoffset(c24);

  int numBoxes : packoffset(c45);
  int numSpheres : packoffset(c45.y);
  int numToruses : packoffset(c45.z);
  float sdfBlend : packoffset(c45.w);
  float4 lights[16] : packoffset(c46);
  float4 lightColors[16] : packoffset(c62);
  float4 ambientLightColor : packoffset(c78);
  float4 fgAmbientLightColor : packoffset(c79);
  float4 bgAmbientLightColor : packoffset(c80);
  float4 fogColor : packoffset(c81);
  float4 colorGainSaturation : packoffset(c82);
  float4 camoLUTCoords : packoffset(c83);
  float2 windowResolution : packoffset(c84);
  float2 mapOffset : packoffset(c84.z);
  float2 fluidSize : packoffset(c85);
  float2 playerPos : packoffset(c85.z);
  float rimLightBrightness : packoffset(c86);
  float midToneBrightness : packoffset(c86.y);
  float shadowBrightness : packoffset(c86.z);
  float farBackgroundReflectivity : packoffset(c86.w);
  float time : packoffset(c87);
  float tpAmount : packoffset(c87.y);
  int mosaicAmount : packoffset(c87.z);
  int numLights : packoffset(c87.w);
  float scanlineAmount : packoffset(c88);
  float blurAmount : packoffset(c88.y);
  float waterLevel : packoffset(c88.z);
  float mapScale : packoffset(c88.w);
  float mapLeft : packoffset(c89);
  float mapRight : packoffset(c89.y);
  float maxFluidForce : packoffset(c89.z);
  float camoBlend : packoffset(c89.w);
  float foregroundSDFDistanceFactor : packoffset(c90);
  int padding0 : packoffset(c90.y);
  int padding1 : packoffset(c90.z);
  int padding2 : packoffset(c90.w);
  float4 sliderKnobs[8] : packoffset(c91);
  float4 sliderButtons[8] : packoffset(c99);
  float playButton : packoffset(c107);
  float stopButton : packoffset(c107.y);
  float rewindButton : packoffset(c107.z);
  float fastForwardButton : packoffset(c107.w);
  float recordButton : packoffset(c108);
  float cycleButton : packoffset(c108.y);
  float trackBackButton : packoffset(c108.z);
  float trackForwardButton : packoffset(c108.w);
  float setButton : packoffset(c109);
  float markerBackButton : packoffset(c109.y);
  float markerForwardButton : packoffset(c109.z);
}

cbuffer ViewportConstantBuffer : register(b2)
{
  float4 viewportSize : packoffset(c0);
}

SamplerState PointSampler_s : register(s0);
Texture2D<float4> tex : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : UV0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xz = float2(0,1);
  r1.x = 0.5 * time;
  r1.yw = float2(0,1000);
  r1.xy = v2.xy * viewportSize.xy + r1.xy;
  r0.w = dot(r1.xy, float2(0.366025418,0.366025418));
  r2.xy = r1.xy + r0.ww;
  r2.xy = floor(r2.xy);
  r2.zw = float2(0.00346020772,0.00346020772) * r2.xy;
  r2.zw = floor(r2.zw);
  r2.zw = -r2.zw * float2(289,289) + r2.xy;
  r1.xy = -r2.xy + r1.xy;
  r0.w = dot(r2.xy, float2(0.211324871,0.211324871));
  r1.xy = r1.xy + r0.ww;
  r0.w = cmp(r1.y < r1.x);
  r3.xyzw = r0.wwww ? float4(1,0,-1,-0) : float4(0,1,-0,-1);
  r0.y = r3.y;
  r0.xyz = r2.www + r0.xyz;
  r2.xyw = r0.xyz * float3(34,34,34) + float3(1,1,1);
  r0.xyz = r2.xyw * r0.xyz;
  r2.xyw = float3(0.00346020772,0.00346020772,0.00346020772) * r0.xyz;
  r2.xyw = floor(r2.xyw);
  r0.xyz = -r2.xyw * float3(289,289,289) + r0.xyz;
  r0.xyz = r0.xyz + r2.zzz;
  r2.xz = float2(0,1);
  r2.y = r3.x;
  r0.xyz = r2.xyz + r0.xyz;
  r2.xyz = r0.xyz * float3(34,34,34) + float3(1,1,1);
  r0.xyz = r2.xyz * r0.xyz;
  r2.xyz = float3(0.00346020772,0.00346020772,0.00346020772) * r0.xyz;
  r2.xyz = floor(r2.xyz);
  r0.xyz = -r2.xyz * float3(289,289,289) + r0.xyz;
  r0.xyz = float3(0.024390243,0.024390243,0.024390243) * r0.xyz;
  r0.xyz = frac(r0.xyz);
  r2.xyz = r0.xyz * float3(2,2,2) + float3(-0.5,-0.5,-0.5);
  r0.xyz = r0.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r2.xyz = floor(r2.xyz);
  r2.xyz = -r2.xyz + r0.xyz;
  r0.xyz = float3(-0.5,-0.5,-0.5) + abs(r0.xyz);
  r4.xyz = r0.xyz * r0.xyz;
  r4.xyz = r2.xyz * r2.xyz + r4.xyz;
  r4.xyz = -r4.xyz * float3(0.853734732,0.853734732,0.853734732) + float3(1.79284286,1.79284286,1.79284286);
  r5.x = dot(r1.xy, r1.xy);
  r6.xyzw = float4(0.211324871,0.211324871,-0.577350259,-0.577350259) + r1.xyxy;
  r6.xy = r6.xy + r3.zw;
  r5.y = dot(r6.xy, r6.xy);
  r5.z = dot(r6.zw, r6.zw);
  r3.xyz = float3(0.5,0.5,0.5) + -r5.xyz;
  r3.xyz = max(float3(0,0,0), r3.xyz);
  r3.xyz = r3.xyz * r3.xyz;
  r3.xyz = r3.xyz * r3.xyz;
  r3.xyz = r3.xyz * r4.xyz;
  r0.x = r0.x * r1.y;
  r0.yz = r6.yw * r0.yz;
  r4.yz = r2.yz * r6.xz + r0.yz;
  r4.x = r2.x * r1.x + r0.x;
  r0.x = dot(r3.xyz, r4.xyz);
  r1.z = time;
  r0.zw = viewportSize.xy * v2.xy;
  r1.xy = r0.zw * float2(0.5,0.5) + r1.zw;
  r2.x = 1000;
  r2.y = 0.200000003 * time;
  r1.xy = r2.xy + r1.xy;
  r1.z = dot(r1.xy, float2(0.366025418,0.366025418));
  r1.zw = r1.xy + r1.zz;
  r1.zw = floor(r1.zw);
  r2.xy = float2(0.00346020772,0.00346020772) * r1.zw;
  r2.xy = floor(r2.xy);
  r2.xy = -r2.xy * float2(289,289) + r1.zw;
  r3.xz = float2(0,1);
  r1.xy = r1.xy + -r1.zw;
  r1.z = dot(r1.zw, float2(0.211324871,0.211324871));
  r1.xy = r1.xy + r1.zz;
  r1.z = cmp(r1.y < r1.x);
  r4.xyzw = r1.zzzz ? float4(1,0,-1,-0) : float4(0,1,-0,-1);
  r3.y = r4.y;
  r2.yzw = r3.xyz + r2.yyy;
  r3.xyz = r2.yzw * float3(34,34,34) + float3(1,1,1);
  r2.yzw = r3.xyz * r2.yzw;
  r3.xyz = float3(0.00346020772,0.00346020772,0.00346020772) * r2.yzw;
  r3.xyz = floor(r3.xyz);
  r2.yzw = -r3.xyz * float3(289,289,289) + r2.yzw;
  r2.xyz = r2.yzw + r2.xxx;
  r3.xz = float2(0,1);
  r3.y = r4.x;
  r2.xyz = r3.xyz + r2.xyz;
  r3.xyz = r2.xyz * float3(34,34,34) + float3(1,1,1);
  r2.xyz = r3.xyz * r2.xyz;
  r3.xyz = float3(0.00346020772,0.00346020772,0.00346020772) * r2.xyz;
  r3.xyz = floor(r3.xyz);
  r2.xyz = -r3.xyz * float3(289,289,289) + r2.xyz;
  r2.xyz = float3(0.024390243,0.024390243,0.024390243) * r2.xyz;
  r2.xyz = frac(r2.xyz);
  r3.xyz = r2.xyz * float3(2,2,2) + float3(-0.5,-0.5,-0.5);
  r2.xyz = r2.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r3.xyz = floor(r3.xyz);
  r3.xyz = -r3.xyz + r2.xyz;
  r2.xyz = float3(-0.5,-0.5,-0.5) + abs(r2.xyz);
  r1.z = r2.x * r1.y;
  r5.x = r3.x * r1.x + r1.z;
  r6.x = dot(r1.xy, r1.xy);
  r1.xyzw = float4(0.211324871,0.211324871,-0.577350259,-0.577350259) + r1.xyxy;
  r6.z = dot(r1.zw, r1.zw);
  r1.xy = r1.xy + r4.zw;
  r6.y = dot(r1.xy, r1.xy);
  r4.xyz = float3(0.5,0.5,0.5) + -r6.xyz;
  r4.xyz = max(float3(0,0,0), r4.xyz);
  r4.xyz = r4.xyz * r4.xyz;
  r4.xyz = r4.xyz * r4.xyz;
  r6.xyz = r2.xyz * r2.xyz;
  r1.yw = r2.yz * r1.yw;
  r5.yz = r3.yz * r1.xz + r1.yw;
  r1.xyz = r3.xyz * r3.xyz + r6.xyz;
  r1.xyz = -r1.xyz * float3(0.853734732,0.853734732,0.853734732) + float3(1.79284286,1.79284286,1.79284286);
  r1.xyz = r4.xyz * r1.xyz;
  r0.y = dot(r1.xyz, r5.xyz);
  r0.xy = -r0.xy * float2(325,325) + r0.zw;
  r0.xy = r0.xy / viewportSize.xy;
  r0.xyz = tex.Sample(PointSampler_s, r0.xy).xyz; // Sample from game
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}