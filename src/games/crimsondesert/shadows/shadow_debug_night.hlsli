// Shadow Debug: Layer Disable + RTV Views (Night variant)
// ─────────────────────────────────────────────────────────────
// Caller-defined macros:
//   SHADOW_DBG_CONTACT_INV   (2B0C: _2595 / 439A: _2579)
//   SHADOW_DBG_OUT_R/G/B/A   (2B0C: _2610-_2613 / 439A: _2594-_2597)
//
// Night shader variables in scope:
//   _550  (terrain), _691 (dyn flag), _692 (dyn index), _694 (bool: _691==0)
//   _807  (static flag), _808 (static index)
//   _1590 (cascade result), _1591 (cascade delta)
//   _1592,_1593,_1594 (half shadow color RGB)
//   _1597 (min terrain+cascade), _1601 (penumbra), _1616 (AO blended)
//   _74 (stencil), _24[],_25[] (cascade UVs)
//
// Night pipeline has NO near-field shadow — direct:
//   terrain+cascade → _1597 → AO blend → _1616 → contact → output
// ─────────────────────────────────────────────────────────────

// ── Shadow Layer Disable ─────────────────────────────────────
// Recompute outputs with the selected layer forced fully-lit.
// 0=None, 1=Terrain, 2=Dynamic Cascade, 3=Static Cascade,
// 4=Near-Field Contact (N/A at night), 5=Screen-Space Contact
{
  int _dis = int(SHADOW_DISABLE_LAYER);
  if (_dis > 0) {
    // Terrain component (force to 1.0 if disabling terrain)
    float _d_terrain = (_dis == 1) ? 1.0f : _550;

    // Cascade component
    bool _d_is_dyn = (_691 != 0);
    float _d_orig_cascade = select((_807 != 0), _1590, 1.0f);
    float _d_cascade;
    if (_dis == 2 && _d_is_dyn)               _d_cascade = 1.0f;  // disable dynamic
    else if (_dis == 3 && !_d_is_dyn && _807 != 0) _d_cascade = 1.0f;  // disable static
    else                                       _d_cascade = _d_orig_cascade;

    // Reconstruct _1597 equivalent (no near-field in night)
    float _d_1597 = min(_d_terrain, _d_cascade);

    // AO blend (same formula as _1616)
    float _d_1616 = (_d_1597 - (_shadowAOParams.x * _d_1597)) + _shadowAOParams.x;

    // Screen-space contact
    float _d_contact = (_dis == 5) ? 1.0f : SHADOW_DBG_CONTACT_INV;
    float _d_final = min(_d_1616, _d_contact);

    // Rewrite RGBA outputs
    SHADOW_DBG_OUT_R = float(half(_d_final * float(_1592)));
    SHADOW_DBG_OUT_G = float(half(_d_final * float(_1593)));
    SHADOW_DBG_OUT_B = float(half(_d_final * float(_1594)));
    SHADOW_DBG_OUT_A = saturate((1.0f - _d_terrain)
                     + (exp2(log2(saturate(_1601)) * 0.45454543828964233f) * _d_terrain));
  }
}

// ── RTV Debug Views ──────────────────────────────────────────
{
  int _dbg = int(SHADOW_DEBUG_MODE);
  if (_dbg > 0) {
    float _dbg_v = 0.0f;

    if (_dbg == 1) {
      // Mode 1: Terrain Shadow — red = shadowed by terrain heightmap
      _dbg_v = 1.0f - _550;

    } else if (_dbg == 2) {
      // Mode 2: Dynamic Cascade — red = covered by dynamic cascade
      _dbg_v = (_691 != 0) ? 1.0f : 0.0f;

    } else if (_dbg == 3) {
      // Mode 3: Static Cascade — red = covered by static cascade
      _dbg_v = (_694 && _807 != 0) ? 1.0f : 0.0f;

    } else if (_dbg == 4) {
      // Mode 4: Active Layer Map — distinct color per layer
      //   Red     = dynamic cascade 0 (near)
      //   Yellow  = dynamic cascade 1 (far)
      //   Green   = static cascade 0
      //   Blue    = static cascade 1
      //   Magenta = terrain only
      //   Black   = no coverage
      float3 _dbg_map;
      if (_691 != 0) {
        _dbg_map = (_692 == 0)
          ? float3(1.0f, 0.0f, 0.0f)    // dyn 0 — red
          : float3(1.0f, 1.0f, 0.0f);   // dyn 1 — yellow
      } else if (_694 && _807 != 0) {
        _dbg_map = (_808 == 0)
          ? float3(0.0f, 1.0f, 0.0f)    // static 0 — green
          : float3(0.0f, 0.0f, 1.0f);   // static 1 — blue
      } else if (_550 < 0.99f) {
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
      // Mode 5: Pre-Contact Composite — red = shadowed (before contact pass)
      // Night has no near-field, so _1616 (AO-blended) is the pre-contact value
      _dbg_v = 1.0f - _1616;

    } else if (_dbg == 6) {
      // Mode 6: Contact Shadow — red = contact shadow hit
      _dbg_v = saturate(1.0f - SHADOW_DBG_CONTACT_INV);

    } else if (_dbg == 7) {
      // Mode 7: Depth Delta — red intensity = shadow map depth offset
      _dbg_v = saturate(_1591 * 60.0f);

    } else if (_dbg == 8) {
      // Mode 8: Penumbra W — red intensity = penumbra soft-shadow width
      _dbg_v = SHADOW_DBG_OUT_A;

    } else if (_dbg == 9) {
      // Mode 9: Stencil ID — distinct hue per material ID
      float _dbg_h = frac(float(_74) * 0.618034f);
      float3 _dbg_hsv;
      _dbg_hsv = saturate(abs(frac(float3(_dbg_h, _dbg_h + 0.333f, _dbg_h + 0.667f)) * 6.0f - 3.0f) - 1.0f);
      SHADOW_DBG_OUT_R = _dbg_hsv.r;
      SHADOW_DBG_OUT_G = _dbg_hsv.g;
      SHADOW_DBG_OUT_B = _dbg_hsv.b;
      SHADOW_DBG_OUT_A = 1.0f;
      _dbg_v = -1.0f; // sentinel

    } else if (_dbg == 10) {
      // Mode 10: Cascade Seams — red = at cascade UV boundary edge
      // Night uses arrays _24[]/_ 25[] for cascade UVs:
      //   _24[0],_25[0] = cascade 0 UV;  _24[1],_25[1] = cascade 1 UV
      float _dbg_texel = select((_808 == 0), 2.5f, 1.25f);  // approximate texel size
      float _dbg_d1u = min(saturate(_24[1] / _dbg_texel), saturate((1.0f - _24[1]) / _dbg_texel));
      float _dbg_d1v = min(saturate(_25[1] / _dbg_texel), saturate((1.0f - _25[1]) / _dbg_texel));
      float _dbg_d0u = min(saturate(_24[0] / _dbg_texel), saturate((1.0f - _24[0]) / _dbg_texel));
      float _dbg_d0v = min(saturate(_25[0] / _dbg_texel), saturate((1.0f - _25[0]) / _dbg_texel));
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
