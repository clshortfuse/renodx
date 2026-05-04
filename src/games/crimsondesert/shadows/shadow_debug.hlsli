// Shadow Debug: Layer Disable + RTV Views
// ─────────────────────────────────────────────────────────────
// Caller-defined macros:
//   SHADOW_DBG_CONTACT_INV   (6BB: _3076 / A3D: _3060)
//   SHADOW_DBG_OUT_R/G/B/A   (6BB: _3091-_3094 / A3D: _3075-_3078)
//
// Variables in scope: _553, _694, _695, _697, _810, _811,
//   _1593, _1594, _1921, _1922, _77, _581, _585, _649, _653, _590
// ─────────────────────────────────────────────────────────────

// ── Shadow Layer Disable ─────────────────────────────────────
// Recompute outputs with the selected layer forced fully-lit.
// 0=None, 1=Terrain, 2=Dynamic Cascade, 3=Static Cascade,
// 4=Near-Field Contact, 5=Screen-Space Contact
{
  int _dis = int(SHADOW_DISABLE_LAYER);
  if (_dis > 0) {
    // Terrain component (force to 1.0 if disabling terrain)
    float _d_terrain = (_dis == 1) ? 1.0f : _553;

    // Cascade component
    bool _d_is_dyn = (_694 != 0);
    float _d_orig_cascade = select((_810 != 0), _1593, 1.0f);
    float _d_cascade;
    if (_dis == 2 && _d_is_dyn)               _d_cascade = 1.0f;  // disable dynamic
    else if (_dis == 3 && !_d_is_dyn && _810 != 0) _d_cascade = 1.0f;  // disable static
    else                                       _d_cascade = _d_orig_cascade;

    // Reconstruct _1600 equivalent
    float _d_1600 = min(_d_terrain, _d_cascade);

    // Near-field: extract from _1921 vs original _1600
    float _d_orig_1600 = min(_553, _d_orig_cascade);
    // If _1921 < original _1600, near-field was the limiter
    float _d_nf = (_1921 < _d_orig_1600 - 1e-6f) ? _1921 : 1.0f;
    if (_dis == 4) _d_nf = 1.0f;  // disable near-field contact
    float _d_1921 = min(_d_1600, _d_nf);

    // AO blend (same formula as _1935)
    float _d_1935 = (_d_1921 - (_shadowAOParams.x * _d_1921)) + _shadowAOParams.x;

    // Screen-space contact
    float _d_contact = (_dis == 5) ? 1.0f : SHADOW_DBG_CONTACT_INV;
    float _d_final = min(_d_1935, _d_contact);

    // Rewrite RGBA outputs
    SHADOW_DBG_OUT_R = float(half(_d_final * float(_1595)));
    SHADOW_DBG_OUT_G = float(half(_d_final * float(_1596)));
    SHADOW_DBG_OUT_B = float(half(_d_final * float(_1597)));
    SHADOW_DBG_OUT_A = saturate((1.0f - _d_terrain)
                     + (exp2(log2(saturate(_1922)) * 0.45454543828964233f) * _d_terrain));
  }
}

// ── RTV Debug Views ──────────────────────────────────────────
{
  int _dbg = int(SHADOW_DEBUG_MODE);
  if (_dbg > 0) {
    float _dbg_v = 0.0f;

    if (_dbg == 1) {
      // Mode 1: Terrain Shadow — red = shadowed by terrain heightmap
      _dbg_v = 1.0f - _553;

    } else if (_dbg == 2) {
      // Mode 2: Dynamic Cascade — red = covered by dynamic cascade
      _dbg_v = (_694 != 0) ? 1.0f : 0.0f;

    } else if (_dbg == 3) {
      // Mode 3: Static Cascade — red = covered by static cascade
      _dbg_v = (_697 && _810 != 0) ? 1.0f : 0.0f;

    } else if (_dbg == 4) {
      // Mode 4: Active Layer Map — distinct color per layer
      //   Red     = dynamic cascade 0 (near)
      //   Yellow  = dynamic cascade 1 (far)
      //   Green   = static cascade 0
      //   Blue    = static cascade 1
      //   Magenta = terrain only
      //   Black   = no coverage
      float3 _dbg_map;
      if (_694 != 0) {
        _dbg_map = (_695 == 0)
          ? float3(1.0f, 0.0f, 0.0f)    // dyn 0 — red
          : float3(1.0f, 1.0f, 0.0f);   // dyn 1 — yellow
      } else if (_697 && _810 != 0) {
        _dbg_map = (_811 == 0)
          ? float3(0.0f, 1.0f, 0.0f)    // static 0 — green
          : float3(0.0f, 0.0f, 1.0f);   // static 1 — blue
      } else if (_553 < 0.99f) {
        _dbg_map = float3(1.0f, 0.0f, 1.0f); // terrain only — magenta
      } else {
        _dbg_map = float3(0.0f, 0.0f, 0.0f); // nothing
      }
      SHADOW_DBG_OUT_R = _dbg_map.r;
      SHADOW_DBG_OUT_G = _dbg_map.g;
      SHADOW_DBG_OUT_B = _dbg_map.b;
      SHADOW_DBG_OUT_A = 1.0f;
      _dbg_v = -1.0f; // sentinel: already wrote output

    } else if (_dbg == 5) {
      // Mode 5: Pre-Contact PCF — red = shadowed (before contact pass)
      _dbg_v = 1.0f - _1921;

    } else if (_dbg == 6) {
      // Mode 6: Contact Shadow — red = contact shadow hit
      _dbg_v = saturate(1.0f - SHADOW_DBG_CONTACT_INV);

    } else if (_dbg == 7) {
      // Mode 7: Depth Delta — red intensity = shadow map depth offset
      _dbg_v = saturate(_1594 * 60.0f);

    } else if (_dbg == 8) {
      // Mode 8: Penumbra W — red intensity = penumbra soft-shadow width
      _dbg_v = SHADOW_DBG_OUT_A;

    } else if (_dbg == 9) {
      // Mode 9: Stencil ID — distinct hue per material ID
      float _dbg_h = frac(float(_77) * 0.618034f);
      float3 _dbg_hsv;
      _dbg_hsv = saturate(abs(frac(float3(_dbg_h, _dbg_h + 0.333f, _dbg_h + 0.667f)) * 6.0f - 3.0f) - 1.0f);
      SHADOW_DBG_OUT_R = _dbg_hsv.r;
      SHADOW_DBG_OUT_G = _dbg_hsv.g;
      SHADOW_DBG_OUT_B = _dbg_hsv.b;
      SHADOW_DBG_OUT_A = 1.0f;
      _dbg_v = -1.0f; // sentinel

    } else if (_dbg == 10) {
      // Mode 10: Cascade Seams — red = at cascade UV boundary edge
      float _dbg_d1u = min(saturate(_581 / _590), saturate((1.0f - _581) / _590));
      float _dbg_d1v = min(saturate(_585 / _590), saturate((1.0f - _585) / _590));
      float _dbg_d0u = min(saturate(_649 / _590), saturate((1.0f - _649) / _590));
      float _dbg_d0v = min(saturate(_653 / _590), saturate((1.0f - _653) / _590));
      float _dbg_edge = 1.0f - min(min(_dbg_d1u, _dbg_d1v), min(_dbg_d0u, _dbg_d0v));
      _dbg_v = saturate((_dbg_edge - 0.65f) * 10.0f);
    }

    // Write red/black for single-channel modes (sentinel -1 = already written)
    if (_dbg_v >= 0.0f) {
      SHADOW_DBG_OUT_R = _dbg_v;
      SHADOW_DBG_OUT_G = 0.0f;
      SHADOW_DBG_OUT_B = 0.0f;
      SHADOW_DBG_OUT_A = 1.0f;
    }
  }
}
