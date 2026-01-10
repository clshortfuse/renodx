#ifndef SRC_SHADERS_MATH_CONSTANTS_HLSL_
#define SRC_SHADERS_MATH_CONSTANTS_HLSL_

#include "./cross.hlsl"

START_NAMESPACE(renodx)
START_NAMESPACE(math)

static const float FLT10_MAX = 64512.f;
static const float FLT11_MAX = 65024.f;

static const float FLT16_MIN = CROSS_COMPILE(asfloat(0x0400), 0.00006103515625);
static const float FLT16_MAX = 65504.f;
static const float FLT32_MIN = CROSS_COMPILE(asfloat(0x00800000), 1.17549435082228750797e-38);
static const float FLT32_MAX = CROSS_COMPILE(asfloat(0x7F7FFFFF), 3.40282346638528859812e+38);
static const float FLT_MIN = CROSS_COMPILE(asfloat(0x00800000), 1.17549435082228750797e-38);
static const float FLT_MAX = CROSS_COMPILE(asfloat(0x7F7FFFFF), 3.40282346638528859812e+38);

static const float INFINITY = CROSS_COMPILE(asfloat(0x7F800000), 1.0 / 0.0);
static const float NEG_INFINITY = CROSS_COMPILE(asfloat(0xFF800000), -1.0 / 0.0);
static const float PI = 3.14159265358979323846f;

static const float FLT10_EPSILON = CROSS_COMPILE(asfloat(0x3C00 + 0x0040), 0.0078125);         // 2^-7
static const float FLT11_EPSILON = CROSS_COMPILE(asfloat(0x3C00 + 0x0020), 0.00390625);        // 2^-8
static const float FLT12_EPSILON = CROSS_COMPILE(asfloat(0x3C00 + 0x0010), 0.001953125);       // 2^-9
static const float FLT16_EPSILON = CROSS_COMPILE(asfloat(0x3C00 + 0x0004), 0.0009765625);      // 2^-10
static const float FLT32_EPSILON = CROSS_COMPILE(asfloat(0x34000000), 1.1920928955078125e-7);  // 2^-23
static const float FLT_EPSILON = CROSS_COMPILE(asfloat(0x34000000), 1.1920928955078125e-7);    // 2^-23

END_NAMESPACE(math)
END_NAMESPACE(renodx)

#endif  // SRC_SHADERS_MATH_CONSTANTS_HLSL_