#include <cstdio>
#include <cstdlib>

#include <cassert>
#include <exception>
#include <fstream>
#include <iostream>
#include <ostream>
#include <print>
#include <string>

#include "../utils/shader_decompiler_dxc.hpp"
#include "./dxdisasm.hpp"

FILE* OpenOrExit(const char* fname, const char* mode) {
  FILE* f = fopen(fname, mode);
  if (f == NULL) {
    perror(fname);
    exit(EXIT_FAILURE);
  }
  return f;
}

const char* GetFileNameFromPath(const char* buffer) {
  char c;
  int i;
  for (i = 0;; ++i) {
    c = *((char*)buffer + i);
    if (c == '\\' || c == '/') {
      return GetFileNameFromPath((char*)buffer + i + 1);
    }
    if (c == '\0') {
      return buffer;
    }
  }
  return "";
}

int main(int argc, char** argv) {
  if (argc < 3) {
    fprintf(stderr,
            "USAGE: %s {cso} {hlsl}\n\n"
            "  Creates {hlsl} from the contents of {cso}\n",
            argv[0]);
    return EXIT_FAILURE;
  }

  std::ifstream file(argv[1], std::ios::binary);
  file.seekg(0, std::ios::end);
  size_t code_size = file.tellg();
  auto* code = new uint8_t[code_size];
  file.seekg(0, std::ios::beg);
  file.read(reinterpret_cast<char*>(code), code_size);

  const char* sym = argv[2];

  char symfile[256];
  snprintf(symfile, sizeof(symfile), "%s", sym);
  const auto* symbasename = GetFileNameFromPath(sym);

  FILE* out = OpenOrExit(symfile, "wt");

  char* disassembly = ShaderCompilerUtil::disassembleShader(code, code_size);
  if (disassembly == nullptr) {
    fprintf(stderr, "Failed to disassemble shader.");
    return EXIT_FAILURE;
  }
  auto* decompiler = new renodx::utils::shader::decompiler::dxc::Decompiler();

  try {
    std::string decompilation = decompiler->Decompile(std::string_view(disassembly));
    if (decompilation.empty()) {
      return EXIT_FAILURE;
    }
    
    fprintf(out, "%s", decompilation.c_str());
    fclose(out);

  } catch (const std::exception& ex) {
    std::cerr << ex.what() << std::endl;
    return EXIT_FAILURE;
  } catch (const std::string& ex) {
    std::cerr << ex << std::endl;
    return EXIT_FAILURE;
  } catch (...) {
    std::cerr << "Unknown failure" << std::endl;
    return EXIT_FAILURE;
  }

  return EXIT_SUCCESS;
}
