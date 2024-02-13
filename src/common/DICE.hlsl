#define FLT_MIN asfloat(0x00800000) //1.175494351e-38f
#define FLT_MAX asfloat(0x7F7FFFFF) //3.402823466e+38f

// sRGB/BT.709
float Luminance(float3 color)
{
	// Fixed from "wrong" values: 0.2125 0.7154 0.0721
	// Note: this might sum up to exactly 1, but it's pretty much fine either way
	return dot(color, float3(0.2126390039920806884765625f, 0.715168654918670654296875f, 0.072192318737506866455078125f));
}


// Aplies exponential ("Photographic") luminance/luma compression.
// The pow can modulate the curve without changing the values around the edges.
float rangeCompress(float X, float Max = FLT_MAX, float Pow = 1.f)
{
	// Branches are for static parameters optimizations
	if (Pow == 1.f && Max == FLT_MAX)
	{
		// This does e^X. We expect X to be between 0 and 1.
		return 1.f - exp(-X);
	}
	if (Pow == 1.f && Max != FLT_MAX)
	{
		const float fLostRange = exp(-Max);
		const float fRestoreRangeScale = 1.f / (1.f - fLostRange);
		return (1.f - exp(-X)) * fRestoreRangeScale;
	}
	if (Pow != 1.f && Max == FLT_MAX)
	{
		return (1.f - pow(exp(-X), Pow));
	}
	const float lostRange = pow(exp(-Max), Pow);
	const float restoreRangeScale = 1.f / (1.f - lostRange);
	return (1.f - pow(exp(-X), Pow)) * restoreRangeScale;
}

// Refurbished DICE HDR tonemapper (per channel or luminance)
float luminanceCompress(float InValue, float OutMaxValue, float ShoulderStart = 0.f, bool considerMaxValue = false, float InMaxValue = FLT_MAX, float ModulationPow = 1.f)
{
	const float compressableValue = InValue - ShoulderStart;
	const float compressableRange = InMaxValue - ShoulderStart;
	const float compressedRange = max(OutMaxValue - ShoulderStart, FLT_MIN);
	const float possibleOutValue = ShoulderStart + compressedRange * rangeCompress(compressableValue / compressedRange, considerMaxValue ? (compressableRange / compressedRange) : FLT_MAX, ModulationPow);
	return InValue <= ShoulderStart ? InValue : possibleOutValue;
}


// Tonemapper inspired from DICE. Can work by luminance to maintain hue.
// "HighlightsShoulderStart" should be between 0 and 1. Determines where the highlights curve (shoulder) starts. Leaving at zero for now as it's a simple and good looking default.
float3 DICETonemap(
	float3 Color,
	float  MaxOutputLuminance,
	float  HighlightsShoulderStart = 0.f,
	float  HighlightsModulationPow = 1.f)
{

	const float sourceLuminance = Luminance(Color);
	if (sourceLuminance > 0.0f)
	{
		const float compressedLuminance = luminanceCompress(sourceLuminance, MaxOutputLuminance, HighlightsShoulderStart, false, FLT_MAX, HighlightsModulationPow);
		Color *= compressedLuminance / sourceLuminance;
	}
	return Color;


	Color.r = luminanceCompress(Color.r, MaxOutputLuminance, HighlightsShoulderStart, false, FLT_MAX, HighlightsModulationPow);
	Color.g = luminanceCompress(Color.g, MaxOutputLuminance, HighlightsShoulderStart, false, FLT_MAX, HighlightsModulationPow);
	Color.b = luminanceCompress(Color.b, MaxOutputLuminance, HighlightsShoulderStart, false, FLT_MAX, HighlightsModulationPow);
	return Color;

}
