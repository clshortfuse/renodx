#include "../shared.h"
cbuffer MiscGroupPS : register(b3) {
  float4 fs_fog_color : packoffset(c000.x);
  float4 fs_lightingAdjust : packoffset(c001.x);
  float4 fs_envRotation0 : packoffset(c002.x);
  float4 fs_envRotation1 : packoffset(c003.x);
  float4 fs_envRotation2 : packoffset(c004.x);
  float4 fs_exposure : packoffset(c005.x);
  float4 fs_screenSize : packoffset(c006.x);
  float4 fs_time : packoffset(c007.x);
  float4 fs_misc_flags : packoffset(c008.x);
  float4 fs_fog_color2 : packoffset(c009.x);
};

float4 main(
  noperspective float4 SV_Position : SV_Position,
  float4 COLOR : COLOR
) : SV_Target {
  float4 SV_Target;
  SV_Target.x = ((COLOR.x * 2.0f) * fs_exposure.y);
  SV_Target.y = ((COLOR.y * 2.0f) * fs_exposure.y);
  SV_Target.z = ((COLOR.z * 2.0f) * fs_exposure.y);
  SV_Target.w = COLOR.w;
  if (COLOR.w >= 1.001f) SV_Target.w *= CUSTOM_VIGNETTE;
  return SV_Target;
}
