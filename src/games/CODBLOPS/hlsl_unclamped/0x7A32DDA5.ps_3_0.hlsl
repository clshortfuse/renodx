// Mechanically reconstructed from 0x7A32DDA5.ps_3_0.cso.
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
    const float4 c0 = float4(-0.5f, 1.0f, 0.0f, 8.0f);
    const float4 c1 = float4(0.797884583f, 1.0f, 0.5f, 0.0f);
    const float4 c3 = float4(31.875f, 4.0f, -2.0f, 0.0009765625f);
    const float4 c4 = float4(0.600000024f, 0.400000006f, 0.125f, 0.25f);
    const float4 c7 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c8 = float4(0.00048828125f, -0.000122070312f, 0.0f, -3.0f);
    const float4 c9 = float4(0.000244140625f, 0.0f, -0.000244140625f, 0.75f);
    const float4 c10 = float4(4.0f, -3.0f, 0.0f, 0.0f);
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

    r0.xy = (v1.zw) * (c1.yz);
    r0 = tex2D(s13, r0.xy);
    r2 = tex2D(s14, v1.zw);
    r3.xy = (r2.xy) * (c3.xx);
    r2.w = dot(v5.xyz, v5.xyz);
    r5.xy = (r0.xz) * (r3.xx);
    r0.x = r0.y;
    r0.w = (r2.x) * (c3.x) + (-(r5.x));
    r2.z = (r0.z) * (-(r3.x)) + (r0.w);
    r1.xy = (v1.zw) * (c1.yz) + (c1.wz);
    r1 = tex2D(s13, r1.xy);
    r4.xy = (r3.yy) * (r1.xz);
    r0.w = (r2.y) * (c3.x) + (-(r4.x));
    r0.y = r1.y;
    r0.z = (r1.z) * (-(r3.y)) + (r0.w);
    r0.xy = (r0.xy) * (c3.yy) + (c3.zz);
    r0.w = dot(r0.xy, r0.xy) + (c0.z);
    r7.y = (r2.z) + (r2.z);
    r0.y = (r0.z) + (r0.z);
    r2.w = rsqrt(r2.w);
    r0.w = exp2(-(r0.w));
    r1.xyz = (v5.xyz) * (-(r2.www)) + (c[17].xyz);
    r0.w = saturate((r0.w) * (c4.x) + (c4.y));
    r3.xyz = normalize(r1.xyz);
    r7.xz = (r5.xy) * (c3.yy);
    r1.w = saturate(dot(r3.xyz, c[17].xyz));
    r0.xz = (r4.xy) * (c3.yy);
    r1.w = (-(r1.w)) + (c0.y);
    r2.xyz = (r0.xyz) * (r0.www) + (r7.xyz);
    r1.z = (r1.w) * (r1.w);
    r0 = tex2D(s0, v1.xy);
    r4.w = (r0.w) * (v0.w) + (c0.x);
    r0 = (r0.xyzx) * (c0.yyyz) + (c0.zzzy);
    r1.z = (r1.z) * (r1.z);
    r0 = float4(((r4.w) >= 0.0f ? (r0.x) : (c0.z)), ((r4.w) >= 0.0f ? (r0.y) : (c0.z)), ((r4.w) >= 0.0f ? (r0.z) : (c0.z)), ((r4.w) >= 0.0f ? (r0.w) : (c0.z)));
    r4.z = (r1.w) * (r1.z);
    r0.xyz = (r0.xyz) * (v0.xyz);
    r1 = tex2D(s2, v1.xy);
    r1 = float4(((r4.w) >= 0.0f ? (r1.x) : (c0.z)), ((r4.w) >= 0.0f ? (r1.y) : (c0.z)), ((r4.w) >= 0.0f ? (r1.z) : (c0.z)), ((r4.w) >= 0.0f ? (r1.w) : (c0.y)));
    r8.xyz = (r0.xyz) * (r0.xyz);
    r9.xyz = (r1.xyz) * (-(r1.xyz)) + (c0.yyy);
    r10.xyz = (r1.xyz) * (r1.xyz);
    r0.z = (r1.w) * (-(c1.x)) + (c1.y);
    r1.xyz = normalize(v2.xyz);
    r12.xyz = (r2.www) * (v5.xyz);
    r7.w = saturate(dot(r1.xyz, -(r12.xyz)));
    r0.x = (r1.w) * (c1.x);
    r3.z = saturate(dot(r1.xyz, r3.xyz));
    r0.y = (r7.w) * (r0.z) + (r0.x);
    r16.xy = (r1.ww) * (c7.xy) + (c7.zw);
    r3.w = saturate(dot(r1.xyz, c[17].xyz));
    r2.w = exp2(r16.y);
    r0.z = (r3.w) * (r0.z) + (r0.x);
    r0.x = pow(abs(r3.z), r2.w);
    r0.z = (r0.z) * (r0.y) + (c3.w);
    r0.y = (r2.w) * (c4.z) + (c4.w);
    r0.z = 1.0f / (r0.z);
    r2.w = (r0.x) * (r0.y);
    r3.z = (r3.w) * (r0.z);
    r0.xyz = (r9.xyz) * (r4.zzz) + (r10.xyz);
    r2.w = (r2.w) * (r3.z);
    r3.y = c0.z;
    r11.xyz = float3(((r4.w) >= 0.0f ? (c[5].x) : (r3.y)), ((r4.w) >= 0.0f ? (c[5].y) : (r3.y)), ((r4.w) >= 0.0f ? (c[5].w) : (r3.y)));
    r0.xyz = (r0.xyz) * (r2.www);
    r15.xyz = (r2.xyz) * (r11.yyy);
    r13.xyz = (r11.zzz) * (r0.xyz);
    r2 = tex2D(s12, v1.zw);
    r0.z = ((-abs(r2.y)) >= 0.0f ? (c0.y) : (c0.z));
    r14.xyz = (r3.www) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r2.y;
        r2.w = r0.z;
    }
    else
    {
        if ((c0.y) >= (v4.w))
        {
            r3 = (v4.xyzx) * (c0.yyyz);
            r2 = (r3) + (-(c8.xyzz));
            r2 = tex2Dlod(s1, r2);
            r2.w = r2.x;
            r4 = (r3) + (c9.xxyy);
            r4 = tex2Dlod(s1, r4);
            r2.x = r4.x;
            r4 = (r3) + (c9.zzyy);
            r4 = tex2Dlod(s1, r4);
            r2.y = r4.x;
            r3 = (r3) + (c8.xyzz);
            r3 = tex2Dlod(s1, r3);
            r2.z = r3.x;
            r0.z = dot(r2, c4.wwww);
            if ((c9.w) < (v4.w))
            {
                r0.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r0.xy) + (c9.xx);
                r2.zw = (v4.zx) * (c0.yz);
                r2 = tex2Dlod(s1, r2);
                r3.xy = (r0.xy) + (c9.zz);
                r3.zw = (v4.zx) * (c0.yz);
                r5 = tex2Dlod(s1, r3);
                r3.xy = (r0.xy) + (c8.xy);
                r3.zw = (v4.zx) * (c0.yz);
                r4 = tex2Dlod(s1, r3);
                r3.xy = (r0.xy) + (-(c8.xy));
                r3.zw = (v4.zx) * (c0.yz);
                r3 = tex2Dlod(s1, r3);
                r2.y = r5.x;
                r2.z = r4.x;
                r2.w = r3.x;
                r0.y = dot(r2, c4.wwww);
                r0.x = (-(r0.z)) + (r0.y);
                r0.y = (v4.w) * (c10.x) + (c10.y);
                r2.w = (r0.y) * (r0.x) + (r0.z);
            }
            else
            {
                r2.w = r0.z;
            }
        }
        else
        {
            r0.z = (v4.w) + (-(c3.y));
            r0.z = ((r0.z) >= 0.0f ? (c0.z) : (c0.y));
            if ((r0.z) != (-(r0.z)))
            {
                r0.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
                r3.xy = (r0.xy) + (c9.xx);
                r3.zw = (v4.zz) * (c0.yz);
                r3 = tex2Dlod(s1, r3);
                r4.xy = (r0.xy) + (c9.zz);
                r4.zw = (v4.zz) * (c0.yz);
                r6 = tex2Dlod(s1, r4);
                r4.xy = (r0.xy) + (c8.xy);
                r4.zw = (v4.zz) * (c0.yz);
                r5 = tex2Dlod(s1, r4);
                r4.xy = (r0.xy) + (-(c8.xy));
                r4.zw = (v4.zz) * (c0.yz);
                r4 = tex2Dlod(s1, r4);
                r3.y = r6.x;
                r3.z = r5.x;
                r3.w = r4.x;
                r0.x = dot(r3, c4.wwww);
                r0.z = saturate((v4.w) + (c8.w));
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
    r2.xyz = (r2.www) * (r14.xyz) + (r15.xyz);
    r4.xyz = (r13.xyz) * (c[19].xyz);
    r0.z = (-(r7.w)) + (c0.y);
    r0.x = 1.0f / (r16.x);
    r0.y = (r0.z) * (r0.z);
    r0.y = (r0.z) * (r0.y);
    r0.z = dot(r12.xyz, r1.xyz);
    r3.w = (r0.x) * (r0.y);
    r0.z = (r0.z) + (r0.z);
    r1.w = (r1.w) * (c0.w);
    r1.xyz = (r1.xyz) * (-(r0.zzz)) + (r12.xyz);
    r1 = texCUBElod(s15, r1);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r0.xyz = (r11.xxx) * (r0.xyz);
    r3.xyz = (r9.xyz) * (r3.www) + (r10.xyz);
    r1.xyz = (r2.www) * (r4.xyz);
    r0.xyz = (r0.xyz) * (r3.xyz);
    r1.xyz = (r8.xyz) * (r2.xyz) + (r1.xyz);
    r0.xyz = (r7.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c0.www) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r1.x = v2.w;
    r0.xyz = (r1.xxx) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = r0.w;

    return oC0;
}
