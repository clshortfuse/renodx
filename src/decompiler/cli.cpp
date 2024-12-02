#include <cstdlib>

#include <cassert>
#include <exception>
#include <iostream>
#include <ostream>
#include <string>

#include "../utils/path.hpp"
#include "../utils/shader_compiler_directx.hpp"
#include "../utils/shader_decompiler_dxc.hpp"

int main(int argc, char** argv) {
  if (argc < 2) {
    std::cerr << "USAGE: decomp.exe {cso} [{hlsl}]\n";
    std::cerr << "  Creates {hlsl} from the contents of {cso}\n";
    return EXIT_FAILURE;
  }

  auto code = renodx::utils::path::ReadBinaryFile(argv[1]);

  auto disassembly = renodx::utils::shader::compiler::directx::DisassembleShader(code);
  if (disassembly.empty()) {
    std::cerr << "Failed to disassemble shader.\n";
    return EXIT_FAILURE;
  }
  auto decompiler = renodx::utils::shader::decompiler::dxc::Decompiler();

  try {
    std::string decompilation = decompiler.Decompile(disassembly);

    if (decompilation.empty()) {
      return EXIT_FAILURE;
    }

    std::string output;

    if (argc >= 3) {
      output = argv[2];
    } else {
      std::filesystem::path input_path = argv[1];
      std::filesystem::path output_path = input_path.parent_path();
      const auto& basename = input_path.stem().string();
      output_path /= basename;
      output_path += ".hlsl";
      output = output_path.string();
    }

    renodx::utils::path::WriteTextFile(output, decompilation);
    std::cout << '"' << argv[1] << '"' << " => " << output << std::endl;

  } catch (const std::exception& ex) {
    std::cerr << '"' << argv[1] << '"' << ": " << ex.what() << std::endl;
    return EXIT_FAILURE;
  } catch (const std::string& ex) {
    std::cerr << '"' << argv[1] << '"' << ": " << ex << std::endl;
    return EXIT_FAILURE;
  } catch (...) {
    std::cerr << '"' << argv[1] << '"' << ": Unknown failure" << std::endl;
    return EXIT_FAILURE;
  }

  return EXIT_SUCCESS;
}
