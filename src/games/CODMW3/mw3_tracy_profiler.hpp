#pragma once
//
// MW3 x64 Tracy integration layer.
// Keep this header FIRST in addon.cpp, before Windows/ReShade headers.
//
// Tracy is compiled into the RenoDX addon translation unit. This avoids needing
// to edit the top-level RenoDX CMake target while keeping all Tracy-specific
// integration in one file.
//

#ifndef WIN32_LEAN_AND_MEAN
#define WIN32_LEAN_AND_MEAN
#endif

// Tracy's Windows client uses Winsock2. It must be included before Windows.h
// (and before any header that may pull in legacy winsock.h).
#include <winsock2.h>
#include <ws2tcpip.h>
#include <Windows.h>

#if !__has_include("../../../external/Tracy/public/tracy/Tracy.hpp")
#error "MW3 Tracy profiler: external/Tracy is missing. Run setup_tracy_mw3_profile.ps1 from the RenoDX repository root."
#endif

#ifndef TRACY_ENABLE
#define TRACY_ENABLE
#endif

// Diagnostic build: no capture overhead until the Tracy viewer connects.
#ifndef TRACY_ON_DEMAND
#define TRACY_ON_DEMAND
#endif

#ifndef TRACY_ONLY_LOCALHOST
#define TRACY_ONLY_LOCALHOST
#endif

#ifndef TRACY_NO_BROADCAST
#define TRACY_NO_BROADCAST
#endif

#ifndef TRACY_NO_FRAME_IMAGE
#define TRACY_NO_FRAME_IMAGE
#endif

#include "../../../external/Tracy/public/tracy/Tracy.hpp"
#include "../../../external/Tracy/public/common/TracySystem.hpp"
#include "../../../external/Tracy/public/client/TracyProfiler.hpp"

// Compile the client into addon.cpp. This header is only included by addon.cpp.
#ifndef MW3_TRACY_CLIENT_IMPLEMENTATION_INCLUDED
#define MW3_TRACY_CLIENT_IMPLEMENTATION_INCLUDED
#include "../../../external/Tracy/public/TracyClient.cpp"
#endif

#include <atomic>
#include <cstdint>

namespace mw3_tracy_profiler {

inline bool Connected() {
#ifdef TRACY_ENABLE
  return tracy::GetProfiler().IsConnected();
#else
  return false;
#endif
}

inline void NameThreadOnce(const char* name) {
#ifdef TRACY_ENABLE
  thread_local bool named = false;
  if (!named && name != nullptr) {
    tracy::SetThreadName(name);
    named = true;
  }
#else
  (void)name;
#endif
}

inline void MarkNativeFrame() {
#ifdef TRACY_ENABLE
  static thread_local int64_t previous = 0;
  LARGE_INTEGER stamp{}, frequency{};
  QueryPerformanceCounter(&stamp);
  QueryPerformanceFrequency(&frequency);
  const int64_t now = stamp.QuadPart;
  if (previous != 0 && now > previous && frequency.QuadPart > 0) {
    TracyPlot("MW3/CPU Native Present Interval ms",
              static_cast<double>(now - previous) * 1000.0 / static_cast<double>(frequency.QuadPart));
  }
  previous = now;
  FrameMarkNamed("MW3 x64 Native D3D9");
#endif
}

inline void MarkProxyFrame() {
#ifdef TRACY_ENABLE
  static thread_local int64_t previous = 0;
  LARGE_INTEGER stamp{}, frequency{};
  QueryPerformanceCounter(&stamp);
  QueryPerformanceFrequency(&frequency);
  const int64_t now = stamp.QuadPart;
  if (previous != 0 && now > previous && frequency.QuadPart > 0) {
    TracyPlot("MW3/CPU Visible Proxy Present Interval ms",
              static_cast<double>(now - previous) * 1000.0 / static_cast<double>(frequency.QuadPart));
  }
  previous = now;
  FrameMarkNamed("MW3 RenoDX Visible Proxy");
#endif
}

inline void PlotNativeFrameMs(double value) {
#ifdef TRACY_ENABLE
  TracyPlot("MW3/CPU Native Frame ms", value);
#else
  (void)value;
#endif
}

inline void PlotGpuFrameMs(double value) {
#ifdef TRACY_ENABLE
  TracyPlot("MW3/GPU D3D9 Frame ms", value);
#else
  (void)value;
#endif
}

inline void PlotDrawCalls(double value) {
#ifdef TRACY_ENABLE
  TracyPlot("MW3/GPU Draw Calls", value);
#else
  (void)value;
#endif
}

inline void PlotIndexedIndices(double value) {
#ifdef TRACY_ENABLE
  TracyPlot("MW3/GPU Indexed Indices", value);
#else
  (void)value;
#endif
}

}  // namespace mw3_tracy_profiler

// CPU-zone helpers used by addon.cpp and the separate engine hook header.
#define MW3_TRACY_ADDON_ZONE(name_literal) ZoneScopedN(name_literal)
#define MW3_TRACY_ENGINE_ZONE(name_literal) ZoneScopedN(name_literal)
