#pragma once

// In relative mouse mode (in-game look) SDL hides the cursor and pins it with
// a 1-pixel ClipCursor rect at the window centre. Over the HDR swapchain,
// Windows still draws a box where that hidden cursor sits and clips highlights
// inside it, which shows as a grey square near the crosshair. Pin the hidden
// cursor to the window's bottom-right pixel instead, so the box falls off the
// game image. Relative motion comes from raw input, so look is unaffected.
#include <Windows.h>
#include <include/reshade.hpp>
#include <cstring>
#include "../../utils/iat_hook.hpp"

namespace doom3::cursor {
inline decltype(&ClipCursor) real_clip_cursor = nullptr;
inline HMODULE sdl_module = nullptr;
inline bool logged_park = false;

inline bool IsRelativeModeClip(const RECT* rect) {
  // SDL_windowswindow.c WIN_UpdateClipCursor: 1x1, or 5x1 under remote desktop.
  return rect != nullptr && rect->bottom - rect->top == 1 && rect->right - rect->left >= 1
         && rect->right - rect->left <= 5;
}

inline BOOL WINAPI HookClipCursor(const RECT* rect) {
  if (IsRelativeModeClip(rect)) {
    // SDL only clips while its window has input focus.
    const HWND window = GetForegroundWindow();
    char class_name[16] = {};
    RECT client = {};
    if (window != nullptr && GetClassNameA(window, class_name, sizeof(class_name)) > 0
        && std::strcmp(class_name, "SDL_app") == 0 && GetClientRect(window, &client)
        && client.right > 0 && client.bottom > 0) {
      POINT corner = {client.right - 1, client.bottom - 1};
      if (ClientToScreen(window, &corner)) {
        const RECT parked = {corner.x, corner.y, corner.x + 1, corner.y + 1};
        if (!logged_park) {
          logged_park = true;
          reshade::log::message(reshade::log::level::info,
              "[Doom3] Hidden mouse cursor parked in the window corner instead of the centre.");
        }
        return real_clip_cursor(&parked);
      }
    }
  }
  return real_clip_cursor(rect);
}

inline void Use(DWORD reason) {
  if (reason == DLL_PROCESS_ATTACH) {
    // dhewm3 links SDL2.dll at load time, so it is present before ReShade loads add-ons.
    sdl_module = GetModuleHandleW(L"SDL2.dll");
    if (sdl_module == nullptr) return;
    if (!renodx::utils::iat_hook::PatchIAT("user32.dll", reinterpret_cast<void*>(&ClipCursor),
                                           reinterpret_cast<void*>(&HookClipCursor),
                                           reinterpret_cast<void**>(&real_clip_cursor), "ClipCursor", sdl_module)) {
      sdl_module = nullptr;
    }
  } else if (reason == DLL_PROCESS_DETACH) {
    if (sdl_module == nullptr) return;
    renodx::utils::iat_hook::UnpatchIAT("user32.dll", reinterpret_cast<void*>(&HookClipCursor),
                                        reinterpret_cast<void*>(real_clip_cursor), "ClipCursor", sdl_module);
    sdl_module = nullptr;
    real_clip_cursor = nullptr;
  }
}
}  // namespace doom3::cursor
