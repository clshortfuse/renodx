# Resident Evil 6

Build the `residentevil6` target with the `clang-x86-debug` build preset while
the game is closed. Install the generated `renodx-residentevil6.addon32` and
restart the game; live HLSL reload alone cannot activate addon exposure history.

RTV0 used by material shaders `0x4E162C4D`, `0xDB03362A`, and `0x9F0F9263`
automatically selects the shared scene-color buffer for RGBA16F cloning.
Their other render targets stay native. The latter two cover the equivalent
scene target in areas where `0x4E162C4D` does not draw.
Check that RTV0 has an active float clone after encountering that material and
that highlights retain values above one through the subsequent HDR color copies.
The packed-color downsample also identifies its actual scene input. Its copy
source is promoted to float on subsequent frames, covering other scene material
variants without adding each shader hash. The first discovery frame can still
contain clipped data. Rebuild to activate this resource-role tracking.

Match Original Curve is enabled by default. It preserves the game's exposure target,
point-sampled authored LUT response, and SDR curve through white. It bypasses
the extra midtone separation and second RenoDRT/Psycho curve. Real HDR values
above white roll off toward the configured peak using one RGB scale. This path
also works with older addons whose former padding register is zero; rebuild to
expose the checkbox. The requested HDR bloom increase remains active.

HDR camera exposure adapts with a 1.5-second response and a maximum speed of
0.5 stops per second. It filters the camera factor independently of the game's
brightness multiplier. Its minimum exposure is 0.25x (two stops below neutral),
preventing bright surfaces from driving the camera arbitrarily dark. This floor
also applies to the live shaders before rebuilding the addon history. Scene and
bloom use the same history once per frame. Rebuild to activate this filter;
older addons fall back to native exposure rather than the old quarter-strength
history. With matching disabled, the selected RenoDRT/Psycho curve is used.

After rebuilding, check a stationary shiny surface, pan between bright and dark
areas, then check a fade, a cutscene, and Vanilla mode. Confirm bloom follows the
scene without pulsing, exposure still adapts, and fades reach black. Compare
1000- and 4000-nit settings: highlight headroom should change while the camera's
exposure behavior stays the same.
