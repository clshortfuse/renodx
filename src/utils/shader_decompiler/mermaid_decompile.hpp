/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 *
 * Mermaid Decompile Strategy — Condition-based HLSL emission via Graph IR
 *
 * This file is #included into the CodeFunction class body inside
 * shader_decompiler_dxc.hpp, within the Decompile() method's strategy
 * dispatch block. It has access to all CodeFunction members, PreprocessState,
 * and the string_stream output.
 *
 * Strategy overview:
 *   Phase 1: Build typed Graph IR from code_blocks
 *   Loop Detection: Identify natural loops via back-edge validation
 *   Condition-Based Emission: Compute reaching conditions, emit flat guarded blocks
 */

// ============================================================
// Phase 1: Graph IR — Data Structures and Construction
// ============================================================

{
  // Reference to the parent-scope stringstream for region helper functions.
  // These are emitted BEFORE main() by the splice logic in shader_decompiler_dxc.hpp.
  auto& mermaid_region_functions = mermaid_pre_main_functions;
  int mermaid_region_counter = 0;

  // Annotation prefix: "// [mermaid] " for --annotate-mermaid, "// --- " for --annotate
  const bool use_mermaid_prefix = decompile_options.annotate_mermaid;
  auto ann_block = [&](int block_id) { return use_mermaid_prefix ? std::format("// [mermaid] block {}", block_id) : std::format("// --- block {}", block_id); };
  auto ann_loop_block = [&](int block_id) { return use_mermaid_prefix ? std::format("// [mermaid] loop block {}", block_id) : std::format("// --- loop block {}", block_id); };

  // --- Graph IR data structures (Task 3.1) ---

  enum class GraphNodeType {
    Entry,
    Branch,
    LoopHeader,
    Join,
    Switch,
    Sequence,
    Terminal
  };

  enum class GraphEdgeType {
    Unconditional,
    TrueBranch,
    FalseBranch,
    BackEdge,
    SwitchCase
  };

  struct PhiAssignment {
    std::string variable;   // e.g., "_1234"
    std::string type;       // LLVM IR type (e.g., "i32", "float")
    std::string value;      // Raw LLVM IR value (e.g., "%42", "0.0", "undef")
  };

  struct GraphNode {
    int block_id = -1;
    GraphNodeType type = GraphNodeType::Sequence;
    std::vector<int> successors;
    std::vector<int> predecessors;
    int ipdom = -1;
  };

  struct GraphEdge {
    int source = -1;
    int target = -1;
    GraphEdgeType type = GraphEdgeType::Unconditional;
    std::vector<PhiAssignment> phi_assignments;
  };

  // --- Graph IR construction (Task 3.2) ---

  // Call existing analysis functions
  auto mermaid_recursions = current_code_function->ListRecursions();
  auto mermaid_predecessors = current_code_function->ListPredecessorsVec();
  auto mermaid_idom = current_code_function->ComputeDominators();
  auto mermaid_postdominators = current_code_function->ListPostDominators();
  auto mermaid_ipdom = current_code_function->ListImmediatePostDominators(mermaid_postdominators);

  // Build dominator sets for back-edge validation
  auto mermaid_dom_sets = current_code_function->ListDominators();

  // Storage for the Graph IR
  std::map<int, GraphNode> graph_nodes;
  std::vector<GraphEdge> graph_edges;

  // Determine entry block (first block in sorted code_blocks)
  // Edge case: empty code_blocks produces empty main function body (Task 8.2)
  int mermaid_entry_block = -1;
  if (!current_code_function->code_blocks.empty()) {
    mermaid_entry_block = current_code_function->code_blocks.begin()->first;
  }

  // Walk code_blocks once, classify each block
  for (const auto& [line_number, code_block] : current_code_function->code_blocks) {
    GraphNode node;
    node.block_id = line_number;

    // Compute successors via existing ListNormalizedSuccessors
    node.successors = current_code_function->ListNormalizedSuccessors(code_block);

    // Predecessors from precomputed map
    if (mermaid_predecessors.contains(line_number)) {
      node.predecessors = mermaid_predecessors.at(line_number);
    }

    // Immediate post-dominator
    if (mermaid_ipdom.contains(line_number)) {
      node.ipdom = mermaid_ipdom.at(line_number);
    }

    // Classify node type using priority: Entry > Terminal > LoopHeader > Switch > Branch > Join > Sequence
    if (line_number == mermaid_entry_block) {
      node.type = GraphNodeType::Entry;
    } else if (node.successors.empty()) {
      node.type = GraphNodeType::Terminal;
    } else if (mermaid_recursions.contains(line_number)) {
      node.type = GraphNodeType::LoopHeader;
    } else if (!code_block.code_switch.switch_condition.empty()) {
      node.type = GraphNodeType::Switch;
    } else if (!code_block.code_branch.branch_condition.empty()) {
      node.type = GraphNodeType::Branch;
    } else if (node.predecessors.size() > 1 || !code_block.phi_lines.empty()) {
      node.type = GraphNodeType::Join;
    } else {
      node.type = GraphNodeType::Sequence;
    }

    graph_nodes[line_number] = std::move(node);
  }

  // Build a set of true back-edge targets using dominator-based detection.
  // A block is a loop header only if it has an incoming edge where
  // source >= target AND target dominates source.
  // This is more precise than ListRecursions() which may include
  // convergence edges that look like back-edges but aren't.
  std::set<int> mermaid_backedge_targets;
  for (const auto& [src_line, src_block] : current_code_function->code_blocks) {
    auto succs = current_code_function->ListNormalizedSuccessors(src_block);
    for (int tgt : succs) {
      if (src_line >= tgt && mermaid_dom_sets.contains(src_line)
          && mermaid_dom_sets.at(src_line).contains(tgt)) {
        mermaid_backedge_targets.insert(tgt);
      }
    }
  }

  // Reclassify nodes: only mark as LoopHeader if they have a true back-edge
  for (auto& [line_number, node] : graph_nodes) {
    if (node.type == GraphNodeType::LoopHeader && !mermaid_backedge_targets.contains(line_number)) {
      // Reclassify: this was marked as LoopHeader by ListRecursions but
      // has no true back-edge. Reclassify based on its properties.
      const auto& code_block = current_code_function->code_blocks.at(line_number);
      if (!code_block.code_switch.switch_condition.empty()) {
        node.type = GraphNodeType::Switch;
      } else if (!code_block.code_branch.branch_condition.empty()) {
        node.type = GraphNodeType::Branch;
      } else if (node.predecessors.size() > 1 || !code_block.phi_lines.empty()) {
        node.type = GraphNodeType::Join;
      } else {
        node.type = GraphNodeType::Sequence;
      }
    }
  }

  // Build edges from branch conditions and classify edge types
  for (const auto& [line_number, code_block] : current_code_function->code_blocks) {
    bool has_branch_condition = !code_block.code_branch.branch_condition.empty();
    bool has_switch = !code_block.code_switch.switch_condition.empty();

    // Helper: detect back-edge (source line >= target line AND target dominates source)
    auto is_back_edge = [&](int source, int target) -> bool {
      if (source < target) return false;
      // Check if target dominates source using dominator sets
      if (mermaid_dom_sets.contains(source)) {
        return mermaid_dom_sets.at(source).contains(target);
      }
      return false;
    };

    // Helper: extract phi assignments for an edge (source -> target)
    // Stores raw LLVM IR types/values — parsing deferred to emission phase
    auto extract_phi_assignments = [&](int source, int target) -> std::vector<PhiAssignment> {
      std::vector<PhiAssignment> assignments;
      // phi_lines are stored on the SOURCE block (the predecessor).
      // Each PhiData entry has code_function = target block.
      const auto& source_block = current_code_function->code_blocks.at(source);
      for (const auto& phi : source_block.phi_lines) {
        if (phi.is_assign && phi.code_function == target) {
          PhiAssignment pa;
          pa.variable = std::format("_{}", phi.variable);
          pa.type = phi.type;      // Raw LLVM IR type
          pa.value = phi.value;    // Raw LLVM IR value — parsed during emission
          assignments.push_back(std::move(pa));
        }
      }
      return assignments;
    };

    if (has_switch) {
      // Switch edges
      if (code_block.code_switch.case_default >= 0 &&
          current_code_function->code_blocks.contains(code_block.code_switch.case_default)) {
        GraphEdge edge;
        edge.source = line_number;
        edge.target = code_block.code_switch.case_default;
        edge.type = is_back_edge(line_number, edge.target) ? GraphEdgeType::BackEdge : GraphEdgeType::SwitchCase;
        edge.phi_assignments = extract_phi_assignments(line_number, edge.target);
        graph_edges.push_back(std::move(edge));
      }
      for (const auto& [case_value, case_function] : code_block.code_switch.case_values) {
        if (case_function >= 0 && current_code_function->code_blocks.contains(case_function)) {
          GraphEdge edge;
          edge.source = line_number;
          edge.target = case_function;
          edge.type = is_back_edge(line_number, case_function) ? GraphEdgeType::BackEdge : GraphEdgeType::SwitchCase;
          edge.phi_assignments = extract_phi_assignments(line_number, case_function);
          graph_edges.push_back(std::move(edge));
        }
      }
    } else if (has_branch_condition) {
      // Conditional branch — true and false edges
      int true_target = code_block.code_branch.branch_condition_true;
      int false_target = code_block.code_branch.branch_condition_false;

      if (true_target >= 0 && current_code_function->code_blocks.contains(true_target)) {
        GraphEdge edge;
        edge.source = line_number;
        edge.target = true_target;
        edge.type = is_back_edge(line_number, true_target) ? GraphEdgeType::BackEdge : GraphEdgeType::TrueBranch;
        edge.phi_assignments = extract_phi_assignments(line_number, true_target);
        graph_edges.push_back(std::move(edge));
      }
      if (false_target >= 0 && current_code_function->code_blocks.contains(false_target)) {
        GraphEdge edge;
        edge.source = line_number;
        edge.target = false_target;
        edge.type = is_back_edge(line_number, false_target) ? GraphEdgeType::BackEdge : GraphEdgeType::FalseBranch;
        edge.phi_assignments = extract_phi_assignments(line_number, false_target);
        graph_edges.push_back(std::move(edge));
      }
    } else {
      // Unconditional branch — single successor
      // Could be branch_condition_true with no condition (goto), or fallthrough
      int target = code_block.code_branch.branch_condition_true;
      if (target >= 0 && current_code_function->code_blocks.contains(target)) {
        GraphEdge edge;
        edge.source = line_number;
        edge.target = target;
        edge.type = is_back_edge(line_number, target) ? GraphEdgeType::BackEdge : GraphEdgeType::Unconditional;
        edge.phi_assignments = extract_phi_assignments(line_number, target);
        graph_edges.push_back(std::move(edge));
      }
    }
  }

  // Full graph IR dump — only with --annotate-mermaid (verbose, for decompiler debugging)
  if (decompile_options.annotate_mermaid) {
    string_stream << spacing << "// [mermaid] Graph IR: " << graph_nodes.size() << " nodes, "
                  << graph_edges.size() << " edges\n";
    for (const auto& [block_id, node] : graph_nodes) {
      const char* type_str = "Sequence";
      switch (node.type) {
        case GraphNodeType::Entry: type_str = "Entry"; break;
        case GraphNodeType::Branch: type_str = "Branch"; break;
        case GraphNodeType::LoopHeader: type_str = "LoopHeader"; break;
        case GraphNodeType::Join: type_str = "Join"; break;
        case GraphNodeType::Switch: type_str = "Switch"; break;
        case GraphNodeType::Sequence: type_str = "Sequence"; break;
        case GraphNodeType::Terminal: type_str = "Terminal"; break;
      }
      string_stream << spacing << "// [mermaid]   node " << block_id << ": " << type_str
                    << " succ=[";
      for (size_t i = 0; i < node.successors.size(); ++i) {
        if (i > 0) string_stream << ",";
        string_stream << node.successors[i];
      }
      string_stream << "] pred=[";
      for (size_t i = 0; i < node.predecessors.size(); ++i) {
        if (i > 0) string_stream << ",";
        string_stream << node.predecessors[i];
      }
      string_stream << "] ipdom=" << node.ipdom << "\n";
    }
    for (const auto& edge : graph_edges) {
      const char* edge_str = "Unconditional";
      switch (edge.type) {
        case GraphEdgeType::Unconditional: edge_str = "Unconditional"; break;
        case GraphEdgeType::TrueBranch: edge_str = "TrueBranch"; break;
        case GraphEdgeType::FalseBranch: edge_str = "FalseBranch"; break;
        case GraphEdgeType::BackEdge: edge_str = "BackEdge"; break;
        case GraphEdgeType::SwitchCase: edge_str = "SwitchCase"; break;
      }
      string_stream << spacing << "// [mermaid]   edge " << edge.source << " -> " << edge.target
                    << " [" << edge_str << "]";
      if (!edge.phi_assignments.empty()) {
        string_stream << " phi={";
        for (size_t i = 0; i < edge.phi_assignments.size(); ++i) {
          if (i > 0) string_stream << ", ";
          string_stream << edge.phi_assignments[i].variable << ":" << edge.phi_assignments[i].type;
        }
        string_stream << "}";
      }
      string_stream << "\n";
    }
  }

  // ============================================================
  // Phase 1.5: Graph Normalization
  // ============================================================
  std::set<int> synthetic_blocks;

  // ============================================================
  // CondExpr — Boolean expression tree for reaching conditions
  // ============================================================

  struct CondExpr {
    enum class Kind { Const, Var, Not, And, Or };
    Kind kind;
    bool const_val = false;                              // for Kind::Const
    std::string var_name;                                // for Kind::Var (e.g., "__cond_3612")
    std::shared_ptr<CondExpr> child;                     // for Kind::Not
    std::vector<std::shared_ptr<CondExpr>> children;     // for Kind::And, Kind::Or
  };

  using CondExprPtr = std::shared_ptr<CondExpr>;

  // --- Factory functions ---

  auto make_const = [](bool val) -> CondExprPtr {
    auto e = std::make_shared<CondExpr>();
    e->kind = CondExpr::Kind::Const;
    e->const_val = val;
    return e;
  };

  auto make_var = [](const std::string& name) -> CondExprPtr {
    auto e = std::make_shared<CondExpr>();
    e->kind = CondExpr::Kind::Var;
    e->var_name = name;
    return e;
  };

  auto make_not = [](CondExprPtr child) -> CondExprPtr {
    auto e = std::make_shared<CondExpr>();
    e->kind = CondExpr::Kind::Not;
    e->child = std::move(child);
    return e;
  };

  auto make_and = [](CondExprPtr a, CondExprPtr b) -> CondExprPtr {
    auto e = std::make_shared<CondExpr>();
    e->kind = CondExpr::Kind::And;
    e->children.push_back(std::move(a));
    e->children.push_back(std::move(b));
    return e;
  };

  auto make_or = [](CondExprPtr a, CondExprPtr b) -> CondExprPtr {
    auto e = std::make_shared<CondExpr>();
    e->kind = CondExpr::Kind::Or;
    e->children.push_back(std::move(a));
    e->children.push_back(std::move(b));
    return e;
  };

  // --- Helper predicates ---

  auto is_const_true = [](const CondExprPtr& expr) -> bool {
    return expr && expr->kind == CondExpr::Kind::Const && expr->const_val;
  };

  auto is_const_false = [](const CondExprPtr& expr) -> bool {
    return expr && expr->kind == CondExpr::Kind::Const && !expr->const_val;
  };

  // Structural equality of two CondExpr trees
  std::function<bool(const CondExprPtr&, const CondExprPtr&)> expr_equal;
  expr_equal = [&expr_equal](const CondExprPtr& a, const CondExprPtr& b) -> bool {
    if (!a && !b) return true;
    if (!a || !b) return false;
    if (a->kind != b->kind) return false;
    switch (a->kind) {
      case CondExpr::Kind::Const:
        return a->const_val == b->const_val;
      case CondExpr::Kind::Var:
        return a->var_name == b->var_name;
      case CondExpr::Kind::Not:
        return expr_equal(a->child, b->child);
      case CondExpr::Kind::And:
      case CondExpr::Kind::Or:
        if (a->children.size() != b->children.size()) return false;
        for (size_t i = 0; i < a->children.size(); ++i) {
          if (!expr_equal(a->children[i], b->children[i])) return false;
        }
        return true;
    }
    return false;
  };

  // Deep clone a CondExpr tree to avoid shared_ptr aliasing issues during simplification.
  // simplify() uses std::move which corrupts shared subtrees if multiple RCs reference the same nodes.
  std::function<CondExprPtr(const CondExprPtr&)> clone_expr;
  clone_expr = [&clone_expr, &make_const, &make_var](const CondExprPtr& expr) -> CondExprPtr {
    if (!expr) return nullptr;
    switch (expr->kind) {
      case CondExpr::Kind::Const:
        return make_const(expr->const_val);
      case CondExpr::Kind::Var:
        return make_var(expr->var_name);
      case CondExpr::Kind::Not: {
        auto e = std::make_shared<CondExpr>();
        e->kind = CondExpr::Kind::Not;
        e->child = clone_expr(expr->child);
        return e;
      }
      case CondExpr::Kind::And:
      case CondExpr::Kind::Or: {
        auto e = std::make_shared<CondExpr>();
        e->kind = expr->kind;
        e->children.reserve(expr->children.size());
        for (const auto& c : expr->children) {
          e->children.push_back(clone_expr(c));
        }
        return e;
      }
    }
    return nullptr;
  };

  // --- Emit a CondExpr as an HLSL boolean expression string ---

  std::function<std::string(const CondExprPtr&)> emit_expr;
  emit_expr = [&emit_expr](const CondExprPtr& expr) -> std::string {
    if (!expr) return "false";
    switch (expr->kind) {
      case CondExpr::Kind::Const:
        return expr->const_val ? "true" : "false";
      case CondExpr::Kind::Var:
        return expr->var_name;
      case CondExpr::Kind::Not: {
        std::string inner = emit_expr(expr->child);
        // If the child is a simple variable or const, no parens needed around it
        if (expr->child && (expr->child->kind == CondExpr::Kind::Var
            || expr->child->kind == CondExpr::Kind::Const)) {
          return std::format("!{}", inner);
        }
        return std::format("!({})", inner);
      }
      case CondExpr::Kind::And: {
        if (expr->children.empty()) return "true";
        if (expr->children.size() == 1) return emit_expr(expr->children[0]);
        std::string result;
        for (size_t i = 0; i < expr->children.size(); ++i) {
          if (i > 0) result += " && ";
          const auto& c = expr->children[i];
          if (!c) { result += "false"; continue; }
          // Wrap OR children in parens for precedence
          if (c->kind == CondExpr::Kind::Or) {
            result += std::format("({})", emit_expr(c));
          } else {
            result += emit_expr(c);
          }
        }
        return result;
      }
      case CondExpr::Kind::Or: {
        if (expr->children.empty()) return "false";
        if (expr->children.size() == 1) return emit_expr(expr->children[0]);
        std::string result;
        for (size_t i = 0; i < expr->children.size(); ++i) {
          if (i > 0) result += " || ";
          const auto& c = expr->children[i];
          if (!c) { result += "false"; continue; }
          // Wrap AND children in parens for precedence
          if (c->kind == CondExpr::Kind::And) {
            result += std::format("({})", emit_expr(c));
          } else {
            result += emit_expr(c);
          }
        }
        return result;
      }
    }
    return "false";
  };

  // --- Simplify a CondExpr tree using boolean algebra rules ---

  std::function<CondExprPtr(CondExprPtr, int)> simplify;
  simplify = [&](CondExprPtr expr, int depth) -> CondExprPtr {
    if (!expr) return make_const(false);

    // Depth guard: stop simplification if depth exceeds 100
    if (depth > 100) return expr;

    switch (expr->kind) {
      case CondExpr::Kind::Const:
      case CondExpr::Kind::Var:
        return expr;

      case CondExpr::Kind::Not: {
        // Recursively simplify the child first
        expr->child = simplify(expr->child, depth + 1);

        // Double negation elimination: NOT(NOT(x)) → x
        if (expr->child && expr->child->kind == CondExpr::Kind::Not) {
          return expr->child->child;
        }
        // NOT(true) → false, NOT(false) → true
        if (is_const_true(expr->child)) return make_const(false);
        if (is_const_false(expr->child)) return make_const(true);

        return expr;
      }

      case CondExpr::Kind::And: {
        // Recursively simplify all children
        for (auto& c : expr->children) {
          c = simplify(c, depth + 1);
        }

        // Flatten nested AND: AND(AND(a,b), c) → AND(a,b,c)
        {
          std::vector<CondExprPtr> flattened;
          for (auto& c : expr->children) {
            if (c && c->kind == CondExpr::Kind::And) {
              for (auto& gc : c->children) {
                flattened.push_back(std::move(gc));
              }
            } else {
              flattened.push_back(std::move(c));
            }
          }
          expr->children = std::move(flattened);
        }

        // Annihilation: if any child is false → false
        for (const auto& c : expr->children) {
          if (is_const_false(c)) return make_const(false);
        }

        // Identity: remove true children (x AND true → x)
        {
          std::vector<CondExprPtr> filtered;
          for (auto& c : expr->children) {
            if (!is_const_true(c)) {
              filtered.push_back(std::move(c));
            }
          }
          expr->children = std::move(filtered);
        }

        // If empty after filtering, it was all true → true
        if (expr->children.empty()) return make_const(true);
        // Single child → return it directly
        if (expr->children.size() == 1) return expr->children[0];

        // Idempotence: remove duplicate children (x AND x → x)
        {
          std::vector<CondExprPtr> deduped;
          for (auto& c : expr->children) {
            bool found = false;
            for (const auto& d : deduped) {
              if (expr_equal(c, d)) {
                found = true;
                break;
              }
            }
            if (!found) {
              deduped.push_back(std::move(c));
            }
          }
          expr->children = std::move(deduped);
        }
        if (expr->children.size() == 1) return expr->children[0];

        // Complementation: x AND NOT(x) → false
        for (size_t i = 0; i < expr->children.size(); ++i) {
          for (size_t j = i + 1; j < expr->children.size(); ++j) {
            const auto& ci = expr->children[i];
            const auto& cj = expr->children[j];
            // Check if ci == NOT(cj) or cj == NOT(ci)
            if (ci->kind == CondExpr::Kind::Not && expr_equal(ci->child, cj)) {
              return make_const(false);
            }
            if (cj->kind == CondExpr::Kind::Not && expr_equal(cj->child, ci)) {
              return make_const(false);
            }
          }
        }

        // Absorption: x AND (x OR y) → x
        // For each child ci, check if any other child cj is an OR containing ci
        {
          std::vector<bool> absorbed(expr->children.size(), false);
          for (size_t i = 0; i < expr->children.size(); ++i) {
            if (absorbed[i]) continue;
            for (size_t j = 0; j < expr->children.size(); ++j) {
              if (i == j || absorbed[j]) continue;
              // If children[j] is OR and contains children[i], absorb children[j]
              if (expr->children[j]->kind == CondExpr::Kind::Or) {
                for (const auto& oc : expr->children[j]->children) {
                  if (expr_equal(expr->children[i], oc)) {
                    absorbed[j] = true;
                    break;
                  }
                }
              }
            }
          }
          std::vector<CondExprPtr> result;
          for (size_t i = 0; i < expr->children.size(); ++i) {
            if (!absorbed[i]) {
              result.push_back(std::move(expr->children[i]));
            }
          }
          expr->children = std::move(result);
        }
        if (expr->children.empty()) return make_const(true);
        if (expr->children.size() == 1) return expr->children[0];

        return expr;
      }

      case CondExpr::Kind::Or: {
        // Recursively simplify all children
        for (auto& c : expr->children) {
          c = simplify(c, depth + 1);
        }

        // Flatten nested OR: OR(OR(a,b), c) → OR(a,b,c)
        {
          std::vector<CondExprPtr> flattened;
          for (auto& c : expr->children) {
            if (c && c->kind == CondExpr::Kind::Or) {
              for (auto& gc : c->children) {
                flattened.push_back(std::move(gc));
              }
            } else {
              flattened.push_back(std::move(c));
            }
          }
          expr->children = std::move(flattened);
        }

        // Annihilation: if any child is true → true
        for (const auto& c : expr->children) {
          if (is_const_true(c)) return make_const(true);
        }

        // Identity: remove false children (x OR false → x)
        {
          std::vector<CondExprPtr> filtered;
          for (auto& c : expr->children) {
            if (!is_const_false(c)) {
              filtered.push_back(std::move(c));
            }
          }
          expr->children = std::move(filtered);
        }

        // If empty after filtering, it was all false → false
        if (expr->children.empty()) return make_const(false);
        // Single child → return it directly
        if (expr->children.size() == 1) return expr->children[0];

        // Idempotence: remove duplicate children (x OR x → x)
        {
          std::vector<CondExprPtr> deduped;
          for (auto& c : expr->children) {
            bool found = false;
            for (const auto& d : deduped) {
              if (expr_equal(c, d)) {
                found = true;
                break;
              }
            }
            if (!found) {
              deduped.push_back(std::move(c));
            }
          }
          expr->children = std::move(deduped);
        }
        if (expr->children.size() == 1) return expr->children[0];

        // Complementation: x OR NOT(x) → true
        for (size_t i = 0; i < expr->children.size(); ++i) {
          for (size_t j = i + 1; j < expr->children.size(); ++j) {
            const auto& ci = expr->children[i];
            const auto& cj = expr->children[j];
            if (ci->kind == CondExpr::Kind::Not && expr_equal(ci->child, cj)) {
              return make_const(true);
            }
            if (cj->kind == CondExpr::Kind::Not && expr_equal(cj->child, ci)) {
              return make_const(true);
            }
          }
        }

        // Absorption: x OR (x AND y) → x
        // For each child ci, check if any other child cj is an AND containing ci
        {
          std::vector<bool> absorbed(expr->children.size(), false);
          for (size_t i = 0; i < expr->children.size(); ++i) {
            if (absorbed[i]) continue;
            for (size_t j = 0; j < expr->children.size(); ++j) {
              if (i == j || absorbed[j]) continue;
              // If children[j] is AND and contains children[i], absorb children[j]
              if (expr->children[j]->kind == CondExpr::Kind::And) {
                for (const auto& ac : expr->children[j]->children) {
                  if (expr_equal(expr->children[i], ac)) {
                    absorbed[j] = true;
                    break;
                  }
                }
              }
            }
          }
          std::vector<CondExprPtr> result;
          for (size_t i = 0; i < expr->children.size(); ++i) {
            if (!absorbed[i]) {
              result.push_back(std::move(expr->children[i]));
            }
          }
          expr->children = std::move(result);
        }
        if (expr->children.empty()) return make_const(false);
        if (expr->children.size() == 1) return expr->children[0];

        return expr;
      }
    }

    return expr;
  };

  // ============================================================
  // EmitRegion — CFG partitioning into acyclic regions and loops
  // ============================================================

  struct EmitRegion {
    enum class Kind { Acyclic, Loop };
    Kind kind;
    int entry;                             // entry block of this region
    std::set<int> blocks;                  // blocks belonging to this region
    int loop_header = -1;                  // for Loop regions: the loop header block
    std::set<int> back_edge_sources;       // for Loop regions: blocks with back-edges to header
    int loop_exit = -1;                    // for Loop regions: first block after the loop
    std::vector<EmitRegion> nested_loops;  // loops nested inside this region
  };

  // ============================================================
  // Loop Detection (kept from Phase 2)
  // ============================================================

  // Compute natural loops and loop bodies using existing infrastructure
  auto mermaid_natural_loops = current_code_function->ListNaturalLoops();
  auto mermaid_loop_bodies = current_code_function->ComputeLoopBodies(mermaid_natural_loops);

  // Build a lookup: block -> innermost loop header it belongs to
  std::map<int, int> block_to_loop_header;
  for (const auto& [header, body] : mermaid_loop_bodies) {
    for (int block : body) {
      // If block is already assigned to a loop, keep the innermost (smallest body)
      if (block_to_loop_header.contains(block)) {
        int existing_header = block_to_loop_header[block];
        if (mermaid_loop_bodies[existing_header].size() > body.size()) {
          block_to_loop_header[block] = header;
        }
      } else {
        block_to_loop_header[block] = header;
      }
    }
  }

  // ============================================================
  // Heap resource declaration tracking (SM6.6 bindless)
  // ============================================================
  //
  // Each SM6.6 heap resource (_HeapResource_N) is declared at the point where
  // its descriptor-heap index is first computed, e.g.
  //     ByteAddressBuffer _HeapResource_52 = ResourceDescriptorHeap[NonUniformResourceIndex(_404)];
  //
  // The index variable `_404` is an SSA local that is pre-declared at function
  // scope and assigned inside the block that also declares _HeapResource_52.
  //
  // When other blocks USE _HeapResource_52, HLSL lexical scoping routes the
  // identifier back to the function-scope pre-declaration (if present) where
  // `_404` is still zero-init'd, producing a handle to descriptor heap slot 0.
  // The fix: inject the canonical declaration at the top of every block that
  // uses a heap resource without declaring it locally. The SSA index variable
  // is guaranteed to hold the correct value by the block's reaching condition.
  static const std::regex mermaid_heap_decl_re(
      R"(^(ByteAddressBuffer|RWByteAddressBuffer|Texture\w+<[^>]+>|RaytracingAccelerationStructure)\s+(_HeapResource_\d+)\s*=\s*ResourceDescriptorHeap)");
  static const std::regex mermaid_heap_use_re(R"(_HeapResource_\d+)");

  std::map<std::string, std::string> heap_decl_by_var;
  std::map<int, std::set<std::string>> heap_decls_in_block;
  std::map<int, std::set<std::string>> heap_uses_in_block;

  for (const auto& [blk_id, cb] : current_code_function->code_blocks) {
    for (const auto& line : cb.hlsl_lines) {
      std::smatch m;
      if (std::regex_search(line, m, mermaid_heap_decl_re)) {
        std::string var_name = m[2].str();
        heap_decls_in_block[blk_id].insert(var_name);
        if (!heap_decl_by_var.contains(var_name)) {
          std::string decl = line;
          size_t first = decl.find_first_not_of(" \t");
          if (first != std::string::npos) decl = decl.substr(first);
          heap_decl_by_var[var_name] = decl;
        }
      }
      auto begin = std::sregex_iterator(line.begin(), line.end(), mermaid_heap_use_re);
      auto end = std::sregex_iterator();
      for (auto it = begin; it != end; ++it) {
        heap_uses_in_block[blk_id].insert(it->str());
      }
    }
  }

  // Phi assignments may also materialize heap-resource references at emission
  // time (via ParseByType inlining). Scan the expanded form to capture those.
  for (const auto& edge : graph_edges) {
    for (const auto& pa : edge.phi_assignments) {
      if (pa.value == "undef") continue;
      std::string parsed_value;
      try {
        parsed_value = current_code_function->ParseByType(pa.value, pa.type);
      } catch (...) {
        continue;
      }
      std::string optimized = OptimizeString(parsed_value);
      if (optimized.find("_HeapResource_") == std::string::npos) continue;
      auto begin = std::sregex_iterator(optimized.begin(), optimized.end(), mermaid_heap_use_re);
      auto end = std::sregex_iterator();
      for (auto it = begin; it != end; ++it) {
        heap_uses_in_block[edge.source].insert(it->str());
      }
    }
  }

  auto heap_decls_to_inject = [&](int block_id) -> std::vector<std::string> {
    std::vector<std::string> out;
    if (!heap_uses_in_block.contains(block_id)) return out;
    const auto& uses = heap_uses_in_block.at(block_id);
    const auto& decls = heap_decls_in_block.contains(block_id)
                        ? heap_decls_in_block.at(block_id)
                        : std::set<std::string>{};
    std::vector<std::string> to_inject;
    for (const auto& var : uses) {
      if (decls.contains(var)) continue;
      if (!heap_decl_by_var.contains(var)) continue;
      to_inject.push_back(var);
    }
    std::sort(to_inject.begin(), to_inject.end());
    for (const auto& var : to_inject) {
      out.push_back(heap_decl_by_var.at(var));
    }
    return out;
  };

  // Collect phi variables at a convergence/exit block from incoming edges
  auto collect_phi_vars = [&](int target_block) -> std::pair<std::vector<std::string>, std::vector<std::string>> {
    std::vector<std::string> phi_vars;
    std::vector<std::string> phi_types_vec;
    std::set<std::string> seen;
    for (const auto& edge : graph_edges) {
      if (edge.target == target_block) {
        for (const auto& pa : edge.phi_assignments) {
          if (!seen.contains(pa.variable)) {
            seen.insert(pa.variable);
            phi_vars.push_back(pa.variable);
            phi_types_vec.push_back(pa.type);
          }
        }
      }
    }
    return {phi_vars, phi_types_vec};
  };

  // Find the loop exit block for a given loop header.
  // The exit is the first successor of any loop body block that is NOT in the loop body.
  auto find_loop_exit = [&](int header, const std::set<int>& body) -> int {
    // Prefer the ipdom of the header if it's outside the loop
    if (graph_nodes.contains(header)) {
      int ipdom = graph_nodes[header].ipdom;
      if (ipdom >= 0 && !body.contains(ipdom)) {
        return ipdom;
      }
    }
    // Fallback: scan body blocks for successors outside the loop
    for (int block : body) {
      if (!graph_nodes.contains(block)) continue;
      for (int succ : graph_nodes[block].successors) {
        if (!body.contains(succ)) {
          return succ;
        }
      }
    }
    return -1;
  };

  // ============================================================
  // Reverse Post-Order Traversal (Task 4.1)
  // ============================================================

  // Compute reverse post-order of blocks in a region, ignoring back-edges.
  // This gives topological order for acyclic graphs.
  auto compute_rpo = [&graph_edges, &graph_nodes](
      int entry,
      const std::set<int>& block_set
  ) -> std::vector<int> {
    std::vector<int> post_order;
    std::set<int> visited;

    // Build a quick lookup: (source, target) -> edge type
    std::map<std::pair<int,int>, GraphEdgeType> edge_type_map;
    for (const auto& edge : graph_edges) {
      edge_type_map[{edge.source, edge.target}] = edge.type;
    }

    std::function<void(int)> dfs = [&](int block) {
      if (visited.contains(block) || !block_set.contains(block)) return;
      visited.insert(block);
      if (graph_nodes.contains(block)) {
        for (int succ : graph_nodes[block].successors) {
          if (!block_set.contains(succ)) continue;
          auto it = edge_type_map.find({block, succ});
          if (it != edge_type_map.end() && it->second == GraphEdgeType::BackEdge) continue;
          dfs(succ);
        }
      }
      post_order.push_back(block);
    };

    dfs(entry);
    std::reverse(post_order.begin(), post_order.end());
    return post_order;
  };

  // ============================================================
  // Reaching Condition Computation (Task 4.2)
  // ============================================================

  // Inter-region RC propagation map.
  // Records the reaching condition variable for each block that has outgoing
  // cross-region edges. When a subsequent region computes RCs and encounters
  // an external predecessor, it looks up the predecessor's actual RC here
  // instead of assuming RC=true.
  // Maps: block_id → RC variable name (e.g., "__rc_9436", "__cond_735", or "" for true)
  std::map<int, std::string> block_exit_rc;

  // Compute reaching conditions for all blocks in an acyclic region.
  // Entry block gets RC = true. Other blocks get RC computed from predecessor
  // contributions combined with OR (multiple preds) or directly (single pred).
  // Back-edges and blocks outside the region are skipped.
  // Each block's RC is simplified after computation.
  // cond_vars is populated with block_id → "__cond_N" variable name for branch conditions.
  // rc_vars_out is populated with block_id → "__rc_N" variable name for blocks with complex RCs.
  auto compute_reaching_conditions = [&](
      int entry,
      const std::set<int>& block_set,
      std::map<int, std::string>& cond_vars,
      std::map<int, std::string>& rc_vars_out,
      bool use_inter_region_rc = true  // false for loop body RC computation (header is always true)
  ) -> std::map<int, CondExprPtr> {
    std::map<int, CondExprPtr> rc;

    // Entry block RC: for loop bodies (use_inter_region_rc=false), always true.
    // For top-level regions, look up inter-region RC from external predecessors.
    if (use_inter_region_rc) {
      std::vector<CondExprPtr> entry_contributions;
      for (const auto& edge : graph_edges) {
        if (edge.target != entry) continue;
        if (edge.type == GraphEdgeType::BackEdge) continue;
        if (block_set.contains(edge.source)) continue;
        // External predecessor of the entry block
        if (block_exit_rc.contains(edge.source)) {
          const std::string& pred_rc_var = block_exit_rc[edge.source];
          CondExprPtr contrib;
          if (pred_rc_var.empty()) {
            contrib = make_const(true);
          } else {
            contrib = make_var(pred_rc_var);
          }
          // Apply edge condition
          if (edge.type == GraphEdgeType::TrueBranch) {
            std::string cond_name = std::format("__cond_{}", edge.source);
            contrib = make_and(contrib, make_var(cond_name));
          } else if (edge.type == GraphEdgeType::FalseBranch) {
            std::string cond_name = std::format("__cond_{}", edge.source);
            contrib = make_and(contrib, make_not(make_var(cond_name)));
          }
          entry_contributions.push_back(contrib);
        }
      }
      if (!entry_contributions.empty()) {
        if (entry_contributions.size() == 1) {
          rc[entry] = entry_contributions[0];
        } else {
          CondExprPtr combined = entry_contributions[0];
          for (size_t i = 1; i < entry_contributions.size(); ++i) {
            combined = make_or(combined, entry_contributions[i]);
          }
          rc[entry] = combined;
        }
        rc[entry] = simplify(clone_expr(rc[entry]), 0);
      } else {
        rc[entry] = make_const(true);
      }
    } else {
      rc[entry] = make_const(true);
    }

    // Build edge lookup: target → list of incoming edges (within block_set, non-back-edge)
    std::map<int, std::vector<const GraphEdge*>> incoming_edges;
    for (const auto& edge : graph_edges) {
      if (edge.type == GraphEdgeType::BackEdge) continue;
      if (!block_set.contains(edge.source)) continue;
      if (!block_set.contains(edge.target)) continue;
      incoming_edges[edge.target].push_back(&edge);
    }

    // Detect blocks in the region that have predecessors OUTSIDE the region.
    // Instead of assuming RC=true, we look up the external predecessor's actual
    // RC from block_exit_rc (inter-region propagation).
    std::set<int> has_external_predecessor;
    // Maps: target_block → list of external predecessor edges (for RC lookup)
    std::map<int, std::vector<const GraphEdge*>> external_pred_edges;
    for (const auto& edge : graph_edges) {
      if (edge.type == GraphEdgeType::BackEdge) continue;
      if (!block_set.contains(edge.target)) continue;
      if (block_set.contains(edge.source)) continue;  // internal edge, already handled
      if (edge.target == entry) continue;  // entry block already handled above
      has_external_predecessor.insert(edge.target);
      external_pred_edges[edge.target].push_back(&edge);
    }

    // rc_vars maps block_id → "__rc_N" variable name for blocks that have
    // non-trivial reaching conditions. When building a successor's RC, we
    // reference the variable name instead of inlining the full expression tree.
    // This keeps expression trees O(1) depth per block instead of O(N) for cascades.
    std::map<int, std::string> rc_vars;

    // Helper: get the "reference" form of a block's RC for use in successor expressions.
    // If the block has a simple RC (const true, single var), return it directly.
    // Otherwise, return a Var node referencing the block's __rc_N variable.
    auto get_rc_ref = [&](int block_id) -> CondExprPtr {
      if (!rc.contains(block_id)) return make_const(false);
      const auto& expr = rc[block_id];
      // Const true/false — return a fresh copy (safe to share)
      if (is_const_true(expr)) return make_const(true);
      if (is_const_false(expr)) return make_const(false);
      // Single variable — return a fresh Var copy (prevents simplify from corrupting rc map)
      if (expr->kind == CondExpr::Kind::Var) return make_var(expr->var_name);
      // Complex expression — reference via __rc_N variable
      if (!rc_vars.contains(block_id)) {
        rc_vars[block_id] = std::format("__rc_{}", block_id);
      }
      return make_var(rc_vars[block_id]);
    };

    // Compute reverse post-order for the region
    auto rpo = compute_rpo(entry, block_set);

    // Process blocks in RPO order
    for (int block_id : rpo) {
      if (block_id == entry) continue;  // Already set to true

      // Collect contributions from each predecessor edge
      std::vector<CondExprPtr> contributions;

      if (incoming_edges.contains(block_id)) {
        for (const auto* edge_ptr : incoming_edges.at(block_id)) {
          const auto& edge = *edge_ptr;

          // Skip predecessors whose RC hasn't been computed yet
          // (shouldn't happen in RPO, but defensive)
          if (!rc.contains(edge.source)) continue;

          // Use the variable reference form of the predecessor's RC.
          CondExprPtr pred_rc = get_rc_ref(edge.source);

        switch (edge.type) {
          case GraphEdgeType::TrueBranch: {
            // Get or create condition variable for the predecessor's branch
            if (!cond_vars.contains(edge.source)) {
              // Use the branch condition expression from the code block to name the variable
              cond_vars[edge.source] = std::format("__cond_{}", edge.source);
            }
            std::string cond_name = cond_vars[edge.source];
            contributions.push_back(make_and(pred_rc, make_var(cond_name)));
            break;
          }
          case GraphEdgeType::FalseBranch: {
            // Get or create condition variable for the predecessor's branch
            if (!cond_vars.contains(edge.source)) {
              cond_vars[edge.source] = std::format("__cond_{}", edge.source);
            }
            std::string cond_name = cond_vars[edge.source];
            contributions.push_back(make_and(pred_rc, make_not(make_var(cond_name))));
            break;
          }
          case GraphEdgeType::Unconditional: {
            contributions.push_back(pred_rc);
            break;
          }
          case GraphEdgeType::SwitchCase: {
            // Build case equality condition from the switch block's condition
            // and the specific case value targeting this block
            if (current_code_function->code_blocks.contains(edge.source)) {
              const auto& src_block = current_code_function->code_blocks.at(edge.source);
              const std::string& switch_cond = src_block.code_switch.switch_condition;

              // Check if this is the default case
              if (src_block.code_switch.case_default == edge.target) {
                // Default case: negate all explicit case conditions
                // For simplicity, use a synthetic variable representing the default path
                std::string default_cond = std::format("__switch_{}_default", edge.source);
                contributions.push_back(make_and(pred_rc, make_var(default_cond)));
              } else {
                // Find the case value(s) that target this block
                for (const auto& [case_val, case_func] : src_block.code_switch.case_values) {
                  if (case_func == edge.target) {
                    std::string case_equality = std::format("({} == {})",
                        switch_cond, std::string(case_val));
                    contributions.push_back(make_and(pred_rc, make_var(case_equality)));
                  }
                }
              }
            }
            break;
          }
          case GraphEdgeType::BackEdge:
            // Already handled above, but satisfy the switch
            break;
        }
      }
      }  // end if (incoming_edges.contains(block_id))

      // Add contribution from external predecessors.
      // Instead of assuming RC=true, look up the actual RC of each external
      // predecessor from block_exit_rc (inter-region propagation).
      if (has_external_predecessor.contains(block_id)) {
        if (external_pred_edges.contains(block_id)) {
          for (const auto* edge_ptr : external_pred_edges.at(block_id)) {
            const auto& edge = *edge_ptr;
            CondExprPtr contrib;
            if (block_exit_rc.contains(edge.source)) {
              const std::string& pred_rc_var = block_exit_rc[edge.source];
              if (pred_rc_var.empty()) {
                contrib = make_const(true);
              } else {
                contrib = make_var(pred_rc_var);
              }
            } else {
              // External predecessor's RC not yet recorded — conservative fallback
              contrib = make_const(true);
            }
            // Apply edge condition for conditional edges — use variable name
            // directly without adding to cond_vars (block is external)
            if (edge.type == GraphEdgeType::TrueBranch) {
              std::string cond_name = std::format("__cond_{}", edge.source);
              contrib = make_and(contrib, make_var(cond_name));
            } else if (edge.type == GraphEdgeType::FalseBranch) {
              std::string cond_name = std::format("__cond_{}", edge.source);
              contrib = make_and(contrib, make_not(make_var(cond_name)));
            }
            contributions.push_back(contrib);
          }
        } else {
          // No edge info available — conservative fallback
          contributions.push_back(make_const(true));
        }
      }

      // Combine contributions
      if (contributions.empty()) {
        // No predecessors within the region (unreachable block)
        rc[block_id] = make_const(false);
      } else if (contributions.size() == 1) {
        // Single predecessor contribution — use directly
        rc[block_id] = contributions[0];
      } else {
        // Multiple predecessors — OR chain
        CondExprPtr combined = contributions[0];
        for (size_t i = 1; i < contributions.size(); ++i) {
          combined = make_or(combined, contributions[i]);
        }
        rc[block_id] = combined;
      }

      // Simplify the reaching condition.
      // Clone first to avoid corrupting shared subtrees — multiple blocks' RCs
      // may reference the same CondExpr nodes via shared_ptr, and simplify()
      // uses std::move which would leave dangling nulls in other blocks' trees.
      rc[block_id] = simplify(clone_expr(rc[block_id]), 0);
    }

    // Handle blocks in block_set that weren't visited by RPO (unreachable from
    // the region entry). These are blocks reached from external predecessors
    // (e.g., loop exit targets). First, find the entry points of these disconnected
    // sub-graphs (blocks with external predecessors), then compute their RPO and
    // RCs using the same algorithm as the main pass.
    {
      std::set<int> unvisited;
      for (int block_id : block_set) {
        if (!rc.contains(block_id)) {
          unvisited.insert(block_id);
        }
      }

      if (!unvisited.empty()) {
        // Find entry points: blocks with external predecessors
        std::vector<int> sub_entries;
        for (int block_id : unvisited) {
          if (has_external_predecessor.contains(block_id)) {
            sub_entries.push_back(block_id);
          }
        }

        // For each sub-entry, set RC based on external predecessor's actual RC
        for (int sub_entry : sub_entries) {
          if (rc.contains(sub_entry)) continue;  // already processed
          // Look up external predecessors' RCs
          if (external_pred_edges.contains(sub_entry)) {
            std::vector<CondExprPtr> entry_contribs;
            for (const auto* edge_ptr : external_pred_edges.at(sub_entry)) {
              const auto& edge = *edge_ptr;
              CondExprPtr contrib;
              if (block_exit_rc.contains(edge.source)) {
                const std::string& pred_rc_var = block_exit_rc[edge.source];
                if (pred_rc_var.empty()) {
                  contrib = make_const(true);
                } else {
                  contrib = make_var(pred_rc_var);
                }
              } else {
                contrib = make_const(true);
              }
              // Apply edge condition — use variable name directly (block is external)
              if (edge.type == GraphEdgeType::TrueBranch) {
                std::string cond_name = std::format("__cond_{}", edge.source);
                contrib = make_and(contrib, make_var(cond_name));
              } else if (edge.type == GraphEdgeType::FalseBranch) {
                std::string cond_name = std::format("__cond_{}", edge.source);
                contrib = make_and(contrib, make_not(make_var(cond_name)));
              }
              entry_contribs.push_back(contrib);
            }
            if (entry_contribs.size() == 1) {
              rc[sub_entry] = entry_contribs[0];
            } else if (entry_contribs.size() > 1) {
              CondExprPtr combined = entry_contribs[0];
              for (size_t i = 1; i < entry_contribs.size(); ++i) {
                combined = make_or(combined, entry_contribs[i]);
              }
              rc[sub_entry] = combined;
            } else {
              rc[sub_entry] = make_const(true);
            }
            rc[sub_entry] = simplify(clone_expr(rc[sub_entry]), 0);
          } else {
            rc[sub_entry] = make_const(true);
          }

          // Compute RPO from this sub-entry within unvisited blocks
          auto sub_rpo = compute_rpo(sub_entry, unvisited);

          // Process sub-RPO blocks using the same RC computation logic
          for (int block_id : sub_rpo) {
            if (block_id == sub_entry) continue;
            if (rc.contains(block_id)) continue;

            std::vector<CondExprPtr> contributions;
            if (incoming_edges.contains(block_id)) {
              for (const auto* edge_ptr : incoming_edges.at(block_id)) {
                const auto& edge = *edge_ptr;
                if (!rc.contains(edge.source)) continue;
                CondExprPtr pred_rc = get_rc_ref(edge.source);

                switch (edge.type) {
                  case GraphEdgeType::TrueBranch: {
                    if (!cond_vars.contains(edge.source))
                      cond_vars[edge.source] = std::format("__cond_{}", edge.source);
                    contributions.push_back(make_and(pred_rc, make_var(cond_vars[edge.source])));
                    break;
                  }
                  case GraphEdgeType::FalseBranch: {
                    if (!cond_vars.contains(edge.source))
                      cond_vars[edge.source] = std::format("__cond_{}", edge.source);
                    contributions.push_back(make_and(pred_rc, make_not(make_var(cond_vars[edge.source]))));
                    break;
                  }
                  case GraphEdgeType::Unconditional: {
                    contributions.push_back(pred_rc);
                    break;
                  }
                  default: break;
                }
              }
            }

            if (has_external_predecessor.contains(block_id)) {
              if (external_pred_edges.contains(block_id)) {
                for (const auto* ext_edge_ptr : external_pred_edges.at(block_id)) {
                  const auto& ext_edge = *ext_edge_ptr;
                  CondExprPtr contrib;
                  if (block_exit_rc.contains(ext_edge.source)) {
                    const std::string& pred_rc_var = block_exit_rc[ext_edge.source];
                    if (pred_rc_var.empty()) {
                      contrib = make_const(true);
                    } else {
                      contrib = make_var(pred_rc_var);
                    }
                  } else {
                    contrib = make_const(true);
                  }
                  // Apply edge condition — use variable name directly (block is external)
                  if (ext_edge.type == GraphEdgeType::TrueBranch) {
                    std::string cond_name = std::format("__cond_{}", ext_edge.source);
                    contrib = make_and(contrib, make_var(cond_name));
                  } else if (ext_edge.type == GraphEdgeType::FalseBranch) {
                    std::string cond_name = std::format("__cond_{}", ext_edge.source);
                    contrib = make_and(contrib, make_not(make_var(cond_name)));
                  }
                  contributions.push_back(contrib);
                }
              } else {
                contributions.push_back(make_const(true));
              }
            }

            if (contributions.empty()) {
              rc[block_id] = make_const(false);
            } else if (contributions.size() == 1) {
              rc[block_id] = contributions[0];
            } else {
              CondExprPtr combined = contributions[0];
              for (size_t i = 1; i < contributions.size(); ++i) {
                combined = make_or(combined, contributions[i]);
              }
              rc[block_id] = combined;
            }
            rc[block_id] = simplify(clone_expr(rc[block_id]), 0);
          }
        }

        // Any remaining unvisited blocks get RC=false
        for (int block_id : unvisited) {
          if (!rc.contains(block_id)) {
            rc[block_id] = make_const(false);
          }
        }
      }
    }

    // Export rc_vars so the emitter knows which blocks need __rc_N declarations.
    // Also ensure ALL blocks with complex RCs get an __rc_N variable, not just
    // those referenced by successors via get_rc_ref. This is needed because
    // post-region code (e.g., after a loop) may reference __rc_N for blocks
    // that have no successors within the region (like loop latches).
    for (const auto& [block_id, expr] : rc) {
      if (is_const_true(expr) || is_const_false(expr)) continue;
      if (expr->kind == CondExpr::Kind::Var) continue;
      if (!rc_vars.contains(block_id)) {
        rc_vars[block_id] = std::format("__rc_{}", block_id);
      }
    }
    rc_vars_out = rc_vars;

    return rc;
  };

  // ============================================================
  // Irreducible Control Flow Detection (Task 4.3)
  // ============================================================

  // Detect irreducible control flow in an acyclic region.
  // After removing back-edges, if any block in block_set is not visited
  // by RPO from the entry, the region has irreducible control flow
  // (a cycle exists in the acyclic portion).
  auto has_irreducible_flow = [&compute_rpo](
      int entry,
      const std::set<int>& block_set
  ) -> bool {
    auto rpo = compute_rpo(entry, block_set);
    return rpo.size() < block_set.size();
  };

  // ============================================================
  // Phi Variable Pre-Declaration (Task 7.1)
  // ============================================================

  // Scan edges within a region for phi assignments, collect unique phi variable
  // names and their LLVM IR types, and emit zero-initialized declarations at
  // function scope before any guarded blocks.
  // This ensures phi variables are in scope for all guarded assignments.
  auto emit_phi_predeclarations = [&](const std::set<int>& block_set) {
    // Collect unique phi variable names and their LLVM IR types.
    // Use an ordered map for deterministic output ordering.
    std::map<std::string, std::string> phi_var_types;  // variable_name -> LLVM IR type

    for (const auto& edge : graph_edges) {
      // Only consider edges where both source and target are in the region
      if (!block_set.contains(edge.source) || !block_set.contains(edge.target)) continue;

      for (const auto& pa : edge.phi_assignments) {
        // Skip if we've already seen this variable
        if (phi_var_types.contains(pa.variable)) continue;
        phi_var_types[pa.variable] = pa.type;
      }
    }

    // Also scan edges from outside the region targeting blocks inside the region
    // (e.g., pre-header → loop header edges carry phi assignments too)
    for (const auto& edge : graph_edges) {
      if (!block_set.contains(edge.target)) continue;
      for (const auto& pa : edge.phi_assignments) {
        if (phi_var_types.contains(pa.variable)) continue;
        phi_var_types[pa.variable] = pa.type;
      }
    }

    if (phi_var_types.empty()) return;

    // Emit a declaration for each unique phi variable with a zero-initialized default.
    // Convert LLVM IR type to HLSL type and pick the appropriate zero literal.
    for (const auto& [var_name, llvm_type] : phi_var_types) {
      // Convert LLVM IR type to HLSL type
      std::string hlsl_type;
      try {
        hlsl_type = ParseType(llvm_type);
      } catch (...) {
        // Fallback: if type cannot be parsed, default to float (most common SSA type)
        hlsl_type = "float";
      }

      // Determine zero-initialized default based on HLSL type
      std::string default_val;
      if (hlsl_type == "bool") {
        default_val = "false";
      } else if (hlsl_type == "int" || hlsl_type == "int16_t" || hlsl_type == "int64_t") {
        default_val = "0";
      } else if (hlsl_type == "uint" || hlsl_type == "uint16_t" || hlsl_type == "uint64_t") {
        default_val = "0u";
      } else if (hlsl_type == "float") {
        default_val = "0.0f";
      } else if (hlsl_type == "half" || hlsl_type == "min16float") {
        default_val = "0.0h";
      } else if (hlsl_type == "double") {
        default_val = "0.0";
      } else {
        // For any other type (structs, vectors, etc.), use HLSL's (Type)0 cast
        default_val = std::format("({})0", hlsl_type);
      }

      string_stream << spacing << hlsl_type << " " << var_name << " = " << default_val << ";\n";
    }
  };

  // ============================================================
  // Zero-Init Phi Skip — skip phi assignments matching pre-declared default
  // ============================================================

  // Check if a parsed phi value is a zero-init literal that matches the
  // pre-declared default for the given LLVM IR type. If so, the assignment
  // is redundant and can be skipped.
  // IMPORTANT: Only skip literal constants, NOT variable references.
  // Variable references like "_42" could carry non-zero values at runtime.
  auto is_redundant_zero_phi = [&](const std::string& optimized_value, const std::string& llvm_type) -> bool {
    // Only skip in non-loop contexts to be safe (loop-carried variables need assignments)
    // Actually, we check the value itself — if it's a literal zero, it's safe anywhere.
    std::string hlsl_type;
    try {
      hlsl_type = ParseType(llvm_type);
    } catch (...) {
      return false;
    }

    // Check if the optimized value matches the zero-init default for this type
    if (hlsl_type == "bool" && (optimized_value == "false" || optimized_value == "bool(false)")) return true;
    if ((hlsl_type == "int" || hlsl_type == "int16_t" || hlsl_type == "int64_t") && optimized_value == "0") return true;
    if ((hlsl_type == "uint" || hlsl_type == "uint16_t" || hlsl_type == "uint64_t") && optimized_value == "0u") return true;
    if (hlsl_type == "float" && (optimized_value == "0.0f" || optimized_value == "0.000000f" || optimized_value == "0.0" || optimized_value == "0")) return true;
    if ((hlsl_type == "half" || hlsl_type == "min16float") && (optimized_value == "0.0h" || optimized_value == "0.0" || optimized_value == "0")) return true;
    if (hlsl_type == "double" && (optimized_value == "0.0" || optimized_value == "0")) return true;

    // Vector/struct zero: (Type)0
    if (optimized_value == std::format("({})0", hlsl_type)) return true;

    return false;
  };

  // Helper: emit a single phi assignment, skipping if it matches the zero-init default.
  // Returns true if the assignment was emitted, false if skipped.
  auto emit_phi_assignment = [&](const PhiAssignment& pa) -> bool {
    if (pa.value == "undef") return false;

    std::string parsed_value;
    try {
      parsed_value = current_code_function->ParseByType(pa.value, pa.type);
    } catch (...) {
      if (pa.value.starts_with("%")) {
        parsed_value = std::format("_{}", pa.value.substr(1));
      } else if (pa.value.starts_with("_")) {
        parsed_value = pa.value;
      } else {
        parsed_value = pa.value;
      }
    }

    std::string optimized = OptimizeString(parsed_value);

    // Skip if the value matches the zero-init default
    if (is_redundant_zero_phi(optimized, pa.type)) return false;

    string_stream << spacing << pa.variable << " = " << optimized << ";\n";
    return true;
  };

  // ============================================================
  // Condition Variable Emission (Task 7.2)
  // ============================================================

  // Track which __cond_N, __rc_N, and __switch_N_default variables have been declared
  // to avoid redefinition errors when the same block appears in multiple regions
  // (e.g., acyclic region before a loop AND inside the loop body).
  std::set<std::string> emitted_bool_vars;

  // Track which of those variables have received their real assignment (not
  // just the zero-init pre-declaration). Used by the convergence bypass phi
  // emission to suppress override writes that would reference a guard variable
  // before it's meaningfully set (the zero-init default would wrongly trigger
  // the bypass path on every edge reaching the convergence block).
  std::set<std::string> assigned_bool_vars;

  // Emit `bool __cond_N = (branch_condition);` for a branch block.
  // The branch condition is already decompiled to HLSL by the instruction-level
  // decompiler (stored in code_branch.branch_condition as e.g. "_42" or "(_x == _y)").
  // cond_vars maps block_id → "__cond_N" variable name (populated by compute_reaching_conditions).
  auto emit_cond_var = [&](int block_id, const std::map<int, std::string>& cond_vars, bool pre_declared = false) {
    // Only emit if this block has a condition variable assigned
    if (!cond_vars.contains(block_id)) return;

    // Only emit for blocks that actually have a branch condition
    if (!current_code_function->code_blocks.contains(block_id)) return;
    const auto& code_block = current_code_function->code_blocks.at(block_id);
    if (code_block.code_branch.branch_condition.empty()) return;

    const std::string& var_name = cond_vars.at(block_id);
    const std::string& branch_cond = code_block.code_branch.branch_condition;

    // Check if this variable was already declared (by a previous region or pre-declaration)
    bool already_declared = pre_declared || emitted_bool_vars.contains(var_name);

    if (already_declared) {
      string_stream << spacing << var_name << " = " << ParseWrapped(branch_cond) << ";";
    } else {
      string_stream << spacing << "bool " << var_name << " = " << ParseWrapped(branch_cond) << ";";
      emitted_bool_vars.insert(var_name);
    }
    assigned_bool_vars.insert(var_name);
    // Annotate with branch targets when --annotate is enabled
    if (decompile_options.annotate) {
      int true_target = code_block.code_branch.branch_condition_true;
      int false_target = code_block.code_branch.branch_condition_false;
      if (true_target > 0 && false_target > 0) {
        string_stream << "  // true->" << true_target << ", false->" << false_target;
      }
    }
    string_stream << "\n";
  };

  // Emit `bool __switch_N_default = !(cond == val1 || cond == val2 || ...);` for switch blocks.
  // This is needed when the reaching condition computation uses __switch_N_default as a
  // synthetic variable for the default case path.
  std::set<int> emitted_switch_defaults;  // track which switch defaults we've already emitted
  auto emit_switch_default_var = [&](int block_id) {
    if (!current_code_function->code_blocks.contains(block_id)) return;
    const auto& code_block = current_code_function->code_blocks.at(block_id);
    if (code_block.code_switch.switch_condition.empty()) return;
    if (code_block.code_switch.case_default < 0) return;

    std::string var_name = std::format("__switch_{}_default", block_id);
    if (emitted_switch_defaults.contains(block_id)) return;
    emitted_switch_defaults.insert(block_id);

    const std::string& switch_cond = code_block.code_switch.switch_condition;

    // Build the negation of all explicit case conditions
    std::string case_or;
    for (const auto& [case_val, case_func] : code_block.code_switch.case_values) {
      if (!case_or.empty()) case_or += " || ";
      case_or += std::format("({} == {})", switch_cond, std::string(case_val));
    }

    // Check if already declared (by a previous region)
    if (emitted_bool_vars.contains(var_name)) {
      if (case_or.empty()) {
        string_stream << spacing << var_name << " = true;\n";
      } else {
        string_stream << spacing << var_name << " = !(" << case_or << ");\n";
      }
    } else {
      if (case_or.empty()) {
        string_stream << spacing << "bool " << var_name << " = true;\n";
      } else {
        string_stream << spacing << "bool " << var_name << " = !(" << case_or << ");\n";
      }
      emitted_bool_vars.insert(var_name);
    }
  };

  // Emit `bool __rc_N = (rc_expression);` for blocks with complex reaching conditions.
  // Only emits if the block has an entry in rc_vars (meaning its RC is complex enough
  // to need a named variable — not a single variable or constant).
  // Uses emit_expr() to convert the CondExpr tree to an HLSL string.
  auto emit_rc_var = [&](int block_id, const std::map<int, CondExprPtr>& rc, const std::map<int, std::string>& rc_vars) {
    // Only emit if this block needs an __rc_N variable
    if (!rc_vars.contains(block_id)) return;

    // Must have a reaching condition computed
    if (!rc.contains(block_id)) return;

    const std::string& var_name = rc_vars.at(block_id);
    const CondExprPtr& expr = rc.at(block_id);

    // Skip emission for constant true (should not happen if rc_vars is populated correctly,
    // but defensive)
    if (is_const_true(expr)) return;

    // Emit: bool __rc_N = (rc_expression); or assignment if already declared
    std::string rc_str = emit_expr(expr);
    if (emitted_bool_vars.contains(var_name)) {
      string_stream << spacing << var_name << " = " << rc_str << ";\n";
    } else {
      string_stream << spacing << "bool " << var_name << " = " << rc_str << ";\n";
      emitted_bool_vars.insert(var_name);
    }
    assigned_bool_vars.insert(var_name);
  };

  // ============================================================
  // Flat Guarded Emission for Acyclic Regions (Task 7.3)
  // ============================================================

  // Emit an acyclic region as flat guarded blocks.
  // For each block in topological order:
  //   1. If RC is const true: emit block code directly (no guard)
  //   2. If RC is const false: skip block entirely
  //   3. Otherwise: emit "if (guard) { block code + phi assignments }"
  // Phi assignments are emitted inside the PREDECESSOR's guarded block,
  // not at the convergence point. This is the key to preventing DXC from
  // merging paths — each predecessor's phi assignment is protected by that
  // predecessor's unique reaching condition.
  // Helper: expand __cond_N and __rc_N references in a guard expression to the actual
  // branch conditions for developer-friendly annotations.
  // Returns the expanded string, truncated to max_len characters.
  auto expand_guard = [&](const std::string& guard, const std::map<int, std::string>& cvars,
                          const std::map<int, CondExprPtr>& rc_map, const std::map<int, std::string>& rv_map,
                          int max_len = 100) -> std::string {
    if (!decompile_options.annotate) return guard;
    std::string result = guard;

    // First expand __rc_N to their CondExpr form (which contains __cond_N references)
    for (const auto& [bid, vname] : rv_map) {
      if (result.find(vname) == std::string::npos) continue;
      if (!rc_map.contains(bid)) continue;
      std::string rc_str = emit_expr(rc_map.at(bid));
      if (rc_str.size() > 60) rc_str = rc_str.substr(0, 57) + "...";
      size_t pos;
      while ((pos = result.find(vname)) != std::string::npos) {
        result.replace(pos, vname.size(), rc_str);
      }
    }

    // Then expand __cond_N to the actual branch condition expressions
    for (const auto& [bid, vname] : cvars) {
      if (result.find(vname) == std::string::npos) continue;
      if (!current_code_function->code_blocks.contains(bid)) continue;
      const auto& cb = current_code_function->code_blocks.at(bid);
      if (cb.code_branch.branch_condition.empty()) continue;
      std::string cond = ParseWrapped(cb.code_branch.branch_condition);
      if (cond.size() > 40) cond = cond.substr(0, 37) + "...";
      size_t pos;
      while ((pos = result.find(vname)) != std::string::npos) {
        result.replace(pos, vname.size(), cond);
      }
    }
    if ((int)result.size() > max_len) result = result.substr(0, max_len - 3) + "...";
    return result;
  };

  // Convergence bypass phi info — populated during preprocessing, used during emission.
  // Maps: target_block_id → (variable_name → {guard_var, skip_value, bypass_source})
  //
  // bypass_source identifies which source block's edge is the actual bypass
  // edge. The override `if (!guard_var) { var = skip_value; }` must only be
  // emitted on that edge, not on every edge reaching the convergence block —
  // otherwise unrelated edges (e.g., intermediate paths that also assign the
  // phi variable) would erroneously zero out their values when the bypass
  // guard was not yet assigned in topological order (its assignment lives
  // AFTER the offending edge's emission).
  struct BypassPhiInfo {
    std::string guard_var;
    std::string skip_value;
    int bypass_source = -1;
  };
  std::map<int, std::map<std::string, BypassPhiInfo>> convergence_bypass_phis;

  auto emit_acyclic_region = [&](const EmitRegion& region) {
    // Step 1: Compute reaching conditions for all blocks in this region
    std::map<int, std::string> cond_vars;
    std::map<int, std::string> rc_vars;
    auto rc = compute_reaching_conditions(region.entry, region.blocks, cond_vars, rc_vars);

    // Step 2: Compute topological order (RPO)
    auto rpo = compute_rpo(region.entry, region.blocks);

    // Step 3: Phi variables are already pre-declared at function scope by the
    // existing infrastructure in shader_decompiler_dxc.hpp (which scans all
    // code_blocks and phi_lines). No need to emit them again here.

    // Step 4: Build edge lookup for phi assignments: source block → list of edges
    // We need this to emit phi assignments inside the predecessor's guarded block.
    // Include both intra-region edges AND cross-region edges (edges from blocks in
    // this region to blocks outside it) since cross-region edges may carry phi
    // assignments that need to be emitted inside the source block's guard.
    std::map<int, std::vector<const GraphEdge*>> outgoing_edges;
    for (const auto& edge : graph_edges) {
      if (!region.blocks.contains(edge.source)) continue;
      if (edge.type == GraphEdgeType::BackEdge) continue;
      outgoing_edges[edge.source].push_back(&edge);
    }

    // Ensure cond_vars has entries for blocks with cross-region conditional edges
    // that carry phi assignments. Without this, the edge guard logic can't apply
    // branch condition guards to cross-region phi emissions.
    for (const auto& edge : graph_edges) {
      if (!region.blocks.contains(edge.source)) continue;
      if (region.blocks.contains(edge.target)) continue;
      if (edge.type == GraphEdgeType::BackEdge) continue;
      if (edge.phi_assignments.empty()) continue;
      if (edge.type == GraphEdgeType::TrueBranch || edge.type == GraphEdgeType::FalseBranch) {
        if (!cond_vars.contains(edge.source)) {
          cond_vars[edge.source] = std::format("__cond_{}", edge.source);
        }
      }
    }

    // Step 4.5: Pre-declare all __cond_N and __rc_N variables at the outer scope.
    // These must be visible to all blocks in the region since successor blocks'
    // __rc_N expressions reference predecessor blocks' __cond_N variables.
    // The actual values are assigned inside each block's guard after the hlsl_lines.
    for (const auto& [bid, vname] : cond_vars) {
      if (!emitted_bool_vars.contains(vname)) {
        string_stream << spacing << "bool " << vname << " = false;\n";
        emitted_bool_vars.insert(vname);
      }
    }
    for (const auto& [bid, vname] : rc_vars) {
      if (!emitted_bool_vars.contains(vname)) {
        string_stream << spacing << "bool " << vname << " = false;\n";
        emitted_bool_vars.insert(vname);
      }
    }

    // Also pre-declare __switch_N_default variables for any switch blocks in this region.
    // These are referenced in RC expressions for blocks reachable from the default case.
    for (int bid : region.blocks) {
      if (!current_code_function->code_blocks.contains(bid)) continue;
      const auto& cb = current_code_function->code_blocks.at(bid);
      if (cb.code_switch.switch_condition.empty()) continue;
      if (cb.code_switch.case_default < 0) continue;
      std::string sw_var = std::format("__switch_{}_default", bid);
      if (!emitted_bool_vars.contains(sw_var)) {
        string_stream << spacing << "bool " << sw_var << " = false;\n";
        emitted_bool_vars.insert(sw_var);
      }
    }

    // Step 5: Walk blocks in RPO order and emit guarded code.
    // Also build a set of visited blocks to detect unreachable blocks later.
    std::set<int> rpo_set(rpo.begin(), rpo.end());

    // Append any blocks in the region that aren't in the RPO (unreachable from
    // the region entry but reachable from external predecessors like loop exits).
    // These blocks need to be emitted too — they have RC=true from the external
    // predecessor fix and contain code/branches that affect downstream blocks.
    std::vector<int> full_walk = rpo;
    for (int bid : region.blocks) {
      if (!rpo_set.contains(bid)) {
        full_walk.push_back(bid);
      }
    }

    // Build position map for topological ordering violation detection.
    // If a phi source block appears AFTER its target in full_walk, the phi
    // assignment would arrive too late. We need to emit those early.
    std::map<int, size_t> block_position;
    for (size_t i = 0; i < full_walk.size(); ++i) {
      block_position[full_walk[i]] = i;
    }

    if (decompile_options.annotate_mermaid) {
      string_stream << spacing << "// [mermaid] acyclic region entry=" << region.entry
                    << " blocks=" << region.blocks.size() << "\n";
    }
    for (int block_id : full_walk) {
      // Emit "early" phi assignments for incoming edges from blocks that appear
      // LATER in the walk order (topological ordering violations). Without this,
      // the phi value arrives too late — the target block reads the variable before
      // the source block writes it.
      if (block_position.contains(block_id)) {
        size_t my_pos = block_position[block_id];
        for (const auto& edge : graph_edges) {
          if (edge.target != block_id) continue;
          if (edge.type == GraphEdgeType::BackEdge) continue;
          if (edge.phi_assignments.empty()) continue;
          if (!region.blocks.contains(edge.source)) continue;
          // Check if source appears after target in the walk order
          if (!block_position.contains(edge.source)) continue;
          if (block_position[edge.source] <= my_pos) continue;
          // Skip source blocks that are appended after RPO (external predecessor
          // blocks). Their RC=true doesn't mean "always reached" — it means
          // "reached when the external path is taken." Their phi assignments are
          // emitted correctly when the block itself is processed later.
          if (!rpo_set.contains(edge.source)) continue;
          // Skip pre-header edges to loop headers — the loop region's
          // emit_loop_region call will emit these phi assignments itself.
          if (mermaid_loop_bodies.contains(edge.target)) {
            const auto& loop_body = mermaid_loop_bodies.at(edge.target);
            if (!loop_body.contains(edge.source)) continue;
          }
          // Source is later — emit its phi assignments early, guarded by source RC
          CondExprPtr src_rc = rc.contains(edge.source) ? rc[edge.source] : make_const(false);
          if (is_const_false(src_rc)) continue;

          bool src_needs_guard = !is_const_true(src_rc);
          std::string src_guard;
          if (src_needs_guard) {
            if (src_rc->kind == CondExpr::Kind::Var) {
              src_guard = src_rc->var_name;
            } else if (rc_vars.contains(edge.source)) {
              src_guard = rc_vars[edge.source];
            } else {
              src_guard = emit_expr(src_rc);
            }
          }

          // Also apply edge condition if it's a conditional branch
          std::string full_guard;
          if (edge.type == GraphEdgeType::TrueBranch && cond_vars.contains(edge.source)) {
            full_guard = src_needs_guard
              ? std::format("{} && {}", src_guard, cond_vars[edge.source])
              : cond_vars[edge.source];
          } else if (edge.type == GraphEdgeType::FalseBranch && cond_vars.contains(edge.source)) {
            full_guard = src_needs_guard
              ? std::format("{} && !{}", src_guard, cond_vars[edge.source])
              : std::format("!{}", cond_vars[edge.source]);
          } else if (src_needs_guard) {
            full_guard = src_guard;
          }

          bool has_phis = false;
          for (const auto& pa : edge.phi_assignments) {
            if (pa.value != "undef") { has_phis = true; break; }
          }
          if (!has_phis) continue;

          if (!full_guard.empty()) {
            string_stream << spacing << "if (" << full_guard << ") {\n";
            indent_spacing();
          }
          for (const auto& pa : edge.phi_assignments) {
            emit_phi_assignment(pa);
          }
          if (!full_guard.empty()) {
            unindent_spacing();
            string_stream << spacing << "}\n";
          }
        }
      }

      // Check if this block has code_blocks entry (has HLSL instructions)
      bool has_code_block = current_code_function->code_blocks.contains(block_id);

      // Get this block's reaching condition
      CondExprPtr block_rc = rc.contains(block_id) ? rc[block_id] : make_const(false);

      // Skip blocks with RC = const false (unreachable)
      if (is_const_false(block_rc)) {
        if (decompile_options.annotate) {
          string_stream << spacing << ann_block(block_id) << " skipped (RC = false)\n";
        }
        continue;
      }

      // Determine the guard expression for this block
      bool needs_guard = !is_const_true(block_rc);
      std::string guard_expr;

      if (needs_guard) {
        // Determine what to use as the if-guard:
        // - If RC is a single Var, use that var name directly (Req 6.6)
        // - If RC has an __rc_N variable, use that
        // - Otherwise, inline the expression
        if (block_rc->kind == CondExpr::Kind::Var) {
          guard_expr = block_rc->var_name;
        } else if (rc_vars.contains(block_id)) {
          guard_expr = rc_vars[block_id];
        } else {
          guard_expr = emit_expr(block_rc);
        }
      }

      // Annotate block in debug mode
      if (decompile_options.annotate) {
        string_stream << spacing << ann_block(block_id);
        if (needs_guard) {
          if (use_mermaid_prefix) {
            string_stream << " (guard: " << guard_expr << ")";
          } else {
            string_stream << " (" << guard_expr << ": " << expand_guard(guard_expr, cond_vars, rc, rc_vars) << ")";
          }
        } else {
          string_stream << (use_mermaid_prefix ? " (no guard, RC = true)" : " (no guard)");
        }
        string_stream << "\n";
      }

      // Emit __rc_N variable for blocks with complex RCs (before the guard — 
      // this block's RC depends on predecessor conditions, not this block's code)
      emit_rc_var(block_id, rc, rc_vars);

      // Open the guard if needed
      if (needs_guard) {
        string_stream << spacing << "if (" << guard_expr << ") {\n";
        indent_spacing();
      }

      // Inject heap resource declarations for blocks that use but don't declare
      // them. Re-emits the canonical `ResourceDescriptorHeap[...]` lookup so
      // the handle is reconstructed inside the current scope rather than
      // falling back to an outer (possibly zero-initialized) binding.
      for (const auto& decl : heap_decls_to_inject(block_id)) {
        string_stream << spacing << decl << "\n";
      }

      // Emit the block's hlsl_lines (the already-decompiled HLSL body)
      // When a line declares a variable that was already pre-declared at function
      // scope (by the SSA pre-declaration infrastructure), strip the type prefix
      // and emit just the assignment. This prevents redefinition errors when
      // variables are used across guarded blocks.
      // Also handles array declarations (e.g., "int _56[4]") by skipping them
      // entirely when already pre-declared.
      static const std::regex mermaid_decl_re(R"(^(float4|float3|float2|float|int64_t|uint64_t|int16_t[234]?|uint16_t[234]?|int|uint|bool|uint4|int4|int2|uint2|int3|uint3|double|half[234]?|min16float[234]?|min16int[234]?|min16uint[234]?)\s+(_\d+)\s*=)");
      static const std::regex mermaid_array_decl_re(R"(^(float|int|uint)\s+(_\d+)\[(\d+)\];?\s*$)");
      // Match "Type _NNN;" declarations without assignment (e.g., "int _259; InterlockedAdd(..., _259);")
      static const std::regex mermaid_decl_noassign_re(R"(^(float4|float3|float2|float|int64_t|uint64_t|int16_t[234]?|uint16_t[234]?|int|uint|bool|uint4|int4|int2|uint2|int3|uint3|double|half[234]?|min16float[234]?|min16int[234]?|min16uint[234]?)\s+(_\d+)\s*;)");
      if (has_code_block) {
        const auto& code_block = current_code_function->code_blocks.at(block_id);
        for (const auto& line : code_block.hlsl_lines) {
          std::string emit_line = line;
          std::smatch m;
          // Check for array declarations first (e.g., "int _56[4]")
          if (std::regex_search(emit_line, m, mermaid_array_decl_re)) {
            std::string var_name = m[2].str();
            if (declared_vars.contains(var_name)) {
              // Already pre-declared at function scope — skip entirely
              continue;
            }
          }
          // Check for scalar/vector variable declarations with assignment
          if (std::regex_search(emit_line, m, mermaid_decl_re)) {
            std::string var_name = m[2].str();
            if (declared_vars.contains(var_name)) {
              // Already pre-declared at function scope — emit as assignment only
              emit_line = var_name + " =" + m.suffix().str();
            }
          }
          // Check for "Type _NNN; ..." declarations without assignment (atomic output params)
          // Strip the entire "Type _NNN; " prefix, keeping only the function call part
          else if (std::regex_search(emit_line, m, mermaid_decl_noassign_re)) {
            std::string var_name = m[2].str();
            if (declared_vars.contains(var_name)) {
              // Strip "Type _NNN;" and any leading whitespace from the remainder
              std::string remainder = m.suffix().str();
              // Remove leading whitespace from remainder
              size_t start = remainder.find_first_not_of(" \t");
              if (start != std::string::npos) {
                emit_line = remainder.substr(start);
              } else {
                // Nothing after the declaration — skip the line entirely
                continue;
              }
            }
          }
          string_stream << spacing << emit_line << "\n";
        }
      }

      // Emit __cond_N variable for branch blocks AFTER the block's hlsl_lines.
      emit_cond_var(block_id, cond_vars);

      // Emit __switch_N_default variable for switch blocks (also after hlsl_lines)
      emit_switch_default_var(block_id);

      // Emit phi assignments for all outgoing edges from this block.
      // Each edge from this block to a target in the region carries phi assignments
      // that must be emitted HERE (inside this block's guard), not at the target.
      // For conditional edges (TrueBranch/FalseBranch), the phi assignments must be
      // further guarded by the branch condition to prevent cross-arm contamination:
      // without this, a FalseBranch phi overwrites the variable unconditionally,
      // even when the TrueBranch is taken.
      if (outgoing_edges.contains(block_id)) {
        // Check if this block has both true and false outgoing edges (conditional branch)
        bool has_true_edge = false, has_false_edge = false;
        for (const auto* ep : outgoing_edges.at(block_id)) {
          if (ep->type == GraphEdgeType::TrueBranch) has_true_edge = true;
          if (ep->type == GraphEdgeType::FalseBranch) has_false_edge = true;
        }
        bool is_conditional = has_true_edge && has_false_edge;

        for (const auto* edge_ptr : outgoing_edges.at(block_id)) {
          const auto& edge = *edge_ptr;

          // Skip back-edges (handled by loop emission)
          if (edge.type == GraphEdgeType::BackEdge) continue;

          // Skip pre-header edges to loop headers — emit_loop_region will emit
          // these phi assignments as pre-header phis. Without this skip, the
          // phi expression is emitted twice: once here (as the source block's
          // outgoing edge phi) and again in emit_loop_region. For wave intrinsics
          // this produces two distinct wave ops with potentially different lane
          // masks, causing per-lane non-uniform values where the original shader
          // expected uniform ones.
          if (mermaid_loop_bodies.contains(edge.target)) {
            const auto& loop_body = mermaid_loop_bodies.at(edge.target);
            // Target is a loop header, and source is outside that loop body
            // => this is a pre-header edge. Skip it.
            if (!loop_body.contains(edge.source)) {
              continue;
            }
          }

          // Determine if this edge's phis need an edge-condition guard
          bool needs_edge_guard = false;
          std::string edge_guard;
          if (is_conditional && !edge.phi_assignments.empty() && cond_vars.contains(block_id)) {
            if (edge.type == GraphEdgeType::TrueBranch) {
              needs_edge_guard = true;
              edge_guard = cond_vars.at(block_id);
            } else if (edge.type == GraphEdgeType::FalseBranch) {
              needs_edge_guard = true;
              edge_guard = std::format("!{}", cond_vars.at(block_id));
            }
          }

          // Check if there are any non-undef phis to emit
          bool has_phis = false;
          for (const auto& pa : edge.phi_assignments) {
            if (pa.value != "undef") { has_phis = true; break; }
          }

          if (needs_edge_guard && has_phis) {
            string_stream << spacing << "if (" << edge_guard << ") {\n";
            indent_spacing();
          }

          for (const auto& pa : edge.phi_assignments) {
            emit_phi_assignment(pa);
          }

          // Inject convergence bypass phis immediately after phi assignments.
          if (convergence_bypass_phis.contains(edge.target)) {
            const auto& bypass_map = convergence_bypass_phis.at(edge.target);
            std::string bp_guard;
            std::vector<std::pair<std::string, std::string>> bp_overrides;
            for (const auto& pa : edge.phi_assignments) {
              if (bypass_map.contains(pa.variable)) {
                const auto& info = bypass_map.at(pa.variable);
                bp_guard = info.guard_var;
                bp_overrides.push_back({pa.variable, info.skip_value});
              }
            }
            // Only emit if the guard variable was actually declared
            if (!bp_guard.empty() && !bp_overrides.empty() && emitted_bool_vars.contains(bp_guard)) {
              string_stream << spacing << "if (!" << bp_guard << ") {\n";
              indent_spacing();
              for (const auto& [var, val] : bp_overrides) {
                string_stream << spacing << var << " = " << val << ";\n";
              }
              unindent_spacing();
              string_stream << spacing << "}\n";
            }
          }

          if (needs_edge_guard && has_phis) {
            unindent_spacing();
            string_stream << spacing << "}\n";
          }
        }
      }

      // Close the guard if needed
      if (needs_guard) {
        unindent_spacing();
        string_stream << spacing << "}\n";
      }
    }

    // Record inter-region exit RCs for blocks with cross-region outgoing edges.
    // This enables subsequent regions to look up the actual RC of their external
    // predecessors instead of assuming RC=true.
    for (int block_id : region.blocks) {
      // Check if this block has any outgoing edge to a block outside this region
      bool has_cross_region_edge = false;
      for (const auto& edge : graph_edges) {
        if (edge.source != block_id) continue;
        if (edge.type == GraphEdgeType::BackEdge) continue;
        if (region.blocks.contains(edge.target)) continue;
        has_cross_region_edge = true;
        break;
      }
      if (!has_cross_region_edge) continue;

      // Record this block's RC variable
      if (!rc.contains(block_id)) continue;
      const auto& expr = rc[block_id];
      if (is_const_true(expr)) {
        block_exit_rc[block_id] = "";  // empty string means "true"
      } else if (is_const_false(expr)) {
        // Don't record — block is unreachable, shouldn't contribute
        continue;
      } else if (expr->kind == CondExpr::Kind::Var) {
        block_exit_rc[block_id] = expr->var_name;
      } else if (rc_vars.contains(block_id)) {
        block_exit_rc[block_id] = rc_vars[block_id];
      } else {
        // Complex expression without an __rc_N variable — create one
        std::string var_name = std::format("__rc_{}", block_id);
        block_exit_rc[block_id] = var_name;
      }
    }
  };

  // ============================================================
  // Loop Region Emission (Task 9.1)
  // ============================================================

  // Emit a loop region as [loop] for(;;) { ... break; } with guarded body blocks.
  // Algorithm:
  //   1. Emit pre-header phi assignments (edges from outside loop → header)
  //   2. Emit [loop] for (;;) {
  //   3. Compute reaching conditions for loop body blocks relative to header
  //   4. Emit guarded blocks inside the loop body (same pattern as acyclic)
  //   5. Emit guarded break for loop exit
  //   6. Emit back-edge phi assignments (latch → header)
  //   7. Emit closing }
  std::function<void(const EmitRegion&)> emit_loop_region;
  emit_loop_region = [&](const EmitRegion& region) {
    int header = region.loop_header;
    if (header < 0) return;


    // --- Step 1: Emit pre-header phi assignments ---
    // These are phi assignments on edges from OUTSIDE the loop body to the header.
    // They represent the initial values of loop-carried variables before the loop starts.
    if (decompile_options.annotate) {
      string_stream << spacing << "// [mermaid] loop region entry=" << header
                    << " exit=" << region.loop_exit
                    << " body=[";
      bool first = true;
      for (int b : region.blocks) {
        if (!first) string_stream << ",";
        string_stream << b;
        first = false;
      }
      string_stream << "] back_edges=[";
      first = true;
      for (int b : region.back_edge_sources) {
        if (!first) string_stream << ",";
        string_stream << b;
        first = false;
      }
      string_stream << "]\n";
    }

    for (const auto& edge : graph_edges) {
      // Edges targeting the header from blocks NOT in the loop body = pre-header edges
      if (edge.target != header) continue;
      if (region.blocks.contains(edge.source)) continue;  // skip intra-loop edges (back-edges)

      for (const auto& pa : edge.phi_assignments) {
        emit_phi_assignment(pa);
      }
    }

    // --- Step 2: Emit [loop] for (;;) { ---
    string_stream << spacing << "[loop] for (;;) {\n";
    indent_spacing();

    // --- Step 3: Compute reaching conditions for loop body blocks ---
    // The header is the local entry point (RC = true within the loop).
    std::map<int, std::string> loop_cond_vars;
    std::map<int, std::string> loop_rc_vars;
    auto loop_rc = compute_reaching_conditions(header, region.blocks, loop_cond_vars, loop_rc_vars, false);

    // --- Step 4: Compute topological order (RPO) within the loop body ---
    auto loop_rpo = compute_rpo(header, region.blocks);

    // Build lookup structures for nested loops so we can emit them recursively
    // instead of as flat guarded blocks.
    std::map<int, const EmitRegion*> nested_loop_by_header;  // header → nested EmitRegion
    std::set<int> blocks_in_nested_loops;  // all blocks belonging to any nested loop
    for (const auto& nested : region.nested_loops) {
      if (nested.kind == EmitRegion::Kind::Loop && nested.loop_header >= 0) {
        nested_loop_by_header[nested.loop_header] = &nested;
        for (int b : nested.blocks) {
          if (b != nested.loop_header) {  // header is emitted by emit_loop_region
            blocks_in_nested_loops.insert(b);
          }
        }
      }
    }

    // Build edge lookup for phi assignments within the loop body
    std::map<int, std::vector<const GraphEdge*>> loop_outgoing_edges;
    for (const auto& edge : graph_edges) {
      if (region.blocks.contains(edge.source) && region.blocks.contains(edge.target)) {
        loop_outgoing_edges[edge.source].push_back(&edge);
      }
    }

    // Determine the exit condition: find edges from loop body blocks to blocks OUTSIDE the loop.
    // The exit condition is the reaching condition of the path that leads out of the loop.
    // We collect all edges from body blocks to any block outside the loop body and build
    // the exit condition from their contributions.
    CondExprPtr exit_condition = nullptr;
    {
      std::vector<CondExprPtr> exit_contributions;
      for (const auto& edge : graph_edges) {
        if (!region.blocks.contains(edge.source)) continue;
        if (region.blocks.contains(edge.target)) continue;  // skip intra-loop edges
        if (edge.type == GraphEdgeType::BackEdge) continue;

        // The exit contribution is the predecessor's RC combined with the edge condition.
        // Clone to prevent simplify() from corrupting loop_rc entries via std::move.
        CondExprPtr pred_rc = loop_rc.contains(edge.source) ? clone_expr(loop_rc[edge.source]) : make_const(false);

        // Use the variable reference form if the RC has an __rc_N variable
        if (!is_const_true(pred_rc) && !is_const_false(pred_rc)
            && pred_rc->kind != CondExpr::Kind::Var
            && loop_rc_vars.contains(edge.source)) {
          pred_rc = make_var(loop_rc_vars[edge.source]);
        }

        switch (edge.type) {
          case GraphEdgeType::TrueBranch: {
            if (!loop_cond_vars.contains(edge.source)) {
              loop_cond_vars[edge.source] = std::format("__cond_{}", edge.source);
            }
            exit_contributions.push_back(make_and(pred_rc, make_var(loop_cond_vars[edge.source])));
            break;
          }
          case GraphEdgeType::FalseBranch: {
            if (!loop_cond_vars.contains(edge.source)) {
              loop_cond_vars[edge.source] = std::format("__cond_{}", edge.source);
            }
            exit_contributions.push_back(make_and(pred_rc, make_not(make_var(loop_cond_vars[edge.source]))));
            break;
          }
          case GraphEdgeType::Unconditional: {
            exit_contributions.push_back(pred_rc);
            break;
          }
          default:
            break;
        }
      }

      if (exit_contributions.size() == 1) {
        exit_condition = exit_contributions[0];
      } else if (exit_contributions.size() > 1) {
        exit_condition = exit_contributions[0];
        for (size_t i = 1; i < exit_contributions.size(); ++i) {
          exit_condition = make_or(exit_condition, exit_contributions[i]);
        }
      }
      if (exit_condition) {
        exit_condition = simplify(exit_condition, 0);
      }
    }

    // --- Step 5: Walk blocks in RPO order and emit guarded code ---
    // Same pattern as emit_acyclic_region, but within the loop body.
    // Type-stripping regex for variable declarations (same as emit_acyclic_region)
    static const std::regex loop_decl_re(R"(^(float4|float3|float2|float|int64_t|uint64_t|int16_t[234]?|uint16_t[234]?|int|uint|bool|uint4|int4|int2|uint2|int3|uint3|double|half[234]?|min16float[234]?|min16int[234]?|min16uint[234]?)\s+(_\d+)\s*=)");
    static const std::regex loop_array_decl_re(R"(^(float|int|uint)\s+(_\d+)\[(\d+)\];?\s*$)");
    // Match "Type _NNN;" declarations without assignment (e.g., atomic output params)
    static const std::regex loop_decl_noassign_re(R"(^(float4|float3|float2|float|int64_t|uint64_t|int16_t[234]?|uint16_t[234]?|int|uint|bool|uint4|int4|int2|uint2|int3|uint3|double|half[234]?|min16float[234]?|min16int[234]?|min16uint[234]?)\s+(_\d+)\s*;)");

    // Pre-declare all __cond_N and __rc_N variables at the outer loop scope.
    // This ensures they're visible both inside nested loops (where they're assigned)
    // and in the outer loop's exit/continuation conditions (where they're referenced).
    for (const auto& [bid, vname] : loop_cond_vars) {
      if (!emitted_bool_vars.contains(vname)) {
        string_stream << spacing << "bool " << vname << " = false;\n";
        emitted_bool_vars.insert(vname);
      }
    }
    for (const auto& [bid, vname] : loop_rc_vars) {
      if (!emitted_bool_vars.contains(vname)) {
        string_stream << spacing << "bool " << vname << " = false;\n";
        emitted_bool_vars.insert(vname);
      }
    }

    // Also pre-declare __switch_N_default variables for any switch blocks in this loop.
    for (int bid : region.blocks) {
      if (!current_code_function->code_blocks.contains(bid)) continue;
      const auto& cb = current_code_function->code_blocks.at(bid);
      if (cb.code_switch.switch_condition.empty()) continue;
      if (cb.code_switch.case_default < 0) continue;
      std::string sw_var = std::format("__switch_{}_default", bid);
      if (!emitted_bool_vars.contains(sw_var)) {
        string_stream << spacing << "bool " << sw_var << " = false;\n";
        emitted_bool_vars.insert(sw_var);
      }
    }

    for (int block_id : loop_rpo) {
      // If this block belongs to a nested loop (but is not the header), skip it —
      // it will be emitted by the nested loop's recursive emit_loop_region call.
      if (blocks_in_nested_loops.contains(block_id)) continue;

      // If this block is a nested loop header, emit the nested loop recursively.
      if (nested_loop_by_header.contains(block_id)) {
        const auto& nested = *nested_loop_by_header[block_id];

        emit_loop_region(nested);

        // After emitting the nested loop, assign __rc_N variables for blocks
        // inside the nested loop that have entries in the OUTER loop's rc_vars.
        for (int nested_bid : nested.blocks) {
          if (loop_rc_vars.contains(nested_bid) && loop_rc.contains(nested_bid)) {
            emit_rc_var(nested_bid, loop_rc, loop_rc_vars);
          }
        }

        continue;
      }

      if (!current_code_function->code_blocks.contains(block_id)) continue;

      const auto& code_block = current_code_function->code_blocks.at(block_id);

      // Get this block's reaching condition (relative to loop header)
      CondExprPtr block_rc = loop_rc.contains(block_id) ? loop_rc[block_id] : make_const(false);

      // Skip blocks with RC = const false (unreachable within loop)
      if (is_const_false(block_rc)) {
        if (decompile_options.annotate) {
          string_stream << spacing << ann_loop_block(block_id) << " skipped (RC = false)\n";
        }
        continue;
      }


      // Determine the guard expression
      bool needs_guard = !is_const_true(block_rc);
      std::string guard_expr;

      if (needs_guard) {
        if (block_rc->kind == CondExpr::Kind::Var) {
          guard_expr = block_rc->var_name;
        } else if (loop_rc_vars.contains(block_id)) {
          guard_expr = loop_rc_vars[block_id];
        } else {
          guard_expr = emit_expr(block_rc);
        }
      }

      // Annotate block in debug mode
      if (decompile_options.annotate) {
        string_stream << spacing << ann_loop_block(block_id);
        if (needs_guard) {
          if (use_mermaid_prefix) {
            string_stream << " (guard: " << guard_expr << ")";
          } else {
            string_stream << " (" << guard_expr << ": " << expand_guard(guard_expr, loop_cond_vars, loop_rc, loop_rc_vars) << ")";
          }
        } else {
          string_stream << (use_mermaid_prefix ? " (no guard, RC = true)" : " (no guard)");
        }
        string_stream << "\n";
      }

      // Emit __rc_N variable for blocks with complex RCs (before the guard)
      emit_rc_var(block_id, loop_rc, loop_rc_vars);

      // Open the guard if needed
      if (needs_guard) {
        string_stream << spacing << "if (" << guard_expr << ") {\n";
        indent_spacing();
      }

      // Inject heap resource declarations for blocks that use but don't declare
      // them. See the acyclic emit site for rationale.
      for (const auto& decl : heap_decls_to_inject(block_id)) {
        string_stream << spacing << decl << "\n";
      }

      // Emit the block's hlsl_lines with type-stripping for pre-declared variables
      for (const auto& line : code_block.hlsl_lines) {
        std::string emit_line = line;
        std::smatch m;
        // Check for array declarations first
        if (std::regex_search(emit_line, m, loop_array_decl_re)) {
          std::string var_name = m[2].str();
          if (declared_vars.contains(var_name)) {
            continue;  // Already pre-declared — skip
          }
        }
        // Check for scalar/vector variable declarations with assignment
        if (std::regex_search(emit_line, m, loop_decl_re)) {
          std::string var_name = m[2].str();
          if (declared_vars.contains(var_name)) {
            emit_line = var_name + " =" + m.suffix().str();
          }
        }
        // Check for "Type _NNN; ..." declarations without assignment (atomic output params)
        else if (std::regex_search(emit_line, m, loop_decl_noassign_re)) {
          std::string var_name = m[2].str();
          if (declared_vars.contains(var_name)) {
            std::string remainder = m.suffix().str();
            size_t start = remainder.find_first_not_of(" \t");
            if (start != std::string::npos) {
              emit_line = remainder.substr(start);
            } else {
              continue;
            }
          }
        }
        string_stream << spacing << emit_line << "\n";
      }

      // Emit __cond_N variable for branch blocks AFTER the block's hlsl_lines.
      // The branch condition depends on values computed by the block's code.
      emit_cond_var(block_id, loop_cond_vars);

      // Emit __switch_N_default variable for switch blocks (also after hlsl_lines)
      emit_switch_default_var(block_id);

      // Emit phi assignments for outgoing edges within the loop body
      // (skip back-edges — those are handled separately at the end)
      // For conditional edges, guard phis by the branch condition to prevent cross-arm contamination.
      if (loop_outgoing_edges.contains(block_id)) {
        bool has_true_edge = false, has_false_edge = false;
        for (const auto* ep : loop_outgoing_edges.at(block_id)) {
          if (ep->type == GraphEdgeType::TrueBranch) has_true_edge = true;
          if (ep->type == GraphEdgeType::FalseBranch) has_false_edge = true;
        }
        bool is_conditional = has_true_edge && has_false_edge;

        for (const auto* edge_ptr : loop_outgoing_edges.at(block_id)) {
          const auto& edge = *edge_ptr;

          // Skip back-edges (handled in step 6)
          if (edge.type == GraphEdgeType::BackEdge) continue;

          // Skip edges to blocks outside the loop (phi assignments for exit are handled
          // after the break statement)
          if (!region.blocks.contains(edge.target)) continue;

          // Skip pre-header edges to nested loop headers — the nested loop's
          // emit_loop_region call will emit these phi assignments as pre-header
          // phis. Without this skip, the phi expression is emitted twice: once
          // here and again in the nested loop's pre-header.
          if (nested_loop_by_header.contains(edge.target)) {
            const auto& nested = *nested_loop_by_header.at(edge.target);
            // Source is outside the nested loop's body => pre-header edge.
            if (!nested.blocks.contains(edge.source)) {
              continue;
            }
          }

          // Determine if this edge's phis need an edge-condition guard
          bool needs_edge_guard = false;
          std::string edge_guard;
          if (is_conditional && !edge.phi_assignments.empty() && loop_cond_vars.contains(block_id)) {
            if (edge.type == GraphEdgeType::TrueBranch) {
              needs_edge_guard = true;
              edge_guard = loop_cond_vars.at(block_id);
            } else if (edge.type == GraphEdgeType::FalseBranch) {
              needs_edge_guard = true;
              edge_guard = std::format("!{}", loop_cond_vars.at(block_id));
            }
          }

          bool has_phis = false;
          for (const auto& pa : edge.phi_assignments) {
            if (pa.value != "undef") { has_phis = true; break; }
          }

          if (needs_edge_guard && has_phis) {
            string_stream << spacing << "if (" << edge_guard << ") {\n";
            indent_spacing();
          }

          for (const auto& pa : edge.phi_assignments) {
            emit_phi_assignment(pa);
          }

          if (needs_edge_guard && has_phis) {
            unindent_spacing();
            string_stream << spacing << "}\n";
          }
        }
      }

      // Close the guard if needed
      if (needs_guard) {
        unindent_spacing();
        string_stream << spacing << "}\n";
      }
    }

    // --- Step 6: Emit guarded break for loop exit ---
    if (exit_condition) {
      std::string exit_expr;
      if (is_const_true(exit_condition)) {
        // Unconditional break (loop always exits after one iteration)
        exit_expr = "true";
      } else {
        exit_expr = emit_expr(exit_condition);
      }

      if (decompile_options.annotate) {
        string_stream << spacing << (use_mermaid_prefix ? "// [mermaid] loop exit condition\n" : "// --- loop exit ---\n");
      }

      // Emit phi assignments for the exit edge(s) inside the break guard
      // These are phi assignments on edges from body blocks to blocks outside the loop
      bool has_exit_phis = false;
      for (const auto& edge : graph_edges) {
        if (!region.blocks.contains(edge.source)) continue;
        if (region.blocks.contains(edge.target)) continue;  // skip intra-loop edges
        if (edge.type == GraphEdgeType::BackEdge) continue;
        if (!edge.phi_assignments.empty()) {
          has_exit_phis = true;
          break;
        }
      }

      if (has_exit_phis) {
        // Emit exit phi assignments inside the exit guard
        // Each exit edge gets its own guarded phi assignments
        for (const auto& edge : graph_edges) {
          if (!region.blocks.contains(edge.source)) continue;
          if (region.blocks.contains(edge.target)) continue;  // skip intra-loop edges
          if (edge.type == GraphEdgeType::BackEdge) continue;

          // Compute the guard for this edge's phi assignments ONCE (outside the phi loop).
          // Clone src_rc to prevent simplify() from corrupting loop_rc entries.
          CondExprPtr src_rc = loop_rc.contains(edge.source) ? clone_expr(loop_rc[edge.source]) : make_const(false);

          // Build the full guard: source RC AND edge condition
          CondExprPtr phi_guard = src_rc;
          if (edge.type == GraphEdgeType::TrueBranch && loop_cond_vars.contains(edge.source)) {
            phi_guard = make_and(clone_expr(src_rc), make_var(loop_cond_vars[edge.source]));
          } else if (edge.type == GraphEdgeType::FalseBranch && loop_cond_vars.contains(edge.source)) {
            phi_guard = make_and(clone_expr(src_rc), make_not(make_var(loop_cond_vars[edge.source])));
          }
          phi_guard = simplify(clone_expr(phi_guard), 0);

          std::string phi_guard_str;
          bool phi_guard_is_true = is_const_true(phi_guard);
          if (!phi_guard_is_true) {
            phi_guard_str = emit_expr(phi_guard);
          }

          for (const auto& pa : edge.phi_assignments) {
            if (pa.value == "undef") continue;

            std::string parsed_value;
            try {
              parsed_value = current_code_function->ParseByType(pa.value, pa.type);
            } catch (...) {
              if (pa.value.starts_with("%")) {
                parsed_value = std::format("_{}", pa.value.substr(1));
              } else if (pa.value.starts_with("_")) {
                parsed_value = pa.value;
              } else {
                parsed_value = pa.value;
              }
            }

            std::string optimized = OptimizeString(parsed_value);

            if (!phi_guard_is_true) {
              string_stream << spacing << "if (" << phi_guard_str << ") " << pa.variable << " = " << optimized << ";\n";
            } else {
              string_stream << spacing << pa.variable << " = " << optimized << ";\n";
            }
          }
        }
      }

      // Emit the break
      if (is_const_true(exit_condition)) {
        string_stream << spacing << "break;\n";
      } else {
        string_stream << spacing << "if (" << exit_expr << ") break;\n";
      }
    }

    // --- Step 7: Emit back-edge phi assignments (latch → header) ---
    // These are the loop-carried values: assignments from back-edge source blocks
    // to the loop header's phi variables.
    bool has_backedge_phis = false;
    for (const auto& edge : graph_edges) {
      if (edge.type != GraphEdgeType::BackEdge) continue;
      if (edge.target != header) continue;
      if (!region.blocks.contains(edge.source)) continue;
      if (!edge.phi_assignments.empty()) {
        has_backedge_phis = true;
        break;
      }
    }

    if (has_backedge_phis) {
      if (decompile_options.annotate) {
        string_stream << spacing << (use_mermaid_prefix ? "// [mermaid] back-edge phi assignments (latch -> header)\n" : "// --- back-edge phis ---\n");
      }

      // Collect all back-edge sources in the loop body
      std::vector<const GraphEdge*> backedge_list;
      for (const auto& edge : graph_edges) {
        if (edge.type != GraphEdgeType::BackEdge) continue;
        if (edge.target != header) continue;
        if (!region.blocks.contains(edge.source)) continue;
        backedge_list.push_back(&edge);
      }

      // If there's a single back-edge source, emit assignments directly.
      // If multiple, guard each by the source block's RC.
      for (const auto* edge_ptr : backedge_list) {
        const auto& edge = *edge_ptr;
        bool needs_latch_guard = backedge_list.size() > 1;
        CondExprPtr latch_rc;

        if (needs_latch_guard) {
          latch_rc = loop_rc.contains(edge.source) ? loop_rc[edge.source] : make_const(false);
          if (is_const_true(latch_rc)) {
            needs_latch_guard = false;
          }
        }

        if (needs_latch_guard && latch_rc) {
          std::string latch_guard;
          if (latch_rc->kind == CondExpr::Kind::Var) {
            latch_guard = latch_rc->var_name;
          } else if (loop_rc_vars.contains(edge.source)) {
            latch_guard = loop_rc_vars[edge.source];
          } else {
            latch_guard = emit_expr(latch_rc);
          }
          string_stream << spacing << "if (" << latch_guard << ") {\n";
          indent_spacing();
        }

        for (const auto& pa : edge.phi_assignments) {
          if (pa.value == "undef") continue;

          std::string parsed_value;
          try {
            parsed_value = current_code_function->ParseByType(pa.value, pa.type);
          } catch (...) {
            if (pa.value.starts_with("%")) {
              parsed_value = std::format("_{}", pa.value.substr(1));
            } else if (pa.value.starts_with("_")) {
              parsed_value = pa.value;
            } else {
              parsed_value = pa.value;
            }
          }

          std::string optimized = OptimizeString(parsed_value);
          string_stream << spacing << pa.variable << " = " << optimized << ";\n";
        }

        if (needs_latch_guard && latch_rc) {
          unindent_spacing();
          string_stream << spacing << "}\n";
        }
      }
    }

    // --- Step 8: Emit guarded continue for non-last latch blocks ---
    // When there are multiple back-edge sources and the latch is not the last
    // block in the loop body RPO, emit a guarded continue to skip remaining code.
    // (In practice, the back-edge phi assignments above handle the latch→header
    // transition, and the for(;;) loop naturally continues. A guarded continue
    // is only needed if there's code after the latch that shouldn't execute on
    // the continue path. Since we emit all blocks in RPO and the break handles
    // the exit, the natural loop continuation suffices for most cases.)

    // --- Step 9: Close the loop ---
    unindent_spacing();
    string_stream << spacing << "}\n";

    // Record inter-region exit RCs for loop body blocks with cross-region edges.
    // This enables subsequent regions to look up the actual RC of blocks inside
    // this loop that have outgoing edges to blocks outside the loop.
    for (int block_id : region.blocks) {
      bool has_cross_region_edge = false;
      for (const auto& edge : graph_edges) {
        if (edge.source != block_id) continue;
        if (edge.type == GraphEdgeType::BackEdge) continue;
        if (region.blocks.contains(edge.target)) continue;
        has_cross_region_edge = true;
        break;
      }
      if (!has_cross_region_edge) continue;

      // Record this block's RC within the loop context
      if (!loop_rc.contains(block_id)) continue;
      const auto& expr = loop_rc[block_id];
      if (is_const_true(expr)) {
        block_exit_rc[block_id] = "";  // empty string means "true"
      } else if (is_const_false(expr)) {
        continue;  // unreachable, don't record
      } else if (expr->kind == CondExpr::Kind::Var) {
        block_exit_rc[block_id] = expr->var_name;
      } else if (loop_rc_vars.contains(block_id)) {
        block_exit_rc[block_id] = loop_rc_vars[block_id];
      } else {
        std::string var_name = std::format("__rc_{}", block_id);
        block_exit_rc[block_id] = var_name;
      }
    }
  };

  // ============================================================
  // Switch Region Emission (Task 10.1)
  // ============================================================

  // Emit a switch region as switch (switch_var) { case N: { ... } }
  // Each case contains the target block's code and phi assignments for that edge.
  // When multiple cases target the same block (fallthrough), they are combined
  // with stacked case labels.
  auto emit_switch_region = [&](int switch_block) {
    if (!current_code_function->code_blocks.contains(switch_block)) return;

    const auto& code_block = current_code_function->code_blocks.at(switch_block);
    const auto& code_switch = code_block.code_switch;

    // Must actually be a switch block
    if (code_switch.switch_condition.empty()) return;

    if (decompile_options.annotate) {
      string_stream << spacing << "// [mermaid] switch region block=" << switch_block
                    << " condition=" << code_switch.switch_condition
                    << " cases=" << code_switch.case_values.size()
                    << " default=" << code_switch.case_default << "\n";
    }

    // --- Step 1: Emit the switch block's hlsl_lines (code before the switch) ---
    static const std::regex switch_decl_re(R"(^(float4|float3|float2|float|int64_t|uint64_t|int16_t[234]?|uint16_t[234]?|int|uint|bool|uint4|int4|int2|uint2|int3|uint3|double|half[234]?|min16float[234]?|min16int[234]?|min16uint[234]?)\s+(_\d+)\s*=)");
    static const std::regex switch_array_decl_re(R"(^(float|int|uint)\s+(_\d+)\[(\d+)\];?\s*$)");
    static const std::regex switch_decl_noassign_re(R"(^(float4|float3|float2|float|int64_t|uint64_t|int16_t[234]?|uint16_t[234]?|int|uint|bool|uint4|int4|int2|uint2|int3|uint3|double|half[234]?|min16float[234]?|min16int[234]?|min16uint[234]?)\s+(_\d+)\s*;)");
    // Inject heap resource declarations for the switch block.
    for (const auto& decl : heap_decls_to_inject(switch_block)) {
      string_stream << spacing << decl << "\n";
    }
    for (const auto& line : code_block.hlsl_lines) {
      std::string emit_line = line;
      std::smatch m;
      if (std::regex_search(emit_line, m, switch_array_decl_re)) {
        std::string var_name = m[2].str();
        if (declared_vars.contains(var_name)) {
          continue;
        }
      }
      if (std::regex_search(emit_line, m, switch_decl_re)) {
        std::string var_name = m[2].str();
        if (declared_vars.contains(var_name)) {
          emit_line = var_name + " =" + m.suffix().str();
        }
      } else if (std::regex_search(emit_line, m, switch_decl_noassign_re)) {
        std::string var_name = m[2].str();
        if (declared_vars.contains(var_name)) {
          std::string remainder = m.suffix().str();
          size_t start = remainder.find_first_not_of(" \t");
          if (start != std::string::npos) {
            emit_line = remainder.substr(start);
          } else {
            continue;
          }
        }
      }
      string_stream << spacing << emit_line << "\n";
    }

    // --- Step 2: Build a map of target_block → list of case labels ---
    // This handles fallthrough: multiple case values targeting the same block
    // get stacked case labels.
    struct CaseInfo {
      std::vector<std::string> labels;  // case value strings (empty string = default)
      bool is_default = false;
    };
    std::map<int, CaseInfo> target_cases;  // target_block_id → case info

    for (const auto& [case_value, case_target] : code_switch.case_values) {
      if (case_target < 0 || !current_code_function->code_blocks.contains(case_target)) continue;
      target_cases[case_target].labels.push_back(std::string(case_value));
    }

    if (code_switch.case_default >= 0
        && current_code_function->code_blocks.contains(code_switch.case_default)) {
      target_cases[code_switch.case_default].is_default = true;
    }

    // --- Step 3: Emit switch (switch_condition) { ---
    string_stream << spacing << "switch (" << code_switch.switch_condition << ") {\n";
    indent_spacing();

    // --- Step 4: Helper to emit a case body (target block code + phi assignments) ---
    auto emit_case_body = [&](int target_block) {
      if (!current_code_function->code_blocks.contains(target_block)) return;

      const auto& target_code_block = current_code_function->code_blocks.at(target_block);

      // Emit the target block's hlsl_lines with type-stripping
      // Inject heap resource declarations for the case's target block.
      for (const auto& decl : heap_decls_to_inject(target_block)) {
        string_stream << spacing << decl << "\n";
      }
      for (const auto& line : target_code_block.hlsl_lines) {
        std::string emit_line = line;
        std::smatch m;
        if (std::regex_search(emit_line, m, switch_array_decl_re)) {
          std::string var_name = m[2].str();
          if (declared_vars.contains(var_name)) {
            continue;
          }
        }
        if (std::regex_search(emit_line, m, switch_decl_re)) {
          std::string var_name = m[2].str();
          if (declared_vars.contains(var_name)) {
            emit_line = var_name + " =" + m.suffix().str();
          }
        } else if (std::regex_search(emit_line, m, switch_decl_noassign_re)) {
          std::string var_name = m[2].str();
          if (declared_vars.contains(var_name)) {
            std::string remainder = m.suffix().str();
            size_t start = remainder.find_first_not_of(" \t");
            if (start != std::string::npos) {
              emit_line = remainder.substr(start);
            } else {
              continue;
            }
          }
        }
        string_stream << spacing << emit_line << "\n";
      }

      // Emit phi assignments for edges from switch_block to this target
      for (const auto& edge : graph_edges) {
        if (edge.source != switch_block) continue;
        if (edge.target != target_block) continue;

        for (const auto& pa : edge.phi_assignments) {
          if (pa.value == "undef") continue;

          std::string parsed_value;
          try {
            parsed_value = current_code_function->ParseByType(pa.value, pa.type);
          } catch (...) {
            if (pa.value.starts_with("%")) {
              parsed_value = std::format("_{}", pa.value.substr(1));
            } else if (pa.value.starts_with("_")) {
              parsed_value = pa.value;
            } else {
              parsed_value = pa.value;
            }
          }

          std::string optimized = OptimizeString(parsed_value);
          string_stream << spacing << pa.variable << " = " << optimized << ";\n";
        }
      }
    };

    // --- Step 5: Emit each unique target block as a case group ---
    // Process case values first, then default
    std::set<int> emitted_targets;

    for (const auto& [case_value, case_target] : code_switch.case_values) {
      if (case_target < 0 || !current_code_function->code_blocks.contains(case_target)) continue;
      if (emitted_targets.contains(case_target)) continue;
      emitted_targets.insert(case_target);

      const auto& info = target_cases[case_target];

      // Emit all case labels for this target (stacked for fallthrough)
      for (const auto& label : info.labels) {
        string_stream << spacing << "case " << label << ":\n";
      }
      // If this target is also the default, emit default label too
      if (info.is_default) {
        string_stream << spacing << "default:\n";
      }

      // Open case body
      string_stream << spacing << "{\n";
      indent_spacing();

      if (decompile_options.annotate) {
        string_stream << spacing << "// --- case target block " << case_target << "\n";
      }

      emit_case_body(case_target);

      string_stream << spacing << "break;\n";
      unindent_spacing();
      string_stream << spacing << "}\n";
    }

    // --- Step 6: Emit default case if not already emitted as part of a shared target ---
    if (code_switch.case_default >= 0
        && current_code_function->code_blocks.contains(code_switch.case_default)
        && !emitted_targets.contains(code_switch.case_default)) {
      string_stream << spacing << "default:\n";
      string_stream << spacing << "{\n";
      indent_spacing();

      if (decompile_options.annotate) {
        string_stream << spacing << "// --- default target block " << code_switch.case_default << "\n";
      }

      emit_case_body(code_switch.case_default);

      string_stream << spacing << "break;\n";
      unindent_spacing();
      string_stream << spacing << "}\n";
    }

    // --- Step 7: Close the switch ---
    unindent_spacing();
    string_stream << spacing << "}\n";
  };

  // ============================================================
  // Irreducible Control Flow Dispatcher Fallback (Task 10.2)
  // ============================================================

  // When an acyclic region contains irreducible control flow (a cycle that
  // is not a natural loop), we fall back to a state-machine dispatcher:
  //   int __state = entry_id;
  //   [loop] for (;;) {
  //       switch (__state) {
  //           case block_N: { ... __state = next; break; }
  //       }
  //   }
  // This is a rare fallback — most shader CFGs are reducible.
  auto emit_dispatcher_fallback = [&](const std::set<int>& blocks, int entry) {
    // Type-stripping regexes (same patterns used elsewhere in the emitter)
    static const std::regex disp_decl_re(R"(^(float4|float3|float2|float|int64_t|uint64_t|int16_t[234]?|uint16_t[234]?|int|uint|bool|uint4|int4|int2|uint2|int3|uint3|double|half[234]?|min16float[234]?|min16int[234]?|min16uint[234]?)\s+(_\d+)\s*=)");
    static const std::regex disp_array_decl_re(R"(^(float|int|uint)\s+(_\d+)\[(\d+)\];?\s*$)");
    static const std::regex disp_decl_noassign_re(R"(^(float4|float3|float2|float|int64_t|uint64_t|int16_t[234]?|uint16_t[234]?|int|uint|bool|uint4|int4|int2|uint2|int3|uint3|double|half[234]?|min16float[234]?|min16int[234]?|min16uint[234]?)\s+(_\d+)\s*;)");

    // Log warning
    string_stream << spacing << "// [mermaid] WARNING: irreducible control flow detected, using dispatcher fallback\n";

    if (decompile_options.annotate) {
      string_stream << spacing << "// [mermaid] dispatcher blocks: {";
      bool first = true;
      for (int b : blocks) {
        if (!first) string_stream << ", ";
        string_stream << b;
        first = false;
      }
      string_stream << "} entry=" << entry << "\n";
    }

    // Emit state variable and loop
    string_stream << spacing << "int __state = " << entry << ";\n";
    string_stream << spacing << "[loop] for (;;) {\n";
    indent_spacing();
    string_stream << spacing << "switch (__state) {\n";
    indent_spacing();

    // Emit a case for each block (sorted by block ID via std::set ordering)
    for (int block_id : blocks) {
      if (!current_code_function->code_blocks.contains(block_id)) continue;
      const auto& code_block = current_code_function->code_blocks.at(block_id);

      string_stream << spacing << "case " << block_id << ": {\n";
      indent_spacing();

      if (decompile_options.annotate) {
        string_stream << spacing << "// --- dispatcher case block " << block_id << "\n";
      }

      // Emit the block's hlsl_lines with type-stripping for pre-declared vars
      // Inject heap resource declarations for the dispatcher case block.
      for (const auto& decl : heap_decls_to_inject(block_id)) {
        string_stream << spacing << decl << "\n";
      }
      for (const auto& line : code_block.hlsl_lines) {
        std::string emit_line = line;
        std::smatch m;
        if (std::regex_search(emit_line, m, disp_array_decl_re)) {
          std::string var_name = m[2].str();
          if (declared_vars.contains(var_name)) {
            continue;  // Already pre-declared — skip
          }
        }
        if (std::regex_search(emit_line, m, disp_decl_re)) {
          std::string var_name = m[2].str();
          if (declared_vars.contains(var_name)) {
            emit_line = var_name + " =" + m.suffix().str();
          }
        } else if (std::regex_search(emit_line, m, disp_decl_noassign_re)) {
          std::string var_name = m[2].str();
          if (declared_vars.contains(var_name)) {
            std::string remainder = m.suffix().str();
            size_t start = remainder.find_first_not_of(" \t");
            if (start != std::string::npos) {
              emit_line = remainder.substr(start);
            } else {
              continue;
            }
          }
        }
        string_stream << spacing << emit_line << "\n";
      }

      // Determine the next state transition based on the block's branch structure
      bool has_branch_condition = !code_block.code_branch.branch_condition.empty();
      int true_target = code_block.code_branch.branch_condition_true;
      int false_target = code_block.code_branch.branch_condition_false;

      if (has_branch_condition && true_target >= 0 && false_target >= 0) {
        // Conditional branch: emit if/else state transition
        std::string cond = code_block.code_branch.branch_condition;
        string_stream << spacing << "if (" << cond << ") __state = " << true_target
                      << "; else __state = " << false_target << ";\n";
      } else if (true_target >= 0) {
        // Unconditional branch: set state to the single target
        string_stream << spacing << "__state = " << true_target << ";\n";
      } else {
        // Terminal block (no successors): break out of the for loop
        string_stream << spacing << "break;\n";
      }

      // Emit phi assignments for outgoing edges from this block
      for (const auto& edge : graph_edges) {
        if (edge.source != block_id) continue;
        if (edge.type == GraphEdgeType::BackEdge) continue;
        for (const auto& pa : edge.phi_assignments) {
          if (pa.value == "undef") continue;

          std::string parsed_value;
          try {
            parsed_value = current_code_function->ParseByType(pa.value, pa.type);
          } catch (...) {
            if (pa.value.starts_with("%")) {
              parsed_value = std::format("_{}", pa.value.substr(1));
            } else if (pa.value.starts_with("_")) {
              parsed_value = pa.value;
            } else {
              parsed_value = pa.value;
            }
          }

          std::string optimized = OptimizeString(parsed_value);
          string_stream << spacing << pa.variable << " = " << optimized << ";\n";
        }
      }

      // Break out of the switch case
      string_stream << spacing << "break;\n";
      unindent_spacing();
      string_stream << spacing << "}\n";
    }

    // Close switch
    unindent_spacing();
    string_stream << spacing << "}\n";

    // Close for loop
    unindent_spacing();
    string_stream << spacing << "}\n";
  };

  // ============================================================
  // CFG Partitioning (Task 5.1)
  // ============================================================

  // Partition the CFG into a sequence of EmitRegions.
  // Top-level loops become Loop regions; everything else is Acyclic.
  // Nested loops are recursively partitioned within their parent loop body.
  // Regions are ordered so that blocks are emitted in topological order.
  std::function<std::vector<EmitRegion>(int, const std::set<int>&, int, int)> partition_cfg;
  partition_cfg = [&](
      int entry,
      const std::set<int>& all_blocks,
      int parent_loop_header,  // -1 at top level; set to the loop header when recursing into a loop body
      int depth
  ) -> std::vector<EmitRegion> {
    std::vector<EmitRegion> regions;

    if (all_blocks.empty()) return regions;

    // Guard against infinite recursion — max nesting depth of 20 is more than enough
    if (depth > 20) return regions;

    // Step 1: Identify top-level loops within all_blocks.
    // A loop is "top-level" relative to this partition call if:
    //   - Its header is in all_blocks
    //   - It is NOT the parent_loop_header (avoid infinite recursion — the parent
    //     loop is already being handled by the caller)
    //   - It is not nested inside another loop that is also top-level at this level
    std::set<int> candidate_headers;
    for (const auto& [header, body] : mermaid_loop_bodies) {
      // Only consider loops whose header is in our block set
      if (!all_blocks.contains(header)) continue;

      // Skip the parent loop header — it's already being handled by the caller.
      // Without this check, recursing into a loop body would re-discover the same
      // loop and recurse infinitely.
      if (header == parent_loop_header) continue;

      candidate_headers.insert(header);
    }

    // Two-pass nesting detection: a candidate header H is nested if there exists
    // another candidate header H2 (H2 != H) whose loop body contains H.
    // This correctly handles self-loops (block_to_loop_header[H] == H) by checking
    // against all other candidates' bodies rather than relying on the innermost-loop map.
    std::set<int> top_level_headers;
    for (int header : candidate_headers) {
      bool is_nested = false;
      for (int other_header : candidate_headers) {
        if (other_header == header) continue;
        if (mermaid_loop_bodies.contains(other_header)) {
          const auto& other_body = mermaid_loop_bodies.at(other_header);
          if (other_body.contains(header)) {
            is_nested = true;
            break;
          }
        }
      }
      if (!is_nested) {
        top_level_headers.insert(header);
      }
    }

    // Step 2: Collect all blocks that belong to top-level loops
    std::set<int> blocks_in_loops;
    for (int header : top_level_headers) {
      if (mermaid_loop_bodies.contains(header)) {
        const auto& body = mermaid_loop_bodies.at(header);
        for (int block : body) {
          if (all_blocks.contains(block)) {
            blocks_in_loops.insert(block);
          }
        }
      }
    }

    // Step 3: Compute RPO of all_blocks to determine region ordering
    auto rpo = compute_rpo(entry, all_blocks);

    // Step 4: Walk blocks in RPO order, grouping consecutive non-loop blocks
    // into Acyclic regions and emitting Loop regions when we hit a loop header.
    std::set<int> current_acyclic_blocks;
    int current_acyclic_entry = -1;
    std::set<int> emitted_loop_headers;

    auto flush_acyclic = [&]() {
      if (!current_acyclic_blocks.empty()) {
        EmitRegion acyclic_region;
        acyclic_region.kind = EmitRegion::Kind::Acyclic;
        acyclic_region.entry = current_acyclic_entry;
        acyclic_region.blocks = std::move(current_acyclic_blocks);
        regions.push_back(std::move(acyclic_region));
        current_acyclic_blocks.clear();
        current_acyclic_entry = -1;
      }
    };

    for (int block_id : rpo) {
      if (top_level_headers.contains(block_id) && !emitted_loop_headers.contains(block_id)) {
        flush_acyclic();

        EmitRegion loop_region;
        loop_region.kind = EmitRegion::Kind::Loop;
        loop_region.entry = block_id;
        loop_region.loop_header = block_id;

        if (mermaid_loop_bodies.contains(block_id)) {
          const auto& body = mermaid_loop_bodies.at(block_id);
          for (int b : body) {
            if (all_blocks.contains(b)) {
              loop_region.blocks.insert(b);
            }
          }
        }

        if (mermaid_natural_loops.contains(block_id)) {
          loop_region.back_edge_sources = mermaid_natural_loops.at(block_id);
        }

        loop_region.loop_exit = find_loop_exit(block_id, loop_region.blocks);
        loop_region.nested_loops = partition_cfg(block_id, loop_region.blocks, block_id, depth + 1);

        regions.push_back(std::move(loop_region));
        emitted_loop_headers.insert(block_id);
      } else if (!blocks_in_loops.contains(block_id)) {
        if (current_acyclic_entry < 0) {
          current_acyclic_entry = block_id;
        }
        current_acyclic_blocks.insert(block_id);
      }
    }

    flush_acyclic();

    return regions;
  };

  // ============================================================
  // Condition-based emission — Wired emission (Task 8)
  // ============================================================

  // Partition the CFG into acyclic and loop regions
  std::set<int> all_block_ids;
  for (const auto& [id, _] : graph_nodes) {
    all_block_ids.insert(id);
  }
  auto regions = partition_cfg(mermaid_entry_block, all_block_ids, -1, 0);

  // ============================================================
  // Preprocessing: Detect loop-bypass convergence phi patterns
  // ============================================================
  // For each guarded loop followed by an acyclic region, precompute which
  // phi variables at the convergence point need bypass treatment.

  for (size_t ri = 0; ri < regions.size(); ++ri) {
    if (regions[ri].kind != EmitRegion::Kind::Loop) continue;
    const auto& loop_region = regions[ri];
    if (loop_region.loop_header < 0) continue;

    // Check if this loop has a guarded entry (unconditional-branch predecessor)
    std::vector<int> ext_preds;
    for (const auto& edge : graph_edges) {
      if (edge.target != loop_region.loop_header) continue;
      if (edge.type == GraphEdgeType::BackEdge) continue;
      if (loop_region.blocks.contains(edge.source)) continue;
      ext_preds.push_back(edge.source);
    }
    if (ext_preds.size() != 1) continue;

    int pred = ext_preds[0];
    if (!current_code_function->code_blocks.contains(pred)) continue;
    const auto& pred_block = current_code_function->code_blocks.at(pred);
    if (!pred_block.code_branch.branch_condition.empty()) continue;  // must be unconditional

    // Only proceed if the predecessor is conditionally reachable (has multiple
    // predecessors or a predecessor with a conditional branch). If the predecessor
    // is always reached (single unconditional predecessor chain from entry), its
    // __rc_N won't be emitted and the bypass would reference an undeclared variable.
    bool pred_is_conditional = false;
    if (graph_nodes.contains(pred) && graph_nodes.at(pred).predecessors.size() >= 1) {
      // Check if any predecessor of pred has a conditional branch
      for (int pp : graph_nodes.at(pred).predecessors) {
        if (current_code_function->code_blocks.contains(pp)) {
          const auto& pp_block = current_code_function->code_blocks.at(pp);
          if (!pp_block.code_branch.branch_condition.empty()) {
            pred_is_conditional = true;
            break;
          }
        }
      }
    }
    if (!pred_is_conditional) continue;

    std::string guard_var = std::format("__rc_{}", pred);

    // Find the convergence region — the first region after the loop that contains
    // a block reachable from outside the guarded scope (the convergence point).
    // This may not be ri+1 if there are intermediate regions that are only
    // reachable from the loop exit (extended guard regions).
    const EmitRegion* convergence_region = nullptr;
    std::set<int> guarded_scope;
    guarded_scope.insert(loop_region.blocks.begin(), loop_region.blocks.end());
    guarded_scope.insert(pred);

    for (size_t search_ri = ri + 1; search_ri < regions.size(); ++search_ri) {
      const auto& candidate = regions[search_ri];

      // Check if this region contains a block with an external predecessor
      // from outside the guarded scope (convergence point)
      bool has_convergence = false;
      for (const auto& edge : graph_edges) {
        if (edge.type == GraphEdgeType::BackEdge) continue;
        if (!candidate.blocks.contains(edge.target)) continue;
        if (candidate.blocks.contains(edge.source)) continue;
        if (guarded_scope.contains(edge.source)) continue;
        // This block has a predecessor from outside the guarded scope
        has_convergence = true;
        break;
      }

      if (has_convergence) {
        convergence_region = &candidate;
        break;
      }

      // Check if this region's entry is only reachable from the guarded scope
      int next_entry = candidate.entry;
      bool all_preds_guarded = true;
      bool has_any_pred = false;
      for (const auto& edge : graph_edges) {
        if (edge.target != next_entry) continue;
        if (edge.type == GraphEdgeType::BackEdge) continue;
        has_any_pred = true;
        if (!guarded_scope.contains(edge.source)) {
          all_preds_guarded = false;
          break;
        }
      }
      if (!all_preds_guarded || !has_any_pred) {
        // Can't extend further — use this region as convergence
        convergence_region = &candidate;
        break;
      }

      // This region is part of the extended guard scope
      guarded_scope.insert(candidate.blocks.begin(), candidate.blocks.end());
    }

    if (!convergence_region) continue;

    // Find bypass edges: edges from outside the guarded scope to the convergence region
    for (const auto& edge : graph_edges) {
      if (!convergence_region->blocks.contains(edge.target)) continue;
      if (edge.type == GraphEdgeType::BackEdge) continue;
      if (loop_region.blocks.contains(edge.source)) continue;
      if (convergence_region->blocks.contains(edge.source)) continue;
      if (guarded_scope.contains(edge.source)) continue;
      if (edge.phi_assignments.empty()) continue;

      // Record bypass phi info for this convergence block
      int conv_block = edge.target;
      for (const auto& pa : edge.phi_assignments) {
        if (pa.value == "undef") continue;
        std::string parsed;
        try { parsed = current_code_function->ParseByType(pa.value, pa.type); }
        catch (...) {
          if (pa.value.starts_with("%")) parsed = std::format("_{}", pa.value.substr(1));
          else parsed = pa.value;
        }
        convergence_bypass_phis[conv_block][pa.variable] = {guard_var, OptimizeString(parsed), edge.source};
      }
      break;  // use first bypass edge
    }
  }

  // Emit each region
  // Safety limit: abort if the output grows beyond a reasonable size.
  // This prevents crashes from std::string reallocation on very large shaders.
  constexpr size_t MERMAID_MAX_OUTPUT_SIZE = 64 * 1024 * 1024;  // 64 MB

  // Pre-declare __cond_N and __rc_N variables at function scope for ALL blocks
  // that have outgoing edges to blocks NOT in the same innermost region.
  // These variables will be referenced by subsequent regions via block_exit_rc.
  // Declaring them here (at function scope) ensures they remain visible regardless
  // of which nested scope they're assigned in (e.g., inside loop guards or nested loops).
  //
  // Strategy: for each block, check if ANY of its successors is in a different
  // top-level region OR if the block is inside a loop whose exit target is outside.
  // Rather than complex region membership checks, we use a simpler heuristic:
  // pre-declare for any block whose successor has a LOWER block_id (potential
  // back-edge target) or is not in the same loop body.
  //
  // Simplest correct approach: pre-declare for ALL blocks that have successors
  // outside their own loop body (for loop blocks) or outside their own acyclic
  // region (for acyclic blocks).
  {
    // Build a lookup: block_id → set of region block_ids it belongs to (innermost)
    std::map<int, const std::set<int>*> block_to_region;
    std::function<void(const std::vector<EmitRegion>&)> map_blocks;
    map_blocks = [&](const std::vector<EmitRegion>& rgns) {
      for (const auto& r : rgns) {
        for (int bid : r.blocks) {
          // Innermost wins — nested loops override parent
          block_to_region[bid] = &r.blocks;
        }
        if (r.kind == EmitRegion::Kind::Loop) {
          map_blocks(r.nested_loops);
        }
      }
    };
    map_blocks(regions);

    for (const auto& [block_id, node] : graph_nodes) {
      const std::set<int>* my_region = block_to_region.contains(block_id) ? block_to_region[block_id] : nullptr;
      if (!my_region) continue;

      bool has_cross_region_edge = false;
      for (int succ : node.successors) {
        if (!my_region->contains(succ)) {
          has_cross_region_edge = true;
          break;
        }
      }
      if (!has_cross_region_edge) continue;

      // Pre-declare __rc_N
      std::string rc_var = std::format("__rc_{}", block_id);
      if (!emitted_bool_vars.contains(rc_var)) {
        string_stream << spacing << "bool " << rc_var << " = false;\n";
        emitted_bool_vars.insert(rc_var);
      }
      // Pre-declare __cond_N if this block has a branch condition
      if (current_code_function->code_blocks.contains(block_id)) {
        const auto& cb = current_code_function->code_blocks.at(block_id);
        if (!cb.code_branch.branch_condition.empty()) {
          std::string cond_var = std::format("__cond_{}", block_id);
          if (!emitted_bool_vars.contains(cond_var)) {
            string_stream << spacing << "bool " << cond_var << " = false;\n";
            emitted_bool_vars.insert(cond_var);
          }
        }
      }
    }
  }

  for (size_t ri = 0; ri < regions.size(); ++ri) {
    const auto& region = regions[ri];
    auto current_size = static_cast<size_t>(string_stream.tellp());
    if (current_size > MERMAID_MAX_OUTPUT_SIZE) {
      string_stream << spacing << "// [mermaid] ERROR: output exceeded "
                    << (MERMAID_MAX_OUTPUT_SIZE / (1024 * 1024))
                    << " MB limit, aborting emission\n";
      break;
    }
    if (region.kind == EmitRegion::Kind::Acyclic) {
      emit_acyclic_region(region);
    } else if (region.kind == EmitRegion::Kind::Loop) {
      // Guard the loop if its only external predecessor is a trivial empty block
      // (no hlsl_lines, unconditional branch). This pattern occurs when LLVM IR
      // has an explicit branch block between a conditional and the loop header:
      //   block 735: br i1 %cond, label %909, label %740
      //   block 740: br label %741  (trivial, empty)
      //   block 741: loop header
      // The loop must be guarded by __rc_740 to prevent execution when the
      // conditional skips it.
      bool loop_guarded = false;
      std::string loop_guard_var;

      if (region.loop_header >= 0) {
        std::vector<int> external_preds;
        for (const auto& edge : graph_edges) {
          if (edge.target != region.loop_header) continue;
          if (edge.type == GraphEdgeType::BackEdge) continue;
          if (region.blocks.contains(edge.source)) continue;
          external_preds.push_back(edge.source);
        }

        if (external_preds.size() == 1) {
          int pred = external_preds[0];
          if (current_code_function->code_blocks.contains(pred)) {
            const auto& pred_block = current_code_function->code_blocks.at(pred);
            // Guard if the predecessor is an unconditional branch to the loop header
            // AND the predecessor is conditionally reachable (has a predecessor with
            // a conditional branch). This prevents infinite loops when the loop
            // should be skipped.
            bool pred_is_unconditional_entry = pred_block.code_branch.branch_condition.empty();

            if (pred_is_unconditional_entry) {
              // Verify the predecessor is conditionally reachable
              bool pred_is_conditional = false;
              if (graph_nodes.contains(pred) && graph_nodes.at(pred).predecessors.size() >= 1) {
                for (int pp : graph_nodes.at(pred).predecessors) {
                  if (current_code_function->code_blocks.contains(pp)) {
                    const auto& pp_block = current_code_function->code_blocks.at(pp);
                    if (!pp_block.code_branch.branch_condition.empty()) {
                      pred_is_conditional = true;
                      break;
                    }
                  }
                }
              }

              if (pred_is_conditional) {
                std::string rc_var = std::format("__rc_{}", pred);
                if (emitted_bool_vars.contains(rc_var)) {
                  loop_guarded = true;
                  loop_guard_var = rc_var;
                }
              }
            }
          }
        }
      }

      // Extend the loop guard to cover subsequent regions that are ONLY reachable
      // from the guarded loop's exit path. This handles the pattern where:
      //   block A: br i1 %cond, label %convergence, label %loop_entry
      //   loop_entry → loop_header → ... → loop_exit → post_loop_block
      //   post_loop_block → ... → convergence
      // With inter-region RC propagation, subsequent regions automatically get
      // the correct RC from block_exit_rc. The extended region detection is no
      // longer needed — compute_reaching_conditions will look up the loop body
      // blocks' RCs and propagate the guard condition naturally.
      // However, we still need to record the loop guard predecessor's RC in
      // block_exit_rc so that subsequent regions can reference it.
      if (loop_guarded) {
        // Find the guard predecessor block and record its RC
        for (const auto& edge : graph_edges) {
          if (edge.target == region.loop_header && !region.blocks.contains(edge.source)) {
            if (edge.type != GraphEdgeType::BackEdge) {
              // The predecessor's RC is the loop_guard_var itself
              block_exit_rc[edge.source] = loop_guard_var;
            }
          }
        }
      }

      if (loop_guarded) {
        string_stream << spacing << "if (" << loop_guard_var << ") {\n";
        indent_spacing();
      }

      emit_loop_region(region);

      if (loop_guarded) {
        unindent_spacing();
        string_stream << spacing << "}\n";
      }
    }
  }

  // Requirement 11.5: Warn when condition variable count exceeds 1000
  {
    std::string output = string_stream.str();
    int cond_count = 0;
    size_t pos = 0;
    while ((pos = output.find("bool __cond_", pos)) != std::string::npos) {
      cond_count++;
      pos += 12;
    }
    pos = 0;
    while ((pos = output.find("bool __rc_", pos)) != std::string::npos) {
      cond_count++;
      pos += 10;
    }
    if (cond_count > 1000) {
      string_stream << spacing << "// [mermaid] WARNING: " << cond_count
                    << " condition variables emitted (exceeds 1000)\n";
    }
  }
}
