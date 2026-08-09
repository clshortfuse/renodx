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
    require(bridge, "DetroitDlssGetApiFn provider_")
    require(bridge, "provider_(DETROIT_DLSS_ABI_VERSION, &candidate)")

    attach_start = addon.index("bool AttachAddon(HMODULE h_module)")
    attach_end = addon.index("void DetachAddon", attach_start)
    attach = addon[attach_start:attach_end]
    pin_index = attach.index("GET_MODULE_HANDLE_EX_FLAG_PIN")
    register_index = attach.index("reshade::register_addon(h_module)")
    cache_index = attach.index("ReadExtensionCache()")
    hooks_index = attach.index("embedded_dlss::AttachEarlyHooks")
    if not pin_index < register_index < cache_index < hooks_index:
        raise AssertionError(
            "the addon must be pinned before ReShade registration, config access, "
            "and early hook attachment"
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
