#include "sharpening.hlsli"

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
    float3 pixel0 = ApplyLiliumRCAS(SrcImage, int2(_16, _17), sharpness_strength, tex_max);
    float3 pixel1 = ApplyLiliumRCAS(SrcImage, int2(_16 | 8, _17), sharpness_strength, tex_max);
    float3 pixel2 = ApplyLiliumRCAS(SrcImage, int2(_16 | 8, _17 | 8), sharpness_strength, tex_max);
    float3 pixel3 = ApplyLiliumRCAS(SrcImage, int2(_16, _17 | 8), sharpness_strength, tex_max);
    if (CUSTOM_FILM_GRAIN != 0.f)
    {
      float ref_white = RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
      pixel0 = renodx::effects::ApplyFilmGrain(pixel0, float2(_16, _17) / float2(tex_max), CUSTOM_RANDOM, CUSTOM_FILM_GRAIN * 0.03f, ref_white);
      pixel1 = renodx::effects::ApplyFilmGrain(pixel1, float2(_16 | 8, _17) / float2(tex_max), CUSTOM_RANDOM, CUSTOM_FILM_GRAIN * 0.03f, ref_white);
      pixel2 = renodx::effects::ApplyFilmGrain(pixel2, float2(_16 | 8, _17 | 8) / float2(tex_max), CUSTOM_RANDOM, CUSTOM_FILM_GRAIN * 0.03f, ref_white);
      pixel3 = renodx::effects::ApplyFilmGrain(pixel3, float2(_16, _17 | 8) / float2(tex_max), CUSTOM_RANDOM, CUSTOM_FILM_GRAIN * 0.03f, ref_white);
    }
    OutputImage[int2(_16, _17)] = float4(pixel0, 1.f);
    OutputImage[int2(_16 | 8, _17)] = float4(pixel1, 1.f);
    OutputImage[int2(_16 | 8, _17 | 8)] = float4(pixel2, 1.f);
    OutputImage[int2(_16, _17 | 8)] = float4(pixel3, 1.f);
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
    float _85 = asfloat(((uint)(((int)((uint)((int)(asint(saturate(asfloat(((uint)(2129690299u - (int)(asint(_72))))) * min(min(min(min(min(_38, _46), _55), _29), _64), (1.0f - _72)))))) >> 1)) + 532432441u))) * asfloat((uint)(const1.x));
    float _87 = (_85 * 4.0f) + 1.0f;
    float _90 = asfloat(((uint)(2129764351u - (int)(asint(_87)))));
    float _93 = (2.0f - (_90 * _87)) * _90;
    OutputImage[int2(_16, _17)] = float4((saturate((((_85 * (((max(0.0f, _31.x) + max(0.0f, _22.x)) + max(0.0f, _48.x)) + max(0.0f, _57.x))) + max(0.0f, _39.x)) * 0.0078125f) * _93) * 128.0f), (saturate(_93 * ((((((_36 + _27) + _53) + _62) * 0.0078125f) * _85) + _46)) * 128.0f), (saturate((((_85 * (((max(0.0f, _31.z) + max(0.0f, _22.z)) + max(0.0f, _48.z)) + max(0.0f, _57.z))) + max(0.0f, _39.z)) * 0.0078125f) * _93) * 128.0f), 1.0f);
    int _122 = _16 | 8;
    float4 _126 = SrcImage.Load(int3(_122, _20, 0));
    float _131 = max(0.0f, _126.y);
    float _133 = _131 * 0.0078125f;
    uint _134 = _122 + -1u;
    float4 _135 = SrcImage.Load(int3(_134, _17, 0));
    float _140 = max(0.0f, _135.y);
    float _142 = _140 * 0.0078125f;
    float4 _143 = SrcImage.Load(int3(_122, _17, 0));
    float _150 = max(0.0f, _143.y) * 0.0078125f;
    uint _151 = _122 + 1u;
    float4 _152 = SrcImage.Load(int3(_151, _17, 0));
    float _157 = max(0.0f, _152.y);
    float _159 = _157 * 0.0078125f;
    float4 _160 = SrcImage.Load(int3(_122, _56, 0));
    float _165 = max(0.0f, _160.y);
    float _167 = _165 * 0.0078125f;
    float _175 = max(max(max(max(_142, _150), _159), _133), _167);
    float _188 = asfloat(((uint)(((int)((uint)((int)(asint(saturate(asfloat(((uint)(2129690299u - (int)(asint(_175))))) * min(min(min(min(min(_142, _150), _159), _133), _167), (1.0f - _175)))))) >> 1)) + 532432441u))) * asfloat((uint)(const1.x));
    float _190 = (_188 * 4.0f) + 1.0f;
    float _193 = asfloat(((uint)(2129764351u - (int)(asint(_190)))));
    float _196 = (2.0f - (_193 * _190)) * _193;
    OutputImage[int2(_122, _17)] = float4((saturate((((_188 * (((max(0.0f, _135.x) + max(0.0f, _126.x)) + max(0.0f, _152.x)) + max(0.0f, _160.x))) + max(0.0f, _143.x)) * 0.0078125f) * _196) * 128.0f), (saturate(_196 * ((((((_140 + _131) + _157) + _165) * 0.0078125f) * _188) + _150)) * 128.0f), (saturate((((_188 * (((max(0.0f, _135.z) + max(0.0f, _126.z)) + max(0.0f, _152.z)) + max(0.0f, _160.z))) + max(0.0f, _143.z)) * 0.0078125f) * _196) * 128.0f), 1.0f);
    int _225 = _17 | 8;
    uint _228 = _225 + -1u;
    float4 _230 = SrcImage.Load(int3(_122, _228, 0));
    float _235 = max(0.0f, _230.y);
    float _237 = _235 * 0.0078125f;
    float4 _238 = SrcImage.Load(int3(_134, _225, 0));
    float _243 = max(0.0f, _238.y);
    float _245 = _243 * 0.0078125f;
    float4 _246 = SrcImage.Load(int3(_122, _225, 0));
    float _253 = max(0.0f, _246.y) * 0.0078125f;
    float4 _254 = SrcImage.Load(int3(_151, _225, 0));
    float _259 = max(0.0f, _254.y);
    float _261 = _259 * 0.0078125f;
    uint _262 = _225 + 1u;
    float4 _263 = SrcImage.Load(int3(_122, _262, 0));
    float _268 = max(0.0f, _263.y);
    float _270 = _268 * 0.0078125f;
    float _278 = max(max(max(max(_245, _253), _261), _237), _270);
    float _291 = asfloat(((uint)(((int)((uint)((int)(asint(saturate(asfloat(((uint)(2129690299u - (int)(asint(_278))))) * min(min(min(min(min(_245, _253), _261), _237), _270), (1.0f - _278)))))) >> 1)) + 532432441u))) * asfloat((uint)(const1.x));
    float _293 = (_291 * 4.0f) + 1.0f;
    float _296 = asfloat(((uint)(2129764351u - (int)(asint(_293)))));
    float _299 = (2.0f - (_296 * _293)) * _296;
    OutputImage[int2(_122, _225)] = float4((saturate((((_291 * (((max(0.0f, _238.x) + max(0.0f, _230.x)) + max(0.0f, _254.x)) + max(0.0f, _263.x))) + max(0.0f, _246.x)) * 0.0078125f) * _299) * 128.0f), (saturate(_299 * ((((((_243 + _235) + _259) + _268) * 0.0078125f) * _291) + _253)) * 128.0f), (saturate((((_291 * (((max(0.0f, _238.z) + max(0.0f, _230.z)) + max(0.0f, _254.z)) + max(0.0f, _263.z))) + max(0.0f, _246.z)) * 0.0078125f) * _299) * 128.0f), 1.0f);
    float4 _331 = SrcImage.Load(int3(_16, _228, 0));
    float _336 = max(0.0f, _331.y);
    float _338 = _336 * 0.0078125f;
    float4 _339 = SrcImage.Load(int3(_30, _225, 0));
    float _344 = max(0.0f, _339.y);
    float _346 = _344 * 0.0078125f;
    float4 _347 = SrcImage.Load(int3(_16, _225, 0));
    float _354 = max(0.0f, _347.y) * 0.0078125f;
    float4 _355 = SrcImage.Load(int3(_47, _225, 0));
    float _360 = max(0.0f, _355.y);
    float _362 = _360 * 0.0078125f;
    float4 _363 = SrcImage.Load(int3(_16, _262, 0));
    float _368 = max(0.0f, _363.y);
    float _370 = _368 * 0.0078125f;
    float _378 = max(max(max(max(_346, _354), _362), _338), _370);
    float _391 = asfloat(((uint)(((int)((uint)((int)(asint(saturate(asfloat(((uint)(2129690299u - (int)(asint(_378))))) * min(min(min(min(min(_346, _354), _362), _338), _370), (1.0f - _378)))))) >> 1)) + 532432441u))) * asfloat((uint)(const1.x));
    float _393 = (_391 * 4.0f) + 1.0f;
    float _396 = asfloat(((uint)(2129764351u - (int)(asint(_393)))));
    float _399 = (2.0f - (_396 * _393)) * _396;
    OutputImage[int2(_16, _225)] = float4((saturate((((_391 * (((max(0.0f, _339.x) + max(0.0f, _331.x)) + max(0.0f, _355.x)) + max(0.0f, _363.x))) + max(0.0f, _347.x)) * 0.0078125f) * _399) * 128.0f), (saturate(_399 * ((((((_344 + _336) + _360) + _368) * 0.0078125f) * _391) + _354)) * 128.0f), (saturate((((_391 * (((max(0.0f, _339.z) + max(0.0f, _331.z)) + max(0.0f, _355.z)) + max(0.0f, _363.z))) + max(0.0f, _347.z)) * 0.0078125f) * _399) * 128.0f), 1.0f);
  }
}
