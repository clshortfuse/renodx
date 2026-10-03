/*
 * Copyright (C) 2026 speedlemur
 * SPDX-License-Identifier: MIT
 *
 * control-rr: DLSS Ray Reconstruction for Control, in-process.
 *
 * Control ships DLSS Super Resolution but never Ray Reconstruction. This
 * answers the game's SR evaluate with a RayReconstruction evaluate
 * instead, supplying the extra guide buffers RR requires. Three pieces,
 * no Streamline:
 *
 *  1. NGX interception — Detours on the driver NGX runtime's
 *     (_nvngx.dll) D3D12 exports. CreateFeature identifies the game's
 *     SuperSampling feature and stashes its creation params;
 *     EvaluateFeature is the injection site.
 *  2. Guide decode — a compute pass (rrg.cs_5_0.hlsl) translating
 *     Control's packed G-buffer into the normal/roughness and albedo
 *     textures RR expects, dispatched on the game's command list right
 *     before evaluate. The decode math is ported from the game's own
 *     shaders.
 *  3. DLSSD — created lazily through the same NGX runtime the game
 *     already initialized.
 *
 * Parameter keys and creation flags are NVIDIA's, from the DLSS SDK
 * vendored at external/DLSS (nvsdk_ngx_defs.h, nvsdk_ngx_defs_dlssd.h).
 *
 * Fallback discipline: any failure (guides not captured yet, DLSSD create
 * or evaluate error) falls through to the game's real SR evaluate — the
 * game must never notice. Toggling RR off mid-session is the live A/B.
 */

#pragma once

#include <d3d12.h>
#include <detours.h>
#include <intrin.h>

#include <nvsdk_ngx.h>
#include <nvsdk_ngx_defs_dlssd.h>

#include <atomic>
#include <cstring>
#include <mutex>
#include <sstream>
#include <string>

#include <embed/shaders.h>
#include <include/reshade.hpp>

#include "../../utils/path.hpp"
#include "../../utils/platform.hpp"

namespace rr {

// ---------------------------------------------------------------------------
// logging
// ---------------------------------------------------------------------------

inline void Log(const std::string& msg) {
  control_diag::Mark(msg.c_str());
  reshade::log::message(reshade::log::level::info, ("rr: " + msg).c_str());
}

inline void LogWarn(const std::string& msg) {
  control_diag::Mark(msg.c_str());
  reshade::log::message(reshade::log::level::warning, ("rr: " + msg).c_str());
}

// Which module a return address belongs to. With OptiScaler installed the
// game's DLSS calls may arrive from IT rather than from the game, and NGX
// itself may be OptiScaler's stand-in rather than the driver's - both are
// invisible without naming the modules.
inline std::string ModuleNameOf(void* address) {
  HMODULE module = nullptr;
  if (GetModuleHandleExA(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS
                             | GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,
                         static_cast<LPCSTR>(address), &module)
      == 0) {
    return "?";
  }
  char path[MAX_PATH] = {};
  if (GetModuleFileNameA(module, path, MAX_PATH) == 0) return "?";
  const char* slash = strrchr(path, '\\');
  return slash != nullptr ? slash + 1 : path;
}



// ---------------------------------------------------------------------------
// guide registry — live game resources, set by the capture path in
// addon.cpp as the game binds them
// ---------------------------------------------------------------------------

inline std::atomic<ID3D12Resource*> guide_gbuffer1 = nullptr;
inline std::atomic<ID3D12Resource*> guide_gbuffer2 = nullptr;
inline std::atomic<ID3D12Resource*> guide_material = nullptr;
inline std::atomic<ID3D12Resource*> guide_envbrdf = nullptr;
#ifdef CONTROL_RR_DEV
inline std::atomic<ID3D12Resource*> guide_hitinfo = nullptr;
#endif
// reflection pass hit-attribute arrays: t26 / t28 of 0xABEC7E90
inline std::atomic<ID3D12Resource*> guide_matid = nullptr;
inline std::atomic<ID3D12Resource*> guide_hitpos = nullptr;

inline void SetGuide(const char* name, ID3D12Resource* resource) {
  if (strcmp(name, "gbuffer1") == 0) {
    guide_gbuffer1 = resource;
  } else if (strcmp(name, "gbuffer2") == 0) {
    guide_gbuffer2 = resource;
  } else if (strcmp(name, "material") == 0) {
    guide_material = resource;
  } else if (strcmp(name, "envbrdf") == 0) {
    guide_envbrdf = resource;
  }
#ifdef CONTROL_RR_DEV
  else if (strcmp(name, "hitinfo") == 0) {
    guide_hitinfo = resource;
  }
#endif
  else if (strcmp(name, "matid") == 0) {
    guide_matid = resource;
  } else if (strcmp(name, "hitpos") == 0) {
    guide_hitpos = resource;
  }
}

// Size of the game's sys_constants block. Offsets within it are NOT
// guessed — they are the RDEF of 0x9018E4F2 (disassemble the dumped blob
// to verify): g_mClipToView +224, g_mPreviousViewToView +544; the struct's
// last field ends at 1128, hence this window. Compute shaders on Control
// keep their reflection data, so the layout is known and named — never
// infer it by scanning a blob.
constexpr size_t kSysConstBytes = 1152;

// master switch (bound to the overlay setting in addon.cpp)
inline std::atomic<bool> rr_enabled = true;
// set permanently on unrecoverable failure so we stop retrying every frame
inline std::atomic<bool> rr_failed = false;
// Why it failed, for the overlay. NGX gives no way to read back which preset
// is actually running (the Hint keys are write-only and the DLL reports the
// outcome only in its own log), so these are the only in-process signals we
// have that the user is not getting what the UI says.
inline std::atomic<unsigned int> rr_last_error = 0;
inline std::atomic<bool> sr_failed = false;
inline std::atomic<unsigned int> sr_last_error = 0;
// Our own F -> E retry fired: the driver is older than F requires. The DLL
// also has a SILENT fallback path for the same condition which succeeds and
// which we cannot detect.
inline std::atomic<bool> rr_preset_downgraded = false;

// status for the OSD label
enum class Status : int {
  kNotArmed = 0,       // NGX exports not hooked yet
  kArmedNoSr,          // hooked, game SR feature not seen yet
  kWaitingGuides,      // SR seen, no captured gbuffer yet
  kFallbackSr,         // RR off (toggle) — passing through
  kActive,             // DLSSD evaluating
  kFailed,             // DLSSD create/evaluate failed — permanent SR
};
inline std::atomic<int> status = static_cast<int>(Status::kNotArmed);

inline const char* StatusTextFor(Status s) {
  switch (s) {
    case Status::kNotArmed: return "RR: NGX NOT HOOKED";
    case Status::kArmedNoSr: return "RR: HOOKED (no SR feature yet)";
    case Status::kWaitingGuides: return "RR: WAITING FOR GUIDES";
    case Status::kFallbackSr: return "RR: OFF (game SR)";
    case Status::kActive: return "RR: ACTIVE";
    case Status::kFailed: return "RR: FAILED (game SR)";
  }
  return "RR: ?";
}

// every transition logs its reason — the OSD can go stale while the game
// is paused (status only updates at evaluate), and a silent bail used to
// be indistinguishable from a real wait
inline void SetStatus(Status new_status, const char* reason) {
  const int prev = status.exchange(static_cast<int>(new_status));
  if (prev != static_cast<int>(new_status)) {
    std::stringstream s;
    s << "status -> " << StatusTextFor(new_status) << " (" << reason << ")";
    Log(s.str());
  }
}

// ---------------------------------------------------------------------------
// Guide decode pass. NGX hands us a native command list outside ReShade's
// wrapper, so this is raw D3D12: root signature [0] 4x 32-bit constants
// (b0), [1] table {t0..t3, u0..u2}, static sampler s0, matching the
// bindings declared in rrg.cs_5_0.hlsl.
// ---------------------------------------------------------------------------

class RrgPass {
 public:
  bool Init(ID3D12Device* device) {
    if (initialized_) return true;
    device_ = device;

    using PFN_Serialize = HRESULT(WINAPI*)(
        const D3D12_ROOT_SIGNATURE_DESC*, D3D_ROOT_SIGNATURE_VERSION, ID3DBlob**, ID3DBlob**);
    auto* d3d12 = GetModuleHandleW(L"d3d12.dll");
    auto* serialize = d3d12 != nullptr
                          ? reinterpret_cast<PFN_Serialize>(GetProcAddress(d3d12, "D3D12SerializeRootSignature"))
                          : nullptr;
    if (serialize == nullptr) {
      LogWarn("D3D12SerializeRootSignature unavailable");
      return false;
    }

    D3D12_DESCRIPTOR_RANGE ranges[2] = {};
    ranges[0].RangeType = D3D12_DESCRIPTOR_RANGE_TYPE_SRV;
    ranges[0].NumDescriptors = 4;
    ranges[0].BaseShaderRegister = 0;
    ranges[0].OffsetInDescriptorsFromTableStart = 0;
    ranges[1].RangeType = D3D12_DESCRIPTOR_RANGE_TYPE_UAV;
    ranges[1].NumDescriptors = 3;
    ranges[1].BaseShaderRegister = 0;
    ranges[1].OffsetInDescriptorsFromTableStart = 4;

    D3D12_ROOT_PARAMETER params[2] = {};
    params[0].ParameterType = D3D12_ROOT_PARAMETER_TYPE_32BIT_CONSTANTS;
    params[0].Constants.ShaderRegister = 0;
    params[0].Constants.Num32BitValues = 4;
    params[0].ShaderVisibility = D3D12_SHADER_VISIBILITY_ALL;
    params[1].ParameterType = D3D12_ROOT_PARAMETER_TYPE_DESCRIPTOR_TABLE;
    params[1].DescriptorTable.NumDescriptorRanges = 2;
    params[1].DescriptorTable.pDescriptorRanges = ranges;
    params[1].ShaderVisibility = D3D12_SHADER_VISIBILITY_ALL;

    D3D12_STATIC_SAMPLER_DESC sampler = {};
    sampler.Filter = D3D12_FILTER_MIN_MAG_MIP_LINEAR;
    sampler.AddressU = D3D12_TEXTURE_ADDRESS_MODE_CLAMP;
    sampler.AddressV = D3D12_TEXTURE_ADDRESS_MODE_CLAMP;
    sampler.AddressW = D3D12_TEXTURE_ADDRESS_MODE_CLAMP;
    sampler.MaxLOD = D3D12_FLOAT32_MAX;
    sampler.ShaderRegister = 0;
    sampler.ShaderVisibility = D3D12_SHADER_VISIBILITY_ALL;

    D3D12_ROOT_SIGNATURE_DESC rs_desc = {};
    rs_desc.NumParameters = 2;
    rs_desc.pParameters = params;
    rs_desc.NumStaticSamplers = 1;
    rs_desc.pStaticSamplers = &sampler;

    ID3DBlob* blob = nullptr;
    ID3DBlob* error = nullptr;
    if (FAILED(serialize(&rs_desc, D3D_ROOT_SIGNATURE_VERSION_1, &blob, &error))) {
      LogWarn("root signature serialize failed");
      if (error != nullptr) error->Release();
      return false;
    }
    HRESULT hr = device->CreateRootSignature(0, blob->GetBufferPointer(), blob->GetBufferSize(),
                                             IID_PPV_ARGS(&root_signature_));
    blob->Release();
    if (FAILED(hr)) {
      LogWarn("CreateRootSignature failed");
      return false;
    }

    D3D12_COMPUTE_PIPELINE_STATE_DESC pso_desc = {};
    pso_desc.pRootSignature = root_signature_;
    pso_desc.CS.pShaderBytecode = __rrg.data();
    pso_desc.CS.BytecodeLength = __rrg.size();
    if (FAILED(device->CreateComputePipelineState(&pso_desc, IID_PPV_ARGS(&pipeline_)))) {
      LogWarn("CreateComputePipelineState failed");
      return false;
    }

    D3D12_DESCRIPTOR_HEAP_DESC heap_desc = {};
    heap_desc.Type = D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV;
    heap_desc.NumDescriptors = kSlots * kRingSize;
    heap_desc.Flags = D3D12_DESCRIPTOR_HEAP_FLAG_SHADER_VISIBLE;
    if (FAILED(device->CreateDescriptorHeap(&heap_desc, IID_PPV_ARGS(&heap_)))) {
      LogWarn("CreateDescriptorHeap failed");
      return false;
    }
    descriptor_size_ = device->GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV);

    // The Flags constant tells the shader which optional inputs are live,
    // but every descriptor in the table must still resolve to a real view.
    // These stand in whenever an input has not been captured.
    D3D12_HEAP_PROPERTIES default_heap = {};
    default_heap.Type = D3D12_HEAP_TYPE_DEFAULT;
    D3D12_RESOURCE_DESC tex_desc = {};
    tex_desc.Dimension = D3D12_RESOURCE_DIMENSION_TEXTURE2D;
    tex_desc.Width = 4;
    tex_desc.Height = 4;
    tex_desc.DepthOrArraySize = 1;
    tex_desc.MipLevels = 1;
    tex_desc.Format = DXGI_FORMAT_R16G16B16A16_FLOAT;
    tex_desc.SampleDesc.Count = 1;
    device->CreateCommittedResource(&default_heap, D3D12_HEAP_FLAG_NONE, &tex_desc,
                                    D3D12_RESOURCE_STATE_COMMON, nullptr, IID_PPV_ARGS(&dummy_texture_));
    D3D12_RESOURCE_DESC buf_desc = {};
    buf_desc.Dimension = D3D12_RESOURCE_DIMENSION_BUFFER;
    buf_desc.Width = 64;
    buf_desc.Height = 1;
    buf_desc.DepthOrArraySize = 1;
    buf_desc.MipLevels = 1;
    buf_desc.SampleDesc.Count = 1;
    buf_desc.Layout = D3D12_TEXTURE_LAYOUT_ROW_MAJOR;
    device->CreateCommittedResource(&default_heap, D3D12_HEAP_FLAG_NONE, &buf_desc,
                                    D3D12_RESOURCE_STATE_COMMON, nullptr, IID_PPV_ARGS(&dummy_buffer_));
    if (dummy_texture_ == nullptr || dummy_buffer_ == nullptr) {
      LogWarn("dummy resource creation failed");
      return false;
    }

    initialized_ = true;
    Log("RRG pass initialized");
    return true;
  }

  // typeless -> typed mapping for SRV creation on game resources
  static DXGI_FORMAT TypedFormat(DXGI_FORMAT format) {
    switch (format) {
      case DXGI_FORMAT_R8G8B8A8_TYPELESS: return DXGI_FORMAT_R8G8B8A8_UNORM;
      case DXGI_FORMAT_B8G8R8A8_TYPELESS: return DXGI_FORMAT_B8G8R8A8_UNORM;
      case DXGI_FORMAT_R16G16B16A16_TYPELESS: return DXGI_FORMAT_R16G16B16A16_FLOAT;
      case DXGI_FORMAT_R16G16_TYPELESS: return DXGI_FORMAT_R16G16_FLOAT;
      case DXGI_FORMAT_R32G32B32A32_TYPELESS: return DXGI_FORMAT_R32G32B32A32_FLOAT;
      case DXGI_FORMAT_R10G10B10A2_TYPELESS: return DXGI_FORMAT_R10G10B10A2_UNORM;
      default: return format;
    }
  }

  void Dispatch(ID3D12GraphicsCommandList* cmd_list,
                ID3D12Resource* gbuffer1, ID3D12Resource* gbuffer2,
                ID3D12Resource* material, ID3D12Resource* envbrdf,
                ID3D12Resource* out_nr, ID3D12Resource* out_diffuse, ID3D12Resource* out_spec,
                uint32_t width, uint32_t height) {
    ring_ = (ring_ + 1) % kRingSize;
    const uint32_t base = ring_ * kSlots;

    auto cpu = [&](uint32_t slot) {
      D3D12_CPU_DESCRIPTOR_HANDLE h = heap_->GetCPUDescriptorHandleForHeapStart();
      h.ptr += static_cast<SIZE_T>(base + slot) * descriptor_size_;
      return h;
    };

    auto make_tex_srv = [&](ID3D12Resource* resource, uint32_t slot) {
      if (resource == nullptr) resource = dummy_texture_;
      auto desc = resource->GetDesc();
      D3D12_SHADER_RESOURCE_VIEW_DESC srv = {};
      srv.Format = TypedFormat(desc.Format);
      srv.ViewDimension = D3D12_SRV_DIMENSION_TEXTURE2D;
      srv.Shader4ComponentMapping = D3D12_DEFAULT_SHADER_4_COMPONENT_MAPPING;
      srv.Texture2D.MipLevels = 1;
      device_->CreateShaderResourceView(resource, &srv, cpu(slot));
    };

    make_tex_srv(gbuffer1, 0);
    make_tex_srv(gbuffer2, 1);
    {
      // Control's material table is a flat array of two-word records; the
      // shader indexes it by the material id unpacked from GBuffer2.
      constexpr UINT kMaterialRecordBytes = sizeof(uint32_t) * 2;
      ID3D12Resource* resource = material != nullptr ? material : dummy_buffer_;
      D3D12_SHADER_RESOURCE_VIEW_DESC srv = {};
      srv.Format = DXGI_FORMAT_UNKNOWN;
      srv.ViewDimension = D3D12_SRV_DIMENSION_BUFFER;
      srv.Shader4ComponentMapping = D3D12_DEFAULT_SHADER_4_COMPONENT_MAPPING;
      srv.Buffer.StructureByteStride = kMaterialRecordBytes;
      srv.Buffer.NumElements =
          static_cast<UINT>(resource->GetDesc().Width / kMaterialRecordBytes);
      device_->CreateShaderResourceView(resource, &srv, cpu(2));
    }
    make_tex_srv(envbrdf, 3);

    auto make_uav = [&](ID3D12Resource* resource, uint32_t slot) {
      D3D12_UNORDERED_ACCESS_VIEW_DESC uav = {};
      uav.Format = DXGI_FORMAT_R16G16B16A16_FLOAT;
      uav.ViewDimension = D3D12_UAV_DIMENSION_TEXTURE2D;
      device_->CreateUnorderedAccessView(resource, nullptr, &uav, cpu(slot));
    };
    make_uav(out_nr, 4);
    make_uav(out_diffuse, 5);
    make_uav(out_spec, 6);

    uint32_t flags = 0;
    if (gbuffer2 != nullptr && material != nullptr) flags |= 1u;
    if (envbrdf != nullptr) flags |= 2u;
    // GBuffer1.z is GLOSS (dump-verified) — RR wants roughness, so invert
    const uint32_t constants[4] = {1u, flags, width, height};

    ID3D12DescriptorHeap* heaps[] = {heap_};
    cmd_list->SetDescriptorHeaps(1, heaps);
    cmd_list->SetComputeRootSignature(root_signature_);
    cmd_list->SetPipelineState(pipeline_);
    cmd_list->SetComputeRoot32BitConstants(0, 4, constants, 0);
    D3D12_GPU_DESCRIPTOR_HANDLE gpu = heap_->GetGPUDescriptorHandleForHeapStart();
    gpu.ptr += static_cast<UINT64>(base) * descriptor_size_;
    cmd_list->SetComputeRootDescriptorTable(1, gpu);
    cmd_list->Dispatch((width + 15) / 16, (height + 15) / 16, 1);
  }

 private:
  static constexpr uint32_t kSlots = 7;  // 4 SRV + 3 UAV
  static constexpr uint32_t kRingSize = 4;

  bool initialized_ = false;
  ID3D12Device* device_ = nullptr;
  ID3D12RootSignature* root_signature_ = nullptr;
  ID3D12PipelineState* pipeline_ = nullptr;
  ID3D12DescriptorHeap* heap_ = nullptr;
  ID3D12Resource* dummy_texture_ = nullptr;
  ID3D12Resource* dummy_buffer_ = nullptr;
  uint32_t descriptor_size_ = 0;
  uint32_t ring_ = 0;
};

// ---------------------------------------------------------------------------
// SpecMV pass — virtual-point specular motion vectors (specmv.cs_5_0.hlsl).
// Root signature: [0] 53x 32-bit constants (b0: 3 matrices + dims + scale +
// layers), [1] table {t0..t4, u0..u1}. All Loads, no sampler. t1/t4 are the
// reflection pass's per-ray 2D arrays.
// ---------------------------------------------------------------------------

struct SpecMvConstants {
  float clip_to_view[16];
  float view_to_clip[16];
  float clip_to_prev_clip[16];
  uint32_t width;
  uint32_t height;
  float mv_out_scale_x;
  float mv_out_scale_y;
  uint32_t layers;  // slices in the hit arrays = rays per pixel
};
static_assert(sizeof(SpecMvConstants) == 53 * 4, "root constant count");

class SpecMvPass {
 public:
  bool Init(ID3D12Device* device) {
    if (initialized_) return true;
    device_ = device;

    using PFN_Serialize = HRESULT(WINAPI*)(
        const D3D12_ROOT_SIGNATURE_DESC*, D3D_ROOT_SIGNATURE_VERSION, ID3DBlob**, ID3DBlob**);
    auto* d3d12 = GetModuleHandleW(L"d3d12.dll");
    auto* serialize = d3d12 != nullptr
                          ? reinterpret_cast<PFN_Serialize>(GetProcAddress(d3d12, "D3D12SerializeRootSignature"))
                          : nullptr;
    if (serialize == nullptr) return false;

    D3D12_DESCRIPTOR_RANGE ranges[2] = {};
    ranges[0].RangeType = D3D12_DESCRIPTOR_RANGE_TYPE_SRV;
    ranges[0].NumDescriptors = 5;
    ranges[0].BaseShaderRegister = 0;
    ranges[0].OffsetInDescriptorsFromTableStart = 0;
    ranges[1].RangeType = D3D12_DESCRIPTOR_RANGE_TYPE_UAV;
    ranges[1].NumDescriptors =
#ifdef CONTROL_RR_DEV
        2;
#else
        1;
#endif
    ranges[1].BaseShaderRegister = 0;
    ranges[1].OffsetInDescriptorsFromTableStart = 5;

    D3D12_ROOT_PARAMETER params[2] = {};
    params[0].ParameterType = D3D12_ROOT_PARAMETER_TYPE_32BIT_CONSTANTS;
    params[0].Constants.ShaderRegister = 0;
    params[0].Constants.Num32BitValues = 53;
    params[0].ShaderVisibility = D3D12_SHADER_VISIBILITY_ALL;
    params[1].ParameterType = D3D12_ROOT_PARAMETER_TYPE_DESCRIPTOR_TABLE;
    params[1].DescriptorTable.NumDescriptorRanges = 2;
    params[1].DescriptorTable.pDescriptorRanges = ranges;
    params[1].ShaderVisibility = D3D12_SHADER_VISIBILITY_ALL;

    D3D12_ROOT_SIGNATURE_DESC rs_desc = {};
    rs_desc.NumParameters = 2;
    rs_desc.pParameters = params;

    ID3DBlob* blob = nullptr;
    ID3DBlob* error = nullptr;
    if (FAILED(serialize(&rs_desc, D3D_ROOT_SIGNATURE_VERSION_1, &blob, &error))) {
      if (error != nullptr) error->Release();
      LogWarn("SpecMV root signature serialize failed");
      return false;
    }
    HRESULT hr = device->CreateRootSignature(0, blob->GetBufferPointer(), blob->GetBufferSize(),
                                             IID_PPV_ARGS(&root_signature_));
    blob->Release();
    if (FAILED(hr)) return false;

    D3D12_COMPUTE_PIPELINE_STATE_DESC pso_desc = {};
    pso_desc.pRootSignature = root_signature_;
    pso_desc.CS.pShaderBytecode = __specmv.data();
    pso_desc.CS.BytecodeLength = __specmv.size();
    if (FAILED(device->CreateComputePipelineState(&pso_desc, IID_PPV_ARGS(&pipeline_)))) {
      LogWarn("SpecMV pipeline creation failed");
      return false;
    }

    D3D12_DESCRIPTOR_HEAP_DESC heap_desc = {};
    heap_desc.Type = D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV;
    heap_desc.NumDescriptors = kSlots * kRingSize;
    heap_desc.Flags = D3D12_DESCRIPTOR_HEAP_FLAG_SHADER_VISIBLE;
    if (FAILED(device->CreateDescriptorHeap(&heap_desc, IID_PPV_ARGS(&heap_)))) return false;
    descriptor_size_ = device->GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV);

    initialized_ = true;
    Log("SpecMV pass initialized");
    return true;
  }

  void Dispatch(ID3D12GraphicsCommandList* cmd_list,
                ID3D12Resource* gbuffer1, ID3D12Resource* matid, ID3D12Resource* hitpos,
                ID3D12Resource* depth, ID3D12Resource* game_mv,
                ID3D12Resource* out_specmv, ID3D12Resource* out_debug,
                const SpecMvConstants& constants) {
    ring_ = (ring_ + 1) % kRingSize;
    const uint32_t base = ring_ * kSlots;

    auto cpu = [&](uint32_t slot) {
      D3D12_CPU_DESCRIPTOR_HANDLE h = heap_->GetCPUDescriptorHandleForHeapStart();
      h.ptr += static_cast<SIZE_T>(base + slot) * descriptor_size_;
      return h;
    };

    auto make_srv = [&](ID3D12Resource* resource, uint32_t slot) {
      auto desc = resource->GetDesc();
      D3D12_SHADER_RESOURCE_VIEW_DESC srv = {};
      srv.Format = RrgPass::TypedFormat(desc.Format);
      if (srv.Format == DXGI_FORMAT_D32_FLOAT) srv.Format = DXGI_FORMAT_R32_FLOAT;
      if (srv.Format == DXGI_FORMAT_R32_TYPELESS) srv.Format = DXGI_FORMAT_R32_FLOAT;
      srv.Shader4ComponentMapping = D3D12_DEFAULT_SHADER_4_COMPONENT_MAPPING;
      // the hit arrays are Texture2DArray even at one slice — the view
      // dimension must match the shader's declaration
      if (desc.DepthOrArraySize > 1 || resource == matid || resource == hitpos) {
        srv.ViewDimension = D3D12_SRV_DIMENSION_TEXTURE2DARRAY;
        srv.Texture2DArray.MipLevels = 1;
        srv.Texture2DArray.ArraySize = desc.DepthOrArraySize;
      } else {
        srv.ViewDimension = D3D12_SRV_DIMENSION_TEXTURE2D;
        srv.Texture2D.MipLevels = 1;
      }
      device_->CreateShaderResourceView(resource, &srv, cpu(slot));
    };
    make_srv(gbuffer1, 0);
    make_srv(matid, 1);
    make_srv(depth, 2);
    make_srv(game_mv, 3);
    make_srv(hitpos, 4);

    D3D12_UNORDERED_ACCESS_VIEW_DESC uav = {};
    uav.Format = DXGI_FORMAT_R16G16_FLOAT;
    uav.ViewDimension = D3D12_UAV_DIMENSION_TEXTURE2D;
    device_->CreateUnorderedAccessView(out_specmv, nullptr, &uav, cpu(5));
#ifdef CONTROL_RR_DEV
    uav.Format = DXGI_FORMAT_R16G16B16A16_FLOAT;
    device_->CreateUnorderedAccessView(out_debug, nullptr, &uav, cpu(6));
#else
    (void)out_debug;
#endif

    ID3D12DescriptorHeap* heaps[] = {heap_};
    cmd_list->SetDescriptorHeaps(1, heaps);
    cmd_list->SetComputeRootSignature(root_signature_);
    cmd_list->SetPipelineState(pipeline_);
    cmd_list->SetComputeRoot32BitConstants(0, 53, &constants, 0);
    D3D12_GPU_DESCRIPTOR_HANDLE gpu = heap_->GetGPUDescriptorHandleForHeapStart();
    gpu.ptr += static_cast<UINT64>(base) * descriptor_size_;
    cmd_list->SetComputeRootDescriptorTable(1, gpu);
    cmd_list->Dispatch((constants.width + 15) / 16, (constants.height + 15) / 16, 1);
  }

 private:
#ifdef CONTROL_RR_DEV
  static constexpr uint32_t kSlots = 7;  // 5 SRV + 2 UAV
#else
  static constexpr uint32_t kSlots = 6;  // 5 SRV + spec-MV UAV
#endif
  static constexpr uint32_t kRingSize = 4;

  bool initialized_ = false;
  ID3D12Device* device_ = nullptr;
  ID3D12RootSignature* root_signature_ = nullptr;
  ID3D12PipelineState* pipeline_ = nullptr;
  ID3D12DescriptorHeap* heap_ = nullptr;
  uint32_t descriptor_size_ = 0;
  uint32_t ring_ = 0;
};

// ---------------------------------------------------------------------------
// NGX runtime interception + DLSSD lifecycle
// ---------------------------------------------------------------------------

using PFN_CreateFeature = NVSDK_NGX_Result(NVSDK_CONV*)(
    ID3D12GraphicsCommandList*, NVSDK_NGX_Feature, NVSDK_NGX_Parameter*, NVSDK_NGX_Handle**);
using PFN_EvaluateFeature = NVSDK_NGX_Result(NVSDK_CONV*)(
    ID3D12GraphicsCommandList*, const NVSDK_NGX_Handle*, const NVSDK_NGX_Parameter*,
    PFN_NVSDK_NGX_ProgressCallback);
using PFN_AllocateParameters = NVSDK_NGX_Result(NVSDK_CONV*)(NVSDK_NGX_Parameter**);
using PFN_ReleaseFeature = NVSDK_NGX_Result(NVSDK_CONV*)(NVSDK_NGX_Handle*);

inline PFN_CreateFeature real_create_feature = nullptr;
inline PFN_EvaluateFeature real_evaluate_feature = nullptr;
inline PFN_AllocateParameters real_allocate_parameters = nullptr;
inline PFN_ReleaseFeature real_release_feature = nullptr;

inline std::atomic<bool> ngx_armed = false;

// game's SuperSampling feature + creation stash (all guarded by state_mutex)
inline std::mutex state_mutex;
inline NVSDK_NGX_Handle* game_sr_handle = nullptr;
inline uint32_t render_width = 0;
inline uint32_t render_height = 0;
inline uint32_t out_width = 0;
inline uint32_t out_height = 0;
inline int perf_quality = 0;
inline int create_flags = 0;
inline bool create_stash_valid = false;

// The input size of the CURRENT evaluate, read from its parameter object.
// When the user LOWERS the quality setting Control replaces its SR feature
// by a path the create hook does not see (the evaluate arrives on an
// unknown handle and is adopted below), so the creation stash can be stale;
// the evaluate is the truth for the decode dispatch and for creating ours.
inline uint32_t eval_width = 0;
inline uint32_t eval_height = 0;

// Reads the evaluate's input size from its parameter object. Sub-rect
// dimensions first (the dynamic-resolution contract), else Width/Height,
// else the creation stash.
inline void ReadEvalDims(const NVSDK_NGX_Parameter* params) {
  auto* p = const_cast<NVSDK_NGX_Parameter*>(params);
  unsigned int w = 0;
  unsigned int h = 0;
  if (p->Get(NVSDK_NGX_Parameter_DLSS_Render_Subrect_Dimensions_Width, &w) != NVSDK_NGX_Result_Success
      || p->Get(NVSDK_NGX_Parameter_DLSS_Render_Subrect_Dimensions_Height, &h) != NVSDK_NGX_Result_Success
      || w == 0 || h == 0) {
    w = 0;
    h = 0;
    if (p->Get(NVSDK_NGX_Parameter_Width, &w) != NVSDK_NGX_Result_Success
        || p->Get(NVSDK_NGX_Parameter_Height, &h) != NVSDK_NGX_Result_Success || w == 0 || h == 0) {
      w = render_width;
      h = render_height;
    }
  }
  if (w != eval_width || h != eval_height) {
    eval_width = w;
    eval_height = h;
    std::stringstream s;
    s << "evaluate input " << w << "x" << h << " (SR feature created at " << render_width << "x"
      << render_height << " -> " << out_width << "x" << out_height << ")";
    Log(s.str());
  }
}

// our DLSSD feature
inline NVSDK_NGX_Handle* dlssd_handle = nullptr;
inline NVSDK_NGX_Parameter* dlssd_params = nullptr;
inline RrgPass rrg_pass;
inline SpecMvPass specmv_pass;

// spec MV output texture (RG16F, render res)
inline ID3D12Resource* out_specmv = nullptr;
inline D3D12_RESOURCE_STATES specmv_state = D3D12_RESOURCE_STATE_COMMON;
#ifdef CONTROL_RR_DEV
// Evidence texture (RGBA16F: hit_t, effective_t, |correction|, applied).
inline ID3D12Resource* out_specdbg = nullptr;
inline D3D12_RESOURCE_STATES specdbg_state = D3D12_RESOURCE_STATE_COMMON;
#endif

// live preset selection. Hints are consumed at feature CREATION, so a
// change releases the affected feature and the next evaluate recreates it
// with the new hint — that is what makes the switch live.
inline std::atomic<unsigned int> rr_preset = 5;  // E (most stable in testing)
inline unsigned int dlssd_created_preset = 5;

// SR preset override: the game's own SR feature was created hint-less, so
// its preset can never change. When a preset is selected we create OUR OWN
// SuperSampling feature with hints and evaluate that instead (the same
// trick as DLSSD). 0 = no override, evaluate the game's feature.
inline std::atomic<unsigned int> sr_preset = 0;
inline NVSDK_NGX_Handle* own_sr_handle = nullptr;
inline NVSDK_NGX_Parameter* own_sr_params = nullptr;
inline unsigned int own_sr_created_preset = 0;
inline std::atomic<bool> release_dlssd_requested = false;
inline std::atomic<bool> release_own_sr_requested = false;

// guide output textures (render res, RGBA16F UAV)
inline ID3D12Resource* out_nr = nullptr;
inline ID3D12Resource* out_diffuse = nullptr;
inline ID3D12Resource* out_spec = nullptr;
inline D3D12_RESOURCE_STATES out_states[3] = {
    D3D12_RESOURCE_STATE_COMMON, D3D12_RESOURCE_STATE_COMMON, D3D12_RESOURCE_STATE_COMMON};

// Dimensions the textures below were actually built at. Render resolution
// changes whenever the game recreates its SR feature — a display mode
// change, but also an ordinary DLSS quality-preset switch, since
// PerfQualityValue is a creation parameter. Textures of the wrong size
// fail SILENTLY (out-of-bounds UAV writes are discarded), so these compare
// on every call rather than trusting anyone to invalidate them.
inline uint32_t guide_texture_width = 0;
inline uint32_t guide_texture_height = 0;
inline uint32_t specmv_texture_width = 0;
inline uint32_t specmv_texture_height = 0;

// ---------------------------------------------------------------------------
// DLSSD.ResponsivityMask as a constant (nvsdk_ngx_defs_dlssd.h: optional,
// signed [-1, 1], render res). On preset F, negative values favor stability
// and positive values favor responsiveness. Zero omits the texture entirely,
// preserving the distinction between no mask and a zero-valued mask.
//
// The fill is a CopyTextureRegion from an upload buffer memset to the SNORM
// byte — no descriptors, no shader — and only re-runs when the value moves.
// ---------------------------------------------------------------------------

inline std::atomic<float> responsivity_value = 0.f;
inline ID3D12Resource* mask_texture = nullptr;
inline ID3D12Resource* mask_upload = nullptr;
inline uint32_t mask_width = 0;
inline uint32_t mask_height = 0;
inline bool mask_filled = false;
inline float mask_filled_value = 0.f;

inline bool EnsureResponsivityMask(ID3D12Device* device, ID3D12GraphicsCommandList* cmd_list,
                                   uint32_t width, uint32_t height, float value) {
  constexpr uint32_t kPitchAlign = 256;  // D3D12_TEXTURE_DATA_PITCH_ALIGNMENT
  const uint32_t pitch = (width + kPitchAlign - 1) / kPitchAlign * kPitchAlign;

  if (mask_texture != nullptr && (mask_width != width || mask_height != height)) {
    mask_texture->Release();
    mask_texture = nullptr;
    mask_upload->Release();
    mask_upload = nullptr;
  }
  if (mask_texture == nullptr) {
    D3D12_HEAP_PROPERTIES heap_props = {};
    heap_props.Type = D3D12_HEAP_TYPE_DEFAULT;
    D3D12_RESOURCE_DESC desc = {};
    desc.Dimension = D3D12_RESOURCE_DIMENSION_TEXTURE2D;
    desc.Width = width;
    desc.Height = height;
    desc.DepthOrArraySize = 1;
    desc.MipLevels = 1;
    desc.Format = DXGI_FORMAT_R8_SNORM;
    desc.SampleDesc.Count = 1;
    if (FAILED(device->CreateCommittedResource(&heap_props, D3D12_HEAP_FLAG_NONE, &desc,
                                               D3D12_RESOURCE_STATE_COPY_DEST, nullptr,
                                               IID_PPV_ARGS(&mask_texture)))) {
      LogWarn("responsivity mask texture creation failed");
      return false;
    }
    D3D12_HEAP_PROPERTIES upload_props = {};
    upload_props.Type = D3D12_HEAP_TYPE_UPLOAD;
    D3D12_RESOURCE_DESC buffer = {};
    buffer.Dimension = D3D12_RESOURCE_DIMENSION_BUFFER;
    buffer.Width = static_cast<UINT64>(pitch) * height;
    buffer.Height = 1;
    buffer.DepthOrArraySize = 1;
    buffer.MipLevels = 1;
    buffer.SampleDesc.Count = 1;
    buffer.Layout = D3D12_TEXTURE_LAYOUT_ROW_MAJOR;
    if (FAILED(device->CreateCommittedResource(&upload_props, D3D12_HEAP_FLAG_NONE, &buffer,
                                               D3D12_RESOURCE_STATE_GENERIC_READ, nullptr,
                                               IID_PPV_ARGS(&mask_upload)))) {
      LogWarn("responsivity mask upload buffer creation failed");
      mask_texture->Release();
      mask_texture = nullptr;
      return false;
    }
    mask_width = width;
    mask_height = height;
    mask_filled = false;
    std::stringstream s;
    s << "responsivity mask created " << width << "x" << height;
    Log(s.str());
  }
  if (mask_filled && mask_filled_value == value) return true;

  // SNORM8: value * 127, -1 encodes as -127 (and -128 also reads as -1)
  const int snorm = static_cast<int>(std::lround(std::clamp(value, -1.f, 1.f) * 127.f));
  void* mapped = nullptr;
  const D3D12_RANGE no_read = {0, 0};
  if (FAILED(mask_upload->Map(0, &no_read, &mapped)) || mapped == nullptr) return false;
  memset(mapped, static_cast<uint8_t>(static_cast<int8_t>(snorm)), static_cast<size_t>(pitch) * height);
  mask_upload->Unmap(0, nullptr);

  D3D12_RESOURCE_BARRIER barrier = {};
  barrier.Type = D3D12_RESOURCE_BARRIER_TYPE_TRANSITION;
  barrier.Transition.pResource = mask_texture;
  barrier.Transition.Subresource = D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;
  if (mask_filled) {  // previously handed to DLSSD as an SRV; bring it back for the copy
    barrier.Transition.StateBefore = D3D12_RESOURCE_STATE_NON_PIXEL_SHADER_RESOURCE;
    barrier.Transition.StateAfter = D3D12_RESOURCE_STATE_COPY_DEST;
    cmd_list->ResourceBarrier(1, &barrier);
  }
  D3D12_TEXTURE_COPY_LOCATION dst = {};
  dst.pResource = mask_texture;
  dst.Type = D3D12_TEXTURE_COPY_TYPE_SUBRESOURCE_INDEX;
  dst.SubresourceIndex = 0;
  D3D12_TEXTURE_COPY_LOCATION src = {};
  src.pResource = mask_upload;
  src.Type = D3D12_TEXTURE_COPY_TYPE_PLACED_FOOTPRINT;
  src.PlacedFootprint.Offset = 0;
  src.PlacedFootprint.Footprint.Format = DXGI_FORMAT_R8_SNORM;
  src.PlacedFootprint.Footprint.Width = width;
  src.PlacedFootprint.Footprint.Height = height;
  src.PlacedFootprint.Footprint.Depth = 1;
  src.PlacedFootprint.Footprint.RowPitch = pitch;
  cmd_list->CopyTextureRegion(&dst, 0, 0, 0, &src, nullptr);
  barrier.Transition.StateBefore = D3D12_RESOURCE_STATE_COPY_DEST;
  barrier.Transition.StateAfter = D3D12_RESOURCE_STATE_NON_PIXEL_SHADER_RESOURCE;
  cmd_list->ResourceBarrier(1, &barrier);

  mask_filled = true;
  mask_filled_value = value;
  std::stringstream s;
  s << "responsivity mask filled with " << value << " (snorm " << snorm << ")";
  Log(s.str());
  return true;
}

inline bool EnsureGuideTextures(ID3D12Device* device, uint32_t width, uint32_t height) {
  control_diag::Scope trace("rr.guide_textures");
  control_diag::Mark("rr.guide_dimensions", width, height);
  ID3D12Resource** outputs[3] = {&out_nr, &out_diffuse, &out_spec};

  if (out_nr != nullptr) {
    if (guide_texture_width == width && guide_texture_height == height) return true;
    for (auto*& slot : outputs) {
      if (*slot != nullptr) {
        (*slot)->Release();
        *slot = nullptr;
      }
    }
    for (auto& state : out_states) state = D3D12_RESOURCE_STATE_COMMON;
    std::stringstream s;
    s << "render resolution changed to " << width << "x" << height
      << " — guide textures released for recreate";
    Log(s.str());
  }

  D3D12_HEAP_PROPERTIES heap_props = {};
  heap_props.Type = D3D12_HEAP_TYPE_DEFAULT;
  D3D12_RESOURCE_DESC desc = {};
  desc.Dimension = D3D12_RESOURCE_DIMENSION_TEXTURE2D;
  desc.Width = width;
  desc.Height = height;
  desc.DepthOrArraySize = 1;
  desc.MipLevels = 1;
  desc.Format = DXGI_FORMAT_R16G16B16A16_FLOAT;
  desc.SampleDesc.Count = 1;
  desc.Flags = D3D12_RESOURCE_FLAG_ALLOW_UNORDERED_ACCESS;

  for (auto*& slot : outputs) {
    if (FAILED(device->CreateCommittedResource(&heap_props, D3D12_HEAP_FLAG_NONE, &desc,
                                               D3D12_RESOURCE_STATE_COMMON, nullptr,
                                               IID_PPV_ARGS(slot)))) {
      LogWarn("guide texture creation failed");
      return false;
    }
  }
  guide_texture_width = width;
  guide_texture_height = height;
  std::stringstream s;
  s << "guide textures created " << width << "x" << height;
  Log(s.str());
  return true;
}

// spec MV output (RG16F), same self-healing contract as the guides above
inline bool EnsureSpecMvTexture(ID3D12Device* device, uint32_t width, uint32_t height) {
  control_diag::Scope trace("rr.specmv_texture");
  if (out_specmv != nullptr) {
    if (specmv_texture_width == width && specmv_texture_height == height) return true;
    out_specmv->Release();
    out_specmv = nullptr;
    specmv_state = D3D12_RESOURCE_STATE_COMMON;
  }

  D3D12_HEAP_PROPERTIES heap_props = {};
  heap_props.Type = D3D12_HEAP_TYPE_DEFAULT;
  D3D12_RESOURCE_DESC desc = {};
  desc.Dimension = D3D12_RESOURCE_DIMENSION_TEXTURE2D;
  desc.Width = width;
  desc.Height = height;
  desc.DepthOrArraySize = 1;
  desc.MipLevels = 1;
  desc.Format = DXGI_FORMAT_R16G16_FLOAT;
  desc.SampleDesc.Count = 1;
  desc.Flags = D3D12_RESOURCE_FLAG_ALLOW_UNORDERED_ACCESS;

  if (FAILED(device->CreateCommittedResource(&heap_props, D3D12_HEAP_FLAG_NONE, &desc,
                                             D3D12_RESOURCE_STATE_COMMON, nullptr,
                                             IID_PPV_ARGS(&out_specmv)))) {
    LogWarn("spec MV texture creation failed");
    return false;
  }
  specmv_texture_width = width;
  specmv_texture_height = height;
  return true;
}

inline bool CopyOrdinaryMotion(ID3D12GraphicsCommandList* cmd_list, ID3D12Resource* game_mv) {
  if (game_mv == nullptr || out_specmv == nullptr) return false;
  const auto source_desc = game_mv->GetDesc();
  const auto output_desc = out_specmv->GetDesc();
  if (source_desc.Dimension != output_desc.Dimension || source_desc.Width != output_desc.Width
      || source_desc.Height != output_desc.Height || source_desc.Format != output_desc.Format) {
    static bool warned = false;
    if (!warned) {
      LogWarn("ordinary-motion fallback does not match the spec-MV texture");
      warned = true;
    }
    return false;
  }

  D3D12_RESOURCE_BARRIER open[2] = {};
  open[0].Type = D3D12_RESOURCE_BARRIER_TYPE_TRANSITION;
  open[0].Transition.pResource = game_mv;
  open[0].Transition.Subresource = D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;
  open[0].Transition.StateBefore = D3D12_RESOURCE_STATE_NON_PIXEL_SHADER_RESOURCE;
  open[0].Transition.StateAfter = D3D12_RESOURCE_STATE_COPY_SOURCE;
  open[1].Type = D3D12_RESOURCE_BARRIER_TYPE_TRANSITION;
  open[1].Transition.pResource = out_specmv;
  open[1].Transition.Subresource = D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;
  open[1].Transition.StateBefore = specmv_state;
  open[1].Transition.StateAfter = D3D12_RESOURCE_STATE_COPY_DEST;
  cmd_list->ResourceBarrier(2, open);
  cmd_list->CopyResource(out_specmv, game_mv);

  D3D12_RESOURCE_BARRIER close[2] = {open[0], open[1]};
  close[0].Transition.StateBefore = D3D12_RESOURCE_STATE_COPY_SOURCE;
  close[0].Transition.StateAfter = D3D12_RESOURCE_STATE_NON_PIXEL_SHADER_RESOURCE;
  close[1].Transition.StateBefore = D3D12_RESOURCE_STATE_COPY_DEST;
  close[1].Transition.StateAfter = D3D12_RESOURCE_STATE_NON_PIXEL_SHADER_RESOURCE;
  cmd_list->ResourceBarrier(2, close);
  specmv_state = D3D12_RESOURCE_STATE_NON_PIXEL_SHADER_RESOURCE;
  return true;
}

// evidence texture for the spec-MV pass (RGBA16F UAV, render res), same
// self-healing contract: rebuilt whenever the size differs
#ifdef CONTROL_RR_DEV
inline uint32_t specdbg_texture_width = 0;
inline uint32_t specdbg_texture_height = 0;
inline bool EnsureSpecDbgTexture(ID3D12Device* device, uint32_t width, uint32_t height) {
  if (out_specdbg != nullptr) {
    if (specdbg_texture_width == width && specdbg_texture_height == height) return true;
    out_specdbg->Release();
    out_specdbg = nullptr;
    specdbg_state = D3D12_RESOURCE_STATE_COMMON;
  }
  D3D12_HEAP_PROPERTIES heap_props = {};
  heap_props.Type = D3D12_HEAP_TYPE_DEFAULT;
  D3D12_RESOURCE_DESC desc = {};
  desc.Dimension = D3D12_RESOURCE_DIMENSION_TEXTURE2D;
  desc.Width = width;
  desc.Height = height;
  desc.DepthOrArraySize = 1;
  desc.MipLevels = 1;
  desc.Format = DXGI_FORMAT_R16G16B16A16_FLOAT;
  desc.SampleDesc.Count = 1;
  desc.Flags = D3D12_RESOURCE_FLAG_ALLOW_UNORDERED_ACCESS;
  if (FAILED(device->CreateCommittedResource(&heap_props, D3D12_HEAP_FLAG_NONE, &desc,
                                             D3D12_RESOURCE_STATE_COMMON, nullptr,
                                             IID_PPV_ARGS(&out_specdbg)))) {
    LogWarn("spec debug texture creation failed");
    return false;
  }
  specdbg_texture_width = width;
  specdbg_texture_height = height;
  return true;
}
#endif

// Derive dims/flags from the evaluate-time parameter object if the create
// hook armed too late to see the game's CreateFeature.
inline bool DeriveStashFromEvalParams(const NVSDK_NGX_Parameter* params) {
  auto* p = const_cast<NVSDK_NGX_Parameter*>(params);
  unsigned int width = 0;
  unsigned int height = 0;
  unsigned int ow = 0;
  unsigned int oh = 0;
  if (p->Get(NVSDK_NGX_Parameter_Width, &width) != NVSDK_NGX_Result_Success
      || p->Get(NVSDK_NGX_Parameter_Height, &height) != NVSDK_NGX_Result_Success) {
    return false;
  }
  if (p->Get(NVSDK_NGX_Parameter_OutWidth, &ow) != NVSDK_NGX_Result_Success) ow = width;
  if (p->Get(NVSDK_NGX_Parameter_OutHeight, &oh) != NVSDK_NGX_Result_Success) oh = height;
  int quality = 0;
  p->Get(NVSDK_NGX_Parameter_PerfQualityValue, &quality);
  int flags = 0;
  p->Get(NVSDK_NGX_Parameter_DLSS_Feature_Create_Flags, &flags);
  render_width = width;
  render_height = height;
  out_width = ow;
  out_height = oh;
  perf_quality = quality;
  create_flags = flags;
  create_stash_valid = true;
  Log("creation stash derived from evaluate params (create hook was late)");
  return true;
}

// Log selected NGX scalars and resource descriptions for the first three
// evaluates. This complements the input-geometry log below.
#if defined(CONTROL_RR_DEV) || defined(CONTROL_RR_DIAGNOSTICS)
inline void LogNgxFullParams(const NVSDK_NGX_Parameter* params) {
  auto* p = const_cast<NVSDK_NGX_Parameter*>(params);
  static uint64_t seen = 0;
  if (++seen > 3) return;

  float sharpness = 0.f;
  float pre_exposure = 0.f;
  float exposure_scale = 0.f;
  int reset = 0;
  unsigned int sub_x = 0;
  unsigned int sub_y = 0;
  unsigned int mv_sub_x = 0;
  unsigned int mv_sub_y = 0;
  unsigned int depth_sub_x = 0;
  unsigned int depth_sub_y = 0;
  unsigned int color_sub_x = 0;
  unsigned int color_sub_y = 0;
  unsigned int quality = 0;
  unsigned int flags = 0;
  p->Get(NVSDK_NGX_Parameter_Sharpness, &sharpness);
  p->Get(NVSDK_NGX_Parameter_DLSS_Pre_Exposure, &pre_exposure);
  p->Get(NVSDK_NGX_Parameter_DLSS_Exposure_Scale, &exposure_scale);
  p->Get(NVSDK_NGX_Parameter_Reset, &reset);
  p->Get(NVSDK_NGX_Parameter_DLSS_Input_Color_Subrect_Base_X, &color_sub_x);
  p->Get(NVSDK_NGX_Parameter_DLSS_Input_Color_Subrect_Base_Y, &color_sub_y);
  p->Get(NVSDK_NGX_Parameter_DLSS_Input_Depth_Subrect_Base_X, &depth_sub_x);
  p->Get(NVSDK_NGX_Parameter_DLSS_Input_Depth_Subrect_Base_Y, &depth_sub_y);
  p->Get(NVSDK_NGX_Parameter_DLSS_Input_MV_SubrectBase_X, &mv_sub_x);
  p->Get(NVSDK_NGX_Parameter_DLSS_Input_MV_SubrectBase_Y, &mv_sub_y);
  p->Get(NVSDK_NGX_Parameter_DLSS_Output_Subrect_Base_X, &sub_x);
  p->Get(NVSDK_NGX_Parameter_DLSS_Output_Subrect_Base_Y, &sub_y);
  p->Get(NVSDK_NGX_Parameter_PerfQualityValue, &quality);
  p->Get(NVSDK_NGX_Parameter_DLSS_Feature_Create_Flags, &flags);

  // Every buffer's real description, including how it was allocated: a
  // padded row or an unexpected format is invisible from the size alone.
  auto describe = [&](const char* name, const char* key) {
    ID3D12Resource* res = nullptr;
    if (p->Get(key, &res) != NVSDK_NGX_Result_Success || res == nullptr) {
      Log(std::string("NGX param ") + name + ": (none)");
      return;
    }
    const auto d = res->GetDesc();
    std::stringstream s;
    s << "NGX param " << name << ": " << d.Width << "x" << d.Height << " fmt " << static_cast<int>(d.Format)
      << " flags 0x" << std::hex << static_cast<unsigned int>(d.Flags) << std::dec << " mips " << d.MipLevels
      << " arraySize " << d.DepthOrArraySize << " layout " << static_cast<int>(d.Layout)
      << " alignment " << d.Alignment << " samples " << d.SampleDesc.Count;
    ID3D12Device* device = nullptr;
    if (SUCCEEDED(res->GetDevice(IID_PPV_ARGS(&device))) && device != nullptr) {
      D3D12_PLACED_SUBRESOURCE_FOOTPRINT fp = {};
      UINT64 total = 0;
      device->GetCopyableFootprints(&d, 0, 1, 0, &fp, nullptr, nullptr, &total);
      s << " | rowPitch " << fp.Footprint.RowPitch << " footprintW " << fp.Footprint.Width
        << " totalBytes " << total;
      device->Release();
    }
    Log(s.str());
  };
  describe("Color", NVSDK_NGX_Parameter_Color);
  describe("Output", NVSDK_NGX_Parameter_Output);
  describe("Depth", NVSDK_NGX_Parameter_Depth);
  describe("MotionVectors", NVSDK_NGX_Parameter_MotionVectors);
  describe("ExposureTexture", NVSDK_NGX_Parameter_ExposureTexture);
  describe("TransparencyMask", NVSDK_NGX_Parameter_TransparencyMask);
  describe("BiasCurrentColorMask", NVSDK_NGX_Parameter_DLSS_Input_Bias_Current_Color_Mask);

  std::stringstream s;
  s.precision(9);
  s << "NGX scalars: sharpness " << sharpness << " preExposure " << pre_exposure << " exposureScale "
    << exposure_scale << " reset " << reset << " quality " << quality << " createFlags 0x" << std::hex
    << flags << std::dec << " | subrect bases colour(" << color_sub_x << "," << color_sub_y << ") depth("
    << depth_sub_x << "," << depth_sub_y << ") mv(" << mv_sub_x << "," << mv_sub_y << ") out(" << sub_x
    << "," << sub_y << ")";
  Log(s.str());
}

// Log input geometry for the first eight evaluates and on dimension changes.
inline void LogNgxInputGeometry(const NVSDK_NGX_Parameter* params) {
  auto* p = const_cast<NVSDK_NGX_Parameter*>(params);
  unsigned int w = 0;
  unsigned int h = 0;
  unsigned int sub_w = 0;
  unsigned int sub_h = 0;
  unsigned int ow = 0;
  unsigned int oh = 0;
  float jitter_x = 0.f;
  float jitter_y = 0.f;
  float mv_scale_x = 0.f;
  float mv_scale_y = 0.f;
  p->Get(NVSDK_NGX_Parameter_Width, &w);
  p->Get(NVSDK_NGX_Parameter_Height, &h);
  p->Get(NVSDK_NGX_Parameter_DLSS_Render_Subrect_Dimensions_Width, &sub_w);
  p->Get(NVSDK_NGX_Parameter_DLSS_Render_Subrect_Dimensions_Height, &sub_h);
  p->Get(NVSDK_NGX_Parameter_OutWidth, &ow);
  p->Get(NVSDK_NGX_Parameter_OutHeight, &oh);
  p->Get(NVSDK_NGX_Parameter_Jitter_Offset_X, &jitter_x);
  p->Get(NVSDK_NGX_Parameter_Jitter_Offset_Y, &jitter_y);
  p->Get("MV.Scale.X", &mv_scale_x);
  p->Get("MV.Scale.Y", &mv_scale_y);

  // The buffer the colour actually lives in, straight from D3D - the only
  // number here that cannot be a derived value.
  unsigned int color_w = 0;
  unsigned int color_h = 0;
  ID3D12Resource* color = nullptr;
  if (p->Get(NVSDK_NGX_Parameter_Color, &color) == NVSDK_NGX_Result_Success && color != nullptr) {
    const auto desc = color->GetDesc();
    color_w = static_cast<unsigned int>(desc.Width);
    color_h = desc.Height;
  }

  static uint64_t seen = 0;
  static unsigned int last_w = 0;
  static unsigned int last_h = 0;
  static float last_jx = 0.f;
  const uint64_t n = ++seen;
  const bool changed = (last_w != w || last_h != h);
  if (!changed && n > 8) {  // first 8 + changes only; no periodic census
    last_jx = jitter_x;
    return;
  }
  last_w = w;
  last_h = h;

  std::stringstream s;
  s.precision(9);
  s << "NGX geometry: in " << w << "x" << h << " subrect " << sub_w << "x" << sub_h
    << " out " << ow << "x" << oh << " | colour buffer " << color_w << "x" << color_h
    << " | jitter " << jitter_x << "," << jitter_y << " (prev x " << last_jx << ")"
    << " | MV.Scale " << mv_scale_x << "," << mv_scale_y;
  if (w != 0) {
    s << " | MV.Scale.X/width " << (mv_scale_x / static_cast<float>(w));
  }
  if (h != 0) {
    s << " MV.Scale.Y/height " << (mv_scale_y / static_cast<float>(h));
  }
  if (w != 0 && ow != 0) {
    s << " | ratio out/in " << (static_cast<float>(ow) / static_cast<float>(w));
  }
  if ((w & 1u) != 0u || (h & 1u) != 0u) s << "  [ODD INPUT SIZE]";
  if (color_w != 0 && color_w != w) s << "  [COLOUR BUFFER WIDTH != INPUT WIDTH]";
  Log(s.str());
  last_jx = jitter_x;
}
#endif

inline bool EnsureDlssd(ID3D12GraphicsCommandList* cmd_list) {
  if (dlssd_handle != nullptr) return true;
  if (real_allocate_parameters == nullptr || real_create_feature == nullptr) return false;

  if (dlssd_params == nullptr
      && real_allocate_parameters(&dlssd_params) != NVSDK_NGX_Result_Success) {
    LogWarn("AllocateParameters failed");
    return false;
  }

  auto* p = dlssd_params;
  // Created at the current evaluate's input size. NGX gives the feature a
  // dynamic input range of [creation size, output size] (DLSSD log:
  // InDynamicMinSetDims == creation dims, whatever PerfQualityValue says),
  // so any later size change means a recreate — which the adoption path in
  // the evaluate hook triggers.
  const uint32_t create_w = (eval_width != 0u) ? eval_width : render_width;
  const uint32_t create_h = (eval_height != 0u) ? eval_height : render_height;
  p->Set(NVSDK_NGX_Parameter_Width, create_w);
  p->Set(NVSDK_NGX_Parameter_Height, create_h);
  p->Set(NVSDK_NGX_Parameter_OutWidth, out_width);
  p->Set(NVSDK_NGX_Parameter_OutHeight, out_height);
  p->Set(NVSDK_NGX_Parameter_PerfQualityValue, perf_quality);
  p->Set(NVSDK_NGX_Parameter_DLSS_Feature_Create_Flags, create_flags);
  // keys from nvsdk_ngx_defs_dlssd.h; values are this game's requirements
  p->Set("DLSS.Denoise.Mode", 1u);    // 1 = the unified DL denoiser
  p->Set("DLSS.Roughness.Mode", 1u);  // roughness rides in normals.w
  p->Set("DLSS.Use.HW.Depth", 1u);    // depth input is hardware depth
  // default: preset E — by far the most stable preset in this game's RT-heavy scenes
  const unsigned int preset = rr_preset.load();
  rr_preset_downgraded.store(false);
  dlssd_created_preset = preset;
  p->Set("RayReconstruction.Hint.Render.Preset.DLAA", preset);
  p->Set("RayReconstruction.Hint.Render.Preset.UltraQuality", preset);
  p->Set("RayReconstruction.Hint.Render.Preset.Quality", preset);
  p->Set("RayReconstruction.Hint.Render.Preset.Balanced", preset);
  p->Set("RayReconstruction.Hint.Render.Preset.Performance", preset);
  p->Set("RayReconstruction.Hint.Render.Preset.UltraPerformance", preset);

  auto result = real_create_feature(cmd_list, NVSDK_NGX_Feature_RayReconstruction, p, &dlssd_handle);
  if ((result != NVSDK_NGX_Result_Success || dlssd_handle == nullptr) && preset == 6u) {
    // Preset F (RR2) is driver-gated: dlssd 310.7.128 FAILS creation outright
    // on a driver older than 580 rather than falling back. A failed create
    // is otherwise permanent for the session (rr_failed), so retry once on E
    // rather than losing RR to a dropdown click.
    std::stringstream s;
    s << "DLSSD CreateFeature FAILED on preset F result=0x" << std::hex
      << static_cast<unsigned int>(result) << " - retrying on preset E";
    LogWarn(s.str());
    dlssd_handle = nullptr;
    rr_preset = 5u;
    dlssd_created_preset = 5u;
    rr_preset_downgraded = true;
    const char* keys[] = {
        "RayReconstruction.Hint.Render.Preset.DLAA",
        "RayReconstruction.Hint.Render.Preset.UltraQuality",
        "RayReconstruction.Hint.Render.Preset.Quality",
        "RayReconstruction.Hint.Render.Preset.Balanced",
        "RayReconstruction.Hint.Render.Preset.Performance",
        "RayReconstruction.Hint.Render.Preset.UltraPerformance"};
    for (const char* key : keys) p->Set(key, 5u);
    result = real_create_feature(cmd_list, NVSDK_NGX_Feature_RayReconstruction, p, &dlssd_handle);
  }
  if (result != NVSDK_NGX_Result_Success || dlssd_handle == nullptr) {
    std::stringstream s;
    s << "DLSSD CreateFeature FAILED result=0x" << std::hex << static_cast<unsigned int>(result);
    LogWarn(s.str());
    dlssd_handle = nullptr;
    rr_last_error = static_cast<unsigned int>(result);
    rr_failed = true;
    return false;
  }
  rr_failed.store(false);
  rr_last_error.store(0);
  std::stringstream s;
  s << "DLSSD feature created (" << create_w << "x" << create_h
    << " -> " << out_width << "x" << out_height << ", preset value "
    << dlssd_created_preset << ")";
  Log(s.str());
  return true;
}

// own SuperSampling feature carrying preset hints — evaluated instead of
// the game's hint-less one when an SR preset override is selected
inline bool EnsureOwnSr(ID3D12GraphicsCommandList* cmd_list, unsigned int preset) {
  if (own_sr_handle != nullptr && own_sr_created_preset == preset) return true;
  if (sr_failed.load()) return false;
  if (real_allocate_parameters == nullptr || real_create_feature == nullptr) return false;

  if (own_sr_handle != nullptr) {
    release_own_sr_requested.store(true);
    return false;
  }
  NVSDK_NGX_Result allocate_result = NVSDK_NGX_Result_Success;
  if (own_sr_params == nullptr
      && (allocate_result = real_allocate_parameters(&own_sr_params)) != NVSDK_NGX_Result_Success) {
    LogWarn("AllocateParameters (own SR) failed");
    sr_last_error.store(static_cast<unsigned int>(allocate_result));
    sr_failed.store(true);
    return false;
  }

  auto* p = own_sr_params;
  p->Set(NVSDK_NGX_Parameter_Width, (eval_width != 0u) ? eval_width : render_width);
  p->Set(NVSDK_NGX_Parameter_Height, (eval_height != 0u) ? eval_height : render_height);
  p->Set(NVSDK_NGX_Parameter_OutWidth, out_width);
  p->Set(NVSDK_NGX_Parameter_OutHeight, out_height);
  p->Set(NVSDK_NGX_Parameter_PerfQualityValue, perf_quality);
  p->Set(NVSDK_NGX_Parameter_DLSS_Feature_Create_Flags, create_flags);
  p->Set("DLSS.Hint.Render.Preset.DLAA", preset);
  p->Set("DLSS.Hint.Render.Preset.UltraQuality", preset);
  p->Set("DLSS.Hint.Render.Preset.Quality", preset);
  p->Set("DLSS.Hint.Render.Preset.Balanced", preset);
  p->Set("DLSS.Hint.Render.Preset.Performance", preset);
  p->Set("DLSS.Hint.Render.Preset.UltraPerformance", preset);

  const auto result = real_create_feature(cmd_list, NVSDK_NGX_Feature_SuperSampling, p, &own_sr_handle);
  if (result != NVSDK_NGX_Result_Success || own_sr_handle == nullptr) {
    std::stringstream s;
    s << "own SR CreateFeature FAILED result=0x" << std::hex << static_cast<unsigned int>(result);
    LogWarn(s.str());
    own_sr_handle = nullptr;
    sr_last_error.store(static_cast<unsigned int>(result));
    sr_failed.store(true);
    return false;
  }
  own_sr_created_preset = preset;
  sr_last_error.store(0);
  sr_failed.store(false);
  std::stringstream s;
  s << "own SR feature created (preset value " << preset << ")";
  Log(s.str());
  return true;
}

inline void SetRrEnabled(bool enabled) {
  control_diag::Scope trace("rr.set_enabled");
  control_diag::Mark("rr.enabled.request", enabled);
  const std::lock_guard lock(state_mutex);
  const bool was_enabled = rr_enabled.exchange(enabled);
  if (enabled && !was_enabled) {
    rr_failed.store(false);
    rr_last_error.store(0);
    if (own_sr_handle != nullptr) release_own_sr_requested.store(true);
  } else if (!enabled && was_enabled && dlssd_handle != nullptr) {
    release_dlssd_requested.store(true);
  }
}

inline void SetRrPreset(unsigned int preset) {
  control_diag::Mark("rr.preset.request", preset);
  const std::lock_guard lock(state_mutex);
  if (preset != 6u) rr_preset_downgraded.store(false);
  if (rr_preset.exchange(preset) == preset) return;
  rr_failed.store(false);
  rr_last_error.store(0);
  if (dlssd_handle != nullptr) release_dlssd_requested.store(true);
}

inline void SetSrPreset(unsigned int preset) {
  control_diag::Mark("sr.preset.request", preset);
  const std::lock_guard lock(state_mutex);
  if (sr_preset.exchange(preset) == preset) return;
  sr_failed.store(false);
  sr_last_error.store(0);
  if (own_sr_handle != nullptr) release_own_sr_requested.store(true);
}

// Preset changes and game-SR replacement are applied after the frame's work
// has been submitted. This keeps one NGX instance at a time and places the
// only queue wait on an explicit reconfiguration.
inline void ApplyPendingFeatureChanges(reshade::api::command_queue* queue) {
  if (queue == nullptr) return;
  if (!release_dlssd_requested.load() && !release_own_sr_requested.load()) return;

  const std::lock_guard lock(state_mutex);
  if (!release_dlssd_requested.load() && !release_own_sr_requested.load()) return;
  control_diag::Scope trace("rr.reconfigure");
  control_diag::Mark("rr.wait_idle.begin", reinterpret_cast<uint64_t>(queue));
  queue->wait_idle();
  control_diag::Mark("rr.wait_idle.end");

  auto release = [&](NVSDK_NGX_Handle*& handle, std::atomic<bool>& requested,
                     const char* name, bool is_rr) {
    if (!requested.load()) return;
    if (handle == nullptr) {
      requested.store(false);
      return;
    }
    if (real_release_feature == nullptr) return;
    control_diag::Mark("ngx.release.begin", reinterpret_cast<uint64_t>(handle));
    const auto result = real_release_feature(handle);
    control_diag::Mark("ngx.release.end", reinterpret_cast<uint64_t>(handle), static_cast<uint64_t>(result));
    if (result != NVSDK_NGX_Result_Success) {
      std::stringstream s;
      s << name << " release failed result=0x" << std::hex
        << static_cast<unsigned int>(result);
      LogWarn(s.str());
      requested.store(false);
      if (is_rr) {
        rr_last_error.store(static_cast<unsigned int>(result));
        rr_failed.store(true);
      } else {
        sr_last_error.store(static_cast<unsigned int>(result));
        sr_failed.store(true);
      }
      return;
    }
    handle = nullptr;
    requested.store(false);
    Log(std::string(name) + " released for recreate");
  };

  release(dlssd_handle, release_dlssd_requested, "DLSSD", true);
  release(own_sr_handle, release_own_sr_requested, "own SR", false);
}

// ---------------------------------------------------------------------------
// Main-camera matrices, taken from the sys_constants buffer that the DLF
// SPECULAR SPATIAL dispatch (hash 0x87EDDD47) had bound at b0.
//
// Identification is by PROVENANCE, not by content: the buffer is the one a
// known shader had bound, so the offsets are guaranteed to describe it —
// content-sniffing a "w, h, 1/w, 1/h" fingerprint is not unique and finds
// impostor buffers. g_mClipToView at +224 is corroborated by our own
// replacement shader (dlf_spatial_spec.hlsli declares it at
// packoffset(c14) = byte 224). Capture checks the projection shape, aspect
// ratio and previous-view transform before publishing matrices.
// ---------------------------------------------------------------------------

inline float mat_view_to_clip[16];
inline float mat_clip_to_view[16];
inline float mat_clip_to_prev_clip[16];
inline bool mat_valid = false;

// Row-vector convention throughout, row-major storage: v' = v * M, and
// (A*B)[i][j] = sum_k A[i][k]*B[k][j]. Same layout the game stores.
inline void Mul4(const float* a, const float* b, float* out) {
  for (int i = 0; i < 4; ++i) {
    for (int j = 0; j < 4; ++j) {
      float sum = 0.0f;
      for (int k = 0; k < 4; ++k) sum += a[(i * 4) + k] * b[(k * 4) + j];
      out[(i * 4) + j] = sum;
    }
  }
}

// Gauss-Jordan with partial pivoting. Returns false on a singular matrix
// rather than emitting infinities into the motion field.
inline bool Invert4(const float* m, float* out) {
  double a[4][8];
  for (int r = 0; r < 4; ++r) {
    for (int c = 0; c < 4; ++c) a[r][c] = m[(r * 4) + c];
    for (int c = 0; c < 4; ++c) a[r][4 + c] = (r == c) ? 1.0 : 0.0;
  }
  for (int c = 0; c < 4; ++c) {
    int pivot = c;
    for (int r = c + 1; r < 4; ++r) {
      if (fabs(a[r][c]) > fabs(a[pivot][c])) pivot = r;
    }
    if (fabs(a[pivot][c]) < 1e-12) return false;
    if (pivot != c) {
      for (int k = 0; k < 8; ++k) std::swap(a[c][k], a[pivot][k]);
    }
    const double inv_pivot = 1.0 / a[c][c];
    for (int k = 0; k < 8; ++k) a[c][k] *= inv_pivot;
    for (int r = 0; r < 4; ++r) {
      if (r == c) continue;
      const double f = a[r][c];
      if (f == 0.0) continue;
      for (int k = 0; k < 8; ++k) a[r][k] -= f * a[c][k];
    }
  }
  for (int r = 0; r < 4; ++r) {
    for (int c = 0; c < 4; ++c) out[(r * 4) + c] = static_cast<float>(a[r][4 + c]);
  }
  return true;
}

// ---------------------------------------------------------------------------
// Camera matrices, pushed from the specular spatial dispatch.
//
// Only two of the three are readable anywhere: Control writes only the
// constants a pass reads, and no shader we have reads g_mClipToPreviousClip.
// The specular passes read g_mClipToView (+224) and g_mPreviousViewToView
// (+544), so those two are real; the third is composed from them.
//
//   ViewToClip     = inverse(ClipToView)
//   ClipToPrevClip = ClipToView * inverse(PrevViewToView) * ViewToClip
//
// which is just the journey spelled out: this frame's screen -> view space ->
// last frame's view space -> last frame's screen. The last leg uses this
// frame's projection because the FOV does not change between frames; only the
// jitter does, and SpecMV takes a DIFFERENCE of two reprojections, so a
// constant NDC offset cancels. A FOV change mid-frame (aim-down-sights,
// cutscene zoom) is the case this does not cover.
// ---------------------------------------------------------------------------

inline std::mutex matrix_mutex;
inline std::atomic<uint64_t> matrix_updates = 0;
inline uint64_t matrix_last_consumed = 0;

inline void InvalidateCameraMatrices() {
  const std::lock_guard lock(matrix_mutex);
  mat_valid = false;
}

inline void SetCameraMatrices(const float* clip_to_view, const float* prev_view_to_view) {
  float view_to_clip[16];
  float view_to_prev_view[16];
  if (!Invert4(clip_to_view, view_to_clip) || !Invert4(prev_view_to_view, view_to_prev_view)) {
    InvalidateCameraMatrices();
    return;
  }

  float tmp[16];
  float clip_to_prev_clip[16];
  Mul4(clip_to_view, view_to_prev_view, tmp);
  Mul4(tmp, view_to_clip, clip_to_prev_clip);

#ifdef CONTROL_RR_DEV
  // Developer-only algebra check.
  // with no measured ground truth, so it reports rather than hides.
  //  - inversion residual: max |ClipToView * ViewToClip - I|
  //  - when the camera has not moved, PrevViewToView is identity and the
  //    composition must collapse to identity too. That is a real test of the
  //    algebra using the game's own data, available every time you stand still.
  float round_trip[16];
  Mul4(clip_to_view, view_to_clip, round_trip);
  float inv_err = 0.0f;
  float still_err = 0.0f;
  float motion = 0.0f;
  for (int i = 0; i < 16; ++i) {
    const float ident = ((i / 4) == (i % 4)) ? 1.0f : 0.0f;
    inv_err = std::max(inv_err, fabsf(round_trip[i] - ident));
    still_err = std::max(still_err, fabsf(clip_to_prev_clip[i] - ident));
    motion = std::max(motion, fabsf(prev_view_to_view[i] - ident));
  }
#endif

  {
    const std::lock_guard lock(matrix_mutex);
    memcpy(mat_clip_to_view, clip_to_view, 64);
    memcpy(mat_view_to_clip, view_to_clip, 64);
    memcpy(mat_clip_to_prev_clip, clip_to_prev_clip, 64);
    mat_valid = true;
    matrix_updates.fetch_add(1);
  }

#ifdef CONTROL_RR_DEV
  const uint64_t n = matrix_updates.load();
  if (n == 1) {  // once; the periodic census was a render-thread file write
    std::stringstream s;
    s.precision(6);
    s << "matrices: inverse_residual=" << inv_err
      << " camera_motion=" << motion
      << " clip_to_prev_clip_vs_identity=" << still_err;
    if (motion < 1e-5f) {
      // standing still: the composition MUST be identity, so this is a verdict
      s << (still_err < 1e-3f ? "  [STILL: composition OK]" : "  [STILL: COMPOSITION WRONG]");
    }
    Log(s.str());
  }
#endif
}

// A matrix set is valid for the evaluate following its capture only. Reusing
// an older transform with current depth and hit positions creates plausible
// but incorrect reflection motion.
inline bool ConsumeFreshMatrices(SpecMvConstants& constants) {
  const std::lock_guard lock(matrix_mutex);
  const uint64_t update = matrix_updates.load();
  if (!mat_valid || update == matrix_last_consumed) return false;
  memcpy(constants.clip_to_view, mat_clip_to_view, 64);
  memcpy(constants.view_to_clip, mat_view_to_clip, 64);
  memcpy(constants.clip_to_prev_clip, mat_clip_to_prev_clip, 64);
  matrix_last_consumed = update;
  return true;
}

#ifdef CONTROL_RR_DEV
// ---------------------------------------------------------------------------
// Diagnostic dump — our decoded guides plus the game's own RR inputs, written to
// the standard renodx output folder (renodx-dev/dump). Copies are recorded
// at evaluate and written 4 evaluates later, once the GPU has certainly
// executed them. rr_dump_meta.txt carries per-file dimensions, format and
// row pitch so the offline convert script can interpret the raw blobs.
// ---------------------------------------------------------------------------

inline std::atomic<bool> dump_requested = false;
inline void RequestDump() { dump_requested = true; }

constexpr int kDumpCount = 10;
inline ID3D12Resource* dump_readbacks[kDumpCount] = {};
inline D3D12_PLACED_SUBRESOURCE_FOOTPRINT dump_footprints[kDumpCount] = {};
inline const char* kDumpNames[kDumpCount] = {
    "rr_guide_normals.bin", "rr_guide_diffuse.bin", "rr_guide_spec.bin",
    "rr_input_color.bin",   "rr_input_depth.bin",   "rr_input_mvec.bin",
    "rr_hitinfo.bin",       "rr_specmv.bin",        "rr_specdbg.bin",
    // The upscaler's RESULT. Without it a dump cannot say whether noise is
    // already in the ray-traced input or is produced by the reconstruction.
    "rr_output_color.bin"};
inline int dump_countdown = -1;
// The upscaler's output does not exist until the evaluate has been recorded,
// so slot 9 is copied AFTER it, on the same command list.
constexpr int kDumpOutputIndex = 9;
inline ID3D12Resource* dump_pending_output = nullptr;

// called in the RR-active path, guides already in NON_PIXEL_SHADER_RESOURCE
inline void ServiceDump(ID3D12GraphicsCommandList* cmd_list, ID3D12Device* device,
                        NVSDK_NGX_Parameter* params) {
  if (dump_requested.exchange(false) && dump_readbacks[0] == nullptr) {
    ID3D12Resource* color = nullptr;
    ID3D12Resource* depth = nullptr;
    ID3D12Resource* mvec = nullptr;
    ID3D12Resource* output = nullptr;
    params->Get(NVSDK_NGX_Parameter_Color, &color);
    params->Get(NVSDK_NGX_Parameter_Depth, &depth);
    params->Get(NVSDK_NGX_Parameter_MotionVectors, &mvec);
    params->Get(NVSDK_NGX_Parameter_Output, &output);
    ID3D12Resource* sources[kDumpCount] = {out_nr,      out_diffuse, out_spec, color,
                                           depth,       mvec,        guide_hitinfo.load(),
                                           out_specmv,  out_specdbg, output};

    D3D12_HEAP_PROPERTIES readback_heap = {};
    readback_heap.Type = D3D12_HEAP_TYPE_READBACK;

    std::stringstream meta;
    int recorded = 0;
    for (int i = 0; i < kDumpCount; ++i) {
      if (sources[i] == nullptr) continue;

      auto src_desc = sources[i]->GetDesc();
      UINT64 total_bytes = 0;
      device->GetCopyableFootprints(&src_desc, 0, 1, 0, &dump_footprints[i], nullptr, nullptr,
                                    &total_bytes);

      D3D12_RESOURCE_DESC buffer_desc = {};
      buffer_desc.Dimension = D3D12_RESOURCE_DIMENSION_BUFFER;
      buffer_desc.Width = total_bytes;
      buffer_desc.Height = 1;
      buffer_desc.DepthOrArraySize = 1;
      buffer_desc.MipLevels = 1;
      buffer_desc.SampleDesc.Count = 1;
      buffer_desc.Layout = D3D12_TEXTURE_LAYOUT_ROW_MAJOR;
      if (FAILED(device->CreateCommittedResource(&readback_heap, D3D12_HEAP_FLAG_NONE, &buffer_desc,
                                                 D3D12_RESOURCE_STATE_COPY_DEST, nullptr,
                                                 IID_PPV_ARGS(&dump_readbacks[i])))) {
        continue;
      }

      if (i == kDumpOutputIndex) {
        // Recorded post-evaluate by ServiceDumpOutput; copying it here would
        // capture the PREVIOUS frame's result, which is worse than useless.
        dump_pending_output = sources[i];
        meta << kDumpNames[i] << " w=" << dump_footprints[i].Footprint.Width
             << " h=" << dump_footprints[i].Footprint.Height
             << " fmt=" << static_cast<int>(dump_footprints[i].Footprint.Format)
             << " pitch=" << dump_footprints[i].Footprint.RowPitch << "\n";
        recorded++;
        continue;
      }

      // guides sit in NON_PIXEL (transitioned by the evaluate path); the
      // game's inputs are expected in the same state at evaluate time
      D3D12_RESOURCE_BARRIER to_copy = {};
      to_copy.Type = D3D12_RESOURCE_BARRIER_TYPE_TRANSITION;
      to_copy.Transition.pResource = sources[i];
      to_copy.Transition.Subresource = D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;
      // The DLSS output is a UAV; everything else reaches here as an SRV.
      to_copy.Transition.StateBefore = (sources[i] == output)
                                           ? D3D12_RESOURCE_STATE_UNORDERED_ACCESS
                                           : D3D12_RESOURCE_STATE_NON_PIXEL_SHADER_RESOURCE;
      to_copy.Transition.StateAfter = D3D12_RESOURCE_STATE_COPY_SOURCE;
      cmd_list->ResourceBarrier(1, &to_copy);

      D3D12_TEXTURE_COPY_LOCATION dst = {};
      dst.pResource = dump_readbacks[i];
      dst.Type = D3D12_TEXTURE_COPY_TYPE_PLACED_FOOTPRINT;
      dst.PlacedFootprint = dump_footprints[i];
      D3D12_TEXTURE_COPY_LOCATION src = {};
      src.pResource = sources[i];
      src.Type = D3D12_TEXTURE_COPY_TYPE_SUBRESOURCE_INDEX;
      src.SubresourceIndex = 0;
      cmd_list->CopyTextureRegion(&dst, 0, 0, 0, &src, nullptr);

      D3D12_RESOURCE_BARRIER back = to_copy;
      back.Transition.StateBefore = D3D12_RESOURCE_STATE_COPY_SOURCE;
      back.Transition.StateAfter = to_copy.Transition.StateBefore;
      cmd_list->ResourceBarrier(1, &back);

      meta << kDumpNames[i] << " w=" << dump_footprints[i].Footprint.Width
           << " h=" << dump_footprints[i].Footprint.Height
           << " fmt=" << static_cast<int>(dump_footprints[i].Footprint.Format)
           << " pitch=" << dump_footprints[i].Footprint.RowPitch << "\n";
      recorded++;
    }

    if (recorded > 0) {
      // Camera state, so a dump can be reconstructed offline. Without these
      // the depth buffer cannot be turned back into view-space positions, so
      // nothing in the dump can be compared against the scene's own scale —
      // which is exactly how we check whether hit distances are in world
      // units. MV.Scale records the game's motion-vector convention.
      float mv_scale_x = 1.0f;
      float mv_scale_y = 1.0f;
      params->Get("MV.Scale.X", &mv_scale_x);
      params->Get("MV.Scale.Y", &mv_scale_y);
      meta.precision(9);
      meta << "render " << render_width << " " << render_height << "\n";
      meta << "mv_scale " << mv_scale_x << " " << mv_scale_y << "\n";
      auto write_matrix = [&meta](const char* name, const float* m) {
        meta << name;
        for (int i = 0; i < 16; ++i) meta << " " << m[i];
        meta << "\n";
      };
      write_matrix("clip_to_view", mat_clip_to_view);
      write_matrix("view_to_clip", mat_view_to_clip);
      write_matrix("clip_to_prev_clip", mat_clip_to_prev_clip);

      const auto dump_path = renodx::utils::path::GetDumpOutputPath();

      std::error_code ec;
      std::filesystem::create_directories(dump_path, ec);
      auto meta_text = meta.str();
      renodx::utils::path::WriteTextFile(dump_path / "rr_dump_meta.txt", meta_text);
      dump_countdown = 4;
      std::stringstream s;
      s << "dump x" << recorded << " recorded";
      Log(s.str());
    }
  } else if (dump_countdown > 0 && --dump_countdown == 0) {
    const auto dump_path = renodx::utils::path::GetDumpOutputPath();
    for (int i = 0; i < kDumpCount; ++i) {
      ID3D12Resource*& readback = dump_readbacks[i];
      if (readback == nullptr) continue;
      void* mapped = nullptr;
      if (SUCCEEDED(readback->Map(0, nullptr, &mapped))) {
        renodx::utils::path::WriteBinaryFile(
            dump_path / kDumpNames[i],
            {static_cast<uint8_t*>(mapped),
             static_cast<size_t>(dump_footprints[i].Footprint.RowPitch)
                 * dump_footprints[i].Footprint.Height});
        readback->Unmap(0, nullptr);
      }
      readback->Release();
      readback = nullptr;
    }

    dump_countdown = -1;
    std::stringstream s;
    s << "dump written (guides + color/depth/mvec) to " << dump_path.string();
    Log(s.str());
  }
}

// Copy of the upscaler's output, recorded AFTER the evaluate on the same
// command list, so GPU ordering sees the finished result. This is what makes
// a dump able to say whether noise is already in the ray-traced input or is
// produced by the reconstruction.
inline void ServiceDumpOutput(ID3D12GraphicsCommandList* cmd_list) {
  if (dump_pending_output == nullptr || dump_readbacks[kDumpOutputIndex] == nullptr) return;
  ID3D12Resource* output = dump_pending_output;
  dump_pending_output = nullptr;

  D3D12_RESOURCE_BARRIER to_copy = {};
  to_copy.Type = D3D12_RESOURCE_BARRIER_TYPE_TRANSITION;
  to_copy.Transition.pResource = output;
  to_copy.Transition.Subresource = D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;
  to_copy.Transition.StateBefore = D3D12_RESOURCE_STATE_UNORDERED_ACCESS;
  to_copy.Transition.StateAfter = D3D12_RESOURCE_STATE_COPY_SOURCE;
  cmd_list->ResourceBarrier(1, &to_copy);

  D3D12_TEXTURE_COPY_LOCATION dst = {};
  dst.pResource = dump_readbacks[kDumpOutputIndex];
  dst.Type = D3D12_TEXTURE_COPY_TYPE_PLACED_FOOTPRINT;
  dst.PlacedFootprint = dump_footprints[kDumpOutputIndex];
  D3D12_TEXTURE_COPY_LOCATION src = {};
  src.pResource = output;
  src.Type = D3D12_TEXTURE_COPY_TYPE_SUBRESOURCE_INDEX;
  src.SubresourceIndex = 0;
  cmd_list->CopyTextureRegion(&dst, 0, 0, 0, &src, nullptr);

  D3D12_RESOURCE_BARRIER back = to_copy;
  back.Transition.StateBefore = D3D12_RESOURCE_STATE_COPY_SOURCE;
  back.Transition.StateAfter = D3D12_RESOURCE_STATE_UNORDERED_ACCESS;
  cmd_list->ResourceBarrier(1, &back);
  Log("dump: upscaler output copy recorded after evaluate");
}
#endif

// ---------------------------------------------------------------------------
// hooks
// ---------------------------------------------------------------------------

inline NVSDK_NGX_Result NVSDK_CONV HookedCreateFeature(
    ID3D12GraphicsCommandList* cmd_list, NVSDK_NGX_Feature feature,
    NVSDK_NGX_Parameter* params, NVSDK_NGX_Handle** out_handle) {
  control_diag::Scope trace("ngx.create");
  control_diag::Mark("ngx.create.feature", static_cast<uint64_t>(feature), reinterpret_cast<uint64_t>(cmd_list));
  {
    static std::atomic<int> logged = 0;
    if (logged.fetch_add(1) < 8) {
      std::stringstream s;
      s << "NGX CreateFeature(feature=" << static_cast<int>(feature) << ") called from "
        << ModuleNameOf(_ReturnAddress());
      Log(s.str());
    }
  }
  // Frame generation defaults this off, and nothing in the stack turns it on.
  // It is what makes it interpolate the hud-less colour and the UI layer
  // separately from the back buffer, which is the whole point of supplying
  // them. It has to be set before the feature is created, and this is the
  // only place that sees that moment. 11 = NVSDK_NGX_Feature_FrameGeneration.
  if (feature == static_cast<NVSDK_NGX_Feature>(11) && params != nullptr) {
    params->Set("DLSSG.UserInterfaceRecompositionEnabled", 1);
  }

  const auto result = real_create_feature(cmd_list, feature, params, out_handle);
  control_diag::Mark("ngx.create.result", static_cast<uint64_t>(result),
      out_handle != nullptr ? reinterpret_cast<uint64_t>(*out_handle) : 0);

  if (feature == static_cast<NVSDK_NGX_Feature>(11)) {
    dlssg_probe::active.store(result == NVSDK_NGX_Result_Success
                              && out_handle != nullptr && *out_handle != nullptr);
  }

  if (feature == NVSDK_NGX_Feature_SuperSampling && result == NVSDK_NGX_Result_Success
      && out_handle != nullptr && *out_handle != nullptr) {
    const std::lock_guard lock(state_mutex);
    game_sr_handle = *out_handle;
    unsigned int width = 0;
    unsigned int height = 0;
    unsigned int ow = 0;
    unsigned int oh = 0;
    params->Get(NVSDK_NGX_Parameter_Width, &width);
    params->Get(NVSDK_NGX_Parameter_Height, &height);
    params->Get(NVSDK_NGX_Parameter_OutWidth, &ow);
    params->Get(NVSDK_NGX_Parameter_OutHeight, &oh);
    params->Get(NVSDK_NGX_Parameter_PerfQualityValue, &perf_quality);
    params->Get(NVSDK_NGX_Parameter_DLSS_Feature_Create_Flags, &create_flags);
    render_width = width;
    render_height = height;
    out_width = ow;
    out_height = oh;
    create_stash_valid = (width != 0 && height != 0);

    // game re-created SR (resolution change) — our features are stale.
    // A failure latched against the OLD feature does not condemn the new one.
    rr_failed = false;
    rr_last_error = 0;
    sr_failed = false;
    sr_last_error = 0;
    if (dlssd_handle != nullptr) release_dlssd_requested.store(true);
    if (own_sr_handle != nullptr) release_own_sr_requested.store(true);
    // Our textures are NOT released here: EnsureGuideTextures /
    // EnsureSpecMvTexture compare against the resolution they were built at
    // and rebuild themselves. One mechanism, nothing to forget.

    std::stringstream s;
    s << "game SR feature created: " << width << "x" << height << " -> " << ow << "x" << oh
      << " quality=" << perf_quality << " flags=0x" << std::hex << create_flags;
    Log(s.str());
    SetStatus(Status::kWaitingGuides, "game SR (re)created");
  }
  return result;
}

inline NVSDK_NGX_Result EvaluateLogged(
    ID3D12GraphicsCommandList* cmd_list, const NVSDK_NGX_Handle* handle,
    const NVSDK_NGX_Parameter* params, PFN_NVSDK_NGX_ProgressCallback callback) {
  control_diag::Mark("ngx.native_evaluate.begin", reinterpret_cast<uint64_t>(handle));
  const auto result = real_evaluate_feature(cmd_list, handle, params, callback);
  control_diag::Mark("ngx.native_evaluate.end", reinterpret_cast<uint64_t>(handle), static_cast<uint64_t>(result));
  if (result != NVSDK_NGX_Result_Success) {
    static std::atomic<unsigned int> logged_error = 0;
    if (logged_error.exchange(static_cast<unsigned int>(result)) == static_cast<unsigned int>(result)) return result;
    std::stringstream message;
    message << "native evaluate failed handle=" << handle << " result=0x"
            << std::hex << static_cast<unsigned int>(result);
    LogWarn(message.str());
  }
  return result;
}

inline NVSDK_NGX_Result NVSDK_CONV HookedEvaluateFeature(
    ID3D12GraphicsCommandList* cmd_list, const NVSDK_NGX_Handle* handle,
    const NVSDK_NGX_Parameter* params, PFN_NVSDK_NGX_ProgressCallback callback) {
  control_diag::Scope trace("ngx.evaluate");
  control_diag::Mark("ngx.evaluate.handle", reinterpret_cast<uint64_t>(handle), reinterpret_cast<uint64_t>(cmd_list));
  const std::lock_guard lock(state_mutex);
  control_diag::Mark("ngx.evaluate.lock_acquired");

  // Adopt an SR-shaped evaluate on a handle we do not know: the create hook
  // armed too late, or the game replaced its feature by a path the hook did
  // not see. Falling through silently here is what "RR stops and nothing in
  // the overlay brings it back" looks like from the outside.
  if (handle != nullptr && handle != game_sr_handle && handle != dlssd_handle
      && handle != own_sr_handle && params != nullptr) {
    ID3D12Resource* color = nullptr;
    ID3D12Resource* mvec = nullptr;
    auto* p = const_cast<NVSDK_NGX_Parameter*>(params);
    if (p->Get(NVSDK_NGX_Parameter_Color, &color) == NVSDK_NGX_Result_Success
        && p->Get(NVSDK_NGX_Parameter_MotionVectors, &mvec) == NVSDK_NGX_Result_Success
        && color != nullptr && mvec != nullptr) {
      std::stringstream s;
      s << "adopted SR handle " << static_cast<const void*>(handle) << " at evaluate (previous "
        << static_cast<const void*>(game_sr_handle) << ")";
      Log(s.str());
      game_sr_handle = const_cast<NVSDK_NGX_Handle*>(handle);
      // the replaced feature's size is unknown — rebuild ours from the evaluate
      if (dlssd_handle != nullptr) release_dlssd_requested.store(true);
      if (own_sr_handle != nullptr) release_own_sr_requested.store(true);
      create_stash_valid = false;
      rr_failed = false;
      rr_last_error = 0;
      sr_failed = false;
      sr_last_error = 0;
    } else {
#if defined(CONTROL_RR_DEV) || defined(CONTROL_RR_DIAGNOSTICS)
      static const void* logged_unknown = nullptr;
      if (logged_unknown != handle) {
        logged_unknown = handle;
        std::stringstream s;
        s << "evaluate on unknown non-SR handle " << static_cast<const void*>(handle);
        Log(s.str());
      }
#endif
    }
  }
  if (handle == game_sr_handle && handle != nullptr && params != nullptr) {
    if (!create_stash_valid) DeriveStashFromEvalParams(params);
    ReadEvalDims(params);
#if defined(CONTROL_RR_DEV) || defined(CONTROL_RR_DIAGNOSTICS)
    LogNgxInputGeometry(params);
    LogNgxFullParams(params);
#endif
  }

  const bool is_game_sr = (handle == game_sr_handle && handle != nullptr);
  if (!is_game_sr || !rr_enabled.load() || rr_failed.load()
      || release_dlssd_requested.load() || release_own_sr_requested.load()) {
    if (is_game_sr) {
      if (rr_failed.load()) {
        SetStatus(Status::kFailed, "previous DLSSD failure");
      } else if (release_dlssd_requested.load() || release_own_sr_requested.load()) {
        SetStatus(Status::kFallbackSr, "NGX feature waiting for safe reconfiguration");
      } else {
        SetStatus(Status::kFallbackSr, "RR toggled off");
      }
      // SR preset override: evaluate our own hinted SR feature instead
      const unsigned int preset = sr_preset.load();
      if (!rr_enabled.load() && preset != 0u && !sr_failed.load()
          && !release_dlssd_requested.load() && !release_own_sr_requested.load()) {
        if (!create_stash_valid) DeriveStashFromEvalParams(params);
        if (create_stash_valid && EnsureOwnSr(cmd_list, preset)) {
          const auto result = EvaluateLogged(cmd_list, own_sr_handle, params, callback);
          if (result == NVSDK_NGX_Result_Success) return result;
          sr_last_error.store(static_cast<unsigned int>(result));
          sr_failed.store(true);
          std::stringstream s;
          s << "own SR evaluate failed result=0x" << std::hex
            << static_cast<unsigned int>(result) << " — falling back to game SR feature";
          LogWarn(s.str());
        }
      }
    }
    return EvaluateLogged(cmd_list, handle, params, callback);
  }

  if (dlssd_handle != nullptr && dlssd_created_preset != rr_preset.load()) {
    release_dlssd_requested.store(true);
    return EvaluateLogged(cmd_list, handle, params, callback);
  }

  // --- RR path ---
  ID3D12Resource* gbuffer1 = guide_gbuffer1.load();
  if (gbuffer1 == nullptr) {
    SetStatus(Status::kWaitingGuides, "no gbuffer1 captured (guides zeroed or no DLF dispatch yet)");
    return EvaluateLogged(cmd_list, handle, params, callback);
  }

  if (!create_stash_valid && !DeriveStashFromEvalParams(params)) {
    SetStatus(Status::kWaitingGuides, "no creation stash");
    return EvaluateLogged(cmd_list, handle, params, callback);
  }

  ID3D12Device* device = nullptr;
  if (FAILED(cmd_list->GetDevice(IID_PPV_ARGS(&device))) || device == nullptr) {
    return EvaluateLogged(cmd_list, handle, params, callback);
  }
  device->Release();  // process-lifetime device; no need to hold a ref

  // Guides are allocated at the evaluate's input size (render res), exactly
  // like the game's own colour/depth/MV inputs — NOT larger; render-res is
  // the tested state.
  if (!rrg_pass.Init(device) || !EnsureGuideTextures(device, eval_width, eval_height)
      || !EnsureDlssd(cmd_list)) {
    if (rr_failed.load()) {
      SetStatus(Status::kFailed, "DLSSD create failed");
    } else {
      SetStatus(Status::kWaitingGuides, "pass/texture/feature setup incomplete");
    }
    return EvaluateLogged(cmd_list, handle, params, callback);
  }

  // decode guides on the game's command list, right before evaluate
  ID3D12Resource* outputs[3] = {out_nr, out_diffuse, out_spec};
  for (int i = 0; i < 3; ++i) {
    if (out_states[i] == D3D12_RESOURCE_STATE_UNORDERED_ACCESS) continue;
    D3D12_RESOURCE_BARRIER to_uav = {};
    to_uav.Type = D3D12_RESOURCE_BARRIER_TYPE_TRANSITION;
    to_uav.Transition.pResource = outputs[i];
    to_uav.Transition.Subresource = D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;
    to_uav.Transition.StateBefore = out_states[i];
    to_uav.Transition.StateAfter = D3D12_RESOURCE_STATE_UNORDERED_ACCESS;
    cmd_list->ResourceBarrier(1, &to_uav);
    out_states[i] = D3D12_RESOURCE_STATE_UNORDERED_ACCESS;
  }

  rrg_pass.Dispatch(cmd_list, gbuffer1, guide_gbuffer2.load(), guide_material.load(),
                    guide_envbrdf.load(), out_nr, out_diffuse, out_spec,
                    eval_width, eval_height);
  control_diag::Mark("rr.guide_dispatch.complete");

  D3D12_RESOURCE_BARRIER barriers[6] = {};
  for (int i = 0; i < 3; ++i) {
    barriers[i].Type = D3D12_RESOURCE_BARRIER_TYPE_UAV;
    barriers[i].UAV.pResource = outputs[i];
    barriers[3 + i].Type = D3D12_RESOURCE_BARRIER_TYPE_TRANSITION;
    barriers[3 + i].Transition.pResource = outputs[i];
    barriers[3 + i].Transition.Subresource = D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;
    barriers[3 + i].Transition.StateBefore = D3D12_RESOURCE_STATE_UNORDERED_ACCESS;
    barriers[3 + i].Transition.StateAfter = D3D12_RESOURCE_STATE_NON_PIXEL_SHADER_RESOURCE;
    out_states[i] = D3D12_RESOURCE_STATE_NON_PIXEL_SHADER_RESOURCE;
  }
  cmd_list->ResourceBarrier(6, barriers);

  // guide params on the game's own parameter object (string-keyed; extra
  // keys are harmless to SR if we ever fall back)
  auto* p = const_cast<NVSDK_NGX_Parameter*>(params);
  p->Set("GBuffer.Normals", out_nr);
  p->Set("GBuffer.Roughness", out_nr);  // packed mode
  p->Set("DLSS.Input.DiffuseAlbedo", out_diffuse);
  p->Set("GBuffer.DiffuseAlbedo", out_diffuse);
  p->Set("DLSS.Input.SpecularAlbedo", out_spec);
  p->Set("GBuffer.SpecularAlbedo", out_spec);

  // constant responsivity mask (user slider); 0 = not sent
  {
    const float value = responsivity_value.load();
    ID3D12Resource* mask = nullptr;
    if (value != 0.f && EnsureResponsivityMask(device, cmd_list, eval_width, eval_height, value)) {
      mask = mask_texture;
    }
    p->Set("DLSSD.ResponsivityMask", mask);
  }
  // Identity matrices apply no additional transform to the view-space normals
  // supplied by the guide pass.
  static float identity[16] = {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1};

  // This is the GAME's parameter object and it persists across frames, so a
  // key we set once and then stop setting stays set forever. Clear both
  // mode-owned texture keys up front and let the branches below re-set only
  // what their mode actually owns; otherwise modes leak into each other and
  // toggling is not idempotent (mode 1 would keep mode 2's now-frozen
  // reflection MVs, and mode 0 would keep both). The matrices need no clear
  // — every path below writes them.
  // Two keys for the reflection MVs: GBuffer.SpecularMvec is what the
  // official DLSS-RR helper binds (nvsdk_ngx_helpers_dlssd.h,
  // NVSDK_NGX_Parameter_GBuffer_SpecularMvec); MotionVectorsReflection is
  // the older DLSS-2-era name that is still accepted.
  // Set both — which one the current model reads is not documented.
  p->Set("GBuffer.SpecularMvec", static_cast<ID3D12Resource*>(nullptr));
  p->Set("MotionVectorsReflection", static_cast<ID3D12Resource*>(nullptr));
  p->Set("DLSSD.SpecularHitDistance", static_cast<ID3D12Resource*>(nullptr));
  ID3D12Resource* refl_matid = guide_matid.load();
  ID3D12Resource* refl_hitpos = guide_hitpos.load();
  SpecMvConstants constants = {};
  const bool matrices_fresh = ConsumeFreshMatrices(constants);
  ID3D12Resource* game_depth = nullptr;
  ID3D12Resource* game_mv = nullptr;
  p->Get(NVSDK_NGX_Parameter_Depth, &game_depth);
  p->Get(NVSDK_NGX_Parameter_MotionVectors, &game_mv);
  bool specmv_ready = false;

  if (matrices_fresh && refl_matid != nullptr && refl_hitpos != nullptr) {
    // app-computed spec MVs from the reflection pass's per-ray hit arrays:
    // our shader consumes the matrices (raw game layout, no
    // NGX transpose trap); NGX receives only a texture
    if (game_depth != nullptr && game_mv != nullptr && specmv_pass.Init(device)) {
      bool outputs_ready = EnsureSpecMvTexture(device, eval_width, eval_height);
#ifdef CONTROL_RR_DEV
      outputs_ready = outputs_ready && EnsureSpecDbgTexture(device, eval_width, eval_height);
#endif
      if (outputs_ready) {
        // game MV convention inherited via the correction formulation;
        // scale converts only the ndc-space correction term. MV.Scale maps
        // stored values to pixels; guard degenerate scales.
        float scale_x = 1.0f;
        float scale_y = 1.0f;
        p->Get("MV.Scale.X", &scale_x);
        p->Get("MV.Scale.Y", &scale_y);
        if (fabsf(scale_x) < 1e-8f) scale_x = 1.0f;
        if (fabsf(scale_y) < 1e-8f) scale_y = 1.0f;

        constants.width = eval_width;
        constants.height = eval_height;
        constants.mv_out_scale_x = 0.5f * static_cast<float>(eval_width) / scale_x;
        constants.mv_out_scale_y = -0.5f * static_cast<float>(eval_height) / scale_y;
        constants.layers = refl_hitpos->GetDesc().DepthOrArraySize;

        auto to_uav = [&](ID3D12Resource* res, D3D12_RESOURCE_STATES& state) {
          if (state == D3D12_RESOURCE_STATE_UNORDERED_ACCESS) return;
          D3D12_RESOURCE_BARRIER b = {};
          b.Type = D3D12_RESOURCE_BARRIER_TYPE_TRANSITION;
          b.Transition.pResource = res;
          b.Transition.Subresource = D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;
          b.Transition.StateBefore = state;
          b.Transition.StateAfter = D3D12_RESOURCE_STATE_UNORDERED_ACCESS;
          cmd_list->ResourceBarrier(1, &b);
          state = D3D12_RESOURCE_STATE_UNORDERED_ACCESS;
        };
        to_uav(out_specmv, specmv_state);
#ifdef CONTROL_RR_DEV
        constexpr bool debug_ready = true;
        to_uav(out_specdbg, specdbg_state);
        ID3D12Resource* debug_output = out_specdbg;
#else
        ID3D12Resource* debug_output = nullptr;
#endif

        specmv_pass.Dispatch(cmd_list, gbuffer1, refl_matid, refl_hitpos, game_depth, game_mv,
                             out_specmv, debug_output, constants);

        D3D12_RESOURCE_BARRIER after[4] = {};
        UINT barrier_count = 0;
        after[barrier_count].Type = D3D12_RESOURCE_BARRIER_TYPE_UAV;
        after[barrier_count++].UAV.pResource = out_specmv;
        after[barrier_count].Type = D3D12_RESOURCE_BARRIER_TYPE_TRANSITION;
        after[barrier_count].Transition.pResource = out_specmv;
        after[barrier_count].Transition.Subresource = D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;
        after[barrier_count].Transition.StateBefore = D3D12_RESOURCE_STATE_UNORDERED_ACCESS;
        after[barrier_count++].Transition.StateAfter = D3D12_RESOURCE_STATE_NON_PIXEL_SHADER_RESOURCE;
#ifdef CONTROL_RR_DEV
        if (debug_ready) {
          after[barrier_count].Type = D3D12_RESOURCE_BARRIER_TYPE_UAV;
          after[barrier_count++].UAV.pResource = out_specdbg;
          after[barrier_count].Type = D3D12_RESOURCE_BARRIER_TYPE_TRANSITION;
          after[barrier_count].Transition.pResource = out_specdbg;
          after[barrier_count].Transition.Subresource = D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;
          after[barrier_count].Transition.StateBefore = D3D12_RESOURCE_STATE_UNORDERED_ACCESS;
          after[barrier_count++].Transition.StateAfter = D3D12_RESOURCE_STATE_NON_PIXEL_SHADER_RESOURCE;
          specdbg_state = D3D12_RESOURCE_STATE_NON_PIXEL_SHADER_RESOURCE;
        }
#endif
        cmd_list->ResourceBarrier(barrier_count, after);
        specmv_state = D3D12_RESOURCE_STATE_NON_PIXEL_SHADER_RESOURCE;

        specmv_ready = true;
        static bool specmv_logged = false;
        if (!specmv_logged) {
          std::stringstream s;
          s << "mode 2: spec MVs feeding DLSSD from the reflection hit arrays (layers="
            << constants.layers << ", MV.Scale=" << scale_x << "," << scale_y << ")";
          Log(s.str());
          specmv_logged = true;
        }
      }
    }
  }

  if (!specmv_ready && game_mv != nullptr
      && EnsureSpecMvTexture(device, eval_width, eval_height)) {
    control_diag::Mark("specmv.ordinary_fallback", matrices_fresh,
        (refl_matid != nullptr ? 1u : 0u) | (refl_hitpos != nullptr ? 2u : 0u));
    specmv_ready = CopyOrdinaryMotion(cmd_list, game_mv);
  }
  if (specmv_ready) {
    p->Set("GBuffer.SpecularMvec", out_specmv);
    p->Set("MotionVectorsReflection", out_specmv);
  }

  p->Set("WorldToViewMatrix", static_cast<void*>(identity));
  p->Set("ViewToClipMatrix", static_cast<void*>(identity));

#ifdef CONTROL_RR_DEV
  ServiceDump(cmd_list, device, p);
#endif

  const auto result = EvaluateLogged(cmd_list, dlssd_handle, params, callback);
#ifdef CONTROL_RR_DEV
  ServiceDumpOutput(cmd_list);
#endif
  if (result != NVSDK_NGX_Result_Success) {
    std::stringstream s;
    s << "DLSSD EvaluateFeature FAILED result=0x" << std::hex << static_cast<unsigned int>(result)
      << " — permanent fallback to game SR";
    LogWarn(s.str());
    rr_last_error.store(static_cast<unsigned int>(result));
    rr_failed = true;
    SetStatus(Status::kFailed, "DLSSD evaluate failed");
    // rescue this frame with the real SR evaluate so the output is written
    return EvaluateLogged(cmd_list, handle, params, callback);
  }
  SetStatus(Status::kActive, "DLSSD evaluating");
  return result;
}

// ---------------------------------------------------------------------------
// arming — detour the NGX runtime's exports once the module is loaded
// ---------------------------------------------------------------------------

inline bool ArmNgxHooks(HMODULE ngx_module) {
  if (ngx_armed.load()) return true;
  if (ngx_module == nullptr) return false;
  const std::lock_guard install_lock(control_rr::detour_mutex);
  if (ngx_armed.load()) return true;

  auto* create = reinterpret_cast<PFN_CreateFeature>(
      GetProcAddress(ngx_module, "NVSDK_NGX_D3D12_CreateFeature"));
  auto* evaluate = reinterpret_cast<PFN_EvaluateFeature>(
      GetProcAddress(ngx_module, "NVSDK_NGX_D3D12_EvaluateFeature"));
  auto* allocate = reinterpret_cast<PFN_AllocateParameters>(
      GetProcAddress(ngx_module, "NVSDK_NGX_D3D12_AllocateParameters"));
  auto* release = reinterpret_cast<PFN_ReleaseFeature>(
      GetProcAddress(ngx_module, "NVSDK_NGX_D3D12_ReleaseFeature"));
  if (create == nullptr || evaluate == nullptr) return false;

  real_create_feature = create;
  real_evaluate_feature = evaluate;
  LONG error = DetourTransactionBegin();
  const bool transaction_started = error == NO_ERROR;
  if (error == NO_ERROR) error = DetourUpdateThread(GetCurrentThread());
  if (error == NO_ERROR) {
    error = DetourAttach(reinterpret_cast<void**>(&real_create_feature), HookedCreateFeature);
  }
  if (error == NO_ERROR) {
    error = DetourAttach(reinterpret_cast<void**>(&real_evaluate_feature), HookedEvaluateFeature);
  }
  if (error != NO_ERROR) {
    if (transaction_started) DetourTransactionAbort();
  } else {
    error = DetourTransactionCommit();
  }
  if (error != NO_ERROR) {
    LogWarn("Detour commit FAILED for NGX exports");
    real_create_feature = create;
    real_evaluate_feature = evaluate;
    return false;
  }

  real_allocate_parameters = allocate;
  real_release_feature = release;
  ngx_armed = true;
  SetStatus(Status::kArmedNoSr, "NGX exports hooked");
  // Log only the module filename so shared logs do not expose local paths.
  Log("NGX D3D12 exports hooked (CreateFeature + EvaluateFeature) in " + ModuleNameOf(ngx_module));
  return true;
}

inline bool TryArmFromLoadedModules() {
  if (ngx_armed.load()) return true;
  HMODULE ngx = GetModuleHandleW(L"_nvngx.dll");
  if (ngx == nullptr) ngx = GetModuleHandleW(L"nvngx.dll");
  return ArmNgxHooks(ngx);
}

// LoadLibrary hooks close the race between the NGX runtime loading and the
// game's first CreateFeature (they can be back-to-back).
inline decltype(&LoadLibraryW) real_load_library_w = nullptr;
inline decltype(&LoadLibraryExW) real_load_library_ex_w = nullptr;
inline decltype(&LoadLibraryA) real_load_library_a = nullptr;
inline decltype(&LoadLibraryExA) real_load_library_ex_a = nullptr;

inline void MaybeArmFromPath(const wchar_t* path, HMODULE loaded) {
  if (ngx_armed.load() || path == nullptr || loaded == nullptr) return;
  const wchar_t* name = wcsrchr(path, L'\\');
  name = (name != nullptr) ? name + 1 : path;
  if (_wcsicmp(name, L"_nvngx.dll") == 0 || _wcsicmp(name, L"nvngx.dll") == 0) {
    ArmNgxHooks(loaded);
  }
}

inline void MaybeArmFromPathA(const char* path, HMODULE loaded) {
  if (ngx_armed.load() || path == nullptr || loaded == nullptr) return;
  const char* name = strrchr(path, '\\');
  name = (name != nullptr) ? name + 1 : path;
  if (_stricmp(name, "_nvngx.dll") == 0 || _stricmp(name, "nvngx.dll") == 0) {
    ArmNgxHooks(loaded);
  }
}

inline HMODULE WINAPI HookedLoadLibraryW(LPCWSTR file_name) {
  HMODULE ret = real_load_library_w(file_name);
  MaybeArmFromPath(file_name, ret);
  return ret;
}
inline HMODULE WINAPI HookedLoadLibraryExW(LPCWSTR file_name, HANDLE file, DWORD flags) {
  HMODULE ret = real_load_library_ex_w(file_name, file, flags);
  MaybeArmFromPath(file_name, ret);
  return ret;
}
inline HMODULE WINAPI HookedLoadLibraryA(LPCSTR file_name) {
  HMODULE ret = real_load_library_a(file_name);
  MaybeArmFromPathA(file_name, ret);
  return ret;
}
inline HMODULE WINAPI HookedLoadLibraryExA(LPCSTR file_name, HANDLE file, DWORD flags) {
  HMODULE ret = real_load_library_ex_a(file_name, file, flags);
  MaybeArmFromPathA(file_name, ret);
  return ret;
}

inline std::atomic<bool> loader_hooks_installed = false;

inline bool IsGameProcess() {
  const auto file_name = renodx::utils::platform::GetCurrentProcessPath().filename().string();
  return _stricmp(file_name.c_str(), "Control_DX12.exe") == 0;
}

inline void InstallLoaderHooks() {
  // The launcher (Control.exe) loads this addon too and exits immediately;
  // hooks left in it dangle after our DLL unloads and crash its shutdown.
  // Only the real game process runs DLSS.
  if (!IsGameProcess()) {
    Log("not the game process — hooks not installed");
    return;
  }
  {
    const std::lock_guard install_lock(control_rr::detour_mutex);
    if (!loader_hooks_installed.load()) {
      real_load_library_w = &LoadLibraryW;
      real_load_library_ex_w = &LoadLibraryExW;
      real_load_library_a = &LoadLibraryA;
      real_load_library_ex_a = &LoadLibraryExA;
      LONG error = DetourTransactionBegin();
      const bool transaction_started = error == NO_ERROR;
      if (error == NO_ERROR) error = DetourUpdateThread(GetCurrentThread());
      if (error == NO_ERROR) error = DetourAttach(reinterpret_cast<void**>(&real_load_library_w), HookedLoadLibraryW);
      if (error == NO_ERROR) error = DetourAttach(reinterpret_cast<void**>(&real_load_library_ex_w), HookedLoadLibraryExW);
      if (error == NO_ERROR) error = DetourAttach(reinterpret_cast<void**>(&real_load_library_a), HookedLoadLibraryA);
      if (error == NO_ERROR) error = DetourAttach(reinterpret_cast<void**>(&real_load_library_ex_a), HookedLoadLibraryExA);
      if (error != NO_ERROR) {
        if (transaction_started) DetourTransactionAbort();
      } else {
        error = DetourTransactionCommit();
      }
      if (error != NO_ERROR) {
        LogWarn("LoadLibrary detours FAILED — will poll for NGX module instead");
      } else {
        loader_hooks_installed = true;
        Log("LoadLibrary hooks installed (watching for NGX runtime)");
      }
    }
  }
  // in case the runtime is already resident
  TryArmFromLoadedModules();
}

// MUST run on DLL_PROCESS_DETACH: any detour left attached after this DLL
// unloads points into freed memory (crashed the launcher's shutdown before
// this existed).
inline void UninstallHooks() {
  const std::lock_guard install_lock(control_rr::detour_mutex);
  const bool had_loader = loader_hooks_installed.load();
  const bool had_ngx = ngx_armed.load();
  if (!had_loader && !had_ngx) return;
  LONG error = DetourTransactionBegin();
  const bool transaction_started = error == NO_ERROR;
  if (error == NO_ERROR) error = DetourUpdateThread(GetCurrentThread());
  if (had_loader) {
    if (error == NO_ERROR) error = DetourDetach(reinterpret_cast<void**>(&real_load_library_w), HookedLoadLibraryW);
    if (error == NO_ERROR) error = DetourDetach(reinterpret_cast<void**>(&real_load_library_ex_w), HookedLoadLibraryExW);
    if (error == NO_ERROR) error = DetourDetach(reinterpret_cast<void**>(&real_load_library_a), HookedLoadLibraryA);
    if (error == NO_ERROR) error = DetourDetach(reinterpret_cast<void**>(&real_load_library_ex_a), HookedLoadLibraryExA);
  }
  if (had_ngx) {
    if (error == NO_ERROR) error = DetourDetach(reinterpret_cast<void**>(&real_create_feature), HookedCreateFeature);
    if (error == NO_ERROR) error = DetourDetach(reinterpret_cast<void**>(&real_evaluate_feature), HookedEvaluateFeature);
  }
  if (error != NO_ERROR) {
    if (transaction_started) DetourTransactionAbort();
    LogWarn("hook detach transaction failed");
  } else {
    error = DetourTransactionCommit();
    if (error != NO_ERROR) {
      LogWarn("hook detach commit failed");
    } else {
      if (had_loader) loader_hooks_installed.store(false);
      if (had_ngx) ngx_armed.store(false);
    }
  }
}

}  // namespace rr
