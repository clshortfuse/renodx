#include "./tonemap.hlsli"

struct SHDRAdaptationState {
  float m_fLuminanceGeometricMean;
  float m_fAdaptedMiddleGray;
  float m_fAdaptedBloomPoint;
  float m_fAdaptedBloomPointThreshold;
  float m_fAdaptedBloomPointClamp;
  float m_fAdaptedLuminance;
  float m_fAdaptedExposure;
  float m_fAdaptedBrightPassThreshold;
  float m_fAdaptedBrightPassClamp;
};

Texture2D<float4> mapLinearLightTexture : register(t0);

Texture2D<float4> mapGlareTexture : register(t1);

Texture3D<float4> srvColorCorrectionVolume : register(t2);

Texture2D<float4> mapGridTexture : register(t3);

StructuredBuffer<SHDRAdaptationState> srvHDRAdaptationState : register(t6);

Texture2D<float> srvExposures : register(t14);

RWTexture2D<float4> uavOutput1 : register(u0);

SamplerState samplerLinearClampNode : register(s4);

[numthreads(8, 8, 1)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _20;
  float _21;
  float4 _33;
  float _42;
  float _43;
  float4 _58;
  float4 _63;
  float _88;
  float _99;
  float _111;
  float _282;
  float _283;
  float _284;
  float _109;
  float _115;
  float _116;
  float _117;
  float _118;
  float _127;
  float _136;
  float _161;
  float _162;
  float _163;
  float _166;
  float _167;
  float _168;
  float _169;
  float _170;
  float _175;
  float _179;
  float _186;
  float _187;
  float _188;
  float _189;
  float _214;
  float _215;
  float _216;
  float4 _240;
  float _246;
  float _250;
  float _258;
  float _259;
  float _260;
  float _261;
  _20 = cbPostChainMerge.vPixelSize.x * (float((int)((int)(SV_DispatchThreadID.x))) + 0.5f);
  _21 = (float((int)((int)(SV_DispatchThreadID.y))) + 0.5f) * cbPostChainMerge.vPixelSize.y;
  _33 = mapGridTexture.SampleLevel(samplerLinearClampNode, float2(((_20 * cbPostChainMerge.vUVToGridUV.x) + cbPostChainMerge.vUVToGridUV.z), ((_21 * cbPostChainMerge.vUVToGridUV.y) + cbPostChainMerge.vUVToGridUV.w)), 0.0f);
  _42 = (cbPostChainMerge.fMaxUVDistortion * _33.x) + _20;
  _43 = (cbPostChainMerge.fMaxUVDistortion * _33.y) + _21;
  _58 = mapLinearLightTexture.SampleLevel(samplerLinearClampNode, float2(_42, _43), 0.0f);
  _63 = mapGlareTexture.SampleLevel(samplerLinearClampNode, float2(_42, _43), 0.0f);
  _88 = max((cbPostChainMerge.vHDRParams.y - cbPostChainMerge.vHDRParams.x), cbPostChainMerge.vHDRParams.z) / cbPostChainMerge.vHDRParams.z;
  if (!(cbPostChainMerge.nApplyExposure == 0)) {
    _99 = ((srvExposures.SampleLevel(samplerLinearClampNode, float2(_20, _21), 0.0f)).x);
  } else {
    _99 = 1.0f;
  }
  if (!(cbPostChainMerge.nApplyExposure == 0)) {
    _109 = srvHDRAdaptationState[0].m_fAdaptedExposure;
    _111 = _109;
  } else {
    _111 = 1.0f;
  }
  _115 = (((cbPostChainMerge.fGlareStrength * _63.x) * cbPostChainMerge.vColorTint.x) * _111) + ((cbPostChainMerge.vColorTint.x * _58.x) * _99);
  _116 = (((cbPostChainMerge.fGlareStrength * _63.y) * cbPostChainMerge.vColorTint.y) * _111) + ((cbPostChainMerge.vColorTint.y * _58.y) * _99);
  _117 = (((cbPostChainMerge.fGlareStrength * _63.z) * cbPostChainMerge.vColorTint.z) * _111) + ((cbPostChainMerge.vColorTint.z * _58.z) * _99);
  _118 = _115 * 0.6000000238418579f;
  _127 = _116 * 0.6000000238418579f;
  _136 = _117 * 0.6000000238418579f;
  _161 = min(((cbPostChainMerge.vParams2.x * _33.w) + ((cbPostChainMerge.fRcpMappedWhitePoint * (((cbPostChainMerge.vVignetteParams.x + -1.0f) * _33.z) + 1.0f)) * (((((_118 + 0.10000000149011612f) * _115) + 0.004000000189989805f) / (((_118 + 1.0f) * _115) + 0.06000000238418579f)) + -0.06666666269302368f))), _88);
  _162 = min(((cbPostChainMerge.vParams2.y * _33.w) + ((cbPostChainMerge.fRcpMappedWhitePoint * (((cbPostChainMerge.vVignetteParams.y + -1.0f) * _33.z) + 1.0f)) * (((((_127 + 0.10000000149011612f) * _116) + 0.004000000189989805f) / (((_127 + 1.0f) * _116) + 0.06000000238418579f)) + -0.06666666269302368f))), _88);
  _163 = min((((cbPostChainMerge.fRcpMappedWhitePoint * (((cbPostChainMerge.vVignetteParams.z + -1.0f) * _33.z) + 1.0f)) * (((((_136 + 0.10000000149011612f) * _117) + 0.004000000189989805f) / (((_136 + 1.0f) * _117) + 0.06000000238418579f)) + -0.06666666269302368f)) + (cbPostChainMerge.vParams2.z * _33.w)), _88);
  _166 = max(_161, max(_162, _163));
  _167 = max(1.0f, _166);
  _168 = _161 / _167;
  _169 = _162 / _167;
  _170 = _163 / _167;
  _175 = saturate(_88 + -1.0f);
  _179 = saturate((_166 - _175) / (_88 - _175));
  _186 = (_179 * (saturate(_161) - _168)) + _168;
  _187 = (_179 * (saturate(_162) - _169)) + _169;
  _188 = (_179 * (saturate(_163) - _170)) + _170;
  _189 = dot(float3(_186, _187, _188), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  _214 = _186 * 12.920000076293945f;
  _215 = _187 * 12.920000076293945f;
  _216 = _188 * 12.920000076293945f;
  _240 = srvColorCorrectionVolume.SampleLevel(samplerLinearClampNode, float3(((saturate((((-0.054999999701976776f - _214) + (exp2(log2(abs(_186)) * 0.4166666567325592f) * 1.0549999475479126f)) * float((bool)(uint)(_186 > 0.0031308000907301903f))) + _214) * 0.9375f) + 0.03125f), ((saturate((((-0.054999999701976776f - _215) + (exp2(log2(abs(_187)) * 0.4166666567325592f) * 1.0549999475479126f)) * float((bool)(uint)(_187 > 0.0031308000907301903f))) + _215) * 0.9375f) + 0.03125f), ((saturate((((-0.054999999701976776f - _216) + (exp2(log2(abs(_188)) * 0.4166666567325592f) * 1.0549999475479126f)) * float((bool)(uint)(_188 > 0.0031308000907301903f))) + _216) * 0.9375f) + 0.03125f)), 0.0f);
  _246 = exp2(log2(dot(float3(_161, _162, _163), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f)) / select((_189 > 0.0f), _189, 1.0f)) * 0.4545454680919647f);
  _250 = cbPostChainMerge.vHDRParams.x * 0.009999999776482582f;
  _258 = (pow(cbPostChainMerge.vHDRParams.w, 0.4545454680919647f));
  _259 = _258 * ((_246 * _240.x) + _250);
  _260 = _258 * ((_246 * _240.y) + _250);
  _261 = _258 * ((_246 * _240.z) + _250);
  if (cbPostChainMerge.fOptionalGammaAdjust > 0.0f) {
    _282 = saturate(exp2(log2(max(_259, 0.0f)) * cbPostChainMerge.fOptionalGammaAdjust));
    _283 = saturate(exp2(log2(max(_260, 0.0f)) * cbPostChainMerge.fOptionalGammaAdjust));
    _284 = saturate(exp2(log2(max(_261, 0.0f)) * cbPostChainMerge.fOptionalGammaAdjust));
  } else {
    _282 = _259;
    _283 = _260;
    _284 = _261;
  }
  float3 output = float3((cbPostChainMerge.fFadeValue * _282),
                         (cbPostChainMerge.fFadeValue * _283),
                         (cbPostChainMerge.fFadeValue * _284));
  output = DrawPostChainMergeCBufferDebug(output, float2((float)(SV_DispatchThreadID.x), (float)(SV_DispatchThreadID.y)));
  uavOutput1[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float4(output, 0.0f);
}
