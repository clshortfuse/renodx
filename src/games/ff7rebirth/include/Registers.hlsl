// main
Texture3D<float4> View_SpatiotemporalBlueNoiseVolumeTexture : register(t0);  // Noise
Texture2D<float4> ColorTexture : register(t1);                               // Scene
Texture2D<float4> GlareTexture : register(t2);                               // Glare
Texture2D<float4> CompositeSDRTexture : register(t3);                        // UI

#if defined(USE_DEFAULT) || defined(USE_STATIC)
Texture3D<float4> BT709PQToBT2020PQLUT : register(t4);  // LUT

#if defined(USE_OVERLAY) && !defined(USE_DISPLAY_MAP)
Texture3D<float4> BT2020PQTosRGBLUT : register(t5);
#endif

#if defined(USE_DISPLAY_MAP) && !defined(USE_OVERLAY)
Texture3D<float4> BT2020PQ1000ToBT2020PQ250LUT : register(t5);  // display mapping
#endif

#if defined(USE_DISPLAY_MAP) && defined(USE_OVERLAY)
Texture3D<float4> BT2020PQTosRGBLUT : register(t5);
Texture3D<float4> BT2020PQ1000ToBT2020PQ250LUT : register(t6);  // display mapping
#endif

#endif

// fmv
#if defined(USE_FMV)
Texture2D<float4> CompositeSurfaceTexture : register(t4);  // FMV
Texture3D<float4> BT709PQToBT2020PQLUT : register(t5);
#if defined(USE_DISPLAY_MAP) && !defined(USE_OVERLAY)
Texture3D<float4> BT2020PQ1000ToBT2020PQ250LUT : register(t6);
#endif
#endif

// menu
#if defined(USE_MENU)
Texture2D<float4> CompositeSDRBackgroundTexture : register(t4);  // Menu background
Texture2D<float4> CompositeSDRForegroundTexture : register(t5);  // Menu foreground
Texture3D<float4> BT709PQToBT2020PQLUT : register(t6);

#if defined(USE_OVERLAY) && !defined(USE_DISPLAY_MAP)
Texture3D<float4> BT2020PQTosRGBLUT : register(t7);
#endif

#if defined(USE_DISPLAY_MAP) && !defined(USE_OVERLAY)
Texture3D<float4> BT2020PQ1000ToBT2020PQ250LUT : register(t7);
#endif
#endif

