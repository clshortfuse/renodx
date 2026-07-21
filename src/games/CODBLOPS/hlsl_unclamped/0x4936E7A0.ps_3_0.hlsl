// Mechanically reconstructed from 0x4936E7A0.ps_3_0.cso.
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
    const float4 c0 = float4(-0.5f, 1.0f, 0.0f, 0.200000003f);
    const float4 c1 = float4(8.0f, 0.797884583f, 1.0f, 0.5f);
    const float4 c3 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c4 = float4(4.0f, -2.0f, 0.600000024f, 0.400000006f);
    const float4 c12 = float4(0.000244140625f, 0.0f, -0.000244140625f, -3.0f);
    const float4 c13 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c14 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.0f);
    const float4 c15 = float4(4.0f, -3.0f, -2.0f, 3.0f);
    const float4 c16 = float4(3.5f, -13.0f, 1.0f, 13.0f);
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

    r0.w = dot(v5.xyz, v5.xyz);
    r1.xyz = (-(v5.xyz)) + (c[5].xyz);
    r9.z = rsqrt(r0.w);
    r0.w = dot(r1.xyz, r1.xyz);
    r0.w = rsqrt(r0.w);
    r2.xyz = (r9.zzz) * (v5.xyz);
    r3.xyz = (r1.xyz) * (r0.www) + (-(r2.xyz));
    r0.xyz = normalize(r3.xyz);
    r3.xyz = normalize(v2.xyz);
    r5.z = saturate(dot(r3.xyz, r0.xyz));
    r4.xyz = (r1.xyz) * (r0.www);
    r0.w = saturate(dot(r0.xyz, r4.xyz));
    r0.z = dot(r4.xyz, c[22].xyz);
    r0.y = saturate((r0.z) * (c[23].x) + (c[23].y));
    r0.w = (-(r0.w)) + (c0.y);
    r0.x = (r0.y) * (c15.z) + (c15.w);
    r0.z = (r0.w) * (r0.w);
    r0.y = (r0.y) * (r0.y);
    r0.z = (r0.z) * (r0.z);
    r6.w = (r0.x) * (r0.y);
    r6.z = (r0.w) * (r0.z);
    r0 = tex2D(s0, v1.xy);
    r3.w = (r0.w) * (v0.w) + (c0.x);
    r0 = (r0.xyzx) * (c0.yyyz) + (c0.zzzy);
    r1 = tex2D(s4, v1.xy);
    r5.xy = (r1.ww) * (c0.zy) + (c0.wz);
    r0 = float4(((r3.w) >= 0.0f ? (r0.x) : (c0.z)), ((r3.w) >= 0.0f ? (r0.y) : (c0.z)), ((r3.w) >= 0.0f ? (r0.z) : (c0.z)), ((r3.w) >= 0.0f ? (r0.w) : (c0.z)));
    r5.xy = float2(((r3.w) >= 0.0f ? (r5.x) : (c0.z)), ((r3.w) >= 0.0f ? (r5.y) : (c0.y)));
    r4.w = (r5.x) * (-(r5.x)) + (c0.y);
    r5.w = (r5.x) * (r5.x);
    r9.w = (r5.y) * (-(c1.y)) + (c1.z);
    r10.z = (r5.y) * (c1.y);
    r2.w = saturate(dot(r4.xyz, r3.xyz));
    r1.w = saturate(dot(r3.xyz, -(r2.xyz)));
    r1.z = (r2.w) * (r9.w) + (r10.z);
    r8.w = (r1.w) * (r9.w) + (r10.z);
    r1.z = (r1.z) * (r8.w) + (c13.x);
    r7.xy = (r5.yy) * (c16.xy) + (c16.zw);
    r1.x = 1.0f / (r1.z);
    r7.w = exp2(r7.y);
    r1.z = pow(abs(r5.z), r7.w);
    r5.z = (r7.w) * (c13.y) + (c13.z);
    r4.z = (r2.w) * (r1.x);
    r1.z = (r1.z) * (r5.z);
    r1.x = (r4.w) * (r6.z) + (r5.w);
    r1.z = (r4.z) * (r1.z);
    r4.xyz = (r0.xyz) * (v0.xyz);
    r0.z = (r1.x) * (r1.z);
    r3.w = ((r3.w) >= 0.0f ? (r1.y) : (c0.z));
    r0.xyz = (r0.zzz) * (c[7].xyz);
    r8.xyz = (r4.xyz) * (r4.xyz);
    r1.xyz = (r3.www) * (r0.xyz);
    r0.xyz = (r2.www) * (c[6].xyz);
    r1.w = (-(r1.w)) + (c0.y);
    r6.xyz = (r8.xyz) * (r0.xyz) + (r1.xyz);
    r0.z = (r1.w) * (r1.w);
    r0.y = 1.0f / (r7.x);
    r0.z = (r1.w) * (r0.z);
    r0.y = (r0.y) * (r0.z);
    r0.z = dot(r2.xyz, r3.xyz);
    r4.z = (r4.w) * (r0.y) + (r5.w);
    r0.z = (r0.z) + (r0.z);
    r1.w = (r5.y) * (c1.x);
    r1.xyz = (r3.xyz) * (-(r0.zzz)) + (r2.xyz);
    r1 = texCUBElod(s15, r1);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r0.xyz = (r3.www) * (r0.xyz);
    r1.xy = (v1.zw) * (c1.zw);
    r1 = tex2D(s13, r1.xy);
    r2 = tex2D(s14, v1.zw);
    r9.xy = (r2.xy) * (c3.ww);
    r7.xyz = (r4.zzz) * (r0.xyz);
    r5.xy = (r1.xz) * (r9.xx);
    r0.x = r1.y;
    r0.z = (r2.x) * (c3.w) + (-(r5.x));
    r2.w = (r1.z) * (-(r9.x)) + (r0.z);
    r1.xy = (v1.zw) * (c3.xy) + (c3.zy);
    r1 = tex2D(s13, r1.xy);
    r4.xy = (r9.yy) * (r1.xz);
    r0.z = (r2.y) * (c3.w) + (-(r4.x));
    r0.y = r1.y;
    r1.w = (r1.z) * (-(r9.y)) + (r0.z);
    r0.xy = (r0.xy) * (c4.xx) + (c4.yy);
    r0.z = dot(r0.xy, r0.xy) + (c0.z);
    r9.y = (r2.w) + (r2.w);
    r0.y = (r1.w) + (r1.w);
    r2.xyz = (v5.xyz) * (-(r9.zzz)) + (c[17].xyz);
    r0.z = exp2(-(r0.z));
    r1.xyz = normalize(r2.xyz);
    r2.z = saturate((r0.z) * (c4.z) + (c4.w));
    r0.z = saturate(dot(r1.xyz, c[17].xyz));
    r9.xz = (r5.xy) * (c4.xx);
    r1.w = (-(r0.z)) + (c0.y);
    r0.xz = (r4.xy) * (c4.xx);
    r2.w = (r1.w) * (r1.w);
    r2.y = (r2.w) * (r2.w);
    r2.w = saturate(dot(r3.xyz, c[17].xyz));
    r2.y = (r1.w) * (r2.y);
    r1.w = (r2.w) * (r9.w) + (r10.z);
    r2.x = saturate(dot(r3.xyz, r1.xyz));
    r1.z = (r1.w) * (r8.w) + (c13.x);
    r1.w = pow(abs(r2.x), r7.w);
    r1.z = 1.0f / (r1.z);
    r1.w = (r5.z) * (r1.w);
    r1.y = (r2.w) * (r1.z);
    r1.z = (r4.w) * (r2.y) + (r5.w);
    r1.w = (r1.w) * (r1.y);
    r0.xyz = (r0.xyz) * (r2.zzz) + (r9.xyz);
    r1.w = (r1.z) * (r1.w);
    r11.xyz = (r3.www) * (r0.xyz);
    r7.w = (r3.w) * (r1.w);
    r1 = tex2D(s12, v1.zw);
    r0.z = ((-abs(r1.y)) >= 0.0f ? (c0.y) : (c0.z));
    r10.xyz = (r2.www) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r1.y;
        r2.w = r0.z;
    }
    else
    {
        if ((c0.y) >= (v4.w))
        {
            r2 = (v4.xyzx) * (c0.yyyz);
            r1 = (r2) + (-(c14.xyzz));
            r1 = tex2Dlod(s1, r1);
            r1.w = r1.x;
            r3 = (r2) + (c12.xxyy);
            r3 = tex2Dlod(s1, r3);
            r1.x = r3.x;
            r3 = (r2) + (c12.zzyy);
            r3 = tex2Dlod(s1, r3);
            r1.y = r3.x;
            r2 = (r2) + (c14.xyzz);
            r2 = tex2Dlod(s1, r2);
            r1.z = r2.x;
            r0.z = dot(r1, c13.zzzz);
            if ((c13.w) < (v4.w))
            {
                r0.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r0.xy) + (c12.xx);
                r1.zw = (v4.zx) * (c0.yz);
                r1 = tex2Dlod(s1, r1);
                r2.xy = (r0.xy) + (c12.zz);
                r2.zw = (v4.zx) * (c0.yz);
                r4 = tex2Dlod(s1, r2);
                r2.xy = (r0.xy) + (c14.xy);
                r2.zw = (v4.zx) * (c0.yz);
                r3 = tex2Dlod(s1, r2);
                r2.xy = (r0.xy) + (-(c14.xy));
                r2.zw = (v4.zx) * (c0.yz);
                r2 = tex2Dlod(s1, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r0.y = dot(r1, c13.zzzz);
                r0.x = (-(r0.z)) + (r0.y);
                r0.y = (v4.w) * (c15.x) + (c15.y);
                r2.w = (r0.y) * (r0.x) + (r0.z);
            }
            else
            {
                r2.w = r0.z;
            }
        }
        else
        {
            r0.z = (v4.w) + (-(c4.x));
            r0.z = ((r0.z) >= 0.0f ? (c0.z) : (c0.y));
            if ((r0.z) != (-(r0.z)))
            {
                r0.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r0.xy) + (c12.xx);
                r2.zw = (v4.zz) * (c0.yz);
                r2 = tex2Dlod(s1, r2);
                r3.xy = (r0.xy) + (c12.zz);
                r3.zw = (v4.zz) * (c0.yz);
                r5 = tex2Dlod(s1, r3);
                r3.xy = (r0.xy) + (c14.xy);
                r3.zw = (v4.zz) * (c0.yz);
                r4 = tex2Dlod(s1, r3);
                r3.xy = (r0.xy) + (-(c14.xy));
                r3.zw = (v4.zz) * (c0.yz);
                r3 = tex2Dlod(s1, r3);
                r2.y = r5.x;
                r2.z = r4.x;
                r2.w = r3.x;
                r0.x = dot(r2, c13.zzzz);
                r0.z = saturate((v4.w) + (c12.w));
                r0.y = (r1.y) + (-(r0.x));
                r0.z = (r0.z) * (r0.y) + (r0.x);
            }
            else
            {
                r0.z = r1.y;
            }
            r2.w = r0.z;
        }
    }
    r1 = (v5.yyyy) * (c[25]);
    r1 = (v5.xxxx) * (c[24]) + (r1);
    r0.xyz = (r2.www) * (r10.xyz) + (r11.xyz);
    r1 = (v5.zzzz) * (c[26]) + (r1);
    r2.xyz = (r7.www) * (c[19].xyz);
    r4 = (r1) + (c[27]);
    r1.xyz = (r2.www) * (r2.xyz);
    r3.zw = r4.zw;
    r8.xyz = (r8.xyz) * (r0.xyz) + (r1.xyz);
    r5.zw = r3.zw;
    r7.xyz = (r7.xyz) * (r9.xyz);
    r2.zw = r5.zw;
    r1.xy = (r4.ww) * (-(c[28].zw)) + (r4.xy);
    r1.zw = r2.zw;
    r1 = tex2Dproj(s2, r1);
    r1.w = r1.x;
    r5.xy = (r3.ww) * (-(c[28].xy)) + (r4.xy);
    r5 = tex2Dproj(s2, r5);
    r1.y = r5.x;
    r3.xy = (r3.ww) * (c[28].xy) + (r4.xy);
    r5 = tex2Dproj(s2, r3);
    r1.x = r5.x;
    r2.xy = (r3.ww) * (c[28].zw) + (r4.xy);
    r3 = tex2Dproj(s2, r2);
    r2 = (v5.xyzx) * (c0.yyyz) + (c0.zzzy);
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
    r3.xy = (r2.xy) * (c15.zz) + (c15.ww);
    r2.xy = (r2.xy) * (r2.xy);
    r0.z = ((-abs(r0.z)) >= 0.0f ? (c0.z) : (r2.w));
    r2.w = (r3.x) * (r2.x);
    r0.z = (r0.z) * (r2.w);
    r2.w = (r2.y) * (-(r3.y)) + (c0.y);
    r0.xy = (r3.ww) * (r0.xy);
    r0.z = (r0.z) * (r2.w);
    r3.w = (r6.w) * (r0.z);
    r0.xy = (r0.xy) * (-(c0.xx)) + (-(c0.xx));
    r2 = tex2D(s3, r0.xy);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r1.w = dot(r1, c13.zzzz);
    r0.xyz = (r3.www) * (r0.xyz);
    r1.xyz = (r7.xyz) * (c1.xxx) + (r8.xyz);
    r0.xyz = (r1.www) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r6.xyz) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r1.x = v2.w;
    r0.xyz = (r1.xxx) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[29].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = r0.w;

    return oC0;
}
