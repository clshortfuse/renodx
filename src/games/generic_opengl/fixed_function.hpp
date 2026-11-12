#pragma once

#include "gl_api.hpp"
#include "parameters.hpp"
#include "../../utils/detour.hpp"
#include <array>
#include <memory>
#include <mutex>
#include <unordered_map>

namespace generic_opengl::fixed {
struct Context {
  GL gl;
  reshade::api::command_list* cmd = nullptr;
  unsigned program = 0;
  bool api_ready = false;
  bool prepared = false;
  bool logged = false;
  parameters::Context parameters;
};
inline std::mutex mutex;
inline std::unordered_map<HGLRC, std::shared_ptr<Context>> contexts;
inline void (*prepare_framebuffer)(reshade::api::command_list*) = nullptr;
inline void(APIENTRY* original_begin)(unsigned) = nullptr;
inline void(APIENTRY* original_end)() = nullptr;
inline void(APIENTRY* original_arrays)(unsigned, int, int) = nullptr;
inline void(APIENTRY* original_elements)(unsigned, int, unsigned, const void*) = nullptr;
inline void(APIENTRY* original_list)(unsigned) = nullptr;
inline void(APIENTRY* original_lists)(int, unsigned, const void*) = nullptr;
inline bool installed = false;
inline thread_local unsigned nesting = 0;

struct DrawState {
  std::shared_ptr<Context> context;
  int vertex_clamp = 0, fragment_clamp = 0;
  bool changed_vertex = false, changed_fragment = false, changed_program = false;
  parameters::State parameters;
};
inline thread_local DrawState immediate;

inline DrawState Before() {
  DrawState state;
  if (internal_gl) return state;
  const auto current = reinterpret_cast<HGLRC(WINAPI*)()>(GLProc("wglGetCurrentContext"));
  if (!current) return state;
  {
    const std::lock_guard lock(mutex);
    const auto found = contexts.find(current());
    if (found == contexts.end()) return state;
    state.context = found->second;
  }
  auto& context = *state.context;
  if (!context.api_ready) {
    // init_command_list may run before ReShade publishes the current context.
    context.gl = GL();
    context.api_ready = true;
    Log(context.gl.compatibility ? "Compatibility context ready" : "Core context ready (GLSL parameters only)");
  }
  const auto& gl = context.gl;
  // Do not query/modify state while building a display list. The call-list hook
  // applies the profile during playback; lists changing programs need an adapter.
  if (!gl.get || !gl.enabled) return {};
  int list = 0;
  if (gl.compatibility) gl.get(0x0B33, &list); // GL_LIST_INDEX
  if (list != 0) return {};
  InternalScope scope;
  if (prepare_framebuffer && context.cmd) prepare_framebuffer(context.cmd);
  int program = 0;
  if (gl.use_program) gl.get(0x8B8D, &program);
  if (program != 0 || (gl.arb_vertex && gl.enabled(0x8620)) || (gl.arb_fragment && gl.enabled(0x8804))) {
    state.parameters = parameters::Before(&context.parameters, gl, context.cmd->get_device(), program);
    return state;
  }
  if (gl.program_pipelines) {
    int pipeline = 0;
    gl.get(0x825A, &pipeline); // GL_PROGRAM_PIPELINE_BINDING
    if (pipeline != 0) return {};
  }
  if (!profile.fixed_function || !gl.compatibility) return {};

  if (!context.prepared) {
    context.prepared = true;
    try {
      if (!profile.fixed_fragment.empty() && gl.create_program && gl.attach_shader && gl.link_program
          && gl.program_iv && gl.delete_program && gl.use_program) {
        const auto shader = gl.Compile(0x8B30, ReadSource(ProfilePath(profile.fixed_fragment)));
        if (shader) {
          context.program = gl.create_program();
          if (context.program) {
            gl.attach_shader(context.program, shader);
            gl.link_program(context.program);
            int ok = 0;
            gl.program_iv(context.program, 0x8B82, &ok);
            if (!ok) {
              char message[2048] = {};
              if (gl.program_log) gl.program_log(context.program, sizeof(message), nullptr, message);
              Log(std::string("Fixed-function fragment link failed: ") + message, true);
              gl.delete_program(context.program);
              context.program = 0;
            }
          }
          gl.delete_shader(shader);
        }
      }
    } catch (const std::exception& error) {
      Log(std::string("Fixed-function profile skipped: ") + error.what(), true);
    }
  }
  // Only fixed-function draws are affected; native shaders retain their state.
  if (gl.clamp_supported && profile.unclamp_vertex) {
    gl.get(0x891A, &state.vertex_clamp);
    gl.clamp(0x891A, 0);
    state.changed_vertex = true;
  }
  if (gl.clamp_supported && profile.unclamp_fragment) {
    gl.get(0x891B, &state.fragment_clamp);
    gl.clamp(0x891B, 0);
    state.changed_fragment = true;
  }
  if (context.program) {
    gl.use_program(context.program);
    state.changed_program = true;
    state.parameters = parameters::Before(&context.parameters, gl, context.cmd->get_device(), context.program, true);
  }
  if (!context.logged) {
    context.logged = true;
    Log(std::string("Fixed-function profile active; custom fragment=") + (context.program ? "yes" : "no")
        + ", color clamp control=" + (gl.clamp_supported ? "available" : "unavailable"));
  }
  return state;
}

inline void After(DrawState* state) {
  if (!state->context) return;
  const auto& gl = state->context->gl;
  InternalScope scope;
  parameters::After(gl, state->parameters);
  if (state->changed_program) gl.use_program(0);
  if (state->changed_vertex) gl.clamp(0x891A, state->vertex_clamp);
  if (state->changed_fragment) gl.clamp(0x891B, state->fragment_clamp);
  *state = {};
}

inline void APIENTRY Begin(unsigned mode) {
  if (nesting++ == 0) immediate = Before();
  original_begin(mode);
}
inline void APIENTRY End() {
  original_end();
  if (nesting > 0 && --nesting == 0) After(&immediate);
}
inline void APIENTRY Arrays(unsigned mode, int first, int count) {
  auto state = nesting++ == 0 ? Before() : DrawState{};
  original_arrays(mode, first, count);
  if (--nesting == 0) After(&state);
}
inline void APIENTRY Elements(unsigned mode, int count, unsigned type, const void* indices) {
  auto state = nesting++ == 0 ? Before() : DrawState{};
  original_elements(mode, count, type, indices);
  if (--nesting == 0) After(&state);
}
inline void APIENTRY CallList(unsigned list) {
  auto state = nesting++ == 0 ? Before() : DrawState{};
  original_list(list);
  if (--nesting == 0) After(&state);
}
inline void APIENTRY CallLists(int count, unsigned type, const void* lists) {
  auto state = nesting++ == 0 ? Before() : DrawState{};
  original_lists(count, type, lists);
  if (--nesting == 0) After(&state);
}
inline const std::array<renodx::utils::detour::Export, 6> hooks = {{
    {"glBegin", &original_begin, Begin}, {"glEnd", &original_end, End},
    {"glDrawArrays", &original_arrays, Arrays}, {"glDrawElements", &original_elements, Elements},
    {"glCallList", &original_list, CallList}, {"glCallLists", &original_lists, CallLists},
}};

struct DrawScope {
  DrawState state = nesting++ == 0 ? Before() : DrawState{};
  ~DrawScope() { if (--nesting == 0) After(&state); }
};

// Resolve extension entry points while an OpenGL context is current. ReShade
// exposes stable wrappers for these functions; nesting prevents double injection.
#define PARAMETER_DRAW(Name, Signature, Arguments) \
  inline void(APIENTRY* original_##Name) Signature = nullptr; \
  inline void APIENTRY Name Signature { DrawScope scope; original_##Name Arguments; }
PARAMETER_DRAW(DrawRangeElements, (unsigned m, unsigned s, unsigned e, int n, unsigned t, const void* p), (m,s,e,n,t,p))
PARAMETER_DRAW(DrawArraysInstanced, (unsigned m, int f, int n, int c), (m,f,n,c))
PARAMETER_DRAW(DrawElementsInstanced, (unsigned m, int n, unsigned t, const void* p, int c), (m,n,t,p,c))
PARAMETER_DRAW(DrawElementsBaseVertex, (unsigned m, int n, unsigned t, const void* p, int b), (m,n,t,p,b))
PARAMETER_DRAW(DrawElementsInstancedBaseVertex, (unsigned m, int n, unsigned t, const void* p, int c, int b), (m,n,t,p,c,b))
PARAMETER_DRAW(DrawArraysInstancedBaseInstance, (unsigned m, int f, int n, int c, unsigned b), (m,f,n,c,b))
PARAMETER_DRAW(DrawElementsInstancedBaseInstance, (unsigned m, int n, unsigned t, const void* p, int c, unsigned b), (m,n,t,p,c,b))
PARAMETER_DRAW(DrawElementsInstancedBaseVertexBaseInstance, (unsigned m, int n, unsigned t, const void* p, int c, int v, unsigned b), (m,n,t,p,c,v,b))
PARAMETER_DRAW(MultiDrawArrays, (unsigned m, const int* f, const int* n, int c), (m,f,n,c))
PARAMETER_DRAW(MultiDrawElements, (unsigned m, const int* n, unsigned t, const void*const* p, int c), (m,n,t,p,c))
PARAMETER_DRAW(DrawArraysIndirect, (unsigned m, const void* p), (m,p))
PARAMETER_DRAW(DrawElementsIndirect, (unsigned m, unsigned t, const void* p), (m,t,p))
PARAMETER_DRAW(MultiDrawArraysIndirect, (unsigned m, const void* p, int n, int s), (m,p,n,s))
PARAMETER_DRAW(MultiDrawElementsIndirect, (unsigned m, unsigned t, const void* p, int n, int s), (m,t,p,n,s))
PARAMETER_DRAW(DispatchCompute, (unsigned x, unsigned y, unsigned z), (x,y,z))
PARAMETER_DRAW(DispatchComputeIndirect, (ptrdiff_t p), (p))
#undef PARAMETER_DRAW

inline void ForgetProgram(unsigned program, unsigned target) {
  if (internal_gl) return;
  const auto current = reinterpret_cast<HGLRC(WINAPI*)()>(GLProc("wglGetCurrentContext"));
  if (!current) return;
  std::shared_ptr<Context> context;
  {
    const std::lock_guard lock(mutex);
    const auto found = contexts.find(current());
    if (found != contexts.end()) context = found->second;
  }
  if (context) parameters::Track(context->cmd->get_device(), program, target, false);
}
inline void(APIENTRY* original_DeleteProgram)(unsigned) = nullptr;
inline void APIENTRY DeleteProgram(unsigned program) {
  // A currently bound deleted GLSL program remains alive until unbound. Its
  // eligibility can safely end early; never let a reused name inherit it.
  ForgetProgram(program, 0);
  original_DeleteProgram(program);
}
inline void(APIENTRY* original_DeleteProgramsARB)(int, const unsigned*) = nullptr;
inline void APIENTRY DeleteProgramsARB(int count, const unsigned* programs) {
  for (int i = 0; i < count; ++i) {
    ForgetProgram(programs[i], 0x8620);
    ForgetProgram(programs[i], 0x8804);
  }
  original_DeleteProgramsARB(count, programs);
}
inline std::vector<renodx::utils::detour::Function> extension_hooks;
inline bool extensions_attempted = false;
inline void InstallExtensions() {
  if (!profile.parameters.enabled || extensions_attempted) return;
  extensions_attempted = true;
  const renodx::utils::detour::Export entries[] = {
#define PARAMETER_ENTRY(Name) {"gl" #Name, &original_##Name, Name},
    PARAMETER_ENTRY(DrawRangeElements)
    PARAMETER_ENTRY(DrawArraysInstanced)
    PARAMETER_ENTRY(DrawElementsInstanced)
    PARAMETER_ENTRY(DrawElementsBaseVertex)
    PARAMETER_ENTRY(DrawElementsInstancedBaseVertex)
    PARAMETER_ENTRY(DrawArraysInstancedBaseInstance)
    PARAMETER_ENTRY(DrawElementsInstancedBaseInstance)
    PARAMETER_ENTRY(DrawElementsInstancedBaseVertexBaseInstance)
    PARAMETER_ENTRY(MultiDrawArrays)
    PARAMETER_ENTRY(MultiDrawElements)
    PARAMETER_ENTRY(DrawArraysIndirect)
    PARAMETER_ENTRY(DrawElementsIndirect)
    PARAMETER_ENTRY(MultiDrawArraysIndirect)
    PARAMETER_ENTRY(MultiDrawElementsIndirect)
    PARAMETER_ENTRY(DispatchCompute)
    PARAMETER_ENTRY(DispatchComputeIndirect)
    PARAMETER_ENTRY(DeleteProgram)
    PARAMETER_ENTRY(DeleteProgramsARB)
#undef PARAMETER_ENTRY
  };
  for (const auto& entry : entries) {
    auto* address = GLProc(entry.name);
    if (!address) continue;
    if (std::any_of(extension_hooks.begin(), extension_hooks.end(),
        [&](const auto& hook) { return *hook.original == address; })) continue;
    *entry.original = reinterpret_cast<void*>(address);
    extension_hooks.emplace_back(entry.original, entry.replacement);
  }
  try {
    if (!extension_hooks.empty()) renodx::utils::detour::Install(extension_hooks);
    Log("Installed parameter extension hooks: " + std::to_string(extension_hooks.size()));
  } catch (const std::exception& error) {
    extension_hooks.clear();
    Log(std::string("Extended parameter hooks unavailable: ") + error.what(), true);
  }
}

inline void OnInitCommandList(reshade::api::command_list* cmd) {
  if (cmd->get_device()->get_api() != reshade::api::device_api::opengl) return;
  if (!profile.fixed_function && !profile.default_framebuffer && !profile.parameters.enabled) return;
  const std::lock_guard lock(mutex);
  InstallExtensions();
  if (!installed) {
    const auto result = renodx::utils::detour::Install(GetModuleHandleW(L"opengl32.dll"), hooks);
    if (!result.Complete()) {
      renodx::utils::detour::Uninstall(hooks);
      Log("Could not install all compatibility draw hooks; fixed-function injection is inactive", true);
      return;
    }
    installed = true;
    Log("Installed compatibility hooks for immediate, array, indexed and display-list draws");
  }
  auto context = std::make_shared<Context>();
  context->cmd = cmd;
  contexts[reinterpret_cast<HGLRC>(cmd->get_native())] = std::move(context);
}

inline void OnDestroyCommandList(reshade::api::command_list* cmd) {
  if (cmd->get_device()->get_api() != reshade::api::device_api::opengl) return;
  const std::lock_guard lock(mutex);
  const auto found = contexts.find(reinterpret_cast<HGLRC>(cmd->get_native()));
  if (found == contexts.end()) return;
  const auto& context = *found->second;
  if (context.parameters.buffer && context.gl.current && context.gl.current() == found->first && context.gl.delete_buffers) {
    InternalScope scope;
    context.gl.delete_buffers(1, &context.parameters.buffer);
  }
  if (context.program && context.gl.current && context.gl.current() == found->first) {
    InternalScope scope;
    context.gl.delete_program(context.program);
  }
  contexts.erase(found);
}

inline void Use(DWORD reason) {
  if (reason == DLL_PROCESS_ATTACH) {
    reshade::register_event<reshade::addon_event::init_command_list>(OnInitCommandList);
    reshade::register_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);
  } else if (reason == DLL_PROCESS_DETACH) {
    if (!extension_hooks.empty()) {
      renodx::utils::detour::Uninstall(extension_hooks);
      extension_hooks.clear();
    }
    if (installed) {
      renodx::utils::detour::Uninstall(hooks);
      installed = false;
    }
    reshade::unregister_event<reshade::addon_event::init_command_list>(OnInitCommandList);
    reshade::unregister_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);
  }
}
}  // namespace generic_opengl::fixed
