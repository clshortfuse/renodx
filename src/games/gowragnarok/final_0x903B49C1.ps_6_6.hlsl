#include "./common.hlsli"

cbuffer ConstBuf_passDataUBO : register(b0, space0) {
  float4 ConstBuf_passData_m0[39] : packoffset(c0);
};

// Don't declare _9[] or _13[] — use ResourceDescriptorHeap directly
// Texture2D<float4> _9[] : register(t0, space0);
// SamplerState _13[] : register(s0, space0);

static float4 gl_FragCoord;
static float2 TEXCOORD;
static float2 TEXCOORD_1;
static float4 SV_Target;

struct SPIRV_Cross_Input {
  float4 gl_FragCoord : SV_Position;
  float2 TEXCOORD : TEXCOORD0;
  float2 TEXCOORD_1 : TEXCOORD1;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
};

namespace rec709 {
static const float REFERENCE_WHITE = 100.f;

float3 OETF(float3 channel) {
  const float3 linearPart = channel * 4.5f;
  const float3 nonLinearPart = 1.099f * pow(channel, 0.45f) - 0.099f;
  return select(nonLinearPart, linearPart, channel < 0.018f);
}

float3 InverseOETF(float3 channel) {
  const float3 linearPart = channel / 4.5f;
  const float3 nonLinearPart = pow((channel + 0.099f) / 1.099f, 1.0f / 0.45f);
  return select(nonLinearPart, linearPart, channel < 0.081f);  // 0.081 = 0.018 * 4.5
}

}  // namespace rec709

void frag_main() {
  uint _56 = uint(int((ConstBuf_passData_m0[10u].x - ConstBuf_passData_m0[9u].z) * 0.5f));
  uint _57 = uint(int((ConstBuf_passData_m0[10u].y - ConstBuf_passData_m0[9u].w) * 0.5f));
  uint _64 = uint(int(gl_FragCoord.x));
  uint _65 = uint(int(gl_FragCoord.y));
  if ((int(_65) > int(uint(int(float(int(_57)) + ConstBuf_passData_m0[9u].w)))) || (((int(_64) < int(_56)) || (int(_65) < int(_57))) || (int(_64) > int(uint(int(float(int(_56)) + ConstBuf_passData_m0[9u].z)))))) {
    SV_Target.x = 0.0f;
    SV_Target.y = 0.0f;
    SV_Target.z = 0.0f;
    SV_Target.w = 1.0f;
  } else {
    uint _83 = _64 - _56;
    uint _84 = _65 - _57;
    uint4 _89 = asuint(ConstBuf_passData_m0[38u]);

    uint texIndex = _89.x;  // uint _90 = _89.x;
    Texture2D<float4> tex = ResourceDescriptorHeap[texIndex];

    float4 _94 = tex.Load(int3(uint2(_83, _84), 0u));  // float4 _94 = _9[_90].Load(int3(uint2(_83, _84), 0u));
    float _97 = _94.x;
    float _98 = _94.y;
    float _99 = _94.z;
    float _193;
    float _194;
    float _195;
    if (ConstBuf_passData_m0[18u].w != 0.0f) {
      float4 _107 = tex.Load(int3(uint2(_83 + 4294967295u, _84), 0u));
      float _109 = _107.x;
      float _110 = _107.y;
      float _111 = _107.z;
      float4 _113 = tex.Load(int3(uint2(_83 + 1u, _84), 0u));
      float _115 = _113.x;
      float _116 = _113.y;
      float _117 = _113.z;
      float4 _119 = tex.Load(int3(uint2(_83, _84 + 1u), 0u));
      float _121 = _119.x;
      float _122 = _119.y;
      float _123 = _119.z;
      float4 _125 = tex.Load(int3(uint2(_83, _84 + 4294967295u), 0u));
      float _127 = _125.x;
      float _128 = _125.y;
      float _129 = _125.z;
      float _138 = min(min(_97, min(_109, _115)), min(_121, _127));
      float _140 = min(min(_98, min(_110, _116)), min(_122, _128));
      float _142 = min(min(_99, min(_111, _117)), min(_123, _129));
      float _164 = (((_115 + _109) + _121) + _127) * 0.25f;
      float _166 = (((_116 + _110) + _122) + _128) * 0.25f;
      float _167 = (((_117 + _111) + _123) + _129) * 0.25f;
      float _178 = (ConstBuf_passData_m0[19u].x * (_97 - _164)) + _164;
      float _179 = (ConstBuf_passData_m0[19u].x * (_98 - _166)) + _166;
      float _180 = (ConstBuf_passData_m0[19u].x * (_99 - _167)) + _167;
      _193 = max(min(_178, _138), min(max(_178, _138), max(max(_97, max(_109, _115)), max(_121, _127))));
      _194 = max(min(_179, _140), min(max(_179, _140), max(max(_98, max(_110, _116)), max(_122, _128))));
      _195 = max(min(_180, _142), min(max(_180, _142), max(max(_99, max(_111, _117)), max(_123, _129))));
    } else {
      _193 = _97;
      _194 = _98;
      _195 = _99;
    }
    float _199 = dot(float3(clamp(_193, 0.0f, 1.0f), clamp(_194, 0.0f, 1.0f), clamp(_195, 0.0f, 1.0f)), float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f));
    float _209 = clamp(1.0f - (_199 * 4.0f), 0.0f, 1.0f);
    float _214 = clamp((_199 * 8.0f) + (-1.0f), 0.0f, 1.0f);

    Texture2D<float4> texInput = ResourceDescriptorHeap[_89.y];
    SamplerState samp = ResourceDescriptorHeap[asuint(ConstBuf_passData_m0[37u]).z];

    float4 sample = texInput.SampleLevel(
        samp,
        float2((ConstBuf_passData_m0[17u].x * TEXCOORD.x) + ConstBuf_passData_m0[17u].z,
               (ConstBuf_passData_m0[17u].y * TEXCOORD.y) + ConstBuf_passData_m0[17u].w),
        0.0f);

    float _256 = ((sample.x * 2.0f) - 1.0f) * (((ConstBuf_passData_m0[18u].z * _214) + (ConstBuf_passData_m0[18u].x * _209)) + (ConstBuf_passData_m0[18u].y * clamp((1.0f - _209) - _214, 0.0f, 1.0f)));

    float _260 = max(_256 + _193, 0.0f);
    float _261 = max(_256 + _194, 0.0f);
    float _262 = max(_256 + _195, 0.0f);

    float _309, _310, _311;
    float3 x = float3(_260, _261, _262);
    float3 corrected;
    if (RENODX_TONE_MAP_TYPE == 0.f) {
      const float a = 0.89722502231597900390625f;
      const float b = -0.001492740004323422908782958984375f;
      //   const float b = 0.005;
      const float c = 0.01871629990637302398681640625f;
      const float d = 0.686428010463714599609375f;
      const float e = 1.11840999126434326171875f;
      const float f = 0.072178699076175689697265625f;

      corrected = (x * x * (x + a) + x * b) / (((((x * c) + d) * x + e) * x) + f);

      _309 = corrected.r, _310 = corrected.g, _311 = corrected.b;
    } else {
      x = ApplyGammaCorrection(x);
      _309 = x.r, _310 = x.g, _311 = x.b;
    }

    float _330 = mad(0.0433130674064159393310546875f, _311, mad(0.3292830288410186767578125f, _310, _309 * 0.627403914928436279296875f));
    float _331 = mad(0.01136231608688831329345703125f, _311, mad(0.9195404052734375f, _310, _309 * 0.069097287952899932861328125f));
    float _332 = mad(0.895595252513885498046875f, _311, mad(0.08801330626010894775390625f, _310, _309 * 0.01639143936336040496826171875f));
    float3 bt2020_color = float3(_330, _331, _332);

    float scalar;
    if (RENODX_TONE_MAP_TYPE == 0.f) {
      scalar = ConstBuf_passData_m0[29u].y;
    } else {
      scalar = RENODX_DIFFUSE_WHITE_NITS / 100.f;
    }
    _330 *= scalar, _331 *= scalar, _332 *= scalar;  // 1.f at slider = 50

    if (RENODX_USE_PQ_ENCODING == 0.f) {
      SV_Target.x = ((((((((((_330 * 533095.75f) + 47438308.0f) * _330) + 29063622.0f) * _330) + 575216.75f) * _330) + 383.091033935546875f) * _330) + 0.000487781013362109661102294921875f) / ((((((((_330 * 66391356.0f) + 81884528.0f) * _330) + 4182885.0f) * _330) + 10668.404296875f) * _330) + 1.0f);
      SV_Target.y = ((((((((((_331 * 533095.75f) + 47438308.0f) * _331) + 29063622.0f) * _331) + 575216.75f) * _331) + 383.091033935546875f) * _331) + 0.000487781013362109661102294921875f) / ((((((((_331 * 66391356.0f) + 81884528.0f) * _331) + 4182885.0f) * _331) + 10668.404296875f) * _331) + 1.0f);
      SV_Target.z = ((((((((((_332 * 533095.75f) + 47438308.0f) * _332) + 29063622.0f) * _332) + 575216.75f) * _332) + 383.091033935546875f) * _332) + 0.000487781013362109661102294921875f) / ((((((((_332 * 66391356.0f) + 81884528.0f) * _332) + 4182885.0f) * _332) + 10668.404296875f) * _332) + 1.0f);
    } else {
      SV_Target.rgb = renodx::color::pq::EncodeSafe(float3(_330, _331, _332), 100.f);
    }
    SV_Target.w = 1.0f;
  }
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  gl_FragCoord = stage_input.gl_FragCoord;
  gl_FragCoord.w = 1.0 / gl_FragCoord.w;
  TEXCOORD = stage_input.TEXCOORD;
  TEXCOORD_1 = stage_input.TEXCOORD_1;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  return stage_output;
}
