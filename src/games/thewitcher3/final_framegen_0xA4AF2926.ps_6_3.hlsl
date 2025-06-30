#include "./common.hlsl"
#include "./lilium_rcas.hlsl"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

cbuffer cb3 : register(b3) {
  float4 CustomPixelConsts_000 : packoffset(c000.x);
  float4 CustomPixelConsts_016 : packoffset(c001.x);
  float4 CustomPixelConsts_032 : packoffset(c002.x);
  float4 CustomPixelConsts_048 : packoffset(c003.x);
  float4 CustomPixelConsts_064 : packoffset(c004.x);
  float4 CustomPixelConsts_080 : packoffset(c005.x);
  float4 CustomPixelConsts_096 : packoffset(c006.x);
  float4 CustomPixelConsts_112 : packoffset(c007.x);
  float4 CustomPixelConsts_128 : packoffset(c008.x);
  float4 CustomPixelConsts_144 : packoffset(c009.x);
  float4 CustomPixelConsts_160 : packoffset(c010.x);
  float4 CustomPixelConsts_176 : packoffset(c011.x);
  float4 CustomPixelConsts_192 : packoffset(c012.x);
  float4 CustomPixelConsts_208 : packoffset(c013.x);
  float4 CustomPixelConsts_224 : packoffset(c014.x);
  float4 CustomPixelConsts_240 : packoffset(c015.x);
  float4 CustomPixelConsts_256 : packoffset(c016.x);
  float4 CustomPixelConsts_272 : packoffset(c017.x);
  float4 CustomPixelConsts_288 : packoffset(c018.x);
  float4 CustomPixelConsts_304 : packoffset(c019.x);
  float4 CustomPixelConsts_320 : packoffset(c020.x);
  float4 CustomPixelConsts_336[4] : packoffset(c021.x);
};

SamplerState s1 : register(s1);

struct OutputSignature {
  float4 SV_Target : SV_Target;
  float4 SV_Target_1 : SV_Target1;
  float4 SV_Target_2 : SV_Target2;
};

OutputSignature main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) {
  float4 SV_Target;
  float4 SV_Target_1;
  float4 SV_Target_2;
  int _15 = int(SV_Position.x - CustomPixelConsts_016.x);
  int _16 = int(SV_Position.y - CustomPixelConsts_016.y);
  float4 _24 = t1.Load(int3(_15, _16, 0));
  // if (!UTILITY_HUD) {
  //   _24 = 0;
  // }
  float4 _29 = t0.SampleLevel(s1, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);

  // float gamma = CustomPixelConsts_032.y * CustomPixelConsts_032.x;
  float gamma = 2.2f;

  float3 gammaGameColor = _29.rgb;
  float3 linearGameColor = renodx::color::gamma::DecodeSafe(gammaGameColor, gamma);
  linearGameColor.xyz = ApplyRCAS(linearGameColor.xyz, TEXCOORD, t0, s1);
  linearGameColor.xyz = CustomTonemap(linearGameColor.xyz);
  linearGameColor.xyz = renodx::effects::ApplyFilmGrain(
      linearGameColor.xyz,
      float2(TEXCOORD.x, TEXCOORD.y),
      CUSTOM_RANDOM,
      CUSTOM_FILM_GRAIN_STRENGTH * 0.03f);
  linearGameColor.rgb = renodx::draw::RenderIntermediatePass(linearGameColor.rgb);

  // float _50 = linearGameColor.x;
  // float _51 = linearGameColor.y;
  // float _52 = linearGameColor.z;
  // linearGameColor = renodx::draw::RenderIntermediatePass(linearGameColor);

  float3 gammaUiColor = _24.rgb;
  float3 linearUiColor = renodx::color::gamma::DecodeSafe(gammaUiColor, gamma);
  // float _41 = linearUiColor.x;
  // float _42 = linearUiColor.y;
  // float _43 = linearUiColor.z;

  float4 outputColor1;
  outputColor1.rgb = ((linearUiColor - linearGameColor) * _24.w) + linearGameColor;

  // outputColor.rgb = renodx::draw::SwapChainPass(outputColor.rgb);
  // outputColor.w = ((_24.w - _29.w) * _24.w) + _29.w;
  outputColor1.w = lerp(_29.w, _24.w, _24.w);
  outputColor1.w = renodx::math::SafePow(outputColor1.w, gamma);

  // SV_Target = outputColor;
  SV_Target_1.rgb = renodx::color::gamma::EncodeSafe(outputColor1.rgb, gamma);
  SV_Target_1.w = outputColor1.w;

  // float _34 = CustomPixelConsts_032.y * CustomPixelConsts_032.x; // gamma slider
  // float _34 = 2.200000047683716f; //disables gamma slider
  // float _34 = 0.4545454680919647f;

  // UI gamma to linear
  // float _35 = log2(_24.x);
  // float _36 = log2(_24.y);
  // float _37 = log2(_24.z);
  // float _38 = _35 * _34;
  // float _39 = _36 * _34;
  // float _40 = _37 * _34;
  // float _41 = exp2(_38);
  // float _42 = exp2(_39);
  // float _43 = exp2(_40);

  // Game gamma to linear
  // float _44 = log2(_29.x);
  // float _45 = log2(_29.y);
  // float _46 = log2(_29.z);
  // float _47 = _44 * _34;
  // float _48 = _45 * _34;
  // float _49 = _46 * _34;
  // float _50 = exp2(_47);
  // float _51 = exp2(_48);
  // float _52 = exp2(_49);

  // // blend gameColor and uiColor (40s ui, 50s game)
  // float _53 = _41 - _50;
  // float _54 = _42 - _51;
  // float _55 = _43 - _52;
  // float _56 = _24.w - _29.w;
  // float _57 = _53 * _24.w;
  // float _58 = _54 * _24.w;
  // float _59 = _55 * _24.w;
  // float _60 = _56 * _24.w;
  // float _61 = _57 + _50;
  // float _62 = _58 + _51;
  // float _63 = _59 + _52;
  // float _64 = _60 + _29.w;

  // convert to gamma
  // float _65 = log2(_61);
  // float _66 = log2(_62);
  // float _67 = log2(_63);
  // float _68 = log2(_64);
  // float _69 = _65 * CustomPixelConsts_032.z;
  // float _70 = _66 * CustomPixelConsts_032.z;
  // float _71 = _67 * CustomPixelConsts_032.z;
  // float _72 = _68 * CustomPixelConsts_032.z;
  // float _73 = exp2(_69);
  // float _74 = exp2(_70);
  // float _75 = exp2(_71);
  // float _76 = exp2(_72);

  bool _78 = ((CustomPixelConsts_016.z) > 0.5f);
  float _84 = float(_15);
  float _85 = float(_16);
  bool _86 = (_84 >= CustomPixelConsts_048.x);
  bool _87 = (_85 >= CustomPixelConsts_048.y);
  float _88 = CustomPixelConsts_048.z + CustomPixelConsts_048.x;
  float _89 = CustomPixelConsts_048.w + CustomPixelConsts_048.y;
  bool _90 = (_84 < _88);
  bool _91 = (_85 < _89);
  bool _92 = _86 && _90;
  bool _93 = _87 && _91;
  bool _94 = _92 && _93;
  bool _95 = _78 && _94;
  float _140;
  float _141;
  float _142;
  float _143;

  float4 outputColor;
  float4 intermediateColor;
  if (_95) {
    float _97 = _84 - CustomPixelConsts_048.x;
    float _98 = _85 - CustomPixelConsts_048.y;
    float _99 = _97 / CustomPixelConsts_048.z;
    float _100 = _98 / CustomPixelConsts_048.w;
    float4 _101 = t2.SampleLevel(s1, float2(_99, _100), 0.0f);

    // float _105 = CustomPixelConsts_032.x * 2.200000047683716f;
    float _105 = gamma;

    float _106 = log2(_101.x);
    float _107 = log2(_101.y);
    float _108 = log2(_101.z);
    float _109 = _106 * _105;
    float _110 = _107 * _105;
    float _111 = _108 * _105;
    float _112 = exp2(_109);
    float _113 = exp2(_110);
    float _114 = exp2(_111);
    // float3 gammaColor1 = renodx::color::gamma::DecodeSafe(_101.rgb);
    // float _112 = gammaColor1.x;
    // float _113 = gammaColor1.y;
    // float _114 = gammaColor1.z;

    _140 = _112;
    _141 = _113;
    _142 = _114;
    _143 = 1.0f;

    outputColor = float4(_140, _141, _142, _143);
  } else {
    intermediateColor.w = saturate(_24.w * 2.0f);
    intermediateColor.xyz = linearGameColor.xyz;

    intermediateColor.xyz *= -0.6699999570846558f;
    intermediateColor.xyz *= intermediateColor.w;
    intermediateColor.xyz += linearGameColor;

    // intermediateColor.xyz = CustomTonemap(intermediateColor.xyz);
    // intermediateColor.xyz = renodx::effects::ApplyFilmGrain(
    //     intermediateColor.xyz,
    //     float2(TEXCOORD.x, TEXCOORD.y),
    //     CUSTOM_RANDOM,
    //     CUSTOM_FILM_GRAIN_STRENGTH * 0.03f);
    // intermediateColor.rgb = renodx::draw::RenderIntermediatePass(intermediateColor.rgb);

    //blend game + ui

    outputColor.xyz = linearUiColor - intermediateColor.xyz;
    outputColor.w = _24.w + -1.0f;
    outputColor *= _24.w;
    outputColor.xyz += intermediateColor.xyz;
    outputColor.w += 1.0f;

    // float _116 = _24.w * 2.0f;
    // float _117 = saturate(_116);
    //  float _118 = _50 * -0.6699999570846558f;
    //  float _119 = _51 * -0.6699999570846558f;
    //  float _120 = _52 * -0.6699999570846558f;
    //  float _121 = _118 * _117;
    //  float _122 = _119 * _117;
    //  float _123 = _120 * _117;
    //  float _124 = _121 + _50;
    //  float _125 = _122 + _51;
    //  float _126 = _123 + _52;
    //  float _127 = _41 - _124;
    //  float _128 = _42 - _125;
    //  float _129 = _43 - _126;
    //  float _130 = _24.w + -1.0f;
    //  float _131 = _127 * _24.w;
    //  float _132 = _128 * _24.w;
    //  float _133 = _129 * _24.w;
    //  float _134 = _130 * _24.w;
    //  float _135 = _131 + _124;
    //  float _136 = _132 + _125;
    //  float _137 = _133 + _126;
    //  float _138 = _134 + 1.0f;
    //  _140 = _135;
    //  _141 = _136;
    //  _142 = _137;
    //  _143 = _138;
  }

  // outputColor = float4(_140, _141, _142, _143);
  //  outputColor.rgb = renodx::color::gamma::EncodeSafe(outputColor.rgb);
  // outputColor.rgb = renodx::draw::SwapChainPass(outputColor.rgb);
  // outputColor.rgb = CustomColorTemp(outputColor.rgb);

  outputColor.rgb = renodx::draw::SwapChainPass(outputColor.rgb);
  SV_Target = outputColor;

  float3 framegenColor = linearGameColor.rgb;
  framegenColor = renodx::draw::SwapChainPass(framegenColor);
  SV_Target_2.rgb = framegenColor;
  SV_Target_2.w = 1.0f;

  // //BT2020
  // float _153 = mad(0.04331360012292862f, _142, mad(0.3292819857597351f, _141, (_140 * 0.627403974533081f))) * CustomPixelConsts_000.x;
  // float _154 = mad(0.011361200362443924f, _142, mad(0.9195399880409241f, _141, (_140 * 0.06909699738025665f))) * CustomPixelConsts_000.x;
  // float _155 = mad(0.8955950140953064f, _142, mad(0.08801320195198059f, _141, (_140 * 0.01639159955084324f))) * CustomPixelConsts_000.x;
  // float _156 = CustomPixelConsts_000.w * 0.8999999761581421f;
  // float _157 = CustomPixelConsts_000.w * 0.10000002384185791f;
  // float _158 = 9.999998092651367f / CustomPixelConsts_000.w;
  // float _166 = _158 * -1.4426950216293335f;
  // float _192 = exp2(log2(select((_153 < _156), _153, (CustomPixelConsts_000.w - (exp2(((_153 - _156) * -1.4426950216293335f) * _158) * _157))) * 9.999999747378752e-05f) * 0.1593017578125f);
  // float _193 = exp2(log2(select((_154 < _156), _154, (CustomPixelConsts_000.w - (exp2(((_154 - _156) * -1.4426950216293335f) * _158) * _157))) * 9.999999747378752e-05f) * 0.1593017578125f);
  // float _194 = exp2(log2(select((_155 < _156), _155, (CustomPixelConsts_000.w - (exp2(_166 * (_155 - _156)) * _157))) * 9.999999747378752e-05f) * 0.1593017578125f);


  // // PQ Encode
  // SV_Target.x = saturate(exp2(log2(((_192 * 18.8515625f) + 0.8359375f) / ((_192 * 18.6875f) + 1.0f)) * 78.84375f));
  // SV_Target.y = saturate(exp2(log2(((_193 * 18.8515625f) + 0.8359375f) / ((_193 * 18.6875f) + 1.0f)) * 78.84375f));
  // SV_Target.z = saturate(exp2(log2(((_194 * 18.8515625f) + 0.8359375f) / ((_194 * 18.6875f) + 1.0f)) * 78.84375f));
  // SV_Target.w = _143;

  // //Gamma encode
  // SV_Target_1.x = exp2(log2(lerp(_50, _41, _24.w)) * CustomPixelConsts_032.z);
  // SV_Target_1.y = exp2(log2(lerp(_51, _42, _24.w)) * CustomPixelConsts_032.z);
  // SV_Target_1.z = exp2(log2(lerp(_52, _43, _24.w)) * CustomPixelConsts_032.z);
  // SV_Target_1.w = exp2(log2(lerp(_29.w, _24.w, _24.w)) * CustomPixelConsts_032.z);

  // //BT2020
  // float _231 = mad(0.04331360012292862f, _52, mad(0.3292819857597351f, _51, (_50 * 0.627403974533081f))) * CustomPixelConsts_000.x;
  // float _232 = mad(0.011361200362443924f, _52, mad(0.9195399880409241f, _51, (_50 * 0.06909699738025665f))) * CustomPixelConsts_000.x;
  // float _233 = mad(0.8955950140953064f, _52, mad(0.08801320195198059f, _51, (_50 * 0.01639159955084324f))) * CustomPixelConsts_000.x;
  // float _266 = exp2(log2(select((_231 < _156), _231, (CustomPixelConsts_000.w - (exp2(((_231 - _156) * -1.4426950216293335f) * _158) * _157))) * 9.999999747378752e-05f) * 0.1593017578125f);
  // float _267 = exp2(log2(select((_232 < _156), _232, (CustomPixelConsts_000.w - (exp2(((_232 - _156) * -1.4426950216293335f) * _158) * _157))) * 9.999999747378752e-05f) * 0.1593017578125f);
  // float _268 = exp2(log2(select((_233 < _156), _233, (CustomPixelConsts_000.w - (exp2(_166 * (_233 - _156)) * _157))) * 9.999999747378752e-05f) * 0.1593017578125f);

  // // PQ Encode
  // SV_Target_2.x = saturate(exp2(log2(((_266 * 18.8515625f) + 0.8359375f) / ((_266 * 18.6875f) + 1.0f)) * 78.84375f));
  // SV_Target_2.y = saturate(exp2(log2(((_267 * 18.8515625f) + 0.8359375f) / ((_267 * 18.6875f) + 1.0f)) * 78.84375f));
  // SV_Target_2.z = saturate(exp2(log2(((_268 * 18.8515625f) + 0.8359375f) / ((_268 * 18.6875f) + 1.0f)) * 78.84375f));
  // SV_Target_2.w = 1.0f;
  OutputSignature output_signature = { SV_Target, SV_Target_1, SV_Target_2 };
  return output_signature;
}
