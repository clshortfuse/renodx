Texture2D<float4> __tex_linear_depth : register(t0);

Texture3D<float4> __tex_fog_volume : register(t1);

TextureCube<float4> __tex_global_diffuse_map : register(t2);

Texture2D<float> average_luminance : register(t3);

cbuffer global_viewport : register(b0) {
  float3 camera_unprojection : packoffset(c000.x);
  float3 camera_pos : packoffset(c001.x);
  float4 camera_view[4] : packoffset(c002.x);
  float4 camera_inv_view[4] : packoffset(c006.x);
  float4 camera_world[4] : packoffset(c010.x);
  float4 camera_last_world[4] : packoffset(c014.x);
  float4 camera_last_view[4] : packoffset(c018.x);
  float4 camera_last_inv_view[4] : packoffset(c022.x);
  float4 camera_projection[4][2] : packoffset(c026.x);
  float4 camera_inv_projection[4][2] : packoffset(c034.x);
  float4 camera_last_projection[4][2] : packoffset(c042.x);
  float4 camera_last_inv_projection[4][2] : packoffset(c050.x);
  float4 camera_last_view_projection[4][2] : packoffset(c058.x);
  float4 camera_last_inv_view_projection[4][2] : packoffset(c066.x);
  float4 camera_view_projection[4][2] : packoffset(c074.x);
  float4 camera_inv_view_projection[4][2] : packoffset(c082.x);
  float time : packoffset(c090.x);
  float delta_time : packoffset(c090.y);
  float2 streamer_write_feedback_threshold : packoffset(c090.z);
  float2 sampler_lod_bias : packoffset(c091.x);
  float frame_number : packoffset(c091.z);
  float2 back_buffer_size : packoffset(c092.x);
  float2 output_rt_size : packoffset(c092.z);
  float4 hdr_content_to_monitor_rec[4] : packoffset(c093.x);
  float taa_enabled : packoffset(c097.x);
  float jitter_enabled : packoffset(c097.y);
  float upscaling_enabled : packoffset(c097.z);
  float debug_rendering : packoffset(c097.w);
  float gamma : packoffset(c098.x);
  float lens_quality_color_fringe_enabled : packoffset(c098.y);
  float lens_quality_distortion_enabled : packoffset(c098.z);
  float volumetric_reprojection_amount : packoffset(c098.w);
  float volumetric_volumes_enabled : packoffset(c099.x);
  float sun_shadows : packoffset(c099.y);
  float capture_cubemap : packoffset(c099.z);
  float capture_ddgi : packoffset(c099.w);
  float hair_wrapped_diffuse : packoffset(c100.x);
  float4 viewport : packoffset(c101.x);
  float is_editor : packoffset(c102.x);
  float2 mouse_uv : packoffset(c102.y);
  float rt_reflections_enabled : packoffset(c102.w);
  float rt_particle_reflections_enabled : packoffset(c103.x);
  float rt_relax_denoiser_enabled : packoffset(c103.y);
  float dlss_rr_enabled : packoffset(c103.z);
  float gtao_enabled : packoffset(c103.w);
  float cacao_enabled : packoffset(c104.x);
  float rt_mixed_reflections : packoffset(c104.y);
  float rt_shadow_ray_multiplier : packoffset(c104.z);
  float rtxgi_enabled : packoffset(c104.w);
  float baked_ddgi : packoffset(c105.x);
  float dxr : packoffset(c105.y);
  float rt_checkerboard_reflections : packoffset(c105.z);
  float3 camera_near_far : packoffset(c106.x);
  float direct_diffuse_enabled : packoffset(c106.w);
  float direct_specular_enabled : packoffset(c107.x);
  float indirect_diffuse_enabled : packoffset(c107.y);
  float indirect_specular_enabled : packoffset(c107.z);
  float occlusion_debug_opacity : packoffset(c107.w);
  float occlusion_debug_far : packoffset(c108.x);
  float occlusion_debug_near : packoffset(c108.y);
  float occluder_debug_opacity : packoffset(c108.z);
  float occluder_debug_far : packoffset(c108.w);
  float hdr_paper_white_nits : packoffset(c109.x);
  float debug_hdr_compare : packoffset(c109.y);
  float reverse_z : packoffset(c109.z);
  float terrain_displacement_min_distance : packoffset(c109.w);
  float terrain_displacement_max_distance : packoffset(c110.x);
  float terrain_tesselation_min_distance : packoffset(c110.y);
  float terrain_tesselation_max_distance : packoffset(c110.z);
};

cbuffer global_environment_settings : register(b1) {
  float minion_rimlight : packoffset(c000.x);
  float minion_glowing_eyes : packoffset(c000.y);
  float minion_environment_mask : packoffset(c000.z);
  float emissive_intensity : packoffset(c000.w);
  float global_roughness_multiplier : packoffset(c001.x);
  float metallic_roughness_multiplier : packoffset(c001.y);
  float non_metallic_roughness_multiplier : packoffset(c001.z);
  float global_reflectance_multiplier : packoffset(c001.w);
  float reflection_boost : packoffset(c002.x);
  float reflection_smooth_bias : packoffset(c002.y);
  float ambient_enabled : packoffset(c002.z);
  float3 global_ambient_tint : packoffset(c003.x);
  float3 local_ambient_tint : packoffset(c004.x);
  float ambient_depth_occlusion_enabled : packoffset(c004.w);
  float ambient_normal_weight_enabled : packoffset(c005.x);
  float2 specular_ao_intensity : packoffset(c005.y);
  float specular_ao_horizon_occlusion : packoffset(c005.w);
  float sun_enabled : packoffset(c006.x);
  float3 sun_direction : packoffset(c006.y);
  float3 sun_color : packoffset(c007.x);
  float sun_disk_enabled : packoffset(c007.w);
  float sun_disk_size : packoffset(c008.x);
  float3 local_shadow_map_bias : packoffset(c008.y);
  float3 sun_shadow_map_bias : packoffset(c009.x);
  float3 ssm_shadow_map_bias : packoffset(c010.x);
  float sun_shadows_enabled : packoffset(c010.w);
  float ssm_enabled : packoffset(c011.x);
  float skydome_u_offset : packoffset(c011.y);
  float skydome_intensity : packoffset(c011.z);
  float3 skydome_tint_color : packoffset(c012.x);
  float3 skydome_flow_direction : packoffset(c013.x);
  float skydome_flow_speed : packoffset(c013.w);
  float skydome_flow_tiling : packoffset(c014.x);
  float2 skydome_cloud_speed_scale : packoffset(c014.y);
  float3 wind_amount : packoffset(c015.x);
  float eye_intensity : packoffset(c015.w);
  float fog_enabled : packoffset(c016.x);
  float3 fog_color : packoffset(c016.y);
  float3 fog0_settings : packoffset(c017.x);
  float3 fog1_settings : packoffset(c018.x);
  float2 skydome_fog_height_falloff : packoffset(c019.x);
  float volumetric_lighting_enabled : packoffset(c019.z);
  float volumetric_global_light_multiplier : packoffset(c019.w);
  float volumetric_local_light_multiplier : packoffset(c020.x);
  float volumetric_distance : packoffset(c020.y);
  float volumetric_phase : packoffset(c020.z);
  float volumetric_extinction : packoffset(c020.w);
  float volumetric_ambient_multiplier : packoffset(c021.x);
  float world_interaction_window_size : packoffset(c021.y);
  float world_interaction_water_window_size : packoffset(c021.z);
  float tonemap_use_custom : packoffset(c021.w);
  float tonemap_slope : packoffset(c022.x);
  float tonemap_toe : packoffset(c022.y);
  float tonemap_shoulder : packoffset(c022.z);
  float tonemap_black_clip : packoffset(c022.w);
  float tonemap_white_clip : packoffset(c023.x);
  float pathtraced_accumulation_frames : packoffset(c023.y);
  float4 ies_atlas_size : packoffset(c024.x);
};

cbuffer c0 : register(b2) {
  float4 world_view_proj[4] : packoffset(c000.x);
  float2 output_target_size : packoffset(c004.x);
  float exposure : packoffset(c004.z);
  float exposure_auto_enabled : packoffset(c004.w);
  float exposure_compensation : packoffset(c005.x);
};

SamplerState __samp_linear_depth : register(s0);

SamplerState __samp_fog_volume : register(s1);

SamplerState __samp_global_diffuse_map : register(s2);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float GetLuminance(float3 color) {
  return dot(color, float3(0.2126999944448471f, 0.7152000069618225f, 0.07209999859333038f));
}

float3 RestoreFogHueAndChrominance(float3 fog_color_input, float3 reference_color) {
  static const float FOG_HUE_RESTORE_STRENGTH = 0.75f;
  static const float FOG_CHROMA_RESTORE_STRENGTH = 0.90f;

  float fog_luminance = max(GetLuminance(fog_color_input), 6.0999998822808266e-05f);
  float reference_luminance = max(GetLuminance(reference_color), 6.0999998822808266e-05f);
  float3 fog_normalized = fog_color_input / fog_luminance;
  float3 reference_normalized = reference_color / reference_luminance;

  float reference_chrominance = saturate(length(reference_normalized - 1.0f.xxx) * 0.5f);
  float3 restored_normalized = lerp(fog_normalized, reference_normalized, FOG_HUE_RESTORE_STRENGTH * reference_chrominance);
  float restored_luminance = max(GetLuminance(restored_normalized), 6.0999998822808266e-05f);
  restored_normalized /= restored_luminance;

  float3 restored_color = fog_luminance * restored_normalized;
  return lerp(fog_color_input, restored_color, FOG_CHROMA_RESTORE_STRENGTH);
}

float4 main(
  precise noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD,
  linear float4 TEXCOORD_1 : TEXCOORD1
) : SV_Target {
  float4 SV_Target;
  int _17;
  float _19;
  bool _23;
  float _32;
  float _33;
  float _34;
  float _35;
  float _41;
  float _92;
  float _474;
  float _475;
  float _476;
  float _477;
  float4 _50;
  float _55;
  float _60;
  float _61;
  float _62;
  float _66;
  float _72;
  float _80;
  float _82;
  float _84;
  float _93;
  float _94;
  float _110;
  float _112;
  float _114;
  float _116;
  float _117;
  float _118;
  float _119;
  float _120;
  float _124;
  float _128;
  float _146;
  float _161;
  float _171;
  float _180;
  float _181;
  float4 _185;
  float _215;
  float _216;
  float _217;
  float _218;
  float _220;
  bool _221;
  float _237;
  float _241;
  float _251;
  float _253;
  bool _254;
  float _270;
  float _274;
  float _284;
  float _286;
  bool _287;
  float _303;
  float _305;
  float _315;
  float _318;
  bool _319;
  float _349;
  float _358;
  float _361;
  float _362;
  float _364;
  float _365;
  float _366;
  float _367;
  float _386;
  float _401;
  float _411;
  float _420;
  float _421;
  float4 _425;
  float _455;
  float _456;
  float _457;
  float _460;
  bool _461;
  float _491;
  bool _492;
  uint _495;
  uint _504;
  uint _508;
  uint _511;
  float _517;
  float _518;
  float _519;
  float _520;
  float _523;
  float _537;
  float _550;
  float _551;
  float _552;
  float _556;
  float3 _fog_reference_color;
  _17 = asint((((float4)(__tex_linear_depth.Sample(__samp_linear_depth, float2(TEXCOORD.x, TEXCOORD.y)))).x));
  _19 = asfloat((_17 & 2147483647));
  _23 = ((int)(uint(float((uint)((uint)((uint)(_17) >> 31))))) == 0);
  _32 = select(_23, TEXCOORD_1.x, TEXCOORD_1.x);
  _33 = select(_23, TEXCOORD_1.y, TEXCOORD_1.y);
  _34 = select(_23, TEXCOORD_1.z, TEXCOORD_1.z);
  _35 = select(_23, TEXCOORD_1.w, TEXCOORD_1.w);
  _41 = _19 - camera_near_far.x;
  _fog_reference_color = max(fog_color * max(global_ambient_tint, 0.0f.xxx), 0.0f.xxx);
  if (volumetric_lighting_enabled != 0.0f) {
    _50 = __tex_fog_volume.SampleLevel(__samp_fog_volume, float3(TEXCOORD.x, TEXCOORD.y, ((log2(_41) * 0.6931471824645996f) / (log2(volumetric_distance) * 0.6931471824645996f))), 0.0f);
    _55 = volumetric_distance + camera_near_far.x;
    [branch]
    if (_19 > _55) {
      _60 = _34 / _35;
      _61 = _60 * _19;
      _62 = _60 * _55;
      if (volumetric_extinction == 0.0f) {
        _66 = camera_pos.z + _62;
        _72 = max(fog0_settings.y, fog1_settings.y);
        if (((camera_pos.z + _61) > _72) && (_66 < _72)) {
          _80 = (_32 / _35) * (_19 - _55);
          _82 = (_33 / _35) * (_19 - _55);
          _84 = _60 * (_19 - _55);
          _92 = (((_72 - _66) / (rsqrt(dot(float3(_80, _82, _84), float3(_80, _82, _84))) * _84)) + _55);
        } else {
          _92 = _19;
        }
      } else {
        _92 = _19;
      }
      _93 = _92 - _55;
      _94 = 1.0f - _50.w;
      _110 = ((camera_world[0].w) - ((_32 / _35) * _19)) - camera_pos.x;
      _112 = ((camera_world[1].w) - ((_33 / _35) * _19)) - camera_pos.y;
      _114 = ((camera_world[2].w) - _61) - camera_pos.z;
      _116 = rsqrt(dot(float3(_110, _112, _114), float3(_110, _112, _114)));
      _117 = _110 * _116;
      _118 = _112 * _116;
      _119 = _114 * _116;
      _120 = camera_pos.z + _62;
      _124 = ((_60 * (_55 + 1.0f)) - _120) + camera_pos.z;
      _128 = (_124 * ((_93 * 0.1666666716337204f) + _55)) + _120;
      _146 = ((max(((fog0_settings.y - _128) / fog0_settings.z), 0.0f) * fog0_settings.x) + volumetric_extinction) + (max(((fog1_settings.y - _128) / fog1_settings.z), 0.0f) * fog1_settings.x);
      _161 = volumetric_phase * volumetric_phase;
      _171 = ((1.0f - _161) / exp2(log2((_161 + 1.0f) - ((volumetric_phase * 2.0f) * dot(float3(sun_direction.x, sun_direction.y, sun_direction.z), float3(_117, _118, _119)))) * 1.5f)) * 0.07957746833562851f;
      _180 = (1.0f - capture_cubemap) * ambient_enabled;
      _181 = -0.0f - volumetric_phase;
      _185 = __tex_global_diffuse_map.SampleLevel(__samp_global_diffuse_map, float3((_117 * _181), (_118 * _181), (_119 * _181)), 0.0f);
      _fog_reference_color = max(((_185.xyz * _180) * global_ambient_tint) + ((sun_color * sun_enabled) * _171), 0.0f.xxx) * max(fog_color, 0.0f.xxx);
      _215 = ((((_185.x * _180) * global_ambient_tint.x) * volumetric_ambient_multiplier) + (((sun_color.x * sun_enabled) * _171) * volumetric_global_light_multiplier)) * fog_color.x;
      _216 = ((((_185.y * _180) * global_ambient_tint.y) * volumetric_ambient_multiplier) + (((sun_color.y * sun_enabled) * _171) * volumetric_global_light_multiplier)) * fog_color.y;
      _217 = ((((_185.z * _180) * global_ambient_tint.z) * volumetric_ambient_multiplier) + (((sun_color.z * sun_enabled) * _171) * volumetric_global_light_multiplier)) * fog_color.z;
      _218 = _93 * -0.48089835047721863f;
      _220 = exp2(_218 * _146);
      _221 = (_146 < 3.000000106112566e-07f);
      _237 = _220 * _94;
      _241 = (_124 * ((_93 * 0.5f) + _55)) + _120;
      _251 = ((max(((fog0_settings.y - _241) / fog0_settings.z), 0.0f) * fog0_settings.x) + volumetric_extinction) + (max(((fog1_settings.y - _241) / fog1_settings.z), 0.0f) * fog1_settings.x);
      _253 = exp2(_218 * _251);
      _254 = (_251 < 3.000000106112566e-07f);
      _270 = _253 * _237;
      _274 = (_124 * ((_93 * 0.8333333134651184f) + _55)) + _120;
      _284 = ((max(((fog0_settings.y - _274) / fog0_settings.z), 0.0f) * fog0_settings.x) + volumetric_extinction) + (max(((fog1_settings.y - _274) / fog1_settings.z), 0.0f) * fog1_settings.x);
      _286 = exp2(_218 * _284);
      _287 = (_284 < 3.000000106112566e-07f);
      _303 = _286 * _270;
      _305 = camera_pos.z + (_60 * _92);
      _315 = ((max(((fog0_settings.y - _305) / fog0_settings.z), 0.0f) * fog0_settings.x) + volumetric_extinction) + (max(((fog1_settings.y - _305) / fog1_settings.z), 0.0f) * fog1_settings.x);
      _318 = exp2((_93 * -0.48089832067489624f) * _315);
      _319 = (_315 < 3.000000106112566e-07f);
      _474 = (((((select(_221, 0.0f, (_215 - (_215 * _220))) * _94) + _50.x) + (select(_254, 0.0f, (_215 - (_215 * _253))) * _237)) + (select(_287, 0.0f, (_215 - (_215 * _286))) * _270)) + (select(_319, 0.0f, (_215 - (_215 * _318))) * _303));
      _475 = (((((select(_221, 0.0f, (_216 - (_216 * _220))) * _94) + _50.y) + (select(_254, 0.0f, (_216 - (_216 * _253))) * _237)) + (select(_287, 0.0f, (_216 - (_216 * _286))) * _270)) + (select(_319, 0.0f, (_216 - (_216 * _318))) * _303));
      _476 = (((((select(_221, 0.0f, (_217 - (_217 * _220))) * _94) + _50.z) + (select(_254, 0.0f, (_217 - (_217 * _253))) * _237)) + (select(_287, 0.0f, (_217 - (_217 * _286))) * _270)) + (select(_319, 0.0f, (_217 - (_217 * _318))) * _303));
      _477 = saturate(1.0f - (_318 * _303));
    } else {
      _474 = _50.x;
      _475 = _50.y;
      _476 = _50.z;
      _477 = _50.w;
    }
  } else {
    _349 = camera_pos.z + ((_34 / _35) * _19);
    _358 = ((-0.0f - ((_32 / _35) * _19)) - camera_pos.x) + (camera_world[0].w);
    _361 = ((-0.0f - ((_33 / _35) * _19)) - camera_pos.y) + (camera_world[1].w);
    _362 = (camera_world[2].w) - _349;
    _364 = rsqrt(dot(float3(_358, _361, _362), float3(_358, _361, _362)));
    _365 = _364 * _358;
    _366 = _364 * _361;
    _367 = _362 * _364;
    _386 = ((max(((fog0_settings.y - _349) / fog0_settings.z), 0.0f) * fog0_settings.x) + volumetric_extinction) + (max(((fog1_settings.y - _349) / fog1_settings.z), 0.0f) * fog1_settings.x);
    _401 = volumetric_phase * volumetric_phase;
    _411 = ((1.0f - _401) / exp2(log2((_401 + 1.0f) - ((volumetric_phase * 2.0f) * dot(float3(sun_direction.x, sun_direction.y, sun_direction.z), float3(_365, _366, _367)))) * 1.5f)) * 0.07957746833562851f;
    _420 = (1.0f - capture_cubemap) * ambient_enabled;
    _421 = -0.0f - volumetric_phase;
    _425 = __tex_global_diffuse_map.SampleLevel(__samp_global_diffuse_map, float3((_365 * _421), (_366 * _421), (_367 * _421)), 0.0f);
    _fog_reference_color = max(((_425.xyz * _420) * global_ambient_tint) + ((sun_color * sun_enabled) * _411), 0.0f.xxx) * max(fog_color, 0.0f.xxx);
    _455 = ((((_425.x * _420) * global_ambient_tint.x) * volumetric_ambient_multiplier) + (((sun_color.x * sun_enabled) * _411) * volumetric_global_light_multiplier)) * fog_color.x;
    _456 = ((((_425.y * _420) * global_ambient_tint.y) * volumetric_ambient_multiplier) + (((sun_color.y * sun_enabled) * _411) * volumetric_global_light_multiplier)) * fog_color.y;
    _457 = ((((_425.z * _420) * global_ambient_tint.z) * volumetric_ambient_multiplier) + (((sun_color.z * sun_enabled) * _411) * volumetric_global_light_multiplier)) * fog_color.z;
    _460 = exp2((_41 * -1.4426950216293335f) * _386);
    _461 = (_386 < 3.000000106112566e-07f);
    _474 = select(_461, 0.0f, (_455 - (_455 * _460)));
    _475 = select(_461, 0.0f, (_456 - (_456 * _460)));
    _476 = select(_461, 0.0f, (_457 - (_457 * _460)));
    _477 = saturate(1.0f - _460);
  }
  _491 = select((exposure_auto_enabled != 0.0f), (0.8333333134651184f / exp2(((average_luminance.Load(int3(0, 0, 0))).x) - exposure_compensation)), (exp2(exposure_compensation) * exposure));
  _492 = (_491 == 0.0f);
  // float3 _fog_restored_color = RestoreFogHueAndChrominance(float3(_474, _475, _476), _fog_reference_color);
  // _474 = _fog_restored_color.x;
  // _475 = _fog_restored_color.y;
  // _476 = _fog_restored_color.z;
  _495 = uint(SV_Position.x);
  _504 = (((int)(((int)(uint(frame_number + 1.0f)) * _495) + uint(output_target_size.x))) * (int)(uint(SV_Position.y))) + _495;
  _508 = ((_504 ^ 61) ^ ((uint)(_504) >> 16)) * 9;
  _511 = (((uint)(_508) >> 4) ^ _508) * 668265261;
  _517 = 1.0f / gamma;
  _518 = _491 * _474;
  _519 = _491 * _475;
  _520 = _491 * _476;
  _523 = max(dot(float3(_518, _519, _520), float3(0.2126999944448471f, 0.7152000069618225f, 0.07209999859333038f)), 6.0999998822808266e-05f) + 1.0f;
  _537 = (float((uint)((uint)(((uint)(_511) >> 15) ^ _511))) * 1.826122586479073e-12f) + -0.003921568393707275f;
  _550 = exp2(log2(max((_537 + exp2(log2(_518 / _523) * _517)), 0.0f)) * gamma);
  _551 = exp2(log2(max((_537 + exp2(log2(_519 / _523) * _517)), 0.0f)) * gamma);
  _552 = exp2(log2(max((_537 + exp2(log2(_520 / _523) * _517)), 0.0f)) * gamma);
  _556 = max((1.0f - dot(float3(_550, _551, _552), float3(0.2126999944448471f, 0.7152000069618225f, 0.07209999859333038f))), 6.0999998822808266e-05f) * _491;
  SV_Target.x = select(_492, _474, (_550 / _556));
  SV_Target.y = select(_492, _475, (_551 / _556));
  SV_Target.z = select(_492, _476, (_552 / _556));
  SV_Target.w = _477;
  return SV_Target;
}