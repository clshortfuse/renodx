#include "../../shaders/color/convert.hlsl"
#include "../../shaders/color/pq.hlsl"

Texture2D<float4> composition : register(t0);

float4 main(float4 position : SV_Position) : SV_Target {
    float4 color = composition.Load(int3(int2(position.xy), 0));
    color.rgb = renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(color.rgb), 80.f);
    return float4(saturate(color.rgb), saturate(color.a));
}
