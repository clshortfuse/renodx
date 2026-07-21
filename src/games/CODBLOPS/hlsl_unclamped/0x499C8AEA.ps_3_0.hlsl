// Mechanically reconstructed from 0x499C8AEA.ps_3_0.cso.
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
sampler2D s12 : register(s12);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD8;
    float4 v3 : TEXCOORD2;
    float4 v4 : TEXCOORD3;
    float4 v5 : TEXCOORD4;
    float4 v6 : TEXCOORD5;
    float4 v7 : TEXCOORD6;
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
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(8.0f, 0.797884583f, 0.959999979f, 0.0399999991f);
    const float4 c3 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c4 = float4(4.0f, -2.0f, 0.797884583f, 1.0f);
    const float4 c12 = float4(1.0f, 0.0f, 0.600000024f, 0.400000006f);
    const float4 c13 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c14 = float4(0.000244140625f, 0.0f, -0.000244140625f, -3.0f);
    const float4 c15 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.0f);
    const float4 c16 = float4(4.0f, -3.0f, -2.0f, 3.0f);
    const float4 c30 = float4(3.5f, -13.0f, 1.0f, 13.0f);
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

    r0 = tex2D(s1, v0.xy);
    r0.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r2 = tex2D(s5, v7.zw);
    r0.w = (r2.w) * (v7.y);
    r5.xy = (r0.ww) * (-(r0.xy)) + (r0.xy);
    r1 = tex2D(s6, v0.xy);
    r3 = tex2D(s0, v0.xy);
    r0.x = -(r1.y);
    r0.y = (r0.x) + (c12.x);
    r4.xyz = lerp(r3.xyz, r2.xyz, r0.www);
    r13.xy = (r0.ww) * (r0.xy) + (r1.yy);
    r8.xyz = (r4.xyz) * (r4.xyz);
    r9.w = (r1.w) * (-(c4.z)) + (c4.w);
    r3.w = dot(r5.xy, r5.xy) + (c12.y);
    r3.xyz = (-(v6.xyz)) + (c[5].xyz);
    r0.z = dot(v6.xyz, v6.xyz);
    r0.w = dot(r3.xyz, r3.xyz);
    r9.z = rsqrt(r0.z);
    r2.w = rsqrt(r0.w);
    r10.xyz = (r9.zzz) * (v6.xyz);
    r0 = v1;
    r0.xyz = (r5.xxx) * (v4.xyz) + (r0.xyz);
    r1.xyz = (r3.xyz) * (r2.www) + (-(r10.xyz));
    r0.xyz = (r5.yyy) * (v3.xyz) + (r0.xyz);
    r2.xyz = normalize(r1.xyz);
    r1.xyz = normalize(r0.xyz);
    r8.w = saturate(dot(r1.xyz, -(r10.xyz)));
    r0.xyz = (r3.xyz) * (r2.www);
    r10.w = (r1.w) * (c1.y);
    r2.w = saturate(dot(r0.xyz, r1.xyz));
    r6.z = (r8.w) * (r9.w) + (r10.w);
    r3.y = (r2.w) * (r9.w) + (r10.w);
    r3.z = saturate(dot(r1.xyz, r2.xyz));
    r3.y = (r3.y) * (r6.z) + (c13.x);
    r2.z = saturate(dot(r2.xyz, r0.xyz));
    r2.y = 1.0f / (r3.y);
    r2.x = (r2.w) * (r2.y);
    r14.xy = (r1.ww) * (c30.xy) + (c30.zw);
    r6.w = exp2(r14.y);
    r2.y = (-(r2.z)) + (c12.x);
    r2.z = pow(abs(r3.z), r6.w);
    r3.z = (r2.y) * (r2.y);
    r5.z = (r6.w) * (c13.y) + (c13.z);
    r3.z = (r3.z) * (r3.z);
    r2.z = (r2.z) * (r5.z);
    r2.y = (r2.y) * (r3.z);
    r2.z = (r2.x) * (r2.z);
    r2.x = (r2.y) * (c1.z) + (c1.w);
    r2.y = exp2(-(r3.w));
    r2.z = (r2.z) * (r2.x);
    r5.w = (r2.y) * (c12.z) + (c12.w);
    r2.xyz = (r2.zzz) * (c[7].xyz);
    r3.xyz = (r13.xxx) * (r2.xyz);
    r2.xyz = (r2.www) * (c[6].xyz);
    r7.xyz = (r8.xyz) * (r2.xyz) + (r3.xyz);
    r2.xy = (v0.zw) * (c3.xy);
    r4 = tex2D(s13, r2.xy);
    r2.xy = (v0.zw) * (c3.xy) + (c3.zy);
    r2 = tex2D(s13, r2.xy);
    r4.w = r2.y;
    r7.w = dot(r0.xyz, c[22].xyz);
    r0.xy = (r4.yw) * (c4.xx) + (c4.yy);
    r3 = tex2D(s14, v0.zw);
    r6.xy = (r3.xy) * (c3.ww);
    r0.z = dot(r0.xy, r5.xy) + (c12.y);
    r4.xy = (r4.xz) * (r6.xx);
    r2.w = (r3.x) * (c3.w) + (-(r4.x));
    r5.xy = (r2.xz) * (r6.yy);
    r2.y = (r4.z) * (-(r6.x)) + (r2.w);
    r2.w = (r3.y) * (c3.w) + (-(r5.x));
    r2.w = (r2.z) * (-(r6.y)) + (r2.w);
    r0.y = dot(r0.xy, r0.xy) + (c12.y);
    r9.y = (r2.y) + (r2.y);
    r0.x = exp2(-(r0.y));
    r0.y = (r2.w) + (r2.w);
    r0.x = (r0.x) * (c12.z) + (c12.w);
    r0.x = (r5.w) * (r0.x);
    r3.xyz = (v6.xyz) * (-(r9.zzz)) + (c[17].xyz);
    r3.w = saturate((r0.z) * (r0.x) + (r0.x));
    r2.xyz = normalize(r3.xyz);
    r0.xz = (r5.xy) * (c4.xx);
    r2.w = saturate(dot(r2.xyz, c[17].xyz));
    r0.xyz = (r0.xyz) * (r3.www);
    r2.w = (-(r2.w)) + (c12.x);
    r9.xz = (r4.xy) * (c4.xx);
    r3.w = (r2.w) * (r2.w);
    r3.z = (r3.w) * (r3.w);
    r3.w = saturate(dot(r1.xyz, c[17].xyz));
    r3.z = (r2.w) * (r3.z);
    r2.w = (r3.w) * (r9.w) + (r10.w);
    r3.y = saturate(dot(r1.xyz, r2.xyz));
    r2.z = (r2.w) * (r6.z) + (c13.x);
    r2.w = pow(abs(r3.y), r6.w);
    r2.z = 1.0f / (r2.z);
    r2.w = (r5.z) * (r2.w);
    r2.y = (r3.w) * (r2.z);
    r2.z = (r3.z) * (c1.z) + (c1.w);
    r2.w = (r2.w) * (r2.y);
    r0.xyz = (r9.xyz) * (r5.www) + (r0.xyz);
    r2.w = (r2.z) * (r2.w);
    r12.xyz = (r13.yyy) * (r0.xyz);
    r9.w = (r13.x) * (r2.w);
    r2 = tex2D(s12, v0.zw);
    r0.z = ((-abs(r2.y)) >= 0.0f ? (c12.x) : (c12.y));
    r11.xyz = (r3.www) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r2.y;
        r2.w = r0.z;
    }
    else
    {
        if ((c12.x) >= (v5.w))
        {
            r3 = (v5.xyzx) * (c12.xxxy);
            r2 = (r3) + (-(c15.xyzz));
            r2 = tex2Dlod(s2, r2);
            r2.w = r2.x;
            r4 = (r3) + (c14.xxyy);
            r4 = tex2Dlod(s2, r4);
            r2.x = r4.x;
            r4 = (r3) + (c14.zzyy);
            r4 = tex2Dlod(s2, r4);
            r2.y = r4.x;
            r3 = (r3) + (c15.xyzz);
            r3 = tex2Dlod(s2, r3);
            r2.z = r3.x;
            r0.z = dot(r2, c13.zzzz);
            if ((c13.w) < (v5.w))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r0.xy) + (c14.xx);
                r2.zw = (v5.zx) * (c12.xy);
                r2 = tex2Dlod(s2, r2);
                r3.xy = (r0.xy) + (c14.zz);
                r3.zw = (v5.zx) * (c12.xy);
                r5 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (c15.xy);
                r3.zw = (v5.zx) * (c12.xy);
                r4 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (-(c15.xy));
                r3.zw = (v5.zx) * (c12.xy);
                r3 = tex2Dlod(s2, r3);
                r2.y = r5.x;
                r2.z = r4.x;
                r2.w = r3.x;
                r0.y = dot(r2, c13.zzzz);
                r0.x = (-(r0.z)) + (r0.y);
                r0.y = (v5.w) * (c16.x) + (c16.y);
                r2.w = (r0.y) * (r0.x) + (r0.z);
            }
            else
            {
                r2.w = r0.z;
            }
        }
        else
        {
            r0.z = (v5.w) + (-(c4.x));
            r0.z = ((r0.z) >= 0.0f ? (c12.y) : (c12.x));
            if ((r0.z) != (-(r0.z)))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r3.xy = (r0.xy) + (c14.xx);
                r3.zw = (v5.zz) * (c12.xy);
                r3 = tex2Dlod(s2, r3);
                r4.xy = (r0.xy) + (c14.zz);
                r4.zw = (v5.zz) * (c12.xy);
                r6 = tex2Dlod(s2, r4);
                r4.xy = (r0.xy) + (c15.xy);
                r4.zw = (v5.zz) * (c12.xy);
                r5 = tex2Dlod(s2, r4);
                r4.xy = (r0.xy) + (-(c15.xy));
                r4.zw = (v5.zz) * (c12.xy);
                r4 = tex2Dlod(s2, r4);
                r3.y = r6.x;
                r3.z = r5.x;
                r3.w = r4.x;
                r0.x = dot(r3, c13.zzzz);
                r0.z = saturate((v5.w) + (c14.w));
                r0.y = (r2.y) + (-(r0.x));
                r0.z = (r0.z) * (r0.y) + (r0.x);
            }
            else
            {
                r0.z = r2.y;
            }
            r2.w = r0.z;
        }
    }
    r0.xyz = (r2.www) * (r11.xyz) + (r12.xyz);
    r2.xyz = (r9.www) * (c[19].xyz);
    r2.xyz = (r2.www) * (r2.xyz);
    r2.w = (-(r8.w)) + (c12.x);
    r8.xyz = (r8.xyz) * (r0.xyz) + (r2.xyz);
    r0.z = (r2.w) * (r2.w);
    r0.y = 1.0f / (r14.x);
    r0.z = (r2.w) * (r0.z);
    r0.y = (r0.y) * (r0.z);
    r0.z = dot(r10.xyz, r1.xyz);
    r2.w = (r0.y) * (c1.z) + (c1.w);
    r0.z = (r0.z) + (r0.z);
    r1.w = (r1.w) * (c1.x);
    r1.xyz = (r1.xyz) * (-(r0.zzz)) + (r10.xyz);
    r1 = texCUBElod(s15, r1);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r0.xyz = (r13.xxx) * (r0.xyz);
    r1 = (v6.yyyy) * (c[25]);
    r0.xyz = (r2.www) * (r0.xyz);
    r1 = (v6.xxxx) * (c[24]) + (r1);
    r6.xyz = (r9.xyz) * (r0.xyz);
    r1 = (v6.zzzz) * (c[26]) + (r1);
    r0.z = saturate((r7.w) * (c[23].x) + (c[23].y));
    r4 = (r1) + (c[27]);
    r0.y = (r0.z) * (c16.z) + (c16.w);
    r3.zw = r4.zw;
    r0.z = (r0.z) * (r0.z);
    r5.zw = r3.zw;
    r4.z = (r0.y) * (r0.z);
    r2.zw = r5.zw;
    r1.xy = (r4.ww) * (-(c[28].zw)) + (r4.xy);
    r1.zw = r2.zw;
    r1 = tex2Dproj(s3, r1);
    r1.w = r1.x;
    r5.xy = (r3.ww) * (-(c[28].xy)) + (r4.xy);
    r5 = tex2Dproj(s3, r5);
    r1.y = r5.x;
    r3.xy = (r3.ww) * (c[28].xy) + (r4.xy);
    r5 = tex2Dproj(s3, r3);
    r1.x = r5.x;
    r2.xy = (r3.ww) * (c[28].zw) + (r4.xy);
    r3 = tex2Dproj(s3, r2);
    r2 = (v6.xyzx) * (c12.xxxy) + (c12.yyyx);
    r1.z = r3.x;
    r0.z = dot(r2, c[21]);
    r3.w = 1.0f / (r0.z);
    r3.x = dot(r2, c[20]);
    r0.x = dot(r2, c[10]);
    r3.y = (r3.x) * (r3.x);
    r0.y = dot(r2, c[11]);
    r0.z = dot(c[8].yz, r3.xy) + (c[8].x);
    r2.w = saturate(1.0f / (r0.z));
    r2.xy = saturate((r3.xx) * (c[9].xy) + (c[9].zw));
    r3.xy = (r2.xy) * (c16.zz) + (c16.ww);
    r2.xy = (r2.xy) * (r2.xy);
    r0.z = ((-abs(r0.z)) >= 0.0f ? (c12.y) : (r2.w));
    r2.w = (r3.x) * (r2.x);
    r0.z = (r0.z) * (r2.w);
    r2.w = (r2.y) * (-(r3.y)) + (c12.x);
    r0.xy = (r3.ww) * (r0.xy);
    r0.z = (r0.z) * (r2.w);
    r3.w = (r4.z) * (r0.z);
    r0.xy = (r0.xy) * (c3.yy) + (c3.yy);
    r2 = tex2D(s4, r0.xy);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r1.w = dot(r1, c13.zzzz);
    r0.xyz = (r3.www) * (r0.xyz);
    r1.xyz = (r6.xyz) * (c1.xxx) + (r8.xyz);
    r0.xyz = (r1.www) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r7.xyz) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[29].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c12.x;

    return oC0;
}
