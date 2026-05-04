#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Mon Mar  9 16:15:12 2026
Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[7];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(1,1) / cb0[6].xy;
  r0.zw = -r0.xy * float2(2,2) + float2(1,1);
  r0.xy = v0.xy * r0.zw + r0.xy;
  r0.zw = r0.xy * cb0[6].xy + float2(-0.5,-0.5);
  r1.xy = (int2)r0.zw;
  r2.xy = trunc(r0.zw);
  r0.zw = -r2.xy + r0.zw;
  r2.xyzw = -r0.zzzz * float4(0.5,0.5,0.5,0.5) + float4(-0.5,0,0.5,1);
  r2.xyzw = r2.xyzw * r2.xyzw;
  r2.xyzw = min(float4(1,1,1,1), r2.xyzw);
  r3.xyzw = r2.xyzw * float4(4,4,4,4) + float4(-5,-5,-5,-5);
  r3.xyzw = r3.xyzw * r2.xyzw + float4(1,1,1,1);
  r2.xyzw = r2.xyzw * float4(0.736577213,0.736577213,0.736577213,0.736577213) + float4(-1,-1,-1,-1);
  r2.xyzw = r2.xyzw * r2.xyzw;
  r2.xyzw = r2.xyzw * r2.xyzw;
  r2.xyzw = r2.xyzw * r3.xyzw;
  r3.xyzw = -r0.wwww * float4(0.5,0.5,0.5,0.5) + float4(-0.5,0,0.5,1);
  r3.xyzw = r3.xyzw * r3.xyzw;
  r3.xyzw = min(float4(1,1,1,1), r3.xyzw);
  r4.xyzw = r3.xyzw * float4(4,4,4,4) + float4(-5,-5,-5,-5);
  r4.xyzw = r4.xyzw * r3.xyzw + float4(1,1,1,1);
  r3.xyzw = r3.xyzw * float4(0.736577213,0.736577213,0.736577213,0.736577213) + float4(-1,-1,-1,-1);
  r3.xyzw = r3.xyzw * r3.xyzw;
  r3.xyzw = r3.xyzw * r3.xyzw;
  r3.xyzw = r3.xyzw * r4.xyzw;
  r4.xyzw = r3.xyzw * r2.xxxx;
  r1.zw = float2(0,0);
  r5.xyz = t1.Load(r1.xyw, int3(-1, -1, 0)).xyz;
  r6.xyz = t1.Load(r1.xyw, int3(-1, 0, 0)).xyz;
  r6.xyz = r6.xyz * r4.yyy;
  r5.xyz = r5.xyz * r4.xxx + r6.xyz;
  r0.z = r4.x + r4.y;
  r6.xyz = t1.Load(r1.xyw, int3(-1, 1, 0)).xyz;
  r4.xyz = r6.xyz * r4.zzz + r5.xyz;
  r0.z = r2.x * r3.z + r0.z;
  r5.xyz = t1.Load(r1.xyw, int3(-1, 2, 0)).xyz;
  r4.xyz = r5.xyz * r4.www + r4.xyz;
  r0.z = r2.x * r3.w + r0.z;
  r5.xyzw = r3.xyzw * r2.yyyy;
  r6.xyz = t1.Load(r1.xyw, int3(0, -1, 0)).xyz;
  r4.xyz = r6.xyz * r5.xxx + r4.xyz;
  r0.z = r2.y * r3.x + r0.z;
  r6.xyz = t1.Load(r1.xyw, int3(0, 0, 0)).xyz;
  r4.xyz = r6.xyz * r5.yyy + r4.xyz;
  r0.z = r2.y * r3.y + r0.z;
  r6.xyz = t1.Load(r1.xyw, int3(0, 1, 0)).xyz;
  r4.xyz = r6.xyz * r5.zzz + r4.xyz;
  r0.z = r2.y * r3.z + r0.z;
  r5.xyz = t1.Load(r1.xyw, int3(0, 2, 0)).xyz;
  r4.xyz = r5.xyz * r5.www + r4.xyz;
  r0.z = r2.y * r3.w + r0.z;
  r5.xyzw = r3.xyzw * r2.zzzz;
  r6.xyz = t1.Load(r1.xyw, int3(1, -1, 0)).xyz;
  r4.xyz = r6.xyz * r5.xxx + r4.xyz;
  r0.z = r2.z * r3.x + r0.z;
  r6.xyz = t1.Load(r1.xyw, int3(1, 0, 0)).xyz;
  r4.xyz = r6.xyz * r5.yyy + r4.xyz;
  r0.z = r2.z * r3.y + r0.z;
  r6.xyz = t1.Load(r1.xyw, int3(1, 1, 0)).xyz;
  r4.xyz = r6.xyz * r5.zzz + r4.xyz;
  r0.z = r2.z * r3.z + r0.z;
  r5.xyz = t1.Load(r1.xyw, int3(1, 2, 0)).xyz;
  r4.xyz = r5.xyz * r5.www + r4.xyz;
  r0.z = r2.z * r3.w + r0.z;
  r5.xyzw = r3.xyzw * r2.wwww;
  r2.xyz = t1.Load(r1.xyw, int3(2, -1, 0)).xyz;
  r2.xyz = r2.xyz * r5.xxx + r4.xyz;
  r0.z = r2.w * r3.x + r0.z;
  r4.xyz = t1.Load(r1.xyw, int3(2, 0, 0)).xyz;
  r2.xyz = r4.xyz * r5.yyy + r2.xyz;
  r0.z = r2.w * r3.y + r0.z;
  r4.xyz = t1.Load(r1.xyw, int3(2, 1, 0)).xyz;
  r2.xyz = r4.xyz * r5.zzz + r2.xyz;
  r0.z = r2.w * r3.z + r0.z;
  r1.xyz = t1.Load(r1.xyz, int3(2, 2, 0)).xyz;
  r1.xyz = r1.xyz * r5.www + r2.xyz;
  r0.z = r2.w * r3.w + r0.z;
  r1.xyz = r1.yzx / r0.zzz;
  if (cb0[5].z != 0) {
    r0.zw = cb0[6].xy * v0.xy;
    r0.zw = cb0[6].zw * r0.zw;
    r2.xyz = t2.SampleLevel(s0_s, r0.zw, 0).xyz;
    r3.xyz = -r2.xyz + r1.zxy;
    r1.xyz = r3.yzx * float3(0.25,0.25,0.25) + r2.yzx;
  }
  r0.zw = r1.yx * float2(2,2) + float2(-1,-1);
  r2.yz = r1.zz + r0.wz;
  r2.x = r2.y + -r0.z;
  r0.w = r1.z + -r0.w;
  r2.w = r0.w + -r0.z;

  if (RENODX_TONE_MAP_TYPE > 1) {
    // Reconstructed RGB is in r2.xzw here; invert max-channel Reinhard before downstream shaping.
    r1.x = max(r2.x, r2.z);
    r1.x = max(r1.x, r2.w);
    r1.x = rcp(max(1.0f - r1.x, 1e-5f));
    r2.x = r2.x * r1.x;
    r2.z = r2.z * r1.x;
    r2.w = r2.w * r1.x;
  }

  r1.xy = (int2)v1.xy;
  r0.zw = float2(-0.5,-0.5) + r0.xy;
  r0.z = dot(r0.zw, r0.zw);
  r0.z = 0.5 + -r0.z;
  r0.z = -cb0[3].x * r0.z;
  r0.z = exp2(r0.z);
  r0.z = saturate(cb0[3].y * r0.z);
  r2.xyz = r2.xzw * r2.xzw;
  r0.w = -r0.z * cb0[2].w + cb0[2].w;
  r0.w = cb0[5].x * r0.w;
  r0.z = r0.z * r0.z;
  r0.z = cb0[2].w * r0.z;
  r2.xyz = r2.xyz * r0.www + cb0[2].xyz;
  r2.xyz = cb0[4].xyz * r0.zzz + r2.xyz;
  r0.xy = cb0[0].xy + r0.xy;
  r0.x = r0.y * 543.309998 + r0.x;
  r0.x = sin(r0.x);
  r0.x = 493013 * r0.x;
  r0.x = frac(r0.x);
  r0.x = r0.x * cb0[1].x + cb0[1].y;
  float3 scene_pre_ui = r2.xyz * r0.xxx;
  r1.zw = float2(0,0);
  r1.xyzw = t0.Load(r1.xyz).xyzw;
  float4 ui_color = r1.xyzw;

  if (RENODX_TONE_MAP_TYPE > 1) {
    float4 final_linear;
    HandleUICompositing(ui_color, scene_pre_ui, final_linear, v0.xy);
    o0 = final_linear;
    return;
  }

  if (RENODX_TONE_MAP_TYPE == 1) {
    float3 final_linear = ui_color.rgb + scene_pre_ui * (1 - ui_color.a);
    o0.xyz = renodx::color::pq::Encode(final_linear, RENODX_DIFFUSE_WHITE_NITS);
    o0.w = 1;
    return;
  }

  r1.xyz = cb0[5].yyy * ui_color.xyz;
  r0.w = 1 + -ui_color.w;
  r0.xyz = scene_pre_ui * r0.www + r1.xyz;
  r1.xyz = float3(-40.9599991,-40.9599991,-40.9599991) * r0.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = float3(-1,-1,-1) + r1.xyz;
  r1.xyz = float3(0.000449999992,0.000449999992,0.000449999992) * r1.xyz;
  r0.xyz = r0.xyz * float3(0.0199999996,0.0199999996,0.0199999996) + r1.xyz;
  r0.xyz = log2(abs(r0.xyz));
  r0.xyz = float3(0.159301758,0.159301758,0.159301758) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xyz = r0.xyz * float3(18.8515625,18.8515625,18.8515625) + float3(0.8359375,0.8359375,0.8359375);
  r0.xyz = r0.xyz * float3(18.6875,18.6875,18.6875) + float3(1,1,1);
  r0.xyz = r1.xyz / r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(78.84375,78.84375,78.84375) * r0.xyz;
  o0.xyz = exp2(r0.xyz);
  o0.w = 0;
  return;
}

// //
// // Generated by Microsoft (R) D3D Shader Disassembler
// //
// //
// // Input signature:
// //
// // Name                 Index   Mask Register SysValue  Format   Used
// // -------------------- ----- ------ -------- -------- ------- ------
// // TEXCOORD                 0   xy          0     NONE   float   xy
// // SV_POSITION              0   xyzw        1      POS   float   xy
// //
// //
// // Output signature:
// //
// // Name                 Index   Mask Register SysValue  Format   Used
// // -------------------- ----- ------ -------- -------- ------- ------
// // SV_Target                0   xyzw        0   TARGET   float   xyzw
// //
// 0x00000000 : ps_5_0
//       0x00000008 : dcl_globalFlags refactoringAllowed
//       0x0000000C : dcl_constantbuffer CB0[7], immediateIndexed
//       0x0000001C : dcl_sampler s0, mode_default
//       0x00000028 : dcl_resource_texture2d(float, float, float, float) t0
//       0x00000038 : dcl_resource_texture2d(float, float, float, float) t1
//       0x00000048 : dcl_resource_texture2d(float, float, float, float) t2
//       0x00000058 : dcl_input_ps linear v0.xy
//       0x00000064 : dcl_input_ps_siv linear noperspective v1.xy, position
//       0x00000074 : dcl_output o0.xyzw
//       0x00000080 : dcl_temps 7
//    0 0x00000088 : div r0.xy, l(1.000000, 1.000000, 1.000000, 1.000000), cb0[6].xyxx
//    1 0x000000B4 : mad r0.zw, -r0.xxxy, l(0.000000, 0.000000, 2.000000, 2.000000), l(0.000000, 0.000000, 1.000000, 1.000000)
//    2 0x000000F4 : mad r0.xy, v0.xyxx, r0.zwzz, r0.xyxx
//    3 0x00000118 : mad r0.zw, r0.xxxy, cb0[6].xxxy, l(0.000000, 0.000000, -0.500000, -0.500000)
//    4 0x0000014C : ftoi r1.xy, r0.zwzz
//    5 0x00000160 : round_z r2.xy, r0.zwzz
//    6 0x00000174 : add r0.zw, r0.zzzw, -r2.xxxy
//    7 0x00000194 : mad r2.xyzw, -r0.zzzz, l(0.500000, 0.500000, 0.500000, 0.500000), l(-0.500000, 0.000000, 0.500000, 1.000000)
//    8 0x000001D4 : mul r2.xyzw, r2.xyzw, r2.xyzw
//    9 0x000001F0 : min r2.xyzw, r2.xyzw, l(1.000000, 1.000000, 1.000000, 1.000000)
//   10 0x00000218 : mad r3.xyzw, r2.xyzw, l(4.000000, 4.000000, 4.000000, 4.000000), l(-5.000000, -5.000000, -5.000000, -5.000000)
//   11 0x00000254 : mad r3.xyzw, r3.xyzw, r2.xyzw, l(1.000000, 1.000000, 1.000000, 1.000000)
//   12 0x00000284 : mad r2.xyzw, r2.xyzw, l(0.736577, 0.736577, 0.736577, 0.736577), l(-1.000000, -1.000000, -1.000000, -1.000000)
//   13 0x000002C0 : mul r2.xyzw, r2.xyzw, r2.xyzw
//   14 0x000002DC : mul r2.xyzw, r2.xyzw, r2.xyzw
//   15 0x000002F8 : mul r2.xyzw, r3.xyzw, r2.xyzw
//   16 0x00000314 : mad r3.xyzw, -r0.wwww, l(0.500000, 0.500000, 0.500000, 0.500000), l(-0.500000, 0.000000, 0.500000, 1.000000)
//   17 0x00000354 : mul r3.xyzw, r3.xyzw, r3.xyzw
//   18 0x00000370 : min r3.xyzw, r3.xyzw, l(1.000000, 1.000000, 1.000000, 1.000000)
//   19 0x00000398 : mad r4.xyzw, r3.xyzw, l(4.000000, 4.000000, 4.000000, 4.000000), l(-5.000000, -5.000000, -5.000000, -5.000000)
//   20 0x000003D4 : mad r4.xyzw, r4.xyzw, r3.xyzw, l(1.000000, 1.000000, 1.000000, 1.000000)
//   21 0x00000404 : mad r3.xyzw, r3.xyzw, l(0.736577, 0.736577, 0.736577, 0.736577), l(-1.000000, -1.000000, -1.000000, -1.000000)
//   22 0x00000440 : mul r3.xyzw, r3.xyzw, r3.xyzw
//   23 0x0000045C : mul r3.xyzw, r3.xyzw, r3.xyzw
//   24 0x00000478 : mul r3.xyzw, r4.xyzw, r3.xyzw
//   25 0x00000494 : mul r4.xyzw, r2.xxxx, r3.xyzw
//   26 0x000004B0 : mov r1.zw, l(0, 0, 0, 0)
//   27 0x000004D0 : ld_aoffimmi_indexable(-1, -1, 0)(texture2d)(float, float, float, float)r5.xyz, r1.xyww, t1.xyzw
//   28 0x000004F8 : ld_aoffimmi_indexable(-1, 0, 0)(texture2d)(float, float, float, float)r6.xyz, r1.xyww, t1.xyzw
//   29 0x00000520 : mul r6.xyz, r4.yyyy, r6.xyzx
//   30 0x0000053C : mad r5.xyz, r5.xyzx, r4.xxxx, r6.xyzx
//   31 0x00000560 : add r0.z, r4.y, r4.x
//   32 0x0000057C : ld_aoffimmi_indexable(-1, 1, 0)(texture2d)(float, float, float, float)r6.xyz, r1.xyww, t1.xyzw
//   33 0x000005A4 : mad r4.xyz, r6.xyzx, r4.zzzz, r5.xyzx
//   34 0x000005C8 : mad r0.z, r2.x, r3.z, r0.z
//   35 0x000005EC : ld_aoffimmi_indexable(-1, 2, 0)(texture2d)(float, float, float, float)r5.xyz, r1.xyww, t1.xyzw
//   36 0x00000614 : mad r4.xyz, r5.xyzx, r4.wwww, r4.xyzx
//   37 0x00000638 : mad r0.z, r2.x, r3.w, r0.z
//   38 0x0000065C : mul r5.xyzw, r2.yyyy, r3.xyzw
//   39 0x00000678 : ld_aoffimmi_indexable(0, -1, 0)(texture2d)(float, float, float, float)r6.xyz, r1.xyww, t1.xyzw
//   40 0x000006A0 : mad r4.xyz, r6.xyzx, r5.xxxx, r4.xyzx
//   41 0x000006C4 : mad r0.z, r2.y, r3.x, r0.z
//   42 0x000006E8 : ld_aoffimmi_indexable(0, 0, 0)(texture2d)(float, float, float, float)r6.xyz, r1.xyww, t1.xyzw
//   43 0x00000710 : mad r4.xyz, r6.xyzx, r5.yyyy, r4.xyzx
//   44 0x00000734 : mad r0.z, r2.y, r3.y, r0.z
//   45 0x00000758 : ld_aoffimmi_indexable(0, 1, 0)(texture2d)(float, float, float, float)r6.xyz, r1.xyww, t1.xyzw
//   46 0x00000780 : mad r4.xyz, r6.xyzx, r5.zzzz, r4.xyzx
//   47 0x000007A4 : mad r0.z, r2.y, r3.z, r0.z
//   48 0x000007C8 : ld_aoffimmi_indexable(0, 2, 0)(texture2d)(float, float, float, float)r5.xyz, r1.xyww, t1.xyzw
//   49 0x000007F0 : mad r4.xyz, r5.xyzx, r5.wwww, r4.xyzx
//   50 0x00000814 : mad r0.z, r2.y, r3.w, r0.z
//   51 0x00000838 : mul r5.xyzw, r2.zzzz, r3.xyzw
//   52 0x00000854 : ld_aoffimmi_indexable(1, -1, 0)(texture2d)(float, float, float, float)r6.xyz, r1.xyww, t1.xyzw
//   53 0x0000087C : mad r4.xyz, r6.xyzx, r5.xxxx, r4.xyzx
//   54 0x000008A0 : mad r0.z, r2.z, r3.x, r0.z
//   55 0x000008C4 : ld_aoffimmi_indexable(1, 0, 0)(texture2d)(float, float, float, float)r6.xyz, r1.xyww, t1.xyzw
//   56 0x000008EC : mad r4.xyz, r6.xyzx, r5.yyyy, r4.xyzx
//   57 0x00000910 : mad r0.z, r2.z, r3.y, r0.z
//   58 0x00000934 : ld_aoffimmi_indexable(1, 1, 0)(texture2d)(float, float, float, float)r6.xyz, r1.xyww, t1.xyzw
//   59 0x0000095C : mad r4.xyz, r6.xyzx, r5.zzzz, r4.xyzx
//   60 0x00000980 : mad r0.z, r2.z, r3.z, r0.z
//   61 0x000009A4 : ld_aoffimmi_indexable(1, 2, 0)(texture2d)(float, float, float, float)r5.xyz, r1.xyww, t1.xyzw
//   62 0x000009CC : mad r4.xyz, r5.xyzx, r5.wwww, r4.xyzx
//   63 0x000009F0 : mad r0.z, r2.z, r3.w, r0.z
//   64 0x00000A14 : mul r5.xyzw, r2.wwww, r3.xyzw
//   65 0x00000A30 : ld_aoffimmi_indexable(2, -1, 0)(texture2d)(float, float, float, float)r2.xyz, r1.xyww, t1.xyzw
//   66 0x00000A58 : mad r2.xyz, r2.xyzx, r5.xxxx, r4.xyzx
//   67 0x00000A7C : mad r0.z, r2.w, r3.x, r0.z
//   68 0x00000AA0 : ld_aoffimmi_indexable(2, 0, 0)(texture2d)(float, float, float, float)r4.xyz, r1.xyww, t1.xyzw
//   69 0x00000AC8 : mad r2.xyz, r4.xyzx, r5.yyyy, r2.xyzx
//   70 0x00000AEC : mad r0.z, r2.w, r3.y, r0.z
//   71 0x00000B10 : ld_aoffimmi_indexable(2, 1, 0)(texture2d)(float, float, float, float)r4.xyz, r1.xyww, t1.xyzw
//   72 0x00000B38 : mad r2.xyz, r4.xyzx, r5.zzzz, r2.xyzx
//   73 0x00000B5C : mad r0.z, r2.w, r3.z, r0.z
//   74 0x00000B80 : ld_aoffimmi_indexable(2, 2, 0)(texture2d)(float, float, float, float)r1.xyz, r1.xyzw, t1.xyzw
//   75 0x00000BA8 : mad r1.xyz, r1.xyzx, r5.wwww, r2.xyzx
//   76 0x00000BCC : mad r0.z, r2.w, r3.w, r0.z
//   77 0x00000BF0 : div r1.xyz, r1.yzxy, r0.zzzz
//   78 0x00000C0C : if_nz cb0[5].z
//   79 0x00000C1C : mul r0.zw, v0.xxxy, cb0[6].xxxy
//   80 0x00000C3C : mul r0.zw, r0.zzzw, cb0[6].zzzw
//   81 0x00000C5C : sample_l_indexable(texture2d)(float, float, float, float) r2.xyz, r0.zwzz, t2.xyzw, s0, l(0.000000)
//   82 0x00000C90 : add r3.xyz, r1.zxyz, -r2.xyzx
//   83 0x00000CB0 : mad r1.xyz, r3.yzxy, l(0.250000, 0.250000, 0.250000, 0.000000), r2.yzxy
//   84 0x00000CE0 : endif 
//   85 0x00000CE4 : mad r0.zw, r1.yyyx, l(0.000000, 0.000000, 2.000000, 2.000000), l(0.000000, 0.000000, -1.000000, -1.000000)
//   86 0x00000D20 : add r2.yz, r0.wwzw, r1.zzzz
//   87 0x00000D3C : add r2.x, -r0.z, r2.y
//   88 0x00000D5C : add r0.w, -r0.w, r1.z
//   89 0x00000D7C : add r2.w, -r0.z, r0.w
//   90 0x00000D9C : ftoi r1.xy, v1.xyxx
//   91 0x00000DB0 : add r0.zw, r0.xxxy, l(0.000000, 0.000000, -0.500000, -0.500000)
//   92 0x00000DD8 : dp2 r0.z, r0.zwzz, r0.zwzz
//   93 0x00000DF4 : add r0.z, -r0.z, l(0.500000)
//   94 0x00000E14 : mul r0.z, r0.z, -cb0[3].x
//   95 0x00000E38 : exp r0.z, r0.z
//   96 0x00000E4C : mul_sat r0.z, r0.z, cb0[3].y
//   97 0x00000E6C : mul r2.xyz, r2.xzwx, r2.xzwx
//   98 0x00000E88 : mad r0.w, -r0.z, cb0[2].w, cb0[2].w
//   99 0x00000EB8 : mul r0.w, r0.w, cb0[5].x
//  100 0x00000ED8 : mul r0.z, r0.z, r0.z
//  101 0x00000EF4 : mul r0.z, r0.z, cb0[2].w
//  102 0x00000F14 : mad r2.xyz, r2.xyzx, r0.wwww, cb0[2].xyzx
//  103 0x00000F3C : mad r2.xyz, cb0[4].xyzx, r0.zzzz, r2.xyzx
//  104 0x00000F64 : add r0.xy, r0.xyxx, cb0[0].xyxx
//  105 0x00000F84 : mad r0.x, r0.y, l(543.309998), r0.x
//  106 0x00000FA8 : sincos r0.x, null, r0.x
//  107 0x00000FC0 : mul r0.x, r0.x, l(493013.000000)
//  108 0x00000FDC : frc r0.x, r0.x
//  109 0x00000FF0 : mad r0.x, r0.x, cb0[1].x, cb0[1].y
//  110 0x0000101C : mul r0.xyz, r0.xxxx, r2.xyzx
//  111 0x00001038 : mov r1.zw, l(0, 0, 0, 0)
//  112 0x00001058 : ld_indexable(texture2d)(float, float, float, float) r1.xyzw, r1.xyzw, t0.xyzw
//  113 0x0000107C : mul r1.xyz, r1.xyzx, cb0[5].yyyy
//  114 0x0000109C : add r0.w, -r1.w, l(1.000000)
//  115 0x000010BC : mad r0.xyz, r0.xyzx, r0.wwww, r1.xyzx
//  116 0x000010E0 : mul r1.xyz, r0.xyzx, l(-40.959999, -40.959999, -40.959999, 0.000000)
//  117 0x00001108 : exp r1.xyz, r1.xyzx
//  118 0x0000111C : add r1.xyz, r1.xyzx, l(-1.000000, -1.000000, -1.000000, 0.000000)
//  119 0x00001144 : mul r1.xyz, r1.xyzx, l(0.000450, 0.000450, 0.000450, 0.000000)
//  120 0x0000116C : mad r0.xyz, r0.xyzx, l(0.020000, 0.020000, 0.020000, 0.000000), r1.xyzx
//  121 0x0000119C : log r0.xyz, | r0.xyzx |
//  122 0x000011B4 : mul r0.xyz, r0.xyzx, l(0.159302, 0.159302, 0.159302, 0.000000)
//  123 0x000011DC : exp r0.xyz, r0.xyzx
//  124 0x000011F0 : mad r1.xyz, r0.xyzx, l(18.851562, 18.851562, 18.851562, 0.000000), l(0.835938, 0.835938, 0.835938, 0.000000)
//  125 0x0000122C : mad r0.xyz, r0.xyzx, l(18.687500, 18.687500, 18.687500, 0.000000), l(1.000000, 1.000000, 1.000000, 0.000000)
//  126 0x00001268 : div r0.xyz, r1.xyzx, r0.xyzx
//  127 0x00001284 : log r0.xyz, r0.xyzx
//  128 0x00001298 : mul r0.xyz, r0.xyzx, l(78.843750, 78.843750, 78.843750, 0.000000)
//  129 0x000012C0 : exp o0.xyz, r0.xyzx
//  130 0x000012D4 : mov o0.w, l(0)
//  131 0x000012E8 : ret
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              // Approximately 0 instruction slots used
