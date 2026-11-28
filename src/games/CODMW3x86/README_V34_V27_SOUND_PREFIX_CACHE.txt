Call of Duty: Modern Warfare 3 x64 - V34 V27-Fast Streamed-Sound Prefix Cache
=============================================================================

Target executable
-----------------
September-2026 x64 iw5sp.exe
SHA-256:
cfbe2c1826f623a43413db65d1cd8c2e003339ef92192303aba6d91c9f3a52bb

Why V34 exists
--------------
The A/B tests isolated two facts:

* V31/V27 all-entry zlib-ng acceleration removes the traversal stutter, but
  streamed audio repeats because modern zlib-ng rejects IW5's old null-output
  compressed seek convention.
* V32/V33 fix the audio by really performing those compressed seeks, but some
  stutter returns because the sound streamer repeatedly closes/reopens a ZIP
  entry and DEFLATE-decodes from byte zero up to its requested position.

V34 keeps the proven V27/V31 traversal path and removes that repeated audio
seek work instead of merely making the discard loop faster.

V34 streamed-sound cache
------------------------
The exact sound loader calls:

  iw5sp+0x30E43F -> FS_Seek
  iw5sp+0x30E450 -> FS_Read(..., 0x20000)

Only FS_Seek calls returning to iw5sp+0x30E444 mark a handle as streamed audio.
The handle filename must also begin with sound/ or sound\.

For that handle only, V34 creates a separate raw-DEFLATE zlib-ng decoder whose
input points directly into the already-existing persistent mapped IWD view.
It keeps an incrementally decoded prefix of the sound entry:

  * each requested uncompressed sound byte is DEFLATE-decoded at most once;
  * a forward seek extends the prefix only as far as necessary;
  * a backward/repeated seek reads the already-decoded prefix from memory;
  * the independent cache decoder survives IW5 closing/reopening its temporary
    minizip current-file/z_stream for a backward seek;
  * cache pages are committed lazily in 64 KiB chunks;
  * entries above 128 MiB or any validation/allocation/decode failure fall back
    to V33's correct compressed-seek path.

A critical minizip detail is handled correctly: current-file +0x58 is a MOVING
compressed-file cursor. V34 derives the original raw DEFLATE data start as:

  current_compressed_offset - (z_stream.total_in + z_stream.avail_in)

The exact executable disassembly validating +0x58 advancement and +0x6C
remaining-compressed accounting is included in VALIDATION_V34.txt.

What remains identical to the known-good V27/V31 performance path
------------------------------------------------------------------
* all compressed IWD entries remain eligible for zlib-ng - no 256 KiB cutoff;
* sound is NOT put back on stock zlib;
* no minizip-open filename scan/detour on every entry;
* no delayed zlib install;
* V27 archive-worker temporary ABOVE_NORMAL behavior is retained;
* persistent mapped-IWD cache is retained;
* exact static CRT _read fast path is retained;
* V27 renderer wait/coalescing and frame-pacing behavior is retained;
* V29 RenderSync producer-assist experiment is absent;
* V27 setting keys are retained so the known-good settings carry over.

V32/V33 compatibility fallback
------------------------------
V34 still contains the corrected null-output discard bridge. If the new sound
prefix cache cannot safely handle an entry, it falls back to that path. Audio
correctness therefore does not depend on the cache succeeding.

Expected log lines
------------------
When the marker hook installs:

  [MW3 V34 Audio Cache] exact streamed-sound FS_Seek marker installed at iw5sp+0x2B6460.

When the first compressed streamed-sound cache is actually created:

  [MW3 V34 Audio Cache] streamed-sound decoded-prefix cache active; direct mapped-IWD zlib-ng decoder will decompress each requested sound byte at most once.

If the first line appears but the second never does, the tested sound was
probably stored rather than DEFLATE-compressed, or it used a different loader.

Install/build
-------------
1. Run install_v34_source.ps1 from the package, pointing -RenoDxRoot at your
   RenoDX checkout if necessary.
2. Build:

   cmake --build --preset clang-x64-release --target CODMW3 --clean-first

3. Install the resulting renodx-CODMW3.addon64 as usual.
4. Keep the existing mw3_zlibng_v27.dll beside iw5sp.exe. You do NOT need to
   replace it if V27/V31/V32/V33 already installed it.

First test
----------
Use the exact same checkpoint/route used for the V31 vs V32/V33 comparison.
Check only these three things first:

1. traversal stutter severity compared with V31;
2. streamed/dialogue audio does not repeat;
3. ReShade.log contains both V34 Audio Cache lines above when the affected
   compressed sound path is exercised.

Validation limit
----------------
This environment does not contain the Windows SDK/RenoDX checkout, so the final
clang-cl compile/link cannot be performed here. The source has been structurally
checked, the new sound-cache block passes a standalone C++ syntax check with
Windows APIs stubbed, and validate_v34_static.py passes every exact executable
signature/source invariant against the supplied iw5sp.exe.
