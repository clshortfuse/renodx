# RenoDX Workflow Skills

This folder contains project-local workflow skills for AI agents and contributors. Skills are on-demand procedures: use them when a task matches their domain instead of putting every workflow detail in always-on instructions.

RenoDX keeps shared workflow skills under `.agents/skills/` for the tool-neutral Agent Skills convention.

Default RenoDX mod behavior should be neutral: preserve the vanilla/original SDR art direction and extend its proven pipeline limits into HDR. Default settings should match the original look as closely as practical; visual augmentation belongs in explicit sliders or presets such as `HDR Look`, not in the baseline. Do not assume HDR means more contrast, more saturation, or a new look.

## How to use

- Agents: match the request to the table below, read the relevant `SKILL.md`, then follow its boundaries and handoffs.
- Users: mention the skill name or trigger terms in chat when you want a specific RenoDX workflow.
- Keep `AGENTS.md` for always-on repository rules; keep skills for specialized multi-step work.

## Skill index

| Skill | Use when | Handoff boundary |
|---|---|---|
| `setup-game-mod-dev` | Starting or resuming a game mod, setting up DevKit, configuring build targets, linking into a game folder, or creating baseline verification. | Hand off to `swapchain-resource-analysis` for resource/output proof and to `handle-sdr-tonemap-lut` for proven shader math. |
| `swapchain-resource-analysis` | Tracing final output, swapchain formats, render resources, `SwapChainPass`, proxy resources, SDR/HDR toggles, or proving whether scene HDR data still exists. | Hand off to `setup-game-mod-dev` for addon wiring/builds and to `handle-sdr-tonemap-lut` after the shader-side target signal is proven. |
| `handle-sdr-tonemap-lut` | Editing shader-side tonemap, hard clip, LUT/color grade, RenoDRT, PsychoV, gamut compression, or HDR bridge logic after upstream signals are known. | Hand off to `swapchain-resource-analysis` if the target pass/resource or source signal is not proven. |
| `analysis-graphing` | Creating dark-theme plots, curve comparisons, hue sweeps, gamut comparisons, LUT statistics, or image diagnostic panels. | Hand off to `hdr-test-pattern-generation` for source pattern generation and to `bt2020-png-generation` for final HDR PNG output. |
| `hdr-test-pattern-generation` | Generating deterministic SDR/HDR ramps, charts, sweeps, color bars, checkerboards, gamut stress images, or validation sources. | Hand off to `analysis-graphing` for plotting results and to `bt2020-png-generation` for PQ PNG encoding/signaling. |
| `bt2020-png-generation` | Producing or validating BT.2020/BT.2100 PQ PNGs, cICP chunks, ICC/cicpTag behavior, or HDR PNG artifacts from analysis data. | Hand off to `hdr-test-pattern-generation` for synthetic sources and to `analysis-graphing` for plots. |

## Maintenance notes

- The `description` field in each `SKILL.md` is the discovery surface. Put important trigger phrases there.
- Skill folders may include referenced templates, snippets, scripts, and resources; link them from `SKILL.md` so agents can load them when needed.
- Keep overlapping skills connected by explicit handoff text instead of copying the same procedure into multiple files.
- Keep examples tied to stable RenoDX concepts or committed project patterns.
- Validate changed Markdown files before committing.
