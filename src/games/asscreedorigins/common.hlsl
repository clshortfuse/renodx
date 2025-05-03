#include "./shared.h"
#define cmp -

float3 HueCorrectAP1(float3 incorrect_color_ap1, float3 correct_color_ap1, float hue_correct_strength = 0.5f) {
  float3 incorrect_color_bt709 = renodx::color::bt709::from::AP1(incorrect_color_ap1);
  float3 correct_color_bt709 = renodx::color::bt709::from::AP1(correct_color_ap1);

  float3 corrected_color_bt709 = renodx::color::correct::Hue(incorrect_color_bt709, correct_color_bt709, hue_correct_strength, 0u);
  float3 corrected_color_ap1 = renodx::color::ap1::from::BT709(corrected_color_bt709);
  return corrected_color_ap1;
}

float3 ApplyToneMapEncodePQ(float3 untonemapped_ap1, float peak_nits, float diffuse_white_nits) {
  float3 untonemapped_bt709 = renodx::color::bt709::from::AP1(untonemapped_ap1);

  const float ACES_MIN = 0.0001f;
  float aces_min = ACES_MIN / diffuse_white_nits;
  float aces_max = (peak_nits / diffuse_white_nits);

#if RENODX_GAME_GAMMA_CORRECTION
  aces_max = renodx::color::correct::Gamma(aces_max, true);
  aces_min = renodx::color::correct::Gamma(aces_min, true);
#endif

  float3 tonemapped_ap1 = renodx::tonemap::aces::RRTAndODT(untonemapped_bt709, aces_min * 48.f, aces_max * 48.f, renodx::color::IDENTITY_MAT) / 48.f;

#if HUE_CORRECTION
  float3 tonemapped_hue_corrected_ap1 = HueCorrectAP1(tonemapped_ap1, untonemapped_ap1);
  tonemapped_ap1 = lerp(tonemapped_hue_corrected_ap1, tonemapped_ap1, saturate(tonemapped_hue_corrected_ap1));
#endif
  float3 tonemapped_bt709 = renodx::color::bt709::from::AP1(tonemapped_ap1);

#if RENODX_GAME_GAMMA_CORRECTION
  tonemapped_bt709 = renodx::color::correct::GammaSafe(tonemapped_bt709);
#endif

  float3 pq_color = renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(tonemapped_bt709), diffuse_white_nits);

  return pq_color;
}



float3 ApplyToneMap(float3 untonemapped_ap1, float peak_nits, float diffuse_white_nits) {
  float3 untonemapped_bt709 = renodx::color::bt709::from::AP1(untonemapped_ap1);

  const float ACES_MID_GRAY = 0.10f;
  const float ACES_MIN = 0.0001f;
  float aces_min = ACES_MIN / diffuse_white_nits;
  float aces_max = (peak_nits / diffuse_white_nits);

#if RENODX_GAME_GAMMA_CORRECTION
  aces_max = renodx::color::correct::Gamma(aces_max, true);
  aces_min = renodx::color::correct::Gamma(aces_min, true);
#endif

  float3 tonemapped = renodx::tonemap::aces::RRTAndODT(untonemapped_bt709, aces_min * 48.f, aces_max * 48.f);
  tonemapped /= 48.f;

#if RENODX_GAME_GAMMA_CORRECTION
  tonemapped = renodx::color::correct::GammaSafe(tonemapped);
#endif

  return tonemapped;
}

float CalculatePaperWhiteExposureCompensation(float paper_white) {
  float x = paper_white;
  float exposure = 0.3849059f
                   - 0.0007877044f * x
                   + 5.215512e-7f * x * x;
  return lerp(1.0f, exposure, CUSTOM_EXPOSURE_COMPENSATION);
}

float CalculatePaperWhiteContrastCompensation(float paper_white) {
  float contrast = mad(-0.0002f, paper_white, 0.92f);
  return lerp(1.0f, contrast, CUSTOM_CONTRAST_COMPENSATION);
}

float3 ApplyVanillaToneMapEncodePQ(float3 untonemapped_ap1, float peak_nits) {
  const float4 icb[] = { { -4.000000, -0.718548, -1.698970, 0.515439 },
                         { -4.000000, 2.081031, -1.698970, 0.847044 },
                         { -3.157377, 3.668124, -1.477900, 1.135800 },
                         { -0.485250, 4.000000, -1.229100, 1.380200 },
                         { 1.847732, 4.000000, -0.864800, 1.519700 },
                         { 0, 0, -0.448000, 1.598500 },
                         { 0, 0, 0.005180, 1.646700 },
                         { 0, 0, 0.451108, 1.674609 },
                         { 0, 0, 0.911374, 1.687873 } };
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12;
  r0.xyz = untonemapped_ap1;

  r1.z = dot(r0.xyz, float3(0.695452213, 0.140678659, 0.163869068));
  r1.y = dot(r0.xyz, float3(0.0447945744, 0.859670997, 0.0955343246));
  r1.x = dot(r0.xyz, float3(-0.00552586792, 0.00402521156, 1.00150073));
  r0.x = max(r1.y, r1.x);
  r0.x = max(r1.z, r0.x);
  r0.z = min(r1.y, r1.x);
  r0.z = min(r1.z, r0.z);
  r0.xyz = max(float3(1.00000001e-10, 0.00999999978, 1.00000001e-10), r0.xxz);
  r0.x = r0.x + -r0.z;
  r0.x = r0.x / r0.y;
  r0.yzw = r1.xyz + -r1.yzx;
  r0.yz = r1.xy * r0.yz;
  r0.y = r0.y + r0.z;
  r0.y = r1.z * r0.w + r0.y;
  r0.y = max(0, r0.y);
  r0.y = sqrt(r0.y);
  r0.z = r1.x + r1.y;
  r0.z = r0.z + r1.z;
  r0.y = r0.y * 1.75 + r0.z;
  r0.w = -0.400000006 + r0.x;
  r1.w = 2.5 * r0.w;
  r1.w = 1 + -abs(r1.w);
  r1.w = max(0, r1.w);
  r2.x = cmp(r0.w < 0);
  r0.w = cmp(0 < r0.w);
  r0.w = r0.w ? 1.000000 : 0;
  r0.w = r2.x ? -1 : r0.w;
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
  r2.xyz = r0.yyy * r1.xyz;
  r0.zw = cmp(r2.yx == r2.zy);
  r0.z = r0.w ? r0.z : 0;
  r0.w = r0.y * r1.y + -r2.x;
  r0.w = 1.73205078 * r0.w;
  r1.y = r2.z * 2 + -r2.y;
  r1.x = -r0.y * r1.x + r1.y;
  r1.y = min(abs(r1.x), abs(r0.w));
  r1.w = max(abs(r1.x), abs(r0.w));
  r1.w = 1 / r1.w;
  r1.y = r1.y * r1.w;
  r1.w = r1.y * r1.y;
  r2.w = r1.w * 0.0208350997 + -0.0851330012;
  r2.w = r1.w * r2.w + 0.180141002;
  r2.w = r1.w * r2.w + -0.330299497;
  r1.w = r1.w * r2.w + 0.999866009;
  r2.w = r1.y * r1.w;
  r3.x = cmp(abs(r1.x) < abs(r0.w));
  r2.w = r2.w * -2 + 1.57079637;
  r2.w = r3.x ? r2.w : 0;
  r1.y = r1.y * r1.w + r2.w;
  r1.w = cmp(r1.x < -r1.x);
  r1.w = r1.w ? -3.141593 : 0;
  r1.y = r1.y + r1.w;
  r1.w = min(r1.x, r0.w);
  r0.w = max(r1.x, r0.w);
  r1.x = cmp(r1.w < -r1.w);
  r0.w = cmp(r0.w >= -r0.w);
  r0.w = r0.w ? r1.x : 0;
  r0.w = r0.w ? -r1.y : r1.y;
  r0.w = 57.2957802 * r0.w;
  r0.z = r0.z ? 0xffc10000 : r0.w;
  r0.w = cmp(r0.z < 0);
  r1.x = 360 + r0.z;
  r0.z = r0.w ? r1.x : r0.z;
  r0.w = cmp(r0.z < -180);
  r1.x = cmp(180 < r0.z);
  r1.yw = float2(360, -360) + r0.zz;
  r0.z = r1.x ? r1.w : r0.z;
  r0.z = r0.w ? r1.y : r0.z;
  r0.w = cmp(-67.5 < r0.z);
  r1.x = cmp(r0.z < 67.5);
  r0.w = r0.w ? r1.x : 0;
  if (r0.w != 0) {
    r0.z = 67.5 + r0.z;
    r0.w = 0.0296296291 * r0.z;
    r1.x = (int)r0.w;
    r0.w = trunc(r0.w);
    r0.z = r0.z * 0.0296296291 + -r0.w;
    r0.w = r0.z * r0.z;
    r1.y = r0.w * r0.z;
    r3.xyz = float3(-0.166666672, -0.5, 0.166666672) * r1.yyy;
    r3.xy = r0.ww * float2(0.5, 0.5) + r3.xy;
    r3.xy = r0.zz * float2(-0.5, 0.5) + r3.xy;
    r0.z = r1.y * 0.5 + -r0.w;
    r0.z = 0.666666687 + r0.z;
    r4.xyz = cmp((int3)r1.xxx == int3(3, 2, 1));
    r1.yw = float2(0.166666672, 0.166666672) + r3.xy;
    r0.w = r1.x ? 0 : r3.z;
    r0.w = r4.z ? r1.w : r0.w;
    r0.z = r4.y ? r0.z : r0.w;
    r0.z = r4.x ? r1.y : r0.z;
  } else {
    r0.z = 0;
  }
  r0.x = r0.z * r0.x;
  r0.x = 1.5 * r0.x;
  r0.y = -r0.y * r1.z + 0.0299999993;
  r0.x = r0.x * r0.y;
  r0.x = r0.x * 0.180000007 + r2.z;
  r0.x = min(65520, r0.x);
  r0.x = max(0, r0.x);
  r1.xy = min(float2(65520, 65520), r2.yx);
  r0.yz = max(float2(0, 0), r1.xy);
  r0.w = dot(r0.xyz, float3(1.45143938, -0.236510724, -0.214928553));
  r1.x = dot(r0.xyz, float3(-0.0765537992, 1.17622995, -0.0996759459));
  r0.x = dot(r0.xyz, float3(0.00831612758, -0.00603244733, 0.997716188));
  r0.xy = min(float2(65504, 65504), r0.xw);
  r2.x = max(0, r0.y);
  r0.y = min(65504, r1.x);
  r2.yz = max(float2(0, 0), r0.yx);
  r0.x = dot(r2.xyz, float3(0.970889151, 0.0269632787, 0.00214758189));
  r0.y = dot(r2.xyz, float3(0.0108891558, 0.986963272, 0.00214758189));
  r0.z = dot(r2.xyz, float3(0.0108891558, 0.0269632787, 0.962147534));
  r0.x = max(5.96046448e-08, r0.x);
  r0.x = log2(r0.x);
  r0.w = cmp(-17.4739304 >= r0.x);
  if (r0.w != 0) {
    r0.w = -4;
  } else {
    r1.x = cmp(r0.x < -2.47393107);
    if (r1.x != 0) {
      r1.x = r0.x * 0.30103001 + 5.26017714;
      r1.y = 0.664385676 * r1.x;
      r1.z = (int)r1.y;
      r1.y = trunc(r1.y);
      r2.y = r1.x * 0.664385676 + -r1.y;
      r1.xy = (int2)r1.zz + int2(1, 2);
      r2.x = r2.y * r2.y;
      r3.x = icb[r1.z + 0].x;
      r3.y = icb[r1.x + 0].x;
      r3.z = icb[r1.y + 0].x;
      r1.x = dot(r3.xzy, float3(0.5, 0.5, -1));
      r1.y = dot(r3.xy, float2(-1, 1));
      r1.z = dot(r3.xy, float2(0.5, 0.5));
      r2.z = 1;
      r0.w = dot(r2.xyz, r1.xyz);
    } else {
      r1.x = cmp(r0.x < 15.5260687);
      if (r1.x != 0) {
        r0.x = r0.x * 0.30103001 + 0.744727433;
        r1.x = 0.553654671 * r0.x;
        r1.y = (int)r1.x;
        r1.x = trunc(r1.x);
        r2.y = r0.x * 0.553654671 + -r1.x;
        r1.xz = (int2)r1.yy + int2(1, 2);
        r2.x = r2.y * r2.y;
        r3.x = icb[r1.y + 0].y;
        r3.y = icb[r1.x + 0].y;
        r3.z = icb[r1.z + 0].y;
        r1.x = dot(r3.xzy, float3(0.5, 0.5, -1));
        r1.y = dot(r3.xy, float2(-1, 1));
        r1.z = dot(r3.xy, float2(0.5, 0.5));
        r2.z = 1;
        r0.w = dot(r2.xyz, r1.xyz);
      } else {
        r0.w = 4;
      }
    }
  }
  r0.x = 3.32192802 * r0.w;
  r1.x = exp2(r0.x);
  r0.x = max(5.96046448e-08, r0.y);
  r0.x = log2(r0.x);
  r0.y = cmp(-17.4739304 >= r0.x);
  if (r0.y != 0) {
    r0.y = -4;
  } else {
    r0.w = cmp(r0.x < -2.47393107);
    if (r0.w != 0) {
      r0.w = r0.x * 0.30103001 + 5.26017714;
      r1.w = 0.664385676 * r0.w;
      r2.x = (int)r1.w;
      r1.w = trunc(r1.w);
      r3.y = r0.w * 0.664385676 + -r1.w;
      r2.yz = (int2)r2.xx + int2(1, 2);
      r3.x = r3.y * r3.y;
      r4.x = icb[r2.x + 0].x;
      r4.y = icb[r2.y + 0].x;
      r4.z = icb[r2.z + 0].x;
      r2.x = dot(r4.xzy, float3(0.5, 0.5, -1));
      r2.y = dot(r4.xy, float2(-1, 1));
      r2.z = dot(r4.xy, float2(0.5, 0.5));
      r3.z = 1;
      r0.y = dot(r3.xyz, r2.xyz);
    } else {
      r0.w = cmp(r0.x < 15.5260687);
      if (r0.w != 0) {
        r0.x = r0.x * 0.30103001 + 0.744727433;
        r0.w = 0.553654671 * r0.x;
        r1.w = (int)r0.w;
        r0.w = trunc(r0.w);
        r2.y = r0.x * 0.553654671 + -r0.w;
        r0.xw = (int2)r1.ww + int2(1, 2);
        r2.x = r2.y * r2.y;
        r3.x = icb[r1.w + 0].y;
        r3.y = icb[r0.x + 0].y;
        r3.z = icb[r0.w + 0].y;
        r4.x = dot(r3.xzy, float3(0.5, 0.5, -1));
        r4.y = dot(r3.xy, float2(-1, 1));
        r4.z = dot(r3.xy, float2(0.5, 0.5));
        r2.z = 1;
        r0.y = dot(r2.xyz, r4.xyz);
      } else {
        r0.y = 4;
      }
    }
  }
  r0.x = 3.32192802 * r0.y;
  r1.y = exp2(r0.x);
  r0.x = max(5.96046448e-08, r0.z);
  r0.x = log2(r0.x);
  r0.y = cmp(-17.4739304 >= r0.x);
  if (r0.y != 0) {
    r0.y = -4;
  } else {
    r0.z = cmp(r0.x < -2.47393107);
    if (r0.z != 0) {
      r0.z = r0.x * 0.30103001 + 5.26017714;
      r0.w = 0.664385676 * r0.z;
      r1.w = (int)r0.w;
      r0.w = trunc(r0.w);
      r2.y = r0.z * 0.664385676 + -r0.w;
      r0.zw = (int2)r1.ww + int2(1, 2);
      r2.x = r2.y * r2.y;
      r3.x = icb[r1.w + 0].x;
      r3.y = icb[r0.z + 0].x;
      r3.z = icb[r0.w + 0].x;
      r4.x = dot(r3.xzy, float3(0.5, 0.5, -1));
      r4.y = dot(r3.xy, float2(-1, 1));
      r4.z = dot(r3.xy, float2(0.5, 0.5));
      r2.z = 1;
      r0.y = dot(r2.xyz, r4.xyz);
    } else {
      r0.z = cmp(r0.x < 15.5260687);
      if (r0.z != 0) {
        r0.x = r0.x * 0.30103001 + 0.744727433;
        r0.z = 0.553654671 * r0.x;
        r0.w = (int)r0.z;
        r0.z = trunc(r0.z);
        r2.y = r0.x * 0.553654671 + -r0.z;
        r0.xz = (int2)r0.ww + int2(1, 2);
        r2.x = r2.y * r2.y;
        r3.x = icb[r0.w + 0].y;
        r3.y = icb[r0.x + 0].y;
        r3.z = icb[r0.z + 0].y;
        r4.x = dot(r3.xzy, float3(0.5, 0.5, -1));
        r4.y = dot(r3.xy, float2(-1, 1));
        r4.z = dot(r3.xy, float2(0.5, 0.5));
        r2.z = 1;
        r0.y = dot(r2.xyz, r4.xyz);
      } else {
        r0.y = 4;
      }
    }
  }
  r0.x = 3.32192802 * r0.y;
  r1.z = exp2(r0.x);
  r0.x = dot(r1.xyz, float3(0.695452213, 0.140678659, 0.163869068));
  r0.y = dot(r1.xyz, float3(0.0447945744, 0.859670997, 0.0955343246));
  r0.z = dot(r1.xyz, float3(-0.00552586792, 0.00402521156, 1.00150073));
  r0.w = dot(r0.xyz, float3(1.45143938, -0.236510724, -0.214928553));
  r1.x = dot(r0.xyz, float3(-0.0765537992, 1.17622995, -0.0996759459));
  r1.y = dot(r0.xyz, float3(0.00831612758, -0.00603244733, 0.997716188));
  r1.z = cmp(peak_nits >= 4000);
  if (r1.z != 0) {
    r2.xyzw = float4(-2.30102992, -2.30102992, -1.93120003, -1.52049994);
    r3.xyzw = float4(-1.05780005, -0.466800004, 0.119379997, 0.708813429);
    r4.xyzw = float4(1.29118657, 0.797318637, 1.2026813, 1.60930002);
    r5.xyzw = float4(2.01079988, 2.41479993, 2.81789994, 3.1724999);
    r6.xyzw = float4(0.000141798722, 0.00499999989, 6824.36377, 4000);
    r7.xyz = float3(3.53449965, 3.66962051, 0.300000012);
  } else {
    r1.z = cmp(peak_nits >= 2000);
    if (r1.z != 0) {
      r1.z = -2000 + peak_nits;
      r1.z = saturate(0.000500000024 * r1.z);
      r4.yzw = r1.zzz * float3(-0.00467658043, 0.00467646122, 0.0149999857) + float3(0.801995218, 1.19800484, 1.59430003);
      r7.xyz = r1.zzz * float3(1052.5, 2000, 0.180000007) + float3(5771.86377, 2000, 0.119999997);
      r2.xyzw = float4(-2.30102992, -2.30102992, -1.93120003, -1.52049994);
      r3.xyzw = float4(-1.05780005, -0.466800004, 0.119379997, 0.708813429);
      r4.x = 1.29118657;
      r5.xyzw = r1.zzzz * float4(0.013499856, 0.0364999771, 0.0494999886, 0.120999813) + float4(1.99730003, 2.37829995, 2.76839995, 3.05150008);
      r6.xy = float2(0.000141798722, 0.00499999989);
      r6.zw = r7.xy;
      r7.xy = r1.zz * float2(0.259870291, 0.342189789) + float2(3.27462935, 3.32743073);
    } else {
      r1.z = cmp(peak_nits >= 1000);
      if (r1.z != 0) {
        r1.z = -1000 + peak_nits;
        r1.z = saturate(0.00100000005 * r1.z);
        r4.yzw = r1.zzz * float3(-0.0069180131, 0.0069180727, 0.0260000229) + float3(0.808913231, 1.19108677, 1.56830001);
        r7.xyz = r1.zzz * float3(1266.78467, 1000, 0.0599999987) + float3(4505.0791, 1000, 0.0599999987);
        r2.xyzw = float4(-2.30102992, -2.30102992, -1.93120003, -1.52049994);
        r3.xyzw = float4(-1.05780005, -0.466800004, 0.119379997, 0.708813429);
        r4.x = 1.29118657;
        r5.xyzw = r1.zzzz * float4(0.0490000248, 0.0699999332, 0.129999876, 0.192000151) + float4(1.9483, 2.30830002, 2.63840008, 2.85949993);
        r6.xy = float2(0.000141798722, 0.00499999989);
        r6.zw = r7.xy;
        r7.xy = r1.zz * float2(0.287368536, 0.314691544) + float2(2.98726082, 3.01273918);
      } else {
        r1.z = cmp(peak_nits >= 48);
        if (r1.z != 0) {
          r1.z = -48 + peak_nits;
          r1.z = saturate(0.00105042022 * r1.z);
          r2.xyzw = r1.zzzz * float4(-0.60205996, -0.60205996, -0.453299999, -0.291399956) + float4(-1.69896996, -1.69896996, -1.47790003, -1.22909999);
          r3.xyzw = r1.zzzz * float4(-0.193000078, -0.0187999904, 0.114199996, 0.25770539) + float4(-0.864799976, -0.448000014, 0.00517999986, 0.451108038);
          r4.xyzw = r1.zzzz * float4(0.379812121, 0.293474555, 0.344043016, 0.432500005) + float4(0.91137445, 0.515438676, 0.847043753, 1.1358);
          r5.xyzw = r1.zzzz * float4(0.568099976, 0.788599968, 1.03990006, 1.21279991) + float4(1.38020003, 1.51970005, 1.59850001, 1.64670002);
          r6.xyzw = r1.zzzz * float4(-0.00273809489, -0.0149999997, 3499.36011, 952) + float4(0.00287989364, 0.0199999996, 1005.71893, 48);
          r7.xyz = r1.zzz * float3(1.31265163, 1.32486582, 0.0199999996) + float3(1.67460918, 1.68787336, 0.0399999991);
        } else {
          r2.xyzw = float4(-1.69896996, -1.69896996, -1.47790003, -1.22909999);
          r3.xyzw = float4(-0.864799976, -0.448000014, 0.00517999986, 0.451108038);
          r4.xyzw = float4(0.91137445, 0.515438676, 0.847043753, 1.1358);
          r5.xyzw = float4(1.38020003, 1.51970005, 1.59850001, 1.64670002);
          r6.xyzw = float4(0.00287989364, 0.0199999996, 1005.71893, 48);
          r7.xyz = float3(1.67460918, 1.68787336, 0.0399999991);
        }
      }
    }
  }
  r0.w = max(5.96046448e-08, r0.w);
  r0.w = log2(r0.w);
  r1.z = 0.30103001 * r0.w;
  r1.w = log2(r6.x);
  r6.x = 0.30103001 * r1.w;
  r7.w = cmp(r6.x >= r1.z);
  if (r7.w != 0) {
    r7.w = log2(r6.y);
    r7.w = 0.30103001 * r7.w;
  } else {
    r8.x = cmp(r0.w < 2.26303411);
    if (r8.x != 0) {
      r8.x = r0.w * 0.30103001 + -r6.x;
      r8.x = 7 * r8.x;
      r8.y = -r1.w * 0.30103001 + 0.681241155;
      r8.x = r8.x / r8.y;
      r8.y = (int)r8.x;
      r8.z = trunc(r8.x);
      r9.y = r8.x + -r8.z;
      r10.xyzw = cmp((int4)r8.yyyy == int4(3, 2, 1, 0));
      r11.xyzw = cmp((int4)r8.yyyy == int4(4, 5, 6, 7));
      r8.x = cmp((int)r8.y == 8);
      r10.xyzw = r10.xyzw ? float4(1, 1, 1, 1) : 0;
      r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
      r8.x = r8.x ? 1.000000 : 0;
      r8.z = dot(r10.wzyx, r2.xyzw);
      r8.z = r11.x * r3.x + r8.z;
      r8.z = r11.y * r3.y + r8.z;
      r8.z = r11.z * r3.z + r8.z;
      r8.z = r11.w * r3.w + r8.z;
      r10.x = r8.x * r4.x + r8.z;
      r8.xy = (int2)r8.yy + int2(1, 2);
      r11.xyzw = cmp((int4)r8.xxxx == int4(3, 2, 1, 0));
      r12.xyzw = cmp((int4)r8.xxxx == int4(4, 5, 6, 7));
      r8.xz = cmp((int2)r8.xy == int2(8, 8));
      r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
      r12.xyzw = r12.xyzw ? float4(1, 1, 1, 1) : 0;
      r8.xz = r8.xz ? float2(1, 1) : 0;
      r8.w = dot(r11.wzyx, r2.xyzw);
      r8.w = r12.x * r3.x + r8.w;
      r8.w = r12.y * r3.y + r8.w;
      r8.w = r12.z * r3.z + r8.w;
      r8.w = r12.w * r3.w + r8.w;
      r10.y = r8.x * r4.x + r8.w;
      r11.xyzw = cmp((int4)r8.yyyy == int4(3, 2, 1, 0));
      r12.xyzw = cmp((int4)r8.yyyy == int4(4, 5, 6, 7));
      r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
      r12.xyzw = r12.xyzw ? float4(1, 1, 1, 1) : 0;
      r8.x = dot(r11.wzyx, r2.xyzw);
      r8.x = r12.x * r3.x + r8.x;
      r8.x = r12.y * r3.y + r8.x;
      r8.x = r12.z * r3.z + r8.x;
      r8.x = r12.w * r3.w + r8.x;
      r10.z = r8.z * r4.x + r8.x;
      r9.x = r9.y * r9.y;
      r8.x = dot(r10.xzy, float3(0.5, 0.5, -1));
      r8.y = dot(r10.xy, float2(-1, 1));
      r8.z = dot(r10.xy, float2(0.5, 0.5));
      r9.z = 1;
      r7.w = dot(r9.xyz, r8.xyz);
    } else {
      r8.x = log2(r6.z);
      r8.y = 0.30103001 * r8.x;
      r8.z = cmp(r1.z < r8.y);
      if (r8.z != 0) {
        r0.w = r0.w * 0.30103001 + -0.681241155;
        r0.w = 7 * r0.w;
        r8.x = r8.x * 0.30103001 + -0.681241155;
        r0.w = r0.w / r8.x;
        r8.x = (int)r0.w;
        r8.z = trunc(r0.w);
        r9.y = -r8.z + r0.w;
        r10.xyzw = cmp((int4)r8.xxxx == int4(0, 1, 2, 3));
        r11.xyzw = cmp((int4)r8.xxxx == int4(4, 5, 6, 7));
        r0.w = cmp((int)r8.x == 8);
        r10.xyzw = r10.xyzw ? float4(1, 1, 1, 1) : 0;
        r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
        r0.w = r0.w ? 1.000000 : 0;
        r8.z = dot(r10.xyz, r4.yzw);
        r8.z = r10.w * r5.x + r8.z;
        r8.z = r11.x * r5.y + r8.z;
        r8.z = r11.y * r5.z + r8.z;
        r8.z = r11.z * r5.w + r8.z;
        r8.z = r11.w * r7.x + r8.z;
        r10.x = r0.w * r7.y + r8.z;
        r8.xz = (int2)r8.xx + int2(1, 2);
        r11.xyzw = cmp((int4)r8.xxxx == int4(0, 1, 2, 3));
        r12.xyzw = cmp((int4)r8.xxxx == int4(4, 5, 6, 7));
        r8.xw = cmp((int2)r8.xz == int2(8, 8));
        r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
        r12.xyzw = r12.xyzw ? float4(1, 1, 1, 1) : 0;
        r8.xw = r8.xw ? float2(1, 1) : 0;
        r0.w = dot(r11.xyz, r4.yzw);
        r0.w = r11.w * r5.x + r0.w;
        r0.w = r12.x * r5.y + r0.w;
        r0.w = r12.y * r5.z + r0.w;
        r0.w = r12.z * r5.w + r0.w;
        r0.w = r12.w * r7.x + r0.w;
        r10.y = r8.x * r7.y + r0.w;
        r11.xyzw = cmp((int4)r8.zzzz == int4(0, 1, 2, 3));
        r12.xyzw = cmp((int4)r8.zzzz == int4(4, 5, 6, 7));
        r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
        r12.xyzw = r12.xyzw ? float4(1, 1, 1, 1) : 0;
        r0.w = dot(r11.xyz, r4.yzw);
        r0.w = r11.w * r5.x + r0.w;
        r0.w = r12.x * r5.y + r0.w;
        r0.w = r12.y * r5.z + r0.w;
        r0.w = r12.z * r5.w + r0.w;
        r0.w = r12.w * r7.x + r0.w;
        r10.z = r8.w * r7.y + r0.w;
        r9.x = r9.y * r9.y;
        r11.x = dot(r10.xzy, float3(0.5, 0.5, -1));
        r11.y = dot(r10.xy, float2(-1, 1));
        r11.z = dot(r10.xy, float2(0.5, 0.5));
        r9.z = 1;
        r7.w = dot(r9.xyz, r11.xyz);
      } else {
        r0.w = log2(r6.w);
        r8.x = r8.y * r7.z;
        r0.w = r0.w * 0.30103001 + -r8.x;
        r7.w = r1.z * r7.z + r0.w;
      }
    }
  }
  r0.w = 3.32192802 * r7.w;
  r0.w = exp2(r0.w);
  r1.xy = max(float2(5.96046448e-08, 5.96046448e-08), r1.xy);
  r1.x = log2(r1.x);
  r1.z = 0.30103001 * r1.x;
  r7.w = cmp(r6.x >= r1.z);
  if (r7.w != 0) {
    r7.w = log2(r6.y);
    r7.w = 0.30103001 * r7.w;
  } else {
    r8.x = cmp(r1.x < 2.26303411);
    if (r8.x != 0) {
      r8.x = r1.x * 0.30103001 + -r6.x;
      r8.x = 7 * r8.x;
      r8.y = -r1.w * 0.30103001 + 0.681241155;
      r8.x = r8.x / r8.y;
      r8.y = (int)r8.x;
      r8.z = trunc(r8.x);
      r9.y = r8.x + -r8.z;
      r10.xyzw = cmp((int4)r8.yyyy == int4(3, 2, 1, 0));
      r11.xyzw = cmp((int4)r8.yyyy == int4(4, 5, 6, 7));
      r8.x = cmp((int)r8.y == 8);
      r10.xyzw = r10.xyzw ? float4(1, 1, 1, 1) : 0;
      r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
      r8.x = r8.x ? 1.000000 : 0;
      r8.z = dot(r10.wzyx, r2.xyzw);
      r8.z = r11.x * r3.x + r8.z;
      r8.z = r11.y * r3.y + r8.z;
      r8.z = r11.z * r3.z + r8.z;
      r8.z = r11.w * r3.w + r8.z;
      r10.x = r8.x * r4.x + r8.z;
      r8.xy = (int2)r8.yy + int2(1, 2);
      r11.xyzw = cmp((int4)r8.xxxx == int4(3, 2, 1, 0));
      r12.xyzw = cmp((int4)r8.xxxx == int4(4, 5, 6, 7));
      r8.xz = cmp((int2)r8.xy == int2(8, 8));
      r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
      r12.xyzw = r12.xyzw ? float4(1, 1, 1, 1) : 0;
      r8.xz = r8.xz ? float2(1, 1) : 0;
      r8.w = dot(r11.wzyx, r2.xyzw);
      r8.w = r12.x * r3.x + r8.w;
      r8.w = r12.y * r3.y + r8.w;
      r8.w = r12.z * r3.z + r8.w;
      r8.w = r12.w * r3.w + r8.w;
      r10.y = r8.x * r4.x + r8.w;
      r11.xyzw = cmp((int4)r8.yyyy == int4(3, 2, 1, 0));
      r12.xyzw = cmp((int4)r8.yyyy == int4(4, 5, 6, 7));
      r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
      r12.xyzw = r12.xyzw ? float4(1, 1, 1, 1) : 0;
      r8.x = dot(r11.wzyx, r2.xyzw);
      r8.x = r12.x * r3.x + r8.x;
      r8.x = r12.y * r3.y + r8.x;
      r8.x = r12.z * r3.z + r8.x;
      r8.x = r12.w * r3.w + r8.x;
      r10.z = r8.z * r4.x + r8.x;
      r9.x = r9.y * r9.y;
      r8.x = dot(r10.xzy, float3(0.5, 0.5, -1));
      r8.y = dot(r10.xy, float2(-1, 1));
      r8.z = dot(r10.xy, float2(0.5, 0.5));
      r9.z = 1;
      r7.w = dot(r9.xyz, r8.xyz);
    } else {
      r8.x = log2(r6.z);
      r8.y = 0.30103001 * r8.x;
      r8.z = cmp(r1.z < r8.y);
      if (r8.z != 0) {
        r1.x = r1.x * 0.30103001 + -0.681241155;
        r1.x = 7 * r1.x;
        r8.x = r8.x * 0.30103001 + -0.681241155;
        r1.x = r1.x / r8.x;
        r8.x = (int)r1.x;
        r8.z = trunc(r1.x);
        r9.y = -r8.z + r1.x;
        r10.xyzw = cmp((int4)r8.xxxx == int4(0, 1, 2, 3));
        r11.xyzw = cmp((int4)r8.xxxx == int4(4, 5, 6, 7));
        r1.x = cmp((int)r8.x == 8);
        r10.xyzw = r10.xyzw ? float4(1, 1, 1, 1) : 0;
        r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
        r1.x = r1.x ? 1.000000 : 0;
        r8.z = dot(r10.xyz, r4.yzw);
        r8.z = r10.w * r5.x + r8.z;
        r8.z = r11.x * r5.y + r8.z;
        r8.z = r11.y * r5.z + r8.z;
        r8.z = r11.z * r5.w + r8.z;
        r8.z = r11.w * r7.x + r8.z;
        r10.x = r1.x * r7.y + r8.z;
        r8.xz = (int2)r8.xx + int2(1, 2);
        r11.xyzw = cmp((int4)r8.xxxx == int4(0, 1, 2, 3));
        r12.xyzw = cmp((int4)r8.xxxx == int4(4, 5, 6, 7));
        r8.xw = cmp((int2)r8.xz == int2(8, 8));
        r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
        r12.xyzw = r12.xyzw ? float4(1, 1, 1, 1) : 0;
        r8.xw = r8.xw ? float2(1, 1) : 0;
        r1.x = dot(r11.xyz, r4.yzw);
        r1.x = r11.w * r5.x + r1.x;
        r1.x = r12.x * r5.y + r1.x;
        r1.x = r12.y * r5.z + r1.x;
        r1.x = r12.z * r5.w + r1.x;
        r1.x = r12.w * r7.x + r1.x;
        r10.y = r8.x * r7.y + r1.x;
        r11.xyzw = cmp((int4)r8.zzzz == int4(0, 1, 2, 3));
        r12.xyzw = cmp((int4)r8.zzzz == int4(4, 5, 6, 7));
        r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
        r12.xyzw = r12.xyzw ? float4(1, 1, 1, 1) : 0;
        r1.x = dot(r11.xyz, r4.yzw);
        r1.x = r11.w * r5.x + r1.x;
        r1.x = r12.x * r5.y + r1.x;
        r1.x = r12.y * r5.z + r1.x;
        r1.x = r12.z * r5.w + r1.x;
        r1.x = r12.w * r7.x + r1.x;
        r10.z = r8.w * r7.y + r1.x;
        r9.x = r9.y * r9.y;
        r11.x = dot(r10.xzy, float3(0.5, 0.5, -1));
        r11.y = dot(r10.xy, float2(-1, 1));
        r11.z = dot(r10.xy, float2(0.5, 0.5));
        r9.z = 1;
        r7.w = dot(r9.xyz, r11.xyz);
      } else {
        r1.x = log2(r6.w);
        r8.x = r8.y * r7.z;
        r1.x = r1.x * 0.30103001 + -r8.x;
        r7.w = r1.z * r7.z + r1.x;
      }
    }
  }
  r1.x = 3.32192802 * r7.w;
  r1.x = exp2(r1.x);
  r1.y = log2(r1.y);
  r1.z = 0.30103001 * r1.y;
  r7.w = cmp(r6.x >= r1.z);
  if (r7.w != 0) {
    r6.y = log2(r6.y);
    r6.y = 0.30103001 * r6.y;
  } else {
    r7.w = cmp(r1.y < 2.26303411);
    if (r7.w != 0) {
      r6.x = r1.y * 0.30103001 + -r6.x;
      r6.x = 7 * r6.x;
      r1.w = -r1.w * 0.30103001 + 0.681241155;
      r1.w = r6.x / r1.w;
      r6.x = (int)r1.w;
      r7.w = trunc(r1.w);
      r8.y = -r7.w + r1.w;
      r9.xyzw = cmp((int4)r6.xxxx == int4(3, 2, 1, 0));
      r10.xyzw = cmp((int4)r6.xxxx == int4(4, 5, 6, 7));
      r1.w = cmp((int)r6.x == 8);
      r9.xyzw = r9.xyzw ? float4(1, 1, 1, 1) : 0;
      r10.xyzw = r10.xyzw ? float4(1, 1, 1, 1) : 0;
      r1.w = r1.w ? 1.000000 : 0;
      r7.w = dot(r9.wzyx, r2.xyzw);
      r7.w = r10.x * r3.x + r7.w;
      r7.w = r10.y * r3.y + r7.w;
      r7.w = r10.z * r3.z + r7.w;
      r7.w = r10.w * r3.w + r7.w;
      r9.x = r1.w * r4.x + r7.w;
      r10.xy = (int2)r6.xx + int2(1, 2);
      r11.xyzw = cmp((int4)r10.xxxx == int4(3, 2, 1, 0));
      r12.xyzw = cmp((int4)r10.xxxx == int4(4, 5, 6, 7));
      r10.xz = cmp((int2)r10.xy == int2(8, 8));
      r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
      r12.xyzw = r12.xyzw ? float4(1, 1, 1, 1) : 0;
      r10.xz = r10.xz ? float2(1, 1) : 0;
      r1.w = dot(r11.wzyx, r2.xyzw);
      r1.w = r12.x * r3.x + r1.w;
      r1.w = r12.y * r3.y + r1.w;
      r1.w = r12.z * r3.z + r1.w;
      r1.w = r12.w * r3.w + r1.w;
      r9.y = r10.x * r4.x + r1.w;
      r11.xyzw = cmp((int4)r10.yyyy == int4(3, 2, 1, 0));
      r12.xyzw = cmp((int4)r10.yyyy == int4(4, 5, 6, 7));
      r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
      r12.xyzw = r12.xyzw ? float4(1, 1, 1, 1) : 0;
      r1.w = dot(r11.wzyx, r2.xyzw);
      r1.w = r12.x * r3.x + r1.w;
      r1.w = r12.y * r3.y + r1.w;
      r1.w = r12.z * r3.z + r1.w;
      r1.w = r12.w * r3.w + r1.w;
      r9.z = r10.z * r4.x + r1.w;
      r8.x = r8.y * r8.y;
      r2.x = dot(r9.xzy, float3(0.5, 0.5, -1));
      r2.y = dot(r9.xy, float2(-1, 1));
      r2.z = dot(r9.xy, float2(0.5, 0.5));
      r8.z = 1;
      r6.y = dot(r8.xyz, r2.xyz);
    } else {
      r1.w = log2(r6.z);
      r2.x = 0.30103001 * r1.w;
      r2.y = cmp(r1.z < r2.x);
      if (r2.y != 0) {
        r1.y = r1.y * 0.30103001 + -0.681241155;
        r1.y = 7 * r1.y;
        r1.w = r1.w * 0.30103001 + -0.681241155;
        r1.y = r1.y / r1.w;
        r1.w = (int)r1.y;
        r2.y = trunc(r1.y);
        r3.y = -r2.y + r1.y;
        r8.xyzw = cmp((int4)r1.wwww == int4(0, 1, 2, 3));
        r9.xyzw = cmp((int4)r1.wwww == int4(4, 5, 6, 7));
        r1.y = cmp((int)r1.w == 8);
        r8.xyzw = r8.xyzw ? float4(1, 1, 1, 1) : 0;
        r9.xyzw = r9.xyzw ? float4(1, 1, 1, 1) : 0;
        r1.y = r1.y ? 1.000000 : 0;
        r2.y = dot(r8.xyz, r4.yzw);
        r2.y = r8.w * r5.x + r2.y;
        r2.y = r9.x * r5.y + r2.y;
        r2.y = r9.y * r5.z + r2.y;
        r2.y = r9.z * r5.w + r2.y;
        r2.y = r9.w * r7.x + r2.y;
        r8.x = r1.y * r7.y + r2.y;
        r1.yw = (int2)r1.ww + int2(1, 2);
        r9.xyzw = cmp((int4)r1.yyyy == int4(0, 1, 2, 3));
        r10.xyzw = cmp((int4)r1.yyyy == int4(4, 5, 6, 7));
        r2.yz = cmp((int2)r1.yw == int2(8, 8));
        r9.xyzw = r9.xyzw ? float4(1, 1, 1, 1) : 0;
        r10.xyzw = r10.xyzw ? float4(1, 1, 1, 1) : 0;
        r2.yz = r2.yz ? float2(1, 1) : 0;
        r1.y = dot(r9.xyz, r4.yzw);
        r1.y = r9.w * r5.x + r1.y;
        r1.y = r10.x * r5.y + r1.y;
        r1.y = r10.y * r5.z + r1.y;
        r1.y = r10.z * r5.w + r1.y;
        r1.y = r10.w * r7.x + r1.y;
        r8.y = r2.y * r7.y + r1.y;
        r9.xyzw = cmp((int4)r1.wwww == int4(0, 1, 2, 3));
        r10.xyzw = cmp((int4)r1.wwww == int4(4, 5, 6, 7));
        r9.xyzw = r9.xyzw ? float4(1, 1, 1, 1) : 0;
        r10.xyzw = r10.xyzw ? float4(1, 1, 1, 1) : 0;
        r1.y = dot(r9.xyz, r4.yzw);
        r1.y = r9.w * r5.x + r1.y;
        r1.y = r10.x * r5.y + r1.y;
        r1.y = r10.y * r5.z + r1.y;
        r1.y = r10.z * r5.w + r1.y;
        r1.y = r10.w * r7.x + r1.y;
        r8.z = r2.z * r7.y + r1.y;
        r3.x = r3.y * r3.y;
        r4.x = dot(r8.xzy, float3(0.5, 0.5, -1));
        r4.y = dot(r8.xy, float2(-1, 1));
        r4.z = dot(r8.xy, float2(0.5, 0.5));
        r3.z = 1;
        r6.y = dot(r3.xyz, r4.xyz);
      } else {
        r1.y = log2(r6.w);
        r1.w = r7.z * r2.x;
        r1.y = r1.y * 0.30103001 + -r1.w;
        r6.y = r1.z * r7.z + r1.y;
      }
    }
  }
  r1.y = 3.32192802 * r6.y;
  r1.y = exp2(r1.y);
  r2.x = -3.50738446e-05 + r0.w;
  r2.yz = float2(-3.50738446e-05, -3.50738446e-05) + r1.xy;
  r1.x = dot(r2.xyz, float3(0.662454247, 0.134004191, 0.156187713));
  r1.y = dot(r2.xyz, float3(0.272228748, 0.674081624, 0.0536895208));
  r1.z = dot(r2.xyz, float3(-0.00557466131, 0.00406072894, 1.01033914));
  r2.x = dot(r1.xyz, float3(0.987223983, -0.00611323956, 0.015953267));
  r2.y = dot(r1.xyz, float3(-0.00759830978, 1.00186133, 0.00533001823));
  r2.z = dot(r1.xyz, float3(0.00307257194, -0.00509595545, 1.08168054));
  r0.w = dot(r2.xyz, float3(1.71665084, -0.35567075, -0.253366232));
  r1.x = dot(r2.xyz, float3(-0.666684449, 1.61648142, 0.0157685392));
  r1.y = dot(r2.xyz, float3(0.0176398549, -0.0427706093, 0.942103207));
  r0.w = min(65520, r0.w);
  r0.w = max(0, r0.w);
  r1.xy = min(float2(65520, 65520), r1.xy);
  r1.xy = max(float2(0, 0), r1.xy);
  r0.w = 9.99999975e-05 * r0.w;
  r0.w = log2(r0.w);
  r0.w = 0.159301758 * r0.w;
  r0.w = exp2(r0.w);
  r1.zw = r0.ww * float2(18.8515625, 18.6875) + float2(0.8359375, 1);
  r0.w = r1.z / r1.w;
  r0.w = log2(r0.w);
  r0.w = 78.84375 * r0.w;
  r2.x = exp2(r0.w);
  r0.w = 9.99999975e-05 * r1.x;
  r0.w = log2(r0.w);
  r0.w = 0.159301758 * r0.w;
  r0.w = exp2(r0.w);
  r1.xz = r0.ww * float2(18.8515625, 18.6875) + float2(0.8359375, 1);
  r0.w = r1.x / r1.z;
  r0.w = log2(r0.w);
  r0.w = 78.84375 * r0.w;
  r2.y = exp2(r0.w);
  r0.w = 9.99999975e-05 * r1.y;
  r0.w = log2(r0.w);
  r0.w = 0.159301758 * r0.w;
  r0.w = exp2(r0.w);
  r1.xy = r0.ww * float2(18.8515625, 18.6875) + float2(0.8359375, 1);
  r0.w = r1.x / r1.y;
  r0.w = log2(r0.w);
  r0.w = 78.84375 * r0.w;
  r2.z = exp2(r0.w);
  r2.w = 1;
  return r2.rgb;
}
