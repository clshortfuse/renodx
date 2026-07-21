// Mechanically reconstructed from 0x839C3EC8.ps_3_0.cso.
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
    const float4 c1 = float4(0.200000003f, -0.5f, 1.0f, 0.0f);
    const float4 c3 = float4(8.0f, 31.875f, 0.797884583f, 1.0f);
    const float4 c4 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c12 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c13 = float4(0.000244140625f, 0.0f, -0.000244140625f, -4.0f);
    const float4 c14 = float4(0.00048828125f, -0.000122070312f, 0.0f, -3.0f);
    const float4 c15 = float4(4.0f, -3.0f, -2.0f, 3.0f);
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
    float4 r12 = 0.0f;
    float4 r13 = 0.0f;
    float4 r14 = 0.0f;
    float4 oC0 = 0.0f;

    r0.w = dot(v7.xyz, v7.xyz);
    r5.w = rsqrt(r0.w);
    r0 = tex2D(s1, v1.xy);
    r1.xyz = (-(v7.xyz)) + (c[6].xyz);
    r0.z = dot(r1.xyz, r1.xyz);
    r1.w = rsqrt(r0.z);
    r6.xyz = (r5.www) * (v7.xyz);
    r3.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r2.xyz = (r1.xyz) * (r1.www) + (-(r6.xyz));
    r0.w = c1.z;
    r0.xyz = normalize(r2.xyz);
    r4 = tex2D(s0, v1.xy);
    r4.w = (r4.w) * (v0.w) + (c1.y);
    r9.xyz = (r1.xyz) * (r1.www);
    r2.xy = float2(((r4.w) >= 0.0f ? (r3.x) : (c1.w)), ((r4.w) >= 0.0f ? (r3.y) : (c1.w)));
    r2.w = saturate(dot(r0.xyz, r9.xyz));
    r1 = v2;
    r1.xyz = (r2.xxx) * (v5.xyz) + (r1.xyz);
    r2.w = (-(r2.w)) + (c1.z);
    r1.xyz = (r2.yyy) * (v4.xyz) + (r1.xyz);
    r2.z = (r2.w) * (r2.w);
    r5.xyz = normalize(r1.xyz);
    r1.z = (r2.z) * (r2.z);
    r6.w = saturate(dot(r5.xyz, r0.xyz));
    r1.x = (r2.w) * (r1.z);
    r3 = tex2D(s5, v1.xy);
    r0.xyz = (r4.xyz) * (r3.xxx);
    r7.w = ((r4.w) >= 0.0f ? (r3.y) : (c1.w));
    r2.w = r3.w;
    r2.xyz = lerp(r4.xyz, c1.xxx, r3.xxx);
    r0 = float4(((r4.w) >= 0.0f ? (r0.x) : (c1.w)), ((r4.w) >= 0.0f ? (r0.y) : (c1.w)), ((r4.w) >= 0.0f ? (r0.z) : (c1.w)), ((r4.w) >= 0.0f ? (r0.w) : (c1.w)));
    r2 = float4(((r4.w) >= 0.0f ? (r2.x) : (c1.w)), ((r4.w) >= 0.0f ? (r2.y) : (c1.w)), ((r4.w) >= 0.0f ? (r2.z) : (c1.w)), ((r4.w) >= 0.0f ? (r2.w) : (c1.z)));
    r12.xyz = (r2.xyz) * (-(r2.xyz)) + (c1.zzz);
    r13.xyz = (r2.xyz) * (r2.xyz);
    r13.w = (r2.w) * (-(c3.z)) + (c3.w);
    r14.z = (r2.w) * (c3.z);
    r4.w = saturate(dot(r9.xyz, r5.xyz));
    r3.z = saturate(dot(r5.xyz, -(r6.xyz)));
    r1.z = (r4.w) * (r13.w) + (r14.z);
    r12.w = (r3.z) * (r13.w) + (r14.z);
    r1.z = (r1.z) * (r12.w) + (c4.x);
    r3.xy = (r2.ww) * (c12.xy) + (c12.zw);
    r1.y = 1.0f / (r1.z);
    r3.w = exp2(r3.y);
    r1.z = pow(abs(r6.w), r3.w);
    r10.w = (r3.w) * (c4.y) + (c4.z);
    r1.y = (r4.w) * (r1.y);
    r1.z = (r1.z) * (r10.w);
    r2.xyz = (r12.xyz) * (r1.xxx) + (r13.xyz);
    r3.y = (r1.y) * (r1.z);
    r1.xyz = (r0.xyz) * (v0.xyz);
    r0.xyz = (r2.xyz) * (r3.yyy);
    r8.xyz = (r1.xyz) * (r1.xyz);
    r0.xyz = (r0.xyz) * (c[8].xyz);
    r1.xyz = (r7.www) * (r0.xyz);
    r0.xyz = (r4.www) * (c[7].xyz);
    r1.xyz = (r8.xyz) * (r0.xyz) + (r1.xyz);
    r3.y = 1.0f / (r3.x);
    r0.y = (-(r3.z)) + (c1.z);
    r0.x = (r0.y) * (r0.y);
    r0.z = dot(r6.xyz, r5.xyz);
    r3.z = (r0.y) * (r0.x);
    r0.z = (r0.z) + (r0.z);
    r2.w = (r2.w) * (c3.x);
    r2.xyz = (r5.xyz) * (-(r0.zzz)) + (r6.xyz);
    r2 = texCUBElod(s15, r2);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r4.w = (r3.y) * (r3.z);
    r3.xyz = (r0.xyz) * (c3.xxx);
    r2 = tex3D(s11, v8.xyz);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r0.xyz = (r3.xyz) * (r0.xyz);
    r3.xyz = (v7.xyz) * (-(r5.www)) + (c[17].xyz);
    r2.xyz = (r0.xyz) * (c3.yyy);
    r0.xyz = normalize(r3.xyz);
    r3.xyz = (r12.xyz) * (r4.www) + (r13.xyz);
    r2.w = saturate(dot(r0.xyz, c[17].xyz));
    r7.xyz = (r2.xyz) * (r3.xyz);
    r2.z = (-(r2.w)) + (c1.z);
    r2.w = (r2.z) * (r2.z);
    r3.z = max(abs(r5.y), abs(r5.z));
    r2.y = (r2.w) * (r2.w);
    r2.w = max(abs(r5.x), r3.z);
    r8.w = (r2.z) * (r2.y);
    r2.w = 1.0f / (r2.w);
    r2.z = saturate(dot(r5.xyz, r0.xyz));
    r0.xyz = (r5.xyz) * (c[5].xyz);
    r11.w = pow(abs(r2.z), r3.w);
    r0.xyz = (r0.xyz) * (r2.www) + (v8.xyz);
    r2 = tex3D(s11, r0.xyz);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r0.xyz = (r7.www) * (r0.xyz);
    r9.w = saturate(dot(r5.xyz, c[17].xyz));
    r11.xyz = (r0.xyz) * (c3.yyy);
    r10.xyz = (r9.www) * (c[18].xyz);
    if ((c1.z) >= (v6.w))
    {
        r3 = (v6.xyzx) * (c1.zzzw);
        r2 = (r3) + (-(c14.xyzz));
        r2 = tex2Dlod(s2, r2);
        r2.w = r2.x;
        r4 = (r3) + (c13.xxyy);
        r4 = tex2Dlod(s2, r4);
        r2.x = r4.x;
        r4 = (r3) + (c13.zzyy);
        r4 = tex2Dlod(s2, r4);
        r2.y = r4.x;
        r3 = (r3) + (c14.xyzz);
        r3 = tex2Dlod(s2, r3);
        r2.z = r3.x;
        r0.z = dot(r2, c4.zzzz);
        if ((c4.w) < (v6.w))
        {
            r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r2.xy = (r0.xy) + (c13.xx);
            r2.zw = (v6.zx) * (c1.zw);
            r2 = tex2Dlod(s2, r2);
            r3.xy = (r0.xy) + (c13.zz);
            r3.zw = (v6.zx) * (c1.zw);
            r5 = tex2Dlod(s2, r3);
            r3.xy = (r0.xy) + (c14.xy);
            r3.zw = (v6.zx) * (c1.zw);
            r4 = tex2Dlod(s2, r3);
            r3.xy = (r0.xy) + (-(c14.xy));
            r3.zw = (v6.zx) * (c1.zw);
            r3 = tex2Dlod(s2, r3);
            r2.y = r5.x;
            r2.z = r4.x;
            r2.w = r3.x;
            r0.y = dot(r2, c4.zzzz);
            r0.x = (-(r0.z)) + (r0.y);
            r0.y = (v6.w) * (c15.x) + (c15.y);
            r2.w = (r0.y) * (r0.x) + (r0.z);
        }
        else
        {
            r2.w = r0.z;
        }
    }
    else
    {
        r0.z = (v6.w) + (c13.w);
        r0.z = ((r0.z) >= 0.0f ? (c1.w) : (c1.z));
        if ((r0.z) != (-(r0.z)))
        {
            r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r3.xy = (r0.xy) + (c13.xx);
            r3.zw = (v6.zz) * (c1.zw);
            r3 = tex2Dlod(s2, r3);
            r4.xy = (r0.xy) + (c13.zz);
            r4.zw = (v6.zz) * (c1.zw);
            r6 = tex2Dlod(s2, r4);
            r4.xy = (r0.xy) + (c14.xy);
            r4.zw = (v6.zz) * (c1.zw);
            r5 = tex2Dlod(s2, r4);
            r4.xy = (r0.xy) + (-(c14.xy));
            r4.zw = (v6.zz) * (c1.zw);
            r4 = tex2Dlod(s2, r4);
            r3.y = r6.x;
            r3.z = r5.x;
            r3.w = r4.x;
            r0.x = dot(r3, c4.zzzz);
            r0.z = saturate((v6.w) + (c14.w));
            r0.y = (r2.w) + (-(r0.x));
            r0.z = (r0.z) * (r0.y) + (r0.x);
        }
        else
        {
            r0.z = r2.w;
        }
        r2.w = r0.z;
    }
    r0.z = (r9.w) * (r13.w) + (r14.z);
    r0.z = (r0.z) * (r12.w) + (c4.x);
    r0.y = 1.0f / (r0.z);
    r0.z = (r10.w) * (r11.w);
    r0.y = (r9.w) * (r0.y);
    r2.z = (r0.z) * (r0.y);
    r0.xyz = (r12.xyz) * (r8.www) + (r13.xyz);
    r0.xyz = (r2.zzz) * (r0.xyz);
    r2.xyz = (r7.www) * (r0.xyz);
    r0.xyz = (r2.www) * (r10.xyz) + (r11.xyz);
    r2.xyz = (r2.xyz) * (c[19].xyz);
    r3.xyz = (r2.www) * (r2.xyz);
    r2 = (v7.yyyy) * (c[26]);
    r8.xyz = (r8.xyz) * (r0.xyz) + (r3.xyz);
    r2 = (v7.xxxx) * (c[25]) + (r2);
    r0.z = dot(r9.xyz, c[23].xyz);
    r2 = (v7.zzzz) * (c[27]) + (r2);
    r0.z = saturate((r0.z) * (c[24].x) + (c[24].y));
    r5 = (r2) + (c[28]);
    r0.y = (r0.z) * (c15.z) + (c15.w);
    r4.zw = r5.zw;
    r0.z = (r0.z) * (r0.z);
    r6.zw = r4.zw;
    r5.z = (r0.y) * (r0.z);
    r3.zw = r6.zw;
    r2.xy = (r5.ww) * (-(c[29].zw)) + (r5.xy);
    r2.zw = r3.zw;
    r2 = tex2Dproj(s3, r2);
    r2.w = r2.x;
    r6.xy = (r4.ww) * (-(c[29].xy)) + (r5.xy);
    r6 = tex2Dproj(s3, r6);
    r2.y = r6.x;
    r4.xy = (r4.ww) * (c[29].xy) + (r5.xy);
    r6 = tex2Dproj(s3, r4);
    r2.x = r6.x;
    r3.xy = (r4.ww) * (c[29].zw) + (r5.xy);
    r4 = tex2Dproj(s3, r3);
    r3 = (v7.xyzx) * (c1.zzzw) + (c1.wwwz);
    r2.z = r4.x;
    r0.z = dot(r3, c[22]);
    r4.w = 1.0f / (r0.z);
    r4.x = dot(r3, c[21]);
    r0.x = dot(r3, c[11]);
    r4.y = (r4.x) * (r4.x);
    r0.y = dot(r3, c[20]);
    r0.z = dot(c[9].yz, r4.xy) + (c[9].x);
    r3.w = saturate(1.0f / (r0.z));
    r3.xy = saturate((r4.xx) * (c[10].xy) + (c[10].zw));
    r4.xy = (r3.xy) * (c15.zz) + (c15.ww);
    r3.xy = (r3.xy) * (r3.xy);
    r0.z = ((-abs(r0.z)) >= 0.0f ? (c1.w) : (r3.w));
    r3.w = (r4.x) * (r3.x);
    r0.z = (r0.z) * (r3.w);
    r3.w = (r3.y) * (-(r4.y)) + (c1.z);
    r0.xy = (r4.ww) * (r0.xy);
    r0.z = (r0.z) * (r3.w);
    r4.w = (r5.z) * (r0.z);
    r0.xy = (r0.xy) * (-(c1.yy)) + (-(c1.yy));
    r3 = tex2D(s4, r0.xy);
    r0.xyz = (r3.xyz) * (r3.xyz);
    r2.w = dot(r2, c4.zzzz);
    r0.xyz = (r4.www) * (r0.xyz);
    r2.xyz = (r7.xyz) * (r7.www) + (r8.xyz);
    r0.xyz = (r2.www) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r1.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[30].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    r0.w = rsqrt(r0.w);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = 1.0f / (r0.w);

    return oC0;
}
