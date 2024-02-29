// Game Render Transfer?

Texture2D<float4> _8 : register(t0, space0);
SamplerState _11 : register(s0, space0);

static float2 TEXCOORD;
static float4 SV_Target;

struct SPIRV_Cross_Input {
  float4 gl_FragCoord : SV_Position;
  float2 TEXCOORD : TEXCOORD0;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
};

void frag_main() {
  float4 _33 = _8.SampleLevel(_11, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  SV_Target.x = _33.x;
  SV_Target.y = _33.y;
  SV_Target.z = _33.z;
  SV_Target.w = _33.w;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  TEXCOORD = stage_input.TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  return stage_output;
}
