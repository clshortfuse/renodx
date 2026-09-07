// ===== MERMAID DIAGRAM OUTPUT =====
// Generates Mermaid flowchart diagrams from CodeFunction's control flow graph.
// These are methods on the CodeFunction class, #included inside the class body.
//
// Usage: decomp.exe shader.cso output.md --mermaid
// The output is a Mermaid flowchart that can be rendered in any Mermaid viewer.
    static std::string EscapeMermaidLabel(std::string_view input) {
      std::string output;
      output.reserve(input.size());
      for (const auto character : input) {
        switch (character) {
          case '&':
            output += "&amp;";
            break;
          case '"':
            output += "&quot;";
            break;
          case '<':
            output += "&lt;";
            break;
          case '>':
            output += "&gt;";
            break;
          default:
            output.push_back(character);
            break;
        }
      }
      return output;
    }

    static std::string MermaidNodeId(std::string_view prefix, int line_number) {
      return std::format("{}_bb{}", prefix, line_number);
    }

    static std::string MermaidOrderNodeId(std::string_view prefix, size_t index) {
      return std::format("{}_ord{}", prefix, index);
    }

    static std::string MermaidPlanNodeId(std::string_view prefix, std::string_view kind, int line_number) {
      return std::format("{}_{}_{}", prefix, kind, line_number);
    }

    std::string BuildMermaid(std::string_view prefix) const {
      try {
        std::stringstream string_stream;
        auto predecessors = ListPredecessorsVec();
        auto postdominators = ListPostDominators();
        auto immediate_postdominators = ListImmediatePostDominators(postdominators);
        auto recursions = ListRecursions();
        size_t edge_index = 0;
        std::vector<std::string> branch_nodes;
        std::vector<std::string> join_nodes;
        std::vector<std::string> loop_nodes;

      auto summarize_ints = [](const auto& values, size_t max_items = 4) {
        std::stringstream summary;
        size_t index = 0;
        for (const auto value : values) {
          if (index != 0) {
            summary << ", ";
          }
          if (index >= max_items) {
            summary << "+" << (values.size() - max_items);
            break;
          }
          summary << value;
          ++index;
        }
        return summary.str();
      };

      auto summarize_strings = [](const auto& values, size_t max_items = 4) {
        std::stringstream summary;
        size_t index = 0;
        for (const auto& value : values) {
          if (index != 0) {
            summary << ", ";
          }
          if (index >= max_items) {
            summary << "+" << (values.size() - max_items);
            break;
          }
          summary << value;
          ++index;
        }
        return summary.str();
      };

      auto summarize_phi_variables = [&](const CodeBlock& code_block) {
        std::set<std::string> phi_variables;
        for (const auto& phi_data : code_block.phi_lines) {
          phi_variables.emplace(std::format("_{}", phi_data.variable));
        }
        return summarize_strings(phi_variables);
      };

      auto truncate_label = [](std::string_view label, size_t max_size = 96) {
        if (label.size() <= max_size) {
          return std::string(label);
        }
        return std::format("{}...", label.substr(0, max_size - 3));
      };

      auto debug_parse_variable = [&](std::string_view input, std::string_view expected_type) {
        return std::format("_{}",  input.substr(1));
      };

      auto format_debug_phi_value = [&](std::string_view value, std::string_view type) {
        auto debug_type = [&]() -> std::string_view {
          if (type == "i1") return "bool";
          if (type == "i32" || type == "int") return "int";
          if (type == "i16" || type == "int16_t") return "int16_t";
          if (type == "uint" || type == "uint16_t") return "uint";
          if (type == "f16" || type == "half" || type == "min16float") return "half";
          return "float";
        }();

        if (value.empty()) {
          return std::string{};
        }
        if (value.starts_with('%')) {
          return debug_parse_variable(value, debug_type);
        }
        if (type == "i1") return ParseBoolString(value);
        if (type == "i32" || type == "int" || type == "i16" || type == "int16_t") return ParseIntString(value);
        if (type == "uint" || type == "uint16_t") return ParseUintString(value);
        if (type == "f16" || type == "half" || type == "min16float") return ParseSuffixedString(value, 'h');
        return ParseSuffixedString(value, 'f');
      };

      auto summarize_edge_phi_assignments = [&](int predecessor, int target) {
        std::vector<std::string> phi_assignments;
        std::unordered_set<std::string> seen_assignments;
        auto predecessor_it = code_blocks.find(predecessor);
        if (predecessor_it == code_blocks.end()) {
          return std::string{};
        }
        for (const auto& phi_data : predecessor_it->second.phi_lines) {
          if (phi_data.code_function == target && phi_data.is_assign) {
            auto formatted_value = OptimizeString(format_debug_phi_value(phi_data.value, phi_data.type));
            auto assignment = std::format("_{}={}", phi_data.variable, formatted_value);
            if (seen_assignments.emplace(assignment).second) {
              phi_assignments.push_back(assignment);
            }
          }
        }
        if (phi_assignments.empty()) {
          return std::string{};
        }

        std::stringstream assignment_stream;
        size_t emitted_count = 0;
        constexpr size_t MAX_ASSIGNMENTS = 3;
        for (size_t i = 0; i < phi_assignments.size() && emitted_count < MAX_ASSIGNMENTS; ++i, ++emitted_count) {
          if (emitted_count != 0) {
            assignment_stream << ", ";
          }
          assignment_stream << phi_assignments[i];
        }
        if (phi_assignments.size() > MAX_ASSIGNMENTS) {
          assignment_stream << ", +" << (phi_assignments.size() - MAX_ASSIGNMENTS);
        }
        return truncate_label(assignment_stream.str(), 72);
      };

      auto entry_block = code_blocks.empty() ? -1 : code_blocks.begin()->first;

      auto is_loop_header = [&](int line_number) {
        auto recursion_it = recursions.find(line_number);
        return recursion_it != recursions.end() && !recursion_it->second.empty();
      };

      auto is_anchor_block = [&](int line_number) {
        auto code_block_it = code_blocks.find(line_number);
        if (code_block_it == code_blocks.end()) {
          return false;
        }
        const auto& code_block = code_block_it->second;
        auto successors = ListNormalizedSuccessors(code_block);
        auto predecessor_it = predecessors.find(line_number);
        const auto predecessor_count = predecessor_it == predecessors.end() ? 0u : predecessor_it->second.size();
        return line_number == entry_block
            || successors.empty()
            || !code_block.code_switch.switch_condition.empty()
            || !code_block.code_branch.branch_condition.empty()
            || predecessor_count > 1
            || !code_block.phi_lines.empty()
            || is_loop_header(line_number);
      };

      auto ladder_index = BuildBranchLadderIndex(predecessors, immediate_postdominators);

      auto function_name = name.empty() ? std::string("anonymous") : std::string(name);
      string_stream << "  subgraph " << prefix << "[\"" << EscapeMermaidLabel(function_name) << "\"]\n";
      string_stream << "    direction TB\n";

      std::vector<int> ordered_blocks;
      ordered_blocks.reserve(code_blocks.size());

      for (const auto& [line_number, code_block] : code_blocks) {
        ordered_blocks.push_back(line_number);
        std::vector<std::string> label_lines = {
            EscapeMermaidLabel(std::format("bb {}", line_number))};

        auto predecessor_it = predecessors.find(line_number);
        if (predecessor_it != predecessors.end() && !predecessor_it->second.empty()) {
          label_lines.push_back(EscapeMermaidLabel(std::format("preds: {}", predecessor_it->second.size())));
          if (predecessor_it->second.size() > 1) {
            label_lines.push_back(EscapeMermaidLabel(std::format("join: {}", summarize_ints(predecessor_it->second))));
          }
        }

        auto immediate_postdominator_it = immediate_postdominators.find(line_number);
        if (immediate_postdominator_it != immediate_postdominators.end()) {
          label_lines.push_back(EscapeMermaidLabel(std::format("ipdom: {}", immediate_postdominator_it->second)));
        }

        if (!code_block.phi_lines.empty()) {
          label_lines.push_back(EscapeMermaidLabel(std::format("phi: {}", code_block.phi_lines.size())));
          auto phi_summary = summarize_phi_variables(code_block);
          if (!phi_summary.empty()) {
            label_lines.push_back(EscapeMermaidLabel(std::format("phi vars: {}", phi_summary)));
          }
        }

        if (!code_block.code_switch.switch_condition.empty()) {
          label_lines.push_back(EscapeMermaidLabel(std::format("switch {}", truncate_label(code_block.code_switch.switch_condition))));
        } else if (!code_block.code_branch.branch_condition.empty()) {
          label_lines.push_back(EscapeMermaidLabel(std::format("if {}", truncate_label(code_block.code_branch.branch_condition))));
        } else if (code_block.code_branch.branch_condition_true != -1) {
          label_lines.push_back(EscapeMermaidLabel(std::format("goto {}", code_block.code_branch.branch_condition_true)));
        } else {
          label_lines.push_back("terminal");
        }

        std::stringstream label_stream;
        for (size_t label_index = 0; label_index < label_lines.size(); ++label_index) {
          if (label_index != 0) {
            label_stream << "<br/>";
          }
          label_stream << label_lines[label_index];
        }

        string_stream << "    " << MermaidNodeId(prefix, line_number)
                      << "[\"" << label_stream.str() << "\"]\n";

        if (!code_block.code_switch.switch_condition.empty() || !code_block.code_branch.branch_condition.empty()) {
          branch_nodes.push_back(MermaidNodeId(prefix, line_number));
        }
        if ((predecessor_it != predecessors.end() && predecessor_it->second.size() > 1) || !code_block.phi_lines.empty()) {
          join_nodes.push_back(MermaidNodeId(prefix, line_number));
        }
        if (auto recursion_it = recursions.find(line_number);
            recursion_it != recursions.end() && !recursion_it->second.empty()) {
          loop_nodes.push_back(MermaidNodeId(prefix, line_number));
        }
      }

      const bool use_ordering_scaffold = ordered_blocks.size() <= 24;
      if (use_ordering_scaffold) {
        for (size_t block_index = 0; block_index < ordered_blocks.size(); ++block_index) {
          string_stream << "    " << MermaidOrderNodeId(prefix, block_index) << "[\" \"]\n";
        }
      }

      string_stream << "  end\n";

      if (use_ordering_scaffold) {
        std::stringstream hidden_class_stream;
        hidden_class_stream << "  class ";
        for (size_t block_index = 0; block_index < ordered_blocks.size(); ++block_index) {
          if (block_index != 0) {
            hidden_class_stream << ",";
          }
          hidden_class_stream << MermaidOrderNodeId(prefix, block_index);
        }
        hidden_class_stream << " hidden\n";
        string_stream << hidden_class_stream.str();
      }

      for (const auto& [line_number, code_block] : code_blocks) {
        auto edge_operator = [&](int target) {
          auto recursion_it = recursions.find(target);
          if (recursion_it != recursions.end() && recursion_it->second.contains(line_number)) {
            return "-.->";
          }
          return "-->";
        };

        auto write_edge = [&](int target, std::string_view label) {
          if (target < 0 || !code_blocks.contains(target)) {
            return;
          }

          std::string full_label = std::string(label);
          auto phi_summary = summarize_edge_phi_assignments(line_number, target);
          if (!phi_summary.empty()) {
            if (!full_label.empty()) {
              full_label += " ";
            }
            full_label += std::format("phi {}", phi_summary);
          }

          string_stream << "  " << MermaidNodeId(prefix, line_number)
                        << " " << edge_operator(target);
          if (!full_label.empty()) {
            string_stream << "|"
                          << EscapeMermaidLabel(full_label)
                          << "|";
          }
          string_stream << " " << MermaidNodeId(prefix, target) << "\n";
          ++edge_index;
        };

        if (!code_block.code_switch.switch_condition.empty()) {
          std::map<int, std::vector<std::string>> labeled_targets;
          labeled_targets[code_block.code_switch.case_default].push_back("default");
          for (const auto& [case_value, case_function] : code_block.code_switch.case_values) {
            labeled_targets[case_function].push_back(std::format("case {}", case_value));
          }

          for (const auto& [target, labels] : labeled_targets) {
            std::stringstream label_stream;
            for (size_t label_index = 0; label_index < labels.size(); ++label_index) {
              if (label_index != 0) {
                label_stream << ", ";
              }
              label_stream << labels[label_index];
            }
            write_edge(target, label_stream.str());
          }
          continue;
        }

        if (!code_block.code_branch.branch_condition.empty()) {
          write_edge(code_block.code_branch.branch_condition_true, "T");
          write_edge(code_block.code_branch.branch_condition_false, "F");
        } else {
          write_edge(code_block.code_branch.branch_condition_true, "");
        }

        if ((!code_block.code_switch.switch_condition.empty() || !code_block.code_branch.branch_condition.empty())) {
          auto immediate_postdominator_it = immediate_postdominators.find(line_number);
          if (immediate_postdominator_it != immediate_postdominators.end()) {
            auto join_target = immediate_postdominator_it->second;
            if (join_target >= 0 && code_blocks.contains(join_target)
                && join_target != code_block.code_branch.branch_condition_true
                && join_target != code_block.code_branch.branch_condition_false) {
              std::string join_label = "join";
              if (auto target_it = code_blocks.find(join_target);
                  target_it != code_blocks.end() && !target_it->second.phi_lines.empty()) {
                join_label = "join phi";
              }
              string_stream << "  " << MermaidNodeId(prefix, line_number)
                            << " -.->|" << EscapeMermaidLabel(join_label) << "| "
                            << MermaidNodeId(prefix, join_target) << "\n";
              ++edge_index;
            }
          }
        }
      }

      if (use_ordering_scaffold) {
        for (size_t block_index = 0; block_index < ordered_blocks.size(); ++block_index) {
          string_stream << "  " << MermaidOrderNodeId(prefix, block_index)
                        << " --> " << MermaidNodeId(prefix, ordered_blocks[block_index]) << "\n";
          string_stream << "  linkStyle " << edge_index++
                        << " stroke:transparent,fill:none,color:transparent;\n";
        }
        for (size_t block_index = 0; block_index + 1 < ordered_blocks.size(); ++block_index) {
          string_stream << "  " << MermaidOrderNodeId(prefix, block_index)
                        << " --> " << MermaidOrderNodeId(prefix, block_index + 1) << "\n";
          string_stream << "  linkStyle " << edge_index++
                        << " stroke:transparent,fill:none,color:transparent;\n";
        }
      }

      if (entry_block != -1) {
        string_stream << "  class " << MermaidNodeId(prefix, entry_block) << " entry\n";
      }
      for (const auto& branch_node : branch_nodes) {
        string_stream << "  class " << branch_node << " branch\n";
      }
      for (const auto& join_node : join_nodes) {
        string_stream << "  class " << join_node << " join\n";
      }
      for (const auto& loop_node : loop_nodes) {
        string_stream << "  class " << loop_node << " loop\n";
      }

        const auto plan_prefix = std::format("{}_plan", prefix);
        try {
          string_stream << BuildMermaidPlan(plan_prefix);
        } catch (const std::exception& ex) {
          throw std::runtime_error(std::format("BuildMermaidPlan({}): {}", prefix, ex.what()));
        }
        if (entry_block != -1) {
          string_stream << "  " << MermaidNodeId(prefix, entry_block)
                        << " -.->|plan| "
                        << MermaidPlanNodeId(plan_prefix, "bb", entry_block)
                        << "\n";
        }
        for (const auto& [line_number, code_block] : code_blocks) {
          std::string plan_node_id;
          if (auto ladder_it = ladder_index.owner.find(line_number); ladder_it != ladder_index.owner.end()) {
            if (ladder_it->second != line_number) {
              continue;
            }
            plan_node_id = MermaidPlanNodeId(plan_prefix, "ladder", line_number);
          } else if (is_anchor_block(line_number)) {
            plan_node_id = MermaidPlanNodeId(plan_prefix, "bb", line_number);
          } else {
            continue;
          }
          string_stream << "  " << MermaidNodeId(prefix, line_number)
                        << " ~~~ " << plan_node_id << "\n";
        }

        return string_stream.str();
      } catch (const std::exception& ex) {
        throw std::runtime_error(std::format("BuildMermaid({}): {}", prefix, ex.what()));
      }
    }

    std::string BuildMermaidPlan(std::string_view prefix) const {
      std::stringstream string_stream;
      auto predecessors = ListPredecessorsVec();
      auto postdominators = ListPostDominators();
      auto immediate_postdominators = ListImmediatePostDominators(postdominators);
      auto recursions = ListRecursions();

      auto summarize_ints = [](const auto& values, size_t max_items = 4) {
        std::stringstream summary;
        size_t index = 0;
        for (const auto value : values) {
          if (index != 0) {
            summary << ", ";
          }
          if (index >= max_items) {
            summary << "+" << (values.size() - max_items);
            break;
          }
          summary << value;
          ++index;
        }
        return summary.str();
      };

      auto summarize_strings = [](const auto& values, size_t max_items = 4) {
        std::stringstream summary;
        size_t index = 0;
        for (const auto& value : values) {
          if (index != 0) {
            summary << ", ";
          }
          if (index >= max_items) {
            summary << "+" << (values.size() - max_items);
            break;
          }
          summary << value;
          ++index;
        }
        return summary.str();
      };

      auto truncate_label = [](std::string_view label, size_t max_size = 72) {
        if (label.size() <= max_size) {
          return std::string(label);
        }
        return std::format("{}...", label.substr(0, max_size - 3));
      };

      auto debug_parse_variable = [&](std::string_view input, std::string_view expected_type) {
        return std::format("_{}",  input.substr(1));
      };

      auto format_debug_phi_value = [&](std::string_view value, std::string_view type) {
        auto debug_type = [&]() -> std::string_view {
          if (type == "i1") return "bool";
          if (type == "i32" || type == "int") return "int";
          if (type == "i16" || type == "int16_t") return "int16_t";
          if (type == "uint" || type == "uint16_t") return "uint";
          if (type == "f16" || type == "half" || type == "min16float") return "half";
          return "float";
        }();

        if (value.empty()) {
          return std::string{};
        }
        if (value.starts_with('%')) {
          return debug_parse_variable(value, debug_type);
        }
        if (type == "i1") return ParseBoolString(value);
        if (type == "i32" || type == "int" || type == "i16" || type == "int16_t") return ParseIntString(value);
        if (type == "uint" || type == "uint16_t") return ParseUintString(value);
        if (type == "f16" || type == "half" || type == "min16float") return ParseSuffixedString(value, 'h');
        return ParseSuffixedString(value, 'f');
      };

      auto summarize_edge_phi_assignments = [&](int predecessor, int target) {
        std::vector<std::string> phi_assignments;
        std::unordered_set<std::string> seen_assignments;
        auto predecessor_it = code_blocks.find(predecessor);
        if (predecessor_it == code_blocks.end()) {
          return std::string{};
        }
        for (const auto& phi_data : predecessor_it->second.phi_lines) {
          if (phi_data.code_function == target && phi_data.is_assign) {
            auto formatted_value = OptimizeString(format_debug_phi_value(phi_data.value, phi_data.type));
            auto assignment = std::format("_{}={}", phi_data.variable, formatted_value);
            if (seen_assignments.emplace(assignment).second) {
              phi_assignments.push_back(assignment);
            }
          }
        }
        if (phi_assignments.empty()) {
          return std::string{};
        }

        std::stringstream assignment_stream;
        size_t emitted_count = 0;
        constexpr size_t MAX_ASSIGNMENTS = 3;
        for (size_t i = 0; i < phi_assignments.size() && emitted_count < MAX_ASSIGNMENTS; ++i, ++emitted_count) {
          if (emitted_count != 0) {
            assignment_stream << ", ";
          }
          assignment_stream << phi_assignments[i];
        }
        if (phi_assignments.size() > MAX_ASSIGNMENTS) {
          assignment_stream << ", +" << (phi_assignments.size() - MAX_ASSIGNMENTS);
        }
        return truncate_label(assignment_stream.str(), 72);
      };

      auto summarize_phi_variables = [&](const CodeBlock& code_block) {
        std::set<std::string> phi_variables;
        for (const auto& phi_data : code_block.phi_lines) {
          phi_variables.emplace(std::format("_{}", phi_data.variable));
        }
        return summarize_strings(phi_variables);
      };

      auto summarize_join_carriers = [&](int target) {
        auto predecessor_it = predecessors.find(target);
        if (predecessor_it == predecessors.end() || predecessor_it->second.empty()) {
          return std::string{};
        }

        std::vector<std::pair<std::vector<int>, std::string>> grouped;
        std::unordered_map<std::string, size_t> group_index;
        for (const auto predecessor : predecessor_it->second) {
          auto summary = summarize_edge_phi_assignments(predecessor, target);
          if (summary.empty()) {
            continue;
          }
          auto [it, inserted] = group_index.emplace(summary, grouped.size());
          if (inserted) {
            grouped.push_back({{predecessor}, summary});
          } else {
            grouped[it->second].first.push_back(predecessor);
          }
        }

        if (grouped.empty()) {
          return std::string{};
        }

        std::stringstream carrier_stream;
        constexpr size_t MAX_GROUPS = 3;
        for (size_t i = 0; i < grouped.size() && i < MAX_GROUPS; ++i) {
          if (i != 0) {
            carrier_stream << "; ";
          }
          carrier_stream << summarize_ints(grouped[i].first) << "=>" << grouped[i].second;
        }
        if (grouped.size() > MAX_GROUPS) {
          carrier_stream << "; +" << (grouped.size() - MAX_GROUPS);
        }
        return truncate_label(carrier_stream.str(), 120);
      };

      auto entry_block = code_blocks.empty() ? -1 : code_blocks.begin()->first;
      auto is_loop_header = [&](int line_number) {
        auto recursion_it = recursions.find(line_number);
        return recursion_it != recursions.end() && !recursion_it->second.empty();
      };

      auto is_anchor_block = [&](int line_number) {
        auto code_block_it = code_blocks.find(line_number);
        if (code_block_it == code_blocks.end()) {
          return false;
        }
        const auto& code_block = code_block_it->second;
        auto successors = ListNormalizedSuccessors(code_block);
        auto predecessor_it = predecessors.find(line_number);
        const auto predecessor_count = predecessor_it == predecessors.end() ? 0u : predecessor_it->second.size();
        return line_number == entry_block
            || successors.empty()
            || !code_block.code_switch.switch_condition.empty()
            || !code_block.code_branch.branch_condition.empty()
            || predecessor_count > 1
            || !code_block.phi_lines.empty()
            || is_loop_header(line_number);
      };

      auto ladder_index = BuildBranchLadderIndex(predecessors, immediate_postdominators);

      struct PlanNode {
        std::string id;
        std::string class_name;
        std::vector<int> members;
      };

      std::vector<PlanNode> plan_nodes;
      std::unordered_map<int, size_t> block_to_plan_node;

      auto add_plan_node = [&](std::string id, std::string class_name, std::vector<int> members, std::vector<std::string> label_lines) {
        std::stringstream label_stream;
        for (size_t label_index = 0; label_index < label_lines.size(); ++label_index) {
          if (label_index != 0) {
            label_stream << "<br/>";
          }
          label_stream << EscapeMermaidLabel(label_lines[label_index]);
        }

        string_stream << "  " << id << "[\"" << label_stream.str() << "\"]\n";

        auto index = plan_nodes.size();
        plan_nodes.push_back({
            .id = std::move(id),
            .class_name = std::move(class_name),
            .members = std::move(members),
        });
        for (const auto member : plan_nodes.back().members) {
          block_to_plan_node[member] = index;
        }
      };

      auto function_name = name.empty() ? std::string("anonymous") : std::string(name);
      string_stream << "  subgraph " << prefix << "[\"" << EscapeMermaidLabel(std::format("{} plan", function_name)) << "\"]\n";
      string_stream << "    direction TB\n";

      for (const auto& [root, ladder] : ladder_index.ladders) {
        std::set<int> member_blocks(ladder.blocks.begin(), ladder.blocks.end());
        std::set<int> unique_exits;
        std::map<int, std::vector<std::string>> exit_phi_summaries;
        for (const auto block : ladder.blocks) {
          for (const auto successor : ListNormalizedSuccessors(code_blocks.at(block))) {
            if (!member_blocks.contains(successor)) {
              unique_exits.emplace(successor);
              if (auto phi_summary = summarize_edge_phi_assignments(block, successor); !phi_summary.empty()) {
                exit_phi_summaries[successor].push_back(std::format("{}=>{}", block, phi_summary));
              }
            }
          }
        }

        std::vector<std::string> label_lines = {
            std::format("ladder {}..{}", ladder.blocks.front(), ladder.blocks.back()),
            std::format("shape: if / else-if x{}", ladder.blocks.size() - 1),
            std::format("tests: {}", ladder.blocks.size()),
        };
        auto branch_plan = AnalyzeBranchStructure(root, immediate_postdominators, ladder_index);
        if (branch_plan.has_value()) {
          label_lines.push_back(std::format("arms: {}", branch_plan->arm_count));
          label_lines.push_back(std::format("else: {}", branch_plan->has_else ? "yes" : "no"));
          if (branch_plan->convergence != -1) {
            label_lines.push_back(std::format("join: {}", branch_plan->convergence));
          }
        }
        if (!unique_exits.empty()) {
          label_lines.push_back(std::format("exits: {}", summarize_ints(unique_exits)));
          for (const auto& exit_target : unique_exits) {
            auto exit_phi_it = exit_phi_summaries.find(exit_target);
            if (exit_phi_it == exit_phi_summaries.end() || exit_phi_it->second.empty()) {
              continue;
            }
            label_lines.push_back(std::format(
                "exit phi {}: {}",
                exit_target,
                summarize_strings(exit_phi_it->second, 2)));
          }
        }

        add_plan_node(
            MermaidPlanNodeId(prefix, "ladder", root),
            "planladder",
            ladder.blocks,
            label_lines);
      }

      for (const auto& [line_number, code_block] : code_blocks) {
        if (block_to_plan_node.contains(line_number)) {
          continue;
        }
        if (!is_anchor_block(line_number)) {
          continue;
        }

        auto successors = ListNormalizedSuccessors(code_block);
        auto predecessor_it = predecessors.find(line_number);
        auto predecessor_count = predecessor_it == predecessors.end() ? 0u : predecessor_it->second.size();
        auto phi_summary = summarize_phi_variables(code_block);
        auto branch_plan = AnalyzeBranchStructure(line_number, immediate_postdominators, ladder_index);

        std::string class_name = "planseq";
        std::vector<std::string> label_lines;
        if (line_number == entry_block) {
          class_name = "planentry";
          label_lines.push_back(std::format("entry bb {}", line_number));
        } else if (successors.empty()) {
          class_name = "planexit";
          label_lines.push_back(std::format("exit bb {}", line_number));
        } else if (is_loop_header(line_number)) {
          class_name = "planloop";
          label_lines.push_back(std::format("loop bb {}", line_number));
        } else if (predecessor_count > 1 || !code_block.phi_lines.empty()) {
          class_name = "planjoin";
          label_lines.push_back(std::format("join bb {}", line_number));
        } else if (!code_block.code_switch.switch_condition.empty()) {
          class_name = "planbranch";
          label_lines.push_back(std::format("switch bb {}", line_number));
        } else if (!code_block.code_branch.branch_condition.empty()) {
          class_name = "planbranch";
          label_lines.push_back(std::format("if bb {}", line_number));
        } else {
          class_name = "planseq";
          label_lines.push_back(std::format("seq bb {}", line_number));
        }

        if (!phi_summary.empty()) {
          label_lines.push_back(std::format("phi {}", phi_summary));
        }
        if (auto carrier_summary = summarize_join_carriers(line_number); !carrier_summary.empty()) {
          label_lines.push_back(std::format("incoming {}", carrier_summary));
        }
        if (branch_plan.has_value()) {
          label_lines.push_back(std::format("shape: {}", branch_plan->shape));
          if (branch_plan->test_count > 0) {
            label_lines.push_back(std::format("tests: {}", branch_plan->test_count));
          }
          if (branch_plan->arm_count > 0) {
            label_lines.push_back(std::format("arms: {}", branch_plan->arm_count));
          }
          if (branch_plan->shape == "if/else") {
            label_lines.push_back("else: yes");
          } else if (branch_plan->shape == "if") {
            label_lines.push_back("else: no");
          }
          if (branch_plan->convergence != -1) {
            label_lines.push_back(std::format("join: {}", branch_plan->convergence));
          }
        }
        if (!code_block.code_switch.switch_condition.empty()) {
          label_lines.push_back(std::format("switch {}", truncate_label(code_block.code_switch.switch_condition)));
        } else if (!code_block.code_branch.branch_condition.empty()) {
          label_lines.push_back(std::format("if {}", truncate_label(code_block.code_branch.branch_condition)));
        } else if (code_block.code_branch.branch_condition_true != -1) {
          label_lines.push_back(std::format("goto {}", code_block.code_branch.branch_condition_true));
        }

        add_plan_node(
            MermaidPlanNodeId(prefix, "bb", line_number),
            class_name,
            {line_number},
            label_lines);
      }

      auto resolve_plan_target = [&](int start) -> std::pair<size_t, size_t> {
        std::set<int> visited;
        int current = start;
        size_t collapsed = 0;
        while (current >= 0) {
          if (auto plan_it = block_to_plan_node.find(current);
              plan_it != block_to_plan_node.end()) {
            return {plan_it->second, collapsed};
          }
          if (!visited.emplace(current).second) {
            break;
          }
          auto block_it = code_blocks.find(current);
          if (block_it == code_blocks.end()) {
            break;
          }
          auto successors = ListNormalizedSuccessors(block_it->second);
          if (successors.size() != 1) {
            break;
          }
          current = successors.front();
          ++collapsed;
        }
        return {static_cast<size_t>(-1), collapsed};
      };

      struct PlanEdge {
        size_t from = static_cast<size_t>(-1);
        size_t to = static_cast<size_t>(-1);
        std::string label;
        bool dashed = false;

        auto operator<=>(const PlanEdge&) const = default;
      };

      std::set<PlanEdge> plan_edges;

      auto add_plan_edge = [&](size_t from, int successor, std::string label, bool dashed = false) {
        auto [target, collapsed] = resolve_plan_target(successor);
        if (target == static_cast<size_t>(-1) || target == from) {
          return;
        }
        if (plan_nodes[from].members.size() == 1) {
          auto phi_summary = summarize_edge_phi_assignments(plan_nodes[from].members.front(), successor);
          if (!phi_summary.empty()) {
            if (!label.empty()) {
              label += " ";
            }
            label += std::format("phi {}", phi_summary);
          }
        }
        if (collapsed > 0) {
          if (!label.empty()) {
            label += " ";
          }
          label += std::format("+{}", collapsed);
        }
        plan_edges.emplace(PlanEdge{
            .from = from,
            .to = target,
            .label = std::move(label),
            .dashed = dashed,
        });
      };

      for (size_t node_index = 0; node_index < plan_nodes.size(); ++node_index) {
        const auto& plan_node = plan_nodes[node_index];
        if (plan_node.class_name == "planladder") {
          auto ladder_root = plan_node.members.front();
          auto ladder_it = ladder_index.ladders.find(ladder_root);
          if (ladder_it == ladder_index.ladders.end()) {
            continue;
          }

          std::set<int> member_blocks(ladder_it->second.blocks.begin(), ladder_it->second.blocks.end());
          std::map<int, size_t> exit_counts;
          for (const auto block : ladder_it->second.blocks) {
            for (const auto successor : ListNormalizedSuccessors(code_blocks.at(block))) {
              if (!member_blocks.contains(successor)) {
                ++exit_counts[successor];
              }
            }
          }

          for (const auto& [exit_target, count] : exit_counts) {
            auto label = count > 1 ? "match" : "fallthrough";
            add_plan_edge(node_index, exit_target, label);
          }
          continue;
        }

        const auto block = plan_node.members.front();
        const auto& code_block = code_blocks.at(block);
        if (!code_block.code_switch.switch_condition.empty()) {
          add_plan_edge(node_index, code_block.code_switch.case_default, "default");
          for (const auto& [case_value, case_function] : code_block.code_switch.case_values) {
            add_plan_edge(node_index, case_function, std::format("case {}", case_value));
          }
          continue;
        }
        if (!code_block.code_branch.branch_condition.empty()) {
          add_plan_edge(node_index, code_block.code_branch.branch_condition_true, "T");
          add_plan_edge(node_index, code_block.code_branch.branch_condition_false, "F");
          continue;
        }
        if (code_block.code_branch.branch_condition_true != -1) {
          add_plan_edge(node_index, code_block.code_branch.branch_condition_true, "");
        }
      }

      for (const auto& edge : plan_edges) {
        string_stream << "  " << plan_nodes[edge.from].id
                      << (edge.dashed ? " -.->" : " -->");
        if (!edge.label.empty()) {
          string_stream << "|" << EscapeMermaidLabel(edge.label) << "|";
        }
        string_stream << " " << plan_nodes[edge.to].id << "\n";
      }

      string_stream << "  end\n";

      for (const auto& plan_node : plan_nodes) {
        string_stream << "  class " << plan_node.id << " " << plan_node.class_name << "\n";
      }

      return string_stream.str();
    }

