// Mechanically reconstructed from 0x095F47AB.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler2D s3 : register(s3);
sampler3D s11 : register(s11);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD3;
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
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(0.5f, 2.0f, -1.0f, 9.99999975e-06f);
    const float4 c2 = float4(1e-15f, 1.44269502f, 0.100000001f, 0.0f);
    const float4 c3 = float4(0.25f, 1.0f, 8.0f, 31.875f);
    const float4 c4 = float4(1.0f, 0.0f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 oC0 = 0.0f;

    r0.x = dot(-(v1.xyz), -(v1.xyz));
    r0.x = rsqrt(r0.x);
    r1.xyz = normalize(c[17].xyz);
    r0.yzw = (-(v1.xyz)) * (r0.xxx) + (r1.xyz);
    r2.xyz = (r0.xxx) * (-(v1.xyz));
    r3.xyz = normalize(r0.yzw);
    r0.xy = (c[20].xx) * (v4.xy);
    r0 = tex2D(s1, r0.xy);
    r0.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0.xy = (r0.xy) * (c1.xx) + (c1.xx);
    r0.xy = (r0.xy) * (c1.yy) + (c1.zz);
    r0.z = dot(v2.xyz, v2.xyz);
    r0.z = rsqrt(r0.z);
    r4.xyz = (r0.zzz) * (v2.xyz);
    r5.xyz = (r4.zxy) * (v3.yzx);
    r5.xyz = (r4.yzx) * (v3.zxy) + (-(r5.xyz));
    r5.xyz = (r5.xyz) * (v3.www);
    r5.xyz = (r0.yyy) * (r5.xyz);
    r0.xyw = (r0.xxx) * (v3.xyz) + (r5.xyz);
    r0.xyz = (v2.xyz) * (r0.zzz) + (r0.xyw);
    r5.xyz = normalize(r0.xyz);
    r0.x = saturate(dot(r5.xyz, r3.xyz));
    r0.y = (r0.x) + (r0.x);
    r0.x = (r0.x) * (r0.x) + (c2.x);
    r0.x = 1.0f / (r0.x);
    r0.z = saturate(dot(r5.xyz, r2.xyz));
    r0.w = saturate(dot(r4.xyz, r2.xyz));
    r0.w = (r0.z) + (r0.w);
    r0.w = (r0.w) * (c1.x);
    r1.w = max(c2.z, r0.w);
    r0.w = 1.0f / (r1.w);
    r0.w = rsqrt(r0.w);
    r0.w = 1.0f / (r0.w);
    r1.w = 1.0f / (r0.z);
    r0.y = (r0.y) * (r1.w);
    r1.x = saturate(dot(r5.xyz, r1.xyz));
    r2.x = min(r0.z, r1.x);
    r0.y = saturate((r0.y) * (r2.x));
    r0.y = (r1.x) * (r0.y);
    r0.y = rsqrt(r0.y);
    r0.y = 1.0f / (r0.y);
    r0.z = (-(r0.x)) + (-(c1.z));
    r0.x = (r0.x) * (r0.x);
    r2 = tex2D(s3, v4.xy);
    r1.y = (r2.x) * (c[23].x);
    r2.xyz = (r2.xyz) * (c[11].xxx);
    r2.w = max(c1.w, r1.y);
    r1.y = (r2.w) * (r2.w);
    r1.y = 1.0f / (r1.y);
    r0.z = (r0.z) * (r1.y);
    r0.z = (r0.z) * (c2.y);
    r0.z = exp2(r0.z);
    r0.x = (r0.x) * (r0.z);
    r0.x = (r0.y) * (r0.x);
    r0.y = max(abs(r4.y), abs(r4.z));
    r1.z = max(abs(r4.x), r0.y);
    r3.xyz = (r4.xyz) * (c[5].xyz);
    r0.y = 1.0f / (r1.z);
    r3.xyz = (r3.xyz) * (r0.yyy) + (v5.xyz);
    r3 = tex3D(s11, r3.xyz);
    r3.xyz = (r3.www) * (c[19].xyz);
    r4.xyz = (r3.www) * (c[18].xyz);
    r4.xyz = (r4.xyz) * (c[6].xxx);
    r1.xzw = (r1.xxx) * (r4.xyz);
    r3.xyz = (r3.xyz) * (c[6].yyy);
    r0.xyz = (r0.xxx) * (r3.xyz);
    r0.xyz = (r0.www) * (r0.xyz);
    r0.xyz = (r1.yyy) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c[22].xxx);
    r0.xyz = (r0.xyz) * (c3.xxx) + (c3.yyy);
    r3.x = log2(abs(r0.x));
    r3.y = log2(abs(r0.y));
    r3.z = log2(abs(r0.z));
    r0.w = c2.w;
    r1.y = max(c[21].x, r0.w);
    r0.x = (r1.y) + (c1.z);
    r0.xyz = (r3.xyz) * (r0.xxx);
    r3.x = exp2(r0.x);
    r3.y = exp2(r0.y);
    r3.z = exp2(r0.z);
    r0.xyz = normalize(v1.xyz);
    r0.w = dot(r0.xyz, r5.xyz);
    r0.w = (r0.w) + (r0.w);
    r0.xyz = (r5.xyz) * (-(r0.www)) + (r0.xyz);
    r0 = texCUBE(s15, r0.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c3.zzz);
    r4 = tex3D(s11, v5.xyz);
    r4.xyz = (r4.xyz) * (r4.xyz);
    r0.xyz = (r0.xyz) * (r4.xyz);
    r0.xyz = (r0.xyz) * (c3.www);
    r0.xyz = (r2.xyz) * (r0.xyz);
    r0.xyz = (r3.xyz) * (c[21].yyy) + (r0.xyz);
    r0.xyz = (r0.xyz) * (c[24].xxx);
    r0.w = max(abs(r5.y), abs(r5.z));
    r1.y = max(abs(r5.x), r0.w);
    r2.xyz = (r5.xyz) * (c[5].xyz);
    r0.w = 1.0f / (r1.y);
    r2.xyz = (r2.xyz) * (r0.www) + (v5.xyz);
    r2 = tex3D(s11, r2.xyz);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r1.xyz = (r2.xyz) * (c3.www) + (r1.xzw);
    r2.xy = ddx(v4.xy);
    r2.zw = ddy(v4.xy);
    r2 = tex2Dgrad(s2, v4.xy, r2.xy, r2.zw);
    r2 = (r2) * (r2);
    r2.xyz = (r1.xyz) * (r2.xyz) + (r0.xyz);
    r0 = max(r2, c2.wwww);
    r1 = (r0.xyzx) * (c4.xxxy) + (c4.yyyx);
    oC0.w = r0.w;
    r0.x = dot(r1, c[8]);
    r0.y = dot(r1, c[9]);
    r0.z = dot(r1, c[10]);
    r0.w = v1.w;
    r1.xyz = lerp(v0.xyz, r0.xyz, r0.www);
    r0.xyz = max(((r1.xyz) * (c[7].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    oC0.x = 1.0f / (r0.x);
    r0.x = rsqrt(r0.y);
    r0.y = rsqrt(r0.z);
    oC0.z = 1.0f / (r0.y);
    oC0.y = 1.0f / (r0.x);

    return oC0;
}
