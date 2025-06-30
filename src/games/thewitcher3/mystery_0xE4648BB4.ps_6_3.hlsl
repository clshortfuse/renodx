#include "./common.hlsl"

Texture2D<float4> t0 : register(t0);

cbuffer cb0 : register(b3) {
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

SamplerState s0 : register(s1);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float _12 = TEXCOORD.x - CustomPixelConsts_272.x;
  float _13 = TEXCOORD.y - CustomPixelConsts_272.y;
  float _14 = _12 / CustomPixelConsts_272.x;
  float _15 = _13 / CustomPixelConsts_272.y;
  float _16 = _14 * _14;
  float _17 = _15 * _15;
  float _18 = _17 + _16;
  float _19 = sqrt(_18);
  float _20 = _19 - (CustomPixelConsts_256.y);
  float _21 = _20 * (CustomPixelConsts_256.z);
  float _22 = saturate(_21);
  float4 _23 = t0.SampleLevel(s0, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  bool _27 = (_22 > 0.0f);
  float _53;
  float _54;
  [branch]
  if (_27) {
    float _32 = _22 * _22;
    float _33 = _32 * (CustomPixelConsts_256.x);
    float _34 = 1.0f / _19;
    float _35 = max(_34, -3.4028234663852886e+38f);
    float _36 = min(_35, 3.4028234663852886e+38f);
    float _37 = _33 * _36;
    float _38 = _14 * CustomPixelConsts_272.z;
    float _39 = _38 * _37;
    float _40 = _15 * CustomPixelConsts_272.w;
    float _41 = _40 * _37;
    float _42 = _39 * 2.0f;
    float _43 = _41 * 2.0f;
    float _44 = TEXCOORD.x - _42;
    float _45 = TEXCOORD.y - _43;
    float4 _46 = t0.SampleLevel(s0, float2(_44, _45), 0.0f);
    float _48 = TEXCOORD.x - _39;
    float _49 = TEXCOORD.y - _41;
    float4 _50 = t0.SampleLevel(s0, float2(_48, _49), 0.0f);
    _53 = (_46.x);
    _54 = _50.y;
  } else {
    _53 = _23.x;
    _54 = _23.y;
  }
  float _57 = abs(_53);
  float _58 = abs(_54);
  float _59 = abs(_23.z);
  float _60 = log2(_57);
  float _61 = log2(_58);
  float _62 = log2(_59);
  float _63 = _60 * CustomPixelConsts_128.x;
  float _64 = _61 * CustomPixelConsts_128.x;
  float _65 = _62 * CustomPixelConsts_128.x;
  float _66 = exp2(_63);
  float _67 = exp2(_64);
  float _68 = exp2(_65);
  float _72 = CustomPixelConsts_224.x * _66;
  float _73 = CustomPixelConsts_224.x * _67;
  float _74 = CustomPixelConsts_224.x * _68;
  float _76 = _72 + CustomPixelConsts_224.y;
  float _77 = _73 + CustomPixelConsts_224.y;
  float _78 = _74 + CustomPixelConsts_224.y;

  float _79 = max(0.0f, _76);
  float _80 = max(0.0f, _77);
  float _81 = max(0.0f, _78);
  float _82 = log2(_79);
  float _83 = log2(_80);
  float _84 = log2(_81);
  float _85 = _82 * CustomPixelConsts_224.z;
  float _86 = _83 * CustomPixelConsts_224.z;
  float _87 = _84 * CustomPixelConsts_224.z;
  float _88 = exp2(_85);
  float _89 = exp2(_86);
  float _90 = exp2(_87);
  float _91 = dot(float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f), float3(_88, _89, _90));
  float _94 = _91 - (CustomPixelConsts_160.x);
  float _96 = _94 * (CustomPixelConsts_160.y);
  float _97 = saturate(_96);
  float _99 = _91 - (CustomPixelConsts_160.z);
  float _101 = _99 * (CustomPixelConsts_160.w);
  float _102 = saturate(_101);

  // float _103 = max(0.0f, _88);
  // float _104 = max(0.0f, _89);
  // float _105 = max(0.0f, _90);
  // float _106 = log2(_103);
  // float _107 = log2(_104);
  // float _108 = log2(_105);
  // float _109 = _106 * 2.200000047683716f;
  // float _110 = _107 * 2.200000047683716f;
  // float _111 = _108 * 2.200000047683716f;
  // float _112 = exp2(_109);
  // float _113 = exp2(_110);
  // float _114 = exp2(_111);
  float _112 = renodx::color::gamma::DecodeSafe(_88);
  float _113 = renodx::color::gamma::DecodeSafe(_89);
  float _114 = renodx::color::gamma::DecodeSafe(_90);

  float3 untonemapped = float3(_112, _113, _114);

  float _115 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_112, _113, _114));
  float _126 = (CustomPixelConsts_176.x) - CustomPixelConsts_192.x;
  float _127 = (CustomPixelConsts_176.y) - CustomPixelConsts_192.y;
  float _128 = (CustomPixelConsts_176.z) - CustomPixelConsts_192.z;
  float _129 = (CustomPixelConsts_176.w) - CustomPixelConsts_192.w;
  float _130 = _126 * _97;
  float _131 = _127 * _97;
  float _132 = _128 * _97;
  float _133 = _129 * _97;
  float _134 = _130 + CustomPixelConsts_192.x;
  float _135 = _131 + CustomPixelConsts_192.y;
  float _136 = _132 + CustomPixelConsts_192.z;
  float _137 = _133 + CustomPixelConsts_192.w;
  float _143 = CustomPixelConsts_208.x - _134;
  float _144 = CustomPixelConsts_208.y - _135;
  float _145 = CustomPixelConsts_208.z - _136;
  float _146 = CustomPixelConsts_208.w - _137;
  float _147 = _143 * _102;
  float _148 = _144 * _102;
  float _149 = _145 * _102;
  float _150 = _146 * _102;
  float _151 = _147 + _134;
  float _152 = _148 + _135;
  float _153 = _149 + _136;
  float _154 = _150 + _137;
  float _155 = _112 - _115;
  float _156 = _113 - _115;
  float _157 = _114 - _115;
  float _158 = _154 * _155;
  float _159 = _154 * _156;
  float _160 = _154 * _157;
  float _161 = _158 + _115;
  float _162 = _159 + _115;
  float _163 = _160 + _115;
  float _164 = _161 * _151;
  float _165 = _162 * _152;
  float _166 = _163 * _153;

  float3 clearNans = renodx::color::bt709::clamp::BT709(float3(_164, _165, _166));

  // float _167 = max(0.0f, _164);
  // float _168 = max(0.0f, _165);
  // float _169 = max(0.0f, _166);
  // float _170 = log2(_167);
  // float _171 = log2(_168);
  // float _172 = log2(_169);
  // float _173 = _170 * 0.4545454680919647f;
  // float _174 = _171 * 0.4545454680919647f;
  // float _175 = _172 * 0.4545454680919647f;
  // float _176 = exp2(_173);
  // float _177 = exp2(_174);
  // float _178 = exp2(_175);
  float _176 = renodx::color::gamma::EncodeSafe(clearNans.x);
  float _177 = renodx::color::gamma::EncodeSafe(clearNans.y);
  float _178 = renodx::color::gamma::EncodeSafe(clearNans.z);

  float _183 = CustomPixelConsts_144.x * _176;
  float _184 = CustomPixelConsts_144.y * _177;
  float _185 = CustomPixelConsts_144.z * _178;
  float _189 = CustomPixelConsts_240.y - CustomPixelConsts_240.x;
  float _190 = _183 * _189;
  float _191 = _184 * _189;
  float _192 = _185 * _189;
  float _193 = _190 + CustomPixelConsts_240.x;
  float _194 = _191 + CustomPixelConsts_240.x;
  float _195 = _192 + CustomPixelConsts_240.x;
  SV_Target.x = _193;
  SV_Target.y = _194;
  SV_Target.z = _195;
  SV_Target.w = 1.0f;

  // SV_Target.rgb = renodx::draw::RenderIntermediatePass(renodx::color::gamma::DecodeSafe(SV_Target.rgb));
  //SV_Target.rgb = renodx::draw::RenderIntermediatePass(SV_Target.rgb);
  return SV_Target;
}
