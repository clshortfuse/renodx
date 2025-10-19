#ifndef SRC_COLOR_HLSL
#define SRC_COLOR_HLSL

#include "./Math.hlsl"

// Needed by "linearToLog()" and "logToLinear()"
#pragma warning( disable : 4122 )

// SDR linear mid gray.
// This is based on the commonly used value, though perception space mid gray (0.5) in sRGB or Gamma 2.2 would theoretically be ~0.2155 in linear.
static const float MidGray = 0.18f;
#ifdef CUSTOM_SDR_GAMMA
static const float DefaultGamma = CUSTOM_SDR_GAMMA;
#else
static const float DefaultGamma = 2.2f;
#endif
static const float3 Rec709_Luminance = float3(0.2126f, 0.7152f, 0.0722f);
static const float3 Rec2020_Luminance = float3(0.2627066f, 0.6779996f, 0.0592938f);
static const float3 AP1_Luminance = float3(0.2722287168f, 0.6740817658f, 0.0536895174f);
static const float HDR10_MaxWhiteNits = 10000.0f;
static const float ITU_WhiteLevelNits = 203.0f;
static const float Rec709_WhiteLevelNits = 100.0f;
static const float sRGB_WhiteLevelNits = 80.0f;

// "Gamma" clamp type "enum":
// 0 None
// 1 Remove negative numbers
// 2 Remove numbers beyond 0-1
// 3 Mirror negative numbers before and after encoding
#define GCT_NONE 0
#define GCT_POSITIVE 1
#define GCT_SATURATE 2
#define GCT_MIRROR 3

#ifndef GCT_DEFAULT
#define GCT_DEFAULT GCT_NONE
#endif

static const float3x3 BT709_2_XYZ = float3x3
  (0.412390798f,  0.357584327f, 0.180480793f,
   0.212639003f,  0.715168654f, 0.0721923187f, // ~same as "Rec709_Luminance"
   0.0193308182f, 0.119194783f, 0.950532138f);

#define CS_BT709 0
#define CS_BT2020 1
#define CS_AP1 2

#define CS_DEFAULT CS_BT709

float GetLuminance(float3 color, uint colorSpace = CS_DEFAULT)
{
	if (colorSpace == CS_BT2020)
	{
		return dot(color, Rec2020_Luminance);
	}
	else if (colorSpace == CS_AP1)
	{
		// AP1 is basically DCI-P3 with a D65 white point
		return dot(color, AP1_Luminance);
	}
	return dot(color, Rec709_Luminance);
}

float3 RestoreLuminance(float3 targetColor, float sourceColorLuminance, bool safe = false, uint colorSpace = CS_DEFAULT)
{
  float targetColorLuminance = GetLuminance(targetColor, colorSpace);
  // Handles negative values and gives more tolerance for divisions by small numbers
  if (safe)
  {
#if 0 // Disabled as it doesn't seem to help (we'd need to set the threshold to "0.001" (which is too high) for this to pick up the cases where divisions end up denormalizing the number etc)
    if (abs(targetColorLuminance - sourceColorLuminance) <= FLT_EPSILON)
    {
      return targetColor;
    }
#endif
    targetColorLuminance = max(targetColorLuminance, 0.0);
    sourceColorLuminance = max(sourceColorLuminance, 0.0);
#if 1
    return targetColor * (targetColorLuminance <= (FLT_EPSILON * 10.0) ? 0.0 : (sourceColorLuminance / targetColorLuminance)); // Empyrically found threshold. Note that this will zero the target color, flattining its RGB ratio (it might have had dithering)
#else
    return targetColor * safeDivision(sourceColorLuminance, targetColorLuminance, 0);
#endif
  }
  return targetColor * safeDivision(sourceColorLuminance, targetColorLuminance, 1);
}
float3 RestoreLuminance(float3 targetColor, float3 sourceColor, bool safe = false, uint colorSpace = CS_DEFAULT)
{
  return RestoreLuminance(targetColor, GetLuminance(sourceColor, colorSpace), safe, colorSpace);
}

 // Note: the result might depend on the color space
float GetChrominance(float3 color)
{
    float maxVal = max(color.r, max(color.g, color.b));
    float minVal = min(color.r, min(color.g, color.b));
    return (maxVal == 0.0) ? 0.0 : saturate((maxVal - minVal) / maxVal);
}

// Returns 1 if the color is a greyscale, more otherwise
 // Note: the result of this depends on the color space
float GetSaturation(float3 color, uint colorSpace = CS_DEFAULT)
{
	float luminance = GetLuminance(color, colorSpace);
	return (luminance == 0.0) ? 1.0 : max3(color) / luminance; // Find the ratio of the color against the luminance
}

float3 Saturation(float3 color, float saturation, uint colorSpace = CS_DEFAULT)
{
	float luminance = GetLuminance(color, colorSpace);
	return lerp(luminance, color, saturation);
}

float3 RestoreSaturation(float3 sourceColor, float3 targetColor, uint colorSpace = CS_DEFAULT)
{
	float sourceSaturation = GetSaturation(sourceColor, colorSpace);
	float targetSaturation = GetSaturation(targetColor, colorSpace);
	float saturationRatio = safeDivision(sourceSaturation, targetSaturation, 1);
	return Saturation(targetColor, saturationRatio, colorSpace);
}

 // Note: the result of this depends on the color space
float3 RestoreChrominance(float3 sourceColor, float3 targetColor, uint colorSpace = CS_DEFAULT)
{
	float sourceChrominance = GetChrominance(sourceColor);
	float targetChrominance = GetChrominance(targetColor);
	float chrominanceRatio = safeDivision(sourceChrominance, targetChrominance, 1);
	// We can't simply change the min, max or mid colors independently to change chrominance, or we'd heavily shift the luminance,
	// so we use the saturation formula.
	return Saturation(targetColor, chrominanceRatio, colorSpace);
}

// This basically does gamut mapping, however it's not focused on gamut as primaries, but on peak white.
// The color is expected to be in the specified color space and in linear.
// 
// The sum of "DesaturationAmount" and "DarkeningAmount" needs to be <= 1, both within 0 and 1.
// The closer the sum is to 1, the more each color channel will be containted within its peak range.
float3 CorrectOutOfRangeColor(float3 Color, bool FixNegatives = true, bool FixPositives = true, float DesaturationAmount = 0.5, float DarkeningAmount = 0.5, float Peak = 1.0, uint ColorSpace = CS_DEFAULT)
{
  if (FixNegatives && any(Color < 0.0)) // Optional "optimization" branch
  {
    float colorLuminance = GetLuminance(Color, ColorSpace);

    float3 positiveColor = max(Color.xyz, 0.0);
	float3 negativeColor = min(Color.xyz, 0.0);
	float positiveLuminance = GetLuminance(positiveColor, ColorSpace);
	float negativeLuminance = GetLuminance(negativeColor, ColorSpace);
	// Desaturate until we are not out of gamut anymore
	if (colorLuminance > FLT_MIN)
	{
#if 0
	  float negativePositiveLuminanceRatio = -negativeLuminance / positiveLuminance;
	  float3 positiveColorRestoredLuminance = RestoreLuminance(positiveColor, colorLuminance, true, ColorSpace);
	  Color = lerp(lerp(Color, positiveColorRestoredLuminance, sqrt(DesaturationAmount)), colorLuminance, negativePositiveLuminanceRatio * sqrt(DesaturationAmount));
#else // This should look better and be faster
	  const float3 luminanceRatio = (ColorSpace == CS_BT2020) ? Rec2020_Luminance : ((ColorSpace == CS_AP1) ? AP1_Luminance : Rec709_Luminance);
	  float3 negativePositiveLuminanceRatio = -(negativeColor / luminanceRatio) / (positiveLuminance / luminanceRatio);
	  Color = lerp(Color, colorLuminance, negativePositiveLuminanceRatio * DesaturationAmount);
#endif
	  // TODO: "DarkeningAmount" isn't normalized with "DesaturationAmount", so setting both to 50% won't perfectly stop gamut clip
      positiveColor = max(Color.xyz, 0.0);
	  negativeColor = min(Color.xyz, 0.0);
	  Color = positiveColor + (negativeColor * (1.0 - DarkeningAmount)); // It's not darkening but brightening in this case
	}
	// Increase luminance until it's 0 if we were below 0 (it will clip out the negative gamut)
	else if (colorLuminance < -FLT_MIN)
	{
	  float negativePositiveLuminanceRatio = positiveLuminance / -negativeLuminance;
	  negativeColor.xyz *= negativePositiveLuminanceRatio;
	  Color.xyz = positiveColor + negativeColor;
	}
	// Snap to 0 if the overall luminance was zero, there's nothing to savage, no valid information on rgb ratio
	else
	{
	  Color.xyz = 0.0;
	}
  }

  if (FixPositives && any(Color > Peak)) // Optional "optimization" branch
  {
    float colorLuminance = GetLuminance(Color, ColorSpace);
    float colorLuminanceInExcess = colorLuminance - Peak;
    float maxColorInExcess = max3(Color) - Peak; // This is guaranteed to be >= "colorLuminanceInExcess"
    float brightnessReduction = saturate(safeDivision(Peak, max3(Color), 1)); // Fall back to one in case of division by zero
    float desaturateAlpha = saturate(safeDivision(maxColorInExcess, maxColorInExcess - colorLuminanceInExcess, 0)); // Fall back to zero in case of division by zero
    Color = lerp(Color, colorLuminance, desaturateAlpha * DesaturationAmount);
    Color = lerp(Color, Color * brightnessReduction, DarkeningAmount); // Also reduce the brightness to partially maintain the hue, at the cost of brightness
  }

  return Color;
}

float3 linear_to_gamma(float3 Color, int ClampType = GCT_DEFAULT, float Gamma = DefaultGamma)
{
	float3 colorSign = sign(Color);
	if (ClampType == GCT_POSITIVE)
		Color = max(Color, 0.f);
	else if (ClampType == GCT_SATURATE)
		Color = saturate(Color);
	else if (ClampType == GCT_MIRROR)
		Color = abs(Color);
	Color = pow(Color, 1.f / Gamma);
	if (ClampType == GCT_MIRROR)
		Color *= sign(colorSign);
	return Color;
}

// 1 component
float gamma_to_linear1(float Color, int ClampType = GCT_DEFAULT, float Gamma = DefaultGamma)
{
	float colorSign = sign(Color);
	if (ClampType == GCT_POSITIVE)
		Color = max(Color, 0.f);
	else if (ClampType == GCT_SATURATE)
		Color = saturate(Color);
	else if (ClampType == GCT_MIRROR)
		Color = abs(Color);
	Color = pow(Color, Gamma);
	if (ClampType == GCT_MIRROR)
		Color *= sign(colorSign);
	return Color;
}

// 1 component
float linear_to_gamma1(float Color, int ClampType = GCT_DEFAULT, float Gamma = DefaultGamma)
{
	float colorSign = sign(Color);
	if (ClampType == GCT_POSITIVE)
		Color = max(Color, 0.f);
	else if (ClampType == GCT_SATURATE)
		Color = saturate(Color);
	else if (ClampType == GCT_MIRROR)
		Color = abs(Color);
	Color = pow(Color, 1.f / Gamma);
	if (ClampType == GCT_MIRROR)
		Color *= sign(colorSign);
	return Color;
}

float3 gamma_to_linear(float3 Color, int ClampType = GCT_DEFAULT, float Gamma = DefaultGamma)
{
	float3 colorSign = sign(Color);
	if (ClampType == GCT_POSITIVE)
		Color = max(Color, 0.f);
	else if (ClampType == GCT_SATURATE)
		Color = saturate(Color);
	else if (ClampType == GCT_MIRROR)
		Color = abs(Color);
	Color = pow(Color, Gamma);
	if (ClampType == GCT_MIRROR)
		Color *= sign(colorSign);
	return Color;
}

float gamma_sRGB_to_linear1(float Channel, int ClampType = GCT_DEFAULT)
{
	float channelSign = sign(Channel);
	if (ClampType == GCT_POSITIVE)
		Channel = max(Channel, 0.f);
	else if (ClampType == GCT_SATURATE)
		Channel = saturate(Channel);
	else if (ClampType == GCT_MIRROR)
		Channel = abs(Channel);

	if (Channel <= 0.04045f)
		Channel = Channel / 12.92f;
	else
		Channel = pow((Channel + 0.055f) / 1.055f, 2.4f);
		
	if (ClampType == GCT_MIRROR)
		Channel *= sign(channelSign);

	return Channel;
}

// The sRGB gamma formula already works beyond the 0-1 range but mirroring (and thus running the pow below 0 too) makes it look better
float3 gamma_sRGB_to_linear(float3 Color, int ClampType = GCT_DEFAULT)
{
	float3 colorSign = sign(Color);
	if (ClampType == GCT_POSITIVE)
		Color = max(Color, 0.f);
	else if (ClampType == GCT_SATURATE)
		Color = saturate(Color);
	else if (ClampType == GCT_MIRROR)
		Color = abs(Color);
	Color = float3(gamma_sRGB_to_linear1(Color.r, GCT_NONE), gamma_sRGB_to_linear1(Color.g, GCT_NONE), gamma_sRGB_to_linear1(Color.b, GCT_NONE));
	if (ClampType == GCT_MIRROR)
		Color *= sign(colorSign);
	return Color;
}

float linear_to_sRGB_gamma1(float Channel, int ClampType = GCT_DEFAULT)
{
	float channelSign = sign(Channel);
	if (ClampType == GCT_POSITIVE)
		Channel = max(Channel, 0.f);
	else if (ClampType == GCT_SATURATE)
		Channel = saturate(Channel);
	else if (ClampType == GCT_MIRROR)
		Channel = abs(Channel);

	if (Channel <= 0.0031308f)
		Channel = Channel * 12.92f;
	else
		Channel = 1.055f * pow(Channel, 1.f / 2.4f) - 0.055f;
		
	if (ClampType == GCT_MIRROR)
		Channel *= sign(channelSign);

	return Channel;
}

// The sRGB gamma formula already works beyond the 0-1 range but mirroring (and thus running the pow below 0 too) makes it look better
float3 linear_to_sRGB_gamma(float3 Color, int ClampType = GCT_DEFAULT)
{
	float3 colorSign = sign(Color);
	if (ClampType == GCT_POSITIVE)
		Color = max(Color, 0.f);
	else if (ClampType == GCT_SATURATE)
		Color = saturate(Color);
	else if (ClampType == GCT_MIRROR)
		Color = abs(Color);
	Color = float3(linear_to_sRGB_gamma1(Color.r, GCT_NONE), linear_to_sRGB_gamma1(Color.g, GCT_NONE), linear_to_sRGB_gamma1(Color.b, GCT_NONE));
	if (ClampType == GCT_MIRROR)
		Color *= sign(colorSign);
	return Color;
}

// Optimized gamma<->linear functions (don't use unless really necessary, they are not accurate)
float3 sqr_mirrored(float3 x)
{
	return sqr(x) * sign(x); // LUMA FT: added mirroring to support negative colors
}
float3 sqrt_mirrored(float3 x)
{
	return sqrt(abs(x)) * sign(x); // LUMA FT: added mirroring to support negative colors
}

static const float PQ_constant_M1 =  0.1593017578125f;
static const float PQ_constant_M2 = 78.84375f;
static const float PQ_constant_C1 =  0.8359375f;
static const float PQ_constant_C2 = 18.8515625f;
static const float PQ_constant_C3 = 18.6875f;

// PQ (Perceptual Quantizer - ST.2084) encode/decode used for HDR10 BT.2100.
float3 Linear_to_PQ(float3 LinearColor, int clampType = GCT_DEFAULT)
{
	float3 LinearColorSign = sign(LinearColor);
	if (clampType == GCT_POSITIVE)
		LinearColor = max(LinearColor, 0.f);
	else if (clampType == GCT_SATURATE)
		LinearColor = saturate(LinearColor);
	else if (clampType == GCT_MIRROR)
		LinearColor = abs(LinearColor);
	float3 colorPow = pow(LinearColor, PQ_constant_M1);
	float3 numerator = PQ_constant_C1 + PQ_constant_C2 * colorPow;
	float3 denominator = 1.f + PQ_constant_C3 * colorPow;
	float3 pq = pow(numerator / denominator, PQ_constant_M2);
	if (clampType == GCT_MIRROR)
		return pq * LinearColorSign;
	return pq;
}

float3 PQ_to_Linear(float3 ST2084Color, int clampType = GCT_DEFAULT)
{
	float3 ST2084ColorSign = sign(ST2084Color);
	if (clampType == GCT_POSITIVE)
		ST2084Color = max(ST2084Color, 0.f);
	else if (clampType == GCT_SATURATE)
		ST2084Color = saturate(ST2084Color);
	else if (clampType == GCT_MIRROR)
		ST2084Color = abs(ST2084Color);
	float3 colorPow = pow(ST2084Color, 1.f / PQ_constant_M2);
	float3 numerator = max(colorPow - PQ_constant_C1, 0.f);
	float3 denominator = PQ_constant_C2 - (PQ_constant_C3 * colorPow);
	float3 linearColor = pow(numerator / denominator, 1.f / PQ_constant_M1);
	if (clampType == GCT_MIRROR)
		return linearColor * ST2084ColorSign;
	return linearColor;
}

// This defines the range you want to cover under log2: 2^14 = 16384,
// 14 is the minimum value to cover 10k nits.
static const float LogLinearRange = 14.f;
// This is the grey point you want to adjust with the "exposure grey" parameter
static const float LogLinearGrey = 0.18f;
// This defines what an input matching the "linear grey" parameter will end up at in log space
static const float LogGrey = 1.f / 3.f;

// Note that an input of zero will not match and output of zero.
float3 linearToLog_internal(float3 linearColor, float3 logGrey = LogGrey)
{
	return (log2(linearColor) / LogLinearRange) - (log2(LogLinearGrey) / LogLinearRange) + logGrey;
}
// "logColor" is expected to be != 0.
float3 logToLinear_internal(float3 logColor, float3 logGrey = LogGrey)
{
//#pragma warning( disable : 4122 ) // Note: this doesn't work here
	return exp2((logColor - logGrey) * LogLinearRange) * LogLinearGrey;
//#pragma warning( default : 4122 )
}

// Perceptual encoding functions (more accurate than HDR10 PQ).
// "linearColor" is expected to be >= 0 and with a white point around 80-100.
// These function are "normalized" so that they will map a linear color value of 0 to a log encoding of 0.
float3 linearToLog(float3 linearColor, int clampType = GCT_DEFAULT, float3 logGrey = LogGrey)
{
	float3 linearColorSign = sign(linearColor);
	if (clampType == GCT_POSITIVE || clampType == GCT_SATURATE)
		linearColor = max(linearColor, 0.f);
	else if (clampType == GCT_MIRROR)
		linearColor = abs(linearColor);
    float3 normalizedLogColor = linearToLog_internal(linearColor + logToLinear_internal(FLT_MIN, logGrey), logGrey);
	if (clampType == GCT_MIRROR)
		normalizedLogColor *= sign(linearColorSign);
	return normalizedLogColor;
}
float3 logToLinear(float3 normalizedLogColor, int clampType = GCT_DEFAULT, float3 logGrey = LogGrey)
{
	float3 normalizedLogColorSign = sign(normalizedLogColor);
	if (clampType == GCT_MIRROR)
		normalizedLogColor = abs(normalizedLogColor);
	float3 linearColor = max(logToLinear_internal(normalizedLogColor, logGrey) - logToLinear_internal(FLT_MIN, logGrey), 0.f);
	if (clampType == GCT_MIRROR)
		linearColor *= sign(normalizedLogColorSign);
	return linearColor;
}

static const float3x3 BT709_2_BT2020 = {
	0.627403914928436279296875f,      0.3292830288410186767578125f,  0.0433130674064159393310546875f,
	0.069097287952899932861328125f,   0.9195404052734375f,           0.011362315155565738677978515625f,
	0.01639143936336040496826171875f, 0.08801330626010894775390625f, 0.895595252513885498046875f };

static const float3x3 BT2020_2_BT709 = {
	 1.66049098968505859375f,          -0.58764111995697021484375f,     -0.072849862277507781982421875f,
	-0.12455047667026519775390625f,     1.13289988040924072265625f,     -0.0083494223654270172119140625f,
	-0.01815076358616352081298828125f, -0.100578896701335906982421875f,  1.11872971057891845703125f };

static const float3x3 BT601_2_BT709 = {
    0.939497225737661f,					0.0502268452914346f,			0.0102759289709032f,
    0.0177558637510127f,				0.965824605885027f,				0.0164195303639603f,
   -0.0016216320996701f,				-0.00437400622653655f,			1.00599563832621f };

float3 BT709_To_BT2020(float3 color)
{
	return mul(BT709_2_BT2020, color);
}

float3 BT2020_To_BT709(float3 color)
{
	return mul(BT2020_2_BT709, color);
}

// TODO: this doesn't seem to be right... Tested with Mafia III videos.
float3 BT601_To_BT709(float3 color)
{
	return mul(BT601_2_BT709, color);
}

static const float2 D65xy = float2(0.3127f, 0.3290f);

static const float2 R2020xy = float2(0.708f, 0.292f);
static const float2 G2020xy = float2(0.170f, 0.797f);
static const float2 B2020xy = float2(0.131f, 0.046f);

static const float2 R709xy = float2(0.64f, 0.33f);
static const float2 G709xy = float2(0.30f, 0.60f);
static const float2 B709xy = float2(0.15f, 0.06f);

static const float3x3 BT2020_To_XYZ = {
	0.636958062648773193359375f, 0.144616901874542236328125f,    0.1688809692859649658203125f,
	0.26270020008087158203125f,  0.677998065948486328125f,       0.0593017153441905975341796875f,
	0.f,                         0.028072692453861236572265625f, 1.060985088348388671875f};

static const float3x3 XYZ_To_BT2020 = {
	 1.7166512012481689453125f,       -0.3556707799434661865234375f,   -0.253366291522979736328125f,
	-0.666684329509735107421875f,      1.61648118495941162109375f,      0.0157685466110706329345703125f,
	 0.0176398567855358123779296875f, -0.0427706129848957061767578125f, 0.9421031475067138671875f };

static const float3x3 BT709_To_XYZ = {
	0.4123907983303070068359375f,    0.3575843274593353271484375f,   0.18048079311847686767578125f,
	0.2126390039920806884765625f,    0.715168654918670654296875f,    0.072192318737506866455078125f,
	0.0193308182060718536376953125f, 0.119194783270359039306640625f, 0.950532138347625732421875f };

static const float3x3 XYZ_To_BT709 = {
	 3.2409698963165283203125f,      -1.53738319873809814453125f,  -0.4986107647418975830078125f,
	-0.96924364566802978515625f,      1.875967502593994140625f,     0.0415550582110881805419921875f,
	 0.055630080401897430419921875f, -0.2039769589900970458984375f, 1.05697154998779296875f };

float3 XYZToxyY(float3 XYZ)
{
	const float xyz = XYZ.x + XYZ.y + XYZ.z;
	float x = XYZ.x / xyz;
	float y = XYZ.y / xyz;
	return float3(x, y, XYZ.y);
}

float3 xyYToXYZ(float3 xyY)
{
	float X = (xyY.x / xyY.y) * xyY.z;
	float Z = ((1.f - xyY.x - xyY.y) / xyY.y) * xyY.z;
	return float3(X, xyY.z, Z);
}

float GetM(float2 A, float2 B)
{
	return (B.y - A.y) / (B.x - A.x);
}

float2 LineIntercept(float MP, float2 FromXYCoords, float2 ToXYCoords, float2 WhitePointXYCoords = D65xy)
{
	const float m = GetM(FromXYCoords, ToXYCoords);
	const float m_mul_xyx = m * FromXYCoords.x;

	const float m_minus_MP = m - MP;
	const float MP_mul_WhitePoint_xyx = MP * WhitePointXYCoords.x;

	float x = (-MP_mul_WhitePoint_xyx + WhitePointXYCoords.y - FromXYCoords.y + m_mul_xyx) / m_minus_MP;
	float y = (-WhitePointXYCoords.y * m + m * MP_mul_WhitePoint_xyx + FromXYCoords.y * MP - m_mul_xyx * MP) / -m_minus_MP;
	return float2(x, y);
}

// convert hue, saturation, value to RGB
// https://en.wikipedia.org/wiki/HSL_and_HSV
float3 HSV_To_RGB(float3 HSV)
{
    float h1 = HSV.x * 6.f;
    float c = HSV.z * HSV.y;
    float x = c * ( 1.f - abs(fmod(h1, 2.f) - 1.f));
    float3 rgb = 0.f;
    if( h1 <= 1.f )
        rgb = float3( c, x, 0.f );
    else if( h1 <= 2.f )
        rgb = float3( x, c, 0.f );
    else if( h1 <= 3.f )
        rgb = float3( 0.f, c, x );
    else if( h1 <= 4.f )
        rgb = float3( 0.f, x, c );
    else if( h1 <= 5.f )
        rgb = float3( x, 0.f, c );
    else if( h1 <= 6.f )
        rgb = float3( c, 0.f, x );
    float m = HSV.z - c;
    return float3(rgb.x + m, rgb.y + m, rgb.z + m);
}
// Works in every color space
float3 HueToRGB(float h, bool hideWhite = false)
{
    const int raw_N = 7;
    int N = raw_N;
	if (hideWhite) N--;
    float interval = 1.0 / N;

	if (!hideWhite) // Start from white
		h -= interval;
    float t = frac(h); // Loop around
    //float t = abs(frac(h * 0.5) * 2.0 - 1.0); // Loop around

    // 7 non-empty RGB combinations
	// From left to right (smaller "h" to bigger "h")
    float3 combos[raw_N] = {
        float3(1,0,0), // R: Red
        float3(1,1,0), // R+G: Yellow
        float3(0,1,0), // G: Green
        float3(0,1,1), // G+B: Cyan
        float3(0,0,1), // B: Blue
        float3(1,0,1), // R+B: Magenta
        float3(1,1,1)  // R+G+B: White (optional)
    };
    
    int i = min(int(t / interval), N-1);
    int next = (i + 1) % N;
    
    float localT = (t - i * interval) / interval;
	
	float powStrength = 0.666; // Makes transitions smoother with higher values
	localT = (localT - 0.5) * 2.0;
	localT = pow(abs(localT), powStrength) * sign(localT);
	localT = (localT * 0.5) + 0.5;
    
    // Blend between current and next combination
    return lerp(combos[i], combos[next], localT);
}

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

float3 BT709_To_AP1(float3 color)
{
	return mul(BT709_TO_AP1_MAT, color);
}

float3 AP1_To_BT709(float3 color)
{
	return mul(AP1_TO_BT709_MAT, color);
}

float3 BT2020_To_AP1(float3 color)
{
	return mul(BT2020_TO_AP1_MAT, color);
}

float3 AP1_To_BT2020(float3 color)
{
	return mul(AP1_TO_BT2020_MAT, color);
}

#endif // SRC_COLOR_HLSL