// Temporal AA/ghost-reduction resolve combining current frame, motion, and history buffers.
Texture2D<half4> tScreenMap : register(t0);

Texture2D<half4> tLastScreenMap : register(t2);

Texture2D<float4> tDepthBuffer : register(t3);

Texture2D<float4> tLastDepthMap : register(t4);

Texture2D<float4> tVBuffer : register(t5);

Texture2D<float4> tNoiseMask : register(t7);

cbuffer Global : register(b2) {
  float4 ViewProj[4] : packoffset(c000.x);
  float4 ShadowViewProjTexs0[4] : packoffset(c004.x);
  float4 ShadowViewProjTexs1[4] : packoffset(c008.x);
  float4 ShadowViewProjTexs2[4] : packoffset(c012.x);
  float4 CSMShadowBiases : packoffset(c016.x);
  float4 DiyLightingInfo : packoffset(c017.x);
  float4 CameraPos : packoffset(c018.x);
  float4 CameraInfo : packoffset(c019.x);
  float4 ScreenInfo : packoffset(c020.x);
  float4 ScreenColor : packoffset(c021.x);
  float4 FogInfo : packoffset(c022.x);
  float4 FogColor : packoffset(c023.x);
  float4 EnvInfo : packoffset(c024.x);
  float4 SunDirection : packoffset(c025.x);
  float4 SunColor : packoffset(c026.x);
  float4 AmbientColor : packoffset(c027.x);
  float4 ShadowColor : packoffset(c028.x);
  float4 ReflectionProbeBBMin : packoffset(c029.x);
  float4 ReflectionProbeBBMax : packoffset(c030.x);
  float4 Misc : packoffset(c031.x);
  float4 Misc2 : packoffset(c032.x);
  float4 Misc3 : packoffset(c033.x);
  float4 VolumetricFogParam : packoffset(c034.x);
  float4 VolumetricFogParam2 : packoffset(c035.x);
  float4 ShadowViewProjTexs3[4] : packoffset(c036.x);
  float4 VTParam0 : packoffset(c040.x);
  float4 VTParam1 : packoffset(c041.x);
  float4 VTParam2 : packoffset(c042.x);
  float4 VTViewpoint : packoffset(c043.x);
  float4 VTIndMapUVTransform : packoffset(c044.x);
  float4 SunFogColor : packoffset(c045.x);
  float4 WindParam : packoffset(c046.x);
  float4 LastWindParam : packoffset(c047.x);
  float4 ScreenMotionGray : packoffset(c048.x);
  float4 GIInfo : packoffset(c049.x);
  float4 SSRParam[4] : packoffset(c050.x);
  float4 LastViewProjTex[4] : packoffset(c054.x);
  float4 GlobalBurnParam : packoffset(c058.x);
  float4 CSMCacheIndexs : packoffset(c059.x);
  float4 AerialPerspectiveExt : packoffset(c060.x);
  float4 AerialPerspectiveMie : packoffset(c061.x);
  float4 AerialPerspectiveRay : packoffset(c062.x);
  float4 LastCameraPos : packoffset(c063.x);
  float4 SHAOParam : packoffset(c064.x);
  float4 SHSBParam : packoffset(c065.x);
  float4 SHSBParam2 : packoffset(c066.x);
  float4 SHGIParam : packoffset(c067.x);
  float4 SHGIParam2 : packoffset(c068.x);
  float4 TimeOfDayInfos : packoffset(c069.x);
  float4 UserData[4] : packoffset(c070.x);
  float4 ViewRotationProj[4] : packoffset(c074.x);
  float4 WorldProbeInfo : packoffset(c078.x);
  float4 LastPlayerPos : packoffset(c079.x);
  float4 HexEnvData[4] : packoffset(c080.x);
  float4 HexRenderOptionData[4] : packoffset(c084.x);
  float4 OriginSunDir : packoffset(c088.x);
};

cbuffer Batch : register(b0) {
  float4 currInvViewProjTex[4] : packoffset(c000.x);
  float2 cRenderRTInfo : packoffset(c004.x);
  float cLastFrameRate : packoffset(c004.z);
  float cLastFrameRate2 : packoffset(c004.w);
  float4 cJitter : packoffset(c005.x);
  float cVarianceScale : packoffset(c006.x);
  float cAlphaForGhost : packoffset(c006.y);
};

SamplerState sScreenSampler : register(s0);

SamplerState sLastScreenSample : register(s2);

SamplerState sDepthBufferSampler : register(s3);

SamplerState sLastDepthSampler : register(s4);

SamplerState sVBufferSampler : register(s5);

SamplerState sNoiseMaskSampler : register(s7);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD,
  linear float4 TEXCOORD_1 : TEXCOORD1
) : SV_Target {
  float4 SV_Target;
  // Gather depth neighborhood around the pixel to detect foreground discontinuities.
  float4 _23 = tDepthBuffer.SampleLevel(sDepthBufferSampler, float2(TEXCOORD_1.x, TEXCOORD_1.y), 0.0f);
  float _28 = TEXCOORD_1.x - cRenderRTInfo.x;
  float _29 = TEXCOORD_1.y - cRenderRTInfo.y;
  float4 _30 = tDepthBuffer.SampleLevel(sDepthBufferSampler, float2(_28, _29), 0.0f);
  bool _32 = (_30.x < _23.x);
  float _34 = min(_30.x, _23.x);
  float _35 = cRenderRTInfo.x + TEXCOORD_1.x;
  float4 _36 = tDepthBuffer.SampleLevel(sDepthBufferSampler, float2(_35, _29), 0.0f);
  bool _38 = (_36.x < _34);
  float _42 = min(_36.x, _34);
  float _43 = cRenderRTInfo.y + TEXCOORD_1.y;
  float4 _44 = tDepthBuffer.SampleLevel(sDepthBufferSampler, float2(_28, _43), 0.0f);
  bool _46 = (_44.x < _42);
  float _48 = min(_44.x, _42);
  float4 _49 = tDepthBuffer.SampleLevel(sDepthBufferSampler, float2(_35, _43), 0.0f);
  bool _51 = (_49.x < _48);
  float _55 = min(_49.x, _48);
  // Compute half-resolution offsets used for motion-driven sampling.
  float _56 = cRenderRTInfo.x * 0.6000000238418579f;
  float _57 = cRenderRTInfo.y * 0.6000000238418579f;
  // Reconstruct view-space position via inverse reprojection.
  float _78 = ScreenInfo.z * SV_Position.x;
  float _79 = ScreenInfo.w * SV_Position.y;
  float _86 = ((CameraInfo.x / _55) - CameraInfo.x) / (CameraInfo.y - CameraInfo.x);
  float _98 = mad(_86, (currInvViewProjTex[3].z), mad(_79, (currInvViewProjTex[3].y), (_78 * (currInvViewProjTex[3].x)))) + (currInvViewProjTex[3].w);
  float _99 = (mad(_86, (currInvViewProjTex[0].z), mad(_79, (currInvViewProjTex[0].y), (_78 * (currInvViewProjTex[0].x)))) + (currInvViewProjTex[0].w)) / _98;
  float _100 = (mad(_86, (currInvViewProjTex[1].z), mad(_79, (currInvViewProjTex[1].y), (_78 * (currInvViewProjTex[1].x)))) + (currInvViewProjTex[1].w)) / _98;
  // Current-to-previous reprojection.
  float _101 = _99 + TEXCOORD_1.z;
  float _102 = _100 + TEXCOORD_1.w;
  float4 _103 = tLastDepthMap.SampleLevel(sLastDepthSampler, float2(_101, _102), 0.0f);
  float _107 = _101 - _56;
  float _108 = _102 - _57;
  float4 _109 = tLastDepthMap.SampleLevel(sLastDepthSampler, float2(_107, _108), 0.0f);
  float _113 = _56 + _101;
  float4 _114 = tLastDepthMap.SampleLevel(sLastDepthSampler, float2(_113, _108), 0.0f);
  float _118 = _57 + _102;
  float4 _119 = tLastDepthMap.SampleLevel(sLastDepthSampler, float2(_107, _118), 0.0f);
  float4 _123 = tLastDepthMap.SampleLevel(sLastDepthSampler, float2(_113, _118), 0.0f);
  // Maximum history depth for rejection.
  float _125 = max(max(max(max(max(0.0f, _103.x), _109.x), _114.x), _119.x), _123.x);
  // Depth-based accumulation factor.
  float _137 = saturate((min(max((CameraInfo.y * min(min(min(min(min(1.0f, _103.x), _109.x), _114.x), _119.x), _123.x)), 0.0f), 300.0f) + -70.0f) * 0.004347825888544321f);
  // Motion vector fallback when history fails.
  float4 _143 = tVBuffer.SampleLevel(sVBufferSampler, float2(((_56 * select(_51, 1.0f, select(_46, -1.0f, select(_38, 1.0f, select(_32, -1.0f, 0.0f))))) + TEXCOORD_1.x), ((_57 * select((_46 || _51), 1.0f, select((_32 || _38), -1.0f, 0.0f))) + TEXCOORD_1.y)), 0.0f);
  bool _148 = (bool)(_143.x < 9.0f) || (bool)(_143.y < 9.0f);
  float _151 = select(_148, (_143.x + TEXCOORD.x), _99);
  float _152 = select(_148, (_143.y + TEXCOORD.y), _100);
  // History rejection if reprojection falls outside frustum or depth delta too large.
  bool _159 = (bool)(((_137 * 9.899999713525176e-05f) + 9.999999974752427e-07f) < saturate((_55 + -9.999999747378752e-05f) - _125)) || (bool)(max(abs(_151 + -0.5f), abs(_152 + -0.5f)) > 0.5f);
  // Box-filtered neighborhood for anti-flicker.
  half4 _160 = tScreenMap.SampleLevel(sScreenSampler, float2(TEXCOORD_1.x, TEXCOORD_1.y), 0.0f);
  float _167 = TEXCOORD_1.x - _56;
  float _168 = TEXCOORD_1.y - _57;
  half4 _169 = tScreenMap.SampleLevel(sScreenSampler, float2(_167, _168), 0.0f);
  float _173 = _56 + TEXCOORD_1.x;
  half4 _174 = tScreenMap.SampleLevel(sScreenSampler, float2(_173, _168), 0.0f);
  float _178 = _57 + TEXCOORD_1.y;
  half4 _179 = tScreenMap.SampleLevel(sScreenSampler, float2(_167, _178), 0.0f);
  half4 _183 = tScreenMap.SampleLevel(sScreenSampler, float2(_173, _178), 0.0f);
  float _191 = ((((_174.x + _169.x) + _179.x) + _183.x) * 0.15000000596046448f) + (_160.x * 0.4000000059604645f);
  float _194 = ((_174.y + _169.y) + _179.y) + _183.y;
  float _196 = (_194 * 0.15000000596046448f) + (_160.y * 0.4000000059604645f);
  float _201 = ((((_174.z + _169.z) + _179.z) + _183.z) * 0.15000000596046448f) + (_160.z * 0.4000000059604645f);
  // Motion magnitude used to control clamp radius and ghost rejection.
  float _204 = _55 * 10.0f;
  float _205 = _204 * (TEXCOORD.x - _151);
  float _206 = _204 * (TEXCOORD.y - _152);
  float _210 = sqrt((_205 * _205) + (_206 * _206));
  // History tap and blue noise jitter.
  half4 _211 = tLastScreenMap.SampleLevel(sLastScreenSample, float2(_151, _152), 0.0f);
  float _226 = (frac(frac(dot(float2((-0.0f - (TEXCOORD.x * ScreenInfo.x)), (-0.0f - (TEXCOORD.y * ScreenInfo.y))), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) + -0.5f) * 0.00390625f;
  float _227 = _226 + _211.x;
  float _228 = _226 + _211.y;
  float _229 = _226 + _211.z;
  // Track maximum intensity across neighborhood and history to detect HDR UI elements.
  float _232 = max(max(_160.x, _160.y), _160.z);
  float _233 = max(max(_169.x, _169.y), _169.z);
  float _234 = max(max(_174.x, _174.y), _174.z);
  float _235 = max(max(_179.x, _179.y), _179.z);
  float _236 = max(max(_183.x, _183.y), _183.z);
  float _237 = max(max(_191, _196), _201);
  float _238 = max(max(_232, _233), max(_234, max(_235, _236)));
  float _239 = max(_238, _237);
  float _240 = max(max(_227, _228), _229);
  float _241 = max(_239, _240);
  float _hdrPadding = max(0.0f, (_241 - 1.0f) * 0.5f);
  float _336;
  float _337;
  float _338;
  float _339;
  float _340;
  float _341;
  float _382;
  float _383;
  float _384;
  if (!_159) {
    // Variance-based color clamp from current neighborhood (valid history).
    float _259 = ((((_169.x + _160.x) + _174.x) + _179.x) + _183.x) * 0.20000000298023224f;
    float _260 = ((((_169.y + _160.y) + _174.y) + _179.y) + _183.y) * 0.20000000298023224f;
    float _261 = ((((_169.z + _160.z) + _174.z) + _179.z) + _183.z) * 0.20000000298023224f;
    float _275 = (((saturate(cVarianceScale * _137) * 4.5f) + 2.5f) * sqrt(abs(((((((_169.x * _169.x) + (_160.x * _160.x)) + (_174.x * _174.x)) + (_179.x * _179.x)) + (_183.x * _183.x)) * 0.20000000298023224f) - (_259 * _259)))) * (1.0f - saturate((min(0.5f, min(cAlphaForGhost, _160.w)) + -0.20000000298023224f) * 2.5f));
    _336 = min((_259 - _275), _191);
    _337 = min((_260 - _275), _196);
    _338 = min((_261 - _275), _201);
    _339 = max(((_275 + _259) + _hdrPadding), (_191 + _hdrPadding));
    _340 = max(((_275 + _260) + _hdrPadding), (_196 + _hdrPadding));
    _341 = max(((_275 + _261) + _hdrPadding), (_201 + _hdrPadding));
  } else {
    // Fallback clamp when history invalid; rely on local extrema.
    float _298 = (4.0f - (saturate(_210 * 100.0f) * 3.8399999141693115f)) * abs(((_160.y * -0.1429000049829483f) - _196) + (_194 * 0.2856999933719635f));
    _336 = (min(_183.x, min(_179.x, min(_174.x, min(_169.x, min(_160.x, 10.0f))))) - _298);
    _337 = (min(_183.y, min(_179.y, min(_174.y, min(_169.y, min(_160.y, 10.0f))))) - _298);
    _338 = (min(_183.z, min(_179.z, min(_174.z, min(_169.z, min(_160.z, 10.0f))))) - _298);
    _339 = (max(_183.x, max(_179.x, max(_174.x, max(_169.x, max(_160.x, 0.0f))))) + _298) + _hdrPadding;
    _340 = (max(_183.y, max(_179.y, max(_174.y, max(_169.y, max(_160.y, 0.0f))))) + _298) + _hdrPadding;
    _341 = (max(_183.z, max(_179.z, max(_174.z, max(_169.z, max(_160.z, 0.0f))))) + _298) + _hdrPadding;
  }
  // Temporal blending weight adjusted by frame rate heuristic.
  float _349 = min(max((((_210 * 600.0f) * (cLastFrameRate2 - cLastFrameRate)) + cLastFrameRate), cLastFrameRate2), cLastFrameRate);
  float _353 = (_339 + _336) * 0.5f;
  float _354 = (_340 + _337) * 0.5f;
  float _355 = (_341 + _338) * 0.5f;
  // History sample clamped inside dynamic box.
  float _362 = _227 - _353;
  float _363 = _228 - _354;
  float _364 = _229 - _355;
  float _372 = max(abs(_362 / ((_339 - _336) * 0.5f)), max(abs(_363 / ((_340 - _337) * 0.5f)), abs(_364 / ((_341 - _338) * 0.5f))));
  if (_372 > 1.0f) {
    _382 = ((_362 / _372) + _353);
    _383 = ((_363 / _372) + _354);
    _384 = ((_364 / _372) + _355);
  } else {
    _382 = _227;
    _383 = _228;
    _384 = _229;
  }
  // Noise mask drives reactive mask / alpha suppression near disocclusions.
  float4 _388 = tNoiseMask.SampleLevel(sNoiseMaskSampler, float2(TEXCOORD_1.x, TEXCOORD_1.y), 0.0f);
  float4 _390 = tNoiseMask.SampleLevel(sNoiseMaskSampler, float2(_167, _168), 0.0f);
  float4 _392 = tNoiseMask.SampleLevel(sNoiseMaskSampler, float2(_173, _168), 0.0f);
  float4 _394 = tNoiseMask.SampleLevel(sNoiseMaskSampler, float2(_167, _178), 0.0f);
  float4 _396 = tNoiseMask.SampleLevel(sNoiseMaskSampler, float2(_173, _178), 0.0f);
  // Final temporal resolve with adaptive lerp and reactive alpha.
  SV_Target.x = max(0.0f, (((select(_159, _191, _382) - _160.x) * _349) + _160.x));
  SV_Target.y = max(0.0f, (((select(_159, _196, _383) - _160.y) * _349) + _160.y));
  SV_Target.z = max(0.0f, (((select(_159, _201, _384) - _160.z) * _349) + _160.z));
  SV_Target.w = max(0.0f, saturate(abs((_388.x * -1.142899990081787f) + ((((_392.x + _390.x) + _394.x) + _396.x) * 0.2856999933719635f)) - (abs(_55 - _125) * 3000.0f)));
  return SV_Target;
}
