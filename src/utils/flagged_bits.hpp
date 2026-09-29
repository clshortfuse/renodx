#pragma once

/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#include <array>
#include <bit>
#include <cassert>
#include <cstddef>
#include <iterator>
#include <limits>
#include <type_traits>
#include <utility>

// NOLINTBEGIN(readability-identifier-naming)
namespace renodx::utils {

template <std::size_t Count, typename Word = std::size_t>
class FlaggedBits {
  static_assert(std::is_unsigned_v<Word> && !std::is_same_v<Word, bool>);

 public:
  static constexpr std::size_t WORD_BITS = std::numeric_limits<Word>::digits;
  static constexpr std::size_t LEVEL_COUNT = [] {
    std::size_t levels = 1;
    for (std::size_t bits = Count; bits > WORD_BITS; ++levels) {
      bits = (bits / WORD_BITS) + (bits % WORD_BITS != 0u ? 1u : 0u);
    }
    return levels;
  }();
  static constexpr auto LEVEL_OFFSETS = [] {
    std::array<std::size_t, LEVEL_COUNT + 1u> offsets{};
    std::size_t bits = Count;
    for (std::size_t level = 0; level < LEVEL_COUNT; ++level) {
      bits = (bits / WORD_BITS) + (bits % WORD_BITS != 0u ? 1u : 0u);
      offsets[level + 1u] = offsets[level] + bits;
    }
    return offsets;
  }();

  void set(std::size_t index) {
    assert(index < Count);
    for (std::size_t level = 0; level < LEVEL_COUNT; ++level) {
      const auto word = index / WORD_BITS;
      const auto previous = words_[LEVEL_OFFSETS[level] + word];
      words_[LEVEL_OFFSETS[level] + word] |= Word{1} << (index % WORD_BITS);
      if (previous != 0u) return;
      index = word;
    }
  }
  void setRange(std::size_t first, std::size_t length) {
    assert(first <= Count && length <= Count - first);
    while (length != 0u) {
      const auto offset = first % WORD_BITS;
      const auto take = length < WORD_BITS - offset ? length : WORD_BITS - offset;
      set(first);  // Establish summaries before marking the rest of this word.
      words_[first / WORD_BITS] |= static_cast<Word>((std::numeric_limits<Word>::max() >> (WORD_BITS - take)) << offset);
      first += take;
      length -= take;
    }
  }
  template <typename Callback>
  void forEachRange(Callback&& callback) const {
    std::size_t first = 0;
    std::size_t end = 0;
    while (end < Count) {
      const auto next = FindNext(0u, end);
      if (next == Count) break;
      first = next;
      end = next;
      do {
        const auto offset = end % WORD_BITS;
        const auto run = static_cast<std::size_t>(std::countr_one(static_cast<Word>(words_[end / WORD_BITS] >> offset)));
        end += run;
        if (run != WORD_BITS - offset) break;
      } while (end < Count);
      callback(first, end - first);
    }
  }
  void reset(std::size_t index) {
    assert(index < Count);
    for (std::size_t level = 0; level < LEVEL_COUNT; ++level) {
      const auto word = index / WORD_BITS;
      words_[LEVEL_OFFSETS[level] + word] &= static_cast<Word>(~(Word{1} << (index % WORD_BITS)));
      if (words_[LEVEL_OFFSETS[level] + word] != 0u) return;
      index = word;
    }
  }
  void reset() {
    if constexpr (Count != 0u) {
      ClearWord(LEVEL_COUNT - 1u, 0u);
    }
  }
  void reset(std::size_t first, std::size_t length) {
    assert(first <= Count && length <= Count - first);
    while (length != 0u) {
      const auto offset = first % WORD_BITS;
      const auto take = length < WORD_BITS - offset ? length : WORD_BITS - offset;
      auto& word = words_[first / WORD_BITS];
      const auto previous = word;
      word &= static_cast<Word>(~((std::numeric_limits<Word>::max() >> (WORD_BITS - take)) << offset));
      if (previous != 0u && word == 0u) {
        reset(first);
      }
      first += take;
      length -= take;
    }
  }
  bool test(std::size_t index) const {
    return index < Count && (words_[index / WORD_BITS] & (Word{1} << (index % WORD_BITS))) != 0u;
  }
  bool operator[](std::size_t index) const { return test(index); }
  bool none() const {
    if constexpr (Count == 0u) {
      return true;
    } else {
      return words_.back() == 0u;
    }
  }
  std::size_t count() const {
    std::size_t result = 0;
    for (std::size_t word = 0; word < LEVEL_OFFSETS[1]; ++word) result += std::popcount(words_[word]);
    return result;
  }
  bool all() const { return count() == Count; }

  class Iterator {
   public:
    using value_type = std::size_t;
    using difference_type = std::ptrdiff_t;
    using iterator_concept = std::input_iterator_tag;
    Iterator() = default;
    explicit Iterator(const FlaggedBits* owner) : owner_(owner) { LoadWord(0); }
    std::size_t operator*() const { return (word_ * WORD_BITS) + std::countr_zero(remaining_); }
    Iterator& operator++() {
      remaining_ &= remaining_ - 1u;
      if (remaining_ == 0u) {
        LoadWord(word_ + 1u);
      }
      return *this;
    }
    void operator++(int) { ++*this; }
    bool operator==([[maybe_unused]] std::default_sentinel_t sentinel) const { return remaining_ == 0u; }

   private:
    void LoadWord(std::size_t first) {
      if constexpr (LEVEL_COUNT == 1u) {
        word_ = first;
      } else {
        word_ = owner_->FindNext(1u, first);
      }
      remaining_ = word_ < LEVEL_OFFSETS[1] ? owner_->words_[word_] : Word{0};
    }
    const FlaggedBits* owner_ = nullptr;
    std::size_t word_ = 0;
    Word remaining_ = 0;
  };

  struct IndexRange {
    const FlaggedBits* owner;
    Iterator begin() const { return Iterator{owner}; }
    std::default_sentinel_t end() const { return {}; }
  };
  // Borrowed range: changing presence invalidates iterators; no capacity-sized copy.
  IndexRange indexes() const& { return {.owner = this}; }
  IndexRange indexes() const&& = delete;

 private:
  // Snapshot each parent before clearing children; no live iterator is mutated.
  void ClearWord(std::size_t level, std::size_t word) {
    Word remaining = words_[LEVEL_OFFSETS[level] + word];
    words_[LEVEL_OFFSETS[level] + word] = 0u;
    if (level == 0u) return;
    while (remaining != 0u) {
      ClearWord(level - 1u, (word * WORD_BITS) + std::countr_zero(remaining));
      remaining &= remaining - 1u;
    }
  }
  std::size_t FindNext(std::size_t level, std::size_t first) const {
    auto word = first / WORD_BITS;
    const auto word_count = LEVEL_OFFSETS[level + 1u] - LEVEL_OFFSETS[level];
    if (word >= word_count) return Count;
    Word remaining = words_[LEVEL_OFFSETS[level] + word]
                     & static_cast<Word>(std::numeric_limits<Word>::max() << (first % WORD_BITS));
    if (remaining == 0u) {
      if (level + 1u == LEVEL_COUNT) return Count;
      word = FindNext(level + 1u, word + 1u);
      if (word >= word_count) return Count;
      remaining = words_[LEVEL_OFFSETS[level] + word];
    }
    return (word * WORD_BITS) + std::countr_zero(remaining);
  }
  std::array<Word, LEVEL_OFFSETS.back()> words_{};
};

namespace flagged_array {

// Shared projection for dense and sparse containers; all values are borrowed.
template <typename Container, bool Entries>
class Range {
  using IndexIterator = decltype(std::declval<const Container&>().indexes().begin());

 public:
  explicit Range(Container* owner) : owner_(owner) {}
  class Iterator {
   public:
    Iterator(Container* owner, IndexIterator index) : owner_(owner), index_(index) {}
    decltype(auto) operator*() const {
      if constexpr (Entries) {
        return std::pair<std::size_t, decltype(owner_->get(*index_))>{*index_, owner_->get(*index_)};
      } else {
        return owner_->get(*index_);
      }
    }
    Iterator& operator++() {
      ++index_;
      return *this;
    }
    bool operator==(std::default_sentinel_t sentinel) const { return index_ == sentinel; }

   private:
    Container* owner_;
    IndexIterator index_;
  };
  Iterator begin() const { return Iterator{owner_, owner_->indexes().begin()}; }
  std::default_sentinel_t end() const { return {}; }

 private:
  Container* owner_;
};

}  // namespace flagged_array
}  // namespace renodx::utils
// NOLINTEND(readability-identifier-naming)