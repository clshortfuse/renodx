/*
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <algorithm>
#include <cstdint>
#include <iterator>
#include <unordered_map>
#include <utility>
#include <vector>

namespace renodx::utils::dlss::vulkan {

// Tracks feature generations referenced by executable command-buffer
// recordings separately from references owned by successful submissions.
// Reusable recordings remain owners until begin/reset/free/pool destruction;
// one-time recordings are released after their last submission completes.
class FeatureLifetimeTracker final {
 public:
  using Handle = std::uint64_t;
  using Generation = std::uint64_t;

  struct SubmittedCommand {
    Handle command_buffer = 0u;
    std::uint64_t recording_epoch = 0u;
    bool one_time_submit = false;
    std::vector<Generation> generations;

    bool operator==(const SubmittedCommand&) const = default;
  };

  struct CompletedRecording {
    Handle command_buffer = 0u;
    std::uint64_t recording_epoch = 0u;

    bool operator==(const CompletedRecording&) const = default;
  };

  struct SubmissionSnapshot {
    std::vector<SubmittedCommand> commands;

    [[nodiscard]] bool Empty() const noexcept { return commands.empty(); }
  };

  void BeginCommandBuffer(Handle command_buffer, bool one_time_submit) {
    if (command_buffer == 0u) return;
    DiscardCommandBuffer(command_buffer);
    command_recordings_[command_buffer] = {
        .epoch = NextEpoch(),
        .one_time_submit = one_time_submit,
    };
  }

  void EnsureCommandBuffer(Handle command_buffer, bool one_time_submit) {
    if (command_buffer == 0u || command_recordings_.contains(command_buffer)) {
      return;
    }
    command_recordings_[command_buffer] = {
        .epoch = NextEpoch(),
        .one_time_submit = one_time_submit,
    };
  }

  std::uint64_t RecordFeatureUse(
      Handle command_buffer,
      Generation generation,
      bool one_time_submit = false) {
    if (command_buffer == 0u || generation == 0u) return 0u;
    auto [recording, inserted] = command_recordings_.try_emplace(command_buffer);
    if (inserted) {
      recording->second.epoch = NextEpoch();
      recording->second.one_time_submit = one_time_submit;
    }
    auto& generations = recording->second.generations;
    if (std::find(generations.begin(), generations.end(), generation)
        != generations.end()) {
      return recording->second.epoch;
    }
    generations.push_back(generation);
    ++reference_counts_[generation].recorded;
    return recording->second.epoch;
  }

  [[nodiscard]] SubmissionSnapshot CaptureSubmission(
      const std::vector<Handle>& command_buffers) const {
    SubmissionSnapshot snapshot;
    snapshot.commands.reserve(command_buffers.size());
    for (const Handle command_buffer : command_buffers) {
      const auto found = command_recordings_.find(command_buffer);
      if (found == command_recordings_.end()
          || found->second.generations.empty()) {
        continue;
      }
      snapshot.commands.push_back({
          .command_buffer = command_buffer,
          .recording_epoch = found->second.epoch,
          .one_time_submit = found->second.one_time_submit,
          .generations = found->second.generations,
      });
    }
    return snapshot;
  }

  SubmissionSnapshot CommitSuccessfulSubmit(
      Handle queue, const SubmissionSnapshot& snapshot) {
    SubmissionSnapshot committed;
    if (queue == 0u || snapshot.Empty()) return committed;
    committed.commands.reserve(snapshot.commands.size());
    auto& submissions = queue_submissions_[queue];
    for (const auto& command : snapshot.commands) {
      const auto current = command_recordings_.find(command.command_buffer);
      if (current == command_recordings_.end()
          || current->second.epoch != command.recording_epoch) {
        continue;
      }
      submissions.push_back(command);
      committed.commands.push_back(command);
      ++current->second.in_flight_submissions;
      for (const Generation generation : command.generations) {
        ++reference_counts_[generation].in_flight;
      }
    }
    if (submissions.empty()) queue_submissions_.erase(queue);
    return committed;
  }

  [[nodiscard]] static bool SubmissionContains(
      const SubmissionSnapshot& snapshot,
      Handle command_buffer,
      Generation generation) noexcept {
    for (const auto& command : snapshot.commands) {
      if (command.command_buffer == command_buffer
          && std::find(
                 command.generations.begin(),
                 command.generations.end(),
                 generation)
                 != command.generations.end()) {
        return true;
      }
    }
    return false;
  }

  [[nodiscard]] std::vector<CompletedRecording> CompleteSubmission(
      Handle queue, const SubmissionSnapshot& snapshot) {
    std::vector<SubmittedCommand> completed;
    if (queue == 0u || snapshot.Empty()) return {};
    const auto found = queue_submissions_.find(queue);
    if (found == queue_submissions_.end()) return {};

    auto& queued = found->second;
    completed.reserve(snapshot.commands.size());
    for (const auto& command : snapshot.commands) {
      const auto submitted = std::find(queued.begin(), queued.end(), command);
      if (submitted == queued.end()) continue;
      completed.push_back(std::move(*submitted));
      queued.erase(submitted);
    }
    if (queued.empty()) queue_submissions_.erase(found);
    return CompleteSubmissions(completed);
  }

  [[nodiscard]] std::vector<CompletedRecording> CompleteQueue(Handle queue) {
    const auto found = queue_submissions_.find(queue);
    if (found == queue_submissions_.end()) return {};
    auto submissions = std::move(found->second);
    queue_submissions_.erase(found);
    return CompleteSubmissions(submissions);
  }

  [[nodiscard]] std::vector<CompletedRecording> CompleteDevice() {
    std::vector<SubmittedCommand> submissions;
    for (auto& [queue, queued] : queue_submissions_) {
      submissions.insert(
          submissions.end(),
          std::make_move_iterator(queued.begin()),
          std::make_move_iterator(queued.end()));
    }
    queue_submissions_.clear();
    return CompleteSubmissions(submissions);
  }

  void DiscardCommandBuffer(Handle command_buffer) {
    if (command_buffer == 0u) return;

    // Successful begin/reset/free proves this command buffer is not pending.
    for (auto queue = queue_submissions_.begin();
         queue != queue_submissions_.end();) {
      auto& submissions = queue->second;
      for (auto submission = submissions.begin();
           submission != submissions.end();) {
        if (submission->command_buffer != command_buffer) {
          ++submission;
          continue;
        }
        DecrementInFlight(*submission);
        submission = submissions.erase(submission);
      }
      if (submissions.empty()) {
        queue = queue_submissions_.erase(queue);
      } else {
        ++queue;
      }
    }

    const auto recording = command_recordings_.find(command_buffer);
    if (recording == command_recordings_.end()) return;
    DecrementRecorded(recording->second.generations);
    command_recordings_.erase(recording);
  }

  void DiscardCommandBuffers(const std::vector<Handle>& command_buffers) {
    for (const Handle command_buffer : command_buffers) {
      DiscardCommandBuffer(command_buffer);
    }
  }

  void DiscardAllCommandBuffers() {
    command_recordings_.clear();
    queue_submissions_.clear();
    reference_counts_.clear();
  }

  [[nodiscard]] bool IsReferenced(Generation generation) const noexcept {
    const auto found = reference_counts_.find(generation);
    return found != reference_counts_.end()
           && (found->second.recorded != 0u || found->second.in_flight != 0u);
  }

  [[nodiscard]] std::uint64_t RecordedReferenceCount(
      Generation generation) const noexcept {
    const auto found = reference_counts_.find(generation);
    return found == reference_counts_.end() ? 0u : found->second.recorded;
  }

  [[nodiscard]] std::uint64_t InFlightReferenceCount(
      Generation generation) const noexcept {
    const auto found = reference_counts_.find(generation);
    return found == reference_counts_.end() ? 0u : found->second.in_flight;
  }

 private:
  struct ReferenceCounts {
    std::uint64_t recorded = 0u;
    std::uint64_t in_flight = 0u;
  };

  struct CommandRecording {
    std::uint64_t epoch = 0u;
    std::uint64_t in_flight_submissions = 0u;
    bool one_time_submit = false;
    std::vector<Generation> generations;
  };

  [[nodiscard]] std::uint64_t NextEpoch() noexcept {
    const std::uint64_t epoch = next_recording_epoch_++;
    if (next_recording_epoch_ == 0u) next_recording_epoch_ = 1u;
    return epoch;
  }

  [[nodiscard]] std::vector<CompletedRecording> CompleteSubmissions(
      const std::vector<SubmittedCommand>& submissions) {
    std::vector<std::pair<Handle, std::uint64_t>> completed_one_time_recordings;
    completed_one_time_recordings.reserve(submissions.size());
    for (const auto& submission : submissions) {
      DecrementInFlight(submission);
      const auto recording = command_recordings_.find(submission.command_buffer);
      if (recording == command_recordings_.end()
          || recording->second.epoch != submission.recording_epoch) {
        continue;
      }
      if (recording->second.in_flight_submissions != 0u) {
        --recording->second.in_flight_submissions;
      }
      if (submission.one_time_submit
          && recording->second.in_flight_submissions == 0u) {
        completed_one_time_recordings.emplace_back(
            submission.command_buffer, submission.recording_epoch);
      }
    }

    std::vector<CompletedRecording> completed_one_time_command_buffers;
    completed_one_time_command_buffers.reserve(
        completed_one_time_recordings.size());
    for (const auto& [command_buffer, epoch] : completed_one_time_recordings) {
      const auto recording = command_recordings_.find(command_buffer);
      if (recording == command_recordings_.end()
          || recording->second.epoch != epoch
          || recording->second.in_flight_submissions != 0u) {
        continue;
      }
      DecrementRecorded(recording->second.generations);
      command_recordings_.erase(recording);
      completed_one_time_command_buffers.push_back({
          .command_buffer = command_buffer,
          .recording_epoch = epoch,
      });
    }
    return completed_one_time_command_buffers;
  }

  void DecrementInFlight(const SubmittedCommand& submission) {
    for (const Generation generation : submission.generations) {
      const auto counts = reference_counts_.find(generation);
      if (counts == reference_counts_.end()) continue;
      if (counts->second.in_flight != 0u) --counts->second.in_flight;
      RemoveEmptyReferenceCounts(counts);
    }
  }

  void DecrementRecorded(const std::vector<Generation>& generations) {
    for (const Generation generation : generations) {
      const auto counts = reference_counts_.find(generation);
      if (counts == reference_counts_.end()) continue;
      if (counts->second.recorded != 0u) --counts->second.recorded;
      RemoveEmptyReferenceCounts(counts);
    }
  }

  void RemoveEmptyReferenceCounts(
      std::unordered_map<Generation, ReferenceCounts>::iterator counts) {
    if (counts->second.recorded == 0u && counts->second.in_flight == 0u) {
      reference_counts_.erase(counts);
    }
  }

  std::uint64_t next_recording_epoch_ = 1u;
  std::unordered_map<Handle, CommandRecording> command_recordings_;
  std::unordered_map<Handle, std::vector<SubmittedCommand>> queue_submissions_;
  std::unordered_map<Generation, ReferenceCounts> reference_counts_;
};

}  // namespace renodx::utils::dlss::vulkan
