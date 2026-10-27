// EMF vertex shader (vs_3_0): the game's vs_1_1 0x2A65069F, which EMF's image (0x7CE55E3E) draws
// with, ported because a ps_3_0 only runs with a vs_3_0. The add-on binds it with
// emf_hdr_pixel_shader for that draw only. Positions come in as a D3DCOLOR in [0, 1].

float4 position_transform : register(c0);           // x: 0, z: offset and 1, w: scale
float4 bump_texcoord_transform[2] : register(c12);  // rows applied to (x, y, 0, 1)
float4 image_texcoord_transform : register(c20);    // xy: scale, zw: offset

struct VertexOutput {
  float4 position : POSITION;
  float2 texcoord_0 : TEXCOORD0;
  float2 texcoord_3 : TEXCOORD3;
};

VertexOutput main(float4 position : POSITION) {
  VertexOutput output;
  output.position = float4(position.xy * position_transform.w - position_transform.z, position_transform.zz);
  const float4 bump_position = float4(position.xy, position_transform.xz);
  output.texcoord_0 = float2(dot(bump_position, bump_texcoord_transform[0]), dot(bump_position, bump_texcoord_transform[1]));
  output.texcoord_3 = position.xy * image_texcoord_transform.xy + image_texcoord_transform.zw;
  return output;
}
