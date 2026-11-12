#version 120
// Only for a verified single texture-unit GL_MODULATE pass, without fog.
// The sampler defaults to texture unit zero. This does not emulate arbitrary
// texture combiners, multiple units, lighting changes, or engine-specific fog.
uniform sampler2D scene_texture;
void main() {
  gl_FragColor = gl_Color * texture2D(scene_texture, gl_TexCoord[0].xy);
}
