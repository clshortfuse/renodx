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
    temporal_mode_state = (source_dir / "temporal_mode_state.hpp").read_text(
        encoding="utf-8"
    )
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

    for removed in (
        "FindLegacyTrackedDeviceFunction",
        "LegacyCaptureNativeOutputTrackedState",
        "LegacyCaptureComputeRestoreState",
        "LegacyLayerCmdBindDescriptorSets",
        "VKAPI_ATTR VkResult VKAPI_CALL LayerQueueSubmit(",
        "VKAPI_ATTR VkResult VKAPI_CALL LayerResetCommandBuffer(",
        "VKAPI_ATTR VkResult VKAPI_CALL LayerCreateCommandPool(",
    ):
        if removed in source:
            raise AssertionError(f"unreachable Vulkan layer path was restored: {removed}")

    begin = section(
        source,
        "VKAPI_ATTR VkResult VKAPI_CALL LayerBeginCommandBuffer(",
        "VKAPI_ATTR void VKAPI_CALL LayerCmdBindDescriptorSets(",
    )
    require(begin, "fast_begin_command_buffer.load")
    require(begin, "RecycleFeatureCommandBuffer(ToOpaque(command_buffer))")
    require(begin, "GetCurrentThreadComputeCommandState()")
    require(begin, ".recording_generation = next_generation")
    if not (
        begin.index("const VkResult result = trampoline")
        < begin.index("RecycleFeatureCommandBuffer(ToOpaque(command_buffer))")
        < begin.index("GetCurrentThreadComputeCommandState()")
    ):
        raise AssertionError("feature resources must recycle only after a successful begin")
    for forbidden in ("tracking_mutex", "state->mutex", "adapter_runtime", "ngx_context"):
        if forbidden in begin:
            raise AssertionError(f"begin hot path must stay TLS-only: {forbidden}")

    bind = section(
        source,
        "VKAPI_ATTR void VKAPI_CALL LayerCmdBindDescriptorSets(",
        "PFN_vkVoidFunction FindTrackedDeviceFunction(",
    )
    require(bind, "fast_cmd_bind_descriptor_sets.load")
    require(bind, "runtime_command_tracking_enabled.load")
    require(bind, "dynamic_offset_count != 1u")
    require(bind, "local.constants_dynamic_offset = dynamic_offsets[0u]")
    require(bind, "local.descriptor_bound_after_begin = true")
    for forbidden in ("tracking_mutex", "state->mutex", "unordered_map"):
        if forbidden in bind:
            raise AssertionError(f"descriptor bind hot path must stay TLS-only: {forbidden}")
    if bind.index("runtime_command_tracking_enabled.load") > bind.index(
        "GetCurrentThreadComputeCommandState()"
    ):
        raise AssertionError("native descriptor bind must return before touching TLS state")

    begin_recording = section(
        temporal_mode_state,
        "void BeginRecording(std::uint64_t command_list)",
        "void DiscardCommandList(std::uint64_t command_list)",
    )
    require(begin_recording, "authorization_command_lists_.Contains(command_list)")
    if begin_recording.index("authorization_command_lists_.Contains") > begin_recording.index(
        "std::scoped_lock lock(mutex_)"
    ):
        raise AssertionError("ordinary command-list reset must bypass the mode-state mutex")

    for lifecycle in (
        section(
            source,
            "void RecycleFeatureCommandBuffer(std::uint64_t command_buffer)",
            "void RetireFeatureCommandBuffer(std::uint64_t command_buffer)",
        ),
        section(
            source,
            "void RetireFeatureCommandBuffer(std::uint64_t command_buffer)",
            "bool AttachEarlyHooks(",
        ),
    ):
        require(lifecycle, "FindDeviceFast(native)")
        require(lifecycle, "MayBeFeatureRecordingCandidate(*state, native)")
        if "FindDeviceSharedFast(native)" in lifecycle:
            raise AssertionError("ordinary lifecycle callbacks must not copy shared ownership")

    recording_metadata = section(
        source,
        "bool ReadCommandRecordingMetadata(",
        "class ThreadComputeCommandStates final",
    )
    for required in (
        "local.command_buffer != command_buffer",
        "local.descriptor_layout == VK_NULL_HANDLE",
        "local.descriptor_set == VK_NULL_HANDLE",
        "claim_evaluation",
        "pipeline_layout == 0u || descriptor_set == 0u",
        "pipeline_layout != 0u",
        "descriptor_set != 0u",
        ".pipeline_layout = ToOpaque(local.descriptor_layout)",
        ".descriptor_set = ToOpaque(local.descriptor_set)",
    ):
        require(recording_metadata, required)
    metadata_getter = section(
        source,
        "bool GetCommandRecordingMetadata(",
        "bool GetCurrentDynamicConstantBufferBinding(",
    )
    require(metadata_getter, "command_buffer,\n      0u,\n      0u,\n      false")
    metadata_claim = section(
        source,
        "bool ClaimCommandRecordingEvaluation(",
        "void RecycleFeatureCommandBuffer(",
    )
    require(
        metadata_claim,
        "command_buffer,\n      pipeline_layout,\n      descriptor_set,\n      true",
    )

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
    unmap_memory = section(
        source,
        "VKAPI_ATTR void VKAPI_CALL LayerObserveUnmapMemory(",
        "VKAPI_ATTR void VKAPI_CALL LayerObserveDestroyBuffer(",
    )
    require(unmap_memory, "mapped->second.pointer = nullptr;")
    if "narrow_mapped_memories.erase" in unmap_memory:
        raise AssertionError("unmap must retain a tombstone for bounded b52 diagnostics")

    for required in (
        "enum class MappedBufferReadDetail",
        "kBufferBindingMissing",
        "kMappedMemoryMissing",
        "kMappedPointerMissing",
        "kMappedRangeExceeded",
        "struct MappedBufferReadDiagnostics",
        "MappedBufferReadDiagnostics* diagnostics = nullptr",
    ):
        require(bootstrap, required)

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
        "diagnostics->tracked_buffer_count",
        "diagnostics->tracked_memory_count",
        "MappedBufferReadDetail::kBufferBindingMissing",
        "MappedBufferReadDetail::kMappedMemoryMissing",
        "MappedBufferReadDetail::kMappedPointerMissing",
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

    # The narrow Vulkan TLS owns exact pipeline/table identity. ReShade retains
    # only the seven descriptor bindings needed by the temporal callback.
    require(temporal, "kSparseBindings = {\n    1u, 3u, 4u, 5u, 7u, 16u, 52u}")
    if "utils::state" in temporal or "state::Use" in temporal:
        raise AssertionError("Detroit temporal capture must not attach global ReShade state tracking")
    require(
        temporal,
        "using Vulkan TLS command metadata; global ReShade state tracking is disabled.",
    )
    require(temporal, "ResolveSparseBindings(")
    require(temporal, "recording.pipeline_layout")
    require(temporal, "recording.descriptor_set")
    require(temporal, "GetCurrentDynamicConstantBufferBinding(")
    require(temporal, "ReadPersistentlyMappedBufferRange(")
    require(temporal, "kStopBeforeBridgeEvaluateForDiagnostic = false")
    require(temporal, "RuntimeStatus::kBridgeInputReadyDiagnostic")
    require(temporal, "bridge_input_ready_diagnostic_reached")
    require(temporal, "kMaximumSnapshotDiagnosticLogs = 16u")
    require(temporal, "kMaximumBridgeDiagnosticAttempts = 3u")
    require(temporal, "TAA snapshot state {}:")
    require(temporal, "DLSS client trace attempt={} event=input")
    require(temporal, "DLSS client trace attempt={} event=resource")
    require(temporal, "DLSS client trace attempt={} event=constants")
    require(temporal, "DLSS client trace attempt={} event=result")
    require(temporal, "bridge boundary reached before Configure/Evaluate")
    require(bridge, "struct EvaluationDiagnostics")
    require(bridge, "EvaluationStageName(")
    require(bridge, "EvaluationDiagnostics* diagnostics = nullptr")
    require(source, 'L"DetroitDLSSTraceFirstThree"')
    require(source, "const bool first_three =")
    if "const bool first_three = true;" in source:
        raise AssertionError("DLSS first-three tracing must remain opt-in")
    require(source, "TraceEvaluationMessage(")
    require(source, "event=bridge_input")
    require(source, "event=invalid_frame failed_mask=")
    for phase in (
        "capture_restore_state",
        "native_output_state",
        "ensure_ngx_initialized",
        "configure_feature",
        "adapter_prepare",
        "ngx_evaluate",
        "adapter_commit",
        "restore_compute_state",
    ):
        require(source, f'TraceEvaluationPhase(trace_record, "{phase}"')
    require(temporal, "GetCommandRecordingMetadata(")
    require(temporal, "device->map_buffer_region(")
    require(temporal, "reshade::api::map_access::read_only")
    if temporal.count("map_buffer_region(") != 2:  # map + unmap spellings
        raise AssertionError("b52 must be mapped only by the targeted temporal callback")
    sparse_update = section(
        temporal,
        "inline bool OnUpdateSparseDescriptorTables(",
        "inline bool OnCopySparseDescriptorTables(",
    )
    sparse_copy = section(
        temporal,
        "inline bool OnCopySparseDescriptorTables(",
        "[[nodiscard]] inline bool ResolveSparseBindings(",
    )
    for operation in (sparse_update, sparse_copy):
        require(operation, "table.epoch = epoch;")
        if "table = {};" in operation:
            raise AssertionError(
                "partial descriptor writes must preserve unchanged sparse bindings"
            )
    constants_capture = section(
        temporal,
        "[[nodiscard]] inline bool CaptureTemporalConstants(",
        "[[nodiscard]] inline ImageShape GetShape(",
    )
    if constants_capture.index("ReadPersistentlyMappedBufferRange(") > constants_capture.index(
        "device->map_buffer_region("
    ):
        raise AssertionError("persistent b52 mapping must be tried before a temporary remap")
    for required in (
        "TemporalConstantsCaptureDiagnostics* diagnostics",
        'return fail("remap_failed")',
        'return fail("remap_pointer_missing")',
        '"persistent_mapping" : "temporary_remap"',
    ):
        require(constants_capture, required)
    required_images = section(
        temporal,
        "const bool required_images_complete =",
        "constants_captured =",
    )
    for required in (
        "sampled[1u].valid",
        "sampled[3u].valid",
        "sampled[4u].valid",
        "storage[0u].valid",
    ):
        require(required_images, required)
    for optional in ("sampled[5u].valid", "sampled[7u].valid"):
        if optional in required_images:
            raise AssertionError(f"optional TAA image became a DLSS prerequisite: {optional}")
    require(temporal, "snapshot_complete = required_images_complete && constants_captured;")
    require(temporal, ".reset = frame_parameters.reset,")
    if "|| !native_history_resources_available" in temporal:
        raise AssertionError("missing optional b7 must not reset DLSS history every frame")
    sparse_resolution = section(
        temporal,
        "[[nodiscard]] inline bool ResolveSparseBindings(",
        "[[nodiscard]] inline std::uint32_t ToVulkanFormat(",
    )
    if sparse_resolution.index("if (epoch != nullptr) *epoch = snapshot.epoch") > sparse_resolution.index(
        "return complete"
    ):
        raise AssertionError("incomplete sparse snapshots must expose their epoch for diagnostics")
    if sparse_resolution.index("assign(52u, &output->constants)") > sparse_resolution.index("return complete"):
        raise AssertionError("incomplete sparse snapshots must expose their slot mask for diagnostics")
    after_temporal_dispatch = temporal[temporal.index("inline void AfterNativeTemporalDispatch(") :]
    snapshot_logging = section(
        after_temporal_dispatch,
        "if (last_logged_snapshot_diagnostic_key.exchange(",
        "if (!snapshot_complete)",
    )
    require(snapshot_logging, "if (log_index < kMaximumSnapshotDiagnosticLogs)")
    require(snapshot_logging, "TAA b52 capture {}:")
    diagnostic_gate = section(
        after_temporal_dispatch,
        "if constexpr (kStopBeforeBridgeEvaluateForDiagnostic)",
        "std::optional<dlss_bridge_client::EvaluationDiagnostics>",
    )
    require(diagnostic_gate, "kBridgeInputReadyDiagnostic")
    require(diagnostic_gate, "bridge_input_ready_diagnostic_reached.store(true")
    if after_temporal_dispatch.index("DetroitDlssTemporalFrameInputs inputs") > after_temporal_dispatch.index(
        "if constexpr (kStopBeforeBridgeEvaluateForDiagnostic)"
    ):
        raise AssertionError("bridge diagnostic gate must run after frame input construction")
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
    metadata_lookup = temporal_dispatch.index("GetCommandRecordingMetadata(")
    sparse_lookup = temporal_dispatch.index("ResolveSparseBindings(")
    fallback = temporal_dispatch.index("if (!snapshot_complete)")
    evaluate = temporal_dispatch.index("client.Evaluate(")
    if not main_gate < metadata_lookup < sparse_lookup < fallback < evaluate:
        raise AssertionError("incomplete or stale descriptor state must fall back before Evaluate")
    require(
        temporal_dispatch,
        "recording_metadata_available && has_pipeline_layout && has_descriptor_set",
    )
    fallback_body = temporal_dispatch[fallback:evaluate]
    require(fallback_body, "RuntimeStatus::kDescriptorContractIncomplete")
    require(fallback_body, "return;")
    snapshot_failure = section(
        temporal_dispatch,
        "if (!snapshot_complete)",
        "const auto constants_size = constants_snapshot.descriptor_range",
    )
    if "contract_mutex" in snapshot_failure:
        raise AssertionError("snapshot diagnostic fallback must not take the contract mutex")

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
    completion = section(adapter, "void RecordCompletion(", "bool ValidateDispatchDimensions(")
    require(completion, "VK_PIPELINE_STAGE_ALL_COMMANDS_BIT")
    if "VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT" in completion:
        raise AssertionError("completion event must cover every stage recorded by NGX")
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
    require(temporal, "dlss::embedded::RetireFeatureCommandBuffer(command_list)")

    destroy_command_list = section(
        temporal,
        "inline void OnDestroyTemporalCommandList(",
        "inline void OnResetTemporalCommandList(",
    )
    require(destroy_command_list, "main_temporal_command_lists.erase(command_list)")
    require(destroy_command_list, "mode_state.DiscardCommandList(command_list)")
    reset_command_list = section(
        temporal,
        "inline void OnResetTemporalCommandList(",
        "[[nodiscard]] inline std::uint64_t MixTelemetryKey(",
    )
    require(reset_command_list, "ClearObservedTemporalCommandList(command_list)")
    if "RecycleFeatureCommandBuffer" in reset_command_list:
        raise AssertionError("ReShade reset callback runs before downstream vkBeginCommandBuffer")

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
