#ifndef SRC_COMMON_MATH_HLSL_
#define SRC_COMMON_MATH_HLSL_

#define FLT_MIN asfloat(0x00800000) //1.175494351e-38f
#define FLT_MAX asfloat(0x7F7FFFFF) //3.402823466e+38f
#define FLT10_MAX 64512.f
#define FLT11_MAX 65024.f
#define FLT16_MAX 65504.f

float average(float3 color)
{
	return (color.x + color.y + color.z) / 3.f;
}

// Returns 1 or FLT_MAX if "dividend" is 0
float safeDivision(float quotient, float dividend, bool returnMax = false)
{
	if (dividend == 0.f) {
		return returnMax ? (FLT_MAX * sign(quotient)) : 1.f;
	}
    return quotient / dividend;
}

// Returns 1 or FLT_MAX if "dividend" is 0
float3 safeDivision(float3 quotient, float3 dividend, bool returnMax = false)
{
    return float3(safeDivision(quotient.x, dividend.x, returnMax),
	              safeDivision(quotient.y, dividend.y, returnMax),
	              safeDivision(quotient.z, dividend.z, returnMax));
}

#endif  // SRC_COMMON_MATH_HLSL_
