#include "./common.hlsl"

Texture2D<float4> __tex_input_texture0 : register(t0);

Texture3D<float4> __tex_virtual_color_grading : register(t1);

Texture2D<float> current_exposure : register(t2);

Texture2D<float4> __tex_input_texture1 : register(t3);

Texture2D<float4> __tex_linear_depth : register(t4);

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

SamplerState __samp_virtual_color_grading : register(s1);

SamplerState __samp_input_texture1 : register(s2);

SamplerState __samp_linear_depth : register(s3);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD,
    linear float4 TEXCOORD_1: TEXCOORD1) : SV_Target {
  float4 SV_Target;
  float4 _15 = __tex_input_texture0.Sample(__samp_input_texture0, float2(TEXCOORD.x, TEXCOORD.y));
  float _20 = current_exposure.Load(int3(0, 0, 0));
  float _22 = _20.x * _15.x;
  float _23 = _20.x * _15.y;
  float _24 = _20.x * _15.z;
  float3 untonemapped_bt709 = float3(_22, _23, _24);  // After exposure

  float _285;
  float _286;
  float _287;
  float _604;
  float _637;
  float _651;
  float _708;
  float _863;
  float _864;
  float _865;
  float _940;
  float _941;
  float _942;
  float _964;
  float _965;
  float _966;
  float _993;
  float _994;
  float _995;
  [branch]
  if (!(bloom_glare_enabled == 0.0f)) {
    float4 _29 = __tex_linear_depth.Sample(__samp_linear_depth, float2(TEXCOORD.x, TEXCOORD.y));
    int _31 = asint(_29.x);
    float _33 = asfloat((_31 & 2147483647));
    bool _37 = ((uint)(uint(float((uint)((int)((uint)(_31) >> 31))))) == 0);
    float _49 = select(_37, TEXCOORD_1.w, TEXCOORD_1.w);
    float _76 = (camera_pos.x + ((select(_37, TEXCOORD_1.x, TEXCOORD_1.x) / _49) * _33)) - (((camera_world[0].y) * _33) * bloom_glare_settings.y);
    float _77 = (camera_pos.y + ((select(_37, TEXCOORD_1.y, TEXCOORD_1.y) / _49) * _33)) - (((camera_world[1].y) * _33) * bloom_glare_settings.y);
    float _78 = (camera_pos.z + ((select(_37, TEXCOORD_1.z, TEXCOORD_1.z) / _49) * _33)) - (((camera_world[2].y) * _33) * bloom_glare_settings.y);
    float _132 = mad(_78, select(_37, (camera_view_projection[1][1].z), (camera_view_projection[3][1].z)), mad(_77, select(_37, (camera_view_projection[1][1].y), (camera_view_projection[3][1].y)), (select(_37, (camera_view_projection[1][1].x), (camera_view_projection[3][1].x)) * _76))) + select(_37, (camera_view_projection[1][1].w), (camera_view_projection[3][1].w));
    float _135 = ((mad(_78, select(_37, (camera_view_projection[0][0].z), (camera_view_projection[2][0].z)), mad(_77, select(_37, (camera_view_projection[0][0].y), (camera_view_projection[2][0].y)), (select(_37, (camera_view_projection[0][0].x), (camera_view_projection[2][0].x)) * _76))) + select(_37, (camera_view_projection[0][0].w), (camera_view_projection[2][0].w))) / _132) * 0.5f;
    float _136 = ((mad(_78, select(_37, (camera_view_projection[0][1].z), (camera_view_projection[2][1].z)), mad(_77, select(_37, (camera_view_projection[0][1].y), (camera_view_projection[2][1].y)), (select(_37, (camera_view_projection[0][1].x), (camera_view_projection[2][1].x)) * _76))) + select(_37, (camera_view_projection[0][1].w), (camera_view_projection[2][1].w))) / _132) * -0.5f;
    float _142 = input_texture1_size.x * (_135 + 0.5f);
    float _143 = (_136 + 0.5f) * input_texture1_size.y;
    float _144 = 1.0f / input_texture1_size.x;
    float _145 = 1.0f / input_texture1_size.y;
    float _148 = floor(_142 + -0.5f);
    float _149 = floor(_143 + -0.5f);
    float _152 = _142 - (_148 + 0.5f);
    float _153 = _143 - (_149 + 0.5f);
    float _154 = _152 * _152;
    float _155 = _153 * _153;
    float _156 = _154 * _152;
    float _157 = _155 * _153;
    float _164 = mad(_154, -1.0f, (_156 * 0.5f)) + 0.6666666865348816f;
    float _168 = _156 * 0.1666666716337204f;
    float _175 = mad(_155, -1.0f, (_157 * 0.5f)) + 0.6666666865348816f;
    float _179 = _157 * 0.1666666716337204f;
    float _180 = (mad(_152, -0.5f, mad(_154, 0.5f, (_156 * -0.1666666716337204f))) + 0.1666666716337204f) + _164;
    float _181 = (mad(_153, -0.5f, mad(_155, 0.5f, (_157 * -0.1666666716337204f))) + 0.1666666716337204f) + _175;
    float _194 = ((_148 + -0.5f) + (_164 / _180)) * _144;
    float _195 = ((_149 + -0.5f) + (_175 / _181)) * _145;
    float _200 = ((_148 + 1.5f) + (_168 / ((_168 + 0.1666666716337204f) + mad(_152, 0.5f, mad(_154, 0.5f, (_156 * -0.5f)))))) * _144;
    float _201 = ((_149 + 1.5f) + (_179 / ((_179 + 0.1666666716337204f) + mad(_153, 0.5f, mad(_155, 0.5f, (_157 * -0.5f)))))) * _145;
    float4 _202 = __tex_input_texture1.Sample(__samp_input_texture1, float2(_194, _195));
    float4 _206 = __tex_input_texture1.Sample(__samp_input_texture1, float2(_200, _195));
    float4 _210 = __tex_input_texture1.Sample(__samp_input_texture1, float2(_194, _201));
    float4 _214 = __tex_input_texture1.Sample(__samp_input_texture1, float2(_200, _201));
    float _233 = ((_206.x - _214.x) * _181) + _214.x;
    float _234 = ((_206.y - _214.y) * _181) + _214.y;
    float _235 = ((_206.z - _214.z) * _181) + _214.z;
    float _242 = (((lerp(_210.x, _202.x, _181)) - _233) * _180) + _233;
    float _243 = (((lerp(_210.y, _202.y, _181)) - _234) * _180) + _234;
    float _244 = (((lerp(_210.z, _202.z, _181)) - _235) * _180) + _235;
    float _249 = max((bloom_threshold_offset_falloff.y - dot(float3(_242, _243, _244), float3(0.2126999944448471f, 0.7152000069618225f, 0.07209999859333038f))), 6.0999998822808266e-05f);
    float _261 = saturate((abs(-0.0f - _135) + -0.5f) * -3.3333332538604736f);
    float _262 = saturate((abs(-0.0f - _136) + -0.5f) * -3.3333332538604736f);
    float _268 = (_261 * _261) * (3.0f - (_261 * 2.0f));
    float _270 = (_262 * _262) * (3.0f - (_262 * 2.0f));
    _285 = ((((bloom_glare_settings.x * (_242 / _249)) * _268) * _270) + _22);
    _286 = ((((bloom_glare_settings.x * (_243 / _249)) * _268) * _270) + _23);
    _287 = ((((bloom_glare_settings.x * (_244 / _249)) * _268) * _270) + _24);
  } else {
    _285 = _22;
    _286 = _23;
    _287 = _24;
  }
  float _291 = input_texture1_size.x * TEXCOORD.x;
  float _292 = input_texture1_size.y * TEXCOORD.y;
  float _293 = 1.0f / input_texture1_size.x;
  float _294 = 1.0f / input_texture1_size.y;
  float _297 = floor(_291 + -0.5f);
  float _298 = floor(_292 + -0.5f);
  float _301 = _291 - (_297 + 0.5f);
  float _302 = _292 - (_298 + 0.5f);
  float _303 = _301 * _301;
  float _304 = _302 * _302;
  float _305 = _303 * _301;
  float _306 = _304 * _302;
  float _313 = mad(_303, -1.0f, (_305 * 0.5f)) + 0.6666666865348816f;
  float _317 = _305 * 0.1666666716337204f;
  float _324 = mad(_304, -1.0f, (_306 * 0.5f)) + 0.6666666865348816f;
  float _328 = _306 * 0.1666666716337204f;
  float _329 = (mad(_301, -0.5f, mad(_303, 0.5f, (_305 * -0.1666666716337204f))) + 0.1666666716337204f) + _313;
  float _330 = (mad(_302, -0.5f, mad(_304, 0.5f, (_306 * -0.1666666716337204f))) + 0.1666666716337204f) + _324;
  float _343 = ((_297 + -0.5f) + (_313 / _329)) * _293;
  float _344 = ((_298 + -0.5f) + (_324 / _330)) * _294;
  float _349 = ((_297 + 1.5f) + (_317 / ((_317 + 0.1666666716337204f) + mad(_301, 0.5f, mad(_303, 0.5f, (_305 * -0.5f)))))) * _293;
  float _350 = ((_298 + 1.5f) + (_328 / ((_328 + 0.1666666716337204f) + mad(_302, 0.5f, mad(_304, 0.5f, (_306 * -0.5f)))))) * _294;
  float4 _351 = __tex_input_texture1.Sample(__samp_input_texture1, float2(_343, _344));
  float4 _355 = __tex_input_texture1.Sample(__samp_input_texture1, float2(_349, _344));
  float4 _359 = __tex_input_texture1.Sample(__samp_input_texture1, float2(_343, _350));
  float4 _363 = __tex_input_texture1.Sample(__samp_input_texture1, float2(_349, _350));
  float _382 = ((_355.x - _363.x) * _330) + _363.x;
  float _383 = ((_355.y - _363.y) * _330) + _363.y;
  float _384 = ((_355.z - _363.z) * _330) + _363.z;
  float _391 = (((lerp(_359.x, _351.x, _330)) - _382) * _329) + _382;
  float _392 = (((lerp(_359.y, _351.y, _330)) - _383) * _329) + _383;
  float _393 = (((lerp(_359.z, _351.z, _330)) - _384) * _329) + _384;
  float _398 = max((bloom_threshold_offset_falloff.y - dot(float3(_391, _392, _393), float3(0.2126999944448471f, 0.7152000069618225f, 0.07209999859333038f))), 6.0999998822808266e-05f);
  float _402 = (_391 / _398) + _285;
  float _403 = (_392 / _398) + _286;
  float _404 = (_393 / _398) + _287;
  [branch]
  if (!(tone_mapping_enabled == 0.0f)) {
    if (!(amd_lpm_tone_mapping_enabled == 0.0f)) {
      float _412 = max(0.0f, _402);
      float _413 = max(0.0f, _403);
      float _414 = max(0.0f, _404);
      float _434 = asfloat((amd_lpm[2].y));
      float _435 = asfloat((amd_lpm[2].z));
      float _436 = asfloat((amd_lpm[2].w));
      float _446 = asfloat((amd_lpm[1].z));
      float _447 = asfloat((amd_lpm[1].w));
      float _448 = asfloat((amd_lpm[2].x));
      float _451 = 1.0f / max(_412, max(_413, _414));
      float _457 = exp2(log2(_451 * _412) * asfloat((amd_lpm[0].x)));
      float _460 = exp2(log2(_451 * _413) * asfloat((amd_lpm[0].y)));
      float _463 = exp2(log2(_451 * _414) * asfloat((amd_lpm[0].z)));
      float _471 = exp2(log2(((_447 * _413) + (_446 * _412)) + (_448 * _414)) * asfloat((amd_lpm[0].w)));
      float _475 = (1.0f / ((_471 * asfloat((amd_lpm[1].x))) + asfloat((amd_lpm[1].y)))) * _471;
      float _483 = saturate(_475 * (1.0f / (((_460 * _447) + (_457 * _446)) + (_463 * _448))));
      float _485 = saturate(_483 * _457);
      float _487 = saturate(_483 * _460);
      float _489 = saturate(_483 * _463);
      float _491 = _434 - (_485 * _434);
      float _493 = _435 - (_487 * _435);
      float _495 = _436 - (_489 * _436);
      float _509 = (1.0f / (((_493 * _447) + (_491 * _446)) + (_495 * _448))) * saturate(((_475 - (_485 * _446)) - (_487 * _447)) - (_489 * _448));
      float _512 = saturate((_509 * _491) + _485);
      float _515 = saturate((_509 * _493) + _487);
      float _518 = saturate((_509 * _495) + _489);
      float _525 = saturate(((_475 - (_512 * _446)) - (_515 * _447)) - (_518 * _448));
      _863 = saturate((_525 * asfloat((amd_lpm[3].x))) + _512);
      _864 = saturate((_525 * asfloat((amd_lpm[3].y))) + _515);
      _865 = saturate((_525 * asfloat((amd_lpm[3].z))) + _518);
    } else {
      if (!(tonemap_use_custom == 0.0f)) {
        float _549 = mad(0.16386905312538147f, _404, mad(0.14067868888378143f, _403, (_402 * 0.6954522132873535f)));
        float _552 = mad(0.0955343246459961f, _404, mad(0.8596711158752441f, _403, (_402 * 0.044794581830501556f)));
        float _555 = mad(1.0015007257461548f, _404, mad(0.004025210160762072f, _403, (_402 * -0.005525882821530104f)));
        float _559 = max(max(_549, _552), _555);
        float _564 = (max(_559, 1.000000013351432e-10f) - max(min(min(_549, _552), _555), 1.000000013351432e-10f)) / max(_559, 0.009999999776482582f);
        float _577 = ((_552 + _549) + _555) + (sqrt((((_555 - _552) * _555) + ((_552 - _549) * _552)) + ((_549 - _555) * _549)) * 1.75f);
        float _578 = _577 * 0.3333333432674408f;
        float _579 = _564 + -0.4000000059604645f;
        float _580 = _579 * 5.0f;
        float _584 = max((1.0f - abs(_579 * 2.5f)), 0.0f);
        float _595 = ((float((int)(((int)(uint)((bool)(_580 > 0.0f))) - ((int)(uint)((bool)(_580 < 0.0f))))) * (1.0f - (_584 * _584))) + 1.0f) * 0.02500000037252903f;
        do {
          if (!(_578 <= 0.0533333346247673f)) {
            if (!(_578 >= 0.1599999964237213f)) {
              _604 = (((0.23999999463558197f / _577) + -0.5f) * _595);
            } else {
              _604 = 0.0f;
            }
          } else {
            _604 = _595;
          }
          float _605 = _604 + 1.0f;
          float _606 = _605 * _549;
          float _607 = _605 * _552;
          float _608 = _605 * _555;
          do {
            if (!((bool)(_606 == _607) && (bool)(_607 == _608))) {
              float _615 = ((_606 * 2.0f) - _607) - _608;
              float _618 = ((_552 - _555) * 1.7320507764816284f) * _605;
              float _620 = atan(_618 / _615);
              bool _623 = (_615 < 0.0f);
              bool _624 = (_615 == 0.0f);
              bool _625 = (_618 >= 0.0f);
              bool _626 = (_618 < 0.0f);
              _637 = select((_625 && _624), 90.0f, select((_626 && _624), -90.0f, (select((_626 && _623), (_620 + -3.1415927410125732f), select((_625 && _623), (_620 + 3.1415927410125732f), _620)) * 57.295780181884766f)));
            } else {
              _637 = 0.0f;
            }
            float _642 = min(max(select((_637 < 0.0f), (_637 + 360.0f), _637), 0.0f), 360.0f);
            do {
              if (_642 < -180.0f) {
                _651 = (_642 + 360.0f);
              } else {
                if (_642 > 180.0f) {
                  _651 = (_642 + -360.0f);
                } else {
                  _651 = _642;
                }
              }
              float _655 = saturate(1.0f - abs(_651 * 0.014814814552664757f));
              float _659 = (_655 * _655) * (3.0f - (_655 * 2.0f));
              float _665 = ((_659 * _659) * ((_564 * 0.18000000715255737f) * (0.029999999329447746f - _606))) + _606;
              float _675 = max(0.0f, mad(-0.21492856740951538f, _608, mad(-0.2365107536315918f, _607, (_665 * 1.4514392614364624f))));
              float _676 = max(0.0f, mad(-0.09967592358589172f, _608, mad(1.17622971534729f, _607, (_665 * -0.07655377686023712f))));
              float _677 = max(0.0f, mad(0.9977163076400757f, _608, mad(-0.006032449658960104f, _607, (_665 * 0.008316148072481155f))));
              float _678 = dot(float3(_675, _676, _677), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
              float _688 = 1.0f - tonemap_toe;
              float _689 = _688 + tonemap_black_clip;
              float _691 = (1.0f - tonemap_shoulder) + tonemap_white_clip;
              do {
                if (tonemap_toe > 0.800000011920929f) {
                  _708 = (((0.8199999928474426f - tonemap_toe) / tonemap_slope) + -0.7447274923324585f);
                } else {
                  float _699 = (tonemap_black_clip + 0.18000000715255737f) / _689;
                  _708 = (-0.7447274923324585f - ((log2(_699 / (2.0f - _699)) * 0.3465735912322998f) * (_689 / tonemap_slope)));
                }
                float _710 = (_688 / tonemap_slope) - _708;
                float _712 = (tonemap_shoulder / tonemap_slope) - _710;
                float _716 = log2(lerp(_678, _675, 0.9599999785423279f)) * 0.3010300099849701f;
                float _717 = log2(lerp(_678, _676, 0.9599999785423279f)) * 0.3010300099849701f;
                float _718 = log2(lerp(_678, _677, 0.9599999785423279f)) * 0.3010300099849701f;
                float _722 = (_716 + _710) * tonemap_slope;
                float _723 = (_717 + _710) * tonemap_slope;
                float _724 = (_718 + _710) * tonemap_slope;
                float _725 = _689 * 2.0f;
                float _727 = (tonemap_slope * -2.0f) / _689;
                float _728 = _716 - _708;
                float _729 = _717 - _708;
                float _730 = _718 - _708;
                float _749 = tonemap_white_clip + 1.0f;
                float _750 = _691 * 2.0f;
                float _752 = (tonemap_slope * 2.0f) / _691;
                float _777 = select((_716 < _708), ((_725 / (exp2((_728 * 1.4426950216293335f) * _727) + 1.0f)) - tonemap_black_clip), _722);
                float _778 = select((_717 < _708), ((_725 / (exp2((_729 * 1.4426950216293335f) * _727) + 1.0f)) - tonemap_black_clip), _723);
                float _779 = select((_718 < _708), ((_725 / (exp2((_727 * 1.4426950216293335f) * _730) + 1.0f)) - tonemap_black_clip), _724);
                float _786 = _712 - _708;
                float _790 = saturate(_728 / _786);
                float _791 = saturate(_729 / _786);
                float _792 = saturate(_730 / _786);
                bool _793 = (_712 < _708);
                float _797 = select(_793, (1.0f - _790), _790);
                float _798 = select(_793, (1.0f - _791), _791);
                float _799 = select(_793, (1.0f - _792), _792);
                float _818 = (((_797 * _797) * (select((_716 > _712), (_749 - (_750 / (exp2(((_716 - _712) * 1.4426950216293335f) * _752) + 1.0f))), _722) - _777)) * (3.0f - (_797 * 2.0f))) + _777;
                float _819 = (((_798 * _798) * (select((_717 > _712), (_749 - (_750 / (exp2(((_717 - _712) * 1.4426950216293335f) * _752) + 1.0f))), _723) - _778)) * (3.0f - (_798 * 2.0f))) + _778;
                float _820 = (((_799 * _799) * (select((_718 > _712), (_749 - (_750 / (exp2(((_718 - _712) * 1.4426950216293335f) * _752) + 1.0f))), _724) - _779)) * (3.0f - (_799 * 2.0f))) + _779;
                float _821 = dot(float3(_818, _819, _820), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                _863 = max(0.0f, (lerp(_821, _818, 0.9300000071525574f)));
                _864 = max(0.0f, (lerp(_821, _819, 0.9300000071525574f)));
                _865 = max(0.0f, (lerp(_821, _820, 0.9300000071525574f)));
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } else {
        _863 = saturate((((_402 * 2.509999990463257f) + 0.029999999329447746f) * _402) / ((((_402 * 2.430000066757202f) + 0.5899999737739563f) * _402) + 0.14000000059604645f));
        _864 = saturate((((_403 * 2.509999990463257f) + 0.029999999329447746f) * _403) / ((((_403 * 2.430000066757202f) + 0.5899999737739563f) * _403) + 0.14000000059604645f));
        _865 = saturate((((_404 * 2.509999990463257f) + 0.029999999329447746f) * _404) / ((((_404 * 2.430000066757202f) + 0.5899999737739563f) * _404) + 0.14000000059604645f));
      }
    }
  } else {
    _863 = _402;
    _864 = _403;
    _865 = _404;
  }

  float _872 = (pow(_863, 0.4545454680919647f));
  float _873 = (pow(_864, 0.4545454680919647f));
  float _874 = (pow(_865, 0.4545454680919647f));
  float _875 = TEXCOORD.x + -0.5f;
  float _876 = TEXCOORD.y + -0.5f;
  float _883 = (vignette_scale_falloff_opacity.y * 1.4427000284194946f) + 1.4427000284194946f;
  float _896 = 1.0f - saturate(exp2((_883 * (1.0f - dot(float2(_875, _876), float2(_875, _876)))) - _883) * vignette_scale_falloff_opacity.x);
  float _905 = vignette_enabled * vignette_scale_falloff_opacity.z;
  float _915 = ((((1.0f - ((1.0f - vignette_color.x) * _896)) * _872) - _872) * _905) + _872;
  float _916 = ((((1.0f - ((1.0f - vignette_color.y) * _896)) * _873) - _873) * _905) + _873;
  float _917 = ((((1.0f - ((1.0f - vignette_color.z) * _896)) * _874) - _874) * _905) + _874;
  [branch]
  if (!(color_filter_enabled == 0.0f)) {
    _940 = ((((color_filter_opacity.y * _915) - _915) * color_filter_opacity.x) + _915);
    _941 = ((((color_filter_opacity.z * _916) - _916) * color_filter_opacity.x) + _916);
    _942 = ((((color_filter_opacity.w * _917) - _917) * color_filter_opacity.x) + _917);
  } else {
    _940 = _915;
    _941 = _916;
    _942 = _917;
  }
  [branch]
  if (!(grey_scale_enabled == 0.0f)) {
    float _953 = max(dot(float3(_940, _941, _942), float3(grey_scale_weights.x, grey_scale_weights.y, grey_scale_weights.z)), 0.0f);
    _964 = (lerp(_940, _953, grey_scale_amount));
    _965 = (lerp(_941, _953, grey_scale_amount));
    _966 = (lerp(_942, _953, grey_scale_amount));
  } else {
    _964 = _940;
    _965 = _941;
    _966 = _942;
  }
  [branch]
  if (!(color_grading_enabled == 0.0f)) {
    float4 _979 = __tex_virtual_color_grading.SampleLevel(__samp_virtual_color_grading, float3(((saturate(_964) * 0.9375f) + 0.03125f), ((saturate(_965) * 0.9375f) + 0.03125f), ((saturate(_966) * 0.9375f) + 0.03125f)), 0.0f);
    _993 = (lerp(_964, _979.x, color_grading_enabled));
    _994 = (lerp(_965, _979.y, color_grading_enabled));
    _995 = (lerp(_966, _979.z, color_grading_enabled));
  } else {
    _993 = _964;
    _994 = _965;
    _995 = _966;
  }
  SV_Target.x = _993;
  SV_Target.y = _994;
  SV_Target.z = _995;

  SV_Target.rgb = Tonemap(untonemapped_bt709, SV_Target.rgb);

  SV_Target.w = _15.w;
  return SV_Target;
}
