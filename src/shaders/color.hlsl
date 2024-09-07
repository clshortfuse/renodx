#ifndef SRC_SHADERS_COLOR_HLSL_
#define SRC_SHADERS_COLOR_HLSL_

namespace renodx {
namespace color {

static const float3x3 BT709_TO_XYZ_MAT = float3x3(
    0.4123907993f, 0.3575843394f, 0.1804807884f,
    0.2126390059f, 0.7151686788f, 0.0721923154f,
    0.0193308187f, 0.1191947798f, 0.9505321522f);

static const float3x3 XYZ_TO_BT709_MAT = float3x3(
    3.2409699419f, -1.5373831776f, -0.4986107603f,
    -0.9692436363f, 1.8759675015f, 0.0415550574f,
    0.0556300797f, -0.2039769589f, 1.0569715142f);

static const float3x3 BT2020_TO_XYZ_MAT = float3x3(
    0.6369580483f, 0.1446169036f, 0.1688809752f,
    0.2627002120f, 0.6779980715f, 0.0593017165f,
    0.0000000000f, 0.0280726930f, 1.0609850577f);

static const float3x3 XYZ_TO_BT2020_MAT = float3x3(
    1.7166511880f, -0.3556707838f, -0.2533662814f,
    -0.6666843518f, 1.6164812366f, 0.0157685458f,
    0.0176398574f, -0.0427706133f, 0.9421031212f);

static const float3x3 AP0_TO_XYZ_MAT = float3x3(
    0.9525523959f, 0.0000000000f, 0.0000936786f,
    0.3439664498f, 0.7281660966f, -0.0721325464f,
    0.0000000000f, 0.0000000000f, 1.0088251844f);

static const float3x3 XYZ_TO_AP0_MAT = float3x3(
    1.0498110175f, 0.0000000000f, -0.0000974845f,
    -0.4959030231f, 1.3733130458f, 0.0982400361f,
    0.0000000000f, 0.0000000000f, 0.9912520182f);

static const float3x3 AP1_TO_XYZ_MAT = float3x3(
    0.6624541811f, 0.1340042065f, 0.1561876870f,
    0.2722287168f, 0.6740817658f, 0.0536895174f,
    -0.0055746495f, 0.0040607335f, 1.0103391003f);

static const float3x3 XYZ_TO_AP1_MAT = float3x3(
    1.6410233797f, -0.3248032942f, -0.2364246952f,
    -0.6636628587f, 1.6153315917f, 0.0167563477f,
    0.0117218943f, -0.0082844420f, 0.9883948585f);

static const float3x3 XYZ_TO_LMS_MAT = float3x3(
    0.3592832590121217f, 0.6976051147779502f, -0.0358915932320290f,
    -0.1920808463704993f, 1.1004767970374321f, 0.0753748658519118f,
    0.0070797844607479f, 0.0748396662186362f, 0.8433265453898765f);

static const float3x3 LMS_TO_XYZ_MAT = float3x3(
    2.07018005669561320, -1.32645687610302100, 0.206616006847855170,
    0.36498825003265756, 0.68046736285223520, -0.045421753075853236,
    -0.04959554223893212, -0.04942116118675749, 1.187995941732803400);

static const float3x3 DISPLAYP3_TO_XYZ_MAT = float3x3(
    0.4865709486f, 0.2656676932f, 0.1982172852f,
    0.2289745641f, 0.6917385218f, 0.0792869141f,
    -0.0000000000f, 0.0451133819f, 1.0439443689f);

static const float3x3 XYZ_TO_DISPLAYP3_MAT = float3x3(
    2.4934969119f, -0.9313836179f, -0.4027107845f,
    -0.8294889696f, 1.7626640603f, 0.0236246858f,
    0.0358458302f, -0.0761723893f, 0.9568845240);

// With Bradford
static const float3x3 D65_TO_D60_CAT = float3x3(
    1.01303, 0.00610531, -0.014971,
    0.00769823, 0.998165, -0.00503203,
    -0.00284131, 0.00468516, 0.924507);

// With Bradford
static const float3x3 D60_TO_D65_MAT = float3x3(
    0.98722400, -0.00611327, 0.0159533,
    -0.00759836, 1.00186000, 0.0053302,
    0.00307257, -0.00509595, 1.0816800);

static const float3x3 IDENTITY_MAT = float3x3(
    1.0f, 0.0f, 0.0f,
    0.0f, 1.0f, 0.0f,
    0.0f, 0.0f, 1.0f);

static const float3x3 BT709_TO_AP0_MAT = mul(XYZ_TO_AP0_MAT, mul(D65_TO_D60_CAT, BT709_TO_XYZ_MAT));

// With Bradford
static const float3x3 BT709_TO_AP1_MAT = float3x3(
    0.6130974024, 0.3395231462, 0.0473794514,
    0.0701937225, 0.9163538791, 0.0134523985,
    0.0206155929, 0.1095697729, 0.8698146342);

static const float3x3 BT709_TO_BT2020_MAT = mul(XYZ_TO_BT2020_MAT, BT709_TO_XYZ_MAT);
static const float3x3 BT709_TO_BT709D60_MAT = mul(XYZ_TO_BT709_MAT, mul(D65_TO_D60_CAT, BT709_TO_XYZ_MAT));
static const float3x3 BT709_TO_BT2020D60_MAT = mul(XYZ_TO_BT2020_MAT, mul(D65_TO_D60_CAT, BT709_TO_XYZ_MAT));
static const float3x3 BT709_TO_DISPLAYP3_MAT = mul(XYZ_TO_DISPLAYP3_MAT, BT709_TO_XYZ_MAT);
static const float3x3 BT709_TO_DISPLAYP3D60_MAT = mul(XYZ_TO_DISPLAYP3_MAT, mul(D65_TO_D60_CAT, BT709_TO_XYZ_MAT));

static const float3x3 BT2020_TO_AP0_MAT = mul(XYZ_TO_AP0_MAT, mul(D65_TO_D60_CAT, BT2020_TO_XYZ_MAT));
static const float3x3 BT2020_TO_BT709_MAT = mul(XYZ_TO_BT709_MAT, BT2020_TO_XYZ_MAT);

static const float3x3 DISPLAYP3_TO_AP0_MAT = mul(XYZ_TO_AP0_MAT, mul(D65_TO_D60_CAT, DISPLAYP3_TO_XYZ_MAT));
static const float3x3 DISPLAYP3_TO_BT709_MAT = mul(XYZ_TO_BT709_MAT, DISPLAYP3_TO_XYZ_MAT);

static const float3x3 AP0_TO_AP1_MAT = mul(XYZ_TO_AP1_MAT, AP0_TO_XYZ_MAT);

static const float3x3 AP1_TO_AP0_MAT = mul(XYZ_TO_AP0_MAT, AP1_TO_XYZ_MAT);

// With Bradford
static const float3x3 AP1_TO_BT709_MAT = float3x3(
    1.7050509927, -0.6217921207, -0.0832588720,
    -0.1302564175, 1.1408047366, -0.0105483191,
    -0.0240033568, -0.1289689761, 1.1529723329);

static const float3x3 AP1_TO_BT2020_MAT = mul(XYZ_TO_BT2020_MAT, mul(D60_TO_D65_MAT, AP1_TO_XYZ_MAT));

static const float3x3 AP1_TO_BT709D60_MAT = mul(XYZ_TO_BT709_MAT, AP1_TO_XYZ_MAT);
static const float3x3 AP1_TO_BT2020D60_MAT = mul(XYZ_TO_BT2020_MAT, AP1_TO_XYZ_MAT);
static const float3x3 AP1_TO_AP1D65_MAT = mul(XYZ_TO_AP1_MAT, mul(D60_TO_D65_MAT, AP1_TO_XYZ_MAT));

static const float3 BT601_Y = float3(0.299, 0.587, 0.114);

// https://www.ilkeratalay.com/colorspacesfaq.php
static const float3 BOURGIN_D65_Y = float3(0.222015, 0.706655, 0.071330);

namespace bt709 {
static const float REFERENCE_WHITE = 100.f;
namespace from {
float3 AP1(float3 ap1) { return mul(AP1_TO_BT709_MAT, ap1); }

float3 BT2020(float3 bt2020) { return mul(BT2020_TO_BT709_MAT, bt2020); }

float3 OkLab(float3 oklab) {
  static const float3x3 OKLAB_2_OKLABLMS = {
      1.f, 0.3963377774f, 0.2158037573f,
      1.f, -0.1055613458f, -0.0638541728f,
      1.f, -0.0894841775f, -1.2914855480f};

  static const float3x3 OKLABLMS_2_BT709 = {
      4.0767416621f, -3.3077115913f, 0.2309699292f,
      -1.2684380046f, 2.6097574011f, -0.3413193965f,
      -0.0041960863f, -0.7034186147f, 1.7076147010f};

  float3 lms = mul(OKLAB_2_OKLABLMS, oklab);

  lms = lms * lms * lms;

  return mul(OKLABLMS_2_BT709, lms);
}

float SRGB(float channel) {
  return (channel <= 0.04045f)
             ? (channel / 12.92f)
             : pow((channel + 0.055f) / 1.055f, 2.4f);
}

float3 SRGB(float3 color) {
  return float3(SRGB(color.r), SRGB(color.g), SRGB(color.b));
}

float4 SRGB(float4 color) {
  return float4(SRGB(color.r), SRGB(color.g), SRGB(color.b), color.a);
}

float4 SRGBA(float4 color) {
  return float4(SRGB(color.r), SRGB(color.g), SRGB(color.b), SRGB(color.a));
}

}  // namespace from
}  // namespace bt709

namespace bt2020 {
namespace from {
float3 BT709(float3 bt709) { return mul(BT709_TO_BT2020_MAT, bt709); }
}  // namespace from
}  // namespace bt2020

namespace ap1 {
namespace from {
float3 BT709(float3 bt709) { return mul(BT709_TO_AP1_MAT, bt709); }
}  // namespace from
}  // namespace ap1

namespace y {
namespace from {
float BT601(float3 bt601) { return dot(bt601, BT601_Y); }
float BT709(float3 bt709) { return dot(bt709, BT709_TO_XYZ_MAT[1].rgb); }
float BT2020(float3 bt2020) { return dot(bt2020, BT2020_TO_XYZ_MAT[1].rgb); }
}  // namespace from
}  // namespace y

namespace pq {
namespace from {
float3 BT2020(float3 bt2020_color, float scaling = 10000.f) {
  static const float M1 = 2610.f / 16384.f;           // 0.1593017578125f;
  static const float M2 = 128.f * (2523.f / 4096.f);  // 78.84375f;
  static const float C1 = 3424.f / 4096.f;            // 0.8359375f;
  static const float C2 = 32.f * (2413.f / 4096.f);   // 18.8515625f;
  static const float C3 = 32.f * (2392.f / 4096.f);   // 18.6875f;

  bt2020_color *= (scaling / 10000.f);
  float3 y_m1 = pow(bt2020_color, M1);
  return pow((C1 + C2 * y_m1) / (1.f + C3 * y_m1), M2);
}
}  // namespace from
}  // namespace pq

namespace ictcp {
namespace from {
float3 BT709(float3 bt709_color) {
  float3 xyz_color = mul(BT709_TO_XYZ_MAT, bt709_color);
  float3 lms_color = mul(XYZ_TO_LMS_MAT, xyz_color);

  float3 pq = pq::from::BT2020(lms_color, 100.0f);

  float3x3 mat = float3x3(
      0.5000, 0.5000, 0.0000,
      1.6137, -3.3234, 1.7097,
      4.3780, -4.2455, -0.1325);

  return mul(mat, pq);
}
}  // namespace from
}  // namespace ictcp

namespace srgb {
static const float REFERENCE_WHITE = 80.f;
namespace from {
float BT709(float channel) {
  return (channel <= 0.0031308f)
             ? (channel * 12.92f)
             : (1.055f * pow(channel, 1.f / 2.4f) - 0.055f);
}
float3 BT709(float3 color) {
  return float3(BT709(color.r), BT709(color.g), BT709(color.b));
}
float4 BT709(float4 color) {
  return float4(BT709(color.r), BT709(color.g), BT709(color.b), color.a);
}
}  // namespace from
}  // namespace srgb

namespace srgba {
namespace from {
float4 BT709(float4 color) {
  return float4(
      srgb::from::BT709(color.r),
      srgb::from::BT709(color.g),
      srgb::from::BT709(color.b),
      srgb::from::BT709(color.a));
}
}  // namespace from
}  // namespace srgba

namespace arri {
namespace logc {
namespace c800 {
float Encode(float x, float cut = 0.010591f) {
  const float a = 5.555556f;
  const float b = 0.052272f;
  const float c = 0.247190f;
  const float d = 0.385537f;
  const float e = 5.367655f;
  const float f = 0.092809f;
  return ((cut == 0.0f) || x > cut)
             ? (c * log10((a * x) + b) + d)
             : (e * x + f);
}

float3 Encode(float3 color, float cut = 0.010591f) {
  return float3(Encode(color.r, cut), Encode(color.g, cut), Encode(color.b, cut));
}

float Decode(float t) {
  const float cut = 0.010591f;
  const float a = 5.555556f;
  const float b = 0.052272f;
  const float c = 0.247190f;
  const float d = 0.385537f;
  const float e = 5.367655f;
  const float f = 0.092809f;

  return (t > e * cut + f)
             ? (pow(10, (t - d) / c) - b) / a
             : (t - f) / e;
}

float3 Decode(float3 color) {
  return float3(Decode(color.r), Decode(color.g), Decode(color.b));
}
}  // namespace c800

namespace c1000 {
float Encode(float x, float cut = 0.011361f) {
  const float a = 5.555556f;
  const float b = 0.047996f;
  const float c = 0.244161f;
  const float d = 0.386036f;
  const float e = 5.301883f;
  const float f = 0.092814f;
  return ((cut == 0.0f) || x > cut)
             ? (c * log10((a * x) + b) + d)
             : (e * x + f);
}

float3 Encode(float3 color, float cut = 0.011361f) {
  return float3(Encode(color.r, cut), Encode(color.g, cut), Encode(color.b, cut));
}
}  // namespace c1000
}  // namespace logc
}  // namespace arri

namespace bt2020 {
namespace from {
float3 PQ(float3 pq_color, float scaling = 10000.f) {
  static const float M1 = 2610.f / 16384.f;           // 0.1593017578125f;
  static const float M2 = 128.f * (2523.f / 4096.f);  // 78.84375f;
  static const float C1 = 3424.f / 4096.f;            // 0.8359375f;
  static const float C2 = 32.f * (2413.f / 4096.f);   // 18.8515625f;
  static const float C3 = 32.f * (2392.f / 4096.f);   // 18.6875f;

  float3 e_m12 = pow(pq_color, 1.f / M2);
  float3 bt2020 = pow(max(e_m12 - C1, 0) / (C2 - C3 * e_m12), 1.f / M1);
  return bt2020 * (10000.f / scaling);
}
}  // namespace from
}  // namespace bt2020

namespace oklab {
namespace from {
float3 BT709(float3 bt709) {
  static const float3x3 BT709_2_OKLABLMS = {
      0.4122214708f, 0.5363325363f, 0.0514459929f,
      0.2119034982f, 0.6806995451f, 0.1073969566f,
      0.0883024619f, 0.2817188376f, 0.6299787005f};
  static const float3x3 OKLABLMS_2_OKLAB = {
      0.2104542553f, 0.7936177850f, -0.0040720468f,
      1.9779984951f, -2.4285922050f, 0.4505937099f,
      0.0259040371f, 0.7827717662f, -0.8086757660f};

  float3 lms = mul(BT709_2_OKLABLMS, bt709);

  lms = sign(lms) * pow(abs(lms), 1.f / 3.f);

  return mul(OKLABLMS_2_OKLAB, lms);
}

float3 OkLCh(float3 oklch) {
  float l = oklch[0];
  float c = oklch[1];
  float h = oklch[2];
  return float3(l, c * cos(h), c * sin(h));
}
}  // namespace from
}  // namespace oklab

namespace bt2408 {
static const float REFERENCE_WHITE = 203.f;
}  // namespace bt2408

namespace oklch {
namespace from {
float3 OkLab(float3 oklab) {
  float l = oklab[0];
  float a = oklab[1];
  float b = oklab[2];
  return float3(l, sqrt((a * a) + (b * b)), atan2(b, a));
}
float3 BT709(float3 bt709) {
  float3 ok_lab = renodx::color::oklab::from::BT709(bt709);
  return OkLab(ok_lab);
}
}  // namespace from
}  // namespace oklch

namespace bt709 {
namespace from {
float3 OkLCh(float3 oklch) {
  float3 ok_lab = renodx::color::oklab::from::OkLCh(oklch);
  return OkLab(ok_lab);
}

float3 ICtCp(float3 col) {
  float3x3 mat = float3x3(
      1.0, 0.00860514569398152, 0.11103560447547328,
      1.0, -0.00860514569398152, -0.11103560447547328,
      1.0, 0.56004885956263900, -0.32063747023212210);
  col = mul(mat, col);

  // 1.0f = 100 nits, 100.0f = 10k nits
  col = bt2020::from::PQ(col, 100.f);
  col = mul(LMS_TO_XYZ_MAT, col);
  return mul(XYZ_TO_BT709_MAT, col);
}

}  // namespace from

namespace clamp {
float3 BT709(float3 bt709) { return max(0, bt709); }
float3 BT2020(float3 bt709) {
  float3 bt2020 = renodx::color::bt2020::from::BT709(bt709);
  bt2020 = max(0, bt2020);
  return renodx::color::bt709::from::BT2020(bt2020);
}

float3 AP1(float3 bt709) {
  float3 ap1 = renodx::color::ap1::from::BT709(bt709);
  ap1 = max(0, ap1);
  return renodx::color::bt709::from::AP1(ap1);
}
}  // namespace clamp
}  // namespace bt709

}  // namespace color
}  // namespace renodx

#endif  // SRC_COMMON_COLOR_HLSL_
