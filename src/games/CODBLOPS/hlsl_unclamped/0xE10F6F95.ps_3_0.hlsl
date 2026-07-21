// Mechanically reconstructed from 0xE10F6F95.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler2D s3 : register(s3);
sampler3D s11 : register(s11);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD3;
    float4 v4 : TEXCOORD4;
    float4 v5 : TEXCOORD5;
    float4 v6 : TEXCOORD6;
    float4 v7 : TEXCOORD7;
    float2 vPosInput : VPOS;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    float4 v6 = input.v6;
    float4 v7 = input.v7;
    float4 vPos = float4(input.vPosInput.xy, 0.0f, 0.0f);
    const float4 c0 = float4(0.999511719f, 9.99999994e-09f, 1.0f, 0.5f);
    const float4 c1 = float4(1.0f, 0.0f, 31.875f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 r8 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (vPos.xy) * (c[28].zw);
    r0 = tex2D(s3, r0.xy);
    r1.w = (-abs(r0.x)) + (c0.x);
    r0.w = max(c0.y, r1.w);
    r0.y = 1.0f / (r0.w);
    r0.w = c0.x;
    r0.z = (r0.w) * (c[4].x);
    r0.w = 1.0f / (v0.z);
    r0.z = (r0.y) * (r0.z);
    r0.xy = (r0.ww) * (v0.xy);
    r0.xy = (r0.zz) * (r0.xy);
    r0.w = c0.z;
    r2.y = dot(r0, v3);
    r2.z = dot(r0, v4);
    r2.x = dot(r0, v2);
    r1.xyz = (r2.xyz) * (c0.www) + (c0.www);
    r7.w = (-abs(r2.x)) + (c0.z);
    r0 = r1.xxxx;
    clip(r0.wwxx);
    r0 = r1.yyyy;
    clip(r0.wwxx);
    r0 = r1.zzzz;
    clip(r0.wwxx);
    r0 = (-(r1.xxxx)) + (c0.zzzz);
    clip(r0.wwxx);
    r2 = (-(r1.yyyy)) + (c0.zzzz);
    r0 = tex2D(s0, r1.yz);
    r4 = (v6.xyzx) * (c1.xxxy) + (c1.yyyx);
    r1.w = dot(r4, c[23]);
    r1.w = 1.0f / (r1.w);
    r1.x = dot(r4, c[20]);
    r1.y = dot(r4, c[21]);
    r3 = (r1.wwww) * (r1.xxyy);
    r5 = (r3) * (c[24].zwxy);
    r5.x = log2(abs(r5.x));
    r5.y = log2(abs(r5.y));
    r5.z = log2(abs(r5.z));
    r5.w = log2(abs(r5.w));
    r5 = (r5) * (c[25].xxxx);
    r5.x = exp2(r5.x);
    r5.y = exp2(r5.y);
    r5.z = exp2(r5.z);
    r5.w = exp2(r5.w);
    r1.xy = (r5.zw) + (r5.xy);
    r1.x = log2(abs(r1.x));
    r1.y = log2(abs(r1.y));
    r1.xy = (r1.xy) * (c[25].yy);
    r1.x = exp2(r1.x);
    r1.y = exp2(r1.y);
    r5.z = dot(r4, c[22]);
    r1.w = (r1.x) * (c[26].x);
    r1.x = (r1.y) * (c[26].y) + (-(r1.w));
    r1.w = c[26].y;
    r1.w = (r1.y) * (r1.w) + (-(c[25].z));
    r1.y = 1.0f / (r1.x);
    r5.xy = abs(r3.xw);
    r6.w = saturate((r1.w) * (r1.y));
    r4 = c[10];
    r4 = saturate((r5.zyxz) * (r4) + (c[11]));
    r6.x = (r4.w) * (r4.x);
    r6.yz = r4.yz;
    r4 = (r6) * (r6);
    r6 = (c[26].zzzz) * (r6) + (c[26].wwww);
    r4 = (r4) * (r6);
    r1.y = (r4.z) * (r4.y);
    r1.w = abs(c[25].w);
    r5.w = (r5.z) * (r5.z);
    r1.y = ((-(r1.w)) >= 0.0f ? (r1.y) : (r4.w));
    r1.w = dot(c[9].yz, r5.zw) + (c[9].x);
    r1.w = (r1.y) * (r1.w);
    r4.w = (r4.x) * (r1.w);
    r4.xz = c[8].xz;
    r1.x = dot(r3.xw, c[27].xy) + (r4.x);
    r1.y = dot(r3.xw, c[27].zw) + (r4.z);
    r3 = tex2D(s2, r1.xy);
    r5.xyz = (r3.xyz) * (r3.xyz);
    r4.x = v5.w;
    r6.xyz = normalize(v5.xyz);
    r4.y = v0.w;
    r3.w = max(abs(r6.y), abs(r6.z));
    r4.z = v1.z;
    r1.w = max(abs(r6.x), r3.w);
    r1.w = 1.0f / (r1.w);
    r3.xyz = (r6.xyz) * (c[5].xyz);
    r7.xyz = (r4.www) * (r5.xyz);
    r3.xyz = (r3.xyz) * (r1.www) + (r4.xyz);
    r3 = tex3D(s11, r3.xyz);
    r4 = tex2Dproj(s1, v7);
    r1.w = lerp(r3.w, r4.x, c[8].w);
    r8.xyz = (-(v6.xyz)) + (c[6].xyz);
    r4.xyz = (r3.xyz) * (r3.xyz);
    r5.xyz = normalize(r8.xyz);
    r3.xyz = (r7.xyz) * (r1.www);
    r1.w = saturate(dot(r5.xyz, r6.xyz));
    r5.xyz = (r4.xyz) * (c1.zzz);
    r4.xyz = (r1.www) * (c[7].xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r3.xyz = (r3.xyz) * (r4.xyz) + (r5.xyz);
    clip(r2.wwxx);
    r0.xyz = (r0.xyz) * (r3.xyz);
    r1 = (-(r1.zzzz)) + (c0.zzzz);
    r0.xyz = max(((r0.xyz) * (c[29].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    clip(r1.wwxx);
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = (r7.w) * (r0.w);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
