// ---- Created with 3Dmigoto v1.4.1 on Mon Mar 10 23:24:01 2025

cbuffer rage_globals : register(b5)
{
  float4 globalScalars : packoffset(c0);
  float4 globalScalars2 : packoffset(c1);
  float4 globalScalars3 : packoffset(c2);
  float4 globalScalars4 : packoffset(c3);
  float4 globalFogParams : packoffset(c4);
  float4 globalFogColor : packoffset(c5);
  float4 globalFogOffsetN : packoffset(c6);
  float4 globalFogColorN : packoffset(c7);
  float4 globalScreenSize : packoffset(c8);
  float4 globalDayNightEffects : packoffset(c9);
  float4 ColorCorrectTopAndPedReflectScale : packoffset(c10);
  float4 ColorCorrectBottomOffset : packoffset(c11);
  float4 ColorShift : packoffset(c12);
  float4 deSatContrastGamma : packoffset(c13);
  float4 deSatContrastGammaIFX : packoffset(c14);
  float4 colorize : packoffset(c15);
  float4 globalUmScalars : packoffset(c16);
  float4 gToneMapScalers : packoffset(c17);
  float4 gAmbientOcclusionEffect : packoffset(c18);
  float4 gWaterGlobals : packoffset(c19);
  float4 ColorCorrectTopScreenEdge : packoffset(c20);
  float4 ColorCorrectBottomOffsetScreenEdge : packoffset(c21);
  float4 gScreenSpaceTessFactors : packoffset(c22);
  float4 gTessFactors : packoffset(c23);
  float4 gFrustumPlaneEquation_Left : packoffset(c24);
  float4 gFrustumPlaneEquation_Right : packoffset(c25);
  float4 gFrustumPlaneEquation_Top : packoffset(c26);
  float4 gFrustumPlaneEquation_Bottom : packoffset(c27);
  float4 gTessParameters : packoffset(c28);
}

SamplerState BackBufferSampler_s : register(s0);
Texture2D<float4> BackBuffer : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = BackBuffer.SampleLevel(BackBufferSampler_s, v1.xy, 0).xyzw;
  r1.xyz = BackBuffer.Gather(BackBufferSampler_s, v1.xy).xyz;
  r2.xyz = BackBuffer.Gather(BackBufferSampler_s, v1.xy, int2(-1, -1)).xzw;
  r1.w = max(r1.x, r0.w);
  r2.w = min(r1.x, r0.w);
  r1.w = max(r1.z, r1.w);
  r2.w = min(r2.w, r1.z);
  r3.x = max(r2.y, r2.x);
  r3.y = min(r2.y, r2.x);
  r1.w = max(r3.x, r1.w);
  r2.w = min(r3.y, r2.w);
  r3.x = 0.165999994 * r1.w;
  r1.w = -r2.w + r1.w;
  r2.w = max(0.0833000019, r3.x);
  r2.w = cmp(r1.w >= r2.w);
  if (r2.w != 0) {
    r2.w = BackBuffer.SampleLevel(BackBufferSampler_s, v1.xy, 0, int2(1, -1)).w;
    r3.x = BackBuffer.SampleLevel(BackBufferSampler_s, v1.xy, 0, int2(-1, 1)).w;
    r3.yz = r2.yx + r1.xz;
    r1.w = 1 / r1.w;
    r3.w = r3.y + r3.z;
    r3.yz = r0.ww * float2(-2,-2) + r3.yz;
    r4.x = r2.w + r1.y;
    r2.w = r2.z + r2.w;
    r4.y = r1.z * -2 + r4.x;
    r2.w = r2.y * -2 + r2.w;
    r2.z = r3.x + r2.z;
    r1.y = r3.x + r1.y;
    r3.x = abs(r3.y) * 2 + abs(r4.y);
    r2.w = abs(r3.z) * 2 + abs(r2.w);
    r3.y = r2.x * -2 + r2.z;
    r1.y = r1.x * -2 + r1.y;
    r3.x = abs(r3.y) + r3.x;
    r1.y = abs(r1.y) + r2.w;
    r2.z = r2.z + r4.x;
    r1.y = cmp(r3.x >= r1.y);
    r2.z = r3.w * 2 + r2.z;
    r2.x = r1.y ? r2.y : r2.x;
    r1.x = r1.y ? r1.x : r1.z;
    r1.z = r1.y ? globalScreenSize.w : globalScreenSize.z;
    r2.y = r2.z * 0.0833333358 + -r0.w;
    r2.z = r2.x + -r0.w;
    r2.w = r1.x + -r0.w;
    r2.x = r2.x + r0.w;
    r1.x = r1.x + r0.w;
    r3.x = cmp(abs(r2.z) >= abs(r2.w));
    r2.z = max(abs(r2.z), abs(r2.w));
    r1.z = r3.x ? -r1.z : r1.z;
    r1.w = saturate(abs(r2.y) * r1.w);
    r2.y = r1.y ? globalScreenSize.z : 0;
    r2.w = r1.y ? 0 : globalScreenSize.w;
    r3.yz = r1.zz * float2(0.5,0.5) + v1.xy;
    r3.y = r1.y ? v1.x : r3.y;
    r3.z = r1.y ? r3.z : v1.y;
    r4.xy = r3.yz + -r2.yw;
    r5.xy = r3.yz + r2.yw;
    r3.y = r1.w * -2 + 3;
    r3.z = BackBuffer.SampleLevel(BackBufferSampler_s, r4.xy, 0).w;
    r1.w = r1.w * r1.w;
    r3.w = BackBuffer.SampleLevel(BackBufferSampler_s, r5.xy, 0).w;
    r1.x = r3.x ? r2.x : r1.x;
    r2.x = 0.25 * r2.z;
    r2.z = -r1.x * 0.5 + r0.w;
    r1.w = r3.y * r1.w;
    r2.z = cmp(r2.z < 0);
    r3.x = -r1.x * 0.5 + r3.z;
    r3.y = -r1.x * 0.5 + r3.w;
    r3.zw = cmp(abs(r3.xy) >= r2.xx);
    r4.z = -r2.y * 1.5 + r4.x;
    r4.x = r3.z ? r4.x : r4.z;
    r4.w = -r2.w * 1.5 + r4.y;
    r4.z = r3.z ? r4.y : r4.w;
    r4.yw = ~(int2)r3.zw;
    r4.y = (int)r4.w | (int)r4.y;
    r4.w = r2.y * 1.5 + r5.x;
    r5.x = r3.w ? r5.x : r4.w;
    r4.w = r2.w * 1.5 + r5.y;
    r5.z = r3.w ? r5.y : r4.w;
    if (r4.y != 0) {
      if (r3.z == 0) {
        r3.x = BackBuffer.SampleLevel(BackBufferSampler_s, r4.xz, 0).w;
      }
      if (r3.w == 0) {
        r3.y = BackBuffer.SampleLevel(BackBufferSampler_s, r5.xz, 0).w;
      }
      r4.y = -r1.x * 0.5 + r3.x;
      r3.x = r3.z ? r3.x : r4.y;
      r3.z = -r1.x * 0.5 + r3.y;
      r3.y = r3.w ? r3.y : r3.z;
      r3.zw = cmp(abs(r3.xy) >= r2.xx);
      r4.y = -r2.y * 2 + r4.x;
      r4.x = r3.z ? r4.x : r4.y;
      r4.y = -r2.w * 2 + r4.z;
      r4.z = r3.z ? r4.z : r4.y;
      r4.yw = ~(int2)r3.zw;
      r4.y = (int)r4.w | (int)r4.y;
      r4.w = r2.y * 2 + r5.x;
      r5.x = r3.w ? r5.x : r4.w;
      r4.w = r2.w * 2 + r5.z;
      r5.z = r3.w ? r5.z : r4.w;
      if (r4.y != 0) {
        if (r3.z == 0) {
          r3.x = BackBuffer.SampleLevel(BackBufferSampler_s, r4.xz, 0).w;
        }
        if (r3.w == 0) {
          r3.y = BackBuffer.SampleLevel(BackBufferSampler_s, r5.xz, 0).w;
        }
        r4.y = -r1.x * 0.5 + r3.x;
        r3.x = r3.z ? r3.x : r4.y;
        r3.z = -r1.x * 0.5 + r3.y;
        r3.y = r3.w ? r3.y : r3.z;
        r3.zw = cmp(abs(r3.xy) >= r2.xx);
        r4.y = -r2.y * 2 + r4.x;
        r4.x = r3.z ? r4.x : r4.y;
        r4.y = -r2.w * 2 + r4.z;
        r4.z = r3.z ? r4.z : r4.y;
        r4.yw = ~(int2)r3.zw;
        r4.y = (int)r4.w | (int)r4.y;
        r4.w = r2.y * 2 + r5.x;
        r5.x = r3.w ? r5.x : r4.w;
        r4.w = r2.w * 2 + r5.z;
        r5.z = r3.w ? r5.z : r4.w;
        if (r4.y != 0) {
          if (r3.z == 0) {
            r3.x = BackBuffer.SampleLevel(BackBufferSampler_s, r4.xz, 0).w;
          }
          if (r3.w == 0) {
            r3.y = BackBuffer.SampleLevel(BackBufferSampler_s, r5.xz, 0).w;
          }
          r4.y = -r1.x * 0.5 + r3.x;
          r3.x = r3.z ? r3.x : r4.y;
          r3.z = -r1.x * 0.5 + r3.y;
          r3.y = r3.w ? r3.y : r3.z;
          r3.zw = cmp(abs(r3.xy) >= r2.xx);
          r4.y = -r2.y * 2 + r4.x;
          r4.x = r3.z ? r4.x : r4.y;
          r4.y = -r2.w * 2 + r4.z;
          r4.z = r3.z ? r4.z : r4.y;
          r4.yw = ~(int2)r3.zw;
          r4.y = (int)r4.w | (int)r4.y;
          r4.w = r2.y * 2 + r5.x;
          r5.x = r3.w ? r5.x : r4.w;
          r4.w = r2.w * 2 + r5.z;
          r5.z = r3.w ? r5.z : r4.w;
          if (r4.y != 0) {
            if (r3.z == 0) {
              r3.x = BackBuffer.SampleLevel(BackBufferSampler_s, r4.xz, 0).w;
            }
            if (r3.w == 0) {
              r3.y = BackBuffer.SampleLevel(BackBufferSampler_s, r5.xz, 0).w;
            }
            r4.y = -r1.x * 0.5 + r3.x;
            r3.x = r3.z ? r3.x : r4.y;
            r1.x = -r1.x * 0.5 + r3.y;
            r3.y = r3.w ? r3.y : r1.x;
            r3.zw = cmp(abs(r3.xy) >= r2.xx);
            r1.x = -r2.y * 8 + r4.x;
            r4.x = r3.z ? r4.x : r1.x;
            r1.x = -r2.w * 8 + r4.z;
            r4.z = r3.z ? r4.z : r1.x;
            r1.x = r2.y * 8 + r5.x;
            r5.x = r3.w ? r5.x : r1.x;
            r1.x = r2.w * 8 + r5.z;
            r5.z = r3.w ? r5.z : r1.x;
          }
        }
      }
    }
    r1.x = v1.x + -r4.x;
    r2.y = v1.y + -r4.z;
    r1.x = r1.y ? r1.x : r2.y;
    r2.xy = -v1.xy + r5.xz;
    r2.x = r1.y ? r2.x : r2.y;
    r2.yw = cmp(r3.xy < float2(0,0));
    r3.x = r2.x + r1.x;
    r2.yz = cmp((int2)r2.yw != (int2)r2.zz);
    r2.w = 1 / r3.x;
    r3.x = cmp(r1.x < r2.x);
    r1.x = min(r2.x, r1.x);
    r2.x = r3.x ? r2.y : r2.z;
    r1.w = r1.w * r1.w;
    r1.x = r1.x * -r2.w + 0.5;
    r1.w = 0.75 * r1.w;
    r1.x = (int)r1.x & (int)r2.x;
    r1.x = max(r1.x, r1.w);
    r1.xz = r1.xx * r1.zz + v1.xy;
    r2.x = r1.y ? v1.x : r1.x;
    r2.y = r1.y ? r1.z : v1.y;
    r0.xyz = BackBuffer.SampleLevel(BackBufferSampler_s, r2.xy, 0).xyz;
  }
  o0.xyzw = (r0.xyzw);  // remove saturate()
  o0.w = saturate(o0.w);
  return;
}