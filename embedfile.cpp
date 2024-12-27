#include <cstdio>
#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <sstream>

namespace {
std::vector<uint8_t> ReadBinaryFile(const std::filesystem::path& path) {
  std::ifstream file(path, std::ios::binary);
  file.seekg(0, std::ios::end);
  const size_t file_size = file.tellg();
  if (file_size == 0) return {};

  auto result = std::vector<uint8_t>(file_size);
  file.seekg(0, std::ios::beg).read(reinterpret_cast<char*>(result.data()), file_size);
  return result;
}

void WriteTextFile(const std::filesystem::path& path, std::string& string) {
  std::ofstream file(path);
  file << string;
}
}  // namespace

int main(int argc, char** argv) {
  if (argc < 3) {
    std::cerr << "USAGE: " << argv[0] << " {rsrc} {sym}\n";
    std::cerr << "\n";
    std::cerr << "  Creates {sym} from the contents of {rsrc}\n";
    return EXIT_FAILURE;
  }

  std::filesystem::path input_path = argv[1];
  std::filesystem::path output_path = argv[2];

  auto binary_data = ReadBinaryFile(input_path);

  std::stringstream stream;

  auto output_basename = output_path.stem().string();

  stream << "#pragma once\n";
  stream << "#ifndef __" << output_basename << "_EMBED_FILE\n";
  stream << "#define __" << output_basename << "_EMBED_FILE\n";
  stream << "#include <cstdint>\n";
  stream << "#include <initializer_list>\n";
  stream << "const std::initializer_list<uint8_t> __" << output_basename << " = {\n";
  size_t current_line_bytes = 0;
  for (uint8_t byte : binary_data) {
    if (current_line_bytes == 0) {
      stream << "   ";
    }
    stream << std::format(" 0x{:02x},", byte);
    if (++current_line_bytes == 8) {
      stream << "\n";
      current_line_bytes = 0;
    }
  }
  stream << "\n};\n";
  stream << "#endif\n";

  std::string output = stream.str();

  WriteTextFile(output_path, output);

  return EXIT_SUCCESS;
}
