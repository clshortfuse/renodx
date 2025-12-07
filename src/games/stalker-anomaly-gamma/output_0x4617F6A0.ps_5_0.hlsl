// ---- Created with 3Dmigoto v1.4.1 on Sat Oct 18 23:14:06 2025

cbuffer _Globals : register(b0)
{
  float4 hdr10_parameters1 : packoffset(c0);
  float4 hdr10_parameters2 : packoffset(c1);
  float4 hdr10_parameters3 : packoffset(c2);
  float4 hdr10_parameters4 : packoffset(c3);
  float4 hdr10_parameters5 : packoffset(c4);
  float4 hdr10_parameters6 : packoffset(c5);
  float4 hdr10_parameters7 : packoffset(c6);
  float4 hdr10_parameters8 : packoffset(c7);
  float4 hdr10_parameters9 : packoffset(c8);
  float4 hdr10_parameters10 : packoffset(c9);
  row_major float4x4 m_wvp_prev : packoffset(c10);
  row_major float4x4 m_vp_prev : packoffset(c14);
  float4 ssfx_jitter : packoffset(c18);
  float4 L_hotness : packoffset(c19);
  float4 c_brightness : packoffset(c20);
}

SamplerState smp_rtlinear_s : register(s0);
SamplerState smp_linear_s : register(s1);
Texture2D<float4> s_base0 : register(t0);
Texture2D<float4> s_base1 : register(t1);
Texture2D<float4> s_noise : register(t2);


// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  float2 w0 : TEXCOORD1,
  float2 v1 : TEXCOORD2,
  float4 v2 : COLOR0,
  float4 v3 : COLOR1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = s_base0.Sample(smp_rtlinear_s, v0.xy).xyz;
  r1.xyz = s_base1.Sample(smp_rtlinear_s, w0.xy).xyz;
  r0.xyz = r1.xyz + r0.xyz;
  r1.xyz = float3(0.5,0.5,0.5) * r0.xyz;
  r0.w = dot(r1.xyz, v3.xyz);
  r0.xyz = r0.xyz * float3(0.5,0.5,0.5) + -r0.www;
  r0.xyz = v3.www * r0.xyz + r0.www;
  r1.xyz = s_noise.Sample(smp_linear_s, v1.xy).xyz;
  r1.xyz = r1.xyz * r0.xyz;
  r2.xyz = r1.xyz + r1.xyz;
  r0.xyz = -r1.xyz * float3(2,2,2) + r0.xyz;
  r0.xyz = v2.www * r0.xyz + r2.xyz;
  r0.xyz = r0.xyz * v2.xyz + c_brightness.xyz;
  r0.xyz = r0.xyz + r0.xyz;
  r0.w = cmp(hdr10_parameters1.z != 0.000000);
  if (r0.w != 0) {
    r1.xyz = max(float3(0,0,0), r0.xyz);
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(2.20000005,2.20000005,2.20000005) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r1.xyz = hdr10_parameters6.xxx + r1.xyz;
    r1.xyz = log2(r1.xyz);
    r1.xyz = hdr10_parameters6.yyy * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r1.xyz = hdr10_parameters3.xxx * r1.xyz;
    r2.xyz = cmp(float3(0.0113610001,0.0113610001,0.0113610001) < r1.xyz);
    r3.xyz = r1.xyz * float3(5.55555582,5.55555582,5.55555582) + float3(0.0479959995,0.0479959995,0.0479959995);
    r3.xyz = log2(r3.xyz);
    r3.xyz = r3.xyz * float3(0.0734997839,0.0734997839,0.0734997839) + float3(0.386036009,0.386036009,0.386036009);
    r1.xyz = r1.xyz * float3(5.30188322,5.30188322,5.30188322) + float3(0.0928139985,0.0928139985,0.0928139985);
    r1.xyz = r2.xyz ? r3.xyz : r1.xyz;
    r1.xyz = -hdr10_parameters3.www + r1.xyz;
    r1.xyz = r1.xyz * hdr10_parameters3.yyy + hdr10_parameters3.www;
    r2.xyz = cmp(float3(0.153048694,0.153048694,0.153048694) < r1.xyz);
    r3.xyz = float3(-0.386036009,-0.386036009,-0.386036009) + r1.xyz;
    r3.xyz = float3(13.6054821,13.6054821,13.6054821) * r3.xyz;
    r3.xyz = exp2(r3.xyz);
    r3.xyz = float3(-0.0479959995,-0.0479959995,-0.0479959995) + r3.xyz;
    r3.xyz = float3(0.179999992,0.179999992,0.179999992) * r3.xyz;
    r1.xyz = float3(-0.0928139985,-0.0928139985,-0.0928139985) + r1.xyz;
    r1.xyz = float3(0.188612223,0.188612223,0.188612223) * r1.xyz;
    r1.xyz = r2.xyz ? r3.xyz : r1.xyz;
    r0.w = dot(r1.xyz, float3(0.212639004,0.715168715,0.0721922964));
    r1.xyz = r1.xyz + -r0.www;
    r1.xyz = hdr10_parameters3.zzz * r1.xyz + r0.www;
    r2.x = dot(float2(0.822461963,0.177538037), r1.xy);
    r2.y = dot(float2(0.0331941992,0.966805816), r1.xy);
    r2.z = dot(float3(0.0170826297,0.0723974407,0.910519958), r1.xyz);
    r3.xyzw = cmp(hdr10_parameters2.xxwx == float4(1,2,0,0));
    r4.x = dot(float3(0.627403915,0.329283029,0.0433130711), r1.xyz);
    r4.y = dot(float3(0.069097288,0.919540405,0.0113623198), r1.xyz);
    r4.z = dot(float3(0.0163914394,0.0880133137,0.895595253), r1.xyz);
    r2.xyz = r3.xxx ? r2.xyz : r4.xyz;
    r3.yw = (int2)r3.yw | (int2)r3.xx;
    r1.xyz = r3.yyy ? r2.xyz : r1.xyz;
    if (r3.z != 0) {
      r2.xy = cmp(hdr10_parameters2.xz == float2(0,1));
      r0.w = dot(r1.xyz, float3(0.212639004,0.715168715,0.0721922964));
      r1.w = dot(r1.xyz, float3(0.228974596,0.691738486,0.0792869031));
      r2.z = dot(r1.xyz, float3(0.2627002,0.677998126,0.0593017004));
      r1.w = r3.x ? r1.w : r2.z;
      r0.w = r2.x ? r0.w : r1.w;
      r1.w = (int)r3.y | (int)r2.x;
      r0.w = r1.w ? r0.w : 0xffc00000;
      if (r2.y != 0) {
        r2.yz = r0.ww * float2(2.50999999,2.43000007) + float2(0.0299999993,0.589999974);
        r2.y = r2.y * r0.w;
        r2.z = r0.w * r2.z + 0.140000001;
        r2.y = saturate(r2.y / r2.z);
        r2.z = -1;
      } else {
        r2.w = cmp(hdr10_parameters2.z == 2.000000);
        if (r2.w != 0) {
          r4.x = dot(float3(0.597190022,0.354579985,0.0482299998), r0.www);
          r4.y = dot(float3(0.0759999976,0.908339977,0.0156599991), r0.www);
          r4.z = dot(float3(0.0284000002,0.133829996,0.837769985), r0.www);
          r5.xyz = float3(0.0245785993,0.0245785993,0.0245785993) + r4.xyz;
          r5.xyz = r4.xyz * r5.xyz + float3(-9.05370034e-05,-9.05370034e-05,-9.05370034e-05);
          r6.xyz = r4.xyz * float3(0.983729005,0.983729005,0.983729005) + float3(0.432951003,0.432951003,0.432951003);
          r4.xyz = r4.xyz * r6.xyz + float3(0.238080993,0.238080993,0.238080993);
          r4.xyz = r5.xyz / r4.xyz;
          r2.y = saturate(dot(float3(1.60475004,-0.531080008,-0.0736699998), r4.xyz));
          r2.z = -1;
        } else {
          r2.w = cmp(hdr10_parameters2.z == 4.000000);
          if (r2.w != 0) {
            r4.x = dot(float3(0.84247905,0.078433603,0.0792237446), r0.www);
            r4.y = dot(float3(0.0423282422,0.878468633,0.0791661292), r0.www);
            r4.z = dot(float3(0.042375654,0.078433603,0.879143), r0.www);
            r5.xyz = cmp(float3(0,0,0) >= r4.xyz);
            r4.xyz = log2(r4.xyz);
            r4.xyz = float3(12.4739304,12.4739304,12.4739304) + r4.xyz;
            r4.xyz = max(float3(0,0,0), float3(0.0606060661,0.0606060661,0.0606060661) * r4.xyz);
            r4.xyz = r5.xyz ? float3(0,0,0) : r4.xyz;
            r5.xyz = r4.xyz * float3(15.1220608,15.1220608,15.1220608) + float3(-38.9015045,-38.9015045,-38.9015045);
            r5.xyz = r4.xyz * r5.xyz + float3(30.3768215,30.3768215,30.3768215);
            r5.xyz = r4.xyz * r5.xyz + float3(-5.92934322,-5.92934322,-5.92934322);
            r5.xyz = r4.xyz * r5.xyz + float3(0.207862496,0.207862496,0.207862496);
            r5.xyz = r4.xyz * r5.xyz + float3(0.124102928,0.124102928,0.124102928);
            r4.xyz = r5.xyz * r4.xyz;
            r2.w = dot(float3(1.19687903,-0.0980208814,-0.0990297422), r4.xyz);
            r2.w = max(0, r2.w);
            r2.w = log2(r2.w);
            r2.w = 2.20000005 * r2.w;
            r2.w = exp2(r2.w);
            r2.y = min(1, r2.w);
            r2.z = -1;
          } else {
            r2.w = cmp(hdr10_parameters2.z == 8.000000);
            if (r2.w != 0) {
              r4.x = dot(float3(0.84247905,0.078433603,0.0792237446), r0.www);
              r4.y = dot(float3(0.0423282422,0.878468633,0.0791661292), r0.www);
              r4.z = dot(float3(0.042375654,0.078433603,0.879143), r0.www);
              r5.xyz = cmp(float3(0,0,0) >= r4.xyz);
              r4.xyz = log2(r4.xyz);
              r4.xyz = float3(12.4739304,12.4739304,12.4739304) + r4.xyz;
              r4.xyz = max(float3(0,0,0), float3(0.0606060661,0.0606060661,0.0606060661) * r4.xyz);
              r4.xyz = r5.xyz ? float3(0,0,0) : r4.xyz;
              r5.xyz = r4.xyz * float3(15.1220608,15.1220608,15.1220608) + float3(-38.9015045,-38.9015045,-38.9015045);
              r5.xyz = r4.xyz * r5.xyz + float3(30.3768215,30.3768215,30.3768215);
              r5.xyz = r4.xyz * r5.xyz + float3(-5.92934322,-5.92934322,-5.92934322);
              r5.xyz = r4.xyz * r5.xyz + float3(0.207862496,0.207862496,0.207862496);
              r5.xyz = r4.xyz * r5.xyz + float3(0.124102928,0.124102928,0.124102928);
              r4.xyz = r5.xyz * r4.xyz;
              r2.w = dot(r4.xyz, float3(0.212639004,0.715168715,0.0721922964));
              r3.z = dot(r4.xyz, float3(0.228974596,0.691738486,0.0792869031));
              r4.w = dot(r4.xyz, float3(0.2627002,0.677998126,0.0593017004));
              r3.z = r3.x ? r3.z : r4.w;
              r2.x = r2.x ? r2.w : r3.z;
              r1.w = r1.w ? r2.x : 0xffc00000;
              r4.xyz = log2(r4.xyz);
              r4.xyz = float3(1.35000002,1.35000002,1.35000002) * r4.xyz;
              r4.xyz = exp2(r4.xyz);
              r4.xyz = r4.xyz + -r1.www;
              r4.xyz = r4.xyz * float3(1.39999998,1.39999998,1.39999998) + r1.www;
              r1.w = dot(float3(1.19687903,-0.0980208814,-0.0990297422), r4.xyz);
              r1.w = max(0, r1.w);
              r1.w = log2(r1.w);
              r1.w = 2.20000005 * r1.w;
              r1.w = exp2(r1.w);
              r2.y = min(1, r1.w);
              r2.z = -1;
            } else {
              r1.w = cmp(hdr10_parameters2.z == 16.000000);
              if (r1.w != 0) {
                r1.w = 4.5454545 * r0.w;
                r2.x = saturate(r1.w);
                r2.w = r2.x * -2 + 3;
                r2.x = r2.x * r2.x;
                r2.x = -r2.w * r2.x + 1;
                r2.w = cmp(r0.w >= 0.532000005);
                r3.z = r2.w ? 1.000000 : 0;
                r4.x = 1 + -r2.x;
                r2.w = r2.w ? -1 : -0;
                r2.w = r4.x + r2.w;
                r1.w = log2(r1.w);
                r1.w = 1.33000004 * r1.w;
                r1.w = exp2(r1.w);
                r1.w = r2.x * r1.w;
                r2.x = -0.532000005 + r0.w;
                r2.x = -3.08268166 * r2.x;
                r2.x = exp2(r2.x);
                r2.x = -r2.x * 0.467999995 + 1;
                r2.w = r2.w * r0.w;
                r1.w = r1.w * 0.219999999 + r2.w;
                r2.y = saturate(r2.x * r3.z + r1.w);
                r2.z = -1;
              } else {
                r1.w = cmp(hdr10_parameters2.z == 32.000000);
                if (r1.w != 0) {
                  r2.xw = r0.ww * float2(10,10) + float2(0.300000012,0.5);
                  r1.w = r2.x * r0.w;
                  r2.x = r0.w * r2.w + 1.5;
                  r2.y = saturate(r1.w / r2.x);
                  r2.z = -1;
                } else {
                  r1.w = r0.w + r0.w;
                  r4.xyzw = r0.wwww * float4(0.300000012,0.300000012,0.25,0.111111112) + float4(0.0500000007,0.5,1,1);
                  r2.xw = r1.ww * r4.xy + float2(0.00400000019,0.0600000024);
                  r1.w = r2.x / r2.w;
                  r1.w = -0.0666666627 + r1.w;
                  r1.w = saturate(0.725129366 * r1.w);
                  r2.xw = r4.zw * r0.ww;
                  r3.z = 1 + r0.w;
                  r2.xw = saturate(r2.xw / r3.zz);
                  r4.xyz = cmp(hdr10_parameters2.zzz == float3(64,128,256));
                  r2.x = r4.y ? r2.x : r2.w;
                  r2.w = (int)r4.z | (int)r4.y;
                  r2.y = r4.x ? r1.w : r2.x;
                  r2.z = (int)r2.w | (int)r4.x;
                }
              }
            }
          }
        }
      }
      r1.w = saturate(r0.w);
      r1.w = r2.z ? r2.y : r1.w;
      r0.w = 9.99999975e-06 + r0.w;
      r0.w = r1.w / r0.w;
      r1.xyz = r1.xyz * r0.www;
    } else {
      r0.w = cmp(hdr10_parameters2.w == 1.000000);
      if (r0.w != 0) {
        r0.w = cmp(hdr10_parameters2.z == 1.000000);
        if (r0.w != 0) {
          r2.xyz = r1.xyz * float3(2.50999999,2.50999999,2.50999999) + float3(0.0299999993,0.0299999993,0.0299999993);
          r2.xyz = r2.xyz * r1.xyz;
          r4.xyz = r1.xyz * float3(2.43000007,2.43000007,2.43000007) + float3(0.589999974,0.589999974,0.589999974);
          r4.xyz = r1.xyz * r4.xyz + float3(0.140000001,0.140000001,0.140000001);
          r2.xyz = saturate(r2.xyz / r4.xyz);
          r0.w = -1;
        } else {
          r1.w = cmp(hdr10_parameters2.z == 2.000000);
          if (r1.w != 0) {
            r4.x = dot(float3(0.597190022,0.354579985,0.0482299998), r1.xyz);
            r4.y = dot(float3(0.0759999976,0.908339977,0.0156599991), r1.xyz);
            r4.z = dot(float3(0.0284000002,0.133829996,0.837769985), r1.xyz);
            r5.xyz = float3(0.0245785993,0.0245785993,0.0245785993) + r4.xyz;
            r5.xyz = r4.xyz * r5.xyz + float3(-9.05370034e-05,-9.05370034e-05,-9.05370034e-05);
            r6.xyz = r4.xyz * float3(0.983729005,0.983729005,0.983729005) + float3(0.432951003,0.432951003,0.432951003);
            r4.xyz = r4.xyz * r6.xyz + float3(0.238080993,0.238080993,0.238080993);
            r4.xyz = r5.xyz / r4.xyz;
            r2.x = saturate(dot(float3(1.60475004,-0.531080008,-0.0736699998), r4.xyz));
            r2.y = saturate(dot(float3(-0.102080002,1.10812998,-0.00604999997), r4.xyz));
            r2.z = saturate(dot(float3(-0.00326999999,-0.0727600008,1.07602), r4.xyz));
            r0.w = -1;
          } else {
            r1.w = cmp(hdr10_parameters2.z == 4.000000);
            if (r1.w != 0) {
              r4.x = dot(float3(0.84247905,0.078433603,0.0792237446), r1.xyz);
              r4.y = dot(float3(0.0423282422,0.878468633,0.0791661292), r1.xyz);
              r4.z = dot(float3(0.042375654,0.078433603,0.879143), r1.xyz);
              r5.xyz = cmp(float3(0,0,0) >= r4.xyz);
              r4.xyz = log2(r4.xyz);
              r4.xyz = float3(12.4739304,12.4739304,12.4739304) + r4.xyz;
              r4.xyz = saturate(float3(0.0606060661,0.0606060661,0.0606060661) * r4.xyz);
              r4.xyz = r5.xyz ? float3(0,0,0) : r4.xyz;
              r5.xyz = r4.xyz * float3(15.1220608,15.1220608,15.1220608) + float3(-38.9015045,-38.9015045,-38.9015045);
              r5.xyz = r4.xyz * r5.xyz + float3(30.3768215,30.3768215,30.3768215);
              r5.xyz = r4.xyz * r5.xyz + float3(-5.92934322,-5.92934322,-5.92934322);
              r5.xyz = r4.xyz * r5.xyz + float3(0.207862496,0.207862496,0.207862496);
              r5.xyz = r4.xyz * r5.xyz + float3(0.124102928,0.124102928,0.124102928);
              r4.xyz = r5.xyz * r4.xyz;
              r5.x = dot(float3(1.19687903,-0.0980208814,-0.0990297422), r4.xyz);
              r5.y = dot(float3(-0.0528968535,1.15190315,-0.0989611745), r4.xyz);
              r5.z = dot(float3(-0.052971635,-0.0980434492,1.15107369), r4.xyz);
              r4.xyz = max(float3(0,0,0), r5.xyz);
              r4.xyz = log2(r4.xyz);
              r4.xyz = float3(2.20000005,2.20000005,2.20000005) * r4.xyz;
              r4.xyz = exp2(r4.xyz);
              r2.xyz = min(float3(1,1,1), r4.xyz);
              r0.w = -1;
            } else {
              r1.w = cmp(hdr10_parameters2.z == 8.000000);
              if (r1.w != 0) {
                r4.x = dot(float3(0.84247905,0.078433603,0.0792237446), r1.xyz);
                r4.y = dot(float3(0.0423282422,0.878468633,0.0791661292), r1.xyz);
                r4.z = dot(float3(0.042375654,0.078433603,0.879143), r1.xyz);
                r5.xyz = cmp(float3(0,0,0) >= r4.xyz);
                r4.xyz = log2(r4.xyz);
                r4.xyz = float3(12.4739304,12.4739304,12.4739304) + r4.xyz;
                r4.xyz = saturate(float3(0.0606060661,0.0606060661,0.0606060661) * r4.xyz);
                r4.xyz = r5.xyz ? float3(0,0,0) : r4.xyz;
                r5.xyz = r4.xyz * float3(15.1220608,15.1220608,15.1220608) + float3(-38.9015045,-38.9015045,-38.9015045);
                r5.xyz = r4.xyz * r5.xyz + float3(30.3768215,30.3768215,30.3768215);
                r5.xyz = r4.xyz * r5.xyz + float3(-5.92934322,-5.92934322,-5.92934322);
                r5.xyz = r4.xyz * r5.xyz + float3(0.207862496,0.207862496,0.207862496);
                r5.xyz = r4.xyz * r5.xyz + float3(0.124102928,0.124102928,0.124102928);
                r4.xyz = r5.xyz * r4.xyz;
                r1.w = cmp(hdr10_parameters2.x == 0.000000);
                r2.w = dot(r4.xyz, float3(0.212639004,0.715168715,0.0721922964));
                r3.z = dot(r4.xyz, float3(0.228974596,0.691738486,0.0792869031));
                r4.w = dot(r4.xyz, float3(0.2627002,0.677998126,0.0593017004));
                r3.z = r3.x ? r3.z : r4.w;
                r2.w = r1.w ? r2.w : r3.z;
                r1.w = (int)r3.y | (int)r1.w;
                r1.w = r1.w ? r2.w : 0xffc00000;
                r4.xyz = log2(r4.xyz);
                r4.xyz = float3(1.35000002,1.35000002,1.35000002) * r4.xyz;
                r4.xyz = exp2(r4.xyz);
                r4.xyz = r4.xyz + -r1.www;
                r4.xyz = r4.xyz * float3(1.39999998,1.39999998,1.39999998) + r1.www;
                r5.x = dot(float3(1.19687903,-0.0980208814,-0.0990297422), r4.xyz);
                r5.y = dot(float3(-0.0528968535,1.15190315,-0.0989611745), r4.xyz);
                r5.z = dot(float3(-0.052971635,-0.0980434492,1.15107369), r4.xyz);
                r4.xyz = max(float3(0,0,0), r5.xyz);
                r4.xyz = log2(r4.xyz);
                r4.xyz = float3(2.20000005,2.20000005,2.20000005) * r4.xyz;
                r4.xyz = exp2(r4.xyz);
                r2.xyz = min(float3(1,1,1), r4.xyz);
                r0.w = -1;
              } else {
                r1.w = cmp(hdr10_parameters2.z == 16.000000);
                if (r1.w != 0) {
                  r4.xyz = float3(4.5454545,4.5454545,4.5454545) * r1.xyz;
                  r5.xyz = max(float3(0,0,0), r4.xyz);
                  r6.xyz = r5.xyz * float3(-2,-2,-2) + float3(3,3,3);
                  r5.xyz = r5.xyz * r5.xyz;
                  r5.xyz = -r6.xyz * r5.xyz + float3(1,1,1);
                  r6.xyz = cmp(r1.xyz >= float3(0.532000005,0.532000005,0.532000005));
                  r7.xyz = r6.xyz ? float3(1,1,1) : 0;
                  r8.xyz = float3(1,1,1) + -r5.xyz;
                  r6.xyz = r6.xyz ? float3(-1,-1,-1) : float3(-0,-0,-0);
                  r6.xyz = r8.xyz + r6.xyz;
                  r4.xyz = log2(r4.xyz);
                  r4.xyz = float3(1.33000004,1.33000004,1.33000004) * r4.xyz;
                  r4.xyz = exp2(r4.xyz);
                  r4.xyz = r5.xyz * r4.xyz;
                  r5.xyz = float3(-0.532000005,-0.532000005,-0.532000005) + r1.xyz;
                  r5.xyz = float3(-3.08268166,-3.08268166,-3.08268166) * r5.xyz;
                  r5.xyz = exp2(r5.xyz);
                  r5.xyz = -r5.xyz * float3(0.467999995,0.467999995,0.467999995) + float3(1,1,1);
                  r6.xyz = r6.xyz * r1.xyz;
                  r4.xyz = r4.xyz * float3(0.219999999,0.219999999,0.219999999) + r6.xyz;
                  r2.xyz = max(float3(0,0,0), r5.xyz * r7.xyz + r4.xyz);
                  r0.w = -1;
                } else {
                  r1.w = cmp(hdr10_parameters2.z == 32.000000);
                  if (r1.w != 0) {
                    r4.xyz = r1.xyz * float3(10,10,10) + float3(0.300000012,0.300000012,0.300000012);
                    r4.xyz = r4.xyz * r1.xyz;
                    r5.xyz = r1.xyz * float3(10,10,10) + float3(0.5,0.5,0.5);
                    r5.xyz = r1.xyz * r5.xyz + float3(1.5,1.5,1.5);
                    r2.xyz = max(float3(0,0,0), r4.xyz / r5.xyz);
                    r0.w = -1;
                  } else {
                    r4.xyz = r1.xyz + r1.xyz;
                    r5.xyz = r1.xyz * float3(0.300000012,0.300000012,0.300000012) + float3(0.0500000007,0.0500000007,0.0500000007);
                    r5.xyz = r4.xyz * r5.xyz + float3(0.00400000019,0.00400000019,0.00400000019);
                    r6.xyz = r1.xyz * float3(0.300000012,0.300000012,0.300000012) + float3(0.5,0.5,0.5);
                    r4.xyz = r4.xyz * r6.xyz + float3(0.0600000024,0.0600000024,0.0600000024);
                    r4.xyz = r5.xyz / r4.xyz;
                    r4.xyz = float3(-0.0666666627,-0.0666666627,-0.0666666627) + r4.xyz;
                    r4.xyz = max(float3(0,0,0), float3(0.725129366,0.725129366,0.725129366) * r4.xyz);
                    r5.xyz = r1.xyz * float3(0.25,0.25,0.25) + float3(1,1,1);
                    r5.xyz = r5.xyz * r1.xyz;
                    r6.xyz = float3(1,1,1) + r1.xyz;
                    r5.xyz = max(float3(0,0,0), r5.xyz / r6.xyz);
                    r7.xyz = cmp(hdr10_parameters2.zzz == float3(64,128,256));
                    r8.xyz = r1.xyz * float3(0.111111112,0.111111112,0.111111112) + float3(1,1,1);
                    r8.xyz = r8.xyz * r1.xyz;
                    r6.xyz = max(float3(0,0,0), r8.xyz / r6.xyz);
                    r5.xyz = r7.yyy ? r5.xyz : r6.xyz;
                    r1.w = (int)r7.z | (int)r7.y;
                    r2.xyz = r7.xxx ? r4.xyz : r5.xyz;
                    r0.w = (int)r1.w | (int)r7.x;
                  }
                }
              }
            }
          }
        }
  r1.xyz = max(float3(0,0,0), r1.xyz);
        r1.xyz = r0.www ? r2.xyz : r1.xyz;
      }
    }
    r2.x = dot(float3(0.753833055,0.198597372,0.047569599), r1.xyz);
    r2.y = dot(float3(0.0457438491,0.941777229,0.0124789299), r1.xyz);
    r2.z = dot(float3(-0.00121033995,0.0176017191,0.983608603), r1.xyz);
    r4.x = dot(float3(0.627403915,0.329283029,0.0433130711), r1.xyz);
    r4.y = dot(float3(0.069097288,0.919540405,0.0113623198), r1.xyz);
    r4.z = dot(float3(0.0163914394,0.0880133137,0.895595253), r1.xyz);
    r2.xyz = r3.xxx ? r2.xyz : r4.xyz;
    r1.xyz = r3.www ? r2.xyz : r1.xyz;
    r1.xyz = hdr10_parameters1.xxx * r1.xyz;
    r1.xyz = float3(9.99999975e-05,9.99999975e-05,9.99999975e-05) * r1.xyz;
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(0.159301758,0.159301758,0.159301758) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r2.xyz = r1.xyz * float3(18.8515625,18.8515625,18.8515625) + float3(0.8359375,0.8359375,0.8359375);
    r1.xyz = r1.xyz * float3(18.6875,18.6875,18.6875) + float3(1,1,1);
    r1.xyz = r2.xyz / r1.xyz;
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(78.84375,78.84375,78.84375) * r1.xyz;
    r0.xyz = exp2(r1.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}