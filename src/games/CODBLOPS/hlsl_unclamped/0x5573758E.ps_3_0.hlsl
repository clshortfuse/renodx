// Mechanically reconstructed from 0x5573758E.ps_3_0.cso.
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
sampler3D s11 : register(s11);

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
    float4 v8 : TEXCOORD6;
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
    float4 v8 = input.v8;
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(31.875f, 1.0f, 0.0f, 0.000244140625f);
    const float4 c3 = float4(0.75f, 4.0f, -3.0f, -4.0f);
    const float4 c4 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.25f);
    const float4 c12 = float4(-2.0f, 3.0f, 0.5f, 0.0f);
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

    r0 = tex2D(s1, v1.xy);
    r1.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0 = v2;
    r0.xyz = (r1.xxx) * (v5.xyz) + (r0.xyz);
    r0.xyz = (r1.yyy) * (v4.xyz) + (r0.xyz);
    r8.xyz = normalize(r0.xyz);
    r1.w = max(abs(r8.y), abs(r8.z));
    r0.z = max(abs(r8.x), r1.w);
    r1.w = 1.0f / (r0.z);
    r0.xyz = (r8.xyz) * (c[5].xyz);
    r0.xyz = (r0.xyz) * (r1.www) + (v8.xyz);
    r1 = tex3D(s11, r0.xyz);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r1.z = saturate(dot(c[17].xyz, r8.xyz));
    r7.xyz = (r0.xyz) * (c1.xxx);
    r6.xyz = (r1.zzz) * (c[18].xyz);
    if ((c1.y) >= (v6.w))
    {
        r2 = (v6.xyzx) * (c1.yyyz);
        r1 = (r2) + (-(c4.xyzz));
        r1 = tex2Dlod(s2, r1);
        r1.w = r1.x;
        r3 = (r2) + (c1.wwzz);
        r3 = tex2Dlod(s2, r3);
        r1.x = r3.x;
        r3 = (r2) + (-(c1.wwzz));
        r3 = tex2Dlod(s2, r3);
        r1.y = r3.x;
        r2 = (r2) + (c4.xyzz);
        r2 = tex2Dlod(s2, r2);
        r1.z = r2.x;
        r6.w = dot(r1, c4.wwww);
        if ((c3.x) < (v6.w))
        {
            r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r1.xy = (r0.xy) + (c1.ww);
            r1.zw = (v6.zx) * (c1.yz);
            r1 = tex2Dlod(s2, r1);
            r2.xy = (r0.xy) + (-(c1.ww));
            r2.zw = (v6.zx) * (c1.yz);
            r4 = tex2Dlod(s2, r2);
            r2.xy = (r0.xy) + (c4.xy);
            r2.zw = (v6.zx) * (c1.yz);
            r3 = tex2Dlod(s2, r2);
            r2.xy = (r0.xy) + (-(c4.xy));
            r2.zw = (v6.zx) * (c1.yz);
            r2 = tex2Dlod(s2, r2);
            r1.y = r4.x;
            r1.z = r3.x;
            r1.w = r2.x;
            r0.z = dot(r1, c4.wwww);
            r0.y = (-(r6.w)) + (r0.z);
            r0.z = (v6.w) * (c3.y) + (c3.z);
            r6.w = (r0.z) * (r0.y) + (r6.w);
        }
    }
    else
    {
        r0.z = (v6.w) + (c3.w);
        r0.z = ((r0.z) >= 0.0f ? (c1.z) : (c1.y));
        if ((r0.z) != (-(r0.z)))
        {
            r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r2.xy = (r0.xy) + (c1.ww);
            r2.zw = (v6.zz) * (c1.yz);
            r2 = tex2Dlod(s2, r2);
            r3.xy = (r0.xy) + (-(c1.ww));
            r3.zw = (v6.zz) * (c1.yz);
            r5 = tex2Dlod(s2, r3);
            r3.xy = (r0.xy) + (c4.xy);
            r3.zw = (v6.zz) * (c1.yz);
            r4 = tex2Dlod(s2, r3);
            r3.xy = (r0.xy) + (-(c4.xy));
            r3.zw = (v6.zz) * (c1.yz);
            r3 = tex2Dlod(s2, r3);
            r2.y = r5.x;
            r2.z = r4.x;
            r2.w = r3.x;
            r0.x = dot(r2, c4.wwww);
            r0.z = saturate((v6.w) + (c3.z));
            r0.y = (r1.w) + (-(r0.x));
            r0.z = (r0.z) * (r0.y) + (r0.x);
        }
        else
        {
            r0.z = r1.w;
        }
        r6.w = r0.z;
    }
    r1.xyz = (-(v7.xyz)) + (c[6].xyz);
    r0.xyz = normalize(r1.xyz);
    r2.w = saturate(dot(r0.xyz, r8.xyz));
    r1 = (v7.yyyy) * (c[25]);
    r0.z = dot(r0.xyz, c[22].xyz);
    r1 = (v7.xxxx) * (c[24]) + (r1);
    r0.z = saturate((r0.z) * (c[23].x) + (c[23].y));
    r1 = (v7.zzzz) * (c[26]) + (r1);
    r0.y = (r0.z) * (c12.x) + (c12.y);
    r4 = (r1) + (c[27]);
    r0.z = (r0.z) * (r0.z);
    r3.zw = r4.zw;
    r4.z = (r0.y) * (r0.z);
    r5.zw = r3.zw;
    r8.xyz = (r2.www) * (c[7].xyz);
    r1.zw = r5.zw;
    r2.xy = (r4.ww) * (-(c[28].zw)) + (r4.xy);
    r2.zw = r1.zw;
    r2 = tex2Dproj(s3, r2);
    r2.w = r2.x;
    r5.xy = (r3.ww) * (-(c[28].xy)) + (r4.xy);
    r5 = tex2Dproj(s3, r5);
    r2.y = r5.x;
    r3.xy = (r3.ww) * (c[28].xy) + (r4.xy);
    r5 = tex2Dproj(s3, r3);
    r2.x = r5.x;
    r1.xy = (r3.ww) * (c[28].zw) + (r4.xy);
    r1 = tex2Dproj(s3, r1);
    r2.z = r1.x;
    r1 = (v7.xyzx) * (c1.yyyz) + (c1.zzzy);
    r2.w = dot(r2, c4.wwww);
    r0.z = dot(r1, c[21]);
    r2.z = 1.0f / (r0.z);
    r2.x = dot(r1, c[20]);
    r0.x = dot(r1, c[10]);
    r2.y = (r2.x) * (r2.x);
    r0.y = dot(r1, c[11]);
    r0.z = dot(c[8].yz, r2.xy) + (c[8].x);
    r1.w = saturate(1.0f / (r0.z));
    r1.xy = saturate((r2.xx) * (c[9].xy) + (c[9].zw));
    r2.xy = (r1.xy) * (c12.xx) + (c12.yy);
    r1.xy = (r1.xy) * (r1.xy);
    r0.z = ((-abs(r0.z)) >= 0.0f ? (c1.z) : (r1.w));
    r1.w = (r2.x) * (r1.x);
    r0.z = (r0.z) * (r1.w);
    r1.w = (r1.y) * (-(r2.y)) + (c1.y);
    r0.xy = (r2.zz) * (r0.xy);
    r0.z = (r0.z) * (r1.w);
    r3.w = (r4.z) * (r0.z);
    r0.xy = (r0.xy) * (c12.zz) + (c12.zz);
    r1 = tex2D(s4, r0.xy);
    r2.xyz = (r1.xyz) * (r1.xyz);
    r1 = tex2D(s0, v1.xy);
    r0.xyz = (r1.xyz) * (v0.xyz);
    r1.xyz = (r3.www) * (r2.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r2.xyz = (r2.www) * (r1.xyz);
    r3.xyz = (r8.xyz) * (r0.xyz);
    r1.xyz = (r6.www) * (r6.xyz) + (r7.xyz);
    r2.xyz = (r2.xyz) * (r3.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[29].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c1.y;

    return oC0;
}
