#ifndef SRC_007FIRSTLIGHT_OUTPUT_HLSLI_
#define SRC_007FIRSTLIGHT_OUTPUT_HLSLI_

#include "../common.hlsli"

float4 EncodeOutputPQ(float3 color, float4 resolve_params) {
	float paper_white = resolve_params.z * resolve_params.y * 10000.f;

	if (TONE_MAP_TYPE != 0.f) paper_white = RENODX_GRAPHICS_WHITE_NITS;

	float3 texture_bt709 = renodx::color::gamma::DecodeSafe(color, 2.2f);
	float3 texture_bt2020 = renodx::color::bt2020::from::BT709(texture_bt709);
	return float4(renodx::color::pq::EncodeSafe(texture_bt2020, paper_white), 1.f);
}

#endif  // SRC_007FIRSTLIGHT_OUTPUT_HLSLI_