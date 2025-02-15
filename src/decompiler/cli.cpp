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
  std::span<char*> arguments = {argv, argv + argc};
  std::vector<char*> paths;
  for (auto& argument : arguments.subspan(1)) {
    if (argument[0] != '-') {
      paths.push_back(argument);
    }
  }

  if (paths.size() < 1) {
    std::cerr << "USAGE: decomp.exe {cso} [{hlsl}] [--flatten] [-f]\n";
    std::cerr << "  Creates {hlsl} from the contents of {cso}\n";
    return EXIT_FAILURE;
  }

  std::string disassembly;
  try {
    auto code = renodx::utils::path::ReadBinaryFile(paths[0]);
    disassembly = renodx::utils::shader::compiler::directx::DisassembleShader(code);
  } catch (const std::exception& ex) {
    std::cerr << '"' << paths[0] << '"' << ": " << ex.what() << std::endl;
    return EXIT_FAILURE;
  }
  if (disassembly.empty()) {
    std::cerr << "Failed to disassemble shader.\n";
    return EXIT_FAILURE;
  }
  auto decompiler = renodx::utils::shader::decompiler::dxc::Decompiler();

  try {
    bool flatten = std::ranges::any_of(arguments, [](const std::string& argument) {
      return (argument == "--flatten" || argument == "-f");
    });
    std::string decompilation = decompiler.Decompile(disassembly, {.flatten = flatten});

    if (decompilation.empty()) {
      return EXIT_FAILURE;
    }

    std::string output;

    if (paths.size() >= 2) {
      output = paths[1];
    } else {
      std::filesystem::path input_path = argv[1];
      std::filesystem::path output_path = input_path.parent_path();
      const auto& basename = input_path.stem().string();
      output_path /= basename;
      output_path += ".hlsl";
      output = output_path.string();
    }

    renodx::utils::path::WriteTextFile(output, decompilation);
    std::cout << '"' << paths[0] << '"' << " => " << output << std::endl;

  } catch (const std::exception& ex) {
    std::cerr << '"' << paths[0] << '"' << ": " << ex.what() << std::endl;
    return EXIT_FAILURE;
  } catch (const std::string& ex) {
    std::cerr << '"' << paths[0] << '"' << ": " << ex << std::endl;
    return EXIT_FAILURE;
  } catch (...) {
    std::cerr << '"' << paths[0] << '"' << ": Unknown failure" << std::endl;
    return EXIT_FAILURE;
  }

  return EXIT_SUCCESS;
}
