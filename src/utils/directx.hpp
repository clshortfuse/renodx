/*
 * Copyright (C) 2025 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <cassert>
#include <type_traits>

#include <windows.h>

#include <d3d10_1.h>
#include <d3d11_4.h>
#include <d3d12.h>
#include <d3d9.h>
#include <dxgi1_6.h>
#include <unknwnbase.h>
#include <include/reshade_api.hpp>


namespace renodx::utils::directx {

namespace internal {
inline bool initialized = false;
}  // namespace internal

inline decltype(&CreateDXGIFactory1) pCreateDXGIFactory1 = nullptr;
inline decltype(&CreateDXGIFactory2) pCreateDXGIFactory2 = nullptr;
inline decltype(&D3D12CreateDevice) pD3D12CreateDevice = nullptr;
inline decltype(&D3D11CreateDevice) pD3D11CreateDevice = nullptr;
inline decltype(&D3D12GetInterface) pD3D12GetInterface = nullptr;
inline decltype(&D3D12GetDebugInterface) pD3D12GetDebugInterface = nullptr;
inline decltype(&D3D12SerializeRootSignature) pD3D12SerializeRootSignature = nullptr;
using PFN_D3D_COMPILE = HRESULT(WINAPI*)(LPCVOID, SIZE_T, LPCSTR, const D3D_SHADER_MACRO*, ID3DInclude*, LPCSTR, LPCSTR, UINT, UINT, ID3DBlob**, ID3DBlob**);
inline PFN_D3D_COMPILE pD3DCompile = nullptr;

/**
 * @return Borrowed ReShade COM device proxy of the requested ID3D10Device,
 * ID3D11Device or ID3D12Device type, or nullptr for null input, backend mismatch,
 * or no valid published association/interface.
 * The caller must keep the ReShade device alive.
 * Forwarded private data establishes association, not wrapper order. Does not unwrap.
 */
template <typename T>
[[nodiscard]] inline T* FindReShadeDeviceProxy(reshade::api::device* device) {
  static_assert(std::is_same_v<T, ID3D10Device> || std::is_same_v<T, ID3D11Device>
                || std::is_same_v<T, ID3D12Device>);
  if (device == nullptr) return nullptr;
  GUID proxy_guid{};
  if constexpr (std::is_same_v<T, ID3D10Device>) {
    if (device->get_api() != reshade::api::device_api::d3d10) return nullptr;
    proxy_guid = {0x88399375, 0x734F, 0x4892, {0xA9, 0x5F, 0x70, 0xDD, 0x42, 0xCE, 0x7C, 0xDD}};
  } else if constexpr (std::is_same_v<T, ID3D11Device>) {
    if (device->get_api() != reshade::api::device_api::d3d11) return nullptr;
    proxy_guid = {0x72299288, 0x2C68, 0x4AD8, {0x94, 0x5D, 0x2B, 0xFB, 0x5A, 0xA9, 0xC6, 0x09}};
  } else {
    if (device->get_api() != reshade::api::device_api::d3d12) return nullptr;
    proxy_guid = {0x2523AFF4, 0x978B, 0x4939, {0xBA, 0x16, 0x8E, 0xE8, 0x76, 0xA4, 0xCB, 0x2A}};
  }
  auto* downstream = reinterpret_cast<T*>(device->get_native());
  if (downstream == nullptr) return nullptr;
  IUnknown* proxy = nullptr;
  UINT size = sizeof(proxy);
  if (FAILED(downstream->GetPrivateData(proxy_guid, &size, &proxy))
      || size != sizeof(proxy) || proxy == nullptr) return nullptr;
  // D3D10/11 publish the concrete wrapper's first (DXGI) base, not its D3D base.
  T* device_proxy = nullptr;
  if (FAILED(proxy->QueryInterface(IID_PPV_ARGS(&device_proxy)))) return nullptr;
  if (device_proxy != nullptr) {
    device_proxy->Release();
  }
  return device_proxy;
}

struct DECLSPEC_UUID("7F2C9A11-3B4E-4D6A-812F-5E9CD37A1B42") ReShadeRetrieveBaseInterface : IUnknown {};
/**
 * @pre The input is a known ReShade proxy, not an arbitrary interface to probe.
 * @post On success, replaces the input with a borrowed downstream interface.
 * Query forwarding means success does not validate the input's wrapper identity.
 * Returns false on contract failure in Release, leaving the input unchanged.
 */
template <typename T>
inline bool NativeFromReShadeProxy(T** reshade_proxy) {
  if (reshade_proxy == nullptr) {
    OutputDebugStringA("NativeFromReShadeProxy: null pointer-to-pointer argument.\n");
    assert(reshade_proxy != nullptr && "NativeFromReShadeProxy requires a valid pointer-to-pointer");
    return false;
  }
  auto* unknown = static_cast<IUnknown*>(*reshade_proxy);
  if (unknown == nullptr) {
    OutputDebugStringA("NativeFromReShadeProxy: null COM object.\n");
    assert(unknown != nullptr && "NativeFromReShadeProxy requires a non-null ReShade proxy");
    return false;
  }
  ReShadeRetrieveBaseInterface* native_base = nullptr;
  const HRESULT result = unknown->QueryInterface(&native_base);
  if (SUCCEEDED(result) && native_base != nullptr) {
    native_base->Release();
    *reshade_proxy = reinterpret_cast<T*>(native_base);
    return true;
  }
  OutputDebugStringA("NativeFromReShadeProxy: expected ReShade proxy did not return a downstream interface.\n");
  assert(SUCCEEDED(result) && native_base != nullptr
         && "NativeFromReShadeProxy requires a ReShade proxy supporting downstream retrieval");
  return false;
}

static bool Initialize() {
  if (internal::initialized) return true;

  if (pCreateDXGIFactory1 == nullptr) {
    HMODULE dxgi_module = LoadLibraryW(L"dxgi.dll");
    if (dxgi_module == nullptr) {
      // reshade::log::message(reshade::log::level::error, "mods::swapchain::LoadDirectXLibraries(LoadLibraryW(dxgi.dll) failed)");
      return false;
    }

    pCreateDXGIFactory1 = reinterpret_cast<decltype(&CreateDXGIFactory1)>(
        GetProcAddress(dxgi_module, "CreateDXGIFactory1"));
    if (pCreateDXGIFactory1 == nullptr) {
      // reshade::log::message(reshade::log::level::error, "mods::swapchain::LoadDirectXLibraries(GetProcAddress(dxgi.dll, CreateDXGIFactory1) failed)");
      return false;
    }
  }

  if (pCreateDXGIFactory2 == nullptr) {
    HMODULE dxgi_module = LoadLibraryW(L"dxgi.dll");
    if (dxgi_module == nullptr) {
      // reshade::log::message(reshade::log::level::error, "mods::swapchain::LoadDirectXLibraries(LoadLibraryW(dxgi.dll) failed)");
      return false;
    }

    pCreateDXGIFactory2 = reinterpret_cast<decltype(&CreateDXGIFactory2)>(
        GetProcAddress(dxgi_module, "CreateDXGIFactory2"));
    if (pCreateDXGIFactory2 == nullptr) {
      // reshade::log::message(reshade::log::level::error, "mods::swapchain::LoadDirectXLibraries(GetProcAddress(dxgi.dll, CreateDXGIFactory2) failed)");
      return false;
    }
  }

  if (pD3D11CreateDevice == nullptr) {
    HMODULE d3d11_module = LoadLibraryW(L"d3d11.dll");
    if (d3d11_module == nullptr) {
      // reshade::log::message(reshade::log::level::error, "mods::swapchain::LoadDirectXLibraries(LoadLibraryW(d3d11.dll) failed)");
      return false;
    }

    pD3D11CreateDevice = reinterpret_cast<decltype(&D3D11CreateDevice)>(
        GetProcAddress(d3d11_module, "D3D11CreateDevice"));
    if (pD3D11CreateDevice == nullptr) {
      // reshade::log::message(reshade::log::level::error, "mods::swapchain::LoadDirectXLibraries(GetProcAddress(d3d11.dll, D3D11CreateDevice) failed)");
      return false;
    }
  }

  if (pD3D12CreateDevice == nullptr) {
    HMODULE d3d12_module = LoadLibraryW(L"d3d12.dll");
    if (d3d12_module == nullptr) {
      // reshade::log::message(reshade::log::level::error, "mods::swapchain::LoadDirectXLibraries(LoadLibraryW(d3d12.dll) failed)");
      return false;
    }

    pD3D12CreateDevice = reinterpret_cast<decltype(&D3D12CreateDevice)>(
        GetProcAddress(d3d12_module, "D3D12CreateDevice"));
    if (pD3D12CreateDevice == nullptr) {
      // reshade::log::message(reshade::log::level::error, "mods::swapchain::LoadDirectXLibraries(GetProcAddress(d3d12.dll, D3D12CreateDevice) failed)");
      return false;
    }
  }

  if (pD3D12GetInterface == nullptr) {
    HMODULE d3d12_module = LoadLibraryW(L"d3d12.dll");
    if (d3d12_module != nullptr) {
      pD3D12GetInterface = reinterpret_cast<decltype(&D3D12GetInterface)>(
          GetProcAddress(d3d12_module, "D3D12GetInterface"));
    }
  }

  // Try to resolve D3D12GetDebugInterface from d3d12.dll so callers can obtain
  // the debug interface via the runtime-resolved symbol (useful when a proxy
  // or injector provides an alternate d3d12.dll).
  if (pD3D12GetDebugInterface == nullptr) {
    HMODULE d3d12_module = LoadLibraryW(L"d3d12.dll");
    if (d3d12_module != nullptr) {
      pD3D12GetDebugInterface = reinterpret_cast<decltype(&D3D12GetDebugInterface)>(
          GetProcAddress(d3d12_module, "D3D12GetDebugInterface"));
    }
  }

  // Try to resolve D3D12SerializeRootSignature from d3d12.dll
  if (pD3D12SerializeRootSignature == nullptr) {
    HMODULE d3d12_module = LoadLibraryW(L"d3d12.dll");
    if (d3d12_module != nullptr) {
      pD3D12SerializeRootSignature = reinterpret_cast<PFN_D3D12_SERIALIZE_ROOT_SIGNATURE>(GetProcAddress(d3d12_module, "D3D12SerializeRootSignature"));
    }
  }

  // Load D3DCompile from d3dcompiler DLL (try common versions)
  if (pD3DCompile == nullptr) {
    const wchar_t* compilers[] = {L"d3dcompiler_47.dll", L"d3dcompiler_46.dll", L"d3dcompiler_43.dll", L"d3dcompiler.dll"};
    for (auto c : compilers) {
      HMODULE d3dcompiler = LoadLibraryW(c);
      if (d3dcompiler != nullptr) {
        pD3DCompile = reinterpret_cast<PFN_D3D_COMPILE>(GetProcAddress(d3dcompiler, "D3DCompile"));
        if (pD3DCompile != nullptr) break;
      }
    }
  }

  internal::initialized = true;
  return true;
}

[[nodiscard]] static bool IsD3D9ExDevice(IDirect3DDevice9* device) {
  if (device == nullptr) return false;

  IDirect3DDevice9Ex* native_device_ex = nullptr;
  const HRESULT hr = device->QueryInterface(IID_PPV_ARGS(&native_device_ex));
  if (FAILED(hr) || native_device_ex == nullptr) return false;

  native_device_ex->Release();
  return true;
}

}  // namespace renodx::utils::directx