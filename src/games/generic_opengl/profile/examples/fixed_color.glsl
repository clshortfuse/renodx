#version 120
// Only for a verified untextured, unfogged fixed-function color pass.
// Fixed-function vertex processing supplies gl_Color.
void main() {
  gl_FragColor = gl_Color;
}
