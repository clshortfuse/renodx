// Facade route: keep the logical FP16 buffer in linear scRGB for ReShade effects;
// HDR10/PQ is encoded later, at physical Present.
#define FFXIV_FINAL_SCRGB
#include "./final_pixel_shader.ps_5_0.hlsl"
