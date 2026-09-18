#pragma once
// Public Tracy plots only. No custom/internal GPU queue protocol.
#include <d3d9.h>
#include <d3d11.h>
#include <array>
#include <mutex>
#include <cstdint>
#include "mw3_gpu_sample.hpp"

namespace mw3_gpu_timing {
constexpr unsigned kDrawsPerGroup=1024, kFrames=6, kQueries=20, kGroups=8, kBlits=4, kDevices=2;
struct Query {
  IDirect3DQuery9* dx9=nullptr;
  ID3D11Query* dx11=nullptr;
  void Release() { if(dx9) dx9->Release(); if(dx11) dx11->Release(); dx9=nullptr; dx11=nullptr; }
};
struct Pair { int begin=-1,end=-1; };
struct Batch {
  Query disjoint,frequency;
  std::array<Query,kQueries> timestamps{};
  std::array<Pair,kGroups> groups{};
  std::array<Pair,kBlits> blits{};
  unsigned count=0,groupCount=0,blitCount=0,draws=0;
  int groupStart=0,frameEnd=-1;
  uint64_t ticket=0,present=0;
  int64_t cpuStart=0,cpuEnd=0,previousPresent=0;
  bool pending=false,bad=false;
  void Release() {
    disjoint.Release(); frequency.Release();
    for(auto& q:timestamps) q.Release();
    *this=Batch{};
  }
  void Recycle() { count=groupCount=blitCount=draws=0; groupStart=0; frameEnd=-1;
    ticket=present=0; pending=bad=false; groups={}; blits={}; }
};
struct State {
  reshade::api::device* key=nullptr;
  IDirect3DDevice9* dx9=nullptr;
  ID3D11Device* dx11=nullptr;
  ID3D11DeviceContext* context=nullptr; // borrowed immediate context, never deferred
  DWORD owner=0;
  std::array<Batch,kFrames> batches{};
  int active=-1;
  uint64_t connection=0,presents=0,dropped=0,epoch=0;
  int64_t previousPresent=0;
  bool disabled=false,logged=false,skipUntilPresent=false;
};
inline std::array<State,kDevices> g_states{};
inline std::mutex g_mutex;
inline uint64_t g_epoch=0,g_ticket=0;
inline int64_t CpuNow() { LARGE_INTEGER q{}; QueryPerformanceCounter(&q); return q.QuadPart; }
inline double CpuMs(int64_t delta) { static const int64_t f=[] { LARGE_INTEGER q{};QueryPerformanceFrequency(&q);return q.QuadPart;}();return f>0?static_cast<double>(delta)*1000.0/f:0; }
inline bool Connected() { return tracy::GetProfiler().IsConnected(); }
inline uint64_t Connection() { return tracy::GetProfiler().ConnectionId(); }
inline void Clear(State& s) {
  for(auto& b:s.batches) b.Release();
  s=State{}; s.epoch=++g_epoch;
}
inline void Disable(State& s) {
  for(auto& b:s.batches) b.Release();
  s.active=-1; s.disabled=true;
  reshade::log::message(reshade::log::level::warning,
      "[MW3 GPU V5] GPU query failure/unsupported queries; timing paused for this device until reset.");
}
inline State* Find(reshade::api::device* device) {
  if(!device) return nullptr;
  for(auto& s:g_states) if(s.key==device) return &s;
  return nullptr;
}
inline State* Get(reshade::api::command_list* cmd) {
  if(!cmd) return nullptr;
  auto* device=cmd->get_device();
  if(!device) return nullptr;
  const auto api=device->get_api();
  if(api!=reshade::api::device_api::d3d9 && api!=reshade::api::device_api::d3d11) return nullptr;
  ID3D11DeviceContext* context=nullptr;
  if(api==reshade::api::device_api::d3d11) {
    context=reinterpret_cast<ID3D11DeviceContext*>(cmd->get_native());
    if(!context || context->GetType()!=D3D11_DEVICE_CONTEXT_IMMEDIATE) return nullptr;
  }
  State* s=Find(device);
  if(!s) {
    for(auto& candidate:g_states) if(candidate.key && ((api==reshade::api::device_api::d3d9 && candidate.dx9) || (api==reshade::api::device_api::d3d11 && candidate.dx11))) return nullptr;
    for(auto& candidate:g_states) if(!candidate.key) { s=&candidate; break; }
    if(!s) return nullptr;
    s->key=device; s->owner=GetCurrentThreadId(); s->epoch=++g_epoch;
    if(api==reshade::api::device_api::d3d9) s->dx9=reinterpret_cast<IDirect3DDevice9*>(device->get_native());
    else { s->dx11=reinterpret_cast<ID3D11Device*>(device->get_native()); s->context=context; }
  }
  if(s->owner!=GetCurrentThreadId() || (s->dx11 && s->context!=context)) {
    if(s->active>=0) s->batches[s->active].bad=true;
    ++s->dropped; return nullptr; // No GPU calls from a different rendering thread.
  }
  return s;
}
inline bool Create(State& s,Query& q,int type) {
  // type 0 timestamp, 1 disjoint, 2 frequency (D3D9 only)
  if(s.dx9) {
    if(q.dx9) return true;
    const D3DQUERYTYPE t=type==0?D3DQUERYTYPE_TIMESTAMP:type==1?D3DQUERYTYPE_TIMESTAMPDISJOINT:D3DQUERYTYPE_TIMESTAMPFREQ;
    return SUCCEEDED(s.dx9->CreateQuery(t,&q.dx9)) && q.dx9;
  }
  if(q.dx11) return true;
  D3D11_QUERY_DESC desc={type==0?D3D11_QUERY_TIMESTAMP:D3D11_QUERY_TIMESTAMP_DISJOINT,0};
  return s.dx11 && SUCCEEDED(s.dx11->CreateQuery(&desc,&q.dx11)) && q.dx11;
}
inline bool Issue(State& s,Query& q,bool begin=false) {
  if(s.dx9) return q.dx9 && SUCCEEDED(q.dx9->Issue(begin?D3DISSUE_BEGIN:D3DISSUE_END));
  if(!q.dx11 || !s.context) return false;
  if(begin) s.context->Begin(q.dx11); else s.context->End(q.dx11);
  return true;
}
inline HRESULT Read(State& s,Query& q,void* out,unsigned size) {
  return s.dx9?q.dx9->GetData(out,size,0):s.context->GetData(q.dx11,out,size,D3D11_ASYNC_GETDATA_DONOTFLUSH);
}
inline int Stamp(State& s,Batch& b) {
  if(b.count==kQueries) { b.bad=true; return -1; }
  const unsigned index=b.count;
  if(!Create(s,b.timestamps[index],0) || !Issue(s,b.timestamps[index])) { b.bad=true; return -1; }
  ++b.count; return static_cast<int>(index);
}
inline Batch* Begin(State& s) {
  if(s.disabled || s.skipUntilPresent) return nullptr;
  if(s.active>=0) return &s.batches[s.active];
  for(unsigned i=0;i<kFrames;++i) {
    auto& b=s.batches[i]; if(b.pending) continue;
    b.Recycle();
    if(!Create(s,b.disjoint,1) || (s.dx9 && !Create(s,b.frequency,2)) || !Issue(s,b.disjoint,true)) { Disable(s); return nullptr; }
    b.ticket=++g_ticket; b.cpuStart=CpuNow();b.previousPresent=s.previousPresent;
    if(Stamp(s,b)<0) { Disable(s); return nullptr; }
    s.active=static_cast<int>(i);
    if(!s.logged) { s.logged=true; reshade::log::message(reshade::log::level::info,
      s.dx9?"[MW3 GPU V5] D3D9 timestamp plots active; asynchronous collection, 6-frame pool."
           :"[MW3 GPU V5] D3D11 immediate-context timestamp plots active; asynchronous collection."); }
    return &b;
  }
  ++s.dropped; s.skipUntilPresent=true; return nullptr; // Backpressure: never reuse a pending batch.
}
inline void Group(State& s,Batch& b,int end) {
  if(b.groupCount<kGroups && b.groupStart>=0 && end>=0) {
    b.groups[b.groupCount++]={b.groupStart,end}; b.groupStart=end;
  }
}
inline void Draw(reshade::api::command_list* cmd) {
  if(!Connected()) return;
  std::scoped_lock lock(g_mutex);
  State* s=Get(cmd); if(!s || s->disabled) return;
  // Connection changes discard old objects, including unfinished queries.
  if(s->connection!=Connection()) {
    for(auto& b:s->batches) b.Release();
    s->active=-1; s->skipUntilPresent=false; s->connection=Connection(); s->epoch=++g_epoch;
  }
  Batch* b=Begin(*s); if(!b) return;
  if(b->draws && b->draws%kDrawsPerGroup==0 && b->groupCount<kGroups) Group(*s,*b,Stamp(*s,*b));
  ++b->draws;
}
inline bool OnDraw(reshade::api::command_list* cmd,uint32_t,uint32_t,uint32_t,uint32_t) { Draw(cmd); return false; }
inline bool OnDrawIndexed(reshade::api::command_list* cmd,uint32_t,uint32_t,uint32_t,int32_t,uint32_t) { Draw(cmd); return false; }
inline void Publish(State& s,Batch& b,const std::array<uint64_t,kQueries>& times,uint64_t frequency) {
  double ms=0;
  if(b.frameEnd<0 || !mw3_gpu_sample::Milliseconds(times[0],times[b.frameEnd],frequency,false,ms)) return;
  TracyPlot(s.dx9?"MW3/GPU D3D9 observed draw span ms":"MW3/GPU D3D11 observed draw span ms",ms);
  TracyPlot(s.dx9?"MW3/GPU D3D9 draw callbacks":"MW3/GPU D3D11 draw callbacks",static_cast<double>(b.draws));
  TracyPlot(s.dx9?"MW3/GPU D3D9 sample age frames":"MW3/GPU D3D11 sample age frames",static_cast<double>(s.presents-b.present));
  TracyPlot(s.dx9?"MW3/GPU D3D9 sampled present":"MW3/GPU D3D11 sampled present",static_cast<double>(b.present));
  static constexpr const char* names9[kGroups]={"MW3/GPU D3D9 group 0 ms","MW3/GPU D3D9 group 1 ms","MW3/GPU D3D9 group 2 ms","MW3/GPU D3D9 group 3 ms","MW3/GPU D3D9 group 4 ms","MW3/GPU D3D9 group 5 ms","MW3/GPU D3D9 group 6 ms","MW3/GPU D3D9 group 7 ms"};
  static constexpr const char* names11[kGroups]={"MW3/GPU D3D11 group 0 ms","MW3/GPU D3D11 group 1 ms","MW3/GPU D3D11 group 2 ms","MW3/GPU D3D11 group 3 ms","MW3/GPU D3D11 group 4 ms","MW3/GPU D3D11 group 5 ms","MW3/GPU D3D11 group 6 ms","MW3/GPU D3D11 group 7 ms"};
  for(unsigned i=0;i<b.groupCount;++i) {
    const auto pair=b.groups[i];
    if(mw3_gpu_sample::Milliseconds(times[pair.begin],times[pair.end],frequency,false,ms)) TracyPlot(s.dx9?names9[i]:names11[i],ms);
  }
  if(b.previousPresent>0 && b.cpuStart>=b.previousPresent)
    TracyPlot(s.dx9?"MW3/CPU D3D9 before first observed draw ms":"MW3/CPU D3D11 before first observed draw ms",CpuMs(b.cpuStart-b.previousPresent));
  if(b.cpuEnd>=b.cpuStart)
    TracyPlot(s.dx9?"MW3/CPU D3D9 observed submission span ms":"MW3/CPU D3D11 observed submission span ms",CpuMs(b.cpuEnd-b.cpuStart));
  const int tailStart=b.groupCount?b.groups[b.groupCount-1].end:0;
  if(mw3_gpu_sample::Milliseconds(times[tailStart],times[b.frameEnd],frequency,false,ms))
    TracyPlot(s.dx9?"MW3/GPU D3D9 ungrouped tail ms":"MW3/GPU D3D11 ungrouped tail ms",ms);
  double blitTotal=0; unsigned complete=0;
  for(unsigned i=0;i<b.blitCount;++i) {
    const auto pair=b.blits[i];
    if(pair.begin>=0 && pair.end>=0 && mw3_gpu_sample::Milliseconds(times[pair.begin],times[pair.end],frequency,false,ms)) {blitTotal+=ms;++complete;}
  }
  if(complete) { TracyPlot("MW3/GPU D3D9 sampled readback blits ms",blitTotal); TracyPlot("MW3/GPU D3D9 sampled readback blits",static_cast<double>(complete)); }
}
inline void Poll(State& s) {
  // Oldest first: each pass checks a batch at most once; no readiness loop.
  for(unsigned pass=0;pass<kFrames;++pass) {
    Batch* oldest=nullptr;
    for(auto& b:s.batches) if(b.pending && (!oldest || b.ticket<oldest->ticket)) oldest=&b;
    if(!oldest) break;
    auto& b=*oldest;
    if(s.presents<=b.present) break; // Do not collect the frame just closed.
    uint64_t frequency=0; bool disjoint=true; HRESULT status;
    if(s.dx9) {
      BOOL invalid=TRUE;
      status=Read(s,b.disjoint,&invalid,sizeof(invalid));
      if(status==S_OK) {disjoint=invalid!=FALSE; status=Read(s,b.frequency,&frequency,sizeof(frequency));}
    } else {
      D3D11_QUERY_DATA_TIMESTAMP_DISJOINT data{};
      status=Read(s,b.disjoint,&data,sizeof(data));
      if(status==S_OK) {disjoint=data.Disjoint!=FALSE;frequency=data.Frequency;}
    }
    if(status==S_FALSE) break;
    if(FAILED(status)) { Disable(s); return; }
    if(disjoint || !frequency || b.bad) { ++s.dropped; b.Release(); continue; }
    std::array<uint64_t,kQueries> values{};
    bool failure=false;
    const auto result=mw3_gpu_sample::Resolve(b.count,[&](size_t i,uint64_t& value) {
      const HRESULT hr=Read(s,b.timestamps[i],&value,sizeof(value));
      if(FAILED(hr)) failure=true;
      return hr==S_OK?mw3_gpu_sample::Result::Ready:hr==S_FALSE?mw3_gpu_sample::Result::Pending:mw3_gpu_sample::Result::Invalid;
    },values.data());
    if(failure) { Disable(s); return; }
    if(result==mw3_gpu_sample::Result::Pending) break;
    if(result==mw3_gpu_sample::Result::Ready && Connected() && s.connection==Connection()) Publish(s,b,values,frequency); else ++s.dropped;
    b.Recycle();
  }
}
inline void Finish(State* s) {
  const int64_t cpuEnd=CpuNow();
  s->skipUntilPresent=false;
  ++s->presents;
  if(s->active>=0) {
    auto& b=s->batches[s->active];
    b.cpuEnd=cpuEnd;
    b.frameEnd=Stamp(*s,b);
    if(b.draws) Group(*s,b,b.frameEnd);
    if(!Issue(*s,b.disjoint) || (s->dx9 && !Issue(*s,b.frequency)) || b.frameEnd<0) { Disable(*s); return; }
    b.pending=true; b.present=s->presents; s->active=-1;
  }
  s->previousPresent=cpuEnd;
  Poll(*s);
  TracyPlot(s->dx9?"MW3/GPU D3D9 current present":"MW3/GPU D3D11 current present",static_cast<double>(s->presents));
  TracyPlot(s->dx9?"MW3/GPU D3D9 dropped measurements":"MW3/GPU D3D11 dropped measurements",static_cast<double>(s->dropped));
}
inline void Present(reshade::api::command_queue* queue) {
  if(!queue) return;
  std::scoped_lock lock(g_mutex);
  State* s=Find(queue->get_device()); if(!s) return;
  if(s->owner!=GetCurrentThreadId()) { if(s->active>=0) s->batches[s->active].bad=true; ++s->dropped; return; }
  if(!Connected() || s->connection!=Connection()) {
    for(auto& b:s->batches) b.Release();
    s->active=-1; s->skipUntilPresent=false; s->connection=Connected()?Connection():0; s->epoch=++g_epoch; return;
  }
  if(s->disabled) return;
  Finish(s);
}
class ScopedBlit {
  State* state_=nullptr; uint64_t epoch_=0,ticket_=0; unsigned pair_=0;
public:
  explicit ScopedBlit(reshade::api::device* device) {
    if(!Connected()) return;
    std::scoped_lock lock(g_mutex);
    if(!device || device->get_api()!=reshade::api::device_api::d3d9) return;
    State* s=Find(device);
    if(!s) {
      for(auto& candidate:g_states) if(candidate.key && candidate.dx9) return;
      for(auto& candidate:g_states) if(!candidate.key) {s=&candidate;break;}
      if(!s) return;
      s->key=device; s->dx9=reinterpret_cast<IDirect3DDevice9*>(device->get_native());
      s->owner=GetCurrentThreadId();s->epoch=++g_epoch;
    }
    if(!s->dx9 || s->owner!=GetCurrentThreadId() || s->disabled) return;
    if(s->connection!=Connection()) {
      for(auto& batch:s->batches) batch.Release();
      s->active=-1;s->skipUntilPresent=false;s->connection=Connection();s->epoch=++g_epoch;
    }
    Batch* active=Begin(*s); if(!active) return;
    auto& b=*active;
    if(b.blitCount==kBlits) return;
    int start=Stamp(*s,b); if(start<0) return;
    state_=s; epoch_=s->epoch; ticket_=b.ticket; pair_=b.blitCount++;
    b.blits[pair_].begin=start;
  }
  ~ScopedBlit() {
    if(!state_) return;
    std::scoped_lock lock(g_mutex);
    auto& s=*state_;
    if(s.epoch!=epoch_ || s.active<0 || s.batches[s.active].ticket!=ticket_) return;
    auto& b=s.batches[s.active]; b.blits[pair_].end=Stamp(s,b);
  }
  ScopedBlit(const ScopedBlit&)=delete;
  ScopedBlit& operator=(const ScopedBlit&)=delete;
};
inline void DestroyDevice(reshade::api::device* device) {
  std::scoped_lock lock(g_mutex);
  if(auto* s=Find(device)) Clear(*s);
}
inline void DestroyQueue(reshade::api::command_queue* queue) { if(queue) DestroyDevice(queue->get_device()); }
inline void DestroySwapchain(reshade::api::swapchain* swapchain,bool) { if(swapchain) DestroyDevice(swapchain->get_device()); }
}
