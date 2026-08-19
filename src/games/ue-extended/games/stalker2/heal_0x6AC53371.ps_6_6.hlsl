#include "../postfx.hlsli"

Texture2D<float4> PostProcessInput_0_Texture : register(t0);

cbuffer $Globals : register(b0) {
  float2 PostProcessInput_0_Extent : packoffset(c000.x);
  float2 PostProcessInput_0_ExtentInverse : packoffset(c000.z);
  float2 PostProcessInput_0_ScreenPosToViewportScale : packoffset(c001.x);
  float2 PostProcessInput_0_ScreenPosToViewportBias : packoffset(c001.z);
  uint2 PostProcessInput_0_ViewportMin : packoffset(c002.x);
  uint2 PostProcessInput_0_ViewportMax : packoffset(c002.z);
  float2 PostProcessInput_0_ViewportSize : packoffset(c003.x);
  float2 PostProcessInput_0_ViewportSizeInverse : packoffset(c003.z);
  float2 PostProcessInput_0_UVViewportMin : packoffset(c004.x);
  float2 PostProcessInput_0_UVViewportMax : packoffset(c004.z);
  float2 PostProcessInput_0_UVViewportSize : packoffset(c005.x);
  float2 PostProcessInput_0_UVViewportSizeInverse : packoffset(c005.z);
  float2 PostProcessInput_0_UVViewportBilinearMin : packoffset(c006.x);
  float2 PostProcessInput_0_UVViewportBilinearMax : packoffset(c006.z);
  float2 PostProcessInput_1_Extent : packoffset(c007.x);
  float2 PostProcessInput_1_ExtentInverse : packoffset(c007.z);
  float2 PostProcessInput_1_ScreenPosToViewportScale : packoffset(c008.x);
  float2 PostProcessInput_1_ScreenPosToViewportBias : packoffset(c008.z);
  uint2 PostProcessInput_1_ViewportMin : packoffset(c009.x);
  uint2 PostProcessInput_1_ViewportMax : packoffset(c009.z);
  float2 PostProcessInput_1_ViewportSize : packoffset(c010.x);
  float2 PostProcessInput_1_ViewportSizeInverse : packoffset(c010.z);
  float2 PostProcessInput_1_UVViewportMin : packoffset(c011.x);
  float2 PostProcessInput_1_UVViewportMax : packoffset(c011.z);
  float2 PostProcessInput_1_UVViewportSize : packoffset(c012.x);
  float2 PostProcessInput_1_UVViewportSizeInverse : packoffset(c012.z);
  float2 PostProcessInput_1_UVViewportBilinearMin : packoffset(c013.x);
  float2 PostProcessInput_1_UVViewportBilinearMax : packoffset(c013.z);
  float2 PostProcessInput_2_Extent : packoffset(c014.x);
  float2 PostProcessInput_2_ExtentInverse : packoffset(c014.z);
  float2 PostProcessInput_2_ScreenPosToViewportScale : packoffset(c015.x);
  float2 PostProcessInput_2_ScreenPosToViewportBias : packoffset(c015.z);
  uint2 PostProcessInput_2_ViewportMin : packoffset(c016.x);
  uint2 PostProcessInput_2_ViewportMax : packoffset(c016.z);
  float2 PostProcessInput_2_ViewportSize : packoffset(c017.x);
  float2 PostProcessInput_2_ViewportSizeInverse : packoffset(c017.z);
  float2 PostProcessInput_2_UVViewportMin : packoffset(c018.x);
  float2 PostProcessInput_2_UVViewportMax : packoffset(c018.z);
  float2 PostProcessInput_2_UVViewportSize : packoffset(c019.x);
  float2 PostProcessInput_2_UVViewportSizeInverse : packoffset(c019.z);
  float2 PostProcessInput_2_UVViewportBilinearMin : packoffset(c020.x);
  float2 PostProcessInput_2_UVViewportBilinearMax : packoffset(c020.z);
  float2 PostProcessInput_3_Extent : packoffset(c021.x);
  float2 PostProcessInput_3_ExtentInverse : packoffset(c021.z);
  float2 PostProcessInput_3_ScreenPosToViewportScale : packoffset(c022.x);
  float2 PostProcessInput_3_ScreenPosToViewportBias : packoffset(c022.z);
  uint2 PostProcessInput_3_ViewportMin : packoffset(c023.x);
  uint2 PostProcessInput_3_ViewportMax : packoffset(c023.z);
  float2 PostProcessInput_3_ViewportSize : packoffset(c024.x);
  float2 PostProcessInput_3_ViewportSizeInverse : packoffset(c024.z);
  float2 PostProcessInput_3_UVViewportMin : packoffset(c025.x);
  float2 PostProcessInput_3_UVViewportMax : packoffset(c025.z);
  float2 PostProcessInput_3_UVViewportSize : packoffset(c026.x);
  float2 PostProcessInput_3_UVViewportSizeInverse : packoffset(c026.z);
  float2 PostProcessInput_3_UVViewportBilinearMin : packoffset(c027.x);
  float2 PostProcessInput_3_UVViewportBilinearMax : packoffset(c027.z);
  float2 PostProcessInput_4_Extent : packoffset(c028.x);
  float2 PostProcessInput_4_ExtentInverse : packoffset(c028.z);
  float2 PostProcessInput_4_ScreenPosToViewportScale : packoffset(c029.x);
  float2 PostProcessInput_4_ScreenPosToViewportBias : packoffset(c029.z);
  uint2 PostProcessInput_4_ViewportMin : packoffset(c030.x);
  uint2 PostProcessInput_4_ViewportMax : packoffset(c030.z);
  float2 PostProcessInput_4_ViewportSize : packoffset(c031.x);
  float2 PostProcessInput_4_ViewportSizeInverse : packoffset(c031.z);
  float2 PostProcessInput_4_UVViewportMin : packoffset(c032.x);
  float2 PostProcessInput_4_UVViewportMax : packoffset(c032.z);
  float2 PostProcessInput_4_UVViewportSize : packoffset(c033.x);
  float2 PostProcessInput_4_UVViewportSizeInverse : packoffset(c033.z);
  float2 PostProcessInput_4_UVViewportBilinearMin : packoffset(c034.x);
  float2 PostProcessInput_4_UVViewportBilinearMax : packoffset(c034.z);
  float2 PostProcessInput_5_Extent : packoffset(c035.x);
  float2 PostProcessInput_5_ExtentInverse : packoffset(c035.z);
  float2 PostProcessInput_5_ScreenPosToViewportScale : packoffset(c036.x);
  float2 PostProcessInput_5_ScreenPosToViewportBias : packoffset(c036.z);
  uint2 PostProcessInput_5_ViewportMin : packoffset(c037.x);
  uint2 PostProcessInput_5_ViewportMax : packoffset(c037.z);
  float2 PostProcessInput_5_ViewportSize : packoffset(c038.x);
  float2 PostProcessInput_5_ViewportSizeInverse : packoffset(c038.z);
  float2 PostProcessInput_5_UVViewportMin : packoffset(c039.x);
  float2 PostProcessInput_5_UVViewportMax : packoffset(c039.z);
  float2 PostProcessInput_5_UVViewportSize : packoffset(c040.x);
  float2 PostProcessInput_5_UVViewportSizeInverse : packoffset(c040.z);
  float2 PostProcessInput_5_UVViewportBilinearMin : packoffset(c041.x);
  float2 PostProcessInput_5_UVViewportBilinearMax : packoffset(c041.z);
  float2 PostProcessInput_6_Extent : packoffset(c042.x);
  float2 PostProcessInput_6_ExtentInverse : packoffset(c042.z);
  float2 PostProcessInput_6_ScreenPosToViewportScale : packoffset(c043.x);
  float2 PostProcessInput_6_ScreenPosToViewportBias : packoffset(c043.z);
  uint2 PostProcessInput_6_ViewportMin : packoffset(c044.x);
  uint2 PostProcessInput_6_ViewportMax : packoffset(c044.z);
  float2 PostProcessInput_6_ViewportSize : packoffset(c045.x);
  float2 PostProcessInput_6_ViewportSizeInverse : packoffset(c045.z);
  float2 PostProcessInput_6_UVViewportMin : packoffset(c046.x);
  float2 PostProcessInput_6_UVViewportMax : packoffset(c046.z);
  float2 PostProcessInput_6_UVViewportSize : packoffset(c047.x);
  float2 PostProcessInput_6_UVViewportSizeInverse : packoffset(c047.z);
  float2 PostProcessInput_6_UVViewportBilinearMin : packoffset(c048.x);
  float2 PostProcessInput_6_UVViewportBilinearMax : packoffset(c048.z);
  float2 PostProcessInput_7_Extent : packoffset(c049.x);
  float2 PostProcessInput_7_ExtentInverse : packoffset(c049.z);
  float2 PostProcessInput_7_ScreenPosToViewportScale : packoffset(c050.x);
  float2 PostProcessInput_7_ScreenPosToViewportBias : packoffset(c050.z);
  uint2 PostProcessInput_7_ViewportMin : packoffset(c051.x);
  uint2 PostProcessInput_7_ViewportMax : packoffset(c051.z);
  float2 PostProcessInput_7_ViewportSize : packoffset(c052.x);
  float2 PostProcessInput_7_ViewportSizeInverse : packoffset(c052.z);
  float2 PostProcessInput_7_UVViewportMin : packoffset(c053.x);
  float2 PostProcessInput_7_UVViewportMax : packoffset(c053.z);
  float2 PostProcessInput_7_UVViewportSize : packoffset(c054.x);
  float2 PostProcessInput_7_UVViewportSizeInverse : packoffset(c054.z);
  float2 PostProcessInput_7_UVViewportBilinearMin : packoffset(c055.x);
  float2 PostProcessInput_7_UVViewportBilinearMax : packoffset(c055.z);
  float2 PostProcessInput_8_Extent : packoffset(c056.x);
  float2 PostProcessInput_8_ExtentInverse : packoffset(c056.z);
  float2 PostProcessInput_8_ScreenPosToViewportScale : packoffset(c057.x);
  float2 PostProcessInput_8_ScreenPosToViewportBias : packoffset(c057.z);
  uint2 PostProcessInput_8_ViewportMin : packoffset(c058.x);
  uint2 PostProcessInput_8_ViewportMax : packoffset(c058.z);
  float2 PostProcessInput_8_ViewportSize : packoffset(c059.x);
  float2 PostProcessInput_8_ViewportSizeInverse : packoffset(c059.z);
  float2 PostProcessInput_8_UVViewportMin : packoffset(c060.x);
  float2 PostProcessInput_8_UVViewportMax : packoffset(c060.z);
  float2 PostProcessInput_8_UVViewportSize : packoffset(c061.x);
  float2 PostProcessInput_8_UVViewportSizeInverse : packoffset(c061.z);
  float2 PostProcessInput_8_UVViewportBilinearMin : packoffset(c062.x);
  float2 PostProcessInput_8_UVViewportBilinearMax : packoffset(c062.z);
  float2 PostProcessInput_9_Extent : packoffset(c063.x);
  float2 PostProcessInput_9_ExtentInverse : packoffset(c063.z);
  float2 PostProcessInput_9_ScreenPosToViewportScale : packoffset(c064.x);
  float2 PostProcessInput_9_ScreenPosToViewportBias : packoffset(c064.z);
  uint2 PostProcessInput_9_ViewportMin : packoffset(c065.x);
  uint2 PostProcessInput_9_ViewportMax : packoffset(c065.z);
  float2 PostProcessInput_9_ViewportSize : packoffset(c066.x);
  float2 PostProcessInput_9_ViewportSizeInverse : packoffset(c066.z);
  float2 PostProcessInput_9_UVViewportMin : packoffset(c067.x);
  float2 PostProcessInput_9_UVViewportMax : packoffset(c067.z);
  float2 PostProcessInput_9_UVViewportSize : packoffset(c068.x);
  float2 PostProcessInput_9_UVViewportSizeInverse : packoffset(c068.z);
  float2 PostProcessInput_9_UVViewportBilinearMin : packoffset(c069.x);
  float2 PostProcessInput_9_UVViewportBilinearMax : packoffset(c069.z);
  float2 PostProcessOutput_Extent : packoffset(c070.x);
  float2 PostProcessOutput_ExtentInverse : packoffset(c070.z);
  float2 PostProcessOutput_ScreenPosToViewportScale : packoffset(c071.x);
  float2 PostProcessOutput_ScreenPosToViewportBias : packoffset(c071.z);
  uint2 PostProcessOutput_ViewportMin : packoffset(c072.x);
  uint2 PostProcessOutput_ViewportMax : packoffset(c072.z);
  float2 PostProcessOutput_ViewportSize : packoffset(c073.x);
  float2 PostProcessOutput_ViewportSizeInverse : packoffset(c073.z);
  float2 PostProcessOutput_UVViewportMin : packoffset(c074.x);
  float2 PostProcessOutput_UVViewportMax : packoffset(c074.z);
  float2 PostProcessOutput_UVViewportSize : packoffset(c075.x);
  float2 PostProcessOutput_UVViewportSizeInverse : packoffset(c075.z);
  float2 PostProcessOutput_UVViewportBilinearMin : packoffset(c076.x);
  float2 PostProcessOutput_UVViewportBilinearMax : packoffset(c076.z);
  float4 DepthOfFieldParams : packoffset(c077.x);
  uint bSceneLightingChannelsValid : packoffset(c078.x);
  uint bSceneDepthWithoutWaterTextureAvailable : packoffset(c078.y);
  float4 SceneWithoutSingleLayerWaterMinMaxUV : packoffset(c079.x);
  float2 SceneWithoutSingleLayerWaterTextureSize : packoffset(c080.x);
  float2 SceneWithoutSingleLayerWaterInvTextureSize : packoffset(c080.z);
};

cbuffer UniformBufferConstants_MaterialCollection0 : register(b1) {
  float4 MaterialCollection0_Vectors[26] : packoffset(c000.x);
};

cbuffer UniformBufferConstants_Material : register(b2) {
  float4 Material_PreshaderBuffer[3] : packoffset(c000.x);
  uint BindlessSampler_Material_Wrap_WorldGroupSettings : packoffset(c003.x);
  uint PrePadding_Material_52 : packoffset(c003.y);
  uint BindlessSampler_Material_Clamp_WorldGroupSettings : packoffset(c003.z);
};

SamplerState PostProcessInput_0_Sampler : register(s0);

float4 main(
    noperspective float4 SV_Position: SV_Position) : SV_Target {
  float4 SV_Target;
  float4 _35 = PostProcessInput_0_Texture.Sample(PostProcessInput_0_Sampler, float2(((((SV_Position.x - float((uint)(int)(PostProcessOutput_ViewportMin.x))) * PostProcessOutput_ViewportSizeInverse.x) * PostProcessInput_0_UVViewportSize.x) + PostProcessInput_0_UVViewportMin.x), ((((SV_Position.y - float((uint)(int)(PostProcessOutput_ViewportMin.y))) * PostProcessOutput_ViewportSizeInverse.y) * PostProcessInput_0_UVViewportSize.y) + PostProcessInput_0_UVViewportMin.y)));
  float3 tonemapped_pq = _35.rgb;

  // SV_Target = float4(_35.x, _35.y, _35.z, 0.0f);
  // return SV_Target;

  if (PROCESSING_PATH == 0.f) {
    _35 = ConvertPQToSRGBWithTonemap(_35);
  }
  float _46 = (((Material_PreshaderBuffer[1].x) - (Material_PreshaderBuffer[1].y)) * (MaterialCollection0_Vectors[7].w)) + (Material_PreshaderBuffer[1].y);
  float _47 = _46 * _35.x;
  float _48 = _46 * _35.y;
  float _49 = _46 * _35.z;
  // Removed max(0, )
  SV_Target.x = ((((Material_PreshaderBuffer[2].x) - _47) * (Material_PreshaderBuffer[1].z)) + _47);
  SV_Target.y = ((((Material_PreshaderBuffer[2].y) - _48) * (Material_PreshaderBuffer[1].z)) + _48);
  SV_Target.z = ((((Material_PreshaderBuffer[2].z) - _49) * (Material_PreshaderBuffer[1].z)) + _49);
  SV_Target.w = 0.0f;

  // Convert output from gamma back to -> PQ
  if (PROCESSING_PATH == 0.f) {
    SV_Target.rgb = ConvertSRGBtoPQAndUpgradeToneMap(SV_Target.rgb, tonemapped_pq);
  }
  return SV_Target;
}
