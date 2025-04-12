Texture3D<float4> HDR_TEX_3D_PREV : register(t5, space2);

Texture3D<float4> HDR_TEX_3D_NEXT : register(t6, space2);

RWTexture3D<float4> HDR_LUT_OUT : register(u1);

cbuffer CB_PASS_HDR : register(b4) {
  float CB_PASS_HDR_003x : packoffset(c003.x);
  float CB_PASS_HDR_003y : packoffset(c003.y);
  float CB_PASS_HDR_003z : packoffset(c003.z);
  float CB_PASS_HDR_003w : packoffset(c003.w);
  float CB_PASS_HDR_004x : packoffset(c004.x);
  float CB_PASS_HDR_004y : packoffset(c004.y);
  float CB_PASS_HDR_004w : packoffset(c004.w);
  float CB_PASS_HDR_005x : packoffset(c005.x);
  float CB_PASS_HDR_005y : packoffset(c005.y);
  float CB_PASS_HDR_005z : packoffset(c005.z);
  float CB_PASS_HDR_005w : packoffset(c005.w);
  float CB_PASS_HDR_006x : packoffset(c006.x);
  float CB_PASS_HDR_008z : packoffset(c008.z);
  float CB_PASS_HDR_008w : packoffset(c008.w);
};

SamplerState PS_SAMPLERS[12] : register(s0, space1);

[numthreads(4, 4, 4)]
void main(
 uint3 SV_DispatchThreadID : SV_DispatchThreadID,
 uint3 SV_GroupID : SV_GroupID,
 uint3 SV_GroupThreadID : SV_GroupThreadID,
 uint SV_GroupIndex : SV_GroupIndex
) {
  float _44 = max(0.0f, ((exp2((-0.0f - ((CB_PASS_HDR_008w) * (CB_PASS_HDR_008z))))) * 0.18000000715255737f));
  float _45 = (max(0.0f, ((exp2(((((float((uint)(SV_DispatchThreadID.x))) * 0.032258063554763794f) - (CB_PASS_HDR_008w)) * (CB_PASS_HDR_008z)))) * 0.18000000715255737f))) - _44;
  float _46 = (max(0.0f, ((exp2(((((float((uint)(SV_DispatchThreadID.y))) * 0.032258063554763794f) - (CB_PASS_HDR_008w)) * (CB_PASS_HDR_008z)))) * 0.18000000715255737f))) - _44;
  float _47 = (max(0.0f, ((exp2(((((float((uint)(SV_DispatchThreadID.z))) * 0.032258063554763794f) - (CB_PASS_HDR_008w)) * (CB_PASS_HDR_008z)))) * 0.18000000715255737f))) - _44;
  float _49 = _45 * (CB_PASS_HDR_003x);
  float _50 = _46 * (CB_PASS_HDR_003x);
  float _51 = _47 * (CB_PASS_HDR_003x);
  float _52 = (CB_PASS_HDR_003z) * (CB_PASS_HDR_003y);
  float _59 = (CB_PASS_HDR_004x) * (CB_PASS_HDR_003w);
  float _69 = (CB_PASS_HDR_004y) * (CB_PASS_HDR_003w);
  float _76 = (CB_PASS_HDR_004x) / (CB_PASS_HDR_004y);
  float _83 = saturate(((((((_49 + _52) * _45) + _59) / (((_49 + (CB_PASS_HDR_003y)) * _45) + _69)) - _76) * (CB_PASS_HDR_004w)));
  float _84 = saturate(((((((_50 + _52) * _46) + _59) / (((_50 + (CB_PASS_HDR_003y)) * _46) + _69)) - _76) * (CB_PASS_HDR_004w)));
  float _85 = saturate(((((((_51 + _52) * _47) + _59) / (((_51 + (CB_PASS_HDR_003y)) * _47) + _69)) - _76) * (CB_PASS_HDR_004w)));
  float _96;
  float _107;
  float _118;
  if (((_83 < 0.0031308000907301903f))) {
    _96 = (_83 * 12.920000076293945f);
  } else {
    _96 = (((exp2(((log2(_83)) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (((_84 < 0.0031308000907301903f))) {
    _107 = (_84 * 12.920000076293945f);
  } else {
    _107 = (((exp2(((log2(_84)) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (((_85 < 0.0031308000907301903f))) {
    _118 = (_85 * 12.920000076293945f);
  } else {
    _118 = (((exp2(((log2(_85)) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float4 _129 = HDR_TEX_3D_PREV.SampleLevel(PS_SAMPLERS[4], float3((((CB_PASS_HDR_005x) * _96) + (CB_PASS_HDR_005y)), (((CB_PASS_HDR_005x) * _107) + (CB_PASS_HDR_005y)), (((CB_PASS_HDR_005x) * _118) + (CB_PASS_HDR_005y))), 0.0f);
  float4 _142 = HDR_TEX_3D_NEXT.SampleLevel(PS_SAMPLERS[4], float3((((CB_PASS_HDR_005z) * _96) + (CB_PASS_HDR_005w)), (((CB_PASS_HDR_005z) * _107) + (CB_PASS_HDR_005w)), (((CB_PASS_HDR_005z) * _118) + (CB_PASS_HDR_005w))), 0.0f);
  HDR_LUT_OUT[int3(((uint)(SV_DispatchThreadID.x)), ((uint)(SV_DispatchThreadID.y)), ((uint)(SV_DispatchThreadID.z)))] = float4((((CB_PASS_HDR_006x) * ((_142.x) - (_129.x))) + (_129.x)), (((CB_PASS_HDR_006x) * ((_142.y) - (_129.y))) + (_129.y)), (((CB_PASS_HDR_006x) * ((_142.z) - (_129.z))) + (_129.z)), 0.0f);
}
