#include <windows.h>
#include <dxcapi.h>

#include <filesystem>
#include <fstream>
#include <iostream>
#include <stdexcept>
#include <string>

// NOLINTNEXTLINE(readability-identifier-naming): Windows Unicode entry point.
int wmain(int argc, wchar_t** argv) {
  if (argc != 4) {
    std::cerr << "Usage: assemble_shader <input.ll> <output.cso> <tools-directory>\n";
    return 1;
  }

  const std::filesystem::path output_path = argv[2];
  auto temporary_path = output_path;
  temporary_path += L".tmp";
  try {
    const auto tools_path = std::filesystem::absolute(argv[3]);
    // The DLL must outlive all COM objects created from it.
    struct Library {
      HMODULE handle = nullptr;
      ~Library() {
        if (handle != nullptr) FreeLibrary(handle);
      }
    } compiler{
        .handle = LoadLibraryExW((tools_path / L"dxcompiler.dll").c_str(), nullptr,
                                 LOAD_LIBRARY_SEARCH_DLL_LOAD_DIR | LOAD_LIBRARY_SEARCH_DEFAULT_DIRS),
    };
    if (compiler.handle == nullptr) {
      throw std::runtime_error("Could not load dxcompiler.dll from " + tools_path.string());
    }
    const auto create_compiler = reinterpret_cast<DxcCreateInstanceProc>(GetProcAddress(compiler.handle, "DxcCreateInstance"));
    if (create_compiler == nullptr) {
      throw std::runtime_error("DxcCreateInstance export missing");
    }
    const auto check = [](HRESULT status, const char* operation) {
      if (FAILED(status)) {
        throw std::runtime_error(std::string(operation) + " failed (HRESULT " + std::to_string(status) + ")");
      }
    };
    struct Interfaces {
      IDxcLibrary* library = nullptr;
      IDxcBlobEncoding* source = nullptr;
      IDxcAssembler* assembler = nullptr;
      IDxcOperationResult* assembled = nullptr;
      IDxcBlob* container = nullptr;
      IDxcValidator* validator = nullptr;
      IDxcOperationResult* validated = nullptr;
      IDxcBlobEncoding* errors = nullptr;
      ~Interfaces() {
        if (errors != nullptr) {
          errors->Release();
        }
        if (validated != nullptr) {
          validated->Release();
        }
        if (validator != nullptr) {
          validator->Release();
        }
        if (container != nullptr) {
          container->Release();
        }
        if (assembled != nullptr) {
          assembled->Release();
        }
        if (assembler != nullptr) {
          assembler->Release();
        }
        if (source != nullptr) {
          source->Release();
        }
        if (library != nullptr) {
          library->Release();
        }
      }
    } interfaces;
    const auto check_result = [&](IDxcOperationResult* result, const char* operation) {
      check(result->GetErrorBuffer(&interfaces.errors), "GetErrorBuffer");
      if (interfaces.errors != nullptr && interfaces.errors->GetBufferSize() != 0) {
        std::cerr.write(static_cast<const char*>(interfaces.errors->GetBufferPointer()), interfaces.errors->GetBufferSize());
        std::cerr << '\n';
      }
      if (interfaces.errors != nullptr) {
        interfaces.errors->Release();
        interfaces.errors = nullptr;
      }
      HRESULT status = S_OK;
      check(result->GetStatus(&status), "GetStatus");
      check(status, operation);
    };

    check(create_compiler(CLSID_DxcLibrary, IID_PPV_ARGS(&interfaces.library)), "Create library");
    check(interfaces.library->CreateBlobFromFile(argv[1], nullptr, &interfaces.source), "Read source");
    check(create_compiler(CLSID_DxcAssembler, IID_PPV_ARGS(&interfaces.assembler)), "Create assembler");
    check(interfaces.assembler->AssembleToContainer(interfaces.source, &interfaces.assembled), "AssembleToContainer");
    check_result(interfaces.assembled, "Assembly");
    check(interfaces.assembled->GetResult(&interfaces.container), "Get assembled container");

    check(create_compiler(CLSID_DxcValidator, IID_PPV_ARGS(&interfaces.validator)), "Create validator");
    check(interfaces.validator->Validate(interfaces.container, DxcValidatorFlags_InPlaceEdit, &interfaces.validated), "Validate");
    check_result(interfaces.validated, "Validation");

    // InPlaceEdit updates the owned container; write only after validation succeeds.
    {
      std::ofstream output;
      output.exceptions(std::ios::failbit | std::ios::badbit);
      output.open(temporary_path, std::ios::binary | std::ios::trunc);
      output.write(static_cast<const char*>(interfaces.container->GetBufferPointer()), interfaces.container->GetBufferSize());
      output.close();
    }
    if (MoveFileExW(temporary_path.c_str(), output_path.c_str(), MOVEFILE_REPLACE_EXISTING) == 0) {
      throw std::runtime_error("Could not publish output file");
    }
    return 0;
  } catch (const std::exception& error) {
    std::error_code ignored;
    std::filesystem::remove(temporary_path, ignored);
    std::cerr << std::filesystem::path(argv[1]).string() << ": " << error.what() << '\n';
    return 1;
  }
}