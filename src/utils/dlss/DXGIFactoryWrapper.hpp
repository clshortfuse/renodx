/*
 * Copyright (C) 2025 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <map>

#include <d3d12.h>
#include <dxgi1_6.h>

#include <sl.h>
#include <sl_core_api.h>
#include <sl_dlss_g.h>

#include <include/reshade_api_device.hpp>

class DXGIFactoryWrapper : public IDXGIFactory7 {
 public:
  explicit DXGIFactoryWrapper(IDXGIFactory7* factory) : _factory(factory) {}

  // {ADEC44E2-61F0-45C3-AD9F-1B37379284FF}
  // {189819F1-1DB6-4B57-BE54-1821339B85F7}
  // {DB6F6DDB-AC77-4E88-8253-819DF9BBF140}
  // {7B7166EC-21C7-44AE-B21A-C9AE321AE369} // IDXGIFactory
  // {A4966EED-76DB-44DA-84C1-EE9A7AFB20A8}
  HRESULT STDMETHODCALLTYPE QueryInterface(REFIID riid, void** ppvObject) override {
    if (riid == __uuidof(IDXGIFactory7)
        || riid == __uuidof(IDXGIFactory6)
        || riid == __uuidof(IDXGIFactory5)
        || riid == __uuidof(IDXGIFactory4)
        || riid == __uuidof(IDXGIFactory3)
        || riid == __uuidof(IDXGIFactory2)
        || riid == __uuidof(IDXGIFactory1)
        || riid == __uuidof(IDXGIFactory)) {
      *ppvObject = this;
      AddRef();
      return S_OK;
    }
    return _factory->QueryInterface(riid, ppvObject);
  }
  ULONG STDMETHODCALLTYPE AddRef() override { return _factory->AddRef(); }
  ULONG STDMETHODCALLTYPE Release() override { return _factory->Release(); }

  // IDXGIObject
  HRESULT STDMETHODCALLTYPE SetPrivateData(REFGUID Name, UINT DataSize, const void* pData) override {
    return _factory->SetPrivateData(Name, DataSize, pData);
  }
  HRESULT STDMETHODCALLTYPE SetPrivateDataInterface(REFGUID Name, const IUnknown* pUnknown) override {
    return _factory->SetPrivateDataInterface(Name, pUnknown);
  }
  HRESULT STDMETHODCALLTYPE GetPrivateData(REFGUID Name, UINT* pDataSize, void* pData) override {
    return _factory->GetPrivateData(Name, pDataSize, pData);
  }
  HRESULT STDMETHODCALLTYPE GetParent(REFIID riid, void** ppParent) override {
    return _factory->GetParent(riid, ppParent);
  }

  // IDXGIFactory
  HRESULT STDMETHODCALLTYPE EnumAdapters(UINT Adapter, IDXGIAdapter** ppAdapter) override {
    return _factory->EnumAdapters(Adapter, ppAdapter);
  }
  HRESULT STDMETHODCALLTYPE MakeWindowAssociation(HWND WindowHandle, UINT Flags) override {
    return _factory->MakeWindowAssociation(WindowHandle, Flags);
  }
  HRESULT STDMETHODCALLTYPE GetWindowAssociation(HWND* pWindowHandle) override {
    return _factory->GetWindowAssociation(pWindowHandle);
  }
  HRESULT STDMETHODCALLTYPE CreateSwapChain(IUnknown* pDevice, DXGI_SWAP_CHAIN_DESC* pDesc,
                                            IDXGISwapChain** ppSwapChain) override {
    return _factory->CreateSwapChain(pDevice, pDesc, ppSwapChain);
  }
  HRESULT STDMETHODCALLTYPE CreateSoftwareAdapter(HMODULE Module, IDXGIAdapter** ppAdapter) override {
    return _factory->CreateSoftwareAdapter(Module, ppAdapter);
  }

  // IDXGIFactory1
  HRESULT STDMETHODCALLTYPE EnumAdapters1(UINT Adapter, IDXGIAdapter1** ppAdapter) override {
    return _factory->EnumAdapters1(Adapter, ppAdapter);
  }
  BOOL STDMETHODCALLTYPE IsCurrent() override { return _factory->IsCurrent(); }

  // IDXGIFactory2
  BOOL STDMETHODCALLTYPE IsWindowedStereoEnabled() override { return _factory->IsWindowedStereoEnabled(); }
  HRESULT STDMETHODCALLTYPE CreateSwapChainForHwnd(IUnknown* pDevice, HWND hWnd, const DXGI_SWAP_CHAIN_DESC1* pDesc,
                                                   const DXGI_SWAP_CHAIN_FULLSCREEN_DESC* pFullscreenDesc,
                                                   IDXGIOutput* pRestrictToOutput,
                                                   IDXGISwapChain1** ppSwapChain) override {
    return _factory->CreateSwapChainForHwnd(pDevice, hWnd, pDesc, pFullscreenDesc, pRestrictToOutput, ppSwapChain);
  }

  HRESULT STDMETHODCALLTYPE CreateSwapChainForCoreWindow(IUnknown* pDevice, IUnknown* pWindow,
                                                         const DXGI_SWAP_CHAIN_DESC1* pDesc,
                                                         IDXGIOutput* pRestrictToOutput,
                                                         IDXGISwapChain1** ppSwapChain) override {
    return _factory->CreateSwapChainForCoreWindow(pDevice, pWindow, pDesc, pRestrictToOutput, ppSwapChain);
  }
  HRESULT STDMETHODCALLTYPE GetSharedResourceAdapterLuid(HANDLE hResource, LUID* pLuid) override {
    return _factory->GetSharedResourceAdapterLuid(hResource, pLuid);
  }
  HRESULT STDMETHODCALLTYPE RegisterStereoStatusWindow(HWND WindowHandle, UINT wMsg, DWORD* pdwCookie) override {
    return _factory->RegisterStereoStatusWindow(WindowHandle, wMsg, pdwCookie);
  }
  HRESULT STDMETHODCALLTYPE RegisterStereoStatusEvent(HANDLE hEvent, DWORD* pdwCookie) override {
    return _factory->RegisterStereoStatusEvent(hEvent, pdwCookie);
  }
  void STDMETHODCALLTYPE UnregisterStereoStatus(DWORD dwCookie) override { _factory->UnregisterStereoStatus(dwCookie); }
  HRESULT STDMETHODCALLTYPE RegisterOcclusionStatusWindow(HWND WindowHandle, UINT wMsg, DWORD* pdwCookie) override {
    return _factory->RegisterOcclusionStatusWindow(WindowHandle, wMsg, pdwCookie);
  }
  HRESULT STDMETHODCALLTYPE RegisterOcclusionStatusEvent(HANDLE hEvent, DWORD* pdwCookie) override {
    return _factory->RegisterOcclusionStatusEvent(hEvent, pdwCookie);
  }
  void STDMETHODCALLTYPE UnregisterOcclusionStatus(DWORD dwCookie) override {
    _factory->UnregisterOcclusionStatus(dwCookie);
  }
  HRESULT STDMETHODCALLTYPE CreateSwapChainForComposition(IUnknown* pDevice, const DXGI_SWAP_CHAIN_DESC1* pDesc,
                                                          IDXGIOutput* pRestrictToOutput,
                                                          IDXGISwapChain1** ppSwapChain) override {
    return _factory->CreateSwapChainForComposition(pDevice, pDesc, pRestrictToOutput, ppSwapChain);
  }

  // IDXGIFactory3
  UINT STDMETHODCALLTYPE GetCreationFlags() override { return _factory->GetCreationFlags(); }

  // IDXGIFactory4
  HRESULT STDMETHODCALLTYPE EnumAdapterByLuid(LUID AdapterLuid, REFIID riid, void** ppvAdapter) override {
    return _factory->EnumAdapterByLuid(AdapterLuid, riid, ppvAdapter);
  }

  HRESULT STDMETHODCALLTYPE EnumWarpAdapter(REFIID riid, void** ppvAdapter) override {
    return _factory->EnumWarpAdapter(riid, ppvAdapter);
  }

  // IDXGIFactory5
  HRESULT STDMETHODCALLTYPE CheckFeatureSupport(DXGI_FEATURE Feature, void* pFeatureSupportData,
                                                UINT FeatureSupportDataSize) override {
    return _factory->CheckFeatureSupport(Feature, pFeatureSupportData, FeatureSupportDataSize);
  }

  // IDXGIFactory6
  HRESULT STDMETHODCALLTYPE EnumAdapterByGpuPreference(UINT Adapter, DXGI_GPU_PREFERENCE GpuPreference, REFIID riid,
                                                       void** ppvAdapter) override {
    return _factory->EnumAdapterByGpuPreference(Adapter, GpuPreference, riid, ppvAdapter);
  }

  // IDXGIFactory7
  HRESULT STDMETHODCALLTYPE RegisterAdaptersChangedEvent(HANDLE hEvent, DWORD* pdwCookie) override {
    return _factory->RegisterAdaptersChangedEvent(hEvent, pdwCookie);
  }
  HRESULT STDMETHODCALLTYPE UnregisterAdaptersChangedEvent(DWORD dwCookie) override {
    return _factory->UnregisterAdaptersChangedEvent(dwCookie);
  }

 private:
  IDXGIFactory7* _factory;
};
