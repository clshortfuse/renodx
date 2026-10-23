#pragma once

#include <algorithm>
#include <cstring>
#include <span>
#include <string>
#include <string_view>
#include <vector>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

namespace renodx::utils::settings {

inline bool SegmentedButtons(
    const char* label,
    int* selected_index,
    std::span<const std::string> options,
    bool multiline = false) {
  IM_ASSERT(selected_index != nullptr);
  IM_ASSERT(!options.empty());
  if (selected_index == nullptr || options.empty()) return false;

  const ImGuiStyle& style = ImGui::GetStyle();
  const float width = ImGui::CalcItemWidth();
  const int option_count = static_cast<int>(options.size());
  const float segment_width = width / option_count;
  const float font_size = ImGui::GetFontSize();
  const float text_line_height = ImGui::GetTextLineHeight();
  ImFont* font = ImGui::GetFont();
  std::vector<std::vector<std::string_view>> option_lines;
  option_lines.reserve(options.size());
  size_t maximum_line_count = 1u;
  for (int index = 0; index < option_count; ++index) {
    const float current_width = index + 1 == option_count
                                    ? width - (segment_width * index)
                                    : segment_width;
    auto& lines = option_lines.emplace_back();
    const std::string& option = options[index];
    const char* text = option.data();
    const char* text_end = text + option.size();
    if (!multiline) {
      lines.emplace_back(text, option.size());
      continue;
    }

    const float text_wrap_width = std::max(
        current_width - (style.FramePadding.x * 2.f),
        1.f);
    while (text < text_end) {
      while (text < text_end && (*text == ' ' || *text == '\t')) ++text;
      if (text == text_end) break;

      const char* line_end = text;
      const char* cursor = text;
      while (cursor < text_end && *cursor != '\n' && *cursor != '\r') {
        const char* word_end = cursor;
        while (word_end < text_end
               && *word_end != ' '
               && *word_end != '\t'
               && *word_end != '\n'
               && *word_end != '\r') {
          ++word_end;
        }
        if (line_end != text
            && ImGui::CalcTextSize(text, word_end).x > text_wrap_width) {
          break;
        }
        line_end = word_end;
        cursor = word_end;
        while (cursor < text_end && (*cursor == ' ' || *cursor == '\t')) {
          ++cursor;
        }
      }
      if (line_end == text) line_end = cursor;
      lines.emplace_back(text, static_cast<size_t>(line_end - text));
      text = cursor;
      while (text < text_end
             && (*text == ' '
                 || *text == '\t'
                 || *text == '\n'
                 || *text == '\r')) {
        ++text;
      }
    }
    if (lines.empty()) lines.emplace_back();
    maximum_line_count = std::max(maximum_line_count, lines.size());
  }
  const float height = multiline
                           ? std::max(
                                 ImGui::GetFrameHeight(),
                                 (text_line_height * maximum_line_count)
                                     + (style.FramePadding.y * 2.f))
                           : ImGui::GetFrameHeight();
  ImDrawList* draw_list = ImGui::GetWindowDrawList();
  bool changed = false;

  ImGui::BeginGroup();
  ImGui::PushID(label);
  const bool pressed = ImGui::InvisibleButton(
      "##Segments",
      ImVec2(width, height),
      ImGuiButtonFlags_EnableNav);
  const ImVec2 frame_min = ImGui::GetItemRectMin();
  const ImVec2 frame_max = ImGui::GetItemRectMax();
  const bool group_hovered = ImGui::IsItemHovered();
  const bool group_active = ImGui::IsItemActive();
  const bool group_focused = ImGui::IsItemFocused();
  const int hovered_index = group_hovered
                                ? std::clamp(
                                      static_cast<int>(
                                          ((ImGui::GetMousePos().x - frame_min.x) / width)
                                          * option_count),
                                      0,
                                      option_count - 1)
                                : -1;

  if (pressed
      && hovered_index >= 0
      && *selected_index != hovered_index) {
    *selected_index = hovered_index;
    changed = true;
  }
  if (group_focused
      && *selected_index > 0
      && (ImGui::IsKeyPressed(ImGuiKey_LeftArrow)
          || ImGui::IsKeyPressed(ImGuiKey_GamepadDpadLeft))) {
    --*selected_index;
    changed = true;
  } else if (group_focused
             && *selected_index + 1 < option_count
             && (ImGui::IsKeyPressed(ImGuiKey_RightArrow)
                 || ImGui::IsKeyPressed(ImGuiKey_GamepadDpadRight))) {
    ++*selected_index;
    changed = true;
  }

  for (int index = 0; index < option_count; ++index) {
    const float current_width = index + 1 == option_count
                                    ? width - (segment_width * index)
                                    : segment_width;
    const ImVec2 segment_min(
        frame_min.x + (segment_width * index),
        frame_min.y);
    const ImVec2 segment_max(
        segment_min.x + current_width,
        frame_max.y);
    const bool segment_hovered = hovered_index == index;

    const bool segment_selected = *selected_index == index;
    ImGuiCol color;
    if (segment_selected) {
      if (group_active) {
        color = ImGuiCol_SliderGrabActive;
      } else {
        color = ImGuiCol_SliderGrab;
      }
    } else {
      if (group_active && segment_hovered) {
        color = ImGuiCol_FrameBgActive;
      } else if (segment_hovered) {
        color = ImGuiCol_FrameBgHovered;
      } else {
        color = ImGuiCol_FrameBg;
      }
    }

    ImDrawFlags corners = ImDrawFlags_RoundCornersNone;
    if (option_count == 1) {
      corners = ImDrawFlags_RoundCornersAll;
    } else if (index == 0) {
      corners = ImDrawFlags_RoundCornersLeft;
    } else if (index + 1 == option_count) {
      corners = ImDrawFlags_RoundCornersRight;
    }

    draw_list->AddRectFilled(
        segment_min,
        segment_max,
        ImGui::GetColorU32(color),
        style.FrameRounding,
        corners);

    const ImVec4 clip_rect(
        segment_min.x + style.FramePadding.x,
        segment_min.y,
        segment_max.x - style.FramePadding.x,
        segment_max.y);
    const auto& lines = option_lines[index];
    const float text_y = segment_min.y
                         + ((height - (text_line_height * lines.size())) * 0.5f);
    for (size_t line_index = 0; line_index < lines.size(); ++line_index) {
      const std::string_view line = lines[line_index];
      const ImVec2 line_size = ImGui::CalcTextSize(
          line.data(),
          line.data() + line.size());
      draw_list->AddText(
          font,
          font_size,
          ImVec2(
              segment_min.x + ((current_width - line_size.x) * 0.5f),
              text_y + (text_line_height * line_index)),
          ImGui::GetColorU32(ImGuiCol_Text),
          line.data(),
          line.data() + line.size(),
          0.f,
          &clip_rect);
    }
  }
  ImGui::PopID();

  const ImU32 border_color = ImGui::GetColorU32(ImGuiCol_Border);
  const float border_size = std::max(style.FrameBorderSize, 1.f);
  for (int index = 1; index < option_count; ++index) {
    const float x = frame_min.x + (segment_width * index);
    draw_list->AddLine(
        ImVec2(x, frame_min.y),
        ImVec2(x, frame_max.y),
        border_color,
        border_size);
  }
  draw_list->AddRect(
      frame_min,
      frame_max,
      border_color,
      style.FrameRounding,
      ImDrawFlags_RoundCornersAll,
      border_size);
  if (group_focused) {
    draw_list->AddRect(
        ImVec2(frame_min.x + 1.f, frame_min.y + 1.f),
        ImVec2(frame_max.x - 1.f, frame_max.y - 1.f),
        ImGui::GetColorU32(ImGuiCol_NavCursor),
        style.FrameRounding,
        ImDrawFlags_RoundCornersAll,
        1.f);
  }

  const ImVec2 label_size = ImGui::CalcTextSize(label, nullptr, true);
  if (label_size.x > 0.f) {
    ImGui::SameLine(0.f, style.ItemInnerSpacing.x);
    ImGui::AlignTextToFramePadding();
    ImGui::TextUnformatted(label, std::strstr(label, "##"));
  }
  ImGui::EndGroup();

  return changed;
}

}  // namespace renodx::utils::settings