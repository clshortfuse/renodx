// Mechanically reconstructed from 0x9C3F0D3A.ps_3_0.cso.
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
sampler3D s11 : register(s11);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD2;
    float4 v5 : TEXCOORD3;
    float4 v6 : TEXCOORD4;
    float4 v7 : TEXCOORD5;
    float4 v8 : TEXCOORD6;
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
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(-2.0f, 3.0f, 31.875f, 0.25f);
    const float4 c2 = float4(1.0f, 0.0f, 0.5f, 0.0f);
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

    r0.xy = (v6.ww) * (c[34].xy) + (v6.xy);
    r0.zw = v6.zw;
    r1 = tex2Dproj(s2, r0);
    r0.xy = (v6.ww) * (-(c[34].xy)) + (v6.xy);
    r0.zw = v6.zw;
    r0 = tex2Dproj(s2, r0);
    r1.y = r0.x;
    r0.xy = (v6.ww) * (c[34].zw) + (v6.xy);
    r0.zw = v6.zw;
    r0 = tex2Dproj(s2, r0);
    r1.z = r0.x;
    r0.xy = (v6.ww) * (-(c[34].zw)) + (v6.xy);
    r0.zw = v6.zw;
    r2 = tex2Dproj(s2, r0);
    r0.xy = (v1.xy) * (c[36].xy);
    r0 = tex2D(s4, r0.xy);
    r3.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0 = tex2D(s1, v1.xy);
    r0.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r3.xy = (c[36].zz) * (r3.xy) + (r0.xy);
    r0 = v2;
    r0.xyz = (r3.xxx) * (v5.xyz) + (r0.xyz);
    r0.xyz = (r3.yyy) * (v4.xyz) + (r0.xyz);
    r8.xyz = normalize(r0.xyz);
    r2.w = max(abs(r8.y), abs(r8.z));
    r1.w = r2.x;
    r0.z = max(abs(r8.x), r2.w);
    r2.w = 1.0f / (r0.z);
    r0.xyz = (r8.xyz) * (c[5].xyz);
    r3.w = dot(r1, c1.wwww);
    r0.xyz = (r0.xyz) * (r2.www) + (v8.xyz);
    r1 = tex3D(s11, r0.xyz);
    r0.xyz = (-(v7.xyz)) + (c[28].xyz);
    r3.y = dot(r0.xyz, r0.xyz);
    r2.z = rsqrt(r3.y);
    r0.xyz = (r0.xyz) * (r2.zzz);
    r2.w = dot(r0.xyz, c[30].xyz);
    r3.x = 1.0f / (r2.z);
    r2.z = saturate((r2.w) * (c[31].x) + (c[31].y));
    r2.w = saturate(dot(r0.xyz, r8.xyz));
    r0.z = (r2.z) * (c[31].w);
    r2.z = lerp(r1.w, r3.w, r0.z);
    r2.xy = saturate((r3.xx) * (c[33].xy) + (c[33].zw));
    r0.xy = (r2.xy) * (r2.xy);
    r2.xy = (r2.xy) * (c1.xx) + (c1.yy);
    r1.w = dot(c[32].yz, r3.xy) + (c[32].x);
    r2.xy = (r0.xy) * (r2.xy);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r1.w = (r1.w) * (r2.x);
    r2.y = (r2.y) * (r1.w);
    r1 = (v7.yyyy) * (c[25]);
    r6.w = (r2.z) * (r2.y);
    r1 = (v7.xxxx) * (c[24]) + (r1);
    r7.xyz = (r0.xyz) * (c1.zzz);
    r1 = (v7.zzzz) * (c[26]) + (r1);
    r6.xyz = (r2.www) * (c[29].xyz);
    r1 = (r1) + (c[27]);
    r4.xy = (r1.ww) * (c[35].xy) + (r1.xy);
    r4.zw = r1.zw;
    r2 = tex2Dproj(s2, r4);
    r3.zw = r4.zw;
    r1.zw = r3.zw;
    r5.xy = (r4.ww) * (-(c[35].zw)) + (r1.xy);
    r5.zw = r1.zw;
    r5 = tex2Dproj(s2, r5);
    r2.w = r5.x;
    r3.xy = (r4.ww) * (-(c[35].xy)) + (r1.xy);
    r1.xy = (r4.ww) * (c[35].zw) + (r1.xy);
    r3 = tex2Dproj(s2, r3);
    r2.y = r3.x;
    r3 = tex2Dproj(s2, r1);
    r1 = (v7.xyzx) * (c2.xxxy) + (c2.yyyx);
    r0.z = dot(r1, c[21]);
    r2.z = r3.x;
    r0.z = 1.0f / (r0.z);
    r0.x = dot(r1, c[10]);
    r0.y = dot(r1, c[11]);
    r2.w = dot(r2, c1.wwww);
    r2.xy = (r0.zz) * (r0.xy);
    r0.x = dot(r1, c[20]);
    r1.xy = (r2.xy) * (c2.zz) + (c2.zz);
    r1 = tex2D(s3, r1.xy);
    r0.y = (r0.x) * (r0.x);
    r0.z = dot(c[8].yz, r0.xy) + (c[8].x);
    r0.xy = saturate((r0.xx) * (c[9].xy) + (c[9].zw));
    r1.w = saturate(1.0f / (r0.z));
    r3.w = ((-abs(r0.z)) >= 0.0f ? (c2.y) : (r1.w));
    r3.xy = (r0.xy) * (r0.xy);
    r4.xy = (r0.xy) * (c1.xx) + (c1.yy);
    r0.xyz = (-(v7.xyz)) + (c[6].xyz);
    r3.z = (r3.x) * (r4.x);
    r2.xyz = normalize(r0.xyz);
    r1.w = (r3.y) * (-(r4.y)) + (c2.x);
    r0.z = dot(r2.xyz, c[22].xyz);
    r0.x = (r3.w) * (r3.z);
    r0.y = saturate((r0.z) * (c[23].x) + (c[23].y));
    r0.z = (r0.y) * (r0.y);
    r0.y = (r0.y) * (c1.x) + (c1.y);
    r1.w = (r1.w) * (r0.x);
    r3.w = (r0.z) * (r0.y);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r1.w = (r1.w) * (r3.w);
    r3.w = saturate(dot(r2.xyz, r8.xyz));
    r2.xyz = (r0.xyz) * (r1.www);
    r1 = tex2D(s0, v1.xy);
    r0.xyz = (r1.xyz) * (v0.xyz);
    r1.xyz = (r3.www) * (c[7].xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r2.xyz = (r2.www) * (r2.xyz);
    r3.xyz = (r1.xyz) * (r0.xyz);
    r1.xyz = (r6.www) * (r6.xyz) + (r7.xyz);
    r2.xyz = (r2.xyz) * (r3.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[37].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c2.x;

    return oC0;
}
