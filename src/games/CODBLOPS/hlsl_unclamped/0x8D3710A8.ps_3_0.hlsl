// Mechanically reconstructed from 0x8D3710A8.ps_3_0.cso.
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
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD8;
    float4 v3 : TEXCOORD4;
    float4 v4 : TEXCOORD5;
    float4 v5 : TEXCOORD6;
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
    const float4 c1 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c3 = float4(4.0f, -2.0f, 0.600000024f, 0.400000006f);
    const float4 c4 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c8 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c9 = float4(0.000244140625f, 0.0f, -0.000244140625f, -3.0f);
    const float4 c10 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.0f);
    const float4 c11 = float4(4.0f, -3.0f, 0.0f, 0.0f);
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

    r0.xy = (v0.zw) * (c0.yw);
    r0 = tex2D(s13, r0.xy);
    r2 = tex2D(s14, v0.zw);
    r4.xy = (r2.xy) * (c1.ww);
    r5.xy = (r0.xz) * (r4.xx);
    r1.x = r0.y;
    r0.w = (r2.x) * (c1.w) + (-(r5.x));
    r1.z = (r0.z) * (-(r4.x)) + (r0.w);
    r0.xy = (v0.zw) * (c1.xy) + (c1.zy);
    r0 = tex2D(s13, r0.xy);
    r3.xy = (r4.yy) * (r0.xz);
    r1.y = r0.y;
    r0.w = (r2.y) * (c1.w) + (-(r3.x));
    r0.xy = (r1.xy) * (c3.xx) + (c3.yy);
    r1.w = (r0.z) * (-(r4.y)) + (r0.w);
    r0.w = dot(r0.xy, r0.xy) + (c1.z);
    r6.y = (r1.z) + (r1.z);
    r0.z = dot(v4.xyz, v4.xyz);
    r0.y = (r1.w) + (r1.w);
    r5.w = rsqrt(r0.z);
    r0.w = exp2(-(r0.w));
    r1.xyz = (v4.xyz) * (-(r5.www)) + (c[17].xyz);
    r0.w = saturate((r0.w) * (c3.z) + (c3.w));
    r4.xyz = normalize(r1.xyz);
    r6.xz = (r5.xy) * (c3.xx);
    r1.w = saturate(dot(r4.xyz, c[17].xyz));
    r0.xz = (r3.xy) * (c3.xx);
    r2.w = (-(r1.w)) + (c0.y);
    r3.xyz = (r0.xyz) * (r0.www) + (r6.xyz);
    r2.z = (r2.w) * (r2.w);
    r1 = tex2D(s0, v0.xy);
    r0 = tex2D(s2, v5.zw);
    r3.w = (r0.w) * (v5.y);
    r0.w = (r2.z) * (r2.z);
    r2.xyz = lerp(r1.xyz, r0.xyz, r3.www);
    r4.w = (r2.w) * (r0.w);
    r7.xyz = (r2.xyz) * (r2.xyz);
    r2 = tex2D(s3, v0.xy);
    r1 = tex2D(s4, v5.zw);
    r0 = lerp(r2, r1, r3.wwww);
    r1.xyw = c[5].xyw;
    r1.xyz = (-(r1.xyw)) + (c[6].xyw);
    r8.xyz = (r0.xyz) * (-(r0.xyz)) + (c0.yyy);
    r9.xyz = (r0.xyz) * (r0.xyz);
    r0.z = (r0.w) * (-(c0.z)) + (c0.y);
    r11.xyz = normalize(v1.xyz);
    r12.xyz = (r5.www) * (v4.xyz);
    r6.w = saturate(dot(r11.xyz, -(r12.xyz)));
    r0.x = (r0.w) * (c0.z);
    r2.z = saturate(dot(r11.xyz, r4.xyz));
    r0.y = (r6.w) * (r0.z) + (r0.x);
    r16.xy = (r0.ww) * (c8.xy) + (c8.zw);
    r2.w = saturate(dot(r11.xyz, c[17].xyz));
    r1.w = exp2(r16.y);
    r0.z = (r2.w) * (r0.z) + (r0.x);
    r0.x = pow(abs(r2.z), r1.w);
    r0.z = (r0.z) * (r0.y) + (c4.x);
    r0.y = (r1.w) * (c4.y) + (c4.z);
    r0.z = 1.0f / (r0.z);
    r1.w = (r0.x) * (r0.y);
    r2.z = (r2.w) * (r0.z);
    r0.xyz = (r8.xyz) * (r4.www) + (r9.xyz);
    r1.w = (r1.w) * (r2.z);
    r10.xyz = (r3.www) * (r1.xyz) + (c[5].xyw);
    r0.xyz = (r0.xyz) * (r1.www);
    r15.xyz = (r3.xyz) * (r10.yyy);
    r13.xyz = (r10.zzz) * (r0.xyz);
    r1 = tex2D(s12, v0.zw);
    r0.z = ((-abs(r1.y)) >= 0.0f ? (c1.x) : (c1.z));
    r14.xyz = (r2.www) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r1.y;
        r1.w = r0.z;
    }
    else
    {
        if ((c0.y) >= (v3.w))
        {
            r2 = (v3.xyzx) * (c1.xxxz);
            r1 = (r2) + (-(c10.xyzz));
            r1 = tex2Dlod(s1, r1);
            r1.w = r1.x;
            r3 = (r2) + (c9.xxyy);
            r3 = tex2Dlod(s1, r3);
            r1.x = r3.x;
            r3 = (r2) + (c9.zzyy);
            r3 = tex2Dlod(s1, r3);
            r1.y = r3.x;
            r2 = (r2) + (c10.xyzz);
            r2 = tex2Dlod(s1, r2);
            r1.z = r2.x;
            r0.z = dot(r1, c4.zzzz);
            if ((c4.w) < (v3.w))
            {
                r0.xy = (v3.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r0.xy) + (c9.xx);
                r1.zw = (v3.zx) * (c1.xz);
                r1 = tex2Dlod(s1, r1);
                r2.xy = (r0.xy) + (c9.zz);
                r2.zw = (v3.zx) * (c1.xz);
                r4 = tex2Dlod(s1, r2);
                r2.xy = (r0.xy) + (c10.xy);
                r2.zw = (v3.zx) * (c1.xz);
                r3 = tex2Dlod(s1, r2);
                r2.xy = (r0.xy) + (-(c10.xy));
                r2.zw = (v3.zx) * (c1.xz);
                r2 = tex2Dlod(s1, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r0.y = dot(r1, c4.zzzz);
                r0.x = (-(r0.z)) + (r0.y);
                r0.y = (v3.w) * (c11.x) + (c11.y);
                r1.w = (r0.y) * (r0.x) + (r0.z);
            }
            else
            {
                r1.w = r0.z;
            }
        }
        else
        {
            r0.z = (v3.w) + (-(c3.x));
            r0.z = ((r0.z) >= 0.0f ? (c1.z) : (c1.x));
            if ((r0.z) != (-(r0.z)))
            {
                r0.xy = (v3.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r0.xy) + (c9.xx);
                r2.zw = (v3.zz) * (c1.xz);
                r2 = tex2Dlod(s1, r2);
                r3.xy = (r0.xy) + (c9.zz);
                r3.zw = (v3.zz) * (c1.xz);
                r5 = tex2Dlod(s1, r3);
                r3.xy = (r0.xy) + (c10.xy);
                r3.zw = (v3.zz) * (c1.xz);
                r4 = tex2Dlod(s1, r3);
                r3.xy = (r0.xy) + (-(c10.xy));
                r3.zw = (v3.zz) * (c1.xz);
                r3 = tex2Dlod(s1, r3);
                r2.y = r5.x;
                r2.z = r4.x;
                r2.w = r3.x;
                r0.x = dot(r2, c4.zzzz);
                r0.z = saturate((v3.w) + (c9.w));
                r0.y = (r1.y) + (-(r0.x));
                r0.z = (r0.z) * (r0.y) + (r0.x);
            }
            else
            {
                r0.z = r1.y;
            }
            r1.w = r0.z;
        }
    }
    r1.xyz = (r1.www) * (r14.xyz) + (r15.xyz);
    r2.xyz = (r13.xyz) * (c[19].xyz);
    r0.z = (-(r6.w)) + (c0.y);
    r0.x = 1.0f / (r16.x);
    r0.y = (r0.z) * (r0.z);
    r0.y = (r0.z) * (r0.y);
    r0.z = dot(r12.xyz, r11.xyz);
    r2.w = (r0.x) * (r0.y);
    r0.z = (r0.z) + (r0.z);
    r0.w = (r0.w) * (c0.x);
    r0.xyz = (r11.xyz) * (-(r0.zzz)) + (r12.xyz);
    r0 = texCUBElod(s15, r0);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r10.xxx) * (r0.xyz);
    r3.xyz = (r8.xyz) * (r2.www) + (r9.xyz);
    r2.xyz = (r1.www) * (r2.xyz);
    r0.xyz = (r0.xyz) * (r3.xyz);
    r1.xyz = (r7.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r6.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c0.xxx) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.w = v1.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[7].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.y;

    return oC0;
}
