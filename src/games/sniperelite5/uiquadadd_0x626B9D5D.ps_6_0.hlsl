#include "./shared.h"
Texture2D<float4> g_xTexture : register(t0);

Texture2D<float4> g_xMaskTexture : register(t1);

cbuffer QuadConstants : register(b1) {
  int g_bUseTexture : packoffset(c000.x);
  int g_bUseRadialClip : packoffset(c000.y);
  float g_fClipStartRadius : packoffset(c000.z);
  float g_fClipEndRadius : packoffset(c000.w);
  float g_fInnerClipStartRadius : packoffset(c001.x);
  float g_fInnerClipEndRadius : packoffset(c001.y);
  float2 g_xClipCentre : packoffset(c001.z);
  int g_bUseWrapSampler : packoffset(c002.x);
  int g_bUsePointMag : packoffset(c002.y);
  int g_bUseDF : packoffset(c002.z);
  int g_bUseTextureAlphaMask : packoffset(c002.w);
  float2 g_xAlphaMaskOrigin : packoffset(c003.x);
  float2 g_xOneOverAlphaMaskDimensions : packoffset(c003.z);
  float4 g_xAlphaMaskUVs : packoffset(c004.x);
  float4 g_xOutlineColour : packoffset(c005.x);
  float4 g_xOuterGlowColour : packoffset(c006.x);
  float2 g_fTextureSize : packoffset(c007.x);
  float g_fOuterGlowMin : packoffset(c007.z);
  float g_fOuterGlowMax : packoffset(c007.w);
  float g_fOutlineHalfThickness : packoffset(c008.x);
  float g_fOutlineOffset : packoffset(c008.y);
  float g_fAntiAliasDistance : packoffset(c008.z);
  float g_fInnerAlpha : packoffset(c008.w);
  float g_fTolerance : packoffset(c009.x);
  int g_bOutline : packoffset(c009.y);
  int g_bAntiAlias : packoffset(c009.z);
  int g_bOuterGlow : packoffset(c009.w);
  float2 g_xAlphaMaskRotation : packoffset(c010.x);
  int g_bUseMSDF : packoffset(c010.z);
  int g_iBlendOperation : packoffset(c010.w);
  float g_fBlendLerp : packoffset(c011.x);
  float2 g_xBlendUVOffset : packoffset(c011.y);
};

SamplerState g_xBilinearClamp : register(s3);

SamplerState g_xTrilinearWrap : register(s4);

SamplerState g_xTrilinearClamp : register(s5);

SamplerState g_xPointMagWrap : register(s10);

SamplerState g_xPointMagClamp : register(s11);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD,
  linear float4 COLOR : COLOR
) : SV_Target {
  float4 SV_Target;
  bool _19 = (g_bUseDF == 0);
  float _65;
  float _66;
  float _91;
  float _127;
  float _128;
  float _129;
  float _130;
  float _212;
  float _213;
  float _214;
  float _215;
  float _245;
  float _246;
  float _247;
  float _248;
  float _293;
  float _294;
  float _295;
  float _296;
  float _302;
  float _303;
  float _304;
  float _305;
  float _339;
  float _342;
  float _389;
  [branch]
  if (!_19) {
    float _24 = g_fTextureSize.x * TEXCOORD.x;
    float _25 = g_fTextureSize.y * TEXCOORD.y;
    float _26 = ddx_coarse(_24);
    float _27 = ddx_coarse(_25);
    float _28 = _26 * _26;
    float _29 = _27 * _27;
    float _30 = _29 + _28;
    float _31 = sqrt(_30);
    float _37 = g_xOutlineColour.x * COLOR.w;
    float _38 = g_xOutlineColour.y * COLOR.w;
    float _39 = g_xOutlineColour.z * COLOR.w;
    float _40 = g_xOutlineColour.w * COLOR.w;
    float _46 = g_xOuterGlowColour.x * COLOR.w;
    float _47 = g_xOuterGlowColour.y * COLOR.w;
    float _48 = g_xOuterGlowColour.z * COLOR.w;
    bool _53 = (g_bUseMSDF == 0);
    float4 _54 = g_xTexture.Sample(g_xTrilinearWrap, float2(TEXCOORD.x, TEXCOORD.y));
    [branch]
    if (!_53) {
      float _60 = max(_54.x, _54.y);
      float _61 = min(_60, _54.z);
      float _62 = min(_54.x, _54.y);
      float _63 = max(_62, _61);
      _65 = _63;
      _66 = _54.w;
    } else {
      _65 = _54.x;
      _66 = _54.x;
    }
    float _69 = g_fAntiAliasDistance * _31;
    float _70 = saturate(_69);
    bool _73 = (g_bAntiAlias == 0);
    [branch]
    if (!_73) {
      float _75 = g_fTolerance - _70;
      float _76 = saturate(_75);
      float _77 = _70 + g_fTolerance;
      float _78 = saturate(_77);
      float _79 = _78 - _76;
      float _80 = _65 - _76;
      float _81 = _80 / (RENODX_TONE_MAP_TYPE == 0.f ? _79 : (_79 < 0.f ? min(_79, -1e-6f) : max(_79, 1e-6f)));
      float _82 = saturate(_81);
      float _83 = _82 * 2.0f;
      float _84 = 3.0f - _83;
      float _85 = _82 * _82;
      float _86 = _85 * _84;
      _91 = _86;
    } else {
      bool _88 = (_65 >= g_fTolerance);
      float _89 = float((bool)_88);
      _91 = _89;
    }
    bool _93 = (g_bOuterGlow == 0);
    [branch]
    if (!_93) {
      float _97 = g_fOuterGlowMax - g_fOuterGlowMin;
      float _98 = _66 - g_fOuterGlowMin;
      float _99 = _98 / _97;
      float _100 = saturate(_99);
      float _101 = _100 * 2.0f;
      float _102 = 3.0f - _101;
      float _103 = g_xOuterGlowColour.w * COLOR.w;
      float _104 = _100 * _100;
      float _105 = _104 * _103;
      float _106 = _105 * _102;
      float _108 = g_fInnerAlpha * COLOR.x;
      float _109 = g_fInnerAlpha * COLOR.y;
      float _110 = g_fInnerAlpha * COLOR.z;
      float _111 = g_fInnerAlpha * COLOR.w;
      float _112 = _108 - _46;
      float _113 = _109 - _47;
      float _114 = _110 - _48;
      float _115 = _111 - _106;
      float _116 = _112 * _91;
      float _117 = _113 * _91;
      float _118 = _114 * _91;
      float _119 = _115 * _91;
      float _120 = _116 + _46;
      float _121 = _117 + _47;
      float _122 = _118 + _48;
      float _123 = _119 + _106;
      _127 = _120;
      _128 = _121;
      _129 = _122;
      _130 = _123;
    } else {
      float _125 = _91 * COLOR.w;
      _127 = COLOR.x;
      _128 = COLOR.y;
      _129 = COLOR.z;
      _130 = _125;
    }
    bool _132 = (g_bOutline == 0);
    [branch]
    if (!_132) {
      float _135 = g_fOutlineOffset + g_fTolerance;
      float _137 = -0.0f - _70;
      float _138 = _65 - g_fOutlineHalfThickness;
      float _139 = _138 - _135;
      float _140 = _139 / _137;
      float _141 = saturate(_140);
      float _142 = _141 * 2.0f;
      float _143 = 3.0f - _142;
      float _144 = _141 * _141;
      float _145 = _144 * _143;
      float _146 = _65 - _135;
      float _147 = _146 + g_fOutlineHalfThickness;
      float _148 = _147 / _70;
      float _149 = saturate(_148);
      float _150 = _149 * 2.0f;
      float _151 = 3.0f - _150;
      float _152 = _149 * _149;
      float _153 = _152 * _151;
      float _154 = _145 + -1.0f;
      float _155 = _154 + _153;
      float _156 = _37 - _127;
      float _157 = _38 - _128;
      float _158 = _39 - _129;
      float _159 = _40 - _130;
      float _160 = _155 * _156;
      float _161 = _155 * _157;
      float _162 = _155 * _158;
      float _163 = _155 * _159;
      float _164 = _160 + _127;
      float _165 = _161 + _128;
      float _166 = _162 + _129;
      float _167 = _163 + _130;
      _302 = _164;
      _303 = _165;
      _304 = _166;
      _305 = _167;
    } else {
      _302 = _127;
      _303 = _128;
      _304 = _129;
      _305 = _130;
    }
  } else {
    bool _171 = (g_bUseTexture == 0);
    [branch]
    if (!_171) {
      bool _175 = (g_fBlendLerp > 0.0f);
      bool _177 = (g_bUsePointMag == 0);
      bool _179 = (g_bUseWrapSampler == 0);
      [branch]
      if (_175) {
        float _183 = g_xBlendUVOffset.x + TEXCOORD.x;
        float _184 = g_xBlendUVOffset.y + TEXCOORD.y;
        [branch]
        if (!_177) {
          [branch]
          if (!_179) {
            float4 _187 = g_xTexture.Sample(g_xPointMagWrap, float2(_183, _184));
            _212 = _187.x;
            _213 = _187.y;
            _214 = _187.z;
            _215 = _187.w;
          } else {
            float4 _193 = g_xTexture.Sample(g_xPointMagClamp, float2(_183, _184));
            _212 = _193.x;
            _213 = _193.y;
            _214 = _193.z;
            _215 = _193.w;
          }
        } else {
          [branch]
          if (!_179) {
            float4 _200 = g_xTexture.Sample(g_xTrilinearWrap, float2(_183, _184));
            _212 = _200.x;
            _213 = _200.y;
            _214 = _200.z;
            _215 = _200.w;
          } else {
            float4 _206 = g_xTexture.Sample(g_xTrilinearClamp, float2(_183, _184));
            _212 = _206.x;
            _213 = _206.y;
            _214 = _206.z;
            _215 = _206.w;
          }
        }
        bool _217 = (g_bUseWrapSampler == 0);
        [branch]
        if (!_177) {
          [branch]
          if (!_217) {
            float4 _220 = g_xTexture.Sample(g_xPointMagWrap, float2(TEXCOORD.x, TEXCOORD.y));
            _245 = _220.x;
            _246 = _220.y;
            _247 = _220.z;
            _248 = _220.w;
          } else {
            float4 _226 = g_xTexture.Sample(g_xPointMagClamp, float2(TEXCOORD.x, TEXCOORD.y));
            _245 = _226.x;
            _246 = _226.y;
            _247 = _226.z;
            _248 = _226.w;
          }
        } else {
          [branch]
          if (!_217) {
            float4 _233 = g_xTexture.Sample(g_xTrilinearWrap, float2(TEXCOORD.x, TEXCOORD.y));
            _245 = _233.x;
            _246 = _233.y;
            _247 = _233.z;
            _248 = _233.w;
          } else {
            float4 _239 = g_xTexture.Sample(g_xTrilinearClamp, float2(TEXCOORD.x, TEXCOORD.y));
            _245 = _239.x;
            _246 = _239.y;
            _247 = _239.z;
            _248 = _239.w;
          }
        }
        float _249 = _212 - _245;
        float _250 = _213 - _246;
        float _251 = _214 - _247;
        float _252 = _215 - _248;
        float _253 = _249 * g_fBlendLerp;
        float _254 = _250 * g_fBlendLerp;
        float _255 = _251 * g_fBlendLerp;
        float _256 = _252 * g_fBlendLerp;
        float _257 = _253 + _245;
        float _258 = _254 + _246;
        float _259 = _255 + _247;
        float _260 = _256 + _248;
        float _261 = _257 * COLOR.x;
        float _262 = _258 * COLOR.y;
        float _263 = _259 * COLOR.z;
        float _264 = _260 * COLOR.w;
        _302 = _261;
        _303 = _262;
        _304 = _263;
        _305 = _264;
      } else {
        [branch]
        if (!_177) {
          [branch]
          if (!_179) {
            float4 _268 = g_xTexture.Sample(g_xPointMagWrap, float2(TEXCOORD.x, TEXCOORD.y));
            _293 = _268.x;
            _294 = _268.y;
            _295 = _268.z;
            _296 = _268.w;
          } else {
            float4 _274 = g_xTexture.Sample(g_xPointMagClamp, float2(TEXCOORD.x, TEXCOORD.y));
            _293 = _274.x;
            _294 = _274.y;
            _295 = _274.z;
            _296 = _274.w;
          }
        } else {
          [branch]
          if (!_179) {
            float4 _281 = g_xTexture.Sample(g_xTrilinearWrap, float2(TEXCOORD.x, TEXCOORD.y));
            _293 = _281.x;
            _294 = _281.y;
            _295 = _281.z;
            _296 = _281.w;
          } else {
            float4 _287 = g_xTexture.Sample(g_xTrilinearClamp, float2(TEXCOORD.x, TEXCOORD.y));
            _293 = _287.x;
            _294 = _287.y;
            _295 = _287.z;
            _296 = _287.w;
          }
        }
        float _297 = _293 * COLOR.x;
        float _298 = _294 * COLOR.y;
        float _299 = _295 * COLOR.z;
        float _300 = _296 * COLOR.w;
        _302 = _297;
        _303 = _298;
        _304 = _299;
        _305 = _300;
      }
    } else {
      _302 = COLOR.x;
      _303 = COLOR.y;
      _304 = COLOR.z;
      _305 = COLOR.w;
    }
  }
  bool _308 = (g_bUseRadialClip == 0);
  [branch]
  if (!_308) {
    float _313 = SV_Position.x - g_xClipCentre.x;
    float _314 = SV_Position.y - g_xClipCentre.y;
    float _315 = _313 * _313;
    float _316 = _314 * _314;
    float _317 = _315 + _316;
    float _318 = sqrt(_317);
    bool _320 = (_318 < g_fInnerClipEndRadius);
    [branch]
    if (_320) {
      float _323 = g_fInnerClipEndRadius - g_fInnerClipStartRadius;
      float _324 = max(_323, 0.009999999776482582f);
      float _325 = _318 - g_fInnerClipStartRadius;
      float _326 = _325 / _324;
      float _327 = saturate(_326);
      _339 = _327;
    } else {
      float _332 = g_fClipEndRadius - g_fClipStartRadius;
      float _333 = max(_332, 0.009999999776482582f);
      float _334 = _318 - g_fClipStartRadius;
      float _335 = _334 / _333;
      float _336 = saturate(_335);
      float _337 = 1.0f - _336;
      _339 = _337;
    }
    float _340 = _339 * _305;
    _342 = _340;
  } else {
    _342 = _305;
  }
  bool _344 = (g_bUseTextureAlphaMask == 0);
  [branch]
  if (!_344) {
    float _349 = SV_Position.x - g_xAlphaMaskOrigin.x;
    float _350 = SV_Position.y - g_xAlphaMaskOrigin.y;
    float _353 = _349 * g_xAlphaMaskRotation.x;
    float _355 = g_xAlphaMaskRotation.y * _350;
    float _356 = _355 + _353;
    float _357 = g_xAlphaMaskRotation.x * _350;
    float _358 = g_xAlphaMaskRotation.y * _349;
    float _359 = _357 - _358;
    float _362 = g_xOneOverAlphaMaskDimensions.x * _356;
    float _363 = _359 * g_xOneOverAlphaMaskDimensions.y;
    bool _364 = (_362 < 0.0f);
    bool _365 = (_362 > 1.0f);
    bool _366 = _364 || _365;
    [branch]
    if (_366) {
      if (true) discard;
    }
    bool _369 = (_363 < 0.0f);
    bool _370 = (_363 > 1.0f);
    bool _371 = _369 || _370;
    [branch]
    if (_371) {
      if (true) discard;
    }
    float _377 = g_xAlphaMaskUVs.z - g_xAlphaMaskUVs.x;
    float _378 = _377 * _362;
    float _379 = _378 + g_xAlphaMaskUVs.x;
    float _382 = g_xAlphaMaskUVs.w - g_xAlphaMaskUVs.y;
    float _383 = _382 * _363;
    float _384 = _383 + g_xAlphaMaskUVs.y;
    float4 _385 = g_xMaskTexture.Sample(g_xBilinearClamp, float2(_379, _384));
    float _387 = _385.x * _342;
    _389 = _387;
  } else {
    _389 = _342;
  }
  float _390 = _389 * _302;
  float _391 = _389 * _303;
  float _392 = _389 * _304;
  SV_Target.x = _390;
  SV_Target.y = _391;
  SV_Target.z = _392;
  SV_Target.w = 1.0f;
  return SV_Target;
}
