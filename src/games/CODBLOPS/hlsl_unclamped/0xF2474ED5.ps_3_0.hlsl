// Mechanically reconstructed from 0xF2474ED5.ps_3_0.cso.
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
sampler2D s6 : register(s6);
sampler2D s7 : register(s7);
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
    const float4 c3 = float4(4.0f, -0.5f, -2.07999992f, 0.25f);
    const float4 c4 = float4(1.0f, 0.0f, -2.0f, 3.0f);
    const float4 c12 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c13 = float4(200.0f, 0.000244140625f, 0.0f, -0.000244140625f);
    const float4 c14 = float4(4.0f, -3.0f, 31.875f, 8.0f);
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
    float4 r10 = 0.0f;
    float4 oC0 = 0.0f;

    r2.xy = c1.xy;
    r0.xy = (v8.xy) * (c[35].xx) + (r2.xx);
    r2.w = dot(-(v6.xyz), -(v6.xyz));
    r0.xy = (r0.xy) * (c[36].xx) + (r2.yy);
    r0 = tex2D(s4, r0.xy);
    r10.xy = (v8.xy) * (c[35].xx);
    r0.w = (r0.y) * (c1.z) + (c1.w);
    r1.xy = (r10.xy) * (c3.xx) + (c3.yy);
    r0.y = (r0.w) * (c1.z) + (c1.w);
    r1.xy = (r1.xy) * (c[37].xx) + (r2.yy);
    r1 = tex2D(s5, r1.xy);
    r0.w = (r1.y) * (c1.z) + (c1.w);
    r0.w = (r0.w) * (c1.z) + (c1.w);
    r0.xz = c3.zz;
    r3.xy = (r0.zw) * (c[39].xx);
    r1.xyz = v7.xyz;
    r2.xyz = (r1.zxy) * (v5.yzx);
    r3.xy = (c[38].xx) * (r0.xy) + (r3.xy);
    r0.xyz = (r1.yzx) * (v5.zxy) + (-(r2.xyz));
    r1.w = rsqrt(r2.w);
    r0.xyz = (r3.yyy) * (-(r0.xyz));
    r1.xyz = (r3.xxx) * (v5.xyz) + (r0.xyz);
    r0.xyz = normalize(c[17].xyz);
    r1.xyz = (r1.xyz) + (v7.xyz);
    r2.xyz = (-(v6.xyz)) * (r1.www) + (r0.xyz);
    r9.xyz = normalize(r1.xyz);
    r1.xyz = normalize(r2.xyz);
    r0.w = saturate(dot(r9.xyz, r1.xyz));
    r9.w = saturate(dot(r9.xyz, r0.xyz));
    r10.w = pow(abs(r0.w), c13.x);
    r0.xyz = (r1.www) * (-(v6.xyz));
    r2.w = max(abs(r9.y), abs(r9.z));
    r0.w = dot(-(r0.xyz), r9.xyz);
    r1.z = max(abs(r9.x), r2.w);
    r0.w = (r0.w) + (r0.w);
    r2.w = 1.0f / (r1.z);
    r1.xyz = (r9.xyz) * (-(r0.www)) + (-(r0.xyz));
    r0 = tex2D(s7, r10.xy);
    r2.xyz = (r9.xyz) * (c[5].xyz);
    r2.xyz = (r2.xyz) * (r2.www) + (v1.xyz);
    r2 = tex3D(s11, r2.xyz);
    if ((c4.x) >= (v0.w))
    {
        r4 = (v0.xyzx) * (c4.xxxy);
        r3 = (r4) + (-(c12.xyzz));
        r3 = tex2Dlod(s0, r3);
        r3.w = r3.x;
        r5 = (r4) + (c13.yyzz);
        r5 = tex2Dlod(s0, r5);
        r3.x = r5.x;
        r5 = (r4) + (c13.wwzz);
        r5 = tex2Dlod(s0, r5);
        r3.y = r5.x;
        r4 = (r4) + (c12.xyzz);
        r4 = tex2Dlod(s0, r4);
        r3.z = r4.x;
        r10.z = dot(r3, c3.wwww);
        if ((c12.w) < (v0.w))
        {
            r7.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r3.xy = (r7.xy) + (c13.yy);
            r3.zw = (v0.zx) * (c4.xy);
            r3 = tex2Dlod(s0, r3);
            r4.xy = (r7.xy) + (c13.ww);
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
            r0.w = dot(r3, c3.wwww);
            r2.w = (-(r10.z)) + (r0.w);
            r0.w = (v0.w) * (c14.x) + (c14.y);
            r10.z = (r0.w) * (r2.w) + (r10.z);
        }
    }
    else
    {
        r0.w = (v0.w) + (-(c3.x));
        r0.w = ((r0.w) >= 0.0f ? (c4.y) : (c4.x));
        if ((r0.w) != (-(r0.w)))
        {
            r7.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r3.xy = (r7.xy) + (c13.yy);
            r3.zw = (v0.zz) * (c4.xy);
            r3 = tex2Dlod(s0, r3);
            r4.xy = (r7.xy) + (c13.ww);
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
            r3.w = dot(r3, c3.wwww);
            r0.w = saturate((v0.w) + (-(c4.w)));
            r2.w = (r2.w) + (-(r3.w));
            r2.w = (r0.w) * (r2.w) + (r3.w);
        }
        r10.z = r2.w;
    }
    r3 = (v6.yyyy) * (c[25]);
    r3 = (v6.xxxx) * (c[24]) + (r3);
    r3 = (v6.zzzz) * (c[26]) + (r3);
    r7 = (r3) + (c[27]);
    r6.zw = r7.zw;
    r3 = (v6.xyzx) * (c4.xxxy) + (c4.yyyx);
    r8.zw = r6.zw;
    r0.w = dot(r3, c[21]);
    r5.zw = r8.zw;
    r4.xy = (r7.ww) * (-(c[28].zw)) + (r7.xy);
    r4.zw = r5.zw;
    r4 = tex2Dproj(s1, r4);
    r4.w = r4.x;
    r8.xy = (r6.ww) * (-(c[28].xy)) + (r7.xy);
    r8 = tex2Dproj(s1, r8);
    r4.y = r8.x;
    r6.xy = (r6.ww) * (c[28].xy) + (r7.xy);
    r8 = tex2Dproj(s1, r6);
    r4.x = r8.x;
    r5.xy = (r6.ww) * (c[28].zw) + (r7.xy);
    r5 = tex2Dproj(s1, r5);
    r4.z = r5.x;
    r2.w = 1.0f / (r0.w);
    r0.w = dot(r4, c3.wwww);
    r5.x = dot(r3, c[10]);
    r4.x = dot(r3, c[20]);
    r5.y = dot(r3, c[11]);
    r4.y = (r4.x) * (r4.x);
    r5.xy = (r2.ww) * (r5.xy);
    r2.w = dot(c[8].yz, r4.xy) + (c[8].x);
    r3.w = saturate(1.0f / (r2.w));
    r3.xy = saturate((r4.xx) * (c[9].xy) + (c[9].zw));
    r2.w = ((-abs(r2.w)) >= 0.0f ? (c4.y) : (r3.w));
    r7.xy = (r3.xy) * (c4.zz) + (c4.ww);
    r6.xy = (r3.xy) * (r3.xy);
    r3.xyz = (-(v6.xyz)) + (c[6].xyz);
    r3.w = (r7.x) * (r6.x);
    r4.xyz = normalize(r3.xyz);
    r2.w = (r2.w) * (r3.w);
    r3.w = dot(r4.xyz, c[22].xyz);
    r3.y = (r6.y) * (-(r7.y)) + (c4.x);
    r3.w = saturate((r3.w) * (c[23].x) + (c[23].y));
    r3.z = (r3.w) * (c4.z) + (c4.w);
    r3.w = (r3.w) * (r3.w);
    r2.w = (r2.w) * (r3.y);
    r3.w = (r3.z) * (r3.w);
    r3.xy = (r5.xy) * (c1.yy) + (c1.yy);
    r2.w = (r2.w) * (r3.w);
    r3 = tex2D(s2, r3.xy);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r7.xyz = (r10.zzz) * (c[18].xyz);
    r5.xyz = (r2.www) * (r3.xyz);
    r3.xyz = (r10.www) * (r7.xyz);
    r5.xyz = (r0.www) * (r5.xyz);
    r0.w = saturate(dot(r9.xyz, r4.xyz));
    r5.xyz = (r5.xyz) * (c[7].xyz);
    r8.xyz = (-(v6.xyz)) * (r1.www) + (r4.xyz);
    r4.xyz = (r1.yyy) * (v3.xyw);
    r6.xyz = normalize(r8.xyz);
    r4.xyz = (r1.xxx) * (v2.xyw) + (r4.xyz);
    r1.w = saturate(dot(r9.xyz, r6.xyz));
    r8.xyz = (r1.zzz) * (v4.xyw) + (r4.xyz);
    r2.w = pow(abs(r1.w), c13.x);
    r1.w = 1.0f / (r8.z);
    r4.xyz = (r2.www) * (r5.xyz) + (r3.xyz);
    r6.xy = (r8.xy) * (r1.ww);
    r3.xyz = (r2.xyz) * (r2.xyz);
    r1.w = max(abs(r6.x), abs(r6.y));
    r3.w = saturate((r1.w) * (-(r1.w)) + (c4.x));
    r2.xy = (r6.xy) * (c1.yx) + (c1.yy);
    r2 = tex2D(s3, r2.xy);
    r6.xyz = (r2.xyz) * (r2.xyz);
    r1.w = c4.y;
    r1 = texCUBElod(s15, r1);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r1.w = 1.0f / (c[32].x);
    r2.xyz = (r1.xyz) * (c[33].xxx);
    r1.xyz = (r6.xyz) * (r1.www);
    r6.xyz = (r2.xyz) * (c14.www);
    r1.w = ((-(r8.z)) >= 0.0f ? (c4.y) : (r3.w));
    r2.xyz = (r1.xyz) * (c[34].xxx) + (-(r6.xyz));
    r1.xyz = (r9.www) * (r7.xyz);
    r2.xyz = (r1.www) * (r2.xyz) + (r6.xyz);
    r1.xyz = (r0.www) * (r5.xyz) + (r1.xyz);
    r2.xyz = (r4.xyz) + (r2.xyz);
    r1.xyz = (r3.xyz) * (c14.zzz) + (r1.xyz);
    r3.xyz = (r0.xyz) * (r2.xyz);
    r0 = tex2D(s6, r10.xy);
    r4.xyz = normalize(v6.xyz);
    r2.xyz = (r0.xyz) * (r0.xyz);
    r0.z = dot(c[29].xyz, r4.xyz);
    r1.w = saturate((c[31].y) * (r0.z) + (c[31].x));
    r0.xyz = c[0].xyz;
    r0.xyz = (-(r0.xyz)) + (c[30].xyz);
    r1.xyz = (r1.xyz) * (r2.xyz) + (r3.xyz);
    r0.xyz = (r1.www) * (r0.xyz) + (c[0].xyz);
    r1.xyz = (r0.xyz) * (-(c[0].www)) + (r1.xyz);
    r1.xyz = (r1.xyz) * (v6.www);
    r0.xyz = (r0.xyz) * (c[0].www) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[32].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = r0.w;

    return oC0;
}
