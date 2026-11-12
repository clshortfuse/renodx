#pragma once

#include <d3d9.h>
#include <wrl/client.h>

#include <array>
#include <cstdint>
#include <type_traits>

#include <include/reshade.hpp>

#include "../../utils/command_action.hpp"
#include "../../utils/state.hpp"

namespace re6_scene_hud {

using Microsoft::WRL::ComPtr;
namespace action = renodx::utils::command_action;
namespace api = reshade::api;

constexpr DWORD SCENE_SAMPLER = 12;
constexpr std::array<D3DSAMPLERSTATETYPE, 6> SAMPLER_STATES = {
    D3DSAMP_ADDRESSU, D3DSAMP_ADDRESSV, D3DSAMP_MINFILTER,
    D3DSAMP_MAGFILTER, D3DSAMP_MIPFILTER, D3DSAMP_SRGBTEXTURE};
constexpr std::array<DWORD, SAMPLER_STATES.size()> POINT_SAMPLER = {
    D3DTADDRESS_CLAMP, D3DTADDRESS_CLAMP, D3DTEXF_POINT, D3DTEXF_POINT, D3DTEXF_NONE, FALSE};

struct __declspec(uuid("3cb89716-a38f-466c-9d64-bdb13e99d28e")) FrameLayers {
  ComPtr<IDirect3DTexture9> scene;
  ComPtr<IDirect3DTexture9> transmission;
  ComPtr<IDirect3DSurface9> scene_surface;
  ComPtr<IDirect3DSurface9> transmission_surface;
  uint32_t width = 0;
  uint32_t height = 0;
  uint64_t target_view = 0;
  uint64_t target_resource = 0;
  uint64_t composite_texture = 0;
  uint64_t composite_view = 0;
  bool capturing = false;
  bool copied_composite = false;
  bool samplers_saved = false;
  bool logged_split = false;
  std::array<ComPtr<IDirect3DBaseTexture9>, 2> original_textures;
  std::array<std::array<DWORD, SAMPLER_STATES.size()>, 2> original_samplers = {};
};

inline void OnInitDevice(api::device* device) {
  if (device->get_api() == api::device_api::d3d9) {
    device->create_private_data<FrameLayers>();
  }
}

inline void OnDestroyDevice(api::device* device) {
  if (device->get_api() == api::device_api::d3d9) {
    device->destroy_private_data<FrameLayers>();
  }
}

inline void OnResetCommandList(api::command_list* cmd) {
  if (auto* layers = cmd->get_device()->get_private_data<FrameLayers>()) {
    *layers = {};
  }
}

inline void OnPresent(api::command_queue* queue, api::swapchain*, const api::rect*,
                      const api::rect*, uint32_t, const api::rect*) {
  if (auto* layers = queue->get_device()->get_private_data<FrameLayers>()) {
    layers->capturing = false;
  }
}

inline void CaptureScene(api::command_list* cmd) {
  auto* device = cmd->get_device();
  auto* layers = device->get_private_data<FrameLayers>();
  if (layers == nullptr) return;
  layers->capturing = false;
  layers->copied_composite = false;

  auto* native = reinterpret_cast<IDirect3DDevice9*>(device->get_native());
  ComPtr<IDirect3DSurface9> target;
  ComPtr<IDirect3DTexture9> target_texture;
  ComPtr<IDirect3DBaseTexture9> composite;
  ComPtr<IDirect3DTexture9> composite_texture;
  ComPtr<IDirect3DSurface9> composite_surface;
  D3DSURFACE_DESC desc = {};
  D3DSURFACE_DESC composite_desc = {};
  D3DVIEWPORT9 viewport = {};
  if (FAILED(native->GetRenderTarget(0, target.GetAddressOf()))
      || FAILED(target->GetDesc(&desc))
      || desc.Format != D3DFMT_A16B16G16R16F
      || desc.MultiSampleType != D3DMULTISAMPLE_NONE
      || FAILED(native->GetViewport(&viewport)) || viewport.X != 0 || viewport.Y != 0
      || viewport.Width != desc.Width || viewport.Height != desc.Height
      || FAILED(target->GetContainer(IID_PPV_ARGS(target_texture.GetAddressOf())))
      || FAILED(native->GetTexture(0, composite.GetAddressOf())) || composite == nullptr
      || composite.Get() == target_texture.Get()
      || FAILED(composite.As(&composite_texture))
      || FAILED(composite_texture->GetSurfaceLevel(0, composite_surface.GetAddressOf()))
      || FAILED(composite_surface->GetDesc(&composite_desc))
      || composite_desc.Width != desc.Width || composite_desc.Height != desc.Height
      || composite_desc.Format != desc.Format) return;

  if (layers->width != desc.Width || layers->height != desc.Height) {
    layers->scene_surface.Reset();
    layers->transmission_surface.Reset();
    layers->scene.Reset();
    layers->transmission.Reset();
    layers->width = 0;
    layers->height = 0;
    if (FAILED(native->CreateTexture(desc.Width, desc.Height, 1, D3DUSAGE_RENDERTARGET,
                                    desc.Format, D3DPOOL_DEFAULT, layers->scene.GetAddressOf(), nullptr))
        || FAILED(native->CreateTexture(desc.Width, desc.Height, 1, D3DUSAGE_RENDERTARGET,
                                       desc.Format, D3DPOOL_DEFAULT, layers->transmission.GetAddressOf(), nullptr))
        || FAILED(layers->scene->GetSurfaceLevel(0, layers->scene_surface.GetAddressOf()))
        || FAILED(layers->transmission->GetSurfaceLevel(0, layers->transmission_surface.GetAddressOf()))) return;
    layers->width = desc.Width;
    layers->height = desc.Height;
  }

  if (FAILED(native->StretchRect(target.Get(), nullptr, layers->scene_surface.Get(), nullptr, D3DTEXF_NONE))
      || FAILED(native->ColorFill(layers->transmission_surface.Get(), nullptr, D3DCOLOR_ARGB(255, 255, 255, 255)))) return;
  layers->target_view = reinterpret_cast<uintptr_t>(target.Get());
  layers->target_resource = reinterpret_cast<uintptr_t>(target_texture.Get());
  layers->composite_texture = reinterpret_cast<uintptr_t>(composite.Get());
  layers->composite_view = reinterpret_cast<uintptr_t>(composite_surface.Get());
  layers->capturing = true;
}

inline void TrackCopy(api::command_list* cmd, api::resource source, api::resource dest, bool full_copy) {
  auto* layers = cmd->get_device()->get_private_data<FrameLayers>();
  if (layers == nullptr || !layers->capturing) return;
  if (dest.handle == layers->target_resource || dest.handle == layers->target_view) {
    layers->capturing = false;
  } else if (dest.handle == layers->composite_texture || dest.handle == layers->composite_view) {
    layers->copied_composite = full_copy
        && (source.handle == layers->target_resource || source.handle == layers->target_view);
  }
}

inline bool OnCopyResource(api::command_list* cmd, api::resource source, api::resource dest) {
  TrackCopy(cmd, source, dest, true);
  return false;
}

inline bool OnCopyTexture(api::command_list* cmd, api::resource source, uint32_t source_subresource,
                          const api::subresource_box* source_box, api::resource dest, uint32_t dest_subresource,
                          const api::subresource_box* dest_box, api::filter_mode) {
  auto* layers = cmd->get_device()->get_private_data<FrameLayers>();
  if (layers == nullptr || !layers->capturing) return false;
  const auto covers_target = [&](const api::subresource_box* box) {
    return box == nullptr || (box->left == 0 && box->top == 0 && box->front == 0
        && box->right == layers->width && box->bottom == layers->height && box->back == 1);
  };
  TrackCopy(cmd, source, dest, source_subresource == 0 && dest_subresource == 0
      && covers_target(source_box) && covers_target(dest_box));
  return false;
}

inline bool OnClearTarget(api::command_list* cmd, api::resource_view target, const float[4],
                          uint32_t, const api::rect*) {
  if (auto* layers = cmd->get_device()->get_private_data<FrameLayers>(); layers != nullptr) {
    const auto view = target.handle & ~uint64_t{1};
    if (layers->target_view == view) {
      layers->capturing = false;
    }
    if (layers->composite_view == view) {
      layers->copied_composite = false;
    }
  }
  return false;
}

inline constexpr auto COVERAGE_ACTION = []<typename Context>(Context& context)
    requires(std::is_same_v<typename Context::ArgumentType, action::DrawArguments>
             || std::is_same_v<typename Context::ArgumentType, action::DrawIndexedArguments>) {
  action::CallbackResult<Context> result;
  auto* device = context.cmd_list->get_device();
  auto* layers = device->template get_private_data<FrameLayers>();
  if (layers == nullptr || !layers->capturing) return result;
  auto* native = reinterpret_cast<IDirect3DDevice9*>(device->get_native());
  ComPtr<IDirect3DSurface9> target;
  if (FAILED(native->GetRenderTarget(0, target.GetAddressOf()))) return result;
  const auto target_view = reinterpret_cast<uintptr_t>(target.Get());
  if (target_view == layers->composite_view) {
    layers->copied_composite = false;
  }
  if (target_view != layers->target_view) return result;

  // These draws were identified between LUT2 and the final gamma pass.
  switch (renodx::utils::state::GetCurrentShaderHash(context.cmd_list, api::pipeline_stage::pixel_shader)) {
    case 0x4FF34287:
    case 0xA01AC130:
    case 0xA2462A7A:
    case 0xA343AA1C:
    case 0xA5755685:
    case 0xC1A17EC7:
    case 0xC1A79CC8:
    case 0xC46FFE99:
    case 0xD09DF659:
      break;
    default:
      layers->capturing = false;
      return result;
  }
  layers->copied_composite = false;
  result.post_callback = [](Context& draw, const void*) {
    auto* device = draw.cmd_list->get_device();
    auto* layers = device->template get_private_data<FrameLayers>();
    auto* native = reinterpret_cast<IDirect3DDevice9*>(device->get_native());
    constexpr std::array<D3DRENDERSTATETYPE, 9> states = {
        D3DRS_ALPHABLENDENABLE, D3DRS_SRCBLEND, D3DRS_DESTBLEND, D3DRS_BLENDOP,
        D3DRS_COLORWRITEENABLE, D3DRS_ZENABLE, D3DRS_ZWRITEENABLE, D3DRS_STENCILENABLE,
        D3DRS_SRGBWRITEENABLE};
    std::array<DWORD, states.size()> saved = {};
    for (size_t i = 0; i < states.size(); ++i) {
      if (FAILED(native->GetRenderState(states[i], &saved[i]))) {
        layers->capturing = false;
        return;
      }
    }
    const auto [blend, source, destination, operation, write, depth, depth_write, stencil, srgb] = saved;
    constexpr DWORD rgb_mask = D3DCOLORWRITEENABLE_RED | D3DCOLORWRITEENABLE_GREEN | D3DCOLORWRITEENABLE_BLUE;
    if ((write & rgb_mask) == 0) return;
    // A destination-dependent source term or a nonlinear blend cannot be separated.
    if ((write & rgb_mask) != rgb_mask || (depth && depth_write) || stencil || srgb
        || (blend && (operation != D3DBLENDOP_ADD || source == D3DBLEND_DESTALPHA
            || source == D3DBLEND_INVDESTALPHA || source == D3DBLEND_DESTCOLOR
            || source == D3DBLEND_INVDESTCOLOR || source == D3DBLEND_SRCALPHASAT
            || source == D3DBLEND_BOTHSRCALPHA || source == D3DBLEND_BOTHINVSRCALPHA
            || (destination != D3DBLEND_ZERO && destination != D3DBLEND_ONE
                && destination != D3DBLEND_SRCALPHA && destination != D3DBLEND_INVSRCALPHA)))) {
      layers->capturing = false;
      return;
    }
    if (blend && destination == D3DBLEND_ONE) return;

    ComPtr<IDirect3DSurface9> original_target;
    ComPtr<IDirect3DSurface9> second_target;
    D3DVIEWPORT9 viewport = {};
    RECT scissor = {};
    if (FAILED(native->GetRenderTarget(0, original_target.GetAddressOf()))
        || reinterpret_cast<uintptr_t>(original_target.Get()) != layers->target_view
        || (SUCCEEDED(native->GetRenderTarget(1, second_target.GetAddressOf())) && second_target != nullptr)
        || FAILED(native->GetViewport(&viewport)) || FAILED(native->GetScissorRect(&scissor))
        || FAILED(native->SetRenderTarget(0, layers->transmission_surface.Get()))) {
      layers->capturing = false;
      return;
    }

    // Replay coverage only. Zero source RGB leaves the product of destination blend factors.
    const bool bound = SUCCEEDED(native->SetViewport(&viewport)) && SUCCEEDED(native->SetScissorRect(&scissor))
        && SUCCEEDED(native->SetRenderState(D3DRS_ALPHABLENDENABLE, TRUE))
        && SUCCEEDED(native->SetRenderState(D3DRS_SRCBLEND, D3DBLEND_ZERO))
        && SUCCEEDED(native->SetRenderState(D3DRS_DESTBLEND, blend ? destination : DWORD{D3DBLEND_ZERO}))
        && SUCCEEDED(native->SetRenderState(D3DRS_BLENDOP, D3DBLENDOP_ADD))
        && SUCCEEDED(native->SetRenderState(D3DRS_COLORWRITEENABLE, D3DCOLORWRITEENABLE_RED));
    if (bound) {
      const auto& args = draw.arguments;
      if constexpr (std::is_same_v<typename Context::ArgumentType, action::DrawArguments>) {
        draw.cmd_list->draw(args.vertex_count, args.instance_count, args.first_vertex, args.first_instance);
      } else {
        draw.cmd_list->draw_indexed(args.index_count, args.instance_count, args.first_index, args.vertex_offset, args.first_instance);
      }
    }
    native->SetRenderTarget(0, original_target.Get());
    native->SetViewport(&viewport);
    native->SetScissorRect(&scissor);
    for (size_t i = 0; i < 5; ++i) {
      native->SetRenderState(states[i], saved[i]);
    }
    if (!bound) {
      layers->capturing = false;
    }
  };
  return result;
};

inline void RestoreGammaSamplers(api::command_list* cmd) {
  auto* device = cmd->get_device();
  auto* layers = device->get_private_data<FrameLayers>();
  if (layers == nullptr || !layers->samplers_saved) return;
  auto* native = reinterpret_cast<IDirect3DDevice9*>(device->get_native());
  for (DWORD i = 0; i < layers->original_textures.size(); ++i) {
    native->SetTexture(SCENE_SAMPLER + i, layers->original_textures[i].Get());
    layers->original_textures[i].Reset();
    for (size_t j = 0; j < SAMPLER_STATES.size(); ++j) {
      native->SetSamplerState(SCENE_SAMPLER + i, SAMPLER_STATES[j], layers->original_samplers[i][j]);
    }
  }
  layers->samplers_saved = false;
}

inline bool BindGammaSamplers(api::command_list* cmd) {
  auto* device = cmd->get_device();
  auto* layers = device->get_private_data<FrameLayers>();
  if (layers == nullptr || !layers->capturing || !layers->copied_composite) return false;
  layers->capturing = false;
  auto* native = reinterpret_cast<IDirect3DDevice9*>(device->get_native());
  ComPtr<IDirect3DBaseTexture9> composite;
  DWORD srgb = 0;
  if (FAILED(native->GetTexture(0, composite.GetAddressOf()))
      || reinterpret_cast<uintptr_t>(composite.Get()) != layers->composite_texture
      || FAILED(native->GetSamplerState(0, D3DSAMP_SRGBTEXTURE, &srgb)) || srgb) return false;

  for (DWORD i = 0; i < layers->original_textures.size(); ++i) {
    if (FAILED(native->GetTexture(SCENE_SAMPLER + i, layers->original_textures[i].ReleaseAndGetAddressOf()))) return false;
    for (size_t j = 0; j < SAMPLER_STATES.size(); ++j) {
      if (FAILED(native->GetSamplerState(SCENE_SAMPLER + i, SAMPLER_STATES[j], &layers->original_samplers[i][j]))) return false;
    }
  }
  layers->samplers_saved = true;
  bool bound = SUCCEEDED(native->SetTexture(SCENE_SAMPLER, layers->scene.Get()))
      && SUCCEEDED(native->SetTexture(SCENE_SAMPLER + 1, layers->transmission.Get()));
  for (DWORD i = 0; i < layers->original_textures.size(); ++i) {
    for (size_t j = 0; j < SAMPLER_STATES.size(); ++j) {
      if (FAILED(native->SetSamplerState(SCENE_SAMPLER + i, SAMPLER_STATES[j], POINT_SAMPLER[j]))) {
        bound = false;
      }
    }
  }
  if (!bound) {
    RestoreGammaSamplers(cmd);
  }
  if (bound && !layers->logged_split) {
    reshade::log::message(reshade::log::level::info, "[RE6] Scene/HUD split active on the final gamma draw.");
    layers->logged_split = true;
  }
  return bound;
}

inline constexpr auto GAMMA_ACTION = []<typename Context>(Context& context)
    requires(std::is_same_v<typename Context::ArgumentType, action::DrawArguments>) {
  action::CallbackResult<Context> result;
  auto* enabled = context.template GetCallbackData<float*>();
  *enabled = BindGammaSamplers(context.cmd_list) ? 1.f : 0.f;
  if (*enabled == 1.f) {
    result.finalize_callback = [](Context& draw, const void*) {
      RestoreGammaSamplers(draw.cmd_list);
      *draw.template GetCallbackData<float*>() = 0.f;
    };
  }
  return result;
};

}  // namespace re6_scene_hud
