#pragma once
#include <Windows.h>
#include <d3d9.h>
#ifndef MW3_HALF_STANDALONE
#include <include/reshade.hpp>
#else
#include "logger.hpp"
#endif
#include <mutex>
#include <atomic>
#include <cstdint>
#include <cstring>
#include <cstdio>
#include "hook_transaction.hpp"

namespace half_filter {
using EngineFn=void(*)(void*,void*);
EngineFn execute=nullptr,draw_material=nullptr;
using DrawFn=HRESULT(WINAPI*)(IDirect3DDevice9*,D3DPRIMITIVETYPE,UINT,UINT);
using IndexedFn=HRESULT(WINAPI*)(IDirect3DDevice9*,D3DPRIMITIVETYPE,INT,UINT,UINT,UINT,UINT);
using UpFn=HRESULT(WINAPI*)(IDirect3DDevice9*,D3DPRIMITIVETYPE,UINT,const void*,UINT);
using IndexedUpFn=HRESULT(WINAPI*)(IDirect3DDevice9*,D3DPRIMITIVETYPE,UINT,UINT,UINT,const void*,D3DFORMAT,const void*,UINT);
DrawFn raw_draw=nullptr;IndexedFn raw_indexed=nullptr;UpFn raw_up=nullptr;IndexedUpFn raw_indexed_up=nullptr;
std::recursive_mutex mutex;
IDirect3DDevice9* gpu=nullptr;
std::atomic<bool> enabled=true,installed=false,attempted=false;bool key_down=false,announced=false;
HMODULE module=nullptr;
template<class T> void Release(T*& p){if(p)p->Release();p=nullptr;}
struct Buffer {IDirect3DTexture9* texture=nullptr;IDirect3DSurface9* surface=nullptr;UINT w=0,h=0;D3DFORMAT format=D3DFMT_UNKNOWN;
 void Clear(){Release(surface);Release(texture);w=h=0;format=D3DFMT_UNKNOWN;}
};
Buffer buffers[2][3];
void Log(const char* text){
#ifdef MW3_HALF_STANDALONE
optimizer_log::message(optimizer_log::level::info,text);
#else
reshade::log::message(reshade::log::level::info,text);
#endif
}
Buffer* GetBuffer(unsigned index,const D3DSURFACE_DESC& d){
 unsigned format=d.Format==D3DFMT_A8R8G8B8?0:d.Format==D3DFMT_X8R8G8B8?1:d.Format==D3DFMT_A16B16G16R16F?2:3;
 if(format==3||d.MultiSampleType!=D3DMULTISAMPLE_NONE||d.Width<2560||d.Height<1440)return nullptr;
 auto& b=buffers[index&1][format];const UINT w=(d.Width+1)/2,h=(d.Height+1)/2;
 if(b.surface && b.w==w && b.h==h)return &b;
 b.Clear();
 if(FAILED(gpu->CreateTexture(w,h,1,D3DUSAGE_RENDERTARGET,d.Format,D3DPOOL_DEFAULT,&b.texture,nullptr))||!b.texture)return nullptr;
 if(FAILED(b.texture->GetSurfaceLevel(0,&b.surface))||!b.surface){b.Clear();return nullptr;}
 b.w=w;b.h=h;b.format=d.Format;return &b;
}
struct Context {unsigned count=0,index=0;IDirect3DTexture9* previous=nullptr;unsigned reduced=0;bool caps_checked=false,caps_valid=false;DWORD mrt_count=0;};
thread_local Context* context=nullptr;
struct Override {
 IDirect3DSurface9 *target=nullptr,*depth=nullptr;IDirect3DBaseTexture9* texture=nullptr;
 D3DVIEWPORT9 viewport{};RECT scissor{};DWORD min_filter=0,mag_filter=0,mip_filter=0;
 bool captured=false,applied=false;unsigned callbacks=0;
 IDirect3DTexture9* next_source=nullptr;
 bool half=false;
 bool changed_target=false,changed_depth=false,changed_view=false,changed_scissor=false,changed_texture=false;
 bool changed_min=false,changed_mag=false,changed_mip=false;
 void Restore(){
  if(changed_target)gpu->SetRenderTarget(0,target);
  if(changed_depth)gpu->SetDepthStencilSurface(depth);
  if(changed_view)gpu->SetViewport(&viewport);
  if(changed_scissor)gpu->SetScissorRect(&scissor);
  if(changed_texture)gpu->SetTexture(0,texture);
  if(changed_min)gpu->SetSamplerState(0,D3DSAMP_MINFILTER,min_filter);
  if(changed_mag)gpu->SetSamplerState(0,D3DSAMP_MAGFILTER,mag_filter);
  if(changed_mip)gpu->SetSamplerState(0,D3DSAMP_MIPFILTER,mip_filter);
  changed_target=changed_depth=changed_view=changed_scissor=changed_texture=false;
  changed_min=changed_mag=changed_mip=false;
  Release(target);Release(depth);Release(texture);captured=applied=false;
 }
 ~Override(){Restore();}
};
thread_local Override* current_override=nullptr;
bool Capture(Override& s){
 if(FAILED(gpu->GetRenderTarget(0,&s.target))||!s.target)return false;
 // A missing depth surface is normal in a post-processing pass.
 HRESULT hr=gpu->GetDepthStencilSurface(&s.depth);if(FAILED(hr)&&hr!=D3DERR_NOTFOUND)return false;
 if(FAILED(gpu->GetTexture(0,&s.texture))||FAILED(gpu->GetViewport(&s.viewport))||FAILED(gpu->GetScissorRect(&s.scissor)))return false;
 if(context->previous && (FAILED(gpu->GetSamplerState(0,D3DSAMP_MINFILTER,&s.min_filter))||FAILED(gpu->GetSamplerState(0,D3DSAMP_MAGFILTER,&s.mag_filter))||FAILED(gpu->GetSamplerState(0,D3DSAMP_MIPFILTER,&s.mip_filter))))return false;
 s.captured=true;return true;
}
void Apply(){
 if(!context||!current_override||!gpu)return;
 auto& c=*context;auto& s=*current_override;
 // The inspected native material draw is a single fullscreen draw.
 // Each raw draw restores state before returning to the material wrapper.
 ++s.callbacks;s.next_source=nullptr;s.half=false;if(!Capture(s))return;
 D3DSURFACE_DESC desc{};if(FAILED(s.target->GetDesc(&desc)))return;
 IDirect3DTexture9* source=c.previous;s.next_source=nullptr;s.half=false;
 bool can_half=c.index+1<c.count && s.viewport.X==0 && s.viewport.Y==0 && s.viewport.Width==desc.Width && s.viewport.Height==desc.Height;
 DWORD z=1,stencil=1;
 if(FAILED(gpu->GetRenderState(D3DRS_ZENABLE,&z))||FAILED(gpu->GetRenderState(D3DRS_STENCILENABLE,&stencil))||z||stencil)can_half=false;
 if(can_half){
  if(!c.caps_checked){D3DCAPS9 caps{};c.caps_valid=SUCCEEDED(gpu->GetDeviceCaps(&caps));c.mrt_count=caps.NumSimultaneousRTs;c.caps_checked=true;}
  if(!c.caps_valid)can_half=false;
  for(unsigned i=1;can_half && i<c.mrt_count;++i){IDirect3DSurface9* extra=nullptr;const auto hr=gpu->GetRenderTarget(i,&extra);if(extra){extra->Release();can_half=false;}else if(FAILED(hr)&&hr!=D3DERR_NOTFOUND)can_half=false;}
 }
 Buffer* output=can_half?GetBuffer(c.index,desc):nullptr;
 // Even when this pass falls back to full size, it must consume the previous
 // half-size result. After that, the engine's original texture is current again.
 if(!source && !output)return;
 s.applied=true;
 if(source){
  if(s.texture!=source){if(FAILED(gpu->SetTexture(0,source)))return;s.changed_texture=true;}
  if(s.min_filter!=D3DTEXF_LINEAR)s.changed_min=SUCCEEDED(gpu->SetSamplerState(0,D3DSAMP_MINFILTER,D3DTEXF_LINEAR));
  if(s.mag_filter!=D3DTEXF_LINEAR)s.changed_mag=SUCCEEDED(gpu->SetSamplerState(0,D3DSAMP_MAGFILTER,D3DTEXF_LINEAR));
  if(s.mip_filter!=D3DTEXF_NONE)s.changed_mip=SUCCEEDED(gpu->SetSamplerState(0,D3DSAMP_MIPFILTER,D3DTEXF_NONE));
 }
 if(output){
  D3DVIEWPORT9 vp=s.viewport;vp.Width=output->w;vp.Height=output->h;
  RECT rect{ s.scissor.left/2,s.scissor.top/2,(s.scissor.right+1)/2,(s.scissor.bottom+1)/2 };
  bool ok=true;
  if(s.depth){ok=SUCCEEDED(gpu->SetDepthStencilSurface(nullptr));s.changed_depth=ok;}
  if(ok){ok=SUCCEEDED(gpu->SetRenderTarget(0,output->surface));s.changed_target=ok;s.changed_view=ok;}
  if(ok)ok=SUCCEEDED(gpu->SetViewport(&vp));
  if(ok && memcmp(&rect,&s.scissor,sizeof(rect))!=0){ok=SUCCEEDED(gpu->SetScissorRect(&rect));s.changed_scissor=ok;}
  if(ok){s.next_source=output->texture;s.half=true;}
  else{
   if(s.changed_target)gpu->SetRenderTarget(0,s.target);
   if(s.changed_depth)gpu->SetDepthStencilSurface(s.depth);
   if(s.changed_view)gpu->SetViewport(&s.viewport);
   if(s.changed_scissor)gpu->SetScissorRect(&s.scissor);
   s.changed_target=s.changed_depth=s.changed_view=s.changed_scissor=false;
  }
 }
}
thread_local unsigned raw_depth=0;
std::atomic<unsigned> rejected_draw_recursion{0};
template<class F> HRESULT Invoke(IDirect3DDevice9* d,F&& f){
#ifndef MW3_HALF_STANDALONE
 mw3_bloom::NativeDrawScope bloom_scope(d);
#endif
 // Guard every entry, including calls outside a half-filter pass. A cyclic
 // external draw-hook chain must fail the draw instead of exhausting the stack.
 if(raw_depth>=8){rejected_draw_recursion.fetch_add(1,std::memory_order_relaxed);return D3DERR_INVALIDCALL;}
 struct DepthScope {DepthScope(){++raw_depth;} ~DepthScope(){--raw_depth;}} depth_scope;
 if(!context||!current_override||d!=gpu||raw_depth>1)return f();
 const DWORD incoming=GetLastError();Apply();SetLastError(incoming);
 const HRESULT hr=f();const DWORD outgoing=GetLastError();current_override->Restore();
 if(SUCCEEDED(hr)&&current_override->half)++context->reduced;
 if(FAILED(hr))current_override->next_source=nullptr;SetLastError(outgoing);return hr;
}
HRESULT WINAPI RawDraw(IDirect3DDevice9* d,D3DPRIMITIVETYPE t,UINT a,UINT b){return Invoke(d,[&]{return raw_draw(d,t,a,b);});}
HRESULT WINAPI RawIndexed(IDirect3DDevice9* d,D3DPRIMITIVETYPE t,INT a,UINT b,UINT c,UINT e,UINT f){return Invoke(d,[&]{return raw_indexed(d,t,a,b,c,e,f);});}
HRESULT WINAPI RawUp(IDirect3DDevice9* d,D3DPRIMITIVETYPE t,UINT a,const void* b,UINT c){return Invoke(d,[&]{return raw_up(d,t,a,b,c);});}
HRESULT WINAPI RawIndexedUp(IDirect3DDevice9* d,D3DPRIMITIVETYPE t,UINT a,UINT b,UINT c,const void* e,D3DFORMAT f,const void* g,UINT h){return Invoke(d,[&]{return raw_indexed_up(d,t,a,b,c,e,f,g,h);});}
void HookDraw(void* material,void* view){
 if(!context){draw_material(material,view);return;}
 const DWORD incoming=GetLastError();Override state;auto* outer=current_override;current_override=&state;
 SetLastError(incoming);draw_material(material,view);const DWORD outgoing=GetLastError();
 current_override=outer;state.Restore();context->previous=state.next_source;++context->index;SetLastError(outgoing);
}
void HookExecute(void* list,void* view){
 if(!enabled.load()||context){execute(list,view);return;}
 const DWORD incoming=GetLastError();std::scoped_lock lock(mutex);
 unsigned count=0,destination=0;memcpy(&count,list,4);memcpy(&destination,static_cast<uint8_t*>(list)+0x1210,4);
 if(!gpu || count<4 || count>32 || (destination!=8 && destination!=9)){SetLastError(incoming);execute(list,view);return;}
 Context scope{count};context=&scope;
 SetLastError(incoming);execute(list,view);const DWORD outgoing=GetLastError();context=nullptr;
 if(!announced && scope.reduced){announced=true;char text[200]{};sprintf_s(text,"[MW3 Half Filter V2] ACTIVE: %u intermediate draw(s) reduced in a %u-pass filter; final output kept full resolution.",scope.reduced,count);Log(text);}
 SetLastError(outgoing);
}
bool Verify(uintptr_t base){
 const auto* dos=reinterpret_cast<IMAGE_DOS_HEADER*>(base);if(dos->e_magic!=IMAGE_DOS_SIGNATURE)return false;
 const auto* nt=reinterpret_cast<IMAGE_NT_HEADERS64*>(base+dos->e_lfanew);
 if(nt->Signature!=IMAGE_NT_SIGNATURE||nt->FileHeader.Machine!=IMAGE_FILE_MACHINE_AMD64||nt->FileHeader.TimeDateStamp!=0x6A743A58||nt->OptionalHeader.SizeOfImage!=0x044BE000)return false;
 const uint8_t filter[]={0x40,0x56,0x48,0x81,0xec,0x80,0,0,0};
 const uint8_t draw[]={0x48,0x89,0x5c,0x24,0x08,0x57,0x48,0x81,0xec,0xb0,0,0,0};
 return !memcmp(reinterpret_cast<void*>(base+0x18eec0),filter,sizeof(filter))&&!memcmp(reinterpret_cast<void*>(base+0x189990),draw,sizeof(draw));
}
void Install(IDirect3DDevice9* native){
 if(attempted.exchange(true))return;const auto base=reinterpret_cast<uintptr_t>(GetModuleHandleW(nullptr));
 if(!Verify(base)){Log("[MW3 Half Filter V2] Executable identity/signatures do not match; no hooks installed.");return;}
 execute=reinterpret_cast<EngineFn>(base+0x18eec0);draw_material=reinterpret_cast<EngineFn>(base+0x189990);
 auto** vtable=*reinterpret_cast<void***>(native);
 for(unsigned i=81;i<=84;++i){
  if(!vtable[i]){Log("[MW3 Hook Safety] Null draw target; half-filter hooks skipped.");return;}
  for(unsigned j=81;j<i;++j)if(vtable[i]==vtable[j]){
   Log("[MW3 Hook Safety] Aliased draw targets; half-filter hooks skipped.");return;
  }
 }
 raw_draw=reinterpret_cast<DrawFn>(vtable[81]);raw_indexed=reinterpret_cast<IndexedFn>(vtable[82]);raw_up=reinterpret_cast<UpFn>(vtable[83]);raw_indexed_up=reinterpret_cast<IndexedUpFn>(vtable[84]);
 HMODULE pinned=nullptr;if(!GetModuleHandleExW(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS|GET_MODULE_HANDLE_EX_FLAG_PIN,reinterpret_cast<LPCWSTR>(&HookExecute),&pinned))return;
 LONG status=hook_transaction::Begin();if(status==NO_ERROR){status=hook_transaction::Attach(reinterpret_cast<PVOID*>(&execute),reinterpret_cast<PVOID>(&HookExecute));
  if(status==NO_ERROR)status=hook_transaction::Attach(reinterpret_cast<PVOID*>(&draw_material),reinterpret_cast<PVOID>(&HookDraw));
  if(status==NO_ERROR)status=hook_transaction::Attach(reinterpret_cast<PVOID*>(&raw_draw),reinterpret_cast<PVOID>(&RawDraw));
  if(status==NO_ERROR)status=hook_transaction::Attach(reinterpret_cast<PVOID*>(&raw_indexed),reinterpret_cast<PVOID>(&RawIndexed));
  if(status==NO_ERROR)status=hook_transaction::Attach(reinterpret_cast<PVOID*>(&raw_up),reinterpret_cast<PVOID>(&RawUp));
  if(status==NO_ERROR)status=hook_transaction::Attach(reinterpret_cast<PVOID*>(&raw_indexed_up),reinterpret_cast<PVOID>(&RawIndexedUp));
  if(status==NO_ERROR)status=hook_transaction::Commit();else hook_transaction::Abort();}
 installed=status==NO_ERROR;Log(installed?"[MW3 Half Filter V2] Ready. F8 toggles intermediate half-resolution filtering. No Tracy; V36/pacing untouched.":"[MW3 Half Filter V2] Hook transaction failed and was rolled back.");
}
void Clear(){for(auto& pair:buffers)for(auto& b:pair)b.Clear();announced=false;}
void Start(IDirect3DDevice9* d){Install(d);std::scoped_lock lock(mutex);if(gpu!=d){Clear();gpu=d;}}
void BeforeReset(IDirect3DDevice9* d){std::scoped_lock lock(mutex);if(d==gpu)Clear();}
void Toggle(){const bool down=(GetAsyncKeyState(VK_F8)&0x8000)!=0;if(down&&!key_down){enabled=!enabled.load();Log(enabled?"[MW3 Half Filter V2] F8: ON":"[MW3 Half Filter V2] F8: OFF");}key_down=down;}
#ifndef MW3_HALF_STANDALONE
reshade::api::device* device=nullptr;
void Init(reshade::api::device* d){if(d->get_api()!=reshade::api::device_api::d3d9)return;Start(reinterpret_cast<IDirect3DDevice9*>(d->get_native()));device=d;}
void Destroy(reshade::api::device* d){std::scoped_lock lock(mutex);if(d==device){Clear();gpu=nullptr;device=nullptr;}}
void DestroySwapchain(reshade::api::swapchain* s,bool){if(s->get_device()==device)BeforeReset(gpu);}
void Present(reshade::api::command_queue* q,reshade::api::swapchain*,const reshade::api::rect*,const reshade::api::rect*,uint32_t,const reshade::api::rect*){
 if(q->get_device()==device){
  Toggle();
  if(rejected_draw_recursion.exchange(0,std::memory_order_relaxed))
   Log("[MW3 Hook Safety] Excessive native draw recursion blocked; check other draw interceptors.");
 }
}
#endif
}
