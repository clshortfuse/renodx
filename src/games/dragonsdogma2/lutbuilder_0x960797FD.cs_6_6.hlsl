#include "./shared.h"

Texture2D<float4> OCIO_lut1d_0 : register(t0);

Texture3D<float4> OCIO_lut3d_1 : register(t1);

RWTexture3D<float4> OutLUT : register(u0);

cbuffer HDRMapping : register(b0) {
  float whitePaperNits : packoffset(c000.x);
  float configImageAlphaScale : packoffset(c000.y);
  float displayMaxNits : packoffset(c000.z);
  float displayMinNits : packoffset(c000.w);
  float4 displayMaxNitsRect : packoffset(c001.x);
  float4 standardMaxNitsRect : packoffset(c002.x);
  float4 mdrOutRangeRect : packoffset(c003.x);
  uint drawMode : packoffset(c004.x);
  float gammaForHDR : packoffset(c004.y);
  float2 configDrawRectSize : packoffset(c004.z);
  float displayMaxNitsST2084 : packoffset(c005.x);
  float displayMinNitsST2084 : packoffset(c005.y);
  float2 targetInvSize : packoffset(c005.z);
  uint drawModeOnMDRPass : packoffset(c006.x);
  float saturationForHDR : packoffset(c006.y);
  float whitePaperNitsForOverlay : packoffset(c006.z);
};

SamplerState BilinearClamp : register(s5, space32);

SamplerState TrilinearClamp : register(s9, space32);

[numthreads(8, 8, 8)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  float _11 = float((uint)SV_DispatchThreadID.x);
  float _12 = float((uint)SV_DispatchThreadID.y);
  float _13 = float((uint)SV_DispatchThreadID.z);
  float _14 = _11 * 0.01587301678955555f;
  float _15 = _12 * 0.01587301678955555f;
  float _16 = _13 * 0.01587301678955555f;
  float _30;
  float _44;
  float _58;
  float _87;
  float _116;
  float _143;
  float _315;
  float _316;
  float _317;
  float _318;
  float _319;
  float _397;
  float _398;
  float _399;
  if (!(!(_14 <= -0.3013699948787689f))) {
    _30 = (exp2((_11 * 0.2780952751636505f) + -8.720000267028809f) + -3.0517578125e-05f);
  } else {
    if (_14 < 1.468000054359436f) {
      _30 = exp2((_11 * 0.2780952751636505f) + -9.720000267028809f);
    } else {
      _30 = 65504.0f;
    }
  }
  if (!(!(_15 <= -0.3013699948787689f))) {
    _44 = (exp2((_12 * 0.2780952751636505f) + -8.720000267028809f) + -3.0517578125e-05f);
  } else {
    if (_15 < 1.468000054359436f) {
      _44 = exp2((_12 * 0.2780952751636505f) + -9.720000267028809f);
    } else {
      _44 = 65504.0f;
    }
  }
  if (!(!(_16 <= -0.3013699948787689f))) {
    _58 = (exp2((_13 * 0.2780952751636505f) + -8.720000267028809f) + -3.0517578125e-05f);
  } else {
    if (_16 < 1.468000054359436f) {
      _58 = exp2((_13 * 0.2780952751636505f) + -9.720000267028809f);
    } else {
      _58 = 65504.0f;
    }
  }

  // Replace ACEScct decode with PQ decode

  // float3 pq_decode = renodx::color::pq::DecodeSafe(float3(_14, _15, _16), 100.f);
  // _30 = pq_decode.x;
  // _44 = pq_decode.y;
  // _58 = pq_decode.z;

  //float _61 = whitePaperNits * 0.009999999776482582f;
  float _61 = 1.f; // neutralize pre-tonemapping scaling

  float _62 = _61 * _30;
  float _63 = _61 * _44;
  float _64 = _61 * _58;
  float _67 = mad(_64, 0.1638689935207367f, mad(_63, 0.1406790018081665f, (_62 * 0.6954519748687744f)));
  float _70 = mad(_64, 0.0955343022942543f, mad(_63, 0.8596709966659546f, (_62 * 0.04479460045695305f)));
  float _73 = mad(_64, 1.0015000104904175f, mad(_63, 0.004025210160762072f, (_62 * -0.00552588002756238f)));
  float _74 = abs(_67);
  if (_74 > 6.103515625e-05f) {
    float _77 = min(_74, 65504.0f);
    float _79 = floor(log2(_77));
    float _80 = exp2(_79);
    _87 = dot(float3(_79, ((_77 - _80) / _80), 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
  } else {
    _87 = (_74 * 16777216.0f);
  }
  float _90 = _87 + select((_67 > 0.0f), 0.0f, 32768.0f);
  float _92 = floor(_90 * 0.00024420025874860585f);
  float4 _101 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2((((_90 + 0.5f) - (_92 * 4095.0f)) * 0.000244140625f), ((_92 + 0.5f) * 0.05882352963089943f)), 0.0f);
  float _103 = abs(_70);
  if (_103 > 6.103515625e-05f) {
    float _106 = min(_103, 65504.0f);
    float _108 = floor(log2(_106));
    float _109 = exp2(_108);
    _116 = dot(float3(_108, ((_106 - _109) / _109), 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
  } else {
    _116 = (_103 * 16777216.0f);
  }
  float _119 = _116 + select((_70 > 0.0f), 0.0f, 32768.0f);
  float _121 = floor(_119 * 0.00024420025874860585f);
  float4 _128 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2((((_119 + 0.5f) - (_121 * 4095.0f)) * 0.000244140625f), ((_121 + 0.5f) * 0.05882352963089943f)), 0.0f);
  float _130 = abs(_73);
  if (_130 > 6.103515625e-05f) {
    float _133 = min(_130, 65504.0f);
    float _135 = floor(log2(_133));
    float _136 = exp2(_135);
    _143 = dot(float3(_135, ((_133 - _136) / _136), 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
  } else {
    _143 = (_130 * 16777216.0f);
  }
  float _146 = _143 + select((_73 > 0.0f), 0.0f, 32768.0f);
  float _148 = floor(_146 * 0.00024420025874860585f);
  float4 _155 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2((((_146 + 0.5f) - (_148 * 4095.0f)) * 0.000244140625f), ((_148 + 0.5f) * 0.05882352963089943f)), 0.0f);
  float _157 = _101.x * 64.0f;
  float _158 = _128.x * 64.0f;
  float _159 = _155.x * 64.0f;

  float3 first_lut = float3(_101.x, _128.x, _155.x);

  float _160 = floor(_157);
  float _161 = floor(_158);
  float _162 = floor(_159);
  float _163 = _157 - _160;
  float _164 = _158 - _161;
  float _165 = _159 - _162;
  float _169 = (_162 + 0.5f) * 0.015384615398943424f;
  float _170 = (_161 + 0.5f) * 0.015384615398943424f;
  float _171 = (_160 + 0.5f) * 0.015384615398943424f;
  float4 _174 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_169, _170, _171), 0.0f);
  float _178 = _169 + 0.015384615398943424f;
  float _179 = _170 + 0.015384615398943424f;
  float _180 = _171 + 0.015384615398943424f;
  float4 _181 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_178, _179, _180), 0.0f);
  if (!(!(_163 >= _164))) {
    if (!(!(_164 >= _165))) {
      float4 _189 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_169, _170, _180), 0.0f);
      float4 _193 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_169, _179, _180), 0.0f);
      float _197 = _163 - _164;
      float _198 = _164 - _165;
      _315 = ((_193.x * _198) + (_189.x * _197));
      _316 = ((_193.y * _198) + (_189.y * _197));
      _317 = ((_193.z * _198) + (_189.z * _197));
      _318 = _163;
      _319 = _165;
    } else {
      if (!(!(_163 >= _165))) {
        float4 _211 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_169, _170, _180), 0.0f);
        float4 _215 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_178, _170, _180), 0.0f);
        float _219 = _163 - _165;
        float _220 = _165 - _164;
        _315 = ((_215.x * _220) + (_211.x * _219));
        _316 = ((_215.y * _220) + (_211.y * _219));
        _317 = ((_215.z * _220) + (_211.z * _219));
        _318 = _163;
        _319 = _164;
      } else {
        float4 _231 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_178, _170, _171), 0.0f);
        float4 _235 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_178, _170, _180), 0.0f);
        float _239 = _165 - _163;
        float _240 = _163 - _164;
        _315 = ((_235.x * _240) + (_231.x * _239));
        _316 = ((_235.y * _240) + (_231.y * _239));
        _317 = ((_235.z * _240) + (_231.z * _239));
        _318 = _165;
        _319 = _164;
      }
    }
  } else {
    if (!(!(_164 <= _165))) {
      float4 _253 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_178, _170, _171), 0.0f);
      float4 _257 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_178, _179, _171), 0.0f);
      float _261 = _165 - _164;
      float _262 = _164 - _163;
      _315 = ((_257.x * _262) + (_253.x * _261));
      _316 = ((_257.y * _262) + (_253.y * _261));
      _317 = ((_257.z * _262) + (_253.z * _261));
      _318 = _165;
      _319 = _163;
    } else {
      if (!(!(_163 >= _165))) {
        float4 _275 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_169, _179, _171), 0.0f);
        float4 _279 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_169, _179, _180), 0.0f);
        float _283 = _164 - _163;
        float _284 = _163 - _165;
        _315 = ((_279.x * _284) + (_275.x * _283));
        _316 = ((_279.y * _284) + (_275.y * _283));
        _317 = ((_279.z * _284) + (_275.z * _283));
        _318 = _164;
        _319 = _165;
      } else {
        float4 _295 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_169, _179, _171), 0.0f);
        float4 _299 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_178, _179, _171), 0.0f);
        float _303 = _164 - _165;
        float _304 = _165 - _163;
        _315 = ((_299.x * _304) + (_295.x * _303));
        _316 = ((_299.y * _304) + (_295.y * _303));
        _317 = ((_299.z * _304) + (_295.z * _303));
        _318 = _164;
        _319 = _163;
      }
    }
  }
  float _320 = 1.0f - _318;
  float _330 = ((_320 * _174.x) + _315) + (_319 * _181.x);
  float _331 = ((_320 * _174.y) + _316) + (_319 * _181.y);
  float _332 = ((_320 * _174.z) + _317) + (_319 * _181.z);

  float3 second_lut = float3(_330, _331, _332);

  if (!((drawMode & 2) == 0)) {
    // float _343 = exp2(log2(saturate(displayMaxNits * 9.999999747378752e-05f)) * 0.1593017578125f);
    // float _352 = saturate(exp2(log2(((_343 * 18.8515625f) + 0.8359375f) / ((_343 * 18.6875f) + 1.0f)) * 78.84375f));
    // float _358 = exp2(log2(saturate(displayMinNits * 9.999999747378752e-05f)) * 0.1593017578125f);
    // float _368 = _352 - saturate(exp2(log2(((_358 * 18.8515625f) + 0.8359375f) / ((_358 * 18.6875f) + 1.0f)) * 78.84375f));
    // float _372 = saturate(_330 / _352);
    // float _373 = saturate(_331 / _352);
    // float _374 = saturate(_332 / _352);
    // _397 = min(((((2.0f - (_372 + _372)) * _368) + (_372 * _352)) * _372), _330);
    // _398 = min(((((2.0f - (_373 + _373)) * _368) + (_373 * _352)) * _373), _331);
    // _399 = min(((((2.0f - (_374 + _374)) * _368) + (_374 * _352)) * _374), _332);
    // float3 output_color = renodx::color::pq::EncodeSafe(first_lut, 100.f);
    float3 output_color = second_lut;
    _397 = output_color.x;
    _398 = output_color.y;
    _399 = output_color.z;
  } else {
    _397 = _330;
    _398 = _331;
    _399 = _332;
  }
  OutLUT[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4(_397, _398, _399, 1.0f);
}
