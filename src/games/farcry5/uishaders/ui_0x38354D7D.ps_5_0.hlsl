#include "../shared.h"

cbuffer CGlobalShaderParameterProvider : register(b0) {
  float4 BurnColor : packoffset(c0);
  float4 BurnParams : packoffset(c1);
  float4 BurnParams2 : packoffset(c2);
  float4 BurnParams3 : packoffset(c3);
  float4 BurnParams4 : packoffset(c4);
  float4 BurnParams5 : packoffset(c5);
  float4 CascadedShadowScaleOffsetTile0 : packoffset(c6);
  float4 CascadedShadowScaleOffsetTile1 : packoffset(c7);
  float4 WindSimParams : packoffset(c8);
  float4 WindDirection : packoffset(c9);
  float4 PrevWindSimParams : packoffset(c10);
  float4 PrevWindDirection : packoffset(c11);
  float Time : packoffset(c12);
  float Time_Previous : packoffset(c12.y);
  float UITime : packoffset(c12.z);
  float NormalizedTimeOfDay : packoffset(c12.w);
  float FireGlowEV : packoffset(c13);
  float BurnSpeedScale : packoffset(c13.y);
  float BurnlineMaskScale : packoffset(c13.z);
  float BurnlineMaskInfluence : packoffset(c13.w);
  float WorldSpaceProgressionMaskScale : packoffset(c14);
  float WorldSpaceProgressionMaskInfluence : packoffset(c14.y);
  float MaskTransitionSpeedModifier : packoffset(c14.z);
  float GlowMaskScale : packoffset(c14.w);
  float FireGlowMaskInfluence : packoffset(c15);
  float CenterBurnlineWidth : packoffset(c15.y);
  float TransitionToBurnlineWidth : packoffset(c15.z);
  float DissolveCutoffPoint : packoffset(c15.w);
  float DissolveBlendDistance : packoffset(c16);
  float WetnessFactor : packoffset(c16.y);
  float DirtFactor : packoffset(c16.z);
  float IronSightFactor : packoffset(c16.w);
  float3 DeprecatedShaderColor : packoffset(c17);
  float HDRReferenceWhiteNits : packoffset(c17.w);
  bool SCRGB : packoffset(c18);
  bool Isolate0 : packoffset(c18.y);
  bool Isolate1 : packoffset(c18.z);
  bool Isolate2 : packoffset(c18.w);
  bool Isolate3 : packoffset(c19);
}

cbuffer CSceneFireUiPrimitiveParameterProvider : register(b1) {
  float DistanceFieldFloatArray[12] : packoffset(c0);
  float BordersSizeFloatArray[8] : packoffset(c12);
  float4x4 Transform : packoffset(c20);
  float4x4 UVTransform : packoffset(c24);
  float4 BinkUVTransforms : packoffset(c28);
  float4 BackgroundColor : packoffset(c29);
  float4 BordersColor : packoffset(c30);
  float4 ColorAdd : packoffset(c31);
  float4 ColorAdjustment : packoffset(c32);
  float4 ColorMultiplier : packoffset(c33);
  float4 ColorTransparent : packoffset(c34);
  float4 ScissorRect : packoffset(c35);
  float2 ViewportScaleXY : packoffset(c36);
  float TextureAddress : packoffset(c36.z);
  float Desaturation : packoffset(c36.w);
  float LinePercentage : packoffset(c37);
  float TexHeight : packoffset(c37.y);
  float TexRatio : packoffset(c37.z);
  float TextWidth : packoffset(c37.w);
  float PrimGroupTime : packoffset(c38);
  float UIHDRValue : packoffset(c38.y);
  float UIModeEx : packoffset(c38.z);
}

SamplerState Wrap_s : register(s0);
SamplerState Clamp_s : register(s1);
SamplerState Mirror_s : register(s2);
Texture2D<float4> DiffuseSampler0 : register(t0);
Texture2D<float4> ASampler : register(t1);

// 3Dmigoto declarations
#define cmp -

float3 ApplyUserColorGrading(float3 ungraded_ap1) {
  return renodx::color::ap1::from::BT709(
      renodx::color::grade::UserColorGrading(
          renodx::color::bt709::from::AP1(ungraded_ap1),
          RENODX_TONE_MAP_EXPOSURE,
          RENODX_TONE_MAP_HIGHLIGHTS,
          RENODX_TONE_MAP_SHADOWS,
          RENODX_TONE_MAP_CONTRAST,
          RENODX_TONE_MAP_SATURATION,
          RENODX_TONE_MAP_BLOWOUT,
          0.f));
}

float3 TonemapByLuminance(float3 untonemapped_ap1) {
  float y = renodx::color::y::from::AP1(untonemapped_ap1);

  float num = y * (y + 0.0206166003f);
  // num -= 7.45694997e-05f; // remove black clip
  float denom = y * (0.983796f * y + 0.433679014f) + 0.246179f;
  float y_mapped = num / denom;

  float scale = y > 0 ? y_mapped / y : 0;

  float3 tonemapped_ap1 = untonemapped_ap1 * scale;

  float3 tonemapped_bt709 = renodx::color::bt709::from::AP1(tonemapped_ap1);
  tonemapped_bt709 = renodx::color::grade::Saturation(tonemapped_bt709, 1.3f);
  tonemapped_ap1 = renodx::color::ap1::from::BT709(tonemapped_bt709);

  float blend_brightness_ratio = 0.613478879269;
  float tonemapped_y = renodx::color::y::from::AP1(tonemapped_ap1);
  tonemapped_ap1 = lerp(tonemapped_ap1, untonemapped_ap1 * blend_brightness_ratio, saturate(tonemapped_y));
  tonemapped_ap1 = ApplyUserColorGrading(tonemapped_ap1);

  return tonemapped_ap1;
}

void main(
    float4 v0: SV_Position0,
    float4 v1: TEXCOORD0,
    float4 v2: TEXCOORD1,
    uint v3: SV_IsFrontFace0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = -ScissorRect.xy + v0.xy;
  r0.zw = ScissorRect.zw + -v0.xy;
  r0.xy = min(r0.xy, r0.zw);
  r0.x = min(r0.x, r0.y);
  r0.x = cmp(r0.x < 0);
  if (r0.x != 0) discard;
  r0.x = cmp(TextureAddress == 3.000000);
  if (r0.x != 0) {
    r0.xyzw = DiffuseSampler0.Sample(Clamp_s, v2.zw).xyzw;
  } else {
    r1.x = cmp(TextureAddress == 2.000000);
    if (r1.x != 0) {
      r0.xyzw = DiffuseSampler0.Sample(Mirror_s, v2.zw).xyzw;
    } else {
      r0.xyzw = DiffuseSampler0.Sample(Wrap_s, v2.zw).xyzw;
    }
  }
  r1.x = cmp(UIModeEx == 1.000000);
  if (r1.x != 0) {
    r1.xy = TextWidth * v2.zw;
    r1.z = cmp(0.100000001 < BordersSizeFloatArray[0]);
    r1.w = cmp(0.100000001 < BordersSizeFloatArray[4]);
    r2.x = cmp(0.100000001 < BordersSizeFloatArray[3]);
    r2.y = cmp(0.100000001 < BordersSizeFloatArray[7]);
    r2.z = cmp(r1.x < BordersSizeFloatArray[0]);
    r2.w = cmp(r1.y < BordersSizeFloatArray[1]);
    r2.z = r2.w ? r2.z : 0;
    r2.z = r1.z ? r2.z : 0;
    r2.w = cmp(r1.x < BordersSizeFloatArray[2]);
    r3.x = cmp(r1.y < BordersSizeFloatArray[3]);
    r2.w = r2.w ? r3.x : 0;
    r2.w = r2.w ? r2.x : 0;
    r3.x = cmp(BordersSizeFloatArray[4] < r1.x);
    r3.y = cmp(r1.y < BordersSizeFloatArray[5]);
    r3.x = r3.y ? r3.x : 0;
    r3.yz = cmp(r1.xy < TextWidth);
    r3.x = r3.y ? r3.x : 0;
    r3.x = r1.w ? r3.x : 0;
    r3.y = cmp(r1.x < BordersSizeFloatArray[6]);
    r3.w = cmp(BordersSizeFloatArray[7] < r1.y);
    r3.y = r3.w ? r3.y : 0;
    r3.y = r3.z ? r3.y : 0;
    r3.y = r2.y ? r3.y : 0;
    r3.z = (int)r2.w | (int)r2.z;
    r3.z = (int)r3.x | (int)r3.z;
    r3.z = (int)r3.y | (int)r3.z;
    if (r3.z != 0) {
      r3.z = cmp(0 < PrimGroupTime);
      r3.w = TextWidth + TexHeight;
      r4.x = r3.w + r3.w;
      r4.y = PrimGroupTime + r3.w;
      r4.x = cmp(r4.x < r4.y);
      r4.z = -r3.w * 2 + r4.y;
      r4.x = r4.x ? r4.z : r4.y;
      r1.y = r1.x + r1.y;
      r4.z = (int)r2.w | (int)r3.x;
      r3.w = r3.w * 2 + -r1.y;
      r1.y = r4.z ? r3.w : r1.y;
      r3.w = cmp(PrimGroupTime < r1.y);
      r4.yz = cmp(r1.yy < r4.yx);
      r3.w = r3.w ? r4.y : 0;
      r4.y = cmp(r4.x < PrimGroupTime);
      r4.y = r4.z ? r4.y : 0;
      r3.w = ~(int)r3.w;
      r4.y = ~(int)r4.y;
      r3.w = r3.w ? r4.y : 0;
      r4.y = -PrimGroupTime + r1.y;
      r1.y = r1.y + -r4.x;
      r4.x = cmp(abs(r4.y) < 20);
      r1.y = cmp(abs(r1.y) < 20);
      r1.y = (int)r1.y | (int)r4.x;
      r4.xy = float2(0.5, 0.75) * BordersColor.ww;
      r1.y = r1.y ? r4.y : BordersColor.w;
      r1.y = r3.w ? r4.x : r1.y;
      r1.y = r3.z ? r1.y : BordersColor.w;
      r3.zw = ~(int2)r1.zw;
      r3.z = (int)r3.w | (int)r3.z;
      r3.w = (int)r2.w | (int)r3.y;
      r4.x = cmp(LinePercentage >= 0);
      r3.w = r3.w ? r4.x : 0;
      r4.x = TextWidth + -LinePercentage;
      r1.x = cmp(r4.x < r1.x);
      r1.x = r1.x ? r3.w : 0;
      r1.x = r1.x ? 0.400000006 : 1;
      r1.x = r3.z ? r1.x : r1.y;
      r1.y = ~(int)r2.z;
      r2.z = ~(int)r3.x;
      r1.y = r2.z ? r1.y : 0;
      r3.xz = cmp(v2.zw < float2(0.5, 0.5));
      r2.z = 0.0700000003 / TexRatio;
      r3.w = 1 / r2.z;
      r4.xy = saturate(v2.zw * r3.ww);
      r4.zw = r4.xy * float2(-2, -2) + float2(3, 3);
      r4.xy = r4.xy * r4.xy;
      r4.xy = r4.zw * r4.xy;
      r3.w = r4.x * r1.x;
      r1.z = r1.z ? r1.x : r3.w;
      r2.z = 1 + -r2.z;
      r3.w = 1 + -r2.z;
      r4.xz = v2.zw + -r2.zz;
      r2.z = 1 / r3.w;
      r4.xz = saturate(r4.xz * r2.zz);
      r5.xy = r4.xz * float2(-2, -2) + float2(3, 3);
      r4.xz = r4.xz * r4.xz;
      r4.xz = -r5.xy * r4.xz + float2(1, 1);
      r2.z = r4.x * r1.x;
      r1.w = r1.w ? r1.x : r2.z;
      r1.z = r3.x ? r1.z : r1.w;
      r1.x = r1.y ? r1.z : r1.x;
      r1.y = ~(int)r2.w;
      r1.z = ~(int)r3.y;
      r1.y = (int)r1.z & (int)r1.y;
      r1.zw = r1.xx * r4.yz;
      r1.zw = r2.xy ? r1.xx : r1.zw;
      r1.z = r3.z ? r1.z : r1.w;
      r1.w = r1.y ? r1.z : r1.x;
      r2.xyz = BordersColor.xyz;
    } else {
      r3.xy = cmp(v2.zw < float2(0.5, 0.5));
      r3.z = cmp(0.100000001 >= BordersSizeFloatArray[0]);
      r3.w = 0.0700000003 / TexRatio;
      r4.x = 1 / r3.w;
      r4.x = saturate(v2.z * r4.x);
      r4.y = r4.x * -2 + 3;
      r4.x = r4.x * r4.x;
      r4.x = r4.y * r4.x;
      r3.z = r3.z ? r4.x : 1;
      r4.x = cmp(0.100000001 >= BordersSizeFloatArray[4]);
      r3.w = 1 + -r3.w;
      r4.y = 1 + -r3.w;
      r3.w = v2.z + -r3.w;
      r4.y = 1 / r4.y;
      r3.w = saturate(r4.y * r3.w);
      r4.y = r3.w * -2 + 3;
      r3.w = r3.w * r3.w;
      r3.w = -r4.y * r3.w + 1;
      r3.w = r4.x ? r3.w : 1;
      r3.x = r3.x ? r3.z : r3.w;
      r3.z = cmp(0.100000001 >= BordersSizeFloatArray[3]);
      r3.w = saturate(14.2857141 * v2.w);
      r4.x = r3.w * -2 + 3;
      r3.w = r3.w * r3.w;
      r3.w = r4.x * r3.w;
      r3.w = r3.x * r3.w;
      r3.z = r3.z ? r3.w : r3.x;
      r3.w = cmp(0.100000001 >= BordersSizeFloatArray[7]);
      r4.x = -0.930000007 + v2.w;
      r4.x = saturate(14.2857161 * r4.x);
      r4.y = r4.x * -2 + 3;
      r4.x = r4.x * r4.x;
      r4.x = -r4.y * r4.x + 1;
      r4.x = r4.x * r3.x;
      r3.x = r3.w ? r4.x : r3.x;
      r3.x = r3.y ? r3.z : r3.x;
      r1.w = BackgroundColor.w * r3.x;
      r2.xyz = BackgroundColor.xyz;
    }
  } else {
    r3.x = cmp(UIModeEx == 2.000000);
    if (r3.x != 0) {
      r2.xyzw = ASampler.Sample(Wrap_s, v2.zw).xyzw;
      r1.w = 0.899999976 * r2.w;
    } else {
      r3.xyz = cmp(float3(0.00313080009, 0.00313080009, 0.00313080009) >= r0.xyz);
      r4.xyz = float3(12.9200001, 12.9200001, 12.9200001) * r0.xyz;
      r5.xyz = log2(abs(r0.xyz));
      r5.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r5.xyz;
      r5.xyz = exp2(r5.xyz);
      r5.xyz = r5.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
      r0.xyz = r3.xyz ? r4.xyz : r5.xyz;
      r3.xyzw = v1.xyzw * r0.xyzw;
      r0.xyz = cmp(float3(0.0404499993, 0.0404499993, 0.0404499993) >= r3.xyz);
      r4.xyz = float3(0.0773993805, 0.0773993805, 0.0773993805) * r3.xyz;
      r5.xyz = float3(0.0549999997, 0.0549999997, 0.0549999997) + abs(r3.xyz);
      r5.xyz = float3(0.947867334, 0.947867334, 0.947867334) * r5.xyz;
      r5.xyz = log2(r5.xyz);
      r5.xyz = float3(2.4000001, 2.4000001, 2.4000001) * r5.xyz;
      r5.xyz = exp2(r5.xyz);
      r0.xyz = r0.xyz ? r4.xyz : r5.xyz;
      r2.w = dot(r0.xyz, float3(0.298999995, 0.587000012, 0.114));
      r4.xyz = r2.www + -r0.xyz;
      r3.xyz = Desaturation * r4.xyz + r0.xyz;
      r4.xyzw = ColorMultiplier.xyzw * r3.xyzw;
      r0.x = cmp(0 < r0.w);
      r3.xyzw = r3.xyzw * ColorMultiplier.xyzw + ColorAdd.xyzw;
      r1.xyzw = r0.xxxx ? r3.xyzw : r4.xyzw;
      r0.x = -1 + r1.w;
      r0.x = ColorTransparent.w * r0.x + 1;
      r0.yzw = -ColorTransparent.xyz + r1.xyz;
      r2.xyz = r0.xxx * r0.yzw + ColorTransparent.xyz;
      r0.x = cmp(UIModeEx == 3.000000);
      if (r0.x != 0) {
        r2.z = dot(r2.xyz, float3(0.212599993, 0.715200007, 0.0722000003));
        r2.xyz = r2.zzz;
      } else {
        r0.x = cmp(UIModeEx == 5.000000);
        if (r0.x != 0) {
          if (RENODX_TONE_MAP_TYPE == 0.f) {
            r0.x = 89.6254959 * UIHDRValue;
            r0.y = UIHDRValue * 0.152480766 + -0.103982367;
            r0.z = -UIHDRValue * 0.0260881726 + 93.2124939;
            r3.xyz = log2(abs(r2.xyz));
            r4.xyz = float3(1.32000005, 1.32000005, 1.32000005) * r3.xyz;
            r4.xyz = exp2(r4.xyz);
            r4.xyz = r4.xyz * r0.xxx;
            r3.xyz = float3(1.02960002, 1.02960002, 1.02960002) * r3.xyz;
            r3.xyz = exp2(r3.xyz);
            r0.xyz = r3.xyz * r0.yyy + r0.zzz;
            r0.xyz = r4.xyz / r0.xyz;
            r2.xyz = r0.xyz / HDRReferenceWhiteNits;
          } else if (RENODX_TONE_MAP_TYPE == 2.f) {
            r2.rgb = TonemapByLuminance(r2.xyz);
          } else {
            r2.rgb = ApplyUserColorGrading(r2.rgb);
          }
        } else {
          r0.x = cmp(UIModeEx == 4.000000);
          if (r0.x != 0) {
            r0.xyz = ColorMultiplier.xyz + ColorAdd.xyz;
            r3.xy = DiffuseSampler0.Sample(Wrap_s, v2.zw).xw;
            r0.w = r3.y * r3.x;
            r2.w = -DistanceFieldFloatArray[3] + DistanceFieldFloatArray[2];
            r3.z = DistanceFieldFloatArray[3] + DistanceFieldFloatArray[2];
            r3.z = r3.z + -r2.w;
            r2.w = r3.y * r3.x + -r2.w;
            r3.z = 1 / r3.z;
            r2.w = saturate(r3.z * r2.w);
            r3.z = r2.w * -2 + 3;
            r2.w = r2.w * r2.w;
            r2.w = r3.z * r2.w;
            r3.z = cmp(DistanceFieldFloatArray[2] < DistanceFieldFloatArray[0]);
            r3.z = r3.z ? 1.000000 : 0;
            r2.w = r3.z * r2.w;
            r2.w = 0.699999988 * r2.w;
            r3.w = DistanceFieldFloatArray[5] + DistanceFieldFloatArray[4];
            r4.x = -DistanceFieldFloatArray[5] + DistanceFieldFloatArray[4];
            r4.x = r4.x + -r3.w;
            r3.w = r3.y * r3.x + -r3.w;
            r4.x = 1 / r4.x;
            r3.w = saturate(r4.x * r3.w);
            r4.x = r3.w * -2 + 3;
            r3.w = r3.w * r3.w;
            r3.w = r4.x * r3.w;
            r4.x = cmp(DistanceFieldFloatArray[4] >= DistanceFieldFloatArray[0]);
            r4.x = r4.x ? 1.000000 : 0;
            r3.w = r4.x * r3.w;
            r4.x = -DistanceFieldFloatArray[1] + DistanceFieldFloatArray[0];
            r4.y = DistanceFieldFloatArray[1] + DistanceFieldFloatArray[0];
            r4.y = r4.y + -r4.x;
            r3.x = r3.y * r3.x + -r4.x;
            r3.y = 1 / r4.y;
            r3.x = saturate(r3.x * r3.y);
            r3.y = r3.x * -2 + 3;
            r3.x = r3.x * r3.x;
            r4.x = r3.y * r3.x;
            r3.x = -r3.y * r3.x + 1;
            r3.x = cmp(0 < r3.x);
            r3.x = r3.x ? 1.000000 : 0;
            r3.y = r3.x * r2.w;
            r4.y = cmp(0 < r4.x);
            r4.y = r4.y ? 1.000000 : 0;
            r3.w = r4.y * r3.w;
            r3.y = cmp(0 < r3.y);
            r3.y = r3.y ? 1.000000 : 0;
            r4.z = cmp(DistanceFieldFloatArray[2] >= DistanceFieldFloatArray[0]);
            r4.z = r4.z ? 1.000000 : 0;
            r4.y = r4.y * r4.z;
            r3.z = r4.x * r3.z + r4.y;
            r4.y = cmp(DistanceFieldFloatArray[4] >= DistanceFieldFloatArray[2]);
            r4.y = r4.y ? 1.000000 : 0;
            r3.y = r3.y + -r3.z;
            r3.y = max(0, r3.y);
            r3.w = saturate(r3.w * r4.y + -r3.y);
            r3.z = saturate(r3.z + -r3.w);
            r5.x = DistanceFieldFloatArray[6] * r3.y;
            r5.y = DistanceFieldFloatArray[7] * r3.y;
            r5.z = DistanceFieldFloatArray[8] * r3.y;
            r0.xyz = r3.zzz * r0.xyz + r5.xyz;
            r5.x = DistanceFieldFloatArray[9] * r3.w;
            r5.y = DistanceFieldFloatArray[10] * r3.w;
            r5.z = DistanceFieldFloatArray[11] * r3.w;
            r2.xyz = saturate(r5.xyz + r0.xyz);
            r0.x = r2.w * r3.x + r4.x;
            r0.x = min(1, r0.x);
            r0.y = cmp(0 < r0.w);
            r0.y = r0.y ? 1.000000 : 0;
            r0.x = r0.x * r0.y;
            r1.w = ColorMultiplier.w * r0.x;
          }
        }
      }
    }
  }

  if (RENODX_TONE_MAP_TYPE != 0 && RENODX_GAMMA_CORRECTION) r2.rgb = renodx::color::correct::GammaSafe(r2.rgb);  // gamma correct UI

  if (SCRGB != 0) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
      r0.x = 0.0125000002 * HDRReferenceWhiteNits;
    } else {
      r0.x = RENODX_GRAPHICS_WHITE_NITS / 80.f;
    }
    r1.xyz = r2.xyz * r0.xxx;
  } else {
    r0.x = dot(r2.xyz, float3(0.753832996, 0.198596999, 0.047569599));
    r0.y = dot(r2.xyz, float3(0.0457439013, 0.941776991, 0.0124787996));
    r0.z = dot(r2.xyz, float3(-0.00121032004, 0.0176017992, 0.983609021));
    r0.xyz = max(float3(0, 0, 0), r0.xyz);
    if (RENODX_TONE_MAP_TYPE == 0.f) {
      r0.w = cmp(UIModeEx != 5.000000);
      r2.xyz = log2(r0.xyz);
      r2.xyz = r2.xyz * float3(0.0588235296, 0.0588235296, 0.0588235296) + float3(0.527878284, 0.527878284, 0.527878284);
      r2.xyz = r2.xyz * float3(-3, -3, -3) + float3(1.14705884, 1.14705884, 1.14705884);
      r2.xyz = exp2(r2.xyz);
      r2.xyz = float3(1, 1, 1) + r2.xyz;
      r2.xyz = rcp(r2.xyz);
      r2.xyz = r2.xyz * float3(2.11813974, 2.11813974, 2.11813974) + float3(-0.658908367, -0.658908367, -0.658908367);
      r2.xyz = r2.xyz * float3(17, 17, 17) + float3(-8.97393131, -8.97393131, -8.97393131);
      r2.xyz = exp2(r2.xyz);
      r0.xyz = r0.www ? r2.xyz : r0.xyz;
      
      r0.xyz = HDRReferenceWhiteNits * r0.xyz;
    } else {
      r0.xyz = RENODX_GRAPHICS_WHITE_NITS * r0.xyz;
    }
    r0.xyz = float3(9.99999975e-05, 9.99999975e-05, 9.99999975e-05) * r0.xyz;
    r0.xyz = log2(abs(r0.xyz));
    r0.xyz = float3(0.159301758, 0.159301758, 0.159301758) * r0.xyz;
    r0.xyz = exp2(r0.xyz);
    r2.xyzw = r0.xxyy * float4(18.8515625, 18.6875, 18.8515625, 18.6875) + float4(0.8359375, 1, 0.8359375, 1);
    r0.xy = r2.xz / r2.yw;
    r0.xy = log2(r0.xy);
    r0.xy = float2(78.84375, 78.84375) * r0.xy;
    r1.xy = exp2(r0.xy);
    r0.xy = r0.zz * float2(18.8515625, 18.6875) + float2(0.8359375, 1);
    r0.x = r0.x / r0.y;
    r0.x = log2(r0.x);
    r0.x = 78.84375 * r0.x;
    r1.z = exp2(r0.x);
    // r1.rgb = renodx::color::pq::EncodeSafe(r0.rgb, 1.f);
  }
  o0.xyzw = r1.xyzw;
  return;
}
