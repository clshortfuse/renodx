// Mechanically reconstructed from 0xEE3E240D.ps_3_0.cso.
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
    const float4 c0 = float4(1.0f, 8.0f, 0.797884583f, 0.5f);
    const float4 c1 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c3 = float4(4.0f, -2.0f, 0.600000024f, 0.400000006f);
    const float4 c4 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c12 = float4(0.000244140625f, 0.0f, -0.000244140625f, -3.0f);
    const float4 c13 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.0f);
    const float4 c14 = float4(4.0f, -3.0f, -2.0f, 3.0f);
    const float4 c15 = float4(3.5f, -13.0f, 1.0f, 13.0f);
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

    r0.w = dot(v4.xyz, v4.xyz);
    r0.xyz = (-(v4.xyz)) + (c[5].xyz);
    r9.w = rsqrt(r0.w);
    r0.w = dot(r0.xyz, r0.xyz);
    r0.w = rsqrt(r0.w);
    r3.xyz = (r9.www) * (v4.xyz);
    r2.xyz = (r0.xyz) * (r0.www) + (-(r3.xyz));
    r1.xyz = normalize(r2.xyz);
    r0.xyz = (r0.xyz) * (r0.www);
    r1.w = saturate(dot(r1.xyz, r0.xyz));
    r0.w = dot(r0.xyz, c[22].xyz);
    r1.w = (-(r1.w)) + (c0.x);
    r0.w = saturate((r0.w) * (c[23].x) + (c[23].y));
    r2.w = (r1.w) * (r1.w);
    r2.w = (r2.w) * (r2.w);
    r4.xyz = normalize(v1.xyz);
    r5.z = (r1.w) * (r2.w);
    r1.w = saturate(dot(r4.xyz, r1.xyz));
    r2 = tex2D(s5, v0.xy);
    r13.xyz = (r2.xyz) * (-(r2.xyz)) + (c0.xxx);
    r14.xyz = (r2.xyz) * (r2.xyz);
    r6.z = (r2.w) * (-(c0.z)) + (c0.x);
    r8.w = (r2.w) * (c0.z);
    r7.z = saturate(dot(r0.xyz, r4.xyz));
    r3.w = saturate(dot(r4.xyz, -(r3.xyz)));
    r0.z = (r7.z) * (r6.z) + (r8.w);
    r6.w = (r3.w) * (r6.z) + (r8.w);
    r0.z = (r0.z) * (r6.w) + (c4.x);
    r6.xy = (r2.ww) * (c15.xy) + (c15.zw);
    r0.y = 1.0f / (r0.z);
    r5.w = exp2(r6.y);
    r0.z = pow(abs(r1.w), r5.w);
    r4.w = (r5.w) * (c4.y) + (c4.z);
    r1.z = (r7.z) * (r0.y);
    r1.w = (r0.z) * (r4.w);
    r0.xyz = (r13.xyz) * (r5.zzz) + (r14.xyz);
    r1.w = (r1.z) * (r1.w);
    r7.w = (r0.w) * (c14.z) + (c14.w);
    r0.xyz = (r0.xyz) * (r1.www);
    r6.y = (r0.w) * (r0.w);
    r2.xyz = (r0.xyz) * (c[7].xyz);
    r0 = tex2D(s4, v5.zw);
    r7.y = (r0.w) * (v5.y);
    r1 = tex2D(s0, v0.xy);
    r5.xyz = lerp(r1.xyz, r0.xyz, r7.yyy);
    r0.z = c0.x;
    r0.xyz = (r0.zzz) + (-(c[29].xyw));
    r1.xyz = (r5.xyz) * (r5.xyz);
    r10.xyz = (r7.yyy) * (r0.xyz) + (c[29].xyw);
    r2.xyz = (r2.xyz) * (r10.zzz);
    r0.xyz = (r7.zzz) * (c[6].xyz);
    r7.w = (r7.w) * (r6.y);
    r7.xyz = (r1.xyz) * (r0.xyz) + (r2.xyz);
    r5.z = 1.0f / (r6.x);
    r0.y = (-(r3.w)) + (c0.x);
    r0.x = (r0.y) * (r0.y);
    r0.z = dot(r3.xyz, r4.xyz);
    r3.w = (r0.y) * (r0.x);
    r0.z = (r0.z) + (r0.z);
    r2.w = (r2.w) * (c0.y);
    r2.xyz = (r4.xyz) * (-(r0.zzz)) + (r3.xyz);
    r2 = texCUBElod(s15, r2);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r2.w = (r5.z) * (r3.w);
    r0.xyz = (r10.xxx) * (r0.xyz);
    r5.xyz = (r13.xyz) * (r2.www) + (r14.xyz);
    r2.xy = (v0.zw) * (c0.xw);
    r2 = tex2D(s13, r2.xy);
    r3 = tex2D(s14, v0.zw);
    r9.xy = (r3.xy) * (c1.ww);
    r8.xyz = (r0.xyz) * (r5.xyz);
    r6.xy = (r2.xz) * (r9.xx);
    r0.x = r2.y;
    r0.z = (r3.x) * (c1.w) + (-(r6.x));
    r3.w = (r2.z) * (-(r9.x)) + (r0.z);
    r2.xy = (v0.zw) * (c1.xy) + (c1.zy);
    r2 = tex2D(s13, r2.xy);
    r5.xy = (r9.yy) * (r2.xz);
    r0.y = r2.y;
    r0.z = (r3.y) * (c1.w) + (-(r5.x));
    r0.xy = (r0.xy) * (c3.xx) + (c3.yy);
    r2.w = (r2.z) * (-(r9.y)) + (r0.z);
    r0.z = dot(r0.xy, r0.xy) + (c1.z);
    r9.y = (r3.w) + (r3.w);
    r0.z = exp2(-(r0.z));
    r2.y = (r2.w) + (r2.w);
    r2.w = saturate((r0.z) * (c3.z) + (c3.w));
    r9.xz = (r6.xy) * (c3.xx);
    r3.xyz = (v4.xyz) * (-(r9.www)) + (c[17].xyz);
    r2.xz = (r5.xy) * (c3.xx);
    r0.xyz = normalize(r3.xyz);
    r2.xyz = (r2.xyz) * (r2.www) + (r9.xyz);
    r2.w = saturate(dot(r0.xyz, c[17].xyz));
    r12.xyz = (r10.yyy) * (r2.xyz);
    r2.w = (-(r2.w)) + (c0.x);
    r2.z = (r2.w) * (r2.w);
    r3.w = saturate(dot(r4.xyz, c[17].xyz));
    r2.z = (r2.z) * (r2.z);
    r2.x = (r3.w) * (r6.z) + (r8.w);
    r2.y = saturate(dot(r4.xyz, r0.xyz));
    r0.y = (r2.x) * (r6.w) + (c4.x);
    r0.z = pow(abs(r2.y), r5.w);
    r0.y = 1.0f / (r0.y);
    r0.z = (r4.w) * (r0.z);
    r0.y = (r3.w) * (r0.y);
    r9.w = (r2.w) * (r2.z);
    r8.w = (r0.z) * (r0.y);
    r2 = tex2D(s12, v0.zw);
    r0.z = ((-abs(r2.y)) >= 0.0f ? (c1.x) : (c1.z));
    r11.xyz = (r3.www) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r2.y;
        r3.w = r0.z;
    }
    else
    {
        if ((c0.x) >= (v3.w))
        {
            r3 = (v3.xyzx) * (c1.xxxz);
            r2 = (r3) + (-(c13.xyzz));
            r2 = tex2Dlod(s1, r2);
            r2.w = r2.x;
            r4 = (r3) + (c12.xxyy);
            r4 = tex2Dlod(s1, r4);
            r2.x = r4.x;
            r4 = (r3) + (c12.zzyy);
            r4 = tex2Dlod(s1, r4);
            r2.y = r4.x;
            r3 = (r3) + (c13.xyzz);
            r3 = tex2Dlod(s1, r3);
            r2.z = r3.x;
            r0.z = dot(r2, c4.zzzz);
            if ((c4.w) < (v3.w))
            {
                r0.xy = (v3.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r0.xy) + (c12.xx);
                r2.zw = (v3.zx) * (c1.xz);
                r2 = tex2Dlod(s1, r2);
                r3.xy = (r0.xy) + (c12.zz);
                r3.zw = (v3.zx) * (c1.xz);
                r5 = tex2Dlod(s1, r3);
                r3.xy = (r0.xy) + (c13.xy);
                r3.zw = (v3.zx) * (c1.xz);
                r4 = tex2Dlod(s1, r3);
                r3.xy = (r0.xy) + (-(c13.xy));
                r3.zw = (v3.zx) * (c1.xz);
                r3 = tex2Dlod(s1, r3);
                r2.y = r5.x;
                r2.z = r4.x;
                r2.w = r3.x;
                r0.y = dot(r2, c4.zzzz);
                r0.x = (-(r0.z)) + (r0.y);
                r0.y = (v3.w) * (c14.x) + (c14.y);
                r3.w = (r0.y) * (r0.x) + (r0.z);
            }
            else
            {
                r3.w = r0.z;
            }
        }
        else
        {
            r0.z = (v3.w) + (-(c3.x));
            r0.z = ((r0.z) >= 0.0f ? (c1.z) : (c1.x));
            if ((r0.z) != (-(r0.z)))
            {
                r0.xy = (v3.xy) * (c[2].ww) + (c[2].xy);
                r3.xy = (r0.xy) + (c12.xx);
                r3.zw = (v3.zz) * (c1.xz);
                r3 = tex2Dlod(s1, r3);
                r4.xy = (r0.xy) + (c12.zz);
                r4.zw = (v3.zz) * (c1.xz);
                r6 = tex2Dlod(s1, r4);
                r4.xy = (r0.xy) + (c13.xy);
                r4.zw = (v3.zz) * (c1.xz);
                r5 = tex2Dlod(s1, r4);
                r4.xy = (r0.xy) + (-(c13.xy));
                r4.zw = (v3.zz) * (c1.xz);
                r4 = tex2Dlod(s1, r4);
                r3.y = r6.x;
                r3.z = r5.x;
                r3.w = r4.x;
                r0.x = dot(r3, c4.zzzz);
                r0.z = saturate((v3.w) + (c12.w));
                r0.y = (r2.y) + (-(r0.x));
                r0.z = (r0.z) * (r0.y) + (r0.x);
            }
            else
            {
                r0.z = r2.y;
            }
            r3.w = r0.z;
        }
    }
    r0.xyz = (r13.xyz) * (r9.www) + (r14.xyz);
    r2.xyz = (r8.www) * (r0.xyz);
    r0.xyz = (r3.www) * (r11.xyz) + (r12.xyz);
    r2.xyz = (r10.zzz) * (r2.xyz);
    r3.xyz = (r2.xyz) * (c[19].xyz);
    r2 = (v4.yyyy) * (c[25]);
    r3.xyz = (r3.www) * (r3.xyz);
    r2 = (v4.xxxx) * (c[24]) + (r2);
    r1.xyz = (r1.xyz) * (r0.xyz) + (r3.xyz);
    r2 = (v4.zzzz) * (c[26]) + (r2);
    r0.xyz = (r8.xyz) * (r9.xyz);
    r3 = (r2) + (c[27]);
    r5.xyz = (r0.xyz) * (c0.yyy) + (r1.xyz);
    r2.zw = r3.zw;
    r3.z = (r1.w) * (-(v5.x)) + (c0.x);
    r4.zw = r2.zw;
    r5.w = (r0.w) * (-(v5.y)) + (c0.x);
    r1.zw = r4.zw;
    r0.xy = (r3.ww) * (-(c[28].zw)) + (r3.xy);
    r0.zw = r1.zw;
    r0 = tex2Dproj(s2, r0);
    r0.w = r0.x;
    r4.xy = (r2.ww) * (-(c[28].xy)) + (r3.xy);
    r4 = tex2Dproj(s2, r4);
    r0.y = r4.x;
    r2.xy = (r2.ww) * (c[28].xy) + (r3.xy);
    r4 = tex2Dproj(s2, r2);
    r0.x = r4.x;
    r1.xy = (r2.ww) * (c[28].zw) + (r3.xy);
    r2 = tex2Dproj(s2, r1);
    r1 = (v4.xyzx) * (c1.xxxz) + (c1.zzzx);
    r0.z = r2.x;
    r2.w = dot(r1, c[21]);
    r2.w = 1.0f / (r2.w);
    r3.x = dot(r1, c[20]);
    r2.x = dot(r1, c[10]);
    r3.y = (r3.x) * (r3.x);
    r2.y = dot(r1, c[11]);
    r1.w = dot(c[8].yz, r3.xy) + (c[8].x);
    r1.z = saturate(1.0f / (r1.w));
    r1.xy = saturate((r3.xx) * (c[9].xy) + (c[9].zw));
    r3.xy = (r1.xy) * (c14.zz) + (c14.ww);
    r1.xy = (r1.xy) * (r1.xy);
    r1.w = ((-abs(r1.w)) >= 0.0f ? (c1.z) : (r1.z));
    r1.z = (r3.x) * (r1.x);
    r1.w = (r1.w) * (r1.z);
    r1.z = (r1.y) * (-(r3.y)) + (c0.x);
    r1.xy = (r2.ww) * (r2.xy);
    r1.w = (r1.w) * (r1.z);
    r2.w = (r7.w) * (r1.w);
    r1.xy = (r1.xy) * (c0.ww) + (c0.ww);
    r1 = tex2D(s3, r1.xy);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r1.w = dot(r0, c4.zzzz);
    r0.xyz = (r2.www) * (r1.xyz);
    r0.w = (r3.z) * (-(r5.w)) + (c0.x);
    r0.xyz = (r1.www) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r7.xyz) + (r5.xyz);
    r1.xyz = (r0.www) * (v2.xyz);
    r0.xyz = (r0.xyz) * (r0.www) + (-(r1.xyz));
    r0.xyz = (v1.www) * (r0.xyz) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[30].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    r0.w = rsqrt(r0.w);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = 1.0f / (r0.w);

    return oC0;
}
