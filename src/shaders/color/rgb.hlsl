#ifndef RENODX_SHADERS_COLOR_RGB_HLSL
#define RENODX_SHADERS_COLOR_RGB_HLSL

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

static const float3x3 XYZ_TO_HUNT_POINTER_ESTEVEZ_LMS_BAD_MAT = float3x3(
    +0.38971f, 0.68898f, -0.07868f,
    -0.22981f, 1.18340f, +0.04641f,
    +0.00000f, 0.00000f, +1.00000f);

static const float3x3 XYZ_TO_CAT02_LMS_MAT = XYZ_TO_HUNT_POINTER_ESTEVEZ_LMS_BAD_MAT;

static const float3x3 XYZ_TO_HUNT_POINTER_ESTEVEZ_LMS_MAT = float3x3(
    +0.38971f, 0.68898f, -0.07869f,
    -0.22981f, 1.18340f, +0.04641f,
    +0.00000f, 0.00000f, +1.00000f);

// According to Dolby
static const float3x3 XYZ_D65_TO_HUNT_POINTER_ESTEVEZ_LMS_MAT = float3x3(
    +0.4002f, 0.7076f, -0.0808f,
    -0.2263f, 1.1653f, +0.0457f,
    +0.0000f, 0.0000f, +0.9182f);

// According to Bruce Lind
static const float3x3 XYZ_D65_TO_VON_KRIES_LMS_MAT = float3x3(
    +0.4002400f, 0.7076000f, -0.0808100f,
    -0.2263000f, 1.1653200f, +0.0457000f,
    +0.0000000f, 0.0000000f, +0.9182200f);

static const float3x3 XYZ_D65_TO_BRADFORD_LMS_MAT = float3x3(
    0.8951000f, 0.2664000f, -0.1614000f,
    -0.7502000f, 1.7135000f, 0.0367000f,
    0.0389000f, -0.0685000f, 1.0296000f);

// AKA Fairchild
static const float3x3 XYZ_TO_CAT97_LMS_MAT = float3x3(
    +0.8562f, +0.3372f, -0.1934f,
    -0.8360f, +1.8327f, +0.0033f,
    +0.0357f, -0.0469f, +1.0112f);

// Stockman & Sharpe 2 degree
static const float3x3 XYZf_TO_STOCKMAN_SHARP_LMS_MAT = float3x3(
    1.94735469f, -1.41445123f, 0.36476327f,
    0.68990272f, +0.34832189f, 0.00000000f,
    0.00000000f, +0.00000000f, 1.93485343f);

static const float3x3 PLMS_TO_IPT_MAT = float3x3(
    0.4f, 0.4f, 0.2f,
    4.4550f, -4.8510f, 0.3960f,
    0.8056f, 0.3572f, -1.1628f);

static const float3x3 DISPLAYP3_TO_XYZ_MAT = float3x3(
    0.4865709486f, 0.2656676932f, 0.1982172852f,
    0.2289745641f, 0.6917385218f, 0.0792869141f,
    0.0000000000f, 0.0451133819f, 1.0439443689f);

static const float3x3 XYZ_TO_DISPLAYP3_MAT = float3x3(
    2.4934969119f, -0.9313836179f, -0.4027107845f,
    -0.8294889696f, 1.7626640603f, 0.0236246858f,
    0.0358458302f, -0.0761723893f, 0.9568845240);

static const float3x3 BT470_PAL_TO_BT709_MAT = float3x3(
    1.04404318f, -0.0440432094f, 0.f,
    0.f, 1.f, 0.f,
    0.f, 0.0117933787f, 0.988206624f);

static const float3x3 BT601_NTSC_U_TO_BT709_MAT = float3x3(
    0.939542055f, 0.0501813553f, 0.0102765792f,
    0.0177722238f, 0.965792834f, 0.0164349135f,
    -0.00162159989f, -0.00436974968f, 1.00599133f);

static const float3x3 NTSC_U_1953_TO_XYZ_MAT = float3x3(
    0.6068638093f, 0.1735072810f, 0.2003348814f,
    0.2989030703f, 0.5866198547f, 0.1144770751f,
    -0.0000000000f, 0.0660980118f, 1.1161514821f);

// chromatic adaptation method: vK20
// chromatic adaptation transform: CAT02
static const float3x3 ARIB_TR_B9_D93_TO_BT709_D65_MAT = float3x3(
    0.886132895f, -0.144765302f, -0.000316959019f,
    0.0408876389f, 0.971982538f, 0.00582195585f,
    0.00312487990f, 0.0414751693f, 1.56167137f);

// chromatic adaptation method: vK20
// chromatic adaptation transform: CAT02
static const float3x3 ARIB_TR_B9_9300K_8_MPCD_TO_BT709_D65_MAT = float3x3(
    0.887350380f, -0.145325064f, -0.0000826625182f,
    0.0409696400f, 0.974039375f, 0.00576419429f,
    0.00292735593f, 0.0404177531f, 1.53643214f);

// chromatic adaptation method: vK20
// chromatic adaptation transform: CAT02
static const float3x3 ARIB_TR_B9_9300K_27_MPCD_TO_BT709_D65_MAT = float3x3(
    0.768497526f, -0.210804164f, 0.000297427177f,
    0.0397904068f, 1.04825413f, 0.00555809540f,
    0.00147510506f, 0.0328789241f, 1.36515128f);

// chromatic adaptation method: vK20
// chromatic adaptation transform: CAT02
static const float3x3 BT709_D93_TO_BT709_D65_MAT = float3x3(
    0.956910431f, -0.0613676644f, -0.00503798108f,
    0.00317927985f, 1.00466823f, 0.000124804413f,
    0.00494503090f, 0.0247498396f, 1.17469859f);

// chromatic adaptation method: von Kries
// chromatic adaptation transform: Bradford
static const float3x3 D65_TO_D60_CAT = float3x3(
    1.01303493f, 0.00610525766f, -0.0149709433f,
    0.00769822997f, 0.998163342f, -0.00503203831f,
    -0.00284131732f, 0.00468515651f, 0.924506127f);

// chromatic adaptation method: von Kries
// chromatic adaptation transform: Bradford
static const float3x3 D60_TO_D65_MAT = float3x3(
    0.987223982f, -0.00611322838f, 0.0159532874f,
    -0.00759837171f, 1.00186145f, 0.00533003592f,
    0.00307257706f, -0.00509596150f, 1.08168065f);

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

// With Bradford
static const float3x3 BT2020_TO_AP1_MAT = float3x3(
    0.9748949779f, 0.0195991086f, 0.0055059134f,
    0.0021795628f, 0.9955354689f, 0.0022849683f,
    0.0047972397f, 0.0245320166f, 0.9706707437f);

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

// With Bradford
static const float3x3 AP1_TO_BT2020_MAT = float3x3(
    1.0258247477f, -0.0200531908f, -0.0057715568f,
    -0.0022343695f, 1.0045865019f, -0.0023521324f,
    -0.0050133515f, -0.0252900718f, 1.0303034233f);

static const float3x3 AP1_TO_BT709D60_MAT = mul(XYZ_TO_BT709_MAT, AP1_TO_XYZ_MAT);
static const float3x3 AP1_TO_BT2020D60_MAT = mul(XYZ_TO_BT2020_MAT, AP1_TO_XYZ_MAT);
static const float3x3 AP1_TO_AP1D65_MAT = mul(XYZ_TO_AP1_MAT, mul(D60_TO_D65_MAT, AP1_TO_XYZ_MAT));

// https://www.ilkeratalay.com/colorspacesfaq.php
static const float3 BOURGIN_D65_Y = float3(0.222015, 0.706655, 0.071330);

// 1931 2 degree standard observer
static const float2 WHITE_POINT_D65 = float2(0.31272, 0.32903);

namespace xyz {
namespace from {
float3 xyY(float3 xyY) {
  float3 XYZ;

  XYZ.xz = float2(xyY.x, (1.f - xyY.xy.x - xyY.xy.y)) / xyY.y * xyY[2];

  XYZ.y = xyY[2];

  return XYZ;
}

float3 BT709(float3 bt709) {
  return mul(BT709_TO_XYZ_MAT, bt709);
}

}  // namespace from
}  // namespace xyz

namespace xyY {
namespace from {
float3 XYZ(float3 XYZ) {
  float xyz = XYZ.x + XYZ.y + XYZ.z;

  float3 xyY;

  xyY.xy = XYZ.xy / xyz;

  xyY[2] = XYZ.y;

  return xyY;
}

float3 BT709(float3 bt709) {
  float3 XYZ = xyz::from::BT709(bt709);

  return xyY::from::XYZ(XYZ);
}
}  // namespace from
}  // namespace xyY

namespace bt709 {
static const float REFERENCE_WHITE = 100.f;

namespace from {
float3 XYZ(float3 XYZ) {
  return mul(XYZ_TO_BT709_MAT, XYZ);
}

float3 xyY(float3 xyY) {
  float3 XYZ = xyz::from::xyY(xyY);

  return bt709::from::XYZ(XYZ);
}

float3 AP1(float3 ap1) {
  return mul(AP1_TO_BT709_MAT, ap1);
}

float3 BT2020(float3 bt2020) {
  return mul(BT2020_TO_BT709_MAT, bt2020);
}

float3 BT601NTSCU(float3 bt601) {
  return mul(BT601_NTSC_U_TO_BT709_MAT, bt601);
}

float3 ARIBTRB9(float3 aribtrb9) {
  return mul(ARIB_TR_B9_D93_TO_BT709_D65_MAT, aribtrb9);
}

float3 ARIBTRB98MPCD(float3 aribtrb9) {
  return mul(ARIB_TR_B9_9300K_8_MPCD_TO_BT709_D65_MAT, aribtrb9);
}

float3 ARIBTRB927MPCD(float3 aribtrb9) {
  return mul(ARIB_TR_B9_9300K_27_MPCD_TO_BT709_D65_MAT, aribtrb9);
}

float3 BT709D93(float3 bt709d93) {
  return mul(BT709_D93_TO_BT709_D65_MAT, bt709d93);
}

}  // namespace from
}  // namespace bt709

namespace bt2020 {
namespace from {
float3 BT709(float3 bt709) {
  return mul(BT709_TO_BT2020_MAT, bt709);
}

float3 AP1(float3 ap1) {
  return mul(AP1_TO_BT2020_MAT, ap1);
}

}  // namespace from
}  // namespace bt2020

namespace ap1 {
namespace from {
float3 BT709(float3 bt709) {
  return mul(BT709_TO_AP1_MAT, bt709);
}

float3 BT2020(float3 bt2020) {
  return mul(BT2020_TO_AP1_MAT, bt2020);
}
}  // namespace from
}  // namespace ap1

namespace y {
namespace from {

float XYZMatrix(float3 color, float3x3 toXYZMatrix) {
  return dot(color, toXYZMatrix[1].rgb);
}

float NTSC1953(float3 ntsc) {
  return XYZMatrix(ntsc, NTSC_U_1953_TO_XYZ_MAT);
}

float BT709(float3 bt709) {
  return XYZMatrix(bt709, BT709_TO_XYZ_MAT);
}
float BT2020(float3 bt2020) {
  return XYZMatrix(bt2020, BT2020_TO_XYZ_MAT);
}
float AP1(float3 ap1) {
  return XYZMatrix(ap1, AP1_TO_XYZ_MAT);
}
}  // namespace from
}  // namespace y

namespace luma {
namespace from {
float BT601(float3 bt601) {
  return y::from::NTSC1953(bt601);
}
}  // namespace from
}  // namespace luma

namespace bt2408 {
static const float REFERENCE_WHITE = 203.f;
static const float GRAPHICS_WHITE = 203.f;
}  // namespace bt2408

}  // namespace color
}  // namespace renodx

#endif  // RENODX_SHADERS_COLOR_RGB_HLSL