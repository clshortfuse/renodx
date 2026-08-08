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
    if "PollCompletedInternalFeatureFences" not in source:
        raise AssertionError("private DLAA submission fences are not polled")
    poll_start = source.index("void PollCompletedInternalFeatureFences")
    poll_end = source.index("VkFence CreateInternalFeatureFence", poll_start)
    poll = source[poll_start:poll_end]
    if "wait_for_fences" in poll or "device_wait_idle" in poll:
        raise AssertionError("DLAA scratch recycling must remain non-blocking")
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
    register_index = attach.index("reshade::register_addon(h_module)")
    cache_index = attach.index("ReadExtensionCache()")
    hooks_index = attach.index("embedded_dlss::AttachEarlyHooks")
    if not register_index < cache_index < hooks_index:
        raise AssertionError(
            "ReShade registration must precede config access and early hook attachment"
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
