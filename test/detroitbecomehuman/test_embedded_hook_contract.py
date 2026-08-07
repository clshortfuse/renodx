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
    require(bridge, "DetroitDlssGetApiFn provider_")
    require(bridge, "provider_(DETROIT_DLSS_ABI_VERSION, &candidate)")

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
