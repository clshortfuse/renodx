// Mechanically reconstructed from 0x75A5002F.ps_3_0.cso.
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
    const float4 c6 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c7 = float4(0.125f, 0.25f, 0.000244140625f, 0.0f);
    const float4 c8 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c9 = float4(4.0f, -3.0f, 0.0f, 0.0f);
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
    r0.w = rsqrt(r0.w);
    r1.xyz = (v5.xyz) * (-(r0.www)) + (c[17].xyz);
    r0.xyz = normalize(r1.xyz);
    r1.w = saturate(dot(r0.xyz, c[17].xyz));
    r1.w = (-(r1.w)) + (c0.y);
    r1.z = (r1.w) * (r1.w);
    r1.z = (r1.z) * (r1.z);
    r2.z = (r1.w) * (r1.z);
    r7.xyz = normalize(v2.xyz);
    r8.xyz = (r0.www) * (v5.xyz);
    r2.y = saturate(dot(r7.xyz, r0.xyz));
    r1.w = saturate(dot(r7.xyz, -(r8.xyz)));
    r0 = tex2D(s2, v1.xy);
    r0.z = (r0.w) * (-(c0.z)) + (c0.y);
    r1.z = (r0.w) * (c0.z);
    r2.w = saturate(dot(r7.xyz, c[17].xyz));
    r0.x = (r1.w) * (r0.z) + (r1.z);
    r0.z = (r2.w) * (r0.z) + (r1.z);
    r0.z = (r0.z) * (r0.x) + (c4.w);
    r1.xy = (r0.ww) * (c6.xy) + (c6.zw);
    r1.z = 1.0f / (r0.z);
    r1.y = exp2(r1.y);
    r0.x = pow(abs(r2.y), r1.y);
    r0.z = (r1.y) * (c7.x) + (c7.y);
    r1.z = (r2.w) * (r1.z);
    r0.z = (r0.x) * (r0.z);
    r0.x = (r2.z) * (c1.x) + (c1.y);
    r0.z = (r1.z) * (r0.z);
    r0.z = (r0.x) * (r0.z);
    r0.x = (r0.y) * (r0.z);
    r2.z = 1.0f / (r1.x);
    r0.z = (-(r1.w)) + (c0.y);
    r2.y = (r0.z) * (r0.z);
    r1.xy = (v1.zw) * (c0.yw);
    r1 = tex2D(s13, r1.xy);
    r3 = tex2D(s14, v1.zw);
    r6.xy = (r3.xy) * (c1.zz);
    r0.z = (r0.z) * (r2.y);
    r5.xy = (r1.xz) * (r6.xx);
    r2.x = r1.y;
    r1.w = (r3.x) * (c1.z) + (-(r5.x));
    r3.w = (r1.z) * (-(r6.x)) + (r1.w);
    r1.xy = (v1.zw) * (c4.xy) + (c4.zy);
    r1 = tex2D(s13, r1.xy);
    r4.xy = (r6.yy) * (r1.xz);
    r2.y = r1.y;
    r1.w = (r3.y) * (c1.z) + (-(r4.x));
    r1.xy = (r2.xy) * (c3.xx) + (c3.yy);
    r1.z = (r1.z) * (-(r6.y)) + (r1.w);
    r1.w = dot(r1.xy, r1.xy) + (c4.z);
    r6.y = (r3.w) + (r3.w);
    r1.w = exp2(-(r1.w));
    r1.y = (r1.z) + (r1.z);
    r1.w = saturate((r1.w) * (c3.z) + (c3.w));
    r6.xz = (r5.xy) * (c1.ww);
    r1.xz = (r4.xy) * (c1.ww);
    r0.z = (r2.z) * (r0.z);
    r1.xyz = (r1.xyz) * (r1.www) + (r6.xyz);
    r6.w = (r0.z) * (c1.x) + (c1.y);
    r10.xyz = (r0.yyy) * (r1.xyz);
    r1 = tex2D(s12, v1.zw);
    r0.z = ((-abs(r1.y)) >= 0.0f ? (c4.x) : (c4.z));
    r9.xyz = (r2.www) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r1.y;
    }
    else
    {
        if ((c0.y) >= (v4.w))
        {
            r2 = (v4.xyzx) * (c4.xxxz);
            r1 = (r2) + (-(c8.xyzz));
            r1 = tex2Dlod(s1, r1);
            r1.w = r1.x;
            r3 = (r2) + (c7.zzww);
            r3 = tex2Dlod(s1, r3);
            r1.x = r3.x;
            r3 = (r2) + (-(c7.zzww));
            r3 = tex2Dlod(s1, r3);
            r1.y = r3.x;
            r2 = (r2) + (c8.xyzz);
            r2 = tex2Dlod(s1, r2);
            r1.z = r2.x;
            r0.z = dot(r1, c7.yyyy);
            if ((c8.w) < (v4.w))
            {
                r5.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r5.xy) + (c7.zz);
                r1.zw = (v4.zx) * (c4.xz);
                r1 = tex2Dlod(s1, r1);
                r2.xy = (r5.xy) + (-(c7.zz));
                r2.zw = (v4.zx) * (c4.xz);
                r4 = tex2Dlod(s1, r2);
                r2.xy = (r5.xy) + (c8.xy);
                r2.zw = (v4.zx) * (c4.xz);
                r3 = tex2Dlod(s1, r2);
                r2.xy = (r5.xy) + (-(c8.xy));
                r2.zw = (v4.zx) * (c4.xz);
                r2 = tex2Dlod(s1, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r1.w = dot(r1, c7.yyyy);
                r1.z = (-(r0.z)) + (r1.w);
                r1.w = (v4.w) * (c9.x) + (c9.y);
                r0.z = (r1.w) * (r1.z) + (r0.z);
            }
        }
        else
        {
            r0.z = (v4.w) + (-(c1.w));
            r0.z = ((r0.z) >= 0.0f ? (c4.z) : (c4.x));
            if ((r0.z) != (-(r0.z)))
            {
                r11.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r11.xy) + (c7.zz);
                r2.zw = (v4.zz) * (c4.xz);
                r2 = tex2Dlod(s1, r2);
                r3.xy = (r11.xy) + (-(c7.zz));
                r3.zw = (v4.zz) * (c4.xz);
                r5 = tex2Dlod(s1, r3);
                r3.xy = (r11.xy) + (c8.xy);
                r3.zw = (v4.zz) * (c4.xz);
                r4 = tex2Dlod(s1, r3);
                r3.xy = (r11.xy) + (-(c8.xy));
                r3.zw = (v4.zz) * (c4.xz);
                r3 = tex2Dlod(s1, r3);
                r2.y = r5.x;
                r2.z = r4.x;
                r2.w = r3.x;
                r1.z = dot(r2, c7.yyyy);
                r0.z = saturate((v4.w) + (c9.y));
                r1.w = (r1.y) + (-(r1.z));
                r0.z = (r0.z) * (r1.w) + (r1.z);
            }
            else
            {
                r0.z = r1.y;
            }
        }
    }
    r1.xyz = (r0.xxx) * (c[19].xyz);
    r3.xyz = (r0.zzz) * (r9.xyz) + (r10.xyz);
    r4.xyz = (r0.zzz) * (r1.xyz);
    r1 = tex2D(s0, v1.xy);
    r0.z = dot(r8.xyz, r7.xyz);
    r0.z = (r0.z) + (r0.z);
    r2.w = (r0.w) * (c0.x);
    r2.xyz = (r7.xyz) * (-(r0.zzz)) + (r8.xyz);
    r2 = texCUBElod(s15, r2);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r1.xyz = (r1.xyz) * (v0.xyz);
    r0.xyz = (r0.yyy) * (r2.xyz);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r0.xyz = (r6.www) * (r0.xyz);
    r1.xyz = (r1.xyz) * (r3.xyz) + (r4.xyz);
    r0.xyz = (r6.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c0.xxx) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.w = v2.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[5].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.y;

    return oC0;
}
