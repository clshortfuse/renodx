#include "./ui.hlsli"

float4 main(float4 position : SV_POSITION, float4 color : COLOR0,
            float4 add : COLOR1, float4 uv : TEXCOORD0) : SV_TARGET {
  return ApplyUIBrightness(color + add);
}
