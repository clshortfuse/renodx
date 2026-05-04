/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <objbase.h>
#include <wincodec.h>
#include <Windows.h>
#include <wrl/client.h>

#include <algorithm>
#include <cstdint>
#include <filesystem>
#include <span>
#include <vector>

namespace renodx::utils::png {

using Microsoft::WRL::ComPtr;

// https://learn.microsoft.com/en-us/windows/win32/wic/-wic-creating-encoder
// https://learn.microsoft.com/en-us/windows/win32/wic/png-format-overview

namespace internal {

inline constexpr GUID WIC_IMAGING_FACTORY_CLSID = {0xcacaf262, 0x9370, 0x4615, {0xa1, 0x3b, 0x9f, 0x55, 0x39, 0xda, 0x4c, 0x0a}};
inline constexpr GUID WIC_IMAGING_FACTORY2_CLSID = {0x317d06e8, 0x5f24, 0x433d, {0xbd, 0xf7, 0x79, 0xce, 0x68, 0xd8, 0xab, 0xc2}};
inline constexpr GUID WIC_CONTAINER_FORMAT_PNG_GUID = {0x1b7cfaf4, 0x713f, 0x473c, {0xbb, 0xcd, 0x61, 0x37, 0x42, 0x5f, 0xae, 0xaf}};
inline constexpr GUID WIC_PIXEL_FORMAT_32BPP_BGRA_GUID = {0x6fddc324, 0x4e03, 0x4bfe, {0xb1, 0x85, 0x3d, 0x77, 0x76, 0x8d, 0xc9, 0x0f}};

template <typename Function>
[[nodiscard]] inline Function LoadModuleProc(std::wstring_view module_name, const char* proc_name) {
  auto* module = GetModuleHandleW(module_name.data());
  if (module == nullptr) {
    module = LoadLibraryW(module_name.data());
  }
  if (module == nullptr) {
    return nullptr;
  }

  return reinterpret_cast<Function>(GetProcAddress(module, proc_name));
}

struct Ole32Api {
  using CoInitializeExFn = HRESULT(WINAPI*)(LPVOID, DWORD);
  using CoUninitializeFn = void(WINAPI*)();
  using CoCreateInstanceFn = HRESULT(WINAPI*)(REFCLSID, LPUNKNOWN, DWORD, REFIID, LPVOID*);

  CoInitializeExFn co_initialize_ex = nullptr;
  CoUninitializeFn co_uninitialize = nullptr;
  CoCreateInstanceFn co_create_instance = nullptr;
};

[[nodiscard]] inline const Ole32Api* GetOle32Api() {
  static const auto API = []() {
    Ole32Api loaded_api = {};
    loaded_api.co_initialize_ex = LoadModuleProc<Ole32Api::CoInitializeExFn>(L"ole32.dll", "CoInitializeEx");
    loaded_api.co_uninitialize = LoadModuleProc<Ole32Api::CoUninitializeFn>(L"ole32.dll", "CoUninitialize");
    loaded_api.co_create_instance = LoadModuleProc<Ole32Api::CoCreateInstanceFn>(L"ole32.dll", "CoCreateInstance");
    return loaded_api;
  }();

  if (API.co_initialize_ex == nullptr || API.co_uninitialize == nullptr || API.co_create_instance == nullptr) {
    return nullptr;
  }

  return &API;
}

class ScopedComInitialization {
 public:
  ScopedComInitialization()
      : ole32_api(GetOle32Api()),
        initialize_result(ole32_api == nullptr ? E_NOINTERFACE : ole32_api->co_initialize_ex(nullptr, COINIT_MULTITHREADED)) {
  }

  ScopedComInitialization(const ScopedComInitialization&) = delete;
  ScopedComInitialization& operator=(const ScopedComInitialization&) = delete;

  ~ScopedComInitialization() {
    if ((initialize_result == S_OK || initialize_result == S_FALSE) && ole32_api != nullptr) {
      ole32_api->co_uninitialize();
    }
  }

  [[nodiscard]] bool IsUsable() const {
    return SUCCEEDED(initialize_result) || initialize_result == RPC_E_CHANGED_MODE;
  }

 private:
  const Ole32Api* ole32_api;
  HRESULT initialize_result;
};

[[nodiscard]] inline ComPtr<IWICImagingFactory> CreateWicFactory() {
  const auto* ole32_api = GetOle32Api();
  if (ole32_api == nullptr) {
    return {};
  }

  ComPtr<IWICImagingFactory> factory;

  auto result = ole32_api->co_create_instance(
      WIC_IMAGING_FACTORY2_CLSID,
      nullptr,
      CLSCTX_INPROC_SERVER,
      IID_PPV_ARGS(&factory));
  if (FAILED(result)) {
    result = ole32_api->co_create_instance(
        WIC_IMAGING_FACTORY_CLSID,
        nullptr,
        CLSCTX_INPROC_SERVER,
        IID_PPV_ARGS(&factory));
  }
  if (FAILED(result)) {
    return {};
  }

  return factory;
}

[[nodiscard]] inline std::vector<std::uint8_t> ConvertRgbaToBgra(std::span<const std::uint8_t> rgba_pixels) {
  std::vector<std::uint8_t> bgra_pixels(rgba_pixels.begin(), rgba_pixels.end());
  for (std::size_t index = 0; index + 3u < bgra_pixels.size(); index += 4u) {
    std::swap(bgra_pixels[index + 0u], bgra_pixels[index + 2u]);
  }
  return bgra_pixels;
}

[[nodiscard]] inline std::vector<std::uint8_t> ConvertBgraToRgba(std::span<const std::uint8_t> bgra_pixels) {
  std::vector<std::uint8_t> rgba_pixels(bgra_pixels.begin(), bgra_pixels.end());
  for (std::size_t index = 0; index + 3u < rgba_pixels.size(); index += 4u) {
    std::swap(rgba_pixels[index + 0u], rgba_pixels[index + 2u]);
  }
  return rgba_pixels;
}

}  // namespace internal

[[nodiscard]] inline bool ReadRgba8(
    const std::filesystem::path& input_path,
    std::uint32_t& width,
    std::uint32_t& height,
    std::vector<std::uint8_t>& rgba_pixels) {
  width = 0u;
  height = 0u;
  rgba_pixels.clear();

  internal::ScopedComInitialization com;
  if (!com.IsUsable()) return false;

  auto factory = internal::CreateWicFactory();
  if (factory == nullptr) return false;

  ComPtr<IWICBitmapDecoder> decoder;
  if (FAILED(factory->CreateDecoderFromFilename(
          input_path.c_str(),
          nullptr,
          GENERIC_READ,
          WICDecodeMetadataCacheOnDemand,
          &decoder))) {
    return false;
  }

  ComPtr<IWICBitmapFrameDecode> frame;
  if (FAILED(decoder->GetFrame(0u, &frame))) return false;

  UINT decoded_width = 0u;
  UINT decoded_height = 0u;
  if (FAILED(frame->GetSize(&decoded_width, &decoded_height))) return false;
  if (decoded_width == 0u || decoded_height == 0u) return false;

  ComPtr<IWICFormatConverter> converter;
  if (FAILED(factory->CreateFormatConverter(&converter))) return false;
  if (FAILED(converter->Initialize(
          frame.Get(),
          internal::WIC_PIXEL_FORMAT_32BPP_BGRA_GUID,
          WICBitmapDitherTypeNone,
          nullptr,
          0.0f,
          WICBitmapPaletteTypeCustom))) {
    return false;
  }

  std::vector<std::uint8_t> bgra_pixels(
      static_cast<std::size_t>(decoded_width) * static_cast<std::size_t>(decoded_height) * 4u);
  const auto stride = decoded_width * 4u;
  const auto buffer_size = static_cast<UINT>(bgra_pixels.size());
  if (FAILED(converter->CopyPixels(nullptr, stride, buffer_size, bgra_pixels.data()))) return false;

  width = decoded_width;
  height = decoded_height;
  rgba_pixels = internal::ConvertBgraToRgba(bgra_pixels);
  return true;
}

[[nodiscard]] inline bool WriteRgba8(
    const std::filesystem::path& output_path,
    std::uint32_t width,
    std::uint32_t height,
    std::span<const std::uint8_t> rgba_pixels) {
  if (width == 0u || height == 0u) return false;
  if (rgba_pixels.size() != static_cast<std::size_t>(width) * static_cast<std::size_t>(height) * 4u) return false;

  internal::ScopedComInitialization com;
  if (!com.IsUsable()) return false;

  auto factory = internal::CreateWicFactory();
  if (factory == nullptr) return false;

  ComPtr<IWICStream> stream;
  if (FAILED(factory->CreateStream(&stream))) return false;
  if (FAILED(stream->InitializeFromFilename(output_path.c_str(), GENERIC_WRITE))) return false;

  ComPtr<IWICBitmapEncoder> encoder;
  if (FAILED(factory->CreateEncoder(internal::WIC_CONTAINER_FORMAT_PNG_GUID, nullptr, &encoder))) return false;
  if (FAILED(encoder->Initialize(stream.Get(), WICBitmapEncoderNoCache))) return false;

  ComPtr<IWICBitmapFrameEncode> frame;
  if (FAILED(encoder->CreateNewFrame(&frame, nullptr))) return false;
  if (FAILED(frame->Initialize(nullptr))) return false;
  if (FAILED(frame->SetSize(width, height))) return false;

  WICPixelFormatGUID pixel_format = internal::WIC_PIXEL_FORMAT_32BPP_BGRA_GUID;
  if (FAILED(frame->SetPixelFormat(&pixel_format))) return false;
  if (InlineIsEqualGUID(pixel_format, internal::WIC_PIXEL_FORMAT_32BPP_BGRA_GUID) == FALSE) return false;

  auto bgra_pixels = internal::ConvertRgbaToBgra(rgba_pixels);
  const auto stride = width * 4u;
  const auto buffer_size = static_cast<UINT>(bgra_pixels.size());
  if (FAILED(frame->WritePixels(height, stride, buffer_size, bgra_pixels.data()))) return false;

  if (FAILED(frame->Commit())) return false;
  if (FAILED(encoder->Commit())) return false;
  return true;
}

}  // namespace renodx::utils::png
