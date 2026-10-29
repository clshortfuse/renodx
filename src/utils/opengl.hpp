/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <cstdint>
#include <mutex>

#include <windows.h>
#include <gl/GL.h>
#include <include/reshade_api_format.hpp>

namespace renodx::utils::opengl {

inline constexpr unsigned int READ_FRAMEBUFFER = 0x8CA8;
inline constexpr unsigned int READ_FRAMEBUFFER_BINDING = 0x8CAA;

// Borrowed handle; the caller must keep the OpenGL runtime loaded.
inline HMODULE GetModule() {
  return GetModuleHandleW(L"opengl32.dll");
}

// WGL DLL exports are shared; extension entry points below are thread-local.
// Initialize with a current context before use. Contexts used on the same
// thread must have compatible WGL extension dispatch.
inline decltype(&wglGetProcAddress) pWglGetProcAddress = nullptr;
inline decltype(&wglGetCurrentContext) pWglGetCurrentContext = nullptr;
inline decltype(&wglGetCurrentDC) pWglGetCurrentDC = nullptr;
inline decltype(&wglMakeCurrent) pWglMakeCurrent = nullptr;
inline std::once_flag wgl_initialized;
inline thread_local decltype(&glGenTextures) pGlGenTextures = nullptr;
inline thread_local decltype(&glDeleteTextures) pGlDeleteTextures = nullptr;
inline thread_local decltype(&glBindTexture) pGlBindTexture = nullptr;
inline thread_local decltype(&glGetIntegerv) pGlGetIntegerv = nullptr;
inline thread_local decltype(&glGetTexLevelParameteriv) pGlGetTexLevelParameteriv = nullptr;
inline thread_local void(APIENTRY* pGlCreateMemoryObjectsEXT)(int, unsigned int*) = nullptr;
inline thread_local void(APIENTRY* pGlMemoryObjectParameterivEXT)(unsigned int, unsigned int, const int*) = nullptr;
inline thread_local void(APIENTRY* pGlImportMemoryWin32HandleEXT)(unsigned int, std::uint64_t, unsigned int, void*) = nullptr;
inline thread_local void(APIENTRY* pGlTexStorageMem2DEXT)(unsigned int, int, unsigned int, int, int, unsigned int, std::uint64_t) = nullptr;
inline thread_local void(APIENTRY* pGlDeleteMemoryObjectsEXT)(int, const unsigned int*) = nullptr;
inline thread_local void(APIENTRY* pGlGenSemaphoresEXT)(int, unsigned int*) = nullptr;
inline thread_local void(APIENTRY* pGlImportSemaphoreWin32HandleEXT)(unsigned int, unsigned int, void*) = nullptr;
inline thread_local void(APIENTRY* pGlDeleteSemaphoresEXT)(int, const unsigned int*) = nullptr;
inline thread_local void(APIENTRY* pGlSemaphoreParameterui64vEXT)(unsigned int, unsigned int, const std::uint64_t*) = nullptr;
inline thread_local void(APIENTRY* pGlSignalSemaphoreEXT)(unsigned int, unsigned int, const unsigned int*, unsigned int, const unsigned int*, const unsigned int*) = nullptr;
inline thread_local void(APIENTRY* pGlWaitSemaphoreEXT)(unsigned int, unsigned int, const unsigned int*, unsigned int, const unsigned int*, const unsigned int*) = nullptr;
inline thread_local unsigned char(APIENTRY* pGlIsSemaphoreEXT)(unsigned int) = nullptr;
inline thread_local const unsigned char*(APIENTRY* pGlGetStringi)(unsigned int, unsigned int) = nullptr;
inline thread_local void(APIENTRY* pGlGetUnsignedBytevEXT)(unsigned int, unsigned char*) = nullptr;
inline thread_local void(APIENTRY* pGlBindFramebuffer)(unsigned int, unsigned int) = nullptr;

// Optional extension pointers may be null; callers check the capability they use.
inline bool Initialize() {
  static thread_local bool initialized = false;
  if (initialized) return true;
  auto* const module = GetModule();
  if (module != nullptr) {
    std::call_once(wgl_initialized, [&]() {
      pWglGetProcAddress = reinterpret_cast<decltype(pWglGetProcAddress)>(GetProcAddress(module, "wglGetProcAddress"));
      pWglGetCurrentContext = reinterpret_cast<decltype(pWglGetCurrentContext)>(GetProcAddress(module, "wglGetCurrentContext"));
      pWglGetCurrentDC = reinterpret_cast<decltype(pWglGetCurrentDC)>(GetProcAddress(module, "wglGetCurrentDC"));
      pWglMakeCurrent = reinterpret_cast<decltype(pWglMakeCurrent)>(GetProcAddress(module, "wglMakeCurrent"));
    });
  }
  if (module == nullptr || pWglGetProcAddress == nullptr || pWglGetCurrentContext == nullptr
      || pWglGetCurrentContext() == nullptr) return false;
  const auto extension = [](const char* name) -> PROC {
    const auto proc = pWglGetProcAddress(name);
    const auto address = reinterpret_cast<std::uintptr_t>(proc);
    return (address > 3u && address != UINTPTR_MAX ? proc : nullptr);
  };
  pGlGenTextures = reinterpret_cast<decltype(pGlGenTextures)>(GetProcAddress(module, "glGenTextures"));
  pGlDeleteTextures = reinterpret_cast<decltype(pGlDeleteTextures)>(GetProcAddress(module, "glDeleteTextures"));
  pGlBindTexture = reinterpret_cast<decltype(pGlBindTexture)>(GetProcAddress(module, "glBindTexture"));
  pGlGetIntegerv = reinterpret_cast<decltype(pGlGetIntegerv)>(GetProcAddress(module, "glGetIntegerv"));
  pGlGetTexLevelParameteriv = reinterpret_cast<decltype(pGlGetTexLevelParameteriv)>(GetProcAddress(module, "glGetTexLevelParameteriv"));
  pGlCreateMemoryObjectsEXT = reinterpret_cast<decltype(pGlCreateMemoryObjectsEXT)>(extension("glCreateMemoryObjectsEXT"));
  pGlMemoryObjectParameterivEXT = reinterpret_cast<decltype(pGlMemoryObjectParameterivEXT)>(extension("glMemoryObjectParameterivEXT"));
  pGlImportMemoryWin32HandleEXT = reinterpret_cast<decltype(pGlImportMemoryWin32HandleEXT)>(extension("glImportMemoryWin32HandleEXT"));
  pGlTexStorageMem2DEXT = reinterpret_cast<decltype(pGlTexStorageMem2DEXT)>(extension("glTexStorageMem2DEXT"));
  pGlDeleteMemoryObjectsEXT = reinterpret_cast<decltype(pGlDeleteMemoryObjectsEXT)>(extension("glDeleteMemoryObjectsEXT"));
  pGlGenSemaphoresEXT = reinterpret_cast<decltype(pGlGenSemaphoresEXT)>(extension("glGenSemaphoresEXT"));
  pGlImportSemaphoreWin32HandleEXT = reinterpret_cast<decltype(pGlImportSemaphoreWin32HandleEXT)>(extension("glImportSemaphoreWin32HandleEXT"));
  pGlDeleteSemaphoresEXT = reinterpret_cast<decltype(pGlDeleteSemaphoresEXT)>(extension("glDeleteSemaphoresEXT"));
  pGlSemaphoreParameterui64vEXT = reinterpret_cast<decltype(pGlSemaphoreParameterui64vEXT)>(extension("glSemaphoreParameterui64vEXT"));
  pGlSignalSemaphoreEXT = reinterpret_cast<decltype(pGlSignalSemaphoreEXT)>(extension("glSignalSemaphoreEXT"));
  pGlWaitSemaphoreEXT = reinterpret_cast<decltype(pGlWaitSemaphoreEXT)>(extension("glWaitSemaphoreEXT"));
  pGlIsSemaphoreEXT = reinterpret_cast<decltype(pGlIsSemaphoreEXT)>(extension("glIsSemaphoreEXT"));
  pGlGetStringi = reinterpret_cast<decltype(pGlGetStringi)>(extension("glGetStringi"));
  pGlGetUnsignedBytevEXT = reinterpret_cast<decltype(pGlGetUnsignedBytevEXT)>(extension("glGetUnsignedBytevEXT"));
  pGlBindFramebuffer = reinterpret_cast<decltype(pGlBindFramebuffer)>(extension("glBindFramebuffer"));
  initialized = true;
  return true;
}

// Sized GL internal formats with matching D3D12 typed storage. No swizzle or conversion.
inline uint32_t GetOpenGLSharedTextureFormat(reshade::api::format format) {
  switch (format) {
    case reshade::api::format::r8_unorm:            return 0x8229;  // GL_R8
    case reshade::api::format::r8g8_unorm:          return 0x822B;  // GL_RG8
    case reshade::api::format::r8g8b8a8_unorm:      return 0x8058;  // GL_RGBA8
    case reshade::api::format::r8g8b8a8_unorm_srgb: return 0x8C43;  // GL_SRGB8_ALPHA8
    case reshade::api::format::r16_unorm:           return 0x822A;  // GL_R16
    case reshade::api::format::r16g16_unorm:        return 0x822C;  // GL_RG16
    case reshade::api::format::r16g16b16a16_unorm:  return 0x805B;  // GL_RGBA16
    case reshade::api::format::r16_float:           return 0x822D;  // GL_R16F
    case reshade::api::format::r16g16_float:        return 0x822F;  // GL_RG16F
    case reshade::api::format::r16g16b16a16_float:  return 0x881A;  // GL_RGBA16F
    case reshade::api::format::r32_float:           return 0x822E;  // GL_R32F
    case reshade::api::format::r32g32_float:        return 0x8230;  // GL_RG32F
    case reshade::api::format::r32g32b32a32_float:  return 0x8814;  // GL_RGBA32F
    case reshade::api::format::r10g10b10a2_unorm:   return 0x8059;  // GL_RGB10_A2
    case reshade::api::format::r11g11b10_float:     return 0x8C3A;  // GL_R11F_G11F_B10F
    default:                                        return 0u;
  }
}

}  // namespace renodx::utils::opengl