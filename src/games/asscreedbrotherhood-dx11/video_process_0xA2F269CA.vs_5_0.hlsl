cbuffer cb3 : register(b3) {
  float4 cb3[47];
}

struct VSOutput {
  float4 position : SV_POSITION0;
  float4 texcoord8 : TEXCOORD8;
  float4 color0 : COLOR0;
  float4 color1 : COLOR1;
  float4 texcoord9 : TEXCOORD9;
  float4 texcoord0 : TEXCOORD0;
  float4 texcoord1 : TEXCOORD1;
  float4 texcoord2 : TEXCOORD2;
  float4 texcoord3 : TEXCOORD3;
  float4 texcoord4 : TEXCOORD4;
  float4 texcoord5 : TEXCOORD5;
  float4 texcoord6 : TEXCOORD6;
  float4 texcoord7 : TEXCOORD7;
};

VSOutput main(uint vertex_id : SV_VertexID) {
  VSOutput output;

  // This pass immediately follows packed video decode. It originally forwards
  // clip-space POSITION and TEXCOORD0, but the HDR/dgVoodoo path can leave the
  // POSITION stream split diagonally. Emit stable fullscreen geometry while
  // preserving the simple 0..1 UV mapping expected by the processing shader.
  if (vertex_id == 0u) {
    output.position = float4(-1.f, 1.f, 0.f, 1.f);
    output.texcoord0 = float4(0.f, 0.f, 0.f, 1.f);
  } else if (vertex_id == 1u) {
    output.position = float4(3.f, 1.f, 0.f, 1.f);
    output.texcoord0 = float4(2.f, 0.f, 0.f, 1.f);
  } else {
    output.position = float4(-1.f, -3.f, 0.f, 1.f);
    output.texcoord0 = float4(0.f, 2.f, 0.f, 1.f);
  }

  output.texcoord8 = output.position;
  output.color0 = float4(1.f, 1.f, 1.f, 1.f);
  output.color1 = float4(0.f, 0.f, 0.f, 1.f);
  output.texcoord9 = float4(1.f, 0.f, 0.f, 0.f);
  output.texcoord1 = float4(0.f, 0.f, 0.f, 1.f);
  output.texcoord2 = float4(0.f, 0.f, 0.f, 1.f);
  output.texcoord3 = float4(0.f, 0.f, 0.f, 1.f);
  output.texcoord4 = float4(0.f, 0.f, 0.f, 1.f);
  output.texcoord5 = float4(0.f, 0.f, 0.f, 1.f);
  output.texcoord6 = float4(0.f, 0.f, 0.f, 1.f);
  output.texcoord7 = float4(0.f, 0.f, 0.f, 1.f);

  return output;
}
