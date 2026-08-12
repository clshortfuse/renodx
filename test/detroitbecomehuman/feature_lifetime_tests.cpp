/*
 * SPDX-License-Identifier: MIT
 */

#include <cstdint>
#include <iostream>
#include <vector>

#include "../../src/games/detroitbecomehuman/dlss/feature_recording_registry.hpp"
#include "../../src/utils/dlss/feature_lifetime.hpp"

namespace dlss = renodx::games::detroitbecomehuman::dlss;
using FeatureLifetimeTracker =
    renodx::utils::dlss::vulkan::FeatureLifetimeTracker;

namespace {

bool Expect(bool condition, const char* message) {
  if (!condition) std::cerr << "FAIL: " << message << '\n';
  return condition;
}

bool TestFeatureRecordingRegistryRejectsBloomFalsePositives() {
  dlss::FeatureRecordingRegistry<2u> registry;

  bool passed = true;
  passed &= Expect(
      registry.Empty() && !registry.Overflowed(),
      "a new exact feature-recording registry must be inactive");
  passed &= Expect(
      !registry.Insert(0u) && registry.Empty(),
      "the null command-buffer handle must never become a candidate");
  passed &= Expect(
      registry.Insert(10u) && registry.Insert(10u)
          && registry.Contains(10u) && !registry.Contains(11u),
      "candidate insertion must be idempotent and exact");
  passed &= Expect(
      registry.Insert(11u) && !registry.Empty()
          && !registry.Overflowed(),
      "the fixed registry must accept every live scratch owner");
  passed &= Expect(
      !registry.Insert(12u) && registry.Overflowed()
          && registry.Contains(11u) && !registry.Contains(12u),
      "overflow must preserve known exact handles while unknown owners fail closed");
  passed &= Expect(
      registry.Erase(10u) && registry.Erase(11u) && registry.Empty()
          && registry.HasLifecycleCandidates(),
      "sticky overflow must retain conservative lifecycle tracking after exact slots empty");
  registry.Clear();
  passed &= Expect(
      registry.Empty() && !registry.Overflowed()
          && !registry.HasLifecycleCandidates(),
      "device teardown must clear candidates and overflow state");
  return passed;
}

bool TestRecordedReferenceSurvivesSubmitAndIdle() {
  FeatureLifetimeTracker tracker;
  tracker.BeginCommandBuffer(10u, false);
  tracker.RecordFeatureUse(10u, 1u);
  const auto submission = tracker.CaptureSubmission({10u});
  tracker.CommitSuccessfulSubmit(20u, submission);

  bool passed = true;
  passed &= Expect(
      tracker.RecordedReferenceCount(1u) == 1u,
      "reusable command buffer must retain its recorded feature reference");
  passed &= Expect(
      tracker.InFlightReferenceCount(1u) == 1u,
      "successful submit must add an in-flight feature reference");
  const auto completed = tracker.CompleteQueue(20u);
  passed &= Expect(
      tracker.RecordedReferenceCount(1u) == 1u
          && tracker.InFlightReferenceCount(1u) == 0u,
      "queue idle must complete work without invalidating a reusable recording");
  passed &= Expect(
      completed.empty(),
      "a reusable recording must not expose its resources for scratch recycling");
  tracker.DiscardCommandBuffer(10u);
  passed &= Expect(
      !tracker.IsReferenced(1u),
      "successful reset/free boundary must release the final recorded reference");
  return passed;
}

bool TestUnsubmittedRecordingBlocksRelease() {
  FeatureLifetimeTracker tracker;
  tracker.BeginCommandBuffer(11u, false);
  tracker.RecordFeatureUse(11u, 2u);
  (void)tracker.CompleteDevice();

  bool passed = true;
  passed &= Expect(
      tracker.IsReferenced(2u),
      "device idle must not erase an unsubmitted executable recording");
  tracker.BeginCommandBuffer(11u, false);
  passed &= Expect(
      !tracker.IsReferenced(2u),
      "a successful new begin must invalidate the old recording");
  return passed;
}

bool TestFailedSubmitDoesNotAddInFlightReference() {
  FeatureLifetimeTracker tracker;
  tracker.BeginCommandBuffer(12u, false);
  tracker.RecordFeatureUse(12u, 3u);
  (void)tracker.CaptureSubmission({12u});

  bool passed = true;
  passed &= Expect(
      tracker.InFlightReferenceCount(3u) == 0u,
      "capturing a failed submit must not create an in-flight reference");
  tracker.DiscardCommandBuffer(12u);
  passed &= Expect(
      !tracker.IsReferenced(3u),
      "failed submit recording may retire after a reset/free boundary");
  return passed;
}

bool TestOneTimeRecordingCompletesAtIdle() {
  FeatureLifetimeTracker tracker;
  tracker.BeginCommandBuffer(13u, true);
  tracker.RecordFeatureUse(13u, 4u);
  const auto submission = tracker.CaptureSubmission({13u});
  tracker.CommitSuccessfulSubmit(21u, submission);
  const auto completed = tracker.CompleteQueue(21u);

  bool passed = true;
  passed &= Expect(
      !tracker.IsReferenced(4u),
      "one-time recording must become invalid after its successful submit completes");
  passed &= Expect(
      completed
          == std::vector<FeatureLifetimeTracker::CompletedRecording>{{
              .command_buffer = 13u,
              .recording_epoch = submission.commands.front().recording_epoch,
          }},
      "queue completion must identify the one-time command buffer for scratch recycling");
  return passed;
}

bool TestOneTimeRecordingCompletesAtFence() {
  FeatureLifetimeTracker tracker;
  tracker.BeginCommandBuffer(27u, true);
  tracker.RecordFeatureUse(27u, 12u);
  const auto captured = tracker.CaptureSubmission({27u});
  const auto committed = tracker.CommitSuccessfulSubmit(28u, captured);

  const auto completed = tracker.CompleteSubmission(28u, committed);
  bool passed = true;
  passed &= Expect(
      completed
          == std::vector<FeatureLifetimeTracker::CompletedRecording>{{
              .command_buffer = 27u,
              .recording_epoch = committed.commands.front().recording_epoch,
          }},
      "a signaled fence must identify its completed one-time command buffer");
  passed &= Expect(
      !tracker.IsReferenced(12u),
      "fence completion must release recorded and in-flight one-time references");
  passed &= Expect(
      tracker.CompleteSubmission(28u, committed).empty(),
      "observing the same fence twice must be idempotent");
  return passed;
}

bool TestFenceTrackedOneTimeChurnDoesNotAccumulate() {
  FeatureLifetimeTracker tracker;
  constexpr std::uint64_t queue = 29u;
  constexpr std::uint64_t generation = 13u;
  bool passed = true;

  // Production attaches a private fence to each one-time no-fence submit.
  // Completed recordings must remain bounded by actual GPU concurrency, not
  // the lifetime count of command-buffer handles.
  for (std::uint64_t command_buffer = 100u; command_buffer < 132u;
       ++command_buffer) {
    tracker.BeginCommandBuffer(command_buffer, true);
    tracker.RecordFeatureUse(command_buffer, generation);
    const auto captured = tracker.CaptureSubmission({command_buffer});
    const auto committed = tracker.CommitSuccessfulSubmit(queue, captured);
    const auto completed = tracker.CompleteSubmission(queue, committed);
    passed &= Expect(
        completed
            == std::vector<FeatureLifetimeTracker::CompletedRecording>{{
                .command_buffer = command_buffer,
                .recording_epoch = committed.commands.front().recording_epoch,
            }},
        "each signaled private fence must release its one-time command buffer");
    passed &= Expect(
        tracker.RecordedReferenceCount(generation) == 0u
            && tracker.InFlightReferenceCount(generation) == 0u,
        "completed fence-tracked churn must not accumulate feature references");
  }
  return passed;
}

bool TestLifecycleFallbackFrameRotationRemainsBounded() {
  FeatureLifetimeTracker tracker;
  constexpr std::uint64_t queue = 30u;
  constexpr std::uint64_t generation = 14u;
  constexpr std::uint64_t frame_slots = 3u;
  bool passed = true;

  // If explicit completion tracking is unavailable, a successful begin/reset
  // of a reused frame command buffer is itself the Vulkan proof that its prior
  // submission is no longer pending. Conservative references and private
  // scratch ownership must still stay bounded by the frame rotation.
  for (std::uint64_t frame = 0u; frame < 96u; ++frame) {
    const std::uint64_t command_buffer = 200u + frame % frame_slots;
    tracker.BeginCommandBuffer(command_buffer, true);
    tracker.RecordFeatureUse(command_buffer, generation);
    const auto captured = tracker.CaptureSubmission({command_buffer});
    (void)tracker.CommitSuccessfulSubmit(queue, captured);
    passed &= Expect(
        tracker.RecordedReferenceCount(generation) <= frame_slots
            && tracker.InFlightReferenceCount(generation) <= frame_slots,
        "lifecycle fallback must remain bounded by reused command buffers");
  }

  tracker.DiscardCommandBuffers({200u, 201u, 202u});
  passed &= Expect(
      !tracker.IsReferenced(generation),
      "reset/free of every lifecycle-fallback slot must release all references");
  return passed;
}

bool TestSimultaneousOneTimeSubmissionsWaitForEveryQueue() {
  FeatureLifetimeTracker tracker;
  tracker.BeginCommandBuffer(14u, true);
  tracker.RecordFeatureUse(14u, 5u);
  const auto submission = tracker.CaptureSubmission({14u});
  tracker.CommitSuccessfulSubmit(22u, submission);
  tracker.CommitSuccessfulSubmit(23u, submission);

  bool passed = true;
  const auto first_completed = tracker.CompleteQueue(22u);
  passed &= Expect(
      tracker.IsReferenced(5u)
          && tracker.InFlightReferenceCount(5u) == 1u,
      "one-time recording must survive while another queue submission is pending");
  passed &= Expect(
      first_completed.empty(),
      "the first of multiple submissions must not recycle shared scratch resources");
  const auto last_completed = tracker.CompleteQueue(23u);
  passed &= Expect(
      !tracker.IsReferenced(5u),
      "last queue completion must invalidate the one-time recording");
  passed &= Expect(
      last_completed
          == std::vector<FeatureLifetimeTracker::CompletedRecording>{{
              .command_buffer = 14u,
              .recording_epoch = submission.commands.front().recording_epoch,
          }},
      "the final submission completion must expose the one-time command buffer");
  return passed;
}

bool TestOneTimeCompletionPreservesRecordingEpochAcrossReuse() {
  FeatureLifetimeTracker tracker;
  constexpr std::uint64_t kCommandBuffer = 31u;
  constexpr std::uint64_t kQueue = 32u;

  tracker.BeginCommandBuffer(kCommandBuffer, true);
  tracker.RecordFeatureUse(kCommandBuffer, 15u);
  const auto first = tracker.CaptureSubmission({kCommandBuffer});
  const auto committed = tracker.CommitSuccessfulSubmit(kQueue, first);
  const auto completed = tracker.CompleteSubmission(kQueue, committed);

  tracker.BeginCommandBuffer(kCommandBuffer, true);
  tracker.RecordFeatureUse(kCommandBuffer, 16u);
  const auto second = tracker.CaptureSubmission({kCommandBuffer});

  bool passed = true;
  passed &= Expect(
      completed.size() == 1u && !first.Empty() && !second.Empty()
          && completed.front().command_buffer == kCommandBuffer
          && completed.front().recording_epoch
                 == first.commands.front().recording_epoch,
      "one-time completion must preserve the exact completed recording epoch");
  passed &= Expect(
      completed.front().recording_epoch
          != second.commands.front().recording_epoch,
      "a reused Vulkan handle must receive a distinct recording epoch");
  return passed;
}

bool TestResetProvesConservativeSubmissionComplete() {
  FeatureLifetimeTracker tracker;
  tracker.BeginCommandBuffer(15u, false);
  tracker.RecordFeatureUse(15u, 6u);
  const auto submission = tracker.CaptureSubmission({15u});
  tracker.CommitSuccessfulSubmit(24u, submission);
  tracker.DiscardCommandBuffer(15u);

  bool passed = true;
  passed &= Expect(
      !tracker.IsReferenced(6u),
      "successful reset/free must clear conservative submitted references");
  (void)tracker.CompleteQueue(24u);
  passed &= Expect(
      !tracker.IsReferenced(6u),
      "a later queue idle must not underflow a discarded submission");
  return passed;
}

bool TestMultipleGenerationsInOneRecording() {
  FeatureLifetimeTracker tracker;
  tracker.BeginCommandBuffer(16u, false);
  tracker.RecordFeatureUse(16u, 7u);
  tracker.RecordFeatureUse(16u, 8u);
  tracker.RecordFeatureUse(16u, 7u);

  bool passed = true;
  passed &= Expect(
      tracker.RecordedReferenceCount(7u) == 1u
          && tracker.RecordedReferenceCount(8u) == 1u,
      "one recording must hold one reference per distinct generation");
  tracker.DiscardAllCommandBuffers();
  passed &= Expect(
      !tracker.IsReferenced(7u) && !tracker.IsReferenced(8u),
      "device destruction must discard every remaining recording");
  return passed;
}

}  // namespace

int main() {
  bool passed = true;
  passed &= TestFeatureRecordingRegistryRejectsBloomFalsePositives();
  passed &= TestRecordedReferenceSurvivesSubmitAndIdle();
  passed &= TestUnsubmittedRecordingBlocksRelease();
  passed &= TestFailedSubmitDoesNotAddInFlightReference();
  passed &= TestOneTimeRecordingCompletesAtIdle();
  passed &= TestOneTimeRecordingCompletesAtFence();
  passed &= TestFenceTrackedOneTimeChurnDoesNotAccumulate();
  passed &= TestLifecycleFallbackFrameRotationRemainsBounded();
  passed &= TestSimultaneousOneTimeSubmissionsWaitForEveryQueue();
  passed &= TestOneTimeCompletionPreservesRecordingEpochAcrossReuse();
  passed &= TestResetProvesConservativeSubmissionComplete();
  passed &= TestMultipleGenerationsInOneRecording();
  std::cerr << (passed ? "PASS\n" : "FAIL\n");
  return passed ? 0 : 1;
}
