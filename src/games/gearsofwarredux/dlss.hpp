/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <d3d11.h>
#include <wrl/client.h>

#include <array>
#include <atomic>
#include <cstdint>
#include <cstddef>
#include <cstring>
#include <format>
#include <mutex>

#include <include/reshade.hpp>
#include <embed/shaders.h>

#include "../../utils/detour.hpp"
#include "../../utils/directx.hpp"
#include "../../utils/iat_hook.hpp"

namespace gearsofwarredux::dlss {

// ReduxUpscalers interface 3: context, render size, output size, quality, flags.
using Create = int(__cdecl*)(ID3D11DeviceContext*, uint32_t, uint32_t, uint32_t, uint32_t, int, uint32_t);
using GetInterfaceVersion = int(__cdecl*)();

// Interface-3 evaluation arguments, verified against the installed wrapper.
// Subrect bases are in texture pixels; jitter and MV scales pass through intact.
struct EvaluateParams {
  ID3D11Resource* color;
  ID3D11Resource* depth;
  ID3D11Resource* motion_vectors;
  uint32_t color_x, color_y;
  uint32_t depth_x, depth_y;
  uint32_t motion_x, motion_y;
  uint32_t render_width, render_height;
  float jitter_x, jitter_y;
  float motion_scale_x, motion_scale_y;
  int reset;
  float trailing_parameter;  // Forwarded unchanged; SDK-specific evaluation data.
};
static_assert(sizeof(EvaluateParams) == 80);
static_assert(offsetof(EvaluateParams, render_width) == 0x30);
static_assert(offsetof(EvaluateParams, trailing_parameter) == 0x4C);
using Evaluate = int(__cdecl*)(ID3D11DeviceContext*, const EvaluateParams*);

static Create original_create = nullptr;
static Evaluate original_evaluate = nullptr;
static float* linear_output = nullptr;
static bool is_upscaling = false;
static decltype(&GetProcAddress) original_get_proc_address = nullptr;
static std::mutex hook_mutex;
static std::atomic_bool install_attempted = false;
static bool installed = false;

static Microsoft::WRL::ComPtr<ID3D11Device> decode_device;
static Microsoft::WRL::ComPtr<ID3D11ComputeShader> decode_shader;
static Microsoft::WRL::ComPtr<ID3D11Buffer> decode_rect;
static Microsoft::WRL::ComPtr<ID3D11Resource> decode_source;
static Microsoft::WRL::ComPtr<ID3D11ShaderResourceView> decode_source_view;
static Microsoft::WRL::ComPtr<ID3D11Texture2D> decode_texture;
static Microsoft::WRL::ComPtr<ID3D11UnorderedAccessView> decode_target_view;
static D3D11_TEXTURE2D_DESC decode_source_desc = {};
static std::array<uint32_t, 4> decode_current_rect = {};

static void ResetDecodeResources() {
  decode_target_view.Reset();
  decode_texture.Reset();
  decode_source_view.Reset();
  decode_source.Reset();
  decode_rect.Reset();
  decode_shader.Reset();
  decode_device.Reset();
  decode_source_desc = {};
  decode_current_rect = {};
}

// One cached input conversion, restricted to the current render rect. The game
// composite retains its existing mapper and grade; DLAA does not use this pass.
static ID3D11Resource* DecodeColor(ID3D11DeviceContext* context, const EvaluateParams& params) {
  if (params.color == nullptr || params.render_width == 0 || params.render_height == 0) return nullptr;
  D3D11_TEXTURE2D_DESC desc = decode_source_desc;
  if (decode_source.Get() != params.color || decode_texture == nullptr) {
    Microsoft::WRL::ComPtr<ID3D11Texture2D> source_texture;
    if (FAILED(params.color->QueryInterface(IID_PPV_ARGS(&source_texture)))) return nullptr;
    source_texture->GetDesc(&desc);
  }
  if (desc.Format != DXGI_FORMAT_R16G16B16A16_FLOAT || desc.SampleDesc.Count != 1
      || desc.ArraySize != 1 || desc.MipLevels != 1
      || params.color_x > desc.Width || params.render_width > desc.Width - params.color_x
      || params.color_y > desc.Height || params.render_height > desc.Height - params.color_y) return nullptr;

  if (decode_source.Get() != params.color || decode_texture == nullptr) {
    Microsoft::WRL::ComPtr<ID3D11Device> device;
    context->GetDevice(&device);
    if (device.Get() != decode_device.Get()) ResetDecodeResources();
    decode_device = device;
    if (decode_shader == nullptr) {
      if (FAILED(device->CreateComputeShader(__dlss_decode_color.data(), __dlss_decode_color.size(),
                                             nullptr, &decode_shader))) return nullptr;
    }
    if (decode_rect == nullptr) {
      D3D11_BUFFER_DESC buffer_desc = {};
      buffer_desc.ByteWidth = 16;
      buffer_desc.Usage = D3D11_USAGE_DEFAULT;
      buffer_desc.BindFlags = D3D11_BIND_CONSTANT_BUFFER;
      if (FAILED(device->CreateBuffer(&buffer_desc, nullptr, &decode_rect))) return nullptr;
    }
    decode_source.Reset();
    decode_source_view.Reset();
    if (FAILED(device->CreateShaderResourceView(params.color, nullptr, &decode_source_view))) return nullptr;
    // UE3 may alternate input textures. Rebind the source view without
    // allocating and clearing another full-resolution FP16 output each time.
    if (decode_texture == nullptr || decode_target_view == nullptr
        || desc.Width != decode_source_desc.Width || desc.Height != decode_source_desc.Height) {
      decode_target_view.Reset();
      decode_texture.Reset();
      auto target_desc = desc;
      target_desc.Usage = D3D11_USAGE_DEFAULT;
      target_desc.BindFlags = D3D11_BIND_SHADER_RESOURCE | D3D11_BIND_UNORDERED_ACCESS;
      target_desc.CPUAccessFlags = 0;
      target_desc.MiscFlags = 0;
      if (FAILED(device->CreateTexture2D(&target_desc, nullptr, &decode_texture))
          || FAILED(device->CreateUnorderedAccessView(decode_texture.Get(), nullptr, &decode_target_view))) return nullptr;
      const float black[4] = {};
      context->ClearUnorderedAccessViewFloat(decode_target_view.Get(), black);
    }
    decode_source_desc = desc;
    decode_source = params.color;
  }

  Microsoft::WRL::ComPtr<ID3D11ComputeShader> saved_shader;
  Microsoft::WRL::ComPtr<ID3D11Buffer> saved_rect;
  std::array<ID3D11ClassInstance*, D3D11_SHADER_MAX_INTERFACES> saved_classes = {};
  UINT class_count = static_cast<UINT>(saved_classes.size());
  std::array<ID3D11ShaderResourceView*, D3D11_COMMONSHADER_INPUT_RESOURCE_SLOT_COUNT> saved_srvs = {};
  std::array<ID3D11UnorderedAccessView*, D3D11_PS_CS_UAV_REGISTER_COUNT> saved_uavs = {};
  context->CSGetShader(&saved_shader, saved_classes.data(), &class_count);
  context->CSGetConstantBuffers(0, 1, &saved_rect);
  context->CSGetShaderResources(0, static_cast<UINT>(saved_srvs.size()), saved_srvs.data());
  context->CSGetUnorderedAccessViews(0, static_cast<UINT>(saved_uavs.size()), saved_uavs.data());
  const std::array<ID3D11ShaderResourceView*, saved_srvs.size()> null_srvs = {};
  const std::array<ID3D11UnorderedAccessView*, saved_uavs.size()> null_uavs = {};
  context->CSSetShaderResources(0, static_cast<UINT>(null_srvs.size()), null_srvs.data());
  context->CSSetUnorderedAccessViews(0, static_cast<UINT>(null_uavs.size()), null_uavs.data(), nullptr);
  const std::array rect = {params.color_x, params.color_y, params.render_width, params.render_height};
  if (rect != decode_current_rect) {
    context->UpdateSubresource(decode_rect.Get(), 0, nullptr, rect.data(), 0, 0);
    decode_current_rect = rect;
  }
  context->CSSetShader(decode_shader.Get(), nullptr, 0);
  context->CSSetConstantBuffers(0, 1, decode_rect.GetAddressOf());
  context->CSSetShaderResources(0, 1, decode_source_view.GetAddressOf());
  context->CSSetUnorderedAccessViews(0, 1, decode_target_view.GetAddressOf(), nullptr);
  context->Dispatch((params.render_width + 7) / 8, (params.render_height + 7) / 8, 1);
  context->CSSetShaderResources(0, static_cast<UINT>(null_srvs.size()), null_srvs.data());
  context->CSSetUnorderedAccessViews(0, static_cast<UINT>(null_uavs.size()), null_uavs.data(), nullptr);
  context->CSSetShader(saved_shader.Get(), saved_classes.data(), class_count);
  context->CSSetConstantBuffers(0, 1, saved_rect.GetAddressOf());
  context->CSSetShaderResources(0, static_cast<UINT>(saved_srvs.size()), saved_srvs.data());
  context->CSSetUnorderedAccessViews(0, static_cast<UINT>(saved_uavs.size()), saved_uavs.data(), nullptr);
  for (auto* view : saved_srvs) if (view != nullptr) view->Release();
  for (auto* view : saved_uavs) if (view != nullptr) view->Release();
  for (UINT i = 0; i < class_count; ++i) if (saved_classes[i] != nullptr) saved_classes[i]->Release();
  return decode_texture.Get();
}

static int __cdecl HookCreate(ID3D11DeviceContext* context,
                             uint32_t render_width, uint32_t render_height,
                             uint32_t output_width, uint32_t output_height,
                             int quality, uint32_t flags) {
  // Wrapper bit 0 = HDR; bit 4 = AutoExposure. The latter matches RenoDX's
  // Streamline path and supplies exposure for the newly linear upscaling feed.
  // DLAA keeps the previous HDR-only configuration and gamma input.
  const bool upscaling = render_width != output_width || render_height != output_height;
  const auto hdr_flags = flags | (upscaling ? 0x11u : 0x1u);
  const auto result = original_create(context, render_width, render_height,
                                      output_width, output_height, quality, hdr_flags);
  if (result == 0) is_upscaling = upscaling;
  static bool logged_success = false;
  static std::array<uint32_t, 6> logged_arguments = {};
  static bool logged_failure = false;
  const std::array arguments = {render_width, render_height, output_width, output_height,
                               static_cast<uint32_t>(quality), hdr_flags};
  if (result == 0 && (!logged_success || logged_arguments != arguments)) {
    logged_success = true;
    logged_arguments = arguments;
    reshade::log::message(reshade::log::level::info,
                          std::format("Gears Redux DLSS HDR: flags {:#x} -> {:#x}, {}x{} -> {}x{}",
                                      flags, hdr_flags, render_width, render_height,
                                      output_width, output_height).c_str());
  } else if (result != 0 && !logged_failure) {
    logged_failure = true;
    reshade::log::message(reshade::log::level::error,
                          std::format("Gears Redux DLSS HDR: create failed ({})", result).c_str());
  }
  return result;
}

static int __cdecl HookEvaluate(ID3D11DeviceContext* context, const EvaluateParams* params) {
  if (linear_output != nullptr) *linear_output = 0.f;
  if (!is_upscaling || context == nullptr || params == nullptr) return original_evaluate(context, params);
  auto converted = *params;
  auto* native_context = context;
  renodx::utils::directx::NativeFromReShadeProxy(&native_context);
  if (auto* color = DecodeColor(native_context, *params); color != nullptr) {
    converted.color = color;
  }
  const auto result = original_evaluate(context, &converted);
  if (result == 0 && converted.color != params->color) {
    if (linear_output != nullptr) *linear_output = 1.f;
    static bool logged = false;
    if (!logged) {
      logged = true;
      reshade::log::message(reshade::log::level::info,
                            "Gears Redux DLSS HDR: linear color input active; final blur restores gamma 2.2");
    }
  } else if (converted.color == params->color) {
    static bool logged = false;
    if (!logged) {
      logged = true;
      reshade::log::message(reshade::log::level::warning,
                            "Gears Redux DLSS HDR: color conversion unavailable; original input retained");
    }
  }
  return result;
}

static const std::array create_hook = {
    renodx::utils::detour::Export("RxUp_DLSS_Create", &original_create, &HookCreate),
    renodx::utils::detour::Export("RxUp_DLSS_Evaluate", &original_evaluate, &HookEvaluate),
};

static void Install(HMODULE module) {
  if (module == nullptr || module != GetModuleHandleW(L"ReduxUpscalers64.dll")) return;
  const std::lock_guard lock(hook_mutex);
  if (install_attempted) return;
  install_attempted = true;

  const auto get_version = reinterpret_cast<GetInterfaceVersion>(GetProcAddress(module, "RxUp_GetInterfaceVersion"));
  if (get_version == nullptr || get_version() != 3) {
    reshade::log::message(reshade::log::level::warning,
                          "Gears Redux DLSS HDR: unsupported ReduxUpscalers interface; hook skipped");
    return;
  }

  try {
    const auto result = renodx::utils::detour::Install(module, create_hook);
    installed = result.Complete();
    if (!installed) renodx::utils::detour::Uninstall(create_hook);
    reshade::log::message(installed ? reshade::log::level::info : reshade::log::level::error,
                          installed ? "Gears Redux DLSS HDR: create hook installed"
                                    : "Gears Redux DLSS HDR: could not install create hook");
  } catch (const std::exception& error) {
    reshade::log::message(reshade::log::level::error,
                          std::format("Gears Redux DLSS HDR: {}", error.what()).c_str());
  }
}

static FARPROC WINAPI HookGetProcAddress(HMODULE module, LPCSTR name) {
  const auto address = original_get_proc_address(module, name);
  // Install before the engine caches its function pointer, including late loads.
  if (address != nullptr && reinterpret_cast<uintptr_t>(name) >= 0x10000
      && (std::strcmp(name, "RxUp_DLSS_Create") == 0
          || std::strcmp(name, "RxUp_DLSS_Evaluate") == 0)) {
    Install(module);
  }
  return address;
}

static void OnInitDevice(reshade::api::device* device) {
  if (device->get_api() == reshade::api::device_api::d3d11) {
    if (!install_attempted.load(std::memory_order_relaxed)) Install(GetModuleHandleW(L"ReduxUpscalers64.dll"));
  }
}

static void OnPresent(reshade::api::command_queue* queue, reshade::api::swapchain*,
                      const reshade::api::rect*, const reshade::api::rect*,
                      uint32_t, const reshade::api::rect*) {
  if (queue->get_device()->get_api() == reshade::api::device_api::d3d11) {
    if (linear_output != nullptr) *linear_output = 0.f;
    if (!install_attempted.load(std::memory_order_relaxed)) Install(GetModuleHandleW(L"ReduxUpscalers64.dll"));
  }
}

static void OnDestroyDevice(reshade::api::device* device) {
  if (device->get_api() == reshade::api::device_api::d3d11) ResetDecodeResources();
}

static void Use(DWORD reason, LPVOID reserved, float* output) {
  if (reason == DLL_PROCESS_ATTACH) {
    linear_output = output;
    renodx::utils::iat_hook::PatchIAT("kernel32.dll", reinterpret_cast<void*>(&GetProcAddress),
                                    reinterpret_cast<void*>(&HookGetProcAddress),
                                    reinterpret_cast<void**>(&original_get_proc_address), "GetProcAddress");
    reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
    reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
    reshade::register_event<reshade::addon_event::present>(OnPresent);
  } else if (reason == DLL_PROCESS_DETACH && reserved == nullptr) {
    reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
    reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
    reshade::unregister_event<reshade::addon_event::present>(OnPresent);
    renodx::utils::iat_hook::UnpatchIAT("kernel32.dll", reinterpret_cast<void*>(&HookGetProcAddress),
                                      reinterpret_cast<void*>(original_get_proc_address), "GetProcAddress");
    const std::lock_guard lock(hook_mutex);
    if (installed && GetModuleHandleW(L"ReduxUpscalers64.dll") != nullptr) {
      try {
        renodx::utils::detour::Uninstall(create_hook);
      } catch (const std::exception& error) {
        reshade::log::message(reshade::log::level::error,
                              std::format("Gears Redux DLSS HDR: unhook failed: {}", error.what()).c_str());
      }
    }
    ResetDecodeResources();
  }
}

}  // namespace gearsofwarredux::dlss
