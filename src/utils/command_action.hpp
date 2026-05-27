/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <array>
#include <cassert>
#include <concepts>
#include <cstddef>
#include <cstdint>
#include <optional>
#include <span>
#include <type_traits>
#include <vector>

#include <include/reshade.hpp>

#include "./cross_addon.hpp"
#include "./shader.hpp"
#include "./swapchain.hpp"

namespace renodx::utils::command_action {

enum CommandType : uint8_t {
  COMMAND_TYPE_DRAW = 0b00001u,
  COMMAND_TYPE_DRAW_INDEXED = 0b00010u,
  COMMAND_TYPE_DISPATCH = 0b00100u,
  COMMAND_TYPE_INDIRECT = 0b01000u,
  COMMAND_TYPE_DISPATCH_MESH = 0b10000u,
  COMMAND_TYPE_DIRECT_DRAW = COMMAND_TYPE_DRAW | COMMAND_TYPE_DRAW_INDEXED,
  COMMAND_TYPE_DIRECT_DISPATCH = COMMAND_TYPE_DISPATCH | COMMAND_TYPE_DISPATCH_MESH,
  COMMAND_TYPE_ALL = COMMAND_TYPE_DRAW | COMMAND_TYPE_DRAW_INDEXED | COMMAND_TYPE_DISPATCH | COMMAND_TYPE_INDIRECT | COMMAND_TYPE_DISPATCH_MESH,
};

enum CommandIndex : uint8_t {
  COMMAND_INDEX_DRAW,
  COMMAND_INDEX_DRAW_INDEXED,
  COMMAND_INDEX_DISPATCH,
  COMMAND_INDEX_INDIRECT,
  COMMAND_INDEX_DISPATCH_MESH,
  COMMAND_INDEX_COUNT,
};

struct DrawArguments {
  static constexpr uint32_t COMMAND_TYPE = COMMAND_TYPE_DRAW;
  static constexpr size_t COMMAND_INDEX = COMMAND_INDEX_DRAW;

  uint32_t vertex_count = 0u;
  uint32_t instance_count = 0u;
  uint32_t first_vertex = 0u;
  uint32_t first_instance = 0u;
};

struct DrawIndexedArguments {
  static constexpr uint32_t COMMAND_TYPE = COMMAND_TYPE_DRAW_INDEXED;
  static constexpr size_t COMMAND_INDEX = COMMAND_INDEX_DRAW_INDEXED;

  uint32_t index_count = 0u;
  uint32_t instance_count = 0u;
  uint32_t first_index = 0u;
  int32_t vertex_offset = 0;
  uint32_t first_instance = 0u;
};

struct DispatchArguments {
  static constexpr uint32_t COMMAND_TYPE = COMMAND_TYPE_DISPATCH;
  static constexpr size_t COMMAND_INDEX = COMMAND_INDEX_DISPATCH;

  uint32_t group_count_x = 0u;
  uint32_t group_count_y = 0u;
  uint32_t group_count_z = 0u;
};

struct DispatchMeshArguments {
  static constexpr uint32_t COMMAND_TYPE = COMMAND_TYPE_DISPATCH_MESH;
  static constexpr size_t COMMAND_INDEX = COMMAND_INDEX_DISPATCH_MESH;

  uint32_t group_count_x = 0u;
  uint32_t group_count_y = 0u;
  uint32_t group_count_z = 0u;
};

struct IndirectArguments {
  static constexpr uint32_t COMMAND_TYPE = COMMAND_TYPE_INDIRECT;
  static constexpr size_t COMMAND_INDEX = COMMAND_INDEX_INDIRECT;

  reshade::api::indirect_command command = reshade::api::indirect_command::unknown;
  reshade::api::resource buffer = {0u};
  uint64_t offset = 0u;
  uint32_t draw_count = 0u;
  uint32_t stride = 0u;
  bool unknown_command_is_dispatch = false;
};

template <typename Arguments>
struct CommandContext {
  using ArgumentType = Arguments;

  reshade::api::command_list* cmd_list = nullptr;
  Arguments arguments = {};

  std::optional<renodx::utils::shader::CommandListData*> shader_state = std::nullopt;
  std::optional<renodx::utils::swapchain::CommandListData*> swapchain_state = std::nullopt;
  std::array<uint32_t, renodx::utils::shader::COMPATIBLE_STAGES_SIZE> shader_hashes = {};
  uint32_t matched_shader_hash = 0u;
  std::optional<renodx::utils::shader::ShaderStageIndex> matched_shader_stage = std::nullopt;
  bool shader_hashes_populated = false;
  const void* callback_data = nullptr;

  template <typename T>
  [[nodiscard]] const T& GetCallbackData() const {
    assert(callback_data != nullptr);
    return *static_cast<const T*>(callback_data);
  }

  [[nodiscard]] constexpr bool IsDispatch() const {
    if constexpr (std::is_same_v<Arguments, DispatchArguments>) {
      return true;
    } else if constexpr (std::is_same_v<Arguments, DispatchMeshArguments>) {
      return true;
    } else if constexpr (std::is_same_v<Arguments, IndirectArguments>) {
      switch (arguments.command) {
        case reshade::api::indirect_command::unknown:
          return arguments.unknown_command_is_dispatch;
        case reshade::api::indirect_command::dispatch:
        case reshade::api::indirect_command::dispatch_mesh:
        case reshade::api::indirect_command::dispatch_rays:
          return true;
        default:
          return false;
      }
    } else {
      return false;
    }
  }
};

template <typename Arguments>
inline renodx::utils::shader::CommandListData* GetShaderState(CommandContext<Arguments>* context) {
  assert(context != nullptr);
  if (context == nullptr) return nullptr;
  if (!context->shader_state.has_value()) {
    context->shader_state = context->cmd_list != nullptr
                                ? renodx::utils::shader::GetCurrentState(context->cmd_list)
                                : nullptr;
  }
  return *context->shader_state;
}

template <typename Arguments>
inline renodx::utils::swapchain::CommandListData* GetSwapchainState(CommandContext<Arguments>* context) {
  assert(context != nullptr);
  if (context == nullptr) return nullptr;
  if (!context->swapchain_state.has_value()) {
    context->swapchain_state = context->cmd_list != nullptr
                                   ? renodx::utils::swapchain::GetCurrentState(context->cmd_list)
                                   : nullptr;
  }
  return *context->swapchain_state;
}

template <typename Context>
struct CallbackResult {
  using PostCallback = void (*)(Context& context, const void* data);

  PostCallback post_callback = nullptr;
  const void* post_data = nullptr;
  bool bypass = false;
  bool replay = false;
};

struct Filter {
  uint32_t shader_hash = 0u;
  uint32_t command_types = COMMAND_TYPE_ALL;
};

using CallbackThunk = void (*)(void* context, const void* callback_data, void* result);

namespace internal {

struct CallbackRegistration {
  uint32_t command_types = COMMAND_TYPE_ALL;
  std::array<CallbackThunk, COMMAND_INDEX_COUNT> command_thunks = {};
  const void* callback = nullptr;
  const void* callback_data = nullptr;
};

using RegistrationList = cross_addon::vector<CallbackRegistration>;
using RegistrationMap = cross_addon::unordered_map<uint32_t, RegistrationList>;

struct __declspec(uuid("542d9cab-784b-496a-8ad8-f22e6b5dfca0")) SharedData {
  RegistrationMap registrations;
};

static cross_addon::Shared<SharedData> shared;

template <typename Callback>
inline constexpr uint8_t CALLBACK_IDENTITY = 0u;

template <typename Callback, typename Context, typename T>
inline constexpr bool IS_DATA_TEMPLATE_CALLBACK = requires(Callback callback, Context& context) {
  { callback.template operator()<T>(context) } -> std::convertible_to<CallbackResult<Context>>;
};

template <typename Callback, typename Context>
inline void InvokeCallback(void* context, const void* /*callback_data*/, void* result) {
  using Result = CallbackResult<Context>;

  if constexpr (std::is_invocable_r_v<Result, Callback, Context&>) {
    *static_cast<Result*>(result) = Callback{}(*static_cast<Context*>(context));
  } else {
    assert(false);
    *static_cast<Result*>(result) = {};
  }
}

template <typename Callback, typename Context, typename T>
inline void InvokeCallback(void* context, const void* callback_data, void* result) {
  using Result = CallbackResult<Context>;

  assert(callback_data != nullptr);
  auto* typed_context = static_cast<Context*>(context);
  const auto* previous_callback_data = typed_context->callback_data;
  typed_context->callback_data = callback_data;
  if constexpr (IS_DATA_TEMPLATE_CALLBACK<Callback, Context, T>) {
    *static_cast<Result*>(result) = Callback{}.template operator()<T>(*typed_context);
  } else if constexpr (std::is_invocable_r_v<Result, Callback, Context&>) {
    *static_cast<Result*>(result) = Callback{}(*typed_context);
  } else {
    assert(false);
    *static_cast<Result*>(result) = {};
  }
  typed_context->callback_data = previous_callback_data;
}

constexpr bool IsValidCommandTypeMask(uint32_t command_types) {
  return command_types != 0u && (command_types & ~COMMAND_TYPE_ALL) == 0u;
}

template <typename Arguments>
inline bool RunCallbacks(CommandContext<Arguments> context) {
  const auto* data = shared.data;
  if (data == nullptr || data->registrations.empty()) return false;

  const auto command_registrations_it = data->registrations.find(0u);
  const bool has_command_registrations = command_registrations_it != data->registrations.end() && !command_registrations_it->second.empty();
  const bool has_shader_registrations = data->registrations.size() > (has_command_registrations ? 1u : 0u);
  if (!has_command_registrations && !has_shader_registrations) return false;

  struct PendingPostResult {
    CallbackResult<CommandContext<Arguments>> result = {};
    const void* callback_data = nullptr;
    uint32_t matched_shader_hash = 0u;
    std::optional<renodx::utils::shader::ShaderStageIndex> matched_shader_stage = std::nullopt;
  };

  static thread_local std::vector<PendingPostResult> pending_post_results;
  pending_post_results.clear();

  bool ran_callback = false;
  bool should_replay = false;

  const auto run_registration_list = [&](std::span<const CallbackRegistration> registrations) {
    constexpr uint32_t command_type = Arguments::COMMAND_TYPE;
    constexpr size_t command_index = Arguments::COMMAND_INDEX;

    if (pending_post_results.capacity() < pending_post_results.size() + registrations.size()) {
      pending_post_results.reserve(pending_post_results.size() + registrations.size());
    }
    for (const auto& registration : registrations) {
      assert(IsValidCommandTypeMask(registration.command_types));
      if ((registration.command_types & command_type) == 0u) continue;
      assert(registration.command_thunks[command_index] != nullptr);

      ran_callback = true;
      CallbackResult<CommandContext<Arguments>> result = {};
      registration.command_thunks[command_index](&context, registration.callback_data, &result);
      if (result.bypass) return true;

      should_replay |= result.replay || result.post_callback != nullptr;
      if (result.post_callback != nullptr) {
        pending_post_results.push_back({
            .result = result,
            .callback_data = registration.callback_data,
            .matched_shader_hash = context.matched_shader_hash,
            .matched_shader_stage = context.matched_shader_stage,
        });
      }
    }

    return false;
  };

  const auto run_shader_callbacks = [&](uint32_t shader_hash, renodx::utils::shader::ShaderStageIndex shader_stage) {
    if (shader_hash == 0u) return false;

    const auto shader_registrations_it = data->registrations.find(shader_hash);
    if (shader_registrations_it == data->registrations.end()) return false;
    if (shader_registrations_it->second.empty()) return false;

    const uint32_t previous_shader_hash = context.matched_shader_hash;
    const auto previous_shader_stage = context.matched_shader_stage;
    context.matched_shader_hash = shader_hash;
    context.matched_shader_stage = shader_stage;

    const bool bypass = run_registration_list({shader_registrations_it->second.data(), shader_registrations_it->second.size()});

    context.matched_shader_hash = previous_shader_hash;
    context.matched_shader_stage = previous_shader_stage;

    return bypass;
  };

  if (has_command_registrations
      && run_registration_list({command_registrations_it->second.data(), command_registrations_it->second.size()})) {
    return true;
  }

  if (has_shader_registrations) {
    const auto get_shader_hash = [&](int index) {
      if (!context.shader_hashes_populated) {
        context.shader_hashes_populated = true;

        auto* shader_state = renodx::utils::command_action::GetShaderState(&context);
        if (shader_state != nullptr) {
          const auto set_shader_hash = [&](int shader_index) {
            context.shader_hashes[shader_index] = renodx::utils::shader::GetCurrentShaderHash(shader_state, shader_index);
          };

          if constexpr (std::is_same_v<Arguments, DispatchArguments> || std::is_same_v<Arguments, DispatchMeshArguments>) {
            set_shader_hash(renodx::utils::shader::COMPUTE_INDEX);
          } else if constexpr (std::is_same_v<Arguments, IndirectArguments>) {
            if (context.IsDispatch()) {
              set_shader_hash(renodx::utils::shader::COMPUTE_INDEX);
            } else {
              set_shader_hash(renodx::utils::shader::VERTEX_INDEX);
              set_shader_hash(renodx::utils::shader::PIXEL_INDEX);
            }
          } else {
            set_shader_hash(renodx::utils::shader::VERTEX_INDEX);
            set_shader_hash(renodx::utils::shader::PIXEL_INDEX);
          }
        }
      }
      return context.shader_hashes[index];
    };

    const auto run_compute_shader_callbacks = [&]() {
      return run_shader_callbacks(
          get_shader_hash(renodx::utils::shader::COMPUTE_INDEX),
          renodx::utils::shader::COMPUTE_INDEX);
    };
    const auto run_graphics_shader_callbacks = [&]() {
      const uint32_t vertex_shader_hash = get_shader_hash(renodx::utils::shader::VERTEX_INDEX);
      const uint32_t pixel_shader_hash = get_shader_hash(renodx::utils::shader::PIXEL_INDEX);
      if (run_shader_callbacks(vertex_shader_hash, renodx::utils::shader::VERTEX_INDEX)) return true;
      return pixel_shader_hash != vertex_shader_hash
             && run_shader_callbacks(pixel_shader_hash, renodx::utils::shader::PIXEL_INDEX);
    };

    if constexpr (std::is_same_v<Arguments, DispatchArguments> || std::is_same_v<Arguments, DispatchMeshArguments>) {
      if (run_compute_shader_callbacks()) return true;
    } else if constexpr (std::is_same_v<Arguments, IndirectArguments>) {
      if (context.IsDispatch()) {
        if (run_compute_shader_callbacks()) return true;
      } else if (run_graphics_shader_callbacks()) {
        return true;
      }
    } else if (run_graphics_shader_callbacks()) {
      return true;
    }
  }

  if (!ran_callback) return false;
  if (!should_replay) return false;
  assert(context.cmd_list != nullptr);

  if constexpr (std::is_same_v<Arguments, DrawArguments>) {
    context.cmd_list->draw(
        context.arguments.vertex_count,
        context.arguments.instance_count,
        context.arguments.first_vertex,
        context.arguments.first_instance);
  } else if constexpr (std::is_same_v<Arguments, DrawIndexedArguments>) {
    context.cmd_list->draw_indexed(
        context.arguments.index_count,
        context.arguments.instance_count,
        context.arguments.first_index,
        context.arguments.vertex_offset,
        context.arguments.first_instance);
  } else if constexpr (std::is_same_v<Arguments, DispatchArguments>) {
    context.cmd_list->dispatch(
        context.arguments.group_count_x,
        context.arguments.group_count_y,
        context.arguments.group_count_z);
  } else if constexpr (std::is_same_v<Arguments, IndirectArguments>) {
    context.cmd_list->draw_or_dispatch_indirect(
        context.arguments.command,
        context.arguments.buffer,
        context.arguments.offset,
        context.arguments.draw_count,
        context.arguments.stride);
  } else if constexpr (std::is_same_v<Arguments, DispatchMeshArguments>) {
    context.cmd_list->dispatch_mesh(
        context.arguments.group_count_x,
        context.arguments.group_count_y,
        context.arguments.group_count_z);
  }

  for (auto& pending_post_result : pending_post_results) {
    const auto* previous_callback_data = context.callback_data;
    const uint32_t previous_shader_hash = context.matched_shader_hash;
    const auto previous_shader_stage = context.matched_shader_stage;
    context.callback_data = pending_post_result.callback_data;
    context.matched_shader_hash = pending_post_result.matched_shader_hash;
    context.matched_shader_stage = pending_post_result.matched_shader_stage;
    pending_post_result.result.post_callback(context, pending_post_result.result.post_data);
    context.callback_data = previous_callback_data;
    context.matched_shader_hash = previous_shader_hash;
    context.matched_shader_stage = previous_shader_stage;
  }

  return true;
}

inline bool OnDraw(
    reshade::api::command_list* cmd_list,
    uint32_t vertex_count,
    uint32_t instance_count,
    uint32_t first_vertex,
    uint32_t first_instance) {
  return RunCallbacks<DrawArguments>({
      .cmd_list = cmd_list,
      .arguments = DrawArguments{
          .vertex_count = vertex_count,
          .instance_count = instance_count,
          .first_vertex = first_vertex,
          .first_instance = first_instance,
      },
  });
}

inline bool OnDrawIndexed(
    reshade::api::command_list* cmd_list,
    uint32_t index_count,
    uint32_t instance_count,
    uint32_t first_index,
    int32_t vertex_offset,
    uint32_t first_instance) {
  return RunCallbacks<DrawIndexedArguments>({
      .cmd_list = cmd_list,
      .arguments = DrawIndexedArguments{
          .index_count = index_count,
          .instance_count = instance_count,
          .first_index = first_index,
          .vertex_offset = vertex_offset,
          .first_instance = first_instance,
      },
  });
}

inline bool OnDispatch(
    reshade::api::command_list* cmd_list,
    uint32_t group_count_x,
    uint32_t group_count_y,
    uint32_t group_count_z) {
  return RunCallbacks<DispatchArguments>({
      .cmd_list = cmd_list,
      .arguments = DispatchArguments{
          .group_count_x = group_count_x,
          .group_count_y = group_count_y,
          .group_count_z = group_count_z,
      },
  });
}

inline bool OnDispatchMesh(
    reshade::api::command_list* cmd_list,
    uint32_t group_count_x,
    uint32_t group_count_y,
    uint32_t group_count_z) {
  return RunCallbacks<DispatchMeshArguments>({
      .cmd_list = cmd_list,
      .arguments = DispatchMeshArguments{
          .group_count_x = group_count_x,
          .group_count_y = group_count_y,
          .group_count_z = group_count_z,
      },
  });
}

inline bool OnDrawOrDispatchIndirect(
    reshade::api::command_list* cmd_list,
    reshade::api::indirect_command type,
    reshade::api::resource buffer,
    uint64_t offset,
    uint32_t draw_count,
    uint32_t stride) {
  CommandContext<IndirectArguments> context = {
      .cmd_list = cmd_list,
      .arguments = IndirectArguments{
          .command = type,
          .buffer = buffer,
          .offset = offset,
          .draw_count = draw_count,
          .stride = stride,
      },
  };
  if (type == reshade::api::indirect_command::unknown) {
    auto* shader_state = renodx::utils::command_action::GetShaderState(&context);
    if (shader_state != nullptr) {
      const uint32_t shader_hash = renodx::utils::shader::GetCurrentComputeShaderHash(shader_state);
      context.shader_hashes[renodx::utils::shader::COMPUTE_INDEX] = shader_hash;
      context.arguments.unknown_command_is_dispatch = shader_hash != 0u;
    }
  }
  return RunCallbacks<IndirectArguments>(context);
}

}  // namespace internal

template <typename Callback>
inline void RegisterCallback(Callback&& callback, Filter filter) {
  using CallbackType = std::remove_cvref_t<Callback>;
  (void)callback;

  static_assert(std::is_empty_v<CallbackType>);
  static_assert(std::is_default_constructible_v<CallbackType>);

  constexpr bool supports_draw = std::is_invocable_r_v<CallbackResult<CommandContext<DrawArguments>>, CallbackType, CommandContext<DrawArguments>&>;
  constexpr bool supports_draw_indexed = std::is_invocable_r_v<CallbackResult<CommandContext<DrawIndexedArguments>>, CallbackType, CommandContext<DrawIndexedArguments>&>;
  constexpr bool supports_dispatch = std::is_invocable_r_v<CallbackResult<CommandContext<DispatchArguments>>, CallbackType, CommandContext<DispatchArguments>&>;
  constexpr bool supports_indirect = std::is_invocable_r_v<CallbackResult<CommandContext<IndirectArguments>>, CallbackType, CommandContext<IndirectArguments>&>;
  constexpr bool supports_dispatch_mesh = std::is_invocable_r_v<CallbackResult<CommandContext<DispatchMeshArguments>>, CallbackType, CommandContext<DispatchMeshArguments>&>;
  constexpr uint32_t supported_command_types = (supports_draw ? COMMAND_TYPE_DRAW : 0u)
                                             | (supports_draw_indexed ? COMMAND_TYPE_DRAW_INDEXED : 0u)
                                             | (supports_dispatch ? COMMAND_TYPE_DISPATCH : 0u)
                                             | (supports_indirect ? COMMAND_TYPE_INDIRECT : 0u)
                                             | (supports_dispatch_mesh ? COMMAND_TYPE_DISPATCH_MESH : 0u);
  const uint32_t command_types = filter.command_types & supported_command_types;

  internal::shared.RegisterModule();
  auto* data = internal::shared.data;
  if (data == nullptr) return;
  assert(internal::IsValidCommandTypeMask(filter.command_types));
  assert(internal::IsValidCommandTypeMask(command_types));
  if (!internal::IsValidCommandTypeMask(filter.command_types) || !internal::IsValidCommandTypeMask(command_types)) return;

  auto& registrations = data->registrations[filter.shader_hash];

  const void* const callback_identity = &internal::CALLBACK_IDENTITY<CallbackType>;

  std::erase_if(registrations, [&](const internal::CallbackRegistration& existing_registration) {
    return existing_registration.callback == callback_identity
           && existing_registration.command_types == command_types;
  });
  registrations.push_back({
      .command_types = command_types,
      .command_thunks = {
        supports_draw ? internal::InvokeCallback<CallbackType, CommandContext<DrawArguments>> : nullptr,
        supports_draw_indexed ? internal::InvokeCallback<CallbackType, CommandContext<DrawIndexedArguments>> : nullptr,
        supports_dispatch ? internal::InvokeCallback<CallbackType, CommandContext<DispatchArguments>> : nullptr,
        supports_indirect ? internal::InvokeCallback<CallbackType, CommandContext<IndirectArguments>> : nullptr,
        supports_dispatch_mesh ? internal::InvokeCallback<CallbackType, CommandContext<DispatchMeshArguments>> : nullptr,
      },
      .callback = callback_identity,
      .callback_data = nullptr,
  });
}

template <typename Callback, typename T>
inline void RegisterCallback(Callback&& callback, Filter filter, const T* callback_data) {
  using CallbackType = std::remove_cvref_t<Callback>;
  using DataType = std::remove_cv_t<T>;
  (void)callback;

  static_assert(std::is_empty_v<CallbackType>);
  static_assert(std::is_default_constructible_v<CallbackType>);

  constexpr bool supports_draw = internal::IS_DATA_TEMPLATE_CALLBACK<CallbackType, CommandContext<DrawArguments>, DataType>
                  || std::is_invocable_r_v<CallbackResult<CommandContext<DrawArguments>>, CallbackType, CommandContext<DrawArguments>&>;
  constexpr bool supports_draw_indexed = internal::IS_DATA_TEMPLATE_CALLBACK<CallbackType, CommandContext<DrawIndexedArguments>, DataType>
                      || std::is_invocable_r_v<CallbackResult<CommandContext<DrawIndexedArguments>>, CallbackType, CommandContext<DrawIndexedArguments>&>;
  constexpr bool supports_dispatch = internal::IS_DATA_TEMPLATE_CALLBACK<CallbackType, CommandContext<DispatchArguments>, DataType>
                    || std::is_invocable_r_v<CallbackResult<CommandContext<DispatchArguments>>, CallbackType, CommandContext<DispatchArguments>&>;
  constexpr bool supports_indirect = internal::IS_DATA_TEMPLATE_CALLBACK<CallbackType, CommandContext<IndirectArguments>, DataType>
                    || std::is_invocable_r_v<CallbackResult<CommandContext<IndirectArguments>>, CallbackType, CommandContext<IndirectArguments>&>;
  constexpr bool supports_dispatch_mesh = internal::IS_DATA_TEMPLATE_CALLBACK<CallbackType, CommandContext<DispatchMeshArguments>, DataType>
                       || std::is_invocable_r_v<CallbackResult<CommandContext<DispatchMeshArguments>>, CallbackType, CommandContext<DispatchMeshArguments>&>;
  constexpr uint32_t supported_command_types = (supports_draw ? COMMAND_TYPE_DRAW : 0u)
                                             | (supports_draw_indexed ? COMMAND_TYPE_DRAW_INDEXED : 0u)
                                             | (supports_dispatch ? COMMAND_TYPE_DISPATCH : 0u)
                                             | (supports_indirect ? COMMAND_TYPE_INDIRECT : 0u)
                                             | (supports_dispatch_mesh ? COMMAND_TYPE_DISPATCH_MESH : 0u);
  const uint32_t command_types = filter.command_types & supported_command_types;

  internal::shared.RegisterModule();
  auto* data = internal::shared.data;
  if (data == nullptr) return;
  assert(callback_data != nullptr);
  assert(internal::IsValidCommandTypeMask(filter.command_types));
  assert(internal::IsValidCommandTypeMask(command_types));
  if (callback_data == nullptr || !internal::IsValidCommandTypeMask(filter.command_types) || !internal::IsValidCommandTypeMask(command_types)) return;

  auto& registrations = data->registrations[filter.shader_hash];

  const void* const callback_identity = &internal::CALLBACK_IDENTITY<CallbackType>;
  const void* const erased_data = callback_data;

  std::erase_if(registrations, [&](const internal::CallbackRegistration& existing_registration) {
    return existing_registration.callback == callback_identity
           && existing_registration.callback_data == erased_data
           && existing_registration.command_types == command_types;
  });
  registrations.push_back({
      .command_types = command_types,
      .command_thunks = {
        supports_draw ? internal::InvokeCallback<CallbackType, CommandContext<DrawArguments>, DataType> : nullptr,
        supports_draw_indexed ? internal::InvokeCallback<CallbackType, CommandContext<DrawIndexedArguments>, DataType> : nullptr,
        supports_dispatch ? internal::InvokeCallback<CallbackType, CommandContext<DispatchArguments>, DataType> : nullptr,
        supports_indirect ? internal::InvokeCallback<CallbackType, CommandContext<IndirectArguments>, DataType> : nullptr,
        supports_dispatch_mesh ? internal::InvokeCallback<CallbackType, CommandContext<DispatchMeshArguments>, DataType> : nullptr,
      },
      .callback = callback_identity,
      .callback_data = erased_data,
  });
}

template <typename Callback>
  requires(!std::is_pointer_v<std::remove_reference_t<Callback>>)
inline void Register(Callback&& callback, Filter filter) {
  RegisterCallback(callback, filter);
}

template <typename T, typename Callback>
  requires(!std::is_pointer_v<std::remove_reference_t<Callback>>)
inline void Register(Callback&& callback, Filter filter, const T* callback_data) {
  RegisterCallback(callback, filter, callback_data);
}

template <typename Callback>
inline void UnregisterCallback(Callback&& callback) {
  using CallbackType = std::remove_cvref_t<Callback>;
  (void)callback;

  auto* data = internal::shared.data;
  if (data == nullptr) return;

  const void* const callback_identity = &internal::CALLBACK_IDENTITY<CallbackType>;

  for (auto it = data->registrations.begin(); it != data->registrations.end();) {
    std::erase_if(it->second, [&](const internal::CallbackRegistration& registration) {
      return registration.callback == callback_identity;
    });
    if (it->second.empty()) {
      it = data->registrations.erase(it);
    } else {
      ++it;
    }
  }
}

template <typename Callback>
  requires(!std::is_pointer_v<std::remove_reference_t<Callback>>)
inline void Unregister(Callback&& callback) {
  UnregisterCallback(callback);
}

inline void Use(DWORD fdw_reason) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (internal::shared.RegisterModule()) {
        reshade::log::message(reshade::log::level::info, "utils::command_action attached...");
      }
      {
        std::array<bool, COMMAND_INDEX_COUNT> command_event_active = {};
        const auto update_command_event_active = [&](const internal::CallbackRegistration& registration) {
          command_event_active[COMMAND_INDEX_DRAW] |= (registration.command_types & COMMAND_TYPE_DRAW) != 0u;
          command_event_active[COMMAND_INDEX_DRAW_INDEXED] |= (registration.command_types & COMMAND_TYPE_DRAW_INDEXED) != 0u;
          command_event_active[COMMAND_INDEX_DISPATCH] |= (registration.command_types & COMMAND_TYPE_DISPATCH) != 0u;
          command_event_active[COMMAND_INDEX_INDIRECT] |= (registration.command_types & COMMAND_TYPE_INDIRECT) != 0u;
          command_event_active[COMMAND_INDEX_DISPATCH_MESH] |= (registration.command_types & COMMAND_TYPE_DISPATCH_MESH) != 0u;
        };
        for (const auto& shader_registrations : internal::shared.data->registrations) {
          for (const auto& registration : shader_registrations.second) {
            update_command_event_active(registration);
          }
        }
        internal::shared.RegisterEvent<reshade::addon_event::draw>(internal::OnDraw, command_event_active[COMMAND_INDEX_DRAW]);
        internal::shared.RegisterEvent<reshade::addon_event::draw_indexed>(internal::OnDrawIndexed, command_event_active[COMMAND_INDEX_DRAW_INDEXED]);
        internal::shared.RegisterEvent<reshade::addon_event::dispatch>(internal::OnDispatch, command_event_active[COMMAND_INDEX_DISPATCH]);
        internal::shared.RegisterEvent<reshade::addon_event::draw_or_dispatch_indirect>(internal::OnDrawOrDispatchIndirect, command_event_active[COMMAND_INDEX_INDIRECT]);
        internal::shared.RegisterEvent<reshade::addon_event::dispatch_mesh>(internal::OnDispatchMesh, command_event_active[COMMAND_INDEX_DISPATCH_MESH]);
      }
      break;
    case DLL_PROCESS_DETACH:
      internal::shared.UnregisterEvent<reshade::addon_event::draw>(internal::OnDraw);
      internal::shared.UnregisterEvent<reshade::addon_event::draw_indexed>(internal::OnDrawIndexed);
      internal::shared.UnregisterEvent<reshade::addon_event::dispatch>(internal::OnDispatch);
      internal::shared.UnregisterEvent<reshade::addon_event::draw_or_dispatch_indirect>(internal::OnDrawOrDispatchIndirect);
      internal::shared.UnregisterEvent<reshade::addon_event::dispatch_mesh>(internal::OnDispatchMesh);
      internal::shared.UnregisterModule();
      break;
  }
}

}  // namespace renodx::utils::command_action
