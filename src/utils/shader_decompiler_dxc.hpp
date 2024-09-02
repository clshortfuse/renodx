/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

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
#include <print>
#include <regex>
#include <set>
#include <span>
#include <sstream>
#include <stdexcept>
#include <string>
#include <unordered_map>
#include <vector>

#include "../utils/string_view.hpp"

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

class Decompiler {
  enum class SignatureName : uint32_t {
    PRIMITIVE_ID,
    SV_POSITION,
    SV_RENDER_TARGET_ARRAY_INDEX,
    SV_TARGET,
    TEXCOORD,
    TEXCOORD10_CENTROID,
    TEXCOORD11_CENTROID
  };

  static std::string ParseIndex(std::string_view input) {
    if (input == "0") return "x";
    if (input == "1") return "y";
    if (input == "2") return "z";
    if (input == "3") return "w";
    throw std::invalid_argument("Could not parse index");
  }

  static std::string ParseBool(std::string_view input) {
    if (input.at(0) == '%') {
      return std::format("_{}", input.substr(1));
    }
    return std::format("{}", input);
  }

  static std::string ParseInt(std::string_view input) {
    if (input.at(0) == '%') {
      return std::format("_{}", input.substr(1));
    }
    return std::format("{}", input);
  }

  static std::string ParseVariable(std::string_view input) {
    if (input.at(0) == '%') {
      return std::format("_{}", input.substr(1));
    }
    throw std::invalid_argument("Could not parse variable");
  }

  static std::string ParseFloat(std::string_view input) {
    if (input.at(0) == '%') {
      return std::format("_{}", input.substr(1));
    }
    std::string output;
    double_t value;
    if (input.starts_with("0x")) {
      const std::string string = std::string{input};
      auto unsigned_long = strtoull(string.c_str(), nullptr, 16);
      uint64_t as_uint64 = unsigned_long;
      memcpy(&value, &as_uint64, sizeof value);
    } else {
      FromStringView(input, value);
    }
    output = std::format("{}", value);
    if (output.find('.') == std::string::npos) {
      output += ".0f";
    } else {
      output += "f";
    }
    return output;
  }

  static std::string ParseType(std::string_view input) {
    if (input == "float") return "float";
    if (input == "i32") return "int";
    if (input == "i1") return "bool";
    throw std::invalid_argument("Could not parse code assignment type");
  }

  static std::string ParseOperator(std::string_view input) {
    if (input == "ogt") return ">";
    if (input == "ugt") return ">";

    if (input == "olt") return "<";
    if (input == "ult") return "<";

    if (input == "ole") return "<=";
    if (input == "ule") return "<=";

    if (input == "oge") return ">=";
    if (input == "uge") return ">=";

    if (input == "oeq") return "==";
    if (input == "eq") return "==";
    if (input == "ne") return "!=";
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
      {"83", "ddx_course"},
      {"84", "ddy_course"},
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

  static SignatureName SignatureNameFromString(std::string_view input) {
    if (input == "PRIMITIVE_ID") return SignatureName::PRIMITIVE_ID;
    if (input == "SV_Position") return SignatureName::SV_POSITION;
    if (input == "SV_RenderTargetArrayIndex") return SignatureName::SV_RENDER_TARGET_ARRAY_INDEX;
    if (input == "SV_Target") return SignatureName::SV_TARGET;
    if (input == "TEXCOORD") return SignatureName::TEXCOORD;
    if (input == "TEXCOORD10_centroid") return SignatureName::TEXCOORD10_CENTROID;
    if (input == "TEXCOORD11_centroid") return SignatureName::TEXCOORD11_CENTROID;
    throw std::invalid_argument("Unknown signature name");
  }

  static std::string SignatureNameToString(SignatureName name) {
    if (name == SignatureName::PRIMITIVE_ID) return "PRIMITIVE_ID";
    if (name == SignatureName::SV_POSITION) return "SV_Position";
    if (name == SignatureName::SV_RENDER_TARGET_ARRAY_INDEX) return "SV_RenderTargetArrayIndex";
    if (name == SignatureName::SV_TARGET) return "SV_Target";
    if (name == SignatureName::TEXCOORD) return "TEXCOORD";
    if (name == SignatureName::TEXCOORD10_CENTROID) return "TEXCOORD10_centroid";
    if (name == SignatureName::TEXCOORD11_CENTROID) return "TEXCOORD11_centroid";
    throw std::invalid_argument("Unknown signature name");
  }

  struct SignaturePacked {
    SignatureName name;

    uint32_t index;
    uint32_t mask;  // Bitwise 1010
    uint32_t dxregister;

    enum class SysValue {
      NONE,
      POS,
      RTINDEX,
      TARGET
    } sys_value;

    enum class Format {
      FLOAT,
      UINT
    } format;

    uint32_t used;

    [[nodiscard]] std::string ToString() const {
      std::stringstream s;
      s << "name: " << static_cast<uint32_t>(this->name);
      s << ", index: " << this->index;
      s << ", mask: " << this->mask;
      s << ", register: " << this->dxregister;
      s << ", sysValue: " << static_cast<uint32_t>(this->sys_value);
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

    static SysValue SysValueFromString(std::string_view input) {
      if (input == "NONE") return SysValue::NONE;
      if (input == "POS") return SysValue::POS;
      if (input == "RTINDEX") return SysValue::RTINDEX;
      if (input == "TARGET") return SysValue::TARGET;
      throw std::invalid_argument("Unknown SysValue");
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

      static auto regex = std::regex{R"(; (\S+)\s+(\S+)\s+((?:x| )(?:y| )(?:z| )(?:w| ))\s+(\S+)\s+(\S+)\s+(\S+)\s*([xyzw ]*))"};
      auto [name, index, mask, dxregister, sysValue, format, used] = StringViewMatch<7>(line, regex);

      this->name = SignatureNameFromString(name);
      FromStringView(index, this->index);
      this->mask = FlagsFromCoordinates(mask);
      FromStringView(dxregister, this->dxregister);
      this->sys_value = SysValueFromString(sysValue);
      this->format = FormatFromString(format);
      this->used = FlagsFromCoordinates(used);
    }
  };

  struct SignatureProperty {
    SignatureName name;

    uint32_t index;

    enum class InterpMode : uint32_t {
      NONE,
      NOINTERPOLATION,
      NOPERSPECTIVE,
      LINEAR,
    } interp_mode;

    int32_t dyn_index = -1;

    [[nodiscard]] std::string ToString() const {
      std::stringstream s;
      s << "name: " << static_cast<uint32_t>(this->name);
      s << ", index: " << this->index;
      s << ", interpMode: " << static_cast<uint32_t>(this->interp_mode);
      s << ", dynIndex: " << this->dyn_index;
      return s.str();
    }

    static InterpMode InterpModeFromString(std::string_view input) {
      if (input.empty()) return InterpMode::NONE;
      if (input == "nointerpolation") return InterpMode::NOINTERPOLATION;
      if (input == "noperspective") return InterpMode::NOPERSPECTIVE;
      if (input == "linear") return InterpMode::LINEAR;
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

      this->name = SignatureNameFromString(name);
      FromStringView(index, this->index);
      this->interp_mode = InterpModeFromString(StringViewTrim(interpMode));
      this->dyn_index = DynIndexFromString(StringViewTrim(dynIndex));
    }
  };

  struct Signature {
    SignatureName name;
    SignaturePacked packed;
    SignatureProperty property;
    std::string name_string;

    explicit Signature(SignaturePacked packed, SignatureProperty property) {
      this->name = packed.name;
      this->packed = packed;
      this->property = property;
      this->name_string = SignatureNameToString(this->name);
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
      if (property.index == 0) return this->name_string;

      std::stringstream string_stream;
      string_stream << this->name_string;
      if (property.index != 0) {
        string_stream << "_" << property.index;
      }
      return string_stream.str();
    }

    [[nodiscard]] std::string SemanticString() const {
      std::stringstream string_stream;
      string_stream << SignatureNameToString(property.name);
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
      static auto regex = std::regex{R"(; ((?:cbuffer)|(?:Resource bind info for))(\s*\w*))"};
      auto [bufferType, name] = StringViewMatch<2>(line, regex);
      this->buffer_type = BufferTypeFromString(bufferType);
      this->name = name;
    }
  };

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
      F32,
      I32,
      STRUCTURE,
    } format;

    enum class ResourceDimensions {
      NA,
      DIMENSION_2D,
      DIMENSION_3D,
      BUFFER,
      READ_ONLY,
    } dimensions;

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
      if (input == "f32") return ResourceFormat::F32;
      if (input == "i32") return ResourceFormat::I32;
      if (input == "struct") return ResourceFormat::STRUCTURE;
      throw std::invalid_argument("Unknown ResourceFormat");
    }

    static ResourceDimensions ResourceDimensionsFromString(std::string_view input) {
      if (input == "NA") return ResourceDimensions::NA;
      if (input == "2d") return ResourceDimensions::DIMENSION_2D;
      if (input == "3d") return ResourceDimensions::DIMENSION_3D;
      if (input == "buffer") return ResourceDimensions::BUFFER;
      if (input == "r/o") return ResourceDimensions::READ_ONLY;
      throw std::invalid_argument("Unknown ResourceDimensions");
    }

    explicit ResourceDescription(std::string_view line) {
      // ; _31_33                            cbuffer      NA          NA     CB0            cb0     1
      static auto regex = std::regex{R"(; (.{30})\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s*)"};
      auto [name, type, format, dimensions, id, hlslBinding, count] = StringViewMatch<7>(line, regex);
      this->name = StringViewTrim(name);
      this->type = ResourceTypeFromString(type);
      this->format = ResourceFormatFromString(format);
      this->dimensions = ResourceDimensionsFromString(dimensions);
      this->id = id;
      this->hlsl_binding = hlslBinding;
      FromStringView(count, this->count);
    }
  };
  struct Resource : Metadata {
    uint32_t record_id;
    std::string_view pointer;
    std::string name;
    uint32_t space;
    uint32_t signature_index;
    uint32_t signature_range;

    explicit Resource(std::vector<std::string_view>& metadata) : Metadata() {
      // !6 = !{i32 0, %"class.Texture2D<vector<float, 4> >"* undef, !"", i32 0, i32 32, i32 1, i32 2, i32 0, !7}
      FromStringView(ParseKeyValue(metadata[0])[1], this->record_id);
      this->pointer = ParseKeyValue(metadata[1])[0];
      this->name = ParseString(metadata[2]);
      FromStringView(ParseKeyValue(metadata[3])[1], this->space);
      FromStringView(ParseKeyValue(metadata[4])[1], this->signature_index);
      FromStringView(ParseKeyValue(metadata[5])[1], this->signature_range);
    };

    void UpdateNameFromDescription(std::span<ResourceDescription> resource_descriptions, std::string prefix) {
      if (!name.empty()) return;
      std::string hlsl_bind;
      if (space != 0u) {
        hlsl_bind = std::format("{}{},space{}", prefix, signature_index, space);
      } else {
        hlsl_bind = std::format("{}{}", prefix, signature_index);
      }
      bool found = false;
      for (const auto& description : resource_descriptions) {
        if (description.hlsl_binding == hlsl_bind) {
          if (description.name.empty()) {
            name = description.id;
            std::transform(name.begin(), name.end(), name.begin(),
                           [](unsigned char c) { return std::tolower(c); });

          } else {
            name = description.name;
          }
          break;
        }
      }
    }

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

    static std::string ResourceKindString(ResourceKind& kind) {
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
          return "TypedBuffer";
        case ResourceKind::RawBuffer:
          return "RawBuffer";
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

    static std::string ComponentTypeString(ComponentType& component_type) {
      switch (component_type) {
        case ComponentType::I1:
          return "bool";
        case ComponentType::I16:
          return "int2";
        case ComponentType::U16:
          return "uint2";
        case ComponentType::I32:
          return "int4";
        case ComponentType::U32:
          return "uint4";
        case ComponentType::I64:
          return "int64_t ";
        case ComponentType::U64:
          return "uint64_t";
        case ComponentType::F16:
          return "half4";
        case ComponentType::F32:
          return "float4";
        case ComponentType::F64:
          return "double4";
        case ComponentType::SNormF16:
          return "snorm half4";
        case ComponentType::UNormF16:
          return "unorm half4";
        case ComponentType::SNormF32:
          return "snorm float4";
        case ComponentType::UNormF32:
          return "unorm float4";
        case ComponentType::SNormF64:
          return "snorm double4";
        case ComponentType::UNormF64:
          return "unorm double4";
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
    explicit SRVResource(
        std::vector<std::string_view>& metadata,
        std::map<std::string_view, std::vector<std::string_view>>& raw_metadata)
        : Resource(metadata) {
      // https://github.com/microsoft/DirectXShaderCompiler/blob/b766b432678cf5f7a93567d253bb5f7fd8a0b2c7/docs/DXIL.rst#L1047
      uint32_t shape;
      FromStringView(ParseKeyValue(metadata[6])[1], shape);
      this->shape = static_cast<ResourceKind>(shape);
      FromStringView(ParseKeyValue(metadata[7])[1], this->sample_count);
      auto pairs = raw_metadata[metadata[8]];
      int type_value;
      FromStringView(ParseKeyValue(pairs[0])[1], type_value);
      if (type_value == 0) {
        uint32_t element_type;
        FromStringView(ParseKeyValue(pairs[1])[1], element_type);
        this->element_type = static_cast<ComponentType>(element_type);
      } else {
        this->element_type = Resource::ComponentType::Invalid;
        FromStringView(ParseKeyValue(pairs[1])[1], this->stride);
      }
    }

    void UpdateNameFromDescription(std::span<ResourceDescription> resource_descriptions) {
      Resource::UpdateNameFromDescription(resource_descriptions, "t");
    }
  };

  struct UAVResource : Resource {
    ResourceKind shape;
    bool is_globally_coherent;
    bool has_counter;
    bool is_rasterizer_ordered_view;

    ComponentType element_type;
    uint32_t stride;

    explicit UAVResource(
        std::vector<std::string_view>& metadata,
        std::map<std::string_view, std::vector<std::string_view>>& raw_metadata)
        : Resource(metadata) {
      // https://github.com/microsoft/DirectXShaderCompiler/blob/b766b432678cf5f7a93567d253bb5f7fd8a0b2c7/docs/DXIL.rst#L1047
      uint32_t shape;
      FromStringView(ParseKeyValue(metadata[6])[1], shape);
      this->shape = static_cast<ResourceKind>(shape);

      this->is_globally_coherent = (ParseKeyValue(metadata[7])[1] == "true");
      this->has_counter = (ParseKeyValue(metadata[8])[1] == "true");
      this->has_counter = (ParseKeyValue(metadata[9])[1] == "true");
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
      }
    }

    void UpdateNameFromDescription(std::span<ResourceDescription> resource_descriptions) {
      Resource::UpdateNameFromDescription(resource_descriptions, "u");
    }
  };

  struct CBVResource : Resource {
    uint32_t buffer_size;
    explicit CBVResource(
        std::vector<std::string_view>& metadata,
        std::map<std::string_view, std::vector<std::string_view>>& raw_metadata)
        : Resource(metadata) {
      FromStringView(ParseKeyValue(metadata[6])[1], buffer_size);
    }

    void UpdateNameFromDescription(std::span<ResourceDescription> resource_descriptions) {
      Resource::UpdateNameFromDescription(resource_descriptions, "cb");
    }
  };

  struct SamplerResource : Resource {
    uint32_t buffer_size;
    explicit SamplerResource(
        std::vector<std::string_view>& metadata,
        std::map<std::string_view, std::vector<std::string_view>>& raw_metadata)
        : Resource(metadata) {
      FromStringView(ParseKeyValue(metadata[6])[1], buffer_size);
    }

    void UpdateNameFromDescription(std::span<ResourceDescription> resource_descriptions) {
      Resource::UpdateNameFromDescription(resource_descriptions, "s");
    }
  };

  struct DataType {
    size_t array_size;
    size_t vector_size;
    std::string data_type;

    explicit DataType(std::string_view line) {
      static auto regex = std::regex{R"(^(?:\[(\S+) x )?(?:<(\S+) x )?(\w+)(\*)?>?\]?$)"};
      const auto [array_size, vector_size, data_type, is_pointer] = StringViewMatch<4>(line, regex);
      if (array_size.empty()) {
        this->array_size = 0;
      } else {
        FromStringView(array_size, this->array_size);
      }
      if (vector_size.empty()) {
        this->vector_size = 0;
      } else {
        FromStringView(vector_size, this->vector_size);
      }
      if (data_type == "i32") {
        this->data_type = "int";
      } else {
        this->data_type = data_type;
      }
    }
  };

  struct TypeDefinition {
    std::string_view name;
    std::vector<std::pair<std::string, DataType>> types;
    std::optional<uint32_t> size;

    TypeDefinition() = default;

    explicit TypeDefinition(std::string_view line) {
      // %"class.Texture3D<vector<float, 4> >" = type { <4 x float>, %"class.Texture3D<vector<float, 4> >::mips_type" }
      static auto regex = std::regex{R"(^(%(?:(?:"[^"]+")|\S+)) = type \{([^}]+)\}$)"};

      auto [name, types] = StringViewMatch<2>(line, regex);

      this->name = name;

      static auto type_split = std::regex(R"( ((?:[^%][^},]+)|(?:%"[^"]+"))(?:,| ))");
      auto type_strings = StringViewSplitAll(types, type_split, 1);
      int value = 0;
      for (const auto type : type_strings) {
        this->types.emplace_back(std::format("value{:02}", value++), type);
      }
    }
  };

  struct PreprocessState {
    std::vector<Signature> input_signature;
    std::vector<Signature> output_signature;
    std::vector<ResourceDescription> resource_descriptions;
    std::map<std::string, std::string> global_variables;
    std::map<std::string, std::pair<std::string, uint32_t>> resource_binding_variables;
    std::vector<SRVResource> srv_resources;
    std::vector<UAVResource> uav_resources;
    std::vector<CBVResource> cbv_resources;
    std::vector<SamplerResource> sampler_resources;
    std::map<std::string_view, TypeDefinition> type_definitions;

    size_t GetTypeSize(const std::string& name) {
      uint32_t data_type_size;
      if (name == "float") {
        return 32 / 8;
      }
      if (name == "int") {
        return 32 / 8;
      }
      if (name == "i32") {
        return 32 / 8;
      }
      if (name == "bool") {
        return 8 / 8;
      }

      auto& definition = type_definitions[name];
      return GetTypeDefinitionSize(definition);
    }

    size_t GetTypeDefinitionSize(TypeDefinition& type_definition) {
      if (type_definition.size.has_value()) return type_definition.size.value();
      size_t size = 0;
      for (auto& [name, type] : type_definition.types) {
        uint32_t data_type_size = GetTypeSize(type.data_type);
        if (type.vector_size > 1) {
          data_type_size *= type.vector_size;
        }
        if (type.array_size > 1) {
          data_type_size *= type.array_size;
        }
        size += data_type_size;
      }
      type_definition.size = size;
      return size;
    }

    TypeDefinition& GetCBVType(CBVResource cbv_resource) {
      auto type_name = cbv_resource.pointer.substr(0, cbv_resource.pointer.length() - 1);
      auto& definition = type_definitions[type_name];
      return definition;
    }

    std::string DataTypeNameAtIndex(std::span<std::pair<std::string, DataType>> data_types, uint32_t index) {
      std::string name = "";
      auto current_index = 0;
      auto pending = index;
      for (auto& [name, type] : data_types) {
        uint32_t base_size = GetTypeSize(type.data_type);
        uint32_t data_type_size = base_size;
        if (type.vector_size > 1) {
          data_type_size *= type.vector_size;
        }
        if (type.array_size > 1) {
          data_type_size *= type.array_size;
        }
        if (pending > data_type_size) {
          pending -= data_type_size;
          continue;
        }

        // in this type
        if (type.vector_size > 1) {
        }
      }
      return name;
    };
    std::string CBVVariableNameAtIndex(CBVResource& cbv_resource, uint32_t index) {
      auto name = DataTypeNameAtIndex(GetCBVType(cbv_resource).types, index);
      return "";
    };
  };

  struct CodeBranch {
    std::string branch_condition;
    int branch_condition_true = -1;
    int branch_condition_false = -1;
  };

  struct CodeBlock {
    std::vector<std::string> hlsl_lines;
    CodeBranch branch;
  };

  struct CodeFunction {
    std::string_view name;
    std::string_view return_type;
    std::vector<std::string_view> parameters;
    std::map<int, CodeBlock> code_blocks;
    std::vector<std::string_view> lines;
    CodeBlock current_code_block;
    int current_code_block_number = 0;
    std::unordered_map<std::string_view, std::string> stored_pointers;

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

      // std::cout << "parsing: " << this->assignment << std::endl;
      auto instruction = StringViewSplitAll(assignment, ' ').at(0);
      if (instruction == "call") {
        static auto regex = std::regex{R"(call (\S+) ([^(]+)\(([^)]+)\)\s*)"};
        static auto param_regex = std::regex(R"(\s*(\S+) ((?:\d+)|(?:\{[^}]+\})|(?:%\d+)|(?:\S+))(?:(?:, )|(?:\s*$)))");
        auto [type, functionName, functionParamsString] = StringViewMatch<3>(assignment, regex);
        // auto paramMatches = string_view_split_all(functionParamsString, paramRegex, {1, 2});
        if (functionName == "@dx.op.createHandle") {
          //   %dx.types.Handle @dx.op.createHandle(i32 57, i8 2, i32 0, i32 0, i1 false)  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
          auto [opNumber, resource_class, range_id, index, nonUniformIndex] = StringViewSplit<5>(functionParamsString, param_regex, 2);
          int index_value;
          FromStringView(index, index_value);
          if (resource_class == "0") {
            auto srv = preprocess_state.srv_resources[index_value];
            decompiled = std::format("// texture _{} = {};", variable, srv.name);
            preprocess_state.resource_binding_variables[std::string(variable)] = {srv.name, index_value};
          } else if (resource_class == "1") {
            auto uav = preprocess_state.uav_resources[index_value];
            decompiled = std::format("// rwtexture _{} = {};", variable, uav.name);
            preprocess_state.resource_binding_variables[std::string(variable)] = {uav.name, index_value};
          } else if (resource_class == "2") {
            auto cbv = preprocess_state.cbv_resources[index_value];
            decompiled = std::format("// cbuffer _{} = {};", variable, cbv.name);
            preprocess_state.resource_binding_variables[std::string(variable)] = {cbv.name, index_value};
          } else if (resource_class == "3") {
            auto sampler = preprocess_state.sampler_resources[index_value];
            decompiled = std::format("// SamplerState _{} = {};", variable, sampler.name);
            preprocess_state.resource_binding_variables[std::string(variable)] = {sampler.name, index_value};
          } else {
            throw std::invalid_argument("Unknown resource type");
          }
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

          int index_value;
          FromStringView(index, index_value);
          if (resource_class == "0") {
            auto srv = preprocess_state.srv_resources[index_value];
            decompiled = std::format("// texture _{} = {};", variable, srv.name);
            preprocess_state.resource_binding_variables[std::string(variable)] = {srv.name, index_value};
          } else if (resource_class == "1") {
            auto uav = preprocess_state.uav_resources[index_value];
            decompiled = std::format("// rwtexture _{} = {};", variable, uav.name);
            preprocess_state.resource_binding_variables[std::string(variable)] = {uav.name, index_value};
          } else if (resource_class == "2") {
            auto cbv = preprocess_state.cbv_resources[index_value];
            decompiled = std::format("// cbuffer _{} = {};", variable, cbv.name);
            preprocess_state.resource_binding_variables[std::string(variable)] = {cbv.name, index_value};
          } else if (resource_class == "3") {
            auto sampler = preprocess_state.sampler_resources[index_value];
            decompiled = std::format("// SamplerState _{} = {};", variable, sampler.name);
            preprocess_state.resource_binding_variables[std::string(variable)] = {sampler.name, index_value};
          } else {
            throw std::invalid_argument("Unknown resource type");
          }
        } else if (functionName == "@dx.op.annotateHandle") {
          // %4 = call %dx.types.Handle @dx.op.annotateHandle(i32 216, %dx.types.Handle %3, %dx.types.ResourceProperties { i32 13, i32 644 })  ; AnnotateHandle(res,props)  resource: CBuffer
          auto [opNumber, res, props] = StringViewSplit<3>(functionParamsString, param_regex, 2);
          auto ref = std::string{res.substr(1)};
          preprocess_state.resource_binding_variables[std::string(variable)] = preprocess_state.resource_binding_variables.at(ref);
          decompiled = std::format("// _{} = _{};", variable, ref);
        } else if (functionName == "@dx.op.loadInput.f32") {
          //   @dx.op.loadInput.f32(i32 4, i32 3, i32 0, i8 0, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
          auto [opNumber, inputSigId, rowIndex, colIndex, gsVertexAxis] = StringViewSplit<5>(functionParamsString, param_regex, 2);
          int input_signature_index;
          FromStringView(inputSigId, input_signature_index);
          auto signature = preprocess_state.input_signature[input_signature_index];
          if (signature.packed.MaskString() == "1") {
            if (ParseIndex(colIndex) != "x") {
              throw std::exception("Unexpected index.");
            }
            decompiled = std::format("float _{} = {};", variable, signature.VariableString());
          } else {
            decompiled = std::format("float _{} = {}.{};", variable, signature.VariableString(), ParseIndex(colIndex));
          }
        } else if (functionName == "@dx.op.loadInput.i32") {
          //   @dx.op.loadInput.i32(i32 4, i32 2, i32 0, i8 0, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
          auto [opNumber, inputSigId, rowIndex, colIndex, gsVertexAxis] = StringViewSplit<5>(functionParamsString, param_regex, 2);
          int input_signature_index;
          FromStringView(inputSigId, input_signature_index);
          auto signature = preprocess_state.input_signature[input_signature_index];
          if (signature.packed.MaskString() == "1") {
            if (ParseIndex(colIndex) != "x") {
              throw std::exception("Unexpected index.");
            }
            decompiled = std::format("int _{} = {};", variable, signature.VariableString());
          } else {
            decompiled = std::format("int _{} = {}.{};", variable, signature.VariableString(), ParseIndex(colIndex));
          }
        } else if (functionName == "@dx.op.cbufferLoadLegacy.f32") {
          auto [opNumber, handle, regIndex] = StringViewSplit<3>(functionParamsString, param_regex, 2);
          auto ref = std::string{handle.substr(1)};
          auto cbv_resource = preprocess_state.cbv_resources[preprocess_state.resource_binding_variables.at(ref).second];

          uint32_t cbv_variable_index;
          FromStringView(regIndex, cbv_variable_index);
          auto name = preprocess_state.CBVVariableNameAtIndex(cbv_resource, cbv_variable_index);

          // decompiled = std::format("// float4 _{} = {}.{};", variable, cbv_resource.name, cbv_variable_index);
          // decompiled = std::format("float4 _{} = {}.;", variable, binding_name, cbv_index);
          decompiled = std::format("float4 _{} = {}[{}u];", variable, cbv_resource.name, cbv_variable_index);

        } else if (functionName == "@dx.op.cbufferLoadLegacy.i32") {
          // %18 = call %dx.types.CBufRet.i32 @dx.op.cbufferLoadLegacy.i32(i32 59, %dx.types.Handle %4, i32 40)  ; CBufferLoadLegacy(handle,regIndex)
          auto [opNumber, handle, regIndex] = StringViewSplit<3>(functionParamsString, param_regex, 2);
          auto ref = std::string{handle.substr(1)};
          auto cbv_resource = preprocess_state.cbv_resources[preprocess_state.resource_binding_variables.at(ref).second];

          uint32_t cbv_variable_index;
          FromStringView(regIndex, cbv_variable_index);
          auto name = preprocess_state.CBVVariableNameAtIndex(cbv_resource, cbv_variable_index);

          // preprocess_state.cbv_resources[index_value];
          // decompiled = std::format("int4 _{} = {}[{}u];", variable, cbv_name, ParseInt(regIndex));
          decompiled = std::format("int4 _{} = {}[{}u];", variable, cbv_resource.name, cbv_variable_index);
        } else if (functionName == "@dx.op.unary.f32") {
          auto [opNumber, value] = StringViewSplit<2>(functionParamsString, param_regex, 2);
          if (auto pair = UNARY_FLOAT_OPS.find(std::string(opNumber));
              pair != UNARY_FLOAT_OPS.end()) {
            decompiled = std::format("{} _{} = {}({});", ParseType(type), variable, pair->second, ParseFloat(value));
          } else {
            throw std::invalid_argument("Unknown @dx.op.unary.f32");
          }
        } else if (functionName == "@dx.op.unary.i32") {
          auto [opNumber, value] = StringViewSplit<2>(functionParamsString, param_regex, 2);
          if (auto pair = UNARY_INT32_OPS.find(std::string(opNumber));
              pair != UNARY_INT32_OPS.end()) {
            decompiled = std::format("{} _{} = {}({});", ParseType(type), variable, pair->second, ParseFloat(value));
          } else {
            throw std::invalid_argument("Unknown @dx.op.unary.i32");
          }
        } else if (functionName == "@dx.op.unaryBits.i32") {
          auto [opNumber, value] = StringViewSplit<2>(functionParamsString, param_regex, 2);
          if (auto pair = UNARY_BITS_OPS.find(std::string(opNumber));
              pair != UNARY_BITS_OPS.end()) {
            if (opNumber == "33") {
              decompiled = std::format("uint _{} = {}({});", variable, pair->second, ParseFloat(value));
            } else {
              decompiled = std::format("{} _{} = {}({});", ParseType(type), variable, pair->second, ParseFloat(value));
            }
          } else {
            throw std::invalid_argument("Unknown @dx.op.unaryBits.i32");
          }
        } else if (functionName == "@dx.op.binary.f32") {
          auto [opNumber, a, b] = StringViewSplit<3>(functionParamsString, param_regex, 2);
          if (auto pair = BINARY_FLOAT_OPS.find(std::string(opNumber));
              pair != UNARY_BITS_OPS.end()) {
            decompiled = std::format("{} _{} = {}({}, {});", ParseType(type), variable, pair->second, ParseFloat(a), ParseFloat(b));
          } else {
            throw std::invalid_argument("Unknown @dx.op.binary.f32");
          }
        } else if (functionName == "@dx.op.textureLoad.f32") {
          // %dx.types.ResRet.f32 @dx.op.textureLoad.f32(i32 66, %dx.types.Handle %40, i32 0, i32 %38, i32 %39, i32 undef, i32 undef, i32 undef, i32 undef)  ; TextureLoad(srv,mipLevelOrSampleCount,coord0,coord1,coord2,offset0,offset1,offset2)
          auto [opNumber, srv, mipLevelOrSampleCount, coord0, coord1, coord2, offset0, offset1, offset2] = StringViewSplit<9>(functionParamsString, param_regex, 2);
          auto ref_resource = std::string{srv.substr(1)};
          const bool has_coord_z = coord2 != "undef";
          const bool has_offset_y = offset1 != "undef";
          const bool has_offset_z = offset2 != "undef";
          std::string coords;
          if (has_coord_z) {
            coords = std::format("int3({}, {}, {})", ParseInt(coord0), ParseInt(coord1), ParseInt(coord2));
          } else {
            coords = std::format("int2({}, {})", ParseInt(coord0), ParseInt(coord1));
          }
          std::string offset;
          if (has_offset_z) {
            offset = std::format("int3({}, {}, {})", ParseInt(offset0), ParseInt(offset1), ParseInt(offset2));
          } else if (has_coord_z) {
            offset = std::format("int2({}, {})", ParseInt(offset0), ParseInt(offset1));
          } else {
            offset = std::format("{}", ParseInt(offset0));
          }
          // skip mipLevelOrSampleCount
          auto srv_resource = preprocess_state.srv_resources[preprocess_state.resource_binding_variables.at(ref_resource).second];
          if (offset == "0" || offset == "int2(0, 0)" || offset == "int3(0, 0, 0)") {
            decompiled = std::format("float4 _{} = {}.Load({});", variable, srv_resource.name, coords);
          } else {
            decompiled = std::format("float4 _{} = {}.Load({}, {});", variable, srv_resource.name, coords, offset);
          }

        } else if (functionName == "@dx.op.sample.f32") {
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
            offset = std::format("int2({}, {})", ParseInt(offset0), ParseInt(offset1));
          } else {
            offset = std::format("{}", ParseInt(offset0));
          }
          if (has_clamp) {
            throw std::invalid_argument("Unknown clamp");
          }

          auto srv_resource = preprocess_state.srv_resources[preprocess_state.resource_binding_variables.at(ref_resource).second];
          auto sampler_resource = preprocess_state.sampler_resources[preprocess_state.resource_binding_variables.at(ref_sampler).second];
          if (offset == "0" || offset == "int2(0, 0)" || offset == "int3(0, 0, 0)") {
            decompiled = std::format("float4 _{} = {}.Sample({}, {});", variable, srv_resource.name, sampler_resource.name, coords);
          } else {
            decompiled = std::format("float4 _{} = {}.Sample({}, {}, {});", variable, srv_resource.name, sampler_resource.name, coords, offset);
          }
        } else if (functionName == "@dx.op.sampleLevel.f32") {
          auto [opNumber, srv, sampler, coord0, coord1, coord2, coord3, offset0, offset1, offset2, LOD] = StringViewSplit<11>(functionParamsString, param_regex, 2);
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
          } else if (has_coord_z) {
            offset = std::format("int2({}, {})", ParseInt(offset0), ParseInt(offset1));
          } else {
            offset = std::format("{}", ParseInt(offset0));
          }

          auto srv_resource = preprocess_state.srv_resources[preprocess_state.resource_binding_variables.at(ref_resource).second];
          auto sampler_resource = preprocess_state.sampler_resources[preprocess_state.resource_binding_variables.at(ref_sampler).second];
          if (offset == "0" || offset == "int2(0, 0)" || offset == "int3(0, 0, 0)") {
            decompiled = std::format("float4 _{} = {}.SampleLevel({}, {}, {});", variable, srv_resource.name, sampler_resource.name, coords, ParseFloat(LOD));
          } else {
            decompiled = std::format("float4 _{} = {}.SampleLevel({}, {}, {}, {});", variable, srv_resource.name, sampler_resource.name, coords, ParseFloat(LOD), offset);
          }
        } else if (functionName == "@dx.op.dot2.f32") {
          auto [opNumber, ax, ay, bx, by] = StringViewSplit<5>(functionParamsString, param_regex, 2);
          decompiled = std::format("float _{} = dot(float2({}, {}), float2({}, {}));", variable, ParseFloat(ax), ParseFloat(ay), ParseFloat(bx), ParseFloat(by));
        } else if (functionName == "@dx.op.dot3.f32") {
          auto [opNumber, ax, ay, az, bx, by, bz] = StringViewSplit<7>(functionParamsString, param_regex, 2);
          decompiled = std::format("float _{} = dot(float3({}, {}, {}), float3({}, {}, {}));", variable, ParseFloat(ax), ParseFloat(ay), ParseFloat(az), ParseFloat(bx), ParseFloat(by), ParseFloat(bz));
        } else if (functionName == "@dx.op.tertiary.f32") {
          // call float @dx.op.tertiary.f32(i32 46, float 0xBFC4A8C160000000, float %210, float %217)  ; FMad(a,b,c)
          auto [opNumber, a, b, c] = StringViewSplit<4>(functionParamsString, param_regex, 2);
          decompiled = std::format("float _{} = mad({}, {}, {});", variable, ParseFloat(a), ParseFloat(b), ParseFloat(c));
        } else if (functionName == "@dx.op.rawBufferLoad.f32") {
          auto [opNumber, srv, index, elementOffset, mask, alignment] = StringViewSplit<6>(functionParamsString, param_regex, 2);
          auto ref = std::string{srv.substr(1)};
          auto srv_resource = preprocess_state.srv_resources[preprocess_state.resource_binding_variables.at(ref).second];
          decompiled = std::format("float4 _{} = {}.Load({} + ({} / {}));", variable, srv_resource.name, ParseInt(index), ParseInt(elementOffset), ParseInt(alignment));
        } else {
          throw std::invalid_argument("Unknown function name");
        }
        // decompiled = std::format("// {} _{} = {}({})", type, variable, functionName, functionParams);
        // decompiled = "// " + std::string{comment};
      } else if (instruction == "extractvalue") {
        // extractvalue %dx.types.ResRet.f32 %448, 0
        auto [type, input, index] = StringViewMatch<3>(assignment, std::regex{R"(extractvalue (\S+) (\S+), (\S+))"});
        if (type == R"(%dx.types.CBufRet.f32)" || type == R"(%dx.types.ResRet.f32)") {
          // float4 value
          decompiled = std::format("float _{} = {}.{};", variable, ParseVariable(input), ParseIndex(index));
        } else if (type == R"(%dx.types.CBufRet.i32)" || type == R"(%dx.types.ResRet.i32)") {
          // int4 value
          decompiled = std::format("int _{} = {}.{};", variable, ParseVariable(input), ParseIndex(index));
        } else {
          throw std::invalid_argument("Unknown extractvalue type");
        }
      } else if (instruction == "fmul") {
        auto [a, b] = StringViewMatch<2>(assignment, std::regex{"fmul (?:fast )?(?:float) (\\S+), (\\S+)"});
        decompiled = std::format("float _{} = {} * {};", variable, ParseFloat(a), ParseFloat(b));
      } else if (instruction == "fdiv") {
        auto [a, b] = StringViewMatch<2>(assignment, std::regex{"fdiv (?:fast )?(?:float) (\\S+), (\\S+)"});
        decompiled = std::format("float _{} = {} / {};", variable, ParseFloat(a), ParseFloat(b));
      } else if (instruction == "fadd") {
        auto [a, b] = StringViewMatch<2>(assignment, std::regex{"fadd (?:fast )?(?:float) (\\S+), (\\S+)"});
        decompiled = std::format("float _{} = {} + {};", variable, ParseFloat(a), ParseFloat(b));
      } else if (instruction == "fsub") {
        auto [a, b] = StringViewMatch<2>(assignment, std::regex{"fsub (?:fast )?(?:float) (\\S+), (\\S+)"});
        decompiled = std::format("float _{} = {} - {};", variable, ParseFloat(a), ParseFloat(b));
      } else if (instruction == "fcmp") {
        // %39 = fcmp fast ogt float %37, 0.000000e+00
        auto [op, type, a, b] = StringViewMatch<4>(assignment, std::regex{R"(fcmp (?:fast )?(\S+) (\S+) (\S+), (\S+))"});
        decompiled = std::format("bool _{} = ({} {} {});", variable, ParseFloat(a), ParseOperator(op), ParseFloat(b));
      } else if (instruction == "icmp") {
        // %39 = fcmp fast ogt float %37, 0.000000e+00
        auto [op, type, a, b] = StringViewMatch<4>(assignment, std::regex{R"(icmp (?:fast )?(\S+) (\S+) (\S+), (\S+))"});
        decompiled = std::format("bool _{} = ({} {} {});", variable, ParseInt(a), ParseOperator(op), ParseInt(b));
      } else if (instruction == "add") {
        // add nsw i32 %1678, 1
        auto [no_unsigned_wrap, no_signed_wrap, a, b] = StringViewMatch<4>(assignment, std::regex{R"(add (nuw )?(nsw )?(?:\S+) (\S+), (\S+))"});
        if (no_signed_wrap.empty()) {
          decompiled = std::format("uint _{} = {} + {};", variable, ParseInt(a), ParseInt(b));
        } else {
          decompiled = std::format("int _{} = {} + {};", variable, ParseInt(a), ParseInt(b));
        }
      } else if (instruction == "sub") {
        // sub nsw i32 %43, %45
        auto [noSignedWrap, a, b] = StringViewMatch<3>(assignment, std::regex{R"(sub (nsw )?(?:\S+) (\S+), (\S+))"});
        if (noSignedWrap.empty()) {
          decompiled = std::format("uint _{} = {} - {};", variable, ParseInt(a), ParseInt(b));
        } else {
          decompiled = std::format("int _{} = {} - {};", variable, ParseInt(a), ParseInt(b));
        }
      } else if (instruction == "zext") {
        // %43 = zext i1 %39 to i32
        auto [a] = StringViewMatch<1>(assignment, std::regex{R"(zext (?:fast )?(?:\S+) (\S+) to (?:\S+))"});
        decompiled = std::format("int _{} = int({});", variable, ParseInt(a));
      } else if (instruction == "sitofp") {
        // sitofp i32 %47 to float
        auto [a] = StringViewMatch<1>(assignment, std::regex{R"(sitofp (?:\S+) (\S+) to (?:\S+))"});
        decompiled = std::format("float _{} = float({});", variable, ParseInt(a));
      } else if (instruction == "uitofp") {
        // uitofp i32 %158 to float
        auto [a] = StringViewMatch<1>(assignment, std::regex{R"(uitofp (?:\S+) (\S+) to (?:\S+))"});
        decompiled = std::format("float _{} = float({});", variable, ParseInt(a));
      } else if (instruction == "fptoui") {
        auto [a] = StringViewMatch<1>(assignment, std::regex{R"(fptoui (?:\S+) (\S+) to (?:\S+))"});
        decompiled = std::format("uint _{} = uint({});", variable, ParseFloat(a));
      } else if (instruction == "fptosi") {
        auto [a] = StringViewMatch<1>(assignment, std::regex{R"(fptosi (?:\S+) (\S+) to (?:\S+))"});
        decompiled = std::format("int _{} = int({});", variable, ParseFloat(a));
      } else if (instruction == "and") {
        auto [type, a, b] = StringViewMatch<3>(assignment, std::regex{R"(and (\S+) (\S+), (\S+))"});
        decompiled = std::format("{} _{} = {} & {};", ParseType(type), variable, ParseInt(a), ParseInt(b));
      } else if (instruction == "or") {
        auto [type, a, b] = StringViewMatch<3>(assignment, std::regex{R"(or (\S+) (\S+), (\S+))"});
        decompiled = std::format("{} _{} = {} | {};", ParseType(type), variable, ParseInt(a), ParseInt(b));
      } else if (instruction == "alloca") {
        // alloca [6 x float], align 4
        auto [size, type, align] = StringViewMatch<3>(assignment, std::regex{R"(alloca \[(\S+) x (\S+)\], align (\S+))"});
        decompiled = std::format("{} _{}[{}];", ParseType(type), variable, ParseInt(size));
      } else if (instruction == "select") {
        // select i1 %26, float 1.000000e+00, float 0x3FFB47E420000000
        auto [condition, type_a, value_a, type_b, value_b] = StringViewMatch<5>(assignment, std::regex{R"(select i1 (\S+), (\S+) (\S+), (\S+) (\S+))"});
        if (type_a == "float" && type_b == "float") {
          decompiled = std::format("float _{} = {} ? {} : {};", variable, ParseInt(condition), ParseFloat(value_a), ParseFloat(value_b));
        } else if (type_a == "int" && type_b == "int") {
          decompiled = std::format("int _{} = {} ? {} : {};", variable, ParseInt(condition), ParseInt(value_a), ParseInt(value_b));
        } else {
          throw std::invalid_argument("Unrecognized code assignment");
        }
      } else if (instruction == "phi") {
        // phi float [ 0x3FF61108E0000000, %0 ], [ 0x3FF069AC80000000, %21 ], [ 0x3FE6412500000000, %23 ], [ %27, %25 ]
        auto [type, arguments] = StringViewMatch<2>(assignment, std::regex{R"(phi (\S+) (.+))"});
        // Declare variable
        auto declaration_line = std::format("{} _{};", type, variable);
        this->code_blocks[0].hlsl_lines.push_back(declaration_line);

        auto pairs = StringViewSplitAll(arguments, std::regex{R"((\[ (\S+), %(\S+) \]),?)"}, {2, 3});
        for (const auto& [value, function_number] : pairs) {
          int function_int;
          FromStringView(function_number, function_int);
          auto assignment_line = std::format("_{} = {};", variable, ParseFloat(value));
          this->code_blocks[function_int].hlsl_lines.push_back(assignment_line);
        }
      } else if (instruction == "load") {
        // load float, float* %1681, align 4, !tbaa !26
        auto [source] = StringViewMatch<1>(assignment, std::regex{R"(load \S+, \S+ %(\S+),.*)"});
        decompiled = std::format("float _{} = {};", variable, stored_pointers[source]);
      } else if (instruction == "bitcast") {
        // noop
      } else if (instruction == "getelementptr") {
        auto [source, index] = StringViewMatch<2>(
            assignment,
            std::regex{R"(getelementptr (?:inbounds )?\[[^\]]+\], \[[^\]]+\]\* (\S+), i32 \S+, i32 (\S+).*)"});
        // %1369 = getelementptr inbounds [6 x float], [6 x float]* %10, i32 0, i32 0
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
      } else {
        throw std::invalid_argument("Unrecognized code assignment");
      }

      if (!decompiled.empty()) {
        this->current_code_block.hlsl_lines.push_back(decompiled);
      }
    }

    void CloseBranch() {
      this->code_blocks[this->current_code_block_number] = this->current_code_block;
      this->current_code_block_number = -1;
      this->current_code_block = {};
    }

    void AddCodeBranch(std::string_view line) {
      // br i1 <cond>, label <iftrue>, label <iffalse>
      // br label <dest>          ; Unconditional branch
      static auto conditional_branch_regex = std::regex{R"(^  br i1 (\S+), label %(\S+), label %(\S+).*)"};

      const auto [condition, if_true, if_false] = StringViewMatch<3>(line, conditional_branch_regex);
      if (!condition.empty()) {
        this->current_code_block.branch.branch_condition = ParseInt(condition);
        FromStringView(if_true, this->current_code_block.branch.branch_condition_true);
        FromStringView(if_false, this->current_code_block.branch.branch_condition_false);
      } else {
        static auto unconditional_branch_regex = std::regex{R"(^  br label %(\S+).*)"};
        const auto [unconditional] = StringViewMatch<1>(line, unconditional_branch_regex);
        FromStringView(unconditional, this->current_code_block.branch.branch_condition_true);
      }
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
      } else if (functionName == "@dx.op.storeOutput.f32") {
        // call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 0, float %2772)  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
        auto [opNumber, outputSigId, rowIndex, colIndex, value] = StringViewSplit<5>(functionParamsString, param_regex, 2);
        int output_signature_index;
        FromStringView(outputSigId, output_signature_index);
        auto signature = preprocess_state.output_signature[output_signature_index];
        if (rowIndex != "0") {
          throw std::exception("Row Index number supported.");
        }
        if (signature.packed.MaskString() == "1") {
          if (ParseIndex(colIndex) != "x") {
            throw std::exception("Unexpected index.");
          }
          decompiled = std::format("{} = {};", signature.VariableString(), ParseFloat(value));
        } else {
          decompiled = std::format("{}.{} = {};", signature.VariableString(), ParseIndex(colIndex), ParseFloat(value));
        }

      } else {
        throw std::invalid_argument("Unknown function name");
      }

      if (!decompiled.empty()) {
        this->current_code_block.hlsl_lines.push_back(decompiled);
      }
    }

    void AddCodeStore(std::string_view line) {
      // store float %1358, float* %1369, align 4, !tbaa !26, !alias.scope !30
      static auto regex = std::regex{R"(^  store \S+ ([^,]+), [^*]+\* %([A-Za-z0-9]+),?.*)"};
      auto [value, pointer] = StringViewMatch<2>(line, regex);

      std::string decompiled = std::format("{} = {};", stored_pointers[pointer], ParseFloat(value));

      this->current_code_block.hlsl_lines.push_back(decompiled);
    }

    void ParseBlockDefinition(std::string_view line) {
      // ; <label>:21                                      ; preds = %0
      static auto block_definition_regex = std::regex{R"(^; <label>:(\S+)\s+; preds = (.*))"};
      auto [line_number, predicates] = StringViewMatch<2>(line, block_definition_regex);
      FromStringView(line_number, this->current_code_block_number);
    }

    auto DecompileLines(PreprocessState& preprocess_state) {
      for (auto line : this->lines) {
        if (line.starts_with("  %")) {
          this->AddCodeAssign(line, preprocess_state);
        } else if (line.starts_with("  call ")) {
          this->AddCodeCall(line, preprocess_state);
        } else if (line.starts_with("  store ")) {
          this->AddCodeStore(line);
        } else if (line.starts_with("  ret ")) {
          //
        } else if (line.starts_with("  br ")) {
          this->AddCodeBranch(line);
        } else if (line.empty()) {
          //
        } else if (line.starts_with("; <label>:")) {
          this->ParseBlockDefinition(line);
        } else {
          std::cerr << line << "\n";
          throw std::invalid_argument("Unexpected code block");
        }
      }
      this->CloseBranch();
    }

    auto ListConvergences() {
      std::map<int, std::set<int>> convergences;

      for (const auto& [line_number, code_block] : code_blocks) {
        if (code_block.branch.branch_condition_true != -1) {
          convergences[code_block.branch.branch_condition_true].emplace(line_number);
        }
        if (code_block.branch.branch_condition_false != -1) {
          convergences[code_block.branch.branch_condition_false].emplace(line_number);
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
        if (code_block.branch.branch_condition_true != -1) {
          if (line_number >= code_block.branch.branch_condition_true) {
            recursions[code_block.branch.branch_condition_true].emplace(line_number);
          }
        }
        if (code_block.branch.branch_condition_false != -1) {
          if (line_number >= code_block.branch.branch_condition_false) {
            recursions[code_block.branch.branch_condition_false].emplace(line_number);
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
  BufferDefinition current_buffer_definition;
  std::vector<BufferDefinition> buffer_definitions;
  size_t current_buffer_definition_depth = 0;

  std::vector<CodeFunction> code_functions;
  CodeFunction current_code_function;
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
    this->pipeline_infos.clear();
    this->view_id_state_info.clear();
    this->sha256_hash = "";
    this->current_buffer_definition = {};
    this->buffer_definitions.clear();
    this->current_buffer_definition_depth = 0;
    this->code_functions.clear();
    this->current_code_function = {};
    this->output_lines.clear();
  }

 public:
  std::string Decompile(std::string_view disassembly) {
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
          case TokenizerState::DESCRIPTION_INPUT_SIG_TABLE_ROW:
            if (line == ";") {
              state = TokenizerState::DESCRIPTION_WHITESPACE;
            } else {
              input_sigs_packed.emplace_back(line);
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
            current_buffer_definition = BufferDefinition(line);
            buffer_definitions.push_back(current_buffer_definition);
            state++;
            line_number++;
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
              current_buffer_definition.definitions.push_back(line);
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
            if (line == "") {
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
            auto type_definition = TypeDefinition(line);
            preprocess_state.type_definitions[type_definition.name] = type_definition;

            line_number++;
            state = TokenizerState::WHITESPACE;
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
            static auto regex = std::regex{R"((\S+) = (?:internal )?(?:unnamed_addr )?constant \[(\S+) x ([^\]]+)\] \[([^\]]+)\])"};
            auto [variable_name, array_size, array_type, entries] = StringViewMatch<4>(line, regex);

            auto values = StringViewSplitAll(entries, std::regex{R"((\s*(\S+) (\S+)),?)"}, {2, 3});

            std::string output_name = std::format("_global_{}", preprocess_state.global_variables.size());
            std::stringstream decompiled;

            decompiled << "static const ";
            decompiled << array_type << " ";
            decompiled << output_name;
            decompiled << "[" << array_size << "] = { ";

            int array_size_number;
            FromStringView(array_size, array_size_number);
            for (int i = 0; i < array_size_number; ++i) {
              if (array_type == "float") {
                decompiled << ParseFloat(values[i].second);
              }
              if (i != array_size_number - 1) {
                decompiled << ", ";
              }
            }
            decompiled << " };";
            // std::cout << decompiled.str() << std::endl;
            preprocess_state.global_variables[std::string{variable_name}] = output_name;

            state = TokenizerState::WHITESPACE;
            line_number++;
          } break;
          case TokenizerState::CODE_DEFINE:
            current_code_function = CodeFunction(line);
            code_functions.push_back(current_code_function);
            // current_code_function.lines.push_back(line);
            line_number++;
            state++;
            break;
          case TokenizerState::CODE_BLOCK:
            if (line == "}") {
              state = TokenizerState::CODE_END;
            } else {
              current_code_function.lines.push_back(line);
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
        // std::cout << prestate << ": " << line << std::endl;
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

    // Generate output

    std::stringstream string_stream;

    // Type Definitions

    bool added_type_definition = false;
    for (const auto& [name, definition] : preprocess_state.type_definitions) {
      // Only add hostlayout to root. The rest are inline.
      static const std::string PREFIX = "%hostlayout.struct.";
      static const auto PREFIX_LENGTH = PREFIX.length();
      if (!name.starts_with(PREFIX)) continue;

      string_stream << "struct " << name.substr(PREFIX_LENGTH) << " {\n";
      for (const auto& [name, info] : definition.types) {
        string_stream << "  " << info.data_type;
        if (info.vector_size > 1) {
          string_stream << info.vector_size;
        }
        string_stream << " " << name;
        if (info.array_size > 1) {
          string_stream << "[" << info.array_size << "]";
        }
        string_stream << ";\n";
      }
      string_stream << "};\n";
      added_type_definition = true;
    }

    if (!preprocess_state.type_definitions.empty()) {
      string_stream << "\n";
    }

    // Resources

    auto resource_list_reference = named_metadata["!dx.resources"][0];
    auto resource_list_key = resource_list_reference;
    auto resource_list = named_metadata[resource_list_key];

    // SRV
    auto srv_list_key = resource_list[0];
    std::vector<std::string_view> srv_list;
    if (srv_list_key != "null") {
      srv_list = named_metadata[srv_list_key];
    }
    preprocess_state.srv_resources.reserve(srv_list.size());
    for (const auto srv_key : srv_list) {
      // srv_resources.emplace_back(named_metadata[srv_key], named_metadata);
      auto srv_resource = SRVResource(named_metadata[srv_key], named_metadata);
      string_stream << SRVResource::ResourceKindString(srv_resource.shape);
      if (srv_resource.element_type != SRVResource::ComponentType::Invalid) {
        string_stream << "<" << SRVResource::ComponentTypeString(srv_resource.element_type) << ">";
      } else {
        string_stream << "< (" << srv_resource.stride << " bytes) >";
      }

      srv_resource.UpdateNameFromDescription(preprocess_state.resource_descriptions);

      string_stream << " " << srv_resource.name;
      string_stream << " : register(t" << srv_resource.signature_index;
      if (srv_resource.space != 0u) {
        string_stream << ", space" << srv_resource.space;
      }
      string_stream << ");\n";
      preprocess_state.srv_resources.push_back(srv_resource);
    }
    if (!srv_list.empty()) {
      string_stream << "\n";
    }

    // UAV
    auto uav_list_key = resource_list[1];
    std::vector<std::string_view> uav_list;
    if (uav_list_key != "null") {
      uav_list = named_metadata[uav_list_key];
    }
    preprocess_state.uav_resources.reserve(uav_list.size());
    for (const auto uav_key : uav_list) {
      // uav_resources.emplace_back(named_metadata[uav_key], named_metadata);
      auto uav_resource = UAVResource(named_metadata[uav_key], named_metadata);
      string_stream << UAVResource::ResourceKindString(uav_resource.shape);
      if (uav_resource.element_type != SRVResource::ComponentType::Invalid) {
        string_stream << "<" << SRVResource::ComponentTypeString(uav_resource.element_type) << ">";
      } else {
        string_stream << "< (" << uav_resource.stride << " bytes) >";
      }

      uav_resource.UpdateNameFromDescription(preprocess_state.resource_descriptions);

      string_stream << " " << uav_resource.name;
      string_stream << " : register(u" << uav_resource.signature_index;
      if (uav_resource.space != 0u) {
        string_stream << ", space" << uav_resource.space;
      }
      string_stream << ");\n";
      preprocess_state.uav_resources.push_back(uav_resource);
    }
    if (!uav_list.empty()) {
      string_stream << "\n";
    }

    // CBV
    auto cbv_list_key = resource_list[2];
    std::vector<std::string_view> cbv_list;
    if (cbv_list_key != "null") {
      cbv_list = named_metadata[cbv_list_key];
    }
    preprocess_state.cbv_resources.reserve(cbv_list.size());
    for (const auto cbv_key : cbv_list) {
      // cbv_resources.emplace_back(named_metadata[cbv_key], named_metadata);
      auto cbv_resource = CBVResource(named_metadata[cbv_key], named_metadata);
      cbv_resource.UpdateNameFromDescription(preprocess_state.resource_descriptions);

      string_stream << "cbuffer _" << cbv_resource.name;
      string_stream << " : register(b" << cbv_resource.signature_index;
      if (cbv_resource.space != 0u) {
        string_stream << ", space" << cbv_resource.space;
      }
      string_stream << ") {\n";

#if 0
      auto type_name = cbv_resource.pointer.substr(0, cbv_resource.pointer.length() - 1);
      auto definition = preprocess_state.type_definitions[type_name];
      string_stream << "  struct " << definition.name.substr(1) << " {\n";
      for (const auto& [name, info] : definition.types) {
        auto size = preprocess_state.GetTypeSize(std::string(info.data_type));
        string_stream << "    " << info.data_type;
        if (info.vector_size > 1) {
          string_stream << info.vector_size;
          size *= info.vector_size;
        }
        string_stream << " " << name;
        if (info.array_size > 1) {
          string_stream << "[" << info.array_size << "]";
          size *= info.array_size;
        }
        string_stream << ";";
        string_stream << "  // " << size;
        string_stream << "\n";
      }
      string_stream << "  } " << cbv_resource.name << " : packoffset(c0);\n";
#else
      string_stream << "  float4 " << cbv_resource.name;
      string_stream << "[" << ceil(static_cast<float>(cbv_resource.buffer_size) / 16.f) << "] : packoffset(c0);\n";
#endif

      string_stream << "};\n";
      preprocess_state.cbv_resources.push_back(cbv_resource);
    }

    if (!cbv_list.empty()) {
      string_stream << "\n";
    }

    // sampler
    auto sampler_list_key = resource_list[3];
    std::vector<std::string_view> sampler_list;
    if (sampler_list_key != "null") {
      sampler_list = named_metadata[sampler_list_key];
    }
    preprocess_state.sampler_resources.reserve(sampler_list.size());
    for (const auto& sampler_key : sampler_list) {
      // sampler_resources.emplace_back(named_metadata[sampler_key], named_metadata);
      auto sampler_resource = SamplerResource(named_metadata[sampler_key], named_metadata);
      sampler_resource.UpdateNameFromDescription(preprocess_state.resource_descriptions);

      string_stream << "SamplerState " << sampler_resource.name;
      string_stream << " : register(s" << sampler_resource.signature_index;
      if (sampler_resource.space != 0u) {
        string_stream << ", space" << sampler_resource.space;
      }
      string_stream << ");\n";
      preprocess_state.sampler_resources.push_back(sampler_resource);
    }

    if (!sampler_list.empty()) {
      string_stream << "\n";
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
    int line_spacing = 2;
    std::vector<int> pending_convergences = {};
    std::vector<std::set<int>> pending_recursions = {};
    std::vector<int> current_loops = {};
    current_code_function.DecompileLines(preprocess_state);

    auto convergences = current_code_function.ListConvergences();
    auto recursions = current_code_function.ListRecursions();

#if DECOMPILE_DEBUG
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
      std::string spacing;
      spacing.insert(0, line_spacing, ' ');
      std::set<int> recursion_pops;
      if (!pending_recursions.empty()) {
        recursion_pops = pending_recursions.rbegin()[0];
      }
      if (recursion_pops.contains(line_number)) {
        string_stream << spacing << "continue;\n";  // go back
        return;
      }

      bool using_recursion = recursions.contains(line_number);
      if (using_recursion) {
        pending_recursions.push_back(recursions[line_number]);
        current_loops.push_back(line_number);
        string_stream << spacing << "while(true) {\n";
        line_spacing += 2;
        spacing.insert(0, 2, ' ');
        // break at these
      }

      auto close_if_recursive = [&]() {
        if (using_recursion) {
          string_stream << spacing << "break;\n";
          line_spacing -= 2;
          spacing = "";
          spacing.insert(0, line_spacing, ' ');
          string_stream << spacing << "}\n";
          pending_recursions.pop_back();
        }
      };

      auto& code_block = current_code_function.code_blocks[line_number];
      for (const auto& hlsl_line : code_block.hlsl_lines) {
        string_stream << spacing << hlsl_line << "\n";
      }

      if (code_block.branch.branch_condition_true <= 0) return;

      int next_convergence = pending_convergences.empty() ? -1 : pending_convergences.rbegin()[0];

      if (code_block.branch.branch_condition.empty()) {
        if (next_convergence == code_block.branch.branch_condition_true) return;
        append_code_block(code_block.branch.branch_condition_true);
        close_if_recursive();
        return;
      }

      if (code_block.branch.branch_condition_false <= line_number
          && code_block.branch.branch_condition_true <= line_number) {
        throw std::exception("Unsupported loop detected.");
      }

      if (code_block.branch.branch_condition_true == next_convergence) {
        string_stream << spacing << "if (!" << code_block.branch.branch_condition << ") {\n";
        line_spacing += 2;
        append_code_block(code_block.branch.branch_condition_false);
        line_spacing -= 2;
        string_stream << spacing << "}\n";
        close_if_recursive();
        return;
      }

      if (code_block.branch.branch_condition_false == next_convergence) {
        string_stream << spacing << "if (" << code_block.branch.branch_condition << ") {\n";
        line_spacing += 2;
        append_code_block(code_block.branch.branch_condition_true);
        line_spacing -= 2;
        string_stream << spacing << "}\n";
        close_if_recursive();
        return;
      }

      // Find next convergence for these two items
      int pair_convergence = -1;
      for (auto& [convergence_line_number, callers] : convergences) {
        if (
            (convergence_line_number == code_block.branch.branch_condition_true || callers.contains(code_block.branch.branch_condition_true))
            && (convergence_line_number == code_block.branch.branch_condition_false || callers.contains(code_block.branch.branch_condition_false))) {
          if (convergence_line_number == next_convergence) break;
          pair_convergence = convergence_line_number;
          pending_convergences.push_back(pair_convergence);
          break;
        }
      }

      if (pair_convergence == code_block.branch.branch_condition_true) {
        string_stream << spacing << "if (!" << code_block.branch.branch_condition << ") {\n";
        line_spacing += 2;
        append_code_block(code_block.branch.branch_condition_false);
        line_spacing -= 2;
        string_stream << spacing << "}\n";
        // Only print else
      } else if (pair_convergence == code_block.branch.branch_condition_false) {
        string_stream << spacing << "if (" << code_block.branch.branch_condition << ") {\n";
        line_spacing += 2;
        append_code_block(code_block.branch.branch_condition_true);
        line_spacing -= 2;
        string_stream << spacing << "}\n";
      } else if (code_block.branch.branch_condition_true < code_block.branch.branch_condition_false) {
        string_stream << spacing << "if (" << code_block.branch.branch_condition << ") {\n";
        line_spacing += 2;
        append_code_block(code_block.branch.branch_condition_true);
        line_spacing -= 2;
        string_stream << spacing << "} else { \n";
        line_spacing += 2;
        append_code_block(code_block.branch.branch_condition_false);
        line_spacing -= 2;
        string_stream << spacing << "}\n";
      } else {
        string_stream << spacing << "if (!" << code_block.branch.branch_condition << ") {\n";
        line_spacing += 2;
        append_code_block(code_block.branch.branch_condition_false);
        line_spacing -= 2;
        string_stream << spacing << "} else { \n";
        line_spacing += 2;
        append_code_block(code_block.branch.branch_condition_true);
        line_spacing -= 2;
        string_stream << spacing << "}\n";
      }

      if (pair_convergence != -1) {
        pending_convergences.pop_back();
        append_code_block(pair_convergence);
      };
      close_if_recursive();
    };

    auto output_signature_count = preprocess_state.output_signature.size();

    if (output_signature_count > 1) {
      string_stream << "struct OutputSignature {\n";
      for (const auto& signature : preprocess_state.output_signature) {
        string_stream << "  " << signature.ToString() << ";\n";
      }
      string_stream << "};\n";
      string_stream << "\n";
      string_stream << "OutputSignature";
    } else {
      string_stream << preprocess_state.output_signature[0].FullFormatString();
    }

    string_stream << " main(\n";
    {
      auto len = preprocess_state.input_signature.size();
      for (int i = 0; i < len; ++i) {
        auto& signature = preprocess_state.input_signature[i];
        string_stream << "  " << signature.ToString();
        if (i != len - 1) {
          string_stream << ",";
        }
        string_stream << "\n";
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

    append_code_block(0);

    if (output_signature_count == 1) {
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

    return string_stream.str();
  }
};  // namespace Decompiler

}  // namespace renodx::utils::shader::decompiler::dxc
