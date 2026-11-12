#include "../../common.hlsl"

// Found in what remains of edith finch

// ---- Created with 3Dmigoto v1.3.16 on Fri May 30 18:01:02 2025
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[41];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float2 v0: TEXCOORD0,
    float4 v1: SV_POSITION0,
    uint v2: SV_RenderTargetArrayIndex0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5, r6, r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = (uint)v2.x;
  r0.z = 0.0322580636 * r0.x;
  r0.xy = v0.xy * float2(1.03225803, 1.03225803) + float2(-0.0161290318, -0.0161290318);
  r0.xyz = float3(-0.434017599, -0.434017599, -0.434017599) + r0.xyz;
  r0.xyz = float3(14, 14, 14) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = float3(0.180000007, 0.180000007, 0.180000007) * r0.xyz;
  r0.w = 1.00055635 * cb0[35].x;
  r1.x = cmp(6996.10791 >= cb0[35].x);
  r1.yz = float2(4.60700006e+09, 2.0064e+09) / r0.ww;
  r1.yz = float2(2967800, 1901800) + -r1.yz;
  r1.yz = r1.yz / r0.ww;
  r1.yz = float2(99.1100006, 247.479996) + r1.yz;
  r1.yz = r1.yz / r0.ww;
  r1.yz = float2(0.244063005, 0.237039998) + r1.yz;
  r1.x = r1.x ? r1.y : r1.z;
  r0.w = r1.x * r1.x;
  r1.z = 2.86999989 * r1.x;
  r0.w = r0.w * -3 + r1.z;
  r1.y = -0.275000006 + r0.w;
  r2.xyz = cb0[35].xxx * float3(0.000154118257, 0.00084242021, 4.22806261e-05) + float3(0.860117733, 1, 0.317398727);
  r0.w = cb0[35].x * cb0[35].x;
  r2.xyz = r0.www * float3(1.28641219e-07, 7.08145137e-07, 4.20481676e-08) + r2.xyz;
  r2.x = r2.x / r2.y;
  r1.z = -cb0[35].x * 2.8974182e-05 + 1;
  r0.w = r0.w * 1.61456057e-07 + r1.z;
  r2.y = r2.z / r0.w;
  r1.zw = r2.xy + r2.xy;
  r0.w = 3 * r2.x;
  r1.z = -r2.y * 8 + r1.z;
  r1.z = 4 + r1.z;
  r3.x = r0.w / r1.z;
  r3.y = r1.w / r1.z;
  r0.w = cmp(cb0[35].x < 4000);
  r1.xy = r0.ww ? r3.xy : r1.xy;
  r0.w = dot(r2.xy, r2.xy);
  r0.w = rsqrt(r0.w);
  r1.zw = r2.xy * r0.ww;
  r0.w = cb0[35].y * -r1.w;
  r0.w = r0.w * 0.0500000007 + r2.x;
  r1.z = cb0[35].y * r1.z;
  r1.z = r1.z * 0.0500000007 + r2.y;
  r1.w = 3 * r0.w;
  r0.w = r0.w + r0.w;
  r0.w = -r1.z * 8 + r0.w;
  r0.w = 4 + r0.w;
  r1.z = r1.z + r1.z;
  r2.xy = r1.wz / r0.ww;
  r1.zw = r2.xy + -r3.xy;
  r1.xy = r1.xy + r1.zw;
  r0.w = max(1.00000001e-10, r1.y);
  r2.x = r1.x / r0.w;
  r1.x = 1 + -r1.x;
  r1.x = r1.x + -r1.y;
  r2.z = r1.x / r0.w;
  r2.y = 1;
  r0.w = dot(float3(0.895099998, 0.266400009, -0.161400005), r2.xyz);
  r1.x = dot(float3(-0.750199974, 1.71350002, 0.0366999991), r2.xyz);
  r1.y = dot(float3(0.0388999991, -0.0684999973, 1.02960002), r2.xyz);
  r0.w = 0.941379189 / r0.w;
  r1.xy = float2(1.04043639, 1.08976662) / r1.xy;
  r2.xyz = float3(0.895099998, 0.266400009, -0.161400005) * r0.www;
  r1.xzw = float3(-0.750199974, 1.71350002, 0.0366999991) * r1.xxx;
  r3.xyz = float3(0.0388999991, -0.0684999973, 1.02960002) * r1.yyy;
  r4.x = r2.x;
  r4.y = r1.x;
  r4.z = r3.x;
  r5.x = dot(float3(0.986992896, -0.1470543, 0.159962699), r4.xyz);
  r6.x = r2.y;
  r6.y = r1.z;
  r6.z = r3.y;
  r5.y = dot(float3(0.986992896, -0.1470543, 0.159962699), r6.xyz);
  r3.x = r2.z;
  r3.y = r1.w;
  r5.z = dot(float3(0.986992896, -0.1470543, 0.159962699), r3.xyz);
  r1.x = dot(float3(0.432305306, 0.518360317, 0.0492912009), r4.xyz);
  r1.y = dot(float3(0.432305306, 0.518360317, 0.0492912009), r6.xyz);
  r1.z = dot(float3(0.432305306, 0.518360317, 0.0492912009), r3.xyz);
  r2.x = dot(float3(-0.0085287001, 0.040042799, 0.968486726), r4.xyz);
  r2.y = dot(float3(-0.0085287001, 0.040042799, 0.968486726), r6.xyz);
  r2.z = dot(float3(-0.0085287001, 0.040042799, 0.968486726), r3.xyz);
  r3.x = dot(r5.xyz, float3(0.412456393, 0.212672904, 0.0193339009));
  r4.x = dot(r5.xyz, float3(0.357576102, 0.715152204, 0.119191997));
  r5.x = dot(r5.xyz, float3(0.180437505, 0.0721750036, 0.950304091));
  r3.y = dot(r1.xyz, float3(0.412456393, 0.212672904, 0.0193339009));
  r4.y = dot(r1.xyz, float3(0.357576102, 0.715152204, 0.119191997));
  r5.y = dot(r1.xyz, float3(0.180437505, 0.0721750036, 0.950304091));
  r3.z = dot(r2.xyz, float3(0.412456393, 0.212672904, 0.0193339009));
  r4.z = dot(r2.xyz, float3(0.357576102, 0.715152204, 0.119191997));
  r5.z = dot(r2.xyz, float3(0.180437505, 0.0721750036, 0.950304091));
  r1.x = dot(float3(3.2409699, -1.5373832, -0.498610765), r3.xyz);
  r1.y = dot(float3(3.2409699, -1.5373832, -0.498610765), r4.xyz);
  r1.z = dot(float3(3.2409699, -1.5373832, -0.498610765), r5.xyz);
  r2.x = dot(float3(-0.969243646, 1.8759675, 0.0415550582), r3.xyz);
  r2.y = dot(float3(-0.969243646, 1.8759675, 0.0415550582), r4.xyz);
  r2.z = dot(float3(-0.969243646, 1.8759675, 0.0415550582), r5.xyz);
  r3.x = dot(float3(0.0556300804, -0.203976959, 1.05697155), r3.xyz);
  r3.y = dot(float3(0.0556300804, -0.203976959, 1.05697155), r4.xyz);
  r3.z = dot(float3(0.0556300804, -0.203976959, 1.05697155), r5.xyz);
  r1.x = dot(r1.xyz, r0.xyz);
  r1.y = dot(r2.xyz, r0.xyz);
  r1.z = dot(r3.xyz, r0.xyz);
  r0.x = dot(float3(0.613191485, 0.33951208, 0.0473663323), r1.xyz);
  r0.y = dot(float3(0.0702069029, 0.916335821, 0.0134500116), r1.xyz);
  r0.z = dot(float3(0.0206188709, 0.109567292, 0.869606733), r1.xyz);
  r0.w = dot(r0.xyz, float3(0.272228718, 0.674081743, 0.0536895171));

  SetUngradedAP1(r0.xyz);

  r0.xyz = r0.xyz + -r0.www;
  r0.xyz = cb0[36].xyz * r0.xyz + r0.www;
  r0.xyz = max(float3(0, 0, 0), r0.xyz);
  r0.xyz = float3(5.55555534, 5.55555534, 5.55555534) * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = cb0[37].xyz * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = float3(0.180000007, 0.180000007, 0.180000007) * r0.xyz;
  r1.xyz = float3(1, 1, 1) / cb0[38].xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = r0.xyz * cb0[39].xyz + cb0[40].xyz;

  SetUntonemappedAP1(r0.xyz);

  r1.x = dot(float3(1.70505154, -0.621790707, -0.0832583979), r0.xyz);
  r1.y = dot(float3(-0.130257145, 1.14080286, -0.0105485283), r0.xyz);
  r1.z = dot(float3(-0.0240032747, -0.128968775, 1.15297174), r0.xyz);
  r0.x = cmp(cb0[26].w == 0.000000);
  [branch]
  if (r0.x != 0) {
    r0.x = dot(r1.xyz, cb0[19].xyz);
    r0.y = dot(r1.xyz, cb0[20].xyz);
    r0.z = dot(r1.xyz, cb0[21].xyz);
    r0.w = dot(r1.xyz, cb0[24].xyz);
    r0.w = 1 + r0.w;
    r0.w = rcp(r0.w);
    r2.xyz = cb0[26].xyz * r0.www + cb0[25].xyz;
    r0.xyz = r2.xyz * r0.xyz;
    r0.xyz = max(float3(0, 0, 0), r0.xyz);
    r2.xyz = cb0[22].xxx + -r0.xyz;
    r2.xyz = max(float3(0, 0, 0), r2.xyz);
    r3.xyz = max(cb0[22].zzz, r0.xyz);
    r0.xyz = max(cb0[22].xxx, r0.xyz);
    r0.xyz = min(cb0[22].zzz, r0.xyz);
    r4.xyz = r3.xyz * cb0[23].xxx + cb0[23].yyy;
    r3.xyz = cb0[22].www + r3.xyz;
    r3.xyz = rcp(r3.xyz);
    r5.xyz = cb0[19].www * r2.xyz;
    r2.xyz = cb0[22].yyy + r2.xyz;
    r2.xyz = rcp(r2.xyz);
    r2.xyz = r5.xyz * r2.xyz + cb0[20].www;
    r0.xyz = r0.xyz * cb0[21].www + r2.xyz;
    r0.xyz = r4.xyz * r3.xyz + r0.xyz;
    r0.xyz = float3(-0.00200000009, -0.00200000009, -0.00200000009) + r0.xyz;

    SetTonemappedBT709(r0.xyz);

  } else {
    r0.w = dot(float3(0.439700812, 0.382978052, 0.1773348), r1.xyz);
    r2.y = dot(float3(0.0897923037, 0.813423157, 0.096761629), r1.xyz);
    r2.z = dot(float3(0.0175439864, 0.111544058, 0.870704114), r1.xyz);
    r1.x = min(r2.y, r0.w);
    r1.x = min(r1.x, r2.z);
    r1.y = max(r2.y, r0.w);
    r1.y = max(r1.y, r2.z);
    r1.xyz = max(float3(1.00000001e-10, 1.00000001e-10, 0.00999999978), r1.xyy);
    r1.x = r1.y + -r1.x;
    r1.x = r1.x / r1.z;
    r1.y = cmp(r0.w == r2.y);
    r1.z = cmp(r2.y == r2.z);
    r1.y = r1.z ? r1.y : 0;
    r1.z = r2.y + -r2.z;
    r1.z = 1.73205078 * r1.z;
    r1.w = r0.w * 2 + -r2.y;
    r1.w = r1.w + -r2.z;
    r2.w = min(abs(r1.z), abs(r1.w));
    r3.x = max(abs(r1.z), abs(r1.w));
    r3.x = 1 / r3.x;
    r2.w = r3.x * r2.w;
    r3.x = r2.w * r2.w;
    r3.y = r3.x * 0.0208350997 + -0.0851330012;
    r3.y = r3.x * r3.y + 0.180141002;
    r3.y = r3.x * r3.y + -0.330299497;
    r3.x = r3.x * r3.y + 0.999866009;
    r3.y = r3.x * r2.w;
    r3.z = cmp(abs(r1.w) < abs(r1.z));
    r3.y = r3.y * -2 + 1.57079637;
    r3.y = r3.z ? r3.y : 0;
    r2.w = r2.w * r3.x + r3.y;
    r3.x = cmp(r1.w < -r1.w);
    r3.x = r3.x ? -3.141593 : 0;
    r2.w = r3.x + r2.w;
    r3.x = min(r1.z, r1.w);
    r1.z = max(r1.z, r1.w);
    r1.w = cmp(r3.x < -r3.x);
    r1.z = cmp(r1.z >= -r1.z);
    r1.z = r1.z ? r1.w : 0;
    r1.z = r1.z ? -r2.w : r2.w;
    r1.z = 57.2957802 * r1.z;
    r1.y = r1.y ? 0 : r1.z;
    r1.z = cmp(r1.y < 0);
    r1.w = 360 + r1.y;
    r1.y = r1.z ? r1.w : r1.y;
    r1.y = max(0, r1.y);
    r1.y = min(360, r1.y);
    r1.z = cmp(180 < r1.y);
    r1.w = -360 + r1.y;
    r1.y = r1.z ? r1.w : r1.y;
    r1.y = 0.0148148146 * r1.y;
    r1.y = 1 + -abs(r1.y);
    r1.y = max(0, r1.y);
    r1.z = r1.y * -2 + 3;
    r1.y = r1.y * r1.y;
    r1.y = r1.z * r1.y;
    r1.y = r1.y * r1.y;
    r1.x = r1.y * r1.x;
    r1.y = 0.0299999993 + -r0.w;
    r1.x = r1.x * r1.y;
    r2.x = r1.x * 0.180000007 + r0.w;
    r1.x = dot(float3(1.45143926, -0.236510754, -0.214928567), r2.xyz);
    r1.y = dot(float3(-0.0765537769, 1.17622972, -0.0996759236), r2.xyz);
    r1.z = dot(float3(0.00831614807, -0.00603244966, 0.997716308), r2.xyz);
    r1.xyz = max(float3(0, 0, 0), r1.xyz);
    r0.w = dot(r1.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
    r1.xyz = r1.xyz + -r0.www;
    r1.xyz = r1.xyz * float3(0.959999979, 0.959999979, 0.959999979) + r0.www;
    r2.xy = float2(1, 0.180000007) + cb0[27].ww;
    r0.w = -cb0[27].y + r2.x;
    r1.w = 1 + cb0[28].x;
    r2.x = -cb0[27].z + r1.w;
    r2.z = cmp(0.800000012 < cb0[27].y);
    r3.xy = float2(0.819999993, 1) + -cb0[27].yy;
    r3.xy = r3.xy / cb0[27].xx;
    r2.w = -0.744727492 + r3.x;
    r2.y = r2.y / r0.w;
    r3.x = -1 + r2.y;
    r3.x = 1 + -r3.x;
    r2.y = r2.y / r3.x;
    r2.y = log2(r2.y);
    r2.y = 0.346573591 * r2.y;
    r3.x = r0.w / cb0[27].x;
    r2.y = -r2.y * r3.x + -0.744727492;
    r2.y = r2.z ? r2.w : r2.y;
    r2.z = r3.y + -r2.y;
    r2.w = cb0[27].z / cb0[27].x;
    r2.w = r2.w + -r2.z;
    r1.xyz = log2(r1.xyz);
    r3.xyz = float3(0.30103001, 0.30103001, 0.30103001) * r1.xyz;
    r4.xyz = r1.xyz * float3(0.30103001, 0.30103001, 0.30103001) + r2.zzz;
    r4.xyz = cb0[27].xxx * r4.xyz;
    r2.z = r0.w + r0.w;
    r3.w = -2 * cb0[27].x;
    r0.w = r3.w / r0.w;
    r5.xyz = r1.xyz * float3(0.30103001, 0.30103001, 0.30103001) + -r2.yyy;
    r6.xyz = r5.xyz * r0.www;
    r6.xyz = float3(1.44269502, 1.44269502, 1.44269502) * r6.xyz;
    r6.xyz = exp2(r6.xyz);
    r6.xyz = float3(1, 1, 1) + r6.xyz;
    r6.xyz = r2.zzz / r6.xyz;
    r6.xyz = -cb0[27].www + r6.xyz;
    r0.w = r2.x + r2.x;
    r2.z = cb0[27].x + cb0[27].x;
    r2.x = r2.z / r2.x;
    r1.xyz = r1.xyz * float3(0.30103001, 0.30103001, 0.30103001) + -r2.www;
    r1.xyz = r2.xxx * r1.xyz;
    r1.xyz = float3(1.44269502, 1.44269502, 1.44269502) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r1.xyz = float3(1, 1, 1) + r1.xyz;
    r1.xyz = r0.www / r1.xyz;
    r1.xyz = r1.www + -r1.xyz;
    r7.xyz = cmp(r3.xyz < r2.yyy);
    r6.xyz = r7.xyz ? r6.xyz : r4.xyz;
    r3.xyz = cmp(r2.www < r3.xyz);
    r1.xyz = r3.xyz ? r1.xyz : r4.xyz;
    r0.w = r2.w + -r2.y;
    r3.xyz = saturate(r5.xyz / r0.www);
    r0.w = cmp(r2.w < r2.y);
    r2.xyz = float3(1, 1, 1) + -r3.xyz;
    r2.xyz = r0.www ? r2.xyz : r3.xyz;
    r3.xyz = -r2.xyz * float3(2, 2, 2) + float3(3, 3, 3);
    r2.xyz = r2.xyz * r2.xyz;
    r2.xyz = r2.xyz * r3.xyz;
    r1.xyz = r1.xyz + -r6.xyz;
    r1.xyz = r2.xyz * r1.xyz + r6.xyz;
    r0.w = dot(r1.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
    r1.xyz = r1.xyz + -r0.www;
    r1.xyz = r1.xyz * float3(0.930000007, 0.930000007, 0.930000007) + r0.www;
    r2.x = dot(float3(1.70505154, -0.621790707, -0.0832583979), r1.xyz);
    r2.y = dot(float3(-0.130257145, 1.14080286, -0.0105485283), r1.xyz);
    r2.z = dot(float3(-0.0240032747, -0.128968775, 1.15297174), r1.xyz);

    SetTonemappedBT709(r2.xyz);

    r0.xyz = max(float3(0, 0, 0), r2.xyz);
  }
  r0.xyz = saturate(r0.xyz);
  r1.xyz = float3(12.9200001, 12.9200001, 12.9200001) * r0.xyz;
  r2.xyz = cmp(r0.xyz >= float3(0.00313066994, 0.00313066994, 0.00313066994));
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = r0.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
  r0.xyz = r2.xyz ? r0.xyz : r1.xyz;
  r1.yzw = r0.xyz * float3(0.9375, 0.9375, 0.9375) + float3(0.03125, 0.03125, 0.03125);
  r0.w = r1.w * 16 + -0.5;
  r1.w = floor(r0.w);
  r0.w = -r1.w + r0.w;
  r1.y = r1.y + r1.w;
  r1.x = 0.0625 * r1.y;
  r2.xyz = t0.Sample(s0_s, r1.xz).xyz;
  r1.xy = float2(0.0625, 0) + r1.xz;
  r1.xyz = t0.Sample(s0_s, r1.xy).xyz;
  r1.xyz = r1.xyz + -r2.xyz;
  r1.xyz = r0.www * r1.xyz + r2.xyz;
  r1.xyz = cb0[30].xxx * r1.xyz;
  r0.xyz = cb0[29].xxx * r0.xyz + r1.xyz;
  r0.xyz = max(float3(6.10351999e-05, 6.10351999e-05, 6.10351999e-05), r0.xyz);
  r1.xyz = cmp(float3(0.0404499993, 0.0404499993, 0.0404499993) < r0.xyz);
  r2.xyz = r0.xyz * float3(0.947867274, 0.947867274, 0.947867274) + float3(0.0521326996, 0.0521326996, 0.0521326996);
  r2.xyz = log2(r2.xyz);
  r2.xyz = float3(2.4000001, 2.4000001, 2.4000001) * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r0.xyz = float3(0.0773993805, 0.0773993805, 0.0773993805) * r0.xyz;
  r0.xyz = r1.xyz ? r2.xyz : r0.xyz;
  r1.xyz = r0.xyz * r0.xyz;
  r0.xyz = cb0[17].yyy * r0.xyz;
  r0.xyz = cb0[17].xxx * r1.xyz + r0.xyz;
  r0.xyz = cb0[17].zzz + r0.xyz;
  r1.xyz = cb0[33].yzw * r0.xyz;
  r0.xyz = -r0.xyz * cb0[33].yzw + cb0[34].xyz;
  r0.xyz = cb0[34].www * r0.xyz + r1.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = cb0[18].yyy * r0.xyz;
  r1.xyz = exp2(r0.xyz);

  if (RENODX_TONE_MAP_TYPE != 0) {
    o0 = GenerateOutput(r1.xyz, asuint(cb0[40].w));
    return;
  }

  [branch]
  if (asuint(cb0[40].w) == 0) {
    r2.xyz = float3(12.9200001, 12.9200001, 12.9200001) * r1.xyz;
    r3.xyz = cmp(r1.xyz >= float3(0.00313066994, 0.00313066994, 0.00313066994));
    r4.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r0.xyz;
    r4.xyz = exp2(r4.xyz);
    r4.xyz = r4.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
    r2.xyz = r3.xyz ? r4.xyz : r2.xyz;
  } else {
    r0.w = cmp(asint(cb0[40].w) == 1);
    r1.xyz = max(float3(6.10351999e-05, 6.10351999e-05, 6.10351999e-05), r1.xyz);
    r3.xyz = float3(4.5, 4.5, 4.5) * r1.xyz;
    r1.xyz = max(float3(0.0179999992, 0.0179999992, 0.0179999992), r1.xyz);
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(0.449999988, 0.449999988, 0.449999988) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r1.xyz = r1.xyz * float3(1.09899998, 1.09899998, 1.09899998) + float3(-0.0989999995, -0.0989999995, -0.0989999995);
    r1.xyz = min(r3.xyz, r1.xyz);
    r0.xyz = cb0[18].zzz * r0.xyz;
    r0.xyz = exp2(r0.xyz);
    r2.xyz = r0.www ? r1.xyz : r0.xyz;
  }
  o0.xyz = float3(0.952380955, 0.952380955, 0.952380955) * r2.xyz;
  o0.w = 0;

  o0 = saturate(o0);

  return;
}
