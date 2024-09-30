#include "./shared.h"

Texture2D<float4> t0 : register(t0);

cbuffer cb0 : register(b0) {
  float cb0_05x : packoffset(c05.x);
  float cb0_05y : packoffset(c05.y);
  float cb0_08x : packoffset(c08.x);
  float cb0_08w : packoffset(c08.w);
  float cb0_08y : packoffset(c08.y);
  float cb0_08z : packoffset(c08.z);
  float cb0_09x : packoffset(c09.x);
  float cb0_10x : packoffset(c10.x);
  float cb0_10y : packoffset(c10.y);
  float cb0_10z : packoffset(c10.z);
  float cb0_10w : packoffset(c10.w);
  float cb0_11x : packoffset(c11.x);
  float cb0_11y : packoffset(c11.y);
  float cb0_11z : packoffset(c11.z);
  float cb0_11w : packoffset(c11.w);
  float cb0_12x : packoffset(c12.x);
  float cb0_12y : packoffset(c12.y);
  float cb0_12z : packoffset(c12.z);
  float cb0_13x : packoffset(c13.x);
  float cb0_13y : packoffset(c13.y);
  float cb0_13z : packoffset(c13.z);
  float cb0_13w : packoffset(c13.w);
  float cb0_14x : packoffset(c14.x);
  float cb0_14y : packoffset(c14.y);
  float cb0_14z : packoffset(c14.z);
  float cb0_15x : packoffset(c15.x);
  float cb0_15y : packoffset(c15.y);
  float cb0_15z : packoffset(c15.z);
  float cb0_15w : packoffset(c15.w);
  float cb0_16x : packoffset(c16.x);
  float cb0_16y : packoffset(c16.y);
  float cb0_16z : packoffset(c16.z);
  float cb0_16w : packoffset(c16.w);
  float cb0_17x : packoffset(c17.x);
  float cb0_17y : packoffset(c17.y);
  float cb0_17z : packoffset(c17.z);
  float cb0_17w : packoffset(c17.w);
  float cb0_18x : packoffset(c18.x);
  float cb0_18y : packoffset(c18.y);
  float cb0_18z : packoffset(c18.z);
  float cb0_18w : packoffset(c18.w);
  float cb0_19x : packoffset(c19.x);
  float cb0_19y : packoffset(c19.y);
  float cb0_19z : packoffset(c19.z);
  float cb0_19w : packoffset(c19.w);
  float cb0_20x : packoffset(c20.x);
  float cb0_20y : packoffset(c20.y);
  float cb0_20z : packoffset(c20.z);
  float cb0_20w : packoffset(c20.w);
  float cb0_21x : packoffset(c21.x);
  float cb0_21y : packoffset(c21.y);
  float cb0_21z : packoffset(c21.z);
  float cb0_21w : packoffset(c21.w);
  float cb0_22x : packoffset(c22.x);
  float cb0_22y : packoffset(c22.y);
  float cb0_22z : packoffset(c22.z);
  float cb0_22w : packoffset(c22.w);
  float cb0_23x : packoffset(c23.x);
  float cb0_23y : packoffset(c23.y);
  float cb0_23z : packoffset(c23.z);
  float cb0_23w : packoffset(c23.w);
  float cb0_24x : packoffset(c24.x);
  float cb0_24y : packoffset(c24.y);
  float cb0_24z : packoffset(c24.z);
  float cb0_24w : packoffset(c24.w);
  float cb0_25x : packoffset(c25.x);
  float cb0_25y : packoffset(c25.y);
  float cb0_25z : packoffset(c25.z);
  float cb0_25w : packoffset(c25.w);
  float cb0_26x : packoffset(c26.x);
  float cb0_26y : packoffset(c26.y);
  float cb0_26z : packoffset(c26.z);
  float cb0_26w : packoffset(c26.w);
  float cb0_27x : packoffset(c27.x);
  float cb0_27y : packoffset(c27.y);
  float cb0_27z : packoffset(c27.z);
  float cb0_27w : packoffset(c27.w);
  float cb0_28x : packoffset(c28.x);
  float cb0_28y : packoffset(c28.y);
  float cb0_28z : packoffset(c28.z);
  float cb0_28w : packoffset(c28.w);
  float cb0_29x : packoffset(c29.x);
  float cb0_29y : packoffset(c29.y);
  float cb0_29z : packoffset(c29.z);
  float cb0_29w : packoffset(c29.w);
  float cb0_30x : packoffset(c30.x);
  float cb0_30y : packoffset(c30.y);
  float cb0_30z : packoffset(c30.z);
  float cb0_30w : packoffset(c30.w);
  float cb0_31x : packoffset(c31.x);
  float cb0_31y : packoffset(c31.y);
  float cb0_31z : packoffset(c31.z);
  float cb0_31w : packoffset(c31.w);
  float cb0_32x : packoffset(c32.x);
  float cb0_32y : packoffset(c32.y);
  float cb0_32z : packoffset(c32.z);
  float cb0_32w : packoffset(c32.w);
  float cb0_33x : packoffset(c33.x);
  float cb0_33y : packoffset(c33.y);
  float cb0_33z : packoffset(c33.z);
  float cb0_33w : packoffset(c33.w);
  float cb0_34x : packoffset(c34.x);
  float cb0_34y : packoffset(c34.y);
  float cb0_34z : packoffset(c34.z);
  float cb0_34w : packoffset(c34.w);
  float cb0_35z : packoffset(c35.z);
  float cb0_35w : packoffset(c35.w);
  float cb0_36x : packoffset(c36.x);
  float cb0_36y : packoffset(c36.y);
  float cb0_36z : packoffset(c36.z);
  float cb0_36w : packoffset(c36.w);
  float cb0_37x : packoffset(c37.x);
  float cb0_37y : packoffset(c37.y);
  float cb0_37z : packoffset(c37.z);
  float cb0_37w : packoffset(c37.w);
  float cb0_38x : packoffset(c38.x);
  float cb0_39x : packoffset(c39.x);
  float cb0_39y : packoffset(c39.y);
  float cb0_39z : packoffset(c39.z);
  float cb0_40y : packoffset(c40.y);
  float cb0_40z : packoffset(c40.z);
  uint cb0_40w : packoffset(c40.w);
  uint cb0_41x : packoffset(c41.x);
};

cbuffer cb1 : register(b1) {
  float cb1_08x : packoffset(c08.x);
  float cb1_08y : packoffset(c08.y);
  float cb1_08z : packoffset(c08.z);
  float cb1_09x : packoffset(c09.x);
  float cb1_09y : packoffset(c09.y);
  float cb1_09z : packoffset(c09.z);
  float cb1_10x : packoffset(c10.x);
  float cb1_10y : packoffset(c10.y);
  float cb1_10z : packoffset(c10.z);
  float cb1_12x : packoffset(c12.x);
  float cb1_12y : packoffset(c12.y);
  float cb1_12z : packoffset(c12.z);
  float cb1_13x : packoffset(c13.x);
  float cb1_13y : packoffset(c13.y);
  float cb1_13z : packoffset(c13.z);
  float cb1_14x : packoffset(c14.x);
  float cb1_14y : packoffset(c14.y);
  float cb1_14z : packoffset(c14.z);
  float cb1_16x : packoffset(c16.x);
  float cb1_16y : packoffset(c16.y);
  float cb1_16z : packoffset(c16.z);
  float cb1_17x : packoffset(c17.x);
  float cb1_17y : packoffset(c17.y);
  float cb1_17z : packoffset(c17.z);
  float cb1_18x : packoffset(c18.x);
  float cb1_18y : packoffset(c18.y);
  float cb1_18z : packoffset(c18.z);
  uint cb1_20x : packoffset(c20.x);
};

SamplerState s0 : register(s0);

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex)
    : SV_Target {
  float4 SV_Target;
  // texture _1 = t0;
  // SamplerState _2 = s0;
  // cbuffer _3 = cb1; // index=1
  // cbuffer _4 = cb0; // index=0
  // _5 = _3;
  // _6 = _4;
  uint _7 = SV_RenderTargetArrayIndex;
  float _8 = TEXCOORD.x;
  float _9 = TEXCOORD.y;
  float _10[6];
  float _11[6];
  float _12[6];
  float _13[6];
  float _14 = _8 + -0.015625f;
  float _15 = _9 + -0.015625f;
  float _16 = _14 * 1.0322580337524414f;
  float _17 = _15 * 1.0322580337524414f;
  float _18 = float(_7);
  float _19 = _18 * 0.032258063554763794f;
  uint _21 = cb0_41x;

  // TONEMAPPER_GAMUT_sRGB_D65 0
  // TONEMAPPER_GAMUT_DCIP3_D65 1
  // TONEMAPPER_GAMUT_Rec2020_D65 2
  // TONEMAPPER_GAMUT_ACES_D60 3
  // TONEMAPPER_GAMUT_ACEScg_D60 4

  bool _22 = (_21 == 1);
  float _39 = 1.379158854484558f;
  float _40 = -0.3088507056236267f;
  float _41 = -0.07034677267074585f;
  float _42 = -0.06933528929948807f;
  float _43 = 1.0822921991348267f;
  float _44 = -0.012962047010660172f;
  float _45 = -0.002159259282052517f;
  float _46 = -0.045465391129255295f;
  float _47 = 1.0477596521377563f;
  float _105;
  float _106;
  float _107;
  float _631;
  float _667;
  float _678;
  float _742;
  float _921;
  float _932;
  float _943;
  float _1116;
  float _1117;
  float _1118;
  float _1129;
  float _1140;
  float _1322;
  float _1358;
  float _1369;
  float _1408;
  float _1518;
  float _1592;
  float _1666;
  float _1745;
  float _1746;
  float _1747;
  float _1898;
  float _1934;
  float _1945;
  float _1984;
  float _2094;
  float _2168;
  float _2242;
  float _2321;
  float _2322;
  float _2323;
  float _2500;
  float _2501;
  float _2502;
  if (!_22) {
    bool _24 = (_21 == 2);
    _39 = 1.02579927444458f;
    _40 = -0.020052503794431686f;
    _41 = -0.0057713985443115234f;
    _42 = -0.0022350111976265907f;
    _43 = 1.0045825242996216f;
    _44 = -0.002352306619286537f;
    _45 = -0.005014004185795784f;
    _46 = -0.025293385609984398f;
    _47 = 1.0304402112960815f;
    if (!_24) {
      bool _26 = (_21 == 3);
      _39 = 0.6954522132873535f;
      _40 = 0.14067870378494263f;
      _41 = 0.16386906802654266f;
      _42 = 0.044794563204050064f;
      _43 = 0.8596711158752441f;
      _44 = 0.0955343171954155f;
      _45 = -0.005525882821530104f;
      _46 = 0.004025210160762072f;
      _47 = 1.0015007257461548f;
      if (!_26) {
        bool _28 = (_21 == 4);
        // AP1_2_sRGB (4) : Identity (5)
        float _29 = _28 ? 1.0f : 1.7050515413284302f;
        float _30 = _28 ? 0.0f : -0.6217905879020691f;
        float _31 = _28 ? 0.0f : -0.0832584798336029f;
        float _32 = _28 ? 0.0f : -0.13025718927383423f;
        float _33 = _28 ? 1.0f : 1.1408027410507202f;
        float _34 = _28 ? 0.0f : -0.010548528283834457f;
        float _35 = _28 ? 0.0f : -0.024003278464078903f;
        float _36 = _28 ? 0.0f : -0.1289687603712082f;
        float _37 = _28 ? 1.0f : 1.152971863746643f;
        _39 = _29;
        _40 = _30;
        _41 = _31;
        _42 = _32;
        _43 = _33;
        _44 = _34;
        _45 = _35;
        _46 = _36;
        _47 = _37;
      }
    }
  }
  uint _49 = cb0_40w;
  bool _50 = (_49 > 2);

  if (_50) {
    float _52 = log2(_16);
    float _53 = log2(_17);
    float _54 = log2(_19);
    float _55 = _52 * 0.012683313339948654f;
    float _56 = _53 * 0.012683313339948654f;
    float _57 = _54 * 0.012683313339948654f;
    float _58 = exp2(_55);
    float _59 = exp2(_56);
    float _60 = exp2(_57);
    float _61 = _58 + -0.8359375f;
    float _62 = _59 + -0.8359375f;
    float _63 = _60 + -0.8359375f;
    float _64 = max(0.0f, _61);
    float _65 = max(0.0f, _62);
    float _66 = max(0.0f, _63);
    float _67 = _58 * 18.6875f;
    float _68 = _59 * 18.6875f;
    float _69 = _60 * 18.6875f;
    float _70 = 18.8515625f - _67;
    float _71 = 18.8515625f - _68;
    float _72 = 18.8515625f - _69;
    float _73 = _64 / _70;
    float _74 = _65 / _71;
    float _75 = _66 / _72;
    float _76 = log2(_73);
    float _77 = log2(_74);
    float _78 = log2(_75);
    float _79 = _76 * 6.277394771575928f;
    float _80 = _77 * 6.277394771575928f;
    float _81 = _78 * 6.277394771575928f;
    float _82 = exp2(_79);
    float _83 = exp2(_80);
    float _84 = exp2(_81);
    float _85 = _82 * 100.0f;
    float _86 = _83 * 100.0f;
    float _87 = _84 * 100.0f;
    _105 = _85;
    _106 = _86;
    _107 = _87;
  } else {
    float _89 = _14 * 14.45161247253418f;
    float _90 = _89 + -6.07624626159668f;
    float _91 = _15 * 14.45161247253418f;
    float _92 = _91 + -6.07624626159668f;
    float _93 = _18 * 0.4516128897666931f;
    float _94 = _93 + -6.07624626159668f;
    float _95 = exp2(_90);
    float _96 = exp2(_92);
    float _97 = exp2(_94);
    float _98 = _95 * 0.18000000715255737f;
    float _99 = _96 * 0.18000000715255737f;
    float _100 = _97 * 0.18000000715255737f;
    float _101 = _98 + -0.002667719265446067f;
    float _102 = _99 + -0.002667719265446067f;
    float _103 = _100 + -0.002667719265446067f;
    _105 = _101;
    _106 = _102;
    _107 = _103;
  }

  float3 input_color = float3(_105, _106, _107);

  float _109 = cb1_08x;
  float _110 = cb1_08y;
  float _111 = cb1_08z;
  float _113 = cb1_09x;
  float _114 = cb1_09y;
  float _115 = cb1_09z;
  float _117 = cb1_10x;
  float _118 = cb1_10y;
  float _119 = cb1_10z;
  float _120 = _109 * _105;
  float _121 = mad(_110, _106, _120);
  float _122 = mad(_111, _107, _121);
  float _123 = _113 * _105;
  float _124 = mad(_114, _106, _123);
  float _125 = mad(_115, _107, _124);
  float _126 = _117 * _105;
  float _127 = mad(_118, _106, _126);
  float _128 = mad(_119, _107, _127);

  // Gamut Expansion
  // AP1_RGB2Y
  float _129 = dot(float3(_122, _125, _128), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _130 = _122 / _129;
  float _131 = _125 / _129;
  float _132 = _128 / _129;
  float _133 = _130 + -1.0f;
  float _134 = _131 + -1.0f;
  float _135 = _132 + -1.0f;
  float _136 = dot(float3(_133, _134, _135), float3(_133, _134, _135));
  float _137 = _136 * -4.0f;
  float _138 = exp2(_137);
  float _139 = 1.0f - _138;
  float _141 = cb0_36z;
  float _142 = _129 * _129;
  float _143 = _142 * -4.0f;
  float _144 = _143 * _141;
  float _145 = exp2(_144);
  float _146 = 1.0f - _145;
  float _147 = _146 * _139;
  float _148 = _122 * 1.370412826538086f;
  float _149 = mad(-0.32929131388664246f, _125, _148);
  float _150 = mad(-0.06368283927440643f, _128, _149);
  float _151 = _122 * -0.08343426138162613f;
  float _152 = mad(1.0970908403396606f, _125, _151);
  float _153 = mad(-0.010861567221581936f, _128, _152);
  float _154 = _122 * -0.02579325996339321f;
  float _155 = mad(-0.09862564504146576f, _125, _154);
  float _156 = mad(1.203694462776184f, _128, _155);
  float _157 = _150 - _122;
  float _158 = _153 - _125;
  float _159 = _156 - _128;
  float _160 = _157 * _147;
  float _161 = _158 * _147;
  float _162 = _159 * _147;
  float _163 = _160 + _122;
  float _164 = _161 + _125;
  float _165 = _162 + _128;

  // AP1_RGB2Y
  float _166 = dot(float3(_163, _164, _165), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _168 = cb0_24x;
  float _169 = cb0_24y;
  float _170 = cb0_24z;
  float _171 = cb0_24w;
  float _173 = cb0_19x;
  float _174 = cb0_19y;
  float _175 = cb0_19z;
  float _176 = cb0_19w;
  float _177 = _173 + _168;
  float _178 = _174 + _169;
  float _179 = _175 + _170;
  float _180 = _176 + _171;
  float _182 = cb0_23x;
  float _183 = cb0_23y;
  float _184 = cb0_23z;
  float _185 = cb0_23w;
  float _187 = cb0_18x;
  float _188 = cb0_18y;
  float _189 = cb0_18z;
  float _190 = cb0_18w;
  float _191 = _187 * _182;
  float _192 = _188 * _183;
  float _193 = _189 * _184;
  float _194 = _190 * _185;
  float _196 = cb0_22x;
  float _197 = cb0_22y;
  float _198 = cb0_22z;
  float _199 = cb0_22w;
  float _201 = cb0_17x;
  float _202 = cb0_17y;
  float _203 = cb0_17z;
  float _204 = cb0_17w;
  float _205 = _201 * _196;
  float _206 = _202 * _197;
  float _207 = _203 * _198;
  float _208 = _204 * _199;
  float _210 = cb0_21x;
  float _211 = cb0_21y;
  float _212 = cb0_21z;
  float _213 = cb0_21w;
  float _215 = cb0_16x;
  float _216 = cb0_16y;
  float _217 = cb0_16z;
  float _218 = cb0_16w;
  float _219 = _215 * _210;
  float _220 = _216 * _211;
  float _221 = _217 * _212;
  float _222 = _218 * _213;
  float _224 = cb0_20x;
  float _225 = cb0_20y;
  float _226 = cb0_20z;
  float _227 = cb0_20w;
  float _229 = cb0_15x;
  float _230 = cb0_15y;
  float _231 = cb0_15z;
  float _232 = cb0_15w;
  float _233 = _229 * _224;
  float _234 = _230 * _225;
  float _235 = _231 * _226;
  float _236 = _232 * _227;
  float _237 = _233 * _236;
  float _238 = _234 * _236;
  float _239 = _235 * _236;
  float _240 = _163 - _166;
  float _241 = _164 - _166;
  float _242 = _165 - _166;
  float _243 = _237 * _240;
  float _244 = _238 * _241;
  float _245 = _239 * _242;
  float _246 = _243 + _166;
  float _247 = _244 + _166;
  float _248 = _245 + _166;
  float _249 = max(0.0f, _246);
  float _250 = max(0.0f, _247);
  float _251 = max(0.0f, _248);
  float _252 = _219 * _222;
  float _253 = _220 * _222;
  float _254 = _221 * _222;
  float _255 = _249 * 5.55555534362793f;
  float _256 = _250 * 5.55555534362793f;
  float _257 = _251 * 5.55555534362793f;
  float _258 = log2(_255);
  float _259 = log2(_256);
  float _260 = log2(_257);
  float _261 = _252 * _258;
  float _262 = _253 * _259;
  float _263 = _254 * _260;
  float _264 = exp2(_261);
  float _265 = exp2(_262);
  float _266 = exp2(_263);
  float _267 = _264 * 0.18000000715255737f;
  float _268 = _265 * 0.18000000715255737f;
  float _269 = _266 * 0.18000000715255737f;
  float _270 = _205 * _208;
  float _271 = _206 * _208;
  float _272 = _207 * _208;
  float _273 = 1.0f / _270;
  float _274 = 1.0f / _271;
  float _275 = 1.0f / _272;
  float _276 = log2(_267);
  float _277 = log2(_268);
  float _278 = log2(_269);
  float _279 = _276 * _273;
  float _280 = _277 * _274;
  float _281 = _278 * _275;
  float _282 = exp2(_279);
  float _283 = exp2(_280);
  float _284 = exp2(_281);
  float _285 = _191 * _194;
  float _286 = _192 * _194;
  float _287 = _193 * _194;
  float _288 = _285 * _282;
  float _289 = _286 * _283;
  float _290 = _287 * _284;
  float _291 = _177 + _180;
  float _292 = _178 + _180;
  float _293 = _179 + _180;
  float _294 = _291 + _288;
  float _295 = _292 + _289;
  float _296 = _293 + _290;
  float _298 = cb0_35z;
  float _299 = _166 / _298;
  float _300 = saturate(_299);
  float _301 = _300 * 2.0f;
  float _302 = 3.0f - _301;
  float _303 = _300 * _300;
  float _304 = _303 * _302;
  float _305 = 1.0f - _304;
  float _307 = cb0_34x;
  float _308 = cb0_34y;
  float _309 = cb0_34z;
  float _310 = cb0_34w;
  float _311 = _173 + _307;
  float _312 = _174 + _308;
  float _313 = _175 + _309;
  float _314 = _176 + _310;
  float _316 = cb0_33x;
  float _317 = cb0_33y;
  float _318 = cb0_33z;
  float _319 = cb0_33w;
  float _320 = _187 * _316;
  float _321 = _188 * _317;
  float _322 = _189 * _318;
  float _323 = _190 * _319;
  float _325 = cb0_32x;
  float _326 = cb0_32y;
  float _327 = cb0_32z;
  float _328 = cb0_32w;
  float _329 = _201 * _325;
  float _330 = _202 * _326;
  float _331 = _203 * _327;
  float _332 = _204 * _328;
  float _334 = cb0_31x;
  float _335 = cb0_31y;
  float _336 = cb0_31z;
  float _337 = cb0_31w;
  float _338 = _215 * _334;
  float _339 = _216 * _335;
  float _340 = _217 * _336;
  float _341 = _218 * _337;
  float _343 = cb0_30x;
  float _344 = cb0_30y;
  float _345 = cb0_30z;
  float _346 = cb0_30w;
  float _347 = _229 * _343;
  float _348 = _230 * _344;
  float _349 = _231 * _345;
  float _350 = _232 * _346;
  float _351 = _347 * _350;
  float _352 = _348 * _350;
  float _353 = _349 * _350;
  float _354 = _351 * _240;
  float _355 = _352 * _241;
  float _356 = _353 * _242;
  float _357 = _354 + _166;
  float _358 = _355 + _166;
  float _359 = _356 + _166;
  float _360 = max(0.0f, _357);
  float _361 = max(0.0f, _358);
  float _362 = max(0.0f, _359);
  float _363 = _338 * _341;
  float _364 = _339 * _341;
  float _365 = _340 * _341;
  float _366 = _360 * 5.55555534362793f;
  float _367 = _361 * 5.55555534362793f;
  float _368 = _362 * 5.55555534362793f;
  float _369 = log2(_366);
  float _370 = log2(_367);
  float _371 = log2(_368);
  float _372 = _363 * _369;
  float _373 = _364 * _370;
  float _374 = _365 * _371;
  float _375 = exp2(_372);
  float _376 = exp2(_373);
  float _377 = exp2(_374);
  float _378 = _375 * 0.18000000715255737f;
  float _379 = _376 * 0.18000000715255737f;
  float _380 = _377 * 0.18000000715255737f;
  float _381 = _329 * _332;
  float _382 = _330 * _332;
  float _383 = _331 * _332;
  float _384 = 1.0f / _381;
  float _385 = 1.0f / _382;
  float _386 = 1.0f / _383;
  float _387 = log2(_378);
  float _388 = log2(_379);
  float _389 = log2(_380);
  float _390 = _387 * _384;
  float _391 = _388 * _385;
  float _392 = _389 * _386;
  float _393 = exp2(_390);
  float _394 = exp2(_391);
  float _395 = exp2(_392);
  float _396 = _320 * _323;
  float _397 = _321 * _323;
  float _398 = _322 * _323;
  float _399 = _396 * _393;
  float _400 = _397 * _394;
  float _401 = _398 * _395;
  float _402 = _311 + _314;
  float _403 = _312 + _314;
  float _404 = _313 + _314;
  float _405 = _402 + _399;
  float _406 = _403 + _400;
  float _407 = _404 + _401;
  float _408 = cb0_36x;
  float _409 = cb0_35w;
  float _410 = _408 - _409;
  float _411 = _166 - _409;
  float _412 = _411 / _410;
  float _413 = saturate(_412);
  float _414 = _413 * 2.0f;
  float _415 = 3.0f - _414;
  float _416 = _413 * _413;
  float _417 = _416 * _415;
  float _419 = cb0_29x;
  float _420 = cb0_29y;
  float _421 = cb0_29z;
  float _422 = cb0_29w;
  float _423 = _173 + _419;
  float _424 = _174 + _420;
  float _425 = _175 + _421;
  float _426 = _176 + _422;
  float _428 = cb0_28x;
  float _429 = cb0_28y;
  float _430 = cb0_28z;
  float _431 = cb0_28w;
  float _432 = _187 * _428;
  float _433 = _188 * _429;
  float _434 = _189 * _430;
  float _435 = _190 * _431;
  float _437 = cb0_27x;
  float _438 = cb0_27y;
  float _439 = cb0_27z;
  float _440 = cb0_27w;
  float _441 = _201 * _437;
  float _442 = _202 * _438;
  float _443 = _203 * _439;
  float _444 = _204 * _440;
  float _446 = cb0_26x;
  float _447 = cb0_26y;
  float _448 = cb0_26z;
  float _449 = cb0_26w;
  float _450 = _215 * _446;
  float _451 = _216 * _447;
  float _452 = _217 * _448;
  float _453 = _218 * _449;
  float _455 = cb0_25x;
  float _456 = cb0_25y;
  float _457 = cb0_25z;
  float _458 = cb0_25w;
  float _459 = _229 * _455;
  float _460 = _230 * _456;
  float _461 = _231 * _457;
  float _462 = _232 * _458;
  float _463 = _459 * _462;
  float _464 = _460 * _462;
  float _465 = _461 * _462;
  float _466 = _463 * _240;
  float _467 = _464 * _241;
  float _468 = _465 * _242;
  float _469 = _466 + _166;
  float _470 = _467 + _166;
  float _471 = _468 + _166;
  float _472 = max(0.0f, _469);
  float _473 = max(0.0f, _470);
  float _474 = max(0.0f, _471);
  float _475 = _450 * _453;
  float _476 = _451 * _453;
  float _477 = _452 * _453;
  float _478 = _472 * 5.55555534362793f;
  float _479 = _473 * 5.55555534362793f;
  float _480 = _474 * 5.55555534362793f;
  float _481 = log2(_478);
  float _482 = log2(_479);
  float _483 = log2(_480);
  float _484 = _475 * _481;
  float _485 = _476 * _482;
  float _486 = _477 * _483;
  float _487 = exp2(_484);
  float _488 = exp2(_485);
  float _489 = exp2(_486);
  float _490 = _487 * 0.18000000715255737f;
  float _491 = _488 * 0.18000000715255737f;
  float _492 = _489 * 0.18000000715255737f;
  float _493 = _441 * _444;
  float _494 = _442 * _444;
  float _495 = _443 * _444;
  float _496 = 1.0f / _493;
  float _497 = 1.0f / _494;
  float _498 = 1.0f / _495;
  float _499 = log2(_490);
  float _500 = log2(_491);
  float _501 = log2(_492);
  float _502 = _499 * _496;
  float _503 = _500 * _497;
  float _504 = _501 * _498;
  float _505 = exp2(_502);
  float _506 = exp2(_503);
  float _507 = exp2(_504);
  float _508 = _432 * _435;
  float _509 = _433 * _435;
  float _510 = _434 * _435;
  float _511 = _508 * _505;
  float _512 = _509 * _506;
  float _513 = _510 * _507;
  float _514 = _423 + _426;
  float _515 = _424 + _426;
  float _516 = _425 + _426;
  float _517 = _514 + _511;
  float _518 = _515 + _512;
  float _519 = _516 + _513;
  float _520 = _304 - _417;
  float _521 = _305 * _294;
  float _522 = _305 * _295;
  float _523 = _305 * _296;
  float _524 = _517 * _520;
  float _525 = _518 * _520;
  float _526 = _519 * _520;
  float _527 = _417 * _405;
  float _528 = _417 * _406;
  float _529 = _417 * _407;
  float _530 = _527 + _521;
  float _531 = _530 + _524;
  float _532 = _528 + _522;
  float _533 = _532 + _525;
  float _534 = _529 + _523;
  float _535 = _534 + _526;
  float _537 = cb1_12x;
  float _538 = cb1_12y;
  float _539 = cb1_12z;
  float _541 = cb1_13x;
  float _542 = cb1_13y;
  float _543 = cb1_13z;
  float _545 = cb1_14x;
  float _546 = cb1_14y;
  float _547 = cb1_14z;
  float _548 = _531 * _537;
  float _549 = mad(_538, _533, _548);
  float _550 = mad(_539, _535, _549);
  float _551 = _541 * _531;
  float _552 = mad(_542, _533, _551);
  float _553 = mad(_543, _535, _552);
  float _554 = _545 * _531;
  float _555 = mad(_546, _533, _554);
  float _556 = mad(_547, _535, _555);

  float _557 = cb0_36y;  // BlueCorrect

  float _558 = _531 * 0.9386394023895264f;
  float _559 = mad(-4.540197551250458e-09f, _533, _558);
  float _560 = mad(0.061360642313957214f, _535, _559);
  float _561 = _531 * 6.775371730327606e-08f;
  float _562 = mad(0.8307942152023315f, _533, _561);
  float _563 = mad(0.169205904006958f, _535, _562);
  float _564 = _531 * -9.313225746154785e-10f;
  float _565 = mad(-2.3283064365386963e-10f, _533, _564);
  float _566 = _560 - _531;
  float _567 = _563 - _533;
  float _568 = _566 * _557;
  float _569 = _567 * _557;
  float _570 = _565 * _557;
  float _571 = _568 + _531;
  float _572 = _569 + _533;
  float _573 = _570 + _535;

  float3 ap1_graded_color = float3(_571, _572, _573);
  // Finished grading in AP1

  // start of FilmToneMap

  // Start (ACES::RRT)

  // AP1 => AP0
  float _574 = _571 * 0.6954522132873535f;
  float _575 = mad(0.14067868888378143f, _572, _574);
  float _576 = mad(0.16386905312538147f, _573, _575);
  float _577 = _571 * 0.044794581830501556f;
  float _578 = mad(0.8596711158752441f, _572, _577);
  float _579 = mad(0.0955343246459961f, _573, _578);
  float _580 = _571 * -0.005525882821530104f;
  float _581 = mad(0.004025210160762072f, _572, _580);
  float _582 = mad(1.0015007257461548f, _573, _581);

  // aces::rgb_2_saturation
  float _583 = min(_576, _579);
  float _584 = min(_583, _582);
  float _585 = max(_576, _579);
  float _586 = max(_585, _582);
  float _587 = max(_586, 1.000000013351432e-10f);
  float _588 = max(_584, 1.000000013351432e-10f);
  float _589 = _587 - _588;
  float _590 = max(_586, 0.009999999776482582f);
  float _591 = _589 / _590;

  // aces::rgb_2_yc
  float _592 = _582 - _579;
  float _593 = _592 * _582;
  float _594 = _579 - _576;
  float _595 = _594 * _579;
  float _596 = _593 + _595;
  float _597 = _576 - _582;
  float _598 = _597 * _576;
  float _599 = _596 + _598;
  float _600 = sqrt(_599);
  float _601 = _600 * 1.75f;
  float _602 = _579 + _576;
  float _603 = _602 + _582;
  float _604 = _603 + _601;
  float _605 = _604 * 0.3333333432674408f;
  float _606 = _591 + -0.4000000059604645f;

  // aces:sigmoid_shaper
  float _607 = _606 * 5.0f;
  float _608 = _606 * 2.5f;
  float _609 = abs(_608);
  float _610 = 1.0f - _609;
  float _611 = max(_610, 0.0f);
  bool _612 = (_607 > 0.0f);
  bool _613 = (_607 < 0.0f);
  int _614 = int(_612);
  int _615 = int(_613);
  int _616 = _614 - _615;
  float _617 = float(_616);
  float _618 = _611 * _611;
  float _619 = 1.0f - _618;
  float _620 = _617 * _619;
  float _621 = _620 + 1.0f;
  float _622 = _621 * 0.02500000037252903f;
  bool _623 = !(_605 <= 0.0533333346247673f);
  _631 = _622;
  if (_623) {
    bool _625 = !(_605 >= 0.1599999964237213f);
    _631 = 0.0f;
    if (_625) {
      float _627 = 0.23999999463558197f / _604;
      float _628 = _627 + -0.5f;
      float _629 = _628 * _622;
      _631 = _629;
    }
  }

  // aces::added_glow
  float _632 = _631 + 1.0f;

  float _633 = _632 * _576;
  float _634 = _632 * _579;
  float _635 = _632 * _582;

  // aces::rgb_2_hue
  bool _636 = (_633 == _634);
  bool _637 = (_634 == _635);
  bool _638 = _636 && _637;
  _667 = 0.0f;
  if (!_638) {
    float _640 = _633 * 2.0f;
    float _641 = _640 - _634;
    float _642 = _641 - _635;
    float _643 = _579 - _582;
    float _644 = _643 * 1.7320507764816284f;
    float _645 = _644 * _632;
    float _646 = _645 / _642;
    float _647 = atan(_646);
    float _648 = _647 + 3.1415927410125732f;
    float _649 = _647 + -3.1415927410125732f;
    bool _650 = (_642 < 0.0f);
    bool _651 = (_642 == 0.0f);
    bool _652 = (_645 >= 0.0f);
    bool _653 = (_645 < 0.0f);
    bool _654 = _652 && _650;
    float _655 = _654 ? _648 : _647;
    bool _656 = _653 && _650;
    float _657 = _656 ? _649 : _655;
    bool _658 = _653 && _651;
    bool _659 = _652 && _651;
    float _660 = _657 * 57.2957763671875f;
    float _661 = _658 ? -90.0f : _660;
    float _662 = _659 ? 90.0f : _661;
    bool _663 = (_662 < 0.0f);
    _667 = _662;
    if (_663) {
      float _665 = _662 + 360.0f;
      _667 = _665;
    }
  }
  float _668 = max(_667, 0.0f);
  float _669 = min(_668, 360.0f);

  // aces::center_hue
  bool _670 = (_669 < -180.0f);
  if (_670) {
    float _672 = _669 + 360.0f;
    _678 = _672;
  } else {
    bool _674 = (_669 > 180.0f);
    _678 = _669;
    if (_674) {
      float _676 = _669 + -360.0f;
      _678 = _676;
    }
  }

  // aces::hueweight (with smoothstep)
  float _679 = _678 * 0.014814814552664757f;
  float _680 = abs(_679);
  float _681 = 1.0f - _680;
  float _682 = saturate(_681);
  float _683 = _682 * 2.0f;
  float _684 = 3.0f - _683;
  float _685 = _682 * _682;

  float _686 = _685 * _684;

  // RRT_RED_PIVOT
  float _687 = 0.029999999329447746f - _633;

  // 1 - RRT_RED_SCALE
  float _688 = _591 * 0.18000000715255737f;
  float _689 = _688 * _687;
  float _690 = _686 * _686;
  float _691 = _690 * _689;
  float _692 = _691 + _633;

  // AP0 => AP1
  float _693 = _692 * 1.4514392614364624f;
  float _694 = mad(-0.2365107536315918f, _634, _693);
  float _695 = mad(-0.21492856740951538f, _635, _694);
  float _696 = _692 * -0.07655377686023712f;
  float _697 = mad(1.17622971534729f, _634, _696);
  float _698 = mad(-0.09967592358589172f, _635, _697);
  float _699 = _692 * 0.008316148072481155f;
  float _700 = mad(-0.006032449658960104f, _634, _699);
  float _701 = mad(0.9977163076400757f, _635, _700);

  // Clamp to AP1
  float _702 = max(0.0f, _695);
  float _703 = max(0.0f, _698);
  float _704 = max(0.0f, _701);

  // AP1_RGB2Y
  // Desaturate
  float _705 = dot(float3(_702, _703, _704), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _706 = _702 - _705;
  float _707 = _703 - _705;
  float _708 = _704 - _705;
  // RRT_SAT_FACTOR (0.96)
  float _709 = _706 * 0.9599999785423279f;
  float _710 = _707 * 0.9599999785423279f;
  float _711 = _708 * 0.9599999785423279f;
  float _712 = _709 + _705;
  float _713 = _710 + _705;
  float _714 = _711 + _705;

  // End ACES::RRT

  // Custom
  float3 ap1_aces_colored = float3(_712, _713, _714);

  // Now SDR Tonemapping/Split

  // Early out with cbuffer
  // (Unreal runs the entire SDR process even if discarding)
  uint output_type = cb0_40w;

  float3 sdr_color;
  float3 hdr_color;
  float3 sdr_ap1_color;

  float _716 = cb0_37w;      // FilmBlackClip
  float _717 = _716 + 1.0f;  // 1 + FilmBlackClip
  float _718 = cb0_37y;      // FilmToe
  float _719 = _717 - _718;  // ToeScale
  float _721 = cb0_38x;      // FilmWhiteClip
  float _722 = _721 + 1.0f;  // 1 + FilmWhiteClip
  float _723 = cb0_37z;      // FilmShoulder
  float _724 = _722 - _723;  // ShoulderScale

  bool is_hdr = (output_type >= 3u && output_type <= 6u);
  if (injectedData.toneMapType != 0.f && is_hdr) {
    renodx::tonemap::Config config = renodx::tonemap::config::Create();
    config.type = injectedData.toneMapType;
    config.peak_nits = injectedData.toneMapPeakNits;
    config.game_nits = injectedData.toneMapGameNits;
    config.gamma_correction = injectedData.toneMapGammaCorrection;
    config.exposure = injectedData.colorGradeExposure;
    config.highlights = injectedData.colorGradeHighlights;
    config.shadows = injectedData.colorGradeShadows;
    config.contrast = injectedData.colorGradeContrast;
    config.saturation = injectedData.colorGradeSaturation;
    config.hue_correction_color = ap1_aces_colored;
    config.reno_drt_highlights = 1.20f;
    config.reno_drt_shadows = 1.0f;
    config.reno_drt_contrast = 1.80f;
    config.reno_drt_saturation = 1.80f;
    config.reno_drt_dechroma = injectedData.colorGradeBlowout;
    config.reno_drt_flare = 0.f;

    float3 config_color = renodx::color::bt709::from::AP1(ap1_graded_color);

    renodx::tonemap::config::DualToneMap dual_tone_map = renodx::tonemap::config::ApplyToneMaps(config_color, config);
    hdr_color = dual_tone_map.color_hdr;
    sdr_color = dual_tone_map.color_sdr;
    sdr_ap1_color = renodx::color::ap1::from::BT709(sdr_color);
  } else {
    // Film Toe > 0.8
    bool _725 = (_718 > 0.800000011920929f);
    float _726 = cb0_37x;  // FilmSlope
    if (_725) {
      float _728 = 0.8199999928474426f - _718;
      float _729 = _728 / _726;
      float _730 = _729 + -0.7447274923324585f;
      _742 = _730;
    } else {
      float _732 = _716 + 0.18000000715255737f;
      float _733 = _732 / _719;
      float _734 = 2.0f - _733;
      float _735 = _733 / _734;
      float _736 = log2(_735);
      float _737 = _736 * 0.3465735912322998f;
      float _738 = _719 / _726;
      float _739 = _737 * _738;
      float _740 = -0.7447274923324585f - _739;
      _742 = _740;
    }

    float _743 = 1.0f - _718;
    float _744 = _743 / _726;
    float _745 = _744 - _742;
    float _746 = _723 / _726;
    float _747 = _746 - _745;
    float _748 = log2(_712);
    float _749 = log2(_713);
    float _750 = log2(_714);

    float _751 = _748 * 0.3010300099849701f;
    float _752 = _749 * 0.3010300099849701f;
    float _753 = _750 * 0.3010300099849701f;
    float _754 = _751 + _745;
    float _755 = _752 + _745;
    float _756 = _753 + _745;
    float _757 = _726 * _754;
    float _758 = _726 * _755;
    float _759 = _726 * _756;
    float _760 = _719 * 2.0f;
    float _761 = _726 * -2.0f;
    float _762 = _761 / _719;
    float _763 = _751 - _742;
    float _764 = _752 - _742;
    float _765 = _753 - _742;
    float _766 = _763 * 1.4426950216293335f;
    float _767 = _766 * _762;
    float _768 = _764 * 1.4426950216293335f;
    float _769 = _768 * _762;
    float _770 = _765 * 1.4426950216293335f;
    float _771 = _770 * _762;
    float _772 = exp2(_767);
    float _773 = exp2(_769);
    float _774 = exp2(_771);
    float _775 = _772 + 1.0f;
    float _776 = _773 + 1.0f;
    float _777 = _774 + 1.0f;
    float _778 = _760 / _775;
    float _779 = _760 / _776;
    float _780 = _760 / _777;
    float _781 = _778 - _716;
    float _782 = _779 - _716;
    float _783 = _780 - _716;
    float _784 = _724 * 2.0f;
    float _785 = _726 * 2.0f;
    float _786 = _785 / _724;
    float _787 = _751 - _747;
    float _788 = _752 - _747;
    float _789 = _753 - _747;
    float _790 = _787 * 1.4426950216293335f;
    float _791 = _790 * _786;
    float _792 = _788 * 1.4426950216293335f;
    float _793 = _792 * _786;
    float _794 = _789 * 1.4426950216293335f;
    float _795 = _794 * _786;
    float _796 = exp2(_791);
    float _797 = exp2(_793);
    float _798 = exp2(_795);
    float _799 = _796 + 1.0f;
    float _800 = _797 + 1.0f;
    float _801 = _798 + 1.0f;
    float _802 = _784 / _799;
    float _803 = _784 / _800;
    float _804 = _784 / _801;
    float _805 = _722 - _802;
    float _806 = _722 - _803;
    float _807 = _722 - _804;
    bool _808 = (_751 < _742);
    bool _809 = (_752 < _742);
    bool _810 = (_753 < _742);
    float _811 = _808 ? _781 : _757;
    float _812 = _809 ? _782 : _758;
    float _813 = _810 ? _783 : _759;
    bool _814 = (_751 > _747);
    bool _815 = (_752 > _747);
    bool _816 = (_753 > _747);
    float _817 = _814 ? _805 : _757;
    float _818 = _815 ? _806 : _758;
    float _819 = _816 ? _807 : _759;
    float _820 = _747 - _742;
    float _821 = _763 / _820;
    float _822 = _764 / _820;
    float _823 = _765 / _820;
    float _824 = saturate(_821);
    float _825 = saturate(_822);
    float _826 = saturate(_823);
    bool _827 = (_747 < _742);
    float _828 = 1.0f - _824;
    float _829 = 1.0f - _825;
    float _830 = 1.0f - _826;
    float _831 = _827 ? _828 : _824;
    float _832 = _827 ? _829 : _825;
    float _833 = _827 ? _830 : _826;
    float _834 = _831 * 2.0f;
    float _835 = _832 * 2.0f;
    float _836 = _833 * 2.0f;
    float _837 = 3.0f - _834;
    float _838 = 3.0f - _835;
    float _839 = 3.0f - _836;
    float _840 = _817 - _811;
    float _841 = _818 - _812;
    float _842 = _819 - _813;
    float _843 = _831 * _831;
    float _844 = _843 * _840;
    float _845 = _844 * _837;
    float _846 = _832 * _832;
    float _847 = _846 * _841;
    float _848 = _847 * _838;
    float _849 = _833 * _833;
    float _850 = _849 * _842;
    float _851 = _850 * _839;
    float _852 = _845 + _811;
    float _853 = _848 + _812;
    float _854 = _851 + _813;
    // AP1_RGB2Y
    float _855 = dot(float3(_852, _853, _854), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
    float _856 = _852 - _855;
    float _857 = _853 - _855;
    float _858 = _854 - _855;
    float _859 = _856 * 0.9300000071525574f;
    float _860 = _857 * 0.9300000071525574f;
    float _861 = _858 * 0.9300000071525574f;
    float _862 = _859 + _855;
    float _863 = _860 + _855;
    float _864 = _861 + _855;
    float _865 = max(0.0f, _862);
    float _866 = max(0.0f, _863);
    float _867 = max(0.0f, _864);

    sdr_ap1_color = float3(_865, _866, _867);
    // end of FilmToneMap
  }

  // lerp untonemapped/tonemapped via ToneCurveAmount
  float _868 = cb0_36w;
  // float _869 = _865 - _571;
  // float _870 = _866 - _572;
  // float _871 = _867 - _573;
  float _869 = sdr_ap1_color.r - _571;
  float _870 = sdr_ap1_color.g - _572;
  float _871 = sdr_ap1_color.b - _573;
  float _872 = _868 * _869;
  float _873 = _868 * _870;
  float _874 = _868 * _871;
  float _875 = _872 + _571;
  float _876 = _873 + _572;
  float _877 = _874 + _573;

  // BlueBlueCorrectInv
  float _878 = _875 * 1.065374732017517f;
  float _879 = mad(1.451815478503704e-06f, _876, _878);
  float _880 = mad(-0.06537103652954102f, _877, _879);
  float _881 = _875 * -2.57161445915699e-07f;
  float _882 = mad(1.2036634683609009f, _876, _881);
  float _883 = mad(-0.20366770029067993f, _877, _882);
  float _884 = _875 * 1.862645149230957e-08f;
  float _885 = mad(2.0954757928848267e-08f, _876, _884);
  float _886 = mad(0.9999996423721313f, _877, _885);

  // lerp with BlueCorrection
  float _887 = _880 - _875;
  float _888 = _883 - _876;
  float _889 = _886 - _877;
  float _890 = _887 * _557;
  float _891 = _888 * _557;
  float _892 = _889 * _557;
  float _893 = _890 + _875;
  float _894 = _891 + _876;
  float _895 = _892 + _877;
  float _896 = _537 * _893;

  // Convert to Target Colorspace
  float _897 = mad(_538, _894, _896);
  float _898 = mad(_539, _895, _897);
  float _899 = _541 * _893;
  float _900 = mad(_542, _894, _899);
  float _901 = mad(_543, _895, _900);
  float _902 = _545 * _893;
  float _903 = mad(_546, _894, _902);
  float _904 = mad(_547, _895, _903);
  float _905 = max(0.0f, _898);
  float _906 = max(0.0f, _901);
  float _907 = max(0.0f, _904);

  float3 lut_input_color = float3(_905, _906, _907);

  float _1011;  // custom branch
  float _1012;  // custom branch
  float _1013;  // custom branch

  if (injectedData.colorGradeLUTStrength != 1.f || injectedData.colorGradeLUTScaling != 0.f) {
    renodx::lut::Config lut_config = renodx::lut::config::Create(
        s0,
        injectedData.colorGradeLUTStrength,
        injectedData.colorGradeLUTScaling, renodx::lut::config::type::SRGB, renodx::lut::config::type::SRGB, 16);

    float3 post_lut_color = renodx::lut::Sample(t0, lut_config, lut_input_color);
    _1011 = post_lut_color.r;
    _1012 = post_lut_color.g;
    _1013 = post_lut_color.b;
  } else {
    // Clip color to target
    float _908 = saturate(_905);
    float _909 = saturate(_906);
    float _910 = saturate(_907);

    // BT709 to SRGB
    bool _911 = (_908 < 0.0031306699384003878f);
    if (_911) {
      float _913 = _908 * 12.920000076293945f;
      _921 = _913;
    } else {
      float _915 = log2(_908);
      float _916 = _915 * 0.4166666567325592f;
      float _917 = exp2(_916);
      float _918 = _917 * 1.0549999475479126f;
      float _919 = _918 + -0.054999999701976776f;
      _921 = _919;
    }
    bool _922 = (_909 < 0.0031306699384003878f);
    if (_922) {
      float _924 = _909 * 12.920000076293945f;
      _932 = _924;
    } else {
      float _926 = log2(_909);
      float _927 = _926 * 0.4166666567325592f;
      float _928 = exp2(_927);
      float _929 = _928 * 1.0549999475479126f;
      float _930 = _929 + -0.054999999701976776f;
      _932 = _930;
    }
    bool _933 = (_910 < 0.0031306699384003878f);
    if (_933) {
      float _935 = _910 * 12.920000076293945f;
      _943 = _935;
    } else {
      float _937 = log2(_910);
      float _938 = _937 * 0.4166666567325592f;
      float _939 = exp2(_938);
      float _940 = _939 * 1.0549999475479126f;
      float _941 = _940 + -0.054999999701976776f;
      _943 = _941;
    }

    // 16x16x16 LUT Sample
    float _944 = _921 * 0.9375f;
    float _945 = _932 * 0.9375f;
    float _946 = _944 + 0.03125f;
    float _947 = _945 + 0.03125f;
    float _949 = cb0_05x;
    float _950 = _949 * _921;
    float _951 = _949 * _932;
    float _952 = _949 * _943;
    float _953 = cb0_05y;
    float _954 = _943 * 15.0f;
    float _955 = floor(_954);
    float _956 = _954 - _955;
    float _957 = _946 + _955;
    float _958 = _957 * 0.0625f;
    // _959 = _1;
    // _960 = _2;
    float4 _961 = t0.Sample(s0, float2(_958, _947));
    float _962 = _961.x;
    float _963 = _961.y;
    float _964 = _961.z;
    float _965 = _958 + 0.0625f;
    // _966 = _1;
    // _967 = _2;
    float4 _968 = t0.Sample(s0, float2(_965, _947));
    float _969 = _968.x;
    float _970 = _968.y;
    float _971 = _968.z;
    float _972 = _969 - _962;
    float _973 = _970 - _963;
    float _974 = _971 - _964;
    float _975 = _972 * _956;
    float _976 = _973 * _956;
    float _977 = _974 * _956;
    float _978 = _975 + _962;
    float _979 = _976 + _963;
    float _980 = _977 + _964;
    float _981 = _978 * _953;
    float _982 = _979 * _953;
    float _983 = _980 * _953;
    float _984 = _981 + _950;
    float _985 = _982 + _951;
    float _986 = _983 + _952;
    float _987 = max(6.103519990574569e-05f, _984);
    float _988 = max(6.103519990574569e-05f, _985);
    float _989 = max(6.103519990574569e-05f, _986);

    // SRGB => BT709
    float _990 = _987 * 0.07739938050508499f;
    float _991 = _988 * 0.07739938050508499f;
    float _992 = _989 * 0.07739938050508499f;
    float _993 = _987 * 0.9478672742843628f;
    float _994 = _988 * 0.9478672742843628f;
    float _995 = _989 * 0.9478672742843628f;
    float _996 = _993 + 0.05213269963860512f;
    float _997 = _994 + 0.05213269963860512f;
    float _998 = _995 + 0.05213269963860512f;
    float _999 = log2(_996);
    float _1000 = log2(_997);
    float _1001 = log2(_998);
    float _1002 = _999 * 2.4000000953674316f;
    float _1003 = _1000 * 2.4000000953674316f;
    float _1004 = _1001 * 2.4000000953674316f;
    float _1005 = exp2(_1002);
    float _1006 = exp2(_1003);
    float _1007 = exp2(_1004);
    bool _1008 = (_987 > 0.040449999272823334f);
    bool _1009 = (_988 > 0.040449999272823334f);
    bool _1010 = (_989 > 0.040449999272823334f);
    // float _1011 = _1008 ? _1005 : _990;
    // float _1012 = _1009 ? _1006 : _991;
    // float _1013 = _1010 ? _1007 : _992;
    _1011 = _1008 ? _1005 : _990;
    _1012 = _1009 ? _1006 : _991;
    _1013 = _1010 ? _1007 : _992;
  }

  // FilmToneMap Gamma Curve adjustment
  float _1015 = cb0_39x;
  float _1016 = _1015 * _1011;
  float _1017 = _1015 * _1012;
  float _1018 = _1015 * _1013;
  float _1019 = cb0_39y;
  float _1020 = cb0_39z;
  float _1021 = _1019 + _1016;
  float _1022 = _1021 * _1011;
  float _1023 = _1022 + _1020;
  float _1024 = _1019 + _1017;
  float _1025 = _1024 * _1012;
  float _1026 = _1025 + _1020;
  float _1027 = _1019 + _1018;
  float _1028 = _1027 * _1013;
  float _1029 = _1028 + _1020;
  float _1031 = cb0_13w;
  float _1032 = cb0_13x;
  float _1033 = cb0_13y;
  float _1034 = cb0_13z;
  float _1036 = cb0_14x;
  float _1037 = cb0_14y;
  float _1038 = cb0_14z;
  float _1039 = _1036 * _1023;
  float _1040 = _1037 * _1026;
  float _1041 = _1038 * _1029;
  float _1042 = _1032 - _1039;
  float _1043 = _1033 - _1040;
  float _1044 = _1034 - _1041;
  float _1045 = _1042 * _1031;
  float _1046 = _1043 * _1031;
  float _1047 = _1044 * _1031;
  float _1048 = _1045 + _1039;
  float _1049 = _1046 + _1040;
  float _1050 = _1047 + _1041;
  float _1051 = _1036 * _550;
  float _1052 = _1037 * _553;
  float _1053 = _1038 * _556;
  float _1054 = _1032 - _1051;
  float _1055 = _1033 - _1052;
  float _1056 = _1034 - _1053;
  float _1057 = _1054 * _1031;
  float _1058 = _1055 * _1031;
  float _1059 = _1056 * _1031;
  float _1060 = _1057 + _1051;
  float _1061 = _1058 + _1052;
  float _1062 = _1059 + _1053;
  float _1064 = cb0_40y;  // custom gamma (contrast)
  float _1065 = max(0.0f, _1048);
  float _1066 = max(0.0f, _1049);
  float _1067 = max(0.0f, _1050);
  float _1068 = log2(_1065);
  float _1069 = log2(_1066);
  float _1070 = log2(_1067);
  float _1071 = _1068 * _1064;
  float _1072 = _1069 * _1064;
  float _1073 = _1070 * _1064;
  float _1074 = exp2(_1071);
  float _1075 = exp2(_1072);
  float _1076 = exp2(_1073);

  float3 film_graded_color = float3(_1074, _1075, _1076);

  if (is_hdr) {
    float3 final_color = saturate(film_graded_color);
    if (injectedData.toneMapType != 0.f) {
      final_color = renodx::tonemap::UpgradeToneMap(hdr_color, sdr_color, final_color, 1.f);
    }
    if (injectedData.toneMapGammaCorrection == 1.f) {
      final_color = renodx::color::correct::GammaSafe(final_color);
    }
    bool is_pq = (output_type == 3u || output_type == 4u);
    if (is_pq) {
      final_color = renodx::color::bt2020::from::BT709(final_color);
      final_color = renodx::color::pq::Encode(final_color, injectedData.toneMapGameNits);
    }

    return float4(final_color * 0.9523810148239136f, 0);
  }

  // Start Output
  // TONEMAPPER_OUTPUT_sRGB 0
  // TONEMAPPER_OUTPUT_Rec709 1
  // TONEMAPPER_OUTPUT_ExplicitGammaMapping 2
  // TONEMAPPER_OUTPUT_ACES1000nitST2084 3
  // TONEMAPPER_OUTPUT_ACES2000nitST2084 4
  // TONEMAPPER_OUTPUT_ACES1000nitScRGB 5
  // TONEMAPPER_OUTPUT_ACES2000nitScRGB 6
  // TONEMAPPER_OUTPUT_LinearEXR 7
  // TONEMAPPER_OUTPUT_NoToneCurve 8
  // TONEMAPPER_OUTPUT_WithToneCurve 9

  uint _1078 = cb0_40w;

  bool _1079 = (_1078 == 0);
  if (_1079) {  // TONEMAPPER_OUTPUT_sRGB
    uint _1082 = cb1_20x;
    bool _1083 = (_1082 == 0);
    _1116 = _1074;
    _1117 = _1075;
    _1118 = _1076;
    do {
      if (_1083) {
        float _1086 = cb1_08x;
        float _1087 = cb1_08y;
        float _1088 = cb1_08z;
        float _1090 = cb1_09x;
        float _1091 = cb1_09y;
        float _1092 = cb1_09z;
        float _1094 = cb1_10x;
        float _1095 = cb1_10y;
        float _1096 = cb1_10z;
        float _1097 = _1086 * _1074;
        float _1098 = mad(_1087, _1075, _1097);
        float _1099 = mad(_1088, _1076, _1098);
        float _1100 = _1090 * _1074;
        float _1101 = mad(_1091, _1075, _1100);
        float _1102 = mad(_1092, _1076, _1101);
        float _1103 = _1094 * _1074;
        float _1104 = mad(_1095, _1075, _1103);
        float _1105 = mad(_1096, _1076, _1104);
        float _1106 = _1099 * _39;
        float _1107 = mad(_40, _1102, _1106);
        float _1108 = mad(_41, _1105, _1107);
        float _1109 = _1099 * _42;
        float _1110 = mad(_43, _1102, _1109);
        float _1111 = mad(_44, _1105, _1110);
        float _1112 = _1099 * _45;
        float _1113 = mad(_46, _1102, _1112);
        float _1114 = mad(_47, _1105, _1113);
        _1116 = _1108;
        _1117 = _1111;
        _1118 = _1114;
      }

      // Linear=>SRGB
      bool _1119 = (_1116 < 0.0031306699384003878f);
      do {
        if (_1119) {
          float _1121 = _1116 * 12.920000076293945f;
          _1129 = _1121;
        } else {
          float _1123 = log2(_1116);
          float _1124 = _1123 * 0.4166666567325592f;
          float _1125 = exp2(_1124);
          float _1126 = _1125 * 1.0549999475479126f;
          float _1127 = _1126 + -0.054999999701976776f;
          _1129 = _1127;
        }
        bool _1130 = (_1117 < 0.0031306699384003878f);
        do {
          if (_1130) {
            float _1132 = _1117 * 12.920000076293945f;
            _1140 = _1132;
          } else {
            float _1134 = log2(_1117);
            float _1135 = _1134 * 0.4166666567325592f;
            float _1136 = exp2(_1135);
            float _1137 = _1136 * 1.0549999475479126f;
            float _1138 = _1137 + -0.054999999701976776f;
            _1140 = _1138;
          }
          bool _1141 = (_1118 < 0.0031306699384003878f);
          if (_1141) {
            float _1143 = _1118 * 12.920000076293945f;
            _2500 = _1129;
            _2501 = _1140;
            _2502 = _1143;
          } else {
            float _1145 = log2(_1118);
            float _1146 = _1145 * 0.4166666567325592f;
            float _1147 = exp2(_1146);
            float _1148 = _1147 * 1.0549999475479126f;
            float _1149 = _1148 + -0.054999999701976776f;
            _2500 = _1129;
            _2501 = _1140;
            _2502 = _1149;
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    bool _1151 = (_1078 == 1);
    if (_1151) {  // TONEMAPPER_OUTPUT_Rec709
      float _1154 = cb1_08x;
      float _1155 = cb1_08y;
      float _1156 = cb1_08z;
      float _1158 = cb1_09x;
      float _1159 = cb1_09y;
      float _1160 = cb1_09z;
      float _1162 = cb1_10x;
      float _1163 = cb1_10y;
      float _1164 = cb1_10z;
      float _1165 = _1154 * _1074;
      float _1166 = mad(_1155, _1075, _1165);
      float _1167 = mad(_1156, _1076, _1166);
      float _1168 = _1158 * _1074;
      float _1169 = mad(_1159, _1075, _1168);
      float _1170 = mad(_1160, _1076, _1169);
      float _1171 = _1162 * _1074;
      float _1172 = mad(_1163, _1075, _1171);
      float _1173 = mad(_1164, _1076, _1172);
      float _1174 = _1167 * _39;
      float _1175 = mad(_40, _1170, _1174);
      float _1176 = mad(_41, _1173, _1175);
      float _1177 = _1167 * _42;
      float _1178 = mad(_43, _1170, _1177);
      float _1179 = mad(_44, _1173, _1178);
      float _1180 = _1167 * _45;
      float _1181 = mad(_46, _1170, _1180);
      float _1182 = mad(_47, _1173, _1181);
      float _1183 = max(6.103519990574569e-05f, _1176);
      float _1184 = max(6.103519990574569e-05f, _1179);
      float _1185 = max(6.103519990574569e-05f, _1182);
      float _1186 = max(_1183, 0.017999999225139618f);
      float _1187 = max(_1184, 0.017999999225139618f);
      float _1188 = max(_1185, 0.017999999225139618f);
      float _1189 = log2(_1186);
      float _1190 = log2(_1187);
      float _1191 = log2(_1188);
      float _1192 = _1189 * 0.44999998807907104f;
      float _1193 = _1190 * 0.44999998807907104f;
      float _1194 = _1191 * 0.44999998807907104f;
      float _1195 = exp2(_1192);
      float _1196 = exp2(_1193);
      float _1197 = exp2(_1194);
      float _1198 = _1195 * 1.0989999771118164f;
      float _1199 = _1196 * 1.0989999771118164f;
      float _1200 = _1197 * 1.0989999771118164f;
      float _1201 = _1198 + -0.0989999994635582f;
      float _1202 = _1199 + -0.0989999994635582f;
      float _1203 = _1200 + -0.0989999994635582f;
      float _1204 = _1183 * 4.5f;
      float _1205 = _1184 * 4.5f;
      float _1206 = _1185 * 4.5f;
      float _1207 = min(_1204, _1201);
      float _1208 = min(_1205, _1202);
      float _1209 = min(_1206, _1203);
      _2500 = _1207;
      _2501 = _1208;
      _2502 = _1209;
    } else {
      bool _1211 = (_1078 == 3);  // TONEMAPPER_OUTPUT_ACES1000nitST2084
      bool _1212 = (_1078 == 5);  // TONEMAPPER_OUTPUT_ACES1000nitScRGB
      bool _1213 = _1211 || _1212;
      if (_1213) {
        //   %1215 = bitcast [6 x float]* %12 to i8*
        //   %1216 = bitcast [6 x float]* %13 to i8*
        float _1218 = cb0_12z;
        float _1219 = cb0_12y;
        float _1220 = cb0_12x;
        float _1222 = cb0_11x;
        float _1223 = cb0_11y;
        float _1224 = cb0_11z;
        float _1225 = cb0_11w;
        float _1227 = cb0_10x;
        float _1228 = cb0_10y;
        float _1229 = cb0_10z;
        float _1230 = cb0_10w;
        float _1232 = cb0_09x;
        float _1234 = cb0_08x;
        float _1235 = cb0_08y;
        float _1236 = cb0_08z;
        float _1237 = cb0_08w;
        _12[0] = _1227;
        _12[1] = _1228;
        _12[2] = _1229;
        _12[3] = _1230;
        _12[4] = _1220;
        _12[5] = _1220;
        _13[0] = _1222;
        _13[1] = _1223;
        _13[2] = _1224;
        _13[3] = _1225;
        _13[4] = _1219;
        _13[5] = _1219;
        float _1251 = cb1_16x;
        float _1252 = cb1_16y;
        float _1253 = cb1_16z;
        float _1255 = cb1_17x;
        float _1256 = cb1_17y;
        float _1257 = cb1_17z;
        float _1259 = cb1_18x;
        float _1260 = cb1_18y;
        float _1261 = cb1_18z;
        float _1262 = _1218 * _1060;
        float _1263 = _1218 * _1061;
        float _1264 = _1218 * _1062;
        float _1265 = _1251 * _1262;
        float _1266 = mad(_1252, _1263, _1265);
        float _1267 = mad(_1253, _1264, _1266);
        float _1268 = _1255 * _1262;
        float _1269 = mad(_1256, _1263, _1268);
        float _1270 = mad(_1257, _1264, _1269);
        float _1271 = _1259 * _1262;
        float _1272 = mad(_1260, _1263, _1271);
        float _1273 = mad(_1261, _1264, _1272);
        float _1274 = min(_1267, _1270);
        float _1275 = min(_1274, _1273);
        float _1276 = max(_1267, _1270);
        float _1277 = max(_1276, _1273);
        float _1278 = max(_1277, 1.000000013351432e-10f);
        float _1279 = max(_1275, 1.000000013351432e-10f);
        float _1280 = _1278 - _1279;
        float _1281 = max(_1277, 0.009999999776482582f);
        float _1282 = _1280 / _1281;
        float _1283 = _1273 - _1270;
        float _1284 = _1283 * _1273;
        float _1285 = _1270 - _1267;
        float _1286 = _1285 * _1270;
        float _1287 = _1284 + _1286;
        float _1288 = _1267 - _1273;
        float _1289 = _1288 * _1267;
        float _1290 = _1287 + _1289;
        float _1291 = sqrt(_1290);
        float _1292 = _1291 * 1.75f;
        float _1293 = _1270 + _1267;
        float _1294 = _1293 + _1273;
        float _1295 = _1294 + _1292;
        float _1296 = _1295 * 0.3333333432674408f;
        float _1297 = _1282 + -0.4000000059604645f;
        float _1298 = _1297 * 5.0f;
        float _1299 = _1297 * 2.5f;
        float _1300 = abs(_1299);
        float _1301 = 1.0f - _1300;
        float _1302 = max(_1301, 0.0f);
        bool _1303 = (_1298 > 0.0f);
        bool _1304 = (_1298 < 0.0f);
        int _1305 = int(_1303);
        int _1306 = int(_1304);
        int _1307 = _1305 - _1306;
        float _1308 = float(_1307);
        float _1309 = _1302 * _1302;
        float _1310 = 1.0f - _1309;
        float _1311 = _1308 * _1310;
        float _1312 = _1311 + 1.0f;
        float _1313 = _1312 * 0.02500000037252903f;
        bool _1314 = !(_1296 <= 0.0533333346247673f);
        _1322 = _1313;
        do {
          if (_1314) {
            bool _1316 = !(_1296 >= 0.1599999964237213f);
            _1322 = 0.0f;
            if (_1316) {
              float _1318 = 0.23999999463558197f / _1295;
              float _1319 = _1318 + -0.5f;
              float _1320 = _1319 * _1313;
              _1322 = _1320;
            }
          }
          float _1323 = _1322 + 1.0f;
          float _1324 = _1323 * _1267;
          float _1325 = _1323 * _1270;
          float _1326 = _1323 * _1273;
          bool _1327 = (_1324 == _1325);
          bool _1328 = (_1325 == _1326);
          bool _1329 = _1327 && _1328;
          _1358 = 0.0f;
          do {
            if (!_1329) {
              float _1331 = _1324 * 2.0f;
              float _1332 = _1331 - _1325;
              float _1333 = _1332 - _1326;
              float _1334 = _1270 - _1273;
              float _1335 = _1334 * 1.7320507764816284f;
              float _1336 = _1335 * _1323;
              float _1337 = _1336 / _1333;
              float _1338 = atan(_1337);
              float _1339 = _1338 + 3.1415927410125732f;
              float _1340 = _1338 + -3.1415927410125732f;
              bool _1341 = (_1333 < 0.0f);
              bool _1342 = (_1333 == 0.0f);
              bool _1343 = (_1336 >= 0.0f);
              bool _1344 = (_1336 < 0.0f);
              bool _1345 = _1343 && _1341;
              float _1346 = _1345 ? _1339 : _1338;
              bool _1347 = _1344 && _1341;
              float _1348 = _1347 ? _1340 : _1346;
              bool _1349 = _1344 && _1342;
              bool _1350 = _1343 && _1342;
              float _1351 = _1348 * 57.2957763671875f;
              float _1352 = _1349 ? -90.0f : _1351;
              float _1353 = _1350 ? 90.0f : _1352;
              bool _1354 = (_1353 < 0.0f);
              _1358 = _1353;
              if (_1354) {
                float _1356 = _1353 + 360.0f;
                _1358 = _1356;
              }
            }
            float _1359 = max(_1358, 0.0f);
            float _1360 = min(_1359, 360.0f);
            bool _1361 = (_1360 < -180.0f);
            do {
              if (_1361) {
                float _1363 = _1360 + 360.0f;
                _1369 = _1363;
              } else {
                bool _1365 = (_1360 > 180.0f);
                _1369 = _1360;
                if (_1365) {
                  float _1367 = _1360 + -360.0f;
                  _1369 = _1367;
                }
              }
              bool _1370 = (_1369 > -67.5f);
              bool _1371 = (_1369 < 67.5f);
              bool _1372 = _1370 && _1371;
              _1408 = 0.0f;
              do {
                if (_1372) {
                  float _1374 = _1369 + 67.5f;
                  float _1375 = _1374 * 0.029629629105329514f;
                  int _1376 = int(_1375);
                  float _1377 = float(_1376);
                  float _1378 = _1375 - _1377;
                  float _1379 = _1378 * _1378;
                  float _1380 = _1379 * _1378;
                  bool _1381 = (_1376 == 3);
                  if (_1381) {
                    float _1383 = _1380 * 0.1666666716337204f;
                    float _1384 = _1379 * 0.5f;
                    float _1385 = _1378 * 0.5f;
                    float _1386 = 0.1666666716337204f - _1385;
                    float _1387 = _1386 + _1384;
                    float _1388 = _1387 - _1383;
                    _1408 = _1388;
                  } else {
                    bool _1390 = (_1376 == 2);
                    if (_1390) {
                      float _1392 = _1380 * 0.5f;
                      float _1393 = 0.6666666865348816f - _1379;
                      float _1394 = _1393 + _1392;
                      _1408 = _1394;
                    } else {
                      bool _1396 = (_1376 == 1);
                      if (_1396) {
                        float _1398 = _1380 * -0.5f;
                        float _1399 = _1379 + _1378;
                        float _1400 = _1399 * 0.5f;
                        float _1401 = _1398 + 0.1666666716337204f;
                        float _1402 = _1401 + _1400;
                        _1408 = _1402;
                      } else {
                        bool _1404 = (_1376 == 0);
                        float _1405 = _1380 * 0.1666666716337204f;
                        float _1406 = _1404 ? _1405 : 0.0f;
                        _1408 = _1406;
                      }
                    }
                  }
                }
                float _1409 = 0.029999999329447746f - _1324;
                float _1410 = _1282 * 0.27000001072883606f;
                float _1411 = _1410 * _1409;
                float _1412 = _1411 * _1408;
                float _1413 = _1412 + _1324;
                float _1414 = max(_1413, 0.0f);
                float _1415 = max(_1325, 0.0f);
                float _1416 = max(_1326, 0.0f);
                float _1417 = min(_1414, 65535.0f);
                float _1418 = min(_1415, 65535.0f);
                float _1419 = min(_1416, 65535.0f);
                float _1420 = _1417 * 1.4514392614364624f;
                float _1421 = mad(-0.2365107536315918f, _1418, _1420);
                float _1422 = mad(-0.21492856740951538f, _1419, _1421);
                float _1423 = _1417 * -0.07655377686023712f;
                float _1424 = mad(1.17622971534729f, _1418, _1423);
                float _1425 = mad(-0.09967592358589172f, _1419, _1424);
                float _1426 = _1417 * 0.008316148072481155f;
                float _1427 = mad(-0.006032449658960104f, _1418, _1426);
                float _1428 = mad(0.9977163076400757f, _1419, _1427);
                float _1429 = max(_1422, 0.0f);
                float _1430 = max(_1425, 0.0f);
                float _1431 = max(_1428, 0.0f);
                float _1432 = min(_1429, 65504.0f);
                float _1433 = min(_1430, 65504.0f);
                float _1434 = min(_1431, 65504.0f);
                float _1435 = dot(float3(_1432, _1433, _1434),
                                  float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _1436 = _1432 - _1435;
                float _1437 = _1433 - _1435;
                float _1438 = _1434 - _1435;
                float _1439 = _1436 * 0.9599999785423279f;
                float _1440 = _1437 * 0.9599999785423279f;
                float _1441 = _1438 * 0.9599999785423279f;
                float _1442 = _1439 + _1435;
                float _1443 = _1440 + _1435;
                float _1444 = _1441 + _1435;
                float _1445 = max(_1442, 1.000000013351432e-10f);
                float _1446 = log2(_1445);
                float _1447 = _1446 * 0.3010300099849701f;
                float _1448 = log2(_1234);
                float _1449 = _1448 * 0.3010300099849701f;
                bool _1450 = !(_1447 <= _1449);
                do {
                  if (!_1450) {
                    float _1452 = log2(_1235);
                    float _1453 = _1452 * 0.3010300099849701f;
                    _1518 = _1453;
                  } else {
                    bool _1455 = (_1447 > _1449);
                    float _1456 = log2(_1232);
                    float _1457 = _1456 * 0.3010300099849701f;
                    bool _1458 = (_1447 < _1457);
                    bool _1459 = _1455 && _1458;
                    if (_1459) {
                      float _1461 = _1446 - _1448;
                      float _1462 = _1461 * 0.9030900001525879f;
                      float _1463 = _1456 - _1448;
                      float _1464 = _1463 * 0.3010300099849701f;
                      float _1465 = _1462 / _1464;
                      int _1466 = int(_1465);
                      float _1467 = float(_1466);
                      float _1468 = _1465 - _1467;
                      float _1470 = _12[_1466];
                      int _1471 = _1466 + 1;
                      float _1473 = _12[_1471];
                      int _1474 = _1466 + 2;
                      float _1476 = _12[_1474];
                      float _1477 = _1468 * _1468;
                      float _1478 = _1470 * 0.5f;
                      float _1479 = mad(_1473, -1.0f, _1478);
                      float _1480 = mad(_1476, 0.5f, _1479);
                      float _1481 = _1473 - _1470;
                      float _1482 = mad(_1473, 0.5f, _1478);
                      float _1483 = dot(float3(_1477, _1468, 1.0f), float3(_1480, _1481, _1482));
                      _1518 = _1483;
                    } else {
                      bool _1485 = !(_1447 >= _1457);
                      do {
                        if (!_1485) {
                          float _1487 = log2(_1236);
                          float _1488 = _1487 * 0.3010300099849701f;
                          bool _1489 = (_1447 < _1488);
                          if (_1489) {
                            float _1491 = _1446 - _1456;
                            float _1492 = _1491 * 0.9030900001525879f;
                            float _1493 = _1487 - _1456;
                            float _1494 = _1493 * 0.3010300099849701f;
                            float _1495 = _1492 / _1494;
                            int _1496 = int(_1495);
                            float _1497 = float(_1496);
                            float _1498 = _1495 - _1497;
                            float _1500 = _13[_1496];
                            int _1501 = _1496 + 1;
                            float _1503 = _13[_1501];
                            int _1504 = _1496 + 2;
                            float _1506 = _13[_1504];
                            float _1507 = _1498 * _1498;
                            float _1508 = _1500 * 0.5f;
                            float _1509 = mad(_1503, -1.0f, _1508);
                            float _1510 = mad(_1506, 0.5f, _1509);
                            float _1511 = _1503 - _1500;
                            float _1512 = mad(_1503, 0.5f, _1508);
                            float _1513 = dot(float3(_1507, _1498, 1.0f), float3(_1510, _1511, _1512));
                            _1518 = _1513;
                            break;
                          }
                        }
                        float _1515 = log2(_1237);
                        float _1516 = _1515 * 0.3010300099849701f;
                        _1518 = _1516;
                      } while (false);
                    }
                  }
                  float _1519 = _1518 * 3.321928024291992f;
                  float _1520 = exp2(_1519);
                  float _1521 = max(_1443, 1.000000013351432e-10f);
                  float _1522 = log2(_1521);
                  float _1523 = _1522 * 0.3010300099849701f;
                  bool _1524 = !(_1523 <= _1449);
                  do {
                    if (!_1524) {
                      float _1526 = log2(_1235);
                      float _1527 = _1526 * 0.3010300099849701f;
                      _1592 = _1527;
                    } else {
                      bool _1529 = (_1523 > _1449);
                      float _1530 = log2(_1232);
                      float _1531 = _1530 * 0.3010300099849701f;
                      bool _1532 = (_1523 < _1531);
                      bool _1533 = _1529 && _1532;
                      if (_1533) {
                        float _1535 = _1522 - _1448;
                        float _1536 = _1535 * 0.9030900001525879f;
                        float _1537 = _1530 - _1448;
                        float _1538 = _1537 * 0.3010300099849701f;
                        float _1539 = _1536 / _1538;
                        int _1540 = int(_1539);
                        float _1541 = float(_1540);
                        float _1542 = _1539 - _1541;
                        float _1544 = _12[_1540];
                        int _1545 = _1540 + 1;
                        float _1547 = _12[_1545];
                        int _1548 = _1540 + 2;
                        float _1550 = _12[_1548];
                        float _1551 = _1542 * _1542;
                        float _1552 = _1544 * 0.5f;
                        float _1553 = mad(_1547, -1.0f, _1552);
                        float _1554 = mad(_1550, 0.5f, _1553);
                        float _1555 = _1547 - _1544;
                        float _1556 = mad(_1547, 0.5f, _1552);
                        float _1557 = dot(float3(_1551, _1542, 1.0f), float3(_1554, _1555, _1556));
                        _1592 = _1557;
                      } else {
                        bool _1559 = !(_1523 >= _1531);
                        do {
                          if (!_1559) {
                            float _1561 = log2(_1236);
                            float _1562 = _1561 * 0.3010300099849701f;
                            bool _1563 = (_1523 < _1562);
                            if (_1563) {
                              float _1565 = _1522 - _1530;
                              float _1566 = _1565 * 0.9030900001525879f;
                              float _1567 = _1561 - _1530;
                              float _1568 = _1567 * 0.3010300099849701f;
                              float _1569 = _1566 / _1568;
                              int _1570 = int(_1569);
                              float _1571 = float(_1570);
                              float _1572 = _1569 - _1571;
                              float _1574 = _13[_1570];
                              int _1575 = _1570 + 1;
                              float _1577 = _13[_1575];
                              int _1578 = _1570 + 2;
                              float _1580 = _13[_1578];
                              float _1581 = _1572 * _1572;
                              float _1582 = _1574 * 0.5f;
                              float _1583 = mad(_1577, -1.0f, _1582);
                              float _1584 = mad(_1580, 0.5f, _1583);
                              float _1585 = _1577 - _1574;
                              float _1586 = mad(_1577, 0.5f, _1582);
                              float _1587 = dot(float3(_1581, _1572, 1.0f), float3(_1584, _1585, _1586));
                              _1592 = _1587;
                              break;
                            }
                          }
                          float _1589 = log2(_1237);
                          float _1590 = _1589 * 0.3010300099849701f;
                          _1592 = _1590;
                        } while (false);
                      }
                    }
                    float _1593 = _1592 * 3.321928024291992f;
                    float _1594 = exp2(_1593);
                    float _1595 = max(_1444, 1.000000013351432e-10f);
                    float _1596 = log2(_1595);
                    float _1597 = _1596 * 0.3010300099849701f;
                    bool _1598 = !(_1597 <= _1449);
                    do {
                      if (!_1598) {
                        float _1600 = log2(_1235);
                        float _1601 = _1600 * 0.3010300099849701f;
                        _1666 = _1601;
                      } else {
                        bool _1603 = (_1597 > _1449);
                        float _1604 = log2(_1232);
                        float _1605 = _1604 * 0.3010300099849701f;
                        bool _1606 = (_1597 < _1605);
                        bool _1607 = _1603 && _1606;
                        if (_1607) {
                          float _1609 = _1596 - _1448;
                          float _1610 = _1609 * 0.9030900001525879f;
                          float _1611 = _1604 - _1448;
                          float _1612 = _1611 * 0.3010300099849701f;
                          float _1613 = _1610 / _1612;
                          int _1614 = int(_1613);
                          float _1615 = float(_1614);
                          float _1616 = _1613 - _1615;
                          float _1618 = _12[_1614];
                          int _1619 = _1614 + 1;
                          float _1621 = _12[_1619];
                          int _1622 = _1614 + 2;
                          float _1624 = _12[_1622];
                          float _1625 = _1616 * _1616;
                          float _1626 = _1618 * 0.5f;
                          float _1627 = mad(_1621, -1.0f, _1626);
                          float _1628 = mad(_1624, 0.5f, _1627);
                          float _1629 = _1621 - _1618;
                          float _1630 = mad(_1621, 0.5f, _1626);
                          float _1631 = dot(float3(_1625, _1616, 1.0f), float3(_1628, _1629, _1630));
                          _1666 = _1631;
                        } else {
                          bool _1633 = !(_1597 >= _1605);
                          do {
                            if (!_1633) {
                              float _1635 = log2(_1236);
                              float _1636 = _1635 * 0.3010300099849701f;
                              bool _1637 = (_1597 < _1636);
                              if (_1637) {
                                float _1639 = _1596 - _1604;
                                float _1640 = _1639 * 0.9030900001525879f;
                                float _1641 = _1635 - _1604;
                                float _1642 = _1641 * 0.3010300099849701f;
                                float _1643 = _1640 / _1642;
                                int _1644 = int(_1643);
                                float _1645 = float(_1644);
                                float _1646 = _1643 - _1645;
                                float _1648 = _13[_1644];
                                int _1649 = _1644 + 1;
                                float _1651 = _13[_1649];
                                int _1652 = _1644 + 2;
                                float _1654 = _13[_1652];
                                float _1655 = _1646 * _1646;
                                float _1656 = _1648 * 0.5f;
                                float _1657 = mad(_1651, -1.0f, _1656);
                                float _1658 = mad(_1654, 0.5f, _1657);
                                float _1659 = _1651 - _1648;
                                float _1660 = mad(_1651, 0.5f, _1656);
                                float _1661 = dot(float3(_1655, _1646, 1.0f), float3(_1658, _1659, _1660));
                                _1666 = _1661;
                                break;
                              }
                            }
                            float _1663 = log2(_1237);
                            float _1664 = _1663 * 0.3010300099849701f;
                            _1666 = _1664;
                          } while (false);
                        }
                      }
                      float _1667 = _1666 * 3.321928024291992f;
                      float _1668 = exp2(_1667);
                      float _1669 = _1520 - _1235;
                      float _1670 = _1237 - _1235;
                      float _1671 = _1669 / _1670;
                      float _1672 = _1594 - _1235;
                      float _1673 = _1672 / _1670;
                      float _1674 = _1668 - _1235;
                      float _1675 = _1674 / _1670;
                      float _1676 = _1671 * 0.6624541878700256f;
                      float _1677 = mad(0.13400420546531677f, _1673, _1676);
                      float _1678 = mad(0.15618768334388733f, _1675, _1677);
                      float _1679 = _1671 * 0.2722287178039551f;
                      float _1680 = mad(0.6740817427635193f, _1673, _1679);
                      float _1681 = mad(0.053689517080783844f, _1675, _1680);
                      float _1682 = _1671 * -0.005574649665504694f;
                      float _1683 = mad(0.00406073359772563f, _1673, _1682);
                      float _1684 = mad(1.0103391408920288f, _1675, _1683);
                      float _1685 = _1678 * 1.6410233974456787f;
                      float _1686 = mad(-0.32480329275131226f, _1681, _1685);
                      float _1687 = mad(-0.23642469942569733f, _1684, _1686);
                      float _1688 = _1678 * -0.663662850856781f;
                      float _1689 = mad(1.6153316497802734f, _1681, _1688);
                      float _1690 = mad(0.016756348311901093f, _1684, _1689);
                      float _1691 = _1678 * 0.011721894145011902f;
                      float _1692 = mad(-0.008284442126750946f, _1681, _1691);
                      float _1693 = mad(0.9883948564529419f, _1684, _1692);
                      float _1694 = max(_1687, 0.0f);
                      float _1695 = max(_1690, 0.0f);
                      float _1696 = max(_1693, 0.0f);
                      float _1697 = min(_1694, 1.0f);
                      float _1698 = min(_1695, 1.0f);
                      float _1699 = min(_1696, 1.0f);
                      float _1700 = _1697 * 0.6624541878700256f;
                      float _1701 = mad(0.13400420546531677f, _1698, _1700);
                      float _1702 = mad(0.15618768334388733f, _1699, _1701);
                      float _1703 = _1697 * 0.2722287178039551f;
                      float _1704 = mad(0.6740817427635193f, _1698, _1703);
                      float _1705 = mad(0.053689517080783844f, _1699, _1704);
                      float _1706 = _1697 * -0.005574649665504694f;
                      float _1707 = mad(0.00406073359772563f, _1698, _1706);
                      float _1708 = mad(1.0103391408920288f, _1699, _1707);
                      float _1709 = _1702 * 1.6410233974456787f;
                      float _1710 = mad(-0.32480329275131226f, _1705, _1709);
                      float _1711 = mad(-0.23642469942569733f, _1708, _1710);
                      float _1712 = _1702 * -0.663662850856781f;
                      float _1713 = mad(1.6153316497802734f, _1705, _1712);
                      float _1714 = mad(0.016756348311901093f, _1708, _1713);
                      float _1715 = _1702 * 0.011721894145011902f;
                      float _1716 = mad(-0.008284442126750946f, _1705, _1715);
                      float _1717 = mad(0.9883948564529419f, _1708, _1716);
                      float _1718 = max(_1711, 0.0f);
                      float _1719 = max(_1714, 0.0f);
                      float _1720 = max(_1717, 0.0f);
                      float _1721 = min(_1718, 65535.0f);
                      float _1722 = min(_1719, 65535.0f);
                      float _1723 = min(_1720, 65535.0f);
                      float _1724 = _1721 * _1237;
                      float _1725 = _1722 * _1237;
                      float _1726 = _1723 * _1237;
                      float _1727 = max(_1724, 0.0f);
                      float _1728 = max(_1725, 0.0f);
                      float _1729 = max(_1726, 0.0f);
                      float _1730 = min(_1727, 65535.0f);
                      float _1731 = min(_1728, 65535.0f);
                      float _1732 = min(_1729, 65535.0f);
                      bool _1733 = (_1078 == 5);
                      _1745 = _1730;
                      _1746 = _1731;
                      _1747 = _1732;
                      do {
                        if (!_1733) {
                          float _1735 = _1730 * _39;
                          float _1736 = mad(_40, _1731, _1735);
                          float _1737 = mad(_41, _1732, _1736);
                          float _1738 = _1730 * _42;
                          float _1739 = mad(_43, _1731, _1738);
                          float _1740 = mad(_44, _1732, _1739);
                          float _1741 = _1730 * _45;
                          float _1742 = mad(_46, _1731, _1741);
                          float _1743 = mad(_47, _1732, _1742);
                          _1745 = _1737;
                          _1746 = _1740;
                          _1747 = _1743;
                        }
                        float _1748 = _1745 * 9.999999747378752e-05f;
                        float _1749 = _1746 * 9.999999747378752e-05f;
                        float _1750 = _1747 * 9.999999747378752e-05f;
                        float _1751 = log2(_1748);
                        float _1752 = log2(_1749);
                        float _1753 = log2(_1750);
                        float _1754 = _1751 * 0.1593017578125f;
                        float _1755 = _1752 * 0.1593017578125f;
                        float _1756 = _1753 * 0.1593017578125f;
                        float _1757 = exp2(_1754);
                        float _1758 = exp2(_1755);
                        float _1759 = exp2(_1756);
                        float _1760 = _1757 * 18.8515625f;
                        float _1761 = _1758 * 18.8515625f;
                        float _1762 = _1759 * 18.8515625f;
                        float _1763 = _1760 + 0.8359375f;
                        float _1764 = _1761 + 0.8359375f;
                        float _1765 = _1762 + 0.8359375f;
                        float _1766 = _1757 * 18.6875f;
                        float _1767 = _1758 * 18.6875f;
                        float _1768 = _1759 * 18.6875f;
                        float _1769 = _1766 + 1.0f;
                        float _1770 = _1767 + 1.0f;
                        float _1771 = _1768 + 1.0f;
                        float _1772 = 1.0f / _1769;
                        float _1773 = 1.0f / _1770;
                        float _1774 = 1.0f / _1771;
                        float _1775 = _1772 * _1763;
                        float _1776 = _1773 * _1764;
                        float _1777 = _1774 * _1765;
                        float _1778 = log2(_1775);
                        float _1779 = log2(_1776);
                        float _1780 = log2(_1777);
                        float _1781 = _1778 * 78.84375f;
                        float _1782 = _1779 * 78.84375f;
                        float _1783 = _1780 * 78.84375f;
                        float _1784 = exp2(_1781);
                        float _1785 = exp2(_1782);
                        float _1786 = exp2(_1783);
                        _2500 = _1784;
                        _2501 = _1785;
                        _2502 = _1786;
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } else {
        int _1788 = _1078 & -3;
        bool _1789 = (_1788 == 4);
        if (_1789) {  // TONEMAPPER_OUTPUT_ACES2000nitST2084 |
                      // TONEMAPPER_OUTPUT_ACES2000nitScRGB
          //   %1791 = bitcast [6 x float]* %10 to i8*
          //   %1792 = bitcast [6 x float]* %11 to i8*
          float _1794 = cb0_12z;
          float _1795 = cb0_12y;
          float _1796 = cb0_12x;
          float _1798 = cb0_11x;
          float _1799 = cb0_11y;
          float _1800 = cb0_11z;
          float _1801 = cb0_11w;
          float _1803 = cb0_10x;
          float _1804 = cb0_10y;
          float _1805 = cb0_10z;
          float _1806 = cb0_10w;
          float _1808 = cb0_09x;
          float _1810 = cb0_08x;
          float _1811 = cb0_08y;
          float _1812 = cb0_08z;
          float _1813 = cb0_08w;
          _10[0] = _1803;
          _10[1] = _1804;
          _10[2] = _1805;
          _10[3] = _1806;
          _10[4] = _1796;
          _10[5] = _1796;
          _11[0] = _1798;
          _11[1] = _1799;
          _11[2] = _1800;
          _11[3] = _1801;
          _11[4] = _1795;
          _11[5] = _1795;
          float _1827 = cb1_16x;
          float _1828 = cb1_16y;
          float _1829 = cb1_16z;
          float _1831 = cb1_17x;
          float _1832 = cb1_17y;
          float _1833 = cb1_17z;
          float _1835 = cb1_18x;
          float _1836 = cb1_18y;
          float _1837 = cb1_18z;
          float _1838 = _1794 * _1060;
          float _1839 = _1794 * _1061;
          float _1840 = _1794 * _1062;
          float _1841 = _1827 * _1838;
          float _1842 = mad(_1828, _1839, _1841);
          float _1843 = mad(_1829, _1840, _1842);
          float _1844 = _1831 * _1838;
          float _1845 = mad(_1832, _1839, _1844);
          float _1846 = mad(_1833, _1840, _1845);
          float _1847 = _1835 * _1838;
          float _1848 = mad(_1836, _1839, _1847);
          float _1849 = mad(_1837, _1840, _1848);
          float _1850 = min(_1843, _1846);
          float _1851 = min(_1850, _1849);
          float _1852 = max(_1843, _1846);
          float _1853 = max(_1852, _1849);
          float _1854 = max(_1853, 1.000000013351432e-10f);
          float _1855 = max(_1851, 1.000000013351432e-10f);
          float _1856 = _1854 - _1855;
          float _1857 = max(_1853, 0.009999999776482582f);
          float _1858 = _1856 / _1857;
          float _1859 = _1849 - _1846;
          float _1860 = _1859 * _1849;
          float _1861 = _1846 - _1843;
          float _1862 = _1861 * _1846;
          float _1863 = _1860 + _1862;
          float _1864 = _1843 - _1849;
          float _1865 = _1864 * _1843;
          float _1866 = _1863 + _1865;
          float _1867 = sqrt(_1866);
          float _1868 = _1867 * 1.75f;
          float _1869 = _1846 + _1843;
          float _1870 = _1869 + _1849;
          float _1871 = _1870 + _1868;
          float _1872 = _1871 * 0.3333333432674408f;
          float _1873 = _1858 + -0.4000000059604645f;
          float _1874 = _1873 * 5.0f;
          float _1875 = _1873 * 2.5f;
          float _1876 = abs(_1875);
          float _1877 = 1.0f - _1876;
          float _1878 = max(_1877, 0.0f);
          bool _1879 = (_1874 > 0.0f);
          bool _1880 = (_1874 < 0.0f);
          int _1881 = int(_1879);
          int _1882 = int(_1880);
          int _1883 = _1881 - _1882;
          float _1884 = float(_1883);
          float _1885 = _1878 * _1878;
          float _1886 = 1.0f - _1885;
          float _1887 = _1884 * _1886;
          float _1888 = _1887 + 1.0f;
          float _1889 = _1888 * 0.02500000037252903f;
          bool _1890 = !(_1872 <= 0.0533333346247673f);
          _1898 = _1889;
          do {
            if (_1890) {
              bool _1892 = !(_1872 >= 0.1599999964237213f);
              _1898 = 0.0f;
              if (_1892) {
                float _1894 = 0.23999999463558197f / _1871;
                float _1895 = _1894 + -0.5f;
                float _1896 = _1895 * _1889;
                _1898 = _1896;
              }
            }
            float _1899 = _1898 + 1.0f;
            float _1900 = _1899 * _1843;
            float _1901 = _1899 * _1846;
            float _1902 = _1899 * _1849;
            bool _1903 = (_1900 == _1901);
            bool _1904 = (_1901 == _1902);
            bool _1905 = _1903 && _1904;
            _1934 = 0.0f;
            do {
              if (!_1905) {
                float _1907 = _1900 * 2.0f;
                float _1908 = _1907 - _1901;
                float _1909 = _1908 - _1902;
                float _1910 = _1846 - _1849;
                float _1911 = _1910 * 1.7320507764816284f;
                float _1912 = _1911 * _1899;
                float _1913 = _1912 / _1909;
                float _1914 = atan(_1913);
                float _1915 = _1914 + 3.1415927410125732f;
                float _1916 = _1914 + -3.1415927410125732f;
                bool _1917 = (_1909 < 0.0f);
                bool _1918 = (_1909 == 0.0f);
                bool _1919 = (_1912 >= 0.0f);
                bool _1920 = (_1912 < 0.0f);
                bool _1921 = _1919 && _1917;
                float _1922 = _1921 ? _1915 : _1914;
                bool _1923 = _1920 && _1917;
                float _1924 = _1923 ? _1916 : _1922;
                bool _1925 = _1920 && _1918;
                bool _1926 = _1919 && _1918;
                float _1927 = _1924 * 57.2957763671875f;
                float _1928 = _1925 ? -90.0f : _1927;
                float _1929 = _1926 ? 90.0f : _1928;
                bool _1930 = (_1929 < 0.0f);
                _1934 = _1929;
                if (_1930) {
                  float _1932 = _1929 + 360.0f;
                  _1934 = _1932;
                }
              }
              float _1935 = max(_1934, 0.0f);
              float _1936 = min(_1935, 360.0f);
              bool _1937 = (_1936 < -180.0f);
              do {
                if (_1937) {
                  float _1939 = _1936 + 360.0f;
                  _1945 = _1939;
                } else {
                  bool _1941 = (_1936 > 180.0f);
                  _1945 = _1936;
                  if (_1941) {
                    float _1943 = _1936 + -360.0f;
                    _1945 = _1943;
                  }
                }
                bool _1946 = (_1945 > -67.5f);
                bool _1947 = (_1945 < 67.5f);
                bool _1948 = _1946 && _1947;
                _1984 = 0.0f;
                do {
                  if (_1948) {
                    float _1950 = _1945 + 67.5f;
                    float _1951 = _1950 * 0.029629629105329514f;
                    int _1952 = int(_1951);
                    float _1953 = float(_1952);
                    float _1954 = _1951 - _1953;
                    float _1955 = _1954 * _1954;
                    float _1956 = _1955 * _1954;
                    bool _1957 = (_1952 == 3);
                    if (_1957) {
                      float _1959 = _1956 * 0.1666666716337204f;
                      float _1960 = _1955 * 0.5f;
                      float _1961 = _1954 * 0.5f;
                      float _1962 = 0.1666666716337204f - _1961;
                      float _1963 = _1962 + _1960;
                      float _1964 = _1963 - _1959;
                      _1984 = _1964;
                    } else {
                      bool _1966 = (_1952 == 2);
                      if (_1966) {
                        float _1968 = _1956 * 0.5f;
                        float _1969 = 0.6666666865348816f - _1955;
                        float _1970 = _1969 + _1968;
                        _1984 = _1970;
                      } else {
                        bool _1972 = (_1952 == 1);
                        if (_1972) {
                          float _1974 = _1956 * -0.5f;
                          float _1975 = _1955 + _1954;
                          float _1976 = _1975 * 0.5f;
                          float _1977 = _1974 + 0.1666666716337204f;
                          float _1978 = _1977 + _1976;
                          _1984 = _1978;
                        } else {
                          bool _1980 = (_1952 == 0);
                          float _1981 = _1956 * 0.1666666716337204f;
                          float _1982 = _1980 ? _1981 : 0.0f;
                          _1984 = _1982;
                        }
                      }
                    }
                  }
                  float _1985 = 0.029999999329447746f - _1900;
                  float _1986 = _1858 * 0.27000001072883606f;
                  float _1987 = _1986 * _1985;
                  float _1988 = _1987 * _1984;
                  float _1989 = _1988 + _1900;
                  float _1990 = max(_1989, 0.0f);
                  float _1991 = max(_1901, 0.0f);
                  float _1992 = max(_1902, 0.0f);
                  float _1993 = min(_1990, 65535.0f);
                  float _1994 = min(_1991, 65535.0f);
                  float _1995 = min(_1992, 65535.0f);
                  float _1996 = _1993 * 1.4514392614364624f;
                  float _1997 = mad(-0.2365107536315918f, _1994, _1996);
                  float _1998 = mad(-0.21492856740951538f, _1995, _1997);
                  float _1999 = _1993 * -0.07655377686023712f;
                  float _2000 = mad(1.17622971534729f, _1994, _1999);
                  float _2001 = mad(-0.09967592358589172f, _1995, _2000);
                  float _2002 = _1993 * 0.008316148072481155f;
                  float _2003 = mad(-0.006032449658960104f, _1994, _2002);
                  float _2004 = mad(0.9977163076400757f, _1995, _2003);
                  float _2005 = max(_1998, 0.0f);
                  float _2006 = max(_2001, 0.0f);
                  float _2007 = max(_2004, 0.0f);
                  float _2008 = min(_2005, 65504.0f);
                  float _2009 = min(_2006, 65504.0f);
                  float _2010 = min(_2007, 65504.0f);
                  float _2011 = dot(float3(_2008, _2009, _2010),
                                    float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _2012 = _2008 - _2011;
                  float _2013 = _2009 - _2011;
                  float _2014 = _2010 - _2011;
                  float _2015 = _2012 * 0.9599999785423279f;
                  float _2016 = _2013 * 0.9599999785423279f;
                  float _2017 = _2014 * 0.9599999785423279f;
                  float _2018 = _2015 + _2011;
                  float _2019 = _2016 + _2011;
                  float _2020 = _2017 + _2011;
                  float _2021 = max(_2018, 1.000000013351432e-10f);
                  float _2022 = log2(_2021);
                  float _2023 = _2022 * 0.3010300099849701f;
                  float _2024 = log2(_1810);
                  float _2025 = _2024 * 0.3010300099849701f;
                  bool _2026 = !(_2023 <= _2025);
                  do {
                    if (!_2026) {
                      float _2028 = log2(_1811);
                      float _2029 = _2028 * 0.3010300099849701f;
                      _2094 = _2029;
                    } else {
                      bool _2031 = (_2023 > _2025);
                      float _2032 = log2(_1808);
                      float _2033 = _2032 * 0.3010300099849701f;
                      bool _2034 = (_2023 < _2033);
                      bool _2035 = _2031 && _2034;
                      if (_2035) {
                        float _2037 = _2022 - _2024;
                        float _2038 = _2037 * 0.9030900001525879f;
                        float _2039 = _2032 - _2024;
                        float _2040 = _2039 * 0.3010300099849701f;
                        float _2041 = _2038 / _2040;
                        int _2042 = int(_2041);
                        float _2043 = float(_2042);
                        float _2044 = _2041 - _2043;
                        float _2046 = _10[_2042];
                        int _2047 = _2042 + 1;
                        float _2049 = _10[_2047];
                        int _2050 = _2042 + 2;
                        float _2052 = _10[_2050];
                        float _2053 = _2044 * _2044;
                        float _2054 = _2046 * 0.5f;
                        float _2055 = mad(_2049, -1.0f, _2054);
                        float _2056 = mad(_2052, 0.5f, _2055);
                        float _2057 = _2049 - _2046;
                        float _2058 = mad(_2049, 0.5f, _2054);
                        float _2059 = dot(float3(_2053, _2044, 1.0f), float3(_2056, _2057, _2058));
                        _2094 = _2059;
                      } else {
                        bool _2061 = !(_2023 >= _2033);
                        do {
                          if (!_2061) {
                            float _2063 = log2(_1812);
                            float _2064 = _2063 * 0.3010300099849701f;
                            bool _2065 = (_2023 < _2064);
                            if (_2065) {
                              float _2067 = _2022 - _2032;
                              float _2068 = _2067 * 0.9030900001525879f;
                              float _2069 = _2063 - _2032;
                              float _2070 = _2069 * 0.3010300099849701f;
                              float _2071 = _2068 / _2070;
                              int _2072 = int(_2071);
                              float _2073 = float(_2072);
                              float _2074 = _2071 - _2073;
                              float _2076 = _11[_2072];
                              int _2077 = _2072 + 1;
                              float _2079 = _11[_2077];
                              int _2080 = _2072 + 2;
                              float _2082 = _11[_2080];
                              float _2083 = _2074 * _2074;
                              float _2084 = _2076 * 0.5f;
                              float _2085 = mad(_2079, -1.0f, _2084);
                              float _2086 = mad(_2082, 0.5f, _2085);
                              float _2087 = _2079 - _2076;
                              float _2088 = mad(_2079, 0.5f, _2084);
                              float _2089 = dot(float3(_2083, _2074, 1.0f), float3(_2086, _2087, _2088));
                              _2094 = _2089;
                              break;
                            }
                          }
                          float _2091 = log2(_1813);
                          float _2092 = _2091 * 0.3010300099849701f;
                          _2094 = _2092;
                        } while (false);
                      }
                    }
                    float _2095 = _2094 * 3.321928024291992f;
                    float _2096 = exp2(_2095);
                    float _2097 = max(_2019, 1.000000013351432e-10f);
                    float _2098 = log2(_2097);
                    float _2099 = _2098 * 0.3010300099849701f;
                    bool _2100 = !(_2099 <= _2025);
                    do {
                      if (!_2100) {
                        float _2102 = log2(_1811);
                        float _2103 = _2102 * 0.3010300099849701f;
                        _2168 = _2103;
                      } else {
                        bool _2105 = (_2099 > _2025);
                        float _2106 = log2(_1808);
                        float _2107 = _2106 * 0.3010300099849701f;
                        bool _2108 = (_2099 < _2107);
                        bool _2109 = _2105 && _2108;
                        if (_2109) {
                          float _2111 = _2098 - _2024;
                          float _2112 = _2111 * 0.9030900001525879f;
                          float _2113 = _2106 - _2024;
                          float _2114 = _2113 * 0.3010300099849701f;
                          float _2115 = _2112 / _2114;
                          int _2116 = int(_2115);
                          float _2117 = float(_2116);
                          float _2118 = _2115 - _2117;
                          float _2120 = _10[_2116];
                          int _2121 = _2116 + 1;
                          float _2123 = _10[_2121];
                          int _2124 = _2116 + 2;
                          float _2126 = _10[_2124];
                          float _2127 = _2118 * _2118;
                          float _2128 = _2120 * 0.5f;
                          float _2129 = mad(_2123, -1.0f, _2128);
                          float _2130 = mad(_2126, 0.5f, _2129);
                          float _2131 = _2123 - _2120;
                          float _2132 = mad(_2123, 0.5f, _2128);
                          float _2133 = dot(float3(_2127, _2118, 1.0f), float3(_2130, _2131, _2132));
                          _2168 = _2133;
                        } else {
                          bool _2135 = !(_2099 >= _2107);
                          do {
                            if (!_2135) {
                              float _2137 = log2(_1812);
                              float _2138 = _2137 * 0.3010300099849701f;
                              bool _2139 = (_2099 < _2138);
                              if (_2139) {
                                float _2141 = _2098 - _2106;
                                float _2142 = _2141 * 0.9030900001525879f;
                                float _2143 = _2137 - _2106;
                                float _2144 = _2143 * 0.3010300099849701f;
                                float _2145 = _2142 / _2144;
                                int _2146 = int(_2145);
                                float _2147 = float(_2146);
                                float _2148 = _2145 - _2147;
                                float _2150 = _11[_2146];
                                int _2151 = _2146 + 1;
                                float _2153 = _11[_2151];
                                int _2154 = _2146 + 2;
                                float _2156 = _11[_2154];
                                float _2157 = _2148 * _2148;
                                float _2158 = _2150 * 0.5f;
                                float _2159 = mad(_2153, -1.0f, _2158);
                                float _2160 = mad(_2156, 0.5f, _2159);
                                float _2161 = _2153 - _2150;
                                float _2162 = mad(_2153, 0.5f, _2158);
                                float _2163 = dot(float3(_2157, _2148, 1.0f), float3(_2160, _2161, _2162));
                                _2168 = _2163;
                                break;
                              }
                            }
                            float _2165 = log2(_1813);
                            float _2166 = _2165 * 0.3010300099849701f;
                            _2168 = _2166;
                          } while (false);
                        }
                      }
                      float _2169 = _2168 * 3.321928024291992f;
                      float _2170 = exp2(_2169);
                      float _2171 = max(_2020, 1.000000013351432e-10f);
                      float _2172 = log2(_2171);
                      float _2173 = _2172 * 0.3010300099849701f;
                      bool _2174 = !(_2173 <= _2025);
                      do {
                        if (!_2174) {
                          float _2176 = log2(_1811);
                          float _2177 = _2176 * 0.3010300099849701f;
                          _2242 = _2177;
                        } else {
                          bool _2179 = (_2173 > _2025);
                          float _2180 = log2(_1808);
                          float _2181 = _2180 * 0.3010300099849701f;
                          bool _2182 = (_2173 < _2181);
                          bool _2183 = _2179 && _2182;
                          if (_2183) {
                            float _2185 = _2172 - _2024;
                            float _2186 = _2185 * 0.9030900001525879f;
                            float _2187 = _2180 - _2024;
                            float _2188 = _2187 * 0.3010300099849701f;
                            float _2189 = _2186 / _2188;
                            int _2190 = int(_2189);
                            float _2191 = float(_2190);
                            float _2192 = _2189 - _2191;
                            float _2194 = _10[_2190];
                            int _2195 = _2190 + 1;
                            float _2197 = _10[_2195];
                            int _2198 = _2190 + 2;
                            float _2200 = _10[_2198];
                            float _2201 = _2192 * _2192;
                            float _2202 = _2194 * 0.5f;
                            float _2203 = mad(_2197, -1.0f, _2202);
                            float _2204 = mad(_2200, 0.5f, _2203);
                            float _2205 = _2197 - _2194;
                            float _2206 = mad(_2197, 0.5f, _2202);
                            float _2207 = dot(float3(_2201, _2192, 1.0f), float3(_2204, _2205, _2206));
                            _2242 = _2207;
                          } else {
                            bool _2209 = !(_2173 >= _2181);
                            do {
                              if (!_2209) {
                                float _2211 = log2(_1812);
                                float _2212 = _2211 * 0.3010300099849701f;
                                bool _2213 = (_2173 < _2212);
                                if (_2213) {
                                  float _2215 = _2172 - _2180;
                                  float _2216 = _2215 * 0.9030900001525879f;
                                  float _2217 = _2211 - _2180;
                                  float _2218 = _2217 * 0.3010300099849701f;
                                  float _2219 = _2216 / _2218;
                                  int _2220 = int(_2219);
                                  float _2221 = float(_2220);
                                  float _2222 = _2219 - _2221;
                                  float _2224 = _11[_2220];
                                  int _2225 = _2220 + 1;
                                  float _2227 = _11[_2225];
                                  int _2228 = _2220 + 2;
                                  float _2230 = _11[_2228];
                                  float _2231 = _2222 * _2222;
                                  float _2232 = _2224 * 0.5f;
                                  float _2233 = mad(_2227, -1.0f, _2232);
                                  float _2234 = mad(_2230, 0.5f, _2233);
                                  float _2235 = _2227 - _2224;
                                  float _2236 = mad(_2227, 0.5f, _2232);
                                  float _2237 = dot(float3(_2231, _2222, 1.0f), float3(_2234, _2235, _2236));
                                  _2242 = _2237;
                                  break;
                                }
                              }
                              float _2239 = log2(_1813);
                              float _2240 = _2239 * 0.3010300099849701f;
                              _2242 = _2240;
                            } while (false);
                          }
                        }
                        float _2243 = _2242 * 3.321928024291992f;
                        float _2244 = exp2(_2243);
                        float _2245 = _2096 - _1811;
                        float _2246 = _1813 - _1811;
                        float _2247 = _2245 / _2246;
                        float _2248 = _2170 - _1811;
                        float _2249 = _2248 / _2246;
                        float _2250 = _2244 - _1811;
                        float _2251 = _2250 / _2246;
                        float _2252 = _2247 * 0.6624541878700256f;
                        float _2253 = mad(0.13400420546531677f, _2249, _2252);
                        float _2254 = mad(0.15618768334388733f, _2251, _2253);
                        float _2255 = _2247 * 0.2722287178039551f;
                        float _2256 = mad(0.6740817427635193f, _2249, _2255);
                        float _2257 = mad(0.053689517080783844f, _2251, _2256);
                        float _2258 = _2247 * -0.005574649665504694f;
                        float _2259 = mad(0.00406073359772563f, _2249, _2258);
                        float _2260 = mad(1.0103391408920288f, _2251, _2259);
                        float _2261 = _2254 * 1.6410233974456787f;
                        float _2262 = mad(-0.32480329275131226f, _2257, _2261);
                        float _2263 = mad(-0.23642469942569733f, _2260, _2262);
                        float _2264 = _2254 * -0.663662850856781f;
                        float _2265 = mad(1.6153316497802734f, _2257, _2264);
                        float _2266 = mad(0.016756348311901093f, _2260, _2265);
                        float _2267 = _2254 * 0.011721894145011902f;
                        float _2268 = mad(-0.008284442126750946f, _2257, _2267);
                        float _2269 = mad(0.9883948564529419f, _2260, _2268);
                        float _2270 = max(_2263, 0.0f);
                        float _2271 = max(_2266, 0.0f);
                        float _2272 = max(_2269, 0.0f);
                        float _2273 = min(_2270, 1.0f);
                        float _2274 = min(_2271, 1.0f);
                        float _2275 = min(_2272, 1.0f);
                        float _2276 = _2273 * 0.6624541878700256f;
                        float _2277 = mad(0.13400420546531677f, _2274, _2276);
                        float _2278 = mad(0.15618768334388733f, _2275, _2277);
                        float _2279 = _2273 * 0.2722287178039551f;
                        float _2280 = mad(0.6740817427635193f, _2274, _2279);
                        float _2281 = mad(0.053689517080783844f, _2275, _2280);
                        float _2282 = _2273 * -0.005574649665504694f;
                        float _2283 = mad(0.00406073359772563f, _2274, _2282);
                        float _2284 = mad(1.0103391408920288f, _2275, _2283);
                        float _2285 = _2278 * 1.6410233974456787f;
                        float _2286 = mad(-0.32480329275131226f, _2281, _2285);
                        float _2287 = mad(-0.23642469942569733f, _2284, _2286);
                        float _2288 = _2278 * -0.663662850856781f;
                        float _2289 = mad(1.6153316497802734f, _2281, _2288);
                        float _2290 = mad(0.016756348311901093f, _2284, _2289);
                        float _2291 = _2278 * 0.011721894145011902f;
                        float _2292 = mad(-0.008284442126750946f, _2281, _2291);
                        float _2293 = mad(0.9883948564529419f, _2284, _2292);
                        float _2294 = max(_2287, 0.0f);
                        float _2295 = max(_2290, 0.0f);
                        float _2296 = max(_2293, 0.0f);
                        float _2297 = min(_2294, 65535.0f);
                        float _2298 = min(_2295, 65535.0f);
                        float _2299 = min(_2296, 65535.0f);
                        float _2300 = _2297 * _1813;
                        float _2301 = _2298 * _1813;
                        float _2302 = _2299 * _1813;
                        float _2303 = max(_2300, 0.0f);
                        float _2304 = max(_2301, 0.0f);
                        float _2305 = max(_2302, 0.0f);
                        float _2306 = min(_2303, 65535.0f);
                        float _2307 = min(_2304, 65535.0f);
                        float _2308 = min(_2305, 65535.0f);
                        bool _2309 = (_1078 == 6);
                        _2321 = _2306;
                        _2322 = _2307;
                        _2323 = _2308;
                        do {
                          if (!_2309) {
                            float _2311 = _2306 * _39;
                            float _2312 = mad(_40, _2307, _2311);
                            float _2313 = mad(_41, _2308, _2312);
                            float _2314 = _2306 * _42;
                            float _2315 = mad(_43, _2307, _2314);
                            float _2316 = mad(_44, _2308, _2315);
                            float _2317 = _2306 * _45;
                            float _2318 = mad(_46, _2307, _2317);
                            float _2319 = mad(_47, _2308, _2318);
                            _2321 = _2313;
                            _2322 = _2316;
                            _2323 = _2319;
                          }
                          float _2324 = _2321 * 9.999999747378752e-05f;
                          float _2325 = _2322 * 9.999999747378752e-05f;
                          float _2326 = _2323 * 9.999999747378752e-05f;
                          float _2327 = log2(_2324);
                          float _2328 = log2(_2325);
                          float _2329 = log2(_2326);
                          float _2330 = _2327 * 0.1593017578125f;
                          float _2331 = _2328 * 0.1593017578125f;
                          float _2332 = _2329 * 0.1593017578125f;
                          float _2333 = exp2(_2330);
                          float _2334 = exp2(_2331);
                          float _2335 = exp2(_2332);
                          float _2336 = _2333 * 18.8515625f;
                          float _2337 = _2334 * 18.8515625f;
                          float _2338 = _2335 * 18.8515625f;
                          float _2339 = _2336 + 0.8359375f;
                          float _2340 = _2337 + 0.8359375f;
                          float _2341 = _2338 + 0.8359375f;
                          float _2342 = _2333 * 18.6875f;
                          float _2343 = _2334 * 18.6875f;
                          float _2344 = _2335 * 18.6875f;
                          float _2345 = _2342 + 1.0f;
                          float _2346 = _2343 + 1.0f;
                          float _2347 = _2344 + 1.0f;
                          float _2348 = 1.0f / _2345;
                          float _2349 = 1.0f / _2346;
                          float _2350 = 1.0f / _2347;
                          float _2351 = _2348 * _2339;
                          float _2352 = _2349 * _2340;
                          float _2353 = _2350 * _2341;
                          float _2354 = log2(_2351);
                          float _2355 = log2(_2352);
                          float _2356 = log2(_2353);
                          float _2357 = _2354 * 78.84375f;
                          float _2358 = _2355 * 78.84375f;
                          float _2359 = _2356 * 78.84375f;
                          float _2360 = exp2(_2357);
                          float _2361 = exp2(_2358);
                          float _2362 = exp2(_2359);
                          _2500 = _2360;
                          _2501 = _2361;
                          _2502 = _2362;
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } else {
          bool _2364 = (_1078 == 7);
          if (_2364) {  // TONEMAPPER_OUTPUT_LinearEXR
            float _2367 = cb1_08x;
            float _2368 = cb1_08y;
            float _2369 = cb1_08z;
            float _2371 = cb1_09x;
            float _2372 = cb1_09y;
            float _2373 = cb1_09z;
            float _2375 = cb1_10x;
            float _2376 = cb1_10y;
            float _2377 = cb1_10z;
            float _2378 = _2367 * _1060;
            float _2379 = mad(_2368, _1061, _2378);
            float _2380 = mad(_2369, _1062, _2379);
            float _2381 = _2371 * _1060;
            float _2382 = mad(_2372, _1061, _2381);
            float _2383 = mad(_2373, _1062, _2382);
            float _2384 = _2375 * _1060;
            float _2385 = mad(_2376, _1061, _2384);
            float _2386 = mad(_2377, _1062, _2385);
            float _2387 = _2380 * _39;
            float _2388 = mad(_40, _2383, _2387);
            float _2389 = mad(_41, _2386, _2388);
            float _2390 = _2380 * _42;
            float _2391 = mad(_43, _2383, _2390);
            float _2392 = mad(_44, _2386, _2391);
            float _2393 = _2380 * _45;
            float _2394 = mad(_46, _2383, _2393);
            float _2395 = mad(_47, _2386, _2394);
            float _2396 = _2389 * 9.999999747378752e-05f;
            float _2397 = _2392 * 9.999999747378752e-05f;
            float _2398 = _2395 * 9.999999747378752e-05f;
            float _2399 = log2(_2396);
            float _2400 = log2(_2397);
            float _2401 = log2(_2398);
            float _2402 = _2399 * 0.1593017578125f;
            float _2403 = _2400 * 0.1593017578125f;
            float _2404 = _2401 * 0.1593017578125f;
            float _2405 = exp2(_2402);
            float _2406 = exp2(_2403);
            float _2407 = exp2(_2404);
            float _2408 = _2405 * 18.8515625f;
            float _2409 = _2406 * 18.8515625f;
            float _2410 = _2407 * 18.8515625f;
            float _2411 = _2408 + 0.8359375f;
            float _2412 = _2409 + 0.8359375f;
            float _2413 = _2410 + 0.8359375f;
            float _2414 = _2405 * 18.6875f;
            float _2415 = _2406 * 18.6875f;
            float _2416 = _2407 * 18.6875f;
            float _2417 = _2414 + 1.0f;
            float _2418 = _2415 + 1.0f;
            float _2419 = _2416 + 1.0f;
            float _2420 = 1.0f / _2417;
            float _2421 = 1.0f / _2418;
            float _2422 = 1.0f / _2419;
            float _2423 = _2420 * _2411;
            float _2424 = _2421 * _2412;
            float _2425 = _2422 * _2413;
            float _2426 = log2(_2423);
            float _2427 = log2(_2424);
            float _2428 = log2(_2425);
            float _2429 = _2426 * 78.84375f;
            float _2430 = _2427 * 78.84375f;
            float _2431 = _2428 * 78.84375f;
            float _2432 = exp2(_2429);
            float _2433 = exp2(_2430);
            float _2434 = exp2(_2431);
            _2500 = _2432;
            _2501 = _2433;
            _2502 = _2434;
          } else {
            bool _2436 = (_1078 == 8);  // TONEMAPPER_OUTPUT_NoToneCurve
            _2500 = _1060;
            _2501 = _1061;
            _2502 = _1062;
            if (!_2436) {
              bool _2438 = (_1078 == 9);  // TONEMAPPER_OUTPUT_WithToneCurve
              float _2440 = cb1_08x;
              float _2441 = cb1_08y;
              float _2442 = cb1_08z;
              float _2444 = cb1_09x;
              float _2445 = cb1_09y;
              float _2446 = cb1_09z;
              float _2448 = cb1_10x;
              float _2449 = cb1_10y;
              float _2450 = cb1_10z;
              if (_2438) {  // TONEMAPPER_OUTPUT_WithToneCurve
                float _2452 = _2440 * _1048;
                float _2453 = mad(_2441, _1049, _2452);
                float _2454 = mad(_2442, _1050, _2453);
                float _2455 = _2444 * _1048;
                float _2456 = mad(_2445, _1049, _2455);
                float _2457 = mad(_2446, _1050, _2456);
                float _2458 = _2448 * _1048;
                float _2459 = mad(_2449, _1049, _2458);
                float _2460 = mad(_2450, _1050, _2459);
                float _2461 = _2454 * _39;
                float _2462 = mad(_40, _2457, _2461);
                float _2463 = mad(_41, _2460, _2462);
                float _2464 = _2454 * _42;
                float _2465 = mad(_43, _2457, _2464);
                float _2466 = mad(_44, _2460, _2465);
                float _2467 = _2454 * _45;
                float _2468 = mad(_46, _2457, _2467);
                float _2469 = mad(_47, _2460, _2468);
                _2500 = _2463;
                _2501 = _2466;
                _2502 = _2469;
              } else {
                // Default (TONEMAPPER_OUTPUT_ExplicitGammaMapping 2) ?
                float _2471 = _2440 * _1074;
                float _2472 = mad(_2441, _1075, _2471);
                float _2473 = mad(_2442, _1076, _2472);
                float _2474 = _2444 * _1074;
                float _2475 = mad(_2445, _1075, _2474);
                float _2476 = mad(_2446, _1076, _2475);
                float _2477 = _2448 * _1074;
                float _2478 = mad(_2449, _1075, _2477);
                float _2479 = mad(_2450, _1076, _2478);
                float _2480 = _2473 * _39;
                float _2481 = mad(_40, _2476, _2480);
                float _2482 = mad(_41, _2479, _2481);
                float _2483 = _2473 * _42;
                float _2484 = mad(_43, _2476, _2483);
                float _2485 = mad(_44, _2479, _2484);
                float _2486 = _2473 * _45;
                float _2487 = mad(_46, _2476, _2486);
                float _2488 = mad(_47, _2479, _2487);
                float _2489 = cb0_40z;  // Custom Gamma
                float _2490 = log2(_2482);
                float _2491 = log2(_2485);
                float _2492 = log2(_2488);
                float _2493 = _2490 * _2489;
                float _2494 = _2491 * _2489;
                float _2495 = _2492 * _2489;
                float _2496 = exp2(_2493);
                float _2497 = exp2(_2494);
                float _2498 = exp2(_2495);
                _2500 = _2496;
                _2501 = _2497;
                _2502 = _2498;
              }
            }
          }
        }
      }
    }
  }
  float _2503 = _2500 * 0.9523810148239136f;
  float _2504 = _2501 * 0.9523810148239136f;
  float _2505 = _2502 * 0.9523810148239136f;
  SV_Target.x = _2503;
  SV_Target.y = _2504;
  SV_Target.z = _2505;
  SV_Target.w = 0.0f;

  return SV_Target;
}
