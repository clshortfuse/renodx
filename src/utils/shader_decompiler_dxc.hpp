/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <algorithm>
#include <array>
#include <cassert>
#include <cmath>
#include <cstdint>
#include <cstdlib>
#include <exception>
#include <format>
#include <functional>
#include <iostream>
#include <iterator>
#include <map>
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
    throw std::invalid_argument("Could not parse index");
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
    return std::format("{}", input);
  }

  static std::string ParseUintString(std::string_view input) {
    return std::format("{}u", input);
  }

  static std::string ParseSuffixedString(std::string_view input, char suffix = 'f') {
    std::string output;

    if (input == "0x7FF0000000000000") return "+1.#INF";
    if (input == "0xH7C00") return "+1.#INF";  // Special case for bfloat16 infinity
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
      memcpy(&as_float, &float_bits, sizeof(as_float));  // Reinterpret bits
      output = std::format("{}", as_float);
    } else if (input.starts_with("0x")) {
      const std::string string = std::string{input};
      auto unsigned_long = strtoull(string.c_str(), nullptr, 16);
      uint64_t as_uint64 = unsigned_long;
      double_t as_double;
      memcpy(&as_double, &as_uint64, sizeof(as_double));
      output = std::format("{}", as_double);
    } else {
      double_t as_double;
      FromStringView(input, as_double);
      output = std::format("{}", as_double);
    }
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
    if (input == "i32") return "int";
    if (input == "f16") return "min16float";
    if (input == "i16") return "min16int";
    if (input == "i1") return "bool";
    throw std::invalid_argument("Could not parse code type");
  }

  static std::string ParseBitcast(std::string_view input) {
    if (input == "float") return "asfloat";
    if (input == "i32") return "asint";
    if (input == "i1") return "bool";
    throw std::invalid_argument("Could not parse bitcast");
  }

  static std::string ParseTrunc(std::string_view input) {
    if (input == "i16") return "min16int";
    if (input == "half") return "half";
    throw std::invalid_argument("Could not parse trunc");
  }

  static std::string ParseUnsignedType(std::string_view input) {
    if (input == "i32") return "uint";
    if (input == "i16") return "min16uint";
    if (input == "i1") return "bool";
    throw std::invalid_argument("Could not parse unsigned");
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
    throw std::invalid_argument("Could not parse code assignment operator");
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
      {"33", "firstbithigh"},  // uint
      {"34", "firstbithigh"},  // int
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

  static std::string OptimizeString(std::string_view line) {
    auto optimized = std::string(line);
    {
      // (((b - a) * t) + a)
      static const auto LERP_REGEX_1 = std::regex(R"(^.*\(\(\(((?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?)) - ((?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?))\) \* ((?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?))\) \+ ((?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?))\).*$)");
      const auto [b, a, t, a2] = StringViewMatch<4>(optimized, LERP_REGEX_1);
      if (!b.empty() && !a.empty() && !t.empty() && !a2.empty()) {
        std::string_view prefix = {optimized.data(), b.data() - 3};
        std::string_view suffix = {a2.data() + a2.size() + 1, optimized.data() + optimized.size()};
        optimized = std::format("{}(lerp({}, {}, {})){}", prefix, a, b, t, suffix);
      }
    }
    {
      // "((b - a) * t) + a"
      static const auto LERP_REGEX_1 = std::regex(R"(^\(\(((?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?)) - ((?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?))\) \* ((?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?))\) \+ ((?:_\d+)|[a-zA-z._0-9]+|(?:\d+u?\.?\d+?f?))$)");
      const auto [b, a, t, a2] = StringViewMatch<4>(optimized, LERP_REGEX_1);
      if (!b.empty() && !a.empty() && !t.empty() && !a2.empty()) {
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
      UINT
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
        case Format::UINT:  return "uint";
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
          throw std::invalid_argument("Unknown mask");
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
            throw std::invalid_argument("Unknown coordinate");
        }
      }
      return flags;
    }

    static Format FormatFromString(std::string_view input) {
      if (input == "float") return Format::FLOAT;
      if (input == "uint") return Format::UINT;
      throw std::invalid_argument("Unknown Format");
    }

    explicit SignaturePacked() = default;
    explicit SignaturePacked(std::string_view line) {
      /**
       * @example
       * ; TEXCOORD                 0   xy          0     NONE   float   xy
       * ; SV_Position              0   xyzw        1      POS   float
       * ; SV_RenderTargetArrayIndex     0   x           2  RTINDEX    uint   x
       */
      // ; SV_DepthLessEqual        0    N/A oDepthLE  DEPTHLE   float    YES

      static auto regex = std::regex{R"(; (\S+)\s+(\S+)\s+((?:(?:x| )(?:y| )(?:z| )(?:w| ))|(?:N\/A))\s+(\S+)\s+(\S+)\s+(\S+)\s*((?:[xyzw ]+)|(?:YES)|))"};
      auto [name, index, mask, dxregister, sysValue, format, used] = StringViewMatch<7>(line, regex);

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
      if (input == "linear") return InterpMode::LINEAR;
      if (input == "centroid") return InterpMode::CENTROID;
      throw std::invalid_argument("Unknown InterpMode");
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
      throw std::invalid_argument("Unknown BufferType");
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
      throw std::invalid_argument("Unknown ResourceType");
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
      throw std::invalid_argument("Unknown ResourceType");
    }

    static ResourceFormat ResourceFormatFromString(std::string_view input) {
      if (input == "NA") return ResourceFormat::NA;
      if (input == "byte") return ResourceFormat::BYTE;
      if (input == "f16") return ResourceFormat::F16;
      if (input == "f32") return ResourceFormat::F32;
      if (input == "i32") return ResourceFormat::I32;
      if (input == "u32") return ResourceFormat::U32;
      if (input == "struct") return ResourceFormat::STRUCTURE;
      throw std::invalid_argument("Unknown ResourceFormat");
    }

    explicit ResourceDescription(std::string_view line) {
      // ; _31_33                            cbuffer      NA          NA     CB0            cb0     1
      static auto regex = std::regex{R"(; (.{30}\S*)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+) (.{14})(.*))"};
      auto [name, type, format, dimensions, id, hlslBinding, count] = StringViewMatch<7>(line, regex);
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
          // return "RawBuffer";
          return "Buffer";
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
      static auto pointer_regex = std::regex{R"(^(?:\[(\S+) x )?%"class\.([^<]+)<(?:vector<)?([^,>]+)(?:, ([^>]+)>)? ?>"\]?\*)"};
      const auto [array_size, class_name, base_type, type_count] = StringViewMatch<4>(this->pointer, pointer_regex);

      auto base_type_fixed = DataType::FixBaseType(base_type);
      this->data_type = std::format("{}{}", base_type_fixed, type_count);

      // https://github.com/microsoft/DirectXShaderCompiler/blob/b766b432678cf5f7a93567d253bb5f7fd8a0b2c7/docs/DXIL.rst#L1047
      uint32_t shape;
      FromStringView(ParseKeyValue(metadata[6])[1], shape);
      this->shape = static_cast<ResourceKind>(shape);
      FromStringView(ParseKeyValue(metadata[7])[1], this->sample_count);
      if (metadata[8] == "null") {
        this->element_type = Resource::ComponentType::Invalid;
        this->stride = 4;
        this->data_type = "uint4";
      } else {
        auto pairs = raw_metadata[metadata[8]];
        int type_value;
        FromStringView(ParseKeyValue(pairs[0])[1], type_value);
        if (type_value == 0) {
          uint32_t element_type;
          FromStringView(ParseKeyValue(pairs[1])[1], element_type);
          this->element_type = static_cast<ComponentType>(element_type);
        } else {
          this->element_type = Resource::ComponentType::Invalid;
          // FromStringView(ParseKeyValue(pairs[1])[1], this->stride);
          //  this->data_type = std::format("_{}", this->name);
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
      static auto pointer_regex = std::regex{R"(^(?:\[(\S+) x )?%"class\.([^<]+)<(?:vector<)?([^,>]+)(?:, ([^>]+)>)? ?>"\]?\*)"};
      const auto [array_size, class_name, base_type, type_count] = StringViewMatch<4>(this->pointer, pointer_regex);

      auto base_type_fixed = DataType::FixBaseType(base_type);
      this->data_type = std::format("{}{}", base_type_fixed, type_count);

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
        this->data_type = "uint4";
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
          this->data_type = std::format("_{}", this->name);
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
      return std::string(data_type);
    }

    explicit DataType(std::string_view line) {
      static auto regex = std::regex{R"(^(?:\[(\S+) x )?(?:\[(\S+) x )?(?:<(\S+) x )?([^*>\]]+)(\*)?>?\]?\]?$)"};
      const auto [array_size_a, array_size_b, vector_size, data_type, is_pointer] = StringViewMatch<5>(line, regex);
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

      static auto type_split = std::regex(R"( ((?:[^},]+)|(?:%"[^"]+"))(?:,| ))");
      auto type_strings = StringViewSplitAll(types, type_split, 1);
      int value = 0;
      for (const auto type : type_strings) {
        this->variables.emplace_back("", std::format("value{:03}", value++), type);
      }
    }
  };

  struct ResourceBindingVariable {
    std::string name;
    uint32_t range_index;
    std::string resource_class;
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
    std::map<std::string_view, std::pair<CBVResource*, uint32_t>> cbv_binding_variables;
    std::map<std::string_view, std::tuple<SRVResource*, std::string, std::string, std::string>> srv_binding_load_variables;
    std::map<std::string_view, std::tuple<UAVResource*, std::string, std::string, std::string>> uav_binding_load_variables;
    std::vector<BufferDefinition> buffer_definitions;

    size_t GetTypeSize(const DataType& data_type) {
      size_t data_type_size = 0;

      if (data_type.data_type == "float") {
        data_type_size = 32 / 8;
      } else if (data_type.data_type == "int") {
        data_type_size = 32 / 8;
      } else if (data_type.data_type == "i32") {
        data_type_size = 32 / 8;
      } else if (data_type.data_type == "bool") {
        data_type_size = 8 / 8;
      } else if (auto pair = type_definitions.find(data_type.data_type);
                 pair != type_definitions.end()) {
        auto type_definition = pair->second;
        for (auto& [declaration, name, type_name, optional_offset] : type_definition.variables) {
          data_type_size += GetTypeSize(DataType(type_name));
        }
      } else {
        data_type_size = GetTypeSize(DataType(data_type.data_type));
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
        } else {
          assert(false);
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

    std::string ResourceVariableNameAtIndex(const Resource& resource, uint32_t index) {
      auto type_name = resource.pointer.substr(0, resource.pointer.length() - 1);
      auto pair = type_definitions.find(type_name);
      assert(pair != type_definitions.end());
      auto& definition = pair->second;

      if (type_name.starts_with("%\"class.StructuredBuffer<")) {
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
      assert(pair != type_definitions.end());
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
            auto pair = this->type_definitions.find(definition);
            assert(pair != this->type_definitions.end());
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
    std::map<std::string, std::pair<std::string, std::string>> variable_aliases;
    std::vector<std::string_view> threads;
    std::map<uint32_t, uint32_t> variable_counter;
    std::set<std::string> phi_variables;
    std::map<uint32_t, uint32_t> variable_declaration;  // variable _codeblocknumber
    std::map<uint32_t, uint32_t> assignment_values;
    std::set<uint32_t> single_use_variables;

    std::vector<std::string> ComputePhiAssignments(CodeBlock* code_block, int branch_code_function) {
      std::vector<std::string> phi_lines;
      for (const auto& [variable, type, value, predecessor, code_function, is_assign] : code_block->phi_lines) {
        // add phi lines
        if (code_function == branch_code_function && is_assign) {
          auto assignment_value = std::format("{}", this->ParseByType(value, type));
          std::string optimized = OptimizeString(assignment_value);
          auto phi_line = std::format("_{} = {};", variable, optimized);
          phi_lines.push_back(phi_line);
        }
      }
      return phi_lines;
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
          auto new_value = (expected_type != alias_type)
                               ? CastType(alias_type, alias_value)
                               : alias_value;
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
        throw std::invalid_argument("Could not parse code assignment");
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
            resource = &preprocess_state.srv_resources[range_id_value];
            hint = "texture";
          } else if (resource_class == "1") {
            resource = &preprocess_state.uav_resources[range_id_value];
            hint = "rwtexture";
          } else if (resource_class == "2") {
            resource = &preprocess_state.cbv_resources[range_id_value];
            hint = "cbuffer";
          } else if (resource_class == "3") {
            resource = &preprocess_state.sampler_resources[range_id_value];
            hint = "SamplerState";
          } else {
            throw std::invalid_argument("Unknown resource type");
          }
          std::string name = resource->name;
          if (resource->array_size.has_value()) {
            name = std::format("{}[{}]", name, ParseUint(index));
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
              name = std::format("{}[{}]", name, ParseInt(index));
            }
            hint = "texture";
          } else if (resource_class == "1") {
            auto uav = std::ranges::find_if(preprocess_state.uav_resources, [&](UAVResource& resource) {
              return resource.space == space_value && resource.signature_index == bind_start_value;
            });
            range_index = uav - preprocess_state.uav_resources.begin();
            name = uav->name;
            if (uav->array_size.has_value()) {
              name = std::format("{}[{}]", name, ParseInt(index));
            }
            hint = "rwtexture";
          } else if (resource_class == "2") {
            auto cbv = std::ranges::find_if(preprocess_state.cbv_resources, [&](CBVResource& resource) {
              return resource.space == space_value && resource.signature_index == bind_start_value;
            });
            range_index = cbv - preprocess_state.cbv_resources.begin();
            name = cbv->name;
            if (cbv->array_size.has_value()) {
              name = std::format("{}[{}]", name, ParseInt(index));
            }
            hint = "cbuffer";
          } else if (resource_class == "3") {
            auto sampler = std::find_if(preprocess_state.sampler_resources.begin(), preprocess_state.sampler_resources.end(), [&](SamplerResource& resource) {
              return resource.space == space_value && resource.signature_index == bind_start_value;
            });
            range_index = sampler - preprocess_state.sampler_resources.begin();
            name = sampler->name;
            if (sampler->array_size.has_value()) {
              name = std::format("{}[{}]", name, ParseInt(index));
            }
            hint = "SamplerState";
          } else {
            throw std::invalid_argument("Unknown resource type");
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
        } else if (functionName == "@dx.op.annotateHandle") {
          // %4 = call %dx.types.Handle @dx.op.annotateHandle(i32 216, %dx.types.Handle %3, %dx.types.ResourceProperties { i32 13, i32 644 })  ; AnnotateHandle(res,props)  resource: CBuffer
          auto [opNumber, res, props] = StringViewSplit<3>(functionParamsString, param_regex, 2);
          auto ref = std::string{res.substr(1)};
          preprocess_state.resource_binding_variables[std::string(variable)] = preprocess_state.resource_binding_variables.at(ref);
          assignment_type = "auto";
          assignment_value = std::format("_{}", ref);
          use_comment = true;
          // decompiled = std::format("// _{} = _{};", variable, ref);
        } else if (functionName == "@dx.op.loadInput.f32") {
          //   @dx.op.loadInput.f32(i32 4, i32 3, i32 0, i8 0, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
          auto [opNumber, inputSigId, rowIndex, colIndex, gsVertexAxis] = StringViewSplit<5>(functionParamsString, param_regex, 2);
          int input_signature_index;
          FromStringView(inputSigId, input_signature_index);
          auto signature = preprocess_state.input_signature[input_signature_index];
          assignment_type = "float";
          is_identity = true;
          if (signature.packed.MaskString() == "1") {
            if (ParseIndex(colIndex) != "x") {
              throw std::exception("Unexpected index.");
            }
            assignment_value = signature.VariableString();
            // decompiled = std::format("float _{} = {};", variable, value);
            // preprocess_state.variable_aliases.emplace(variable, assignment_value);
          } else {
            assignment_value = std::format("{}.{}", signature.VariableString(), ParseIndex(colIndex));
            // decompiled = std::format("float _{} = {};", variable, value);
            // preprocess_state.variable_aliases.emplace(variable, assignment_value);
          }
        } else if (functionName == "@dx.op.loadInput.i32") {
          //   @dx.op.loadInput.i32(i32 4, i32 2, i32 0, i8 0, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
          auto [opNumber, inputSigId, rowIndex, colIndex, gsVertexAxis] = StringViewSplit<5>(functionParamsString, param_regex, 2);
          int input_signature_index;
          FromStringView(inputSigId, input_signature_index);
          auto signature = preprocess_state.input_signature[input_signature_index];
          assignment_type = "int";
          is_identity = true;
          if (signature.packed.MaskString() == "1") {
            if (ParseIndex(colIndex) != "x") {
              throw std::exception("Unexpected index.");
            }
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
            // Needs float4
            throw std::exception("Unexpected dynamic cbuffer offset.");
          }
          uint32_t cbv_variable_index;
          FromStringView(regIndex, cbv_variable_index);
          // auto name = preprocess_state.ResourceVariableNameAtIndex(cbv_resource, cbv_variable_index);

          // decompiled = std::format("// float4 _{} = {}[{}u];", variable, cbv_resource.name, cbv_variable_index);
          preprocess_state.cbv_binding_variables[variable] = {&cbv_resource, cbv_variable_index};

        } else if (functionName == "@dx.op.cbufferLoadLegacy.i32") {
          // %18 = call %dx.types.CBufRet.i32 @dx.op.cbufferLoadLegacy.i32(i32 59, %dx.types.Handle %4, i32 40)  ; CBufferLoadLegacy(handle,regIndex)
          auto [opNumber, handle, regIndex] = StringViewSplit<3>(functionParamsString, param_regex, 2);
          auto ref = std::string{handle.substr(1)};
          auto [binding_name, range_index, resource_class] = preprocess_state.resource_binding_variables.at(ref);
          assert(resource_class == "2");
          auto& cbv_resource = preprocess_state.cbv_resources[range_index];

          uint32_t cbv_variable_index;
          FromStringView(regIndex, cbv_variable_index);
          if (regIndex.starts_with("%")) {
            throw std::exception("Unexpected dynamic cbuffer offset.");
          }
          // auto name = preprocess_state.ResourceVariableNameAtIndex(cbv_resource, cbv_variable_index);

          // decompiled = std::format("// int4 _{} = {}[{}u];", variable, cbv_resource.name, cbv_variable_index);
          preprocess_state.cbv_binding_variables[variable] = {&cbv_resource, cbv_variable_index};
        } else if (functionName == "@dx.op.unary.f32") {
          auto [opNumber, value] = StringViewSplit<2>(functionParamsString, param_regex, 2);
          if (auto pair = UNARY_FLOAT_OPS.find(std::string(opNumber));
              pair != UNARY_FLOAT_OPS.end()) {
            assignment_type = ParseType(type);
            assignment_value = std::format("{}{}", pair->second, ParseWrapped(ParseFloat(value)));
            // decompiled = std::format("{} _{} = {}({});", ParseType(type), variable, pair->second, ParseFloat(value));
          } else {
            throw std::invalid_argument("Unknown @dx.op.unary.f32");
          }
        } else if (functionName == "@dx.op.unary.f16") {
          auto [opNumber, value] = StringViewSplit<2>(functionParamsString, param_regex, 2);
          if (auto pair = UNARY_FLOAT_OPS.find(std::string(opNumber));
              pair != UNARY_FLOAT_OPS.end()) {
            assignment_type = ParseType(type);
            assignment_value = std::format("{}{}", pair->second, ParseWrapped(ParseHalf(value)));
            // decompiled = std::format("{} _{} = {}({});", ParseType(type), variable, pair->second, ParseFloat(value));
          } else {
            throw std::invalid_argument("Unknown @dx.op.unary.f32");
          }
        } else if (functionName == "@dx.op.unary.i32") {
          auto [opNumber, value] = StringViewSplit<2>(functionParamsString, param_regex, 2);
          if (auto pair = UNARY_INT32_OPS.find(std::string(opNumber));
              pair != UNARY_INT32_OPS.end()) {
            assignment_type = ParseType(type);
            assignment_value = std::format("{}{}", pair->second, ParseWrapped(ParseFloat(value)));
            // decompiled = std::format("{} _{} = {}({});", ParseType(type), variable, pair->second, ParseFloat(value));
          } else {
            throw std::invalid_argument("Unknown @dx.op.unary.i32");
          }
        } else if (functionName == "@dx.op.unaryBits.i32") {
          auto [opNumber, value] = StringViewSplit<2>(functionParamsString, param_regex, 2);
          if (auto pair = UNARY_BITS_OPS.find(std::string(opNumber));
              pair != UNARY_BITS_OPS.end()) {
            if (opNumber == "33") {
              assignment_type = "uint";
              // decompiled = std::format("uint _{} = {}({});", variable, pair->second, ParseFloat(value));
            } else {
              assignment_type = ParseType(type);
              // decompiled = std::format("{} _{} = {}({});", ParseType(type), variable, pair->second, ParseFloat(value));
            }
            assignment_value = CastType(pair->second, ParseFloat(value));
          } else {
            throw std::invalid_argument("Unknown @dx.op.unaryBits.i32");
          }
        } else if (functionName == "@dx.op.binary.f32") {
          auto [opNumber, a, b] = StringViewSplit<3>(functionParamsString, param_regex, 2);
          if (auto pair = BINARY_FLOAT_OPS.find(std::string(opNumber));
              pair != BINARY_FLOAT_OPS.end()) {
            assignment_type = ParseType(type);
            assignment_value = std::format("{}({}, {})", pair->second, ParseFloat(a), ParseFloat(b));
            // decompiled = std::format("{} _{} = {}({}, {});", ParseType(type), variable, pair->second, ParseFloat(a), ParseFloat(b));
          } else {
            throw std::invalid_argument("Unknown @dx.op.binary.f32");
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
            throw std::invalid_argument("Unknown @dx.op.binary.f16");
          }
        } else if (functionName == "@dx.op.binary.i32") {
          auto [opNumber, a, b] = StringViewSplit<3>(functionParamsString, param_regex, 2);
          if (auto pair = BINARY_INT32_OPS.find(std::string(opNumber));
              pair != BINARY_INT32_OPS.end()) {
            assignment_type = ParseType(type);
            assignment_value = std::format("{}({}, {})", pair->second, ParseInt(a), ParseInt(b));
            // decompiled = std::format("{} _{} = {}({}, {});", ParseType(type), variable, pair->second, ParseInt(a), ParseInt(b));
          } else {
            throw std::invalid_argument("Unknown @dx.op.binary.i32");
          }
        } else if (functionName == "@dx.op.textureLoad.f32" || functionName == "@dx.op.textureLoad.i32") {
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
          Resource::ResourceKind shape;
          if (resource_class == "0") {
            shape = preprocess_state.srv_resources[range_index].shape;
            assignment_type = preprocess_state.srv_resources[range_index].data_type;
          } else if (resource_class == "1") {
            shape = preprocess_state.uav_resources[range_index].shape;
            assignment_type = preprocess_state.uav_resources[range_index].data_type;
          } else {
            throw std::invalid_argument("Unknown @dx.op.textureLoad.f32 resource");
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
              throw std::exception("Unknown shape");
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
            throw std::invalid_argument("Unknown clamp");
          }

          auto [srv_name, srv_range_index, srv_resource_class] = preprocess_state.resource_binding_variables.at(ref_resource);
          assert(srv_resource_class == "0");
          auto srv_resource = preprocess_state.srv_resources[srv_range_index];
          auto [sampler_name, sampler_range_index, sampler_resource_class] = preprocess_state.resource_binding_variables.at(ref_sampler);
          auto sampler_resource = preprocess_state.sampler_resources[sampler_range_index];
          assignment_type = srv_resource.data_type;
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
          auto srv_resource = preprocess_state.srv_resources[srv_range_index];
          auto [sampler_name, sampler_range_index, sampler_resource_class] = preprocess_state.resource_binding_variables.at(ref_sampler);
          auto sampler_resource = preprocess_state.sampler_resources[sampler_range_index];
          assignment_type = srv_resource.data_type;
          if (offset == "" || offset == "0" || offset == "int2(0, 0)" || offset == "int3(0, 0, 0)") {
            assignment_value = std::format("{}.SampleLevel({}, {}, {})", srv_name,
                                           sampler_name, coords, ParseFloat(LOD));
            // decompiled = std::format("{} _{} = {}.SampleLevel({}, {}, {});", srv_resource.data_type, variable, srv_name, sampler_name, coords, ParseFloat(LOD));
          } else {
            assignment_value = std::format("{}.SampleLevel({}, {}, {}, {})", srv_name,
                                           sampler_name, coords, ParseFloat(LOD), offset);
            // decompiled = std::format("{} _{} = {}.SampleLevel({}, {}, {}, {});", srv_resource.data_type, variable, srv_name, sampler_name, coords, ParseFloat(LOD), offset);
          }
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
        } else if (functionName == "@dx.op.dot4.f32") {
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
        } else if (functionName == "@dx.op.rawBufferLoad.f32") {
          // call %dx.types.ResRet.f32 @dx.op.rawBufferLoad.f32(i32 139, %dx.types.Handle %21, i32 %20, i32 0, i8 15, i32 4)  ; RawBufferLoad(srv,index,elementOffset,mask,alignment)
          // call %dx.types.ResRet.f32 @dx.op.rawBufferLoad.f32(i32 139, %dx.types.Handle %21, i32 %20, i32 32, i8 1, i32 4)  ; RawBufferLoad(srv,index,elementOffset,mask,alignment)

          auto [opNumber, srv, index, elementOffset, mask, alignment] = StringViewSplit<6>(functionParamsString, param_regex, 2);
          auto ref = std::string{srv.substr(1)};
          auto [res_name, range_index, resource_class] = preprocess_state.resource_binding_variables.at(ref);
          bool is_raw_buffer = false;
          if (resource_class == "0") {
            is_raw_buffer = preprocess_state.srv_resources[range_index].shape == Resource::ResourceKind::RawBuffer;
          } else if (resource_class == "1") {
            is_raw_buffer = preprocess_state.uav_resources[range_index].shape == Resource::ResourceKind::RawBuffer;
          } else {
            throw std::invalid_argument("Unknown @dx.op.rawBufferLoad.f32 resource");
          }

          if (is_raw_buffer) {
            assignment_type = "float4";
            assert(elementOffset == "undef");
            assignment_value = std::format("{}[{} / {}]",
                                           res_name, ParseInt(index), ParseInt(alignment));
          } else if (resource_class == "0") {
            preprocess_state.srv_binding_load_variables[variable] = {
                &preprocess_state.srv_resources[range_index],
                ParseInt(index),
                ParseInt(elementOffset),
                ParseInt(alignment),
            };
          } else if (resource_class == "1") {
            preprocess_state.uav_binding_load_variables[variable] = {
                &preprocess_state.uav_resources[range_index],
                ParseInt(index),
                ParseInt(elementOffset),
                ParseInt(alignment),
            };
          }
        } else if (functionName == "@dx.op.rawBufferLoad.i32") {
          auto [opNumber, srv, index, elementOffset, mask, alignment] = StringViewSplit<6>(functionParamsString, param_regex, 2);
          auto ref = std::string{srv.substr(1)};
          auto [res_name, res_range_index, resource_class] = preprocess_state.resource_binding_variables.at(ref);
          bool is_raw_buffer = false;
          if (resource_class == "0") {
            is_raw_buffer = preprocess_state.srv_resources[res_range_index].shape == Resource::ResourceKind::RawBuffer;
          } else if (resource_class == "1") {
            is_raw_buffer = preprocess_state.uav_resources[res_range_index].shape == Resource::ResourceKind::RawBuffer;
          } else {
            throw std::invalid_argument("Unknown @dx.op.rawBufferLoad.i32 resource");
          }

          if (is_raw_buffer) {
            assignment_type = "int4";
            assert(elementOffset == "undef");
            assignment_value = std::format("asint({}[{} / {}])",
                                           res_name, ParseInt(index), ParseInt(alignment));
          } else if (resource_class == "0") {
            preprocess_state.srv_binding_load_variables[variable] = {
                &preprocess_state.srv_resources[res_range_index],
                ParseInt(index),
                ParseInt(elementOffset),
                ParseInt(alignment),
            };
          } else if (resource_class == "1") {
            preprocess_state.uav_binding_load_variables[variable] = {
                &preprocess_state.uav_resources[res_range_index],
                ParseInt(index),
                ParseInt(elementOffset),
                ParseInt(alignment),
            };
          }
        } else if (functionName == "@dx.op.bufferLoad.i32") {
          // call %dx.types.ResRet.i32 @dx.op.bufferLoad.i32(i32 68, %dx.types.Handle %4, i32 6, i32 undef)  ; BufferLoad(srv,index,wot)
          // call %dx.types.ResRet.i32 @dx.op.bufferLoad.i32(i32 68, %dx.types.Handle %31, i32 %28, i32 undef)  ; BufferLoad(srv,index,wot)
          auto [opNumber, srv, index, wot] = StringViewSplit<4>(functionParamsString, param_regex, 2);
          auto ref = std::string{srv.substr(1)};
          auto [res_name, range_index, resource_class] = preprocess_state.resource_binding_variables.at(ref);
          if (resource_class == "0") {
            assignment_type = preprocess_state.srv_resources[range_index].data_type;
          } else if (resource_class == "1") {
            assignment_type = preprocess_state.uav_resources[range_index].data_type;
          } else {
            throw std::invalid_argument("Unknown @dx.op.bufferLoad.i32 resource");
          }
          assignment_value = std::format("{}.Load{}", res_name, ParseWrapped(ParseInt(index)));

        } else if (functionName == "@dx.op.bufferLoad.f32") {
          // call %dx.types.ResRet.i32 @dx.op.bufferLoad.i32(i32 68, %dx.types.Handle %31, i32 %28, i32 undef)  ; BufferLoad(srv,index,wot)
          auto [opNumber, srv, index, wot] = StringViewSplit<4>(functionParamsString, param_regex, 2);
          auto ref = std::string{srv.substr(1)};
          auto [res_name, range_index, resource_class] = preprocess_state.resource_binding_variables.at(ref);
          if (resource_class == "0") {
            assignment_type = preprocess_state.srv_resources[range_index].data_type;
          } else if (resource_class == "1") {
            assignment_type = preprocess_state.uav_resources[range_index].data_type;
          } else {
            throw std::invalid_argument("Unknown @dx.op.bufferLoad.f32 resource");
          }
          assignment_value = std::format("{}.Load{}", res_name, ParseWrapped(ParseInt(index)));
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
            throw std::invalid_argument("Unknown @dx.op.isSpecialFloat.f32");
          }
        } else if (functionName == "@dx.op.getDimensions") {
          // call %dx.types.Dimensions @dx.op.getDimensions(i32 72, %dx.types.Handle %1, i32 0)  ; GetDimensions(handle,mipLevel)
          auto [opNumber, handle, mip_level] = StringViewSplit<3>(functionParamsString, param_regex, 2);

          auto ref_resource = std::string{handle.substr(1)};
          auto [srv_name, range_index, resource_class] = preprocess_state.resource_binding_variables.at(ref_resource);
          Resource::ResourceKind shape;
          if (resource_class == "0") {
            shape = preprocess_state.srv_resources[range_index].shape;
          } else if (resource_class == "1") {
            shape = preprocess_state.uav_resources[range_index].shape;
          } else {
            throw std::invalid_argument("Unknown @dx.op.textureLoad.f32 resource");
          }

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
            default:
              std::cerr << "Unexpected shape: " << Resource::ResourceKindString(shape) << "\n";
              throw std::invalid_argument("Unexpected shape");
          }

          if (mip_level != "0") {
            decompiled = std::format("{} _{}; uint _{}_levels; {}.GetDimensions({}, {}, _{}_levels);",
                                     assignment_type, variable, variable, srv_name, ParseUint(mip_level), get_dimensions_arguments, variable);
          } else {
            decompiled = std::format("{} _{}; {}.GetDimensions({});", assignment_type, variable, srv_name, get_dimensions_arguments);
          }
          is_identity = false;  // Can never be identity
        } else if (functionName == "@dx.op.sampleBias.f32") {
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
          auto srv_resource = preprocess_state.srv_resources[srv_range_index];
          auto [sampler_name, sampler_range_index, sampler_resource_class] = preprocess_state.resource_binding_variables.at(ref_sampler);
          auto sampler_resource = preprocess_state.sampler_resources[sampler_range_index];

          assignment_type = srv_resource.data_type;
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
          auto srv_resource = preprocess_state.srv_resources[srv_range_index];
          auto [sampler_name, sampler_range_index, sampler_resource_class] = preprocess_state.resource_binding_variables.at(ref_sampler);
          auto sampler_resource = preprocess_state.sampler_resources[sampler_range_index];

          assignment_type = srv_resource.data_type;
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
          auto srv_resource = preprocess_state.srv_resources[srv_range_index];
          auto [sampler_name, sampler_range_index, sampler_resource_class] = preprocess_state.resource_binding_variables.at(ref_sampler);
          auto sampler_resource = preprocess_state.sampler_resources[sampler_range_index];

          assignment_type = srv_resource.data_type;
          assignment_value = std::format("{}.SampleCmpLevelZero({}, {}, {})", srv_name, sampler_name, coords, ParseFloat(compareValue));
        } else if (functionName == "@dx.op.textureGather.i32" || functionName == "@dx.op.textureGather.f32") {
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
          auto srv_resource = preprocess_state.srv_resources[srv_range_index];
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
            throw std::exception("Unknown Gather channel.");
          }
          if (functionName == "@dx.op.textureGather.i32") {
            assignment_type = "int4";
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
            throw std::invalid_argument("Unknown wave active op");
          }
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
        } else if (functionName == "@dx.op.waveAnyTrue") {
          // call i1 @dx.op.waveAnyTrue(i32 113, i1 %264)  ; WaveAnyTrue(cond)
          auto [op, cond] = StringViewSplit<2>(functionParamsString, param_regex, 2);
          assignment_type = "bool";
          assignment_value = std::format("WaveActiveAnyTrue{}", ParseWrapped(ParseBool(cond)));
        } else if (functionName == "@dx.op.waveGetLaneIndex") {
          // %347 = call i32 @dx.op.waveGetLaneIndex(i32 111)  ; WaveGetLaneIndex()
          assignment_type = "int";
          assignment_value = "WaveGetLaneIndex()";
        } else if (functionName == "@dx.op.waveReadLaneAt.i32") {
          //   %350 = call i32 @dx.op.waveReadLaneAt.i32(i32 117, i32 %346, i32 %349)  ; WaveReadLaneAt(value,lane)
          auto [op, value, lane] = StringViewSplit<3>(functionParamsString, param_regex, 2);
          assignment_type = "int";
          assignment_value = std::format("WaveReadLaneAt({},{})", ParseInt(value), ParseInt(lane));
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
          const bool has_offset_y = offset1 != "undef";
          const bool has_offset_z = offset2 != "undef";
          std::string offset;
          if (has_offset_z) {
            offset = std::format("int3({}, {}, {})", ParseInt(offset0), ParseInt(offset1), ParseInt(offset2));
          } else if (has_offset_y) {
            offset = std::format("int2({}, {})", ParseInt(offset0), ParseInt(offset1));
          } else {
            offset = std::format("{}", ParseInt(offset0));
          }
          auto [uav_name, uav_range_index, resource_class] = preprocess_state.resource_binding_variables.at(ref_resource);
          auto uav_resource = preprocess_state.uav_resources[uav_range_index];
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
            throw std::invalid_argument("Unknown atomicOp for AtomicBinOp");
          }
          assignment_type = uav_resource.data_type;
          decompiled = std::format("{} _{}; {}({}[{}], {}, _{});", assignment_type, variable, atomic_func, uav_name, offset, ParseInt(newValue), variable);
        } else {
          std::cerr << line << "\n";
          std::cerr << "Function name: " << functionName << "\n";
          throw std::invalid_argument("Unknown assign function name");
        }
        // decompiled = std::format("// {} _{} = {}({})", type, variable, functionName, functionParams);
        // decompiled = "// " + std::string{comment};
      } else if (instruction == "extractvalue") {
        // extractvalue %dx.types.ResRet.f32 %448, 0
        // extractvalue %dx.types.CBufRet.i32 %19, 0
        auto [type, input, index] = StringViewMatch<3>(assignment, std::regex{R"(extractvalue (\S+) (\S+), (\S+))"});
        if (type == R"(%dx.types.CBufRet.f32)") {
          auto source_variable = ParseVariable(input).substr(1);
          const auto& [cbv_resource, cbv_variable_index] = preprocess_state.cbv_binding_variables[source_variable];
          int literal_index;
          FromStringView(index, literal_index);

          auto value_from_reflection = preprocess_state.ResourceVariableNameAtIndex(*cbv_resource, (cbv_variable_index * 16) + (literal_index * 4));

          if (value_from_reflection.empty()) {
            int real_index = cbv_variable_index;
            char sub_index = VECTOR_INDEXES[literal_index];
            std::string suffix = std::format("{:03}{}", real_index, sub_index);
            assignment_value = std::format("{}_{}", cbv_resource->name, suffix);
            cbv_resource->data_types[suffix] = "float";
          } else {
            assignment_value = value_from_reflection;
          }

          assignment_type = "float";
          is_identity = true;
          // decompiled = std::format("float _{} = {};", variable, value);
          // preprocess_state.variable_aliases.emplace(variable, value);
        } else if (type == R"(%dx.types.CBufRet.i32)") {
          auto source_variable = ParseVariable(input).substr(1);
          const auto& [cbv_resource, cbv_variable_index] = preprocess_state.cbv_binding_variables[source_variable];
          int literal_index;
          FromStringView(index, literal_index);

          auto value_from_reflection = preprocess_state.ResourceVariableNameAtIndex(*cbv_resource, (cbv_variable_index * 16) + (literal_index * 4));

          if (value_from_reflection.empty()) {
            int real_index = cbv_variable_index;
            char sub_index = VECTOR_INDEXES[literal_index];
            std::string suffix = std::format("{:03}{}", real_index, sub_index);
            assignment_value = std::format("{}_{}", cbv_resource->name, suffix);
            cbv_resource->data_types[suffix] = "int";
          } else {
            assignment_value = value_from_reflection;
          }

          assignment_type = "int";
          is_identity = true;
          // preprocess_state.variable_aliases.emplace(variable, value);
        } else if (type == R"(%dx.types.ResRet.f32)") {
          auto source_variable = ParseVariable(input).substr(1);
          assignment_type = "float";
          if (auto pair = preprocess_state.srv_binding_load_variables.find(source_variable);
              pair != preprocess_state.srv_binding_load_variables.end()) {
            const auto& [srv_resource, srv_index, element_offset, alignment] = pair->second;
            int literal_index;
            FromStringView(index, literal_index);
            int literal_element_offset;
            FromStringView(element_offset, literal_element_offset);
            int literal_alignment;
            FromStringView(alignment, literal_alignment);
            assignment_value = std::format("{}[{}]{}",
                                           srv_resource->name,
                                           ParseInt(srv_index),
                                           preprocess_state.ResourceVariableNameAtIndex(*srv_resource, (literal_element_offset) + (literal_index * 4)));
            is_identity = false;
            use_comment = false;
          } else if (auto pair = preprocess_state.uav_binding_load_variables.find(source_variable);
                     pair != preprocess_state.uav_binding_load_variables.end()) {
            const auto& [uav_resource, srv_index, element_offset, alignment] = pair->second;
            int literal_index;
            FromStringView(index, literal_index);
            int literal_element_offset;
            FromStringView(element_offset, literal_element_offset);
            int literal_alignment;
            FromStringView(alignment, literal_alignment);
            assignment_value = std::format("{}[{}]{}",
                                           uav_resource->name,
                                           ParseInt(srv_index),
                                           preprocess_state.ResourceVariableNameAtIndex(*uav_resource, (literal_element_offset) + (literal_index * 4)));
            is_identity = false;
            use_comment = false;
          } else {
            assignment_value = std::format("{}.{}", ParseVariable(input), ParseIndex(index));
            is_identity = true;
          }

          // decompiled = std::format("float _{} = {};", variable, value);
          // preprocess_state.variable_aliases.emplace(variable, value);
        } else if (type == R"(%dx.types.ResRet.f16)") {
          auto source_variable = ParseVariable(input).substr(1);
          assignment_type = "half";
          if (auto pair = preprocess_state.srv_binding_load_variables.find(source_variable);
              pair != preprocess_state.srv_binding_load_variables.end()) {
            throw std::invalid_argument("Unsupported half in SRV.");
          } else if (auto pair = preprocess_state.uav_binding_load_variables.find(source_variable);
                     pair != preprocess_state.uav_binding_load_variables.end()) {
            throw std::invalid_argument("Unsupported half in UAV.");
          } else {
            assignment_value = std::format("{}.{}", ParseVariable(input), ParseIndex(index));
            is_identity = true;
          }
        } else if (type == R"(%dx.types.ResRet.i32)") {
          auto source_variable = ParseVariable(input).substr(1);
          assignment_type = "int";
          if (auto pair = preprocess_state.srv_binding_load_variables.find(source_variable);
              pair != preprocess_state.srv_binding_load_variables.end()) {
            const auto& [srv_resource, srv_index, element_offset, alignment] = pair->second;
            int literal_index;
            FromStringView(index, literal_index);
            int literal_element_offset;
            FromStringView(element_offset, literal_element_offset);
            int literal_alignment;
            FromStringView(alignment, literal_alignment);
            assignment_value = std::format("{}[{}]{}",
                                           srv_resource->name,
                                           ParseInt(srv_index),
                                           preprocess_state.ResourceVariableNameAtIndex(*srv_resource, (literal_element_offset) + (literal_index * 4)));
            is_identity = false;
            use_comment = false;
          } else if (auto pair = preprocess_state.uav_binding_load_variables.find(source_variable);
                     pair != preprocess_state.uav_binding_load_variables.end()) {
            const auto& [uav_resource, srv_index, element_offset, alignment] = pair->second;
            int literal_index;
            FromStringView(index, literal_index);
            int literal_element_offset;
            FromStringView(element_offset, literal_element_offset);
            int literal_alignment;
            FromStringView(alignment, literal_alignment);
            assignment_value = std::format("{}[{}]{}",
                                           uav_resource->name,
                                           ParseInt(srv_index),
                                           preprocess_state.ResourceVariableNameAtIndex(*uav_resource, (literal_element_offset) + (literal_index * 4)));
            is_identity = false;
            use_comment = false;
          } else {
            assignment_value = std::format("{}.{}", ParseVariable(input), ParseIndex(index));
            is_identity = true;
          }
          // decompiled = std::format("int _{} = {};", variable, value);
          // preprocess_state.variable_aliases.emplace(variable, value);
        } else if (type == R"(%dx.types.Dimensions)") {
          assignment_type = "uint";
          assignment_value = std::format("{}.{}", ParseVariable(input), ParseIndex(index));
          is_identity = true;
          // decompiled = std::format("uint _{} = {};", variable, value);
          // preprocess_state.variable_aliases.emplace(variable, value);
        } else {
          std::cerr << type << "\n";
          throw std::invalid_argument("Unknown extractvalue type");
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
        // %95 = ashr i32 %68, 2
        // %36 = exact i32 %35, 16
        auto [exact, no_unsigned_wrap, no_signed_wrap, variable_type, a, b] = StringViewMatch<6>(assignment, std::regex{R"(ashr (exact )?(nuw )?(nsw )?(\S+) (\S+), (\S+))"});
        assignment_type = ParseType(variable_type);
        if (no_signed_wrap.empty()) {
          if (assignment_type == "int") {
            assignment_type = "uint";
          } else if (assignment_type == "min16int") {
            assignment_type = "min16uint";
          }
        }
        assignment_value = std::format("{} >> {}", ParseInt(a), ParseInt(b));
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

        // Missing fast support
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
          assignment_value = std::format("!({} != {})", a_parsed, b_parsed);
        } else if (op == "ugt") {
          assignment_value = std::format("!({} <= {})", a_parsed, b_parsed);
        } else if (op == "uge") {
          assignment_value = std::format("!({} > {})", a_parsed, b_parsed);
        } else if (op == "ult") {
          assignment_value = std::format("!({} >= {})", a_parsed, b_parsed);
        } else if (op == "ule") {
          assignment_value = std::format("!({} > {})", a_parsed, b_parsed);
        } else if (op == "une") {
          assignment_value = std::format("!({} == {})", a_parsed, b_parsed);
        } else if (op == "uno") {
          assignment_value = std::format("(isnan{} || isnan{})", ParseWrapped(a_parsed), ParseWrapped(b_parsed));
        } else {
          std::cerr << op << "\n";
          throw std::invalid_argument("Could not parse code assignment operator");
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

        assignment_type = "bool";
        if (op == "false") {
          assignment_value = "false";
        } else if (op == "eq") {
          assignment_value = std::format("({} == {})", ParseByType(a, type), ParseByType(b, type));
        } else if (op == "ne") {
          assignment_value = std::format("({} != {})", ParseByType(a, type), ParseByType(b, type));
        } else if (op == "ugt" || op == "sgt") {
          assignment_value = std::format("({}{} > {}{})", cast, ParseByType(a, type), cast, ParseByType(b, type));
        } else if (op == "uge" || op == "sge") {
          assignment_value = std::format("({}{} >= {}{})", cast, ParseByType(a, type), cast, ParseByType(b, type));
        } else if (op == "ult" || op == "slt") {
          assignment_value = std::format("({}{} < {}{})", cast, ParseByType(a, type), cast, ParseByType(b, type));
        } else if (op == "ule" || op == "sle") {
          assignment_value = std::format("({}{} <= {}{})", cast, ParseByType(a, type), cast, ParseByType(b, type));
        } else {
          std::cerr << op << "\n";
          throw std::invalid_argument("Could not parse code assignment operator");
        }
      } else if (instruction == "add") {
        // add nsw i32 %1678, 1
        auto [no_unsigned_wrap, no_signed_wrap, a, b] = StringViewMatch<4>(assignment, std::regex{R"(add (nuw )?(nsw )?(?:\S+) (\S+), (\S+))"});
        assignment_type = (no_signed_wrap.empty()) ? "uint" : "int";
        assignment_value = std::format("{} + {}", ParseByType(a, assignment_type), ParseByType(b, assignment_type));
      } else if (instruction == "sub") {
        // sub nsw i32 %43, %45
        auto [no_signed_wrap, a, b] = StringViewMatch<3>(assignment, std::regex{R"(sub (nsw )?(?:\S+) (\S+), (\S+))"});
        assignment_type = (no_signed_wrap.empty()) ? "uint" : "int";
        assignment_value = std::format("{} - {}", ParseByType(a, assignment_type), ParseByType(b, assignment_type));
      } else if (instruction == "sext") {
        // %43 = sext i1 %324 to i32
        auto [from_type, a, to_type] = StringViewMatch<3>(assignment, std::regex{R"(sext (?:fast )?(\S+) (\S+) to (\S+))"});
        assignment_type = ParseType(to_type);
        assignment_value = std::format("{}(({}){})", assignment_type, ParseUnsignedType(from_type), ParseInt(a));
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
          assignment_value = std::format("{} && {}", ParseInt(a), ParseInt(b));
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
        assignment_type = "int";
        assignment_value = std::format("{} / {}", ParseInt(a), ParseInt(b));
      } else if (instruction == "or") {
        auto [type, a, b] = StringViewMatch<3>(assignment, std::regex{R"(or (\S+) (\S+), (\S+))"});
        if (type == "i1") {
          assignment_type = "bool";
          assignment_value = std::format("{} || {}", ParseInt(a), ParseInt(b));
        } else {
          assignment_type = ParseType(type);
          assignment_value = std::format("{} | {}", ParseInt(a), ParseInt(b));
        }
      } else if (instruction == "alloca") {
        // alloca [6 x float], align 4
        auto [size, type, align] = StringViewMatch<3>(assignment, std::regex{R"(alloca \[(\S+) x (\S+)\], align (\S+))"});
        decompiled = std::format("{} _{}[{}];", ParseType(type), variable, ParseInt(size));
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
        } else {
          std::cerr << line << "\n";
          throw std::invalid_argument("Unrecognized code assignment");
        }
      } else if (instruction == "phi") {
        // phi float [ 0x3FF61108E0000000, %0 ], [ 0x3FF069AC80000000, %21 ], [ 0x3FE6412500000000, %23 ], [ %27, %25 ]
        auto [type, arguments] = StringViewMatch<2>(assignment, std::regex{R"(phi (\S+) (.+))"});
        // Declare variable
        bool declared = false;
        auto pairs = StringViewSplitAll(arguments, std::regex{R"((\[ (\S+), %(\S+) \]),?)"}, {2, 3});

        for (const auto& [value, predecessor] : pairs) {
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
        // phi_variables.emplace(variable);

      } else if (instruction == "load") {
        // load float, float* %1681, align 4, !tbaa !26
        // load float, float addrspace(3)* %64, align 4, !tbaa !27
        auto [source] = StringViewMatch<1>(assignment, std::regex{R"(load \S+, [^*]+\* %(\S+),.*)"});
        assignment_type = "float";
        assignment_value = stored_pointers[source];
      } else if (instruction == "bitcast") {
        // %63 = bitcast i32 %62 to float
        auto [source_type, source_variable, dest_type] = StringViewMatch<3>(assignment, std::regex{R"(bitcast (\S+) (\S+) to (\S+))"});
        if (source_type.empty()) {
          // decompiled = std::format("// {}", line);
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
        auto [source, index] = StringViewMatch<2>(
            assignment,
            std::regex{R"(getelementptr (?:inbounds )?\[[^\]]+\], \[[^\]]+\](?: addrspace\(\d+\))?\* (\S+), i32 \S+, i32 (\S+).*)"});
        // %1369 = getelementptr inbounds [6 x float], [6 x float]* %10, i32 0, i32 0
        // %58 = getelementptr [128 x float], [128 x float] addrspace(3)* @"\01?g_ToneMapRadianceSamples@@3PAMA", i32 0, i32 %57
        std::string parsed_source;
        if (source.starts_with('%')) {
          parsed_source = std::format("_{}", source.substr(1));
        } else if (source.starts_with('@')) {
          if (auto pair = preprocess_state.global_variables.find(std::string(source));
              pair != preprocess_state.global_variables.end()) {
            parsed_source = pair->second;
          } else {
            throw std::invalid_argument("Unknown global variable");
          }
        } else {
          throw std::invalid_argument("Unknown pointer source");
        }
        const auto pointer_value = std::format("{}[{}]", parsed_source, ParseInt(index));
        stored_pointers[variable] = pointer_value;
        IncrementVariableCounter(variable);
      } else {
        std::cerr << line << "\n";
        throw std::invalid_argument("Unrecognized code assignment");
      }

      if (decompiled.empty() && !assignment_value.empty()) {
        if (is_identity) {
          variable_aliases.emplace(variable, std::pair<std::string, std::string>(assignment_type, OptimizeString(assignment_value)));
          use_comment = true;
        }
        if (use_comment) {
#if DECOMPILER_DXC_DEBUG >= 1
          decompiled = std::format("// {} _{} = {};", assignment_type, variable, assignment_value);
#endif
        } else {
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
        if (StringViewTrim(current_line) == "]") break;
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
        auto [opNumber, barrierMode] = StringViewSplit<2>(functionParamsString, param_regex, 2);
        if (barrierMode == "9") {
          decompiled = "GroupMemoryBarrierWithGroupSync();";
        } else {
          throw std::exception("Unknown barrier mode.");
        }
      } else if (functionName == "@dx.op.rawBufferStore.f32") {
        // call void @dx.op.rawBufferStore.f32(i32 140, %dx.types.Handle %1751, i32 0, i32 0, float %884, float %885, float %821, float %833, i8 15, i32 4)  ; RawBufferStore(uav,index,elementOffset,value0,value1,value2,value3,mask,alignment)

        auto [opNumber, uav, index, elementOffset, value0, value1, value2, value3, mask, alignment] = StringViewSplit<10>(functionParamsString, param_regex, 2);
        auto ref = std::string{uav.substr(1)};
        auto [res_name, range_index, resource_class] = preprocess_state.resource_binding_variables.at(ref);
        bool is_raw_buffer = false;
        if (resource_class == "0") {
          is_raw_buffer = preprocess_state.srv_resources[range_index].shape == Resource::ResourceKind::RawBuffer;
        } else if (resource_class == "1") {
          is_raw_buffer = preprocess_state.uav_resources[range_index].shape == Resource::ResourceKind::RawBuffer;
        } else {
          throw std::invalid_argument("Unknown @dx.op.rawBufferStore.f32 resource");
        }

        const bool has_value_y = value1 != "undef";
        const bool has_value_z = value2 != "undef";
        const bool has_value_w = value3 != "undef";
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

        // assert(is_raw_buffer);

        // assert(elementOffset == "undef");
        decompiled = std::format("{}[{} / {}] = {};",
                                 res_name, ParseInt(index), ParseInt(alignment), value);
      } else if (functionName == "@dx.op.storeOutput.f32") {
        // call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 0, float %2772)  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
        auto [opNumber, outputSigId, rowIndex, colIndex, value] = StringViewSplit<5>(functionParamsString, param_regex, 2);
        int output_signature_index;
        FromStringView(outputSigId, output_signature_index);
        auto signature = preprocess_state.output_signature[output_signature_index];
        if (rowIndex != "0") {
          throw std::exception("Row index not supported.");
        }
        if (signature.packed.MaskString() == "1") {
          if (ParseIndex(colIndex) != "x") {
            throw std::exception("Unexpected index.");
          }
          decompiled = std::format("{} = {};", signature.VariableString(), ParseFloat(value));
        } else {
          decompiled = std::format("{}.{} = {};", signature.VariableString(), ParseIndex(colIndex), ParseFloat(value));
        }
      } else if (functionName == "@dx.op.textureStore.f32") {
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
      } else if (functionName == "@dx.op.textureStore.i32") {
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
      } else if (functionName == "@dx.op.bufferStore.i32") {
        // call void @dx.op.bufferStore.i32(i32 69, %dx.types.Handle %1, i32 %17, i32 undef, i32 %438, i32 %438, i32 %438, i32 %438, i8 15)  ; BufferStore(uav,coord0,coord1,value0,value1,value2,value3,mask)

        auto [opNumber, uav, coord0, coord1, value0, value1, value2, value3, mask] = StringViewSplit<9>(functionParamsString, param_regex, 2);
        auto ref = std::string{uav.substr(1)};
        const bool has_coord_y = coord1 != "undef";
        std::string coords;
        auto [uav_name, uav_range_index, resource_class] = preprocess_state.resource_binding_variables.at(ref);
        auto uav_resource = preprocess_state.uav_resources[uav_range_index];
        if (has_coord_y) {
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

      } else {
        std::cerr << line << "\n";
        std::cerr << "Function name: " << functionName << "\n";
        throw std::invalid_argument("Unknown call function name");
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
      // store float %1358, float* %1369, align 4, !tbaa !26, !alias.scope !30
      static auto regex = std::regex{R"(^  store \S+ ([^,]+), [^*]+\* %([A-Za-z0-9]+),?.*)"};
      auto [value, pointer] = StringViewMatch<2>(line, regex);

      std::string decompiled = std::format("{} = {};", stored_pointers[pointer], ParseFloat(value));

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
          throw std::invalid_argument("Unexpected code block");
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

    auto ListRecursions() {
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
    for (const auto property : src_property) {
      SignaturePacked packed;
      bool found = false;
      for (const auto candidate_packed : src_packed) {
        if (candidate_packed.name != property.name) continue;
        if (candidate_packed.index != property.index) continue;
        destination.emplace_back(candidate_packed, property);
        found = true;
        break;
      }

      if (!found) {
        std::stringstream s;
        s << "Could not find packed signature: ";
        s << property.ToString();
        throw std::exception(s.str().c_str());
      }
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
  };

  std::string Decompile(std::string_view disassembly, const DecompileOptions& decompile_options = {
                                                          .flatten = false,
                                                          .use_do_while = false,
                                                      }) {
    Init();
    this->source_lines = StringViewSplitAll(disassembly, '\n');

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
              throw std::invalid_argument("Unexpected start of file");
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
              throw std::invalid_argument("Unexpected description entry");
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
              throw std::invalid_argument("Unexpected buffer definition block start");
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
              throw std::invalid_argument("Unexpected line");
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

            static auto regex = std::regex{R"(^(\S+) = (?:(internal|external) )?(?:(unnamed_addr|addrspace\(\d+\)) )?(constant|global) (?:\[(\S+) x ([^\]]+)\]|(\S+))(?:,|(?: \[([^\]]+)\])| undef).*)"};
            auto [variable_name, scope, addr, qualifier, array_size, array_type, value_type, entries] = StringViewMatch<8>(line, regex);

            std::string output_name = std::format("_global_{}", preprocess_state.global_variables.size());

            std::stringstream decompiled;

            if (scope == "internal") {
              decompiled << "static const ";
            } else if (scope == "external" || scope == "") {
              decompiled << "groupshared ";
            } else {
              throw std::exception("Unknown global variable scope.");
            }
            if (!array_type.empty()) {
              decompiled << array_type << " ";
              decompiled << output_name;
              decompiled << "[" << array_size << "]";
            } else {
              decompiled << value_type << " ";
              decompiled << output_name;
            }
            if (entries.empty()) {
              decompiled << ";";
            } else {
              auto values = StringViewSplitAll(entries, std::regex{R"((\s*(\S+) (\S+)),?)"}, {2, 3});
              decompiled << " = { ";

              int array_size_number;
              FromStringView(array_size, array_size_number);
              for (int i = 0; i < array_size_number; ++i) {
                if (array_type == "float") {
                  decompiled << ParseSuffixedString(values[i].second, 'f');
                } else if (array_type == "half") {
                  decompiled << ParseSuffixedString(values[i].second, 'h');
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

    // Decompilation also notes
    current_code_function->DecompileLines(preprocess_state);

    if (decompile_options.flatten) {
      for (const auto& [variable, count] : current_code_function->variable_counter) {
        if (count == 1) {
          current_code_function->single_use_variables.insert(variable);
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

      static const std::regex STRUCT_PATTERN = std::regex(R"(%(?:hostlayout\.)?(?:struct\.)(.*))");
      auto [struct_name] = StringViewMatch<1>(definition_name, STRUCT_PATTERN);

      if (struct_name.empty()) return;
      if (struct_name == "SamplerState") return;

      for (const auto& [declaration, name, type_name, optional_offset] : definition.variables) {
        // Check for nested structs
        DataType info(type_name);
        static const std::regex STRUCT_PATTERN = std::regex(R"(%(?:hostlayout\.)(?:struct\.)(.*))");
        auto [struct_name] = StringViewMatch<1>(info.data_type, STRUCT_PATTERN);
        if (struct_name.empty()) continue;

        if (!added_definitions.contains(std::string(info.data_type))) {
          declare_definition(info.data_type, "");
        }
      }

      string_stream << spacing << "struct " << struct_name << " {\n";
      indent_spacing();
      for (const auto& [declaration, name, type_name, optional_offset] : definition.variables) {
        DataType info(type_name);

        static const std::regex TYPE_NAME_PATTERN = std::regex(R"(%?(host)?(?:layout\.)?(struct\.)?(.*))");
        auto [is_host, is_struct, type_name_parsed] = StringViewMatch<3>(info.data_type, TYPE_NAME_PATTERN);

        assert(!type_name_parsed.empty());

        if (is_host.empty() && !is_struct.empty()) {
          declare_definition(info.data_type, name);
        } else {
          if (declaration.starts_with("uint")) {
            // use uint from declaration
            assert(info.data_type == "int" || info.data_type == "uint");
            string_stream << spacing << "uint";
          } else {
            string_stream << spacing << type_name_parsed;
          }
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
      static const std::regex STRUCT_PATTERN = std::regex(R"(%(?:hostlayout\.)(?:struct\.)(.*))");
      auto [struct_name] = StringViewMatch<1>(name, STRUCT_PATTERN);
      if (struct_name.empty()) continue;
      if (struct_name == "SamplerState") continue;

      if (!added_definitions.contains(std::string(name))) {
        declare_definition(name, "");
      }
    }

    if (!added_definitions.empty()) {
      string_stream << "\n";
    }

    for (const auto& srv_resource : preprocess_state.srv_resources) {
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

      static const std::regex TYPE_NAME_PATTERN = std::regex(R"(%?(?:host)?(?:layout\.)?(?:struct\.)?(.*))");
      auto [type_name_parsed] = StringViewMatch<1>(srv_resource.data_type, TYPE_NAME_PATTERN);
      assert(!type_name_parsed.empty());

      string_stream << SRVResource::ResourceKindString(srv_resource.shape);

      string_stream << "<" << type_name_parsed << ">";

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
      string_stream << "RW" << UAVResource::ResourceKindString(uav_resource.shape);
      if (uav_resource.element_type != SRVResource::ComponentType::Invalid) {
        static const std::regex TYPE_NAME_PATTERN = std::regex(R"(%?(?:host)?(?:layout\.)?(?:struct\.)?(.*))");
        auto [type_name_parsed] = StringViewMatch<1>(uav_resource.data_type, TYPE_NAME_PATTERN);

        assert(!type_name_parsed.empty());

        string_stream << "<" << type_name_parsed << ">";
      } else {
        string_stream << "< (" << uav_resource.stride << " bytes) >";
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

    for (const auto& cbv_resource : preprocess_state.cbv_resources) {
      string_stream << "cbuffer " << cbv_resource.name;
      if (cbv_resource.array_size.has_value()) {
        string_stream << "[";
        if (cbv_resource.array_size != 0) {
          string_stream << cbv_resource.array_size.value();
        }
        string_stream << "]";
      }
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
      if (use_cbuffer_float4) {
        string_stream << "  float4 " << cbv_resource.name;
        string_stream << "[" << ceil(static_cast<float>(cbv_resource.buffer_size) / 16.f) << "] : packoffset(c0);\n";
      } else if (definition.size == cbv_resource.buffer_size || definition.has_offsets) {
        for (const auto& [declaration, name, type_name, optional_offset] : definition.variables) {
          DataType info(type_name);
          assert(!name.empty());

          if (type_name.starts_with("%class")) {
            // known classes
            if (type_name.starts_with("%class.matrix")) {
              static const std::regex PATTERN = std::regex(R"(%class\.matrix\.([^.]+)\.(\d+)\.(\d+))");
              auto [base_type, array_string, vector_string] = StringViewMatch<3>(type_name, PATTERN);
              uint32_t array;
              FromStringView(array_string, array);
              uint32_t vector;
              FromStringView(vector_string, vector);
              string_stream << spacing << std::format("row_major {}{}x{} {}", base_type, array, vector, name);
            }
          } else if (info.data_type == "float" || info.data_type == "uint" || info.data_type == "int") {
            if (declaration.starts_with("uint")) {
              // use uint from declaration
              assert(info.data_type == "int" || info.data_type == "uint");
              string_stream << spacing << "uint";
            } else {
              string_stream << spacing << info.data_type;
            }
            if (info.vector_size != 0) {
              string_stream << info.vector_size;
            }
            string_stream << " " << name;

          } else if (info.data_type.starts_with("%struct.")) {
            declare_definition(info.data_type, name);

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
          string_stream << std::format(" : packoffset(c{:03}.{});\n", item_offset / 16, VECTOR_INDEXES[item_offset % 16 / 4], item_offset);
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
      }
      unindent_spacing();
      // string_stream << "  } " << cbv_resource.name << " : packoffset(c0);\n";

      string_stream << "};\n\n";
    }

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

    auto convergences = current_code_function->ListConvergences();
    auto recursions = current_code_function->ListRecursions();

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
        string_stream << spacing << "while(true) {\n";
        indent_spacing();
        // break at these
      }

      auto on_complete = [&]() {
        if (using_recursion) {
          string_stream << spacing << "break;\n";
          unindent_spacing();
          string_stream << spacing << "}\n";
          pending_recursions.pop_back();
          current_loops.pop_back();
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
          string_stream << spacing << optimized_line << "\n";
        } else {
          string_stream << spacing << hlsl_line << "\n";
        }
      }
      for (const auto& [variable, type, value, predecessor, code_function, is_assign] : code_block.phi_lines) {
        auto assignment_type = ParseType(type);
        std::string phi_line;
        if (is_assign) continue;
        // Declare variable now
        phi_line = std::format("{} _{};", assignment_type, variable);
        string_stream << spacing << phi_line << "\n";
      }

      int current_loop = current_loops.empty() ? -1 : current_loop = current_loops.rbegin()[0];

      if (code_block.code_branch.branch_condition_true <= 0 && code_block.code_switch.switch_condition.empty()) {
        return;
      }

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
          string_stream << spacing << "continue;\n";  // go back
        } else if (next_convergence == branch_number) {
#if DECOMPILER_DXC_DEBUG >= 1
          string_stream << spacing << "// fn:converge " << line_number << " => " << next_convergence << "\n";
#endif
          // noop
        } else if (std::ranges::find(pending_convergences, branch_number) != pending_convergences.end()) {
          if (decompile_options.use_do_while) {
            string_stream << spacing << "break;\n";
          } else {
            throw std::exception("Unexpected goto");
          }
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
        throw std::exception("Unsupported loop detected.");
      }

      if (code_block.code_branch.branch_condition_true == next_convergence) {
        if (code_block.code_branch.use_hint) {
          string_stream << spacing << "[branch]\n";
        }
        string_stream << spacing << "if (!" << code_block.code_branch.branch_condition << ") {\n";
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
        string_stream << spacing << std::format("if {} {{\n", ParseWrapped(code_block.code_branch.branch_condition));
        indent_spacing();
        on_branch(code_block.code_branch.branch_condition_true);
        unindent_spacing();

        close_lonely_if(next_convergence);

        on_complete();
        return;
      }

      // Find next convergence for these two items
      int pair_convergence = -1;
      for (auto& [convergence_line_number, callers] : convergences) {
        if (
            (convergence_line_number == code_block.code_branch.branch_condition_true || callers.contains(code_block.code_branch.branch_condition_true))
            && (convergence_line_number == code_block.code_branch.branch_condition_false || callers.contains(code_block.code_branch.branch_condition_false))) {
          if (convergence_line_number == next_convergence) break;
          pair_convergence = convergence_line_number;
          if (!pending_convergences.empty()) {
            if (decompile_options.use_do_while) {
              string_stream << spacing << "do {\n";
              indent_spacing();
            }
          }
          pending_convergences.push_back(pair_convergence);
          break;
        }
      }

      if (pair_convergence == code_block.code_branch.branch_condition_true) {
        if (code_block.code_branch.use_hint) {
          string_stream << spacing << "[branch]\n";
        }
        string_stream << spacing << "if (!" << code_block.code_branch.branch_condition << ") {\n";
        indent_spacing();
        on_branch(code_block.code_branch.branch_condition_false);
        unindent_spacing();

        close_lonely_if(pair_convergence);

        // Only print else
      } else if (pair_convergence == code_block.code_branch.branch_condition_false) {
        if (code_block.code_branch.use_hint) {
          string_stream << spacing << "[branch]\n";
        }
        string_stream << spacing << std::format("if {} {{\n", ParseWrapped(code_block.code_branch.branch_condition));
        indent_spacing();
        on_branch(code_block.code_branch.branch_condition_true);
        unindent_spacing();

        close_lonely_if(pair_convergence);

      } else if (code_block.code_branch.branch_condition_true < code_block.code_branch.branch_condition_false) {
        if (code_block.code_branch.use_hint) {
          string_stream << spacing << "[branch]\n";
        }
        string_stream << spacing << std::format("if {} {{\n", ParseWrapped(code_block.code_branch.branch_condition));
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
        string_stream << spacing << "if (!" << code_block.code_branch.branch_condition << ") {\n";
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
        on_branch(pair_convergence, true);
        if (!is_empty) {
          if (decompile_options.use_do_while) {
            unindent_spacing();
            string_stream << spacing << "} while (false);\n";
          }
        }
      };
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
          string_stream << "  " << signature.ToString();
          if (std::next(it) != end) {
            string_stream << ",";
          }
          string_stream << "\n";
        }
      } else {
        string_stream << "\n";
        string_stream << "  uint3 SV_DispatchThreadID : SV_DispatchThreadID,\n";
        string_stream << "  uint3 SV_GroupID : SV_GroupID,\n";
        string_stream << "  uint3 SV_GroupThreadID : SV_GroupThreadID,\n";
        string_stream << "  uint SV_GroupIndex : SV_GroupIndex\n";
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
    append_code_block(0);
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
    return string_stream.str();
#endif
  }
};  // namespace Decompiler

}  // namespace renodx::utils::shader::decompiler::dxc
