// ---- Created with 3Dmigoto v1.3.16 on Thu May  9 21:04:04 2024

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
Texture2D<float4> foreground : register(t2);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : UV0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = viewportSize.y * v2.y;
  r0.x = cmp(r0.x < waterLevel);
  if (r0.x != 0) {
    r0.x = foreground.Sample(PointSampler_s, v2.xy).w;
    r0.x = cmp(0.5 < r0.x);
    r0.x = r0.x ? 0.100000001 : 0.0500000007;
    r0.xy = v2.xy * r0.xx;
    r1.xw = float2(-0.314200014,0.219999999) * time;
    r1.yz = float2(0,0);
    r0.xyzw = r0.xyxy * viewportSize.xyxy + r1.xyzw;
    r1.x = dot(r0.xy, float2(0.366025418,0.366025418));
    r1.xy = r1.xx + r0.xy;
    r1.xy = floor(r1.xy);
    r0.xy = -r1.xy + r0.xy;
    r1.z = dot(r1.xy, float2(0.211324871,0.211324871));
    r0.xy = r1.zz + r0.xy;
    r1.z = cmp(r0.y < r0.x);
    r2.xyzw = float4(0.211324871,0.211324871,-0.577350259,-0.577350259) + r0.xyxy;
    r3.xyzw = r1.zzzz ? float4(0,1,-1,-0) : float4(1,0,-0,-1);
    r2.xy = r3.zw + r2.xy;
    r1.zw = float2(0.00346020772,0.00346020772) * r1.xy;
    r1.zw = floor(r1.zw);
    r1.xy = -r1.zw * float2(289,289) + r1.xy;
    r4.xz = float2(0,1);
    r4.y = r3.x;
    r1.yzw = r4.xyz + r1.yyy;
    r4.xyz = r1.yzw * float3(34,34,34) + float3(1,1,1);
    r1.yzw = r4.xyz * r1.yzw;
    r4.xyz = float3(0.00346020772,0.00346020772,0.00346020772) * r1.yzw;
    r4.xyz = floor(r4.xyz);
    r1.yzw = -r4.xyz * float3(289,289,289) + r1.yzw;
    r1.xyz = r1.yzw + r1.xxx;
    r3.xz = float2(0,1);
    r1.xyz = r3.xyz + r1.xyz;
    r3.xyz = r1.xyz * float3(34,34,34) + float3(1,1,1);
    r1.xyz = r3.xyz * r1.xyz;
    r3.xyz = float3(0.00346020772,0.00346020772,0.00346020772) * r1.xyz;
    r3.xyz = floor(r3.xyz);
    r1.xyz = -r3.xyz * float3(289,289,289) + r1.xyz;
    r3.x = dot(r0.xy, r0.xy);
    r3.y = dot(r2.xy, r2.xy);
    r3.z = dot(r2.zw, r2.zw);
    r3.xyz = float3(0.5,0.5,0.5) + -r3.xyz;
    r3.xyz = max(float3(0,0,0), r3.xyz);
    r3.xyz = r3.xyz * r3.xyz;
    r3.xyz = r3.xyz * r3.xyz;
    r1.xyz = float3(0.024390243,0.024390243,0.024390243) * r1.xyz;
    r1.xyz = frac(r1.xyz);
    r4.xyz = r1.xyz * float3(2,2,2) + float3(-1,-1,-1);
    r5.xyz = float3(-0.5,-0.5,-0.5) + abs(r4.xyz);
    r1.xyz = r1.xyz * float3(2,2,2) + float3(-0.5,-0.5,-0.5);
    r1.xyz = floor(r1.xyz);
    r1.xyz = r4.xyz + -r1.xyz;
    r4.xyz = r5.xyz * r5.xyz;
    r4.xyz = r1.xyz * r1.xyz + r4.xyz;
    r4.xyz = -r4.xyz * float3(0.853734732,0.853734732,0.853734732) + float3(1.79284286,1.79284286,1.79284286);
    r3.xyz = r4.xyz * r3.xyz;
    r0.y = r5.x * r0.y;
    r4.x = r1.x * r0.x + r0.y;
    r0.xy = r5.yz * r2.yw;
    r4.yz = r1.yz * r2.xz + r0.xy;
    r0.x = dot(r3.xyz, r4.xyz);
    r0.y = dot(r0.zw, float2(0.366025418,0.366025418));
    r1.xy = r0.zw + r0.yy;
    r1.xy = floor(r1.xy);
    r0.yz = -r1.xy + r0.zw;
    r0.w = dot(r1.xy, float2(0.211324871,0.211324871));
    r0.yz = r0.yz + r0.ww;
    r0.w = cmp(r0.z < r0.y);
    r2.xyzw = float4(0.211324871,0.211324871,-0.577350259,-0.577350259) + r0.yzyz;
    r3.xyzw = r0.wwww ? float4(0,1,-1,-0) : float4(1,0,-0,-1);
    r2.xy = r3.zw + r2.xy;
    r1.zw = float2(0.00346020772,0.00346020772) * r1.xy;
    r1.zw = floor(r1.zw);
    r1.xy = -r1.zw * float2(289,289) + r1.xy;
    r4.xz = float2(0,1);
    r4.y = r3.x;
    r1.yzw = r4.xyz + r1.yyy;
    r4.xyz = r1.yzw * float3(34,34,34) + float3(1,1,1);
    r1.yzw = r4.xyz * r1.yzw;
    r4.xyz = float3(0.00346020772,0.00346020772,0.00346020772) * r1.yzw;
    r4.xyz = floor(r4.xyz);
    r1.yzw = -r4.xyz * float3(289,289,289) + r1.yzw;
    r1.xyz = r1.yzw + r1.xxx;
    r3.xz = float2(0,1);
    r1.xyz = r3.xyz + r1.xyz;
    r3.xyz = r1.xyz * float3(34,34,34) + float3(1,1,1);
    r1.xyz = r3.xyz * r1.xyz;
    r3.xyz = float3(0.00346020772,0.00346020772,0.00346020772) * r1.xyz;
    r3.xyz = floor(r3.xyz);
    r1.xyz = -r3.xyz * float3(289,289,289) + r1.xyz;
    r3.x = dot(r0.yz, r0.yz);
    r3.y = dot(r2.xy, r2.xy);
    r3.z = dot(r2.zw, r2.zw);
    r3.xyz = float3(0.5,0.5,0.5) + -r3.xyz;
    r3.xyz = max(float3(0,0,0), r3.xyz);
    r3.xyz = r3.xyz * r3.xyz;
    r3.xyz = r3.xyz * r3.xyz;
    r1.xyz = float3(0.024390243,0.024390243,0.024390243) * r1.xyz;
    r1.xyz = frac(r1.xyz);
    r4.xyz = r1.xyz * float3(2,2,2) + float3(-1,-1,-1);
    r5.xyz = float3(-0.5,-0.5,-0.5) + abs(r4.xyz);
    r1.xyz = r1.xyz * float3(2,2,2) + float3(-0.5,-0.5,-0.5);
    r1.xyz = floor(r1.xyz);
    r1.xyz = r4.xyz + -r1.xyz;
    r4.xyz = r5.xyz * r5.xyz;
    r4.xyz = r1.xyz * r1.xyz + r4.xyz;
    r4.xyz = -r4.xyz * float3(0.853734732,0.853734732,0.853734732) + float3(1.79284286,1.79284286,1.79284286);
    r3.xyz = r4.xyz * r3.xyz;
    r0.z = r5.x * r0.z;
    r4.x = r1.x * r0.y + r0.z;
    r0.yz = r5.yz * r2.yw;
    r4.yz = r1.yz * r2.xz + r0.yz;
    r0.y = dot(r3.xyz, r4.xyz);
    r0.y = 130 * r0.y;
    r0.x = r0.x * 130 + r0.y;
    r0.x = 0.800000012 + -abs(r0.x);
    r0.x = saturate(1.66666663 * r0.x);
    r0.y = r0.x * -2 + 3;
    r0.x = r0.x * r0.x;
    r0.x = dot(r0.yy, r0.xx);
    r0.x = floor(r0.x);
    r0.x = 0.5 * r0.x;
    r0.y = -v2.y * viewportSize.y + waterLevel;
    r0.y = saturate(0.00999999978 * r0.y);
    r0.y = 1 + -r0.y;
    r0.x = r0.x * r0.y;
    r0.yzw = min(float3(0.150000006,0.150000006,0.150000006), ambientLightColor.xyz);
    r0.xyz = r0.xxx * r0.yzw;
    o0.xyz = max(float3(0,0,0), r0.xyz);
    o0.w = 1;
    return;
  } else {
    o0.xyzw = float4(0,0,0,0);
    return;
  }
  return;
}