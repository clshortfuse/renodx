cbuffer _33_35 : register(b0, space3) {
  float4 _35_m0[1] : packoffset(c0);
}

cbuffer _38_40 : register(b0, space5) {
  float4 _40_m0[14] : packoffset(c0);
}


Texture2D<uint4> _12 : register(t0, space3);
Texture2D<float4> _16 : register(t1, space3);
Texture2D<float4> _17 : register(t2, space3);
Texture2D<float4> _18 : register(t4, space3);
Texture2D<float4> _19 : register(t5, space3);
Texture2D<float4> _20 : register(t6, space3);
Texture2D<float4> _21 : register(t7, space3);
Texture2D<float4> _22 : register(t8, space3);
Texture2D<float4> _23 : register(t9, space3);
Buffer<float4> _26 : register(t0, space5);
Texture3D<float4> _29 : register(t1, space5);

static float4 gl_FragCoord;
static float2 TEXCOORD;
static float4 SV_Target;
static float SV_Target_1;

struct SPIRV_Cross_Input {
  float4 gl_FragCoord : SV_Position;
  float2 TEXCOORD : TEXCOORD0;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
  float SV_Target_1 : SV_Target1;
};

void frag_main() {
  SamplerState samp0 = SamplerDescriptorHeap[NonUniformResourceIndex(0)];
  SamplerState samp2 = SamplerDescriptorHeap[NonUniformResourceIndex(2)];
  SamplerState samp17 = SamplerDescriptorHeap[NonUniformResourceIndex(17)];

  uint4 _68 = asuint(_35_m0[0u]);
  uint4 _106 = asuint(_40_m0[5u]);
  uint4 _141 = asuint(_40_m0[13u]);
  uint _142 = _141.y;
  float _153 = (_40_m0[0u].x * TEXCOORD.x) + _40_m0[0u].z;
  float _154 = (_40_m0[0u].y * TEXCOORD.y) + _40_m0[0u].w;
  float4 _159 = _18.Sample(samp0, float2(TEXCOORD.x, TEXCOORD.y));
  float _161 = _159.x;
  float _162 = _159.y;
  float _163 = _159.z;
  float _168 = float(int(_106.x));
  float _169 = float(int(_106.y));
  float _175 = float(int(uint(int(uint(gl_FragCoord.x)) >> int(_68.z & 31u))));
  float _176 = float(int(uint(int(uint(gl_FragCoord.y)) >> int(_68.w & 31u))));
  uint4 _189 = _12.Load(int3(uint2(uint(int(max(min(_175, _168), min(max(_175, _168), float(int(_106.z)))))), uint(int(max(min(_176, _169), min(max(_176, _169), float(int(_106.w))))))), 0u));
  uint _192 = _189.x;
  float _195;
  float _200;
  float _205;
  if (_192 == 0u) {
    _195 = _161;
    _200 = _162;
    _205 = _163;
  } else {
    float frontier_phi_1_2_ladder;
    float frontier_phi_1_2_ladder_1;
    float frontier_phi_1_2_ladder_2;
    if ((_192 & 536870912u) == 0u) {
      float frontier_phi_1_2_ladder_5_ladder;
      float frontier_phi_1_2_ladder_5_ladder_1;
      float frontier_phi_1_2_ladder_5_ladder_2;
      if ((_192 & 268435456u) == 0u) {
        float4 _531 = _16.Sample(samp0, float2(TEXCOORD.x, TEXCOORD.y));
        float _533 = _531.x;
        float _534 = _533 * 12.0f;
        float _541 = max(min(_534, -18.0f), min(max(_534, -18.0f), 18.0f));
        float4 _544 = _17.Sample(samp2, float2(TEXCOORD.x, TEXCOORD.y));
        float _550 = max(clamp((-0.0f) - _541, 0.0f, 1.0f), _544.x);
        float _552 = clamp(_541 + (-0.5f), 0.0f, 1.0f);
        float _557 = (_552 * _552) * (3.0f - (_552 * 2.0f));
        float4 _559 = _16.Sample(samp0, float2(TEXCOORD.x, TEXCOORD.y - _35_m0[0u].y));
        float4 _564 = _16.Sample(samp0, float2(TEXCOORD.x - _35_m0[0u].x, TEXCOORD.y));
        float4 _569 = _16.Sample(samp0, float2(_35_m0[0u].x + TEXCOORD.x, TEXCOORD.y));
        float4 _574 = _16.Sample(samp0, float2(TEXCOORD.x, _35_m0[0u].y + TEXCOORD.y));
        float _577 = min(min(min(min(_533, _559.x), _564.x), _569.x), _574.x);
        float _682;
        if (_577 < 0.0f) {
          _682 = (-0.0f) - _577;
        } else {
          _682 = max(_577, _533);
        }
        float _683 = _682 * 12.0f;
        float _688 = max(min(_683, -18.0f), min(max(_683, -18.0f), 18.0f)) * 2.0f;
        float _924;
        float _925;
        float _926;
        if ((_557 < 1.0f) && ((_550 < 1.0f) && (_688 > 0.25f))) {
          float _783 = min(_688, 4.0f);
          float _784 = _783 * _35_m0[0u].x;
          float _785 = _783 * _35_m0[0u].y;
          float4 _795 = _18.SampleLevel(samp2, float2(TEXCOORD.x, _785 + TEXCOORD.y), 0.0f);
          float _809 = _784 * 0.707106769084930419921875f;
          float _811 = _785 * 0.707106769084930419921875f;
          float _812 = _809 + TEXCOORD.x;
          float _813 = _811 + TEXCOORD.y;
          float4 _814 = _18.SampleLevel(samp2, float2(_812, _813), 0.0f);
          float4 _829 = _18.SampleLevel(samp2, float2(_784 + TEXCOORD.x, TEXCOORD.y), 0.0f);
          float _843 = TEXCOORD.y - _811;
          float4 _844 = _18.SampleLevel(samp2, float2(_812, _843), 0.0f);
          float4 _859 = _18.SampleLevel(samp2, float2(TEXCOORD.x, TEXCOORD.y - _785), 0.0f);
          float _873 = TEXCOORD.x - _809;
          float4 _874 = _18.SampleLevel(samp2, float2(_873, _843), 0.0f);
          float4 _889 = _18.SampleLevel(samp2, float2(TEXCOORD.x - _784, TEXCOORD.y), 0.0f);
          float4 _903 = _18.SampleLevel(samp2, float2(_873, _813), 0.0f);
          _924 = exp2(((((((((log2(max(_795.x, 1.0000000133514319600180897396058e-10f)) + log2(max(_161, 1.0000000133514319600180897396058e-10f))) + log2(max(_814.x, 1.0000000133514319600180897396058e-10f))) + log2(max(_829.x, 1.0000000133514319600180897396058e-10f))) + log2(max(_844.x, 1.0000000133514319600180897396058e-10f))) + log2(max(_859.x, 1.0000000133514319600180897396058e-10f))) + log2(max(_874.x, 1.0000000133514319600180897396058e-10f))) + log2(max(_889.x, 1.0000000133514319600180897396058e-10f))) + log2(max(_903.x, 1.0000000133514319600180897396058e-10f))) * 0.111111111938953399658203125f);
          _925 = exp2(((((((((log2(max(_795.y, 1.0000000133514319600180897396058e-10f)) + log2(max(_162, 1.0000000133514319600180897396058e-10f))) + log2(max(_814.y, 1.0000000133514319600180897396058e-10f))) + log2(max(_829.y, 1.0000000133514319600180897396058e-10f))) + log2(max(_844.y, 1.0000000133514319600180897396058e-10f))) + log2(max(_859.y, 1.0000000133514319600180897396058e-10f))) + log2(max(_874.y, 1.0000000133514319600180897396058e-10f))) + log2(max(_889.y, 1.0000000133514319600180897396058e-10f))) + log2(max(_903.y, 1.0000000133514319600180897396058e-10f))) * 0.111111111938953399658203125f);
          _926 = exp2(((((((((log2(max(_795.z, 1.0000000133514319600180897396058e-10f)) + log2(max(_163, 1.0000000133514319600180897396058e-10f))) + log2(max(_814.z, 1.0000000133514319600180897396058e-10f))) + log2(max(_829.z, 1.0000000133514319600180897396058e-10f))) + log2(max(_844.z, 1.0000000133514319600180897396058e-10f))) + log2(max(_859.z, 1.0000000133514319600180897396058e-10f))) + log2(max(_874.z, 1.0000000133514319600180897396058e-10f))) + log2(max(_889.z, 1.0000000133514319600180897396058e-10f))) + log2(max(_903.z, 1.0000000133514319600180897396058e-10f))) * 0.111111111938953399658203125f);
        } else {
          _924 = _161;
          _925 = _162;
          _926 = _163;
        }
        float4 _929 = _20.Sample(samp2, float2(TEXCOORD.x, TEXCOORD.y));
        float _199 = ((_929.x - _924) * _557) + _924;
        float _204 = ((_929.y - _925) * _557) + _925;
        float _209 = ((_929.z - _926) * _557) + _926;
        float4 _942 = _19.Sample(samp0, float2(TEXCOORD.x, TEXCOORD.y));
        float frontier_phi_1_2_ladder_5_ladder_25_ladder;
        float frontier_phi_1_2_ladder_5_ladder_25_ladder_1;
        float frontier_phi_1_2_ladder_5_ladder_25_ladder_2;
        if ((_942.z > 0.0f) || ((_942.x > 0.0f) || (_942.y > 0.0f))) {
          float4 _954 = _19.Sample(samp2, float2(TEXCOORD.x, TEXCOORD.y));
          frontier_phi_1_2_ladder_5_ladder_25_ladder = ((_954.x - _199) * _550) + _199;
          frontier_phi_1_2_ladder_5_ladder_25_ladder_1 = ((_954.y - _204) * _550) + _204;
          frontier_phi_1_2_ladder_5_ladder_25_ladder_2 = ((_954.z - _209) * _550) + _209;
        } else {
          frontier_phi_1_2_ladder_5_ladder_25_ladder = _199;
          frontier_phi_1_2_ladder_5_ladder_25_ladder_1 = _204;
          frontier_phi_1_2_ladder_5_ladder_25_ladder_2 = _209;
        }
        frontier_phi_1_2_ladder_5_ladder = frontier_phi_1_2_ladder_5_ladder_25_ladder;
        frontier_phi_1_2_ladder_5_ladder_1 = frontier_phi_1_2_ladder_5_ladder_25_ladder_1;
        frontier_phi_1_2_ladder_5_ladder_2 = frontier_phi_1_2_ladder_5_ladder_25_ladder_2;
      } else {
        float4 _581 = _20.Sample(samp2, float2(TEXCOORD.x, TEXCOORD.y));
        frontier_phi_1_2_ladder_5_ladder = _581.x;
        frontier_phi_1_2_ladder_5_ladder_1 = _581.y;
        frontier_phi_1_2_ladder_5_ladder_2 = _581.z;
      }
      frontier_phi_1_2_ladder = frontier_phi_1_2_ladder_5_ladder;
      frontier_phi_1_2_ladder_1 = frontier_phi_1_2_ladder_5_ladder_1;
      frontier_phi_1_2_ladder_2 = frontier_phi_1_2_ladder_5_ladder_2;
    } else {
      float4 _409 = _19.Sample(samp2, float2(TEXCOORD.x, TEXCOORD.y));
      frontier_phi_1_2_ladder = _409.x;
      frontier_phi_1_2_ladder_1 = _409.y;
      frontier_phi_1_2_ladder_2 = _409.z;
    }
    _195 = frontier_phi_1_2_ladder;
    _200 = frontier_phi_1_2_ladder_1;
    _205 = frontier_phi_1_2_ladder_2;
  }
  float4 _211 = _26.Load(2u);
  float _212 = _211.x;
  float4 _215 = _21.Sample(samp2, float2(TEXCOORD.x, TEXCOORD.y));
  float _217 = _215.x;
  float _218 = _215.y;
  float _219 = _215.z;
  float4 _222 = _22.Sample(samp2, float2(TEXCOORD.x, TEXCOORD.y));
  float _224 = _222.x;
  float _230 = _40_m0[11u].y * 0.25f;
  float _232 = _195 * _230;
  float _233 = _200 * _230;
  float _234 = _205 * _230;
  float _248 = (clamp(dot(float3(_232, _233, _234), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f)) + 9.9999999747524270787835121154785e-07f, 0.0f, 1.0f) * (1.0f - _40_m0[9u].w)) + _40_m0[9u].w;
  float _264 = (exp2(log2(max(_232, 0.0f)) * _248) / _230) * _40_m0[9u].w;
  float _265 = (exp2(log2(max(_233, 0.0f)) * _248) / _230) * _40_m0[9u].w;
  float _266 = (exp2(log2(max(_234, 0.0f)) * _248) / _230) * _40_m0[9u].w;
  float _267 = (_217 * _217) / _40_m0[11u].z;
  float _268 = (_218 * _218) / _40_m0[11u].z;
  float _269 = (_219 * _219) / _40_m0[11u].z;
  float _273 = (_212 * 4.0f) / (_212 + 0.25f);
  float _277 = max(_212, 1.0000000031710768509710513471353e-30f);
  float _290 = 1.0f / ((_212 + 1.0f) + _273);
  float _300 = dot(float3(_224, _222.yz), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
  float _319 = ((_40_m0[11u].x * _40_m0[1u].y) * (((_222.y - _300) * _40_m0[1u].w) + _300)) + (((_268 + _265) + (sqrt((_268 * _265) / _277) * _273)) * _290);
  float _325 = (((((_40_m0[11u].x * _40_m0[1u].x) * (((_224 - _300) * _40_m0[1u].w) + _300)) + (_290 * ((_267 + _264) + (sqrt((_267 * _264) / _277) * _273)))) * _40_m0[9u].x) + (_319 * (_40_m0[9u].x - _40_m0[9u].y))) * _40_m0[11u].z;
  float _327 = (_40_m0[11u].z * _40_m0[9u].y) * _319;
  float _329 = (_40_m0[11u].z * _40_m0[9u].z) * (((_40_m0[11u].x * _40_m0[1u].z) * (((_222.z - _300) * _40_m0[1u].w) + _300)) + (((_269 + _266) + (sqrt((_269 * _266) / _277) * _273)) * _290));
  float _335;
  float _337;
  float _339;
  if ((_142 & 1u) == 0u) {
    _335 = _325;
    _337 = _327;
    _339 = _329;
  } else {
    uint _379 = asuint(_40_m0[4u].z);
    float _400 = (_23.Sample(samp17, float2((_153 * _40_m0[4u].x) + (float(_379 & 65535u) * 1.52587890625e-05f), (_154 * _40_m0[4u].y) + (float(_379 >> 16u) * 1.52587890625e-05f))).y + (-0.5f)) * _215.w;
    _335 = max(_400 + _325, 0.0f);
    _337 = max(_400 + _327, 0.0f);
    _339 = max(_400 + _329, 0.0f);
  }
  float _341 = _290 * _40_m0[11u].z;
  float _348 = (_153 * 2.0f) + (-1.0f);
  float _350 = (_154 * 2.0f) + (-1.0f);
  float _357 = clamp((sqrt((_350 * _350) + (_348 * _348)) * _40_m0[3u].x) + _40_m0[3u].y, 0.0f, 1.0f);
  float _359 = (_357 * _357) * _40_m0[2u].w;
  float _360 = 1.0f - _359;
  float _370 = max((_360 * _335) + ((_341 * _40_m0[2u].x) * _359), 9.9999999747524270787835121154785e-07f);
  float _371 = max((_360 * _337) + ((_341 * _40_m0[2u].y) * _359), 9.9999999747524270787835121154785e-07f);
  float _372 = max((_360 * _339) + ((_341 * _40_m0[2u].z) * _359), 9.9999999747524270787835121154785e-07f);
  float _411;
  float _413;
  float _415;
  if ((_142 & 2u) == 0u) {
    _411 = _370;
    _413 = _371;
    _415 = _372;
  } else {
    float _468 = max(_370, 0.0f);
    float _469 = max(_371, 0.0f);
    float _470 = max(_372, 0.0f);
    float _475 = mad(0.00889899022877216339111328125f, _470, mad(0.045505501329898834228515625f, _469, _468 * 0.9455959796905517578125f));
    float _481 = mad(0.01734930090606212615966796875f, _470, mad(0.967956006526947021484375f, _469, _468 * 0.014694600366055965423583984375f));
    float _487 = mad(0.97429001331329345703125f, _470, mad(0.02014279924333095550537109375f, _469, _468 * 0.0055674300529062747955322265625f));
    float _495 = dot(float3(0.2132180035114288330078125f, 0.72758901119232177734375f, 0.0591935999691486358642578125f), float3(_475, _481, _487)) + 1.0f;
    float _502 = ((_495 * _475) + 1.0f) * _475;
    float _503 = ((_495 * _481) + 1.0f) * _481;
    float _504 = ((_495 * _487) + 1.0f) * _487;
    float _508 = _502 / (_502 + _495);
    float _509 = _503 / (_503 + _495);
    float _510 = _504 / (_504 + _495);
    _411 = max(mad(-0.00878410041332244873046875f, _510, mad(-0.0495725981891155242919921875f, _509, _508 * 1.05835998058319091796875f)), 0.0f);
    _413 = max(mad(-0.01827090047299861907958984375f, _510, mad(1.0342400074005126953125f, _509, _508 * (-0.015964500606060028076171875f))), 0.0f);
    _415 = max(mad(1.0268199443817138671875f, _510, mad(-0.0210989005863666534423828125f, _509, _508 * (-0.005717770196497440338134765625f))), 0.0f);
  }
  float4 _438 = _29.SampleLevel(samp2, float3((clamp(sqrt(max(_411, 0.0f)), 0.0f, 1.0f) * _40_m0[3u].z) + _40_m0[3u].w, (clamp(sqrt(max(_413, 0.0f)), 0.0f, 1.0f) * _40_m0[3u].z) + _40_m0[3u].w, (clamp(sqrt(max(_415, 0.0f)), 0.0f, 1.0f) * _40_m0[3u].z) + _40_m0[3u].w), 0.0f);
  float _440 = _438.x;
  float _441 = _438.y;
  float _442 = _438.z;
  float _443 = _440 * _440;
  float _444 = _441 * _441;
  float _445 = _442 * _442;
  float _462 = clamp((dot(float3(_443, _444, _445), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f)) * 8.0f) + (-4.0f), 0.0f, 1.0f) * clamp((max(dot(float3(_370, _371, _372), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f)) / (dot(float3(_411, _413, _415), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f)) + 9.9999999600419720025001879548654e-13f), 0.0f) + (-1.0f)) * 0.039999999105930328369140625f, 0.0f, 1.0f);
  float _463 = clamp(_443, 0.0f, 1.0f);
  float _464 = clamp(_444, 0.0f, 1.0f);
  float _465 = clamp(_445, 0.0f, 1.0f);
  float _583;
  float _585;
  float _587;
  if ((_142 & 4u) == 0u) {
    _583 = _463;
    _585 = _464;
    _587 = _465;
  } else {
    float peakNitsOverPaperWhite = _40_m0[13u].x;
    // float peakNitsOverPaperWhite = 1000.f / (_40_m0[10u].y * 10000.f);
    float _594 = _40_m0[12u].w * _40_m0[12u].w;
    float _604 = _40_m0[12u].w + 1.0f;
    float _605 = (sqrt((_463 * _463) + _594) - _40_m0[12u].w) * _604;
    float _606 = (sqrt((_464 * _464) + _594) - _40_m0[12u].w) * _604;
    float _607 = (sqrt((_465 * _465) + _594) - _40_m0[12u].w) * _604;
    float _612 = clamp(dot(float3(_605, _606, _607), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f)), 0.0f, 1.0f);
    float _614 = clamp(_612 + (-0.5f), 0.0f, 1.0f);
    float _631 = (((max(1.0f, _40_m0[12u].z) + (-1.0f)) * 0.0384615398943424224853515625f) * max(0.0f, ((((_614 * _614) * (_462 * 100.0f)) + (1.0f / (1.0f - (_612 * 0.5f)))) * _612) - _612)) + _612;
    float _634 = 1.0f / max(_612, 9.999999717180685365747194737196e-10f);
    float _639 = max(9.999999717180685365747194737196e-10f, _631 * _634);
    float _652 = peakNitsOverPaperWhite * peakNitsOverPaperWhite;
    float _653 = _652 * 0.03125f;
    float _678;
    if (_631 > _653) {
      _678 = (_653 + peakNitsOverPaperWhite) - (_652 / ((peakNitsOverPaperWhite - _653) + _631));
    } else {
      _678 = _631;
    }
    _583 = min(_678 * exp2(log2(abs(_634 * _605)) * _639), peakNitsOverPaperWhite);
    _585 = min(_678 * exp2(log2(abs(_634 * _606)) * _639), peakNitsOverPaperWhite);
    _587 = min(_678 * exp2(log2(abs(_634 * _607)) * _639), peakNitsOverPaperWhite);
  }
  uint _589 = uint(int(_40_m0[10u].w));
  float _769;
  float _771;
  float _773;
  if (_589 == 1u) {
    float _667 = exp2(log2(abs(_583)) * _40_m0[10u].x);
    float _668 = exp2(log2(abs(_585)) * _40_m0[10u].x);
    float _669 = exp2(log2(abs(_587)) * _40_m0[10u].x);
    float _770;
    if (_667 < 0.00310000008903443813323974609375f) {
      _770 = _667 * 12.9200000762939453125f;
    } else {
      _770 = (exp2(log2(abs(_667)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float _772;
    if (_668 < 0.00310000008903443813323974609375f) {
      _772 = _668 * 12.9200000762939453125f;
    } else {
      _772 = (exp2(log2(abs(_668)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float frontier_phi_23_30_ladder;
    float frontier_phi_23_30_ladder_1;
    float frontier_phi_23_30_ladder_2;
    if (_669 < 0.00310000008903443813323974609375f) {
      frontier_phi_23_30_ladder = _770;
      frontier_phi_23_30_ladder_1 = _772;
      frontier_phi_23_30_ladder_2 = _669 * 12.9200000762939453125f;
    } else {
      frontier_phi_23_30_ladder = _770;
      frontier_phi_23_30_ladder_1 = _772;
      frontier_phi_23_30_ladder_2 = (exp2(log2(abs(_669)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    _769 = frontier_phi_23_30_ladder;
    _771 = frontier_phi_23_30_ladder_1;
    _773 = frontier_phi_23_30_ladder_2;
  } else {
    float frontier_phi_23_16_ladder;
    float frontier_phi_23_16_ladder_1;
    float frontier_phi_23_16_ladder_2;
    if (_589 == 2u) {
      float _735 = exp2(log2(abs(mad(0.0433130674064159393310546875f, _587, mad(0.3292830288410186767578125f, _585, _583 * 0.627403914928436279296875f)) * _40_m0[10u].y)) * _40_m0[10u].x);
      float _736 = exp2(log2(abs(mad(0.01136231608688831329345703125f, _587, mad(0.9195404052734375f, _585, _583 * 0.069097287952899932861328125f)) * _40_m0[10u].y)) * _40_m0[10u].x);
      float _737 = exp2(log2(abs(mad(0.895595252513885498046875f, _587, mad(0.08801330626010894775390625f, _585, _583 * 0.01639143936336040496826171875f)) * _40_m0[10u].y)) * _40_m0[10u].x);
      frontier_phi_23_16_ladder = exp2(log2(abs(((_735 * 18.8515625f) + 0.8359375f) / ((_735 * 18.6875f) + 1.0f))) * 78.84375f);
      frontier_phi_23_16_ladder_1 = exp2(log2(abs(((_736 * 18.8515625f) + 0.8359375f) / ((_736 * 18.6875f) + 1.0f))) * 78.84375f);
      frontier_phi_23_16_ladder_2 = exp2(log2(abs(((_737 * 18.8515625f) + 0.8359375f) / ((_737 * 18.6875f) + 1.0f))) * 78.84375f);
    } else {
      frontier_phi_23_16_ladder = _583;
      frontier_phi_23_16_ladder_1 = _585;
      frontier_phi_23_16_ladder_2 = _587;
    }
    _769 = frontier_phi_23_16_ladder;
    _771 = frontier_phi_23_16_ladder_1;
    _773 = frontier_phi_23_16_ladder_2;
  }
  SV_Target.x = _769;
  SV_Target.y = _771;
  SV_Target.z = _773;
  SV_Target.w = _462;
  SV_Target_1 = dot(float3(_769, _771, _773), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  gl_FragCoord = stage_input.gl_FragCoord;
  gl_FragCoord.w = 1.0 / gl_FragCoord.w;
  TEXCOORD = stage_input.TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  stage_output.SV_Target_1 = SV_Target_1;
  return stage_output;
}
