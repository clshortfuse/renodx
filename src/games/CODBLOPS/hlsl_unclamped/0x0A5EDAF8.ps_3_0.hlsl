// Mechanically reconstructed from 0x0A5EDAF8.ps_3_0.cso.
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
sampler2D s4 : register(s4);
sampler2D s5 : register(s5);
sampler3D s11 : register(s11);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : TEXCOORD1;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD3;
    float4 v4 : TEXCOORD4;
    float4 v5 : TEXCOORD5;
    float4 v6 : TEXCOORD6;
    float4 v7 : TEXCOORD7;
    float4 v8 : TEXCOORD8;
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
    float4 v8 = input.v8;
    const float4 c1 = float4(-0.5f, 0.5f, 4.06451607f, -2.06451607f);
    const float4 c2 = float4(4.0f, -0.5f, -2.07999992f, 0.25f);
    const float4 c3 = float4(-2.0f, 3.0f, 200.0f, 31.875f);
    const float4 c4 = float4(0.0f, 8.0f, 1.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 r8 = 0.0f;
    float4 r9 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (v0.ww) * (c[20].xy) + (v0.xy);
    r0.zw = v0.zw;
    r0 = tex2Dproj(s0, r0);
    r1.xy = (v0.ww) * (-(c[20].xy)) + (v0.xy);
    r1.zw = v0.zw;
    r1 = tex2Dproj(s0, r1);
    r0.y = r1.x;
    r1.xy = (v0.ww) * (c[20].zw) + (v0.xy);
    r1.zw = v0.zw;
    r1 = tex2Dproj(s0, r1);
    r0.z = r1.x;
    r1.xy = (v0.ww) * (-(c[20].zw)) + (v0.xy);
    r1.zw = v0.zw;
    r1 = tex2Dproj(s0, r1);
    r4.xy = c1.xy;
    r2.xy = (v8.xy) * (c[27].xx) + (r4.xx);
    r2.xy = (r2.xy) * (c[28].xx) + (r4.yy);
    r2 = tex2D(s2, r2.xy);
    r9.xy = (v8.xy) * (c[27].xx);
    r0.w = (r2.y) * (c1.z) + (c1.w);
    r3.xy = (r9.xy) * (c2.xx) + (c2.yy);
    r2.y = (r0.w) * (c1.z) + (c1.w);
    r3.xy = (r3.xy) * (c[29].xx) + (r4.yy);
    r3 = tex2D(s3, r3.xy);
    r0.w = (r3.y) * (c1.z) + (c1.w);
    r2.w = (r0.w) * (c1.z) + (c1.w);
    r2.xz = c2.zz;
    r5.xy = (r2.zw) * (c[31].xx);
    r3.xyz = v7.xyz;
    r4.xyz = (r3.zxy) * (v5.yzx);
    r5.xy = (c[30].xx) * (r2.xy) + (r5.xy);
    r2.xyz = (r3.yzx) * (v5.zxy) + (-(r4.xyz));
    r2.xyz = (r5.yyy) * (-(r2.xyz));
    r2.xyz = (r5.xxx) * (v5.xyz) + (r2.xyz);
    r2.xyz = (r2.xyz) + (v7.xyz);
    r3.xyz = normalize(r2.xyz);
    r2.w = max(abs(r3.y), abs(r3.z));
    r0.w = r1.x;
    r1.w = max(abs(r3.x), r2.w);
    r1.w = 1.0f / (r1.w);
    r1.xyz = (r3.xyz) * (c[5].xyz);
    r2.z = dot(r0, c2.wwww);
    r0.xyz = (r1.xyz) * (r1.www) + (v1.xyz);
    r0 = tex3D(s11, r0.xyz);
    r1.xyz = (-(v6.xyz)) + (c[6].xyz);
    r2.y = dot(r1.xyz, r1.xyz);
    r2.w = rsqrt(r2.y);
    r5.xyz = (r1.xyz) * (r2.www);
    r1.w = dot(r5.xyz, c[8].xyz);
    r1.w = saturate((r1.w) * (c[9].x) + (c[9].y));
    r2.x = 1.0f / (r2.w);
    r2.w = (r1.w) * (c[9].w);
    r1.w = lerp(r0.w, r2.z, r2.w);
    r0.w = dot(-(v6.xyz), -(v6.xyz));
    r4.xyz = (r0.xyz) * (r0.xyz);
    r0.w = rsqrt(r0.w);
    r2.w = dot(c[10].yz, r2.xy) + (c[10].x);
    r0.xyz = (r0.www) * (-(v6.xyz));
    r2.xy = saturate((r2.xx) * (c[11].xy) + (c[11].zw));
    r1.z = dot(-(r0.xyz), r3.xyz);
    r1.xy = (r2.xy) * (r2.xy);
    r1.z = (r1.z) + (r1.z);
    r2.xy = (r2.xy) * (c3.xx) + (c3.yy);
    r0.xyz = (r3.xyz) * (-(r1.zzz)) + (-(r0.xyz));
    r2.xy = (r1.xy) * (r2.xy);
    r1.xyz = (r0.yyy) * (v3.xyw);
    r2.w = (r2.w) * (r2.x);
    r1.xyz = (r0.xxx) * (v2.xyw) + (r1.xyz);
    r2.w = (r2.y) * (r2.w);
    r7.xyz = (r0.zzz) * (v4.xyw) + (r1.xyz);
    r1.z = (r1.w) * (r2.w);
    r1.w = 1.0f / (r7.z);
    r2.xyz = (r1.zzz) * (c[7].xyz);
    r7.xy = (r7.xy) * (r1.ww);
    r8.xyz = (-(v6.xyz)) * (r0.www) + (r5.xyz);
    r1.xy = (r7.xy) * (c1.yx) + (c1.yy);
    r1 = tex2D(s1, r1.xy);
    r6.xyz = (r1.xyz) * (r1.xyz);
    r0.w = c4.x;
    r0 = texCUBElod(s15, r0);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.w = 1.0f / (c[24].x);
    r1.xyz = (r0.xyz) * (c[25].xxx);
    r0.xyz = (r6.xyz) * (r0.www);
    r1.xyz = (r1.xyz) * (c4.yyy);
    r0.w = max(abs(r7.x), abs(r7.y));
    r0.xyz = (r0.xyz) * (c[26].xxx) + (-(r1.xyz));
    r0.w = saturate((r0.w) * (-(r0.w)) + (c4.z));
    r6.xyz = normalize(r8.xyz);
    r0.w = ((-(r7.z)) >= 0.0f ? (c4.x) : (r0.w));
    r1.w = saturate(dot(r3.xyz, r6.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (r1.xyz);
    r0.w = pow(abs(r1.w), c3.z);
    r2.w = saturate(dot(r3.xyz, r5.xyz));
    r3.xyz = (r0.www) * (r2.xyz) + (r0.xyz);
    r1 = tex2D(s5, r9.xy);
    r0 = tex2D(s4, r9.xy);
    r3.xyz = (r3.xyz) * (r1.xyz);
    r1.xyz = (r4.xyz) * (c3.www);
    r1.xyz = (r2.www) * (r2.xyz) + (r1.xyz);
    r4.xyz = normalize(v6.xyz);
    r2.xyz = (r0.xyz) * (r0.xyz);
    r0.z = dot(c[21].xyz, r4.xyz);
    r1.w = saturate((c[23].y) * (r0.z) + (c[23].x));
    r0.xyz = c[0].xyz;
    r0.xyz = (-(r0.xyz)) + (c[22].xyz);
    r1.xyz = (r1.xyz) * (r2.xyz) + (r3.xyz);
    r0.xyz = (r1.www) * (r0.xyz) + (c[0].xyz);
    r1.xyz = (r0.xyz) * (-(c[0].www)) + (r1.xyz);
    r1.xyz = (r1.xyz) * (v6.www);
    r0.xyz = (r0.xyz) * (c[0].www) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[24].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = r0.w;
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
