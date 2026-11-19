#pragma once

namespace mw3_frame_deadline {
// Inputs and output share the caller's clock units. Late frames are released
// immediately; a new pacing phase starts there rather than one period later.
inline double Advance(double previous, double now, double period, bool reset) {
  if (reset || period <= 0.0) return now;
  const double next = previous + period;
  if (now >= next || next - now > period) return now;
  return next;
}
}
