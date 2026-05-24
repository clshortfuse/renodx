/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <algorithm>
#include <array>
#include <cassert>
#include <charconv>
#include <cmath>
#include <cstdint>
#include <cstdlib>
#include <exception>
#include <algorithm>
#include <deque>
#include <format>
#include <functional>
#include <iostream>
#include <iterator>
#include <map>
#include <memory>
#include <optional>
#include <ostream>
#include <ranges>
#include <regex>
#include <set>
#include <span>
#include <sstream>
#include <stdexcept>
#include <string>
#include <string_view>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include "../utils/string_view.hpp"

#define DECOMPILER_DXC_DEBUG 0

namespace renodx::utils::shader::decompiler::dxc {
enum class TokenizerState : uint32_t {
  START,
  DESCRIPTION_WHITESPACE,
  DESCRIPTION_INPUT_SIG_TITLE,
  DESCRIPTION_INPUT_SIG_WHITESPACE,
  DESCRIPTION_INPUT_SIG_TABLE_HEADER,
  DESCRIPTION_INPUT_SIG_TABLE_DIVIDER,
  DESCRIPTION_INPUT_SIG_TABLE_ROW,
  DESCRIPTION_INPUT_SIG_TABLE_END,
  DESCRIPTION_OUTPUT_SIG_TITLE,
  DESCRIPTION_OUTPUT_SIG_WHITESPACE,
  DESCRIPTION_OUTPUT_SIG_TABLE_HEADER,
  DESCRIPTION_OUTPUT_SIG_TABLE_DIVIDER,
  DESCRIPTION_OUTPUT_SIG_TABLE_ROW,
  DESCRIPTION_OUTPUT_SIG_TABLE_END,
  DESCRIPTION_SHADER_DEBUG_NAME,
  DESCRIPTION_SHADER_HASH,
  DESCRIPTION_FUNCTIONALITY_NOTE,
  DESCRIPTION_PIPELINE_RUNTIME_TITLE,
  DESCRIPTION_PIPELINE_RUNTIME_WHITESPACE,
  DESCRIPTION_PIPELINE_RUNTIME_INFO,
  DESCRIPTION_PIPELINE_RUNTIME_END,
  DESCRIPTION_INPUT_SIG2_TITLE,
  DESCRIPTION_INPUT_SIG2_WHITESPACE,
  DESCRIPTION_INPUT_SIG2_TABLE_HEADER,
  DESCRIPTION_INPUT_SIG2_TABLE_DIVIDER,
  DESCRIPTION_INPUT_SIG2_TABLE_ROW,
  DESCRIPTION_INPUT_SIG2_TABLE_END,
  DESCRIPTION_OUTPUT_SIG2_TITLE,
  DESCRIPTION_OUTPUT_SIG2_WHITESPACE,
  DESCRIPTION_OUTPUT_SIG2_TABLE_HEADER,
  DESCRIPTION_OUTPUT_SIG2_TABLE_DIVIDER,
  DESCRIPTION_OUTPUT_SIG2_TABLE_ROW,
  DESCRIPTION_OUTPUT_SIG2_TABLE_END,
  DESCRIPTION_BUFFER_DEFINITION_TITLE,
  DESCRIPTION_BUFFER_DEFINITION_WHITESPACE,
  DESCRIPTION_BUFFER_DEFINITION_TYPE,
  DESCRIPTION_BUFFER_DEFINITION_TYPE_BLOCK_START,
  DESCRIPTION_BUFFER_DEFINITION_TYPE_BLOCK,
  DESCRIPTION_BUFFER_DEFINITION_TYPE_BLOCK_END,
  DESCRIPTION_BUFFER_DEFINITION_TYPE_END,
  DESCRIPTION_BUFFER_DEFINITION_TYPE_COMPLETE,
  DESCRIPTION_RESOURCE_BINDINGS_TITLE,
  DESCRIPTION_RESOURCE_BINDINGS_WHITESPACE,
  DESCRIPTION_RESOURCE_BINDINGS_TABLE_HEADER,
  DESCRIPTION_RESOURCE_BINDINGS_TABLE_DIVIDER,
  DESCRIPTION_RESOURCE_BINDINGS_TABLE_ROW,
  DESCRIPTION_RESOURCE_BINDINGS_TABLE_END,
  DESCRIPTION_VIEW_ID_STATE_TITLE,
  DESCRIPTION_VIEW_ID_STATE_WHITESPACE,
  DESCRIPTION_VIEW_ID_STATE_INFO,
  DESCRIPTION_VIEW_ID_STATE_END,
  WHITESPACE,
  TARGET_DATALAYOUT,
  TARGET_TRIPLE,
  TYPE_DEFINITION,
  FUNCTION_DESCRIPTION,
  FUNCTION_DECLARE,
  FUNCTION_ATTRIBUTES,
  CODE_DEFINE,
  CODE_BLOCK,
  CODE_END,
  NAMED_METADATA,
  GLOBAL_VARIABLE,
  COMPLETE
};

inline std::ostream& operator<<(std::ostream& os, const TokenizerState& state) {
  switch (state) {
    case TokenizerState::START:                                          return os << "start";
    case TokenizerState::DESCRIPTION_WHITESPACE:                         return os << "description_whitespace";
    case TokenizerState::DESCRIPTION_INPUT_SIG_TITLE:                    return os << "description_input_sig_title";
    case TokenizerState::DESCRIPTION_INPUT_SIG_WHITESPACE:               return os << "description_input_sig_whitespace";
    case TokenizerState::DESCRIPTION_INPUT_SIG_TABLE_HEADER:             return os << "description_input_sig_table_header";
    case TokenizerState::DESCRIPTION_INPUT_SIG_TABLE_DIVIDER:            return os << "description_input_sig_table_divider";
    case TokenizerState::DESCRIPTION_INPUT_SIG_TABLE_ROW:                return os << "description_input_sig_table_row";
    case TokenizerState::DESCRIPTION_INPUT_SIG_TABLE_END:                return os << "description_input_sig_table_end";
    case TokenizerState::DESCRIPTION_OUTPUT_SIG_TITLE:                   return os << "description_output_sig_title";
    case TokenizerState::DESCRIPTION_OUTPUT_SIG_WHITESPACE:              return os << "description_output_sig_whitespace";
    case TokenizerState::DESCRIPTION_OUTPUT_SIG_TABLE_HEADER:            return os << "description_output_sig_table_header";
    case TokenizerState::DESCRIPTION_OUTPUT_SIG_TABLE_DIVIDER:           return os << "description_output_sig_table_divider";
    case TokenizerState::DESCRIPTION_OUTPUT_SIG_TABLE_ROW:               return os << "description_output_sig_table_row";
    case TokenizerState::DESCRIPTION_OUTPUT_SIG_TABLE_END:               return os << "description_output_sig_table_end";
    case TokenizerState::DESCRIPTION_SHADER_HASH:                        return os << "description_shader_hash";
    case TokenizerState::DESCRIPTION_PIPELINE_RUNTIME_TITLE:             return os << "description_pipeline_runtime_title";
    case TokenizerState::DESCRIPTION_PIPELINE_RUNTIME_WHITESPACE:        return os << "description_pipeline_runtime_whitespace";
    case TokenizerState::DESCRIPTION_PIPELINE_RUNTIME_INFO:              return os << "description_pipeline_runtime_info";
    case TokenizerState::DESCRIPTION_PIPELINE_RUNTIME_END:               return os << "description_pipeline_runtime_end";
    case TokenizerState::DESCRIPTION_INPUT_SIG2_TITLE:                   return os << "description_input_sig2_title";
    case TokenizerState::DESCRIPTION_INPUT_SIG2_WHITESPACE:              return os << "description_input_sig2_whitespace";
    case TokenizerState::DESCRIPTION_INPUT_SIG2_TABLE_HEADER:            return os << "description_input_sig2_table_header";
    case TokenizerState::DESCRIPTION_INPUT_SIG2_TABLE_DIVIDER:           return os << "description_input_sig2_table_divider";
    case TokenizerState::DESCRIPTION_INPUT_SIG2_TABLE_ROW:               return os << "description_input_sig2_table_row";
    case TokenizerState::DESCRIPTION_INPUT_SIG2_TABLE_END:               return os << "description_input_sig2_table_end";
    case TokenizerState::DESCRIPTION_OUTPUT_SIG2_TITLE:                  return os << "description_output_sig2_title";
    case TokenizerState::DESCRIPTION_OUTPUT_SIG2_WHITESPACE:             return os << "description_output_sig2_whitespace";
    case TokenizerState::DESCRIPTION_OUTPUT_SIG2_TABLE_HEADER:           return os << "description_output_sig2_table_header";
    case TokenizerState::DESCRIPTION_OUTPUT_SIG2_TABLE_DIVIDER:          return os << "description_output_sig2_table_divider";
    case TokenizerState::DESCRIPTION_OUTPUT_SIG2_TABLE_ROW:              return os << "description_output_sig2_table_row";
    case TokenizerState::DESCRIPTION_OUTPUT_SIG2_TABLE_END:              return os << "description_output_sig2_table_end";
    case TokenizerState::DESCRIPTION_BUFFER_DEFINITION_TITLE:            return os << "description_buffer_definition_title";
    case TokenizerState::DESCRIPTION_BUFFER_DEFINITION_WHITESPACE:       return os << "description_buffer_definition_whitespace";
    case TokenizerState::DESCRIPTION_BUFFER_DEFINITION_TYPE:             return os << "description_buffer_definition_type";
    case TokenizerState::DESCRIPTION_BUFFER_DEFINITION_TYPE_BLOCK_START: return os << "description_buffer_definition_type_block_start";
    case TokenizerState::DESCRIPTION_BUFFER_DEFINITION_TYPE_BLOCK:       return os << "description_buffer_definition_type_block";
    case TokenizerState::DESCRIPTION_BUFFER_DEFINITION_TYPE_BLOCK_END:   return os << "description_buffer_definition_type_block_end";
    case TokenizerState::DESCRIPTION_BUFFER_DEFINITION_TYPE_END:         return os << "description_buffer_definition_type_end";
    case TokenizerState::DESCRIPTION_BUFFER_DEFINITION_TYPE_COMPLETE:    return os << "description_buffer_definition_type_complete";
    case TokenizerState::DESCRIPTION_RESOURCE_BINDINGS_TITLE:            return os << "description_resource_bindings_title";
    case TokenizerState::DESCRIPTION_RESOURCE_BINDINGS_WHITESPACE:       return os << "description_resource_bindings_whitespace";
    case TokenizerState::DESCRIPTION_RESOURCE_BINDINGS_TABLE_HEADER:     return os << "description_resource_bindings_table_header";
    case TokenizerState::DESCRIPTION_RESOURCE_BINDINGS_TABLE_DIVIDER:    return os << "description_resource_bindings_table_divider";
    case TokenizerState::DESCRIPTION_RESOURCE_BINDINGS_TABLE_ROW:        return os << "description_resource_bindings_table_row";
    case TokenizerState::DESCRIPTION_RESOURCE_BINDINGS_TABLE_END:        return os << "description_resource_bindings_table_end";
    case TokenizerState::DESCRIPTION_VIEW_ID_STATE_TITLE:                return os << "description_view_id_state_title";
    case TokenizerState::DESCRIPTION_VIEW_ID_STATE_WHITESPACE:           return os << "description_view_id_state_whitespace";
    case TokenizerState::DESCRIPTION_VIEW_ID_STATE_INFO:                 return os << "description_view_id_state_info";
    case TokenizerState::DESCRIPTION_VIEW_ID_STATE_END:                  return os << "description_view_id_state_end";
    case TokenizerState::WHITESPACE:                                     return os << "whitespace";
    case TokenizerState::TARGET_DATALAYOUT:                              return os << "target_datalayout";
    case TokenizerState::TARGET_TRIPLE:                                  return os << "target_triple";
    case TokenizerState::TYPE_DEFINITION:                                return os << "type_definition";
    case TokenizerState::CODE_DEFINE:                                    return os << "code_define";
    case TokenizerState::CODE_BLOCK:                                     return os << "code_block";
    case TokenizerState::CODE_END:                                       return os << "code_end";
    case TokenizerState::COMPLETE:                                       return os << "complete";
    case TokenizerState::FUNCTION_DECLARE:                               return os << "function_declare";
    case TokenizerState::FUNCTION_DESCRIPTION:                           return os << "function_description";
    case TokenizerState::FUNCTION_ATTRIBUTES:                            return os << "function_attributes";
    case TokenizerState::GLOBAL_VARIABLE:                                return os << "global_variable";
    case TokenizerState::NAMED_METADATA:                                 return os << "named_metadata";
    default:                                                             return os << "unknown";
  }
}

inline TokenizerState& operator++(TokenizerState& state) {
  state = static_cast<TokenizerState>(static_cast<uint32_t>(state) + 1);
  return state;
}

inline TokenizerState& operator++(TokenizerState& state, int) {
  state = static_cast<TokenizerState>(static_cast<uint32_t>(state) + 1);
  return state;
}

struct Metadata {
  static std::string_view ParseString(std::string_view s) {
    static const std::regex METADATA_STRING_REGEX = std::regex("^!\"(.*)\"$");
    return StringViewMatch(s, METADATA_STRING_REGEX);
  }

  static std::array<std::string_view, 2> ParseKeyValue(std::string_view s) {
    static const std::regex METADATA_KEY_VALUE_REGEX = std::regex(R"(^(.*) (\S+)$)");
    return StringViewMatch<2>(s, METADATA_KEY_VALUE_REGEX);
  }
};

class Decompiler {
  constexpr static const auto VECTOR_INDEXES = "xyzw";

  static std::string ParseIndex(std::string_view input) {
    if (input == "0") return "x";
    if (input == "1") return "y";
    if (input == "2") return "z";
    if (input == "3") return "w";
    assert(false);
    throw std::runtime_error("Could not parse index");
  }

  static uint32_t IndexFromChar(const char input) {
    switch (input) {
      case 'r':
      case 'x': return 0;
      case 'g':
      case 'y': return 1;
      case 'b':
      case 'z': return 2;
      case 'a':
      case 'w': return 3;
      default:  return -1;
    }
  }

  static std::string ParseBoolString(std::string_view input) {
    return std::format("{}", input);
  }

  static std::string ParseIntString(std::string_view input) {
    if (input == "undef") return "0";
    return std::format("{}", input);
  }

  // Convert negative constants to unsigned equivalents (two's complement)
  static std::string ParseUnsignedConstant(std::string_view input, std::string_view dxil_type) {
    if (input == "undef") return "0u";
    if (input.starts_with("%")) return std::string(input);  // variable, not a constant
    // Check if it's a negative constant
    if (!input.empty() && input[0] == '-') {
      int64_t value;
      auto result = std::from_chars(input.data(), input.data() + input.size(), value);
      if (result.ec == std::errc()) {
        // Convert to unsigned based on type width
        if (dxil_type == "i16") {
          uint16_t unsigned_val = static_cast<uint16_t>(value);
          return std::format("{}u", unsigned_val);
        } else if (dxil_type == "i32") {
          uint32_t unsigned_val = static_cast<uint32_t>(value);
          return std::format("{}u", unsigned_val);
        } else if (dxil_type == "i64") {
          uint64_t unsigned_val = static_cast<uint64_t>(value);
          return std::format("{}u", unsigned_val);
        }
      }
    }
    return ParseUintString(input);
  }

  static std::string ParseUintString(std::string_view input) {
    if (input == "undef") return "0u";
    static const auto UINT_LITERAL_REGEX = std::regex{R"(^(?:\d+|0x[0-9A-Fa-f]+)$)"};
    if (std::regex_match(input.begin(), input.end(), UINT_LITERAL_REGEX)) {
      return std::format("{}u", input);
    }
    return std::format("(uint){}", ParseWrapped(input));
  }

  static std::string ParseSuffixedString(std::string_view input, char suffix = 'f') {
    std::string output;

    if (input == "undef") return "0.0f";
    if (input == "0x7FF0000000000000") return "+1.#INF";
    if (input == "0xFFF0000000000000") return "-1.#INF";
    if (input == "0xH7C00") return "+1.#INF";  // Special case for bfloat16 infinity
    if (input == "0xHFC00") return "-1.#INF";  // Special case for bfloat16 -infinity
    if (input.starts_with("0xH")) {
      const std::string string = std::string{input.substr(3)};
      auto as_uint16 = static_cast<uint16_t>(strtoul(string.c_str(), nullptr, 16));
      // bfloat16: upper 16 bits of IEEE 754 float32
      uint32_t sign = (as_uint16 & 0x8000) << 16;
      uint32_t exponent = ((as_uint16 & 0x7C00) >> 10) - 15 + 127;
      uint32_t mantissa = (as_uint16 & 0x03FF) << (23 - 10);

      if ((as_uint16 & 0x7C00) == 0) {
        exponent = 0;  // Subnormal numbers
      } else if ((as_uint16 & 0x7C00) == 0x7C00) {
        exponent = 255;  // Infinity or NaN
        mantissa = ((as_uint16 & 0x03FF) != 0) ? 0x00400000 : 0;
      }

      // Combine into full IEEE 754 float32 format
      uint32_t float_bits = sign | (exponent << 23) | mantissa;

      float as_float;
      memcpy(&as_float, &float_bits, sizeof(as_float));
      if (std::isnan(as_float)) {
        return "asfloat(0x7FC00000u)";
      }
      output = std::format("{}", as_float);
    } else if (input.starts_with("0x")) {
      const std::string string = std::string{input};
      auto unsigned_long = strtoull(string.c_str(), nullptr, 16);
      uint64_t as_uint64 = unsigned_long;
      double_t as_double;
      memcpy(&as_double, &as_uint64, sizeof(as_double));
      if (std::isnan(as_double)) {
        return "asfloat(0x7FC00000u)";
      }
      output = std::format("{}", as_double);
    } else {
      double_t as_double;
      FromStringView(input, as_double);
      output = std::format("{}", as_double);
    }
    if (output == "nan" || output == "-nan" || output == "nan(ind)") {
      return "asfloat(0x7FC00000u)";
    }
    if (output == "inf" || output == "+inf") return "+1.#INF";
    if (output == "-inf") return "-1.#INF";
    bool has_dot = output.find('.') != std::string::npos;
    bool has_plus = output.find('+') != std::string::npos;
    if (!has_dot && !has_plus) {
      output += ".0";
    }
    output += suffix;
    return output;
  }

  static std::string ParseType(std::string_view input) {
    if (input == "float") return "float";
    if (input == "half") return "half";
    if (input == "int") return "int";
    if (input == "uint") return "uint";
    if (input == "bool") return "bool";
    if (input == "i32") return "int";
    if (input == "i64") return "int64_t";
    if (input == "f16") return "min16float";
    if (input == "i16") return "int16_t";
    if (input == "i1") return "bool";
    {
      static const auto MATRIX_REGEX = std::regex(R"(^%class\.matrix\.float\.(\d+)\.(\d+)$)");
      auto [row_count, column_count] = StringViewMatch<2>(input, MATRIX_REGEX);
      if (!row_count.empty() && !column_count.empty()) {
        return std::format("float{}x{}", row_count, column_count);
      }
    }
    {
      static const auto STRUCT_REGEX = std::regex(R"(^%\"?(?:hostlayout\.)?(?:struct\.)?([^"]+)\"?$)");
      auto [struct_name] = StringViewMatch<1>(input, STRUCT_REGEX);
      if (!struct_name.empty()) {
        return std::string(struct_name);
      }
    }
    throw std::runtime_error(std::format("Could not parse code type '{}'", input));
  }

  static std::string ParseBitcast(std::string_view input) {
    if (input == "float") return "asfloat";
    if (input == "i32") return "asint";
    if (input == "i1") return "bool";
    throw std::runtime_error(std::format("Could not parse bitcast '{}'", input));
  }

  static std::string ParseTrunc(std::string_view input) {
    if (input == "i32") return "int";
    if (input == "i16") return "int16_t";
    if (input == "half") return "half";
    throw std::runtime_error(std::format("Could not parse trunc '{}'", input));
  }

  static std::string ParseUnsignedType(std::string_view input) {
    if (input == "i32") return "uint";
    if (input == "i64") return "uint64_t";
    if (input == "i16") return "uint16_t";
    if (input == "i1") return "bool";
    throw std::runtime_error(std::format("Could not parse unsigned '{}'", input));
  }

  static std::string ParseOperator(std::string_view input) {
    if (input == "ogt") return ">";
    if (input == "ugt") return ">";
    if (input == "sgt") return ">";

    if (input == "olt") return "<";
    if (input == "ult") return "<";
    if (input == "slt") return "<";

    if (input == "ole") return "<=";
    if (input == "ule") return "<=";
    if (input == "sle") return "<=";

    if (input == "oge") return ">=";
    if (input == "uge") return ">=";
    if (input == "sge") return ">=";

    if (input == "oeq") return "==";
    if (input == "eq") return "==";

    if (input == "ne") return "!=";
    if (input == "une") return "!=";

    std::cerr << input << "\n";
    throw std::runtime_error(std::format("Could not parse code assignment operator '{}'", input));
  }

  // https://github.com/microsoft/DirectXShaderCompiler/blob/main/docs/DXIL.rst
  // https://github.com/microsoft/DirectXShaderCompiler/blob/main/utils/hct/hctdb_test.py
  // https://github.com/microsoft/DirectXShaderCompiler/blob/main/lib/DXIL/DxilOperations.cpp
  // https://github.com/microsoft/DirectXShaderCompiler/blob/main/include/dxc/DXIL/DxilConstants.h

  inline static const std::map<std::string, std::string> UNARY_FLOAT_OPS = {
      {"6", "abs"},
      {"7", "saturate"},
      {"8", "isnan"},
      {"9", "isinf"},
      {"10", "isfinite"},
      // {"11",   "isNormal"},
      {"12", "cos"},
      {"13", "sin"},
      {"14", "tan"},
      {"15", "acos"},
      {"16", "asin"},
      {"17", "atan"},
      {"18", "cosh"},
      {"19", "sinh"},
      {"20", "tanh"},
      {"21", "exp2"},
      {"22", "frac"},
      {"23", "log2"},
      {"24", "sqrt"},
      {"25", "rsqrt"},
      {"26", "round"},
      {"27", "floor"},
      {"28", "ceil"},
      {"29", "trunc"},
      {"83", "ddx_coarse"},
      {"84", "ddy_coarse"},
      {"85", "ddx_fine"},
      {"86", "ddy_fine"},
  };

  inline static const std::map<std::string, std::string> UNARY_INT32_OPS = {
      {"30", "reversebits"},
  };

  inline static const std::map<std::string, std::string> UNARY_BITS_OPS = {
      {"31", "countbits"},
      {"32", "firstbitlow"},
      {"33", "firstbithigh_msb"},  // uint — returns bit position from MSB (NOT HLSL firstbithigh)
      {"34", "firstbithigh_msb"},  // int — returns bit position from MSB (NOT HLSL firstbithigh)
  };

  inline static const std::map<std::string, std::string> BINARY_FLOAT_OPS = {
      {"35", "max"},
      {"36", "min"},
  };

  inline static const std::map<std::string, std::string> BINARY_INT32_OPS = {
      {"37", "max"},  // imax
      {"38", "min"},  // imin
      {"39", "max"},  // umax
      {"40", "min"},  // umin
  };

  inline static const std::set<std::string> UNSIGNED_BINARY_INT32_OPS = {"39", "40"};

  static std::string OptimizeString(std::string_view line) {
    auto optimized = std::string(line);
    {
      // (((b - a) * t) + a)
      static const auto LERP_REGEX_1 = std::regex(R"(^.*\(\(\(((?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?)) - ((?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?))\) \* ((?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?))\) \+ ((?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?))\).*$)");
      const auto [b, a, t, a2] = StringViewMatch<4>(optimized, LERP_REGEX_1);
      if (!b.empty() && !a.empty() && !t.empty() && !a2.empty() && a == a2) {
        std::string_view prefix = {optimized.data(), b.data() - 3};
        std::string_view suffix = {a2.data() + a2.size() + 1, optimized.data() + optimized.size()};
        optimized = std::format("{}(lerp({}, {}, {})){}", prefix, a, b, t, suffix);
      }
    }
    {
      // "((b - a) * t) + a"
      static const auto LERP_REGEX_1 = std::regex(R"(^\(\(((?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?)) - ((?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?))\) \* ((?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?))\) \+ ((?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?))$)");
      const auto [b, a, t, a2] = StringViewMatch<4>(optimized, LERP_REGEX_1);
      if (!b.empty() && !a.empty() && !t.empty() && !a2.empty() && a == a2) {
        optimized = std::format("(lerp({}, {}, {}))", a, b, t);
      }
    }

    {
      // exp2(log2(base) * exp)
      static const auto LERP_REGEX_1 = std::regex(R"(^.*exp2\(log2\(((?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?))\) \* ((?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?))\).*$)");
      const auto [base, exp] = StringViewMatch<2>(optimized, LERP_REGEX_1);
      if (!base.empty() && !exp.empty()) {
        std::string_view prefix = {optimized.data(), base.data() - 10};
        std::string_view suffix = {exp.data() + exp.size() + 1, optimized.data() + optimized.size()};
        optimized = std::format("{}(pow({}, {})){}", prefix, base, exp, suffix);
      }
    }

    return optimized;
  }

  struct SignaturePacked {
    std::string_view name;

    uint32_t index;
    uint32_t mask;  // Bitwise 1010
    uint32_t dxregister;

    std::string_view sys_value;

    enum class Format {
      FLOAT,
      INT,
      UINT,
      FP16
    } format;

    uint32_t used;

    [[nodiscard]] std::string ToString() const {
      std::stringstream s;
      s << "name: " << this->name;
      s << ", index: " << this->index;
      s << ", mask: " << this->mask;
      s << ", register: " << this->dxregister;
      s << ", sysValue: " << sys_value;
      s << ", format: " << static_cast<uint32_t>(this->format);
      s << ", used: " << this->used;
      return s.str();
    }

    [[nodiscard]] std::string FormatString() const {
      switch (this->format) {
        case Format::FLOAT: return "float";
        case Format::INT:   return "int";
        case Format::UINT:  return "uint";
        case Format::FP16:  return "half";
        default:            return "";
      };
    }

    [[nodiscard]] std::string MaskString() const {
      switch (this->mask) {
        case 0b1000:
        case 0b0100:
        case 0b0010:
        case 0b0001:
          return "1";
        case 0b1100:
        case 0b0110:
        case 0b0011:
          return "2";
        case 0b1110:
        case 0b0111:
          return "3";
        case 0b1111:
          return "4";
        case 0b0000:
          return "4";
        default:
          throw std::runtime_error(std::format("Unknown mask '{}'", mask));
      };
    }

    static uint32_t FlagsFromCoordinates(std::string_view input) {
      uint32_t flags = 0;
      if (input == "N/A") return 0b1000;
      if (input == "NO") return 0;
      if (input == "YES") return 0b1000;
      const size_t len = input.length();

      for (size_t i = 0; i < len; i++) {
        switch (input.at(i)) {
          case 'x': flags += 0b1000; break;
          case 'y': flags += 0b0100; break;
          case 'z': flags += 0b0010; break;
          case 'w': flags += 0b0001; break;
          case ' ': break;
          default:
            throw std::runtime_error(std::format("Unknown coordinate '{}'", input.at(i)));
        }
      }
      return flags;
    }

    static Format FormatFromString(std::string_view input) {
      if (input == "float") return Format::FLOAT;
      if (input == "uint") return Format::UINT;
      if (input == "int") return Format::INT;
      if (input == "fp16") return Format::FP16;
      throw std::runtime_error(std::format("Unknown Format '{}'", input));
    }

    explicit SignaturePacked() = default;
    explicit SignaturePacked(std::string_view line) {
      /**
       * @example
       * ; TEXCOORD                 0   xy          0     NONE   float   xy
       * ; TEXCOORD                 0   xyzw        1     NONE   float   xy
       * ; SV_Position              0   xyzw        1      POS   float
       * ; SV_RenderTargetArrayIndex     0   x           2  RTINDEX    uint   x
       * ; SV_Position              0   xyzw        0      POS   float   xy
       * ; SV_ShadingRate           0     z         4SHDINGRATE    uint     z
       * ; SV_DepthLessEqual        0    N/A oDepthLE  DEPTHLE   float    YES
       */

      static auto regex = std::regex{R"(; (\S+)\s+(\S+)\s+(N\/A|[xyzw ]*[xyzw][xyzw ]*)\s*(\d+|\S+)\s*(\S+)\s+(\S+)\s*(YES|NO|[xyzw ]*))"};
      auto [name, index, mask, dxregister, sysValue, format, used] = StringViewMatch<7>(line, regex);
      if (name.empty()) {
        throw std::runtime_error(std::format("Unknown packed signature row '{}'", line));
      }

      this->name = name;
      FromStringView(index, this->index);
      this->mask = FlagsFromCoordinates(mask);
      FromStringView(dxregister, this->dxregister);
      this->sys_value = sysValue;
      this->format = FormatFromString(format);
      this->used = FlagsFromCoordinates(used);
    }
  };

  struct SignatureProperty {
    std::string_view name;

    uint32_t index;

    enum class InterpMode : uint32_t {
      NONE,
      NOINTERPOLATION,
      NOPERSPECTIVE,
      NOPERSPECTIVE_SAMPLE,
      NOPERSPECTIVE_CENTROID,
      LINEAR,
      CENTROID,
    } interp_mode;

    int32_t dyn_index = -1;

    [[nodiscard]] std::string ToString() const {
      std::stringstream s;
      s << "name: " << this->name;
      s << ", index: " << this->index;
      s << ", interpMode: " << static_cast<uint32_t>(this->interp_mode);
      s << ", dynIndex: " << this->dyn_index;
      return s.str();
    }

    static InterpMode InterpModeFromString(std::string_view input) {
      if (input.empty()) return InterpMode::NONE;
      if (input == "nointerpolation") return InterpMode::NOINTERPOLATION;
      if (input == "noperspective") return InterpMode::NOPERSPECTIVE;
      if (input == "noperspective sample") return InterpMode::NOPERSPECTIVE_SAMPLE;
      if (input == "noperspective centroid") return InterpMode::NOPERSPECTIVE_CENTROID;
      if (input == "linear") return InterpMode::LINEAR;
      if (input == "centroid") return InterpMode::CENTROID;
      throw std::runtime_error(std::format("Unknown InterpMode '{}'", input));
    }

    static int32_t DynIndexFromString(std::string_view input) {
      if (input.empty()) return -1;
      int32_t value = -1;
      FromStringView(input, value);
      return value;
    }

    SignatureProperty() = default;

    explicit SignatureProperty(std::string_view line) {
      /**
       * @example
       * ; SV_Position              0          noperspective
       * ; SV_Position              0                          9
       * ; SV_Target                0
       */
      static auto regex = std::regex{R"(; (\S+)\s+(\S+)(?:$|(?:(.{23})\s*(\S+)?)))"};
      auto [name, index, interpMode, dynIndex] = StringViewMatch<4>(line, regex);

      this->name = name;
      FromStringView(index, this->index);
      this->interp_mode = InterpModeFromString(StringViewTrim(interpMode));
      this->dyn_index = DynIndexFromString(StringViewTrim(dynIndex));
    }
  };

  struct Signature {
    std::string_view name;
    SignaturePacked packed;
    SignatureProperty property;

    explicit Signature() = default;

    explicit Signature(SignaturePacked packed, SignatureProperty property) {
      this->name = packed.name;
      this->packed = packed;
      this->property = property;
    }

    // eg: float; float3; float4
    [[nodiscard]] std::string FullFormatString() const {
      if (property.name == "SV_IsFrontFace") {
        return "bool";
      }
      std::stringstream string_stream;
      string_stream << packed.FormatString();
      auto mask_string = packed.MaskString();
      if (mask_string != "1") {
        string_stream << packed.MaskString();
      }
      return string_stream.str();
    }

    // eg: float; float3; float4
    [[nodiscard]] std::string VariableString() const {
      if (property.index == 0) return std::string{this->name};

      std::stringstream string_stream;
      string_stream << this->name;
      if (property.index != 0) {
        string_stream << "_" << property.index;
      }
      return string_stream.str();
    }

    [[nodiscard]] std::string SemanticString() const {
      std::stringstream string_stream;
      string_stream << property.name;
      if (property.index != 0) {
        string_stream << property.index;
      }
      return string_stream.str();
    }

    [[nodiscard]] std::string ToString() const {
      std::stringstream string_stream;
      // Prevent Z-fighting from fast-math precision mismatches with depth pre-pass
      if (name == "SV_Position") {
        string_stream << "precise ";
      }
      switch (property.interp_mode) {
        case SignatureProperty::InterpMode::NOINTERPOLATION:
          string_stream << "nointerpolation ";
          break;
        case SignatureProperty::InterpMode::LINEAR:
          string_stream << "linear ";
          break;
        case SignatureProperty::InterpMode::NOPERSPECTIVE:
          string_stream << "noperspective ";
          break;
        case SignatureProperty::InterpMode::NOPERSPECTIVE_SAMPLE:
          string_stream << "noperspective sample ";
          break;
        case SignatureProperty::InterpMode::NOPERSPECTIVE_CENTROID:
          string_stream << "noperspective centroid ";
          break;
        case SignatureProperty::InterpMode::NONE:
        default:
          break;
      }
      string_stream << FullFormatString();
      string_stream << " ";
      string_stream << VariableString();
      string_stream << " : ";
      string_stream << SemanticString();
      return string_stream.str();
    }
  };

  struct BufferDefinition {
    /* Size in bytes */
    uint32_t size;
    std::string_view name;

    enum class BufferType {
      CBUFFER,
      RESOURCE
    } buffer_type;

    std::vector<std::string_view> definitions;

    BufferDefinition() = default;

    static BufferType BufferTypeFromString(std::string_view input) {
      if (input == "cbuffer") return BufferType::CBUFFER;
      if (input == "Resource bind info for") return BufferType::RESOURCE;
      throw std::runtime_error(std::format("Unknown BufferType '{}'", input));
    }

    explicit BufferDefinition(std::string_view line) {
      static auto regex = std::regex{R"(; ((?:cbuffer)|(?:Resource bind info for))\s*(.*))"};
      auto [bufferType, name] = StringViewMatch<2>(line, regex);
      this->buffer_type = BufferTypeFromString(bufferType);
      this->name = name;
    }
  };

  struct ResourceDescription {
    std::string_view name;

    enum class ResourceType {
      CBUFFER,
      SAMPLER,
      TEXTURE,
      UAV
    } type;

    enum class ResourceFormat {
      NA,
      BYTE,
      F16,
      I16,
      U16,
      F32,
      I32,
      U32,
      STRUCTURE,
    } format;

    std::string_view dimensions;

    std::string_view id;

    std::string_view hlsl_binding;

    uint32_t count;

    ResourceDescription() = default;

    [[nodiscard]] std::string ResourceTypeString() const {
      if (this->type == ResourceType::CBUFFER) return "cbuffer";
      if (this->type == ResourceType::SAMPLER) return "sampler";
      if (this->type == ResourceType::TEXTURE) return "texture";
      if (this->type == ResourceType::UAV) return "UAV";
      throw std::runtime_error(std::format("Unknown ResourceType '{}'", static_cast<int>(this->type)));
    }

    [[nodiscard]] std::string NameString() const {
      if (!this->name.empty()) return std::string(this->name);
      return std::format("_{}", std::string(this->id));
    }

    static ResourceType ResourceTypeFromString(std::string_view input) {
      if (input == "cbuffer") return ResourceType::CBUFFER;
      if (input == "sampler") return ResourceType::SAMPLER;
      if (input == "texture") return ResourceType::TEXTURE;
      if (input == "UAV") return ResourceType::UAV;
      // Handle merged type+format columns (e.g., "UAVunorm_f32" when no space between columns)
      if (input.starts_with("UAV")) return ResourceType::UAV;
      throw std::runtime_error(std::format("Unknown ResourceType '{}'", input));
    }

    static ResourceFormat ResourceFormatFromString(std::string_view input) {
      if (input == "NA") return ResourceFormat::NA;
      if (input == "byte") return ResourceFormat::BYTE;
      if (input == "f16") return ResourceFormat::F16;
      if (input == "i16") return ResourceFormat::I16;
      if (input == "u16") return ResourceFormat::U16;
      if (input == "f32") return ResourceFormat::F32;
      if (input == "i32") return ResourceFormat::I32;
      if (input == "u32") return ResourceFormat::U32;
      if (input == "struct") return ResourceFormat::STRUCTURE;
      if (input == "unorm_f32") return ResourceFormat::F32;
      if (input == "snorm_f32") return ResourceFormat::F32;
      if (input == "unorm_f16") return ResourceFormat::F16;
      if (input == "snorm_f16") return ResourceFormat::F16;
      throw std::runtime_error(std::format("Unknown ResourceFormat '{}'", input));
    }

    explicit ResourceDescription(std::string_view line) {
      // ; _31_33                            cbuffer      NA          NA     CB0            cb0     1
      // ; RWNumHistoryFramesAccumulated         UAVunorm_f32     2darray      U2             u2     1
      static auto regex = std::regex{R"(; (.{30}\S*)\s+(cbuffer|sampler|texture|UAV)\s*(\S+)\s+(\S+)\s+(\S+) (.{14})(.*))"};
      auto [name, type, format, dimensions, id, hlslBinding, count] = StringViewMatch<7>(line, regex);

      if (name.empty()) {
        // Fallback for unusual formatting
        static auto alt_regex = std::regex{R"(; (.+?)\s{2,}(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(.*))"};
        auto [n, t, f, d, i, h, c] = StringViewMatch<7>(line, alt_regex);
        name = n; type = t; format = f; dimensions = d; id = i; hlslBinding = h; count = c;
      }

      this->name = StringViewTrim(name);
      this->type = ResourceTypeFromString(type);
      this->format = ResourceFormatFromString(format);
      this->dimensions = dimensions;
      this->id = id;
      this->hlsl_binding = StringViewTrim(hlslBinding);
      auto count_trimmed = StringViewTrim(count);
      if (count_trimmed == "unbounded") {
        this->count = 0;
      } else {
        FromStringView(count_trimmed, this->count);
      }
    }
  };
  struct Resource : Metadata {
    uint32_t record_id;
    std::string_view pointer;
    std::string name;
    uint32_t space;
    uint32_t signature_index;
    uint32_t signature_range;
    std::optional<uint32_t> array_size;

    explicit Resource(
        std::vector<std::string_view>& metadata,
        std::span<ResourceDescription> resource_descriptions,
        std::string prefix) : Metadata() {
      // !6 = !{i32 0, %"class.Texture2D<vector<float, 4> >"* undef, !"", i32 0, i32 32, i32 1, i32 2, i32 0, !7}
      // !6 = !{i32 0, [32768 x %"class.Texture2D<vector<float, 4> >"]* undef, !"", i32 1, i32 0, i32 32768, i32 2, i32 0, !7}
      // !11 = !{i32 0, [0 x %struct.SamplerState]* undef, !"", i32 1, i32 0, i32 -1, i32 0, null}
      FromStringView(ParseKeyValue(metadata[0])[1], this->record_id);
      this->pointer = ParseKeyValue(metadata[1])[0];
      static auto array_regex = std::regex{R"(^(?:\[(\S+) x ).*)"};
      const auto [array_size] = StringViewMatch<1>(this->pointer, array_regex);
      if (!array_size.empty()) {
        uint32_t value;
        FromStringView(array_size, value);
        this->array_size = value;
      }

      this->name = ParseString(metadata[2]);
      FromStringView(ParseKeyValue(metadata[3])[1], this->space);
      FromStringView(ParseKeyValue(metadata[4])[1], this->signature_index);
      FromStringView(ParseKeyValue(metadata[5])[1], this->signature_range);

      if (this->name.empty()) {
        std::string hlsl_bind = (space == 0u)
                                    ? std::format("{}{}", prefix, signature_index)
                                    : std::format("{}{},space{}", prefix, signature_index, space);

        for (const auto& description : resource_descriptions) {
          if (description.hlsl_binding == hlsl_bind) {
            if (description.name.empty()) {
              if (space == 0u) {
                this->name = std::format("{}{}", prefix, signature_index);
              } else {
                this->name = std::format("{}{}_space{}", prefix, signature_index, space);
              }
              std::transform(this->name.begin(), this->name.end(), this->name.begin(),
                             [](unsigned char c) { return std::tolower(c); });
            } else {
              this->name = description.name;
            }
            break;
          }
        }
      }
    };

    enum class ResourceKind : unsigned {
      Invalid = 0,
      Texture1D,
      Texture2D,
      Texture2DMS,
      Texture3D,
      TextureCube,
      Texture1DArray,
      Texture2DArray,
      Texture2DMSArray,
      TextureCubeArray,
      TypedBuffer,
      RawBuffer,
      StructuredBuffer,
      CBuffer,
      Sampler,
      TBuffer,
      RTAccelerationStructure,
      FeedbackTexture2D,
      FeedbackTexture2DArray,
      NumEntries,
    };

    static std::string ResourceKindString(const ResourceKind& kind) {
      switch (kind) {
        case ResourceKind::Texture1D:
          return "Texture1D";
        case ResourceKind::Texture2D:
          return "Texture2D";
        case ResourceKind::Texture2DMS:
          return "Texture2DMS";
        case ResourceKind::Texture3D:
          return "Texture3D";
        case ResourceKind::TextureCube:
          return "TextureCube";
        case ResourceKind::Texture1DArray:
          return "Texture1DArray";
        case ResourceKind::Texture2DArray:
          return "Texture2DArray";
        case ResourceKind::Texture2DMSArray:
          return "Texture2DMSArray";
        case ResourceKind::TextureCubeArray:
          return "TextureCubeArray";
        case ResourceKind::TypedBuffer:
          // return "TypedBuffer";
          return "Buffer";
        case ResourceKind::RawBuffer:
          return "ByteAddressBuffer";
        case ResourceKind::StructuredBuffer:
          return "StructuredBuffer";
        case ResourceKind::CBuffer:
          return "CBuffer";
        case ResourceKind::Sampler:
          return "Sampler";
        case ResourceKind::TBuffer:
          return "TBuffer";
        case ResourceKind::RTAccelerationStructure:
          return "RTAccelerationStructure";
        case ResourceKind::FeedbackTexture2D:
          return "FeedbackTexture2D";
        case ResourceKind::FeedbackTexture2DArray:
          return "FeedbackTexture2DArray";
        default:
        case ResourceKind::Invalid:
        case ResourceKind::NumEntries:
          return "";
      }
    }

    enum class ComponentType : uint32_t {
      Invalid = 0,
      I1,
      I16,
      U16,
      I32,
      U32,
      I64,
      U64,
      F16,
      F32,
      F64,
      SNormF16,
      UNormF16,
      SNormF32,
      UNormF32,
      SNormF64,
      UNormF64,
      PackedS8x32,
      PackedU8x32,
      LastEntry
    };

    static std::string ComponentTypeString(const ComponentType& component_type) {
      switch (component_type) {
        case ComponentType::I1:
          return "bool";
        case ComponentType::I16:
          return "short";
        case ComponentType::U16:
          return "ushort";
        case ComponentType::I32:
          return "int";
        case ComponentType::U32:
          return "uint";
        case ComponentType::I64:
          return "int64_t";
        case ComponentType::U64:
          return "uint64_t";
        case ComponentType::F16:
          return "half";
        case ComponentType::F32:
          return "float";
        case ComponentType::F64:
          return "double";
        case ComponentType::SNormF16:
          return "snorm half";
        case ComponentType::UNormF16:
          return "unorm half";
        case ComponentType::SNormF32:
          return "snorm float";
        case ComponentType::UNormF32:
          return "unorm float";
        case ComponentType::SNormF64:
          return "snorm double";
        case ComponentType::UNormF64:
          return "unorm double";
        case ComponentType::PackedS8x32:
          return "p32i8";
        case ComponentType::PackedU8x32:
          return "p32u8";
        default:
        case ComponentType::LastEntry:
        case ComponentType::Invalid:
          return "";
      }
    }

    static bool IsByteAddressBufferPointer(std::string_view pointer) {
      static const auto pattern = std::regex{R"(^(?:\[(\S+) x )?%struct\.ByteAddressBuffer\]?\*+$)"};
      return std::regex_match(pointer.begin(), pointer.end(), pattern);
    }

    static bool IsRWByteAddressBufferPointer(std::string_view pointer) {
      static const auto pattern = std::regex{R"(^(?:\[(\S+) x )?%struct\.RWByteAddressBuffer\]?\*+$)"};
      return std::regex_match(pointer.begin(), pointer.end(), pattern);
    }

    static bool IsAnyByteAddressBufferPointer(std::string_view pointer) {
      return IsByteAddressBufferPointer(pointer) || IsRWByteAddressBufferPointer(pointer);
    }
  };

  struct SRVResource : Resource {
    ResourceKind shape;
    uint32_t sample_count;
    ComponentType element_type;
    uint32_t stride;
    std::string data_type;
    explicit SRVResource(
        std::vector<std::string_view>& metadata,
        std::span<ResourceDescription> resource_descriptions,
        std::map<std::string_view, std::vector<std::string_view>>& raw_metadata)
        : Resource(metadata, resource_descriptions, "t") {
      static auto rtas_pointer_regex = std::regex{R"(^(?:\[(\S+) x )?%struct\.RaytracingAccelerationStructure\*+$)"};
      static auto pointer_regex = std::regex{R"(^(?:\[(\S+) x )?%"(?:hostlayout\.)?class\.([^<]+)<(?:vector<)?([^,>]+)(?:, ([^>]+)>)? ?>"\]?\*)"};
      const auto [rtas_array_size] = StringViewMatch<1>(this->pointer, rtas_pointer_regex);
      const auto [array_size, class_name, base_type, type_count] = StringViewMatch<4>(this->pointer, pointer_regex);

      std::string base_type_fixed;
      std::string_view effective_type_count = type_count;
      if (IsAnyByteAddressBufferPointer(this->pointer)) {
        base_type_fixed.clear();
        effective_type_count = "";
      } else if (!rtas_array_size.empty() || this->pointer == "%struct.RaytracingAccelerationStructure*") {
        base_type_fixed = "RaytracingAccelerationStructure";
        effective_type_count = "";
        if (!rtas_array_size.empty()) {
          uint32_t parsed_array_size = 0;
          FromStringView(rtas_array_size, parsed_array_size);
          this->array_size = parsed_array_size;
        }
      } else if (!base_type.empty()) {
        base_type_fixed = DataType::FixBaseType(base_type);
      }
      this->data_type = std::format("{}{}", base_type_fixed, effective_type_count);

      // https://github.com/microsoft/DirectXShaderCompiler/blob/b766b432678cf5f7a93567d253bb5f7fd8a0b2c7/docs/DXIL.rst#L1047
      uint32_t shape;
      FromStringView(ParseKeyValue(metadata[6])[1], shape);
      this->shape = static_cast<ResourceKind>(shape);
      FromStringView(ParseKeyValue(metadata[7])[1], this->sample_count);
      if (metadata[8] == "null") {
        this->element_type = Resource::ComponentType::Invalid;
        this->stride = 4;
        this->data_type = IsByteAddressBufferPointer(this->pointer) ? "" : "uint4";
      } else {
        auto pairs = raw_metadata[metadata[8]];
        int type_value;
        FromStringView(ParseKeyValue(pairs[0])[1], type_value);
        if (type_value == 0) {
          uint32_t element_type;
          FromStringView(ParseKeyValue(pairs[1])[1], element_type);
          this->element_type = static_cast<ComponentType>(element_type);
          if (this->data_type.empty()) {
            throw std::runtime_error(std::format("SRV '{}': could not determine data_type from pointer '{}'", this->name, this->pointer));
          }
        } else {
          this->element_type = Resource::ComponentType::Invalid;
          FromStringView(ParseKeyValue(pairs[1])[1], this->stride);
          if (this->data_type.empty()) {
            if (!(this->shape == ResourceKind::StructuredBuffer && !base_type_fixed.empty())) {
              this->data_type = std::format("_{}", this->name);
            }
          }
        }
      }
    }
  };

  struct UAVResource : Resource {
    ResourceKind shape;
    bool is_globally_coherent = false;
    bool has_counter = false;
    bool is_rasterizer_ordered_view = false;

    ComponentType element_type;
    uint32_t stride;
    std::string data_type;

    explicit UAVResource(
        std::vector<std::string_view>& metadata,
        std::span<ResourceDescription> resource_descriptions,
        std::map<std::string_view, std::vector<std::string_view>>& raw_metadata)
        : Resource(metadata, resource_descriptions, "u") {
      // https://github.com/microsoft/DirectXShaderCompiler/blob/b766b432678cf5f7a93567d253bb5f7fd8a0b2c7/docs/DXIL.rst#L1047
      static auto pointer_regex = std::regex{R"(^(?:\[(\S+) x )?%"(?:hostlayout\.)?class\.([^<]+)<(?:vector<)?([^,>]+)(?:, ([^>]+)>)? ?>"\]?\*)"};
      const auto [array_size, class_name, base_type, type_count] = StringViewMatch<4>(this->pointer, pointer_regex);

      std::string base_type_fixed;
      std::string_view effective_type_count = type_count;
      if (IsAnyByteAddressBufferPointer(this->pointer)) {
        base_type_fixed.clear();
        effective_type_count = "";
      } else if (!base_type.empty()) {
        base_type_fixed = DataType::FixBaseType(base_type);
      }
      this->data_type = std::format("{}{}", base_type_fixed, effective_type_count);

      uint32_t shape;
      FromStringView(ParseKeyValue(metadata[6])[1], shape);
      this->shape = static_cast<ResourceKind>(shape);

      this->is_globally_coherent = (ParseKeyValue(metadata[7])[1] == "true");
      this->has_counter = (ParseKeyValue(metadata[8])[1] == "true");
      this->has_counter = (ParseKeyValue(metadata[9])[1] == "true");

      if (metadata[10] == "null") {
        // Byte array
        this->element_type = Resource::ComponentType::Invalid;
        this->stride = 4;
        this->data_type = IsRWByteAddressBufferPointer(this->pointer) ? "" : "uint4";
      } else {
        auto pairs = raw_metadata[metadata[10]];
        int type_value;
        FromStringView(ParseKeyValue(pairs[0])[1], type_value);
        if (type_value == 0) {
          uint32_t element_type;
          FromStringView(ParseKeyValue(pairs[1])[1], element_type);
          this->element_type = static_cast<ComponentType>(element_type);
        } else {
          this->element_type = Resource::ComponentType::Invalid;
          FromStringView(ParseKeyValue(pairs[1])[1], this->stride);
          if (!(this->shape == ResourceKind::StructuredBuffer && !base_type_fixed.empty())) {
            this->data_type = std::format("_{}", this->name);
          }
        }
      }
    }
  };

  struct CBVResource : Resource {
    uint32_t buffer_size;
    std::unordered_map<std::string, std::string_view> data_types;
    explicit CBVResource(
        std::vector<std::string_view>& metadata,
        std::span<ResourceDescription> resource_descriptions,
        std::map<std::string_view, std::vector<std::string_view>>& raw_metadata)
        : Resource(metadata, resource_descriptions, "cb") {
      FromStringView(ParseKeyValue(metadata[6])[1], buffer_size);
    }
  };

  struct SamplerResource : Resource {
    uint32_t buffer_size;
    explicit SamplerResource(
        std::vector<std::string_view>& metadata,
        std::span<ResourceDescription> resource_descriptions,
        std::map<std::string_view, std::vector<std::string_view>>& raw_metadata)
        : Resource(metadata, resource_descriptions, "s") {
      FromStringView(ParseKeyValue(metadata[6])[1], buffer_size);
    }
  };

  struct DataType {
    size_t vector_size;
    std::vector<size_t> array_sizes;  // in C++ dereferencing order
    std::string data_type;

    static std::string FixBaseType(std::string_view data_type) {
      assert(!data_type.empty());
      if (data_type == "i32") return "int";
      if (data_type == "unsigned int") return "uint";
      if (data_type == "unsigned long long") return "uint64_t";
      if (data_type == "long long") return "int64_t";
      return std::string(data_type);
    }

    explicit DataType(std::string_view line) {
      static auto regex = std::regex{R"(^(?:\[(\S+) x )?(?:\[(\S+) x )?(?:<(\S+) x )?([^*>\]]+)(\*)?>?\]?\]?$)"};
      // Alternate regex for quoted type names containing < > (e.g., %"struct.pa_uint16_array<10>")
      static auto quoted_regex = std::regex{R"(^(?:\[(\S+) x )?(?:\[(\S+) x )?(%"[^"]+")(\*)?\]?\]?$)"};
      auto [array_size_a, array_size_b, vector_size, data_type, is_pointer] = StringViewMatch<5>(line, regex);
      if (data_type.empty()) {
        // Try quoted type regex (no vector prefix possible for quoted struct names)
        auto [qa, qb, qtype, qptr] = StringViewMatch<4>(line, quoted_regex);
        if (!qtype.empty()) {
          if (!qa.empty()) {
            if (qb.empty()) {
              array_sizes.resize(1);
              FromStringView(qa, array_sizes[0]);
            } else {
              array_sizes.resize(2);
              FromStringView(qa, array_sizes[1]);
              FromStringView(qb, array_sizes[0]);
            }
          }
          this->vector_size = 0;
          this->data_type = FixBaseType(qtype);
          return;
        }
      }
      if (!array_size_a.empty()) {
        if (array_size_b.empty()) {
          array_sizes.resize(1);
          FromStringView(array_size_a, array_sizes[0]);
        } else {
          array_sizes.resize(2);
          FromStringView(array_size_a, array_sizes[1]);
          FromStringView(array_size_b, array_sizes[0]);
        }
      }

      if (vector_size.empty()) {
        this->vector_size = 0;
      } else {
        FromStringView(vector_size, this->vector_size);
      }
      this->data_type = FixBaseType(data_type);
    }
  };

  struct Variable {
    std::string declaration;
    std::string name;
    std::string_view type;
    std::optional<uint32_t> offset;
  };
  struct TypeDefinition {
    std::string_view name;
    std::vector<Variable> variables;
    std::optional<uint32_t> size;
    bool has_offsets = false;

    TypeDefinition() = default;

    explicit TypeDefinition(std::string_view line) {
      // %"class.Texture3D<vector<float, 4> >" = type { <4 x float>, %"class.Texture3D<vector<float, 4> >::mips_type" }
      static auto regex = std::regex{R"(^(%(?:(?:"[^"]+")|\S+)) = type \{([^}]+)\}$)"};

      auto [name, types] = StringViewMatch<2>(line, regex);

      this->name = name;
      int value = 0;

      // Quote-aware comma splitting (upstream approach)
      size_t token_start = 0;
      bool in_quotes = false;
      for (size_t i = 0; i < types.size(); ++i) {
        if (types[i] == '"') {
          in_quotes = !in_quotes;
        } else if (types[i] == ',' && !in_quotes) {
          auto token = StringViewTrim(types.substr(token_start, i - token_start));
          if (!token.empty()) {
            this->variables.emplace_back("", std::format("value{:03}", value++), token);
          }
          token_start = i + 1;
        }
      }

      auto token = StringViewTrim(types.substr(token_start));
      if (!token.empty()) {
        this->variables.emplace_back("", std::format("value{:03}", value++), token);
      }
    }
  };

  struct ResourceBindingVariable {
    std::string name;
    uint32_t range_index;
    std::string resource_class;
  };

  // Extra info for heap-created resource handles (SM6.6 bindless)
  struct HeapResourceInfo {
    Resource::ResourceKind resource_kind = Resource::ResourceKind::Invalid;
    std::string data_type;
  };

  struct PreprocessState {
    std::vector<Signature> input_signature;
    std::vector<Signature> output_signature;
    std::vector<ResourceDescription> resource_descriptions;
    std::map<std::string, std::string> global_variables;
    std::vector<std::string> global_variables_decompiled;
    std::map<std::string, ResourceBindingVariable> resource_binding_variables;
    std::vector<SRVResource> srv_resources;
    std::vector<UAVResource> uav_resources;
    std::vector<CBVResource> cbv_resources;
    std::vector<SamplerResource> sampler_resources;
    std::map<std::string_view, TypeDefinition> type_definitions;
    std::map<std::string_view, std::tuple<CBVResource*, uint32_t, std::string>> cbv_binding_variables;
    std::map<std::string_view, std::tuple<SRVResource*, std::string, std::string, std::string, std::string>> srv_binding_load_variables;
    std::map<std::string_view, std::tuple<UAVResource*, std::string, std::string, std::string, std::string>> uav_binding_load_variables;
    std::vector<BufferDefinition> buffer_definitions;
    std::set<uint32_t> cbv_dynamic_access_indices;  // CBV range indices that use dynamic offset
    std::set<std::string> cbv_handles_with_dynamic_access;  // Handle variables (e.g. "%15") that use dynamic cbuffer indexing
    bool uses_view_id = false;  // Whether the shader uses SV_ViewID (dx.op.viewID)

    // Tracks variables created by createHandleFromHeap (SM6.6 bindless)
    struct HeapHandleInfo {
      std::string heap_index;  // The descriptor heap index expression
      bool is_non_uniform;
    };
    std::map<std::string, HeapHandleInfo> heap_handle_variables;
    uint32_t heap_srv_counter = 0;  // Counter for generating unique synthetic names

    // Maps variable name -> heap resource info for handles created via createHandleFromHeap
    std::map<std::string, HeapResourceInfo> heap_resource_info;

    // Helper to resolve resource shape from a binding variable (handles both normal and heap resources)
    Resource::ResourceKind GetResourceShape(const std::string& var_name) const {
      auto heap_it = heap_resource_info.find(var_name);
      if (heap_it != heap_resource_info.end()) return heap_it->second.resource_kind;
      auto binding_it = resource_binding_variables.find(var_name);
      if (binding_it == resource_binding_variables.end()) return Resource::ResourceKind::Invalid;
      auto& binding = binding_it->second;
      auto [name, range_index, resource_class] = binding;
      if (resource_class == "0" && range_index < srv_resources.size()) return srv_resources[range_index].shape;
      if (resource_class == "1" && range_index < uav_resources.size()) return uav_resources[range_index].shape;
      return Resource::ResourceKind::Invalid;
    }

    // Helper to check if a binding variable refers to a heap resource
    bool IsHeapResource(const std::string& var_name) const {
      return heap_resource_info.count(var_name) > 0;
    }

    // Helper to get data_type for a resource binding variable (handles heap resources)
    std::string GetResourceDataType(const std::string& var_name) const {
      auto heap_it = heap_resource_info.find(var_name);
      if (heap_it != heap_resource_info.end()) return heap_it->second.data_type;
      auto binding_it = resource_binding_variables.find(var_name);
      if (binding_it == resource_binding_variables.end()) return "float4";
      auto& binding = binding_it->second;
      auto [name, range_index, resource_class] = binding;
      if (resource_class == "0" && range_index < srv_resources.size()) return srv_resources[range_index].data_type;
      if (resource_class == "1" && range_index < uav_resources.size()) return uav_resources[range_index].data_type;
      return "float4";
    }

    size_t GetTypeSize(const DataType& data_type) {
      size_t data_type_size = 0;

      if (data_type.data_type == "float") {
        data_type_size = 32 / 8;
      } else if (data_type.data_type == "int") {
        data_type_size = 32 / 8;
      } else if (data_type.data_type == "uint") {
        data_type_size = 32 / 8;
      } else if (data_type.data_type == "i32") {
        data_type_size = 32 / 8;
      } else if (data_type.data_type == "half" || data_type.data_type == "i16") {
        data_type_size = 16 / 8;
      } else if (data_type.data_type == "int64_t" || data_type.data_type == "uint64_t" || data_type.data_type == "double" || data_type.data_type == "i64") {
        data_type_size = 64 / 8;
      } else if (data_type.data_type == "bool") {
        data_type_size = 8 / 8;
      } else if (data_type.data_type.starts_with("%class.matrix.")) {
        // %class.matrix.float.4.4 → look up in type_definitions
        auto pair = type_definitions.find(data_type.data_type);
        if (pair != type_definitions.end()) {
          auto type_definition = pair->second;
          for (auto& [declaration, name, type_name, optional_offset] : type_definition.variables) {
            data_type_size += GetTypeSize(DataType(type_name));
          }
        } else {
          // Parse directly: %class.matrix.{type}.{rows}.{cols}
          static const std::regex MATRIX_PATTERN(R"(%class\.matrix\.([^.]+)\.(\d+)\.(\d+))");
          auto [base_type, rows_str, cols_str] = StringViewMatch<3>(data_type.data_type, MATRIX_PATTERN);
          if (!base_type.empty()) {
            uint32_t rows, cols;
            FromStringView(rows_str, rows);
            FromStringView(cols_str, cols);
            size_t scalar_size = (base_type == "float") ? 4 : 4;
            data_type_size = scalar_size * rows * cols;
          }
        }
      } else if (auto pair = type_definitions.find(data_type.data_type);
                 pair != type_definitions.end()) {
        auto type_definition = pair->second;
        auto uses_reflected_offsets =
            type_definition.has_offsets || std::ranges::any_of(type_definition.variables, [](const auto& variable) {
              return variable.offset.has_value();
            });
        if (uses_reflected_offsets) {
          size_t current_offset = 0;
          for (auto& [declaration, name, type_name, optional_offset] : type_definition.variables) {
            auto field_offset = optional_offset.value_or(current_offset);
            auto field_size = GetTypeSize(DataType(type_name));
            data_type_size = (std::max)(data_type_size, field_offset + field_size);
            current_offset = field_offset + field_size;
          }
        } else if (type_definition.size.has_value()) {
          data_type_size = type_definition.size.value();
        } else {
          for (auto& [declaration, name, type_name, optional_offset] : type_definition.variables) {
            data_type_size += GetTypeSize(DataType(type_name));
          }
        }
      } else {
        // Avoid infinite recursion: if the inner DataType has the same data_type string, bail
        DataType inner(data_type.data_type);
        if (inner.data_type == data_type.data_type && inner.vector_size == 0 && inner.array_sizes.empty()) {
          throw std::runtime_error(std::format("Unknown data type '{}' while computing size", data_type.data_type));
        }
        data_type_size = GetTypeSize(inner);
      }

      if (data_type.vector_size > 1) {
        data_type_size *= data_type.vector_size;
      }
      for (auto array_size : data_type.array_sizes) {
        data_type_size *= array_size;
      }
      assert(data_type_size != 0);
      return data_type_size;
    }

    std::string GetSubValueFromType(std::string_view type_namex, const DataType& info, uint32_t offset) {
      uint32_t data_type_size = GetTypeSize(DataType(info.data_type));
      if (info.vector_size != 0) {
        data_type_size *= info.vector_size;
      }

      uint32_t inner_offset = offset;
      std::string value;

      // array_sizes in C++ dereferencing order
      for (auto it = info.array_sizes.begin(); it != info.array_sizes.end(); ++it) {
        size_t array_data_size = data_type_size;
        for (auto it2 = it + 1; it2 != info.array_sizes.end(); ++it2) {
          // Increase by next array sizes;
          array_data_size *= *it2;
        }

        size_t array_index = inner_offset / array_data_size;
        value += std::format("[{}]", array_index);
        inner_offset = inner_offset % array_data_size;
      }

      if (info.data_type.starts_with("%class")) {
        // known classes
        if (info.data_type.starts_with("%class.matrix.float")) {
          static const std::regex PATTERN = std::regex(R"(%class\.matrix\.([^.]+)\.(\d+)\.(\d+))");
          auto [base_type, array_string, vector_string] = StringViewMatch<3>(info.data_type, PATTERN);
          uint32_t array;
          FromStringView(array_string, array);
          uint32_t vector;
          FromStringView(vector_string, vector);
          assert(base_type == "float");
          value += std::format("[{}].{}", inner_offset / (vector * 4), VECTOR_INDEXES[(inner_offset % (vector * 4)) / 4]);
        } else {
          assert(false);
        }
      } else if (info.data_type == "float" || info.data_type == "uint" || info.data_type == "int") {
        if (info.vector_size != 0) {
          assert(inner_offset <= 16);
          value += std::format(".{}", VECTOR_INDEXES[inner_offset / 4]);
        }
      } else if (info.data_type == "half" || info.data_type == "int16_t" || info.data_type == "i16") {
        if (info.vector_size != 0) {
          value += std::format(".{}", VECTOR_INDEXES[inner_offset / 2]);
        }
      } else if (info.data_type == "uint64_t" || info.data_type == "int64_t" || info.data_type == "double" || info.data_type == "i64") {
        if (info.vector_size != 0) {
          value += std::format(".{}", VECTOR_INDEXES[inner_offset / 8]);
        }
      } else {
        value += ".";
        if (info.data_type.starts_with("%struct.")) {
          auto& sub_type = type_definitions[info.data_type];
          value += DataTypeNameAtIndex(sub_type.variables, inner_offset);
        } else if (info.data_type.starts_with("%hostlayout.struct.")) {
          auto& sub_type = type_definitions[info.data_type];
          value += DataTypeNameAtIndex(sub_type.variables, inner_offset);
        } else if (info.data_type.starts_with("%\"")) {
          auto& sub_type = type_definitions[info.data_type];
          value += DataTypeNameAtIndex(sub_type.variables, inner_offset);
        } else if (info.data_type.starts_with("%")) {
          // Generic type lookup (e.g., %class.matrix.float.4.4)
          auto it = type_definitions.find(info.data_type);
          if (it != type_definitions.end()) {
            value += DataTypeNameAtIndex(it->second.variables, inner_offset);
          } else {
            return "UNKNOWN";
          }
        } else {
          throw std::runtime_error(std::format("GetSubValueFromType: unhandled data_type '{}' at offset {}", info.data_type, inner_offset));
          return "UNKNOWN";
        }
      }
      return value;
    }

    std::string DataTypeNameAtIndex(const std::vector<Variable>& variables, uint32_t index) {
      std::string complete_name;
      auto current_index = 0;
      auto pending = index;
      for (const auto& [declaration, name, type_name, optional_offset] : variables) {
        DataType info(type_name);
        uint32_t data_type_size = GetTypeSize(info);

        if (optional_offset.has_value()) {
          auto real_offset = optional_offset.value();
          auto distance = index - real_offset;
          if (distance < 0) continue;
          if (distance >= data_type_size) continue;
          pending = distance;
        } else {
          if (pending != 0 && pending >= data_type_size) {
            pending -= data_type_size;
            continue;
          }
        }

        return name + GetSubValueFromType(type_name, info, pending);
      }
      assert(false);
      return complete_name;
    };

    // Resolves a byte offset within a structured buffer to the field name only (no vector swizzle).
    // Used for rawBufferStore where we write the entire field at once.
    std::string ResourceFieldNameAtOffset(const Resource& resource, uint32_t offset) {
      auto type_name = resource.pointer.substr(0, resource.pointer.length() - 1);
      auto pair = type_definitions.find(type_name);
      if (pair == type_definitions.end()) {
        static auto array_inner_regex = std::regex{R"(^\[\d+ x (.+)\]$)"};
        auto [inner_type] = StringViewMatch<1>(type_name, array_inner_regex);
        if (!inner_type.empty()) {
          pair = type_definitions.find(inner_type);
        }
        if (pair == type_definitions.end()) {
          return "";
        }
      }
      auto& definition = pair->second;

      auto effective_type_name = (pair == type_definitions.end()) ? type_name : std::string_view(pair->first);
      if (effective_type_name.starts_with("%\"class.StructuredBuffer<") || effective_type_name.starts_with("%\"class.RWStructuredBuffer<")
          || effective_type_name.starts_with("%\"hostlayout.class.StructuredBuffer<") || effective_type_name.starts_with("%\"hostlayout.class.RWStructuredBuffer<")) {
        auto struct_pair = type_definitions.find(definition.variables[0].type);
        if (struct_pair != type_definitions.end()) {
          // Find the field at this offset without sub-value resolution
          uint32_t running_offset = 0;
          for (const auto& [declaration, name, field_type, optional_offset] : struct_pair->second.variables) {
            DataType info(field_type);
            uint32_t data_type_size = GetTypeSize(info);
            uint32_t field_start = optional_offset.has_value() ? optional_offset.value() : running_offset;
            uint32_t field_end = field_start + data_type_size;
            if (offset >= field_start && offset < field_end) {
              // Offset is within this field
              uint32_t offset_in_field = offset - field_start;
              if (!info.array_sizes.empty()) {
                // Array field: compute element index
                uint32_t element_size = data_type_size;
                for (auto arr_size : info.array_sizes) {
                  element_size /= arr_size;
                }
                uint32_t array_index = offset_in_field / element_size;
                uint32_t offset_in_element = offset_in_field % element_size;
                // Drill into struct elements if there's remaining offset
                if (offset_in_element > 0 && (info.data_type.starts_with("%struct.") || info.data_type.starts_with("%hostlayout.struct."))) {
                  auto elem_pair = type_definitions.find(info.data_type);
                  if (elem_pair != type_definitions.end()) {
                    std::string sub_field = DataTypeNameAtIndex(elem_pair->second.variables, offset_in_element);
                    return std::format(".{}[{}].{}", name, array_index, sub_field);
                  }
                }
                return std::format(".{}[{}]", name, array_index);
              }
              // Non-array struct field: drill into it if there's remaining offset
              if (offset_in_field > 0 && (info.data_type.starts_with("%struct.") || info.data_type.starts_with("%hostlayout.struct."))) {
                auto nested_pair = type_definitions.find(info.data_type);
                if (nested_pair != type_definitions.end()) {
                  std::string sub_field = DataTypeNameAtIndex(nested_pair->second.variables, offset_in_field);
                  return std::format(".{}.{}", name, sub_field);
                }
              } else if (offset_in_field == 0 && (info.data_type.starts_with("%struct.") || info.data_type.starts_with("%hostlayout.struct."))) {
                // Struct field at offset 0 — drill into first sub-field so scalar stores resolve correctly
                auto nested_pair = type_definitions.find(info.data_type);
                if (nested_pair != type_definitions.end()) {
                  std::string sub_field = DataTypeNameAtIndex(nested_pair->second.variables, 0);
                  return std::format(".{}.{}", name, sub_field);
                }
              }
              return "." + name;
            }
            running_offset = field_end;
          }
        }
      }
      return "";
    };

    std::string ResourceVariableNameAtIndex(const Resource& resource, uint32_t index) {
      auto type_name = resource.pointer.substr(0, resource.pointer.length() - 1);
      auto pair = type_definitions.find(type_name);
      if (pair == type_definitions.end()) {
        // Try stripping array wrapper: [N x %type] -> %type
        static auto array_inner_regex = std::regex{R"(^\[\d+ x (.+)\]$)"};
        auto [inner_type] = StringViewMatch<1>(type_name, array_inner_regex);
        if (!inner_type.empty()) {
          pair = type_definitions.find(inner_type);
        }
        if (pair == type_definitions.end()) {
          return "";  // Can't resolve
        }
      }
      auto& definition = pair->second;

      // Check for StructuredBuffer (may be the original type_name or the inner type after array stripping)
      auto effective_type_name = (pair == type_definitions.end()) ? type_name : std::string_view(pair->first);
      if (effective_type_name.starts_with("%\"class.StructuredBuffer<") || effective_type_name.starts_with("%\"class.RWStructuredBuffer<")
          || effective_type_name.starts_with("%\"hostlayout.class.StructuredBuffer<") || effective_type_name.starts_with("%\"hostlayout.class.RWStructuredBuffer<")) {
        auto struct_pair = type_definitions.find(definition.variables[0].type);
        if (struct_pair != type_definitions.end()) {
          return "." + DataTypeNameAtIndex(struct_pair->second.variables, index);
        }
        return GetSubValueFromType(definition.variables[0].type, DataType(definition.variables[0].type), index);
      }
      return DataTypeNameAtIndex(definition.variables, index);
    };

    std::string ResourceVariableNameAtIndex(const CBVResource& resource, uint32_t index) {
      auto type_name = resource.pointer.substr(0, resource.pointer.length() - 1);
      auto pair = type_definitions.find(type_name);
      if (pair == type_definitions.end()) {
        // Try stripping array wrapper: [N x %type] -> %type
        static auto array_inner_regex = std::regex{R"(^\[\d+ x (.+)\]$)"};
        auto [inner_type] = StringViewMatch<1>(type_name, array_inner_regex);
        if (!inner_type.empty()) {
          pair = type_definitions.find(inner_type);
        }
        if (pair == type_definitions.end()) {
          return "";  // Can't resolve — caller will use fallback
        }
      }
      auto& definition = pair->second;

      if (definition.has_offsets || resource.buffer_size == definition.size) {
        return DataTypeNameAtIndex(definition.variables, index);
      }
      return "";
    };

    void ProcessBufferDefinitions(
        std::span<std::string_view> buffer_definition_lines,
        uint32_t base_offset = 0) {
      size_t current_index = 0;

      TypeDefinition* type_definition = nullptr;
      int depth = 0;
      std::string_view* inner_span_begin = nullptr;
      std::string_view* inner_span_end = nullptr;

      // look for name by offset, should line up with variables
      for (auto it = buffer_definition_lines.begin(); it != buffer_definition_lines.end(); ++it) {
        auto& line = *it;
        static const auto REGEX = std::regex(R"(;\s*([{}])?\s*([^;]*)(?:;*\s*; Offset:)?\s*(\d*)(?: Size:\s*\d*)?)");
        auto [line_brace, line_declaration, line_offset] = StringViewMatch<3>(line, REGEX);
        uint32_t line_offset_number = 0;

        if (!line_offset.empty()) {
          FromStringView(line_offset, line_offset_number);
        }

        if (line_brace == "{") {
          depth++;
          if (depth == 2) {
            inner_span_begin = &*(it - 1);
          }
          continue;
        }

        if (line_brace == "}") {
          if (depth == 2) {
            inner_span_end = &*(it);
            ProcessBufferDefinitions(std::span<std::string_view>(inner_span_begin, inner_span_end), line_offset_number);
          }
          depth--;

        } else if (line_offset.empty()) {
          if (line_declaration.empty()) {
            // blank line
            continue;
          }
          if (depth != 0) continue;
          if (line_declaration.starts_with("struct ")) {
            std::string definition = std::string("%") + std::string(line_declaration.substr(7));
            if (definition == "%$Globals") {
              definition = "%\"$Globals\"";
            }
            // LLVM IR quotes identifiers containing special characters like '$', '<', '>'
            auto needs_quoting = [](const std::string& s) {
              return s.find('$') != std::string::npos
                  || s.find('<') != std::string::npos
                  || s.find('>') != std::string::npos;
            };
            if (needs_quoting(definition) && !definition.starts_with("%\"")) {
              definition = "%\"" + definition.substr(1) + "\"";
            }
            auto pair = this->type_definitions.find(definition);
            // Try with "struct." prefix if not found (buffer definitions strip it)
            if (pair == this->type_definitions.end()) {
              std::string with_struct = "%\"struct." + definition.substr(definition.starts_with("%\"") ? 2 : 1);
              if (!with_struct.ends_with("\"")) with_struct += "\"";
              pair = this->type_definitions.find(with_struct);
            }
            if (pair == this->type_definitions.end()) {
              // Skip type definitions we can't resolve — non-fatal
              continue;
            }
            type_definition = &pair->second;
            type_definition->has_offsets = true;
            continue;
          }
          if (line.find("(type annotation not present)") != std::string_view::npos) {
            continue;
          }
          assert(false);
        }

        if (depth != 1) continue;
        assert(type_definition != nullptr);

        auto& item = type_definition->variables[current_index++];

        item.declaration.assign(line_declaration);

        // Doesn't work, C++ bug?
        // static const auto NAME_REGEX = std::regex(R"((\w+)(\[\d+\])?$)");
        // auto [candidate_name, candidate_array] = StringViewMatch<2>(candidate_declaration, NAME_REGEX);

        // Manual string search
        auto candidate_names = StringViewSplitAll(line_declaration, ' ');
        if (candidate_names.empty()) break;
        auto candidate_name = candidate_names.back();
        auto array_start_index = candidate_name.find_first_of('[');
        if (array_start_index != std::string_view::npos) {
          candidate_name = candidate_name.substr(0, array_start_index);
        }

        if (candidate_name.empty()) {
          assert(!candidate_name.empty());
          break;
        }

        item.name.assign(candidate_name);
        item.offset = line_offset_number - base_offset;
      }
    }

    void RecompileTypeDefinitions() {
      for (auto& [type_definition_name, definition] : this->type_definitions) {
        int offset = 0;
        int size = 0;
        if (!type_definition_name.starts_with("%")) continue;
        if (type_definition_name.starts_with("%class.")) continue;
        if (type_definition_name.starts_with("%\"class.")) continue;
        if (type_definition_name.starts_with("%dx.types.")) continue;

        static const std::regex PATTERN = std::regex(R"(%\"?(?:host)?(?:layout\.)?(?:struct\.)?([^"]*)\"?)");
        auto [real_name] = StringViewMatch<1>(type_definition_name, PATTERN);
        assert(!real_name.empty());

        for (auto& [declaration, variable_name, type_name, optional_offset] : definition.variables) {
          DataType info(type_name);
          variable_name.assign(std::format("{}_{:03}", real_name, offset));
          size = GetTypeSize(info);
          offset += size;
        }

        definition.size = offset;
      }

      for (auto& candidate : this->buffer_definitions) {
        ProcessBufferDefinitions(candidate.definitions, 0);
      }
    }

    // Apply HLSL cbuffer packing rules to CBV types that lack annotation data.
    // Must be called AFTER cbv_resources are populated (metadata parsing).
    void ApplyCBufferPacking() {
      for (const auto& cbv : this->cbv_resources) {
        auto type_name = cbv.pointer.substr(0, cbv.pointer.length() - 1);
        auto pair = this->type_definitions.find(type_name);
        if (pair == this->type_definitions.end()) continue;
        auto& definition = pair->second;

        // Skip if already has annotation-based offsets
        if (definition.has_offsets) continue;

        // Compute packed size using cbuffer rules
        static const std::regex PATTERN = std::regex(R"(%\"?(?:host)?(?:layout\.)?(?:struct\.)?([^"]*)\"?)");
        auto [real_name] = StringViewMatch<1>(type_name, PATTERN);
        if (real_name.empty()) continue;

        int offset = 0;
        for (auto& [declaration, variable_name, field_type, optional_offset] : definition.variables) {
          DataType info(field_type);
          int field_size = static_cast<int>(GetTypeSize(info));

          bool is_array = !info.array_sizes.empty();
          bool is_struct = info.data_type.starts_with("%struct.") || info.data_type.starts_with("%hostlayout.")
                        || info.data_type.starts_with("%\"struct.") || info.data_type.starts_with("%\"hostlayout.");
          bool is_matrix = info.data_type.starts_with("%class.matrix.") || info.data_type.starts_with("class.matrix.");

          if (is_array || is_struct || is_matrix) {
            offset = (offset + 15) & ~15;
          } else {
            int register_offset = offset % 16;
            if (register_offset + field_size > 16) {
              offset = (offset + 15) & ~15;
            }
          }

          variable_name.assign(std::format("{}_{:03}", real_name, offset));
          optional_offset = static_cast<uint32_t>(offset);
          offset += field_size;
        }

        // Only apply if packed size matches the declared buffer size
        if (static_cast<uint32_t>(offset) == cbv.buffer_size) {
          definition.size = offset;
          definition.has_offsets = true;
        }
        // If sizes don't match, leave the original tight-packed layout
        // (the per-component fallback will be used)
      }
    }
  };

  struct CodeBranch {
    std::string branch_condition;
    int branch_condition_true = -1;
    int branch_condition_false = -1;
    bool use_hint = false;
  };

  struct CodeSwitch {
    std::string switch_condition;
    int case_default = -1;
    std::vector<std::pair<std::string_view, int>> case_values;
    std::unordered_set<int> branches;  // for tracking convergences
    bool use_hint = false;
  };

  struct PhiData {
    //   %50 = phi i1 [ false, %0 ], [ %48, %45 ]
    std::string variable;
    std::string type;
    std::string value;
    int predecessor;
    int code_function;
    bool is_assign = false;
  };
  struct CodeBlock {
    std::vector<std::string> hlsl_lines;
    std::vector<PhiData> phi_lines;

    CodeBranch code_branch;
    CodeSwitch code_switch;
  };

  static bool IsWrapped(std::string_view input) {
    if (!input.starts_with('(')) return false;
    size_t parentheses_count = 1;
    auto size = input.size();
    for (auto i = 1; i < size; i++) {
      if (input[i] == '(') {
        ++parentheses_count;
      } else if (input[i] == ')') {
        if (parentheses_count == 1) {
          return (i == size - 1);
        }
        --parentheses_count;
      }
    }
    return false;
  }

  static std::string ParseWrapped(std::string_view input) {
    assert(!input.empty());
    return (!IsWrapped(input))
               ? std::format("({})", input)
               : std::string(input);
  }

  static std::string CastType(std::string_view type, std::string_view variable) {
    assert(!type.empty());
    return std::format("({}){}", type, ParseWrapped(variable));
  }

  struct CodeFunction {
    std::string_view name;
    std::string_view return_type;
    std::vector<std::string_view> parameters;
    std::map<int, CodeBlock> code_blocks;
    std::vector<std::string_view> lines;
    CodeBlock current_code_block;
    int current_code_block_number = 0;
    std::map<uint32_t, std::string> variable_assignments;
    std::unordered_map<std::string_view, std::string> stored_pointers;
    // Tracks the underlying element type (LLVM type) that a pointer alias
    // actually refers to in HLSL-land. When a pointer bitcast reinterprets
    // the element type (e.g. i32* -> float*), this map keeps the ORIGINAL
    // type so that stores/loads can emit asuint()/asfloat() to preserve bits.
    // Key: variable name (e.g. "193"). Value: LLVM scalar type (e.g. "i32").
    std::unordered_map<std::string, std::string> stored_pointer_element_types;
    std::map<std::string, std::pair<std::string, std::string>> variable_aliases;
    std::vector<std::string_view> threads;
    std::map<uint32_t, uint32_t> variable_counter;
    std::set<std::string> phi_variables;
    std::map<uint32_t, uint32_t> variable_declaration;  // variable _codeblocknumber
    std::map<uint32_t, uint32_t> assignment_values;
    std::set<uint32_t> single_use_variables;
    std::vector<std::string> ray_query_declarations;  // RayQuery declarations to hoist to function scope

    std::vector<std::string> ComputePhiAssignments(CodeBlock* code_block, int branch_code_function,
                                                    const std::set<std::string>& bool_forwarding_phis = {}) {
      std::vector<std::string> phi_lines;
      for (const auto& [variable, type, value, predecessor, code_function, is_assign] : code_block->phi_lines) {
        // add phi lines
        if (code_function == branch_code_function && is_assign) {
          auto var_name = std::format("_{}", variable);
          auto assignment_value = std::format("{}", this->ParseByType(value, type));
          std::string optimized = OptimizeString(assignment_value);
          // For boolean forwarding phis (true/false constants that DXC
          // constant-folds), emit as uint to prevent branch elimination.
          if (bool_forwarding_phis.contains(var_name)) {
            if (optimized == "true") optimized = "1u";
            else if (optimized == "false") optimized = "0u";
          }
          auto phi_line = std::format("_{} = {};", variable, optimized);
          phi_lines.push_back(phi_line);
        }
      }
      return phi_lines;
    }

    // Detect boolean forwarding phis: phi i1 [true from A, false from B]
    // DXC constant-folds these when used as branch conditions, eliminating
    // code paths. Returns set of variable names that need uint treatment.
    std::set<std::string> DetectBooleanForwardingPhis(int convergence_block) {
      std::set<std::string> result;
      if (!code_blocks.contains(convergence_block)) return result;
      auto& block = code_blocks[convergence_block];
      
      std::map<std::string, std::vector<std::pair<int, std::string>>> phi_groups;
      for (const auto& [variable, type, value, predecessor, code_function, is_assign] : block.phi_lines) {
        if (type == "i1" && is_assign) {
          phi_groups[std::string(variable)].emplace_back(code_function, std::string(value));
        }
      }
      
      for (auto& [variable, entries] : phi_groups) {
        if (entries.size() != 2) continue;
        bool has_true = false, has_false = false;
        for (auto& [cf, val] : entries) {
          if (val == "true") has_true = true;
          if (val == "false") has_false = true;
        }
        if (has_true && has_false) {
          result.insert(std::format("_{}", variable));
        }
      }
      return result;
    }

    void IncrementVariableCounter(std::string_view variable) {
      uint32_t variable_number;
      FromStringView(variable, variable_number);
      auto& count = variable_counter[variable_number];
      ++count;
    }

    std::string ParseVariable(std::string_view input, const std::string& expected_type = "float") {
      auto result_string = std::string(input.substr(1));
      IncrementVariableCounter(input.substr(1));
      if (!phi_variables.contains(result_string)) {
        if (auto pair = variable_aliases.find(result_string);
            pair != variable_aliases.end()) {
          auto& [alias_type, alias_value] = pair->second;

          // check for function
          static const auto IS_FUNCTION = std::regex{R"(^\w*(\(.*\))$)"};
          const auto [functionlike] = StringViewMatch<1>(alias_value, IS_FUNCTION);
          bool is_function = false;
          if (!functionlike.empty()) {
            is_function = IsWrapped(functionlike);
          }

          static constexpr const auto* SAFE_CHARACTERS = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_.";
          // static constexpr const auto *UNSAFE_CHARACTERS = " *+-/&^|";
          bool needs_wrap = !is_function && alias_value.find_first_not_of(SAFE_CHARACTERS) != std::string_view::npos;
          std::string new_value;
          if (expected_type != alias_type) {
            // When caller explicitly requests int or uint, cast to the requested
            // type to preserve signedness semantics (e.g., udiv needs uint operands).
            // For other cases (float default, bool), preserve the source type annotation
            // so that reinterpret casts like asfloat() see the correct input type.
            if (expected_type == "int" || expected_type == "uint") {
              new_value = CastType(expected_type, alias_value);
            } else {
              new_value = CastType(alias_type, alias_value);
            }
          } else {
            new_value = std::string(alias_value);
          }
          return needs_wrap ? ParseWrapped(new_value) : new_value;
        }
      }
      return std::format("_{}", result_string);
    }

    std::string ParseBool(std::string_view input) {
      if (input.at(0) == '%') {
        return ParseVariable(input, "bool");
      }
      return ParseBoolString(input);
    }

    std::string ParseInt(std::string_view input) {
      if (input.at(0) == '%') {
        return ParseVariable(input, "int");
      }
      return ParseIntString(input);
    }

    std::string ParseInt64(std::string_view input) {
      if (input.at(0) == '%') {
        return ParseVariable(input, "int64_t");
      }
      return ParseIntString(input);
    }

    std::string ParseUint(std::string_view input) {
      if (input.at(0) == '%') {
        return ParseVariable(input, "uint");
      }
      return ParseUintString(input);
    }

    std::string ParseFloat(std::string_view input) {
      if (input.at(0) == '%') {
        return ParseVariable(input);
      }
      return ParseSuffixedString(input, 'f');
    }

    std::string ParseHalf(std::string_view input) {
      if (input.at(0) == '%') {
        return ParseVariable(input);
      }
      return ParseSuffixedString(input, 'h');
    }

    std::string ParseByType(std::string_view input, std::string_view type) {
      if (type == "i1") return ParseBool(input);
      if (type == "i32") return ParseInt(input);
      if (type == "int") return ParseInt(input);
      if (type == "uint") return ParseUint(input);
      if (type == "i16") return ParseInt(input);
      if (type == "i64") return ParseInt64(input);
      if (type == "half") return ParseHalf(input);
      return ParseFloat(input);
    }

    CodeFunction() = default;

    explicit CodeFunction(std::string_view line) {
      // define void @main() {
      static auto regex = std::regex{R"(define (\S+) @([^(]+)\(([^)]*)\) \{)"};
      static auto param_split = std::regex(R"( ((?:[^%][^},]+)|(?:%"[^"]+"))(?:,| ))");

      auto [returnType, name, params] = StringViewMatch<3>(line, regex);

      this->return_type = returnType;
      this->name = name;
      this->parameters = StringViewSplitAll(params, param_split, 1);
    }

    void AddCodeAssign(std::string_view line, PreprocessState& preprocess_state) {
      static auto code_assign_regex = std::regex{R"(^  %(\d+) = ([^;\r\n]+)(?:; ([^\r\n]+))?$)"};

      auto [variable, assignment, comment] = StringViewMatch<3>(line, code_assign_regex);
      if (variable.empty()) {
        throw std::runtime_error("Could not parse code assignment");
      }

      std::string decompiled;
      std::string assignment_type;
      std::string assignment_value;
      uint32_t variable_number;
      FromStringView(variable, variable_number);
      bool use_comment = false;
      bool is_identity = false;
      if (single_use_variables.contains(variable_number)) {
        is_identity = true;
        use_comment = true;
      }

#if DECOMPILER_DXC_DEBUG >= 3
      std::cout << "// " << line << "\n";
#endif

      // std::cout << "parsing: " << this->assignment << std::endl;
      auto instruction = StringViewSplitAll(assignment, ' ').at(0);
      if (instruction == "call") {
        static auto regex = std::regex{R"(call (\S+) ([^(]+)\(([^)]+)\),?.*)"};
        static auto param_regex = std::regex(R"(\s*(\S+) ((?:\d+)|(?:\{[^}]+\})|(?:%\d+)|(?:\S+))(?:(?:, )|(?:\s*$)))");
        auto [type, functionName, functionParamsString] = StringViewMatch<3>(assignment, regex);
        // auto paramMatches = string_view_split_all(functionParamsString, paramRegex, {1, 2});
        if (functionName == "@dx.op.createHandle") {
          //   %dx.types.Handle @dx.op.createHandle(i32 57, i8 2, i32 0, i32 0, i1 false)  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
          auto [opNumber, resource_class, range_id, index, nonUniformIndex] = StringViewSplit<5>(functionParamsString, param_regex, 2);
          // uint32_t index_value = std::stoi(std::string(index));
          uint32_t range_id_value = std::stoi(std::string(range_id));
          uint32_t range_count = 0;
          // auto check_resource = [&](const Resource& resource) {
          //   return (resource.signature_index == index_value) && (range_id_value == range_count++);
          // };
          std::string hint;
          Resource* resource;
          if (resource_class == "0") {
            if (range_id_value >= preprocess_state.srv_resources.size()) {
              throw std::runtime_error(std::format("createHandle: SRV rangeId {} out of bounds (size={})", range_id_value, preprocess_state.srv_resources.size()));
            }
            resource = &preprocess_state.srv_resources[range_id_value];
            hint = "texture";
          } else if (resource_class == "1") {
            if (range_id_value >= preprocess_state.uav_resources.size()) {
              throw std::runtime_error(std::format("createHandle: UAV rangeId {} out of bounds (size={})", range_id_value, preprocess_state.uav_resources.size()));
            }
            resource = &preprocess_state.uav_resources[range_id_value];
            hint = "rwtexture";
          } else if (resource_class == "2") {
            if (range_id_value >= preprocess_state.cbv_resources.size()) {
              throw std::runtime_error(std::format("createHandle: CBV rangeId {} out of bounds (size={})", range_id_value, preprocess_state.cbv_resources.size()));
            }
            resource = &preprocess_state.cbv_resources[range_id_value];
            hint = "cbuffer";
          } else if (resource_class == "3") {
            if (range_id_value >= preprocess_state.sampler_resources.size()) {
              throw std::runtime_error(std::format("createHandle: Sampler rangeId {} out of bounds (size={})", range_id_value, preprocess_state.sampler_resources.size()));
            }
            resource = &preprocess_state.sampler_resources[range_id_value];
            hint = "SamplerState";
          } else {
            throw std::runtime_error(std::format("Unknown resource class '{}' in createHandle", resource_class));
          }
          std::string name = resource->name;
          if (resource->array_size.has_value()) {
            bool is_non_uniform_old = (nonUniformIndex.find("true") != std::string_view::npos);
            auto idx = ParseUint(index);
            name = is_non_uniform_old
                ? std::format("{}[NonUniformResourceIndex({})]", name, idx)
                : std::format("{}[{}]", name, idx);
          }
          preprocess_state.resource_binding_variables[std::string(variable)] = {
              .name = name,
              .range_index = range_id_value,
              .resource_class = std::string(resource_class),
          };
          assignment_type = hint;
          assignment_value = name;
          use_comment = true;

          // decompiled = std::format("// {} _{} = {};", hint, variable, name);

        } else if (functionName == "@dx.op.createHandleFromBinding") {
          // %dx.types.Handle @dx.op.createHandleFromBinding(i32 217, %dx.types.ResBind { i32 4, i32 4, i32 9, i8 0 }, i32 4, i1 false)  ; CreateHandleFromBinding(bind,index,nonUniformIndex)
          auto [opNumber, bind, index, nonUniformIndex] = StringViewSplit<4>(functionParamsString, param_regex, 2);
          std::string bind_start = "0";
          std::string bind_end = "0";
          std::string space = "0";
          std::string resource_class = "0";
          if (bind != "zeroinitializer") {
            auto inner_params = StringViewSplit<4>(bind.substr(1, bind.size() - 2), param_regex, 2);
            bind_start = ParseInt(inner_params[0]);
            bind_end = ParseInt(inner_params[1]);
            space = ParseInt(inner_params[2]);
            resource_class = inner_params[3];
          }

          int space_value;
          int bind_start_value;
          FromStringView(space, space_value);
          FromStringView(bind_start, bind_start_value);
          bool is_non_uniform = (nonUniformIndex.find("true") != std::string_view::npos);
          std::string name;
          uint32_t range_index;
          std::string hint;
          if (resource_class == "0") {
            auto srv = std::ranges::find_if(preprocess_state.srv_resources, [&](SRVResource& resource) {
              return resource.space == space_value && resource.signature_index == bind_start_value;
            });
            range_index = srv - preprocess_state.srv_resources.begin();
            name = srv->name;
            if (srv->array_size.has_value()) {
              auto idx = ParseInt(index);
              name = is_non_uniform
                  ? std::format("{}[NonUniformResourceIndex({})]", name, idx)
                  : std::format("{}[{}]", name, idx);
            }
            hint = "texture";
          } else if (resource_class == "1") {
            auto uav = std::ranges::find_if(preprocess_state.uav_resources, [&](UAVResource& resource) {
              return resource.space == space_value && resource.signature_index == bind_start_value;
            });
            range_index = uav - preprocess_state.uav_resources.begin();
            name = uav->name;
            if (uav->array_size.has_value()) {
              auto idx = ParseInt(index);
              name = is_non_uniform
                  ? std::format("{}[NonUniformResourceIndex({})]", name, idx)
                  : std::format("{}[{}]", name, idx);
            }
            hint = "rwtexture";
          } else if (resource_class == "2") {
            auto cbv = std::ranges::find_if(preprocess_state.cbv_resources, [&](CBVResource& resource) {
              return resource.space == space_value && resource.signature_index == bind_start_value;
            });
            range_index = cbv - preprocess_state.cbv_resources.begin();
            name = cbv->name;
            if (cbv->array_size.has_value()) {
              auto idx = ParseInt(index);
              name = is_non_uniform
                  ? std::format("{}[NonUniformResourceIndex({})]", name, idx)
                  : std::format("{}[{}]", name, idx);
            }
            hint = "cbuffer";
          } else if (resource_class == "3") {
            auto sampler = std::find_if(preprocess_state.sampler_resources.begin(), preprocess_state.sampler_resources.end(), [&](SamplerResource& resource) {
              return resource.space == space_value && resource.signature_index == bind_start_value;
            });
            range_index = sampler - preprocess_state.sampler_resources.begin();
            name = sampler->name;
            if (sampler->array_size.has_value()) {
              auto idx = ParseInt(index);
              name = is_non_uniform
                  ? std::format("{}[NonUniformResourceIndex({})]", name, idx)
                  : std::format("{}[{}]", name, idx);
            }
            hint = "SamplerState";
          } else {
            throw std::runtime_error("Unknown resource type");
          }

          preprocess_state.resource_binding_variables[std::string(variable)] = {
              .name = name,
              .range_index = range_index,
              .resource_class = std::string(resource_class),
          };
          assignment_type = hint;
          assignment_value = name;
          use_comment = true;
          // decompiled = std::format("// {} _{} = {};", hint, variable, name);
        } else if (functionName == "@dx.op.createHandleFromHeap") {
          // %21 = call %dx.types.Handle @dx.op.createHandleFromHeap(i32 218, i32 %14, i1 false, i1 true)  ; CreateHandleFromHeap(index,samplerHeap,nonUniformIndex)
          auto [opNumber, index, samplerHeap, nonUniformIndex] = StringViewSplit<4>(functionParamsString, param_regex, 2);
          bool is_non_uniform = (nonUniformIndex.find("true") != std::string_view::npos);
          std::string heap_index = ParseInt(index);
          preprocess_state.heap_handle_variables[std::string(variable)] = {
              .heap_index = heap_index,
              .is_non_uniform = is_non_uniform,
          };
          assignment_type = "auto";
          assignment_value = std::format("/* heap[{}] */", heap_index);
          use_comment = true;
        } else if (functionName == "@dx.op.annotateHandle") {
          // %4 = call %dx.types.Handle @dx.op.annotateHandle(i32 216, %dx.types.Handle %3, %dx.types.ResourceProperties { i32 13, i32 644 })  ; AnnotateHandle(res,props)  resource: CBuffer
          auto [opNumber, res, props] = StringViewSplit<3>(functionParamsString, param_regex, 2);
          auto ref = std::string{res.substr(1)};

          // Check if this annotates a heap-created handle (SM6.6 bindless)
          auto heap_it = preprocess_state.heap_handle_variables.find(ref);
          if (heap_it != preprocess_state.heap_handle_variables.end()) {
            // Parse ResourceProperties { i32 <kind_bits>, i32 <extra> }
            // kind_bits low 12 bits = ResourceKind, bit 12 = isUAV
            static auto props_regex = std::regex{R"(\{\s*i32\s+(\d+)\s*,\s*i32\s+(\d+)\s*\})"};
            auto [kind_bits_str, extra_str] = StringViewMatch<2>(props, props_regex);
            uint32_t kind_bits = 0;
            if (!kind_bits_str.empty()) FromStringView(kind_bits_str, kind_bits);
            uint32_t resource_kind = kind_bits & 0xFF;
            bool is_uav = (kind_bits >> 11) & 1;

            auto& heap_info = heap_it->second;
            std::string synth_name = std::format("_HeapResource_{}", preprocess_state.heap_srv_counter++);
            std::string resource_class;
            uint32_t range_index;

            if (is_uav) {
              // Create synthetic UAV
              range_index = static_cast<uint32_t>(preprocess_state.uav_resources.size());
              resource_class = "1";
              // We don't add to uav_resources — just track the binding variable
              // The downstream code will need to handle this via the resource_class
            } else {
              // Create synthetic SRV entry for tracking
              range_index = static_cast<uint32_t>(preprocess_state.srv_resources.size());
              resource_class = "0";
            }

            // Determine the HLSL type name for the heap resource
            std::string hint;
            std::string data_type;
            auto rk = static_cast<Resource::ResourceKind>(resource_kind);
            if (rk == Resource::ResourceKind::RawBuffer) {
              hint = is_uav ? "RWByteAddressBuffer" : "ByteAddressBuffer";
              data_type = "";
            } else if (rk == Resource::ResourceKind::RTAccelerationStructure) {
              hint = "RaytracingAccelerationStructure";
              data_type = "RaytracingAccelerationStructure";
            } else if (rk == Resource::ResourceKind::StructuredBuffer) {
              hint = is_uav ? "rwtexture" : "texture";
              data_type = "uint4";  // StructuredBuffer accessed via raw loads
            } else {
              // Texture types — parse element type from second props word
              // Second word: low 8 bits = component type, bits 8+ = component count
              uint32_t extra = 0;
              if (!extra_str.empty()) FromStringView(extra_str, extra);
              uint32_t comp_type = extra & 0xFF;
              uint32_t comp_count = (extra >> 8) & 0xFF;
              if (comp_count == 0) comp_count = 1;  // fallback
              std::string base;
              switch (comp_type) {
                case 1: base = "bool"; break;    // I1
                case 2: base = "int16_t"; break; // I16
                case 3: base = "uint16_t"; break;// U16
                case 4: base = "int"; break;     // I32
                case 5: base = "uint"; break;    // U32
                case 6: base = "int64_t"; break; // I64
                case 7: base = "uint64_t"; break;// U64
                case 8: base = "half"; break;    // F16
                case 9: base = "float"; break;   // F32
                case 10: base = "double"; break; // F64
                default: base = "float"; break;
              }
              data_type = (comp_count == 1) ? base : std::format("{}{}", base, comp_count);
              hint = is_uav ? "rwtexture" : "texture";
            }

            preprocess_state.resource_binding_variables[std::string(variable)] = {
                .name = synth_name,
                .range_index = range_index,
                .resource_class = resource_class,
            };
            preprocess_state.heap_resource_info[std::string(variable)] = {
                .resource_kind = rk,
                .data_type = data_type,
            };

            // Emit actual variable declaration using ResourceDescriptorHeap
            std::string hlsl_type;
            if (rk == Resource::ResourceKind::RawBuffer) {
              hlsl_type = is_uav ? "RWByteAddressBuffer" : "ByteAddressBuffer";
            } else if (rk == Resource::ResourceKind::StructuredBuffer) {
              hlsl_type = is_uav ? "RWByteAddressBuffer" : "ByteAddressBuffer";
            } else if (rk == Resource::ResourceKind::RTAccelerationStructure) {
              hlsl_type = "RaytracingAccelerationStructure";
            } else {
              // Texture types
              std::string rk_str = Resource::ResourceKindString(rk);
              if (is_uav) rk_str = "RW" + rk_str;
              hlsl_type = data_type.empty() ? rk_str : std::format("{}<{}>", rk_str, data_type);
            }
            assignment_type = hlsl_type;
            std::string heap_idx = heap_info.is_non_uniform
                ? std::format("NonUniformResourceIndex({})", heap_info.heap_index)
                : heap_info.heap_index;
            assignment_value = std::format("ResourceDescriptorHeap[{}]", heap_idx);
            // Override the variable name to use the synthetic name
            decompiled = std::format("{} {} = {};", hlsl_type, synth_name, assignment_value);
            assignment_type.clear();
            assignment_value.clear();
          } else {
            preprocess_state.resource_binding_variables[std::string(variable)] = preprocess_state.resource_binding_variables.at(ref);
            // Check if this annotated handle has dynamic cbuffer access
            if (preprocess_state.cbv_handles_with_dynamic_access.contains(std::format("%{}", variable))) {
              auto& binding = preprocess_state.resource_binding_variables[std::string(variable)];
              if (binding.resource_class == "2") {  // CBV
                preprocess_state.cbv_dynamic_access_indices.insert(binding.range_index);
              }
            }
            assignment_type = "auto";
            assignment_value = std::format("_{}", ref);
            use_comment = true;
          }
          // decompiled = std::format("// _{} = _{};", variable, ref);
        } else if (functionName == "@dx.op.loadInput.f32") {
          //   @dx.op.loadInput.f32(i32 4, i32 3, i32 0, i8 0, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
          auto [opNumber, inputSigId, rowIndex, colIndex, gsVertexAxis] = StringViewSplit<5>(functionParamsString, param_regex, 2);
          int input_signature_index;
          FromStringView(inputSigId, input_signature_index);
          // rowIndex offsets within array signatures (e.g., TEXCOORD 1-16)
          int row_index = 0;
          FromStringView(rowIndex, row_index);
          auto sig_index = input_signature_index + row_index;
          if (sig_index >= static_cast<int>(preprocess_state.input_signature.size())) {
            sig_index = input_signature_index;  // fallback
          }
          auto signature = preprocess_state.input_signature[sig_index];
          assignment_type = "float";
          is_identity = true;
          if (signature.packed.MaskString() == "1") {
            // Single-component signature — use the variable directly.
            // The colIndex may not be "x" when the signature occupies a
            // non-x component of a shared register (e.g., SV_RenderTargetArrayIndex
            // at mask y sharing a register with PRIMITIVE_ID at mask x).
            assignment_value = signature.VariableString();
            // decompiled = std::format("float _{} = {};", variable, value);
            // preprocess_state.variable_aliases.emplace(variable, assignment_value);
          } else {
            assignment_value = std::format("{}.{}", signature.VariableString(), ParseIndex(colIndex));
            // decompiled = std::format("float _{} = {};", variable, value);
            // preprocess_state.variable_aliases.emplace(variable, assignment_value);
          }
        } else if (functionName == "@dx.op.loadInput.f16") {
          //   @dx.op.loadInput.f16(i32 4, i32 5, i32 0, i8 0, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
          auto [opNumber, inputSigId, rowIndex, colIndex, gsVertexAxis] = StringViewSplit<5>(functionParamsString, param_regex, 2);
          int input_signature_index;
          FromStringView(inputSigId, input_signature_index);
          int row_index = 0;
          FromStringView(rowIndex, row_index);
          auto sig_index = input_signature_index + row_index;
          if (sig_index >= static_cast<int>(preprocess_state.input_signature.size())) {
            sig_index = input_signature_index;
          }
          auto signature = preprocess_state.input_signature[sig_index];
          assignment_type = "half";
          is_identity = true;
          if (signature.packed.MaskString() == "1") {
            assignment_value = signature.VariableString();
          } else {
            assignment_value = std::format("{}.{}", signature.VariableString(), ParseIndex(colIndex));
          }
        } else if (functionName == "@dx.op.loadInput.i32") {
          //   @dx.op.loadInput.i32(i32 4, i32 2, i32 0, i8 0, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
          auto [opNumber, inputSigId, rowIndex, colIndex, gsVertexAxis] = StringViewSplit<5>(functionParamsString, param_regex, 2);
          int input_signature_index;
          FromStringView(inputSigId, input_signature_index);
          int row_index = 0;
          FromStringView(rowIndex, row_index);
          auto sig_index = input_signature_index + row_index;
          if (sig_index >= static_cast<int>(preprocess_state.input_signature.size())) {
            sig_index = input_signature_index;
          }
          auto signature = preprocess_state.input_signature[sig_index];
          assignment_type = "int";
          is_identity = true;
          if (signature.packed.MaskString() == "1") {
            assignment_value = signature.VariableString();
            // decompiled = std::format("uint _{} = {};", variable, value);
            // preprocess_state.variable_aliases.emplace(variable, value);
          } else {
            assignment_value = std::format("{}.{}", signature.VariableString(), ParseIndex(colIndex));
            // decompiled = std::format("uint _{} = {};", variable, value);
            // preprocess_state.variable_aliases.emplace(variable, value);
          }
        } else if (functionName == "@dx.op.cbufferLoadLegacy.f32") {
          auto [opNumber, handle, regIndex] = StringViewSplit<3>(functionParamsString, param_regex, 2);
          auto ref = std::string{handle.substr(1)};
          auto [binding_name, range_index, resource_class] = preprocess_state.resource_binding_variables.at(ref);
          assert(resource_class == "2");
          auto& cbv_resource = preprocess_state.cbv_resources[range_index];

          if (regIndex.starts_with("%")) {
            // Dynamic cbuffer offset — emit as array-style access via raw uint4 view
            preprocess_state.cbv_dynamic_access_indices.insert(range_index);
            assignment_type = "float4";
            assignment_value = std::format("asfloat({}_raw[{}])", cbv_resource.name, ParseVariable(regIndex));
            is_identity = false;
            use_comment = false;
          } else {
            uint32_t cbv_variable_index;
            FromStringView(regIndex, cbv_variable_index);
            // auto name = preprocess_state.ResourceVariableNameAtIndex(cbv_resource, cbv_variable_index);

            // decompiled = std::format("// float4 _{} = {}[{}u];", variable, cbv_resource.name, cbv_variable_index);
            preprocess_state.cbv_binding_variables[variable] = {&cbv_resource, cbv_variable_index, binding_name};
          }

        } else if (functionName == "@dx.op.cbufferLoadLegacy.i32") {
          // %18 = call %dx.types.CBufRet.i32 @dx.op.cbufferLoadLegacy.i32(i32 59, %dx.types.Handle %4, i32 40)  ; CBufferLoadLegacy(handle,regIndex)
          auto [opNumber, handle, regIndex] = StringViewSplit<3>(functionParamsString, param_regex, 2);
          auto ref = std::string{handle.substr(1)};
          auto [binding_name, range_index, resource_class] = preprocess_state.resource_binding_variables.at(ref);
          assert(resource_class == "2");
          auto& cbv_resource = preprocess_state.cbv_resources[range_index];

          if (regIndex.starts_with("%")) {
            // Dynamic cbuffer offset — emit as array-style access via raw float4 view
            preprocess_state.cbv_dynamic_access_indices.insert(range_index);
            assignment_type = "int4";
            assignment_value = std::format("asint({}_raw[{}])", cbv_resource.name, ParseVariable(regIndex));
            is_identity = false;
            use_comment = false;
          } else {
            uint32_t cbv_variable_index;
            FromStringView(regIndex, cbv_variable_index);
            // auto name = preprocess_state.ResourceVariableNameAtIndex(cbv_resource, cbv_variable_index);

            // decompiled = std::format("// int4 _{} = {}[{}u];", variable, cbv_resource.name, cbv_variable_index);
            preprocess_state.cbv_binding_variables[variable] = {&cbv_resource, cbv_variable_index, binding_name};
          }
        } else if (functionName == "@dx.op.cbufferLoadLegacy.f16") {
          auto [opNumber, handle, regIndex] = StringViewSplit<3>(functionParamsString, param_regex, 2);
          auto ref = std::string{handle.substr(1)};
          auto [binding_name, range_index, resource_class] = preprocess_state.resource_binding_variables.at(ref);
          assert(resource_class == "2");
          auto& cbv_resource = preprocess_state.cbv_resources[range_index];

          if (regIndex.starts_with("%")) {
            throw std::runtime_error("Unsupported dynamic @dx.op.cbufferLoadLegacy.f16");
          } else {
            uint32_t cbv_variable_index;
            FromStringView(regIndex, cbv_variable_index);
            preprocess_state.cbv_binding_variables[variable] = {&cbv_resource, cbv_variable_index, binding_name};
          }
        } else if (functionName == "@dx.op.unary.f32") {
          auto [opNumber, value] = StringViewSplit<2>(functionParamsString, param_regex, 2);
          if (auto pair = UNARY_FLOAT_OPS.find(std::string(opNumber));
              pair != UNARY_FLOAT_OPS.end()) {
            assignment_type = ParseType(type);
            assignment_value = std::format("{}{}", pair->second, ParseWrapped(ParseFloat(value)));
            // decompiled = std::format("{} _{} = {}({});", ParseType(type), variable, pair->second, ParseFloat(value));
          } else {
            throw std::runtime_error("Unknown @dx.op.unary.f32");
          }
        } else if (functionName == "@dx.op.unary.f16") {
          auto [opNumber, value] = StringViewSplit<2>(functionParamsString, param_regex, 2);
          if (auto pair = UNARY_FLOAT_OPS.find(std::string(opNumber));
              pair != UNARY_FLOAT_OPS.end()) {
            assignment_type = ParseType(type);
            assignment_value = std::format("{}{}", pair->second, ParseWrapped(ParseHalf(value)));
            // decompiled = std::format("{} _{} = {}({});", ParseType(type), variable, pair->second, ParseFloat(value));
          } else {
            throw std::runtime_error("Unknown @dx.op.unary.f32");
          }
        } else if (functionName == "@dx.op.unary.i32") {
          auto [opNumber, value] = StringViewSplit<2>(functionParamsString, param_regex, 2);
          if (auto pair = UNARY_INT32_OPS.find(std::string(opNumber));
              pair != UNARY_INT32_OPS.end()) {
            assignment_type = ParseType(type);
            assignment_value = std::format("{}{}", pair->second, ParseWrapped(ParseFloat(value)));
            // decompiled = std::format("{} _{} = {}({});", ParseType(type), variable, pair->second, ParseFloat(value));
          } else {
            throw std::runtime_error("Unknown @dx.op.unary.i32");
          }
        } else if (functionName == "@dx.op.unaryBits.i32") {
          auto [opNumber, value] = StringViewSplit<2>(functionParamsString, param_regex, 2);
          if (auto pair = UNARY_BITS_OPS.find(std::string(opNumber));
              pair != UNARY_BITS_OPS.end()) {
            if (opNumber == "33" || opNumber == "34") {
              assignment_type = "uint";
            } else {
              assignment_type = ParseType(type);
            }
            // Opcode 33 = FirstbitHi (unsigned input) — must cast to uint
            // Opcode 34 = FirstbitSHi (signed input) — must cast to int
            // Other opcodes (countbits, firstbitlow) use generic parse
            std::string parsed_arg;
            if (opNumber == "33") {
              parsed_arg = ParseUint(value);
            } else if (opNumber == "34") {
              parsed_arg = ParseInt(value);
            } else {
              parsed_arg = ParseFloat(value);
            }
            assignment_value = std::format("{}{}", pair->second, ParseWrapped(parsed_arg));
          } else {
            throw std::runtime_error("Unknown @dx.op.unaryBits.i32");
          }
        } else if (functionName == "@dx.op.binary.f32") {
          auto [opNumber, a, b] = StringViewSplit<3>(functionParamsString, param_regex, 2);
          if (auto pair = BINARY_FLOAT_OPS.find(std::string(opNumber));
              pair != BINARY_FLOAT_OPS.end()) {
            assignment_type = ParseType(type);
            assignment_value = std::format("{}({}, {})", pair->second, ParseFloat(a), ParseFloat(b));
            // decompiled = std::format("{} _{} = {}({}, {});", ParseType(type), variable, pair->second, ParseFloat(a), ParseFloat(b));
          } else {
            throw std::runtime_error("Unknown @dx.op.binary.f32");
          }
        } else if (functionName == "@dx.op.binary.f16") {
          // call half @dx.op.binary.f16(i32 35, half %696, half 0xH0000)
          auto [opNumber, a, b] = StringViewSplit<3>(functionParamsString, param_regex, 2);
          if (auto pair = BINARY_FLOAT_OPS.find(std::string(opNumber));
              pair != BINARY_FLOAT_OPS.end()) {
            assignment_type = ParseType(type);
            assignment_value = std::format("{}({}, {})", pair->second, ParseHalf(a), ParseHalf(b));
            // decompiled = std::format("{} _{} = {}({}, {});", ParseType(type), variable, pair->second, ParseFloat(a), ParseFloat(b));
          } else {
            throw std::runtime_error("Unknown @dx.op.binary.f16");
          }
        } else if (functionName == "@dx.op.binary.i32") {
          auto [opNumber, a, b] = StringViewSplit<3>(functionParamsString, param_regex, 2);
          if (auto pair = BINARY_INT32_OPS.find(std::string(opNumber));
              pair != BINARY_INT32_OPS.end()) {
            assignment_type = ParseType(type);
            if (UNSIGNED_BINARY_INT32_OPS.contains(std::string(opNumber))) {
              // UMin/UMax require unsigned comparison semantics
              auto a_str = std::string(ParseInt(a));
              auto b_str = std::string(ParseInt(b));
              // Wrap in (uint) cast if not already uint
              auto cast_uint = [](const std::string& s) -> std::string {
                if (s.starts_with("(uint)") || (s.size() > 0 && s.back() == 'u')) return s;
                return std::format("(uint)({})", s);
              };
              assignment_value = std::format("(int){}({}, {})", pair->second, cast_uint(a_str), cast_uint(b_str));
            } else {
              // IMax/IMin require signed comparison semantics
              auto a_str = std::string(ParseInt(a));
              auto b_str = std::string(ParseInt(b));
              auto cast_int = [](const std::string& s) -> std::string {
                if (s.starts_with("(int)")) return s;
                return std::format("(int)({})", s);
              };
              assignment_value = std::format("{}({}, {})", pair->second, cast_int(a_str), cast_int(b_str));
            }
          } else {
            throw std::runtime_error("Unknown @dx.op.binary.i32");
          }
        } else if (functionName == "@dx.op.binary.i16") {
          // call i16 @dx.op.binary.i16(i32 38, i16 %365, i16 4)  ; IMin(a,b)
          auto [opNumber, a, b] = StringViewSplit<3>(functionParamsString, param_regex, 2);
          if (auto pair = BINARY_INT32_OPS.find(std::string(opNumber));
              pair != BINARY_INT32_OPS.end()) {
            assignment_type = "int16_t";
            if (UNSIGNED_BINARY_INT32_OPS.contains(std::string(opNumber))) {
              // UMin/UMax require unsigned comparison semantics
              auto a_str = std::string(ParseInt(a));
              auto b_str = std::string(ParseInt(b));
              auto cast_uint16 = [](const std::string& s) -> std::string {
                if (s.starts_with("(uint16_t)")) return s;
                return std::format("(uint16_t)({})", s);
              };
              assignment_value = std::format("(int16_t){}({}, {})", pair->second, cast_uint16(a_str), cast_uint16(b_str));
            } else {
              // IMax/IMin require signed comparison semantics
              auto a_str = std::string(ParseInt(a));
              auto b_str = std::string(ParseInt(b));
              auto cast_int16 = [](const std::string& s) -> std::string {
                if (s.starts_with("(int16_t)")) return s;
                return std::format("(int16_t)({})", s);
              };
              assignment_value = std::format("{}({}, {})", pair->second, cast_int16(a_str), cast_int16(b_str));
            }
          } else {
            throw std::runtime_error("Unknown @dx.op.binary.i16");
          }
        } else if (functionName == "@dx.op.textureLoad.f32" || functionName == "@dx.op.textureLoad.i32" || functionName == "@dx.op.textureLoad.f16" || functionName == "@dx.op.textureLoad.i16") {
          // %dx.types.ResRet.f32 @dx.op.textureLoad.f32(i32 66, %dx.types.Handle %40, i32 0, i32 %38, i32 %39, i32 undef, i32 undef, i32 undef, i32 undef)  ; TextureLoad(srv,mipLevelOrSampleCount,coord0,coord1,coord2,offset0,offset1,offset2)
          // %dx.types.ResRet.f32 @dx.op.textureLoad.f32(i32 66, %dx.types.Handle %442, i32 undef, i32 %440, i32 %441, i32 undef, i32 undef, i32 undef, i32 undef)  ; TextureLoad(srv,mipLevelOrSampleCount,coord0,coord1,coord2,offset0,offset1,offset2)
          auto [opNumber, srv, mipLevelOrSampleCount, coord0, coord1, coord2, offset0, offset1, offset2] = StringViewSplit<9>(functionParamsString, param_regex, 2);
          auto ref_resource = std::string{srv.substr(1)};
          const bool has_coord_y = coord1 != "undef";
          const bool has_coord_z = coord2 != "undef";
          const bool has_offset_y = offset1 != "undef";
          const bool has_offset_z = offset2 != "undef";
          const bool has_mip_level = mipLevelOrSampleCount != "undef";
          std::string coords;
          auto [binding_name, range_index, resource_class] = preprocess_state.resource_binding_variables.at(ref_resource);
          Resource::ResourceKind shape = preprocess_state.GetResourceShape(ref_resource);
          if (resource_class == "0") {
            assignment_type = preprocess_state.GetResourceDataType(ref_resource);
          } else if (resource_class == "1") {
            shape = preprocess_state.uav_resources[range_index].shape;
            assignment_type = preprocess_state.uav_resources[range_index].data_type;
          } else {
            throw std::runtime_error(std::format("Unknown {} resource", functionName));
          }

          switch (shape) {
            case Resource::ResourceKind::Texture1D:
              coords = std::format("int2({}, {})", ParseInt(coord0), ParseInt(mipLevelOrSampleCount));
              break;
            case Resource::ResourceKind::Texture2DMS:
              coords = std::format("int2({}, {})", ParseInt(coord0), ParseInt(coord1));
              break;
            case Resource::ResourceKind::Texture1DArray:
            case Resource::ResourceKind::Texture2D:
              if (has_mip_level) {
                coords = std::format("int3({}, {}, {})", ParseInt(coord0), ParseInt(coord1), ParseInt(mipLevelOrSampleCount));
              } else {
                coords = std::format("int2({}, {})", ParseInt(coord0), ParseInt(coord1));
              }
              break;
            case Resource::ResourceKind::Texture2DMSArray:
              coords = std::format("int3({}, {}, {})", ParseInt(coord0), ParseInt(coord1), ParseInt(coord2));
              break;
            case Resource::ResourceKind::Texture2DArray:
            case Resource::ResourceKind::Texture3D:
              if (has_mip_level) {
                coords = std::format("int4({}, {}, {}, {})", ParseInt(coord0), ParseInt(coord1), ParseInt(coord2), ParseInt(mipLevelOrSampleCount));
              } else {
                coords = std::format("int3({}, {}, {})", ParseInt(coord0), ParseInt(coord1), ParseInt(coord2));
              }
              break;
            default:
              throw std::runtime_error("Unknown shape");
          }

          std::string offset;
          if (has_offset_z) {
            offset = std::format("int3({}, {}, {})", ParseInt(offset0), ParseInt(offset1), ParseInt(offset2));
          } else if (has_offset_y) {
            offset = std::format("int2({}, {})", ParseInt(offset0), ParseInt(offset1));
          } else {
            offset = std::format("{}", ParseInt(offset0));
          }
          if (offset == "undef" || offset == "0" || offset == "int2(0, 0)" || offset == "int3(0, 0, 0)") {
            assignment_value = std::format("{}.Load({})", binding_name, coords);
            // decompiled = std::format("{} _{} = {}.Load({});", srv_resource.data_type, variable, binding_name, coords);
          } else {
            assignment_value = std::format("{}.Load({}, {})", binding_name, coords, offset);
            // decompiled = std::format("{} _{} = {}.Load({}, {});", srv_resource.data_type, variable, binding_name, coords, offset);
          }
        } else if (functionName == "@dx.op.sample.f32" || functionName == "@dx.op.sample.f16") {
          //  call %dx.types.ResRet.f32 @dx.op.sample.f32(i32 60, %dx.types.Handle %1, %dx.types.Handle %2, float %4, float %5, float undef, float undef, i32 0, i32 0, i32 undef, float undef)  ; Sample(srv,sampler,coord0,coord1,coord2,coord3,offset0,offset1,offset2,clamp)
          auto [opNumber, srv, sampler, coord0, coord1, coord2, coord3, offset0, offset1, offset2, clamp] = StringViewSplit<11>(functionParamsString, param_regex, 2);
          auto ref_resource = std::string{srv.substr(1)};
          auto ref_sampler = std::string{sampler.substr(1)};

          const bool has_coord_z = coord2 != "undef";
          const bool has_coord_w = coord3 != "undef";
          const bool has_offset_y = offset1 != "undef";
          const bool has_offset_z = offset2 != "undef";
          const bool has_clamp = clamp != "undef";
          std::string coords;
          if (has_coord_w) {
            coords = std::format("float4({}, {}, {}, {})", ParseFloat(coord0), ParseFloat(coord1), ParseFloat(coord2), ParseFloat(coord3));
          } else if (has_coord_z) {
            coords = std::format("float3({}, {}, {})", ParseFloat(coord0), ParseFloat(coord1), ParseFloat(coord2));
          } else {
            coords = std::format("float2({}, {})", ParseFloat(coord0), ParseFloat(coord1));
          }
          std::string offset;
          if (has_offset_z) {
            offset = std::format("int3({}, {}, {})", ParseInt(offset0), ParseInt(offset1), ParseInt(offset2));
          } else if (has_coord_z) {
            offset = std::format("int3({}, {}, 0u)", ParseInt(offset0), ParseInt(offset1));
          } else {
            offset = std::format("{}", ParseInt(offset0));
          }
          if (has_clamp) {
            throw std::runtime_error("Unknown clamp");
          }

          auto [srv_name, srv_range_index, srv_resource_class] = preprocess_state.resource_binding_variables.at(ref_resource);
          assert(srv_resource_class == "0");
          auto [sampler_name, sampler_range_index, sampler_resource_class] = preprocess_state.resource_binding_variables.at(ref_sampler);
          auto sampler_resource = preprocess_state.sampler_resources[sampler_range_index];
          assignment_type = preprocess_state.GetResourceDataType(ref_resource);
          if (offset == "0" || offset == "int2(0, 0)" || offset == "int3(0, 0, 0)") {
            assignment_value = std::format("{}.Sample({}, {})", srv_name, sampler_name, coords);
            // decompiled = std::format("{} _{} = {}.Sample({}, {});", srv_resource.data_type, variable, srv_name, sampler_name, coords);
          } else {
            assignment_value = std::format("{}.Sample({}, {}, {})", srv_name, sampler_name, coords, offset);
            // decompiled = std::format("{} _{} = {}.Sample({}, {}, {});", srv_resource.data_type, variable, srv_name, sampler_name, coords, offset);
          }
        } else if (functionName == "@dx.op.sampleLevel.f32" || functionName == "@dx.op.sampleLevel.f16") {
          // %427 = call %dx.types.ResRet.f32 @dx.op.sampleLevel.f32(i32 62, %dx.types.Handle %3, %dx.types.Handle %7, float %384, float %385, float %426, float undef, i32 undef, i32 undef, i32 undef, float 0.000000e+00)  ; SampleLevel(srv,sampler,coord0,coord1,coord2,coord3,offset0,offset1,offset2,LOD)
          // %427 = i32 62, %dx.types.Handle %3, %dx.types.Handle %7,
          // float %384, float %385, float %426, float undef,
          // i32 undef, i32 undef, i32 undef, float 0.000000e+00)  ; SampleLevel(srv,sampler,coord0,coord1,coord2,coord3,offset0,offset1,offset2,LOD)
          auto [opNumber, srv, sampler, coord0, coord1, coord2, coord3, offset0, offset1, offset2, LOD] = StringViewSplit<11>(functionParamsString, param_regex, 2);
          auto ref_resource = std::string{srv.substr(1)};
          auto ref_sampler = std::string{sampler.substr(1)};

          const bool has_coord_z = coord2 != "undef";
          const bool has_coord_w = coord3 != "undef";
          const bool has_offset_x = offset0 != "undef";
          const bool has_offset_y = offset1 != "undef";
          const bool has_offset_z = offset2 != "undef";
          std::string coords;
          if (has_coord_w) {
            coords = std::format("float4({}, {}, {}, {})", ParseFloat(coord0), ParseFloat(coord1), ParseFloat(coord2), ParseFloat(coord3));
          } else if (has_coord_z) {
            coords = std::format("float3({}, {}, {})", ParseFloat(coord0), ParseFloat(coord1), ParseFloat(coord2));
          } else {
            coords = std::format("float2({}, {})", ParseFloat(coord0), ParseFloat(coord1));
          }
          std::string offset;
          if (has_offset_z) {
            offset = std::format("int3({}, {}, {})", ParseInt(offset0), ParseInt(offset1), ParseInt(offset2));
          } else if (has_offset_y) {
            offset = std::format("int2({}, {})", ParseInt(offset0), ParseInt(offset1));
          } else if (has_offset_x) {
            offset = std::format("{}", ParseInt(offset0));
          }

          auto [srv_name, srv_range_index, srv_resource_class] = preprocess_state.resource_binding_variables.at(ref_resource);
          auto [sampler_name, sampler_range_index, sampler_resource_class] = preprocess_state.resource_binding_variables.at(ref_sampler);
          auto sampler_resource = preprocess_state.sampler_resources[sampler_range_index];
          assignment_type = preprocess_state.GetResourceDataType(ref_resource);
          if (offset == "" || offset == "0" || offset == "int2(0, 0)" || offset == "int3(0, 0, 0)") {
            assignment_value = std::format("{}.SampleLevel({}, {}, {})", srv_name,
                                           sampler_name, coords, ParseFloat(LOD));
            // decompiled = std::format("{} _{} = {}.SampleLevel({}, {}, {});", srv_resource.data_type, variable, srv_name, sampler_name, coords, ParseFloat(LOD));
          } else {
            assignment_value = std::format("{}.SampleLevel({}, {}, {}, {})", srv_name,
                                           sampler_name, coords, ParseFloat(LOD), offset);
            // decompiled = std::format("{} _{} = {}.SampleLevel({}, {}, {}, {});", srv_resource.data_type, variable, srv_name, sampler_name, coords, ParseFloat(LOD), offset);
          }
        } else if (functionName == "@dx.op.calculateLOD.f32") {
          // call float @dx.op.calculateLOD.f32(i32 81, %dx.types.Handle %srv, %dx.types.Handle %sampler, float %coord0, float %coord1, float %coord2, i1 true)  ; CalculateLOD(handle,sampler,coord0,coord1,coord2,clamped)
          auto [opNumber, srv, sampler, coord0, coord1, coord2, clamped] = StringViewSplit<7>(functionParamsString, param_regex, 2);
          auto ref_resource = std::string{srv.substr(1)};
          auto ref_sampler = std::string{sampler.substr(1)};
          const bool has_coord_y = coord1 != "undef";
          const bool has_coord_z = coord2 != "undef";

          std::string coords;
          if (has_coord_z) {
            coords = std::format("float3({}, {}, {})", ParseFloat(coord0), ParseFloat(coord1), ParseFloat(coord2));
          } else if (has_coord_y) {
            coords = std::format("float2({}, {})", ParseFloat(coord0), ParseFloat(coord1));
          } else {
            coords = ParseFloat(coord0);
          }

          auto [srv_name, srv_range_index, srv_resource_class] = preprocess_state.resource_binding_variables.at(ref_resource);
          auto [sampler_name, sampler_range_index, sampler_resource_class] = preprocess_state.resource_binding_variables.at(ref_sampler);
          assignment_type = "float";
          assignment_value = std::format(
              "{}.{}({}, {})",
              srv_name,
              clamped == "true" ? "CalculateLevelOfDetail" : "CalculateLevelOfDetailUnclamped",
              sampler_name,
              coords);
        } else if (functionName == "@dx.op.dot2.f32") {
          auto [opNumber, ax, ay, bx, by] = StringViewSplit<5>(functionParamsString, param_regex, 2);
          assignment_type = "float";
          assignment_value = std::format("dot(float2({}, {}), float2({}, {}))",
                                         ParseFloat(ax), ParseFloat(ay),
                                         ParseFloat(bx), ParseFloat(by));
          // decompiled = std::format("float _{} = dot(float2({}, {}), float2({}, {}));", variable, ParseFloat(ax), ParseFloat(ay), ParseFloat(bx), ParseFloat(by));
        } else if (functionName == "@dx.op.dot3.f32") {
          auto [opNumber, ax, ay, az, bx, by, bz] = StringViewSplit<7>(functionParamsString, param_regex, 2);
          assignment_type = "float";
          assignment_value = std::format("dot(float3({}, {}, {}), float3({}, {}, {}))",
                                         ParseFloat(ax), ParseFloat(ay), ParseFloat(az),
                                         ParseFloat(bx), ParseFloat(by), ParseFloat(bz));
          // decompiled = std::format("float _{} = dot(float3({}, {}, {}), float3({}, {}, {}));", variable, ParseFloat(ax), ParseFloat(ay), ParseFloat(az), ParseFloat(bx), ParseFloat(by), ParseFloat(bz));
        } else if (functionName == "@dx.op.dot4.f32") {
          // call float @dx.op.dot4.f32(i32 56, float %73, float %74, float %75, float %76, float %1366, float %1367, float %1368, float 1.000000e+00)  ; Dot4(ax,ay,az,aw,bx,by,bz,bw)
          auto [opNumber, ax, ay, az, aw, bx, by, bz, bw] = StringViewSplit<9>(functionParamsString, param_regex, 2);
          assignment_type = "float";
          assignment_value = std::format("dot(float4({}, {}, {}, {}), float4({}, {}, {}, {}))",
                                         ParseFloat(ax), ParseFloat(ay), ParseFloat(az), ParseFloat(aw),
                                         ParseFloat(bx), ParseFloat(by), ParseFloat(bz), ParseFloat(bw));
        } else if (functionName == "@dx.op.dot2.f16") {
          auto [opNumber, ax, ay, bx, by] = StringViewSplit<5>(functionParamsString, param_regex, 2);
          assignment_type = "half";
          assignment_value = std::format("dot(half2({}, {}), half2({}, {}))",
                                         ParseHalf(ax), ParseHalf(ay),
                                         ParseHalf(bx), ParseHalf(by));
        } else if (functionName == "@dx.op.dot3.f16") {
          // call half @dx.op.dot3.f16(i32 55, half %704, half %705, half %706, half 0xH34C9, half 0xH38B2, half 0xH2F4C)
          auto [opNumber, ax, ay, az, bx, by, bz] = StringViewSplit<7>(functionParamsString, param_regex, 2);
          assignment_type = "half";
          assignment_value = std::format("dot(half3({}, {}, {}), half3({}, {}, {}))",
                                         ParseHalf(ax), ParseHalf(ay), ParseHalf(az),
                                         ParseHalf(bx), ParseHalf(by), ParseHalf(bz));
        } else if (functionName == "@dx.op.dot4.f16") {
          auto [opNumber, ax, ay, az, aw, bx, by, bz, bw] = StringViewSplit<9>(functionParamsString, param_regex, 2);
          assignment_type = "half";
          assignment_value = std::format("dot(half4({}, {}, {}, {}), half4({}, {}, {}, {}))",
                                         ParseHalf(ax), ParseHalf(ay), ParseHalf(az), ParseHalf(aw),
                                         ParseHalf(bx), ParseHalf(by), ParseHalf(bz), ParseHalf(bw));
        } else if (functionName == "@dx.op.tertiary.f32") {
          // call float @dx.op.tertiary.f32(i32 46, float 0xBFC4A8C160000000, float %210, float %217)  ; FMad(a,b,c)
          auto [opNumber, a, b, c] = StringViewSplit<4>(functionParamsString, param_regex, 2);
          assignment_type = "float";
          assignment_value = std::format("mad({}, {}, {})",
                                         ParseFloat(a), ParseFloat(b), ParseFloat(c));
        } else if (functionName == "@dx.op.tertiary.f16") {
          auto [opNumber, a, b, c] = StringViewSplit<4>(functionParamsString, param_regex, 2);
          assignment_type = "half";
          assignment_value = std::format("mad({}, {}, {})",
                                         ParseHalf(a), ParseHalf(b), ParseHalf(c));
        } else if (functionName == "@dx.op.tertiary.i32") {
          // call i32 @dx.op.tertiary.i32(i32 48, i32 %x, i32 %y, i32 %z)  ; IMad(a,b,c)
          auto [opNumber, a, b, c] = StringViewSplit<4>(functionParamsString, param_regex, 2);
          assignment_type = "int";
          assignment_value = std::format("mad({}, {}, {})",
                                         ParseInt(a), ParseInt(b), ParseInt(c));
        } else if (functionName == "@dx.op.rawBufferLoad.f32" || functionName == "@dx.op.rawBufferLoad.f16") {
          // call %dx.types.ResRet.f32 @dx.op.rawBufferLoad.f32(i32 139, %dx.types.Handle %21, i32 %20, i32 0, i8 15, i32 4)  ; RawBufferLoad(srv,index,elementOffset,mask,alignment)
          // call %dx.types.ResRet.f32 @dx.op.rawBufferLoad.f32(i32 139, %dx.types.Handle %21, i32 %20, i32 32, i8 1, i32 4)  ; RawBufferLoad(srv,index,elementOffset,mask,alignment)

          auto [opNumber, srv, index, elementOffset, mask, alignment] = StringViewSplit<6>(functionParamsString, param_regex, 2);
          auto ref = std::string{srv.substr(1)};
          auto binding = preprocess_state.resource_binding_variables.at(ref);
          auto [res_name, range_index, resource_class] = binding;
          bool is_raw_buffer = preprocess_state.GetResourceShape(ref) == Resource::ResourceKind::RawBuffer;

          if (is_raw_buffer) {
            assert(elementOffset == "undef");
            int mask_val;
            FromStringView(mask, mask_val);
            int component_count = 0;
            if (mask_val & 1) component_count++;
            if (mask_val & 2) component_count++;
            if (mask_val & 4) component_count++;
            if (mask_val & 8) component_count++;
            std::string load_func = (component_count == 1) ? "Load" :
                                    std::format("Load{}", component_count);
            assignment_type = (component_count == 1) ? "float" :
                              std::format("float{}", component_count);
            assignment_value = std::format("asfloat({}.{}({}))",
                                           res_name, load_func, ParseInt(index));
            // Store in binding_load_variables with component_count so
            // extractvalue knows whether to append .x/.y/.z/.w
            std::string count_str = std::to_string(component_count);
            if (resource_class == "0") {
              preprocess_state.srv_binding_load_variables[variable] = {
                  nullptr, assignment_value, count_str, "raw", ""};
            } else {
              preprocess_state.uav_binding_load_variables[variable] = {
                  nullptr, assignment_value, count_str, "raw", ""};
            }
            use_comment = true;
          } else if (!preprocess_state.IsHeapResource(ref) && resource_class == "0") {
            preprocess_state.srv_binding_load_variables[variable] = {
                &preprocess_state.srv_resources[range_index],
                ParseInt(index),
                ParseInt(elementOffset),
                ParseInt(alignment),
                res_name,
            };
          } else if (!preprocess_state.IsHeapResource(ref) && resource_class == "1") {
            preprocess_state.uav_binding_load_variables[variable] = {
                &preprocess_state.uav_resources[range_index],
                ParseInt(index),
                ParseInt(elementOffset),
                ParseInt(alignment),
                res_name,
            };
          } else if (preprocess_state.IsHeapResource(ref)) {
            // Heap-created structured buffer — store with nullptr resource
            if (resource_class == "0") {
              preprocess_state.srv_binding_load_variables[variable] = {
                  nullptr, ParseInt(index), ParseInt(elementOffset), ParseInt(alignment), res_name};
            } else {
              preprocess_state.uav_binding_load_variables[variable] = {
                  nullptr, ParseInt(index), ParseInt(elementOffset), ParseInt(alignment), res_name};
            }
          }
        } else if (functionName == "@dx.op.rawBufferLoad.i32" || functionName == "@dx.op.rawBufferLoad.i16") {
          auto [opNumber, srv, index, elementOffset, mask, alignment] = StringViewSplit<6>(functionParamsString, param_regex, 2);
          auto ref = std::string{srv.substr(1)};
          auto binding = preprocess_state.resource_binding_variables.at(ref);
          auto [res_name, res_range_index, resource_class] = binding;
          bool is_raw_buffer = preprocess_state.GetResourceShape(ref) == Resource::ResourceKind::RawBuffer;

          if (is_raw_buffer) {
            assert(elementOffset == "undef");
            int mask_val;
            FromStringView(mask, mask_val);
            int component_count = 0;
            if (mask_val & 1) component_count++;
            if (mask_val & 2) component_count++;
            if (mask_val & 4) component_count++;
            if (mask_val & 8) component_count++;
            std::string load_func = (component_count == 1) ? "Load" :
                                    std::format("Load{}", component_count);
            assignment_type = (component_count == 1) ? "int" :
                              std::format("int{}", component_count);
            assignment_value = std::format("asint({}.{}({}))",
                                           res_name, load_func, ParseInt(index));
            std::string count_str = std::to_string(component_count);
            if (resource_class == "0") {
              preprocess_state.srv_binding_load_variables[variable] = {
                  nullptr, assignment_value, count_str, "raw", ""};
            } else {
              preprocess_state.uav_binding_load_variables[variable] = {
                  nullptr, assignment_value, count_str, "raw", ""};
            }
            use_comment = true;
          } else if (!preprocess_state.IsHeapResource(ref) && resource_class == "0") {
            preprocess_state.srv_binding_load_variables[variable] = {
                &preprocess_state.srv_resources[res_range_index],
                ParseInt(index),
                ParseInt(elementOffset),
                ParseInt(alignment),
                res_name,
            };
          } else if (!preprocess_state.IsHeapResource(ref) && resource_class == "1") {
            preprocess_state.uav_binding_load_variables[variable] = {
                &preprocess_state.uav_resources[res_range_index],
                ParseInt(index),
                ParseInt(elementOffset),
                ParseInt(alignment),
                res_name,
            };
          } else if (preprocess_state.IsHeapResource(ref)) {
            if (resource_class == "0") {
              preprocess_state.srv_binding_load_variables[variable] = {
                  nullptr, ParseInt(index), ParseInt(elementOffset), ParseInt(alignment), res_name};
            } else {
              preprocess_state.uav_binding_load_variables[variable] = {
                  nullptr, ParseInt(index), ParseInt(elementOffset), ParseInt(alignment), res_name};
            }
          }
        } else if (functionName == "@dx.op.bufferLoad.i32" || functionName == "@dx.op.bufferLoad.i16") {
          // call %dx.types.ResRet.i32 @dx.op.bufferLoad.i32(i32 68, %dx.types.Handle %4, i32 6, i32 undef)  ; BufferLoad(srv,index,wot)
          // call %dx.types.ResRet.i32 @dx.op.bufferLoad.i32(i32 68, %dx.types.Handle %31, i32 %28, i32 undef)  ; BufferLoad(srv,index,wot)
          auto [opNumber, srv, index, wot] = StringViewSplit<4>(functionParamsString, param_regex, 2);
          auto ref = std::string{srv.substr(1)};
          auto [res_name, range_index, resource_class] = preprocess_state.resource_binding_variables.at(ref);
          assignment_type = preprocess_state.GetResourceDataType(ref);
          auto buffer_load_shape = preprocess_state.GetResourceShape(ref);
          if (buffer_load_shape == Resource::ResourceKind::StructuredBuffer) {
            // StructuredBuffer: register so extractvalue resolves struct field names
            if (resource_class == "0") {
              preprocess_state.srv_binding_load_variables[variable] = {
                  &preprocess_state.srv_resources[range_index],
                  ParseInt(index), "0", "4", ""};
            } else {
              preprocess_state.uav_binding_load_variables[variable] = {
                  &preprocess_state.uav_resources[range_index],
                  ParseInt(index), "0", "4", ""};
            }
          } else if (buffer_load_shape == Resource::ResourceKind::RawBuffer) {
            // RawBuffer (ByteAddressBuffer): register as raw load so extractvalue
            // emits component access directly without an intermediate variable.
            assignment_value = std::format("{}.Load4{}", res_name, ParseWrapped(ParseInt(index)));
            if (resource_class == "0") {
              preprocess_state.srv_binding_load_variables[variable] = {
                  nullptr, assignment_value, "4", "raw", ""};
            } else {
              preprocess_state.uav_binding_load_variables[variable] = {
                  nullptr, assignment_value, "4", "raw", ""};
            }
            use_comment = true;
          } else {
            // TypedBuffer (RWBuffer<T>): emit .Load() directly
            assignment_value = std::format("{}.Load{}", res_name, ParseWrapped(ParseInt(index)));
          }

        } else if (functionName == "@dx.op.bufferLoad.f32" || functionName == "@dx.op.bufferLoad.f16") {
          // call %dx.types.ResRet.i32 @dx.op.bufferLoad.i32(i32 68, %dx.types.Handle %31, i32 %28, i32 undef)  ; BufferLoad(srv,index,wot)
          auto [opNumber, srv, index, wot] = StringViewSplit<4>(functionParamsString, param_regex, 2);
          auto ref = std::string{srv.substr(1)};
          auto [res_name, range_index, resource_class] = preprocess_state.resource_binding_variables.at(ref);
          assignment_type = preprocess_state.GetResourceDataType(ref);
          auto buffer_load_shape_f = preprocess_state.GetResourceShape(ref);
          if (buffer_load_shape_f == Resource::ResourceKind::StructuredBuffer) {
            // StructuredBuffer: register so extractvalue resolves struct field names
            if (resource_class == "0") {
              preprocess_state.srv_binding_load_variables[variable] = {
                  &preprocess_state.srv_resources[range_index],
                  ParseInt(index), "0", "4", ""};
            } else {
              preprocess_state.uav_binding_load_variables[variable] = {
                  &preprocess_state.uav_resources[range_index],
                  ParseInt(index), "0", "4", ""};
            }
          } else if (buffer_load_shape_f == Resource::ResourceKind::RawBuffer) {
            // RawBuffer: register as raw load
            assignment_value = std::format("asfloat({}.Load4{})", res_name, ParseWrapped(ParseInt(index)));
            if (resource_class == "0") {
              preprocess_state.srv_binding_load_variables[variable] = {
                  nullptr, assignment_value, "4", "raw", ""};
            } else {
              preprocess_state.uav_binding_load_variables[variable] = {
                  nullptr, assignment_value, "4", "raw", ""};
            }
            use_comment = true;
          } else {
            // TypedBuffer: emit .Load() directly
            assignment_value = std::format("{}.Load{}", res_name, ParseWrapped(ParseInt(index)));
          }
        } else if (functionName == "@dx.op.bufferUpdateCounter") {
          // %98 = call i32 @dx.op.bufferUpdateCounter(i32 70, %dx.types.Handle %2, i8 -1)  ; BufferUpdateCounter(uav,inc)
          auto [opNumber, handle, inc] = StringViewSplit<3>(functionParamsString, param_regex, 2);
          auto ref = std::string{handle.substr(1)};
          auto [uav_name, range_index, resource_class] = preprocess_state.resource_binding_variables.at(ref);
          int inc_value = 0;
          FromStringView(inc, inc_value);
          assignment_type = "uint";
          if (inc_value == 1 || inc == "1") {
            assignment_value = std::format("{}.IncrementCounter()", uav_name);
          } else {
            assignment_value = std::format("{}.DecrementCounter()", uav_name);
          }
        } else if (functionName == "@dx.op.threadId.i32") {
          // call i32 @dx.op.threadId.i32(i32 93, i32 0)  ; ThreadId(component)
          auto [opNumber, component] = StringViewSplit<2>(functionParamsString, param_regex, 2);
          assignment_type = "uint";
          assignment_value = std::format("SV_DispatchThreadID.{}", ParseIndex(component));
          is_identity = true;

        } else if (functionName == "@dx.op.threadIdInGroup.i32") {
          // %14 = call i32 @dx.op.threadIdInGroup.i32(i32 95, i32 0)  ; ThreadIdInGroup(component)
          auto [opNumber, component] = StringViewSplit<2>(functionParamsString, param_regex, 2);
          assignment_type = "uint";
          assignment_value = std::format("SV_GroupThreadID.{}", ParseIndex(component));
          is_identity = true;
        } else if (functionName == "@dx.op.flattenedThreadIdInGroup.i32") {
          // call i32 @dx.op.flattenedThreadIdInGroup.i32(i32 96)  ; FlattenedThreadIdInGroup()
          assignment_type = "uint";
          assignment_value = "SV_GroupIndex";
          is_identity = true;
        } else if (functionName == "@dx.op.viewID.i32") {
          // call i32 @dx.op.viewID.i32(i32 138)  ; ViewID()
          assignment_type = "uint";
          assignment_value = "SV_ViewID";
          is_identity = true;
          preprocess_state.uses_view_id = true;
        } else if (functionName == "@dx.op.groupId.i32") {
          // %10 = call i32 @dx.op.groupId.i32(i32 94, i32 0)  ; GroupId(component)
          auto [opNumber, component] = StringViewSplit<2>(functionParamsString, param_regex, 2);
          assignment_type = "uint";
          assignment_value = std::format("SV_GroupID.{}", ParseIndex(component));
          is_identity = true;
        } else if (functionName == "@dx.op.isSpecialFloat.f32") {
          // call i1 @dx.op.isSpecialFloat.f32(i32 8, float %309)  ; IsNaN(value)
          auto [opNumber, value] = StringViewSplit<2>(functionParamsString, param_regex, 2);
          if (auto pair = UNARY_FLOAT_OPS.find(std::string(opNumber));
              pair != UNARY_FLOAT_OPS.end()) {
            assignment_type = ParseType(type);
            assignment_value = std::format("{}{}", pair->second, ParseWrapped(ParseFloat(value)));
          } else {
            throw std::runtime_error("Unknown @dx.op.isSpecialFloat.f32");
          }
        } else if (functionName == "@dx.op.getDimensions") {
          // call %dx.types.Dimensions @dx.op.getDimensions(i32 72, %dx.types.Handle %1, i32 0)  ; GetDimensions(handle,mipLevel)
          auto [opNumber, handle, mip_level] = StringViewSplit<3>(functionParamsString, param_regex, 2);

          auto ref_resource = std::string{handle.substr(1)};
          auto [srv_name, range_index, resource_class] = preprocess_state.resource_binding_variables.at(ref_resource);
          Resource::ResourceKind shape = preprocess_state.GetResourceShape(ref_resource);

          std::string get_dimensions_arguments;
          switch (shape) {
            case SRVResource::ResourceKind::Texture1D:
              assignment_type = "uint";
              get_dimensions_arguments = std::format("_{}", variable);
              break;
            case SRVResource::ResourceKind::Texture2D:
              assignment_type = "uint2";
              get_dimensions_arguments = std::format("_{}.x, _{}.y", variable, variable);
              break;
            case SRVResource::ResourceKind::Texture2DArray:
            case SRVResource::ResourceKind::Texture3D:
              assignment_type = "uint3";
              get_dimensions_arguments = std::format("_{}.x, _{}.y, _{}.z", variable, variable, variable);
              break;
            case SRVResource::ResourceKind::StructuredBuffer:
            case SRVResource::ResourceKind::RawBuffer: {
              // StructuredBuffer/ByteAddressBuffer: GetDimensions(numStructs, stride)
              assignment_type = "uint2";
              get_dimensions_arguments = std::format("_{}.x, _{}.y", variable, variable);
              break;
            }
            default:
              std::cerr << "Unexpected shape: " << Resource::ResourceKindString(shape) << "\n";
              throw std::runtime_error("Unexpected shape");
          }

          bool has_mip_level = (mip_level != "0" && mip_level != "undef"
                                && shape != SRVResource::ResourceKind::StructuredBuffer
                                && shape != SRVResource::ResourceKind::RawBuffer);
          if (has_mip_level) {
            decompiled = std::format("{} _{}; uint _{}_levels; {}.GetDimensions({}, {}, _{}_levels);",
                                     assignment_type, variable, variable, srv_name, ParseUint(mip_level), get_dimensions_arguments, variable);
          } else {
            decompiled = std::format("{} _{}; {}.GetDimensions({});", assignment_type, variable, srv_name, get_dimensions_arguments);
          }
          is_identity = false;  // Can never be identity
        } else if (functionName == "@dx.op.sampleBias.f32" || functionName == "@dx.op.sampleBias.f16") {
          // call %dx.types.ResRet.f32 @dx.op.sampleBias.f32(i32 61, %dx.types.Handle %66, %dx.types.Handle %67, float %62, float %63, float undef, float undef, i32 0, i32 0, i32 undef, float %65, float undef)  ; SampleBias(srv,sampler,coord0,coord1,coord2,coord3,offset0,offset1,offset2,bias,clamp)
          auto [op, srv, sampler, coord0, coord1, coord2, coord3, offset0, offset1, offset2, bias, clamp] = StringViewSplit<12>(functionParamsString, param_regex, 2);

          auto ref_resource = std::string{srv.substr(1)};
          auto ref_sampler = std::string{sampler.substr(1)};

          const bool has_coord_z = coord2 != "undef";
          const bool has_coord_w = coord3 != "undef";
          const bool has_offset_y = offset1 != "undef";
          const bool has_offset_z = offset2 != "undef";
          std::string coords;
          if (has_coord_w) {
            coords = std::format("float4({}, {}, {}, {})", ParseFloat(coord0), ParseFloat(coord1), ParseFloat(coord2), ParseFloat(coord3));
          } else if (has_coord_z) {
            coords = std::format("float3({}, {}, {})", ParseFloat(coord0), ParseFloat(coord1), ParseFloat(coord2));
          } else {
            coords = std::format("float2({}, {})", ParseFloat(coord0), ParseFloat(coord1));
          }
          std::string offset;
          if (has_offset_z) {
            offset = std::format("int3({}, {}, {})", ParseInt(offset0), ParseInt(offset1), ParseInt(offset2));
          } else if (has_offset_y) {
            offset = std::format("int2({}, {})", ParseInt(offset0), ParseInt(offset1));
          } else {
            offset = std::format("{}", ParseInt(offset0));
          }

          auto [srv_name, srv_range_index, srv_resource_class] = preprocess_state.resource_binding_variables.at(ref_resource);
          auto [sampler_name, sampler_range_index, sampler_resource_class] = preprocess_state.resource_binding_variables.at(ref_sampler);
          auto sampler_resource = preprocess_state.sampler_resources[sampler_range_index];

          assignment_type = preprocess_state.GetResourceDataType(ref_resource);
          assignment_value = std::format("{}.SampleBias({}, {}, {}, {})",
                                         srv_name,
                                         sampler_name, coords, ParseFloat(bias), offset);
        } else if (functionName == "@dx.op.sampleGrad.f32") {
          // %296 = call %dx.types.ResRet.f32 @dx.op.sampleGrad.f32(i32 63, %dx.types.Handle %294, %dx.types.Handle %295, float %36, float %29, float undef, float undef, i32 0, i32 0, i32 undef, float %289, float %290, float undef, float %292, float %293, float undef, float undef)  ; SampleGrad(srv,sampler,coord0,coord1,coord2,coord3,offset0,offset1,offset2,ddx0,ddx1,ddx2,ddy0,ddy1,ddy2,clamp)
          auto [op, srv, sampler,
                coord0, coord1, coord2, coord3,
                offset0, offset1, offset2,
                ddx0, ddx1, ddx2,
                ddy0, ddy1, ddy2,
                clamp] = StringViewSplit<17>(functionParamsString, param_regex, 2);

          auto ref_resource = std::string{srv.substr(1)};
          auto ref_sampler = std::string{sampler.substr(1)};

          const bool has_coord_z = coord2 != "undef";
          const bool has_coord_w = coord3 != "undef";
          const bool has_offset_y = offset1 != "undef";
          const bool has_offset_z = offset2 != "undef";

          std::string coords;
          if (has_coord_w) {
            coords = std::format("float4({}, {}, {}, {})", ParseFloat(coord0), ParseFloat(coord1), ParseFloat(coord2), ParseFloat(coord3));
          } else if (has_coord_z) {
            coords = std::format("float3({}, {}, {})", ParseFloat(coord0), ParseFloat(coord1), ParseFloat(coord2));
          } else {
            coords = std::format("float2({}, {})", ParseFloat(coord0), ParseFloat(coord1));
          }
          std::string offset;
          if (has_offset_z) {
            offset = std::format("int3({}, {}, {})", ParseInt(offset0), ParseInt(offset1), ParseInt(offset2));
          } else if (has_offset_y) {
            offset = std::format("int2({}, {})", ParseInt(offset0), ParseInt(offset1));
          } else {
            offset = std::format("{}", ParseInt(offset0));
          }

          std::string ddx;
          if (ddx2 != "undef") {
            ddx = std::format("float3({}, {}, {})", ParseFloat(ddx0), ParseFloat(ddx1), ParseFloat(ddx2));
          } else if (ddx1 != "undef") {
            ddx = std::format("float2({}, {})", ParseFloat(ddx0), ParseFloat(ddx1));
          } else {
            ddx = std::format("{}", ParseFloat(ddx0));
          }

          std::string ddy;
          if (ddy2 != "undef") {
            ddy = std::format("float3({}, {}, {})", ParseFloat(ddy0), ParseFloat(ddy1), ParseFloat(ddy2));
          } else if (ddy1 != "undef") {
            ddy = std::format("float2({}, {})", ParseFloat(ddy0), ParseFloat(ddy1));
          } else {
            ddy = std::format("{}", ParseFloat(ddy0));
          }

          auto [srv_name, srv_range_index, srv_resource_class] = preprocess_state.resource_binding_variables.at(ref_resource);
          auto [sampler_name, sampler_range_index, sampler_resource_class] = preprocess_state.resource_binding_variables.at(ref_sampler);
          auto sampler_resource = preprocess_state.sampler_resources[sampler_range_index];

          assignment_type = preprocess_state.GetResourceDataType(ref_resource);
          assignment_value = std::format("{}.SampleGrad({}, {}, {}, {}, {})",
                                         srv_name,
                                         sampler_name, coords, ddx, ddy, offset);
        } else if (functionName == "@dx.op.sampleCmpLevelZero.f32") {
          // call %dx.types.ResRet.f32 @dx.op.sampleCmpLevelZero.f32(i32 65, %dx.types.Handle %10, %dx.types.Handle %14, float %528, float %530, float %407, float undef, i32 0, i32 0, i32 undef, float %441)  ; SampleCmpLevelZero(srv,sampler,coord0,coord1,coord2,coord3,offset0,offset1,offset2,compareValue)
          // call %dx.types.ResRet.f32 @dx.op.sampleCmpLevelZero.f32(i32 65, %dx.types.Handle %2, %dx.types.Handle %4, float %232, float %234, float %159, float undef, i32 0, i32 0, i32 undef, float %158)  ; SampleCmpLevelZero(srv,sampler,coord0,coord1,coord2,coord3,offset0,offset1,offset2,compareValue)
          auto [op, srv, sampler, coord0, coord1, coord2, coord3, offset0, offset1, offset2, compareValue] = StringViewSplit<11>(functionParamsString, param_regex, 2);

          auto ref_resource = std::string{srv.substr(1)};
          auto ref_sampler = std::string{sampler.substr(1)};

          const bool has_coord_z = coord2 != "undef";
          const bool has_coord_w = coord3 != "undef";
          const bool has_offset_y = offset1 != "undef";
          const bool has_offset_z = offset2 != "undef";
          std::string coords;
          if (has_coord_w) {
            coords = std::format("float4({}, {}, {}, {})", ParseFloat(coord0), ParseFloat(coord1), ParseFloat(coord2), ParseFloat(coord3));
          } else if (has_coord_z) {
            coords = std::format("float3({}, {}, {})", ParseFloat(coord0), ParseFloat(coord1), ParseFloat(coord2));
          } else {
            coords = std::format("float2({}, {})", ParseFloat(coord0), ParseFloat(coord1));
          }
          std::string offset;
          if (has_offset_z) {
            offset = std::format("int3({}, {}, {})", ParseInt(offset0), ParseInt(offset1), ParseInt(offset2));
          } else if (has_offset_y) {
            offset = std::format("int2({}, {})", ParseInt(offset0), ParseInt(offset1));
          } else {
            offset = std::format("{}", ParseInt(offset0));
          }

          auto [srv_name, srv_range_index, srv_resource_class] = preprocess_state.resource_binding_variables.at(ref_resource);
          auto [sampler_name, sampler_range_index, sampler_resource_class] = preprocess_state.resource_binding_variables.at(ref_sampler);
          auto sampler_resource = preprocess_state.sampler_resources[sampler_range_index];

          assignment_type = preprocess_state.GetResourceDataType(ref_resource);
          assignment_value = std::format("{}.SampleCmpLevelZero({}, {}, {})", srv_name, sampler_name, coords, ParseFloat(compareValue));
        } else if (functionName == "@dx.op.textureGather.i32" || functionName == "@dx.op.textureGather.f32" || functionName == "@dx.op.textureGather.i16") {
          // %67 = call %dx.types.ResRet.i32 @dx.op.textureGather.i32(i32 73, %dx.types.Handle %3, %dx.types.Handle %11, float %53, float %54, float undef, float undef, i32 0, i32 0, i32 0)  ; TextureGather(srv,sampler,coord0,coord1,coord2,coord3,offset0,offset1,channel)
          auto [op, srv, sampler, coord0, coord1, coord2, coord3, offset0, offset1, channel] = StringViewSplit<10>(functionParamsString, param_regex, 2);
          auto ref_resource = std::string{srv.substr(1)};
          auto ref_sampler = std::string{sampler.substr(1)};

          const bool has_coord_z = coord2 != "undef";
          const bool has_coord_w = coord3 != "undef";
          const bool has_offset_y = offset1 != "undef";
          std::string coords;
          if (has_coord_w) {
            coords = std::format("float4({}, {}, {}, {})", ParseFloat(coord0), ParseFloat(coord1), ParseFloat(coord2), ParseFloat(coord3));
          } else if (has_coord_z) {
            coords = std::format("float3({}, {}, {})", ParseFloat(coord0), ParseFloat(coord1), ParseFloat(coord2));
          } else {
            coords = std::format("float2({}, {})", ParseFloat(coord0), ParseFloat(coord1));
          }
          std::string offset;
          if (has_offset_y) {
            offset = std::format("int2({}, {})", ParseInt(offset0), ParseInt(offset1));
          } else {
            offset = std::format("{}", ParseInt(offset0));
          }

          auto [srv_name, srv_range_index, srv_resource_class] = preprocess_state.resource_binding_variables.at(ref_resource);
          auto [sampler_name, sampler_range_index, sampler_resource_class] = preprocess_state.resource_binding_variables.at(ref_sampler);
          auto sampler_resource = preprocess_state.sampler_resources[sampler_range_index];
          std::string channel_string;
          if (channel == "0") {
            channel_string = "Red";
          } else if (channel == "1") {
            channel_string = "Green";
          } else if (channel == "2") {
            channel_string = "Blue";
          } else if (channel == "3") {
            channel_string = "Alpha";
          } else {
            throw std::runtime_error("Unknown Gather channel.");
          }
          if (functionName == "@dx.op.textureGather.i32") {
            assignment_type = "int4";
          } else if (functionName == "@dx.op.textureGather.i16") {
            assignment_type = "int16_t4";
          } else {
            assignment_type = "float4";
          }
          assignment_value = std::format("{}.Gather{}({}, {})", srv_name, channel_string, sampler_name, coords);
        } else if (functionName == "@dx.op.waveReadLaneFirst.f32") {
          // call float @dx.op.waveReadLaneFirst.f32(i32 118, float %503)  ; WaveReadLaneFirst(value)
          auto [op, value] = StringViewSplit<2>(functionParamsString, param_regex, 2);
          assignment_type = "float";
          assignment_value = std::format("WaveReadLaneFirst{}", ParseWrapped(ParseFloat(value)));
        } else if (functionName == "@dx.op.waveReadLaneFirst.i32") {
          // call i32 @dx.op.waveReadLaneFirst.i32(i32 118, i32 %36)  ; WaveReadLaneFirst(value)
          auto [op, value] = StringViewSplit<2>(functionParamsString, param_regex, 2);
          assignment_type = "int";
          assignment_value = std::format("WaveReadLaneFirst{}", ParseWrapped(ParseInt(value)));

        } else if (functionName == "@dx.op.waveActiveOp.i32") {
          // call i32 @dx.op.waveActiveOp.i32(i32 119, i32 %140, i8 3, i8 1)  ; WaveActiveOp(value,op,sop)
          auto [op, value, op2, sop] = StringViewSplit<4>(functionParamsString, param_regex, 2);
          assignment_type = "int";
          if (op2 == "0") {
            assignment_value = std::format("WaveActiveSum{}", ParseWrapped(ParseInt(value)));
          } else if (op2 == "1") {
            assignment_value = std::format("WaveActiveProduct{}", ParseWrapped(ParseInt(value)));
          } else if (op2 == "2") {
            assignment_value = std::format("WaveActiveMin{}", ParseWrapped(ParseInt(value)));
          } else if (op2 == "3") {
            assignment_value = std::format("WaveActiveMax{}", ParseWrapped(ParseInt(value)));
          } else {
            throw std::runtime_error("Unknown wave active op");
          }
        } else if (functionName == "@dx.op.waveActiveOp.f32") {
          // %58 = call float @dx.op.waveActiveOp.f32(i32 119, float %57, i8 3, i8 0)  ; WaveActiveOp(value,op,sop)
          auto [op, value, op2, sop] = StringViewSplit<4>(functionParamsString, param_regex, 2);
          assignment_type = "float";
          if (op2 == "0") {
            assignment_value = std::format("WaveActiveSum{}", ParseWrapped(ParseFloat(value)));
          } else if (op2 == "1") {
            assignment_value = std::format("WaveActiveProduct{}", ParseWrapped(ParseFloat(value)));
          } else if (op2 == "2") {
            assignment_value = std::format("WaveActiveMin{}", ParseWrapped(ParseFloat(value)));
          } else if (op2 == "3") {
            assignment_value = std::format("WaveActiveMax{}", ParseWrapped(ParseFloat(value)));
          } else {
            throw std::runtime_error("Unknown wave active op");
          }
        } else if (functionName == "@dx.op.waveIsFirstLane") {
          // call i1 @dx.op.waveIsFirstLane(i32 110)  ; WaveIsFirstLane()
          assignment_type = "bool";
          assignment_value = "WaveIsFirstLane()";
        } else if (functionName == "@dx.op.waveAllTrue") {
          // call i1 @dx.op.waveAllTrue(i32 114, i1 %144)  ; WaveAllTrue(cond)
          auto [op, cond] = StringViewSplit<2>(functionParamsString, param_regex, 2);
          assignment_type = "bool";
          assignment_value = std::format("WaveActiveAllTrue{}", ParseWrapped(ParseBool(cond)));
        } else if (functionName == "@dx.op.waveAllTrue.i32") {
          // call i1 @dx.op.waveAllTrue(i32 114, i1 %34)  ; WaveAllTrue(cond)
          auto [op, cond] = StringViewSplit<2>(functionParamsString, param_regex, 2);
          assignment_type = "bool";
          assignment_value = std::format("WaveActiveAllTrue{}", ParseWrapped(ParseBool(cond)));
        } else if (functionName == "@dx.op.waveAllOp") {
          // %25 = call i32 @dx.op.waveAllOp(i32 135, i1 true)  ; WaveAllBitCount(value)
          auto [op, cond] = StringViewSplit<2>(functionParamsString, param_regex, 2);
          assignment_type = "int";
          assignment_value = std::format("WaveActiveCountBits{}", ParseWrapped(ParseBool(cond)));
        } else if (functionName == "@dx.op.wavePrefixOp") {
          // %26 = call i32 @dx.op.wavePrefixOp(i32 136, i1 true)  ; WavePrefixBitCount(value)
          auto [op, cond] = StringViewSplit<2>(functionParamsString, param_regex, 2);
          assignment_type = "int";
          assignment_value = std::format("WavePrefixCountBits{}", ParseWrapped(ParseBool(cond)));
        } else if (functionName == "@dx.op.wavePrefixOp.i32") {
          // %213 = call i32 @dx.op.wavePrefixOp.i32(i32 121, i32 %212, i8 0, i8 1)  ; WavePrefixOp(value,op,sop)
          auto [opNumber, value, op, sop] = StringViewSplit<4>(functionParamsString, param_regex, 2);
          int op_val = 0, sop_val = 0;
          FromStringView(op, op_val);
          FromStringView(sop, sop_val);
          bool is_unsigned = (sop_val == 1);
          assignment_type = is_unsigned ? "uint" : "int";
          std::string func_name = (op_val == 0) ? "WavePrefixSum" : "WavePrefixProduct";
          if (is_unsigned) {
            assignment_value = std::format("{}({})", func_name, ParseUint(value));
          } else {
            assignment_value = std::format("{}({})", func_name, ParseInt(value));
          }
        } else if (functionName == "@dx.op.wavePrefixOp.f32") {
          // call float @dx.op.wavePrefixOp.f32(i32 121, float %val, i8 0, i8 0)  ; WavePrefixOp(value,op,sop)
          auto [opNumber, value, op, sop] = StringViewSplit<4>(functionParamsString, param_regex, 2);
          int op_val = 0;
          FromStringView(op, op_val);
          assignment_type = "float";
          std::string func_name = (op_val == 0) ? "WavePrefixSum" : "WavePrefixProduct";
          assignment_value = std::format("{}({})", func_name, ParseFloat(value));
        } else if (functionName == "@dx.op.waveAnyTrue") {
          // call i1 @dx.op.waveAnyTrue(i32 113, i1 %264)  ; WaveAnyTrue(cond)
          auto [op, cond] = StringViewSplit<2>(functionParamsString, param_regex, 2);
          assignment_type = "bool";
          assignment_value = std::format("WaveActiveAnyTrue{}", ParseWrapped(ParseBool(cond)));
        } else if (functionName == "@dx.op.waveActiveBit.i32") {
          // %2503 = call i32 @dx.op.waveActiveBit.i32(i32 120, i32 %2502, i8 1)  ; WaveActiveBit(value,op)
          auto [op, value, bitOp] = StringViewSplit<3>(functionParamsString, param_regex, 2);
          assignment_type = "uint";
          // WaveActiveBit functions require uint argument — explicit cast
          auto uint_arg = std::format("(uint)({})", ParseInt(value));
          if (bitOp == "0") {
            assignment_value = std::format("WaveActiveBitAnd{}", ParseWrapped(uint_arg));
          } else if (bitOp == "1") {
            assignment_value = std::format("WaveActiveBitOr{}", ParseWrapped(uint_arg));
          } else if (bitOp == "2") {
            assignment_value = std::format("WaveActiveBitXor{}", ParseWrapped(uint_arg));
          } else {
            throw std::runtime_error("Unknown wave active bit op");
          }
        } else if (functionName == "@dx.op.waveGetLaneIndex") {
          // %347 = call i32 @dx.op.waveGetLaneIndex(i32 111)  ; WaveGetLaneIndex()
          assignment_type = "int";
          assignment_value = "WaveGetLaneIndex()";
        } else if (functionName == "@dx.op.waveActiveBallot") {
          // %X = call %dx.types.fouri32 @dx.op.waveActiveBallot(i32 116, i1 %cond)  ; WaveActiveBallot(cond)
          auto [opNumber, cond] = StringViewSplit<2>(functionParamsString, param_regex, 2);
          assignment_type = "uint4";
          assignment_value = std::format("WaveActiveBallot{}", ParseWrapped(ParseBool(cond)));
        } else if (functionName == "@dx.op.waveGetLaneCount") {
          // %15 = call i32 @dx.op.waveGetLaneCount(i32 112)  ; WaveGetLaneCount()
          assignment_type = "uint";
          assignment_value = "WaveGetLaneCount()";
        } else if (functionName == "@dx.op.waveReadLaneAt.f32") {
          //   %823 = call float @dx.op.waveReadLaneAt.f32(i32 117, float %682, i32 %821)  ; WaveReadLaneAt(value,lane)
          auto [op, value, lane] = StringViewSplit<3>(functionParamsString, param_regex, 2);
          assignment_type = "float";
          assignment_value = std::format("WaveReadLaneAt({},{})", ParseFloat(value), ParseInt(lane));
        } else if (functionName == "@dx.op.waveReadLaneAt.i32") {
          //   %350 = call i32 @dx.op.waveReadLaneAt.i32(i32 117, i32 %346, i32 %349)  ; WaveReadLaneAt(value,lane)
          auto [op, value, lane] = StringViewSplit<3>(functionParamsString, param_regex, 2);
          assignment_type = "int";
          assignment_value = std::format("WaveReadLaneAt({},{})", ParseInt(value), ParseInt(lane));
        } else if (functionName == "@dx.op.waveMatch.i32") {
          // %928 = call %dx.types.fouri32 @dx.op.waveMatch.i32(i32 165, i32 %876)  ; WaveMatch(value)
          auto [op, value] = StringViewSplit<2>(functionParamsString, param_regex, 2);
          assignment_type = "uint4";
          assignment_value = std::format("WaveMatch({})", ParseInt(value));
        } else if (functionName.starts_with("@dx.op.waveMultiPrefixOp.")) {
          // %942 = call half @dx.op.waveMultiPrefixOp.f16(i32 166, half %923, i32 %932, i32 %935, i32 %938, i32 %941, i8 0, i8 0)
          // WaveMultiPrefixOp(value, mask0, mask1, mask2, mask3, op, sop)
          auto [op_id, value, m0, m1, m2, m3, wave_op, sop] = StringViewSplit<8>(functionParamsString, param_regex, 2);
          std::string val_parsed;
          if (functionName.find(".f16") != std::string::npos || functionName.find(".f32") != std::string::npos) {
            val_parsed = ParseFloat(value);
            assignment_type = functionName.find(".f16") != std::string::npos ? "half" : "float";
          } else {
            val_parsed = ParseInt(value);
            assignment_type = "int";
          }
          auto mask_str = std::format("uint4({}, {}, {}, {})", ParseInt(m0), ParseInt(m1), ParseInt(m2), ParseInt(m3));
          std::string op_name;
          if (wave_op == "0") op_name = "WaveMultiPrefixSum";
          else if (wave_op == "1") op_name = "WaveMultiPrefixProduct";
          else op_name = std::format("WaveMultiPrefixOp/*op={}*/", wave_op);
          assignment_value = std::format("{}({}, {})", op_name, val_parsed, mask_str);
        } else if (functionName == "@dx.op.quadReadLaneAt.f32") {
          // call float @dx.op.quadReadLaneAt.f32(i32 122, float %val, i32 0)  ; QuadReadLaneAt(value,quadLane)
          auto [op, value, quadLane] = StringViewSplit<3>(functionParamsString, param_regex, 2);
          assignment_type = "float";
          assignment_value = std::format("QuadReadLaneAt({}, {})", ParseFloat(value), ParseInt(quadLane));
        } else if (functionName == "@dx.op.quadReadLaneAt.f16") {
          auto [op, value, quadLane] = StringViewSplit<3>(functionParamsString, param_regex, 2);
          assignment_type = "half";
          assignment_value = std::format("QuadReadLaneAt({}, {})", ParseHalf(value), ParseInt(quadLane));
        } else if (functionName == "@dx.op.quadReadLaneAt.i32") {
          auto [op, value, quadLane] = StringViewSplit<3>(functionParamsString, param_regex, 2);
          assignment_type = "int";
          assignment_value = std::format("QuadReadLaneAt({}, {})", ParseInt(value), ParseInt(quadLane));
        } else if (functionName == "@dx.op.quadReadLaneAt.i16") {
          auto [op, value, quadLane] = StringViewSplit<3>(functionParamsString, param_regex, 2);
          assignment_type = "int16_t";
          assignment_value = std::format("QuadReadLaneAt({}, {})", ParseInt(value), ParseInt(quadLane));
        } else if (functionName == "@dx.op.legacyF32ToF16") {
          //   %1390 = call i32 @dx.op.legacyF32ToF16(i32 130, float %115)  ; LegacyF32ToF16(value)
          auto [op, value] = StringViewSplit<2>(functionParamsString, param_regex, 2);
          assignment_type = "uint";
          assignment_value = std::format("f32tof16({})", ParseFloat(value));
        } else if (functionName == "@dx.op.legacyF16ToF32") {
          //   %350 = call float @dx.op.legacyF16ToF32(i32 131, i32 %349)  ; LegacyF16ToF32(value)
          auto [op, value] = StringViewSplit<2>(functionParamsString, param_regex, 2);
          assignment_type = "float";
          assignment_value = std::format("f16tof32({})", ParseUint(value));
        } else if (functionName == "@dx.op.atomicBinOp.i32") {
          // %78 = call i32 @dx.op.atomicBinOp.i32(i32 78, %dx.types.Handle %1, i32 7, i32 %62, i32 %63, i32 0, i32 %77)  ; AtomicBinOp(handle,atomicOp,offset0,offset1,offset2,newValue)
          auto [op, handle, atomicOp, offset0, offset1, offset2, newValue] = StringViewSplit<7>(functionParamsString, param_regex, 2);
          auto ref_resource = std::string{handle.substr(1)};
          auto [uav_name, uav_range_index, resource_class] = preprocess_state.resource_binding_variables.at(ref_resource);
          auto uav_resource = preprocess_state.uav_resources[uav_range_index];

          const bool has_offset_y = offset1 != "undef";
          const bool has_offset_z = offset2 != "undef";
          const bool is_raw_buffer = (uav_resource.shape == Resource::ResourceKind::RawBuffer);
          const bool is_structured = (uav_resource.shape == Resource::ResourceKind::StructuredBuffer);
          std::string target;
          bool use_method_syntax = false;
          std::string byte_addr;
          if (is_raw_buffer) {
            // RWByteAddressBuffer: use method syntax buffer.InterlockedAdd(byteAddress, value, original)
            use_method_syntax = true;
            byte_addr = ParseInt(offset0);
          } else if (is_structured && has_offset_y) {
            // StructuredBuffer: offset0 = element index, offset1 = byte offset within element
            int byte_offset = 0;
            FromStringView(offset1, byte_offset);
            // Try to resolve byte offset to struct field access
            // The data_type may be a plain name like "SharcAccumulationData" — try %struct. prefix
            std::string lookup_type = uav_resource.data_type;
            if (!lookup_type.starts_with("%") && !lookup_type.starts_with("_")) {
              auto struct_key = std::format("%struct.{}", lookup_type);
              if (preprocess_state.type_definitions.contains(struct_key)) {
                lookup_type = struct_key;
              }
            }
            std::string field_access;
            try {
              field_access = preprocess_state.GetSubValueFromType(lookup_type, DataType(lookup_type), byte_offset);
            } catch (...) {
              // Fallback: compute swizzle from byte offset assuming 4-byte components
              static const char* swizzles[] = {"x", "y", "z", "w"};
              int comp_idx = byte_offset / 4;
              if (comp_idx < 4) {
                field_access = std::format(".{}", swizzles[comp_idx]);
              }
            }
            target = std::format("{}[{}]{}", uav_name, ParseInt(offset0), field_access);
          } else if (is_structured) {
            target = std::format("{}[{}]", uav_name, ParseInt(offset0));
          } else if (has_offset_z) {
            target = std::format("{}[int3({}, {}, {})]", uav_name, ParseInt(offset0), ParseInt(offset1), ParseInt(offset2));
          } else if (has_offset_y) {
            target = std::format("{}[int2({}, {})]", uav_name, ParseInt(offset0), ParseInt(offset1));
          } else {
            target = std::format("{}[{}]", uav_name, ParseInt(offset0));
          }
          // assignment_type = "int";
          std::string atomic_func;

          if (atomicOp == "0") {
            atomic_func = "InterlockedAdd";
          } else if (atomicOp == "1") {
            atomic_func = "InterlockedAnd";
          } else if (atomicOp == "2") {
            atomic_func = "InterlockedOr";
          } else if (atomicOp == "3") {
            atomic_func = "InterlockedXor";
          } else if (atomicOp == "4") {
            atomic_func = "InterlockedMin";
          } else if (atomicOp == "5") {
            atomic_func = "InterlockedMax";
          } else if (atomicOp == "6") {
            atomic_func = "InterlockedMin";
          } else if (atomicOp == "7") {
            atomic_func = "InterlockedMax";
          } else if (atomicOp == "8") {
            atomic_func = "InterlockedExchange";
          } else {
            throw std::runtime_error("Unknown atomicOp for AtomicBinOp");
          }
          assignment_type = "int";
          if (use_method_syntax) {
            decompiled = std::format("int _{}; {}.{}({}, {}, _{});", variable, uav_name, atomic_func, byte_addr, ParseInt(newValue), variable);
          } else {
            decompiled = std::format("int _{}; {}({}, {}, _{});", variable, atomic_func, target, ParseInt(newValue), variable);
          }
        } else if (functionName == "@dx.op.atomicBinOp.i64") {
          // %2646 = call i64 @dx.op.atomicBinOp.i64(i32 78, %dx.types.Handle %2537, i32 7, i32 %2530, i32 %2489, i32 undef, i64 %2645)  ; AtomicBinOp(handle,atomicOp,offset0,offset1,offset2,newValue)
          auto [op, handle, atomicOp, offset0, offset1, offset2, newValue] = StringViewSplit<7>(functionParamsString, param_regex, 2);
          auto ref_resource = std::string{handle.substr(1)};
          auto [uav_name, uav_range_index, resource_class] = preprocess_state.resource_binding_variables.at(ref_resource);
          auto uav_resource = preprocess_state.uav_resources[uav_range_index];

          const bool has_offset_y = offset1 != "undef";
          const bool has_offset_z = offset2 != "undef";
          const bool is_raw_buffer = (uav_resource.shape == Resource::ResourceKind::RawBuffer);
          const bool is_structured = (uav_resource.shape == Resource::ResourceKind::StructuredBuffer);
          std::string target;
          bool use_method_syntax = false;
          std::string byte_addr;
          if (is_raw_buffer) {
            use_method_syntax = true;
            byte_addr = ParseInt(offset0);
          } else if (is_structured && has_offset_y) {
            int byte_offset = 0;
            FromStringView(offset1, byte_offset);
            std::string lookup_type = uav_resource.data_type;
            if (!lookup_type.starts_with("%") && !lookup_type.starts_with("_")) {
              auto struct_key = std::format("%struct.{}", lookup_type);
              if (preprocess_state.type_definitions.contains(struct_key)) {
                lookup_type = struct_key;
              }
            }
            std::string field_access;
            try {
              field_access = preprocess_state.GetSubValueFromType(lookup_type, DataType(lookup_type), byte_offset);
            } catch (...) {
              static const char* swizzles[] = {"x", "y", "z", "w"};
              int comp_idx = byte_offset / 8;  // 8 bytes for i64
              if (comp_idx < 4) {
                field_access = std::format(".{}", swizzles[comp_idx]);
              }
            }
            target = std::format("{}[{}]{}", uav_name, ParseInt(offset0), field_access);
          } else if (is_structured) {
            target = std::format("{}[{}]", uav_name, ParseInt(offset0));
          } else if (has_offset_z) {
            target = std::format("{}[int3({}, {}, {})]", uav_name, ParseInt(offset0), ParseInt(offset1), ParseInt(offset2));
          } else if (has_offset_y) {
            target = std::format("{}[int2({}, {})]", uav_name, ParseInt(offset0), ParseInt(offset1));
          } else {
            target = std::format("{}[{}]", uav_name, ParseInt(offset0));
          }
          // assignment_type = "int64_t";
          std::string atomic_func;

          if (atomicOp == "0") {
            atomic_func = "InterlockedAdd";
          } else if (atomicOp == "1") {
            atomic_func = "InterlockedAnd";
          } else if (atomicOp == "2") {
            atomic_func = "InterlockedOr";
          } else if (atomicOp == "3") {
            atomic_func = "InterlockedXor";
          } else if (atomicOp == "4") {
            atomic_func = "InterlockedMin";
          } else if (atomicOp == "5") {
            atomic_func = "InterlockedMax";
          } else if (atomicOp == "6") {
            atomic_func = "InterlockedMin";
          } else if (atomicOp == "7") {
            atomic_func = "InterlockedMax";
          } else if (atomicOp == "8") {
            atomic_func = "InterlockedExchange";
          } else {
            throw std::runtime_error("Unknown atomicOp for AtomicBinOp");
          }
          assignment_type = "int64_t";
          if (use_method_syntax) {
            decompiled = std::format("int64_t _{}; {}.{}({}, {}, _{});", variable, uav_name, atomic_func, byte_addr, ParseInt64(newValue), variable);
          } else {
            decompiled = std::format("int64_t _{}; {}({}, {}, _{});", variable, atomic_func, target, ParseInt64(newValue), variable);
          }

        } else if (functionName == "@dx.op.atomicCompareExchange.i32"
                   || functionName == "@dx.op.atomicCompareExchange.i64") {
          // %4482 = call i64 @dx.op.atomicCompareExchange.i64(i32 79, %dx.types.Handle %4481, i32 %4480, i32 0, i32 undef, i64 0, i64 %4435)
          // AtomicCompareExchange(handle,offset0,offset1,offset2,compareValue,newValue)
          auto [op, handle, offset0, offset1, offset2, compareValue, newValue] = StringViewSplit<7>(functionParamsString, param_regex, 2);
          auto ref_resource = std::string{handle.substr(1)};
          auto [uav_name, uav_range_index, resource_class] = preprocess_state.resource_binding_variables.at(ref_resource);

          bool is_64 = functionName.find("i64") != std::string_view::npos;
          std::string value_type = is_64 ? "int64_t" : "int";

          auto uav_resource = preprocess_state.uav_resources[uav_range_index];
          const bool has_offset_y = offset1 != "undef";
          const bool is_raw_buffer = (uav_resource.shape == Resource::ResourceKind::RawBuffer);
          const bool is_structured = (uav_resource.shape == Resource::ResourceKind::StructuredBuffer);
          std::string target;
          bool use_method_syntax = false;
          std::string byte_addr;
          if (is_raw_buffer) {
            use_method_syntax = true;
            byte_addr = ParseInt(offset0);
          } else if (is_structured && has_offset_y) {
            int byte_offset = 0;
            FromStringView(offset1, byte_offset);
            std::string lookup_type = uav_resource.data_type;
            if (!lookup_type.starts_with("%") && !lookup_type.starts_with("_")) {
              auto struct_key = std::format("%struct.{}", lookup_type);
              if (preprocess_state.type_definitions.contains(struct_key)) {
                lookup_type = struct_key;
              }
            }
            std::string field_access;
            try {
              field_access = preprocess_state.GetSubValueFromType(lookup_type, DataType(lookup_type), byte_offset);
            } catch (...) {
              static const char* swizzles[] = {"x", "y", "z", "w"};
              int scalar_size = is_64 ? 8 : 4;
              int comp_idx = byte_offset / scalar_size;
              if (comp_idx < 4) {
                field_access = std::format(".{}", swizzles[comp_idx]);
              }
            }
            target = std::format("{}[{}]{}", uav_name, ParseInt(offset0), field_access);
          } else if (is_structured) {
            target = std::format("{}[{}]", uav_name, ParseInt(offset0));
          } else if (has_offset_y) {
            target = std::format("{}[int2({}, {})]", uav_name, ParseInt(offset0), ParseInt(offset1));
          } else {
            target = std::format("{}[{}]", uav_name, ParseInt(offset0));
          }

          assignment_type = value_type;
          if (use_method_syntax) {
            decompiled = std::format("{} _{}; {}.InterlockedCompareExchange({}, {}, {}, _{});",
                                     value_type, variable, uav_name, byte_addr,
                                     is_64 ? ParseInt64(compareValue) : ParseInt(compareValue),
                                     is_64 ? ParseInt64(newValue) : ParseInt(newValue),
                                     variable);
          } else {
            decompiled = std::format("{} _{}; InterlockedCompareExchange({}, {}, {}, _{});",
                                     value_type, variable, target,
                                     is_64 ? ParseInt64(compareValue) : ParseInt(compareValue),
                                     is_64 ? ParseInt64(newValue) : ParseInt(newValue),
                                     variable);
          }

        // --- Ray Query operations (DXR Tier 1.1 inline raytracing) ---
        } else if (functionName == "@dx.op.allocateRayQuery") {
          // %154 = call i32 @dx.op.allocateRayQuery(i32 178, i32 512)  ; AllocateRayQuery(constRayFlags)
          auto [opNumber, constRayFlags] = StringViewSplit<2>(functionParamsString, param_regex, 2);
          // Track for hoisting to function scope (avoids scoping issues with deferred blocks)
          ray_query_declarations.push_back(std::format("RayQuery<{}> _{};", ParseInt(constRayFlags), variable));
          assignment_type = "auto";
          assignment_value = std::format("/* RayQuery<{}> */", ParseInt(constRayFlags));
          use_comment = true;
        } else if (functionName == "@dx.op.rayQuery_Proceed.i1") {
          // %156 = call i1 @dx.op.rayQuery_Proceed.i1(i32 180, i32 %154)  ; RayQuery_Proceed(rayQueryHandle)
          auto [opNumber, rayQueryHandle] = StringViewSplit<2>(functionParamsString, param_regex, 2);
          assignment_type = "bool";
          assignment_value = std::format("_{}.Proceed()", ParseVariable(rayQueryHandle).substr(1));
        } else if (functionName == "@dx.op.rayQuery_StateScalar.i32") {
          // %159 = call i32 @dx.op.rayQuery_StateScalar.i32(i32 185, i32 %154)  ; RayQuery_CandidateType(rayQueryHandle)
          auto [opNumber, rayQueryHandle] = StringViewSplit<2>(functionParamsString, param_regex, 2);
          int op_code = 0;
          FromStringView(opNumber, op_code);
          std::string rq_var = std::format("_{}", ParseVariable(rayQueryHandle).substr(1));
          assignment_type = "uint";
          // Map DXIL opcodes to HLSL RayQuery methods
          switch (op_code) {
            case 184: assignment_value = std::format("{}.CommittedStatus()", rq_var); break;
            case 185: assignment_value = std::format("{}.CandidateType()", rq_var); break;
            case 201: assignment_value = std::format("{}.CandidateInstanceIndex()", rq_var); break;
            case 202: assignment_value = std::format("{}.CandidateInstanceID()", rq_var); break;
            case 203: assignment_value = std::format("{}.CandidateGeometryIndex()", rq_var); break;
            case 204: assignment_value = std::format("{}.CandidatePrimitiveIndex()", rq_var); break;
            case 207: assignment_value = std::format("{}.CommittedInstanceIndex()", rq_var); break;
            case 208: assignment_value = std::format("{}.CommittedInstanceID()", rq_var); break;
            case 209: assignment_value = std::format("{}.CommittedGeometryIndex()", rq_var); break;
            case 210: assignment_value = std::format("{}.CommittedPrimitiveIndex()", rq_var); break;
            default: throw std::runtime_error(std::format("Unknown rayQuery_StateScalar.i32 opcode {}", op_code));
          }
        } else if (functionName == "@dx.op.rayQuery_StateScalar.f32") {
          // %1396 = call float @dx.op.rayQuery_StateScalar.f32(i32 200, i32 %154)  ; RayQuery_CommittedRayT(rayQueryHandle)
          auto [opNumber, rayQueryHandle] = StringViewSplit<2>(functionParamsString, param_regex, 2);
          int op_code = 0;
          FromStringView(opNumber, op_code);
          std::string rq_var = std::format("_{}", ParseVariable(rayQueryHandle).substr(1));
          assignment_type = "float";
          switch (op_code) {
            case 195: assignment_value = std::format("{}.CandidateTriangleRayT()", rq_var); break;
            case 198: assignment_value = std::format("{}.RayTMin()", rq_var); break;
            case 199: assignment_value = std::format("{}.CandidateRayT()", rq_var); break;
            case 200: assignment_value = std::format("{}.CommittedRayT()", rq_var); break;
            default: throw std::runtime_error(std::format("Unknown rayQuery_StateScalar.f32 opcode {}", op_code));
          }
        } else if (functionName == "@dx.op.rayQuery_StateScalar.i1") {
          // %198 = call i1 @dx.op.rayQuery_StateScalar.i1(i32 192, i32 %177)  ; RayQuery_CommittedTriangleFrontFace(rayQueryHandle)
          auto [opNumber, rayQueryHandle] = StringViewSplit<2>(functionParamsString, param_regex, 2);
          int op_code = 0;
          FromStringView(opNumber, op_code);
          std::string rq_var = std::format("_{}", ParseVariable(rayQueryHandle).substr(1));
          assignment_type = "bool";
          switch (op_code) {
            case 191: assignment_value = std::format("{}.CandidateTriangleFrontFace()", rq_var); break;
            case 192: assignment_value = std::format("{}.CommittedTriangleFrontFace()", rq_var); break;
            default: throw std::runtime_error(std::format("Unknown rayQuery_StateScalar.i1 opcode {}", op_code));
          }
        } else if (functionName == "@dx.op.rayQuery_StateVector.f32") {
          // %168 = call float @dx.op.rayQuery_StateVector.f32(i32 193, i32 %154, i8 0)  ; RayQuery_CandidateTriangleBarycentrics(rayQueryHandle,component)
          auto [opNumber, rayQueryHandle, component] = StringViewSplit<3>(functionParamsString, param_regex, 2);
          int op_code = 0;
          FromStringView(opNumber, op_code);
          std::string rq_var = std::format("_{}", ParseVariable(rayQueryHandle).substr(1));
          int comp = 0;
          FromStringView(component, comp);
          std::string swizzle = (comp == 0) ? ".x" : ".y";
          assignment_type = "float";
          switch (op_code) {
            case 186: assignment_value = std::format("{}.WorldRayOrigin(){}", rq_var, swizzle); break;
            case 187: assignment_value = std::format("{}.WorldRayDirection(){}", rq_var, swizzle); break;
            case 193: assignment_value = std::format("{}.CandidateTriangleBarycentrics(){}", rq_var, swizzle); break;
            case 194: assignment_value = std::format("{}.CommittedTriangleBarycentrics(){}", rq_var, swizzle); break;
            default: throw std::runtime_error(std::format("Unknown rayQuery_StateVector.f32 opcode {}", op_code));
          }
        } else {
          std::cerr << line << "\n";
          std::cerr << "Function name: " << functionName << "\n";
          throw std::runtime_error("Unknown assign function name");
        }
      } else if (instruction == "extractvalue") {
        // extractvalue %dx.types.ResRet.f32 %448, 0
        // extractvalue %dx.types.CBufRet.i32 %19, 0
        auto [type, input, index] = StringViewMatch<3>(assignment, std::regex{R"(extractvalue (\S+) (\S+), (\S+))"});
        // Use raw variable number for binding lookups (not ParseVariable which may
        // return an inlined expression when flatten mode is active)
        auto raw_source_variable = std::string(input.substr(1));
        if (type == R"(%dx.types.CBufRet.f32)") {
          auto source_variable = raw_source_variable;
          if (preprocess_state.cbv_binding_variables.find(source_variable) == preprocess_state.cbv_binding_variables.end()) {
            // Dynamic cbuffer access — use swizzle on the float4 value
            int literal_index;
            FromStringView(index, literal_index);
            assignment_type = "float";
            assignment_value = std::format("{}.{}", ParseVariable(input), ParseIndex(index));
            is_identity = true;
          } else {
            const auto& [cbv_resource, cbv_variable_index, cbv_binding_name] = preprocess_state.cbv_binding_variables[source_variable];
            int literal_index;
            FromStringView(index, literal_index);

            // Check if this cbuffer uses dynamic access (float4 array only)
            auto cbv_range_idx = static_cast<uint32_t>(cbv_resource - preprocess_state.cbv_resources.data());
            if (preprocess_state.cbv_dynamic_access_indices.count(cbv_range_idx)) {
              // Use raw array access: cbuffer_raw[regIndex].component (uint4, reinterpret as float)
              assignment_value = std::format("asfloat({}_raw[{}u].{})", cbv_resource->name, cbv_variable_index, ParseIndex(index));
            } else {
              auto value_from_reflection = preprocess_state.ResourceVariableNameAtIndex(*cbv_resource, (cbv_variable_index * 16) + (literal_index * 4));

              if (value_from_reflection.empty()) {
                int real_index = cbv_variable_index;
                char sub_index = VECTOR_INDEXES[literal_index];
                std::string suffix = std::format("{:03}{}", real_index, sub_index);
                assignment_value = std::format("{}_{}", cbv_binding_name, suffix);
                cbv_resource->data_types[suffix] = "float";
              } else {
                // Use binding name for array cbuffers (includes array index), direct for regular
                if (cbv_resource->array_size.has_value()) {
                  assignment_value = std::format("{}.{}", cbv_binding_name, value_from_reflection);
                } else {
                  assignment_value = value_from_reflection;
                }
              }
            }

            assignment_type = "float";
            is_identity = true;
          }
          // decompiled = std::format("float _{} = {};", variable, value);
          // preprocess_state.variable_aliases.emplace(variable, value);
        } else if (type == R"(%dx.types.CBufRet.i32)") {
          auto source_variable = raw_source_variable;
          if (preprocess_state.cbv_binding_variables.find(source_variable) == preprocess_state.cbv_binding_variables.end()) {
            // Dynamic cbuffer access — use swizzle on the int4 value
            int literal_index;
            FromStringView(index, literal_index);
            assignment_type = "int";
            assignment_value = std::format("{}.{}", ParseVariable(input), ParseIndex(index));
            is_identity = true;
          } else {
            const auto& [cbv_resource, cbv_variable_index, cbv_binding_name] = preprocess_state.cbv_binding_variables[source_variable];
            int literal_index;
            FromStringView(index, literal_index);

            // Check if this cbuffer uses dynamic access (float4 array only)
            auto cbv_range_idx = static_cast<uint32_t>(cbv_resource - preprocess_state.cbv_resources.data());
            if (preprocess_state.cbv_dynamic_access_indices.count(cbv_range_idx)) {
              // Use raw array access: cbuffer_raw[regIndex].component
              assignment_value = std::format("asint({}_raw[{}u].{})", cbv_resource->name, cbv_variable_index, ParseIndex(index));
            } else {
              auto value_from_reflection = preprocess_state.ResourceVariableNameAtIndex(*cbv_resource, (cbv_variable_index * 16) + (literal_index * 4));

              if (value_from_reflection.empty()) {
                int real_index = cbv_variable_index;
                char sub_index = VECTOR_INDEXES[literal_index];
                std::string suffix = std::format("{:03}{}", real_index, sub_index);
                assignment_value = std::format("{}_{}", cbv_binding_name, suffix);
                cbv_resource->data_types[suffix] = "int";
              } else {
                if (cbv_resource->array_size.has_value()) {
                  assignment_value = std::format("{}.{}", cbv_binding_name, value_from_reflection);
                } else {
                  assignment_value = value_from_reflection;
                }
              }
            }

            assignment_type = "int";
            is_identity = true;
          }
          // preprocess_state.variable_aliases.emplace(variable, value);
        } else if (type == R"(%dx.types.CBufRet.f16.8)") {
          auto source_variable = raw_source_variable;
          if (preprocess_state.cbv_binding_variables.find(source_variable) == preprocess_state.cbv_binding_variables.end()) {
            throw std::runtime_error("Unsupported extractvalue from %dx.types.CBufRet.f16.8 without CBV binding");
          } else {
            const auto& [cbv_resource, cbv_variable_index, cbv_binding_name] = preprocess_state.cbv_binding_variables[source_variable];
            int literal_index;
            FromStringView(index, literal_index);

            auto cbv_range_idx = static_cast<uint32_t>(cbv_resource - preprocess_state.cbv_resources.data());
            if (preprocess_state.cbv_dynamic_access_indices.count(cbv_range_idx)) {
              // f16.8: indices 0-3 = low 16 bits of xyzw, 4-7 = high 16 bits
              int component = literal_index % 4;
              bool high_half = literal_index >= 4;
              if (high_half) {
                assignment_value = std::format("f16tof32({}_raw[{}u].{} >> 16u)", cbv_resource->name, cbv_variable_index, VECTOR_INDEXES[component]);
              } else {
                assignment_value = std::format("f16tof32({}_raw[{}u].{})", cbv_resource->name, cbv_variable_index, VECTOR_INDEXES[component]);
              }
            } else {
              auto value_from_reflection = preprocess_state.ResourceVariableNameAtIndex(*cbv_resource, (cbv_variable_index * 16) + (literal_index * 2));

              if (value_from_reflection.empty()) {
                int real_index = cbv_variable_index;
                char sub_index = VECTOR_INDEXES[literal_index % 4];
                std::string suffix = std::format("{:03}{}", real_index, sub_index);
                assignment_value = std::format("{}_{}", cbv_binding_name, suffix);
                cbv_resource->data_types[suffix] = "half";
              } else {
                if (cbv_resource->array_size.has_value()) {
                  assignment_value = std::format("{}.{}", cbv_binding_name, value_from_reflection);
                } else {
                  assignment_value = value_from_reflection;
                }
              }
            }
          }
          assignment_type = "half";
          is_identity = true;
        } else if (type == R"(%dx.types.ResRet.f32)") {
          auto source_variable = raw_source_variable;
          assignment_type = "float";
          if (auto pair = preprocess_state.srv_binding_load_variables.find(source_variable);
              pair != preprocess_state.srv_binding_load_variables.end()) {
            const auto& [srv_resource, srv_index, element_offset, alignment, srv_binding_name] = pair->second;
            if (alignment == "raw") {
              // Raw buffer load — srv_index has the full expression, element_offset has component count
              int comp_count = 0;
              FromStringView(element_offset, comp_count);
              int literal_index;
              FromStringView(index, literal_index);
              if (comp_count == 1) {
                assignment_value = srv_index;  // scalar, no component access
              } else {
                assignment_value = std::format("{}.{}", srv_index, ParseIndex(index));
              }
              is_identity = false;
              use_comment = false;
            } else {
              int literal_index;
              FromStringView(index, literal_index);
              int literal_element_offset;
              FromStringView(element_offset, literal_element_offset);
              int literal_alignment;
              FromStringView(alignment, literal_alignment);
              // Use binding name (includes array index for unbounded arrays) instead of resource name
              auto& access_name = srv_binding_name.empty() ? srv_resource->name : srv_binding_name;
              assignment_value = std::format("{}[{}]{}",
                                             access_name,
                                             ParseInt(srv_index),
                                             preprocess_state.ResourceVariableNameAtIndex(*srv_resource, (literal_element_offset) + (literal_index * 4)));
              is_identity = false;
              use_comment = false;
            }
          } else if (auto pair = preprocess_state.uav_binding_load_variables.find(source_variable);
                     pair != preprocess_state.uav_binding_load_variables.end()) {
            const auto& [uav_resource, srv_index, element_offset, alignment, uav_binding_name] = pair->second;
            if (alignment == "raw") {
              int comp_count = 0;
              FromStringView(element_offset, comp_count);
              int literal_index;
              FromStringView(index, literal_index);
              if (comp_count == 1) {
                assignment_value = srv_index;
              } else {
                assignment_value = std::format("{}.{}", srv_index, ParseIndex(index));
              }
              is_identity = false;
              use_comment = false;
            } else {
              int literal_index;
              FromStringView(index, literal_index);
              int literal_element_offset;
              FromStringView(element_offset, literal_element_offset);
              int literal_alignment;
              FromStringView(alignment, literal_alignment);
              assignment_value = std::format("{}[{}]{}",
                                             (uav_binding_name.empty() ? uav_resource->name : uav_binding_name),
                                             ParseInt(srv_index),
                                             preprocess_state.ResourceVariableNameAtIndex(*uav_resource, (literal_element_offset) + (literal_index * 4)));
              is_identity = false;
              use_comment = false;
            }
          } else {
            assignment_value = std::format("{}.{}", ParseVariable(input), ParseIndex(index));
            is_identity = true;
          }

          // decompiled = std::format("float _{} = {};", variable, value);
          // preprocess_state.variable_aliases.emplace(variable, value);
          // preprocess_state.variable_aliases.emplace(variable, value);
        } else if (type == R"(%dx.types.ResRet.f16)") {
          auto source_variable = raw_source_variable;
          assignment_type = "half";
          if (auto pair = preprocess_state.srv_binding_load_variables.find(source_variable);
              pair != preprocess_state.srv_binding_load_variables.end()) {
            const auto& [srv_resource, srv_index, element_offset, alignment, srv_binding_name] = pair->second;
            if (alignment == "raw") {
              int comp_count = 0;
              FromStringView(element_offset, comp_count);
              int literal_index;
              FromStringView(index, literal_index);
              if (comp_count == 1) {
                assignment_value = srv_index;
              } else {
                assignment_value = std::format("{}.{}", srv_index, ParseIndex(index));
              }
              is_identity = false;
              use_comment = false;
            } else {
              int literal_index;
              FromStringView(index, literal_index);
              int literal_element_offset;
              FromStringView(element_offset, literal_element_offset);
              int literal_alignment;
              FromStringView(alignment, literal_alignment);
              auto& access_name = srv_binding_name.empty() ? srv_resource->name : srv_binding_name;
              assignment_value = std::format("{}[{}]{}",
                                             access_name,
                                             ParseInt(srv_index),
                                             preprocess_state.ResourceVariableNameAtIndex(*srv_resource, (literal_element_offset) + (literal_index * 2)));
              is_identity = false;
              use_comment = false;
            }
          } else if (auto pair = preprocess_state.uav_binding_load_variables.find(source_variable);
                     pair != preprocess_state.uav_binding_load_variables.end()) {
            const auto& [uav_resource, srv_index, element_offset, alignment, uav_binding_name] = pair->second;
            if (alignment == "raw") {
              int comp_count = 0;
              FromStringView(element_offset, comp_count);
              int literal_index;
              FromStringView(index, literal_index);
              if (comp_count == 1) {
                assignment_value = srv_index;
              } else {
                assignment_value = std::format("{}.{}", srv_index, ParseIndex(index));
              }
              is_identity = false;
              use_comment = false;
            } else {
              int literal_index;
              FromStringView(index, literal_index);
              int literal_element_offset;
              FromStringView(element_offset, literal_element_offset);
              int literal_alignment;
              FromStringView(alignment, literal_alignment);
              assignment_value = std::format("{}[{}]{}",
                                             (uav_binding_name.empty() ? uav_resource->name : uav_binding_name),
                                             ParseInt(srv_index),
                                             preprocess_state.ResourceVariableNameAtIndex(*uav_resource, (literal_element_offset) + (literal_index * 2)));
              is_identity = false;
              use_comment = false;
            }
          } else {
            assignment_value = std::format("{}.{}", ParseVariable(input), ParseIndex(index));
            is_identity = true;
          }
        } else if (type == R"(%dx.types.ResRet.i32)") {
          auto source_variable = raw_source_variable;
          assignment_type = "int";
          if (auto pair = preprocess_state.srv_binding_load_variables.find(source_variable);
              pair != preprocess_state.srv_binding_load_variables.end()) {
            const auto& [srv_resource, srv_index, element_offset, alignment, srv_binding_name] = pair->second;
            if (alignment == "raw") {
              int comp_count = 0;
              FromStringView(element_offset, comp_count);
              int literal_index;
              FromStringView(index, literal_index);
              if (comp_count == 1) {
                assignment_value = srv_index;
              } else {
                assignment_value = std::format("{}.{}", srv_index, ParseIndex(index));
              }
              is_identity = false;
              use_comment = false;
            } else {
              int literal_index;
              FromStringView(index, literal_index);
              int literal_element_offset;
              FromStringView(element_offset, literal_element_offset);
              int literal_alignment;
              FromStringView(alignment, literal_alignment);
              auto& access_name = srv_binding_name.empty() ? srv_resource->name : srv_binding_name;
              assignment_value = std::format("{}[{}]{}",
                                             access_name,
                                             ParseInt(srv_index),
                                             preprocess_state.ResourceVariableNameAtIndex(*srv_resource, (literal_element_offset) + (literal_index * 4)));
              is_identity = false;
              use_comment = false;
            }
          } else if (auto pair = preprocess_state.uav_binding_load_variables.find(source_variable);
                     pair != preprocess_state.uav_binding_load_variables.end()) {
            const auto& [uav_resource, srv_index, element_offset, alignment, uav_binding_name] = pair->second;
            if (alignment == "raw") {
              int comp_count = 0;
              FromStringView(element_offset, comp_count);
              int literal_index;
              FromStringView(index, literal_index);
              if (comp_count == 1) {
                assignment_value = srv_index;
              } else {
                assignment_value = std::format("{}.{}", srv_index, ParseIndex(index));
              }
              is_identity = false;
              use_comment = false;
            } else {
              int literal_index;
              FromStringView(index, literal_index);
              int literal_element_offset;
              FromStringView(element_offset, literal_element_offset);
              int literal_alignment;
              FromStringView(alignment, literal_alignment);
              assignment_value = std::format("{}[{}]{}",
                                             (uav_binding_name.empty() ? uav_resource->name : uav_binding_name),
                                             ParseInt(srv_index),
                                             preprocess_state.ResourceVariableNameAtIndex(*uav_resource, (literal_element_offset) + (literal_index * 4)));
              is_identity = false;
              use_comment = false;
            }
          } else {
            assignment_value = std::format("{}.{}", ParseVariable(input), ParseIndex(index));
            is_identity = true;
          }
          // decompiled = std::format("int _{} = {};", variable, value);
          // preprocess_state.variable_aliases.emplace(variable, value);
        } else if (type == R"(%dx.types.ResRet.i16)") {
          auto source_variable = raw_source_variable;
          assignment_type = "int16_t";
          if (auto pair = preprocess_state.srv_binding_load_variables.find(source_variable);
              pair != preprocess_state.srv_binding_load_variables.end()) {
            const auto& [srv_resource, srv_index, element_offset, alignment, srv_binding_name] = pair->second;
            if (alignment == "raw") {
              int comp_count = 0;
              FromStringView(element_offset, comp_count);
              int literal_index;
              FromStringView(index, literal_index);
              if (comp_count == 1) {
                assignment_value = srv_index;
              } else {
                assignment_value = std::format("{}.{}", srv_index, ParseIndex(index));
              }
              is_identity = false;
              use_comment = false;
            } else {
              int literal_index;
              FromStringView(index, literal_index);
              int literal_element_offset;
              FromStringView(element_offset, literal_element_offset);
              int literal_alignment;
              FromStringView(alignment, literal_alignment);
              auto& access_name = srv_binding_name.empty() ? srv_resource->name : srv_binding_name;
              assignment_value = std::format("{}[{}]{}",
                                             access_name,
                                             ParseInt(srv_index),
                                             preprocess_state.ResourceVariableNameAtIndex(*srv_resource, (literal_element_offset) + (literal_index * 2)));
              is_identity = false;
              use_comment = false;
            }
          } else if (auto pair = preprocess_state.uav_binding_load_variables.find(source_variable);
                     pair != preprocess_state.uav_binding_load_variables.end()) {
            const auto& [uav_resource, srv_index, element_offset, alignment, uav_binding_name] = pair->second;
            if (alignment == "raw") {
              int comp_count = 0;
              FromStringView(element_offset, comp_count);
              int literal_index;
              FromStringView(index, literal_index);
              if (comp_count == 1) {
                assignment_value = srv_index;
              } else {
                assignment_value = std::format("{}.{}", srv_index, ParseIndex(index));
              }
              is_identity = false;
              use_comment = false;
            } else {
              int literal_index;
              FromStringView(index, literal_index);
              int literal_element_offset;
              FromStringView(element_offset, literal_element_offset);
              int literal_alignment;
              FromStringView(alignment, literal_alignment);
              assignment_value = std::format("{}[{}]{}",
                                             (uav_binding_name.empty() ? uav_resource->name : uav_binding_name),
                                             ParseInt(srv_index),
                                             preprocess_state.ResourceVariableNameAtIndex(*uav_resource, (literal_element_offset) + (literal_index * 2)));
              is_identity = false;
              use_comment = false;
            }
          } else {
            assignment_value = std::format("{}.{}", ParseVariable(input), ParseIndex(index));
            is_identity = true;
          }
        } else if (type == R"(%dx.types.Dimensions)") {
          assignment_type = "uint";
          assignment_value = std::format("{}.{}", ParseVariable(input), ParseIndex(index));
          is_identity = true;
        } else if (type == R"(%dx.types.fouri32)") {
          // extractvalue %dx.types.fouri32 %928, 0  — from WaveMatch
          assignment_type = "uint";
          assignment_value = std::format("{}.{}", ParseVariable(input), ParseIndex(index));
          is_identity = true;
        } else {
          std::cerr << type << "\n";
          throw std::runtime_error("Unknown extractvalue type");
        }
      } else if (instruction == "shl") {
        auto [no_unsigned_wrap, no_signed_wrap, variable_type, a, b] = StringViewMatch<5>(assignment, std::regex{R"(shl (nuw )?(nsw )?(\S+) (\S+), (\S+))"});
        assignment_type = no_signed_wrap.empty() ? ParseUnsignedType(variable_type) : ParseType(variable_type);
        assignment_value = std::format("{} << {}", ParseInt(a), ParseInt(b));
      } else if (instruction == "lshr") {
        // %132 = lshr i32 %131, 16
        // %17  = lshr i16 %15, 1
        // %168 = lshr exact i32 %167, 1
        auto [exact, no_unsigned_wrap, no_signed_wrap, variable_type, a, b] = StringViewMatch<6>(assignment, std::regex{R"(lshr (exact )?(nuw )?(nsw )?(\S+) (\S+), (\S+))"});
        // assignment_type = (no_signed_wrap.empty()) ? "uint" : "int";

        assignment_type = ParseType(variable_type);
        assignment_value = std::format("({}){} >> {}", ParseUnsignedType(variable_type), ParseWrapped(ParseUint(a)), ParseInt(b));
      } else if (instruction == "ashr") {
        // ashr: arithmetic right shift — result must be signed for sign-extension
        auto [exact, no_unsigned_wrap, no_signed_wrap, variable_type, a, b] = StringViewMatch<6>(assignment, std::regex{R"(ashr (exact )?(nuw )?(nsw )?(\S+) (\S+), (\S+))"});
        assignment_type = ParseType(variable_type);
        // Force signed type for ashr — HLSL >> on int is arithmetic shift
        if (assignment_type == "uint") {
          assignment_type = "int";
        } else if (assignment_type == "min16uint") {
          assignment_type = "min16int";
        } else if (assignment_type == "uint16_t") {
          assignment_type = "int16_t";
        }
        assignment_value = std::format("(int){} >> {}", ParseWrapped(ParseInt(a)), ParseInt(b));
      } else if (instruction == "xor") {
        // %173 = xor i1 %100, true
        // %347 = xor i32 %344, %339
        // %437 = xor i1 %123, true
        auto [xor_type, a, b] = StringViewMatch<3>(assignment, std::regex{R"(xor (\S+) (\S+), (\S+))"});
        assignment_type = ParseType(xor_type);
        if (xor_type == "i1" && b == "true") {
          assignment_value = std::format("!{}", ParseByType(a, xor_type));
        } else {
          assignment_value = std::format("{} ^ {}", ParseByType(a, xor_type), ParseByType(b, xor_type));
        }
      } else if (instruction == "mul") {
        auto [no_unsigned_wrap, no_signed_wrap, a, b] = StringViewMatch<4>(assignment, std::regex{R"(mul (nuw )?(nsw )?(?:i32) (\S+), (\S+))"});
        assignment_type = (no_signed_wrap.empty()) ? "uint" : "int";
        assignment_value = std::format("{} * {}", ParseInt(a), ParseInt(b));
      } else if (instruction == "fmul") {
        auto [value_type, a, b] = StringViewMatch<3>(assignment, std::regex{R"(fmul (?:fast )?(\S+) (\S+), (\S+))"});
        assignment_type = ParseType(value_type);
        assignment_value = std::format("{} * {}", ParseByType(a, value_type), ParseByType(b, value_type));
      } else if (instruction == "fdiv") {
        auto [value_type, a, b] = StringViewMatch<3>(assignment, std::regex{R"(fdiv (?:fast )?(\S+) (\S+), (\S+))"});
        assignment_type = ParseType(value_type);
        assignment_value = std::format("{} / {}", ParseByType(a, value_type), ParseByType(b, value_type));
      } else if (instruction == "fadd") {
        auto [value_type, a, b] = StringViewMatch<3>(assignment, std::regex{R"(fadd (?:fast )?(\S+) (\S+), (\S+))"});
        assignment_type = ParseType(value_type);
        assignment_value = std::format("{} + {}", ParseByType(a, value_type), ParseByType(b, value_type));
      } else if (instruction == "frem") {
        // frem fast float %25, 2.000000e+00
        auto [value_type, a, b] = StringViewMatch<3>(assignment, std::regex{R"(frem (?:fast )?(\S+) (\S+), (\S+))"});
        assignment_type = ParseType(value_type);
        assignment_value = std::format("fmod({}, {})", ParseByType(a, value_type), ParseByType(b, value_type));
      } else if (instruction == "fsub") {
        // fsub fast half 0xH3C00, %42
        auto [value_type, a, b] = StringViewMatch<3>(assignment, std::regex{R"(fsub (?:fast )?(\S+) (\S+), (\S+))"});
        assignment_type = ParseType(value_type);
        assignment_value = std::format("{} - {}", ParseByType(a, value_type), ParseByType(b, value_type));
      } else if (instruction == "fcmp") {
        // %39 = fcmp fast ogt float %37, 0.000000e+00
        auto [fast, op, value_type, a, b] = StringViewMatch<5>(assignment, std::regex{R"(fcmp (fast )?(\S+) (\S+) (\S+), (\S+))"});

        bool is_fast = !fast.empty();
        assignment_type = "bool";

        auto a_parsed = ParseByType(a, value_type);
        auto b_parsed = ParseByType(b, value_type);
        if (op == "false") {
          assignment_value = "false";
        } else if (op == "oeq") {
          assignment_value = std::format("({} == {})", a_parsed, b_parsed);
        } else if (op == "ogt") {
          assignment_value = std::format("({} > {})", a_parsed, b_parsed);
        } else if (op == "oge") {
          assignment_value = std::format("({} >= {})", a_parsed, b_parsed);
        } else if (op == "olt") {
          assignment_value = std::format("({} < {})", a_parsed, b_parsed);
        } else if (op == "ole") {
          assignment_value = std::format("({} <= {})", a_parsed, b_parsed);
        } else if (op == "one") {
          assignment_value = std::format("({} != {})", a_parsed, b_parsed);
        } else if (op == "ord") {
          assignment_value = std::format("(!isnan{} && !isnan{})", ParseWrapped(a_parsed), ParseWrapped(b_parsed));
        } else if (op == "ueq") {
          // With fast: unordered == ordered, emit direct comparison
          if (is_fast) {
            assignment_value = std::format("({} == {})", a_parsed, b_parsed);
          } else {
            assignment_value = std::format("!({} != {})", a_parsed, b_parsed);
          }
        } else if (op == "ugt") {
          if (is_fast) {
            assignment_value = std::format("({} > {})", a_parsed, b_parsed);
          } else {
            assignment_value = std::format("!({} <= {})", a_parsed, b_parsed);
          }
        } else if (op == "uge") {
          if (is_fast) {
            assignment_value = std::format("({} >= {})", a_parsed, b_parsed);
          } else {
            assignment_value = std::format("!({} < {})", a_parsed, b_parsed);
          }
        } else if (op == "ult") {
          if (is_fast) {
            assignment_value = std::format("({} < {})", a_parsed, b_parsed);
          } else {
            assignment_value = std::format("!({} >= {})", a_parsed, b_parsed);
          }
        } else if (op == "ule") {
          if (is_fast) {
            assignment_value = std::format("({} <= {})", a_parsed, b_parsed);
          } else {
            assignment_value = std::format("!({} > {})", a_parsed, b_parsed);
          }
        } else if (op == "une") {
          if (is_fast) {
            assignment_value = std::format("({} != {})", a_parsed, b_parsed);
          } else {
            assignment_value = std::format("!({} == {})", a_parsed, b_parsed);
          }
        } else if (op == "uno") {
          assignment_value = std::format("(isnan{} || isnan{})", ParseWrapped(a_parsed), ParseWrapped(b_parsed));
        } else {
          std::cerr << op << "\n";
          throw std::runtime_error("Could not parse code assignment operator");
        }

      } else if (instruction == "icmp") {
        // %44 = icmp eq i32 %43, 0
        auto [op, type, a, b] = StringViewMatch<4>(assignment, std::regex{R"(icmp (\S+) (\S+) (\S+), (\S+))"});
        std::string cast;

        if (op.starts_with("u")) {
          cast = "(uint)";
        } else if (op.starts_with("s")) {
          cast = "(int)";
        }

        // Convert negative constants to unsigned equivalents for unsigned comparisons
        auto parse_icmp_operand = [&](std::string_view operand) -> std::string {
          if (op.starts_with("u") && !operand.empty() && operand[0] == '-') {
            return ParseUnsignedConstant(operand, type);
          }
          return ParseByType(operand, type);
        };

        assignment_type = "bool";
        if (op == "false") {
          assignment_value = "false";
        } else if (op == "eq") {
          assignment_value = std::format("({} == {})", parse_icmp_operand(a), parse_icmp_operand(b));
        } else if (op == "ne") {
          assignment_value = std::format("({} != {})", parse_icmp_operand(a), parse_icmp_operand(b));
        } else if (op == "ugt" || op == "sgt") {
          assignment_value = std::format("({}{} > {}{})", cast, parse_icmp_operand(a), cast, parse_icmp_operand(b));
        } else if (op == "uge" || op == "sge") {
          assignment_value = std::format("({}{} >= {}{})", cast, parse_icmp_operand(a), cast, parse_icmp_operand(b));
        } else if (op == "ult" || op == "slt") {
          assignment_value = std::format("({}{} < {}{})", cast, parse_icmp_operand(a), cast, parse_icmp_operand(b));
        } else if (op == "ule" || op == "sle") {
          assignment_value = std::format("({}{} <= {}{})", cast, parse_icmp_operand(a), cast, parse_icmp_operand(b));
        } else {
          std::cerr << op << "\n";
          throw std::runtime_error("Could not parse code assignment operator");
        }
      } else if (instruction == "add") {
        // add nsw i32 %1678, 1
        auto [no_unsigned_wrap, no_signed_wrap, a, b] = StringViewMatch<4>(assignment, std::regex{R"(add (nuw )?(nsw )?(?:\S+) (\S+), (\S+))"});
        assignment_type = (no_signed_wrap.empty()) ? "uint" : "int";
        assignment_value = std::format("{} + {}", ParseByType(a, assignment_type), ParseByType(b, assignment_type));
      } else if (instruction == "sub") {
        // sub nsw i32 %43, %45
        // sub nuw nsw i32 3, %885
        auto [no_unsigned_wrap, no_signed_wrap, a, b] = StringViewMatch<4>(assignment, std::regex{R"(sub (nuw )?(nsw )?(?:\S+) (\S+), (\S+))"});
        assignment_type = (no_signed_wrap.empty()) ? "uint" : "int";
        assignment_value = std::format("{} - {}", ParseByType(a, assignment_type), ParseByType(b, assignment_type));
      } else if (instruction == "sext") {
        // %43 = sext i1 %324 to i32
        auto [from_type, a, to_type] = StringViewMatch<3>(assignment, std::regex{R"(sext (?:fast )?(\S+) (\S+) to (\S+))"});
        assignment_type = ParseType(to_type);
        if (from_type == "i1") {
          // Sign-extending i1: true → -1 (all bits set), false → 0
          // int((bool)x) gives 1 for true, so negate it.
          assignment_value = std::format("-{}(({}){})", assignment_type, ParseUnsignedType(from_type), ParseInt(a));
        } else {
          assignment_value = std::format("{}(({}){})", assignment_type, ParseUnsignedType(from_type), ParseInt(a));
        }
      } else if (instruction == "zext") {
        // %43 = zext i1 %39 to i32
        auto [from_type, a, to_type] = StringViewMatch<3>(assignment, std::regex{R"(zext (?:fast )?(\S+) (\S+) to (\S+))"});
        assignment_type = ParseType(to_type);
        if (from_type == "i16") {
          assignment_value = std::format("({})(min16uint){}", assignment_type, ParseWrapped(ParseInt(a)));
        } else {
          assignment_value = std::format("({})(uint){}", assignment_type, ParseWrapped(ParseInt(a)));
        }
      } else if (instruction == "sitofp") {
        // sitofp i32 %47 to float
        auto [a] = StringViewMatch<1>(assignment, std::regex{R"(sitofp (?:\S+) (\S+) to (?:\S+))"});
        assignment_type = "float";
        assignment_value = std::format("float((int){})", ParseWrapped(ParseInt(a)));
      } else if (instruction == "uitofp") {
        // uitofp i32 %158 to float
        // uitofp i16 %32 to float
        auto [from_type, a, to_type] = StringViewMatch<3>(assignment, std::regex{R"(uitofp (\S+) (\S+) to (\S+))"});
        assignment_type = ParseType(to_type);
        assignment_value = std::format("{}(({}){})", assignment_type, ParseUnsignedType(from_type), ParseUint(a));
      } else if (instruction == "fptoui") {
        auto [a] = StringViewMatch<1>(assignment, std::regex{R"(fptoui (?:\S+) (\S+) to (?:\S+))"});
        assignment_type = "uint";
        assignment_value = std::format("uint{}", ParseWrapped(ParseFloat(a)));
      } else if (instruction == "fptosi") {
        auto [a] = StringViewMatch<1>(assignment, std::regex{R"(fptosi (?:\S+) (\S+) to (?:\S+))"});
        assignment_type = "int";
        assignment_value = std::format("int{}", ParseWrapped(ParseFloat(a)));
      } else if (instruction == "and") {
        auto [type, a, b] = StringViewMatch<3>(assignment, std::regex{R"(and (\S+) (\S+), (\S+))"});
        if (type == "i1") {
          assignment_type = "bool";
          // Use ParseBool (not ParseInt) so operands stay in the bool domain.
          // Otherwise each bool alias gets wrapped in (int)(...) which exposes
          // integer-level structure to DXC's InstCombine. That can fuse a bool
          // flag (e.g. derived from `X & (1<<N)`) with its underlying bit
          // extraction (`lshr X, N`), letting DXC CSE independent gated
          // branches that share such a flag into one integer expression and
          // eliminate per-branch floating-point work. Keeping the operands as
          // pure bool expressions preserves the original `and i1 / br i1`
          // structure on recompilation.
          assignment_value = std::format("{} && {}", ParseBool(a), ParseBool(b));
        } else {
          assignment_type = ParseType(type);
          assignment_value = std::format("{} & {}", ParseInt(a), ParseInt(b));
        }
      } else if (instruction == "urem") {
        //   %100 = urem i32 %99, 5
        auto [type, a, b] = StringViewMatch<3>(assignment, std::regex{R"(urem (\S+) (\S+), (\S+))"});
        assignment_type = "uint";
        assignment_value = std::format("{} % {}", ParseInt(a), ParseInt(b));
      } else if (instruction == "srem") {
        //   %100 = urem i32 %99, 5
        auto [type, a, b] = StringViewMatch<3>(assignment, std::regex{R"(srem (\S+) (\S+), (\S+))"});
        assignment_type = "int";
        assignment_value = std::format("{} % {}", ParseInt(a), ParseInt(b));
      } else if (instruction == "udiv") {
        // %16 = udiv i32 %14, 38
        auto [type, a, b] = StringViewMatch<3>(assignment, std::regex{R"(udiv (\S+) (\S+), (\S+))"});
        assignment_type = "uint";
        assignment_value = std::format("{} / {}", ParseUint(a), ParseUint(b));
      } else if (instruction == "sdiv") {
        // %215 = sdiv i32 %193, 2
        auto [type, a, b] = StringViewMatch<3>(assignment, std::regex{R"(sdiv (\S+) (\S+), (\S+))"});
        assignment_type = "int";
        assignment_value = std::format("{} / {}", ParseInt(a), ParseInt(b));
      } else if (instruction == "or") {
        auto [type, a, b] = StringViewMatch<3>(assignment, std::regex{R"(or (\S+) (\S+), (\S+))"});
        if (type == "i1") {
          assignment_type = "bool";
          // See `and i1` above for rationale: stay in the bool domain so DXC
          // does not fuse the bool flag with its underlying bit extraction.
          assignment_value = std::format("{} || {}", ParseBool(a), ParseBool(b));
        } else {
          assignment_type = ParseType(type);
          assignment_value = std::format("{} | {}", ParseInt(a), ParseInt(b));
        }
      } else if (instruction == "alloca") {
        // alloca [6 x float], align 4
        // alloca i32, align 4
        static auto alloca_array_regex = std::regex{R"(alloca \[(\S+) x (\S+)\], align (\S+))"};
        static auto alloca_scalar_regex = std::regex{R"(alloca (\S+), align (\S+))"};
        auto [size, type, align] = StringViewMatch<3>(assignment, alloca_array_regex);
        if (!size.empty()) {
          decompiled = std::format("{} _{}[{}];", ParseType(type), variable, ParseInt(size));
        } else {
          auto [scalar_type, scalar_align] = StringViewMatch<2>(assignment, alloca_scalar_regex);
          if (!scalar_type.empty()) {
            // Scalar alloca: declare a local variable and register it in stored_pointers
            // so that subsequent store/load through this pointer resolve correctly.
            // Note: `variable` is a string_view into persistent line data, safe as map key.
            decompiled = std::format("{} _{};", ParseType(scalar_type), variable);
            stored_pointers[variable] = std::format("_{}", variable);
          }
        }
      } else if (instruction == "select") {
        // select i1 %26, float 1.000000e+00, float 0x3FFB47E420000000
        // %88 = select i1 %84, i1 %86, i1 %87
        // select i1 %44, half %45, half %42
        auto [condition, type_a, value_a, type_b, value_b] = StringViewMatch<5>(assignment, std::regex{R"(select i1 (\S+), (\S+) (\S+), (\S+) (\S+))"});
        if (type_a == "float" && type_b == "float") {
          assignment_type = "float";
          assignment_value = std::format("select({}, {}, {})", ParseBool(condition), ParseFloat(value_a), ParseFloat(value_b));
        } else if (type_a == "int" && type_b == "int") {
          assignment_type = "int";
          assignment_value = std::format("select({}, {}, {})", ParseBool(condition), ParseInt(value_a), ParseInt(value_b));
        } else if (type_a == "i32" && type_b == "i32") {
          assignment_type = "int";
          assignment_value = std::format("select({}, {}, {})", ParseBool(condition), ParseInt(value_a), ParseInt(value_b));
        } else if (type_a == "i1" && type_b == "i1") {
          assignment_type = "bool";
          assignment_value = std::format("select({}, {}, {})", ParseBool(condition), ParseBool(value_a), ParseBool(value_b));
        } else if (type_a == "half" && type_b == "half") {
          assignment_type = "half";
          assignment_value = std::format("select({}, {}, {})", ParseBool(condition), ParseFloat(value_a), ParseFloat(value_b));
        } else if (type_a == "i64" && type_b == "i64") {
          assignment_type = "int64_t";
          assignment_value = std::format("select({}, {}, {})", ParseBool(condition), ParseInt64(value_a), ParseInt64(value_b));
        } else if (type_a == "i16" && type_b == "i16") {
          assignment_type = "int16_t";
          assignment_value = std::format("select({}, {}, {})", ParseBool(condition), ParseInt(value_a), ParseInt(value_b));
        } else {
          std::cerr << line << "\n";
          throw std::runtime_error("Unrecognized code assignment");
        }
      } else if (instruction == "phi") {
        // phi float [ 0x3FF61108E0000000, %0 ], [ 0x3FF069AC80000000, %21 ], [ 0x3FE6412500000000, %23 ], [ %27, %25 ]
        auto [type, arguments] = StringViewMatch<2>(assignment, std::regex{R"(phi (\S+) (.+))"});
        // Declare variable
        bool declared = false;
        auto pairs = StringViewSplitAll(arguments, std::regex{R"((\[ (\S+), %(\S+) \]),?)"}, {2, 3});

        // Find the first non-undef value to use as a substitute for undef entries.
        // LLVM undef means "don't care" — the path is unreachable or the value unused.
        // We skip emitting assignments for undef phi entries entirely, leaving the variable
        // uninitialized on that path. This lets DXC optimize the same way LLVM does —
        // it can assume any value for the uninitialized variable and eliminate dead paths.

        for (const auto& [value, predecessor] : pairs) {
          if (value == "undef") {
            // Don't emit an assignment — leave variable uninitialized on this path
            int predecessor_int;
            FromStringView(predecessor, predecessor_int);
            // Still need to parse to register the predecessor block, but skip the phi_line
            continue;
          }
          ParseByType(value, type);
          int predecessor_int;
          FromStringView(predecessor, predecessor_int);

          this->code_blocks[predecessor_int].phi_lines.push_back({
              .variable = std::string(variable),
              .type = std::string(type),
              .value = std::string(value),
              .predecessor = predecessor_int,
              .code_function = this->current_code_block_number,
              .is_assign = true,
          });
        }

        this->code_blocks[0].phi_lines.push_back({
            .variable = std::string(variable),
            .type = std::string(type),
            .value = "",
            .predecessor = 0,
            .code_function = this->current_code_block_number,
            .is_assign = false,
        });

        // this->code_blocks[0].phi_lines.push_back(
        //     std::format("{} _{};", ParseType(type), variable));
        phi_variables.emplace(std::string(variable));

      } else if (instruction == "load") {
        // load float, float* %1681, align 4, !tbaa !26
        // load float, float addrspace(3)* %64, align 4, !tbaa !27
        // load i32, i32* %1376, align 4, !tbaa !60
        // load i32, i32 addrspace(3)* @"\01?NumSphericalHarmonics@@3IA", align 4
        // load float, float addrspace(3)* getelementptr inbounds ([1024 x float], [1024 x float] addrspace(3)* @"...", i32 0, i32 0), align 4
        static auto load_local_regex = std::regex{R"(load (\S+), [^*]+\* %(\S+),.*)"};
        static auto load_global_regex = std::regex{R"(load (\S+), [^*]+\* (@[^,]+),.*)"};
        static auto load_inline_gep_regex = std::regex{R"(load (\S+), [^*]+\* getelementptr inbounds \([^,]+, [^*]+\* (@[^,]+), i32 \S+, i32 (\S+)\)(?:,.*)?)"};
        auto [load_type, source] = StringViewMatch<2>(assignment, load_local_regex);
        if (source.empty()) {
          auto [load_type_gep, gep_global, gep_index] = StringViewMatch<3>(assignment, load_inline_gep_regex);
          if (!gep_global.empty()) {
            // Inline GEP load from shared memory: array[index]
            if (load_type_gep == "i32") {
              assignment_type = "int";
            } else {
              assignment_type = "float";
            }
            if (auto pair = preprocess_state.global_variables.find(std::string(gep_global));
                pair != preprocess_state.global_variables.end()) {
              assignment_value = std::format("{}[{}]", pair->second, gep_index);
            } else {
              assignment_value = std::format("/* {} */[{}]", gep_global, gep_index);
            }
            is_identity = true;
          } else {
            auto [load_type_g, global_source] = StringViewMatch<2>(assignment, load_global_regex);
            if (!global_source.empty()) {
              if (load_type_g == "i32") {
                assignment_type = "int";
              } else {
                assignment_type = "float";
              }
              if (auto pair = preprocess_state.global_variables.find(std::string(global_source));
                  pair != preprocess_state.global_variables.end()) {
                assignment_value = pair->second;
              } else {
                assignment_value = std::format("/* {} */", global_source);
              }
              is_identity = true;
            }
          }
        } else {
          if (load_type == "i32") {
            assignment_type = "int";
          } else if (load_type == "i16") {
            assignment_type = "int";
          } else {
            assignment_type = "float";
          }
          assignment_value = stored_pointers[source];
        }
      } else if (instruction == "bitcast") {
        // %63 = bitcast i32 %62 to float
        // %1323 = bitcast i32* %1322 to float*
        // %193 = bitcast i32 addrspace(3)* %192 to float addrspace(3)*
        static auto bitcast_regex = std::regex{R"(bitcast (\S+(?:\s+addrspace\(\d+\))?\*?) (\S+) to (\S+(?:\s+addrspace\(\d+\))?\*?))"};
        auto [source_type, source_variable, dest_type] = StringViewMatch<3>(assignment, bitcast_regex);
        if (source_type.empty()) {
          // decompiled = std::format("// {}", line);
        } else if (dest_type.find('*') != std::string_view::npos) {
          // Pointer bitcast — propagate the stored pointer alias.
          // Preserve the ORIGINAL element type of the source pointer so
          // that subsequent stores/loads through this alias know when the
          // value type differs from the actual HLSL array element type
          // (e.g. storing a float through an i32* that was bitcast to
          // float* — must emit asuint() to preserve the bits).
          auto source_ref = std::string(source_variable.substr(1));
          if (stored_pointers.count(source_ref)) {
            stored_pointers[variable] = stored_pointers[source_ref];
          } else {
            stored_pointers[variable] = std::format("_{}", source_ref);
          }
          auto it = stored_pointer_element_types.find(source_ref);
          if (it != stored_pointer_element_types.end()) {
            stored_pointer_element_types[std::string(variable)] = it->second;
          }
          IncrementVariableCounter(variable);
        } else {
          assignment_type = ParseType(dest_type);
          assignment_value = std::format("{}({})", ParseBitcast(dest_type), ParseVariable(source_variable, ParseType(source_type)));
          // IncrementVariableCounter(source_variable);
        }
      } else if (instruction == "trunc") {
        // %12 = trunc i32 %10 to i16
        auto [source_type, source_variable, dest_type] = StringViewMatch<3>(assignment, std::regex{R"(trunc (\S+) (\S+) to (\S+))"});
        if (source_type.empty()) {
          // decompiled = std::format("// {}", line);
        } else {
          assignment_type = ParseType(dest_type);
          assignment_value = std::format("{}{}", ParseTrunc(dest_type), ParseWrapped(ParseVariable(source_variable, ParseType(source_type))));
          // IncrementVariableCounter(source_variable);
        }
      } else if (instruction == "fptrunc") {
        // %42 = fptrunc float %40 to half
        auto [source_type, source_variable, dest_type] = StringViewMatch<3>(assignment, std::regex{R"(fptrunc (\S+) (\S+) to (\S+))"});
        if (source_type.empty()) {
          // decompiled = std::format("// {}", line);
        } else {
          assignment_type = ParseType(dest_type);
          assignment_value = std::format("{}{}", ParseTrunc(dest_type), ParseWrapped(ParseVariable(source_variable, ParseType(source_type))));
          // IncrementVariableCounter(source_variable);
        }
      } else if (instruction == "fpext") {
        // fpext half %46 to float
        auto [source_type, source_variable, dest_type] = StringViewMatch<3>(assignment, std::regex{R"(fpext (\S+) (\S+) to (\S+))"});
        if (source_type.empty()) {
          // decompiled = std::format("// {}", line);
        } else {
          assignment_type = ParseType(dest_type);
          assignment_value = std::format("{}{}", ParseType(dest_type), ParseWrapped(ParseVariable(source_variable, ParseType(source_type))));
          // IncrementVariableCounter(source_variable);
        }
      } else if (instruction == "getelementptr") {
        auto [array_size_str, element_type, source, index] = StringViewMatch<4>(
            assignment,
            std::regex{R"(getelementptr (?:inbounds )?\[(\d+) x ([^\]]+)\], \[[^\]]+\](?: addrspace\(\d+\))?\* (\S+), i32 \S+, i32 (\S+).*)"});
        // %1369 = getelementptr inbounds [6 x float], [6 x float]* %10, i32 0, i32 0
        // %58 = getelementptr [128 x float], [128 x float] addrspace(3)* @"\01?g_ToneMapRadianceSamples@@3PAMA", i32 0, i32 %57
        int array_size = 0;
        if (!array_size_str.empty()) {
          FromStringView(array_size_str, array_size);
        }
        
        std::string parsed_source;
        if (source.starts_with('%')) {
          parsed_source = std::format("_{}", source.substr(1));
        } else if (source.starts_with('@')) {
          if (auto pair = preprocess_state.global_variables.find(std::string(source));
              pair != preprocess_state.global_variables.end()) {
            parsed_source = pair->second;
          } else {
            // Try stripping .N.N... suffix (sub-element access into global struct)
            // The suffix is inside the quotes: @"\01?name@@...A.0.0" -> @"\01?name@@...A"
            auto source_str = std::string(source);
            bool found_base = false;
            // Try progressively stripping .N suffixes from inside the closing quote
            auto last_quote = source_str.rfind('"');
            if (last_quote != std::string::npos && last_quote > 0) {
              auto inner = source_str.substr(0, last_quote);  // everything before closing "
              while (!found_base) {
                auto last_dot = inner.rfind('.');
                if (last_dot == std::string::npos) break;
                // Check if everything after the dot is digits
                auto suffix = inner.substr(last_dot + 1);
                bool all_digits = !suffix.empty() && std::ranges::all_of(suffix, [](char c) { return c >= '0' && c <= '9'; });
                if (!all_digits) break;
                inner = inner.substr(0, last_dot);
                auto candidate = inner + "\"";
                if (auto pair2 = preprocess_state.global_variables.find(candidate);
                    pair2 != preprocess_state.global_variables.end()) {
                  parsed_source = pair2->second;
                  found_base = true;
                }
              }
            }
            if (!found_base) {
              throw std::invalid_argument(std::format("Unknown global variable: {}", source));
            }
          }
        } else {
          throw std::invalid_argument("Unknown pointer source");
        }
        // Clamp dynamic indices to array bounds to prevent OOB access.
        // The original DXIL guarantees in-bounds via control flow, but the
        // decompiler's opaque condition mechanism can't preserve that guarantee
        // for all possible values of __opaque_false. DXC's validator checks
        // all possible paths including the opaque-flipped ones.
        auto parsed_index = ParseInt(index);
        bool is_dynamic_index = index.starts_with('%');
        std::string clamped_index;
        if (is_dynamic_index && array_size > 0) {
          clamped_index = std::format("min((uint)({}), {}u)", parsed_index, array_size - 1);
        } else {
          clamped_index = parsed_index;
        }
        const auto pointer_value = std::format("{}[{}]", parsed_source, clamped_index);
        stored_pointers[variable] = pointer_value;
        if (!element_type.empty()) {
          stored_pointer_element_types[std::string(variable)] = std::string(element_type);
        }
        IncrementVariableCounter(variable);
      } else if (instruction == "atomicrmw") {
        // %259 = atomicrmw add i32 addrspace(3)* @"\01?NumSphericalHarmonics@@3IA", i32 1 seq_cst
        // %X   = atomicrmw add i32 addrspace(3)* getelementptr inbounds ([N x i32], [N x i32] addrspace(3)* @"name", i32 0, i32 INDEX), i32 %val seq_cst
        std::string op_str;
        std::string parsed_pointer;
        std::string operand_str_raw;
        auto assignment_str = std::string(assignment);
        bool is_inline_gep = assignment_str.find("getelementptr inbounds") != std::string::npos
                              && assignment_str.find("addrspace(") != std::string::npos;
        if (is_inline_gep) {
          // Parse: atomicrmw OP TYPE addrspace(N)* getelementptr inbounds (..., addrspace(N)* @"NAME", i32 0, i32 INDEX), TYPE OPERAND ...
          auto rmw_pos = assignment_str.find("atomicrmw ") + 10;
          auto op_end = assignment_str.find(' ', rmw_pos);
          op_str = assignment_str.substr(rmw_pos, op_end - rmw_pos);
          auto at_pos = assignment_str.find("@\"");
          auto close_quote = (at_pos != std::string::npos) ? assignment_str.find("\"", at_pos + 2) : std::string::npos;
          // Find the GEP closing ")," — the last "i32 N)" before the comma
          auto gep_close = (close_quote != std::string::npos) ? assignment_str.find(")", close_quote) : std::string::npos;
          // Find the index: last "i32 N" before gep_close
          auto last_i32 = (gep_close != std::string::npos) ? assignment_str.rfind("i32 ", gep_close) : std::string::npos;
          // Find the operand: after "), TYPE "
          auto post_gep = (gep_close != std::string::npos) ? assignment_str.find(", ", gep_close) : std::string::npos;
          if (!op_str.empty() && at_pos != std::string::npos && close_quote != std::string::npos
              && last_i32 != std::string::npos && post_gep != std::string::npos
              && gep_close > last_i32 + 4) {
            auto gep_global = assignment_str.substr(at_pos, close_quote - at_pos + 1);
            auto index_str = assignment_str.substr(last_i32 + 4, gep_close - (last_i32 + 4));
            // Operand is after "), TYPE " — skip the type word
            auto operand_start = assignment_str.find(' ', post_gep + 2) + 1;
            auto operand_end = assignment_str.find(' ', operand_start);
            if (operand_end == std::string::npos) operand_end = assignment_str.size();
            operand_str_raw = assignment_str.substr(operand_start, operand_end - operand_start);
            
            std::string base_pointer;
            if (auto pair = preprocess_state.global_variables.find(gep_global);
                pair != preprocess_state.global_variables.end()) {
              base_pointer = pair->second;
            } else {
              base_pointer = std::format("/* {} */", gep_global);
            }
            int index = 0;
            FromStringView(index_str, index);
            parsed_pointer = std::format("{}[{}]", base_pointer, index);
          }
        }
        
        if (parsed_pointer.empty()) {
          // Fall back to simple pointer regex
          static auto atomicrmw_regex = std::regex{R"(atomicrmw (\S+) \S+(?: addrspace\(\d+\))?\* (\S+), \S+ (\S+).*)"};
          auto [op, pointer, operand] = StringViewMatch<3>(assignment, atomicrmw_regex);
          if (op.empty()) {
            throw std::runtime_error(std::format("Could not parse atomicrmw: {}", assignment));
          }
          op_str = std::string(op);
          operand_str_raw = std::string(operand);
          if (pointer.starts_with('%')) {
            parsed_pointer = stored_pointers.count(pointer.substr(1)) ? stored_pointers[pointer.substr(1)] : std::format("_{}", pointer.substr(1));
          } else if (pointer.starts_with('@')) {
            if (auto pair = preprocess_state.global_variables.find(std::string(pointer));
                pair != preprocess_state.global_variables.end()) {
              parsed_pointer = pair->second;
            } else {
              parsed_pointer = std::format("/* {} */", pointer);
            }
          } else {
            parsed_pointer = std::string(pointer);
          }
        }
        
        std::string atomic_func;
        if (op_str == "add") atomic_func = "InterlockedAdd";
        else if (op_str == "sub") atomic_func = "InterlockedAdd";  // sub with negated value
        else if (op_str == "and") atomic_func = "InterlockedAnd";
        else if (op_str == "or") atomic_func = "InterlockedOr";
        else if (op_str == "xor") atomic_func = "InterlockedXor";
        else if (op_str == "max") atomic_func = "InterlockedMax";
        else if (op_str == "min") atomic_func = "InterlockedMin";
        else if (op_str == "umax") atomic_func = "InterlockedMax";
        else if (op_str == "umin") atomic_func = "InterlockedMin";
        else if (op_str == "xchg") atomic_func = "InterlockedExchange";
        else atomic_func = std::format("InterlockedOp/* {} */", op_str);

        assignment_type = "uint";
        std::string operand_str = ParseInt(std::string_view(operand_str_raw));
        if (op_str == "sub") {
          operand_str = std::format("-{}", operand_str);
        }
        assignment_value = std::format("{}({}, {})", atomic_func, parsed_pointer, operand_str);
        is_identity = false;
        use_comment = false;
        decompiled = std::format("uint _{}; {}({}, {}, _{});", variable, atomic_func, parsed_pointer, operand_str, variable);
      } else {
        std::cerr << line << "\n";
        throw std::runtime_error("Unrecognized code assignment");
      }

      if (decompiled.empty() && !assignment_value.empty()) {
        if (is_identity) {
          // Refuse to inline wave intrinsics. Wave ops (WaveActiveCountBits,
          // WavePrefixCountBits, WaveReadLaneFirst, WaveIsFirstLane, etc.) rely
          // on the active-lane mask at the point of call. If a wave op is
          // inlined into a use-site that lives under a deeper branch (e.g.,
          // inside `if (WaveIsFirstLane())`), the active mask differs from
          // where the original DXIL called it, producing wrong results.
          // Keep the assignment as a named local so the wave op executes at
          // its original control-flow position.
          static const auto IS_WAVE_INTRINSIC = std::regex(
              R"(\bWave(Active|Prefix|Read|Is|Match|MultiPrefix|All|Any)\w*\s*\()");
          if (std::regex_search(assignment_value, IS_WAVE_INTRINSIC)) {
            use_comment = false;
            decompiled = std::format("{} _{} = {};", assignment_type, variable, assignment_value);
          } else {
            variable_aliases.emplace(variable, std::pair<std::string, std::string>(assignment_type, OptimizeString(assignment_value)));
            use_comment = true;
          }
        }
        if (use_comment) {
#if DECOMPILER_DXC_DEBUG >= 1
          decompiled = std::format("// {} _{} = {};", assignment_type, variable, assignment_value);
#endif
        } else if (decompiled.empty()) {
          decompiled = std::format("{} _{} = {};", assignment_type, variable, assignment_value);
        }
      }

      if (!decompiled.empty()) {
#if DECOMPILER_DXC_DEBUG >= 3
        std::cout << decompiled << "\n";
#endif
#if DECOMPILER_DXC_DEBUG >= 1
        this->current_code_block.hlsl_lines.push_back(std::format("// {}", StringViewTrim(line)));
#endif
        this->current_code_block.hlsl_lines.push_back(decompiled);
      }
    }

    void CloseBranch() {
      // may already exist via phi
      auto& previous_code_block = this->code_blocks[this->current_code_block_number];
      previous_code_block.code_branch = this->current_code_block.code_branch;
      previous_code_block.code_switch = this->current_code_block.code_switch;
      previous_code_block.hlsl_lines = this->current_code_block.hlsl_lines;
      this->current_code_block_number = -1;
      this->current_code_block = {};
    }

    void AddCodeBranch(std::string_view line, PreprocessState& preprocess_state) {
      // br i1 <cond>, label <iftrue>, label <iffalse>
      // br label <dest>          ; Unconditional branch
      static auto conditional_branch_regex = std::regex{R"(^  br i1 (\S+), label %(\S+), label %(\S+),?( !dx\.controlflow\.hints)?.*)"};

      const auto [condition, if_true, if_false, use_hint] = StringViewMatch<4>(line, conditional_branch_regex);
      if (!condition.empty()) {
        this->current_code_block.code_branch.branch_condition = ParseBool(condition);
        FromStringView(if_true, this->current_code_block.code_branch.branch_condition_true);
        FromStringView(if_false, this->current_code_block.code_branch.branch_condition_false);
        if (!use_hint.empty()) {
          this->current_code_block.code_branch.use_hint = true;
        }
      } else {
        static auto unconditional_branch_regex = std::regex{R"(^  br label %(\S+).*)"};
        const auto [unconditional] = StringViewMatch<1>(line, unconditional_branch_regex);
        FromStringView(unconditional, this->current_code_block.code_branch.branch_condition_true);
      }
      this->CloseBranch();
    }

    void AddCodeSwitch(std::string_view line, PreprocessState& preprocess_state, std::vector<std::string_view>::iterator& iterator) {
      // switch i32 %24, label %357 [
      //   i32 2, label %25
      //   i32 3, label %147
      //   i32 4, label %213
      //   i32 5, label %358
      //   i32 6, label %224
      //   i32 1, label %229
      // ]
      static const auto SWITCH_START_REGEX = std::regex{R"(^  switch i32 (\S+), label %(\S+) \[.*)"};

      const auto [condition, case_default] = StringViewMatch<2>(line, SWITCH_START_REGEX);

      auto& code_switch = this->current_code_block.code_switch;

      code_switch.switch_condition = ParseBool(condition);
      FromStringView(case_default, code_switch.case_default);

      code_switch.branches.emplace(code_switch.case_default);

      while (true) {
        auto& current_line = *(++iterator);
        if (StringViewTrim(current_line).starts_with("]")) break;
        //     i32 2, label %25
        static const auto SWITCH_CASE_REGEX = std::regex{R"(^    i32 (\S+), label %(\S+).*$)"};
        const auto [case_value, case_function] = StringViewMatch<2>(current_line, SWITCH_CASE_REGEX);
        int case_function_int = -1;
        FromStringView(case_function, case_function_int);
        code_switch.case_values.emplace_back(case_value, case_function_int);
        code_switch.branches.emplace(case_function_int);
      };

      this->CloseBranch();
    }

    void AddCodeCall(std::string_view line, PreprocessState& preprocess_state) {
      static auto regex = std::regex{R"(^  call (\S+) ([^(]+)\(([^)]+)\).*)"};
      static auto param_regex = std::regex(R"(\s*(\S+) ((?:\d+)|(?:\{[^}]+\})|(?:%\d+)|(?:\S+))(?:(?:, )|(?:\s*$)))");
      auto [type, functionName, functionParamsString] = StringViewMatch<3>(line, regex);
      std::string decompiled;
      // auto paramMatches = string_view_split_all(functionParamsString, paramRegex, {1, 2});
      if (functionName == "@llvm.lifetime.start") {
      } else if (functionName == "@llvm.lifetime.end") {
      } else if (functionName == "@dx.op.discard") {
        // call void @dx.op.discard(i32 82, i1 true)  ; Discard(condition)
        auto [opNumber, condition] = StringViewSplit<2>(functionParamsString, param_regex, 2);
        if (condition.at(0) == '%') {
          // discard may infact be clip;
        }
        auto condition_string = ParseBool(condition);
        static auto clip_regex = std::regex(R"((.*)( < 0.0f)(\)+))");
        auto [clip_condition, less_than, parentheses_end] = StringViewMatch<3>(condition_string, clip_regex);
        if (less_than.empty()) {
          decompiled = std::format("if {} discard;", ParseWrapped(ParseBool(condition)));
        } else {
          decompiled = std::format("clip({}{});", clip_condition, parentheses_end);
        }
      } else if (functionName == "@dx.op.barrier") {
        // @dx.op.barrier(i32 80, i32 9)  ; Barrier(barrierMode)
        // Barrier mode is a bitmask: bit0=SyncThreadGroup, bit1=UAVFenceGlobal, bit2=UAVFenceThreadGroup, bit3=TGSMFence
        auto [opNumber, barrierMode] = StringViewSplit<2>(functionParamsString, param_regex, 2);
        int mode = 0;
        FromStringView(barrierMode, mode);
        bool has_sync = (mode & 1) != 0;
        bool has_uav_global = (mode & 2) != 0;
        bool has_uav_thread_group = (mode & 4) != 0;
        bool has_tgsm = (mode & 8) != 0;
        
        if (has_tgsm && has_sync && !has_uav_global) {
          decompiled = "GroupMemoryBarrierWithGroupSync();";
        } else if (has_tgsm && !has_sync && !has_uav_global) {
          decompiled = "GroupMemoryBarrier();";
        } else if (has_uav_global && has_sync && !has_tgsm) {
          decompiled = "DeviceMemoryBarrierWithGroupSync();";
        } else if (has_uav_global && !has_sync && !has_tgsm) {
          decompiled = "DeviceMemoryBarrier();";
        } else if (has_uav_global && has_tgsm && has_sync) {
          decompiled = "AllMemoryBarrierWithGroupSync();";
        } else if (has_uav_global && has_tgsm && !has_sync) {
          decompiled = "AllMemoryBarrier();";
        } else if (mode == 0) {
          decompiled = "// barrier(0) - no-op";
        } else {
          // Fallback: emit AllMemoryBarrierWithGroupSync for any unrecognized combo with sync
          decompiled = has_sync ? "AllMemoryBarrierWithGroupSync();" : "AllMemoryBarrier();";
        }
      } else if (functionName == "@dx.op.rawBufferStore.f32" || functionName == "@dx.op.rawBufferStore.f16") {
        // call void @dx.op.rawBufferStore.f32(i32 140, %dx.types.Handle %1751, i32 0, i32 0, float %884, float %885, float %821, float %833, i8 15, i32 4)  ; RawBufferStore(uav,index,elementOffset,value0,value1,value2,value3,mask,alignment)

        auto [opNumber, uav, index, elementOffset, value0, value1, value2, value3, mask, alignment] = StringViewSplit<10>(functionParamsString, param_regex, 2);
        auto ref = std::string{uav.substr(1)};
        auto binding_store_f32 = preprocess_state.resource_binding_variables.at(ref);
        auto [res_name, range_index, resource_class] = binding_store_f32;
        bool is_raw_buffer = preprocess_state.GetResourceShape(ref) == Resource::ResourceKind::RawBuffer;

        const bool has_value_y = value1 != "undef";
        const bool has_value_z = value2 != "undef";
        const bool has_value_w = value3 != "undef";
        std::string value;
        bool is_f16 = (functionName == "@dx.op.rawBufferStore.f16");
        if (is_f16) {
          if (has_value_w) {
            value = std::format("half4({}, {}, {}, {})", ParseHalf(value0), ParseHalf(value1), ParseHalf(value2), ParseHalf(value3));
          } else if (has_value_z) {
            value = std::format("half3({}, {}, {})", ParseHalf(value0), ParseHalf(value1), ParseHalf(value2));
          } else if (has_value_y) {
            value = std::format("half2({}, {})", ParseHalf(value0), ParseHalf(value1));
          } else {
            value = std::format("{}", ParseHalf(value0));
          }
        } else {
          if (has_value_w) {
            value = std::format("float4({}, {}, {}, {})", ParseFloat(value0), ParseFloat(value1), ParseFloat(value2), ParseFloat(value3));
          } else if (has_value_z) {
            value = std::format("float3({}, {}, {})", ParseFloat(value0), ParseFloat(value1), ParseFloat(value2));
          } else if (has_value_y) {
            value = std::format("float2({}, {})", ParseFloat(value0), ParseFloat(value1));
          } else {
            value = std::format("{}", ParseFloat(value0));
          }
        }

        // assert(is_raw_buffer);

        // assert(elementOffset == "undef");
        if (is_raw_buffer) {
          int component_count = 1;
          if (has_value_w) component_count = 4;
          else if (has_value_z) component_count = 3;
          else if (has_value_y) component_count = 2;
          std::string store_func = (component_count == 1) ? "Store" :
                                   std::format("Store{}", component_count);
          decompiled = std::format("{}.{}({}, asuint({}));",
                                   res_name, store_func, ParseInt(index), value);
        } else if (elementOffset.starts_with("%")) {
          // Dynamic element offset on a StructuredBuffer — resolve using struct layout.
          auto& uav_resource = preprocess_state.uav_resources[range_index];
          auto offset_var = std::string(elementOffset.substr(1));  // strip '%'

          uint32_t constant_field_offset = 0;
          std::string array_index_expr;

          // Scan source lines for the definition of this offset variable
          static const auto or_ir_regex_f = std::regex(R"(^\s+%(\d+) = or i32 (%\d+), (\d+))");
          static const auto add_ir_regex_f = std::regex(R"(^\s+%(\d+) = add (?:nuw )?(?:nsw )?i32 (%\d+), (\d+))");
          for (const auto& src_line : this->lines) {
            std::match_results<std::string_view::const_iterator> m;
            if (std::regex_search(src_line.begin(), src_line.end(), m, or_ir_regex_f) || std::regex_search(src_line.begin(), src_line.end(), m, add_ir_regex_f)) {
              if (m[1].str() == offset_var) {
                FromStringView(std::string_view(m[3].str()), constant_field_offset);
                array_index_expr = ParseInt(std::string_view(m[2].str()));
                break;
              }
            }
          }
          if (array_index_expr.empty()) {
            array_index_expr = ParseInt(elementOffset);
          }

          std::string field_access = preprocess_state.ResourceFieldNameAtOffset(uav_resource, constant_field_offset);
          if (!field_access.empty()) {
            auto type_name = uav_resource.pointer.substr(0, uav_resource.pointer.length() - 1);
            auto type_pair = preprocess_state.type_definitions.find(type_name);
            if (type_pair == preprocess_state.type_definitions.end()) {
              static auto array_inner_regex2 = std::regex{R"(^\[\d+ x (.+)\]$)"};
              auto [inner_type] = StringViewMatch<1>(type_name, array_inner_regex2);
              if (!inner_type.empty()) type_pair = preprocess_state.type_definitions.find(inner_type);
            }
            bool resolved_dynamic = false;
            if (type_pair != preprocess_state.type_definitions.end()) {
              auto& def = type_pair->second;
              auto effective_tn = std::string_view(type_pair->first);
              if (effective_tn.starts_with("%\"class.RWStructuredBuffer<") || effective_tn.starts_with("%\"hostlayout.class.RWStructuredBuffer<")) {
                auto struct_pair = preprocess_state.type_definitions.find(def.variables[0].type);
                if (struct_pair != preprocess_state.type_definitions.end()) {
                  for (const auto& [decl, fname, ftype, foffset] : struct_pair->second.variables) {
                    DataType finfo(ftype);
                    if (!finfo.array_sizes.empty()) {
                      uint32_t total_size = static_cast<uint32_t>(preprocess_state.GetTypeSize(finfo));
                      uint32_t element_size = total_size;
                      for (auto arr_sz : finfo.array_sizes) element_size /= arr_sz;
                      std::string sub_field;
                      if (finfo.data_type.starts_with("%struct.") || finfo.data_type.starts_with("%hostlayout.struct.")) {
                        auto sub_pair = preprocess_state.type_definitions.find(finfo.data_type);
                        if (sub_pair != preprocess_state.type_definitions.end()) {
                          sub_field = "." + preprocess_state.DataTypeNameAtIndex(sub_pair->second.variables, constant_field_offset);
                        }
                      } else {
                        DataType elem_info(finfo.data_type);
                        if (elem_info.vector_size > 0 && constant_field_offset > 0) {
                          uint32_t scalar_size = (elem_info.data_type == "double" || elem_info.data_type == "int64_t" || elem_info.data_type == "uint64_t") ? 8 : 4;
                          sub_field = std::format(".{}", VECTOR_INDEXES[constant_field_offset / scalar_size]);
                        }
                      }
                      decompiled = std::format("{}[{}].{}[{} / {}]{} = {};",
                                               res_name, ParseInt(index), fname, array_index_expr, element_size, sub_field, value);
                      resolved_dynamic = true;
                      break;
                    }
                  }
                }
              }
            }
            if (!resolved_dynamic) {
              decompiled = std::format("{}[{}]{} = {};",
                                       res_name, ParseInt(index), field_access, value);
            }
          } else {
            decompiled = std::format("{}[{}] = {};",
                                     res_name, ParseInt(index), value);
          }
        } else {
          // Structured buffer store: resolve byte offset to struct field
          int literal_element_offset = 0;
          if (elementOffset != "undef") {
            FromStringView(elementOffset, literal_element_offset);
          }
          auto& uav_resource = preprocess_state.uav_resources[range_index];
          std::string field_access = preprocess_state.ResourceFieldNameAtOffset(uav_resource, literal_element_offset);
          if (!field_access.empty()) {
            decompiled = std::format("{}[{}]{} = {};",
                                     res_name, ParseInt(index), field_access, value);
          } else {
            // Fallback: can't resolve field, use raw offset notation
            decompiled = std::format("{}[{}] = {};",
                                     res_name, ParseInt(index), value);
          }
        }
      } else if (functionName == "@dx.op.rawBufferStore.i32" || functionName == "@dx.op.rawBufferStore.i16") {
        // call void @dx.op.rawBufferStore.i32(i32 140, %dx.types.Handle %3114, i32 %3113, i32 0, i32 %2310, i32 undef, i32 undef, i32 undef, i8 1, i32 4)  ; RawBufferStore(uav,index,elementOffset,value0,value1,value2,value3,mask,alignment)

        auto [opNumber, uav, index, elementOffset, value0, value1, value2, value3, mask, alignment] = StringViewSplit<10>(functionParamsString, param_regex, 2);
        auto ref = std::string{uav.substr(1)};
        auto binding_store_i32 = preprocess_state.resource_binding_variables.at(ref);
        auto [res_name, range_index, resource_class] = binding_store_i32;
        bool is_raw_buffer = preprocess_state.GetResourceShape(ref) == Resource::ResourceKind::RawBuffer;

        const bool has_value_y = value1 != "undef";
        const bool has_value_z = value2 != "undef";
        const bool has_value_w = value3 != "undef";
        std::string value;
        bool is_i16 = (functionName == "@dx.op.rawBufferStore.i16");
        if (is_i16) {
          if (has_value_w) {
            value = std::format("int16_t4({}, {}, {}, {})", ParseInt(value0), ParseInt(value1), ParseInt(value2), ParseInt(value3));
          } else if (has_value_z) {
            value = std::format("int16_t3({}, {}, {})", ParseInt(value0), ParseInt(value1), ParseInt(value2));
          } else if (has_value_y) {
            value = std::format("int16_t2({}, {})", ParseInt(value0), ParseInt(value1));
          } else {
            value = std::format("(int16_t)({})", ParseInt(value0));
          }
        } else {
          if (has_value_w) {
            value = std::format("int4({}, {}, {}, {})", ParseInt(value0), ParseInt(value1), ParseInt(value2), ParseInt(value3));
          } else if (has_value_z) {
            value = std::format("int3({}, {}, {})", ParseInt(value0), ParseInt(value1), ParseInt(value2));
          } else if (has_value_y) {
            value = std::format("int2({}, {})", ParseInt(value0), ParseInt(value1));
          } else {
            value = std::format("{}", ParseInt(value0));
          }
        }

        if (is_raw_buffer) {
          decompiled = std::format("{}.{}({}, asuint({}));",
                                   res_name,
                                   has_value_w ? "Store4" : has_value_z ? "Store3" : has_value_y ? "Store2" : "Store",
                                   ParseInt(index), value);
        } else if (elementOffset.starts_with("%")) {
          // Dynamic element offset on a StructuredBuffer — resolve using struct layout.
          // Extract the constant field offset from the IR definition of the offset variable.
          // Pattern: %N = or i32 %base, CONSTANT  →  field offset = CONSTANT
          // Pattern: %N = shl ... (no constant add)  →  field offset = 0
          auto& uav_resource = preprocess_state.uav_resources[range_index];
          auto offset_var = std::string(elementOffset.substr(1));  // strip '%'

          uint32_t constant_field_offset = 0;
          std::string array_index_expr;

          // Scan source lines for the definition of this offset variable
          static const auto or_ir_regex = std::regex(R"(^\s+%(\d+) = or i32 (%\d+), (\d+))");
          static const auto add_ir_regex = std::regex(R"(^\s+%(\d+) = add (?:nuw )?(?:nsw )?i32 (%\d+), (\d+))");
          for (const auto& src_line : this->lines) {
            std::match_results<std::string_view::const_iterator> m;
            if (std::regex_search(src_line.begin(), src_line.end(), m, or_ir_regex) || std::regex_search(src_line.begin(), src_line.end(), m, add_ir_regex)) {
              if (m[1].str() == offset_var) {
                FromStringView(std::string_view(m[3].str()), constant_field_offset);
                array_index_expr = ParseInt(std::string_view(m[2].str()));
                break;
              }
            }
          }
          // If no or/add found, the offset itself is the base (field offset = 0)
          if (array_index_expr.empty()) {
            array_index_expr = ParseInt(elementOffset);
          }

          std::string field_access = preprocess_state.ResourceFieldNameAtOffset(uav_resource, constant_field_offset);
          if (!field_access.empty()) {
            // Find the array field and its element size to emit proper indexing
            auto type_name = uav_resource.pointer.substr(0, uav_resource.pointer.length() - 1);
            auto type_pair = preprocess_state.type_definitions.find(type_name);
            if (type_pair == preprocess_state.type_definitions.end()) {
              static auto array_inner_regex3 = std::regex{R"(^\[\d+ x (.+)\]$)"};
              auto [inner_type] = StringViewMatch<1>(type_name, array_inner_regex3);
              if (!inner_type.empty()) type_pair = preprocess_state.type_definitions.find(inner_type);
            }
            bool resolved_dynamic = false;
            if (type_pair != preprocess_state.type_definitions.end()) {
              auto& def = type_pair->second;
              auto effective_tn = std::string_view(type_pair->first);
              if (effective_tn.starts_with("%\"class.RWStructuredBuffer<") || effective_tn.starts_with("%\"hostlayout.class.RWStructuredBuffer<")) {
                auto struct_pair = preprocess_state.type_definitions.find(def.variables[0].type);
                if (struct_pair != preprocess_state.type_definitions.end()) {
                  for (const auto& [decl, fname, ftype, foffset] : struct_pair->second.variables) {
                    DataType finfo(ftype);
                    if (!finfo.array_sizes.empty()) {
                      uint32_t total_size = static_cast<uint32_t>(preprocess_state.GetTypeSize(finfo));
                      uint32_t element_size = total_size;
                      for (auto arr_sz : finfo.array_sizes) element_size /= arr_sz;
                      std::string sub_field;
                      if (finfo.data_type.starts_with("%struct.") || finfo.data_type.starts_with("%hostlayout.struct.")) {
                        auto sub_pair = preprocess_state.type_definitions.find(finfo.data_type);
                        if (sub_pair != preprocess_state.type_definitions.end()) {
                          sub_field = "." + preprocess_state.DataTypeNameAtIndex(sub_pair->second.variables, constant_field_offset);
                        }
                      } else {
                        DataType elem_info(finfo.data_type);
                        if (elem_info.vector_size > 0 && constant_field_offset > 0) {
                          uint32_t scalar_size = (elem_info.data_type == "double" || elem_info.data_type == "int64_t" || elem_info.data_type == "uint64_t") ? 8 : 4;
                          sub_field = std::format(".{}", VECTOR_INDEXES[constant_field_offset / scalar_size]);
                        }
                      }
                      decompiled = std::format("{}[{}].{}[{} / {}]{} = {};",
                                               res_name, ParseInt(index), fname, array_index_expr, element_size, sub_field, value);
                      resolved_dynamic = true;
                      break;
                    }
                  }
                }
              }
            }
            if (!resolved_dynamic) {
              decompiled = std::format("{}[{}]{} = {};",
                                       res_name, ParseInt(index), field_access, value);
            }
          } else {
            decompiled = std::format("{}[{}] = {};",
                                     res_name, ParseInt(index), value);
          }
        } else {
          // Structured buffer store: resolve byte offset to struct field
          int literal_element_offset = 0;
          if (elementOffset != "undef") {
            FromStringView(elementOffset, literal_element_offset);
          }
          auto& uav_resource = preprocess_state.uav_resources[range_index];
          std::string field_access = preprocess_state.ResourceFieldNameAtOffset(uav_resource, literal_element_offset);
          if (!field_access.empty()) {
            decompiled = std::format("{}[{}]{} = {};",
                                     res_name, ParseInt(index), field_access, value);
          } else {
            // Fallback: can't resolve field, use raw offset notation
            decompiled = std::format("{}[{}] = {};",
                                     res_name, ParseInt(index), value);
          }
        }
      } else if (functionName == "@dx.op.storeOutput.f32" || functionName == "@dx.op.storeOutput.f16") {
        // call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 0, float %2772)  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
        auto [opNumber, outputSigId, rowIndex, colIndex, value] = StringViewSplit<5>(functionParamsString, param_regex, 2);
        int output_signature_index;
        FromStringView(outputSigId, output_signature_index);
        auto signature = preprocess_state.output_signature[output_signature_index];
        if (rowIndex != "0") {
          throw std::runtime_error("Row index not supported.");
        }
        if (signature.packed.MaskString() == "1") {
          decompiled = std::format("{} = {};", signature.VariableString(), ParseFloat(value));
        } else {
          decompiled = std::format("{}.{} = {};", signature.VariableString(), ParseIndex(colIndex), ParseFloat(value));
        }
      } else if (functionName == "@dx.op.storeOutput.i32") {
        // call void @dx.op.storeOutput.i32(i32 5, i32 0, i32 0, i8 0, i32 %532)  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
        auto [opNumber, outputSigId, rowIndex, colIndex, value] = StringViewSplit<5>(functionParamsString, param_regex, 2);
        int output_signature_index;
        FromStringView(outputSigId, output_signature_index);
        auto signature = preprocess_state.output_signature[output_signature_index];
        if (rowIndex != "0") {
          throw std::runtime_error("Row index not supported.");
        }
        auto parsed_value = signature.packed.format == SignaturePacked::Format::UINT ? ParseUint(value) : ParseInt(value);
        if (signature.packed.MaskString() == "1") {
          decompiled = std::format("{} = {};", signature.VariableString(), parsed_value);
        } else {
          decompiled = std::format("{}.{} = {};", signature.VariableString(), ParseIndex(colIndex), parsed_value);
        }
      } else if (functionName == "@dx.op.textureStore.f32" || functionName == "@dx.op.textureStore.f16") {
        //   call void @dx.op.textureStore.f32(i32 67, %dx.types.Handle %558, i32 %16, i32 %17, i32 undef, float %555, float %556, float %557, float 1.000000e+00, i8 15)  ; TextureStore(srv,coord0,coord1,coord2,value0,value1,value2,value3,mask)
        auto [opNumber, uav, coord0, coord1, coord2, value0, value1, value2, value3, mask] = StringViewSplit<10>(functionParamsString, param_regex, 2);
        auto ref_resource = std::string{uav.substr(1)};
        const bool has_coord_y = coord1 != "undef";
        const bool has_coord_z = coord2 != "undef";
        std::string coords;
        auto [uav_name, uav_range_index, resource_class] = preprocess_state.resource_binding_variables.at(ref_resource);
        auto uav_resource = preprocess_state.uav_resources[uav_range_index];
        if (has_coord_z) {
          coords = std::format("int3({}, {}, {})", ParseInt(coord0), ParseInt(coord1), ParseInt(coord2));
        } else if (has_coord_y) {
          coords = std::format("int2({}, {})", ParseInt(coord0), ParseInt(coord1));
        } else {
          coords = std::format("{}", ParseInt(coord0));
        }
        bool has_value_y = value1 != "undef";
        bool has_value_z = value2 != "undef";
        bool has_value_w = value3 != "undef";

        if (has_value_w && value3 == value0 && uav_resource.data_type != "float4") {
          has_value_w = false;
        }
        if (has_value_z && value2 == value0 && uav_resource.data_type != "float3") {
          has_value_z = false;
        }
        if (has_value_y && value1 == value0 && uav_resource.data_type != "float2") {
          has_value_y = false;
        }
        std::string value;
        if (has_value_w) {
          value = std::format("float4({}, {}, {}, {})", ParseFloat(value0), ParseFloat(value1), ParseFloat(value2), ParseFloat(value3));
        } else if (has_value_z) {
          value = std::format("float3({}, {}, {})", ParseFloat(value0), ParseFloat(value1), ParseFloat(value2));
        } else if (has_value_y) {
          value = std::format("float2({}, {})", ParseFloat(value0), ParseFloat(value1));
        } else {
          value = std::format("{}", ParseFloat(value0));
        }

        decompiled = std::format("{}[{}] = {};", uav_name, coords, value);
      } else if (functionName == "@dx.op.textureStore.i32" || functionName == "@dx.op.textureStore.i16") {
        //     call void @dx.op.textureStore.i32(i32 67, %dx.types.Handle %1, i32 %12, i32 %13, i32 undef, i32 %1392, i32 %1405, i32 %1392, i32 %1392, i8 15)  ; TextureStore(srv,coord0,coord1,coord2,value0,value1,value2,value3,mask)
        auto [opNumber, uav, coord0, coord1, coord2, value0, value1, value2, value3, mask] = StringViewSplit<10>(functionParamsString, param_regex, 2);
        auto ref_resource = std::string{uav.substr(1)};
        const bool has_coord_y = coord1 != "undef";
        const bool has_coord_z = coord2 != "undef";
        std::string coords;
        auto [uav_name, uav_range_index, resource_class] = preprocess_state.resource_binding_variables.at(ref_resource);
        auto uav_resource = preprocess_state.uav_resources[uav_range_index];
        if (has_coord_z) {
          coords = std::format("int3({}, {}, {})", ParseInt(coord0), ParseInt(coord1), ParseInt(coord2));
        } else if (has_coord_y) {
          coords = std::format("int2({}, {})", ParseInt(coord0), ParseInt(coord1));
        } else {
          coords = std::format("{}", ParseInt(coord0));
        }
        bool has_value_y = value1 != "undef";
        bool has_value_z = value2 != "undef";
        bool has_value_w = value3 != "undef";

        if (has_value_w && value3 == value0 && uav_resource.data_type != "uint4") {
          has_value_w = false;
        }
        if (has_value_z && value2 == value0 && uav_resource.data_type != "uint3") {
          has_value_z = false;
        }
        if (has_value_y && value1 == value0 && uav_resource.data_type != "uint2") {
          has_value_y = false;
        }
        std::string value;
        if (has_value_w) {
          value = std::format("int4({}, {}, {}, {})", ParseInt(value0), ParseInt(value1), ParseInt(value2), ParseInt(value3));
        } else if (has_value_z) {
          value = std::format("int3({}, {}, {})", ParseInt(value0), ParseInt(value1), ParseInt(value2));
        } else if (has_value_y) {
          value = std::format("int2({}, {})", ParseInt(value0), ParseInt(value1));
        } else {
          value = std::format("{}", ParseInt(value0));
        }

        decompiled = std::format("{}[{}] = {};", uav_name, coords, value);
      } else if (functionName == "@dx.op.bufferStore.f32" || functionName == "@dx.op.bufferStore.f16") {
        // call void @dx.op.bufferStore.f32(i32 69, %dx.types.Handle %593, i32 %584, i32 undef, float %592, float %592, float %592, float %592, i8 15)  ; BufferStore(uav,coord0,coord1,value0,value1,value2,value3,mask)

        auto [opNumber, uav, coord0, coord1, value0, value1, value2, value3, mask] = StringViewSplit<9>(functionParamsString, param_regex, 2);
        auto ref = std::string{uav.substr(1)};
        const bool has_coord_y = coord1 != "undef";
        std::string coords;
        auto [uav_name, uav_range_index, resource_class] = preprocess_state.resource_binding_variables.at(ref);
        auto uav_resource = preprocess_state.uav_resources[uav_range_index];
        // For StructuredBuffer, coord0 is the element index and coord1 is the byte
        // offset within the struct element. Use only coord0 as the HLSL index.
        bool is_structured = (uav_resource.shape == Resource::ResourceKind::StructuredBuffer);
        if (has_coord_y && !is_structured) {
          coords = std::format("int2({}, {})", ParseInt(coord0), ParseInt(coord1));
        } else {
          coords = std::format("{}", ParseInt(coord0));
        }

        bool has_value_y = value1 != "undef";
        bool has_value_z = value2 != "undef";
        bool has_value_w = value3 != "undef";

        if (has_value_w && value3 == value0 && uav_resource.data_type != "float4") {
          has_value_w = false;
        }
        if (has_value_z && value2 == value0 && uav_resource.data_type != "float3") {
          has_value_z = false;
        }
        if (has_value_y && value1 == value0 && uav_resource.data_type != "float2") {
          has_value_y = false;
        }
        std::string value;
        if (has_value_w) {
          value = std::format("float4({}, {}, {}, {})", ParseFloat(value0), ParseFloat(value1), ParseFloat(value2), ParseFloat(value3));
        } else if (has_value_z) {
          value = std::format("float3({}, {}, {})", ParseFloat(value0), ParseFloat(value1), ParseFloat(value2));
        } else if (has_value_y) {
          value = std::format("float2({}, {})", ParseFloat(value0), ParseFloat(value1));
        } else {
          value = std::format("{}", ParseFloat(value0));
        }

        bool is_raw_buffer_f = (uav_resource.shape == Resource::ResourceKind::RawBuffer);
        if (is_raw_buffer_f) {
          int component_count = 1;
          if (has_value_w) component_count = 4;
          else if (has_value_z) component_count = 3;
          else if (has_value_y) component_count = 2;
          std::string store_func = (component_count == 1) ? "Store" :
                                   std::format("Store{}", component_count);
          decompiled = std::format("{}.{}({}, asuint({}));",
                                   uav_name, store_func, coords, value);
        } else if (is_structured) {
          // Resolve byte offset to struct field name
          int byte_offset = 0;
          if (has_coord_y && coord1 != "undef") {
            FromStringView(coord1, byte_offset);
          }
          std::string field_access = preprocess_state.ResourceFieldNameAtOffset(uav_resource, byte_offset);
          decompiled = std::format("{}[{}]{} = {};", uav_name, coords, field_access, value);
        } else {
          decompiled = std::format("{}[{}] = {};", uav_name, coords, value);
        }
      } else if (functionName == "@dx.op.bufferStore.i32" || functionName == "@dx.op.bufferStore.i16") {
        // call void @dx.op.bufferStore.i32(i32 69, %dx.types.Handle %1, i32 %17, i32 undef, i32 %438, i32 %438, i32 %438, i32 %438, i8 15)  ; BufferStore(uav,coord0,coord1,value0,value1,value2,value3,mask)

        auto [opNumber, uav, coord0, coord1, value0, value1, value2, value3, mask] = StringViewSplit<9>(functionParamsString, param_regex, 2);
        auto ref = std::string{uav.substr(1)};
        const bool has_coord_y = coord1 != "undef";
        std::string coords;
        auto [uav_name, uav_range_index, resource_class] = preprocess_state.resource_binding_variables.at(ref);
        auto uav_resource = preprocess_state.uav_resources[uav_range_index];
        // For StructuredBuffer, coord0 is the element index and coord1 is the byte
        // offset within the struct element. Use only coord0 as the HLSL index.
        bool is_structured = (uav_resource.shape == Resource::ResourceKind::StructuredBuffer);
        if (has_coord_y && !is_structured) {
          coords = std::format("int2({}, {})", ParseInt(coord0), ParseInt(coord1));
        } else {
          coords = std::format("{}", ParseInt(coord0));
        }

        bool has_value_y = value1 != "undef";
        bool has_value_z = value2 != "undef";
        bool has_value_w = value3 != "undef";

        if (has_value_w && value3 == value0 && uav_resource.data_type != "uint4") {
          has_value_w = false;
        }
        if (has_value_z && value2 == value0 && uav_resource.data_type != "uint3") {
          has_value_z = false;
        }
        if (has_value_y && value1 == value0 && uav_resource.data_type != "uint2") {
          has_value_y = false;
        }
        std::string value;
        if (has_value_w) {
          value = std::format("int4({}, {}, {}, {})", ParseInt(value0), ParseInt(value1), ParseInt(value2), ParseInt(value3));
        } else if (has_value_z) {
          value = std::format("int3({}, {}, {})", ParseInt(value0), ParseInt(value1), ParseInt(value2));
        } else if (has_value_y) {
          value = std::format("int2({}, {})", ParseInt(value0), ParseInt(value1));
        } else {
          value = std::format("{}", ParseInt(value0));
        }

        bool is_raw_buffer_i = (uav_resource.shape == Resource::ResourceKind::RawBuffer);
        if (is_raw_buffer_i) {
          int component_count = 1;
          if (has_value_w) component_count = 4;
          else if (has_value_z) component_count = 3;
          else if (has_value_y) component_count = 2;
          std::string store_func = (component_count == 1) ? "Store" :
                                   std::format("Store{}", component_count);
          decompiled = std::format("{}.{}({}, asuint({}));",
                                   uav_name, store_func, coords, value);
        } else if (is_structured) {
          // Resolve byte offset to struct field name
          int byte_offset = 0;
          if (has_coord_y && coord1 != "undef") {
            FromStringView(coord1, byte_offset);
          }
          std::string field_access = preprocess_state.ResourceFieldNameAtOffset(uav_resource, byte_offset);
          decompiled = std::format("{}[{}]{} = {};", uav_name, coords, field_access, value);
        } else {
          decompiled = std::format("{}[{}] = {};", uav_name, coords, value);
        }

      // --- Ray Query void operations (DXR Tier 1.1 inline raytracing) ---
      } else if (functionName == "@dx.op.rayQuery_TraceRayInline") {
        // call void @dx.op.rayQuery_TraceRayInline(i32 179, i32 %154, %dx.types.Handle %155, i32 0, i32 128, float %133, float %135, float %137, float %153, float %147, float %148, float %149, float %146)
        auto [opNumber, rayQueryHandle, accelStruct, rayFlags, instanceMask,
              originX, originY, originZ, tMin,
              directionX, directionY, directionZ, tMax] = StringViewSplit<13>(functionParamsString, param_regex, 2);
        std::string rq_var = std::format("_{}", ParseVariable(rayQueryHandle).substr(1));
        auto ref_as = std::string{accelStruct.substr(1)};
        auto [as_name, as_range_index, as_resource_class] = preprocess_state.resource_binding_variables.at(ref_as);
        // HLSL TraceRayInline takes 4 args: (accelStruct, rayFlags, instanceMask, rayDesc)
        // Pack origin/tMin/direction/tMax into a RayDesc struct
        std::string rd_var = std::format("_rd_{}", rq_var);
        decompiled = std::format("RayDesc {}; {}.Origin = float3({}, {}, {}); {}.TMin = {}; {}.Direction = float3({}, {}, {}); {}.TMax = {}; {}.TraceRayInline({}, {}, {}, {});",
                                  rd_var,
                                  rd_var, ParseFloat(originX), ParseFloat(originY), ParseFloat(originZ),
                                  rd_var, ParseFloat(tMin),
                                  rd_var, ParseFloat(directionX), ParseFloat(directionY), ParseFloat(directionZ),
                                  rd_var, ParseFloat(tMax),
                                  rq_var, as_name, ParseInt(rayFlags), ParseInt(instanceMask), rd_var);
      } else if (functionName == "@dx.op.rayQuery_CommitNonOpaqueTriangleHit") {
        // call void @dx.op.rayQuery_CommitNonOpaqueTriangleHit(i32 182, i32 %154)
        auto [opNumber, rayQueryHandle] = StringViewSplit<2>(functionParamsString, param_regex, 2);
        std::string rq_var = std::format("_{}", ParseVariable(rayQueryHandle).substr(1));
        decompiled = std::format("{}.CommitNonOpaqueTriangleHit();", rq_var);
      } else if (functionName == "@dx.op.rayQuery_CommitProceduralPrimitiveHit") {
        // call void @dx.op.rayQuery_CommitProceduralPrimitiveHit(i32 183, i32 %handle, float %tHit)
        auto [opNumber, rayQueryHandle, tHit] = StringViewSplit<3>(functionParamsString, param_regex, 2);
        std::string rq_var = std::format("_{}", ParseVariable(rayQueryHandle).substr(1));
        decompiled = std::format("{}.CommitProceduralPrimitiveHit({});", rq_var, ParseFloat(tHit));
      } else if (functionName == "@dx.op.rayQuery_Abort") {
        // call void @dx.op.rayQuery_Abort(i32 181, i32 %handle)
        auto [opNumber, rayQueryHandle] = StringViewSplit<2>(functionParamsString, param_regex, 2);
        std::string rq_var = std::format("_{}", ParseVariable(rayQueryHandle).substr(1));
        decompiled = std::format("{}.Abort();", rq_var);
      } else {
        std::cerr << line << "\n";
        std::cerr << "Function name: " << functionName << "\n";
        throw std::runtime_error("Unknown call function name");
      }

      if (!decompiled.empty()) {
#if DECOMPILER_DXC_DEBUG >= 3
        std::cout << decompiled << "\n";
#endif
#if DECOMPILER_DXC_DEBUG >= 2
        this->current_code_block.hlsl_lines.push_back(std::format("// {}", StringViewTrim(line)));
#endif
        this->current_code_block.hlsl_lines.push_back(decompiled);
      }
    }

    void AddCodeStore(std::string_view line, PreprocessState& preprocess_state) {
      // Handle stores with inline getelementptr to shared memory FIRST (before other regexes):
      // store i32 %val, i32 addrspace(3)* getelementptr inbounds ([N x type], [N x type] addrspace(3)* @"name", i32 0, i32 INDEX), ...
      {
        auto line_str = std::string(line);
        if (line_str.find("getelementptr inbounds") != std::string::npos
            && line_str.find("addrspace(3)") != std::string::npos) {
          // Parse store type and value manually: "  store TYPE VALUE, ..."
          auto store_start = line_str.find("store ") + 6;  // skip "  store "
          auto type_end = line_str.find(' ', store_start);
          auto gep_store_type = line_str.substr(store_start, type_end - store_start);
          auto value_start = type_end + 1;
          auto value_end = line_str.find(',', value_start);
          auto gep_value = line_str.substr(value_start, value_end - value_start);
          auto at_pos = line_str.find("@\"");
          auto close_quote = (at_pos != std::string::npos) ? line_str.find("\"", at_pos + 2) : std::string::npos;
          auto last_i32 = line_str.rfind("i32 ");
          auto close_paren = (last_i32 != std::string::npos) ? line_str.find(")", last_i32) : std::string::npos;
          
          if (!gep_store_type.empty() && !gep_value.empty()
              && at_pos != std::string::npos && close_quote != std::string::npos
              && last_i32 != std::string::npos && close_paren != std::string::npos
              && close_paren > last_i32 + 4) {
            auto gep_global = line_str.substr(at_pos, close_quote - at_pos + 1);
            auto index_str = std::string_view(line_str).substr(last_i32 + 4, close_paren - (last_i32 + 4));
            
            std::string parsed_pointer;
            if (auto pair = preprocess_state.global_variables.find(gep_global);
                pair != preprocess_state.global_variables.end()) {
              parsed_pointer = pair->second;
            } else {
              parsed_pointer = std::format("/* {} */", gep_global);
            }
            std::string parsed_value;
            if (gep_store_type == "i32" || gep_store_type == "i16") {
              parsed_value = ParseInt(std::string_view(gep_value));
            } else {
              parsed_value = ParseFloat(std::string_view(gep_value));
            }
            int index = 0;
            FromStringView(index_str, index);
            std::string decompiled = std::format("{}[{}] = {};", parsed_pointer, index, parsed_value);
            this->current_code_block.hlsl_lines.push_back(decompiled);
            return;
          }
        }
      }

      // store float %1358, float* %1369, align 4, !tbaa !26, !alias.scope !30
      // store i32 %62, i32 addrspace(3)* %ptr, align 4
      // Parse store type to use correct value parser (float stores to int groupshared need asuint)
      static auto regex = std::regex{R"(^  store (\S+) ([^,]+), [^*]+\* %([A-Za-z0-9]+),?.*)"};
      auto [store_type, value, pointer] = StringViewMatch<3>(line, regex);

      auto get_reinterpret_for_mismatch = [](std::string_view stored_type, std::string_view element_type) -> std::string {
        if (element_type.empty() || stored_type == element_type) return "";
        // float -> integer storage: preserve bits via asuint/asint
        if (stored_type == "float" || stored_type == "half" || stored_type == "double") {
          if (element_type == "i32" || element_type == "i16" || element_type == "i64") {
            return "asuint";
          }
        }
        // integer -> float storage
        if (stored_type == "i32" || stored_type == "i16" || stored_type == "i64") {
          if (element_type == "float" || element_type == "half" || element_type == "double") {
            return "asfloat";
          }
        }
        return "";
      };

      if (pointer.empty()) {
        // Handle stores to global/addrspace variables (e.g., shared memory)
        // store i32 0, i32 addrspace(3)* @"...", align 4
        // store float %val, float addrspace(3)* @"...", align 4
        static auto global_regex = std::regex{R"(^  store (\S+) ([^,]+), [^*]+\* (@[^,]+),?.*)"};
        auto [global_store_type, global_value, global_pointer] = StringViewMatch<3>(line, global_regex);
        if (!global_pointer.empty()) {
          std::string parsed_pointer;
          if (auto pair = preprocess_state.global_variables.find(std::string(global_pointer));
              pair != preprocess_state.global_variables.end()) {
            parsed_pointer = pair->second;
          } else {
            parsed_pointer = std::format("/* {} */", global_pointer);
          }
          // Use type-appropriate parser for the stored value
          std::string parsed_value;
          if (global_store_type == "i32" || global_store_type == "i16") {
            parsed_value = ParseInt(global_value);
          } else {
            parsed_value = ParseFloat(global_value);
          }
          std::string decompiled = std::format("{} = {};", parsed_pointer, parsed_value);
#if DECOMPILER_DXC_DEBUG >= 1
          this->current_code_block.hlsl_lines.push_back(std::format("// {}", StringViewTrim(line)));
#endif
          this->current_code_block.hlsl_lines.push_back(decompiled);
          return;
        }

        // Unknown store format — skip with comment
        std::cerr << "WARNING: Unhandled store instruction: " << StringViewTrim(line) << "\n";
        this->current_code_block.hlsl_lines.push_back(std::format("// UNHANDLED: {}", StringViewTrim(line)));
        return;
      }

      // Use type-appropriate parser for the stored value
      std::string parsed_value;
      if (store_type == "i32" || store_type == "i16") {
        parsed_value = ParseInt(value);
      } else {
        parsed_value = ParseFloat(value);
      }

      // If the pointer was reinterpret-bitcast to a different scalar type
      // (e.g. i32* -> float*), the underlying HLSL array element type still
      // follows the original declaration. Plain HLSL assignment would
      // perform a numeric conversion (float -> uint truncation), which is
      // WRONG when the DXIL intent is a bit-level reinterpret. Emit
      // asuint()/asfloat() to preserve the raw bits.
      auto element_type_it = stored_pointer_element_types.find(std::string(pointer));
      if (element_type_it != stored_pointer_element_types.end()) {
        std::string cast = get_reinterpret_for_mismatch(store_type, element_type_it->second);
        if (!cast.empty()) {
          parsed_value = std::format("{}({})", cast, parsed_value);
        }
      }
      std::string decompiled = std::format("{} = {};", stored_pointers[pointer], parsed_value);

#if DECOMPILER_DXC_DEBUG >= 3
      std::cout << decompiled << "\n";
#endif
#if DECOMPILER_DXC_DEBUG >= 1
      this->current_code_block.hlsl_lines.push_back(std::format("// {}", StringViewTrim(line)));
#endif
      this->current_code_block.hlsl_lines.push_back(decompiled);
    }

    void ParseBlockDefinition(std::string_view line) {
      // ; <label>:21                                      ; preds = %0
      static auto block_definition_regex = std::regex{R"(^; <label>:(\S+)\s+; preds = (.*))"};
      auto [line_number, predecessors] = StringViewMatch<2>(line, block_definition_regex);
      FromStringView(line_number, this->current_code_block_number);
    }

    auto DecompileLines(PreprocessState& preprocess_state) {
      for (auto it = this->lines.begin(); it != this->lines.end(); ++it) {
        auto& line = *it;
        if (line.starts_with("  %")) {
          this->AddCodeAssign(line, preprocess_state);
        } else if (line.starts_with("  call ")) {
          this->AddCodeCall(line, preprocess_state);
        } else if (line.starts_with("  store ")) {
          this->AddCodeStore(line, preprocess_state);
        } else if (line.starts_with("  ret ")) {
          this->CloseBranch();
        } else if (line.starts_with("  br ")) {
          this->AddCodeBranch(line, preprocess_state);
        } else if (line.starts_with("  switch ")) {
          this->AddCodeSwitch(line, preprocess_state, it);
        } else if (line.empty()) {
          //
        } else if (line == "entry:") {
          // noop
        } else if (line.starts_with("; <label>:")) {
          this->ParseBlockDefinition(line);
        } else {
          std::cerr << line << "\n";
          throw std::runtime_error("Unexpected code block");
        }
      }
    }

    auto ListConvergences() {
      std::map<int, std::set<int>> convergences;

      for (const auto& [line_number, code_block] : code_blocks) {
        if (code_block.code_branch.branch_condition_true != -1) {
          convergences[code_block.code_branch.branch_condition_true].emplace(line_number);
        }
        if (code_block.code_branch.branch_condition_false != -1) {
          convergences[code_block.code_branch.branch_condition_false].emplace(line_number);
        }
        if (!code_block.code_switch.switch_condition.empty()) {
          convergences[code_block.code_switch.case_default].emplace(line_number);
          for (const auto& [case_value, case_function] : code_block.code_switch.case_values) {
            convergences[case_function].emplace(line_number);
          }
        }
      }

      // Single-pass transitive closure (ascending key order).
      // Because std::map iterates in ascending order and we modify
      // in-place, earlier entries expand before later entries read them,
      // effectively computing a multi-level closure. The post-dominator
      // validation in the convergence search corrects any over-inclusion.
      for (auto& [line_number, convergence_set] : convergences) {
        const auto temp_convergence_set = convergence_set;
        for (const auto convergence : temp_convergence_set) {
          auto other_set = convergences[convergence];
          for (const auto other_set_item : other_set) {
            convergence_set.emplace(other_set_item);
          }
        }
      }

      return convergences;
    }

    auto ListRecursions() const {
      std::map<int, std::set<int>> recursions;

      for (const auto& [line_number, code_block] : code_blocks) {
        if (code_block.code_branch.branch_condition_true != -1) {
          if (line_number >= code_block.code_branch.branch_condition_true) {
            recursions[code_block.code_branch.branch_condition_true].emplace(line_number);
          }
        }
        if (code_block.code_branch.branch_condition_false != -1) {
          if (line_number >= code_block.code_branch.branch_condition_false) {
            recursions[code_block.code_branch.branch_condition_false].emplace(line_number);
          }
        }
        if (!code_block.code_switch.switch_condition.empty()) {
          if (line_number >= code_block.code_switch.case_default) {
            recursions[code_block.code_switch.case_default].emplace(line_number);
          }
          for (const auto& [case_value, case_function] : code_block.code_switch.case_values) {
            if (line_number >= case_function) {
              recursions[case_function].emplace(line_number);
            }
          }
        }
      }

      return recursions;
    }

    // Compute predecessors for each block
    auto ComputePredecessors() {
      std::map<int, std::set<int>> preds;
      for (const auto& [line_number, code_block] : code_blocks) {
        if (code_block.code_branch.branch_condition_true > 0) {
          preds[code_block.code_branch.branch_condition_true].insert(line_number);
        }
        if (code_block.code_branch.branch_condition_false > 0) {
          preds[code_block.code_branch.branch_condition_false].insert(line_number);
        }
        if (!code_block.code_switch.switch_condition.empty()) {
          preds[code_block.code_switch.case_default].insert(line_number);
          for (const auto& [case_value, case_function] : code_block.code_switch.case_values) {
            preds[case_function].insert(line_number);
          }
        }
      }
      return preds;
    }

    // Compute immediate dominators using iterative dataflow algorithm
    // Returns map: block -> immediate dominator
    auto ComputeDominators() {
      std::map<int, int> idom;
      auto preds = ComputePredecessors();

      // Get sorted block numbers
      std::vector<int> block_order;
      for (const auto& [line_number, _] : code_blocks) {
        block_order.push_back(line_number);
      }
      std::sort(block_order.begin(), block_order.end());

      if (block_order.empty()) return idom;

      int entry = block_order[0];
      idom[entry] = entry;  // entry dominates itself

      // Intersect function for dominator computation
      auto intersect = [&](int b1, int b2) -> int {
        auto finger1 = b1;
        auto finger2 = b2;
        while (finger1 != finger2) {
          while (finger1 > finger2) {
            finger1 = idom[finger1];
          }
          while (finger2 > finger1) {
            finger2 = idom[finger2];
          }
        }
        return finger1;
      };

      bool changed = true;
      while (changed) {
        changed = false;
        for (int b : block_order) {
          if (b == entry) continue;
          int new_idom = -1;
          if (preds.contains(b)) {
            for (int p : preds[b]) {
              if (!idom.contains(p)) continue;  // not yet processed
              if (new_idom == -1) {
                new_idom = p;
              } else {
                new_idom = intersect(new_idom, p);
              }
            }
          }
          if (new_idom != -1 && (!idom.contains(b) || idom[b] != new_idom)) {
            idom[b] = new_idom;
            changed = true;
          }
        }
      }

      return idom;
    }

    // Compute full dominator sets for every block.
    // Returns map: block -> set of all blocks that dominate it (including itself).
    auto ListDominators() {
      std::map<int, std::set<int>> dom_sets;
      auto idom = ComputeDominators();
      for (const auto& [block, _] : code_blocks) {
        std::set<int>& s = dom_sets[block];
        int cur = block;
        while (true) {
          s.insert(cur);
          if (!idom.contains(cur)) break;
          int next = idom.at(cur);
          if (next == cur) break;
          cur = next;
        }
      }
      return dom_sets;
    }

    // Check if block 'a' dominates block 'b'
    static bool Dominates(const std::map<int, int>& idom, int a, int b) {
      int current = b;
      while (current != a) {
        if (!idom.contains(current)) return false;
        int next = idom.at(current);
        if (next == current) return false;  // reached entry without finding 'a'
        current = next;
      }
      return true;
    }

    // Compute successors for each block
    auto ComputeSuccessors() {
      std::map<int, std::set<int>> succs;
      for (const auto& [line_number, code_block] : code_blocks) {
        if (code_block.code_branch.branch_condition_true > 0) {
          succs[line_number].insert(code_block.code_branch.branch_condition_true);
        }
        if (code_block.code_branch.branch_condition_false > 0) {
          succs[line_number].insert(code_block.code_branch.branch_condition_false);
        }
        if (!code_block.code_switch.switch_condition.empty()) {
          succs[line_number].insert(code_block.code_switch.case_default);
          for (const auto& [case_value, case_function] : code_block.code_switch.case_values) {
            succs[line_number].insert(case_function);
          }
        }
      }
      return succs;
    }

    // Compute immediate post-dominators using iterative dataflow on reverse CFG.
    // Returns map: block -> immediate post-dominator.
    // loop_back_edges: map of loop_header -> set of back-edge source blocks.
    // Back edges are removed from the successor graph so that post-dominators
    // are meaningful inside infinite loops (while(true)).
    auto ComputePostDominators(const std::map<int, std::set<int>>& loop_back_edges = {}) {
      std::map<int, int> ipdom;
      auto succs = ComputeSuccessors();

      // Remove back edges from the successor graph.
      // A back edge is source -> header where source is in loop_back_edges[header].
      for (const auto& [header, sources] : loop_back_edges) {
        for (int src : sources) {
          if (succs.contains(src)) {
            succs[src].erase(header);
          }
        }
      }

      std::vector<int> block_order;
      for (const auto& [line_number, _] : code_blocks) {
        block_order.push_back(line_number);
      }
      std::sort(block_order.begin(), block_order.end());

      if (block_order.empty()) return ipdom;

      // Find exit blocks (blocks with no successors after back-edge removal)
      std::set<int> exit_blocks;
      for (int b : block_order) {
        if (!succs.contains(b) || succs[b].empty()) {
          exit_blocks.insert(b);
        }
      }
      // If no natural exits, use the last block
      if (exit_blocks.empty()) {
        exit_blocks.insert(block_order.back());
      }

      // Add a virtual exit node that all exit blocks point to
      int virtual_exit = block_order.back() + 1;
      ipdom[virtual_exit] = virtual_exit;
      for (int e : exit_blocks) {
        ipdom[e] = virtual_exit;
      }

      // Intersect on reverse post-order (descending block numbers)
      auto intersect = [&](int b1, int b2) -> int {
        auto finger1 = b1;
        auto finger2 = b2;
        while (finger1 != finger2) {
          while (finger1 < finger2) {
            if (!ipdom.contains(finger1)) return -1;
            finger1 = ipdom[finger1];
          }
          while (finger2 < finger1) {
            if (!ipdom.contains(finger2)) return -1;
            finger2 = ipdom[finger2];
          }
        }
        return finger1;
      };

      bool changed = true;
      while (changed) {
        changed = false;
        // Process in ascending order for post-dominators
        // (reverse post-order of the reverse CFG ≈ ascending block numbers)
        for (int i = 0; i < static_cast<int>(block_order.size()); i++) {
          int b = block_order[i];
          if (exit_blocks.contains(b)) continue;
          int new_ipdom = -1;
          if (succs.contains(b)) {
            for (int s : succs[b]) {
              if (!ipdom.contains(s)) continue;
              if (new_ipdom == -1) {
                new_ipdom = s;
              } else {
                new_ipdom = intersect(new_ipdom, s);
                if (new_ipdom == -1) break;
              }
            }
          }
          if (new_ipdom != -1 && (!ipdom.contains(b) || ipdom[b] != new_ipdom)) {
            ipdom[b] = new_ipdom;
            changed = true;
          }
        }
      }

      // Remove virtual exit from results
      ipdom.erase(virtual_exit);
      for (auto& [b, pd] : ipdom) {
        if (pd == virtual_exit) pd = -1;
      }

      return ipdom;
    }

    // Find the nearest common post-dominator of two blocks.
    static int NearestCommonPostDominator(const std::map<int, int>& ipdom, int a, int b) {
      // Walk up both post-dominator chains until they meet
      std::set<int> a_chain;
      int current = a;
      while (current != -1) {
        a_chain.insert(current);
        if (!ipdom.contains(current)) break;
        int next = ipdom.at(current);
        if (next == current) break;
        current = next;
      }
      current = b;
      while (current != -1) {
        if (a_chain.contains(current)) return current;
        if (!ipdom.contains(current)) break;
        int next = ipdom.at(current);
        if (next == current) break;
        current = next;
      }
      return -1;
    }

    // Check if block 'start' can bypass block 'candidate' — i.e., reach a
    // block after 'candidate' without going through 'candidate'.
    // Uses the successor graph with back edges removed.
    // Returns true if 'start' can bypass 'candidate'.
    bool CanBypass(int start, int candidate,
                   const std::map<int, std::set<int>>& succs_no_backedge) {
      if (start == candidate) return false;

      // Find successors of candidate (what's "after" it)
      std::set<int> after_candidate;
      if (succs_no_backedge.contains(candidate)) {
        for (int s : succs_no_backedge.at(candidate)) {
          after_candidate.insert(s);
        }
      }
      if (after_candidate.empty()) return false;

      // BFS from start, avoiding candidate
      std::set<int> visited;
      std::vector<int> queue = {start};
      while (!queue.empty()) {
        int node = queue.back();
        queue.pop_back();
        if (node == candidate) continue;  // don't go through candidate
        if (visited.contains(node)) continue;
        visited.insert(node);
        if (after_candidate.contains(node)) return true;  // bypassed!
        if (succs_no_backedge.contains(node)) {
          for (int s : succs_no_backedge.at(node)) {
            queue.push_back(s);
          }
        }
      }
      return false;
    }

    // Find the convergence point for two branches using BFS on the
    // back-edge-free CFG. Returns the first block reachable from both
    // branches, which is the correct convergence point.
    static int FindPairConvergence(
        int branch_a, int branch_b,
        const std::map<int, std::set<int>>& succs_no_backedge) {
      if (branch_a == branch_b) return branch_a;

      // BFS from both branches simultaneously
      std::map<int, int> reached_by;  // block -> bitmask (1=a, 2=b, 3=both)
      std::deque<std::pair<int, int>> queue;  // (block, origin_bit)

      auto enqueue = [&](int block, int origin) {
        int prev = reached_by.count(block) ? reached_by[block] : 0;
        if ((prev & origin) == origin) return;  // already reached by this origin
        reached_by[block] = prev | origin;
        if (reached_by[block] == 3) return;  // both reached — don't expand further
        queue.push_back({block, origin});
      };

      // Helper: check if 'src' can reach 'target' without going through 'avoid'
      auto can_reach_avoiding = [&](int src, int target, int avoid) -> bool {
        std::set<int> visited;
        std::deque<int> q;
        q.push_back(src);
        while (!q.empty()) {
          int n = q.front(); q.pop_front();
          if (n == target) return true;
          if (n == avoid || visited.count(n)) continue;
          visited.insert(n);
          if (succs_no_backedge.contains(n)) {
            for (int s : succs_no_backedge.at(n)) {
              q.push_back(s);
            }
          }
        }
        return false;
      };

      enqueue(branch_a, 1);
      enqueue(branch_b, 2);

      while (!queue.empty()) {
        auto [node, origin] = queue.front();
        queue.pop_front();
        if (succs_no_backedge.contains(node)) {
          for (int s : succs_no_backedge.at(node)) {
            enqueue(s, origin);
            if (reached_by.count(s) && reached_by[s] == 3) {
              // If the convergence candidate is one of the branch targets,
              // check if the other branch can bypass it. If so, the candidate
              // is not a true convergence — one path can skip it entirely.
              if (s == branch_a && succs_no_backedge.contains(branch_a)) {
                // Check if branch_b can reach any successor of branch_a
                // without going through branch_a itself
                bool can_bypass = false;
                for (int succ_a : succs_no_backedge.at(branch_a)) {
                  if (can_reach_avoiding(branch_b, succ_a, branch_a)) {
                    can_bypass = true;
                    break;
                  }
                }
                if (can_bypass) continue;  // skip this candidate
              }
              if (s == branch_b && succs_no_backedge.contains(branch_b)) {
                bool can_bypass = false;
                for (int succ_b : succs_no_backedge.at(branch_b)) {
                  if (can_reach_avoiding(branch_a, succ_b, branch_b)) {
                    can_bypass = true;
                    break;
                  }
                }
                if (can_bypass) continue;
              }
              return s;
            }
          }
        }
      }
      return -1;
    }

    // Compute natural loops using dominator info
    // Only back edges where the header dominates the source form natural loops
    // Returns: map of loop_header -> set of back-edge source blocks (same format as ListRecursions)
    auto ListNaturalLoops() {
      auto idom = ComputeDominators();
      std::map<int, std::set<int>> natural_loops;

      for (const auto& [line_number, code_block] : code_blocks) {
        auto check_back_edge = [&](int target) {
          if (target <= 0 || target > line_number) return;  // not a back edge
          // It's a back edge: line_number -> target (backward)
          // Natural loop only if target dominates line_number
          if (Dominates(idom, target, line_number)) {
            natural_loops[target].insert(line_number);
          }
        };

        if (code_block.code_branch.branch_condition_true != -1) {
          check_back_edge(code_block.code_branch.branch_condition_true);
        }
        if (code_block.code_branch.branch_condition_false != -1) {
          check_back_edge(code_block.code_branch.branch_condition_false);
        }
        if (!code_block.code_switch.switch_condition.empty()) {
          check_back_edge(code_block.code_switch.case_default);
          for (const auto& [case_value, case_function] : code_block.code_switch.case_values) {
            check_back_edge(case_function);
          }
        }
      }

      return natural_loops;
    }

    // Compute the set of blocks belonging to each natural loop body.
    // A block is in the loop body if it's on a path from the header to any
    // back-edge source. Uses the standard reverse-walk algorithm: start from
    // each back-edge source and walk predecessors until reaching the header.
    // Returns: map of loop_header -> set of blocks in the loop body (includes header).
    auto ComputeLoopBodies(const std::map<int, std::set<int>>& natural_loops) {
      std::map<int, std::set<int>> loop_bodies;
      auto preds = ComputePredecessors();

      for (const auto& [header, back_edge_sources] : natural_loops) {
        std::set<int>& body = loop_bodies[header];
        body.insert(header);

        // Reverse walk from each back-edge source
        std::vector<int> worklist;
        for (int src : back_edge_sources) {
          if (src != header) {
            body.insert(src);
            worklist.push_back(src);
          }
        }

        while (!worklist.empty()) {
          int block = worklist.back();
          worklist.pop_back();
          if (!preds.contains(block)) continue;
          for (int pred : preds[block]) {
            if (!body.contains(pred)) {
              body.insert(pred);
              worklist.push_back(pred);
            }
          }
        }
      }

      return loop_bodies;
    }

    // ===== Methods needed for --structural code path =====

    std::vector<int> ListSuccessors(const CodeBlock& code_block) const {
      std::vector<int> successors;
      if (code_block.code_branch.branch_condition_true != -1) {
        successors.push_back(code_block.code_branch.branch_condition_true);
      }
      if (code_block.code_branch.branch_condition_false != -1) {
        successors.push_back(code_block.code_branch.branch_condition_false);
      }
      if (!code_block.code_switch.switch_condition.empty()) {
        successors.push_back(code_block.code_switch.case_default);
        for (const auto& [case_value, case_function] : code_block.code_switch.case_values) {
          successors.push_back(case_function);
        }
      }
      return successors;
    }

    std::vector<int> ListNormalizedSuccessors(const CodeBlock& code_block) const {
      auto successors = ListSuccessors(code_block);
      std::erase_if(successors, [&](int successor) {
        return successor < 0 || !code_blocks.contains(successor);
      });
      std::ranges::sort(successors);
      successors.erase(std::unique(successors.begin(), successors.end()), successors.end());
      return successors;
    }

    auto ListPredecessorsVec() const {
      std::map<int, std::vector<int>> predecessors;
      for (const auto& [line_number, code_block] : code_blocks) {
        predecessors[line_number];
      }
      for (const auto& [line_number, code_block] : code_blocks) {
        for (const auto successor : ListNormalizedSuccessors(code_block)) {
          predecessors[successor].push_back(line_number);
        }
      }
      return predecessors;
    }

    auto ListPostDominators() const {
      std::map<int, std::set<int>> postdominators;
      std::set<int> all_blocks;
      for (const auto& [line_number, code_block] : code_blocks) {
        all_blocks.emplace(line_number);
      }
      for (const auto& [line_number, code_block] : code_blocks) {
        auto successors = ListNormalizedSuccessors(code_block);
        if (successors.empty()) {
          postdominators[line_number] = {line_number};
        } else {
          postdominators[line_number] = all_blocks;
        }
      }
      bool changed = true;
      while (changed) {
        changed = false;
        for (const auto& [line_number, code_block] : code_blocks) {
          auto successors = ListNormalizedSuccessors(code_block);
          std::set<int> next_postdominators = {line_number};
          if (!successors.empty()) {
            auto intersection = postdominators.at(successors.front());
            for (auto successor_it = successors.begin() + 1; successor_it != successors.end(); ++successor_it) {
              std::set<int> next_intersection;
              const auto& successor_postdominators = postdominators.at(*successor_it);
              std::set_intersection(intersection.begin(), intersection.end(),
                                    successor_postdominators.begin(), successor_postdominators.end(),
                                    std::inserter(next_intersection, next_intersection.begin()));
              intersection = std::move(next_intersection);
            }
            next_postdominators.insert(intersection.begin(), intersection.end());
          }
          if (next_postdominators != postdominators[line_number]) {
            postdominators[line_number] = std::move(next_postdominators);
            changed = true;
          }
        }
      }
      return postdominators;
    }

    auto ListImmediatePostDominators(const std::map<int, std::set<int>>& postdominators) const {
      std::map<int, int> immediate_postdominators;
      for (const auto& [line_number, dominator_set] : postdominators) {
        std::vector<int> strict_postdominators;
        strict_postdominators.reserve(dominator_set.size());
        for (const auto postdominator : dominator_set) {
          if (postdominator != line_number) {
            strict_postdominators.push_back(postdominator);
          }
        }
        for (const auto candidate : strict_postdominators) {
          const auto& candidate_set = postdominators.at(candidate);
          bool is_immediate = true;
          for (const auto other : strict_postdominators) {
            if (other == candidate) continue;
            if (!candidate_set.contains(other)) {
              is_immediate = false;
              break;
            }
          }
          if (is_immediate) {
            immediate_postdominators[line_number] = candidate;
            break;
          }
        }
      }
      return immediate_postdominators;
    }

    bool RegionNeedsConvergenceWrapper(
        int start_line_number,
        int region_convergence,
        const std::vector<int>& outer_convergences) const {
      if (outer_convergences.empty() || start_line_number < 0) {
        return false;
      }
      std::set<int> visited;
      std::vector<int> pending = {start_line_number};
      while (!pending.empty()) {
        int current_line_number = pending.back();
        pending.pop_back();
        if (current_line_number == region_convergence) {
          continue;
        }
        if (std::ranges::find(outer_convergences, current_line_number) != outer_convergences.end()) {
          return true;
        }
        if (!visited.emplace(current_line_number).second) {
          continue;
        }
        auto code_block = code_blocks.find(current_line_number);
        if (code_block == code_blocks.end()) {
          continue;
        }
        for (const auto successor : ListSuccessors(code_block->second)) {
          if (successor == -1 || successor == region_convergence) {
            continue;
          }
          if (std::ranges::find(outer_convergences, successor) != outer_convergences.end()) {
            return true;
          }
          pending.push_back(successor);
        }
      }
      return false;
    }

    struct BranchLadderPlan {
      int root = -1;
      bool false_chain = false;
      std::vector<int> blocks;
      std::vector<int> exits;
    };

    struct BranchLadderIndex {
      std::map<int, BranchLadderPlan> ladders;
      std::unordered_map<int, int> owner;
    };

    std::optional<BranchLadderPlan> DetectBranchLadder(
        int root,
        bool false_chain,
        const std::map<int, std::vector<int>>& predecessors,
        const std::map<int, int>& immediate_postdominators) const {
      auto root_it = code_blocks.find(root);
      if (root_it == code_blocks.end()) {
        return std::nullopt;
      }
      if (root_it->second.code_branch.branch_condition.empty()) {
        return std::nullopt;
      }
      auto ipdom_it = immediate_postdominators.find(root);
      if (ipdom_it == immediate_postdominators.end()) {
        return std::nullopt;
      }
      const auto root_ipdom = ipdom_it->second;
      BranchLadderPlan ladder{.root = root, .false_chain = false_chain};
      std::set<int> visited;
      int current = root;
      while (true) {
        if (!visited.emplace(current).second) {
          return std::nullopt;
        }
        auto current_it = code_blocks.find(current);
        if (current_it == code_blocks.end()) {
          return std::nullopt;
        }
        const auto& code_block = current_it->second;
        if (code_block.code_branch.branch_condition.empty()) {
          return std::nullopt;
        }
        ladder.blocks.push_back(current);
        int chain_target = false_chain ? code_block.code_branch.branch_condition_false : code_block.code_branch.branch_condition_true;
        int side_target = false_chain ? code_block.code_branch.branch_condition_true : code_block.code_branch.branch_condition_false;
        ladder.exits.push_back(side_target);
        auto next_it = code_blocks.find(chain_target);
        if (next_it == code_blocks.end() || next_it->second.code_branch.branch_condition.empty()) {
          ladder.exits.push_back(chain_target);
          break;
        }
        auto predecessor_it = predecessors.find(chain_target);
        if (predecessor_it == predecessors.end() || predecessor_it->second.size() != 1) {
          ladder.exits.push_back(chain_target);
          break;
        }
        auto next_ipdom_it = immediate_postdominators.find(chain_target);
        if (next_ipdom_it == immediate_postdominators.end() || next_ipdom_it->second != root_ipdom) {
          ladder.exits.push_back(chain_target);
          break;
        }
        current = chain_target;
      }
      if (ladder.blocks.size() < 3) {
        return std::nullopt;
      }
      return ladder;
    }

    BranchLadderIndex BuildBranchLadderIndex(
        const std::map<int, std::vector<int>>& predecessors,
        const std::map<int, int>& immediate_postdominators) const {
      BranchLadderIndex index;
      for (const auto& [line_number, code_block] : code_blocks) {
        if (index.owner.contains(line_number) || code_block.code_branch.branch_condition.empty()) {
          continue;
        }
        auto false_ladder = DetectBranchLadder(line_number, true, predecessors, immediate_postdominators);
        auto true_ladder = DetectBranchLadder(line_number, false, predecessors, immediate_postdominators);
        auto chosen = [&]() -> std::optional<BranchLadderPlan> {
          if (false_ladder.has_value() && true_ladder.has_value()) {
            return false_ladder->blocks.size() >= true_ladder->blocks.size() ? false_ladder : true_ladder;
          }
          if (false_ladder.has_value()) return false_ladder;
          if (true_ladder.has_value()) return true_ladder;
          return std::nullopt;
        }();
        if (!chosen.has_value()) {
          continue;
        }
        bool overlaps = false;
        for (const auto block : chosen->blocks) {
          if (index.owner.contains(block)) {
            overlaps = true;
            break;
          }
        }
        if (overlaps) {
          continue;
        }
        index.ladders.emplace(line_number, *chosen);
        for (const auto block : chosen->blocks) {
          index.owner.emplace(block, line_number);
        }
      }
      return index;
    }

    struct BranchStructurePlan {
      std::string shape;
      int convergence = -1;
      int then_target = -1;
      int else_target = -1;
      size_t test_count = 0;
      size_t else_if_count = 0;
      size_t arm_count = 0;
      bool has_else = false;
      std::set<int> exits;
    };

    std::optional<BranchStructurePlan> AnalyzeBranchStructure(
        int line_number,
        const std::map<int, int>& immediate_postdominators,
        const BranchLadderIndex& ladder_index) const {
      auto code_block_it = code_blocks.find(line_number);
      if (code_block_it == code_blocks.end()) {
        return std::nullopt;
      }
      const auto& code_block = code_block_it->second;
      if (code_block.code_branch.branch_condition.empty()) {
        return std::nullopt;
      }
      BranchStructurePlan plan;
      if (auto ipdom_it = immediate_postdominators.find(line_number);
          ipdom_it != immediate_postdominators.end()) {
        plan.convergence = ipdom_it->second;
      }
      if (auto ladder_it = ladder_index.ladders.find(line_number);
          ladder_it != ladder_index.ladders.end()) {
        const auto& ladder = ladder_it->second;
        std::set<int> member_blocks(ladder.blocks.begin(), ladder.blocks.end());
        for (const auto block : ladder.blocks) {
          for (const auto successor : ListNormalizedSuccessors(code_blocks.at(block))) {
            if (!member_blocks.contains(successor)) {
              plan.exits.emplace(successor);
            }
          }
        }
        plan.shape = "if-ladder";
        plan.test_count = ladder.blocks.size();
        plan.else_if_count = plan.test_count > 0 ? plan.test_count - 1 : 0;
        plan.arm_count = plan.test_count;
        if (!ladder.exits.empty()) {
          auto final_exit = ladder.exits.back();
          if (final_exit > 0 && final_exit != plan.convergence) {
            plan.has_else = true;
            ++plan.arm_count;
          }
        }
        return plan;
      }
      plan.then_target = code_block.code_branch.branch_condition_true;
      plan.else_target = code_block.code_branch.branch_condition_false;
      if (plan.then_target == plan.convergence && plan.else_target == plan.convergence) {
        plan.shape = "if";
        plan.test_count = 1;
        plan.arm_count = 0;
        return plan;
      }
      if (plan.then_target == plan.convergence || plan.else_target == plan.convergence) {
        plan.shape = "if";
        plan.test_count = 1;
        plan.arm_count = 1;
        return plan;
      }
      plan.shape = "if/else";
      plan.test_count = 1;
      plan.arm_count = 2;
      plan.has_else = true;
      return plan;
    }

#include "shader_decompiler/mermaid.hpp"
  };

  PreprocessState preprocess_state;
  std::vector<std::string_view> source_lines;
  std::vector<std::string_view> output_lines;
  size_t line_number = 0;
  TokenizerState state = TokenizerState::START;
  size_t input_sig_section_count = 0;
  size_t output_sig_section_count = 0;
  std::vector<SignaturePacked> input_sigs_packed;
  std::vector<SignaturePacked> output_sigs_packed;
  std::vector<SignatureProperty> input_sigs_property;
  std::vector<SignatureProperty> output_sigs_property;
  bool created_signatures = false;
  std::vector<std::string_view> pipeline_infos;
  std::vector<std::string_view> view_id_state_info;
  std::string_view sha256_hash;
  BufferDefinition* current_buffer_definition;
  size_t current_buffer_definition_depth = 0;

  std::vector<CodeFunction> code_functions;
  CodeFunction* current_code_function;
  std::map<std::string_view, std::vector<std::string_view>> named_metadata;

  static void CreateSignatures(
      std::span<SignaturePacked> src_packed,
      std::span<SignatureProperty> src_property,
      std::vector<Signature>& destination) {
    destination.clear();
    // DXIL inputSigId/outputSigId indexes by property order, not packed order.
    // Iterate property entries and find the matching packed entry for each.
    for (const auto& property : src_property) {
      SignaturePacked best_packed;
      bool found = false;
      for (const auto& packed : src_packed) {
        if (packed.name != property.name) continue;
        if (packed.index == property.index) {
          // Exact match
          best_packed = packed;
          found = true;
          break;
        }
        if (packed.index >= property.index) {
          // Array match — this property covers a range of packed indices
          if (!found || packed.index < best_packed.index) {
            best_packed = packed;
            found = true;
          }
        }
      }
      if (!found) {
        throw std::runtime_error(std::format("Could not find packed signature for property: {} index {}", property.name, property.index));
      }
      destination.emplace_back(best_packed, property);
    }
  }

  void Init() {
    this->line_number = 0;
    this->state = TokenizerState::START;
    this->input_sig_section_count = 0;
    this->output_sig_section_count = 0;
    this->input_sigs_packed.clear();
    this->output_sigs_packed.clear();
    this->input_sigs_property.clear();
    this->output_sigs_property.clear();
    this->preprocess_state.input_signature.clear();
    this->preprocess_state.output_signature.clear();
    this->preprocess_state.resource_descriptions.clear();
    this->preprocess_state.global_variables.clear();
    this->preprocess_state.resource_binding_variables.clear();
    this->preprocess_state.type_definitions.clear();
    this->preprocess_state.buffer_definitions.clear();
    this->pipeline_infos.clear();
    this->view_id_state_info.clear();
    this->sha256_hash = "";
    this->current_buffer_definition = nullptr;
    this->current_buffer_definition_depth = 0;
    this->code_functions.clear();
    this->current_code_function = nullptr;
    this->output_lines.clear();
  }

 public:
  struct DecompileOptions {
    bool flatten = false;
    bool use_do_while = false;
    bool stackify = false;
    bool structural = false;  // ShortFuse-style structural analysis
    bool mermaid = false;     // Output Mermaid flowchart instead of HLSL
    bool annotate = false;    // Emit developer-friendly annotation comments
    bool annotate_mermaid = false;  // Emit full graph IR dump (nodes, edges, phi assignments)
    bool mermaid_decompile = false;  // Mermaid-based region decompilation strategy
    bool no_single_use_inline = false;  // Disable single-use variable inlining (keeps expressions readable and matches original DXIL SSA structure)
  };

  std::string Decompile(std::string_view disassembly, DecompileOptions decompile_options = {
                                                          .flatten = false,
                                                          .use_do_while = false,
                                                          .stackify = false,
                                                          .structural = false,
                                                          .mermaid = false,
                                                          .annotate = false,
                                                          .annotate_mermaid = false,
                                                          .mermaid_decompile = false,
                                                          .no_single_use_inline = false,
                                                      }) {
    Init();
    // --structural implies --use-do-while for convergence wrappers and --flatten
    if (decompile_options.structural) {
      decompile_options.use_do_while = true;
      decompile_options.flatten = true;
    }
    // --mermaid-decompile implies --flatten for OptimizeString (lerp/pow patterns)
    // but NOT single-use variable inlining, which conflicts with region functions
    // (inlined variables become unavailable across function boundaries).
    if (decompile_options.mermaid_decompile) {
      decompile_options.flatten = true;
    }
    // --annotate-mermaid implies --annotate (block annotations are a superset)
    if (decompile_options.annotate_mermaid) {
      decompile_options.annotate = true;
    }
    this->source_lines = StringViewSplitAll(disassembly, '\n');

    // Pre-scan: identify handle variables used with dynamic cbuffer access
    // (extractvalue on a static load may appear before the dynamic load that marks it)
    {
      static auto dynamic_cbuf_regex = std::regex(
          R"(call %dx\.types\.CBufRet\.\w+ @dx\.op\.cbufferLoadLegacy\.\w+\(i32 \d+, %dx\.types\.Handle (%\d+), i32 %)"
      );
      for (const auto& src_line : this->source_lines) {
        std::match_results<std::string_view::const_iterator> match;
        if (std::regex_search(src_line.begin(), src_line.end(), match, dynamic_cbuf_regex)) {
          preprocess_state.cbv_handles_with_dynamic_access.insert(match[1].str());
        }
      }
    }

    const std::string_view line;
    while (state != TokenizerState::COMPLETE) {
      std::string_view line = StringViewTrimEnd(source_lines.at(line_number));
      auto prestate = state;
      try {
        switch (state) {
          case TokenizerState::START:
            if (line == ";") {
              state = TokenizerState::DESCRIPTION_WHITESPACE;
            } else if (line == "") {
              state = TokenizerState::WHITESPACE;
            } else {
              throw std::runtime_error("Unexpected start of file");
            }
            break;
          case TokenizerState::DESCRIPTION_WHITESPACE:
            if (line == "" || line[0] != ';') {
              state = TokenizerState::WHITESPACE;
            } else if (line == ";") {
              line_number++;
            } else if (line == "; Input signature:") {
              if (input_sig_section_count == 0u) {
                state = TokenizerState::DESCRIPTION_INPUT_SIG_TITLE;
                input_sig_section_count++;
              } else {
                state = TokenizerState::DESCRIPTION_INPUT_SIG2_TITLE;
              }
            } else if (line == "; Output signature:") {
              if (output_sig_section_count == 0u) {
                state = TokenizerState::DESCRIPTION_OUTPUT_SIG_TITLE;
                output_sig_section_count++;
              } else {
                state = TokenizerState::DESCRIPTION_OUTPUT_SIG2_TITLE;
              }
            } else if (line.starts_with("; shader hash:")) {
              state = TokenizerState::DESCRIPTION_SHADER_HASH;
            } else if (line.starts_with("; shader debug name:")) {
              state = TokenizerState::DESCRIPTION_SHADER_HASH;
            } else if (line == "; Pipeline Runtime Information:") {
              state = TokenizerState::DESCRIPTION_PIPELINE_RUNTIME_TITLE;
            } else if (line == "; Buffer Definitions:") {
              state = TokenizerState::DESCRIPTION_BUFFER_DEFINITION_TITLE;
            } else if (line == "; Resource Bindings:") {
              state = TokenizerState::DESCRIPTION_RESOURCE_BINDINGS_TITLE;
            } else if (line == "; ViewId state:") {
              state = TokenizerState::DESCRIPTION_VIEW_ID_STATE_TITLE;
            } else if (line == "; Note: shader requires additional functionality:") {
              state = TokenizerState::DESCRIPTION_FUNCTIONALITY_NOTE;
            } else {
              throw std::runtime_error("Unexpected description entry");
            }
            break;
          case TokenizerState::DESCRIPTION_INPUT_SIG_TITLE:
          case TokenizerState::DESCRIPTION_INPUT_SIG_WHITESPACE:
          case TokenizerState::DESCRIPTION_INPUT_SIG_TABLE_HEADER:
          case TokenizerState::DESCRIPTION_INPUT_SIG_TABLE_DIVIDER:
            state++;
            line_number++;
            break;
          case TokenizerState::DESCRIPTION_FUNCTIONALITY_NOTE:
            if (line == ";") {
              state = TokenizerState::DESCRIPTION_WHITESPACE;
            }
            line_number++;
            break;
          case TokenizerState::DESCRIPTION_INPUT_SIG_TABLE_ROW:
            if (line == ";") {
              state = TokenizerState::DESCRIPTION_WHITESPACE;
            } else {
              if (line != "; no parameters") {
                input_sigs_packed.emplace_back(line);
              }
              line_number++;
            }
            break;
          case TokenizerState::DESCRIPTION_INPUT_SIG_TABLE_END:
            break;
          case TokenizerState::DESCRIPTION_OUTPUT_SIG_TITLE:
          case TokenizerState::DESCRIPTION_OUTPUT_SIG_WHITESPACE:
          case TokenizerState::DESCRIPTION_OUTPUT_SIG_TABLE_HEADER:
          case TokenizerState::DESCRIPTION_OUTPUT_SIG_TABLE_DIVIDER:
            state++;
            line_number++;
            break;
          case TokenizerState::DESCRIPTION_OUTPUT_SIG_TABLE_ROW:
            if (line == ";") {
              state = TokenizerState::DESCRIPTION_WHITESPACE;
            } else if (line == "; no parameters") {
              state = TokenizerState::DESCRIPTION_WHITESPACE;
              line_number++;
            } else {
              output_sigs_packed.emplace_back(line);
              line_number++;
            }
            break;
          case TokenizerState::DESCRIPTION_OUTPUT_SIG_TABLE_END:
            break;
          case TokenizerState::DESCRIPTION_SHADER_HASH:
            sha256_hash = line.substr(strlen("; shader hash: "));
            state = TokenizerState::DESCRIPTION_WHITESPACE;
            line_number++;
            break;
          case TokenizerState::DESCRIPTION_SHADER_DEBUG_NAME:
          case TokenizerState::DESCRIPTION_PIPELINE_RUNTIME_TITLE:
          case TokenizerState::DESCRIPTION_PIPELINE_RUNTIME_WHITESPACE:
            state++;
            line_number++;
            break;
          case TokenizerState::DESCRIPTION_PIPELINE_RUNTIME_INFO:
            if (line == ";") {
              state = TokenizerState::DESCRIPTION_WHITESPACE;
            } else {
              pipeline_infos.push_back(line);
              line_number++;
            }
            break;
          case TokenizerState::DESCRIPTION_PIPELINE_RUNTIME_END:
            break;
          case TokenizerState::DESCRIPTION_INPUT_SIG2_TITLE:
          case TokenizerState::DESCRIPTION_INPUT_SIG2_WHITESPACE:
          case TokenizerState::DESCRIPTION_INPUT_SIG2_TABLE_HEADER:
          case TokenizerState::DESCRIPTION_INPUT_SIG2_TABLE_DIVIDER:
            state++;
            line_number++;
            break;
          case TokenizerState::DESCRIPTION_INPUT_SIG2_TABLE_ROW:
            if (line == ";") {
              state = TokenizerState::DESCRIPTION_WHITESPACE;
            } else {
              input_sigs_property.emplace_back(line);
              line_number++;
            }
            break;
          case TokenizerState::DESCRIPTION_INPUT_SIG2_TABLE_END:

            break;
          case TokenizerState::DESCRIPTION_OUTPUT_SIG2_TITLE:
          case TokenizerState::DESCRIPTION_OUTPUT_SIG2_WHITESPACE:
          case TokenizerState::DESCRIPTION_OUTPUT_SIG2_TABLE_HEADER:
          case TokenizerState::DESCRIPTION_OUTPUT_SIG2_TABLE_DIVIDER:
            state++;
            line_number++;
            break;
          case TokenizerState::DESCRIPTION_OUTPUT_SIG2_TABLE_ROW:
            if (line == ";") {
              state = TokenizerState::DESCRIPTION_WHITESPACE;
            } else {
              output_sigs_property.emplace_back(line);
              line_number++;
            }
            break;
          case TokenizerState::DESCRIPTION_OUTPUT_SIG2_TABLE_END:
            break;
          case TokenizerState::DESCRIPTION_BUFFER_DEFINITION_TITLE:
          case TokenizerState::DESCRIPTION_BUFFER_DEFINITION_WHITESPACE:
            state++;
            line_number++;
            break;
          case TokenizerState::DESCRIPTION_BUFFER_DEFINITION_TYPE:
            if (line == ";") {
              state = TokenizerState::DESCRIPTION_BUFFER_DEFINITION_TYPE_COMPLETE;
            } else {
              current_buffer_definition = &preprocess_state.buffer_definitions.emplace_back(line);
              state++;
              line_number++;
            }
            break;
          case TokenizerState::DESCRIPTION_BUFFER_DEFINITION_TYPE_BLOCK_START:
            if (line != "; {") {
              throw std::runtime_error("Unexpected buffer definition block start");
            }
            state++;
            line_number++;
            break;
          case TokenizerState::DESCRIPTION_BUFFER_DEFINITION_TYPE_BLOCK:
            if (line == ";") {
              line_number++;
            } else if (line == "; }") {
              state = TokenizerState::DESCRIPTION_BUFFER_DEFINITION_TYPE_BLOCK_END;
            } else {
              current_buffer_definition->definitions.push_back(line);
              line_number++;
            }
            break;
          case TokenizerState::DESCRIPTION_BUFFER_DEFINITION_TYPE_BLOCK_END:
          case TokenizerState::DESCRIPTION_BUFFER_DEFINITION_TYPE_END:
            state++;
            line_number++;
            break;
          case TokenizerState::DESCRIPTION_BUFFER_DEFINITION_TYPE_COMPLETE:
            if (line == ";") {
              state = TokenizerState::DESCRIPTION_WHITESPACE;
            } else {
              state = TokenizerState::DESCRIPTION_BUFFER_DEFINITION_TYPE;
            }
            break;
          case TokenizerState::DESCRIPTION_RESOURCE_BINDINGS_TITLE:
          case TokenizerState::DESCRIPTION_RESOURCE_BINDINGS_WHITESPACE:
          case TokenizerState::DESCRIPTION_RESOURCE_BINDINGS_TABLE_HEADER:
          case TokenizerState::DESCRIPTION_RESOURCE_BINDINGS_TABLE_DIVIDER:
            state++;
            line_number++;
            break;
          case TokenizerState::DESCRIPTION_RESOURCE_BINDINGS_TABLE_ROW:
            if (line == ";") {
              state = TokenizerState::DESCRIPTION_WHITESPACE;
            } else {
              preprocess_state.resource_descriptions.emplace_back(line);
            }
            line_number++;
            break;
          case TokenizerState::DESCRIPTION_RESOURCE_BINDINGS_TABLE_END:
            break;
          case TokenizerState::DESCRIPTION_VIEW_ID_STATE_TITLE:
          case TokenizerState::DESCRIPTION_VIEW_ID_STATE_WHITESPACE:
            state++;
            line_number++;
          case TokenizerState::DESCRIPTION_VIEW_ID_STATE_INFO:
            if (line == ";") {
              state = TokenizerState::DESCRIPTION_WHITESPACE;
            } else {
              view_id_state_info.push_back(line);
              line_number++;
            }
            break;
          case TokenizerState::DESCRIPTION_VIEW_ID_STATE_END:
            break;
          case TokenizerState::TARGET_DATALAYOUT:
            // ignore for now
            state = TokenizerState::WHITESPACE;
            line_number++;
            break;
          case TokenizerState::TARGET_TRIPLE:
            state = TokenizerState::WHITESPACE;
            line_number++;
            break;
          case TokenizerState::WHITESPACE:
            if (!created_signatures) {
              CreateSignatures(input_sigs_packed, input_sigs_property, preprocess_state.input_signature);
              CreateSignatures(output_sigs_packed, output_sigs_property, preprocess_state.output_signature);
              created_signatures = true;
            };
            if (line.empty() || line[0] == '\0') {
              line_number++;
            } else if (line[0] == '%') {
              state = TokenizerState::TYPE_DEFINITION;
            } else if (line.starts_with("target datalayout")) {
              state = TokenizerState::TARGET_DATALAYOUT;
            } else if (line.starts_with("target triple")) {
              state = TokenizerState::TARGET_TRIPLE;
            } else if (line.starts_with("define")) {
              state = TokenizerState::CODE_DEFINE;
            } else if (line.starts_with("; Function Attrs:")) {
              state = TokenizerState::FUNCTION_DESCRIPTION;
            } else if (line.starts_with("declare")) {
              state = TokenizerState::FUNCTION_DECLARE;
            } else if (line.starts_with("attributes #")) {
              state = TokenizerState::FUNCTION_ATTRIBUTES;
            } else if (line.starts_with("@")) {
              state = TokenizerState::GLOBAL_VARIABLE;
            } else if (line.starts_with("!")) {
              state = TokenizerState::NAMED_METADATA;
            } else {
              throw std::runtime_error("Unexpected line");
            }
            break;
          case TokenizerState::TYPE_DEFINITION: {
            if (line.empty() || line[0] != '%') {
              preprocess_state.RecompileTypeDefinitions();
              state = TokenizerState::WHITESPACE;
            } else {
              auto type_definition = TypeDefinition(line);
              preprocess_state.type_definitions[type_definition.name] = type_definition;
              line_number++;
              state = TokenizerState::TYPE_DEFINITION;  // loop
            }
          } break;
          case TokenizerState::FUNCTION_DESCRIPTION:
          case TokenizerState::FUNCTION_DECLARE:
          case TokenizerState::FUNCTION_ATTRIBUTES:
            line_number++;
            state = TokenizerState::WHITESPACE;
            break;
          case TokenizerState::NAMED_METADATA: {
            // https://llvm.org/docs/LangRef.html#namedmetadatastructure
            // !5 = !{i32 0, %"class.Texture2D<vector<float, 4> >"* undef, !"", i32 0, i32 0, i32 1, i32 2, i32 0, !6}
            static auto regex = std::regex{R"(^(\S+) = !\{(.*)\}$)"};
            static auto values_regex = std::regex(R"(\s*([^,"]+(("[^"]*")[^,]*|)),?)");

            auto [variable_name, values_packed] = StringViewMatch<2>(line, regex);
            auto values = StringViewSplitAll(values_packed, values_regex, 1);
            auto len = values.size();
            // std::cout << values_packed << "\n";
            for (int i = 0; i < len; ++i) {
              values[i] = StringViewTrim(values[i]);
              // std::cout << values[i] << " | ";
            }
            // std::cout << "\n";
            this->named_metadata[variable_name] = values;

            line_number++;
            state = TokenizerState::WHITESPACE;
          } break;
          case TokenizerState::GLOBAL_VARIABLE: {
            // @C.i.22.i.i.95.i.0.hca = internal unnamed_addr constant [6 x float] [float -4.000000e+00, float -4.000000e+00, float 0xC009424EA0000000, float 0xBFDF0E5600000000, float 0x3FFD904FE0000000, float 0x3FFD904FE0000000]
            // @"\01?g_ToneMapRadianceSamples@@3PAMA" = external addrspace(3) global [128 x float], align 4
            // @"\01?shPixelsY@@3PAY0CG@$$CAMA.1dim" = addrspace(3) global [1444 x float] undef, align 4
            // @"\01?pixelOffsets@?1??DirectionalObscuranceCommon@@YA?AUSSDOOutput@@USSAOParams@@@Z@3QBV?$vector@M$01@@B.v.1dim" = internal constant [8 x float] [float -1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float -1.000000e+00, float -1.000000e+00, float -1.000000e+00], align 4

            static auto regex = std::regex{R"(^(\S+) = (?:(internal|external) )?(?:unnamed_addr )?(?:(addrspace\(\d+\)) )?(constant|global) (?:\[(\S+) x ([^\]]+)\]|(\S+))(?:,| \S+,| \S+$|(?: \[([^\]]+)\])| undef| zeroinitializer).*)"};
            auto [variable_name, scope, addr, qualifier, array_size, array_type, value_type, entries] = StringViewMatch<8>(line, regex);

            std::string output_name = std::format("_global_{}", preprocess_state.global_variables.size());

            std::stringstream decompiled;

            bool has_addrspace3 = (addr == "addrspace(3)");
            if (scope == "internal" && !has_addrspace3) {
              decompiled << "static const ";
            } else if (scope == "external" || scope == "" || has_addrspace3) {
              decompiled << "groupshared ";
            } else {
              throw std::runtime_error("Unknown global variable scope.");
            }
            bool is_groupshared = (scope == "external" || scope == "" || has_addrspace3);
            if (!array_type.empty()) {
              // Use uint for groupshared i32 arrays (atomic intrinsics need uint l-values)
              auto hlsl_array_type = (array_type == "i32") ? (is_groupshared ? std::string_view("uint") : std::string_view("int"))
                                   : (array_type == "i16") ? std::string_view("int16_t")
                                   : array_type;
              decompiled << hlsl_array_type << " ";
              decompiled << output_name;
              decompiled << "[" << array_size << "]";
            } else {
              auto hlsl_value_type = (value_type == "i32") ? (is_groupshared ? std::string_view("uint") : std::string_view("int"))
                                   : (value_type == "i16") ? std::string_view("int16_t")
                                   : value_type;
              decompiled << hlsl_value_type << " ";
              decompiled << output_name;
            }
            if (entries.empty()) {
              decompiled << ";";
            } else {
              auto values = StringViewSplitAll(entries, std::regex{R"((\s*(\S+) ([^\s,]+)),?)"}, {2, 3});
              decompiled << " = { ";

              int array_size_number;
              FromStringView(array_size, array_size_number);
              for (int i = 0; i < array_size_number; ++i) {
                if (array_type == "float") {
                  decompiled << ParseSuffixedString(values[i].second, 'f');
                } else if (array_type == "half") {
                  decompiled << ParseSuffixedString(values[i].second, 'h');
                } else if (array_type == "i32") {
                  decompiled << std::string(values[i].second);
                } else if (array_type == "i16") {
                  decompiled << std::string(values[i].second);
                } else {
                  decompiled << std::string(values[i].second);
                }
                if (i != array_size_number - 1) {
                  decompiled << ", ";
                }
              }
              decompiled << " };";
            }
            preprocess_state.global_variables[std::string{variable_name}] = output_name;
            preprocess_state.global_variables_decompiled.push_back(decompiled.str());

            state = TokenizerState::WHITESPACE;
            line_number++;
          } break;
          case TokenizerState::CODE_DEFINE:
            current_code_function = &code_functions.emplace_back(line);
            // current_code_function.lines.push_back(line);
            line_number++;
            state++;
            break;
          case TokenizerState::CODE_BLOCK:
            if (line == "}") {
              state = TokenizerState::CODE_END;
            } else {
              current_code_function->lines.push_back(line);
              line_number++;
            }
            break;
          case TokenizerState::CODE_END:
            state = TokenizerState::WHITESPACE;
            line_number++;
            break;
          default:
            break;
        }
#if DECOMPILER_DXC_DEBUG >= 2
        std::cout << prestate << ": " << line << std::endl;
#endif
      } catch (const std::invalid_argument& ex) {
        std::cerr << ex.what() << " at line: " << line_number + 1 << std::endl
                  << "  >>>" << line << "<<<" << std::endl;
        throw;
      } catch (const std::exception& ex) {
        std::cerr << ex.what() << " at line: " << line_number + 1 << std::endl
                  << "  >>>" << line << "<<<" << std::endl;
        throw;
      } catch (...) {
        std::cerr << "Unknown error at line: " << line_number + 1 << std::endl
                  << "  >>>" << line << "<<<" << std::endl;
        throw;
      }
      if (line_number == source_lines.size()) {
        state = TokenizerState::COMPLETE;
      }
    }

    // Resources
    auto resource_list_metadata = named_metadata["!dx.resources"];
    if (!resource_list_metadata.empty()) {
      auto resource_list_reference = resource_list_metadata[0];
      auto resource_list_key = resource_list_reference;
      auto resource_list = named_metadata[resource_list_key];

      auto srv_list_key = resource_list[0];
      auto uav_list_key = resource_list[1];
      auto cbv_list_key = resource_list[2];
      auto sampler_list_key = resource_list[3];

      if (srv_list_key != "null") {
        auto srv_list = named_metadata[srv_list_key];
        preprocess_state.srv_resources.reserve(srv_list.size());
        for (const auto srv_key : srv_list) {
          preprocess_state.srv_resources.emplace_back(
              named_metadata[srv_key], preprocess_state.resource_descriptions, named_metadata);
        }
      }

      if (uav_list_key != "null") {
        auto uav_list = named_metadata[uav_list_key];
        preprocess_state.uav_resources.reserve(uav_list.size());
        for (const auto uav_key : uav_list) {
          preprocess_state.uav_resources.emplace_back(
              named_metadata[uav_key], preprocess_state.resource_descriptions, named_metadata);
        }
      }

      if (cbv_list_key != "null") {
        auto cbv_list = named_metadata[cbv_list_key];
        preprocess_state.cbv_resources.reserve(cbv_list.size());
        for (const auto cbv_key : cbv_list) {
          preprocess_state.cbv_resources.emplace_back(
              named_metadata[cbv_key], preprocess_state.resource_descriptions, named_metadata);
        }
      }

      if (sampler_list_key != "null") {
        auto sampler_list = named_metadata[sampler_list_key];
        preprocess_state.sampler_resources.reserve(sampler_list.size());
        for (const auto& sampler_key : sampler_list) {
          preprocess_state.sampler_resources.emplace_back(
              named_metadata[sampler_key], preprocess_state.resource_descriptions, named_metadata);
        }
      }
    }

    // Entrypoints
    auto entry_points_reference = named_metadata["!dx.entryPoints"][0];
    auto entry_points_key = entry_points_reference;
    auto entry_points = named_metadata[entry_points_key];
    auto entry_point_global_symbol = entry_points[0];
    auto entry_point_name = entry_points[1];
    auto entry_point_signatures = entry_points[2];
    auto entry_point_resources = entry_points[3];
    auto entry_point_capabilities_key = entry_points[4];

    if (entry_point_capabilities_key != "null") {
      auto capabilities_list = named_metadata[entry_point_capabilities_key];
      auto capabilities_count = capabilities_list.size() / 2;
      for (auto i = 0; i < capabilities_count; ++i) {
        auto capabilities_type = capabilities_list[i * 2];
        auto capabilities_value = capabilities_list[(i * 2) + 1];
        auto [key, value] = Metadata::ParseKeyValue(capabilities_type);
        // NOLINTBEGIN(readability-identifier-naming)
        static const unsigned kDxilShaderFlagsTag = 0;
        static const unsigned kDxilGSStateTag = 1;
        static const unsigned kDxilDSStateTag = 2;
        static const unsigned kDxilHSStateTag = 3;
        static const unsigned kDxilNumThreadsTag = 4;
        static const unsigned kDxilAutoBindingSpaceTag = 5;
        static const unsigned kDxilRayPayloadSizeTag = 6;
        static const unsigned kDxilRayAttribSizeTag = 7;
        static const unsigned kDxilShaderKindTag = 8;
        static const unsigned kDxilMSStateTag = 9;
        static const unsigned kDxilASStateTag = 10;
        static const unsigned kDxilWaveSizeTag = 11;
        static const unsigned kDxilEntryRootSigTag = 12;

        if (key == "i32") {
          switch (value[0]) {
            case '0':
            case '1':
            case '2':
            case '3':
            default:
              break;
            case '4': {
              // kDxilNumThreadsTag
              auto num_threads_values = named_metadata[capabilities_value];
              current_code_function->threads = {
                  Metadata::ParseKeyValue(num_threads_values[0])[1],
                  Metadata::ParseKeyValue(num_threads_values[1])[1],
                  Metadata::ParseKeyValue(num_threads_values[2])[1],
              };
            }
          }
        }
      }
    }

    // Apply cbuffer packing rules (must happen after metadata parse, before DecompileLines)
    preprocess_state.ApplyCBufferPacking();

    // Mark cbuffers with 16-bit fields for raw uint4 array access
    {
      std::function<bool(std::string_view)> type_uses_native_16bit = [&](std::string_view raw_type_name) -> bool {
        DataType info(raw_type_name);
        if (info.data_type == "half") return true;
        if (auto nested = preprocess_state.type_definitions.find(info.data_type);
            nested != preprocess_state.type_definitions.end()) {
          return std::ranges::any_of(nested->second.variables, [&](const auto& variable) {
            return type_uses_native_16bit(variable.type);
          });
        }
        return false;
      };
      for (size_t cbv_idx = 0; cbv_idx < preprocess_state.cbv_resources.size(); ++cbv_idx) {
        const auto& cbv_resource = preprocess_state.cbv_resources[cbv_idx];
        auto type_name = cbv_resource.pointer.substr(0, cbv_resource.pointer.length() - 1);
        auto def_it = preprocess_state.type_definitions.find(type_name);
        if (def_it != preprocess_state.type_definitions.end()) {
          const auto& definition = def_it->second;
          // Note: 16-bit fields (half/min16float) are handled normally with packoffset.
          // The decompiler always compiles with -enable-16bit-types, so layout is consistent.
        }
      }
    }

    // Decompilation also notes

    // Pre-pass: resolve cbufferLoad extractvalues for forward references
    std::map<std::string, std::pair<std::string, std::string>> cbuffer_prepass_aliases;
    {
      static const auto create_handle_regex = std::regex(
          R"(^\s+%(\d+) = call %dx\.types\.Handle @dx\.op\.createHandle\(i32 \d+, i8 2, i32 (\d+), i32 (\d+), i1 (?:true|false)\))");
      static const auto cbuf_load_regex = std::regex(
          R"(^\s+%(\d+) = call %dx\.types\.CBufRet\.(f32|i32) @dx\.op\.cbufferLoadLegacy\.\w+\(i32 \d+, %dx\.types\.Handle %(\d+), i32 (\d+)\))");
      static const auto extractvalue_regex = std::regex(
          R"(^\s+%(\d+) = extractvalue %dx\.types\.CBufRet\.(f32|i32) %(\d+), (\d+))");

      // First: find createHandle calls for CBVs (resourceClass=2)
      std::map<std::string, std::pair<uint32_t, uint32_t>> cbv_handles;  // handle_var -> (range_index, register_bind)
      for (const auto& src_line : current_code_function->lines) {
        std::match_results<std::string_view::const_iterator> m;
        if (std::regex_search(src_line.begin(), src_line.end(), m, create_handle_regex)) {
          std::string handle_var = m[1].str();
          uint32_t range_id = 0, bind_index = 0;
          FromStringView(std::string_view(m[2].str()), range_id);
          FromStringView(std::string_view(m[3].str()), bind_index);
          cbv_handles[handle_var] = {range_id, bind_index};
        }
      }

      // Second: find cbufferLoadLegacy calls with static register index
      std::map<std::string, std::tuple<uint32_t, uint32_t, std::string>> cbuf_load_map;  // var -> (range_index, regIndex, binding_name)
      for (const auto& src_line : current_code_function->lines) {
        std::match_results<std::string_view::const_iterator> m;
        if (std::regex_search(src_line.begin(), src_line.end(), m, cbuf_load_regex)) {
          std::string var = m[1].str();
          std::string handle_ref = m[3].str();
          uint32_t reg_index = 0;
          FromStringView(std::string_view(m[4].str()), reg_index);

          auto handle_it = cbv_handles.find(handle_ref);
          if (handle_it == cbv_handles.end()) continue;
          auto [range_index, bind_index] = handle_it->second;
          if (range_index >= preprocess_state.cbv_resources.size()) continue;

          // Skip if this cbuffer handle has dynamic access (uses raw array style)
          if (preprocess_state.cbv_handles_with_dynamic_access.contains(std::format("%{}", handle_ref))) continue;
          if (preprocess_state.cbv_dynamic_access_indices.count(range_index)) continue;

          auto& cbv_resource = preprocess_state.cbv_resources[range_index];
          cbuf_load_map[var] = {range_index, reg_index, cbv_resource.name};
        }
      }

      // Third: resolve extractvalues from those cbufferLoads
      for (const auto& src_line : current_code_function->lines) {
        std::match_results<std::string_view::const_iterator> m;
        if (std::regex_search(src_line.begin(), src_line.end(), m, extractvalue_regex)) {
          std::string var = m[1].str();
          std::string ret_type = m[2].str();
          std::string source_var = m[3].str();
          uint32_t component_index = 0;
          FromStringView(std::string_view(m[4].str()), component_index);

          auto cbuf_it = cbuf_load_map.find(source_var);
          if (cbuf_it == cbuf_load_map.end()) continue;

          auto& [range_index, reg_index, binding_name] = cbuf_it->second;
          auto& cbv_resource = preprocess_state.cbv_resources[range_index];

          std::string assignment_type;
          std::string assignment_value;

          if (ret_type == "f32") {
            assignment_type = "float";
            auto value_from_reflection = preprocess_state.ResourceVariableNameAtIndex(cbv_resource, (reg_index * 16) + (component_index * 4));
            if (value_from_reflection.empty()) {
              char sub_index = VECTOR_INDEXES[component_index];
              std::string suffix = std::format("{:03}{}", reg_index, sub_index);
              assignment_value = std::format("{}_{}", binding_name, suffix);
            } else {
              if (cbv_resource.array_size.has_value()) {
                assignment_value = std::format("{}.{}", binding_name, value_from_reflection);
              } else {
                assignment_value = value_from_reflection;
              }
            }
          } else if (ret_type == "i32") {
            assignment_type = "int";
            auto value_from_reflection = preprocess_state.ResourceVariableNameAtIndex(cbv_resource, (reg_index * 16) + (component_index * 4));
            if (value_from_reflection.empty()) {
              char sub_index = VECTOR_INDEXES[component_index];
              std::string suffix = std::format("{:03}{}", reg_index, sub_index);
              assignment_value = std::format("{}_{}", binding_name, suffix);
            } else {
              if (cbv_resource.array_size.has_value()) {
                assignment_value = std::format("{}.{}", binding_name, value_from_reflection);
              } else {
                assignment_value = value_from_reflection;
              }
            }
          }

          if (!assignment_value.empty()) {
            cbuffer_prepass_aliases.emplace(var, std::pair<std::string, std::string>(assignment_type, assignment_value));
          }
        }
      }

      // Seed the pre-pass aliases into the current code function
      for (const auto& [key, value] : cbuffer_prepass_aliases) {
        current_code_function->variable_aliases.emplace(key, value);
      }
    }

    current_code_function->DecompileLines(preprocess_state);

    if (decompile_options.flatten) {
      // Single-use variable inlining: replace variables used only once with
      // their defining expression. This is critical for preventing DXC from
      // merging paths at multi-way convergence points — when phi assignments
      // reference the same SSA variable from different predecessors, inlining
      // expands them to different expressions that DXC can't prove equivalent.
      if (!decompile_options.no_single_use_inline) {
      {
        // Propagate use counts through identity aliases. When an identity alias
        // (e.g., extractvalue _460 = _459.x) is used multiple times, the source
        // variable (_459) should NOT be considered single-use, because inlining
        // it would duplicate the source expression (e.g., a SampleLevel call)
        // at each use site. DXC cannot always CSE these duplicates back together,
        // especially when they appear in short-circuit conditions vs else branches.
        std::map<uint32_t, uint32_t> propagated_counter = current_code_function->variable_counter;
        for (const auto& [alias_var_str, alias_pair] : current_code_function->variable_aliases) {
          // Parse the alias variable number
          uint32_t alias_var_num;
          if (alias_var_str.empty() || !std::all_of(alias_var_str.begin(), alias_var_str.end(),
                  [](char c) { return c >= '0' && c <= '9'; })) {
            continue;
          }
          FromStringView(alias_var_str, alias_var_num);
          // Get the alias's use count
          auto alias_count_it = propagated_counter.find(alias_var_num);
          if (alias_count_it == propagated_counter.end() || alias_count_it->second <= 1) {
            continue;  // alias is single-use or unused, no propagation needed
          }
          // Find the source variable referenced in the alias expression.
          // Identity aliases have the form "_SOURCE.component" or "(type)(_SOURCE)"
          const auto& alias_expr = alias_pair.second;
          // Look for _N pattern (variable reference) in the alias expression
          static const auto SOURCE_VAR_REGEX = std::regex(R"(^_(\d+)\.)");
          std::smatch match;
          if (std::regex_search(alias_expr, match, SOURCE_VAR_REGEX)) {
            uint32_t source_var_num;
            FromStringView(std::string_view(match[1].first, match[1].second), source_var_num);
            // Propagate: source gets additional uses from the alias (minus the 1 already counted)
            propagated_counter[source_var_num] += (alias_count_it->second - 1);
          }
        }
        for (const auto& [variable, count] : propagated_counter) {
          if (count == 1) {
            current_code_function->single_use_variables.insert(variable);
          }
        }

        // Exclude variables that are forward-referenced (used in a block before their
        // definition block). Inlining these would produce undeclared identifiers because
        // the definition hasn't been processed when the use-site is emitted.
        {
          // Build a map: variable_number -> definition_block_number
          std::map<uint32_t, int> var_definition_block;
          // Build a map: variable_number -> earliest_use_block_number
          std::map<uint32_t, int> var_earliest_use_block;

          static const auto def_regex = std::regex(R"(^\s+%(\d+)\s*=)");
          static const auto use_regex = std::regex(R"(%(\d+))");

          int current_block = 0;
          static const auto block_label_regex = std::regex(R"(^; <label>:(\d+))");
          for (const auto& src_line : current_code_function->lines) {
            std::match_results<std::string_view::const_iterator> bm;
            if (std::regex_search(src_line.begin(), src_line.end(), bm, block_label_regex)) {
              FromStringView(std::string_view(bm[1].first, bm[1].second), current_block);
              continue;
            }
            // Check for definition
            std::match_results<std::string_view::const_iterator> dm;
            if (std::regex_search(src_line.begin(), src_line.end(), dm, def_regex)) {
              uint32_t var_num = 0;
              FromStringView(std::string_view(dm[1].first, dm[1].second), var_num);
              var_definition_block.try_emplace(var_num, current_block);
              // Also scan RHS for uses
              auto rhs_start = dm[0].second;
              auto search_start = rhs_start;
              std::match_results<std::string_view::const_iterator> um;
              while (std::regex_search(search_start, src_line.end(), um, use_regex)) {
                uint32_t use_var = 0;
                FromStringView(std::string_view(um[1].first, um[1].second), use_var);
                if (use_var != var_num) {
                  auto it = var_earliest_use_block.find(use_var);
                  if (it == var_earliest_use_block.end() || current_block < it->second) {
                    var_earliest_use_block[use_var] = current_block;
                  }
                }
                search_start = um[0].second;
              }
            } else {
              // Non-definition line — all %N references are uses
              auto search_start = src_line.begin();
              std::match_results<std::string_view::const_iterator> um;
              while (std::regex_search(search_start, src_line.end(), um, use_regex)) {
                uint32_t use_var = 0;
                FromStringView(std::string_view(um[1].first, um[1].second), use_var);
                auto it = var_earliest_use_block.find(use_var);
                if (it == var_earliest_use_block.end() || current_block < it->second) {
                  var_earliest_use_block[use_var] = current_block;
                }
                search_start = um[0].second;
              }
            }
          }

          // Remove forward-referenced variables from single_use_variables
          std::vector<uint32_t> to_remove;
          for (uint32_t var : current_code_function->single_use_variables) {
            auto def_it = var_definition_block.find(var);
            auto use_it = var_earliest_use_block.find(var);
            if (def_it != var_definition_block.end() && use_it != var_earliest_use_block.end()) {
              if (use_it->second < def_it->second) {
                to_remove.push_back(var);
              }
            }
          }
          for (uint32_t var : to_remove) {
            current_code_function->single_use_variables.erase(var);
          }
        }
      }
      if (!current_code_function->single_use_variables.empty()) {
        CodeFunction replacement_code_function;
        replacement_code_function.threads = current_code_function->threads;
        replacement_code_function.return_type = current_code_function->return_type;
        replacement_code_function.name = current_code_function->name;
        replacement_code_function.parameters = current_code_function->parameters;
        replacement_code_function.lines = current_code_function->lines;
        replacement_code_function.single_use_variables = current_code_function->single_use_variables;
        replacement_code_function.phi_variables = current_code_function->phi_variables;
        // Seed cbuffer pre-pass aliases so forward-referenced cbuffer loads resolve correctly
        for (const auto& [key, value] : cbuffer_prepass_aliases) {
          replacement_code_function.variable_aliases.emplace(key, value);
        }
        replacement_code_function.DecompileLines(preprocess_state);
        *current_code_function = replacement_code_function;

#if 0
        // Not supported in C++
        static const auto LERP_REGEXES = {
            // (((b - a) * t) + a)
            std::regex(R"(\(\(\((?<b>(?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?)) - (?<a>(?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?))\) \* (?<t>(?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?))\) \+ \k<a>\))"),
            // ((t * (b - a)) + a)
            std::regex(R"(\(\((?<t>(?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?)) \* \((?<b>(?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?)) - (?<a>(?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?))\)\) \+ \k<a>\))"),

            // (a + ((b - a) * t))
            std::regex(R"(\((?<a>(?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?)) \+ \(\((?<b>(?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?)) - \k<a>\) \* (?<t>(?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?))\)\))"),
            // (a + (t * (b - a)))
            std::regex(R"(\((?<a>(?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?)) \+ \((?<t>(?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?)) \* \((?<b>(?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?)) - \k<a>\)\)\))"),

            // (((1.0f - t) * a) + (t * b))
            std::regex(R"(\(\(\(1\.0f - (?<t>(?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?))\) \* (?<a>(?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?))\) \+ \(\k<t> \* (?<b>(?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?))\)\))"),
            // (((1.0f - t) * a) + (b * t))
            std::regex(R"(\(\(\(1\.0f - (?<t>(?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?))\) \* (?<a>(?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?))\) \+ \((?<b>(?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?)) \* \k<t>\)\))"),

            // ((a * (1.0f - t)) + (t * b))
            std::regex(R"(\(\((?<a>(?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?)) \* \(1\.0f - (?<t>(?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?))\)\) \+ \(\k<t> \* (?<b>(?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?))\)\))"),
            // ((a * (1.0f - t)) + (b * t))
            std::regex(R"(\(\((?<a>(?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?)) \* \(1\.0f - (?<t>(?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?))\)\) \+ \((?<b>(?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?)) \* \k<t>\)\))"),

            // ((b - (1.0f - t)) * (b - a))
            std::regex(R"(\(\((?<b>(?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?)) \- \(1\.0f - (?<t>(?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?))\)\) \* \(\k<b> - (?<a>(?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?))\)\))"),
            // ((b - a) * (b - (1.0f - t)))
            std::regex(R"(\(\((?<b>(?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?)) \- (?<a>(?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?))\) \* \(\k<b> - \(1\.0f - (?<t>(?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?))\)\))"),
        };
#endif
      }
      }  // end of if (!no_single_use_inline)
    }

    // Mermaid diagram output — returns a flowchart instead of HLSL
    if (decompile_options.mermaid) {
      std::stringstream string_stream;
      string_stream << "```mermaid\n";
      string_stream << "%%{init: {'theme': 'base', 'themeVariables': {"
                    << "'background': '#111827', "
                    << "'mainBkg': '#111827', "
                    << "'clusterBkg': '#111827', "
                    << "'tertiaryColor': '#111827', "
                    << "'lineColor': '#64748b', "
                    << "'textColor': '#f8fafc', "
                    << "'primaryTextColor': '#f8fafc'"
                    << "}}}%%\n";
      string_stream << "flowchart TD\n";
      string_stream << "  classDef entry fill:#0f2233,stroke:#63b3ed,stroke-width:2px,color:#ebf8ff;\n";
      string_stream << "  classDef branch fill:#1f2937,stroke:#94a3b8,stroke-width:1px,color:#f8fafc;\n";
      string_stream << "  classDef join fill:#0f2a1f,stroke:#68d391,stroke-width:2px,color:#f0fff4;\n";
      string_stream << "  classDef loop fill:#24163a,stroke:#b794f4,stroke-width:2px,color:#faf5ff;\n";
      string_stream << "  classDef planentry fill:#0f2233,stroke:#63b3ed,stroke-width:2px,color:#ebf8ff;\n";
      string_stream << "  classDef planbranch fill:#1f2937,stroke:#94a3b8,stroke-width:1px,color:#f8fafc;\n";
      string_stream << "  classDef planjoin fill:#0f2a1f,stroke:#68d391,stroke-width:2px,color:#f0fff4;\n";
      string_stream << "  classDef planloop fill:#24163a,stroke:#b794f4,stroke-width:2px,color:#faf5ff;\n";
      string_stream << "  classDef planladder fill:#341326,stroke:#f687b3,stroke-width:2px,color:#fff5f7;\n";
      string_stream << "  classDef planseq fill:#1a202c,stroke:#a0aec0,stroke-width:1px,color:#edf2f7;\n";
      string_stream << "  classDef planexit fill:#3b1014,stroke:#fc8181,stroke-width:2px,color:#fff5f5;\n";
      string_stream << "  classDef hidden fill:transparent,stroke:transparent,color:transparent;\n";
      for (size_t function_index = 0; function_index < code_functions.size(); ++function_index) {
        string_stream << code_functions[function_index].BuildMermaid(std::format("fn{}", function_index));
      }
      string_stream << "```\n";
      return string_stream.str();
    }

    // Generate output

#if DECOMPILER_DXC_DEBUG >= 3
    auto& string_stream = std::cout;
#else
    std::stringstream string_stream;
#endif

    int line_spacing = 0;
    std::string spacing;
    auto indent_spacing = [&]() {
      line_spacing += 2;
      spacing = "";
      spacing.insert(0, line_spacing, ' ');
    };
    auto unindent_spacing = [&]() {
      line_spacing -= 2;
      spacing = "";
      spacing.insert(0, line_spacing, ' ');
    };

    // Type Definitions
    std::unordered_set<std::string> added_definitions;

    std::function<void(std::string_view, std::string_view)> declare_definition = [&](auto definition_name, auto struct_variable_name) {
      if (added_definitions.contains(std::string(definition_name))) return;
      auto& definition = preprocess_state.type_definitions[definition_name];

      static const std::regex STRUCT_PATTERN = std::regex(R"xx(%"?(?:hostlayout\.)?(?:struct\.)?([^"]*)"?)xx");
      auto [struct_name] = StringViewMatch<1>(definition_name, STRUCT_PATTERN);

      if (struct_name.empty()) return;
      if (struct_name == "SamplerState") return;
      if (struct_name == "ByteAddressBuffer") return;

      for (const auto& [declaration, name, type_name, optional_offset] : definition.variables) {
        // Check for nested structs
        DataType info(type_name);
        static const std::regex NESTED_STRUCT_PATTERN = std::regex(R"xx(%"?(?:hostlayout\.)?(?:struct\.)([^"]*)"?)xx");        auto [struct_name] = StringViewMatch<1>(info.data_type, NESTED_STRUCT_PATTERN);
        if (struct_name.empty()) continue;

        if (!added_definitions.contains(std::string(info.data_type))) {
          declare_definition(info.data_type, "");
        }
      }

      // Sanitize struct name for HLSL (replace <, >, spaces with underscores)
      std::string sanitized_name(struct_name);
      std::ranges::replace(sanitized_name, '<', '_');
      std::ranges::replace(sanitized_name, '>', '_');
      std::ranges::replace(sanitized_name, ' ', '_');
      string_stream << spacing << "struct " << sanitized_name << " {\n";
      indent_spacing();
      for (const auto& [declaration, name, type_name, optional_offset] : definition.variables) {
        DataType info(type_name);

        static const std::regex TYPE_NAME_PATTERN = std::regex(R"xx(%?"?(host)?(?:layout\.)?(struct\.)?([^"]*)"?)xx");
        auto [is_host, is_struct, type_name_parsed] = StringViewMatch<3>(info.data_type, TYPE_NAME_PATTERN);

        assert(!type_name_parsed.empty());

        if (is_host.empty() && !is_struct.empty()) {
          // Sanitize struct name for HLSL
          std::string sanitized_type(type_name_parsed);
          std::ranges::replace(sanitized_type, '<', '_');
          std::ranges::replace(sanitized_type, '>', '_');
          std::ranges::replace(sanitized_type, ' ', '_');
          if (added_definitions.contains(std::string(info.data_type))) {
            // Struct already declared — emit as field reference
            string_stream << spacing << sanitized_type << " " << name;
          } else {
            declare_definition(info.data_type, name);
          }
        } else {
          // Determine the HLSL type name
          std::string hlsl_type;
          if (declaration.starts_with("uint")) {
            assert(info.data_type == "int" || info.data_type == "uint" || info.data_type == "i16");
            if (info.data_type == "i16") {
              hlsl_type = "uint16_t";
            } else {
              hlsl_type = "uint";
            }
          } else if (info.data_type.starts_with("%class.matrix.") || std::string_view(type_name_parsed).starts_with("class.matrix.")) {
            // Matrix type: class.matrix.{base}.{rows}.{cols}
            static const std::regex MATRIX_PATTERN(R"((?:%)?class\.matrix\.([^.]+)\.(\d+)\.(\d+))");
            auto [base_type, rows_str, cols_str] = StringViewMatch<3>(info.data_type, MATRIX_PATTERN);
            if (!base_type.empty()) {
              // Always emit row_major for struct fields because the decompiler's
              // register-based cbuffer access assumes row-major layout.
              hlsl_type = std::format("row_major {}{}x{}", base_type, rows_str, cols_str);
            } else {
              hlsl_type = std::string(type_name_parsed);
            }
          } else if (info.data_type == "i16" || type_name_parsed == "i16") {
            hlsl_type = "int16_t";
          } else if (info.data_type == "i32" || type_name_parsed == "i32") {
            hlsl_type = "int";
          } else if (info.data_type == "i64" || type_name_parsed == "i64") {
            hlsl_type = "int64_t";
          } else if (info.data_type == "f16" || type_name_parsed == "f16") {
            hlsl_type = "half";
          } else {
            hlsl_type = std::string(type_name_parsed);
          }
          string_stream << spacing << hlsl_type;
          if (info.vector_size != 0) {
            string_stream << info.vector_size;
          }
          string_stream << " " << name;
        }

        for (const auto& array_size : info.array_sizes) {
          string_stream << "[" << array_size << "]";
        }

        string_stream << ";\n";
      }
      unindent_spacing();
      string_stream << spacing << "}";
      if (struct_variable_name.empty()) {
        string_stream << ";\n\n";
        added_definitions.emplace(definition_name);
      } else {
        string_stream << " " << struct_variable_name;
      }
    };

    for (auto& [name, definition] : preprocess_state.type_definitions) {
      static const std::regex STRUCT_PATTERN = std::regex(R"(%(?:hostlayout\.)?(?:struct\.)(.*))");
      auto [struct_name] = StringViewMatch<1>(name, STRUCT_PATTERN);
      if (struct_name.empty()) continue;
      if (struct_name == "SamplerState") continue;
      if (struct_name == "SamplerComparisonState") continue;
      if (struct_name == "ByteAddressBuffer") continue;
      if (struct_name == "RWByteAddressBuffer") continue;
      if (struct_name == "RaytracingAccelerationStructure") continue;

      if (!added_definitions.contains(std::string(name))) {
        declare_definition(name, "");
      }
    }

    if (!added_definitions.empty()) {
      string_stream << "\n";
    }

    for (const auto& srv_resource : preprocess_state.srv_resources) {
      // Skip struct definition for RaytracingAccelerationStructure — it's a built-in HLSL type
      if (srv_resource.shape == SRVResource::ResourceKind::RTAccelerationStructure
          || srv_resource.pointer == "%struct.RaytracingAccelerationStructure*") {
        // Just emit the declaration, no struct needed
      } else {
        auto pair = preprocess_state.type_definitions.find(srv_resource.data_type);
        if (pair != preprocess_state.type_definitions.end()) {
          auto& resource_type_definition = pair->second;

          if (resource_type_definition.name.starts_with("%\"class.StructuredBuffer<")) {
            auto struct_pair = preprocess_state.type_definitions.find(resource_type_definition.variables[0].type);
            if (struct_pair != preprocess_state.type_definitions.end()) {
              resource_type_definition = struct_pair->second;
            }
          }
          if (srv_resource.shape == SRVResource::ResourceKind::StructuredBuffer) {
            declare_definition(resource_type_definition.name, "");
          }
        }
      }

      static const std::regex TYPE_NAME_PATTERN = std::regex(R"(%?(?:host)?(?:layout\.)?(?:struct\.)?(.*))");

      if (Resource::IsByteAddressBufferPointer(srv_resource.pointer)) {
        string_stream << "ByteAddressBuffer";
      } else if (srv_resource.shape == SRVResource::ResourceKind::RTAccelerationStructure
                 || srv_resource.pointer == "%struct.RaytracingAccelerationStructure*") {
        string_stream << "RaytracingAccelerationStructure";
      } else {
        auto [type_name_parsed] = StringViewMatch<1>(srv_resource.data_type, TYPE_NAME_PATTERN);
        assert(!type_name_parsed.empty());

        string_stream << SRVResource::ResourceKindString(srv_resource.shape);

        if (srv_resource.shape != SRVResource::ResourceKind::RawBuffer) {
          string_stream << "<" << type_name_parsed << ">";
        }
      }

      string_stream << " " << srv_resource.name;
      if (srv_resource.array_size.has_value()) {
        string_stream << "[";
        if (srv_resource.array_size != 0) {
          string_stream << srv_resource.array_size.value();
        }
        string_stream << "]";
      }
      string_stream << " : register(t" << srv_resource.signature_index;
      if (srv_resource.space != 0u) {
        string_stream << ", space" << srv_resource.space;
      }
      string_stream << ");\n\n";
    }

    // UAV

    for (const auto& uav_resource : preprocess_state.uav_resources) {
      if (Resource::IsRWByteAddressBufferPointer(uav_resource.pointer)) {
        string_stream << "RWByteAddressBuffer";
      } else {
        string_stream << "RW" << UAVResource::ResourceKindString(uav_resource.shape);
      }
      if (uav_resource.shape == UAVResource::ResourceKind::RawBuffer) {
        // RWByteAddressBuffer has no template parameter
      } else if (!uav_resource.data_type.empty()
                 && (uav_resource.data_type != "uint4"
                     || uav_resource.shape == UAVResource::ResourceKind::Texture2D
                     || uav_resource.shape == UAVResource::ResourceKind::Texture2DArray
                     || uav_resource.shape == UAVResource::ResourceKind::Texture3D
                     || uav_resource.shape == UAVResource::ResourceKind::Texture1D
                     || uav_resource.shape == UAVResource::ResourceKind::Texture1DArray
                     || uav_resource.shape == UAVResource::ResourceKind::TextureCube
                     || uav_resource.shape == UAVResource::ResourceKind::TextureCubeArray)) {
        static const std::regex TYPE_NAME_PATTERN = std::regex(R"(%?(?:host)?(?:layout\.)?(?:struct\.)?(.*))");
        std::string_view type_to_parse = uav_resource.data_type;
        // Strip leading underscore from struct name references
        if (type_to_parse.starts_with("_")) type_to_parse = type_to_parse.substr(1);
        auto [type_name_parsed] = StringViewMatch<1>(type_to_parse, TYPE_NAME_PATTERN);

        if (!type_name_parsed.empty()) {
          string_stream << "<" << type_name_parsed << ">";
        } else {
          string_stream << "<" << type_to_parse << ">";
        }
      } else if (uav_resource.element_type != SRVResource::ComponentType::Invalid) {
        string_stream << "<" << SRVResource::ComponentTypeString(uav_resource.element_type) << ">";
      } else {
        string_stream << "<uint4>";
      }

      string_stream << " " << uav_resource.name;
      if (uav_resource.array_size.has_value()) {
        string_stream << "[";
        if (uav_resource.array_size != 0) {
          string_stream << uav_resource.array_size.value();
        }
        string_stream << "]";
      }
      string_stream << " : register(u" << uav_resource.signature_index;
      if (uav_resource.space != 0u) {
        string_stream << ", space" << uav_resource.space;
      }
      string_stream << ");\n\n";
    }

    // CBV

    for (size_t cbv_idx = 0; cbv_idx < preprocess_state.cbv_resources.size(); ++cbv_idx) {
      const auto& cbv_resource = preprocess_state.cbv_resources[cbv_idx];

      // For cbuffers with dynamic access, emit as float4 array only
      if (preprocess_state.cbv_dynamic_access_indices.count(static_cast<uint32_t>(cbv_idx))) {
        uint32_t num_float4s = static_cast<uint32_t>(ceil(static_cast<float>(cbv_resource.buffer_size) / 16.f));
        string_stream << "cbuffer " << cbv_resource.name << " : register(b" << cbv_resource.signature_index;
        if (cbv_resource.space != 0u) {
          string_stream << ", space" << cbv_resource.space;
        }
        string_stream << ") {\n";
        string_stream << "  uint4 " << cbv_resource.name << "_raw[" << num_float4s << "];\n";
        string_stream << "};\n\n";
        continue;
      }

      // Array cbuffers (including unbounded) must use ConstantBuffer<Type> syntax
      if (cbv_resource.array_size.has_value()) {
        auto type_name = cbv_resource.pointer.substr(0, cbv_resource.pointer.length() - 1);
        // Strip array wrapper: [N x %type] -> %type
        static auto array_inner_regex = std::regex{R"(^\[\d+ x (.+)\]$)"};
        auto [inner_type] = StringViewMatch<1>(type_name, array_inner_regex);
        std::string_view lookup_type = inner_type.empty() ? type_name : inner_type;

        // Find or declare the struct type
        auto def_it = preprocess_state.type_definitions.find(lookup_type);
        if (def_it != preprocess_state.type_definitions.end()) {
          auto& definition = def_it->second;
          // Declare the inner struct if it has reflected fields
          if (definition.has_offsets) {
            static const std::regex STRUCT_PATTERN = std::regex(R"(%(?:hostlayout\.)?(?:struct\.)?(.+))");
            auto [struct_type_name] = StringViewMatch<1>(lookup_type, STRUCT_PATTERN);
            if (!struct_type_name.empty() && !added_definitions.contains(std::string(lookup_type))) {
              declare_definition(lookup_type, "");
            }
            // Check for name collision: if the struct type name equals the variable name,
            // the ConstantBuffer<Type> Type[] declaration creates an ambiguous reference.
            // Fix by appending _t to the struct type name in the template parameter.
            // The struct declaration was already emitted by declare_definition above,
            // so we also need to emit a typedef alias.
            std::string cb_type_str = struct_type_name.empty() ? std::string(lookup_type) : std::string(struct_type_name);
            if (cb_type_str == cbv_resource.name) {
              std::string renamed = cb_type_str + "_t";
              string_stream << "typedef " << cb_type_str << " " << renamed << ";\n";
              cb_type_str = renamed;
            }
            string_stream << "ConstantBuffer<" << cb_type_str << "> " << cbv_resource.name << "[";
          } else {
            // Fallback: emit as float4 array
            string_stream << "ConstantBuffer<float4> " << cbv_resource.name << "[";
          }
        } else {
          string_stream << "ConstantBuffer<float4> " << cbv_resource.name << "[";
        }
        if (cbv_resource.array_size.value() != 0 && cbv_resource.array_size.value() != 0xFFFFFFFF) {
          string_stream << cbv_resource.array_size.value();
        }
        string_stream << "] : register(b" << cbv_resource.signature_index;
        if (cbv_resource.space != 0u) {
          string_stream << ", space" << cbv_resource.space;
        }
        string_stream << ");\n\n";
        continue;
      }

      string_stream << "cbuffer " << cbv_resource.name;
      string_stream << " : register(b" << cbv_resource.signature_index;
      if (cbv_resource.space != 0u) {
        string_stream << ", space" << cbv_resource.space;
      }
      string_stream << ") {\n";

      auto type_name = cbv_resource.pointer.substr(0, cbv_resource.pointer.length() - 1);
      auto definition = preprocess_state.type_definitions[type_name];
      int offset = 0;

      indent_spacing();

      bool use_cbuffer_float4 = false;

      // Detect if any field uses native 16-bit types (half) — packoffset is not valid for these
      std::function<bool(std::string_view)> type_uses_native_16bit = [&](std::string_view raw_type_name) -> bool {
        DataType info(raw_type_name);
        if (info.data_type == "half") return true;
        if (auto nested = preprocess_state.type_definitions.find(info.data_type);
            nested != preprocess_state.type_definitions.end()) {
          return std::ranges::any_of(nested->second.variables, [&](const auto& variable) {
            return type_uses_native_16bit(variable.type);
          });
        }
        return false;
      };
      bool has_16bit_fields = definition.has_offsets && std::ranges::any_of(definition.variables, [&](const auto& variable) {
        return type_uses_native_16bit(variable.type);
      });

      // 16-bit fields (half/min16float) are emitted as named fields with packoffset.
      // The decompiler always compiles with -enable-16bit-types, so layout is consistent.

      if (use_cbuffer_float4) {
        string_stream << "  float4 " << cbv_resource.name;
        string_stream << "[" << ceil(static_cast<float>(cbv_resource.buffer_size) / 16.f) << "] : packoffset(c0);\n";
      } else if (definition.has_offsets || cbv_resource.buffer_size == definition.size) {
        int padding_counter = 0;
        for (const auto& [declaration, name, type_name, optional_offset] : definition.variables) {
          DataType info(type_name);

          // Fields with no name are padding or unused — emit a placeholder
          if (name.empty()) {
            auto item_offset = offset;
            if (optional_offset.has_value()) {
              item_offset = optional_offset.value();
              offset = item_offset;
            }
            auto field_size = preprocess_state.GetTypeSize(info);
            // Emit padding as int (4 bytes per component)
            uint32_t padding_components = static_cast<uint32_t>(field_size / 4);
            if (padding_components == 0) padding_components = 1;
            std::string padding_type = (padding_components > 1) ? std::format("int{}", padding_components) : "int";
            string_stream << spacing << padding_type << " _padding_" << padding_counter++;
            if (!has_16bit_fields) {
              string_stream << std::format(" : packoffset(c{:03}.{})", item_offset / 16, VECTOR_INDEXES[item_offset % 16 / 4]);
            }
            string_stream << ";\n";
            offset += static_cast<int>(field_size);
            continue;
          }

          if (type_name.starts_with("%class") || info.data_type.starts_with("class.matrix.") || info.data_type.starts_with("%class.matrix.")) {
            // known classes — handle both direct (%class.matrix...) and array ([N x %class.matrix...]) types
            static const std::regex PATTERN = std::regex(R"((?:%)?class\.matrix\.([^.]+)\.(\d+)\.(\d+))");
            auto [base_type, array_string, vector_string] = StringViewMatch<3>(info.data_type, PATTERN);
            if (!base_type.empty()) {
              uint32_t array;
              FromStringView(array_string, array);
              uint32_t vector;
              FromStringView(vector_string, vector);
              // Always emit row_major because the decompiler's register-based
              // access pattern assumes row-major layout (mat[N] = reg base+N).
              string_stream << spacing << std::format("row_major {}{}x{} {}", base_type, array, vector, name);
            }
          } else if (info.data_type == "float" || info.data_type == "uint" || info.data_type == "int"
                     || info.data_type == "half" || info.data_type == "bool"
                     || info.data_type == "double" || info.data_type == "i16"
                     || info.data_type == "int16_t" || info.data_type == "uint16_t"
                     || info.data_type == "int64_t" || info.data_type == "uint64_t"
                     || info.data_type == "i64") {
            if (declaration.starts_with("uint")) {
              // use uint from declaration
              assert(info.data_type == "int" || info.data_type == "uint");
              string_stream << spacing << "uint";
            } else if (info.data_type == "half") {
              // half is not valid in cbuffer with packoffset — use min16float
              string_stream << spacing << "min16float";
            } else if (info.data_type == "i64") {
              // i64 is LLVM IR type — emit as int64_t for HLSL
              string_stream << spacing << "int64_t";
            } else {
              string_stream << spacing << info.data_type;
            }
            if (info.vector_size != 0) {
              string_stream << info.vector_size;
            }
            string_stream << " " << name;

          } else if (info.data_type.starts_with("%struct.")) {
            if (added_definitions.contains(std::string(info.data_type))) {
              // Struct already declared — just reference it by name
              auto struct_type_name = std::string(info.data_type.substr(8));  // strip "%struct."
              string_stream << spacing << struct_type_name << " " << name;
            } else {
              declare_definition(info.data_type, name);
            }

          } else if (info.data_type.starts_with("%hostlayout.struct.")) {
            // host struct
            static const std::regex PATTERN = std::regex(R"(%hostlayout.struct\.(.*))");
            auto [struct_name] = StringViewMatch<1>(type_name, PATTERN);
            string_stream << spacing << struct_name << " " << name;
          } else if (info.data_type.starts_with("%\"")) {
            // host struct
            static const std::regex PATTERN = std::regex(R"(%\"[^"]*\")");
            auto [struct_name] = StringViewMatch<1>(type_name, PATTERN);
            string_stream << spacing << struct_name << " " << name;
          } else if (info.data_type.starts_with("%")) {
            // Bare struct reference — emit type name directly
            static const std::regex BARE_TYPE_PATTERN = std::regex(R"(%(?:hostlayout\.)?(?:struct\.)?(.+))");
            auto [bare_name] = StringViewMatch<1>(info.data_type, BARE_TYPE_PATTERN);
            if (!bare_name.empty()) {
              string_stream << spacing << bare_name << " " << name;
            }
          } else {
            assert(false);
          }

          for (const auto& array_size : info.array_sizes) {
            string_stream << "[" << array_size << "]";
          };

          auto item_offset = offset;
          if (optional_offset.has_value()) {
            item_offset = optional_offset.value();
            offset = item_offset;
          }
          if (has_16bit_fields) {
            string_stream << ";\n";
          } else {
            string_stream << std::format(" : packoffset(c{:03}.{});\n", item_offset / 16, VECTOR_INDEXES[item_offset % 16 / 4], item_offset);
          }
          offset += preprocess_state.GetTypeSize(info);
        }
      } else {
        std::vector<std::pair<std::string, std::string_view>> sorted(cbv_resource.data_types.begin(), cbv_resource.data_types.end());
        std::ranges::sort(sorted, [](auto a, auto b) {
          auto& [a_suffix, a_type] = a;
          auto& [b_suffix, b_type] = b;
          auto a_marker = a_suffix.length() - 1;
          auto b_marker = b_suffix.length() - 1;
          auto a_index1 = std::stoi(a_suffix.substr(0, a_marker));
          auto b_index1 = std::stoi(b_suffix.substr(0, b_marker));
          auto a_index2 = IndexFromChar(a_suffix[a_marker]);
          auto b_index2 = IndexFromChar(b_suffix[b_marker]);
          return (a_index1 == b_index1)
                     ? a_index2 < b_index2
                     : a_index1 < b_index1;
        });

        for (const auto& [suffix, type] : sorted) {
          string_stream << "  " << type << " " << cbv_resource.name << "_" << suffix;
          auto marker = suffix.length() - 1;
          string_stream << " : packoffset(c" << std::format("{}.{}", suffix.substr(0, marker), suffix.substr(marker)) << ");\n";
        }
        if (sorted.empty()) {
          // No resolved fields — emit float4 array as fallback
          uint32_t num_float4s = static_cast<uint32_t>(ceil(static_cast<float>(cbv_resource.buffer_size) / 16.f));
          string_stream << "  float4 " << cbv_resource.name << "_data[" << num_float4s << "];\n";
        }
      }
      unindent_spacing();
      // string_stream << "  } " << cbv_resource.name << " : packoffset(c0);\n";

      string_stream << "};\n\n";
    }

    // Emit raw float4 array views for cbuffers with dynamic access
    // (These are emitted inside the cbuffer block via packoffset overlap — no separate declaration needed)
    // Dynamic access uses the _raw array which overlaps the named fields at packoffset(c0)

    // sampler
    for (const auto& sampler_resource : preprocess_state.sampler_resources) {
      string_stream << StringViewMatch(sampler_resource.pointer, std::regex(R"(.*struct\.([^*"\]]+).*)"));
      string_stream << " " << sampler_resource.name;
      if (sampler_resource.array_size.has_value()) {
        string_stream << "[";
        if (sampler_resource.array_size != 0) {
          string_stream << sampler_resource.array_size.value();
        }
        string_stream << "]";
      }
      string_stream << " : register(s" << sampler_resource.signature_index;
      if (sampler_resource.space != 0u) {
        string_stream << ", space" << sampler_resource.space;
      }
      string_stream << ");\n\n";
    }

    // Helper for DXIL FirstbitHi — returns bit position from MSB (count of leading zeros)
    // Unlike HLSL firstbithigh() which returns position from LSB
    string_stream << "// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)\n";
    string_stream << "uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }\n";
    string_stream << "uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }\n\n";

    // for (const auto binding : preprocess_state.resource_bindings) {
    //   if (binding.type == ResourceDescription::ResourceType::CBUFFER) {
    //     string_stream << "cbuffer " << binding.NameString() << " : ";
    //     string_stream << "register(";
    //     string_stream << binding.hlsl_binding.substr(1);
    //     string_stream << ") {\n";
    //     string_stream << "};\n";
    //   }
    // }

    // Parse Lines
    std::vector<int> pending_convergences = {};
    std::vector<std::set<int>> pending_recursions = {};
    std::vector<int> current_loops = {};
    int loop_escape_counter = 0;
    std::vector<std::string> loop_escape_flags = {};
    std::vector<std::string> loop_exit_flags = {};  // separate flag for convergence-exit (exits loop without continue)
    std::set<int> loops_needing_exit_flag;  // loop headers that need the exit flag
    int do_while_depth = 0;
    std::vector<int> loop_do_while_depth = {};  // do_while_depth when each while(true) opened
    std::set<int> phi_predeclared_blocks;  // blocks whose phi vars were pre-declared for convergence
    std::set<std::string> declared_vars;  // variables already declared (for convergence scope hoisting)
    std::vector<std::string> convergence_bypass_flags = {};
    std::vector<int> convergence_bypass_targets = {};
    // Deferred branch targets — upstream mechanism. When a block is reached
    // from multiple paths inside a convergence region, we defer it: emit a
    // bool flag, set it to true on each reaching path, and process the block
    // once after the convergence via `if (flag) { ... }`.
    std::vector<std::pair<int, std::string>> deferred_branch_targets;

    auto convergences = current_code_function->ListConvergences();
    auto recursions = current_code_function->ListNaturalLoops();
    auto ipdom = current_code_function->ComputePostDominators(recursions);
    auto loop_bodies = current_code_function->ComputeLoopBodies(recursions);
    auto dominators = current_code_function->ListDominators();
    auto predecessors = current_code_function->ComputePredecessors();

    // Pre-compute which loops need a separate exit flag. A loop needs it if
    // any block inside the loop body can branch to the loop's exit block
    // (ipdom of back-edge source) and that exit block is a convergence target.
    for (const auto& [header, back_edge_sources] : recursions) {
      for (int src : back_edge_sources) {
        if (!ipdom.contains(src)) continue;
        int exit_block = ipdom.at(src);
        // Check if any block in the loop body branches to the exit block
        if (loop_bodies.contains(header)) {
          const auto& body = loop_bodies.at(header);
          auto& succs = current_code_function->code_blocks;
          for (int blk : body) {
            if (!succs.contains(blk)) continue;
            auto& cb = succs.at(blk);
            if (cb.code_branch.branch_condition_true == exit_block
                || cb.code_branch.branch_condition_false == exit_block) {
              // This block branches to the exit — and it's not the latch itself
              if (blk != src) {
                loops_needing_exit_flag.insert(header);
                break;
              }
            }
          }
          if (loops_needing_exit_flag.contains(header)) break;
        }
      }
    }

    // Build successor graph with back edges removed for bypass detection.
    auto succs_no_backedge = current_code_function->ComputeSuccessors();
    for (const auto& [header, sources] : recursions) {
      for (int src : sources) {
        if (succs_no_backedge.contains(src)) {
          succs_no_backedge[src].erase(header);
        }
      }
    }

#if DECOMPILER_DXC_DEBUG >= 2
    for (const auto& [a, b] : convergences) {
      std::cout << "Convergences " << a << " = ";
      for (const auto c : b) {
        std::cout << c << " | ";
      }
      std::cout << "\n";
    }

    for (const auto& [a, b] : recursions) {
      std::cout << "Recursion " << a << " = ";
      for (const auto c : b) {
        std::cout << c << " | ";
      }
      std::cout << "\n";
    }

    for (const auto& [a, b] : recursions) {
      std::cout << "Recursion " << a << " = ";
      for (const auto c : b) {
        std::cout << c << " | ";
      }
      std::cout << "\n";
    }
#endif

    std::function<void(int line_number)> append_code_block = [&](int line_number) {
      std::set<int> recursion_pops;
      if (!pending_recursions.empty()) {
        recursion_pops = pending_recursions.rbegin()[0];
      }

      bool using_recursion = recursions.contains(line_number);
      if (using_recursion) {
        pending_recursions.push_back(recursions[line_number]);
        current_loops.push_back(line_number);
        if (decompile_options.use_do_while) {
          auto flag_name = std::format("_loop_break_{}", loop_escape_counter);
          auto exit_flag_name = std::format("_loop_exit_{}", loop_escape_counter);
          loop_escape_counter++;
          loop_escape_flags.push_back(flag_name);
          bool needs_exit = loops_needing_exit_flag.contains(line_number);
          loop_exit_flags.push_back(needs_exit ? exit_flag_name : "");
          loop_do_while_depth.push_back(do_while_depth);
          string_stream << spacing << "bool " << flag_name << " = false;\n";
          if (needs_exit) {
            string_stream << spacing << "bool " << exit_flag_name << " = false;\n";
          }
        }
        string_stream << spacing << "while(true) {\n";
        indent_spacing();
      }

      auto on_complete = [&]() {
        if (using_recursion) {
          string_stream << spacing << "break;\n";
          unindent_spacing();
          string_stream << spacing << "}\n";
          pending_recursions.pop_back();
          current_loops.pop_back();
          if (decompile_options.use_do_while) {
            loop_escape_flags.pop_back();
            loop_exit_flags.pop_back();
            loop_do_while_depth.pop_back();
            if (!loop_escape_flags.empty()) {
              auto& parent_flag = loop_escape_flags.back();
              std::string outer_guard;
              for (int i = static_cast<int>(loop_escape_flags.size()) - 2; i >= 0; i--) {
                if (!outer_guard.empty()) outer_guard += " && ";
                outer_guard += "!" + loop_escape_flags[i];
              }
              // Check if we're inside a do-while(false) that's between us and
              // the parent while(true) loop. If so, 'continue' would target
              // the do-while, not the parent while(true).
              int parent_dw_depth = loop_do_while_depth.back();
              bool inside_intermediate_do_while = (do_while_depth > parent_dw_depth);
              if (inside_intermediate_do_while) {
                // Emit break to propagate through the do-while, keeping flag set
                if (outer_guard.empty()) {
                  string_stream << spacing << "if (" << parent_flag << ") break;\n";
                } else {
                  string_stream << spacing << "if (" << parent_flag << " && " << outer_guard << ") break;\n";
                }
              } else {
                if (outer_guard.empty()) {
                  string_stream << spacing << "if (" << parent_flag << ") { " << parent_flag << " = false; continue; }\n";
                } else {
                  string_stream << spacing << "if (" << parent_flag << " && " << outer_guard << ") { " << parent_flag << " = false; continue; }\n";
                }
              }
            }
          }
        }
      };

      auto& code_block = current_code_function->code_blocks[line_number];
#if DECOMPILER_DXC_DEBUG >= 1
      string_stream << spacing << "// fn:start " << line_number << "\n";
      if (!pending_convergences.empty()) {
        string_stream << spacing << "// fn:pending ";
        int len = pending_convergences.size();
        for (int i = 0; i < len; ++i) {
          string_stream << pending_convergences[i];
          if (i != len - 1) string_stream << ", ";
        }
        string_stream << "\n";
      }
#endif
      for (const auto& hlsl_line : code_block.hlsl_lines) {
        auto optimized_line = (decompile_options.flatten ? OptimizeString(hlsl_line) : hlsl_line);
        if (optimized_line != hlsl_line) {
#if DECOMPILER_DXC_DEBUG >= 2
          string_stream << spacing << "// optimized: " << hlsl_line << "\n";
#endif
        }
        auto& emit_line = (optimized_line != hlsl_line) ? optimized_line : hlsl_line;
        // Check if this is a variable declaration that was already declared
        // (from convergence scope hoisting). If so, strip the type prefix.
        std::string final_line = emit_line;
        static const std::regex decl_re(R"(^(float4|float3|float2|float|int64_t|uint64_t|int16_t|uint16_t|int|uint|bool|uint4|int4|int2|uint2|int3|uint3|double|half|min16float|min16int|min16uint)\s+(_\d+)\s*=)");
        std::smatch m;
        if (std::regex_search(final_line, m, decl_re)) {
          std::string var_name = m[2].str();
          if (declared_vars.contains(var_name)) {
            // Already pre-declared at convergence scope — emit as assignment only
            final_line = var_name + " =" + m.suffix().str();
          }
        }
        string_stream << spacing << final_line << "\n";
      }
      for (const auto& [variable, type, value, predecessor, code_function, is_assign] : code_block.phi_lines) {
        auto assignment_type = ParseType(type);
        std::string phi_line;
        if (is_assign) continue;
        // Skip if already pre-declared (convergence or function-level)
        auto var_name = std::format("_{}", variable);
        if (phi_predeclared_blocks.contains(line_number) || declared_vars.contains(var_name)) continue;
        // Declare variable now
        phi_line = std::format("{} {};", assignment_type, var_name);
        string_stream << spacing << phi_line << "\n";
      }

      int current_loop = current_loops.empty() ? -1 : current_loop = current_loops.rbegin()[0];

      if (code_block.code_branch.branch_condition_true <= 0 && code_block.code_switch.switch_condition.empty()) {
        return;
      }

      // Wrap branch condition in opaque function to prevent DXC from proving
      // it's constant and eliminating code paths (and their resource accesses)
      auto branch_cond = code_block.code_branch.branch_condition;
      auto branch_cond_neg = branch_cond.empty() ? std::string("") : std::string("!") + ParseWrapped(branch_cond);

      int next_convergence = pending_convergences.empty() ? -1 : pending_convergences.rbegin()[0];

      auto close_lonely_if = [&](int else_code_function) {
        std::vector<std::string> phi_lines = current_code_function->ComputePhiAssignments(&code_block, else_code_function);
        if (phi_lines.empty()) {
          string_stream << spacing << "}\n";
        } else {
          string_stream << spacing << "} else {\n";
          indent_spacing();
          for (const auto& phi_line : phi_lines) {
#if DECOMPILER_DXC_DEBUG >= 2
            string_stream << spacing << "// else_code_function: " << else_code_function << "\n";
#endif
            auto optimized_line = (decompile_options.flatten ? OptimizeString(phi_line) : phi_line);
            if (optimized_line != phi_line) {
#if DECOMPILER_DXC_DEBUG >= 2
              string_stream << spacing << "// optimized: " << phi_line << "\n";
#endif
              string_stream << spacing << optimized_line << "\n";
            } else {
              string_stream << spacing << phi_line << "\n";
            }
          }
          unindent_spacing();
          string_stream << spacing << "}\n";
        }
      };

      auto on_branch = [&](int branch_number, bool is_fallthrough = false) {
        if (!is_fallthrough) {
          for (const auto& phi_line : current_code_function->ComputePhiAssignments(&code_block, branch_number)) {
#if DECOMPILER_DXC_DEBUG >= 2
            string_stream << spacing << "// branch_number: " << branch_number << "\n";
#endif
            auto optimized_line = (decompile_options.flatten ? OptimizeString(phi_line) : phi_line);
            if (optimized_line != phi_line) {
#if DECOMPILER_DXC_DEBUG >= 2
              string_stream << spacing << "// optimized: " << phi_line << "\n";
#endif
              string_stream << spacing << optimized_line << "\n";
            } else {
              string_stream << spacing << phi_line << "\n";
            }
          }
        }
        if (current_loop == branch_number) {
          if (decompile_options.use_do_while && do_while_depth > 0) {
            // Inside a do { } while(false) — continue would target the do-while.
            // Use loop escape flag + break to propagate through the do-while.
            for (size_t i = 0; i < current_loops.size(); i++) {
              if (current_loops[i] == branch_number) {
                string_stream << spacing << loop_escape_flags[i] << " = true;\n";
                string_stream << spacing << "break;\n";
                break;
              }
            }
          } else {
            string_stream << spacing << "continue;\n";
          }
        } else if (std::ranges::find(current_loops, branch_number) != current_loops.end()) {
          // Branch targets an outer natural loop header
          if (decompile_options.use_do_while && current_loop != -1) {
            for (size_t i = 0; i < current_loops.size(); i++) {
              if (current_loops[i] == branch_number) {
                string_stream << spacing << loop_escape_flags[i] << " = true;\n";
                string_stream << spacing << "break;\n";
                break;
              }
            }
          } else {
            string_stream << spacing << "continue;\n";
          }
        } else if (next_convergence == branch_number) {
#if DECOMPILER_DXC_DEBUG >= 1
          string_stream << spacing << "// fn:converge " << line_number << " => " << next_convergence << "\n";
#endif
          // noop
        } else if (std::ranges::find(pending_convergences, branch_number) != pending_convergences.end()) {
          if (decompile_options.use_do_while) {
            // When a convergence break targets the loop exit block and we're
            // inside a do-while nested within the while(true), the plain `break`
            // only exits the do-while. We need an exit flag so the while(true)
            // also exits (without triggering the loop-continue handler).
            // The loop exit block is identified as the post-dominator of any
            // back-edge source — i.e., where control goes when the latch
            // doesn't loop back.
            if (current_loop != -1 && !loop_do_while_depth.empty()) {
              int current_loop_dw_depth = loop_do_while_depth.back();
              if (do_while_depth > current_loop_dw_depth && !pending_recursions.empty()) {
                const auto& back_edge_sources = pending_recursions.back();
                bool is_loop_exit = false;
                for (int src : back_edge_sources) {
                  if (ipdom.contains(src) && ipdom.at(src) == branch_number) {
                    is_loop_exit = true;
                    break;
                  }
                }
                if (is_loop_exit) {
                  for (size_t i = 0; i < current_loops.size(); i++) {
                    if (current_loops[i] == current_loop) {
                      // Emit code and phi assignments for the chain of blocks
                      // after the loop exit. Follow unconditional branches and
                      // emit hlsl_lines + phis at each step until we hit a
                      // conditional branch or a block that's already a pending
                      // convergence.
                      int chain_block = branch_number;
                      while (chain_block > 0 && current_code_function->code_blocks.contains(chain_block)) {
                        auto& cb = current_code_function->code_blocks.at(chain_block);
                        int next_block = cb.code_branch.branch_condition_true;
                        // Only follow unconditional branches (no condition string)
                        if (next_block <= 0 || !cb.code_branch.branch_condition.empty()) break;
                        // Emit the block's hlsl_lines (actual computations).
                        // These may define variables referenced by the phi
                        // assignments below. Without this, the phi assignments
                        // would use stale values from a previous loop iteration.
                        for (const auto& hlsl_line : cb.hlsl_lines) {
                          auto& emit_line = hlsl_line;
                          // Strip type prefix if variable was already declared
                          std::string final_line = emit_line;
                          static const std::regex decl_re(R"(^(float4|float3|float2|float|int64_t|uint64_t|int16_t|uint16_t|int|uint|bool|uint4|int4|int2|uint2|int3|uint3|double|half|min16float|min16int|min16uint)\s+(_\d+)\s*=)");
                          std::smatch m;
                          if (std::regex_search(final_line, m, decl_re)) {
                            std::string var_name = m[2].str();
                            if (declared_vars.contains(var_name)) {
                              final_line = var_name + " =" + m.suffix().str();
                            }
                          }
                          string_stream << spacing << final_line << "\n";
                        }
                        // Emit phi assignments stored in chain_block targeting next_block
                        for (const auto& [variable, type, value, predecessor, code_function_id, is_assign_flag] : cb.phi_lines) {
                          if (code_function_id == next_block && is_assign_flag) {
                            auto assignment_value = current_code_function->ParseByType(value, type);
                            std::string optimized = OptimizeString(assignment_value);
                            string_stream << spacing << "_" << variable << " = " << optimized << ";\n";
                          }
                        }
                        // Continue chain if next_block also has an unconditional branch
                        chain_block = next_block;
                      }
                      string_stream << spacing << loop_exit_flags[i] << " = true;\n";
                      break;
                    }
                  }
                }
              }
            }
            string_stream << spacing << "break;\n";
          } else {
            throw std::runtime_error("Unexpected goto");
          }
        } else if (auto deferred_it = std::ranges::find_if(
                       deferred_branch_targets.rbegin(),
                       deferred_branch_targets.rend(),
                       [&](const auto& entry) {
                         return entry.first == branch_number;
                       });
                   deferred_it != deferred_branch_targets.rend()) {
          // Target is deferred — set the flag instead of inlining the block.
          // The block will be emitted once after the convergence region closes.
          string_stream << spacing << deferred_it->second << " = true;\n";
        } else {
          append_code_block(branch_number);
        }
      };

      if (!code_block.code_switch.switch_condition.empty()) {
        int switch_convergence = -1;
        // Paths must converge
        for (auto& [convergence_line_number, callers] : convergences) {
          bool missing = false;
          bool has_match = false;
          for (const auto branch : code_block.code_switch.branches) {
            if (convergence_line_number == branch || callers.contains(branch)) {
              has_match = true;
            } else {
              missing = true;
              break;
            }
          }
          if (has_match && !missing) {
            switch_convergence = convergence_line_number;
            break;
          }
        }

        assert(switch_convergence != -1);
        pending_convergences.push_back(switch_convergence);

        const auto add_convergence_phis = [&]() {
          for (const auto& phi_line : current_code_function->ComputePhiAssignments(&code_block, switch_convergence)) {
#if DECOMPILER_DXC_DEBUG >= 2
            string_stream << spacing << "// branch_number: " << switch_convergence << "\n";
#endif
            auto optimized_line = (decompile_options.flatten ? OptimizeString(phi_line) : phi_line);
            if (optimized_line != phi_line) {
#if DECOMPILER_DXC_DEBUG >= 2
              string_stream << spacing << "// optimized: " << phi_line << "\n";
#endif
              string_stream << spacing << optimized_line << "\n";
            } else {
              string_stream << spacing << phi_line << "\n";
            }
          }
        };

        string_stream << spacing << "switch (" << code_block.code_switch.switch_condition << ") {\n";
        indent_spacing();

        for (const auto& [case_value, case_function] : code_block.code_switch.case_values) {
          string_stream << spacing << "case " << case_value << ": {\n";
          indent_spacing();
          if (case_function == switch_convergence) {
            add_convergence_phis();
          } else {
            on_branch(case_function);
          }
          string_stream << spacing << "break;\n";
          unindent_spacing();
          string_stream << spacing << "}\n";
        }

        string_stream << spacing << "default: {\n";
        indent_spacing();
        if (code_block.code_switch.case_default == switch_convergence) {
          add_convergence_phis();
        } else {
          on_branch(code_block.code_switch.case_default);
        }
        string_stream << spacing << "break;\n";
        unindent_spacing();
        string_stream << spacing << "}\n";

        unindent_spacing();
        string_stream << spacing << "}\n";

        pending_convergences.pop_back();
        bool is_empty = pending_convergences.empty();
        on_branch(switch_convergence, true);
        if (!is_empty) {
          // if (decompile_options.use_do_while) {
          //   unindent_spacing();
          //   string_stream << spacing << "} while (false);\n";
          // }
        }

        on_complete();

        return;
      }

      if (code_block.code_branch.branch_condition.empty()) {
        on_branch(code_block.code_branch.branch_condition_true);
        on_complete();
        return;
      }

      if (code_block.code_branch.branch_condition_false <= line_number
          && code_block.code_branch.branch_condition_true <= line_number) {
        // Both branches point backwards — this is a conditional at the end of a loop body
        // where both paths loop back (possibly to different loop headers)
        if (current_loop != -1) {
          // We're inside a loop — emit conditional continue/break
          auto true_target = code_block.code_branch.branch_condition_true;
          auto false_target = code_block.code_branch.branch_condition_false;

          // Emit phi assignments for true branch
          if (true_target == current_loop && false_target == current_loop) {
            auto true_phis = current_code_function->ComputePhiAssignments(&current_code_function->code_blocks[line_number], true_target);
            auto false_phis = current_code_function->ComputePhiAssignments(&current_code_function->code_blocks[line_number], false_target);
            if (!true_phis.empty() || !false_phis.empty()) {
              string_stream << spacing << "if (" << branch_cond << ") {\n";
              indent_spacing();
              for (const auto& phi : true_phis) {
                string_stream << spacing << phi << "\n";
              }
              unindent_spacing();
              string_stream << spacing << "} else {\n";
              indent_spacing();
              for (const auto& phi : false_phis) {
                string_stream << spacing << phi << "\n";
              }
              unindent_spacing();
              string_stream << spacing << "}\n";
            }
          } else if (true_target == current_loop) {
            // true branch loops back, false branch exits the loop
            string_stream << spacing << "if (" << branch_cond_neg << ") {\n";
            indent_spacing();
            for (const auto& phi : current_code_function->ComputePhiAssignments(&current_code_function->code_blocks[line_number], false_target)) {
              string_stream << spacing << phi << "\n";
            }
            string_stream << spacing << "break;\n";
            unindent_spacing();
            auto true_phis = current_code_function->ComputePhiAssignments(&current_code_function->code_blocks[line_number], true_target);
            if (!true_phis.empty()) {
              string_stream << spacing << "} else {\n";
              indent_spacing();
              for (const auto& phi : true_phis) {
                string_stream << spacing << phi << "\n";
              }
              unindent_spacing();
            }
            string_stream << spacing << "}\n";
            on_complete();
            on_branch(false_target, true);
            return;
          } else if (false_target == current_loop) {
            // false branch loops back, true branch exits the loop
            // Emit break for exit, continue for loop-back
            string_stream << spacing << "if (" << branch_cond << ") {\n";
            indent_spacing();
            for (const auto& phi : current_code_function->ComputePhiAssignments(&current_code_function->code_blocks[line_number], true_target)) {
              string_stream << spacing << phi << "\n";
            }
            string_stream << spacing << "break;\n";
            unindent_spacing();
            auto false_phis = current_code_function->ComputePhiAssignments(&current_code_function->code_blocks[line_number], false_target);
            if (!false_phis.empty()) {
              string_stream << spacing << "} else {\n";
              indent_spacing();
              for (const auto& phi : false_phis) {
                string_stream << spacing << phi << "\n";
              }
              unindent_spacing();
            }
            string_stream << spacing << "}\n";
            on_complete();
            // After the loop closes, process the exit target
            on_branch(true_target, true);
            return;
          } else {
            string_stream << spacing << "if (" << branch_cond << ") {\n";
            indent_spacing();
            on_branch(true_target);
            unindent_spacing();
            // When the false target is the convergence point, use
            // close_lonely_if to put phi assignments in an else block.
            // Otherwise on_branch emits them unconditionally, overwriting
            // values set by the true branch path.
            if (false_target == next_convergence
                || std::ranges::find(pending_convergences, false_target) != pending_convergences.end()) {
              close_lonely_if(false_target);
            } else {
              string_stream << spacing << "}\n";
              on_branch(false_target);
            }
          }
          on_complete();
          return;
        }
        throw std::exception("Unsupported loop detected.");
      }

      if (code_block.code_branch.branch_condition_true == next_convergence) {
        if (code_block.code_branch.use_hint) {
          string_stream << spacing << "[branch]\n";
        }
        string_stream << spacing << "if (" << branch_cond_neg << ") {\n";
        indent_spacing();
        on_branch(code_block.code_branch.branch_condition_false);
        unindent_spacing();

        close_lonely_if(next_convergence);

        on_complete();
        return;
      }

      if (code_block.code_branch.branch_condition_false == next_convergence) {
        if (code_block.code_branch.use_hint) {
          string_stream << spacing << "[branch]\n";
        }
        string_stream << spacing << std::format("if {} {{\n", ParseWrapped(branch_cond));
        indent_spacing();
        on_branch(code_block.code_branch.branch_condition_true);
        unindent_spacing();

        close_lonely_if(next_convergence);

        on_complete();
        return;
      }

      // Find next convergence for these two items using BFS on the
      // back-edge-free CFG. This finds the first block reachable from
      // both branches, which is the correct convergence point.
      int pair_convergence = -1;
      std::vector<std::pair<int, std::string>> deferred_shared_targets;
      auto branch_true_val = code_block.code_branch.branch_condition_true;
      auto branch_false_val = code_block.code_branch.branch_condition_false;

      int bfs_convergence = CodeFunction::FindPairConvergence(
          branch_true_val, branch_false_val, succs_no_backedge);

      // Use the BFS result if it's valid and not the current next_convergence
      if (bfs_convergence != -1 && bfs_convergence != next_convergence) {
        pair_convergence = bfs_convergence;

        // Detect deferred shared targets BEFORE opening the do-while wrapper,
        // so the flag declarations are at the outer scope and visible after
        // the do-while closes.
        if (!decompile_options.flatten) {
          auto can_defer_shared_target = [&](int candidate_target, bool allow_phi = false) -> bool {
            if (candidate_target <= 0
                || candidate_target == pair_convergence
                || candidate_target <= line_number
                || !current_code_function->code_blocks.contains(candidate_target)
                || recursions.contains(candidate_target)) {
              return false;
            }
            // Reject candidates that are loop latches (branch back to a loop header).
            // Deferring a loop latch breaks the loop structure.
            auto& candidate_block = current_code_function->code_blocks.at(candidate_target);
            if (candidate_block.code_branch.branch_condition_true > 0
                && recursions.contains(candidate_block.code_branch.branch_condition_true)) {
              return false;
            }
            if (candidate_block.code_branch.branch_condition_false > 0
                && recursions.contains(candidate_block.code_branch.branch_condition_false)) {
              return false;
            }
            // Reject candidates that are inside a loop body between line_number
            // and pair_convergence. Deferring blocks inside loops causes the
            // convergence guard (if(!flag)) to skip loop iterations.
            for (const auto& [header, body] : loop_bodies) {
              if (header > line_number && header < pair_convergence
                  && body.contains(candidate_target)) {
                return false;
              }
            }
            auto pred_it = predecessors.find(candidate_target);
            if (pred_it == predecessors.end() || pred_it->second.size() < 2) {
              return false;
            }
            for (int pred : pred_it->second) {
              if (!current_code_function->code_blocks.contains(pred)) return false;
              auto dom_it = dominators.find(pred);
              if (dom_it == dominators.end() || !dom_it->second.contains(line_number)) return false;
              if (!allow_phi
                  && !current_code_function->ComputePhiAssignments(
                         &current_code_function->code_blocks.at(pred), candidate_target)
                          .empty()) {
                return false;
              }
            }
            return true;
          };

          std::optional<int> best_deferred;
          size_t best_pred_count = 0;
          for (const auto& [candidate, _cb] : current_code_function->code_blocks) {
            if (!can_defer_shared_target(candidate)) continue;
            auto existing = std::ranges::find_if(
                deferred_branch_targets.rbegin(), deferred_branch_targets.rend(),
                [&](const auto& e) { return e.first == candidate; });
            if (existing != deferred_branch_targets.rend()) continue;
            size_t count = predecessors.at(candidate).size();
            if (!best_deferred.has_value() || count > best_pred_count
                || (count == best_pred_count && candidate > best_deferred.value())) {
              best_deferred = candidate;
              best_pred_count = count;
            }
          }

          if (best_deferred.has_value()) {
            auto existing = std::ranges::find_if(
                deferred_branch_targets.rbegin(), deferred_branch_targets.rend(),
                [&](const auto& e) { return e.first == best_deferred.value(); });
            if (existing == deferred_branch_targets.rend()) {
              auto flag_name = std::format("__defer_{}_{}", line_number, best_deferred.value());
              string_stream << spacing << "bool " << flag_name << " = false;\n";
              deferred_branch_targets.emplace_back(best_deferred.value(), flag_name);
              deferred_shared_targets.emplace_back(best_deferred.value(), flag_name);
            }
          }

          // Secondary deferred target with phi assignments spanning both sides.
          auto candidate_spans_both_sides = [&](int candidate_target) -> bool {
            auto pred_it = predecessors.find(candidate_target);
            if (pred_it == predecessors.end() || pred_it->second.size() < 2) return false;
            bool has_true = (candidate_target == branch_true_val);
            bool has_false = (candidate_target == branch_false_val);
            for (int pred : pred_it->second) {
              auto dom_it = dominators.find(pred);
              if (dom_it == dominators.end()) continue;
              if (pred == branch_true_val || dom_it->second.contains(branch_true_val)) has_true = true;
              if (pred == branch_false_val || dom_it->second.contains(branch_false_val)) has_false = true;
            }
            return has_true && has_false;
          };

          std::optional<int> secondary_deferred;
          size_t secondary_pred_count = 0;
          for (const auto& [candidate, _cb] : current_code_function->code_blocks) {
            if (best_deferred.has_value() && candidate == best_deferred.value()) continue;
            if (!candidate_spans_both_sides(candidate)) continue;
            if (!can_defer_shared_target(candidate, true)) continue;
            bool has_phi = false;
            auto pred_it = predecessors.find(candidate);
            if (pred_it != predecessors.end()) {
              for (int pred : pred_it->second) {
                if (!current_code_function->ComputePhiAssignments(
                         &current_code_function->code_blocks.at(pred), candidate)
                         .empty()) {
                  has_phi = true;
                  break;
                }
              }
            }
            if (!has_phi) continue;
            auto existing = std::ranges::find_if(
                deferred_branch_targets.rbegin(), deferred_branch_targets.rend(),
                [&](const auto& e) { return e.first == candidate; });
            if (existing != deferred_branch_targets.rend()) continue;
            size_t count = predecessors.at(candidate).size();
            if (!secondary_deferred.has_value() || count > secondary_pred_count
                || (count == secondary_pred_count && candidate > secondary_deferred.value())) {
              secondary_deferred = candidate;
              secondary_pred_count = count;
            }
          }

          if (secondary_deferred.has_value()) {
            auto existing = std::ranges::find_if(
                deferred_branch_targets.rbegin(), deferred_branch_targets.rend(),
                [&](const auto& e) { return e.first == secondary_deferred.value(); });
            if (existing == deferred_branch_targets.rend()) {
              auto flag_name = std::format("__defer_{}_{}", line_number, secondary_deferred.value());
              string_stream << spacing << "bool " << flag_name << " = false;\n";
              deferred_branch_targets.emplace_back(secondary_deferred.value(), flag_name);
              deferred_shared_targets.emplace_back(secondary_deferred.value(), flag_name);
            }
          }
        }

        if (!pending_convergences.empty()) {
          if (decompile_options.use_do_while) {
            convergence_bypass_flags.push_back("");
            convergence_bypass_targets.push_back(-1);
            do_while_depth++;
            string_stream << spacing << "do {\n";
            indent_spacing();
          } else {
            convergence_bypass_flags.push_back("");
            convergence_bypass_targets.push_back(-1);
          }
        } else {
          convergence_bypass_flags.push_back("");
          convergence_bypass_targets.push_back(-1);
        }
        pending_convergences.push_back(pair_convergence);
      } else if (bfs_convergence == next_convergence && next_convergence != -1) {
        // Both branches converge at the already-pending convergence point.
        // Emit if/else — both paths will reach next_convergence naturally.
        if (code_block.code_branch.use_hint) {
          string_stream << spacing << "[branch]\n";
        }
        if (branch_true_val < branch_false_val) {
          string_stream << spacing << std::format("if {} {{\n", ParseWrapped(branch_cond));
          indent_spacing();
          on_branch(branch_true_val);
          unindent_spacing();
          string_stream << spacing << "} else {\n";
          indent_spacing();
          on_branch(branch_false_val);
          unindent_spacing();
          string_stream << spacing << "}\n";
        } else {
          string_stream << spacing << "if (" << branch_cond_neg << ") {\n";
          indent_spacing();
          on_branch(branch_false_val);
          unindent_spacing();
          string_stream << spacing << "} else {\n";
          indent_spacing();
          on_branch(branch_true_val);
          unindent_spacing();
          string_stream << spacing << "}\n";
        }
        on_complete();
        return;
      }

      // Pre-declare phi variables for the convergence block.
      if (pair_convergence != -1 && current_code_function->code_blocks.contains(pair_convergence)) {
        for (const auto& [variable, type, value, predecessor, code_function, is_assign] : current_code_function->code_blocks[pair_convergence].phi_lines) {
          if (is_assign) continue;
          auto var_name = std::format("_{}", variable);
          if (!declared_vars.contains(var_name)) {
            string_stream << spacing << ParseType(type) << " " << var_name << ";\n";
            declared_vars.insert(var_name);
          }
        }
        phi_predeclared_blocks.insert(pair_convergence);
      }

      if (pair_convergence == code_block.code_branch.branch_condition_true) {
        // When inside a do-while, pre-initialize phi variables with their
        // else-branch (convergence) values before the if block. This avoids
        // emitting if-else phi assignments that DXC can constant-fold through,
        // which causes dead code elimination of reachable SampleLevel calls.
        if (do_while_depth > 0) {
          auto convergence_phis = current_code_function->ComputePhiAssignments(&code_block, pair_convergence);
          for (const auto& phi_line : convergence_phis) {
            string_stream << spacing << phi_line << "\n";
          }
        }
        if (code_block.code_branch.use_hint) {
          string_stream << spacing << "[branch]\n";
        }
        string_stream << spacing << "if (" << branch_cond_neg << ") {\n";
        indent_spacing();
        on_branch(code_block.code_branch.branch_condition_false);
        unindent_spacing();

        if (do_while_depth > 0) {
          string_stream << spacing << "}\n";
        } else {
          close_lonely_if(pair_convergence);
        }

        // Only print else
      } else if (pair_convergence == code_block.code_branch.branch_condition_false) {
        // Same do-while pre-initialization for the symmetric case.
        if (do_while_depth > 0) {
          auto convergence_phis = current_code_function->ComputePhiAssignments(&code_block, pair_convergence);
          for (const auto& phi_line : convergence_phis) {
            string_stream << spacing << phi_line << "\n";
          }
        }
        if (code_block.code_branch.use_hint) {
          string_stream << spacing << "[branch]\n";
        }
        string_stream << spacing << std::format("if {} {{\n", ParseWrapped(branch_cond));
        indent_spacing();
        on_branch(code_block.code_branch.branch_condition_true);
        unindent_spacing();

        if (do_while_depth > 0) {
          string_stream << spacing << "}\n";
        } else {
          close_lonely_if(pair_convergence);
        }

      } else if (code_block.code_branch.branch_condition_true < code_block.code_branch.branch_condition_false) {
        if (code_block.code_branch.use_hint) {
          string_stream << spacing << "[branch]\n";
        }
        string_stream << spacing << std::format("if {} {{\n", ParseWrapped(branch_cond));
        indent_spacing();
        on_branch(code_block.code_branch.branch_condition_true);
        unindent_spacing();
        string_stream << spacing << "} else {\n";
        indent_spacing();
        on_branch(code_block.code_branch.branch_condition_false);
        unindent_spacing();
        string_stream << spacing << "}\n";
      } else {
        if (code_block.code_branch.use_hint) {
          string_stream << spacing << "[branch]\n";
        }
        string_stream << spacing << "if (" << branch_cond_neg << ") {\n";
        indent_spacing();
        on_branch(code_block.code_branch.branch_condition_false);
        unindent_spacing();
        string_stream << spacing << "} else {\n";
        indent_spacing();
        on_branch(code_block.code_branch.branch_condition_true);
        unindent_spacing();
        string_stream << spacing << "}\n";
      }

      if (pair_convergence != -1) {
        pending_convergences.pop_back();
        bool is_empty = pending_convergences.empty();
        // Pop both stacks together to keep them in sync.
        convergence_bypass_flags.pop_back();
        convergence_bypass_targets.pop_back();
        // If deferred targets exist, wrap the convergence block in if(!flag)
        // so it's skipped when the bypass path was taken. This prevents the
        // convergence code (which may include a loop) from executing when
        // the bypass already computed the final values.
        bool has_defer_guard = !deferred_shared_targets.empty() && decompile_options.use_do_while;
        if (has_defer_guard) {
          // Use the first deferred flag as the guard — if any deferred path
          // was taken, the convergence block should be skipped.
          string_stream << spacing << "if (!" << deferred_shared_targets.front().second << ") {\n";
          indent_spacing();
        }
        on_branch(pair_convergence, true);
        if (has_defer_guard) {
          unindent_spacing();
          string_stream << spacing << "}\n";
        }
        if (!is_empty) {
          if (decompile_options.use_do_while) {
            do_while_depth--;
            unindent_spacing();
            string_stream << spacing << "} while (false);\n";
            // After the do-while, propagate any loop escape flags that were set
            // inside it. A continue inside the do-while targeted the do-while
            // (exiting it), so we need to check flags and re-emit the continue
            // for the correct while(true) loop.
            if (!loop_escape_flags.empty()) {
              auto& parent_flag = loop_escape_flags.back();
              auto& exit_flag = loop_exit_flags.back();
              // Build the flag condition: parent_flag, or (parent_flag || exit_flag) if exit flag exists
              std::string flag_cond = exit_flag.empty()
                  ? parent_flag
                  : ("(" + parent_flag + " || " + exit_flag + ")");
              // Build condition: flag is set AND no outer flags are set
              std::string outer_guard;
              for (int i = static_cast<int>(loop_escape_flags.size()) - 2; i >= 0; i--) {
                if (!outer_guard.empty()) outer_guard += " && ";
                outer_guard += "!" + loop_escape_flags[i];
              }
              // Check if we're still inside a do-while(false) between us and
              // the target while(true). If so, 'continue' would target that
              // intermediate do-while instead of the while(true).
              int target_dw_depth = loop_do_while_depth.back();
              bool inside_intermediate_do_while = (do_while_depth > target_dw_depth);
              if (inside_intermediate_do_while) {
                // Emit break to propagate through the next do-while level,
                // keeping the flag set for the next handler.
                if (outer_guard.empty()) {
                  string_stream << spacing << "if (" << flag_cond << ") break;\n";
                } else {
                  string_stream << spacing << "if (" << flag_cond << " && " << outer_guard << ") break;\n";
                }
              } else {
                // At the same do-while depth as the target while(true).
                // For loop-continue (parent_flag): reset and continue.
                // For loop-exit (exit_flag): the continue check only fires for parent_flag.
                if (outer_guard.empty()) {
                  string_stream << spacing << "if (" << parent_flag << ") { " << parent_flag << " = false; continue; }\n";
                } else {
                  string_stream << spacing << "if (" << parent_flag << " && " << outer_guard << ") { " << parent_flag << " = false; continue; }\n";
                }
              }
            }
          }
        }
      };

      // Process deferred shared targets: emit each deferred block once,
      // guarded by its flag. This runs AFTER the convergence region closes,
      // so DXC can't eliminate the code through SSA analysis of the
      // convergence's control flow.
      for (const auto& [deferred_target, deferred_flag] : deferred_shared_targets) {
        string_stream << spacing << "if (" << deferred_flag << ") {\n";
        indent_spacing();
        append_code_block(deferred_target);
        unindent_spacing();
        string_stream << spacing << "}\n";
      }
      // Pop deferred targets that were registered for this convergence level.
      for (size_t i = 0; i < deferred_shared_targets.size(); ++i) {
        deferred_branch_targets.pop_back();
      }

      on_complete();
    };

    for (const auto& decompiled : preprocess_state.global_variables_decompiled) {
      string_stream << decompiled << "\n";
    }
    if (!preprocess_state.global_variables_decompiled.empty()) {
      string_stream << "\n";
    }

    auto output_signature_count = preprocess_state.output_signature.size();

    std::string threads;
    if (!current_code_function->threads.empty()) {
      threads = std::format("[numthreads({}, {}, {})]\n",
                            current_code_function->threads[0],
                            current_code_function->threads[1],
                            current_code_function->threads[2]);
    }

    if (output_signature_count == 0) {
      string_stream << threads;
      string_stream << "void";
    } else if (output_signature_count == 1) {
      string_stream << preprocess_state.output_signature[0].FullFormatString();
    } else {
      string_stream << "struct OutputSignature {\n";
      for (const auto& signature : preprocess_state.output_signature) {
        string_stream << "  " << signature.ToString() << ";\n";
      }
      string_stream << "};\n";
      string_stream << "\n";
      string_stream << threads;
      string_stream << "OutputSignature";
    }

    string_stream << " main(";
    {
      // For mermaid strategy, prefix input params with __
      // to avoid conflict with static module-scope copies.
      bool mermaid_rename = decompile_options.mermaid_decompile;
      if (threads.empty()) {
        auto len = preprocess_state.input_signature.size();
        if (len > 0) string_stream << "\n";
        std::vector<std::pair<uint32_t, Signature>> sorted_inputs;
        sorted_inputs.reserve(preprocess_state.input_signature.size());
        for (const auto& signature : preprocess_state.input_signature) {
          sorted_inputs.emplace_back(signature.packed.dxregister, signature);
        }
        std::ranges::sort(sorted_inputs,
                          [](const auto& a, const auto& b) { return a.first < b.first; });

        auto it = sorted_inputs.begin();
        auto end = sorted_inputs.end();
        for (; it != end; ++it) {
          const auto& signature = it->second;
          if (mermaid_rename) {
            // Include interpolation mode in the renamed parameter declaration
            // so DXIL validation passes (especially for SV_Position which requires
            // specific interpolation modes).
            string_stream << "  ";
            // Emit interpolation mode prefix
            switch (signature.property.interp_mode) {
              case SignatureProperty::InterpMode::NOINTERPOLATION:
                string_stream << "nointerpolation "; break;
              case SignatureProperty::InterpMode::LINEAR:
                string_stream << "linear "; break;
              case SignatureProperty::InterpMode::NOPERSPECTIVE:
                string_stream << "noperspective "; break;
              case SignatureProperty::InterpMode::NOPERSPECTIVE_SAMPLE:
                string_stream << "noperspective sample "; break;
              case SignatureProperty::InterpMode::NOPERSPECTIVE_CENTROID:
                string_stream << "noperspective centroid "; break;
              case SignatureProperty::InterpMode::CENTROID:
                string_stream << "centroid "; break;
              default: break;
            }
            string_stream << signature.FullFormatString() << " __" << signature.VariableString()
                          << " : " << signature.SemanticString();
          } else {
            string_stream << "  " << signature.ToString();
          }
          if (std::next(it) != end) {
            string_stream << ",";
          } else if (preprocess_state.uses_view_id) {
            string_stream << ",";
          }
          string_stream << "\n";
        }
        if (preprocess_state.uses_view_id) {
          string_stream << "  uint SV_ViewID : SV_ViewID\n";
        }
      } else {
        string_stream << "\n";
        if (mermaid_rename) {
          string_stream << "  uint3 __SV_DispatchThreadID : SV_DispatchThreadID,\n";
          string_stream << "  uint3 __SV_GroupID : SV_GroupID,\n";
          string_stream << "  uint3 __SV_GroupThreadID : SV_GroupThreadID,\n";
          string_stream << "  uint __SV_GroupIndex : SV_GroupIndex\n";
        } else {
          string_stream << "  uint3 SV_DispatchThreadID : SV_DispatchThreadID,\n";
          string_stream << "  uint3 SV_GroupID : SV_GroupID,\n";
          string_stream << "  uint3 SV_GroupThreadID : SV_GroupThreadID,\n";
          string_stream << "  uint SV_GroupIndex : SV_GroupIndex\n";
        }
      }
    }
    string_stream << ")";
    if (output_signature_count == 1) {
      string_stream << " : " << preprocess_state.output_signature[0].SemanticString();
    }
    string_stream << " {\n";

    for (const auto& signature : preprocess_state.output_signature) {
      string_stream << "  " << signature.FullFormatString();
      string_stream << " " << signature.VariableString() << ";\n";
    }

    indent_spacing();

    // For mermaid strategy, phi-barrier function declarations are collected here
    // and spliced before main() after code generation.
    std::stringstream mermaid_module_vars;       // Only used for PS input statics now
    std::stringstream mermaid_pre_main_functions; // Phi-barrier functions

    // For mermaid v2 strategy, emit input variable copies.
    // Compute: copy __SV_* params to local vars at start of main()
    // Pixel: copy __TEXCOORD etc. to local vars declared at function scope
    // No more static module-scope — everything is local since there are no region functions.
    if (decompile_options.mermaid_decompile) {
      bool is_compute = !threads.empty();
      if (is_compute) {
        if (preprocess_state.input_signature.empty()) {
          // Declare local copies and assign from renamed params
          string_stream << spacing << "uint3 SV_DispatchThreadID = __SV_DispatchThreadID;\n";
          string_stream << spacing << "uint3 SV_GroupID = __SV_GroupID;\n";
          string_stream << spacing << "uint3 SV_GroupThreadID = __SV_GroupThreadID;\n";
          string_stream << spacing << "uint SV_GroupIndex = __SV_GroupIndex;\n";
        }
      } else {
        // Pixel shader: declare local copies and assign from renamed params.
        // Interpolation modes are on the parameter declaration — by the time
        // main() executes, interpolation is done and values are plain floats.
        for (const auto& sig : preprocess_state.input_signature) {
          std::string var = sig.VariableString();
          std::string type = sig.FullFormatString();
          string_stream << spacing << type << " " << var << " = __" << var << ";\n";
        }
      }
    }

    // Pre-declare all SSA variables at function scope to avoid scoping
    // issues when convergence optimization eliminates node splitting.
    // Variables defined inside if/else branches may be referenced by
    // convergence fallthrough blocks at a higher scope level.
    {
      // Helper: zero-initializer for a given HLSL type name.
      // Using zero for all types. The decompiler's structured HLSL should
      // assign all variables on all reachable paths. Zero initialization
      // passes DXIL validation and doesn't poison DXC's optimizer.
      auto zero_init_for_type = [](const std::string& type_name) -> std::string {
        if (type_name == "bool") return " = false";
        if (type_name == "int" || type_name == "int16_t" || type_name == "int64_t") return " = 0";
        if (type_name == "uint" || type_name == "uint16_t" || type_name == "uint64_t") return " = 0u";
        if (type_name == "half" || type_name == "min16float") return " = 0.0h";
        if (type_name == "double") return " = 0.0";
        if (type_name == "float") return " = 0.0f";
        if (type_name == "float2") return " = float2(0.0f, 0.0f)";
        if (type_name == "float3") return " = float3(0.0f, 0.0f, 0.0f)";
        if (type_name == "float4") return " = float4(0.0f, 0.0f, 0.0f, 0.0f)";
        if (type_name == "int2") return " = int2(0, 0)";
        if (type_name == "int3") return " = int3(0, 0, 0)";
        if (type_name == "int4") return " = int4(0, 0, 0, 0)";
        if (type_name == "uint2") return " = uint2(0u, 0u)";
        if (type_name == "uint3") return " = uint3(0u, 0u, 0u)";
        if (type_name == "uint4") return " = uint4(0u, 0u, 0u, 0u)";
        return " = 0";
      };
      // For mermaid v2 strategy, declare variables at function scope (local)
      // since everything is emitted inline in main(). No more static module-scope.
      bool use_module_scope = false;

      // Zero-initialize pre-declared variables to pass DXIL validation.
      // DXC's validator rejects reads of uninitialized values. The structured
      // HLSL may create paths where a variable isn't assigned (due to branch
      // restructuring), so zero initialization is needed for validation.
      // The opaque condition removal and convergence fixes prevent DXC from
      // exploiting zero values at branch points in most cases.
      bool use_zero_init = decompile_options.mermaid_decompile;
      bool use_phi_zero_init = use_zero_init;

      static const std::regex var_decl_re(R"(^(float4|float3|float2|float|int|uint|bool|uint4|int4|int2|uint2|int3|uint3|double|int64_t|uint64_t|int16_t[234]?|uint16_t[234]?|half[234]?|min16float[234]?|min16int[234]?|min16uint[234]?|[A-Z_]\w*)\s+(_\d+)\s*=)");
      // Also match "Type _NNN;" declarations without assignment (e.g., from InterlockedAdd output params:
      // "int _259; InterlockedAdd(..., _259);")
      static const std::regex var_decl_noassign_re(R"(^(float4|float3|float2|float|int|uint|bool|uint4|int4|int2|uint2|int3|uint3|double|int64_t|uint64_t|int16_t[234]?|uint16_t[234]?|half[234]?|min16float[234]?|min16int[234]?|min16uint[234]?|[A-Z_]\w*)\s+(_\d+)\s*;)");
      for (const auto& [block_num, cb] : current_code_function->code_blocks) {
        for (const auto& hl : cb.hlsl_lines) {
          std::smatch m;
          if (std::regex_search(hl, m, var_decl_re)) {
            std::string var_name = m[2].str();
            if (!declared_vars.contains(var_name)) {
              std::string type_name = m[1].str();
              auto& target = use_module_scope ? mermaid_module_vars : string_stream;
              std::string prefix = use_module_scope ? "static " : spacing;
              if (use_zero_init) {
                target << prefix << type_name << " " << var_name << zero_init_for_type(type_name) << ";\n";
              } else {
                target << prefix << type_name << " " << var_name << ";\n";
              }
              declared_vars.insert(var_name);
            }
          } else if (std::regex_search(hl, m, var_decl_noassign_re)) {
            // Catch "Type _NNN; ..." declarations (e.g., atomic output params)
            std::string var_name = m[2].str();
            if (!declared_vars.contains(var_name)) {
              std::string type_name = m[1].str();
              auto& target = use_module_scope ? mermaid_module_vars : string_stream;
              std::string prefix = use_module_scope ? "static " : spacing;
              if (use_zero_init) {
                target << prefix << type_name << " " << var_name << zero_init_for_type(type_name) << ";\n";
              } else {
                target << prefix << type_name << " " << var_name << ";\n";
              }
              declared_vars.insert(var_name);
            }
          }
        }
        // Also pre-declare phi variables
        for (const auto& [variable, type, value, predecessor, code_function, is_assign] : cb.phi_lines) {
          if (is_assign) continue;
          auto var_name = std::format("_{}", variable);
          if (!declared_vars.contains(var_name)) {
            std::string hlsl_type = ParseType(type);
            auto& target = use_module_scope ? mermaid_module_vars : string_stream;
            std::string prefix = use_module_scope ? "static " : spacing;
            if (use_phi_zero_init) {
              target << prefix << hlsl_type << " " << var_name << zero_init_for_type(hlsl_type) << ";\n";
            } else if (use_zero_init) {
              target << prefix << hlsl_type << " " << var_name << zero_init_for_type(hlsl_type) << ";\n";
            } else {
              target << prefix << hlsl_type << " " << var_name << ";\n";
            }
            declared_vars.insert(var_name);
          }
        }
      }

      // For mermaid strategy, also pre-declare alloca arrays at function scope
      // so they're available across all scopes within main().
      if (decompile_options.mermaid_decompile) {
        static const std::regex alloca_re(R"(^(float|int|uint)\s+(_\d+)\[(\d+)\])");
        for (const auto& [block_num, cb] : current_code_function->code_blocks) {
          for (const auto& hl : cb.hlsl_lines) {
            std::smatch m;
            if (std::regex_search(hl, m, alloca_re)) {
              std::string var_name = m[2].str();
              if (!declared_vars.contains(var_name)) {
                string_stream << spacing << m[1].str() << " " << var_name << "[" << m[3].str() << "];\n";
                declared_vars.insert(var_name);
              }
            }
          }
        }
      }

      // Pre-declare heap resource variables (_HeapResource_N) at function scope.
      // ResourceDescriptorHeap[] declarations CANNOT be at module scope because
      // DXC ignores initializers of external globals, causing "Explicit load/store
      // type does not match pointee type" validation errors.
      //
      // For mermaid, we intentionally DO NOT hoist heap resource declarations to
      // function scope. The declaration uses an SSA index variable (e.g., _404)
      // that is zero-initialized at function scope and only assigned inside a
      // guarded block. A function-scope hoist would read _404 = 0 and construct
      // a handle to descriptor heap slot 0. The mermaid emitter re-declares the
      // heap resource at the top of every block that uses it instead.
      // (See heap_decls_to_inject in mermaid_decompile.hpp.)
      if (decompile_options.mermaid_decompile) {
        // intentional no-op
      } else {
        static const std::regex heap_re(R"(^(.+\s+_HeapResource_\d+\s*=\s*ResourceDescriptorHeap\[.+\]);)");
        std::set<std::string> hoisted_heap_lines;
        for (const auto& [block_num, cb] : current_code_function->code_blocks) {
          for (const auto& hl : cb.hlsl_lines) {
            std::smatch m;
            if (std::regex_search(hl, m, heap_re)) {
              static const std::regex name_re(R"((_HeapResource_\d+))");
              std::smatch nm;
              if (std::regex_search(hl, nm, name_re)) {
                std::string var_name = nm[1].str();
                if (!declared_vars.contains(var_name)) {
                  string_stream << spacing << hl << "\n";
                  declared_vars.insert(var_name);
                  hoisted_heap_lines.insert(hl);
                }
              }
            }
          }
        }
        // Remove hoisted declarations from code blocks to prevent duplication
        for (auto& [block_num, cb] : current_code_function->code_blocks) {
          std::erase_if(cb.hlsl_lines, [&](const std::string& line) {
            return hoisted_heap_lines.contains(line);
          });
        }
      }
    }

    // Emit hoisted RayQuery declarations at function scope
    // For mermaid v2, also at function scope (no more module scope needed)
    for (const auto& rq_decl : current_code_function->ray_query_declarations) {
      string_stream << spacing << rq_decl << "\n";
    }

    if (decompile_options.structural) {
      // Attempt structural code generation; fall back to use-do-while on unsupported patterns.
      auto stream_pos_before_structural = string_stream.tellp();
      try {
#include "shader_decompiler/structural.hpp"
      } catch (const std::runtime_error& structural_error) {
        // Reset stream to before structural output and fall back to use-do-while
        std::cerr << "WARNING: Structural decompilation failed, falling back to use-do-while: "
                  << structural_error.what() << "\n";
        string_stream.seekp(stream_pos_before_structural);
        std::string truncated = string_stream.str().substr(0, static_cast<size_t>(stream_pos_before_structural));
        string_stream.str(truncated);
        string_stream.seekp(0, std::ios_base::end);
        string_stream << spacing << "// Structural fallback: " << structural_error.what() << "\n";
        append_code_block(0);
      }
    } else if (decompile_options.mermaid_decompile) {
#include "shader_decompiler/mermaid_decompile.hpp"
    } else if (decompile_options.stackify) {
#include "shader_decompiler/stackify.hpp"
    } else {
      append_code_block(0);
    }
    unindent_spacing();

    if (output_signature_count == 0) {
    } else if (output_signature_count == 1) {
      string_stream << "  return " << preprocess_state.output_signature[0].VariableString() << ";\n";
    } else {
      string_stream << "  OutputSignature output_signature = {";
      for (int i = 0; i < output_signature_count; ++i) {
        auto& signature = preprocess_state.output_signature[i];
        string_stream << " " << signature.VariableString();
        if (i != (output_signature_count - 1)) string_stream << ",";
      }
      string_stream << " };\n";
      string_stream << "  return output_signature;\n";
    }

    string_stream << "}\n";
#if DECOMPILER_DXC_DEBUG == 3
    return "";
#else
    auto output = string_stream.str();
    if (!decompile_options.annotate && !decompile_options.mermaid_decompile) {
      output = OptimizeWholeStructBufferStores(output);
      output = OptimizeDeferredBoolBridgeBlocks(output);
      output = OptimizeSingleUseBoolChains(output);
      output = OptimizeUpperBoundGuardLoads(output);
      output = OptimizeSentinelBoolIntGuards(output);
      output = OptimizeBoolCarrierAssignments(output);
      output = OptimizeTrailingBoolFallbackElse(output);
      output = OptimizeSentinelBoolIntGuards(output);  // second pass
      output = OptimizeVisibilityBindlessIndices(output);
      output = OptimizeVisibilityParamIndexSelection(output);
      output = OptimizeVectorComponentTempArrays(output);
      output = OptimizeRepeatedStoreAddresses(output);
      output = OptimizeUnusedLocalAssignments(output);
      output = OptimizeDeferredSiblingGuards(output);
      output = OptimizeDeferredSelectorSentinels(output);
      output = OptimizeNestedReductionLoops(output);
      output = OptimizeVectorMaskedDots(output);
    }

    // Mermaid-safe post-processing passes: struct buffer store/load optimization.
    // These combine field-by-field stores into single struct stores and consecutive
    // component loads into vector loads. Safe for mermaid output because they don't
    // affect control flow or phi assignments.
    if (decompile_options.mermaid_decompile && !decompile_options.annotate) {
      output = OptimizeWholeStructBufferStores(output);
      output = OptimizeStructuredResourceVectorLoads(output);
    }

    // Mermaid v2 post-processing: splice phi-barrier functions before main().
    if (decompile_options.mermaid_decompile) {
      std::string region_funcs = mermaid_pre_main_functions.str();

      if (!region_funcs.empty()) {
        auto main_pos = output.find(" main(");
        if (main_pos != std::string::npos) {
          auto line_start = output.rfind('\n', main_pos);
          if (line_start == std::string::npos) line_start = 0;
          else line_start += 1;
          // Check if the previous line is a [numthreads] attribute
          if (line_start > 1) {
            auto prev_line_end = line_start - 1;
            auto prev_line_start = output.rfind('\n', prev_line_end - 1);
            if (prev_line_start == std::string::npos) prev_line_start = 0;
            else prev_line_start += 1;
            std::string prev_line = output.substr(prev_line_start, prev_line_end - prev_line_start);
            if (prev_line.find("[numthreads") != std::string::npos) {
              line_start = prev_line_start;
            }
          }
          output.insert(line_start, region_funcs + "\n");
        }
      }
    }

    return output;
#endif
  }

#include "shader_decompiler/postprocess.hpp"
};  // namespace Decompiler

}  // namespace renodx::utils::shader::decompiler::dxc
