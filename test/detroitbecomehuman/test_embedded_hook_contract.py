#!/usr/bin/env python3

import argparse
import re
from pathlib import Path


def require(source: str, text: str) -> None:
    if text not in source:
        raise AssertionError(f"missing embedded hook contract: {text}")


def section(source: str, start: str, end: str) -> str:
    begin = source.index(start)
    return source[begin : source.index(end, begin)]


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--source-dir", type=Path, required=True)
    args = parser.parse_args()

    source_dir = args.source_dir
    source = (source_dir / "dlss" / "vulkan_layer.cpp").read_text(encoding="utf-8")
    adapter = (source_dir / "dlss" / "adapter_runtime.cpp").read_text(encoding="utf-8")
    adapter_header = (source_dir / "dlss" / "adapter_runtime.hpp").read_text(
        encoding="utf-8"
    )
    bootstrap = (source_dir / "dlss" / "embedded_bootstrap.hpp").read_text(
        encoding="utf-8"
    )
    temporal = (source_dir / "temporal_capture.hpp").read_text(encoding="utf-8")
    addon = (source_dir / "addon.cpp").read_text(encoding="utf-8")
    bridge = (source_dir / "dlss_bridge_client.hpp").read_text(encoding="utf-8")
    effects_addon = (
        source_dir.parent / "detroitbecomehuman-effects" / "addon.cpp"
    ).read_text(encoding="utf-8")
    cmake = (source_dir / "dlss" / "CMakeLists.txt").read_text(encoding="utf-8")

    # Bootstrap remains early so NGX extensions are present at device creation.
    for hook in (
        "HookCreateInstance",
        "HookGetInstanceProcAddr",
        "HookGetDeviceProcAddr",
    ):
        require(source, f"reinterpret_cast<PVOID>(&{hook})")
    for hook in ("HookCreateDevice", "HookDestroyInstance", "HookDestroyDevice"):
        require(source, f"return reinterpret_cast<PFN_vkVoidFunction>(&{hook});")
    require(source, "const auto downstream = reshade_get_device_proc_addr(device, name);")
    require(source, "if (const auto tracked = FindTrackedDeviceFunction(name); tracked != nullptr)")
    require(bootstrap, "inline constexpr bool kDlssRuntimeEnabled = true;")
    require(bootstrap, "return kDlssRuntimeEnabled;")

    # Ordinary Vulkan dispatch exposes only targeted DLAA/TAA snapshot hooks.
    tracked = section(
        source,
        "PFN_vkVoidFunction FindTrackedDeviceFunction(",
        "void DETROIT_DLSS_CALL BridgeShutdown",
    )
    tracked_names = re.findall(r'std::strcmp\(name, "([^"]+)"\)', tracked)
    if tracked_names != [
        "vkBeginCommandBuffer",
        "vkCmdBindDescriptorSets",
        "vkUpdateDescriptorSets",
        "vkCreateDescriptorUpdateTemplate",
        "vkCreateDescriptorUpdateTemplateKHR",
        "vkDestroyDescriptorUpdateTemplate",
        "vkDestroyDescriptorUpdateTemplateKHR",
        "vkUpdateDescriptorSetWithTemplate",
        "vkUpdateDescriptorSetWithTemplateKHR",
        "vkBindBufferMemory",
        "vkBindBufferMemory2",
        "vkBindBufferMemory2KHR",
        "vkMapMemory",
        "vkUnmapMemory",
        "vkDestroyBuffer",
        "vkFreeMemory",
    ]:
        raise AssertionError(f"unexpected production Vulkan wrappers: {tracked_names}")
    for forbidden in (
        "vkQueueSubmit",
        "vkQueueSubmit2",
        "vkQueueWaitIdle",
        "vkDeviceWaitIdle",
        "vkWaitForFences",
        "vkGetFenceStatus",
        "vkResetCommandBuffer",
        "vkCreateImage",
        "vkCreateBuffer",
        "vkAllocateMemory",
    ):
        if forbidden in tracked:
            raise AssertionError(f"global Vulkan wrapper escaped into production: {forbidden}")

    begin = section(
        source,
        "VKAPI_ATTR VkResult VKAPI_CALL LayerBeginCommandBuffer(",
        "VKAPI_ATTR VkResult VKAPI_CALL LayerResetCommandBuffer(",
    )
    require(begin, "fast_begin_command_buffer.load")
    require(begin, "GetCurrentThreadComputeCommandState()")
    require(begin, ".recording_generation = next_generation")
    for forbidden in ("tracking_mutex", "state->mutex", "adapter_runtime", "ngx_context"):
        if forbidden in begin:
            raise AssertionError(f"begin hot path must stay TLS-only: {forbidden}")

    bind = section(
        source,
        "VKAPI_ATTR void VKAPI_CALL LayerCmdBindDescriptorSets(",
        "[[maybe_unused]] PFN_vkVoidFunction FindLegacyTrackedDeviceFunction(",
    )
    require(bind, "fast_cmd_bind_descriptor_sets.load")
    require(bind, "dynamic_offset_count != 1u")
    require(bind, "local.constants_dynamic_offset = dynamic_offsets[0u]")
    require(bind, "local.descriptor_bound_after_begin = true")
    for forbidden in ("tracking_mutex", "state->mutex", "unordered_map"):
        if forbidden in bind:
            raise AssertionError(f"descriptor bind hot path must stay TLS-only: {forbidden}")

    update = section(
        source,
        "VKAPI_ATTR void VKAPI_CALL LayerUpdateDynamicConstantBufferDescriptorSets(",
        "VKAPI_ATTR VkResult VKAPI_CALL LayerBeginCommandBuffer(",
    )
    require(update, "fast_update_descriptor_sets.load")
    require(update, "GetCurrentDynamicDescriptorUpdateScope()")
    require(update, "const auto previous = current")
    require(update, "current = previous")
    for forbidden in ("tracking_mutex", "state->mutex", "unordered_map"):
        if forbidden in update:
            raise AssertionError(f"descriptor update hot path must stay TLS-only: {forbidden}")

    descriptor_template = section(
        source,
        "VKAPI_ATTR VkResult VKAPI_CALL LayerCreateDynamicDescriptorUpdateTemplate(",
        "VKAPI_ATTR VkResult VKAPI_CALL LayerObserveBindBufferMemory(",
    )
    for required in (
        "DETROIT_DLSS_TAA_CONSTANT_BINDING_52",
        "VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER_DYNAMIC",
        "descriptor_template_mutex",
        "template_descriptor_set = descriptor_set",
        ".descriptor_update_template = descriptor_update_template",
        ".template_data = descriptor_data",
        "current = previous",
    ):
        require(descriptor_template, required)
    for forbidden in ("tracking_mutex", "state->mutex", "queue_mutex"):
        if forbidden in descriptor_template:
            raise AssertionError(f"descriptor template observer is too broad: {forbidden}")
    template_update = section(
        source,
        "VKAPI_ATTR void VKAPI_CALL LayerUpdateDynamicDescriptorSetWithTemplate(",
        "VKAPI_ATTR VkResult VKAPI_CALL LayerObserveBindBufferMemory(",
    )
    for forbidden in (
        "descriptor_template_mutex",
        "dynamic_descriptor_templates.find",
        "tracking_mutex",
    ):
        if forbidden in template_update:
            raise AssertionError(f"non-b52 template update must stay lock-free: {forbidden}")

    mapped_memory = section(
        source,
        "VKAPI_ATTR VkResult VKAPI_CALL LayerObserveBindBufferMemory(",
        "VKAPI_ATTR void VKAPI_CALL LayerUpdateDynamicConstantBufferDescriptorSets(",
    )
    for required in (
        "narrow_buffer_bindings",
        "narrow_mapped_memories",
        "mapped_buffer_mutex",
        "LayerObserveFreeMemory",
    ):
        require(mapped_memory, required)
    for forbidden in ("tracking_mutex", "state->mutex", "queue_mutex"):
        if forbidden in mapped_memory:
            raise AssertionError(f"mapped-memory observer is too broad: {forbidden}")

    dynamic_binding = section(
        source,
        "bool GetCurrentDynamicConstantBufferBinding(",
        "bool ClaimCommandRecordingEvaluation(",
    )
    for validation in (
        "ToOpaque(current.device) != device",
        "ToOpaque(write.dstSet) != descriptor_set",
        "write.dstBinding != DETROIT_DLSS_TAA_CONSTANT_BINDING_52",
        "write.dstArrayElement != 0u",
        "write.descriptorCount != 1u",
        "write.descriptorType != VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER_DYNAMIC",
        "current.template_data != nullptr",
        "ToOpaque(current.template_descriptor_set) == descriptor_set",
        "state->dynamic_descriptor_templates.find",
        "state->narrow_buffer_bindings.find(buffer)",
        "state->narrow_mapped_memories.find",
    ):
        require(dynamic_binding, validation)

    metadata = section(source, "bool ReadCommandRecordingMetadata(", "class ThreadComputeCommandStates")
    for validation in (
        "!local.recording_active",
        "!local.descriptor_bound_after_begin",
        "local.recording_generation == 0u",
        "local.command_buffer != command_buffer",
        "ToOpaque(local.descriptor_layout) != pipeline_layout",
        "ToOpaque(local.descriptor_set) != descriptor_set",
        "claim_evaluation && local.evaluation_claimed",
    ):
        require(metadata, validation)

    restore = section(source, "bool CaptureComputeRestoreState(", "bool RestoreComputeCommandState(")
    require(restore, "ClaimCommandRecordingEvaluation(")
    require(restore, "metadata.constants_dynamic_offset")
    require(restore, "metadata.recording_generation")

    core_submit = section(source, "VkResult CoreSubmit(", "void UpdateFeatureTrackingStateLocked(")
    if "queue_mutex" in core_submit:
        raise AssertionError("private NGX submission must not serialize the game queue")

    # ReShade owns exact pipeline/table state and only seven descriptor bindings are retained.
    require(temporal, "kSparseBindings = {\n    1u, 3u, 4u, 5u, 7u, 16u, 52u}")
    require(temporal, "renodx::utils::state::GetCurrentState(context.cmd_list)")
    require(temporal, "ResolveSparseBindings(")
    require(temporal, "GetCurrentDynamicConstantBufferBinding(")
    require(temporal, "ReadPersistentlyMappedBufferRange(")
    require(temporal, "kStopAfterInputSnapshotForDiagnostic = true")
    require(temporal, "RuntimeStatus::kInputSnapshotReadyDiagnostic")
    require(temporal, "GetCommandRecordingMetadata(")
    require(temporal, "device->map_buffer_region(")
    require(temporal, "reshade::api::map_access::read_only")
    if temporal.count("map_buffer_region(") != 2:  # map + unmap spellings
        raise AssertionError("b52 must be mapped only by the targeted temporal callback")
    constants_capture = section(
        temporal,
        "[[nodiscard]] inline bool CaptureTemporalConstants(",
        "[[nodiscard]] inline ImageShape GetShape(",
    )
    if constants_capture.index("ReadPersistentlyMappedBufferRange(") > constants_capture.index(
        "device->map_buffer_region("
    ):
        raise AssertionError("persistent b52 mapping must be tried before a temporary remap")
    diagnostic_gate = section(
        temporal,
        "if constexpr (kStopAfterInputSnapshotForDiagnostic)",
        "const auto constants_size = constants_snapshot.descriptor_range",
    )
    require(diagnostic_gate, "kInputSnapshotReadyDiagnostic")
    if temporal.index("CaptureTemporalConstants(", temporal.index("AfterNativeTemporalDispatch(")) > temporal.index(
        "if constexpr (kStopAfterInputSnapshotForDiagnostic)"
    ):
        raise AssertionError("input diagnostic gate must run after b52 capture")
    if "CaptureTemporalSnapshot(" in temporal or "trace_descriptor_tables" in temporal:
        raise AssertionError("global descriptor snapshotting must stay disabled")
    for event in (
        "init_device",
        "destroy_device",
        "update_descriptor_tables",
        "copy_descriptor_tables",
    ):
        require(temporal, f"reshade::addon_event::{event}")

    temporal_dispatch = section(
        temporal, "inline void AfterNativeTemporalDispatch(", "struct TemporalDispatchCallback"
    )
    main_gate = temporal_dispatch.index("if (!IsMainTemporalCommandList(native_command_list))")
    state_lookup = temporal_dispatch.index("renodx::utils::state::GetCurrentState")
    fallback = temporal_dispatch.index("if (!snapshot_complete)")
    evaluate = temporal_dispatch.index("client.Evaluate(")
    if not main_gate < state_lookup < fallback < evaluate:
        raise AssertionError("incomplete or stale descriptor state must fall back before Evaluate")
    fallback_body = temporal_dispatch[fallback:evaluate]
    require(fallback_body, "RuntimeStatus::kDescriptorContractIncomplete")
    require(fallback_body, "return;")

    # Scratch retirement is tied to the feature-bearing command buffer only.
    require(adapter_header, "PollCompletedOneTimeCommandBuffers(")
    for procedure in (
        "vkCreateEvent",
        "vkDestroyEvent",
        "vkGetEventStatus",
        "vkResetEvent",
        "vkCmdSetEvent",
    ):
        require(adapter, procedure)
    poll = section(
        adapter,
        "std::size_t AdapterRuntime::PollCompletedOneTimeCommandBuffers(",
        "void AdapterRuntime::RecycleCommandBuffer(",
    )
    status = poll.index("!= VK_EVENT_SET")
    erase = poll.index("impl_->bundles.erase")
    if "!state.one_time_submit" not in poll or "!state.completion_pending" not in poll:
        raise AssertionError("only completed ONE_TIME_SUBMIT bundles may auto-recycle")
    if status >= erase:
        raise AssertionError("scratch was recycled before its completion event signaled")
    require(temporal, "dlss::embedded::RecycleFeatureCommandBuffer(cmd_list->get_native())")
    require(temporal, "dlss::embedded::RetireFeatureCommandBuffer(cmd_list->get_native())")

    destroy = section(
        source,
        "VKAPI_ATTR void VKAPI_CALL HookDestroyDevice(",
        "VKAPI_ATTR PFN_vkVoidFunction VKAPI_CALL HookGetDeviceProcAddr(",
    )
    require(destroy, "ForceShutdownNgxForDeviceDestroy(state.get())")
    require(destroy, "state->adapter_runtime.Shutdown(false)")
    require(destroy, 'reshade_get_device_proc_addr(device, "vkDestroyDevice")')

    # Retinal code stays in-tree, but saved Retinal mode is explicitly downgraded.
    require(addon, "if (dof_mode >= 2.5f)")
    require(addon, "dof_mode = 2.f")
    require(addon, "temporarily unavailable without global Vulkan interposition; using Cinematic")
    require(addon, '.labels = {"Vanilla", "Clean", "Cinematic"}')
    require(addon, "void ApplyRetinalDofFilter(")

    # The ABI and HDR/effects split remain unchanged.
    require(bridge, "provider_(DETROIT_DLSS_ABI_VERSION, &candidate)")
    require(effects_addon, "#define DETROIT_EFFECTS_ADDON")
    require(effects_addon, '#include "../detroitbecomehuman/addon.cpp"')
    require(cmake, "target_sources(detroitbecomehuman-effects PRIVATE")
    if "target_sources(detroitbecomehuman PRIVATE" in cmake:
        raise AssertionError("HDR Core must not acquire embedded Vulkan/DLSS sources")


if __name__ == "__main__":
    main()
