# RenoDX Web UI

Modern web interface for browsing and downloading RenoDX mods.

## Structure

```
src/web/
  static/          # Static assets (favicon, images)
  scripts/         # JavaScript modules
    build.mjs      # Build script
    dev.mjs        # Development watch mode
    clean.mjs      # Clean artifacts
  index.html       # Entry point
  package.json     # Scripts configuration
```

## Development

```bash
# Watch mode (auto-rebuilds on changes)
cd src/web
npm run dev

# Manual build
npm run build

# Clean build artifacts
npm run clean
```

## Deployment

The build output goes to `githubrelease/`, which is served by GitHub Pages.

The CI workflow (`.github/workflows/snapshot.yml`) automatically:
1. Builds all mods
2. Copies binaries to `githubrelease/`
3. Generates manifest files
4. Builds the web UI
5. Deploys to GitHub Pages
