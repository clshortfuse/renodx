CODMW3 x64 V30 - V27-Fast Audio-Safe Stutter Fix
==================================================

Why V30 exists
--------------
The user's A/B result is decisive:
  V27 = traversal stutter largely fixed
  V28/V29 = traversal stutter returns

Source diff found the primary regression: V28 introduced a rule that left every
compressed IWD entry smaller than 256 KiB on MW3's bundled zlib 1.1.4. The bad
traversal workload is thousands of small archive operations, so that safety rule
put a large part of the original bottleneck back on the slow path.

V30 is therefore based on V27, not V28/V29.

What V30 keeps EXACTLY from V27's performance design
-----------------------------------------------------
- No <256 KiB stock-zlib cutoff.
- No delayed 120-Present / 75-ms-quiet zlib hook installation.
- No V28 promote/retire ownership rewrite.
- No V29 render-producer priority assist.
- Immediate V27-style zlib-ng shadow acceleration.
- Every compressed NON-AUDIO IWD entry is eligible, including tiny entries.
- Persistent mapped IWD cache.
- Exact CRT _read fast path.
- V27 archive burst detection/coalescing.
- V27 archive worker temporary ABOVE_NORMAL option/default.
- V27 precise renderer sleep/wait behavior.
- Renderer/query executable-byte experiments remain locked stock.
- Existing V27 settings keys are intentionally retained, so known-good V27
  settings carry straight into V30.

Minimal stability/audio additions
---------------------------------
1. sound/ asset bypass
   The exact x64 FS handle table associates the active minizip archive pointer
   with the normalized asset filename. Entries whose path begins sound/ or
   sound\ stay completely on MW3's original zlib 1.1.4. There is NO size cutoff
   for any other asset class.

2. stale stream-address protection
   V27 keys modern shadow state by MW3's z_stream address. V30 detects a fresh
   MW3 stream at an address that still has nonzero modern history and retires
   that stale modern shadow before creating a new one.

3. ownership beats settings
   If an entry already has a modern shadow, it finishes on that decoder even if
   the setting changes mid-entry. New settings apply on the next stream.

4. Escape/focus raw-mouse rebase
   Escape or focus loss clears the raw-mouse burst state before IW5 changes menu
   state. This does NOT disable zlib-ng, waits, or archive acceleration for a
   one-second window, so it does not reproduce V28's gameplay behavior.

zlib-ng DLL
-----------
V30 deliberately keeps the proven private DLL name:
  mw3_zlibng_v27.dll

If V27 already has that DLL beside iw5sp.exe, no DLL reinstall is required.
setup_zlibng_v30.ps1 is included for a fresh install.

Recommended first test
----------------------
Use the same V27 settings that were smooth. In particular:
  IWD Traversal Stream Cache       = Persistent Mapped IWD Cache
  IWD CRT Fast Read                = Fast Binary IWD _read
  IWD Modern DEFLATE Decoder       = Modern zlib-ng shadow inflater
  Archive Decode Worker Priority   = Temporary Above Normal During Burst
  Renderer wait/sleep/coalescing   = same values as working V27

Then test:
- the exact traversal spots where V28/V29 brought the hitch back;
- dialogue, weapons, ambience and music for repeating sounds;
- Escape repeatedly, including during/after asset-heavy traversal/checkpoints.

Expected log lines
------------------
[MW3 V30 Runtime] ... modern IWD inflate=zlib-ng ...
[MW3 V30 zlib-ng] first compressed IWD entry is using the modern shadow inflater...
[MW3 V30 Audio] sound/ IWD entries stay on stock zlib 1.1.4...

Build
-----
1. Run from this package, or copy files manually:
     .\install_v30_source.ps1 -RenoDXRoot <your-renodx-root>
2. Build:
     cmake --build --preset clang-x64-release --target CODMW3 --clean-first
3. Deploy the resulting renodx-CODMW3.addon64.

Validation note
---------------
Static validation against the exact supplied September-2026 x64 iw5sp.exe
passed. A final Windows clang-cl/RenoDX link cannot be performed in the current
Linux container, so the user's local RenoDX build remains the final compile/link
check.
