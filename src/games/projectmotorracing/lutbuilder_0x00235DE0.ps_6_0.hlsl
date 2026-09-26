Texture3D<float4> colorGradingLUT0 : register(t0);

Texture3D<float4> colorGradingLUT1 : register(t1);

Texture3D<float4> colorGradingLUT2 : register(t2);

Texture3D<float4> colorGradingLUT3 : register(t3);

cbuffer LUTColorGradingParams : register(b0) {
  float4 g_globalColorSaturation : packoffset(c000.x);
  float4 g_globalColorContrast : packoffset(c001.x);
  float4 g_globalColorGamma : packoffset(c002.x);
  float4 g_globalColorGain : packoffset(c003.x);
  float4 g_shadowsColorSaturation : packoffset(c004.x);
  float4 g_shadowsColorContrast : packoffset(c005.x);
  float4 g_shadowsColorGamma : packoffset(c006.x);
  float4 g_shadowsColorGain : packoffset(c007.x);
  float4 g_midTonesColorSaturation : packoffset(c008.x);
  float4 g_midTonesColorContrast : packoffset(c009.x);
  float4 g_midTonesColorGamma : packoffset(c010.x);
  float4 g_midTonesColorGain : packoffset(c011.x);
  float4 g_highLightsColorSaturation : packoffset(c012.x);
  float4 g_highLightsColorContrast : packoffset(c013.x);
  float4 g_highLightsColorGamma : packoffset(c014.x);
  float4 g_highLightsColorGain : packoffset(c015.x);
  float g_shadowsMax : packoffset(c016.x);
  float g_highLightsMin : packoffset(c016.y);
  float g_whiteTeperature : packoffset(c016.z);
  float g_teperatureTint : packoffset(c016.w);
  float g_preTonemapDesaturation : packoffset(c017.x);
  float g_postTonemapDesaturation : packoffset(c017.y);
  float g_lutParam2 : packoffset(c017.z);
  float g_lutParam3 : packoffset(c017.w);
  float g_hiDesatStartEV : packoffset(c018.x);
  float g_hiDesatEndEV : packoffset(c018.y);
  float g_hiDesatStrength : packoffset(c018.z);
  float g_gamutDesatStart : packoffset(c018.w);
  float g_gamutDesatEnd : packoffset(c019.x);
  float g_gamutDesatAmount : packoffset(c019.y);
  float g_disableWhiteBalance : packoffset(c019.z);
};

cbuffer VolumeSliceIndex : register(b1) {
  float g_sliceIndex : packoffset(c000.x);
};

cbuffer LUTTextureBlendParams : register(b2) {
  float4 g_lutTextureWeights : packoffset(c000.x);
  float4 g_lutTextureDomainMinEV : packoffset(c001.x);
  float4 g_lutTextureDomainMaxEV : packoffset(c002.x);
  float4 g_lutTextureBlendParams : packoffset(c003.x);
};

SamplerState samplerBilinearClamp : register(s0);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float _27 = (exp2(((TEXCOORD.x + -0.015625f) * 14.45161247253418f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _28 = (exp2(((0.984375f - TEXCOORD.y) * 14.45161247253418f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _29 = (exp2((g_sliceIndex * 0.4516128897666931f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _35 = max(g_lutTextureWeights.x, 0.0f);
  float _36 = max(g_lutTextureWeights.y, 0.0f);
  float _37 = max(g_lutTextureWeights.z, 0.0f);
  float _38 = max(g_lutTextureWeights.w, 0.0f);
  float _39 = dot(float4(_35, _36, _37, _38), float4(1.0f, 1.0f, 1.0f, 1.0f));
  float _99;
  float _100;
  float _101;
  float _154;
  float _155;
  float _156;
  float _209;
  float _210;
  float _211;
  float _264;
  float _265;
  float _266;
  if (((bool)(!(_39 <= 9.999999747378752e-06f))) && ((bool)(!(g_lutTextureBlendParams.x <= 0.5f)))) {
    float _46 = _35 / _39;
    float _47 = _36 / _39;
    float _48 = _37 / _39;
    float _49 = _38 / _39;
    do {
      if (_46 > 0.0f) {
        float _59 = exp2(g_lutTextureDomainMinEV.x) * 0.18000000715255737f;
        float _66 = max(g_lutTextureDomainMaxEV.x, (g_lutTextureDomainMinEV.x + 0.25f)) - g_lutTextureDomainMinEV.x;
        float4 _91 = colorGradingLUT0.Sample(samplerBilinearClamp, float3(((saturate((log2(max(((max(_27, 0.0f) + _59) * 5.55555534362793f), 9.999999974752427e-07f)) - g_lutTextureDomainMinEV.x) / _66) * 0.96875f) + 0.015625f), ((saturate((log2(max(((max(_28, 0.0f) + _59) * 5.55555534362793f), 9.999999974752427e-07f)) - g_lutTextureDomainMinEV.x) / _66) * 0.96875f) + 0.015625f), ((saturate((log2(max(((max(_29, 0.0f) + _59) * 5.55555534362793f), 9.999999974752427e-07f)) - g_lutTextureDomainMinEV.x) / _66) * 0.96875f) + 0.015625f)));
        _99 = (_91.x * _46);
        _100 = (_91.y * _46);
        _101 = (_91.z * _46);
      } else {
        _99 = 0.0f;
        _100 = 0.0f;
        _101 = 0.0f;
      }
      do {
        if (_47 > 0.0f) {
          float _111 = exp2(g_lutTextureDomainMinEV.y) * 0.18000000715255737f;
          float _118 = max(g_lutTextureDomainMaxEV.y, (g_lutTextureDomainMinEV.y + 0.25f)) - g_lutTextureDomainMinEV.y;
          float4 _143 = colorGradingLUT1.Sample(samplerBilinearClamp, float3(((saturate((log2(max(((max(_27, 0.0f) + _111) * 5.55555534362793f), 9.999999974752427e-07f)) - g_lutTextureDomainMinEV.y) / _118) * 0.96875f) + 0.015625f), ((saturate((log2(max(((max(_28, 0.0f) + _111) * 5.55555534362793f), 9.999999974752427e-07f)) - g_lutTextureDomainMinEV.y) / _118) * 0.96875f) + 0.015625f), ((saturate((log2(max(((max(_29, 0.0f) + _111) * 5.55555534362793f), 9.999999974752427e-07f)) - g_lutTextureDomainMinEV.y) / _118) * 0.96875f) + 0.015625f)));
          _154 = ((_143.x * _47) + _99);
          _155 = ((_143.y * _47) + _100);
          _156 = ((_143.z * _47) + _101);
        } else {
          _154 = _99;
          _155 = _100;
          _156 = _101;
        }
        do {
          if (_48 > 0.0f) {
            float _166 = exp2(g_lutTextureDomainMinEV.z) * 0.18000000715255737f;
            float _173 = max(g_lutTextureDomainMaxEV.z, (g_lutTextureDomainMinEV.z + 0.25f)) - g_lutTextureDomainMinEV.z;
            float4 _198 = colorGradingLUT2.Sample(samplerBilinearClamp, float3(((saturate((log2(max(((max(_27, 0.0f) + _166) * 5.55555534362793f), 9.999999974752427e-07f)) - g_lutTextureDomainMinEV.z) / _173) * 0.96875f) + 0.015625f), ((saturate((log2(max(((max(_28, 0.0f) + _166) * 5.55555534362793f), 9.999999974752427e-07f)) - g_lutTextureDomainMinEV.z) / _173) * 0.96875f) + 0.015625f), ((saturate((log2(max(((max(_29, 0.0f) + _166) * 5.55555534362793f), 9.999999974752427e-07f)) - g_lutTextureDomainMinEV.z) / _173) * 0.96875f) + 0.015625f)));
            _209 = ((_198.x * _48) + _154);
            _210 = ((_198.y * _48) + _155);
            _211 = ((_198.z * _48) + _156);
          } else {
            _209 = _154;
            _210 = _155;
            _211 = _156;
          }
          if (_49 > 0.0f) {
            float _221 = exp2(g_lutTextureDomainMinEV.w) * 0.18000000715255737f;
            float _228 = max(g_lutTextureDomainMaxEV.w, (g_lutTextureDomainMinEV.w + 0.25f)) - g_lutTextureDomainMinEV.w;
            float4 _253 = colorGradingLUT3.Sample(samplerBilinearClamp, float3(((saturate((log2(max(((max(_27, 0.0f) + _221) * 5.55555534362793f), 9.999999974752427e-07f)) - g_lutTextureDomainMinEV.w) / _228) * 0.96875f) + 0.015625f), ((saturate((log2(max(((max(_28, 0.0f) + _221) * 5.55555534362793f), 9.999999974752427e-07f)) - g_lutTextureDomainMinEV.w) / _228) * 0.96875f) + 0.015625f), ((saturate((log2(max(((max(_29, 0.0f) + _221) * 5.55555534362793f), 9.999999974752427e-07f)) - g_lutTextureDomainMinEV.w) / _228) * 0.96875f) + 0.015625f)));
            _264 = ((_253.x * _49) + _209);
            _265 = ((_253.y * _49) + _210);
            _266 = ((_253.z * _49) + _211);
          } else {
            _264 = _209;
            _265 = _210;
            _266 = _211;
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    _264 = _27;
    _265 = _28;
    _266 = _29;
  }
  bool _269 = (g_lutParam2 > 0.5f);
  SV_Target.x = select(_269, _27, _264);
  SV_Target.y = select(_269, _28, _265);
  SV_Target.z = select(_269, _29, _266);
  SV_Target.w = 0.0f;
  return SV_Target;
}
