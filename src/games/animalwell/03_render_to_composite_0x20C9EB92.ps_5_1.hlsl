#include "./shared.h"

cbuffer PS_CONSTANT_BUFFER : register(b0) {
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
  }
  boxes[4] : packoffset(c0);

  struct
  {
    float4 s;
  }
  spheres[4] : packoffset(c12);

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
  }
  toruses[4] : packoffset(c16);

  struct
  {
    float4 s;
  }
  bgSpheres[21] : packoffset(c24);

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

SamplerState PointSampler_s : register(s0);
Texture2D<float4> mainWindow : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: COLOR0,
    float2 v2: UV0,
    out float4 o0: SV_TARGET0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.zw = float2(-1, 0.666666687);
  r1.zw = float2(1, -1);
  r2.xyzw = mainWindow.Sample(PointSampler_s, v2.xy).xyzw;
  float4 inputColor = r2.xyzw;
  r2.xyz = log2(abs(r2.xyz));
  o0.w = r2.w;
  r2.xyz = colorGainSaturation.xyz * r2.xyz;
  r2.xyw = exp2(r2.yzx);
  r3.x = cmp(r2.x >= r2.y);
  r3.x = r3.x ? 1.000000 : 0;
  r0.xy = r2.yx;
  r1.xy = r2.xy + -r0.xy;
  r0.xyzw = r3.xxxx * r1.xyzw + r0.xyzw;
  r2.xyz = r0.xyw;
  r1.x = cmp(r2.w >= r2.x);
  r1.x = r1.x ? 1.000000 : 0;
  r0.xyw = r2.wyx;
  r0.xyzw = -r2.xyzw + r0.xyzw;
  r0.xyzw = r1.xxxx * r0.xyzw + r2.xyzw;
  r1.x = min(r0.w, r0.y);
  r1.x = -r1.x + r0.x;
  r1.y = r1.x * 6 + 1.00000001e-10;
  r0.y = r0.w + -r0.y;
  r0.y = r0.y / r1.y;
  r0.y = r0.z + r0.y;
  r0.yzw = abs(r0.yyy) * float3(6, 6, 6) + float3(0, 4, 2);
  r0.yzw = float3(0.166666672, 0.166666672, 0.166666672) * r0.yzw;
  r1.yzw = cmp(r0.yzw >= -r0.yzw);
  r0.yzw = frac(r0.yzw);
  r0.yzw = r1.yzw ? r0.yzw : -r0.yzw;
  r0.yzw = r0.yzw * float3(6, 6, 6) + float3(-3, -3, -3);
  r0.yzw = saturate(float3(-1, -1, -1) + abs(r0.yzw));
  r0.yzw = float3(-1, -1, -1) + r0.yzw;
  r1.y = 1.00000001e-10 + r0.x;
  r1.x = r1.x / r1.y;
  r1.x = colorGainSaturation.w * r1.x;
  r0.yzw = r1.xxx * r0.yzw + float3(1, 1, 1);
  o0.xyz = r0.xxx * r0.yzw;

  o0.rgb = max(o0.rgb, 0);
  // o0.rgb = pow(o0.rgb, 2.2f);
  // o0.rgb *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
  // o0.rgb = pow(o0.rgb, 1.f / 2.2f);
  return;
}
