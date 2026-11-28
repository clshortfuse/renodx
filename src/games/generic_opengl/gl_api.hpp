#pragma once

#include "profile.hpp"

namespace generic_opengl {
// Resolve against the application's loader, so ReShade retains state tracking.
inline PROC GLProc(const char* name) {
  const auto module = GetModuleHandleW(L"opengl32.dll");
  if (!module) return nullptr;
  if (const auto proc = GetProcAddress(module, name)) return proc;
  const auto get = reinterpret_cast<PROC(WINAPI*)(LPCSTR)>(GetProcAddress(module, "wglGetProcAddress"));
  if (!get) return nullptr;
  const auto proc = get(name);
  const auto value = reinterpret_cast<intptr_t>(proc);
  return value == -1 || (value >= 0 && value <= 3) ? nullptr : proc;
}

struct GL {
  HGLRC(WINAPI* current)() = nullptr;
  void(APIENTRY* get)(unsigned, int*) = nullptr;
  const unsigned char*(APIENTRY* get_string)(unsigned) = nullptr;
  unsigned char(APIENTRY* enabled)(unsigned) = nullptr;
  void(APIENTRY* clamp)(unsigned, unsigned) = nullptr;
  unsigned(APIENTRY* create_shader)(unsigned) = nullptr;
  void(APIENTRY* shader_source)(unsigned, int, const char* const*, const int*) = nullptr;
  void(APIENTRY* compile_shader)(unsigned) = nullptr;
  void(APIENTRY* shader_iv)(unsigned, unsigned, int*) = nullptr;
  void(APIENTRY* shader_log)(unsigned, int, int*, char*) = nullptr;
  void(APIENTRY* delete_shader)(unsigned) = nullptr;
  unsigned(APIENTRY* create_program)() = nullptr;
  void(APIENTRY* attach_shader)(unsigned, unsigned) = nullptr;
  void(APIENTRY* link_program)(unsigned) = nullptr;
  void(APIENTRY* program_iv)(unsigned, unsigned, int*) = nullptr;
  void(APIENTRY* program_log)(unsigned, int, int*, char*) = nullptr;
  void(APIENTRY* delete_program)(unsigned) = nullptr;
  void(APIENTRY* use_program)(unsigned) = nullptr;
  void(APIENTRY* gen_arb)(int, unsigned*) = nullptr;
  void(APIENTRY* bind_arb)(unsigned, unsigned) = nullptr;
  void(APIENTRY* upload_arb)(unsigned, unsigned, int, const void*) = nullptr;
  void(APIENTRY* arb_iv)(unsigned, unsigned, int*) = nullptr;
  void(APIENTRY* delete_arb)(int, const unsigned*) = nullptr;
  void(APIENTRY* arb_local)(unsigned, unsigned, const float*) = nullptr;
  void(APIENTRY* arb_env)(unsigned, unsigned, const float*) = nullptr;
  void(APIENTRY* get_arb_local)(unsigned, unsigned, float*) = nullptr;
  void(APIENTRY* get_arb_env)(unsigned, unsigned, float*) = nullptr;
  int(APIENTRY* uniform_location)(unsigned, const char*) = nullptr;
  void(APIENTRY* active_uniform)(unsigned, unsigned, int, int*, int*, unsigned*, char*) = nullptr;
  void(APIENTRY* uniform4fv)(int, int, const float*) = nullptr;
  void(APIENTRY* get_uniform)(unsigned, int, float*) = nullptr;
  unsigned(APIENTRY* block_index)(unsigned, const char*) = nullptr;
  void(APIENTRY* block_iv)(unsigned, unsigned, unsigned, int*) = nullptr;
  void(APIENTRY* block_binding)(unsigned, unsigned, unsigned) = nullptr;
  void(APIENTRY* gen_buffers)(int, unsigned*) = nullptr;
  void(APIENTRY* delete_buffers)(int, const unsigned*) = nullptr;
  void(APIENTRY* bind_buffer)(unsigned, unsigned) = nullptr;
  void(APIENTRY* buffer_data)(unsigned, ptrdiff_t, const void*, unsigned) = nullptr;
  void(APIENTRY* buffer_subdata)(unsigned, ptrdiff_t, ptrdiff_t, const void*) = nullptr;
  void(APIENTRY* bind_base)(unsigned, unsigned, unsigned) = nullptr;
  void(APIENTRY* bind_range)(unsigned, unsigned, unsigned, ptrdiff_t, ptrdiff_t) = nullptr;
  void(APIENTRY* get_indexed)(unsigned, unsigned, int*) = nullptr;
  void(APIENTRY* get_indexed64)(unsigned, unsigned, int64_t*) = nullptr;
  bool compatibility = false;
  bool arb_vertex = false;
  bool arb_fragment = false;
  bool clamp_supported = false;
  bool program_pipelines = false;
  bool uniform_buffers = false;

  GL() {
#define LOAD(member, name) member = reinterpret_cast<decltype(member)>(GLProc(name))
    LOAD(current, "wglGetCurrentContext"); LOAD(get, "glGetIntegerv");
    LOAD(get_string, "glGetString"); LOAD(enabled, "glIsEnabled");
    LOAD(clamp, "glClampColorARB");
    LOAD(create_shader, "glCreateShader"); LOAD(shader_source, "glShaderSource");
    LOAD(compile_shader, "glCompileShader"); LOAD(shader_iv, "glGetShaderiv");
    LOAD(shader_log, "glGetShaderInfoLog"); LOAD(delete_shader, "glDeleteShader");
    LOAD(create_program, "glCreateProgram"); LOAD(attach_shader, "glAttachShader");
    LOAD(link_program, "glLinkProgram"); LOAD(program_iv, "glGetProgramiv");
    LOAD(program_log, "glGetProgramInfoLog"); LOAD(delete_program, "glDeleteProgram");
    LOAD(use_program, "glUseProgram"); LOAD(gen_arb, "glGenProgramsARB");
    LOAD(bind_arb, "glBindProgramARB"); LOAD(upload_arb, "glProgramStringARB");
    LOAD(arb_iv, "glGetProgramivARB"); LOAD(delete_arb, "glDeleteProgramsARB");
    LOAD(arb_local, "glProgramLocalParameter4fvARB"); LOAD(arb_env, "glProgramEnvParameter4fvARB");
    LOAD(get_arb_local, "glGetProgramLocalParameterfvARB"); LOAD(get_arb_env, "glGetProgramEnvParameterfvARB");
    LOAD(uniform_location, "glGetUniformLocation"); LOAD(active_uniform, "glGetActiveUniform");
    LOAD(uniform4fv, "glUniform4fv"); LOAD(get_uniform, "glGetUniformfv");
    LOAD(block_index, "glGetUniformBlockIndex"); LOAD(block_iv, "glGetActiveUniformBlockiv");
    LOAD(block_binding, "glUniformBlockBinding"); LOAD(gen_buffers, "glGenBuffers");
    LOAD(delete_buffers, "glDeleteBuffers"); LOAD(bind_buffer, "glBindBuffer");
    LOAD(buffer_data, "glBufferData"); LOAD(buffer_subdata, "glBufferSubData");
    LOAD(bind_base, "glBindBufferBase"); LOAD(bind_range, "glBindBufferRange");
    LOAD(get_indexed, "glGetIntegeri_v"); LOAD(get_indexed64, "glGetInteger64i_v");
#undef LOAD
    if (!current || !current() || !get || !get_string) return;
    const auto* version = get_string(0x1F02);
    int major = 0, minor = 0;
    if (version) sscanf_s(reinterpret_cast<const char*>(version), "%d.%d", &major, &minor);
    program_pipelines = major > 4 || (major == 4 && minor >= 1);
    uniform_buffers = major > 3 || (major == 3 && minor >= 1);
    if (major > 3 || (major == 3 && minor >= 2)) {
      int mask = 0;
      get(0x9126, &mask); // GL_CONTEXT_PROFILE_MASK
      compatibility = (mask & 2) != 0;
      // NVIDIA's legacy wglCreateContext path can report a zero profile mask.
      // Require its advertised compatibility extension rather than guessing.
      if (mask == 0) {
        const auto* extensions = get_string(0x1F03);
        compatibility = extensions && std::string(reinterpret_cast<const char*>(extensions)).find("GL_ARB_compatibility") != std::string::npos;
      }
    } else {
      compatibility = major > 0 && major < 3;
      if (major == 3 && minor == 0) {
        int flags = 0;
        get(0x821E, &flags);
        compatibility = (flags & 1) == 0;
      }
      // 3.1 is deliberately excluded unless a later compatibility context is used.
    }
    if (compatibility) {
      const auto* raw = get_string(0x1F03);
      const std::string extensions = std::string(raw ? reinterpret_cast<const char*>(raw) : "") + " ";
      program_pipelines = program_pipelines || extensions.find("GL_ARB_separate_shader_objects ") != std::string::npos;
      uniform_buffers = uniform_buffers || extensions.find("GL_ARB_uniform_buffer_object ") != std::string::npos;
      arb_vertex = extensions.find("GL_ARB_vertex_program ") != std::string::npos;
      arb_fragment = extensions.find("GL_ARB_fragment_program ") != std::string::npos;
      clamp_supported = clamp && (major >= 3 || extensions.find("GL_ARB_color_buffer_float ") != std::string::npos);
    }
  }

  // Compile without changing the game's shader object. Returns an owned shader.
  unsigned Compile(unsigned type, const std::string& source) const {
    if (!create_shader || !shader_source || !compile_shader || !shader_iv || !delete_shader) return 0;
    const auto shader = create_shader(type);
    if (!shader) return 0;
    const char* text = source.data();
    const int size = static_cast<int>(source.size());
    shader_source(shader, 1, &text, &size);
    compile_shader(shader);
    int ok = 0;
    shader_iv(shader, 0x8B81, &ok);
    if (ok) return shader;
    char message[2048] = {};
    if (shader_log) shader_log(shader, sizeof(message), nullptr, message);
    Log(std::string("GLSL compile failed; keeping original: ") + message, true);
    delete_shader(shader);
    return 0;
  }
};

struct InternalScope {
  bool previous = internal_gl;
  InternalScope() { internal_gl = true; }
  ~InternalScope() { internal_gl = previous; }
};
}  // namespace generic_opengl
