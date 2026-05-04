/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include "../../../utils/mcp/types.hpp"

namespace renodx::addons::devkit::mcp::tool_catalog {
inline const renodx::utils::mcp::ToolCatalog METADATA = {
    {
        "devkit_status",
        {
            .title = "Devkit Status",
            .description = "Summarize tracked devices, selected device state, and snapshot activity.",
            .annotations = {
                .read_only_hint = true,
            },
        },
    },
    {
        "devkit_select_device",
        {
            .title = "Select Device",
            .description = "Change the currently selected devkit device by index.",
            .input_schema = {
                .properties = {
                    {"deviceIndex", {.types = {"integer"}, .minimum = 0}},
                },
                .required = {"deviceIndex"},
            },
        },
    },
    {
        "devkit_list_shaders",
        {
            .title = "List Shaders",
            .description = "List tracked shaders for a device, optionally filtered by stage.",
            .input_schema = {
                .properties = {
                    {"deviceIndex", {.types = {"integer"}, .minimum = 0}},
                    {"stage", {.types = {"string"}}},
                    {"limit", {.types = {"integer"}, .minimum = 1, .maximum = 5000}},
                    {"offset", {.types = {"integer"}, .minimum = 0}},
                },
            },
            .annotations = {
                .read_only_hint = true,
            },
        },
    },
    {
        "devkit_get_shader",
        {
            .title = "Get Shader",
            .description = "Return metadata for a tracked shader and optionally include disassembly or DXC decompilation text via a named view or a views array.",
            .input_schema = {
                .properties = {
                    {"deviceIndex", {.types = {"integer"}, .minimum = 0}},
                    {"shaderHash", {.types = {"string", "integer"}}},
                    {"view", {.types = {"string"}, .enum_values = {"summary", "disassembly", "decompilation", "all"}}},
                    {"views", {.types = {"array"}, .item_types = {"string"}, .item_enum_values = {"disassembly", "decompilation"}}},
                    {"maxTextLength", {.types = {"integer"}, .minimum = 1}},
                },
                .required = {"shaderHash"},
            },
            .annotations = {
                .read_only_hint = true,
            },
        },
    },
    {
        "devkit_dump_shader",
        {
            .title = "Dump Shader",
            .description = "Write a tracked shader's original bytecode to disk for external decompilers or archiving.",
            .input_schema = {
                .properties = {
                    {"deviceIndex", {.types = {"integer"}, .minimum = 0}},
                    {"shaderHash", {.types = {"string", "integer"}}},
                    {"outputPath", {.types = {"string"}}},
                },
                .required = {"shaderHash"},
            },
        },
    },
    {
        "devkit_set_tools_path",
        {
            .title = "Set Tools Path",
            .description = "Query or change the directory used for dxcompiler.dll and optional repo bin tools.",
            .input_schema = {
                .properties = {
                    {"path", {.types = {"string"}}},
                },
            },
        },
    },
    {
        "devkit_set_live_shader_path",
        {
            .title = "Set Live Shader Path",
            .description = "Query or change the directory used by the devkit live shader compiler.",
            .input_schema = {
                .properties = {
                    {"path", {.types = {"string"}}},
                },
            },
        },
    },
    {
        "devkit_load_live_shaders",
        {
            .title = "Load Live Shaders",
            .description = "Compile and activate shader replacements from the configured live shader directory for the selected device.",
            .input_schema = {
                .properties = {
                    {"deviceIndex", {.types = {"integer"}, .minimum = 0}},
                },
            },
        },
    },
    {
        "devkit_unload_live_shaders",
        {
            .title = "Unload Live Shaders",
            .description = "Remove active live shader replacements from the selected device.",
            .input_schema = {
                .properties = {
                    {"deviceIndex", {.types = {"integer"}, .minimum = 0}},
                },
            },
        },
    },
    {
        "devkit_list_draws",
        {
            .title = "List Draws",
            .description = "List draw records from the selected device's current snapshot cache.",
            .input_schema = {
                .properties = {
                    {"deviceIndex", {.types = {"integer"}, .minimum = 0}},
                    {"limit", {.types = {"integer"}, .minimum = 1, .maximum = 1000}},
                    {"offset", {.types = {"integer"}, .minimum = 0}},
                },
            },
            .annotations = {
                .read_only_hint = true,
            },
        },
    },
    {
        "devkit_get_draw",
        {
            .title = "Get Draw",
            .description = "Return full details for a single captured draw, including bindings and blend state.",
            .input_schema = {
                .properties = {
                    {"deviceIndex", {.types = {"integer"}, .minimum = 0}},
                    {"drawIndex", {.types = {"integer"}, .minimum = 0}},
                },
                .required = {"drawIndex"},
            },
            .annotations = {
                .read_only_hint = true,
            },
        },
    },
    {
        "devkit_analyze_resource",
        {
            .title = "Analyze Resource",
            .description = "Copy a tracked resource view, or its instantiated clone when requested, into a temporary readback texture, summarize its current contents, and optionally save a PNG preview or RGBA16F EXR dump.",
            .input_schema = {
                .properties = {
                    {"deviceIndex", {.types = {"integer"}, .minimum = 0}},
                    {"resourceViewHandle", {.types = {"string", "integer"}}},
                    {"outputPath", {.types = {"string"}}},
                    {"previewMode", {.types = {"string"}, .enum_values = {"clamped", "neutwo"}}},
                    {"preferClone", {.types = {"boolean"}}},
                },
                .required = {"resourceViewHandle"},
            },
            .annotations = {
                .read_only_hint = true,
            },
        },
    },
    {
        "devkit_set_resource_clone",
        {
            .title = "Set Resource Clone",
            .description = "Enable or disable devkit clone hotswap on a tracked texture resource for live comparison.",
            .input_schema = {
                .properties = {
                    {"deviceIndex", {.types = {"integer"}, .minimum = 0}},
                    {"resourceHandle", {.types = {"string", "integer"}}},
                    {"enabled", {.types = {"boolean"}}},
                },
                .required = {"resourceHandle", "enabled"},
            },
        },
    },
    {
        "devkit_snapshot_summary",
        {
            .title = "Snapshot Summary",
            .description = "Summarize cached snapshot counts for a device.",
            .input_schema = {
                .properties = {
                    {"deviceIndex", {.types = {"integer"}, .minimum = 0}},
                },
            },
            .annotations = {
                .read_only_hint = true,
            },
        },
    },
    {
        "devkit_queue_snapshot",
        {
            .title = "Queue Snapshot",
            .description = "Queue a new snapshot capture for a device on the next present.",
            .input_schema = {
                .properties = {
                    {"deviceIndex", {.types = {"integer"}, .minimum = 0}},
                },
            },
        },
    },
};

}  // namespace renodx::addons::devkit::mcp::tool_catalog
