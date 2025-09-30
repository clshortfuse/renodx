#define DB_HEIGHT 0.01f
#define DB_DIV 7.f
#define BF_B_T lerp(color, float3(0,1,0), 0.9f)
#define BF_B_F lerp(color, (float3)0.2f, 0.5f)

float3 DrawBinary(in int i, in float3 color, in float2 uv) {
  if (uv.y > DB_HEIGHT) return color;

  if (i > 15 || i < 0) return float3(0.5f, 0, 0);

  if (uv.x < 1/DB_DIV) {
    if ((i & 8 /* 0b1000 */) > 0) return BF_B_T;
    else return BF_B_F;
  } else if (uv.x < 2/DB_DIV) {
    return color;
  } else if (uv.x < 3/DB_DIV) {
    if ((i & 4 /* 0b0100 */) > 0) return BF_B_T;
    else return BF_B_F;
  } else if (uv.x < 4/DB_DIV) {
    return color;
  }   if (uv.x < 5/DB_DIV) {
    if ((i & 2 /* 0b0010 */) > 0) return BF_B_T;
    else return BF_B_F;
  } else if (uv.x < 6/DB_DIV) {
    return color;
  } else /* if (uv.x < 7/DB_DIV) */ {
    if ((i & 1 /* 0b0001 */) > 0) return BF_B_T;
    else return BF_B_F;
  }
}
