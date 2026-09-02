# AGENTS: game mod folders

Scope: `src/games/{gamename}` folders.

## Mod structure

- Each folder under `src/games/` is a mod.
- Keep changes local to one game folder unless cross-mod work is explicitly requested.
- New mods should start from `src/games/generic`.

## Shader files

- Shader files must be named `{CRC32}.{TARGET}.hlsl`.
- `{CRC32}` is a hex-formatted CRC32 such as `0xC0DEC0DE`.
- `{TARGET}` is the shader target such as `ps_6_6`.
- Generated shader headers are written to `embed/{CRC32}.h`.

## HLSL readability

- Follow the root HLSL readability rules instead of restating them here.
- Keep decompiled/original shader edits readable at the point of use, with game-specific reusable logic in nearby shared includes when warranted.

## Addon targets

- An `addon.cpp` in a game folder creates `renodx-{mod}.addon64` for 64-bit builds or `.addon32` for 32-bit builds.
- Prefer building the specific mod target instead of rebuilding the whole repository.

## Verification

- Include concise manual verification steps in the mod README or PR description.
- State the addon target to build, generated files to inspect, and runtime steps needed in the game.
- Automated tests are usually impractical for game mods; prefer exact build and runtime checks.

## PR notes

- PR title format: `[mod:{gamename}] Short summary`.
- Describe what changed, why it changed, and how it was manually verified.