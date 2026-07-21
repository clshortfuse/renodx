// Mechanically reconstructed from 0x519EA118.ps_3_0.cso.
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
    float4 v1 : COLOR1;
    float4 v2 : COLOR0;
    float4 v3 : TEXCOORD5;
    float4 v4 : TEXCOORD2;
    float4 v5 : TEXCOORD9;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    const float4 c0 = float4(0.0f, -1.0f, 1.0f, 31.875f);
    const float4 c1 = float4(0.25f, -2.0f, 3.0f, 0.5f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 oC0 = 0.0f;

    r1.xyz = (-(v3.xyz)) + (c[20].xyz);
    r0.xyz = normalize(r1.xyz);
    r0.w = dot(r0.xyz, c[28].xyz);
    r1.z = saturate((r0.w) * (c[29].x) + (c[29].y));
    r0 = (v3.xyzx) * (c0.zzzx) + (c0.xxxz);
    r1.w = (r1.z) * (r1.z);
    r1.x = dot(r0, c[26]);
    r1.z = (r1.z) * (c1.y) + (c1.z);
    r1.y = (r1.x) * (r1.x);
    r1.w = (r1.w) * (r1.z);
    r1.z = dot(c[22].yz, r1.xy) + (c[22].x);
    r2.xy = saturate((r1.xx) * (c[23].xy) + (c[23].zw));
    r2.w = saturate(1.0f / (r1.z));
    r1.xy = (r2.xy) * (r2.xy);
    r2.xy = (r2.xy) * (c1.yy) + (c1.zz);
    r2.w = ((-abs(r1.z)) >= 0.0f ? (c0.x) : (r2.w));
    r1.x = (r1.x) * (r2.x);
    r2.z = (r1.y) * (-(r2.y)) + (c0.z);
    r1.z = dot(r0, c[27]);
    r2.w = (r2.w) * (r1.x);
    r1.z = 1.0f / (r1.z);
    r1.x = dot(r0, c[24]);
    r1.y = dot(r0, c[25]);
    r0.w = (r2.z) * (r2.w);
    r0.xy = (r1.zz) * (r1.xy);
    r2.w = (r1.w) * (r0.w);
    r0.xy = (r0.xy) * (c1.ww) + (c1.ww);
    r0 = tex2D(s2, r0.xy);
    r2.xyz = (r0.xyz) * (r0.xyz);
    r0.xy = (v5.ww) * (c[30].xy) + (v5.xy);
    r0.zw = v5.zw;
    r0 = tex2Dproj(s1, r0);
    r1.xy = (v5.ww) * (-(c[30].xy)) + (v5.xy);
    r1.zw = v5.zw;
    r1 = tex2Dproj(s1, r1);
    r0.y = r1.x;
    r1.xy = (v5.ww) * (c[30].zw) + (v5.xy);
    r1.zw = v5.zw;
    r1 = tex2Dproj(s1, r1);
    r0.z = r1.x;
    r1.xy = (v5.ww) * (-(c[30].zw)) + (v5.xy);
    r1.zw = v5.zw;
    r1 = tex2Dproj(s1, r1);
    r0.w = r1.x;
    r1.xyz = (r2.www) * (r2.xyz);
    r0.w = dot(r0, c1.xxxx);
    r2.xyz = (r1.xyz) * (r0.www);
    r0 = tex2D(s0, v0.xy);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r3.xyz = (r0.xyz) * (c[21].xyz);
    r1.xyz = (v4.xyz) + (c0.xxy);
    r1.xy = (r1.xy) * (c[31].xx);
    r4.w = c0.z;
    r1.w = (c[31].x) * (r1.z) + (r4.w);
    r4.xyz = (r2.xyz) * (r3.xyz);
    r1.w = saturate(dot(c[17].xyz, r1.xyw));
    r1.xyz = (r1.www) * (c[18].xyz);
    r2.xyz = (v0.zwz) * (c0.zzx) + (c0.xxz);
    r3 = tex3D(s11, r2.xyz);
    r5.xyz = (r1.xyz) * (r3.www);
    r1 = (-(v3.yyyy)) + (c[6]);
    r2 = (r1) * (r1);
    r1 = (-(v3.xxxx)) + (c[5]);
    r2 = (r1) * (r1) + (r2);
    r1 = (-(v3.zzzz)) + (c[7]);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r1 = (r1) * (r1) + (r2);
    r2.xyz = (r3.xyz) * (c0.www) + (r5.xyz);
    r1 = saturate((r1) * (c[8]) + (r4.wwww));
    r3.xyz = (r0.xyz) * (r2.xyz) + (r4.xyz);
    r2.x = dot(c[9], r1);
    r2.y = dot(c[10], r1);
    r2.z = dot(c[11], r1);
    r0.xyz = (r0.xyz) * (r2.xyz) + (r3.xyz);
    r0.xyz = (r0.xyz) + (-(v1.xyz));
    r1.xyz = v1.xyz;
    r0.xyz = (v2.www) * (r0.xyz) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[32].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = r0.w;
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
