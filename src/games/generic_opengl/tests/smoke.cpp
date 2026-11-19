#include <Windows.h>
#include <GL/gl.h>
#include <cstdio>
#include <cmath>
#include <filesystem>
#include <fstream>
#include <string>
#include <cstdint>
#include <stdexcept>

template<class T> T proc(const char* name) {
  const auto value = wglGetProcAddress(name);
  if (!value) throw std::runtime_error(name);
  return reinterpret_cast<T>(value);
}
void file(const std::string& path, const std::string& data) {
  std::filesystem::create_directories(std::filesystem::path(path).parent_path());
  std::ofstream(path, std::ios::binary) << data;
}
std::string key(const std::string& source, const char* extension) {
  uint32_t crc = ~0u;
  for (unsigned char byte : source) {
    crc ^= byte;
    for (int bit = 0; bit < 8; ++bit) crc = (crc >> 1) ^ (0xEDB88320u & (0u - (crc & 1u)));
  }
  char result[64];
  sprintf_s(result, "0x%08X.ps.%s", ~crc, extension);
  return result;
}
const std::string glsl = "#version 120\nvoid main(){gl_FragColor=vec4(0.2,0,0,1);}\n";
const std::string external = "#version 120\nvoid main(){gl_FragColor=vec4(0.4,0,0,1);}\n";
const std::string bad = "#version 120\nvoid main(){gl_FragColor=vec4(0.6,0,0,1);}\n";
const std::string arb = "!!ARBfp1.0\nMOV result.color, {0.3,0,0,1};\nEND\n";
int failures = 0;
void triangle() {
  glBegin(GL_TRIANGLES); glVertex2f(-1,-1); glVertex2f(3,-1); glVertex2f(-1,3); glEnd();
}
void check(const char* name, float expected) {
  float pixel[4] = {};
  glFinish();
  glReadPixels(16,16,1,1,GL_RGBA,GL_FLOAT,pixel);
  const auto error = glGetError();
  const bool ok = std::abs(pixel[0]-expected) < 0.025f && error == 0;
  printf("%s %s got=%.3f expected=%.3f GLerror=0x%X\n", ok?"PASS":"FAIL", name,pixel[0],expected,error);
  if (!ok) ++failures;
}
#include "parameter_cases.hpp"

int main(int argc, char** argv) {
  try {
    const bool capture = argc > 1 && std::string(argv[1]) == "capture";
    const bool clamp_only = argc > 1 && std::string(argv[1]) == "clamp";
    const bool hdr = argc > 1 && std::string(argv[1]) == "hdr";
    const bool nohooks = argc > 1 && std::string(argv[1]) == "nohooks";
    const bool parameters = argc > 1 && std::string(argv[1]).starts_with("parameters-");
    const bool environment = parameters && std::string(argv[1]) == "parameters-env";
    file("renodx-opengl/replacements/"+key(glsl,"glsl"),"#version 120\nvoid main(){gl_FragColor=vec4(2,0,0,1);}\n");
    file("renodx-opengl/replacements/"+key(arb,"arb"),"!!ARBfp1.0\nMOV result.color, {3,0,0,1};\nEND\n");
    file("renodx-opengl/replacements/"+key(bad,"glsl"),"#version 120\nthis is invalid GLSL\n");
    file("renodx-opengl/external/lighting.glsl","#version 120\nvoid main(){gl_FragColor=vec4(4,0,0,1);}\n");
    file("renodx-opengl/fixed.glsl","#version 120\nvoid main(){gl_FragColor=vec4(5,0,0,1);}\n");
    file("renodx-opengl/profile.json",std::string("{\"dump_shaders\":true,\"replace_shaders\":")+(capture?"false":"true")+
      ",\"hdr_proxy\":"+((hdr||nohooks)?"true":"false")+",\"redirect_default_framebuffer\":"+(hdr?"true":"false")+",\"replacements\":{\""+key(external,"glsl")+"\":\"external/lighting.glsl\"},\"fixed_function\":{\"enabled\":"+
      (capture?"false":"true")+",\"unclamp_vertex_color\":true,\"unclamp_fragment_color\":true,\"fragment_shader\":\""+(clamp_only?"":"fixed.glsl")+"\"}}");
    WNDCLASSW wc = {}; wc.lpfnWndProc=DefWindowProcW;wc.hInstance=GetModuleHandleW(nullptr);wc.lpszClassName=L"RenoDXSmoke";wc.style=CS_OWNDC;
    if (parameters) ParameterProfile(environment);
    RegisterClassW(&wc);
    HWND window=CreateWindowW(wc.lpszClassName,L"RenoDX OpenGL smoke",WS_OVERLAPPEDWINDOW,0,0,128,128,nullptr,nullptr,wc.hInstance,nullptr);
    HDC dc=GetDC(window);
    PIXELFORMATDESCRIPTOR pfd={sizeof(pfd),1,PFD_DRAW_TO_WINDOW|PFD_SUPPORT_OPENGL|PFD_DOUBLEBUFFER,PFD_TYPE_RGBA,32};
    pfd.cDepthBits=24;pfd.cStencilBits=8;
    if (!SetPixelFormat(dc,ChoosePixelFormat(dc,&pfd),&pfd)) throw std::runtime_error("pixel format");
    HGLRC context=wglCreateContext(dc);
    if(!context || !wglMakeCurrent(dc,context)) throw std::runtime_error("context");
    printf("GL=%s\n",glGetString(GL_VERSION));
    auto gen=proc<void(APIENTRY*)(int,unsigned*)>("glGenFramebuffers");
    auto bind=proc<void(APIENTRY*)(unsigned,unsigned)>("glBindFramebuffer");
    auto attach=proc<void(APIENTRY*)(unsigned,unsigned,unsigned,unsigned,int)>("glFramebufferTexture2D");
    auto status=proc<unsigned(APIENTRY*)(unsigned)>("glCheckFramebufferStatus");
    auto clamp=proc<void(APIENTRY*)(unsigned,unsigned)>("glClampColorARB");
    auto create_shader=proc<unsigned(APIENTRY*)(unsigned)>("glCreateShader");
    auto source=proc<void(APIENTRY*)(unsigned,int,const char*const*,const int*)>("glShaderSource");
    auto compile=proc<void(APIENTRY*)(unsigned)>("glCompileShader");
    auto create_program=proc<unsigned(APIENTRY*)()>("glCreateProgram");
    auto attach_shader=proc<void(APIENTRY*)(unsigned,unsigned)>("glAttachShader");
    auto link=proc<void(APIENTRY*)(unsigned)>("glLinkProgram");
    auto use=proc<void(APIENTRY*)(unsigned)>("glUseProgram");
    auto delete_program=proc<void(APIENTRY*)(unsigned)>("glDeleteProgram");
    auto delete_shader=proc<void(APIENTRY*)(unsigned)>("glDeleteShader");
    auto gen_arb=proc<void(APIENTRY*)(int,unsigned*)>("glGenProgramsARB");
    auto bind_arb=proc<void(APIENTRY*)(unsigned,unsigned)>("glBindProgramARB");
    auto upload_arb=proc<void(APIENTRY*)(unsigned,unsigned,int,const void*)>("glProgramStringARB");
    unsigned texture=0,fbo=0;
    glGenTextures(1,&texture);glBindTexture(GL_TEXTURE_2D,texture);
    glTexImage2D(GL_TEXTURE_2D,0,0x8814,32,32,0,GL_RGBA,GL_FLOAT,nullptr);
    gen(1,&fbo);bind(0x8D40,fbo);attach(0x8D40,0x8CE0,GL_TEXTURE_2D,texture,0);
    glDrawBuffer(0x8CE0);glReadBuffer(0x8CE0);
    if(status(0x8D40)!=0x8CD5) throw std::runtime_error("FBO incomplete");
    glViewport(0,0,32,32);
    clamp(0x891B,0);clamp(0x891C,0);
    if (parameters) {
      ParameterTests(dc, fbo, environment);
      bind(0x8D40, 0); SwapBuffers(dc);
      wglMakeCurrent(nullptr,nullptr);wglDeleteContext(context);ReleaseDC(window,dc);DestroyWindow(window);
      printf("RESULT failures=%d\n", failures);
      return failures ? 1 : 0;
    }
    for (const auto& test : {std::pair{glsl,capture?0.2f:2.f},std::pair{external,capture?0.4f:4.f},std::pair{bad,0.6f}}) {
      const auto shader=create_shader(0x8B30);
      const char* bytes=test.first.c_str();source(shader,1,&bytes,nullptr);compile(shader);
      const auto program=create_program();attach_shader(program,shader);link(program);use(program);
      triangle();check(test.first==glsl?"GLSL replacement":test.first==external?"external file mapping":"invalid replacement fallback",test.second);
      use(0);delete_program(program);delete_shader(shader);
    }
    unsigned program=0;gen_arb(1,&program);bind_arb(0x8804,program);
    upload_arb(0x8804,0x8875,static_cast<int>(arb.size()),arb.data());glEnable(0x8804);
    triangle();check("ARB replacement",capture?0.3f:3.f);glDisable(0x8804);
    clamp(0x891A,1);clamp(0x891B,1);
    glColor4f(4,0,0,1);
    const float fixed_expected=capture?1.f:clamp_only?4.f:5.f;
    triangle();check("fixed immediate",fixed_expected);
    const float vertices[]={-1,-1,3,-1,-1,3};
    glEnableClientState(GL_VERTEX_ARRAY);glVertexPointer(2,GL_FLOAT,0,vertices);
    glDrawArrays(GL_TRIANGLES,0,3);check("fixed arrays",fixed_expected);
    const unsigned short indices[]={0,1,2};
    glDrawElements(GL_TRIANGLES,3,GL_UNSIGNED_SHORT,indices);check("fixed indexed",fixed_expected);
    glDisableClientState(GL_VERTEX_ARRAY);
    const auto list=glGenLists(1);glNewList(list,GL_COMPILE);triangle();glEndList();glCallList(list);check("fixed display list",fixed_expected);
    int restored_program=-1,restored_vertex=-1,restored_fragment=-1;
    glGetIntegerv(0x8B8D,&restored_program);glGetIntegerv(0x891A,&restored_vertex);glGetIntegerv(0x891B,&restored_fragment);
    if(restored_program!=0 || restored_vertex!=1 || restored_fragment!=1){++failures;printf("FAIL state restoration\n");}else printf("PASS state restoration\n");
    bind(0x8D40,0);
    // Exercise ordinary presentation and teardown with the addon still loaded.
    SwapBuffers(dc);
    if(hdr) {
      glViewport(0,0,120,89);
      for(int frame=0;frame<3;++frame){
        glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT|GL_STENCIL_BUFFER_BIT);triangle();
        int draw_fbo=0,read_fbo=0;
        glGetIntegerv(0x8CA6,&draw_fbo);glGetIntegerv(0x8CAA,&read_fbo);
        if(draw_fbo){bind(0x8CA8,draw_fbo);glReadBuffer(0x8CE0);check("HDR scene above one before output",5.f);bind(0x8CA8,read_fbo);}
        else {printf("FAIL HDR scene still targets default framebuffer\n");++failures;}
        SwapBuffers(dc);
      }
      printf("HDR proxy presentation completed\n");
    }
    wglMakeCurrent(nullptr,nullptr);wglDeleteContext(context);ReleaseDC(window,dc);DestroyWindow(window);
    printf("RESULT failures=%d\n",failures);
    return failures?1:0;
  }catch(const std::exception& e){printf("FATAL %s\n",e.what());return 2;}
}
