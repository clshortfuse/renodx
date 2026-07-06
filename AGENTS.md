# AGENTS: RenoDX repository guidance

This file is the root, always-on guidance for AI coding agents. Keep it short. Put folder-specific rules in nested `AGENTS.md` files only when the subtree needs durable local rules.

## How AGENTS.md is layered

- Root `AGENTS.md` is the shared baseline for the repository.
- Nested `AGENTS.md` files apply to files under their directory; the closest/narrowest file should own conflicts.
- User chat instructions override repository instructions.
- Keep common policy here instead of repeating it in every nested file.
- Use nested files for folder-specific deltas such as shader naming, shared utility API constraints, skill-authoring rules, or per-game exceptions.
- Use workflow skills in `.agents/skills/` for task procedures; do not expand always-on `AGENTS.md` files with long workflow playbooks.

## Scoped guidance

- `.agents/skills/AGENTS.md` - authoring and maintenance rules for project workflow skills.
- `src/games/AGENTS.md` - game mod folders, shader naming, addon targets, and manual verification.
- `src/mods/AGENTS.md` - shared mod feature modules used by game-specific addons.
- `src/shaders/AGENTS.md` - shared HLSL shader library files.
- `src/utils/AGENTS.md` - shared C++ utility infrastructure and ReShade wrappers.

Nested `AGENTS.md` files require `chat.useNestedAgentsMdFiles` to be enabled in `.vscode/settings.json` for VS Code to load them automatically.

## Workflow skills

Project workflow skills live under `.agents/skills/<name>/SKILL.md`. When a request matches one of these domains, read the matching skill before planning or editing:

- `setup-game-mod-dev` - starting or resuming game mod development, DevKit setup, build targets, links, and baseline verification.
- `swapchain-resource-analysis` - swapchain/output tracing, resource formats, `SwapChainPass`, proxy resources, SDR/HDR output state, and rejecting final-SDR inverse-tonemap approaches.
- `handle-sdr-tonemap-lut` - shader-side tonemap, hard clip, LUT/color-grade, RenoDRT, PsychoV, and HDR bridge work after target signals are proven.
- `analysis-graphing` - dark-theme plots, curve comparisons, hue sweeps, LUT statistics, and other analysis figures.
- `hdr-test-pattern-generation` - deterministic SDR/HDR ramps, charts, sweeps, color bars, and synthetic validation images.
- `bt2020-png-generation` - BT.2020/BT.2100 PQ PNG output, cICP/ICC signaling, and HDR PNG validation.

For human discoverability, `.agents/skills/README.md` summarizes the skills and their handoff boundaries.

## Global rules

- Apply Don't Repeat Yourself logic (DRY) as much as possible.
- Don't create useless single-use functions.
- Keep changes small and scoped to the folder or subsystem requested.
- Do not change global CMake presets, CI workflows, vendored dependencies, or external submodules without explicit approval.
- Prefer existing project abstractions over new framework-style layers.
- For C++ and HLSL, do not extract single-use helpers for local control flow, one-off switches, simple casts, basic field access, or short condition checks.
- Only add helper functions when they are reused, enforce an invariant, name a stable domain concept, hide real complexity, or form a deliberate API boundary.
- Do not introduce named single-use locals that are only passed to the next call or immediately returned; construct the value at the call/return site unless the local is mutated, reused, or materially clarifies the code.
- For C++ parameters, use pointers for modifiable/out values and `const&` for non-modified inputs that should not be copied; avoid non-const references except established callback/API signatures.
- Validate changes with the smallest relevant build target or manual verification path.


