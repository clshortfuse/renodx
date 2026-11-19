#pragma once

// Opt-in CPU wall-clock measurements. No per-frame allocation, file I/O,
// resource readback, GPU flush, or change to the native wait semantics.
namespace codwaw_frame_timing {
enum Channel { FrameInterval, LimiterWait, RendererWait, Readback, Count };
struct Counter {
  std::atomic<uint64_t> count{0}, total_us{0}, max_us{0};
};
inline Counter counters[Count];
inline std::atomic<bool> enabled{false};
inline std::atomic<uint64_t> last_present{0};
inline uint64_t Now() {
  LARGE_INTEGER t{};
  QueryPerformanceCounter(&t);
  return static_cast<uint64_t>(t.QuadPart);
}
inline uint64_t Frequency() {
  static const uint64_t frequency = [] {
    LARGE_INTEGER f{};
    return QueryPerformanceFrequency(&f) && f.QuadPart > 0
        ? static_cast<uint64_t>(f.QuadPart) : uint64_t{0};
  }();
  return frequency;
}
inline void Record(Channel channel, uint64_t begin, uint64_t end) {
  const uint64_t frequency = Frequency();
  if (frequency == 0 || end < begin) return;
  const uint64_t us = static_cast<uint64_t>(
      static_cast<double>(end - begin) * 1000000.0 / frequency);
  auto& c = counters[channel];
  c.count.fetch_add(1, std::memory_order_relaxed);
  c.total_us.fetch_add(us, std::memory_order_relaxed);
  uint64_t maximum = c.max_us.load(std::memory_order_relaxed);
  while (maximum < us && !c.max_us.compare_exchange_weak(
      maximum, us, std::memory_order_relaxed)) {}
}
struct Scope {
  Channel channel;
  uint64_t begin;
  explicit Scope(Channel value) : channel(value),
      begin(value < Count && enabled.load(std::memory_order_relaxed) ? Now() : 0) {}
  ~Scope() {
    if (begin != 0 && enabled.load(std::memory_order_relaxed))
      Record(channel, begin, Now());
  }
};
inline void Present() {
  if (!enabled.load(std::memory_order_relaxed)) {
    last_present.store(0, std::memory_order_relaxed);
    return;
  }
  const auto now = Now();
  const auto previous = last_present.exchange(now, std::memory_order_relaxed);
  if (previous != 0) Record(FrameInterval, previous, now);
}
inline void Reset() {
  last_present.store(0, std::memory_order_relaxed);
  for (auto& c : counters) {
    c.count.store(0, std::memory_order_relaxed);
    c.total_us.store(0, std::memory_order_relaxed);
    c.max_us.store(0, std::memory_order_relaxed);
  }
}
inline void Draw() {
  bool capture = enabled.load(std::memory_order_relaxed);
  if (ImGui::Checkbox("Record frame timings", &capture)) {
    enabled.store(capture, std::memory_order_relaxed);
    if (capture) Reset();
  }
  ImGui::SameLine();
  if (ImGui::Button("Reset timings")) Reset();
  constexpr const char* names[] = {
      "D3D9 frame interval", "Internal limiter wait",
      "Renderer event wait", "HDR readback conversion"};
  for (int i = 0; i < Count; ++i) {
    const auto n = counters[i].count.load(std::memory_order_relaxed);
    const auto total = counters[i].total_us.load(std::memory_order_relaxed);
    const auto maximum = counters[i].max_us.load(std::memory_order_relaxed);
    ImGui::Text("%s: average %.3f ms, max %.3f ms (%llu samples)", names[i],
                n != 0 ? static_cast<double>(total) / n / 1000.0 : 0.0,
                static_cast<double>(maximum) / 1000.0,
                static_cast<unsigned long long>(n));
  }
  ImGui::TextWrapped("CPU elapsed time only. Categories can overlap; D3D9 intervals do not measure the proxy's final displayed frames. Reset after loading Vendetta, record the repeated turn, then stop recording.");
  if (ImGui::Button("Write timing summary to ReShade.log")) {
    for (int i = 0; i < Count; ++i) {
      const auto n = counters[i].count.load(std::memory_order_relaxed);
      const auto total = counters[i].total_us.load(std::memory_order_relaxed);
      const auto maximum = counters[i].max_us.load(std::memory_order_relaxed);
      std::stringstream text;
      text << "[CoDWaW Timing] " << names[i] << ": samples=" << n
           << " average_ms=" << (n ? static_cast<double>(total) / n / 1000.0 : 0.0)
           << " max_ms=" << static_cast<double>(maximum) / 1000.0;
      reshade::log::message(reshade::log::level::info, text.str().c_str());
    }
  }
}
}  // namespace codwaw_frame_timing
