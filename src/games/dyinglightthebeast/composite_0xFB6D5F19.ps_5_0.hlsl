#include "./common.hlsli"

cbuffer cb0_buf : register(b0) {
  float cb0_m0 : packoffset(c0);
  uint3 cb0_m1 : packoffset(c0.y);
};

SamplerState s0 : register(s0);
SamplerState s1 : register(s1);
Texture2D<float4> scene_texture : register(t0);
Texture2D<float4> ui_texture : register(t1);

static float4 SV_POSITON;
static float2 TEXCOORD;
static float4 SV_TARGET;

struct SPIRV_Cross_Input {
  float4 SV_POSITON : SV_POSITION0;
  noperspective float2 TEXCOORD : TEXCOORD0;
};

struct SPIRV_Cross_Output {
  float4 SV_TARGET : SV_Target0;
};

float dp3_f32(float3 a, float3 b) {
  precise float _65 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _65));
}

void frag_main() {
  bool _80 = cb0_m1.x == 1u;
  float2 _89 = float2(TEXCOORD.x, TEXCOORD.y);
  float4 _92 = scene_texture.SampleLevel(s0, _89, 0.0f);
  float _93 = _92.x;
  float3 _97 = float3(_93, _92.yz);
  bool _107 = cb0_m1.x != 0u;
  float _108 = _107 ? (_80 ? dp3_f32(_97, float3(0.75383281707763671875f, 0.1985976397991180419921875f, 0.04756940901279449462890625f)) : _93) : dp3_f32(_97, float3(0.62740409374237060546875f, 0.329282104969024658203125f, 0.0433137975633144378662109375f));
  float _109 = _107 ? (_80 ? dp3_f32(_97, float3(0.045744635164737701416015625f, 0.941777706146240234375f, 0.012479779310524463653564453125f)) : _92.y) : dp3_f32(_97, float3(0.0690972506999969482421875f, 0.919541180133819580078125f, 0.011362140066921710968017578125f));
  float _110 = _107 ? (_80 ? dp3_f32(_97, float3(-0.00121037731878459453582763671875f, 0.01760110817849636077880859375f, 0.98360812664031982421875f)) : _92.z) : dp3_f32(_97, float3(0.01639158837497234344482421875f, 0.088013254106044769287109375f, 0.895595014095306396484375f));
  float _114 = _108 / cb0_m0;
  float _115 = _109 / cb0_m0;
  float _116 = _110 / cb0_m0;

  float4 _132 = ui_texture.SampleLevel(s1, _89, 0.0f);

  float _136 = _132.w;
  float _149 = pow((abs(mad(mad(cb0_m0, _114 / (_114 + 1.0f), -_108), _136, _108))), (1.f / 2.2f));
  float _150 = pow((abs(mad(_136, mad(cb0_m0, _115 / (_115 + 1.0f), -_109), _109))), (1.f / 2.2f));
  float _151 = pow((abs(mad(_136, mad(cb0_m0, _116 / (_116 + 1.0f), -_110), _110))), (1.f / 2.2f));

  float3 _152 = float3(_132.xyz);
  // _152 = renodx::color::correct::GammaSafe(_152);

  SV_TARGET.x = exp2(log2(abs(mad(_136, exp2(log2(abs(cb0_m0 * dp3_f32(_152, float3(0.62740409374237060546875f, 0.329282104969024658203125f, 0.0433137975633144378662109375f)))) * (1.f / 2.2f)) - _149, _149))) * 2.2f);
  SV_TARGET.y = exp2(log2(abs(mad(_136, exp2(log2(abs(cb0_m0 * dp3_f32(_152, float3(0.0690972506999969482421875f, 0.919541180133819580078125f, 0.011362140066921710968017578125f)))) * (1.f / 2.2f)) - _150, _150))) * 2.2f);
  SV_TARGET.z = exp2(log2(abs(mad(_136, exp2(log2(abs(cb0_m0 * dp3_f32(_152, float3(0.01639158837497234344482421875f, 0.088013254106044769287109375f, 0.895595014095306396484375f)))) * (1.f / 2.2f)) - _151, _151))) * 2.2f);
  SV_TARGET.w = mad(_92.w, 1.0f - _136, _136);
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  TEXCOORD = stage_input.TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_TARGET = SV_TARGET;
  return stage_output;
}
