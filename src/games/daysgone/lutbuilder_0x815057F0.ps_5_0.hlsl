#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Mon Mar  9 16:57:58 2026
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[46];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[26];
}

// 3Dmigoto declarations
#define cmp -



void main(
  linear noperspective float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  uint v2 : SV_RenderTargetArrayIndex0,
  float4 v3 : TEXCOORD1,
  float3 v4 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = (uint)v2.x;
  r0.z = 0.0322580636 * r0.x;
  r0.xy = v0.xy * float2(1.03225803,1.03225803) + float2(-0.0161290318,-0.0161290318);

  r0.xyz = LutDecode(r0.xyz);
  

  r0.w = max(0, cb0[20].x);

  r1.x = dot(float3(1.66049004,-0.587641001,-0.0728498995), r0.xyz);
  r2.y = dot(float3(-0.12455,1.1329,-0.00834941957), r0.xyz);
  r0.x = dot(float3(-0.0181508008,-0.100579001,1.11872995), r0.xyz);
  r0.yz = t1.Load(float4(0,0,0,0)).xy;
  r0.yz = r0.yz * cb0[20].zz + float2(1,1);
  r2.x = r1.x * r0.y;
  r2.z = r0.x * r0.z;
  r0.x = 1.00055635 * r0.w;
  r0.y = cmp(6996.10791 >= r0.w);
  r1.xy = float2(4.60700006e+09,2.0064e+09) / r0.xx;
  r1.xy = float2(2967800,1901800) + -r1.xy;
  r1.xy = r1.xy / r0.xx;
  r1.xy = float2(99.1100006,247.479996) + r1.xy;
  r0.xz = r1.xy / r0.xx;
  r0.xz = float2(0.244063005,0.237039998) + r0.xz;
  r0.x = r0.y ? r0.x : r0.z;
  r0.z = r0.x * r0.x;
  r1.x = 2.86999989 * r0.x;
  r0.z = r0.z * -3 + r1.x;
  r0.y = -0.275000006 + r0.z;
  r1.xyz = r0.www * float3(0.000154118257,0.00084242021,4.22806261e-05) + float3(0.860117733,1,0.317398727);
  r0.z = r0.w * r0.w;
  r1.xyz = r0.zzz * float3(1.28641219e-07,7.08145137e-07,4.20481676e-08) + r1.xyz;
  r1.x = r1.x / r1.y;
  r1.w = -r0.w * 2.8974182e-05 + 1;
  r0.z = r0.z * 1.61456057e-07 + r1.w;
  r1.y = r1.z / r0.z;
  r1.zw = r1.xy + r1.xy;
  r0.z = 3 * r1.x;
  r1.z = -r1.y * 8 + r1.z;
  r1.z = 4 + r1.z;
  r3.x = r0.z / r1.z;
  r3.y = r1.w / r1.z;
  r0.z = cmp(r0.w < 4000);
  r0.xy = r0.zz ? r3.xy : r0.xy;
  r0.z = dot(r1.xy, r1.xy);
  r0.z = rsqrt(r0.z);
  r0.zw = r1.xy * r0.zz;
  r0.w = cb0[20].y * -r0.w;
  r0.w = r0.w * 0.0500000007 + r1.x;
  r0.z = cb0[20].y * r0.z;
  r0.z = r0.z * 0.0500000007 + r1.y;
  r1.x = 3 * r0.w;
  r0.w = r0.w + r0.w;
  r0.w = -r0.z * 8 + r0.w;
  r0.w = 4 + r0.w;
  r1.x = r1.x / r0.w;
  r0.z = r0.z + r0.z;
  r1.y = r0.z / r0.w;
  r0.zw = r1.xy + -r3.xy;
  r0.xy = r0.xy + r0.zw;
  r0.z = max(1.00000001e-10, r0.y);
  r1.x = r0.x / r0.z;
  r0.x = 1 + -r0.x;
  r0.x = r0.x + -r0.y;
  r1.z = r0.x / r0.z;
  r1.y = 1;
  r0.x = dot(float3(0.895099998,0.266400009,-0.161400005), r1.xyz);
  r0.y = dot(float3(-0.750199974,1.71350002,0.0366999991), r1.xyz);
  r0.z = dot(float3(0.0388999991,-0.0684999973,1.02960002), r1.xyz);
  r0.xyz = float3(0.941379189,1.04043639,1.08976662) / r0.xyz;
  r1.xyz = float3(0.895099998,0.266400009,-0.161400005) * r0.xxx;
  r0.xyw = float3(-0.750199974,1.71350002,0.0366999991) * r0.yyy;
  r3.xyz = float3(0.0388999991,-0.0684999973,1.02960002) * r0.zzz;
  r4.x = r1.x;
  r4.y = r0.x;
  r4.z = r3.x;
  r5.x = dot(float3(0.986992896,-0.1470543,0.159962699), r4.xyz);
  r6.x = r1.y;
  r6.y = r0.y;
  r6.z = r3.y;
  r5.y = dot(float3(0.986992896,-0.1470543,0.159962699), r6.xyz);
  r3.x = r1.z;
  r3.y = r0.w;
  r5.z = dot(float3(0.986992896,-0.1470543,0.159962699), r3.xyz);
  r0.x = dot(float3(0.432305306,0.518360317,0.0492912009), r4.xyz);
  r0.y = dot(float3(0.432305306,0.518360317,0.0492912009), r6.xyz);
  r0.z = dot(float3(0.432305306,0.518360317,0.0492912009), r3.xyz);
  r1.x = dot(float3(-0.0085287001,0.040042799,0.968486726), r4.xyz);
  r1.y = dot(float3(-0.0085287001,0.040042799,0.968486726), r6.xyz);
  r1.z = dot(float3(-0.0085287001,0.040042799,0.968486726), r3.xyz);
  r3.x = dot(r5.xyz, float3(0.412456393,0.212672904,0.0193339009));
  r4.x = dot(r5.xyz, float3(0.357576102,0.715152204,0.119191997));
  r5.x = dot(r5.xyz, float3(0.180437505,0.0721750036,0.950304091));
  r3.y = dot(r0.xyz, float3(0.412456393,0.212672904,0.0193339009));
  r4.y = dot(r0.xyz, float3(0.357576102,0.715152204,0.119191997));
  r5.y = dot(r0.xyz, float3(0.180437505,0.0721750036,0.950304091));
  r3.z = dot(r1.xyz, float3(0.412456393,0.212672904,0.0193339009));
  r4.z = dot(r1.xyz, float3(0.357576102,0.715152204,0.119191997));
  r5.z = dot(r1.xyz, float3(0.180437505,0.0721750036,0.950304091));
  r0.x = dot(float3(3.2409699,-1.5373832,-0.498610765), r3.xyz);
  r0.y = dot(float3(3.2409699,-1.5373832,-0.498610765), r4.xyz);
  r0.z = dot(float3(3.2409699,-1.5373832,-0.498610765), r5.xyz);
  r1.x = dot(float3(-0.969243646,1.8759675,0.0415550582), r3.xyz);
  r1.y = dot(float3(-0.969243646,1.8759675,0.0415550582), r4.xyz);
  r1.z = dot(float3(-0.969243646,1.8759675,0.0415550582), r5.xyz);
  r3.x = dot(float3(0.0556300804,-0.203976959,1.05697155), r3.xyz);
  r3.y = dot(float3(0.0556300804,-0.203976959,1.05697155), r4.xyz);
  r3.z = dot(float3(0.0556300804,-0.203976959,1.05697155), r5.xyz);
  r0.x = dot(r0.xyz, r2.xyz);
  r0.y = dot(r1.xyz, r2.xyz);
  r0.z = dot(r3.xyz, r2.xyz);
  r1.x = dot(float3(0.627403915,0.329283029,0.0433130674), r0.xyz);
  r1.y = dot(float3(0.069097288,0.919540405,0.0113623161), r0.xyz);
  r1.z = dot(float3(0.0163914394,0.0880133063,0.895595253), r0.xyz);
  r0.xyz = max(float3(0,0,0), r1.xyz);
  r1.x = dot(float3(0.613191485,0.33951208,0.0473663323), r0.xyz);
  r1.y = dot(float3(0.0702069029,0.916335821,0.0134500116), r0.xyz);
  r1.z = dot(float3(0.0206188709,0.109567292,0.869606733), r0.xyz);
  r0.x = dot(r1.xyz, float3(0.272228718,0.674081743,0.0536895171));
  r0.yzw = r1.xyz + -r0.xxx;

  r0.xyz = cb0[21].xyz * r0.yzw + r0.xxx;
  //r0.xyz = r0.yzw + r0.xxx;

  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.xyz = float3(5.55555534,5.55555534,5.55555534) * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = cb0[22].xyz * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = float3(0.180000007,0.180000007,0.180000007) * r0.xyz;
  r1.xyz = float3(1,1,1) / cb0[23].xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = exp2(r0.xyz);

  r0.xyz = r0.xyz * cb0[24].xyz + cb0[25].xyz; // color grading?

  r1.x = dot(float3(1.70505154,-0.621790707,-0.0832583979), r0.xyz);
  r1.y = dot(float3(-0.130257145,1.14080286,-0.0105485283), r0.xyz);
  r1.z = dot(float3(-0.0240032747,-0.128968775,1.15297174), r0.xyz);
  r0.x = cmp(cb0[7].w == 0.000000);
  if (r0.x != 0) {
    r0.x = dot(r1.xyz, cb0[2].xyz);
    r0.y = dot(r1.xyz, cb0[3].xyz);
    r0.z = dot(r1.xyz, cb0[4].xyz);
    r0.w = dot(r1.xyz, cb0[5].xyz);
    r0.w = 1 + r0.w;
    r0.w = rcp(r0.w);
    r2.xyz = cb0[7].xyz * r0.www + cb0[6].xyz;
    r0.xyz = r2.xyz * r0.xyz;
    r0.xyz = max(float3(0,0,0), r0.xyz);
    r2.xyz = cb0[9].xyz * r0.yyy;
    r0.xyw = r0.xxx * cb0[8].xyz + r2.xyz;
    r0.xyz = r0.zzz * cb0[10].xyz + r0.xyw;
    r0.xyz = cb0[11].xyz + r0.xyz;
  } else {
    r0.w = dot(float3(0.439700812,0.382978052,0.1773348), r1.xyz);
    r2.y = dot(float3(0.0897923037,0.813423157,0.096761629), r1.xyz);
    r2.z = dot(float3(0.0175439864,0.111544058,0.870704114), r1.xyz);
    r1.x = min(r2.y, r0.w);
    r1.x = min(r1.x, r2.z);
    r1.y = max(r2.y, r0.w);
    r1.y = max(r1.y, r2.z);
    r1.xyz = max(float3(1.00000001e-10,1.00000001e-10,0.00999999978), r1.xyy);
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

    // AP0 -> AP1
    r1.x = dot(float3(1.45143926,-0.236510754,-0.214928567), r2.xyz);
    r1.y = dot(float3(-0.0765537769,1.17622972,-0.0996759236), r2.xyz);
    r1.z = dot(float3(0.00831614807,-0.00603244966,0.997716308), r2.xyz);
    r1.xyz = max(float3(0,0,0), r1.xyz);
    r0.w = dot(r1.xyz, float3(0.272228718,0.674081743,0.0536895171));

    float3 untonemapped_ap1 = r1.xyz;

    // RRT start

    r1.xyz = r1.xyz + -r0.www;
    r1.xyz = r1.xyz * float3(0.959999979,0.959999979,0.959999979) + r0.www;
    r2.xy = float2(1,0.180000007) + cb0[12].ww;
    r0.w = -cb0[12].y + r2.x;
    r1.w = 1 + cb0[13].x;
    r2.x = -cb0[12].z + r1.w;
    r2.z = cmp(0.800000012 < cb0[12].y);
    r3.xy = float2(0.819999993,1) + -cb0[12].yy;
    r3.xy = r3.xy / cb0[12].xx;
    r2.w = -0.744727492 + r3.x;
    r2.y = r2.y / r0.w;
    r3.x = -1 + r2.y;
    r3.x = 1 + -r3.x;
    r2.y = r2.y / r3.x;
    r2.y = log2(r2.y);
    r2.y = 0.346573591 * r2.y;
    r3.x = r0.w / cb0[12].x;
    r2.y = -r2.y * r3.x + -0.744727492;
    r2.y = r2.z ? r2.w : r2.y;
    r2.z = r3.y + -r2.y;
    r2.w = cb0[12].z / cb0[12].x;
    r2.w = r2.w + -r2.z;
    r1.xyz = log2(r1.xyz);
    r3.xyz = float3(0.30103001,0.30103001,0.30103001) * r1.xyz;
    r4.xyz = r1.xyz * float3(0.30103001,0.30103001,0.30103001) + r2.zzz;
    r4.xyz = cb0[12].xxx * r4.xyz;
    r2.z = r0.w + r0.w;
    r3.w = -2 * cb0[12].x;
    r0.w = r3.w / r0.w;
    r5.xyz = r1.xyz * float3(0.30103001,0.30103001,0.30103001) + -r2.yyy;
    r6.xyz = r5.xyz * r0.www;
    r6.xyz = float3(1.44269502,1.44269502,1.44269502) * r6.xyz;
    r6.xyz = exp2(r6.xyz);
    r6.xyz = float3(1,1,1) + r6.xyz;
    r6.xyz = r2.zzz / r6.xyz;
    r6.xyz = -cb0[12].www + r6.xyz;
    r0.w = r2.x + r2.x;
    r2.z = cb0[12].x + cb0[12].x;
    r2.x = r2.z / r2.x;
    r1.xyz = r1.xyz * float3(0.30103001,0.30103001,0.30103001) + -r2.www;
    r1.xyz = r2.xxx * r1.xyz;
    r1.xyz = float3(1.44269502,1.44269502,1.44269502) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r1.xyz = float3(1,1,1) + r1.xyz;
    r1.xyz = r0.www / r1.xyz;
    r1.xyz = r1.www + -r1.xyz;
    r7.xyz = cmp(r3.xyz < r2.yyy);
    r6.xyz = r7.xyz ? r6.xyz : r4.xyz;
    r3.xyz = cmp(r2.www < r3.xyz);
    r1.xyz = r3.xyz ? r1.xyz : r4.xyz;
    r0.w = r2.w + -r2.y;
    r3.xyz = saturate(r5.xyz / r0.www);
    r0.w = cmp(r2.w < r2.y);
    r2.xyz = float3(1,1,1) + -r3.xyz;
    r2.xyz = r0.www ? r2.xyz : r3.xyz;
    r3.xyz = -r2.xyz * float3(2,2,2) + float3(3,3,3);
    r2.xyz = r2.xyz * r2.xyz;
    r2.xyz = r2.xyz * r3.xyz;
    r1.xyz = r1.xyz + -r6.xyz;
    r1.xyz = r2.xyz * r1.xyz + r6.xyz;
    r0.w = dot(r1.xyz, float3(0.272228718,0.674081743,0.0536895171));
    r1.xyz = r1.xyz + -r0.www;
    r1.xyz = r1.xyz * float3(0.930000007,0.930000007,0.930000007) + r0.www;

    if (SCENE_GRADE_SKIP_ACES == 1) {
      r1.xyz = untonemapped_ap1;
    }
    // RRT end

    // AP1 -> BT709 + D60 -> D65
    r2.x = dot(float3(1.70505154,-0.621790707,-0.0832583979), r1.xyz);
    r2.y = dot(float3(-0.130257145,1.14080286,-0.0105485283), r1.xyz);
    r2.z = dot(float3(-0.0240032747,-0.128968775,1.15297174), r1.xyz);
    r0.xyz = max(float3(0,0,0), r2.xyz);
  }

  float scale = ComputeReinhardSmoothClampScale(r0.xyz);
  //r0.xyz = RENODX_TONE_MAP_TYPE > 1 ? r0.xyz * scale : r0.xyz;

  r0.xyzw = saturate(r0.xyzx);
  r1.xyzw = float4(12.9200001,12.9200001,12.9200001,12.9200001) * r0.wyzw;
  r2.xyzw = cmp(r0.wyzw >= float4(0.00313066994,0.00313066994,0.00313066994,0.00313066994));
  r0.xyzw = log2(r0.xyzw);
  r0.xyzw = float4(0.416666657,0.416666657,0.416666657,0.416666657) * r0.xyzw;
  r0.xyzw = exp2(r0.xyzw);
  r0.xyzw = r0.xyzw * float4(1.05499995,1.05499995,1.05499995,1.05499995) + float4(-0.0549999997,-0.0549999997,-0.0549999997,-0.0549999997);
  r0.xyzw = r2.xyzw ? r0.xyzw : r1.xyzw;
  r1.yzw = r0.wyz * float3(0.9375,0.9375,0.9375) + float3(0.03125,0.03125,0.03125);
  r1.w = r1.w * 16 + -0.5;
  r2.x = floor(r1.w);
  r1.w = -r2.x + r1.w;
  r1.y = r2.x + r1.y;
  r1.x = 0.0625 * r1.y;
  r2.xyz = t0.SampleLevel(s0_s, r1.xz, 0).xyz;
  r1.xy = float2(0.0625,0) + r1.xz;
  r1.xyz = t0.SampleLevel(s0_s, r1.xy, 0).xyz;
  r3.xyzw = r1.xyzx + -r2.xyzx;
  r1.xyzw = r1.wwww * r3.xyzw + r2.xyzx;
  r1.xyzw = cb0[15].xxxx * r1.xyzw;
  r0.xyzw = cb0[14].xxxx * r0.xyzw + r1.xyzw;
  r0.xyzw = max(float4(6.10351999e-05,6.10351999e-05,6.10351999e-05,6.10351999e-05), r0.xyzw);
  r1.xyzw = cmp(float4(0.0404499993,0.0404499993,0.0404499993,0.0404499993) < r0.wyzw);
  r2.xyzw = r0.wyzw * float4(0.947867274,0.947867274,0.947867274,0.947867274) + float4(0.0521326996,0.0521326996,0.0521326996,0.0521326996);
  r2.xyzw = log2(r2.xyzw);
  r2.xyzw = float4(2.4000001,2.4000001,2.4000001,2.4000001) * r2.xyzw;
  r2.xyzw = exp2(r2.xyzw);
  r0.xyzw = float4(0.0773993805,0.0773993805,0.0773993805,0.0773993805) * r0.xyzw;
  r0.xyzw = r1.xyzw ? r2.xyzw : r0.xyzw;

  r1.xyzw = r0.wyzw * r0.wyzw;
  r0.xyzw = cb0[0].yyyy * r0.xyzw;
  r0.xyzw = cb0[0].xxxx * r1.xyzw + r0.xyzw;
  r0.xyzw = cb0[0].zzzz + r0.xyzw;
  r1.xyzw = cb0[18].yzwy * r0.xyzw;
  r0.xyzw = -r0.wyzw * cb0[18].yzwy + cb0[19].xyzx;
  r0.xyzw = cb0[19].wwww * r0.xyzw + r1.xyzw;
  r0.xyzw = max(float4(0,0,0,0), r0.xyzw);
  r0.xyzw = log2(r0.xyzw);
  r0.xyzw = cb0[1].yyyy * r0.xyzw;
  r0.xyzw = exp2(r0.xyzw);
  r1.xyzw = r0.wyzw * float4(15.8000002,15.8000002,15.8000002,15.8000002) + float4(2.11999989,2.11999989,2.11999989,2.11999989);
  r1.xyzw = r1.xyzw * r0.wyzw;
  r2.xyzw = r0.wyzw * float4(1.20000005,1.20000005,1.20000005,1.20000005) + float4(5.92000008,5.92000008,5.92000008,5.92000008);
  r0.xyzw = r0.xyzw * r2.xyzw + float4(1.89999998,1.89999998,1.89999998,1.89999998);
  r0.xyzw = r1.xyzw / r0.xyzw;
  r0.xyzw = float4(0.5,0.5,0.5,0.5) * r0.xyzw;
  r1.x = asint(cb1[45].x) & 8;
  r1.y = max(r0.y, r0.z);
  r1.y = max(r1.y, r0.w);

  // BT2020 -> BT709
  r2.x = dot(float3(-0.587641001,-0.0728498995,1.66049004), r0.yzw);
  r2.y = dot(float3(1.1329,-0.00834941957,-0.12455), r0.yzw);
  r2.z = dot(float3(-0.100579001,1.11872995,-0.0181508008), r0.yzw);

  //r0.xyz = RENODX_TONE_MAP_TYPE > 1 ? r0.xyz / scale : r0.xyz;

  r1.z = 10 / r1.y;
  r2.xyzw = r2.xyzx * r1.zzzz;
  r3.xyzw = r2.wyzw * float4(1.41421354,1.41421354,1.41421354,1.41421354) + float4(-1.41421354,-1.41421354,-1.41421354,-1.41421354);
  r4.xyzw = exp2(r3.wyzw);
  r3.xyzw = cmp(float4(0,0,0,0) < r3.xyzw);
  r2.xyzw = r3.xyzw ? r2.xyzw : r4.xyzw;
  r1.z = cmp(0 < r1.y);
  r1.y = 0.100000001 * r1.y;
  r2.xyzw = r2.xyzw * r1.yyyy;
  r2.xyzw = r1.zzzz ? r2.xyzw : 0;
  r0.xyzw = r1.xxxx ? r0.xyzw : r2.xyzw;
  r1.xy = float2(0.00499999989,0.99000001) * r0.yw;
  r0.w = r1.y + r1.x;
  r1.x = r0.z * 0.00499999989 + r0.w;
  r0.xw = r0.xx * float2(0.00499999989,0.00499999989) + r0.yz;
  r0.x = -r0.y * 0.00999999978 + r0.x;
  r1.y = r0.z * 0.00499999989 + r0.x;
  r0.x = r0.y * 0.00499999989 + r0.w;
  r1.z = -r0.z * 0.00999999978 + r0.x;
  r0.xyz = float3(0.5,0.5,0.5) * r1.xyz;
  r0.xyz = max(float3(0,0,0), r0.xyz);
  // o0.xyz = sqrt(r0.xyz);
  o0.xyz = LutEncode(r0.xyz);
  o0.w = 0;
  return;
}