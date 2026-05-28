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
  float _255;
  float _256;
  float _257;
  float _109;
  float _134;
  float _135;
  float _136;
  float _139;
  float _140;
  float _141;
  float _142;
  float _143;
  float _148;
  float _152;
  float _159;
  float _160;
  float _161;
  float _162;
  float _187;
  float _188;
  float _189;
  float4 _213;
  float _219;
  float _223;
  float _231;
  float _232;
  float _233;
  float _234;
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
  _134 = min((((cbPostChainMerge.fRcpMappedWhitePoint * (((cbPostChainMerge.vVignetteParams.x + -1.0f) * _33.z) + 1.0f)) * ((((cbPostChainMerge.fGlareStrength * _63.x) * cbPostChainMerge.vColorTint.x) * _111) + ((cbPostChainMerge.vColorTint.x * _58.x) * _99))) + (cbPostChainMerge.vParams2.x * _33.w)), _88);
  _135 = min((((cbPostChainMerge.fRcpMappedWhitePoint * (((cbPostChainMerge.vVignetteParams.y + -1.0f) * _33.z) + 1.0f)) * ((((cbPostChainMerge.fGlareStrength * _63.y) * cbPostChainMerge.vColorTint.y) * _111) + ((cbPostChainMerge.vColorTint.y * _58.y) * _99))) + (cbPostChainMerge.vParams2.y * _33.w)), _88);
  _136 = min((((cbPostChainMerge.fRcpMappedWhitePoint * (((cbPostChainMerge.vVignetteParams.z + -1.0f) * _33.z) + 1.0f)) * ((((cbPostChainMerge.fGlareStrength * _63.z) * cbPostChainMerge.vColorTint.z) * _111) + ((cbPostChainMerge.vColorTint.z * _58.z) * _99))) + (cbPostChainMerge.vParams2.z * _33.w)), _88);
  _139 = max(_134, max(_135, _136));
  _140 = max(1.0f, _139);
  _141 = _134 / _140;
  _142 = _135 / _140;
  _143 = _136 / _140;
  _148 = saturate(_88 + -1.0f);
  _152 = saturate((_139 - _148) / (_88 - _148));
  _159 = (_152 * (saturate(_134) - _141)) + _141;
  _160 = (_152 * (saturate(_135) - _142)) + _142;
  _161 = (_152 * (saturate(_136) - _143)) + _143;
  _162 = dot(float3(_159, _160, _161), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  _187 = _159 * 12.920000076293945f;
  _188 = _160 * 12.920000076293945f;
  _189 = _161 * 12.920000076293945f;
  _213 = srvColorCorrectionVolume.SampleLevel(samplerLinearClampNode, float3(((saturate((((-0.054999999701976776f - _187) + (exp2(log2(abs(_159)) * 0.4166666567325592f) * 1.0549999475479126f)) * float((bool)(uint)(_159 > 0.0031308000907301903f))) + _187) * 0.9375f) + 0.03125f), ((saturate((((-0.054999999701976776f - _188) + (exp2(log2(abs(_160)) * 0.4166666567325592f) * 1.0549999475479126f)) * float((bool)(uint)(_160 > 0.0031308000907301903f))) + _188) * 0.9375f) + 0.03125f), ((saturate((((-0.054999999701976776f - _189) + (exp2(log2(abs(_161)) * 0.4166666567325592f) * 1.0549999475479126f)) * float((bool)(uint)(_161 > 0.0031308000907301903f))) + _189) * 0.9375f) + 0.03125f)), 0.0f);
  _219 = exp2(log2(dot(float3(_134, _135, _136), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f)) / select((_162 > 0.0f), _162, 1.0f)) * 0.4545454680919647f);
  _223 = cbPostChainMerge.vHDRParams.x * 0.009999999776482582f;
  _231 = (pow(cbPostChainMerge.vHDRParams.w, 0.4545454680919647f));
  _232 = _231 * ((_219 * _213.x) + _223);
  _233 = _231 * ((_219 * _213.y) + _223);
  _234 = _231 * ((_219 * _213.z) + _223);
  if (cbPostChainMerge.fOptionalGammaAdjust > 0.0f) {
    _255 = saturate(exp2(log2(max(_232, 0.0f)) * cbPostChainMerge.fOptionalGammaAdjust));
    _256 = saturate(exp2(log2(max(_233, 0.0f)) * cbPostChainMerge.fOptionalGammaAdjust));
    _257 = saturate(exp2(log2(max(_234, 0.0f)) * cbPostChainMerge.fOptionalGammaAdjust));
  } else {
    _255 = _232;
    _256 = _233;
    _257 = _234;
  }
  float3 output = float3((cbPostChainMerge.fFadeValue * _255),
                         (cbPostChainMerge.fFadeValue * _256),
                         (cbPostChainMerge.fFadeValue * _257));
  // output = DrawPostChainMergeCBufferDebug(output, float2((float)(SV_DispatchThreadID.x), (float)(SV_DispatchThreadID.y)));
  uavOutput1[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float4(output, 0.0f);
}
