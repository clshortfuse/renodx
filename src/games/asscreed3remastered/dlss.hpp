#pragma once

#include <array>
#include <cstdint>
#include <cstring>
#include <sstream>
#include <string>
#include <utility>

#include <d3d11.h>
#include <d3dcompiler.h>
#include <Windows.h>
#include <include/reshade.hpp>
#include <nvsdk_ngx.h>
#include <nvsdk_ngx_helpers.h>
#include <wrl/client.h>

#include "../../utils/bitwise.hpp"
#include "../../utils/descriptor.hpp"
#include "../../utils/directx.hpp"
#include "../../utils/pipeline_layout.hpp"
#include "../../utils/shader.hpp"

namespace ac3r::dlss {

static constexpr uint32_t kTemporalAAHash = 0x78DC7D04u;
static constexpr uint32_t kTemporalAAConstantBufferIndex = 5u;
static constexpr uint64_t kTemporalAASubPixelJitterOffset = 32u;
static constexpr uint32_t kTrackedSrvCount = 8u;
static constexpr uint32_t kTrackedRtvCount = 8u;

struct __declspec(uuid("e4fedc25-d6cf-457d-924b-a95d63a35475")) CommandListData {
  std::array<reshade::api::resource_view, kTrackedSrvCount> pixel_srvs = {};
  std::array<reshade::api::resource_view, kTrackedRtvCount> rtvs = {};
  reshade::api::buffer_range temporal_aa_constants = {};
  reshade::api::resource_view dsv = {};
};

struct NgxRuntime {
  Microsoft::WRL::ComPtr<ID3D11Device> device;
  Microsoft::WRL::ComPtr<ID3D11Texture2D> output_texture;
  Microsoft::WRL::ComPtr<ID3D11Texture2D> preconditioned_motion_vectors;
  Microsoft::WRL::ComPtr<ID3D11ShaderResourceView> preconditioned_motion_vectors_srv;
  Microsoft::WRL::ComPtr<ID3D11UnorderedAccessView> preconditioned_motion_vectors_uav;
  Microsoft::WRL::ComPtr<ID3D11ComputeShader> motion_vector_prepass_cs;
  Microsoft::WRL::ComPtr<ID3D11Buffer> motion_vector_prepass_constants;
  Microsoft::WRL::ComPtr<ID3D11Buffer> temporal_constants_staging;
  NVSDK_NGX_Parameter* parameters = nullptr;
  NVSDK_NGX_Handle* feature = nullptr;
  uint32_t temporal_constants_staging_size = 0u;
  uint32_t width = 0u;
  uint32_t height = 0u;
  DXGI_FORMAT output_format = DXGI_FORMAT_UNKNOWN;
  int render_preset = -1;
  int feature_flags = 0;
  bool initialized = false;
  bool init_failed = false;
  bool create_failed = false;
  bool eval_failed = false;
  bool logged_success = false;
  bool logged_jitter = false;
  bool logged_mv_prepass = false;
  bool mv_prepass_failed = false;
};

inline float dlaa_enabled = 0.f;
inline float dlaa_render_preset = 0.f;
inline float dlaa_sharpness = 0.f;
inline float dlaa_responsive_mask = 1.f;
inline float dlaa_jitter_scale = 1.f;
inline float dlaa_jitter_mode = 0.f;
inline float dlaa_motion_vector_prepass_jitter_mode = 0.f;
inline float dlaa_motion_vector_mode = 3.f;
inline float dlaa_motion_vectors_jittered = 0.f;
inline bool is_nvidia_device = false;
inline bool hdr_output_active = true;
inline bool attached = false;
inline bool logged_taa_inputs = false;
inline NgxRuntime ngx;

struct MotionVectorPrepassConstants {
  float size[4];
  float jitter[4];
};

static constexpr const char* kMotionVectorPrepassShader = R"(
Texture2D<float2> MotionVectors : register(t0);
Texture2D<float> Depth : register(t1);
RWTexture2D<float2> Output : register(u0);

cbuffer MotionVectorPrepassConstants : register(b0) {
  float4 Size;
  float4 Jitter;
}

int2 ClampCoord(int2 coord) {
  return clamp(coord, int2(0, 0), int2(Size.xy) - int2(1, 1));
}

float LoadDepth(int2 coord) {
  return Depth.Load(int3(ClampCoord(coord), 0));
}

float2 LoadMotionVector(int2 coord) {
  return MotionVectors.Load(int3(ClampCoord(coord), 0));
}

[numthreads(8, 8, 1)]
void main(uint3 dispatch_id : SV_DispatchThreadID) {
  if (dispatch_id.x >= (uint)Size.x || dispatch_id.y >= (uint)Size.y) return;

  const int2 base_coord = int2(dispatch_id.xy);

  float min_depth = LoadDepth(base_coord);
  float max_depth = min_depth;
  int2 min_offset = int2(0, 0);
  int2 max_offset = int2(0, 0);

  [unroll]
  for (int y = -1; y <= 1; ++y) {
    [unroll]
    for (int x = -1; x <= 1; ++x) {
      const int2 offset = int2(x, y);
      const float depth = LoadDepth(base_coord + offset);
      if (depth < min_depth) {
        min_depth = depth;
        min_offset = offset;
      }
      if (depth > max_depth) {
        max_depth = depth;
        max_offset = offset;
      }
    }
  }

  const float2 min_motion = LoadMotionVector(base_coord + min_offset);
  const float2 max_motion = LoadMotionVector(base_coord + max_offset);
  const float2 disagreement_pixels = (max_motion - min_motion) * Size.xy;
  const bool disocclusion_edge = dot(disagreement_pixels, disagreement_pixels) > 4.f;

  const int jitter_x = Jitter.x < 0.f ? -1 : 1;
  const int jitter_y = Jitter.y < 0.f ? -1 : 1;
  int2 jitter_selected_offset = int2(0, 0);
  float jitter_selected_depth = LoadDepth(base_coord);

  [unroll]
  for (int y_candidate = 0; y_candidate <= 1; ++y_candidate) {
    [unroll]
    for (int x_candidate = 0; x_candidate <= 1; ++x_candidate) {
      const int2 offset = int2(x_candidate * jitter_x, y_candidate * jitter_y);
      const float depth = LoadDepth(base_coord + offset);
      if (depth < jitter_selected_depth) {
        jitter_selected_depth = depth;
        jitter_selected_offset = offset;
      }
    }
  }

  const float2 jitter_selected_motion = LoadMotionVector(base_coord + jitter_selected_offset);

  // Native TAA uses the far/min-depth neighborhood vector for ordinary pixels, then
  // switches to a jitter-quadrant neighborhood vector when near/far vectors disagree.
  Output[dispatch_id.xy] = disocclusion_edge ? jitter_selected_motion : min_motion;
}
)";

inline std::wstring GetProcessDirectory() {
  std::array<wchar_t, MAX_PATH> path = {};
  const DWORD length = GetModuleFileNameW(nullptr, path.data(), static_cast<DWORD>(path.size()));
  if (length == 0u || length >= path.size()) return L".";

  std::wstring result(path.data(), length);
  const auto separator = result.find_last_of(L"\\/");
  if (separator == std::wstring::npos) return L".";
  return result.substr(0u, separator);
}

inline CommandListData* Get(reshade::api::command_list* cmd_list) {
  if (cmd_list == nullptr) return nullptr;
  auto* data = cmd_list->get_private_data<CommandListData>();
  return data != nullptr ? data : cmd_list->create_private_data<CommandListData>();
}

inline const char* ResultToString(NVSDK_NGX_Result result) {
  switch (result) {
    case NVSDK_NGX_Result_Success:
      return "Success";
    case NVSDK_NGX_Result_FAIL_FeatureNotSupported:
      return "FeatureNotSupported";
    case NVSDK_NGX_Result_FAIL_PlatformError:
      return "PlatformError";
    case NVSDK_NGX_Result_FAIL_FeatureAlreadyExists:
      return "FeatureAlreadyExists";
    case NVSDK_NGX_Result_FAIL_FeatureNotFound:
      return "FeatureNotFound";
    case NVSDK_NGX_Result_FAIL_InvalidParameter:
      return "InvalidParameter";
    case NVSDK_NGX_Result_FAIL_ScratchBufferTooSmall:
      return "ScratchBufferTooSmall";
    case NVSDK_NGX_Result_FAIL_NotInitialized:
      return "NotInitialized";
    case NVSDK_NGX_Result_FAIL_UnsupportedInputFormat:
      return "UnsupportedInputFormat";
    case NVSDK_NGX_Result_FAIL_RWFlagMissing:
      return "RWFlagMissing";
    case NVSDK_NGX_Result_FAIL_MissingInput:
      return "MissingInput";
    case NVSDK_NGX_Result_FAIL_UnableToInitializeFeature:
      return "UnableToInitializeFeature";
    case NVSDK_NGX_Result_FAIL_OutOfDate:
      return "OutOfDate";
    case NVSDK_NGX_Result_FAIL_OutOfGPUMemory:
      return "OutOfGPUMemory";
    case NVSDK_NGX_Result_FAIL_UnsupportedFormat:
      return "UnsupportedFormat";
    case NVSDK_NGX_Result_FAIL_UnableToWriteToAppDataPath:
      return "UnableToWriteToAppDataPath";
    case NVSDK_NGX_Result_FAIL_UnsupportedParameter:
      return "UnsupportedParameter";
    case NVSDK_NGX_Result_FAIL_Denied:
      return "Denied";
    case NVSDK_NGX_Result_FAIL_NotImplemented:
      return "NotImplemented";
    default:
      return "Unknown";
  }
}

inline bool IsSupported() {
  return is_nvidia_device;
}

inline void ReleaseFeature() {
  if (ngx.feature != nullptr) {
    NVSDK_NGX_D3D11_ReleaseFeature(ngx.feature);
    ngx.feature = nullptr;
  }
  ngx.output_texture.Reset();
  ngx.preconditioned_motion_vectors.Reset();
  ngx.preconditioned_motion_vectors_srv.Reset();
  ngx.preconditioned_motion_vectors_uav.Reset();
  ngx.width = 0u;
  ngx.height = 0u;
  ngx.output_format = DXGI_FORMAT_UNKNOWN;
  ngx.render_preset = -1;
  ngx.feature_flags = 0;
  ngx.create_failed = false;
  ngx.eval_failed = false;
  ngx.logged_success = false;
  ngx.logged_mv_prepass = false;
}

inline void ReleaseNgx() {
  ReleaseFeature();
  if (ngx.parameters != nullptr) {
    NVSDK_NGX_D3D11_DestroyParameters(ngx.parameters);
    ngx.parameters = nullptr;
  }
  ngx.temporal_constants_staging.Reset();
  ngx.motion_vector_prepass_cs.Reset();
  ngx.motion_vector_prepass_constants.Reset();
  ngx.temporal_constants_staging_size = 0u;
  if (ngx.initialized) {
    NVSDK_NGX_D3D11_Shutdown1(ngx.device.Get());
  }
  ngx.device.Reset();
  ngx.initialized = false;
  ngx.init_failed = false;
}

inline bool EnsureNgxInitialized(reshade::api::device* device) {
  if (ngx.initialized) return true;
  if (ngx.init_failed) return false;
  if (device == nullptr) return false;

  auto* native_device = reinterpret_cast<ID3D11Device*>(device->get_native());
  if (native_device == nullptr) return false;

  const std::wstring process_directory = GetProcessDirectory();
  wchar_t* feature_paths[] = {const_cast<wchar_t*>(process_directory.c_str())};
  NVSDK_NGX_FeatureCommonInfo feature_info = {};
  feature_info.PathListInfo.Length = 1u;
  feature_info.PathListInfo.Path = feature_paths;

  const NVSDK_NGX_Result init_result = NVSDK_NGX_D3D11_Init_with_ProjectID(
      "2bce07a2-a7da-4c76-9a65-52d9c9819a0e",
      NVSDK_NGX_ENGINE_TYPE_CUSTOM,
      "1.0",
      process_directory.c_str(),
      native_device,
      &feature_info,
      NVSDK_NGX_Version_API);
  if (NVSDK_NGX_FAILED(init_result)) {
    ngx.init_failed = true;
    std::stringstream s;
    s << "AC3R DLAA: NGX init failed: " << ResultToString(init_result)
      << " (0x" << std::hex << static_cast<uint32_t>(init_result) << ")";
    reshade::log::message(reshade::log::level::error, s.str().c_str());
    return false;
  }

  const NVSDK_NGX_Result params_result = NVSDK_NGX_D3D11_GetCapabilityParameters(&ngx.parameters);
  if (NVSDK_NGX_FAILED(params_result) || ngx.parameters == nullptr) {
    ngx.init_failed = true;
    std::stringstream s;
    s << "AC3R DLAA: NGX capability parameters failed: " << ResultToString(params_result)
      << " (0x" << std::hex << static_cast<uint32_t>(params_result) << ")";
    reshade::log::message(reshade::log::level::error, s.str().c_str());
    NVSDK_NGX_D3D11_Shutdown1(native_device);
    return false;
  }

  ngx.device = native_device;
  ngx.initialized = true;

  int super_sampling_available = 0;
  ngx.parameters->Get(NVSDK_NGX_Parameter_SuperSampling_Available, &super_sampling_available);
  std::stringstream s;
  s << "AC3R DLAA: NGX initialized, feature path=";
  std::string process_directory_narrow(process_directory.begin(), process_directory.end());
  s << process_directory_narrow;
  s << ", SuperSampling_Available=" << super_sampling_available;
  reshade::log::message(reshade::log::level::info, s.str().c_str());
  return true;
}

inline bool EnsureOutputTexture(ID3D11Device* device, uint32_t width, uint32_t height, DXGI_FORMAT format) {
  if (device == nullptr || width == 0u || height == 0u) return false;
  if (format == DXGI_FORMAT_UNKNOWN) return false;
  if (ngx.output_texture != nullptr && ngx.width == width && ngx.height == height && ngx.output_format == format) return true;

  ReleaseFeature();

  D3D11_TEXTURE2D_DESC desc = {};
  desc.Width = width;
  desc.Height = height;
  desc.MipLevels = 1u;
  desc.ArraySize = 1u;
  desc.Format = format;
  desc.SampleDesc.Count = 1u;
  desc.Usage = D3D11_USAGE_DEFAULT;
  desc.BindFlags = D3D11_BIND_SHADER_RESOURCE | D3D11_BIND_UNORDERED_ACCESS | D3D11_BIND_RENDER_TARGET;

  const HRESULT hr = device->CreateTexture2D(&desc, nullptr, ngx.output_texture.ReleaseAndGetAddressOf());
  if (FAILED(hr)) {
    std::stringstream s;
    s << "AC3R DLAA: output texture creation failed: 0x" << std::hex << static_cast<uint32_t>(hr);
    reshade::log::message(reshade::log::level::error, s.str().c_str());
    return false;
  }

  ngx.width = width;
  ngx.height = height;
  ngx.output_format = format;
  return true;
}

inline bool EnsureMotionVectorPrepass(ID3D11Device* device, uint32_t width, uint32_t height) {
  if (device == nullptr || width == 0u || height == 0u || ngx.mv_prepass_failed) return false;

  if (ngx.motion_vector_prepass_cs == nullptr) {
    if (!renodx::utils::directx::Initialize() || renodx::utils::directx::pD3DCompile == nullptr) {
      ngx.mv_prepass_failed = true;
      reshade::log::message(reshade::log::level::warning, "AC3R DLAA: motion-vector prepass disabled, D3DCompile unavailable");
      return false;
    }

    ID3DBlob* shader_blob = nullptr;
    ID3DBlob* error_blob = nullptr;
    const HRESULT compile_hr = renodx::utils::directx::pD3DCompile(
        kMotionVectorPrepassShader,
        std::strlen(kMotionVectorPrepassShader),
        "AC3R_DLAA_MotionVectorPrepass",
        nullptr,
        nullptr,
        "main",
        "cs_5_0",
        0u,
        0u,
        &shader_blob,
        &error_blob);
    if (FAILED(compile_hr) || shader_blob == nullptr) {
      ngx.mv_prepass_failed = true;
      std::stringstream s;
      s << "AC3R DLAA: motion-vector prepass compile failed: 0x" << std::hex << static_cast<uint32_t>(compile_hr);
      if (error_blob != nullptr) {
        s << " " << static_cast<const char*>(error_blob->GetBufferPointer());
      }
      reshade::log::message(reshade::log::level::error, s.str().c_str());
      if (shader_blob != nullptr) shader_blob->Release();
      if (error_blob != nullptr) error_blob->Release();
      return false;
    }

    const HRESULT shader_hr = device->CreateComputeShader(
        shader_blob->GetBufferPointer(),
        shader_blob->GetBufferSize(),
        nullptr,
        ngx.motion_vector_prepass_cs.ReleaseAndGetAddressOf());
    shader_blob->Release();
    if (error_blob != nullptr) error_blob->Release();
    if (FAILED(shader_hr) || ngx.motion_vector_prepass_cs == nullptr) {
      ngx.mv_prepass_failed = true;
      std::stringstream s;
      s << "AC3R DLAA: motion-vector prepass shader creation failed: 0x" << std::hex << static_cast<uint32_t>(shader_hr);
      reshade::log::message(reshade::log::level::error, s.str().c_str());
      return false;
    }
  }

  if (ngx.motion_vector_prepass_constants == nullptr) {
    D3D11_BUFFER_DESC constant_desc = {};
    constant_desc.ByteWidth = sizeof(MotionVectorPrepassConstants);
    constant_desc.Usage = D3D11_USAGE_DEFAULT;
    constant_desc.BindFlags = D3D11_BIND_CONSTANT_BUFFER;

    const HRESULT hr = device->CreateBuffer(&constant_desc, nullptr, ngx.motion_vector_prepass_constants.ReleaseAndGetAddressOf());
    if (FAILED(hr) || ngx.motion_vector_prepass_constants == nullptr) {
      std::stringstream s;
      s << "AC3R DLAA: motion-vector prepass constant buffer creation failed: 0x" << std::hex << static_cast<uint32_t>(hr);
      reshade::log::message(reshade::log::level::error, s.str().c_str());
      return false;
    }
  }

  if (ngx.preconditioned_motion_vectors != nullptr && ngx.width == width && ngx.height == height) return true;

  D3D11_TEXTURE2D_DESC texture_desc = {};
  texture_desc.Width = width;
  texture_desc.Height = height;
  texture_desc.MipLevels = 1u;
  texture_desc.ArraySize = 1u;
  texture_desc.Format = DXGI_FORMAT_R16G16_FLOAT;
  texture_desc.SampleDesc.Count = 1u;
  texture_desc.Usage = D3D11_USAGE_DEFAULT;
  texture_desc.BindFlags = D3D11_BIND_SHADER_RESOURCE | D3D11_BIND_UNORDERED_ACCESS;

  ngx.preconditioned_motion_vectors_srv.Reset();
  ngx.preconditioned_motion_vectors_uav.Reset();
  const HRESULT texture_hr = device->CreateTexture2D(
      &texture_desc,
      nullptr,
      ngx.preconditioned_motion_vectors.ReleaseAndGetAddressOf());
  if (FAILED(texture_hr) || ngx.preconditioned_motion_vectors == nullptr) {
    std::stringstream s;
    s << "AC3R DLAA: motion-vector prepass texture creation failed: 0x" << std::hex << static_cast<uint32_t>(texture_hr);
    reshade::log::message(reshade::log::level::error, s.str().c_str());
    return false;
  }

  D3D11_SHADER_RESOURCE_VIEW_DESC srv_desc = {};
  srv_desc.Format = texture_desc.Format;
  srv_desc.ViewDimension = D3D11_SRV_DIMENSION_TEXTURE2D;
  srv_desc.Texture2D.MipLevels = 1u;
  const HRESULT srv_hr = device->CreateShaderResourceView(
      ngx.preconditioned_motion_vectors.Get(),
      &srv_desc,
      ngx.preconditioned_motion_vectors_srv.ReleaseAndGetAddressOf());
  if (FAILED(srv_hr) || ngx.preconditioned_motion_vectors_srv == nullptr) {
    std::stringstream s;
    s << "AC3R DLAA: motion-vector prepass SRV creation failed: 0x" << std::hex << static_cast<uint32_t>(srv_hr);
    reshade::log::message(reshade::log::level::error, s.str().c_str());
    return false;
  }

  D3D11_UNORDERED_ACCESS_VIEW_DESC uav_desc = {};
  uav_desc.Format = texture_desc.Format;
  uav_desc.ViewDimension = D3D11_UAV_DIMENSION_TEXTURE2D;
  const HRESULT uav_hr = device->CreateUnorderedAccessView(
      ngx.preconditioned_motion_vectors.Get(),
      &uav_desc,
      ngx.preconditioned_motion_vectors_uav.ReleaseAndGetAddressOf());
  if (FAILED(uav_hr) || ngx.preconditioned_motion_vectors_uav == nullptr) {
    std::stringstream s;
    s << "AC3R DLAA: motion-vector prepass UAV creation failed: 0x" << std::hex << static_cast<uint32_t>(uav_hr);
    reshade::log::message(reshade::log::level::error, s.str().c_str());
    return false;
  }

  return true;
}

inline int GetRenderPresetValue() {
  switch (static_cast<int>(dlaa_render_preset)) {
    case 1:
      return static_cast<int>(NVSDK_NGX_DLSS_Hint_Render_Preset_F);
    case 2:
      return static_cast<int>(NVSDK_NGX_DLSS_Hint_Render_Preset_J);
    case 3:
      return static_cast<int>(NVSDK_NGX_DLSS_Hint_Render_Preset_K);
    case 4:
      return static_cast<int>(NVSDK_NGX_DLSS_Hint_Render_Preset_L);
    case 5:
      return static_cast<int>(NVSDK_NGX_DLSS_Hint_Render_Preset_M);
    default:
      return static_cast<int>(NVSDK_NGX_DLSS_Hint_Render_Preset_Default);
  }
}

inline const char* GetRenderPresetName(int preset) {
  switch (preset) {
    case static_cast<int>(NVSDK_NGX_DLSS_Hint_Render_Preset_F):
      return "F";
    case static_cast<int>(NVSDK_NGX_DLSS_Hint_Render_Preset_J):
      return "J";
    case static_cast<int>(NVSDK_NGX_DLSS_Hint_Render_Preset_K):
      return "K";
    case static_cast<int>(NVSDK_NGX_DLSS_Hint_Render_Preset_L):
      return "L";
    case static_cast<int>(NVSDK_NGX_DLSS_Hint_Render_Preset_M):
      return "M";
    default:
      return "Default";
  }
}

inline void ReleaseFeatureHandleOnly() {
  if (ngx.feature != nullptr) {
    NVSDK_NGX_D3D11_ReleaseFeature(ngx.feature);
    ngx.feature = nullptr;
  }
  ngx.render_preset = -1;
  ngx.feature_flags = 0;
  ngx.create_failed = false;
  ngx.eval_failed = false;
  ngx.logged_success = false;
  ngx.logged_jitter = false;
}

inline void SetHDROutputActive(bool active) {
  if (hdr_output_active == active) return;
  hdr_output_active = active;
  ReleaseFeatureHandleOnly();
}

inline int GetFeatureFlags() {
  int flags = NVSDK_NGX_DLSS_Feature_Flags_DepthInverted
              | NVSDK_NGX_DLSS_Feature_Flags_AutoExposure;
  if (hdr_output_active) {
    flags |= NVSDK_NGX_DLSS_Feature_Flags_IsHDR;
  }
  if (dlaa_motion_vectors_jittered != 0.f) {
    flags |= NVSDK_NGX_DLSS_Feature_Flags_MVJittered;
  }
  return flags;
}

inline std::string GetFeatureFlagsName(int flags) {
  std::string name;
  if ((flags & NVSDK_NGX_DLSS_Feature_Flags_IsHDR) != 0) {
    name += "IsHDR|";
  }
  name += "DepthInverted|AutoExposure";
  if ((flags & NVSDK_NGX_DLSS_Feature_Flags_MVJittered) != 0) {
    name += "|MVJittered";
  }
  return name;
}

inline const char* GetMotionVectorModeName() {
  switch (static_cast<int>(dlaa_motion_vector_mode)) {
    case 1:
      return "Invert X";
    case 2:
      return "Invert Y";
    case 3:
      return "Invert XY";
    default:
      return "Native";
  }
}

inline const char* GetJitterModeName(float mode) {
  switch (static_cast<int>(mode)) {
    case 1:
      return "Flip X";
    case 2:
      return "Flip Y";
    case 3:
      return "Flip XY";
    case 4:
      return "Zero";
    default:
      return "Native";
  }
}

inline const char* GetJitterModeName() {
  return GetJitterModeName(dlaa_jitter_mode);
}

inline const char* GetMotionVectorPrepassJitterModeName() {
  return GetJitterModeName(dlaa_motion_vector_prepass_jitter_mode);
}

inline std::pair<float, float> GetJitterOffset(float mode, float jitter_x, float jitter_y) {
  switch (static_cast<int>(mode)) {
    case 1:
      return {-jitter_x, jitter_y};
    case 2:
      return {jitter_x, -jitter_y};
    case 3:
      return {-jitter_x, -jitter_y};
    case 4:
      return {0.f, 0.f};
    default:
      return {jitter_x, jitter_y};
  }
}

inline std::pair<float, float> GetJitterOffset(float jitter_x, float jitter_y) {
  return GetJitterOffset(dlaa_jitter_mode, jitter_x, jitter_y);
}

inline std::pair<float, float> GetMotionVectorPrepassJitterOffset(float jitter_x, float jitter_y) {
  return GetJitterOffset(dlaa_motion_vector_prepass_jitter_mode, jitter_x, jitter_y);
}

inline std::pair<float, float> GetMotionVectorScale(uint32_t width, uint32_t height) {
  float scale_x = static_cast<float>(width);
  float scale_y = static_cast<float>(height);

  switch (static_cast<int>(dlaa_motion_vector_mode)) {
    case 1:
      scale_x = -scale_x;
      break;
    case 2:
      scale_y = -scale_y;
      break;
    case 3:
      scale_x = -scale_x;
      scale_y = -scale_y;
      break;
    default:
      break;
  }

  return {scale_x, scale_y};
}

inline bool EnsureFeature(ID3D11DeviceContext* context, uint32_t width, uint32_t height) {
  if (context == nullptr || ngx.parameters == nullptr || ngx.output_texture == nullptr) return false;
  const int render_preset_value = GetRenderPresetValue();
  const int feature_flags = GetFeatureFlags();
  if (ngx.feature != nullptr
      && ngx.width == width
      && ngx.height == height
      && ngx.render_preset == render_preset_value
      && ngx.feature_flags == feature_flags) {
    return true;
  }
  if (ngx.feature != nullptr) ReleaseFeatureHandleOnly();
  if (ngx.create_failed) return false;

  NVSDK_NGX_DLSS_Create_Params params = {};
  params.Feature.InWidth = width;
  params.Feature.InHeight = height;
  params.Feature.InTargetWidth = width;
  params.Feature.InTargetHeight = height;
  params.Feature.InPerfQualityValue = NVSDK_NGX_PerfQuality_Value_DLAA;
  params.InFeatureCreateFlags = feature_flags;
  params.InEnableOutputSubrects = false;

  NVSDK_NGX_Parameter_SetI(ngx.parameters, NVSDK_NGX_Parameter_DLSS_Hint_Render_Preset_DLAA, render_preset_value);
  NVSDK_NGX_Parameter_SetI(ngx.parameters, NVSDK_NGX_Parameter_DLSS_Hint_Render_Preset_Quality, render_preset_value);
  NVSDK_NGX_Parameter_SetI(ngx.parameters, NVSDK_NGX_Parameter_DLSS_Hint_Render_Preset_Balanced, render_preset_value);
  NVSDK_NGX_Parameter_SetI(ngx.parameters, NVSDK_NGX_Parameter_DLSS_Hint_Render_Preset_Performance, render_preset_value);
  NVSDK_NGX_Parameter_SetI(ngx.parameters, NVSDK_NGX_Parameter_DLSS_Hint_Render_Preset_UltraPerformance, render_preset_value);
  NVSDK_NGX_Parameter_SetI(ngx.parameters, NVSDK_NGX_Parameter_DLSS_Hint_Render_Preset_UltraQuality, render_preset_value);

  const NVSDK_NGX_Result result = NGX_D3D11_CREATE_DLSS_EXT(context, &ngx.feature, ngx.parameters, &params);
  if (NVSDK_NGX_FAILED(result) || ngx.feature == nullptr) {
    ngx.create_failed = true;
    std::stringstream s;
    s << "AC3R DLAA: feature creation failed: " << ResultToString(result)
      << " (0x" << std::hex << static_cast<uint32_t>(result) << ")";
    reshade::log::message(reshade::log::level::error, s.str().c_str());
    return false;
  }

  ngx.render_preset = render_preset_value;
  ngx.feature_flags = feature_flags;

  std::stringstream s;
  s << "AC3R DLAA: feature created at " << width << "x" << height
    << " flags=" << GetFeatureFlagsName(feature_flags)
    << " preset=" << GetRenderPresetName(render_preset_value);
  reshade::log::message(reshade::log::level::info, s.str().c_str());
  return true;
}

inline bool ResolveRegister(
    reshade::api::pipeline_layout layout,
    uint32_t layout_param,
    const reshade::api::descriptor_table_update& update,
    uint32_t descriptor_index,
    uint32_t& dx_register_index,
    uint32_t& dx_register_space) {
  const auto* layout_data = renodx::utils::pipeline_layout::GetPipelineLayoutData(layout);
  if (layout_data == nullptr || layout_param >= layout_data->params.size()) return false;

  const auto& param = layout_data->params[layout_param];
  const uint32_t binding = update.binding + descriptor_index;

  switch (param.type) {
    case reshade::api::pipeline_layout_param_type::push_descriptors:
      dx_register_index = param.push_descriptors.dx_register_index + binding;
      dx_register_space = param.push_descriptors.dx_register_space;
      return true;
    case reshade::api::pipeline_layout_param_type::descriptor_table:
    case reshade::api::pipeline_layout_param_type::push_descriptors_with_ranges:
    case reshade::api::pipeline_layout_param_type::push_descriptors_with_static_samplers:
    case reshade::api::pipeline_layout_param_type::descriptor_table_with_static_samplers:
      if (layout_param >= layout_data->ranges.size()) return false;
      for (const auto& range : layout_data->ranges[layout_param]) {
        const bool in_range = binding >= range.binding
                              && (range.count == UINT32_MAX || binding < range.binding + range.count);
        if (!in_range) continue;
        dx_register_index = range.dx_register_index + (binding - range.binding);
        dx_register_space = range.dx_register_space;
        return true;
      }
      return false;
    default:
      return false;
  }
}

inline void OnInitCommandList(reshade::api::command_list* cmd_list) {
  cmd_list->create_private_data<CommandListData>();
}

inline void OnDestroyCommandList(reshade::api::command_list* cmd_list) {
  cmd_list->destroy_private_data<CommandListData>();
}

inline void OnResetCommandList(reshade::api::command_list* cmd_list) {
  auto* data = Get(cmd_list);
  if (data != nullptr) *data = {};
}

inline void OnBindRenderTargetsAndDepthStencil(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::resource_view* rtvs,
    reshade::api::resource_view dsv) {
  auto* data = Get(cmd_list);
  if (data == nullptr) return;

  data->rtvs = {};
  for (uint32_t i = 0u; i < count && i < kTrackedRtvCount; ++i) {
    data->rtvs[i] = rtvs != nullptr ? rtvs[i] : reshade::api::resource_view{};
  }
  data->dsv = dsv;
}

inline void OnPushDescriptors(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t layout_param,
    const reshade::api::descriptor_table_update& update) {
  if (!renodx::utils::bitwise::HasFlag(stages, reshade::api::shader_stage::pixel)) return;
  auto* data = Get(cmd_list);
  if (data == nullptr) return;

  if (update.type == reshade::api::descriptor_type::constant_buffer) {
    for (uint32_t i = 0; i < update.count; ++i) {
      uint32_t dx_register_index = 0u;
      uint32_t dx_register_space = 0u;
      if (!ResolveRegister(layout, layout_param, update, i, dx_register_index, dx_register_space)) continue;
      if (dx_register_space != 0u || dx_register_index != kTemporalAAConstantBufferIndex) continue;

      data->temporal_aa_constants = static_cast<const reshade::api::buffer_range*>(update.descriptors)[i];
    }
    return;
  }

  switch (update.type) {
    case reshade::api::descriptor_type::sampler_with_resource_view:
    case reshade::api::descriptor_type::texture_shader_resource_view:
    case reshade::api::descriptor_type::buffer_shader_resource_view:
      break;
    default:
      return;
  }

  for (uint32_t i = 0; i < update.count; ++i) {
    uint32_t dx_register_index = 0u;
    uint32_t dx_register_space = 0u;
    if (!ResolveRegister(layout, layout_param, update, i, dx_register_index, dx_register_space)) continue;
    if (dx_register_space != 0u || dx_register_index >= kTrackedSrvCount) continue;

    data->pixel_srvs[dx_register_index] =
        renodx::utils::descriptor::GetResourceViewFromDescriptorUpdate(update, i);
  }
}

inline void AppendViewInfo(
    std::stringstream& s,
    reshade::api::device* device,
    const char* label,
    reshade::api::resource_view view) {
  s << "\n  " << label << " view=" << reinterpret_cast<void*>(view.handle);
  if (device == nullptr || view.handle == 0u) return;

  const auto resource = device->get_resource_from_view(view);
  s << " resource=" << reinterpret_cast<void*>(resource.handle);
  if (resource.handle == 0u) return;

  const auto desc = device->get_resource_desc(resource);
  const auto view_desc = device->get_resource_view_desc(view);
  s << " size=" << desc.texture.width << "x" << desc.texture.height;
  s << " resource_format=" << static_cast<uint32_t>(desc.texture.format);
  s << " view_format=" << static_cast<uint32_t>(view_desc.format);
}

inline bool LogTemporalAAInputs(reshade::api::command_list* cmd_list) {
  if (logged_taa_inputs) return false;

  auto* shader_state = renodx::utils::shader::GetCurrentState(cmd_list);
  if (shader_state == nullptr) return false;

  const uint32_t pixel_hash = renodx::utils::shader::GetCurrentPixelShaderHash(shader_state);
  if (pixel_hash != kTemporalAAHash) return false;

  auto* data = Get(cmd_list);
  if (data == nullptr) return false;
  if (data->pixel_srvs[0].handle == 0u
      || data->pixel_srvs[1].handle == 0u
      || data->pixel_srvs[2].handle == 0u
      || data->pixel_srvs[3].handle == 0u) {
    return false;
  }

  logged_taa_inputs = true;

  std::stringstream s;
  s << "AC3R DLSS probe: detected TemporalAA 0x78DC7D04 inputs";
  auto* device = cmd_list->get_device();
  AppendViewInfo(s, device, "t0 source_color", data->pixel_srvs[0]);
  AppendViewInfo(s, device, "t1 color_history", data->pixel_srvs[1]);
  AppendViewInfo(s, device, "t2 motion_vectors", data->pixel_srvs[2]);
  AppendViewInfo(s, device, "t3 depth", data->pixel_srvs[3]);
  AppendViewInfo(s, device, "t4 responsive_aa", data->pixel_srvs[4]);
  AppendViewInfo(s, device, "rtv0 output", data->rtvs[0]);
  reshade::log::message(reshade::log::level::info, s.str().c_str());

  return false;
}

inline bool IsTemporalAADraw(reshade::api::command_list* cmd_list, CommandListData*& data) {
  auto* shader_state = renodx::utils::shader::GetCurrentState(cmd_list);
  if (shader_state == nullptr) return false;

  const uint32_t pixel_hash = renodx::utils::shader::GetCurrentPixelShaderHash(shader_state);
  if (pixel_hash != kTemporalAAHash) return false;

  data = Get(cmd_list);
  if (data == nullptr) return false;
  return data->pixel_srvs[0].handle != 0u
         && data->pixel_srvs[2].handle != 0u
         && data->pixel_srvs[3].handle != 0u
         && data->rtvs[0].handle != 0u;
}

inline ID3D11Resource* GetNativeResource(
    reshade::api::device* device,
    reshade::api::resource_view view) {
  if (device == nullptr || view.handle == 0u) return nullptr;
  const auto resource = device->get_resource_from_view(view);
  if (resource.handle == 0u) return nullptr;
  return reinterpret_cast<ID3D11Resource*>(resource.handle);
}

inline bool ReadTemporalAAJitter(
    ID3D11Device* device,
    ID3D11DeviceContext* context,
    const reshade::api::buffer_range& buffer_range,
    float& jitter_x,
    float& jitter_y) {
  if (device == nullptr || context == nullptr || buffer_range.buffer.handle == 0u) return false;

  auto* source_buffer = reinterpret_cast<ID3D11Buffer*>(buffer_range.buffer.handle);
  D3D11_BUFFER_DESC source_desc = {};
  source_buffer->GetDesc(&source_desc);
  if (source_desc.ByteWidth == 0u) return false;

  const uint64_t range_offset = buffer_range.offset == UINT64_MAX ? 0u : buffer_range.offset;
  const uint64_t jitter_offset = range_offset + kTemporalAASubPixelJitterOffset;
  if (jitter_offset + sizeof(float) * 2u > source_desc.ByteWidth) return false;

  if (ngx.temporal_constants_staging == nullptr || ngx.temporal_constants_staging_size < source_desc.ByteWidth) {
    D3D11_BUFFER_DESC staging_desc = source_desc;
    staging_desc.Usage = D3D11_USAGE_STAGING;
    staging_desc.BindFlags = 0u;
    staging_desc.CPUAccessFlags = D3D11_CPU_ACCESS_READ;
    staging_desc.MiscFlags = 0u;
    staging_desc.StructureByteStride = 0u;

    if (FAILED(device->CreateBuffer(&staging_desc, nullptr, ngx.temporal_constants_staging.ReleaseAndGetAddressOf()))) {
      ngx.temporal_constants_staging_size = 0u;
      return false;
    }
    ngx.temporal_constants_staging_size = source_desc.ByteWidth;
  }

  context->CopyResource(ngx.temporal_constants_staging.Get(), source_buffer);

  D3D11_MAPPED_SUBRESOURCE mapped = {};
  if (FAILED(context->Map(ngx.temporal_constants_staging.Get(), 0u, D3D11_MAP_READ, 0u, &mapped))) {
    return false;
  }

  const auto* bytes = static_cast<const uint8_t*>(mapped.pData);
  std::memcpy(&jitter_x, bytes + jitter_offset, sizeof(float));
  std::memcpy(&jitter_y, bytes + jitter_offset + sizeof(float), sizeof(float));
  context->Unmap(ngx.temporal_constants_staging.Get(), 0u);
  return true;
}

inline ID3D11Resource* RunMotionVectorPrepass(
    ID3D11Device* device,
    ID3D11DeviceContext* context,
    const CommandListData* data,
    uint32_t width,
    uint32_t height,
    float jitter_x,
    float jitter_y) {
  if (device == nullptr || context == nullptr || data == nullptr) return nullptr;
  if (!EnsureMotionVectorPrepass(device, width, height)) return nullptr;

  auto* motion_vectors_srv = reinterpret_cast<ID3D11ShaderResourceView*>(data->pixel_srvs[2].handle);
  auto* depth_srv = reinterpret_cast<ID3D11ShaderResourceView*>(data->pixel_srvs[3].handle);
  if (motion_vectors_srv == nullptr || depth_srv == nullptr) return nullptr;

  MotionVectorPrepassConstants constants = {};
  constants.size[0] = static_cast<float>(width);
  constants.size[1] = static_cast<float>(height);
  constants.size[2] = 1.f / static_cast<float>(width);
  constants.size[3] = 1.f / static_cast<float>(height);
  constants.jitter[0] = jitter_x;
  constants.jitter[1] = jitter_y;
  context->UpdateSubresource(ngx.motion_vector_prepass_constants.Get(), 0u, nullptr, &constants, 0u, 0u);

  ID3D11ComputeShader* previous_cs = nullptr;
  ID3D11ShaderResourceView* previous_srvs[2] = {};
  ID3D11UnorderedAccessView* previous_uavs[1] = {};
  ID3D11Buffer* previous_cbs[1] = {};
  context->CSGetShader(&previous_cs, nullptr, nullptr);
  context->CSGetShaderResources(0u, 2u, previous_srvs);
  context->CSGetUnorderedAccessViews(0u, 1u, previous_uavs);
  context->CSGetConstantBuffers(0u, 1u, previous_cbs);

  ID3D11ShaderResourceView* srvs[2] = {motion_vectors_srv, depth_srv};
  ID3D11UnorderedAccessView* uavs[1] = {ngx.preconditioned_motion_vectors_uav.Get()};
  ID3D11Buffer* cbs[1] = {ngx.motion_vector_prepass_constants.Get()};
  constexpr UINT keep_counts[1] = {UINT_MAX};

  context->CSSetShader(ngx.motion_vector_prepass_cs.Get(), nullptr, 0u);
  context->CSSetShaderResources(0u, 2u, srvs);
  context->CSSetUnorderedAccessViews(0u, 1u, uavs, keep_counts);
  context->CSSetConstantBuffers(0u, 1u, cbs);
  context->Dispatch((width + 7u) / 8u, (height + 7u) / 8u, 1u);

  ID3D11ShaderResourceView* null_srvs[2] = {};
  ID3D11UnorderedAccessView* null_uavs[1] = {};
  ID3D11Buffer* null_cbs[1] = {};
  context->CSSetShaderResources(0u, 2u, null_srvs);
  context->CSSetUnorderedAccessViews(0u, 1u, null_uavs, keep_counts);
  context->CSSetConstantBuffers(0u, 1u, null_cbs);

  context->CSSetShader(previous_cs, nullptr, 0u);
  context->CSSetShaderResources(0u, 2u, previous_srvs);
  context->CSSetUnorderedAccessViews(0u, 1u, previous_uavs, keep_counts);
  context->CSSetConstantBuffers(0u, 1u, previous_cbs);

  if (previous_cs != nullptr) previous_cs->Release();
  for (auto* previous_srv : previous_srvs) {
    if (previous_srv != nullptr) previous_srv->Release();
  }
  for (auto* previous_uav : previous_uavs) {
    if (previous_uav != nullptr) previous_uav->Release();
  }
  for (auto* previous_cb : previous_cbs) {
    if (previous_cb != nullptr) previous_cb->Release();
  }

  if (!ngx.logged_mv_prepass) {
    ngx.logged_mv_prepass = true;
    std::stringstream s;
    s << "AC3R DLAA: using depth-neighborhood motion-vector prepass"
      << " jitter_mode=" << GetMotionVectorPrepassJitterModeName()
      << " jitter=(" << jitter_x << ", " << jitter_y << ")";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
  }

  return ngx.preconditioned_motion_vectors.Get();
}

inline bool EvaluateDLAA(reshade::api::command_list* cmd_list, const CommandListData* data) {
  if (cmd_list == nullptr || data == nullptr || dlaa_enabled == 0.f || !IsSupported()) return false;

  auto* device = cmd_list->get_device();
  if (device == nullptr) return false;

  auto* context = reinterpret_cast<ID3D11DeviceContext*>(cmd_list->get_native());
  auto* native_device = reinterpret_cast<ID3D11Device*>(device->get_native());
  if (context == nullptr || native_device == nullptr) return false;

  auto* color = GetNativeResource(device, data->pixel_srvs[0]);
  auto* motion_vectors = GetNativeResource(device, data->pixel_srvs[2]);
  auto* depth = GetNativeResource(device, data->pixel_srvs[3]);
  auto* responsive_aa = GetNativeResource(device, data->pixel_srvs[4]);
  auto* output_target = GetNativeResource(device, data->rtvs[0]);
  if (color == nullptr || motion_vectors == nullptr || depth == nullptr || output_target == nullptr) return false;

  D3D11_TEXTURE2D_DESC color_desc = {};
  {
    ID3D11Texture2D* color_texture = nullptr;
    if (FAILED(color->QueryInterface(__uuidof(ID3D11Texture2D), reinterpret_cast<void**>(&color_texture)))
        || color_texture == nullptr) {
      return false;
    }
    color_texture->GetDesc(&color_desc);
    color_texture->Release();
  }

  D3D11_TEXTURE2D_DESC output_desc = {};
  {
    ID3D11Texture2D* output_texture = nullptr;
    if (FAILED(output_target->QueryInterface(__uuidof(ID3D11Texture2D), reinterpret_cast<void**>(&output_texture)))
        || output_texture == nullptr) {
      return false;
    }
    output_texture->GetDesc(&output_desc);
    output_texture->Release();
  }

  const uint32_t width = color_desc.Width;
  const uint32_t height = color_desc.Height;
  if (width == 0u || height == 0u) return false;
  if (output_desc.Width != width || output_desc.Height != height) return false;

  if (!EnsureNgxInitialized(device)) return false;
  if (!EnsureOutputTexture(native_device, width, height, output_desc.Format)) return false;
  if (!EnsureFeature(context, width, height)) return false;
  if (ngx.eval_failed) return false;

  float jitter_x = 0.f;
  float jitter_y = 0.f;
  const bool has_jitter = ReadTemporalAAJitter(native_device, context, data->temporal_aa_constants, jitter_x, jitter_y);
  const auto prepass_jitter_offset = GetMotionVectorPrepassJitterOffset(jitter_x, jitter_y);
  ID3D11Resource* preconditioned_motion_vectors = RunMotionVectorPrepass(
      native_device,
      context,
      data,
      width,
      height,
      has_jitter ? prepass_jitter_offset.first : 0.f,
      has_jitter ? prepass_jitter_offset.second : 0.f);
  const auto jitter_offset = GetJitterOffset(jitter_x, jitter_y);

  NVSDK_NGX_D3D11_DLSS_Eval_Params eval = {};
  eval.Feature.pInColor = color;
  eval.Feature.pInOutput = ngx.output_texture.Get();
  eval.Feature.InSharpness = dlaa_sharpness;
  eval.pInDepth = depth;
  eval.pInMotionVectors = preconditioned_motion_vectors != nullptr ? preconditioned_motion_vectors : motion_vectors;
  eval.pInBiasCurrentColorMask = dlaa_responsive_mask != 0.f ? responsive_aa : nullptr;
  eval.InJitterOffsetX = has_jitter ? jitter_offset.first * dlaa_jitter_scale : 0.f;
  eval.InJitterOffsetY = has_jitter ? jitter_offset.second * dlaa_jitter_scale : 0.f;
  eval.InRenderSubrectDimensions.Width = width;
  eval.InRenderSubrectDimensions.Height = height;
  eval.InReset = 0;
  const auto motion_vector_scale = GetMotionVectorScale(width, height);
  eval.InMVScaleX = motion_vector_scale.first;
  eval.InMVScaleY = motion_vector_scale.second;
  eval.InPreExposure = 1.f;
  eval.InExposureScale = 1.f;

  const NVSDK_NGX_Result result = NGX_D3D11_EVALUATE_DLSS_EXT(context, ngx.feature, ngx.parameters, &eval);
  if (NVSDK_NGX_FAILED(result)) {
    ngx.eval_failed = true;
    std::stringstream s;
    s << "AC3R DLAA: evaluation failed: " << ResultToString(result)
      << " (0x" << std::hex << static_cast<uint32_t>(result) << ")";
    reshade::log::message(reshade::log::level::error, s.str().c_str());
    return false;
  }

  std::array<ID3D11RenderTargetView*, D3D11_SIMULTANEOUS_RENDER_TARGET_COUNT> previous_rtvs = {};
  ID3D11DepthStencilView* previous_dsv = nullptr;
  context->OMGetRenderTargets(
      static_cast<UINT>(previous_rtvs.size()),
      previous_rtvs.data(),
      &previous_dsv);

  std::array<ID3D11RenderTargetView*, D3D11_SIMULTANEOUS_RENDER_TARGET_COUNT> null_rtvs = {};
  context->OMSetRenderTargets(static_cast<UINT>(null_rtvs.size()), null_rtvs.data(), nullptr);
  context->CopyResource(output_target, ngx.output_texture.Get());
  context->OMSetRenderTargets(
      static_cast<UINT>(previous_rtvs.size()),
      previous_rtvs.data(),
      previous_dsv);

  for (auto* previous_rtv : previous_rtvs) {
    if (previous_rtv != nullptr) previous_rtv->Release();
  }
  if (previous_dsv != nullptr) previous_dsv->Release();

  if (!ngx.logged_success) {
    ngx.logged_success = true;
    std::stringstream s;
    s << "AC3R DLAA: replacing TemporalAA at " << width << "x" << height;
    reshade::log::message(reshade::log::level::info, s.str().c_str());
  }
  if (has_jitter && !ngx.logged_jitter) {
    ngx.logged_jitter = true;
    std::stringstream s;
    s << "AC3R DLAA: using TemporalAA jitter raw=(" << jitter_x << ", " << jitter_y
      << ") ngx=(" << eval.InJitterOffsetX << ", " << eval.InJitterOffsetY
      << ") mode=" << GetJitterModeName()
      << " scale=" << dlaa_jitter_scale
      << " mv_mode=" << GetMotionVectorModeName()
      << " mv_scale=(" << motion_vector_scale.first << ", " << motion_vector_scale.second << ")"
      << " mv_jittered=" << (dlaa_motion_vectors_jittered != 0.f ? "on" : "off")
      << " responsive_mask=" << (dlaa_responsive_mask != 0.f ? "on" : "off");
    reshade::log::message(reshade::log::level::info, s.str().c_str());
  }

  return true;
}

inline bool OnDraw(
    reshade::api::command_list* cmd_list,
    uint32_t vertex_count,
    uint32_t instance_count,
    uint32_t first_vertex,
    uint32_t first_instance) {
  LogTemporalAAInputs(cmd_list);

  CommandListData* data = nullptr;
  if (dlaa_enabled == 0.f || !IsSupported() || !IsTemporalAADraw(cmd_list, data)) return false;

  return EvaluateDLAA(cmd_list, data);
}

inline bool OnDrawIndexed(
    reshade::api::command_list* cmd_list,
    uint32_t index_count,
    uint32_t instance_count,
    uint32_t first_index,
    int32_t vertex_offset,
    uint32_t first_instance) {
  LogTemporalAAInputs(cmd_list);

  CommandListData* data = nullptr;
  if (dlaa_enabled == 0.f || !IsSupported() || !IsTemporalAADraw(cmd_list, data)) return false;

  return EvaluateDLAA(cmd_list, data);
}

inline bool OnDrawOrDispatchIndirect(
    reshade::api::command_list* cmd_list,
    reshade::api::indirect_command,
    reshade::api::resource,
    uint64_t,
    uint32_t,
    uint32_t) {
  return LogTemporalAAInputs(cmd_list);
}

inline void OnDestroyDevice(reshade::api::device*) {
  ReleaseNgx();
  is_nvidia_device = false;
}

inline void OnInitDevice(reshade::api::device* device) {
  is_nvidia_device = false;
  if (device == nullptr) return;

  int vendor_id = 0;
  const bool retrieved = device->get_property(reshade::api::device_properties::vendor_id, &vendor_id);
  is_nvidia_device = retrieved && vendor_id == 0x10de;

  if (!is_nvidia_device) {
    dlaa_enabled = 0.f;
    reshade::log::message(reshade::log::level::info, "AC3R DLAA: hidden because the active graphics adapter is not NVIDIA");
  }
}

inline void Use(DWORD fdw_reason) {
  renodx::utils::pipeline_layout::Use(fdw_reason);

  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (attached) return;
      attached = true;
      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::init_command_list>(OnInitCommandList);
      reshade::register_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);
      reshade::register_event<reshade::addon_event::reset_command_list>(OnResetCommandList);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::register_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(OnBindRenderTargetsAndDepthStencil);
      reshade::register_event<reshade::addon_event::push_descriptors>(OnPushDescriptors);
      reshade::register_event<reshade::addon_event::draw>(OnDraw);
      reshade::register_event<reshade::addon_event::draw_indexed>(OnDrawIndexed);
      reshade::register_event<reshade::addon_event::draw_or_dispatch_indirect>(OnDrawOrDispatchIndirect);
      break;
    case DLL_PROCESS_DETACH:
      if (!attached) return;
      attached = false;
      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::unregister_event<reshade::addon_event::init_command_list>(OnInitCommandList);
      reshade::unregister_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);
      reshade::unregister_event<reshade::addon_event::reset_command_list>(OnResetCommandList);
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::unregister_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(OnBindRenderTargetsAndDepthStencil);
      reshade::unregister_event<reshade::addon_event::push_descriptors>(OnPushDescriptors);
      reshade::unregister_event<reshade::addon_event::draw>(OnDraw);
      reshade::unregister_event<reshade::addon_event::draw_indexed>(OnDrawIndexed);
      reshade::unregister_event<reshade::addon_event::draw_or_dispatch_indirect>(OnDrawOrDispatchIndirect);
      ReleaseNgx();
      break;
  }
}

}  // namespace ac3r::dlss
