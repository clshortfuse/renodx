#include "./lilium_rcas.hlsl"
#include "./uncharted2.hlsl"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

// cbuffer cb0 : register(b3) {
//   float4 CustomPixelConsts_000 : packoffset(c000.x);
//   float4 CustomPixelConsts_016 : packoffset(c001.x);
//   float4 CustomPixelConsts_032 : packoffset(c002.x);
//   float4 CustomPixelConsts_048 : packoffset(c003.x);
//   float4 CustomPixelConsts_064 : packoffset(c004.x);
//   float4 CustomPixelConsts_080 : packoffset(c005.x);
//   float4 CustomPixelConsts_096 : packoffset(c006.x);
//   float4 CustomPixelConsts_112 : packoffset(c007.x);
//   float4 CustomPixelConsts_128 : packoffset(c008.x);
//   float4 CustomPixelConsts_144 : packoffset(c009.x);
//   float4 CustomPixelConsts_160 : packoffset(c010.x);
//   float4 CustomPixelConsts_176 : packoffset(c011.x);
//   float4 CustomPixelConsts_192 : packoffset(c012.x);
//   float4 CustomPixelConsts_208 : packoffset(c013.x);
//   float4 CustomPixelConsts_224 : packoffset(c014.x);
//   float4 CustomPixelConsts_240 : packoffset(c015.x);
//   float4 CustomPixelConsts_256 : packoffset(c016.x);
//   float4 CustomPixelConsts_272 : packoffset(c017.x);
//   float4 CustomPixelConsts_288 : packoffset(c018.x);
//   float4 CustomPixelConsts_304 : packoffset(c019.x);
//   float4 CustomPixelConsts_320 : packoffset(c020.x);
//   float4 CustomPixelConsts_336[4] : packoffset(c021.x);
// };

SamplerState s0 : register(s1);

struct OutputSignature {
  float4 SV_Target : SV_Target;
  float4 SV_Target_1 : SV_Target1;
};

OutputSignature main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) {
  float4 SV_Target;
  float4 SV_Target_1;
  float _13 = SV_Position.x - (CustomPixelConsts_016.x);
  float _14 = SV_Position.y - (CustomPixelConsts_016.y);
  int _15 = int(_13);
  int _16 = int(_14);
  float4 _24 = t1.Load(int3(_15, _16, 0));
  // if (!UTILITY_HUD) {
  //   _24 = 0;
  // }
  float4 _29 = t0.SampleLevel(s0, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);

  // float gamma = CustomPixelConsts_032.y * CustomPixelConsts_032.x;
  float gamma = 2.2f;

  float3 gammaGameColor = _29.rgb;
  float3 linearGameColor = renodx::color::gamma::DecodeSafe(gammaGameColor, gamma);

  linearGameColor.xyz = ApplyRCAS(linearGameColor.xyz, TEXCOORD, t0, s0);
  //linearGameColor.xyz = CustomTonemap(linearGameColor.xyz);
  linearGameColor.xyz = renodx::effects::ApplyFilmGrain(
      linearGameColor.xyz,
      float2(TEXCOORD.x, TEXCOORD.y),
      CUSTOM_RANDOM,
      CUSTOM_FILM_GRAIN_STRENGTH * 0.03f);
  //linearGameColor.xyz = CustomGammaCorrection(linearGameColor.xyz);
  linearGameColor.rgb = renodx::draw::RenderIntermediatePass(linearGameColor.rgb);

  // float _50 = linearGameColor.x;
  // float _51 = linearGameColor.y;
  // float _52 = linearGameColor.z;
  //linearGameColor = renodx::draw::RenderIntermediatePass(linearGameColor);

  float3 gammaUiColor = _24.rgb;
  float3 linearUiColor = renodx::color::gamma::DecodeSafe(gammaUiColor, gamma);
  // float _41 = linearUiColor.x;
  // float _42 = linearUiColor.y;
  // float _43 = linearUiColor.z;
  //linearUiColor *= (RENODX_GRAPHICS_WHITE_NITS / renodx::color::srgb::REFERENCE_WHITE);
  //linearGameColor *= (RENODX_DIFFUSE_WHITE_NITS / renodx::color::srgb::REFERENCE_WHITE);

  float4 outputColor1;
  outputColor1.rgb = ((linearUiColor - linearGameColor) * _24.w) + linearGameColor;

  // outputColor.rgb = renodx::draw::SwapChainPass(outputColor.rgb);
  // outputColor.w = ((_24.w - _29.w) * _24.w) + _29.w;
  outputColor1.w = lerp(_29.w, _24.w, _24.w);
  outputColor1.w = renodx::math::SafePow(outputColor1.w, 1.f / gamma);

  //SV_Target = outputColor;
  SV_Target_1.rgb = renodx::color::gamma::EncodeSafe(outputColor1.rgb, gamma);
  SV_Target_1.w = outputColor1.w;

  // float _34 = CustomPixelConsts_032.y * CustomPixelConsts_032.x; // gamma slider
  // float _34 = 2.200000047683716f; //disables gamma slider
  //float _34 = 0.4545454680919647f;

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
  //float _68 = log2(_64);
  // float _69 = _65 * CustomPixelConsts_032.z;
  // float _70 = _66 * CustomPixelConsts_032.z;
  // float _71 = _67 * CustomPixelConsts_032.z;
  //float _72 = _68 * CustomPixelConsts_032.z;
  // float _73 = exp2(_69);
  // float _74 = exp2(_70);
  // float _75 = exp2(_71);
  //float _76 = exp2(_72);

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
  if (_95) {
    float _97 = _84 - CustomPixelConsts_048.x;
    float _98 = _85 - CustomPixelConsts_048.y;
    float _99 = _97 / CustomPixelConsts_048.z;
    float _100 = _98 / CustomPixelConsts_048.w;
    float4 _101 = t2.SampleLevel(s0, float2(_99, _100), 0.0f);

    //float _105 = CustomPixelConsts_032.x * 2.200000047683716f;
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
    // float4 intermediateColor;
    // intermediateColor.w = saturate(_24.w * 2.0f);
    // intermediateColor.xyz = linearGameColor.xyz;
  
    // intermediateColor.xyz = CustomTonemap(intermediateColor.xyz);
    // intermediateColor.xyz = renodx::effects::ApplyFilmGrain(
    //     intermediateColor.xyz,
    //     float2(TEXCOORD.x, TEXCOORD.y),
    //     CUSTOM_RANDOM,
    //     CUSTOM_FILM_GRAIN_STRENGTH * 0.03f);
    // intermediateColor.rgb = renodx::draw::RenderIntermediatePass(intermediateColor.rgb);

    //blend game + ui
    // intermediateColor.xyz *= -0.6699999570846558f;
    // intermediateColor.xyz *= intermediateColor.w;
    // intermediateColor.xyz += linearGameColor;
    // outputColor.xyz = linearUiColor - intermediateColor.xyz;
    // outputColor.w = _24.w + -1.0f;
    // outputColor *= _24.w;
    // outputColor.xyz += intermediateColor.xyz;
    // outputColor.w += 1.0f;

    outputColor = HandleUICompositing(float4(linearUiColor, _24.w), float4(linearGameColor, _29.w));

    //float _116 = _24.w * 2.0f;
    //float _117 = saturate(_116);
    // float _118 = _50 * -0.6699999570846558f;
    // float _119 = _51 * -0.6699999570846558f;
    // float _120 = _52 * -0.6699999570846558f;
    // float _121 = _118 * _117;
    // float _122 = _119 * _117;
    // float _123 = _120 * _117;
    // float _124 = _121 + _50;
    // float _125 = _122 + _51;
    // float _126 = _123 + _52;

    // float _127 = _41 - _124;
    // float _128 = _42 - _125;
    // float _129 = _43 - _126;
    // float _130 = _24.w + -1.0f;
    // float _131 = _127 * _24.w;
    // float _132 = _128 * _24.w;
    // float _133 = _129 * _24.w;
    // float _134 = _130 * _24.w;
    // float _135 = _131 + _124;
    // float _136 = _132 + _125;
    // float _137 = _133 + _126;
    // float _138 = _134 + 1.0f;
    // _140 = _135;
    // _141 = _136;
    // _142 = _137;
    // _143 = _138;
  }

  // outputColor.rgb = renodx::color::bt2020::from::BT709(outputColor.rgb);
  // outputColor.rgb = renodx::color::pq::EncodeSafe(outputColor.rgb, 80.f);
  // SV_Target.rgb = outputColor.rgb;
  SV_Target.rgb = renodx::draw::SwapChainPass(outputColor.rgb);
  //SV_Target.rgb = renodx::draw::SwapChainPass(linearGameColor.rgb);
  SV_Target.w = outputColor.w;

  // //BT2020
  // float _144 = _140 * 0.627403974533081f;
  // float _145 = mad(0.3292819857597351f, _141, _144);
  // float _146 = mad(0.04331360012292862f, _142, _145);
  // float _147 = _140 * 0.06909699738025665f;
  // float _148 = mad(0.9195399880409241f, _141, _147);
  // float _149 = mad(0.011361200362443924f, _142, _148);
  // float _150 = _140 * 0.01639159955084324f;
  // float _151 = mad(0.08801320195198059f, _141, _150);
  // float _152 = mad(0.8955950140953064f, _142, _151);
  // float _153 = _146 * CustomPixelConsts_000.x;
  // float _154 = _149 * CustomPixelConsts_000.x;
  // float _155 = _152 * CustomPixelConsts_000.x;
  // float _156 = CustomPixelConsts_000.w * 0.8999999761581421f;
  // float _157 = CustomPixelConsts_000.w * 0.10000002384185791f;
  // float _158 = 9.999998092651367f / CustomPixelConsts_000.w;
  // float _159 = _153 - _156;
  // float _160 = _154 - _156;
  // float _161 = _155 - _156;
  // float _162 = _159 * -1.4426950216293335f;
  // float _163 = _162 * _158;
  // float _164 = _160 * -1.4426950216293335f;
  // float _165 = _164 * _158;
  // float _166 = _158 * -1.4426950216293335f;
  // float _167 = _166 * _161;
  // float _168 = exp2(_163);
  // float _169 = exp2(_165);
  // float _170 = exp2(_167);
  // float _171 = _168 * _157;
  // float _172 = _169 * _157;
  // float _173 = _170 * _157;
  // float _174 = CustomPixelConsts_000.w - _171;
  // float _175 = CustomPixelConsts_000.w - _172;
  // float _176 = CustomPixelConsts_000.w - _173;
  // bool _177 = (_153 < _156);
  // bool _178 = (_154 < _156);
  // bool _179 = (_155 < _156);
  // float _180 = select(_177, _153, _174);
  // float _181 = select(_178, _154, _175);
  // float _182 = select(_179, _155, _176);

  // //PQ Encode
  // float _183 = _180 * 9.999999747378752e-05f;
  // float _184 = _181 * 9.999999747378752e-05f;
  // float _185 = _182 * 9.999999747378752e-05f;
  // float _186 = log2(_183);
  // float _187 = log2(_184);
  // float _188 = log2(_185);
  // float _189 = _186 * 0.1593017578125f;
  // float _190 = _187 * 0.1593017578125f;
  // float _191 = _188 * 0.1593017578125f;
  // float _192 = exp2(_189);
  // float _193 = exp2(_190);
  // float _194 = exp2(_191);
  // float _195 = _192 * 18.8515625f;
  // float _196 = _193 * 18.8515625f;
  // float _197 = _194 * 18.8515625f;
  // float _198 = _195 + 0.8359375f;
  // float _199 = _196 + 0.8359375f;
  // float _200 = _197 + 0.8359375f;
  // float _201 = _192 * 18.6875f;
  // float _202 = _193 * 18.6875f;
  // float _203 = _194 * 18.6875f;
  // float _204 = _201 + 1.0f;
  // float _205 = _202 + 1.0f;
  // float _206 = _203 + 1.0f;
  // float _207 = _198 / _204;
  // float _208 = _199 / _205;
  // float _209 = _200 / _206;
  // float _210 = log2(_207);
  // float _211 = log2(_208);
  // float _212 = log2(_209);
  // float _213 = _210 * 78.84375f;
  // float _214 = _211 * 78.84375f;
  // float _215 = _212 * 78.84375f;
  // float _216 = exp2(_213);
  // float _217 = exp2(_214);
  // float _218 = exp2(_215);
  // float _219 = saturate(_216);
  // float _220 = saturate(_217);
  // float _221 = saturate(_218);
  // SV_Target.x = _219;
  // SV_Target.y = _220;
  // SV_Target.z = _221;
  // SV_Target.w = _143;

  // SV_Target_1.x = _73;
  // SV_Target_1.y = _74;
  // SV_Target_1.z = _75;
  // SV_Target_1.w = _76;

  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}
