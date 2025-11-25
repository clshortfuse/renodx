#include "./common.hlsl"

Texture2D<float4> __tex_input_texture0 : register(t0);

Texture2D<float4> __tex_input_texture3 : register(t1);

Texture3D<float4> __tex_virtual_color_grading : register(t2);

Texture2D<float> current_exposure : register(t3);

Texture2D<float4> __tex_input_texture1 : register(t4);

Texture2D<float4> __tex_linear_depth : register(t5);

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
  float3 bloom_threshold_offset_falloff : packoffset(c004.x);
  float3 vignette_scale_falloff_opacity : packoffset(c005.x);
  float3 vignette_color : packoffset(c006.x);
  float bloom_enabled : packoffset(c006.w);
  float bloom_glare_enabled : packoffset(c007.x);
  float2 bloom_glare_settings : packoffset(c007.y);
  float light_shafts_enabled : packoffset(c007.w);
  float sun_flare_enabled : packoffset(c008.x);
  float tone_mapping_enabled : packoffset(c008.y);
  float amd_lpm_tone_mapping_enabled : packoffset(c008.z);
  float vignette_enabled : packoffset(c008.w);
  float color_grading_enabled : packoffset(c009.x);
  float grey_scale_enabled : packoffset(c009.y);
  float grey_scale_amount : packoffset(c009.z);
  float3 grey_scale_weights : packoffset(c010.x);
  float mirror_uv : packoffset(c010.w);
  float color_filter_enabled : packoffset(c011.x);
  float4 color_filter_opacity : packoffset(c012.x);
  float2 input_texture1_size : packoffset(c013.x);
  uint4 amd_lpm[24] : packoffset(c014.x);
};

SamplerState __samp_input_texture0 : register(s0);

SamplerState __samp_input_texture3 : register(s1);

SamplerState __samp_virtual_color_grading : register(s2);

SamplerState __samp_input_texture1 : register(s3);

SamplerState __samp_linear_depth : register(s4);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD,
  linear float4 TEXCOORD_1 : TEXCOORD1
) : SV_Target {
  float4 SV_Target;
  float4 _17 = __tex_input_texture0.Sample(__samp_input_texture0, float2(TEXCOORD.x, TEXCOORD.y));
  float _22 = current_exposure.Load(int3(0, 0, 0));
  float _24 = _22.x * _17.x;
  float _25 = _22.x * _17.y;
  float _26 = _22.x * _17.z;
  float3 untonemapped_bt709 = float3(_24, _25, _26);  // After exposure

  float _287;
  float _288;
  float _289;
  float _613;
  float _646;
  float _660;
  float _717;
  float _872;
  float _873;
  float _874;
  float _949;
  float _950;
  float _951;
  float _973;
  float _974;
  float _975;
  float _1002;
  float _1003;
  float _1004;
  [branch]
  if (!(bloom_glare_enabled == 0.0f)) {
    float4 _31 = __tex_linear_depth.Sample(__samp_linear_depth, float2(TEXCOORD.x, TEXCOORD.y));
    int _33 = asint(_31.x);
    float _35 = asfloat((_33 & 2147483647));
    bool _39 = ((uint)(uint(float((uint)((int)((uint)(_33) >> 31))))) == 0);
    float _51 = select(_39, TEXCOORD_1.w, TEXCOORD_1.w);
    float _78 = (camera_pos.x + ((select(_39, TEXCOORD_1.x, TEXCOORD_1.x) / _51) * _35)) - (((camera_world[0].y) * _35) * bloom_glare_settings.y);
    float _79 = (camera_pos.y + ((select(_39, TEXCOORD_1.y, TEXCOORD_1.y) / _51) * _35)) - (((camera_world[1].y) * _35) * bloom_glare_settings.y);
    float _80 = (camera_pos.z + ((select(_39, TEXCOORD_1.z, TEXCOORD_1.z) / _51) * _35)) - (((camera_world[2].y) * _35) * bloom_glare_settings.y);
    float _134 = mad(_80, select(_39, (camera_view_projection[1][1].z), (camera_view_projection[3][1].z)), mad(_79, select(_39, (camera_view_projection[1][1].y), (camera_view_projection[3][1].y)), (select(_39, (camera_view_projection[1][1].x), (camera_view_projection[3][1].x)) * _78))) + select(_39, (camera_view_projection[1][1].w), (camera_view_projection[3][1].w));
    float _137 = ((mad(_80, select(_39, (camera_view_projection[0][0].z), (camera_view_projection[2][0].z)), mad(_79, select(_39, (camera_view_projection[0][0].y), (camera_view_projection[2][0].y)), (select(_39, (camera_view_projection[0][0].x), (camera_view_projection[2][0].x)) * _78))) + select(_39, (camera_view_projection[0][0].w), (camera_view_projection[2][0].w))) / _134) * 0.5f;
    float _138 = ((mad(_80, select(_39, (camera_view_projection[0][1].z), (camera_view_projection[2][1].z)), mad(_79, select(_39, (camera_view_projection[0][1].y), (camera_view_projection[2][1].y)), (select(_39, (camera_view_projection[0][1].x), (camera_view_projection[2][1].x)) * _78))) + select(_39, (camera_view_projection[0][1].w), (camera_view_projection[2][1].w))) / _134) * -0.5f;
    float _144 = input_texture1_size.x * (_137 + 0.5f);
    float _145 = (_138 + 0.5f) * input_texture1_size.y;
    float _146 = 1.0f / input_texture1_size.x;
    float _147 = 1.0f / input_texture1_size.y;
    float _150 = floor(_144 + -0.5f);
    float _151 = floor(_145 + -0.5f);
    float _154 = _144 - (_150 + 0.5f);
    float _155 = _145 - (_151 + 0.5f);
    float _156 = _154 * _154;
    float _157 = _155 * _155;
    float _158 = _156 * _154;
    float _159 = _157 * _155;
    float _166 = mad(_156, -1.0f, (_158 * 0.5f)) + 0.6666666865348816f;
    float _170 = _158 * 0.1666666716337204f;
    float _177 = mad(_157, -1.0f, (_159 * 0.5f)) + 0.6666666865348816f;
    float _181 = _159 * 0.1666666716337204f;
    float _182 = (mad(_154, -0.5f, mad(_156, 0.5f, (_158 * -0.1666666716337204f))) + 0.1666666716337204f) + _166;
    float _183 = (mad(_155, -0.5f, mad(_157, 0.5f, (_159 * -0.1666666716337204f))) + 0.1666666716337204f) + _177;
    float _196 = ((_150 + -0.5f) + (_166 / _182)) * _146;
    float _197 = ((_151 + -0.5f) + (_177 / _183)) * _147;
    float _202 = ((_150 + 1.5f) + (_170 / ((_170 + 0.1666666716337204f) + mad(_154, 0.5f, mad(_156, 0.5f, (_158 * -0.5f)))))) * _146;
    float _203 = ((_151 + 1.5f) + (_181 / ((_181 + 0.1666666716337204f) + mad(_155, 0.5f, mad(_157, 0.5f, (_159 * -0.5f)))))) * _147;
    float4 _204 = __tex_input_texture1.Sample(__samp_input_texture1, float2(_196, _197));
    float4 _208 = __tex_input_texture1.Sample(__samp_input_texture1, float2(_202, _197));
    float4 _212 = __tex_input_texture1.Sample(__samp_input_texture1, float2(_196, _203));
    float4 _216 = __tex_input_texture1.Sample(__samp_input_texture1, float2(_202, _203));
    float _235 = ((_208.x - _216.x) * _183) + _216.x;
    float _236 = ((_208.y - _216.y) * _183) + _216.y;
    float _237 = ((_208.z - _216.z) * _183) + _216.z;
    float _244 = (((lerp(_212.x, _204.x, _183)) - _235) * _182) + _235;
    float _245 = (((lerp(_212.y, _204.y, _183)) - _236) * _182) + _236;
    float _246 = (((lerp(_212.z, _204.z, _183)) - _237) * _182) + _237;
    float _251 = max((bloom_threshold_offset_falloff.y - dot(float3(_244, _245, _246), float3(0.2126999944448471f, 0.7152000069618225f, 0.07209999859333038f))), 6.0999998822808266e-05f);
    float _263 = saturate((abs(-0.0f - _137) + -0.5f) * -3.3333332538604736f);
    float _264 = saturate((abs(-0.0f - _138) + -0.5f) * -3.3333332538604736f);
    float _270 = (_263 * _263) * (3.0f - (_263 * 2.0f));
    float _272 = (_264 * _264) * (3.0f - (_264 * 2.0f));
    _287 = ((((bloom_glare_settings.x * (_244 / _251)) * _270) * _272) + _24);
    _288 = ((((bloom_glare_settings.x * (_245 / _251)) * _270) * _272) + _25);
    _289 = ((((bloom_glare_settings.x * (_246 / _251)) * _270) * _272) + _26);
  } else {
    _287 = _24;
    _288 = _25;
    _289 = _26;
  }
  float _293 = input_texture1_size.x * TEXCOORD.x;
  float _294 = input_texture1_size.y * TEXCOORD.y;
  float _295 = 1.0f / input_texture1_size.x;
  float _296 = 1.0f / input_texture1_size.y;
  float _299 = floor(_293 + -0.5f);
  float _300 = floor(_294 + -0.5f);
  float _303 = _293 - (_299 + 0.5f);
  float _304 = _294 - (_300 + 0.5f);
  float _305 = _303 * _303;
  float _306 = _304 * _304;
  float _307 = _305 * _303;
  float _308 = _306 * _304;
  float _315 = mad(_305, -1.0f, (_307 * 0.5f)) + 0.6666666865348816f;
  float _319 = _307 * 0.1666666716337204f;
  float _326 = mad(_306, -1.0f, (_308 * 0.5f)) + 0.6666666865348816f;
  float _330 = _308 * 0.1666666716337204f;
  float _331 = (mad(_303, -0.5f, mad(_305, 0.5f, (_307 * -0.1666666716337204f))) + 0.1666666716337204f) + _315;
  float _332 = (mad(_304, -0.5f, mad(_306, 0.5f, (_308 * -0.1666666716337204f))) + 0.1666666716337204f) + _326;
  float _345 = ((_299 + -0.5f) + (_315 / _331)) * _295;
  float _346 = ((_300 + -0.5f) + (_326 / _332)) * _296;
  float _351 = ((_299 + 1.5f) + (_319 / ((_319 + 0.1666666716337204f) + mad(_303, 0.5f, mad(_305, 0.5f, (_307 * -0.5f)))))) * _295;
  float _352 = ((_300 + 1.5f) + (_330 / ((_330 + 0.1666666716337204f) + mad(_304, 0.5f, mad(_306, 0.5f, (_308 * -0.5f)))))) * _296;
  float4 _353 = __tex_input_texture1.Sample(__samp_input_texture1, float2(_345, _346));
  float4 _357 = __tex_input_texture1.Sample(__samp_input_texture1, float2(_351, _346));
  float4 _361 = __tex_input_texture1.Sample(__samp_input_texture1, float2(_345, _352));
  float4 _365 = __tex_input_texture1.Sample(__samp_input_texture1, float2(_351, _352));
  float _384 = ((_357.x - _365.x) * _332) + _365.x;
  float _385 = ((_357.y - _365.y) * _332) + _365.y;
  float _386 = ((_357.z - _365.z) * _332) + _365.z;
  float _393 = (((lerp(_361.x, _353.x, _332)) - _384) * _331) + _384;
  float _394 = (((lerp(_361.y, _353.y, _332)) - _385) * _331) + _385;
  float _395 = (((lerp(_361.z, _353.z, _332)) - _386) * _331) + _386;
  float _400 = max((bloom_threshold_offset_falloff.y - dot(float3(_393, _394, _395), float3(0.2126999944448471f, 0.7152000069618225f, 0.07209999859333038f))), 6.0999998822808266e-05f);
  float4 _407 = __tex_input_texture3.Sample(__samp_input_texture3, float2(TEXCOORD.x, TEXCOORD.y));
  float _411 = ((_393 / _400) + _287) + _407.x;
  float _412 = ((_394 / _400) + _288) + _407.y;
  float _413 = ((_395 / _400) + _289) + _407.z;
  [branch]
  if (!(tone_mapping_enabled == 0.0f)) {
    if (!(amd_lpm_tone_mapping_enabled == 0.0f)) {
      float _421 = max(0.0f, _411);
      float _422 = max(0.0f, _412);
      float _423 = max(0.0f, _413);
      float _443 = asfloat((amd_lpm[2].y));
      float _444 = asfloat((amd_lpm[2].z));
      float _445 = asfloat((amd_lpm[2].w));
      float _455 = asfloat((amd_lpm[1].z));
      float _456 = asfloat((amd_lpm[1].w));
      float _457 = asfloat((amd_lpm[2].x));
      float _460 = 1.0f / max(_421, max(_422, _423));
      float _466 = exp2(log2(_460 * _421) * asfloat((amd_lpm[0].x)));
      float _469 = exp2(log2(_460 * _422) * asfloat((amd_lpm[0].y)));
      float _472 = exp2(log2(_460 * _423) * asfloat((amd_lpm[0].z)));
      float _480 = exp2(log2(((_456 * _422) + (_455 * _421)) + (_457 * _423)) * asfloat((amd_lpm[0].w)));
      float _484 = (1.0f / ((_480 * asfloat((amd_lpm[1].x))) + asfloat((amd_lpm[1].y)))) * _480;
      float _492 = saturate(_484 * (1.0f / (((_469 * _456) + (_466 * _455)) + (_472 * _457))));
      float _494 = saturate(_492 * _466);
      float _496 = saturate(_492 * _469);
      float _498 = saturate(_492 * _472);
      float _500 = _443 - (_494 * _443);
      float _502 = _444 - (_496 * _444);
      float _504 = _445 - (_498 * _445);
      float _518 = (1.0f / (((_502 * _456) + (_500 * _455)) + (_504 * _457))) * saturate(((_484 - (_494 * _455)) - (_496 * _456)) - (_498 * _457));
      float _521 = saturate((_518 * _500) + _494);
      float _524 = saturate((_518 * _502) + _496);
      float _527 = saturate((_518 * _504) + _498);
      float _534 = saturate(((_484 - (_521 * _455)) - (_524 * _456)) - (_527 * _457));
      _872 = saturate((_534 * asfloat((amd_lpm[3].x))) + _521);
      _873 = saturate((_534 * asfloat((amd_lpm[3].y))) + _524);
      _874 = saturate((_534 * asfloat((amd_lpm[3].z))) + _527);
    } else {
      if (!(tonemap_use_custom == 0.0f)) {
        float _558 = mad(0.16386905312538147f, _413, mad(0.14067868888378143f, _412, (_411 * 0.6954522132873535f)));
        float _561 = mad(0.0955343246459961f, _413, mad(0.8596711158752441f, _412, (_411 * 0.044794581830501556f)));
        float _564 = mad(1.0015007257461548f, _413, mad(0.004025210160762072f, _412, (_411 * -0.005525882821530104f)));
        float _568 = max(max(_558, _561), _564);
        float _573 = (max(_568, 1.000000013351432e-10f) - max(min(min(_558, _561), _564), 1.000000013351432e-10f)) / max(_568, 0.009999999776482582f);
        float _586 = ((_561 + _558) + _564) + (sqrt((((_564 - _561) * _564) + ((_561 - _558) * _561)) + ((_558 - _564) * _558)) * 1.75f);
        float _587 = _586 * 0.3333333432674408f;
        float _588 = _573 + -0.4000000059604645f;
        float _589 = _588 * 5.0f;
        float _593 = max((1.0f - abs(_588 * 2.5f)), 0.0f);
        float _604 = ((float((int)(((int)(uint)((bool)(_589 > 0.0f))) - ((int)(uint)((bool)(_589 < 0.0f))))) * (1.0f - (_593 * _593))) + 1.0f) * 0.02500000037252903f;
        do {
          if (!(_587 <= 0.0533333346247673f)) {
            if (!(_587 >= 0.1599999964237213f)) {
              _613 = (((0.23999999463558197f / _586) + -0.5f) * _604);
            } else {
              _613 = 0.0f;
            }
          } else {
            _613 = _604;
          }
          float _614 = _613 + 1.0f;
          float _615 = _614 * _558;
          float _616 = _614 * _561;
          float _617 = _614 * _564;
          do {
            if (!((bool)(_615 == _616) && (bool)(_616 == _617))) {
              float _624 = ((_615 * 2.0f) - _616) - _617;
              float _627 = ((_561 - _564) * 1.7320507764816284f) * _614;
              float _629 = atan(_627 / _624);
              bool _632 = (_624 < 0.0f);
              bool _633 = (_624 == 0.0f);
              bool _634 = (_627 >= 0.0f);
              bool _635 = (_627 < 0.0f);
              _646 = select((_634 && _633), 90.0f, select((_635 && _633), -90.0f, (select((_635 && _632), (_629 + -3.1415927410125732f), select((_634 && _632), (_629 + 3.1415927410125732f), _629)) * 57.295780181884766f)));
            } else {
              _646 = 0.0f;
            }
            float _651 = min(max(select((_646 < 0.0f), (_646 + 360.0f), _646), 0.0f), 360.0f);
            do {
              if (_651 < -180.0f) {
                _660 = (_651 + 360.0f);
              } else {
                if (_651 > 180.0f) {
                  _660 = (_651 + -360.0f);
                } else {
                  _660 = _651;
                }
              }
              float _664 = saturate(1.0f - abs(_660 * 0.014814814552664757f));
              float _668 = (_664 * _664) * (3.0f - (_664 * 2.0f));
              float _674 = ((_668 * _668) * ((_573 * 0.18000000715255737f) * (0.029999999329447746f - _615))) + _615;
              float _684 = max(0.0f, mad(-0.21492856740951538f, _617, mad(-0.2365107536315918f, _616, (_674 * 1.4514392614364624f))));
              float _685 = max(0.0f, mad(-0.09967592358589172f, _617, mad(1.17622971534729f, _616, (_674 * -0.07655377686023712f))));
              float _686 = max(0.0f, mad(0.9977163076400757f, _617, mad(-0.006032449658960104f, _616, (_674 * 0.008316148072481155f))));
              float _687 = dot(float3(_684, _685, _686), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
              float _697 = 1.0f - tonemap_toe;
              float _698 = _697 + tonemap_black_clip;
              float _700 = (1.0f - tonemap_shoulder) + tonemap_white_clip;
              do {
                if (tonemap_toe > 0.800000011920929f) {
                  _717 = (((0.8199999928474426f - tonemap_toe) / tonemap_slope) + -0.7447274923324585f);
                } else {
                  float _708 = (tonemap_black_clip + 0.18000000715255737f) / _698;
                  _717 = (-0.7447274923324585f - ((log2(_708 / (2.0f - _708)) * 0.3465735912322998f) * (_698 / tonemap_slope)));
                }
                float _719 = (_697 / tonemap_slope) - _717;
                float _721 = (tonemap_shoulder / tonemap_slope) - _719;
                float _725 = log2(lerp(_687, _684, 0.9599999785423279f)) * 0.3010300099849701f;
                float _726 = log2(lerp(_687, _685, 0.9599999785423279f)) * 0.3010300099849701f;
                float _727 = log2(lerp(_687, _686, 0.9599999785423279f)) * 0.3010300099849701f;
                float _731 = (_725 + _719) * tonemap_slope;
                float _732 = (_726 + _719) * tonemap_slope;
                float _733 = (_727 + _719) * tonemap_slope;
                float _734 = _698 * 2.0f;
                float _736 = (tonemap_slope * -2.0f) / _698;
                float _737 = _725 - _717;
                float _738 = _726 - _717;
                float _739 = _727 - _717;
                float _758 = tonemap_white_clip + 1.0f;
                float _759 = _700 * 2.0f;
                float _761 = (tonemap_slope * 2.0f) / _700;
                float _786 = select((_725 < _717), ((_734 / (exp2((_737 * 1.4426950216293335f) * _736) + 1.0f)) - tonemap_black_clip), _731);
                float _787 = select((_726 < _717), ((_734 / (exp2((_738 * 1.4426950216293335f) * _736) + 1.0f)) - tonemap_black_clip), _732);
                float _788 = select((_727 < _717), ((_734 / (exp2((_736 * 1.4426950216293335f) * _739) + 1.0f)) - tonemap_black_clip), _733);
                float _795 = _721 - _717;
                float _799 = saturate(_737 / _795);
                float _800 = saturate(_738 / _795);
                float _801 = saturate(_739 / _795);
                bool _802 = (_721 < _717);
                float _806 = select(_802, (1.0f - _799), _799);
                float _807 = select(_802, (1.0f - _800), _800);
                float _808 = select(_802, (1.0f - _801), _801);
                float _827 = (((_806 * _806) * (select((_725 > _721), (_758 - (_759 / (exp2(((_725 - _721) * 1.4426950216293335f) * _761) + 1.0f))), _731) - _786)) * (3.0f - (_806 * 2.0f))) + _786;
                float _828 = (((_807 * _807) * (select((_726 > _721), (_758 - (_759 / (exp2(((_726 - _721) * 1.4426950216293335f) * _761) + 1.0f))), _732) - _787)) * (3.0f - (_807 * 2.0f))) + _787;
                float _829 = (((_808 * _808) * (select((_727 > _721), (_758 - (_759 / (exp2(((_727 - _721) * 1.4426950216293335f) * _761) + 1.0f))), _733) - _788)) * (3.0f - (_808 * 2.0f))) + _788;
                float _830 = dot(float3(_827, _828, _829), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                _872 = max(0.0f, (lerp(_830, _827, 0.9300000071525574f)));
                _873 = max(0.0f, (lerp(_830, _828, 0.9300000071525574f)));
                _874 = max(0.0f, (lerp(_830, _829, 0.9300000071525574f)));
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } else {
        _872 = saturate((((_411 * 2.509999990463257f) + 0.029999999329447746f) * _411) / ((((_411 * 2.430000066757202f) + 0.5899999737739563f) * _411) + 0.14000000059604645f));
        _873 = saturate((((_412 * 2.509999990463257f) + 0.029999999329447746f) * _412) / ((((_412 * 2.430000066757202f) + 0.5899999737739563f) * _412) + 0.14000000059604645f));
        _874 = saturate((((_413 * 2.509999990463257f) + 0.029999999329447746f) * _413) / ((((_413 * 2.430000066757202f) + 0.5899999737739563f) * _413) + 0.14000000059604645f));
      }
    }
  } else {
    _872 = _411;
    _873 = _412;
    _874 = _413;
  }
  float _881 = (pow(_872, 0.4545454680919647f));
  float _882 = (pow(_873, 0.4545454680919647f));
  float _883 = (pow(_874, 0.4545454680919647f));
  float _884 = TEXCOORD.x + -0.5f;
  float _885 = TEXCOORD.y + -0.5f;
  float _892 = (vignette_scale_falloff_opacity.y * 1.4427000284194946f) + 1.4427000284194946f;
  float _905 = 1.0f - saturate(exp2((_892 * (1.0f - dot(float2(_884, _885), float2(_884, _885)))) - _892) * vignette_scale_falloff_opacity.x);
  float _914 = vignette_enabled * vignette_scale_falloff_opacity.z;
  float _924 = ((((1.0f - ((1.0f - vignette_color.x) * _905)) * _881) - _881) * _914) + _881;
  float _925 = ((((1.0f - ((1.0f - vignette_color.y) * _905)) * _882) - _882) * _914) + _882;
  float _926 = ((((1.0f - ((1.0f - vignette_color.z) * _905)) * _883) - _883) * _914) + _883;
  [branch]
  if (!(color_filter_enabled == 0.0f)) {
    _949 = ((((color_filter_opacity.y * _924) - _924) * color_filter_opacity.x) + _924);
    _950 = ((((color_filter_opacity.z * _925) - _925) * color_filter_opacity.x) + _925);
    _951 = ((((color_filter_opacity.w * _926) - _926) * color_filter_opacity.x) + _926);
  } else {
    _949 = _924;
    _950 = _925;
    _951 = _926;
  }
  [branch]
  if (!(grey_scale_enabled == 0.0f)) {
    float _962 = max(dot(float3(_949, _950, _951), float3(grey_scale_weights.x, grey_scale_weights.y, grey_scale_weights.z)), 0.0f);
    _973 = (lerp(_949, _962, grey_scale_amount));
    _974 = (lerp(_950, _962, grey_scale_amount));
    _975 = (lerp(_951, _962, grey_scale_amount));
  } else {
    _973 = _949;
    _974 = _950;
    _975 = _951;
  }
  [branch]
  if (!(color_grading_enabled == 0.0f)) {
    float4 _988 = __tex_virtual_color_grading.SampleLevel(__samp_virtual_color_grading, float3(((saturate(_973) * 0.9375f) + 0.03125f), ((saturate(_974) * 0.9375f) + 0.03125f), ((saturate(_975) * 0.9375f) + 0.03125f)), 0.0f);
    _1002 = (lerp(_973, _988.x, color_grading_enabled));
    _1003 = (lerp(_974, _988.y, color_grading_enabled));
    _1004 = (lerp(_975, _988.z, color_grading_enabled));
  } else {
    _1002 = _973;
    _1003 = _974;
    _1004 = _975;
  }
  SV_Target.x = _1002;
  SV_Target.y = _1003;
  SV_Target.z = _1004;

  SV_Target.rgb = Tonemap(untonemapped_bt709, SV_Target.rgb);

  SV_Target.w = _17.w;
  return SV_Target;
}
