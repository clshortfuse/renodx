#include "./color_grade.hlsli"

sampler2D SSPoint__tBaseMap : register(s0);
sampler2D SSPoint__tColorCorrectTableMap : register(s1);
row_major float4x4 fColorCorrectMatrix : register(c1);
float4 fColorCorrectColor : register(c5);

float4 main(float2 texcoord : TEXCOORD0) : COLOR0 {
  float4 base = tex2D(SSPoint__tBaseMap, texcoord);
  bool hdr = UseSceneHDR();
  float3 color = DecodeGameSRGB(hdr ? base.rgb : saturate(base.rgb));
  float3 graded = ApplyGameColorGrade(color, fColorCorrectMatrix, SSPoint__tColorCorrectTableMap, fColorCorrectColor.w, hdr);
  float4 output = float4(EncodeGameSRGB(graded), base.a);
  return hdr ? max(output, 0.f) : saturate(output);
}
