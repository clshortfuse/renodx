#include "../common.hlsl"

Texture2D<float4> t0_space4 : register(t0, space4);

RWTexture2D<float4> u0_space4 : register(u0, space4);

cbuffer cb0_space2 : register(b0, space2) {
  struct FrameData {
    int FrameData_000;
    int FrameData_004;
    float2 FrameData_008;
    float FrameData_016;
    float FrameData_020;
    float FrameData_024;
    float FrameData_028;
    float FrameData_032;
    int FrameData_036;
    float FrameData_040;
    float FrameData_044;
    float4 FrameData_048;
    float FrameData_064;
    float FrameData_068;
    int FrameData_072;
    int FrameData_076;
    struct FrameDebug {
      int2 FrameDebug_000;
      int2 FrameDebug_008;
      int2 FrameDebug_016;
      int FrameDebug_024;
      int FrameDebug_028;
      float FrameDebug_032;
      int FrameDebug_036;
      int FrameDebug_040;
      int FrameDebug_044;
      int FrameDebug_048;
      int FrameDebug_052;
      int FrameDebug_056;
      int FrameDebug_060;
    }
    FrameData_080;
  }
SharedFrameData_000:
  packoffset(c000.x);
};

cbuffer cb0_space4 : register(b0, space4) {
  struct ContrastAdaptiveSharpeningData {
    int4 ContrastAdaptiveSharpeningData_000;
    int4 ContrastAdaptiveSharpeningData_016;
    int4 ContrastAdaptiveSharpeningData_032;
    int4 ContrastAdaptiveSharpeningData_048;
  }
CASData_000:
  packoffset(c000.x);
};

[numthreads(64, 1, 1)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  uint _23 = (int)(CASData_000.ContrastAdaptiveSharpeningData_032.x) + ((int)((((uint)(SV_GroupThreadID.x) >> 1) & 7) | ((uint)((uint)(SV_GroupID.x) << 4))));
  uint _24 = ((int)(((((uint)(SV_GroupThreadID.x) >> 3) & 6) | ((uint)(SV_GroupThreadID.x) & 1)) | ((uint)((uint)(SV_GroupID.y) << 4)))) + (int)(CASData_000.ContrastAdaptiveSharpeningData_032.y);
  half _29 = half(SharedFrameData_000.FrameData_028);

  _29 = 2.4h;

  uint _35 = _23 << 16;
  uint _36 = _35 >> 16;
  uint _37 = _24 << 16;

  uint _45 = ((uint)(max(min(_36, CASData_000.ContrastAdaptiveSharpeningData_048.z), CASData_000.ContrastAdaptiveSharpeningData_048.x) << 16)) >> 16;
  uint _47 = ((uint)(max(min(((uint)(((uint)(_37 + -65536u)) >> 16)), CASData_000.ContrastAdaptiveSharpeningData_048.w), CASData_000.ContrastAdaptiveSharpeningData_048.y) << 16)) >> 16;
  float4 _49 = t0_space4.Load(int3(_45, _47, 0));
  half _53 = half(_49.x);
  half _54 = half(_49.y);
  half _55 = half(_49.z);
  uint _57 = ((uint)(_35 + -65536u)) >> 16;
  uint _66 = ((uint)(max(min(((uint)(_37 >> 16)), CASData_000.ContrastAdaptiveSharpeningData_048.w), CASData_000.ContrastAdaptiveSharpeningData_048.y) << 16)) >> 16;
  float4 _67 = t0_space4.Load(int3(((uint)(((uint)(max(min(_57, CASData_000.ContrastAdaptiveSharpeningData_048.z), CASData_000.ContrastAdaptiveSharpeningData_048.x) << 16)) >> 16)), _66, 0));
  half _71 = half(_67.x);
  half _72 = half(_67.y);
  half _73 = half(_67.z);
  float4 _74 = t0_space4.Load(int3(_45, _66, 0));
  half _78 = half(_74.x);
  half _79 = half(_74.y);
  half _80 = half(_74.z);
  uint _82 = ((uint)(_35 + 65536u)) >> 16;
  float4 _87 = t0_space4.Load(int3(((uint)(((uint)(max(min(_82, CASData_000.ContrastAdaptiveSharpeningData_048.z), CASData_000.ContrastAdaptiveSharpeningData_048.x) << 16)) >> 16)), _66, 0));
  half _91 = half(_87.x);
  half _92 = half(_87.y);
  half _93 = half(_87.z);
  uint _99 = ((uint)(max(min(((uint)(((uint)(_37 + 65536u)) >> 16)), CASData_000.ContrastAdaptiveSharpeningData_048.w), CASData_000.ContrastAdaptiveSharpeningData_048.y) << 16)) >> 16;
  float4 _100 = t0_space4.Load(int3(_45, _99, 0));
  half _104 = half(_100.x);
  half _105 = half(_100.y);
  half _106 = half(_100.z);
  uint _109 = ((uint)((_23 << 16) + 524288u)) >> 16;
  uint _113 = ((uint)(max(min(_109, CASData_000.ContrastAdaptiveSharpeningData_048.z), CASData_000.ContrastAdaptiveSharpeningData_048.x) << 16)) >> 16;
  float4 _114 = t0_space4.Load(int3(_113, _47, 0));
  half _118 = half(_114.x);
  half _119 = half(_114.y);
  half _120 = half(_114.z);
  uint _122 = ((uint)(_35 + 458752u)) >> 16;
  float4 _127 = t0_space4.Load(int3(((uint)(((uint)(max(min(_122, CASData_000.ContrastAdaptiveSharpeningData_048.z), CASData_000.ContrastAdaptiveSharpeningData_048.x) << 16)) >> 16)), _66, 0));
  half _131 = half(_127.x);
  half _132 = half(_127.y);
  half _133 = half(_127.z);
  float4 _134 = t0_space4.Load(int3(_113, _66, 0));
  half _138 = half(_134.x);
  half _139 = half(_134.y);
  half _140 = half(_134.z);
  uint _142 = ((uint)(_35 + 589824u)) >> 16;
  float4 _147 = t0_space4.Load(int3(((uint)(((uint)(max(min(_142, CASData_000.ContrastAdaptiveSharpeningData_048.z), CASData_000.ContrastAdaptiveSharpeningData_048.x) << 16)) >> 16)), _66, 0));
  half _151 = half(_147.x);
  half _152 = half(_147.y);
  half _153 = half(_147.z);
  float4 _154 = t0_space4.Load(int3(_113, _99, 0));
  half _158 = half(_154.x);
  half _159 = half(_154.y);
  half _160 = half(_154.z);
  half _183 = (half)(min(1.0h, ((half)(_54 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_54 + 0.054992676h)) * 0.9477539h))) * _29)));
  half _184 = (half)(min(1.0h, ((half)(_119 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_119 + 0.054992676h)) * 0.9477539h))) * _29)));
  half _215 = (half)(min(1.0h, ((half)(_72 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_72 + 0.054992676h)) * 0.9477539h))) * _29)));
  half _216 = (half)(min(1.0h, ((half)(_132 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_132 + 0.054992676h)) * 0.9477539h))) * _29)));
  half _247 = (half)(min(1.0h, ((half)(_79 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_79 + 0.054992676h)) * 0.9477539h))) * _29)));
  half _248 = (half)(min(1.0h, ((half)(_139 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_139 + 0.054992676h)) * 0.9477539h))) * _29)));
  half _279 = (half)(min(1.0h, ((half)(_92 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_92 + 0.054992676h)) * 0.9477539h))) * _29)));
  half _280 = (half)(min(1.0h, ((half)(_152 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_152 + 0.054992676h)) * 0.9477539h))) * _29)));
  half _311 = (half)(min(1.0h, ((half)(_105 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_105 + 0.054992676h)) * 0.9477539h))) * _29)));
  half _312 = (half)(min(1.0h, ((half)(_159 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_159 + 0.054992676h)) * 0.9477539h))) * _29)));
  half _335 = max((half)(max(_279, _311)), (half)(max((half)(max(_183, _215)), _247)));
  half _336 = max((half)(max(_280, _312)), (half)(max((half)(max(_184, _216)), _248)));
  half _351 = half(f16tof32(((int)(CASData_000.ContrastAdaptiveSharpeningData_016.y & 65535))));
  half _352 = _351 * (half)(sqrt((half)(saturate((half)((half)(min((half)(min((half)(min(_279, _311)), (half)(min((half)(min(_183, _215)), _247)))), ((half)(1.0h - _335)))) * ((half)(1.0h / _335)))))));
  half _353 = _351 * (half)(sqrt((half)(saturate((half)((half)(min((half)(min((half)(min(_280, _312)), (half)(min((half)(min(_184, _216)), _248)))), ((half)(1.0h - _336)))) * ((half)(1.0h / _336)))))));
  half _358 = 1.0h / ((half)(((half)(_352 * 4.0h)) + 1.0h));
  half _359 = 1.0h / ((half)(((half)(_353 * 4.0h)) + 1.0h));
  half _381 = max(_29, 0.0010004044h);
  
  uint _513 = _23 + 8u;
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    if ((bool)((uint)_23 <= (uint)CASData_000.ContrastAdaptiveSharpeningData_032.z) && (bool)((uint)_24 <= (uint)CASData_000.ContrastAdaptiveSharpeningData_032.w)) {
      u0_space4[int2(_23, _24)] = float4(
        renodx::draw::RenderIntermediatePass(
          ComputeCASByGreen(
              renodx::draw::InvertIntermediatePass(_49).rgb,
              renodx::draw::InvertIntermediatePass(_67).rgb,
              renodx::draw::InvertIntermediatePass(_74).rgb,
              renodx::draw::InvertIntermediatePass(_87).rgb,
              renodx::draw::InvertIntermediatePass(_100).rgb,
              _351)), 1.f);
          
    }
    if ((bool)((uint)_513 <= (uint)CASData_000.ContrastAdaptiveSharpeningData_032.z) && (bool)((uint)_24 <= (uint)CASData_000.ContrastAdaptiveSharpeningData_032.w)) {

      float test = float(saturate((((((_353 * ((((((_216 + _184)) + _280)) + _312)))) + _248)) * _359)));

      u0_space4[int2(_513, _24)] = float4(
        renodx::draw::RenderIntermediatePass(
          ComputeCASByGreen(
              renodx::draw::InvertIntermediatePass(_114).rgb,
              renodx::draw::InvertIntermediatePass(_127).rgb,
              renodx::draw::InvertIntermediatePass(_134).rgb,
              renodx::draw::InvertIntermediatePass(_147).rgb,
              renodx::draw::InvertIntermediatePass(_154).rgb,
              _351)),
          1.f);
    }
    
  } else {


  if ((bool)((uint)_23 <= (uint)CASData_000.ContrastAdaptiveSharpeningData_032.z) && (bool)((uint)_24 <= (uint)CASData_000.ContrastAdaptiveSharpeningData_032.w)) {
    half _436 = 1.0h / _381;
    u0_space4[int2(_23, _24)] = float4(
      float(max(((half)(((half)((half)(exp2((half)(_436 * (half)(log2((half)(saturate((half)(((half)(((half)((half)(min(1.0h, ((half)(_78 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_78 + 0.054992676h)) * 0.9477539h))) * _29))))) + ((half)(((half)(((half)(((half)(((half)((half)(min(1.0h, ((half)(_71 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_71 + 0.054992676h)) * 0.9477539h))) * _29))))) + ((half)((half)(min(1.0h, ((half)(_53 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_53 + 0.054992676h)) * 0.9477539h))) * _29))))))) + ((half)((half)(min(1.0h, ((half)(_91 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_91 + 0.054992676h)) * 0.9477539h))) * _29))))))) + ((half)((half)(min(1.0h, ((half)(_104 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_104 + 0.054992676h)) * 0.9477539h))) * _29))))))) * _352)))) * _358)))))))) * 1.0546875h)) + -0.054992676h)), 0.0h)),
      float(max(((half)(((half)((half)(exp2((half)(_436 * (half)(log2((half)(saturate((half)(((half)(((half)(_352 * ((half)(((half)(((half)(_215 + _183)) + _279)) + _311)))) + _247)) * _358)))))))) * 1.0546875h)) + -0.054992676h)), 0.0h)),
      float(max(((half)(((half)((half)(exp2((half)(_436 * (half)(log2((half)(saturate((half)(((half)(((half)((half)(min(1.0h, ((half)(_80 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_80 + 0.054992676h)) * 0.9477539h))) * _29))))) + ((half)(((half)(((half)(((half)(((half)((half)(min(1.0h, ((half)(_73 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_73 + 0.054992676h)) * 0.9477539h))) * _29))))) + ((half)((half)(min(1.0h, ((half)(_55 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_55 + 0.054992676h)) * 0.9477539h))) * _29))))))) + ((half)((half)(min(1.0h, ((half)(_93 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_93 + 0.054992676h)) * 0.9477539h))) * _29))))))) + ((half)((half)(min(1.0h, ((half)(_106 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_106 + 0.054992676h)) * 0.9477539h))) * _29))))))) * _352)))) * _358)))))))) * 1.0546875h)) + -0.054992676h)), 0.0h)), 
      1.0f);
  }
  // uint _513 = _23 + 8u;
  if ((bool)((uint)_513 <= (uint)CASData_000.ContrastAdaptiveSharpeningData_032.z) && (bool)((uint)_24 <= (uint)CASData_000.ContrastAdaptiveSharpeningData_032.w)) {
    half _522 = 1.0h / _381;
    u0_space4[int2(_513, _24)] = float4(
      float(max(((half)(((half)((half)(exp2((half)(_522 * (half)(log2((half)(saturate((half)(((half)(((half)(_353 * ((half)(((half)(((half)(((half)((half)(min(1.0h, ((half)(_131 * +1.#INF)))) * (half)(exp2((half)(_29 * (half)(log2((half)(((half)(_131 + 0.054992676h)) * 0.9477539h)))))))) + ((half)((half)(min(1.0h, ((half)(_118 * +1.#INF)))) * (half)(exp2((half)(_29 * (half)(log2((half)(((half)(_118 + 0.054992676h)) * 0.9477539h)))))))))) + ((half)((half)(min(1.0h, ((half)(_151 * +1.#INF)))) * (half)(exp2((half)(_29 * (half)(log2((half)(((half)(_151 + 0.054992676h)) * 0.9477539h)))))))))) + ((half)((half)(min(1.0h, ((half)(_158 * +1.#INF)))) * (half)(exp2((half)(_29 * (half)(log2((half)(((half)(_158 + 0.054992676h)) * 0.9477539h)))))))))))) + ((half)((half)(min(1.0h, ((half)(_138 * +1.#INF)))) * (half)(exp2((half)(_29 * (half)(log2((half)(((half)(_138 + 0.054992676h)) * 0.9477539h)))))))))) * _359)))))))) * 1.0546875h)) + -0.054992676h)), 0.0h)),
      float(max(((half)(((half)((half)(exp2((half)(_522 * (half)(log2((half)(saturate((half)(((half)(((half)(_353 * ((half)(((half)(((half)(_216 + _184)) + _280)) + _312)))) + _248)) * _359)))))))) * 1.0546875h)) + -0.054992676h)), 0.0h)),
      float(max(((half)(((half)((half)(exp2((half)(_522 * (half)(log2((half)(saturate((half)(((half)(((half)(_353 * ((half)(((half)(((half)(((half)((half)(min(1.0h, ((half)(_133 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_133 + 0.054992676h)) * 0.9477539h))) * _29))))) + ((half)((half)(min(1.0h, ((half)(_120 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_120 + 0.054992676h)) * 0.9477539h))) * _29))))))) + ((half)((half)(min(1.0h, ((half)(_153 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_153 + 0.054992676h)) * 0.9477539h))) * _29))))))) + ((half)((half)(min(1.0h, ((half)(_160 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_160 + 0.054992676h)) * 0.9477539h))) * _29))))))))) + ((half)((half)(min(1.0h, ((half)(_140 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_140 + 0.054992676h)) * 0.9477539h))) * _29))))))) * _359)))))))) * 1.0546875h)) + -0.054992676h)), 0.0h)), 1.0f);
  }
}


  uint _545 = _24 + 8u;
  uint _551 = _545 << 16;
  uint _559 = ((uint)(max(min(_36, CASData_000.ContrastAdaptiveSharpeningData_048.z), CASData_000.ContrastAdaptiveSharpeningData_048.x) << 16)) >> 16;
  uint _561 = ((uint)(max(min(((uint)(((uint)(_551 + -65536u)) >> 16)), CASData_000.ContrastAdaptiveSharpeningData_048.w), CASData_000.ContrastAdaptiveSharpeningData_048.y) << 16)) >> 16;
  float4 _563 = t0_space4.Load(int3(_559, _561, 0));
  half _567 = half(_563.x);
  half _568 = half(_563.y);
  half _569 = half(_563.z);
  uint _578 = ((uint)(max(min(((uint)(_551 >> 16)), CASData_000.ContrastAdaptiveSharpeningData_048.w), CASData_000.ContrastAdaptiveSharpeningData_048.y) << 16)) >> 16;
  float4 _579 = t0_space4.Load(int3(((uint)(((uint)(max(min(_57, CASData_000.ContrastAdaptiveSharpeningData_048.z), CASData_000.ContrastAdaptiveSharpeningData_048.x) << 16)) >> 16)), _578, 0));
  half _583 = half(_579.x);
  half _584 = half(_579.y);
  half _585 = half(_579.z);
  float4 _586 = t0_space4.Load(int3(_559, _578, 0));
  half _590 = half(_586.x);
  half _591 = half(_586.y);
  half _592 = half(_586.z);
  float4 _597 = t0_space4.Load(int3(((uint)(((uint)(max(min(_82, CASData_000.ContrastAdaptiveSharpeningData_048.z), CASData_000.ContrastAdaptiveSharpeningData_048.x) << 16)) >> 16)), _578, 0));
  half _601 = half(_597.x);
  half _602 = half(_597.y);
  half _603 = half(_597.z);
  uint _609 = ((uint)(max(min(((uint)(((uint)(_551 + 65536u)) >> 16)), CASData_000.ContrastAdaptiveSharpeningData_048.w), CASData_000.ContrastAdaptiveSharpeningData_048.y) << 16)) >> 16;
  float4 _610 = t0_space4.Load(int3(_559, _609, 0));
  half _614 = half(_610.x);
  half _615 = half(_610.y);
  half _616 = half(_610.z);
  uint _620 = ((uint)(max(min(_109, CASData_000.ContrastAdaptiveSharpeningData_048.z), CASData_000.ContrastAdaptiveSharpeningData_048.x) << 16)) >> 16;
  float4 _621 = t0_space4.Load(int3(_620, _561, 0));
  half _625 = half(_621.x);
  half _626 = half(_621.y);
  half _627 = half(_621.z);
  float4 _632 = t0_space4.Load(int3(((uint)(((uint)(max(min(_122, CASData_000.ContrastAdaptiveSharpeningData_048.z), CASData_000.ContrastAdaptiveSharpeningData_048.x) << 16)) >> 16)), _578, 0));
  half _636 = half(_632.x);
  half _637 = half(_632.y);
  half _638 = half(_632.z);
  float4 _639 = t0_space4.Load(int3(_620, _578, 0));
  half _643 = half(_639.x);
  half _644 = half(_639.y);
  half _645 = half(_639.z);
  float4 _650 = t0_space4.Load(int3(((uint)(((uint)(max(min(_142, CASData_000.ContrastAdaptiveSharpeningData_048.z), CASData_000.ContrastAdaptiveSharpeningData_048.x) << 16)) >> 16)), _578, 0));
  half _654 = half(_650.x);
  half _655 = half(_650.y);
  half _656 = half(_650.z);
  float4 _657 = t0_space4.Load(int3(_620, _609, 0));
  half _661 = half(_657.x);
  half _662 = half(_657.y);
  half _663 = half(_657.z);

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    if ((bool)((uint)_23 <= (uint)CASData_000.ContrastAdaptiveSharpeningData_032.z) && (bool)((uint)_545 <= (uint)CASData_000.ContrastAdaptiveSharpeningData_032.w)) {
      u0_space4[int2(_23, _545)] = float4(
        renodx::draw::RenderIntermediatePass(
          ComputeCASByGreen(
              renodx::draw::InvertIntermediatePass(_563).rgb,
              renodx::draw::InvertIntermediatePass(_579).rgb,
              renodx::draw::InvertIntermediatePass(_586).rgb,
              renodx::draw::InvertIntermediatePass(_597).rgb,
              renodx::draw::InvertIntermediatePass(_610).rgb,
              _351)), 1.f);
          
    }
    if ((bool)((uint)_513 <= (uint)CASData_000.ContrastAdaptiveSharpeningData_032.z) && (bool)((uint)_545 <= (uint)CASData_000.ContrastAdaptiveSharpeningData_032.w)) {
      u0_space4[int2(_513, _545)] = float4(
        renodx::draw::RenderIntermediatePass(
          ComputeCASByGreen(
              renodx::draw::InvertIntermediatePass(_621).rgb,
              renodx::draw::InvertIntermediatePass(_632).rgb,
              renodx::draw::InvertIntermediatePass(_639).rgb,
              renodx::draw::InvertIntermediatePass(_650).rgb,
              renodx::draw::InvertIntermediatePass(_657).rgb,
              _351)),
          1.f);
    }
    return;
  }


  half _666 = half(SharedFrameData_000.FrameData_028);
  _666 = 2.4h;
  half _689 = (half)(min(1.0h, ((half)(_568 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_568 + 0.054992676h)) * 0.9477539h))) * _666)));
  half _690 = (half)(min(1.0h, ((half)(_626 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_626 + 0.054992676h)) * 0.9477539h))) * _666)));
  half _721 = (half)(min(1.0h, ((half)(_584 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_584 + 0.054992676h)) * 0.9477539h))) * _666)));
  half _722 = (half)(min(1.0h, ((half)(_637 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_637 + 0.054992676h)) * 0.9477539h))) * _666)));
  half _753 = (half)(min(1.0h, ((half)(_591 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_591 + 0.054992676h)) * 0.9477539h))) * _666)));
  half _754 = (half)(min(1.0h, ((half)(_644 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_644 + 0.054992676h)) * 0.9477539h))) * _666)));
  half _785 = (half)(min(1.0h, ((half)(_602 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_602 + 0.054992676h)) * 0.9477539h))) * _666)));
  half _786 = (half)(min(1.0h, ((half)(_655 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_655 + 0.054992676h)) * 0.9477539h))) * _666)));
  half _817 = (half)(min(1.0h, ((half)(_615 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_615 + 0.054992676h)) * 0.9477539h))) * _666)));
  half _818 = (half)(min(1.0h, ((half)(_662 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_662 + 0.054992676h)) * 0.9477539h))) * _666)));
  half _841 = max((half)(max(_785, _817)), (half)(max((half)(max(_689, _721)), _753)));
  half _842 = max((half)(max(_786, _818)), (half)(max((half)(max(_690, _722)), _754)));
  half _855 = _351 * (half)(sqrt((half)(saturate((half)((half)(min((half)(min((half)(min(_785, _817)), (half)(min((half)(min(_689, _721)), _753)))), ((half)(1.0h - _841)))) * ((half)(1.0h / _841)))))));
  half _856 = _351 * (half)(sqrt((half)(saturate((half)((half)(min((half)(min((half)(min(_786, _818)), (half)(min((half)(min(_690, _722)), _754)))), ((half)(1.0h - _842)))) * ((half)(1.0h / _842)))))));
  half _861 = 1.0h / ((half)(((half)(_855 * 4.0h)) + 1.0h));
  half _862 = 1.0h / ((half)(((half)(_856 * 4.0h)) + 1.0h));
  if ((bool)((uint)_23 <= (uint)CASData_000.ContrastAdaptiveSharpeningData_032.z) && (bool)((uint)_545 <= (uint)CASData_000.ContrastAdaptiveSharpeningData_032.w)) {
    half _939 = 1.0h / _381;
    u0_space4[int2(_23, _545)] = float4(float(max(((half)(((half)((half)(exp2((half)(_939 * (half)(log2((half)(saturate((half)(((half)(((half)((half)(min(1.0h, ((half)(_590 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_590 + 0.054992676h)) * 0.9477539h))) * _666))))) + ((half)(((half)(((half)(((half)(((half)((half)(min(1.0h, ((half)(_583 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_583 + 0.054992676h)) * 0.9477539h))) * _666))))) + ((half)((half)(min(1.0h, ((half)(_567 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_567 + 0.054992676h)) * 0.9477539h))) * _666))))))) + ((half)((half)(min(1.0h, ((half)(_601 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_601 + 0.054992676h)) * 0.9477539h))) * _666))))))) + ((half)((half)(min(1.0h, ((half)(_614 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_614 + 0.054992676h)) * 0.9477539h))) * _666))))))) * _855)))) * _861)))))))) * 1.0546875h)) + -0.054992676h)), 0.0h)), float(max(((half)(((half)((half)(exp2((half)(_939 * (half)(log2((half)(saturate((half)(((half)(((half)(_855 * ((half)(((half)(((half)(_721 + _689)) + _785)) + _817)))) + _753)) * _861)))))))) * 1.0546875h)) + -0.054992676h)), 0.0h)), float(max(((half)(((half)((half)(exp2((half)(_939 * (half)(log2((half)(saturate((half)(((half)(((half)((half)(min(1.0h, ((half)(_592 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_592 + 0.054992676h)) * 0.9477539h))) * _666))))) + ((half)(((half)(((half)(((half)(((half)((half)(min(1.0h, ((half)(_585 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_585 + 0.054992676h)) * 0.9477539h))) * _666))))) + ((half)((half)(min(1.0h, ((half)(_569 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_569 + 0.054992676h)) * 0.9477539h))) * _666))))))) + ((half)((half)(min(1.0h, ((half)(_603 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_603 + 0.054992676h)) * 0.9477539h))) * _666))))))) + ((half)((half)(min(1.0h, ((half)(_616 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_616 + 0.054992676h)) * 0.9477539h))) * _666))))))) * _855)))) * _861)))))))) * 1.0546875h)) + -0.054992676h)), 0.0h)), 1.0f);
  }
  if ((bool)((uint)_513 <= (uint)CASData_000.ContrastAdaptiveSharpeningData_032.z) && (bool)((uint)_545 <= (uint)CASData_000.ContrastAdaptiveSharpeningData_032.w)) {
    half _1024 = 1.0h / _381;
    u0_space4[int2(_513, _545)] = float4(
      float(max(((half)(((half)((half)(exp2((half)(_1024 * (half)(log2((half)(saturate((half)(((half)(((half)(_856 * ((half)(((half)(((half)(((half)((half)(min(1.0h, ((half)(_636 * +1.#INF)))) * (half)(exp2((half)(_666 * (half)(log2((half)(((half)(_636 + 0.054992676h)) * 0.9477539h)))))))) + ((half)((half)(min(1.0h, ((half)(_625 * +1.#INF)))) * (half)(exp2((half)(_666 * (half)(log2((half)(((half)(_625 + 0.054992676h)) * 0.9477539h)))))))))) + ((half)((half)(min(1.0h, ((half)(_654 * +1.#INF)))) * (half)(exp2((half)(_666 * (half)(log2((half)(((half)(_654 + 0.054992676h)) * 0.9477539h)))))))))) + ((half)((half)(min(1.0h, ((half)(_661 * +1.#INF)))) * (half)(exp2((half)(_666 * (half)(log2((half)(((half)(_661 + 0.054992676h)) * 0.9477539h)))))))))))) + ((half)((half)(min(1.0h, ((half)(_643 * +1.#INF)))) * (half)(exp2((half)(_666 * (half)(log2((half)(((half)(_643 + 0.054992676h)) * 0.9477539h)))))))))) * _862)))))))) * 1.0546875h)) + -0.054992676h)), 0.0h)),
      float(max(((half)(((half)((half)(exp2((half)(_1024 * (half)(log2((half)(saturate((half)(((half)(((half)(_856 * ((half)(((half)(((half)(_722 + _690)) + _786)) + _818)))) + _754)) * _862)))))))) * 1.0546875h)) + -0.054992676h)), 0.0h)),
      float(max(((half)(((half)((half)(exp2((half)(_1024 * (half)(log2((half)(saturate((half)(((half)(((half)(_856 * ((half)(((half)(((half)(((half)((half)(min(1.0h, ((half)(_638 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_638 + 0.054992676h)) * 0.9477539h))) * _666))))) + ((half)((half)(min(1.0h, ((half)(_627 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_627 + 0.054992676h)) * 0.9477539h))) * _666))))))) + ((half)((half)(min(1.0h, ((half)(_656 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_656 + 0.054992676h)) * 0.9477539h))) * _666))))))) + ((half)((half)(min(1.0h, ((half)(_663 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_663 + 0.054992676h)) * 0.9477539h))) * _666))))))))) + ((half)((half)(min(1.0h, ((half)(_645 * +1.#INF)))) * (half)(exp2((half)((half)(log2((half)(((half)(_645 + 0.054992676h)) * 0.9477539h))) * _666))))))) * _862)))))))) * 1.0546875h)) + -0.054992676h)), 0.0h)), 1.0f);
  }
}
