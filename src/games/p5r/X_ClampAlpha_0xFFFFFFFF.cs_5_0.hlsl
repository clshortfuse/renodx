
RWTexture2D<float4> targetTexture : register(u0);

[numthreads(32, 32, 1)]
void main(uint3 dispatchThreadID : SV_DispatchThreadID)
{
    // Read the current pixel
    float4 pixel = targetTexture[dispatchThreadID.xy];

    // clamp negative colors and saturate alpha
    pixel.rgb = max(0, pixel.rgb);
    pixel.a = saturate(pixel.a);

    // Write the modified pixel back to the texture
    targetTexture[dispatchThreadID.xy] = pixel;
}
