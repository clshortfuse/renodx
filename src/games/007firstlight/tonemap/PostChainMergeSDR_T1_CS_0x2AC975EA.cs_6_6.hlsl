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
  float _261;
  float _262;
  float _263;
  float _109;
  float _115;
  float _116;
  float _117;
  float _140;
  float _141;
  float _142;
  float _145;
  float _146;
  float _147;
  float _148;
  float _149;
  float _154;
  float _158;
  float _165;
  float _166;
  float _167;
  float _168;
  float _193;
  float _194;
  float _195;
  float4 _219;
  float _225;
  float _229;
  float _237;
  float _238;
  float _239;
  float _240;
  float _269;
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
  _140 = min(((cbPostChainMerge.vParams2.x * _33.w) + ((cbPostChainMerge.fRcpMappedWhitePoint * (((cbPostChainMerge.vVignetteParams.x + -1.0f) * _33.z) + 1.0f)) * (_115 / (_115 + 1.0f)))), _88);
  _141 = min(((cbPostChainMerge.vParams2.y * _33.w) + ((cbPostChainMerge.fRcpMappedWhitePoint * (((cbPostChainMerge.vVignetteParams.y + -1.0f) * _33.z) + 1.0f)) * (_116 / (_116 + 1.0f)))), _88);
  _142 = min(((cbPostChainMerge.vParams2.z * _33.w) + ((cbPostChainMerge.fRcpMappedWhitePoint * (((cbPostChainMerge.vVignetteParams.z + -1.0f) * _33.z) + 1.0f)) * (_117 / (_117 + 1.0f)))), _88);
  _145 = max(_140, max(_141, _142));
  _146 = max(1.0f, _145);
  _147 = _140 / _146;
  _148 = _141 / _146;
  _149 = _142 / _146;
  _154 = saturate(_88 + -1.0f);
  _158 = saturate((_145 - _154) / (_88 - _154));
  _165 = (_158 * (saturate(_140) - _147)) + _147;
  _166 = (_158 * (saturate(_141) - _148)) + _148;
  _167 = (_158 * (saturate(_142) - _149)) + _149;
  _168 = dot(float3(_165, _166, _167), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  _193 = _165 * 12.920000076293945f;
  _194 = _166 * 12.920000076293945f;
  _195 = _167 * 12.920000076293945f;
  _219 = srvColorCorrectionVolume.SampleLevel(samplerLinearClampNode, float3(((saturate((((-0.054999999701976776f - _193) + (exp2(log2(abs(_165)) * 0.4166666567325592f) * 1.0549999475479126f)) * float((bool)(uint)(_165 > 0.0031308000907301903f))) + _193) * 0.9375f) + 0.03125f), ((saturate((((-0.054999999701976776f - _194) + (exp2(log2(abs(_166)) * 0.4166666567325592f) * 1.0549999475479126f)) * float((bool)(uint)(_166 > 0.0031308000907301903f))) + _194) * 0.9375f) + 0.03125f), ((saturate((((-0.054999999701976776f - _195) + (exp2(log2(abs(_167)) * 0.4166666567325592f) * 1.0549999475479126f)) * float((bool)(uint)(_167 > 0.0031308000907301903f))) + _195) * 0.9375f) + 0.03125f)), 0.0f);
  _225 = exp2(log2(dot(float3(_140, _141, _142), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f)) / select((_168 > 0.0f), _168, 1.0f)) * 0.4545454680919647f);
  _229 = cbPostChainMerge.vHDRParams.x * 0.009999999776482582f;
  _237 = (pow(cbPostChainMerge.vHDRParams.w, 0.4545454680919647f));
  _238 = _237 * ((_225 * _219.x) + _229);
  _239 = _237 * ((_225 * _219.y) + _229);
  _240 = _237 * ((_225 * _219.z) + _229);
  if (cbPostChainMerge.fOptionalGammaAdjust > 0.0f) {
    _261 = saturate(exp2(log2(max(_238, 0.0f)) * cbPostChainMerge.fOptionalGammaAdjust));
    _262 = saturate(exp2(log2(max(_239, 0.0f)) * cbPostChainMerge.fOptionalGammaAdjust));
    _263 = saturate(exp2(log2(max(_240, 0.0f)) * cbPostChainMerge.fOptionalGammaAdjust));
  } else {
    _261 = _238;
    _262 = _239;
    _263 = _240;
  }
  _269 = (frac(sin(dot(float2(_20, _21), float2(12.989800453186035f, 78.23300170898438f))) * 43758.546875f) * 0.003921568859368563f) + -0.0019607844296842813f;
  float3 output = float3(((_269 + _261) * cbPostChainMerge.fFadeValue),
                         ((_269 + _262) * cbPostChainMerge.fFadeValue),
                         ((_269 + _263) * cbPostChainMerge.fFadeValue));
  // output = DrawPostChainMergeCBufferDebug(output, float2((float)(SV_DispatchThreadID.x), (float)(SV_DispatchThreadID.y)));
  uavOutput1[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float4(output, 0.0f);
}
