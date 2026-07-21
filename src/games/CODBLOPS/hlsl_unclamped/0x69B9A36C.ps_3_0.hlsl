// Mechanically reconstructed from 0x69B9A36C.ps_3_0.cso.
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
    const float4 c3 = float4(4.0f, -0.5f, -2.07999992f, 1.0f);
    const float4 c4 = float4(1.0f, 0.0f, 0.000244140625f, -0.000244140625f);
    const float4 c12 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.25f);
    const float4 c13 = float4(0.75f, 4.0f, -3.0f, 200.0f);
    const float4 c14 = float4(31.875f, 8.0f, 0.0f, 0.0f);
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

    r2.xy = c1.xy;
    r0.xy = (v8.xy) * (c[27].xx) + (r2.xx);
    r0.xy = (r0.xy) * (c[28].xx) + (r2.yy);
    r0 = tex2D(s2, r0.xy);
    r9.xy = (v8.xy) * (c[27].xx);
    r0.w = (r0.y) * (c1.z) + (c1.w);
    r1.xy = (r9.xy) * (c3.xx) + (c3.yy);
    r0.y = (r0.w) * (c1.z) + (c1.w);
    r1.xy = (r1.xy) * (c[29].xx) + (r2.yy);
    r1 = tex2D(s3, r1.xy);
    r0.w = (r1.y) * (c1.z) + (c1.w);
    r0.w = (r0.w) * (c1.z) + (c1.w);
    r0.xz = c3.zz;
    r3.xy = (r0.zw) * (c[31].xx);
    r1.xyz = v7.xyz;
    r2.xyz = (r1.zxy) * (v5.yzx);
    r3.xy = (c[30].xx) * (r0.xy) + (r3.xy);
    r0.xyz = (r1.yzx) * (v5.zxy) + (-(r2.xyz));
    r0.xyz = (r3.yyy) * (-(r0.xyz));
    r0.xyz = (r3.xxx) * (v5.xyz) + (r0.xyz);
    r0.w = dot(-(v6.xyz), -(v6.xyz));
    r0.xyz = (r0.xyz) + (v7.xyz);
    r6.w = rsqrt(r0.w);
    r5.xyz = normalize(r0.xyz);
    r3.xyz = normalize(c[17].xyz);
    r4 = (-(v6.yyyy)) + (c[7]);
    r2 = (-(v6.xxxx)) + (c[6]);
    r0 = (r4) * (r4);
    r1 = (r2) * (r2) + (r0);
    r0 = (-(v6.zzzz)) + (c[8]);
    r7.w = saturate(dot(r5.xyz, r3.xyz));
    r1 = (r0) * (r0) + (r1);
    r7.xyz = (-(v6.xyz)) * (r6.www) + (r3.xyz);
    r3.x = rsqrt(r1.x);
    r3.y = rsqrt(r1.y);
    r3.z = rsqrt(r1.z);
    r3.w = rsqrt(r1.w);
    r6.xyz = normalize(r7.xyz);
    r4 = (r4) * (r3);
    r5.w = saturate(dot(r5.xyz, r6.xyz));
    r4 = (r5.yyyy) * (r4);
    r2 = (r2) * (r3);
    r6.xyz = (r6.www) * (-(v6.xyz));
    r2 = (r2) * (r5.xxxx) + (r4);
    r4.w = dot(-(r6.xyz), r5.xyz);
    r0 = (r0) * (r3);
    r3.w = (r4.w) + (r4.w);
    r2 = saturate((r0) * (r5.zzzz) + (r2));
    r0.xyz = (r5.xyz) * (-(r3.www)) + (-(r6.xyz));
    r0.w = c3.w;
    r1 = saturate((r1) * (c[9]) + (r0.wwww));
    r3.xyz = (r0.yyy) * (v3.xyw);
    r1 = (r2) * (r1);
    r2.xyz = (r0.xxx) * (v2.xyw) + (r3.xyz);
    r7.z = dot(c[20], r1);
    r3.xyz = (r0.zzz) * (v4.xyw) + (r2.xyz);
    r8.w = pow(abs(r5.w), c13.w);
    r2.w = 1.0f / (r3.z);
    r0.w = max(abs(r5.y), abs(r5.z));
    r2.xy = (r3.xy) * (r2.ww);
    r3.w = max(abs(r5.x), r0.w);
    r0.w = max(abs(r2.x), abs(r2.y));
    r3.y = saturate((r0.w) * (-(r0.w)) + (c3.w));
    r2.xy = (r2.xy) * (c1.yx) + (c1.yy);
    r2 = tex2D(s1, r2.xy);
    r4.xyz = (r2.xyz) * (r2.xyz);
    r0.w = c4.y;
    r0 = texCUBElod(s15, r0);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.w = 1.0f / (c[24].x);
    r2.xyz = (r0.xyz) * (c[25].xxx);
    r0.xyz = (r4.xyz) * (r0.www);
    r2.xyz = (r2.xyz) * (c14.yyy);
    r0.w = ((-(r3.z)) >= 0.0f ? (c4.y) : (r3.y));
    r0.xyz = (r0.xyz) * (c[26].xxx) + (-(r2.xyz));
    r8.xyz = (r0.www) * (r0.xyz) + (r2.xyz);
    r2.w = 1.0f / (r3.w);
    r0 = tex2D(s5, r9.xy);
    r2.xyz = (r5.xyz) * (c[5].xyz);
    r2.xyz = (r2.xyz) * (r2.www) + (v1.xyz);
    r2 = tex3D(s11, r2.xyz);
    if ((c3.w) >= (v0.w))
    {
        r4 = (v0.xyzx) * (c4.xxxy);
        r3 = (r4) + (-(c12.xyzz));
        r3 = tex2Dlod(s0, r3);
        r3.w = r3.x;
        r5 = (r4) + (c4.zzyy);
        r5 = tex2Dlod(s0, r5);
        r3.x = r5.x;
        r5 = (r4) + (c4.wwyy);
        r5 = tex2Dlod(s0, r5);
        r3.y = r5.x;
        r4 = (r4) + (c12.xyzz);
        r4 = tex2Dlod(s0, r4);
        r3.z = r4.x;
        r0.w = dot(r3, c12.wwww);
        if ((c13.x) < (v0.w))
        {
            r7.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r3.xy = (r7.xy) + (c4.zz);
            r3.zw = (v0.zx) * (c4.xy);
            r3 = tex2Dlod(s0, r3);
            r4.xy = (r7.xy) + (c4.ww);
            r4.zw = (v0.zx) * (c4.xy);
            r6 = tex2Dlod(s0, r4);
            r4.xy = (r7.xy) + (c12.xy);
            r4.zw = (v0.zx) * (c4.xy);
            r5 = tex2Dlod(s0, r4);
            r4.xy = (r7.xy) + (-(c12.xy));
            r4.zw = (v0.zx) * (c4.xy);
            r4 = tex2Dlod(s0, r4);
            r3.y = r6.x;
            r3.z = r5.x;
            r3.w = r4.x;
            r2.w = dot(r3, c12.wwww);
            r3.w = (-(r0.w)) + (r2.w);
            r2.w = (v0.w) * (c13.y) + (c13.z);
            r0.w = (r2.w) * (r3.w) + (r0.w);
        }
    }
    else
    {
        r0.w = (v0.w) + (-(c3.x));
        r0.w = ((r0.w) >= 0.0f ? (c4.y) : (c4.x));
        if ((r0.w) != (-(r0.w)))
        {
            r7.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r3.xy = (r7.xy) + (c4.zz);
            r3.zw = (v0.zz) * (c4.xy);
            r3 = tex2Dlod(s0, r3);
            r4.xy = (r7.xy) + (c4.ww);
            r4.zw = (v0.zz) * (c4.xy);
            r6 = tex2Dlod(s0, r4);
            r4.xy = (r7.xy) + (c12.xy);
            r4.zw = (v0.zz) * (c4.xy);
            r5 = tex2Dlod(s0, r4);
            r4.xy = (r7.xy) + (-(c12.xy));
            r4.zw = (v0.zz) * (c4.xy);
            r4 = tex2Dlod(s0, r4);
            r3.y = r6.x;
            r3.z = r5.x;
            r3.w = r4.x;
            r3.w = dot(r3, c12.wwww);
            r0.w = saturate((v0.w) + (c13.z));
            r2.w = (r2.w) + (-(r3.w));
            r0.w = (r0.w) * (r2.w) + (r3.w);
        }
        else
        {
            r0.w = r2.w;
        }
    }
    r4.xyz = (r0.www) * (c[18].xyz);
    r3.xyz = (r2.xyz) * (r2.xyz);
    r7.x = dot(c[10], r1);
    r7.y = dot(c[11], r1);
    r2.xyz = (r8.www) * (r4.xyz) + (r8.xyz);
    r1.xyz = (r3.xyz) * (c14.xxx) + (r7.xyz);
    r3.xyz = (r0.xyz) * (r2.xyz);
    r1.xyz = (r7.www) * (r4.xyz) + (r1.xyz);
    r0 = tex2D(s4, r9.xy);
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
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = r0.w;

    return oC0;
}
