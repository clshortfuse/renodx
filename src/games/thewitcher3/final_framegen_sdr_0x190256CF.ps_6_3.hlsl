#include "./common.hlsl"
#include "./lilium_rcas.hlsl"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

cbuffer cb3 : register(b3) {
  float4 CustomPixelConsts_000 : packoffset(c000.x);
  float4 CustomPixelConsts_016 : packoffset(c001.x);
  float4 CustomPixelConsts_032 : packoffset(c002.x);
  float4 CustomPixelConsts_048 : packoffset(c003.x);
  float4 CustomPixelConsts_064 : packoffset(c004.x);
  float4 CustomPixelConsts_080 : packoffset(c005.x);
  float4 CustomPixelConsts_096 : packoffset(c006.x);
  float4 CustomPixelConsts_112 : packoffset(c007.x);
  float4 CustomPixelConsts_128 : packoffset(c008.x);
  float4 CustomPixelConsts_144 : packoffset(c009.x);
  float4 CustomPixelConsts_160 : packoffset(c010.x);
  float4 CustomPixelConsts_176 : packoffset(c011.x);
  float4 CustomPixelConsts_192 : packoffset(c012.x);
  float4 CustomPixelConsts_208 : packoffset(c013.x);
  float4 CustomPixelConsts_224 : packoffset(c014.x);
  float4 CustomPixelConsts_240 : packoffset(c015.x);
  float4 CustomPixelConsts_256 : packoffset(c016.x);
  float4 CustomPixelConsts_272 : packoffset(c017.x);
  float4 CustomPixelConsts_288 : packoffset(c018.x);
  float4 CustomPixelConsts_304 : packoffset(c019.x);
  float4 CustomPixelConsts_320 : packoffset(c020.x);
  float4 CustomPixelConsts_336[4] : packoffset(c021.x);
};

SamplerState s1 : register(s1);

struct OutputSignature {
  float4 SV_Target : SV_Target;
  float4 SV_Target_1 : SV_Target1;
  float4 SV_Target_2 : SV_Target2;
};

OutputSignature main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) {
  float4 SV_Target;
  float4 SV_Target_1;
  float4 SV_Target_2;
  float4 _20 = t1.Load(int3(int(SV_Position.x - CustomPixelConsts_016.x), int(SV_Position.y - CustomPixelConsts_016.y), 0));
  float4 _25 = t0.SampleLevel(s1, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);

  float3 gamma_game_color = _25.rgb;
  float3 gamma_ui_color = _20.rgb;

  float game_alpha = _25.w;
  float ui_alpha = _20.w;

  float3 linear_game_color = renodx::color::gamma::Decode(gamma_game_color);

  linear_game_color.xyz = ApplyRCAS(linear_game_color.xyz, TEXCOORD, t0, s1);
  linear_game_color.xyz = CustomTonemap(linear_game_color.xyz, SdrConfig());
  linear_game_color.xyz = renodx::effects::ApplyFilmGrain(
      linear_game_color.xyz,
      float2(TEXCOORD.x, TEXCOORD.y),
      CUSTOM_RANDOM,
      CUSTOM_FILM_GRAIN_STRENGTH * 0.03f);

  float3 linear_ui_color = renodx::color::gamma::Decode(gamma_ui_color);

  float4 outputColor = HandleUICompositing(float4(linear_ui_color, ui_alpha), float4(linear_game_color, game_alpha));

  SV_Target.rgb = renodx::color::gamma::Encode(outputColor.rgb);
  SV_Target.w = outputColor.w;

  SV_Target_2.rgb = renodx::color::gamma::Encode(linear_game_color);
  SV_Target_2.w = pow(game_alpha, 1.f / 2.2f);

  OutputSignature output_signature = { SV_Target, SV_Target_1, SV_Target_2 };
  return output_signature;
}


// OutputSignature main(
//   noperspective float4 SV_Position : SV_Position,
//   linear float2 TEXCOORD : TEXCOORD
// ) {
//   float4 SV_Target;
//   float4 SV_Target_1;
//   float4 SV_Target_2;
//   float4 _20 = t1.Load(int3(int(SV_Position.x - CustomPixelConsts_016.x), int(SV_Position.y - CustomPixelConsts_016.y), 0));
//   float4 _25 = t0.SampleLevel(s1, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
//   float _30 = CustomPixelConsts_032.y * CustomPixelConsts_032.x;
//   float _46 = (pow(_25.x, _30));
//   float _47 = (pow(_25.y, _30));
//   float _48 = (pow(_25.z, _30));
//   SV_Target.x = exp2(log2((((pow(_20.x, _30)) - _46) * _20.w) + _46) * CustomPixelConsts_032.z);
//   SV_Target.y = exp2(log2((((pow(_20.y, _30)) - _47) * _20.w) + _47) * CustomPixelConsts_032.z);
//   SV_Target.z = exp2(log2((((pow(_20.z, _30)) - _48) * _20.w) + _48) * CustomPixelConsts_032.z);
//   SV_Target.w = exp2(log2(lerp(_25.w, _20.w, _20.w)) * CustomPixelConsts_032.z);
//   SV_Target_2.x = (pow(_46, CustomPixelConsts_032.z));
//   SV_Target_2.y = (pow(_47, CustomPixelConsts_032.z));
//   SV_Target_2.z = (pow(_48, CustomPixelConsts_032.z));
//   SV_Target_2.w = (pow(_25.w, CustomPixelConsts_032.z));
//   OutputSignature output_signature = { SV_Target, SV_Target_1, SV_Target_2 };
//   return output_signature;
// }
