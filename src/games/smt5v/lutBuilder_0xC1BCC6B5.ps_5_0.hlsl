// ---- Created with 3Dmigoto v1.3.16 on Mon Jul  8 21:01:04 2024
cbuffer cb0 : register(b0)
{
    float4 cb0[67];
}




// 3Dmigoto declarations
#define cmp -


void main(
  linear noperspective float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  uint v2 : SV_RenderTargetArrayIndex0,
  out float4 o0 : SV_Target0)
{
    const float4 icb[] =
    {
        { -4.000000, -0.718548, -4.970622, 0.808913 },
        { -4.000000, 2.081031, -3.029378, 1.191087 },
        { -3.157377, 3.668124, -2.126200, 1.568300 },
        { -0.485250, 4.000000, -1.510500, 1.948300 },
        { 1.847732, 4.000000, -1.057800, 2.308300 },
        { 1.847732, 4.000000, -0.466800, 2.638400 },
        { -2.301030, 0.801995, 0.119380, 2.859500 },
        { -2.301030, 1.198005, 0.708813, 2.987261 },
        { -1.931200, 1.594300, 1.291187, 3.012739 },
        { -1.520500, 1.997300, 1.291187, 3.012739 },
        { -1.057800, 2.378300, 0, 0 },
        { -0.466800, 2.768400, 0, 0 },
        { 0.119380, 3.051500, 0, 0 },
        { 0.708813, 3.274629, 0, 0 },
        { 1.291187, 3.327431, 0, 0 },
        { 1.291187, 3.327431, 0, 0 }
    };
    float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12;
    uint4 bitmask, uiDest;
    float4 fDest;

    r0.xy = float2(-0.015625, -0.015625) + v0.xy;
    r0.xy = float2(1.03225803, 1.03225803) * r0.xy;
    r0.z = (uint) v2.x;
    r1.z = 0.0322580636 * r0.z;
    r0.z = cmp(asuint(cb0[65].z) >= 3);
    r2.xy = log2(r0.xy);
    r2.z = log2(r1.z);
    r0.xyw = float3(0.0126833133, 0.0126833133, 0.0126833133) * r2.xyz;
    r0.xyw = exp2(r0.xyw);
    r2.xyz = float3(-0.8359375, -0.8359375, -0.8359375) + r0.xyw;
    r2.xyz = max(float3(0, 0, 0), r2.xyz);
    r0.xyw = -r0.xyw * float3(18.6875, 18.6875, 18.6875) + float3(18.8515625, 18.8515625, 18.8515625);
    r0.xyw = r2.xyz / r0.xyw;
    r0.xyw = log2(r0.xyw);
    r0.xyw = float3(6.27739477, 6.27739477, 6.27739477) * r0.xyw;
    r0.xyw = exp2(r0.xyw);
    r0.xyw = float3(100, 100, 100) * r0.xyw;
    r1.xy = v0.xy * float2(1.03225803, 1.03225803) + float2(-0.0161290318, -0.0161290318);
    r1.xyz = float3(-0.434017599, -0.434017599, -0.434017599) + r1.xyz;
    r1.xyz = float3(14, 14, 14) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r1.xyz = r1.xyz * float3(0.180000007, 0.180000007, 0.180000007) + float3(-0.00266771927, -0.00266771927, -0.00266771927);
    r0.xyz = r0.zzz ? r0.xyw : r1.xyz;
    //ACES sRGB_2_AP1 [ https://github.com/Unity-Technologies/PostProcessing/blob/v2/PostProcessing/Shaders/ACES.hlsl ]
    r1.x = dot(float3(0.613191485, 0.33951208, 0.0473663323), r0.xyz);
    r1.y = dot(float3(0.0702069029, 0.916335821, 0.0134500116), r0.xyz);
    r1.z = dot(float3(0.0206188709, 0.109567292, 0.869606733), r0.xyz);
    // AP1_RGB2Y
    r0.x = dot(r1.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
    r0.yzw = r1.xyz / r0.xxx;
    r0.yzw = float3(-1, -1, -1) + r0.yzw;
    r0.y = dot(r0.yzw, r0.yzw);
    r0.y = -4 * r0.y;
    r0.y = exp2(r0.y);
    r0.x = r0.x * r0.x;
    r0.x = cb0[66].y * r0.x;
    r0.x = -4 * r0.x;
    r0.x = exp2(r0.x);
    r0.xy = float2(1, 1) + -r0.xy;
    r0.x = r0.y * r0.x;
    r2.x = dot(float3(1.37041271, -0.329291314, -0.0636827648), r1.xyz);
    r2.y = dot(float3(-0.0834341869, 1.09709096, -0.0108615728), r1.xyz);
    r2.z = dot(float3(-0.0257932581, -0.0986256376, 1.20369434), r1.xyz);
    r0.yzw = r2.xyz + -r1.xyz;
    r0.xyz = r0.xxx * r0.yzw + r1.xyz;
    r0.xyz = cb0[44].yyy ? r1.xyz : r0.xyz;
    // AP1_RGB2Y
    r0.w = dot(r0.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
    r1.xyzw = cb0[50].xyzw * cb0[45].xyzw;
    r2.xyzw = cb0[51].xyzw * cb0[46].xyzw;
    r3.xyzw = cb0[52].xyzw * cb0[47].xyzw;
    r4.xyzw = cb0[53].xyzw * cb0[48].xyzw;
    r5.xyzw = cb0[54].xyzw + cb0[49].xyzw;
    r1.xyz = r1.xyz * r1.www;
    r0.xyz = r0.xyz + -r0.www;
    r1.xyz = r1.xyz * r0.xyz + r0.www;
    r1.xyz = max(float3(0, 0, 0), r1.xyz);
    r1.xyz = float3(5.55555534, 5.55555534, 5.55555534) * r1.xyz;
    r2.xyz = r2.xyz * r2.www;
    r1.xyz = log2(r1.xyz);
    r1.xyz = r2.xyz * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r1.xyz = float3(0.180000007, 0.180000007, 0.180000007) * r1.xyz;
    r2.xyz = r3.xyz * r3.www;
    r2.xyz = float3(1, 1, 1) / r2.xyz;
    r1.xyz = log2(r1.xyz);
    r1.xyz = r2.xyz * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r2.xyz = r4.xyz * r4.www;
    r3.xyz = r5.xyz + r5.www;
    r1.xyz = r1.xyz * r2.xyz + r3.xyz;
    r1.w = 1 / cb0[65].x;
    r1.w = saturate(r1.w * r0.w); //removed saturate
    r2.x = r1.w * -2 + 3;
    r1.w = r1.w * r1.w;
    r1.w = -r2.x * r1.w + 1;
    r2.xyzw = cb0[60].xyzw * cb0[45].xyzw;
    r3.xyzw = cb0[61].xyzw * cb0[46].xyzw;
    r4.xyzw = cb0[62].xyzw * cb0[47].xyzw;
    r5.xyzw = cb0[63].xyzw * cb0[48].xyzw;
    r6.xyzw = cb0[64].xyzw + cb0[49].xyzw;
    r2.xyz = r2.xyz * r2.www;
    r2.xyz = r2.xyz * r0.xyz + r0.www;
    r2.xyz = max(float3(0, 0, 0), r2.xyz);
    r2.xyz = float3(5.55555534, 5.55555534, 5.55555534) * r2.xyz;
    r3.xyz = r3.xyz * r3.www;
    r2.xyz = log2(r2.xyz);
    r2.xyz = r3.xyz * r2.xyz;
    r2.xyz = exp2(r2.xyz);
    r2.xyz = float3(0.180000007, 0.180000007, 0.180000007) * r2.xyz;
    r3.xyz = r4.xyz * r4.www;
    r3.xyz = float3(1, 1, 1) / r3.xyz;
    r2.xyz = log2(r2.xyz);
    r2.xyz = r3.xyz * r2.xyz;
    r2.xyz = exp2(r2.xyz);
  
  // purple sword
  //r2.xyz = sign(r2.xyz) * pow(r2.xyz, 1 / 2.4);
  //o0.xyz = r2.xyz;
  //return;
  
    r3.xyz = r5.xyz * r5.www;
    r4.xyz = r6.xyz + r6.www;
    r2.xyz = r2.xyz * r3.xyz + r4.xyz;
    r2.w = 1 + -cb0[65].y;
    r3.x = -cb0[65].y + r0.w;
    r2.w = 1 / r2.w;
    r2.w = saturate(r3.x * r2.w); //removed saturate
    r3.x = r2.w * -2 + 3;
    r2.w = r2.w * r2.w;
    r3.y = r3.x * r2.w;
    r4.xyzw = cb0[55].xyzw * cb0[45].xyzw;
    r5.xyzw = cb0[56].xyzw * cb0[46].xyzw;
    r6.xyzw = cb0[57].xyzw * cb0[47].xyzw;
    r7.xyzw = cb0[58].xyzw * cb0[48].xyzw;
    r8.xyzw = cb0[59].xyzw + cb0[49].xyzw;
    r4.xyz = r4.xyz * r4.www;
    r0.xyz = r4.xyz * r0.xyz + r0.www;
    r0.xyz = max(float3(0, 0, 0), r0.xyz);
    r0.xyz = float3(5.55555534, 5.55555534, 5.55555534) * r0.xyz;
    r4.xyz = r5.xyz * r5.www;
    r0.xyz = log2(r0.xyz);
    r0.xyz = r4.xyz * r0.xyz;
    r0.xyz = exp2(r0.xyz);
    r0.xyz = float3(0.180000007, 0.180000007, 0.180000007) * r0.xyz;
    r4.xyz = r6.xyz * r6.www;
    r4.xyz = float3(1, 1, 1) / r4.xyz;
    r0.xyz = log2(r0.xyz);
    r0.xyz = r4.xyz * r0.xyz;
    r0.xyz = exp2(r0.xyz);
    r4.xyz = r7.xyz * r7.www;
    r5.xyz = r8.xyz + r8.www;
    r0.xyz = r0.xyz * r4.xyz + r5.xyz;
    r0.w = 1 + -r1.w;
    r0.w = -r3.x * r2.w + r0.w;
    r0.xyz = r0.xyz * r0.www;
    r0.xyz = r1.xyz * r1.www + r0.xyz;
    r0.xyz = r2.xyz * r3.yyy + r0.xyz;
    // ACES AP1_2_sRGB [ https://github.com/Unity-Technologies/PostProcessing/blob/v2/PostProcessing/Shaders/ACES.hlsl ]
    r1.x = dot(float3(1.70505154, -0.621790707, -0.0832583979), r0.xyz);
    r1.y = dot(float3(-0.130257145, 1.14080286, -0.0105485283), r0.xyz);
    r1.z = dot(float3(-0.0240032747, -0.128968775, 1.15297174), r0.xyz);
    
    if (cb0[44].y != 0)
    { // not needed, "else" is chosen
        r2.x = dot(r1.xyz, cb0[28].xyz);
        r2.y = dot(r1.xyz, cb0[29].xyz);
        r2.z = dot(r1.xyz, cb0[30].xyz);
        r0.w = dot(r1.xyz, cb0[33].xyz);
        r0.w = 1 + r0.w;
        r0.w = rcp(r0.w);
        r3.xyz = cb0[35].xyz * r0.www + cb0[34].xyz;
        r2.xyz = r3.xyz * r2.xyz;
        r2.xyz = max(float3(0, 0, 0), r2.xyz);
        r3.xyz = cb0[31].xxx + -r2.xyz;
        r3.xyz = max(float3(0, 0, 0), r3.xyz);
        r4.xyz = max(cb0[31].zzz, r2.xyz);
        r2.xyz = max(cb0[31].xxx, r2.xyz);
        r2.xyz = min(cb0[31].zzz, r2.xyz);
        r5.xyz = r4.xyz * cb0[32].xxx + cb0[32].yyy;
        r4.xyz = cb0[31].www + r4.xyz;
        r4.xyz = rcp(r4.xyz);
        r6.xyz = cb0[28].www * r3.xyz;
        r3.xyz = cb0[31].yyy + r3.xyz;
        r3.xyz = rcp(r3.xyz);
        r3.xyz = r6.xyz * r3.xyz + cb0[29].www;
        r2.xyz = r2.xyz * cb0[30].www + r3.xyz;
        r2.xyz = r5.xyz * r4.xyz + r2.xyz;
        r2.xyz = float3(-0.00200000009, -0.00200000009, -0.00200000009) + r2.xyz;
    }
    else
    {
	// main lut stuff
	
	// if uncommented, makes the sword purple (applies no lut/color correction)
	//r0.xyz = sign(r0.xyz) * pow(r0.xyz, 1 / 2.4);
	//o0.xyz = r0.xyz;
	//return;
	// ---
	
	// makes sword white instead of purple (first color correction)
        // ACES ODT_SAT_FACTOR? 
        r3.x = dot(float3(0.938639402, 1.02359565e-10, 0.0613606237), r0.xyz);
        r3.y = dot(float3(8.36008554e-11, 0.830794156, 0.169205874), r0.xyz);
        r3.z = dot(float3(2.13187367e-12, -5.63307213e-12, 1), r0.xyz);
        
	
	// early return
	//r3.xyz = sign(r3.xyz) * pow(r3.xyz, 1 / 2.4);
	//o0.xyz = r3.xyz;
	//return;
	// ---
	
        r3.xyz = r3.xyz + -r0.xyz;
        r0.xyz = cb0[66].xxx * r3.xyz + r0.xyz;
	
	// desaturates the yellow tones
    // ACES AP1_2_AP0_MAT [ https://github.com/Unity-Technologies/PostProcessing/blob/v2/PostProcessing/Shaders/ACES.hlsl ]
        r3.y = dot(float3(0.695452213, 0.140678704, 0.163869068), r0.xyz);
        r3.z = dot(float3(0.0447945632, 0.859671116, 0.0955343172), r0.xyz);
        r3.w = dot(float3(-0.00552588236, 0.00402521016, 1.00150073), r0.xyz);
	
	// early return
    //    r3.xyz = sign(r3.yzw) * pow(r3.yzw, 1 / 2.4);
    //    o0.xyz = r3.xyz;
    //    return;
	// ---
	
       r0.w = min(r3.y, r3.z);
       r0.w = min(r0.w, r3.w);
       r1.w = max(r3.y, r3.z);
       r1.w = max(r1.w, r3.w);
       r4.xy = max(float2(1.00000001e-10, 0.00999999978), r1.ww);
        r0.w = max(1.00000001e-10, r0.w);
        r0.w = r4.x + -r0.w;
        r0.w = r0.w / r4.y;
        r4.xyz = r3.wzy + -r3.zyw;
        r4.xy = r4.xy * r3.wz;
        r1.w = r4.x + r4.y;
        r1.w = r3.y * r4.z + r1.w;
        r1.w = sqrt(r1.w);
        r2.w = r3.w + r3.z;
        r2.w = r2.w + r3.y;
        r1.w = r1.w * 1.75 + r2.w;
        r2.w = 0.333333343 * r1.w;
        r3.x = -0.400000006 + r0.w;
        r4.x = 2.5 * r3.x;
        r4.x = 1 + -abs(r4.x);
        r4.x = max(0, r4.x);
        r4.y = cmp(0 < r3.x);
        r3.x = cmp(r3.x < 0);
        r3.x = (int) -r4.y + (int) r3.x;
        r3.x = (int) r3.x;
        r4.x = -r4.x * r4.x + 1;
        r3.x = r3.x * r4.x + 1;
        r3.x = 0.0250000004 * r3.x;
        r4.x = cmp(0.159999996 >= r1.w);
        r1.w = cmp(r1.w >= 0.479999989);
        r2.w = 0.0799999982 / r2.w;
        r2.w = -0.5 + r2.w;
        r2.w = r3.x * r2.w;
        r1.w = r1.w ? 0 : r2.w;
        r1.w = r4.x ? r3.x : r1.w;
        r1.w = 1 + r1.w;
        r4.yzw = r3.yzw * r1.www;
        r5.xy = cmp(r4.zw == r4.yz);
        r2.w = r5.y ? r5.x : 0;
        r3.x = r3.z * r1.w + -r4.w;
        r3.x = 1.73205078 * r3.x;
        r3.z = r4.y * 2 + -r4.z;
        r3.z = -r3.w * r1.w + r3.z;
        r3.w = min(abs(r3.x), abs(r3.z));
        r5.x = max(abs(r3.x), abs(r3.z));
        r5.x = 1 / r5.x;
        r3.w = r5.x * r3.w;
        r5.x = r3.w * r3.w;
        r5.y = r5.x * 0.0208350997 + -0.0851330012;
        r5.y = r5.x * r5.y + 0.180141002;
        r5.y = r5.x * r5.y + -0.330299497;
        r5.x = r5.x * r5.y + 0.999866009;
        r5.y = r5.x * r3.w;
        r5.z = cmp(abs(r3.z) < abs(r3.x));
        r5.y = r5.y * -2 + 1.57079637;
        r5.y = r5.z ? r5.y : 0;
        r3.w = r3.w * r5.x + r5.y;
        r5.x = cmp(r3.z < -r3.z);
        r5.x = r5.x ? -3.141593 : 0;
        r3.w = r5.x + r3.w;
        r5.x = min(r3.x, r3.z);
        r3.x = max(r3.x, r3.z);
        r3.z = cmp(r5.x < -r5.x);
        r3.x = cmp(r3.x >= -r3.x);
        r3.x = r3.x ? r3.z : 0;
        r3.x = r3.x ? -r3.w : r3.w;
        r3.x = 57.2957802 * r3.x;
        r2.w = r2.w ? 0 : r3.x;
        r3.x = cmp(r2.w < 0);
        r3.z = 360 + r2.w;
        r2.w = r3.x ? r3.z : r2.w;
        r2.w = max(0, r2.w);
        r2.w = min(360, r2.w);
        r3.x = cmp(180 < r2.w);
        r3.z = -360 + r2.w;
        r2.w = r3.x ? r3.z : r2.w;
        r2.w = 0.0148148146 * r2.w;
        r2.w = 1 + -abs(r2.w);
        r2.w = max(0, r2.w);
        r3.x = r2.w * -2 + 3;
        r2.w = r2.w * r2.w;
        r2.w = r3.x * r2.w;
        r2.w = r2.w * r2.w;
        r0.w = r2.w * r0.w;
        r1.w = -r3.y * r1.w + 0.0299999993;
        r0.w = r1.w * r0.w;
        r4.x = r0.w * 0.180000007 + r4.y;
        //ACES AP0_2_AP1_MAT [ https://github.com/Unity-Technologies/PostProcessing/blob/v2/PostProcessing/Shaders/ACES.hlsl ]
        r3.x = dot(float3(1.45143926, -0.236510754, -0.214928567), r4.xzw);
        r3.y = dot(float3(-0.0765537769, 1.17622972, -0.0996759236), r4.xzw);
        r3.z = dot(float3(0.00831614807, -0.00603244966, 0.997716308), r4.xzw);
        r3.xyz = max(float3(0, 0, 0), r3.xyz);
        // AP1_RGB2Y
        r0.w = dot(r3.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
        
        r3.xyz = r3.xyz + -r0.www;
        r3.xyz = r3.xyz * float3(0.959999979, 0.959999979, 0.959999979) + r0.www;
        r4.xy = float2(1, 0.180000007) + cb0[36].ww;
        r0.w = -cb0[36].y + r4.x;
        r1.w = 1 + cb0[37].x;
        r2.w = -cb0[36].z + r1.w;
        r3.w = cmp(0.800000012 < cb0[36].y);
        r4.xz = float2(0.819999993, 1) + -cb0[36].yy;
        r4.xz = r4.xz / cb0[36].xx;
        r4.y = r4.y / r0.w;
        r4.xw = float2(-0.744727492, -1) + r4.xy;
        r4.w = 1 + -r4.w;
        r4.y = r4.y / r4.w;
        r4.y = log2(r4.y);
        r4.y = 0.346573591 * r4.y;
        r4.w = r0.w / cb0[36].x;
        r4.y = -r4.y * r4.w + -0.744727492;
        r3.w = r3.w ? r4.x : r4.y;
        r4.x = r4.z + -r3.w;
        r4.y = cb0[36].z / cb0[36].x;
        r4.y = r4.y + -r4.x;
        r3.xyz = log2(r3.xyz);
        r5.xyz = float3(0.30103001, 0.30103001, 0.30103001) * r3.xyz;
        r4.xzw = r3.xyz * float3(0.30103001, 0.30103001, 0.30103001) + r4.xxx;
        r4.xzw = cb0[36].xxx * r4.xzw;
        r5.w = r0.w + r0.w;
        r6.x = -2 * cb0[36].x;
        r0.w = r6.x / r0.w;
        r6.xyz = r3.xyz * float3(0.30103001, 0.30103001, 0.30103001) + -r3.www;
        r7.xyz = r6.xyz * r0.www;
        r7.xyz = float3(1.44269502, 1.44269502, 1.44269502) * r7.xyz;
        r7.xyz = exp2(r7.xyz);
        r7.xyz = float3(1, 1, 1) + r7.xyz;
        r7.xyz = r5.www / r7.xyz;
        r7.xyz = -cb0[36].www + r7.xyz;
        r0.w = r2.w + r2.w;
        r5.w = cb0[36].x + cb0[36].x;
        r2.w = r5.w / r2.w;
        r3.xyz = r3.xyz * float3(0.30103001, 0.30103001, 0.30103001) + -r4.yyy;
        r3.xyz = r3.xyz * r2.www;
        r3.xyz = float3(1.44269502, 1.44269502, 1.44269502) * r3.xyz;
        r3.xyz = exp2(r3.xyz);
        r3.xyz = float3(1, 1, 1) + r3.xyz;
        r3.xyz = r0.www / r3.xyz;
        r3.xyz = -r3.xyz + r1.www;
        r8.xyz = cmp(r5.xyz < r3.www);
        r7.xyz = r8.xyz ? r7.xyz : r4.xzw;
        r5.xyz = cmp(r4.yyy < r5.xyz);
        r3.xyz = r5.xyz ? r3.xyz : r4.xzw;
        r0.w = r4.y + -r3.w;
        r4.xzw = saturate(r6.xyz / r0.www);
        r0.w = cmp(r4.y < r3.w);
        r5.xyz = float3(1, 1, 1) + -r4.xzw;
        r4.xyz = r0.www ? r5.xyz : r4.xzw;
        r5.xyz = -r4.xyz * float3(2, 2, 2) + float3(3, 3, 3);
        r4.xyz = r4.xyz * r4.xyz;
        r4.xyz = r4.xyz * r5.xyz;
        r3.xyz = r3.xyz + -r7.xyz;
        r3.xyz = r4.xyz * r3.xyz + r7.xyz;
        r0.w = dot(r3.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
        r3.xyz = r3.xyz + -r0.www;
        r3.xyz = r3.xyz * float3(0.930000007, 0.930000007, 0.930000007) + r0.www;
        r3.xyz = max(float3(0, 0, 0), r3.xyz);
        r3.xyz = r3.xyz + -r0.xyz;
        r0.xyz = cb0[66].zzz * r3.xyz + r0.xyz;
        r3.x = dot(float3(1.06537485, 1.44678506e-06, -0.0653710067), r0.xyz);
        r3.y = dot(float3(-3.45525592e-07, 1.20366347, -0.203667715), r0.xyz);
        r3.z = dot(float3(1.9865448e-08, 2.12079581e-08, 0.999999583), r0.xyz);
        
        r3.xyz = r3.xyz + -r0.xyz;
        r0.xyz = cb0[66].xxx * r3.xyz + r0.xyz;
        //ACES AP0_2_sRGB [ https://github.com/Unity-Technologies/PostProcessing/blob/v2/PostProcessing/Shaders/ACES.hlsl ]
        r3.x = dot(float3(1.70505154, -0.621790707, -0.0832583979), r0.xyz);
        r3.y = dot(float3(-0.130257145, 1.14080286, -0.0105485283), r0.xyz);
        r3.z = dot(float3(-0.0240032747, -0.128968775, 1.15297174), r0.xyz);
	
	// final with lut/color correction
        r2.xyz = max(float3(0, 0, 0), r3.xyz);
    }
    r0.xyz = r2.xyz * r2.xyz;
    r2.xyz = cb0[26].yyy * r2.xyz;
    r0.xyz = cb0[26].xxx * r0.xyz + r2.xyz;
    r0.xyz = cb0[26].zzz + r0.xyz;
    r2.xyz = cb0[42].yzw * r0.xyz;
    r0.xyz = -r0.xyz * cb0[42].yzw + cb0[43].xyz;
    r0.xyz = cb0[43].www * r0.xyz + r2.xyz;
    r2.xyz = max(float3(0, 0, 0), r0.xyz);
  //r2.xyz = log2(r2.xyz);
  //r2.xyz = cb0[27].yyy * r2.xyz;
    if (cb0[65].z == 0)
    {
    //r2.xyz = float3(0.416666657,0.416666657,0.416666657) * r2.xyz; // main color correction
    //r2.xyz = exp2(r2.xyz);
        r2.xyz = sign(r2.xyz) * pow(r2.xyz, 1 / 2.4); //2.4 gamma
        r2.xyz = r2.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997); // slightly touches shadows
        o0.xyz = r2.xyz;
        return;
    }
  //o0.xyz = float3(0.952381015,0.952381015,0.952381015) * r2.xyz;
    o0.w = 0;
    return;
}