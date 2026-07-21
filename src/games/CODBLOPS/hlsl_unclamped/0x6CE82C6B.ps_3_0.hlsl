// Mechanically reconstructed from 0x6CE82C6B.ps_3_0.cso.
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
    const float4 c1 = float4(8.0f, 31.875f, 1.0f, 0.797884583f);
    const float4 c3 = float4(0.959999979f, 0.0399999991f, 0.0009765625f, 0.25f);
    const float4 c4 = float4(0.125f, 0.25f, 1.0f, 0.0f);
    const float4 c12 = float4(0.00048828125f, -0.000122070312f, 0.0f, -4.0f);
    const float4 c13 = float4(0.000244140625f, 0.0f, -0.000244140625f, 0.75f);
    const float4 c14 = float4(4.0f, -3.0f, -2.0f, 3.0f);
    const float4 c15 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c16 = float4(0.5f, 0.0f, 0.0f, 0.0f);
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

    r0.w = dot(v7.xyz, v7.xyz);
    r2.xyz = (-(v7.xyz)) + (c[6].xyz);
    r7.z = rsqrt(r0.w);
    r0.w = dot(r2.xyz, r2.xyz);
    r1.w = rsqrt(r0.w);
    r6.xyz = (r7.zzz) * (v7.xyz);
    r0.xyz = (r2.xyz) * (r1.www) + (-(r6.xyz));
    r1.xyz = normalize(r0.xyz);
    r0 = tex2D(s1, v1.xy);
    r3.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r2.xyz = (r2.xyz) * (r1.www);
    r0.xyz = v2.xyz;
    r0.xyz = (r3.xxx) * (v5.xyz) + (r0.xyz);
    r0.w = saturate(dot(r1.xyz, r2.xyz));
    r0.xyz = (r3.yyy) * (v4.xyz) + (r0.xyz);
    r1.w = (-(r0.w)) + (c1.z);
    r8.xyz = normalize(r0.xyz);
    r0.w = (r1.w) * (r1.w);
    r8.w = saturate(dot(r8.xyz, r1.xyz));
    r0.z = (r0.w) * (r0.w);
    r0.w = dot(r2.xyz, c[23].xyz);
    r0.z = (r1.w) * (r0.z);
    r7.y = (r0.z) * (c3.x) + (c3.y);
    r0.w = saturate((r0.w) * (c[24].x) + (c[24].y));
    r0.z = (r0.w) * (c14.z) + (c14.w);
    r0.w = (r0.w) * (r0.w);
    r6.w = (r0.z) * (r0.w);
    r7.x = saturate(dot(r8.xyz, -(r6.xyz)));
    r1 = tex2D(s5, v1.xy);
    r11.y = (r1.w) * (-(c1.w)) + (c1.z);
    r11.x = (r1.w) * (c1.w);
    r0 = (v7.yyyy) * (c[26]);
    r11.z = (r7.x) * (r11.y) + (r11.x);
    r0 = (v7.xxxx) * (c[25]) + (r0);
    r7.w = saturate(dot(r2.xyz, r8.xyz));
    r0 = (v7.zzzz) * (c[27]) + (r0);
    r1.z = (r7.w) * (r11.y) + (r11.x);
    r4 = (r0) + (c[28]);
    r0.w = (r1.z) * (r11.z) + (c3.z);
    r3.zw = r4.zw;
    r0.w = 1.0f / (r0.w);
    r5.zw = r3.zw;
    r1.x = (r7.w) * (r0.w);
    r2.zw = r5.zw;
    r0.xy = (r4.ww) * (-(c[29].zw)) + (r4.xy);
    r0.zw = r2.zw;
    r0 = tex2Dproj(s3, r0);
    r0.w = r0.x;
    r5.xy = (r3.ww) * (-(c[29].xy)) + (r4.xy);
    r5 = tex2Dproj(s3, r5);
    r0.y = r5.x;
    r3.xy = (r3.ww) * (c[29].xy) + (r4.xy);
    r5 = tex2Dproj(s3, r3);
    r0.x = r5.x;
    r2.xy = (r3.ww) * (c[29].zw) + (r4.xy);
    r2 = tex2Dproj(s3, r2);
    r3.xy = (r1.ww) * (c15.xy) + (c15.zw);
    r0.z = r2.x;
    r11.w = exp2(r3.y);
    r2.w = pow(abs(r8.w), r11.w);
    r9.w = (r11.w) * (c4.x) + (c4.y);
    r1.z = dot(r0, c3.wwww);
    r0.w = (r2.w) * (r9.w);
    r1.x = (r1.x) * (r0.w);
    r2.w = 1.0f / (r3.x);
    r2.z = (-(r7.x)) + (c1.z);
    r0.w = dot(r6.xyz, r8.xyz);
    r2.y = (r2.z) * (r2.z);
    r0.z = (r0.w) + (r0.w);
    r0.w = (r1.w) * (c1.x);
    r0.xyz = (r8.xyz) * (-(r0.zzz)) + (r6.xyz);
    r0 = texCUBElod(s15, r0);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1.w = (r2.z) * (r2.y);
    r2.xyz = (r0.xyz) * (c1.xxx);
    r0 = tex3D(s11, v8.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.w = (r2.w) * (r1.w);
    r0.xyz = (r2.xyz) * (r0.xyz);
    r0.w = (r0.w) * (c3.x) + (c3.y);
    r0.xyz = (r0.xyz) * (c1.yyy);
    r8.w = (r7.y) * (r1.x);
    r6.xyz = (r0.www) * (r0.xyz);
    r1.w = max(abs(r8.y), abs(r8.z));
    r0.xyz = (v7.xyz) * (-(r7.zzz)) + (c[17].xyz);
    r0.w = max(abs(r8.x), r1.w);
    r9.xyz = normalize(r0.xyz);
    r0.w = 1.0f / (r0.w);
    r0.xyz = (r8.xyz) * (c[5].xyz);
    r1.x = saturate(dot(r9.xyz, c[17].xyz));
    r0.xyz = (r0.xyz) * (r0.www) + (v8.xyz);
    r0 = tex3D(s11, r0.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r1.yyy) * (r0.xyz);
    r10.w = saturate(dot(r8.xyz, c[17].xyz));
    r10.xyz = (r0.xyz) * (c1.yyy);
    r7.xyz = (r10.www) * (c[18].xyz);
    if ((c1.z) >= (v6.w))
    {
        r2 = (v6.xyzx) * (c4.zzzw);
        r0 = (r2) + (-(c12.xyzz));
        r0 = tex2Dlod(s2, r0);
        r0.w = r0.x;
        r3 = (r2) + (c13.xxyy);
        r3 = tex2Dlod(s2, r3);
        r0.x = r3.x;
        r3 = (r2) + (c13.zzyy);
        r3 = tex2Dlod(s2, r3);
        r0.y = r3.x;
        r2 = (r2) + (c12.xyzz);
        r2 = tex2Dlod(s2, r2);
        r0.z = r2.x;
        r1.w = dot(r0, c3.wwww);
        if ((c13.w) < (v6.w))
        {
            r5.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r0.xy = (r5.xy) + (c13.xx);
            r0.zw = (v6.zx) * (c4.zw);
            r0 = tex2Dlod(s2, r0);
            r2.xy = (r5.xy) + (c13.zz);
            r2.zw = (v6.zx) * (c4.zw);
            r4 = tex2Dlod(s2, r2);
            r2.xy = (r5.xy) + (c12.xy);
            r2.zw = (v6.zx) * (c4.zw);
            r3 = tex2Dlod(s2, r2);
            r2.xy = (r5.xy) + (-(c12.xy));
            r2.zw = (v6.zx) * (c4.zw);
            r2 = tex2Dlod(s2, r2);
            r0.y = r4.x;
            r0.z = r3.x;
            r0.w = r2.x;
            r0.w = dot(r0, c3.wwww);
            r0.z = (-(r1.w)) + (r0.w);
            r0.w = (v6.w) * (c14.x) + (c14.y);
            r1.w = (r0.w) * (r0.z) + (r1.w);
        }
    }
    else
    {
        r0.z = (v6.w) + (c12.w);
        r0.z = ((r0.z) >= 0.0f ? (c4.w) : (c4.z));
        if ((r0.z) != (-(r0.z)))
        {
            r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r2.xy = (r0.xy) + (c13.xx);
            r2.zw = (v6.zz) * (c4.zw);
            r2 = tex2Dlod(s2, r2);
            r3.xy = (r0.xy) + (c13.zz);
            r3.zw = (v6.zz) * (c4.zw);
            r5 = tex2Dlod(s2, r3);
            r3.xy = (r0.xy) + (c12.xy);
            r3.zw = (v6.zz) * (c4.zw);
            r4 = tex2Dlod(s2, r3);
            r3.xy = (r0.xy) + (-(c12.xy));
            r3.zw = (v6.zz) * (c4.zw);
            r3 = tex2Dlod(s2, r3);
            r2.y = r5.x;
            r2.z = r4.x;
            r2.w = r3.x;
            r0.y = dot(r2, c3.wwww);
            r0.z = saturate((v6.w) + (c14.y));
            r0.w = (r0.w) + (-(r0.y));
            r0.w = (r0.z) * (r0.w) + (r0.y);
        }
        r1.w = r0.w;
    }
    r0.w = (-(r1.x)) + (c1.z);
    r0.z = (r0.w) * (r0.w);
    r0.z = (r0.z) * (r0.z);
    r7.xyz = (r1.www) * (r7.xyz) + (r10.xyz);
    r0.w = (r0.w) * (r0.z);
    r1.x = (r0.w) * (c3.x) + (c3.y);
    r0.w = (r10.w) * (r11.y) + (r11.x);
    r0.w = (r0.w) * (r11.z) + (c3.z);
    r2.w = saturate(dot(r8.xyz, r9.xyz));
    r0.z = 1.0f / (r0.w);
    r0.w = pow(abs(r2.w), r11.w);
    r0.z = (r10.w) * (r0.z);
    r0.w = (r9.w) * (r0.w);
    r0.w = (r0.z) * (r0.w);
    r0.xyz = (r8.www) * (c[8].xyz);
    r1.x = (r1.x) * (r0.w);
    r3.xyz = (r1.yyy) * (r0.xyz);
    r0 = tex2D(s0, v1.xy);
    r0 = (r0.wxyz) * (v0.wxyz);
    r5.xyz = (r0.yzw) * (r0.yzw);
    r2.xyz = (r7.www) * (c[7].xyz);
    r0.w = (r1.y) * (r1.x);
    r3.xyz = (r5.xyz) * (r2.xyz) + (r3.xyz);
    r4.xyz = (r0.www) * (c[19].xyz);
    r2 = (v7.xyzx) * (c4.zzzw) + (c4.wwwz);
    r8.xyz = (r1.www) * (r4.xyz);
    r0.w = dot(r2, c[22]);
    r0.y = 1.0f / (r0.w);
    r9.x = dot(r2, c[21]);
    r4.x = dot(r2, c[11]);
    r9.y = (r9.x) * (r9.x);
    r4.y = dot(r2, c[20]);
    r0.w = dot(c[9].yz, r9.xy) + (c[9].x);
    r0.z = saturate(1.0f / (r0.w));
    r2.xy = saturate((r9.xx) * (c[10].xy) + (c[10].zw));
    r9.xy = (r2.xy) * (c14.zz) + (c14.ww);
    r2.xy = (r2.xy) * (r2.xy);
    r0.w = ((-abs(r0.w)) >= 0.0f ? (c4.w) : (r0.z));
    r0.z = (r9.x) * (r2.x);
    r0.w = (r0.w) * (r0.z);
    r0.z = (r2.y) * (-(r9.y)) + (c1.z);
    r2.xy = (r0.yy) * (r4.xy);
    r0.w = (r0.w) * (r0.z);
    r0.w = (r6.w) * (r0.w);
    r2.xy = (r2.xy) * (c16.xx) + (c16.xx);
    r2 = tex2D(s4, r2.xy);
    r4.xyz = (r2.xyz) * (r2.xyz);
    r2.xyz = (r5.xyz) * (r7.xyz) + (r8.xyz);
    r4.xyz = (r0.www) * (r4.xyz);
    r2.xyz = (r6.xyz) * (r1.yyy) + (r2.xyz);
    r1.xyz = (r1.zzz) * (r4.xyz);
    r1.xyz = (r1.xyz) * (r3.xyz) + (r2.xyz);
    r2.xyz = (r0.xxx) * (v3.xyz);
    r1.xyz = (r1.xyz) * (r0.xxx) + (-(r2.xyz));
    r1.xyz = (v2.www) * (r1.xyz) + (r2.xyz);
    r1.xyz = max(((r1.xyz) * (c[30].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r1.x = rsqrt(r1.x);
    r1.y = rsqrt(r1.y);
    r1.z = rsqrt(r1.z);
    r0.w = rsqrt(r0.x);
    oC0.x = 1.0f / (r1.x);
    oC0.y = 1.0f / (r1.y);
    oC0.z = 1.0f / (r1.z);
    oC0.w = 1.0f / (r0.w);

    return oC0;
}
