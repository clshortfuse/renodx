// main
Texture3D<float4> View_SpatiotemporalBlueNoiseVolumeTexture : register(t0);  // Noise
Texture2D<float4> ColorTexture : register(t1);                               // Scene
Texture2D<float4> GlareTexture : register(t2);                               // Glare
Texture2D<float4> CompositeSDRTexture : register(t3);                        // UI

#if defined(SHADER_HASH_0xC67C6B5A) || defined(SHADER_HASH_0XD092CC63) || defined(SHADER_HASH_0xD0981514) || defined(SHADER_HASH_0xD7A19FB6)
Texture3D<float4> BT709PQToBT2020PQLUT : register(t4);  // LUT
#if defined(SHADER_HASH_0XD092CC63) || defined(SHADER_HASH_0xD7A19FB6)
Texture3D<float4> BT2020PQ1000ToBT2020PQ250LUT : register(t5);  // display mapping
#endif
#endif

// fmv
#if defined(SHADER_HASH_0xC9686A2D) || defined(SHADER_HASH_0xEFDBD563) || defined(SHADER_HASH_0x854B9174) || defined(SHADER_HASH_0x476D2C8F)
Texture2D<float4> CompositeSurfaceTexture : register(t4);  // FMV
Texture3D<float4> BT709PQToBT2020PQLUT : register(t5);
#if defined(SHADER_HASH_0xEFDBD563) || defined(SHADER_HASH_0x476D2C8F)
Texture3D<float4> BT2020PQ1000ToBT2020PQ250LUT : register(t6);
#endif
#endif

// menu
#if defined(SHADER_HASH_0xD31CF869) || defined(SHADER_HASH_0x288CF983) || defined(SHADER_HASH_0x15CB9307) || defined(SHADER_HASH_0x97E882E3)
Texture2D<float4> CompositeSDRBackgroundTexture : register(t4);  // Menu background
Texture2D<float4> CompositeSDRForegroundTexture : register(t5);  // Menu foreground
Texture3D<float4> BT709PQToBT2020PQLUT : register(t6);
#if defined(SHADER_HASH_0x288CF983) || defined(SHADER_HASH_0x97E882E3)
Texture3D<float4> BT2020PQ1000ToBT2020PQ250LUT : register(t7);
#endif
#endif

