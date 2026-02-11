#include "../antialiasing.hlsli"

// Texture2D<float4> HDRImage : register(t0);

cbuffer SceneInfo : register(b0) {
  float4 viewProjMat[4] : packoffset(c000.x);
  float4 transposeViewMat[3] : packoffset(c004.x);
  float4 transposeViewInvMat[3] : packoffset(c007.x);
  float4 projElement[2] : packoffset(c010.x);
  float4 projInvElements[2] : packoffset(c012.x);
  float4 viewProjInvMat[4] : packoffset(c014.x);
  float4 prevViewProjMat[4] : packoffset(c018.x);
  float3 ZToLinear : packoffset(c022.x);
  float subdivisionLevel : packoffset(c022.w);
  float2 screenSize : packoffset(c023.x);
  float2 screenInverseSize : packoffset(c023.z);
  float2 cullingHelper : packoffset(c024.x);
  float cameraNearPlane : packoffset(c024.z);
  float cameraFarPlane : packoffset(c024.w);
  float4 viewFrustum[6] : packoffset(c025.x);
  float4 clipplane : packoffset(c031.x);
  float2 vrsVelocityThreshold : packoffset(c032.x);
  uint GPUVisibleMask : packoffset(c032.z);
  uint resolutionRatioPacked : packoffset(c032.w);
};

// SamplerState BilinearClamp : register(s5, space32);

float4 main(
    noperspective float4 SV_Position: SV_Position)
    : SV_Target {
  float4 SV_Target;
  float _9 = screenInverseSize.x * SV_Position.x;
  float _10 = screenInverseSize.y * SV_Position.y;
  float4 _11_raw = HDRImage.SampleLevel(BilinearClamp, float2(_9, _10), 0.0f);

  float4 _11 = _11_raw;
  _11.rgb *= INV_WHITE_SCALE;

  float4 _16 = FxaaGatherGreenScaled(float2(_9, _10));
  float4 _20 = FxaaGatherGreenScaled(float2(_9, _10));
  float _30 = max(max(_20.z, _20.x), max(_16.z, max(_16.x, _11.y)));
  float _33 = _30 - min(min(_20.z, _20.x), min(_16.z, min(_16.x, _11.y)));
  float _139;
  float _144;
  float _169;
  float _174;
  float _199;
  float _204;
  float _223;
  float _224;
  float _225;
  float _226;
  float _227;
  float _228;
  float _259;
  float _260;
  float _261;
  float _262;
  if (!(_33 < max(0.08330000191926956f, (_30 * 0.3330000042915344f)))) {
    float4 _37 = FxaaSampleScaled(float2(_9, _10), int2(1, -1));
    float4 _39 = FxaaSampleScaled(float2(_9, _10), int2(-1, 1));
    float _41 = _20.z + _16.x;
    float _42 = _20.x + _16.z;
    float _45 = _11.y * 2.0f;
    float _48 = _37.y + _16.y;
    float _54 = _39.y + _20.w;
    bool _72 = ((((abs(_41 - _45) * 2.0f) + abs(_48 - (_16.z * 2.0f))) + abs(_54 - (_20.x * 2.0f))) >= (((abs(_42 - _45) * 2.0f) + abs((_20.w + _37.y) - (_20.z * 2.0f))) + abs((_16.y + _39.y) - (_16.x * 2.0f))));
    float _76 = select(_72, _20.z, _20.x);
    float _77 = select(_72, _16.x, _16.z);
    float _78 = select(_72, screenInverseSize.y, screenInverseSize.x);
    float _83 = abs(_76 - _11.y);
    float _84 = abs(_77 - _11.y);
    bool _85 = (_83 >= _84);
    float _88 = select(_85, (-0.0f - _78), _78);
    float _91 = saturate(abs((((_48 + ((_41 + _42) * 2.0f)) + _54) * 0.0833333358168602f) - _11.y) * (1.0f / _33));
    float _92 = select(_72, screenInverseSize.x, 0.0f);
    float _93 = select(_72, 0.0f, screenInverseSize.y);
    float _94 = _88 * 0.5f;
    float _96 = select(_72, _9, (_94 + _9));
    float _98 = select(_72, (_94 + _10), _10);
    float _99 = _96 - _92;
    float _100 = _98 - _93;
    float _101 = _96 + _92;
    float _102 = _98 + _93;
    float4 _105 = FxaaSampleScaled(float2(_99, _100));
    float4 _108 = FxaaSampleScaled(float2(_101, _102));
    float _112 = max(_83, _84) * 0.25f;
    float _113 = (_11.y + select(_85, _76, _77)) * 0.5f;
    float _115 = (_91 * _91) * (3.0f - (_91 * 2.0f));
    float _117 = _105.y - _113;
    float _118 = _108.y - _113;
    bool _120 = (abs(_117) >= _112);
    bool _122 = (abs(_118) >= _112);
    float _123 = _92 * 1.5f;
    float _125 = select(_120, _99, (_99 - _123));
    float _126 = _93 * 1.5f;
    float _128 = select(_120, _100, (_100 - _126));
    float _131 = select(_122, _101, (_101 + _123));
    float _133 = select(_122, _102, (_102 + _126));
    do {
      if (!(_120 && _122)) {
        do {
          if (!_120) {
            float4 _136 = FxaaSampleScaled(float2(_125, _128));
            _139 = _136.y;
          } else {
            _139 = _117;
          }
          do {
            if (!_122) {
              float4 _141 = FxaaSampleScaled(float2(_131, _133));
              _144 = _141.y;
            } else {
              _144 = _118;
            }
            float _146 = select(_120, _139, (_139 - _113));
            float _148 = select(_122, _144, (_144 - _113));
            bool _150 = (abs(_146) >= _112);
            bool _152 = (abs(_148) >= _112);
            float _153 = _92 * 2.0f;
            float _155 = select(_150, _125, (_125 - _153));
            float _156 = _93 * 2.0f;
            float _158 = select(_150, _128, (_128 - _156));
            float _161 = select(_152, _131, (_131 + _153));
            float _163 = select(_152, _133, (_133 + _156));
            if (!(_150 && _152)) {
              do {
                if (!_150) {
                  float4 _166 = FxaaSampleScaled(float2(_155, _158));
                  _169 = _166.y;
                } else {
                  _169 = _146;
                }
                do {
                  if (!_152) {
                    float4 _171 = FxaaSampleScaled(float2(_161, _163));
                    _174 = _171.y;
                  } else {
                    _174 = _148;
                  }
                  float _176 = select(_150, _169, (_169 - _113));
                  float _178 = select(_152, _174, (_174 - _113));
                  bool _180 = (abs(_176) >= _112);
                  bool _182 = (abs(_178) >= _112);
                  float _183 = _92 * 4.0f;
                  float _185 = select(_180, _155, (_155 - _183));
                  float _186 = _93 * 4.0f;
                  float _188 = select(_180, _158, (_158 - _186));
                  float _191 = select(_182, _161, (_161 + _183));
                  float _193 = select(_182, _163, (_163 + _186));
                  if (!(_180 && _182)) {
                    do {
                      if (!_180) {
                        float4 _196 = FxaaSampleScaled(float2(_185, _188));
                        _199 = _196.y;
                      } else {
                        _199 = _176;
                      }
                      do {
                        if (!_182) {
                          float4 _201 = FxaaSampleScaled(float2(_191, _193));
                          _204 = _201.y;
                        } else {
                          _204 = _178;
                        }
                        float _206 = select(_180, _199, (_199 - _113));
                        float _208 = select(_182, _204, (_204 - _113));
                        bool _210 = (abs(_206) >= _112);
                        float _213 = _92 * 12.0f;
                        float _215 = select(_210, _185, (_185 - _213));
                        float _216 = _93 * 12.0f;
                        float _218 = select(_210, _188, (_188 - _216));
                        if (!(abs(_208) >= _112)) {
                          _223 = _215;
                          _224 = _218;
                          _225 = (_191 + _213);
                          _226 = (_193 + _216);
                          _227 = _206;
                          _228 = _208;
                        } else {
                          _223 = _215;
                          _224 = _218;
                          _225 = _191;
                          _226 = _193;
                          _227 = _206;
                          _228 = _208;
                        }
                      } while (false);
                    } while (false);
                  } else {
                    _223 = _185;
                    _224 = _188;
                    _225 = _191;
                    _226 = _193;
                    _227 = _176;
                    _228 = _178;
                  }
                } while (false);
              } while (false);
            } else {
              _223 = _155;
              _224 = _158;
              _225 = _161;
              _226 = _163;
              _227 = _146;
              _228 = _148;
            }
          } while (false);
        } while (false);
      } else {
        _223 = _125;
        _224 = _128;
        _225 = _131;
        _226 = _133;
        _227 = _117;
        _228 = _118;
      }
      float _232 = select(_72, (_9 - _223), (_10 - _224));
      float _234 = select(_72, (_225 - _9), (_226 - _10));
      float _249 = max(select((((_11.y - _113) < 0.0f) ^ select((_232 < _234), (_227 < 0.0f), (_228 < 0.0f))), (0.5f - (min(_232, _234) * (1.0f / (_234 + _232)))), 0.0f), ((_115 * _115) * 0.75f)) * _88;
      float4 _254 = FxaaSampleScaled(float2(select(_72, _9, (_249 + _9)), select(_72, (_249 + _10), _10)));
      _259 = _254.x;
      _260 = _254.y;
      _261 = _254.z;
      _262 = _11_raw.y;
    } while (false);
  } else {
    _259 = _11.x;
    _260 = _11.y;
    _261 = _11.z;
    _262 = _11_raw.w;
  }
  SV_Target.x = _259;
  SV_Target.y = _260;
  SV_Target.z = _261;
  SV_Target.w = _262;

  SV_Target.rgb *= WHITE_SCALE;

  return SV_Target;
}
