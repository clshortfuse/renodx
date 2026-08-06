/*
 * SPDX-License-Identifier: MIT
 *
 * Stable x64 C ABI shared by the Detroit RenoDX add-on and a future Vulkan
 * DLSS bootstrap. This header deliberately does not depend on Vulkan or NGX
 * headers. Vulkan handles and procedure addresses cross the boundary as
 * opaque 64-bit values.
 */

#ifndef RENODX_DETROITBECOMEHUMAN_DLSS_BRIDGE_ABI_H
#define RENODX_DETROITBECOMEHUMAN_DLSS_BRIDGE_ABI_H

#include <stdint.h>

#if defined(_WIN32)
#define DETROIT_DLSS_CALL __cdecl
#else
#define DETROIT_DLSS_CALL
#endif

#ifdef __cplusplus
extern "C" {
#endif

#define DETROIT_DLSS_ABI_VERSION            2u
#define DETROIT_DLSS_TEMPORAL_AA_SHADER_CRC 0xB5506A45u

typedef uint32_t DetroitDlssMode;
#define DETROIT_DLSS_MODE_NATIVE      0u
#define DETROIT_DLSS_MODE_DLAA        1u
#define DETROIT_DLSS_MODE_QUALITY     2u
#define DETROIT_DLSS_MODE_BALANCED    3u
#define DETROIT_DLSS_MODE_PERFORMANCE 4u

typedef uint32_t DetroitDlssResultCode;
#define DETROIT_DLSS_RESULT_SUCCESS  0u
#define DETROIT_DLSS_RESULT_FALLBACK 1u
#define DETROIT_DLSS_RESULT_ERROR    2u

typedef uint64_t DetroitDlssCapabilityFlags;
#define DETROIT_DLSS_CAPABILITY_SUPER_RESOLUTION         (UINT64_C(1) << 0u)
#define DETROIT_DLSS_CAPABILITY_DLAA                     (UINT64_C(1) << 1u)
#define DETROIT_DLSS_CAPABILITY_AUTO_EXPOSURE            (UINT64_C(1) << 2u)
#define DETROIT_DLSS_CAPABILITY_RENDER_SCALE_CONTROL     (UINT64_C(1) << 3u)
#define DETROIT_DLSS_CAPABILITY_TEMPORAL_INPUTS_VERIFIED (UINT64_C(1) << 4u)
#define DETROIT_DLSS_CAPABILITY_SUPPORTED_EXECUTABLE     (UINT64_C(1) << 5u)

typedef uint64_t DetroitDlssFrameFlags;
#define DETROIT_DLSS_FRAME_NATIVE_TAA_COMPLETED (UINT64_C(1) << 0u)
#define DETROIT_DLSS_FRAME_ALLOW_AUTO_EXPOSURE  (UINT64_C(1) << 1u)
#define DETROIT_DLSS_FRAME_CAMERA_CUT           (UINT64_C(1) << 2u)
#define DETROIT_DLSS_FRAME_SCENE_LOADED         (UINT64_C(1) << 3u)

typedef uint32_t DetroitDlssCreateFlags;
#define DETROIT_DLSS_CREATE_HDR                           (UINT32_C(1) << 0u)
#define DETROIT_DLSS_CREATE_MOTION_VECTORS_LOW_RESOLUTION (UINT32_C(1) << 1u)
#define DETROIT_DLSS_CREATE_DEPTH_INVERTED                (UINT32_C(1) << 2u)
#define DETROIT_DLSS_CREATE_MOTION_VECTORS_JITTERED       (UINT32_C(1) << 3u)
#define DETROIT_DLSS_CREATE_AUTO_EXPOSURE                 (UINT32_C(1) << 4u)
#define DETROIT_DLSS_CREATE_KNOWN_MASK                 \
  (DETROIT_DLSS_CREATE_HDR                             \
   | DETROIT_DLSS_CREATE_MOTION_VECTORS_LOW_RESOLUTION \
   | DETROIT_DLSS_CREATE_DEPTH_INVERTED                \
   | DETROIT_DLSS_CREATE_MOTION_VECTORS_JITTERED       \
   | DETROIT_DLSS_CREATE_AUTO_EXPOSURE)

typedef uint64_t DetroitDlssVerificationFlags;
#define DETROIT_DLSS_VERIFY_RESOURCE_SEMANTICS                (UINT64_C(1) << 0u)
#define DETROIT_DLSS_VERIFY_DESCRIPTOR_SET_AND_LAYOUTS        (UINT64_C(1) << 1u)
#define DETROIT_DLSS_VERIFY_CONSTANTS_DECODED                 (UINT64_C(1) << 2u)
#define DETROIT_DLSS_VERIFY_JITTER_DECODED                    (UINT64_C(1) << 3u)
#define DETROIT_DLSS_VERIFY_DEPTH_CONVENTION                  (UINT64_C(1) << 4u)
#define DETROIT_DLSS_VERIFY_MOTION_VECTOR_DIRECTION_AND_SCALE (UINT64_C(1) << 5u)
#define DETROIT_DLSS_VERIFY_MOTION_VECTORS_INCLUDE_CAMERA     (UINT64_C(1) << 6u)
#define DETROIT_DLSS_VERIFY_CURRENT_COLOR_IS_UI_FREE          (UINT64_C(1) << 7u)
#define DETROIT_DLSS_VERIFY_EXPOSURE                          (UINT64_C(1) << 8u)
#define DETROIT_DLSS_VERIFY_DIMENSIONS                        (UINT64_C(1) << 9u)
#define DETROIT_DLSS_VERIFY_HISTORY                           (UINT64_C(1) << 10u)
#define DETROIT_DLSS_VERIFY_MANDATORY_MASK                 \
  (DETROIT_DLSS_VERIFY_RESOURCE_SEMANTICS                  \
   | DETROIT_DLSS_VERIFY_DESCRIPTOR_SET_AND_LAYOUTS        \
   | DETROIT_DLSS_VERIFY_CONSTANTS_DECODED                 \
   | DETROIT_DLSS_VERIFY_JITTER_DECODED                    \
   | DETROIT_DLSS_VERIFY_DEPTH_CONVENTION                  \
   | DETROIT_DLSS_VERIFY_MOTION_VECTOR_DIRECTION_AND_SCALE \
   | DETROIT_DLSS_VERIFY_MOTION_VECTORS_INCLUDE_CAMERA     \
   | DETROIT_DLSS_VERIFY_CURRENT_COLOR_IS_UI_FREE          \
   | DETROIT_DLSS_VERIFY_EXPOSURE                          \
   | DETROIT_DLSS_VERIFY_DIMENSIONS                        \
   | DETROIT_DLSS_VERIFY_HISTORY)

typedef uint64_t DetroitDlssEvaluateFlags;
#define DETROIT_DLSS_EVALUATE_OUTPUT_VALID       (UINT64_C(1) << 0u)
#define DETROIT_DLSS_EVALUATE_USED_AUTO_EXPOSURE (UINT64_C(1) << 1u)

/*
 * Observed descriptor contract for shader 0xB5506A45. Names stay neutral
 * until runtime captures prove the semantics of every slot.
 */
#define DETROIT_DLSS_TAA_SAMPLED_BINDING_0       0u
#define DETROIT_DLSS_TAA_SAMPLED_BINDING_1       1u
#define DETROIT_DLSS_TAA_SAMPLED_BINDING_2       2u
#define DETROIT_DLSS_TAA_SAMPLED_BINDING_3       3u
#define DETROIT_DLSS_TAA_SAMPLED_BINDING_4       4u
#define DETROIT_DLSS_TAA_SAMPLED_BINDING_5       5u
#define DETROIT_DLSS_TAA_SAMPLED_BINDING_6       6u
#define DETROIT_DLSS_TAA_SAMPLED_BINDING_7       7u
#define DETROIT_DLSS_TAA_SAMPLED_BINDING_9       9u
#define DETROIT_DLSS_TAA_SAMPLED_BINDING_COUNT   9u
#define DETROIT_DLSS_TAA_STORAGE_BINDING_16      16u
#define DETROIT_DLSS_TAA_STORAGE_BINDING_17      17u
#define DETROIT_DLSS_TAA_STORAGE_BINDING_18      18u
#define DETROIT_DLSS_TAA_STORAGE_BINDING_19      19u
#define DETROIT_DLSS_TAA_STORAGE_BINDING_COUNT   4u
#define DETROIT_DLSS_TAA_CONSTANT_BINDING_52     52u
#define DETROIT_DLSS_TAA_DESCRIPTOR_SET          0u
#define DETROIT_DLSS_TEMPORAL_CONSTANTS_CAPACITY 1024u
#define DETROIT_DLSS_TAA_IMAGE_BINDING_COUNT     13u
/*
 * The native shader declares b0-b7 and b16-b19. Its pipeline layout also has
 * the inactive b9 slot, which the snapshot keeps for diagnostics. DLSS with
 * auto-exposure only consumes current color (b1), depth (b3), motion vectors
 * (b4), and the color output (b16). Native history and auxiliary outputs must
 * therefore remain observable without becoming prerequisites for NGX.
 */
#define DETROIT_DLSS_TAA_DECLARED_IMAGE_MASK UINT64_C(0x000F00FF)
#define DETROIT_DLSS_TAA_REQUIRED_IMAGE_MASK UINT64_C(0x0001001A)
#define DETROIT_DLSS_TAA_OPTIONAL_IMAGE_MASK UINT64_C(0x000E02E5)

typedef uint64_t DetroitDlssTemporalConstantsValidFlags;
#define DETROIT_DLSS_CONSTANTS_DESCRIPTOR_VALID       (UINT64_C(1) << 0u)
#define DETROIT_DLSS_CONSTANTS_DYNAMIC_OFFSET_VALID   (UINT64_C(1) << 1u)
#define DETROIT_DLSS_CONSTANTS_EFFECTIVE_OFFSET_VALID (UINT64_C(1) << 2u)
#define DETROIT_DLSS_CONSTANTS_RANGE_VALID            (UINT64_C(1) << 3u)
#define DETROIT_DLSS_CONSTANTS_PAYLOAD_VALID          (UINT64_C(1) << 4u)
#define DETROIT_DLSS_CONSTANTS_MANDATORY_MASK      \
  (DETROIT_DLSS_CONSTANTS_DESCRIPTOR_VALID         \
   | DETROIT_DLSS_CONSTANTS_DYNAMIC_OFFSET_VALID   \
   | DETROIT_DLSS_CONSTANTS_EFFECTIVE_OFFSET_VALID \
   | DETROIT_DLSS_CONSTANTS_RANGE_VALID            \
   | DETROIT_DLSS_CONSTANTS_PAYLOAD_VALID)

typedef uint64_t DetroitDlssTemporalConstantsSourceFlags;
#define DETROIT_DLSS_CONSTANTS_SOURCE_MAPPED_MEMORY (UINT64_C(1) << 0u)
#define DETROIT_DLSS_CONSTANTS_SOURCE_SHADOW_COPY   (UINT64_C(1) << 1u)

typedef struct DetroitDlssBootstrapContext {
  uint32_t struct_size;
  uint32_t abi_version;
  uint64_t vk_instance;
  uint64_t vk_physical_device;
  uint64_t vk_device;
  uint64_t vk_graphics_queue;
  uint64_t vk_get_instance_proc_addr;
  uint64_t vk_get_device_proc_addr;
  uint32_t graphics_queue_family_index;
  uint32_t graphics_queue_index;
  DetroitDlssCapabilityFlags capability_flags;
  uint64_t enabled_extension_flags;
} DetroitDlssBootstrapContext;

typedef struct DetroitDlssResource {
  uint64_t image;
  uint64_t image_view;
  uint32_t format;
  uint32_t layout;
  uint32_t width;
  uint32_t height;
  uint32_t mip_level;
  uint32_t array_layer;
  uint32_t flags;
  uint32_t reserved;
} DetroitDlssResource;

typedef struct DetroitDlssTemporalConstantsSnapshot {
  uint32_t struct_size;
  uint32_t abi_version;
  uint32_t descriptor_set_index;
  uint32_t binding;
  uint64_t command_buffer;
  uint64_t descriptor_set;
  uint64_t pipeline_layout;
  uint64_t buffer;
  uint64_t descriptor_offset;
  uint64_t dynamic_offset;
  uint64_t effective_offset;
  uint64_t descriptor_range;
  uint32_t bytes_written;
  uint32_t descriptor_type;
  DetroitDlssTemporalConstantsValidFlags valid_flags;
  DetroitDlssTemporalConstantsSourceFlags source_flags;
  uint8_t constants[DETROIT_DLSS_TEMPORAL_CONSTANTS_CAPACITY];
} DetroitDlssTemporalConstantsSnapshot;

typedef uint64_t DetroitDlssImageSnapshotValidFlags;
#define DETROIT_DLSS_IMAGE_DESCRIPTOR_VALID        (UINT64_C(1) << 0u)
#define DETROIT_DLSS_IMAGE_VIEW_VALID              (UINT64_C(1) << 1u)
#define DETROIT_DLSS_IMAGE_VALID                   (UINT64_C(1) << 2u)
#define DETROIT_DLSS_IMAGE_FORMAT_VALID            (UINT64_C(1) << 3u)
#define DETROIT_DLSS_IMAGE_EXTENT_VALID            (UINT64_C(1) << 4u)
#define DETROIT_DLSS_IMAGE_SUBRESOURCE_VALID       (UINT64_C(1) << 5u)
#define DETROIT_DLSS_IMAGE_DESCRIPTOR_LAYOUT_VALID (UINT64_C(1) << 6u)
#define DETROIT_DLSS_IMAGE_MANDATORY_MASK \
  (DETROIT_DLSS_IMAGE_DESCRIPTOR_VALID    \
   | DETROIT_DLSS_IMAGE_VIEW_VALID        \
   | DETROIT_DLSS_IMAGE_VALID             \
   | DETROIT_DLSS_IMAGE_FORMAT_VALID      \
   | DETROIT_DLSS_IMAGE_EXTENT_VALID      \
   | DETROIT_DLSS_IMAGE_SUBRESOURCE_VALID \
   | DETROIT_DLSS_IMAGE_DESCRIPTOR_LAYOUT_VALID)

typedef uint64_t DetroitDlssDescriptorSourceFlags;
#define DETROIT_DLSS_DESCRIPTOR_SOURCE_DIRECT_WRITE (UINT64_C(1) << 0u)
#define DETROIT_DLSS_DESCRIPTOR_SOURCE_COPY         (UINT64_C(1) << 1u)

typedef uint64_t DetroitDlssTemporalSnapshotFlags;
#define DETROIT_DLSS_SNAPSHOT_COMMAND_TRACKED                (UINT64_C(1) << 0u)
#define DETROIT_DLSS_SNAPSHOT_SET_BOUND                      (UINT64_C(1) << 1u)
#define DETROIT_DLSS_SNAPSHOT_EXPECTED_SET_MATCH             (UINT64_C(1) << 2u)
#define DETROIT_DLSS_SNAPSHOT_EXPECTED_PIPELINE_LAYOUT_MATCH (UINT64_C(1) << 3u)
#define DETROIT_DLSS_SNAPSHOT_DESCRIPTOR_SET_TRACKED         (UINT64_C(1) << 4u)
#define DETROIT_DLSS_SNAPSHOT_PIPELINE_LAYOUT_TRACKED        (UINT64_C(1) << 5u)
#define DETROIT_DLSS_SNAPSHOT_REQUIRED_IMAGES_COMPLETE       (UINT64_C(1) << 6u)
#define DETROIT_DLSS_SNAPSHOT_CONSTANTS_DESCRIPTOR_VALID     (UINT64_C(1) << 7u)
#define DETROIT_DLSS_SNAPSHOT_CONSTANTS_PAYLOAD_VALID        (UINT64_C(1) << 8u)
#define DETROIT_DLSS_SNAPSHOT_MANDATORY_MASK              \
  (DETROIT_DLSS_SNAPSHOT_COMMAND_TRACKED                  \
   | DETROIT_DLSS_SNAPSHOT_SET_BOUND                      \
   | DETROIT_DLSS_SNAPSHOT_EXPECTED_SET_MATCH             \
   | DETROIT_DLSS_SNAPSHOT_EXPECTED_PIPELINE_LAYOUT_MATCH \
   | DETROIT_DLSS_SNAPSHOT_DESCRIPTOR_SET_TRACKED         \
   | DETROIT_DLSS_SNAPSHOT_PIPELINE_LAYOUT_TRACKED        \
   | DETROIT_DLSS_SNAPSHOT_REQUIRED_IMAGES_COMPLETE       \
   | DETROIT_DLSS_SNAPSHOT_CONSTANTS_DESCRIPTOR_VALID     \
   | DETROIT_DLSS_SNAPSHOT_CONSTANTS_PAYLOAD_VALID)

typedef uint32_t DetroitDlssTemporalSnapshotDetail;
#define DETROIT_DLSS_SNAPSHOT_DETAIL_NONE                       0u
#define DETROIT_DLSS_SNAPSHOT_DETAIL_DEVICE_UNAVAILABLE         1u
#define DETROIT_DLSS_SNAPSHOT_DETAIL_COMMAND_UNTRACKED          2u
#define DETROIT_DLSS_SNAPSHOT_DETAIL_SET_UNBOUND                3u
#define DETROIT_DLSS_SNAPSHOT_DETAIL_DESCRIPTOR_SET_MISMATCH    4u
#define DETROIT_DLSS_SNAPSHOT_DETAIL_PIPELINE_LAYOUT_MISMATCH   5u
#define DETROIT_DLSS_SNAPSHOT_DETAIL_DESCRIPTOR_SET_UNTRACKED   6u
#define DETROIT_DLSS_SNAPSHOT_DETAIL_PIPELINE_LAYOUT_UNTRACKED  7u
#define DETROIT_DLSS_SNAPSHOT_DETAIL_IMAGE_DESCRIPTOR_MISSING   8u
#define DETROIT_DLSS_SNAPSHOT_DETAIL_IMAGE_VIEW_UNTRACKED       9u
#define DETROIT_DLSS_SNAPSHOT_DETAIL_IMAGE_UNTRACKED            10u
#define DETROIT_DLSS_SNAPSHOT_DETAIL_IMAGE_METADATA_INCOMPLETE  11u
#define DETROIT_DLSS_SNAPSHOT_DETAIL_REQUIRED_IMAGES_INCOMPLETE 12u
#define DETROIT_DLSS_SNAPSHOT_DETAIL_CONSTANTS_UNAVAILABLE      13u

typedef uint32_t DetroitDlssTemporalConstantsDetail;
#define DETROIT_DLSS_CONSTANTS_DETAIL_NONE                     0u
#define DETROIT_DLSS_CONSTANTS_DETAIL_BINDING_UNTRACKED        1u
#define DETROIT_DLSS_CONSTANTS_DETAIL_DYNAMIC_OFFSET_INVALID   2u
#define DETROIT_DLSS_CONSTANTS_DETAIL_DESCRIPTOR_SET_UNTRACKED 3u
#define DETROIT_DLSS_CONSTANTS_DETAIL_DESCRIPTOR_MISSING       4u
#define DETROIT_DLSS_CONSTANTS_DETAIL_OFFSET_OVERFLOW          5u
#define DETROIT_DLSS_CONSTANTS_DETAIL_BUFFER_UNTRACKED         6u
#define DETROIT_DLSS_CONSTANTS_DETAIL_RANGE_INVALID            7u
#define DETROIT_DLSS_CONSTANTS_DETAIL_RANGE_TOO_SMALL          8u
#define DETROIT_DLSS_CONSTANTS_DETAIL_MEMORY_UNTRACKED         9u
#define DETROIT_DLSS_CONSTANTS_DETAIL_MEMORY_NOT_HOST_VISIBLE  10u
#define DETROIT_DLSS_CONSTANTS_DETAIL_MEMORY_NOT_MAPPED        11u
#define DETROIT_DLSS_CONSTANTS_DETAIL_MAPPED_RANGE_MISS        12u

typedef struct DetroitDlssImageBindingSnapshot {
  uint32_t struct_size;
  uint32_t binding;
  uint32_t array_element;
  uint32_t descriptor_type;
  uint64_t descriptor_set;
  uint64_t sampler;
  DetroitDlssResource resource;
  uint32_t image_format;
  uint32_t image_type;
  uint32_t view_type;
  uint32_t aspect_mask;
  uint32_t level_count;
  uint32_t layer_count;
  uint32_t image_mip_levels;
  uint32_t image_array_layers;
  uint32_t image_width;
  uint32_t image_height;
  uint32_t image_depth;
  uint32_t sample_count;
  uint32_t image_usage;
  uint32_t image_create_flags;
  DetroitDlssImageSnapshotValidFlags valid_flags;
  DetroitDlssDescriptorSourceFlags source_flags;
  uint64_t update_serial;
} DetroitDlssImageBindingSnapshot;

typedef struct DetroitDlssTemporalConstantsDiagnostics {
  uint32_t struct_size;
  DetroitDlssTemporalConstantsDetail detail_code;
  uint32_t buffer_usage;
  uint32_t memory_property_flags;
  uint64_t buffer_size;
  uint64_t allocation_size;
  uint64_t buffer_memory_offset;
  uint64_t mapped_offset;
  uint64_t mapped_size;
  uint64_t required_payload_size;
  DetroitDlssDescriptorSourceFlags descriptor_source_flags;
  uint64_t descriptor_update_serial;
} DetroitDlssTemporalConstantsDiagnostics;

typedef struct DetroitDlssTemporalDescriptorSnapshot {
  uint32_t struct_size;
  uint32_t abi_version;
  uint32_t descriptor_set_index;
  uint32_t image_binding_count;
  uint64_t command_buffer;
  uint64_t descriptor_set;
  uint64_t pipeline_layout;
  uint64_t compute_pipeline;
  uint64_t required_image_mask;
  uint64_t present_image_mask;
  uint64_t complete_image_mask;
  DetroitDlssTemporalSnapshotFlags snapshot_flags;
  DetroitDlssTemporalSnapshotDetail detail_code;
  uint32_t reserved;
  DetroitDlssImageBindingSnapshot
      images[DETROIT_DLSS_TAA_IMAGE_BINDING_COUNT];
  DetroitDlssTemporalConstantsSnapshot constants;
  DetroitDlssTemporalConstantsDiagnostics constants_diagnostics;
} DetroitDlssTemporalDescriptorSnapshot;

typedef struct DetroitDlssModeSettings {
  uint32_t struct_size;
  uint32_t abi_version;
  DetroitDlssMode mode;
  DetroitDlssCreateFlags create_flags;
  uint32_t output_width;
  uint32_t output_height;
  uint32_t render_width;
  uint32_t render_height;
  uint32_t min_render_width;
  uint32_t min_render_height;
  uint32_t max_render_width;
  uint32_t max_render_height;
} DetroitDlssModeSettings;

typedef struct DetroitDlssTemporalFrameInputs {
  uint32_t struct_size;
  uint32_t abi_version;
  uint32_t shader_crc;
  uint32_t descriptor_set_index;
  uint64_t command_buffer;
  uint64_t descriptor_set;
  uint64_t pipeline_layout;
  uint64_t constants_buffer;
  uint64_t constants_offset;
  uint64_t constants_size;
  DetroitDlssResource current_color;
  DetroitDlssResource depth;
  DetroitDlssResource motion_vectors;
  DetroitDlssResource exposure;
  DetroitDlssResource output;
  uint32_t render_width;
  uint32_t render_height;
  uint32_t output_width;
  uint32_t output_height;
  float jitter_x;
  float jitter_y;
  float motion_vector_scale_x;
  float motion_vector_scale_y;
  float pre_exposure;
  uint32_t reset;
  uint64_t frame_id;
  DetroitDlssFrameFlags flags;
  DetroitDlssVerificationFlags verification_flags;
  uint64_t reserved;
} DetroitDlssTemporalFrameInputs;

typedef struct DetroitDlssEvaluateResult {
  uint32_t struct_size;
  uint32_t abi_version;
  DetroitDlssResultCode status;
  uint32_t detail_code;
  uint64_t frame_id;
  DetroitDlssEvaluateFlags flags;
} DetroitDlssEvaluateResult;

typedef DetroitDlssResultCode(DETROIT_DLSS_CALL* DetroitDlssGetContextFn)(
    DetroitDlssBootstrapContext* context);
typedef DetroitDlssResultCode(DETROIT_DLSS_CALL* DetroitDlssGetTemporalConstantsFn)(
    uint64_t command_buffer,
    uint32_t descriptor_set_index,
    uint32_t binding,
    DetroitDlssTemporalConstantsSnapshot* snapshot);
typedef DetroitDlssResultCode(DETROIT_DLSS_CALL* DetroitDlssGetTemporalSnapshotFn)(
    uint64_t command_buffer,
    uint32_t descriptor_set_index,
    uint64_t expected_descriptor_set,
    uint64_t expected_pipeline_layout,
    DetroitDlssTemporalDescriptorSnapshot* snapshot);
typedef DetroitDlssResultCode(DETROIT_DLSS_CALL* DetroitDlssQueryModeFn)(
    DetroitDlssMode mode,
    uint32_t output_width,
    uint32_t output_height,
    DetroitDlssModeSettings* settings);
typedef DetroitDlssResultCode(DETROIT_DLSS_CALL* DetroitDlssConfigureFn)(
    const DetroitDlssModeSettings* settings);
typedef DetroitDlssResultCode(DETROIT_DLSS_CALL* DetroitDlssEvaluateFn)(
    const DetroitDlssTemporalFrameInputs* inputs,
    DetroitDlssEvaluateResult* result);
typedef void(DETROIT_DLSS_CALL* DetroitDlssShutdownFn)(void);

typedef struct DetroitDlssApiV2 {
  uint32_t struct_size;
  uint32_t abi_version;
  DetroitDlssGetContextFn get_context;
  DetroitDlssGetTemporalConstantsFn get_temporal_constants;
  DetroitDlssGetTemporalSnapshotFn get_temporal_snapshot;
  DetroitDlssQueryModeFn query_mode;
  DetroitDlssConfigureFn configure;
  DetroitDlssEvaluateFn evaluate;
  DetroitDlssShutdownFn shutdown;
} DetroitDlssApiV2;

typedef DetroitDlssResultCode(DETROIT_DLSS_CALL* DetroitDlssGetApiFn)(
    uint32_t requested_version,
    DetroitDlssApiV2* api);

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* RENODX_DETROITBECOMEHUMAN_DLSS_BRIDGE_ABI_H */
