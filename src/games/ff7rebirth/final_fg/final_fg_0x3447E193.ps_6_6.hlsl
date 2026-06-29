#define USE_DEFAULT
#define USE_FG

#include "../hdrcomposite.hlsl"

OutputSignature main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 TEXCOORD_1: TEXCOORD1,
    noperspective float4 SV_Position: SV_Position)
    {
  return HDRComposite(TEXCOORD, TEXCOORD_1, SV_Position);
}