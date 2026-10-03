#include "./colorgrade.hlsli"
#include "./shared.h"
#include "./tonemap.hlsli"


struct Clustered_Params {
  column_major float4x4 clusters_view_proj;
  float3 clusters_count_inv;
  int spot_light_offset;
  int3 clusters_count;
  uint _pad0;
  float2 clusters_near_far;
  float2 _pad1;
  int light_count;
  int decal_count;
  int light_probe_count;
  int shadow_decal_count;
};

struct Fog_Params {
  float4 min_corner_and_inv_size_point_light[3];
  float4 min_corner_and_inv_size0;
  float4 min_corner_and_inv_size1;
  float3 min_corner2;
  uint fog_texture_heap_index;
  float3 inv_size2;
  uint pad0;
};

struct Viewpoint_Params {
  column_major float4x4 vp_transform;
  column_major float4x4 vp_inverse_transform;
  column_major float4x4 vp_reflected_world_to_proj_matrices[4];
  column_major float4x4 vp_inverse_reflected_world_to_proj_matrices[4];
  column_major float4x4 vp_view_matrix;
  column_major float4x4 vp_inverse_proj_matrix;
  column_major float4x4 vp_proj_matrix;
  float3 vp_view_origin;
  float vp_time;
  float3 vp_view_direction;
  int vp_auto_tbn;
  float2 vp_framebuffer_inverse_extents;
  float vp_framebuffer_depth_m;
  float vp_framebuffer_depth_a;
  float vp_depth_near;
  float vp_depth_far;
  float inv_depth_range;
  float vp_zoom_out_factor;
  int vp_debug_lightmap_mode;
  uint vp_frame_index;
  uint type;
  int vp_debug_mode;
  float3 billboard_e1_view;
  int vp_shading_flags;
  float3 billboard_e2_view;
  float vp_map_mode_amount;
  float3 billboard_e3_view;
  uint bit_state;
};

Texture2D<float4> color_texture : register(t51);
Texture2D<float4> bloom_texture : register(t52);

cbuffer component_viewpoint_c : register(b2) {
  Viewpoint_Params viewpoint_params : packoffset(c000.x);
  Fog_Params fog_params : packoffset(c060.x);
  Clustered_Params clustered_params : packoffset(c067.x);
  float2 fog_z_range : packoffset(c075.x);
  column_major float4x4 fog_view_proj : packoffset(c076.x);
};

cbuffer cb_shader : register(b3) {
  float contrast : packoffset(c000.x);
  float white_point : packoffset(c000.y);
  float tone_mapper_curve : packoffset(c000.z);
  float to_target_curve_scale : packoffset(c000.w);
  float bloom_intensity : packoffset(c001.x);
  float vibrance_filter_scale : packoffset(c001.y);
  float3 color_filter : packoffset(c002.x);
  float saturation : packoffset(c002.w);
  float3 lift_adjust : packoffset(c003.x);
  float3 gain_adjust : packoffset(c004.x);
  float3 inv_gamma_adjust : packoffset(c005.x);
  float scotopic_vision_scale : packoffset(c005.w);
  float3 scotopic_vision_color : packoffset(c006.x);
  float scotopic_vision_max_luminance : packoffset(c006.w);
  float undo_effect_t : packoffset(c007.x);
  float undo_effect_t_smooth : packoffset(c007.y);
  float2 distort_intensity : packoffset(c007.z);
  float pulse_intensity : packoffset(c008.x);
  float noise_intensity : packoffset(c008.y);
};

SamplerState Sampler_Linear_Clamp : register(s6);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD) : SV_Target {
  float4 SV_Target;
  float _23 = min((viewpoint_params.vp_framebuffer_inverse_extents.y / viewpoint_params.vp_framebuffer_inverse_extents.x), 1.0f) * ((viewpoint_params.vp_framebuffer_inverse_extents.x * SV_Position.x) + -0.5f);
  float _24 = min((viewpoint_params.vp_framebuffer_inverse_extents.x / viewpoint_params.vp_framebuffer_inverse_extents.y), 1.0f) * ((viewpoint_params.vp_framebuffer_inverse_extents.y * SV_Position.y) + -0.5f);
  float _30 = sqrt((_24 * _24) + (_23 * _23));
  float _31 = _30 * 2.0f;
  float _33 = undo_effect_t_smooth * undo_effect_t_smooth;
  float _35 = _33 + 0.20000000298023224f;
  float _39 = saturate(((1.0f - _31) - _35) / ((_33 * 0.5f) - _35));
  float _44 = ((_39 * _39) * undo_effect_t_smooth) * (3.0f - (_39 * 2.0f));
  bool _45 = !(undo_effect_t_smooth == 0.0f);
  float _345;
  float _346;
  float _347;
  float _384;
  float _553;
  float _554;
  float _555;
  float _781;
  float _782;
  float _783;
  if (_45) {
    float _49 = ((_44 * 0.5f) + 0.5f) * undo_effect_t_smooth;
    float _54 = _23 * 106.0660171508789f;
    float _55 = _24 * 106.0660171508789f;
    float _56 = viewpoint_params.vp_time * 1.336431860923767f;
    float _57 = dot(float3(_54, _55, _56), float3(0.3333333432674408f, 0.3333333432674408f, 0.3333333432674408f));
    float _61 = floor(_57 + _54);
    float _62 = floor(_57 + _55);
    float _63 = floor(_56 + _57);
    float _67 = dot(float3(_61, _62, _63), float3(0.1666666716337204f, 0.1666666716337204f, 0.1666666716337204f));
    float _68 = _67 + (_54 - _61);
    float _69 = _67 + (_55 - _62);
    float _70 = (_56 - _63) + _67;
    float _74 = select((_68 < _69), 0.0f, 1.0f);
    float _75 = select((_69 < _70), 0.0f, 1.0f);
    float _76 = select((_70 < _68), 0.0f, 1.0f);
    float _77 = 1.0f - _74;
    float _78 = 1.0f - _75;
    float _79 = 1.0f - _76;
    float _80 = min(_74, _79);
    float _81 = min(_75, _77);
    float _82 = min(_76, _78);
    float _83 = max(_74, _79);
    float _84 = max(_75, _77);
    float _85 = max(_76, _78);
    float _89 = (_68 - _80) + 0.1666666716337204f;
    float _90 = (_69 - _81) + 0.1666666716337204f;
    float _91 = (_70 - _82) + 0.1666666716337204f;
    float _95 = (_68 - _83) + 0.3333333432674408f;
    float _96 = (_69 - _84) + 0.3333333432674408f;
    float _97 = (_70 - _85) + 0.3333333432674408f;
    float _98 = _68 + -0.5f;
    float _99 = _69 + -0.5f;
    float _100 = _70 + -0.5f;
    float _110 = _61 - (floor(_61 * 0.014492753893136978f) * 69.0f);
    float _111 = _62 - (floor(_62 * 0.014492753893136978f) * 69.0f);
    float _112 = _63 - (floor(_63 * 0.014492753893136978f) * 69.0f);
    float _124 = select((_112 > 67.5f), 0.0f, 1.0f) * (_112 + 1.0f);
    float _125 = _110 + 50.0f;
    float _126 = _111 + 161.0f;
    float _127 = (select((_110 > 67.5f), 0.0f, 1.0f) * (_110 + 1.0f)) + 50.0f;
    float _128 = (select((_111 > 67.5f), 0.0f, 1.0f) * (_111 + 1.0f)) + 161.0f;
    float _129 = _125 * _125;
    float _130 = _126 * _126;
    float _131 = _127 * _127;
    float _132 = _128 * _128;
    float _133 = _131 - _129;
    float _134 = _132 - _130;
    float _143 = _130 * _129;
    float _144 = ((_134 * _81) + _130) * ((_133 * _80) + _129);
    float _145 = ((_134 * _84) + _130) * ((_133 * _83) + _129);
    float _146 = _132 * _131;
    float _153 = 1.0f / ((_112 * 48.500389099121094f) + 635.2987060546875f);
    float _154 = 1.0f / ((_112 * 65.29412078857422f) + 682.3574829101562f);
    float _155 = 1.0f / ((_112 * 63.934600830078125f) + 668.926513671875f);
    float _162 = 1.0f / ((_124 * 48.500389099121094f) + 635.2987060546875f);
    float _163 = 1.0f / ((_124 * 65.29412078857422f) + 682.3574829101562f);
    float _164 = 1.0f / ((_124 * 63.934600830078125f) + 668.926513671875f);
    bool _165 = (_82 < 0.5f);
    bool _169 = (_85 < 0.5f);
    float _197 = frac(_143 * _153) + -0.49998998641967773f;
    float _198 = frac(_144 * select(_165, _153, _162)) + -0.49998998641967773f;
    float _199 = frac(_145 * select(_169, _153, _162)) + -0.49998998641967773f;
    float _200 = frac(_146 * _162) + -0.49998998641967773f;
    float _201 = frac(_143 * _154) + -0.49998998641967773f;
    float _202 = frac(_144 * select(_165, _154, _163)) + -0.49998998641967773f;
    float _203 = frac(_145 * select(_169, _154, _163)) + -0.49998998641967773f;
    float _204 = frac(_146 * _163) + -0.49998998641967773f;
    float _205 = frac(_143 * _155) + -0.49998998641967773f;
    float _206 = frac(_144 * select(_165, _155, _164)) + -0.49998998641967773f;
    float _207 = frac(_145 * select(_169, _155, _164)) + -0.49998998641967773f;
    float _208 = frac(_146 * _164) + -0.49998998641967773f;
    float _229 = rsqrt(((_201 * _201) + (_197 * _197)) + (_205 * _205));
    float _230 = rsqrt(((_202 * _202) + (_198 * _198)) + (_206 * _206));
    float _231 = rsqrt(((_203 * _203) + (_199 * _199)) + (_207 * _207));
    float _232 = rsqrt(((_204 * _204) + (_200 * _200)) + (_208 * _208));
    float _233 = _229 * _197;
    float _234 = _230 * _198;
    float _235 = _231 * _199;
    float _236 = _232 * _200;
    float _237 = _229 * _201;
    float _238 = _230 * _202;
    float _239 = _231 * _203;
    float _240 = _232 * _204;
    float _241 = _229 * _205;
    float _242 = _230 * _206;
    float _243 = _231 * _207;
    float _244 = _232 * _208;
    float _261 = ((_233 * _68) + (_237 * _69)) + (_241 * _70);
    float _262 = ((_234 * _89) + (_238 * _90)) + (_242 * _91);
    float _263 = ((_235 * _95) + (_239 * _96)) + (_243 * _97);
    float _264 = ((_236 * _98) + (_240 * _99)) + (_244 * _100);
    float _289 = max((((0.5f - (_69 * _69)) - (_68 * _68)) - (_70 * _70)), 0.0f);
    float _290 = max((((0.5f - (_89 * _89)) - (_90 * _90)) - (_91 * _91)), 0.0f);
    float _291 = max((((0.5f - (_95 * _95)) - (_96 * _96)) - (_97 * _97)), 0.0f);
    float _292 = max((((0.5f - (_99 * _99)) - (_98 * _98)) - (_100 * _100)), 0.0f);
    float _293 = _289 * _289;
    float _294 = _290 * _290;
    float _295 = _291 * _291;
    float _296 = _292 * _292;
    float _297 = _293 * _289;
    float _298 = _294 * _290;
    float _299 = _295 * _291;
    float _300 = _296 * _292;
    float _302 = (_261 * -6.0f) * _293;
    float _304 = (_262 * -6.0f) * _294;
    float _306 = (_263 * -6.0f) * _295;
    float _308 = (_264 * -6.0f) * _296;
    float _320 = (dot(float4(_297, _298, _299, _300), float4(_233, _234, _235, _236)) + dot(float4(_302, _304, _306, _308), float4(_68, _89, _95, _98))) * 37.83722686767578f;
    float _321 = (dot(float4(_297, _298, _299, _300), float4(_237, _238, _239, _240)) + dot(float4(_302, _304, _306, _308), float4(_69, _90, _96, _99))) * 37.83722686767578f;
    float _329 = (((_49 * _49) * ((_31 * _30) + 0.5f)) * _49) * rsqrt(dot(float2(_320, _321), float2(_320, _321)));
    _345 = (((_320 * distort_intensity.x) * _329) + TEXCOORD.x);
    _346 = (((_321 * distort_intensity.y) * _329) + TEXCOORD.y);
    _347 = (((((_30 * 75.67445373535156f) * _44) * (dot(float4(_297, _298, _299, _300), float4(_241, _242, _243, _244)) + dot(float4(_302, _304, _306, _308), float4(_70, _91, _97, _100)))) * noise_intensity) * abs(dot(float4(_297, _298, _299, _300), float4(_261, _262, _263, _264)) * 37.83722686767578f));
  } else {
    _345 = TEXCOORD.x;
    _346 = TEXCOORD.y;
    _347 = 0.0f;
  }
  float4 _350 = color_texture.SampleLevel(Sampler_Linear_Clamp, float2(_345, _346), 0.0f);
  float4 _355 = bloom_texture.Sample(Sampler_Linear_Clamp, float2(TEXCOORD.x, TEXCOORD.y));
  // CUSTOM: Scale the game's original linear-light bloom contribution.
  // float _364 = (bloom_intensity * _355.x) + _350.x;
  // float _365 = (bloom_intensity * _355.y) + _350.y;
  // float _366 = (bloom_intensity * _355.z) + _350.z;
  float _364 = ((bloom_intensity * CUSTOM_BLOOM) * _355.x) + _350.x;
  float _365 = ((bloom_intensity * CUSTOM_BLOOM) * _355.y) + _350.y;
  float _366 = ((bloom_intensity * CUSTOM_BLOOM) * _355.z) + _350.z;
  float _368 = max(_364, max(_365, _366));
  float _370 = min(_364, min(_365, _366));
  float _374 = _368 - _370;
  if (_368 == _364) {
    _384 = ((vibrance_filter_scale * 0.5f) * (min(1.0f, abs((_365 - _366) / _374)) + 1.0f));
  } else {
    _384 = vibrance_filter_scale;
  }
  float _386 = _384 * (2.0f - _374);
  float _389 = (_386 * (1.0f - _374)) + 1.0f;
  float _393 = _386 * _370;
  float _394 = (_389 * _364) - _393;
  float _395 = (_389 * _365) - _393;
  float _396 = (_389 * _366) - _393;
  float _398 = dot(float3(_364, _365, _366), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f)) / dot(float3(_394, _395, _396), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _404 = (color_filter.x * _398) * _394;
  float _406 = (color_filter.y * _398) * _395;
  float _408 = (color_filter.z * _398) * _396;
  float _409 = dot(float3(_404, _406, _408), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _455 = saturate(exp2(log2(max(0.0f, (exp2((contrast * (log2(lerp(_409, _404, saturation)) + 1.717856764793396f)) + -1.717856764793396f) + -0.0010000000474974513f)) / white_point) * inv_gamma_adjust.x));
  float _460 = (((1.0f - _455) * lift_adjust.x) + (_455 * gain_adjust.x)) * white_point;
  float _468 = saturate(exp2(log2(max(0.0f, (exp2(((log2(lerp(_409, _406, saturation)) + 1.717856764793396f) * contrast) + -1.717856764793396f) + -0.0010000000474974513f)) / white_point) * inv_gamma_adjust.y));
  float _473 = (((1.0f - _468) * lift_adjust.y) + (_468 * gain_adjust.y)) * white_point;
  float _481 = saturate(exp2(log2(max(0.0f, (exp2(((log2(lerp(_409, _408, saturation)) + 1.717856764793396f) * contrast) + -1.717856764793396f) + -0.0010000000474974513f)) / white_point) * inv_gamma_adjust.z));
  float _486 = (((1.0f - _481) * lift_adjust.z) + (_481 * gain_adjust.z)) * white_point;
  // CUSTOM: Preserve the exact grade at vanilla effect strengths; otherwise
  // scale the authored saturation, lift, gamma, and gain around their identities.
  const float3 custom_color_graded = SinkingStarApplyCustomColorGrade(
      float3(_404, _406, _408),
      _409,
      saturation,
      contrast,
      white_point,
      inv_gamma_adjust,
      lift_adjust,
      gain_adjust,
      float3(_460, _473, _486));
  _460 = custom_color_graded.x;
  _473 = custom_color_graded.y;
  _486 = custom_color_graded.z;
  float _497 = saturate(dot(float3(mad(_486, 0.024800000712275505f, mad(_473, 0.3653999865055084f, (_460 * 0.5149000287055969f))), mad(_486, 0.12479999661445618f, mad(_473, 0.6704000234603882f, (_460 * 0.32440000772476196f))), mad(_486, 0.8503999710083008f, mad(_473, 0.06419999897480011f, (_460 * 0.1606999933719635f)))), float3(-0.8050000071525574f, 1.1820000410079956f, 0.3619999885559082f)));
  float _502 = 1.0f - saturate(_497 / scotopic_vision_max_luminance);
  float _505 = (_502 * _502) * scotopic_vision_scale;
  float _511 = rsqrt(dot(float3(scotopic_vision_color.x, scotopic_vision_color.y, scotopic_vision_color.z), float3(scotopic_vision_color.x, scotopic_vision_color.y, scotopic_vision_color.z))) * _497;
  float _521 = (((_511 * scotopic_vision_color.x) - _460) * _505) + _460;
  float _522 = (((_511 * scotopic_vision_color.y) - _473) * _505) + _473;
  float _523 = (((_511 * scotopic_vision_color.z) - _486) * _505) + _486;
  if (_45) {
    float _540 = (_30 + 0.5f) * undo_effect_t_smooth;
    float _542 = (exp2(((-0.0f - _347) - (((_44 * (1.0f - undo_effect_t_smooth)) * pulse_intensity) * cos((_30 + undo_effect_t_smooth) * 12.566370964050293f))) * 1.4426950216293335f) * 0.699999988079071f) * dot(float3(_521, _522, _523), float3(0.2989000082015991f, 0.5866000056266785f, 0.1145000010728836f));
    _553 = (lerp(_521, _542, _540));
    _554 = (lerp(_522, _542, _540));
    _555 = (lerp(_523, _542, _540));
  } else {
    _553 = _521;
    _554 = _522;
    _555 = _523;
  }
  float _557 = _553 * to_target_curve_scale;
  float _558 = _554 * to_target_curve_scale;
  float _559 = _555 * to_target_curve_scale;

  if (tone_mapper_curve == 0.0f) {
    float _563 = dot(float3(_557, _558, _559), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
    float _564 = _563 * 0.15000000596046448f;
    float _575 = ((((((_564 + 0.05000000074505806f) * _563) + 0.0020000000949949026f) / (((_564 + 0.5f) * _563) + 0.06000000238418579f)) + -0.03333333134651184f) * 1.6641758680343628f) / max(_563, 0.0010000000474974513f);
    _781 = (_575 * _557);
    _782 = (_575 * _558);
    _783 = (_575 * _559);
  } else {
    if (tone_mapper_curve == 3.0f) {
      float _582 = _559 * 0.15000000596046448f;
      float _592 = _558 * 0.15000000596046448f;
      float _602 = _557 * 0.15000000596046448f;
      _781 = ((((((_602 + 0.05000000074505806f) * _557) + 0.0020000000949949026f) / (((_602 + 0.5f) * _557) + 0.06000000238418579f)) + -0.03333333134651184f) * 1.6641758680343628f);
      _782 = ((((((_592 + 0.05000000074505806f) * _558) + 0.0020000000949949026f) / (((_592 + 0.5f) * _558) + 0.06000000238418579f)) + -0.03333333134651184f) * 1.6641758680343628f);
      _783 = ((((((_582 + 0.05000000074505806f) * _559) + 0.0020000000949949026f) / (((_582 + 0.5f) * _559) + 0.06000000238418579f)) + -0.03333333134651184f) * 1.6641758680343628f);
    } else {
      if (tone_mapper_curve == 4.0f) {
        _781 = saturate((((_557 * 2.509999990463257f) + 0.029999999329447746f) * _557) / ((((_557 * 2.430000066757202f) + 0.5899999737739563f) * _557) + 0.14000000059604645f));
        _782 = saturate((((_558 * 2.509999990463257f) + 0.029999999329447746f) * _558) / ((((_558 * 2.430000066757202f) + 0.5899999737739563f) * _558) + 0.14000000059604645f));
        _783 = saturate((((_559 * 2.509999990463257f) + 0.029999999329447746f) * _559) / ((((_559 * 2.430000066757202f) + 0.5899999737739563f) * _559) + 0.14000000059604645f));
      } else {
        if (tone_mapper_curve == 1.0f) {
          float _645 = dot(float3(_557, _558, _559), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
          float _656 = saturate((((_645 * 2.509999990463257f) + 0.029999999329447746f) * _645) / ((((_645 * 2.430000066757202f) + 0.5899999737739563f) * _645) + 0.14000000059604645f)) / max(_645, 0.0010000000474974513f);
          _781 = (_656 * _557);
          _782 = (_656 * _558);
          _783 = (_656 * _559);
        } else {
          if (tone_mapper_curve == 5.0f) {
            float _663 = _557 * 0.6000000238418579f;
            float _664 = _558 * 0.6000000238418579f;
            float _665 = _559 * 0.6000000238418579f;
            _781 = saturate((((_557 * 1.50600004196167f) + 0.029999999329447746f) * _663) / ((((_557 * 1.4580000638961792f) + 0.5899999737739563f) * _663) + 0.14000000059604645f));
            _782 = saturate((((_558 * 1.50600004196167f) + 0.029999999329447746f) * _664) / ((((_558 * 1.4580000638961792f) + 0.5899999737739563f) * _664) + 0.14000000059604645f));
            _783 = saturate((((_559 * 1.50600004196167f) + 0.029999999329447746f) * _665) / ((((_559 * 1.4580000638961792f) + 0.5899999737739563f) * _665) + 0.14000000059604645f));
          } else {
            if (tone_mapper_curve == 2.0f) {
              float _696 = _557 * 0.6000000238418579f;
              float _697 = _558 * 0.6000000238418579f;
              float _698 = _559 * 0.6000000238418579f;
              float _699 = dot(float3(_696, _697, _698), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
              float _710 = saturate((((_699 * 2.509999990463257f) + 0.029999999329447746f) * _699) / ((((_699 * 2.430000066757202f) + 0.5899999737739563f) * _699) + 0.14000000059604645f)) / max(_699, 0.0010000000474974513f);
              _781 = (_710 * _696);
              _782 = (_710 * _697);
              _783 = (_710 * _698);
            } else {
              if (tone_mapper_curve == 6.0f) {
                float _723 = (pow(_557, 0.45454543828964233f));
                float _724 = (pow(_558, 0.45454543828964233f));
                float _725 = (pow(_559, 0.45454543828964233f));
                float _728 = mad(0.04822999984025955f, _725, mad(0.35457998514175415f, _724, (_723 * 0.5971900224685669f)));
                float _731 = mad(0.01565999910235405f, _725, mad(0.9083399772644043f, _724, (_723 * 0.07599999755620956f)));
                float _734 = mad(0.8377699851989746f, _725, mad(0.1338299959897995f, _724, (_723 * 0.0284000001847744f)));
                float _756 = (((_728 + 0.024578599259257317f) * _728) + -9.053700341610238e-05f) / ((((_728 * 0.9837290048599243f) + 0.4329510033130646f) * _728) + 0.23808099329471588f);
                float _757 = (((_731 + 0.024578599259257317f) * _731) + -9.053700341610238e-05f) / ((((_731 * 0.9837290048599243f) + 0.4329510033130646f) * _731) + 0.23808099329471588f);
                float _758 = (((_734 + 0.024578599259257317f) * _734) + -9.053700341610238e-05f) / ((((_734 * 0.9837290048599243f) + 0.4329510033130646f) * _734) + 0.23808099329471588f);
                _781 = saturate(exp2(log2(mad(-0.07366999983787537f, _758, mad(-0.5310800075531006f, _757, (_756 * 1.6047500371932983f)))) * 2.200000047683716f));
                _782 = saturate(exp2(log2(mad(-0.006049999967217445f, _758, mad(1.1081299781799316f, _757, (_756 * -0.10208000242710114f)))) * 2.200000047683716f));
                _783 = saturate(exp2(log2(mad(1.0760200023651123f, _758, mad(-0.07276000082492828f, _757, (_756 * -0.003269999986514449f)))) * 2.200000047683716f));
              } else {
                _781 = _557;
                _782 = _558;
                _783 = _559;
              }
            }
          }
        }
      }
    }
  }

  // CUSTOM: dispatch from the proven linear graded scene while retaining the exact bounded vanilla result as the extension base.
  if (RENODX_PEAK_WHITE_NITS > 0.f && RENODX_TONE_MAP_TYPE != RENODX_TONE_MAP_TYPE_VANILLA) {
    const float3 custom_untonemapped = float3(_557, _558, _559);
    const float3 custom_vanilla = saturate(float3(_781, _782, _783));
    if (RENODX_TONE_MAP_TYPE == RENODX_TONE_MAP_TYPE_NEUTWO
        || RENODX_TONE_MAP_TYPE == RENODX_TONE_MAP_TYPE_PSYCHOV17
        || RENODX_TONE_MAP_TYPE == RENODX_TONE_MAP_TYPE_PSYCHOV30) {
      const SinkingStarVanillaToneMapReference custom_reference = SinkingStarResolveVanillaToneMapReference(
          tone_mapper_curve,
          RENODX_TONE_MAP_TYPE == RENODX_TONE_MAP_TYPE_NEUTWO);
      if (RENODX_TONE_MAP_TYPE == RENODX_TONE_MAP_TYPE_PSYCHOV17) {
        SV_Target.rgb = SinkingStarApplyPsychoV17(custom_untonemapped, custom_reference, tone_mapper_curve);
      } else if (RENODX_TONE_MAP_TYPE == RENODX_TONE_MAP_TYPE_PSYCHOV30) {
        SV_Target.rgb = SinkingStarApplyPsychoV30(custom_untonemapped, custom_reference, tone_mapper_curve);
      } else {
        SV_Target.rgb = renodx::draw::ToneMapPass(
            SinkingStarApplyVanillaToneMapExtended(
                custom_untonemapped,
                custom_vanilla,
                tone_mapper_curve,
                custom_reference));
      }
#ifndef NDEBUG
      // CUSTOM: show the PsychoV reference solve for live comparison without affecting release shaders.
      if (CUSTOM_DEBUG_CANVAS != 0.f) {
        SV_Target.rgb = SinkingStarDrawPsychoVDebugCanvas(
            SV_Target.rgb,
            SV_Position.xy,
            tone_mapper_curve,
            RENODX_TONE_MAP_TYPE,
            custom_reference);
      }
#endif
    } else {
      SV_Target.rgb = custom_vanilla;
    }
    // CUSTOM: prepare the scene for graphics-white UI composition and the matching final SwapChainPass.
    SV_Target.rgb = renodx::draw::RenderIntermediatePass(SV_Target.rgb);
    SV_Target.w = 1.f;
    return SV_Target;
  }

  // CUSTOM: emulate the original implicit UNORM clamp after cloning ldr_target to RGBA16F.
  SV_Target.rgb = renodx::draw::RenderIntermediatePass(saturate(float3(_781, _782, _783)));
  SV_Target.w = 1.0f;
  return SV_Target;
}
