#include "./common.hlsl"

Texture2D<float4> ElementTexture : register(t0);

/* float4 WeightAndOffsets[63];
int SampleCount;
float4 BufferSizeAndDirection;
float4 UVBounds; */
cbuffer $Globals : register(b0) {
  float $Globals_000x : packoffset(c000.x);
  float $Globals_000y : packoffset(c000.y);
  float $Globals_000z : packoffset(c000.z);
  float $Globals_000w : packoffset(c000.w);
  float $Globals_001x : packoffset(c001.x);
  float $Globals_001y : packoffset(c001.y);
  float $Globals_001z : packoffset(c001.z);
  float $Globals_001w : packoffset(c001.w);
};

SamplerState ElementTextureSampler : register(s0);

struct OutputSignature {
  float4 SV_Target : SV_Target;
  float4 SV_Target_1 : SV_Target1;
};

// Cuts black and PQ encodes at the end
OutputSignature main(
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float4 SV_Position : SV_Position
) {
  float4 SV_Target;
  float4 SV_Target_1;
  float4 _17 = ElementTexture.Sample(ElementTextureSampler, float2((TEXCOORD.x), (TEXCOORD.y)));
  // _17.rgb = DecodeFromPQ(_17.rgb);
  float _24 = (TEXCOORD.x) / ($Globals_000z);
  float _25 = (TEXCOORD.y) / ($Globals_000w);
  float _26 = ($Globals_000x) * 0.5f;
  float _27 = ($Globals_000y) * 0.5f;
  float _30 = (((bool)((_24 > 0.5f))) ? 0.0f : 1.0f);
  float _37 = (_30 * (($Globals_001w) - ($Globals_001z))) + ($Globals_001z);
  float _40 = ((((_30 * (($Globals_001x) - ($Globals_001y))) + ($Globals_001y)) - _37) * ((((bool)((_25 > 0.5f))) ? 0.0f : 1.0f))) + _37;
  float _45 = abs(((_24 + -0.5f) * ($Globals_000x)));
  float _46 = abs(((_25 + -0.5f) * ($Globals_000y)));
  float _49 = _45 - (_26 - _40);
  float _50 = _46 - (_27 - _40);
  float _62 = (sqrt(((_49 * _49) + (_50 * _50)))) - _40;
  float _65 = max(_40, 0.0f);
  float _68 = _45 - (_26 - _65);
  float _69 = _46 - (_27 - _65);
  float _81 = (sqrt(((_69 * _69) + (_68 * _68)))) - _65;
  float _88 = saturate((((_62 + -1.0f) + ((float((uint)((bool)(((bool)((_49 <= 0.0f))) || ((bool)((_50 <= 0.0f))))))) * ((max((_49 - _40), (_50 - _40))) - _62))) * -0.5f));
  float _93 = saturate((-0.0f - ((_81 + ((float((uint)((bool)(((bool)((_68 <= 0.0f))) || ((bool)((_69 <= 0.0f))))))) * ((max((_68 - _65), (_69 - _65))) - _81))) + -0.5f)));
  float _100 = ((_88 * _88) * (_17.w)) * (3.0f - (_88 * 2.0f));
  float _113 = exp2(((log2(((_17.x) * 0.00800000037997961f))) * 0.1593017578125f));
  float _114 = exp2(((log2(((_17.y) * 0.00800000037997961f))) * 0.1593017578125f));
  float _115 = exp2(((log2(((_17.z) * 0.00800000037997961f))) * 0.1593017578125f));
  float3 final_color = float3(_113, _114, _115);
  SV_Target_1.x = 0.0f;
  SV_Target_1.y = 0.0f;
  SV_Target_1.z = 0.0f;
  SV_Target_1.w = 0.0f;
  SV_Target.x = (exp2(((log2(((1.0f / ((_113 * 18.6875f) + 1.0f)) * ((_113 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
  SV_Target.y = (exp2(((log2(((1.0f / ((_114 * 18.6875f) + 1.0f)) * ((_114 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
  SV_Target.z = (exp2(((log2(((1.0f / ((_115 * 18.6875f) + 1.0f)) * ((_115 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
  SV_Target.w = ((((_93 * _93) * (3.0f - (_93 * 2.0f))) * ((_17.w) - _100)) + _100);

  // SV_Target.rgb = EncodeToPQ(final_color);
  SV_Target.rgb = _17.rgb;

  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}
