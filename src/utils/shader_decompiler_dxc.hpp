/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <array>
#include <cassert>
#include <charconv>
#include <cstdlib>
#include <format>
#include <functional>
#include <iostream>
#include <iterator>
#include <map>
#include <ostream>
#include <print>
#include <regex>
#include <set>
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
  CODE_ASSIGN,
  CODE_CALL,
  CODE_STORE,
  CODE_RETURN,
  CODE_BRANCH,
  CODE_BRANCH_START,
  CODE_BRANCH_BLOCK,
  CODE_END,
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
    case TokenizerState::CODE_ASSIGN:                                    return os << "code_assign";
    case TokenizerState::CODE_CALL:                                      return os << "code_call";
    case TokenizerState::CODE_STORE:                                     return os << "code_store";
    case TokenizerState::CODE_RETURN:                                    return os << "code_return";
    case TokenizerState::CODE_BRANCH:                                    return os << "code_branch";
    case TokenizerState::CODE_BRANCH_START:                              return os << "code_branch_start";
    case TokenizerState::CODE_BRANCH_BLOCK:                              return os << "code_branch_block";
    case TokenizerState::CODE_END:                                       return os << "code_end";
    case TokenizerState::COMPLETE:                                       return os << "complete";
    case TokenizerState::FUNCTION_DECLARE:                               return os << "function_declare";
    case TokenizerState::FUNCTION_DESCRIPTION:                           return os << "function_description";
    case TokenizerState::FUNCTION_ATTRIBUTES:                            return os << "function_attributes";
    case TokenizerState::GLOBAL_VARIABLE:                                return os << "global_variable";
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
    TEXCOOR_D10_CENTROID,
    TEXCOOR_D11_CENTROID
  };

  static std::string ParseIndex(std::string_view input) {
    if (input == "0") return "x";
    if (input == "1") return "y";
    if (input == "2") return "z";
    if (input == "3") return "w";
    throw std::invalid_argument("Could not parse index");
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
      std::from_chars(input.data(), input.data() + input.size(), value);
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
      {"21", "exp"},
      {"22", "frac"},
      {"23", "log"},
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
    if (input == "TEXCOORD10_centroid") return SignatureName::TEXCOOR_D10_CENTROID;
    if (input == "TEXCOORD11_centroid") return SignatureName::TEXCOOR_D11_CENTROID;
    throw std::invalid_argument("Unknown signature name");
  }

  struct Signature1 {
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

    std::string ToString() const {
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

    explicit Signature1(std::string_view line) {
      /**
       * @example
       * ; TEXCOORD                 0   xy          0     NONE   float   xy
       * ; SV_Position              0   xyzw        1      POS   float
       * ; SV_RenderTargetArrayIndex     0   x           2  RTINDEX    uint   x
       */

      static auto regex = std::regex{R"(; (\S+)\s+(\S+)\s+((?:x| )(?:y| )(?:z| )(?:w| ))\s+(\S+)\s+(\S+)\s+(\S+)\s*([xyzw ]*))"};
      auto [name, index, mask, dxregister, sysValue, format, used] = StringViewMatch<7>(line, regex);

      this->name = SignatureNameFromString(name);
      std::from_chars(index.data(), index.data() + index.size(), this->index);
      this->mask = FlagsFromCoordinates(mask);
      std::from_chars(dxregister.data(), dxregister.data() + dxregister.size(), this->dxregister);
      this->sys_value = SysValueFromString(sysValue);
      this->format = FormatFromString(format);
      this->used = FlagsFromCoordinates(used);
    }
  };

  struct Signature2 {
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
      std::from_chars(input.data(), input.data() + input.size(), value);
      return value;
    }

    explicit Signature2(std::string_view line) {
      /**
       * @example
       * ; SV_Position              0          noperspective
       * ; SV_Position              0                          9
       * ; SV_Target                0
       */
      static auto regex = std::regex{R"(; (\S+)\s+(\S+)(?:$|(?:(.{23})\s*(\S+)?)))"};
      auto [name, index, interpMode, dynIndex] = StringViewMatch<4>(line, regex);

      this->name = SignatureNameFromString(name);
      std::from_chars(index.data(), index.data() + index.size(), this->index);
      this->interp_mode = InterpModeFromString(StringViewTrim(interpMode));
      this->dyn_index = DynIndexFromString(StringViewTrim(dynIndex));
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

  struct ResourceBinding {
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
      DIMENSION2_D,
      DIMENSION3_D,
      BUFFER,
      READ_ONLY,
    } dimensions;

    std::string_view id;

    std::string_view hlsl_binding;

    uint32_t count;

    ResourceBinding() = default;

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
      if (input == "2d") return ResourceDimensions::DIMENSION2_D;
      if (input == "3d") return ResourceDimensions::DIMENSION3_D;
      if (input == "buffer") return ResourceDimensions::BUFFER;
      if (input == "r/o") return ResourceDimensions::READ_ONLY;
      throw std::invalid_argument("Unknown ResourceDimensions");
    }

    explicit ResourceBinding(std::string_view line) {
      // ; _31_33                            cbuffer      NA          NA     CB0            cb0     1
      static auto regex = std::regex{R"(; (.{30})\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s*)"};
      auto [name, type, format, dimensions, id, hlslBinding, count] = StringViewMatch<7>(line, regex);
      this->name = StringViewTrim(name);
      this->type = ResourceTypeFromString(type);
      this->format = ResourceFormatFromString(format);
      this->dimensions = ResourceDimensionsFromString(dimensions);
      this->id = id;
      this->hlsl_binding = hlslBinding;
      std::from_chars(count.data(), count.data() + count.size(), this->count);
    }
  };

  struct TypeDefinition {
    std::string_view name;
    std::vector<std::string_view> types;

    TypeDefinition() = default;

    explicit TypeDefinition(std::string_view line) {
      // %"class.Texture3D<vector<float, 4> >" = type { <4 x float>, %"class.Texture3D<vector<float, 4> >::mips_type" }
      static auto regex = std::regex{R"(^(%(?:(?:"[^"]+")|\S+)) = type \{([^}]+)\}$)"};

      auto [name, types] = StringViewMatch<2>(line, regex);

      this->name = name;

      static auto type_split = std::regex(R"( ((?:[^%][^},]+)|(?:%"[^"]+"))(?:,| ))");
      this->types = StringViewSplitAll(types, type_split, 1);
    }
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

    void AddCodeAssign(std::string_view line, std::map<std::string, std::string>& resource_bindings) {
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
        if (functionName == "@dx.op.createHandleFromBinding") {
          auto [opNumber, bind, index, nonUniformIndex] = StringViewSplit<4>(functionParamsString, param_regex, 2);
          std::string bind_start = "0";
          std::string bind_end = "0";
          std::string space = "0";
          std::string resource_type = "0";
          if (bind != "zeroinitializer") {
            auto inner_params = StringViewSplit<4>(bind.substr(1, bind.size() - 2), param_regex, 2);
            bind_start = ParseInt(inner_params[0]);
            bind_end = ParseInt(inner_params[1]);
            space = ParseInt(inner_params[2]);
            resource_type = inner_params[3];
          }

          if (resource_type == "0") {
            decompiled = std::format("// texture _{} = t{};", variable, ParseInt(index));
            resource_bindings[std::string(variable)] = std::format("t{}", ParseInt(index));
          } else if (resource_type == "2") {
            decompiled = std::format("// cbuffer _{} = cb{};", variable, ParseInt(index));
            resource_bindings[std::string(variable)] = std::format("cb{}", ParseInt(index));
          } else if (resource_type == "3") {
            decompiled = std::format("// SamplerState _{} = s{};", variable, ParseInt(index));
            resource_bindings[std::string(variable)] = std::format("s{}", ParseInt(index));
          } else {
            throw std::invalid_argument("Unknown resource type");
          }
        } else if (functionName == "@dx.op.annotateHandle") {
          auto [opNumber, res, props] = StringViewSplit<3>(functionParamsString, param_regex, 2);
          auto ref = std::string{res.substr(1)};
          resource_bindings[std::string(variable)] = resource_bindings.at(ref);
          decompiled = std::format("// _{} = _{};", variable, ref);
        } else if (functionName == "@dx.op.loadInput.f32") {
          //   @dx.op.loadInput.f32(i32 4, i32 3, i32 0, i8 0, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
          auto [opNumber, inputSigId, rowIndex, colIndex, gsVertexAxis] = StringViewSplit<5>(functionParamsString, param_regex, 2);
          decompiled = std::format("float _{} = arg{}.{};", variable, inputSigId, ParseIndex(colIndex));
        } else if (functionName == "@dx.op.loadInput.i32") {
          //   @dx.op.loadInput.i32(i32 4, i32 2, i32 0, i8 0, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
          auto [opNumber, inputSigId, rowIndex, colIndex, gsVertexAxis] = StringViewSplit<5>(functionParamsString, param_regex, 2);
          decompiled = std::format("uint _{} = arg{}.{};", variable, inputSigId, ParseIndex(colIndex));
        } else if (functionName == "@dx.op.cbufferLoadLegacy.f32") {
          auto [opNumber, handle, regIndex] = StringViewSplit<3>(functionParamsString, param_regex, 2);
          auto ref = std::string{handle.substr(1)};
          decompiled = std::format("float4 _{} = {}[{}u];", variable, resource_bindings.at(ref), ParseInt(regIndex));
        } else if (functionName == "@dx.op.cbufferLoadLegacy.i32") {
          auto [opNumber, handle, regIndex] = StringViewSplit<3>(functionParamsString, param_regex, 2);
          auto ref = std::string{handle.substr(1)};
          decompiled = std::format("int4 _{} = {}[{}u];", variable, resource_bindings.at(ref), ParseInt(regIndex));
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
          if (offset == "0" || offset == "int2(0, 0)" || offset == "int3(0, 0, 0)") {
            decompiled = std::format("float4 _{} = {}.Sample({}, {});", variable, resource_bindings.at(ref_resource), resource_bindings.at(ref_sampler), coords);
          } else {
            decompiled = std::format("float4 _{} = {}.Sample({}, {}, {});", variable, resource_bindings.at(ref_resource), resource_bindings.at(ref_sampler), coords, offset);
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
          if (offset == "0" || offset == "int2(0, 0)" || offset == "int3(0, 0, 0)") {
            decompiled = std::format("float4 _{} = {}.SampleLevel({}, {}, {});", variable, resource_bindings.at(ref_resource), resource_bindings.at(ref_sampler), coords, ParseFloat(LOD));
          } else {
            decompiled = std::format("float4 _{} = {}.SampleLevel({}, {}, {}, {});", variable, resource_bindings.at(ref_resource), resource_bindings.at(ref_sampler), coords, ParseFloat(LOD), offset);
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
          decompiled = std::format("float _{} = {} * {} + {};", variable, ParseFloat(a), ParseFloat(b), ParseFloat(c));
        } else if (functionName == "@dx.op.rawBufferLoad.f32") {
          auto [opNumber, srv, index, elementOffset, mask, alignment] = StringViewSplit<6>(functionParamsString, param_regex, 2);
          auto ref = std::string{srv.substr(1)};
          decompiled = std::format("float4 _{} = {}.Load({} + ({} / {}));", variable, resource_bindings.at(ref), ParseInt(index), ParseInt(elementOffset), ParseInt(alignment));
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
          // float4 value
          decompiled = std::format("int4 _{} = {}.{};", variable, ParseVariable(input), ParseIndex(index));
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
        auto [noSignedWrap, a, b] = StringViewMatch<3>(assignment, std::regex{R"(add (nsw )?(?:\S+) (\S+), (\S+))"});
        if (noSignedWrap.empty()) {
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
          std::from_chars(function_number.data(), function_number.data() + function_number.size(), function_int);
          auto assignment_line = std::format("_{} = {};", variable, ParseFloat(value));
          this->code_blocks[function_int].hlsl_lines.push_back(assignment_line);
        }
      } else if (instruction == "load") {
        // load float, float* %1681, align 4, !tbaa !26
        auto [source] = StringViewMatch<1>(assignment, std::regex{R"(load \S+, \S+ %(\S+),.*)"});
        decompiled = std::format("_{} = {};", variable, stored_pointers[source]);
      } else if (instruction == "bitcast") {
        // noop
      } else if (instruction == "getelementptr") {
        auto [source, index] = StringViewMatch<2>(
            assignment,
            std::regex{R"(getelementptr inbounds \[[^\]]+\], \[[^\]]+\]\* %(\S+), i32 \S+, i32 (\S+))"});
        // %1369 = getelementptr inbounds [6 x float], [6 x float]* %10, i32 0, i32 0
        const auto pointer_value = std::format("_{}[{}]", source, ParseInt(index));
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
        std::from_chars(if_true.data(), if_true.data() + if_true.size(), this->current_code_block.branch.branch_condition_true);
        std::from_chars(if_false.data(), if_false.data() + if_false.size(), this->current_code_block.branch.branch_condition_false);
      } else {
        static auto unconditional_branch_regex = std::regex{R"(^  br label %(\S+).*)"};
        const auto [unconditional] = StringViewMatch<1>(line, unconditional_branch_regex);
        std::from_chars(unconditional.data(), unconditional.data() + unconditional.size(), this->current_code_block.branch.branch_condition_true);
      }
      this->CloseBranch();
    }

    void AddCodeCall(std::string_view line) {
      static auto regex = std::regex{R"(^  call (\S+) ([^(]+)\(([^)]+)\).*)"};
      static auto param_regex = std::regex(R"(\s*(\S+) ((?:\d+)|(?:\{[^}]+\})|(?:%\d+)|(?:\S+))(?:(?:, )|(?:\s*$)))");
      auto [type, functionName, functionParamsString] = StringViewMatch<3>(line, regex);
      std::string decompiled;
      // auto paramMatches = string_view_split_all(functionParamsString, paramRegex, {1, 2});
      if (functionName == "@llvm.lifetime.start") {
      } else if (functionName == "@llvm.lifetime.end") {
      } else if (functionName == "@dx.op.storeOutput.f32") {
        // call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 0, float %2772)  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
        auto [opNumber, sv_target_index, unknown, index, source] = StringViewSplit<5>(functionParamsString, param_regex, 2);
        decompiled = std::format("SV_TARGET_{}.{} = {};", sv_target_index, ParseIndex(index), ParseFloat(source));
      } else {
        throw std::invalid_argument("Unknown function name");
      }

      if (!decompiled.empty()) {
        this->current_code_block.hlsl_lines.push_back(decompiled);
      }
    }

    void AddCodeStore(std::string_view line) {
      // store float %1358, float* %1369, align 4, !tbaa !26, !alias.scope !30
      static auto regex = std::regex{R"(^  store \S+ ([%A-Za-z0-9]+), [%A-Za-z0-9]+\* %([A-Za-z0-9]+),?.*)"};
      auto [value, pointer] = StringViewMatch<2>(line, regex);

      std::string decompiled = std::format("{} = {};", stored_pointers[pointer], ParseFloat(value));

      this->current_code_block.hlsl_lines.push_back(decompiled);
    }

    void ParseBlockDefinition(std::string_view line) {
      // ; <label>:21                                      ; preds = %0
      static auto block_definition_regex = std::regex{R"(^; <label>:(\S+)\s+; preds = (.*))"};
      auto [line_number, predicates] = StringViewMatch<2>(line, block_definition_regex);
      std::from_chars(line_number.data(), line_number.data() + line_number.size(), this->current_code_block_number);
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
  };

  std::map<std::string, std::string> resource_bindings;
  std::vector<std::string_view> lines;
  size_t line_number = 0;
  TokenizerState state = TokenizerState::START;
  size_t input_sig_section_count = 0;
  size_t output_sig_section_count = 0;
  std::vector<Signature1> input_sigs1;
  std::vector<Signature1> output_sigs1;
  std::vector<Signature2> input_sigs2;
  std::vector<Signature2> output_sigs2;
  std::vector<std::string_view> pipeline_infos;
  std::vector<std::string_view> view_id_state_info;
  std::string_view sha256_hash;
  BufferDefinition current_buffer_definition;
  std::vector<BufferDefinition> buffer_definitions;
  size_t current_buffer_definition_depth = 0;
  std::vector<TypeDefinition> type_definitions;
  std::vector<CodeFunction> code_functions;
  CodeFunction current_code_function;

  void Init() {
    this->line_number = 0;
    this->state = TokenizerState::START;
    this->input_sig_section_count = 0;
    this->output_sig_section_count = 0;
    this->input_sigs1.clear();
    this->output_sigs1.clear();
    this->input_sigs2.clear();
    this->output_sigs2.clear();
    this->resource_bindings.clear();
    this->pipeline_infos.clear();
    this->view_id_state_info.clear();
    this->sha256_hash = "";
    this->current_buffer_definition = {};
    this->buffer_definitions.clear();
    this->current_buffer_definition_depth = 0;
    this->type_definitions.clear();
    this->code_functions.clear();
    this->current_code_function = {};
  }

 public:
  std::string Decompile(std::string_view disassembly) {
    Init();
    this->lines = StringViewSplitAll(disassembly, '\n');

    const std::string_view line;
    while (state != TokenizerState::COMPLETE) {
      std::string_view line = StringViewTrimEnd(lines.at(line_number));
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
              input_sigs1.emplace_back(line);
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
              output_sigs1.emplace_back(line);
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
              input_sigs2.emplace_back(line);
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
              output_sigs2.emplace_back(line);
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
              // resource_bindings.push_back(ResourceBinding(line));
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
            } else if (line.starts_with("!")) {
              state = TokenizerState::GLOBAL_VARIABLE;
            } else {
              throw std::invalid_argument("Unexpected line");
            }
            break;
          case TokenizerState::TYPE_DEFINITION:
            if (line == "" || line[0] != '%') {
              state = TokenizerState::WHITESPACE;
            }
            type_definitions.emplace_back(line);
            line_number++;
            break;
          case TokenizerState::FUNCTION_DESCRIPTION:
          case TokenizerState::FUNCTION_DECLARE:
          case TokenizerState::FUNCTION_ATTRIBUTES:
          case TokenizerState::GLOBAL_VARIABLE:
            line_number++;
            state = TokenizerState::WHITESPACE;
            break;
          case TokenizerState::CODE_DEFINE:
            current_code_function = CodeFunction(line);
            code_functions.push_back(current_code_function);
            current_code_function.lines.push_back(line);
            line_number++;
            state++;
            break;
          case TokenizerState::CODE_BLOCK:
            current_code_function.lines.push_back(line);
            if (line == "}") {
              state = TokenizerState::CODE_END;
            } else if (line.starts_with("  %")) {
              state = TokenizerState::CODE_ASSIGN;
            } else if (line.starts_with("  call ")) {
              state = TokenizerState::CODE_CALL;
            } else if (line.starts_with("  store ")) {
              state = TokenizerState::CODE_STORE;
            } else if (line.starts_with("  ret ")) {
              state = TokenizerState::CODE_RETURN;
            } else if (line.starts_with("  br ")) {
              state = TokenizerState::CODE_BRANCH;
            } else if (line.empty()) {
              state = TokenizerState::CODE_BLOCK;
              line_number++;
            } else if (line.starts_with("; <label>:")) {
              state = TokenizerState::CODE_BRANCH_START;
            } else {
              throw std::invalid_argument("Unexpected code block");
            }
            break;
          case TokenizerState::CODE_ASSIGN:
            current_code_function.AddCodeAssign(line, resource_bindings);
            state = TokenizerState::CODE_BLOCK;
            line_number++;
            break;
          case TokenizerState::CODE_CALL:
            current_code_function.AddCodeCall(line);
            state = TokenizerState::CODE_BLOCK;
            line_number++;
            break;
          case TokenizerState::CODE_STORE:
            current_code_function.AddCodeStore(line);
            state = TokenizerState::CODE_BLOCK;
            line_number++;
            break;
          case TokenizerState::CODE_RETURN:
            line_number++;
            state = TokenizerState::CODE_BLOCK;
            break;
          case TokenizerState::CODE_BRANCH:
            current_code_function.AddCodeBranch(line);
            state = TokenizerState::CODE_BLOCK;
            line_number++;
            break;
          case TokenizerState::CODE_BRANCH_START:
            current_code_function.ParseBlockDefinition(line);
            state = TokenizerState::CODE_BLOCK;
            line_number++;
            break;
          case TokenizerState::CODE_BRANCH_BLOCK:
            break;
          case TokenizerState::CODE_END:
            current_code_function.CloseBranch();
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
      if (line_number == lines.size()) {
        state = TokenizerState::COMPLETE;
      }
    }

    std::stringstream string_stream;
    int line_spacing = 2;
    std::vector<int> pending_convergences = {};
    auto convergences = current_code_function.ListConvergences();
    std::function<void(int line_number)> append_code_block = [&](int line_number) {
      std::string spacing;
      spacing.insert(0, line_spacing, ' ');

      auto& code_block = current_code_function.code_blocks[line_number];
      for (const auto& hlsl_line : code_block.hlsl_lines) {
        string_stream << spacing << hlsl_line << "\r\n";
      }

      if (code_block.branch.branch_condition_true <= 0) return;

      int next_convergence = pending_convergences.empty() ? -1 : pending_convergences.rbegin()[0];

      if (code_block.branch.branch_condition.empty()) {
        if (next_convergence == code_block.branch.branch_condition_true) return;
        append_code_block(code_block.branch.branch_condition_true);
        return;
      }

      if (code_block.branch.branch_condition_true == next_convergence) {
        string_stream << spacing << "if (!" << code_block.branch.branch_condition << ") {\r\n";
        line_spacing += 2;
        append_code_block(code_block.branch.branch_condition_false);
        line_spacing -= 2;
        string_stream << spacing << "}\r\n";
        return;
      }

      if (code_block.branch.branch_condition_false == next_convergence) {
        string_stream << spacing << "if (" << code_block.branch.branch_condition << ") {\r\n";
        line_spacing += 2;
        append_code_block(code_block.branch.branch_condition_true);
        line_spacing -= 2;
        string_stream << spacing << "}\r\n";
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
        string_stream << spacing << "if (!" << code_block.branch.branch_condition << ") {\r\n";
        line_spacing += 2;
        append_code_block(code_block.branch.branch_condition_false);
        line_spacing -= 2;
        string_stream << spacing << "}\r\n";
        // Only print else
      } else if (pair_convergence == code_block.branch.branch_condition_false) {
        string_stream << spacing << "if (" << code_block.branch.branch_condition << ") {\r\n";
        line_spacing += 2;
        append_code_block(code_block.branch.branch_condition_true);
        line_spacing -= 2;
        string_stream << spacing << "}\r\n";
      } else if (code_block.branch.branch_condition_true < code_block.branch.branch_condition_false) {
        string_stream << spacing << "if (" << code_block.branch.branch_condition << ") {\r\n";
        line_spacing += 2;
        append_code_block(code_block.branch.branch_condition_true);
        line_spacing -= 2;
        string_stream << spacing << "} else { \r\n";
        line_spacing += 2;
        append_code_block(code_block.branch.branch_condition_false);
        line_spacing -= 2;
        string_stream << spacing << "}\r\n";
      } else {
        string_stream << spacing << "if (!" << code_block.branch.branch_condition << ") {\r\n";
        line_spacing += 2;
        append_code_block(code_block.branch.branch_condition_false);
        line_spacing -= 2;
        string_stream << spacing << "} else { \r\n";
        line_spacing += 2;
        append_code_block(code_block.branch.branch_condition_true);
        line_spacing -= 2;
        string_stream << spacing << "}\r\n";
      }

      if (pair_convergence != -1) {
        pending_convergences.pop_back();
        append_code_block(pair_convergence);
      };
    };

    string_stream << "function main() {\r\n";

    append_code_block(0);
    string_stream << "}\r\n";

    return string_stream.str();
  }

};  // namespace Decompiler

}  // namespace renodx::utils::shader::decompiler::dxc
