vec4 FinalizeUI(vec4 color) {
  return vec4(max(color.rgb, vec3(0.f)), clamp(color.a, 0.f, 1.f));
}
