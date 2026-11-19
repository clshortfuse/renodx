#pragma once

// SDR screen is S + D * (1 - S). For D > 1, adding glow can darken D;
// for S > 1 it can even invert it. Change only recognized screen blends
// on the selected luminous passes, and restore every changed state afterward.
namespace codwaw_bloom {
struct SavedBlend {
  IDirect3DDevice9* device = nullptr;
  DWORD source = 0, destination = 0;
  DWORD separate_alpha = 0, source_alpha = 0, destination_alpha = 0, alpha_op = 0;
};
inline thread_local SavedBlend saved;

inline DWORD AlphaFactor(DWORD factor) {
  if (factor == D3DBLEND_SRCCOLOR) return D3DBLEND_SRCALPHA;
  if (factor == D3DBLEND_INVSRCCOLOR) return D3DBLEND_INVSRCALPHA;
  if (factor == D3DBLEND_DESTCOLOR) return D3DBLEND_DESTALPHA;
  if (factor == D3DBLEND_INVDESTCOLOR) return D3DBLEND_INVDESTALPHA;
  return factor;
}

inline void Restore(reshade::api::command_list*) {
  if (saved.device == nullptr) return;
  auto state = saved;
  saved = {};
  state.device->SetRenderState(D3DRS_SRCBLEND, state.source);
  state.device->SetRenderState(D3DRS_DESTBLEND, state.destination);
  state.device->SetRenderState(D3DRS_SRCBLENDALPHA, state.source_alpha);
  state.device->SetRenderState(D3DRS_DESTBLENDALPHA, state.destination_alpha);
  state.device->SetRenderState(D3DRS_BLENDOPALPHA, state.alpha_op);
  state.device->SetRenderState(D3DRS_SEPARATEALPHABLENDENABLE, state.separate_alpha);
}

inline bool Begin(reshade::api::command_list* cmd, bool hdr) {
  if (!hdr || cmd->get_device()->get_api() != reshade::api::device_api::d3d9) return true;
  auto* device = reinterpret_cast<IDirect3DDevice9*>(cmd->get_device()->get_native());
  DWORD enabled = 0, operation = 0;
  SavedBlend state;
  if (FAILED(device->GetRenderState(D3DRS_ALPHABLENDENABLE, &enabled)) || !enabled
      || FAILED(device->GetRenderState(D3DRS_BLENDOP, &operation)) || operation != D3DBLENDOP_ADD
      || FAILED(device->GetRenderState(D3DRS_SRCBLEND, &state.source))
      || FAILED(device->GetRenderState(D3DRS_DESTBLEND, &state.destination))) return true;
  const bool screen = (state.source == D3DBLEND_ONE && state.destination == D3DBLEND_INVSRCCOLOR)
                   || (state.source == D3DBLEND_INVDESTCOLOR && state.destination == D3DBLEND_ONE);
  if (!screen) return true; // Preserve smoke, ordinary alpha, additive and modulate materials.
  if (FAILED(device->GetRenderState(D3DRS_SEPARATEALPHABLENDENABLE, &state.separate_alpha))
      || FAILED(device->GetRenderState(D3DRS_SRCBLENDALPHA, &state.source_alpha))
      || FAILED(device->GetRenderState(D3DRS_DESTBLENDALPHA, &state.destination_alpha))
      || FAILED(device->GetRenderState(D3DRS_BLENDOPALPHA, &state.alpha_op))) return true;
  state.device = device;
  saved = state;
  // Preserve the original alpha equation even when color blending becomes additive.
  if (!state.separate_alpha) {
    if (FAILED(device->SetRenderState(D3DRS_SRCBLENDALPHA, AlphaFactor(state.source)))
        || FAILED(device->SetRenderState(D3DRS_DESTBLENDALPHA, AlphaFactor(state.destination)))
        || FAILED(device->SetRenderState(D3DRS_BLENDOPALPHA, operation))
        || FAILED(device->SetRenderState(D3DRS_SEPARATEALPHABLENDENABLE, TRUE))) {
      Restore(cmd);
      return true;
    }
  }
  if (FAILED(device->SetRenderState(D3DRS_SRCBLEND, D3DBLEND_ONE))
      || FAILED(device->SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE))) Restore(cmd);
  return true;
}
} // namespace codwaw_bloom
