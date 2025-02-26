Texture2D<float4> UI_DIFF : register(t0, space2);

Texture2D<float4> UI_TEX2 : register(t2, space2);

Texture2D<float4> UI_TEX3 : register(t3, space2);

Texture2D<float4> UI_TEX4 : register(t4, space2);

cbuffer CB_COMMON : register(b0) {
  float CB_COMMON_041x : packoffset(c041.x);
  float CB_COMMON_041y : packoffset(c041.y);
  float CB_COMMON_041w : packoffset(c041.w);
};

cbuffer CB_DYNAMIC_UI : register(b4) {
  float CB_DYNAMIC_UI_005x : packoffset(c005.x);
  float CB_DYNAMIC_UI_005y : packoffset(c005.y);
  float CB_DYNAMIC_UI_005z : packoffset(c005.z);
  float CB_DYNAMIC_UI_005w : packoffset(c005.w);
  float CB_DYNAMIC_UI_006x : packoffset(c006.x);
  float CB_DYNAMIC_UI_006y : packoffset(c006.y);
  float CB_DYNAMIC_UI_006z : packoffset(c006.z);
  float CB_DYNAMIC_UI_006w : packoffset(c006.w);
  float CB_DYNAMIC_UI_015w : packoffset(c015.w);
  float CB_DYNAMIC_UI_016x : packoffset(c016.x);
  float CB_DYNAMIC_UI_016y : packoffset(c016.y);
  float CB_DYNAMIC_UI_016z : packoffset(c016.z);
  float CB_DYNAMIC_UI_017x : packoffset(c017.x);
  float CB_DYNAMIC_UI_017y : packoffset(c017.y);
  float CB_DYNAMIC_UI_017z : packoffset(c017.z);
  float CB_DYNAMIC_UI_018x : packoffset(c018.x);
  float CB_DYNAMIC_UI_018y : packoffset(c018.y);
  float CB_DYNAMIC_UI_018z : packoffset(c018.z);
  float CB_DYNAMIC_UI_019x : packoffset(c019.x);
  float CB_DYNAMIC_UI_019y : packoffset(c019.y);
  float CB_DYNAMIC_UI_019z : packoffset(c019.z);
};

SamplerState PS_SAMPLERS[12] : register(s0, space1);

struct OutputSignature {
  float4 SV_Target : SV_Target;
  float4 SV_Target_1 : SV_Target1;
};

OutputSignature main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD,
  linear float COLOR_1 : COLOR1
) {
  float4 SV_Target;
  float4 SV_Target_1;
  float _9[3];
  float _10[3];
  float4 _12 = UI_DIFF.Sample(PS_SAMPLERS[4], float2((TEXCOORD.x), (TEXCOORD.y)));
  float4 _14 = UI_TEX2.Sample(PS_SAMPLERS[4], float2((TEXCOORD.x), (TEXCOORD.y)));
  float4 _16 = UI_TEX3.Sample(PS_SAMPLERS[4], float2((TEXCOORD.x), (TEXCOORD.y)));
  float4 _18 = UI_TEX4.Sample(PS_SAMPLERS[4], float2((TEXCOORD.x), (TEXCOORD.y)));
  float _24 = (CB_DYNAMIC_UI_019x) * (_12.x);
  float _25 = (CB_DYNAMIC_UI_019y) * (_12.x);
  float _26 = (CB_DYNAMIC_UI_019z) * (_12.x);
  float _31 = (CB_DYNAMIC_UI_016x) * (_14.x);
  float _32 = (CB_DYNAMIC_UI_016y) * (_14.x);
  float _33 = (CB_DYNAMIC_UI_016z) * (_14.x);
  float _38 = (CB_DYNAMIC_UI_017x) * (_16.x);
  float _39 = (CB_DYNAMIC_UI_017y) * (_16.x);
  float _40 = (CB_DYNAMIC_UI_017z) * (_16.x);
  float _45 = _31 + _24;
  float _46 = _45 + _38;
  float _47 = _46 + (CB_DYNAMIC_UI_018x);
  float _48 = _32 + _25;
  float _49 = _48 + _39;
  float _50 = _49 + (CB_DYNAMIC_UI_018y);
  float _51 = _33 + _26;
  float _52 = _51 + _40;
  float _53 = _52 + (CB_DYNAMIC_UI_018z);
  float _59 = (CB_DYNAMIC_UI_005x) * (_18.x);
  float _60 = _59 * _47;
  float _61 = (CB_DYNAMIC_UI_005y) * (_18.x);
  float _62 = _61 * _50;
  float _63 = (CB_DYNAMIC_UI_005z) * (_18.x);
  float _64 = _63 * _53;
  float _65 = (CB_DYNAMIC_UI_005w) * (_18.x);
  float _71 = _60 + (CB_DYNAMIC_UI_006x);
  float _72 = _62 + (CB_DYNAMIC_UI_006y);
  float _73 = _64 + (CB_DYNAMIC_UI_006z);
  float _74 = _65 + (CB_DYNAMIC_UI_006w);
  bool _77 = !((CB_COMMON_041w) == 0.0f);
  float _131 = _72;
  float _132 = _73;
  if (_77) {
    int _79 = int(79);
    float _80 = float(_79);
    float _81 = (CB_COMMON_041w) - _80;
    float _82 = _81 * 2.0f;
    float _83 = _71 * 17.882400512695312f;
    float _84 = mad(43.5161018371582f, _72, _83);
    float _85 = mad(4.119349956512451f, _73, _84);
    float _86 = _71 * 3.4556500911712646f;
    float _87 = mad(27.155399322509766f, _72, _86);
    float _88 = mad(3.867140054702759f, _73, _87);
    float _89 = _71 * 0.029956599697470665f;
    float _90 = mad(0.1843090057373047f, _72, _89);
    float _91 = mad(1.4670900106430054f, _73, _90);
    _9[0] = _85;
    _9[1] = _88;
    _9[2] = _91;
    float _95 = mad(2.023439884185791f, _88, 0.0f);
    float _96 = mad(-2.5258100032806396f, _91, _95);
    float _97 = _85 * 0.4942069947719574f;
    float _98 = mad(1.248270034790039f, _91, _97);
    float _99 = _85 * -0.3959130048751831f;
    float _100 = mad(0.8011090159416199f, _88, _99);
    _10[0] = _96;
    _10[1] = _98;
    _10[2] = _100;
    int _104 = _79 + -1;
    float _106 = _10[_104];
    _9[_104] = _106;
    float _108 = _9[0];
    float _109 = _9[1];
    float _110 = _9[2];
    float _111 = _108 * 0.08094444870948792f;
    float _112 = mad(-0.13050441443920135f, _109, _111);
    float _113 = mad(0.11672106385231018f, _110, _112);
    float _114 = _108 * -0.010248533450067043f;
    float _115 = mad(0.05401932820677757f, _109, _114);
    float _116 = mad(-0.11361470818519592f, _110, _115);
    float _117 = _108 * -0.0003652969317045063f;
    float _118 = mad(-0.004121614620089531f, _109, _117);
    float _119 = mad(0.693511426448822f, _110, _118);
    float _120 = _71 - _113;
    float _121 = _72 - _116;
    float _122 = _120 * 0.699999988079071f;
    float _123 = _121 + _122;
    float _124 = _122 + _73;
    float _125 = _124 - _119;
    float _126 = _123 * _82;
    float _127 = _125 * _82;
    float _128 = _126 + _72;
    float _129 = _127 + _73;
    _131 = _128;
    _132 = _129;
  }
  float _135 = log2(_71);
  float _136 = log2(_131);
  float _137 = log2(_132);
  float _138 = _135 * (CB_COMMON_041x);
  float _139 = _136 * (CB_COMMON_041x);
  float _140 = _137 * (CB_COMMON_041x);
  float _141 = exp2(_138);
  float _142 = exp2(_139);
  float _143 = exp2(_140);
  float _144 = _141 * (CB_COMMON_041y);
  float _145 = _142 * (CB_COMMON_041y);
  float _146 = _143 * (CB_COMMON_041y);
  float _149 = 1.0f - (CB_DYNAMIC_UI_015w);
  float _150 = _149 * _71;
  float _151 = _149 * _131;
  float _152 = _149 * _132;
  float _153 = _144 * (CB_DYNAMIC_UI_015w);
  float _154 = _145 * (CB_DYNAMIC_UI_015w);
  float _155 = _146 * (CB_DYNAMIC_UI_015w);
  float _156 = _150 + _153;
  float _157 = _151 + _154;
  float _158 = _152 + _155;
  float _159 = _156 * _74;
  float _160 = _157 * _74;
  float _161 = _158 * _74;
  SV_Target.x = _159;
  SV_Target.y = _160;
  SV_Target.z = _161;
  SV_Target.w = 0.0f;
  SV_Target_1.x = _159;
  SV_Target_1.y = _160;
  SV_Target_1.z = _161;
  SV_Target_1.w = 0.0f;
  SV_Target = saturate(SV_Target);
  SV_Target_1 = saturate(SV_Target_1);
  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}
