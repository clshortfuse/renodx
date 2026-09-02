#pragma once

#ifndef VK_NO_PROTOTYPES
#define VK_NO_PROTOTYPES
#endif

#include <windows.h>

#include <detours.h>
#include <vulkan/vulkan.h>

#include <algorithm>
#include <array>
#include <atomic>
#include <cmath>
#include <cstdint>
#include <cstring>
#include <memory>
#include <mutex>
#include <shared_mutex>
#include <span>
#include <sstream>
#include <string>
#include <unordered_map>
#include <vector>

#include <embed/shaders.h>
#include <include/reshade.hpp>

#include "../../utils/hash.hpp"
#include "./shared.h"
#include "./supported_build.hpp"

namespace renodx::games::doom2016::pipeline_variants {

inline constexpr std::size_t kToneMapVariantCount = 7u;

enum class DiagnosticMode : std::uint8_t {
  kProduction,
  kIdentityOutput,
  kModifiedOutput,
  kIdentityPostProcess,
  kModifiedPostProcess,
  kModifiedBothVanilla,
};

inline const std::array<std::span<const std::uint8_t>,
                        kToneMapVariantCount>
    kPostProcessBytecode = {
        __postprocess_vanilla,
        __postprocess_psychov17,
        __postprocess_psychov22,
        __postprocess_psychov24,
        __postprocess_psychov25,
        __postprocess_psychov30,
        __postprocess_renodrt,
};

struct CachedVariants {
  bool post_process = false;
  std::array<VkPipeline, kToneMapVariantCount> tone_map = {};
  VkPipeline output = VK_NULL_HANDLE;
};

struct DeviceData {
  VkDevice device = VK_NULL_HANDLE;
  PFN_vkCreateShaderModule create_shader_module = nullptr;
  PFN_vkDestroyShaderModule destroy_shader_module = nullptr;
  PFN_vkCreateGraphicsPipelines create_graphics_pipelines = nullptr;
  PFN_vkDestroyPipeline destroy_pipeline = nullptr;
  std::shared_mutex mutex;
  std::unordered_map<VkShaderModule, std::uint32_t> shader_hashes;
  std::unordered_map<VkPipeline, CachedVariants> variants;
};

inline ShaderInjectData* injection = nullptr;
inline DiagnosticMode diagnostic_mode = DiagnosticMode::kProduction;
inline std::shared_mutex devices_mutex;
inline std::unordered_map<VkDevice, std::shared_ptr<DeviceData>> devices;
inline PFN_vkGetInstanceProcAddr reshade_get_instance_proc_addr = nullptr;
inline PFN_vkGetDeviceProcAddr reshade_get_device_proc_addr = nullptr;
inline std::atomic_bool hooks_attached = false;
inline thread_local bool creating_or_destroying_variant = false;
inline std::atomic_uint64_t created_pipeline_count = 0u;
inline std::atomic_uint64_t selected_pipeline_bind_count = 0u;
inline std::atomic_uint64_t failed_pipeline_count = 0u;
inline std::atomic_uint32_t first_execution_mask = 0u;

inline std::shared_ptr<DeviceData> FindDevice(VkDevice device) {
  const std::shared_lock lock(devices_mutex);
  const auto found = devices.find(device);
  return found == devices.end() ? nullptr : found->second;
}

inline bool UsesModifiedPostProcess() {
  return diagnostic_mode == DiagnosticMode::kProduction
         || diagnostic_mode == DiagnosticMode::kModifiedPostProcess
         || diagnostic_mode == DiagnosticMode::kModifiedBothVanilla;
}

inline bool UsesBt2020PostProcess() {
  return diagnostic_mode == DiagnosticMode::kProduction
         && injection != nullptr
         && injection->tone_map_type >= DOOM2016_TONEMAP_PSYCHOV_17
         && injection->tone_map_type <= DOOM2016_TONEMAP_PSYCHOV_30;
}

inline bool ShouldCreateTarget(bool post_process) {
  switch (diagnostic_mode) {
    case DiagnosticMode::kIdentityOutput:
    case DiagnosticMode::kModifiedOutput:
      return !post_process;
    case DiagnosticMode::kIdentityPostProcess:
    case DiagnosticMode::kModifiedPostProcess:
      return post_process;
    case DiagnosticMode::kModifiedBothVanilla:
    case DiagnosticMode::kProduction:
      return true;
  }
  return false;
}

inline std::size_t ResolveToneMapIndex() {
  if (injection == nullptr || !std::isfinite(injection->tone_map_type)) {
    return 0u;
  }
  return static_cast<std::size_t>(std::clamp(
      std::lround(injection->tone_map_type),
      0l,
      static_cast<long>(kToneMapVariantCount - 1u)));
}

inline void SetDiagnosticMode(DiagnosticMode mode) {
  diagnostic_mode = mode;
}

inline std::uint32_t ComputeShaderHash(
    const VkShaderModuleCreateInfo* create_info) {
  if (create_info == nullptr || create_info->pCode == nullptr
      || create_info->codeSize == 0u) {
    return 0u;
  }
  return renodx::utils::hash::ComputeCRC32(
      reinterpret_cast<const std::uint8_t*>(create_info->pCode),
      create_info->codeSize);
}

template <typename T>
inline const T* FindInChain(
    const void* chain,
    VkStructureType structure_type) {
  auto* current = static_cast<const VkBaseInStructure*>(chain);
  while (current != nullptr) {
    if (current->sType == structure_type) {
      return reinterpret_cast<const T*>(current);
    }
    current = current->pNext;
  }
  return nullptr;
}

inline std::uint32_t FindFragmentShaderHash(
    const std::shared_ptr<DeviceData>& data,
    const VkGraphicsPipelineCreateInfo& create_info) {
  for (std::uint32_t index = 0u; index < create_info.stageCount; ++index) {
    const auto& stage = create_info.pStages[index];
    if (stage.stage != VK_SHADER_STAGE_FRAGMENT_BIT) continue;
    if (stage.module != VK_NULL_HANDLE) {
      const std::shared_lock lock(data->mutex);
      const auto found = data->shader_hashes.find(stage.module);
      return found == data->shader_hashes.end() ? 0u : found->second;
    }
    return ComputeShaderHash(FindInChain<VkShaderModuleCreateInfo>(
        stage.pNext,
        VK_STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO));
  }
  return 0u;
}

inline void DestroyCachedVariants(
    const std::shared_ptr<DeviceData>& data,
    CachedVariants* cached) {
  if (data == nullptr || data->destroy_pipeline == nullptr
      || cached == nullptr) {
    return;
  }
  creating_or_destroying_variant = true;
  for (auto& pipeline : cached->tone_map) {
    if (pipeline == VK_NULL_HANDLE) continue;
    data->destroy_pipeline(data->device, pipeline, nullptr);
    pipeline = VK_NULL_HANDLE;
  }
  if (cached->output != VK_NULL_HANDLE) {
    data->destroy_pipeline(data->device, cached->output, nullptr);
    cached->output = VK_NULL_HANDLE;
  }
  creating_or_destroying_variant = false;
}

inline bool CreateExactVariant(
    const std::shared_ptr<DeviceData>& data,
    VkPipelineCache pipeline_cache,
    const VkGraphicsPipelineCreateInfo& original,
    const VkAllocationCallbacks* allocator,
    std::span<const std::uint8_t> replacement,
    VkPipeline* output) {
  if (data == nullptr || output == nullptr) {
    reshade::log::message(
        reshade::log::level::error,
        "DOOM 2016 HDR native variant rejected: missing device/output.");
    return false;
  }
  if (allocator != nullptr) {
    reshade::log::message(
        reshade::log::level::error,
        "DOOM 2016 HDR native variant rejected: custom allocator.");
    return false;
  }
  if (original.pStages == nullptr || original.stageCount == 0u) {
    reshade::log::message(
        reshade::log::level::error,
        "DOOM 2016 HDR native variant rejected: missing shader stages.");
    return false;
  }
  if ((original.flags & VK_PIPELINE_CREATE_DERIVATIVE_BIT) != 0u
      && original.basePipelineIndex != -1) {
    reshade::log::message(
        reshade::log::level::error,
        "DOOM 2016 HDR native variant rejected: derivative batch index.");
    return false;
  }

  std::vector<VkPipelineShaderStageCreateInfo> stages(
      original.pStages,
      original.pStages + original.stageCount);
  auto fragment = std::find_if(
      stages.begin(),
      stages.end(),
      [](const auto& stage) {
        return stage.stage == VK_SHADER_STAGE_FRAGMENT_BIT;
      });
  if (fragment == stages.end() || fragment->module == VK_NULL_HANDLE) {
    reshade::log::message(
        reshade::log::level::error,
        "DOOM 2016 HDR native variant rejected: inline/missing fragment module.");
    return false;
  }

  if (!replacement.empty()) {
    if (fragment->pName == nullptr
        || std::strcmp(fragment->pName, "main") != 0) {
      reshade::log::message(
          reshade::log::level::error,
          "DOOM 2016 HDR native variant rejected: unexpected fragment entry point.");
      return false;
    }
    if (fragment->pSpecializationInfo != nullptr
        && (fragment->pSpecializationInfo->mapEntryCount != 0u
            || fragment->pSpecializationInfo->dataSize != 0u)) {
      reshade::log::message(
          reshade::log::level::error,
          "DOOM 2016 HDR native variant rejected: fragment specialization constants.");
      return false;
    }
    if (FindInChain<VkShaderModuleCreateInfo>(
            fragment->pNext,
            VK_STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO)
        != nullptr) {
      reshade::log::message(
          reshade::log::level::error,
          "DOOM 2016 HDR native variant rejected: inline fragment module.");
      return false;
    }
#ifdef VK_EXT_shader_module_identifier
    if (FindInChain<VkPipelineShaderStageModuleIdentifierCreateInfoEXT>(
            fragment->pNext,
            VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_MODULE_IDENTIFIER_CREATE_INFO_EXT)
        != nullptr) {
      reshade::log::message(
          reshade::log::level::error,
          "DOOM 2016 HDR native variant rejected: fragment module identifier.");
      return false;
    }
#endif
  }

  VkShaderModule replacement_module = VK_NULL_HANDLE;
  if (!replacement.empty()) {
    if ((replacement.size() % sizeof(std::uint32_t)) != 0u) return false;
    std::vector<std::uint32_t> words(
        replacement.size() / sizeof(std::uint32_t));
    std::memcpy(words.data(), replacement.data(), replacement.size());
    const VkShaderModuleCreateInfo module_info = {
        .sType = VK_STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO,
        .pNext = nullptr,
        .flags = 0u,
        .codeSize = replacement.size(),
        .pCode = words.data(),
    };
    if (data->create_shader_module(
            data->device,
            &module_info,
            nullptr,
            &replacement_module)
        != VK_SUCCESS) {
      return false;
    }
    fragment->module = replacement_module;
  }

  VkGraphicsPipelineCreateInfo variant = original;
  variant.pStages = stages.data();
  creating_or_destroying_variant = true;
  const VkResult result = data->create_graphics_pipelines(
      data->device,
      pipeline_cache,
      1u,
      &variant,
      allocator,
      output);
  creating_or_destroying_variant = false;

  if (replacement_module != VK_NULL_HANDLE) {
    data->destroy_shader_module(
        data->device,
        replacement_module,
        nullptr);
  }
  return result == VK_SUCCESS && *output != VK_NULL_HANDLE;
}

inline bool BuildVariants(
    const std::shared_ptr<DeviceData>& data,
    VkPipelineCache pipeline_cache,
    const VkGraphicsPipelineCreateInfo& create_info,
    const VkAllocationCallbacks* allocator,
    VkPipeline original_pipeline,
    std::uint32_t shader_hash) {
  const bool post_process =
      shader_hash == supported_build::kPostProcessShaderCrc;
  if (!ShouldCreateTarget(post_process)) return true;

  {
    std::ostringstream message;
    message << "DOOM 2016 HDR native pipeline contract: flags=0x"
            << std::hex << create_info.flags << std::dec
            << ", base_index=" << create_info.basePipelineIndex
            << ", stages=" << create_info.stageCount
            << ", pnext=" << (create_info.pNext != nullptr ? "yes" : "no")
            << ", allocator=" << (allocator != nullptr ? "yes" : "no")
            << ".";
    reshade::log::message(
        reshade::log::level::info,
        message.str().c_str());
  }

  CachedVariants cached = {.post_process = post_process};
  bool complete = true;
  if (post_process) {
    if (diagnostic_mode == DiagnosticMode::kIdentityPostProcess) {
      complete = CreateExactVariant(
          data,
          pipeline_cache,
          create_info,
          allocator,
          {},
          &cached.tone_map[0]);
    } else if (diagnostic_mode == DiagnosticMode::kModifiedPostProcess
               || diagnostic_mode == DiagnosticMode::kModifiedBothVanilla) {
      complete = CreateExactVariant(
          data,
          pipeline_cache,
          create_info,
          allocator,
          __postprocess_vanilla,
          &cached.tone_map[0]);
    } else {
      for (std::size_t index = 0u;
           index < kToneMapVariantCount;
           ++index) {
        if (!CreateExactVariant(
                data,
                pipeline_cache,
                create_info,
                allocator,
                kPostProcessBytecode[index],
                &cached.tone_map[index])) {
          complete = false;
          break;
        }
      }
    }
  } else {
    complete = CreateExactVariant(
        data,
        pipeline_cache,
        create_info,
        allocator,
        diagnostic_mode == DiagnosticMode::kIdentityOutput
            ? std::span<const std::uint8_t>{}
            : __viewcolor_output,
        &cached.output);
  }

  if (!complete) {
    failed_pipeline_count.fetch_add(1u, std::memory_order_relaxed);
    DestroyCachedVariants(data, &cached);
    reshade::log::message(
        reshade::log::level::error,
        "DOOM 2016 HDR: exact native Vulkan variant creation failed; the original pipeline remains active.");
    return false;
  }

  std::size_t created = cached.output == VK_NULL_HANDLE ? 0u : 1u;
  created += std::count_if(
      cached.tone_map.begin(),
      cached.tone_map.end(),
      [](VkPipeline pipeline) { return pipeline != VK_NULL_HANDLE; });
  created_pipeline_count.fetch_add(created, std::memory_order_relaxed);

  {
    const std::unique_lock lock(data->mutex);
    if (data->variants.contains(original_pipeline)) {
      DestroyCachedVariants(data, &cached);
      return true;
    }
    data->variants.emplace(original_pipeline, std::move(cached));
  }

  const char* message = nullptr;
  if (diagnostic_mode == DiagnosticMode::kIdentityOutput) {
    message = "DOOM 2016 HDR diagnostic: cached an exact-native byte-identical final-output VkPipeline.";
  } else if (diagnostic_mode == DiagnosticMode::kIdentityPostProcess) {
    message = "DOOM 2016 HDR diagnostic: cached an exact-native byte-identical post-process VkPipeline.";
  } else if (post_process) {
    message = diagnostic_mode == DiagnosticMode::kProduction
                  ? "DOOM 2016 HDR: cached seven exact-native post-process VkPipelines."
                  : "DOOM 2016 HDR diagnostic: cached an exact-native modified post-process VkPipeline.";
  } else {
    message = "DOOM 2016 HDR: cached the exact-native modified final-output VkPipeline.";
  }
  reshade::log::message(reshade::log::level::info, message);
  return true;
}

VKAPI_ATTR VkResult VKAPI_CALL HookCreateShaderModule(
    VkDevice device,
    const VkShaderModuleCreateInfo* create_info,
    const VkAllocationCallbacks* allocator,
    VkShaderModule* shader_module) {
  const auto data = FindDevice(device);
  const auto downstream =
      data == nullptr
          ? reinterpret_cast<PFN_vkCreateShaderModule>(
                reshade_get_device_proc_addr(device, "vkCreateShaderModule"))
          : data->create_shader_module;
  if (downstream == nullptr) return VK_ERROR_INITIALIZATION_FAILED;
  const VkResult result = downstream(
      device,
      create_info,
      allocator,
      shader_module);
  if (result == VK_SUCCESS && data != nullptr && shader_module != nullptr) {
    const auto hash = ComputeShaderHash(create_info);
    if (hash == supported_build::kPostProcessShaderCrc
        || hash == supported_build::kOutputShaderCrc) {
      const std::unique_lock lock(data->mutex);
      data->shader_hashes[*shader_module] = hash;
    }
  }
  return result;
}

VKAPI_ATTR void VKAPI_CALL HookDestroyShaderModule(
    VkDevice device,
    VkShaderModule shader_module,
    const VkAllocationCallbacks* allocator) {
  const auto data = FindDevice(device);
  const auto downstream =
      data == nullptr
          ? reinterpret_cast<PFN_vkDestroyShaderModule>(
                reshade_get_device_proc_addr(device, "vkDestroyShaderModule"))
          : data->destroy_shader_module;
  if (data != nullptr) {
    const std::unique_lock lock(data->mutex);
    data->shader_hashes.erase(shader_module);
  }
  if (downstream != nullptr) downstream(device, shader_module, allocator);
}

VKAPI_ATTR VkResult VKAPI_CALL HookCreateGraphicsPipelines(
    VkDevice device,
    VkPipelineCache pipeline_cache,
    std::uint32_t create_info_count,
    const VkGraphicsPipelineCreateInfo* create_infos,
    const VkAllocationCallbacks* allocator,
    VkPipeline* pipelines) {
  const auto data = FindDevice(device);
  const auto downstream =
      data == nullptr
          ? reinterpret_cast<PFN_vkCreateGraphicsPipelines>(
                reshade_get_device_proc_addr(
                    device,
                    "vkCreateGraphicsPipelines"))
          : data->create_graphics_pipelines;
  if (downstream == nullptr) return VK_ERROR_INITIALIZATION_FAILED;

  std::vector<std::uint32_t> shader_hashes(create_info_count, 0u);
  if (data != nullptr && !creating_or_destroying_variant
      && create_infos != nullptr) {
    for (std::uint32_t index = 0u; index < create_info_count; ++index) {
      shader_hashes[index] = FindFragmentShaderHash(data, create_infos[index]);
    }
  }

  const VkResult result = downstream(
      device,
      pipeline_cache,
      create_info_count,
      create_infos,
      allocator,
      pipelines);
  if (result != VK_SUCCESS || data == nullptr
      || creating_or_destroying_variant || pipelines == nullptr) {
    return result;
  }

  for (std::uint32_t index = 0u; index < create_info_count; ++index) {
    if (shader_hashes[index] != supported_build::kPostProcessShaderCrc
        && shader_hashes[index] != supported_build::kOutputShaderCrc) {
      continue;
    }
    BuildVariants(
        data,
        pipeline_cache,
        create_infos[index],
        allocator,
        pipelines[index],
        shader_hashes[index]);
  }
  return result;
}

VKAPI_ATTR PFN_vkVoidFunction VKAPI_CALL HookGetDeviceProcAddr(
    VkDevice device,
    const char* name) {
  if (name == nullptr || reshade_get_device_proc_addr == nullptr) return nullptr;
  const auto downstream = reshade_get_device_proc_addr(device, name);
  if (downstream == nullptr) return nullptr;
  if (std::strcmp(name, "vkGetDeviceProcAddr") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&HookGetDeviceProcAddr);
  }
  if (std::strcmp(name, "vkCreateShaderModule") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&HookCreateShaderModule);
  }
  if (std::strcmp(name, "vkDestroyShaderModule") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&HookDestroyShaderModule);
  }
  if (std::strcmp(name, "vkCreateGraphicsPipelines") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&HookCreateGraphicsPipelines);
  }
  return downstream;
}

VKAPI_ATTR PFN_vkVoidFunction VKAPI_CALL HookGetInstanceProcAddr(
    VkInstance instance,
    const char* name) {
  if (name == nullptr || reshade_get_instance_proc_addr == nullptr) return nullptr;
  const auto downstream = reshade_get_instance_proc_addr(instance, name);
  if (std::strcmp(name, "vkGetInstanceProcAddr") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&HookGetInstanceProcAddr);
  }
  if (std::strcmp(name, "vkGetDeviceProcAddr") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&HookGetDeviceProcAddr);
  }
  if (downstream == nullptr) return nullptr;
  if (std::strcmp(name, "vkCreateShaderModule") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&HookCreateShaderModule);
  }
  if (std::strcmp(name, "vkDestroyShaderModule") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&HookDestroyShaderModule);
  }
  if (std::strcmp(name, "vkCreateGraphicsPipelines") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&HookCreateGraphicsPipelines);
  }
  return downstream;
}

inline bool AttachEarlyHooks() {
  if (hooks_attached.load(std::memory_order_acquire)) return true;
  const HMODULE reshade = GetModuleHandleW(L"ReShade64.dll");
  if (reshade == nullptr) return false;
  reshade_get_instance_proc_addr =
      reinterpret_cast<PFN_vkGetInstanceProcAddr>(
          GetProcAddress(reshade, "vkGetInstanceProcAddr"));
  reshade_get_device_proc_addr =
      reinterpret_cast<PFN_vkGetDeviceProcAddr>(
          GetProcAddress(reshade, "vkGetDeviceProcAddr"));
  if (reshade_get_instance_proc_addr == nullptr
      || reshade_get_device_proc_addr == nullptr) {
    return false;
  }
  if (DetourTransactionBegin() != NO_ERROR
      || DetourUpdateThread(GetCurrentThread()) != NO_ERROR
      || DetourAttach(
             reinterpret_cast<PVOID*>(&reshade_get_instance_proc_addr),
             reinterpret_cast<PVOID>(&HookGetInstanceProcAddr))
             != NO_ERROR
      || DetourAttach(
             reinterpret_cast<PVOID*>(&reshade_get_device_proc_addr),
             reinterpret_cast<PVOID>(&HookGetDeviceProcAddr))
             != NO_ERROR
      || DetourTransactionCommit() != NO_ERROR) {
    DetourTransactionAbort();
    return false;
  }
  hooks_attached.store(true, std::memory_order_release);
  reshade::log::message(
      reshade::log::level::info,
      "DOOM 2016 HDR: exact native Vulkan pipeline hooks attached.");
  return true;
}

inline void OnInitDevice(reshade::api::device* device) {
  if (device == nullptr
      || device->get_api() != reshade::api::device_api::vulkan) {
    return;
  }
  const auto native = reinterpret_cast<VkDevice>(device->get_native());
  auto data = std::make_shared<DeviceData>();
  data->device = native;
  data->create_shader_module =
      reinterpret_cast<PFN_vkCreateShaderModule>(
          reshade_get_device_proc_addr(native, "vkCreateShaderModule"));
  data->destroy_shader_module =
      reinterpret_cast<PFN_vkDestroyShaderModule>(
          reshade_get_device_proc_addr(native, "vkDestroyShaderModule"));
  data->create_graphics_pipelines =
      reinterpret_cast<PFN_vkCreateGraphicsPipelines>(
          reshade_get_device_proc_addr(
              native,
              "vkCreateGraphicsPipelines"));
  data->destroy_pipeline =
      reinterpret_cast<PFN_vkDestroyPipeline>(
          reshade_get_device_proc_addr(native, "vkDestroyPipeline"));
  if (data->create_shader_module == nullptr
      || data->destroy_shader_module == nullptr
      || data->create_graphics_pipelines == nullptr
      || data->destroy_pipeline == nullptr) {
    reshade::log::message(
        reshade::log::level::error,
        "DOOM 2016 HDR: native Vulkan pipeline functions are unavailable.");
    return;
  }
  const std::unique_lock lock(devices_mutex);
  devices[native] = std::move(data);
}

inline void OnDestroyDevice(reshade::api::device* device) {
  if (device == nullptr) return;
  const auto native = reinterpret_cast<VkDevice>(device->get_native());
  const std::unique_lock lock(devices_mutex);
  devices.erase(native);
}

inline void OnDestroyPipeline(
    reshade::api::device* device,
    reshade::api::pipeline pipeline) {
  if (creating_or_destroying_variant || device == nullptr
      || pipeline.handle == 0u) {
    return;
  }
  const auto data = FindDevice(
      reinterpret_cast<VkDevice>(device->get_native()));
  if (data == nullptr) return;
  CachedVariants cached;
  {
    const std::unique_lock lock(data->mutex);
    const auto found = data->variants.find(
        reinterpret_cast<VkPipeline>(pipeline.handle));
    if (found == data->variants.end()) return;
    cached = std::move(found->second);
    data->variants.erase(found);
  }
  DestroyCachedVariants(data, &cached);
}

inline void OnBindPipeline(
    reshade::api::command_list* command_list,
    reshade::api::pipeline_stage stages,
    reshade::api::pipeline pipeline) {
  if (command_list == nullptr || pipeline.handle == 0u
      || stages != reshade::api::pipeline_stage::all_graphics) {
    return;
  }
  if (diagnostic_mode == DiagnosticMode::kProduction
      && (injection == nullptr
          || (injection->output_mode < 0.5f
              && injection->tone_map_type < 0.5f))) {
    return;
  }
  const auto data = FindDevice(reinterpret_cast<VkDevice>(
      command_list->get_device()->get_native()));
  if (data == nullptr) return;

  VkPipeline replacement = VK_NULL_HANDLE;
  bool post_process = false;
  std::size_t selected_index = 0u;
  {
    const std::shared_lock lock(data->mutex);
    const auto found = data->variants.find(
        reinterpret_cast<VkPipeline>(pipeline.handle));
    if (found == data->variants.end()) return;
    post_process = found->second.post_process;
    if (post_process) {
      selected_index = diagnostic_mode == DiagnosticMode::kProduction
                           ? ResolveToneMapIndex()
                           : 0u;
      replacement = found->second.tone_map[selected_index];
    } else {
      replacement = found->second.output;
    }
  }
  if (replacement == VK_NULL_HANDLE) return;
  command_list->bind_pipeline(
      stages,
      {reinterpret_cast<std::uint64_t>(replacement)});
  selected_pipeline_bind_count.fetch_add(1u, std::memory_order_relaxed);
  const std::uint32_t category_bit =
      post_process ? (1u << selected_index) : (1u << 8u);
  const auto previous = first_execution_mask.fetch_or(
      category_bit,
      std::memory_order_relaxed);
  if ((previous & category_bit) == 0u) {
    if (post_process) {
      const std::string message =
          "DOOM 2016 HDR: executing exact-native post-process mode "
          + std::to_string(selected_index) + ".";
      reshade::log::message(
          reshade::log::level::info,
          message.c_str());
    } else {
      reshade::log::message(
          reshade::log::level::info,
          "DOOM 2016 HDR: executing the exact-native final-output VkPipeline.");
    }
  }
}

inline void UseEarly(DWORD reason, ShaderInjectData* shader_injection) {
  if (reason != DLL_PROCESS_ATTACH) return;
  injection = shader_injection;
  if (!AttachEarlyHooks()) {
    reshade::log::message(
        reshade::log::level::error,
        "DOOM 2016 HDR: failed to attach exact native Vulkan hooks.");
  }
  reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
  reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
}

inline void UseLate(DWORD reason) {
  if (reason != DLL_PROCESS_ATTACH) return;
  reshade::register_event<reshade::addon_event::destroy_pipeline>(
      OnDestroyPipeline);
  reshade::register_event<reshade::addon_event::bind_pipeline>(
      OnBindPipeline);
}

}  // namespace renodx::games::doom2016::pipeline_variants
