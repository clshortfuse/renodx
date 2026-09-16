# Metadata-driven mods catalog

- Preserve existing metadata fields and expose maintainers, summary, notes, URLs,
  release status, and deployment requirements in the catalog.
- Add catalog category and compatibility fields without conflating compatibility
  with the existing release-channel status.
- Include metadata-only entries with external links, even without built artifacts.
- Generic-engine compatibility lives in GitHub Discussions, linked using
  `urls` with `kind: discussion`; do not import wiki compatibility tables.
- Auto-merge only metadata additions/modifications from an explicit YAML account
  allowlist. Validate against trusted base-branch schema, never execute PR code,
  and merge the validated head SHA without bypassing branch protections.
- Validate schema, manifest propagation, unsafe URL handling, and workflow gates.

## External wiki migration (2026-09-09)

- Source: https://raw.githubusercontent.com/wiki/clshortfuse/renodx/Mods.md
- Migrate missing primary-list external packages and all Related Mods, including
  third-party snapshot builds, Nexus, Discord, and GameBanana downloads.
- Enrich existing metadata rather than duplicate packages; group shared binaries
  using `games`. Preserve wiki credits and compatibility caveats, not release status.
- Do not invent store IDs, artwork, author credits, or discussion URLs.
- Omit generic RenoDX Discord invites from mod links; use mod-specific channels
  or threads. Crysis Remastered still needs such a link before catalog inclusion.
- The mods browser excludes `related` entries: non-RenoDX projects must not
  appear alongside RenoDX downloads, including within mixed-package game cards.
- Leave generic-engine compatibility tables and deprecated entries for their
  separate migration. Retain the wiki fallback.
- Validate metadata against the schema, regenerate the published-snapshot preview,
  run catalog tests, and inspect external-only cards. No game build is required
  for metadata-only folders; no addon implementation or binary is added.