// Mechanically reconstructed from 0xD50CCF57.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler3D s11 : register(s11);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD4;
    float4 v3 : TEXCOORD5;
    float4 v4 : TEXCOORD7;
    float4 v5 : COLOR0;
    float4 v6 : TEXCOORD8;
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
    const float4 c0 = float4(31.875f, -3.0f, 1.0f, 0.0f);
    const float4 c1 = float4(0.000244140625f, 0.0f, -0.000244140625f, 0.25f);
    const float4 c2 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.5f);
    const float4 c3 = float4(-2.0f, 3.0f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = tex2D(s0, v0.xy);
    r2 = (v4.xyzx) * (c0.zzzw);
    r1 = (r2) + (c1.xxyy);
    r1 = tex2Dlod(s1, r1);
    r3 = (r2) + (c1.zzyy);
    r3 = tex2Dlod(s1, r3);
    r1.y = r3.x;
    r3 = (r2) + (c2.xyzz);
    r2 = (r2) + (-(c2.xyzz));
    r3 = tex2Dlod(s1, r3);
    r1.z = r3.x;
    r2 = tex2Dlod(s1, r2);
    r3.xyz = normalize(v1.xyz);
    r4.w = max(abs(r3.y), abs(r3.z));
    r1.w = r2.x;
    r2.w = max(abs(r3.x), r4.w);
    r2.w = 1.0f / (r2.w);
    r2.xyz = (r3.xyz) * (c[5].xyz);
    r4.w = dot(r1, c1.wwww);
    r1.xyz = (r2.xyz) * (r2.www) + (v2.xyz);
    r1 = tex3D(s11, r1.xyz);
    r3.w = saturate((v4.w) + (c0.y));
    r2.w = saturate(dot(r3.xyz, c[17].xyz));
    r2.z = lerp(r4.w, r1.w, r3.w);
    r0.xyz = (r0.xyz) * (c[31].xyz);
    r1.w = (r2.w) * (r2.z);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r1.w = (r1.w) * (c[33].x) + (c[33].y);
    r2.xyz = (r1.www) * (c[18].xyz);
    r4.xyz = (-(v6.xyz)) + (c[21].xyz);
    r3.xyz = (r1.xyz) * (v0.zzz);
    r1.xyz = normalize(r4.xyz);
    r3.xyz = (r3.xyz) * (c0.xxx);
    r1.w = dot(r1.xyz, c[29].xyz);
    r3.w = saturate((r1.w) * (c[30].x) + (c[30].y));
    r1 = (v6.xyzx) * (c0.zzzw) + (c0.wwwz);
    r2.w = (r3.w) * (r3.w);
    r4.x = dot(r1, c[27]);
    r3.w = (r3.w) * (c3.x) + (c3.y);
    r4.y = (r4.x) * (r4.x);
    r2.w = (r2.w) * (r3.w);
    r3.w = dot(c[23].yz, r4.xy) + (c[23].x);
    r5.xy = saturate((r4.xx) * (c[24].xy) + (c[24].zw));
    r4.w = saturate(1.0f / (r3.w));
    r4.xy = (r5.xy) * (r5.xy);
    r5.xy = (r5.xy) * (c3.xx) + (c3.yy);
    r4.w = ((-abs(r3.w)) >= 0.0f ? (c0.w) : (r4.w));
    r4.x = (r4.x) * (r5.x);
    r4.z = (r4.y) * (-(r5.y)) + (c0.z);
    r3.w = dot(r1, c[28]);
    r4.w = (r4.w) * (r4.x);
    r3.w = 1.0f / (r3.w);
    r4.x = dot(r1, c[25]);
    r4.y = dot(r1, c[26]);
    r1.w = (r4.z) * (r4.w);
    r1.xy = (r3.ww) * (r4.xy);
    r2.w = (r2.w) * (r1.w);
    r1.xy = (r1.xy) * (c2.ww) + (c2.ww);
    r1 = tex2D(s2, r1.xy);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r3.xyz = (r2.xyz) * (v5.xyz) + (r3.xyz);
    r4.xyz = (r2.www) * (r1.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1 = (-(v6.yyyy)) + (c[7]);
    r2 = (r1) * (r1);
    r1 = (-(v6.xxxx)) + (c[6]);
    r2 = (r1) * (r1) + (r2);
    r1 = (-(v6.zzzz)) + (c[8]);
    r5.xyz = (r0.xyz) * (c[22].xyz);
    r1 = (r1) * (r1) + (r2);
    r2.xyz = (r4.xyz) * (r5.xyz);
    r2.w = c0.z;
    r1 = saturate((r1) * (c[9]) + (r2.wwww));
    r3.xyz = (r0.xyz) * (r3.xyz) + (r2.xyz);
    r2.x = dot(c[10], r1);
    r2.y = dot(c[11], r1);
    r2.z = dot(c[20], r1);
    r0.xyz = (r0.xyz) * (r2.xyz) + (r3.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r1.x = v2.w;
    r0.xyz = (r1.xxx) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[32].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = saturate((r0.w) + (r0.w));
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
