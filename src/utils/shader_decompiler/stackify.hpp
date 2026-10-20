// ===== STACKIFIER CODE GENERATION =====
// This file is #included inside the Decompiler::Decompile() method when
// decompile_options.stackify is true.
//
// Available in scope from the caller:
//   - current_code_function, string_stream, spacing, decompile_options
//   - indent_spacing(), unindent_spacing()
//   - ParseType(), ParseWrapped(), OptimizeString(), IsWrapped()
//   - convergences, recursions, ipdom, loop_bodies, dominators, predecessors
//   - declared_vars, preprocess_state
//
// This code path replaces the block iteration with a recursive if/else nesting
// approach using topological sort, scope markers, and phi_sel convergence.

{
      auto succs_fwd = current_code_function->ComputeSuccessors();
      // Remove back edges
      for (const auto& [header, sources] : recursions) {
        for (int src : sources) {
          succs_fwd[src].erase(header);
        }
      }

      // Compute forward predecessors (predecessors minus back edges)
      std::map<int, std::set<int>> preds_fwd;
      for (const auto& [blk, succ_set] : succs_fwd) {
        for (int s : succ_set) {
          preds_fwd[s].insert(blk);
        }
      }

      // Topological sort with loop body contiguity constraint.
      // After emitting a loop header, all blocks dominated by the header
      // (i.e., the loop body) must be emitted before any block outside the loop.
      std::vector<int> topo_order;
      std::set<int> visited;
      std::set<int> in_queue;

      // Priority: prefer blocks with single forward predecessor (for if/else nesting)
      // and prefer lower block numbers (original program order)
      std::function<void(int)> topo_visit = [&](int blk) {
        if (visited.contains(blk)) return;
        if (!current_code_function->code_blocks.contains(blk)) return;
        visited.insert(blk);

        // If this is a loop header, visit all loop body blocks first
        if (loop_bodies.contains(blk)) {
          const auto& body = loop_bodies.at(blk);
          // Collect body successors in order
          std::vector<int> body_blocks(body.begin(), body.end());
          std::ranges::sort(body_blocks);
          // Visit body blocks (they'll recursively visit their successors within the body)
          for (int bb : body_blocks) {
            if (bb != blk && !visited.contains(bb)) {
              topo_visit(bb);
            }
          }
        }

        topo_order.push_back(blk);

        // Visit forward successors
        if (succs_fwd.contains(blk)) {
          std::vector<int> succ_list(succs_fwd[blk].begin(), succs_fwd[blk].end());
          // Sort: prefer blocks with single predecessor (nestable), then by block number
          std::ranges::sort(succ_list, [&](int a, int b) {
            bool a_single = preds_fwd[a].size() == 1;
            bool b_single = preds_fwd[b].size() == 1;
            if (a_single != b_single) return a_single > b_single;
            return a < b;
          });
          for (int s : succ_list) {
            topo_visit(s);
          }
        }
      };

      topo_visit(0);

      // Build position map: block -> index in topo_order
      std::map<int, int> block_pos;
      for (int i = 0; i < static_cast<int>(topo_order.size()); ++i) {
        block_pos[topo_order[i]] = i;
      }

      // Compute scope events using a stack-based approach.
      // Each scope has an open position and a close-before position (the block AFTER the scope).
      // Scopes must nest properly — they can't interleave.

      struct Scope {
        enum Type { LOOP, BLOCK };
        Type type;
        int open_pos;       // position where scope opens
        int close_before;   // scope closes just before this position (target block for BLOCK, first-after-loop for LOOP)
        int id;             // loop header or target block number
      };

      std::vector<Scope> all_scopes;

      // Loop scopes: open at header, close before the first block after the loop body
      for (const auto& [header, sources] : recursions) {
        if (!block_pos.contains(header)) continue;
        int header_pos = block_pos[header];

        // Find the last body block position
        int last_body_pos = header_pos;
        if (loop_bodies.contains(header)) {
          for (int bb : loop_bodies.at(header)) {
            if (block_pos.contains(bb)) {
              last_body_pos = (std::max)(last_body_pos, block_pos[bb]);
            }
          }
        }
        for (int src : sources) {
          if (block_pos.contains(src)) {
            last_body_pos = (std::max)(last_body_pos, block_pos[src]);
          }
        }

        all_scopes.push_back({Scope::LOOP, header_pos, last_body_pos + 1, header});
      }

      // Block scopes: open at earliest source, close before the target block
      std::set<int> block_scope_targets;
      for (const auto& [blk, succ_set] : succs_fwd) {
        if (!block_pos.contains(blk)) continue;
        int src_pos = block_pos[blk];
        for (int dst : succ_set) {
          if (!block_pos.contains(dst)) continue;
          int dst_pos = block_pos[dst];
          if (dst_pos > src_pos + 1) {
            block_scope_targets.insert(dst);
          }
        }
      }

      for (int target : block_scope_targets) {
        if (!block_pos.contains(target)) continue;
        int target_pos = block_pos[target];

        // Find the earliest source that jumps to this target
        int earliest_src_pos = target_pos;
        for (const auto& [blk, succ_set] : succs_fwd) {
          if (succ_set.contains(target) && block_pos.contains(blk)) {
            earliest_src_pos = (std::min)(earliest_src_pos, block_pos[blk]);
          }
        }

        // The scope must open OUTSIDE any loop scope that doesn't contain the target.
        // For now, just open at the earliest source position.
        all_scopes.push_back({Scope::BLOCK, earliest_src_pos, target_pos, target});
      }

      // Sort scopes: outer scopes first (wider range), then by open position
      std::ranges::sort(all_scopes, [](const Scope& a, const Scope& b) {
        int a_range = a.close_before - a.open_pos;
        int b_range = b.close_before - b.open_pos;
        if (a.open_pos != b.open_pos) return a.open_pos < b.open_pos;
        return a_range > b_range;  // wider scope first (opens first)
      });

      // Build open/close event lists per position
      // Opens happen BEFORE the block at that position
      // Closes happen BEFORE the block at close_before position
      std::map<int, std::vector<int>> opens_at;   // pos -> indices into all_scopes
      std::map<int, std::vector<int>> closes_at;  // pos -> indices into all_scopes
      for (int i = 0; i < static_cast<int>(all_scopes.size()); ++i) {
        opens_at[all_scopes[i].open_pos].push_back(i);
        closes_at[all_scopes[i].close_before].push_back(i);
      }

      // Track active scopes as a stack for proper nesting
      std::vector<int> scope_stack;  // indices into all_scopes
      std::vector<int> active_loops;

      // Pre-scan: hoist heap resource declarations to function scope.
      // Heap resources (ResourceDescriptorHeap[...]) are declared inside specific blocks
      // but may be used in blocks outside that scope. Hoist them to function scope.
      {
        static const std::regex heap_decl_re(R"(^(ByteAddressBuffer|RWByteAddressBuffer|Texture2D<[^>]+>|Texture3D<[^>]+>|TextureCube<[^>]+>|RaytracingAccelerationStructure)\s+(_HeapResource_\d+)\s*=\s*ResourceDescriptorHeap)");
        std::set<std::string> hoisted_heap_vars;
        for (const auto& [blk_num, cb] : current_code_function->code_blocks) {
          for (const auto& line : cb.hlsl_lines) {
            std::smatch m;
            if (std::regex_search(line, m, heap_decl_re)) {
              std::string var_name = m[2].str();
              if (!hoisted_heap_vars.contains(var_name)) {
                // Emit the full declaration at function scope
                string_stream << spacing << line << "\n";
                hoisted_heap_vars.insert(var_name);
              }
            }
          }
        }
      }

      // ===== EMIT BLOCKS (Recursive with if/else nesting) =====
      // Instead of linear emission with do{}while(false) + break,
      // recursively nest blocks inside their parent's if/else branches.
      // A block with a single forward predecessor is nested inline.
      // This produces native if/else without break statements.

      std::set<int> emitted_blocks;

      // Check if a block is a back-edge target (loop continue)
      auto is_back_edge = [&](int src, int dst) -> bool {
        for (const auto& [header, sources] : recursions) {
          if (dst == header && sources.contains(src)) return true;
        }
        return false;
      };

      // Compute the immediate post-dominator (convergence point) for a block
      auto get_ipdom = [&](int blk) -> int {
        if (ipdom.contains(blk)) return ipdom.at(blk);
        return -1;
      };

      // Emit a single block's HLSL lines (no control flow)
      auto emit_block_body = [&](int blk) {
        auto& cb = current_code_function->code_blocks[blk];
        // Phi declarations
        for (const auto& [variable, type, value, predecessor, code_function, is_assign] : cb.phi_lines) {
          if (is_assign) continue;
          auto var_name = std::format("_{}", variable);
          if (declared_vars.contains(var_name)) continue;
          string_stream << spacing << ParseType(type) << " " << var_name << ";\n";
        }
        // HLSL lines
        for (const auto& hlsl_line : cb.hlsl_lines) {
          if (hlsl_line.find("ResourceDescriptorHeap") != std::string::npos
              && hlsl_line.find("_HeapResource_") != std::string::npos) {
            continue;
          }
          std::string final_line = hlsl_line;
          static const std::regex decl_re(R"(^(float4|float3|float2|float|int64_t|uint64_t|int16_t|uint16_t|int|uint|bool|uint4|int4|int2|uint2|int3|uint3|double|half|min16float|min16int|min16uint)\s+(_\d+)\s*=)");
          static const std::regex decl_noassign_re(R"(^(float4|float3|float2|float|int64_t|uint64_t|int16_t|uint16_t|int|uint|bool|uint4|int4|int2|uint2|int3|uint3|double|half|min16float|min16int|min16uint)\s+(_\d+)\s*;)");
          std::smatch m;
          if (std::regex_search(final_line, m, decl_re)) {
            std::string var_name = m[2].str();
            if (declared_vars.contains(var_name)) {
              final_line = var_name + " =" + m.suffix().str();
            }
          } else if (std::regex_search(final_line, m, decl_noassign_re)) {
            std::string var_name = m[2].str();
            if (declared_vars.contains(var_name)) {
              // Strip "type _N;" and emit only the remainder (e.g., GetDimensions call)
              std::string remainder = m.suffix().str();
              size_t start = remainder.find_first_not_of(" \t");
              if (start != std::string::npos) {
                final_line = remainder.substr(start);
              } else {
                continue;  // Nothing left after stripping — skip entirely
              }
            }
          }
          string_stream << spacing << final_line << "\n";
        }
      };

      // Pre-initialize phi variables for a convergence block.
      // Before an if/else with convergence, emit default values for all phi variables
      // of the convergence block. This ensures variables are always defined on all paths,
      // preventing DXC from eliminating code as undefined behavior.
      auto emit_phi_pre_init = [&](int convergence_blk, int from_blk) {
        if (convergence_blk < 0 || from_blk < 0) return;
        if (!current_code_function->code_blocks.contains(from_blk)) return;
        auto& from_cb = current_code_function->code_blocks[from_blk];
        auto phi_defaults = current_code_function->ComputePhiAssignments(&from_cb, convergence_blk);
        for (const auto& pl : phi_defaults) {
          string_stream << spacing << pl << "\n";
        }
      };

      // Compute immediate dominators for branch exclusivity analysis
      auto idom = current_code_function->ComputeDominators();

      // Phi selector state: when phi_sel_var is non-empty, emit_region
      // sets a selector variable instead of emitting phi assignments when
      // reaching stop_at. This creates multi-way convergence via switch,
      // preserving 3+ input phi structure that prevents optimizer exploitation.
      std::string phi_sel_var;
      int phi_sel_next_value = 0;
      std::map<int, int> phi_sel_pred_map;  // selector_value -> predecessor_block
      int phi_sel_counter = 0;
      int phi_sel_convergence = -1;  // The convergence block this phi_sel targets

      // Helper: emit phi_sel assignment instead of phi assignments
      auto emit_phi_sel_assign = [&](int pred_block) {
        int val = phi_sel_next_value++;
        phi_sel_pred_map[val] = pred_block;
        string_stream << spacing << phi_sel_var << " = " << val << "u;\n";
      };

      // Count unique phi predecessors for a convergence block
      auto count_phi_predecessors = [&](int convergence_blk) -> int {
        std::set<int> preds;
        for (const auto& [cb_num, cb] : current_code_function->code_blocks) {
          for (const auto& [variable, type, value, predecessor, code_function, is_assign] : cb.phi_lines) {
            if (code_function == convergence_blk && is_assign) {
              preds.insert(cb_num);
            }
          }
        }
        return static_cast<int>(preds.size());
      };

      // Compute blocks reachable from `start` up to (not including) `stop_at`,
      // following only forward edges (back edges already removed from succs_fwd).
      auto reachable_from = [&](int start, int stop_at) -> std::set<int> {
        std::set<int> visited;
        std::deque<int> queue;
        queue.push_back(start);
        while (!queue.empty()) {
          int b = queue.front();
          queue.pop_front();
          if (b == stop_at || visited.contains(b)) continue;
          if (!current_code_function->code_blocks.contains(b)) continue;
          visited.insert(b);
          if (succs_fwd.contains(b)) {
            for (int s : succs_fwd.at(b)) {
              queue.push_back(s);
            }
          }
        }
        return visited;
      };

      // Compute shared blocks between two branches up to a convergence point.
      // Returns blocks reachable from BOTH branch targets that are not
      // exclusively dominated by either target.
      auto compute_shared_blocks = [&](int true_target, int false_target, int convergence) -> std::set<int> {
        if (convergence < 0) return {};
        if (true_target == convergence || false_target == convergence) return {};
        auto true_reach = reachable_from(true_target, convergence);
        auto false_reach = reachable_from(false_target, convergence);
        std::set<int> shared;
        for (int b : true_reach) {
          if (false_reach.contains(b)) {
            shared.insert(b);
          }
        }
        return shared;
      };

      // Check if a region from `start` to `stop_at` contains any back-edges
      // (blocks that branch back to a loop header). If so, wrapping in
      // do{}while(false) would intercept `continue` statements.
      auto region_has_back_edges = [&](int start, int stop_at) -> bool {
        auto reach = reachable_from(start, stop_at);
        for (int b : reach) {
          if (!current_code_function->code_blocks.contains(b)) continue;
          auto& cb = current_code_function->code_blocks[b];
          for (int target : {cb.code_branch.branch_condition_true, cb.code_branch.branch_condition_false}) {
            if (target <= 0) continue;
            if (is_back_edge(b, target)) return true;
          }
        }
        return false;
      };

      // When true, convergence wrapping uses boolean flags instead of do-while
      // to avoid intercepting continue/break from inner loops.
      bool suppress_dowhile = false;
      // Prevent nested deferred convergence flags (which cause exponential growth)
      bool inside_deferred_conv = false;

      // Deferred latch: when set, emit_region will set a flag instead of
      // emitting this block, deferring it to the loop body level.
      int deferred_latch_block = -1;
      std::string deferred_latch_flag_name;

      // Track do-while nesting depth for continue/break propagation.
      // When inside a do-while scope within a loop, `continue` targets the
      // do-while instead of the enclosing while(true). We use a flag to
      // propagate the continue through the do-while scope.
      int stackify_dowhile_depth = 0;
      int stackify_loop_continue_counter = 0;
      // Stack of (continue_flag_name, break_flag_name) for nested loops
      std::vector<std::pair<std::string, std::string>> stackify_loop_flags;

      // Recursive block emission.
      std::function<void(int blk, int stop_at, bool in_loop, int loop_exit_blk)> emit_region;

      // Helper: emit a `continue` statement. If inside a do-while scope,
      // use flag-based propagation to escape the do-while first.
      auto emit_continue = [&]() {
        if (stackify_dowhile_depth > 0 && !stackify_loop_flags.empty()) {
          auto& [cf, bf] = stackify_loop_flags.back();
          string_stream << spacing << cf << " = true;\n";
          string_stream << spacing << "break;\n";
        } else {
          string_stream << spacing << "continue;\n";
        }
      };

      auto emit_loop_break = [&]() {
        // break always targets the innermost loop/do-while scope.
        // Inside a do-while, break exits the do-while (correct behavior).
        // We don't need flag propagation for break.
        string_stream << spacing << "break;\n";
      };

      auto open_dowhile = [&]() {
        string_stream << spacing << "do {\n";
        indent_spacing();
        stackify_dowhile_depth++;
      };

      auto close_dowhile = [&]() {
        stackify_dowhile_depth--;
        unindent_spacing();
        string_stream << spacing << "} while(false);\n";
        // Only emit flag checks if we're back at loop body level
        // and the do-while actually contained back-edges or loop exits
        // (indicated by stackify_dowhile_depth returning to 0)
        // Note: we always emit the checks because we can't easily track
        // whether flags were set inside the do-while. The flags are
        // initialized to false, so the checks are no-ops when not set.
        if (stackify_dowhile_depth == 0 && !stackify_loop_flags.empty()) {
          auto& [cf, bf] = stackify_loop_flags.back();
          string_stream << spacing << "if (" << cf << ") { " << cf << " = false; continue; }\n";
        }
      };

      emit_region = [&](int blk, int stop_at, bool in_loop, int loop_exit_blk) {
        while (blk >= 0 && blk != stop_at) {
          if (emitted_blocks.contains(blk)) {
            // When phi_sel is active, re-emit the chain from this block to
            // the convergence. This ensures the correct selector is set even
            // when blocks are shared between branches.
            if (!phi_sel_var.empty() && phi_sel_convergence >= 0) {
              // Collect blocks reachable from blk to convergence
              std::set<int> to_reemit;
              std::deque<int> rq;
              rq.push_back(blk);
              while (!rq.empty()) {
                int u = rq.front(); rq.pop_front();
                if (u == phi_sel_convergence || to_reemit.contains(u)) continue;
                if (!current_code_function->code_blocks.contains(u)) continue;
                to_reemit.insert(u);
                auto& ucb = current_code_function->code_blocks[u];
                if (ucb.code_branch.branch_condition_true > 0) rq.push_back(ucb.code_branch.branch_condition_true);
                if (ucb.code_branch.branch_condition_false > 0) rq.push_back(ucb.code_branch.branch_condition_false);
              }
              // Temporarily un-mark these blocks
              for (int u : to_reemit) emitted_blocks.erase(u);
              // Re-emit — this will process the chain and set phi_sel correctly
              emit_region(blk, stop_at, in_loop, loop_exit_blk);
              // Re-mark all blocks
              for (int u : to_reemit) emitted_blocks.insert(u);
              return;
            }
            return;
          }
          if (!current_code_function->code_blocks.contains(blk)) return;
          // Check if this is the deferred latch block
          if (blk == deferred_latch_block && deferred_latch_block >= 0) {
            // Set the flag instead of emitting the block
            string_stream << spacing << deferred_latch_flag_name << " = true;\n";
            // Don't mark as emitted — it will be emitted later at loop body level
            return;
          }
          emitted_blocks.insert(blk);

          auto& cb = current_code_function->code_blocks[blk];

          // Check if this is a loop header
          bool is_loop = recursions.contains(blk);
          int loop_exit = -1;
          if (is_loop) {
            // Find the loop exit block (ipdom of the loop, or the block after the loop body)
            loop_exit = get_ipdom(blk);
            // If ipdom is inside the loop body, look for the exit differently
            if (loop_bodies.contains(blk) && loop_exit >= 0) {
              const auto& body = loop_bodies.at(blk);
              if (body.contains(loop_exit)) {
                // ipdom is inside the loop — find the actual exit
                // Strategy 1: ipdom of the latch block
                bool found_exit = false;
                for (int src : recursions.at(blk)) {
                  int latch_ipdom = get_ipdom(src);
                  if (latch_ipdom >= 0 && !body.contains(latch_ipdom)) {
                    loop_exit = latch_ipdom;
                    found_exit = true;
                    break;
                  }
                }
                // Strategy 2: find the unique exit target from loop body blocks.
                // Only use if there's exactly one exit target (unambiguous).
                if (!found_exit) {
                  std::set<int> exit_targets;
                  for (int bb : body) {
                    if (!current_code_function->code_blocks.contains(bb)) continue;
                    auto& bcb = current_code_function->code_blocks[bb];
                    for (int target : {bcb.code_branch.branch_condition_true, bcb.code_branch.branch_condition_false}) {
                      if (target > 0 && !body.contains(target) && !is_back_edge(bb, target)) {
                        exit_targets.insert(target);
                      }
                    }
                  }
                  if (exit_targets.size() == 1) {
                    loop_exit = *exit_targets.begin();
                  }
                }
              }
            }

            auto loop_flag_id = stackify_loop_continue_counter++;
            auto loop_continue_flag = std::format("__loop_continue_{}", loop_flag_id);
            auto loop_break_flag = std::format("__loop_break_{}", loop_flag_id);
            string_stream << spacing << "bool " << loop_continue_flag << " = false;\n";
            string_stream << spacing << "bool " << loop_break_flag << " = false;\n";
            stackify_loop_flags.push_back({loop_continue_flag, loop_break_flag});
            string_stream << spacing << "while(true) {\n";
            indent_spacing();
            // Emit the header block's body inside the loop
            emit_block_body(blk);
            // Now handle the header's branches — they're the loop body
            // The header is already marked as emitted, so recursive calls won't re-enter it
            auto& loop_cb = current_code_function->code_blocks[blk];
            if (!loop_cb.code_branch.branch_condition.empty()) {
              int lt = loop_cb.code_branch.branch_condition_true;
              int lf = loop_cb.code_branch.branch_condition_false;
              auto lcond = loop_cb.code_branch.branch_condition;
              auto lt_phis = current_code_function->ComputePhiAssignments(&loop_cb, lt);
              auto lf_phis = current_code_function->ComputePhiAssignments(&loop_cb, lf);
              bool lt_back = is_back_edge(blk, lt);
              bool lf_back = is_back_edge(blk, lf);
              bool lt_exit = (lt == loop_exit);
              bool lf_exit = (lf == loop_exit);
              int loop_convergence = get_ipdom(blk);
              // If convergence is outside the loop, use loop_exit as convergence
              if (loop_bodies.contains(blk) && loop_convergence >= 0 && !loop_bodies.at(blk).contains(loop_convergence)) {
                loop_convergence = loop_exit;
              }

              if (lt_back && lf_back) {
                for (const auto& pl : lt_phis) string_stream << spacing << pl << "\n";
                string_stream << spacing << "continue;\n";
              } else if (lt_exit && lf_exit) {
                for (const auto& pl : lt_phis) string_stream << spacing << pl << "\n";
                string_stream << spacing << "break;\n";
              } else if (lt_back) {
                string_stream << spacing << "if (" << lcond << ") {\n";
                indent_spacing();
                for (const auto& pl : lt_phis) string_stream << spacing << pl << "\n";
                string_stream << spacing << "continue;\n";
                unindent_spacing();
                string_stream << spacing << "}\n";
                for (const auto& pl : lf_phis) string_stream << spacing << pl << "\n";
                emit_region(lf, loop_exit, true, loop_exit);
              } else if (lf_back) {
                string_stream << spacing << "if (!(" << lcond << ")) {\n";
                indent_spacing();
                for (const auto& pl : lf_phis) string_stream << spacing << pl << "\n";
                string_stream << spacing << "continue;\n";
                unindent_spacing();
                string_stream << spacing << "}\n";
                for (const auto& pl : lt_phis) string_stream << spacing << pl << "\n";
                emit_region(lt, loop_exit, true, loop_exit);
              } else if (lt_exit) {
                string_stream << spacing << "if (" << lcond << ") {\n";
                indent_spacing();
                for (const auto& pl : lt_phis) string_stream << spacing << pl << "\n";
                string_stream << spacing << "break;\n";
                unindent_spacing();
                string_stream << spacing << "}\n";
                for (const auto& pl : lf_phis) string_stream << spacing << pl << "\n";
                emit_region(lf, loop_exit, true, loop_exit);
              } else if (lf_exit) {
                string_stream << spacing << "if (!(" << lcond << ")) {\n";
                indent_spacing();
                for (const auto& pl : lf_phis) string_stream << spacing << pl << "\n";
                string_stream << spacing << "break;\n";
                unindent_spacing();
                string_stream << spacing << "}\n";
                for (const auto& pl : lt_phis) string_stream << spacing << pl << "\n";
                emit_region(lt, loop_exit, true, loop_exit);
              } else if (loop_convergence >= 0 && lt == loop_convergence) {
                for (const auto& pl : lt_phis) string_stream << spacing << pl << "\n";
                emit_phi_pre_init(loop_convergence, blk);
                open_dowhile();
                string_stream << spacing << "if (!(" << lcond << ")) {\n";
                indent_spacing();
                for (const auto& pl : lf_phis) string_stream << spacing << pl << "\n";
                emit_region(lf, loop_convergence, true, loop_exit);
                unindent_spacing();
                string_stream << spacing << "}\n";
                close_dowhile();
                emit_region(loop_convergence, loop_exit, true, loop_exit);
              } else if (loop_convergence >= 0 && lf == loop_convergence) {
                for (const auto& pl : lf_phis) string_stream << spacing << pl << "\n";
                emit_phi_pre_init(loop_convergence, blk);
                open_dowhile();
                string_stream << spacing << "if (" << lcond << ") {\n";
                indent_spacing();
                for (const auto& pl : lt_phis) string_stream << spacing << pl << "\n";
                emit_region(lt, loop_convergence, true, loop_exit);
                unindent_spacing();
                string_stream << spacing << "}\n";
                close_dowhile();
                emit_region(loop_convergence, loop_exit, true, loop_exit);
              } else if (loop_convergence >= 0) {
                // Both branches diverge inside loop
                emit_phi_pre_init(loop_convergence, lt);
                // Find multi-predecessor blocks that lead to the back-edge source.
                // These are convergence points that should be deferred to the
                // loop body level to avoid do-while scope interception.
                // Only apply when the back-edge source is also a direct branch
                // target of the loop header (meaning it's shared between branches).
                int back_edge_src = -1;
                for (int src : recursions.at(blk)) {
                  back_edge_src = src;
                }
                int latch_conv = -1;
                if (back_edge_src >= 0 && (back_edge_src == lt || back_edge_src == lf)) {
                  // The back-edge source is a direct target of the loop header.
                  // Find blocks that unconditionally branch to it and have
                  // multiple predecessors (convergence points).
                  auto pm = current_code_function->ComputePredecessors();
                  for (const auto& [pb, pi] : current_code_function->code_blocks) {
                    if (pi.code_branch.branch_condition.empty() &&
                        pi.code_branch.branch_condition_true == back_edge_src &&
                        pb != blk && pm.contains(pb) && pm.at(pb).size() > 1) {
                      latch_conv = pb;
                      break;
                    }
                  }
                }
                // Set up deferred latch if found
                int saved_deferred = deferred_latch_block;
                std::string saved_flag = deferred_latch_flag_name;
                if (latch_conv >= 0) {
                  deferred_latch_block = latch_conv;
                  deferred_latch_flag_name = std::format("__defer_latch_{}", blk);
                  string_stream << spacing << "bool " << deferred_latch_flag_name << " = false;\n";
                }
                open_dowhile();
                string_stream << spacing << "if (" << lcond << ") {\n";
                indent_spacing();
                for (const auto& pl : lt_phis) string_stream << spacing << pl << "\n";
                emit_region(lt, loop_convergence, true, loop_exit);
                unindent_spacing();
                string_stream << spacing << "} else {\n";
                indent_spacing();
                for (const auto& pl : lf_phis) string_stream << spacing << pl << "\n";
                emit_region(lf, loop_convergence, true, loop_exit);
                unindent_spacing();
                string_stream << spacing << "}\n";
                close_dowhile();
                // Emit deferred latch at loop body level
                if (latch_conv >= 0) {
                  deferred_latch_block = saved_deferred;
                  deferred_latch_flag_name = saved_flag;
                  string_stream << spacing << "if (" << std::format("__defer_latch_{}", blk) << ") {\n";
                  indent_spacing();
                  emit_region(latch_conv, loop_exit, true, loop_exit);
                  // The deferred latch block may branch to an already-emitted
                  // back-edge source block. Re-emit that block's body so the
                  // Proceed() call and continue/break are not lost.
                  if (current_code_function->code_blocks.contains(latch_conv)) {
                    auto& latch_cb = current_code_function->code_blocks[latch_conv];
                    int latch_next = latch_cb.code_branch.branch_condition_true;
                    if (latch_next > 0 && latch_cb.code_branch.branch_condition.empty()
                        && emitted_blocks.contains(latch_next)
                        && current_code_function->code_blocks.contains(latch_next)) {
                      // Re-emit the back-edge source block
                      auto& be_cb = current_code_function->code_blocks[latch_next];
                      // Emit phi assignments from latch to back-edge source
                      auto be_phis = current_code_function->ComputePhiAssignments(&latch_cb, latch_next);
                      for (const auto& pl : be_phis) string_stream << spacing << pl << "\n";
                      // Emit the block body
                      emit_block_body(latch_next);
                      // Handle the branch (should be continue or conditional continue/break)
                      if (!be_cb.code_branch.branch_condition.empty()) {
                        int be_bt = be_cb.code_branch.branch_condition_true;
                        int be_bf = be_cb.code_branch.branch_condition_false;
                        auto be_cond = be_cb.code_branch.branch_condition;
                        bool be_bt_back = is_back_edge(latch_next, be_bt);
                        bool be_bf_back = is_back_edge(latch_next, be_bf);
                        auto be_bt_phis = current_code_function->ComputePhiAssignments(&be_cb, be_bt);
                        auto be_bf_phis = current_code_function->ComputePhiAssignments(&be_cb, be_bf);
                        if (be_bt_back) {
                          string_stream << spacing << "if (" << be_cond << ") {\n";
                          indent_spacing();
                          for (const auto& pl : be_bt_phis) string_stream << spacing << pl << "\n";
                          string_stream << spacing << "continue;\n";
                          unindent_spacing();
                          string_stream << spacing << "}\n";
                          for (const auto& pl : be_bf_phis) string_stream << spacing << pl << "\n";
                        } else if (be_bf_back) {
                          string_stream << spacing << "if (!(" << be_cond << ")) {\n";
                          indent_spacing();
                          for (const auto& pl : be_bf_phis) string_stream << spacing << pl << "\n";
                          string_stream << spacing << "continue;\n";
                          unindent_spacing();
                          string_stream << spacing << "}\n";
                          for (const auto& pl : be_bt_phis) string_stream << spacing << pl << "\n";
                        }
                      } else if (be_cb.code_branch.branch_condition_true > 0) {
                        int be_target = be_cb.code_branch.branch_condition_true;
                        auto be_phis2 = current_code_function->ComputePhiAssignments(&be_cb, be_target);
                        for (const auto& pl : be_phis2) string_stream << spacing << pl << "\n";
                        if (is_back_edge(latch_next, be_target)) {
                          string_stream << spacing << "continue;\n";
                        }
                      }
                    }
                  }
                  unindent_spacing();
                  string_stream << spacing << "}\n";
                } else {
                  deferred_latch_block = saved_deferred;
                  deferred_latch_flag_name = saved_flag;
                }
                emit_region(loop_convergence, loop_exit, true, loop_exit);
              } else {
                // No convergence inside loop — emit if/else
                string_stream << spacing << "if (" << lcond << ") {\n";
                indent_spacing();
                for (const auto& pl : lt_phis) string_stream << spacing << pl << "\n";
                emit_region(lt, loop_exit, true, loop_exit);
                unindent_spacing();
                string_stream << spacing << "} else {\n";
                indent_spacing();
                for (const auto& pl : lf_phis) string_stream << spacing << pl << "\n";
                emit_region(lf, loop_exit, true, loop_exit);
                unindent_spacing();
                string_stream << spacing << "}\n";
              }
            } else if (loop_cb.code_branch.branch_condition_true > 0) {
              int target = loop_cb.code_branch.branch_condition_true;
              auto phi_lines = current_code_function->ComputePhiAssignments(&loop_cb, target);
              for (const auto& pl : phi_lines) string_stream << spacing << pl << "\n";
              if (is_back_edge(blk, target)) {
                string_stream << spacing << "continue;\n";
              } else if (target == loop_exit) {
                string_stream << spacing << "break;\n";
              } else {
                emit_region(target, loop_exit, true, loop_exit);
              }
            }
            unindent_spacing();
            string_stream << spacing << "}\n";
            if (!stackify_loop_flags.empty()) stackify_loop_flags.pop_back();
            // Continue with the exit block
            blk = loop_exit;
            continue;
          }

          emit_block_body(blk);

          // Handle switch
          if (!cb.code_switch.switch_condition.empty()) {
            string_stream << spacing << "switch (" << cb.code_switch.switch_condition << ") {\n";
            indent_spacing();
            int switch_ipdom = get_ipdom(blk);
            for (const auto& [case_value, case_target] : cb.code_switch.case_values) {
              string_stream << spacing << "case " << case_value << ": {\n";
              indent_spacing();
              auto phi_lines = current_code_function->ComputePhiAssignments(&cb, case_target);
              for (const auto& pl : phi_lines) string_stream << spacing << pl << "\n";
              if (case_target != switch_ipdom && !emitted_blocks.contains(case_target)) {
                emit_region(case_target, switch_ipdom, false, -1);
              }
              string_stream << spacing << "break;\n";
              unindent_spacing();
              string_stream << spacing << "}\n";
            }
            string_stream << spacing << "default: {\n";
            indent_spacing();
            auto default_phis = current_code_function->ComputePhiAssignments(&cb, cb.code_switch.case_default);
            for (const auto& pl : default_phis) string_stream << spacing << pl << "\n";
            if (cb.code_switch.case_default != switch_ipdom && !emitted_blocks.contains(cb.code_switch.case_default)) {
              emit_region(cb.code_switch.case_default, switch_ipdom, false, -1);
            }
            string_stream << spacing << "break;\n";
            unindent_spacing();
            string_stream << spacing << "}\n";
            unindent_spacing();
            string_stream << spacing << "}\n";
            // Continue with the convergence point
            blk = switch_ipdom;
            continue;
          }

          // Handle conditional branch
          if (!cb.code_branch.branch_condition.empty()) {
            int true_target = cb.code_branch.branch_condition_true;
            int false_target = cb.code_branch.branch_condition_false;
            auto cond = cb.code_branch.branch_condition;
            int convergence = get_ipdom(blk);

            // Emit phi assignments as part of the branch
            auto true_phis = current_code_function->ComputePhiAssignments(&cb, true_target);
            auto false_phis = current_code_function->ComputePhiAssignments(&cb, false_target);

            bool true_is_back = is_back_edge(blk, true_target);
            bool false_is_back = is_back_edge(blk, false_target);
            bool true_is_exit = (true_target == stop_at) || (in_loop && true_target == loop_exit_blk);
            bool false_is_exit = (false_target == stop_at) || (in_loop && false_target == loop_exit_blk);
            // Distinguish between do-while exit (stop_at) and loop exit (loop_exit_blk)
            // Only use flag-based break for actual loop exits, not do-while exits
            // When stop_at == loop_exit_blk, the target is a convergence exit, not a loop exit
            bool true_is_loop_exit = (in_loop && true_target == loop_exit_blk && true_target != stop_at);
            bool false_is_loop_exit = (in_loop && false_target == loop_exit_blk && false_target != stop_at);

            if (true_is_exit && false_is_exit) {
              for (const auto& pl : true_phis) string_stream << spacing << pl << "\n";
              if (true_is_loop_exit || false_is_loop_exit) emit_loop_break();
              else if (in_loop) string_stream << spacing << "break;\n";
              return;
            } else if (true_is_back && false_is_exit) {
              string_stream << spacing << "if (" << cond << ") {\n";
              indent_spacing();
              for (const auto& pl : true_phis) string_stream << spacing << pl << "\n";
              emit_continue();
              unindent_spacing();
              string_stream << spacing << "}\n";
              for (const auto& pl : false_phis) string_stream << spacing << pl << "\n";
              if (false_is_loop_exit) emit_loop_break();
              else if (in_loop) string_stream << spacing << "break;\n";
              return;
            } else if (false_is_back && true_is_exit) {
              string_stream << spacing << "if (!(" << cond << ")) {\n";
              indent_spacing();
              for (const auto& pl : false_phis) string_stream << spacing << pl << "\n";
              emit_continue();
              unindent_spacing();
              string_stream << spacing << "}\n";
              for (const auto& pl : true_phis) string_stream << spacing << pl << "\n";
              if (true_is_loop_exit) emit_loop_break();
              else if (in_loop) string_stream << spacing << "break;\n";
              return;
            } else if (true_is_back && false_is_back) {
              for (const auto& pl : true_phis) string_stream << spacing << pl << "\n";
              if (in_loop) emit_continue();
              return;
            } else if (true_is_back) {
              string_stream << spacing << "if (" << cond << ") {\n";
              indent_spacing();
              for (const auto& pl : true_phis) string_stream << spacing << pl << "\n";
              if (in_loop) emit_continue();
              unindent_spacing();
              string_stream << spacing << "}\n";
              for (const auto& pl : false_phis) string_stream << spacing << pl << "\n";
              blk = false_target;
              continue;
            } else if (false_is_back) {
              // False branch is continue, true branch continues forward
              string_stream << spacing << "if (!(" << cond << ")) {\n";
              indent_spacing();
              for (const auto& pl : false_phis) string_stream << spacing << pl << "\n";
              if (in_loop) emit_continue();
              unindent_spacing();
              string_stream << spacing << "}\n";
              for (const auto& pl : true_phis) string_stream << spacing << pl << "\n";
              blk = true_target;
              continue;
            } else if (true_is_exit) {
              // Phi selector mode: set selector for the exit path
              if (!phi_sel_var.empty() && true_target == phi_sel_convergence) {
                string_stream << spacing << "if (" << cond << ") {\n";
                indent_spacing();
                emit_phi_sel_assign(blk);
                string_stream << spacing << "break;\n";
                unindent_spacing();
                string_stream << spacing << "}\n";
                for (const auto& pl : false_phis) string_stream << spacing << pl << "\n";
                blk = false_target;
                continue;
              }
              // Emit BOTH true_phis and false_phis as defaults.
              for (const auto& pl : false_phis) string_stream << spacing << pl << "\n";
              for (const auto& pl : true_phis) string_stream << spacing << pl << "\n";
              string_stream << spacing << "if (" << cond << ") {\n";
              indent_spacing();
              if (true_is_loop_exit) emit_loop_break();
              else if (in_loop) string_stream << spacing << "break;\n";
              unindent_spacing();
              string_stream << spacing << "}\n";
              blk = false_target;
              continue;
            } else if (false_is_exit) {
              // Phi selector mode: set selector for the exit path
              if (!phi_sel_var.empty() && false_target == phi_sel_convergence) {
                string_stream << spacing << "if (!(" << cond << ")) {\n";
                indent_spacing();
                emit_phi_sel_assign(blk);
                string_stream << spacing << "break;\n";
                unindent_spacing();
                string_stream << spacing << "}\n";
                for (const auto& pl : true_phis) string_stream << spacing << pl << "\n";
                blk = true_target;
                continue;
              }
              for (const auto& pl : false_phis) string_stream << spacing << pl << "\n";
              string_stream << spacing << "if (!(" << cond << ")) {\n";
              indent_spacing();
              if (false_is_loop_exit) emit_loop_break();
              else if (in_loop) string_stream << spacing << "break;\n";
              unindent_spacing();
              string_stream << spacing << "}\n";
              for (const auto& pl : true_phis) string_stream << spacing << pl << "\n";
              blk = true_target;
              continue;
            } else if (true_target == convergence) {
              // Check if convergence has 3+ phi predecessors — use phi_sel
              int conv_preds = count_phi_predecessors(convergence);
              if (conv_preds >= 3 && phi_sel_var.empty() && !in_loop) {
                // Enable phi_sel mode for the false branch
                auto sel_name = std::format("__phi_sel_{}", phi_sel_counter++);
                string_stream << spacing << "uint " << sel_name << " = 0u;\n";
                auto saved_sel = phi_sel_var;
                auto saved_next = phi_sel_next_value;
                auto saved_map = phi_sel_pred_map;
                auto saved_conv = phi_sel_convergence;
                phi_sel_var = sel_name;
                phi_sel_convergence = convergence;
                phi_sel_next_value = 1;  // 0 = true path (blk -> convergence)
                phi_sel_pred_map.clear();
                phi_sel_pred_map[0] = blk;  // selector 0 = current block
                // Emit false branch with phi_sel active
                string_stream << spacing << "do {\n";
                indent_spacing();
                string_stream << spacing << "if (!(" << cond << ")) {\n";
                indent_spacing();
                for (const auto& pl : false_phis) string_stream << spacing << pl << "\n";
                emit_region(false_target, convergence, in_loop, loop_exit_blk);
                unindent_spacing();
                string_stream << spacing << "}\n";
                unindent_spacing();
                string_stream << spacing << "} while(false);\n";
                // Collect results
                auto sel_map = phi_sel_pred_map;
                phi_sel_var = saved_sel;
                phi_sel_next_value = saved_next;
                phi_sel_pred_map = saved_map;
                phi_sel_convergence = saved_conv;
                // Emit switch with one case per predecessor
                string_stream << spacing << "switch (" << sel_name << ") {\n";
                for (const auto& [sv, pred] : sel_map) {
                  string_stream << spacing << "case " << sv << "u:\n";
                  indent_spacing();
                  if (current_code_function->code_blocks.contains(pred)) {
                    auto pred_phis = current_code_function->ComputePhiAssignments(
                        &current_code_function->code_blocks[pred], convergence);
                    for (const auto& pl : pred_phis) string_stream << spacing << pl << "\n";
                  }
                  string_stream << spacing << "break;\n";
                  unindent_spacing();
                }
                string_stream << spacing << "default: break;\n";
                string_stream << spacing << "}\n";
                blk = convergence;
                continue;
              }
              for (const auto& pl : true_phis) string_stream << spacing << pl << "\n";
              emit_phi_pre_init(convergence, blk);
              bool needs_flags = in_loop && region_has_back_edges(false_target, convergence);
              if (needs_flags) { open_dowhile(); } else { string_stream << spacing << "do {\n"; indent_spacing(); }
              string_stream << spacing << "if (!(" << cond << ")) {\n";
              indent_spacing();
              for (const auto& pl : false_phis) string_stream << spacing << pl << "\n";
              emit_region(false_target, convergence, in_loop, loop_exit_blk);
              unindent_spacing();
              string_stream << spacing << "}\n";
              if (needs_flags) { close_dowhile(); } else { unindent_spacing(); string_stream << spacing << "} while(false);\n"; }
              blk = convergence;
              continue;
            } else if (false_target == convergence) {
              for (const auto& pl : false_phis) string_stream << spacing << pl << "\n";
              emit_phi_pre_init(convergence, blk);
              bool has_inner_loop = false;
              {
                auto reach = reachable_from(true_target, convergence);
                for (int b : reach) {
                  if (recursions.contains(b)) { has_inner_loop = true; break; }
                }
              }
              {
              bool needs_flags_ft = in_loop && region_has_back_edges(true_target, convergence);
              if (needs_flags_ft) { open_dowhile(); } else { string_stream << spacing << "do {\n"; indent_spacing(); }
              string_stream << spacing << "if (" << cond << ") {\n";
              indent_spacing();
              for (const auto& pl : true_phis) string_stream << spacing << pl << "\n";
              emit_region(true_target, convergence, in_loop, loop_exit_blk);
              unindent_spacing();
              string_stream << spacing << "}\n";
              if (needs_flags_ft) { close_dowhile(); } else { unindent_spacing(); string_stream << spacing << "} while(false);\n"; }
              }
              blk = convergence;
              continue;
            } else if (convergence >= 0) {
              auto shared = compute_shared_blocks(true_target, false_target, convergence);
              // Check if convergence has 3+ phi predecessors — use phi_sel
              int conv_preds_c = count_phi_predecessors(convergence);
              if (conv_preds_c >= 3 && phi_sel_var.empty() && !in_loop) {
                auto sel_name = std::format("__phi_sel_{}", phi_sel_counter++);
                string_stream << spacing << "uint " << sel_name << " = 0u;\n";
                auto saved_sel = phi_sel_var;
                auto saved_next = phi_sel_next_value;
                auto saved_map = phi_sel_pred_map;
                auto saved_conv_c = phi_sel_convergence;
                phi_sel_var = sel_name;
                phi_sel_convergence = convergence;
                phi_sel_next_value = 0;
                phi_sel_pred_map.clear();
                // Emit both branches with phi_sel active
                string_stream << spacing << "do {\n";
                indent_spacing();
                string_stream << spacing << "if (" << cond << ") {\n";
                indent_spacing();
                for (const auto& pl : true_phis) string_stream << spacing << pl << "\n";
                emit_region(true_target, convergence, in_loop, loop_exit_blk);
                unindent_spacing();
                string_stream << spacing << "} else {\n";
                indent_spacing();
                for (const auto& pl : false_phis) string_stream << spacing << pl << "\n";
                emit_region(false_target, convergence, in_loop, loop_exit_blk);
                unindent_spacing();
                string_stream << spacing << "}\n";
                unindent_spacing();
                string_stream << spacing << "} while(false);\n";
                auto sel_map = phi_sel_pred_map;
                phi_sel_var = saved_sel;
                phi_sel_next_value = saved_next;
                phi_sel_pred_map = saved_map;
                phi_sel_convergence = saved_conv_c;
                // Emit switch
                if (!sel_map.empty()) {
                  string_stream << spacing << "switch (" << sel_name << ") {\n";
                  for (const auto& [sv, pred] : sel_map) {
                    string_stream << spacing << "case " << sv << "u:\n";
                    indent_spacing();
                    if (current_code_function->code_blocks.contains(pred)) {
                      auto pred_phis = current_code_function->ComputePhiAssignments(
                          &current_code_function->code_blocks[pred], convergence);
                      for (const auto& pl : pred_phis) string_stream << spacing << pl << "\n";
                    }
                    string_stream << spacing << "break;\n";
                    unindent_spacing();
                  }
                  string_stream << spacing << "default: break;\n";
                  string_stream << spacing << "}\n";
                }
                blk = convergence;
                continue;
              }
              emit_phi_pre_init(convergence, true_target);
              bool use_dw_c = !(in_loop && (
                  region_has_back_edges(true_target, convergence) ||
                  region_has_back_edges(false_target, convergence)));
              if (use_dw_c) {
                bool needs_flags_c = in_loop && (
                    region_has_back_edges(true_target, convergence) ||
                    region_has_back_edges(false_target, convergence));
                if (needs_flags_c) { open_dowhile(); } else { string_stream << spacing << "do {\n"; indent_spacing(); }
              }
              string_stream << spacing << "if (" << cond << ") {\n";
              indent_spacing();
              for (const auto& pl : true_phis) string_stream << spacing << pl << "\n";
              emit_region(true_target, convergence, in_loop, loop_exit_blk);
              unindent_spacing();
              string_stream << spacing << "} else {\n";
              indent_spacing();
              for (const auto& pl : false_phis) string_stream << spacing << pl << "\n";
              emit_region(false_target, convergence, in_loop, loop_exit_blk);
              unindent_spacing();
              string_stream << spacing << "}\n";
              if (use_dw_c) {
                bool needs_flags_c2 = in_loop && (
                    region_has_back_edges(true_target, convergence) ||
                    region_has_back_edges(false_target, convergence));
                if (needs_flags_c2) { close_dowhile(); } else { unindent_spacing(); string_stream << spacing << "} while(false);\n"; }
              }
              blk = convergence;
              continue;
            } else {
              // No convergence — emit if/else with both as terminal
              string_stream << spacing << "if (" << cond << ") {\n";
              indent_spacing();
              for (const auto& pl : true_phis) string_stream << spacing << pl << "\n";
              emit_region(true_target, stop_at, in_loop, loop_exit_blk);
              unindent_spacing();
              string_stream << spacing << "} else {\n";
              indent_spacing();
              for (const auto& pl : false_phis) string_stream << spacing << pl << "\n";
              emit_region(false_target, stop_at, in_loop, loop_exit_blk);
              unindent_spacing();
              string_stream << spacing << "}\n";
              return;
            }
          } else if (cb.code_branch.branch_condition_true > 0) {
            // Unconditional branch
            int target = cb.code_branch.branch_condition_true;
            // Phi selector mode: set selector instead of emitting phi assignments
            if (!phi_sel_var.empty() && target == phi_sel_convergence) {
              emit_phi_sel_assign(blk);
              return;
            }
            auto phi_lines = current_code_function->ComputePhiAssignments(&cb, target);
            for (const auto& pl : phi_lines) string_stream << spacing << pl << "\n";

            if (is_back_edge(blk, target)) {
              if (in_loop) emit_continue();
              return;
            }
            if (target == stop_at || (in_loop && target == loop_exit_blk)) {
              if (in_loop && target == loop_exit_blk) emit_loop_break();
              else if (in_loop) string_stream << spacing << "break;\n";
              return;
            }
            blk = target;
            continue;
          } else {
            // No branch — terminal block
            return;
          }
        }
        // Reached stop_at by falling through convergence points.
        // If we're inside a loop and stop_at is the loop exit, emit break.
        if (in_loop && blk == loop_exit_blk) {
          emit_loop_break();  // This is always a real loop exit
        }
      };

      emit_region(0, -1, false, -1);
      // ===== END STACKIFIER =====

}
// ===== END STACKIFIER =====
