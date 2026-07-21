// BT.2020 (native gamut) - upscale + 32^3 calib LUT.
#define MEA_PRESENT_LUT3D 1
#include "../../shared.h"
#include "../linearize.hlsli"
#include "../lilium_rcas.hlsli"
#include "../present_core.hlsli"
#include "../../bicubic_upscale.hlsli"
#include "../output_upscale.hlsli"
