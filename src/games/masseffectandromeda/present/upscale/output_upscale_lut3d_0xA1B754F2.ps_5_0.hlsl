// BT.2020 output-gamut hash.
#define MEA_PRESENT_LUT3D 1
#define MEA_PRESENT_FILTER 1
#include "../../shared.h"
#include "../linearize.hlsli"
#include "../lilium_rcas.hlsli"
#include "../present_core.hlsli"
#include "../../bicubic_upscale.hlsli"
#include "../output_scaled.hlsli"
