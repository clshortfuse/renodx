// Mechanically reconstructed from 0x2AF31F3A.ps_3_0.cso.
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
    const float4 c3 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c4 = float4(4.0f, -2.0f, 0.0009765625f, 0.25f);
    const float4 c12 = float4(1.0f, 0.797884583f, 0.959999979f, 0.0399999991f);
    const float4 c13 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c14 = float4(0.125f, 0.25f, 0.000244140625f, 0.0f);
    const float4 c15 = float4(4.0f, -3.0f, -2.0f, 3.0f);
    const float4 c16 = float4(3.5f, -13.0f, 1.0f, 13.0f);
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
    float4 oC0 = 0.0f;

    r0.w = dot(v7.xyz, v7.xyz);
    r5.z = rsqrt(r0.w);
    r0 = tex2D(s1, v1.xy);
    r3.xyz = (-(v7.xyz)) + (c[5].xyz);
    r8.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0.w = dot(r3.xyz, r3.xyz);
    r3.w = rsqrt(r0.w);
    r10.xyz = (r5.zzz) * (v7.xyz);
    r1.xyz = (r3.xyz) * (r3.www) + (-(r10.xyz));
    r0.xyz = v2.xyz;
    r0.xyz = (r8.xxx) * (v5.xyz) + (r0.xyz);
    r4.xyz = normalize(r1.xyz);
    r0.xyz = (r8.yyy) * (v4.xyz) + (r0.xyz);
    r9.xyz = normalize(r0.xyz);
    r0.w = dot(r8.xy, r8.xy) + (c1.x);
    r5.w = saturate(dot(r9.xyz, r4.xyz));
    r0.w = exp2(-(r0.w));
    r4.w = (r0.w) * (c1.y) + (c1.z);
    r0.xy = (v1.zw) * (c3.xy);
    r2 = tex2D(s13, r0.xy);
    r0.xy = (v1.zw) * (c3.xy) + (c3.zy);
    r0 = tex2D(s13, r0.xy);
    r1 = tex2D(s14, v1.zw);
    r6.xy = (r1.xy) * (c3.ww);
    r2.w = r0.y;
    r5.xy = (r2.xz) * (r6.xx);
    r7.xy = (r2.yw) * (c4.xx) + (c4.yy);
    r0.y = (r1.x) * (c3.w) + (-(r5.x));
    r0.w = dot(r7.xy, r8.xy) + (c1.x);
    r1.w = (r2.z) * (-(r6.x)) + (r0.y);
    r2.xy = (r0.xz) * (r6.yy);
    r0.x = dot(r7.xy, r7.xy) + (c1.x);
    r0.y = (r1.y) * (c3.w) + (-(r2.x));
    r0.x = exp2(-(r0.x));
    r0.y = (r0.z) * (-(r6.y)) + (r0.y);
    r0.z = (r0.x) * (c1.y) + (c1.z);
    r7.y = (r1.w) + (r1.w);
    r0.z = (r4.w) * (r0.z);
    r0.y = (r0.y) + (r0.y);
    r0.w = saturate((r0.w) * (r0.z) + (r0.z));
    r0.xz = (r2.xy) * (c4.xx);
    r1.xyz = (v7.xyz) * (-(r5.zzz)) + (c[17].xyz);
    r0.xyz = (r0.xyz) * (r0.www);
    r2.xyz = normalize(r1.xyz);
    r7.xz = (r5.xy) * (c4.xx);
    r0.w = saturate(dot(r2.xyz, c[17].xyz));
    r0.xyz = (r7.xyz) * (r4.www) + (r0.xyz);
    r1.w = (-(r0.w)) + (c12.x);
    r3.xyz = (r3.xyz) * (r3.www);
    r0.w = (r1.w) * (r1.w);
    r4.x = saturate(dot(r4.xyz, r3.xyz));
    r1.z = (r0.w) * (r0.w);
    r0.w = dot(r3.xyz, c[22].xyz);
    r1.w = (r1.w) * (r1.z);
    r2.w = (r1.w) * (c12.z) + (c12.w);
    r0.w = saturate((r0.w) * (c[23].x) + (c[23].y));
    r5.z = (r0.w) * (c15.z) + (c15.w);
    r3.w = (r0.w) * (r0.w);
    r1 = tex2D(s5, v1.xy);
    r4.w = (r1.w) * (-(c12.y)) + (c12.x);
    r4.y = (r1.w) * (c12.y);
    r8.w = saturate(dot(r3.xyz, r9.xyz));
    r1.z = saturate(dot(r9.xyz, -(r10.xyz)));
    r0.w = (r8.w) * (r4.w) + (r4.y);
    r4.z = (r1.z) * (r4.w) + (r4.y);
    r6.w = (r5.z) * (r3.w);
    r0.w = (r0.w) * (r4.z) + (c4.z);
    r0.w = 1.0f / (r0.w);
    r11.xy = (r1.ww) * (c16.xy) + (c16.zw);
    r3.w = (r8.w) * (r0.w);
    r3.x = exp2(r11.y);
    r1.x = pow(abs(r5.w), r3.x);
    r0.w = (r3.x) * (c14.x) + (c14.y);
    r1.x = (r1.x) * (r0.w);
    r3.z = (-(r4.x)) + (c12.x);
    r3.w = (r3.w) * (r1.x);
    r1.x = (r3.z) * (r3.z);
    r3.y = (r1.x) * (r1.x);
    r1.x = saturate(dot(r9.xyz, c[17].xyz));
    r3.z = (r3.z) * (r3.y);
    r4.w = (r1.x) * (r4.w) + (r4.y);
    r3.y = saturate(dot(r9.xyz, r2.xyz));
    r2.z = (r4.w) * (r4.z) + (c4.z);
    r2.y = pow(abs(r3.y), r3.x);
    r2.z = 1.0f / (r2.z);
    r0.w = (r0.w) * (r2.y);
    r2.y = (r1.x) * (r2.z);
    r2.z = (r3.z) * (c12.z) + (c12.w);
    r0.w = (r0.w) * (r2.y);
    r9.w = (r3.w) * (r2.z);
    r0.w = (r2.w) * (r0.w);
    r8.xyz = (r0.xyz) * (r1.yyy);
    r7.w = (r1.y) * (r0.w);
    r0 = tex2D(s12, v1.zw);
    r0.w = ((-abs(r0.y)) >= 0.0f ? (c3.x) : (c3.z));
    r6.xyz = (r1.xxx) * (c[18].xyz);
    if ((r0.w) != (-(r0.w)))
    {
        r0.w = r0.y;
        r1.x = r0.w;
    }
    else
    {
        if ((c12.x) >= (v6.w))
        {
            r2 = (v6.xyzx) * (c3.xxxz);
            r0 = (r2) + (-(c13.xyzz));
            r0 = tex2Dlod(s2, r0);
            r0.w = r0.x;
            r3 = (r2) + (c14.zzww);
            r3 = tex2Dlod(s2, r3);
            r0.x = r3.x;
            r3 = (r2) + (-(c14.zzww));
            r3 = tex2Dlod(s2, r3);
            r0.y = r3.x;
            r2 = (r2) + (c13.xyzz);
            r2 = tex2Dlod(s2, r2);
            r0.z = r2.x;
            r1.x = dot(r0, c4.wwww);
            if ((c13.w) < (v6.w))
            {
                r5.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
                r0.xy = (r5.xy) + (c14.zz);
                r0.zw = (v6.zx) * (c3.xz);
                r0 = tex2Dlod(s2, r0);
                r2.xy = (r5.xy) + (-(c14.zz));
                r2.zw = (v6.zx) * (c3.xz);
                r4 = tex2Dlod(s2, r2);
                r2.xy = (r5.xy) + (c13.xy);
                r2.zw = (v6.zx) * (c3.xz);
                r3 = tex2Dlod(s2, r2);
                r2.xy = (r5.xy) + (-(c13.xy));
                r2.zw = (v6.zx) * (c3.xz);
                r2 = tex2Dlod(s2, r2);
                r0.y = r4.x;
                r0.z = r3.x;
                r0.w = r2.x;
                r0.w = dot(r0, c4.wwww);
                r0.z = (-(r1.x)) + (r0.w);
                r0.w = (v6.w) * (c15.x) + (c15.y);
                r1.x = (r0.w) * (r0.z) + (r1.x);
            }
        }
        else
        {
            r0.w = (v6.w) + (-(c4.x));
            r0.w = ((r0.w) >= 0.0f ? (c3.z) : (c3.x));
            if ((r0.w) != (-(r0.w)))
            {
                r12.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r12.xy) + (c14.zz);
                r2.zw = (v6.zz) * (c3.xz);
                r2 = tex2Dlod(s2, r2);
                r3.xy = (r12.xy) + (-(c14.zz));
                r3.zw = (v6.zz) * (c3.xz);
                r5 = tex2Dlod(s2, r3);
                r3.xy = (r12.xy) + (c13.xy);
                r3.zw = (v6.zz) * (c3.xz);
                r4 = tex2Dlod(s2, r3);
                r3.xy = (r12.xy) + (-(c13.xy));
                r3.zw = (v6.zz) * (c3.xz);
                r3 = tex2Dlod(s2, r3);
                r2.y = r5.x;
                r2.z = r4.x;
                r2.w = r3.x;
                r0.x = dot(r2, c4.wwww);
                r0.w = saturate((v6.w) + (c15.y));
                r0.z = (r0.y) + (-(r0.x));
                r0.w = (r0.w) * (r0.z) + (r0.x);
            }
            else
            {
                r0.w = r0.y;
            }
            r1.x = r0.w;
        }
    }
    r0.xyz = (r9.www) * (c[7].xyz);
    r3.xyz = (r1.xxx) * (r6.xyz) + (r8.xyz);
    r5.xyz = (r1.yyy) * (r0.xyz);
    r0 = tex2D(s0, v1.xy);
    r0 = (r0.wxyz) * (v0.wxyz);
    r2.xyz = (r0.yzw) * (r0.yzw);
    r4.xyz = (r8.www) * (c[6].xyz);
    r6.xyz = (r2.xyz) * (r4.xyz) + (r5.xyz);
    r4.xyz = (r7.www) * (c[19].xyz);
    r4.xyz = (r1.xxx) * (r4.xyz);
    r0.w = (-(r1.z)) + (c12.x);
    r8.xyz = (r2.xyz) * (r3.xyz) + (r4.xyz);
    r0.y = (r0.w) * (r0.w);
    r0.z = 1.0f / (r11.x);
    r0.w = (r0.w) * (r0.y);
    r0.w = (r0.z) * (r0.w);
    r0.z = dot(r10.xyz, r9.xyz);
    r0.w = (r0.w) * (c12.z) + (c12.w);
    r0.z = (r0.z) + (r0.z);
    r2.w = (r1.w) * (c1.w);
    r2.xyz = (r9.xyz) * (-(r0.zzz)) + (r10.xyz);
    r3 = texCUBElod(s15, r2);
    r2 = (v7.yyyy) * (c[25]);
    r2 = (v7.xxxx) * (c[24]) + (r2);
    r2 = (v7.zzzz) * (c[26]) + (r2);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r4 = (r2) + (c[27]);
    r1.xyz = (r1.yyy) * (r3.xyz);
    r3.zw = r4.zw;
    r1.xyz = (r0.www) * (r1.xyz);
    r5.zw = r3.zw;
    r7.xyz = (r7.xyz) * (r1.xyz);
    r2.zw = r5.zw;
    r1.xy = (r4.ww) * (-(c[28].zw)) + (r4.xy);
    r1.zw = r2.zw;
    r1 = tex2Dproj(s3, r1);
    r1.w = r1.x;
    r5.xy = (r3.ww) * (-(c[28].xy)) + (r4.xy);
    r5 = tex2Dproj(s3, r5);
    r1.y = r5.x;
    r3.xy = (r3.ww) * (c[28].xy) + (r4.xy);
    r5 = tex2Dproj(s3, r3);
    r1.x = r5.x;
    r2.xy = (r3.ww) * (c[28].zw) + (r4.xy);
    r3 = tex2Dproj(s3, r2);
    r2 = (v7.xyzx) * (c3.xxxz) + (c3.zzzx);
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
    r0.w = ((-abs(r0.w)) >= 0.0f ? (c1.x) : (r0.z));
    r0.z = (r4.x) * (r2.x);
    r0.w = (r0.w) * (r0.z);
    r0.z = (r2.y) * (-(r4.y)) + (c12.x);
    r2.xy = (r0.yy) * (r3.xy);
    r0.w = (r0.w) * (r0.z);
    r0.z = (r6.w) * (r0.w);
    r2.xy = (r2.xy) * (c3.yy) + (c3.yy);
    r2 = tex2D(s4, r2.xy);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r0.w = dot(r1, c4.wwww);
    r1.xyz = (r0.zzz) * (r2.xyz);
    r2.xyz = (r7.xyz) * (c1.www) + (r8.xyz);
    r1.xyz = (r0.www) * (r1.xyz);
    r1.xyz = (r1.xyz) * (r6.xyz) + (r2.xyz);
    r2.xyz = (r0.xxx) * (v3.xyz);
    r1.xyz = (r1.xyz) * (r0.xxx) + (-(r2.xyz));
    r1.xyz = (v2.www) * (r1.xyz) + (r2.xyz);
    r1.xyz = max(((r1.xyz) * (c[29].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
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
