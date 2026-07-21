// Mechanically reconstructed from 0x5C74902F.ps_3_0.cso.
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
    const float4 c0 = float4(8.0f, 1.0f, 0.797884583f, 0.5f);
    const float4 c1 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c3 = float4(4.0f, -2.0f, 0.600000024f, 0.400000006f);
    const float4 c4 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c12 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c13 = float4(0.000244140625f, 0.0f, -0.000244140625f, -3.0f);
    const float4 c14 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.0f);
    const float4 c15 = float4(4.0f, -3.0f, -2.0f, 3.0f);
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
    r9.w = rsqrt(r0.w);
    r0.w = dot(r1.xyz, r1.xyz);
    r0.w = rsqrt(r0.w);
    r10.xyz = (r9.www) * (v5.xyz);
    r2.xyz = (r1.xyz) * (r0.www) + (-(r10.xyz));
    r0.xyz = normalize(r2.xyz);
    r9.xyz = normalize(v2.xyz);
    r8.w = saturate(dot(r9.xyz, r0.xyz));
    r5.xyz = (r1.xyz) * (r0.www);
    r5.w = saturate(dot(r0.xyz, r5.xyz));
    r0.w = dot(r5.xyz, c[22].xyz);
    r3.w = saturate((r0.w) * (c[23].x) + (c[23].y));
    r0.xy = (v1.zw) * (c0.yw);
    r0 = tex2D(s13, r0.xy);
    r2 = tex2D(s14, v1.zw);
    r6.xy = (r2.xy) * (c1.ww);
    r1.w = (r3.w) * (c15.z) + (c15.w);
    r4.xy = (r0.xz) * (r6.xx);
    r1.x = r0.y;
    r0.w = (r2.x) * (c1.w) + (-(r4.x));
    r1.z = (r0.z) * (-(r6.x)) + (r0.w);
    r0.xy = (v1.zw) * (c1.xy) + (c1.zy);
    r0 = tex2D(s13, r0.xy);
    r3.xy = (r6.yy) * (r0.xz);
    r1.y = r0.y;
    r0.w = (r2.y) * (c1.w) + (-(r3.x));
    r0.xy = (r1.xy) * (c3.xx) + (c3.yy);
    r0.z = (r0.z) * (-(r6.y)) + (r0.w);
    r0.w = dot(r0.xy, r0.xy) + (c1.z);
    r7.y = (r1.z) + (r1.z);
    r0.w = exp2(-(r0.w));
    r0.y = (r0.z) + (r0.z);
    r1.z = saturate((r0.w) * (c3.z) + (c3.w));
    r7.xz = (r4.xy) * (c3.xx);
    r0.xz = (r3.xy) * (c3.xx);
    r0.w = (r3.w) * (r3.w);
    r0.xyz = (r0.xyz) * (r1.zzz) + (r7.xyz);
    r6.w = (r1.w) * (r0.w);
    r8.xyz = (r0.xyz) * (c[29].yyy);
    r0 = tex2D(s12, v1.zw);
    r7.w = saturate(dot(r9.xyz, c[17].xyz));
    r0.w = ((-abs(r0.y)) >= 0.0f ? (c1.x) : (c1.z));
    r6.xyz = (r7.www) * (c[18].xyz);
    if ((r0.w) != (-(r0.w)))
    {
        r0.w = r0.y;
        r3.w = r0.w;
    }
    else
    {
        if ((c0.y) >= (v4.w))
        {
            r1 = (v4.xyzx) * (c1.xxxz);
            r0 = (r1) + (-(c14.xyzz));
            r0 = tex2Dlod(s1, r0);
            r0.w = r0.x;
            r2 = (r1) + (c13.xxyy);
            r2 = tex2Dlod(s1, r2);
            r0.x = r2.x;
            r2 = (r1) + (c13.zzyy);
            r2 = tex2Dlod(s1, r2);
            r0.y = r2.x;
            r1 = (r1) + (c14.xyzz);
            r1 = tex2Dlod(s1, r1);
            r0.z = r1.x;
            r4.w = dot(r0, c4.zzzz);
            if ((c4.w) < (v4.w))
            {
                r4.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
                r0.xy = (r4.xy) + (c13.xx);
                r0.zw = (v4.zx) * (c1.xz);
                r0 = tex2Dlod(s1, r0);
                r1.xy = (r4.xy) + (c13.zz);
                r1.zw = (v4.zx) * (c1.xz);
                r3 = tex2Dlod(s1, r1);
                r1.xy = (r4.xy) + (c14.xy);
                r1.zw = (v4.zx) * (c1.xz);
                r2 = tex2Dlod(s1, r1);
                r1.xy = (r4.xy) + (-(c14.xy));
                r1.zw = (v4.zx) * (c1.xz);
                r1 = tex2Dlod(s1, r1);
                r0.y = r3.x;
                r0.z = r2.x;
                r0.w = r1.x;
                r0.w = dot(r0, c4.zzzz);
                r0.z = (-(r4.w)) + (r0.w);
                r0.w = (v4.w) * (c15.x) + (c15.y);
                r3.w = (r0.w) * (r0.z) + (r4.w);
            }
            else
            {
                r3.w = r4.w;
            }
        }
        else
        {
            r0.w = (v4.w) + (-(c3.x));
            r0.w = ((r0.w) >= 0.0f ? (c1.z) : (c1.x));
            if ((r0.w) != (-(r0.w)))
            {
                r11.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r11.xy) + (c13.xx);
                r1.zw = (v4.zz) * (c1.xz);
                r1 = tex2Dlod(s1, r1);
                r2.xy = (r11.xy) + (c13.zz);
                r2.zw = (v4.zz) * (c1.xz);
                r4 = tex2Dlod(s1, r2);
                r2.xy = (r11.xy) + (c14.xy);
                r2.zw = (v4.zz) * (c1.xz);
                r3 = tex2Dlod(s1, r2);
                r2.xy = (r11.xy) + (-(c14.xy));
                r2.zw = (v4.zz) * (c1.xz);
                r2 = tex2Dlod(s1, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r0.x = dot(r1, c4.zzzz);
                r0.w = saturate((v4.w) + (c13.w));
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
    r0.xyz = (v5.xyz) * (-(r9.www)) + (c[17].xyz);
    r4.xyz = normalize(r0.xyz);
    r0.w = saturate(dot(r4.xyz, c[17].xyz));
    r2.xyz = (r3.www) * (r6.xyz) + (r8.xyz);
    r0.y = (-(r0.w)) + (c0.y);
    r0.z = (r0.y) * (r0.y);
    r0.w = (-(r5.w)) + (c0.y);
    r0.x = (r0.z) * (r0.z);
    r0.z = (r0.w) * (r0.w);
    r5.w = (r0.y) * (r0.x);
    r0.z = (r0.z) * (r0.z);
    r0.w = (r0.w) * (r0.z);
    r4.w = saturate(dot(r5.xyz, r9.xyz));
    r1 = tex2D(s4, v1.xy);
    r3.xyz = (r1.xyz) * (-(r1.xyz)) + (c0.yyy);
    r5.xyz = (r1.xyz) * (r1.xyz);
    r0.xyz = (r3.xyz) * (r0.www) + (r5.xyz);
    r1.z = (r1.w) * (-(c0.z)) + (c0.y);
    r6.y = (r1.w) * (c0.z);
    r2.w = saturate(dot(r9.xyz, -(r10.xyz)));
    r0.w = (r4.w) * (r1.z) + (r6.y);
    r1.y = (r2.w) * (r1.z) + (r6.y);
    r0.w = (r0.w) * (r1.y) + (c4.x);
    r11.xy = (r1.ww) * (c12.xy) + (c12.zw);
    r6.x = 1.0f / (r0.w);
    r6.z = exp2(r11.y);
    r1.x = pow(abs(r8.w), r6.z);
    r0.w = (r6.z) * (c4.y) + (c4.z);
    r6.x = (r4.w) * (r6.x);
    r1.x = (r1.x) * (r0.w);
    r1.x = (r6.x) * (r1.x);
    r1.z = (r7.w) * (r1.z) + (r6.y);
    r0.xyz = (r0.xyz) * (r1.xxx);
    r1.z = (r1.z) * (r1.y) + (c4.x);
    r1.z = 1.0f / (r1.z);
    r4.z = saturate(dot(r9.xyz, r4.xyz));
    r1.z = (r7.w) * (r1.z);
    r1.y = pow(abs(r4.z), r6.z);
    r0.w = (r0.w) * (r1.y);
    r0.xyz = (r0.xyz) * (c[7].xyz);
    r4.z = (r1.z) * (r0.w);
    r8.xyz = (r0.xyz) * (c[29].www);
    r0 = tex2D(s0, v1.xy);
    r1.xyz = (r3.xyz) * (r5.www) + (r5.xyz);
    r0 = (r0.wxyz) * (v0.wxyz);
    r4.xyz = (r4.zzz) * (r1.xyz);
    r1.xyz = (r0.yzw) * (r0.yzw);
    r4.xyz = (r4.xyz) * (c[29].www);
    r6.xyz = (r4.www) * (c[6].xyz);
    r4.xyz = (r4.xyz) * (c[19].xyz);
    r6.xyz = (r1.xyz) * (r6.xyz) + (r8.xyz);
    r4.xyz = (r3.www) * (r4.xyz);
    r8.xyz = (r1.xyz) * (r2.xyz) + (r4.xyz);
    r0.w = (-(r2.w)) + (c0.y);
    r0.y = 1.0f / (r11.x);
    r0.z = (r0.w) * (r0.w);
    r0.w = (r0.w) * (r0.z);
    r0.z = dot(r10.xyz, r9.xyz);
    r0.w = (r0.y) * (r0.w);
    r0.z = (r0.z) + (r0.z);
    r1.w = (r1.w) * (c0.x);
    r1.xyz = (r9.xyz) * (-(r0.zzz)) + (r10.xyz);
    r2 = texCUBElod(s15, r1);
    r1 = (v5.yyyy) * (c[25]);
    r1 = (v5.xxxx) * (c[24]) + (r1);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r1 = (v5.zzzz) * (c[26]) + (r1);
    r2.xyz = (r2.xyz) * (c[29].xxx);
    r4 = (r1) + (c[27]);
    r1.xyz = (r3.xyz) * (r0.www) + (r5.xyz);
    r3.zw = r4.zw;
    r1.xyz = (r2.xyz) * (r1.xyz);
    r5.zw = r3.zw;
    r7.xyz = (r7.xyz) * (r1.xyz);
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
    r2 = (v5.xyzx) * (c1.xxxz) + (c1.zzzx);
    r1.z = r3.x;
    r0.w = dot(r2, c[21]);
    r0.y = 1.0f / (r0.w);
    r4.x = dot(r2, c[20]);
    r3.x = dot(r2, c[10]);
    r4.y = (r4.x) * (r4.x);
    r3.y = dot(r2, c[11]);
    r0.w = dot(c[8].yz, r4.xy) + (c[8].x);
    r0.z = saturate(1.0f / (r0.w));
    r2.xy = saturate((r4.xx) * (c[9].xy) + (c[9].zw));
    r4.xy = (r2.xy) * (c15.zz) + (c15.ww);
    r2.xy = (r2.xy) * (r2.xy);
    r0.w = ((-abs(r0.w)) >= 0.0f ? (c1.z) : (r0.z));
    r0.z = (r4.x) * (r2.x);
    r0.w = (r0.w) * (r0.z);
    r0.z = (r2.y) * (-(r4.y)) + (c0.y);
    r2.xy = (r0.yy) * (r3.xy);
    r0.w = (r0.w) * (r0.z);
    r0.z = (r6.w) * (r0.w);
    r2.xy = (r2.xy) * (c0.ww) + (c0.ww);
    r2 = tex2D(s3, r2.xy);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r0.w = dot(r1, c4.zzzz);
    r1.xyz = (r0.zzz) * (r2.xyz);
    r2.xyz = (r7.xyz) * (c0.xxx) + (r8.xyz);
    r1.xyz = (r0.www) * (r1.xyz);
    r1.xyz = (r1.xyz) * (r6.xyz) + (r2.xyz);
    r2.xyz = (r0.xxx) * (v3.xyz);
    r1.xyz = (r1.xyz) * (r0.xxx) + (-(r2.xyz));
    r1.xyz = (v2.www) * (r1.xyz) + (r2.xyz);
    r1.xyz = max(((r1.xyz) * (c[30].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
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
