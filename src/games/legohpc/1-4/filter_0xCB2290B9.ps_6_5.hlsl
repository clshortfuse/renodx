// mip blend → blur → noise → LUT (no vignette)
#define FILTER_MIP_BLEND
#define FILTER_BLUR
#define FILTER_TEXCOORD3
#include "filter_lut.hlsl"
