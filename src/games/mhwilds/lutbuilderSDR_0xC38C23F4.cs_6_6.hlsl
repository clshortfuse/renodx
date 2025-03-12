
/*
;   struct OutputColorAdjustment
;   {
;
;       float fGamma;                                 ; Offset:    0
;       float fLowerLimit;                            ; Offset:    4
;       float fUpperLimit;                            ; Offset:    8
;       float fConvertToLimit;                        ; Offset:   12

;       float4 fConfigDrawRect;                       ; Offset:   16

;       float4 fSecondaryConfigDrawRect;              ; Offset:   32

;       float2 fConfigDrawRectSize;                   ; Offset:   48
;       float2 fSecondaryConfigDrawRectSize;          ; Offset:   56

;       uint uConfigMode;                             ; Offset:   64
;       float fConfigImageIntensity;                  ; Offset:   68
;       float fSecondaryConfigImageIntensity;         ; Offset:   72
;       float fConfigImageAlphaScale;                 ; Offset:   76

;       float fGammaForOverlay;                       ; Offset:   80
;       float fLowerLimitForOverlay;                  ; Offset:   84
;       float fConvertToLimitForOverlay;              ; Offset:   88
;
;   } OutputColorAdjustment;
 */
cbuffer OutputColorAdjustmentUBO : register(b0, space0) {
  float4 OutputColorAdjustment_m0[6] : packoffset(c0);
};

Texture2D<float4> OCIO_lut1d_0 : register(t0, space0);
Texture3D<float4> OCIO_lut3d_1 : register(t1, space0);
RWTexture3D<float4> OutLUT : register(u0, space0);
SamplerState BilinearClamp : register(s5, space32);
SamplerState TrilinearClamp : register(s9, space32);

static uint3 gl_GlobalInvocationID;
struct SPIRV_Cross_Input {
  uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
};

void comp_main() {
  float _39 = float(gl_GlobalInvocationID.x);
  float _40 = float(gl_GlobalInvocationID.y);
  float _41 = float(gl_GlobalInvocationID.z);
  float _42 = _39 * 0.01587301678955554962158203125f;
  float _44 = _40 * 0.01587301678955554962158203125f;
  float _45 = _41 * 0.01587301678955554962158203125f;
  float _63;
  if (_42 > (-0.3013699948787689208984375f)) {
    float frontier_phi_4_1_ladder;
    if (_42 < 1.46800005435943603515625f) {
      frontier_phi_4_1_ladder = exp2((_39 * 0.2780952751636505126953125f) + (-9.72000026702880859375f));
    } else {
      frontier_phi_4_1_ladder = 65504.0f;
    }
    _63 = frontier_phi_4_1_ladder;
  } else {
    _63 = exp2((_39 * 0.2780952751636505126953125f) + (-8.72000026702880859375f)) + (-3.0517578125e-05f);
  }
  float _74;
  if (_44 > (-0.3013699948787689208984375f)) {
    float frontier_phi_8_5_ladder;
    if (_44 < 1.46800005435943603515625f) {
      frontier_phi_8_5_ladder = exp2((_40 * 0.2780952751636505126953125f) + (-9.72000026702880859375f));
    } else {
      frontier_phi_8_5_ladder = 65504.0f;
    }
    _74 = frontier_phi_8_5_ladder;
  } else {
    _74 = exp2((_40 * 0.2780952751636505126953125f) + (-8.72000026702880859375f)) + (-3.0517578125e-05f);
  }
  float _84;
  if (_45 > (-0.3013699948787689208984375f)) {
    float frontier_phi_12_9_ladder;
    if (_45 < 1.46800005435943603515625f) {
      frontier_phi_12_9_ladder = exp2((_41 * 0.2780952751636505126953125f) + (-9.72000026702880859375f));
    } else {
      frontier_phi_12_9_ladder = 65504.0f;
    }
    _84 = frontier_phi_12_9_ladder;
  } else {
    _84 = exp2((_41 * 0.2780952751636505126953125f) + (-8.72000026702880859375f)) + (-3.0517578125e-05f);
  }
  float _89 = mad(_84, 0.1638689935207366943359375f, mad(_74, 0.14067900180816650390625f, _63 * 0.6954519748687744140625f));
  float _95 = mad(_84, 0.095534302294254302978515625f, mad(_74, 0.85967099666595458984375f, _63 * 0.0447946004569530487060546875f));
  float _101 = mad(_84, 1.00150001049041748046875f, mad(_74, 0.0040252101607620716094970703125f, _63 * (-0.0055258800275623798370361328125f)));
  float _103 = abs(_89);
  float _120;
  if (_103 > 6.103515625e-05f) {
    float _106 = min(_103, 65504.0f);
    float _108 = floor(log2(_106));
    float _109 = exp2(_108);
    _120 = dot(float3(_108, (_106 - _109) / _109, 15.0f), 1024.0f.xxx);
  } else {
    _120 = _103 * 16777216.0f;
  }
  float _125 = _120 + ((_89 > 0.0f) ? 0.0f : 32768.0f);
  float _128 = floor(_125 * 0.00024420025874860584735870361328125f);
  float _147 = abs(_95);
  float _159;
  if (_147 > 6.103515625e-05f) {
    float _149 = min(_147, 65504.0f);
    float _151 = floor(log2(_149));
    float _152 = exp2(_151);
    _159 = dot(float3(_151, (_149 - _152) / _152, 15.0f), 1024.0f.xxx);
  } else {
    _159 = _147 * 16777216.0f;
  }
  float _162 = _159 + ((_95 > 0.0f) ? 0.0f : 32768.0f);
  float _164 = floor(_162 * 0.00024420025874860584735870361328125f);
  float _175 = abs(_101);
  float _187;
  if (_175 > 6.103515625e-05f) {
    float _177 = min(_175, 65504.0f);
    float _179 = floor(log2(_177));
    float _180 = exp2(_179);
    _187 = dot(float3(_179, (_177 - _180) / _180, 15.0f), 1024.0f.xxx);
  } else {
    _187 = _175 * 16777216.0f;
  }
  float _190 = _187 + ((_101 > 0.0f) ? 0.0f : 32768.0f);
  float _192 = floor(_190 * 0.00024420025874860584735870361328125f);
  float _203 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2(((_125 + 0.5f) - (_128 * 4095.0f)) * 0.000244140625f, (_128 + 0.5f) * 0.0588235296308994293212890625f), 0.0f).x * 64.0f;
  float _205 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2(((_162 + 0.5f) - (_164 * 4095.0f)) * 0.000244140625f, (_164 + 0.5f) * 0.0588235296308994293212890625f), 0.0f).x * 64.0f;
  float _206 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2(((_190 + 0.5f) - (_192 * 4095.0f)) * 0.000244140625f, (_192 + 0.5f) * 0.0588235296308994293212890625f), 0.0f).x * 64.0f;
  float _207 = floor(_203);
  float _208 = floor(_205);
  float _209 = floor(_206);
  float _210 = _203 - _207;
  float _211 = _205 - _208;
  float _212 = _206 - _209;
  float _216 = (_209 + 0.5f) * 0.015384615398943424224853515625f;
  float _218 = (_208 + 0.5f) * 0.015384615398943424224853515625f;
  float _219 = (_207 + 0.5f) * 0.015384615398943424224853515625f;
  float4 _224 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_216, _218, _219), 0.0f);
  float _229 = _216 + 0.015384615398943424224853515625f;
  float _230 = _218 + 0.015384615398943424224853515625f;
  float _231 = _219 + 0.015384615398943424224853515625f;
  float4 _232 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_229, _230, _231), 0.0f);
  float _330;
  float _333;
  float _336;
  float _339;
  float _340;
  if (_210 < _211) {
    float frontier_phi_30_22_ladder;
    float frontier_phi_30_22_ladder_1;
    float frontier_phi_30_22_ladder_2;
    float frontier_phi_30_22_ladder_3;
    float frontier_phi_30_22_ladder_4;
    if (_211 > _212) {
      float frontier_phi_30_22_ladder_24_ladder;
      float frontier_phi_30_22_ladder_24_ladder_1;
      float frontier_phi_30_22_ladder_24_ladder_2;
      float frontier_phi_30_22_ladder_24_ladder_3;
      float frontier_phi_30_22_ladder_24_ladder_4;
      if (_210 < _212) {
        float4 _287 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_216, _230, _219), 0.0f);
        float4 _292 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_229, _230, _219), 0.0f);
        float _297 = _211 - _212;
        float _298 = _212 - _210;
        frontier_phi_30_22_ladder_24_ladder = (_292.x * _298) + (_287.x * _297);
        frontier_phi_30_22_ladder_24_ladder_1 = (_292.y * _298) + (_287.y * _297);
        frontier_phi_30_22_ladder_24_ladder_2 = (_292.z * _298) + (_287.z * _297);
        frontier_phi_30_22_ladder_24_ladder_3 = _211;
        frontier_phi_30_22_ladder_24_ladder_4 = _210;
      } else {
        float4 _309 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_216, _230, _219), 0.0f);
        float4 _314 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_216, _230, _231), 0.0f);
        float _319 = _211 - _210;
        float _320 = _210 - _212;
        frontier_phi_30_22_ladder_24_ladder = (_314.x * _320) + (_309.x * _319);
        frontier_phi_30_22_ladder_24_ladder_1 = (_314.y * _320) + (_309.y * _319);
        frontier_phi_30_22_ladder_24_ladder_2 = (_314.z * _320) + (_309.z * _319);
        frontier_phi_30_22_ladder_24_ladder_3 = _211;
        frontier_phi_30_22_ladder_24_ladder_4 = _212;
      }
      frontier_phi_30_22_ladder = frontier_phi_30_22_ladder_24_ladder;
      frontier_phi_30_22_ladder_1 = frontier_phi_30_22_ladder_24_ladder_1;
      frontier_phi_30_22_ladder_2 = frontier_phi_30_22_ladder_24_ladder_2;
      frontier_phi_30_22_ladder_3 = frontier_phi_30_22_ladder_24_ladder_3;
      frontier_phi_30_22_ladder_4 = frontier_phi_30_22_ladder_24_ladder_4;
    } else {
      float4 _242 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_229, _218, _219), 0.0f);
      float4 _247 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_229, _230, _219), 0.0f);
      float _252 = _212 - _211;
      float _253 = _211 - _210;
      frontier_phi_30_22_ladder = (_247.x * _253) + (_242.x * _252);
      frontier_phi_30_22_ladder_1 = (_247.y * _253) + (_242.y * _252);
      frontier_phi_30_22_ladder_2 = (_247.z * _253) + (_242.z * _252);
      frontier_phi_30_22_ladder_3 = _212;
      frontier_phi_30_22_ladder_4 = _210;
    }
    _330 = frontier_phi_30_22_ladder;
    _333 = frontier_phi_30_22_ladder_1;
    _336 = frontier_phi_30_22_ladder_2;
    _339 = frontier_phi_30_22_ladder_3;
    _340 = frontier_phi_30_22_ladder_4;
  } else {
    float frontier_phi_30_23_ladder;
    float frontier_phi_30_23_ladder_1;
    float frontier_phi_30_23_ladder_2;
    float frontier_phi_30_23_ladder_3;
    float frontier_phi_30_23_ladder_4;
    if (_211 < _212) {
      float frontier_phi_30_23_ladder_26_ladder;
      float frontier_phi_30_23_ladder_26_ladder_1;
      float frontier_phi_30_23_ladder_26_ladder_2;
      float frontier_phi_30_23_ladder_26_ladder_3;
      float frontier_phi_30_23_ladder_26_ladder_4;
      if (_210 < _212) {
        float4 _380 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_229, _218, _219), 0.0f);
        float4 _385 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_229, _218, _231), 0.0f);
        float _390 = _212 - _210;
        float _391 = _210 - _211;
        frontier_phi_30_23_ladder_26_ladder = (_385.x * _391) + (_380.x * _390);
        frontier_phi_30_23_ladder_26_ladder_1 = (_385.y * _391) + (_380.y * _390);
        frontier_phi_30_23_ladder_26_ladder_2 = (_385.z * _391) + (_380.z * _390);
        frontier_phi_30_23_ladder_26_ladder_3 = _212;
        frontier_phi_30_23_ladder_26_ladder_4 = _211;
      } else {
        float4 _399 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_216, _218, _231), 0.0f);
        float4 _404 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_229, _218, _231), 0.0f);
        float _409 = _210 - _212;
        float _410 = _212 - _211;
        frontier_phi_30_23_ladder_26_ladder = (_404.x * _410) + (_399.x * _409);
        frontier_phi_30_23_ladder_26_ladder_1 = (_404.y * _410) + (_399.y * _409);
        frontier_phi_30_23_ladder_26_ladder_2 = (_404.z * _410) + (_399.z * _409);
        frontier_phi_30_23_ladder_26_ladder_3 = _210;
        frontier_phi_30_23_ladder_26_ladder_4 = _211;
      }
      frontier_phi_30_23_ladder = frontier_phi_30_23_ladder_26_ladder;
      frontier_phi_30_23_ladder_1 = frontier_phi_30_23_ladder_26_ladder_1;
      frontier_phi_30_23_ladder_2 = frontier_phi_30_23_ladder_26_ladder_2;
      frontier_phi_30_23_ladder_3 = frontier_phi_30_23_ladder_26_ladder_3;
      frontier_phi_30_23_ladder_4 = frontier_phi_30_23_ladder_26_ladder_4;
    } else {
      float4 _265 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_216, _218, _231), 0.0f);
      float4 _270 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_216, _230, _231), 0.0f);
      float _275 = _210 - _211;
      float _276 = _211 - _212;
      frontier_phi_30_23_ladder = (_270.x * _276) + (_265.x * _275);
      frontier_phi_30_23_ladder_1 = (_270.y * _276) + (_265.y * _275);
      frontier_phi_30_23_ladder_2 = (_270.z * _276) + (_265.z * _275);
      frontier_phi_30_23_ladder_3 = _210;
      frontier_phi_30_23_ladder_4 = _212;
    }
    _330 = frontier_phi_30_23_ladder;
    _333 = frontier_phi_30_23_ladder_1;
    _336 = frontier_phi_30_23_ladder_2;
    _339 = frontier_phi_30_23_ladder_3;
    _340 = frontier_phi_30_23_ladder_4;
  }
  precise float _341 = 1.0f - _339;
  float fGamma = 1.f;           //// OutputColorAdjustment_m0[0u].x
  float fLowerLimit = 0.f;      // OutputColorAdjustment_m0[0u].y
  float fConvertToLimit = 1.f;  // OutputColorAdjustment_m0[0u].w
  OutLUT[uint3(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y, gl_GlobalInvocationID.z)] =
      float4((exp2(log2(((_341 * _224.x) + _330) + (_340 * _232.x)) * fGamma) * fConvertToLimit) + fLowerLimit, (exp2(log2(((_341 * _224.y) + _333) + (_340 * _232.y)) * fGamma) * fConvertToLimit) + fLowerLimit, (exp2(log2(((_341 * _224.z) + _336) + (_340 * _232.z)) * fGamma) * fConvertToLimit) + fLowerLimit, 1.0f);
}

[numthreads(8, 8, 8)]
void main(SPIRV_Cross_Input stage_input) {
  gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
  comp_main();
}
