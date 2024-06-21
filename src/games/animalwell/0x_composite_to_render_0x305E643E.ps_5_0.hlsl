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
Texture2D<float4> tex : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : UV0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = v2.y * viewportSize.y + -waterLevel;
  r0.x = saturate(0.0166666675 * r0.x);
  r0.x = 1 + -r0.x;
  r0.y = -v2.y * viewportSize.y + waterLevel;
  r0.y = 0.00039999999 * r0.y;
  r0.z = viewportSize.y * v2.y;
  r0.w = waterLevel * 2 + -r0.z;
  r0.z = cmp(waterLevel < r0.z);
  r1.y = r0.w / viewportSize.y;
  r0.w = r1.y * 200 + time;
  r0.w = v2.x * 63 + r0.w;
  r0.w = sin(r0.w);
  r1.x = r0.y * r0.w + v2.x;
  r0.yw = r0.zz ? r1.xy : v2.xy;
  r1.xyzw = tex.Sample(PointSampler_s, r0.yw).xyzw;
  r0.xyw = r1.xyz * r0.xxx;
  r0.xyw = float3(0.5,0.5,0.699999988) * r0.xyw;
  o0.xyz = r0.zzz ? r0.xyw : r1.xyz;
  o0.w = r1.w;
  return;
}