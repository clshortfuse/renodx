#include "../shared.h"
#include "local_light_common.hlsl"

Texture2D<float4> __3__36__0__0__g_inputSceneColor : register(t4, space36);

Texture2D<float> __3__36__0__0__g_sceneDepth : register(t5, space36);

Texture2D<float> __3__36__0__0__g_atmosphericScatteringDepth : register(t6, space36);

Texture2D<float4> __3__36__0__0__g_offScreenParticleAlphaBlend : register(t7, space36);

Texture2D<float2> __3__36__0__0__g_offscreenParticleDepth : register(t9, space36);

Texture2D<float2> __3__36__0__0__g_offscreenParticleDepthQuarter : register(t10, space36);

Texture2D<uint> __3__36__0__0__g_effectTileCoords : register(t12, space36);

RWTexture2D<float4> __3__38__0__1__g_sceneColorUAV : register(u0, space38);

RWTexture2D<uint> __3__38__0__1__g_materialIdUAV : register(u10, space38);

cbuffer __3__35__0__0__SceneConstantBuffer : register(b4, space35) {
  float4 _time;
  float4 _timeNoScale;
  uint4 _frameNumber;
  float4 _screenSizeAndInvSize;
  float4 _bufferSizeAndInvSize;
  float4 _hiZUVScaleAndInvScale;
  float4 _resolutionScale;
  float4 _temporalReprojectionParams;
  float4 _viewPos;
  float4 _viewDir;
  column_major float4x4 _viewProj;
  column_major float4x4 _viewProjNoJitter;
  column_major float4x4 _viewProjRelative;
  column_major float4x4 _viewProjRelativeNoJitter;
  column_major float4x4 _invViewProj;
  column_major float4x4 _invViewProjRelative;
  column_major float4x4 _invViewProjRelativeNoJitter;
  column_major float4x4 _viewProjRelativeOrtho;
  float4 _sunDirection;
  float4 _moonDirection;
  float4 _moonRight;
  float4 _moonUp;
  float4 _ssaoRandomDirection[16];
  column_major float4x4 _view;
  column_major float4x4 _viewRelative;
  column_major float4x4 _viewRelativePrev;
  column_major float4x4 _proj;
  column_major float4x4 _projNoJitter;
  float4 _viewPosPrev;
  column_major float4x4 _viewProjNoJitterPrev;
  column_major float4x4 _viewProjRelativePrev;
  column_major float4x4 _viewProjRelativeNoJitterPrev;
  column_major float4x4 _invViewProjPrev;
  column_major float4x4 _invViewProjRelativePrev;
  column_major float4x4 _projToPrevProj;
  column_major float4x4 _projToPrevProjNoTranslation;
  column_major float4x4 _viewProjectionTexScale;
  float4 _temporalAAJitter;
  float4 _temporalAAJitterParams;
  float4 _frustumPlanes[6];
  float4 _frustumPlanesPrev[6];
  float4 _frustumCornerDirs[4];
  float4 _screenPercentage;
  float4 _nearFarProj;
  float4 _renderingOriginPos;
  float4 _renderingOriginPosPrev;
  float4 _lodMaskRenderRate;
  float4 _terrainNormalParams;
  int4 _hiZMapInfo;
  int4 _hiZMapInfoCurrent;
  float4 _treeParams;
  uint4 _clusterSize;
  uint4 _globalLightParams;
  float4 _bevelParams;
  float4 _variableRateShadingParams;
  float4 _cavityParams;
  float4 _customRenderPassSizeInvSize;
  uint4 _impostorParams;
  float4 _clusterDecalSizeAndInvSize;
  uint4 _globalWindParams;
  float4 _windFluidVolumeParams;
  float4 _windFluidTextureParams;
  float4 _raytracingAccelerationStructureOrigin;
  float4 _debugBaseColor;
  float4 _debugNormal;
  float4 _debugMaterial;
  float4 _debugMultiplier;
  half4 _debugBaseColor16;
  half4 _debugNormal16;
  half4 _debugMaterial16;
  half4 _debugMultiplier16;
  float4 _debugCursorWorldPos;
  uint4 _debugRenderToggle01;
  uint4 _debugTreeShapeVariation;
  float4 _positionBasedDynamicsParameter;
  float _effectiveMetallicForVelvet;
  float _debugCharacterSnowRate;
  uint _systemRandomSeed;
  uint _skinnedMeshDebugFlag;
  float4 _viewPosShifted;
  float4 _viewPosShiftedPrev;
  float4 _viewTileRelativePos;
  float4 _viewTileRelativePosPrev;
  int2 _viewTileIndex;
  int2 _viewTileIndexPrev;
  float4 _worldVolume;
  float3 _diffViewPosAccurate;
  uint _isAllowBlood;
};

cbuffer __3__1__0__0__EffectOffScreenParticleConstants : register(b0, space1) {
  int2 _effectTileDataSize : packoffset(c000.x);
  float2 _effectTileDataSizeInv : packoffset(c000.z);
  int2 _renderTargetSize : packoffset(c001.x);
  float2 _renderTargetSizeInv : packoffset(c001.z);
  int2 _inputTextureSizeForTileData : packoffset(c002.x);
  int _isRenderedOffscreenParticlesHalf : packoffset(c002.z);
  int _isRenderedOffscreenParticlesQuarter : packoffset(c002.w);
  float _compositeAlphaRangeMax : packoffset(c003.x);
};

SamplerState __0__4__0__0__g_staticBilinearClamp : register(s3, space4);

SamplerState __0__4__0__0__g_staticPointClamp : register(s10, space4);

[numthreads(16, 16, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  int __loop_jump_target = -1;
  uint _21 = (int)(SV_GroupID.x) % _effectTileDataSize.x;
  int _22 = (int)(SV_GroupID.x) / _effectTileDataSize.x;
  uint _24 = __3__36__0__0__g_effectTileCoords.Load(int3(_21, _22, 0));
  int _26 = (uint)((uint)(_24.x)) >> 16;
  int _27 = _26 << 4;
  uint _28 = (uint)(_24.x) << 4;
  int _29 = _28 & 1048560;
  uint _30 = _27 + SV_GroupThreadID.x;
  uint _31 = _29 + SV_GroupThreadID.y;
  bool _34 = ((uint)_renderTargetSize.x > (uint)_30);
  float _67;
  int _68;
  float _69;
  float _70;
  float _71;
  float _72;
  float _73;
  float _177;
  bool _207;
  bool _234;
  float _235;
  float _236;
  float _237;
  float _238;
  if (_34) {
    bool _37 = ((uint)_renderTargetSize.y > (uint)_31);
    if (_37) {
      float _39 = float((uint)_30);
      float _40 = float((uint)_31);
      float _41 = _39 + 0.5f;
      float _42 = _40 + 0.5f;
      float _46 = _renderTargetSizeInv.x * _41;
      float _47 = _renderTargetSizeInv.y * _42;
      float _50 = __3__36__0__0__g_sceneDepth.Sample(__0__4__0__0__g_staticPointClamp, float2(_46, _47));
      float _54 = max(1.0000000116860974e-07f, _50.x);
      float _55 = _nearFarProj.x / _54;
      float _56 = float((int)(_renderTargetSize.x));
      float _57 = float((int)(_renderTargetSize.y));
      float _58 = 2.0f / _56;
      float _59 = 2.0f / _57;
      int _60 = _30 % 2;
      int _61 = _31 % 2;
      int _62 = _60 << 1;
      int _63 = _61 << 1;
      int _64 = _62 + -1;
      int _65 = _63 + -1;
      _67 = _55;
      _68 = 0;
      _69 = _55;
      _70 = _55;
      _71 = 0.0f;
      _72 = _46;
      _73 = _47;
      while(true) {
        int _74 = _68 * _65;
        float _75 = float((int)(_74));
        float _76 = _75 * _59;
        float _77 = _76 + _47;
        float _80 = __3__36__0__0__g_atmosphericScatteringDepth.SampleLevel(__0__4__0__0__g_staticPointClamp, float2(_46, _77), 0.0f);
        float _84 = max(1.0000000116860974e-07f, _80.x);
        float _85 = _nearFarProj.x / _84;
        float _86 = min(_69, _85);
        float _87 = max(_70, _85);
        bool _88 = (_87 > 0.0f);
        float _89 = _87 - _86;
        float _90 = _89 / _87;
        float _91 = select(_88, _90, 0.0f);
        float _92 = max(_71, _91);
        float _93 = _85 - _55;
        float _94 = abs(_93);
        bool _95 = (_94 < _67);
        float _96 = select(_95, _94, _67);
        float _97 = select(_95, _46, _72);
        float _98 = float((int)(_64));
        float _99 = _98 * _58;
        float _100 = _99 + _46;
        float _101 = __3__36__0__0__g_atmosphericScatteringDepth.SampleLevel(__0__4__0__0__g_staticPointClamp, float2(_100, _77), 0.0f);
        float _103 = max(1.0000000116860974e-07f, _101.x);
        float _104 = _nearFarProj.x / _103;
        float _105 = min(_86, _104);
        float _106 = max(_87, _104);
        bool _107 = (_106 > 0.0f);
        float _108 = _106 - _105;
        float _109 = _108 / _106;
        float _110 = select(_107, _109, 0.0f);
        float _111 = max(_92, _110);
        float _112 = _104 - _55;
        float _113 = abs(_112);
        bool _114 = (_113 < _96);
        float _115 = select(_114, _113, _96);
        float _116 = select(_114, _100, _97);
        bool _117 = (_114) | (_95);
        float _118 = select(_117, _77, _73);
        int _119 = _68 + 1;
        bool _120 = (_119 == 2);
        if (!_120) {
          _67 = _115;
          _68 = _119;
          _69 = _105;
          _70 = _106;
          _71 = _111;
          _72 = _116;
          _73 = _118;
          continue;
        }
        float4 _124 = __3__36__0__0__g_offScreenParticleAlphaBlend.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_46, _47), 0.0f);
        float4 _129 = __3__36__0__0__g_offScreenParticleAlphaBlend.SampleLevel(__0__4__0__0__g_staticPointClamp, float2(_116, _118), 0.0f);
        float2 _135 = __3__36__0__0__g_offscreenParticleDepth.SampleLevel(__0__4__0__0__g_staticPointClamp, float2(_46, _47), 0.0f);
        float2 _137 = __3__36__0__0__g_offscreenParticleDepth.SampleLevel(__0__4__0__0__g_staticPointClamp, float2(_116, _118), 0.0f);
        float2 _140 = __3__36__0__0__g_offscreenParticleDepthQuarter.SampleLevel(__0__4__0__0__g_staticPointClamp, float2(_46, _47), 0.0f);
        float2 _142 = __3__36__0__0__g_offscreenParticleDepth.Load(int3(_30, _31, 0));
        float _144 = _56 * 0.5f;
        float _145 = _144 * _116;
        float _146 = _57 * 0.5f;
        float _147 = _146 * _118;
        int _148 = int(_145);
        int _149 = int(_147);
        float2 _150 = __3__36__0__0__g_offscreenParticleDepthQuarter.Load(int3(_148, _149, 0));
        float _152 = max(_142.x, _150.x);
        float _153 = _nearFarProj.x * 1e+07f;
        bool _154 = (_153 <= _106);
        float _155 = max(1.0000000116860974e-07f, _152);
        float _156 = _nearFarProj.x / _155;
        bool _157 = (_105 < _156);
        bool _158 = (_154) | (_157);
        if (_158) {
          float _160 = _111 * 100.0f;
          _177 = _160;
        } else {
          float _162 = _124.w - _129.w;
          float _163 = abs(_162);
          float _164 = _163 * _111;
          float _165 = log2(_164);
          float _166 = _165 * 0.5f;
          float _167 = exp2(_166);
          float _168 = _167 * 4.0f;
          float _169 = _106 * -0.014426949433982372f;
          float _170 = exp2(_169);
          float _171 = saturate(_170);
          float _172 = 1.0f - _129.w;
          float _173 = _172 + _171;
          float _174 = saturate(_173);
          float _175 = _168 * _174;
          _177 = _175;
        }
        float _178 = saturate(_177);
        float _179 = _129.x - _124.x;
        float _180 = _129.y - _124.y;
        float _181 = _129.z - _124.z;
        float _182 = _129.w - _124.w;
        float _183 = _178 * _179;
        float _184 = _178 * _180;
        float _185 = _178 * _181;
        float _186 = _178 * _182;
        float _187 = _183 + _124.x;
        float _188 = _184 + _124.y;
        float _189 = _185 + _124.z;
        float _190 = _186 + _124.w;
        bool _191 = !(_187 == 0.0f);
        bool _192 = !(_188 == 0.0f);
        bool _193 = !(_189 == 0.0f);
        bool _194 = !(_190 == 1.0f);
        bool _195 = (_191) | (_192);
        bool _196 = (_193) | (_195);
        bool _197 = (_194) | (_196);
        if (_197) {
          bool _199 = !(_129.x == 0.0f);
          bool _200 = !(_129.y == 0.0f);
          bool _201 = !(_129.z == 0.0f);
          bool _202 = !(_129.w == 1.0f);
          bool _203 = (_199) | (_200);
          bool _204 = (_201) | (_203);
          bool _205 = (_202) | (_204);
          _207 = _205;
        } else {
          _207 = false;
        }
        float _208 = select(_207, _187, 0.0f);
        float _209 = select(_207, _188, 0.0f);
        float _210 = select(_207, _189, 0.0f);
        float _211 = select(_207, _190, 1.0f);

        // RenoDX: Apply MB hue correction to flame VFX colour
        if (LOCAL_LIGHT_HUE_CORRECTION > 0.f || abs(LOCAL_LIGHT_SATURATION - 1.f) > 1e-6f) {
          float3 _vfx_corrected = ApplyLocalLightHueCorrection(
              float3(_208, _209, _210),
              LOCAL_LIGHT_HUE_CORRECTION,
              LOCAL_LIGHT_SATURATION);
          _208 = _vfx_corrected.x;
          _209 = _vfx_corrected.y;
          _210 = _vfx_corrected.z;
        }

        bool _212 = (_135.y == 27.0f);
        bool _213 = (_137.y == 27.0f);
        bool _214 = (_212) | (_213);
        bool _215 = (_135.y == 28.0f);
        bool _216 = (_137.y == 28.0f);
        bool _217 = (_215) | (_216);
        bool _218 = (_140.y == 28.0f);
        bool _219 = (_217) | (_218);
        float4 _221 = __3__36__0__0__g_inputSceneColor.Load(int3(_30, _31, 0));
        bool _226 = (_221.w == 0.0f);
        if (_226) {
          float4 _229 = __3__38__0__1__g_sceneColorUAV.Load(int2(_30, _31));
          _234 = _207;
          _235 = _229.x;
          _236 = _229.y;
          _237 = _229.z;
          _238 = 0.0f;
        } else {
          _234 = true;
          _235 = _221.x;
          _236 = _221.y;
          _237 = _221.z;
          _238 = _221.w;
        }
        float _239 = _235 * _211;
        float _240 = _236 * _211;
        float _241 = _237 * _211;
        float _242 = _239 + _208;
        float _243 = _240 + _209;
        float _244 = _241 + _210;
        float _245 = 1.0f - _238;
        float _246 = saturate(_245);
        float _247 = dot(float3(_208, _209, _210), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
        float _248 = _247 * 0.10000000149011612f;
        float _249 = 1.0f - _248;
        float _250 = saturate(_249);
        float _251 = min(_211, _250);
        float _252 = _251 * _246;
        __3__38__0__1__g_sceneColorUAV[int2(_30, _31)] = float4(_242, _243, _244, _252);
        if (_234) {
          int _255 = select(_214, 27, 26);
          int _256 = select(_219, 28, _255);
          int _257 = _256 + -27;
          bool _258 = ((uint)_257 > (uint)1);
          bool _259 = (_256 != 26);
          bool _260 = (_259) & (_258);
          if (!_260) {
            uint _263 = __3__38__0__1__g_materialIdUAV.Load(int2(_30, _31));
            int _265 = _263.x & 128;
            int _266 = _265 | _256;
            __3__38__0__1__g_materialIdUAV[int2(_30, _31)] = _266;
          }
        }
        break;
      }
    }
  }
}
