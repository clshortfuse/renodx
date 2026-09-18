#pragma once
//
// MW3 x64 D3D9 GPU profiler.
//
// Tracy has no native Direct3D 9 backend. This file therefore does two things:
//
//  1. Always: use real IDirect3DQuery9 TIMESTAMP / TIMESTAMPFREQ /
//     TIMESTAMPDISJOINT queries to measure the native GPU frame and sequential
//     draw chunks. Results are exposed as Tracy plots.
//
//  2. Experimental: emit Tracy's internal GPU context/zone queue events so the
//     real D3D9 timestamps appear on a GPU timeline in the Tracy UI.
//
// If Tracy's internal queue ABI changes, set MW3_TRACY_INTERNAL_D3D9_GPU to 0.
// The D3D9 query timing and Tracy plots remain enabled.
//

#include <Windows.h>
#include <d3d9.h>

#include <array>
#include <atomic>
#include <algorithm>
#include <cstdint>
#include <cstdio>
#include <cstring>

#include <include/reshade.hpp>

#include "../../../external/Tracy/public/tracy/Tracy.hpp"
#include "../../../external/Tracy/public/client/TracyProfiler.hpp"
#include "../../../external/Tracy/public/common/TracyAlloc.hpp"
#include "../../../external/Tracy/public/common/TracyQueue.hpp"

#ifndef MW3_TRACY_INTERNAL_D3D9_GPU
#define MW3_TRACY_INTERNAL_D3D9_GPU 0
#endif

namespace mw3_tracy_d3d9_gpu {

constexpr uint32_t kMaxTimestampQueries = 512u;
constexpr uint32_t kBatchCount = 8u;
constexpr uint32_t kMaxQueriesPerFrame = 96u;
constexpr uint32_t kDrawsPerChunk = 256u;
constexpr uint32_t kMaxChunksPerFrame = 32u;

struct TimestampSlot {
  IDirect3DQuery9* query = nullptr;
  bool in_use = false;
};

struct FrameBatch {
  IDirect3DQuery9* frequency = nullptr;
  IDirect3DQuery9* disjoint = nullptr;
  std::array<uint16_t, kMaxQueriesPerFrame> query_ids = {};
  uint32_t query_count = 0u;
  uint64_t frame_id = 0u;
  uint64_t draw_calls = 0u;
  uint64_t indexed_indices = 0u;
  uint64_t connection_id = 0u;
  bool active = false;
  bool pending = false;
};

inline IDirect3DDevice9* g_device = nullptr;
inline std::array<TimestampSlot, kMaxTimestampQueries> g_timestamps = {};
inline std::array<FrameBatch, kBatchCount> g_batches = {};
inline int g_active_batch = -1;
inline uint64_t g_frame_id = 0u;
inline uint64_t g_draw_calls = 0u;
inline uint64_t g_indexed_indices = 0u;
inline uint32_t g_chunk_index = 0u;
inline bool g_chunk_open = false;
inline bool g_frame_zone_open = false;
inline bool g_support_checked = false;
inline bool g_supported = false;
inline bool g_internal_context_ready = false;
inline bool g_internal_calibration_attempted = false;
inline int32_t g_context_id = -1;
inline double g_latest_gpu_ms = -1.0;
inline uint64_t g_frame_start_cpu_qpc = 0u;
inline LARGE_INTEGER g_qpc_frequency = {};

inline bool TracyConnected() {
#ifdef TRACY_ENABLE
  return tracy::GetProfiler().IsConnected();
#else
  return false;
#endif
}

inline uint64_t TracyConnectionId() {
#if defined(TRACY_ENABLE) && defined(TRACY_ON_DEMAND)
  return tracy::GetProfiler().ConnectionId();
#else
  return 0u;
#endif
}

inline void ReleaseQuery(IDirect3DQuery9*& q) {
  if (q != nullptr) {
    q->Release();
    q = nullptr;
  }
}

inline void Reset() {
  for (auto& slot : g_timestamps) {
    ReleaseQuery(slot.query);
    slot.in_use = false;
  }
  for (auto& batch : g_batches) {
    ReleaseQuery(batch.frequency);
    ReleaseQuery(batch.disjoint);
    batch = {};
  }
  g_device = nullptr;
  g_active_batch = -1;
  g_frame_id = 0u;
  g_draw_calls = 0u;
  g_indexed_indices = 0u;
  g_chunk_index = 0u;
  g_chunk_open = false;
  g_frame_zone_open = false;
  g_support_checked = false;
  g_supported = false;
  g_internal_context_ready = false;
  g_internal_calibration_attempted = false;
  g_context_id = -1;
  g_latest_gpu_ms = -1.0;
  g_frame_start_cpu_qpc = 0u;
  g_qpc_frequency = {};
}

inline bool EnsureTimestampQuery(uint16_t id) {
  if (g_device == nullptr || id >= g_timestamps.size()) return false;
  auto& slot = g_timestamps[id];
  if (slot.query != nullptr) return true;
  return SUCCEEDED(g_device->CreateQuery(
      D3DQUERYTYPE_TIMESTAMP, &slot.query));
}

inline int AllocateTimestamp(FrameBatch& batch) {
  if (batch.query_count >= batch.query_ids.size()) return -1;
  for (uint32_t i = 0u; i < g_timestamps.size(); ++i) {
    auto& slot = g_timestamps[i];
    if (slot.in_use) continue;
    if (!EnsureTimestampQuery(static_cast<uint16_t>(i))) return -1;
    slot.in_use = true;
    batch.query_ids[batch.query_count++] = static_cast<uint16_t>(i);
    return static_cast<int>(i);
  }
  return -1;
}

inline void FreeBatchQueries(FrameBatch& batch) {
  for (uint32_t i = 0u; i < batch.query_count; ++i) {
    const uint16_t id = batch.query_ids[i];
    if (id < g_timestamps.size()) g_timestamps[id].in_use = false;
  }
  batch.query_count = 0u;
}

inline bool EnsureBatchQueries(FrameBatch& batch) {
  if (g_device == nullptr) return false;
  if (batch.frequency == nullptr
      && FAILED(g_device->CreateQuery(
          D3DQUERYTYPE_TIMESTAMPFREQ, &batch.frequency))) {
    return false;
  }
  if (batch.disjoint == nullptr
      && FAILED(g_device->CreateQuery(
          D3DQUERYTYPE_TIMESTAMPDISJOINT, &batch.disjoint))) {
    return false;
  }
  return true;
}

#if MW3_TRACY_INTERNAL_D3D9_GPU

inline void EmitGpuContext(int64_t cpu_time, int64_t gpu_time) {
  if (g_internal_context_ready) return;

  g_context_id = static_cast<int32_t>(tracy::GetGpuCtxCounter().fetch_add(1));

  auto* item = tracy::Profiler::QueueSerial();
  tracy::MemWrite(&item->hdr.type, tracy::QueueType::GpuNewContext);
  tracy::MemWrite(&item->gpuNewContext.cpuTime, cpu_time);
  tracy::MemWrite(&item->gpuNewContext.gpuTime, gpu_time);
  tracy::MemWrite(&item->gpuNewContext.thread, uint32_t(0));
  tracy::MemWrite(&item->gpuNewContext.period, 1.0f);
  tracy::MemWrite(
      &item->gpuNewContext.context,
      static_cast<uint8_t>(g_context_id));
  tracy::MemWrite(
      &item->gpuNewContext.flags,
      tracy::GpuContextFlags(0));

  // Tracy has no Direct3D9 enum. Use the D3D11 renderer type only as a viewer
  // transport tag; all timestamps are produced by actual D3D9 queries.
  tracy::MemWrite(
      &item->gpuNewContext.type,
      tracy::GpuContextType::Direct3D11);

#ifdef TRACY_ON_DEMAND
  tracy::GetProfiler().DeferItem(*item);
#endif
  tracy::Profiler::QueueSerialFinish();

  const char* context_name =
      "MW3 Native D3D9 GPU (custom Tracy backend)";
  const uint16_t len =
      static_cast<uint16_t>(std::strlen(context_name));
  char* ptr = static_cast<char*>(tracy::tracy_malloc(len));
  std::memcpy(ptr, context_name, len);

  item = tracy::Profiler::QueueSerial();
  tracy::MemWrite(
      &item->hdr.type,
      tracy::QueueType::GpuContextName);
  tracy::MemWrite(
      &item->gpuContextNameFat.context,
      static_cast<uint8_t>(g_context_id));
  tracy::MemWrite(
      &item->gpuContextNameFat.ptr,
      reinterpret_cast<uint64_t>(ptr));
  tracy::MemWrite(
      &item->gpuContextNameFat.size,
      len);
#ifdef TRACY_ON_DEMAND
  tracy::GetProfiler().DeferItem(*item);
#endif
  tracy::Profiler::QueueSerialFinish();

  g_internal_context_ready = true;
}

inline void EmitGpuTime(uint16_t query_id, int64_t gpu_ns) {
  if (!g_internal_context_ready || !TracyConnected()) return;

  auto* item = tracy::Profiler::QueueSerial();
  tracy::MemWrite(&item->hdr.type, tracy::QueueType::GpuTime);
  tracy::MemWrite(&item->gpuTime.gpuTime, gpu_ns);
  tracy::MemWrite(&item->gpuTime.queryId, query_id);
  tracy::MemWrite(
      &item->gpuTime.context,
      static_cast<uint8_t>(g_context_id));
  tracy::Profiler::QueueSerialFinish();
}

inline void EmitZoneBegin(uint16_t query_id, const char* name) {
  if (!g_internal_context_ready || !TracyConnected() || name == nullptr) return;

  const uint64_t srcloc = tracy::Profiler::AllocSourceLocation(
      0u,
      "mw3_tracy_d3d9_gpu.hpp",
      sizeof("mw3_tracy_d3d9_gpu.hpp") - 1u,
      "MW3 D3D9 GPU",
      sizeof("MW3 D3D9 GPU") - 1u,
      name,
      std::strlen(name));

  auto* item = tracy::Profiler::QueueSerial();
  tracy::MemWrite(
      &item->hdr.type,
      tracy::QueueType::GpuZoneBeginAllocSrcLocSerial);
  tracy::MemWrite(
      &item->gpuZoneBegin.cpuTime,
      tracy::Profiler::GetTime());
  tracy::MemWrite(
      &item->gpuZoneBegin.srcloc,
      srcloc);
  tracy::MemWrite(
      &item->gpuZoneBegin.thread,
      tracy::GetThreadHandle());
  tracy::MemWrite(
      &item->gpuZoneBegin.queryId,
      query_id);
  tracy::MemWrite(
      &item->gpuZoneBegin.context,
      static_cast<uint8_t>(g_context_id));
  tracy::Profiler::QueueSerialFinish();
}

inline void EmitZoneEnd(uint16_t query_id) {
  if (!g_internal_context_ready || !TracyConnected()) return;

  auto* item = tracy::Profiler::QueueSerial();
  tracy::MemWrite(
      &item->hdr.type,
      tracy::QueueType::GpuZoneEndSerial);
  tracy::MemWrite(
      &item->gpuZoneEnd.cpuTime,
      tracy::Profiler::GetTime());
  tracy::MemWrite(
      &item->gpuZoneEnd.thread,
      tracy::GetThreadHandle());
  tracy::MemWrite(
      &item->gpuZoneEnd.queryId,
      query_id);
  tracy::MemWrite(
      &item->gpuZoneEnd.context,
      static_cast<uint8_t>(g_context_id));
  tracy::Profiler::QueueSerialFinish();
}

#else

inline void EmitGpuContext(int64_t, int64_t) {}
inline void EmitGpuTime(uint16_t, int64_t) {}
inline void EmitZoneBegin(uint16_t, const char*) {}
inline void EmitZoneEnd(uint16_t) {}

#endif

inline bool IssueZoneTimestamp(FrameBatch& batch, bool begin, const char* name = nullptr) {
  const int id = AllocateTimestamp(batch);
  if (id < 0) return false;

  auto* q = g_timestamps[static_cast<size_t>(id)].query;
  if (q == nullptr || FAILED(q->Issue(D3DISSUE_END))) return false;

  if (begin) {
    EmitZoneBegin(static_cast<uint16_t>(id), name);
  } else {
    EmitZoneEnd(static_cast<uint16_t>(id));
  }
  return true;
}

inline bool CalibrateInternalContext() {
#if !MW3_TRACY_INTERNAL_D3D9_GPU
  return false;
#else
  if (!TracyConnected() || g_device == nullptr) return false;
  if (g_internal_context_ready) return true;
  if (g_internal_calibration_attempted) return false;
  g_internal_calibration_attempted = true;

  IDirect3DQuery9* ts = nullptr;
  IDirect3DQuery9* freq = nullptr;
  IDirect3DQuery9* disjoint = nullptr;

  if (FAILED(g_device->CreateQuery(D3DQUERYTYPE_TIMESTAMP, &ts))
      || FAILED(g_device->CreateQuery(D3DQUERYTYPE_TIMESTAMPFREQ, &freq))
      || FAILED(g_device->CreateQuery(
          D3DQUERYTYPE_TIMESTAMPDISJOINT, &disjoint))) {
    ReleaseQuery(ts);
    ReleaseQuery(freq);
    ReleaseQuery(disjoint);
    return false;
  }

  disjoint->Issue(D3DISSUE_BEGIN);
  const int64_t cpu0 = tracy::Profiler::GetTime();
  ts->Issue(D3DISSUE_END);
  disjoint->Issue(D3DISSUE_END);
  freq->Issue(D3DISSUE_END);

  UINT64 timestamp = 0u;
  UINT64 frequency = 0u;
  BOOL was_disjoint = TRUE;

  // One-time profiling-only calibration. Do not do this unless a viewer is
  // connected. The regular per-frame collector below is always non-blocking.
  const ULONGLONG deadline_ms = GetTickCount64() + 100u;
  while (GetTickCount64() < deadline_ms) {
    const HRESULT a = ts->GetData(
        &timestamp, sizeof(timestamp), D3DGETDATA_FLUSH);
    const HRESULT b = freq->GetData(
        &frequency, sizeof(frequency), D3DGETDATA_FLUSH);
    const HRESULT c = disjoint->GetData(
        &was_disjoint, sizeof(was_disjoint), D3DGETDATA_FLUSH);
    if (a == S_OK && b == S_OK && c == S_OK) break;
    Sleep(0);
  }

  const int64_t cpu1 = tracy::Profiler::GetTime();

  bool ok =
      frequency != 0u
      && was_disjoint == FALSE;

  if (ok) {
    const long double gpu_ns_ld =
        static_cast<long double>(timestamp)
        * 1000000000.0L
        / static_cast<long double>(frequency);
    const int64_t gpu_ns = static_cast<int64_t>(gpu_ns_ld);
    const int64_t cpu_mid = cpu0 + (cpu1 - cpu0) / 2;
    EmitGpuContext(cpu_mid, gpu_ns);
  }

  ReleaseQuery(ts);
  ReleaseQuery(freq);
  ReleaseQuery(disjoint);
  return ok && g_internal_context_ready;
#endif
}

inline FrameBatch* ActiveBatch() {
  if (g_active_batch < 0) return nullptr;
  return &g_batches[static_cast<size_t>(g_active_batch)];
}

inline bool OpenChunk() {
  auto* batch = ActiveBatch();
  if (batch == nullptr
      || g_chunk_open
      || g_chunk_index >= kMaxChunksPerFrame) {
    return false;
  }

  char name[64] = {};
  std::snprintf(
      name, sizeof(name),
      "MW3 GPU / Draw Chunk %02u (%u draws)",
      g_chunk_index,
      kDrawsPerChunk);

  if (!IssueZoneTimestamp(*batch, true, name)) return false;
  g_chunk_open = true;
  return true;
}

inline void CloseChunk() {
  auto* batch = ActiveBatch();
  if (batch == nullptr || !g_chunk_open) return;
  IssueZoneTimestamp(*batch, false);
  g_chunk_open = false;
  ++g_chunk_index;
}

inline void PollPendingBatches() {
  if (g_device == nullptr) return;

  for (auto& batch : g_batches) {
    if (!batch.pending) continue;

#if defined(TRACY_ENABLE) && defined(TRACY_ON_DEMAND)
    // A GPU zone belongs to the Tracy connection in which it was opened.
    // Never replay timestamps from an old capture into a later reconnect.
    if (!TracyConnected() || batch.connection_id != TracyConnectionId()) {
      FreeBatchQueries(batch);
      batch.pending = false;
      batch.active = false;
      batch.frame_id = 0u;
      batch.connection_id = 0u;
      continue;
    }
#endif

    UINT64 frequency = 0u;
    BOOL was_disjoint = TRUE;

    const HRESULT freq_hr =
        batch.frequency->GetData(
            &frequency, sizeof(frequency), 0u);
    const HRESULT disjoint_hr =
        batch.disjoint->GetData(
            &was_disjoint, sizeof(was_disjoint), 0u);

    if (freq_hr == S_FALSE || disjoint_hr == S_FALSE) continue;

    bool valid =
        SUCCEEDED(freq_hr)
        && SUCCEEDED(disjoint_hr)
        && was_disjoint == FALSE
        && frequency != 0u;
    bool timestamp_not_ready = false;

    UINT64 first_ts = 0u;
    UINT64 last_ts = 0u;
    bool have_first = false;
    bool have_last = false;

    if (valid) {
      for (uint32_t i = 0u; i < batch.query_count; ++i) {
        const uint16_t id = batch.query_ids[i];
        UINT64 ts = 0u;
        const HRESULT hr =
            g_timestamps[id].query->GetData(
                &ts, sizeof(ts), 0u);

        if (hr == S_FALSE) {
          timestamp_not_ready = true;
          break;
        }
        if (FAILED(hr)) {
          valid = false;
          break;
        }

        const long double ns_ld =
            static_cast<long double>(ts)
            * 1000000000.0L
            / static_cast<long double>(frequency);
        EmitGpuTime(id, static_cast<int64_t>(ns_ld));

        if (!have_first) {
          first_ts = ts;
          have_first = true;
        }
        last_ts = ts;
        have_last = true;
      }
    }

    if (timestamp_not_ready) {
      continue;
    }

    if (valid && have_first && have_last && last_ts >= first_ts) {
      g_latest_gpu_ms =
          static_cast<double>(last_ts - first_ts)
          * 1000.0
          / static_cast<double>(frequency);

      TracyPlot("MW3/GPU D3D9 Frame ms", g_latest_gpu_ms);
      TracyPlot(
          "MW3/GPU Draw Calls",
          static_cast<double>(batch.draw_calls));
      TracyPlot(
          "MW3/GPU Indexed Indices",
          static_cast<double>(batch.indexed_indices));
    }

    FreeBatchQueries(batch);
    batch.pending = false;
    batch.active = false;
    batch.frame_id = 0u;
    batch.connection_id = 0u;
  }
}

inline int FindFreeBatch() {
  for (uint32_t i = 0u; i < g_batches.size(); ++i) {
    if (!g_batches[i].active && !g_batches[i].pending) {
      return static_cast<int>(i);
    }
  }
  return -1;
}

inline void BeginFrame() {
  if (!TracyConnected() || !g_supported || g_device == nullptr) return;
#if MW3_TRACY_INTERNAL_D3D9_GPU
  if (!g_internal_context_ready) {
    CalibrateInternalContext();
  }
#endif

  const int index = FindFreeBatch();
  if (index < 0) return;

  auto& batch = g_batches[static_cast<size_t>(index)];
  if (!EnsureBatchQueries(batch)) {
    g_supported = false;
    return;
  }

  if (FAILED(batch.disjoint->Issue(D3DISSUE_BEGIN))) {
    return;
  }

  batch.active = true;
  batch.pending = false;
  batch.query_count = 0u;
  batch.frame_id = ++g_frame_id;
  batch.draw_calls = 0u;
  batch.indexed_indices = 0u;
  batch.connection_id = TracyConnectionId();

  g_active_batch = index;
  g_draw_calls = 0u;
  g_indexed_indices = 0u;
  g_chunk_index = 0u;
  g_chunk_open = false;
  g_frame_zone_open =
      IssueZoneTimestamp(batch, true, "MW3 GPU / Native D3D9 Frame");

  OpenChunk();
}

inline void EndFrame() {
  auto* batch = ActiveBatch();
  if (batch == nullptr) return;

  CloseChunk();

  if (g_frame_zone_open) {
    IssueZoneTimestamp(*batch, false);
    g_frame_zone_open = false;
  }

  batch->draw_calls = g_draw_calls;
  batch->indexed_indices = g_indexed_indices;

  const HRESULT disjoint_hr =
      batch->disjoint->Issue(D3DISSUE_END);
  const HRESULT frequency_hr =
      batch->frequency->Issue(D3DISSUE_END);

  if (FAILED(disjoint_hr) || FAILED(frequency_hr)) {
    FreeBatchQueries(*batch);
    batch->active = false;
    g_active_batch = -1;
    return;
  }

  batch->active = false;
  batch->pending = true;
  g_active_batch = -1;
}

inline void SetDevice(IDirect3DDevice9* device) {
  if (device == g_device) return;
  Reset();
  g_device = device;

  if (g_device != nullptr) {
    IDirect3DQuery9* probe = nullptr;
    g_supported =
        SUCCEEDED(g_device->CreateQuery(
            D3DQUERYTYPE_TIMESTAMP, &probe));
    g_support_checked = true;
    ReleaseQuery(probe);
  }
}

inline void OnD3D9Present(IDirect3DDevice9* device) {
  ZoneScopedN("MW3 Addon / D3D9 GPU Profiler Present");

  SetDevice(device);
  if (!g_supported || !TracyConnected()) {
    if (g_active_batch >= 0) EndFrame();
    PollPendingBatches();
    return;
  }

  // Present closes the frame that began at the previous Present.
  EndFrame();
  PollPendingBatches();
  BeginFrame();
}

inline bool OnDraw(
    reshade::api::command_list* cmd_list,
    uint32_t vertices,
    uint32_t instances,
    uint32_t,
    uint32_t) {
  (void)cmd_list;
  if (g_active_batch < 0 || !TracyConnected()) return false;

  g_draw_calls += std::max<uint32_t>(instances, 1u);

  if (g_chunk_open
      && (g_draw_calls % kDrawsPerChunk) == 0u
      && g_chunk_index + 1u < kMaxChunksPerFrame) {
    CloseChunk();
    OpenChunk();
  }

  (void)vertices;
  return false;
}

inline bool OnDrawIndexed(
    reshade::api::command_list* cmd_list,
    uint32_t indices,
    uint32_t instances,
    uint32_t,
    int32_t,
    uint32_t) {
  (void)cmd_list;
  if (g_active_batch < 0 || !TracyConnected()) return false;

  const uint32_t instance_count = std::max<uint32_t>(instances, 1u);
  g_draw_calls += instance_count;
  g_indexed_indices +=
      static_cast<uint64_t>(indices)
      * static_cast<uint64_t>(instance_count);

  if (g_chunk_open
      && (g_draw_calls % kDrawsPerChunk) == 0u
      && g_chunk_index + 1u < kMaxChunksPerFrame) {
    CloseChunk();
    OpenChunk();
  }

  return false;
}

class ScopedAddonGpuZone {
 public:
  ScopedAddonGpuZone(
      IDirect3DDevice9* device,
      const char* name)
      : device_(device) {
    if (device_ == nullptr
        || device_ != g_device
        || g_active_batch < 0
        || !TracyConnected()) {
      return;
    }

    auto* batch = ActiveBatch();
    if (batch == nullptr) return;

    active_ = IssueZoneTimestamp(*batch, true, name);
  }

  ~ScopedAddonGpuZone() {
    if (!active_) return;
    auto* batch = ActiveBatch();
    if (batch != nullptr) {
      IssueZoneTimestamp(*batch, false);
    }
  }

 private:
  IDirect3DDevice9* device_ = nullptr;
  bool active_ = false;
};

inline double LatestGpuFrameMs() {
  return g_latest_gpu_ms;
}

inline void Shutdown() {
  EndFrame();
  PollPendingBatches();
  Reset();
}

}  // namespace mw3_tracy_d3d9_gpu
