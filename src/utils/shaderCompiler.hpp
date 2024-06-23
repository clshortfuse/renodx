
/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <atlbase.h>
#include <d3dcompiler.h>
#include <dxcapi.h>

#include <string>
#include <vector>

#include <include/reshade.hpp>

namespace ShaderCompilerUtil {

  CComPtr<ID3DBlob> disassembleShaderFXC(const void* data, size_t size, LPCWSTR library = L"D3DCompiler_47.dll") {
    HMODULE d3d_compiler = LoadLibraryW(library);
    if (d3d_compiler != nullptr) {
      pD3DDisassemble d3d_disassemble = pD3DDisassemble(GetProcAddress(d3d_compiler, "D3DDisassemble"));

      if (d3d_disassemble != nullptr) {
        CComPtr<ID3DBlob> outBlob;
        if (SUCCEEDED(d3d_disassemble(
              data,
              size,
              D3D_DISASM_ENABLE_INSTRUCTION_NUMBERING | D3D_DISASM_ENABLE_INSTRUCTION_OFFSET,
              nullptr,
              &outBlob
            ))) {
          return outBlob;
        }
      }
      FreeLibrary(d3d_compiler);
    }
    return nullptr;
  }

  HRESULT CreateLibrary(IDxcLibrary** pLibrary) {
    // HMODULE dxil_loader = LoadLibraryW(L"dxil.dll");
    HMODULE dx_compiler = LoadLibraryW(L"dxcompiler.dll");
    if (dx_compiler == nullptr) {
      reshade::log_message(reshade::log_level::error, "dxcompiler.dll not loaded");
      return -1;
    }
    DxcCreateInstanceProc dxcCreateInstance = DxcCreateInstanceProc(GetProcAddress(dx_compiler, "DxcCreateInstance"));
    if (dxcCreateInstance == nullptr) return -1;
    return dxcCreateInstance(CLSID_DxcLibrary, __uuidof(IDxcLibrary), (void**)pLibrary);
  }

  HRESULT CreateCompiler(IDxcCompiler** ppCompiler) {
    // HMODULE dxil_loader = LoadLibraryW(L"dxil.dll");
    HMODULE dx_compiler = LoadLibraryW(L"dxcompiler.dll");
    if (dx_compiler == nullptr) {
      reshade::log_message(reshade::log_level::error, "dxcompiler.dll not loaded");
      return -1;
    }
    DxcCreateInstanceProc dxcCreateInstance = DxcCreateInstanceProc(GetProcAddress(dx_compiler, "DxcCreateInstance"));
    if (dxcCreateInstance == nullptr) return -1;
    return dxcCreateInstance(CLSID_DxcCompiler, __uuidof(IDxcCompiler), (void**)ppCompiler);
  }

  CComPtr<ID3DBlob> disassembleShaderDXC(const void* data, size_t size) {
    CComPtr<IDxcLibrary> library;
    CComPtr<IDxcCompiler> compiler;
    CComPtr<IDxcBlobEncoding> source;
    CComPtr<IDxcBlobEncoding> disassemblyText;
    CComPtr<ID3DBlob> disassembly;

    if (FAILED(CreateLibrary(&library))) return nullptr;
    if (FAILED(library->CreateBlobWithEncodingFromPinned(data, size, CP_ACP, &source))) return nullptr;
    if (FAILED(CreateCompiler(&compiler))) return nullptr;
    if (FAILED(compiler->Disassemble(source, &disassemblyText))) return nullptr;
    if (FAILED(disassemblyText.QueryInterface(&disassembly))) return nullptr;

    return disassembly;
  }

  std::string disassembleShader(void* code, size_t size) {
    CComPtr<ID3DBlob> result = disassembleShaderFXC(code, size);
    if (result == nullptr) {
      result = disassembleShaderDXC(code, size);
    }
    if (result == nullptr) {
      return "";
    }
    std::string outString((char*)result->GetBufferPointer(), result->GetBufferSize());
    return outString;
  }

  ID3DBlob* compileShaderFromFileFXC(LPCWSTR filePath, LPCSTR shaderTarget, LPCWSTR library = L"D3DCompiler_47.dll") {
    ID3DBlob* outBlob = nullptr;

    HMODULE d3d_compiler = LoadLibraryW(library);
    if (d3d_compiler != nullptr) {
      typedef HRESULT(WINAPI * pD3DCompileFromFile)(
        LPCWSTR, const D3D_SHADER_MACRO*, ID3DInclude*, LPCSTR, LPCSTR, UINT, UINT, ID3DBlob**, ID3DBlob**
      );

      pD3DCompileFromFile d3d_compilefromfile = pD3DCompileFromFile(GetProcAddress(d3d_compiler, "D3DCompileFromFile"));

      if (d3d_compilefromfile != nullptr) {
        ID3DBlob* errorBlob = nullptr;
        if (FAILED(d3d_compilefromfile(
              filePath,
              nullptr,
              D3D_COMPILE_STANDARD_FILE_INCLUDE,
              "main",
              shaderTarget,
              D3DCOMPILE_ENABLE_BACKWARDS_COMPATIBILITY,
              0,
              &outBlob,
              &errorBlob
            ))) {
          std::stringstream s;
          s << "compileShaderFromFileFXC(Compilation failed";
          if (errorBlob != nullptr) {
            // auto error_size = errorBlob->GetBufferSize();
            auto error = (uint8_t*)errorBlob->GetBufferPointer();
            s << ": " << error;
            errorBlob->Release();
          } else {
            s << ".";
          }
          s << ")";
          if (outBlob) {
            outBlob->Release();
          }
          outBlob = nullptr;
          reshade::log_message(reshade::log_level::error, s.str().c_str());
        }
      }
      FreeLibrary(d3d_compiler);
    }
    return outBlob;
  }

#define IFR(x)          \
  {                     \
    HRESULT __hr = (x); \
    if (FAILED(__hr))   \
      return __hr;      \
  }

#define IFT(x)          \
  {                     \
    HRESULT __hr = (x); \
    if (FAILED(__hr))   \
      throw(__hr);      \
  }

  HRESULT CompileFromBlob(IDxcBlobEncoding* pSource, LPCWSTR pSourceName, const D3D_SHADER_MACRO* pDefines, IDxcIncludeHandler* pInclude, LPCSTR pEntrypoint, LPCSTR pTarget, UINT Flags1, UINT Flags2, ID3DBlob** ppCode, ID3DBlob** ppErrorMsgs) {
    CComPtr<IDxcCompiler> compiler;
    CComPtr<IDxcOperationResult> operationResult;
    HRESULT hr;

    // Upconvert legacy targets
    char Target[7] = "?s_6_0";
    Target[6] = 0;
    if (pTarget[3] < '6') {
      Target[0] = pTarget[0];
      pTarget = Target;
    }

    try {
      CA2W pEntrypointW(pEntrypoint, CP_UTF8);
      CA2W pTargetProfileW(pTarget, CP_UTF8);
      std::vector<std::wstring> defineValues;
      std::vector<DxcDefine> defines;
      if (pDefines) {
        CONST D3D_SHADER_MACRO* pCursor = pDefines;

        // Convert to UTF-16.
        while (pCursor->Name) {
          defineValues.push_back(std::wstring(CA2W(pCursor->Name, CP_UTF8)));
          if (pCursor->Definition)
            defineValues.push_back(
              std::wstring(CA2W(pCursor->Definition, CP_UTF8))
            );
          else
            defineValues.push_back(std::wstring());
          ++pCursor;
        }

        // Build up array.
        pCursor = pDefines;
        size_t i = 0;
        while (pCursor->Name) {
          defines.push_back(
            DxcDefine{defineValues[i++].c_str(), defineValues[i++].c_str()}
          );
          ++pCursor;
        }
      }

      std::vector<LPCWSTR> arguments;
      if (Flags1 & D3DCOMPILE_ENABLE_BACKWARDS_COMPATIBILITY)
        arguments.push_back(L"/Gec");
      // /Ges Not implemented:
      // if(Flags1 & D3DCOMPILE_ENABLE_STRICTNESS) arguments.push_back(L"/Ges");
      if (Flags1 & D3DCOMPILE_IEEE_STRICTNESS)
        arguments.push_back(L"/Gis");
      if (Flags1 & D3DCOMPILE_OPTIMIZATION_LEVEL2) {
        switch (Flags1 & D3DCOMPILE_OPTIMIZATION_LEVEL2) {
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
      // if(Flags1 & D3DCOMPILE_SKIP_OPTIMIZATION) arguments.push_back(L"/Od");
      if (Flags1 & D3DCOMPILE_DEBUG)
        arguments.push_back(L"/Zi");
      if (Flags1 & D3DCOMPILE_PACK_MATRIX_ROW_MAJOR)
        arguments.push_back(L"/Zpr");
      if (Flags1 & D3DCOMPILE_PACK_MATRIX_COLUMN_MAJOR)
        arguments.push_back(L"/Zpc");
      if (Flags1 & D3DCOMPILE_AVOID_FLOW_CONTROL)
        arguments.push_back(L"/Gfa");
      if (Flags1 & D3DCOMPILE_PREFER_FLOW_CONTROL)
        arguments.push_back(L"/Gfp");
      // We don't implement this:
      // if(Flags1 & D3DCOMPILE_PARTIAL_PRECISION) arguments.push_back(L"/Gpp");
      if (Flags1 & D3DCOMPILE_RESOURCES_MAY_ALIAS)
        arguments.push_back(L"/res_may_alias");
      arguments.push_back(L"/HV");
      arguments.push_back(L"2021");

      IFR(CreateCompiler(&compiler));
      IFR(compiler->Compile(pSource, pSourceName, pEntrypointW, pTargetProfileW, arguments.data(), (UINT)arguments.size(), defines.data(), (UINT)defines.size(), pInclude, &operationResult));
    } catch (const std::bad_alloc &) {
      return E_OUTOFMEMORY;
    } catch (const CAtlException &err) {
      return err.m_hr;
    }

    operationResult->GetStatus(&hr);
    if (SUCCEEDED(hr)) {
      return operationResult->GetResult((IDxcBlob**)ppCode);
    } else {
      if (ppErrorMsgs)
        operationResult->GetErrorBuffer((IDxcBlobEncoding**)ppErrorMsgs);
      return hr;
    }
  }

  HRESULT WINAPI BridgeD3DCompileFromFile(
    LPCWSTR pFileName,
    const D3D_SHADER_MACRO* pDefines,
    ID3DInclude* pInclude,
    LPCSTR pEntrypoint,
    LPCSTR pTarget,
    UINT Flags1,
    UINT Flags2,
    ID3DBlob** ppCode,
    ID3DBlob** ppErrorMsgs
  ) {
    CComPtr<IDxcLibrary> library;
    CComPtr<IDxcBlobEncoding> source;
    CComPtr<IDxcIncludeHandler> includeHandler;
    HRESULT hr;

    *ppCode = nullptr;
    if (ppErrorMsgs != nullptr)
      *ppErrorMsgs = nullptr;

    hr = CreateLibrary(&library);
    if (FAILED(hr))
      return hr;
    hr = library->CreateBlobFromFile(pFileName, nullptr, &source);
    if (FAILED(hr))
      return hr;

    // Until we actually wrap the include handler, fail if there's a user-supplied
    // handler.
    if (D3D_COMPILE_STANDARD_FILE_INCLUDE == pInclude) {
      IFT(library->CreateIncludeHandler(&includeHandler));
    } else if (pInclude) {
      return E_INVALIDARG;
    }

    return CompileFromBlob(source, pFileName, pDefines, includeHandler, pEntrypoint, pTarget, Flags1, Flags2, ppCode, ppErrorMsgs);
  }

  ID3DBlob* compileShaderFromFileDXC(LPCWSTR filePath, LPCSTR shaderTarget) {
    ID3DBlob* outBlob = nullptr;

    ID3DBlob* errorBlob = nullptr;
    if (FAILED(BridgeD3DCompileFromFile(
          filePath,
          nullptr,
          D3D_COMPILE_STANDARD_FILE_INCLUDE,
          "main",
          shaderTarget,
          0,
          0,
          &outBlob,
          &errorBlob
        ))) {
      std::stringstream s;
      s << "compileShaderFromFileDXC(Compilation failed";
      if (errorBlob != nullptr) {
        // auto error_size = errorBlob->GetBufferSize();
        auto error = (uint8_t*)errorBlob->GetBufferPointer();
        s << ": " << error;
        errorBlob->Release();
      } else {
        s << ".";
      }
      s << ")";

      if (outBlob) {
        outBlob->Release();
      }
      outBlob = nullptr;
      reshade::log_message(reshade::log_level::error, s.str().c_str());
    }

    return outBlob;
  }

  ID3DBlob* compileShaderFromFile(LPCWSTR filePath, LPCSTR shaderTarget, LPCWSTR library = L"D3DCompiler_47.dll") {
    if (shaderTarget[3] < '6') {
      return compileShaderFromFileFXC(filePath, shaderTarget, library);
    }
    return compileShaderFromFileDXC(filePath, shaderTarget);
  }

}  // namespace ShaderCompilerUtil
