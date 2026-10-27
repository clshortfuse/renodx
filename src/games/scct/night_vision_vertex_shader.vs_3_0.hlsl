// Night vision vertex shader (vs_3_0): the game's vs_1_1 0x6DE58908, which its night vision image
// (0x4ADA0B05) and the glow blurs draw with, ported because a ps_3_0 only runs with a vs_3_0. The
// add-on binds it with night_vision_hdr_pixel_shader. Positions come in as a D3DCOLOR in [0, 1].

float4 position_transform : register(c0);       // z: offset, w: scale
float4 texcoord_transforms[4] : register(c20);  // per texcoord, xy: scale, zw: offset

struct VertexOutput {
  float4 position : POSITION;
  float2 texcoord_0 : TEXCOORD0;
  float2 texcoord_1 : TEXCOORD1;
  float2 texcoord_2 : TEXCOORD2;
  float2 texcoord_3 : TEXCOORD3;
};

VertexOutput main(float4 position : POSITION) {
  VertexOutput output;
  output.position = float4(position.xy * position_transform.w - position_transform.z, position_transform.zz);
  output.texcoord_0 = position.xy * texcoord_transforms[0].xy + texcoord_transforms[0].zw;
  output.texcoord_1 = position.xy * texcoord_transforms[1].xy + texcoord_transforms[1].zw;
  output.texcoord_2 = position.xy * texcoord_transforms[2].xy + texcoord_transforms[2].zw;
  output.texcoord_3 = position.xy * texcoord_transforms[3].xy + texcoord_transforms[3].zw;
  return output;
}
