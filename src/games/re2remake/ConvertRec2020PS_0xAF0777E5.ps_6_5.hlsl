// cbuffer HDRMapping
// {

//   struct HDRMapping
//   {

//       float whitePaperNits;                         ; Offset:    0
//       float configImageAlphaScale;                  ; Offset:    4
//       float displayMaxNits;                         ; Offset:    8
//       float displayMinNits;                         ; Offset:   12
//       float4 displayMaxNitsRect;                    ; Offset:   16
//       float4 standardMaxNitsRect;                   ; Offset:   32
//       float4 mdrOutRangeRect;                       ; Offset:   48
//       uint drawMode;                                ; Offset:   64
//       float gammaForHDR;                            ; Offset:   68
//       float2 configDrawRectSize;                    ; Offset:   72

//   } HDRMapping;                                     ; Offset:    0 Size:    80

// }

#include "./shared.h"
Texture2D<float4> tLinearImage : register(t0);

cbuffer HDRMapping : register(b0) {
  float HDRMapping_000x : packoffset(c000.x);
  float HDRMapping_000z : packoffset(c000.z);
  float HDRMapping_000w : packoffset(c000.w);
  uint HDRMapping_004x : packoffset(c004.x);
  float HDRMapping_004y : packoffset(c004.y);
};

SamplerState PointBorder : register(s2, space32);

float4 main(noperspective float4 SV_Position: SV_Position,
            linear float2 TEXCOORD: TEXCOORD)
    : SV_Target {
  float4 bt709Color = tLinearImage.SampleLevel(PointBorder, TEXCOORD.xy, 0.0f);

#if 0  // Gamma Correction
  bt709Color.rgb = renodx::color::correct::GammaSafe(bt709Color.rgb);
#endif

  float3 bt2020Color =
      renodx::color::bt2020::from::BT709(bt709Color.rgb);

  float3 pqColor = renodx::color::pq::Encode(bt2020Color, HDRMapping_000x);

  return float4(pqColor, 1.0);
}
