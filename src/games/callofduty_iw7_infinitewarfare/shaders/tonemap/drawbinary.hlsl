#define DB_HEIGHT 0.01f
#define DB_DIV 7.f
#define BF_B_T_1 float3(0,0.25f,0)
#define BF_B_T_2 float3(0.25f,0.25f,0)
#define BF_B_T color != BF_B_T_1 && color != BF_B_F ? BF_B_T_1 : BF_B_T_2
#define BF_B_F (float3)0.2f

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
