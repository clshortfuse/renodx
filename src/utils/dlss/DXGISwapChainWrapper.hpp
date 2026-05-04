/*
 * Copyright (C) 2025 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <dxgi1_6.h>

class DXGISwapChainWrapper : public IDXGISwapChain4 {
 public:
  explicit DXGISwapChainWrapper(IDXGISwapChain4* swapchain) : _swap_chain(swapchain) {}

  // IUnknown
  HRESULT STDMETHODCALLTYPE QueryInterface(REFIID riid, void** ppvObject) override {
    return _swap_chain->QueryInterface(riid, ppvObject);
  }
  ULONG STDMETHODCALLTYPE AddRef() override {
    return _swap_chain->AddRef();
  }
  ULONG STDMETHODCALLTYPE Release() override {
    return _swap_chain->Release();
  }

  // IDXGIObject
  HRESULT STDMETHODCALLTYPE SetPrivateData(REFGUID Name, UINT DataSize, const void* pData) override {
    return _swap_chain->SetPrivateData(Name, DataSize, pData);
  }
  HRESULT STDMETHODCALLTYPE SetPrivateDataInterface(REFGUID Name, const IUnknown* pUnknown) override {
    return _swap_chain->SetPrivateDataInterface(Name, pUnknown);
  }
  HRESULT STDMETHODCALLTYPE GetPrivateData(REFGUID Name, UINT* pDataSize, void* pData) override {
    return _swap_chain->GetPrivateData(Name, pDataSize, pData);
  }
  HRESULT STDMETHODCALLTYPE GetParent(REFIID riid, void** ppParent) override {
    return _swap_chain->GetParent(riid, ppParent);
  }

  // IDXGIDeviceSubObject
  HRESULT STDMETHODCALLTYPE GetDevice(REFIID riid, void** ppDevice) override {
    return _swap_chain->GetDevice(riid, ppDevice);
  }

  // IDXGISwapChain
  HRESULT STDMETHODCALLTYPE Present(UINT SyncInterval, UINT Flags) override {
    return _swap_chain->Present(SyncInterval, Flags);
  }
  HRESULT STDMETHODCALLTYPE GetBuffer(UINT Buffer, REFIID riid, void** ppSurface) override {
    return _swap_chain->GetBuffer(Buffer, riid, ppSurface);
  }
  HRESULT STDMETHODCALLTYPE SetFullscreenState(BOOL Fullscreen, IDXGIOutput* pTarget) override {
    return _swap_chain->SetFullscreenState(Fullscreen, pTarget);
  }
  HRESULT STDMETHODCALLTYPE GetFullscreenState(BOOL* pFullscreen, IDXGIOutput** ppTarget) override {
    return _swap_chain->GetFullscreenState(pFullscreen, ppTarget);
  }
  HRESULT STDMETHODCALLTYPE GetDesc(DXGI_SWAP_CHAIN_DESC* pDesc) override {
    return _swap_chain->GetDesc(pDesc);
  }
  HRESULT STDMETHODCALLTYPE ResizeBuffers(UINT BufferCount, UINT Width, UINT Height, DXGI_FORMAT NewFormat, UINT SwapChainFlags) override {
    return _swap_chain->ResizeBuffers(BufferCount, Width, Height, NewFormat, SwapChainFlags);
  }
  HRESULT STDMETHODCALLTYPE ResizeTarget(const DXGI_MODE_DESC* pNewTargetParameters) override {
    return _swap_chain->ResizeTarget(pNewTargetParameters);
  }
  HRESULT STDMETHODCALLTYPE GetContainingOutput(IDXGIOutput** ppOutput) override {
    return _swap_chain->GetContainingOutput(ppOutput);
  }
  HRESULT STDMETHODCALLTYPE GetFrameStatistics(DXGI_FRAME_STATISTICS* pStats) override {
    return _swap_chain->GetFrameStatistics(pStats);
  }
  HRESULT STDMETHODCALLTYPE GetLastPresentCount(UINT* pLastPresentCount) override {
    return _swap_chain->GetLastPresentCount(pLastPresentCount);
  }

  // IDXGISwapChain1
  HRESULT STDMETHODCALLTYPE GetDesc1(DXGI_SWAP_CHAIN_DESC1* pDesc) override {
    return _swap_chain->GetDesc1(pDesc);
  }
  HRESULT STDMETHODCALLTYPE GetFullscreenDesc(DXGI_SWAP_CHAIN_FULLSCREEN_DESC* pDesc) override {
    return _swap_chain->GetFullscreenDesc(pDesc);
  }
  HRESULT STDMETHODCALLTYPE GetHwnd(HWND* pHwnd) override {
    return _swap_chain->GetHwnd(pHwnd);
  }
  HRESULT STDMETHODCALLTYPE GetCoreWindow(REFIID refiid, void** ppUnk) override {
    return _swap_chain->GetCoreWindow(refiid, ppUnk);
  }
  HRESULT STDMETHODCALLTYPE Present1(UINT SyncInterval, UINT PresentFlags, const DXGI_PRESENT_PARAMETERS* pPresentParameters) override {
    return _swap_chain->Present1(SyncInterval, PresentFlags, pPresentParameters);
  }
  BOOL STDMETHODCALLTYPE IsTemporaryMonoSupported() override {
    return _swap_chain->IsTemporaryMonoSupported();
  }
  HRESULT STDMETHODCALLTYPE GetRestrictToOutput(IDXGIOutput** ppRestrictToOutput) override {
    return _swap_chain->GetRestrictToOutput(ppRestrictToOutput);
  }
  HRESULT STDMETHODCALLTYPE SetBackgroundColor(const DXGI_RGBA* pColor) override {
    return _swap_chain->SetBackgroundColor(pColor);
  }
  HRESULT STDMETHODCALLTYPE GetBackgroundColor(DXGI_RGBA* pColor) override {
    return _swap_chain->GetBackgroundColor(pColor);
  }
  HRESULT STDMETHODCALLTYPE SetRotation(DXGI_MODE_ROTATION Rotation) override {
    return _swap_chain->SetRotation(Rotation);
  }
  HRESULT STDMETHODCALLTYPE GetRotation(DXGI_MODE_ROTATION* pRotation) override {
    return _swap_chain->GetRotation(pRotation);
  }

  // IDXGISwapChain2
  HRESULT STDMETHODCALLTYPE SetSourceSize(UINT Width, UINT Height) override {
    return _swap_chain->SetSourceSize(Width, Height);
  }
  HRESULT STDMETHODCALLTYPE GetSourceSize(UINT* pWidth, UINT* pHeight) override {
    return _swap_chain->GetSourceSize(pWidth, pHeight);
  }
  HRESULT STDMETHODCALLTYPE SetMaximumFrameLatency(UINT MaxLatency) override {
    return _swap_chain->SetMaximumFrameLatency(MaxLatency);
  }
  HRESULT STDMETHODCALLTYPE GetMaximumFrameLatency(UINT* pMaxLatency) override {
    return _swap_chain->GetMaximumFrameLatency(pMaxLatency);
  }
  HANDLE STDMETHODCALLTYPE GetFrameLatencyWaitableObject() override {
    return _swap_chain->GetFrameLatencyWaitableObject();
  }
  HRESULT STDMETHODCALLTYPE SetMatrixTransform(const DXGI_MATRIX_3X2_F* pMatrix) override {
    return _swap_chain->SetMatrixTransform(pMatrix);
  }
  HRESULT STDMETHODCALLTYPE GetMatrixTransform(DXGI_MATRIX_3X2_F* pMatrix) override {
    return _swap_chain->GetMatrixTransform(pMatrix);
  }

  // IDXGISwapChain3
  UINT STDMETHODCALLTYPE GetCurrentBackBufferIndex() override {
    return _swap_chain->GetCurrentBackBufferIndex();
  }
  HRESULT STDMETHODCALLTYPE CheckColorSpaceSupport(DXGI_COLOR_SPACE_TYPE ColorSpace, UINT* pColorSpaceSupport) override {
    return _swap_chain->CheckColorSpaceSupport(ColorSpace, pColorSpaceSupport);
  }
  HRESULT STDMETHODCALLTYPE SetColorSpace1(DXGI_COLOR_SPACE_TYPE ColorSpace) override {
    return _swap_chain->SetColorSpace1(ColorSpace);
  }
  HRESULT STDMETHODCALLTYPE ResizeBuffers1(UINT BufferCount, UINT Width, UINT Height, DXGI_FORMAT Format, UINT SwapChainFlags, const UINT* pCreationNodeMask, IUnknown* const* ppPresentQueue) override {
    return _swap_chain->ResizeBuffers1(BufferCount, Width, Height, Format, SwapChainFlags, pCreationNodeMask, ppPresentQueue);
  }

  // IDXGISwapChain4
  HRESULT STDMETHODCALLTYPE SetHDRMetaData(DXGI_HDR_METADATA_TYPE Type, UINT Size, void* pMetaData) override {
    return _swap_chain->SetHDRMetaData(Type, Size, pMetaData);
  }

 private:
  IDXGISwapChain4* _swap_chain;
};