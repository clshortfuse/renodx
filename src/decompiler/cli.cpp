#include <cstdio>
#include <cstdlib>

#include <cassert>
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

  char* disassembly = ShaderCompilerUtil::disassembleShader(code, code_size);
  if (disassembly == nullptr) {
    fprintf(stderr, "Failed to disassemble shader.");
    return EXIT_FAILURE;
  }
  std::cout << "Disassembled." << std::endl;
  auto* decompiler = new renodx::utils::shader::decompiler::dxc::Decompiler();

  std::string decompilation = decompiler->Decompile(std::string_view(disassembly));

  if (decompilation.empty()) {
    return EXIT_FAILURE;
  }
  fprintf(stdout, "%s", decompilation.c_str());
  return EXIT_SUCCESS;
}
