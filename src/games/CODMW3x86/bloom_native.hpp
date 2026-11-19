#pragma once
#include <Windows.h>
#include <d3d9.h>
#include <include/reshade.hpp>
#include <atomic>
#include <mutex>
#include "hook_transaction.hpp"

namespace mw3_bloom_native {
using DrawFn=HRESULT(WINAPI*)(IDirect3DDevice9*,D3DPRIMITIVETYPE,UINT,UINT);
using IndexedFn=HRESULT(WINAPI*)(IDirect3DDevice9*,D3DPRIMITIVETYPE,INT,UINT,UINT,UINT,UINT);
using UpFn=HRESULT(WINAPI*)(IDirect3DDevice9*,D3DPRIMITIVETYPE,UINT,const void*,UINT);
using IndexedUpFn=HRESULT(WINAPI*)(IDirect3DDevice9*,D3DPRIMITIVETYPE,UINT,UINT,UINT,const void*,D3DFORMAT,const void*,UINT);
DrawFn raw_draw=nullptr;IndexedFn raw_indexed=nullptr;UpFn raw_up=nullptr;IndexedUpFn raw_indexed_up=nullptr;
inline std::mutex mutex;
inline std::atomic<IDirect3DDevice9*> gpu = nullptr;
inline std::atomic<bool> installed = false;
inline void* targets[4]{};

template<class F> HRESULT Invoke(IDirect3DDevice9* d, F&& f) {
  mw3_bloom::NativeDrawScope scope(d);
  return f();
}
HRESULT WINAPI RawDraw(IDirect3DDevice9* d,D3DPRIMITIVETYPE t,UINT a,UINT b){return Invoke(d,[&]{return raw_draw(d,t,a,b);});}
HRESULT WINAPI RawIndexed(IDirect3DDevice9* d,D3DPRIMITIVETYPE t,INT a,UINT b,UINT c,UINT e,UINT f){return Invoke(d,[&]{return raw_indexed(d,t,a,b,c,e,f);});}
HRESULT WINAPI RawUp(IDirect3DDevice9* d,D3DPRIMITIVETYPE t,UINT a,const void* b,UINT c){return Invoke(d,[&]{return raw_up(d,t,a,b,c);});}
HRESULT WINAPI RawIndexedUp(IDirect3DDevice9* d,D3DPRIMITIVETYPE t,UINT a,UINT b,UINT c,const void* e,D3DFORMAT f,const void* g,UINT h){return Invoke(d,[&]{return raw_indexed_up(d,t,a,b,c,e,f,g,h);});}
inline void Init(reshade::api::device* device) {
  if (device->get_api() != reshade::api::device_api::d3d9) return;
  std::scoped_lock lock(mutex);
  auto* native = reinterpret_cast<IDirect3DDevice9*>(device->get_native());
  auto** vtable = *reinterpret_cast<void***>(native);
  if (installed.load()) {
    for (unsigned i=0; i<4; ++i) if (targets[i] != vtable[81+i]) return;
    if (gpu.load() == nullptr) gpu.store(native);
    return;
  }
  for (unsigned i=0; i<4; ++i) targets[i] = vtable[81+i];
  raw_draw = reinterpret_cast<DrawFn>(targets[0]);
  raw_indexed = reinterpret_cast<IndexedFn>(targets[1]);
  raw_up = reinterpret_cast<UpFn>(targets[2]);
  raw_indexed_up = reinterpret_cast<IndexedUpFn>(targets[3]);
  // Hooks live until process exit; pin this module so trampolines cannot outlive it.
  HMODULE pinned = nullptr;
  if (!GetModuleHandleExW(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS | GET_MODULE_HANDLE_EX_FLAG_PIN,
                         reinterpret_cast<LPCWSTR>(&RawDraw), &pinned)) return;
  LONG status = hook_transaction::Begin();
  if (status == NO_ERROR) {
    status = DetourAttach(reinterpret_cast<PVOID*>(&raw_draw), reinterpret_cast<PVOID>(&RawDraw));
    if (status == NO_ERROR) status = DetourAttach(reinterpret_cast<PVOID*>(&raw_indexed), reinterpret_cast<PVOID>(&RawIndexed));
    if (status == NO_ERROR) status = DetourAttach(reinterpret_cast<PVOID*>(&raw_up), reinterpret_cast<PVOID>(&RawUp));
    if (status == NO_ERROR) status = DetourAttach(reinterpret_cast<PVOID*>(&raw_indexed_up), reinterpret_cast<PVOID>(&RawIndexedUp));
    if (status == NO_ERROR) status = hook_transaction::Commit(); else hook_transaction::Abort();
  }
  if (status == NO_ERROR) {
    gpu.store(native);
    installed.store(true);
  }
  reshade::log::message(reshade::log::level::info, status == NO_ERROR
      ? "[MW3 x86 HDR Bloom] Native draw restoration ready; no bloom draw replay."
      : "[MW3 x86 HDR Bloom] Draw hooks unavailable; blend correction disabled.");
}
inline void Destroy(reshade::api::device* device) {
  auto* native = reinterpret_cast<IDirect3DDevice9*>(device->get_native());
  auto* expected = native;
  gpu.compare_exchange_strong(expected, nullptr);
}
inline bool Ready(reshade::api::command_list* cmd) {
  return installed.load() && cmd->get_device()->get_api() == reshade::api::device_api::d3d9
      && reinterpret_cast<IDirect3DDevice9*>(cmd->get_device()->get_native()) == gpu.load();
}
}
