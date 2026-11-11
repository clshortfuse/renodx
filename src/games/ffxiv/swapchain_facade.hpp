#pragma once

#include <d3d11.h>
#include <dxgi1_6.h>
#include <wrl/client.h>

#include <embed/shaders.h>

#include <array>
#include <atomic>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <cwchar>
#include <exception>
#include <mutex>
#include <new>
#include <shared_mutex>
#include <unordered_set>

#include <include/reshade.hpp>

#include "../../utils/dlss/DXGISwapChainWrapper.hpp"
#include "../../utils/log.hpp"
#include "../../utils/vtable.hpp"

// COM facade over the HDR10 swapchain. The application and ReShade see one logical
// FP16 scRGB buffer per index; Present encodes it into the physical RGB10A2 PQ buffer.
namespace renodx::games::ffxiv::swapchain_facade {

using Microsoft::WRL::ComPtr;
using CreateSwapChain = HRESULT(STDMETHODCALLTYPE*)(IDXGIFactory*, IUnknown*, DXGI_SWAP_CHAIN_DESC*, IDXGISwapChain**);

static constexpr GUID FACTORY_PROXY_ID{0x019778d4, 0xa03a, 0x7af4, {0xb8, 0x89, 0xe9, 0x23, 0x62, 0xd2, 0x02, 0x38}};
static constexpr GUID SWAPCHAIN_PROXY_ID{0x1f445f9f, 0x9887, 0x4c4c, {0x90, 0x55, 0x4e, 0x3b, 0xad, 0xaf, 0xcc, 0xa8}};
static constexpr GUID OPTISCALER_ID{0x23b064bb, 0x482d, 0x416c, {0x93, 0xb1, 0x82, 0x9a, 0xce, 0xdf, 0xb3, 0xd0}};
// Special K swapchain color-space private data, also written by utils::swapchain::ChangeColorSpace.
static constexpr GUID COLOR_SPACE_ID{0x018b57e4, 0x1493, 0x4953, {0xad, 0xf2, 0xde, 0x6d, 0x99, 0xcc, 0x05, 0xe5}};

static std::atomic_bool logging_enabled = false;
static std::atomic_uint32_t live_objects = 0;
static std::shared_mutex hook_mutex;
static bool accepting = false;
static CreateSwapChain original = nullptr;
// Retain the forwarding address after unhook for calls already dispatched to us.
static CreateSwapChain forward_entry = nullptr;
static utils::vtable::Slot<CreateSwapChain> slot;
static ComPtr<IDXGIFactory> retained_factory;
// Non-owning identities: remove at destroy_device, without keeping devices alive.
static std::unordered_set<IUnknown*> devices;
// Creation depth on this thread; a result produced inside an outer creation is nested.
static thread_local uint32_t hook_depth = 0;

template <typename... Args>
inline void Log(Args&&... args) noexcept {
  if (!logging_enabled.load()) return;
  try {
    utils::log::i("[FFXIV Facade] ", std::forward<Args>(args)...);
  } catch (...) {
    // Diagnostics must not throw across a COM boundary.
  }
}

// Late encoding of the logical scRGB buffer into the physical RGB10A2 buffer.
enum class OutputEncoding : uint32_t {
  HDR10_PQ,
  SDR_GAMMA22,
};

inline DXGI_COLOR_SPACE_TYPE PhysicalColorSpace(OutputEncoding encoding) {
  return (encoding == OutputEncoding::SDR_GAMMA22 ? DXGI_COLOR_SPACE_RGB_FULL_G22_NONE_P709
                                                  : DXGI_COLOR_SPACE_RGB_FULL_G2084_NONE_P2020);
}

inline const char* EncodingName(OutputEncoding encoding) {
  return (encoding == OutputEncoding::SDR_GAMMA22 ? "sdr_g22" : "hdr10_pq");
}

// Reuse the complete DXGI forwarding implementation, replacing its non-owning
// IUnknown behavior. Only insert for inners supporting all versions.
class DECLSPEC_UUID("6E1F3A52-9C4B-4D7E-A2B8-3F05C7D19E64") ForwardingSwapchain final : public DXGISwapChainWrapper {
 public:
  ForwardingSwapchain(IDXGISwapChain4* inner, const char* source)
      : DXGISwapChainWrapper(inner), inner_(inner), source_(source) {
    ++live_objects;
    Log("CREATE facade=", this, " inner=", inner, " source=", source, " refs=1 live=", live_objects.load());
  }

  HRESULT STDMETHODCALLTYPE QueryInterface(REFIID iid, void** output) override {
    if (output == nullptr) return E_POINTER;
    *output = nullptr;
    if (iid == __uuidof(IUnknown) || iid == __uuidof(IDXGIObject)
        || iid == __uuidof(IDXGIDeviceSubObject) || iid == __uuidof(IDXGISwapChain)
        || iid == __uuidof(IDXGISwapChain1) || iid == __uuidof(IDXGISwapChain2)
        || iid == __uuidof(IDXGISwapChain3) || iid == __uuidof(IDXGISwapChain4)
        || iid == __uuidof(ForwardingSwapchain)) {
      *output = static_cast<IDXGISwapChain4*>(this);
      AddRef();
      return S_OK;
    }
    // Never return an inner interface with a different controlling IUnknown.
    if (++unknown_queries_ <= 16) {
      char guid[40]{};
      std::snprintf(guid, sizeof(guid), "%08lx-%04x-%04x-%02x%02x-%02x%02x%02x%02x%02x%02x",
                    iid.Data1, iid.Data2, iid.Data3, iid.Data4[0], iid.Data4[1], iid.Data4[2], iid.Data4[3],
                    iid.Data4[4], iid.Data4[5], iid.Data4[6], iid.Data4[7]);
      Log("QI_UNSUPPORTED facade=", this, " iid=", guid);
    }
    return E_NOINTERFACE;
  }

  ULONG STDMETHODCALLTYPE AddRef() override { return ++references_; }
  ULONG STDMETHODCALLTYPE Release() override {
    const ULONG remaining = --references_;
    if (remaining == 0) delete this;
    return remaining;
  }

  // Runs once before the facade is published. On failure the caller releases the
  // facade and returns the original swapchain, keeping the upstream route.
  HRESULT InitializeComposition() {
    std::unique_lock lock(buffers_mutex_);
    auto result = inner_->GetDevice(IID_PPV_ARGS(&device_));
    if (FAILED(result)) return result;
    result = device_->CreateDeferredContext(0, &conversion_context_);
    if (FAILED(result)) return result;
    result = device_->CreateVertexShader(__final_vertex_shader.data(), __final_vertex_shader.size(), nullptr, &conversion_vs_);
    if (FAILED(result)) return result;
    result = device_->CreatePixelShader(__present_pq.data(), __present_pq.size(), nullptr, &conversion_pq_ps_);
    if (FAILED(result)) return result;
    result = device_->CreatePixelShader(__present_sdr.data(), __present_sdr.size(), nullptr, &conversion_sdr_ps_);
    if (FAILED(result)) return result;
    result = inner_->SetColorSpace1(PhysicalColorSpace(applied_encoding_.load()));
    if (FAILED(result)) return result;
    return buffers_result_ = CreateLogicalBuffers();
  }

  bool IsCompositionReady() {
    std::shared_lock lock(buffers_mutex_);
    return SUCCEEDED(buffers_result_);
  }

  // Encoding the addon composed the current frame with; applied at the next Present.
  void SetFrameEncoding(OutputEncoding encoding) { frame_encoding_ = encoding; }

  // Encoding of the physical color space and late conversion; persists across resize.
  OutputEncoding AppliedEncoding() const { return applied_encoding_.load(); }

  // True once after Present failed to apply the frame encoding.
  bool TakeSwitchFailure() { return switch_failed_.exchange(false); }

  bool SupportsEncoding(OutputEncoding encoding) {
    UINT support = 0;
    return SUCCEEDED(inner_->CheckColorSpaceSupport(PhysicalColorSpace(encoding), &support))
           && (support & DXGI_SWAP_CHAIN_COLOR_SPACE_SUPPORT_FLAG_PRESENT) != 0;
  }

  HRESULT STDMETHODCALLTYPE GetPrivateData(REFGUID id, UINT* size, void* data) override {
    if (id != COLOR_SPACE_ID) return inner_->GetPrivateData(id, size, data);
    if (size == nullptr) return E_INVALIDARG;
    const UINT capacity = *size;
    *size = sizeof(DXGI_COLOR_SPACE_TYPE);
    if (data == nullptr) return S_OK;
    if (capacity < *size) return DXGI_ERROR_MORE_DATA;
    *static_cast<DXGI_COLOR_SPACE_TYPE*>(data) = DXGI_COLOR_SPACE_RGB_FULL_G10_NONE_P709;
    return S_OK;
  }

  HRESULT STDMETHODCALLTYPE SetPrivateData(REFGUID id, UINT size, const void* data) override {
    if (id == COLOR_SPACE_ID) {
      return (size == 0 || (size == sizeof(DXGI_COLOR_SPACE_TYPE) && data != nullptr)) ? S_OK : E_INVALIDARG;
    }
    return inner_->SetPrivateData(id, size, data);
  }

  HRESULT STDMETHODCALLTYPE CheckColorSpaceSupport(DXGI_COLOR_SPACE_TYPE color, UINT* support) override {
    if (support == nullptr) return E_POINTER;
    *support = (color == DXGI_COLOR_SPACE_RGB_FULL_G10_NONE_P709 ? DXGI_SWAP_CHAIN_COLOR_SPACE_SUPPORT_FLAG_PRESENT : 0);
    return S_OK;
  }

  // The physical PQ color space is owned by the facade; the logical buffer is scRGB only.
  HRESULT STDMETHODCALLTYPE SetColorSpace1(DXGI_COLOR_SPACE_TYPE color) override {
    return (color == DXGI_COLOR_SPACE_RGB_FULL_G10_NONE_P709 ? S_OK : DXGI_ERROR_UNSUPPORTED);
  }

  HRESULT STDMETHODCALLTYPE GetDesc(DXGI_SWAP_CHAIN_DESC* desc) override {
    std::shared_lock lock(buffers_mutex_);
    const auto result = inner_->GetDesc(desc);
    if (SUCCEEDED(result) && desc != nullptr) {
      desc->BufferDesc.Format = DXGI_FORMAT_R16G16B16A16_FLOAT;
      desc->BufferUsage |= DXGI_USAGE_RENDER_TARGET_OUTPUT | DXGI_USAGE_SHADER_INPUT;
    }
    return result;
  }

  HRESULT STDMETHODCALLTYPE GetDesc1(DXGI_SWAP_CHAIN_DESC1* desc) override {
    std::shared_lock lock(buffers_mutex_);
    const auto result = inner_->GetDesc1(desc);
    if (SUCCEEDED(result) && desc != nullptr) {
      desc->Format = DXGI_FORMAT_R16G16B16A16_FLOAT;
      desc->BufferUsage |= DXGI_USAGE_RENDER_TARGET_OUTPUT | DXGI_USAGE_SHADER_INPUT;
    }
    return result;
  }

  HRESULT STDMETHODCALLTYPE GetBuffer(UINT index, REFIID iid, void** output) override {
    if (output == nullptr) return E_POINTER;
    *output = nullptr;
    std::shared_lock lock(buffers_mutex_);
    if (FAILED(buffers_result_)) return buffers_result_;
    if (index >= buffers_.size()) return DXGI_ERROR_INVALID_CALL;
    if (FAILED(buffers_[index].result)) return buffers_[index].result;
    const auto result = buffers_[index].texture->QueryInterface(iid, output);
    if (++buffer_queries_ <= 4) {
      Log("GET_BUFFER facade=", this, " generation=", generation_.load(), " index=", index,
          " logical=", buffers_[index].texture.Get(), " hr=", utils::log::AsHex(result));
    }
    return result;
  }

  HRESULT STDMETHODCALLTYPE Present(UINT interval, UINT flags) override {
    std::unique_lock lock(buffers_mutex_);
    if ((flags & DXGI_PRESENT_TEST) == 0) {
      const auto conversion = ConvertForPresent();
      if (FAILED(conversion)) return conversion;
    }
    const auto result = inner_->Present(interval, flags);
    const auto count = ++presents_;
    if (count == 1 || (FAILED(result) && ++present_failures_ <= 8)) {
      Log("PRESENT facade=", this, " count=", count, " flags=", flags, " hr=", utils::log::AsHex(result));
    }
    return result;
  }

  HRESULT STDMETHODCALLTYPE Present1(UINT interval, UINT flags, const DXGI_PRESENT_PARAMETERS* params) override {
    std::unique_lock lock(buffers_mutex_);
    const bool test = (flags & DXGI_PRESENT_TEST) != 0;
    if (!test) {
      const auto conversion = ConvertForPresent();
      if (FAILED(conversion)) return conversion;
    }
    // The conversion rewrites the whole physical buffer, so dirty/scroll rects no longer apply.
    const DXGI_PRESENT_PARAMETERS full_frame{};
    const auto result = inner_->Present1(interval, flags, (test || params == nullptr) ? params : &full_frame);
    const auto count = ++presents1_;
    if (count == 1 || (FAILED(result) && ++present_failures_ <= 8)) {
      Log("PRESENT1 facade=", this, " count=", count, " flags=", flags, " hr=", utils::log::AsHex(result));
    }
    return result;
  }

  HRESULT STDMETHODCALLTYPE ResizeBuffers(UINT count, UINT width, UINT height, DXGI_FORMAT format, UINT flags) override {
    return ResizeLogicalBuffers(count, width, height, format, flags, false, nullptr, nullptr);
  }

  HRESULT STDMETHODCALLTYPE ResizeBuffers1(UINT count, UINT width, UINT height, DXGI_FORMAT format, UINT flags,
                                          const UINT* masks, IUnknown* const* queues) override {
    return ResizeLogicalBuffers(count, width, height, format, flags, true, masks, queues);
  }

 private:
  struct LogicalBuffer {
    ComPtr<ID3D11Texture2D> texture;
    HRESULT result = DXGI_ERROR_INVALID_CALL;
  };

  // Encodes the current logical scRGB buffer into the physical buffer (BT.2020/PQ
  // or gamma 2.2/BT.709): after ReShade effects/GUI, before the inner Present.
  HRESULT ConvertForPresent() {
    auto fail = [&](HRESULT result) {
      if (++conversion_failures_ <= 8) {
        Log("ENCODE_FAILED facade=", this, " generation=", generation_.load(), " hr=", utils::log::AsHex(result));
      }
      return result;
    };
    if (FAILED(buffers_result_)) return fail(buffers_result_);
    const UINT index = inner_->GetCurrentBackBufferIndex();
    if (index >= buffers_.size() || buffers_[index].texture == nullptr) return fail(DXGI_ERROR_INVALID_CALL);
    ComPtr<ID3D11Texture2D> physical;
    auto result = inner_->GetBuffer(index, IID_PPV_ARGS(&physical));
    if (FAILED(result)) return fail(result);
    D3D11_TEXTURE2D_DESC logical_desc{};
    D3D11_TEXTURE2D_DESC physical_desc{};
    buffers_[index].texture->GetDesc(&logical_desc);
    physical->GetDesc(&physical_desc);
    if (logical_desc.SampleDesc.Count != 1 || physical_desc.SampleDesc.Count != 1
        || logical_desc.Width != physical_desc.Width || logical_desc.Height != physical_desc.Height
        || physical_desc.Format != DXGI_FORMAT_R10G10B10A2_UNORM) return fail(DXGI_ERROR_UNSUPPORTED);
    ComPtr<ID3D11ShaderResourceView> logical_srv;
    ComPtr<ID3D11RenderTargetView> physical_rtv;
    result = device_->CreateShaderResourceView(buffers_[index].texture.Get(), nullptr, &logical_srv);
    if (FAILED(result)) return fail(result);
    result = device_->CreateRenderTargetView(physical.Get(), nullptr, &physical_rtv);
    if (FAILED(result)) return fail(result);
    // Switch the physical color space together with the encoding. On failure keep
    // encoding with the applied color space, so the two never disagree.
    const auto frame_encoding = frame_encoding_.load();
    const auto previous_encoding = applied_encoding_.load();
    if (frame_encoding != previous_encoding) {
      const auto switched = inner_->SetColorSpace1(PhysicalColorSpace(frame_encoding));
      if (SUCCEEDED(switched)) {
        applied_encoding_ = frame_encoding;
        Log("ENCODING_SWITCH facade=", this, " from=", EncodingName(previous_encoding),
            " to=", EncodingName(frame_encoding), " color_space=", static_cast<UINT>(PhysicalColorSpace(frame_encoding)));
      } else {
        switch_failed_ = true;
        if (++switch_failures_ <= 8) {
          Log("ENCODING_SWITCH_FAILED facade=", this, " from=", EncodingName(previous_encoding),
              " to=", EncodingName(frame_encoding), " hr=", utils::log::AsHex(switched));
        }
      }
    }
    const auto encoding = applied_encoding_.load();
    const auto& pixel_shader = (encoding == OutputEncoding::SDR_GAMMA22 ? conversion_sdr_ps_ : conversion_pq_ps_);
    conversion_context_->ClearState();
    conversion_context_->IASetPrimitiveTopology(D3D11_PRIMITIVE_TOPOLOGY_TRIANGLELIST);
    conversion_context_->VSSetShader(conversion_vs_.Get(), nullptr, 0);
    conversion_context_->PSSetShader(pixel_shader.Get(), nullptr, 0);
    conversion_context_->PSSetShaderResources(0, 1, logical_srv.GetAddressOf());
    conversion_context_->OMSetRenderTargets(1, physical_rtv.GetAddressOf(), nullptr);
    const D3D11_VIEWPORT viewport{
        .TopLeftX = 0.f,
        .TopLeftY = 0.f,
        .Width = static_cast<float>(logical_desc.Width),
        .Height = static_cast<float>(logical_desc.Height),
        .MinDepth = 0.f,
        .MaxDepth = 1.f,
    };
    conversion_context_->RSSetViewports(1, &viewport);
    conversion_context_->Draw(3, 0);
    ComPtr<ID3D11CommandList> commands;
    result = conversion_context_->FinishCommandList(FALSE, &commands);
    conversion_context_->ClearState();
    if (FAILED(result)) return fail(result);
    ComPtr<ID3D11DeviceContext> immediate_context;
    device_->GetImmediateContext(&immediate_context);
    // Restore all immediate-context state before the inner swapchain consumes the frame.
    immediate_context->ExecuteCommandList(commands.Get(), TRUE);
    if (converted_generation_ != generation_.load() || converted_encoding_ != encoding) {
      converted_generation_ = generation_.load();
      converted_encoding_ = encoding;
      Log("ENCODE_SUBMITTED facade=", this, " generation=", converted_generation_, " index=", index,
          " logical=", buffers_[index].texture.Get(), " physical=", physical.Get(), " encoding=", EncodingName(encoding));
    }
    return S_OK;
  }

  HRESULT CreateLogicalBuffers() {
    DXGI_SWAP_CHAIN_DESC desc{};
    auto result = inner_->GetDesc(&desc);
    if (FAILED(result)) return result;
    if (desc.BufferDesc.Format != DXGI_FORMAT_R10G10B10A2_UNORM || desc.BufferCount == 0
        || desc.BufferCount > buffers_.size() || (desc.Flags & DXGI_SWAP_CHAIN_FLAG_GDI_COMPATIBLE) != 0) {
      return DXGI_ERROR_UNSUPPORTED;
    }
    std::array<LogicalBuffer, 16> pending;
    std::array<ComPtr<ID3D11Texture2D>, 16> physical;
    for (UINT index = 0; index < desc.BufferCount; ++index) {
      result = inner_->GetBuffer(index, IID_PPV_ARGS(&physical[index]));
      pending[index].result = result;
      if (FAILED(result)) {
        // D3D11 flip-model chains may expose only buffer 0; mirror that per index.
        if (index != 0 && result == DXGI_ERROR_INVALID_CALL) continue;
        return result;
      }
      for (UINT previous = 0; previous < index; ++previous) {
        if (physical[previous].Get() == physical[index].Get()) {
          pending[index].texture = pending[previous].texture;
          break;
        }
      }
      if (pending[index].texture == nullptr) {
        D3D11_TEXTURE2D_DESC texture_desc{};
        physical[index]->GetDesc(&texture_desc);
        texture_desc.Format = DXGI_FORMAT_R16G16B16A16_FLOAT;
        texture_desc.BindFlags |= D3D11_BIND_RENDER_TARGET | D3D11_BIND_SHADER_RESOURCE;
        texture_desc.MiscFlags = 0;
        result = device_->CreateTexture2D(&texture_desc, nullptr, &pending[index].texture);
        if (FAILED(result)) return result;
      }
      Log("FP16_BUFFER facade=", this, " generation=", generation_.load(), " index=", index,
          " logical=", pending[index].texture.Get(), " physical=", physical[index].Get(),
          " size=", desc.BufferDesc.Width, "x", desc.BufferDesc.Height, " logical_format=10 physical_format=24");
    }
    buffers_ = std::move(pending);
    return S_OK;
  }

  HRESULT ResizeLogicalBuffers(UINT count, UINT width, UINT height, DXGI_FORMAT format, UINT flags,
                               bool version1, const UINT* masks, IUnknown* const* queues) {
    std::unique_lock lock(buffers_mutex_);
    if (format != DXGI_FORMAT_UNKNOWN && format != DXGI_FORMAT_R16G16B16A16_FLOAT
        && format != DXGI_FORMAT_R10G10B10A2_UNORM) return DXGI_ERROR_INVALID_CALL;
    // DXGI fails a resize while buffers are referenced; apply that to the logical buffers.
    for (const auto& buffer : buffers_) {
      if (buffer.texture == nullptr) continue;
      ULONG owned = 0;
      for (const auto& alias : buffers_) owned += (alias.texture.Get() == buffer.texture.Get() ? 1 : 0);
      buffer.texture->AddRef();
      const ULONG references = buffer.texture->Release();
      if (references != owned) {
        Log("RESIZE_REFERENCED facade=", this, " logical=", buffer.texture.Get(), " refs=", references, " owned=", owned);
        return DXGI_ERROR_INVALID_CALL;
      }
    }
    Log("RESIZE_BEGIN facade=", this, " method=", (version1 ? "ResizeBuffers1" : "ResizeBuffers"), " count=", count,
        " size=", width, "x", height, " format=", static_cast<UINT>(format), " physical_format=24 flags=", flags);
    auto result = (version1
                       ? inner_->ResizeBuffers1(count, width, height, DXGI_FORMAT_R10G10B10A2_UNORM, flags, masks, queues)
                       : inner_->ResizeBuffers(count, width, height, DXGI_FORMAT_R10G10B10A2_UNORM, flags));
    if (SUCCEEDED(result)) {
      ++generation_;
      buffer_queries_ = 0;
      buffers_ = {};
      result = buffers_result_ = CreateLogicalBuffers();
      if (SUCCEEDED(result)) {
        result = inner_->SetColorSpace1(PhysicalColorSpace(applied_encoding_.load()));
      }
    }
    Log("RESIZE_END facade=", this, " generation=", generation_.load(), " ready=", SUCCEEDED(buffers_result_),
        " encoding=", EncodingName(applied_encoding_.load()),
        " hr=", utils::log::AsHex(result));
    return result;
  }

  ~ForwardingSwapchain() {
    Log("DESTROY facade=", this, " inner=", inner_.Get(), " source=", source_, " refs=0 presents=", presents_.load(),
        " presents1=", presents1_.load(), " generations=", generation_.load());
    buffers_ = {};
    Log("RELEASED_FP16 facade=", this);
    inner_.Reset();
    Log("RELEASED_INNER facade=", this, " live=", --live_objects);
  }

  ComPtr<IDXGISwapChain4> inner_;
  const char* source_;
  std::atomic<ULONG> references_ = 1;
  std::atomic_uint64_t presents_ = 0;
  std::atomic_uint64_t presents1_ = 0;
  std::atomic_uint32_t generation_ = 0;
  std::atomic_uint32_t unknown_queries_ = 0;
  std::atomic_uint32_t present_failures_ = 0;
  std::atomic_uint32_t buffer_queries_ = 0;

  std::shared_mutex buffers_mutex_;
  std::array<LogicalBuffer, 16> buffers_;
  HRESULT buffers_result_ = E_FAIL;
  ComPtr<ID3D11Device> device_;
  ComPtr<ID3D11DeviceContext> conversion_context_;
  ComPtr<ID3D11VertexShader> conversion_vs_;
  ComPtr<ID3D11PixelShader> conversion_pq_ps_;
  ComPtr<ID3D11PixelShader> conversion_sdr_ps_;
  uint32_t converted_generation_ = UINT32_MAX;
  uint32_t conversion_failures_ = 0;
  std::atomic<OutputEncoding> frame_encoding_ = OutputEncoding::HDR10_PQ;
  std::atomic<OutputEncoding> applied_encoding_ = OutputEncoding::HDR10_PQ;
  OutputEncoding converted_encoding_ = OutputEncoding::HDR10_PQ;
  std::atomic_bool switch_failed_ = false;
  uint32_t switch_failures_ = 0;
};

inline HRESULT STDMETHODCALLTYPE CreateSwapChainHook(IDXGIFactory* factory, IUnknown* device,
                                                     DXGI_SWAP_CHAIN_DESC* desc, IDXGISwapChain** output) {
  CreateSwapChain forward = nullptr;
  {
    std::shared_lock lock(hook_mutex);
    forward = forward_entry;
  }
  ++hook_depth;
  const HRESULT result = forward(factory, device, desc, output);
  const bool nested = (--hook_depth != 0);
  if (FAILED(result) || output == nullptr || *output == nullptr || desc == nullptr || device == nullptr) return result;

  char window_class[64]{};
  DWORD process_id = 0;
  GetWindowThreadProcessId(desc->OutputWindow, &process_id);
  if (process_id != GetCurrentProcessId()
      || GetClassNameA(desc->OutputWindow, window_class, sizeof(window_class)) == 0
      || std::strcmp(window_class, "FFXIVGAME") != 0) return result;

  ComPtr<IUnknown> device_identity;
  ComPtr<IUnknown> output_device_identity;
  if (FAILED(device->QueryInterface(IID_PPV_ARGS(&device_identity)))
      || FAILED((*output)->GetDevice(IID_PPV_ARGS(&output_device_identity)))
      || device_identity.Get() != output_device_identity.Get()) return result;
  {
    std::shared_lock lock(hook_mutex);
    if (!accepting || !devices.contains(device_identity.Get())) return result;
  }

  ComPtr<IUnknown> identity;
  if (FAILED((*output)->QueryInterface(IID_PPV_ARGS(&identity)))) return result;
  ComPtr<IUnknown> opti;
  const bool optiscaler = SUCCEEDED((*output)->QueryInterface(OPTISCALER_ID, reinterpret_cast<void**>(opti.GetAddressOf())));
  if (optiscaler) {
    ComPtr<IUnknown> opti_identity;
    if (FAILED(opti.As(&opti_identity)) || identity.Get() != opti_identity.Get()) return result;
  } else {
    // Without OptiScaler's identity, accept only an outermost system DXGI object
    // created through an entry owned by system DXGI or ReShade. Any other layer
    // (frame generation, overlays, proxies) may own nested or wrapped chains.
    auto module_of = [](const void* address) {
      HMODULE module = nullptr;
      GetModuleHandleExW(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS | GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,
                         static_cast<LPCWSTR>(address), &module);
      return module;
    };
    wchar_t system_dxgi_path[MAX_PATH]{};
    const UINT length = GetSystemDirectoryW(system_dxgi_path, MAX_PATH);
    HMODULE system_dxgi = nullptr;
    if (length != 0 && length < MAX_PATH && wcscat_s(system_dxgi_path, L"\\dxgi.dll") == 0) {
      system_dxgi = GetModuleHandleW(system_dxgi_path);
    }
    const HMODULE factory_module = module_of(reinterpret_cast<const void*>(forward));
    const bool factory_verified = factory_module != nullptr
                                  && (factory_module == system_dxgi
                                      || factory_module == reshade::internal::get_reshade_module_handle());
    const bool swapchain_verified = system_dxgi != nullptr
                                    && module_of(*reinterpret_cast<void* const*>(identity.Get())) == system_dxgi;
    // The result must belong to the factory that created it, not a cached or foreign chain.
    ComPtr<IUnknown> factory_identity;
    ComPtr<IUnknown> parent_identity;
    const bool parent_verified = SUCCEEDED(factory->QueryInterface(IID_PPV_ARGS(&factory_identity)))
                                 && SUCCEEDED((*output)->GetParent(IID_PPV_ARGS(&parent_identity)))
                                 && factory_identity.Get() == parent_identity.Get();
    if (nested || !factory_verified || !swapchain_verified || !parent_verified) {
      Log("SKIP unverified DXGI inner=", *output, " nested=", nested, " factory_verified=", factory_verified,
          " swapchain_verified=", swapchain_verified, " parent_verified=", parent_verified);
      return result;
    }
  }

  void* factory_proxy = nullptr;
  void* swapchain_proxy = nullptr;
  UINT size = sizeof(factory_proxy);
  if (FAILED(factory->GetPrivateData(FACTORY_PROXY_ID, &size, &factory_proxy)) || factory_proxy == nullptr
      || GetModuleHandleW(L"overlay64.dll") != nullptr) return result;
  size = sizeof(swapchain_proxy);
  (*output)->GetPrivateData(SWAPCHAIN_PROXY_ID, &size, &swapchain_proxy);
  if (swapchain_proxy != nullptr) {
    Log("SKIP already wrapped by ReShade inner=", *output);
    return result;
  }

  ComPtr<IDXGISwapChain4> inner;
  if (FAILED((*output)->QueryInterface(IID_PPV_ARGS(&inner)))) return result;
  // The shared forwarding base uses the v4 interface for every method. Prove
  // each advertised version is supported and belongs to the same COM object.
  for (const auto& iid : {__uuidof(IDXGISwapChain), __uuidof(IDXGISwapChain1), __uuidof(IDXGISwapChain2),
                          __uuidof(IDXGISwapChain3), __uuidof(IDXGISwapChain4)}) {
    ComPtr<IUnknown> version;
    ComPtr<IUnknown> version_identity;
    if (FAILED(inner->QueryInterface(iid, reinterpret_cast<void**>(version.GetAddressOf())))
        || FAILED(version.As(&version_identity)) || version_identity.Get() != identity.Get()) {
      Log("SKIP unsupported/inconsistent DXGI versions inner=", *output);
      return result;
    }
  }
  const char* source = (optiscaler ? "optiscaler" : "dxgi");
  auto* facade = new (std::nothrow) ForwardingSwapchain(inner.Get(), source);
  if (facade == nullptr) return result;
  if (const auto composition = facade->InitializeComposition(); FAILED(composition)) {
    Log("FALLBACK upstream inner=", inner.Get(), " source=", source, " hr=", utils::log::AsHex(composition));
    facade->Release();
    return result;
  }
  // The facade owns one new inner reference. Discharge exactly the original
  // creation-result reference; temporary QI references leave scope normally.
  Log("INSERT facade=", facade, " inner=", *output, " source=", source, " device=", device_identity.Get(),
      " factory=", factory, " hwnd=", desc->OutputWindow, " nested=", nested, " reshade_proxy=0");
  (*output)->Release();
  *output = facade;
  return result;
}

inline void OnInitDevice(reshade::api::device* device) {
  if (device->get_api() != reshade::api::device_api::d3d11) return;
  ComPtr<IUnknown> identity;
  ComPtr<IDXGIDevice> dxgi;
  ComPtr<IDXGIAdapter> adapter;
  ComPtr<IDXGIFactory> factory;
  if (FAILED(reinterpret_cast<ID3D11Device*>(device->get_native())->QueryInterface(IID_PPV_ARGS(&identity)))
      || FAILED(identity.As(&dxgi)) || FAILED(dxgi->GetAdapter(&adapter))
      || FAILED(adapter->GetParent(IID_PPV_ARGS(&factory)))) return;
  std::unique_lock lock(hook_mutex);
  devices.insert(identity.Get());
  auto** table = *reinterpret_cast<void***>(factory.Get());
  if (slot.installed_address != nullptr) {
    if (slot.installed_address != table + 10) {
      Log("SKIP other factory table=", table);
    }
    return;
  }
  // Hooks and outstanding COM objects may outlive ReShade addon unregister.
  // Pin our code for this process; replacement/removal requires a game restart.
  HMODULE module = nullptr;
  if (!GetModuleHandleExW(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS | GET_MODULE_HANDLE_EX_FLAG_PIN,
                          reinterpret_cast<LPCWSTR>(&CreateSwapChainHook), &module)) return;
  slot = {factory.Get(), 10, &original, &CreateSwapChainHook};
  // Also cover a call dispatched during a failed install's rollback. The lock
  // keeps it from observing an incomplete successful installation.
  forward_entry = reinterpret_cast<CreateSwapChain>(table[10]);
  try {
    utils::vtable::Install(&slot);
    forward_entry = original;
    retained_factory = factory;
    accepting = true;
    Log("HOOK_INSTALLED device=", identity.Get(), " factory=", factory.Get(), " table=", table, " module_pinned=1");
  } catch (const std::exception& error) {
    Log("HOOK_FAILED ", error.what());
  }
}

inline void OnDestroyDevice(reshade::api::device* device) {
  if (device->get_api() != reshade::api::device_api::d3d11) return;
  ComPtr<IUnknown> identity;
  if (SUCCEEDED(reinterpret_cast<ID3D11Device*>(device->get_native())->QueryInterface(IID_PPV_ARGS(&identity)))) {
    std::unique_lock lock(hook_mutex);
    devices.erase(identity.Get());
  }
}

// Returns the facade behind a ReShade swapchain, or null for any other swapchain.
inline ComPtr<ForwardingSwapchain> Find(reshade::api::swapchain* swapchain) {
  ComPtr<ForwardingSwapchain> facade;
  if (swapchain->get_device()->get_api() == reshade::api::device_api::d3d11) {
    reinterpret_cast<IDXGISwapChain*>(swapchain->get_native())->QueryInterface(IID_PPV_ARGS(&facade));
  }
  return facade;
}

inline void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  const auto facade = Find(swapchain);
  if (facade == nullptr) {
    Log("RESHADE_INIT native=", reinterpret_cast<void*>(swapchain->get_native()), " facade=0 resize=", resize);
    return;
  }
  bool identity_ok = true;
  for (const auto& iid : {__uuidof(IUnknown), __uuidof(IDXGIObject), __uuidof(IDXGIDeviceSubObject),
                          __uuidof(IDXGISwapChain), __uuidof(IDXGISwapChain1), __uuidof(IDXGISwapChain2),
                          __uuidof(IDXGISwapChain3), __uuidof(IDXGISwapChain4)}) {
    ComPtr<IUnknown> version;
    ComPtr<IUnknown> identity;
    identity_ok &= SUCCEEDED(facade->QueryInterface(iid, reinterpret_cast<void**>(version.GetAddressOf())))
                   && SUCCEEDED(version.As(&identity)) && identity.Get() == static_cast<IUnknown*>(facade.Get());
  }
  DXGI_SWAP_CHAIN_DESC desc{};
  const auto result = facade->GetDesc(&desc);
  Log("RESHADE_INIT native=", reinterpret_cast<void*>(swapchain->get_native()), " facade=", facade.Get(),
      " resize=", resize, " identity_ok=", identity_ok, " desc_hr=", utils::log::AsHex(result),
      " size=", desc.BufferDesc.Width, "x", desc.BufferDesc.Height, " format=", static_cast<UINT>(desc.BufferDesc.Format));
}

inline void OnDestroySwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (const auto facade = Find(swapchain); facade != nullptr) {
    Log("RESHADE_DESTROY facade=", facade.Get(), " resize=", resize);
  }
}

inline void Use(DWORD reason) {
  if (reason == DLL_PROCESS_ATTACH) {
    logging_enabled = true;
    Log("ENABLED logical_FP16 late_PQ sources=optiscaler,dxgi");
    reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
    reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
    reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
    reshade::register_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
  } else if (reason == DLL_PROCESS_DETACH) {
    reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
    reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
    reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
    reshade::unregister_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
    std::unique_lock lock(hook_mutex);
    accepting = false;
    if (slot.installed_address != nullptr) {
      try {
        utils::vtable::Uninstall(&slot);
        Log("HOOK_REMOVED live=", live_objects.load());
      } catch (const std::exception& error) {
        Log("HOOK_REMOVE_FAILED ", error.what(), " live=", live_objects.load());
      }
    }
    devices.clear();
    retained_factory.Reset();
    logging_enabled = false;
  }
}

}  // namespace renodx::games::ffxiv::swapchain_facade
