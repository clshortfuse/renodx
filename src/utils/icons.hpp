#pragma once

#include "../../external/reshade/res/fonts/forkawesome.h"

namespace renodx::utils::icons {

inline const char* View(const char* icon) {
  return icon;
}

#if defined(__cpp_char8_t)
inline const char* View(const char8_t* icon) {
  return reinterpret_cast<const char*>(icon);
}
#endif

inline constexpr auto CANCEL = ICON_FK_CANCEL;
inline constexpr auto CANCEL_CIRCLE = ICON_FK_CANCEL_CIRCLE;
inline constexpr auto FILE = ICON_FK_FILE;
inline constexpr auto FILE_CODE = ICON_FK_FILE_CODE;
inline constexpr auto FILE_IMAGE = ICON_FK_FILE_IMAGE;
inline constexpr auto FLOPPY = ICON_FK_FLOPPY;
inline constexpr auto FOLDER = ICON_FK_FOLDER;
inline constexpr auto FOLDER_OPEN = ICON_FK_FOLDER_OPEN;
inline constexpr auto ANGLE_DOWN = ICON_FK_ANGLE_DOWN;
inline constexpr auto ANGLE_LEFT = ICON_FK_ANGLE_LEFT;
inline constexpr auto ANGLE_RIGHT = ICON_FK_ANGLE_RIGHT;
inline constexpr auto ANGLE_UP = ICON_FK_ANGLE_UP;
inline constexpr auto BARS = ICON_FK_BARS;
inline constexpr auto BOOKMARK = ICON_FK_BOOKMARK;
inline constexpr auto CARET_DOWN = ICON_FK_CARET_DOWN;
inline constexpr auto CARET_LEFT = ICON_FK_CARET_LEFT;
inline constexpr auto CARET_RIGHT = ICON_FK_CARET_RIGHT;
inline constexpr auto CARET_UP = ICON_FK_CARET_UP;
inline constexpr auto CHEVRON_DOWN = ICON_FK_CHEVRON_DOWN;
inline constexpr auto CHEVRON_LEFT = ICON_FK_CHEVRON_LEFT;
inline constexpr auto CHEVRON_RIGHT = ICON_FK_CHEVRON_RIGHT;
inline constexpr auto CHEVRON_UP = ICON_FK_CHEVRON_UP;
inline constexpr auto CLOCK = ICON_FK_CLOCK;
inline constexpr auto CLONE = ICON_FK_CLONE;
inline constexpr auto CODE = ICON_FK_CODE;
inline constexpr auto CODE_FORK = ICON_FK_CODE_FORK;
inline constexpr auto COG = ICON_FK_COG;
inline constexpr auto COGS = ICON_FK_COGS;
inline constexpr auto COPY = ICON_FK_COPY;
inline constexpr auto DESKTOP = ICON_FK_DESKTOP;
inline constexpr auto DOWNLOAD = ICON_FK_DOWNLOAD;
inline constexpr auto EXTERNAL_LINK = ICON_FK_EXTERNAL_LINK;
inline constexpr auto EYE = ICON_FK_EYE;
inline constexpr auto EYE_SLASH = ICON_FK_EYE_SLASH;
inline constexpr auto FILTER = ICON_FK_FILTER;
inline constexpr auto GAMEPAD = ICON_FK_GAMEPAD;
inline constexpr auto HEART = ICON_FK_HEART;
inline constexpr auto HEART_EMPTY = ICON_FK_HEART_EMPTY;
inline constexpr auto HISTORY = ICON_FK_HISTORY;
inline constexpr auto HOME = ICON_FK_HOME;
inline constexpr auto INFO_CIRCLE = ICON_FK_INFO_CIRCLE;
inline constexpr auto LINK = ICON_FK_LINK;
inline constexpr auto LIST = ICON_FK_LIST;
inline constexpr auto LIST_ALT = ICON_FK_LIST_ALT;
inline constexpr auto LIST_OL = ICON_FK_LIST_OL;
inline constexpr auto LIST_UL = ICON_FK_LIST_UL;
inline constexpr auto LOCK = ICON_FK_LOCK;
inline constexpr auto MINUS = ICON_FK_MINUS;
inline constexpr auto MINUS_CIRCLE = ICON_FK_MINUS_CIRCLE;
inline constexpr auto OK = ICON_FK_OK;
inline constexpr auto OK_CIRCLE = ICON_FK_OK_CIRCLE;
inline constexpr auto PAUSE = ICON_FK_PAUSE;
inline constexpr auto PAUSE_CIRCLE = ICON_FK_PAUSE_CIRCLE;
inline constexpr auto PENCIL = ICON_FK_PENCIL;
inline constexpr auto PENCIL_SQUARE = ICON_FK_PENCIL_SQUARE;
inline constexpr auto PICTURE = ICON_FK_PICTURE;
inline constexpr auto PLAY = ICON_FK_PLAY;
inline constexpr auto PLAY_CIRCLE = ICON_FK_PLAY_CIRCLE;
inline constexpr auto PLUS = ICON_FK_PLUS;
inline constexpr auto PLUS_CIRCLE = ICON_FK_PLUS_CIRCLE;
inline constexpr auto QUESTION_CIRCLE = ICON_FK_QUESTION_CIRCLE;
inline constexpr auto REFRESH = ICON_FK_REFRESH;
inline constexpr auto SEARCH = ICON_FK_SEARCH;
inline constexpr auto SEARCH_MINUS = ICON_FK_SEARCH_MINUS;
inline constexpr auto SEARCH_PLUS = ICON_FK_SEARCH_PLUS;
inline constexpr auto STAR = ICON_FK_STAR;
inline constexpr auto STAR_EMPTY = ICON_FK_STAR_EMPTY;
inline constexpr auto STAR_HALF = ICON_FK_STAR_HALF;
inline constexpr auto STOP = ICON_FK_STOP;
inline constexpr auto STOP_CIRCLE = ICON_FK_STOP_CIRCLE;
inline constexpr auto TAG = ICON_FK_TAG;
inline constexpr auto TAGS = ICON_FK_TAGS;
inline constexpr auto TRASH_ALT = ICON_FK_TRASH_ALT;
inline constexpr auto UNDO = ICON_FK_UNDO;
inline constexpr auto UNLOCK = ICON_FK_UNLOCK;
inline constexpr auto UPLOAD = ICON_FK_UPLOAD;
inline constexpr auto WARNING = ICON_FK_WARNING;

}  // namespace renodx::utils::icons
