#include "./shared.h"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

cbuffer cb0 : register(b0)
{
    float cb0_007z : packoffset(c007.z);
};

SamplerState s0 : register(s0);

SamplerState s1 : register(s1);

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float4 SV_Position : SV_Position
) : SV_Target
{
    float4 SV_Target;
  // texture _1 = t1;
  // texture _2 = t0;
  // SamplerState _3 = s1;
  // SamplerState _4 = s0;
  // cbuffer _5 = cb0; // index=0
  // _6 = _5;
    float _7 = TEXCOORD.x;
    float _8 = TEXCOORD.y;
  // _9 = _2;
  // _10 = _4;
    float4 _11 = t0.Sample(s0, float2(_7, _8));
    float _12 = _11.x;
    float _13 = _11.y;
    float _14 = _11.z;
    float _15 = _11.w;
    
    // fix elevated blacks
    //float _16 = max(6.103519990574569e-05f, _12);
    //float _17 = max(6.103519990574569e-05f, _13);
    //float _18 = max(6.103519990574569e-05f, _14);
    float _16 = _12;
    float _17 = _13;
    float _18 = _14;
    
    float _19 = _16 * 0.07739938050508499f;
    float _20 = _17 * 0.07739938050508499f;
    float _21 = _18 * 0.07739938050508499f;
    float _22 = _16 * 0.9478672742843628f;
    float _23 = _17 * 0.9478672742843628f;
    float _24 = _18 * 0.9478672742843628f;
    float _25 = _22 + 0.05213269963860512f;
    float _26 = _23 + 0.05213269963860512f;
    float _27 = _24 + 0.05213269963860512f;
    float _28 = log2(_25);
    float _29 = log2(_26);
    float _30 = log2(_27);
    float _31 = _28 * 2.4000000953674316f;
    float _32 = _29 * 2.4000000953674316f;
    float _33 = _30 * 2.4000000953674316f;
    float _34 = exp2(_31);
    float _35 = exp2(_32);
    float _36 = exp2(_33);
    bool _37 = (_16 > 0.040449999272823334f);
    bool _38 = (_17 > 0.040449999272823334f);
    bool _39 = (_18 > 0.040449999272823334f);
    float _40 = _37 ? _34 : _19;
    float _41 = _38 ? _35 : _20;
    float _42 = _39 ? _36 : _21;
    float _43 = _40 * 0.6274880170822144f;
    float _44 = mad(0.32926714420318604f, _41, _43);
    float _45 = mad(0.04330150783061981f, _42, _44);
    float _46 = _40 * 0.06910824030637741f;
    float _47 = mad(0.9195171594619751f, _41, _46);
    float _48 = mad(0.011359544470906258f, _42, _47);
    float _49 = _40 * 0.016396233811974525f;
    float _50 = mad(0.08802297711372375f, _41, _49);
    float _51 = mad(0.8954997062683105f, _42, _50);
    
    //float _52 = _45 * 300.0f;
    //float _53 = _48 * 300.0f;
    //float _54 = _51 * 300.0f;
    float _52 = (_45 * 300.0f) / 203.f * injectedData.toneMapUINits;
    float _53 = (_48 * 300.0f) / 203.f * injectedData.toneMapUINits;
    float _54 = (_51 * 300.0f) / 203.f * injectedData.toneMapUINits;
    
    // _55 = _1;
    // _56 = _3;
    float4 _57 = t1.Sample(s1, float2(_7, _8));
    float _58 = _57.x;
    float _59 = _57.y;
    float _60 = _57.z;
    float _61 = log2(_58);
    float _62 = log2(_59);
    float _63 = log2(_60);
    float _64 = _61 * 0.012683313339948654f;
    float _65 = _62 * 0.012683313339948654f;
    float _66 = _63 * 0.012683313339948654f;
    float _67 = exp2(_64);
    float _68 = exp2(_65);
    float _69 = exp2(_66);
    float _70 = _67 + -0.8359375f;
    float _71 = _68 + -0.8359375f;
    float _72 = _69 + -0.8359375f;
    float _73 = max(0.0f, _70);
    float _74 = max(0.0f, _71);
    float _75 = max(0.0f, _72);
    float _76 = _67 * 18.6875f;
    float _77 = _68 * 18.6875f;
    float _78 = _69 * 18.6875f;
    float _79 = 18.8515625f - _76;
    float _80 = 18.8515625f - _77;
    float _81 = 18.8515625f - _78;
    float _82 = _73 / _79;
    float _83 = _74 / _80;
    float _84 = _75 / _81;
    float _85 = log2(_82);
    float _86 = log2(_83);
    float _87 = log2(_84);
    float _88 = _85 * 6.277394771575928f;
    float _89 = _86 * 6.277394771575928f;
    float _90 = _87 * 6.277394771575928f;
    float _91 = exp2(_88);
    float _92 = exp2(_89);
    float _93 = exp2(_90);
    float _94 = _91 * 10000.0f;
    float _95 = _92 * 10000.0f;
    float _96 = _93 * 10000.0f;
    float _98 = cb0_007z;
    bool _99 = (_15 > 0.0f);
    bool _100 = (_15 < 1.0f);
    bool _101 = _99 && _100;
    float _118 = _94;
    float _119 = _95;
    float _120 = _96;
    if (_101)
    {
        float _103 = max(_94, 0.0f);
        float _104 = max(_95, 0.0f);
        float _105 = max(_96, 0.0f);
        float _106 = dot(float3(_103, _104, _105), float3(0.26269999146461487f, 0.6779999732971191f, 0.059300001710653305f));
        float _107 = _106 / _98;
        float _108 = _107 + 1.0f;
        float _109 = 1.0f / _108;
        float _110 = _109 * _98;
        float _111 = _110 + -1.0f;
        float _112 = _111 * _15;
        float _113 = _112 + 1.0f;
        float _114 = _113 * _103;
        float _115 = _113 * _104;
        float _116 = _113 * _105;
        _118 = _114;
        _119 = _115;
        _120 = _116;
    }
    float _121 = 1.0f - _15;
    float _122 = _118 * _121;
    float _123 = _119 * _121;
    float _124 = _120 * _121;
    float _125 = _52 * _98;
    float _126 = _53 * _98;
    float _127 = _54 * _98;
    float _128 = _122 + _125;
    float _129 = _123 + _126;
    float _130 = _124 + _127;
    float _131 = _128 * 9.999999747378752e-05f;
    float _132 = _129 * 9.999999747378752e-05f;
    float _133 = _130 * 9.999999747378752e-05f;
    float _134 = log2(_131);
    float _135 = log2(_132);
    float _136 = log2(_133);
    float _137 = _134 * 0.1593017578125f;
    float _138 = _135 * 0.1593017578125f;
    float _139 = _136 * 0.1593017578125f;
    float _140 = exp2(_137);
    float _141 = exp2(_138);
    float _142 = exp2(_139);
    float _143 = _140 * 18.8515625f;
    float _144 = _141 * 18.8515625f;
    float _145 = _142 * 18.8515625f;
    float _146 = _143 + 0.8359375f;
    float _147 = _144 + 0.8359375f;
    float _148 = _145 + 0.8359375f;
    float _149 = _140 * 18.6875f;
    float _150 = _141 * 18.6875f;
    float _151 = _142 * 18.6875f;
    float _152 = _149 + 1.0f;
    float _153 = _150 + 1.0f;
    float _154 = _151 + 1.0f;
    float _155 = 1.0f / _152;
    float _156 = 1.0f / _153;
    float _157 = 1.0f / _154;
    float _158 = _155 * _146;
    float _159 = _156 * _147;
    float _160 = _157 * _148;
    float _161 = log2(_158);
    float _162 = log2(_159);
    float _163 = log2(_160);
    float _164 = _161 * 78.84375f;
    float _165 = _162 * 78.84375f;
    float _166 = _163 * 78.84375f;
    float _167 = exp2(_164);
    float _168 = exp2(_165);
    float _169 = exp2(_166);
    SV_Target.x = _167;
    SV_Target.y = _168;
    SV_Target.z = _169;

    // SV_Target.w = 1.0f;
    SV_Target.w = _11.w; // fix DLSS FG in HDR

    return SV_Target;
}
