#ifndef RENODX_SHADERS_COLOR_ARRI_HLSL
#define RENODX_SHADERS_COLOR_ARRI_HLSL

#include "../math.hlsl"

namespace renodx {
namespace color {
namespace arri {
namespace logc {

struct EncodingParams {
  float a;
  float b;
  float c;
  float d;
  float e;
  float f;
  float cut;
};

#define ARRI_ENCODE_GENERATOR(T)                                       \
  T Encode(T c, EncodingParams params, bool use_cut = true) {          \
    if (!use_cut) {                                                    \
      return (params.c * log10((params.a * c) + params.b) + params.d); \
    }                                                                  \
    return renodx::math::Select(                                       \
        (c > params.cut),                                              \
        (params.c * log10((params.a * c) + params.b) + params.d),      \
        (params.e * c + params.f));                                    \
  }

ARRI_ENCODE_GENERATOR(float)
ARRI_ENCODE_GENERATOR(float2)
ARRI_ENCODE_GENERATOR(float3)

#define ARRI_DECODE_GENERATOR(T)                                        \
  T Decode(T c, EncodingParams params, bool use_cut = true) {           \
    return renodx::math::Select(                                        \
        (c > (params.e * params.cut * (use_cut ? 1 : 0) + params.f)),   \
        ((pow(10.f, (c - params.d) / params.c) - params.b) / params.a), \
        ((c - params.f) / params.e));                                   \
  }

ARRI_DECODE_GENERATOR(float)
ARRI_DECODE_GENERATOR(float2)
ARRI_DECODE_GENERATOR(float3)

#undef ARRI_ENCODE_GENERATOR
#undef ARRI_DECODE_GENERATOR

#define GENERATE_ARRI_LOGC_FUNCTIONS(T)      \
  T Encode(T c, bool use_cut = true) {       \
    return logc::Encode(c, PARAMS, use_cut); \
  }                                          \
  T Decode(T c, bool use_cut = true) {       \
    return logc::Decode(c, PARAMS, use_cut); \
  }

namespace c800 {
static const EncodingParams PARAMS = {
  5.555556f,
  0.052272f,
  0.247190f,
  0.385537f,
  5.367655f,
  0.092809f,
  0.010591f,
};

GENERATE_ARRI_LOGC_FUNCTIONS(float)
GENERATE_ARRI_LOGC_FUNCTIONS(float2)
GENERATE_ARRI_LOGC_FUNCTIONS(float3)

}  // namespace c800

namespace c1000 {

static const EncodingParams PARAMS = {
  5.555556f,
  0.047996f,
  0.244161f,
  0.386036f,
  5.301883f,
  0.092814f,
  0.011361f
};

GENERATE_ARRI_LOGC_FUNCTIONS(float)
GENERATE_ARRI_LOGC_FUNCTIONS(float2)
GENERATE_ARRI_LOGC_FUNCTIONS(float3)

}  // namespace c1000

#undef GENERATE_ARRI_LOGC_FUNCTIONS

}  // namespace logc
}  // namespace arri
}  // namespace color
}  // namespace renodx
#endif  // RENODX_SHADERS_COLOR_ARRI_HLSL