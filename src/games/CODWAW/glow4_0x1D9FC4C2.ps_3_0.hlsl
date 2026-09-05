//
// Call of Duty: World at War
// Disabled / no-output replacement.
//
// This shader intentionally writes NOTHING.
//
// Every pixel is discarded with clip(-1.0f).
//
// This is preferable to:
//
//     return float4(0, 0, 0, 0);
//
// because returning zero still writes black/transparent values to the
// render target. With clip(), the pixel shader produces no output.
//

sampler2D colorMapSampler : register(s0);

float4 colorTintBase  : register(c5);
float4 colorTintDelta : register(c6);
float4 colorBias      : register(c7);


struct PixelInput
{
    float4 color    : COLOR0;
    float2 texCoord : TEXCOORD0;
};


float4 main(PixelInput input) : COLOR0
{
    // Always discard the pixel.
    //
    // A negative clip value causes the current pixel to be killed.
    // Therefore this pass writes nothing to the render target.

    clip(-1.0f);

    // Required syntactically even though this line is unreachable.
    return 0.0f;
}