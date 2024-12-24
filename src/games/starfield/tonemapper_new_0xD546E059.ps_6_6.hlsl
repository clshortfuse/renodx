#define USE_BLOOM
#define USE_TONEMAP

#include "./hdrcomposite.hlsl"

float4 main(float4 gl_FragCoord : SV_Position, float2 TEXCOORD : TEXCOORD0) : SV_Target {
  return HDRComposite(gl_FragCoord, TEXCOORD);
}
