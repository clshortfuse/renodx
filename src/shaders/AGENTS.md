# AGENTS: shared HLSL shaders

Scope: shared HLSL files in `src/shaders/`.

## Design rules

- Treat these files as shared shader library code used by multiple mods.
- Preserve existing function behavior and signatures unless the user explicitly asks for a migration.
- Avoid changes that increase register pressure or instruction count without a clear benefit.

## HLSL readability

- Follow the root HLSL readability rules instead of restating them here.
- Shared shader helpers must preserve existing signatures and be justified by reuse, a stable shader concept, or real complexity.

## Verification

- Build the smallest relevant game target that consumes the changed shader code.
- If a change affects visual output, document the expected runtime visual difference.