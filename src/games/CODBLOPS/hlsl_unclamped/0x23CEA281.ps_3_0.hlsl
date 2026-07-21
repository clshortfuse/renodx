// Mechanically reconstructed from 0x23CEA281.ps_3_0.cso.
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
    const float4 c1 = float4(0.0f, 0.600000024f, 0.400000006f, 8.0f);
    const float4 c3 = float4(31.875f, 4.0f, -2.0f, 0.0009765625f);
    const float4 c4 = float4(1.0f, 0.797884583f, 0.5f, 0.0f);
    const float4 c12 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c13 = float4(0.125f, 0.25f, 0.000244140625f, 0.0f);
    const float4 c14 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c15 = float4(4.0f, -3.0f, 0.0f, 0.0f);
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

    r0 = tex2D(s1, v1.xy);
    r3.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0.w = dot(r3.xy, r3.xy) + (c1.x);
    r2.w = exp2(-(r0.w));
    r0.xy = (v1.zw) * (c4.xz) + (c4.wz);
    r0 = tex2D(s13, r0.xy);
    r1.xy = (v1.zw) * (c4.xz);
    r1 = tex2D(s13, r1.xy);
    r0.w = r1.y;
    r3.w = (r2.w) * (c1.y) + (c1.z);
    r6.xy = (r0.wy) * (c3.yy) + (c3.zz);
    r1.w = dot(v7.xyz, v7.xyz);
    r0.w = dot(r6.xy, r3.xy) + (c1.x);
    r2 = tex2D(s14, v1.zw);
    r7.xy = (r2.xy) * (c3.xx);
    r4.xy = (r1.xz) * (r7.xx);
    r5.xy = (r0.xz) * (r7.yy);
    r0.x = (r2.x) * (c3.x) + (-(r4.x));
    r0.y = (r2.y) * (c3.x) + (-(r5.x));
    r0.x = (r1.z) * (-(r7.x)) + (r0.x);
    r0.y = (r0.z) * (-(r7.y)) + (r0.y);
    r9.y = (r0.x) + (r0.x);
    r0.z = dot(r6.xy, r6.xy) + (c1.x);
    r0.y = (r0.y) + (r0.y);
    r0.z = exp2(-(r0.z));
    r0.z = (r0.z) * (c1.y) + (c1.z);
    r5.z = rsqrt(r1.w);
    r0.z = (r3.w) * (r0.z);
    r1.xyz = (v7.xyz) * (-(r5.zzz)) + (c[17].xyz);
    r1.w = saturate((r0.w) * (r0.z) + (r0.z));
    r8.xyz = normalize(r1.xyz);
    r0.xz = (r5.xy) * (c3.yy);
    r0.w = saturate(dot(r8.xyz, c[17].xyz));
    r0.xyz = (r0.xyz) * (r1.www);
    r0.w = (-(r0.w)) + (c4.x);
    r9.xz = (r4.xy) * (c3.yy);
    r1.w = (r0.w) * (r0.w);
    r0.xyz = (r9.xyz) * (r3.www) + (r0.xyz);
    r1.w = (r1.w) * (r1.w);
    r7.xyz = (r0.xyz) * (c[20].yyy);
    r5.w = (r0.w) * (r1.w);
    r0 = tex2D(s12, v1.zw);
    r1.xyz = v2.xyz;
    r1.xyz = (r3.xxx) * (v5.xyz) + (r1.xyz);
    r1.xyz = (r3.yyy) * (v4.xyz) + (r1.xyz);
    r10.xyz = normalize(r1.xyz);
    r6.w = saturate(dot(r10.xyz, c[17].xyz));
    r0.w = ((-abs(r0.y)) >= 0.0f ? (c4.x) : (c4.w));
    r6.xyz = (r6.www) * (c[18].xyz);
    if ((r0.w) != (-(r0.w)))
    {
        r0.w = r0.y;
        r3.w = r0.w;
    }
    else
    {
        if ((c4.x) >= (v6.w))
        {
            r1 = (v6.xyzx) * (c4.xxxw);
            r0 = (r1) + (-(c14.xyzz));
            r0 = tex2Dlod(s2, r0);
            r0.w = r0.x;
            r2 = (r1) + (c13.zzww);
            r2 = tex2Dlod(s2, r2);
            r0.x = r2.x;
            r2 = (r1) + (-(c13.zzww));
            r2 = tex2Dlod(s2, r2);
            r0.y = r2.x;
            r1 = (r1) + (c14.xyzz);
            r1 = tex2Dlod(s2, r1);
            r0.z = r1.x;
            r4.w = dot(r0, c13.yyyy);
            if ((c14.w) < (v6.w))
            {
                r4.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
                r0.xy = (r4.xy) + (c13.zz);
                r0.zw = (v6.zx) * (c4.xw);
                r0 = tex2Dlod(s2, r0);
                r1.xy = (r4.xy) + (-(c13.zz));
                r1.zw = (v6.zx) * (c4.xw);
                r3 = tex2Dlod(s2, r1);
                r1.xy = (r4.xy) + (c14.xy);
                r1.zw = (v6.zx) * (c4.xw);
                r2 = tex2Dlod(s2, r1);
                r1.xy = (r4.xy) + (-(c14.xy));
                r1.zw = (v6.zx) * (c4.xw);
                r1 = tex2Dlod(s2, r1);
                r0.y = r3.x;
                r0.z = r2.x;
                r0.w = r1.x;
                r0.w = dot(r0, c13.yyyy);
                r0.z = (-(r4.w)) + (r0.w);
                r0.w = (v6.w) * (c15.x) + (c15.y);
                r3.w = (r0.w) * (r0.z) + (r4.w);
            }
            else
            {
                r3.w = r4.w;
            }
        }
        else
        {
            r0.w = (v6.w) + (-(c3.y));
            r0.w = ((r0.w) >= 0.0f ? (c4.w) : (c4.x));
            if ((r0.w) != (-(r0.w)))
            {
                r5.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r5.xy) + (c13.zz);
                r1.zw = (v6.zz) * (c4.xw);
                r1 = tex2Dlod(s2, r1);
                r2.xy = (r5.xy) + (-(c13.zz));
                r2.zw = (v6.zz) * (c4.xw);
                r4 = tex2Dlod(s2, r2);
                r2.xy = (r5.xy) + (c14.xy);
                r2.zw = (v6.zz) * (c4.xw);
                r3 = tex2Dlod(s2, r2);
                r2.xy = (r5.xy) + (-(c14.xy));
                r2.zw = (v6.zz) * (c4.xw);
                r2 = tex2Dlod(s2, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r0.x = dot(r1, c13.yyyy);
                r0.w = saturate((v6.w) + (c15.y));
                r0.z = (r0.y) + (-(r0.x));
                r0.w = (r0.w) * (r0.z) + (r0.x);
            }
            else
            {
                r0.w = r0.y;
            }
            r3.w = r0.w;
        }
    }
    r2.xyz = (r5.zzz) * (v7.xyz);
    r0.w = saturate(dot(r10.xyz, -(r2.xyz)));
    r1 = tex2D(s3, v1.xy);
    r5.xyz = (r1.xyz) * (-(r1.xyz)) + (c4.xxx);
    r0.z = (r1.w) * (-(c4.y)) + (c4.x);
    r0.x = (r1.w) * (c4.y);
    r0.y = (r0.w) * (r0.z) + (r0.x);
    r0.z = (r6.w) * (r0.z) + (r0.x);
    r11.xyz = (r1.xyz) * (r1.xyz);
    r0.z = (r0.z) * (r0.y) + (c3.w);
    r0.x = 1.0f / (r0.z);
    r3.xy = (r1.ww) * (c12.xy) + (c12.zw);
    r1.y = saturate(dot(r10.xyz, r8.xyz));
    r1.z = exp2(r3.y);
    r0.y = pow(abs(r1.y), r1.z);
    r0.z = (r1.z) * (c13.x) + (c13.y);
    r1.y = (r6.w) * (r0.x);
    r1.z = (r0.y) * (r0.z);
    r0.xyz = (r5.xyz) * (r5.www) + (r11.xyz);
    r2.w = (r1.y) * (r1.z);
    r1.xyz = (r3.www) * (r6.xyz) + (r7.xyz);
    r0.xyz = (r0.xyz) * (r2.www);
    r0.xyz = (r0.xyz) * (c[20].www);
    r0.w = (-(r0.w)) + (c4.x);
    r0.xyz = (r0.xyz) * (c[19].xyz);
    r3.z = (r0.w) * (r0.w);
    r2.w = 1.0f / (r3.x);
    r0.w = (r0.w) * (r3.z);
    r3.xyz = (r3.www) * (r0.xyz);
    r5.w = (r2.w) * (r0.w);
    r0 = tex2D(s0, v1.xy);
    r0 = (r0.wxyz) * (v0.wxyz);
    r6.xyz = (r0.yzw) * (r0.yzw);
    r0.w = dot(r2.xyz, r10.xyz);
    r7.xyz = (r6.xyz) * (r1.xyz) + (r3.xyz);
    r0.w = (r0.w) + (r0.w);
    r1.w = (r1.w) * (c1.w);
    r1.xyz = (r10.xyz) * (-(r0.www)) + (r2.xyz);
    r1 = texCUBElod(s15, r1);
    r8.xyz = (r1.xyz) * (r1.xyz);
    r4 = (-(v7.yyyy)) + (c[6]);
    r3 = (-(v7.xxxx)) + (c[5]);
    r1 = (r4) * (r4);
    r1 = (r3) * (r3) + (r1);
    r2 = (-(v7.zzzz)) + (c[7]);
    r8.xyz = (r8.xyz) * (c[20].xxx);
    r1 = (r2) * (r2) + (r1);
    r11.xyz = (r5.xyz) * (r5.www) + (r11.xyz);
    r5.x = rsqrt(r1.x);
    r5.y = rsqrt(r1.y);
    r5.z = rsqrt(r1.z);
    r5.w = rsqrt(r1.w);
    r8.xyz = (r8.xyz) * (r11.xyz);
    r4 = (r4) * (r5);
    r4 = (r10.yyyy) * (r4);
    r3 = (r3) * (r5);
    r2 = (r2) * (r5);
    r3 = (r3) * (r10.xxxx) + (r4);
    r2 = saturate((r2) * (r10.zzzz) + (r3));
    r0.w = c4.x;
    r1 = saturate((r1) * (c[8]) + (r0.wwww));
    r3.xyz = (r9.xyz) * (r8.xyz);
    r1 = (r2) * (r1);
    r3.xyz = (r3.xyz) * (c1.www) + (r7.xyz);
    r2.z = dot(c[11], r1);
    r2.x = dot(c[9], r1);
    r2.y = dot(c[10], r1);
    r1.xyz = (r6.xyz) * (r2.xyz) + (r3.xyz);
    r2.xyz = (r0.xxx) * (v3.xyz);
    r1.xyz = (r1.xyz) * (r0.xxx) + (-(r2.xyz));
    r1.xyz = (v2.www) * (r1.xyz) + (r2.xyz);
    r1.xyz = max(((r1.xyz) * (c[21].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
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
