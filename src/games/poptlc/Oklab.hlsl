//TODOFT: put in externals folder? DICE as well? And rename DICE? And darktable ucs?

//RGB linear BT.709/sRGB -> OKLab's LMS
static const float3x3 srgb_to_oklms = {
	0.4122214708f, 0.5363325363f, 0.0514459929f,
	0.2119034982f, 0.6806995451f, 0.1073969566f,
	0.0883024619f, 0.2817188376f, 0.6299787005f};

//RGB linear BT.2020 -> OKLab's LMS
static const float3x3 bt2020_to_oklms = {
	0.616688430309295654296875f,  0.3601590692996978759765625f, 0.0230432935059070587158203125f,
	0.2651402056217193603515625f, 0.63585650920867919921875f,   0.099030233919620513916015625f,
	0.100150644779205322265625f,  0.2040043175220489501953125f, 0.69632470607757568359375f };

//OKLab's (_) L'M'S' -> OKLab
static const float3x3 oklms__to_oklab = {
	0.2104542553f,  0.7936177850f, -0.0040720468f,
	1.9779984951f, -2.4285922050f,  0.4505937099f,
	0.0259040371f,  0.7827717662f, -0.8086757660f};

//OKLab -> OKLab's L'M'S' (_)
//the 1s get optimized away by the compiler
static const float3x3 oklab_to_oklms_ = {
	1.f,  0.3963377774f,  0.2158037573f,
	1.f, -0.1055613458f, -0.0638541728f,
	1.f, -0.0894841775f, -1.2914855480f};

//OKLab's LMS -> RGB linear BT.709/sRGB
static const float3x3 oklms_to_srgb = {
	 4.0767416621f, -3.3077115913f,  0.2309699292f,
	-1.2684380046f,  2.6097574011f, -0.3413193965f,
	-0.0041960863f, -0.7034186147f,  1.7076147010f};

//OKLab's LMS -> RGB linear BT.2020
static const float3x3 oklms_to_bt2020 = {
	 2.1401402950286865234375f,      -1.24635589122772216796875f, 0.1064317226409912109375f,
	-0.884832441806793212890625f,     2.16317272186279296875f,   -0.2783615887165069580078125f,
	-0.048579059541225433349609375f, -0.4544909000396728515625f,  1.5023562908172607421875f };

// (in) linear sRGB/BT.709
// (out) OKLab
// L - perceived lightness
// a - how green/red the color is
// b - how blue/yellow the color is
float3 linear_srgb_to_oklab(float3 rgb) {
	//LMS
	float3 lms = mul(srgb_to_oklms, rgb);

	//L'M'S'
// Not sure whether the pow(abs())*sign() is technically correct, but if we pass in scRGB negative colors (or better, colors outside the Oklab gamut),
// this might break, and we think this might work fine
#if 1
	float3 lms_ = pow(abs(lms), 1.f/3.f) * sign(lms);
#else
	float3 lms_ = pow(lms, 1.f/3.f);
#endif

	return mul(oklms__to_oklab, lms_);
}

// (in) linear BT.2020
// (out) OKLab
float3 linear_bt2020_to_oklab(float3 rgb) {
	//LMS
	float3 lms = mul(bt2020_to_oklms, rgb);

	//L'M'S'
#if 1
	float3 lms_ = pow(abs(lms), 1.f/3.f) * sign(lms);
#else
	float3 lms_ = pow(lms, 1.f/3.f);
#endif

	return mul(oklms__to_oklab, lms_);
}

// (in) OKLab
// (out) linear sRGB/BT.709
float3 oklab_to_linear_srgb(float3 lab) {
	//L'M'S'
	float3 lms_ = mul(oklab_to_oklms_, lab);

	//LMS
	float3 lms = lms_ * lms_ * lms_;

	return mul(oklms_to_srgb, lms);
}

// (in) OKLab
// (out) linear BT.2020
float3 oklab_to_linear_bt2020(float3 lab) {
	//L'M'S'
	float3 lms_ = mul(oklab_to_oklms_, lab);

	//LMS
	float3 lms = lms_ * lms_ * lms_;

	return mul(oklms_to_bt2020, lms);
}

float3 oklab_to_oklch(float3 lab) {
	float L = lab[0];
	float a = lab[1];
	float b = lab[2];
	return float3(
		L,
		sqrt((a*a) + (b*b)), // The length of the color ab (or xy) offset, which represents saturation. Range 0+.
		atan2(b, a) // Hue. Range is -π/+π, and it can loop around.
	);
}

float3 oklch_to_oklab(float3 lch) {
	float L = lch[0];
	float C = lch[1];
	float h = lch[2];
	return float3(
		L,
		C * cos(h),
		C * sin(h)
	);
}

// (in) linear sRGB/BT.709
// (out) OKLch
// L – perceived lightness (identical to OKLAB)
// c – chroma (saturation)
// h – hue
float3 linear_srgb_to_oklch(float3 rgb) {
	return oklab_to_oklch(
		linear_srgb_to_oklab(rgb)
	);
}

// (in) linear BT.2020
// (out) OKLch
float3 linear_bt2020_to_oklch(float3 rgb) {
	return oklab_to_oklch(
		linear_bt2020_to_oklab(rgb)
	);
}

// (in) OKLch
// (out) sRGB/BT.709
float3 oklch_to_linear_srgb(float3 lch) {
	return oklab_to_linear_srgb(
			oklch_to_oklab(lch)
	);
}

// (in) OKLch
// (out) BT.2020
float3 oklch_to_linear_bt2020(float3 lch) {
	return oklab_to_linear_bt2020(
			oklch_to_oklab(lch)
	);
}