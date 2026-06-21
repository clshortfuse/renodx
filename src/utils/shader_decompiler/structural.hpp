// ===== STRUCTURAL CODE GENERATION =====
// #included inside Decompiler::Decompile() when decompile_options.structural is true.
// Replaces the default append_code_block loop with deferred-target + branch-folding.

{
  // Use ListRecursions (any backward edge) instead of ListNaturalLoops
  auto recursions = current_code_function->ListRecursions();  // shadows outer `recursions`

  // Recompute analysis using structural-specific functions
  auto postdominators = current_code_function->ListPostDominators();
  auto immediate_postdominators = current_code_function->ListImmediatePostDominators(postdominators);
  auto structural_predecessors = current_code_function->ListPredecessorsVec();
  auto ladder_index = current_code_function->BuildBranchLadderIndex(structural_predecessors, immediate_postdominators);

  std::map<int, int> temporary_declaration_blocks;

  auto is_temp_local_variable_token = [](std::string_view token) {
    if (token.size() < 2 || token.front() != '_') return false;
    return std::ranges::all_of(token.substr(1), [](char c) { return c >= '0' && c <= '9'; });
  };
  auto is_temp_local_qualifier_token = [](std::string_view token) {
    return token == "const" || token == "row_major" || token == "column_major" || token == "precise";
  };
  auto is_temp_local_type_token = [&](std::string_view token) {
    if (token.empty() || is_temp_local_qualifier_token(token)) return false;
    const char first = token.front();
    if (!((first >= 'A' && first <= 'Z') || (first >= 'a' && first <= 'z') || first == '_')) return false;
    for (char c : token) {
      if ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9') || c == '_' || c == '<'
          || c == '>' || c == ',') {
        continue;
      }
      return false;
    }
    return true;
  };
  auto split_temp_local_tokens = [](std::string_view input) {
    std::vector<std::string_view> tokens;
    size_t offset = 0;
    while (offset < input.size()) {
      while (offset < input.size() && (input[offset] == ' ' || input[offset] == '\t')) {
        offset++;
      }
      if (offset >= input.size()) break;
      size_t end = offset;
      while (end < input.size() && input[end] != ' ' && input[end] != '\t') {
        end++;
      }
      tokens.push_back(input.substr(offset, end - offset));
      offset = end;
    }
    return tokens;
  };
  auto try_parse_temp_local_assignment_number = [&](std::string_view hlsl_line) -> std::optional<int> {
    auto line = StringViewTrim(hlsl_line);
    if (line.empty() || line.starts_with("//")) return std::nullopt;
    auto semicolon = line.find(';');
    if (semicolon == std::string_view::npos) return std::nullopt;
    auto equals = line.find('=');
    const bool has_assignment = equals != std::string_view::npos && equals < semicolon;
    auto lhs = StringViewTrim(line.substr(0, has_assignment ? equals : semicolon));
    if (lhs.empty()) return std::nullopt;
    auto tokens = split_temp_local_tokens(lhs);
    if (tokens.empty()) return std::nullopt;
    auto variable_token = tokens.back();
    if (!is_temp_local_variable_token(variable_token)) return std::nullopt;
    const auto prefix_count = tokens.size() - 1;
    if (!has_assignment && prefix_count == 0) return std::nullopt;
    if (prefix_count == 0) {
      int variable_number;
      FromStringView(variable_token.substr(1), variable_number);
      return variable_number;
    }
    size_t type_token_index = 0;
    while (type_token_index < prefix_count && is_temp_local_qualifier_token(tokens[type_token_index])) {
      type_token_index++;
    }
    if (type_token_index != prefix_count - 1 || !is_temp_local_type_token(tokens[type_token_index])) {
      return std::nullopt;
    }
    int variable_number;
    FromStringView(variable_token.substr(1), variable_number);
    return variable_number;
  };

  for (const auto& [declaration_block_line_number, declaration_code_block] : current_code_function->code_blocks) {
    for (const auto& hlsl_line : declaration_code_block.hlsl_lines) {
      auto declared_variable_number = try_parse_temp_local_assignment_number(hlsl_line);
      if (!declared_variable_number.has_value()) continue;
      temporary_declaration_blocks.try_emplace(declared_variable_number.value(), declaration_block_line_number);
    }
  }

  struct AssumedCondition {
    std::string variable;
    bool value;
  };
  std::vector<AssumedCondition> assumed_conditions;
  std::vector<std::pair<int, std::string>> structural_deferred_branch_targets;
  std::vector<int> structural_pending_convergences;
  std::vector<int> structural_current_loops;
  std::vector<int> active_deferred_phi_join_targets;

  // Phi coalescing: maps convergence phi names to loop phi names to prevent
  // DXC from exploiting identity cycles. Currently disabled (needs liveness analysis).
  std::map<std::string, std::string> structural_phi_coalescing;

  auto emit_annotation_comment = [&](std::string_view comment) {
    if (!decompile_options.annotate) return;
    string_stream << spacing << "// " << comment << "\n";
  };
  auto format_int_list = [&](const auto& values) {
    std::stringstream stream;
    bool first = true;
    for (const auto& value : values) {
      if (!first) {
        stream << ", ";
      }
      stream << value;
      first = false;
    }
    return stream.str();
  };
  auto has_active_deferred_phi_join_target = [&](int target) {
    return std::ranges::find(active_deferred_phi_join_targets, target) != active_deferred_phi_join_targets.end();
  };

  auto normalize_assumed_condition = [&](std::string_view input) -> std::optional<std::pair<std::string, bool>> {
    auto condition = StringViewTrim(input);
    bool negated = false;
    while (true) {
      while (!condition.empty() && IsWrapped(condition)) {
        condition = StringViewTrim(condition.substr(1, condition.size() - 2));
      }
      if (!condition.empty() && condition.front() == '!') {
        negated = !negated;
        condition = StringViewTrim(condition.substr(1));
        continue;
      }
      break;
    }
    if (condition.empty() || condition.front() != '_') {
      return std::nullopt;
    }
    for (size_t index = 1; index < condition.size(); ++index) {
      unsigned char character = static_cast<unsigned char>(condition[index]);
      if (!std::isalnum(character) && condition[index] != '_') {
        return std::nullopt;
      }
    }
    return std::pair{std::string(condition), negated};
  };

  auto resolve_assumed_condition = [&](std::string_view input) -> std::optional<bool> {
    auto normalized = normalize_assumed_condition(input);
    if (!normalized.has_value()) {
      return std::nullopt;
    }
    auto [variable, negated] = normalized.value();
    for (auto assumption_it = assumed_conditions.rbegin(); assumption_it != assumed_conditions.rend(); ++assumption_it) {
      if (assumption_it->variable == variable) {
        return negated ? !assumption_it->value : assumption_it->value;
      }
    }
    return std::nullopt;
  };

  auto with_assumed_condition = [&](std::string_view input, bool condition_value, auto&& callback) {
    auto normalized = normalize_assumed_condition(input);
    if (!normalized.has_value()) {
      callback();
      return;
    }
    auto [variable, negated] = normalized.value();
    assumed_conditions.push_back({
        .variable = std::move(variable),
        .value = negated ? !condition_value : condition_value,
    });
    callback();
    assumed_conditions.pop_back();
  };

  auto expand_block_branch_condition = [&](const CodeBlock& branch_code_block) -> std::optional<std::string> {
    constexpr size_t MAX_EXPANDED_BRANCH_CONDITION_SIZE = 16 * 1024;
    if (branch_code_block.code_branch.branch_condition.empty()) {
      return std::nullopt;
    }
    auto is_identifier_character = [](char character) {
      return (character >= '0' && character <= '9')
          || (character >= 'A' && character <= 'Z')
          || (character >= 'a' && character <= 'z')
          || character == '_';
    };
    auto replace_whole_identifier = [&](std::string_view input, std::string_view identifier, std::string_view replacement) {
      std::string output;
      output.reserve(input.size());
      size_t cursor = 0;
      while (cursor < input.size()) {
        auto match_index = input.find(identifier, cursor);
        if (match_index == std::string_view::npos) {
          output.append(input.substr(cursor));
          break;
        }
        auto has_left_identifier =
            match_index > 0 && is_identifier_character(input[match_index - 1]);
        auto match_end = match_index + identifier.size();
        auto has_right_identifier =
            match_end < input.size() && is_identifier_character(input[match_end]);
        if (has_left_identifier || has_right_identifier) {
          output.append(input.substr(cursor, match_end - cursor));
          cursor = match_end;
          continue;
        }
        output.append(input.substr(cursor, match_index - cursor));
        output.append(replacement);
        cursor = match_end;
      }
      return output;
    };
    auto count_whole_identifier = [&](std::string_view input, std::string_view identifier) {
      size_t count = 0;
      size_t cursor = 0;
      while (cursor < input.size()) {
        auto match_index = input.find(identifier, cursor);
        if (match_index == std::string_view::npos) break;
        auto has_left_identifier =
            match_index > 0 && is_identifier_character(input[match_index - 1]);
        auto match_end = match_index + identifier.size();
        auto has_right_identifier =
            match_end < input.size() && is_identifier_character(input[match_end]);
        if (!has_left_identifier && !has_right_identifier) {
          ++count;
        }
        cursor = match_end;
      }
      return count;
    };
    auto is_trivial_inline_expression = [](std::string_view expression) {
      return StringViewTrim(expression).size() <= 32;
    };
    auto make_parenthesized_expression = [](std::string_view expression) {
      std::string parenthesized_expression;
      parenthesized_expression.reserve(expression.size() + 2);
      parenthesized_expression.push_back('(');
      parenthesized_expression.append(expression);
      parenthesized_expression.push_back(')');
      return parenthesized_expression;
    };
    auto try_inline_known_expression = [&](std::string& expression, const std::string& known_variable, const std::string& known_expression) {
      const auto use_count = count_whole_identifier(expression, known_variable);
      if (use_count == 0) {
        return true;
      }
      // This is only a fold heuristic. If inlining would duplicate a non-trivial
      // expression, keep the original block structure instead of manufacturing a
      // massive condition with repeated resource/wave/hash expressions.
      if (use_count > 1 && !is_trivial_inline_expression(known_expression)) {
        return false;
      }
      if (expression.size() > MAX_EXPANDED_BRANCH_CONDITION_SIZE) {
        return false;
      }
      const auto replacement_size = known_expression.size() + 2;
      if (replacement_size > known_variable.size()) {
        const auto growth_per_use = replacement_size - known_variable.size();
        if (growth_per_use > 0
            && use_count > (MAX_EXPANDED_BRANCH_CONDITION_SIZE - expression.size()) / growth_per_use) {
          return false;
        }
      }
      auto parenthesized_expression = make_parenthesized_expression(known_expression);
      expression = replace_whole_identifier(expression, known_variable, parenthesized_expression);
      return expression.size() <= MAX_EXPANDED_BRANCH_CONDITION_SIZE;
    };

    std::vector<std::string_view> executable_lines;
    executable_lines.reserve(branch_code_block.hlsl_lines.size());
    for (const auto& hlsl_line : branch_code_block.hlsl_lines) {
      if (hlsl_line.starts_with("//")) continue;
      executable_lines.emplace_back(hlsl_line);
    }
    if (executable_lines.empty()) {
      return ParseWrapped(branch_code_block.code_branch.branch_condition);
    }

    static const auto ASSIGN_REGEX = std::regex(R"(^(?:const\s+)?(\S+) (\S+) = (.*);$)");
    std::map<std::string, std::string> known_assignments;
    for (const auto& executable_line : executable_lines) {
      auto [assignment_type, variable_name, expression] = StringViewMatch<3>(executable_line, ASSIGN_REGEX);
      if (assignment_type.empty() || variable_name.empty() || expression.empty()) {
        return std::nullopt;
      }
      std::string expanded_expression(expression);
      for (const auto& [known_variable, known_expression] : known_assignments) {
        if (!try_inline_known_expression(expanded_expression, known_variable, known_expression)) {
          return std::nullopt;
        }
      }
      known_assignments.emplace(variable_name, expanded_expression);
    }

    std::string expanded_condition(branch_code_block.code_branch.branch_condition);
    for (const auto& [known_variable, known_expression] : known_assignments) {
      if (!try_inline_known_expression(expanded_condition, known_variable, known_expression)) {
        return std::nullopt;
      }
    }

    // Safety: bail if a variable defined here is used only externally
    for (const auto& [var_name, _expr] : known_assignments) {
      bool referenced_internally = false;
      for (const auto& [other_var, other_expr] : known_assignments) {
        if (other_var == var_name) continue;
        if (other_expr.find(var_name) != std::string::npos) {
          auto pos = other_expr.find(var_name);
          while (pos != std::string::npos) {
            bool left_ok = (pos == 0) || !is_identifier_character(other_expr[pos - 1]);
            bool right_ok = (pos + var_name.size() >= other_expr.size()) || !is_identifier_character(other_expr[pos + var_name.size()]);
            if (left_ok && right_ok) {
              referenced_internally = true;
              break;
            }
            pos = other_expr.find(var_name, pos + 1);
          }
          if (referenced_internally) break;
        }
      }
      if (!referenced_internally) {
        auto cond_str = std::string(branch_code_block.code_branch.branch_condition);
        auto pos = cond_str.find(var_name);
        while (pos != std::string::npos) {
          bool left_ok = (pos == 0) || !is_identifier_character(cond_str[pos - 1]);
          bool right_ok = (pos + var_name.size() >= cond_str.size()) || !is_identifier_character(cond_str[pos + var_name.size()]);
          if (left_ok && right_ok) {
            referenced_internally = true;
            break;
          }
          pos = cond_str.find(var_name, pos + 1);
        }
      }
      if (!referenced_internally) {
        return std::nullopt;
      }
    }

    // Safety: bail if a variable is also referenced by other blocks
    auto check_variable_referenced_externally = [&](const std::string& var_name) -> bool {
      auto contains_whole_identifier = [&](std::string_view haystack) -> bool {
        auto pos = haystack.find(var_name);
        while (pos != std::string_view::npos) {
          bool left_ok = (pos == 0) || !is_identifier_character(haystack[pos - 1]);
          bool right_ok = (pos + var_name.size() >= haystack.size()) || !is_identifier_character(haystack[pos + var_name.size()]);
          if (left_ok && right_ok) return true;
          pos = haystack.find(var_name, pos + 1);
        }
        return false;
      };
      for (const auto& [other_block_line_number, other_code_block] : current_code_function->code_blocks) {
        if (&other_code_block == &branch_code_block) continue;
        for (const auto& other_line : other_code_block.hlsl_lines) {
          if (other_line.starts_with("//")) continue;
          if (contains_whole_identifier(other_line)) return true;
        }
        for (const auto& [phi_var, phi_type, phi_value, phi_predecessor, phi_code_function, phi_is_assign] : other_code_block.phi_lines) {
          if (!phi_is_assign) continue;
          if (contains_whole_identifier(phi_value)) return true;
        }
        if (contains_whole_identifier(other_code_block.code_branch.branch_condition)) return true;
      }
      return false;
    };
    for (const auto& [var_name, _expr] : known_assignments) {
      if (check_variable_referenced_externally(var_name)) {
        return std::nullopt;
      }
    }

    return ParseWrapped(expanded_condition);
  };

  // Loop jump target for nonlocal loop breaks
  constexpr std::string_view LOOP_JUMP_TARGET_NAME = "__loop_jump_target";
  auto loop_can_jump_to_ancestor = [&](int loop_header, int ancestor_loop) {
    auto recursion_it = recursions.find(ancestor_loop);
    if (recursion_it == recursions.end()) {
      return false;
    }
    for (const auto source_line_number : recursion_it->second) {
      auto dominator_it = dominators.find(source_line_number);
      if (dominator_it != dominators.end() && dominator_it->second.contains(loop_header)) {
        return true;
      }
    }
    return false;
  };
  auto loop_has_nonlocal_jump = [&](int loop_header) {
    auto dominator_it = dominators.find(loop_header);
    if (dominator_it == dominators.end()) {
      return false;
    }
    for (const auto& [ancestor_loop, ancestor_sources] : recursions) {
      if (ancestor_loop == loop_header) continue;
      if (!dominator_it->second.contains(ancestor_loop)) continue;
      if (loop_can_jump_to_ancestor(loop_header, ancestor_loop)) {
        return true;
      }
    }
    return false;
  };
  const bool uses_loop_jump_target = [&]() {
    for (const auto& [loop_header, loop_sources] : recursions) {
      if (loop_has_nonlocal_jump(loop_header)) {
        return true;
      }
    }
    return false;
  }();

  // ===== Main structural append_code_block =====
  constexpr size_t MAX_OUTPUT_SIZE = 128 * 1024 * 1024;  // 128 MB safety limit

  std::function<void(int line_number)> structural_append_code_block = [&](int line_number) {
    auto current_size = static_cast<size_t>(string_stream.tellp());
    if (current_size > MAX_OUTPUT_SIZE) {
      throw std::runtime_error(std::format(
          "Structural code generation exceeded {} MB output limit at block {}. "
          "This shader may require --use-do-while or --stackify instead.",
          MAX_OUTPUT_SIZE / (1024 * 1024), line_number));
    }

    bool using_recursion = recursions.contains(line_number);
    if (using_recursion) {
      structural_current_loops.push_back(line_number);
      string_stream << spacing << "while(true) {\n";
      indent_spacing();

      // Phi pre-initialization: emit _convergence = _loop_phi at loop header
      // to prevent DXC from replacing initial values with undef in identity cycles.
      {
        auto& loop_header_block = current_code_function->code_blocks[line_number];
        auto loop_dom_it = dominators.find(line_number);
        
        for (const auto& [cv_variable, cv_type, cv_value, cv_predecessor, cv_code_function, cv_is_assign] : loop_header_block.phi_lines) {
          if (!cv_is_assign) continue;
          if (cv_code_function == line_number) continue;
          if (cv_code_function != loop_header_block.code_branch.branch_condition_true
              && cv_code_function != loop_header_block.code_branch.branch_condition_false) continue;
          auto conv_dom_it = dominators.find(cv_code_function);
          if (conv_dom_it == dominators.end() || !conv_dom_it->second.contains(line_number)) continue;
          auto cv_value_str = std::string(cv_value);
          if (cv_value_str.empty() || cv_value_str[0] != '%') continue;
          auto loop_phi_var = cv_value_str.substr(1);
          
          bool found_back_edge = false;
          for (auto& [block_num, block] : current_code_function->code_blocks) {
            if (block_num == line_number) continue;
            for (const auto& [be_variable, be_type, be_value, be_predecessor, be_code_function, be_is_assign] : block.phi_lines) {
              if (!be_is_assign || be_code_function != line_number || be_variable != loop_phi_var) continue;
              if (std::string(be_value) == std::format("%{}", cv_variable)) {
                found_back_edge = true;
                break;
              }
            }
            if (found_back_edge) break;
          }
          if (!found_back_edge) continue;
          
          auto conv_var_name = std::format("_{}", cv_variable);
          bool used_in_code = false;
          for (const auto& [block_num, block] : current_code_function->code_blocks) {
            for (const auto& hlsl_line : block.hlsl_lines) {
              size_t pos = hlsl_line.find(conv_var_name);
              while (pos != std::string::npos) {
                size_t end_pos = pos + conv_var_name.size();
                if (end_pos >= hlsl_line.size() || !(hlsl_line[end_pos] >= '0' && hlsl_line[end_pos] <= '9')) {
                  used_in_code = true;
                  break;
                }
                pos = hlsl_line.find(conv_var_name, end_pos);
              }
              if (used_in_code) break;
            }
            if (used_in_code) break;
          }
          if (used_in_code) continue;
          
          string_stream << spacing << conv_var_name << " = _" << loop_phi_var << ";\n";
        }
      }
    }
    auto on_complete = [&]() {
      if (using_recursion) {
        string_stream << spacing << "break;\n";
        unindent_spacing();
        string_stream << spacing << "}\n";
        auto enclosing_loop = structural_current_loops.size() > 1 ? structural_current_loops[structural_current_loops.size() - 2] : -1;
        const bool can_jump_to_enclosing_loop =
            enclosing_loop != -1 && loop_can_jump_to_ancestor(line_number, enclosing_loop);
        bool can_jump_to_outer_ancestor = false;
        if (enclosing_loop != -1) {
          for (size_t loop_index = 0; loop_index + 1 < structural_current_loops.size(); ++loop_index) {
            int ancestor_loop = structural_current_loops[loop_index];
            if (ancestor_loop == enclosing_loop) continue;
            if (loop_can_jump_to_ancestor(line_number, ancestor_loop)) {
              can_jump_to_outer_ancestor = true;
              break;
            }
          }
        }
        if (can_jump_to_enclosing_loop) {
          string_stream << spacing << "if (" << LOOP_JUMP_TARGET_NAME << " == " << enclosing_loop << ") {\n";
          indent_spacing();
          string_stream << spacing << LOOP_JUMP_TARGET_NAME << " = -1;\n";
          string_stream << spacing << "continue;\n";
          unindent_spacing();
          string_stream << spacing << "}\n";
        }
        if (can_jump_to_enclosing_loop || can_jump_to_outer_ancestor) {
          string_stream << spacing << "if (" << LOOP_JUMP_TARGET_NAME << " != -1) {\n";
          indent_spacing();
          string_stream << spacing << "break;\n";
          unindent_spacing();
          string_stream << spacing << "}\n";
        }
        structural_current_loops.pop_back();
        // Clean up phi coalescing entries for this loop
        std::erase_if(structural_phi_coalescing, [&](const auto& entry) {
          // Remove entries that were added for this loop (their target is a phi of this loop header)
          // We identify them by checking if the coalesced target is a phi variable of this loop header
          for (const auto& [lh_variable, lh_type, lh_value, lh_predecessor, lh_code_function, lh_is_assign] : current_code_function->code_blocks[line_number].phi_lines) {
            if (lh_is_assign && std::format("_{}", lh_variable) == entry.second) return true;
          }
          return false;
        });
      }
    };

    auto emit_code_block_prelude = [&](int emit_line_number) {
      auto& emit_code_block = current_code_function->code_blocks[emit_line_number];
      if (decompile_options.annotate) {
        std::stringstream block_comment;
        block_comment << "bb " << emit_line_number;
        if (auto predecessor_it = structural_predecessors.find(emit_line_number);
            predecessor_it != structural_predecessors.end() && !predecessor_it->second.empty()) {
          block_comment << " preds=[" << format_int_list(predecessor_it->second) << "]";
        }
        if (auto postdominator_it = immediate_postdominators.find(emit_line_number);
            postdominator_it != immediate_postdominators.end()) {
          block_comment << " ipdom=" << postdominator_it->second;
        }
        auto successors = current_code_function->ListNormalizedSuccessors(emit_code_block);
        if (!successors.empty()) {
          block_comment << " succ=[" << format_int_list(successors) << "]";
        }
        if (recursions.contains(emit_line_number)) {
          block_comment << " loop-header";
        }
        emit_annotation_comment(block_comment.str());
        if (!structural_pending_convergences.empty()) {
          emit_annotation_comment(std::format("pending-convergence [{}]", format_int_list(structural_pending_convergences)));
        }
      }
      // Strip type prefix from pre-declared variables to avoid redefinition
      static const std::regex structural_var_decl_re(
          R"(^(float4|float3|float2|float|int|uint|bool|uint4|int4|int2|uint2|int3|uint3|double|int64_t|uint64_t|int16_t|uint16_t|half|min16float|min16int|min16uint|[A-Z_]\w*)\s+(_\d+)\s*=)");
      static const std::regex structural_var_decl_noassign_re(
          R"(^(float4|float3|float2|float|int|uint|bool|uint4|int4|int2|uint2|int3|uint3|double|int64_t|uint64_t|int16_t|uint16_t|half|min16float|min16int|min16uint|[A-Z_]\w*)\s+(_\d+)\s*;)");
      for (const auto& hlsl_line : emit_code_block.hlsl_lines) {
        auto optimized_line = (decompile_options.flatten ? OptimizeString(hlsl_line) : hlsl_line);
        std::smatch decl_match;
        auto line_str = std::string(optimized_line);
        if (std::regex_search(line_str, decl_match, structural_var_decl_re)) {
          std::string var_name = decl_match[2].str();
          if (declared_vars.contains(var_name)) {
            line_str = line_str.substr(decl_match[1].length() + 1);
            string_stream << spacing << line_str << "\n";
            continue;
          }
        } else if (std::regex_search(line_str, decl_match, structural_var_decl_noassign_re)) {
          std::string var_name = decl_match[2].str();
          if (declared_vars.contains(var_name)) {
            auto decl_end = decl_match[0].length();
            auto remainder = StringViewTrim(std::string_view(line_str).substr(decl_end));
            if (!remainder.empty()) {
              string_stream << spacing << remainder << "\n";
            }
            continue;
          }
        }
        string_stream << spacing << optimized_line << "\n";
      }
      for (const auto& [variable, type, value, predecessor, code_function, is_assign] : emit_code_block.phi_lines) {
        if (is_assign) continue;
        auto var_name = std::format("_{}", variable);
        if (!declared_vars.contains(var_name)) {
          auto assignment_type = ParseType(type);
          string_stream << spacing << std::format("{} {};", assignment_type, var_name) << "\n";
        }
      }
    };

    auto emit_phi_assignments = [&](CodeBlock* source_code_block, int branch_number) {
      for (const auto& phi_line : current_code_function->ComputePhiAssignments(source_code_block, branch_number)) {
        auto optimized_line = (decompile_options.flatten ? OptimizeString(phi_line) : phi_line);
        string_stream << spacing << optimized_line << "\n";
      }
    };

    auto& code_block = current_code_function->code_blocks[line_number];
    emit_code_block_prelude(line_number);

    int current_loop = structural_current_loops.empty() ? -1 : structural_current_loops.back();

    if (code_block.code_branch.branch_condition_true <= 0 && code_block.code_switch.switch_condition.empty()) {
      on_complete();
      return;
    }

    int next_convergence = structural_pending_convergences.empty() ? -1 : structural_pending_convergences.back();

    auto close_lonely_if = [&](int else_code_function) {
      std::vector<std::string> phi_lines = current_code_function->ComputePhiAssignments(&code_block, else_code_function);
      if (phi_lines.empty()) {
        string_stream << spacing << "}\n";
      } else {
        string_stream << spacing << "} else {\n";
        indent_spacing();
        for (const auto& phi_line : phi_lines) {
          auto optimized_line = (decompile_options.flatten ? OptimizeString(phi_line) : phi_line);
          string_stream << spacing << optimized_line << "\n";
        }
        unindent_spacing();
        string_stream << spacing << "}\n";
      }
    };

    std::optional<int> deferred_phi_join_target;
    auto on_branch_from = [&](CodeBlock* source_code_block, int branch_number, bool is_fallthrough = false) {
      int active_convergence = structural_pending_convergences.empty() ? -1 : structural_pending_convergences.back();

      if (!is_fallthrough) {
        emit_phi_assignments(source_code_block, branch_number);
      }
      if (deferred_phi_join_target.has_value() && branch_number == deferred_phi_join_target.value()) {
        emit_annotation_comment(std::format("edge {} -> {} phi-join", line_number, branch_number));
      } else if (has_active_deferred_phi_join_target(branch_number)) {
        emit_annotation_comment(std::format("edge {} -> {} phi-join-active", line_number, branch_number));
      } else if (current_loop == branch_number) {
        emit_annotation_comment(std::format("edge {} -> {} continue", line_number, branch_number));
        string_stream << spacing << "continue;\n";
      } else if (std::ranges::find(structural_current_loops, branch_number) != structural_current_loops.end()) {
        emit_annotation_comment(std::format("edge {} -> {} break-to-loop", line_number, branch_number));
        string_stream << spacing << LOOP_JUMP_TARGET_NAME << " = " << branch_number << ";\n";
        string_stream << spacing << "break;\n";
      } else if (active_convergence == branch_number) {
        emit_annotation_comment(std::format("edge {} -> {} converge", line_number, branch_number));
      } else if (std::ranges::find(structural_pending_convergences, branch_number) != structural_pending_convergences.end()) {
        emit_annotation_comment(std::format("edge {} -> {} break-pending-convergence", line_number, branch_number));
        if (decompile_options.use_do_while) {
          string_stream << spacing << "break;\n";
        } else {
          throw std::runtime_error("Unexpected goto");
        }
      } else if (auto deferred_target = std::ranges::find_if(
                     structural_deferred_branch_targets.rbegin(),
                     structural_deferred_branch_targets.rend(),
                     [&](const auto& entry) {
                       return entry.first == branch_number;
                     });
                 deferred_target != structural_deferred_branch_targets.rend()) {
        emit_annotation_comment(std::format("edge {} -> {} defer({})", line_number, branch_number, deferred_target->second));
        string_stream << spacing << deferred_target->second << " = true;\n";
      } else {
        emit_annotation_comment(std::format("edge {} -> {} inline", line_number, branch_number));
        structural_append_code_block(branch_number);
      }
    };
    auto on_branch = [&](int branch_number, bool is_fallthrough = false) {
      on_branch_from(&code_block, branch_number, is_fallthrough);
    };
    auto on_branch_assuming = [&](int branch_number, bool condition_value, bool is_fallthrough = false) {
      with_assumed_condition(code_block.code_branch.branch_condition, condition_value, [&]() {
        on_branch(branch_number, is_fallthrough);
      });
    };
    auto append_or_defer = [&](int branch_number) {
      if (has_active_deferred_phi_join_target(branch_number)) {
        emit_annotation_comment(std::format("edge {} -> {} phi-join-active-append", line_number, branch_number));
        emit_phi_assignments(&code_block, branch_number);
      } else if (auto deferred_target = std::ranges::find_if(
              structural_deferred_branch_targets.rbegin(),
              structural_deferred_branch_targets.rend(),
              [&](const auto& entry) {
                return entry.first == branch_number;
              });
          deferred_target != structural_deferred_branch_targets.rend()) {
        string_stream << spacing << deferred_target->second << " = true;\n";
      } else {
        structural_append_code_block(branch_number);
      }
    };

    // Fold assumed conditions
    if (code_block.code_switch.switch_condition.empty()) {
      if (auto known_condition = resolve_assumed_condition(code_block.code_branch.branch_condition);
          known_condition.has_value()) {
        emit_annotation_comment(std::format(
            "fold assume {}={} -> {}",
            code_block.code_branch.branch_condition,
            known_condition.value() ? "true" : "false",
            known_condition.value()
                ? code_block.code_branch.branch_condition_true
                : code_block.code_branch.branch_condition_false));
        on_branch(known_condition.value()
                      ? code_block.code_branch.branch_condition_true
                      : code_block.code_branch.branch_condition_false);
        on_complete();
        return;
      }
    }

    // Switch handling
    if (!code_block.code_switch.switch_condition.empty()) {
      int switch_convergence = -1;
      if (auto pair = immediate_postdominators.find(line_number);
          pair != immediate_postdominators.end()) {
        switch_convergence = pair->second;
      }
      assert(switch_convergence != -1);
      structural_pending_convergences.push_back(switch_convergence);

      const auto add_convergence_phis = [&]() {
        for (const auto& phi_line : current_code_function->ComputePhiAssignments(&code_block, switch_convergence)) {
          auto optimized_line = (decompile_options.flatten ? OptimizeString(phi_line) : phi_line);
          string_stream << spacing << optimized_line << "\n";
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

      structural_pending_convergences.pop_back();
      bool is_empty = structural_pending_convergences.empty();
      on_branch(switch_convergence, true);
      on_complete();
      return;
    }

    // Unconditional branch
    if (code_block.code_branch.branch_condition.empty()) {
      on_branch(code_block.code_branch.branch_condition_true);
      on_complete();
      return;
    }

    auto targets_active_loop = [&](int branch_number) {
      return std::ranges::find(structural_current_loops, branch_number) != structural_current_loops.end();
    };

    if (code_block.code_branch.branch_condition_false <= line_number
        && code_block.code_branch.branch_condition_true <= line_number
        && !targets_active_loop(code_block.code_branch.branch_condition_true)
        && !targets_active_loop(code_block.code_branch.branch_condition_false)
        && code_block.code_branch.branch_condition_true != next_convergence
        && code_block.code_branch.branch_condition_false != next_convergence
        && std::ranges::find(structural_pending_convergences, code_block.code_branch.branch_condition_true) == structural_pending_convergences.end()
        && std::ranges::find(structural_pending_convergences, code_block.code_branch.branch_condition_false) == structural_pending_convergences.end()
        && !recursions.contains(code_block.code_branch.branch_condition_true)
        && !recursions.contains(code_block.code_branch.branch_condition_false)) {
      auto message = std::format(
          "Unsupported loop detected at block {} (true={}, false={}, current_loop={}, next_convergence={})",
          line_number,
          code_block.code_branch.branch_condition_true,
          code_block.code_branch.branch_condition_false,
          current_loop,
          next_convergence);
      throw std::runtime_error(message);
    }

    // Single-side convergence shortcuts
    if (code_block.code_branch.branch_condition_true == next_convergence) {
      if (code_block.code_branch.use_hint) {
        string_stream << spacing << "[branch]\n";
      }
      string_stream << spacing << "if (!" << code_block.code_branch.branch_condition << ") {\n";
      indent_spacing();
      on_branch_assuming(code_block.code_branch.branch_condition_false, false);
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
      on_branch_assuming(code_block.code_branch.branch_condition_true, true);
      unindent_spacing();
      close_lonely_if(next_convergence);
      on_complete();
      return;
    }

    // Find pair convergence (immediate post-dominator)
    int pair_convergence = -1;
    bool pushed_pair_convergence = false;
    bool uses_convergence_wrapper = false;
    if (auto pair = immediate_postdominators.find(line_number);
        pair != immediate_postdominators.end()) {
      pair_convergence = pair->second;
      if (pair_convergence != next_convergence) {
        if (!structural_pending_convergences.empty()) {
          uses_convergence_wrapper =
              decompile_options.use_do_while && (current_code_function->RegionNeedsConvergenceWrapper(code_block.code_branch.branch_condition_true, pair_convergence, structural_pending_convergences) || current_code_function->RegionNeedsConvergenceWrapper(code_block.code_branch.branch_condition_false, pair_convergence, structural_pending_convergences));
          if (uses_convergence_wrapper) {
            string_stream << spacing << "do {\n";
            indent_spacing();
          }
        }
        structural_pending_convergences.push_back(pair_convergence);
        pushed_pair_convergence = true;
      }
    } else {
      // No ipdom — exit block or unconditional
    }

    // ===== Structural analysis: SharedBranchChain =====
    struct SharedBranchChainStep {
      int line_number;
      bool shared_on_true;
    };
    struct SharedBranchChain {
      int shared_target;
      int final_continue_target;
      std::vector<SharedBranchChainStep> steps;
    };

    auto build_shared_branch_chain =
        [&](int shared_target, int continue_target, bool shared_on_true) -> std::optional<SharedBranchChain> {
      if (pair_convergence == -1 || shared_target <= 0 || continue_target <= 0 || shared_target == pair_convergence
          || continue_target == pair_convergence) {
        return std::nullopt;
      }
      SharedBranchChain chain = {
          .shared_target = shared_target,
          .final_continue_target = pair_convergence,
          .steps = {{line_number, shared_on_true}},
      };
      std::set<int> visited = {line_number};
      int current_line_number = continue_target;
      while (true) {
        if (current_line_number <= 0 || !current_code_function->code_blocks.contains(current_line_number)
            || !visited.emplace(current_line_number).second) {
          return std::nullopt;
        }
        if (recursions.contains(current_line_number)) {
          return std::nullopt;
        }
        auto convergence_pair = immediate_postdominators.find(current_line_number);
        if (convergence_pair == immediate_postdominators.end() || convergence_pair->second != pair_convergence) {
          return std::nullopt;
        }
        const auto& current_chain_block = current_code_function->code_blocks.at(current_line_number);
        if (!current_chain_block.code_switch.switch_condition.empty()
            || current_chain_block.code_branch.branch_condition.empty()
            || current_chain_block.code_branch.branch_condition_true <= 0
            || current_chain_block.code_branch.branch_condition_false <= 0) {
          return std::nullopt;
        }
        int next_continue_target = -1;
        bool current_shared_on_true = false;
        if (current_chain_block.code_branch.branch_condition_true == shared_target
            && current_chain_block.code_branch.branch_condition_false != shared_target) {
          current_shared_on_true = true;
          next_continue_target = current_chain_block.code_branch.branch_condition_false;
        } else if (current_chain_block.code_branch.branch_condition_false == shared_target
                   && current_chain_block.code_branch.branch_condition_true != shared_target) {
          current_shared_on_true = false;
          next_continue_target = current_chain_block.code_branch.branch_condition_true;
        } else {
          return std::nullopt;
        }
        chain.steps.push_back({current_line_number, current_shared_on_true});
        if (next_continue_target == pair_convergence) {
          chain.final_continue_target = pair_convergence;
          break;
        }
        if (next_continue_target <= current_line_number) {
          return std::nullopt;
        }
        const auto& next_continue_code_block = current_code_function->code_blocks.at(next_continue_target);
        if (next_continue_code_block.code_switch.switch_condition.empty()
            && next_continue_code_block.code_branch.branch_condition.empty()
            && next_continue_code_block.code_branch.branch_condition_true == pair_convergence) {
          chain.final_continue_target = next_continue_target;
          break;
        }
        current_line_number = next_continue_target;
      }
      if (chain.steps.size() < 2) {
        return std::nullopt;
      }
      return chain;
    };

    std::optional<SharedBranchChain> shared_branch_chain;
    if (pair_convergence != -1) {
      auto true_candidate = build_shared_branch_chain(code_block.code_branch.branch_condition_true,
                                                      code_block.code_branch.branch_condition_false, true);
      auto false_candidate = build_shared_branch_chain(code_block.code_branch.branch_condition_false,
                                                       code_block.code_branch.branch_condition_true, false);
      if (true_candidate && (!false_candidate || true_candidate->steps.size() >= false_candidate->steps.size())) {
        shared_branch_chain = std::move(true_candidate);
      } else if (false_candidate) {
        shared_branch_chain = std::move(false_candidate);
      }
    }

    auto get_foldable_chain_branch_condition =
        [&](const CodeBlock& chain_code_block) -> std::optional<std::string> {
      return expand_block_branch_condition(chain_code_block);
    };

    // ===== FoldedSharedBranchJoin =====
    struct FoldedSharedBranchJoin {
      int shared_target;
      int continue_target;
      bool use_branch_hint;
      std::string shared_target_condition;
    };

    auto build_folded_shared_branch_join = [&]() -> std::optional<FoldedSharedBranchJoin> {
      if (pair_convergence == -1) return std::nullopt;
      auto inspect_child = [&](int child_line_number) -> std::optional<std::tuple<const CodeBlock*, std::string, int, int>> {
        if (child_line_number <= 0 || !current_code_function->code_blocks.contains(child_line_number)
            || recursions.contains(child_line_number)) {
          return std::nullopt;
        }
        const auto& child_code_block = current_code_function->code_blocks.at(child_line_number);
        if (!child_code_block.code_switch.switch_condition.empty()
            || child_code_block.code_branch.branch_condition.empty()
            || child_code_block.code_branch.branch_condition_true <= 0
            || child_code_block.code_branch.branch_condition_false <= 0) {
          return std::nullopt;
        }
        auto convergence_pair = immediate_postdominators.find(child_line_number);
        if (convergence_pair == immediate_postdominators.end() || convergence_pair->second != pair_convergence) {
          return std::nullopt;
        }
        if (!current_code_function->ComputePhiAssignments(&code_block, child_line_number).empty()) {
          return std::nullopt;
        }
        auto child_condition = get_foldable_chain_branch_condition(child_code_block);
        if (!child_condition.has_value()) return std::nullopt;
        return std::tuple<const CodeBlock*, std::string, int, int>{
            &child_code_block, child_condition.value(),
            child_code_block.code_branch.branch_condition_true,
            child_code_block.code_branch.branch_condition_false};
      };
      auto true_child = inspect_child(code_block.code_branch.branch_condition_true);
      auto false_child = inspect_child(code_block.code_branch.branch_condition_false);
      if (!true_child.has_value() || !false_child.has_value()) return std::nullopt;
      const auto& [true_child_block, true_child_condition, true_true_target, true_false_target] = true_child.value();
      const auto& [false_child_block, false_child_condition, false_true_target, false_false_target] = false_child.value();
      std::set<int> true_child_targets = {true_true_target, true_false_target};
      std::set<int> false_child_targets = {false_true_target, false_false_target};
      if (true_child_targets.size() != 2 || true_child_targets != false_child_targets) return std::nullopt;
      auto root_condition = ParseWrapped(code_block.code_branch.branch_condition);
      const bool use_branch_hint =
          code_block.code_branch.use_hint || true_child_block->code_branch.use_hint || false_child_block->code_branch.use_hint;
      auto build_join_for_target = [&](int candidate_shared_target) -> std::optional<FoldedSharedBranchJoin> {
        auto candidate_continue_target_it = true_child_targets.begin();
        while (candidate_continue_target_it != true_child_targets.end()
               && *candidate_continue_target_it == candidate_shared_target) {
          ++candidate_continue_target_it;
        }
        if (candidate_continue_target_it == true_child_targets.end()) return std::nullopt;
        int candidate_continue_target = *candidate_continue_target_it;
        if (candidate_shared_target <= 0 || candidate_continue_target <= 0
            || candidate_shared_target == pair_convergence || candidate_continue_target == pair_convergence) {
          return std::nullopt;
        }
        if (!current_code_function->ComputePhiAssignments(const_cast<CodeBlock*>(true_child_block), candidate_shared_target).empty()
            || !current_code_function->ComputePhiAssignments(const_cast<CodeBlock*>(true_child_block), candidate_continue_target).empty()
            || !current_code_function->ComputePhiAssignments(const_cast<CodeBlock*>(false_child_block), candidate_shared_target).empty()
            || !current_code_function->ComputePhiAssignments(const_cast<CodeBlock*>(false_child_block), candidate_continue_target).empty()) {
          return std::nullopt;
        }
        auto true_path_shared_condition = (true_true_target == candidate_shared_target)
                                              ? true_child_condition
                                              : std::format("!{}", true_child_condition);
        auto false_path_shared_condition = (false_true_target == candidate_shared_target)
                                               ? false_child_condition
                                               : std::format("!{}", false_child_condition);
        return FoldedSharedBranchJoin{
            .shared_target = candidate_shared_target,
            .continue_target = candidate_continue_target,
            .use_branch_hint = use_branch_hint,
            .shared_target_condition = std::format(
                "(({} && {}) || (!{} && {}))",
                root_condition, true_path_shared_condition,
                root_condition, false_path_shared_condition),
        };
      };
      auto shared_target_it = true_child_targets.begin();
      auto shared_join = build_join_for_target(*shared_target_it);
      if (shared_join.has_value()) return shared_join;
      ++shared_target_it;
      if (shared_target_it == true_child_targets.end()) return std::nullopt;
      return build_join_for_target(*shared_target_it);
    };

    // ===== FoldedSharedContinueJoin =====
    struct FoldedSharedContinueJoin {
      int continue_target;
      int true_target;
      int false_target;
      bool use_branch_hint;
      std::string continue_target_condition;
      std::string true_target_condition;
      std::string false_target_condition;
    };

    auto build_folded_shared_continue_join = [&]() -> std::optional<FoldedSharedContinueJoin> {
      if (pair_convergence == -1) return std::nullopt;
      auto inspect_child = [&](int child_line_number) -> std::optional<std::tuple<const CodeBlock*, std::string, int, int>> {
        if (child_line_number <= 0 || !current_code_function->code_blocks.contains(child_line_number)
            || recursions.contains(child_line_number)) {
          return std::nullopt;
        }
        const auto& child_code_block = current_code_function->code_blocks.at(child_line_number);
        if (!child_code_block.code_switch.switch_condition.empty()
            || child_code_block.code_branch.branch_condition.empty()
            || child_code_block.code_branch.branch_condition_true <= 0
            || child_code_block.code_branch.branch_condition_false <= 0) {
          return std::nullopt;
        }
        auto convergence_pair = immediate_postdominators.find(child_line_number);
        if (convergence_pair == immediate_postdominators.end() || convergence_pair->second != pair_convergence) {
          return std::nullopt;
        }
        if (!current_code_function->ComputePhiAssignments(&code_block, child_line_number).empty()) {
          return std::nullopt;
        }
        auto child_condition = get_foldable_chain_branch_condition(child_code_block);
        if (!child_condition.has_value()) return std::nullopt;
        return std::tuple<const CodeBlock*, std::string, int, int>{
            &child_code_block, child_condition.value(),
            child_code_block.code_branch.branch_condition_true,
            child_code_block.code_branch.branch_condition_false};
      };
      auto true_child = inspect_child(code_block.code_branch.branch_condition_true);
      auto false_child = inspect_child(code_block.code_branch.branch_condition_false);
      if (!true_child.has_value() || !false_child.has_value()) return std::nullopt;
      const auto& [true_child_block, true_child_condition, true_true_target, true_false_target] = true_child.value();
      const auto& [false_child_block, false_child_condition, false_true_target, false_false_target] = false_child.value();
      std::set<int> common_targets = {true_true_target, true_false_target};
      std::set<int> other_targets = {false_true_target, false_false_target};
      std::vector<int> shared_targets;
      std::set_intersection(common_targets.begin(), common_targets.end(),
                            other_targets.begin(), other_targets.end(),
                            std::back_inserter(shared_targets));
      if (shared_targets.size() != 1) return std::nullopt;
      int continue_target = shared_targets.front();
      if (continue_target <= 0 || continue_target == pair_convergence) return std::nullopt;
      auto pick_noncontinue_target = [&](int a, int b) -> std::optional<int> {
        if (a == continue_target && b != continue_target) return b;
        if (b == continue_target && a != continue_target) return a;
        return std::nullopt;
      };
      auto true_noncontinue_target = pick_noncontinue_target(true_true_target, true_false_target);
      auto false_noncontinue_target = pick_noncontinue_target(false_true_target, false_false_target);
      if (!true_noncontinue_target.has_value() || !false_noncontinue_target.has_value()) return std::nullopt;
      if (!current_code_function->ComputePhiAssignments(const_cast<CodeBlock*>(true_child_block), continue_target).empty()
          || !current_code_function->ComputePhiAssignments(const_cast<CodeBlock*>(false_child_block), continue_target).empty()
          || !current_code_function->ComputePhiAssignments(const_cast<CodeBlock*>(true_child_block), true_noncontinue_target.value()).empty()
          || !current_code_function->ComputePhiAssignments(const_cast<CodeBlock*>(false_child_block), false_noncontinue_target.value()).empty()) {
        return std::nullopt;
      }
      auto root_condition = ParseWrapped(code_block.code_branch.branch_condition);
      auto true_continue_condition = (true_true_target == continue_target)
                                         ? true_child_condition : std::format("!{}", true_child_condition);
      auto false_continue_condition = (false_true_target == continue_target)
                                          ? false_child_condition : std::format("!{}", false_child_condition);
      auto true_noncontinue_condition = (true_true_target == continue_target)
                                            ? std::format("!{}", true_child_condition) : true_child_condition;
      auto false_noncontinue_condition = (false_true_target == continue_target)
                                             ? std::format("!{}", false_child_condition) : false_child_condition;
      return FoldedSharedContinueJoin{
          .continue_target = continue_target,
          .true_target = true_noncontinue_target.value(),
          .false_target = false_noncontinue_target.value(),
          .use_branch_hint = code_block.code_branch.use_hint
                             || true_child_block->code_branch.use_hint
                             || false_child_block->code_branch.use_hint,
          .continue_target_condition = std::format(
              "(({} && {}) || (!{} && {}))",
              root_condition, true_continue_condition,
              root_condition, false_continue_condition),
          .true_target_condition = std::format("({} && {})", root_condition, ParseWrapped(true_noncontinue_condition)),
          .false_target_condition = std::format("(!{} && {})", root_condition, ParseWrapped(false_noncontinue_condition)),
      };
    };

    // ===== FoldedNestedContinueReduction =====
    auto can_fold_path_reach_target =
        [&](int start_line_number, int target_line_number, auto&& self, std::set<int>& visited) -> bool {
      if (start_line_number == target_line_number) return true;
      if (start_line_number <= 0 || !current_code_function->code_blocks.contains(start_line_number)
          || !visited.emplace(start_line_number).second
          || recursions.contains(start_line_number)) {
        return false;
      }
      const auto& path_code_block = current_code_function->code_blocks.at(start_line_number);
      if (!path_code_block.code_switch.switch_condition.empty()
          || path_code_block.code_branch.branch_condition.empty()
          || path_code_block.code_branch.branch_condition_true <= 0
          || path_code_block.code_branch.branch_condition_false <= 0) {
        return false;
      }
      auto convergence_pair = immediate_postdominators.find(start_line_number);
      if (convergence_pair == immediate_postdominators.end() || convergence_pair->second != pair_convergence) {
        return false;
      }
      return self(path_code_block.code_branch.branch_condition_true, target_line_number, self, visited)
             || self(path_code_block.code_branch.branch_condition_false, target_line_number, self, visited);
    };

    struct FoldedNestedContinueReduction {
      int unique_target;
      int direct_target;
      int nested_convergence;
      bool use_branch_hint;
      std::string unique_condition;
    };

    auto build_folded_nested_continue_reduction =
        [&](const FoldedSharedContinueJoin& shared_continue_join) -> std::optional<FoldedNestedContinueReduction> {
      auto try_orientation =
          [&](int branch_root_target, std::string_view branch_root_entry_condition,
              int direct_target) -> std::optional<FoldedNestedContinueReduction> {
        if (branch_root_target <= 0 || direct_target <= 0 || branch_root_target == direct_target
            || !current_code_function->code_blocks.contains(branch_root_target)
            || recursions.contains(branch_root_target)) {
          return std::nullopt;
        }
        const auto& branch_root_code_block = current_code_function->code_blocks.at(branch_root_target);
        if (!branch_root_code_block.code_switch.switch_condition.empty()
            || branch_root_code_block.code_branch.branch_condition.empty()
            || branch_root_code_block.code_branch.branch_condition_true <= 0
            || branch_root_code_block.code_branch.branch_condition_false <= 0) {
          return std::nullopt;
        }
        auto convergence_pair = immediate_postdominators.find(branch_root_target);
        if (convergence_pair == immediate_postdominators.end()) return std::nullopt;
        int nested_convergence = convergence_pair->second;
        if (nested_convergence <= 0 || nested_convergence == pair_convergence) return std::nullopt;
        auto branch_condition = get_foldable_chain_branch_condition(branch_root_code_block);
        if (!branch_condition.has_value()) return std::nullopt;
        int unique_target = -1;
        std::string unique_branch_condition;
        if (branch_root_code_block.code_branch.branch_condition_true == direct_target
            && branch_root_code_block.code_branch.branch_condition_false != direct_target) {
          unique_target = branch_root_code_block.code_branch.branch_condition_false;
          unique_branch_condition = std::format("!{}", branch_condition.value());
        } else if (branch_root_code_block.code_branch.branch_condition_false == direct_target
                   && branch_root_code_block.code_branch.branch_condition_true != direct_target) {
          unique_target = branch_root_code_block.code_branch.branch_condition_true;
          unique_branch_condition = branch_condition.value();
        } else {
          return std::nullopt;
        }
        if (!current_code_function->ComputePhiAssignments(&code_block, branch_root_target).empty()
            || !current_code_function->ComputePhiAssignments(&code_block, direct_target).empty()
            || !current_code_function->ComputePhiAssignments(
                                         const_cast<CodeBlock*>(&branch_root_code_block), unique_target).empty()
            || !current_code_function->ComputePhiAssignments(
                                         const_cast<CodeBlock*>(&branch_root_code_block), direct_target).empty()) {
          return std::nullopt;
        }
        return FoldedNestedContinueReduction{
            .unique_target = unique_target,
            .direct_target = direct_target,
            .nested_convergence = nested_convergence,
            .use_branch_hint = branch_root_code_block.code_branch.use_hint,
            .unique_condition = std::format("({} && {})", ParseWrapped(branch_root_entry_condition), ParseWrapped(unique_branch_condition)),
        };
      };
      if (auto reduction = try_orientation(shared_continue_join.true_target,
              shared_continue_join.true_target_condition, shared_continue_join.false_target);
          reduction.has_value()) {
        return reduction;
      }
      return try_orientation(shared_continue_join.false_target,
          shared_continue_join.false_target_condition, shared_continue_join.true_target);
    };

    // ===== FoldedSharedBranchLadder =====
    struct FoldedSharedBranchLadder {
      int shared_target;
      int continue_target;
      bool use_branch_hint;
      std::string shared_target_condition;
    };

    auto build_folded_shared_branch_ladder =
        [&](int shared_target, int next_step, bool shared_on_true) -> std::optional<FoldedSharedBranchLadder> {
      if (pair_convergence == -1 || shared_target <= 0 || next_step <= 0
          || shared_target == pair_convergence
          || !current_code_function->code_blocks.contains(next_step)
          || recursions.contains(next_step)) {
        return std::nullopt;
      }
      if (!current_code_function->ComputePhiAssignments(&code_block, next_step).empty()) {
        return std::nullopt;
      }
      auto negate_condition = [&](std::string_view condition) {
        return std::format("!{}", ParseWrapped(condition));
      };
      auto and_conditions = [&](std::string_view a, std::string_view b) {
        return std::format("({} && {})", ParseWrapped(a), ParseWrapped(b));
      };
      auto or_conditions = [&](const std::vector<std::string>& predicates) {
        std::stringstream stream;
        for (size_t i = 0; i < predicates.size(); ++i) {
          if (i != 0) stream << " || ";
          stream << predicates[i];
        }
        return stream.str();
      };
      bool use_branch_hint = code_block.code_branch.use_hint;
      auto root_condition = ParseWrapped(code_block.code_branch.branch_condition);
      std::vector<std::string> shared_predicates = {
          shared_on_true ? std::string(root_condition) : negate_condition(root_condition)};
      std::vector<std::string> continue_predicates;
      std::string current_path_condition =
          shared_on_true ? negate_condition(root_condition) : std::string(root_condition);
      int continue_target = -1;
      std::set<int> visited = {line_number};
      int current_line_number = next_step;
      while (true) {
        if (current_line_number <= 0 || !current_code_function->code_blocks.contains(current_line_number)
            || !visited.emplace(current_line_number).second
            || recursions.contains(current_line_number)) {
          return std::nullopt;
        }
        const auto& ladder_code_block = current_code_function->code_blocks.at(current_line_number);
        if (!ladder_code_block.code_switch.switch_condition.empty()
            || ladder_code_block.code_branch.branch_condition.empty()
            || ladder_code_block.code_branch.branch_condition_true <= 0
            || ladder_code_block.code_branch.branch_condition_false <= 0) {
          return std::nullopt;
        }
        auto convergence_pair = immediate_postdominators.find(current_line_number);
        if (convergence_pair == immediate_postdominators.end() || convergence_pair->second != pair_convergence) {
          return std::nullopt;
        }
        auto ladder_condition = get_foldable_chain_branch_condition(ladder_code_block);
        if (!ladder_condition.has_value()) return std::nullopt;
        use_branch_hint = use_branch_hint || ladder_code_block.code_branch.use_hint;

        struct ClassifiedEdge {
          enum class Kind { Shared, Continue, Next } kind;
          int target;
          std::string predicate;
        };
        auto classify_edge = [&](int edge_target, std::string predicate) -> std::optional<ClassifiedEdge> {
          if (edge_target == shared_target) {
            return ClassifiedEdge{.kind = ClassifiedEdge::Kind::Shared, .target = edge_target, .predicate = std::move(predicate)};
          }
          if (continue_target != -1 && edge_target == continue_target) {
            return ClassifiedEdge{.kind = ClassifiedEdge::Kind::Continue, .target = edge_target, .predicate = std::move(predicate)};
          }
          bool reaches_shared_target = false;
          if (edge_target != pair_convergence) {
            std::set<int> reachability_visited;
            reaches_shared_target = can_fold_path_reach_target(edge_target, shared_target, can_fold_path_reach_target, reachability_visited);
          }
          if (reaches_shared_target) {
            return ClassifiedEdge{.kind = ClassifiedEdge::Kind::Next, .target = edge_target, .predicate = std::move(predicate)};
          }
          return ClassifiedEdge{.kind = ClassifiedEdge::Kind::Continue, .target = edge_target, .predicate = std::move(predicate)};
        };
        auto true_edge = classify_edge(
            ladder_code_block.code_branch.branch_condition_true,
            and_conditions(current_path_condition, ladder_condition.value()));
        auto false_edge = classify_edge(
            ladder_code_block.code_branch.branch_condition_false,
            and_conditions(current_path_condition, negate_condition(ladder_condition.value())));
        if (!true_edge.has_value() || !false_edge.has_value()) return std::nullopt;
        int next_edge_count = 0;
        std::optional<ClassifiedEdge> next_edge;
        for (const auto& edge : {true_edge.value(), false_edge.value()}) {
          switch (edge.kind) {
            case ClassifiedEdge::Kind::Shared:
              if (!current_code_function->ComputePhiAssignments(const_cast<CodeBlock*>(&ladder_code_block), edge.target).empty()) {
                return std::nullopt;
              }
              shared_predicates.push_back(edge.predicate);
              break;
            case ClassifiedEdge::Kind::Continue:
              if (continue_target == -1) {
                continue_target = edge.target;
              } else if (continue_target != edge.target) {
                return std::nullopt;
              }
              if (!current_code_function->ComputePhiAssignments(const_cast<CodeBlock*>(&ladder_code_block), edge.target).empty()) {
                return std::nullopt;
              }
              continue_predicates.push_back(edge.predicate);
              break;
            case ClassifiedEdge::Kind::Next:
              if (!current_code_function->ComputePhiAssignments(const_cast<CodeBlock*>(&ladder_code_block), edge.target).empty()) {
                return std::nullopt;
              }
              ++next_edge_count;
              next_edge = edge;
              break;
          }
        }
        if (next_edge_count > 1) return std::nullopt;
        if (next_edge_count == 0) break;
        current_path_condition = next_edge->predicate;
        current_line_number = next_edge->target;
      }
      if (continue_target == -1 || shared_predicates.empty() || continue_predicates.empty()) {
        return std::nullopt;
      }
      return FoldedSharedBranchLadder{
          .shared_target = shared_target,
          .continue_target = continue_target,
          .use_branch_hint = use_branch_hint,
          .shared_target_condition = or_conditions(shared_predicates),
      };
    };

    // ===== Deferred target detection =====
    auto can_defer_shared_target = [&](int candidate_target, bool allow_phi_assignments = false) -> bool {
      if (pair_convergence == -1 || candidate_target <= 0 || candidate_target == pair_convergence
          || candidate_target <= line_number
          || !current_code_function->code_blocks.contains(candidate_target)
          || recursions.contains(candidate_target)) {
        return false;
      }
      auto predecessor_it = structural_predecessors.find(candidate_target);
      if (predecessor_it == structural_predecessors.end() || predecessor_it->second.size() < 2) {
        return false;
      }
      for (int predecessor_line_number : predecessor_it->second) {
        if (!current_code_function->code_blocks.contains(predecessor_line_number)) return false;
        auto dominator_it = dominators.find(predecessor_line_number);
        if (dominator_it == dominators.end() || !dominator_it->second.contains(line_number)) return false;
        if (!current_code_function->ComputePhiAssignments(
                                      &current_code_function->code_blocks.at(predecessor_line_number),
                                      candidate_target).empty()) {
          if (!allow_phi_assignments) return false;
        }
      }
      return true;
    };

    auto candidate_spans_both_root_sides = [&](int candidate_target) -> bool {
      auto predecessor_it = structural_predecessors.find(candidate_target);
      if (predecessor_it == structural_predecessors.end() || predecessor_it->second.size() < 2) return false;
      bool has_true_side = candidate_target == code_block.code_branch.branch_condition_true;
      bool has_false_side = candidate_target == code_block.code_branch.branch_condition_false;
      for (int predecessor_line_number : predecessor_it->second) {
        auto predecessor_dominators_it = dominators.find(predecessor_line_number);
        if (predecessor_dominators_it == dominators.end()) continue;
        if (predecessor_line_number == code_block.code_branch.branch_condition_true
            || predecessor_dominators_it->second.contains(code_block.code_branch.branch_condition_true)) {
          has_true_side = true;
        }
        if (predecessor_line_number == code_block.code_branch.branch_condition_false
            || predecessor_dominators_it->second.contains(code_block.code_branch.branch_condition_false)) {
          has_false_side = true;
        }
      }
      return has_true_side && has_false_side;
    };

    auto get_convergence_join_rejection_reason = [&](int candidate_target) -> std::optional<std::string> {
      if (pair_convergence == -1 || candidate_target <= 0 || candidate_target == pair_convergence
          || candidate_target <= line_number || candidate_target >= pair_convergence
          || !current_code_function->code_blocks.contains(candidate_target)
          || recursions.contains(candidate_target)) {
        return "out-of-range";
      }
      const auto& candidate_code_block = current_code_function->code_blocks.at(candidate_target);
      if (!candidate_code_block.code_switch.switch_condition.empty()
          || candidate_code_block.code_branch.branch_condition.empty()
          || candidate_code_block.code_branch.branch_condition_true <= 0
          || candidate_code_block.code_branch.branch_condition_false <= 0) {
        return "not-conditional-join";
      }
      const bool true_converges = candidate_code_block.code_branch.branch_condition_true == pair_convergence;
      const bool false_converges = candidate_code_block.code_branch.branch_condition_false == pair_convergence;
      if (true_converges == false_converges) return "not-single-converging-join";
      auto ipdom_it = immediate_postdominators.find(candidate_target);
      if (ipdom_it == immediate_postdominators.end() || ipdom_it->second != pair_convergence) {
        return "ipdom-mismatch";
      }
      auto predecessor_it = structural_predecessors.find(candidate_target);
      if (predecessor_it == structural_predecessors.end() || predecessor_it->second.size() < 2) {
        return "need-multi-preds";
      }
      auto candidate_dominators_it = dominators.find(candidate_target);
      if (candidate_dominators_it == dominators.end()) return "missing-dominators";
      for (int predecessor_line_number : predecessor_it->second) {
        if (!current_code_function->code_blocks.contains(predecessor_line_number)) {
          return std::format("missing-pred-{}", predecessor_line_number);
        }
        auto dominator_it = dominators.find(predecessor_line_number);
        if (dominator_it == dominators.end() || !dominator_it->second.contains(line_number)) {
          return std::format("pred-not-dominated-{}", predecessor_line_number);
        }
      }
      bool has_true_side = candidate_target == code_block.code_branch.branch_condition_true;
      bool has_false_side = candidate_target == code_block.code_branch.branch_condition_false;
      for (int predecessor_line_number : predecessor_it->second) {
        auto predecessor_dominators_it = dominators.find(predecessor_line_number);
        if (predecessor_dominators_it == dominators.end()) continue;
        if (predecessor_line_number == code_block.code_branch.branch_condition_true
            || predecessor_dominators_it->second.contains(code_block.code_branch.branch_condition_true)) {
          has_true_side = true;
        }
        if (predecessor_line_number == code_block.code_branch.branch_condition_false
            || predecessor_dominators_it->second.contains(code_block.code_branch.branch_condition_false)) {
          has_false_side = true;
        }
      }
      if (!has_true_side || !has_false_side) {
        return has_true_side ? "single-side-false" : "single-side-true";
      }
      // Reject if any predecessor of pair_convergence also branches to the candidate
      // (bypass edge — deferring would execute the candidate on the bypass path)
      {
        auto pair_convergence_preds_it = structural_predecessors.find(pair_convergence);
        if (pair_convergence_preds_it != structural_predecessors.end()) {
          auto candidate_preds_set = std::set<int>(predecessor_it->second.begin(), predecessor_it->second.end());
          for (int convergence_predecessor : pair_convergence_preds_it->second) {
            if (convergence_predecessor == candidate_target) continue;
            if (candidate_preds_set.contains(convergence_predecessor)) {
              return std::format("bypass-edge-from-{}", convergence_predecessor);
            }
          }
        }
      }
      // Scope validation for temporary variables
      static const auto TEMP_REFERENCE_REGEX = std::regex(R"(\b_(\d+)\b)");
      for (const auto& hlsl_line : candidate_code_block.hlsl_lines) {
        if (hlsl_line.starts_with("//")) continue;
        auto line = std::string(hlsl_line);
        auto line_declared_variable_number = try_parse_temp_local_assignment_number(hlsl_line);
        auto refs_begin = std::sregex_iterator(line.begin(), line.end(), TEMP_REFERENCE_REGEX);
        auto refs_end = std::sregex_iterator();
        for (auto ref_it = refs_begin; ref_it != refs_end; ++ref_it) {
          int referenced_variable_number = std::stoi((*ref_it)[1].str());
          if (line_declared_variable_number.has_value()
              && referenced_variable_number == line_declared_variable_number.value()) {
            continue;
          }
          auto declaration_it = temporary_declaration_blocks.find(referenced_variable_number);
          if (declaration_it == temporary_declaration_blocks.end()) {
            if (!current_code_function->phi_variables.contains(std::to_string(referenced_variable_number))) {
              return std::format("missing-temp-{}", referenced_variable_number);
            }
            continue;
          }
          int declaration_block_line_number = declaration_it->second;
          if (declaration_block_line_number == candidate_target) continue;
          if (!candidate_dominators_it->second.contains(declaration_block_line_number)) {
            return std::format("temp-{}-decl-after-{}", referenced_variable_number, declaration_block_line_number);
          }
        }
      }
      return std::nullopt;
    };

    auto get_convergence_bridge_rejection_reason = [&](int candidate_target) -> std::optional<std::string> {
      if (pair_convergence == -1 || candidate_target <= 0 || candidate_target == pair_convergence
          || candidate_target <= line_number || candidate_target >= pair_convergence
          || !current_code_function->code_blocks.contains(candidate_target)
          || recursions.contains(candidate_target)) {
        return "out-of-range";
      }
      const auto& candidate_code_block = current_code_function->code_blocks.at(candidate_target);
      if (!candidate_code_block.code_switch.switch_condition.empty()
          || !candidate_code_block.code_branch.branch_condition.empty()
          || candidate_code_block.code_branch.branch_condition_true != pair_convergence
          || candidate_code_block.code_branch.branch_condition_false != -1) {
        return "not-direct-bridge";
      }
      auto ipdom_it = immediate_postdominators.find(candidate_target);
      if (ipdom_it == immediate_postdominators.end() || ipdom_it->second != pair_convergence) {
        return "ipdom-mismatch";
      }
      auto predecessor_it = structural_predecessors.find(candidate_target);
      if (predecessor_it == structural_predecessors.end() || predecessor_it->second.size() < 2) {
        return "need-multi-preds";
      }
      auto candidate_dominators_it = dominators.find(candidate_target);
      if (candidate_dominators_it == dominators.end()) return "missing-dominators";
      for (int predecessor_line_number : predecessor_it->second) {
        if (!current_code_function->code_blocks.contains(predecessor_line_number)) {
          return std::format("missing-pred-{}", predecessor_line_number);
        }
        auto dominator_it = dominators.find(predecessor_line_number);
        if (dominator_it == dominators.end() || !dominator_it->second.contains(line_number)) {
          return std::format("pred-not-dominated-{}", predecessor_line_number);
        }
      }
      bool has_true_side = candidate_target == code_block.code_branch.branch_condition_true;
      bool has_false_side = candidate_target == code_block.code_branch.branch_condition_false;
      for (int predecessor_line_number : predecessor_it->second) {
        auto predecessor_dominators_it = dominators.find(predecessor_line_number);
        if (predecessor_dominators_it == dominators.end()) continue;
        if (predecessor_line_number == code_block.code_branch.branch_condition_true
            || predecessor_dominators_it->second.contains(code_block.code_branch.branch_condition_true)) {
          has_true_side = true;
        }
        if (predecessor_line_number == code_block.code_branch.branch_condition_false
            || predecessor_dominators_it->second.contains(code_block.code_branch.branch_condition_false)) {
          has_false_side = true;
        }
      }
      if (!has_true_side || !has_false_side) {
        return has_true_side ? "single-side-false" : "single-side-true";
      }
      // Scope validation
      static const auto TEMP_REFERENCE_REGEX = std::regex(R"(\b_(\d+)\b)");
      for (const auto& hlsl_line : candidate_code_block.hlsl_lines) {
        if (hlsl_line.starts_with("//")) continue;
        auto line = std::string(hlsl_line);
        auto line_declared_variable_number = try_parse_temp_local_assignment_number(hlsl_line);
        auto refs_begin = std::sregex_iterator(line.begin(), line.end(), TEMP_REFERENCE_REGEX);
        auto refs_end = std::sregex_iterator();
        for (auto ref_it = refs_begin; ref_it != refs_end; ++ref_it) {
          int referenced_variable_number = std::stoi((*ref_it)[1].str());
          if (line_declared_variable_number.has_value()
              && referenced_variable_number == line_declared_variable_number.value()) {
            continue;
          }
          auto declaration_it = temporary_declaration_blocks.find(referenced_variable_number);
          if (declaration_it == temporary_declaration_blocks.end()) {
            if (!current_code_function->phi_variables.contains(std::to_string(referenced_variable_number))) {
              return std::format("missing-temp-{}", referenced_variable_number);
            }
            continue;
          }
          int declaration_block_line_number = declaration_it->second;
          if (declaration_block_line_number == candidate_target) continue;
          if (!candidate_dominators_it->second.contains(declaration_block_line_number)) {
            return std::format("temp-{}-decl-after-{}", referenced_variable_number, declaration_block_line_number);
          }
        }
      }
      return std::nullopt;
    };

    // ===== FoldedSharedBranchConditions =====
    struct FoldedSharedBranchConditions {
      std::string shared_target_condition;
      std::string continue_target_condition;
    };

    auto build_folded_shared_branch_condition =
        [&](const SharedBranchChain& chain) -> std::optional<FoldedSharedBranchConditions> {
      std::vector<std::string> shared_predicates;
      std::vector<std::string> continue_predicates;
      shared_predicates.reserve(chain.steps.size());
      continue_predicates.reserve(chain.steps.size());
      for (size_t step_index = 0; step_index < chain.steps.size(); ++step_index) {
        const auto& chain_step = chain.steps[step_index];
        const auto& chain_code_block = current_code_function->code_blocks.at(chain_step.line_number);
        if (!current_code_function->ComputePhiAssignments(const_cast<CodeBlock*>(&chain_code_block), chain.shared_target).empty()) {
          return std::nullopt;
        }
        if (step_index + 1 < chain.steps.size()) {
          if (!current_code_function->ComputePhiAssignments(
                  const_cast<CodeBlock*>(&chain_code_block), chain.steps[step_index + 1].line_number).empty()) {
            return std::nullopt;
          }
        } else if (chain.final_continue_target != pair_convergence) {
          if (!current_code_function->ComputePhiAssignments(
                  const_cast<CodeBlock*>(&chain_code_block), chain.final_continue_target).empty()) {
            return std::nullopt;
          }
        }
        std::optional<std::string> wrapped_condition;
        if (step_index == 0) {
          wrapped_condition = ParseWrapped(chain_code_block.code_branch.branch_condition);
        } else {
          wrapped_condition = get_foldable_chain_branch_condition(chain_code_block);
          if (!wrapped_condition.has_value()) return std::nullopt;
        }
        if (chain_step.shared_on_true) {
          shared_predicates.push_back(wrapped_condition.value());
          continue_predicates.push_back(std::format("!{}", wrapped_condition.value()));
        } else {
          shared_predicates.push_back(std::format("!{}", wrapped_condition.value()));
          continue_predicates.push_back(wrapped_condition.value());
        }
      }
      if (shared_predicates.empty() || continue_predicates.empty()) return std::nullopt;
      std::stringstream shared_condition_stream;
      for (size_t i = 0; i < shared_predicates.size(); ++i) {
        if (i != 0) shared_condition_stream << " | ";
        shared_condition_stream << shared_predicates[i];
      }
      std::stringstream continue_condition_stream;
      for (size_t i = 0; i < continue_predicates.size(); ++i) {
        if (i != 0) continue_condition_stream << " && ";
        continue_condition_stream << continue_predicates[i];
      }
      return FoldedSharedBranchConditions{
          .shared_target_condition = shared_condition_stream.str(),
          .continue_target_condition = continue_condition_stream.str(),
      };
    };

    // Build all folded structures
    std::optional<FoldedSharedBranchConditions> folded_shared_branch_condition;
    if (shared_branch_chain.has_value()) {
      folded_shared_branch_condition = build_folded_shared_branch_condition(shared_branch_chain.value());
    }
    auto folded_shared_branch_join = build_folded_shared_branch_join();
    auto folded_shared_continue_join = build_folded_shared_continue_join();
    std::optional<FoldedNestedContinueReduction> folded_nested_continue_reduction;
    if (folded_shared_continue_join.has_value()) {
      folded_nested_continue_reduction = build_folded_nested_continue_reduction(folded_shared_continue_join.value());
    }
    std::optional<FoldedSharedBranchLadder> folded_shared_branch_ladder;
    if (pair_convergence != -1) {
      auto true_ladder = build_folded_shared_branch_ladder(code_block.code_branch.branch_condition_true,
                                                           code_block.code_branch.branch_condition_false, true);
      auto false_ladder = build_folded_shared_branch_ladder(code_block.code_branch.branch_condition_false,
                                                            code_block.code_branch.branch_condition_true, false);
      if (true_ladder.has_value()) {
        folded_shared_branch_ladder = std::move(true_ladder);
      } else if (false_ladder.has_value()) {
        folded_shared_branch_ladder = std::move(false_ladder);
      }
    }

    // Deferred phi join target detection
    if (pair_convergence != -1) {
      size_t deferred_phi_join_predecessor_count = 0;
      for (const auto& [candidate_target, candidate_code_block] : current_code_function->code_blocks) {
        if (get_convergence_join_rejection_reason(candidate_target).has_value()) continue;
        if (has_active_deferred_phi_join_target(candidate_target)) continue;
        auto predecessor_it = structural_predecessors.find(candidate_target);
        if (predecessor_it == structural_predecessors.end()
            || predecessor_it->second.size() != 2
            || std::ranges::find(predecessor_it->second, line_number) == predecessor_it->second.end()) {
          continue;
        }
        if (current_code_function->ComputePhiAssignments(&code_block, candidate_target).empty()) continue;
        auto existing_deferred_target = std::ranges::find_if(
            structural_deferred_branch_targets.rbegin(),
            structural_deferred_branch_targets.rend(),
            [&](const auto& entry) { return entry.first == candidate_target; });
        if (existing_deferred_target != structural_deferred_branch_targets.rend()) continue;
        size_t candidate_predecessor_count = predecessor_it->second.size();
        if (!deferred_phi_join_target.has_value()
            || candidate_predecessor_count > deferred_phi_join_predecessor_count
            || (candidate_predecessor_count == deferred_phi_join_predecessor_count
                && candidate_target > deferred_phi_join_target.value())) {
          deferred_phi_join_target = candidate_target;
          deferred_phi_join_predecessor_count = candidate_predecessor_count;
        }
      }
    }

    auto branch_plan = current_code_function->AnalyzeBranchStructure(line_number, immediate_postdominators, ladder_index);
    auto should_skip_simple_two_arm_defer = [&](int candidate_target) {
      if (!branch_plan.has_value() || branch_plan->shape != "if/else"
          || branch_plan->arm_count != 2 || !branch_plan->exits.contains(candidate_target)) {
        return false;
      }
      auto predecessor_it = structural_predecessors.find(candidate_target);
      if (predecessor_it == structural_predecessors.end() || predecessor_it->second.size() > 2) return false;
      if (ladder_index.owner.contains(candidate_target)) return false;
      return true;
    };

    // Deferred shared target setup
    std::vector<std::pair<int, std::string>> deferred_shared_targets;
    const bool allow_deferred_shared_targets = !decompile_options.flatten;
    if (pair_convergence != -1 && allow_deferred_shared_targets) {
      std::optional<int> deferred_target;
      size_t deferred_target_predecessor_count = 0;
      auto consider_deferred_target = [&](int candidate_target) {
        if (deferred_phi_join_target.has_value() && candidate_target == deferred_phi_join_target.value()) return;
        if (has_active_deferred_phi_join_target(candidate_target)) return;
        if (should_skip_simple_two_arm_defer(candidate_target)) return;
        if (!can_defer_shared_target(candidate_target)) return;
        size_t candidate_predecessor_count = structural_predecessors.at(candidate_target).size();
        if (!deferred_target.has_value()
            || candidate_predecessor_count > deferred_target_predecessor_count
            || (candidate_predecessor_count == deferred_target_predecessor_count
                && candidate_target > deferred_target.value())) {
          deferred_target = candidate_target;
          deferred_target_predecessor_count = candidate_predecessor_count;
        }
      };
      if (folded_shared_branch_join.has_value()) {
        consider_deferred_target(folded_shared_branch_join->shared_target);
        consider_deferred_target(folded_shared_branch_join->continue_target);
      }
      if (folded_shared_continue_join.has_value()) {
        consider_deferred_target(folded_shared_continue_join->continue_target);
      }
      if (folded_shared_branch_ladder.has_value()) {
        consider_deferred_target(folded_shared_branch_ladder->shared_target);
        consider_deferred_target(folded_shared_branch_ladder->continue_target);
      }
      if (shared_branch_chain.has_value()) {
        consider_deferred_target(shared_branch_chain->shared_target);
        if (shared_branch_chain->final_continue_target != pair_convergence) {
          consider_deferred_target(shared_branch_chain->final_continue_target);
        }
      }
      for (const auto& [candidate_target, candidate_code_block_unused] : current_code_function->code_blocks) {
        if (has_active_deferred_phi_join_target(candidate_target)) continue;
        auto join_rejection_reason = get_convergence_join_rejection_reason(candidate_target);
        if (!join_rejection_reason.has_value()) {
          if (deferred_phi_join_target.has_value() && candidate_target == deferred_phi_join_target.value()) continue;
          if (should_skip_simple_two_arm_defer(candidate_target)) continue;
          size_t candidate_predecessor_count = structural_predecessors.at(candidate_target).size();
          if (!deferred_target.has_value()
              || candidate_predecessor_count > deferred_target_predecessor_count
              || (candidate_predecessor_count == deferred_target_predecessor_count
                  && candidate_target > deferred_target.value())) {
            deferred_target = candidate_target;
            deferred_target_predecessor_count = candidate_predecessor_count;
          }
          continue;
        }
        auto bridge_rejection_reason = get_convergence_bridge_rejection_reason(candidate_target);
        if (bridge_rejection_reason.has_value()) continue;
        size_t candidate_predecessor_count = structural_predecessors.at(candidate_target).size();
        if (!deferred_target.has_value()
            || candidate_predecessor_count > deferred_target_predecessor_count
            || (candidate_predecessor_count == deferred_target_predecessor_count
                && candidate_target > deferred_target.value())) {
          deferred_target = candidate_target;
          deferred_target_predecessor_count = candidate_predecessor_count;
        }
      }

      // Secondary phi deferred target
      std::optional<int> secondary_phi_deferred_target;
      size_t secondary_phi_deferred_target_predecessor_count = 0;
      for (const auto& [candidate_target, candidate_code_block_unused2] : current_code_function->code_blocks) {
        if (candidate_target == deferred_phi_join_target
            || (deferred_target.has_value() && candidate_target == deferred_target.value())
            || has_active_deferred_phi_join_target(candidate_target)) {
          continue;
        }
        if (!candidate_spans_both_root_sides(candidate_target)) continue;
        if (!can_defer_shared_target(candidate_target, true)) continue;
        bool has_phi_assignments = false;
        auto predecessor_it = structural_predecessors.find(candidate_target);
        if (predecessor_it == structural_predecessors.end()) continue;
        for (int predecessor_line_number : predecessor_it->second) {
          if (!current_code_function->ComputePhiAssignments(
                  &current_code_function->code_blocks.at(predecessor_line_number), candidate_target).empty()) {
            has_phi_assignments = true;
            break;
          }
        }
        if (!has_phi_assignments) continue;
        size_t candidate_predecessor_count = predecessor_it->second.size();
        if (!secondary_phi_deferred_target.has_value()
            || candidate_predecessor_count > secondary_phi_deferred_target_predecessor_count
            || (candidate_predecessor_count == secondary_phi_deferred_target_predecessor_count
                && candidate_target > secondary_phi_deferred_target.value())) {
          secondary_phi_deferred_target = candidate_target;
          secondary_phi_deferred_target_predecessor_count = candidate_predecessor_count;
        }
      }

      if (deferred_target.has_value()) {
        auto existing = std::ranges::find_if(
            structural_deferred_branch_targets.rbegin(), structural_deferred_branch_targets.rend(),
            [&](const auto& entry) { return entry.first == deferred_target.value(); });
        if (existing != structural_deferred_branch_targets.rend()) {
          deferred_target.reset();
        }
      }
      if (deferred_target.has_value()) {
        auto deferred_target_variable = std::format("__defer_{}_{}", line_number, deferred_target.value());
        emit_annotation_comment(std::format("defer-target bb {} target={} preds={} phi=no",
            line_number, deferred_target.value(), deferred_target_predecessor_count));
        string_stream << spacing << "bool " << deferred_target_variable << " = false;\n";
        structural_deferred_branch_targets.emplace_back(deferred_target.value(), deferred_target_variable);
        deferred_shared_targets.emplace_back(deferred_target.value(), deferred_target_variable);
      }
      if (secondary_phi_deferred_target.has_value()) {
        auto existing = std::ranges::find_if(
            structural_deferred_branch_targets.rbegin(), structural_deferred_branch_targets.rend(),
            [&](const auto& entry) { return entry.first == secondary_phi_deferred_target.value(); });
        if (existing == structural_deferred_branch_targets.rend()) {
          auto deferred_target_variable = std::format("__defer_{}_{}", line_number, secondary_phi_deferred_target.value());
          emit_annotation_comment(std::format("defer-target bb {} target={} preds={} phi=yes",
              line_number, secondary_phi_deferred_target.value(), secondary_phi_deferred_target_predecessor_count));
          string_stream << spacing << "bool " << deferred_target_variable << " = false;\n";
          structural_deferred_branch_targets.emplace_back(secondary_phi_deferred_target.value(), deferred_target_variable);
          deferred_shared_targets.emplace_back(secondary_phi_deferred_target.value(), deferred_target_variable);
        }
      }
    }

    // ===== Main emission decision tree =====
    bool pushed_deferred_phi_join_target = false;
    if (deferred_phi_join_target.has_value()) {
      active_deferred_phi_join_targets.push_back(deferred_phi_join_target.value());
      pushed_deferred_phi_join_target = true;
    }

    auto emit_single_branch = [&](bool take_true_branch) {
      if (code_block.code_branch.use_hint) {
        string_stream << spacing << "[branch]\n";
      }
      if (take_true_branch) {
        string_stream << spacing << std::format("if {} {{\n", ParseWrapped(code_block.code_branch.branch_condition));
        indent_spacing();
        on_branch_assuming(code_block.code_branch.branch_condition_true, true);
        unindent_spacing();
      } else {
        string_stream << spacing << "if (!" << code_block.code_branch.branch_condition << ") {\n";
        indent_spacing();
        on_branch_assuming(code_block.code_branch.branch_condition_false, false);
        unindent_spacing();
      }
      close_lonely_if(pair_convergence);
    };

    auto emit_full_branch = [&](bool true_branch_first) {
      if (code_block.code_branch.use_hint) {
        string_stream << spacing << "[branch]\n";
      }
      if (true_branch_first) {
        string_stream << spacing << std::format("if {} {{\n", ParseWrapped(code_block.code_branch.branch_condition));
        indent_spacing();
        on_branch_assuming(code_block.code_branch.branch_condition_true, true);
        unindent_spacing();
        string_stream << spacing << "} else {\n";
        indent_spacing();
        on_branch_assuming(code_block.code_branch.branch_condition_false, false);
        unindent_spacing();
        string_stream << spacing << "}\n";
      } else {
        string_stream << spacing << "if (!" << code_block.code_branch.branch_condition << ") {\n";
        indent_spacing();
        on_branch_assuming(code_block.code_branch.branch_condition_false, false);
        unindent_spacing();
        string_stream << spacing << "} else {\n";
        indent_spacing();
        on_branch_assuming(code_block.code_branch.branch_condition_true, true);
        unindent_spacing();
        string_stream << spacing << "}\n";
      }
    };

    if (pair_convergence == code_block.code_branch.branch_condition_true) {
      emit_single_branch(false);
    } else if (pair_convergence == code_block.code_branch.branch_condition_false) {
      emit_single_branch(true);
    } else if (folded_shared_branch_join.has_value()) {
      emit_annotation_comment(std::format("fold shared-branch-join bb {} shared={} continue={}",
          line_number, folded_shared_branch_join->shared_target, folded_shared_branch_join->continue_target));
      if (folded_shared_branch_join->use_branch_hint) {
        string_stream << spacing << "[branch]\n";
      }
      string_stream << spacing << "if (" << folded_shared_branch_join->shared_target_condition << ") {\n";
      indent_spacing();
      append_or_defer(folded_shared_branch_join->shared_target);
      unindent_spacing();
      string_stream << spacing << "} else {\n";
      indent_spacing();
      append_or_defer(folded_shared_branch_join->continue_target);
      unindent_spacing();
      string_stream << spacing << "}\n";
    } else if (folded_shared_continue_join.has_value()) {
      emit_annotation_comment(std::format("fold shared-continue-join bb {} continue={} true={} false={}",
          line_number, folded_shared_continue_join->continue_target,
          folded_shared_continue_join->true_target, folded_shared_continue_join->false_target));
      if (folded_shared_continue_join->use_branch_hint) {
        string_stream << spacing << "[branch]\n";
      }
      string_stream << spacing << "if (" << folded_shared_continue_join->continue_target_condition << ") {\n";
      indent_spacing();
      append_or_defer(folded_shared_continue_join->continue_target);
      unindent_spacing();
      string_stream << spacing << "} else {\n";
      indent_spacing();
      if (folded_nested_continue_reduction.has_value()) {
        emit_annotation_comment(std::format("fold nested-continue-reduction bb {} unique={} direct={} converge={}",
            line_number, folded_nested_continue_reduction->unique_target,
            folded_nested_continue_reduction->direct_target, folded_nested_continue_reduction->nested_convergence));
        if (folded_nested_continue_reduction->use_branch_hint) {
          string_stream << spacing << "[branch]\n";
        }
        structural_pending_convergences.push_back(folded_nested_continue_reduction->nested_convergence);
        string_stream << spacing << "if (" << folded_nested_continue_reduction->unique_condition << ") {\n";
        indent_spacing();
        structural_append_code_block(folded_nested_continue_reduction->unique_target);
        unindent_spacing();
        string_stream << spacing << "} else {\n";
        indent_spacing();
        structural_append_code_block(folded_nested_continue_reduction->direct_target);
        unindent_spacing();
        string_stream << spacing << "}\n";
        structural_pending_convergences.pop_back();
        structural_append_code_block(folded_nested_continue_reduction->nested_convergence);
      } else {
        string_stream << spacing << "if (" << ParseWrapped(code_block.code_branch.branch_condition) << ") {\n";
        indent_spacing();
        append_or_defer(folded_shared_continue_join->true_target);
        unindent_spacing();
        string_stream << spacing << "} else {\n";
        indent_spacing();
        append_or_defer(folded_shared_continue_join->false_target);
        unindent_spacing();
        string_stream << spacing << "}\n";
      }
      unindent_spacing();
      string_stream << spacing << "}\n";
    } else if (folded_shared_branch_ladder.has_value()) {
      emit_annotation_comment(std::format("fold shared-branch-ladder bb {} shared={} continue={}",
          line_number, folded_shared_branch_ladder->shared_target, folded_shared_branch_ladder->continue_target));
      if (folded_shared_branch_ladder->use_branch_hint) {
        string_stream << spacing << "[branch]\n";
      }
      string_stream << spacing << "if (" << folded_shared_branch_ladder->shared_target_condition << ") {\n";
      indent_spacing();
      append_or_defer(folded_shared_branch_ladder->shared_target);
      unindent_spacing();
      string_stream << spacing << "} else {\n";
      indent_spacing();
      append_or_defer(folded_shared_branch_ladder->continue_target);
      unindent_spacing();
      string_stream << spacing << "}\n";
    } else if (shared_branch_chain.has_value() && folded_shared_branch_condition.has_value()) {
      emit_annotation_comment(std::format("fold shared-branch-chain-cond bb {} shared={} continue={}",
          line_number, shared_branch_chain->shared_target, shared_branch_chain->final_continue_target));
      bool use_branch_hint = false;
      for (const auto& chain_step : shared_branch_chain->steps) {
        if (current_code_function->code_blocks.at(chain_step.line_number).code_branch.use_hint) {
          use_branch_hint = true;
          break;
        }
      }
      if (use_branch_hint) {
        string_stream << spacing << "[branch]\n";
      }
      const auto& last_chain_step = shared_branch_chain->steps.back();
      auto& last_chain_code_block = current_code_function->code_blocks.at(last_chain_step.line_number);
      if (shared_branch_chain->final_continue_target != pair_convergence) {
        string_stream << spacing << "if (" << folded_shared_branch_condition->continue_target_condition << ") {\n";
        indent_spacing();
        on_branch_from(&last_chain_code_block, shared_branch_chain->final_continue_target);
        unindent_spacing();
        string_stream << spacing << "} else {\n";
        indent_spacing();
        append_or_defer(shared_branch_chain->shared_target);
        unindent_spacing();
        string_stream << spacing << "}\n";
      } else {
        string_stream << spacing << "if (" << folded_shared_branch_condition->shared_target_condition << ") {\n";
        indent_spacing();
        append_or_defer(shared_branch_chain->shared_target);
        unindent_spacing();
        string_stream << spacing << "} else {\n";
        indent_spacing();
        emit_phi_assignments(&last_chain_code_block, pair_convergence);
        unindent_spacing();
        string_stream << spacing << "}\n";
      }
    } else if (shared_branch_chain.has_value()) {
      // Fallback: emit the chain step-by-step with a branch variable
      emit_annotation_comment(std::format("fold shared-branch-chain-fallback bb {} shared={} continue={}",
          line_number, shared_branch_chain->shared_target, shared_branch_chain->final_continue_target));
      const auto& shared_target_code_block =
          current_code_function->code_blocks.at(shared_branch_chain->shared_target);
      const bool inlineable_shared_target =
          shared_target_code_block.code_switch.switch_condition.empty()
          && shared_target_code_block.code_branch.branch_condition.empty()
          && shared_target_code_block.code_branch.branch_condition_true > 0
          && shared_target_code_block.code_branch.branch_condition_false == -1
          && shared_target_code_block.hlsl_lines.empty();
      std::string chain_branch_variable;
      if (!inlineable_shared_target) {
        chain_branch_variable = std::format("__branch_chain_{}", line_number);
        string_stream << spacing << "bool " << chain_branch_variable << ";\n";
      }
      std::function<void(size_t, CodeBlock*)> emit_shared_branch_chain_step =
          [&](size_t step_index, CodeBlock* predecessor_code_block) {
            const auto& chain_step = shared_branch_chain->steps[step_index];
            auto& chain_code_block = current_code_function->code_blocks[chain_step.line_number];
            if (predecessor_code_block != nullptr) {
              emit_phi_assignments(predecessor_code_block, chain_step.line_number);
              emit_code_block_prelude(chain_step.line_number);
            }
            auto emit_chain_branch = [&](bool take_shared_target) {
              if (take_shared_target) {
                emit_phi_assignments(&chain_code_block, shared_branch_chain->shared_target);
                if (inlineable_shared_target) {
                  on_branch_from(const_cast<CodeBlock*>(&shared_target_code_block),
                                 shared_target_code_block.code_branch.branch_condition_true);
                } else {
                  string_stream << spacing << chain_branch_variable << " = true;\n";
                }
              } else if (step_index + 1 < shared_branch_chain->steps.size()) {
                emit_shared_branch_chain_step(step_index + 1, &chain_code_block);
              } else {
                if (inlineable_shared_target && shared_branch_chain->final_continue_target != pair_convergence) {
                  on_branch_from(&chain_code_block, shared_branch_chain->final_continue_target);
                } else {
                  if (shared_branch_chain->final_continue_target == pair_convergence) {
                    emit_phi_assignments(&chain_code_block, pair_convergence);
                  }
                  if (!inlineable_shared_target) {
                    string_stream << spacing << chain_branch_variable << " = false;\n";
                  }
                }
              }
            };
            if (chain_code_block.code_branch.use_hint) {
              string_stream << spacing << "[branch]\n";
            }
            if (chain_step.shared_on_true) {
              string_stream << spacing << std::format("if {} {{\n", ParseWrapped(chain_code_block.code_branch.branch_condition));
            } else {
              string_stream << spacing << "if (!" << chain_code_block.code_branch.branch_condition << ") {\n";
            }
            indent_spacing();
            with_assumed_condition(chain_code_block.code_branch.branch_condition, chain_step.shared_on_true, [&]() {
              emit_chain_branch(true);
            });
            unindent_spacing();
            string_stream << spacing << "} else {\n";
            indent_spacing();
            with_assumed_condition(chain_code_block.code_branch.branch_condition, !chain_step.shared_on_true, [&]() {
              emit_chain_branch(false);
            });
            unindent_spacing();
            string_stream << spacing << "}\n";
          };
      emit_shared_branch_chain_step(0, nullptr);
      if (!inlineable_shared_target) {
        string_stream << spacing << "if (" << chain_branch_variable << ") {\n";
        indent_spacing();
        append_or_defer(shared_branch_chain->shared_target);
        unindent_spacing();
        if (shared_branch_chain->final_continue_target != pair_convergence) {
          string_stream << spacing << "} else {\n";
          indent_spacing();
          const auto& last_chain_step = shared_branch_chain->steps.back();
          auto& last_chain_code_block = current_code_function->code_blocks.at(last_chain_step.line_number);
          on_branch_from(&last_chain_code_block, shared_branch_chain->final_continue_target);
          unindent_spacing();
          string_stream << spacing << "}\n";
        } else {
          string_stream << spacing << "}\n";
        }
      }
    } else if (branch_plan.has_value() && branch_plan->shape == "if" && branch_plan->arm_count == 1) {
      if (branch_plan->then_target > 0 && branch_plan->then_target != branch_plan->convergence
          && (branch_plan->else_target <= 0 || branch_plan->else_target == branch_plan->convergence)) {
        emit_single_branch(true);
      } else if (branch_plan->else_target > 0 && branch_plan->else_target != branch_plan->convergence
                 && (branch_plan->then_target <= 0 || branch_plan->then_target == branch_plan->convergence)) {
        emit_single_branch(false);
      } else if (code_block.code_branch.branch_condition_true < code_block.code_branch.branch_condition_false) {
        emit_full_branch(true);
      } else {
        emit_full_branch(false);
      }
    } else if (branch_plan.has_value() && branch_plan->shape == "if/else" && branch_plan->arm_count == 2) {
      emit_full_branch(true);
    } else if (code_block.code_branch.branch_condition_true < code_block.code_branch.branch_condition_false) {
      emit_full_branch(true);
    } else {
      emit_full_branch(false);
    }

    // Deferred phi join target emission
    if (deferred_phi_join_target.has_value()) {
      emit_annotation_comment(std::format("append phi-join bb {} target={}", line_number, deferred_phi_join_target.value()));
      structural_append_code_block(deferred_phi_join_target.value());
    }
    if (pushed_deferred_phi_join_target) {
      active_deferred_phi_join_targets.pop_back();
    }

    // Convergence completion
    if (pushed_pair_convergence) {
      structural_pending_convergences.pop_back();
      bool is_empty = structural_pending_convergences.empty();
      on_branch(pair_convergence, true);
      if (!is_empty && uses_convergence_wrapper) {
        unindent_spacing();
        string_stream << spacing << "} while (false);\n";
      }
    }

    // Deferred shared target emission
    for (const auto& [deferred_target, deferred_target_variable] : deferred_shared_targets) {
      string_stream << spacing << "if (" << deferred_target_variable << ") {\n";
      indent_spacing();
      structural_append_code_block(deferred_target);
      unindent_spacing();
      string_stream << spacing << "}\n";
    }
    for (size_t deferred_target_index = 0; deferred_target_index < deferred_shared_targets.size(); ++deferred_target_index) {
      structural_deferred_branch_targets.pop_back();
    }

    on_complete();
  };  // end structural_append_code_block

  // The structural emitter can still produce break-to-ancestor loop jumps in
  // on_branch_from() for some nested-loop shapes even when the conservative
  // pre-scan above misses them. Declare the helper for any structural loop;
  // unused locals are harmless, while missing this declaration breaks HLSL.
  if (uses_loop_jump_target || !recursions.empty()) {
    string_stream << spacing << "int " << LOOP_JUMP_TARGET_NAME << " = -1;\n";
  }

  structural_append_code_block(0);
}
// ===== END STRUCTURAL =====
