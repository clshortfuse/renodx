
#include "../denoising.hlsli"

cbuffer RayTracingDenoiserConstantBufferInfo : register(b0, space0) {
  uint WaveletStep : packoffset(c000.x);
  float AODistance : packoffset(c000.y);
  uint UserStencilMask : packoffset(c000.z);
  float compressEV : packoffset(c000.w);
  uint diff_RT_WIDTH : packoffset(c001.x);
  uint diff_RT_HEIGHT : packoffset(c001.y);
  float diff_INV_RT_WIDTH : packoffset(c001.z);
  float diff_INV_RT_HEIGHT : packoffset(c001.w);
  uint spec_RT_WIDTH : packoffset(c002.x);
  uint spec_RT_HEIGHT : packoffset(c002.y);
  float spec_INV_RT_WIDTH : packoffset(c002.z);
  float spec_INV_RT_HEIGHT : packoffset(c002.w);
  float diffuseMultipler : packoffset(c003.x);
  float specularMultipler : packoffset(c003.y);
  float modelScaler : packoffset(c003.z);
  float depthRejectionThresold : packoffset(c003.w);
  float specularRoughnessThreshold : packoffset(c004.x);
  uint disocclusionStep : packoffset(c004.y);
  float maxDiffuseHistory : packoffset(c004.z);
  float maxSpecularHistory : packoffset(c004.w);
  float4 Rotator0 : packoffset(c005.x);
  float4 Rotator1 : packoffset(c006.x);
  float4 Rotator2 : packoffset(c007.x);
  float4 Rotator3 : packoffset(c008.x);
  row_major float4x4 prevViewProjInvMat : packoffset(c009.x);
  uint diffuseMaxIterationCount : packoffset(c013.x);
  uint specularMaxIterationCount : packoffset(c013.y);
  uint ps5HeatmapMode : packoffset(c013.z);
  float heatmapMaxIntersectionCount : packoffset(c013.w);
  float2 diffResolutionRatio : packoffset(c014.x);
  float GIHistoryThreshold : packoffset(c014.z);
  float GIFilterCenterWeight : packoffset(c014.w);
  float VFXDiffuseBoost : packoffset(c015.x);
  float VFXSpecularBoost : packoffset(c015.y);
  uint VFXSpecularMipBias : packoffset(c015.z);
  float VFXDiffuseResolutionRatio : packoffset(c015.w);
  float VFXSpecularResolutionRatio : packoffset(c016.x);
  float VFXInvalidateTemporalRatio : packoffset(c016.y);
  float VFXPrevSpecularResolutionRatio : packoffset(c016.z);
  float VFXTemporalCompositeRate : packoffset(c016.w);
  uint medianFilterStepSize : packoffset(c017.x);
  float specularSecondaryBounceRoughnessThreshold : packoffset(c017.y);
  float2 diffInvResolutionRatio : packoffset(c017.z);
  float2 specResolutionRatio : packoffset(c018.x);
  float2 specInvResolutionRatio : packoffset(c018.z);
  float specularTraceRoughnessThreshold : packoffset(c019.x);
  uint diffuseDisocclusionFrameRange : packoffset(c019.y);
  float diffuseDisocclusionFilteringStrength : packoffset(c019.z);
  float reserved0 : packoffset(c019.w);
  float iblLeakingAmountDiff : packoffset(c020.x);
  float iblLeakingAmountSpec : packoffset(c020.y);
  float iblLeakingDistanceDiff : packoffset(c020.z);
  float iblLeakingDistanceSpec : packoffset(c020.w);
  float2 diffUVAdjuster : packoffset(c021.x);
  float2 specUVAdjuster : packoffset(c021.z);
};
Texture2D<float4> specSRV : register(t0);
Texture2D<float> depthSRV : register(t1);
RWTexture2D<float4> specUAV : register(u0);

static uint3 gl_GlobalInvocationID;
struct SPIRV_Cross_Input {
  uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
};

void comp_main() {
  uint2 pixel = gl_GlobalInvocationID.xy;
  if (!(depthSRV.Load(int3(pixel, 0u)).x <= 0.0f)) {
    if (RT_SKIP_DEFLICKER) {
      specUAV[pixel] = specSRV.Load(int3(pixel, 0u));
      return;
    }

    float _54;
    uint _57;
    float _33[9];
    float _34[9];
    float _35[9];
    float _36[9];
    float _37[9];
    float _38[9];
    float _39[9];
    float _40[9];
    float _41[9];
    float _42[9];
    float _43[9];
    float _44[9];
    float _61;
    uint _62;
    uint _63;
    float _53 = 1.0f;
    uint _56 = 0u;
    uint _58 = 4294967295u;
    for (;;) {
      _61 = _53;
      _62 = _56;
      _63 = 4294967295u;
      uint _74;
      uint _75;
      bool _87;
      for (;;) {
        uint4 _70 = uint4(medianFilterStepSize, asuint(specularSecondaryBounceRoughnessThreshold), asuint(diffInvResolutionRatio));
        uint _71 = _70.x;
        _74 = (_71 * _63) + gl_GlobalInvocationID.x;
        _75 = (_71 * _58) + gl_GlobalInvocationID.y;
        uint4 _79 = uint4(spec_RT_WIDTH, spec_RT_HEIGHT, asuint(spec_INV_RT_WIDTH), asuint(spec_INV_RT_HEIGHT));
        _87 = (int(_75) < int(_79.y)) && ((int(_74) < int(_79.x)) && (int(_74 | _75) > int(4294967295u)));
        float frontier_phi_8_pred;
        uint frontier_phi_8_pred_1;
        for (;;) {
          if (_87) {
            if (!(depthSRV.Load(int3(uint2(_74, _75), 0u)).x < 0.0f)) {
              float4 _116 = specSRV.Load(int3(uint2(_74, _75), 0u));
              uint _124 = (_63 + 4u) + (_58 * 3u);
              _33[_124] = _116.x;
              _34[_124] = _116.y;
              _35[_124] = _116.z;
              _36[_124] = _116.w;
              frontier_phi_8_pred = _61;
              frontier_phi_8_pred_1 = _62 + 1u;
              break;
            }
          }
          float _93 = _61 * 66000.0f;
          uint _99 = (_63 + 4u) + (_58 * 3u);
          _41[_99] = _93;
          _42[_99] = _93;
          _43[_99] = _93;
          _44[_99] = _93;
          _37[_99] = _93;
          _38[_99] = _93;
          _39[_99] = _93;
          _40[_99] = _93;
          _33[_99] = _93;
          _34[_99] = _93;
          _35[_99] = _93;
          _36[_99] = _93;
          frontier_phi_8_pred = (-0.0f) - _61;
          frontier_phi_8_pred_1 = _62;
          break;
        }
        _54 = frontier_phi_8_pred;
        _57 = frontier_phi_8_pred_1;
        uint _64 = _63 + 1u;
        if (_64 == 2u) {
          break;
        } else {
          _61 = _54;
          _62 = _57;
          _63 = _64;
          continue;
        }
      }
      uint _59 = _58 + 1u;
      if (_59 == 2u) {
        break;
      } else {
        _53 = _54;
        _56 = _57;
        _58 = _59;
        continue;
      }
    }
    float _814;
    float _815;
    float _816;
    float _817;
    if (int(_57) > int(2u)) {
      float _214 = max(_41[0u], _41[1u]);
      float _215 = max(_42[0u], _42[1u]);
      float _216 = max(_43[0u], _43[1u]);
      float _220 = max(_44[0u], _44[1u]);
      float _239 = min(min(_214, max(_41[2u], _41[1u])), max(_41[2u], _41[0u]));
      float _240 = min(min(_215, max(_42[2u], _42[1u])), max(_42[2u], _42[0u]));
      float _241 = min(min(_216, max(_43[2u], _43[1u])), max(_43[2u], _43[0u]));
      float _245 = min(min(_220, max(_44[2u], _44[1u])), max(_44[2u], _44[0u]));
      float _246 = max(_41[3u], _41[4u]);
      float _247 = max(_42[3u], _42[4u]);
      float _248 = max(_43[3u], _43[4u]);
      float _252 = max(_44[3u], _44[4u]);
      float _271 = min(min(_246, max(_41[5u], _41[4u])), max(_41[5u], _41[3u]));
      float _272 = min(min(_247, max(_42[5u], _42[4u])), max(_42[5u], _42[3u]));
      float _273 = min(min(_248, max(_43[5u], _43[4u])), max(_43[5u], _43[3u]));
      float _277 = min(min(_252, max(_44[5u], _44[4u])), max(_44[5u], _44[3u]));
      float _278 = max(_41[6u], _41[7u]);
      float _279 = max(_42[6u], _42[7u]);
      float _280 = max(_43[6u], _43[7u]);
      float _284 = max(_44[6u], _44[7u]);
      float _303 = min(min(_278, max(_41[8u], _41[7u])), max(_41[8u], _41[6u]));
      float _304 = min(min(_279, max(_42[8u], _42[7u])), max(_42[8u], _42[6u]));
      float _305 = min(min(_280, max(_43[8u], _43[7u])), max(_43[8u], _43[6u]));
      float _309 = min(min(_284, max(_44[8u], _44[7u])), max(_44[8u], _44[6u]));
      float _313 = max(max(min(min(_41[0u], _41[1u]), _41[2u]), min(min(_41[3u], _41[4u]), _41[5u])), min(min(_41[6u], _41[7u]), _41[8u]));
      float _314 = max(max(min(min(_42[0u], _42[1u]), _42[2u]), min(min(_42[3u], _42[4u]), _42[5u])), min(min(_42[6u], _42[7u]), _42[8u]));
      float _315 = max(max(min(min(_43[0u], _43[1u]), _43[2u]), min(min(_43[3u], _43[4u]), _43[5u])), min(min(_43[6u], _43[7u]), _43[8u]));
      float _317 = max(max(min(min(_44[0u], _44[1u]), _44[2u]), min(min(_44[3u], _44[4u]), _44[5u])), min(min(_44[6u], _44[7u]), _44[8u]));
      float _321 = min(min(max(_214, _41[2u]), max(_246, _41[5u])), max(_278, _41[8u]));
      float _322 = min(min(max(_215, _42[2u]), max(_247, _42[5u])), max(_279, _42[8u]));
      float _323 = min(min(max(_216, _43[2u]), max(_248, _43[5u])), max(_280, _43[8u]));
      float _325 = min(min(max(_220, _44[2u]), max(_252, _44[5u])), max(_284, _44[8u]));
      float _338 = min(min(max(_239, _271), max(_303, _271)), max(_303, _239));
      float _339 = min(min(max(_240, _272), max(_304, _272)), max(_304, _240));
      float _340 = min(min(max(_241, _273), max(_305, _273)), max(_305, _241));
      float _345 = min(min(max(_245, _277), max(_309, _277)), max(_309, _245));
      _41[4u] = min(min(max(_313, _321), max(_338, _321)), max(_338, _313));
      _42[4u] = min(min(max(_314, _322), max(_339, _322)), max(_339, _314));
      _43[4u] = min(min(max(_315, _323), max(_340, _323)), max(_340, _315));
      _44[4u] = min(min(max(_317, _325), max(_345, _325)), max(_345, _317));
      float _438 = max(_37[0u], _37[1u]);
      float _439 = max(_38[0u], _38[1u]);
      float _440 = max(_39[0u], _39[1u]);
      float _444 = max(_40[0u], _40[1u]);
      float _463 = min(min(_438, max(_37[2u], _37[1u])), max(_37[2u], _37[0u]));
      float _464 = min(min(_439, max(_38[2u], _38[1u])), max(_38[2u], _38[0u]));
      float _465 = min(min(_440, max(_39[2u], _39[1u])), max(_39[2u], _39[0u]));
      float _469 = min(min(_444, max(_40[2u], _40[1u])), max(_40[2u], _40[0u]));
      float _470 = max(_37[3u], _37[4u]);
      float _471 = max(_38[3u], _38[4u]);
      float _472 = max(_39[3u], _39[4u]);
      float _476 = max(_40[3u], _40[4u]);
      float _495 = min(min(_470, max(_37[5u], _37[4u])), max(_37[5u], _37[3u]));
      float _496 = min(min(_471, max(_38[5u], _38[4u])), max(_38[5u], _38[3u]));
      float _497 = min(min(_472, max(_39[5u], _39[4u])), max(_39[5u], _39[3u]));
      float _501 = min(min(_476, max(_40[5u], _40[4u])), max(_40[5u], _40[3u]));
      float _502 = max(_37[6u], _37[7u]);
      float _503 = max(_38[6u], _38[7u]);
      float _504 = max(_39[6u], _39[7u]);
      float _508 = max(_40[6u], _40[7u]);
      float _527 = min(min(_502, max(_37[8u], _37[7u])), max(_37[8u], _37[6u]));
      float _528 = min(min(_503, max(_38[8u], _38[7u])), max(_38[8u], _38[6u]));
      float _529 = min(min(_504, max(_39[8u], _39[7u])), max(_39[8u], _39[6u]));
      float _533 = min(min(_508, max(_40[8u], _40[7u])), max(_40[8u], _40[6u]));
      float _537 = max(max(min(min(_37[0u], _37[1u]), _37[2u]), min(min(_37[3u], _37[4u]), _37[5u])), min(min(_37[6u], _37[7u]), _37[8u]));
      float _538 = max(max(min(min(_38[0u], _38[1u]), _38[2u]), min(min(_38[3u], _38[4u]), _38[5u])), min(min(_38[6u], _38[7u]), _38[8u]));
      float _539 = max(max(min(min(_39[0u], _39[1u]), _39[2u]), min(min(_39[3u], _39[4u]), _39[5u])), min(min(_39[6u], _39[7u]), _39[8u]));
      float _541 = max(max(min(min(_40[0u], _40[1u]), _40[2u]), min(min(_40[3u], _40[4u]), _40[5u])), min(min(_40[6u], _40[7u]), _40[8u]));
      float _545 = min(min(max(_438, _37[2u]), max(_470, _37[5u])), max(_502, _37[8u]));
      float _546 = min(min(max(_439, _38[2u]), max(_471, _38[5u])), max(_503, _38[8u]));
      float _547 = min(min(max(_440, _39[2u]), max(_472, _39[5u])), max(_504, _39[8u]));
      float _549 = min(min(max(_444, _40[2u]), max(_476, _40[5u])), max(_508, _40[8u]));
      float _562 = min(min(max(_463, _495), max(_527, _495)), max(_527, _463));
      float _563 = min(min(max(_464, _496), max(_528, _496)), max(_528, _464));
      float _564 = min(min(max(_465, _497), max(_529, _497)), max(_529, _465));
      float _569 = min(min(max(_469, _501), max(_533, _501)), max(_533, _469));
      _37[4u] = min(min(max(_537, _545), max(_562, _545)), max(_562, _537));
      _38[4u] = min(min(max(_538, _546), max(_563, _546)), max(_563, _538));
      _39[4u] = min(min(max(_539, _547), max(_564, _547)), max(_564, _539));
      _40[4u] = min(min(max(_541, _549), max(_569, _549)), max(_569, _541));
      float _594 = _33[8u];
      float _595 = _34[8u];
      float _596 = _35[8u];
      float _597 = _36[8u];
      float _602 = _33[7u];
      float _603 = _34[7u];
      float _604 = _35[7u];
      float _605 = _36[7u];
      float _610 = _33[6u];
      float _611 = _34[6u];
      float _612 = _35[6u];
      float _613 = _36[6u];
      float _618 = _33[5u];
      float _619 = _34[5u];
      float _620 = _35[5u];
      float _621 = _36[5u];
      float _622 = _33[4u];
      float _623 = _34[4u];
      float _624 = _35[4u];
      float _625 = _36[4u];
      float _630 = _33[3u];
      float _631 = _34[3u];
      float _632 = _35[3u];
      float _633 = _36[3u];
      float _638 = _33[2u];
      float _639 = _34[2u];
      float _640 = _35[2u];
      float _641 = _36[2u];
      float _646 = _33[1u];
      float _647 = _34[1u];
      float _648 = _35[1u];
      float _649 = _36[1u];
      float _654 = _33[0u];
      float _655 = _34[0u];
      float _656 = _35[0u];
      float _657 = _36[0u];
      float _658 = max(_654, _646);
      float _659 = max(_655, _647);
      float _660 = max(_656, _648);
      float _664 = max(_657, _649);
      float _683 = min(min(_658, max(_638, _646)), max(_638, _654));
      float _684 = min(min(_659, max(_639, _647)), max(_639, _655));
      float _685 = min(min(_660, max(_640, _648)), max(_640, _656));
      float _689 = min(min(_664, max(_641, _649)), max(_641, _657));
      float _690 = max(_630, _622);
      float _691 = max(_631, _623);
      float _692 = max(_632, _624);
      float _696 = max(_633, _625);
      float _715 = min(min(_690, max(_618, _622)), max(_618, _630));
      float _716 = min(min(_691, max(_619, _623)), max(_619, _631));
      float _717 = min(min(_692, max(_620, _624)), max(_620, _632));
      float _721 = min(min(_696, max(_621, _625)), max(_621, _633));
      float _722 = max(_610, _602);
      float _723 = max(_611, _603);
      float _724 = max(_612, _604);
      float _728 = max(_613, _605);
      float _747 = min(min(_722, max(_594, _602)), max(_594, _610));
      float _748 = min(min(_723, max(_595, _603)), max(_595, _611));
      float _749 = min(min(_724, max(_596, _604)), max(_596, _612));
      float _753 = min(min(_728, max(_597, _605)), max(_597, _613));
      float _757 = max(max(min(min(_654, _646), _638), min(min(_630, _622), _618)), min(min(_610, _602), _594));
      float _758 = max(max(min(min(_655, _647), _639), min(min(_631, _623), _619)), min(min(_611, _603), _595));
      float _759 = max(max(min(min(_656, _648), _640), min(min(_632, _624), _620)), min(min(_612, _604), _596));
      float _761 = max(max(min(min(_657, _649), _641), min(min(_633, _625), _621)), min(min(_613, _605), _597));
      float _765 = min(min(max(_658, _638), max(_690, _618)), max(_722, _594));
      float _766 = min(min(max(_659, _639), max(_691, _619)), max(_723, _595));
      float _767 = min(min(max(_660, _640), max(_692, _620)), max(_724, _596));
      float _769 = min(min(max(_664, _641), max(_696, _621)), max(_728, _597));
      float _782 = min(min(max(_683, _715), max(_747, _715)), max(_747, _683));
      float _783 = min(min(max(_684, _716), max(_748, _716)), max(_748, _684));
      float _784 = min(min(max(_685, _717), max(_749, _717)), max(_749, _685));
      float _789 = min(min(max(_689, _721), max(_753, _721)), max(_753, _689));
      float _802 = min(min(max(_757, _765), max(_782, _765)), max(_782, _757));
      float _803 = min(min(max(_758, _766), max(_783, _766)), max(_783, _758));
      float _804 = min(min(max(_759, _767), max(_784, _767)), max(_784, _759));
      float _809 = min(min(max(_761, _769), max(_789, _769)), max(_789, _761));
      _33[4u] = _802;
      _34[4u] = _803;
      _35[4u] = _804;
      _36[4u] = _809;
      _814 = _809;
      _815 = _804;
      _816 = _803;
      _817 = _802;
    } else {
      _814 = _36[4u];
      _815 = _35[4u];
      _816 = _34[4u];
      _817 = _33[4u];
    }
    specUAV[pixel] = float4(_817, _816, _815, _814);
  }
}

[numthreads(16, 16, 1)]
void main(SPIRV_Cross_Input stage_input) {
  gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
  comp_main();
}
