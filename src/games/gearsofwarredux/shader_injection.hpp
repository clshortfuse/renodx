/*
 * Copyright (C) 2026 RenoDX contributors
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <d3d11.h>
#include <wrl/client.h>

#include <cstring>
#include <format>
#include <mutex>
#include <shared_mutex>
#include <span>
#include <unordered_map>
#include <unordered_set>

#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../utils/data.hpp"
#include "../../utils/hash.hpp"
#include "./shared.h"

namespace gearsofwarredux::shader {

struct __declspec(uuid("a2b676fa-ef2e-4946-847e-3f99a395ddf5")) DeviceData {
  std::shared_mutex mutex;
  std::unordered_set<uint64_t> pipelines;
};

struct __declspec(uuid("849cb0b3-e8a1-4e78-b423-997586cb3998")) ContextData {
  Microsoft::WRL::ComPtr<ID3D11Buffer> buffer;
  ShaderInjectData uploaded = {};
  bool has_upload = false;
};

static std::unordered_map<uint32_t, std::span<const uint8_t>> replacements;
static std::unordered_set<uint32_t> replacement_hashes;
static const ShaderInjectData* injection = nullptr;

// One dynamic buffer per recording context. Bind again after NGX or the
// output proxy changes b13, but upload only when the actual settings change.
inline bool BindConstants(ID3D11DeviceContext* context, ContextData* data,
                          const ShaderInjectData& values) {
  if (data->buffer == nullptr) {
    Microsoft::WRL::ComPtr<ID3D11Device> device;
    context->GetDevice(&device);
    D3D11_BUFFER_DESC desc = {};
    desc.ByteWidth = sizeof(ShaderInjectData);
    desc.Usage = D3D11_USAGE_DYNAMIC;
    desc.BindFlags = D3D11_BIND_CONSTANT_BUFFER;
    desc.CPUAccessFlags = D3D11_CPU_ACCESS_WRITE;
    if (FAILED(device->CreateBuffer(&desc, nullptr, &data->buffer))) return false;
  }

  if (!data->has_upload || std::memcmp(&data->uploaded, &values, sizeof(values)) != 0) {
    D3D11_MAPPED_SUBRESOURCE mapped = {};
    if (FAILED(context->Map(data->buffer.Get(), 0, D3D11_MAP_WRITE_DISCARD, 0, &mapped))) return false;
    std::memcpy(mapped.pData, &values, sizeof(values));
    context->Unmap(data->buffer.Get(), 0);
    data->uploaded = values;
    data->has_upload = true;
  }
  context->PSSetConstantBuffers(13, 1, data->buffer.GetAddressOf());
  return true;
}

inline void OnInitDevice(reshade::api::device* device) {
  if (device->get_api() == reshade::api::device_api::d3d11) {
    renodx::utils::data::Create<DeviceData>(device);
  }
}

inline void OnDestroyDevice(reshade::api::device* device) {
  renodx::utils::data::Delete<DeviceData>(device);
}

inline bool OnCreatePipeline(reshade::api::device* device, reshade::api::pipeline_layout,
                             uint32_t count, const reshade::api::pipeline_subobject* subobjects) {
  if (device->get_api() != reshade::api::device_api::d3d11) return false;
  bool changed = false;
  for (uint32_t i = 0; i < count; ++i) {
    if (subobjects[i].type != reshade::api::pipeline_subobject_type::pixel_shader) continue;
    auto* desc = static_cast<reshade::api::shader_desc*>(subobjects[i].data);
    if (desc->code == nullptr || desc->code_size == 0) continue;
    const auto found = replacements.find(renodx::utils::hash::ComputeCRC32(
        static_cast<const uint8_t*>(desc->code), desc->code_size));
    if (found == replacements.end()) continue;
    // Embedded DXBC stays alive for the addon lifetime. ReShade's DX11
    // CreatePixelShader passes this descriptor through to init_pipeline.
    desc->code = found->second.data();
    desc->code_size = found->second.size();
    desc->entry_point = "main";
    changed = true;
    reshade::log::message(reshade::log::level::info,
        std::format("Gears Redux direct DX11 shader: replaced {:#010x} at creation", found->first).c_str());
  }
  return changed;
}

inline void OnInitPipeline(reshade::api::device* device, reshade::api::pipeline_layout,
                           uint32_t count, const reshade::api::pipeline_subobject* subobjects,
                           reshade::api::pipeline pipeline) {
  if (device->get_api() != reshade::api::device_api::d3d11) return;
  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) return;
  for (uint32_t i = 0; i < count; ++i) {
    if (subobjects[i].type != reshade::api::pipeline_subobject_type::pixel_shader) continue;
    const auto* desc = static_cast<const reshade::api::shader_desc*>(subobjects[i].data);
    if (desc->code == nullptr || desc->code_size == 0) continue;
    if (!replacement_hashes.contains(renodx::utils::hash::ComputeCRC32(
            static_cast<const uint8_t*>(desc->code), desc->code_size))) continue;
    const std::unique_lock lock(data->mutex);
    data->pipelines.insert(pipeline.handle);
  }
}

inline void OnDestroyPipeline(reshade::api::device* device, reshade::api::pipeline pipeline) {
  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) return;
  const std::unique_lock lock(data->mutex);
  data->pipelines.erase(pipeline.handle);
}

inline void OnBindPipeline(reshade::api::command_list* cmd_list,
                          reshade::api::pipeline_stage stage, reshade::api::pipeline pipeline) {
  if (stage != reshade::api::pipeline_stage::pixel_shader || pipeline.handle == 0u) return;
  auto* device_data = renodx::utils::data::Get<DeviceData>(cmd_list->get_device());
  if (device_data == nullptr) return;
  {
    const std::shared_lock lock(device_data->mutex);
    if (!device_data->pipelines.contains(pipeline.handle)) return;
  }
  auto* data = renodx::utils::data::Get<ContextData>(cmd_list);
  if (data == nullptr) data = renodx::utils::data::Create<ContextData>(cmd_list);
  if (!BindConstants(reinterpret_cast<ID3D11DeviceContext*>(cmd_list->get_native()), data, *injection)) {
    reshade::log::message(reshade::log::level::error, "Gears Redux direct DX11 shader: failed to bind settings");
  }
}

inline void OnDestroyCommandList(reshade::api::command_list* cmd_list) {
  renodx::utils::data::Delete<ContextData>(cmd_list);
}

static void Use(DWORD reason, const renodx::mods::shader::CustomShaders& shaders,
                const ShaderInjectData* values) {
  if (reason == DLL_PROCESS_ATTACH) {
    injection = values;
    for (const auto& [hash, shader] : shaders) {
      replacements.emplace(hash, shader.code);
      replacement_hashes.insert(renodx::utils::hash::ComputeCRC32(shader.code.data(), shader.code.size()));
    }
    reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
    reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
    reshade::register_event<reshade::addon_event::create_pipeline>(OnCreatePipeline);
    reshade::register_event<reshade::addon_event::init_pipeline>(OnInitPipeline);
    reshade::register_event<reshade::addon_event::destroy_pipeline>(OnDestroyPipeline);
    reshade::register_event<reshade::addon_event::bind_pipeline>(OnBindPipeline);
    reshade::register_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);
  } else if (reason == DLL_PROCESS_DETACH) {
    reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
    reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
    reshade::unregister_event<reshade::addon_event::create_pipeline>(OnCreatePipeline);
    reshade::unregister_event<reshade::addon_event::init_pipeline>(OnInitPipeline);
    reshade::unregister_event<reshade::addon_event::destroy_pipeline>(OnDestroyPipeline);
    reshade::unregister_event<reshade::addon_event::bind_pipeline>(OnBindPipeline);
    reshade::unregister_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);
  }
}

}  // namespace gearsofwarredux::shader
