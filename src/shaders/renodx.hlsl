#ifndef SRC_SHADERS_RENODX_HLSL_
#define SRC_SHADERS_RENODX_HLSL_

#pragma warning(disable: 3571)  // pow(f,e)
#pragma warning(disable: 3554)  // [branch] on dead-code elimination

#include "./color.hlsl"
#include "./color_convert.hlsl"
#include "./colorcorrect.hlsl"
#include "./colorgrade.hlsl"
#include "./debug.hlsl"
#include "./draw.hlsl"
#include "./effects.hlsl"
#include "./inverse_tonemap.hlsl"
#include "./math.hlsl"
#include "./random.hlsl"
#include "./tonemap.hlsl"

#include "./deprecated.hlsl"

#endif  // SRC_SHADERS_RENODX_HLSL_