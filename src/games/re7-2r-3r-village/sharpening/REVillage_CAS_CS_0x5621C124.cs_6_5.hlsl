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
  int _15 = (((uint)(SV_GroupThreadID.x) >> 1) & 7) | ((uint)((uint)(SV_GroupID.x) << 4));
  int _16 = ((((uint)(SV_GroupThreadID.x) >> 3) & 6) | ((uint)(SV_GroupThreadID.x) & 1)) | ((uint)((uint)(SV_GroupID.y) << 4));
  
  if (CUSTOM_SHARPENING == 0.f) {
    int _119 = _15 | 8;
    int _220 = _16 | 8;
    OutputImage[int2(_15, _16)] = float4(SrcImage.Load(int3(_15, _16, 0)).rgb, 1.f);  
    OutputImage[int2(_119, _16)] = float4(SrcImage.Load(int3(_119, _16, 0)).rgb, 1.f);
    OutputImage[int2(_119, _220)] = float4(SrcImage.Load(int3(_119, _220, 0)).rgb, 1.f);
    OutputImage[int2(_15, _220)] = float4(SrcImage.Load(int3(_15, _220, 0)).rgb, 1.f);
    return;
  } else if (CUSTOM_SHARPENING == 2.f) {  // Lilium RCAS
    float sharpness_strength = 0.75f;  // asfloat(const1.x)
    
    int _119 = _15 | 8;
    int _220 = _16 | 8;
    uint tex_width, tex_height;
    SrcImage.GetDimensions(tex_width, tex_height);
    int2 tex_max = int2(tex_width - 1, tex_height - 1);

    // Process 4 pixels per thread with RCAS
    OutputImage[int2(_15, _16)] = float4(ApplyLiliumRCAS(SrcImage, int2(_15, _16), sharpness_strength, tex_max), 1.f);
    OutputImage[int2(_119, _16)] = float4(ApplyLiliumRCAS(SrcImage, int2(_119, _16), sharpness_strength, tex_max), 1.f);
    OutputImage[int2(_119, _220)] = float4(ApplyLiliumRCAS(SrcImage, int2(_119, _220), sharpness_strength, tex_max), 1.f);
    OutputImage[int2(_15, _220)] = float4(ApplyLiliumRCAS(SrcImage, int2(_15, _220), sharpness_strength, tex_max), 1.f);
    return;
  } else {  // Original CAS Implementation
    uint _19 = _16 + -1u;
    float4 _20 = SrcImage.Load(int3(_15, _19, 0));
    float _25 = max(0.0f, _20.y);
    float _27 = _25 * 0.0078125f;
    uint _28 = _15 + -1u;
    float4 _29 = SrcImage.Load(int3(_28, _16, 0));
    float _34 = max(0.0f, _29.y);
    float _36 = _34 * 0.0078125f;
    float4 _37 = SrcImage.Load(int3(_15, _16, 0));
    float _44 = max(0.0f, _37.y) * 0.0078125f;
    int _45 = _15 + 1;
    float4 _46 = SrcImage.Load(int3(_45, _16, 0));
    float _51 = max(0.0f, _46.y);
    float _53 = _51 * 0.0078125f;
    int _54 = _16 + 1;
    float4 _55 = SrcImage.Load(int3(_15, _54, 0));
    float _60 = max(0.0f, _55.y);
    float _62 = _60 * 0.0078125f;
    float _70 = max(max(max(max(_36, _44), _53), _27), _62);
    float _83 = asfloat(((uint)(((int)((uint)((int)(asint(saturate(asfloat(((uint)(2129690299u - (int)(asint(_70))))) * min(min(min(min(min(_36, _44), _53), _27), _62), (1.0f - _70)))))) >> 1)) + 532432441u))) * asfloat(const1.x);
    float _85 = (_83 * 4.0f) + 1.0f;
    float _88 = asfloat(((uint)(2129764351u - (int)(asint(_85)))));
    float _91 = (2.0f - (_88 * _85)) * _88;
    OutputImage[int2(_15, _16)] = float4((saturate((((_83 * (((max(0.0f, _29.x) + max(0.0f, _20.x)) + max(0.0f, _46.x)) + max(0.0f, _55.x))) + max(0.0f, _37.x)) * 0.0078125f) * _91) * 128.0f), (saturate(_91 * ((((((_34 + _25) + _51) + _60) * 0.0078125f) * _83) + _44)) * 128.0f), (saturate((((_83 * (((max(0.0f, _29.z) + max(0.0f, _20.z)) + max(0.0f, _46.z)) + max(0.0f, _55.z))) + max(0.0f, _37.z)) * 0.0078125f) * _91) * 128.0f), 1.0f);
    int _119 = _15 | 8;
    float4 _122 = SrcImage.Load(int3(_119, _19, 0));
    float _127 = max(0.0f, _122.y);
    float _129 = _127 * 0.0078125f;
    uint _130 = _119 + -1u;
    float4 _131 = SrcImage.Load(int3(_130, _16, 0));
    float _136 = max(0.0f, _131.y);
    float _138 = _136 * 0.0078125f;
    float4 _139 = SrcImage.Load(int3(_119, _16, 0));
    float _146 = max(0.0f, _139.y) * 0.0078125f;
    uint _147 = _119 + 1u;
    float4 _148 = SrcImage.Load(int3(_147, _16, 0));
    float _153 = max(0.0f, _148.y);
    float _155 = _153 * 0.0078125f;
    float4 _156 = SrcImage.Load(int3(_119, _54, 0));
    float _161 = max(0.0f, _156.y);
    float _163 = _161 * 0.0078125f;
    float _171 = max(max(max(max(_138, _146), _155), _129), _163);
    float _184 = asfloat(((uint)(((int)((uint)((int)(asint(saturate(asfloat(((uint)(2129690299u - (int)(asint(_171))))) * min(min(min(min(min(_138, _146), _155), _129), _163), (1.0f - _171)))))) >> 1)) + 532432441u))) * asfloat(const1.x);
    float _186 = (_184 * 4.0f) + 1.0f;
    float _189 = asfloat(((uint)(2129764351u - (int)(asint(_186)))));
    float _192 = (2.0f - (_189 * _186)) * _189;
    OutputImage[int2(_119, _16)] = float4((saturate((((_184 * (((max(0.0f, _131.x) + max(0.0f, _122.x)) + max(0.0f, _148.x)) + max(0.0f, _156.x))) + max(0.0f, _139.x)) * 0.0078125f) * _192) * 128.0f), (saturate(_192 * ((((((_136 + _127) + _153) + _161) * 0.0078125f) * _184) + _146)) * 128.0f), (saturate((((_184 * (((max(0.0f, _131.z) + max(0.0f, _122.z)) + max(0.0f, _148.z)) + max(0.0f, _156.z))) + max(0.0f, _139.z)) * 0.0078125f) * _192) * 128.0f), 1.0f);
    int _220 = _16 | 8;
    uint _223 = _220 + -1u;
    float4 _224 = SrcImage.Load(int3(_119, _223, 0));
    float _229 = max(0.0f, _224.y);
    float _231 = _229 * 0.0078125f;
    float4 _232 = SrcImage.Load(int3(_130, _220, 0));
    float _237 = max(0.0f, _232.y);
    float _239 = _237 * 0.0078125f;
    float4 _240 = SrcImage.Load(int3(_119, _220, 0));
    float _247 = max(0.0f, _240.y) * 0.0078125f;
    float4 _248 = SrcImage.Load(int3(_147, _220, 0));
    float _253 = max(0.0f, _248.y);
    float _255 = _253 * 0.0078125f;
    uint _256 = _220 + 1u;
    float4 _257 = SrcImage.Load(int3(_119, _256, 0));
    float _262 = max(0.0f, _257.y);
    float _264 = _262 * 0.0078125f;
    float _272 = max(max(max(max(_239, _247), _255), _231), _264);
    float _285 = asfloat(((uint)(((int)((uint)((int)(asint(saturate(asfloat(((uint)(2129690299u - (int)(asint(_272))))) * min(min(min(min(min(_239, _247), _255), _231), _264), (1.0f - _272)))))) >> 1)) + 532432441u))) * asfloat(const1.x);
    float _287 = (_285 * 4.0f) + 1.0f;
    float _290 = asfloat(((uint)(2129764351u - (int)(asint(_287)))));
    float _293 = (2.0f - (_290 * _287)) * _290;
    OutputImage[int2(_119, _220)] = float4((saturate((((_285 * (((max(0.0f, _232.x) + max(0.0f, _224.x)) + max(0.0f, _248.x)) + max(0.0f, _257.x))) + max(0.0f, _240.x)) * 0.0078125f) * _293) * 128.0f), (saturate(_293 * ((((((_237 + _229) + _253) + _262) * 0.0078125f) * _285) + _247)) * 128.0f), (saturate((((_285 * (((max(0.0f, _232.z) + max(0.0f, _224.z)) + max(0.0f, _248.z)) + max(0.0f, _257.z))) + max(0.0f, _240.z)) * 0.0078125f) * _293) * 128.0f), 1.0f);
    float4 _323 = SrcImage.Load(int3(_15, _223, 0));
    float _328 = max(0.0f, _323.y);
    float _330 = _328 * 0.0078125f;
    float4 _331 = SrcImage.Load(int3(_28, _220, 0));
    float _336 = max(0.0f, _331.y);
    float _338 = _336 * 0.0078125f;
    float4 _339 = SrcImage.Load(int3(_15, _220, 0));
    float _346 = max(0.0f, _339.y) * 0.0078125f;
    float4 _347 = SrcImage.Load(int3(_45, _220, 0));
    float _352 = max(0.0f, _347.y);
    float _354 = _352 * 0.0078125f;
    float4 _355 = SrcImage.Load(int3(_15, _256, 0));
    float _360 = max(0.0f, _355.y);
    float _362 = _360 * 0.0078125f;
    float _370 = max(max(max(max(_338, _346), _354), _330), _362);
    float _383 = asfloat(((uint)(((int)((uint)((int)(asint(saturate(asfloat(((uint)(2129690299u - (int)(asint(_370))))) * min(min(min(min(min(_338, _346), _354), _330), _362), (1.0f - _370)))))) >> 1)) + 532432441u))) * asfloat(const1.x);
    float _385 = (_383 * 4.0f) + 1.0f;
    float _388 = asfloat(((uint)(2129764351u - (int)(asint(_385)))));
    float _391 = (2.0f - (_388 * _385)) * _388;
    OutputImage[int2(_15, _220)] = float4((saturate((((_383 * (((max(0.0f, _331.x) + max(0.0f, _323.x)) + max(0.0f, _347.x)) + max(0.0f, _355.x))) + max(0.0f, _339.x)) * 0.0078125f) * _391) * 128.0f), (saturate(_391 * ((((((_336 + _328) + _352) + _360) * 0.0078125f) * _383) + _346)) * 128.0f), (saturate((((_383 * (((max(0.0f, _331.z) + max(0.0f, _323.z)) + max(0.0f, _347.z)) + max(0.0f, _355.z))) + max(0.0f, _339.z)) * 0.0078125f) * _391) * 128.0f), 1.0f);
  } // End else block (Original CAS)
}
