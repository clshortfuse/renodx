#define FLT_MIN asfloat(0x00800000)  //1.175494351e-38f
#define FLT_MAX asfloat(0x7F7FFFFF)  //3.402823466e+38f

#define PI 3.141592653589793238462643383279502884197
#define PI_X2 (PI * 2.0)
#define PI_X4 (PI_X4 * 4.0)

float average(float3 color)
{
	return (color.x + color.y + color.z) / 3.f;
}

// Returns 0, 1 or FLT_MAX if "dividend" is 0
float safeDivision(float quotient, float dividend, int fallbackMode = 0)
{
	if (dividend == 0.f) {
        if (fallbackMode == 0)
          return 0;
        if (fallbackMode == 1)
          return sign(quotient);
        return FLT_MAX * sign(quotient);
    }
    return quotient / dividend;
}

// Returns 0, 1 or FLT_MAX if "dividend" is 0
float3 safeDivision(float3 quotient, float3 dividend, int fallbackMode = 0)
{
    return float3(safeDivision(quotient.x, dividend.x, fallbackMode), safeDivision(quotient.y, dividend.y, fallbackMode), safeDivision(quotient.z, dividend.z, fallbackMode));
}

float3 sqr(float3 x) { return x * x; }
float sqr(float x) { return x * x; }

float min3(float _a, float _b, float _c) { return min(_a, min(_b, _c)); }
float3 min3(float3 _a, float3 _b, float3 _c) { return min(_a, min(_b, _c)); }
float min3(float3 _a) { return min(_a.x, min(_a.y, _a.z)); }
float3 max3(float3 _a, float3 _b, float3 _c) { return max(_a, max(_b, _c)); }
float max3(float _a, float _b, float _c) { return max(_a, max(_b, _c)); }
float max3(float3 _a) { return max(_a.x, max(_a.y, _a.z)); }

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

float getDistanceFromCubeEdge(float3 normal)
{
	static const float cubeDiagonalLength = sqrt(3.0);
  
#if 1 // Theoretically the input is already a normal so we could skip this
	if (length(normal) <= FLT_MIN)
  {
    // For pure black, pretend the output is pure white
    return cubeDiagonalLength;
  }
#endif

  // Abs() because all directions are mirrored.
	// We restrict the possible intersections from 6 to 3 cube faces
  normal = abs(normal);
  
  // Multiply by (e.g.) 3 to make the vector long enough to always intersect with an edge of the cube
  normal *= 3.0;

	float3 currentIntersection;
	float intersectionLength = FLT_MAX;
	bool foundIntersection = false;
	// Find the closest intersection with each cube edge as a plane (multiple planes would intersect, likely all 3)
	if (cubeCoordinatesIntersection(currentIntersection, normal, float3(-1.f, 0.f, 0.f)))
	{
		foundIntersection = true;
		intersectionLength = length(currentIntersection);
	}
	if (cubeCoordinatesIntersection(currentIntersection, normal, float3(0.f, -1.f, 0.f)))
	{
		foundIntersection = true;
		float currentIntersectionLength = length(currentIntersection);
		if (currentIntersectionLength < intersectionLength)
			intersectionLength = currentIntersectionLength;
	}
	if (cubeCoordinatesIntersection(currentIntersection, normal, float3(0.f, 0.f, -1.f)))
	{
		foundIntersection = true;
		float currentIntersectionLength = length(currentIntersection);
		if (currentIntersectionLength < intersectionLength)
			intersectionLength = currentIntersectionLength;
	}

#if 1 // This can't can't really happen so we can disabled as an optimization
	if (!foundIntersection)
    return cubeDiagonalLength;
#endif

	return intersectionLength;
}