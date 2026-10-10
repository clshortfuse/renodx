// ===== POST-PROCESSING PASSES =====
// String-to-string transforms applied to the final HLSL output.
// These are static methods on the Decompiler class, operating on the
// complete HLSL text after code generation.
//
// Ported from ShortFuse's shader_decompiler_dxc.hpp.
// Each pass is a self-contained function: std::string -> std::string.
  static std::string OptimizeWholeStructBufferStores(std::string_view hlsl) {
    static const auto STRUCT_START_REGEX = std::regex(R"(^struct\s+([A-Za-z_][A-Za-z0-9_]*)\s*\{$)");
    static const auto STRUCT_FIELD_REGEX = std::regex(R"(^\s*[A-Za-z_][A-Za-z0-9_<>, ]*\s+([A-Za-z_][A-Za-z0-9_]*)\s*;\s*$)");
    static const auto RW_STRUCTURED_BUFFER_REGEX =
        std::regex(R"(^\s*RWStructuredBuffer<([A-Za-z_][A-Za-z0-9_]*)>\s+([A-Za-z_][A-Za-z0-9_]*)\s*:\s*register\(u\d+,\s*space\d+\);\s*$)");
    static const auto STRUCT_FIELD_STORE_REGEX =
        std::regex(R"(^(\s*)([A-Za-z_][A-Za-z0-9_]*)\[(.+)\](\.[A-Za-z_][A-Za-z0-9_]*) = (.+);\s*$)");

    std::vector<std::string> lines;
    {
      std::stringstream line_stream{std::string(hlsl)};
      std::string line;
      while (std::getline(line_stream, line)) {
        lines.push_back(line);
      }
    }

    std::map<std::string, std::vector<std::string>> struct_fields;
    std::map<std::string, std::string> resource_struct_types;

    for (size_t i = 0; i < lines.size(); ++i) {
      auto [struct_name] = StringViewMatch<1>(lines[i], STRUCT_START_REGEX);
      if (!struct_name.empty()) {
        std::vector<std::string> fields;
        ++i;
        while (i < lines.size() && lines[i] != "};") {
          auto [field_name] = StringViewMatch<1>(lines[i], STRUCT_FIELD_REGEX);
          if (!field_name.empty()) {
            fields.emplace_back(field_name);
          }
          ++i;
        }
        if (!fields.empty()) {
          struct_fields.emplace(std::string(struct_name), std::move(fields));
        }
        continue;
      }

      auto [struct_type, resource_name] = StringViewMatch<2>(lines[i], RW_STRUCTURED_BUFFER_REGEX);
      if (!struct_type.empty() && !resource_name.empty()) {
        resource_struct_types.emplace(std::string(resource_name), std::string(struct_type));
      }
    }

    std::vector<std::string> output_lines;
    output_lines.reserve(lines.size());
    int temp_index = 0;

    for (size_t i = 0; i < lines.size(); ++i) {
      auto [indent, resource_name, element_index, field_name, expression] = StringViewMatch<5>(lines[i], STRUCT_FIELD_STORE_REGEX);
      if (resource_name.empty() || !resource_struct_types.contains(std::string(resource_name))) {
        output_lines.push_back(lines[i]);
        continue;
      }

      const auto& struct_type = resource_struct_types.at(std::string(resource_name));
      auto struct_fields_it = struct_fields.find(struct_type);
      if (struct_fields_it == struct_fields.end()) {
        output_lines.push_back(lines[i]);
        continue;
      }

      std::vector<std::tuple<std::string, std::string>> run_fields = {
          {std::string(field_name), std::string(expression)},
      };
      size_t run_end = i;
      for (size_t j = i + 1; j < lines.size(); ++j) {
        auto [next_indent, next_resource_name, next_element_index, next_field_name, next_expression] =
            StringViewMatch<5>(lines[j], STRUCT_FIELD_STORE_REGEX);
        if (next_indent != indent
            || next_resource_name != resource_name
            || next_element_index != element_index
            || next_field_name.empty()
            || next_expression.empty()) {
          break;
        }
        run_fields.emplace_back(std::string(next_field_name), std::string(next_expression));
        run_end = j;
      }

      if (run_fields.size() != struct_fields_it->second.size()) {
        output_lines.push_back(lines[i]);
        continue;
      }

      bool covers_all_fields = true;
      std::set<std::string> seen_fields;
      for (const auto& expected_field : struct_fields_it->second) {
        seen_fields.insert("." + expected_field);
      }
      for (const auto& [run_field_name, run_expression] : run_fields) {
        if (!seen_fields.erase(run_field_name)) {
          covers_all_fields = false;
          break;
        }
      }
      if (!covers_all_fields || !seen_fields.empty()) {
        output_lines.push_back(lines[i]);
        continue;
      }

      auto temp_name = std::format("__struct_store_{}", temp_index++);
      output_lines.push_back(std::format("{}{} {};", indent, struct_type, temp_name));
      for (const auto& expected_field : struct_fields_it->second) {
        auto run_it = std::ranges::find_if(
            run_fields,
            [&](const auto& run_field) {
              return std::get<0>(run_field) == ("." + expected_field);
            });
        output_lines.push_back(std::format(
            "{}{}{} = {};",
            indent,
            temp_name,
            std::get<0>(*run_it),
            std::get<1>(*run_it)));
      }
      output_lines.push_back(std::format(
          "{}{}[{}] = {};",
          indent,
          resource_name,
          element_index,
          temp_name));
      i = run_end;
    }

    std::stringstream output_stream;
    for (size_t i = 0; i < output_lines.size(); ++i) {
      output_stream << output_lines[i];
      if (i + 1 < output_lines.size()) {
        output_stream << "\n";
      }
    }
    return output_stream.str();
  }

  static std::string OptimizeStructuredResourceVectorLoads(std::string_view hlsl) {
    static const auto STRUCTURED_BUFFER_REGEX =
        std::regex(R"(^\s*(?:RW)?StructuredBuffer<([A-Za-z_][A-Za-z0-9_]*)>\s+([A-Za-z_][A-Za-z0-9_]*)\s*(?:\[\])?\s*:\s*register\([tu]\d+,\s*space\d+\);\s*$)");
    static const auto VECTOR_COMPONENT_LOAD_REGEX =
        std::regex(R"(^(\s*)(float|half|int|uint)\s+([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.+)\.([xyzw]);\s*$)");

    std::vector<std::string> lines;
    {
      std::stringstream line_stream{std::string(hlsl)};
      std::string line;
      while (std::getline(line_stream, line)) {
        lines.push_back(line);
      }
    }

    std::set<std::string> structured_resource_names;
    for (const auto& line : lines) {
      auto [struct_type, resource_name] = StringViewMatch<2>(line, STRUCTURED_BUFFER_REGEX);
      if (!struct_type.empty() && !resource_name.empty()) {
        structured_resource_names.emplace(std::string(resource_name));
      }
    }

    auto is_structured_resource_expression = [&](std::string_view expression) {
      for (const auto& resource_name : structured_resource_names) {
        if (expression.starts_with(resource_name) && expression.size() > resource_name.size()
            && expression[resource_name.size()] == '[') {
          return true;
        }
      }
      return false;
    };

    std::vector<std::string> output_lines;
    output_lines.reserve(lines.size());
    int temp_index = 0;

    for (size_t i = 0; i < lines.size();) {
      auto [indent, scalar_type, first_variable, base_expression, swizzle] =
          StringViewMatch<5>(lines[i], VECTOR_COMPONENT_LOAD_REGEX);
      if (first_variable.empty() || base_expression.empty() || swizzle != "x"
          || !is_structured_resource_expression(base_expression)) {
        output_lines.push_back(lines[i]);
        ++i;
        continue;
      }

      std::vector<std::tuple<std::string, std::string>> run = {
          {std::string(first_variable), std::string(swizzle)},
      };
      size_t run_end = i;
      size_t expected_component_index = 1;
      for (size_t j = i + 1; j < lines.size() && expected_component_index < 4; ++j) {
        auto [next_indent, next_scalar_type, next_variable, next_base_expression, next_swizzle] =
            StringViewMatch<5>(lines[j], VECTOR_COMPONENT_LOAD_REGEX);
        if (next_variable.empty()
            || next_indent != indent
            || next_scalar_type != scalar_type
            || next_base_expression != base_expression
            || next_swizzle.size() != 1
            || next_swizzle[0] != VECTOR_INDEXES[expected_component_index]) {
          break;
        }
        run.emplace_back(std::string(next_variable), std::string(next_swizzle));
        run_end = j;
        ++expected_component_index;
      }

      if (run.size() < 2) {
        output_lines.push_back(lines[i]);
        ++i;
        continue;
      }

      auto temp_name = std::format("__structured_resource_load_{}", temp_index++);
      output_lines.push_back(std::format(
          "{}{}{} {} = {};",
          indent,
          scalar_type,
          run.size(),
          temp_name,
          base_expression));
      for (const auto& [variable_name, component_swizzle] : run) {
        output_lines.push_back(std::format(
            "{}{} {} = {}.{};",
            indent,
            scalar_type,
            variable_name,
            temp_name,
            component_swizzle));
      }
      i = run_end + 1;
    }

    std::stringstream output_stream;
    for (size_t i = 0; i < output_lines.size(); ++i) {
      output_stream << output_lines[i];
      if (i + 1 < output_lines.size()) {
        output_stream << "\n";
      }
    }
    return output_stream.str();
  }

  static std::string OptimizeDeferredBoolBridgeBlocks(std::string_view hlsl) {
    static const auto DEFER_DECL_REGEX = std::regex(R"(^(\s*)bool (__defer_\d+_\d+) = false;\s*$)");
    static const auto DEFER_ASSIGN_REGEX = std::regex(R"(^(\s*)(__defer_\d+_\d+) = true;\s*$)");
    static const auto DEFER_IF_REGEX = std::regex(R"(^(\s*)if \((__defer_\d+_\d+)\) \{\s*$)");
    static const auto SIMPLE_BODY_LINE_REGEX = std::regex(R"(^\s*(?:(?://.*)|(?:[A-Za-z_][A-Za-z0-9_<>, ]*\s+_\d+\s*=.*;)|(?:_\d+ = .*;)|(?:bool _\d+;)|(?:_\d+;))\s*$)");

    std::vector<std::string> lines;
    {
      std::stringstream line_stream{std::string(hlsl)};
      std::string line;
      while (std::getline(line_stream, line)) {
        lines.push_back(line);
      }
    }

    auto count_braces = [](std::string_view line) {
      int delta = 0;
      for (char c : line) {
        if (c == '{') ++delta;
        if (c == '}') --delta;
      }
      return delta;
    };

    bool changed = false;
    for (size_t i = 0; i < lines.size(); ++i) {
      auto [decl_indent, defer_var] = StringViewMatch<2>(lines[i], DEFER_DECL_REGEX);
      if (defer_var.empty()) continue;

      size_t defer_if_line = std::string::npos;
      for (size_t j = i + 1; j < lines.size(); ++j) {
        auto [if_indent, if_defer_var] = StringViewMatch<2>(lines[j], DEFER_IF_REGEX);
        if (if_defer_var == defer_var) {
          defer_if_line = j;
          break;
        }
      }
      if (defer_if_line == std::string::npos) continue;

      int brace_depth = count_braces(lines[defer_if_line]);
      size_t defer_if_end = defer_if_line;
      for (size_t j = defer_if_line + 1; j < lines.size(); ++j) {
        brace_depth += count_braces(lines[j]);
        if (brace_depth == 0) {
          defer_if_end = j;
          break;
        }
      }
      if (defer_if_end == defer_if_line) continue;

      std::vector<std::string> defer_body_lines;
      for (size_t j = defer_if_line + 1; j < defer_if_end; ++j) {
        if (!std::regex_match(lines[j], SIMPLE_BODY_LINE_REGEX)) {
          defer_body_lines.clear();
          break;
        }
        defer_body_lines.push_back(lines[j]);
      }
      if (defer_body_lines.empty()) continue;

      size_t body_min_indent = (std::numeric_limits<size_t>::max)();
      for (const auto& line : defer_body_lines) {
        if (line.empty()) continue;
        size_t first_non_space = line.find_first_not_of(' ');
        if (first_non_space == std::string::npos) continue;
        body_min_indent = (std::min)(body_min_indent, first_non_space);
      }
      if (body_min_indent == (std::numeric_limits<size_t>::max)()) continue;

      std::vector<size_t> assignment_positions;
      for (size_t j = i + 1; j < defer_if_line; ++j) {
        auto [assign_indent, assign_defer_var] = StringViewMatch<2>(lines[j], DEFER_ASSIGN_REGEX);
        if (assign_defer_var == defer_var) {
          assignment_positions.push_back(j);
        }
      }

      if (assignment_positions.empty()) {
        lines.erase(lines.begin() + defer_if_line, lines.begin() + defer_if_end + 1);
        lines.erase(lines.begin() + i);
        changed = true;
        --i;
        continue;
      }

      for (auto assignment_it = assignment_positions.rbegin(); assignment_it != assignment_positions.rend(); ++assignment_it) {
        size_t assignment_position = *assignment_it;
        auto [assign_indent, assign_defer_var] = StringViewMatch<2>(lines[assignment_position], DEFER_ASSIGN_REGEX);
        std::vector<std::string> expanded_lines;
        for (const auto& body_line : defer_body_lines) {
          std::string trimmed = body_line.size() >= body_min_indent ? body_line.substr(body_min_indent) : body_line;
          expanded_lines.push_back(std::string(assign_indent) + trimmed);
        }

        lines.erase(lines.begin() + assignment_position);
        lines.insert(lines.begin() + assignment_position, expanded_lines.begin(), expanded_lines.end());
        changed = true;
      }

      defer_if_line = std::string::npos;
      for (size_t j = i + 1; j < lines.size(); ++j) {
        auto [if_indent, if_defer_var] = StringViewMatch<2>(lines[j], DEFER_IF_REGEX);
        if (if_defer_var == defer_var) {
          defer_if_line = j;
          break;
        }
      }
      if (defer_if_line == std::string::npos) continue;

      brace_depth = count_braces(lines[defer_if_line]);
      defer_if_end = defer_if_line;
      for (size_t j = defer_if_line + 1; j < lines.size(); ++j) {
        brace_depth += count_braces(lines[j]);
        if (brace_depth == 0) {
          defer_if_end = j;
          break;
        }
      }
      if (defer_if_end == defer_if_line) continue;

      lines.erase(lines.begin() + defer_if_line, lines.begin() + defer_if_end + 1);
      lines.erase(lines.begin() + i);
      changed = true;
      --i;
    }

    if (!changed) {
      return std::string(hlsl);
    }

    std::stringstream output_stream;
    for (size_t i = 0; i < lines.size(); ++i) {
      output_stream << lines[i];
      if (i + 1 < lines.size()) {
        output_stream << "\n";
      }
    }
    return output_stream.str();
  }

  static std::string OptimizeSingleUseBoolChains(std::string_view hlsl) {
    static const auto BOOL_ASSIGN_REGEX =
        std::regex(R"(^(\s*)bool ([A-Za-z_][A-Za-z0-9_]*) = \((.+)\);\s*$)");
    static const auto BOOL_COMBINE_REGEX =
        std::regex(R"(^(\s*)bool ([A-Za-z_][A-Za-z0-9_]*) = \(([A-Za-z_][A-Za-z0-9_]*)\) (\&\&|\|\||\&|\|) \(([A-Za-z_][A-Za-z0-9_]*)\);\s*$)");

    std::vector<std::string> lines;
    {
      std::stringstream line_stream{std::string(hlsl)};
      std::string line;
      while (std::getline(line_stream, line)) {
        lines.push_back(line);
      }
    }

    auto count_variable_references = [&](std::string_view variable) {
      auto variable_regex = std::regex(std::format(R"((^|[^A-Za-z0-9_]){}([^A-Za-z0-9_]|$))", variable));
      size_t count = 0;
      for (const auto& line : lines) {
        if (std::regex_search(line, variable_regex)) {
          ++count;
        }
      }
      return count;
    };

    bool changed = false;
    for (size_t i = 0; i + 2 < lines.size(); ++i) {
      auto [indent_a, variable_a, expression_a] = StringViewMatch<3>(lines[i], BOOL_ASSIGN_REGEX);
      auto [indent_b, variable_b, expression_b] = StringViewMatch<3>(lines[i + 1], BOOL_ASSIGN_REGEX);
      auto [indent_c, variable_c, lhs_variable, combine_op, rhs_variable] = StringViewMatch<5>(lines[i + 2], BOOL_COMBINE_REGEX);
      if (variable_a.empty() || variable_b.empty() || variable_c.empty()) continue;
      if (indent_a != indent_b || indent_b != indent_c) continue;

      const bool is_direct_order = lhs_variable == variable_a && rhs_variable == variable_b;
      const bool is_reverse_order = lhs_variable == variable_b && rhs_variable == variable_a;
      if (!is_direct_order && !is_reverse_order) continue;

      if (count_variable_references(variable_a) != 2 || count_variable_references(variable_b) != 2) {
        continue;
      }

      auto lhs_expression = std::string(is_direct_order ? expression_a : expression_b);
      auto rhs_expression = std::string(is_direct_order ? expression_b : expression_a);
      lines[i + 2] = std::format(
          "{}bool {} = (({}) {} ({}));",
          indent_c,
          variable_c,
          lhs_expression,
          combine_op,
          rhs_expression);
      lines.erase(lines.begin() + i, lines.begin() + i + 2);
      changed = true;
      if (i != 0) --i;
    }

    if (!changed) {
      return std::string(hlsl);
    }

    std::stringstream output_stream;
    for (size_t i = 0; i < lines.size(); ++i) {
      output_stream << lines[i];
      if (i + 1 < lines.size()) {
        output_stream << "\n";
      }
    }
    return output_stream.str();
  }

  static std::string OptimizeSentinelBoolIntGuards(std::string_view hlsl) {
    static const auto IF_GUARD_REGEX =
        std::regex(R"(^(\s*)if \(\(\((_?\w+) != 0\)\) && \(\((_?\w+) != -1\)\)\) \{\s*$)");
    static const auto INT_FROM_BOOL_ASSIGN_REGEX =
        std::regex(R"(^(\s*)(_\d+) = \(\(int\)\(uint\)\(\(int\)\((.+)\)\)\);\s*$)");
    static const auto INT_FROM_BOOL_DECL_ASSIGN_REGEX =
        std::regex(R"(^(\s*)int\s+(_\d+)\s*=\s*\(\(int\)\(uint\)\(\(int\)\((.+)\)\)\);\s*$)");
    static const auto SIMPLE_ASSIGN_REGEX =
        std::regex(R"(^(\s*)(_\d+) = (.+);\s*$)");
    static const auto BOOL_DECL_REGEX =
        std::regex(R"(^(\s*)bool (_\d+)\s*;\s*$)");
    static const auto INT_DECL_REGEX =
        std::regex(R"(^(\s*)int (_\d+)\s*;\s*$)");

    std::vector<std::string> lines;
    {
      std::stringstream line_stream{std::string(hlsl)};
      std::string line;
      while (std::getline(line_stream, line)) {
        lines.push_back(line);
      }
    }

    bool changed = false;
    for (size_t i = 0; i < lines.size(); ++i) {
      auto [if_indent, int_guard_variable, sentinel_variable] = StringViewMatch<3>(lines[i], IF_GUARD_REGEX);
      if (int_guard_variable.empty() || sentinel_variable.empty()) {
        continue;
      }

      auto previous_non_empty_line = [&lines](size_t start) -> std::optional<size_t> {
        for (size_t j = start; j-- > 0;) {
          if (!StringViewTrim(lines[j]).empty()) {
            return j;
          }
        }
        return std::nullopt;
      };

      auto direct_guard_line = previous_non_empty_line(i);
      if (direct_guard_line.has_value()) {
        auto [bool_indent, bool_assign_variable, bool_expression] =
            StringViewMatch<3>(lines[direct_guard_line.value()], INT_FROM_BOOL_ASSIGN_REGEX);
        if (bool_assign_variable == int_guard_variable) {
          continue;
        }

        auto [decl_indent, decl_assign_variable, decl_expression] =
            StringViewMatch<3>(lines[direct_guard_line.value()], INT_FROM_BOOL_DECL_ASSIGN_REGEX);
        if (decl_assign_variable == int_guard_variable) {
          continue;
        }
      }

      bool saw_sentinel_assignment = false;
      std::optional<size_t> direct_guard_assignment_line;
      std::optional<size_t> true_guard_assignment_line;
      std::optional<size_t> false_guard_assignment_line;
      std::optional<std::string> bool_guard_expression;
      const size_t direct_guard_search_begin = i > 6 ? i - 6 : 0;
      for (size_t j = i; j-- > direct_guard_search_begin;) {
        auto [bool_indent, bool_assign_variable, bool_expression] =
            StringViewMatch<3>(lines[j], INT_FROM_BOOL_ASSIGN_REGEX);
        if (bool_assign_variable == int_guard_variable) {
          direct_guard_assignment_line = j;
          bool_guard_expression = std::string(bool_expression);
          break;
        }

        auto [decl_indent, decl_assign_variable, decl_expression] =
            StringViewMatch<3>(lines[j], INT_FROM_BOOL_DECL_ASSIGN_REGEX);
        if (decl_assign_variable == int_guard_variable) {
          direct_guard_assignment_line = j;
          bool_guard_expression = std::string(decl_expression);
          break;
        }
      }

      const size_t search_begin = i > 200 ? i - 200 : 0;
      for (size_t j = i; j-- > search_begin;) {
        auto [assign_indent, assign_variable, assign_value] = StringViewMatch<3>(lines[j], SIMPLE_ASSIGN_REGEX);
        if (assign_variable != sentinel_variable) {
          continue;
        }

        if (assign_value == "-1") {
          saw_sentinel_assignment = true;
          const size_t false_guard_search_begin = j > 6 ? j - 6 : 0;
          for (size_t k = j; k-- > false_guard_search_begin;) {
            auto [bool_indent, bool_assign_variable, bool_expression] =
                StringViewMatch<3>(lines[k], INT_FROM_BOOL_ASSIGN_REGEX);
            if (bool_assign_variable == int_guard_variable) {
              false_guard_assignment_line = k;
              break;
            }
            auto [decl_indent, decl_assign_variable, decl_expression] =
                StringViewMatch<3>(lines[k], INT_FROM_BOOL_DECL_ASSIGN_REGEX);
            if (decl_assign_variable == int_guard_variable) {
              false_guard_assignment_line = k;
              break;
            }
          }
          continue;
        }

        const size_t guard_search_begin = j > 6 ? j - 6 : 0;
        for (size_t k = j; k-- > guard_search_begin;) {
          auto [bool_indent, bool_assign_variable, bool_expression] =
              StringViewMatch<3>(lines[k], INT_FROM_BOOL_ASSIGN_REGEX);
          if (bool_assign_variable == int_guard_variable) {
            true_guard_assignment_line = k;
            bool_guard_expression = std::string(bool_expression);
            break;
          }
          auto [decl_indent, decl_assign_variable, decl_expression] =
              StringViewMatch<3>(lines[k], INT_FROM_BOOL_DECL_ASSIGN_REGEX);
          if (decl_assign_variable == int_guard_variable) {
            true_guard_assignment_line = k;
            bool_guard_expression = std::string(decl_expression);
            break;
          }
        }
        break;
      }

      if (!saw_sentinel_assignment || !bool_guard_expression.has_value()) {
        continue;
      }

      auto [bool_guard_variable] =
          StringViewMatch<1>(bool_guard_expression.value(), std::regex(R"(^(_\d+)$)"));
      if (!bool_guard_variable.empty()) {
        std::optional<size_t> bool_decl_line;
        std::optional<size_t> int_decl_line;
        for (size_t j = 0; j < i; ++j) {
          auto [decl_indent, decl_variable] = StringViewMatch<2>(lines[j], BOOL_DECL_REGEX);
          if (decl_variable == bool_guard_variable) {
            bool_decl_line = j;
          }
          auto [int_decl_indent, int_decl_variable] = StringViewMatch<2>(lines[j], INT_DECL_REGEX);
          if (int_decl_variable == int_guard_variable) {
            int_decl_line = j;
          }
        }

        if (bool_decl_line.has_value()
            && true_guard_assignment_line.has_value()
            && false_guard_assignment_line.has_value()) {
          auto [decl_indent, decl_variable] = StringViewMatch<2>(lines[bool_decl_line.value()], BOOL_DECL_REGEX);
          lines[bool_decl_line.value()] = std::format("{}bool {} = false;", decl_indent, decl_variable);

          std::vector<size_t> removable_lines = {
              int_decl_line.value_or(std::string::npos),
              true_guard_assignment_line.value(),
              false_guard_assignment_line.value(),
          };
          std::ranges::sort(removable_lines);
          removable_lines.erase(std::unique(removable_lines.begin(), removable_lines.end()), removable_lines.end());
          removable_lines.erase(
              std::remove(removable_lines.begin(), removable_lines.end(), std::string::npos),
              removable_lines.end());
          for (auto line_it = removable_lines.rbegin(); line_it != removable_lines.rend(); ++line_it) {
            auto removed_line = *line_it;
            lines.erase(lines.begin() + removed_line);
            if (removed_line < i) {
              --i;
            }
          }

          lines.insert(
              lines.begin() + i,
              std::format(
                  "{}int {} = ((int)(uint)((int)({})));",
                  if_indent,
                  int_guard_variable,
                  bool_guard_expression.value()));
          ++i;
          changed = true;
          continue;
        }
      }

      lines[i] = std::format(
          "{}if ((({} != -1)) && {}) {{",
          if_indent,
          sentinel_variable,
          bool_guard_expression.value());
      if (direct_guard_assignment_line.has_value()) {
        auto removed_line = direct_guard_assignment_line.value();
        lines.erase(lines.begin() + removed_line);
        if (removed_line < i) {
          --i;
        }
      }
      changed = true;
    }

    if (!changed) {
      return std::string(hlsl);
    }

    std::stringstream output_stream;
    for (size_t i = 0; i < lines.size(); ++i) {
      output_stream << lines[i];
      if (i + 1 < lines.size()) {
        output_stream << "\n";
      }
    }
    return output_stream.str();
  }

  static std::string OptimizeBoolCarrierAssignments(std::string_view hlsl) {
    static const auto IF_LINE_REGEX = std::regex(R"(^(\s*)if \((.+)\) \{\s*$)");
    static const auto NOT_IF_LINE_REGEX = std::regex(R"(^(\s*)if \(!(_\d+)\) \{\s*$)");
    static const auto ASSIGN_LINE_REGEX = std::regex(R"(^(\s*)(_\d+) = (.+);\s*$)");

    auto count_char = [](std::string_view line, char value) {
      return static_cast<int>(std::ranges::count(line, value));
    };
    auto trim = [](std::string_view line) {
      return StringViewTrim(line);
    };
    auto next_non_empty = [&](const std::vector<std::string>& lines, size_t start) -> std::optional<size_t> {
      for (size_t i = start; i < lines.size(); ++i) {
        if (!trim(lines[i]).empty()) {
          return i;
        }
      }
      return std::nullopt;
    };
    auto previous_non_empty = [&](const std::vector<std::string>& lines, size_t start) -> std::optional<size_t> {
      for (size_t i = start; i-- > 0;) {
        if (!trim(lines[i]).empty()) {
          return i;
        }
      }
      return std::nullopt;
    };
    auto find_if_region = [&](const std::vector<std::string>& lines, size_t start) -> std::optional<std::pair<size_t, size_t>> {
      auto [indent, condition] = StringViewMatch<2>(lines[start], IF_LINE_REGEX);
      if (condition.empty()) {
        return std::nullopt;
      }

      int depth = 1;
      std::optional<size_t> else_line;
      for (size_t i = start + 1; i < lines.size(); ++i) {
        auto line_trimmed = trim(lines[i]);
        if (depth == 1 && line_trimmed == "} else {") {
          else_line = i;
        }

        depth += count_char(lines[i], '{');
        depth -= count_char(lines[i], '}');
        if (depth == 0) {
          if (!else_line.has_value()) {
            return std::nullopt;
          }
          return std::pair<size_t, size_t>(else_line.value(), i);
        }
      }
      return std::nullopt;
    };

    std::vector<std::string> lines;
    {
      std::stringstream line_stream{std::string(hlsl)};
      std::string line;
      while (std::getline(line_stream, line)) {
        lines.push_back(line);
      }
    }

    bool changed = false;
    for (size_t i = 0; i < lines.size(); ++i) {
      auto [if_indent, outer_condition] = StringViewMatch<2>(lines[i], IF_LINE_REGEX);
      if (outer_condition.empty()) {
        continue;
      }

      auto outer_region = find_if_region(lines, i);
      if (!outer_region.has_value()) {
        continue;
      }
      auto [outer_else_line, outer_end_line] = outer_region.value();

      auto outer_true_assignment_line = previous_non_empty(lines, outer_else_line);
      if (!outer_true_assignment_line.has_value() || outer_true_assignment_line.value() <= i) {
        continue;
      }
      auto [outer_assign_indent, source_variable, source_expression] =
          StringViewMatch<3>(lines[outer_true_assignment_line.value()], ASSIGN_LINE_REGEX);
      if (source_variable.empty() || source_expression.empty()) {
        continue;
      }

      auto outer_else_assignment_line = next_non_empty(lines, outer_else_line + 1);
      if (!outer_else_assignment_line.has_value() || outer_else_assignment_line.value() >= outer_end_line) {
        continue;
      }
      auto [outer_else_assign_indent, outer_else_variable, outer_else_expression] =
          StringViewMatch<3>(lines[outer_else_assignment_line.value()], ASSIGN_LINE_REGEX);
      if (outer_else_variable != source_variable || outer_else_expression != "true") {
        continue;
      }

      auto next_if_line = next_non_empty(lines, outer_end_line + 1);
      if (!next_if_line.has_value()) {
        continue;
      }
      auto [next_if_indent, not_variable] = StringViewMatch<2>(lines[next_if_line.value()], NOT_IF_LINE_REGEX);
      if (not_variable != source_variable) {
        continue;
      }

      auto next_region = find_if_region(lines, next_if_line.value());
      if (!next_region.has_value()) {
        continue;
      }
      auto [next_else_line, next_end_line] = next_region.value();

      auto next_true_assignment_line = next_non_empty(lines, next_if_line.value() + 1);
      if (!next_true_assignment_line.has_value() || next_true_assignment_line.value() >= next_else_line) {
        continue;
      }
      auto [target_assign_indent, target_variable, target_default_expression] =
          StringViewMatch<3>(lines[next_true_assignment_line.value()], ASSIGN_LINE_REGEX);
      if (target_variable.empty() || target_default_expression.empty()) {
        continue;
      }

      auto next_else_assignment_line = next_non_empty(lines, next_else_line + 1);
      if (!next_else_assignment_line.has_value() || next_else_assignment_line.value() >= next_end_line) {
        continue;
      }
      auto [next_else_assign_indent, next_else_variable, next_else_expression] =
          StringViewMatch<3>(lines[next_else_assignment_line.value()], ASSIGN_LINE_REGEX);
      if (next_else_variable != target_variable || next_else_expression != "true") {
        continue;
      }

      std::vector<std::string> rewritten_lines;
      rewritten_lines.reserve(lines.size() + 4);

      rewritten_lines.insert(rewritten_lines.end(), lines.begin(), lines.begin() + i);
      rewritten_lines.push_back(std::format("{}{} = {};", if_indent, target_variable, target_default_expression));
      rewritten_lines.insert(
          rewritten_lines.end(),
          lines.begin() + i,
          lines.begin() + outer_true_assignment_line.value());
      rewritten_lines.push_back(std::format("{}if ({}) {{", outer_assign_indent, source_expression));
      rewritten_lines.push_back(std::format("{}  {} = true;", outer_assign_indent, target_variable));
      rewritten_lines.push_back(std::format("{}}}", outer_assign_indent));
      rewritten_lines.insert(
          rewritten_lines.end(),
          lines.begin() + outer_true_assignment_line.value() + 1,
          lines.begin() + outer_else_assignment_line.value());
      rewritten_lines.push_back(std::format("{}{} = true;", outer_else_assign_indent, target_variable));
      rewritten_lines.insert(
          rewritten_lines.end(),
          lines.begin() + outer_else_assignment_line.value() + 1,
          lines.begin() + outer_end_line + 1);
      rewritten_lines.insert(
          rewritten_lines.end(),
          lines.begin() + outer_end_line + 1,
          lines.begin() + next_if_line.value());
      rewritten_lines.insert(
          rewritten_lines.end(),
          lines.begin() + next_end_line + 1,
          lines.end());

      lines = std::move(rewritten_lines);
      changed = true;
      i = 0;
    }

    if (!changed) {
      return std::string(hlsl);
    }

    std::stringstream output_stream;
    for (size_t i = 0; i < lines.size(); ++i) {
      output_stream << lines[i];
      if (i + 1 < lines.size()) {
        output_stream << "\n";
      }
    }
    return output_stream.str();
  }

  static std::string OptimizeTrailingBoolFallbackElse(std::string_view hlsl) {
    auto count_char = [](std::string_view line, char value) {
      return static_cast<int>(std::ranges::count(line, value));
    };
    auto trim = [](std::string_view line) {
      return StringViewTrim(line);
    };
    struct ParsedIfLine {
      std::string indent;
      std::string condition;
    };
    struct ParsedAssignLine {
      std::string indent;
      std::string variable;
      std::string expression;
    };
    auto parse_if_line = [&](const std::string& line) -> std::optional<ParsedIfLine> {
      auto trimmed = trim(line);
      if (!trimmed.starts_with("if (") || !trimmed.ends_with(") {")) {
        return std::nullopt;
      }

      auto indent_length = line.find_first_not_of(" \t");
      if (indent_length == std::string::npos) {
        indent_length = line.size();
      }

      auto condition_start = trimmed.find('(');
      auto condition_end = trimmed.rfind(") {");
      if (condition_start == std::string_view::npos || condition_end == std::string_view::npos ||
          condition_end <= condition_start + 1) {
        return std::nullopt;
      }

      return ParsedIfLine{
          .indent = line.substr(0, indent_length),
          .condition = std::string(trimmed.substr(condition_start + 1, condition_end - condition_start - 1)),
      };
    };
    auto parse_assignment_line = [&](const std::string& line) -> std::optional<ParsedAssignLine> {
      auto trimmed = trim(line);
      if (trimmed.empty() || !trimmed.ends_with(";")) {
        return std::nullopt;
      }

      auto equals = trimmed.find(" = ");
      if (equals == std::string_view::npos) {
        return std::nullopt;
      }

      auto variable = trimmed.substr(0, equals);
      if (variable.size() < 2 || variable[0] != '_' ||
          !std::ranges::all_of(variable.substr(1), [](char c) { return c >= '0' && c <= '9'; })) {
        return std::nullopt;
      }

      auto indent_length = line.find_first_not_of(" \t");
      if (indent_length == std::string::npos) {
        indent_length = line.size();
      }

      return ParsedAssignLine{
          .indent = line.substr(0, indent_length),
          .variable = std::string(variable),
          .expression = std::string(trimmed.substr(equals + 3, trimmed.size() - equals - 4)),
      };
    };
    auto next_non_empty = [&](const std::vector<std::string>& lines, size_t start) -> std::optional<size_t> {
      for (size_t i = start; i < lines.size(); ++i) {
        if (!trim(lines[i]).empty()) {
          return i;
        }
      }
      return std::nullopt;
    };
    auto previous_non_empty = [&](const std::vector<std::string>& lines, size_t start) -> std::optional<size_t> {
      for (size_t i = start + 1; i-- > 0;) {
        if (!trim(lines[i]).empty()) {
          return i;
        }
      }
      return std::nullopt;
    };
    auto find_if_region = [&](const std::vector<std::string>& lines, size_t start) -> std::optional<std::pair<size_t, size_t>> {
      auto parsed_if = parse_if_line(lines[start]);
      if (!parsed_if.has_value()) {
        return std::nullopt;
      }

      int depth = 1;
      std::optional<size_t> else_line;
      for (size_t i = start + 1; i < lines.size(); ++i) {
        auto line_trimmed = trim(lines[i]);
        if (depth == 1 && line_trimmed == "} else {") {
          else_line = i;
        }

        depth += count_char(lines[i], '{');
        depth -= count_char(lines[i], '}');
        if (depth == 0) {
          if (!else_line.has_value()) {
            return std::nullopt;
          }
          return std::pair<size_t, size_t>(else_line.value(), i);
        }
      }
      return std::nullopt;
    };
    auto find_if_end_without_else =
        [&](const std::vector<std::string>& lines, size_t start) -> std::optional<size_t> {
      auto parsed_if = parse_if_line(lines[start]);
      if (!parsed_if.has_value()) {
        return std::nullopt;
      }

      int depth = 1;
      for (size_t i = start + 1; i < lines.size(); ++i) {
        auto line_trimmed = trim(lines[i]);
        if (depth == 1 && line_trimmed == "} else {") {
          return std::nullopt;
        }

        depth += count_char(lines[i], '{');
        depth -= count_char(lines[i], '}');
        if (depth == 0) {
          return i;
        }
      }
      return std::nullopt;
    };

    std::vector<std::string> lines;
    {
      std::stringstream line_stream{std::string(hlsl)};
      std::string line;
      while (std::getline(line_stream, line)) {
        lines.push_back(line);
      }
    }

    bool changed = false;
    for (size_t i = 0; i < lines.size(); ++i) {
      auto outer_if = parse_if_line(lines[i]);
      if (!outer_if.has_value()) {
        continue;
      }

      auto outer_region = find_if_region(lines, i);
      if (!outer_region.has_value()) {
        continue;
      }
      auto [outer_else_line, outer_end_line] = outer_region.value();

      auto outer_else_assign_line = next_non_empty(lines, outer_else_line + 1);
      if (!outer_else_assign_line.has_value() || outer_else_assign_line.value() >= outer_end_line) {
        continue;
      }
      auto outer_else_assignment = parse_assignment_line(lines[outer_else_assign_line.value()]);
      if (!outer_else_assignment.has_value() || outer_else_assignment->expression != "true") {
        continue;
      }
      auto outer_else_after = next_non_empty(lines, outer_else_assign_line.value() + 1);
      if (!outer_else_after.has_value() || outer_else_after.value() != outer_end_line) {
        continue;
      }

      std::optional<size_t> nested_if_line;
      std::optional<size_t> nested_else_line;
      std::optional<size_t> nested_end_line;
      std::string nested_if_indent;
      std::string target_variable_string;
      std::string default_expression_string;

      for (size_t candidate = i + 1; candidate < outer_else_line; ++candidate) {
        auto candidate_if = parse_if_line(lines[candidate]);
        if (!candidate_if.has_value()) {
          continue;
        }

        auto candidate_region = find_if_region(lines, candidate);
        if (!candidate_region.has_value()) {
          continue;
        }
        auto [candidate_else_line, candidate_end_line] = candidate_region.value();
        auto candidate_tail_after = next_non_empty(lines, candidate_end_line + 1);
        if (!candidate_tail_after.has_value() || candidate_tail_after.value() != outer_else_line) {
          continue;
        }

        auto candidate_true_assign_line = next_non_empty(lines, candidate + 1);
        if (!candidate_true_assign_line.has_value() || candidate_true_assign_line.value() >= candidate_else_line) {
          continue;
        }
        auto candidate_true_assignment = parse_assignment_line(lines[candidate_true_assign_line.value()]);
        if (!candidate_true_assignment.has_value() || candidate_true_assignment->expression != "true") {
          continue;
        }
        auto candidate_true_after = next_non_empty(lines, candidate_true_assign_line.value() + 1);
        if (!candidate_true_after.has_value() || candidate_true_after.value() != candidate_else_line) {
          continue;
        }

        auto candidate_else_assign_line = next_non_empty(lines, candidate_else_line + 1);
        if (!candidate_else_assign_line.has_value() || candidate_else_assign_line.value() >= candidate_end_line) {
          continue;
        }
        auto candidate_else_assignment = parse_assignment_line(lines[candidate_else_assign_line.value()]);
        if (!candidate_else_assignment.has_value() ||
            candidate_else_assignment->variable != candidate_true_assignment->variable) {
          continue;
        }
        auto candidate_else_after = next_non_empty(lines, candidate_else_assign_line.value() + 1);
        if (!candidate_else_after.has_value() || candidate_else_after.value() != candidate_end_line) {
          continue;
        }

        auto target_regex = std::regex(std::format(
            R"((^|[^A-Za-z0-9_])({})([^A-Za-z0-9_]|$))",
            candidate_true_assignment->variable));
        bool referenced_before_nested_if = false;
        for (size_t line_index = i + 1; line_index < candidate; ++line_index) {
          if (std::regex_search(lines[line_index], target_regex)) {
            referenced_before_nested_if = true;
            break;
          }
        }
        if (referenced_before_nested_if) {
          continue;
        }

        if (outer_else_assignment->variable != candidate_true_assignment->variable) {
          continue;
        }

        nested_if_line = candidate;
        nested_else_line = candidate_else_line;
        nested_end_line = candidate_end_line;
        nested_if_indent = candidate_if->indent;
        target_variable_string = candidate_true_assignment->variable;
        default_expression_string = candidate_else_assignment->expression;
        break;
      }

      if (!nested_if_line.has_value() || !nested_else_line.has_value() || !nested_end_line.has_value()) {
        continue;
      }

      std::vector<std::string> rewritten_lines;
      rewritten_lines.reserve(lines.size() + 1);
      rewritten_lines.insert(rewritten_lines.end(), lines.begin(), lines.begin() + i);
      rewritten_lines.push_back(std::format("{}{} = {};", outer_if->indent, target_variable_string, default_expression_string));
      rewritten_lines.insert(rewritten_lines.end(), lines.begin() + i, lines.begin() + nested_else_line.value());
      rewritten_lines.push_back(std::format("{}}}", nested_if_indent));
      rewritten_lines.insert(rewritten_lines.end(), lines.begin() + nested_end_line.value() + 1, lines.end());

      lines = std::move(rewritten_lines);
      changed = true;
      i = 0;
    }

    if (!changed) {
      return std::string(hlsl);
    }

    std::stringstream output_stream;
    for (size_t i = 0; i < lines.size(); ++i) {
      output_stream << lines[i];
      if (i + 1 < lines.size()) {
        output_stream << "\n";
      }
    }
    return output_stream.str();
  }

  static std::string OptimizeRepeatedStoreAddresses(std::string_view hlsl) {
    static const std::regex SIMPLE_IDENTIFIER_REGEX(R"(^[A-Za-z_][A-Za-z0-9_]*$)");

    auto trim = [](std::string_view line) {
      return StringViewTrim(line);
    };
    auto parse_store_line = [&](const std::string& line)
        -> std::optional<std::tuple<std::string, std::string, std::string, std::string>> {
      auto trimmed = trim(line);
      if (!trimmed.ends_with("));")) {
        return std::nullopt;
      }

      auto store_pos = trimmed.find(".Store(");
      auto value_pos = trimmed.rfind(", asuint(");
      if (store_pos == std::string_view::npos || value_pos == std::string_view::npos || value_pos <= store_pos + 7) {
        return std::nullopt;
      }

      auto indent_length = line.find_first_not_of(" \t");
      if (indent_length == std::string::npos) {
        indent_length = line.size();
      }

      auto resource = std::string(trimmed.substr(0, store_pos));
      auto address = std::string(trimmed.substr(store_pos + 7, value_pos - (store_pos + 7)));
      static constexpr std::string_view VALUE_PREFIX = ", asuint(";
      auto value_start = value_pos + VALUE_PREFIX.size();
      auto value = std::string(trimmed.substr(value_start, trimmed.size() - value_start - 3));
      return std::tuple<std::string, std::string, std::string, std::string>(
          line.substr(0, indent_length), resource, address, value);
    };
    auto extract_identifiers = [&](std::string_view expression) {
      static const std::regex TOKEN_REGEX(R"([A-Za-z_][A-Za-z0-9_]*)");
      static const std::unordered_set<std::string> KEYWORDS = {
          "asuint", "int", "uint", "true", "false", "x", "y", "z", "w"};

      std::string expression_string(expression);
      std::vector<std::string> identifiers;
      std::unordered_set<std::string> seen;
      for (std::sregex_iterator it(expression_string.begin(), expression_string.end(), TOKEN_REGEX), end; it != end; ++it) {
        auto match_pos = static_cast<size_t>(it->position());
        if (match_pos > 0 && expression_string[match_pos - 1] == '.') {
          continue;
        }

        auto identifier = it->str();
        if (KEYWORDS.contains(identifier) || seen.contains(identifier)) {
          continue;
        }

        seen.insert(identifier);
        identifiers.push_back(std::move(identifier));
      }
      return identifiers;
    };
    auto line_assigns_identifier = [&](std::string_view line, std::string_view identifier) {
      auto trimmed = trim(line);
      if (trimmed.empty()) {
        return false;
      }

      size_t equals = std::string_view::npos;
      for (size_t i = 0; i < trimmed.size(); ++i) {
        if (trimmed[i] != '=') {
          continue;
        }
        if (i > 0 && (trimmed[i - 1] == '=' || trimmed[i - 1] == '!' || trimmed[i - 1] == '<' || trimmed[i - 1] == '>')) {
          continue;
        }
        if (i + 1 < trimmed.size() && trimmed[i + 1] == '=') {
          continue;
        }
        equals = i;
        break;
      }
      if (equals == std::string_view::npos) {
        return false;
      }

      auto lhs = trim(trimmed.substr(0, equals));
      auto last_space = lhs.find_last_of(" \t");
      auto tail = last_space == std::string_view::npos ? lhs : trim(lhs.substr(last_space + 1));
      return tail == identifier || tail.starts_with(std::format("{}[", identifier));
    };

    std::vector<std::string> lines;
    {
      std::stringstream line_stream{std::string(hlsl)};
      std::string line;
      while (std::getline(line_stream, line)) {
        lines.push_back(line);
      }
    }

    bool changed = false;
    int temp_index = 0;
    for (size_t i = 0; i < lines.size(); ++i) {
      auto first_store = parse_store_line(lines[i]);
      if (!first_store.has_value()) {
        continue;
      }

      auto [indent, resource, address, value] = first_store.value();
      if (std::regex_match(address, SIMPLE_IDENTIFIER_REGEX)) {
        continue;
      }
      auto identifiers = extract_identifiers(address);
      if (identifiers.empty()) {
        continue;
      }

      for (size_t j = i + 1; j < lines.size(); ++j) {
        auto second_store = parse_store_line(lines[j]);
        if (!second_store.has_value()) {
          continue;
        }

        auto [next_indent, next_resource, next_address, next_value] = second_store.value();
        if (next_resource != resource || next_address != address) {
          continue;
        }
        if (next_indent != indent) {
          continue;
        }

        bool assigned_between = false;
        for (size_t k = i + 1; k < j && !assigned_between; ++k) {
          auto trimmed_between = trim(lines[k]);
          if (trimmed_between.find('{') != std::string_view::npos || trimmed_between.find('}') != std::string_view::npos) {
            assigned_between = true;
            break;
          }
          for (const auto& identifier : identifiers) {
            if (line_assigns_identifier(lines[k], identifier)) {
              assigned_between = true;
              break;
            }
          }
        }
        if (assigned_between) {
          continue;
        }

        auto temp_name = std::format("_store_addr_{}", temp_index++);
        lines.insert(lines.begin() + i, std::format("{}int {} = {};", indent, temp_name, address));
        lines[i + 1] = std::format("{}{}.Store({}, asuint({}));", indent, resource, temp_name, value);
        lines[j + 1] = std::format("{}{}.Store({}, asuint({}));", next_indent, next_resource, temp_name, next_value);
        changed = true;
        i = 0;
        break;
      }
    }

    if (!changed) {
      return std::string(hlsl);
    }

    std::stringstream output_stream;
    for (size_t i = 0; i < lines.size(); ++i) {
      output_stream << lines[i];
      if (i + 1 < lines.size()) {
        output_stream << "\n";
      }
    }
    return output_stream.str();
  }

  static std::string OptimizeVisibilityBindlessIndices(std::string_view hlsl) {
    static const std::regex VISIBILITY_INDEX_LINE_REGEX(
        R"(^(\s*)uint\s+(_\d+)\s*=\s*\(\(_visibilityParams\[(.+)\]\)\.x\)\s*\*\s*3;\s*$)");
    static const std::regex VISIBILITY_OFFSET_LINE_REGEX(
        R"(^(\s*)int\s+(_\d+)\s*=\s*\(int\)\(SV_DispatchThreadID\.x\)\s*-\s*\(\(_visibilityParams\[(.+)\]\)\.w\);\s*$)");
    static const std::regex RENDER_INSTANCE_COUNT_LINE_REGEX(
        R"(^(\s*)uint\s+(_\d+)\s*=\s*\(_renderInstanceCollectionData\[\(int\)\((_\d+)\s*\+\s*2u\)\]\)\.y;\s*$)");

    auto trim = [](std::string_view line) {
      return StringViewTrim(line);
    };
    auto replace_all = [](std::string& input, const std::string& from, const std::string& to) {
      if (from.empty()) {
        return false;
      }
      bool changed = false;
      size_t pos = 0;
      while ((pos = input.find(from, pos)) != std::string::npos) {
        input.replace(pos, from.size(), to);
        pos += to.size();
        changed = true;
      }
      return changed;
    };

    std::vector<std::string> lines;
    {
      std::stringstream line_stream{std::string(hlsl)};
      std::string line;
      while (std::getline(line_stream, line)) {
        lines.push_back(line);
      }
    }

    bool changed = false;
    std::string selected_visibility_index_expression;
    std::string selected_visibility_index_var;
    std::string selected_dispatch_offset_var;
    for (size_t i = 0; i + 1 < lines.size(); ++i) {
      auto [visibility_indent, visibility_index_var, visibility_index_expression] =
          StringViewMatch<3>(lines[i], VISIBILITY_INDEX_LINE_REGEX);
      auto [offset_indent, dispatch_offset_var, visibility_offset_expression] =
          StringViewMatch<3>(lines[i + 1], VISIBILITY_OFFSET_LINE_REGEX);
      if (visibility_index_var.empty() || dispatch_offset_var.empty() ||
          visibility_index_expression != visibility_offset_expression || visibility_indent != offset_indent) {
        continue;
      }

      std::optional<size_t> render_instance_count_line;
      std::string render_instance_count_var;
      for (size_t j = i + 2; j < lines.size(); ++j) {
        auto trimmed = trim(lines[j]);
        if (trimmed.empty()) {
          continue;
        }

        auto [count_indent, count_var, count_index_var] =
            StringViewMatch<3>(lines[j], RENDER_INSTANCE_COUNT_LINE_REGEX);
        if (!count_var.empty() && count_index_var == visibility_index_var) {
          render_instance_count_line = j;
          render_instance_count_var = count_var;
        }
        break;
      }
      if (!render_instance_count_line.has_value()) {
        continue;
      }

      auto visibility_indent_string = std::string(visibility_indent);
      auto visibility_index_var_string = std::string(visibility_index_var);
      auto visibility_index_expression_string = std::string(visibility_index_expression);
      auto offset_indent_string = std::string(offset_indent);
      auto dispatch_offset_var_string = std::string(dispatch_offset_var);

      lines[i] = std::format("{}uint __visibility_param_index = {};", visibility_indent_string, visibility_index_expression_string);
      lines[i + 1] = std::format("{}int4 __visibility_param = _visibilityParams[__visibility_param_index];", visibility_indent_string);
      lines.insert(lines.begin() + i + 2, std::format("{}uint {} = (uint)(__visibility_param.x) * 3u;", visibility_indent_string, visibility_index_var_string));
      lines.insert(lines.begin() + i + 3, std::format("{}int {} = (int)(SV_DispatchThreadID.x) - __visibility_param.w;", offset_indent_string, dispatch_offset_var_string));

      auto count_line_index = render_instance_count_line.value() + 2;
      lines.insert(lines.begin() + count_line_index + 1, std::format("{}int __visibility_store_address = (int)(((uint)({} + __visibility_param.z)) << 2);", visibility_indent_string, dispatch_offset_var_string));
      lines.insert(lines.begin() + count_line_index + 2, std::format("{}uint4 __render_instance_collection_entry = _renderInstanceCollectionData[(int)({})];", visibility_indent_string, visibility_index_var_string));
      lines.insert(lines.begin() + count_line_index + 3, std::format("{}uint __object_bound_box_data_buffer_index = select((__render_instance_collection_entry.y < 40000u), __render_instance_collection_entry.y, 0u);", visibility_indent_string));
      lines.insert(lines.begin() + count_line_index + 4, std::format("{}uint __static_mesh_data_buffer_index = select((__render_instance_collection_entry.x < 40000u), __render_instance_collection_entry.x, 0u);", visibility_indent_string));

      changed = true;
      selected_visibility_index_expression = visibility_index_expression_string;
      selected_visibility_index_var = visibility_index_var_string;
      selected_dispatch_offset_var = dispatch_offset_var_string;
      break;
    }

    if (!changed) {
      return std::string(hlsl);
    }

    std::stringstream output_stream;
    for (size_t i = 0; i < lines.size(); ++i) {
      output_stream << lines[i];
      if (i + 1 < lines.size()) {
        output_stream << "\n";
      }
    }

    auto output = output_stream.str();
    auto visibility_y = std::format("((_visibilityParams[{}]).y)", selected_visibility_index_expression);
    auto visibility_z = std::format("((_visibilityParams[{}]).z)", selected_visibility_index_expression);
    auto visibility_store_address =
        std::format("((int)(((uint)({} + __visibility_param.z)) << 2))", selected_dispatch_offset_var);
    auto render_instance_y = std::format(
        "((int)((uint)(select(((uint)((_renderInstanceCollectionData[(int)({})]).y) < (uint)40000), ((_renderInstanceCollectionData[(int)({})]).y), 0)) + 0u))",
        selected_visibility_index_var,
        selected_visibility_index_var);
    auto render_instance_x = std::format(
        "((int)((uint)(select(((uint)((_renderInstanceCollectionData[(int)({})]).x) < (uint)40000), ((_renderInstanceCollectionData[(int)({})]).x), 0)) + 0u))",
        selected_visibility_index_var,
        selected_visibility_index_var);

    replace_all(output, visibility_y, "__visibility_param.y");
    replace_all(output, visibility_z, "__visibility_param.z");
    replace_all(output, visibility_store_address, "__visibility_store_address");
    replace_all(output, render_instance_y, "(int)(__object_bound_box_data_buffer_index)");
    replace_all(output, render_instance_x, "(int)(__static_mesh_data_buffer_index)");
    return output;
  }

  static std::string OptimizeVisibilityParamIndexSelection(std::string_view hlsl) {
    static const std::regex VISIBILITY_SELECTOR_LINE_REGEX(
        R"(^(\s*)uint\s+(__visibility_param_index)\s*=\s*\(uint\)\(\(uint\)\(\(\(int\)\(65535u\s*<<\s*(_\d+)\)\)\s*&\s*\((_\d+)\[\(\(\(uint\)\(SV_GroupID\.x\)\s*>>\s*1\)\s*&\s*3\)\]\)\)\)\s*>>\s*(_\d+)\s*;\s*$)");

    std::vector<std::string> lines;
    {
      std::stringstream line_stream{std::string(hlsl)};
      std::string line;
      while (std::getline(line_stream, line)) {
        lines.push_back(line);
      }
    }

    for (size_t i = 0; i < lines.size(); ++i) {
      auto [selector_indent, visibility_index_var, shift_variable_a, visibility_indices_array_var, shift_variable_b] =
          StringViewMatch<5>(lines[i], VISIBILITY_SELECTOR_LINE_REGEX);
      if (visibility_index_var.empty() || shift_variable_a != shift_variable_b) {
        continue;
      }

      auto declaration_line = std::find(lines.begin(), lines.end(), std::format("{}int {}[4];", selector_indent, visibility_indices_array_var));
      if (declaration_line == lines.end()) {
        continue;
      }

      std::array<size_t, 4> assignment_indices{};
      bool has_assignments = true;
      constexpr std::array<std::string_view, 4> suffixes = {"x", "y", "z", "w"};
      for (size_t component_index = 0; component_index < suffixes.size(); ++component_index) {
        auto assignment_it = std::find(
            lines.begin(),
            lines.end(),
            std::format(
                "{}{}[{}] = ((_visibilityParamIndices[(uint)(SV_GroupID.x) >> 3]).{});",
                selector_indent,
                visibility_indices_array_var,
                component_index,
                suffixes[component_index]));
        if (assignment_it == lines.end()) {
          has_assignments = false;
          break;
        }
        assignment_indices[component_index] = static_cast<size_t>(std::distance(lines.begin(), assignment_it));
      }
      if (!has_assignments) {
        continue;
      }

      size_t array_reference_count = 0;
      auto array_reference = std::format("{}[", visibility_indices_array_var);
      for (const auto& line : lines) {
        if (line.find(array_reference) != std::string::npos) {
          array_reference_count += 1;
        }
      }
      if (array_reference_count != 5) {
        continue;
      }

      auto declaration_index = static_cast<size_t>(std::distance(lines.begin(), declaration_line));
      lines[declaration_index] =
          std::format("{}int4 __visibility_param_indices_entry = _visibilityParamIndices[(uint)(SV_GroupID.x) >> 3];", selector_indent);
      for (auto assignment_index : assignment_indices) {
        lines[assignment_index].clear();
      }
      lines.insert(
          lines.begin() + i,
          std::format(
              "{}int __visibility_param_index_component = __visibility_param_indices_entry[(((uint)(SV_GroupID.x) >> 1) & 3)];",
              selector_indent));
      lines[i + 1] = std::format(
          "{}uint __visibility_param_index = (uint)((uint)(((int)(65535u << {})) & (__visibility_param_index_component))) >> {};",
          selector_indent,
          shift_variable_a,
          shift_variable_a);

      std::stringstream output_stream;
      for (size_t line_index = 0; line_index < lines.size(); ++line_index) {
        if (lines[line_index].empty()) {
          continue;
        }
        output_stream << lines[line_index];
        if (line_index + 1 < lines.size()) {
          output_stream << "\n";
        }
      }
      return output_stream.str();
    }

    return std::string(hlsl);
  }

  static std::string OptimizeVectorComponentTempArrays(std::string_view hlsl) {
    static const auto ARRAY_DECL_REGEX = std::regex(
        R"(^(\s*)(int|uint|float|half|int16_t|uint16_t|min16float|int64_t|uint64_t)\s+(_\d+)\[4\];\s*$)");
    static const auto ARRAY_ASSIGN_REGEX =
        std::regex(R"(^(\s*)(_\d+)\[(\d)\]\s*=\s*\(\((.+)\)\.([xyzw])\);\s*$)");
    static const auto ARRAY_INDEX_USE_REGEX = std::regex(
        R"(^(\s*)(int|uint|float|half|int16_t|uint16_t|min16float|int64_t|uint64_t)\s+(_\d+)\s*=\s*(_\d+)\[(.+)\];\s*$)");

    std::vector<std::string> lines;
    {
      std::stringstream line_stream{std::string(hlsl)};
      std::string line;
      while (std::getline(line_stream, line)) {
        lines.push_back(line);
      }
    }

    bool changed = false;
    for (size_t i = 0; i < lines.size(); ++i) {
      auto [decl_indent, decl_type, array_var] = StringViewMatch<3>(lines[i], ARRAY_DECL_REGEX);
      if (array_var.empty()) {
        continue;
      }

      size_t reference_count = 0;
      auto array_reference = std::format("{}[", array_var);
      for (const auto& line : lines) {
        if (line.find(array_reference) != std::string::npos) {
          reference_count += 1;
        }
      }
      if (reference_count != 6) {
        continue;
      }

      std::array<size_t, 4> assignment_indices{};
      std::array<bool, 4> has_assignment{};
      std::string base_expression;
      std::optional<size_t> use_index;
      std::string use_indent;
      std::string use_type;
      std::string use_variable;
      std::string lane_expression;
      bool invalid = false;

      for (size_t j = i + 1; j < lines.size(); ++j) {
        if (lines[j].find(array_reference) == std::string::npos) {
          continue;
        }

        auto [assign_indent, assign_var, component_index, assign_base, component_swizzle] =
            StringViewMatch<5>(lines[j], ARRAY_ASSIGN_REGEX);
        if (!assign_var.empty() && assign_var == array_var && assign_indent == decl_indent) {
          int parsed_component_index = -1;
          FromStringView(component_index, parsed_component_index);
          if (parsed_component_index < 0 || parsed_component_index > 3) {
            invalid = true;
            break;
          }
          if (component_swizzle.size() != 1 || component_swizzle[0] != VECTOR_INDEXES[parsed_component_index]) {
            invalid = true;
            break;
          }
          if (has_assignment[parsed_component_index]) {
            invalid = true;
            break;
          }
          auto assign_base_string = std::string(StringViewTrim(assign_base));
          if (base_expression.empty()) {
            base_expression = assign_base_string;
          } else if (base_expression != assign_base_string) {
            invalid = true;
            break;
          }
          has_assignment[parsed_component_index] = true;
          assignment_indices[parsed_component_index] = j;
          continue;
        }

        auto [match_use_indent, match_use_type, match_use_variable, match_array_var, match_lane_expression] =
            StringViewMatch<5>(lines[j], ARRAY_INDEX_USE_REGEX);
        if (!match_use_variable.empty() && match_array_var == array_var) {
          if (use_index.has_value()) {
            invalid = true;
            break;
          }
          use_index = j;
          use_indent = std::string(match_use_indent);
          use_type = std::string(match_use_type);
          use_variable = std::string(match_use_variable);
          lane_expression = std::string(StringViewTrim(match_lane_expression));
          continue;
        }

        invalid = true;
        break;
      }

      if (invalid || !use_index.has_value()) {
        continue;
      }
      if (!std::ranges::all_of(has_assignment, [](bool value) { return value; })) {
        continue;
      }

      lines[i].clear();
      for (auto assignment_index : assignment_indices) {
        lines[assignment_index].clear();
      }
      lines[use_index.value()] = std::format(
          "{}{} {} = ({})({}[{}]);",
          use_indent,
          use_type,
          use_variable,
          use_type,
          base_expression,
          lane_expression);
      changed = true;
    }

    if (!changed) {
      return std::string(hlsl);
    }

    std::stringstream output_stream;
    bool first_line = true;
    for (const auto& line : lines) {
      if (line.empty()) {
        continue;
      }
      if (!first_line) {
        output_stream << "\n";
      }
      output_stream << line;
      first_line = false;
    }
    return output_stream.str();
  }

  static std::string OptimizeUnusedLocalAssignments(std::string_view hlsl) {
    static const auto DECL_REGEX =
        std::regex(R"(^(\s*)(?:bool|int|uint|float|half|int16_t|uint16_t|min16float|int64_t|uint64_t)\s+((?:_\d+)|(?:__defer_\d+_\d+)|(?:__branch_chain_\d+))\s*;\s*$)");
    static const auto DECL_ASSIGN_REGEX =
        std::regex(R"(^(\s*)(?:bool|int|uint|float|half|int16_t|uint16_t|min16float|int64_t|uint64_t)\s+((?:_\d+)|(?:__defer_\d+_\d+)|(?:__branch_chain_\d+))\s*=.*;\s*$)");
    static const auto ASSIGN_REGEX =
        std::regex(R"(^(\s*)((?:_\d+)|(?:__defer_\d+_\d+)|(?:__branch_chain_\d+))\s*=.*;\s*$)");
    static const auto VARIABLE_REGEX =
        std::regex(R"((^|[^A-Za-z0-9_])((?:_\d+)|(?:__defer_\d+_\d+)|(?:__branch_chain_\d+))(?=$|[^A-Za-z0-9_]))");

    std::vector<std::string> lines;
    {
      std::stringstream line_stream{std::string(hlsl)};
      std::string line;
      while (std::getline(line_stream, line)) {
        lines.push_back(line);
      }
    }

    struct LineInfo {
      std::vector<std::string> references;
      std::string target_variable;
    };

    std::vector<LineInfo> line_infos(lines.size());
    std::unordered_map<std::string, size_t> occurrence_counts;
    std::unordered_map<std::string, std::vector<size_t>> removable_lines_by_variable;

    for (size_t i = 0; i < lines.size(); ++i) {
      for (auto it = std::sregex_iterator(lines[i].begin(), lines[i].end(), VARIABLE_REGEX);
           it != std::sregex_iterator();
           ++it) {
        auto variable = (*it)[2].str();
        line_infos[i].references.push_back(variable);
        occurrence_counts[variable] += 1;
      }

      auto [decl_indent, decl_variable] = StringViewMatch<2>(lines[i], DECL_REGEX);
      auto [decl_assign_indent, decl_assign_variable] = StringViewMatch<2>(lines[i], DECL_ASSIGN_REGEX);
      auto [assign_indent, assign_variable] = StringViewMatch<2>(lines[i], ASSIGN_REGEX);
      if (!decl_variable.empty()) {
        line_infos[i].target_variable = std::string(decl_variable);
      } else if (!decl_assign_variable.empty()) {
        line_infos[i].target_variable = std::string(decl_assign_variable);
      } else if (!assign_variable.empty()) {
        line_infos[i].target_variable = std::string(assign_variable);
      }

      if (!line_infos[i].target_variable.empty()) {
        removable_lines_by_variable[line_infos[i].target_variable].push_back(i);
      }
    }

    bool changed = false;
    std::vector<bool> removed(lines.size(), false);
    while (true) {
      std::vector<size_t> lines_to_remove;

      for (const auto& [variable, removable_lines] : removable_lines_by_variable) {
        size_t active_line_count = 0;
        for (auto line_index : removable_lines) {
          if (!removed[line_index]) {
            active_line_count += 1;
          }
        }
        if (active_line_count == 0) {
          continue;
        }
        auto occurrence_it = occurrence_counts.find(variable);
        size_t occurrence_count = occurrence_it == occurrence_counts.end() ? 0 : occurrence_it->second;
        if (occurrence_count != active_line_count) {
          continue;
        }
        for (auto line_index : removable_lines) {
          if (!removed[line_index]) {
            lines_to_remove.push_back(line_index);
          }
        }
      }

      if (lines_to_remove.empty()) {
        break;
      }

      std::ranges::sort(lines_to_remove);
      lines_to_remove.erase(std::unique(lines_to_remove.begin(), lines_to_remove.end()), lines_to_remove.end());
      for (auto line_index : lines_to_remove) {
        removed[line_index] = true;
        for (const auto& reference : line_infos[line_index].references) {
          auto occurrence_it = occurrence_counts.find(reference);
          if (occurrence_it != occurrence_counts.end() && occurrence_it->second > 0) {
            occurrence_it->second -= 1;
          }
        }
      }
      changed = true;
    }

    if (!changed) {
      return std::string(hlsl);
    }

    std::stringstream output_stream;
    for (size_t i = 0; i < lines.size(); ++i) {
      if (removed[i]) {
        continue;
      }
      output_stream << lines[i];
      if (i + 1 < lines.size()) {
        output_stream << "\n";
      }
    }
    return output_stream.str();
  }

  static std::string OptimizeDeferredSiblingGuards(std::string_view hlsl) {
    static const auto DEFER_DECL_REGEX =
        std::regex(R"(^(\s*)bool (__defer_(\d+)_(\d+)) = false;\s*$)");
    static const auto DEFER_ASSIGN_TRUE_REGEX =
        std::regex(R"(^(\s*)(__defer_\d+_\d+) = true;\s*$)");
    static const auto DEFER_IF_REGEX =
        std::regex(R"(^(\s*)if \((__defer_\d+_\d+)\) \{\s*$)");

    std::vector<std::string> lines;
    {
      std::stringstream line_stream{std::string(hlsl)};
      std::string line;
      while (std::getline(line_stream, line)) {
        lines.push_back(line);
      }
    }

    auto count_variable_references = [&](std::string_view variable) {
      auto variable_regex = std::regex(std::format(R"((^|[^A-Za-z0-9_]){}([^A-Za-z0-9_]|$))", variable));
      size_t count = 0;
      for (const auto& line : lines) {
        if (std::regex_search(line, variable_regex)) {
          ++count;
        }
      }
      return count;
    };

    bool changed = false;
    for (size_t i = 0; i + 1 < lines.size(); ++i) {
      auto [indent_a, flag_a, root_a, target_a] = StringViewMatch<4>(lines[i], DEFER_DECL_REGEX);
      auto [indent_b, flag_b, root_b, target_b] = StringViewMatch<4>(lines[i + 1], DEFER_DECL_REGEX);
      if (flag_a.empty() || flag_b.empty()) continue;
      if (indent_a != indent_b || root_a != root_b) continue;
      if (count_variable_references(flag_a) < 2) continue;

      std::optional<size_t> if_a_line;
      std::optional<size_t> if_b_line;
      std::vector<size_t> assign_a_lines;
      for (size_t j = i + 2; j < lines.size(); ++j) {
        auto [assign_indent, assign_flag] = StringViewMatch<2>(lines[j], DEFER_ASSIGN_TRUE_REGEX);
        if (assign_flag == flag_a) {
          assign_a_lines.push_back(j);
        }

        auto [if_indent, if_flag] = StringViewMatch<2>(lines[j], DEFER_IF_REGEX);
        if (if_flag == flag_a && if_indent == indent_a && !if_a_line.has_value()) {
          if_a_line = j;
        } else if (if_flag == flag_b && if_indent == indent_b && if_a_line.has_value()) {
          if_b_line = j;
          break;
        }
      }

      if (!if_a_line.has_value() || !if_b_line.has_value() || assign_a_lines.empty()) {
        continue;
      }

      const auto expected_reference_count = assign_a_lines.size() + 2;
      if (count_variable_references(flag_a) != expected_reference_count) {
        continue;
      }

      lines[if_a_line.value()] = std::format("{}if (!{}) {{", indent_a, flag_b);

      std::vector<size_t> remove_lines = {i};
      remove_lines.insert(remove_lines.end(), assign_a_lines.begin(), assign_a_lines.end());
      std::ranges::sort(remove_lines);
      for (auto line_it = remove_lines.rbegin(); line_it != remove_lines.rend(); ++line_it) {
        auto removed_line = *line_it;
        lines.erase(lines.begin() + removed_line);
        if (removed_line < i) {
          --i;
        }
      }
      changed = true;
      if (i != 0) {
        --i;
      }
    }

    if (!changed) {
      return std::string(hlsl);
    }

    std::stringstream output_stream;
    for (size_t i = 0; i < lines.size(); ++i) {
      output_stream << lines[i];
      if (i + 1 < lines.size()) {
        output_stream << "\n";
      }
    }
    return output_stream.str();
  }

  static std::string OptimizeDeferredSelectorSentinels(std::string_view hlsl) {
    static const auto DEFER_DECL_REGEX =
        std::regex(R"(^(\s*)bool (__defer_(\d+)_(\d+)) = false;\s*$)");
    static const auto DEFER_ASSIGN_TRUE_REGEX =
        std::regex(R"(^(\s*)(__defer_\d+_\d+) = true;\s*$)");
    static const auto SELECTOR_ASSIGN_REGEX =
        std::regex(R"(^(\s*)(_\d+) = ([0-9]+);\s*$)");
    static const auto DEFER_IF_REGEX =
        std::regex(R"(^(\s*)if \((!?)(__defer_\d+_\d+)\) \{\s*$)");
    static const auto VARIABLE_REGEX =
        std::regex(R"((^|[^A-Za-z0-9_])((?:__defer_\d+_\d+)|(?:_\d+))([^A-Za-z0-9_]|$))");

    std::vector<std::string> lines;
    {
      std::stringstream line_stream{std::string(hlsl)};
      std::string line;
      while (std::getline(line_stream, line)) {
        lines.push_back(line);
      }
    }

    auto count_variable_references = [&](std::string_view variable) {
      auto variable_regex = std::regex(std::format(R"((^|[^A-Za-z0-9_]){}([^A-Za-z0-9_]|$))", variable));
      size_t count = 0;
      for (const auto& line : lines) {
        if (std::regex_search(line, variable_regex)) {
          ++count;
        }
      }
      return count;
    };

    auto line_indent = [&](size_t line_index) {
      auto first_non_space = lines[line_index].find_first_not_of(' ');
      if (first_non_space == std::string::npos) {
        return std::string{};
      }
      return std::string(first_non_space, ' ');
    };

    auto previous_non_empty_line = [&](size_t start) -> std::optional<size_t> {
      for (size_t j = start; j-- > 0;) {
        if (!StringViewTrim(lines[j]).empty()) {
          return j;
        }
      }
      return std::nullopt;
    };

    bool changed = false;
    for (size_t i = 0; i < lines.size(); ++i) {
      auto [decl_indent, defer_flag, defer_root, defer_target] = StringViewMatch<4>(lines[i], DEFER_DECL_REGEX);
      if (defer_flag.empty()) {
        continue;
      }
      auto indent = line_indent(i);
      auto flag = std::string(defer_flag);

      std::vector<size_t> assign_lines;
      std::string selector_variable;
      std::optional<size_t> false_guard_line;
      std::optional<size_t> true_guard_line;
      for (size_t j = i + 1; j < lines.size(); ++j) {
        auto [if_indent, if_negated, if_defer_flag] = StringViewMatch<3>(lines[j], DEFER_IF_REGEX);
        if (if_defer_flag == flag) {
          if (if_negated == "!") {
            false_guard_line = j;
          } else if (true_guard_line == std::nullopt) {
            true_guard_line = j;
            break;
          }
        }

        auto [assign_indent, assign_flag] = StringViewMatch<2>(lines[j], DEFER_ASSIGN_TRUE_REGEX);
        if (assign_flag != flag) {
          continue;
        }
        auto previous_line = previous_non_empty_line(j);
        if (!previous_line.has_value()) {
          assign_lines.clear();
          break;
        }

        auto [selector_indent, selector_name, selector_value] =
            StringViewMatch<3>(lines[previous_line.value()], SELECTOR_ASSIGN_REGEX);
        if (selector_name.empty()) {
          assign_lines.clear();
          break;
        }
        if (selector_variable.empty()) {
          selector_variable = selector_name;
        } else if (selector_variable != selector_name) {
          assign_lines.clear();
          break;
        }
        assign_lines.push_back(j);
      }

      if (selector_variable.empty() || assign_lines.empty() || !false_guard_line.has_value() || !true_guard_line.has_value()) {
        continue;
      }

      const auto expected_reference_count = assign_lines.size() + 3;
      if (count_variable_references(flag) != expected_reference_count) {
        continue;
      }

      lines[i] = std::format("{}{} = -1;", indent, selector_variable);
      lines[false_guard_line.value()] =
          std::format("{}if ({} == -1) {{", line_indent(false_guard_line.value()), selector_variable);
      lines[true_guard_line.value()] =
          std::format("{}if ({} != -1) {{", line_indent(true_guard_line.value()), selector_variable);

      std::ranges::sort(assign_lines);
      for (auto assign_it = assign_lines.rbegin(); assign_it != assign_lines.rend(); ++assign_it) {
        auto removed_line = *assign_it;
        lines.erase(lines.begin() + removed_line);
        if (removed_line < false_guard_line.value()) {
          false_guard_line = false_guard_line.value() - 1;
        }
        if (removed_line < true_guard_line.value()) {
          true_guard_line = true_guard_line.value() - 1;
        }
      }
      changed = true;
    }

    if (!changed) {
      return std::string(hlsl);
    }

    std::stringstream output_stream;
    for (size_t i = 0; i < lines.size(); ++i) {
      output_stream << lines[i];
      if (i + 1 < lines.size()) {
        output_stream << "\n";
      }
    }
    return output_stream.str();
  }

  static std::string OptimizeNestedReductionLoops(std::string_view hlsl) {
    static const auto IF_POSITIVE_REGEX = std::regex(R"(^(\s*)if \(\(int\)(_\d+) > \(int\)0\) \{\s*$)");
    static const auto ASSIGN_ZERO_INT_REGEX = std::regex(R"(^(\s*)(_\d+) = 0;\s*$)");
    static const auto ASSIGN_ZERO_FLOAT_REGEX = std::regex(R"(^(\s*)(_\d+) = 0\.0f;\s*$)");
    static const auto WHILE_TRUE_REGEX = std::regex(R"(^(\s*)while\(true\) \{\s*$)");
    static const auto ASSIGN_COPY_REGEX = std::regex(R"(^(\s*)(_\d+) = (_\d+);\s*$)");
    static const auto SAMPLE_MAX_REGEX = std::regex(R"(^(\s*)float (_\d+) = max\((_\d+), (_\d+)\.x\);\s*$)");
    static const auto NEXT_INDEX_REGEX = std::regex(R"(^(\s*)int (_\d+) = (_\d+) \+ 1;\s*$)");
    static const auto BOUNDED_IF_REGEX =
        std::regex(R"(^(\s*)if \(\(\(\(int\)(_\d+) < \(int\)(_\d+)\)\) && \(\(\(int\)(_\d+) < \(int\)8\)\)\) \{\s*$)");
    static const auto CONTINUE_REGEX = std::regex(R"(^(\s*)continue;\s*$)");
    static const auto BREAK_REGEX = std::regex(R"(^(\s*)break;\s*$)");
    static const auto ELSE_REGEX = std::regex(R"(^(\s*)\} else \{\s*$)");
    static const auto CLOSE_REGEX = std::regex(R"(^(\s*)\}\s*$)");

    std::vector<std::string> lines;
    {
      std::stringstream line_stream{std::string(hlsl)};
      std::string line;
      while (std::getline(line_stream, line)) {
        lines.push_back(line);
      }
    }

    bool changed = false;
    for (size_t i = 0; i + 33 < lines.size(); ++i) {
      auto [indent, outer_count] = StringViewMatch<2>(lines[i], IF_POSITIVE_REGEX);
      auto [assign_zero_indent, outer_index] = StringViewMatch<2>(lines[i + 1], ASSIGN_ZERO_INT_REGEX);
      auto [assign_zero_float_indent, outer_acc] = StringViewMatch<2>(lines[i + 2], ASSIGN_ZERO_FLOAT_REGEX);
      auto [outer_loop_indent] = StringViewMatch<1>(lines[i + 3], WHILE_TRUE_REGEX);
      auto [inner_if_indent, inner_count] = StringViewMatch<2>(lines[i + 4], IF_POSITIVE_REGEX);
      auto [inner_zero_indent, inner_index] = StringViewMatch<2>(lines[i + 5], ASSIGN_ZERO_INT_REGEX);
      auto [inner_copy_indent, inner_acc, copied_outer_acc] = StringViewMatch<3>(lines[i + 6], ASSIGN_COPY_REGEX);
      auto [inner_loop_indent] = StringViewMatch<1>(lines[i + 7], WHILE_TRUE_REGEX);
      auto [sample_max_indent, sample_max, sample_acc, sample_vec] = StringViewMatch<4>(lines[i + 9], SAMPLE_MAX_REGEX);
      auto [next_inner_indent, next_inner, next_inner_source] = StringViewMatch<3>(lines[i + 10], NEXT_INDEX_REGEX);
      auto [inner_bound_indent, inner_bound_var_a, inner_bound_limit, inner_bound_var_b] =
          StringViewMatch<4>(lines[i + 11], BOUNDED_IF_REGEX);
      auto [inner_assign_indent, inner_assign_index, inner_assign_value] = StringViewMatch<3>(lines[i + 12], ASSIGN_COPY_REGEX);
      auto [inner_acc_assign_indent, inner_acc_assign_target, inner_acc_assign_value] = StringViewMatch<3>(lines[i + 13], ASSIGN_COPY_REGEX);
      auto [inner_continue_indent] = StringViewMatch<1>(lines[i + 14], CONTINUE_REGEX);
      auto [inner_if_end_indent] = StringViewMatch<1>(lines[i + 15], CLOSE_REGEX);
      auto [result_assign_indent, result_var, result_value] = StringViewMatch<3>(lines[i + 16], ASSIGN_COPY_REGEX);
      auto [inner_break_indent] = StringViewMatch<1>(lines[i + 17], BREAK_REGEX);
      auto [inner_loop_end_indent] = StringViewMatch<1>(lines[i + 18], CLOSE_REGEX);
      auto [else_indent] = StringViewMatch<1>(lines[i + 19], ELSE_REGEX);
      auto [else_result_indent, else_result_var, else_result_value] = StringViewMatch<3>(lines[i + 20], ASSIGN_COPY_REGEX);
      auto [else_end_indent] = StringViewMatch<1>(lines[i + 21], CLOSE_REGEX);
      auto [next_outer_indent, next_outer, next_outer_source] = StringViewMatch<3>(lines[i + 22], NEXT_INDEX_REGEX);
      auto [outer_bound_indent, outer_bound_var_a, outer_bound_limit, outer_bound_var_b] =
          StringViewMatch<4>(lines[i + 23], BOUNDED_IF_REGEX);
      auto [outer_assign_indent, outer_assign_index, outer_assign_value] = StringViewMatch<3>(lines[i + 24], ASSIGN_COPY_REGEX);
      auto [outer_acc_assign_indent, outer_acc_assign_target, outer_acc_assign_value] = StringViewMatch<3>(lines[i + 25], ASSIGN_COPY_REGEX);
      auto [outer_continue_indent] = StringViewMatch<1>(lines[i + 26], CONTINUE_REGEX);
      auto [outer_if_end_indent] = StringViewMatch<1>(lines[i + 27], CLOSE_REGEX);
      auto [final_assign_indent, final_var, final_value] = StringViewMatch<3>(lines[i + 28], ASSIGN_COPY_REGEX);
      auto [outer_break_indent] = StringViewMatch<1>(lines[i + 29], BREAK_REGEX);
      auto [outer_loop_end_indent_2] = StringViewMatch<1>(lines[i + 30], CLOSE_REGEX);
      auto [outer_else_indent] = StringViewMatch<1>(lines[i + 31], ELSE_REGEX);
      auto [outer_else_assign_indent, outer_else_var] = StringViewMatch<2>(lines[i + 32], ASSIGN_ZERO_FLOAT_REGEX);
      auto [outer_if_end_indent_2] = StringViewMatch<1>(lines[i + 33], CLOSE_REGEX);

      if (outer_count.empty() || outer_index.empty() || outer_acc.empty() || inner_count.empty()
          || inner_index.empty() || inner_acc.empty() || sample_max.empty() || sample_vec.empty()
          || next_inner.empty() || result_var.empty() || next_outer.empty() || final_var.empty()) {
        continue;
      }
      if (copied_outer_acc != outer_acc
          || sample_acc != inner_acc
          || next_inner_source != inner_index
          || inner_bound_var_a != next_inner
          || inner_bound_var_b != next_inner
          || inner_bound_limit != inner_count
          || inner_assign_index != inner_index
          || inner_assign_value != next_inner
          || inner_acc_assign_target != inner_acc
          || inner_acc_assign_value != sample_max
          || result_value != sample_max
          || else_result_var != result_var
          || else_result_value != outer_acc
          || next_outer_source != outer_index
          || outer_bound_var_a != next_outer
          || outer_bound_var_b != next_outer
          || outer_bound_limit != outer_count
          || outer_assign_index != outer_index
          || outer_assign_value != next_outer
          || outer_acc_assign_target != outer_acc
          || outer_acc_assign_value != result_var
          || final_value != result_var
          || outer_else_var != final_var) {
        continue;
      }

      auto indent_string = std::string(indent);
      std::vector<std::string> replacement = {
          std::format("{}if ((int){} > (int)0) {{", indent_string, outer_count),
          std::format("{}  {} = 0;", indent_string, outer_index),
          std::format("{}  {} = 0.0f;", indent_string, outer_acc),
          std::format("{}  int {};", indent_string, next_outer),
          std::format("{}  do {{", indent_string),
          std::format("{}    if ((int){} > (int)0) {{", indent_string, inner_count),
          std::format("{}      {} = 0;", indent_string, inner_index),
          std::format("{}      {} = {};", indent_string, inner_acc, outer_acc),
          std::format("{}      int {};", indent_string, next_inner),
          std::format("{}      do {{", indent_string),
          std::format("{}        {}", indent_string, lines[i + 8].substr(indent_string.size() + 8)),
          std::format("{}        {} = max({}, {}.x);", indent_string, inner_acc, inner_acc, sample_vec),
          std::format("{}        {} = {} + 1;", indent_string, next_inner, inner_index),
          std::format(
              "{}        if ((((int){} < (int){})) && (((int){} < (int)8))) {{",
              indent_string,
              next_inner,
              inner_count,
              next_inner),
          std::format("{}          {} = {};", indent_string, inner_index, next_inner),
          std::format("{}        }}", indent_string),
          std::format(
              "{}      }} while ((((int){} < (int){})) && (((int){} < (int)8)));",
              indent_string,
              next_inner,
              inner_count,
              next_inner),
          std::format("{}      {} = {};", indent_string, result_var, inner_acc),
          std::format("{}    }} else {{", indent_string),
          std::format("{}      {} = {};", indent_string, result_var, outer_acc),
          std::format("{}    }}", indent_string),
          std::format("{}    {} = {};", indent_string, outer_acc, result_var),
          std::format("{}    {} = {} + 1;", indent_string, next_outer, outer_index),
          std::format(
              "{}    if ((((int){} < (int){})) && (((int){} < (int)8))) {{",
              indent_string,
              next_outer,
              outer_count,
              next_outer),
          std::format("{}      {} = {};", indent_string, outer_index, next_outer),
          std::format("{}    }}", indent_string),
          std::format(
              "{}  }} while ((((int){} < (int){})) && (((int){} < (int)8)));",
              indent_string,
              next_outer,
              outer_count,
              next_outer),
          std::format("{}  {} = {};", indent_string, final_var, result_var),
          std::format("{}}} else {{", indent_string),
          std::format("{}  {} = 0.0f;", indent_string, final_var),
          std::format("{}}}", indent_string),
      };

      lines.erase(lines.begin() + i, lines.begin() + i + 34);
      lines.insert(lines.begin() + i, replacement.begin(), replacement.end());
      changed = true;
      if (i != 0) {
        --i;
      }
    }

    if (!changed) {
      return std::string(hlsl);
    }

    std::stringstream output_stream;
    for (size_t i = 0; i < lines.size(); ++i) {
      output_stream << lines[i];
      if (i + 1 < lines.size()) {
        output_stream << "\n";
      }
    }
    return output_stream.str();
  }

  static std::string OptimizeUpperBoundGuardLoads(std::string_view hlsl) {
    static const auto RANGE_GUARD_REGEX =
        std::regex(R"(^(\s*)if \(\(\(\(int\)(_\d+) > \(int\)-1\)\) && \(\(\(uint\)\2 < \(uint\)\((.+)\)\)\)\) \{\s*$)");
    static const auto VARIABLE_REGEX = std::regex(R"((^|[^A-Za-z0-9_])_(\d+)([^A-Za-z0-9_]|$))");
    static const auto SIMPLE_ASSIGN_REGEX =
        std::regex(R"(^(\s*)(?:[A-Za-z_][A-Za-z0-9_<> \[\]]+\s+)?(_\d+)\s*= .+;\s*$)");

    std::vector<std::string> lines;
    {
      std::stringstream line_stream{std::string(hlsl)};
      std::string line;
      while (std::getline(line_stream, line)) {
        lines.push_back(line);
      }
    }

    uint32_t next_variable = 0;
    for (const auto& line : lines) {
      for (auto it = std::sregex_iterator(line.begin(), line.end(), VARIABLE_REGEX);
           it != std::sregex_iterator();
           ++it) {
        uint32_t current_variable = 0;
        FromStringView((*it)[2].str(), current_variable);
        next_variable = std::max(next_variable, current_variable + 1);
      }
    }

    bool changed = false;
    for (size_t i = 0; i < lines.size(); ++i) {
      auto [indent, lower_bound_variable, upper_bound_expression] = StringViewMatch<3>(lines[i], RANGE_GUARD_REGEX);
      if (lower_bound_variable.empty() || upper_bound_expression.empty()) {
        continue;
      }

      auto upper_bound_variable = [&]() {
        auto [preferred_index_text] = StringViewMatch<1>(lower_bound_variable, std::regex(R"(^_(\d+)$)"));
        if (preferred_index_text.empty()) {
          return std::format("_{}", next_variable++);
        }
        uint32_t preferred_index = 0;
        FromStringView(preferred_index_text, preferred_index);
        auto preferred_variable = std::format("_{}", preferred_index + 1);
        auto preferred_regex = std::regex(std::format(R"((^|[^A-Za-z0-9_]){}([^A-Za-z0-9_]|$))", preferred_variable));
        bool preferred_used = false;
        for (const auto& line : lines) {
          if (std::regex_search(line, preferred_regex)) {
            preferred_used = true;
            break;
          }
        }
        if (!preferred_used) {
          next_variable = std::max(next_variable, preferred_index + 2);
          return preferred_variable;
        }
        return std::format("_{}", next_variable++);
      }();

      size_t insertion_index = i;
      for (size_t j = i; j-- > 0;) {
        auto [assign_indent, assign_variable] = StringViewMatch<2>(lines[j], SIMPLE_ASSIGN_REGEX);
        if (assign_variable == lower_bound_variable && assign_indent == indent) {
          insertion_index = j + 1;
          break;
        }
      }

      lines.insert(
          lines.begin() + insertion_index,
          std::format("{}uint {} = {};", indent, upper_bound_variable, upper_bound_expression));
      if (insertion_index <= i) {
        ++i;
      }
      lines[i] = std::format(
          "{}if ((((int){} > (int)-1)) && (((uint){} < {}))) {{",
          indent,
          lower_bound_variable,
          lower_bound_variable,
          upper_bound_variable);
      changed = true;
    }

    if (!changed) {
      return std::string(hlsl);
    }

    std::stringstream output_stream;
    for (size_t i = 0; i < lines.size(); ++i) {
      output_stream << lines[i];
      if (i + 1 < lines.size()) {
        output_stream << "\n";
      }
    }
    return output_stream.str();
  }

  static std::string OptimizeVectorMaskedDots(std::string_view hlsl) {
    static const auto SELECT_LINE_REGEX =
        std::regex(R"(^(\s*)float ([A-Za-z_][A-Za-z0-9_]*) = select\(([^,]+), ([^,]+)\.([xyzw]), (.+)\);\s*$)");
    static const auto DOT_LINE_REGEX =
        std::regex(R"(^(\s*)float ([A-Za-z_][A-Za-z0-9_]*) = dot\(float3\(([A-Za-z_][A-Za-z0-9_]*), ([A-Za-z_][A-Za-z0-9_]*), ([A-Za-z_][A-Za-z0-9_]*)\), (.+)\);\s*$)");

    std::vector<std::string> lines;
    {
      std::stringstream line_stream{std::string(hlsl)};
      std::string line;
      while (std::getline(line_stream, line)) {
        lines.push_back(line);
      }
    }

    auto count_variable_references = [&](std::string_view variable) {
      auto variable_regex = std::regex(std::format(R"((^|[^A-Za-z0-9_]){}([^A-Za-z0-9_]|$))", variable));
      size_t count = 0;
      for (const auto& line : lines) {
        if (std::regex_search(line, variable_regex)) {
          ++count;
        }
      }
      return count;
    };

    auto make_vector_name = [](std::string_view first_variable, std::string_view last_variable, size_t fallback_index) {
      if (first_variable.starts_with("_") && last_variable.starts_with("_")) {
        return std::format("{}_{}", first_variable, last_variable.substr(1));
      }
      return std::format("__vector_mask_{}", fallback_index);
    };

    bool changed = false;
    size_t fallback_index = 0;
    for (size_t i = 0; i + 3 < lines.size(); ++i) {
      auto [indent_x, variable_x, condition_x, base_x, component_x, fallback_x] = StringViewMatch<6>(lines[i], SELECT_LINE_REGEX);
      auto [indent_y, variable_y, condition_y, base_y, component_y, fallback_y] = StringViewMatch<6>(lines[i + 1], SELECT_LINE_REGEX);
      auto [indent_z, variable_z, condition_z, base_z, component_z, fallback_z] = StringViewMatch<6>(lines[i + 2], SELECT_LINE_REGEX);
      auto [dot_indent, dot_variable, dot_x, dot_y, dot_z, dot_rhs] = StringViewMatch<6>(lines[i + 3], DOT_LINE_REGEX);
      if (variable_x.empty() || variable_y.empty() || variable_z.empty() || dot_variable.empty()) continue;
      if (indent_x != indent_y || indent_y != indent_z || indent_z != dot_indent) continue;
      if (condition_x != condition_y || condition_y != condition_z) continue;
      if (base_x != base_y || base_y != base_z) continue;
      if (fallback_x != fallback_y || fallback_y != fallback_z) continue;
      if (dot_x != variable_x || dot_y != variable_y || dot_z != variable_z) continue;
      if (count_variable_references(variable_x) != 2
          || count_variable_references(variable_y) != 2
          || count_variable_references(variable_z) != 2) {
        continue;
      }

      auto swizzle = std::format("{}{}{}", component_x, component_y, component_z);
      auto vector_name = make_vector_name(variable_x, variable_z, fallback_index++);
      lines[i] = std::format(
          "{}float3 {} = select({}, {}.{}, ({}).xxx);",
          indent_x,
          vector_name,
          condition_x,
          base_x,
          swizzle,
          fallback_x);
      lines[i + 3] = std::format(
          "{}float {} = dot({}, {});",
          dot_indent,
          dot_variable,
          vector_name,
          dot_rhs);
      lines.erase(lines.begin() + i + 1, lines.begin() + i + 3);
      changed = true;
    }

    if (!changed) {
      return std::string(hlsl);
    }

    std::stringstream output_stream;
    for (size_t i = 0; i < lines.size(); ++i) {
      output_stream << lines[i];
      if (i + 1 < lines.size()) {
        output_stream << "\n";
      }
    }
    return output_stream.str();
  }

