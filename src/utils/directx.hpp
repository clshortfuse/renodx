/*
 * Copyright (C) 2025 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <windows.h>

#include <d3d11_4.h>
#include <d3d12.h>
#include <dxgi1_6.h>
#include <unknwnbase.h>

namespace renodx::utils::directx {

namespace internal {
inline bool initialized = false;
}

inline decltype(&CreateDXGIFactory1) pCreateDXGIFactory1 = nullptr;
inline decltype(&CreateDXGIFactory2) pCreateDXGIFactory2 = nullptr;
inline decltype(&D3D12CreateDevice) pD3D12CreateDevice = nullptr;
inline decltype(&D3D11CreateDevice) pD3D11CreateDevice = nullptr;
inline decltype(&D3D12GetDebugInterface) pD3D12GetDebugInterface = nullptr;
inline decltype(&D3D12SerializeRootSignature) pD3D12SerializeRootSignature = nullptr;
using PFN_D3D_COMPILE = HRESULT(WINAPI*)(LPCVOID, SIZE_T, LPCSTR, const D3D_SHADER_MACRO*, ID3DInclude*, LPCSTR, LPCSTR, UINT, UINT, ID3DBlob**, ID3DBlob**);
inline PFN_D3D_COMPILE pD3DCompile = nullptr;

struct DECLSPEC_UUID("7F2C9A11-3B4E-4D6A-812F-5E9CD37A1B42") ReShadeRetrieveBaseInterface : IUnknown {};
template <typename T>
inline bool NativeFromReShadeProxy(T** reshade_proxy) {
  auto* unknown = static_cast<IUnknown*>(*reshade_proxy);
  if (unknown == nullptr) return false;
  ReShadeRetrieveBaseInterface* native_base = nullptr;
  if (SUCCEEDED(unknown->QueryInterface(&native_base))) {
    native_base->Release();
    *reshade_proxy = (T*)(native_base);
    return true;
  }
  assert(false);
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

}  // namespace renodx::utils::directx