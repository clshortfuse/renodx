/*
 * Copyright (C) 2026 speedlemur
 * SPDX-License-Identifier: MIT
 *
 * control-rr: gives Streamline's frame generation the HDR10 buffers it
 * needs while the game keeps rendering into the FP16 format it asked for.
 *
 * Frame generation only accepts HDR10. Control asks for FP16 scRGB, and
 * every layer in between passes that request along unchanged, so generation
 * sits switched on and idle. Changing the format that reaches Streamline
 * makes it build RGB10A2 buffers and run.
 *
 * Two patches, both on Streamline's own objects:
 *
 *   1. Its FACTORY, so the swap chain it creates is RGB10A2.
 *   2. Its SWAP CHAIN's GetBuffer, so Control still receives an FP16 surface
 *      to draw into while Streamline's own code gets the real 10-bit one.
 *
 * Then once a frame, in Present, Control's surface is PQ-encoded into the
 * buffer Streamline is about to interpolate from. Doing it afterwards - which
 * is where a swap-chain conversion naturally lands - gives a correct picture
 * and no generated frames, because generation has already happened by then.
 *
 * Reaching Streamline: it is loaded through ntdll by whoever hosts it, so no
 * LoadLibrary hook sees it and every device-level event arrives too late. A
 * thread waits for the module, then detours slUpgradeInterface, the one call
 * every host makes to obtain a Streamline factory.
 *
 * The slot numbers below are COM, fixed for the life of the interfaces, not
 * anything specific to a driver or a Streamline build. Every entry is still
 * checked before it is written.
 */

#pragma once

#include <windows.h>
#include <intrin.h>
#include <detours.h>
#include <d3d12.h>
#include <dxgi1_4.h>
#include <dxgi1_6.h>  // IDXGIOutput6::GetDesc1, to log whether the display is in HDR

#include <atomic>
#include <mutex>
#include <thread>
#include <sstream>
#include <string>
#include <unordered_map>

#include <sl.h>
#include <sl_core_api.h>

#include <include/reshade.hpp>

namespace sl_hdr10 {

inline void Log(const std::string& msg) {
  control_diag::Mark(msg.c_str());
  reshade::log::message(reshade::log::level::info, ("sl-hdr10: " + msg).c_str());
}
inline void LogWarn(const std::string& msg) {
  control_diag::Mark(msg.c_str());
  reshade::log::message(reshade::log::level::warning, ("sl-hdr10: " + msg).c_str());
}

// COM vtable layout. IUnknown 0-2, IDXGIObject 3-6, then each interface adds
// its own methods in declaration order.
//   IDXGIFactory:  7 EnumAdapters, 8 MakeWindowAssociation,
//                  9 GetWindowAssociation, 10 CreateSwapChain
//   IDXGIFactory1: 12 EnumAdapters1, 13 IsCurrent
//   IDXGIFactory2: 14 IsWindowedStereoEnabled, 15 CreateSwapChainForHwnd
constexpr size_t kSlotCreateSwapChain = 10;
constexpr size_t kSlotCreateSwapChainForHwnd = 15;
//   IDXGIDeviceSubObject: 7 GetDevice
//   IDXGISwapChain: 8 Present, 9 GetBuffer ... 13 ResizeBuffers
//   IDXGISwapChain1: 22 Present1
constexpr size_t kSlotPresent = 8;
constexpr size_t kSlotGetBuffer = 9;
// A display-mode change destroys every buffer we hold; without this hook we
// keep drawing into freed resources and the game freezes on the first
// window/fullscreen switch.
constexpr size_t kSlotResizeBuffers = 13;
// Flip-model swap chains present through Present1, so patching only Present
// leaves the encode never running - a black screen with everything else
// reporting success.
constexpr size_t kSlotPresent1 = 22;
constexpr UINT kMaxBuffers = 8;

using PFN_CreateSwapChain = HRESULT(STDMETHODCALLTYPE*)(  //
    IDXGIFactory*, IUnknown*, DXGI_SWAP_CHAIN_DESC*, IDXGISwapChain**);
using PFN_CreateSwapChainForHwnd = HRESULT(STDMETHODCALLTYPE*)(  //
    IDXGIFactory2*, IUnknown*, HWND, const DXGI_SWAP_CHAIN_DESC1*,
    const DXGI_SWAP_CHAIN_FULLSCREEN_DESC*, IDXGIOutput*, IDXGISwapChain1**);
using PFN_GetBuffer = HRESULT(STDMETHODCALLTYPE*)(IDXGISwapChain*, UINT, REFIID, void**);
using PFN_Present = HRESULT(STDMETHODCALLTYPE*)(IDXGISwapChain*, UINT, UINT);
using PFN_Present1 = HRESULT(STDMETHODCALLTYPE*)(IDXGISwapChain1*, UINT, UINT,
                                                 const DXGI_PRESENT_PARAMETERS*);
using PFN_ResizeBuffers = HRESULT(STDMETHODCALLTYPE*)(IDXGISwapChain*, UINT, UINT, UINT,
                                                      DXGI_FORMAT, UINT);

inline PFN_CreateSwapChain real_create_swap_chain = nullptr;
inline PFN_CreateSwapChainForHwnd real_create_swap_chain_for_hwnd = nullptr;
inline PFN_GetBuffer real_get_buffer = nullptr;
inline PFN_Present real_present = nullptr;
inline PFN_Present1 real_present1 = nullptr;
inline PFN_ResizeBuffers real_resize_buffers = nullptr;

inline std::atomic<bool> enabled = false;
inline std::atomic<bool> swapchain_patched = false;

// Overwrite one vtable entry. The table is shared by every object of the
// class, so patching the factory handed to one host redirects them all.
inline bool PatchSlot(void** vtable, size_t slot, void* replacement, void** out_original) {
  DWORD old_protect = 0;
  if (VirtualProtect(&vtable[slot], sizeof(void*), PAGE_READWRITE, &old_protect) == 0) {
    return false;
  }
  *out_original = vtable[slot];
  vtable[slot] = replacement;
  DWORD ignored = 0;
  VirtualProtect(&vtable[slot], sizeof(void*), old_protect, &ignored);
  return true;
}

inline void PatchSwapChainVTable(IDXGISwapChain* swap_chain);

// A module's ProductName from its version resource, or empty. OptiScaler
// ships under whatever proxy name the user picked (dxgi, winmm, version,
// dbghelp...) but its resource always says "OptiScaler"; Streamline's says
// "NVIDIA STREAMLINE". version.dll is reached at runtime so the build wiring
// stays untouched.
inline std::wstring ModuleProductName(const wchar_t* path) {
  using PFN_Size = DWORD(WINAPI*)(LPCWSTR, LPDWORD);
  using PFN_Get = BOOL(WINAPI*)(LPCWSTR, DWORD, DWORD, LPVOID);
  using PFN_Query = BOOL(WINAPI*)(LPCVOID, LPCWSTR, LPVOID*, PUINT);
  static HMODULE version = LoadLibraryW(L"version.dll");
  if (version == nullptr) return {};
  static auto size_fn = reinterpret_cast<PFN_Size>(GetProcAddress(version, "GetFileVersionInfoSizeW"));
  static auto get_fn = reinterpret_cast<PFN_Get>(GetProcAddress(version, "GetFileVersionInfoW"));
  static auto query_fn = reinterpret_cast<PFN_Query>(GetProcAddress(version, "VerQueryValueW"));
  if (size_fn == nullptr || get_fn == nullptr || query_fn == nullptr) return {};

  DWORD handle = 0;
  const DWORD size = size_fn(path, &handle);
  if (size == 0) return {};
  std::string block(size, '\0');
  if (get_fn(path, 0, size, block.data()) == 0) return {};

  struct LangCodePage { WORD language; WORD code_page; };
  LangCodePage* translations = nullptr;
  UINT length = 0;
  if (query_fn(block.data(), L"\\VarFileInfo\\Translation",
               reinterpret_cast<void**>(&translations), &length) == 0
      || translations == nullptr || length < sizeof(LangCodePage)) {
    return {};
  }
  wchar_t key[64] = {};
  swprintf_s(key, L"\\StringFileInfo\\%04x%04x\\ProductName",
             translations[0].language, translations[0].code_page);
  wchar_t* value = nullptr;
  if (query_fn(block.data(), key, reinterpret_cast<void**>(&value), &length) == 0
      || value == nullptr) {
    return {};
  }
  return std::wstring(value);
}

// Control cannot render into a 10-bit target, so it must keep receiving the
// format it asked for. Streamline's own code must NOT - it is the one that
// has to see HDR10. The caller's module tells them apart: by file name for
// the fixed ones, by version resource for the proxy whose name the user
// chooses. Frame-generation callers must receive the real back buffer;
// returning a surrogate can cause incorrect output or device removal.
inline bool CallerIsStreamlineOrNvidia(void* return_address) {
  HMODULE module = nullptr;
  if (GetModuleHandleExW(
          GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS | GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,
          static_cast<LPCWSTR>(return_address), &module)
      == 0) {
    return false;
  }
  // One verdict per module for the life of the process; GetBuffer is hot.
  static std::mutex cache_mutex;
  static std::unordered_map<HMODULE, bool> cache;
  {
    const std::lock_guard lock(cache_mutex);
    const auto it = cache.find(module);
    if (it != cache.end()) return it->second;
  }

  wchar_t path[MAX_PATH] = {};
  if (GetModuleFileNameW(module, path, MAX_PATH) == 0) return false;
  const wchar_t* name = wcsrchr(path, L'\\');
  name = (name != nullptr) ? name + 1 : path;
  // Anything that is part of the frame-generation machinery gets the truth.
  bool machinery = _wcsnicmp(name, L"sl.", 3) == 0
                   || _wcsnicmp(name, L"nvngx", 5) == 0
                   || _wcsnicmp(name, L"OptiScaler", 10) == 0;
  if (!machinery) {
    const std::wstring product = ModuleProductName(path);
    machinery = product.find(L"OptiScaler") != std::wstring::npos
                || product.find(L"STREAMLINE") != std::wstring::npos
                || product.find(L"Streamline") != std::wstring::npos;
  }
  {
    std::wstring w(name);
    Log(std::string("GetBuffer caller ") + std::string(w.begin(), w.end())
        + (machinery ? " - gets the real back buffer" : " - gets the surrogate"));
    const std::lock_guard lock(cache_mutex);
    cache[module] = machinery;
  }
  return machinery;
}

// ---------------------------------------------------------------------------
// The surrogate.
//
// Streamline's buffers are 10-bit, and Control cannot draw into those - it
// writes linear scRGB, which read back as 10-bit integers is a mess on
// screen. So the renderer is handed a floating-point texture of our own and
// never learns the difference, while Streamline's own code keeps getting the
// real buffer. Once a frame, just before Present, ours is encoded into theirs.
//
// Control's renderer, d3d_rmdwin10_f.dll, requests indices 0 and 1 at startup
// and retains them. Frame-generation callers are handled separately.
// ---------------------------------------------------------------------------

struct Bridge {
  ID3D12Device* device = nullptr;
  ID3D12CommandQueue* queue = nullptr;
  IDXGISwapChain3* swap_chain = nullptr;

  ID3D12Resource* surrogate[kMaxBuffers] = {};
  ID3D12Resource* back_buffer[kMaxBuffers] = {};
  ID3D12DescriptorHeap* back_rtv_heap = nullptr;  // views onto Streamline's buffers
  ID3D12DescriptorHeap* srv_heap = nullptr;       // views onto the surrogates
  UINT rtv_stride = 0;
  UINT srv_stride = 0;

  ID3D12RootSignature* root_signature = nullptr;
  ID3D12PipelineState* pipeline = nullptr;
  ID3D12CommandAllocator* allocator[kMaxBuffers] = {};
  ID3D12GraphicsCommandList* command_list = nullptr;
  ID3D12Fence* fence = nullptr;
  HANDLE fence_event = nullptr;
  UINT64 fence_value = 0;
  UINT64 pending[kMaxBuffers] = {};  // last submission per allocator

  // The hud-less frame, PQ-encoded to match the back buffer. Frame generation
  // works out the UI by comparing the final colour against this one, so the
  // two have to be in the same encoding - handing it linear scRGB against a
  // PQ back buffer makes that comparison meaningless, and the nonsense lands
  // on edges under motion.
  ID3D12Resource* hudless_encoded = nullptr;
  ID3D12DescriptorHeap* hudless_rtv = nullptr;
  ID3D12DescriptorHeap* hudless_srv = nullptr;
  std::atomic<void*> hudless_source{nullptr};  // FP16 snapshot from the addon
  void* hudless_viewed = nullptr;              // what the SRV currently points at

  UINT buffer_count = 0;
  UINT width = 0;
  UINT height = 0;
  bool ready = false;
  bool failed = false;
  bool format_rewritten = false;
  void* rewritten_swap_chain = nullptr;
};

inline Bridge bridge;

// Everything the bridge owns, dropped. Called before a resize destroys the
// buffers underneath us, and it deliberately clears `failed` too so the next
// present rebuilds rather than staying broken for the rest of the session.
inline bool WaitForFence(UINT64 value, DWORD timeout_ms, const char* operation) {
  control_diag::Scope trace("bridge.wait_fence");
#if defined(CONTROL_RR_DEV) || defined(CONTROL_RR_DIAGNOSTICS)
  control_diag::Mark("bridge.fence.target_completed", value, bridge.fence != nullptr ? bridge.fence->GetCompletedValue() : 0);
#endif
  if (value == 0 || bridge.fence == nullptr || bridge.fence->GetCompletedValue() >= value) {
    return true;
  }
  if (bridge.fence_event == nullptr) {
    bridge.fence_event = CreateEventW(nullptr, FALSE, FALSE, nullptr);
  }
  if (bridge.fence_event == nullptr) {
    LogWarn(std::string(operation) + ": could not create fence event");
    return false;
  }
  if (FAILED(bridge.fence->SetEventOnCompletion(value, bridge.fence_event))) {
    LogWarn(std::string(operation) + ": SetEventOnCompletion failed");
    return false;
  }
  const DWORD wait = WaitForSingleObject(bridge.fence_event, timeout_ms);
  if (wait != WAIT_OBJECT_0) {
    std::stringstream s;
    s << operation << ": GPU fence wait failed (result 0x" << std::hex << wait << ")";
    LogWarn(s.str());
    return false;
  }
  return true;
}

inline bool WaitForBridgeIdle() {
  if (bridge.queue == nullptr || bridge.fence == nullptr) return true;
  const UINT64 value = ++bridge.fence_value;
  if (FAILED(bridge.queue->Signal(bridge.fence, value))) {
    LogWarn("bridge release: queue Signal failed");
    return false;
  }
  return WaitForFence(value, 2000, "bridge release");
}

inline bool ReleaseBridge() {
  control_diag::Scope trace("bridge.release");
  if (!WaitForBridgeIdle()) return false;
  dlssg_probe::Publish(dlssg_probe::hudless_buffer, nullptr, 0, 0, 0, 0);
  bridge.hudless_source.store(nullptr);
  for (auto*& r : bridge.surrogate) { if (r != nullptr) { r->Release(); r = nullptr; } }
  for (auto*& r : bridge.back_buffer) { if (r != nullptr) { r->Release(); r = nullptr; } }
  for (auto*& a : bridge.allocator) { if (a != nullptr) { a->Release(); a = nullptr; } }
  if (bridge.command_list != nullptr) { bridge.command_list->Release(); bridge.command_list = nullptr; }
  if (bridge.back_rtv_heap != nullptr) { bridge.back_rtv_heap->Release(); bridge.back_rtv_heap = nullptr; }
  if (bridge.srv_heap != nullptr) { bridge.srv_heap->Release(); bridge.srv_heap = nullptr; }
  if (bridge.pipeline != nullptr) { bridge.pipeline->Release(); bridge.pipeline = nullptr; }
  if (bridge.root_signature != nullptr) { bridge.root_signature->Release(); bridge.root_signature = nullptr; }
  if (bridge.fence != nullptr) { bridge.fence->Release(); bridge.fence = nullptr; }
  if (bridge.fence_event != nullptr) { CloseHandle(bridge.fence_event); bridge.fence_event = nullptr; }
  if (bridge.hudless_encoded != nullptr) { bridge.hudless_encoded->Release(); bridge.hudless_encoded = nullptr; }
  if (bridge.hudless_rtv != nullptr) { bridge.hudless_rtv->Release(); bridge.hudless_rtv = nullptr; }
  if (bridge.hudless_srv != nullptr) { bridge.hudless_srv->Release(); bridge.hudless_srv = nullptr; }
  bridge.hudless_viewed = nullptr;
  if (bridge.swap_chain != nullptr) { bridge.swap_chain->Release(); bridge.swap_chain = nullptr; }
  if (bridge.device != nullptr) { bridge.device->Release(); bridge.device = nullptr; }
  for (auto& p : bridge.pending) p = 0;
  bridge.buffer_count = 0;
  bridge.ready = false;
  bridge.failed = false;
  bridge.format_rewritten = false;
  bridge.rewritten_swap_chain = nullptr;
  return true;
}

inline bool BuildPipeline() {
  // One texture in, one colour out. The shader takes no constants, so the
  // signature is a single descriptor table plus a static sampler.
  D3D12_DESCRIPTOR_RANGE range = {};
  range.RangeType = D3D12_DESCRIPTOR_RANGE_TYPE_SRV;
  range.NumDescriptors = 1;
  range.BaseShaderRegister = 0;
  range.OffsetInDescriptorsFromTableStart = D3D12_DESCRIPTOR_RANGE_OFFSET_APPEND;

  D3D12_ROOT_PARAMETER param = {};
  param.ParameterType = D3D12_ROOT_PARAMETER_TYPE_DESCRIPTOR_TABLE;
  param.DescriptorTable.NumDescriptorRanges = 1;
  param.DescriptorTable.pDescriptorRanges = &range;
  param.ShaderVisibility = D3D12_SHADER_VISIBILITY_PIXEL;

  D3D12_STATIC_SAMPLER_DESC sampler = {};
  sampler.Filter = D3D12_FILTER_MIN_MAG_MIP_POINT;  // an exact copy, never resampled
  sampler.AddressU = D3D12_TEXTURE_ADDRESS_MODE_CLAMP;
  sampler.AddressV = D3D12_TEXTURE_ADDRESS_MODE_CLAMP;
  sampler.AddressW = D3D12_TEXTURE_ADDRESS_MODE_CLAMP;
  sampler.ShaderVisibility = D3D12_SHADER_VISIBILITY_PIXEL;

  D3D12_ROOT_SIGNATURE_DESC root_desc = {};
  root_desc.NumParameters = 1;
  root_desc.pParameters = &param;
  root_desc.NumStaticSamplers = 1;
  root_desc.pStaticSamplers = &sampler;
  root_desc.Flags = D3D12_ROOT_SIGNATURE_FLAG_ALLOW_INPUT_ASSEMBLER_INPUT_LAYOUT;

  // Resolved rather than linked: the addon does not import d3d12, and the
  // module is certainly loaded by the time we get here.
  using PFN_Serialize = HRESULT(WINAPI*)(const D3D12_ROOT_SIGNATURE_DESC*,
                                         D3D_ROOT_SIGNATURE_VERSION, ID3DBlob**, ID3DBlob**);
  HMODULE d3d12 = GetModuleHandleW(L"d3d12.dll");
  auto* serialize_root_signature =
      (d3d12 != nullptr)
          ? reinterpret_cast<PFN_Serialize>(GetProcAddress(d3d12, "D3D12SerializeRootSignature"))
          : nullptr;
  if (serialize_root_signature == nullptr) {
    LogWarn("no D3D12SerializeRootSignature - cannot build the bridge pipeline");
    return false;
  }

  ID3DBlob* serialized = nullptr;
  ID3DBlob* error = nullptr;
  if (FAILED(serialize_root_signature(&root_desc, D3D_ROOT_SIGNATURE_VERSION_1, &serialized,
                                      &error))) {
    if (error != nullptr) error->Release();
    LogWarn("could not serialize the bridge root signature");
    return false;
  }
  const auto hr = bridge.device->CreateRootSignature(0, serialized->GetBufferPointer(),
                                                     serialized->GetBufferSize(),
                                                     IID_PPV_ARGS(&bridge.root_signature));
  serialized->Release();
  if (error != nullptr) error->Release();
  if (FAILED(hr)) {
    LogWarn("could not create the bridge root signature");
    return false;
  }

  D3D12_GRAPHICS_PIPELINE_STATE_DESC pso = {};
  pso.pRootSignature = bridge.root_signature;
  pso.VS = {__swap_chain_proxy_vertex_shader.data(), __swap_chain_proxy_vertex_shader.size()};
  pso.PS = {__swap_chain_proxy_pixel_shader.data(), __swap_chain_proxy_pixel_shader.size()};
  pso.BlendState.RenderTarget[0].RenderTargetWriteMask = D3D12_COLOR_WRITE_ENABLE_ALL;
  pso.SampleMask = UINT_MAX;
  pso.RasterizerState.FillMode = D3D12_FILL_MODE_SOLID;
  pso.RasterizerState.CullMode = D3D12_CULL_MODE_NONE;
  pso.PrimitiveTopologyType = D3D12_PRIMITIVE_TOPOLOGY_TYPE_TRIANGLE;
  pso.NumRenderTargets = 1;
  pso.RTVFormats[0] = DXGI_FORMAT_R10G10B10A2_UNORM;
  pso.SampleDesc.Count = 1;
  if (FAILED(bridge.device->CreateGraphicsPipelineState(&pso, IID_PPV_ARGS(&bridge.pipeline)))) {
    LogWarn("could not create the bridge pipeline");
    return false;
  }
  return true;
}

inline bool EnsureBridge(IDXGISwapChain* swap_chain) {
  if (bridge.failed) return false;
  if (bridge.ready) return true;
  if (bridge.queue == nullptr) return false;  // captured when the chain was created

  IDXGISwapChain3* chain3 = nullptr;
  if (FAILED(swap_chain->QueryInterface(IID_PPV_ARGS(&chain3))) || chain3 == nullptr) {
    LogWarn("swap chain is not IDXGISwapChain3 - cannot tell which buffer is current");
    bridge.failed = true;
    return false;
  }
  bridge.swap_chain = chain3;

  DXGI_SWAP_CHAIN_DESC desc = {};
  if (FAILED(chain3->GetDesc(&desc))) {
    bridge.failed = true;
    return false;
  }
  // NOT desc.BufferCount: that reports what Control asked for (2), while
  // Streamline quietly builds more (6). Believing it left every frame past
  // index 1 unencoded, which is a black screen. Probe instead.
  bridge.width = desc.BufferDesc.Width;
  bridge.height = desc.BufferDesc.Height;
  bridge.buffer_count = 0;

  if (FAILED(bridge.queue->GetDevice(IID_PPV_ARGS(&bridge.device)))) {
    LogWarn("could not reach the device from the presenting queue");
    bridge.failed = true;
    return false;
  }

  // How many buffers there really are: ask for each in turn until refused.
  // GetBuffer is patched, so ask the ORIGINAL for the real 10-bit surface -
  // our own hook would hand back a surrogate and we would copy onto ourselves.
  for (UINT i = 0; i < kMaxBuffers; ++i) {
    ID3D12Resource* probe = nullptr;
    const HRESULT hr = real_get_buffer(chain3, i, __uuidof(ID3D12Resource),
                                       reinterpret_cast<void**>(&probe));
    if (FAILED(hr) || probe == nullptr) break;
    probe->Release();
    bridge.buffer_count = i + 1;
  }
  if (bridge.buffer_count == kMaxBuffers) {
    // Any buffer past the cap is never encoded: a picture that flickers
    // between frames and black, with nothing else reporting a problem.
    LogWarn("swap chain has MORE buffers than the bridge can hold - some frames will present black");
  }
  if (bridge.buffer_count == 0) {
    LogWarn("swap chain reports no buffers");
    bridge.failed = true;
    return false;
  }

  D3D12_DESCRIPTOR_HEAP_DESC rtv_desc = {};
  rtv_desc.Type = D3D12_DESCRIPTOR_HEAP_TYPE_RTV;
  rtv_desc.NumDescriptors = bridge.buffer_count;
  D3D12_DESCRIPTOR_HEAP_DESC srv_desc = {};
  srv_desc.Type = D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV;
  srv_desc.NumDescriptors = bridge.buffer_count;
  srv_desc.Flags = D3D12_DESCRIPTOR_HEAP_FLAG_SHADER_VISIBLE;
  if (FAILED(bridge.device->CreateDescriptorHeap(&rtv_desc, IID_PPV_ARGS(&bridge.back_rtv_heap)))
      || FAILED(bridge.device->CreateDescriptorHeap(&srv_desc, IID_PPV_ARGS(&bridge.srv_heap)))) {
    LogWarn("could not create the bridge descriptor heaps");
    bridge.failed = true;
    return false;
  }
  bridge.rtv_stride =
      bridge.device->GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_RTV);
  bridge.srv_stride =
      bridge.device->GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV);

  D3D12_HEAP_PROPERTIES heap = {};
  heap.Type = D3D12_HEAP_TYPE_DEFAULT;

  for (UINT i = 0; i < bridge.buffer_count; ++i) {
    if (FAILED(real_get_buffer(chain3, i, __uuidof(ID3D12Resource),
                               reinterpret_cast<void**>(&bridge.back_buffer[i])))) {
      LogWarn("could not read a back buffer");
      bridge.failed = true;
      return false;
    }
    D3D12_CPU_DESCRIPTOR_HANDLE back_rtv =
        bridge.back_rtv_heap->GetCPUDescriptorHandleForHeapStart();
    back_rtv.ptr += static_cast<SIZE_T>(i) * bridge.rtv_stride;
    bridge.device->CreateRenderTargetView(bridge.back_buffer[i], nullptr, back_rtv);

    // The surface Control believes is the back buffer: same size, the format
    // it asked for, and a render target because that is what it does with it.
    D3D12_RESOURCE_DESC tex = {};
    tex.Dimension = D3D12_RESOURCE_DIMENSION_TEXTURE2D;
    tex.Width = bridge.width;
    tex.Height = bridge.height;
    tex.DepthOrArraySize = 1;
    tex.MipLevels = 1;
    tex.Format = DXGI_FORMAT_R16G16B16A16_FLOAT;
    tex.SampleDesc.Count = 1;
    tex.Layout = D3D12_TEXTURE_LAYOUT_UNKNOWN;
    tex.Flags = D3D12_RESOURCE_FLAG_ALLOW_RENDER_TARGET;
    if (FAILED(bridge.device->CreateCommittedResource(
            &heap, D3D12_HEAP_FLAG_NONE, &tex, D3D12_RESOURCE_STATE_RENDER_TARGET, nullptr,
            IID_PPV_ARGS(&bridge.surrogate[i])))) {
      LogWarn("could not create a surrogate back buffer");
      bridge.failed = true;
      return false;
    }
    D3D12_CPU_DESCRIPTOR_HANDLE srv = bridge.srv_heap->GetCPUDescriptorHandleForHeapStart();
    srv.ptr += static_cast<SIZE_T>(i) * bridge.srv_stride;
    bridge.device->CreateShaderResourceView(bridge.surrogate[i], nullptr, srv);

    if (FAILED(bridge.device->CreateCommandAllocator(D3D12_COMMAND_LIST_TYPE_DIRECT,
                                                     IID_PPV_ARGS(&bridge.allocator[i])))) {
      LogWarn("could not create a bridge command allocator");
      bridge.failed = true;
      return false;
    }
  }

  {
    D3D12_RESOURCE_DESC tex = {};
    tex.Dimension = D3D12_RESOURCE_DIMENSION_TEXTURE2D;
    tex.Width = bridge.width;
    tex.Height = bridge.height;
    tex.DepthOrArraySize = 1;
    tex.MipLevels = 1;
    tex.Format = DXGI_FORMAT_R10G10B10A2_UNORM;
    tex.SampleDesc.Count = 1;
    tex.Layout = D3D12_TEXTURE_LAYOUT_UNKNOWN;
    tex.Flags = D3D12_RESOURCE_FLAG_ALLOW_RENDER_TARGET;
    D3D12_DESCRIPTOR_HEAP_DESC one_rtv = {};
    one_rtv.Type = D3D12_DESCRIPTOR_HEAP_TYPE_RTV;
    one_rtv.NumDescriptors = 1;
    D3D12_DESCRIPTOR_HEAP_DESC one_srv = {};
    one_srv.Type = D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV;
    one_srv.NumDescriptors = 1;
    one_srv.Flags = D3D12_DESCRIPTOR_HEAP_FLAG_SHADER_VISIBLE;
    if (FAILED(bridge.device->CreateCommittedResource(
            &heap, D3D12_HEAP_FLAG_NONE, &tex, D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE,
            nullptr, IID_PPV_ARGS(&bridge.hudless_encoded)))
        || FAILED(bridge.device->CreateDescriptorHeap(&one_rtv, IID_PPV_ARGS(&bridge.hudless_rtv)))
        || FAILED(bridge.device->CreateDescriptorHeap(&one_srv,
                                                      IID_PPV_ARGS(&bridge.hudless_srv)))) {
      LogWarn("could not create the hud-less encode target");
      bridge.failed = true;
      return false;
    }
    bridge.device->CreateRenderTargetView(bridge.hudless_encoded, nullptr,
                                          bridge.hudless_rtv->GetCPUDescriptorHandleForHeapStart());
  }

  if (!BuildPipeline()) {
    bridge.failed = true;
    return false;
  }
  if (FAILED(bridge.device->CreateCommandList(0, D3D12_COMMAND_LIST_TYPE_DIRECT,
                                              bridge.allocator[0], bridge.pipeline,
                                              IID_PPV_ARGS(&bridge.command_list)))) {
    LogWarn("could not create the bridge command list");
    bridge.failed = true;
    return false;
  }
  bridge.command_list->Close();
  if (FAILED(bridge.device->CreateFence(0, D3D12_FENCE_FLAG_NONE, IID_PPV_ARGS(&bridge.fence)))) {
    LogWarn("could not create the bridge fence");
    bridge.failed = true;
    return false;
  }

  // The format alone is not enough. Without this the display decodes our PQ
  // data as if it were sRGB, which reads as washed out with lifted blacks -
  // a coherent picture with the contrast gone.
  {
    UINT support = 0;
    const auto space = DXGI_COLOR_SPACE_RGB_FULL_G2084_NONE_P2020;
    const bool supported =
        SUCCEEDED(chain3->CheckColorSpaceSupport(space, &support))
        && (support & DXGI_SWAP_CHAIN_COLOR_SPACE_SUPPORT_FLAG_PRESENT) != 0;
    if (!supported) {
      LogWarn("display does not accept HDR10 on this swap chain - colours will be wrong");
    } else if (FAILED(chain3->SetColorSpace1(space))) {
      LogWarn("SetColorSpace1(HDR10) refused - colours will be wrong");
    }
    // What the OUTPUT is in, independent of what the chain accepts: a user
    // with Windows HDR off gets a coherent but wrong picture, and this is the
    // line that says so in their log.
    IDXGIOutput* output = nullptr;
    if (SUCCEEDED(chain3->GetContainingOutput(&output)) && output != nullptr) {
      IDXGIOutput6* output6 = nullptr;
      if (SUCCEEDED(output->QueryInterface(IID_PPV_ARGS(&output6))) && output6 != nullptr) {
        DXGI_OUTPUT_DESC1 out_desc = {};
        if (SUCCEEDED(output6->GetDesc1(&out_desc))) {
          std::stringstream o;
          o << "display colour space " << static_cast<int>(out_desc.ColorSpace)
            << (out_desc.ColorSpace == DXGI_COLOR_SPACE_RGB_FULL_G2084_NONE_P2020
                    ? " (HDR on)" : " (NOT HDR - Windows HDR is off for this display)")
            << ", max " << out_desc.MaxLuminance << " nits, chain accepts HDR10 = "
            << (supported ? "yes" : "NO");
          (supported && out_desc.ColorSpace == DXGI_COLOR_SPACE_RGB_FULL_G2084_NONE_P2020)
              ? Log(o.str()) : LogWarn(o.str());
        }
        output6->Release();
      }
      output->Release();
    }
  }

  bridge.ready = true;
  std::stringstream s;
  s << "bridge ready - " << bridge.buffer_count << " surrogates at " << bridge.width << "x"
    << bridge.height << ", PQ-encoded into RGB10A2 every present";
  Log(s.str());
  return true;
}

// Same PQ encode as the back buffer, applied to the hud-less frame so the two
// are directly comparable. The addon hands us its FP16 snapshot; what gets
// tagged is the 10-bit result. Recorded into the open command list.
inline void EncodeHudless() {
  auto* source = static_cast<ID3D12Resource*>(bridge.hudless_source.load());
  if (source == nullptr || bridge.hudless_encoded == nullptr) return;

  if (bridge.hudless_viewed != source) {
    bridge.device->CreateShaderResourceView(
        source, nullptr, bridge.hudless_srv->GetCPUDescriptorHandleForHeapStart());
    bridge.hudless_viewed = source;
  }

  D3D12_RESOURCE_BARRIER to_target = {};
  to_target.Transition.pResource = bridge.hudless_encoded;
  to_target.Transition.StateBefore = D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE;
  to_target.Transition.StateAfter = D3D12_RESOURCE_STATE_RENDER_TARGET;
  to_target.Transition.Subresource = D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;
  D3D12_RESOURCE_BARRIER back = to_target;
  back.Transition.StateBefore = D3D12_RESOURCE_STATE_RENDER_TARGET;
  back.Transition.StateAfter = D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE;

  bridge.command_list->ResourceBarrier(1, &to_target);
  const D3D12_CPU_DESCRIPTOR_HANDLE rtv =
      bridge.hudless_rtv->GetCPUDescriptorHandleForHeapStart();
  D3D12_VIEWPORT viewport = {0.f, 0.f, static_cast<float>(bridge.width),
                             static_cast<float>(bridge.height), 0.f, 1.f};
  D3D12_RECT scissor = {0, 0, static_cast<LONG>(bridge.width), static_cast<LONG>(bridge.height)};
  ID3D12DescriptorHeap* heaps[] = {bridge.hudless_srv};
  bridge.command_list->SetDescriptorHeaps(1, heaps);
  bridge.command_list->SetGraphicsRootDescriptorTable(
      0, bridge.hudless_srv->GetGPUDescriptorHandleForHeapStart());
  bridge.command_list->RSSetViewports(1, &viewport);
  bridge.command_list->RSSetScissorRects(1, &scissor);
  bridge.command_list->OMSetRenderTargets(1, &rtv, FALSE, nullptr);
  bridge.command_list->DrawInstanced(3, 1, 0, 0);
  bridge.command_list->ResourceBarrier(1, &back);
}

// Draw the surrogate into the real back buffer, on the queue that presents, so
// it has landed before frame generation looks at the frame.
inline void EncodeSurrogate() {
  control_diag::Scope trace("bridge.encode");
  // One index for both ends. Streamline's proxy hands the game a game-facing
  // index, and this is the buffer it is about to read as "the game's frame".
  // Measured: Control never calls GetCurrentBackBufferIndex - it alternates
  // 0/1 on a counter of its own that stays in phase with the chain because
  // both start at 0 and step once per present. Reading any other surrogate
  // handed generation a stale picture every second frame: F1 F1 F3 F3, which
  // shows as 150fps on a counter and a quiver on screen.
  const UINT index = bridge.swap_chain->GetCurrentBackBufferIndex();
  if (index >= bridge.buffer_count) {
    static std::atomic<int> logged = 0;
    if (logged.fetch_add(1) < 3) {
      std::stringstream s;
      s << "present index " << index << " is past the " << bridge.buffer_count
        << " surrogates - this frame presents UNENCODED";
      LogWarn(s.str());
    }
    return;
  }

  // Never reset allocator memory while the GPU can still be reading it.
  if (!WaitForFence(bridge.pending[index], 1000, "bridge encode")) return;

  // Ask for the destination fresh. Streamline manages its own buffers behind
  // GetBuffer; measured stable across a run, but a re-query costs nothing and
  // a stale target after a resize would be a silent black frame.
  {
    ID3D12Resource* destination = nullptr;
    real_get_buffer(bridge.swap_chain, index, __uuidof(ID3D12Resource),
                    reinterpret_cast<void**>(&destination));
    if (destination == nullptr) return;
    if (destination != bridge.back_buffer[index]) {
      if (bridge.back_buffer[index] != nullptr) bridge.back_buffer[index]->Release();
      bridge.back_buffer[index] = destination;  // keep the reference just handed to us
      D3D12_CPU_DESCRIPTOR_HANDLE fresh =
          bridge.back_rtv_heap->GetCPUDescriptorHandleForHeapStart();
      fresh.ptr += static_cast<SIZE_T>(index) * bridge.rtv_stride;
      bridge.device->CreateRenderTargetView(destination, nullptr, fresh);
    } else {
      destination->Release();  // we already hold a reference to this one
    }
  }

  if (FAILED(bridge.allocator[index]->Reset())) {
    LogWarn("bridge encode: command allocator Reset failed");
    bridge.failed = true;
    return;
  }
  if (FAILED(bridge.command_list->Reset(bridge.allocator[index], bridge.pipeline))) {
    LogWarn("bridge encode: command list Reset failed");
    bridge.failed = true;
    return;
  }

  D3D12_RESOURCE_BARRIER open[2] = {};
  open[0].Transition.pResource = bridge.surrogate[index];
  open[0].Transition.StateBefore = D3D12_RESOURCE_STATE_RENDER_TARGET;
  open[0].Transition.StateAfter = D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE;
  open[0].Transition.Subresource = D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;
  open[1].Transition.pResource = bridge.back_buffer[index];
  open[1].Transition.StateBefore = D3D12_RESOURCE_STATE_PRESENT;
  open[1].Transition.StateAfter = D3D12_RESOURCE_STATE_RENDER_TARGET;
  open[1].Transition.Subresource = D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;
  D3D12_RESOURCE_BARRIER shut[2] = {open[0], open[1]};
  shut[0].Transition.StateBefore = open[0].Transition.StateAfter;
  shut[0].Transition.StateAfter = open[0].Transition.StateBefore;
  shut[1].Transition.StateBefore = open[1].Transition.StateAfter;
  shut[1].Transition.StateAfter = open[1].Transition.StateBefore;

  D3D12_CPU_DESCRIPTOR_HANDLE rtv = bridge.back_rtv_heap->GetCPUDescriptorHandleForHeapStart();
  rtv.ptr += static_cast<SIZE_T>(index) * bridge.rtv_stride;
  D3D12_GPU_DESCRIPTOR_HANDLE srv = bridge.srv_heap->GetGPUDescriptorHandleForHeapStart();
  srv.ptr += static_cast<UINT64>(index) * bridge.srv_stride;

  D3D12_VIEWPORT viewport = {0.f, 0.f, static_cast<float>(bridge.width),
                             static_cast<float>(bridge.height), 0.f, 1.f};
  D3D12_RECT scissor = {0, 0, static_cast<LONG>(bridge.width), static_cast<LONG>(bridge.height)};

  bridge.command_list->ResourceBarrier(2, open);
  bridge.command_list->SetGraphicsRootSignature(bridge.root_signature);
  ID3D12DescriptorHeap* heaps[] = {bridge.srv_heap};
  bridge.command_list->SetDescriptorHeaps(1, heaps);
  bridge.command_list->SetGraphicsRootDescriptorTable(0, srv);
  bridge.command_list->RSSetViewports(1, &viewport);
  bridge.command_list->RSSetScissorRects(1, &scissor);
  bridge.command_list->OMSetRenderTargets(1, &rtv, FALSE, nullptr);
  bridge.command_list->IASetPrimitiveTopology(D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST);
  bridge.command_list->DrawInstanced(3, 1, 0, 0);
  EncodeHudless();
  bridge.command_list->ResourceBarrier(2, shut);
  if (FAILED(bridge.command_list->Close())) {
    LogWarn("bridge encode: command list Close failed");
    bridge.failed = true;
    return;
  }

  ID3D12CommandList* lists[] = {bridge.command_list};
  bridge.queue->ExecuteCommandLists(1, lists);
  if (FAILED(bridge.queue->Signal(bridge.fence, ++bridge.fence_value))) {
    LogWarn("bridge encode: queue Signal failed");
    bridge.failed = true;
    return;
  }
  bridge.pending[index] = bridge.fence_value;
}

inline void RunEncode(IDXGISwapChain* swap_chain) {
  if (!enabled.load()) return;
  if (!bridge.format_rewritten || bridge.rewritten_swap_chain != swap_chain) return;
  if (!EnsureBridge(swap_chain)) {
    // The format was already rewritten at creation, so there is no way back
    // to FP16 here: the game is drawing into a 10-bit surface nobody encodes.
    if (bridge.failed) {
      static std::atomic<int> logged = 0;
      if (logged.fetch_add(1) < 1) {
        LogWarn("bridge FAILED after the swap chain was already made 10-bit - "
                "the picture will be wrong for the rest of this session (see warnings above)");
      }
    }
    return;
  }
  EncodeSurrogate();
}

inline HRESULT STDMETHODCALLTYPE HookedResizeBuffers(IDXGISwapChain* swap_chain, UINT count,
                                                     UINT width, UINT height, DXGI_FORMAT format,
                                                     UINT flags) {
  control_diag::Scope trace("bridge.resize");
  control_diag::Mark("bridge.resize.dimensions", width, height);
  // Everything we hold refers to buffers that are about to stop existing.
  const bool rebuild = enabled.load() && bridge.format_rewritten
                       && bridge.rewritten_swap_chain == swap_chain;
  if (rebuild && !ReleaseBridge()) return DXGI_ERROR_WAS_STILL_DRAWING;
  if (rebuild && format == DXGI_FORMAT_R16G16B16A16_FLOAT) {
    format = DXGI_FORMAT_R10G10B10A2_UNORM;
  }
  const HRESULT result = real_resize_buffers(swap_chain, count, width, height, format, flags);
  control_diag::Mark("bridge.resize.result", static_cast<uint32_t>(result));
  // Rebuild before returning: Control requests its buffers immediately after
  // resizing and needs the FP16 surrogates for its linear output.
  if (rebuild) {
    bridge.format_rewritten = true;
    bridge.rewritten_swap_chain = swap_chain;
    EnsureBridge(swap_chain);
  }
  return result;
}

inline void LogPresentFailure(HRESULT result) {
  if (SUCCEEDED(result)) return;
  static std::atomic<HRESULT> logged_error = S_OK;
  if (logged_error.exchange(result) == result) return;
  std::stringstream message;
  message << "Present failed HRESULT=0x" << std::hex << static_cast<uint32_t>(result);
  if (bridge.device != nullptr) {
    message << " device removal reason=0x"
            << static_cast<uint32_t>(bridge.device->GetDeviceRemovedReason());
  }
  LogWarn(message.str());
}

inline HRESULT STDMETHODCALLTYPE HookedPresent(IDXGISwapChain* swap_chain, UINT sync_interval,
                                               UINT flags) {
  control_diag::Scope trace("bridge.present");
  RunEncode(swap_chain);
  const HRESULT result = real_present(swap_chain, sync_interval, flags);
  control_diag::Mark("bridge.present.result", static_cast<uint32_t>(result));
  LogPresentFailure(result);
  return result;
}

inline HRESULT STDMETHODCALLTYPE HookedPresent1(IDXGISwapChain1* swap_chain, UINT sync_interval,
                                                UINT flags,
                                                const DXGI_PRESENT_PARAMETERS* parameters) {
  control_diag::Scope trace("bridge.present1");
  RunEncode(swap_chain);
  const HRESULT result = real_present1(swap_chain, sync_interval, flags, parameters);
  control_diag::Mark("bridge.present1.result", static_cast<uint32_t>(result));
  LogPresentFailure(result);
  return result;
}

// Control gets its own floating-point surface; Streamline and NVIDIA keep the
// real 10-bit one.
inline HRESULT STDMETHODCALLTYPE HookedGetBuffer(IDXGISwapChain* swap_chain, UINT buffer,
                                                 REFIID riid, void** surface) {
  // Never answer the game without a bridge: the real buffer is 10-bit and
  // the game cannot render into it.
  const bool is_bridge_chain = enabled.load() && bridge.format_rewritten
                               && bridge.rewritten_swap_chain == swap_chain;
  if (is_bridge_chain && !bridge.ready && !bridge.failed) EnsureBridge(swap_chain);
  if (is_bridge_chain && bridge.ready && buffer < bridge.buffer_count
      && bridge.surrogate[buffer] != nullptr && !CallerIsStreamlineOrNvidia(_ReturnAddress())) {
    return bridge.surrogate[buffer]->QueryInterface(riid, surface);
  }
  return real_get_buffer(swap_chain, buffer, riid, surface);
}

inline bool RewriteFormat(DXGI_FORMAT& format) {
  if (!enabled.load()) return false;
  if (format != DXGI_FORMAT_R16G16B16A16_FLOAT) return false;
  format = DXGI_FORMAT_R10G10B10A2_UNORM;
  Log("swap chain requested as FP16, created as RGB10A2 for frame generation");
  return true;
}

inline HRESULT STDMETHODCALLTYPE HookedCreateSwapChain(IDXGIFactory* factory, IUnknown* device,
                                                       DXGI_SWAP_CHAIN_DESC* desc,
                                                       IDXGISwapChain** swap_chain) {
  bool can_rewrite = enabled.load() && desc != nullptr
                     && desc->BufferDesc.Format == DXGI_FORMAT_R16G16B16A16_FLOAT;
  if (can_rewrite && bridge.queue == nullptr) {
    // For D3D12 this parameter is the command queue that will present, which
    // is exactly the queue our encode has to be recorded on.
    if (device == nullptr || FAILED(device->QueryInterface(IID_PPV_ARGS(&bridge.queue)))) {
      LogWarn("swap-chain device is not a D3D12 command queue - leaving FP16 unchanged");
      can_rewrite = false;
    }
  }
  const bool rewritten = can_rewrite && RewriteFormat(desc->BufferDesc.Format);
  const auto hr = real_create_swap_chain(factory, device, desc, swap_chain);
  if (rewritten && SUCCEEDED(hr) && swap_chain != nullptr && *swap_chain != nullptr) {
    bridge.format_rewritten = true;
    bridge.rewritten_swap_chain = *swap_chain;
    PatchSwapChainVTable(*swap_chain);
    // Immediately, not at first present: Control asks for its buffers once at
    // start-up and keeps them. A surrogate that arrives later is never taken.
    EnsureBridge(*swap_chain);
  }
  return hr;
}

inline HRESULT STDMETHODCALLTYPE HookedCreateSwapChainForHwnd(
    IDXGIFactory2* factory, IUnknown* device, HWND hwnd, const DXGI_SWAP_CHAIN_DESC1* desc,
    const DXGI_SWAP_CHAIN_FULLSCREEN_DESC* fullscreen, IDXGIOutput* restrict_output,
    IDXGISwapChain1** swap_chain) {
  DXGI_SWAP_CHAIN_DESC1 patched = {};
  const DXGI_SWAP_CHAIN_DESC1* use = desc;
  bool can_rewrite = enabled.load() && desc != nullptr
                     && desc->Format == DXGI_FORMAT_R16G16B16A16_FLOAT;
  if (can_rewrite && bridge.queue == nullptr) {
    if (device == nullptr || FAILED(device->QueryInterface(IID_PPV_ARGS(&bridge.queue)))) {
      LogWarn("swap-chain device is not a D3D12 command queue - leaving FP16 unchanged");
      can_rewrite = false;
    }
  }
  if (desc != nullptr) {
    patched = *desc;
    if (can_rewrite) RewriteFormat(patched.Format);
    use = &patched;
  }
  const bool rewritten = desc != nullptr && patched.Format != desc->Format;
  const auto hr =
      real_create_swap_chain_for_hwnd(factory, device, hwnd, use, fullscreen, restrict_output,
                                      swap_chain);
  if (rewritten && SUCCEEDED(hr) && swap_chain != nullptr && *swap_chain != nullptr) {
    bridge.format_rewritten = true;
    bridge.rewritten_swap_chain = *swap_chain;
    PatchSwapChainVTable(*swap_chain);
    EnsureBridge(*swap_chain);
  }
  return hr;
}

inline void PatchSwapChainVTable(IDXGISwapChain* swap_chain) {
  if (swapchain_patched.load()) return;
  static std::mutex patch_mutex;
  const std::lock_guard patch_lock(patch_mutex);
  if (swapchain_patched.load()) return;
  // Confirm the object really is what the slot numbers assume before writing
  // into its table.
  IDXGISwapChain* verified = nullptr;
  if (FAILED(swap_chain->QueryInterface(__uuidof(IDXGISwapChain),
                                        reinterpret_cast<void**>(&verified)))
      || verified == nullptr) {
    LogWarn("swap chain does not answer to IDXGISwapChain - not patching it");
    return;
  }
  auto** vtable = *reinterpret_cast<void***>(verified);
  auto patch = [&](size_t slot, void* hook, void** real, const char* name) {
    void* original = nullptr;
    if (!PatchSlot(vtable, slot, hook, &original)) {
      LogWarn(std::string("could not patch IDXGISwapChain::") + name);
      return false;
    }
    if (original != hook) *real = original;
    return true;
  };
  const bool ok =
      patch(kSlotGetBuffer, reinterpret_cast<void*>(&HookedGetBuffer),
            reinterpret_cast<void**>(&real_get_buffer), "GetBuffer")
      && patch(kSlotPresent, reinterpret_cast<void*>(&HookedPresent),
               reinterpret_cast<void**>(&real_present), "Present")
      && patch(kSlotPresent1, reinterpret_cast<void*>(&HookedPresent1),
               reinterpret_cast<void**>(&real_present1), "Present1")
      && patch(kSlotResizeBuffers, reinterpret_cast<void*>(&HookedResizeBuffers),
               reinterpret_cast<void**>(&real_resize_buffers), "ResizeBuffers");
  if (ok) {
    swapchain_patched.store(true);
    Log("patched Streamline's swap chain: GetBuffer, Present, Present1, ResizeBuffers");
  }
  verified->Release();
}

// Every factory Streamline upgrades passes through here, including the one
// the host keeps. Patch whatever object comes back, not a class we guessed.
using PFN_slUpgradeInterface = sl::Result (*)(void**);
inline PFN_slUpgradeInterface real_upgrade_interface = nullptr;

inline void PatchFactoryVTable(void* factory) {
  if (factory == nullptr) return;
  static std::mutex patch_mutex;
  const std::lock_guard patch_lock(patch_mutex);
  auto** vtable = *reinterpret_cast<void***>(factory);
  static std::atomic<uintptr_t> patched_tables[8] = {};
  for (auto& slot : patched_tables) {
    if (slot.load() == reinterpret_cast<uintptr_t>(vtable)) return;  // already ours
  }
  void* original = nullptr;
  bool hwnd_ok = false;
  if (PatchSlot(vtable, kSlotCreateSwapChainForHwnd,
                reinterpret_cast<void*>(&HookedCreateSwapChainForHwnd), &original)) {
    if (original != reinterpret_cast<void*>(&HookedCreateSwapChainForHwnd)) {
      real_create_swap_chain_for_hwnd = reinterpret_cast<PFN_CreateSwapChainForHwnd>(original);
    }
    hwnd_ok = true;
  }
  original = nullptr;
  bool base_ok = false;
  if (PatchSlot(vtable, kSlotCreateSwapChain, reinterpret_cast<void*>(&HookedCreateSwapChain),
                &original)) {
    if (original != reinterpret_cast<void*>(&HookedCreateSwapChain)) {
      real_create_swap_chain = reinterpret_cast<PFN_CreateSwapChain>(original);
    }
    base_ok = true;
  }
  if (hwnd_ok && base_ok) {
    for (auto& slot : patched_tables) {
      uintptr_t expected = 0;
      if (slot.compare_exchange_strong(expected, reinterpret_cast<uintptr_t>(vtable))) break;
    }
    Log("patched Streamline's factory: CreateSwapChain, CreateSwapChainForHwnd");
  } else {
    LogWarn("could not patch Streamline's factory - frame generation will stay idle");
  }
}

inline sl::Result HookedUpgradeInterface(void** base_interface) {
  const auto result = real_upgrade_interface(base_interface);
  if (result == sl::Result::eOk && base_interface != nullptr && *base_interface != nullptr) {
    IDXGIFactory2* factory = nullptr;
    auto* object = static_cast<IUnknown*>(*base_interface);
    if (SUCCEEDED(object->QueryInterface(IID_PPV_ARGS(&factory))) && factory != nullptr) {
      PatchFactoryVTable(factory);
      factory->Release();
    }
  }
  return result;
}

// Just the watcher - everything of interest happens later, through the
// detour. Idempotent: detouring twice would detour our own hook onto itself,
// which overflows the stack with nothing in any log.
inline bool InstallUpgradeWatch() {
  static std::atomic<bool> installed = false;
  if (installed.load()) return true;
  HMODULE interposer = GetModuleHandleW(L"sl.interposer.dll");
  if (interposer == nullptr) return false;
  const std::lock_guard install_lock(control_rr::detour_mutex);
  if (installed.load()) return true;
  auto* upgrade =
      reinterpret_cast<PFN_slUpgradeInterface>(GetProcAddress(interposer, "slUpgradeInterface"));
  if (upgrade == nullptr) {
    LogWarn("sl.interposer.dll has no slUpgradeInterface");
    return false;
  }
  real_upgrade_interface = upgrade;
  LONG error = DetourTransactionBegin();
  const bool transaction_started = error == NO_ERROR;
  if (error == NO_ERROR) error = DetourUpdateThread(GetCurrentThread());
  if (error == NO_ERROR) {
    error = DetourAttach(reinterpret_cast<void**>(&real_upgrade_interface), HookedUpgradeInterface);
  }
  if (error != NO_ERROR) {
    if (transaction_started) DetourTransactionAbort();
  } else {
    error = DetourTransactionCommit();
  }
  if (error != NO_ERROR) {
    LogWarn("could not detour slUpgradeInterface");
    real_upgrade_interface = nullptr;
    return false;
  }
  installed.store(true);
  Log("watching slUpgradeInterface");
  return true;
}

// Poll for Streamline during a bounded startup window (6000 two-ms sleeps).
// If it does not appear, no upgrade hook is installed by this watcher.
inline void WatchForStreamline() {
  static std::atomic<bool> started = false;
  if (started.exchange(true)) return;
  std::thread([] {
    for (int attempt = 0; attempt < 6000; ++attempt) {
      if (InstallUpgradeWatch()) return;
      Sleep(2);
    }
  }).detach();
}

// Belt and braces from device events, in case the thread lost the race.
inline bool TryInstall() { return InstallUpgradeWatch(); }

}  // namespace sl_hdr10
