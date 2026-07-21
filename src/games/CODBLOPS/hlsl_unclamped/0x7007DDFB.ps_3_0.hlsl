// Mechanically reconstructed from 0x7007DDFB.ps_3_0.cso.
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
sampler2D s12 : register(s12);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);
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
    const float4 c1 = float4(-0.5f, 1.0f, 0.0f, 0.200000003f);
    const float4 c3 = float4(0.600000024f, 0.400000006f, 8.0f, 0.797884583f);
    const float4 c4 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c12 = float4(4.0f, -2.0f, 0.797884583f, 1.0f);
    const float4 c13 = float4(0.000244140625f, 0.0f, -0.000244140625f, -3.0f);
    const float4 c14 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.0f);
    const float4 c15 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c16 = float4(4.0f, -3.0f, -2.0f, 3.0f);
    const float4 c37 = float4(3.5f, -13.0f, 1.0f, 13.0f);
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

    r0 = tex2D(s0, v1.xy);
    r3.w = (r0.w) * (v0.w) + (c1.x);
    r0 = (r0.xyzx) * (c1.yyyz) + (c1.zzzy);
    r0 = float4(((r3.w) >= 0.0f ? (r0.x) : (c1.z)), ((r3.w) >= 0.0f ? (r0.y) : (c1.z)), ((r3.w) >= 0.0f ? (r0.z) : (c1.z)), ((r3.w) >= 0.0f ? (r0.w) : (c1.z)));
    r0.xyz = (r0.xyz) * (v0.xyz);
    r1 = tex2D(s1, v1.xy);
    r2.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r1 = tex2D(s5, v1.xy);
    r2.zw = (r1.ww) * (c1.zy) + (c1.wz);
    r8.xyz = (r0.xyz) * (r0.xyz);
    r4 = float4(((r3.w) >= 0.0f ? (r2.x) : (c1.z)), ((r3.w) >= 0.0f ? (r2.y) : (c1.z)), ((r3.w) >= 0.0f ? (r2.z) : (c1.z)), ((r3.w) >= 0.0f ? (r2.w) : (c1.y)));
    r9.w = ((r3.w) >= 0.0f ? (r1.y) : (c1.z));
    r0.z = dot(r4.xy, r4.xy) + (c1.z);
    r10.w = (r4.z) * (-(r4.z)) + (c1.y);
    r0.z = exp2(-(r0.z));
    r5.w = (r4.w) * (-(c12.z)) + (c12.w);
    r5.z = (r0.z) * (c3.x) + (c3.y);
    r0.z = dot(v7.xyz, v7.xyz);
    r0.xy = (v1.zw) * (c4.xy);
    r2 = tex2D(s13, r0.xy);
    r0.xy = (v1.zw) * (c4.xy) + (c4.zy);
    r1 = tex2D(s13, r0.xy);
    r2.w = r1.y;
    r6.w = rsqrt(r0.z);
    r0.xy = (r2.yw) * (c12.xx) + (c12.yy);
    r11.w = (r4.z) * (r4.z);
    r1.w = dot(r0.xy, r4.xy) + (c1.z);
    r3 = tex2D(s14, v1.zw);
    r7.xy = (r3.xy) * (c4.ww);
    r5.xy = (r2.xz) * (r7.xx);
    r6.xy = (r1.xz) * (r7.yy);
    r0.z = (r3.x) * (c4.w) + (-(r5.x));
    r1.y = (r3.y) * (c4.w) + (-(r6.x));
    r0.z = (r2.z) * (-(r7.x)) + (r0.z);
    r1.z = (r1.z) * (-(r7.y)) + (r1.y);
    r11.y = (r0.z) + (r0.z);
    r0.z = dot(r0.xy, r0.xy) + (c1.z);
    r0.y = (r1.z) + (r1.z);
    r0.z = exp2(-(r0.z));
    r0.z = (r0.z) * (c3.x) + (c3.y);
    r1.xyz = (-(v7.xyz)) + (c[20].xyz);
    r0.x = (r5.z) * (r0.z);
    r0.z = dot(r1.xyz, r1.xyz);
    r0.z = rsqrt(r0.z);
    r12.xyz = (r6.www) * (v7.xyz);
    r2.w = saturate((r1.w) * (r0.x) + (r0.x));
    r3.xyz = (r1.xyz) * (r0.zzz) + (-(r12.xyz));
    r2.xyz = normalize(r3.xyz);
    r3.xyz = (r1.xyz) * (r0.zzz);
    r0.xz = (r6.xy) * (c12.xx);
    r1.w = saturate(dot(r2.xyz, r3.xyz));
    r0.xyz = (r0.xyz) * (r2.www);
    r1.w = (-(r1.w)) + (c1.y);
    r11.xz = (r5.xy) * (c12.xx);
    r1.z = (r1.w) * (r1.w);
    r0.xyz = (r11.xyz) * (r5.zzz) + (r0.xyz);
    r1.z = (r1.z) * (r1.z);
    r2.w = dot(r3.xyz, c[29].xyz);
    r1.w = (r1.w) * (r1.z);
    r5.z = (r10.w) * (r1.w) + (r11.w);
    r1 = v2;
    r1.xyz = (r4.xxx) * (v5.xyz) + (r1.xyz);
    r3.w = saturate((r2.w) * (c[30].x) + (c[30].y));
    r1.xyz = (r4.yyy) * (v4.xyz) + (r1.xyz);
    r9.xyz = normalize(r1.xyz);
    r4.z = (r4.w) * (c3.w);
    r2.w = saturate(dot(r3.xyz, r9.xyz));
    r12.w = saturate(dot(r9.xyz, -(r12.xyz)));
    r1.z = (r2.w) * (r5.w) + (r4.z);
    r3.x = (r12.w) * (r5.w) + (r4.z);
    r1.x = (r3.w) * (c16.z) + (c16.w);
    r1.z = (r1.z) * (r3.x) + (c15.x);
    r1.y = (r3.w) * (r3.w);
    r1.z = 1.0f / (r1.z);
    r8.w = (r1.x) * (r1.y);
    r1.y = (r2.w) * (r1.z);
    r13.w = dot(r12.xyz, r9.xyz);
    r14.xy = (r4.ww) * (c37.xy) + (c37.zw);
    r3.y = exp2(r14.y);
    r2.z = saturate(dot(r9.xyz, r2.xyz));
    r1.z = pow(abs(r2.z), r3.y);
    r3.z = (r3.y) * (c15.y) + (c15.z);
    r1.z = (r1.z) * (r3.z);
    r2.xyz = (v7.xyz) * (-(r6.www)) + (c[17].xyz);
    r3.w = (r1.y) * (r1.z);
    r1.xyz = normalize(r2.xyz);
    r2.y = (r5.z) * (r3.w);
    r2.z = saturate(dot(r1.xyz, c[17].xyz));
    r13.xyz = (r9.www) * (r0.xyz);
    r2.z = (-(r2.z)) + (c1.y);
    r0.xyz = (r2.yyy) * (c[22].xyz);
    r2.y = (r2.z) * (r2.z);
    r2.y = (r2.y) * (r2.y);
    r3.w = saturate(dot(r9.xyz, c[17].xyz));
    r2.z = (r2.z) * (r2.y);
    r2.x = (r3.w) * (r5.w) + (r4.z);
    r2.y = saturate(dot(r9.xyz, r1.xyz));
    r1.y = (r2.x) * (r3.x) + (c15.x);
    r1.z = pow(abs(r2.y), r3.y);
    r1.y = 1.0f / (r1.y);
    r1.z = (r3.z) * (r1.z);
    r1.x = (r3.w) * (r1.y);
    r1.y = (r10.w) * (r2.z) + (r11.w);
    r1.z = (r1.z) * (r1.x);
    r4.xyz = (r9.www) * (r0.xyz);
    r0.z = (r1.y) * (r1.z);
    r1.xyz = (r2.www) * (c[21].xyz);
    r14.w = (r9.w) * (r0.z);
    r2 = tex2D(s12, v1.zw);
    r0.z = ((-abs(r2.y)) >= 0.0f ? (c1.y) : (c1.z));
    r10.xyz = (r3.www) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r2.y;
        r2.w = r0.z;
    }
    else
    {
        if ((c1.y) >= (v6.w))
        {
            r3 = (v6.xyzx) * (c1.yyyz);
            r2 = (r3) + (-(c14.xyzz));
            r2 = tex2Dlod(s2, r2);
            r2.w = r2.x;
            r5 = (r3) + (c13.xxyy);
            r5 = tex2Dlod(s2, r5);
            r2.x = r5.x;
            r5 = (r3) + (c13.zzyy);
            r5 = tex2Dlod(s2, r5);
            r2.y = r5.x;
            r3 = (r3) + (c14.xyzz);
            r3 = tex2Dlod(s2, r3);
            r2.z = r3.x;
            r0.z = dot(r2, c15.zzzz);
            if ((c15.w) < (v6.w))
            {
                r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r0.xy) + (c13.xx);
                r2.zw = (v6.zx) * (c1.yz);
                r2 = tex2Dlod(s2, r2);
                r3.xy = (r0.xy) + (c13.zz);
                r3.zw = (v6.zx) * (c1.yz);
                r6 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (c14.xy);
                r3.zw = (v6.zx) * (c1.yz);
                r5 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (-(c14.xy));
                r3.zw = (v6.zx) * (c1.yz);
                r3 = tex2Dlod(s2, r3);
                r2.y = r6.x;
                r2.z = r5.x;
                r2.w = r3.x;
                r0.y = dot(r2, c15.zzzz);
                r0.x = (-(r0.z)) + (r0.y);
                r0.y = (v6.w) * (c16.x) + (c16.y);
                r2.w = (r0.y) * (r0.x) + (r0.z);
            }
            else
            {
                r2.w = r0.z;
            }
        }
        else
        {
            r0.z = (v6.w) + (-(c12.x));
            r0.z = ((r0.z) >= 0.0f ? (c1.z) : (c1.y));
            if ((r0.z) != (-(r0.z)))
            {
                r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
                r3.xy = (r0.xy) + (c13.xx);
                r3.zw = (v6.zz) * (c1.yz);
                r3 = tex2Dlod(s2, r3);
                r5.xy = (r0.xy) + (c13.zz);
                r5.zw = (v6.zz) * (c1.yz);
                r7 = tex2Dlod(s2, r5);
                r5.xy = (r0.xy) + (c14.xy);
                r5.zw = (v6.zz) * (c1.yz);
                r6 = tex2Dlod(s2, r5);
                r5.xy = (r0.xy) + (-(c14.xy));
                r5.zw = (v6.zz) * (c1.yz);
                r5 = tex2Dlod(s2, r5);
                r3.y = r7.x;
                r3.z = r6.x;
                r3.w = r5.x;
                r0.x = dot(r3, c15.zzzz);
                r0.z = saturate((v6.w) + (c13.w));
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
    r2.xyz = (r14.www) * (c[19].xyz);
    r0.xyz = (r2.www) * (r10.xyz) + (r13.xyz);
    r2.xyz = (r2.www) * (r2.xyz);
    r1.xyz = (r8.xyz) * (r1.xyz) + (r4.xyz);
    r10.xyz = (r8.xyz) * (r0.xyz) + (r2.xyz);
    r0.z = (r13.w) + (r13.w);
    r2 = (v7.yyyy) * (c[32]);
    r0.x = 1.0f / (r14.x);
    r2 = (v7.xxxx) * (c[31]) + (r2);
    r0.y = (-(r12.w)) + (c1.y);
    r2 = (v7.zzzz) * (c[33]) + (r2);
    r3.w = (r0.y) * (r0.y);
    r6 = (r2) + (c[34]);
    r0.y = (r0.y) * (r3.w);
    r5.zw = r6.zw;
    r0.y = (r0.x) * (r0.y);
    r7.zw = r5.zw;
    r6.z = (r10.w) * (r0.y) + (r11.w);
    r3.zw = r7.zw;
    r2.xy = (r6.ww) * (-(c[35].zw)) + (r6.xy);
    r2.zw = r3.zw;
    r2 = tex2Dproj(s3, r2);
    r2.w = r2.x;
    r7.xy = (r5.ww) * (-(c[35].xy)) + (r6.xy);
    r7 = tex2Dproj(s3, r7);
    r2.y = r7.x;
    r5.xy = (r5.ww) * (c[35].xy) + (r6.xy);
    r7 = tex2Dproj(s3, r5);
    r2.x = r7.x;
    r3.xy = (r5.ww) * (c[35].zw) + (r6.xy);
    r3 = tex2Dproj(s3, r3);
    r4.w = (r4.w) * (c3.z);
    r4.xyz = (r9.xyz) * (-(r0.zzz)) + (r12.xyz);
    r4 = texCUBElod(s15, r4);
    r0.xyz = (r4.xyz) * (r4.xyz);
    r2.z = r3.x;
    r0.xyz = (r9.www) * (r0.xyz);
    r7.w = dot(r2, c15.zzzz);
    r0.xyz = (r6.zzz) * (r0.xyz);
    r0.xyz = (r11.xyz) * (r0.xyz);
    r2 = (v7.xyzx) * (c1.yyyz) + (c1.zzzy);
    r7.xyz = (r0.xyz) * (c3.zzz) + (r10.xyz);
    r0.z = dot(r2, c[28]);
    r3.w = 1.0f / (r0.z);
    r3.x = dot(r2, c[27]);
    r0.x = dot(r2, c[25]);
    r3.y = (r3.x) * (r3.x);
    r0.y = dot(r2, c[26]);
    r0.z = dot(c[23].yz, r3.xy) + (c[23].x);
    r2.w = saturate(1.0f / (r0.z));
    r2.xy = saturate((r3.xx) * (c[24].xy) + (c[24].zw));
    r3.xy = (r2.xy) * (c16.zz) + (c16.ww);
    r2.xy = (r2.xy) * (r2.xy);
    r0.z = ((-abs(r0.z)) >= 0.0f ? (c1.z) : (r2.w));
    r2.w = (r3.x) * (r2.x);
    r0.z = (r0.z) * (r2.w);
    r2.w = (r2.y) * (-(r3.y)) + (c1.y);
    r0.xy = (r3.ww) * (r0.xy);
    r0.z = (r0.z) * (r2.w);
    r8.w = (r8.w) * (r0.z);
    r0.xy = (r0.xy) * (-(c1.xx)) + (-(c1.xx));
    r6 = tex2D(s4, r0.xy);
    r5 = (-(v7.yyyy)) + (c[6]);
    r4 = (-(v7.xxxx)) + (c[5]);
    r2 = (r5) * (r5);
    r2 = (r4) * (r4) + (r2);
    r3 = (-(v7.zzzz)) + (c[7]);
    r2 = (r3) * (r3) + (r2);
    r0.xyz = (r6.xyz) * (r6.xyz);
    r6.x = rsqrt(r2.x);
    r6.y = rsqrt(r2.y);
    r6.z = rsqrt(r2.z);
    r6.w = rsqrt(r2.w);
    r0.xyz = (r8.www) * (r0.xyz);
    r5 = (r5) * (r6);
    r5 = (r9.yyyy) * (r5);
    r4 = (r4) * (r6);
    r3 = (r3) * (r6);
    r4 = (r4) * (r9.xxxx) + (r5);
    r3 = saturate((r3) * (r9.zzzz) + (r4));
    r4.z = c1.y;
    r2 = saturate((r2) * (c[8]) + (r4.zzzz));
    r0.xyz = (r7.www) * (r0.xyz);
    r2 = (r3) * (r2);
    r1.xyz = (r0.xyz) * (r1.xyz) + (r7.xyz);
    r0.z = dot(c[11], r2);
    r0.x = dot(c[9], r2);
    r0.y = dot(c[10], r2);
    r0.xyz = (r8.xyz) * (r0.xyz) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r1.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[36].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = r0.w;

    return oC0;
}
