# AGENTS: RenoDX skill authoring

This folder contains project-local workflow skills. Keep skills focused, discoverable, and useful for agents that may not have prior RenoDX context.

## Skill frontmatter

- Each skill must use `SKILL.md` under `.agents/skills/<skill-name>/`.
- Keep `name` identical to the folder name.
- Quote `description` values, especially when they contain colons, commas, or trigger phrases.
- Treat `description` as the discovery surface: include the concrete words a user or agent will mention.
- Keep `argument-hint` short and focused on the minimum context needed to start the workflow.

## Bundled resources

- Skill folders may include `templates/`, `snippets/`, `scripts/`, `references/`, or other small support files.
- Reference any bundled file from `SKILL.md` with a relative Markdown link; agents load skill resources progressively and may not discover unreferenced files.
- Prefer small templates and snippets that remove repeated scratch scaffolds or copy-paste shader boilerplate.
- Do not bundle large captures, generated plots, game dumps, binaries, or one-off investigation artifacts.
- Keep snippets clearly marked as starting points, not copy-paste replacements for game-specific proof.

## Scope and overlap

- Keep always-on repository rules in root or nested `AGENTS.md`; keep task-specific procedures in skills.
- Start each broad skill with a short boundary or related-skills section when overlap is likely.
- Prefer handoff language over duplication when another skill owns the next step.
- Do not turn skills into scratch logs; move only stable workflow guidance into committed skill files.

## RenoDX-specific expectations

- Preserve the RenoDX distinction between upstream HDR/source recovery and final-frame inverse-tonemap postprocessing.
- Treat RenoDX mods as neutral by default: preserve vanilla/original SDR contrast, saturation, hue, and grade while extending proven range/resource limits into HDR. Default settings should match the original as closely as practical; visual augmentation belongs in explicit sliders or presets such as `HDR Look`. Do not bake in "HDR = more contrast/saturation" looks.
- For swapchain/resource work, keep `SwapChainPass`, proxy resources, output presets, color-space synchronization, and UI/HUD separation together.
- For shader math, require a proven target pass/resource before applying tonemap, LUT, hard-clip, or HDR bridge guidance.
- For analysis images and plots, keep source data and scripts reproducible and prefer dark-theme output.

## Maintenance checks

- After editing skills, validate Markdown diagnostics for the changed files.
- Check that new trigger phrases are in the relevant `description`, not only in the body.
- Keep `.agents/skills/README.md` in sync when adding, removing, or substantially changing a skill.
