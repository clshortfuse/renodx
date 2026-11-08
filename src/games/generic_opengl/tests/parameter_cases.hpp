#pragma once

// Included by smoke.cpp to reuse its isolated context, float FBO and assertions.
const std::string uniform_original = "#version 120\nuniform vec4 renodx_params[16];\nvoid main(){gl_FragColor=vec4(renodx_params[0].x+0.01,0,0,1);}\n";
const std::string uniform_replacement = "#version 120\nuniform vec4 renodx_params[16];\nvoid main(){gl_FragColor=vec4(renodx_params[0].x+renodx_params[1].x,0,0,1);}\n";
const std::string ubo_replacement = "#version 330 compatibility\nlayout(std140) uniform RenoDX { vec4 renodx_params[16]; };\nout vec4 color;\nvoid main(){color=vec4(renodx_params[0].x+renodx_params[1].x,0,0,1);}\n";
void ParameterProfile(bool environment) {
  const std::string compute_original = "#version 430\nlayout(local_size_x=1) in;layout(std430,binding=0) buffer Result {float result;};void main(){result=0.25;}\n";
  auto compute_key=key(compute_original,"glsl");compute_key.replace(compute_key.find(".ps."),4,".cs.");
  file("renodx-opengl/replacements/"+compute_key,"#version 430\nlayout(local_size_x=1) in;layout(std430,binding=0) buffer Result {float result;};layout(std140) uniform RenoDX {vec4 renodx_params[16];};void main(){result=renodx_params[0].x+renodx_params[1].x;}\n");
  file("renodx-opengl/parameter_values.json", "{\"exposure\":2}");
  file("renodx-opengl/replacements/"+key(glsl,"glsl"), ubo_replacement);
  file("renodx-opengl/replacements/"+key(uniform_original,"glsl"), uniform_replacement);
  file("renodx-opengl/replacements/"+key(arb,"arb"), std::string("!!ARBfp1.0\nADD result.color, program.")+(environment?"env":"local")+"[80], program."+(environment?"env":"local")+"[81];\nEND\n");
  file("renodx-opengl/fixed_parameters.glsl", uniform_replacement);
  file("renodx-opengl/profile.json", std::string(R"({"dump_shaders":true,"replace_shaders":true,"parameters":{"enabled":true,"ubo_binding":13,"arb_start":80,"arb_mode":")")+
    (environment?"env":"local")+R"(","values":[{"name":"exposure","value":2,"min":0,"max":10},{"name":"y"},{"name":"z"},{"name":"w"},{"name":"offset","value":3,"min":0,"max":10}]},"fixed_function":{"enabled":true,"fragment_shader":"fixed_parameters.glsl"}})");
}
void expect(const char* name, bool ok) {
  printf("%s %s\n", ok?"PASS":"FAIL",name);
  if(!ok) ++failures;
}
void ParameterTests(HDC dc, unsigned fbo, bool environment) {
#define GLPROC(Name, Return, ...) auto Name = proc<Return(APIENTRY*)(__VA_ARGS__)>("gl" #Name)
  GLPROC(CreateShader,unsigned,unsigned); GLPROC(ShaderSource,void,unsigned,int,const char*const*,const int*);
  GLPROC(CompileShader,void,unsigned); GLPROC(CreateProgram,unsigned); GLPROC(AttachShader,void,unsigned,unsigned);
  GLPROC(LinkProgram,void,unsigned); GLPROC(UseProgram,void,unsigned); GLPROC(GetProgramiv,void,unsigned,unsigned,int*);
  GLPROC(DeleteShader,void,unsigned); GLPROC(DeleteProgram,void,unsigned);
  GLPROC(GetUniformLocation,int,unsigned,const char*); GLPROC(Uniform4fv,void,int,int,const float*);
  GLPROC(GetUniformfv,void,unsigned,int,float*);
  GLPROC(GenBuffers,void,int,unsigned*); GLPROC(BindBuffer,void,unsigned,unsigned);
  GLPROC(BufferData,void,unsigned,ptrdiff_t,const void*,unsigned); GLPROC(BindBufferRange,void,unsigned,unsigned,unsigned,ptrdiff_t,ptrdiff_t);
  GLPROC(GetIntegeri_v,void,unsigned,unsigned,int*); GLPROC(GetInteger64i_v,void,unsigned,unsigned,int64_t*);
  GLPROC(GetUniformBlockIndex,unsigned,unsigned,const char*); GLPROC(UniformBlockBinding,void,unsigned,unsigned,unsigned);
  GLPROC(GetActiveUniformBlockiv,void,unsigned,unsigned,unsigned,int*); GLPROC(BindFramebuffer,void,unsigned,unsigned);
  GLPROC(DrawArraysInstanced,void,unsigned,int,int,int);
  GLPROC(GenProgramsARB,void,int,unsigned*); GLPROC(BindProgramARB,void,unsigned,unsigned);
  GLPROC(ProgramStringARB,void,unsigned,unsigned,int,const void*);
  GLPROC(ProgramLocalParameter4fvARB,void,unsigned,unsigned,const float*); GLPROC(ProgramEnvParameter4fvARB,void,unsigned,unsigned,const float*);
  GLPROC(GetProgramLocalParameterfvARB,void,unsigned,unsigned,float*); GLPROC(GetProgramEnvParameterfvARB,void,unsigned,unsigned,float*);
  GLPROC(DeleteProgramsARB,void,int,const unsigned*);
  GLPROC(DispatchCompute,void,unsigned,unsigned,unsigned); GLPROC(MemoryBarrier,void,unsigned);
  GLPROC(BindBufferBase,void,unsigned,unsigned,unsigned); GLPROC(GetBufferSubData,void,unsigned,ptrdiff_t,ptrdiff_t,void*);
#undef GLPROC
  auto program = [&](const std::string& text, unsigned stage=0x8B30) {
    auto shader=CreateShader(stage); const char* bytes=text.c_str();
    ShaderSource(shader,1,&bytes,nullptr);CompileShader(shader);
    auto result=CreateProgram();AttachShader(result,shader);LinkProgram(result);DeleteShader(shader);
    int linked=0;GetProgramiv(result,0x8B82,&linked); if(!linked) throw std::runtime_error("parameter program link failed");
    return result;
  };
  const auto uniform=program(uniform_original);
  UseProgram(uniform);
  const int location=GetUniformLocation(uniform,"renodx_params[0]");
  const float sentinel[8]={0.75f,0.5f,0.25f,1,0,0,0,0};
  Uniform4fv(location,2,sentinel);
  triangle();check("ordinary uniforms injected with vec4 packing",5);
  float restored[4]={};GetUniformfv(uniform,location,restored);
  expect("ordinary uniforms restored",restored[0]==0.75f && restored[1]==0.5f);
  const float vertices[]={-1,-1,3,-1,-1,3};
  glEnableClientState(GL_VERTEX_ARRAY);glVertexPointer(2,GL_FLOAT,0,vertices);
  DrawArraysInstanced(GL_TRIANGLES,0,3,1);check("instanced draw parameters",5);
  glDisableClientState(GL_VERTEX_ARRAY);

  const auto block_program=program(glsl);UseProgram(block_program);
  unsigned buffers[2]={};GenBuffers(2,buffers);
  int alignment=0;glGetIntegerv(0x8A34,&alignment);
  const int offset=alignment>256?alignment:256;
  BindBuffer(0x8A11,buffers[0]);BufferData(0x8A11,offset+256,nullptr,0x88E8);
  BindBufferRange(0x8A11,13,buffers[0],offset,256);
  BindBuffer(0x8A11,buffers[1]);BufferData(0x8A11,256,nullptr,0x88E8);
  const auto block=GetUniformBlockIndex(block_program,"RenoDX");UniformBlockBinding(block_program,block,3);
  triangle();check("UBO parameters injected",5);
  int indexed=0,generic=0,binding=0;int64_t start=0,size=0;
  GetIntegeri_v(0x8A28,13,&indexed);glGetIntegerv(0x8A28,&generic);
  GetInteger64i_v(0x8A29,13,&start);GetInteger64i_v(0x8A2A,13,&size);
  GetActiveUniformBlockiv(block_program,block,0x8A3F,&binding);
  expect("UBO indexed range, generic binding and block mapping restored",indexed==buffers[0]&&generic==buffers[1]&&start==offset&&size==256&&binding==3);

  file("renodx-opengl/parameter_values.json","{\"exposure\":4}");Sleep(550);
  BindFramebuffer(0x8D40,0);SwapBuffers(dc);BindFramebuffer(0x8D40,fbo);glViewport(0,0,32,32);
  UseProgram(block_program);triangle();check("live UBO update without relink",7);
  UseProgram(uniform);triangle();check("live uniform update without relink",7);
  file("renodx-opengl/parameter_values.json","{\"exposure\":1000,\"offset\":1}");Sleep(550);
  BindFramebuffer(0x8D40,0);SwapBuffers(dc);BindFramebuffer(0x8D40,fbo);glViewport(0,0,32,32);
  UseProgram(uniform);triangle();check("invalid live values rejected atomically",7);

  const auto unmatched=program("#version 120\nuniform vec4 renodx_params[16];void main(){gl_FragColor=renodx_params[0];}\n");
  UseProgram(unmatched);Uniform4fv(GetUniformLocation(unmatched,"renodx_params[0]"),1,sentinel);
  triangle();check("unmatched native program untouched",0.75f);
  UseProgram(0);
  unsigned assembly=0;GenProgramsARB(1,&assembly);BindProgramARB(0x8804,assembly);
  ProgramStringARB(0x8804,0x8875,static_cast<int>(arb.size()),arb.data());
  auto set=environment?ProgramEnvParameter4fvARB:ProgramLocalParameter4fvARB;
  auto get=environment?GetProgramEnvParameterfvARB:GetProgramLocalParameterfvARB;
  set(0x8804,80,sentinel);set(0x8804,81,sentinel);glEnable(0x8804);
  triangle();check(environment?"ARB environment injection":"ARB local injection",7);
  get(0x8804,80,restored);expect("ARB parameters restored",restored[0]==0.75f&&restored[1]==0.5f);
  glDisable(0x8804);DeleteProgramsARB(1,&assembly);
  triangle();check("private fixed-function shader parameters",7);
  const auto compute=program("#version 430\nlayout(local_size_x=1) in;layout(std430,binding=0) buffer Result {float result;};void main(){result=0.25;}\n",0x91B9);
  unsigned storage=0;GenBuffers(1,&storage);BindBuffer(0x90D2,storage);BufferData(0x90D2,4,nullptr,0x88E8);BindBufferBase(0x90D2,0,storage);
  UseProgram(compute);DispatchCompute(1,1,1);MemoryBarrier(0x200);float result=0;GetBufferSubData(0x90D2,0,4,&result);
  expect("compute dispatch UBO injection",std::abs(result-7)<0.001f && glGetError()==0);
  UseProgram(0);DeleteProgram(compute);
  DeleteProgram(uniform);DeleteProgram(block_program);DeleteProgram(unmatched);
  expect("no GL error after cleanup",glGetError()==0);
}
