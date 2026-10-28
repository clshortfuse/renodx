/*
 * Copyright (C) 2026 Musa Haji
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include "../diagnostics_config.hpp"

#if RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS

#include <windows.h>

#include <algorithm>
#include <array>
#include <atomic>
#include <charconv>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <cwchar>
#include <memory>
#include <mutex>
#include <new>
#include <shared_mutex>
#include <string_view>
#include <system_error>
#include <utility>

#include <include/reshade.hpp>

#include "../../../utils/log.hpp"
#include "../../../utils/resource.hpp"
#include "./lifetime.hpp"

namespace rdr2vk::diagnostics {

static_assert(sizeof(void*) == 8, "RDR2 lifetime diagnostics require x64 CONTEXT and native handles");

struct SyncObservation {
  const char* kind;
  std::uint64_t device = 0;
  std::uint64_t object = 0;
  std::uint64_t request = 0;
  std::int32_t result = 0;
  std::uint32_t count = 0;
  const std::uint64_t* handles = nullptr;
};

enum class ViewKind : std::uint8_t { IMAGE,
                                     BUFFER };

struct DestroyObservation {
  ViewKind kind = ViewKind::IMAGE;
  std::uint64_t device = 0;
  std::uint64_t view = 0;
};

struct BufferCreationObservation {
  std::uint64_t device = 0;
  std::uint64_t buffer = 0;
  std::uint32_t format = 0;
  std::uint64_t offset = 0;
  std::uint64_t range = 0;
  std::uint64_t output_slot = 0;
  std::uint64_t previous_output = 0;
  std::size_t previous_bytes = 0;
  bool info_readable = false;
};

struct CreationResultObservation {
  std::int32_t result = 0;
  // Output bytes are not a valid handle on failure, and are never queried.
  std::uint64_t output = 0;
  std::size_t output_bytes = 0;
};

struct DescriptorInput {
  std::uint64_t view = 0;
  std::uint64_t descriptor_set = 0;
  std::uint64_t input_address = 0;
  std::uint32_t binding = 0;
  std::uint32_t element = 0;
  std::uint32_t type = 0;
};

static constexpr std::size_t DESCRIPTOR_REFERENCE_LIMIT = 128;

// The wrapper owns the bounded input snapshot for the whole native call. Its
// scope restores nested TLS; the exception observer only changes fault_reported.
struct DescriptorBatchObservation {
  std::uint64_t device = 0;
  std::uint64_t writes_address = 0;
  std::uint32_t writes = 0;
  std::uint32_t copies = 0;
  std::uint64_t references = 0;
  std::uint32_t captured = 0;
  std::uint32_t unreadable = 0;
  std::array<DescriptorInput, DESCRIPTOR_REFERENCE_LIMIT> inputs = {};
  std::uint64_t request = 0;
  std::int64_t counter = 0;
  std::uint32_t phase = 0;
  bool fault_reported = false;
};

namespace internal {

static constexpr std::size_t VIEW_SLOTS = 16384;
static constexpr std::size_t VIEW_PROBE_LIMIT = 16;
static constexpr std::size_t HISTORY_SIZE = 128;
static constexpr std::size_t SYNC_HISTORY_SIZE = 256;
static constexpr std::uint32_t VIEW_REPORT_LIMIT = 8;
static constexpr std::uint32_t AV_REPORT_LIMIT = 4;
static constexpr std::uint32_t CREATION_REPORT_LIMIT = 16;

enum class ViewEvent : std::uint8_t {
  CREATE,
  BUFFER_CREATE_RETURN,
  IMAGE_DESTROY_ENTER,
  IMAGE_DESTROY_RETURN,
  BUFFER_DESTROY_ENTER,
  BUFFER_DESTROY_RETURN,
  DESTROY_CALLBACK,
  DESTROY_CALLBACK_UNKNOWN,
  SHARED_RETIRE,
  DESCRIPTOR_INPUT,
  DESCRIPTOR_RETURN,
};

struct NativeCall {
  std::uint64_t request = 0;
  std::uint64_t generation = 0;
  std::uint64_t device = 0;
  std::uint64_t view = 0;
  bool creating = false;
  bool destroying = false;
  bool fault_reported = false;
  ViewKind kind = ViewKind::IMAGE;
};

struct ViewObservation {
  ViewEvent event = ViewEvent::CREATE;
  std::uint64_t device = 0;
  std::uint64_t view = 0;
  std::uint64_t resource = 0;
  std::uint64_t clone = 0;
  std::uint64_t fallback = 0;
  std::uint64_t offset = 0;
  std::uint64_t range = 0;
  std::uint64_t request = 0;
  std::uint64_t generation = 0;
  std::uint32_t format = 0;
  bool destroyed = false;
  bool is_clone = false;
};

struct Evidence {
  ViewObservation observation;
  std::uint64_t sequence = 0;
  std::uint64_t tick = 0;
  std::int64_t counter = 0;
  DWORD thread = 0;
  USHORT frames = 0;
  std::array<void*, 16> stack = {};
};

struct ViewEvidence {
  std::uint64_t device = 0;
  std::uint64_t view = 0;
  std::uint64_t last_sequence = 0;
  lifetime::LifetimeState lifetime;
  Evidence creation;
  Evidence description;
  Evidence first_destroy;
  Evidence first_return;
  Evidence first_event;
  Evidence last_reference;
  Evidence last_reference_return;
  Evidence reference_before_destroy;
  Evidence reference_return_before_destroy;
  bool descriptor_reported = false;
};

struct SyncEvidence {
  std::uint64_t sequence = 0;
  std::int64_t counter = 0;
  std::uint64_t device = 0;
  std::uint64_t object = 0;
  std::uint64_t request = 0;
  std::int32_t result = 0;
  std::uint32_t count = 0;
  DWORD thread = 0;
  std::array<char, 32> kind = {};
  std::array<std::uint64_t, 4> handles = {};
  std::size_t handle_bytes = 0;
};

struct History {
  std::array<ViewEvidence, VIEW_SLOTS> views = {};
  std::array<Evidence, HISTORY_SIZE> events = {};
  std::array<SyncEvidence, SYNC_HISTORY_SIZE> sync = {};
  std::uint64_t sequence = 0;
  std::uint64_t sync_sequence = 0;
  std::uint64_t evictions = 0;
  std::uint64_t untracked = 0;
  std::uint64_t create_enters = 0;
  std::uint64_t create_returns = 0;
  std::uint64_t destroy_enters = 0;
  std::uint64_t destroy_returns = 0;
  std::uint64_t descriptor_updates = 0;
  std::uint32_t reports = 0;
  std::uint32_t reported_problems = 0;
  std::uint32_t fault_reports = 0;
  std::uint32_t failure_reports = 0;
};

struct TraceState {
  std::shared_mutex mutex;
  HANDLE file = INVALID_HANDLE_VALUE;
  std::unique_ptr<History> history;
  PVOID exception_handler = nullptr;
  std::uintptr_t driver_begin = 0;
  std::uintptr_t driver_end = 0;
  bool callbacks_registered = false;
  bool failed = false;
};

static TraceState trace;
static std::atomic_bool ready = false;
static std::atomic_uint64_t next_request = 0;
static std::atomic_uint64_t skipped_lock_entries = 0;
static std::atomic_uint32_t native_hook_producers = 0;
static thread_local NativeCall native_call;
static thread_local DescriptorBatchObservation* active_descriptor_batch = nullptr;
static thread_local bool exception_observer_active = false;
static thread_local bool recorder_entered = false;

enum class LockMode { WAIT,
                      TRY };

// A first-chance exception can interrupt this thread while it owns the mutex.
// Check TLS BEFORE try_lock; recursively trying a std::shared_mutex is not valid.
class RecorderLock {
 public:
  explicit RecorderLock(LockMode mode = LockMode::WAIT) noexcept
      : lock(trace.mutex, std::defer_lock) {
    if (recorder_entered) {
      ++skipped_lock_entries;
      return;
    }
    recorder_entered = true;
    entered = true;
    try {
      if (mode == LockMode::TRY) {
        if (!lock.try_lock()) {
          ++skipped_lock_entries;
        }
      } else {
        lock.lock();
      }
    } catch (...) {
      ++skipped_lock_entries;
    }
  }

  RecorderLock(const RecorderLock&) = delete;
  RecorderLock& operator=(const RecorderLock&) = delete;

  ~RecorderLock() {
    if (lock.owns_lock()) {
      lock.unlock();
    }
    if (entered) {
      recorder_entered = false;
    }
  }

  explicit operator bool() const noexcept { return lock.owns_lock(); }

 private:
  std::unique_lock<std::shared_mutex> lock;
  bool entered = false;
};

// Fixed storage and to_chars keep the exception path independent of allocating
// streams, locale initialization, symbol lookup, and the ReShade logger.
struct ReportLine {
  std::array<char, 2048> bytes = {};
  std::size_t size = 0;

  void Text(const char* text) noexcept {
    if (text == nullptr) return;
    while (*text != '\0' && size < bytes.size() - 1) {
      bytes[size++] = *text++;
    }
  }

  template <typename Integer>
  void Number(const char* name, Integer value, int base = 10) noexcept {
    Text(name);
    const auto result = std::to_chars(bytes.data() + size, bytes.data() + bytes.size() - 1, value, base);
    if (result.ec == std::errc{}) {
      size = static_cast<std::size_t>(result.ptr - bytes.data());
    }
  }
};

// All file access holds RecorderLock. I/O failure stops observations, not calls
// to Vulkan. Cleanup still belongs to Use after the producers have stopped.
static void WriteText(const char* text) noexcept {
  if (trace.file == INVALID_HANDLE_VALUE || trace.failed) return;
  const auto size = static_cast<DWORD>(std::strlen(text));
  DWORD written = 0;
  if (WriteFile(trace.file, text, size, &written, nullptr) == FALSE || written != size) {
    trace.failed = true;
    ready.store(false, std::memory_order_release);
  }
}

static void WriteLine(ReportLine* line) noexcept {
  line->Text("\n");
  line->bytes[line->size] = '\0';
  WriteText(line->bytes.data());
}

static void FlushReport() noexcept {
  if (trace.file == INVALID_HANDLE_VALUE || trace.failed) return;
  if (FlushFileBuffers(trace.file) == FALSE) {
    trace.failed = true;
    ready.store(false, std::memory_order_release);
  }
}

static void WriteEvidence(const char* label, const Evidence& evidence) noexcept {
  if (evidence.sequence == 0) return;
  const auto& value = evidence.observation;
  ReportLine line;
  line.Text(label);
  line.Number(" seq=", evidence.sequence);
  line.Number(" tick=", evidence.tick);
  line.Number(" qpc=", evidence.counter);
  line.Number(" thread=", evidence.thread);
  line.Number(" event=", static_cast<unsigned>(value.event));
  line.Number(" request=", value.request);
  line.Number(" generation=", value.generation);
  line.Number(" device=", value.device, 16);
  line.Number(" view=", value.view, 16);
  line.Number(" resource=", value.resource, 16);
  line.Number(" clone=", value.clone, 16);
  line.Number(" fallback=", value.fallback, 16);
  line.Number(" destroyed=", static_cast<unsigned>(value.destroyed));
  line.Number(" is_clone=", static_cast<unsigned>(value.is_clone));
  line.Number(" format=", value.format);
  line.Number(" offset=", value.offset, 16);
  line.Number(" range=", value.range, 16);
  for (USHORT index = 0; index < evidence.frames; ++index) {
    line.Number(" pc=", reinterpret_cast<std::uintptr_t>(evidence.stack[index]), 16);
  }
  WriteLine(&line);
}

// Ordinary anomaly/allocation reports only, never the exception observer.
// Inspect mapped game code, not native object storage or arbitrary stack data.
static void WriteCallerCode(const Evidence& evidence) noexcept {
  for (USHORT index = 0; index < evidence.frames; ++index) {
    MEMORY_BASIC_INFORMATION region = {};
    if (VirtualQuery(evidence.stack[index], &region, sizeof(region)) == 0
        || region.AllocationBase != GetModuleHandleW(nullptr)
        || region.Type != MEM_IMAGE || region.State != MEM_COMMIT
        || (region.Protect & (PAGE_GUARD | PAGE_NOACCESS)) != 0
        || (region.Protect & (PAGE_EXECUTE | PAGE_EXECUTE_READ | PAGE_EXECUTE_READWRITE | PAGE_EXECUTE_WRITECOPY)) == 0) continue;
    const auto pc = reinterpret_cast<std::uintptr_t>(evidence.stack[index]);
    const auto begin = reinterpret_cast<std::uintptr_t>(region.BaseAddress);
    const auto address = (pc - begin >= 96 ? pc - 96 : begin);
    std::array<unsigned char, 256> bytes = {};
    SIZE_T copied = 0;
    if (ReadProcessMemory(GetCurrentProcess(), reinterpret_cast<const void*>(address), bytes.data(),
                          (std::min)(bytes.size(), region.RegionSize - (address - begin)), &copied)
            == FALSE
        || copied == 0) continue;
    ReportLine line;
    line.Number("caller_code address=", address, 16);
    line.Number(" size=", copied);
    line.Text(" bytes=");
    constexpr std::string_view hex_digits = "0123456789abcdef";
    for (SIZE_T byte = 0; byte < copied; ++byte) {
      const std::array encoded = {hex_digits[bytes[byte] >> 4], hex_digits[bytes[byte] & 15], '\0'};
      line.Text(encoded.data());
    }
    WriteLine(&line);
  }
}

static void WriteView(const ViewEvidence& entry) noexcept {
  WriteEvidence("creation", entry.creation);
  WriteEvidence("description", entry.description);
  WriteEvidence("first_native_destroy", entry.first_destroy);
  WriteEvidence("first_native_return", entry.first_return);
  WriteEvidence("first_event", entry.first_event);
  WriteEvidence("reference_before_destroy", entry.reference_before_destroy);
  WriteEvidence("reference_return_before_destroy", entry.reference_return_before_destroy);
  WriteEvidence("last_reference", entry.last_reference);
  WriteEvidence("last_reference_return", entry.last_reference_return);
}

static void WriteHistories() noexcept {
  if (trace.history == nullptr) return;
  const auto& history = *trace.history;
  const auto first_event = (history.sequence >= HISTORY_SIZE ? history.sequence - HISTORY_SIZE + 1 : 1);
  for (auto sequence = first_event; sequence <= history.sequence; ++sequence) {
    const auto& evidence = history.events[sequence % HISTORY_SIZE];
    if (evidence.sequence == sequence) {
      WriteEvidence("recent", evidence);
    }
  }
  const auto first_sync = (history.sync_sequence >= SYNC_HISTORY_SIZE ? history.sync_sequence - SYNC_HISTORY_SIZE + 1 : 1);
  for (auto sequence = first_sync; sequence <= history.sync_sequence; ++sequence) {
    const auto& sync = history.sync[sequence % SYNC_HISTORY_SIZE];
    if (sync.sequence != sequence) continue;
    ReportLine line;
    line.Number("sync seq=", sync.sequence);
    line.Number(" qpc=", sync.counter);
    line.Number(" thread=", sync.thread);
    line.Text(" kind=");
    line.Text(sync.kind.data());
    line.Number(" device=", sync.device, 16);
    line.Number(" object=", sync.object, 16);
    line.Number(" request=", sync.request);
    line.Number(" result=", sync.result);
    line.Number(" count=", sync.count);
    line.Number(" handle_bytes=", sync.handle_bytes);
    for (const auto handle : sync.handles) {
      line.Number(" handle=", handle, 16);
    }
    WriteLine(&line);
  }
}

static void WriteDescriptorBatch(const DescriptorBatchObservation& batch) noexcept {
  ReportLine heading;
  heading.Number("descriptor_batch request=", batch.request);
  heading.Number(" qpc=", batch.counter);
  heading.Number(" device=", batch.device, 16);
  heading.Number(" writes_address=", batch.writes_address, 16);
  heading.Number(" writes=", batch.writes);
  heading.Number(" copies=", batch.copies);
  heading.Number(" references=", batch.references);
  heading.Number(" captured=", batch.captured);
  heading.Number(" unreadable=", batch.unreadable);
  heading.Number(" phase=", batch.phase);
  WriteLine(&heading);
  for (std::uint32_t index = 0; index < batch.captured; ++index) {
    const auto& input = batch.inputs[index];
    ReportLine line;
    line.Number("descriptor_input index=", index);
    line.Number(" view=", input.view, 16);
    line.Number(" set=", input.descriptor_set, 16);
    line.Number(" address=", input.input_address, 16);
    line.Number(" binding=", input.binding);
    line.Number(" element=", input.element);
    line.Number(" type=", input.type);
    WriteLine(&line);
    if (trace.history == nullptr || input.view == 0) continue;
    const auto hash = ((input.view >> 4) ^ (input.view >> 21) ^ (batch.device >> 5)) % VIEW_SLOTS;
    for (std::size_t probe = 0; probe < VIEW_PROBE_LIMIT; ++probe) {
      const auto& entry = trace.history->views[(hash + probe) % VIEW_SLOTS];
      if (entry.view == input.view && entry.device == batch.device) {
        WriteView(entry);
        break;
      }
    }
  }
}

static std::uint64_t RecordView(const ViewObservation& observation) noexcept {
  if (!ready.load(std::memory_order_acquire) || observation.view == 0) return 0;
  LARGE_INTEGER counter = {};
  QueryPerformanceCounter(&counter);
  Evidence evidence = {
      .observation = observation,
      .tick = GetTickCount64(),
      .counter = counter.QuadPart,
      .thread = GetCurrentThreadId(),
  };
  const bool descriptor_input = observation.event == ViewEvent::DESCRIPTOR_INPUT;
  const bool descriptor_return = observation.event == ViewEvent::DESCRIPTOR_RETURN;
  if (!descriptor_input && !descriptor_return) {
    evidence.frames = CaptureStackBackTrace(1, static_cast<DWORD>(evidence.stack.size()), evidence.stack.data(), nullptr);
  }
  const RecorderLock lock;
  if (!lock || !ready.load(std::memory_order_relaxed) || trace.history == nullptr) return 0;
  auto& history = *trace.history;
  // Publish the sequence with its ring entry below. Reports made before that
  // must see all 128 preceding events, not 127 plus an unwritten trigger slot.
  evidence.sequence = history.sequence + 1;
  ViewEvidence* entry = nullptr;
  ViewEvidence* replacement = nullptr;
  const auto hash = ((observation.view >> 4) ^ (observation.view >> 21) ^ (observation.device >> 5)) % VIEW_SLOTS;
  for (std::size_t probe = 0; probe < VIEW_PROBE_LIMIT; ++probe) {
    auto& candidate = history.views[(hash + probe) % VIEW_SLOTS];
    if (candidate.view == observation.view && candidate.device == observation.device) {
      entry = &candidate;
      break;
    }
    if (candidate.lifetime.active_destroys == 0
        && (replacement == nullptr || candidate.last_sequence < replacement->last_sequence)) {
      replacement = &candidate;
    }
  }
  if (entry == nullptr && replacement != nullptr) {
    if (replacement->view != 0) {
      ++history.evictions;
    }
    *replacement = {.device = observation.device, .view = observation.view};
    // Unique even for unknown histories or reused slots; stale returns cannot
    // accidentally match a new slot's generation zero.
    replacement->lifetime.generation = evidence.sequence;
    entry = replacement;
  }
  if (entry == nullptr) {
    ++history.untracked;
    history.events[evidence.sequence % HISTORY_SIZE] = evidence;
    history.sequence = evidence.sequence;
    return 0;
  }

  lifetime::Problem problem = lifetime::Problem::NONE;
  switch (observation.event) {
    case ViewEvent::CREATE:
      problem = entry->lifetime.Apply(lifetime::Event::CREATE, observation.request);
      entry->lifetime.generation = evidence.sequence;
      break;
    case ViewEvent::IMAGE_DESTROY_ENTER:
    case ViewEvent::BUFFER_DESTROY_ENTER:
      if (entry->first_destroy.sequence == 0) {
        entry->reference_before_destroy = entry->last_reference;
        entry->reference_return_before_destroy = entry->last_reference_return;
      }
      problem = entry->lifetime.Apply(lifetime::Event::DESTROY_ENTER, observation.request);
      if (observation.event == ViewEvent::BUFFER_DESTROY_ENTER) {
        ++history.destroy_enters;
      }
      break;
    case ViewEvent::IMAGE_DESTROY_RETURN:
    case ViewEvent::BUFFER_DESTROY_RETURN:
      problem = entry->lifetime.Apply(lifetime::Event::DESTROY_RETURN, observation.request, observation.generation);
      if (observation.event == ViewEvent::BUFFER_DESTROY_RETURN) {
        ++history.destroy_returns;
      }
      break;
    case ViewEvent::DESTROY_CALLBACK:
    case ViewEvent::DESTROY_CALLBACK_UNKNOWN:
      problem = entry->lifetime.Apply(lifetime::Event::DESTROY_EVENT, observation.request);
      break;
    case ViewEvent::BUFFER_CREATE_RETURN:
      if (observation.generation == 0 || observation.generation != entry->lifetime.generation
          || observation.request == 0 || entry->creation.sequence == 0
          || observation.request != entry->creation.observation.request) {
        problem = lifetime::Problem::RETURN_FROM_OLDER_LIFETIME;
      }
      break;
    case ViewEvent::DESCRIPTOR_INPUT:
      problem = entry->lifetime.ReferenceProblem();
      break;
    case ViewEvent::DESCRIPTOR_RETURN:
    case ViewEvent::SHARED_RETIRE:
      break;
  }
  // Preserve generation zero for an uncorrelated creation return. Do not label
  // its description as belonging to an older, already tracked native lifetime.
  if (observation.event != ViewEvent::BUFFER_CREATE_RETURN) {
    evidence.observation.generation = entry->lifetime.generation;
  }
  const auto problem_bit = (1u << static_cast<unsigned>(problem));
  const bool report_new = (descriptor_input ? !entry->descriptor_reported : (history.reported_problems & problem_bit) == 0);
  if (problem != lifetime::Problem::NONE && history.reports < VIEW_REPORT_LIMIT && report_new) {
    if (descriptor_input) {
      entry->descriptor_reported = true;
      evidence.frames = CaptureStackBackTrace(1, static_cast<DWORD>(evidence.stack.size()), evidence.stack.data(), nullptr);
    }
    history.reported_problems |= problem_bit;
    ReportLine line;
    line.Number("ANOMALY report=", ++history.reports);
    line.Number(" problem=", static_cast<unsigned>(problem));
    line.Number(" evictions=", history.evictions);
    line.Number(" untracked=", history.untracked);
    line.Number(" active_destroys=", entry->lifetime.active_destroys);
    line.Number(" native_completed=", static_cast<unsigned>(entry->lifetime.native_completed));
    WriteLine(&line);
    WriteView(*entry);
    WriteEvidence("trigger", evidence);
    if (active_descriptor_batch != nullptr) {
      WriteDescriptorBatch(*active_descriptor_batch);
    }
    WriteHistories();
    WriteCallerCode(entry->creation);
    WriteCallerCode(entry->first_destroy);
    WriteCallerCode(evidence);
    FlushReport();
  }

  switch (observation.event) {
    case ViewEvent::CREATE:
      // Save any preceding lifetime in the report before resetting its evidence.
      *entry = {.device = observation.device, .view = observation.view, .lifetime = entry->lifetime, .creation = evidence};
      break;
    case ViewEvent::BUFFER_CREATE_RETURN:
      if (problem != lifetime::Problem::RETURN_FROM_OLDER_LIFETIME) {
        entry->description = evidence;
      }
      break;
    case ViewEvent::IMAGE_DESTROY_ENTER:
    case ViewEvent::BUFFER_DESTROY_ENTER:
      if (entry->first_destroy.sequence == 0) {
        entry->first_destroy = evidence;
      }
      break;
    case ViewEvent::IMAGE_DESTROY_RETURN:
    case ViewEvent::BUFFER_DESTROY_RETURN:
      if (entry->first_return.sequence == 0 && problem != lifetime::Problem::RETURN_FROM_OLDER_LIFETIME) {
        entry->first_return = evidence;
      }
      break;
    case ViewEvent::DESTROY_CALLBACK:
    case ViewEvent::DESTROY_CALLBACK_UNKNOWN:
      if (entry->first_event.sequence == 0) {
        entry->first_event = evidence;
      }
      break;
    case ViewEvent::DESCRIPTOR_INPUT:
      entry->last_reference = evidence;
      break;
    case ViewEvent::DESCRIPTOR_RETURN:
      if (entry->last_reference.observation.request == observation.request) {
        entry->last_reference_return = evidence;
      }
      break;
    case ViewEvent::SHARED_RETIRE:
      break;
  }
  entry->last_sequence = evidence.sequence;
  history.events[evidence.sequence % HISTORY_SIZE] = evidence;
  history.sequence = evidence.sequence;
  return evidence.observation.generation;
}

static LONG CALLBACK OnException(EXCEPTION_POINTERS* exception) noexcept {
  if (exception_observer_active || recorder_entered || !ready.load(std::memory_order_acquire)
      || exception == nullptr || exception->ExceptionRecord == nullptr || exception->ContextRecord == nullptr
      || exception->ExceptionRecord->ExceptionCode != EXCEPTION_ACCESS_VIOLATION) return EXCEPTION_CONTINUE_SEARCH;
  exception_observer_active = true;
  struct ResetObserver {
    ~ResetObserver() { exception_observer_active = false; }
  } reset_observer;
  const RecorderLock lock(LockMode::TRY);
  if (!lock || !ready.load(std::memory_order_relaxed) || trace.history == nullptr
      || trace.history->fault_reports >= AV_REPORT_LIMIT) return EXCEPTION_CONTINUE_SEARCH;
  auto* batch = active_descriptor_batch;
  const auto& registers = *exception->ContextRecord;
  const bool driver_fault = registers.Rip >= trace.driver_begin && registers.Rip < trace.driver_end;
  const bool native_fault = native_call.request != 0 && (native_call.creating || native_call.destroying);
  if ((batch == nullptr && !driver_fault && !native_fault)
      || (batch != nullptr && batch->fault_reported)
      || (native_fault && native_call.fault_reported)) return EXCEPTION_CONTINUE_SEARCH;
  if (batch != nullptr) {
    batch->fault_reported = true;
  }
  if (native_fault) {
    native_call.fault_reported = true;
  }
  LARGE_INTEGER counter = {};
  QueryPerformanceCounter(&counter);
  ReportLine line;
  line.Number("FIRST_CHANCE_AV report=", ++trace.history->fault_reports);
  line.Number(" qpc=", counter.QuadPart);
  line.Number(" thread=", GetCurrentThreadId());
  line.Number(" hooked_batch=", static_cast<unsigned>(batch != nullptr));
  line.Number(" native_request=", native_call.request);
  line.Number(" native_device=", native_call.device, 16);
  line.Number(" native_view=", native_call.view, 16);
  line.Number(" native_creating=", static_cast<unsigned>(native_call.creating));
  line.Number(" native_destroying=", static_cast<unsigned>(native_call.destroying));
  line.Number(" native_buffer=", static_cast<unsigned>(native_call.kind == ViewKind::BUFFER));
  line.Number(" address=", reinterpret_cast<std::uintptr_t>(exception->ExceptionRecord->ExceptionAddress), 16);
  line.Number(" rip=", registers.Rip, 16);
  line.Number(" rsp=", registers.Rsp, 16);
  if (exception->ExceptionRecord->NumberParameters >= 2) {
    line.Number(" access=", exception->ExceptionRecord->ExceptionInformation[0]);
    line.Number(" target=", exception->ExceptionRecord->ExceptionInformation[1], 16);
  }
  WriteLine(&line);
  if (batch != nullptr) {
    WriteDescriptorBatch(*batch);
  }
  const std::array<std::uint64_t, 16> addresses = {
      registers.Rax,
      registers.Rbx,
      registers.Rcx,
      registers.Rdx,
      registers.Rsi,
      registers.Rdi,
      registers.Rbp,
      registers.Rsp,
      registers.R8,
      registers.R9,
      registers.R10,
      registers.R11,
      registers.R12,
      registers.R13,
      registers.R14,
      registers.R15,
  };
  ReportLine values;
  values.Text("registers order=rax,rbx,rcx,rdx,rsi,rdi,rbp,rsp,r8,r9,r10,r11,r12,r13,r14,r15");
  for (const auto address : addresses) {
    values.Number(" value=", address, 16);
  }
  WriteLine(&values);
  // Match saved integers only. No driver calls, freed-object reads, stack walk,
  // symbol lookup, or allocation on this path. A candidate is not proof of use.
  std::uint32_t found = 0;
  for (const auto& entry : trace.history->views) {
    if (entry.view == 0) continue;
    if (std::ranges::find(addresses, entry.view) == addresses.end()) continue;
    WriteView(entry);
    if (++found == 16) break;
  }
  WriteHistories();
  FlushReport();
  // First-chance exceptions may be recovered by another handler.
  return EXCEPTION_CONTINUE_SEARCH;
}

}  // namespace internal

[[nodiscard]] inline bool IsActive() noexcept {
  return internal::ready.load(std::memory_order_acquire);
}

inline std::uint64_t NextRequest() noexcept {
  return internal::next_request.fetch_add(1, std::memory_order_relaxed) + 1;
}

inline void RecordSync(const SyncObservation& observation) noexcept {
  if (!IsActive()) return;
  LARGE_INTEGER counter = {};
  QueryPerformanceCounter(&counter);
  internal::SyncEvidence evidence = {
      .counter = counter.QuadPart,
      .device = observation.device,
      .object = observation.object,
      .request = observation.request,
      .result = observation.result,
      .count = observation.count,
      .thread = GetCurrentThreadId(),
  };
  if (observation.kind != nullptr) {
    for (std::size_t index = 0; index + 1 < evidence.kind.size() && observation.kind[index] != '\0'; ++index) {
      evidence.kind[index] = observation.kind[index];
    }
  }
  if (observation.handles != nullptr) {
    ReadProcessMemory(GetCurrentProcess(), observation.handles, evidence.handles.data(),
                      (std::min)(evidence.handles.size(), static_cast<std::size_t>(observation.count)) * sizeof(std::uint64_t),
                      &evidence.handle_bytes);
  }
  const internal::RecorderLock lock;
  if (!lock || !IsActive() || internal::trace.history == nullptr) return;
  auto& history = *internal::trace.history;
  evidence.sequence = ++history.sync_sequence;
  history.sync[evidence.sequence % internal::SYNC_HISTORY_SIZE] = evidence;
}

// The optional detour group pins the recorder until removal actually succeeds.
// Required rendering producers must also be stopped by the addon before Use(detach).
inline void RetainNativeHookProducer() noexcept {
  internal::native_hook_producers.fetch_add(1, std::memory_order_relaxed);
}

inline void ReleaseNativeHookProducer() noexcept {
  internal::native_hook_producers.fetch_sub(1, std::memory_order_relaxed);
}

class ViewDestroyScope {
 public:
  explicit ViewDestroyScope(const DestroyObservation& observation) noexcept
      : observation(observation), outer(internal::native_call) {
    internal::native_call = {
        .request = NextRequest(),
        .device = observation.device,
        .view = observation.view,
        .destroying = true,
        .kind = observation.kind,
    };
    internal::native_call.generation = internal::RecordView({
        .event = (observation.kind == ViewKind::BUFFER ? internal::ViewEvent::BUFFER_DESTROY_ENTER : internal::ViewEvent::IMAGE_DESTROY_ENTER),
        .device = observation.device,
        .view = observation.view,
        .request = internal::native_call.request,
    });
  }

  ViewDestroyScope(const ViewDestroyScope&) = delete;
  ViewDestroyScope& operator=(const ViewDestroyScope&) = delete;
  ~ViewDestroyScope() { internal::native_call = outer; }

  // Explicit: unwinding out of a native call must not invent a normal return.
  void Returned() noexcept {
    internal::RecordView({
        .event = (observation.kind == ViewKind::BUFFER ? internal::ViewEvent::BUFFER_DESTROY_RETURN : internal::ViewEvent::IMAGE_DESTROY_RETURN),
        .device = observation.device,
        .view = observation.view,
        .request = internal::native_call.request,
        .generation = internal::native_call.generation,
    });
    internal::native_call.destroying = false;  // The original returned normally.
  }

 private:
  DestroyObservation observation;
  internal::NativeCall outer;
};

class BufferCreationScope {
 public:
  explicit BufferCreationScope(const BufferCreationObservation& observation) noexcept
      : observation(observation), outer(internal::native_call) {
    internal::native_call = {
        .request = NextRequest(),
        .device = observation.device,
        .creating = true,
        .kind = ViewKind::BUFFER,
    };
    const internal::RecorderLock lock;
    if (lock && IsActive() && internal::trace.history != nullptr) {
      ++internal::trace.history->create_enters;
    }
  }

  BufferCreationScope(const BufferCreationScope&) = delete;
  BufferCreationScope& operator=(const BufferCreationScope&) = delete;
  ~BufferCreationScope() { internal::native_call = outer; }

  void Returned(const CreationResultObservation& result) noexcept {
    internal::native_call.creating = false;
    if (!IsActive()) return;
    std::uint32_t report = 0;
    {
      const internal::RecorderLock lock;
      if (!lock || !IsActive() || internal::trace.history == nullptr) return;
      auto& history = *internal::trace.history;
      ++history.create_returns;
      if (result.result != 0 && history.failure_reports < internal::CREATION_REPORT_LIMIT) {
        report = ++history.failure_reports;
      }
    }
    if (result.result == 0) {
      if (result.output_bytes == sizeof(result.output)) {
        internal::RecordView({
            .event = internal::ViewEvent::BUFFER_CREATE_RETURN,
            .device = observation.device,
            .view = result.output,
            .resource = observation.buffer,
            .offset = observation.offset,
            .range = observation.range,
            .request = internal::native_call.request,
            .generation = (internal::native_call.view == result.output ? internal::native_call.generation : 0),
            .format = observation.format,
        });
      }
      return;
    }
    if (report == 0) return;

    internal::ReportLine totals;
    if (report == 1) {
      std::uint64_t resources = 0;
      std::uint64_t buffers = 0;
      std::uint64_t buffer_bytes = 0;
      std::uint64_t uploads = 0;
      std::uint64_t upload_bytes = 0;
      std::uint64_t textures = 0;
      std::uint64_t texture_bytes = 0;
      std::uint64_t upgraded = 0;
      std::uint64_t clones = 0;
      std::uint64_t views = 0;
      std::uint64_t buffer_views = 0;
      std::uint64_t cloned_views = 0;
      bool scanned = false;
      bool scan_failed = false;
      // Resource retirement can call this recorder while holding resource locks.
      // NEVER hold RecorderLock during this scan. Counts are non-atomic estimates
      // of core records, not all addon allocations, a GPU budget, or ownership.
      try {
        if (renodx::utils::resource::shared.data != nullptr) {
          scanned = true;
          renodx::utils::resource::shared.data->resource_infos.for_each([&](const auto& pair) {
            const auto& [handle, info] = pair;
            if (info.destroyed || info.device == nullptr || info.device->get_native() != observation.device) return;
            ++resources;
            if (info.desc.type == reshade::api::resource_type::buffer) {
              ++buffers;
              buffer_bytes += info.desc.buffer.size;
              if (info.desc.heap == reshade::api::memory_heap::cpu_to_gpu) {
                ++uploads;
                upload_bytes += info.desc.buffer.size;
              }
            } else if (info.desc.type == reshade::api::resource_type::texture_2d
                       || info.desc.type == reshade::api::resource_type::texture_3d
                       || info.desc.type == reshade::api::resource_type::surface) {
              ++textures;
              texture_bytes += renodx::utils::resource::ComputeTextureSize(info.desc);
              upgraded += info.upgraded;
              clones += info.is_clone;
            }
          });
          renodx::utils::resource::shared.data->resource_view_infos.for_each([&](const auto& pair) {
            const auto& [handle, info] = pair;
            if (info.destroyed || info.device == nullptr || info.device->get_native() != observation.device) return;
            ++views;
            buffer_views += info.desc.type == reshade::api::resource_view_type::buffer;
            cloned_views += info.is_clone;
          });
        }
      } catch (...) {
        scan_failed = true;
      }
      totals.Text("allocation_snapshot incomplete=1 non_atomic=1");
      totals.Number(" scanned=", static_cast<unsigned>(scanned));
      totals.Number(" scan_failed=", static_cast<unsigned>(scan_failed));
      totals.Number(" resources=", resources);
      totals.Number(" buffers=", buffers);
      totals.Number(" buffer_bytes=", buffer_bytes);
      totals.Number(" upload_buffers=", uploads);
      totals.Number(" upload_bytes=", upload_bytes);
      totals.Number(" textures=", textures);
      totals.Number(" estimated_texture_bytes=", texture_bytes);
      totals.Number(" upgraded_textures=", upgraded);
      totals.Number(" cloned_textures=", clones);
      totals.Number(" views=", views);
      totals.Number(" buffer_views=", buffer_views);
      totals.Number(" cloned_views=", cloned_views);
    }
    internal::Evidence caller = {
        .observation = {.device = observation.device, .request = internal::native_call.request},
        .thread = GetCurrentThreadId(),
    };
    caller.frames = CaptureStackBackTrace(1, static_cast<DWORD>(caller.stack.size()), caller.stack.data(), nullptr);
    const internal::RecorderLock lock;
    if (!lock || !IsActive() || internal::trace.history == nullptr) return;
    if (report == 1) {
      internal::WriteLine(&totals);
    }
    internal::ReportLine line;
    line.Number("BUFFER_CREATE_FAILURE report=", report);
    line.Number(" request=", internal::native_call.request);
    line.Number(" thread=", GetCurrentThreadId());
    line.Number(" result=", result.result);
    line.Number(" device=", observation.device, 16);
    line.Number(" output_slot=", observation.output_slot, 16);
    line.Number(" before=", observation.previous_output, 16);
    line.Number(" before_bytes=", observation.previous_bytes);
    line.Number(" after=", result.output, 16);
    line.Number(" after_bytes=", result.output_bytes);
    line.Number(" info_readable=", static_cast<unsigned>(observation.info_readable));
    line.Number(" buffer=", observation.buffer, 16);
    line.Number(" format=", observation.format);
    line.Number(" offset=", observation.offset, 16);
    line.Number(" range=", observation.range, 16);
    internal::WriteLine(&line);
    caller.sequence = internal::trace.history->sequence + 1;
    internal::WriteEvidence("failed_create_caller", caller);
    internal::WriteCallerCode(caller);
    internal::WriteHistories();
    internal::FlushReport();
  }

 private:
  BufferCreationObservation observation;
  internal::NativeCall outer;
};

class DescriptorUpdateScope {
 public:
  explicit DescriptorUpdateScope(DescriptorBatchObservation* observation) noexcept
      : batch(observation),
        outer_call(internal::native_call),
        outer_batch(internal::active_descriptor_batch) {
    LARGE_INTEGER counter = {};
    QueryPerformanceCounter(&counter);
    batch->request = NextRequest();
    batch->counter = counter.QuadPart;
    batch->phase = 0;
    internal::native_call = {.request = batch->request, .device = batch->device};
    internal::active_descriptor_batch = batch;
    const internal::RecorderLock lock;
    if (lock && IsActive() && internal::trace.history != nullptr) {
      ++internal::trace.history->descriptor_updates;
    }
  }

  DescriptorUpdateScope(const DescriptorUpdateScope&) = delete;
  DescriptorUpdateScope& operator=(const DescriptorUpdateScope&) = delete;
  ~DescriptorUpdateScope() {
    internal::native_call = outer_call;
    internal::active_descriptor_batch = outer_batch;
  }

  // Used for every readable original reference before forwarding, and for the
  // bounded saved references after return. Recording never grows the snapshot.
  void Record(const DescriptorInput& input) noexcept {
    internal::RecordView({
        .event = (batch->phase == 3 ? internal::ViewEvent::DESCRIPTOR_RETURN : internal::ViewEvent::DESCRIPTOR_INPUT),
        .device = batch->device,
        .view = input.view,
        .resource = input.descriptor_set,
        .offset = input.binding,
        .range = input.element,
        .request = batch->request,
        .format = input.type,
    });
  }

  void Returned() noexcept {
    batch->phase = 3;
    for (std::uint32_t index = 0; index < batch->captured; ++index) {
      Record(batch->inputs[index]);
    }
  }

 private:
  DescriptorBatchObservation* batch;
  internal::NativeCall outer_call;
  DescriptorBatchObservation* outer_batch;
};

namespace internal {

static void OnInitResourceView(reshade::api::device* device, reshade::api::resource resource,
                               [[maybe_unused]] reshade::api::resource_usage usage, const reshade::api::resource_view_desc& desc,
                               reshade::api::resource_view view) {
  if (!IsActive() || device->get_api() != reshade::api::device_api::vulkan) return;
  const bool creating = native_call.creating && native_call.device == device->get_native();
  const auto generation = RecordView({
      .event = ViewEvent::CREATE,
      .device = device->get_native(),
      .view = view.handle,
      .resource = resource.handle,
      .request = (creating ? native_call.request : 0),
      .format = static_cast<std::uint32_t>(desc.format),
  });
  if (creating) {
    native_call.generation = generation;
    native_call.view = view.handle;
  }
}

static void OnDestroyResourceView(reshade::api::device* device, reshade::api::resource_view view) {
  if (!IsActive() || device->get_api() != reshade::api::device_api::vulkan) return;
  ViewObservation observation = {
      .event = ViewEvent::DESTROY_CALLBACK_UNKNOWN,
      .device = device->get_native(),
      .view = view.handle,
  };
  if (native_call.device == observation.device && native_call.view == view.handle && !native_call.creating) {
    observation.request = native_call.request;
  }
  // Copy existing metadata while valid; do not query the native view. A shared
  // destroyed flag alone does not establish a repeated Vulkan destruction.
  try {
    if (renodx::utils::resource::shared.data != nullptr) {
      renodx::utils::resource::GetResourceViewInfo(view, [&](const auto& info) {
        if (info.device != device) return;
        observation.event = ViewEvent::DESTROY_CALLBACK;
        observation.resource = info.original_resource.handle;
        observation.clone = info.clone.handle;
        observation.fallback = info.fallback.handle;
        observation.destroyed = info.destroyed;
        observation.is_clone = info.is_clone;
      });
    }
  } catch (...) {
    // Missing metadata is an observation gap, not a rendering failure.
  }
  RecordView(observation);
}

static void OnRetireView(renodx::utils::resource::ResourceViewInfo* info) {
  if (!IsActive() || info == nullptr || info->device == nullptr
      || info->device->get_api() != reshade::api::device_api::vulkan) return;
  RecordView({
      .event = ViewEvent::SHARED_RETIRE,
      .device = info->device->get_native(),
      .view = info->view.handle,
      .resource = info->original_resource.handle,
      .clone = info->clone.handle,
      .fallback = info->fallback.handle,
      .destroyed = info->destroyed,
      .is_clone = info->is_clone,
  });
}

static void OnDestroyDevice(reshade::api::device* device) {
  if (!IsActive() || device->get_api() != reshade::api::device_api::vulkan) return;
  const auto native = device->get_native();
  const RecorderLock lock;
  if (!lock || trace.history == nullptr) return;
  for (auto& entry : trace.history->views) {
    if (entry.device == native) {
      entry = {};
    }
  }
}

}  // namespace internal

// Call once from serialized addon lifecycle, after shared resource setup.
// Stop required native/output producers and optional hooks before detach. This
// does not add support for unloading the addon while game threads are running.
inline void Use(DWORD reason) {
  if (reason == DLL_PROCESS_ATTACH) {
    {
      const internal::RecorderLock lock;
      if (!lock || internal::trace.history != nullptr || internal::trace.exception_handler != nullptr) return;
    }
    if (renodx::utils::resource::shared.data == nullptr) {
      renodx::utils::log::w("rdr2vk: diagnostic recorder needs shared resource callbacks first.");
      return;
    }
    std::array<wchar_t, MAX_PATH> path = {};
    const auto length = GetModuleFileNameW(nullptr, path.data(), static_cast<DWORD>(path.size()));
    if (length == 0 || length >= path.size()) return;
    auto* end = std::wcsrchr(path.data(), L'\\');
    if (end == nullptr) return;
    LARGE_INTEGER counter = {};
    QueryPerformanceCounter(&counter);
    if (swprintf_s(end + 1, path.size() - (end + 1 - path.data()), L"rdr2vk-view-lifetime-v5-%lu-%lld.trace",
                   GetCurrentProcessId(), counter.QuadPart)
        < 0) return;
    auto history = std::unique_ptr<internal::History>(new (std::nothrow) internal::History{});
    if (history == nullptr) {
      renodx::utils::log::w("rdr2vk: diagnostic history allocation failed; rendering is unchanged.");
      return;
    }
    // CREATE_NEW preserves every earlier crash file, including old schema files.
    auto* const file = CreateFileW(path.data(), GENERIC_WRITE, FILE_SHARE_READ, nullptr, CREATE_NEW, FILE_ATTRIBUTE_NORMAL, nullptr);
    if (file == INVALID_HANDLE_VALUE) {
      renodx::utils::log::w("rdr2vk: diagnostic file creation failed; rendering is unchanged.");
      return;
    }
    {
      const internal::RecorderLock lock;
      if (!lock) {
        CloseHandle(file);
        return;
      }
      internal::trace.history = std::move(history);
      internal::trace.file = file;
      internal::trace.failed = false;
      internal::trace.driver_begin = 0;
      internal::trace.driver_end = 0;
      internal::skipped_lock_entries.store(0, std::memory_order_relaxed);
      internal::WriteText(
          "rdr2vk lifetime trace v5: observation only; all original calls are forwarded.\n"
          "Schema change from v4: no blocked_duplicates field or buffer_destroy_blocked event; no destroy mitigation.\n"
          "Limits: views=16384 probes=16 recent_views=128 recent_sync=256 descriptor_inputs=128 view_reports=8 AV_reports=4 creation_reports=16.\n"
          "Normal events remain in memory. Slots may be replaced; active current-generation destroys are not eviction candidates. Missing history is unknown, never proof of safety.\n"
          "Keys are device and handle values, not permanent native object identities. Reuse or simultaneous aliased handles can make observations ambiguous. Generations describe captured history only.\n"
          "All readable original texel-buffer references are checked before forwarding; only the first 128 captured inputs and their returns are saved. Capture and checking read original inputs separately; unreadable counts failed reads, possibly twice.\n"
          "Image/buffer descriptors and descriptor copies are not decoded. Sync handles truncate at 4; names at 31 bytes. Uncorrelated creation returns retain generation=0 and never replace an existing lifetime description.\n"
          "Allocation estimates are incomplete and non-atomic. Zero tracked uploads does not prove zero addon uploads. Diagnostic capture, locks and I/O change CPU timing.\n"
          "Native return/submit success is not GPU completion. First-chance exceptions are not necessarily fatal; observer always continues search.\n"
          "Exception coverage is narrower than v4: only active descriptor batches or instruction addresses in the startup NVIDIA driver range qualify. No exception stack walk, caller-code reads, nearby-memory scan, or freed-object reads.\n"
          "Exception candidates match saved register values only. Busy/reentrant recorder paths are skipped. Other modules and drivers loaded after startup may be missed. Ordinary anomaly/allocation reports still save mapped game caller code.\n"
          "problem=1 recreate_during_destroy;2 overlap;3 repeated_native_destroy;4 duplicate_callback;5 repeated_unbracketed_event;6 old_or_uncorrelated_lifetime_return;7 descriptor_after_destroy;8 descriptor_during_destroy.\n"
          "event=0 create;1 buffer_create_return;2 image_destroy_enter;3 image_destroy_return;4 buffer_destroy_enter;5 buffer_destroy_return;6 destroy_callback;7 destroy_callback_unknown;8 shared_retire;9 descriptor_input;10 descriptor_return.\n"
          "phase=0 capture;1 histories;2 forwarding;3 returned. Register candidates are saved-handle matches only; no freed-object queries or private driver layouts.\n");
      LARGE_INTEGER frequency = {};
      QueryPerformanceFrequency(&frequency);
      internal::ReportLine clock;
      clock.Number("clock qpc_frequency=", frequency.QuadPart);
      internal::WriteLine(&clock);
      const auto driver = reinterpret_cast<std::uintptr_t>(GetModuleHandleW(L"nvoglv64.dll"));
      MEMORY_BASIC_INFORMATION addon = {};
      VirtualQuery(&internal::trace, &addon, sizeof(addon));
      struct ModuleObservation {
        const char* name;
        std::uintptr_t begin;
      };
      for (const auto& module : std::array<ModuleObservation, 3>{{
               {.name = "game", .begin = reinterpret_cast<std::uintptr_t>(GetModuleHandleW(nullptr))},
               {.name = "addon", .begin = reinterpret_cast<std::uintptr_t>(addon.AllocationBase)},
               {.name = "nvoglv64.dll", .begin = driver},
           }}) {
        IMAGE_DOS_HEADER dos = {};
        IMAGE_NT_HEADERS64 nt = {};
        SIZE_T copied = 0;
        std::uintptr_t module_end = 0;
        if (module.begin != 0
            && ReadProcessMemory(GetCurrentProcess(), reinterpret_cast<const void*>(module.begin), &dos, sizeof(dos), &copied) != FALSE
            && copied == sizeof(dos) && dos.e_magic == IMAGE_DOS_SIGNATURE && dos.e_lfanew > 0
            && ReadProcessMemory(GetCurrentProcess(), reinterpret_cast<const void*>(module.begin + dos.e_lfanew), &nt, sizeof(nt), &copied) != FALSE
            && copied == sizeof(nt) && nt.Signature == IMAGE_NT_SIGNATURE
            && nt.OptionalHeader.Magic == IMAGE_NT_OPTIONAL_HDR64_MAGIC && nt.OptionalHeader.SizeOfImage != 0) {
          module_end = module.begin + nt.OptionalHeader.SizeOfImage;
          if (module.begin == driver) {
            internal::trace.driver_begin = driver;
            internal::trace.driver_end = module_end;
          }
        }
        internal::ReportLine range;
        range.Text("module name=");
        range.Text(module.name);
        range.Number(" begin=", module.begin, 16);
        range.Number(" end=", module_end, 16);
        range.Number(" range_known=", static_cast<unsigned>(module_end != 0));
        internal::WriteLine(&range);
      }
    }

    bool initialized = false;
    bool init_registered = false;
    bool destroy_registered = false;
    bool device_registered = false;
    bool retire_registered = false;
    PVOID handler = nullptr;
    try {
      {
        const internal::RecorderLock lock;
        if (lock && !internal::trace.failed) {
          handler = AddVectoredExceptionHandler(1, internal::OnException);
          internal::trace.exception_handler = handler;
        }
      }
      if (handler != nullptr) {
        reshade::register_event<reshade::addon_event::init_resource_view>(internal::OnInitResourceView);
        init_registered = true;
        reshade::register_event<reshade::addon_event::destroy_resource_view>(internal::OnDestroyResourceView);
        destroy_registered = true;
        reshade::register_event<reshade::addon_event::destroy_device>(internal::OnDestroyDevice);
        device_registered = true;
        renodx::utils::resource::RegisterOnDestroyResourceViewInfoCallback(internal::OnRetireView);
        retire_registered = true;
        const internal::RecorderLock lock;
        if (lock) {
          internal::trace.callbacks_registered = true;
          internal::ready.store(true, std::memory_order_release);
          initialized = true;
        }
      }
    } catch (...) {
      // Optional setup must not escape into addon/rendering initialization.
    }
    if (initialized) return;
    if (retire_registered) {
      renodx::utils::resource::UnregisterOnDestroyResourceViewInfoCallback(internal::OnRetireView);
    }
    if (device_registered) {
      reshade::unregister_event<reshade::addon_event::destroy_device>(internal::OnDestroyDevice);
    }
    if (destroy_registered) {
      reshade::unregister_event<reshade::addon_event::destroy_resource_view>(internal::OnDestroyResourceView);
    }
    if (init_registered) {
      reshade::unregister_event<reshade::addon_event::init_resource_view>(internal::OnInitResourceView);
    }
    const bool handler_removed = handler == nullptr || RemoveVectoredExceptionHandler(handler) != 0;
    {
      const internal::RecorderLock lock;
      if (lock) {
        if (handler_removed) {
          internal::trace.exception_handler = nullptr;
        }
        // An unremoved handler sees ready=false and cannot touch released data.
        CloseHandle(internal::trace.file);
        internal::trace.file = INVALID_HANDLE_VALUE;
        internal::trace.history.reset();
      }
    }
    renodx::utils::log::w("rdr2vk: diagnostic setup failed and was cleaned up; rendering is unchanged.");
  } else if (reason == DLL_PROCESS_DETACH) {
    if (internal::native_hook_producers.load(std::memory_order_relaxed) != 0) {
      renodx::utils::log::w("rdr2vk: diagnostic hooks remain installed; retaining recorder state. Do not unload this addon.");
      return;
    }
    bool registered = false;
    PVOID handler = nullptr;
    {
      const internal::RecorderLock lock;
      if (!lock) return;
      internal::ready.store(false, std::memory_order_release);
      registered = std::exchange(internal::trace.callbacks_registered, false);
      handler = internal::trace.exception_handler;
    }
    if (registered) {
      reshade::unregister_event<reshade::addon_event::init_resource_view>(internal::OnInitResourceView);
      reshade::unregister_event<reshade::addon_event::destroy_resource_view>(internal::OnDestroyResourceView);
      reshade::unregister_event<reshade::addon_event::destroy_device>(internal::OnDestroyDevice);
      if (renodx::utils::resource::shared.data != nullptr) {
        renodx::utils::resource::UnregisterOnDestroyResourceViewInfoCallback(internal::OnRetireView);
      }
    }
    if (handler != nullptr && RemoveVectoredExceptionHandler(handler) == 0) {
      renodx::utils::log::w("rdr2vk: exception observer removal failed; retaining its state. Do not unload this addon.");
      return;
    }
    const internal::RecorderLock lock;
    if (!lock) return;
    internal::trace.exception_handler = nullptr;
    if (internal::trace.history != nullptr) {
      const auto& history = *internal::trace.history;
      internal::ReportLine summary;
      summary.Number("shutdown events=", history.sequence);
      summary.Number(" evictions=", history.evictions);
      summary.Number(" untracked=", history.untracked);
      summary.Number(" skipped_lock_entries=", internal::skipped_lock_entries.load(std::memory_order_relaxed));
      summary.Number(" reports=", history.reports);
      summary.Number(" buffer_create_enter=", history.create_enters);
      summary.Number(" buffer_create_return=", history.create_returns);
      summary.Number(" buffer_destroy_enter=", history.destroy_enters);
      summary.Number(" buffer_destroy_return=", history.destroy_returns);
      summary.Number(" descriptor_updates=", history.descriptor_updates);
      summary.Number(" sync_events=", history.sync_sequence);
      summary.Number(" fault_reports=", history.fault_reports);
      summary.Number(" failure_reports=", history.failure_reports);
      internal::WriteLine(&summary);
      internal::FlushReport();
    }
    if (internal::trace.file != INVALID_HANDLE_VALUE) {
      CloseHandle(internal::trace.file);
      internal::trace.file = INVALID_HANDLE_VALUE;
    }
    internal::trace.history.reset();
  }
}

}  // namespace rdr2vk::diagnostics

#endif  // RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS