/*
 * SPDX-License-Identifier: MIT
 */

#include <cstdint>
#include <iostream>
#include <vector>

#include "../../src/games/detroitbecomehuman/dlss/feature_lifetime.hpp"

namespace dlss = renodx::games::detroitbecomehuman::dlss;

namespace {

bool Expect(bool condition, const char* message) {
  if (!condition) std::cerr << "FAIL: " << message << '\n';
  return condition;
}

bool TestRecordedReferenceSurvivesSubmitAndIdle() {
  dlss::FeatureLifetimeTracker tracker;
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
  dlss::FeatureLifetimeTracker tracker;
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
  dlss::FeatureLifetimeTracker tracker;
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
  dlss::FeatureLifetimeTracker tracker;
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
      completed == std::vector<dlss::FeatureLifetimeTracker::Handle>{13u},
      "queue completion must identify the one-time command buffer for scratch recycling");
  return passed;
}

bool TestOneTimeRecordingCompletesAtFence() {
  dlss::FeatureLifetimeTracker tracker;
  tracker.BeginCommandBuffer(27u, true);
  tracker.RecordFeatureUse(27u, 12u);
  const auto captured = tracker.CaptureSubmission({27u});
  const auto committed = tracker.CommitSuccessfulSubmit(28u, captured);

  const auto completed = tracker.CompleteSubmission(28u, committed);
  bool passed = true;
  passed &= Expect(
      completed == std::vector<dlss::FeatureLifetimeTracker::Handle>{27u},
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
  dlss::FeatureLifetimeTracker tracker;
  constexpr std::uint64_t queue = 29u;
  constexpr std::uint64_t generation = 13u;
  bool passed = true;

  // The opt-in compatibility path can still attach a private fence to each
  // no-fence submit. Completed recordings must remain bounded by actual GPU
  // concurrency, not the lifetime count of command-buffer handles.
  for (std::uint64_t command_buffer = 100u; command_buffer < 132u;
       ++command_buffer) {
    tracker.BeginCommandBuffer(command_buffer, true);
    tracker.RecordFeatureUse(command_buffer, generation);
    const auto captured = tracker.CaptureSubmission({command_buffer});
    const auto committed = tracker.CommitSuccessfulSubmit(queue, captured);
    const auto completed = tracker.CompleteSubmission(queue, committed);
    passed &= Expect(
        completed
            == std::vector<dlss::FeatureLifetimeTracker::Handle>{command_buffer},
        "each signaled private fence must release its one-time command buffer");
    passed &= Expect(
        tracker.RecordedReferenceCount(generation) == 0u
            && tracker.InFlightReferenceCount(generation) == 0u,
        "completed fence-tracked churn must not accumulate feature references");
  }
  return passed;
}

bool TestFencelessFrameRotationRemainsBounded() {
  dlss::FeatureLifetimeTracker tracker;
  constexpr std::uint64_t queue = 30u;
  constexpr std::uint64_t generation = 14u;
  constexpr std::uint64_t frame_slots = 3u;
  bool passed = true;

  // The default path does not inject a VkFence. A successful begin/reset of a
  // reused frame command buffer is itself the Vulkan proof that its prior
  // submission is no longer pending, so conservative references and private
  // scratch ownership must stay bounded by the frame rotation.
  for (std::uint64_t frame = 0u; frame < 96u; ++frame) {
    const std::uint64_t command_buffer = 200u + frame % frame_slots;
    tracker.BeginCommandBuffer(command_buffer, true);
    tracker.RecordFeatureUse(command_buffer, generation);
    const auto captured = tracker.CaptureSubmission({command_buffer});
    (void)tracker.CommitSuccessfulSubmit(queue, captured);
    passed &= Expect(
        tracker.RecordedReferenceCount(generation) <= frame_slots
            && tracker.InFlightReferenceCount(generation) <= frame_slots,
        "fenceless frame rotation must remain bounded by reused command buffers");
  }

  tracker.DiscardCommandBuffers({200u, 201u, 202u});
  passed &= Expect(
      !tracker.IsReferenced(generation),
      "reset/free of every fenceless frame slot must release all references");
  return passed;
}

bool TestSimultaneousOneTimeSubmissionsWaitForEveryQueue() {
  dlss::FeatureLifetimeTracker tracker;
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
      last_completed == std::vector<dlss::FeatureLifetimeTracker::Handle>{14u},
      "the final submission completion must expose the one-time command buffer");
  return passed;
}

bool TestResetProvesConservativeSubmissionComplete() {
  dlss::FeatureLifetimeTracker tracker;
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
  dlss::FeatureLifetimeTracker tracker;
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

bool TestCreationGateRejectsOtherRecordingBeforeSubmit() {
  dlss::FeatureCreationGate gate = {
      .command_buffer = 17u,
  };

  bool passed = true;
  passed &= Expect(
      gate.AllowsUseFrom(17u),
      "feature creation command buffer may evaluate the new feature in order");
  passed &= Expect(
      !gate.AllowsUseFrom(18u),
      "another command buffer must wait for successful feature creation submit");
  passed &= Expect(
      gate.InvalidatedByDiscard(17u),
      "discarding an unsubmitted creation recording must invalidate the feature");
  passed &= Expect(
      !gate.InvalidatedByDiscard(18u),
      "discarding an unrelated recording must not invalidate the feature");
  return passed;
}

bool TestCreationGateOpensOnlyForCommittedCreationSubmission() {
  dlss::FeatureLifetimeTracker tracker;
  tracker.BeginCommandBuffer(19u, false);
  tracker.RecordFeatureUse(19u, 9u);
  const auto captured = tracker.CaptureSubmission({19u});
  const auto committed = tracker.CommitSuccessfulSubmit(25u, captured);

  dlss::FeatureCreationGate gate = {
      .command_buffer = 19u,
  };
  if (dlss::FeatureLifetimeTracker::SubmissionContains(
          committed, gate.command_buffer, 9u)) {
    gate.MarkSubmitted();
  }

  bool passed = true;
  passed &= Expect(
      gate.AllowsUseFrom(20u),
      "successful creation submission must open the feature to later recordings");
  passed &= Expect(
      !gate.InvalidatedByDiscard(19u),
      "discarding the old creation recording must preserve a submitted feature");
  passed &= Expect(
      !dlss::FeatureLifetimeTracker::SubmissionContains(
          committed, 20u, 9u),
      "submission matching must include the exact creation command buffer");
  passed &= Expect(
      !dlss::FeatureLifetimeTracker::SubmissionContains(
          committed, 19u, 10u),
      "submission matching must include the exact feature generation");
  return passed;
}

bool TestStaleCreationSnapshotDoesNotOpenGate() {
  dlss::FeatureLifetimeTracker tracker;
  tracker.BeginCommandBuffer(21u, false);
  tracker.RecordFeatureUse(21u, 11u);
  const auto stale = tracker.CaptureSubmission({21u});
  tracker.BeginCommandBuffer(21u, false);
  tracker.RecordFeatureUse(21u, 11u);
  const auto committed = tracker.CommitSuccessfulSubmit(26u, stale);

  dlss::FeatureCreationGate gate = {
      .command_buffer = 21u,
  };
  if (dlss::FeatureLifetimeTracker::SubmissionContains(
          committed, gate.command_buffer, 11u)) {
    gate.MarkSubmitted();
  }

  bool passed = true;
  passed &= Expect(
      committed.Empty(),
      "a stale recording epoch must not be accepted as a successful submission");
  passed &= Expect(
      !gate.AllowsUseFrom(22u),
      "a stale creation snapshot must not open the feature to another recording");
  return passed;
}

}  // namespace

int main() {
  bool passed = true;
  passed &= TestRecordedReferenceSurvivesSubmitAndIdle();
  passed &= TestUnsubmittedRecordingBlocksRelease();
  passed &= TestFailedSubmitDoesNotAddInFlightReference();
  passed &= TestOneTimeRecordingCompletesAtIdle();
  passed &= TestOneTimeRecordingCompletesAtFence();
  passed &= TestFenceTrackedOneTimeChurnDoesNotAccumulate();
  passed &= TestFencelessFrameRotationRemainsBounded();
  passed &= TestSimultaneousOneTimeSubmissionsWaitForEveryQueue();
  passed &= TestResetProvesConservativeSubmissionComplete();
  passed &= TestMultipleGenerationsInOneRecording();
  passed &= TestCreationGateRejectsOtherRecordingBeforeSubmit();
  passed &= TestCreationGateOpensOnlyForCommittedCreationSubmission();
  passed &= TestStaleCreationSnapshotDoesNotOpenGate();
  std::cerr << (passed ? "PASS\n" : "FAIL\n");
  return passed ? 0 : 1;
}
