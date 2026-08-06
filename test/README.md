# Runtime tests

Configure with `RENODX_BUILD_TESTS=ON`, build the `renodx_test_suites` target,
then run the registered CTest tests.

## Compatibility contract

- Existing Direct3D and OpenGL mods built from `main` retain their public
  defaults and source conventions. In particular, an omitted
  `ViewBinding::space` remains register space 50 outside Vulkan, and ordinary
  `.frag.glsl`, `.vert.glsl`, and `.comp.glsl` files remain OpenGL sources.
- Mods based on the initial Vulkan PR only rename Vulkan entry shaders from
  `.glsl` to `.vk.glsl`; addon source and binding declarations do not change.
- On Vulkan, the legacy omitted `ViewBinding::space` value resolves to
  descriptor set 0. Explicit non-default descriptor sets remain unchanged.

The runtime tests use native D3D12 or Vulkan helpers and ReShade addon callbacks
or GPU readback. ReShade 6.7.3 is pinned by SHA-256. A matching
`bin/ReShade64.dll` is used when available; otherwise the official addon
package is downloaded and extracted when the test suite is built.

- `api_compatibility` compile-checks the public `main` configuration fields and
  the shader factory and macro exposed by the initial PR, then verifies
  backend-aware default-space resolution.
- `shader_source_compatibility` verifies that a main-style plain `.glsl` entry
  is still copied unchanged, while a renamed `.vk.glsl` entry is compiled to
  Vulkan SPIR-V and both remain available through `__ALL_CUSTOM_SHADERS`.
- `render_pass_behavior` verifies automatic, legacy mutable, and caller-owned
  descriptor-table paths with deterministic GPU readback.
- `resource_upgrade_transfer` verifies RGBA8 and RGB10A2 upload/readback through
  cloned RGBA16F resources. Vulkan controls first verify native packed transfer
  behavior, then independently validate application-visible readback and the
  normalized half-float texels stored by the upgraded transfer path.
- `swapchain_proxy_barrier_states` runs the production compatibility copy and
  `RenderPass` draw for 12 frames in Vulkan SDK `vkcube` with ReShade and the
  Khronos validation layer, covering image-layout and descriptor-set lifetime
  regressions.
- `shader_injection_behavior` verifies exact 64-DWORD root-signature injection,
  no-budget rejection, the exact `main` register-space 50 default across
  Direct3D and OpenGL, the safe Vulkan descriptor-set 0 interpretation,
  explicit Vulkan descriptor sets, descriptor mapping, and pipeline-layout
  destruction.