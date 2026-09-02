# Graph Report - detroitbecomehuman  (2026-08-11)

## Corpus Check
- 58 files · ~126,449 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1961 nodes · 3905 edges · 122 communities (121 shown, 1 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS · INFERRED: 13 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `822f83dd`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- DeviceState
- Tracker
- vulkan_layer.cpp
- VkDevice
- dlss_policy.hpp
- Client
- dof_runtime.hpp
- uint32_t
- ultrawide.hpp
- ToOpaque
- notes
- VkFence
- impl_
- EvaluationTraceRecord
- retinal_observability.hpp
- Constants
- ShaderInjectData
- AdapterResult
- ApplyRetinalDofFilter
- InstallUltrawidePatch
- Runtime
- FeatureRecordingRegistry
- ImageState
- AdapterPrepareInfo
- array
- English documentation
- OnPresent
- temporal_capture.hpp
- ImageDescriptorState
- DofCompositeImageSnapshot
- uint32_t
- FrameEligibility
- addon.cpp
- Capture
- retinal_math.hpp
- VkResult
- ReShadeCaptureState
- AdapterRuntimeCreateInfo
- .BindPass
- NVSDK_NGX_Result
- AdapterPreparedFrame
- SubmissionTraceTracker
- adapter_runtime.cpp
- BufferState
- render_debug.hpp
- SourceContract
- HookCreateDevice
- DETROIT_DLSS_CALL BridgeEvaluate
- string
- AfterNativeTemporalDispatch
- Config
- RuntimeController
- DescriptorSetLayoutState
- ImageShape
- Tracker
- DecodedConstants
- embedded_bootstrap.hpp
- NgxFrameParameters
- extension_probe.cpp
- Evaluation
- taa_contract.hpp
- CapturedImage
- ResolvedOverlay
- DescriptorSetState
- GetDofStatusText
- ResolvedSlot
- NativeTemporalFallbackGuard
- .CreateImage
- FeatureTransition
- RuntimeSupport
- StorageBinding
- NgxDiscovery
- SerializeExtensions
- Q: Сейчас при включении DLSS падает FPS, но нагрузка ни на CPU, ни на GPU не повышается
- MemoryState
- .CaptureTemporalSnapshot
- ExtensionCache
- FilterSample
- DofCompositeCommandState
- FeatureCreationGate
- DllMain
- command_list
- NgxDiscovery
- ContractShape
- Int4
- CoreInitializeProject
- Float4
- UltrawidePatchState
- FencedFeatureSubmission
- Q: Where does Detroit PsychoV convert tone-mapped BT.709 values before PQ output?
- Q: Why can switching between DLAA and native TAA produce a partially rendered frame?
- Q: Why does enabling the Detroit RenoDX addon reduce FPS from 144 to about 90 even with Native TAA?
- Q: Disable hook for dlaa for now and keep placeholder about it or comment in the code
- Q: Осталось глобальное замыливание
- Q: Глобального замыливания не осталось. Потом я решил проверить в главном меню и у меня вылетела игра
- Q: А не лучше ли уже тогда вмешаться в motion blur шейдер, чтобы накладывать лёгкий градиентный эффект по краям персонажа?
- Q: Вот тут заметнее всего, он слишком резкий
- Q: Does graph data identify 0xC03380A0 as the owner of the visible camera-motion-blur silhouette?
- Q: Всё равно не такой гладкий и незаметный переход как в vanilla
- Q: Why does the current Detroit Cinematic High DOF show a coarse transition across hair?
- Q: How should the current Detroit Cinematic High DOF handoff band be fixed?
- Q: Я сейчас понаблюдал, и эти стыки совпадают с DOF Coarse CoC
- Q: Стыки заметно ослабли и вообще не заметны, но появилась маска по контуру лица и волос
- Q: Can the Detroit AA-removal patch replace global Vulkan bind hooks for DLAA while preserving DOF?
- Q: Статичная копия появилась, по сглаживанию не могу визуально сказать, т.к. копия мешает. RenderDOC или renodx mcp поможет локализовать проблему?
- Q: Реализуй этот план
- dlss_bridge_client.hpp
- .MakeScratchResource
- CommandPoolState
- RestoreDofCompositeComputeState
- FeatureLifecycleDecision
- BindingContract
- Float3
- MeridianParameters
- EvaluationTraceConfiguration
- CompositeOutputSnapshot
- PipelineLayoutState
- ApplyNativeImage
- CoreQueryMode
- TraceCompletionCandidate
- TraceSubmissionCandidate
- Trace

## God Nodes (most connected - your core abstractions)
1. `DeviceState` - 210 edges
2. `impl_` - 65 edges
3. `ToOpaque()` - 59 edges
4. `Constants` - 40 edges
5. `size` - 31 edges
6. `Runtime` - 30 edges
7. `ShaderInjectData` - 29 edges
8. `EvaluationTraceRecord` - 28 edges
9. `Client` - 26 edges
10. `AdapterPrepareInfo` - 25 edges

## Surprising Connections (you probably didn't know these)
- `AfterNativeTemporalDispatch()` --references--> `DecodedConstants`  [INFERRED]
  temporal_capture.hpp → taa_contract.hpp
- `ReadExtensionCache()` --references--> `ExtensionCache`  [EXTRACTED]
  addon.cpp → dlss/embedded_bootstrap.hpp
- `AtomicWriteRipDisplacement()` --references--> `PatchOperationResult`  [EXTRACTED]
  addon.cpp → ultrawide.hpp
- `FindUniquePattern()` --references--> `PatternByte`  [EXTRACTED]
  addon.cpp → ultrawide.hpp
- `GetRetinalCaptureDiagnostic()` --references--> `CaptureDiagnostic`  [EXTRACTED]
  addon.cpp → retinal_observability.hpp

## Import Cycles
- None detected.

## Communities (122 total, 1 thin omitted)

### Community 0 - "DeviceState"
Cohesion: 0.02
Nodes (106): atomic, mutex, unique_ptr, VkPhysicalDeviceMemoryProperties, DeviceState, adapter_available, adapter_runtime, available_internal_feature_fences (+98 more)

### Community 1 - "Tracker"
Cohesion: 0.10
Nodes (24): CommandAuthorization, Authorization, authorized, replacement_eligible, snapshot, CanUseNativeModeFastPath(), CanUseNativePostDispatchFastPath(), atomic (+16 more)

### Community 2 - "vulkan_layer.cpp"
Cohesion: 0.08
Nodes (40): BootstrapStatus, AttachEarlyHooks(), CheckSupportedHostExecutable(), CloseTraceFile(), CoreEndCommandBuffer(), CoreShutdown(), DetroitDlssBootstrapContext, DetroitDlssModeSettings (+32 more)

### Community 3 - "VkDevice"
Cohesion: 0.10
Nodes (57): CoreCreateCommandPool(), CoreDestroyCommandPool(), CoreDestroyFence(), CoreFreeCommandBuffers(), VkDescriptorSetLayout, VkDevice, VkDeviceSize, DestroyInternalFeatureFencePool() (+49 more)

### Community 4 - "dlss_policy.hpp"
Cohesion: 0.23
Nodes (16): DetroitDlssFrameFlags, CheckFrameEligibility(), CheckModeAvailability(), HasFixedNativeExtent(), HasFrameFlag(), DetroitDlssMode, DetroitDlssModeSettings, DetroitDlssResource (+8 more)

### Community 5 - "Client"
Cohesion: 0.13
Nodes (17): DetroitDlssGetApiFn, Client, api_, configured_, configured_settings_, connected_, context_, mutex_ (+9 more)

### Community 6 - "dof_runtime.hpp"
Cohesion: 0.07
Nodes (40): atomic_bool, FrameResult, mode, observed_pass_mask, status, atomic, atomic_uint32_t, RuntimeMode (+32 more)

### Community 7 - "uint32_t"
Cohesion: 0.10
Nodes (46): Dispatchable, AddWithoutOverflow(), BindingMask(), size, CanInsertComputeWriteBarrier(), CaptureDofCompositeImageSnapshot(), CommandDescriptorKey(), array (+38 more)

### Community 8 - "ultrawide.hpp"
Cohesion: 0.08
Nodes (36): Apply, DisplacementWriteAction, InstructionSize, PatternSize, Restore, ActiveValues, aspect_ratio, ui_scale (+28 more)

### Community 9 - "ToOpaque"
Cohesion: 0.17
Nodes (35): CompletedFeatureRecording, CompleteFeatureDevice(), CompleteFeatureFence(), CompleteFeatureQueue(), VkCommandBuffer, DetachTemporalConstantsBufferLocked(), next_get_fence_status, DiscardFeatureCommandBuffer() (+27 more)

### Community 10 - "notes"
Cohesion: 0.05
Nodes (40): deploy, api, architecture, detection, game_exe, platform, process_name, reshade_version_range (+32 more)

### Community 11 - "VkFence"
Cohesion: 0.23
Nodes (27): AppendFeatureSubmissionCandidate(), AppendTraceCompletionCandidates(), CaptureFeatureSubmission(), CaptureTraceSubmissionCandidates(), CommitFeatureSubmission(), CompleteUnfencedFeatureSubmissionFallback(), vector, CreateInternalFeatureFence() (+19 more)

### Community 12 - "impl_"
Cohesion: 0.06
Nodes (37): impl_, bundles, device, get_device_proc_addr, get_instance_proc_addr, idle_bundles, initialized, instance (+29 more)

### Community 13 - "EvaluationTraceRecord"
Cohesion: 0.10
Nodes (21): DetroitDlssMode, EvaluationTraceRecord, attempt, command_buffer, commit, commit_called, consumer_image, consumer_view (+13 more)

### Community 14 - "retinal_observability.hpp"
Cohesion: 0.09
Nodes (27): GetRetinalCaptureDiagnostic(), CaptureDiagnostic, embedded_detail, result, CaptureDiagnosticState, bits_, CaptureDiagnosticTransition, changed (+19 more)

### Community 15 - "Constants"
Cohesion: 0.06
Nodes (34): RawMatrix, Constants, contour_depth, contour_enable, debug_coord_x, debug_coord_y, debug_frame, debug_options (+26 more)

### Community 16 - "ShaderInjectData"
Cohesion: 0.06
Nodes (33): DecodeDofPackedScale(), PushData(), ShaderInjectData, cas_mode, cas_strength, color_grade_strength, diffuse_white_nits, dof_runtime_mode (+25 more)

### Community 17 - "AdapterResult"
Cohesion: 0.12
Nodes (23): AdapterStatus, BufferAllocation, AdapterResult, detail, status, vk_result, Initialize, Prepare (+15 more)

### Community 18 - "ApplyRetinalDofFilter"
Cohesion: 0.22
Nodes (11): ApplyRetinalDofFilter(), device, LogClass, RunResult, GetRetinalLogLevel(), GetRetinalRunResult(), OnDestroyDevice(), OnDestroyResource() (+3 more)

### Community 19 - "InstallUltrawidePatch"
Cohesion: 0.23
Nodes (15): AllocateNearPatchData(), AtomicWriteRipDisplacement(), optional, span, uint8_t, uintptr_t, FindUniquePattern(), ForceUltrawideRuntimeVanilla() (+7 more)

### Community 20 - "Runtime"
Cohesion: 0.12
Nodes (20): format, recursive_mutex, resource, array, device, pipeline_layout, RunResult, size_t (+12 more)

### Community 21 - "FeatureRecordingRegistry"
Cohesion: 0.16
Nodes (7): Capacity, FeatureRecordingRegistry, slots_, array, atomic, uint64_t, Slot

### Community 22 - "ImageState"
Cohesion: 0.07
Nodes (30): CaptureNativeOutputTrackedState(), DetroitDlssResource, TrackedImageState, VkFormat, VkImageSubresourceRange, ImageState, array_layers, extent (+22 more)

### Community 23 - "AdapterPrepareInfo"
Cohesion: 0.09
Nodes (22): AdapterPrepareInfo, command_buffer, current_color, depth, dlaa_sharpening, dlaa_sharpening_normalization, motion_vectors, output_color_pass (+14 more)

### Community 24 - "array"
Cohesion: 0.09
Nodes (24): array, span, uint32_t, uint8_t, GetPackColorSpirv(), GetPrepareColorMotionSpirv(), uint32_t, PackColorBindings (+16 more)

### Community 25 - "English documentation"
Cohesion: 0.07
Nodes (27): Detroit: Native DOF v2, English documentation, Example: clean focus transition, Example: recommended profile, Example: stronger background blur, How the fix works, Modes, Purpose (+19 more)

### Community 26 - "OnPresent"
Cohesion: 0.32
Nodes (12): IsHdrOutputColorSpace(), OnDestroySwapchain(), OnInitSwapchain(), OnPresent(), TrySaveRequestedReShadeScreenshot(), TryTrackGameSwapchain(), UpdatePeakBrightness(), UpdateUltrawideFromSwapchain() (+4 more)

### Community 27 - "temporal_capture.hpp"
Cohesion: 0.12
Nodes (26): CallbackResult, ConsumeDlssOutputForCommandList(), GetEvaluationSerial(), GetMode(), GetStatus(), GetTemporalDescriptorBinding(), command_list, DetroitDlssMode (+18 more)

### Community 28 - "ImageDescriptorState"
Cohesion: 0.12
Nodes (17): DetroitDlssDescriptorSourceFlags, BufferDescriptorState, buffer, descriptor_type, offset, range, source_flags, update_serial (+9 more)

### Community 29 - "DofCompositeImageSnapshot"
Cohesion: 0.12
Nodes (16): DofCompositeImageSnapshot, binding, command_buffer, compute_pipeline, depth, descriptor_set, descriptor_set_index, dynamic_offset (+8 more)

### Community 30 - "uint32_t"
Cohesion: 0.16
Nodes (18): descriptor_range, descriptor_table, DeviceData, shader_stage, CaptureImage(), device, pipeline_layout, uint32_t (+10 more)

### Community 31 - "FrameEligibility"
Cohesion: 0.12
Nodes (17): FinalizeFrame(), FrameEligibility, evaluate_dlss, preserve_native_taa, reason, use_auto_exposure, FrameOutcome, preserve_native_taa (+9 more)

### Community 32 - "addon.cpp"
Cohesion: 0.16
Nodes (25): ApplyAspectRatioMode(), ApplyDlssMode(), AttachAddon(), Source, GetRenderDebugConfig(), GetRenderDebugSource(), IsDofSupportedBuild(), MigrateDlssModeSettings() (+17 more)

### Community 33 - "Capture"
Cohesion: 0.19
Nodes (14): Capture, embedded_detail, native, output, result, CaptureCompositeOutput(), CaptureResult, command_list (+6 more)

### Community 34 - "retinal_math.hpp"
Cohesion: 0.23
Nodes (19): Meridian, ComputeAdditionalGaussianSigmaPixels(), ComputeBinocularSpacingDegrees(), ComputeFilterSample(), ComputeGaussianWeight(), ComputeKernelRadius(), ComputeMidgetDensityPerSquareDegree(), ComputeMonocularSpacingDegrees() (+11 more)

### Community 35 - "VkResult"
Cohesion: 0.12
Nodes (18): RestoreVulkanLayerDispatchPointer(), CoreAllocateCommandBuffers(), CoreBeginCommandBuffer(), CoreCreateFence(), CoreSubmit(), CoreWaitForFences(), VkResult, next_allocate_command_buffers (+10 more)

### Community 36 - "ReShadeCaptureState"
Cohesion: 0.10
Nodes (21): DetroitDlssMode, time_point, uint64_t, DlaaSharpeningGate, active, exact_command_list_match, mode, strength (+13 more)

### Community 37 - "AdapterRuntimeCreateInfo"
Cohesion: 0.11
Nodes (19): AdapterRuntimeCreateInfo, device, get_device_proc_addr, get_instance_proc_addr, instance, maximum_scratch_bundles, memory_properties, physical_device (+11 more)

### Community 38 - ".BindPass"
Cohesion: 0.40
Nodes (4): FilterConstants, command_list, pipeline, resource_view

### Community 39 - "NVSDK_NGX_Result"
Cohesion: 0.27
Nodes (12): CoreAllocateParameters(), CoreCreateFeature(), CoreDestroyParameters(), CoreEvaluateFeature(), CoreGetCapabilityParameters(), CoreGetParameterI(), CoreReleaseFeature(), EvaluateInfo (+4 more)

### Community 40 - "AdapterPreparedFrame"
Cohesion: 0.11
Nodes (18): AdapterPreparedFrame, color, color_state, command_buffer, depth, motion_vectors, native_output_state, output (+10 more)

### Community 41 - "SubmissionTraceTracker"
Cohesion: 0.05
Nodes (42): Attempt, EvaluationTerminalName(), FirstThreeAttemptWindow, kAttemptLimit, state_, atomic, EvaluationTerminal, Handle (+34 more)

### Community 42 - "adapter_runtime.cpp"
Cohesion: 0.22
Nodes (12): AdapterRuntime, CommitAfterNgx, Discard, IsInitialized, NotifyCommandBufferBegin, RecycleCommandBuffer, Shutdown, TakeCompletedTraceReadback (+4 more)

### Community 43 - "BufferState"
Cohesion: 0.15
Nodes (13): BufferState, memory, memory_offset, shadow_bytes, shadow_valid_bytes, temporal_constants_candidate, temporal_slot_hashes, temporal_slot_hashes_primed (+5 more)

### Community 44 - "render_debug.hpp"
Cohesion: 0.20
Nodes (11): FrameResult, observed_pass_mask, payload, required_pass_mask, status, HasUnavailableSource(), uint32_t, PackBits() (+3 more)

### Community 45 - "SourceContract"
Cohesion: 0.12
Nodes (15): Access, Decoder, ProducerPass, string_view, SourceContract, access, binding, decoder (+7 more)

### Community 46 - "HookCreateDevice"
Cohesion: 0.15
Nodes (21): BuildCachedExtensionList(), PFN_vkGetInstanceProcAddr, uintptr_t, VkInstance, DispatchKey(), EnsureInstanceState(), FindInstance(), FindTrackedDeviceFunction() (+13 more)

### Community 47 - "DETROIT_DLSS_CALL BridgeEvaluate"
Cohesion: 0.10
Nodes (24): BridgeDetail, DetroitDlssCreateFlags, CanRestoreComputeCommandState(), CaptureComputeRestoreState(), ComputeCommandRestoreState, descriptor_layout, descriptor_sets, dynamic_offsets (+16 more)

### Community 48 - "string"
Cohesion: 0.13
Nodes (19): ApplyPeakBrightness(), level, string, vector, wchar_t, EnsureLoadFromDllMainEntry(), GetDisplayName(), InitializeReShadeCaptureRequest() (+11 more)

### Community 49 - "AfterNativeTemporalDispatch"
Cohesion: 0.27
Nodes (10): CommandContext, DispatchArguments, AfterNativeTemporalDispatch(), DetroitDlssTemporalConstantsDiagnostics, DetroitDlssTemporalConstantsSnapshot, level, string, format (+2 more)

### Community 50 - "Config"
Cohesion: 0.15
Nodes (15): Channel, DashboardPreset, Config, channel, custom_slots, dashboard, mapping, mode (+7 more)

### Community 51 - "RuntimeController"
Cohesion: 0.14
Nodes (11): atomic, atomic_uint32_t, mutex, RuntimeStatus, RuntimeController, config_, config_mutex_, last_observed_pass_mask_ (+3 more)

### Community 52 - "DescriptorSetLayoutState"
Cohesion: 0.21
Nodes (12): DescriptorLayoutBinding, binding, descriptor_count, descriptor_type, DescriptorSetLayoutState, bindings, dof_composite_candidate, temporal_candidate (+4 more)

### Community 53 - "ImageShape"
Cohesion: 0.25
Nodes (7): GetShape(), ImageShape, array_layer, height, layout, mip_level, width

### Community 54 - "Tracker"
Cohesion: 0.20
Nodes (9): uint32_t, uint64_t, Snapshot, descriptor_set, pipeline_layout, Tracker, descriptor_set_, pipeline_layout_ (+1 more)

### Community 55 - "DecodedConstants"
Cohesion: 0.17
Nodes (12): byte, CheckPlausibility(), DecodeConstants(), DecodedConstants, plausibility, raw, optional, span (+4 more)

### Community 56 - "embedded_bootstrap.hpp"
Cohesion: 0.31
Nodes (12): CanAttachEarlyHooks(), EqualsInsensitiveAscii(), FileName(), DetroitDlssMode, string, string_view, vector, IsValidCache() (+4 more)

### Community 57 - "NgxFrameParameters"
Cohesion: 0.15
Nodes (12): NgxFrameParameters, constants_valid, dimensions_valid, history_valid, jitter_valid, jitter_x, jitter_y, motion_vector_scale (+4 more)

### Community 58 - "extension_probe.cpp"
Cohesion: 0.33
Nodes (11): BuildProbeEnvironment(), HMODULE, wstring, EqualsInsensitive(), GetModulePath(), IsBlockedEnvironmentEntry(), IsExtensionProbeHost(), QueryRequiredExtensionsIsolated() (+3 more)

### Community 59 - "Evaluation"
Cohesion: 0.22
Nodes (9): Evaluation, bridge_detail, effective_reset, output_valid, reason, status, suppress_final_cas, DetroitDlssResultCode (+1 more)

### Community 60 - "taa_contract.hpp"
Cohesion: 0.31
Nodes (9): BuildNgxFrameParameters(), Float2, x, y, GetNgxJitterOffset(), GetNgxMotionVectorScale(), uint32_t, IsRequiredSampledBinding() (+1 more)

### Community 61 - "CapturedImage"
Cohesion: 0.17
Nodes (12): CapturedImage, array_layer, format, height, image, image_view, layout, mip_level (+4 more)

### Community 62 - "ResolvedOverlay"
Cohesion: 0.18
Nodes (11): Mapping, OverlayMode, ResolvedOverlay, channel, mapping, mode, opacity, show_fixation (+3 more)

### Community 63 - "DescriptorSetState"
Cohesion: 0.11
Nodes (26): BoundDescriptorState, descriptor_set, dynamic_offset, dynamic_offset_valid, pipeline_layout, DWORD, optional, size_t (+18 more)

### Community 64 - "GetDofStatusText"
Cohesion: 0.33
Nodes (6): RuntimeStatus, string_view, GetDofStatusText(), LogDofStatus(), UpdateDofRuntimeMode(), FrameResult

### Community 65 - "ResolvedSlot"
Cohesion: 0.20
Nodes (10): buffer_range, descriptor_type, resource_view, ResolvedSlot, buffer, found, set_index, table (+2 more)

### Community 66 - "NativeTemporalFallbackGuard"
Cohesion: 0.24
Nodes (9): Context, Snapshot, pipeline, NativeTemporalFallbackGuard, armed, context, mode_snapshot, native_pipeline (+1 more)

### Community 67 - ".CreateImage"
Cohesion: 0.22
Nodes (6): ColorSubresourceRange(), VkFormat, VkImageSubresourceRange, ImageAllocation, VkExtent2D, VkFormatFeatureFlags

### Community 68 - "FeatureTransition"
Cohesion: 0.25
Nodes (8): FeatureTransition, camera_cut, feature_exists, manual_reset, mode_changed, output_extent_changed, render_extent_changed, scene_loaded

### Community 69 - "RuntimeSupport"
Cohesion: 0.25
Nodes (8): RuntimeSupport, auto_exposure_available, bridge_abi_version, bridge_available, dlaa_available, executable_supported, ngx_initialized, temporal_interface_verified

### Community 70 - "StorageBinding"
Cohesion: 0.20
Nodes (8): string_view, SampledBinding, binding, shader_name, StorageBinding, binding, shader_name, storage_format

### Community 71 - "NgxDiscovery"
Cohesion: 0.22
Nodes (9): NVSDK_NGX_FeatureCommonInfo, NVSDK_NGX_FeatureDiscoveryInfo, wchar_t, NgxDiscovery, data_path, discovery_info, feature_info, feature_path (+1 more)

### Community 72 - "SerializeExtensions"
Cohesion: 0.50
Nodes (5): uint32_t, VkExtensionProperties, VkPhysicalDevice, SerializeExtensions(), SupportsDeviceExtensions()

### Community 73 - "Q: Сейчас при включении DLSS падает FPS, но нагрузка ни на CPU, ни на GPU не повышается"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: Сейчас при включении DLSS падает FPS, но нагрузка ни на CPU, ни на GPU не повышается, Source Nodes

### Community 74 - "MemoryState"
Cohesion: 0.22
Nodes (9): VkMemoryPropertyFlags, MemoryState, allocation_size, mapped_offset, mapped_pointer, mapped_size, memory_type_index, property_flags (+1 more)

### Community 75 - ".CaptureTemporalSnapshot"
Cohesion: 0.33
Nodes (5): DetroitDlssImageBindingSnapshot, DetroitDlssTemporalConstantsSnapshot, DetroitDlssTemporalDescriptorSnapshot, uint64_t, IsTemporalImageSnapshotAccepted()

### Community 76 - "ExtensionCache"
Cohesion: 0.13
Nodes (19): WriteExtensionCache(), ExtensionCache, device_extensions, executable_sha256, instance_extensions, ready, schema_version, uint32_t (+11 more)

### Community 77 - "FilterSample"
Cohesion: 0.22
Nodes (9): FilterSample, eccentricity_degrees, horizontal_eccentricity_degrees, horizontal_pixels_per_degree, horizontal_sigma_pixels, retinal_nyquist_cycles_per_degree, vertical_eccentricity_degrees, vertical_pixels_per_degree (+1 more)

### Community 78 - "DofCompositeCommandState"
Cohesion: 0.12
Nodes (16): unordered_map, VkPipeline, DofCompositeCommandState, descriptor_set, dynamic_offset, dynamic_offset_valid, pipeline, pipeline_layout (+8 more)

### Community 79 - "FeatureCreationGate"
Cohesion: 0.32
Nodes (4): FeatureCreationGate, command_buffer, submitted, Handle

### Community 80 - "DllMain"
Cohesion: 0.29
Nodes (8): DWORD, HMODULE, path, DetachAddon(), DllMain(), GetModulePath(), BOOL, LPVOID

### Community 81 - "command_list"
Cohesion: 0.19
Nodes (15): ApplyDlssOutputMarker(), command_list, uint32_t, GetDlaaSharpeningGate(), GetRuntimeFlags(), IsSharedHdrIntermediateTarget(), OnDofFillDraw(), OnDofGatherDraw() (+7 more)

### Community 82 - "NgxDiscovery"
Cohesion: 0.25
Nodes (7): NVSDK_NGX_FeatureDiscoveryInfo, NgxDiscovery, data_path, discovery_info, feature_info, feature_path, feature_paths

### Community 83 - "ContractShape"
Cohesion: 0.25
Nodes (7): ContractShape, constants_descriptor_type, constants_size, pipeline_layout, sampled, storage, array

### Community 84 - "Int4"
Cohesion: 0.29
Nodes (6): int32_t, Int4, w, x, y, z

### Community 85 - "CoreInitializeProject"
Cohesion: 0.29
Nodes (7): CoreInitializeProject(), NVSDK_NGX_FeatureCommonInfo, PFN_vkGetDeviceProcAddr, VkPhysicalDevice, wchar_t, NVSDK_NGX_EngineType, NVSDK_NGX_Version

### Community 86 - "Float4"
Cohesion: 0.33
Nodes (5): Float4, w, x, y, z

### Community 87 - "UltrawidePatchState"
Cohesion: 0.13
Nodes (15): array, int32_t, RefreshUltrawideValues(), StoreRuntimeFloat(), UltrawidePatchState, active_patches, displacement_addresses, original_displacements (+7 more)

### Community 88 - "FencedFeatureSubmission"
Cohesion: 0.40
Nodes (5): FencedFeatureSubmission, owned_by_layer, queue, snapshot, SubmissionSnapshot

### Community 89 - "Q: Where does Detroit PsychoV convert tone-mapped BT.709 values before PQ output?"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: Where does Detroit PsychoV convert tone-mapped BT.709 values before PQ output?, Source Nodes

### Community 90 - "Q: Why can switching between DLAA and native TAA produce a partially rendered frame?"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: Why can switching between DLAA and native TAA produce a partially rendered frame?, Source Nodes

### Community 91 - "Q: Why does enabling the Detroit RenoDX addon reduce FPS from 144 to about 90 even with Native TAA?"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: Why does enabling the Detroit RenoDX addon reduce FPS from 144 to about 90 even with Native TAA?, Source Nodes

### Community 92 - "Q: Disable hook for dlaa for now and keep placeholder about it or comment in the code"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: Disable hook for dlaa for now and keep placeholder about it or comment in the code, Source Nodes

### Community 93 - "Q: Осталось глобальное замыливание"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: Осталось глобальное замыливание, Source Nodes

### Community 94 - "Q: Глобального замыливания не осталось. Потом я решил проверить в главном меню и у меня вылетела игра"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: Глобального замыливания не осталось. Потом я решил проверить в главном меню и у меня вылетела игра, Source Nodes

### Community 95 - "Q: А не лучше ли уже тогда вмешаться в motion blur шейдер, чтобы накладывать лёгкий градиентный эффект по краям персонажа?"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: А не лучше ли уже тогда вмешаться в motion blur шейдер, чтобы накладывать лёгкий градиентный эффект по краям персонажа?, Source Nodes

### Community 96 - "Q: Вот тут заметнее всего, он слишком резкий"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: Вот тут заметнее всего, он слишком резкий, Source Nodes

### Community 97 - "Q: Does graph data identify 0xC03380A0 as the owner of the visible camera-motion-blur silhouette?"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: Does graph data identify 0xC03380A0 as the owner of the visible camera-motion-blur silhouette?, Source Nodes

### Community 98 - "Q: Всё равно не такой гладкий и незаметный переход как в vanilla"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: Всё равно не такой гладкий и незаметный переход как в vanilla, Source Nodes

### Community 99 - "Q: Why does the current Detroit Cinematic High DOF show a coarse transition across hair?"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: Why does the current Detroit Cinematic High DOF show a coarse transition across hair?, Source Nodes

### Community 100 - "Q: How should the current Detroit Cinematic High DOF handoff band be fixed?"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: How should the current Detroit Cinematic High DOF handoff band be fixed?, Source Nodes

### Community 101 - "Q: Я сейчас понаблюдал, и эти стыки совпадают с DOF Coarse CoC"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: Я сейчас понаблюдал, и эти стыки совпадают с DOF Coarse CoC, Source Nodes

### Community 102 - "Q: Стыки заметно ослабли и вообще не заметны, но появилась маска по контуру лица и волос"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: Стыки заметно ослабли и вообще не заметны, но появилась маска по контуру лица и волос, Source Nodes

### Community 103 - "Q: Can the Detroit AA-removal patch replace global Vulkan bind hooks for DLAA while preserving DOF?"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: Can the Detroit AA-removal patch replace global Vulkan bind hooks for DLAA while preserving DOF?, Source Nodes

### Community 104 - "Q: Статичная копия появилась, по сглаживанию не могу визуально сказать, т.к. копия мешает. RenderDOC или renodx mcp поможет локализовать проблему?"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: Статичная копия появилась, по сглаживанию не могу визуально сказать, т.к. копия мешает. RenderDOC или renodx mcp поможет локализовать проблему?, Source Nodes

### Community 105 - "Q: Реализуй этот план"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: Реализуй этот план, Source Nodes

### Community 107 - ".MakeScratchResource"
Cohesion: 0.40
Nodes (5): DetroitDlssResource, Handle, uint64_t, FromOpaque(), ToOpaque()

### Community 108 - "CommandPoolState"
Cohesion: 0.50
Nodes (4): CommandPoolState, flags, queue_family_index, VkCommandPoolCreateFlags

### Community 109 - "RestoreDofCompositeComputeState"
Cohesion: 0.50
Nodes (4): next_cmd_bind_descriptor_sets, next_cmd_bind_pipeline, next_cmd_push_constants, RestoreDofCompositeComputeState()

### Community 110 - "FeatureLifecycleDecision"
Cohesion: 0.40
Nodes (5): FeatureLifecycleDecision, create_feature, recreate_feature, release_feature, reset_history

### Community 111 - "BindingContract"
Cohesion: 0.50
Nodes (4): BindingContract, binding, descriptor_set, shader_crc

### Community 112 - "Float3"
Cohesion: 0.50
Nodes (4): Float3, x, y, z

### Community 113 - "MeridianParameters"
Cohesion: 0.50
Nodes (4): MeridianParameters, exponential_scale_degrees, mixture, rational_scale_degrees

### Community 114 - "EvaluationTraceConfiguration"
Cohesion: 0.67
Nodes (3): EvaluationTraceConfiguration, first_three, readback

### Community 115 - "CompositeOutputSnapshot"
Cohesion: 0.10
Nodes (20): mutex, Flags, Float2, CompositeOutputSnapshot, array_layer, height, mip_level, unordered_access_view (+12 more)

### Community 116 - "PipelineLayoutState"
Cohesion: 0.50
Nodes (4): PipelineLayoutState, push_constant_ranges, set_layouts, VkPushConstantRange

### Community 117 - "ApplyNativeImage"
Cohesion: 0.67
Nodes (4): ApplyNativeImage(), FindNativeImage(), DetroitDlssImageBindingSnapshot, DetroitDlssTemporalDescriptorSnapshot

### Community 118 - "CoreQueryMode"
Cohesion: 0.67
Nodes (3): CoreQueryMode(), ModeQuery, ModeSettings

### Community 119 - "TraceCompletionCandidate"
Cohesion: 0.67
Nodes (3): TraceCompletionCandidate, command_buffer, recording_epoch

### Community 120 - "TraceSubmissionCandidate"
Cohesion: 0.67
Nodes (3): TraceSubmissionCandidate, command_buffer, recording_generation

### Community 129 - "Trace"
Cohesion: 0.38
Nodes (7): EvaluationTerminal, string_view, format, Trace(), TraceEvaluationTerminal(), TraceNgxCallName(), TraceNgxFailureOnce()

## Knowledge Gaps
- **720 isolated node(s):** `aspect_ratio_bits`, `ui_scale_bits`, `displacement_addresses`, `original_displacements`, `redirected_displacements` (+715 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **1 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Work-memory lessons

**Preferred sources** — corroborated by past sessions; start here.
- `DescriptorSetState` (3× useful, score=2.946205038) _(code changed — re-verify)_
- `CommitAfterNgx` (2× useful, score=1.96654264)
- `AfterNativeTemporalDispatch()` (2× useful, score=1.96654264) _(code changed — re-verify)_
- `Example: clean focus transition` (2× useful, score=1.954813017)
- `NativeTemporalFallbackGuard` (2× useful, score=1.937114217) _(code changed — re-verify)_

**Known dead ends** — questions that led nowhere; don't re-derive.
- "Where does Detroit PsychoV convert tone-mapped BT.709 values before PQ output?" -> `tone_map_type`, `peak_white_nits`, `ShaderInjectData`
- "Вот тут заметнее всего, он слишком резкий" -> `ShaderInjectData`, `dof_runtime.hpp`, `motion_vectors`
- "Does graph data identify 0xC03380A0 as the owner of the visible camera-motion-blur silhouette?" -> `motion_vectors`, `blur_radius_percent`, `depth`

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `DeviceState` connect `DeviceState` to `Trace`, `vulkan_layer.cpp`, `VkDevice`, `uint32_t`, `ToOpaque`, `VkFence`, `FeatureRecordingRegistry`, `ImageState`, `VkResult`, `SubmissionTraceTracker`, `adapter_runtime.cpp`, `BufferState`, `HookCreateDevice`, `DETROIT_DLSS_CALL BridgeEvaluate`, `DescriptorSetLayoutState`, `DescriptorSetState`, `MemoryState`, `DofCompositeCommandState`, `NgxDiscovery`, `CoreInitializeProject`, `FencedFeatureSubmission`, `CommandPoolState`, `RestoreDofCompositeComputeState`, `PipelineLayoutState`?**
  _High betweenness centrality (0.166) - this node is a cross-community bridge._
- **Why does `impl_` connect `impl_` to `.CreateImage`, `adapter_runtime.cpp`, `.MakeScratchResource`, `AdapterResult`, `AdapterPrepareInfo`?**
  _High betweenness centrality (0.071) - this node is a cross-community bridge._
- **What connects `aspect_ratio_bits`, `ui_scale_bits`, `displacement_addresses` to the rest of the system?**
  _720 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `DeviceState` be split into smaller, more focused modules?**
  _Cohesion score 0.018867924528301886 - nodes in this community are weakly interconnected._
- **Should `Tracker` be split into smaller, more focused modules?**
  _Cohesion score 0.09682539682539683 - nodes in this community are weakly interconnected._
- **Should `vulkan_layer.cpp` be split into smaller, more focused modules?**
  _Cohesion score 0.08383838383838384 - nodes in this community are weakly interconnected._
- **Should `VkDevice` be split into smaller, more focused modules?**
  _Cohesion score 0.10025062656641603 - nodes in this community are weakly interconnected._