#include <stdio.h>
#include <stdlib.h>

FILE* OpenOrExit(const char* fname, const char* mode) {
  FILE* f = fopen(fname, mode);
  if (f == NULL) {
    perror(fname);
    exit(EXIT_FAILURE);
  }
  return f;
}

const char* GetFileNameFromPath(const char* buffer) {
  char c;
  int i;
  for (i = 0;; ++i) {
    c = *((char*)buffer + i);
    if (c == '\\' || c == '/') {
      return GetFileNameFromPath((char*)buffer + i + 1);
    }
    if (c == '\0') {
      return buffer;
    }
  }
  return "";
}

int main(int argc, char** argv) {
  if (argc < 3) {
    fprintf(stderr,
      "USAGE: %s {rsrc} {sym}\n\n"
      "  Creates {sym}.h from the contents of {rsrc}\n",
      argv[0]);
    return EXIT_FAILURE;
  }

  FILE* in = OpenOrExit(argv[1], "rb");
  const char* sym = argv[2];

  char symfile[256];
  snprintf(symfile, sizeof(symfile), "%s.h", sym);
  char* symbasename = GetFileNameFromPath(sym);

  FILE* out = OpenOrExit(symfile, "wt");
  fprintf(out, "#ifndef _%s_EMBED_FILE\n", symbasename);
  fprintf(out, "#define _%s_EMBED_FILE\n", symbasename);
  fprintf(out, "#include <cstdint>\n");
  fprintf(out, "const std::uint8_t _%s[] = {\n", symbasename);

  unsigned char buf[256];
  size_t nread = 0;
  size_t linecount = 0;
  do {
    nread = fread(buf, 1, sizeof(buf), in);
    size_t i;
    for (i = 0; i < nread; i++) {
      fprintf(out, "0x%02x, ", buf[i]);
      if (++linecount == 10) {
        fprintf(out, "\n");
        linecount = 0;
      }
    }
  } while (nread > 0);
  if (linecount > 0) {
    fprintf(out, "\n");
  }
  fprintf(out, "};\n");
  fprintf(out, "#endif\n");

  fclose(in);
  fclose(out);

  return EXIT_SUCCESS;
}
