/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include "../../../utils/mcp/types.hpp"

namespace renodx::addons::devkit::mcp::tool_catalog {
inline renodx::utils::mcp::InputSchemaProperty MakeFlexibleHandleProperty() {
  return renodx::utils::mcp::InputSchemaProperty{
      .types = {"string"},
  };
}

inline renodx::utils::mcp::InputSchemaProperty MakeFlexibleUploadPathsProperty() {
  return renodx::utils::mcp::InputSchemaProperty{
      .types = {"array"},
      .item_types = {"string"},
      .item_enum_values = {
          "create_resource",
          "update_texture_region",
          "copy_buffer_to_texture",
      },
  };
}

inline renodx::utils::mcp::InputSchemaProperty MakeTextureReplaceRulesProperty() {
  using InputSchemaProperty = renodx::utils::mcp::InputSchemaProperty;

  return InputSchemaProperty{
      .types = {"array"},
      .item_types = {"object"},
      .item_properties = {
          {"name", {.types = {"string"}}},
          {"enabled", {.types = {"boolean"}}},
          {"uploadPaths",
           {
               MakeFlexibleUploadPathsProperty(),
           }},
          {"subresource", {.types = {"integer"}, .minimum = 0}},
          {"requireFullUpdate", {.types = {"boolean"}}},
          {"requireUploadHeapSource", {.types = {"boolean"}}},
          {"format", {.types = {"integer"}, .minimum = 0}},
          {"usageInclude", {.types = {"integer"}, .minimum = 0}},
          {"usageExclude", {.types = {"integer"}, .minimum = 0}},
          {"width", {.types = {"integer"}}},
          {"height", {.types = {"integer"}}},
          {"depthOrLayers", {.types = {"integer"}}},
          {"allowDynamic", {.types = {"boolean"}}},
          {"allowMultisampled", {.types = {"boolean"}}},
      },
  };
}

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
                    {"shaderHash", MakeFlexibleHandleProperty()},
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
                    {"shaderHash", MakeFlexibleHandleProperty()},
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
            .description = "List draw records from the selected device's current snapshot cache, with optional filters for method, shader hash, stage, and binding/render-target counts.",
            .input_schema = {
                .properties = {
                    {"deviceIndex", {.types = {"integer"}, .minimum = 0}},
                    {"method", {.types = {"string"}}},
                    {"shaderHash", MakeFlexibleHandleProperty()},
                    {"activeShaderStage", {.types = {"string"}}},
                    {"minSrvCount", {.types = {"integer"}, .minimum = 0}},
                    {"minUavCount", {.types = {"integer"}, .minimum = 0}},
                    {"minConstantCount", {.types = {"integer"}, .minimum = 0}},
                    {"minRenderTargetCount", {.types = {"integer"}, .minimum = 0}},
                    {"minPipelineCount", {.types = {"integer"}, .minimum = 0}},
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
                    {"resourceViewHandle", MakeFlexibleHandleProperty()},
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
        "devkit_dump_resource_with_hash",
        {
            .title = "Dump Resource With Hash",
            .description = "Read back a tracked resource view, compute a raw-byte CRC32, prefer a matching tracked upload CRC when available, and dump a hash-named PNG for replacement workflows.",
            .input_schema = {
                .properties = {
                    {"deviceIndex", {.types = {"integer"}, .minimum = 0}},
                    {"resourceViewHandle", MakeFlexibleHandleProperty()},
                    {"outputDirectory", {.types = {"string"}}},
                    {"namePrefix", {.types = {"string"}}},
                    {"preferClone", {.types = {"boolean"}}},
                },
                .required = {"resourceViewHandle", "outputDirectory"},
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
                    {"resourceHandle", MakeFlexibleHandleProperty()},
                    {"enabled", {.types = {"boolean"}}},
                },
                .required = {"resourceHandle", "enabled"},
            },
        },
    },
    {
        "devkit_replace_resource_with_file",
        {
            .title = "Replace Resource With File",
            .description = "Enable clone hotswap for a tracked resource or view, create a clone if needed, and upload a PNG into that clone for immediate live replacement.",
            .input_schema = {
                .properties = {
                    {"deviceIndex", {.types = {"integer"}, .minimum = 0}},
                    {"resourceViewHandle", MakeFlexibleHandleProperty()},
                    {"resourceHandle", MakeFlexibleHandleProperty()},
                    {"path", {.types = {"string"}}},
                },
                .required = {"path"},
            },
        },
    },
    {
        "devkit_set_texture_replace_enabled",
        {
            .title = "Set Texture Replace Enabled",
            .description = "Enable or disable devkit boot/create texture replacement interception globally.",
            .input_schema = {
                .properties = {
                    {"enabled", {.types = {"boolean"}}},
                },
                .required = {"enabled"},
            },
        },
    },
    {
        "devkit_reload_texture_replace_boot_cache",
        {
            .title = "Reload Texture Replace Boot Cache",
            .description = "Reload pre-decoded PNG replacements from the devkit boot directory for future create_resource initial-data replacements.",
        },
    },
    {
        "devkit_set_texture_replace_rules",
        {
            .title = "Set Texture Replace Rules",
            .description = "Replace the texture-replacement rule list for a device. Rule fields are descriptor/path filters used before any replacement provider is invoked.",
            .input_schema = {
                .properties = {
                    {"deviceIndex", {.types = {"integer"}, .minimum = 0}},
                    {"rules", MakeTextureReplaceRulesProperty()},
                },
                .required = {"rules"},
            },
        },
    },
    {
        "devkit_get_texture_replace_state",
        {
            .title = "Get Texture Replace State",
            .description = "Return boot/create texture-replacement enable state, provider state, active rules, observation count, and observed upload stats for a device.",
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
        "devkit_list_texture_replace_observations",
        {
            .title = "List Texture Replace Observations",
            .description = "List identified texture upload observations with CRC, format, dimensions, upload path, and hit counters.",
            .input_schema = {
                .properties = {
                    {"deviceIndex", {.types = {"integer"}, .minimum = 0}},
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
        "devkit_clear_texture_replace_observations",
        {
            .title = "Clear Texture Replace Observations",
            .description = "Clear captured texture upload observations for a device and reset observation hit counters.",
            .input_schema = {
                .properties = {
                    {"deviceIndex", {.types = {"integer"}, .minimum = 0}},
                },
            },
        },
    },
    {
        "devkit_dump_texture_replace_observation",
        {
            .title = "Dump Texture Replace Observation",
            .description = "Dump captured bytes for an identified texture observation to disk for offline editing. Use .png for RGBA8/BGRA8 families, .bin for raw bytes, or pass the boot directory to use the canonical boot/create replacement filename.",
            .input_schema = {
                .properties = {
                    {"deviceIndex", {.types = {"integer"}, .minimum = 0}},
                    {"observationIndex", {.types = {"integer"}, .minimum = 0}},
                    {"outputPath", {.types = {"string"}}},
                },
                .required = {"observationIndex", "outputPath"},
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
