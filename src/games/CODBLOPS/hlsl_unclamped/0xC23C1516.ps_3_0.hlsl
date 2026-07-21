// Mechanically reconstructed from 0xC23C1516.ps_3_0.cso.
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
    const float4 c1 = float4(4.0f, -2.0f, 2.0f, 0.25f);
    const float4 c3 = float4(0.600000024f, 0.400000006f, 31.875f, 4.0f);
    const float4 c4 = float4(0.000244140625f, 0.0f, -0.000244140625f, 0.75f);
    const float4 c12 = float4(0.00048828125f, -0.000122070312f, 0.0f, -3.0f);
    const float4 c13 = float4(4.0f, -3.0f, -2.0f, 3.0f);
    const float4 c14 = float4(-1.0f, 1.0f, 0.0f, 0.5f);
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

    r0 = tex2D(s1, v0.xy);
    r1 = tex2D(s5, v7.zw);
    r1.xyz = (r1.xyz) + (c14.xxx);
    r5.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r1.xyz = (v7.yyy) * (r1.xyz) + (c14.yyy);
    r0 = tex2D(s0, v0.xy);
    r0.xyz = (r1.xyz) * (r0.xyz);
    r6.xyz = (r0.xyz) * (r0.xyz);
    r0.w = dot(r5.xy, r5.xy) + (c14.z);
    r1.w = exp2(-(r0.w));
    r0.xy = (v0.zw) * (c14.yw);
    r0 = tex2D(s13, r0.xy);
    r1.xy = (v0.zw) * (c14.yw) + (c14.zw);
    r2 = tex2D(s13, r1.xy);
    r0.w = r2.y;
    r2.w = (r1.w) * (c3.x) + (c3.y);
    r4.xy = (r0.yw) * (c1.xx) + (c1.yy);
    r1 = tex2D(s14, v0.zw);
    r3.xy = (r1.xy) * (c3.zz);
    r0.y = dot(r4.xy, r5.xy) + (c14.z);
    r2.xy = (r2.xz) * (r3.yy);
    r0.w = (r1.y) * (c3.z) + (-(r2.x));
    r1.w = dot(r4.xy, r4.xy) + (c14.z);
    r0.w = (r2.z) * (-(r3.y)) + (r0.w);
    r1.w = exp2(-(r1.w));
    r4.xy = (r0.xz) * (r3.xx);
    r0.x = (r1.w) * (c3.x) + (c3.y);
    r1.w = (r1.x) * (c3.z) + (-(r4.x));
    r0.x = (r2.w) * (r0.x);
    r0.z = (r0.z) * (-(r3.x)) + (r1.w);
    r1.w = saturate((r0.y) * (r0.x) + (r0.x));
    r1.y = (r2.w) * (r0.z);
    r3.y = (r0.w) + (r0.w);
    r3.xz = (r2.xy) * (c3.ww);
    r0 = v1;
    r2.xyz = (r5.xxx) * (v4.xyz) + (r0.xyz);
    r0.xyz = (r1.www) * (r3.xyz);
    r2.xyz = (r5.yyy) * (v3.xyz) + (r2.xyz);
    r1.xz = (r2.ww) * (r4.xy);
    r9.xyz = normalize(r2.xyz);
    r8.xyz = (r1.xyz) * (c1.xzx) + (r0.xyz);
    r0.y = saturate(dot(c[17].xyz, r9.xyz));
    r1 = tex2D(s12, v0.zw);
    r0.z = ((-abs(r1.y)) >= 0.0f ? (c14.y) : (c14.z));
    r7.xyz = (r0.yyy) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r1.y;
    }
    else
    {
        if ((c14.y) >= (v5.w))
        {
            r2 = (v5.xyzx) * (c14.yyyz);
            r1 = (r2) + (-(c12.xyzz));
            r1 = tex2Dlod(s2, r1);
            r1.w = r1.x;
            r3 = (r2) + (c4.xxyy);
            r3 = tex2Dlod(s2, r3);
            r1.x = r3.x;
            r3 = (r2) + (c4.zzyy);
            r3 = tex2Dlod(s2, r3);
            r1.y = r3.x;
            r2 = (r2) + (c12.xyzz);
            r2 = tex2Dlod(s2, r2);
            r1.z = r2.x;
            r0.z = dot(r1, c1.wwww);
            if ((c4.w) < (v5.w))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r0.xy) + (c4.xx);
                r1.zw = (v5.zx) * (c14.yz);
                r1 = tex2Dlod(s2, r1);
                r2.xy = (r0.xy) + (c4.zz);
                r2.zw = (v5.zx) * (c14.yz);
                r4 = tex2Dlod(s2, r2);
                r2.xy = (r0.xy) + (c12.xy);
                r2.zw = (v5.zx) * (c14.yz);
                r3 = tex2Dlod(s2, r2);
                r2.xy = (r0.xy) + (-(c12.xy));
                r2.zw = (v5.zx) * (c14.yz);
                r2 = tex2Dlod(s2, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r0.y = dot(r1, c1.wwww);
                r0.x = (-(r0.z)) + (r0.y);
                r0.y = (v5.w) * (c13.x) + (c13.y);
                r0.z = (r0.y) * (r0.x) + (r0.z);
            }
        }
        else
        {
            r0.z = (v5.w) + (-(c3.w));
            r0.z = ((r0.z) >= 0.0f ? (c14.z) : (c14.y));
            if ((r0.z) != (-(r0.z)))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r0.xy) + (c4.xx);
                r2.zw = (v5.zz) * (c14.yz);
                r2 = tex2Dlod(s2, r2);
                r3.xy = (r0.xy) + (c4.zz);
                r3.zw = (v5.zz) * (c14.yz);
                r5 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (c12.xy);
                r3.zw = (v5.zz) * (c14.yz);
                r4 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (-(c12.xy));
                r3.zw = (v5.zz) * (c14.yz);
                r3 = tex2Dlod(s2, r3);
                r2.y = r5.x;
                r2.z = r4.x;
                r2.w = r3.x;
                r0.x = dot(r2, c1.wwww);
                r0.z = saturate((v5.w) + (c12.w));
                r0.y = (r1.y) + (-(r0.x));
                r0.z = (r0.z) * (r0.y) + (r0.x);
            }
            else
            {
                r0.z = r1.y;
            }
        }
    }
    r1 = (v6.xyzx) * (c14.yyyz) + (c14.zzzy);
    r0.xyz = (r0.zzz) * (r7.xyz) + (r8.xyz);
    r2.w = dot(r1, c[27]);
    r2.w = 1.0f / (r2.w);
    r2.x = dot(r1, c[26]);
    r3.x = dot(r1, c[24]);
    r2.y = (r2.x) * (r2.x);
    r3.y = dot(r1, c[25]);
    r1.w = dot(c[22].yz, r2.xy) + (c[22].x);
    r1.xy = (r2.ww) * (r3.xy);
    r1.z = saturate(1.0f / (r1.w));
    r7.xy = (r1.xy) * (c14.ww) + (c14.ww);
    r2.w = ((-abs(r1.w)) >= 0.0f ? (c14.z) : (r1.z));
    r2.xy = saturate((r2.xx) * (c[23].xy) + (c[23].zw));
    r1 = (v6.yyyy) * (c[31]);
    r3.xy = (r2.xy) * (c13.zz) + (c13.ww);
    r1 = (v6.xxxx) * (c[30]) + (r1);
    r2.xy = (r2.xy) * (r2.xy);
    r1 = (v6.zzzz) * (c[32]) + (r1);
    r2.z = (r3.x) * (r2.x);
    r4 = (r1) + (c[33]);
    r1.w = (r2.w) * (r2.z);
    r3.zw = r4.zw;
    r1.z = (r2.y) * (-(r3.y)) + (c14.y);
    r5.zw = r3.zw;
    r4.z = (r1.w) * (r1.z);
    r2.zw = r5.zw;
    r1.xy = (r4.ww) * (-(c[34].zw)) + (r4.xy);
    r1.zw = r2.zw;
    r1 = tex2Dproj(s3, r1);
    r1.w = r1.x;
    r5.xy = (r3.ww) * (-(c[34].xy)) + (r4.xy);
    r5 = tex2Dproj(s3, r5);
    r1.y = r5.x;
    r3.xy = (r3.ww) * (c[34].xy) + (r4.xy);
    r5 = tex2Dproj(s3, r3);
    r1.x = r5.x;
    r2.xy = (r3.ww) * (c[34].zw) + (r4.xy);
    r2 = tex2Dproj(s3, r2);
    r3.xyz = (-(v6.xyz)) + (c[20].xyz);
    r5.xyz = normalize(r3.xyz);
    r1.z = dot(r5.xyz, c[28].xyz);
    r1.z = saturate((r1.z) * (c[29].x) + (c[29].y));
    r2.w = (r1.z) * (c13.z) + (c13.w);
    r1.z = (r1.z) * (r1.z);
    r2.w = (r2.w) * (r1.z);
    r1.z = r2.x;
    r3.w = (r4.z) * (r2.w);
    r2 = tex2D(s4, r7.xy);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r1.w = dot(r1, c1.wwww);
    r1.xyz = (r3.www) * (r2.xyz);
    r7.xyz = (r1.www) * (r1.xyz);
    r4 = (-(v6.yyyy)) + (c[6]);
    r3 = (-(v6.xxxx)) + (c[5]);
    r1 = (r4) * (r4);
    r1 = (r3) * (r3) + (r1);
    r2 = (-(v6.zzzz)) + (c[7]);
    r5.w = saturate(dot(r5.xyz, r9.xyz));
    r1 = (r2) * (r2) + (r1);
    r8.xyz = (r5.www) * (c[21].xyz);
    r5.x = rsqrt(r1.x);
    r5.y = rsqrt(r1.y);
    r5.z = rsqrt(r1.z);
    r5.w = rsqrt(r1.w);
    r8.xyz = (r6.xyz) * (r8.xyz);
    r4 = (r4) * (r5);
    r4 = (r9.yyyy) * (r4);
    r3 = (r3) * (r5);
    r2 = (r2) * (r5);
    r3 = (r3) * (r9.xxxx) + (r4);
    r2 = saturate((r2) * (r9.zzzz) + (r3));
    r3.z = c14.y;
    r1 = saturate((r1) * (c[8]) + (r3.zzzz));
    r3.xyz = (r7.xyz) * (r8.xyz);
    r1 = (r2) * (r1);
    r2.xyz = (r6.xyz) * (r0.xyz) + (r3.xyz);
    r0.z = dot(c[11], r1);
    r0.x = dot(c[9], r1);
    r0.y = dot(c[10], r1);
    r0.xyz = (r6.xyz) * (r0.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[35].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c14.y;

    return oC0;
}
