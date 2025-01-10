struct _t0 {
  float data[4];
};
StructuredBuffer<_t0> t0 : register(t0);

Texture3D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t5 : register(t5);

cbuffer cb0 : register(b0) {
  float cb0_004x : packoffset(c004.x);
  float cb0_004y : packoffset(c004.y);
  float cb0_004w : packoffset(c004.w);
  float cb0_005x : packoffset(c005.x);
  float cb0_005y : packoffset(c005.y);
  float cb0_005w : packoffset(c005.w);
  float cb0_006x : packoffset(c006.x);
  float cb0_006y : packoffset(c006.y);
  float cb0_006w : packoffset(c006.w);
  float cb0_007x : packoffset(c007.x);
  float cb0_007y : packoffset(c007.y);
  float cb0_007w : packoffset(c007.w);
  float cb0_044x : packoffset(c044.x);
  float cb0_044y : packoffset(c044.y);
  float cb0_044z : packoffset(c044.z);
  float cb0_044w : packoffset(c044.w);
  float cb0_045x : packoffset(c045.x);
  float cb0_045y : packoffset(c045.y);
  float cb0_045z : packoffset(c045.z);
  float cb0_045w : packoffset(c045.w);
  float cb0_046x : packoffset(c046.x);
  float cb0_046y : packoffset(c046.y);
  float cb0_046z : packoffset(c046.z);
  float cb0_046w : packoffset(c046.w);
  float cb0_047x : packoffset(c047.x);
  float cb0_047y : packoffset(c047.y);
  float cb0_047z : packoffset(c047.z);
  float cb0_047w : packoffset(c047.w);
  float cb0_070x : packoffset(c070.x);
  float cb0_070y : packoffset(c070.y);
  float cb0_070z : packoffset(c070.z);
  float cb0_135y : packoffset(c135.y);
  float cb0_140x : packoffset(c140.x);
  float cb0_208z : packoffset(c208.z);
  float cb0_209x : packoffset(c209.x);
  float cb0_209y : packoffset(c209.y);
  float cb0_209z : packoffset(c209.z);
};

cbuffer cb1 : register(b1) {
  float cb1_114w : packoffset(c114.w);
};

cbuffer cb2 : register(b2) {
  float cb2_001x : packoffset(c001.x);
  float cb2_001y : packoffset(c001.y);
  float cb2_001z : packoffset(c001.z);
  float cb2_003w : packoffset(c003.w);
  float cb2_004x : packoffset(c004.x);
  float cb2_004y : packoffset(c004.y);
  float cb2_004z : packoffset(c004.z);
};

SamplerState s0 : register(s0);

SamplerState s1 : register(s1);

SamplerState s2 : register(s2);

SamplerState s3 : register(s3);

SamplerState s4 : register(s4);

float4 main(
  linear float4 TEXCOORD10_centroid : TEXCOORD10_centroid,
  linear float4 TEXCOORD11_centroid : TEXCOORD11_centroid,
  linear float4 TEXCOORD : TEXCOORD,
  nointerpolation uint PRIMITIVE_ID : PRIMITIVE_ID,
  linear float4 TEXCOORD_7 : TEXCOORD7,
  noperspective float4 SV_Position : SV_Position,
  nointerpolation uint SV_IsFrontFace : SV_IsFrontFace
) : SV_Target {
  float4 SV_Target;
  float _68 = (mad((SV_Position.z), (cb0_046w), (mad((SV_Position.y), (cb0_045w), ((cb0_044w) * (SV_Position.x)))))) + (cb0_047w);
  float _72 = (((mad((SV_Position.z), (cb0_046x), (mad((SV_Position.y), (cb0_045x), ((cb0_044x) * (SV_Position.x)))))) + (cb0_047x)) / _68) - (cb0_070x);
  float _73 = (((mad((SV_Position.z), (cb0_046y), (mad((SV_Position.y), (cb0_045y), ((cb0_044y) * (SV_Position.x)))))) + (cb0_047y)) / _68) - (cb0_070y);
  float _74 = (((mad((SV_Position.z), (cb0_046z), (mad((SV_Position.y), (cb0_045z), ((cb0_044z) * (SV_Position.x)))))) + (cb0_047z)) / _68) - (cb0_070z);
  float4 _75 = t2.Sample(s1, float2((TEXCOORD.x), (TEXCOORD.y)));
  float _88 = (((cb2_003w) * (TEXCOORD.x)) + -0.5f) + (cb2_004x);
  float _89 = (TEXCOORD.y) + -0.5f;
  float4 _94 = t4.Sample(s3, float2(((dot(float2(_88, _89), float2(1.0f, -0.0f))) + 0.5f), ((dot(float2(_88, _89), float2(0.0f, 1.0f))) + 0.5f)));
  float _98 = (_94.x) * (((float4)(t3.Sample(s2, float2((TEXCOORD.x), (TEXCOORD.y))))).w);
  float _101 = _98 + (_75.x);
  float _102 = ((_94.y) * (((float4)(t3.Sample(s2, float2((TEXCOORD.x), (TEXCOORD.y))))).w)) + (_75.y);
  float _103 = ((_94.z) * (((float4)(t3.Sample(s2, float2((TEXCOORD.x), (TEXCOORD.y))))).w)) + (_75.z);
  float _127 = saturate((((_98 + (_75.w)) + ((((float4)(t5.Sample(s4, float2((TEXCOORD.x), (TEXCOORD.y))))).w) * 0.10000000149011612f)) * (cb2_004z)));
  float _186 = (TEXCOORD_7.x);
  float _187 = (TEXCOORD_7.y);
  float _188 = (TEXCOORD_7.z);
  float _189 = (TEXCOORD_7.w);
  float _230;
  float _231;
  float _232;
  float _233;
  if ((((cb1_114w) > 0.0f))) {
    float _139 = (mad(_74, (cb0_006w), (mad(_73, (cb0_005w), (_72 * (cb0_004w)))))) + (cb0_007w);
    float4 _173 = t1.SampleLevel(s0, float3((((((mad(_74, (cb0_006x), (mad(_73, (cb0_005x), (_72 * (cb0_004x)))))) + (cb0_007x)) / _139) * 0.5f) + 0.5f), (0.5f - ((((mad(_74, (cb0_006y), (mad(_73, (cb0_005y), (_72 * (cb0_004y)))))) + (cb0_007y)) / _139) * 0.5f)), (((cb0_209z) * (log2((((cb0_209x) * _139) + (cb0_209y))))) * (cb0_208z))), 0.0f);
    _186 = (((_173.w) * (TEXCOORD_7.x)) + (_173.x));
    _187 = (((_173.w) * (TEXCOORD_7.y)) + (_173.y));
    _188 = (((_173.w) * (TEXCOORD_7.z)) + (_173.z));
    _189 = ((_173.w) * (TEXCOORD_7.w));
  }
  float _190 = max(((((cb2_001x) - _101) * (cb2_004y)) + _101), 0.0f);
  float _191 = max(((((cb2_001y) - _102) * (cb2_004y)) + _102), 0.0f);
  float _192 = max(((((cb2_001z) - _103) * (cb2_004y)) + _103), 0.0f);
  _230 = _127;
  _231 = _190;
  _232 = _191;
  _233 = _192;
  if ((((cb0_140x) > 0.0f))) {
    uint _197 = 197 * ((uint)(PRIMITIVE_ID));
    /* _t0 _199 = t0.Load(((uint)(_197 + 5)));
    _t0 _210 = t0.Load(((uint)(_197 + 19))); */

    _t0 temp_199 = t0.Load(((uint)(_197 + 5)));
    _t0 temp_210 = t0.Load(((uint)(_197 + 19)));

    float4 _199 = temp_199.data[0 / 4];
    float4 _210 = temp_210.data[0 / 4];

    _230 = _127;
    _231 = _190;
    _232 = _191;
    _233 = _192;
    if ((((bool)(((abs((_74 - (_199.z)))) > ((_210.z) + 1.0f)))) || ((bool)(((bool)(((abs((_72 - (_199.x)))) > ((_210.x) + 1.0f)))) || ((bool)(((abs((_73 - (_199.y)))) > ((_210.y) + 1.0f)))))))) {
      float _227 = float((uint)((bool)(((frac(((dot(float3(_72, _73, _74), float3(0.5770000219345093f, 0.5770000219345093f, 0.5770000219345093f))) * 0.0020000000949949026f))) > 0.5f))));
      _230 = 1.0f;
      _231 = (1.0f - _227);
      _232 = 1.0f;
      _233 = _227;
    }
  }
  SV_Target.x = ((cb0_135y) * ((_231 * _189) + _186));
  SV_Target.y = ((cb0_135y) * ((_232 * _189) + _187));
  SV_Target.z = (((_233 * _189) + _188) * (cb0_135y));
  SV_Target.rgb = saturate(SV_Target.rgb);
  SV_Target.w = _230;
  return SV_Target;
}
