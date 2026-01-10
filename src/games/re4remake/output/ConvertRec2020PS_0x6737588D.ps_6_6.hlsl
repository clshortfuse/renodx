#include "../common.hlsli"

Texture2D<float4> tLinearImage : register(t0);

cbuffer HDRMapping : register(b0) {
  float whitePaperNits : packoffset(c000.x);
  float displayMaxNits : packoffset(c000.z);
  float HDRMapping_000w : packoffset(c000.w);
  uint HDRMapping_004x : packoffset(c004.x);
  float HDRMapping_004y : packoffset(c004.y);  // gammaForHDR
  float HDRMapping_005x : packoffset(c005.x);  // float saturationForHDR
};

SamplerState PointBorder : register(s2, space32);

float4 main(noperspective float4 SV_Position: SV_Position,
            linear float2 TEXCOORD: TEXCOORD)
    : SV_Target {
  if (TONE_MAP_TYPE != 0) {
    float3 bt709Color = tLinearImage.SampleLevel(PointBorder, TEXCOORD.xy, 0.0f).rgb;

    bt709Color = ApplyGammaCorrection(bt709Color);

    float3 bt2020Color = renodx::color::bt2020::from::BT709(bt709Color.rgb);

#if 0
    bt2020Color = ApplyDisplayMap(bt2020Color, whitePaperNits, displayMaxNits);
#endif

    float3 pqColor = renodx::color::pq::Encode(bt2020Color, RENODX_GRAPHICS_WHITE_NITS);

    return float4(pqColor, 1.0);
  } else {
    float4 SV_Target;

    float _5 = TEXCOORD.x;
    float _6 = TEXCOORD.y;

    float4 _9 = tLinearImage.SampleLevel(PointBorder, TEXCOORD.xy, 0.0f);
    float _10 = _9.x;
    float _11 = _9.y;
    float _12 = _9.z;
    float _13 = _10 * 0.627403974533081f;
    float _14 = mad(0.3292819857597351f, _11, _13);
    float _15 = mad(0.04331360012292862f, _12, _14);
    float _16 = _10 * 0.06909699738025665f;
    float _17 = mad(0.9195399880409241f, _11, _16);
    float _18 = mad(0.011361200362443924f, _12, _17);
    float _19 = _10 * 0.01639159955084324f;
    float _20 = mad(0.08801320195198059f, _11, _19);
    float _21 = mad(0.8955950140953064f, _12, _20);
    float _23 = HDRMapping_005x;
    float _24 = _10 - _15;
    float _25 = _11 - _18;
    float _26 = _12 - _21;
    float _27 = _23 * _24;
    float _28 = _23 * _25;
    float _29 = _23 * _26;
    float _30 = _27 + _15;
    float _31 = _28 + _18;
    float _32 = _29 + _21;
    float _34 = HDRMapping_004y;
    float _35 = log2(_30);
    float _36 = log2(_31);
    float _37 = log2(_32);
    float _38 = _35 * _34;
    float _39 = _36 * _34;
    float _40 = _37 * _34;
    float _41 = exp2(_38);
    float _42 = exp2(_39);
    float _43 = exp2(_40);
    float _45 = whitePaperNits;
    float _46 = 10000.0f / _45;
    float _47 = _41 / _46;
    float _48 = _42 / _46;
    float _49 = _43 / _46;
    float _50 = saturate(_47);
    float _51 = saturate(_48);
    float _52 = saturate(_49);
    float _53 = log2(_50);
    float _54 = log2(_51);
    float _55 = log2(_52);
    float _56 = _53 * 0.1593017578125f;
    float _57 = _54 * 0.1593017578125f;
    float _58 = _55 * 0.1593017578125f;
    float _59 = exp2(_56);
    float _60 = exp2(_57);
    float _61 = exp2(_58);
    float _62 = _59 * 18.8515625f;
    float _63 = _60 * 18.8515625f;
    float _64 = _61 * 18.8515625f;
    float _65 = _62 + 0.8359375f;
    float _66 = _63 + 0.8359375f;
    float _67 = _64 + 0.8359375f;
    float _68 = _59 * 18.6875f;
    float _69 = _60 * 18.6875f;
    float _70 = _61 * 18.6875f;
    float _71 = _68 + 1.0f;
    float _72 = _69 + 1.0f;
    float _73 = _70 + 1.0f;
    float _74 = _65 / _71;
    float _75 = _66 / _72;
    float _76 = _67 / _73;
    float _77 = log2(_74);
    float _78 = log2(_75);
    float _79 = log2(_76);
    float _80 = _77 * 78.84375f;
    float _81 = _78 * 78.84375f;
    float _82 = _79 * 78.84375f;
    float _83 = exp2(_80);
    float _84 = exp2(_81);
    float _85 = exp2(_82);
    float _86 = saturate(_83);
    float _87 = saturate(_84);
    float _88 = saturate(_85);
    uint _90 = HDRMapping_004x;
    int _91 = _90 & 2;
    bool _92 = (_91 == 0);
    float _153 = _86;
    float _154 = _87;
    float _155 = _88;
    if (!_92) {
      float _94 = displayMaxNits;
      float _95 = _94 * 9.999999747378752e-05f;
      float _96 = saturate(_95);
      float _97 = log2(_96);
      float _98 = _97 * 0.1593017578125f;
      float _99 = exp2(_98);
      float _100 = _99 * 18.8515625f;
      float _101 = _100 + 0.8359375f;
      float _102 = _99 * 18.6875f;
      float _103 = _102 + 1.0f;
      float _104 = _101 / _103;
      float _105 = log2(_104);
      float _106 = _105 * 78.84375f;
      float _107 = exp2(_106);
      float _108 = saturate(_107);
      float _109 = HDRMapping_000w;
      float _110 = _109 * 9.999999747378752e-05f;
      float _111 = saturate(_110);
      float _112 = log2(_111);
      float _113 = _112 * 0.1593017578125f;
      float _114 = exp2(_113);
      float _115 = _114 * 18.8515625f;
      float _116 = _115 + 0.8359375f;
      float _117 = _114 * 18.6875f;
      float _118 = _117 + 1.0f;
      float _119 = _116 / _118;
      float _120 = log2(_119);
      float _121 = _120 * 78.84375f;
      float _122 = exp2(_121);
      float _123 = saturate(_122);
      float _124 = _108 - _123;
      float _125 = _86 / _108;
      float _126 = _87 / _108;
      float _127 = _88 / _108;
      float _128 = saturate(_125);
      float _129 = saturate(_126);
      float _130 = saturate(_127);
      float _131 = _128 * _108;
      float _132 = _129 * _108;
      float _133 = _130 * _108;
      float _134 = _128 + _128;
      float _135 = 2.0f - _134;
      float _136 = _135 * _124;
      float _137 = _136 + _131;
      float _138 = _137 * _128;
      float _139 = _129 + _129;
      float _140 = 2.0f - _139;
      float _141 = _140 * _124;
      float _142 = _141 + _132;
      float _143 = _142 * _129;
      float _144 = _130 + _130;
      float _145 = 2.0f - _144;
      float _146 = _145 * _124;
      float _147 = _146 + _133;
      float _148 = _147 * _130;
      float _149 = min(_138, _86);
      float _150 = min(_143, _87);
      float _151 = min(_148, _88);
      _153 = _149;
      _154 = _150;
      _155 = _151;
    }
    SV_Target.x = _153;
    SV_Target.y = _154;
    SV_Target.z = _155;
    SV_Target.w = 1.0f;
    return SV_Target;
  }
}
