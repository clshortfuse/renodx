#ifndef SRC_SHADERS_COLOR_ICTCP_HLSL_
#define SRC_SHADERS_COLOR_ICTCP_HLSL_

#include "../math.hlsl"
#include "./pq.hlsl"
#include "./rgb.hlsl"

namespace renodx {
namespace color {

namespace ictcp {
// https://professional.dolby.com/siteassets/pdfs/ictcp_dolbywhitepaper_v071.pdf

static const float3x3 XYZ_TO_ICTCP_LMS_MAT = float3x3(
    0.359168797f, 0.697604775f, -0.0357883982f,
    -0.192186400f, 1.10039842f, 0.0755404010f,
    0.00695759989f, 0.0749168023f, 0.843357980f);

static const float3x3 ICTCP_LMS_TO_XYZ_MAT = float3x3(
    2.07036161f, -1.32659053f, 0.206681042f,
    0.364990383f, 0.680468797f, -0.0454616732f,
    -0.0495028905f, -0.0495028905f, 1.18806946f);

static const float3x3 BT709_TO_ICTCP_LMS_MAT = float3x3(
    0.295764088f, 0.623072445f, 0.0811667516f,
    0.156191974f, 0.727251648f, 0.116557933f,
    0.0351022854f, 0.156589955f, 0.808302998f);

static const float3x3 ICTCP_LMS_TO_BT709_MAT = float3x3(
    6.17353248f, -5.32089900f, 0.147354885f,
    -1.32403194f, 2.56026983f, -0.236238613f,
    -0.0115983877f, -0.264921456f, 1.27652633f);

static const float CROSSTALK = 0.04f;
static const float IPT_OPTIMIZATION = 1.0f;

static const float3x3 CROSSTALK_MAT = float3x3(
    1.0f - (2 * CROSSTALK), CROSSTALK, CROSSTALK,
    CROSSTALK, 1.0f - (2 * CROSSTALK), CROSSTALK,
    CROSSTALK, CROSSTALK, 1.0f - (2 * CROSSTALK));

static const float3x3 XYZ_TO_DOLBY_LMS_MAT = mul(XYZ_D65_TO_HUNT_POINTER_ESTEVEZ_LMS_MAT, CROSSTALK_MAT);

static const float3x3 PLMS_TO_IPT_OPTIMIZED_MAT = float3x3(
    lerp(PLMS_TO_IPT_MAT[0], float3(0.5f, 0.5f, 0.0f), IPT_OPTIMIZATION),
    PLMS_TO_IPT_MAT[1],
    PLMS_TO_IPT_MAT[2]);

static const float VECTORSCOPE_DEGREES = 65.f;
static const float ROTATION_POINT = VECTORSCOPE_DEGREES * renodx::math::PI / 180.f;

static const float3x3 IPT_ROTATION_MAT = float3x3(
    1.f, 0, 0.f,
    0, cos(ROTATION_POINT), -sin(ROTATION_POINT),
    0, sin(ROTATION_POINT), cos(ROTATION_POINT));

static const float SCALE_FACTOR = 1.4f;
static const float3x3 IPT_SCALE_MAT = float3x3(
    1.0f, 1.0f, 1.0f,
    SCALE_FACTOR, SCALE_FACTOR, SCALE_FACTOR,
    1.0f, 1.0f, 1.0f);

static const float3x3 PLMS_TO_ICTCP_MAT = mul(IPT_ROTATION_MAT, PLMS_TO_IPT_OPTIMIZED_MAT) * IPT_SCALE_MAT;

namespace from {
float3 BT709(float3 bt709_color, float scaling = 100.f) {
  float3 lms = mul(mul(XYZ_TO_DOLBY_LMS_MAT, BT709_TO_XYZ_MAT), bt709_color);
  float3 plms = pq::Encode(max(0, lms), scaling);
  float3 ictcp_color = mul(PLMS_TO_ICTCP_MAT, plms);
  return ictcp_color;
}
}  // namespace from
}  // namespace ictcp

namespace bt709 {
namespace from {

float3 ICtCp(float3 ictcp_color, float scaling = 100.f) {
  float3 plms_color = mul(renodx::math::Invert3x3(ictcp::PLMS_TO_ICTCP_MAT), ictcp_color);
  float3 lms_color = pq::Decode(plms_color, scaling);
  float3 bt709_color = mul(
      mul(
          renodx::math::Invert3x3(BT709_TO_XYZ_MAT),
          renodx::math::Invert3x3(ictcp::XYZ_TO_DOLBY_LMS_MAT)),
      lms_color);
  return bt709_color;
}

}  // namespace from
}  // namespace bt709
}  // namespace color
}  // namespace renodx

#endif  // SRC_SHADERS_COLOR_ICTCP_HLSL_