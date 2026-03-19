// -------------------------Depth-Bias Micro Detail Shadows --------------------
//
// Bend Studio style SSS
//
// Uses a continuous depth bias instead of binary hit/miss like in base shader
//
//   - Depth deltas within a configurable thickness window produce
//     graduated shadows
//
//   - Deltas outside the window are ignored
//
// -----------------------------------------------------------------------------

if (CONTACT_SHADOW_QUALITY > 0.5f) {
  // -- Tuning constants -------------------------------------------------------
  static const int   MICRO_STEPS    = 16;
  static const float MICRO_CONTRAST = 2.5;

  float _microLinDepth = MICRO_LINEAR_DEPTH;
  float _microDistFade = saturate((40.0 - _microLinDepth) * 0.1);

  [branch]
  if (_microDistFade > 0.01) {
    float _microRange = lerp(0.12, 0.30, saturate(_microLinDepth / 30.0));
    float _microStep  = _microRange / (float)MICRO_STEPS;
    float _microThick = _microStep *
      (_nearFarProj.x / max(1.0, _microLinDepth * _microLinDepth));
    _microThick = clamp(_microThick, 0.00005, 0.005);

    // Temporal jitter
    float _microJitter = frac(
      float(int4(_frameNumber).x & 0xFF) * 0.38196601 +
      MICRO_PIXEL_X_FLOAT * 0.7548776 +
      MICRO_PIXEL_Y_FLOAT * 0.5698402) * 0.5;

    float3 _microPos = float3(MICRO_WORLD_POS_X, MICRO_WORLD_POS_Y, MICRO_WORLD_POS_Z);
    float3 _microDir = float3(MICRO_LIGHT_DIR_X, MICRO_LIGHT_DIR_Y, MICRO_LIGHT_DIR_Z);

    float _microShadow = 1.0;

    [loop]
    for (int _mi = 0; _mi < MICRO_STEPS; _mi++) {
      float _mt = ((float)_mi + 0.5 + _microJitter) * _microStep;
      float3 _msp = _microPos + _microDir * _mt;

      // Project to clip space via _viewProjRelative 
      float _mcx = mad(_viewProjRelative[0].z, _msp.z,
                    mad(_viewProjRelative[0].y, _msp.y,
                        _viewProjRelative[0].x * _msp.x)) + _viewProjRelative[0].w;
      float _mcy = mad(_viewProjRelative[1].z, _msp.z,
                    mad(_viewProjRelative[1].y, _msp.y,
                        _viewProjRelative[1].x * _msp.x)) + _viewProjRelative[1].w;
      float _mcz = mad(_viewProjRelative[2].z, _msp.z,
                    mad(_viewProjRelative[2].y, _msp.y,
                        _viewProjRelative[2].x * _msp.x)) + _viewProjRelative[2].w;
      float _mcw = mad(_viewProjRelative[3].z, _msp.z,
                    mad(_viewProjRelative[3].y, _msp.y,
                        _viewProjRelative[3].x * _msp.x)) + _viewProjRelative[3].w;

      // Skip if behind camera
      if (_mcw <= 0.0) continue;

      float2 _muv = float2(_mcx / _mcw * 0.5 + 0.5,
                            0.5 - _mcy / _mcw * 0.5);

      // Bounds check
      if (any(_muv < 0.0) || any(_muv > 1.0)) continue;

      float _mRayDepth = _mcz / _mcw;

      // Sample depth buffer
      int2 _mpx = int2((int)(_muv.x * _bufferSizeAndInvSize.x),
                        (int)(_muv.y * _bufferSizeAndInvSize.y));
      uint _mdr = __3__36__0__0__g_depthStencil.Load(int3(_mpx, 0)).x;
      float _msd = float(_mdr & 0xFFFFFF) * 5.960465188081798e-08;

      // Skip sky
      if (_msd < 1e-7 || _msd >= 1.0) continue;

      // -- Depth-bias evaluation --------------------------------------------
      // Reversed-Z: near=1, far=0.
      // Positive delta = sample farther from camera = potential occluder.
      float _mdelta = _msd - _mRayDepth;

      if (_mdelta >= 0.0 && _mdelta <= _microThick) {
        float _mocc = saturate((_mdelta / max(_microThick, 1e-7)) * MICRO_CONTRAST);
        _microShadow = min(_microShadow, 1.0 - _mocc);
      }
    }

    // Blend into contact shadow with distance fade
    float _microResult = lerp(1.0, _microShadow, _microDistFade);
    MICRO_CONTACT_SHADOW = min(MICRO_CONTACT_SHADOW, _microResult);
  }
}
