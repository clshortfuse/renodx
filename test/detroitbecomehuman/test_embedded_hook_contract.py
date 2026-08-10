#!/usr/bin/env python3

import argparse
from pathlib import Path


def require(source: str, text: str) -> None:
    if text not in source:
        raise AssertionError(f"missing embedded hook contract: {text}")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--source-dir", type=Path, required=True)
    args = parser.parse_args()
    source = (args.source_dir / "dlss" / "vulkan_layer.cpp").read_text(encoding="utf-8")
    addon = (args.source_dir / "addon.cpp").read_text(encoding="utf-8")
    cmake = (args.source_dir / "dlss" / "CMakeLists.txt").read_text(encoding="utf-8")
    bridge = (args.source_dir / "dlss_bridge_client.hpp").read_text(encoding="utf-8")
    temporal = (args.source_dir / "temporal_capture.hpp").read_text(encoding="utf-8")
    bootstrap = (args.source_dir / "dlss" / "embedded_bootstrap.hpp").read_text(
        encoding="utf-8"
    )
    temporal_shader = (args.source_dir / "temporal_aux.comp.vk.glsl").read_text(
        encoding="utf-8"
    )

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
    require(source, "UseInternalFeatureFences()")
    require(source, "feature_command_buffer_bloom")
    require(source, "AppendFeatureSubmissionCandidate(")
    require(source, "command-buffer lifecycle tracking")
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
    require(bootstrap, "inline constexpr bool kDlaaRuntimeEnabled = false;")
    require(bootstrap, "return kDlaaRuntimeEnabled || retinal_dof_requested;")
    require(bootstrap, "return retinal_dof_requested;")
    require(
        source,
        "Targeted DLAA backend active without native Vulkan command-bind hooks",
    )
    require(addon, '.labels = {"Native TAA", "DLAA"}')
    require(addon, "if (!embedded_dlss::kDlaaRuntimeEnabled)")
    require(temporal_shader, "imageStore(OutAADepth")
    require(temporal_shader, "imageStore(OutPrevSpeedAndFlagsTex")
    require(temporal_shader, "imageStore(HalfResContours")
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
    require(snapshot_capture, "ResolveLatestTemporalDescriptorUpdateLocked(")
    require(snapshot_capture, "ResolveChangedTemporalConstantsSlotLocked(")
    require(snapshot_capture, "FillTemporalConstantsForBindingLocked(")
    require(source, "pipeline_layout->second.set_layouts.size() != 1u")
    if "InstallTargetedTemporalCommandStateLocked" in source:
        raise AssertionError(
            "targeted snapshots must not persist a rotating b52 offset as command state"
        )

    bind_pipeline_start = source.index("LayerCmdBindPipeline(")
    bind_pipeline_end = source.index("LayerCmdBindDescriptorSets(", bind_pipeline_start)
    bind_pipeline = source[bind_pipeline_start:bind_pipeline_end]
    pipeline_gate = bind_pipeline.index("runtime_command_tracking_enabled.load")
    pipeline_state = bind_pipeline.index("GetThreadComputeCommandStates()")
    if pipeline_gate > pipeline_state:
        raise AssertionError(
            "inactive runtime tracking must bypass pipeline command-state capture"
        )

    bind_descriptors_start = bind_pipeline_end
    bind_descriptors_end = source.index("FindTrackedDeviceFunction(", bind_descriptors_start)
    bind_descriptors = source[bind_descriptors_start:bind_descriptors_end]
    descriptor_gate = bind_descriptors.index("runtime_command_tracking_enabled.load")
    descriptor_state = bind_descriptors.index("GetThreadComputeCommandStates()")
    if descriptor_gate > descriptor_state:
        raise AssertionError(
            "inactive runtime tracking must bypass descriptor command-state capture"
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
    require(poll, "if (!UseInternalFeatureFences()")
    if "wait_for_fences" in poll or "device_wait_idle" in poll:
        raise AssertionError("DLAA scratch recycling must remain non-blocking")

    spatial_start = source.index("if (diagnostic_spatial_output) {")
    spatial_end = source.index("auto color = MakeNgxResource", spatial_start)
    spatial = source[spatial_start:spatial_end]
    require(spatial, "RecordFeatureUseLocked(")
    require(spatial, "CommitSpatialDiagnostic(prepared_frame)")
    require(spatial, "without NGX evaluation; feature submission and")
    if "NGX_VULKAN_EVALUATE_DLSS_EXT" in spatial:
        raise AssertionError(
            "spatial diagnostic must retain fence tracking without recording NGX"
        )
    if spatial.index("RecordFeatureUseLocked(") > spatial.index(
        "CommitSpatialDiagnostic(prepared_frame)"
    ):
        raise AssertionError(
            "spatial diagnostic must mark feature lifetime before its commands commit"
        )
    gate_index = source.index("if (!cache_valid)")
    detour_index = source.index("DetourTransactionBegin()", gate_index)
    if not gate_index < detour_index:
        raise AssertionError("invalid extension cache must fail closed before Detours")
    require(addon, "QueryRequiredExtensionsIsolated(addon_module, &refreshed)")
    require(addon, "bool ReadStartupEmbeddedHookRequest()")
    require(addon, '"renodx-preset1", "DLSSMode"')
    require(addon, '"renodx-preset1", "DepthOfFieldMode"')
    require(addon, "embedded_hooks_requested_at_startup = ReadStartupEmbeddedHookRequest()")
    require(addon, "if (embedded_hooks_requested_at_startup)")
    require(addon, "embedded_hooks_active.store(")
    require(addon, "embedded_hooks_requested_at_startup\n      && !bootstrap_setup_attempted.exchange")
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
