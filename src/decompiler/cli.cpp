#include <stdio.h>
#include <stdlib.h>

#include <array>
#include <bitset>
#include <cassert>
#include <charconv>
#include <format>
#include <fstream>
#include <iostream>
#include <map>
#include <ostream>
#include <print>
#include <regex>
#include <sstream>
#include <stdexcept>
#include <string>
#include <vector>

#include "./dxdecomp.hpp"

enum class decompiler_state : uint32_t {
  start,
  description_whitespace,
  description_input_sig_title,
  description_input_sig_whitespace,
  description_input_sig_table_header,
  description_input_sig_table_divider,
  description_input_sig_table_row,
  description_input_sig_table_end,
  description_output_sig_title,
  description_output_sig_whitespace,
  description_output_sig_table_header,
  description_output_sig_table_divider,
  description_output_sig_table_row,
  description_output_sig_table_end,
  description_shader_hash,
  description_pipeline_runtime_title,
  description_pipeline_runtime_whitespace,
  description_pipeline_runtime_info,
  description_pipeline_runtime_end,
  description_input_sig2_title,
  description_input_sig2_whitespace,
  description_input_sig2_table_header,
  description_input_sig2_table_divider,
  description_input_sig2_table_row,
  description_input_sig2_table_end,
  description_output_sig2_title,
  description_output_sig2_whitespace,
  description_output_sig2_table_header,
  description_output_sig2_table_divider,
  description_output_sig2_table_row,
  description_output_sig2_table_end,
  description_buffer_definition_title,
  description_buffer_definition_whitespace,
  description_buffer_definition_type,
  description_buffer_definition_type_block_start,
  description_buffer_definition_type_block,
  description_buffer_definition_type_block_end,
  description_buffer_definition_type_end,
  description_buffer_definition_type_complete,
  description_resource_bindings_title,
  description_resource_bindings_whitespace,
  description_resource_bindings_table_header,
  description_resource_bindings_table_divider,
  description_resource_bindings_table_row,
  description_resource_bindings_table_end,
  description_view_id_state_title,
  description_view_id_state_whitespace,
  description_view_id_state_info,
  description_view_id_state_end,
  whitespace,
  target_datalayout,
  target_triple,
  type_definition,
  code_define,
  code_block,
  code_assign,
  code_call,
  code_store,
  code_return,
  code_branch,
  code_branch_start,
  code_branch_block,
  code_end,
  complete
};

std::ostream &operator<<(std::ostream &os, const decompiler_state &state) {
  switch (state) {
    case decompiler_state::start:                                          return os << "start";
    case decompiler_state::description_whitespace:                         return os << "description_whitespace";
    case decompiler_state::description_input_sig_title:                    return os << "description_input_sig_title";
    case decompiler_state::description_input_sig_whitespace:               return os << "description_input_sig_whitespace";
    case decompiler_state::description_input_sig_table_header:             return os << "description_input_sig_table_header";
    case decompiler_state::description_input_sig_table_divider:            return os << "description_input_sig_table_divider";
    case decompiler_state::description_input_sig_table_row:                return os << "description_input_sig_table_row";
    case decompiler_state::description_input_sig_table_end:                return os << "description_input_sig_table_end";
    case decompiler_state::description_output_sig_title:                   return os << "description_output_sig_title";
    case decompiler_state::description_output_sig_whitespace:              return os << "description_output_sig_whitespace";
    case decompiler_state::description_output_sig_table_header:            return os << "description_output_sig_table_header";
    case decompiler_state::description_output_sig_table_divider:           return os << "description_output_sig_table_divider";
    case decompiler_state::description_output_sig_table_row:               return os << "description_output_sig_table_row";
    case decompiler_state::description_output_sig_table_end:               return os << "description_output_sig_table_end";
    case decompiler_state::description_shader_hash:                        return os << "description_shader_hash";
    case decompiler_state::description_pipeline_runtime_title:             return os << "description_pipeline_runtime_title";
    case decompiler_state::description_pipeline_runtime_whitespace:        return os << "description_pipeline_runtime_whitespace";
    case decompiler_state::description_pipeline_runtime_info:              return os << "description_pipeline_runtime_info";
    case decompiler_state::description_pipeline_runtime_end:               return os << "description_pipeline_runtime_end";
    case decompiler_state::description_input_sig2_title:                   return os << "description_input_sig2_title";
    case decompiler_state::description_input_sig2_whitespace:              return os << "description_input_sig2_whitespace";
    case decompiler_state::description_input_sig2_table_header:            return os << "description_input_sig2_table_header";
    case decompiler_state::description_input_sig2_table_divider:           return os << "description_input_sig2_table_divider";
    case decompiler_state::description_input_sig2_table_row:               return os << "description_input_sig2_table_row";
    case decompiler_state::description_input_sig2_table_end:               return os << "description_input_sig2_table_end";
    case decompiler_state::description_output_sig2_title:                  return os << "description_output_sig2_title";
    case decompiler_state::description_output_sig2_whitespace:             return os << "description_output_sig2_whitespace";
    case decompiler_state::description_output_sig2_table_header:           return os << "description_output_sig2_table_header";
    case decompiler_state::description_output_sig2_table_divider:          return os << "description_output_sig2_table_divider";
    case decompiler_state::description_output_sig2_table_row:              return os << "description_output_sig2_table_row";
    case decompiler_state::description_output_sig2_table_end:              return os << "description_output_sig2_table_end";
    case decompiler_state::description_buffer_definition_title:            return os << "description_buffer_definition_title";
    case decompiler_state::description_buffer_definition_whitespace:       return os << "description_buffer_definition_whitespace";
    case decompiler_state::description_buffer_definition_type:             return os << "description_buffer_definition_type";
    case decompiler_state::description_buffer_definition_type_block_start: return os << "description_buffer_definition_type_block_start";
    case decompiler_state::description_buffer_definition_type_block:       return os << "description_buffer_definition_type_block";
    case decompiler_state::description_buffer_definition_type_block_end:   return os << "description_buffer_definition_type_block_end";
    case decompiler_state::description_buffer_definition_type_end:         return os << "description_buffer_definition_type_end";
    case decompiler_state::description_buffer_definition_type_complete:    return os << "description_buffer_definition_type_complete";
    case decompiler_state::description_resource_bindings_title:            return os << "description_resource_bindings_title";
    case decompiler_state::description_resource_bindings_whitespace:       return os << "description_resource_bindings_whitespace";
    case decompiler_state::description_resource_bindings_table_header:     return os << "description_resource_bindings_table_header";
    case decompiler_state::description_resource_bindings_table_divider:    return os << "description_resource_bindings_table_divider";
    case decompiler_state::description_resource_bindings_table_row:        return os << "description_resource_bindings_table_row";
    case decompiler_state::description_resource_bindings_table_end:        return os << "description_resource_bindings_table_end";
    case decompiler_state::description_view_id_state_title:                return os << "description_view_id_state_title";
    case decompiler_state::description_view_id_state_whitespace:           return os << "description_view_id_state_whitespace";
    case decompiler_state::description_view_id_state_info:                 return os << "description_view_id_state_info";
    case decompiler_state::description_view_id_state_end:                  return os << "description_view_id_state_end";
    case decompiler_state::whitespace:                                     return os << "whitespace";
    case decompiler_state::target_datalayout:                              return os << "target_datalayout";
    case decompiler_state::target_triple:                                  return os << "target_triple";
    case decompiler_state::type_definition:                                return os << "type_definition";
    case decompiler_state::code_define:                                    return os << "code_define";
    case decompiler_state::code_block:                                     return os << "code_block";
    case decompiler_state::code_assign:                                    return os << "code_assign";
    case decompiler_state::code_call:                                      return os << "code_call";
    case decompiler_state::code_store:                                     return os << "code_store";
    case decompiler_state::code_return:                                    return os << "code_return";
    case decompiler_state::code_branch:                                    return os << "code_branch";
    case decompiler_state::code_branch_start:                              return os << "code_branch_start";
    case decompiler_state::code_branch_block:                              return os << "code_branch_block";
    case decompiler_state::code_end:                                       return os << "code_end";
    case decompiler_state::complete:                                       return os << "complete";
    default:                                                               return os << "unknown";
  }
}

decompiler_state &operator++(decompiler_state &state) {
  state = static_cast<decompiler_state>(static_cast<uint32_t>(state) + 1);
  return state;
}

decompiler_state &operator++(decompiler_state &state, int) {
  state = static_cast<decompiler_state>(static_cast<uint32_t>(state) + 1);
  return state;
}

std::string_view string_view_from_csub_match(const std::csub_match &match) {
  return std::string_view{match.first, match.second};
}

std::vector<std::string_view> string_view_match_all(const std::string_view &input, const std::regex &regex) {
  std::cmatch matches;
  std::regex_match(input.data(), input.data() + input.size(), matches, regex);
  if (matches.size() == 0) return {};
  std::vector<std::string_view> results(matches.size() - 1);

  for (size_t i = 1; i < matches.size(); ++i) {
    results[i - 1] = string_view_from_csub_match(matches[i]);
  }
  return results;
}

template <size_t N>
std::array<std::string_view, N> string_view_match(const std::string_view &input, const std::regex &regex) {
  std::array<std::string_view, N> results;

  std::cmatch matches;
  std::regex_match(input.data(), input.data() + input.size(), matches, regex);
  if (matches.size() == 0) return {};
  for (size_t i = 1; i < matches.size(); ++i) {
    results[i - 1] = string_view_from_csub_match(matches[i]);
  }
  return results;
}

std::vector<std::pair<std::string_view, std::string_view>> string_view_split_all(const std::string_view &input, const std::regex &separator, const std::vector<int> &submatches) {
  std::cregex_token_iterator iter(input.data(), input.data() + input.size(), separator, submatches);
  std::cregex_token_iterator end;
  std::vector<std::pair<std::string_view, std::string_view>> results = {};
  while (iter != end) {
    auto first = string_view_from_csub_match(*iter++);
    auto second = string_view_from_csub_match(*iter++);
    results.push_back({first, second});
  }

  return results;
}

template <size_t N1, size_t N2>
std::array<std::array<std::string_view, N2>, N1> string_view_split(const std::string_view &input, const std::regex &separator, const std::array<int, N2> &submatches) {
  std::vector<int> submatchesv = {submatches.data(), submatches.data() + N2};
  std::cregex_token_iterator iter(input.data(), input.data() + input.size(), separator, submatchesv);
  std::cregex_token_iterator end;
  std::array<std::array<std::string_view, N2>, N1> results;
  size_t count = 0;
  while (iter != end) {
    std::array<std::string_view, N2> record;
    for (size_t i = 0; i < N2; ++i) {
      record[i] = string_view_from_csub_match(*iter++);
    }
    results[count++] = record;
  }

  return results;
}

template <size_t N>
std::array<std::string_view, N> string_view_split(const std::string_view &input, const std::regex &separator, uint32_t submatch = -1) {
  std::cregex_token_iterator iter(input.data(), input.data() + input.size(), separator, submatch);
  std::cregex_token_iterator end;
  std::array<std::string_view, N> results;
  size_t count = 0;
  while (iter != end) {
    results[count++] = string_view_from_csub_match(*iter++);
  }

  return results;
}

std::vector<std::string_view> string_view_split_all(const std::string_view &input, const std::regex &separator, uint32_t submatch = -1) {
  std::cregex_token_iterator iter(input.data(), input.data() + input.size(), separator, submatch);
  std::cregex_token_iterator end;
  std::vector<std::string_view> results = {};
  while (iter != end) {
    results.push_back(string_view_from_csub_match(*iter));
    ++iter;
  }
  return results;
}

std::vector<std::string_view> string_view_split_all(const std::string_view &input, const char separator) {
  std::vector<std::string_view> results;

  std::string_view::size_type pos = 0;
  std::string_view::size_type prev = 0;
  while ((pos = input.find(separator, prev)) != std::string_view::npos) {
    results.push_back(std::string_view{input.data() + prev, input.data() + pos});
    prev = pos + 1;
  }
  results.push_back(std::string_view{input.data() + prev, input.data() + input.size()});

  return results;
}

std::string_view string_view_trim_start(const std::string_view &input) {
  auto pos = input.find_first_not_of("\t\n\v\f\r ");
  if (pos == std::string_view::npos) return input;
  return std::string_view{input.data() + pos, input.data() + input.size()};
}

std::string_view string_view_trim_end(const std::string_view &input) {
  auto pos = input.find_last_not_of("\t\n\v\f\r ");
  if (pos == std::string_view::npos) return input;
  return std::string_view{input.data(), input.data() + pos + 1};
}

std::string_view string_view_trim(std::string_view input) {
  return string_view_trim_start(string_view_trim_end(input));
}

enum class SignatureName : uint32_t {
  PRIMITIVE_ID,
  SV_Position,
  SV_RenderTargetArrayIndex,
  SV_Target,
  TEXCOORD,
  TEXCOORD10_centroid,
  TEXCOORD11_centroid
};

SignatureName signatureNameFromString(std::string_view input) {
  if (input == "PRIMITIVE_ID") return SignatureName::PRIMITIVE_ID;
  if (input == "SV_Position") return SignatureName::SV_Position;
  if (input == "SV_RenderTargetArrayIndex") return SignatureName::SV_RenderTargetArrayIndex;
  if (input == "SV_Target") return SignatureName::SV_Target;
  if (input == "TEXCOORD") return SignatureName::TEXCOORD;
  if (input == "TEXCOORD10_centroid") return SignatureName::TEXCOORD10_centroid;
  if (input == "TEXCOORD11_centroid") return SignatureName::TEXCOORD11_centroid;
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
  } sysValue;

  enum class Format {
    FLOAT,
    UINT
  } format;

  uint32_t used;

  std::string to_string() {
    std::stringstream s;
    s << "name: " << (uint32_t)this->name;
    s << ", index: " << this->index;
    s << ", mask: " << this->mask;
    s << ", register: " << this->dxregister;
    s << ", sysValue: " << (uint32_t)this->sysValue;
    s << ", format: " << (uint32_t)this->format;
    s << ", used: " << this->used;
    return s.str();
  }

  static const uint32_t flagsFromCoordinates(std::string_view input) {
    uint32_t flags = 0;
    size_t len = input.length();

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

  static const SysValue sysValueFromString(std::string_view input) {
    if (input == "NONE") return SysValue::NONE;
    if (input == "POS") return SysValue::POS;
    if (input == "RTINDEX") return SysValue::RTINDEX;
    if (input == "TARGET") return SysValue::TARGET;
    throw std::invalid_argument("Unknown SysValue");
  }

  static const Format formatFromString(std::string_view input) {
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

    static auto regex = std::regex{R"/(; (\S+)\s+(\S+)\s+((?:x| )(?:y| )(?:z| )(?:w| ))\s+(\S+)\s+(\S+)\s+(\S+)\s*([xyzw ]*))/"};
    auto [name, index, mask, dxregister, sysValue, format, used] = string_view_match<7>(line, regex);

    this->name = signatureNameFromString(name);
    std::from_chars(index.data(), index.data() + index.size(), this->index);
    this->mask = flagsFromCoordinates(mask);
    std::from_chars(dxregister.data(), dxregister.data() + dxregister.size(), this->dxregister);
    this->sysValue = sysValueFromString(sysValue);
    this->format = formatFromString(format);
    this->used = flagsFromCoordinates(used);
  }
};

struct Signature2 {
  SignatureName name;

  uint32_t index;

  enum class InterpMode : uint32_t {
    none,
    noperspective,
    linear,
  } interpMode;

  int32_t dynIndex = -1;

  std::string to_string() {
    std::stringstream s;
    s << "name: " << (uint32_t)this->name;
    s << ", index: " << this->index;
    s << ", interpMode: " << (uint32_t)this->interpMode;
    s << ", dynIndex: " << this->dynIndex;
    return s.str();
  }

  static const InterpMode interpModeFromString(std::string_view input) {
    if (input == "") return InterpMode::none;
    if (input == "noperspective") return InterpMode::noperspective;
    if (input == "linear") return InterpMode::linear;
    throw std::invalid_argument("Unknown InterpMode");
  }

  static const int32_t dynIndexFromString(std::string_view input) {
    if (input == "") return -1;
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
    static auto regex = std::regex{R"/(; (\S+)\s+(\S+)(?:$|(?:(.{23})\s*(\S+)?)))/"};
    auto [name, index, interpMode, dynIndex] = string_view_match<4>(line, regex);

    this->name = signatureNameFromString(name);
    std::from_chars(index.data(), index.data() + index.size(), this->index);
    this->interpMode = interpModeFromString(string_view_trim(interpMode));
    this->dynIndex = dynIndexFromString(string_view_trim(dynIndex));
  }
};

struct BufferDefinition {
  /* Size in bytes */
  uint32_t size;
  std::string_view name = "";

  enum class BufferType {
    cbuffer,
    resource
  } bufferType;

  std::vector<std::string_view> definitions;

  BufferDefinition() {}

  static const BufferType bufferTypeFromString(std::string_view input) {
    if (input == "cbuffer") return BufferType::cbuffer;
    if (input == "Resource bind info for") return BufferType::resource;
    throw std::invalid_argument("Unknown BufferType");
  }

  explicit BufferDefinition(std::string_view line) {
    static auto regex = std::regex{R"/(; ((?:cbuffer)|(?:Resource bind info for))(\w*))/"};
    auto [bufferType, name] = string_view_match<2>(line, regex);
    this->bufferType = bufferTypeFromString(bufferType);
    this->name = name;
  }
};

struct ResourceBinding {
  std::string_view name;

  enum class ResourceType {
    cbuffer,
    sampler,
    texture,
    UAV
  } type;

  enum class ResourceFormat {
    NA,
    f32,
    i32,
    structure,
  } format;

  enum class ResourceDimensions {
    NA,
    Dimension2D,
    Dimension3D,
    Buffer,
    ReadOnly,
  } dimensions;

  std::string_view ID;

  std::string_view hlslBinding;

  uint32_t count;

  ResourceBinding() {}

  static const ResourceType resourceTypeFromString(std::string_view input) {
    if (input == "cbuffer") return ResourceType::cbuffer;
    if (input == "sampler") return ResourceType::sampler;
    if (input == "texture") return ResourceType::texture;
    if (input == "UAV") return ResourceType::UAV;
    throw std::invalid_argument("Unknown ResourceType");
  }

  static const ResourceFormat resourceFormatFromString(std::string_view input) {
    if (input == "NA") return ResourceFormat::NA;
    if (input == "f32") return ResourceFormat::f32;
    if (input == "i32") return ResourceFormat::i32;
    if (input == "struct") return ResourceFormat::structure;
    throw std::invalid_argument("Unknown ResourceFormat");
  }

  static const ResourceDimensions resourceDimensionsFromString(std::string_view input) {
    if (input == "NA") return ResourceDimensions::NA;
    if (input == "2d") return ResourceDimensions::Dimension2D;
    if (input == "3d") return ResourceDimensions::Dimension3D;
    if (input == "buffer") return ResourceDimensions::Buffer;
    if (input == "r/o") return ResourceDimensions::ReadOnly;
    throw std::invalid_argument("Unknown ResourceDimensions");
  }

  explicit ResourceBinding(std::string_view line) {
    // ; _31_33                            cbuffer      NA          NA     CB0            cb0     1
    static auto regex = std::regex{R"/(; (.{30})\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s*)/"};
    auto [name, type, format, dimensions, id, hlslBinding, count] = string_view_match<7>(line, regex);
    this->name = string_view_trim(name);
    this->type = resourceTypeFromString(type);
    this->format = resourceFormatFromString(format);
    this->dimensions = resourceDimensionsFromString(dimensions);
    this->ID = id;
    this->hlslBinding = hlslBinding;
    std::from_chars(count.data(), count.data() + count.size(), this->count);
  }
};

struct TypeDefinition {
  std::string_view name;
  std::vector<std::string_view> types;

  TypeDefinition() {}

  explicit TypeDefinition(std::string_view line) {
    // %"class.Texture3D<vector<float, 4> >" = type { <4 x float>, %"class.Texture3D<vector<float, 4> >::mips_type" }
    static auto regex = std::regex{R"/(^(%(?:(?:"[^"]+")|\S+)) = type \{([^}]+)\}$)/"};

    auto [name, types] = string_view_match<2>(line, regex);

    this->name = name;

    static auto type_split = std::regex(R"/( ((?:[^%][^},]+)|(?:%"[^"]+"))(?:,| ))/");
    this->types = string_view_split_all(types, type_split, 1);
  }
};

std::map<std::string, std::string> resourceBindings = {};

struct CodeAssign {
  std::string_view variable;
  std::string_view assignment;
  std::string_view comment;

  std::string_view instruction;
  std::string decompiled;

  // https://github.com/microsoft/DirectXShaderCompiler/blob/main/docs/DXIL.rst
  // https://github.com/microsoft/DirectXShaderCompiler/blob/main/utils/hct/hctdb_test.py
  // https://github.com/microsoft/DirectXShaderCompiler/blob/main/lib/DXIL/DxilOperations.cpp
  // https://github.com/microsoft/DirectXShaderCompiler/blob/main/include/dxc/DXIL/DxilConstants.h

  static inline const std::map<std::string, std::string> unaryFloatOps = {
    { "6",        "abs"},
    { "7",   "saturate"},
    { "8",      "isnan"},
    { "9",      "isinf"},
    {"10",   "isfinite"},
 // {"11",   "isNormal"},
    {"12",        "cos"},
    {"13",        "sin"},
    {"14",        "tan"},
    {"15",       "acos"},
    {"16",       "asin"},
    {"17",       "atan"},
    {"18",       "cosh"},
    {"19",       "sinh"},
    {"20",       "tanh"},
    {"21",        "exp"},
    {"22",       "frac"},
    {"23",        "log"},
    {"24",       "sqrt"},
    {"25",      "rsqrt"},
    {"26",      "round"},
    {"27",      "floor"},
    {"28",       "ceil"},
    {"29",      "trunc"},
    {"83", "ddx_course"},
    {"84", "ddy_course"},
    {"85",   "ddx_fine"},
    {"86",   "ddy_fine"},
  };

  static inline const std::map<std::string, std::string> unaryInt32Ops = {
    {"30", "reversebits"},
  };

  static inline const std::map<std::string, std::string> unaryBitsOps = {
    {"31",    "countbits"},
    {"32",  "firstbitlow"},
    {"33", "firstbithigh"}, // uint
    {"34", "firstbithigh"}, // int
  };

  static inline const std::map<std::string, std::string> binaryFloatOps = {
    {"35", "max"},
    {"36", "min"},
  };

  CodeAssign(){};

  static const std::string parseIndex(std::string_view input) {
    if (input == "0") return "x";
    if (input == "1") return "y";
    if (input == "2") return "z";
    if (input == "3") return "w";
    throw std::invalid_argument("Could not parse index");
  }

  static const std::string parseInt(std::string_view input) {
    if (input.at(0) == '%') {
      return std::format("_{}", input.substr(1));
    } else {
      return std::format("{}", input);
    }
  }

  static const std::string parseVariable(std::string_view input) {
    if (input.at(0) == '%') {
      return std::format("_{}", input.substr(1));
    }
    throw std::invalid_argument("Could not parse variable");
  }

  static const std::string parseFloat(std::string_view input) {
    if (input.at(0) == '%') {
      return std::format("_{}", input.substr(1));
    }
    std::string output;
    double_t value;
    if (input.starts_with("0x")) {
      std::string string = std::string{input};
      auto unsignedLong = strtoull(string.c_str(), nullptr, 16);
      uint64_t asUint64 = unsignedLong;
      memcpy(&value, &asUint64, sizeof value);
    } else {
      std::from_chars(input.data(), input.data() + input.size(), value);
    }
    output = std::format("{}", value);
    if (output.find(".") == std::string::npos) {
      output += ".f";
    } else {
      output += "f";
    }
    return output;
  }

  static const std::string parseType(std::string_view input) {
    if (input == "float") return "float";
    if (input == "i32") return "int";
    throw std::invalid_argument("Could not parse code assignment type");
  }

  static const std::string parseOperator(std::string_view input) {
    if (input == "ogt") return ">";
    if (input == "olt") return "<";
    if (input == "eq") return "==";
    throw std::invalid_argument("Could not parse code assignment operator");
  }

  explicit CodeAssign(std::string_view line) {
    static auto codeAssignRegex = std::regex{R"/(^  %(\d+) = ([^;\r\n]+)(?:; ([^\r\n]+))?$)/"};

    auto results = string_view_match<3>(line, codeAssignRegex);
    if (results.size() < 3) {
      throw std::invalid_argument("Could not parse code assignment");
    }
    auto [variable, assignment, comment] = results;
    this->variable = variable;
    this->assignment = assignment;
    this->comment = comment;

    // std::cout << "parsing: " << this->assignment << std::endl;
    this->instruction = string_view_split_all(this->assignment, ' ').at(0);
    if (this->instruction == "call") {
      static auto regex = std::regex{R"/(call (\S+) ([^(]+)\(([^)]+)\)\s*)/"};
      static auto paramRegex = std::regex(R"/(\s*(\S+) ((?:\d+)|(?:\{[^}]+\})|(?:%\d+)|(?:\S+))(?:(?:, )|(?:\s*$)))/");
      auto [type, functionName, functionParamsString] = string_view_match<3>(this->assignment, regex);
      // auto paramMatches = string_view_split_all(functionParamsString, paramRegex, {1, 2});
      if (functionName == "@dx.op.createHandleFromBinding") {
        auto [opNumber, bind, index, nonUniformIndex] = string_view_split<4>(functionParamsString, paramRegex, 2);
        std::string bindStart = "0";
        std::string bindEnd = "0";
        std::string space = "0";
        std::string resourceType = "0";
        if (bind != "zeroinitializer") {
          auto innerParams = string_view_split<4>(bind.substr(1, bind.size() - 2), paramRegex, 2);
          bindStart = parseInt(innerParams[0]);
          bindEnd = parseInt(innerParams[1]);
          space = parseInt(innerParams[2]);
          resourceType = innerParams[3];
        }

        if (resourceType == "0") {
          this->decompiled = std::format("// texture _{} = t{};", this->variable, parseInt(index));
          resourceBindings[std::string(this->variable)] = std::format("t{}", parseInt(index));
        } else if (resourceType == "2") {
          this->decompiled = std::format("// cbuffer _{} = cb{};", this->variable, parseInt(index));
          resourceBindings[std::string(this->variable)] = std::format("cb{}", parseInt(index));
        } else if (resourceType == "3") {
          this->decompiled = std::format("// SamplerState _{} = s{};", this->variable, parseInt(index));
          resourceBindings[std::string(this->variable)] = std::format("s{}", parseInt(index));
        } else {
          throw std::invalid_argument("Unknown resource type");
        }
      } else if (functionName == "@dx.op.annotateHandle") {
        auto [opNumber, res, props] = string_view_split<3>(functionParamsString, paramRegex, 2);
        auto ref = std::string{res.substr(1)};
        resourceBindings[std::string(this->variable)] = resourceBindings.at(ref);
        this->decompiled = std::format("// _{} = _{};", this->variable, ref);
      } else if (functionName == "@dx.op.loadInput.f32") {
        //   @dx.op.loadInput.f32(i32 4, i32 3, i32 0, i8 0, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
        auto [opNumber, inputSigId, rowIndex, colIndex, gsVertexAxis] = string_view_split<5>(functionParamsString, paramRegex, 2);
        this->decompiled = std::format("float _{} = arg{}.{};", this->variable, inputSigId, parseIndex(colIndex));
      } else if (functionName == "@dx.op.cbufferLoadLegacy.f32") {
        auto [opNumber, handle, regIndex] = string_view_split<3>(functionParamsString, paramRegex, 2);
        auto ref = std::string{handle.substr(1)};
        this->decompiled = std::format("float4 _{} = {}[{}u];", this->variable, resourceBindings.at(ref), parseInt(regIndex));
      } else if (functionName == "@dx.op.cbufferLoadLegacy.i32") {
        auto [opNumber, handle, regIndex] = string_view_split<3>(functionParamsString, paramRegex, 2);
        auto ref = std::string{handle.substr(1)};
        this->decompiled = std::format("int4 _{} = {}[{}u];", this->variable, resourceBindings.at(ref), parseInt(regIndex));
      } else if (functionName == "@dx.op.unary.f32") {
        auto [opNumber, value] = string_view_split<2>(functionParamsString, paramRegex, 2);
        if (auto pair = unaryFloatOps.find(std::string(opNumber));
            pair != unaryFloatOps.end()) {
          this->decompiled = std::format("{} _{} = {}({});", parseType(type), this->variable, pair->second, parseFloat(value));
        } else {
          throw std::invalid_argument("Unknown @dx.op.unary.f32");
        }
      } else if (functionName == "@dx.op.unary.i32") {
        auto [opNumber, value] = string_view_split<2>(functionParamsString, paramRegex, 2);
        if (auto pair = unaryInt32Ops.find(std::string(opNumber));
            pair != unaryInt32Ops.end()) {
          this->decompiled = std::format("{} _{} = {}({});", parseType(type), this->variable, pair->second, parseFloat(value));
        } else {
          throw std::invalid_argument("Unknown @dx.op.unary.i32");
        }
      } else if (functionName == "@dx.op.unaryBits.i32") {
        auto [opNumber, value] = string_view_split<2>(functionParamsString, paramRegex, 2);
        if (auto pair = unaryBitsOps.find(std::string(opNumber));
            pair != unaryBitsOps.end()) {
          if (opNumber == "33") {
            this->decompiled = std::format("uint _{} = {}({});", this->variable, pair->second, parseFloat(value));
          } else {
            this->decompiled = std::format("{} _{} = {}({});", parseType(type), this->variable, pair->second, parseFloat(value));
          }
        } else {
          throw std::invalid_argument("Unknown @dx.op.unaryBits.i32");
        }
      } else if (functionName == "@dx.op.binary.f32") {
        auto [opNumber, a, b] = string_view_split<3>(functionParamsString, paramRegex, 2);
        if (auto pair = binaryFloatOps.find(std::string(opNumber));
            pair != unaryBitsOps.end()) {
          this->decompiled = std::format("{} _{} = {}({}, {});", parseType(type), this->variable, pair->second, parseFloat(a), parseFloat(b));
        } else {
          throw std::invalid_argument("Unknown @dx.op.binary.f32");
        }
      } else if (functionName == "@dx.op.sample.f32") {
        auto [opNumber, srv, sampler, coord0, coord1, coord2, coord3, offset0, offset1, offset2, clamp] = string_view_split<11>(functionParamsString, paramRegex, 2);
        auto refResource = std::string{srv.substr(1)};
        auto refSampler = std::string{sampler.substr(1)};

        bool hasCoordZ = coord2 != "undef";
        bool hasCoordW = coord3 != "undef";
        bool hasOffsetY = offset1 != "undef";
        bool hasOffsetZ = offset2 != "undef";
        bool hasClamp = clamp != "undef";
        std::string coords;
        if (hasCoordW) {
          coords = std::format("float4({}, {}, {}, {})", parseFloat(coord0), parseFloat(coord1), parseFloat(coord2), parseFloat(coord3));
        } else if (hasCoordZ) {
          coords = std::format("float3({}, {}, {})", parseFloat(coord0), parseFloat(coord1), parseFloat(coord2));
        } else {
          coords = std::format("float2({}, {})", parseFloat(coord0), parseFloat(coord1));
        }
        std::string offset;
        if (hasOffsetZ) {
          offset = std::format("int3({}, {}, {})", parseInt(offset0), parseInt(offset1), parseInt(offset2));
        } else if (hasCoordZ) {
          offset = std::format("int2({}, {})", parseInt(offset0), parseInt(offset1));
        } else {
          offset = std::format("{}", parseInt(offset0));
        }
        if (hasClamp) {
          throw std::invalid_argument("Unknown clamp");
        } else if (offset == "0" || offset == "int2(0, 0)" || offset == "int3(0, 0, 0)") {
          this->decompiled = std::format("float4 _{} = {}.Sample({}, {});", this->variable, resourceBindings.at(refResource), resourceBindings.at(refSampler), coords);
        } else {
          this->decompiled = std::format("float4 _{} = {}.Sample({}, {}, {});", this->variable, resourceBindings.at(refResource), resourceBindings.at(refSampler), coords, offset);
        }
      } else if (functionName == "@dx.op.sampleLevel.f32") {
        auto [opNumber, srv, sampler, coord0, coord1, coord2, coord3, offset0, offset1, offset2, LOD] = string_view_split<11>(functionParamsString, paramRegex, 2);
        auto refResource = std::string{srv.substr(1)};
        auto refSampler = std::string{sampler.substr(1)};

        bool hasCoordZ = coord2 != "undef";
        bool hasCoordW = coord3 != "undef";
        bool hasOffsetY = offset1 != "undef";
        bool hasOffsetZ = offset2 != "undef";
        std::string coords;
        if (hasCoordW) {
          coords = std::format("float4({}, {}, {}, {})", parseFloat(coord0), parseFloat(coord1), parseFloat(coord2), parseFloat(coord3));
        } else if (hasCoordZ) {
          coords = std::format("float3({}, {}, {})", parseFloat(coord0), parseFloat(coord1), parseFloat(coord2));
        } else {
          coords = std::format("float2({}, {})", parseFloat(coord0), parseFloat(coord1));
        }
        std::string offset;
        if (hasOffsetZ) {
          offset = std::format("int3({}, {}, {})", parseInt(offset0), parseInt(offset1), parseInt(offset2));
        } else if (hasCoordZ) {
          offset = std::format("int2({}, {})", parseInt(offset0), parseInt(offset1));
        } else {
          offset = std::format("{}", parseInt(offset0));
        }
        if (offset == "0" || offset == "int2(0, 0)" || offset == "int3(0, 0, 0)") {
          this->decompiled = std::format("float4 _{} = {}.SampleLevel({}, {}, {});", this->variable, resourceBindings.at(refResource), resourceBindings.at(refSampler), coords, parseFloat(LOD));
        } else {
          this->decompiled = std::format("float4 _{} = {}.SampleLevel({}, {}, {}, {});", this->variable, resourceBindings.at(refResource), resourceBindings.at(refSampler), coords, parseFloat(LOD), offset);
        }
      } else if (functionName == "@dx.op.dot2.f32") {
        auto [opNumber, ax, ay, bx, by] = string_view_split<5>(functionParamsString, paramRegex, 2);
        this->decompiled = std::format("float _{} = dot(float2({}, {}), float2({}, {});", this->variable, parseFloat(ax), parseFloat(ay), parseFloat(bx), parseFloat(by));
      } else if (functionName == "@dx.op.dot3.f32") {
        auto [opNumber, ax, ay, az, bx, by, bz] = string_view_split<7>(functionParamsString, paramRegex, 2);
        this->decompiled = std::format("float _{} = dot(float3({}, {}, {}), float3({}, {}, {});", this->variable, parseFloat(ax), parseFloat(ay), parseFloat(az), parseFloat(bx), parseFloat(by), parseFloat(bz));
      } else if (functionName == "@dx.op.rawBufferLoad.f32") {
        auto [opNumber, srv, index, elementOffset, mask, alignment] = string_view_split<6>(functionParamsString, paramRegex, 2);
        auto ref = std::string{srv.substr(1)};
        this->decompiled = std::format("float4 _{} = {}.Load({} + ({} / {}));", this->variable, resourceBindings.at(ref), parseInt(index), parseInt(elementOffset), parseInt(alignment));
      } else {
        throw std::invalid_argument("Unknown function name");
      }

      // this->decompiled = std::format("// {} _{} = {}({})", type, this->variable, functionName, functionParams);
      // this->decompiled = "// " + std::string{this->comment};
    } else if (this->instruction == "extractvalue") {
      // extractvalue %dx.types.ResRet.f32 %448, 0
      auto [type, input, index] = string_view_match<3>(this->assignment, std::regex{"extractvalue (\\S+) (\\S+), (\\S+)"});
      if (type == R"(%dx.types.CBufRet.f32)" || type == R"(%dx.types.ResRet.f32)") {
        // float4 value
        this->decompiled = std::format("float _{} = {}.{};", this->variable, parseVariable(input), parseIndex(index));
      } else if (type == R"(%dx.types.CBufRet.i32)" || type == R"(%dx.types.ResRet.i32)") {
        // float4 value
        this->decompiled = std::format("int4 _{} = {}.{};", this->variable, parseVariable(input), parseIndex(index));
      } else {
        throw std::invalid_argument("Unknown extractvalue type");
      }
    } else if (this->instruction == "fmul") {
      auto [a, b] = string_view_match<2>(this->assignment, std::regex{"fmul (?:fast )?(?:float) (\\S+), (\\S+)"});
      this->decompiled = std::format("float _{} = {} * {};", this->variable, parseFloat(a), parseFloat(b));
    } else if (this->instruction == "fdiv") {
      auto [a, b] = string_view_match<2>(this->assignment, std::regex{"fdiv (?:fast )?(?:float) (\\S+), (\\S+)"});
      this->decompiled = std::format("float _{} = {} / {};", this->variable, parseFloat(a), parseFloat(b));
    } else if (this->instruction == "fadd") {
      auto [a, b] = string_view_match<2>(this->assignment, std::regex{"fadd (?:fast )?(?:float) (\\S+), (\\S+)"});
      this->decompiled = std::format("float _{} = {} + {};", this->variable, parseFloat(a), parseFloat(b));
    } else if (this->instruction == "fsub") {
      auto [a, b] = string_view_match<2>(this->assignment, std::regex{"fsub (?:fast )?(?:float) (\\S+), (\\S+)"});
      this->decompiled = std::format("float _{} = {} - {};", this->variable, parseFloat(a), parseFloat(b));
    } else if (this->instruction == "fcmp") {
      // %39 = fcmp fast ogt float %37, 0.000000e+00
      auto [op, type, a, b] = string_view_match<4>(this->assignment, std::regex{"fcmp (?:fast )?(\\S+) (\\S+) (\\S+), (\\S+)"});
      this->decompiled = std::format("{} _{} = ({} {} {});", parseType(type), this->variable, parseFloat(a), parseOperator(op), parseFloat(b));
    } else if (this->instruction == "icmp") {
      // %39 = fcmp fast ogt float %37, 0.000000e+00
      auto [op, type, a, b] = string_view_match<4>(this->assignment, std::regex{"icmp (?:fast )?(\\S+) (\\S+) (\\S+), (\\S+)"});
      this->decompiled = std::format("{} _{} = ({} {} {});", parseType(type), this->variable, parseInt(a), parseOperator(op), parseInt(b));
    } else if (this->instruction == "sub") {
      // sub nsw i32 %43, %45
      auto [noSignedWrap, a, b] = string_view_match<3>(this->assignment, std::regex{"sub (nsw )?(?:\\S+) (\\S+), (\\S+)"});
      if (noSignedWrap.length() != 0) {
        this->decompiled = std::format("int _{} = {} - {};", this->variable, parseInt(a), parseInt(b));
      } else {
        this->decompiled = std::format("uint _{} = {} - {};", this->variable, parseInt(a), parseInt(b));
      }
    } else if (this->instruction == "zext") {
      // %43 = zext i1 %39 to i32
      auto [a] = string_view_match<1>(this->assignment, std::regex{"zext (?:fast )?(?:\\S+) (\\S+) to (?:\\S+)"});
      this->decompiled = std::format("int _{} = int({});", this->variable, parseInt(a));
    } else if (this->instruction == "sitofp") {
      // sitofp i32 %47 to float
      auto [a] = string_view_match<1>(this->assignment, std::regex{"sitofp (?:\\S+) (\\S+) to (?:\\S+)"});
      this->decompiled = std::format("float _{} = float({});", this->variable, parseInt(a));
    } else if (this->instruction == "uitofp") {
      // uitofp i32 %158 to float
      auto [a] = string_view_match<1>(this->assignment, std::regex{"uitofp (?:\\S+) (\\S+) to (?:\\S+)"});
      this->decompiled = std::format("float _{} = float({});", this->variable, parseInt(a));
    } else if (this->instruction == "fptoui") {
      auto [a] = string_view_match<1>(this->assignment, std::regex{"fptoui (?:\\S+) (\\S+) to (?:\\S+)"});
      this->decompiled = std::format("uint _{} = uint({});", this->variable, parseFloat(a));
    } else if (this->instruction == "and") {
      auto [type, a, b] = string_view_match<3>(this->assignment, std::regex{"and (\\S+) (\\S+), (\\S+)"});
      this->decompiled = std::format("{} _{} = {} & {};", parseType(type), this->variable, parseInt(a), parseInt(b));
    } else {
      throw std::invalid_argument("Could not parse code assignment");
    }
    std::cout << "// " << line << std::endl;
    std::cout << this->decompiled << std::endl;
  }
};

struct CodeFunction {
  std::string_view name;
  std::string_view returnType;
  std::vector<std::string_view> parameters;
  std::vector<std::string_view> lines;
  std::vector<std::string> hlslLine;

  CodeFunction() {}

  explicit CodeFunction(std::string_view line) {
    // define void @main() {
    static auto regex = std::regex{R"/(define (\S+) @([^(]+)\(([^)]*)\) \{)/"};
    static auto param_split = std::regex(R"/( ((?:[^%][^},]+)|(?:%"[^"]+"))(?:,| ))/");

    auto [returnType, name, params] = string_view_match<3>(line, regex);

    this->returnType = returnType;
    this->name = name;
    this->parameters = string_view_split_all(params, param_split, 1);
  }

  void addCodeAssign(std::string_view line) {
    CodeAssign assignment(line);
    this->hlslLine.push_back(assignment.decompiled);
  }
};

std::string decompile(std::string_view disassembly) {
  auto lines = string_view_split_all(disassembly, '\n');
  size_t line_number = 0;
  decompiler_state state = decompiler_state::start;
  size_t inputSigSectionCount = 0;
  size_t outputSigSectionCount = 0;
  std::vector<Signature1> inputSigs1;
  std::vector<Signature1> outputSigs1;
  std::vector<Signature2> inputSigs2;
  std::vector<Signature2> outputSigs2;
  std::vector<ResourceBinding> resourceBindings;
  std::vector<std::string_view> pipelineInfos;
  std::vector<std::string_view> viewIdStateInfo;
  std::string_view sha256Hash = "";
  BufferDefinition currentBufferDefinition;
  std::vector<BufferDefinition> bufferDefinitions;
  size_t currentBufferDefinitionDepth = 0;
  std::vector<TypeDefinition> typeDefinitions;
  std::vector<CodeFunction> codeFunctions;
  CodeFunction currentCodeFunction;

  std::string_view line = "";
  while (state != decompiler_state::complete) {
    std::string_view line = string_view_trim_end(lines.at(line_number));
    auto prestate = state;
    try {
      switch (state) {
        case decompiler_state::start:
          if (line == ";") {
            state = decompiler_state::description_whitespace;
          } else if (line == "") {
            state = decompiler_state::whitespace;
          } else {
            throw std::invalid_argument("Unexpected start of file");
          }
          break;
        case decompiler_state::description_whitespace:
          if (line == "" || line[0] != ';') {
            state = decompiler_state::whitespace;
          } else if (line == ";") {
            line_number++;
          } else if (line == "; Input signature:") {
            if (!inputSigSectionCount) {
              state = decompiler_state::description_input_sig_title;
              inputSigSectionCount++;
            } else {
              state = decompiler_state::description_input_sig2_title;
            }
          } else if (line == "; Output signature:") {
            if (!outputSigSectionCount) {
              state = decompiler_state::description_output_sig_title;
              outputSigSectionCount++;
            } else {
              state = decompiler_state::description_output_sig2_title;
            }
          } else if (line.starts_with("; shader hash:")) {
            state = decompiler_state::description_shader_hash;
          } else if (line == "; Pipeline Runtime Information:") {
            state = decompiler_state::description_pipeline_runtime_title;
          } else if (line == "; Buffer Definitions:") {
            state = decompiler_state::description_buffer_definition_title;
          } else if (line == "; Resource Bindings:") {
            state = decompiler_state::description_resource_bindings_title;
          } else if (line == "; ViewId state:") {
            state = decompiler_state::description_view_id_state_title;
          } else {
            throw std::invalid_argument("Unexpected description entry");
          }
          break;
        case decompiler_state::description_input_sig_title:
        case decompiler_state::description_input_sig_whitespace:
        case decompiler_state::description_input_sig_table_header:
        case decompiler_state::description_input_sig_table_divider:
          state++;
          line_number++;
          break;
        case decompiler_state::description_input_sig_table_row:
          if (line == ";") {
            state = decompiler_state::description_whitespace;
          } else {
            inputSigs1.push_back(Signature1(line));
            line_number++;
          }
          break;
        case decompiler_state::description_input_sig_table_end:
          break;
        case decompiler_state::description_output_sig_title:
        case decompiler_state::description_output_sig_whitespace:
        case decompiler_state::description_output_sig_table_header:
        case decompiler_state::description_output_sig_table_divider:
          state++;
          line_number++;
          break;
        case decompiler_state::description_output_sig_table_row:
          if (line == ";") {
            state = decompiler_state::description_whitespace;
          } else {
            outputSigs1.push_back(Signature1(line));
            line_number++;
          }
          break;
        case decompiler_state::description_output_sig_table_end:
          break;
        case decompiler_state::description_shader_hash:
          sha256Hash = line.substr(strlen("; shader hash: "));
          state = decompiler_state::description_whitespace;
          line_number++;
          break;
        case decompiler_state::description_pipeline_runtime_title:
        case decompiler_state::description_pipeline_runtime_whitespace:
          state++;
          line_number++;
          break;
        case decompiler_state::description_pipeline_runtime_info:
          if (line == ";") {
            state = decompiler_state::description_whitespace;
          } else {
            pipelineInfos.push_back(line);
            line_number++;
          }
          break;
        case decompiler_state::description_pipeline_runtime_end:
          break;
        case decompiler_state::description_input_sig2_title:
        case decompiler_state::description_input_sig2_whitespace:
        case decompiler_state::description_input_sig2_table_header:
        case decompiler_state::description_input_sig2_table_divider:
          state++;
          line_number++;
          break;
        case decompiler_state::description_input_sig2_table_row:
          if (line == ";") {
            state = decompiler_state::description_whitespace;
          } else {
            inputSigs2.push_back(Signature2(line));
            line_number++;
          }
          break;
        case decompiler_state::description_input_sig2_table_end:

          break;
        case decompiler_state::description_output_sig2_title:
        case decompiler_state::description_output_sig2_whitespace:
        case decompiler_state::description_output_sig2_table_header:
        case decompiler_state::description_output_sig2_table_divider:
          state++;
          line_number++;
          break;
        case decompiler_state::description_output_sig2_table_row:
          if (line == ";") {
            state = decompiler_state::description_whitespace;
          } else {
            outputSigs2.push_back(Signature2(line));
            line_number++;
          }
          break;
        case decompiler_state::description_output_sig2_table_end:
          break;
        case decompiler_state::description_buffer_definition_title:
        case decompiler_state::description_buffer_definition_whitespace:
          state++;
          line_number++;
          break;
        case decompiler_state::description_buffer_definition_type:
          currentBufferDefinition = BufferDefinition(line);
          bufferDefinitions.push_back(currentBufferDefinition);
          state++;
          line_number++;
          break;
        case decompiler_state::description_buffer_definition_type_block_start:
          if (line != "; {") {
            throw std::invalid_argument("Unexpected buffer definition block start");
          }
          state++;
          line_number++;
          break;
        case decompiler_state::description_buffer_definition_type_block:
          if (line == ";") {
            line_number++;
          } else if (line == "; }") {
            state = decompiler_state::description_buffer_definition_type_block_end;
          } else {
            currentBufferDefinition.definitions.push_back(line);
            line_number++;
          }
          break;
        case decompiler_state::description_buffer_definition_type_block_end:
        case decompiler_state::description_buffer_definition_type_end:
          state++;
          line_number++;
          break;
        case decompiler_state::description_buffer_definition_type_complete:
          if (line == ";") {
            state = decompiler_state::description_whitespace;
          } else {
            state = decompiler_state::description_buffer_definition_type;
          }
          break;
        case decompiler_state::description_resource_bindings_title:
        case decompiler_state::description_resource_bindings_whitespace:
        case decompiler_state::description_resource_bindings_table_header:
        case decompiler_state::description_resource_bindings_table_divider:
          state++;
          line_number++;
          break;
        case decompiler_state::description_resource_bindings_table_row:
          if (line == ";") {
            state = decompiler_state::description_whitespace;
          } else {
            resourceBindings.push_back(ResourceBinding(line));
          }
          line_number++;
          break;
        case decompiler_state::description_resource_bindings_table_end:
          break;
        case decompiler_state::description_view_id_state_title:
        case decompiler_state::description_view_id_state_whitespace:
          state++;
          line_number++;
        case decompiler_state::description_view_id_state_info:
          if (line == ";") {
            state = decompiler_state::description_whitespace;
          } else {
            viewIdStateInfo.push_back(line);
            line_number++;
          }
          break;
        case decompiler_state::description_view_id_state_end:
          break;
        case decompiler_state::target_datalayout:
          // ignore for now
          state = decompiler_state::whitespace;
          line_number++;
          break;
        case decompiler_state::target_triple:
          state = decompiler_state::whitespace;
          line_number++;
          break;
        case decompiler_state::whitespace:
          if (line == "") {
            line_number++;
          } else if (line[0] == '%') {
            state = decompiler_state::type_definition;
          } else if (line.starts_with("target datalayout")) {
            state = decompiler_state::target_datalayout;
          } else if (line.starts_with("target triple")) {
            state = decompiler_state::target_triple;
          } else if (line.starts_with("define")) {
            state = decompiler_state::code_define;
          } else {
            throw std::invalid_argument("Unexpected line");
          }
          break;
        case decompiler_state::type_definition:
          if (line == "" || line[0] != '%') {
            state = decompiler_state::whitespace;
          }
          typeDefinitions.push_back(TypeDefinition(line));
          line_number++;
          break;
        case decompiler_state::code_define:
          currentCodeFunction = CodeFunction(line);
          codeFunctions.push_back(currentCodeFunction);
          currentCodeFunction.lines.push_back(line);
          line_number++;
          state++;
          break;
        case decompiler_state::code_block:
          currentCodeFunction.lines.push_back(line);
          if (line == "}") {
            state = decompiler_state::code_end;
          } else if (line.starts_with("  %")) {
            state = decompiler_state::code_assign;
          } else if (line.starts_with("  call ")) {
            state = decompiler_state::code_call;
          } else if (line.starts_with("  store ")) {
            state = decompiler_state::code_store;
          } else if (line.starts_with("  ret ")) {
            state = decompiler_state::code_return;
          } else if (line.starts_with("  br ")) {
            state = decompiler_state::code_branch;
          } else {
            throw std::invalid_argument("Unexpected code block");
          }
          break;
        case decompiler_state::code_assign:
          currentCodeFunction.addCodeAssign(line);
          state = decompiler_state::code_block;
          line_number++;
          break;
        case decompiler_state::code_call:
        case decompiler_state::code_store:
        case decompiler_state::code_return:
        case decompiler_state::code_branch:
          state = decompiler_state::code_block;
          line_number++;
          break;
        case decompiler_state::code_branch_start:

          break;
        case decompiler_state::code_branch_block:

          break;
        case decompiler_state::code_end:
          state = decompiler_state::whitespace;
          line_number++;
          break;
        default:
          break;
      }
      // std::cout << prestate << ": " << line << std::endl;
    } catch (const std::invalid_argument &ex) {
      std::cerr << ex.what() << " at line: " << line_number + 1 << std::endl
                << "  >>>" << line << "<<<" << std::endl;
      throw;
    } catch (const std::exception &ex) {
      std::cerr << ex.what() << " at line: " << line_number + 1 << std::endl
                << "  >>>" << line << "<<<" << std::endl;
      throw;
    } catch (...) {
      std::cerr << "Unknown error at line: " << line_number + 1 << std::endl
                << "  >>>" << line << "<<<" << std::endl;
      throw;
    }
  }

  return "foo";
}

FILE* open_or_exit(const char* fname, const char* mode) {
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
  uint8_t* code = new uint8_t[code_size];
  file.seekg(0, std::ios::beg);
  file.read((char*)code, code_size);

  char* disassembly = ShaderCompilerUtil::disassembleShader(code, code_size);
  if (disassembly == nullptr) {
    fprintf(stderr, "Failed to disassemble shader.");
    return EXIT_FAILURE;
  }
  std::cout << "Disassembled." << std::endl;
  std::string decompilation = decompile(std::string_view(disassembly));

  // fprintf(stdout, "%s", decompilation.c_str());
  if (!decompilation.length()) {
    return EXIT_FAILURE;
  }
  return EXIT_SUCCESS;
}
