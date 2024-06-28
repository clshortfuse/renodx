
/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <atlbase.h>
#include <d3dcompiler.h>
#include <dxcapi.h>

#include <optional>
#include <sstream>
#include <string>
#include <vector>

#include <include/reshade.hpp>

namespace renodx::utils::shader::compiler {

inline std::optional<std::string> DisassembleShaderFXC(void* data, size_t size, LPCWSTR library = L"D3DCompiler_47.dll") {
  std::optional<std::string> result;

  HMODULE d3d_compiler = LoadLibraryW(library);
  if (d3d_compiler != nullptr) {
    // NOLINTNEXTLINE(google-readability-casting)
    auto d3d_disassemble = pD3DDisassemble(GetProcAddress(d3d_compiler, "D3DDisassemble"));

    if (d3d_disassemble != nullptr) {
      CComPtr<ID3DBlob> out_blob;
      if (SUCCEEDED(d3d_disassemble(
              data,
              size,
              D3D_DISASM_ENABLE_INSTRUCTION_NUMBERING | D3D_DISASM_ENABLE_INSTRUCTION_OFFSET,
              nullptr,
              &out_blob))) {
        result = {reinterpret_cast<char*>(out_blob->GetBufferPointer()), out_blob->GetBufferSize()};
      }
    }
    FreeLibrary(d3d_compiler);
  }
  return result;
}

inline HRESULT CreateLibrary(IDxcLibrary** dxc_library) {
  // HMODULE dxil_loader = LoadLibraryW(L"dxil.dll");
  HMODULE dx_compiler = LoadLibraryW(L"dxcompiler.dll");
  if (dx_compiler == nullptr) {
    reshade::log_message(reshade::log_level::error, "dxcompiler.dll not loaded");
    return -1;
  }
  // NOLINTNEXTLINE(google-readability-casting)
  auto dxc_create_instance = DxcCreateInstanceProc(GetProcAddress(dx_compiler, "DxcCreateInstance"));
  if (dxc_create_instance == nullptr) return -1;
  return dxc_create_instance(CLSID_DxcLibrary, __uuidof(IDxcLibrary), reinterpret_cast<void**>(dxc_library));
}

inline HRESULT CreateCompiler(IDxcCompiler** dxc_compiler) {
  // HMODULE dxil_loader = LoadLibraryW(L"dxil.dll");
  HMODULE dx_compiler = LoadLibraryW(L"dxcompiler.dll");
  if (dx_compiler == nullptr) {
    reshade::log_message(reshade::log_level::error, "dxcompiler.dll not loaded");
    return -1;
  }
  // NOLINTNEXTLINE(google-readability-casting)
  auto dxc_create_instance = DxcCreateInstanceProc(GetProcAddress(dx_compiler, "DxcCreateInstance"));
  if (dxc_create_instance == nullptr) return -1;
  return dxc_create_instance(CLSID_DxcCompiler, __uuidof(IDxcCompiler), reinterpret_cast<void**>(dxc_compiler));
}

inline std::optional<std::string> DisassembleShaderDXC(void* data, size_t size) {
  CComPtr<IDxcLibrary> library;
  CComPtr<IDxcCompiler> compiler;
  CComPtr<IDxcBlobEncoding> source;
  CComPtr<IDxcBlobEncoding> disassembly_text;
  CComPtr<ID3DBlob> disassembly;

  std::optional<std::string> result;

  if (FAILED(CreateLibrary(&library))) return result;
  if (FAILED(library->CreateBlobWithEncodingFromPinned(data, size, CP_ACP, &source))) return result;
  if (FAILED(CreateCompiler(&compiler))) return result;
  if (FAILED(compiler->Disassemble(source, &disassembly_text))) return result;
  if (FAILED(disassembly_text.QueryInterface(&disassembly))) return result;

  result = {reinterpret_cast<char*>(disassembly->GetBufferPointer()), disassembly->GetBufferSize()};

  return result;
}

inline std::optional<std::string> DisassembleShader(void* code, size_t size) {
  auto result = DisassembleShaderFXC(code, size);
  if (!result.has_value()) {
    result = DisassembleShaderDXC(code, size);
  }
  return result;
}

inline std::vector<uint8_t> CompileShaderFromFileFXC(LPCWSTR file_path, LPCSTR shader_target, LPCWSTR library = L"D3DCompiler_47.dll") {
  std::vector<uint8_t> result;
  CComPtr<ID3DBlob> out_blob;

  HMODULE d3d_compiler = LoadLibraryW(library);
  if (d3d_compiler != nullptr) {
    typedef HRESULT(WINAPI * pD3DCompileFromFile)(
        LPCWSTR, const D3D_SHADER_MACRO*, ID3DInclude*, LPCSTR, LPCSTR, UINT, UINT, ID3DBlob**, ID3DBlob**);

    // NOLINTNEXTLINE(google-readability-casting)
    auto d3d_compilefromfile = pD3DCompileFromFile(GetProcAddress(d3d_compiler, "D3DCompileFromFile"));

    if (d3d_compilefromfile != nullptr) {
      CComPtr<ID3DBlob> error_blob;
      if (SUCCEEDED(d3d_compilefromfile(
              file_path,
              nullptr,
              D3D_COMPILE_STANDARD_FILE_INCLUDE,
              "main",
              shader_target,
              D3DCOMPILE_ENABLE_BACKWARDS_COMPATIBILITY,
              0,
              &out_blob,
              &error_blob))) {
        result.assign(
            reinterpret_cast<uint8_t*>(out_blob->GetBufferPointer()),
            reinterpret_cast<uint8_t*>(out_blob->GetBufferPointer()) + out_blob->GetBufferSize());
      } else {
        std::stringstream s;
        s << "CompileShaderFromFileFXC(Compilation failed";
        if (error_blob != nullptr) {
          // auto error_size = error_blob->GetBufferSize();
          auto* error = reinterpret_cast<uint8_t*>(error_blob->GetBufferPointer());
          s << ": " << error;
        } else {
          s << ".";
        }
        s << ")";
        reshade::log_message(reshade::log_level::error, s.str().c_str());
      }
    }
    FreeLibrary(d3d_compiler);
  }

  return result;
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
      while (cursor->Name != nullptr) {
        define_values.emplace_back(CA2W(cursor->Name, CP_UTF8));
        if (cursor->Definition != nullptr) {
          define_values.emplace_back(
              CA2W(cursor->Definition, CP_UTF8));
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
  HRESULT hr;

  *code = nullptr;
  if (error_messages != nullptr) {
    *error_messages = nullptr;
  }

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

inline std::vector<uint8_t> CompileShaderFromFileDXC(LPCWSTR file_path, LPCSTR shader_target) {
  std::vector<uint8_t> result;

  CComPtr<ID3DBlob> out_blob;
  CComPtr<ID3DBlob> error_blob;
  if (SUCCEEDED(BridgeD3DCompileFromFile(
          file_path,
          nullptr,
          D3D_COMPILE_STANDARD_FILE_INCLUDE,
          "main",
          shader_target,
          0,
          0,
          &out_blob,
          &error_blob))) {
    result.assign(
        reinterpret_cast<uint8_t*>(out_blob->GetBufferPointer()),
        reinterpret_cast<uint8_t*>(out_blob->GetBufferPointer()) + out_blob->GetBufferSize());
  } else {
    std::stringstream s;
    s << "CompileShaderFromFileDXC(Compilation failed";
    if (error_blob != nullptr) {
      // auto error_size = error_blob->GetBufferSize();
      auto* error = reinterpret_cast<uint8_t*>(error_blob->GetBufferPointer());
      s << ": " << error;
    } else {
      s << ".";
    }
    s << ")";

    reshade::log_message(reshade::log_level::error, s.str().c_str());
  }

  return result;
}

inline std::vector<uint8_t> CompileShaderFromFile(LPCWSTR file_path, LPCSTR shader_target, LPCWSTR library = L"D3DCompiler_47.dll") {
  if (shader_target[3] < '6') {
    return CompileShaderFromFileFXC(file_path, shader_target, library);
  }
  return CompileShaderFromFileDXC(file_path, shader_target);
}

}  // namespace renodx::utils::shader::compiler
