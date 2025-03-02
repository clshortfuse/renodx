Texture2D<float4> StandardMaxNitsImage : register(t0);

Texture2D<float4> DisplayMaxNitsImage : register(t1);

cbuffer HDRMapping : register(b0) {
  float HDRMapping_000x : packoffset(c000.x);
  float HDRMapping_000y : packoffset(c000.y);
  float HDRMapping_000z : packoffset(c000.z);
  float HDRMapping_001x : packoffset(c001.x);
  float HDRMapping_001y : packoffset(c001.y);
  float HDRMapping_001z : packoffset(c001.z);
  float HDRMapping_001w : packoffset(c001.w);
  float HDRMapping_003x : packoffset(c003.x);
  float HDRMapping_003y : packoffset(c003.y);
  float HDRMapping_003z : packoffset(c003.z);
  float HDRMapping_003w : packoffset(c003.w);
  float HDRMapping_005x : packoffset(c005.x);
  float HDRMapping_005y : packoffset(c005.y);
  float HDRMapping_005z : packoffset(c005.z);
  float HDRMapping_005w : packoffset(c005.w);
};

SamplerState PointClamp : register(s1, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  bool _10 = !((TEXCOORD.x) >= (HDRMapping_003x));
  float _88 = 0.0f;
  float _89 = 0.0f;
  float _90 = 0.0f;
  float _91 = 0.0f;
  float _184;
  float _185;
  float _186;
  float _187;
  if (!_10) {
    bool _13 = !((TEXCOORD.x) <= (HDRMapping_003z));
    bool _15 = !((TEXCOORD.y) >= (HDRMapping_003y));
    bool _16 = _13 || _15;
    _88 = 0.0f;
    _89 = 0.0f;
    _90 = 0.0f;
    _91 = 0.0f;
    if (!_16) {
      bool _19 = !((TEXCOORD.y) <= (HDRMapping_003w));
      _88 = 0.0f;
      _89 = 0.0f;
      _90 = 0.0f;
      _91 = 0.0f;
      if (!_19) {
        float _24 = (HDRMapping_003z) - (TEXCOORD.x);
        float _25 = _24 / (HDRMapping_005z);
        float _26 = 1.0f - _25;
        float _27 = (HDRMapping_003w) - (TEXCOORD.y);
        float _28 = _27 / (HDRMapping_005w);
        float _29 = 1.0f - _28;
        float4 _32 = StandardMaxNitsImage.SampleLevel(PointClamp, float2(_26, _29), 0.0f);
        float _39 = (_32.x) * 100.0f;
        float _40 = (_32.y) * 100.0f;
        float _41 = (_32.z) * 100.0f;
        float _42 = 10000.0f / (HDRMapping_000x);
        float _43 = _39 / _42;
        float _44 = _40 / _42;
        float _45 = _41 / _42;
        float _46 = saturate(_43);
        float _47 = saturate(_44);
        float _48 = saturate(_45);
        float _49 = log2(_46);
        float _50 = _49 * 0.1593017578125f;
        float _51 = exp2(_50);
        float _52 = _51 * 18.8515625f;
        float _53 = _52 + 0.8359375f;
        float _54 = _51 * 18.6875f;
        float _55 = _54 + 1.0f;
        float _56 = _53 / _55;
        float _57 = log2(_56);
        float _58 = _57 * 78.84375f;
        float _59 = exp2(_58);
        float _60 = saturate(_59);
        float _61 = log2(_47);
        float _62 = _61 * 0.1593017578125f;
        float _63 = exp2(_62);
        float _64 = _63 * 18.8515625f;
        float _65 = _64 + 0.8359375f;
        float _66 = _63 * 18.6875f;
        float _67 = _66 + 1.0f;
        float _68 = _65 / _67;
        float _69 = log2(_68);
        float _70 = _69 * 78.84375f;
        float _71 = exp2(_70);
        float _72 = saturate(_71);
        float _73 = log2(_48);
        float _74 = _73 * 0.1593017578125f;
        float _75 = exp2(_74);
        float _76 = _75 * 18.8515625f;
        float _77 = _76 + 0.8359375f;
        float _78 = _75 * 18.6875f;
        float _79 = _78 + 1.0f;
        float _80 = _77 / _79;
        float _81 = log2(_80);
        float _82 = _81 * 78.84375f;
        float _83 = exp2(_82);
        float _84 = saturate(_83);
        float _86 = (HDRMapping_000y) * (_32.w);
        _88 = _60;
        _89 = _72;
        _90 = _84;
        _91 = _86;
      }
    }
  }
  bool _94 = !((TEXCOORD.x) >= (HDRMapping_001x));
  _184 = _88;
  _185 = _89;
  _186 = _90;
  _187 = _91;
  if (!_94) {
    bool _97 = !((TEXCOORD.x) <= (HDRMapping_001z));
    bool _99 = !((TEXCOORD.y) >= (HDRMapping_001y));
    bool _100 = _97 || _99;
    _184 = _88;
    _185 = _89;
    _186 = _90;
    _187 = _91;
    if (!_100) {
      bool _103 = !((TEXCOORD.y) <= (HDRMapping_001w));
      _184 = _88;
      _185 = _89;
      _186 = _90;
      _187 = _91;
      if (!_103) {
        float _108 = (HDRMapping_001z) - (TEXCOORD.x);
        float _109 = _108 / (HDRMapping_005x);
        float _110 = 1.0f - _109;
        float _111 = (HDRMapping_001w) - (TEXCOORD.y);
        float _112 = _111 / (HDRMapping_005y);
        float _113 = 1.0f - _112;
        float4 _116 = DisplayMaxNitsImage.SampleLevel(PointClamp, float2(_110, _113), 0.0f);
        float _124 = (HDRMapping_000z) * (_116.x);
        float _125 = (HDRMapping_000z) * (_116.y);
        float _126 = (HDRMapping_000z) * (_116.z);
        float _127 = 10000.0f / (HDRMapping_000x);
        float _128 = (HDRMapping_000x) * _127;
        float _129 = _124 / _128;
        float _130 = _125 / _128;
        float _131 = _126 / _128;
        float _132 = saturate(_129);
        float _133 = saturate(_130);
        float _134 = saturate(_131);
        float _135 = log2(_132);
        float _136 = _135 * 0.1593017578125f;
        float _137 = exp2(_136);
        float _138 = _137 * 18.8515625f;
        float _139 = _138 + 0.8359375f;
        float _140 = _137 * 18.6875f;
        float _141 = _140 + 1.0f;
        float _142 = _139 / _141;
        float _143 = log2(_142);
        float _144 = _143 * 78.84375f;
        float _145 = exp2(_144);
        float _146 = saturate(_145);
        float _147 = log2(_133);
        float _148 = _147 * 0.1593017578125f;
        float _149 = exp2(_148);
        float _150 = _149 * 18.8515625f;
        float _151 = _150 + 0.8359375f;
        float _152 = _149 * 18.6875f;
        float _153 = _152 + 1.0f;
        float _154 = _151 / _153;
        float _155 = log2(_154);
        float _156 = _155 * 78.84375f;
        float _157 = exp2(_156);
        float _158 = saturate(_157);
        float _159 = log2(_134);
        float _160 = _159 * 0.1593017578125f;
        float _161 = exp2(_160);
        float _162 = _161 * 18.8515625f;
        float _163 = _162 + 0.8359375f;
        float _164 = _161 * 18.6875f;
        float _165 = _164 + 1.0f;
        float _166 = _163 / _165;
        float _167 = log2(_166);
        float _168 = _167 * 78.84375f;
        float _169 = exp2(_168);
        float _170 = saturate(_169);
        float _172 = (HDRMapping_000y) * (_116.w);
        float _173 = _146 - _88;
        float _174 = _158 - _89;
        float _175 = _170 - _90;
        float _176 = _172 * _173;
        float _177 = _172 * _174;
        float _178 = _172 * _175;
        float _179 = _176 + _88;
        float _180 = _177 + _89;
        float _181 = _178 + _90;
        float _182 = max(_91, _172);
        _184 = _179;
        _185 = _180;
        _186 = _181;
        _187 = _182;
      }
    }
  }
  SV_Target.x = _184;
  SV_Target.y = _185;
  SV_Target.z = _186;
  SV_Target.w = _187;
  return SV_Target;
}
