/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <windows.h>
#include <include/reshade.hpp>

#include <algorithm>
#include <cstdint>
#include <shared_mutex>

#include "./data.hpp"

namespace renodx::utils::windowing {

using WindowMessageCallback = bool (*)(
    HWND hwnd,
    UINT msg,
    WPARAM wparam,
    LPARAM lparam,
    LRESULT* out_result,
    void* callback_context);

struct WindowProcHookData {
  WNDPROC original_proc = nullptr;
  WindowMessageCallback callback = nullptr;
  void* callback_context = nullptr;
};

static data::ParallelNodeHashMap<HWND, WindowProcHookData, std::shared_mutex> g_wndprocs;

static bool TryGetClientRect(HWND hwnd, RECT* rect) {
  if (hwnd == nullptr || rect == nullptr) return false;
  return GetClientRect(hwnd, rect) != FALSE;
}

static void RestoreWindowIfMinimized(HWND window, bool allow_activate) {
  if (window == nullptr) return;
  if (IsIconic(window) == FALSE) return;
  ShowWindow(window, allow_activate ? SW_RESTORE : SW_SHOWNOACTIVATE);
}

static bool DefaultSwapchainWindowMessageCallback(
    HWND hwnd,
    UINT msg,
    WPARAM wparam,
    LPARAM lparam,
    LRESULT* out_result,
    void* callback_context) {
  if (msg == WM_ACTIVATEAPP && (wparam != FALSE)) {
    RestoreWindowIfMinimized(hwnd, true);
  }
  return false;
}

static LRESULT CALLBACK SwapchainWndProc(HWND hwnd, UINT msg, WPARAM wparam, LPARAM lparam) {
  WindowProcHookData hook_data = {};
  g_wndprocs.if_contains(hwnd, [&hook_data](const std::pair<const HWND, WindowProcHookData>& pair) {
    hook_data = pair.second;
  });

  if (hook_data.callback != nullptr) {
    LRESULT callback_result = 0;
    if (hook_data.callback(hwnd, msg, wparam, lparam, &callback_result, hook_data.callback_context)) {
      return callback_result;
    }
  }

  if (hook_data.original_proc != nullptr) {
    return CallWindowProc(hook_data.original_proc, hwnd, msg, wparam, lparam);
  }
  return DefWindowProc(hwnd, msg, wparam, lparam);
}

static bool HookSwapchainWindowProc(
    HWND hwnd,
    WindowMessageCallback callback = DefaultSwapchainWindowMessageCallback,
    void* callback_context = nullptr) {
  if (hwnd == nullptr) return false;

  const bool already_hooked =
      g_wndprocs.if_contains(hwnd, [](const std::pair<const HWND, WindowProcHookData>&) {});
  if (already_hooked) return true;

  const auto original = reinterpret_cast<WNDPROC>(
      SetWindowLongPtr(hwnd, GWLP_WNDPROC, reinterpret_cast<LONG_PTR>(SwapchainWndProc)));
  if (original == nullptr) {
    reshade::log::message(reshade::log::level::warning,
                          "utils::windowing::HookSwapchainWindowProc(failed)");
    return false;
  }

  if (callback == nullptr) {
    callback = DefaultSwapchainWindowMessageCallback;
  }

  g_wndprocs.insert_or_assign(
      hwnd,
      WindowProcHookData{
          .original_proc = original,
          .callback = callback,
          .callback_context = callback_context,
      });
  return true;
}

static bool UnhookSwapchainWindowProc(HWND hwnd) {
  if (hwnd == nullptr) return false;

  WindowProcHookData hook_data = {};
  const bool hooked =
      g_wndprocs.if_contains(hwnd, [&hook_data](const std::pair<const HWND, WindowProcHookData>& pair) {
        hook_data = pair.second;
      });
  if (!hooked || hook_data.original_proc == nullptr) return false;

  if (SetWindowLongPtr(hwnd, GWLP_WNDPROC, reinterpret_cast<LONG_PTR>(hook_data.original_proc)) == 0) {
    return false;
  }

  g_wndprocs.erase(hwnd);
  return true;
}

static bool IsBorderlessStyle(LONG_PTR style, LONG_PTR exstyle) {
  return (style & (WS_BORDER | WS_THICKFRAME | WS_DLGFRAME)) == 0
         && (exstyle & (WS_EX_CLIENTEDGE | WS_EX_WINDOWEDGE)) == 0;
}

static bool IsBorderlessWindow(HWND hwnd) {
  if (hwnd == nullptr) return false;
  const LONG_PTR style = GetWindowLongPtr(hwnd, GWL_STYLE);
  const LONG_PTR exstyle = GetWindowLongPtr(hwnd, GWL_EXSTYLE);
  return IsBorderlessStyle(style, exstyle);
}

static void RemoveWindowBorder(HWND window) {
  if (window == nullptr) return;

  const auto current_style = GetWindowLongPtr(window, GWL_STYLE);
  if (current_style != 0) {
    const auto new_style = current_style & ~WS_BORDER & ~WS_THICKFRAME & ~WS_DLGFRAME;
    if (new_style != current_style) {
      SetWindowLongPtr(window, GWL_STYLE, new_style);
    }
  }

  const auto current_exstyle = GetWindowLongPtr(window, GWL_EXSTYLE);
  if (current_exstyle != 0) {
    const auto new_exstyle = current_exstyle & ~WS_EX_CLIENTEDGE & ~WS_EX_WINDOWEDGE;
    if (new_exstyle != current_exstyle) {
      SetWindowLongPtr(window, GWL_EXSTYLE, new_exstyle);
    }
  }
}

static bool GetMonitorRect(HWND hwnd, RECT* rect) {
  if (hwnd == nullptr || rect == nullptr) return false;

  HMONITOR monitor = MonitorFromWindow(hwnd, MONITOR_DEFAULTTONEAREST);
  if (monitor == nullptr) return false;

  MONITORINFO monitor_info = {};
  monitor_info.cbSize = sizeof(MONITORINFO);
  if (GetMonitorInfo(monitor, &monitor_info) == FALSE) return false;

  *rect = monitor_info.rcMonitor;
  return true;
}

static bool ComputeCenteredRect(const RECT& container, uint32_t width, uint32_t height, RECT* rect) {
  if (rect == nullptr || width == 0 || height == 0) return false;

  const int container_width = container.right - container.left;
  const int container_height = container.bottom - container.top;
  const int target_width = static_cast<int>(width);
  const int target_height = static_cast<int>(height);

  const int left = container.left + std::max((container_width - target_width) / 2, 0);
  const int top = container.top + std::max((container_height - target_height) / 2, 0);

  rect->left = left;
  rect->top = top;
  rect->right = left + target_width;
  rect->bottom = top + target_height;
  return true;
}

static bool SetWindowPositionAndSize(
    HWND hwnd,
    int left,
    int top,
    uint32_t width,
    uint32_t height,
    UINT flags = SWP_ASYNCWINDOWPOS | SWP_FRAMECHANGED | SWP_SHOWWINDOW | SWP_NOZORDER,
    HWND insert_after = nullptr) {
  if (hwnd == nullptr) return false;

  RECT rect = {};
  if (GetWindowRect(hwnd, &rect) == FALSE) return false;

  return SetWindowPos(
             hwnd,
             insert_after,
             left,
             top,
             static_cast<int>(width),
             static_cast<int>(height),
             flags)
         != FALSE;
}

static bool CanApplyFakeFullscreen(HWND hwnd) {
  if (hwnd == nullptr) return false;
  if (IsWindow(hwnd) == FALSE) return false;
  if (IsWindowVisible(hwnd) == FALSE) return false;
  if (IsIconic(hwnd) != FALSE) return false;
  return GetForegroundWindow() == hwnd;
}

static bool ApplyFakeFullscreen(HWND hwnd, uint32_t width, uint32_t height) {
  if (hwnd == nullptr || width == 0 || height == 0) return false;

  RECT monitor_rect = {};
  if (!GetMonitorRect(hwnd, &monitor_rect)) return false;

  RECT desired_rect = {};
  if (!ComputeCenteredRect(monitor_rect, width, height, &desired_rect)) return false;

  RemoveWindowBorder(hwnd);

  RECT current_rect = {};
  if (GetWindowRect(hwnd, &current_rect) == FALSE) return false;
  const bool already_positioned =
      IsBorderlessWindow(hwnd)
      && current_rect.left == desired_rect.left
      && current_rect.top == desired_rect.top
      && current_rect.right == desired_rect.right
      && current_rect.bottom == desired_rect.bottom;
  if (already_positioned) return true;

  HWND foreground = GetForegroundWindow();
  const bool was_foreground = (foreground == hwnd);

  if (!SetWindowPositionAndSize(
          hwnd,
          desired_rect.left,
          desired_rect.top,
          width,
          height,
          SWP_ASYNCWINDOWPOS | SWP_FRAMECHANGED | SWP_SHOWWINDOW | (was_foreground ? 0 : SWP_NOACTIVATE),
          HWND_TOP)) {
    return false;
  }

  if (IsIconic(hwnd) == TRUE) {
    ShowWindow(hwnd, was_foreground ? SW_RESTORE : SW_SHOWNOACTIVATE);
  }

  UpdateWindow(hwnd);
  SendMessage(hwnd, WM_SIZE, SIZE_RESTORED, MAKELPARAM(width, height));

  return true;
}

static bool ApplyFakeFullscreen(reshade::api::swapchain* swapchain, const reshade::api::resource_desc& desc) {
  if (swapchain == nullptr) return false;

  HWND hwnd = static_cast<HWND>(swapchain->get_hwnd());
  if (hwnd == nullptr) return false;

  const uint32_t texture_width = desc.texture.width;
  const uint32_t texture_height = desc.texture.height;
  if (texture_width == 0 || texture_height == 0) return false;

  return ApplyFakeFullscreen(hwnd, texture_width, texture_height);
}

}  // namespace renodx::utils::windowing
