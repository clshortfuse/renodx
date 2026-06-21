#pragma once

// Semantic labeling post-pass for decompiled HLSL.
// Propagates meaningful names from known sources (inputs, resources, cbuffers)
// through the def-use chain and emits inline comments.

#include <map>
#include <regex>
#include <set>
#include <sstream>
#include <string>
#include <string_view>
#include <vector>

namespace renodx::utils::shader::decompiler {

struct SemanticLabel {
  std::string variable;   // e.g., "_42"
  std::string label;      // e.g., "worldPos_xy"
  float confidence;       // 0.0 - 1.0
  std::string source;     // What derived this label (for debugging)
};

struct SemanticContext {
  // Maps variable name -> semantic label
  std::map<std::string, SemanticLabel> labels;

  // Track which variables are derived from which
  std::map<std::string, std::vector<std::string>> def_use;  // var -> [users]
  std::map<std::string, std::vector<std::string>> use_def;  // var -> [sources]
};

class SemanticLabeler {
 public:
  // Run semantic labeling on decompiled HLSL text.
  // Returns the HLSL with inline // [sem: ...] comments added.
  static std::string Label(const std::string& hlsl) {
    SemanticContext ctx;

    auto lines = SplitLines(hlsl);

    // Phase 1: Seed labels from known sources
    SeedFromInputs(lines, ctx);
    SeedFromResources(lines, ctx);
    SeedFromCBV(lines, ctx);

    // Phase 2: Build def-use chains
    BuildDefUseChains(lines, ctx);

    // Phase 3: Propagate labels forward
    PropagateLabels(ctx);

    // Phase 4: Recognize patterns and add derived labels
    RecognizePatterns(lines, ctx);

    // Phase 5: Emit annotated HLSL
    return EmitAnnotated(lines, ctx);
  }

 private:
  static std::vector<std::string> SplitLines(const std::string& text) {
    std::vector<std::string> lines;
    std::istringstream stream(text);
    std::string line;
    while (std::getline(stream, line)) {
      lines.push_back(line);
    }
    return lines;
  }

  // --- Phase 1: Seed from input struct assignments ---
  static void SeedFromInputs(const std::vector<std::string>& lines, SemanticContext& ctx) {
    // Mermaid mode: float2 TEXCOORD = __TEXCOORD; (inputs are named directly)
    // Also match: float4 SV_Position = __SV_Position;
    static const std::regex INPUT_DECL_REGEX{
        R"(^\s*\w+\s+(\w+)\s*=\s*__(\w+);)"};
    // Match uses of input variables in assignments: _42 = ... TEXCOORD.x ...
    // We'll seed from the input declarations and let propagation handle the rest

    for (const auto& line : lines) {
      std::smatch m;
      if (std::regex_search(line, m, INPUT_DECL_REGEX)) {
        std::string var = m[1].str();
        std::string semantic = m[2].str();
        std::string label = DeriveLabelFromSemantic(semantic, "");
        ctx.labels[var] = {var, label, 1.0f, "input." + semantic};
      }
    }
  }

  static std::string DeriveLabelFromSemantic(const std::string& semantic, const std::string& swizzle) {
    // Map common semantics to readable names
    std::string base;
    if (semantic.find("TEXCOORD") != std::string::npos) base = "uv";
    else if (semantic.find("NORMAL") != std::string::npos) base = "normal";
    else if (semantic.find("TANGENT") != std::string::npos) base = "tangent";
    else if (semantic.find("BINORMAL") != std::string::npos) base = "bitangent";
    else if (semantic.find("COLOR") != std::string::npos) base = "vertexColor";
    else if (semantic.find("SV_Position") != std::string::npos) base = "svPosition";
    else if (semantic.find("SV_InstanceID") != std::string::npos) base = "instanceId";
    else if (semantic.find("SV_VertexID") != std::string::npos) base = "vertexId";
    else if (semantic.find("SV_IsFrontFace") != std::string::npos) base = "isFrontFace";
    else if (semantic.find("SV_DispatchThreadID") != std::string::npos) base = "dispatchId";
    else if (semantic.find("SV_GroupThreadID") != std::string::npos) base = "groupThreadId";
    else if (semantic.find("SV_GroupID") != std::string::npos) base = "groupId";
    else base = semantic;

    if (!swizzle.empty() && swizzle != "xyzw") {
      base += "_" + swizzle;
    }
    return base;
  }

  // --- Phase 1: Seed from resource accesses ---
  static void SeedFromResources(const std::vector<std::string>& lines, SemanticContext& ctx) {
    // Match: _42 = resourceName.SampleLevel(sampler, coords, lod);
    // Match: float4 _42 = resourceName.Sample(sampler, coords);
    static const std::regex SAMPLE_REGEX{
        R"(^\s*(?:\w+\s+)?(_\d+)\s*=\s*(?:\(\(float4\)\()?(\w+)\.(Sample\w*|Load|Gather\w*)\()"};
    // Match: _42 = resourceName[index];
    static const std::regex INDEX_REGEX{
        R"(^\s*(?:\w+\s+)?(_\d+)\s*=\s*(\w+)\[)"};

    for (const auto& line : lines) {
      std::smatch m;
      if (std::regex_search(line, m, SAMPLE_REGEX)) {
        std::string var = m[1].str();
        std::string resource = m[2].str();
        std::string op = m[3].str();

        std::string label = ShortenResourceName(resource) + "_" + SimplifyOp(op);
        ctx.labels[var] = {var, label, 0.9f, resource + "." + op};
      } else if (std::regex_search(line, m, INDEX_REGEX)) {
        std::string var = m[1].str();
        std::string resource = m[2].str();

        // Skip if it's a known non-resource (like a local variable or array)
        if (resource.starts_with("_")) continue;
        if (resource == "select" || resource == "float2" || resource == "float3" || resource == "float4") continue;

        ctx.labels[var] = {var, ShortenResourceName(resource) + "_load", 0.7f, resource + "[]"};
      }
    }
  }

  // Shorten long UE resource names like "SceneTexturesStruct_GBufferATexture" -> "GBufferA"
  static std::string ShortenResourceName(const std::string& name) {
    // Remove common prefixes
    std::string shortened = name;
    if (shortened.find("SceneTexturesStruct_") == 0) shortened = shortened.substr(20);
    if (shortened.find("Texture") != std::string::npos) {
      auto pos = shortened.find("Texture");
      shortened = shortened.substr(0, pos);
    }
    if (shortened.find("_") == 0) shortened = shortened.substr(1);
    // Lowercase first char
    if (!shortened.empty() && std::isupper(shortened[0])) {
      shortened[0] = std::tolower(shortened[0]);
    }
    return shortened.empty() ? name : shortened;
  }

  static std::string SimplifyOp(const std::string& op) {
    if (op == "Sample") return "sample";
    if (op == "SampleLevel") return "sampleLod";
    if (op == "SampleCmp" || op == "SampleCmpLevelZero") return "shadowCmp";
    if (op == "Load") return "load";
    if (op.find("Gather") != std::string::npos) return "gather";
    return op;
  }

  // --- Phase 1: Seed from CBV field loads ---
  static void SeedFromCBV(const std::vector<std::string>& lines, SemanticContext& ctx) {
    // Match: _42 = cbvName_012x;  (cbuffer field access, old style)
    static const std::regex CBV_FIELD_REGEX{
        R"(^\s*(?:\w+\s+)?(_\d+)\s*=\s*(\w+_\d{3}[xyzw]);)"};
    // Match: _42 = View.FieldName.x; or _42 = View.FieldName;
    static const std::regex CBV_DOT_REGEX{
        R"(^\s*(?:\w+\s+)?(_\d+)\s*=\s*(\w+)\.(\w+)(?:\.([xyzw]+))?;)"};
    // Match: _42 = asfloat(cbvName_raw[N].x);
    static const std::regex CBV_RAW_REGEX{
        R"(^\s*(?:\w+\s+)?(_\d+)\s*=\s*(?:asfloat|asint|asuint)\((\w+)_raw\[)"};

    for (const auto& line : lines) {
      std::smatch m;
      if (std::regex_search(line, m, CBV_FIELD_REGEX)) {
        std::string var = m[1].str();
        std::string field = m[2].str();
        ctx.labels[var] = {var, "cb_" + field, 0.8f, "cbuffer." + field};
      } else if (std::regex_search(line, m, CBV_DOT_REGEX)) {
        std::string var = m[1].str();
        std::string cbv = m[2].str();
        std::string field = m[3].str();
        std::string swizzle = m[4].matched ? m[4].str() : "";
        // Only label if it looks like a cbuffer access (capitalized name, known cbuffer names)
        if (std::isupper(cbv[0]) && field.length() > 2) {
          std::string label = field;
          if (!swizzle.empty()) label += "_" + swizzle;
          ctx.labels[var] = {var, label, 0.85f, cbv + "." + field};
        }
      } else if (std::regex_search(line, m, CBV_RAW_REGEX)) {
        std::string var = m[1].str();
        std::string cbv = m[2].str();
        ctx.labels[var] = {var, "cb_" + cbv + "_dyn", 0.6f, cbv + "_raw[]"};
      }
    }
  }

  // --- Phase 2: Build def-use chains ---
  static void BuildDefUseChains(const std::vector<std::string>& lines, SemanticContext& ctx) {
    // Match both: "float _42 = expr;" and "_42 = expr;" (mermaid mode reassignments)
    static const std::regex ASSIGN_REGEX{R"(^\s*(?:\w+\s+)?(_\d+)\s*=\s*(.+);)"};
    static const std::regex VAR_REF_REGEX{R"((_\d+))"};

    for (const auto& line : lines) {
      std::smatch m;
      if (std::regex_search(line, m, ASSIGN_REGEX)) {
        std::string def_var = m[1].str();
        std::string rhs = m[2].str();

        // Skip zero-init declarations (float _42 = 0.0f;)
        if (rhs == "0.0f" || rhs == "0u" || rhs == "0" || rhs == "false" ||
            rhs.starts_with("float2(0") || rhs.starts_with("float3(0") || rhs.starts_with("float4(0")) {
          continue;
        }

        // Find all _N references in the RHS
        auto begin = std::sregex_iterator(rhs.begin(), rhs.end(), VAR_REF_REGEX);
        auto end = std::sregex_iterator();
        for (auto it = begin; it != end; ++it) {
          std::string use_var = (*it)[1].str();
          if (use_var != def_var) {
            ctx.def_use[use_var].push_back(def_var);
            ctx.use_def[def_var].push_back(use_var);
          }
        }
      }
    }
  }

  // --- Phase 3: Forward propagation ---
  static void PropagateLabels(SemanticContext& ctx, int max_depth = 3) {
    // BFS propagation from seeded labels
    std::vector<std::string> worklist;
    for (const auto& [var, label] : ctx.labels) {
      worklist.push_back(var);
    }

    for (int depth = 0; depth < max_depth && !worklist.empty(); ++depth) {
      std::vector<std::string> next_worklist;
      float decay = 1.0f - (depth + 1) * 0.2f;

      for (const auto& var : worklist) {
        if (!ctx.labels.contains(var)) continue;
        const auto& source_label = ctx.labels[var];

        for (const auto& user : ctx.def_use[var]) {
          // Don't overwrite higher-confidence labels
          if (ctx.labels.contains(user) && ctx.labels[user].confidence >= source_label.confidence * decay) {
            continue;
          }
          // Only propagate through simple assignments and swizzles
          // More complex expressions get pattern-based labels instead
          if (ctx.use_def[user].size() == 1) {
            ctx.labels[user] = {user, source_label.label + "_derived", source_label.confidence * decay, "propagated from " + var};
            next_worklist.push_back(user);
          }
        }
      }
      worklist = std::move(next_worklist);
    }
  }

  // --- Phase 4: Pattern recognition ---
  static void RecognizePatterns(const std::vector<std::string>& lines, SemanticContext& ctx) {
    // All patterns handle both "type _N = expr;" and "_N = expr;" formats
    static const std::regex NORMALIZE_REGEX{R"((?:\w+\s+)?(_\d+)\s*=\s*normalize\((.+?)\);)"};
    static const std::regex DOT_REGEX{R"((?:\w+\s+)?(_\d+)\s*=\s*dot\((.+?),\s*(.+?)\);)"};
    static const std::regex SATURATE_REGEX{R"((?:\w+\s+)?(_\d+)\s*=\s*saturate\((.+?)\);)"};
    static const std::regex LERP_REGEX{R"((?:\w+\s+)?(_\d+)\s*=\s*(?:\()?lerp\()"};
    static const std::regex MUL_REGEX{R"((?:\w+\s+)?(_\d+)\s*=\s*mul\((.+?),\s*(.+?)\);)"};
    static const std::regex CROSS_REGEX{R"((?:\w+\s+)?(_\d+)\s*=\s*cross\((.+?),\s*(.+?)\);)"};
    static const std::regex REFLECT_REGEX{R"((?:\w+\s+)?(_\d+)\s*=\s*reflect\((.+?),\s*(.+?)\);)"};
    static const std::regex LENGTH_REGEX{R"((?:\w+\s+)?(_\d+)\s*=\s*(?:length|distance)\((.+?)\);)"};
    static const std::regex POW_REGEX{R"((?:\w+\s+)?(_\d+)\s*=\s*pow\((.+?),\s*(.+?)\);)"};
    static const std::regex RSQRT_REGEX{R"((?:\w+\s+)?(_\d+)\s*=\s*rsqrt\((.+?)\);)"};
    static const std::regex SELECT_REGEX{R"((?:\w+\s+)?(_\d+)\s*=\s*select\((.+?),\s*(.+?),\s*(.+?)\);)"};
    // Detect depth linearization: (a * depth + b) + (1.0 / (c * depth + d))
    static const std::regex DEPTH_REGEX{R"(InvDeviceZToWorldZTransform)"};

    for (size_t i = 0; i < lines.size(); ++i) {
      const auto& line = lines[i];
      std::smatch m;

      // Depth linearization (specific to UE deferred lighting)
      if (std::regex_search(line, DEPTH_REGEX)) {
        static const std::regex DEPTH_VAR_REGEX{R"((?:\w+\s+)?(_\d+)\s*=)"};
        std::smatch dm;
        if (std::regex_search(line, dm, DEPTH_VAR_REGEX)) {
          std::string var = dm[1].str();
          ctx.labels[var] = {var, "linearDepth", 0.95f, "InvDeviceZToWorldZTransform"};
        }
      } else if (std::regex_search(line, m, RSQRT_REGEX)) {
        std::string var = m[1].str();
        std::string arg = m[2].str();
        // rsqrt(dot(v, v)) is normalization magnitude
        if (arg.find("dot(") != std::string::npos) {
          ctx.labels[var] = {var, "invLength", 0.8f, "rsqrt(dot(...))"};
        } else {
          ctx.labels[var] = {var, "rsqrt_val", 0.5f, "rsqrt(" + arg + ")"};
        }
      } else if (std::regex_search(line, m, NORMALIZE_REGEX)) {
        std::string var = m[1].str();
        std::string arg = m[2].str();
        std::string base = GetLabelOrVar(arg, ctx);
        if (!ctx.labels.contains(var) || ctx.labels[var].confidence < 0.7f) {
          ctx.labels[var] = {var, base + "_dir", 0.7f, "normalize(" + arg + ")"};
        }
      } else if (std::regex_search(line, m, DOT_REGEX)) {
        std::string var = m[1].str();
        std::string a = m[2].str();
        std::string b = m[3].str();
        std::string la = GetLabelOrVar(a, ctx);
        std::string lb = GetLabelOrVar(b, ctx);
        // Only label if at least one argument resolved to something meaningful
        if (la == "expr" && lb == "expr") continue;
        std::string label = la + "_dot_" + lb;
        if (la.find("normal") != std::string::npos && lb.find("light") != std::string::npos) label = "NdotL";
        else if (la.find("normal") != std::string::npos && lb.find("view") != std::string::npos) label = "NdotV";
        else if (la.find("normal") != std::string::npos && lb.find("half") != std::string::npos) label = "NdotH";
        ctx.labels[var] = {var, label, 0.8f, "dot(" + a + ", " + b + ")"};
      } else if (std::regex_search(line, m, SATURATE_REGEX)) {
        std::string var = m[1].str();
        std::string arg = m[2].str();
        std::string base = GetLabelOrVar(arg, ctx);
        ctx.labels[var] = {var, base + "_sat", 0.7f, "saturate(" + arg + ")"};
      } else if (std::regex_search(line, m, LERP_REGEX)) {
        std::string var = m[1].str();
        ctx.labels[var] = {var, "blended", 0.6f, "lerp(...)"};
      } else if (std::regex_search(line, m, MUL_REGEX)) {
        std::string var = m[1].str();
        std::string a = m[2].str();
        std::string b = m[3].str();
        std::string label = "transformed";
        std::string la = GetLabelOrVar(a, ctx);
        if (la.find("Pos") != std::string::npos || la.find("pos") != std::string::npos) label = "transformed_pos";
        else if (la.find("normal") != std::string::npos) label = "transformed_normal";
        else if (la.find("view") != std::string::npos) label = "transformed_view";
        ctx.labels[var] = {var, label, 0.6f, "mul(" + a + ", " + b + ")"};
      } else if (std::regex_search(line, m, CROSS_REGEX)) {
        std::string var = m[1].str();
        ctx.labels[var] = {var, "cross_product", 0.7f, "cross(...)"};
      } else if (std::regex_search(line, m, REFLECT_REGEX)) {
        std::string var = m[1].str();
        ctx.labels[var] = {var, "reflection_dir", 0.8f, "reflect(...)"};
      } else if (std::regex_search(line, m, LENGTH_REGEX)) {
        std::string var = m[1].str();
        ctx.labels[var] = {var, "dist", 0.6f, "length/distance(...)"};
      } else if (std::regex_search(line, m, POW_REGEX)) {
        std::string var = m[1].str();
        ctx.labels[var] = {var, "pow_result", 0.5f, "pow(...)"};
      }
    }
  }

  static std::string GetLabelOrVar(const std::string& var_or_expr, const SemanticContext& ctx) {
    // If it's a variable reference and we have a label, use the label
    if (var_or_expr.starts_with("_") && ctx.labels.contains(var_or_expr)) {
      return ctx.labels.at(var_or_expr).label;
    }
    // If it's a simple _N variable without a label, return short form
    static const std::regex SIMPLE_VAR{R"(^_\d+$)"};
    if (std::regex_match(var_or_expr, SIMPLE_VAR)) {
      return var_or_expr;
    }
    // For complex expressions (literals, function calls, etc.), return a generic placeholder
    return "expr";
  }

  // --- Phase 5: Emit annotated output ---
  static std::string EmitAnnotated(const std::vector<std::string>& lines, const SemanticContext& ctx) {
    // Match both "type _N = ..." and "_N = ..." (reassignment in mermaid mode)
    static const std::regex ASSIGN_VAR_REGEX{R"(^\s*(?:\w+\s+)?(_\d+)\s*=\s*(?!0\.0f|0u|0;|false|float))"};
    std::string result;
    result.reserve(lines.size() * 80);

    for (const auto& line : lines) {
      std::smatch m;
      if (std::regex_search(line, m, ASSIGN_VAR_REGEX)) {
        std::string var = m[1].str();
        if (ctx.labels.contains(var)) {
          const auto& label = ctx.labels.at(var);
          if (label.confidence >= 0.5f) {
            // Don't annotate if line is already very long
            if (line.length() > 120) {
              result += "  // [sem: " + label.label + "]\n";
            }
            result += line;
            if (line.length() <= 120) {
              result += "  // [sem: " + label.label + "]";
            }
            result += "\n";
            continue;
          }
        }
      }
      result += line;
      result += "\n";
    }
    return result;
  }
};

}  // namespace renodx::utils::shader::decompiler
