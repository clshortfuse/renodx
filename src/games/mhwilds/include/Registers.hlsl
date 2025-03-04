// LUTBuilder
Texture2D<float4> OCIO_lut1d_0 : register(t0);

Texture3D<float4> OCIO_lut3d_1 : register(t1);

RWTexture3D<float4> OutLUT : register(u0);

SamplerState BilinearClamp : register(s5, space32);

// Output
Texture2D<float4> SrcTexture : register(t0);

Texture3D<float4> SrcLUT : register(t1);

SamplerState PointBorder : register(s2, space32);

// Shared

SamplerState TrilinearClamp : register(s9, space32);
