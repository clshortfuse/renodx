#include <cstdlib>

#include <cassert>
#include <exception>
#include <iostream>
#include <ostream>
#include <string>

#include "../utils/path.hpp"
#include "../utils/shader_compiler_directx.hpp"
#include "../utils/shader_decompiler_dxc.hpp"
#include "../utils/shader_decompiler/semantic_labels.hpp"

int main(int argc, char** argv) {
  std::span<char*> arguments = {argv, argv + argc};
  std::vector<char*> paths;
  for (auto& argument : arguments.subspan(1)) {
    if (argument[0] != '-') {
      paths.push_back(argument);
    }
  }

  if (paths.size() < 1) {
    std::cerr << "USAGE: decomp.exe {cso} [{hlsl}] [options]\n";
    std::cerr << "  Creates {hlsl} from the contents of {cso}\n";
    std::cerr << "\n";
    std::cerr << "Options:\n";
    std::cerr << "  --flatten, -f        Optimize/inline expressions\n";
    std::cerr << "  --use-do-while       Use do-while convergence wrappers\n";
    std::cerr << "  --stackify           Recursive if/else nesting with phi_sel\n";
    std::cerr << "  --structural         ShortFuse structural analysis (RECOMMENDED)\n";
    std::cerr << "  --mermaid-decompile  Condition-based flat guarded emission\n";
    std::cerr << "  --mermaid            Output Mermaid flowchart instead of HLSL\n";
    std::cerr << "  --annotate           Add block boundary and condition comments to output\n";
    std::cerr << "  --annotate-mermaid   Add full graph IR dump (nodes, edges, phi assignments)\n";
    std::cerr << "  --semantic-labels    Add semantic labels as inline comments\n";
    std::cerr << "  --skip-existing, -s  Skip if output file exists\n";
    return EXIT_FAILURE;
  }

  std::string disassembly;
  try {
    auto code = renodx::utils::path::ReadBinaryFile(paths[0]);
    disassembly = renodx::utils::shader::compiler::directx::DisassembleShader(code);
  } catch (const std::exception& ex) {
    std::cerr << '"' << paths[0] << '"' << ": " << ex.what() << '\n';
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
    bool skip_existing = std::ranges::any_of(arguments, [](const std::string& argument) {
      return (argument == "--skip-existing" || argument == "-s");
    });
    bool use_do_while = std::ranges::any_of(arguments, [](const std::string& argument) {
      return (argument == "--use-do-while");
    });
    bool stackify = std::ranges::any_of(arguments, [](const std::string& argument) {
      return (argument == "--stackify");
    });
    bool structural = std::ranges::any_of(arguments, [](const std::string& argument) {
      return (argument == "--structural");
    });
    bool annotate = std::ranges::any_of(arguments, [](const std::string& argument) {
      return (argument == "--annotate");
    });
    bool annotate_mermaid = std::ranges::any_of(arguments, [](const std::string& argument) {
      return (argument == "--annotate-mermaid");
    });
    bool mermaid = std::ranges::any_of(arguments, [](const std::string& argument) {
      return (argument == "--mermaid");
    });
    bool mermaid_decompile = std::ranges::any_of(arguments, [](const std::string& argument) {
      return (argument == "--mermaid-decompile");
    });
    bool no_single_use_inline = std::ranges::any_of(arguments, [](const std::string& argument) {
      return (argument == "--no-inline");
    });
    bool semantic_labels = std::ranges::any_of(arguments, [](const std::string& argument) {
      return (argument == "--semantic-labels");
    });
    std::string decompilation = decompiler.Decompile(disassembly, {
                                                                      .flatten = flatten,
                                                                      .use_do_while = use_do_while,
                                                                      .stackify = stackify,
                                                                      .structural = structural,
                                                                      .mermaid = mermaid,
                                                                      .annotate = annotate,
                                                                      .annotate_mermaid = annotate_mermaid,
                                                                      .mermaid_decompile = mermaid_decompile,
                                                                      .no_single_use_inline = no_single_use_inline,
                                                                  });

    if (decompilation.empty()) {
      return EXIT_FAILURE;
    }

    // Apply semantic labeling post-pass if requested
    if (semantic_labels) {
      decompilation = renodx::utils::shader::decompiler::SemanticLabeler::Label(decompilation);
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

    if (skip_existing) {
      if (renodx::utils::path::CheckExistsFile(output)) {
        std::cout << "Skipping " << output << '\n';
        return EXIT_SUCCESS;
      }
    }

    renodx::utils::path::WriteTextFile(output, decompilation);
    std::cout << '"' << paths[0] << '"' << " => " << output << '\n';

  } catch (const std::exception& ex) {
    std::cerr << '"' << paths[0] << '"' << ": " << ex.what() << '\n';
    return EXIT_FAILURE;
  } catch (const std::string& ex) {
    std::cerr << '"' << paths[0] << '"' << ": " << ex << '\n';
    return EXIT_FAILURE;
  } catch (...) {
    std::cerr << '"' << paths[0] << '"' << ": Unknown failure" << '\n';
    return EXIT_FAILURE;
  }

  return EXIT_SUCCESS;
}
