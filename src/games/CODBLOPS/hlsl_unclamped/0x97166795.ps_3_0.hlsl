// Mechanically reconstructed from 0x97166795.ps_3_0.cso.
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
sampler2D s8 : register(s8);
sampler3D s11 : register(s11);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : TEXCOORD1;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD3;
    float4 v4 : TEXCOORD5;
    float4 v5 : TEXCOORD6;
    float4 v6 : TEXCOORD7;
    float4 v7 : TEXCOORD8;
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
    const float4 c0 = float4(2.75f, -2.0f, 0.5f, 2.0f);
    const float4 c1 = float4(60.0f, 0.25f, 1.0f, 0.0f);
    const float4 c3 = float4(75.0f, 0.5f, -0.5f, 3.68000007f);
    const float4 c4 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c12 = float4(0.00333333341f, 300.0f, -64.0301971f, 9.40301991f);
    const float4 c13 = float4(-2.0f, 3.0f, 0.000244140625f, 0.0f);
    const float4 c14 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c15 = float4(4.0f, -3.0f, -4.0f, 31.875f);
    const float4 c16 = float4(100.0f, 8.0f, 0.0f, 0.0f);
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

    r0.w = c12.x;
    r0.w = (r0.w) * (c[25].w);
    r0.w = frac(abs(r0.w));
    r4.w = ((c[25].w) >= 0.0f ? (r0.w) : (-(r0.w)));
    r3.y = (r4.w) * (c1.x);
    r0 = tex2D(s4, v7.xy);
    r11.xy = (v7.xy) * (c[28].xx);
    r1.xy = (r11.xy) * (c[31].xx);
    r3.xzw = (r4.www) * (c12.yzw);
    r2.xy = (c[33].xx) * (r3.xx) + (r1.xy);
    r2 = tex2D(s6, r2.xy);
    r1.xy = (c[32].xy) * (r3.xx) + (r1.xy);
    r1 = tex2D(s6, r1.xy);
    r0.w = (r2.x) + (r1.x);
    r0.z = (r0.w) + (r0.w);
    r0.w = saturate(r0.y);
    r0.z = (r4.w) * (-(c3.x)) + (r0.z);
    r1.w = (r0.z) + (c3.y);
    r0.xyz = c[29].xyz;
    r0.xyz = (-(r0.yzx)) + (c[30].yzx);
    r1.w = frac(r1.w);
    r6.xyz = (r0.www) * (r0.xyz) + (c[29].yzx);
    r0.w = (r1.w) + (c3.z);
    r0.z = frac(r6.y);
    r1.w = (abs(r0.w)) * (c3.w);
    r0.w = (r6.y) + (-(r0.z));
    r0.w = (r0.w) * (c0.y);
    r1.z = (r0.z) + (c3.z);
    r2.z = exp2(r0.w);
    r0.z = ((r1.z) >= 0.0f ? (c0.z) : (c0.w));
    r0.w = pow(abs(r1.w), c0.x);
    r2.w = (r2.z) * (r0.z);
    r1.w = lerp(c[34].x, c[34].y, r0.w);
    r3.x = (r11.x) * (r2.w) + (r3.y);
    r0.x = (r11.x) * (r2.z) + (r3.y);
    r0.z = (r11.y) * (r2.z);
    r0 = tex2D(s5, r0.xz);
    r1.xy = (r0.wy) * (c4.xy) + (c4.zw);
    r0.xy = (r11.xy) * (r2.zz) + (r3.zw);
    r0 = tex2D(s5, r0.xy);
    r0.xy = (r0.wy) * (c4.xy) + (c4.zw);
    r1.xy = (r1.xy) * (r0.xy);
    r0.xy = (r11.xy) * (r2.ww) + (r3.zw);
    r0 = tex2D(s5, r0.xy);
    r2.xy = (r0.wy) * (c4.xy) + (c4.zw);
    r3.z = (r11.y) * (r2.w);
    r0 = tex2D(s5, r3.xz);
    r0.xy = (r0.wy) * (c4.xy) + (c4.zw);
    r0.xy = (r2.xy) * (r0.xy) + (-(r1.xy));
    r0.w = (abs(r1.z)) + (abs(r1.z));
    r1.w = (r6.x) * (r1.w);
    r2.xy = (r0.ww) * (r0.xy) + (r1.xy);
    r0 = tex2D(s3, r11.xy);
    r3.xy = (r0.wy) * (c4.xy) + (c4.zw);
    r0.xyz = v5.xyz;
    r1.xyz = (r0.zxy) * (v3.yzx);
    r2.xy = (r1.ww) * (r2.xy) + (r3.xy);
    r0.xyz = (r0.yzx) * (v3.zxy) + (-(r1.xyz));
    r0.xyz = (r2.yyy) * (-(r0.xyz));
    r0.xyz = (r2.xxx) * (v3.xyz) + (r0.xyz);
    r0.w = dot(-(v4.xyz), -(v4.xyz));
    r0.xyz = (r0.xyz) + (v5.xyz);
    r7.w = rsqrt(r0.w);
    r7.xyz = normalize(r0.xyz);
    r0.xy = (v2.ww) * (-(c[24].xy)) + (v2.xy);
    r0.zw = v2.zw;
    r0 = tex2Dproj(s1, r0);
    r0.y = r0.x;
    r1.xy = (v2.ww) * (c[24].zw) + (v2.xy);
    r1.zw = v2.zw;
    r1 = tex2Dproj(s1, r1);
    r2.xyz = normalize(c[17].xyz);
    r0.z = r1.x;
    r3.xyz = (-(v4.xyz)) * (r7.www) + (r2.xyz);
    r8.xyz = (r7.www) * (-(v4.xyz));
    r1.xyz = normalize(r3.xyz);
    r6.w = saturate(dot(r7.xyz, r8.xyz));
    r2.w = saturate(dot(r7.xyz, r1.xyz));
    r1.xy = (v2.ww) * (-(c[24].zw)) + (v2.xy);
    r1.zw = v2.zw;
    r1 = tex2Dproj(s1, r1);
    r0.w = r1.x;
    r1.xy = (v2.ww) * (c[24].xy) + (v2.xy);
    r1.zw = v2.zw;
    r1 = tex2Dproj(s1, r1);
    r0.x = r1.x;
    r1.w = max(abs(r7.y), abs(r7.z));
    r9.w = dot(r0, c1.yyyy);
    r0.w = max(abs(r7.x), r1.w);
    r8.w = pow(abs(r2.w), c16.x);
    r0.w = 1.0f / (r0.w);
    r9.xyz = normalize(v5.xyz);
    r0.xyz = (r7.xyz) * (c[5].xyz);
    r6.x = saturate(dot(r9.xyz, r2.xyz));
    r0.xyz = (r0.xyz) * (r0.www) + (v1.xyz);
    r1 = tex3D(s11, r0.xyz);
    r0.xyz = (-(v4.xyz)) + (c[6].xyz);
    r10.xyz = normalize(r0.xyz);
    r0.w = dot(r10.xyz, c[22].xyz);
    r0.w = saturate((r0.w) * (c[23].x) + (c[23].y));
    r6.y = saturate(dot(r9.xyz, r10.xyz));
    r1.y = (r0.w) * (c13.x) + (c13.y);
    r1.z = (r0.w) * (r0.w);
    r0 = (v4.xyzx) * (c1.zzzw) + (c1.wwwz);
    r10.w = (r1.y) * (r1.z);
    r11.w = dot(r0, c[21]);
    if ((c1.z) >= (v0.w))
    {
        r2 = (v0.xyzx) * (c1.zzzw);
        r1 = (r2) + (-(c14.xyzz));
        r1 = tex2Dlod(s0, r1);
        r1.w = r1.x;
        r3 = (r2) + (c13.zzww);
        r3 = tex2Dlod(s0, r3);
        r1.x = r3.x;
        r3 = (r2) + (-(c13.zzww));
        r3 = tex2Dlod(s0, r3);
        r1.y = r3.x;
        r2 = (r2) + (c14.xyzz);
        r2 = tex2Dlod(s0, r2);
        r1.z = r2.x;
        r5.w = dot(r1, c1.yyyy);
        if ((c14.w) < (v0.w))
        {
            r5.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r1.xy = (r5.xy) + (c13.zz);
            r1.zw = (v0.zx) * (c1.zw);
            r1 = tex2Dlod(s0, r1);
            r2.xy = (r5.xy) + (-(c13.zz));
            r2.zw = (v0.zx) * (c1.zw);
            r4 = tex2Dlod(s0, r2);
            r2.xy = (r5.xy) + (c14.xy);
            r2.zw = (v0.zx) * (c1.zw);
            r3 = tex2Dlod(s0, r2);
            r2.xy = (r5.xy) + (-(c14.xy));
            r2.zw = (v0.zx) * (c1.zw);
            r2 = tex2Dlod(s0, r2);
            r1.y = r4.x;
            r1.z = r3.x;
            r1.w = r2.x;
            r1.w = dot(r1, c1.yyyy);
            r1.z = (-(r5.w)) + (r1.w);
            r1.w = (v0.w) * (c15.x) + (c15.y);
            r1.w = (r1.w) * (r1.z) + (r5.w);
        }
        else
        {
            r1.w = r5.w;
        }
    }
    else
    {
        r1.z = (v0.w) + (c15.z);
        r1.z = ((r1.z) >= 0.0f ? (c1.w) : (c1.z));
        if ((r1.z) != (-(r1.z)))
        {
            r1.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r2.xy = (r1.xy) + (c13.zz);
            r2.zw = (v0.zz) * (c1.zw);
            r2 = tex2Dlod(s0, r2);
            r3.xy = (r1.xy) + (-(c13.zz));
            r3.zw = (v0.zz) * (c1.zw);
            r5 = tex2Dlod(s0, r3);
            r3.xy = (r1.xy) + (c14.xy);
            r3.zw = (v0.zz) * (c1.zw);
            r4 = tex2Dlod(s0, r3);
            r3.xy = (r1.xy) + (-(c14.xy));
            r3.zw = (v0.zz) * (c1.zw);
            r3 = tex2Dlod(s0, r3);
            r2.y = r5.x;
            r2.z = r4.x;
            r2.w = r3.x;
            r1.y = dot(r2, c1.yyyy);
            r1.z = saturate((v0.w) + (-(c13.y)));
            r1.w = (r1.w) + (-(r1.y));
            r1.w = (r1.z) * (r1.w) + (r1.y);
        }
    }
    r1.z = 1.0f / (r11.w);
    r2.x = dot(r0, c[20]);
    r1.x = dot(r0, c[10]);
    r2.y = (r2.x) * (r2.x);
    r1.y = dot(r0, c[11]);
    r0.w = dot(c[8].yz, r2.xy) + (c[8].x);
    r0.z = saturate(1.0f / (r0.w));
    r0.xy = saturate((r2.xx) * (c[9].xy) + (c[9].zw));
    r2.xy = (r0.xy) * (c13.xx) + (c13.yy);
    r0.xy = (r0.xy) * (r0.xy);
    r0.w = ((-abs(r0.w)) >= 0.0f ? (c1.w) : (r0.z));
    r0.z = (r2.x) * (r0.x);
    r0.w = (r0.w) * (r0.z);
    r0.z = (r0.y) * (-(r2.y)) + (c1.z);
    r0.xy = (r1.zz) * (r1.xy);
    r0.w = (r0.w) * (r0.z);
    r1.z = (r10.w) * (r0.w);
    r0.xy = (r0.xy) * (c3.yy) + (c3.yy);
    r0 = tex2D(s2, r0.xy);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r1.zzz) * (r0.xyz);
    r0.xyz = (r9.www) * (r0.xyz);
    r2.xyz = (r0.xyz) * (c[7].xyz);
    r1.xyz = (r1.www) * (c[18].xyz);
    r3.xyz = (r8.www) * (r1.xyz);
    r4.xyz = (-(v4.xyz)) * (r7.www) + (r10.xyz);
    r0.xyz = normalize(r4.xyz);
    r1.w = max(abs(r9.y), abs(r9.z));
    r2.w = saturate(dot(r7.xyz, r0.xyz));
    r0.w = max(abs(r9.x), r1.w);
    r0.xyz = (r9.xyz) * (c[5].xyz);
    r0.w = 1.0f / (r0.w);
    r1.w = pow(abs(r2.w), c16.x);
    r0.xyz = (r0.xyz) * (r0.www) + (v1.xyz);
    r0 = tex3D(s11, r0.xyz);
    r1.xyz = (r6.xxx) * (r1.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1.xyz = (r6.yyy) * (r2.xyz) + (r1.xyz);
    r2.xyz = (r1.www) * (r2.xyz) + (r3.xyz);
    r1.xyz = (r0.xyz) * (c15.www) + (r1.xyz);
    r0 = tex2D(s8, r11.xy);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.w = dot(-(r8.xyz), r7.xyz);
    r1.xyz = (r1.xyz) * (r0.xyz);
    r0.z = (r0.w) + (r0.w);
    r0.w = c[27].x;
    r0.xyz = (r7.xyz) * (-(r0.zzz)) + (-(r8.xyz));
    r0 = texCUBElod(s15, r0);
    r0.w = (-(r6.w)) + (c1.z);
    r1.w = (r0.w) * (r0.w);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1.w = (r1.w) * (r1.w);
    r2.xyz = (r0.xyz) * (c16.yyy) + (r2.xyz);
    r1.w = (r0.w) * (r1.w);
    r0 = tex2D(s7, r11.xy);
    r2.w = (-(r0.x)) + (c1.z);
    r0.xyz = (r2.xyz) * (r6.zzz) + (-(r1.xyz));
    r0.w = saturate(lerp(r2.w, c1.z, r1.w));
    r0.xyz = (r0.www) * (r0.xyz) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v6.xyz));
    r0.w = v3.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v6.xyz);
    r0.xyz = max(((r0.xyz) * (c[26].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c1.z;

    return oC0;
}
