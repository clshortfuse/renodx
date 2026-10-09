// CUSTOM: Existing RenoDX controls and updated curve-6 reference.
#include "./colorgrade.hlsli"
#define SINKING_STAR_LINEAR_CURVE_6
#include "./tonemap.hlsli"
#undef SINKING_STAR_LINEAR_CURVE_6

struct Clustered_Params {
  float3 clusters_count_inv;
  int spot_light_offset;
  int3 clusters_count;
  uint _pad0;
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
  uint fog_noise_heap_index;
  uint fog_shadow_heap_index;
  float pad0;
  float pad1;
  float pad2;
};

struct Viewpoint_Params {
  row_major float4x4 vp_transform;
  row_major float4x4 vp_inverse_transform;
  row_major float4x4 vp_reflected_world_to_proj_matrices[4];
  row_major float4x4 vp_inverse_reflected_world_to_proj_matrices[4];
  row_major float4x4 vp_view_matrix;
  row_major float4x4 vp_inverse_proj_matrix;
  row_major float4x4 vp_proj_matrix;
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

Texture2D<float4> color_texture : register(t54);

Texture2D<float4> bloom_texture : register(t55);

cbuffer component_viewpoint_c : register(b2) {
  Viewpoint_Params viewpoint_params : packoffset(c000.x);
  Fog_Params fog_params : packoffset(c060.x);
  Clustered_Params clustered_params : packoffset(c068.x);
  float2 fog_z_range : packoffset(c071.x);
  row_major float4x4 fog_view_proj : packoffset(c072.x);
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

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}
uint firstbithigh_msb(uint value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}

float4 main(
    precise noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD) : SV_Target {
  float4 SV_Target;
  float _23;
  float _24;
  float _30;
  float _31;
  float _33;
  float _35;
  float _39;
  float _44;
  bool _45;
  float _345;
  float _346;
  float _347;
  float _384;
  float _553;
  float _554;
  float _555;
  float _763;
  float _764;
  float _765;
  float _49;
  float _54;
  float _55;
  float _56;
  float _57;
  float _61;
  float _62;
  float _63;
  float _67;
  float _68;
  float _69;
  float _70;
  float _74;
  float _75;
  float _76;
  float _77;
  float _78;
  float _79;
  float _80;
  float _81;
  float _82;
  float _83;
  float _84;
  float _85;
  float _89;
  float _90;
  float _91;
  float _95;
  float _96;
  float _97;
  float _98;
  float _99;
  float _100;
  float _110;
  float _111;
  float _112;
  float _124;
  float _125;
  float _126;
  float _127;
  float _128;
  float _129;
  float _130;
  float _131;
  float _132;
  float _133;
  float _134;
  float _143;
  float _144;
  float _145;
  float _146;
  float _153;
  float _154;
  float _155;
  float _162;
  float _163;
  float _164;
  bool _165;
  bool _169;
  float _197;
  float _198;
  float _199;
  float _200;
  float _201;
  float _202;
  float _203;
  float _204;
  float _205;
  float _206;
  float _207;
  float _208;
  float _229;
  float _230;
  float _231;
  float _232;
  float _233;
  float _234;
  float _235;
  float _236;
  float _237;
  float _238;
  float _239;
  float _240;
  float _241;
  float _242;
  float _243;
  float _244;
  float _261;
  float _262;
  float _263;
  float _264;
  float _289;
  float _290;
  float _291;
  float _292;
  float _293;
  float _294;
  float _295;
  float _296;
  float _297;
  float _298;
  float _299;
  float _300;
  float _302;
  float _304;
  float _306;
  float _308;
  float _320;
  float _321;
  float _329;
  float4 _350;
  float4 _355;
  float _364;
  float _365;
  float _366;
  float _368;
  float _370;
  float _374;
  float _386;
  float _389;
  float _393;
  float _394;
  float _395;
  float _396;
  float _398;
  float _404;
  float _406;
  float _408;
  float _409;
  float _417;
  float _455;
  float _460;
  float _468;
  float _473;
  float _481;
  float _486;
  float _497;
  float _502;
  float _505;
  float _511;
  float _521;
  float _522;
  float _523;
  float _540;
  float _542;
  float _557;
  float _558;
  float _559;
  float _563;
  float _564;
  float _575;
  float _582;
  float _592;
  float _602;
  float _645;
  float _656;
  float _663;
  float _664;
  float _665;
  float _696;
  float _697;
  float _698;
  float _699;
  float _710;
  float _719;
  float _722;
  float _725;
  float _747;
  float _748;
  float _749;
  _23 = min((viewpoint_params.vp_framebuffer_inverse_extents.y / viewpoint_params.vp_framebuffer_inverse_extents.x), 1.0f) * ((viewpoint_params.vp_framebuffer_inverse_extents.x * SV_Position.x) + -0.5f);
  _24 = min((viewpoint_params.vp_framebuffer_inverse_extents.x / viewpoint_params.vp_framebuffer_inverse_extents.y), 1.0f) * ((viewpoint_params.vp_framebuffer_inverse_extents.y * SV_Position.y) + -0.5f);
  _30 = sqrt((_24 * _24) + (_23 * _23));
  _31 = _30 * 2.0f;
  _33 = undo_effect_t_smooth * undo_effect_t_smooth;
  _35 = _33 + 0.20000000298023224f;
  _39 = saturate(((1.0f - _31) - _35) / ((_33 * 0.5f) - _35));
  _44 = ((_39 * _39) * undo_effect_t_smooth) * (3.0f - (_39 * 2.0f));
  _45 = !(undo_effect_t_smooth == 0.0f);
  if (_45) {
    _49 = ((_44 * 0.5f) + 0.5f) * undo_effect_t_smooth;
    _54 = _23 * 106.0660171508789f;
    _55 = _24 * 106.0660171508789f;
    _56 = viewpoint_params.vp_time * 1.336431860923767f;
    _57 = dot(float3(_54, _55, _56), float3(0.3333333432674408f, 0.3333333432674408f, 0.3333333432674408f));
    _61 = floor(_57 + _54);
    _62 = floor(_57 + _55);
    _63 = floor(_56 + _57);
    _67 = dot(float3(_61, _62, _63), float3(0.1666666716337204f, 0.1666666716337204f, 0.1666666716337204f));
    _68 = _67 + (_54 - _61);
    _69 = _67 + (_55 - _62);
    _70 = (_56 - _63) + _67;
    _74 = select((_68 < _69), 0.0f, 1.0f);
    _75 = select((_69 < _70), 0.0f, 1.0f);
    _76 = select((_70 < _68), 0.0f, 1.0f);
    _77 = 1.0f - _74;
    _78 = 1.0f - _75;
    _79 = 1.0f - _76;
    _80 = min(_74, _79);
    _81 = min(_75, _77);
    _82 = min(_76, _78);
    _83 = max(_74, _79);
    _84 = max(_75, _77);
    _85 = max(_76, _78);
    _89 = (_68 - _80) + 0.1666666716337204f;
    _90 = (_69 - _81) + 0.1666666716337204f;
    _91 = (_70 - _82) + 0.1666666716337204f;
    _95 = (_68 - _83) + 0.3333333432674408f;
    _96 = (_69 - _84) + 0.3333333432674408f;
    _97 = (_70 - _85) + 0.3333333432674408f;
    _98 = _68 + -0.5f;
    _99 = _69 + -0.5f;
    _100 = _70 + -0.5f;
    _110 = _61 - (floor(_61 * 0.014492753893136978f) * 69.0f);
    _111 = _62 - (floor(_62 * 0.014492753893136978f) * 69.0f);
    _112 = _63 - (floor(_63 * 0.014492753893136978f) * 69.0f);
    _124 = select((_112 > 67.5f), 0.0f, 1.0f) * (_112 + 1.0f);
    _125 = _110 + 50.0f;
    _126 = _111 + 161.0f;
    _127 = (select((_110 > 67.5f), 0.0f, 1.0f) * (_110 + 1.0f)) + 50.0f;
    _128 = (select((_111 > 67.5f), 0.0f, 1.0f) * (_111 + 1.0f)) + 161.0f;
    _129 = _125 * _125;
    _130 = _126 * _126;
    _131 = _127 * _127;
    _132 = _128 * _128;
    _133 = _131 - _129;
    _134 = _132 - _130;
    _143 = _130 * _129;
    _144 = ((_134 * _81) + _130) * ((_133 * _80) + _129);
    _145 = ((_134 * _84) + _130) * ((_133 * _83) + _129);
    _146 = _132 * _131;
    _153 = 1.0f / ((_112 * 48.500389099121094f) + 635.2987060546875f);
    _154 = 1.0f / ((_112 * 65.29412078857422f) + 682.3574829101562f);
    _155 = 1.0f / ((_112 * 63.934600830078125f) + 668.926513671875f);
    _162 = 1.0f / ((_124 * 48.500389099121094f) + 635.2987060546875f);
    _163 = 1.0f / ((_124 * 65.29412078857422f) + 682.3574829101562f);
    _164 = 1.0f / ((_124 * 63.934600830078125f) + 668.926513671875f);
    _165 = (_82 < 0.5f);
    _169 = (_85 < 0.5f);
    _197 = frac(_143 * _153) + -0.49998998641967773f;
    _198 = frac(_144 * select(_165, _153, _162)) + -0.49998998641967773f;
    _199 = frac(_145 * select(_169, _153, _162)) + -0.49998998641967773f;
    _200 = frac(_146 * _162) + -0.49998998641967773f;
    _201 = frac(_143 * _154) + -0.49998998641967773f;
    _202 = frac(_144 * select(_165, _154, _163)) + -0.49998998641967773f;
    _203 = frac(_145 * select(_169, _154, _163)) + -0.49998998641967773f;
    _204 = frac(_146 * _163) + -0.49998998641967773f;
    _205 = frac(_143 * _155) + -0.49998998641967773f;
    _206 = frac(_144 * select(_165, _155, _164)) + -0.49998998641967773f;
    _207 = frac(_145 * select(_169, _155, _164)) + -0.49998998641967773f;
    _208 = frac(_146 * _164) + -0.49998998641967773f;
    _229 = rsqrt(((_201 * _201) + (_197 * _197)) + (_205 * _205));
    _230 = rsqrt(((_202 * _202) + (_198 * _198)) + (_206 * _206));
    _231 = rsqrt(((_203 * _203) + (_199 * _199)) + (_207 * _207));
    _232 = rsqrt(((_204 * _204) + (_200 * _200)) + (_208 * _208));
    _233 = _229 * _197;
    _234 = _230 * _198;
    _235 = _231 * _199;
    _236 = _232 * _200;
    _237 = _229 * _201;
    _238 = _230 * _202;
    _239 = _231 * _203;
    _240 = _232 * _204;
    _241 = _229 * _205;
    _242 = _230 * _206;
    _243 = _231 * _207;
    _244 = _232 * _208;
    _261 = ((_233 * _68) + (_237 * _69)) + (_241 * _70);
    _262 = ((_234 * _89) + (_238 * _90)) + (_242 * _91);
    _263 = ((_235 * _95) + (_239 * _96)) + (_243 * _97);
    _264 = ((_236 * _98) + (_240 * _99)) + (_244 * _100);
    _289 = max((((0.5f - (_69 * _69)) - (_68 * _68)) - (_70 * _70)), 0.0f);
    _290 = max((((0.5f - (_89 * _89)) - (_90 * _90)) - (_91 * _91)), 0.0f);
    _291 = max((((0.5f - (_95 * _95)) - (_96 * _96)) - (_97 * _97)), 0.0f);
    _292 = max((((0.5f - (_99 * _99)) - (_98 * _98)) - (_100 * _100)), 0.0f);
    _293 = _289 * _289;
    _294 = _290 * _290;
    _295 = _291 * _291;
    _296 = _292 * _292;
    _297 = _293 * _289;
    _298 = _294 * _290;
    _299 = _295 * _291;
    _300 = _296 * _292;
    _302 = (_261 * -6.0f) * _293;
    _304 = (_262 * -6.0f) * _294;
    _306 = (_263 * -6.0f) * _295;
    _308 = (_264 * -6.0f) * _296;
    _320 = (dot(float4(_297, _298, _299, _300), float4(_233, _234, _235, _236)) + dot(float4(_302, _304, _306, _308), float4(_68, _89, _95, _98))) * 37.83722686767578f;
    _321 = (dot(float4(_297, _298, _299, _300), float4(_237, _238, _239, _240)) + dot(float4(_302, _304, _306, _308), float4(_69, _90, _96, _99))) * 37.83722686767578f;
    _329 = (((_49 * _49) * ((_31 * _30) + 0.5f)) * _49) * rsqrt(dot(float2(_320, _321), float2(_320, _321)));
    _345 = (((_320 * distort_intensity.x) * _329) + TEXCOORD.x);
    _346 = (((_321 * distort_intensity.y) * _329) + TEXCOORD.y);
    _347 = (((((_30 * 75.67445373535156f) * _44) * (dot(float4(_297, _298, _299, _300), float4(_241, _242, _243, _244)) + dot(float4(_302, _304, _306, _308), float4(_70, _91, _97, _100)))) * noise_intensity) * abs(dot(float4(_297, _298, _299, _300), float4(_261, _262, _263, _264)) * 37.83722686767578f));
  } else {
    _345 = TEXCOORD.x;
    _346 = TEXCOORD.y;
    _347 = 0.0f;
  }
  _350 = color_texture.SampleLevel(Sampler_Linear_Clamp, float2(_345, _346), 0.0f);
  _355 = bloom_texture.Sample(Sampler_Linear_Clamp, float2(TEXCOORD.x, TEXCOORD.y));
  _364 = (bloom_intensity * _355.x) + _350.x;
  _365 = (bloom_intensity * _355.y) + _350.y;
  _366 = (bloom_intensity * _355.z) + _350.z;
  // CUSTOM: Scale only the original bloom contribution.
  if (RENODX_PEAK_WHITE_NITS > 0.f) {
    _364 = ((bloom_intensity * CUSTOM_BLOOM) * _355.x) + _350.x;
    _365 = ((bloom_intensity * CUSTOM_BLOOM) * _355.y) + _350.y;
    _366 = ((bloom_intensity * CUSTOM_BLOOM) * _355.z) + _350.z;
  }
  _368 = max(_364, max(_365, _366));
  _370 = min(_364, min(_365, _366));
  _374 = _368 - _370;
  if (_368 == _364) {
    _384 = ((vibrance_filter_scale * 0.5f) * (min(1.0f, abs((_365 - _366) / _374)) + 1.0f));
  } else {
    _384 = vibrance_filter_scale;
  }
  _386 = _384 * (2.0f - _374);
  _389 = (_386 * (1.0f - _374)) + 1.0f;
  _393 = _386 * _370;
  _394 = (_389 * _364) - _393;
  _395 = (_389 * _365) - _393;
  _396 = (_389 * _366) - _393;
  _398 = dot(float3(_364, _365, _366), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f)) / dot(float3(_394, _395, _396), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  _404 = (color_filter.x * _398) * _394;
  _406 = (color_filter.y * _398) * _395;
  _408 = (color_filter.z * _398) * _396;
  _409 = dot(float3(_404, _406, _408), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  _417 = _409 + 0.0010000000474974513f;
  _455 = saturate(exp2(log2(max(0.0f, (exp2((contrast * (log2(((_404 - _409) * saturation) + _417) + 1.717856764793396f)) + -1.717856764793396f) + -0.0010000000474974513f)) / white_point) * inv_gamma_adjust.x));
  _460 = (((1.0f - _455) * lift_adjust.x) + (_455 * gain_adjust.x)) * white_point;
  _468 = saturate(exp2(log2(max(0.0f, (exp2(((log2(((_406 - _409) * saturation) + _417) + 1.717856764793396f) * contrast) + -1.717856764793396f) + -0.0010000000474974513f)) / white_point) * inv_gamma_adjust.y));
  _473 = (((1.0f - _468) * lift_adjust.y) + (_468 * gain_adjust.y)) * white_point;
  _481 = saturate(exp2(log2(max(0.0f, (exp2(((log2(((_408 - _409) * saturation) + _417) + 1.717856764793396f) * contrast) + -1.717856764793396f) + -0.0010000000474974513f)) / white_point) * inv_gamma_adjust.z));
  _486 = (((1.0f - _481) * lift_adjust.z) + (_481 * gain_adjust.z)) * white_point;
  // CUSTOM: Apply existing authored-grade controls without altering vanilla math.
  if (RENODX_PEAK_WHITE_NITS > 0.f) {
    const float3 custom_color_graded = SinkingStarApplyCustomColorGrade(
        float3(_404, _406, _408), _409, saturation, contrast, white_point,
        inv_gamma_adjust, lift_adjust, gain_adjust, float3(_460, _473, _486));
    _460 = custom_color_graded.x;
    _473 = custom_color_graded.y;
    _486 = custom_color_graded.z;
  }
  _497 = saturate(dot(float3(mad(_486, 0.024800000712275505f, mad(_473, 0.3653999865055084f, (_460 * 0.5149000287055969f))), mad(_486, 0.12479999661445618f, mad(_473, 0.6704000234603882f, (_460 * 0.32440000772476196f))), mad(_486, 0.8503999710083008f, mad(_473, 0.06419999897480011f, (_460 * 0.1606999933719635f)))), float3(-0.8050000071525574f, 1.1820000410079956f, 0.3619999885559082f)));
  _502 = 1.0f - saturate(_497 / scotopic_vision_max_luminance);
  _505 = (_502 * _502) * scotopic_vision_scale;
  _511 = rsqrt(dot(float3(scotopic_vision_color.x, scotopic_vision_color.y, scotopic_vision_color.z), float3(scotopic_vision_color.x, scotopic_vision_color.y, scotopic_vision_color.z))) * _497;
  _521 = (((_511 * scotopic_vision_color.x) - _460) * _505) + _460;
  _522 = (((_511 * scotopic_vision_color.y) - _473) * _505) + _473;
  _523 = (((_511 * scotopic_vision_color.z) - _486) * _505) + _486;
  if (_45) {
    _540 = (_30 + 0.5f) * undo_effect_t_smooth;
    _542 = (exp2(((-0.0f - _347) - (((_44 * (1.0f - undo_effect_t_smooth)) * pulse_intensity) * cos((_30 + undo_effect_t_smooth) * 12.566370964050293f))) * 1.4426950216293335f) * 0.699999988079071f) * dot(float3(_521, _522, _523), float3(0.2989000082015991f, 0.5866000056266785f, 0.1145000010728836f));
    _553 = (lerp(_521, _542, _540));
    _554 = (lerp(_522, _542, _540));
    _555 = (lerp(_523, _542, _540));
  } else {
    _553 = _521;
    _554 = _522;
    _555 = _523;
  }
  _557 = _553 * to_target_curve_scale;
  _558 = _554 * to_target_curve_scale;
  _559 = _555 * to_target_curve_scale;
  if (tone_mapper_curve == 0.0f) {
    _563 = dot(float3(_557, _558, _559), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
    _564 = _563 * 0.15000000596046448f;
    _575 = ((((((_564 + 0.05000000074505806f) * _563) + 0.0020000000949949026f) / (((_564 + 0.5f) * _563) + 0.06000000238418579f)) + -0.03333333134651184f) * 1.6641758680343628f) / max(_563, 0.0010000000474974513f);
    _763 = (_575 * _557);
    _764 = (_575 * _558);
    _765 = (_575 * _559);
  } else {
    if (tone_mapper_curve == 3.0f) {
      _582 = _559 * 0.15000000596046448f;
      _592 = _558 * 0.15000000596046448f;
      _602 = _557 * 0.15000000596046448f;
      _763 = ((((((_602 + 0.05000000074505806f) * _557) + 0.0020000000949949026f) / (((_602 + 0.5f) * _557) + 0.06000000238418579f)) + -0.03333333134651184f) * 1.6641758680343628f);
      _764 = ((((((_592 + 0.05000000074505806f) * _558) + 0.0020000000949949026f) / (((_592 + 0.5f) * _558) + 0.06000000238418579f)) + -0.03333333134651184f) * 1.6641758680343628f);
      _765 = ((((((_582 + 0.05000000074505806f) * _559) + 0.0020000000949949026f) / (((_582 + 0.5f) * _559) + 0.06000000238418579f)) + -0.03333333134651184f) * 1.6641758680343628f);
    } else {
      if (tone_mapper_curve == 4.0f) {
        _763 = saturate((((_557 * 2.509999990463257f) + 0.029999999329447746f) * _557) / ((((_557 * 2.430000066757202f) + 0.5899999737739563f) * _557) + 0.14000000059604645f));
        _764 = saturate((((_558 * 2.509999990463257f) + 0.029999999329447746f) * _558) / ((((_558 * 2.430000066757202f) + 0.5899999737739563f) * _558) + 0.14000000059604645f));
        _765 = saturate((((_559 * 2.509999990463257f) + 0.029999999329447746f) * _559) / ((((_559 * 2.430000066757202f) + 0.5899999737739563f) * _559) + 0.14000000059604645f));
      } else {
        if (tone_mapper_curve == 1.0f) {
          _645 = dot(float3(_557, _558, _559), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
          _656 = saturate((((_645 * 2.509999990463257f) + 0.029999999329447746f) * _645) / ((((_645 * 2.430000066757202f) + 0.5899999737739563f) * _645) + 0.14000000059604645f)) / max(_645, 0.0010000000474974513f);
          _763 = (_656 * _557);
          _764 = (_656 * _558);
          _765 = (_656 * _559);
        } else {
          if (tone_mapper_curve == 5.0f) {
            _663 = _557 * 0.6000000238418579f;
            _664 = _558 * 0.6000000238418579f;
            _665 = _559 * 0.6000000238418579f;
            _763 = saturate((((_557 * 1.50600004196167f) + 0.029999999329447746f) * _663) / ((((_557 * 1.4580000638961792f) + 0.5899999737739563f) * _663) + 0.14000000059604645f));
            _764 = saturate((((_558 * 1.50600004196167f) + 0.029999999329447746f) * _664) / ((((_558 * 1.4580000638961792f) + 0.5899999737739563f) * _664) + 0.14000000059604645f));
            _765 = saturate((((_559 * 1.50600004196167f) + 0.029999999329447746f) * _665) / ((((_559 * 1.4580000638961792f) + 0.5899999737739563f) * _665) + 0.14000000059604645f));
          } else {
            if (tone_mapper_curve == 2.0f) {
              _696 = _557 * 0.6000000238418579f;
              _697 = _558 * 0.6000000238418579f;
              _698 = _559 * 0.6000000238418579f;
              _699 = dot(float3(_696, _697, _698), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
              _710 = saturate((((_699 * 2.509999990463257f) + 0.029999999329447746f) * _699) / ((((_699 * 2.430000066757202f) + 0.5899999737739563f) * _699) + 0.14000000059604645f)) / max(_699, 0.0010000000474974513f);
              _763 = (_710 * _696);
              _764 = (_710 * _697);
              _765 = (_710 * _698);
            } else {
              if (tone_mapper_curve == 6.0f) {
                _719 = mad(0.04822999984025955f, _559, mad(0.35457998514175415f, _558, (_557 * 0.5971900224685669f)));
                _722 = mad(0.01565999910235405f, _559, mad(0.9083399772644043f, _558, (_557 * 0.07599999755620956f)));
                _725 = mad(0.8377699851989746f, _559, mad(0.1338299959897995f, _558, (_557 * 0.0284000001847744f)));
                _747 = (((_719 + 0.024578599259257317f) * _719) + -9.053700341610238e-05f) / ((((_719 * 0.9837290048599243f) + 0.4329510033130646f) * _719) + 0.23808099329471588f);
                _748 = (((_722 + 0.024578599259257317f) * _722) + -9.053700341610238e-05f) / ((((_722 * 0.9837290048599243f) + 0.4329510033130646f) * _722) + 0.23808099329471588f);
                _749 = (((_725 + 0.024578599259257317f) * _725) + -9.053700341610238e-05f) / ((((_725 * 0.9837290048599243f) + 0.4329510033130646f) * _725) + 0.23808099329471588f);
                _763 = saturate(mad(-0.07366999983787537f, _749, mad(-0.5310800075531006f, _748, (_747 * 1.6047500371932983f))));
                _764 = saturate(mad(-0.006049999967217445f, _749, mad(1.1081299781799316f, _748, (_747 * -0.10208000242710114f))));
                _765 = saturate(mad(1.0760200023651123f, _749, mad(-0.07276000082492828f, _748, (_747 * -0.003269999986514449f))));
              } else {
                _763 = _557;
                _764 = _558;
                _765 = _559;
              }
            }
          }
        }
      }
    }
  }
  SV_Target.x = _763;
  SV_Target.y = _764;
  SV_Target.z = _765;
  SV_Target.w = 1.0f;
  // CUSTOM: Preserve the existing HDR dispatch and intermediate output contract.
  if (RENODX_PEAK_WHITE_NITS > 0.f) {
    if (RENODX_TONE_MAP_TYPE != RENODX_TONE_MAP_TYPE_VANILLA) {
      const float3 custom_untonemapped = float3(_557, _558, _559);
      const float3 custom_vanilla = saturate(SV_Target.rgb);
      if (RENODX_TONE_MAP_TYPE == RENODX_TONE_MAP_TYPE_NEUTWO
          || RENODX_TONE_MAP_TYPE == RENODX_TONE_MAP_TYPE_PSYCHOV17
          || RENODX_TONE_MAP_TYPE == RENODX_TONE_MAP_TYPE_PSYCHOV30) {
        const SinkingStarVanillaToneMapReference custom_reference = SinkingStarResolveVanillaToneMapReference(
            tone_mapper_curve, RENODX_TONE_MAP_TYPE == RENODX_TONE_MAP_TYPE_NEUTWO);
        if (RENODX_TONE_MAP_TYPE == RENODX_TONE_MAP_TYPE_PSYCHOV17) {
          SV_Target.rgb = SinkingStarApplyPsychoV17(custom_untonemapped, custom_reference, tone_mapper_curve);
        } else if (RENODX_TONE_MAP_TYPE == RENODX_TONE_MAP_TYPE_PSYCHOV30) {
          SV_Target.rgb = SinkingStarApplyPsychoV30(custom_untonemapped, custom_reference, tone_mapper_curve);
        } else {
          SV_Target.rgb = renodx::draw::ToneMapPass(SinkingStarApplyVanillaToneMapExtended(
              custom_untonemapped, custom_vanilla, tone_mapper_curve, custom_reference));
        }
#ifndef NDEBUG
        if (CUSTOM_DEBUG_CANVAS) {
          SV_Target.rgb = SinkingStarDrawPsychoVDebugCanvas(
              SV_Target.rgb, SV_Position.xy, tone_mapper_curve, RENODX_TONE_MAP_TYPE, custom_reference);
        }
#endif
      } else {
        SV_Target.rgb = custom_vanilla;
      }
    } else {
      // CUSTOM: Emulate the original UNORM write after the resource upgrade.
      SV_Target.rgb = saturate(SV_Target.rgb);
    }
    SV_Target.rgb = renodx::draw::RenderIntermediatePass(SV_Target.rgb);
  }
  return SV_Target;
}
