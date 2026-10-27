/*
 * Copyright (C) 2026 Musa Haji
 * SPDX-License-Identifier: MIT
 */

#pragma once

// Normal builds leave temporary crash recording off. Set to 1 only for an
// investigation. Zero removes the recorder and its duplicate-destroy block
// from the build; the hooks needed for scene/UI drawing order stay active.
#ifndef RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS
#define RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS 0
#endif

#if RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS

#include <windows.h>

#include <rpc.h>
#include <rpcndr.h>

#include <array>
#include <atomic>
#include <bit>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <memory>
#include <mutex>
#include <shared_mutex>

#include "../../utils/log.hpp"
#include "./view_lifetime_state.hpp"

namespace rdr2vk::view_lifetime_trace {

static constexpr std::size_t HISTORY_SIZE = 128;
static constexpr std::size_t VIEW_SLOTS = 16384;
static constexpr std::uint32_t REPORT_LIMIT = 8;
static constexpr std::size_t DESCRIPTOR_REFERENCE_LIMIT = 128;
static constexpr std::size_t SYNC_HISTORY_SIZE = 256;
struct NativeCall {
  std::uint64_t request = 0;
  std::uint64_t generation = 0;
  bool creating = false;
};
static thread_local NativeCall native_call;
static std::atomic_uint64_t next_request = 0;

struct Evidence {
  std::uint64_t sequence = 0;
  std::uint64_t tick = 0;
  std::int64_t counter = 0;
  std::uint64_t device = 0;
  std::uint64_t view = 0;
  std::uint64_t resource = 0;
  std::uint64_t clone = 0;
  std::uint64_t fallback = 0;
  std::uint64_t offset = 0;
  std::uint64_t range = 0;
  std::uint64_t request = 0;
  std::uint64_t generation = 0;
  DWORD thread = 0;
  std::uint32_t format = 0;
  bool destroyed = false;
  bool is_clone = false;
  char event[32] = {};
  std::array<void*, 16> stack = {};
  USHORT frames = 0;
};
struct ViewEvidence {
  std::uint64_t device = 0;
  std::uint64_t view = 0;
  std::uint64_t last_sequence = 0;
  LifetimeState lifetime;
  bool ambiguous_creation = false;
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
struct DescriptorReference {
  std::uint64_t view = 0;
  std::uint64_t descriptor_set = 0;
  std::uint64_t input_address = 0;
  std::uint32_t binding = 0;
  std::uint32_t element = 0;
  std::uint32_t type = 0;
};
struct DescriptorBatch {
  std::uint64_t request = 0;
  std::uint64_t device = 0;
  std::int64_t counter = 0;
  std::uint64_t writes_address = 0;
  std::uint32_t writes = 0;
  std::uint32_t copies = 0;
  std::uint32_t references = 0;
  std::uint32_t captured = 0;
  std::uint32_t phase = 0;
  bool fault_reported = false;
  std::array<DescriptorReference, DESCRIPTOR_REFERENCE_LIMIT> inputs;
};
static thread_local DescriptorBatch* active_descriptor_batch = nullptr;
static thread_local bool exception_observer_active = false;

struct SyncEvidence {
  std::uint64_t sequence = 0;
  std::int64_t counter = 0;
  std::uint64_t device = 0;
  std::uint64_t object = 0;
  std::uint64_t request = 0;
  std::int32_t result = 0;
  std::uint32_t count = 0;
  DWORD thread = 0;
  char event[24] = {};
  std::array<std::uint64_t, 4> fences = {};
};
struct TraceState {
  std::shared_mutex mutex;
  HANDLE file = INVALID_HANDLE_VALUE;
  std::unique_ptr<std::array<ViewEvidence, VIEW_SLOTS>> views;
  std::array<Evidence, HISTORY_SIZE> history;
  std::uint64_t sequence = 0;
  std::uint64_t evictions = 0;
  std::uint64_t untracked = 0;
  std::uint64_t create_enters = 0;
  std::uint64_t create_returns = 0;
  std::uint64_t destroy_enters = 0;
  std::uint64_t destroy_returns = 0;
  std::uint32_t reports = 0;
  std::uint32_t reported_problems = 0;
  std::uint64_t blocked_duplicates = 0;
  std::uint64_t descriptor_updates = 0;
  std::array<SyncEvidence, SYNC_HISTORY_SIZE> sync_history;
  std::uint64_t sync_sequence = 0;
  std::uint32_t fault_reports = 0;
  std::uint32_t failure_reports = 0;
  PVOID exception_handler = nullptr;
  std::uintptr_t driver_begin = 0;
  std::uintptr_t driver_end = 0;
  bool failed = false;
};
static TraceState trace;

// A destroyed flag is not enough to block a call. We need a successful creation,
// then the destroy call, its callback, and its return for this exact lifetime.
// If records are missing or could describe different views, allow the call.
static bool HasCompletedBufferLifetime(const ViewEvidence& entry) {
  const auto generation = entry.lifetime.generation;
  return generation != 0 && !entry.ambiguous_creation && entry.lifetime.active_destroys == 0 && entry.lifetime.native_completed
         && entry.creation.sequence != 0 && entry.creation.generation == generation
         && entry.description.sequence > entry.creation.sequence && entry.description.generation == generation
         && entry.description.request != 0 && entry.description.request == entry.creation.request
         && strcmp(entry.description.event, "buffer_create_return") == 0
         && entry.first_destroy.sequence > entry.description.sequence && entry.first_destroy.generation == generation
         && strcmp(entry.first_destroy.event, "buffer_destroy_enter") == 0
         && entry.first_event.sequence > entry.first_destroy.sequence
         && entry.first_event.request == entry.first_destroy.request && entry.first_event.generation == generation
         && entry.first_return.sequence > entry.first_event.sequence && entry.first_return.generation == generation
         && entry.first_return.request == entry.first_destroy.request
         && strcmp(entry.first_return.event, "buffer_destroy_return") == 0;
}

// Normal events stay in memory. Write only startup/shutdown summaries, one-time
// hook checks, and the limited number of error reports to the file.
static void WriteText(const char* text) {
  if (trace.file == INVALID_HANDLE_VALUE || trace.failed) return;
  const auto size = static_cast<DWORD>(strlen(text));
  DWORD written = 0;
  if (WriteFile(trace.file, text, size, &written, nullptr) == FALSE || written != size) {
    trace.failed = true;
    if (!exception_observer_active) {
      renodx::utils::log::e("rdr2vk: could not write the view-lifetime report; error=", GetLastError());
    }
  }
}

static void WriteEvidence(const char* label, const Evidence& evidence) {
  if (evidence.sequence == 0) return;
  std::array<char, 2048> line = {};
  int used = snprintf(line.data(), line.size(),
                      "%s seq=%llu tick=%llu qpc=%lld thread=%lu event=%s request=%llu generation=%llu device=%llx view=%llx resource=%llx clone=%llx fallback=%llx destroyed=%u is_clone=%u format=%u offset=%llx range=%llx stack=",
                      label, evidence.sequence, evidence.tick, evidence.counter, evidence.thread, evidence.event,
                      evidence.request, evidence.generation, evidence.device, evidence.view, evidence.resource,
                      evidence.clone, evidence.fallback, static_cast<unsigned>(evidence.destroyed),
                      static_cast<unsigned>(evidence.is_clone), evidence.format, evidence.offset, evidence.range);
  for (USHORT index = 0; index < evidence.frames && used > 0 && used < static_cast<int>(line.size()) - 32; ++index) {
    used += snprintf(line.data() + used, line.size() - used, "%p,", evidence.stack[index]);
  }
  if (used > 0 && used < static_cast<int>(line.size()) - 1) {
    line[used++] = '\n';
    line[used] = '\0';
  }
  WriteText(line.data());
}

// The caller must hold trace.mutex. Save code bytes only for the limited error
// reports, not each descriptor update. ReadProcessMemory safely skips unreadable code.
static void WriteCallerCode(const Evidence& evidence) {
  for (USHORT index = 0; index < evidence.frames; ++index) {
    MEMORY_BASIC_INFORMATION region = {};
    if (VirtualQuery(evidence.stack[index], &region, sizeof(region)) == 0
        || region.AllocationBase != GetModuleHandleW(nullptr)) continue;
    const auto address = reinterpret_cast<std::uintptr_t>(evidence.stack[index]) - 96;
    std::array<unsigned char, 256> bytes = {};
    SIZE_T copied = 0;
    const BOOL readable = ReadProcessMemory(GetCurrentProcess(), std::bit_cast<const void*>(address),
                                            bytes.data(), bytes.size(), &copied);
    if (readable == FALSE || copied == 0) continue;
    std::array<char, 640> line = {};
    int used = snprintf(line.data(), line.size(), "caller_code address=%llx size=%llu bytes=",
                        static_cast<unsigned long long>(address), static_cast<unsigned long long>(copied));
    for (SIZE_T byte = 0; byte < copied; ++byte) {
      used += snprintf(line.data() + used, line.size() - used, "%02x", bytes[byte]);
    }
    line[used++] = '\n';
    line[used] = '\0';
    WriteText(line.data());
  }
}

static void WriteSyncHistory() {
  const auto first = (trace.sync_sequence >= SYNC_HISTORY_SIZE ? trace.sync_sequence - SYNC_HISTORY_SIZE + 1 : 1);
  for (auto sequence = first; sequence <= trace.sync_sequence; ++sequence) {
    const auto& sync = trace.sync_history[sequence % SYNC_HISTORY_SIZE];
    if (sync.sequence != sequence) continue;
    std::array<char, 384> line = {};
    snprintf(line.data(), line.size(),
             "sync seq=%llu qpc=%lld thread=%lu event=%s device=%llx object=%llx request=%llu result=%d count=%u fences=%llx,%llx,%llx,%llx\n",
             sync.sequence, sync.counter, sync.thread, sync.event, sync.device, sync.object, sync.request,
             sync.result, sync.count, sync.fences[0], sync.fences[1], sync.fences[2], sync.fences[3]);
    WriteText(line.data());
  }
}

static void WriteDescriptorBatch(const DescriptorBatch& batch) {
  std::array<char, 384> line = {};
  snprintf(line.data(), line.size(),
           "descriptor_batch request=%llu qpc=%lld device=%llx writes_address=%llx writes=%u copies=%u references=%u captured=%u phase=%u\n",
           batch.request, batch.counter, batch.device, batch.writes_address, batch.writes, batch.copies,
           batch.references, batch.captured, batch.phase);
  WriteText(line.data());
  for (std::uint32_t index = 0; index < batch.captured; ++index) {
    const auto& reference = batch.inputs[index];
    snprintf(line.data(), line.size(),
             "descriptor_input index=%u view=%llx set=%llx address=%llx binding=%u element=%u type=%u\n",
             index, reference.view, reference.descriptor_set, reference.input_address,
             reference.binding, reference.element, reference.type);
    WriteText(line.data());
    if (trace.views == nullptr || reference.view == 0) continue;
    const auto hash = ((reference.view >> 4) ^ (reference.view >> 21) ^ (batch.device >> 5)) % VIEW_SLOTS;
    for (std::size_t probe = 0; probe < 16; ++probe) {
      const auto& entry = (*trace.views)[(hash + probe) % VIEW_SLOTS];
      if (entry.view != reference.view || entry.device != batch.device) continue;
      WriteEvidence("batch_creation", entry.creation);
      WriteEvidence("batch_description", entry.description);
      WriteEvidence("batch_reference_before_destroy", entry.reference_before_destroy);
      WriteEvidence("batch_reference_return_before_destroy", entry.reference_return_before_destroy);
      WriteEvidence("batch_destroy", entry.first_destroy);
      WriteEvidence("batch_destroy_return", entry.first_return);
      WriteEvidence("batch_last_reference", entry.last_reference);
      WriteEvidence("batch_last_reference_return", entry.last_reference_return);
      break;
    }
  }
}

static void RecordSync(const char* event, std::uint64_t device, std::uint64_t object,
                       std::uint64_t request, std::int32_t result = 0,
                       std::uint32_t count = 0, const std::uint64_t* fences = nullptr) {
  LARGE_INTEGER counter = {};
  QueryPerformanceCounter(&counter);
  SyncEvidence evidence = {
      .counter = counter.QuadPart,
      .device = device,
      .object = object,
      .request = request,
      .result = result,
      .count = count,
      .thread = GetCurrentThreadId(),
  };
  strncpy_s(evidence.event, event, _TRUNCATE);
  if (fences != nullptr) {
    for (std::size_t index = 0; index < evidence.fences.size() && index < count; ++index) {
      evidence.fences[index] = fences[index];
    }
  }
  const std::unique_lock lock(trace.mutex);
  evidence.sequence = ++trace.sync_sequence;
  trace.sync_history[evidence.sequence % SYNC_HISTORY_SIZE] = evidence;
}

static std::uint64_t Record(const char* event, std::uint64_t device, std::uint64_t view,
                            std::uint64_t resource = 0, std::uint64_t clone = 0,
                            std::uint64_t fallback = 0, bool destroyed = false, bool is_clone = false,
                            std::uint32_t format = 0, std::uint64_t buffer_offset = 0,
                            std::uint64_t buffer_range = 0) {
  if (view == 0) {
    if (strcmp(event, "buffer_create_enter") == 0) {
      const std::unique_lock lock(trace.mutex);
      ++trace.create_enters;
    }
    return 0;
  }
  LARGE_INTEGER counter = {};
  QueryPerformanceCounter(&counter);
  Evidence evidence = {
      .tick = GetTickCount64(),
      .counter = counter.QuadPart,
      .device = device,
      .view = view,
      .resource = resource,
      .clone = clone,
      .fallback = fallback,
      .offset = buffer_offset,
      .range = buffer_range,
      .request = native_call.request,
      .thread = GetCurrentThreadId(),
      .format = format,
      .destroyed = destroyed,
      .is_clone = is_clone,
  };
  strncpy_s(evidence.event, event, _TRUNCATE);
  const bool descriptor_reference = strcmp(event, "descriptor_reference") == 0;
  const bool descriptor_return = strcmp(event, "descriptor_return") == 0;
  if (!descriptor_reference && !descriptor_return) {
    evidence.frames = CaptureStackBackTrace(1, static_cast<DWORD>(evidence.stack.size()), evidence.stack.data(), nullptr);
  }
  const std::unique_lock lock(trace.mutex);
  if (trace.views == nullptr) return 0;
  evidence.sequence = ++trace.sequence;
  ViewEvidence* entry = nullptr;
  ViewEvidence* replacement = nullptr;
  const auto hash = ((view >> 4) ^ (view >> 21) ^ (device >> 5)) % VIEW_SLOTS;
  // Check at most 16 slots instead of allocating more memory. Never replace an
  // entry while its destroy call is running, or confuse another slot's key with ours.
  for (std::size_t probe = 0; probe < 16; ++probe) {
    auto& candidate = (*trace.views)[(hash + probe) % VIEW_SLOTS];
    if (candidate.view == view && candidate.device == device) {
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
      ++trace.evictions;
    }
    *replacement = {.device = device, .view = view};
    entry = replacement;
  }
  if (entry == nullptr) {
    ++trace.untracked;
    return 0;
  }
  Problem problem = Problem::NONE;
  if (strcmp(event, "create_event") == 0) {
    // Without Vulkan privateData, different views can have the same handle.
    // If another creation appears before destruction finishes, we cannot tell
    // which view a later request belongs to. Do not block requests for that history.
    entry->ambiguous_creation = entry->creation.sequence != 0 && (!entry->lifetime.native_completed || entry->lifetime.active_destroys != 0);
    problem = entry->lifetime.Apply(Event::CREATE, native_call.request);
    if (problem == Problem::NONE) {
      entry->description = {};
      entry->first_destroy = {};
      entry->first_return = {};
      entry->first_event = {};
      entry->last_reference = {};
      entry->last_reference_return = {};
      entry->reference_before_destroy = {};
      entry->reference_return_before_destroy = {};
      entry->descriptor_reported = false;
    }
  } else if (strcmp(event, "buffer_destroy_enter") == 0 || strcmp(event, "vulkan_destroy_enter") == 0) {
    if (entry->first_destroy.sequence == 0) {
      entry->reference_before_destroy = entry->last_reference;
      entry->reference_return_before_destroy = entry->last_reference_return;
    }
    problem = entry->lifetime.Apply(Event::DESTROY_ENTER, native_call.request);
    if (strcmp(event, "buffer_destroy_enter") == 0) {
      ++trace.destroy_enters;
    }
  } else if (strcmp(event, "buffer_destroy_return") == 0 || strcmp(event, "vulkan_destroy_return") == 0) {
    problem = entry->lifetime.Apply(Event::DESTROY_RETURN, native_call.request, native_call.generation);
    if (strcmp(event, "buffer_destroy_return") == 0) {
      ++trace.destroy_returns;
      if (trace.destroy_returns == 1) {
        WriteText("coverage: native buffer destruction returned\n");
      }
    }
  } else if (strcmp(event, "destroy_event") == 0 || strcmp(event, "destroy_event_unknown") == 0) {
    problem = entry->lifetime.Apply(Event::DESTROY_EVENT, native_call.request);
  } else if (strcmp(event, "buffer_create_return") == 0) {
    ++trace.create_returns;
    evidence.generation = entry->lifetime.generation;
    if (native_call.request != 0 && native_call.generation != entry->lifetime.generation) {
      problem = Problem::RETURN_FROM_OLDER_LIFETIME;
    } else {
      entry->description = evidence;
    }
    if (trace.create_returns == 1) {
      WriteText("coverage: native buffer creation returned\n");
    }
  } else if (descriptor_reference) {
    if (entry->lifetime.active_destroys != 0) {
      problem = Problem::REFERENCE_DURING_DESTROY;
    } else if (entry->lifetime.native_completed || entry->lifetime.event_seen) {
      problem = Problem::REFERENCE_AFTER_DESTROY;
    }
  }
  evidence.generation = entry->lifetime.generation;
  // Save the old creation and first destroy before changing their records. Do
  // this before the suspicious call, while we can still write a reliable report.
  const auto problem_bit = (1u << static_cast<unsigned>(problem));
  const bool report_new_problem = (descriptor_reference ? !entry->descriptor_reported : (trace.reported_problems & problem_bit) == 0);
  if (problem != Problem::NONE && trace.reports < REPORT_LIMIT && report_new_problem) {
    if (descriptor_reference) {
      entry->descriptor_reported = true;
      evidence.frames = CaptureStackBackTrace(1, static_cast<DWORD>(evidence.stack.size()), evidence.stack.data(), nullptr);
    }
    trace.reported_problems |= problem_bit;
    ++trace.reports;
    std::array<char, 512> heading = {};
    snprintf(heading.data(), heading.size(),
             "\nANOMALY report=%u problem=%u evictions=%llu untracked=%llu buffer_create_enter=%llu buffer_create_return=%llu buffer_destroy_enter=%llu buffer_destroy_return=%llu active_destroys=%u native_completed=%u\n",
             trace.reports, static_cast<unsigned>(problem), trace.evictions, trace.untracked,
             trace.create_enters, trace.create_returns, trace.destroy_enters, trace.destroy_returns,
             entry->lifetime.active_destroys, static_cast<unsigned>(entry->lifetime.native_completed));
    WriteText(heading.data());
    WriteEvidence("creation", entry->creation);
    WriteEvidence("description", entry->description);
    WriteEvidence("first_native_destroy", entry->first_destroy);
    WriteEvidence("first_native_return", entry->first_return);
    WriteEvidence("first_event", entry->first_event);
    WriteEvidence("reference_before_destroy", entry->reference_before_destroy);
    WriteEvidence("reference_return_before_destroy", entry->reference_return_before_destroy);
    WriteEvidence("previous_reference", entry->last_reference);
    WriteEvidence("trigger", evidence);
    if (active_descriptor_batch != nullptr) {
      WriteDescriptorBatch(*active_descriptor_batch);
    }
    WriteSyncHistory();
    WriteCallerCode(entry->creation);
    WriteCallerCode(entry->first_destroy);
    WriteCallerCode(evidence);
    const auto first = (trace.sequence > HISTORY_SIZE ? trace.sequence - HISTORY_SIZE : 1);
    for (auto sequence = first; sequence < trace.sequence; ++sequence) {
      const auto& previous = trace.history[sequence % HISTORY_SIZE];
      if (previous.sequence == sequence) {
        WriteEvidence("recent", previous);
      }
    }
    if (trace.file != INVALID_HANDLE_VALUE && !trace.failed && FlushFileBuffers(trace.file) == FALSE) {
      trace.failed = true;
      renodx::utils::log::e("rdr2vk: could not flush the view-lifetime report to disk; error=", GetLastError());
    }
  }
  if (strcmp(event, "create_event") == 0) {
    entry->creation = evidence;
  } else if (descriptor_reference) {
    entry->last_reference = evidence;
  } else if (descriptor_return && entry->last_reference.request == evidence.request) {
    entry->last_reference_return = evidence;
  } else if ((strcmp(event, "buffer_destroy_enter") == 0 || strcmp(event, "vulkan_destroy_enter") == 0)
             && entry->first_destroy.sequence == 0) {
    entry->first_destroy = evidence;
  } else if ((strcmp(event, "destroy_event") == 0 || strcmp(event, "destroy_event_unknown") == 0)
             && entry->first_event.sequence == 0) {
    entry->first_event = evidence;
  } else if ((strcmp(event, "buffer_destroy_return") == 0 || strcmp(event, "vulkan_destroy_return") == 0)
             && entry->first_return.sequence == 0 && problem != Problem::RETURN_FROM_OLDER_LIFETIME) {
    entry->first_return = evidence;
  }
  entry->last_sequence = evidence.sequence;
  trace.history[evidence.sequence % HISTORY_SIZE] = evidence;
  return evidence.generation;
}

static NativeCall BeginDestroy(const char* event, std::uint64_t device, std::uint64_t view) {
  const auto outer = native_call;
  native_call = {.request = ++next_request};
  native_call.generation = Record(event, device, view);
  return outer;
}

static bool SuppressCompletedBufferDestroy(std::uint64_t device, std::uint64_t view) {
  if (view == 0) return false;
  Evidence blocked = {.tick = GetTickCount64(), .device = device, .view = view, .thread = GetCurrentThreadId()};
  strncpy_s(blocked.event, "buffer_destroy_blocked", _TRUNCATE);
  const std::unique_lock lock(trace.mutex);
  if (trace.views == nullptr) return false;
  const auto hash = ((view >> 4) ^ (view >> 21) ^ (device >> 5)) % VIEW_SLOTS;
  for (std::size_t probe = 0; probe < 16; ++probe) {
    auto& entry = (*trace.views)[(hash + probe) % VIEW_SLOTS];
    if (entry.device != device || entry.view != view) continue;
    if (!HasCompletedBufferLifetime(entry)) return false;
    ++trace.blocked_duplicates;
    // Save the first blocked call before returning to the game. Later blocks
    // update only a counter: no repeated file writes or ReShade log messages.
    if (trace.blocked_duplicates == 1) {
      blocked.sequence = ++trace.sequence;
      blocked.generation = entry.lifetime.generation;
      blocked.frames = CaptureStackBackTrace(1, static_cast<DWORD>(blocked.stack.size()), blocked.stack.data(), nullptr);
      WriteText("\nMITIGATION: blocked a second buffer-view destroy request because the saved history proves the first call already finished for this lifetime.\n");
      WriteEvidence("creation", entry.creation);
      WriteEvidence("description", entry.description);
      WriteEvidence("first_native_destroy", entry.first_destroy);
      WriteEvidence("first_event", entry.first_event);
      WriteEvidence("first_native_return", entry.first_return);
      WriteEvidence("blocked", blocked);
      if (trace.file != INVALID_HANDLE_VALUE && !trace.failed && FlushFileBuffers(trace.file) == FALSE) {
        trace.failed = true;
        renodx::utils::log::e("rdr2vk: could not flush the blocked-destroy report to disk; error=", GetLastError());
      }
    }
    return true;
  }
  return false;
}

static void EndDestroy(const char* event, std::uint64_t device, std::uint64_t view, NativeCall outer) {
  Record(event, device, view);
  native_call = outer;
}

static LONG CALLBACK OnException(EXCEPTION_POINTERS* exception) {
  if (exception_observer_active) return EXCEPTION_CONTINUE_SEARCH;
  auto* batch = active_descriptor_batch;
  if (exception == nullptr || exception->ExceptionRecord == nullptr || exception->ContextRecord == nullptr
      || exception->ExceptionRecord->ExceptionCode != EXCEPTION_ACCESS_VIOLATION) return EXCEPTION_CONTINUE_SEARCH;
  const auto& registers = *exception->ContextRecord;
  const bool driver_fault = registers.Rip >= trace.driver_begin && registers.Rip < trace.driver_end;
  if ((batch == nullptr && !driver_fault) || (batch != nullptr && batch->fault_reported)) return EXCEPTION_CONTINUE_SEARCH;
  // Do not wait for another thread, look up symbols, allocate memory, or handle
  // the exception. Another handler may recover; check the dump before calling it fatal.
  const std::unique_lock lock(trace.mutex, std::try_to_lock);
  if (!lock.owns_lock() || trace.fault_reports >= 4) return EXCEPTION_CONTINUE_SEARCH;
  exception_observer_active = true;
  if (batch != nullptr) {
    batch->fault_reported = true;
  }
  ++trace.fault_reports;
  std::array<char, 512> line = {};
  LARGE_INTEGER counter = {};
  QueryPerformanceCounter(&counter);
  snprintf(line.data(), line.size(),
           "\nDESCRIPTOR_FIRST_CHANCE_AV report=%u qpc=%lld thread=%lu hooked_batch=%u address=%p rip=%llx rax=%llx rbx=%llx rcx=%llx rdx=%llx rsp=%llx access=%llu target=%llx\n",
           trace.fault_reports, counter.QuadPart, GetCurrentThreadId(), static_cast<unsigned>(batch != nullptr), exception->ExceptionRecord->ExceptionAddress,
           registers.Rip, registers.Rax, registers.Rbx, registers.Rcx, registers.Rdx, registers.Rsp,
           static_cast<unsigned long long>(exception->ExceptionRecord->ExceptionInformation[0]),
           static_cast<unsigned long long>(exception->ExceptionRecord->ExceptionInformation[1]));
  WriteText(line.data());
  if (batch != nullptr) {
    WriteDescriptorBatch(*batch);
  }
  // Some captured crashes had no active descriptor hook. Search the CPU values
  // directly, without asking the driver about freed views or assuming how that
  // driver version stores its private objects.
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
  std::array<std::array<std::uint64_t, 16>, 16> nearby = {};
  std::array<SIZE_T, 16> copied = {};
  for (std::size_t index = 0; index < addresses.size(); ++index) {
    if (addresses[index] == 0) continue;
    ReadProcessMemory(GetCurrentProcess(), std::bit_cast<const void*>(addresses[index]),
                      nearby[index].data(), sizeof(nearby[index]), &copied[index]);
  }
  if (trace.views != nullptr) {
    std::uint32_t found_views = 0;
    for (const auto& entry : *trace.views) {
      if (entry.view == 0 || found_views == 16) continue;
      const auto describe_match = [&](std::uint64_t address) {
        snprintf(line.data(), line.size(), "fault_view_candidate device=%llx view=%llx input_address=%llx generation=%llu completed=%u\n",
                 entry.device, entry.view, address, entry.lifetime.generation,
                 static_cast<unsigned>(entry.lifetime.native_completed));
        WriteText(line.data());
        WriteEvidence("fault_creation", entry.creation);
        WriteEvidence("fault_description", entry.description);
        WriteEvidence("fault_reference_before_destroy", entry.reference_before_destroy);
        WriteEvidence("fault_reference_return_before_destroy", entry.reference_return_before_destroy);
        WriteEvidence("fault_destroy", entry.first_destroy);
        WriteEvidence("fault_destroy_return", entry.first_return);
        WriteEvidence("fault_last_reference", entry.last_reference);
        WriteEvidence("fault_last_reference_return", entry.last_reference_return);
        WriteCallerCode(entry.creation);
        WriteCallerCode(entry.first_destroy);
        ++found_views;
      };
      bool found = false;
      for (std::size_t index = 0; index < addresses.size() && !found; ++index) {
        if (addresses[index] == entry.view) {
          describe_match(0);
          found = true;
          break;
        }
        for (std::size_t word = 0; word < copied[index] / sizeof(std::uint64_t); ++word) {
          if (nearby[index][word] != entry.view) continue;
          describe_match(addresses[index] + (word * sizeof(std::uint64_t)));
          found = true;
          break;
        }
      }
    }
  }
  WriteSyncHistory();
  Evidence caller = {.sequence = trace.sequence, .thread = GetCurrentThreadId()};
  caller.frames = CaptureStackBackTrace(0, static_cast<DWORD>(caller.stack.size()), caller.stack.data(), nullptr);
  WriteEvidence("exception_stack", caller);
  WriteCallerCode(caller);
  if (trace.file != INVALID_HANDLE_VALUE && !trace.failed) {
    FlushFileBuffers(trace.file);
  }
  exception_observer_active = false;
  return EXCEPTION_CONTINUE_SEARCH;
}

}  // namespace rdr2vk::view_lifetime_trace

#endif  // RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS