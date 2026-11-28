#pragma once

#include <d3d9.h>
#include <wrl/client.h>

#include <array>
#include <cstdint>

#include <include/reshade_api_resource.hpp>

namespace re6_hdr_copy {

inline bool CopyColorRegion(
    IDirect3DDevice9* device,
    reshade::api::resource source, uint32_t source_subresource, const reshade::api::subresource_box* source_box,
    reshade::api::resource dest, uint32_t dest_subresource, const reshade::api::subresource_box* dest_box,
    reshade::api::filter_mode filter) {
  using Microsoft::WRL::ComPtr;
  if (device == nullptr || source.handle == 0u || dest.handle == 0u) return false;
  const auto get_surface = [](reshade::api::resource resource, uint32_t level, ComPtr<IDirect3DSurface9>* surface) {
    auto* object = reinterpret_cast<IDirect3DResource9*>(static_cast<uintptr_t>(resource.handle));
    if (object->GetType() == D3DRTYPE_TEXTURE) {
      return static_cast<IDirect3DTexture9*>(object)->GetSurfaceLevel(level, surface->GetAddressOf());
    }
    if (object->GetType() == D3DRTYPE_SURFACE && level == 0u) {
      return object->QueryInterface(IID_PPV_ARGS(surface->GetAddressOf()));
    }
    return E_INVALIDARG;
  };
  ComPtr<IDirect3DSurface9> source_surface;
  ComPtr<IDirect3DSurface9> dest_surface;
  if (FAILED(get_surface(source, source_subresource, &source_surface))
      || FAILED(get_surface(dest, dest_subresource, &dest_surface))) return false;
  D3DSURFACE_DESC source_desc = {};
  D3DSURFACE_DESC dest_desc = {};
  if (FAILED(source_surface->GetDesc(&source_desc)) || FAILED(dest_surface->GetDesc(&dest_desc))
      || source_desc.MultiSampleType != D3DMULTISAMPLE_NONE || dest_desc.MultiSampleType != D3DMULTISAMPLE_NONE
      || dest_desc.Format != D3DFMT_A16B16G16R16F) return false;
  if ((source_box != nullptr && (source_box->front != 0u || source_box->back != 1u))
      || (dest_box != nullptr && (dest_box->front != 0u || dest_box->back != 1u))) return false;

  RECT source_rect = {0, 0, static_cast<LONG>(source_desc.Width), static_cast<LONG>(source_desc.Height)};
  RECT dest_rect = {0, 0, static_cast<LONG>(dest_desc.Width), static_cast<LONG>(dest_desc.Height)};
  if (source_box != nullptr) {
    source_rect = {static_cast<LONG>(source_box->left), static_cast<LONG>(source_box->top),
                   static_cast<LONG>(source_box->right), static_cast<LONG>(source_box->bottom)};
  }
  if (dest_box != nullptr) {
    dest_rect = {static_cast<LONG>(dest_box->left), static_cast<LONG>(dest_box->top),
                 static_cast<LONG>(dest_box->right), static_cast<LONG>(dest_box->bottom)};
  }
  if (source_rect.left < 0 || source_rect.top < 0 || source_rect.right > static_cast<LONG>(source_desc.Width)
      || source_rect.bottom > static_cast<LONG>(source_desc.Height)
      || source_rect.left >= source_rect.right || source_rect.top >= source_rect.bottom
      || dest_rect.left < 0 || dest_rect.top < 0 || dest_rect.right > static_cast<LONG>(dest_desc.Width)
      || dest_rect.bottom > static_cast<LONG>(dest_desc.Height)
      || dest_rect.left >= dest_rect.right || dest_rect.top >= dest_rect.bottom) return false;
  const auto texture_filter = (filter == reshade::api::filter_mode::min_mag_mip_linear
                                       || filter == reshade::api::filter_mode::min_mag_linear_mip_point
                                   ? D3DTEXF_LINEAR
                                   : D3DTEXF_POINT);
  if (source_desc.Format == dest_desc.Format) {
    return SUCCEEDED(device->StretchRect(source_surface.Get(), &source_rect, dest_surface.Get(), &dest_rect, texture_filter));
  }

  // D3D9 drivers can reject UNORM -> FP16 StretchRect. A texture-select draw
  // transfers all four encoded channels without gamma, blending or alpha tests.
  // Restrict this fallback to UNORM inputs; fixed-function HDR transport is not assumed.
  if (source_desc.Format != D3DFMT_A8R8G8B8 && source_desc.Format != D3DFMT_A8B8G8R8) return false;
  ComPtr<IDirect3DTexture9> texture;
  ComPtr<IDirect3DStateBlock9> state;
  std::array<ComPtr<IDirect3DSurface9>, 4> targets;
  ComPtr<IDirect3DSurface9> depth;
  D3DVIEWPORT9 viewport = {};
  if (FAILED(source_surface->GetContainer(IID_PPV_ARGS(texture.GetAddressOf())))
      || FAILED(device->CreateStateBlock(D3DSBT_ALL, state.GetAddressOf()))
      || FAILED(state->Capture()) || FAILED(device->GetViewport(&viewport))) return false;
  for (DWORD i = 0; i < targets.size(); ++i) {
    device->GetRenderTarget(i, targets[i].GetAddressOf());
  }
  device->GetDepthStencilSurface(depth.GetAddressOf());

  const bool opened_scene = SUCCEEDED(device->BeginScene());
  bool configured = SUCCEEDED(device->SetDepthStencilSurface(nullptr));
  for (DWORD i = 1; i < targets.size(); ++i) {
    device->SetRenderTarget(i, nullptr);
  }
  configured = configured
               && SUCCEEDED(device->SetRenderTarget(0, dest_surface.Get()))
               && SUCCEEDED(device->SetVertexShader(nullptr)) && SUCCEEDED(device->SetPixelShader(nullptr))
               && SUCCEEDED(device->SetFVF(D3DFVF_XYZRHW | D3DFVF_TEX1))
               && SUCCEEDED(device->SetStreamSourceFreq(0, 1))
               && SUCCEEDED(device->SetTexture(0, texture.Get()))
               && SUCCEEDED(device->SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_SELECTARG1))
               && SUCCEEDED(device->SetTextureStageState(0, D3DTSS_COLORARG1, D3DTA_TEXTURE))
               && SUCCEEDED(device->SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_SELECTARG1))
               && SUCCEEDED(device->SetTextureStageState(0, D3DTSS_ALPHAARG1, D3DTA_TEXTURE))
               && SUCCEEDED(device->SetTextureStageState(0, D3DTSS_RESULTARG, D3DTA_CURRENT))
               && SUCCEEDED(device->SetTextureStageState(0, D3DTSS_TEXCOORDINDEX, 0))
               && SUCCEEDED(device->SetTextureStageState(0, D3DTSS_TEXTURETRANSFORMFLAGS, D3DTTFF_DISABLE))
               && SUCCEEDED(device->SetTextureStageState(1, D3DTSS_COLOROP, D3DTOP_DISABLE))
               && SUCCEEDED(device->SetSamplerState(0, D3DSAMP_SRGBTEXTURE, FALSE))
               && SUCCEEDED(device->SetSamplerState(0, D3DSAMP_MINFILTER, texture_filter))
               && SUCCEEDED(device->SetSamplerState(0, D3DSAMP_MAGFILTER, texture_filter))
               && SUCCEEDED(device->SetSamplerState(0, D3DSAMP_MIPFILTER, D3DTEXF_NONE))
               && SUCCEEDED(device->SetSamplerState(0, D3DSAMP_MAXMIPLEVEL, source_subresource))
               && SUCCEEDED(device->SetSamplerState(0, D3DSAMP_ADDRESSU, D3DTADDRESS_CLAMP))
               && SUCCEEDED(device->SetSamplerState(0, D3DSAMP_ADDRESSV, D3DTADDRESS_CLAMP));
  constexpr std::array disabled_states = {
      D3DRS_ZENABLE, D3DRS_ZWRITEENABLE, D3DRS_STENCILENABLE, D3DRS_ALPHATESTENABLE,
      D3DRS_ALPHABLENDENABLE, D3DRS_SCISSORTESTENABLE, D3DRS_FOGENABLE, D3DRS_LIGHTING,
      D3DRS_SRGBWRITEENABLE, D3DRS_CLIPPLANEENABLE, D3DRS_DITHERENABLE};
  for (const auto render_state : disabled_states) {
    if (FAILED(device->SetRenderState(render_state, FALSE))) configured = false;
  }
  configured = configured
               && SUCCEEDED(device->SetRenderState(D3DRS_CULLMODE, D3DCULL_NONE))
               && SUCCEEDED(device->SetRenderState(D3DRS_FILLMODE, D3DFILL_SOLID))
               && SUCCEEDED(device->SetRenderState(D3DRS_WRAP0, 0))
               && SUCCEEDED(device->SetRenderState(D3DRS_COLORWRITEENABLE, 0xFu));
  const float left = static_cast<float>(dest_rect.left) - 0.5f;
  const float top = static_cast<float>(dest_rect.top) - 0.5f;
  const float right = static_cast<float>(dest_rect.right) - 0.5f;
  const float bottom = static_cast<float>(dest_rect.bottom) - 0.5f;
  const float u0 = static_cast<float>(source_rect.left) / source_desc.Width;
  const float v0 = static_cast<float>(source_rect.top) / source_desc.Height;
  const float u1 = static_cast<float>(source_rect.right) / source_desc.Width;
  const float v1 = static_cast<float>(source_rect.bottom) / source_desc.Height;
  const float vertices[4][6] = {
      {left, top, 0.f, 1.f, u0, v0}, {right, top, 0.f, 1.f, u1, v0}, {left, bottom, 0.f, 1.f, u0, v1}, {right, bottom, 0.f, 1.f, u1, v1}};
  const bool copied = configured && SUCCEEDED(device->DrawPrimitiveUP(D3DPT_TRIANGLESTRIP, 2, vertices, sizeof(vertices[0])));
  if (opened_scene) device->EndScene();
  for (DWORD i = 0; i < targets.size(); ++i) {
    device->SetRenderTarget(i, targets[i].Get());
  }
  device->SetDepthStencilSurface(depth.Get());
  state->Apply();
  device->SetViewport(&viewport);
  return copied;
}

}  // namespace re6_hdr_copy
