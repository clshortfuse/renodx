// Mechanically reconstructed from 0xBD2144F9.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler2D s12 : register(s12);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD4;
    float4 v5 : TEXCOORD5;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    const float4 c0 = float4(-0.5f, 1.0f, 0.0f, 0.5f);
    const float4 c1 = float4(31.875f, 4.0f, -2.0f, 0.25f);
    const float4 c2 = float4(0.600000024f, 0.400000006f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = tex2D(s0, v1.xy);
    r2 = (v5.xyzx) * (c0.yyyz) + (c0.zzzy);
    r1.w = dot(r2, c[22]);
    r1.w = 1.0f / (r1.w);
    r1.x = dot(r2, c[11]);
    r1.y = dot(r2, c[20]);
    r1 = (r1.wwww) * (r1.xxyy);
    r3 = (r1) * (c[23].zwxy);
    r3.x = log2(abs(r3.x));
    r3.y = log2(abs(r3.y));
    r3.z = log2(abs(r3.z));
    r3.w = log2(abs(r3.w));
    r3 = (r3) * (c[24].xxxx);
    r3.x = exp2(r3.x);
    r3.y = exp2(r3.y);
    r3.z = exp2(r3.z);
    r3.w = exp2(r3.w);
    r3.xy = (r3.zw) + (r3.xy);
    r3.x = log2(abs(r3.x));
    r3.y = log2(abs(r3.y));
    r3.xy = (r3.xy) * (c[24].yy);
    r3.x = exp2(r3.x);
    r3.y = exp2(r3.y);
    r3.z = dot(r2, c[21]);
    r1.z = (r3.x) * (c[25].x);
    r1.y = (r3.y) * (c[25].y) + (-(r1.z));
    r1.z = c[25].y;
    r1.z = (r3.y) * (r1.z) + (-(c[24].z));
    r1.y = 1.0f / (r1.y);
    r3.xy = abs(r1.xw);
    r4.w = saturate((r1.z) * (r1.y));
    r2 = c[9];
    r2 = saturate((r3.zyxz) * (r2) + (c[10]));
    r4.x = (r2.w) * (r2.x);
    r4.yz = r2.yz;
    r2 = (r4) * (r4);
    r4 = (c[25].zzzz) * (r4) + (c[25].wwww);
    r2 = (r2) * (r4);
    r1.y = (r0.w) * (v0.w) + (c0.x);
    r1.z = (r2.z) * (r2.y);
    r0.w = abs(c[24].w);
    r3.w = (r3.z) * (r3.z);
    r2.w = ((-(r0.w)) >= 0.0f ? (r1.z) : (r2.w));
    r1.z = dot(c[8].yz, r3.zw) + (c[8].x);
    r0 = (r0.xyzx) * (c0.yyyz) + (c0.zzzy);
    r1.z = (r2.w) * (r1.z);
    r0 = float4(((r1.y) >= 0.0f ? (r0.x) : (c0.z)), ((r1.y) >= 0.0f ? (r0.y) : (c0.z)), ((r1.y) >= 0.0f ? (r0.z) : (c0.z)), ((r1.y) >= 0.0f ? (r0.w) : (c0.z)));
    r3.w = (r2.x) * (r1.z);
    r2.xz = c[7].xz;
    r2.x = dot(r1.xw, c[26].xy) + (r2.x);
    r2.y = dot(r1.xw, c[26].zw) + (r2.z);
    r1 = tex2D(s2, r2.xy);
    r3.xyz = (r1.xyz) * (r1.xyz);
    r1.xy = (v4.ww) * (c[27].xy) + (v4.xy);
    r1.zw = v4.zw;
    r1 = tex2Dproj(s1, r1);
    r2.xy = (v4.ww) * (-(c[27].xy)) + (v4.xy);
    r2.zw = v4.zw;
    r2 = tex2Dproj(s1, r2);
    r1.y = r2.x;
    r2.xy = (v4.ww) * (c[27].zw) + (v4.xy);
    r2.zw = v4.zw;
    r2 = tex2Dproj(s1, r2);
    r1.z = r2.x;
    r2.xy = (v4.ww) * (-(c[27].zw)) + (v4.xy);
    r2.zw = v4.zw;
    r2 = tex2Dproj(s1, r2);
    r1.w = r2.x;
    r4.xyz = (r3.www) * (r3.xyz);
    r4.w = dot(r1, c1.wwww);
    r2 = tex2D(s12, v1.zw);
    r1.xy = (v1.zw) * (c0.yw);
    r3 = tex2D(s13, r1.xy);
    r1.xy = (v1.zw) * (c0.yw) + (c0.zw);
    r1 = tex2D(s13, r1.xy);
    r3.w = r1.y;
    r1.w = lerp(r2.y, r4.w, c[7].w);
    r2.xy = (r3.yw) * (c1.yy) + (c1.zz);
    r4.xyz = (r4.xyz) * (r1.www);
    r1.w = dot(r2.xy, r2.xy) + (c0.z);
    r2 = tex2D(s14, v1.zw);
    r5.xy = (r2.xy) * (c1.xx);
    r1.w = exp2(-(r1.w));
    r3.xy = (r3.xz) * (r5.xx);
    r1.w = saturate((r1.w) * (c2.x) + (c2.y));
    r2.w = (r2.x) * (c1.x) + (-(r3.x));
    r2.xz = (r3.xy) * (c1.yy);
    r1.xy = (r1.xz) * (r5.yy);
    r3.w = (r3.z) * (-(r5.x)) + (r2.w);
    r2.w = (r2.y) * (c1.x) + (-(r1.x));
    r2.y = (r3.w) + (r3.w);
    r2.w = (r1.z) * (-(r5.y)) + (r2.w);
    r1.xz = (r1.xy) * (c1.yy);
    r1.y = (r2.w) + (r2.w);
    r2.xyz = (r1.xyz) * (r1.www) + (r2.xyz);
    r3.xyz = (-(v5.xyz)) + (c[5].xyz);
    r1.xyz = normalize(r3.xyz);
    r3.xyz = normalize(v2.xyz);
    r2.xyz = (r0.www) * (r2.xyz);
    r1.w = saturate(dot(r1.xyz, r3.xyz));
    r0.xyz = (r0.xyz) * (v0.xyz);
    r1.xyz = (r1.www) * (c[6].xyz);
    r1.xyz = (r4.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (-(v3.xyz));
    r1.x = v2.w;
    r0.xyz = (r1.xxx) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[29].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = (r0.w) * (c[28].w);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
