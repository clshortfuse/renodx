# AGENTS: shared mod modules

Scope: shared modules in `src/mods/` that game-specific addons include and configure.

## Responsibilities

- Treat files here as shared infrastructure for multiple game mods.
- Preserve existing APIs unless the user explicitly asks for a migration.
- Check representative consumers under `src/games/` before changing public structs, callbacks, settings, or lifecycle behavior.

## Coding guidance

- Keep configuration data visible at call sites when it describes game-specific behavior.
- Avoid adding abstraction layers that only wrap one module or one caller.
- Prefer opt-in behavior and backwards-compatible defaults for shared settings.
- Keep ReShade addon registration and unregistration balanced across attach/detach paths.

## Verification

- Build at least one affected game target that consumes the changed module.
- If behavior depends on runtime game state, document manual verification steps instead of inventing synthetic tests.