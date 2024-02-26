#include "../common/color.hlsl"

cbuffer _16_18 : register(b6, space0) {
  float4 cb6[1] : packoffset(c0);
}

Texture2D<float4> menuTexture : register(t0, space0);
RWTexture2D<float4> _11 : register(u0, space0);
SamplerState _21 : register(s11, space0);

static uint3 gl_GlobalInvocationID;

struct SPIRV_Cross_Input {
  uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
};

void comp_main() {
  float _39 = float(gl_GlobalInvocationID.x);
  float _45 = cb6[0u].y * (float(gl_GlobalInvocationID.y) + 0.5f);
  float4 _49 = menuTexture.SampleLevel(_21, float2(cb6[0u].x * (_39 + 0.5f), _45), 0.0f);
  float _52 = _49.x;
  float _53 = _49.y;
  float _54 = _49.z;
  float4 _80 = menuTexture.SampleLevel(_21, float2(cb6[0u].x * (_39 + 1.884615421295166015625f), _45), 0.0f);
  float _82 = _80.x;
  float _83 = _80.y;
  float _84 = _80.z;
  float4 _101 = menuTexture.SampleLevel(_21, float2(cb6[0u].x * (_39 + (-0.884615421295166015625f)), _45), 0.0f);
  float _103 = _101.x;
  float _104 = _101.y;
  float _105 = _101.z;
  float4 _135 = menuTexture.SampleLevel(_21, float2(cb6[0u].x * (_39 + 3.73076915740966796875f), _45), 0.0f);
  float _137 = _135.x;
  float _138 = _135.y;
  float _139 = _135.z;
  float4 _156 = menuTexture.SampleLevel(_21, float2(cb6[0u].x * (_39 + (-2.73076915740966796875f)), _45), 0.0f);
  float _158 = _156.x;
  float _159 = _156.y;
  float _160 = _156.z;
  float _183 = ((((clamp((cb6[0u].z * _103) + cb6[0u].w, 0.0f, 1.0f) * _103) + (clamp((cb6[0u].z * _82) + cb6[0u].w, 0.0f, 1.0f) * _82)) * 0.3162162303924560546875f) + ((_52 * 0.2270270287990570068359375f) * clamp((cb6[0u].z * _52) + cb6[0u].w, 0.0f, 1.0f))) + (((clamp((cb6[0u].z * _158) + cb6[0u].w, 0.0f, 1.0f) * _158) + (clamp((cb6[0u].z * _137) + cb6[0u].w, 0.0f, 1.0f) * _137)) * 0.0702702701091766357421875f);
  float _184 = ((((clamp((cb6[0u].z * _104) + cb6[0u].w, 0.0f, 1.0f) * _104) + (clamp((cb6[0u].z * _83) + cb6[0u].w, 0.0f, 1.0f) * _83)) * 0.3162162303924560546875f) + ((_53 * 0.2270270287990570068359375f) * clamp((cb6[0u].z * _53) + cb6[0u].w, 0.0f, 1.0f))) + (((clamp((cb6[0u].z * _159) + cb6[0u].w, 0.0f, 1.0f) * _159) + (clamp((cb6[0u].z * _138) + cb6[0u].w, 0.0f, 1.0f) * _138)) * 0.0702702701091766357421875f);
  float _185 = ((((clamp((cb6[0u].z * _105) + cb6[0u].w, 0.0f, 1.0f) * _105) + (clamp((cb6[0u].z * _84) + cb6[0u].w, 0.0f, 1.0f) * _84)) * 0.3162162303924560546875f) + ((_54 * 0.2270270287990570068359375f) * clamp((cb6[0u].z * _54) + cb6[0u].w, 0.0f, 1.0f))) + (((clamp((cb6[0u].z * _160) + cb6[0u].w, 0.0f, 1.0f) * _160) + (clamp((cb6[0u].z * _139) + cb6[0u].w, 0.0f, 1.0f) * _139)) * 0.0702702701091766357421875f);

  float4 outputColor = float4(
    srgbFromLinear(_183),
    srgbFromLinear(_184),
    srgbFromLinear(_185),
    (((_101.w + _80.w) * 0.3162162303924560546875f) + (_49.w * 0.2270270287990570068359375f)) + ((_156.w + _135.w) * 0.0702702701091766357421875f)
  );

  _11[uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y)] = outputColor;
}

[numthreads(8, 8, 1)] void main(SPIRV_Cross_Input stage_input) {
  gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
  comp_main();
}
