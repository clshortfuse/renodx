# Copilot Instructions for RenoDX

Use `AGENTS.md` as the primary repository guidance.

For workflow-specific RenoDX tasks, use `.agents/skills/README.md` to find the matching skill and read its `SKILL.md` before acting.

When performing a Copilot code review, apply the RenoDX review checklist in `.github/instructions/renodx-code-review.instructions.md` and the review-focused skill in `.github/skills/code-review/SKILL.md` when available. Do not leave a code review without a `RenoDX review checklist` section in the review body; mark each relevant checklist item as `Pass`, `Needs comment`, or `N/A`, and leave actionable comments for every `Needs comment` item. Review for RenoDX domain correctness and PR hygiene, not just buildability: flag PRs that do not preserve the vanilla/default look, treat HDR as extra contrast/saturation, clamp HDR through an SDR LUT without a proven bridge/tooling strategy, implement final-frame inverse tonemapping, default to scRGB without a rare-case justification instead of HDR10 with an SDR/HDR toggle, or include unrelated core/scratch files in a mod PR. Comments should be actionable and pattern-oriented; references to other mods should point to specific proven techniques, not imply the whole mod is authoritative.

Follow the nested `AGENTS.md` file for the folder being edited:

- `src/games/AGENTS.md` for game mod folders, shader naming, addon targets, and manual verification.
- `src/mods/AGENTS.md` for shared mod feature modules.
- `src/shaders/AGENTS.md` for shared HLSL shader library files.
- `src/utils/AGENTS.md` for shared C++ utility infrastructure and ReShade wrappers.

Keep this file short to avoid duplicating scoped instructions.