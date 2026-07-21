// Mechanically reconstructed from 0x48B973F2.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
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
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD3;
    float4 v4 : TEXCOORD4;
    float4 v5 : TEXCOORD5;
    float4 v6 : TEXCOORD6;
    float4 v7 : TEXCOORD7;
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
    const float4 c0 = float4(31.875f, 3.5f, 1.0f, 0.00390625f);
    const float4 c1 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.25f);
    const float4 c3 = float4(0.75f, 4.0f, -3.0f, -4.0f);
    const float4 c4 = float4(1.0f, 0.0f, -0.0f, 0.000244140625f);
    const float4 c12 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c13 = float4(60.0f, -50.0f, 1.70000005f, 0.100000001f);
    const float4 c14 = float4(0.5f, 2.0f, -1.0f, 50.0f);
    const float4 c15 = float4(9.99999975e-06f, 1e-15f, 1.44269502f, 8.0f);
    const float4 c16 = float4(-0.109375f, 30.0f, -0.0700000003f, 1.88679242f);
    const float4 c30 = float4(-2.0f, 3.0f, 1.29999995f, 0.0f);
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
    float4 r11 = 0.0f;
    float4 oC0 = 0.0f;

    r0.x = dot(v2.xyz, v2.xyz);
    r0.x = rsqrt(r0.x);
    r0.yzw = (r0.xxx) * (v2.zxy);
    r1.xyz = (r0.yzw) * (v3.yzx);
    r1.xyz = (r0.wyz) * (v3.zxy) + (-(r1.xyz));
    r1.xyz = (r1.xyz) * (v3.www);
    r1.w = max(abs(r0.w), abs(r0.y));
    r2.x = max(abs(r0.z), r1.w);
    r2.yzw = (r0.zwy) * (c[5].xyz);
    r1.w = 1.0f / (r2.x);
    r2.xyz = (r2.yzw) * (r1.www) + (v6.xyz);
    r2 = tex3D(s11, r2.xyz);
    if ((c4.x) >= (v7.w))
    {
        r3 = (v7.xyzx) * (c4.xxxy) + (c4.zzzx);
        r3 = (r3) * (c4.xxxy);
        r4 = (r3) + (c4.wwyy);
        r4 = tex2Dlod(s1, r4);
        r5 = (r3) + (-(c4.wwyy));
        r5 = tex2Dlod(s1, r5);
        r6 = (r3) + (c1.xyzz);
        r6 = tex2Dlod(s1, r6);
        r3 = (r3) + (-(c1.xyzz));
        r3 = tex2Dlod(s1, r3);
        r4.y = r5.x;
        r4.z = r6.x;
        r4.w = r3.x;
        r1.w = dot(r4, c1.wwww);
        if ((c3.x) < (v7.w))
        {
            r3.xy = (v7.xy) * (c[2].ww) + (c[2].xy);
            r3.zw = (v7.zx) * (c4.xy) + (c4.zx);
            r3 = (r3) * (c4.xxxy);
            r4 = (r3) + (c4.wwyy);
            r4 = tex2Dlod(s1, r4);
            r5 = (r3) + (-(c4.wwyy));
            r5 = tex2Dlod(s1, r5);
            r6 = (r3) + (c1.xyzz);
            r6 = tex2Dlod(s1, r6);
            r3 = (r3) + (-(c1.xyzz));
            r3 = tex2Dlod(s1, r3);
            r4.y = r5.x;
            r4.z = r6.x;
            r4.w = r3.x;
            r2.x = dot(r4, c1.wwww);
            r2.y = (v7.w) * (c3.y) + (c3.z);
            r3.x = lerp(r1.w, r2.x, r2.y);
            r1.w = r3.x;
        }
    }
    else
    {
        r2.x = (c3.w) + (v7.w);
        r2.x = ((r2.x) >= 0.0f ? (c4.y) : (c4.x));
        if ((r2.x) != (-(r2.x)))
        {
            r3.xy = (v7.xy) * (c[2].ww) + (c[2].xy);
            r3.zw = (v7.zz) * (c4.xy) + (c4.zx);
            r3 = (r3) * (c4.xxxy);
            r4 = (r3) + (c4.wwyy);
            r4 = tex2Dlod(s1, r4);
            r5 = (r3) + (-(c4.wwyy));
            r5 = tex2Dlod(s1, r5);
            r6 = (r3) + (c1.xyzz);
            r6 = tex2Dlod(s1, r6);
            r3 = (r3) + (-(c1.xyzz));
            r3 = tex2Dlod(s1, r3);
            r4.y = r5.x;
            r4.z = r6.x;
            r4.w = r3.x;
            r2.x = dot(r4, c1.wwww);
            r2.y = saturate((c3.z) + (v7.w));
            r1.w = lerp(r2.x, r2.w, r2.y);
        }
        else
        {
            r1.w = r2.w;
        }
    }
    r2.xyz = (r1.www) * (c[18].xyz);
    r3.xyz = (r1.www) * (c[19].xyz);
    r4.xyz = normalize(c[17].xyz);
    r5 = tex2D(s2, v5.xy);
    r5.xy = (r5.wy) * (c12.xy) + (c12.zw);
    r5.xy = (r5.xy) * (c14.xx) + (c14.xx);
    r5.xy = (r5.xy) * (c14.yy) + (c14.zz);
    r1.xyz = (r1.xyz) * (r5.yyy);
    r1.xyz = (r5.xxx) * (v3.xyz) + (r1.xyz);
    r1.xyz = (v2.xyz) * (r0.xxx) + (r1.xyz);
    r5.xyz = normalize(r1.xyz);
    r1.xyz = (r2.xyz) * (c[6].xxx);
    r0.x = saturate(dot(r5.xyz, r4.xyz));
    r2.xyz = (r3.xyz) * (c[6].yyy);
    r3 = tex2D(s5, v5.xy);
    r3 = (r3.wxyz) * (r3.wxyz);
    r6 = c13;
    r1.w = (c[7].y) * (r6.x) + (r6.y);
    r2.w = (c[25].x) * (r6.z) + (r6.w);
    r1.w = (r3.x) * (c14.w) + (r1.w);
    r3.x = saturate(lerp(c14.x, r1.w, r2.w));
    r6 = tex2D(s7, v5.xy);
    r6.yz = (c[26].xx) * (v5.xy);
    r7 = tex2D(s3, r6.yz);
    r1.w = (r6.x) * (r7.w);
    r2.w = (r6.x) * (r7.w) + (-(r6.x));
    r2.w = (r3.x) * (r2.w) + (r6.x);
    r4.w = max(c15.x, r2.w);
    r2.w = dot(-(v1.xyz), -(v1.xyz));
    r2.w = rsqrt(r2.w);
    r6.xyz = (r2.www) * (-(v1.xyz));
    r5.w = saturate(dot(r5.xyz, r6.xyz));
    r4.w = (r4.w) * (r4.w);
    r4.w = 1.0f / (r4.w);
    r8.xyz = (-(v1.xyz)) * (r2.www) + (r4.xyz);
    r9.xyz = normalize(r8.xyz);
    r2.w = saturate(dot(r5.xyz, r9.xyz));
    r6.w = (r2.w) * (r2.w) + (c15.y);
    r6.w = 1.0f / (r6.w);
    r8.x = (-(r6.w)) + (c4.x);
    r8.x = (r4.w) * (r8.x);
    r8.x = (r8.x) * (c15.z);
    r8.x = exp2(r8.x);
    r6.w = (r6.w) * (r6.w);
    r6.w = (r8.x) * (r6.w);
    r2.w = (r2.w) + (r2.w);
    r8.x = 1.0f / (r5.w);
    r2.w = (r2.w) * (r8.x);
    r8.x = min(r5.w, r0.x);
    r2.w = saturate((r2.w) * (r8.x));
    r2.w = (r0.x) * (r2.w);
    r2.w = rsqrt(r2.w);
    r2.w = 1.0f / (r2.w);
    r2.w = (r6.w) * (r2.w);
    r2.xyz = (r2.xyz) * (r2.www);
    r0.z = saturate(dot(r0.zwy, r6.xyz));
    r0.z = (r5.w) + (r0.z);
    r0.z = (r0.z) * (c14.x);
    r2.w = max(c13.w, r0.z);
    r0.z = 1.0f / (r2.w);
    r0.z = rsqrt(r0.z);
    r0.z = 1.0f / (r0.z);
    r2.xyz = (r2.xyz) * (r0.zzz);
    r0.z = (r4.w) * (c1.w);
    r2.xyz = (r2.xyz) * (r0.zzz);
    r8.xyz = normalize(v1.xyz);
    r0.z = dot(r8.xyz, r5.xyz);
    r0.w = (r0.z) + (r0.z);
    r8.xyz = (r5.xyz) * (-(r0.www)) + (r8.xyz);
    r8.w = (r1.w) * (c15.w);
    r8 = texCUBElod(s15, r8);
    r8.xyz = (r8.xyz) * (r8.xyz);
    r8.xyz = (r8.xyz) * (c15.www);
    r9 = tex3D(s11, v6.xyz);
    r9.xyz = (r9.xyz) * (r9.xyz);
    r8.xyz = (r8.xyz) * (r9.xyz);
    r8.xyz = (r8.xyz) * (c[22].xxx);
    r8.xyz = (r8.xyz) * (c0.xxx);
    r9 = tex2D(s4, v5.xy);
    r9 = (r3.xxxx) * (r7) + (r9);
    r0.z = saturate(r0.z);
    r0.z = (-(r0.z)) + (c4.x);
    r0.w = (r0.z) * (r0.z);
    r0.z = (r0.z) * (r0.w);
    r0.w = (r9.w) * (c0.y) + (c0.z);
    r0.w = 1.0f / (r0.w);
    r0.z = (r0.z) * (r0.w);
    r10.xyz = lerp(r9.xyz, c4.xxx, r0.zzz);
    r8.xyz = (r8.xyz) * (r10.xyz);
    r2.xyz = (r2.xyz) * (c1.www) + (r8.xyz);
    r8.xyz = (-(r2.xyz)) + (c4.xxx);
    r2.xyz = (c[7].xxx) * (r8.xyz) + (r2.xyz);
    r0.z = max(abs(r5.y), abs(r5.z));
    r1.w = max(abs(r5.x), r0.z);
    r8.xyz = (r5.xyz) * (c[5].xyz);
    r0.z = 1.0f / (r1.w);
    r8.xyz = (r8.xyz) * (r0.zzz) + (v6.xyz);
    r8 = tex3D(s11, r8.xyz);
    r8.xyz = (r8.xyz) * (r8.xyz);
    r10.x = c[6].x;
    r10.xyz = (r10.xxx) * (c[18].xyz);
    r11 = tex2D(s6, v5.xy);
    r0.z = (r11.x) * (c[29].x);
    r0.w = dot(-(r4.xyz), r5.xyz);
    r0.w = (r0.w) + (r0.w);
    r5.xyz = (r5.xyz) * (-(r0.www)) + (-(r4.xyz));
    r0.w = dot(r4.xyz, -(r6.xyz));
    r0.w = saturate((r0.w) * (c14.x) + (c14.x));
    r0.w = (r0.w) + (r0.w);
    r0.w = (r0.w) * (r0.w);
    r0.w = (r0.w) * (r0.w);
    r0.w = (r0.w) * (r0.w);
    r0.z = (r0.z) * (r0.w);
    r0.w = (r0.w) * (c16.x) + (c16.y);
    r0.z = (r0.z) * (c0.w);
    r1.w = saturate(dot(r5.xyz, r6.xyz));
    r2.w = pow(abs(r1.w), r0.w);
    r4.xyz = max(r10.xyz, c4.xxx);
    r4.xyz = (r2.www) * (r4.xyz);
    r4.xyz = (r0.zzz) * (r4.xyz);
    r0.y = saturate(r0.y);
    r0.y = (r8.w) * (r0.y);
    r0.yzw = (r4.xyz) * (r0.yyy);
    r0.yzw = (r8.xyz) * (c0.xxx) + (r0.yzw);
    r1.w = (r5.w) + (c16.z);
    r1.w = saturate((r1.w) * (c16.w));
    r2.w = (r1.w) * (c30.x) + (c30.y);
    r1.w = (r1.w) * (r1.w);
    r1.w = saturate((r2.w) * (r1.w));
    r3.yzw = (r3.yzw) * (v4.xyz);
    r4.xyz = (r3.yzw) * (c[23].xxx);
    r5.xyz = (r3.yzw) * (c[24].xxx);
    r6.x = log2(abs(abs(r5.x)));
    r6.y = log2(abs(abs(r5.y)));
    r6.z = log2(abs(abs(r5.z)));
    r5.xyz = (r6.xyz) * (c30.zzz);
    r6.x = exp2(r5.x);
    r6.y = exp2(r5.y);
    r6.z = exp2(r5.z);
    r3.yzw = (r3.yzw) * (-(c[23].xxx)) + (r6.xyz);
    r3.yzw = (r1.www) * (r3.yzw) + (r4.xyz);
    r1.w = (r7.x) * (r7.w);
    r4.x = c4.x;
    r1.w = (r1.w) * (-(c[28].x)) + (r4.x);
    r4.yzw = (r3.yzw) * (c[27].xyz) + (-(r3.yzw));
    r4.yzw = (r1.www) * (r4.yzw);
    r3.xyz = (r3.xxx) * (r4.yzw) + (r3.yzw);
    r0.xyz = (r0.xxx) * (r1.xyz) + (r0.yzw);
    r1.xyz = (r9.xyz) * (r2.xyz);
    r0.xyz = (r0.xyz) * (r3.xyz) + (r1.xyz);
    r1.xyz = max(r0.xyz, c4.yyy);
    r0.w = c[8].w;
    r0.x = (r0.w) * (c[21].x);
    r0.yzw = (-(r4.xxx)) + (c[8].xyz);
    r0.xyz = (r0.xxx) * (r0.yzw) + (c4.xxx);
    r0.xyz = (r1.xyz) * (r0.xyz);
    r0.w = c4.x;
    r1.x = dot(r0, c[10]);
    r1.y = dot(r0, c[11]);
    r1.z = dot(r0, c[20]);
    r0.w = v1.w;
    r2.xyz = lerp(v0.xyz, r1.xyz, r0.www);
    r0.xyz = max(((r2.xyz) * (c[9].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c4.x;

    return oC0;
}
