
/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <atlbase.h>
#include <d3dcompiler.h>
#include <dxcapi.h>
#include <mmiscapi.h>
#include <winsock.h>

#include <cstdint>
#include <exception>
#include <ios>
#include <map>
#include <mutex>
#include <optional>
#include <shared_mutex>
#include <span>
#include <string>
#include <vector>

#include <include/reshade.hpp>
#include "format.hpp"

namespace renodx::utils::shader::compiler {

namespace internal {

static HMODULE fxc_compiler_library = nullptr;
static HMODULE dxc_compiler_library = nullptr;
static std::shared_mutex mutex_fxc_compiler;
static std::shared_mutex mutex_dxc_compiler;

inline HRESULT CreateLibrary(IDxcLibrary** dxc_library) {
  // HMODULE dxil_loader = LoadLibraryW(L"dxil.dll");
  if (dxc_compiler_library == nullptr) {
    dxc_compiler_library = LoadLibraryW(L"dxcompiler.dll");
  }
  if (dxc_compiler_library == nullptr) {
    return -1;
  }
  // NOLINTNEXTLINE(google-readability-casting)
  auto dxc_create_instance = DxcCreateInstanceProc(GetProcAddress(dxc_compiler_library, "DxcCreateInstance"));
  if (dxc_create_instance == nullptr) return -1;
  return dxc_create_instance(CLSID_DxcLibrary, __uuidof(IDxcLibrary), reinterpret_cast<void**>(dxc_library));
}

inline HRESULT CreateCompiler(IDxcCompiler** dxc_compiler) {
  // HMODULE dxil_loader = LoadLibraryW(L"dxil.dll");
  if (dxc_compiler_library == nullptr) {
    dxc_compiler_library = LoadLibraryW(L"dxcompiler.dll");
  }
  if (dxc_compiler_library == nullptr) {
    return -1;
  }
  // NOLINTNEXTLINE(google-readability-casting)
  auto dxc_create_instance = DxcCreateInstanceProc(GetProcAddress(dxc_compiler_library, "DxcCreateInstance"));
  if (dxc_create_instance == nullptr) return -1;
  return dxc_create_instance(CLSID_DxcCompiler, __uuidof(IDxcCompiler), reinterpret_cast<void**>(dxc_compiler));
}

#define IFR(x)                \
  {                           \
    const HRESULT __hr = (x); \
    if (FAILED(__hr))         \
      return __hr;            \
  }

#define IFT(x)                \
  {                           \
    const HRESULT __hr = (x); \
    if (FAILED(__hr))         \
      throw(__hr);            \
  }

inline HRESULT CompileFromBlob(
    IDxcBlobEncoding* source,
    LPCWSTR source_name,
    const D3D_SHADER_MACRO* defines,
    IDxcIncludeHandler* include,
    LPCSTR entrypoint,
    LPCSTR target,
    UINT flags1,
    UINT flags2,
    ID3DBlob** code,
    ID3DBlob** error_messages) {
  CComPtr<IDxcCompiler> compiler;
  CComPtr<IDxcOperationResult> operation_result;
  HRESULT hr;

  // Upconvert legacy targets
  char parsed_target[7] = "?s_6_0";
  parsed_target[6] = 0;
  if (target[3] < '6') {
    parsed_target[0] = target[0];
    target = parsed_target;
  }

  try {
    const CA2W entrypoint_wide(entrypoint, CP_UTF8);
    const CA2W target_profile_wide(target, CP_UTF8);
    std::vector<std::wstring> define_values;
    std::vector<DxcDefine> new_defines;
    if (defines != nullptr) {
      CONST D3D_SHADER_MACRO* cursor = defines;

      // Convert to UTF-16.
      while (cursor != nullptr && cursor->Name != nullptr) {
        define_values.emplace_back(CA2W(cursor->Name, CP_UTF8));
        if (cursor->Definition != nullptr) {
          define_values.emplace_back(CA2W(cursor->Definition, CP_UTF8));
        } else {
          define_values.emplace_back(/* empty */);
        }
        ++cursor;
      }

      // Build up array.
      cursor = defines;
      size_t i = 0;
      while (cursor->Name != nullptr) {
        new_defines.push_back(
            DxcDefine{define_values[i++].c_str(), define_values[i++].c_str()});
        ++cursor;
      }
    }

    std::vector<LPCWSTR> arguments;
    if ((flags1 & D3DCOMPILE_ENABLE_BACKWARDS_COMPATIBILITY) != 0) arguments.push_back(L"/Gec");
    // /Ges Not implemented:
    // if(flags1 & D3DCOMPILE_ENABLE_STRICTNESS) arguments.push_back(L"/Ges");
    if ((flags1 & D3DCOMPILE_IEEE_STRICTNESS) != 0) arguments.push_back(L"/Gis");
    if ((flags1 & D3DCOMPILE_OPTIMIZATION_LEVEL2) != 0) {
      switch (flags1 & D3DCOMPILE_OPTIMIZATION_LEVEL2) {
        case D3DCOMPILE_OPTIMIZATION_LEVEL0:
          arguments.push_back(L"/O0");
          break;
        case D3DCOMPILE_OPTIMIZATION_LEVEL2:
          arguments.push_back(L"/O2");
          break;
        case D3DCOMPILE_OPTIMIZATION_LEVEL3:
          arguments.push_back(L"/O3");
          break;
      }
    }
    // Currently, /Od turns off too many optimization passes, causing incorrect
    // DXIL to be generated. Re-enable once /Od is implemented properly:
    // if(flags1 & D3DCOMPILE_SKIP_OPTIMIZATION) arguments.push_back(L"/Od");
    if ((flags1 & D3DCOMPILE_DEBUG) != 0) arguments.push_back(L"/Zi");
    if ((flags1 & D3DCOMPILE_PACK_MATRIX_ROW_MAJOR) != 0) arguments.push_back(L"/Zpr");
    if ((flags1 & D3DCOMPILE_PACK_MATRIX_COLUMN_MAJOR) != 0) arguments.push_back(L"/Zpc");
    if ((flags1 & D3DCOMPILE_AVOID_FLOW_CONTROL) != 0) arguments.push_back(L"/Gfa");
    if ((flags1 & D3DCOMPILE_PREFER_FLOW_CONTROL) != 0) arguments.push_back(L"/Gfp");
    // We don't implement this:
    // if(flags1 & D3DCOMPILE_PARTIAL_PRECISION) arguments.push_back(L"/Gpp");
    if ((flags1 & D3DCOMPILE_RESOURCES_MAY_ALIAS) != 0) arguments.push_back(L"/res_may_alias");
    arguments.push_back(L"/HV");
    arguments.push_back(L"2021");

    IFR(CreateCompiler(&compiler));
    IFR(compiler->Compile(
        source,
        source_name,
        entrypoint_wide,
        target_profile_wide,
        arguments.data(),
        (UINT)arguments.size(),
        new_defines.data(),
        (UINT)new_defines.size(),
        include,
        &operation_result));
  } catch (const std::bad_alloc&) {
    return E_OUTOFMEMORY;
  } catch (const CAtlException& err) {
    return err.m_hr;
  }

  operation_result->GetStatus(&hr);
  if (SUCCEEDED(hr)) {
    return operation_result->GetResult(reinterpret_cast<IDxcBlob**>(code));
  }
  if (error_messages != nullptr) {
    operation_result->GetErrorBuffer(reinterpret_cast<IDxcBlobEncoding**>(error_messages));
  }
  return hr;
}

inline HRESULT WINAPI BridgeD3DCompileFromFile(
    LPCWSTR file_name,
    const D3D_SHADER_MACRO* defines,
    ID3DInclude* include,
    LPCSTR entrypoint,
    LPCSTR target,
    UINT flags1,
    UINT flags2,
    ID3DBlob** code,
    ID3DBlob** error_messages) {
  CComPtr<IDxcLibrary> library;
  CComPtr<IDxcBlobEncoding> source;
  CComPtr<IDxcIncludeHandler> include_handler;

  *code = nullptr;
  if (error_messages != nullptr) {
    *error_messages = nullptr;
  }

  HRESULT hr;
  hr = CreateLibrary(&library);
  if (FAILED(hr)) return hr;
  hr = library->CreateBlobFromFile(file_name, nullptr, &source);
  if (FAILED(hr)) return hr;

  // Until we actually wrap the include handler, fail if there's a user-supplied
  // handler.
  if (D3D_COMPILE_STANDARD_FILE_INCLUDE == include) {
    IFT(library->CreateIncludeHandler(&include_handler));
  } else if (include != nullptr) {
    return E_INVALIDARG;
  }

  return CompileFromBlob(source, file_name, defines, include_handler, entrypoint, target, flags1, flags2, code, error_messages);
}

inline std::vector<uint8_t> CompileShaderFromFileFXC(
    LPCWSTR file_path,
    LPCSTR shader_target,
    const D3D_SHADER_MACRO* defines = nullptr) {
  CComPtr<ID3DBlob> out_blob;

  if (fxc_compiler_library == nullptr) {
    std::stringstream s;
    s << "CompileShaderFromFileFXC(Loading D3DCompiler_47.dll)";
    reshade::log_message(reshade::log_level::debug, s.str().c_str());
    fxc_compiler_library = LoadLibraryW(L"D3DCompiler_47.dll");
  }
  if (fxc_compiler_library == nullptr) {
    throw std::exception("Could not to load D3DCompiler_47.dll");
  }

  typedef HRESULT(WINAPI * pD3DCompileFromFile)(
      LPCWSTR, const D3D_SHADER_MACRO*, ID3DInclude*, LPCSTR, LPCSTR, UINT, UINT, ID3DBlob**, ID3DBlob**);

  {
    std::stringstream s;
    s << "CompileShaderFromFileFXC(GetProcAddress)";
    reshade::log_message(reshade::log_level::debug, s.str().c_str());
  }
  // NOLINTNEXTLINE(google-readability-casting)
  auto d3d_compilefromfile = pD3DCompileFromFile(GetProcAddress(fxc_compiler_library, "D3DCompileFromFile"));
  if (d3d_compilefromfile == nullptr) {
    throw std::exception("Could not to load D3DCompileFromFile from D3DCompiler_47.dll");
  }

  std::unique_lock lock(mutex_fxc_compiler);
  CComPtr<ID3DBlob> error_blob;
  if (FAILED(d3d_compilefromfile(
          file_path,
          defines,
          D3D_COMPILE_STANDARD_FILE_INCLUDE,
          "main",
          shader_target,
          D3DCOMPILE_ENABLE_BACKWARDS_COMPATIBILITY,
          0,
          &out_blob,
          &error_blob))) {
    if (error_blob == nullptr) throw std::exception("Unknown error occurred.");

    throw std::exception(
        std::string(reinterpret_cast<char*>(error_blob->GetBufferPointer()),
                    error_blob->GetBufferSize())
            .c_str());
  }
  return {reinterpret_cast<uint8_t*>(out_blob->GetBufferPointer()),
          reinterpret_cast<uint8_t*>(out_blob->GetBufferPointer()) + out_blob->GetBufferSize()};
}

inline std::vector<uint8_t> CompileShaderFromFileDXC(
    LPCWSTR file_path,
    LPCSTR shader_target,
    const D3D_SHADER_MACRO* defines = nullptr) {
  std::vector<uint8_t> result;

  CComPtr<ID3DBlob> out_blob;
  CComPtr<ID3DBlob> error_blob;
  std::unique_lock lock(mutex_dxc_compiler);
  if (FAILED(internal::BridgeD3DCompileFromFile(
          file_path,
          defines,
          D3D_COMPILE_STANDARD_FILE_INCLUDE,
          "main",
          shader_target,
          0,
          0,
          &out_blob,
          &error_blob))) {
    if (error_blob == nullptr) throw std::exception("Unknown error occurred.");

    throw std::exception(std::string(reinterpret_cast<char*>(error_blob->GetBufferPointer()),
                                     error_blob->GetBufferSize())
                             .c_str());
  }
  return {reinterpret_cast<uint8_t*>(out_blob->GetBufferPointer()),
          reinterpret_cast<uint8_t*>(out_blob->GetBufferPointer()) + out_blob->GetBufferSize()};
}

inline std::string DisassembleShaderFXC(std::span<uint8_t> blob) {
  if (fxc_compiler_library == nullptr) {
    fxc_compiler_library = LoadLibraryW(L"D3DCompiler_47.dll");
  }
  if (fxc_compiler_library == nullptr) throw std::exception("Could not to load D3DCompiler_47.dll");

  // NOLINTNEXTLINE(google-readability-casting)
  auto d3d_disassemble = pD3DDisassemble(GetProcAddress(fxc_compiler_library, "D3DDisassemble"));

  if (d3d_disassemble == nullptr) throw std::exception("Could not to load D3DDisassemble in D3DCompiler_47.dll");

  // Function may not be thread-safe
  std::unique_lock lock(mutex_fxc_compiler);
  CComPtr<ID3DBlob> out_blob;
  if (FAILED(d3d_disassemble(
          blob.data(),
          blob.size(),
          D3D_DISASM_ENABLE_INSTRUCTION_NUMBERING | D3D_DISASM_ENABLE_INSTRUCTION_OFFSET,
          nullptr,
          &out_blob))) {
    throw std::exception("Disassembly failed");
  }

  return {
      reinterpret_cast<char*>(out_blob->GetBufferPointer()),
      out_blob->GetBufferSize()};
}

inline std::string DisassembleShaderDXC(std::span<uint8_t> blob) {
  CComPtr<IDxcLibrary> library;
  CComPtr<IDxcCompiler> compiler;
  CComPtr<IDxcBlobEncoding> source;
  CComPtr<IDxcBlobEncoding> disassembly_text;
  CComPtr<ID3DBlob> disassembly;

  std::unique_lock lock(mutex_dxc_compiler);
  if (FAILED(internal::CreateLibrary(&library))) throw std::exception("Could not create library.");
  if (FAILED(library->CreateBlobWithEncodingFromPinned(blob.data(), blob.size(), CP_ACP, &source))) throw std::exception("Could not prepare blob.");
  if (FAILED(internal::CreateCompiler(&compiler))) throw std::exception("Could not create compiler object.");
  if (FAILED(compiler->Disassemble(source, &disassembly_text))) throw std::exception("Could not disassemble.");
  if (FAILED(disassembly_text.QueryInterface(&disassembly))) throw std::exception("Could not find diassembly");

  return {
      reinterpret_cast<char*>(disassembly->GetBufferPointer()),
      disassembly->GetBufferSize(),
  };
}

}  // namespace internal

// Also compatible with DXBC
struct DxilContainerHeader {
  uint32_t four_cc;
  uint8_t digest[16];
  uint16_t major_version;
  uint16_t minor_version;
  uint32_t container_size;
  uint32_t part_count;
};
struct DxilPartHeader {
  uint32_t four_cc;
  uint32_t part_size;
};

struct DxilProgramVersion {
  uint32_t value = 0xffff0000;
  [[nodiscard]] unsigned int GetMajor() const { return (value & 0xf0) >> 4; }
  [[nodiscard]] unsigned int GetMinor() const { return (value & 0xf); }
  [[nodiscard]] unsigned int GetKind() const { return (value & 0xffff0000) >> 16; }
  [[nodiscard]] const char* GetKindAbbr() const {
    switch (this->GetKind()) {
      case D3D11_SHVER_PIXEL_SHADER:    return "ps";
      case D3D11_SHVER_VERTEX_SHADER:   return "vs";
      case D3D11_SHVER_GEOMETRY_SHADER: return "gs";
      case D3D11_SHVER_HULL_SHADER:     return "hs";
      case D3D11_SHVER_DOMAIN_SHADER:   return "ds";
      case D3D11_SHVER_COMPUTE_SHADER:  return "cs";
      default:                          return "??";
    }
  }
};

constexpr uint32_t FourCC(char char0, char char1, char char2, char char3) {
  return static_cast<uint32_t>(static_cast<uint8_t>(char0))
         | (static_cast<uint32_t>(static_cast<uint8_t>(char1)) << 8)
         | (static_cast<uint32_t>(static_cast<uint8_t>(char2)) << 16)
         | (static_cast<uint32_t>(static_cast<uint8_t>(char3)) << 24);
}

inline DxilProgramVersion DecodeShaderVersion(std::span<uint8_t> blob) {
  if (blob.size() < sizeof(DxilContainerHeader)) throw std::exception("Invalid shader size.");
  auto* header = reinterpret_cast<DxilContainerHeader*>(blob.data());

  switch (header->four_cc) {
    case FourCC('D', 'X', 'B', 'C'):
    case FourCC('D', 'X', 'I', 'L'):
      break;
    default:
      throw std::exception("Unrecognized header.");
  }

  auto part_offsets = std::span<uint32_t>(
      reinterpret_cast<uint32_t*>(blob.data() + sizeof(DxilContainerHeader)),
      header->part_count);

  for (auto offset : part_offsets) {
    auto* part_header = reinterpret_cast<DxilPartHeader*>(blob.data() + offset);

    switch (part_header->four_cc) {
      case FourCC('S', 'H', 'D', 'R'):
      case FourCC('S', 'H', 'E', 'X'):
      case FourCC('D', 'X', 'I', 'L'):
        break;
      default:
        continue;
    }
    auto part_data = blob.subspan(
        offset + sizeof(DxilPartHeader),
        part_header->part_size);
    auto* program_version = reinterpret_cast<DxilProgramVersion*>(part_data.data());
    return *program_version;
  }
  return DxilProgramVersion{};  // No shader (shader layout perhaps)
}

inline std::string DisassembleShader(std::span<uint8_t> blob) {
  auto version = DecodeShaderVersion(blob);
  if (version.GetMajor() < 6) {
    return internal::DisassembleShaderFXC(blob);
  }
  return internal::DisassembleShaderDXC(blob);
}

inline std::vector<uint8_t> CompileShaderFromFile(
    LPCWSTR file_path,
    LPCSTR shader_target,
    const std::vector<std::pair<std::string, std::string>>& defines = {}) {
  std::vector<D3D_SHADER_MACRO> local_defines;
  for (const auto& [key, value] : defines) {
    if (!key.empty() && !value.empty()) {
      local_defines.push_back({key.c_str(), value.c_str()});
    }
  }
  if (!local_defines.empty()) {
    local_defines.push_back({nullptr, nullptr});
  }

  if (shader_target[3] < '6') {
    return internal::CompileShaderFromFileFXC(file_path, shader_target, local_defines.empty() ? nullptr : local_defines.data());
  }
  return internal::CompileShaderFromFileDXC(file_path, shader_target, local_defines.empty() ? nullptr : local_defines.data());
}

}  // namespace renodx::utils::shader::compiler
