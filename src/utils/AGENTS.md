# AGENTS: shared C++ utility infrastructure

Scope: shared C++ utilities in `src/utils/`, including ReShade wrappers, resource helpers, shader utility code, IPC, logging, tracing, and command handling.

## Design rules

- Treat this folder as cross-mod infrastructure; changes can affect many game addons.
- Preserve API compatibility unless the user explicitly asks for a migration.
- Avoid hidden global behavior unless it matches existing shared utility patterns.
- Keep attach/detach, registration/unregistration, and resource lifetime paths symmetrical.

## C++ readability

- Follow the root C++ readability rules instead of restating them here.
- Before finalizing shared utility API changes, check whether the helper, callback, or wrapper is a real API boundary used by more than one caller.

## ReShade and shared state

- Cross-addon shared state must account for multiple modules registering the same utility.
- Event hooks should use existing shared registration patterns where available.
- If a utility wraps a ReShade event, keep callback signatures and bypass semantics explicit.

## Verification

- Build the smallest game target or utility target that exercises the changed utility.
- For broad utility changes, search for downstream uses before finalizing.