// Mechanically reconstructed from 0xB0FA0E4F.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s12 : register(s12);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD4;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c0 = float4(-0.5f, 1.0f, 0.0f, 0.5f);
    const float4 c1 = float4(31.875f, 4.0f, -2.0f, 0.25f);
    const float4 c3 = float4(0.600000024f, 0.400000006f, 0.000244140625f, 0.0f);
    const float4 c4 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c7 = float4(4.0f, -3.0f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 r8 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (v1.zw) * (c0.yw);
    r0 = tex2D(s13, r0.xy);
    r2 = tex2D(s14, v1.zw);
    r5.xy = (r2.xy) * (c1.xx);
    r4.xy = (r0.xz) * (r5.xx);
    r1.x = r0.y;
    r0.w = (r2.x) * (c1.x) + (-(r4.x));
    r1.w = (r0.z) * (-(r5.x)) + (r0.w);
    r0.xy = (v1.zw) * (c0.yw) + (c0.zw);
    r0 = tex2D(s13, r0.xy);
    r3.xy = (r5.yy) * (r0.xz);
    r1.y = r0.y;
    r0.w = (r2.y) * (c1.x) + (-(r3.x));
    r0.xy = (r1.xy) * (c1.yy) + (c1.zz);
    r0.z = (r0.z) * (-(r5.y)) + (r0.w);
    r0.w = dot(r0.xy, r0.xy) + (c0.z);
    r1.y = (r1.w) + (r1.w);
    r0.w = exp2(-(r0.w));
    r0.y = (r0.z) + (r0.z);
    r0.w = saturate((r0.w) * (c3.x) + (c3.y));
    r1.xz = (r4.xy) * (c1.yy);
    r0.xz = (r3.xy) * (c1.yy);
    r1.xyz = (r0.xyz) * (r0.www) + (r1.xyz);
    r0 = tex2D(s0, v1.xy);
    r1.w = (r0.w) * (v0.w) + (c0.x);
    r0 = (r0.xyzx) * (c0.yyyz) + (c0.zzzy);
    r2.xyz = normalize(v2.xyz);
    r0 = float4(((r1.w) >= 0.0f ? (r0.x) : (c0.z)), ((r1.w) >= 0.0f ? (r0.y) : (c0.z)), ((r1.w) >= 0.0f ? (r0.z) : (c0.z)), ((r1.w) >= 0.0f ? (r0.w) : (c0.z)));
    r2.w = saturate(dot(c[17].xyz, r2.xyz));
    r7.xyz = (r1.xyz) * (r0.www);
    r1 = tex2D(s12, v1.zw);
    r1.w = ((-abs(r1.y)) >= 0.0f ? (c0.y) : (c0.z));
    r6.xyz = (r2.www) * (c[18].xyz);
    if ((r1.w) != (-(r1.w)))
    {
        r1.w = r1.y;
    }
    else
    {
        if ((c0.y) >= (v4.w))
        {
            r2 = (v4.xyzx) * (c0.yyyz);
            r1 = (r2) + (-(c4.xyzz));
            r1 = tex2Dlod(s1, r1);
            r1.w = r1.x;
            r3 = (r2) + (c3.zzww);
            r3 = tex2Dlod(s1, r3);
            r1.x = r3.x;
            r3 = (r2) + (-(c3.zzww));
            r3 = tex2Dlod(s1, r3);
            r1.y = r3.x;
            r2 = (r2) + (c4.xyzz);
            r2 = tex2Dlod(s1, r2);
            r1.z = r2.x;
            r5.w = dot(r1, c1.wwww);
            if ((c4.w) < (v4.w))
            {
                r5.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r5.xy) + (c3.zz);
                r1.zw = (v4.zx) * (c0.yz);
                r1 = tex2Dlod(s1, r1);
                r2.xy = (r5.xy) + (-(c3.zz));
                r2.zw = (v4.zx) * (c0.yz);
                r4 = tex2Dlod(s1, r2);
                r2.xy = (r5.xy) + (c4.xy);
                r2.zw = (v4.zx) * (c0.yz);
                r3 = tex2Dlod(s1, r2);
                r2.xy = (r5.xy) + (-(c4.xy));
                r2.zw = (v4.zx) * (c0.yz);
                r2 = tex2Dlod(s1, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r1.w = dot(r1, c1.wwww);
                r1.z = (-(r5.w)) + (r1.w);
                r1.w = (v4.w) * (c7.x) + (c7.y);
                r1.w = (r1.w) * (r1.z) + (r5.w);
            }
            else
            {
                r1.w = r5.w;
            }
        }
        else
        {
            r1.w = (v4.w) + (-(c1.y));
            r1.w = ((r1.w) >= 0.0f ? (c0.z) : (c0.y));
            if ((r1.w) != (-(r1.w)))
            {
                r8.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r8.xy) + (c3.zz);
                r2.zw = (v4.zz) * (c0.yz);
                r2 = tex2Dlod(s1, r2);
                r3.xy = (r8.xy) + (-(c3.zz));
                r3.zw = (v4.zz) * (c0.yz);
                r5 = tex2Dlod(s1, r3);
                r3.xy = (r8.xy) + (c4.xy);
                r3.zw = (v4.zz) * (c0.yz);
                r4 = tex2Dlod(s1, r3);
                r3.xy = (r8.xy) + (-(c4.xy));
                r3.zw = (v4.zz) * (c0.yz);
                r3 = tex2Dlod(s1, r3);
                r2.y = r5.x;
                r2.z = r4.x;
                r2.w = r3.x;
                r1.x = dot(r2, c1.wwww);
                r1.w = saturate((v4.w) + (c7.y));
                r1.z = (r1.y) + (-(r1.x));
                r1.w = (r1.w) * (r1.z) + (r1.x);
            }
            else
            {
                r1.w = r1.y;
            }
        }
    }
    r0.xyz = (r0.xyz) * (v0.xyz);
    r1.xyz = (r1.www) * (r6.xyz) + (r7.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (-(v3.xyz));
    r1.x = v2.w;
    r0.xyz = (r1.xxx) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = (r0.w) * (c[5].w);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
