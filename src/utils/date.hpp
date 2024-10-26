/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

constexpr unsigned int compileYear = (__DATE__[7] - '0') * 1000 + (__DATE__[8] - '0') * 100 + (__DATE__[9] - '0') * 10 + (__DATE__[10] - '0');
constexpr unsigned int compileMonth = (__DATE__[0] == 'J')   ? ((__DATE__[1] == 'a') ? 1 : ((__DATE__[2] == 'n') ? 6 : 7))  // Jan, Jun or Jul
                                      : (__DATE__[0] == 'F') ? 2                                                            // Feb
                                      : (__DATE__[0] == 'M') ? ((__DATE__[2] == 'r') ? 3 : 5)                               // Mar or May
                                      : (__DATE__[0] == 'A') ? ((__DATE__[2] == 'p') ? 4 : 8)                               // Apr or Aug
                                      : (__DATE__[0] == 'S') ? 9                                                            // Sep
                                      : (__DATE__[0] == 'O') ? 10                                                           // Oct
                                      : (__DATE__[0] == 'N') ? 11                                                           // Nov
                                      : (__DATE__[0] == 'D') ? 12                                                           // Dec
                                                             : 0;
constexpr unsigned int compileDay = (__DATE__[4] == ' ') ? (__DATE__[5] - '0') : (__DATE__[4] - '0') * 10 + (__DATE__[5] - '0');

constexpr char IsoDate[] =
    {compileYear / 1000 + '0', (compileYear % 1000) / 100 + '0', (compileYear % 100) / 10 + '0', compileYear % 10 + '0',
     '-', compileMonth / 10 + '0', compileMonth % 10 + '0',
     '-', compileDay / 10 + '0', compileDay % 10 + '0',
     0};