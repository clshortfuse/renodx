// Mechanically reconstructed from 0x912CCEDE.ps_3_0.cso.
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
    const float4 c1 = float4(-1.0f, 1.0f, 0.200000003f, -0.5f);
    const float4 c3 = float4(0.0f, 1.0f, 0.200000003f, 8.0f);
    const float4 c4 = float4(0.600000024f, 0.400000006f, 0.797884583f, 31.875f);
    const float4 c12 = float4(1.0f, 0.5f, 0.0f, 4.0f);
    const float4 c13 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c14 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.0f);
    const float4 c15 = float4(0.000244140625f, 0.0f, -0.000244140625f, -3.0f);
    const float4 c16 = float4(4.0f, -3.0f, -2.0f, 3.0f);
    const float4 c30 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c31 = float4(4.0f, -2.0f, 0.797884583f, 1.0f);
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
    float4 r15 = 0.0f;
    float4 r16 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = tex2D(s1, v1.xy);
    r10.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r3 = tex2D(s7, v1.xy);
    r0 = tex2D(s5, v8.xy);
    r0.xyz = (r0.xyz) + (c1.xxx);
    r1.w = r3.w;
    r1.xyz = (v0.yyy) * (r0.xyz) + (c1.yyy);
    r0 = tex2D(s0, v1.xy);
    r2.xyz = (r1.xyz) * (r0.xyz);
    r0 = tex2D(s6, v8.zw);
    r3.w = (r0.w) * (v0.z) + (c1.w);
    r1.xyz = (r1.xyz) * (c1.zzz);
    r4.xyz = float3(((r3.w) >= 0.0f ? (r0.x) : (r2.x)), ((r3.w) >= 0.0f ? (r0.y) : (r2.y)), ((r3.w) >= 0.0f ? (r0.z) : (r2.z)));
    r2 = tex2D(s8, v8.zw);
    r0.w = dot(v7.xyz, v7.xyz);
    r6.xyz = (-(v7.xyz)) + (c[5].xyz);
    r15.w = rsqrt(r0.w);
    r0.w = dot(r6.xyz, r6.xyz);
    r2.z = rsqrt(r0.w);
    r14.xyz = (r15.www) * (v7.xyz);
    r0 = (r2.wwww) * (c3.xxxy) + (c3.zzzx);
    r7.xyz = (r6.xyz) * (r2.zzz) + (-(r14.xyz));
    r5.xyz = normalize(r7.xyz);
    r9.xyz = (r6.xyz) * (r2.zzz);
    r1 = float4(((r3.w) >= 0.0f ? (r0.x) : (r1.x)), ((r3.w) >= 0.0f ? (r0.y) : (r1.y)), ((r3.w) >= 0.0f ? (r0.z) : (r1.z)), ((r3.w) >= 0.0f ? (r0.w) : (r1.w)));
    r0.w = saturate(dot(r5.xyz, r9.xyz));
    r11.xyz = (r1.xyz) * (-(r1.xyz)) + (c1.yyy);
    r2.w = (-(r0.w)) + (c1.y);
    r12.w = (r1.w) * (-(c31.z)) + (c31.w);
    r0.w = (r2.w) * (r2.w);
    r2.z = (r0.w) * (r0.w);
    r0 = v2;
    r0.xyz = (r10.xxx) * (v5.xyz) + (r0.xyz);
    r2.w = (r2.w) * (r2.z);
    r0.xyz = (r10.yyy) * (v4.xyz) + (r0.xyz);
    r12.xyz = (r1.xyz) * (r1.xyz);
    r13.xyz = normalize(r0.xyz);
    r1.y = saturate(dot(r13.xyz, r5.xyz));
    r13.w = (r1.w) * (c4.z);
    r1.z = saturate(dot(r9.xyz, r13.xyz));
    r14.w = saturate(dot(r13.xyz, -(r14.xyz)));
    r0.z = (r1.z) * (r12.w) + (r13.w);
    r11.w = (r14.w) * (r12.w) + (r13.w);
    r0.z = (r0.z) * (r11.w) + (c13.x);
    r16.xy = (r1.ww) * (c30.xy) + (c30.zw);
    r0.y = 1.0f / (r0.z);
    r10.w = exp2(r16.y);
    r0.z = pow(abs(r1.y), r10.w);
    r8.w = (r10.w) * (c13.y) + (c13.z);
    r1.x = (r1.z) * (r0.y);
    r1.y = (r0.z) * (r8.w);
    r0.xyz = (r11.xyz) * (r2.www) + (r12.xyz);
    r1.y = (r1.x) * (r1.y);
    r7.w = ((r3.w) >= 0.0f ? (r2.y) : (r3.y));
    r0.xyz = (r0.xyz) * (r1.yyy);
    r8.xyz = (r4.xyz) * (r4.xyz);
    r0.xyz = (r0.xyz) * (c[7].xyz);
    r5.xyz = (r7.www) * (r0.xyz);
    r0.z = dot(r10.xy, r10.xy) + (c3.x);
    r1.xyz = (r1.zzz) * (c[6].xyz);
    r0.z = exp2(-(r0.z));
    r5.w = (r0.z) * (c4.x) + (c4.y);
    r0.xy = (v1.zw) * (-(c1.xw));
    r4 = tex2D(s13, r0.xy);
    r0.xy = (v1.zw) * (c12.xy) + (c12.zy);
    r2 = tex2D(s13, r0.xy);
    r4.w = r2.y;
    r3 = tex2D(s14, v1.zw);
    r0.xy = (r3.xy) * (c4.ww);
    r6.xy = (r4.yw) * (c31.xx) + (c31.yy);
    r4.xy = (r4.xz) * (r0.xx);
    r0.z = dot(r6.xy, r10.xy) + (c3.x);
    r2.w = (r3.x) * (c4.w) + (-(r4.x));
    r2.w = (r4.z) * (-(r0.x)) + (r2.w);
    r2.xy = (r2.xz) * (r0.yy);
    r3.w = (r3.y) * (c4.w) + (-(r2.x));
    r0.x = dot(r6.xy, r6.xy) + (c3.x);
    r0.y = (r2.z) * (-(r0.y)) + (r3.w);
    r0.x = exp2(-(r0.x));
    r10.y = (r2.w) + (r2.w);
    r0.x = (r0.x) * (c4.x) + (c4.y);
    r0.y = (r0.y) + (r0.y);
    r0.x = (r5.w) * (r0.x);
    r2.w = saturate((r0.z) * (r0.x) + (r0.x));
    r0.xz = (r2.xy) * (c12.ww);
    r0.xyz = (r0.xyz) * (r2.www);
    r10.xz = (r4.xy) * (c12.ww);
    r7.xyz = (r8.xyz) * (r1.xyz) + (r5.xyz);
    r0.xyz = (r10.xyz) * (r5.www) + (r0.xyz);
    r15.xyz = (r7.www) * (r0.xyz);
    r9.w = saturate(dot(r13.xyz, c[17].xyz));
    r2 = tex2D(s12, v1.zw);
    r0.z = ((-abs(r2.y)) >= 0.0f ? (c3.y) : (c3.x));
    r1.xyz = (r9.www) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r2.y;
        r2.w = r0.z;
    }
    else
    {
        if ((c1.y) >= (v6.w))
        {
            r3 = (v6.xyzx) * (c3.yyyx);
            r2 = (r3) + (-(c14.xyzz));
            r2 = tex2Dlod(s2, r2);
            r2.w = r2.x;
            r4 = (r3) + (c15.xxyy);
            r4 = tex2Dlod(s2, r4);
            r2.x = r4.x;
            r4 = (r3) + (c15.zzyy);
            r4 = tex2Dlod(s2, r4);
            r2.y = r4.x;
            r3 = (r3) + (c14.xyzz);
            r3 = tex2Dlod(s2, r3);
            r2.z = r3.x;
            r0.z = dot(r2, c13.zzzz);
            if ((c13.w) < (v6.w))
            {
                r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r0.xy) + (c15.xx);
                r2.zw = (v6.zx) * (c3.yx);
                r2 = tex2Dlod(s2, r2);
                r3.xy = (r0.xy) + (c15.zz);
                r3.zw = (v6.zx) * (c3.yx);
                r5 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (c14.xy);
                r3.zw = (v6.zx) * (c3.yx);
                r4 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (-(c14.xy));
                r3.zw = (v6.zx) * (c3.yx);
                r3 = tex2Dlod(s2, r3);
                r2.y = r5.x;
                r2.z = r4.x;
                r2.w = r3.x;
                r0.y = dot(r2, c13.zzzz);
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
            r0.z = (v6.w) + (-(c12.w));
            r0.z = ((r0.z) >= 0.0f ? (c3.x) : (c3.y));
            if ((r0.z) != (-(r0.z)))
            {
                r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
                r3.xy = (r0.xy) + (c15.xx);
                r3.zw = (v6.zz) * (c3.yx);
                r3 = tex2Dlod(s2, r3);
                r4.xy = (r0.xy) + (c15.zz);
                r4.zw = (v6.zz) * (c3.yx);
                r6 = tex2Dlod(s2, r4);
                r4.xy = (r0.xy) + (c14.xy);
                r4.zw = (v6.zz) * (c3.yx);
                r5 = tex2Dlod(s2, r4);
                r4.xy = (r0.xy) + (-(c14.xy));
                r4.zw = (v6.zz) * (c3.yx);
                r4 = tex2Dlod(s2, r4);
                r3.y = r6.x;
                r3.z = r5.x;
                r3.w = r4.x;
                r0.x = dot(r3, c13.zzzz);
                r0.z = saturate((v6.w) + (c15.w));
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
    r2.xyz = (v7.xyz) * (-(r15.www)) + (c[17].xyz);
    r0.xyz = normalize(r2.xyz);
    r2.z = saturate(dot(r0.xyz, c[17].xyz));
    r3.w = (-(r2.z)) + (c1.y);
    r3.z = (r3.w) * (r3.w);
    r2.xyz = (r2.www) * (r1.xyz) + (r15.xyz);
    r1.z = (r3.z) * (r3.z);
    r3.z = (r3.w) * (r1.z);
    r1.z = (-(r14.w)) + (c1.y);
    r1.x = 1.0f / (r16.x);
    r1.y = (r1.z) * (r1.z);
    r1.y = (r1.z) * (r1.y);
    r1.z = dot(r14.xyz, r13.xyz);
    r3.w = (r1.x) * (r1.y);
    r1.z = (r1.z) + (r1.z);
    r1.w = (r1.w) * (c3.w);
    r1.xyz = (r13.xyz) * (-(r1.zzz)) + (r14.xyz);
    r1 = texCUBElod(s15, r1);
    r1.w = (r9.w) * (r12.w) + (r13.w);
    r3.y = (r1.w) * (r11.w) + (c13.x);
    r1.w = saturate(dot(r13.xyz, r0.xyz));
    r0.y = 1.0f / (r3.y);
    r0.z = pow(abs(r1.w), r10.w);
    r0.y = (r9.w) * (r0.y);
    r0.z = (r8.w) * (r0.z);
    r1.w = (r0.y) * (r0.z);
    r3.xyz = (r11.xyz) * (r3.zzz) + (r12.xyz);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r1.xyz = (r1.www) * (r3.xyz);
    r0.xyz = (r7.www) * (r0.xyz);
    r1.xyz = (r7.www) * (r1.xyz);
    r3.xyz = (r11.xyz) * (r3.www) + (r12.xyz);
    r1.xyz = (r1.xyz) * (c[19].xyz);
    r0.xyz = (r0.xyz) * (r3.xyz);
    r1.xyz = (r2.www) * (r1.xyz);
    r8.xyz = (r8.xyz) * (r2.xyz) + (r1.xyz);
    r1 = (v7.yyyy) * (c[25]);
    r6.xyz = (r10.xyz) * (r0.xyz);
    r1 = (v7.xxxx) * (c[24]) + (r1);
    r0.z = dot(r9.xyz, c[22].xyz);
    r1 = (v7.zzzz) * (c[26]) + (r1);
    r0.z = saturate((r0.z) * (c[23].x) + (c[23].y));
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
    r2 = (v7.xyzx) * (c3.yyyx) + (c3.xxxy);
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
    r0.z = ((-abs(r0.z)) >= 0.0f ? (c3.x) : (r2.w));
    r2.w = (r3.x) * (r2.x);
    r0.z = (r0.z) * (r2.w);
    r2.w = (r2.y) * (-(r3.y)) + (c1.y);
    r0.xy = (r3.ww) * (r0.xy);
    r0.z = (r0.z) * (r2.w);
    r3.w = (r4.z) * (r0.z);
    r0.xy = (r0.xy) * (-(c1.ww)) + (-(c1.ww));
    r2 = tex2D(s4, r0.xy);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r1.w = dot(r1, c13.zzzz);
    r0.xyz = (r3.www) * (r0.xyz);
    r1.xyz = (r6.xyz) * (c3.www) + (r8.xyz);
    r0.xyz = (r1.www) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r7.xyz) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[29].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c1.y;

    return oC0;
}
