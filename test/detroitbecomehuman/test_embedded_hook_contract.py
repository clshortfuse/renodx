#!/usr/bin/env python3

import argparse
from pathlib import Path
import re


def require(source: str, text: str) -> None:
    if text not in source:
        raise AssertionError(f"missing embedded hook contract: {text}")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--source-dir", type=Path, required=True)
    args = parser.parse_args()
    source = (args.source_dir / "dlss" / "vulkan_layer.cpp").read_text(encoding="utf-8")
    addon = (args.source_dir / "addon.cpp").read_text(encoding="utf-8")
    effects_addon = (
        args.source_dir.parent / "detroitbecomehuman-effects" / "addon.cpp"
    ).read_text(encoding="utf-8")
    cmake = (args.source_dir / "dlss" / "CMakeLists.txt").read_text(encoding="utf-8")
    bridge = (args.source_dir / "dlss_bridge_client.hpp").read_text(encoding="utf-8")
    policy = (args.source_dir / "dlss_policy.hpp").read_text(encoding="utf-8")
    temporal = (args.source_dir / "temporal_capture.hpp").read_text(encoding="utf-8")
    bootstrap = (args.source_dir / "dlss" / "embedded_bootstrap.hpp").read_text(
        encoding="utf-8"
    )
    feature_registry = (
        args.source_dir / "dlss" / "feature_recording_registry.hpp"
    ).read_text(encoding="utf-8")
    temporal_shader = (args.source_dir / "temporal_aux.comp.vk.glsl").read_text(
        encoding="utf-8"
    )
    command_action = (
        args.source_dir.parent.parent / "utils" / "command_action.hpp"
    ).read_text(encoding="utf-8")
    shader_mod = (
        args.source_dir.parent.parent / "mods" / "shader.hpp"
    ).read_text(encoding="utf-8")

    for hook in (
        "HookCreateInstance",
        "HookGetInstanceProcAddr",
        "HookGetDeviceProcAddr",
    ):
        require(source, f"reinterpret_cast<PVOID>(&{hook})")
    require(source, "const auto downstream = reshade_get_instance_proc_addr(instance, name);")
    require(source, "const auto downstream = reshade_get_device_proc_addr(device, name);")
    require(source, "if (const auto tracked = FindTrackedDeviceFunction(name); tracked != nullptr)")
    require(source, "return downstream;")
    require(source, "CreateInternalFeatureFence(state, snapshot)")
    require(source, "feature_command_buffer_bloom")
    require(source, "published_command_buffer_bloom")
    require(source, "feature_recording_candidates")
    require(source, "feature_evaluation_active")
    require(source, "feature_submission_tracking_active")
    require(source, "feature_lifecycle_tracking_active")
    require(feature_registry, "class FeatureRecordingRegistry final")
    require(feature_registry, "std::array<Slot, Capacity>")
    require(feature_registry, "recording_epoch")
    require(feature_registry, "bool Matches(")
    require(feature_registry, "bool EraseIfMatches(")
    require(feature_registry, "bool MarkSubmittedIfMatches(")
    require(feature_registry, "bool AnyRequiresSubmissionTracking()")
    require(feature_registry, "overflowed_.store(true, std::memory_order_release)")
    require(source, "kMaximumAdapterScratchBundles = 8u")
    require(
        source,
        "kMaximumFeatureRecordingCandidates =\n"
        "    kMaximumAdapterScratchBundles * 2u",
    )
    require(source, ".maximum_scratch_bundles = static_cast<std::uint32_t>(\n"
                    "          kMaximumAdapterScratchBundles)")
    require(source, "tracked_descriptor_set_bloom")
    if "temporal_descriptor_set_bloom" in source or "dof_composite_descriptor_set_bloom" in source:
        raise AssertionError(
            "descriptor hot path must use one false-positive-only candidate filter"
        )
    require(source, "FindDeviceSharedFast(")
    require(source, "active_device_identity")
    active_check_start = source.index("bool IsActiveDevice(")
    active_check_end = source.index("bool ReadCachedNgxExtensions(", active_check_start)
    active_check = source[active_check_start:active_check_end]
    require(active_check, "active_device_identity.load(std::memory_order_acquire)")
    if "state_mutex" in active_check:
        raise AssertionError("per-frame active-device check must remain lock-free")
    require(source, "AppendFeatureSubmissionCandidate(")
    require(source, "fence == VK_NULL_HANDLE && !snapshot.Empty()")
    require(source, "PollCompletedInternalFeatureFences(state.get())")
    require(source, "state->next_get_fence_status(state->device, fence)")
    require(source, "submission->second.owned_by_layer")
    require(source, "CompleteFeatureDevice(state.get());")
    require(source, "available_internal_feature_fences")
    require(source, "RecycleInternalFeatureFence(state, fence)")
    require(source, "DestroyInternalFeatureFencePool(state.get())")
    require(source, "VK_ACCESS_SHADER_WRITE_BIT")
    require(source, "VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT")
    require(source, "runtime_command_tracking_enabled")
    require(source, "void SetRuntimeCommandTracking(bool enabled)")
    require(source, "bootstrap_status_revision.fetch_add")
    require(bootstrap, "std::uint64_t GetStatusRevision();")
    require(command_action, "std::deque<std::vector<PendingPostResult>>")
    require(command_action, "pending_post_result_frames")
    require(command_action, "pending_post_result_depth")
    require(command_action, "PendingPostResultFrameGuard")
    if "static thread_local std::vector<PendingPostResult> pending_post_results" in command_action:
        raise AssertionError(
            "post callbacks must not share one vector across reentrant commands"
        )
    require(bootstrap, "inline constexpr bool kDlssRuntimeEnabled = true;")
    require(bootstrap, "return kDlssRuntimeEnabled || retinal_dof_requested;")
    require(
        bootstrap,
        "return mode != DETROIT_DLSS_MODE_NATIVE || retinal_dof_requested;",
    )
    require(
        source,
        "Targeted Vulkan command hooks installed with mode-gated tracking",
    )
    if re.search(
        r'\.labels\s*=\s*\{\s*"Native TAA"\s*,\s*"DLAA"\s*\}',
        addon,
    ) is None:
        raise AssertionError("AA mode UI must expose exactly Native TAA and DLAA")
    for removed_label in (
        '"DLSS Quality"',
        '"DLSS Balanced"',
        '"DLSS Performance"',
    ):
        if removed_label in addon:
            raise AssertionError(
                f"legacy SR option must not be exposed in the UI: {removed_label}"
            )
    for removed_scale_contract in (
        "IsSuperResolutionMode",
        "resolution_scale_controller",
        "dlss_scale_transition_controller",
        "ApplyDlssRenderScale",
        "RestoreNativeRenderScale",
        '"DLSSRenderScale"',
        '"DLSSRenderScaleStatus"',
    ):
        if removed_scale_contract in addon or removed_scale_contract in temporal:
            raise AssertionError(
                "DLAA-only runtime retained an SR/scale contract: "
                + removed_scale_contract
            )
    require(policy, "NormalizeDlssMode(")
    require(policy, "ParsePersistedDlssMode(")
    require(addon, "dlss_policy::ParsePersistedDlssMode(")
    require(addon, "if (!embedded_dlss::kDlssRuntimeEnabled)")
    require(temporal_shader, "imageStore(OutAADepth")
    require(temporal_shader, "imageStore(OutPrevSpeedAndFlagsTex")
    require(temporal_shader, "imageStore(HalfResContours")
    require(temporal_shader, "vec2 _1740 = _1589 - _1705;")
    if temporal_shader.count("_fJitterCoordX") != 1 or temporal_shader.count(
        "_fJitterCoordY"
    ) != 1:
        raise AssertionError(
            "native TAA history lookup must not apply b52 jitter separately from b4"
        )
    if "DlssTemporalReplacementActive" in temporal_shader:
        raise AssertionError("DLAA must retain Detroit's b17-b19 history outputs")

    tracked_function_start = source.index("PFN_vkVoidFunction FindTrackedDeviceFunction(")
    tracked_function_end = source.index("void DETROIT_DLSS_CALL BridgeShutdown", tracked_function_start)
    tracked_function = source[tracked_function_start:tracked_function_end]
    for command_bind in ("vkCmdBindPipeline", "vkCmdBindDescriptorSets"):
        require(
            tracked_function,
            'native_command_hooks_installed.load(std::memory_order_acquire)\n'
            f'      && std::strcmp(name, "{command_bind}") == 0',
        )

    snapshot_start = source.index("BridgeGetTemporalSnapshot(")
    snapshot_end = source.index("BridgeQueryMode(", snapshot_start)
    snapshot_capture = source[snapshot_start:snapshot_end]
    require(snapshot_capture, "ResolveExpectedTemporalDescriptorSetLocked(")
    if "ResolveLatestTemporalDescriptorUpdateLocked(" in source:
        raise AssertionError(
            "temporal capture must not substitute descriptor-update recency for "
            "the exact command-buffer binding"
        )
    require(
        snapshot_capture,
        "if (expected_descriptor_set == 0u || expected_pipeline_layout == 0u)",
    )
    require(snapshot_capture, "ResolveChangedTemporalConstantsSlotLocked(")
    require(snapshot_capture, "FillTemporalConstantsForBindingLocked(")
    slot_scan_start = source.index("ResolveChangedTemporalConstantsSlotLocked(")
    slot_scan_end = snapshot_start
    slot_scan = source[slot_scan_start:slot_scan_end]
    require(slot_scan, "temporal_slot_scratch_offsets")
    require(slot_scan, "temporal_slot_scratch_hashes")
    require(slot_scan, "buffer.temporal_slot_offsets.swap(offsets)")
    require(slot_scan, "buffer.temporal_slot_hashes.swap(hashes)")
    changed_hash_gate = slot_scan.index(
        "else if (hash != buffer.temporal_slot_hashes[slot_index])"
    )
    decode_constants = slot_scan.index("DecodeConstants(")
    if changed_hash_gate >= decode_constants:
        raise AssertionError(
            "unchanged temporal slots must bypass constants decode and validation"
        )
    if "std::vector<bool>" in slot_scan:
        raise AssertionError("temporal slot scan must reuse persistent scratch storage")
    require(
        temporal,
        "CaptureTemporalSnapshot(\n"
        "          context.cmd_list->get_native(),\n"
        "          0u,",
    )
    for removed_global_bind_path in (
        "OnBindTemporalDescriptorTables(",
        "addon_event::bind_descriptor_tables",
        "GetTemporalDescriptorBinding(",
        "temporal_descriptor_binding_tracking_epoch",
    ):
        if removed_global_bind_path in temporal:
            raise AssertionError(
                "Native TAA must not retain the global ReShade descriptor-bind path: "
                + removed_global_bind_path
            )
    reset_callback_start = temporal.index("OnResetTemporalCommandList(")
    reset_callback_end = temporal.index(
        "MixTelemetryKey(", reset_callback_start
    )
    reset_callback = temporal[reset_callback_start:reset_callback_end]
    reset_native_gate = reset_callback.index(
        "temporal_mode_state::CanUseNativeModeFastPath(mode_state.GetMode())"
    )
    reset_authorization = reset_callback.index("mode_state.BeginRecording(")
    if not reset_native_gate < reset_authorization:
        raise AssertionError(
            "DLAA recording authorization must reset after the Native fast gate"
        )
    context_start = source.index("BridgeGetContext(")
    context_end = source.index("BridgeGetTemporalConstants(", context_start)
    context = source[context_start:context_end]
    require(context, "DETROIT_DLSS_CAPABILITY_DLAA")
    for removed_capability in (
        "DETROIT_DLSS_CAPABILITY_SUPER_RESOLUTION",
        "DETROIT_DLSS_CAPABILITY_RENDER_SCALE_CONTROL",
    ):
        if removed_capability in context:
            raise AssertionError(
                "DLAA-only bridge must not advertise " + removed_capability
            )
    query_mode_start = snapshot_end
    query_mode_end = source.index("BridgeConfigure(", query_mode_start)
    query_mode = source[query_mode_start:query_mode_end]
    require(query_mode, "DETROIT_DLSS_CREATE_MOTION_VECTORS_JITTERED")
    exact_query_gate = (
        "if (mode != DETROIT_DLSS_MODE_NATIVE\n"
        "      && mode != DETROIT_DLSS_MODE_DLAA)"
    )
    require(query_mode, exact_query_gate)
    legacy_query_gate = query_mode.index(exact_query_gate)
    query_device_lookup = query_mode.index("const auto state = GetActiveDevice()")
    query_ngx = query_mode.index("EnsureNgxInitialized(state.get())")
    if not legacy_query_gate < query_device_lookup < query_ngx:
        raise AssertionError(
            "legacy SR mode queries must fail before device and NGX work"
        )
    configure_start = query_mode_end
    configure_end = source.index(
        "DetroitDlssResultCode DETROIT_DLSS_CALL BridgeEvaluate",
        configure_start,
    )
    configure = source[configure_start:configure_end]
    exact_configure_gate = (
        "if (settings->mode != DETROIT_DLSS_MODE_NATIVE\n"
        "      && settings->mode != DETROIT_DLSS_MODE_DLAA)"
    )
    require(configure, exact_configure_gate)
    legacy_configure_gate = configure.index(exact_configure_gate)
    legacy_configure = configure[legacy_configure_gate:]
    retire_feature = legacy_configure.index("RetireActiveFeatureLocked(state.get())")
    clear_configured = legacy_configure.index("state->configured = false")
    return_fallback = legacy_configure.index("return DETROIT_DLSS_RESULT_FALLBACK")
    if not retire_feature < clear_configured < return_fallback:
        raise AssertionError(
            "legacy SR configure must retire the feature and clear state before fallback"
        )
    require(source, "pipeline_layout->second.set_layouts.size() != 1u")
    if "InstallTargetedTemporalCommandStateLocked" in source:
        raise AssertionError(
            "targeted snapshots must not persist a rotating b52 offset as command state"
        )

    restore_capture_start = source.index("CaptureComputeRestoreState(")
    restore_capture_end = source.index("RestoreComputeCommandState(", restore_capture_start)
    restore_capture = source[restore_capture_start:restore_capture_end]
    require(restore_capture, "ComputeCommandRestoreState* restore")
    require(restore_capture, "restore->descriptor_sets.assign(")
    require(restore_capture, "restore->dynamic_offsets.assign(")
    require(restore_capture, "command_usage == state->command_buffer_usage_flags.end()")
    require(restore_capture, "command_generation->second == 0u")
    require(source, "ComputeCommandRestoreState evaluation_restore_state;")

    publish_start = source.index("bool PublishThreadCommandRecordingLocked(")
    publish_end = source.index("void MarkFeatureRecordingCandidateLocked(", publish_start)
    publish_recording = source[publish_start:publish_end]
    for publication_step in (
        "!local->recording_active",
        "state->next_recording_generation++",
        "state->command_buffer_usage_flags[command_buffer] = local->begin_flags",
        "state->command_buffer_recording_generations[command_buffer] =",
        "state->published_command_buffer_bloom.fetch_or(",
    ):
        require(publish_recording, publication_step)

    snapshot_start = source.index("BridgeGetTemporalSnapshot(")
    snapshot_end = source.index("BridgeQueryMode(", snapshot_start)
    temporal_snapshot = source[snapshot_start:snapshot_end]
    local_recording = temporal_snapshot.index("GetThreadComputeCommandStates().Find(")
    snapshot_lock = temporal_snapshot.index("state->tracking_mutex")
    publish_snapshot = temporal_snapshot.index("PublishThreadCommandRecordingLocked(")
    if not local_recording < snapshot_lock < publish_snapshot:
        raise AssertionError(
            "temporal snapshots must fail before the shared lock and publish only "
            "the selected command buffer under that lock"
        )
    require(temporal_snapshot, "DETROIT_DLSS_SNAPSHOT_DETAIL_COMMAND_UNTRACKED")

    descriptor_update_start = source.index("LayerUpdateDescriptorSets(")
    descriptor_update_end = source.index("LayerCreateImage(", descriptor_update_start)
    descriptor_update = source[descriptor_update_start:descriptor_update_end]
    require(descriptor_update, "MayBeTrackedDescriptorSet(")
    require(descriptor_update, "may_touch_tracked_set = true;")
    require(descriptor_update, "break;")

    begin_start = source.index("LayerBeginCommandBuffer(")
    begin_end = source.index("LayerResetCommandBuffer(", begin_start)
    begin_command_buffer = source[begin_start:begin_end]
    require(begin_command_buffer, "if (result == VK_SUCCESS)")
    require(begin_command_buffer, "MayBeFeatureRecordingCandidate(")
    require(begin_command_buffer, "GetThreadComputeCommandStates().BeginRecording(")
    published_begin_gate = begin_command_buffer.index(
        "if (MayHavePublishedCommandBufferState("
    )
    begin_tracking_lock = begin_command_buffer.index("state->tracking_mutex")
    if published_begin_gate >= begin_tracking_lock:
        raise AssertionError(
            "ordinary command-buffer begin must bypass the shared tracking mutex"
        )
    if (
        "state->command_buffer_usage_flags[" in begin_command_buffer
        or "state->next_recording_generation++" in begin_command_buffer
    ):
        raise AssertionError(
            "ordinary begin metadata must stay thread-local until a temporal/DOF selection"
        )
    feature_gate = begin_command_buffer.index("if (may_have_feature_recording)")
    adapter_begin = begin_command_buffer.index(
        "state->adapter_runtime.NotifyCommandBufferBegin(command_buffer)"
    )
    ngx_begin = begin_command_buffer.index("state->ngx_context->BeginRecording(")
    if feature_gate >= adapter_begin or feature_gate >= ngx_begin:
        raise AssertionError(
            "non-feature command buffers must bypass adapter and NGX lifecycle locks"
        )
    unmark_begin = begin_command_buffer.index(
        "UnmarkFeatureRecordingCandidateLocked("
    )
    if adapter_begin >= unmark_begin or ngx_begin >= unmark_begin:
        raise AssertionError(
            "a successful begin must release adapter/NGX ownership before "
            "removing the exact feature candidate"
        )

    mark_candidate_start = source.index("void MarkFeatureRecordingCandidateLocked(")
    candidate_start = source.index("bool MayBeFeatureRecordingCandidate(")
    mark_candidate = source[mark_candidate_start:candidate_start]
    exact_insert = mark_candidate.index("feature_recording_candidates.Insert(")
    bloom_publish = mark_candidate.index("feature_command_buffer_bloom.fetch_or(")
    if exact_insert >= bloom_publish or "return" in mark_candidate[exact_insert:bloom_publish]:
        raise AssertionError(
            "registry overflow must still publish the candidate Bloom bit"
        )
    candidate_end = source.index(
        "void UnmarkFeatureRecordingCandidateLocked(", candidate_start
    )
    candidate_filter = source[candidate_start:candidate_end]
    lifecycle_gate = candidate_filter.index(
        "feature_lifecycle_tracking_active.load"
    )
    bloom_miss = candidate_filter.index("CommandBufferBloomBit(handle)")
    exact_lookup = candidate_filter.index(
        "feature_recording_candidates.Contains(handle)"
    )
    if not lifecycle_gate < bloom_miss < exact_lookup:
        raise AssertionError(
            "lifecycle inactivity and Bloom misses must precede exact registry lookup"
        )
    require(candidate_filter, "feature_recording_candidates.Overflowed()")

    tracking_state_start = source.index("void UpdateFeatureTrackingStateLocked(")
    tracking_state_end = source.index("bool EnsureNgxInitialized(", tracking_state_start)
    tracking_state = source[tracking_state_start:tracking_state_end]
    require(tracking_state, "ActiveFeatureGeneration() != 0u")
    require(tracking_state, ".AnyRequiresSubmissionTracking()")
    require(
        tracking_state,
        "feature_submission_tracking_active.store(\n"
        "      requires_submission_tracking, std::memory_order_release)",
    )
    require(
        tracking_state,
        "feature_lifecycle_tracking_active.store(\n"
        "      has_lifecycle_candidates, std::memory_order_release)",
    )
    if "feature_submission_tracking_active.store(\n      has_features" in tracking_state:
        raise AssertionError(
            "retired NGX features must not keep every queue submit on the tracking path"
        )

    commit_start = source.index("void CommitFeatureSubmission(")
    commit_end = source.index("void CompleteFeatureQueue(", commit_start)
    commit = source[commit_start:commit_end]
    submitted_match = commit.index(
        "feature_recording_candidates.MarkSubmittedIfMatches("
    )
    refresh_tracking = commit.index("UpdateFeatureTrackingStateLocked(state)")
    if submitted_match >= refresh_tracking:
        raise AssertionError(
            "successful submission must clear exact pending-submit state before "
            "refreshing the fast-path gate"
        )

    retired_poll_start = source.index("void PollRetiredFeatureFencesOnQueueSubmit(")
    retired_poll_end = source.index("void RecycleInternalFeatureFence(", retired_poll_start)
    retired_poll = source[retired_poll_start:retired_poll_end]
    require(retired_poll, "feature_evaluation_active.load(")
    require(retired_poll, "internal_feature_fences_pending.load(")
    require(retired_poll, "retired_feature_fence_poll_serial.fetch_add(")
    require(retired_poll, "PollCompletedInternalFeatureFences(state)")
    if retired_poll.index("internal_feature_fences_pending.load(") >= retired_poll.index(
        "feature_evaluation_active.load("
    ):
        raise AssertionError(
            "stable Native queue submission must stop after one pending-fence atomic load"
        )
    if source.count("PollRetiredFeatureFencesOnQueueSubmit(") != 4:
        raise AssertionError(
            "retired one-time fences must drain through every queue-submit entry point"
        )
    unfenced_fallback_start = source.index(
        "void CompleteUnfencedFeatureSubmissionFallback("
    )
    unfenced_fallback_end = source.index(
        "void RecycleInternalFeatureFence(", unfenced_fallback_start
    )
    unfenced_fallback = source[unfenced_fallback_start:unfenced_fallback_end]
    required_gate = unfenced_fallback.index("!internal_fence_required")
    missing_fence_gate = unfenced_fallback.index(
        "internal_fence != VK_NULL_HANDLE"
    )
    successful_submit_gate = unfenced_fallback.index(
        "submit_result != VK_SUCCESS"
    )
    queue_wait = unfenced_fallback.index("state->next_queue_wait_idle(queue)")
    complete_queue = unfenced_fallback.index("CompleteFeatureQueue(state, queue)")
    if not (
        required_gate
        < missing_fence_gate
        < successful_submit_gate
        < queue_wait
        < complete_queue
    ):
        raise AssertionError(
            "missing private fences must synchronously retire only successful "
            "required submissions"
        )
    if source.count("CompleteUnfencedFeatureSubmissionFallback(") != 4:
        raise AssertionError(
            "all three queue-submit entry points must cover private-fence creation failure"
        )
    for submit_hook, submit_end in (
        ("LayerQueueSubmit(", "LayerQueueSubmit2("),
        ("LayerQueueSubmit2(", "LayerQueueSubmit2KHR("),
        ("LayerQueueSubmit2KHR(", "LayerQueueWaitIdle("),
    ):
        hook_start = source.index(submit_hook, retired_poll_end)
        hook_end = source.index(submit_end, hook_start)
        hook = source[hook_start:hook_end]
        retired_cleanup = hook.index("PollRetiredFeatureFencesOnQueueSubmit(state)")
        active_gate = hook.index("feature_submission_tracking_active.load")
        if retired_cleanup >= active_gate:
            raise AssertionError(
                "retired fence cleanup must be able to restore the immediate submit fast path"
            )

    submit_lock_start = source.index("VkResult SubmitQueueLocked(")
    submit_lock_end = source.index("LayerQueueSubmit(", submit_lock_start)
    submit_locks = source[submit_lock_start:submit_lock_end]
    for submit_name in (
        "state->next_queue_submit",
        "state->next_queue_submit2",
        "state->next_queue_submit2_khr",
    ):
        require(submit_locks, submit_name)
    non_graphics_gate = submit_locks.index("queue != state->graphics_queue")
    queue_mutex = submit_locks.index("state->queue_mutex")
    if non_graphics_gate >= queue_mutex:
        raise AssertionError(
            "queues unused by private NGX submit must bypass the graphics queue mutex"
        )

    bind_pipeline_start = source.index("LayerCmdBindPipeline(")
    bind_pipeline_end = source.index("LayerCmdBindDescriptorSets(", bind_pipeline_start)
    bind_pipeline = source[bind_pipeline_start:bind_pipeline_end]
    pipeline_gate = bind_pipeline.index("runtime_command_tracking_enabled.load")
    pipeline_lookup = bind_pipeline.index("FindDeviceFast(command_buffer)")
    pipeline_state = bind_pipeline.index("GetThreadComputeCommandStates()")
    if pipeline_gate > pipeline_lookup or pipeline_gate > pipeline_state:
        raise AssertionError(
            "inactive runtime tracking must bypass pipeline lookup and command-state capture"
        )
    pipeline_fast_path = bind_pipeline[pipeline_gate:pipeline_lookup]
    require(pipeline_fast_path, "fast_command_dispatch_key.load")
    require(pipeline_fast_path, "fast_cmd_bind_pipeline.load")
    if "state_mutex" in pipeline_fast_path or "tracking_mutex" in pipeline_fast_path:
        raise AssertionError("inactive pipeline bind fast path must not take a mutex")

    bind_descriptors_start = bind_pipeline_end
    bind_descriptors_end = source.index("FindTrackedDeviceFunction(", bind_descriptors_start)
    bind_descriptors = source[bind_descriptors_start:bind_descriptors_end]
    descriptor_gate = bind_descriptors.index("runtime_command_tracking_enabled.load")
    descriptor_lookup = bind_descriptors.index("FindDeviceFast(command_buffer)")
    descriptor_state = bind_descriptors.index("GetThreadComputeCommandStates()")
    if descriptor_gate > descriptor_lookup or descriptor_gate > descriptor_state:
        raise AssertionError(
            "inactive runtime tracking must bypass descriptor lookup and command-state capture"
        )
    descriptor_fast_path = bind_descriptors[descriptor_gate:descriptor_lookup]
    require(descriptor_fast_path, "fast_command_dispatch_key.load")
    require(descriptor_fast_path, "fast_cmd_bind_descriptor_sets.load")
    if "state_mutex" in descriptor_fast_path or "tracking_mutex" in descriptor_fast_path:
        raise AssertionError("inactive descriptor bind fast path must not take a mutex")
    publish_descriptor = bind_descriptors.index("PublishThreadCommandRecordingLocked(")
    dof_store = bind_descriptors.index(
        "state->command_buffer_dof_composite_states[command_buffer_handle]"
    )
    if publish_descriptor >= dof_store:
        raise AssertionError(
            "Retinal DOF command state must publish the matching begin metadata first"
        )

    reset_start = source.index("LayerResetCommandBuffer(")
    reset_end = source.index("LayerFreeCommandBuffers(", reset_start)
    reset_command_buffer = source[reset_start:reset_end]
    published_reset_gate = reset_command_buffer.index(
        "if (MayHavePublishedCommandBufferState("
    )
    reset_tracking_lock = reset_command_buffer.index("state->tracking_mutex")
    if published_reset_gate >= reset_tracking_lock:
        raise AssertionError(
            "ordinary command-buffer reset must bypass the shared tracking mutex"
        )
    require(reset_command_buffer, "GetThreadComputeCommandStates().ResetRecording(")
    require(reset_command_buffer, "ErasePublishedCommandBufferStateLocked(")

    reset_pool_start = source.index("LayerResetCommandPool(")
    reset_pool_end = source.index("LayerDestroyCommandPool(", reset_pool_start)
    reset_pool = source[reset_pool_start:reset_pool_end]
    require(reset_pool, "thread_states.ResetRecording(")
    if "thread_states.erase(" in reset_pool:
        raise AssertionError(
            "pool reset must retain TLS nodes instead of reallocating them next frame"
        )

    layout_start = source.index("LayerCreatePipelineLayout(")
    layout_end = source.index("LayerDestroyPipelineLayout(", layout_start)
    layout_capture = source[layout_start:layout_end]
    for exact_dof_gate in (
        "allocator == nullptr",
        "tracked.set_layouts.size() == 1u",
        "tracked.push_constant_ranges.empty()",
        "descriptor_layout->second.dof_composite_candidate",
        "{VK_SHADER_STAGE_COMPUTE_BIT, 0u, 112u}",
    ):
        require(layout_capture, exact_dof_gate)
    if "state->supported_executable" in layout_capture:
        raise AssertionError(
            "pipeline-layout tracking must not race deferred executable verification"
        )
    trampoline_index = layout_capture.index("trampoline(device, create_info")
    effective_range_index = layout_capture.index(
        "{VK_SHADER_STAGE_COMPUTE_BIT, 0u, 112u}"
    )
    store_index = layout_capture.index("state->pipeline_layouts")
    if not trampoline_index < effective_range_index < store_index:
        raise AssertionError(
            "the exact DOF effective push range must be mirrored only after "
            "successful downstream layout creation and before tracking"
        )

    destroy_start = source.index("HookDestroyDevice(")
    destroy_end = source.index("HookGetDeviceProcAddr(", destroy_start)
    destroy_device = source[destroy_start:destroy_end]
    require(destroy_device, "CompleteFeatureDevice(state.get());")
    require(destroy_device, "state->adapter_runtime.Shutdown(false);")
    require(destroy_device, "vkDestroyDevice: untracked device forwarded")
    require(destroy_device, "vkDestroyDevice: downstream destroy unavailable; cleanup skipped")
    require(destroy_device, "vkDestroyDevice: feature lifetime cleanup begin")
    require(destroy_device, "vkDestroyDevice: feature lifetime cleanup complete")
    require(destroy_device, "vkDestroyDevice: internal fence cleanup begin")
    require(destroy_device, "vkDestroyDevice: internal fence cleanup complete")
    require(destroy_device, "vkDestroyDevice: NGX cleanup begin")
    require(destroy_device, "vkDestroyDevice: NGX cleanup complete")
    require(destroy_device, "vkDestroyDevice: adapter cleanup begin")
    require(destroy_device, "vkDestroyDevice: adapter cleanup complete")
    require(destroy_device, "reshade_get_device_proc_addr(device, \"vkDestroyDevice\")")
    if "next_device_wait_idle" in destroy_device:
        raise AssertionError(
            "vkDestroyDevice must not add a redundant device-idle wait"
        )

    adapter_runtime = (args.source_dir / "dlss" / "adapter_runtime.cpp").read_text(
        encoding="utf-8"
    )
    adapter_header = (args.source_dir / "dlss" / "adapter_runtime.hpp").read_text(
        encoding="utf-8"
    )
    evaluation_trace = (args.source_dir / "dlss" / "evaluation_trace.hpp").read_text(
        encoding="utf-8"
    )
    for lifecycle_call in (
        "adapter_runtime.NotifyCommandBufferBegin(command_buffer)",
        "adapter_runtime.RecycleCommandBuffer(command_buffer)",
        "adapter_runtime.RetireCommandBuffer(command_buffers[index])",
    ):
        require(source, lifecycle_call)
    require(adapter_runtime, "impl_->RecycleBundle(command_buffer);")
    require(adapter_runtime, "impl_->idle_bundles")
    destructor_start = adapter_runtime.index("AdapterRuntime::~AdapterRuntime()")
    destructor_end = adapter_runtime.index(
        "AdapterResult AdapterRuntime::Initialize", destructor_start
    )
    if "Shutdown(" in adapter_runtime[destructor_start:destructor_end]:
        raise AssertionError(
            "CRT process detach must not call Vulkan shutdown from a static destructor"
        )

    capture_start = source.index("bool CaptureDofCompositeImageSnapshot(")
    capture_end = source.index("bool ReleaseDofCompositeImageSnapshot(", capture_start)
    capture = source[capture_start:capture_end]
    for detail in (
        "kDeviceStateUnavailable",
        "kCommandStateMissing",
        "kDescriptorSetMissing",
        "kDescriptorSetLayoutMismatch",
        "kPipelineLayoutMismatch",
        "kOutputBindingUnavailable",
        "kDepthBindingUnavailable",
        "kOutputDescriptorTypeMismatch",
        "kOutputLayoutMismatch",
        "kDepthDescriptorTypeMismatch",
    ):
        require(capture, detail)
    if "PollCompletedInternalFeatureFences" not in source:
        raise AssertionError("private DLAA submission fences are not polled")
    poll_start = source.index("void PollCompletedInternalFeatureFences")
    poll_end = source.index("VkFence CreateInternalFeatureFence", poll_start)
    poll = source[poll_start:poll_end]
    require(poll, "internal_feature_fences_pending.load(")
    if "wait_for_fences" in poll or "device_wait_idle" in poll:
        raise AssertionError("DLAA scratch recycling must remain non-blocking")

    removed_diagnostics = (
        "DiagnosticOutputMode",
        "DetroitDLSSDiagnosticOutput",
        "CommitSpatialDiagnostic",
        "diagnostic_spatial_output",
        "diagnostic_direct_output",
        "kDiagnosticPostNativeDirect",
        "kDiagnosticNativeReplay",
        "RENODX_DETROIT_DLSS_DIAGNOSTIC_OUTPUT",
    )
    diagnostic_sources = source + adapter_runtime + adapter_header + temporal
    for removed in removed_diagnostics:
        if removed in diagnostic_sources:
            raise AssertionError(f"temporary DLSS A/B diagnostic remains: {removed}")

    require(source, 'L"renodx-dev"')
    require(source, 'L"DetroitDLSSTraceFirstThree"')
    require(source, 'L"DetroitDLSSTraceReadback"')
    require(source, "GetPrivateProfileIntW(")
    require(source, "module_path.parent_path() / L\"ReShade.ini\"")
    require(source, "FirstThreeAttemptWindow")
    require(source, "TraceEvaluationTerminal(")
    require(source, "TraceFeatureSubmissionResult(")
    require(source, "TracePostCompletionResubmissionResult(")
    require(source, "TraceFeatureCompletion(")
    require(source, "submission_trace_tracker")
    require(evaluation_trace, "kAttemptLimit = 3u")
    require(evaluation_trace, "Arm()")
    require(evaluation_trace, "compare_exchange_weak(")
    require(evaluation_trace, "class SubmissionTraceTracker final")
    require(evaluation_trace, "MarkSubmitted(")
    require(evaluation_trace, "MarkPostCompletionResubmitted(")
    require(evaluation_trace, "NeedsCompletion(")
    require(evaluation_trace, "kSubmitLogLimit = 4u")
    require(evaluation_trace, "submit_count")
    require(evaluation_trace, "completion_logged")
    require(evaluation_trace, "recording_generation")
    require(evaluation_trace, "recording_epoch")
    require(source, "event=post_completion_resubmit")
    require(source, "core_snapshot=false")
    if source.count("TracePostCompletionResubmissionResult(") != 4:
        raise AssertionError(
            "post-completion replay detection must cover all three queue-submit entry points"
        )
    require(source, "SubmissionNeedsInternalFeatureFence(")
    fence_policy_start = source.index("bool SubmissionNeedsInternalFeatureFence(")
    fence_policy_end = source.index(
        "void TraceFeatureSubmissionResult(", fence_policy_start
    )
    fence_policy = source[fence_policy_start:fence_policy_end]
    one_time_gate = fence_policy.index("if (command.one_time_submit) return true;")
    trace_gate = fence_policy.index(
        "!GetEvaluationTraceConfiguration().readback"
    )
    if one_time_gate >= trace_gate:
        raise AssertionError(
            "one-time scratch completion fences must not depend on trace/readback"
        )
    if "unclassified_terminal" in evaluation_trace or "unclassified_terminal" in source:
        raise AssertionError("every bounded evaluation attempt must have a terminal class")

    trace_start = source.index("void Trace(std::string_view message)")
    trace_end = source.index("void CloseTraceFile()", trace_start)
    trace_body = source[trace_start:trace_end]
    require(trace_body, "if (trace_file == INVALID_HANDLE_VALUE)")
    require(trace_body, "trace_file = CreateFileW(")
    if "CloseHandle(" in trace_body:
        raise AssertionError("the bounded trace file must not reopen for every line")

    readback_start = adapter_runtime.index("bool RecordTraceReadback(")
    readback_end = adapter_runtime.index("AdapterResult CreateBundle(", readback_start)
    readback = adapter_runtime[readback_start:readback_end]
    require(readback, "kTraceReadbackTileCount")
    require(readback, "bundle->dlss_output.image")
    require(readback, "cmd_copy_image_to_buffer(")
    if "native_output.image" in readback or "output_color_pass" in readback:
        raise AssertionError("trace readback must never copy Detroit-owned b16")
    require(adapter_header, "kTraceReadbackTileCount = 5u")
    require(adapter_header, "TakeCompletedTraceReadback(")

    completion_start = source.index("void TraceFeatureCompletion(")
    completion_end = source.index("void RecycleCompletedCommandBuffers(", completion_start)
    completion = source[completion_start:completion_end]
    require(completion, "TakeCompletedTraceReadback(")
    completion_lock = completion.index("const std::lock_guard lock(state->mutex)")
    completion_record = completion.index("submission_trace_tracker.Complete(")
    completion_readback = completion.index("TakeCompletedTraceReadback(")
    if not completion_lock < completion_record < completion_readback:
        raise AssertionError(
            "trace record and adapter readback must share one generation-safe lock"
        )
    recycle_start = completion_end
    recycle_end = source.index("void RecycleInternalFeatureFence(", recycle_start)
    recycle = source[recycle_start:recycle_end]
    recycle_lock = recycle.index("const std::lock_guard lock(state->mutex)")
    epoch_match = recycle.index("feature_recording_candidates.Matches(")
    recycle_call = recycle.index("adapter_runtime.RecycleCommandBuffer(")
    epoch_erase = recycle.index("feature_recording_candidates.EraseIfMatches(")
    if not recycle_lock < epoch_match < recycle_call < epoch_erase:
        raise AssertionError(
            "completion cleanup must match, recycle, and erase one exact recording epoch"
        )

    evaluate_start = source.index("DetroitDlssResultCode DETROIT_DLSS_CALL BridgeEvaluate")
    evaluate_end = source.index("LayerCreateDescriptorSetLayout(", evaluate_start)
    evaluate = source[evaluate_start:evaluate_end]
    require(evaluate, "EnsureNgxInitialized(state.get())")
    require(evaluate, "state->ngx_context->ConfigureFeature({")
    require(evaluate, "if (configure_result.feature_created)")
    require(evaluate, "state->ngx_context->Evaluate({")
    dlaa_mode_gate = evaluate.index(
        "state->settings.mode != DETROIT_DLSS_MODE_DLAA"
    )
    prepare_call = evaluate.index("state->adapter_runtime.Prepare(")
    candidate_mark = evaluate.index("MarkFeatureRecordingCandidateLocked(")
    ngx_evaluate = evaluate.index("state->ngx_context->Evaluate({")
    if not dlaa_mode_gate < prepare_call < ngx_evaluate < candidate_mark:
        raise AssertionError(
            "Evaluate must reject non-DLAA state before adapter/NGX work and use "
            "the authoritative NGX recording epoch"
        )
    require(evaluate[candidate_mark:], "evaluate_result.recording_epoch")
    require(source, "return NGX_VULKAN_CREATE_DLSS_EXT1(")
    gate_index = source.index("if (!cache_valid)")
    detour_index = source.index("DetourTransactionBegin()", gate_index)
    if not gate_index < detour_index:
        raise AssertionError("invalid extension cache must fail closed before Detours")
    require(addon, "QueryRequiredExtensionsIsolated(addon_module, &refreshed)")
    require(addon, "bool ReadStartupEmbeddedHookRequest()")
    if "ReadStartupNativeCommandHookRequest" in addon:
        raise AssertionError("command hooks must follow the embedded bridge lifecycle")
    require(addon, '"renodx-preset1", "DepthOfFieldMode"')
    require(addon, "embedded_hooks_requested_at_startup = ReadStartupEmbeddedHookRequest()")
    require(addon, "if (embedded_hooks_requested_at_startup)")
    require(addon, "embedded_hooks_active.store(")
    require(
        addon,
        "embedded_dlss::AttachEarlyHooks(\n"
        "            h_module,\n"
        "            initial_extension_cache,\n"
        "            true)",
    )
    if not re.search(
        r"embedded_hooks_requested_at_startup\s*"
        r"&& !bootstrap_setup_attempted\.load\(std::memory_order_acquire\)\s*"
        r"&& !bootstrap_setup_attempted\.exchange",
        addon,
    ):
        raise AssertionError("deferred bootstrap must remain single-shot")
    tracking_refresh_start = addon.index("void RefreshEmbeddedCommandTracking()")
    tracking_refresh_end = addon.index("void ApplyDlssMode(", tracking_refresh_start)
    tracking_refresh = addon[tracking_refresh_start:tracking_refresh_end]
    require(tracking_refresh, "embedded_dlss::SetRuntimeCommandTracking(")
    require(tracking_refresh, "embedded_dlss::NeedsRuntimeCommandTracking(")
    require(tracking_refresh, "temporal_capture::GetMode()")
    require(tracking_refresh, "dof_mode >= 2.5f")
    apply_mode_start = tracking_refresh_end
    apply_mode_end = addon.index("void OnDlssModeChanged()", apply_mode_start)
    require(addon[apply_mode_start:apply_mode_end], "RefreshEmbeddedCommandTracking()")
    dof_settings_start = addon.index("void OnDofSettingsChanged()")
    dof_settings_end = addon.index("render_debug::Source", dof_settings_start)
    require(addon[dof_settings_start:dof_settings_end], "RefreshEmbeddedCommandTracking()")
    temporal_dispatch_start = temporal.index("inline void AfterNativeTemporalDispatch(")
    temporal_dispatch_end = temporal.index("inline void Use(", temporal_dispatch_start)
    temporal_dispatch = temporal[temporal_dispatch_start:temporal_dispatch_end]
    native_fast_path = temporal_dispatch.index(
        "if (mode_snapshot.mode == DETROIT_DLSS_MODE_NATIVE)"
    )
    snapshot_capture = temporal_dispatch.index("CaptureTemporalSnapshot(")
    if native_fast_path > snapshot_capture:
        raise AssertionError(
            "Native TAA must bypass temporal snapshot capture before bridge work"
        )
    require(bridge, "DetroitDlssGetApiFn provider_")
    require(bridge, "provider_(DETROIT_DLSS_ABI_VERSION, &candidate)")

    attach_start = addon.index("bool AttachAddon(HMODULE h_module)")
    attach_end = addon.index("void DetachAddon", attach_start)
    attach = addon[attach_start:attach_end]
    pin_index = attach.index("GET_MODULE_HANDLE_EX_FLAG_PIN")
    register_index = attach.index("reshade::register_addon(h_module)")
    cache_index = attach.index("ReadExtensionCache()")
    request_index = attach.index("embedded_hooks_requested_at_startup = ReadStartupEmbeddedHookRequest()")
    hooks_index = attach.index("embedded_dlss::AttachEarlyHooks")
    if not pin_index < register_index < cache_index < request_index < hooks_index:
        raise AssertionError(
            "the addon must be pinned before ReShade registration, config access, "
            "startup feature selection, and conditional early hook attachment"
        )

    require(effects_addon, "#define DETROIT_EFFECTS_ADDON")
    require(effects_addon, '#include "../detroitbecomehuman/addon.cpp"')
    require(cmake, "target_sources(detroitbecomehuman-effects PRIVATE")
    if "target_sources(detroitbecomehuman PRIVATE" in cmake:
        raise AssertionError("HDR core must not link the Vulkan DLSS backend")
    require(
        addon,
        "#ifndef DETROIT_EFFECTS_ADDON\n"
        "namespace renodx::games::detroitbecomehuman::dlss::embedded",
    )
    effects_start = attach.index("#ifdef DETROIT_EFFECTS_ADDON")
    hdr_start = attach.index("#else", effects_start)
    split_end = attach.index("#endif", hdr_start)
    effects_attach = attach[effects_start:hdr_start]
    hdr_attach = attach[hdr_start:split_end]
    for effect_registration in (
        "embedded_dlss::AttachEarlyHooks",
        "temporal_capture::Use(DLL_PROCESS_ATTACH)",
        "effect_shaders",
        "OnInitEffectRuntime",
        "OnDestroyResource",
    ):
        require(effects_attach, effect_registration)
        if effect_registration in hdr_attach:
            raise AssertionError(
                "HDR core must not register optional effect logic: "
                + effect_registration
            )
    require(hdr_attach, "hdr_shaders")
    require(
        effects_attach,
        "renodx::mods::shader::use_shared_pipeline_injection = true;",
    )
    if "use_shared_pipeline_injection" in hdr_attach:
        raise AssertionError("HDR core must own the shared pipeline injection")
    require(
        shader_mod,
        "if (!use_shared_pipeline_injection\n"
        "          && (mods::shader::use_pipeline_layout_cloning",
    )

    detach_start = addon.index("void DetachAddon(HMODULE h_module")
    detach_end = addon.index("BOOL APIENTRY DllMain", detach_start)
    detach = addon[detach_start:detach_end]
    require(detach, "addon_attached.store(false")
    for loader_lock_teardown in (
        "reshade::unregister_event",
        "reshade::unregister_addon",
        "renodx::utils::settings::Use",
        "renodx::mods::shader::Use",
        "DetachEarlyHooks",
    ):
        if loader_lock_teardown in detach:
            raise AssertionError(
                "DllMain detach must not perform teardown under the loader lock: "
                + loader_lock_teardown
            )

    forbidden = (
        "vkNegotiateLoaderLayerInterfaceVersion",
        "VkLayerInstanceCreateInfo",
        "VkLayerDeviceCreateInfo",
        "VK_LAYER_LINK_INFO",
        "GetModuleHandleW(kBridgeModuleName)",
        "add_executable(detroitbecomehuman_dlss_launcher",
        "add_library(detroitbecomehuman_dlss_layer SHARED",
    )
    combined = source + cmake + bridge
    for text in forbidden:
        if text in combined:
            raise AssertionError(f"obsolete external-layer contract remains: {text}")

    print("PASS")


if __name__ == "__main__":
    main()
