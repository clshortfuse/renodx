/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

namespace renodx::utils::date {

constexpr unsigned int COMPILE_YEAR = ((__DATE__[7] - '0') * 1000)
                                      + ((__DATE__[8] - '0') * 100)
                                      + ((__DATE__[9] - '0') * 10)
                                      + (__DATE__[10] - '0');
constexpr unsigned int COMPILE_MONTH = (__DATE__[0] == 'J')   ? ((__DATE__[1] == 'a') ? 1 : ((__DATE__[2] == 'n') ? 6 : 7))  // Jan, Jun or Jul
                                       : (__DATE__[0] == 'F') ? 2                                                            // Feb
                                       : (__DATE__[0] == 'M') ? ((__DATE__[2] == 'r') ? 3 : 5)                               // Mar or May
                                       : (__DATE__[0] == 'A') ? ((__DATE__[2] == 'p') ? 4 : 8)                               // Apr or Aug
                                       : (__DATE__[0] == 'S') ? 9                                                            // Sep
                                       : (__DATE__[0] == 'O') ? 10                                                           // Oct
                                       : (__DATE__[0] == 'N') ? 11                                                           // Nov
                                       : (__DATE__[0] == 'D') ? 12                                                           // Dec
                                                              : 0;
constexpr unsigned int COMPILE_DAY = (__DATE__[4] == ' ')
                                         ? (__DATE__[5] - '0')
                                         : ((__DATE__[4] - '0') * 10) + (__DATE__[5] - '0');
// IsoDate returns "YYYY-MM-DD" format
constexpr char ISO_DATE[] = {(COMPILE_YEAR / 1000) + '0', ((COMPILE_YEAR % 1000) / 100) + '0', ((COMPILE_YEAR % 100) / 10) + '0', (COMPILE_YEAR % 10) + '0',
                             '-', (COMPILE_MONTH / 10) + '0', (COMPILE_MONTH % 10) + '0',
                             '-', (COMPILE_DAY / 10) + '0', (COMPILE_DAY % 10) + '0',
                             0};

}  // namespace renodx::utils::date