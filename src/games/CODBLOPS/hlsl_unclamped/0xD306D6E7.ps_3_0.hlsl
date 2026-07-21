// Mechanically reconstructed from 0xD306D6E7.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
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
    const float4 c0 = float4(8.0f, 1.0f, 0.797884583f, 0.5f);
    const float4 c1 = float4(0.959999979f, 0.0399999991f, 31.875f, 4.0f);
    const float4 c3 = float4(4.0f, -2.0f, 0.600000024f, 0.400000006f);
    const float4 c4 = float4(1.0f, 0.5f, 0.0f, 0.0009765625f);
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

    r1.w = dot(v5.xyz, v5.xyz);
    r0.xy = (v1.zw) * (c0.yw);
    r0 = tex2D(s13, r0.xy);
    r2 = tex2D(s14, v1.zw);
    r5.xy = (r2.xy) * (c1.zz);
    r1.w = rsqrt(r1.w);
    r4.xy = (r0.xz) * (r5.xx);
    r1.x = r0.y;
    r0.w = (r2.x) * (c1.z) + (-(r4.x));
    r1.z = (r0.z) * (-(r5.x)) + (r0.w);
    r0.xy = (v1.zw) * (c4.xy) + (c4.zy);
    r0 = tex2D(s13, r0.xy);
    r3.xy = (r5.yy) * (r0.xz);
    r1.y = r0.y;
    r0.w = (r2.y) * (c1.z) + (-(r3.x));
    r0.xy = (r1.xy) * (c3.xx) + (c3.yy);
    r0.z = (r0.z) * (-(r5.y)) + (r0.w);
    r0.w = dot(r0.xy, r0.xy) + (c4.z);
    r8.y = (r1.z) + (r1.z);
    r2.xyz = (v5.xyz) * (-(r1.www)) + (c[17].xyz);
    r0.y = (r0.z) + (r0.z);
    r1.xyz = normalize(r2.xyz);
    r0.z = exp2(-(r0.w));
    r0.w = saturate(dot(r1.xyz, c[17].xyz));
    r2.z = saturate((r0.z) * (c3.z) + (c3.w));
    r0.w = (-(r0.w)) + (c0.y);
    r8.xz = (r4.xy) * (c1.ww);
    r2.w = (r0.w) * (r0.w);
    r0.xz = (r3.xy) * (c1.ww);
    r2.w = (r2.w) * (r2.w);
    r0.xyz = (r0.xyz) * (r2.zzz) + (r8.xyz);
    r2.w = (r0.w) * (r2.w);
    r4 = tex2D(s2, v1.xy);
    r2.z = (r4.w) * (-(c0.z)) + (c0.y);
    r2.x = (r4.w) * (c0.z);
    r10.xyz = (r1.www) * (v5.xyz);
    r9.xyz = normalize(v2.xyz);
    r0.w = saturate(dot(r9.xyz, -(r10.xyz)));
    r1.w = saturate(dot(r9.xyz, c[17].xyz));
    r2.y = (r0.w) * (r2.z) + (r2.x);
    r2.z = (r1.w) * (r2.z) + (r2.x);
    r2.w = (r2.w) * (c1.x) + (c1.y);
    r2.z = (r2.z) * (r2.y) + (c4.w);
    r2.z = 1.0f / (r2.z);
    r2.xy = (r4.ww) * (c12.xy) + (c12.zw);
    r2.y = exp2(r2.y);
    r3.w = saturate(dot(r9.xyz, r1.xyz));
    r1.x = pow(abs(r3.w), r2.y);
    r1.z = (r2.y) * (c13.x) + (c13.y);
    r1.y = (r1.w) * (r2.z);
    r1.z = (r1.x) * (r1.z);
    r1.z = (r1.y) * (r1.z);
    r0.w = (-(r0.w)) + (c0.y);
    r1.y = (r2.w) * (r1.z);
    r1.x = (r0.w) * (r0.w);
    r1.z = 1.0f / (r2.x);
    r0.w = (r0.w) * (r1.x);
    r4.z = (r4.y) * (r1.y);
    r0.w = (r1.z) * (r0.w);
    r6.w = (r0.w) * (c1.x) + (c1.y);
    r7.xyz = (r0.xyz) * (r4.yyy);
    r0 = tex2D(s12, v1.zw);
    r0.w = ((-abs(r0.y)) >= 0.0f ? (c4.x) : (c4.z));
    r6.xyz = (r1.www) * (c[18].xyz);
    if ((r0.w) != (-(r0.w)))
    {
        r0.w = r0.y;
    }
    else
    {
        if ((c0.y) >= (v4.w))
        {
            r1 = (v4.xyzx) * (c4.xxxz);
            r0 = (r1) + (-(c14.xyzz));
            r0 = tex2Dlod(s1, r0);
            r0.w = r0.x;
            r2 = (r1) + (c13.zzww);
            r2 = tex2Dlod(s1, r2);
            r0.x = r2.x;
            r2 = (r1) + (-(c13.zzww));
            r2 = tex2Dlod(s1, r2);
            r0.y = r2.x;
            r1 = (r1) + (c14.xyzz);
            r1 = tex2Dlod(s1, r1);
            r0.z = r1.x;
            r4.x = dot(r0, c13.yyyy);
            if ((c14.w) < (v4.w))
            {
                r5.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
                r0.xy = (r5.xy) + (c13.zz);
                r0.zw = (v4.zx) * (c4.xz);
                r0 = tex2Dlod(s1, r0);
                r1.xy = (r5.xy) + (-(c13.zz));
                r1.zw = (v4.zx) * (c4.xz);
                r3 = tex2Dlod(s1, r1);
                r1.xy = (r5.xy) + (c14.xy);
                r1.zw = (v4.zx) * (c4.xz);
                r2 = tex2Dlod(s1, r1);
                r1.xy = (r5.xy) + (-(c14.xy));
                r1.zw = (v4.zx) * (c4.xz);
                r1 = tex2Dlod(s1, r1);
                r0.y = r3.x;
                r0.z = r2.x;
                r0.w = r1.x;
                r0.w = dot(r0, c13.yyyy);
                r0.z = (-(r4.x)) + (r0.w);
                r0.w = (v4.w) * (c15.x) + (c15.y);
                r0.w = (r0.w) * (r0.z) + (r4.x);
            }
            else
            {
                r0.w = r4.x;
            }
        }
        else
        {
            r0.w = (v4.w) + (-(c1.w));
            r0.w = ((r0.w) >= 0.0f ? (c4.z) : (c4.x));
            if ((r0.w) != (-(r0.w)))
            {
                r11.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r11.xy) + (c13.zz);
                r1.zw = (v4.zz) * (c4.xz);
                r1 = tex2Dlod(s1, r1);
                r2.xy = (r11.xy) + (-(c13.zz));
                r2.zw = (v4.zz) * (c4.xz);
                r5 = tex2Dlod(s1, r2);
                r2.xy = (r11.xy) + (c14.xy);
                r2.zw = (v4.zz) * (c4.xz);
                r3 = tex2Dlod(s1, r2);
                r2.xy = (r11.xy) + (-(c14.xy));
                r2.zw = (v4.zz) * (c4.xz);
                r2 = tex2Dlod(s1, r2);
                r1.y = r5.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r0.x = dot(r1, c13.yyyy);
                r0.w = saturate((v4.w) + (c15.y));
                r0.z = (r0.y) + (-(r0.x));
                r0.w = (r0.w) * (r0.z) + (r0.x);
            }
            else
            {
                r0.w = r0.y;
            }
        }
    }
    r0.xyz = (r4.zzz) * (c[19].xyz);
    r1.xyz = (r0.www) * (r6.xyz) + (r7.xyz);
    r2.xyz = (r0.www) * (r0.xyz);
    r0 = tex2D(s0, v1.xy);
    r0.xyz = (r0.xyz) * (v0.xyz);
    r6.xyz = (r0.xyz) * (r0.xyz);
    r0.w = dot(r10.xyz, r9.xyz);
    r7.xyz = (r6.xyz) * (r1.xyz) + (r2.xyz);
    r0.z = (r0.w) + (r0.w);
    r0.w = (r4.w) * (c0.x);
    r0.xyz = (r9.xyz) * (-(r0.zzz)) + (r10.xyz);
    r5 = texCUBElod(s15, r0);
    r3 = (-(v5.yyyy)) + (c[6]);
    r2 = (-(v5.xxxx)) + (c[5]);
    r0 = (r3) * (r3);
    r0 = (r2) * (r2) + (r0);
    r1 = (-(v5.zzzz)) + (c[7]);
    r5.xyz = (r5.xyz) * (r5.xyz);
    r0 = (r1) * (r1) + (r0);
    r5.xyz = (r4.yyy) * (r5.xyz);
    r4.x = rsqrt(r0.x);
    r4.y = rsqrt(r0.y);
    r4.z = rsqrt(r0.z);
    r4.w = rsqrt(r0.w);
    r5.xyz = (r6.www) * (r5.xyz);
    r3 = (r3) * (r4);
    r3 = (r9.yyyy) * (r3);
    r2 = (r2) * (r4);
    r1 = (r1) * (r4);
    r2 = (r2) * (r9.xxxx) + (r3);
    r1 = saturate((r1) * (r9.zzzz) + (r2));
    r2.z = c0.y;
    r0 = saturate((r0) * (c[8]) + (r2.zzzz));
    r2.xyz = (r8.xyz) * (r5.xyz);
    r0 = (r1) * (r0);
    r2.xyz = (r2.xyz) * (c0.xxx) + (r7.xyz);
    r1.z = dot(c[11], r0);
    r1.x = dot(c[9], r0);
    r1.y = dot(c[10], r0);
    r0.xyz = (r6.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.w = v2.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[20].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.y;

    return oC0;
}
