/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <charconv>
#include <regex>
#include <string_view>
#include <vector>

inline std::string_view StringViewFromCsubMatch(const std::csub_match& match) {
  return std::string_view{match.first, match.second};
}

inline std::vector<std::string_view> StringViewMatchAll(const std::string_view& input, const std::regex& regex) {
  std::cmatch matches;
  std::regex_match(input.data(), input.data() + input.size(), matches, regex);
  if (matches.empty()) return {};
  std::vector<std::string_view> results(matches.size() - 1);

  for (size_t i = 1; i < matches.size(); ++i) {
    results[i - 1] = StringViewFromCsubMatch(matches[i]);
  }
  return results;
}

template <size_t N = 0>
inline std::array<std::string_view, N> StringViewMatch(const std::string_view& input, const std::regex& regex) {
  std::array<std::string_view, N> results;

  std::cmatch matches;
  std::regex_match(input.data(), input.data() + input.size(), matches, regex);
  if (matches.empty()) return {};
  for (size_t i = 1; i < matches.size(); ++i) {
    results[i - 1] = StringViewFromCsubMatch(matches[i]);
  }
  return results;
}

inline std::string_view StringViewMatch(const std::string_view& input, const std::regex& regex) {
  std::cmatch matches;
  std::regex_match(input.data(), input.data() + input.size(), matches, regex);
  if (matches.empty()) return {};
  for (size_t i = 1; i < matches.size(); ++i) {
    return StringViewFromCsubMatch(matches[i]);
  }
  return "";
}

inline std::string_view StringViewMatch(const std::string_view& input, const std::string& regex) {
  return StringViewMatch(input, std::regex{regex});
}

inline std::vector<std::pair<std::string_view, std::string_view>> StringViewSplitAll(const std::string_view& input, const std::regex& separator, const std::vector<int>& submatches) {
  std::cregex_token_iterator iter(input.data(), input.data() + input.size(), separator, submatches);
  const std::cregex_token_iterator end;
  std::vector<std::pair<std::string_view, std::string_view>> results = {};
  while (iter != end) {
    auto first = StringViewFromCsubMatch(*iter++);
    auto second = StringViewFromCsubMatch(*iter++);
    results.emplace_back(first, second);
  }

  return results;
}

template <size_t N1, size_t N2>
std::array<std::array<std::string_view, N2>, N1> StringViewSplit(const std::string_view& input, const std::regex& separator, const std::array<int, N2>& submatches) {
  std::vector<int> submatchesv = {submatches.data(), submatches.data() + N2};
  std::cregex_token_iterator iter(input.data(), input.data() + input.size(), separator, submatchesv);
  const std::cregex_token_iterator end;
  std::array<std::array<std::string_view, N2>, N1> results;
  size_t count = 0;
  while (iter != end) {
    std::array<std::string_view, N2> record;
    for (size_t i = 0; i < N2; ++i) {
      record[i] = StringViewFromCsubMatch(*iter++);
    }
    results[count++] = record;
  }

  return results;
}

template <size_t N>
std::array<std::string_view, N> StringViewSplit(const std::string_view& input, const std::regex& separator, uint32_t submatch = -1) {
  std::cregex_token_iterator iter(input.data(), input.data() + input.size(), separator, submatch);
  const std::cregex_token_iterator end;
  std::array<std::string_view, N> results;
  size_t count = 0;
  while (iter != end) {
    results[count++] = StringViewFromCsubMatch(*iter++);
  }

  return results;
}

inline std::vector<std::string_view> StringViewSplitAll(const std::string_view& input, const std::regex& separator, uint32_t submatch = -1) {
  std::cregex_token_iterator iter(input.data(), input.data() + input.size(), separator, submatch);
  const std::cregex_token_iterator end;
  std::vector<std::string_view> results = {};
  while (iter != end) {
    results.push_back(StringViewFromCsubMatch(*iter));
    ++iter;
  }
  return results;
}

inline std::vector<std::string_view> StringViewSplitAll(const std::string_view& input, const char separator) {
  std::vector<std::string_view> results;

  std::string_view::size_type pos = 0;
  std::string_view::size_type prev = 0;
  while ((pos = input.find(separator, prev)) != std::string_view::npos) {
    results.emplace_back(input.data() + prev, input.data() + pos);
    prev = pos + 1;
  }
  results.emplace_back(input.data() + prev, input.data() + input.size());

  return results;
}

inline std::string_view StringViewTrimStart(const std::string_view& input) {
  auto pos = input.find_first_not_of("\t\n\v\f\r ");
  if (pos == std::string_view::npos) return {};
  return std::string_view{input.data() + pos, input.data() + input.size()};
}

inline std::string_view StringViewTrimEnd(const std::string_view& input) {
  auto pos = input.find_last_not_of("\t\n\v\f\r ");
  if (pos == std::string_view::npos) return {};
  return std::string_view{input.data(), input.data() + pos + 1};
}

inline std::string_view StringViewTrim(std::string_view input) {
  return StringViewTrimStart(StringViewTrimEnd(input));
}

template <typename T>
inline void FromStringView(std::string_view s, T& value) {
  std::from_chars(s.data(), s.data() + s.size(), value);
}
