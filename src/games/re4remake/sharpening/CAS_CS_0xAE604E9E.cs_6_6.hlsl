#include "./sharpening.hlsli"

Texture2D<float4> SrcImage : register(t0);

RWTexture2D<float4> OutputImage : register(u0);

cbuffer cbCAS : register(b0) {
  uint4 const0 : packoffset(c000.x);
  uint4 const1 : packoffset(c001.x);
};

[numthreads(64, 1, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  int _16 = (((uint)(SV_GroupThreadID.x) >> 1) & 7) | ((uint)((uint)(SV_GroupID.x) << 4));
  int _17 = ((((uint)(SV_GroupThreadID.x) >> 3) & 6) | ((uint)(SV_GroupThreadID.x) & 1)) | ((uint)((uint)(SV_GroupID.y) << 4));

  if (CUSTOM_SHARPENING == 1.f) {  // Lilium RCAS
    const float sharpness_strength = CUSTOM_SHARPENING_STRENGTH;
    uint2 tex_max;
    SrcImage.GetDimensions(tex_max.x, tex_max.y);
    
    // Process 4 pixels per thread with RCAS
    OutputImage[int2(_16, _17)] = float4(ApplyLiliumRCAS(SrcImage, int2(_16, _17), sharpness_strength, tex_max), 1.f);
    OutputImage[int2(_16 | 8, _17)] = float4(ApplyLiliumRCAS(SrcImage, int2(_16 | 8, _17), sharpness_strength, tex_max), 1.f);
    OutputImage[int2(_16 | 8, _17 | 8)] = float4(ApplyLiliumRCAS(SrcImage, int2(_16 | 8, _17 | 8), sharpness_strength, tex_max), 1.f);
    OutputImage[int2(_16, _17 | 8)] = float4(ApplyLiliumRCAS(SrcImage, int2(_16, _17 | 8), sharpness_strength, tex_max), 1.f);
    return;
  } else {
    uint _20 = _17 + -1u;
    float4 _22 = SrcImage.Load(int3(_16, _20, 0));
    float _27 = max(0.0f, _22.y);
    float _29 = _27 * 0.0078125f;
    uint _30 = _16 + -1u;
    float4 _31 = SrcImage.Load(int3(_30, _17, 0));
    float _36 = max(0.0f, _31.y);
    float _38 = _36 * 0.0078125f;
    float4 _39 = SrcImage.Load(int3(_16, _17, 0));
    float _46 = max(0.0f, _39.y) * 0.0078125f;
    int _47 = _16 + 1;
    float4 _48 = SrcImage.Load(int3(_47, _17, 0));
    float _53 = max(0.0f, _48.y);
    float _55 = _53 * 0.0078125f;
    int _56 = _17 + 1;
    float4 _57 = SrcImage.Load(int3(_16, _56, 0));
    float _62 = max(0.0f, _57.y);
    float _64 = _62 * 0.0078125f;
    float _72 = max(max(max(max(_38, _46), _55), _29), _64);
    float _85 = asfloat(((uint)(((int)((uint)((int)(asint(saturate(asfloat(((uint)(2129690299u - (int)(asint(_72))))) * min(min(min(min(min(_38, _46), _55), _29), _64), (1.0f - _72)))))) >> 1)) + 532432441u))) * asfloat(const1.x);
    float _87 = (_85 * 4.0f) + 1.0f;
    float _90 = asfloat(((uint)(2129764351u - (int)(asint(_87)))));
    float _93 = (2.0f - (_90 * _87)) * _90;
    OutputImage[int2(_16, _17)] = float4((saturate((((_85 * (((max(0.0f, _31.x) + max(0.0f, _22.x)) + max(0.0f, _48.x)) + max(0.0f, _57.x))) + max(0.0f, _39.x)) * 0.0078125f) * _93) * 128.0f), (saturate(_93 * ((((((_36 + _27) + _53) + _62) * 0.0078125f) * _85) + _46)) * 128.0f), (saturate((((_85 * (((max(0.0f, _31.z) + max(0.0f, _22.z)) + max(0.0f, _48.z)) + max(0.0f, _57.z))) + max(0.0f, _39.z)) * 0.0078125f) * _93) * 128.0f), 1.0f);
    int _122 = _16 | 8;
    float4 _126 = SrcImage.Load(int3(_122, _20, 0));
    float _131 = max(0.0f, _126.y);
    float _133 = _131 * 0.0078125f;
    float4 _135 = SrcImage.Load(int3(((uint)(_122 + -1u)), _17, 0));
    float _140 = max(0.0f, _135.y);
    float _142 = _140 * 0.0078125f;
    float4 _143 = SrcImage.Load(int3(_122, _17, 0));
    float _150 = max(0.0f, _143.y) * 0.0078125f;
    float4 _152 = SrcImage.Load(int3(((uint)(_122 + 1u)), _17, 0));
    float _157 = max(0.0f, _152.y);
    float _159 = _157 * 0.0078125f;
    float4 _160 = SrcImage.Load(int3(_122, _56, 0));
    float _165 = max(0.0f, _160.y);
    float _167 = _165 * 0.0078125f;
    float _175 = max(max(max(max(_142, _150), _159), _133), _167);
    float _188 = asfloat(((uint)(((int)((uint)((int)(asint(saturate(asfloat(((uint)(2129690299u - (int)(asint(_175))))) * min(min(min(min(min(_142, _150), _159), _133), _167), (1.0f - _175)))))) >> 1)) + 532432441u))) * asfloat(const1.x);
    float _190 = (_188 * 4.0f) + 1.0f;
    float _193 = asfloat(((uint)(2129764351u - (int)(asint(_190)))));
    float _196 = (2.0f - (_193 * _190)) * _193;
    OutputImage[int2(_122, _17)] = float4((saturate((((_188 * (((max(0.0f, _135.x) + max(0.0f, _126.x)) + max(0.0f, _152.x)) + max(0.0f, _160.x))) + max(0.0f, _143.x)) * 0.0078125f) * _196) * 128.0f), (saturate(_196 * ((((((_140 + _131) + _157) + _165) * 0.0078125f) * _188) + _150)) * 128.0f), (saturate((((_188 * (((max(0.0f, _135.z) + max(0.0f, _126.z)) + max(0.0f, _152.z)) + max(0.0f, _160.z))) + max(0.0f, _143.z)) * 0.0078125f) * _196) * 128.0f), 1.0f);
    int _225 = _17 | 8;
    uint _228 = _17 + 7u;
    float4 _230 = SrcImage.Load(int3(_122, _228, 0));
    float _235 = max(0.0f, _230.y);
    float _237 = _235 * 0.0078125f;
    float4 _239 = SrcImage.Load(int3(((uint)(_16 + 7u)), _225, 0));
    float _244 = max(0.0f, _239.y);
    float _246 = _244 * 0.0078125f;
    float4 _247 = SrcImage.Load(int3(_122, _225, 0));
    float _254 = max(0.0f, _247.y) * 0.0078125f;
    float4 _256 = SrcImage.Load(int3(((uint)(_16 + 9u)), _225, 0));
    float _261 = max(0.0f, _256.y);
    float _263 = _261 * 0.0078125f;
    uint _264 = _17 + 9u;
    float4 _265 = SrcImage.Load(int3(_122, _264, 0));
    float _270 = max(0.0f, _265.y);
    float _272 = _270 * 0.0078125f;
    float _280 = max(max(max(max(_246, _254), _263), _237), _272);
    float _293 = asfloat(((uint)(((int)((uint)((int)(asint(saturate(asfloat(((uint)(2129690299u - (int)(asint(_280))))) * min(min(min(min(min(_246, _254), _263), _237), _272), (1.0f - _280)))))) >> 1)) + 532432441u))) * asfloat(const1.x);
    float _295 = (_293 * 4.0f) + 1.0f;
    float _298 = asfloat(((uint)(2129764351u - (int)(asint(_295)))));
    float _301 = (2.0f - (_298 * _295)) * _298;
    OutputImage[int2(_122, _225)] = float4((saturate((((_293 * (((max(0.0f, _239.x) + max(0.0f, _230.x)) + max(0.0f, _256.x)) + max(0.0f, _265.x))) + max(0.0f, _247.x)) * 0.0078125f) * _301) * 128.0f), (saturate(_301 * ((((((_244 + _235) + _261) + _270) * 0.0078125f) * _293) + _254)) * 128.0f), (saturate((((_293 * (((max(0.0f, _239.z) + max(0.0f, _230.z)) + max(0.0f, _256.z)) + max(0.0f, _265.z))) + max(0.0f, _247.z)) * 0.0078125f) * _301) * 128.0f), 1.0f);
    float4 _333 = SrcImage.Load(int3(_16, _228, 0));
    float _338 = max(0.0f, _333.y);
    float _340 = _338 * 0.0078125f;
    float4 _341 = SrcImage.Load(int3(_30, _225, 0));
    float _346 = max(0.0f, _341.y);
    float _348 = _346 * 0.0078125f;
    float4 _349 = SrcImage.Load(int3(_16, _225, 0));
    float _356 = max(0.0f, _349.y) * 0.0078125f;
    float4 _357 = SrcImage.Load(int3(_47, _225, 0));
    float _362 = max(0.0f, _357.y);
    float _364 = _362 * 0.0078125f;
    float4 _365 = SrcImage.Load(int3(_16, _264, 0));
    float _370 = max(0.0f, _365.y);
    float _372 = _370 * 0.0078125f;
    float _380 = max(max(max(max(_348, _356), _364), _340), _372);
    float _393 = asfloat(((uint)(((int)((uint)((int)(asint(saturate(asfloat(((uint)(2129690299u - (int)(asint(_380))))) * min(min(min(min(min(_348, _356), _364), _340), _372), (1.0f - _380)))))) >> 1)) + 532432441u))) * asfloat(const1.x);
    float _395 = (_393 * 4.0f) + 1.0f;
    float _398 = asfloat(((uint)(2129764351u - (int)(asint(_395)))));
    float _401 = (2.0f - (_398 * _395)) * _398;
    OutputImage[int2(_16, _225)] = float4((saturate((((_393 * (((max(0.0f, _341.x) + max(0.0f, _333.x)) + max(0.0f, _357.x)) + max(0.0f, _365.x))) + max(0.0f, _349.x)) * 0.0078125f) * _401) * 128.0f), (saturate(_401 * ((((((_346 + _338) + _362) + _370) * 0.0078125f) * _393) + _356)) * 128.0f), (saturate((((_393 * (((max(0.0f, _341.z) + max(0.0f, _333.z)) + max(0.0f, _357.z)) + max(0.0f, _365.z))) + max(0.0f, _349.z)) * 0.0078125f) * _401) * 128.0f), 1.0f);
  }
}
