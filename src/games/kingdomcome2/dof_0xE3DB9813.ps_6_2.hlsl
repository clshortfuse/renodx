Texture2D<float4> CDOF_HDRDoF1 : register(t2);

Texture2D<float4> CDOF_HDRDoF0 : register(t1);

Texture2D<float4> CDOF_STarg : register(t3);

Texture2D<float4> CDOF_Depth : register(t0);

cbuffer PER_BATCH : register(b0, space1) {
  float PER_BATCH_000x : packoffset(c000.x);
  float PER_BATCH_000y : packoffset(c000.y);
  float PER_BATCH_001w : packoffset(c001.w);
  float PER_BATCH_002x : packoffset(c002.x);
  float PER_BATCH_002y : packoffset(c002.y);
  float PER_BATCH_003y : packoffset(c003.y);
  float PER_BATCH_004x : packoffset(c004.x);
  float PER_BATCH_004y : packoffset(c004.y);
};

SamplerState CDOF_PCSamp : register(s4);

SamplerState CDOF_LCSamp : register(s5);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _10 = CDOF_STarg.Sample(CDOF_PCSamp, float2((TEXCOORD.x), (TEXCOORD.y)));
  float _18 = (PER_BATCH_004x) * 0.5f;
  float _19 = (PER_BATCH_004y) * 0.5f;
  float _22 = (_18 * (TEXCOORD.x)) + 0.5f;
  float _23 = (_19 * (TEXCOORD.y)) + 0.5f;
  float _26 = frac(_22);
  float _27 = frac(_23);
  float _34 = ((((((_26 * 2.0f) + -3.0f) * _26) + -3.0f) * _26) + 5.0f) * 0.1666666716337204f;
  float _35 = _26 * 3.0f;
  float _42 = ((((((3.0f - _35) + _26) * _26) + 3.0f) * _26) + 1.0f) * 0.1666666716337204f;
  float _43 = _26 * _26;
  float _54 = _27 * _27;
  float _55 = _27 * 3.0f;
  float _66 = ((((((_27 * 2.0f) + -3.0f) * _27) + -3.0f) * _27) + 5.0f) * 0.1666666716337204f;
  float _77 = ((((((3.0f - _55) + _27) * _27) + 3.0f) * _27) + 1.0f) * 0.1666666716337204f;
  float _80 = (floor(_22)) + -0.5f;
  float _82 = (floor(_23)) + -0.5f;
  float _84 = (_80 + (((((_43 * (_35 + -6.0f)) + 4.0f) * 0.1666666716337204f) / _34) + -1.0f)) / _18;
  float _85 = (_82 + (((((_54 * (_55 + -6.0f)) + 4.0f) * 0.1666666716337204f) / _66) + -1.0f)) / _19;
  float _87 = (_80 + ((((_43 * 0.1666666716337204f) * _26) / _42) + 1.0f)) / _18;
  float _89 = (_82 + ((((_54 * 0.1666666716337204f) * _27) / _77) + 1.0f)) / _19;
  float4 _90 = CDOF_HDRDoF0.Sample(CDOF_LCSamp, float2(_84, _85));
  float4 _99 = CDOF_HDRDoF0.Sample(CDOF_LCSamp, float2(_87, _85));
  float4 _116 = CDOF_HDRDoF0.Sample(CDOF_LCSamp, float2(_84, _89));
  float4 _125 = CDOF_HDRDoF0.Sample(CDOF_LCSamp, float2(_87, _89));
  float _145 = ((((_125.w) * _42) + ((_116.w) * _34)) * _77) + ((((_99.w) * _42) + ((_90.w) * _34)) * _66);
  float _149 = (PER_BATCH_004x) * 0.5f;
  float _150 = (PER_BATCH_004y) * 0.5f;
  float _153 = (_149 * (TEXCOORD.x)) + 0.5f;
  float _154 = (_150 * (TEXCOORD.y)) + 0.5f;
  float _157 = frac(_153);
  float _158 = frac(_154);
  float _165 = ((((((_157 * 2.0f) + -3.0f) * _157) + -3.0f) * _157) + 5.0f) * 0.1666666716337204f;
  float _166 = _157 * 3.0f;
  float _173 = ((((((3.0f - _166) + _157) * _157) + 3.0f) * _157) + 1.0f) * 0.1666666716337204f;
  float _174 = _157 * _157;
  float _185 = _158 * _158;
  float _186 = _158 * 3.0f;
  float _197 = ((((((_158 * 2.0f) + -3.0f) * _158) + -3.0f) * _158) + 5.0f) * 0.1666666716337204f;
  float _208 = ((((((3.0f - _186) + _158) * _158) + 3.0f) * _158) + 1.0f) * 0.1666666716337204f;
  float _211 = (floor(_153)) + -0.5f;
  float _213 = (floor(_154)) + -0.5f;
  float _215 = (_211 + (((((_174 * (_166 + -6.0f)) + 4.0f) * 0.1666666716337204f) / _165) + -1.0f)) / _149;
  float _216 = (_213 + (((((_185 * (_186 + -6.0f)) + 4.0f) * 0.1666666716337204f) / _197) + -1.0f)) / _150;
  float _218 = (_211 + ((((_174 * 0.1666666716337204f) * _157) / _173) + 1.0f)) / _149;
  float _220 = (_213 + ((((_185 * 0.1666666716337204f) * _158) / _208) + 1.0f)) / _150;
  float4 _221 = CDOF_HDRDoF1.Sample(CDOF_LCSamp, float2(_215, _216));
  float4 _230 = CDOF_HDRDoF1.Sample(CDOF_LCSamp, float2(_218, _216));
  float4 _247 = CDOF_HDRDoF1.Sample(CDOF_LCSamp, float2(_215, _220));
  float4 _256 = CDOF_HDRDoF1.Sample(CDOF_LCSamp, float2(_218, _220));
  float _276 = ((((_256.w) * _173) + ((_247.w) * _165)) * _208) + ((((_230.w) * _173) + ((_221.w) * _165)) * _197);
  float4 _282 = CDOF_Depth.GatherRed(CDOF_PCSamp, float2(((TEXCOORD.x) - (PER_BATCH_000x)), ((TEXCOORD.y) - (PER_BATCH_000y))));
  float _304 = saturate(((((PER_BATCH_003y) * (_282.x)) * (PER_BATCH_002x)) + (PER_BATCH_002y)));
  float _305 = saturate(((((PER_BATCH_003y) * (_282.y)) * (PER_BATCH_002x)) + (PER_BATCH_002y)));
  float _306 = saturate(((((PER_BATCH_003y) * (_282.z)) * (PER_BATCH_002x)) + (PER_BATCH_002y)));
  float _307 = saturate(((((PER_BATCH_003y) * (_282.w)) * (PER_BATCH_002x)) + (PER_BATCH_002y)));
  float _326 = min((max((max(((_304 * _304) * (PER_BATCH_001w)), 9.999999747378752e-06f)), -4.0f)), 4.0f);
  float _327 = min((max((max(((_305 * _305) * (PER_BATCH_001w)), 9.999999747378752e-06f)), -4.0f)), 4.0f);
  float _328 = min((max((max(((_306 * _306) * (PER_BATCH_001w)), 9.999999747378752e-06f)), -4.0f)), 4.0f);
  float _329 = min((max((max(((_307 * _307) * (PER_BATCH_001w)), 9.999999747378752e-06f)), -4.0f)), 4.0f);
  float _332 = min((min(_326, _328)), (min(_327, _329)));
  float _335 = max((max(_326, _328)), (max(_327, _329)));
  float _339 = saturate(((_276 - _332) / (_335 - _332)));
  float _343 = (_339 * _339) * (3.0f - (_339 * 2.0f));
  float _346 = saturate(_332);
  float _351 = (((bool)((_276 > 0.0f))) ? _276 : 1.0f);
  float _355 = saturate((((_343 * _343) * ((saturate(_335)) - _346)) + _346));
  float _364 = (_355 * (((((((_256.x) * _173) + ((_247.x) * _165)) * _208) + ((((_230.x) * _173) + ((_221.x) * _165)) * _197)) / _351) - (_10.x))) + (_10.x);
  float _365 = (_355 * (((((((_256.y) * _173) + ((_247.y) * _165)) * _208) + ((((_230.y) * _173) + ((_221.y) * _165)) * _197)) / _351) - (_10.y))) + (_10.y);
  float _366 = (_355 * (((((((_256.z) * _173) + ((_247.z) * _165)) * _208) + ((((_230.z) * _173) + ((_221.z) * _165)) * _197)) / _351) - (_10.z))) + (_10.z);
  float _367 = ((_355 - (_10.w)) * _355) + (_10.w);
  float _369 = (((bool)((_145 > 0.0f))) ? _145 : 1.0f);
  float _373 = saturate(_145);
  SV_Target.x = ((_373 * (((((((_125.x) * _42) + ((_116.x) * _34)) * _77) + ((((_99.x) * _42) + ((_90.x) * _34)) * _66)) / _369) - _364)) + _364);
  SV_Target.y = ((_373 * (((((((_125.y) * _42) + ((_116.y) * _34)) * _77) + ((((_99.y) * _42) + ((_90.y) * _34)) * _66)) / _369) - _365)) + _365);
  SV_Target.z = ((_373 * (((((((_125.z) * _42) + ((_116.z) * _34)) * _77) + ((((_99.z) * _42) + ((_90.z) * _34)) * _66)) / _369) - _366)) + _366);
  SV_Target.w = (((_373 - _367) * _373) + _367);

  return SV_Target;
}
