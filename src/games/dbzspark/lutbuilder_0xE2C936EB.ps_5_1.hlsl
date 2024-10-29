// ---- Created with 3Dmigoto v1.3.16 on Thu Oct 17 13:24:19 2024
#include "./shared.h"
#include "./tonemapper.hlsl"

cbuffer cb0 : register(b0) {
  float4 cb0[8];
}

// 3Dmigoto declarations
#define cmp -

void main(
    linear noperspective float2 v0 : TEXCOORD0,
                                     float4 v1 : SV_POSITION0,
                                                 uint v2 : SV_RenderTargetArrayIndex0,
                                                           out float4 o0 : SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(-0.015625, -0.015625) + v0.xy;
  r0.xy = float2(1.03225803, 1.03225803) * r0.xy;
  r0.z = (uint)v2.x;
  r1.z = 0.0322580636 * r0.z;
  r2.xyzw = cmp(asint(cb0[2].yyyy) == int4(1, 2, 3, 4));
  r3.xyz = r2.www ? float3(1, 0, 0) : float3(1.70505154, -0.621790707, -0.0832583979);
  r4.xyz = r2.www ? float3(0, 1, 0) : float3(-0.130257145, 1.14080286, -0.0105485283);
  r5.xyz = r2.www ? float3(0, 0, 1) : float3(-0.0240032747, -0.128968775, 1.15297174);
  r3.xyz = r2.zzz ? float3(0.695452213, 0.140678704, 0.163869068) : r3.xyz;
  r4.xyz = r2.zzz ? float3(0.0447945632, 0.859671116, 0.0955343172) : r4.xyz;
  r5.xyz = r2.zzz ? float3(-0.00552588282, 0.00402521016, 1.00150073) : r5.xyz;
  r3.xyz = r2.yyy ? float3(1.02579927, -0.0200525094, -0.00577136781) : r3.xyz;
  r4.xyz = r2.yyy ? float3(-0.00223502493, 1.00458264, -0.00235231337) : r4.xyz;
  r2.yzw = r2.yyy ? float3(-0.00501400325, -0.0252933875, 1.03044021) : r5.xyz;
  r3.xyz = r2.xxx ? float3(1.37915885, -0.308850735, -0.0703467429) : r3.xyz;
  r4.xyz = r2.xxx ? float3(-0.0693352968, 1.08229232, -0.0129620517) : r4.xyz;
  r2.xyz = r2.xxx ? float3(-0.00215925858, -0.0454653986, 1.04775953) : r2.yzw;
  r0.xy = log2(r0.xy);
  r0.z = log2(r1.z);
  r0.xyz = float3(0.0126833133, 0.0126833133, 0.0126833133) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r5.xyz = float3(-0.8359375, -0.8359375, -0.8359375) + r0.xyz;
  r5.xyz = max(float3(0, 0, 0), r5.xyz);
  r0.xyz = -r0.xyz * float3(18.6875, 18.6875, 18.6875) + float3(18.8515625, 18.8515625, 18.8515625);
  r0.xyz = r5.xyz / r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(6.27739477, 6.27739477, 6.27739477) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  // r0.xyz = float3(10000, 10000, 10000) * r0.xyz;
  r0.rgb = float3(100, 100, 100) * r0.rgb;

  // They stop before converting to AP1
  float3 input_color = r0.rgb;

  // uint output_type = cb0[40].w;
  float3 sdr_color;
  float3 hdr_color;
  float3 sdr_ap1_color;

  r5.xy = cmp(asint(cb0[2].xx) == int2(3, 5));
  r0.w = (int)r5.y | (int)r5.x;

  if (injectedData.toneMapType != 0.f) {
    renodx::tonemap::Config config = getCommonConfig();

    float3 config_color = renodx::color::bt709::from::BT2020(input_color);

    renodx::tonemap::config::DualToneMap dual_tone_map = renodx::tonemap::config::ApplyToneMaps(config_color, config);
    hdr_color = dual_tone_map.color_hdr;
    sdr_color = dual_tone_map.color_sdr;

    float3 final_color = saturate(input_color);

    if (injectedData.toneMapType != 1.f) {
      final_color = renodx::tonemap::UpgradeToneMap(hdr_color, sdr_color, final_color, 1.f);
    } else {
      final_color = hdr_color;
    }

    final_color = renodx::color::bt2020::from::BT709(final_color);
    float encodeRate = injectedData.toneMapType > 1.f ? injectedData.toneMapGameNits : 100.f;
    final_color = renodx::color::pq::Encode(final_color, encodeRate);

    o0.rgba = float4(final_color, 0);
    return;
  }
  // Nothing to upgrade since ACES SDR adjustments are removed

  if (r0.w != 0) {
    r5.y = dot(float3(0.439700812, 0.382978052, 0.1773348), r0.xyz);
    r5.z = dot(float3(0.0897923037, 0.813423157, 0.096761629), r0.xyz);
    r5.w = dot(float3(0.0175439864, 0.111544058, 0.870704114), r0.xyz);
    r0.w = min(r5.y, r5.z);
    r0.w = min(r0.w, r5.w);
    r1.w = max(r5.y, r5.z);
    r1.w = max(r1.w, r5.w);
    r6.xy = max(float2(1.00000001e-10, 0.00999999978), r1.ww);
    r0.w = max(1.00000001e-10, r0.w);
    r0.w = r6.x + -r0.w;
    r0.w = r0.w / r6.y;
    r6.xyz = r5.wzy + -r5.zyw;
    r6.xy = r6.xy * r5.wz;
    r1.w = r6.x + r6.y;
    r1.w = r5.y * r6.z + r1.w;
    r1.w = sqrt(r1.w);
    r2.w = r5.w + r5.z;
    r2.w = r2.w + r5.y;
    r1.w = r1.w * 1.75 + r2.w;
    r2.w = 0.333333343 * r1.w;
    r3.w = -0.400000006 + r0.w;
    r4.w = 2.5 * r3.w;
    r4.w = 1 + -abs(r4.w);
    r4.w = max(0, r4.w);
    r5.x = cmp(0 < r3.w);
    r3.w = cmp(r3.w < 0);
    r3.w = (int)-r5.x + (int)r3.w;
    r3.w = (int)r3.w;
    r4.w = -r4.w * r4.w + 1;
    r3.w = r3.w * r4.w + 1;
    r3.w = 0.0250000004 * r3.w;
    r4.w = cmp(0.159999996 >= r1.w);
    r1.w = cmp(r1.w >= 0.479999989);
    r2.w = 0.0799999982 / r2.w;
    r2.w = -0.5 + r2.w;
    r2.w = r3.w * r2.w;
    r1.w = r1.w ? 0 : r2.w;
    r1.w = r4.w ? r3.w : r1.w;
    r1.w = 1 + r1.w;
    r6.yzw = r5.yzw * r1.www;
    r7.xy = cmp(r6.zw == r6.yz);
    r2.w = r7.y ? r7.x : 0;
    r3.w = r5.z * r1.w + -r6.w;
    r3.w = 1.73205078 * r3.w;
    r4.w = r6.y * 2 + -r6.z;
    r4.w = -r5.w * r1.w + r4.w;
    r5.x = min(abs(r4.w), abs(r3.w));
    r5.z = max(abs(r4.w), abs(r3.w));
    r5.z = 1 / r5.z;
    r5.x = r5.x * r5.z;
    r5.z = r5.x * r5.x;
    r5.w = r5.z * 0.0208350997 + -0.0851330012;
    r5.w = r5.z * r5.w + 0.180141002;
    r5.w = r5.z * r5.w + -0.330299497;
    r5.z = r5.z * r5.w + 0.999866009;
    r5.w = r5.x * r5.z;
    r7.x = cmp(abs(r4.w) < abs(r3.w));
    r5.w = r5.w * -2 + 1.57079637;
    r5.w = r7.x ? r5.w : 0;
    r5.x = r5.x * r5.z + r5.w;
    r5.z = cmp(r4.w < -r4.w);
    r5.z = r5.z ? -3.141593 : 0;
    r5.x = r5.x + r5.z;
    r5.z = min(r4.w, r3.w);
    r3.w = max(r4.w, r3.w);
    r4.w = cmp(r5.z < -r5.z);
    r3.w = cmp(r3.w >= -r3.w);
    r3.w = r3.w ? r4.w : 0;
    r3.w = r3.w ? -r5.x : r5.x;
    r3.w = 57.2957802 * r3.w;
    r2.w = r2.w ? 0 : r3.w;
    r3.w = cmp(r2.w < 0);
    r4.w = 360 + r2.w;
    r2.w = r3.w ? r4.w : r2.w;
    r2.w = max(0, r2.w);
    r2.w = min(360, r2.w);
    r3.w = cmp(180 < r2.w);
    r4.w = -360 + r2.w;
    r2.w = r3.w ? r4.w : r2.w;
    r3.w = cmp(-67.5 < r2.w);
    r4.w = cmp(r2.w < 67.5);
    r3.w = r3.w ? r4.w : 0;
    if (r3.w != 0) {
      r2.w = 67.5 + r2.w;
      r3.w = 0.0296296291 * r2.w;
      r4.w = (int)r3.w;
      r3.w = trunc(r3.w);
      r2.w = r2.w * 0.0296296291 + -r3.w;
      r3.w = r2.w * r2.w;
      r5.x = r3.w * r2.w;
      r7.xyz = float3(-0.166666672, -0.5, 0.166666672) * r5.xxx;
      r5.zw = r3.ww * float2(0.5, 0.5) + r7.xy;
      r5.zw = r2.ww * float2(-0.5, 0.5) + r5.zw;
      r2.w = r5.x * 0.5 + -r3.w;
      r2.w = 0.666666687 + r2.w;
      r7.xyw = cmp((int3)r4.www == int3(3, 2, 1));
      r5.xz = float2(0.166666672, 0.166666672) + r5.zw;
      r3.w = r4.w ? 0 : r7.z;
      r3.w = r7.w ? r5.z : r3.w;
      r2.w = r7.y ? r2.w : r3.w;
      r2.w = r7.x ? r5.x : r2.w;
    } else {
      r2.w = 0;
    }
    r0.w = r2.w * r0.w;
    r0.w = 1.5 * r0.w;
    r1.w = -r5.y * r1.w + 0.0299999993;
    r0.w = r1.w * r0.w;
    r6.x = r0.w * 0.180000007 + r6.y;
    r5.xyz = max(float3(0, 0, 0), r6.xzw);
    r5.xyz = min(float3(65535, 65535, 65535), r5.xyz);
    r6.x = dot(float3(1.45143926, -0.236510754, -0.214928567), r5.xyz);
    r6.y = dot(float3(-0.0765537769, 1.17622972, -0.0996759236), r5.xyz);
    r6.z = dot(float3(0.00831614807, -0.00603244966, 0.997716308), r5.xyz);
    r5.xyz = max(float3(0, 0, 0), r6.xyz);
    r5.xyz = min(float3(65504, 65504, 65504), r5.xyz);
    r0.w = dot(r5.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
    r5.xyz = r5.xyz + -r0.www;
    r5.xyz = r5.xyz * float3(0.959999979, 0.959999979, 0.959999979) + r0.www;
    r5.xyz = max(float3(1.00000001e-10, 1.00000001e-10, 1.00000001e-10), r5.xyz);
    r5.xyz = log2(r5.xyz);
    r6.xyz = float3(0.30103001, 0.30103001, 0.30103001) * r5.xyz;
    r0.w = log2(cb0[3].x);
    r0.w = 0.30103001 * r0.w;
    r7.xyz = cmp(r0.www >= r6.xyz);
    if (r7.x != 0) {
      r1.w = log2(cb0[3].y);
      r1.w = 0.30103001 * r1.w;
    } else {
      r2.w = cmp(r0.w < r6.x);
      r3.w = log2(cb0[4].x);
      r4.w = 0.30103001 * r3.w;
      r5.w = cmp(r6.x < r4.w);
      r2.w = r2.w ? r5.w : 0;
      if (r2.w != 0) {
        r2.w = r5.x * 0.30103001 + -r0.w;
        r2.w = 3 * r2.w;
        r3.w = r3.w * 0.30103001 + -r0.w;
        r2.w = r2.w / r3.w;
        r3.w = (int)r2.w;
        r5.w = trunc(r2.w);
        r8.y = -r5.w + r2.w;
        r9.xyzw = cmp((int4)r3.wwww == int4(3, 2, 1, 0));
        r7.xw = cmp((int2)r3.ww == int2(4, 5));
        r9.xyzw = r9.xyzw ? float4(1, 1, 1, 1) : 0;
        r7.xw = r7.xw ? float2(1, 1) : 0;
        r2.w = dot(r9.wzyx, cb0[5].xyzw);
        r2.w = r7.x * cb0[7].x + r2.w;
        r9.x = r7.w * cb0[7].x + r2.w;
        r10.xyzw = (int4)r3.wwww + int4(1, 1, 2, 2);
        r11.xyzw = cmp((int4)r10.yyyy == int4(3, 2, 1, 0));
        r12.xyzw = cmp((int4)r10.xyzw == int4(4, 5, 4, 5));
        r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
        r12.xyzw = r12.xyzw ? float4(1, 1, 1, 1) : 0;
        r2.w = dot(r11.wzyx, cb0[5].xyzw);
        r2.w = r12.x * cb0[7].x + r2.w;
        r9.y = r12.y * cb0[7].x + r2.w;
        r10.xyzw = cmp((int4)r10.wwww == int4(3, 2, 1, 0));
        r10.xyzw = r10.xyzw ? float4(1, 1, 1, 1) : 0;
        r2.w = dot(r10.wzyx, cb0[5].xyzw);
        r2.w = r12.z * cb0[7].x + r2.w;
        r9.z = r12.w * cb0[7].x + r2.w;
        r8.x = r8.y * r8.y;
        r10.x = dot(r9.xzy, float3(0.5, 0.5, -1));
        r10.y = dot(r9.xy, float2(-1, 1));
        r10.z = dot(r9.xy, float2(0.5, 0.5));
        r8.z = 1;
        r1.w = dot(r8.xyz, r10.xyz);
      } else {
        r2.w = cmp(r6.x >= r4.w);
        r3.w = log2(cb0[3].z);
        r5.w = 0.30103001 * r3.w;
        r5.w = cmp(r6.x < r5.w);
        r2.w = r2.w ? r5.w : 0;
        if (r2.w != 0) {
          r2.w = r5.x * 0.30103001 + -r4.w;
          r2.w = 3 * r2.w;
          r3.w = r3.w * 0.30103001 + -r4.w;
          r2.w = r2.w / r3.w;
          r3.w = (int)r2.w;
          r4.w = trunc(r2.w);
          r8.y = -r4.w + r2.w;
          r9.xyzw = cmp((int4)r3.wwww == int4(3, 2, 1, 0));
          r5.xw = cmp((int2)r3.ww == int2(4, 5));
          r9.xyzw = r9.xyzw ? float4(1, 1, 1, 1) : 0;
          r5.xw = r5.xw ? float2(1, 1) : 0;
          r2.w = dot(r9.wzyx, cb0[6].xyzw);
          r2.w = r5.x * cb0[7].y + r2.w;
          r9.x = r5.w * cb0[7].y + r2.w;
          r10.xyzw = (int4)r3.wwww + int4(1, 1, 2, 2);
          r11.xyzw = cmp((int4)r10.yyyy == int4(3, 2, 1, 0));
          r12.xyzw = cmp((int4)r10.xyzw == int4(4, 5, 4, 5));
          r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
          r12.xyzw = r12.xyzw ? float4(1, 1, 1, 1) : 0;
          r2.w = dot(r11.wzyx, cb0[6].xyzw);
          r2.w = r12.x * cb0[7].y + r2.w;
          r9.y = r12.y * cb0[7].y + r2.w;
          r10.xyzw = cmp((int4)r10.wwww == int4(3, 2, 1, 0));
          r10.xyzw = r10.xyzw ? float4(1, 1, 1, 1) : 0;
          r2.w = dot(r10.wzyx, cb0[6].xyzw);
          r2.w = r12.z * cb0[7].y + r2.w;
          r9.z = r12.w * cb0[7].y + r2.w;
          r8.x = r8.y * r8.y;
          r10.x = dot(r9.xzy, float3(0.5, 0.5, -1));
          r10.y = dot(r9.xy, float2(-1, 1));
          r10.z = dot(r9.xy, float2(0.5, 0.5));
          r8.z = 1;
          r1.w = dot(r8.xyz, r10.xyz);
        } else {
          r2.w = log2(cb0[3].w);
          r1.w = 0.30103001 * r2.w;
        }
      }
    }
    r1.w = 3.32192802 * r1.w;
    r1.w = exp2(r1.w);
    if (r7.y != 0) {
      r2.w = log2(cb0[3].y);
      r2.w = 0.30103001 * r2.w;
    } else {
      r3.w = cmp(r0.w < r6.y);
      r4.w = log2(cb0[4].x);
      r5.x = 0.30103001 * r4.w;
      r5.w = cmp(r6.y < r5.x);
      r3.w = r3.w ? r5.w : 0;
      if (r3.w != 0) {
        r3.w = r5.y * 0.30103001 + -r0.w;
        r3.w = 3 * r3.w;
        r4.w = r4.w * 0.30103001 + -r0.w;
        r3.w = r3.w / r4.w;
        r4.w = (int)r3.w;
        r5.w = trunc(r3.w);
        r8.y = -r5.w + r3.w;
        r9.xyzw = cmp((int4)r4.wwww == int4(3, 2, 1, 0));
        r6.xw = cmp((int2)r4.ww == int2(4, 5));
        r9.xyzw = r9.xyzw ? float4(1, 1, 1, 1) : 0;
        r6.xw = r6.xw ? float2(1, 1) : 0;
        r3.w = dot(r9.wzyx, cb0[5].xyzw);
        r3.w = r6.x * cb0[7].x + r3.w;
        r9.x = r6.w * cb0[7].x + r3.w;
        r10.xyzw = (int4)r4.wwww + int4(1, 1, 2, 2);
        r11.xyzw = cmp((int4)r10.yyyy == int4(3, 2, 1, 0));
        r12.xyzw = cmp((int4)r10.xyzw == int4(4, 5, 4, 5));
        r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
        r12.xyzw = r12.xyzw ? float4(1, 1, 1, 1) : 0;
        r3.w = dot(r11.wzyx, cb0[5].xyzw);
        r3.w = r12.x * cb0[7].x + r3.w;
        r9.y = r12.y * cb0[7].x + r3.w;
        r10.xyzw = cmp((int4)r10.wwww == int4(3, 2, 1, 0));
        r10.xyzw = r10.xyzw ? float4(1, 1, 1, 1) : 0;
        r3.w = dot(r10.wzyx, cb0[5].xyzw);
        r3.w = r12.z * cb0[7].x + r3.w;
        r9.z = r12.w * cb0[7].x + r3.w;
        r8.x = r8.y * r8.y;
        r10.x = dot(r9.xzy, float3(0.5, 0.5, -1));
        r10.y = dot(r9.xy, float2(-1, 1));
        r10.z = dot(r9.xy, float2(0.5, 0.5));
        r8.z = 1;
        r2.w = dot(r8.xyz, r10.xyz);
      } else {
        r3.w = cmp(r6.y >= r5.x);
        r4.w = log2(cb0[3].z);
        r5.w = 0.30103001 * r4.w;
        r5.w = cmp(r6.y < r5.w);
        r3.w = r3.w ? r5.w : 0;
        if (r3.w != 0) {
          r3.w = r5.y * 0.30103001 + -r5.x;
          r3.w = 3 * r3.w;
          r4.w = r4.w * 0.30103001 + -r5.x;
          r3.w = r3.w / r4.w;
          r4.w = (int)r3.w;
          r5.x = trunc(r3.w);
          r8.y = -r5.x + r3.w;
          r9.xyzw = cmp((int4)r4.wwww == int4(3, 2, 1, 0));
          r5.xy = cmp((int2)r4.ww == int2(4, 5));
          r9.xyzw = r9.xyzw ? float4(1, 1, 1, 1) : 0;
          r5.xy = r5.xy ? float2(1, 1) : 0;
          r3.w = dot(r9.wzyx, cb0[6].xyzw);
          r3.w = r5.x * cb0[7].y + r3.w;
          r9.x = r5.y * cb0[7].y + r3.w;
          r10.xyzw = (int4)r4.wwww + int4(1, 1, 2, 2);
          r11.xyzw = cmp((int4)r10.yyyy == int4(3, 2, 1, 0));
          r12.xyzw = cmp((int4)r10.xyzw == int4(4, 5, 4, 5));
          r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
          r12.xyzw = r12.xyzw ? float4(1, 1, 1, 1) : 0;
          r3.w = dot(r11.wzyx, cb0[6].xyzw);
          r3.w = r12.x * cb0[7].y + r3.w;
          r9.y = r12.y * cb0[7].y + r3.w;
          r10.xyzw = cmp((int4)r10.wwww == int4(3, 2, 1, 0));
          r10.xyzw = r10.xyzw ? float4(1, 1, 1, 1) : 0;
          r3.w = dot(r10.wzyx, cb0[6].xyzw);
          r3.w = r12.z * cb0[7].y + r3.w;
          r9.z = r12.w * cb0[7].y + r3.w;
          r8.x = r8.y * r8.y;
          r10.x = dot(r9.xzy, float3(0.5, 0.5, -1));
          r10.y = dot(r9.xy, float2(-1, 1));
          r10.z = dot(r9.xy, float2(0.5, 0.5));
          r8.z = 1;
          r2.w = dot(r8.xyz, r10.xyz);
        } else {
          r3.w = log2(cb0[3].w);
          r2.w = 0.30103001 * r3.w;
        }
      }
    }
    r2.w = 3.32192802 * r2.w;
    r2.w = exp2(r2.w);
    if (r7.z != 0) {
      r3.w = log2(cb0[3].y);
      r3.w = 0.30103001 * r3.w;
    } else {
      r4.w = cmp(r0.w < r6.z);
      r5.x = log2(cb0[4].x);
      r5.y = 0.30103001 * r5.x;
      r5.w = cmp(r6.z < r5.y);
      r4.w = r4.w ? r5.w : 0;
      if (r4.w != 0) {
        r4.w = r5.z * 0.30103001 + -r0.w;
        r4.w = 3 * r4.w;
        r0.w = r5.x * 0.30103001 + -r0.w;
        r0.w = r4.w / r0.w;
        r4.w = (int)r0.w;
        r5.x = trunc(r0.w);
        r7.y = -r5.x + r0.w;
        r8.xyzw = cmp((int4)r4.wwww == int4(3, 2, 1, 0));
        r5.xw = cmp((int2)r4.ww == int2(4, 5));
        r8.xyzw = r8.xyzw ? float4(1, 1, 1, 1) : 0;
        r5.xw = r5.xw ? float2(1, 1) : 0;
        r0.w = dot(r8.wzyx, cb0[5].xyzw);
        r0.w = r5.x * cb0[7].x + r0.w;
        r8.x = r5.w * cb0[7].x + r0.w;
        r9.xyzw = (int4)r4.wwww + int4(1, 1, 2, 2);
        r10.xyzw = cmp((int4)r9.yyyy == int4(3, 2, 1, 0));
        r11.xyzw = cmp((int4)r9.xyzw == int4(4, 5, 4, 5));
        r10.xyzw = r10.xyzw ? float4(1, 1, 1, 1) : 0;
        r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
        r0.w = dot(r10.wzyx, cb0[5].xyzw);
        r0.w = r11.x * cb0[7].x + r0.w;
        r8.y = r11.y * cb0[7].x + r0.w;
        r9.xyzw = cmp((int4)r9.wwww == int4(3, 2, 1, 0));
        r9.xyzw = r9.xyzw ? float4(1, 1, 1, 1) : 0;
        r0.w = dot(r9.wzyx, cb0[5].xyzw);
        r0.w = r11.z * cb0[7].x + r0.w;
        r8.z = r11.w * cb0[7].x + r0.w;
        r7.x = r7.y * r7.y;
        r9.x = dot(r8.xzy, float3(0.5, 0.5, -1));
        r9.y = dot(r8.xy, float2(-1, 1));
        r9.z = dot(r8.xy, float2(0.5, 0.5));
        r7.z = 1;
        r3.w = dot(r7.xyz, r9.xyz);
      } else {
        r0.w = cmp(r6.z >= r5.y);
        r4.w = log2(cb0[3].z);
        r5.x = 0.30103001 * r4.w;
        r5.x = cmp(r6.z < r5.x);
        r0.w = r0.w ? r5.x : 0;
        if (r0.w != 0) {
          r0.w = r5.z * 0.30103001 + -r5.y;
          r0.w = 3 * r0.w;
          r4.w = r4.w * 0.30103001 + -r5.y;
          r0.w = r0.w / r4.w;
          r4.w = (int)r0.w;
          r5.x = trunc(r0.w);
          r5.y = -r5.x + r0.w;
          r6.xyzw = cmp((int4)r4.wwww == int4(3, 2, 1, 0));
          r7.xy = cmp((int2)r4.ww == int2(4, 5));
          r6.xyzw = r6.xyzw ? float4(1, 1, 1, 1) : 0;
          r7.xy = r7.xy ? float2(1, 1) : 0;
          r0.w = dot(r6.wzyx, cb0[6].xyzw);
          r0.w = r7.x * cb0[7].y + r0.w;
          r6.x = r7.y * cb0[7].y + r0.w;
          r7.xyzw = (int4)r4.wwww + int4(1, 1, 2, 2);
          r8.xyzw = cmp((int4)r7.yyyy == int4(3, 2, 1, 0));
          r9.xyzw = cmp((int4)r7.xyzw == int4(4, 5, 4, 5));
          r8.xyzw = r8.xyzw ? float4(1, 1, 1, 1) : 0;
          r9.xyzw = r9.xyzw ? float4(1, 1, 1, 1) : 0;
          r0.w = dot(r8.wzyx, cb0[6].xyzw);
          r0.w = r9.x * cb0[7].y + r0.w;
          r6.y = r9.y * cb0[7].y + r0.w;
          r7.xyzw = cmp((int4)r7.wwww == int4(3, 2, 1, 0));
          r7.xyzw = r7.xyzw ? float4(1, 1, 1, 1) : 0;
          r0.w = dot(r7.wzyx, cb0[6].xyzw);
          r0.w = r9.z * cb0[7].y + r0.w;
          r6.z = r9.w * cb0[7].y + r0.w;
          r5.x = r5.y * r5.y;
          r7.x = dot(r6.xzy, float3(0.5, 0.5, -1));
          r7.y = dot(r6.xy, float2(-1, 1));
          r7.z = dot(r6.xy, float2(0.5, 0.5));
          r5.z = 1;
          r3.w = dot(r5.xyz, r7.xyz);
        } else {
          r0.w = log2(cb0[3].w);
          r3.w = 0.30103001 * r0.w;
        }
      }
    }
    r0.w = 3.32192802 * r3.w;
    r0.w = exp2(r0.w);
    r1.w = -cb0[3].y + r1.w;
    r3.w = cb0[3].w + -cb0[3].y;
    r5.x = r1.w / r3.w;
    r1.w = -cb0[3].y + r2.w;
    r5.y = r1.w / r3.w;
    r0.w = -cb0[3].y + r0.w;
    r5.z = r0.w / r3.w;
    r6.x = dot(float3(0.662454188, 0.134004205, 0.156187683), r5.xyz);
    r6.y = dot(float3(0.272228718, 0.674081743, 0.0536895171), r5.xyz);
    r6.z = dot(float3(-0.00557464967, 0.0040607336, 1.01033914), r5.xyz);
    r5.x = saturate(dot(float3(1.6410234, -0.324803293, -0.236424699), r6.xyz));
    r5.y = saturate(dot(float3(-0.663662851, 1.61533165, 0.0167563483), r6.xyz));
    r5.z = saturate(dot(float3(0.0117218941, -0.00828444213, 0.988394856), r6.xyz));
    r6.x = dot(float3(0.662454188, 0.134004205, 0.156187683), r5.xyz);
    r6.y = dot(float3(0.272228718, 0.674081743, 0.0536895171), r5.xyz);
    r6.z = dot(float3(-0.00557464967, 0.0040607336, 1.01033914), r5.xyz);
    r5.x = dot(float3(1.6410234, -0.324803293, -0.236424699), r6.xyz);
    r5.y = dot(float3(-0.663662851, 1.61533165, 0.0167563483), r6.xyz);
    r5.z = dot(float3(0.0117218941, -0.00828444213, 0.988394856), r6.xyz);
    r5.xyz = max(float3(0, 0, 0), r5.xyz);
    r5.xyz = cb0[3].www * r5.xyz;
    r5.xyz = max(float3(0, 0, 0), r5.xyz);
    r5.xyz = min(float3(65535, 65535, 65535), r5.xyz);
    r0.w = cmp(asint(cb0[2].x) != 5);
    r6.x = dot(r3.xyz, r5.xyz);
    r6.y = dot(r4.xyz, r5.xyz);
    r6.z = dot(r2.xyz, r5.xyz);
    r5.xyz = r0.www ? r6.xyz : r5.xyz;
    r5.xyz = float3(9.99999975e-05, 9.99999975e-05, 9.99999975e-05) * r5.xyz;
    r5.xyz = log2(r5.xyz);
    r5.xyz = float3(0.159301758, 0.159301758, 0.159301758) * r5.xyz;
    r5.xyz = exp2(r5.xyz);
    r6.xyz = r5.xyz * float3(18.8515625, 18.8515625, 18.8515625) + float3(0.8359375, 0.8359375, 0.8359375);
    r5.xyz = r5.xyz * float3(18.6875, 18.6875, 18.6875) + float3(1, 1, 1);
    r5.xyz = rcp(r5.xyz);
    r5.xyz = r6.xyz * r5.xyz;
    r5.xyz = log2(r5.xyz);
    r5.xyz = float3(78.84375, 78.84375, 78.84375) * r5.xyz;
    r1.xyz = exp2(r5.xyz);
  } else {
    r5.xy = cmp(asint(cb0[2].xx) == int2(4, 6));
    r0.w = (int)r5.y | (int)r5.x;
    if (r0.w != 0) {
      r5.y = dot(float3(0.439700812, 0.382978052, 0.1773348), r0.xyz);
      r5.z = dot(float3(0.0897923037, 0.813423157, 0.096761629), r0.xyz);
      r5.w = dot(float3(0.0175439864, 0.111544058, 0.870704114), r0.xyz);
      r0.x = min(r5.y, r5.z);
      r0.x = min(r0.x, r5.w);
      r0.y = max(r5.y, r5.z);
      r0.y = max(r0.y, r5.w);
      r0.xyz = max(float3(1.00000001e-10, 1.00000001e-10, 0.00999999978), r0.xyy);
      r0.x = r0.y + -r0.x;
      r0.x = r0.x / r0.z;
      r0.yzw = r5.wzy + -r5.zyw;
      r0.yz = r5.wz * r0.yz;
      r0.y = r0.y + r0.z;
      r0.y = r5.y * r0.w + r0.y;
      r0.y = sqrt(r0.y);
      r0.z = r5.w + r5.z;
      r0.z = r0.z + r5.y;
      r0.y = r0.y * 1.75 + r0.z;
      r0.w = -0.400000006 + r0.x;
      r1.w = 2.5 * r0.w;
      r1.w = 1 + -abs(r1.w);
      r1.w = max(0, r1.w);
      r2.w = cmp(0 < r0.w);
      r0.w = cmp(r0.w < 0);
      r0.w = (int)-r2.w + (int)r0.w;
      r0.w = (int)r0.w;
      r1.w = -r1.w * r1.w + 1;
      r0.w = r0.w * r1.w + 1;
      r0.zw = float2(0.333333343, 0.0250000004) * r0.yw;
      r1.w = cmp(0.159999996 >= r0.y);
      r0.y = cmp(r0.y >= 0.479999989);
      r0.z = 0.0799999982 / r0.z;
      r0.z = -0.5 + r0.z;
      r0.z = r0.w * r0.z;
      r0.y = r0.y ? 0 : r0.z;
      r0.y = r1.w ? r0.w : r0.y;
      r0.y = 1 + r0.y;
      r6.yzw = r5.yzw * r0.yyy;
      r0.zw = cmp(r6.zw == r6.yz);
      r0.z = r0.w ? r0.z : 0;
      r0.w = r5.z * r0.y + -r6.w;
      r0.w = 1.73205078 * r0.w;
      r1.w = r6.y * 2 + -r6.z;
      r1.w = -r5.w * r0.y + r1.w;
      r2.w = min(abs(r1.w), abs(r0.w));
      r3.w = max(abs(r1.w), abs(r0.w));
      r3.w = 1 / r3.w;
      r2.w = r3.w * r2.w;
      r3.w = r2.w * r2.w;
      r4.w = r3.w * 0.0208350997 + -0.0851330012;
      r4.w = r3.w * r4.w + 0.180141002;
      r4.w = r3.w * r4.w + -0.330299497;
      r3.w = r3.w * r4.w + 0.999866009;
      r4.w = r3.w * r2.w;
      r5.x = cmp(abs(r1.w) < abs(r0.w));
      r4.w = r4.w * -2 + 1.57079637;
      r4.w = r5.x ? r4.w : 0;
      r2.w = r2.w * r3.w + r4.w;
      r3.w = cmp(r1.w < -r1.w);
      r3.w = r3.w ? -3.141593 : 0;
      r2.w = r3.w + r2.w;
      r3.w = min(r1.w, r0.w);
      r0.w = max(r1.w, r0.w);
      r1.w = cmp(r3.w < -r3.w);
      r0.w = cmp(r0.w >= -r0.w);
      r0.w = r0.w ? r1.w : 0;
      r0.w = r0.w ? -r2.w : r2.w;
      r0.w = 57.2957802 * r0.w;
      r0.z = r0.z ? 0 : r0.w;
      r0.w = cmp(r0.z < 0);
      r1.w = 360 + r0.z;
      r0.z = r0.w ? r1.w : r0.z;
      r0.z = max(0, r0.z);
      r0.z = min(360, r0.z);
      r0.w = cmp(180 < r0.z);
      r1.w = -360 + r0.z;
      r0.z = r0.w ? r1.w : r0.z;
      r0.w = cmp(-67.5 < r0.z);
      r1.w = cmp(r0.z < 67.5);
      r0.w = r0.w ? r1.w : 0;
      if (r0.w != 0) {
        r0.z = 67.5 + r0.z;
        r0.w = 0.0296296291 * r0.z;
        r1.w = (int)r0.w;
        r0.w = trunc(r0.w);
        r0.z = r0.z * 0.0296296291 + -r0.w;
        r0.w = r0.z * r0.z;
        r2.w = r0.w * r0.z;
        r5.xzw = float3(-0.166666672, -0.5, 0.166666672) * r2.www;
        r5.xz = r0.ww * float2(0.5, 0.5) + r5.xz;
        r5.xz = r0.zz * float2(-0.5, 0.5) + r5.xz;
        r0.z = r2.w * 0.5 + -r0.w;
        r0.z = 0.666666687 + r0.z;
        r7.xyz = cmp((int3)r1.www == int3(3, 2, 1));
        r5.xz = float2(0.166666672, 0.166666672) + r5.xz;
        r0.w = r1.w ? 0 : r5.w;
        r0.w = r7.z ? r5.z : r0.w;
        r0.z = r7.y ? r0.z : r0.w;
        r0.z = r7.x ? r5.x : r0.z;
      } else {
        r0.z = 0;
      }
      r0.x = r0.z * r0.x;
      r0.x = 1.5 * r0.x;
      r0.y = -r5.y * r0.y + 0.0299999993;
      r0.x = r0.x * r0.y;
      r6.x = r0.x * 0.180000007 + r6.y;
      r0.xyz = max(float3(0, 0, 0), r6.xzw);
      r0.xyz = min(float3(65535, 65535, 65535), r0.xyz);
      r5.x = dot(float3(1.45143926, -0.236510754, -0.214928567), r0.xyz);
      r5.y = dot(float3(-0.0765537769, 1.17622972, -0.0996759236), r0.xyz);
      r5.z = dot(float3(0.00831614807, -0.00603244966, 0.997716308), r0.xyz);
      r0.xyz = max(float3(0, 0, 0), r5.xyz);
      r0.xyz = min(float3(65504, 65504, 65504), r0.xyz);
      r0.w = dot(r0.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
      r0.xyz = r0.xyz + -r0.www;
      r0.xyz = r0.xyz * float3(0.959999979, 0.959999979, 0.959999979) + r0.www;
      r0.xyz = max(float3(1.00000001e-10, 1.00000001e-10, 1.00000001e-10), r0.xyz);
      r0.xyz = log2(r0.xyz);
      r5.xyz = float3(0.30103001, 0.30103001, 0.30103001) * r0.xyz;
      r0.w = log2(cb0[3].x);
      r0.w = 0.30103001 * r0.w;
      r6.xyz = cmp(r0.www >= r5.xyz);
      if (r6.x != 0) {
        r1.w = log2(cb0[3].y);
        r1.w = 0.30103001 * r1.w;
      } else {
        r2.w = cmp(r0.w < r5.x);
        r3.w = log2(cb0[4].x);
        r4.w = 0.30103001 * r3.w;
        r5.w = cmp(r5.x < r4.w);
        r2.w = r2.w ? r5.w : 0;
        if (r2.w != 0) {
          r2.w = r0.x * 0.30103001 + -r0.w;
          r2.w = 3 * r2.w;
          r3.w = r3.w * 0.30103001 + -r0.w;
          r2.w = r2.w / r3.w;
          r3.w = (int)r2.w;
          r5.w = trunc(r2.w);
          r7.y = -r5.w + r2.w;
          r8.xyzw = cmp((int4)r3.wwww == int4(3, 2, 1, 0));
          r6.xw = cmp((int2)r3.ww == int2(4, 5));
          r8.xyzw = r8.xyzw ? float4(1, 1, 1, 1) : 0;
          r6.xw = r6.xw ? float2(1, 1) : 0;
          r2.w = dot(r8.wzyx, cb0[5].xyzw);
          r2.w = r6.x * cb0[7].x + r2.w;
          r8.x = r6.w * cb0[7].x + r2.w;
          r9.xyzw = (int4)r3.wwww + int4(1, 1, 2, 2);
          r10.xyzw = cmp((int4)r9.yyyy == int4(3, 2, 1, 0));
          r11.xyzw = cmp((int4)r9.xyzw == int4(4, 5, 4, 5));
          r10.xyzw = r10.xyzw ? float4(1, 1, 1, 1) : 0;
          r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
          r2.w = dot(r10.wzyx, cb0[5].xyzw);
          r2.w = r11.x * cb0[7].x + r2.w;
          r8.y = r11.y * cb0[7].x + r2.w;
          r9.xyzw = cmp((int4)r9.wwww == int4(3, 2, 1, 0));
          r9.xyzw = r9.xyzw ? float4(1, 1, 1, 1) : 0;
          r2.w = dot(r9.wzyx, cb0[5].xyzw);
          r2.w = r11.z * cb0[7].x + r2.w;
          r8.z = r11.w * cb0[7].x + r2.w;
          r7.x = r7.y * r7.y;
          r9.x = dot(r8.xzy, float3(0.5, 0.5, -1));
          r9.y = dot(r8.xy, float2(-1, 1));
          r9.z = dot(r8.xy, float2(0.5, 0.5));
          r7.z = 1;
          r1.w = dot(r7.xyz, r9.xyz);
        } else {
          r2.w = cmp(r5.x >= r4.w);
          r3.w = log2(cb0[3].z);
          r5.w = 0.30103001 * r3.w;
          r5.x = cmp(r5.x < r5.w);
          r2.w = r2.w ? r5.x : 0;
          if (r2.w != 0) {
            r0.x = r0.x * 0.30103001 + -r4.w;
            r0.x = 3 * r0.x;
            r2.w = r3.w * 0.30103001 + -r4.w;
            r0.x = r0.x / r2.w;
            r2.w = (int)r0.x;
            r3.w = trunc(r0.x);
            r7.y = -r3.w + r0.x;
            r8.xyzw = cmp((int4)r2.wwww == int4(3, 2, 1, 0));
            r5.xw = cmp((int2)r2.ww == int2(4, 5));
            r8.xyzw = r8.xyzw ? float4(1, 1, 1, 1) : 0;
            r5.xw = r5.xw ? float2(1, 1) : 0;
            r0.x = dot(r8.wzyx, cb0[6].xyzw);
            r0.x = r5.x * cb0[7].y + r0.x;
            r8.x = r5.w * cb0[7].y + r0.x;
            r9.xyzw = (int4)r2.wwww + int4(1, 1, 2, 2);
            r10.xyzw = cmp((int4)r9.yyyy == int4(3, 2, 1, 0));
            r11.xyzw = cmp((int4)r9.xyzw == int4(4, 5, 4, 5));
            r10.xyzw = r10.xyzw ? float4(1, 1, 1, 1) : 0;
            r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
            r0.x = dot(r10.wzyx, cb0[6].xyzw);
            r0.x = r11.x * cb0[7].y + r0.x;
            r8.y = r11.y * cb0[7].y + r0.x;
            r9.xyzw = cmp((int4)r9.wwww == int4(3, 2, 1, 0));
            r9.xyzw = r9.xyzw ? float4(1, 1, 1, 1) : 0;
            r0.x = dot(r9.wzyx, cb0[6].xyzw);
            r0.x = r11.z * cb0[7].y + r0.x;
            r8.z = r11.w * cb0[7].y + r0.x;
            r7.x = r7.y * r7.y;
            r9.x = dot(r8.xzy, float3(0.5, 0.5, -1));
            r9.y = dot(r8.xy, float2(-1, 1));
            r9.z = dot(r8.xy, float2(0.5, 0.5));
            r7.z = 1;
            r1.w = dot(r7.xyz, r9.xyz);
          } else {
            r0.x = log2(cb0[3].w);
            r1.w = 0.30103001 * r0.x;
          }
        }
      }
      r0.x = 3.32192802 * r1.w;
      r0.x = exp2(r0.x);
      if (r6.y != 0) {
        r1.w = log2(cb0[3].y);
        r1.w = 0.30103001 * r1.w;
      } else {
        r2.w = cmp(r0.w < r5.y);
        r3.w = log2(cb0[4].x);
        r4.w = 0.30103001 * r3.w;
        r5.x = cmp(r5.y < r4.w);
        r2.w = r2.w ? r5.x : 0;
        if (r2.w != 0) {
          r2.w = r0.y * 0.30103001 + -r0.w;
          r2.w = 3 * r2.w;
          r3.w = r3.w * 0.30103001 + -r0.w;
          r2.w = r2.w / r3.w;
          r3.w = (int)r2.w;
          r5.x = trunc(r2.w);
          r7.y = -r5.x + r2.w;
          r8.xyzw = cmp((int4)r3.wwww == int4(3, 2, 1, 0));
          r5.xw = cmp((int2)r3.ww == int2(4, 5));
          r8.xyzw = r8.xyzw ? float4(1, 1, 1, 1) : 0;
          r5.xw = r5.xw ? float2(1, 1) : 0;
          r2.w = dot(r8.wzyx, cb0[5].xyzw);
          r2.w = r5.x * cb0[7].x + r2.w;
          r8.x = r5.w * cb0[7].x + r2.w;
          r9.xyzw = (int4)r3.wwww + int4(1, 1, 2, 2);
          r10.xyzw = cmp((int4)r9.yyyy == int4(3, 2, 1, 0));
          r11.xyzw = cmp((int4)r9.xyzw == int4(4, 5, 4, 5));
          r10.xyzw = r10.xyzw ? float4(1, 1, 1, 1) : 0;
          r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
          r2.w = dot(r10.wzyx, cb0[5].xyzw);
          r2.w = r11.x * cb0[7].x + r2.w;
          r8.y = r11.y * cb0[7].x + r2.w;
          r9.xyzw = cmp((int4)r9.wwww == int4(3, 2, 1, 0));
          r9.xyzw = r9.xyzw ? float4(1, 1, 1, 1) : 0;
          r2.w = dot(r9.wzyx, cb0[5].xyzw);
          r2.w = r11.z * cb0[7].x + r2.w;
          r8.z = r11.w * cb0[7].x + r2.w;
          r7.x = r7.y * r7.y;
          r9.x = dot(r8.xzy, float3(0.5, 0.5, -1));
          r9.y = dot(r8.xy, float2(-1, 1));
          r9.z = dot(r8.xy, float2(0.5, 0.5));
          r7.z = 1;
          r1.w = dot(r7.xyz, r9.xyz);
        } else {
          r2.w = cmp(r5.y >= r4.w);
          r3.w = log2(cb0[3].z);
          r5.x = 0.30103001 * r3.w;
          r5.x = cmp(r5.y < r5.x);
          r2.w = r2.w ? r5.x : 0;
          if (r2.w != 0) {
            r0.y = r0.y * 0.30103001 + -r4.w;
            r0.y = 3 * r0.y;
            r2.w = r3.w * 0.30103001 + -r4.w;
            r0.y = r0.y / r2.w;
            r2.w = (int)r0.y;
            r3.w = trunc(r0.y);
            r7.y = -r3.w + r0.y;
            r8.xyzw = cmp((int4)r2.wwww == int4(3, 2, 1, 0));
            r5.xy = cmp((int2)r2.ww == int2(4, 5));
            r8.xyzw = r8.xyzw ? float4(1, 1, 1, 1) : 0;
            r5.xy = r5.xy ? float2(1, 1) : 0;
            r0.y = dot(r8.wzyx, cb0[6].xyzw);
            r0.y = r5.x * cb0[7].y + r0.y;
            r8.x = r5.y * cb0[7].y + r0.y;
            r9.xyzw = (int4)r2.wwww + int4(1, 1, 2, 2);
            r10.xyzw = cmp((int4)r9.yyyy == int4(3, 2, 1, 0));
            r11.xyzw = cmp((int4)r9.xyzw == int4(4, 5, 4, 5));
            r10.xyzw = r10.xyzw ? float4(1, 1, 1, 1) : 0;
            r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
            r0.y = dot(r10.wzyx, cb0[6].xyzw);
            r0.y = r11.x * cb0[7].y + r0.y;
            r8.y = r11.y * cb0[7].y + r0.y;
            r9.xyzw = cmp((int4)r9.wwww == int4(3, 2, 1, 0));
            r9.xyzw = r9.xyzw ? float4(1, 1, 1, 1) : 0;
            r0.y = dot(r9.wzyx, cb0[6].xyzw);
            r0.y = r11.z * cb0[7].y + r0.y;
            r8.z = r11.w * cb0[7].y + r0.y;
            r7.x = r7.y * r7.y;
            r9.x = dot(r8.xzy, float3(0.5, 0.5, -1));
            r9.y = dot(r8.xy, float2(-1, 1));
            r9.z = dot(r8.xy, float2(0.5, 0.5));
            r7.z = 1;
            r1.w = dot(r7.xyz, r9.xyz);
          } else {
            r0.y = log2(cb0[3].w);
            r1.w = 0.30103001 * r0.y;
          }
        }
      }
      r0.y = 3.32192802 * r1.w;
      r0.y = exp2(r0.y);
      if (r6.z != 0) {
        r1.w = log2(cb0[3].y);
        r1.w = 0.30103001 * r1.w;
      } else {
        r2.w = cmp(r0.w < r5.z);
        r3.w = log2(cb0[4].x);
        r4.w = 0.30103001 * r3.w;
        r5.x = cmp(r5.z < r4.w);
        r2.w = r2.w ? r5.x : 0;
        if (r2.w != 0) {
          r2.w = r0.z * 0.30103001 + -r0.w;
          r2.w = 3 * r2.w;
          r0.w = r3.w * 0.30103001 + -r0.w;
          r0.w = r2.w / r0.w;
          r2.w = (int)r0.w;
          r3.w = trunc(r0.w);
          r6.y = -r3.w + r0.w;
          r7.xyzw = cmp((int4)r2.wwww == int4(3, 2, 1, 0));
          r5.xy = cmp((int2)r2.ww == int2(4, 5));
          r7.xyzw = r7.xyzw ? float4(1, 1, 1, 1) : 0;
          r5.xy = r5.xy ? float2(1, 1) : 0;
          r0.w = dot(r7.wzyx, cb0[5].xyzw);
          r0.w = r5.x * cb0[7].x + r0.w;
          r7.x = r5.y * cb0[7].x + r0.w;
          r8.xyzw = (int4)r2.wwww + int4(1, 1, 2, 2);
          r9.xyzw = cmp((int4)r8.yyyy == int4(3, 2, 1, 0));
          r10.xyzw = cmp((int4)r8.xyzw == int4(4, 5, 4, 5));
          r9.xyzw = r9.xyzw ? float4(1, 1, 1, 1) : 0;
          r10.xyzw = r10.xyzw ? float4(1, 1, 1, 1) : 0;
          r0.w = dot(r9.wzyx, cb0[5].xyzw);
          r0.w = r10.x * cb0[7].x + r0.w;
          r7.y = r10.y * cb0[7].x + r0.w;
          r8.xyzw = cmp((int4)r8.wwww == int4(3, 2, 1, 0));
          r8.xyzw = r8.xyzw ? float4(1, 1, 1, 1) : 0;
          r0.w = dot(r8.wzyx, cb0[5].xyzw);
          r0.w = r10.z * cb0[7].x + r0.w;
          r7.z = r10.w * cb0[7].x + r0.w;
          r6.x = r6.y * r6.y;
          r8.x = dot(r7.xzy, float3(0.5, 0.5, -1));
          r8.y = dot(r7.xy, float2(-1, 1));
          r8.z = dot(r7.xy, float2(0.5, 0.5));
          r6.z = 1;
          r1.w = dot(r6.xyz, r8.xyz);
        } else {
          r0.w = cmp(r5.z >= r4.w);
          r2.w = log2(cb0[3].z);
          r3.w = 0.30103001 * r2.w;
          r3.w = cmp(r5.z < r3.w);
          r0.w = r0.w ? r3.w : 0;
          if (r0.w != 0) {
            r0.z = r0.z * 0.30103001 + -r4.w;
            r0.z = 3 * r0.z;
            r0.w = r2.w * 0.30103001 + -r4.w;
            r0.z = r0.z / r0.w;
            r0.w = (int)r0.z;
            r2.w = trunc(r0.z);
            r5.y = -r2.w + r0.z;
            r6.xyzw = cmp((int4)r0.wwww == int4(3, 2, 1, 0));
            r7.xy = cmp((int2)r0.ww == int2(4, 5));
            r6.xyzw = r6.xyzw ? float4(1, 1, 1, 1) : 0;
            r7.xy = r7.xy ? float2(1, 1) : 0;
            r0.z = dot(r6.wzyx, cb0[6].xyzw);
            r0.z = r7.x * cb0[7].y + r0.z;
            r6.x = r7.y * cb0[7].y + r0.z;
            r7.xyzw = (int4)r0.wwww + int4(1, 1, 2, 2);
            r8.xyzw = cmp((int4)r7.yyyy == int4(3, 2, 1, 0));
            r9.xyzw = cmp((int4)r7.xyzw == int4(4, 5, 4, 5));
            r8.xyzw = r8.xyzw ? float4(1, 1, 1, 1) : 0;
            r9.xyzw = r9.xyzw ? float4(1, 1, 1, 1) : 0;
            r0.z = dot(r8.wzyx, cb0[6].xyzw);
            r0.z = r9.x * cb0[7].y + r0.z;
            r6.y = r9.y * cb0[7].y + r0.z;
            r7.xyzw = cmp((int4)r7.wwww == int4(3, 2, 1, 0));
            r7.xyzw = r7.xyzw ? float4(1, 1, 1, 1) : 0;
            r0.z = dot(r7.wzyx, cb0[6].xyzw);
            r0.z = r9.z * cb0[7].y + r0.z;
            r6.z = r9.w * cb0[7].y + r0.z;
            r5.x = r5.y * r5.y;
            r7.x = dot(r6.xzy, float3(0.5, 0.5, -1));
            r7.y = dot(r6.xy, float2(-1, 1));
            r7.z = dot(r6.xy, float2(0.5, 0.5));
            r5.z = 1;
            r1.w = dot(r5.xyz, r7.xyz);
          } else {
            r0.z = log2(cb0[3].w);
            r1.w = 0.30103001 * r0.z;
          }
        }
      }
      r0.z = 3.32192802 * r1.w;
      r0.z = exp2(r0.z);
      r0.x = -cb0[3].y + r0.x;
      r0.w = cb0[3].w + -cb0[3].y;
      r5.x = r0.x / r0.w;
      r0.x = -cb0[3].y + r0.y;
      r5.y = r0.x / r0.w;
      r0.x = -cb0[3].y + r0.z;
      r5.z = r0.x / r0.w;
      r0.x = dot(float3(0.662454188, 0.134004205, 0.156187683), r5.xyz);
      r0.y = dot(float3(0.272228718, 0.674081743, 0.0536895171), r5.xyz);
      r0.z = dot(float3(-0.00557464967, 0.0040607336, 1.01033914), r5.xyz);
      r5.x = saturate(dot(float3(1.6410234, -0.324803293, -0.236424699), r0.xyz));
      r5.y = saturate(dot(float3(-0.663662851, 1.61533165, 0.0167563483), r0.xyz));
      r5.z = saturate(dot(float3(0.0117218941, -0.00828444213, 0.988394856), r0.xyz));
      r0.x = dot(float3(0.662454188, 0.134004205, 0.156187683), r5.xyz);
      r0.y = dot(float3(0.272228718, 0.674081743, 0.0536895171), r5.xyz);
      r0.z = dot(float3(-0.00557464967, 0.0040607336, 1.01033914), r5.xyz);
      r5.x = dot(float3(1.6410234, -0.324803293, -0.236424699), r0.xyz);
      r5.y = dot(float3(-0.663662851, 1.61533165, 0.0167563483), r0.xyz);
      r5.z = dot(float3(0.0117218941, -0.00828444213, 0.988394856), r0.xyz);
      r0.xyz = max(float3(0, 0, 0), r5.xyz);
      r0.xyz = cb0[3].www * r0.xyz;
      r0.xyz = max(float3(0, 0, 0), r0.xyz);
      r0.xyz = min(float3(65535, 65535, 65535), r0.xyz);
      r0.w = cmp(asint(cb0[2].x) != 6);
      r3.x = dot(r3.xyz, r0.xyz);
      r3.y = dot(r4.xyz, r0.xyz);
      r3.z = dot(r2.xyz, r0.xyz);
      r0.xyz = r0.www ? r3.xyz : r0.xyz;
      r0.xyz = float3(9.99999975e-05, 9.99999975e-05, 9.99999975e-05) * r0.xyz;
      r0.xyz = log2(r0.xyz);
      r0.xyz = float3(0.159301758, 0.159301758, 0.159301758) * r0.xyz;
      r0.xyz = exp2(r0.xyz);
      r2.xyz = r0.xyz * float3(18.8515625, 18.8515625, 18.8515625) + float3(0.8359375, 0.8359375, 0.8359375);
      r0.xyz = r0.xyz * float3(18.6875, 18.6875, 18.6875) + float3(1, 1, 1);
      r0.xyz = rcp(r0.xyz);
      r0.xyz = r2.xyz * r0.xyz;
      r0.xyz = log2(r0.xyz);
      r0.xyz = float3(78.84375, 78.84375, 78.84375) * r0.xyz;
      r1.xyz = exp2(r0.xyz);
    } else {
      r1.xy = v0.xy * float2(1.03225803, 1.03225803) + float2(-0.0161290318, -0.0161290318);
    }
  }
  o0.xyz = float3(0.952381015, 0.952381015, 0.952381015) * r1.xyz;
  o0.w = 0;
  return;
}