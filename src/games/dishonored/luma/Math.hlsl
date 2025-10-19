#ifndef SRC_MATH_HLSL
#define SRC_MATH_HLSL

#define FLT_MIN	asfloat(0x00800000)  // 1.175494351e-38f
#define FLT_MAX	asfloat(0x7F7FFFFF)  // 3.402823466e+38f
#define FLT_QNAN_POS asfloat(0x7FC00000) // +qNaN
#define FLT_QNAN_NEG asfloat(0xFFC00000) // -qNaN
#define FLT_SNAN_POS asfloat(0x7FA00000) // +sNaN
#define FLT_SNAN_NEG asfloat(0xFFA00000) // -sNaN
#define FLT_NAN	FLT_QNAN_POS
#define FLT_EPSILON	1.192092896e-07 // Smallest positive number, such that 1.0 + FLT_EPSILON != 1.0
#define FLT10_MAX 64512.f
#define FLT11_MAX 65024.f
#define FLT16_MAX 65504.f

#define PI 3.141592653589793238462643383279502884197
#define PI_X2 (PI * 2.0)
#define PI_X4 (PI_X4 * 4.0)

static const float3x3 IdentityMatrix = float3x3(
    1.0f, 0.0f, 0.0f,
    0.0f, 1.0f, 0.0f,
    0.0f, 0.0f, 1.0f);

float average(float3 color)
{
	return (color.x + color.y + color.z) / 3.f;
}
float average(float2 color)
{
	return (color.x + color.y) / 2.f;
}

float remap(float input, float oldMin, float oldMax, float newMin, float newMax)
{
	return ((input - oldMin) * ((newMax - newMin) / (oldMax - oldMin))) + newMin;
}

// Returns 0, 1, -1/0/+1 or +/-FLT_MAX if "dividend" is 0
float safeDivision(float quotient, float dividend, int fallbackMode = 0)
{
  float result = 0; // We get warning 4000 if just directly return values
	if (dividend == 0)
  {
    if (fallbackMode == 0)
      result = 0;
    else if (fallbackMode == 1)
      result = 1;
    else if (fallbackMode == 2)
      result = sign(quotient); // This will return 0 for 0
    else
      result = FLT_MAX * sign(quotient);
  }
  else
  {
    result = quotient / dividend;
  }
  return result;
}
// Returns 0, 1 or FLT_MAX if "dividend" is 0
float3 safeDivision(float3 quotient, float3 dividend, int fallbackMode = 0)
{
  return float3(safeDivision(quotient.x, dividend.x, fallbackMode), safeDivision(quotient.y, dividend.y, fallbackMode), safeDivision(quotient.z, dividend.z, fallbackMode));
}

// Depending on the compiler settings, DX claims to strip away "isnan" checks as "NaN" can't happen in shaders (which isn't true...),
// this is an actual forced check for it.
bool IsNaN_Strict(float x)
{
#if 0 // float!=float is only true if the number is NaN. This doesn't always work, it's probably optimized away!
  return x.x != x.x;
#else // This will cover all the possible nan cases
  uint bits = asuint(x);
  return ((bits & 0x7F800000u) == 0x7F800000u) && ((bits & 0x007FFFFFu) != 0);
#endif
}
bool2 IsNaN_Strict(float2 x)
{
  return bool2(IsNaN_Strict(x.x), IsNaN_Strict(x.y));
}
bool3 IsNaN_Strict(float3 x)
{
  return bool3(IsNaN_Strict(x.x), IsNaN_Strict(x.y), IsNaN_Strict(x.z));
}
bool4 IsNaN_Strict(float4 x)
{
  return bool4(IsNaN_Strict(x.x), IsNaN_Strict(x.y), IsNaN_Strict(x.z), IsNaN_Strict(x.w));
}
bool IsAnyNaN_Strict(float2 x)
{
  return IsNaN_Strict(x.x) || IsNaN_Strict(x.y);
}
bool IsAnyNaN_Strict(float3 x)
{
  return IsNaN_Strict(x.x) || IsNaN_Strict(x.y) || IsNaN_Strict(x.z);
}
bool IsAnyNaN_Strict(float4 x)
{
  return IsNaN_Strict(x.x) || IsNaN_Strict(x.y) || IsNaN_Strict(x.z) || IsNaN_Strict(x.w);
}

bool IsInfinite_Strict(float x)
{
    return abs(x) > FLT_MAX;
}
bool3 IsInfinite_Strict(float3 x)
{
    return abs(x) > FLT_MAX;
}

float inverseLerp(float a, float b, float value)
{
  // Avoid division by zero
  if (a == b) {
    return 0.0;
  }
  return (value - a) / (b - a);
}

float safePow(float base, float exponent)
{
  return pow(abs(base), exponent) * sign(base);
}
float3 safePow(float3 base, float exponent)
{
  return pow(abs(base), exponent) * sign(base);
}

float sqr(float x) { return x * x; }
float2 sqr(float2 x) { return x * x; }
float3 sqr(float3 x) { return x * x; }
float4 sqr(float4 x) { return x * x; }

float min3(float _a, float _b, float _c) { return min(_a, min(_b, _c)); }
float3 min3(float3 _a, float3 _b, float3 _c) { return min(_a, min(_b, _c)); }
float min3(float3 _a) { return min(_a.x, min(_a.y, _a.z)); }
float3 max3(float3 _a, float3 _b, float3 _c) { return max(_a, max(_b, _c)); }
float max3(float _a, float _b, float _c) { return max(_a, max(_b, _c)); }
float max3(float3 _a) { return max(_a.x, max(_a.y, _a.z)); }

// Returns a random value betweed 0 and 1
// "seed" can be in any space (e.g. pixel or uv or whatever else)
float3 NRand3(float2 seed, float tr = 1.0)
{
  return frac(sin(dot(seed.xy, float2(34.483, 89.637) * tr)) * float3(29156.4765, 38273.5639, 47843.7546));
}

// Takes coordinates centered around zero, and a normal for a cube of side size 1, both with origin at 0.
// The normal is expected to be negative/inverted (facing origin) (basically it's just the cube side).
bool cubeCoordinatesIntersection(out float3 intersection, float3 coordinates, float3 sideNormal)
{
  intersection = 0;
  if (dot(sideNormal, coordinates) >= -1.f)
    return false; // No intersection, the line is parallel or facing away from the plane
  // Compute the X value for the directed line ray intersecting the plane
  float t = -1.f / dot(sideNormal, coordinates);
  intersection = coordinates * t;
  return true;
}

#endif // SRC_MATH_HLSL