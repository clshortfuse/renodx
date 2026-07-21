// Mechanically reconstructed from 0xCBB6C2BA.ps_3_0.cso.
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
    const float4 c0 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c1 = float4(4.0f, -2.0f, 0.600000024f, 0.400000006f);
    const float4 c3 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c4 = float4(0.000244140625f, 0.0f, -0.000244140625f, 0.25f);
    const float4 c12 = float4(4.0f, -3.0f, -2.0f, 3.0f);
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
    float4 oC0 = 0.0f;

    r0.xy = (v1.zw) * (c0.xy);
    r0 = tex2D(s13, r0.xy);
    r2 = tex2D(s14, v1.zw);
    r5.xy = (r2.xy) * (c0.ww);
    r4.xy = (r0.xz) * (r5.xx);
    r1.x = r0.y;
    r0.w = (r2.x) * (c0.w) + (-(r4.x));
    r1.w = (r0.z) * (-(r5.x)) + (r0.w);
    r0.xy = (v1.zw) * (c0.xy) + (c0.zy);
    r0 = tex2D(s13, r0.xy);
    r3.xy = (r5.yy) * (r0.xz);
    r1.y = r0.y;
    r0.w = (r2.y) * (c0.w) + (-(r3.x));
    r0.xy = (r1.xy) * (c1.xx) + (c1.yy);
    r0.z = (r0.z) * (-(r5.y)) + (r0.w);
    r0.w = dot(r0.xy, r0.xy) + (c0.z);
    r1.y = (r1.w) + (r1.w);
    r0.w = exp2(-(r0.w));
    r0.y = (r0.z) + (r0.z);
    r0.w = saturate((r0.w) * (c1.z) + (c1.w));
    r1.xz = (r4.xy) * (c1.xx);
    r0.xz = (r3.xy) * (c1.xx);
    r7.xyz = (r0.xyz) * (r0.www) + (r1.xyz);
    r0 = tex2D(s12, v1.zw);
    r10.xyz = normalize(v2.xyz);
    r0.z = saturate(dot(c[17].xyz, r10.xyz));
    r0.w = ((-abs(r0.y)) >= 0.0f ? (c0.x) : (c0.z));
    r6.xyz = (r0.zzz) * (c[18].xyz);
    if ((r0.w) != (-(r0.w)))
    {
        r0.w = r0.y;
        r1.w = r0.w;
    }
    else
    {
        if ((c0.x) >= (v4.w))
        {
            r1 = (v4.xyzx) * (c0.xxxz);
            r0 = (r1) + (-(c3.xyzz));
            r0 = tex2Dlod(s1, r0);
            r0.w = r0.x;
            r2 = (r1) + (c4.xxyy);
            r2 = tex2Dlod(s1, r2);
            r0.x = r2.x;
            r2 = (r1) + (c4.zzyy);
            r2 = tex2Dlod(s1, r2);
            r0.y = r2.x;
            r1 = (r1) + (c3.xyzz);
            r1 = tex2Dlod(s1, r1);
            r0.z = r1.x;
            r4.w = dot(r0, c4.wwww);
            if ((c3.w) < (v4.w))
            {
                r4.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
                r0.xy = (r4.xy) + (c4.xx);
                r0.zw = (v4.zx) * (c0.xz);
                r0 = tex2Dlod(s1, r0);
                r1.xy = (r4.xy) + (c4.zz);
                r1.zw = (v4.zx) * (c0.xz);
                r3 = tex2Dlod(s1, r1);
                r1.xy = (r4.xy) + (c3.xy);
                r1.zw = (v4.zx) * (c0.xz);
                r2 = tex2Dlod(s1, r1);
                r1.xy = (r4.xy) + (-(c3.xy));
                r1.zw = (v4.zx) * (c0.xz);
                r1 = tex2Dlod(s1, r1);
                r0.y = r3.x;
                r0.z = r2.x;
                r0.w = r1.x;
                r0.w = dot(r0, c4.wwww);
                r0.z = (-(r4.w)) + (r0.w);
                r0.w = (v4.w) * (c12.x) + (c12.y);
                r1.w = (r0.w) * (r0.z) + (r4.w);
            }
            else
            {
                r1.w = r4.w;
            }
        }
        else
        {
            r0.w = (v4.w) + (-(c1.x));
            r0.w = ((r0.w) >= 0.0f ? (c0.z) : (c0.x));
            if ((r0.w) != (-(r0.w)))
            {
                r5.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r5.xy) + (c4.xx);
                r1.zw = (v4.zz) * (c0.xz);
                r1 = tex2Dlod(s1, r1);
                r2.xy = (r5.xy) + (c4.zz);
                r2.zw = (v4.zz) * (c0.xz);
                r4 = tex2Dlod(s1, r2);
                r2.xy = (r5.xy) + (c3.xy);
                r2.zw = (v4.zz) * (c0.xz);
                r3 = tex2Dlod(s1, r2);
                r2.xy = (r5.xy) + (-(c3.xy));
                r2.zw = (v4.zz) * (c0.xz);
                r2 = tex2Dlod(s1, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r0.x = dot(r1, c4.wwww);
                r0.w = saturate((v4.w) + (c12.y));
                r0.z = (r0.y) + (-(r0.x));
                r0.w = (r0.w) * (r0.z) + (r0.x);
            }
            else
            {
                r0.w = r0.y;
            }
            r1.w = r0.w;
        }
    }
    r0.xyz = (-(v5.xyz)) + (c[20].xyz);
    r5.xyz = normalize(r0.xyz);
    r0.w = dot(r5.xyz, c[28].xyz);
    r0.w = saturate((r0.w) * (c[29].x) + (c[29].y));
    r7.xyz = (r1.www) * (r6.xyz) + (r7.xyz);
    r1.z = (r0.w) * (c12.z) + (c12.w);
    r1.w = (r0.w) * (r0.w);
    r0 = (v5.xyzx) * (c0.xxxz) + (c0.zzzx);
    r1.w = (r1.z) * (r1.w);
    r1.z = dot(r0, c[27]);
    r1.z = 1.0f / (r1.z);
    r2.x = dot(r0, c[26]);
    r1.x = dot(r0, c[24]);
    r2.y = (r2.x) * (r2.x);
    r1.y = dot(r0, c[25]);
    r0.w = dot(c[22].yz, r2.xy) + (c[22].x);
    r0.z = saturate(1.0f / (r0.w));
    r0.xy = saturate((r2.xx) * (c[23].xy) + (c[23].zw));
    r2.xy = (r0.xy) * (c12.zz) + (c12.ww);
    r0.xy = (r0.xy) * (r0.xy);
    r0.w = ((-abs(r0.w)) >= 0.0f ? (c0.z) : (r0.z));
    r0.z = (r2.x) * (r0.x);
    r0.w = (r0.w) * (r0.z);
    r0.z = (r0.y) * (-(r2.y)) + (c0.x);
    r0.xy = (r1.zz) * (r1.xy);
    r0.w = (r0.w) * (r0.z);
    r0.xy = (r0.xy) * (c0.yy) + (c0.yy);
    r5.w = (r1.w) * (r0.w);
    r0 = tex2D(s3, r0.xy);
    r1 = (v5.yyyy) * (c[31]);
    r1 = (v5.xxxx) * (c[30]) + (r1);
    r1 = (v5.zzzz) * (c[32]) + (r1);
    r3 = (r1) + (c[33]);
    r2.zw = r3.zw;
    r4.zw = r2.zw;
    r6.xyz = (r0.xyz) * (r0.xyz);
    r1.zw = r4.zw;
    r0.xy = (r3.ww) * (-(c[34].zw)) + (r3.xy);
    r0.zw = r1.zw;
    r0 = tex2Dproj(s2, r0);
    r0.w = r0.x;
    r4.xy = (r2.ww) * (-(c[34].xy)) + (r3.xy);
    r4 = tex2Dproj(s2, r4);
    r0.y = r4.x;
    r2.xy = (r2.ww) * (c[34].xy) + (r3.xy);
    r4 = tex2Dproj(s2, r2);
    r0.x = r4.x;
    r1.xy = (r2.ww) * (c[34].zw) + (r3.xy);
    r1 = tex2Dproj(s2, r1);
    r0.z = r1.x;
    r1.xyz = (r5.www) * (r6.xyz);
    r0.w = dot(r0, c4.wwww);
    r8.xyz = (r1.xyz) * (r0.www);
    r5.w = saturate(dot(r5.xyz, r10.xyz));
    r0 = tex2D(s0, v1.xy);
    r0 = (r0.wxyz) * (v0.wxyz);
    r4 = (-(v5.yyyy)) + (c[6]);
    r3 = (-(v5.xxxx)) + (c[5]);
    r1 = (r4) * (r4);
    r1 = (r3) * (r3) + (r1);
    r2 = (-(v5.zzzz)) + (c[7]);
    r6.xyz = (r0.yzw) * (r0.yzw);
    r1 = (r2) * (r2) + (r1);
    r9.xyz = (r5.www) * (c[21].xyz);
    r5.x = rsqrt(r1.x);
    r5.y = rsqrt(r1.y);
    r5.z = rsqrt(r1.z);
    r5.w = rsqrt(r1.w);
    r9.xyz = (r6.xyz) * (r9.xyz);
    r4 = (r4) * (r5);
    r4 = (r10.yyyy) * (r4);
    r3 = (r3) * (r5);
    r2 = (r2) * (r5);
    r3 = (r3) * (r10.xxxx) + (r4);
    r2 = saturate((r2) * (r10.zzzz) + (r3));
    r0.w = c0.x;
    r1 = saturate((r1) * (c[8]) + (r0.wwww));
    r3.xyz = (r8.xyz) * (r9.xyz);
    r1 = (r2) * (r1);
    r3.xyz = (r6.xyz) * (r7.xyz) + (r3.xyz);
    r2.z = dot(c[11], r1);
    r2.x = dot(c[9], r1);
    r2.y = dot(c[10], r1);
    r1.xyz = (r6.xyz) * (r2.xyz) + (r3.xyz);
    r2.xyz = (r0.xxx) * (v3.xyz);
    r1.xyz = (r1.xyz) * (r0.xxx) + (-(r2.xyz));
    r1.xyz = (v2.www) * (r1.xyz) + (r2.xyz);
    r1.xyz = max(((r1.xyz) * (c[35].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
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
