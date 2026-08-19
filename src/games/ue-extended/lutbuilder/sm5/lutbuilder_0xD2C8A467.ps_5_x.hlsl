// State of Decay 2 (UE 4.13.2.0)

#include "../lutbuilderoutput.hlsli"

// ---- Created with 3Dmigoto v1.4.1 on Tue Apr 28 13:14:32 2026
cbuffer cb0 : register(b0) {
  float4 cb0[46];
}

// 3Dmigoto declarations
#define cmp -

void main(
    linear noperspective float2 v0: TEXCOORD0,
    float4 v1: SV_POSITION0,
    uint v2: SV_RenderTargetArrayIndex0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = (uint)v2.x;
  r0.z = 0.0322580636 * r0.x;
  switch (cb0[20].z) {
    case 0:
      r1.xyz = float3(1.70505154, -0.621790707, -0.0832583979);
      r2.xyz = float3(-0.130257145, 1.14080286, -0.0105485283);
      r3.xyz = float3(-0.0240032747, -0.128968775, 1.15297174);
      break;
    case 1:
      r1.xyz = float3(1.37915885, -0.308850735, -0.0703467429);
      r2.xyz = float3(-0.0693352968, 1.08229232, -0.0129620517);
      r3.xyz = float3(-0.00215925858, -0.0454653986, 1.04775953);
      break;
    case 2:
      r1.xyz = float3(1.02579927, -0.0200525094, -0.00577136781);
      r2.xyz = float3(-0.00223502493, 1.00458264, -0.00235231337);
      r3.xyz = float3(-0.00501400325, -0.0252933875, 1.03044021);
      break;
    case 3:
      r1.xyz = float3(0.695452213, 0.140678704, 0.163869068);
      r2.xyz = float3(0.0447945632, 0.859671116, 0.0955343172);
      r3.xyz = float3(-0.00552588282, 0.00402521016, 1.00150073);
      break;
    case 4:
      r1.xyz = float3(1, 0, 0);
      r2.xyz = float3(0, 1, 0);
      r3.xyz = float3(0, 0, 1);
      break;
    default:
      break;
  }
  r0.xy = v0.xy * float2(1.03225803, 1.03225803) + float2(-0.0161290318, -0.0161290318);
  r0.xyz = float3(-0.434017599, -0.434017599, -0.434017599) + r0.xyz;
  r0.xyz = float3(14, 14, 14) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = float3(0.180000007, 0.180000007, 0.180000007) * r0.xyz;
  r0.w = 1.00055635 * cb0[40].x;
  r1.w = cmp(6996.10791 >= cb0[40].x);
  r4.xy = float2(4.60700006e+09, 2.0064e+09) / r0.ww;
  r4.xy = float2(2967800, 1901800) + -r4.xy;
  r4.xy = r4.xy / r0.ww;
  r4.xy = float2(99.1100006, 247.479996) + r4.xy;
  r4.xy = r4.xy / r0.ww;
  r4.xy = float2(0.244063005, 0.237039998) + r4.xy;
  r4.x = r1.w ? r4.x : r4.y;
  r0.w = r4.x * r4.x;
  r1.w = 2.86999989 * r4.x;
  r0.w = r0.w * -3 + r1.w;
  r4.y = -0.275000006 + r0.w;
  r5.xyz = cb0[40].xxx * float3(0.000154118257, 0.00084242021, 4.22806261e-05) + float3(0.860117733, 1, 0.317398727);
  r0.w = cb0[40].x * cb0[40].x;
  r5.xyz = r0.www * float3(1.28641219e-07, 7.08145137e-07, 4.20481676e-08) + r5.xyz;
  r5.x = r5.x / r5.y;
  r1.w = -cb0[40].x * 2.8974182e-05 + 1;
  r0.w = r0.w * 1.61456057e-07 + r1.w;
  r5.y = r5.z / r0.w;
  r4.zw = r5.xy + r5.xy;
  r0.w = 3 * r5.x;
  r1.w = -r5.y * 8 + r4.z;
  r1.w = 4 + r1.w;
  r6.x = r0.w / r1.w;
  r6.y = r4.w / r1.w;
  r0.w = cmp(cb0[40].x < 4000);
  r4.xy = r0.ww ? r6.xy : r4.xy;
  r0.w = dot(r5.xy, r5.xy);
  r0.w = rsqrt(r0.w);
  r4.zw = r5.xy * r0.ww;
  r0.w = cb0[40].y * -r4.w;
  r0.w = r0.w * 0.0500000007 + r5.x;
  r1.w = cb0[40].y * r4.z;
  r1.w = r1.w * 0.0500000007 + r5.y;
  r2.w = 3 * r0.w;
  r0.w = r0.w + r0.w;
  r0.w = -r1.w * 8 + r0.w;
  r0.w = 4 + r0.w;
  r5.x = r2.w / r0.w;
  r1.w = r1.w + r1.w;
  r5.y = r1.w / r0.w;
  r4.zw = r5.xy + -r6.xy;
  r4.xy = r4.xy + r4.zw;
  r0.w = max(1.00000001e-10, r4.y);
  r5.x = r4.x / r0.w;
  r1.w = 1 + -r4.x;
  r1.w = r1.w + -r4.y;
  r5.z = r1.w / r0.w;
  r5.y = 1;
  r0.w = dot(float3(0.895099998, 0.266400009, -0.161400005), r5.xyz);
  r1.w = dot(float3(-0.750199974, 1.71350002, 0.0366999991), r5.xyz);
  r2.w = dot(float3(0.0388999991, -0.0684999973, 1.02960002), r5.xyz);
  r0.w = 0.941379249 / r0.w;
  r1.w = 1.04043639 / r1.w;
  r2.w = 1.0897665 / r2.w;
  r4.xyz = float3(0.895099998, 0.266400009, -0.161400005) * r0.www;
  r5.xyz = float3(-0.750199974, 1.71350002, 0.0366999991) * r1.www;
  r6.xyz = float3(0.0388999991, -0.0684999973, 1.02960002) * r2.www;
  r7.x = r4.x;
  r7.y = r5.x;
  r7.z = r6.x;
  r8.x = dot(float3(0.986992896, -0.1470543, 0.159962699), r7.xyz);
  r9.x = r4.y;
  r9.y = r5.y;
  r9.z = r6.y;
  r8.y = dot(float3(0.986992896, -0.1470543, 0.159962699), r9.xyz);
  r6.x = r4.z;
  r6.y = r5.z;
  r8.z = dot(float3(0.986992896, -0.1470543, 0.159962699), r6.xyz);
  r4.x = dot(float3(0.432305306, 0.518360317, 0.0492912009), r7.xyz);
  r4.y = dot(float3(0.432305306, 0.518360317, 0.0492912009), r9.xyz);
  r4.z = dot(float3(0.432305306, 0.518360317, 0.0492912009), r6.xyz);
  r5.x = dot(float3(-0.0085287001, 0.040042799, 0.968486726), r7.xyz);
  r5.y = dot(float3(-0.0085287001, 0.040042799, 0.968486726), r9.xyz);
  r5.z = dot(float3(-0.0085287001, 0.040042799, 0.968486726), r6.xyz);
  switch (cb0[20].z) {
    case 0:
      r6.xyz = float3(3.2409699, -1.5373832, -0.498610765);
      r7.xyz = float3(-0.969243646, 1.8759675, 0.0415550582);
      r9.xyz = float3(0.0556300804, -0.203976959, 1.05697155);
      r0.w = -1;
      break;
    case 1:
      r6.xyz = float3(2.49339628, -0.93134588, -0.402694494);
      r7.xyz = float3(-0.829486787, 1.76265967, 0.0236246008);
      r9.xyz = float3(0.0358507, -0.0761827007, 0.957014024);
      r0.w = -1;
      break;
    case 2:
      r6.xyz = float3(1.71660841, -0.355662107, -0.253360093);
      r7.xyz = float3(-0.666682899, 1.61647761, 0.0157685);
      r9.xyz = float3(0.0176422, -0.0427763015, 0.942228675);
      r0.w = -1;
      break;
    case 3:
      r6.xyz = float3(1.04981101, 0, -9.74845025e-05);
      r7.xyz = float3(-0.495903015, 1.37331307, 0.0982400328);
      r9.xyz = float3(0, 0, 0.991252005);
      r0.w = -1;
      break;
    case 4:
      r6.xyz = float3(1.6410234, -0.324803293, -0.236424699);
      r7.xyz = float3(-0.663662851, 1.61533165, 0.0167563483);
      r9.xyz = float3(0.0117218941, -0.00828444213, 0.988394856);
      r0.w = -1;
      break;
    default:
      r0.w = 0;
      break;
  }
  r6.xyz = r0.www ? r6.xyz : float3(1, 0, 0);
  r7.xyz = r0.www ? r7.xyz : float3(0, 1, 0);
  r9.xyz = r0.www ? r9.xyz : float3(0, 0, 1);
  switch (cb0[20].z) {
    case 0:
      r10.xyz = float3(0.412456393, 0.212672904, 0.0193339009);
      r11.xyz = float3(0.357576102, 0.715152204, 0.119191997);
      r12.xyz = float3(0.180437505, 0.0721750036, 0.950304091);
      r0.w = -1;
      break;
    case 1:
      r10.xyz = float3(0.486590594, 0.228983805, 0);
      r11.xyz = float3(0.265668303, 0.691740215, 0.0451135002);
      r12.xyz = float3(0.198190495, 0.0792761967, 1.0438031);
      r0.w = -1;
      break;
    case 2:
      r10.xyz = float3(0.636973619, 0.262706608, 0);
      r11.xyz = float3(0.1446172, 0.677999616, 0.0280728005);
      r12.xyz = float3(0.168858498, 0.0592937991, 1.06084371);
      r0.w = -1;
      break;
    case 3:
      r10.xyz = float3(0.952552378, 0.343966454, 0);
      r11.xyz = float3(0, 0.728166103, 0);
      r12.xyz = float3(9.36786018e-05, -0.0721325427, 1.00882518);
      r0.w = -1;
      break;
    case 4:
      r10.xyz = float3(0.662454188, 0.272228718, -0.00557464967);
      r11.xyz = float3(0.134004205, 0.674081743, 0.0040607336);
      r12.xyz = float3(0.156187683, 0.0536895171, 1.01033914);
      r0.w = -1;
      break;
    default:
      r0.w = 0;
      break;
  }
  r10.xyz = r0.www ? r10.xyz : float3(1, 0, 0);
  r11.xyz = r0.www ? r11.xyz : float3(0, 1, 0);
  r12.xyz = r0.www ? r12.xyz : float3(0, 0, 1);
  r13.x = dot(r8.xyz, r10.xyz);
  r14.x = dot(r8.xyz, r11.xyz);
  r8.x = dot(r8.xyz, r12.xyz);
  r13.y = dot(r4.xyz, r10.xyz);
  r14.y = dot(r4.xyz, r11.xyz);
  r8.y = dot(r4.xyz, r12.xyz);
  r13.z = dot(r5.xyz, r10.xyz);
  r14.z = dot(r5.xyz, r11.xyz);
  r8.z = dot(r5.xyz, r12.xyz);
  r4.x = dot(r6.xyz, r13.xyz);
  r4.y = dot(r6.xyz, r14.xyz);
  r4.z = dot(r6.xyz, r8.xyz);
  r5.x = dot(r7.xyz, r13.xyz);
  r5.y = dot(r7.xyz, r14.xyz);
  r5.z = dot(r7.xyz, r8.xyz);
  r6.x = dot(r9.xyz, r13.xyz);
  r6.y = dot(r9.xyz, r14.xyz);
  r6.z = dot(r9.xyz, r8.xyz);
  r4.x = dot(r4.xyz, r0.xyz);
  r4.y = dot(r5.xyz, r0.xyz);
  r4.z = dot(r6.xyz, r0.xyz);
  switch (cb0[20].z) {
    case 0:
      r0.xyz = float3(0.613191485, 0.0702069029, 0.0206188709);
      r5.xyz = float3(0.33951208, 0.916335821, 0.109567292);
      r6.xyz = float3(0.0473663323, 0.0134500116, 0.869606733);
      break;
    case 1:
      r0.xyz = float3(0.735823631, 0.0471839607, 0.00356378197);
      r5.xyz = float3(0.212164462, 0.938050687, 0.0411420129);
      r6.xyz = float3(0.0520266704, 0.0147733372, 0.955166042);
      break;
    case 2:
      r0.xyz = float3(0.974913538, 0.00218234211, 0.00479732221);
      r5.xyz = float3(0.0195976123, 0.995539963, 0.0245321207);
      r6.xyz = float3(0.00550352037, 0.00228539831, 0.970542312);
      break;
    case 3:
      r0.xyz = float3(1.45143926, -0.0765537769, 0.00831614807);
      r5.xyz = float3(-0.236510754, 1.17622972, -0.00603244966);
      r6.xyz = float3(-0.214928567, -0.0996759236, 0.997716308);
      break;
    case 4:
      r0.xyz = float3(1, 0, 0);
      r5.xyz = float3(0, 1, 0);
      r6.xyz = float3(0, 0, 1);
      break;
    default:
      break;
  }
  r7.x = r0.x;
  r7.y = r5.x;
  r7.z = r6.x;
  r7.x = dot(r7.xyz, r4.xyz);
  r8.x = r0.y;
  r8.y = r5.y;
  r8.z = r6.y;
  r7.y = dot(r8.xyz, r4.xyz);
  r6.x = r0.z;
  r6.y = r5.z;
  r7.z = dot(r6.xyz, r4.xyz);
  r0.x = dot(r7.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
  r0.yzw = r7.xyz + -r0.xxx;
  r0.xyz = cb0[41].xyz * r0.yzw + r0.xxx;
  r0.xyz = max(float3(0, 0, 0), r0.xyz);
  r0.xyz = float3(5.55555534, 5.55555534, 5.55555534) * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = cb0[42].xyz * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = float3(0.180000007, 0.180000007, 0.180000007) * r0.xyz;
  r4.xyz = float3(1, 1, 1) / cb0[43].xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = r4.xyz * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = r0.xyz * cb0[44].xyz + cb0[45].xyz;
  switch (cb0[20].z) {
    case 0:
      r4.xyz = float3(1.70505154, -0.621790707, -0.0832583979);
      r5.xyz = float3(-0.130257145, 1.14080286, -0.0105485283);
      r6.xyz = float3(-0.0240032747, -0.128968775, 1.15297174);
      break;
    case 1:
      r4.xyz = float3(1.37915885, -0.308850735, -0.0703467429);
      r5.xyz = float3(-0.0693352968, 1.08229232, -0.0129620517);
      r6.xyz = float3(-0.00215925858, -0.0454653986, 1.04775953);
      break;
    case 2:
      r4.xyz = float3(1.02579927, -0.0200525094, -0.00577136781);
      r5.xyz = float3(-0.00223502493, 1.00458264, -0.00235231337);
      r6.xyz = float3(-0.00501400325, -0.0252933875, 1.03044021);
      break;
    case 3:
      r4.xyz = float3(0.695452213, 0.140678704, 0.163869068);
      r5.xyz = float3(0.0447945632, 0.859671116, 0.0955343172);
      r6.xyz = float3(-0.00552588282, 0.00402521016, 1.00150073);
      break;
    case 4:
      r4.xyz = float3(1, 0, 0);
      r5.xyz = float3(0, 1, 0);
      r6.xyz = float3(0, 0, 1);
      break;
    default:
      break;
  }

  float3 untonemapped_ap1 = r0.xyz;

  UECbufferConfig cb_config = CreateCbufferConfig();
  cb_config.ue_filmblackclip = asfloat(cb0[32].w);
  cb_config.ue_filmtoe = asfloat(cb0[32].y);
  cb_config.ue_filmshoulder = asfloat(cb0[32].z);
  cb_config.ue_filmslope = asfloat(cb0[32].x);
  cb_config.ue_filmwhiteclip = asfloat(cb0[33].x);
  cb_config.ue_tonecurveammount = asfloat(1.f);  // old UE version; 1.f = no tonecurve
  cb_config.ue_mappingpolynomial = asfloat(cb0[19].xyz);
  cb_config.ue_overlaycolor = asfloat(cb0[39].xyzw);
  cb_config.ue_bluecorrection = asfloat(0.f);  // old UE version; 0.f = no bluecorrect
  cb_config.ue_colorscale = asfloat(cb0[38].yzw);

  o0 = ProcessLutbuilder(float3(untonemapped_ap1), cb_config, o0, asuint(cb0[31].w));

  return;

  r4.x = dot(r4.xyz, r0.xyz);
  r4.y = dot(r5.xyz, r0.xyz);
  r4.z = dot(r6.xyz, r0.xyz);
  switch (cb0[20].z) {
    case 0:
      r0.xyz = float3(0.613191485, 0.0702069029, 0.0206188709);
      r5.xyz = float3(0.33951208, 0.916335821, 0.109567292);
      r6.xyz = float3(0.0473663323, 0.0134500116, 0.869606733);
      break;
    case 1:
      r0.xyz = float3(0.735823631, 0.0471839607, 0.00356378197);
      r5.xyz = float3(0.212164462, 0.938050687, 0.0411420129);
      r6.xyz = float3(0.0520266704, 0.0147733372, 0.955166042);
      break;
    case 2:
      r0.xyz = float3(0.974913538, 0.00218234211, 0.00479732221);
      r5.xyz = float3(0.0195976123, 0.995539963, 0.0245321207);
      r6.xyz = float3(0.00550352037, 0.00228539831, 0.970542312);
      break;
    case 3:
      r0.xyz = float3(1.45143926, -0.0765537769, 0.00831614807);
      r5.xyz = float3(-0.236510754, 1.17622972, -0.00603244966);
      r6.xyz = float3(-0.214928567, -0.0996759236, 0.997716308);
      break;
    case 4:
      r0.xyz = float3(1, 0, 0);
      r5.xyz = float3(0, 1, 0);
      r6.xyz = float3(0, 0, 1);
      break;
    default:
      break;
  }

  r0.w = cmp(cb0[31].w == 0.000000);
  if (r0.w != 0) {
    r7.x = dot(r4.xyz, cb0[24].xyz);
    r7.y = dot(r4.xyz, cb0[25].xyz);
    r7.z = dot(r4.xyz, cb0[26].xyz);
    r0.w = dot(r4.xyz, cb0[29].xyz);
    r0.w = 1 + r0.w;
    r0.w = rcp(r0.w);
    r8.xyz = cb0[31].xyz * r0.www + cb0[30].xyz;
    r7.xyz = r8.xyz * r7.xyz;
    r7.xyz = max(float3(0, 0, 0), r7.xyz);
    r8.xyz = cb0[27].xxx + -r7.xyz;
    r8.xyz = max(float3(0, 0, 0), r8.xyz);
    r9.xyz = max(cb0[27].zzz, r7.xyz);
    r7.xyz = max(cb0[27].xxx, r7.xyz);
    r7.xyz = min(cb0[27].zzz, r7.xyz);
    r10.xyz = r9.xyz * cb0[28].xxx + cb0[28].yyy;
    r9.xyz = cb0[27].www + r9.xyz;
    r9.xyz = rcp(r9.xyz);
    r11.xyz = cb0[24].www * r8.xyz;
    r8.xyz = cb0[27].yyy + r8.xyz;
    r8.xyz = rcp(r8.xyz);
    r8.xyz = r11.xyz * r8.xyz + cb0[25].www;
    r7.xyz = r7.xyz * cb0[26].www + r8.xyz;
    r7.xyz = r10.xyz * r9.xyz + r7.xyz;
    r7.xyz = float3(-0.00200000009, -0.00200000009, -0.00200000009) + r7.xyz;
  } else {
    r8.x = dot(float3(0.695452213, 0.140678704, 0.163869068), r0.xyz);
    r8.y = dot(float3(0.695452213, 0.140678704, 0.163869068), r5.xyz);
    r8.z = dot(float3(0.695452213, 0.140678704, 0.163869068), r6.xyz);
    r9.x = dot(float3(0.0447945632, 0.859671116, 0.0955343172), r0.xyz);
    r9.y = dot(float3(0.0447945632, 0.859671116, 0.0955343172), r5.xyz);
    r9.z = dot(float3(0.0447945632, 0.859671116, 0.0955343172), r6.xyz);
    r0.x = dot(float3(-0.00552588282, 0.00402521016, 1.00150073), r0.xyz);
    r0.y = dot(float3(-0.00552588282, 0.00402521016, 1.00150073), r5.xyz);
    r0.z = dot(float3(-0.00552588282, 0.00402521016, 1.00150073), r6.xyz);
    r0.w = dot(r8.xyz, r4.xyz);
    r5.y = dot(r9.xyz, r4.xyz);
    r5.z = dot(r0.xyz, r4.xyz);
    r0.x = min(r5.y, r0.w);
    r0.x = min(r0.x, r5.z);
    r0.y = max(r5.y, r0.w);
    r0.y = max(r0.y, r5.z);
    r0.xyz = max(float3(1.00000001e-10, 1.00000001e-10, 0.00999999978), r0.xyy);
    r0.x = r0.y + -r0.x;
    r0.x = r0.x / r0.z;
    r0.y = cmp(r0.w == r5.y);
    r0.z = cmp(r5.z == r5.y);
    r0.y = r0.z ? r0.y : 0;
    r0.z = r5.y + -r5.z;
    r0.z = 1.73205078 * r0.z;
    r1.w = r0.w * 2 + -r5.y;
    r1.w = r1.w + -r5.z;
    r2.w = min(abs(r1.w), abs(r0.z));
    r3.w = max(abs(r1.w), abs(r0.z));
    r3.w = 1 / r3.w;
    r2.w = r3.w * r2.w;
    r3.w = r2.w * r2.w;
    r4.x = r3.w * 0.0208350997 + -0.0851330012;
    r4.x = r3.w * r4.x + 0.180141002;
    r4.x = r3.w * r4.x + -0.330299497;
    r3.w = r3.w * r4.x + 0.999866009;
    r4.x = r3.w * r2.w;
    r4.y = cmp(abs(r1.w) < abs(r0.z));
    r4.x = r4.x * -2 + 1.57079637;
    r4.x = r4.y ? r4.x : 0;
    r2.w = r2.w * r3.w + r4.x;
    r3.w = cmp(r1.w < -r1.w);
    r3.w = r3.w ? -3.141593 : 0;
    r2.w = r3.w + r2.w;
    r3.w = min(r1.w, r0.z);
    r0.z = max(r1.w, r0.z);
    r1.w = cmp(r3.w < -r3.w);
    r0.z = cmp(r0.z >= -r0.z);
    r0.z = r0.z ? r1.w : 0;
    r0.z = r0.z ? -r2.w : r2.w;
    r0.z = 57.2957802 * r0.z;
    r0.y = r0.y ? 0 : r0.z;
    r0.z = cmp(r0.y < 0);
    r1.w = 360 + r0.y;
    r0.y = r0.z ? r1.w : r0.y;
    r0.y = max(0, r0.y);
    r0.y = min(360, r0.y);
    r0.z = cmp(180 < r0.y);
    r1.w = -360 + r0.y;
    r0.y = r0.z ? r1.w : r0.y;
    r0.y = 0.0148148146 * r0.y;
    r0.y = 1 + -abs(r0.y);
    r0.y = max(0, r0.y);
    r0.z = r0.y * -2 + 3;
    r0.y = r0.y * r0.y;
    r0.y = r0.z * r0.y;
    r0.y = r0.y * r0.y;
    r0.x = r0.y * r0.x;
    r0.y = 0.0299999993 + -r0.w;
    r0.x = r0.x * r0.y;
    r5.x = r0.x * 0.180000007 + r0.w;
    r0.x = dot(float3(1.45143926, -0.236510754, -0.214928567), r5.xyz);
    r0.y = dot(float3(-0.0765537769, 1.17622972, -0.0996759236), r5.xyz);
    r0.z = dot(float3(0.00831614807, -0.00603244966, 0.997716308), r5.xyz);
    r0.xyz = max(float3(0, 0, 0), r0.xyz);
    r0.w = dot(r0.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
    r0.xyz = r0.xyz + -r0.www;
    r0.xyz = r0.xyz * float3(0.959999979, 0.959999979, 0.959999979) + r0.www;
    r4.xy = float2(1, 0.180000007) + cb0[32].ww;
    r0.w = -cb0[32].y + r4.x;
    r1.w = 1 + cb0[33].x;
    r2.w = -cb0[32].z + r1.w;
    r3.w = cmp(0.800000012 < cb0[32].y);
    r4.xz = float2(0.819999993, 1) + -cb0[32].yy;
    r4.xz = r4.xz / cb0[32].xx;
    r4.y = r4.y / r0.w;
    r4.xw = float2(-0.744727492, -1) + r4.xy;
    r4.w = 1 + -r4.w;
    r4.y = r4.y / r4.w;
    r4.y = log2(r4.y);
    r4.y = 0.346573591 * r4.y;
    r4.w = r0.w / cb0[32].x;
    r4.y = -r4.y * r4.w + -0.744727492;
    r3.w = r3.w ? r4.x : r4.y;
    r4.x = r4.z + -r3.w;
    r4.y = cb0[32].z / cb0[32].x;
    r4.y = r4.y + -r4.x;
    r0.xyz = log2(r0.xyz);
    r5.xyz = float3(0.30103001, 0.30103001, 0.30103001) * r0.xyz;
    r4.xzw = r0.xyz * float3(0.30103001, 0.30103001, 0.30103001) + r4.xxx;
    r4.xzw = cb0[32].xxx * r4.xzw;
    r5.w = r0.w + r0.w;
    r6.x = -2 * cb0[32].x;
    r0.w = r6.x / r0.w;
    r6.xyz = r0.xyz * float3(0.30103001, 0.30103001, 0.30103001) + -r3.www;
    r8.xyz = r6.xyz * r0.www;
    r8.xyz = float3(1.44269502, 1.44269502, 1.44269502) * r8.xyz;
    r8.xyz = exp2(r8.xyz);
    r8.xyz = float3(1, 1, 1) + r8.xyz;
    r8.xyz = r5.www / r8.xyz;
    r8.xyz = -cb0[32].www + r8.xyz;
    r0.w = r2.w + r2.w;
    r5.w = cb0[32].x + cb0[32].x;
    r2.w = r5.w / r2.w;
    r0.xyz = r0.xyz * float3(0.30103001, 0.30103001, 0.30103001) + -r4.yyy;
    r0.xyz = r2.www * r0.xyz;
    r0.xyz = float3(1.44269502, 1.44269502, 1.44269502) * r0.xyz;
    r0.xyz = exp2(r0.xyz);
    r0.xyz = float3(1, 1, 1) + r0.xyz;
    r0.xyz = r0.www / r0.xyz;
    r0.xyz = r1.www + -r0.xyz;
    r9.xyz = cmp(r5.xyz < r3.www);
    r8.xyz = r9.xyz ? r8.xyz : r4.xzw;
    r5.xyz = cmp(r4.yyy < r5.xyz);
    r0.xyz = r5.xyz ? r0.xyz : r4.xzw;
    r0.w = r4.y + -r3.w;
    r4.xzw = saturate(r6.xyz / r0.www);
    r0.w = cmp(r4.y < r3.w);
    r5.xyz = float3(1, 1, 1) + -r4.xzw;
    r4.xyz = r0.www ? r5.xyz : r4.xzw;
    r5.xyz = -r4.xyz * float3(2, 2, 2) + float3(3, 3, 3);
    r4.xyz = r4.xyz * r4.xyz;
    r4.xyz = r4.xyz * r5.xyz;
    r0.xyz = r0.xyz + -r8.xyz;
    r0.xyz = r4.xyz * r0.xyz + r8.xyz;
    r0.w = dot(r0.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
    r0.xyz = r0.xyz + -r0.www;
    r0.xyz = r0.xyz * float3(0.930000007, 0.930000007, 0.930000007) + r0.www;
    r0.xyz = max(float3(0, 0, 0), r0.xyz);
    r1.x = dot(r1.xyz, r0.xyz);
    r1.y = dot(r2.xyz, r0.xyz);
    r1.z = dot(r3.xyz, r0.xyz);
    r7.xyz = max(float3(0, 0, 0), r1.xyz);
  }
  r0.xyz = r7.xyz * r7.xyz;
  r1.xyz = cb0[19].yyy * r7.xyz;
  r0.xyz = cb0[19].xxx * r0.xyz + r1.xyz;
  r0.xyz = cb0[19].zzz + r0.xyz;
  r1.xyz = cb0[38].yzw * r0.xyz;
  r0.xyz = -r0.xyz * cb0[38].yzw + cb0[39].xyz;
  r0.xyz = cb0[39].www * r0.xyz + r1.xyz;
  r0.xyz = max(float3(0, 0, 0), r0.xyz);
  r0.xyz = log2(r0.xyz);
  r0.xyz = cb0[23].yyy * r0.xyz;
  r1.xyz = exp2(r0.xyz);
  r2.xyz = float3(12.9200001, 12.9200001, 12.9200001) * r1.xyz;
  r1.xyz = cmp(r1.xyz >= float3(0.00313066994, 0.00313066994, 0.00313066994));
  r0.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = r0.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
  r0.xyz = r1.xyz ? r0.xyz : r2.xyz;
  o0.xyz = float3(0.952381015, 0.952381015, 0.952381015) * r0.xyz;
  o0.w = 0;
  return;
}
