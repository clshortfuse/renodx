// Mechanically reconstructed from 0x02C8C230.ps_3_0.cso.
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
sampler3D s11 : register(s11);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD4;
    float4 v5 : TEXCOORD5;
    float4 v6 : TEXCOORD6;
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
    const float4 c0 = float4(31.875f, 1.0f, 0.0f, 0.000244140625f);
    const float4 c1 = float4(0.75f, 4.0f, -3.0f, -4.0f);
    const float4 c3 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.25f);
    const float4 c4 = float4(-2.0f, 3.0f, 0.5f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 oC0 = 0.0f;

    r7.xyz = normalize(v2.xyz);
    r1.w = max(abs(r7.y), abs(r7.z));
    r0.w = max(abs(r7.x), r1.w);
    r0.w = 1.0f / (r0.w);
    r0.xyz = (r7.xyz) * (c[5].xyz);
    r0.xyz = (r0.xyz) * (r0.www) + (v6.xyz);
    r0 = tex3D(s11, r0.xyz);
    r1.xyz = (r0.xyz) * (r0.xyz);
    r1.w = saturate(dot(c[17].xyz, r7.xyz));
    r0.xyz = c[18].xyz;
    r0.xyz = (r0.xyz) * (c[28].xxx);
    r6.xyz = (r1.xyz) * (c0.xxx);
    r5.xyz = (r1.www) * (r0.xyz);
    if ((c0.y) >= (v4.w))
    {
        r1 = (v4.xyzx) * (c0.yyyz);
        r0 = (r1) + (-(c3.xyzz));
        r0 = tex2Dlod(s1, r0);
        r0.w = r0.x;
        r2 = (r1) + (c0.wwzz);
        r2 = tex2Dlod(s1, r2);
        r0.x = r2.x;
        r2 = (r1) + (-(c0.wwzz));
        r2 = tex2Dlod(s1, r2);
        r0.y = r2.x;
        r1 = (r1) + (c3.xyzz);
        r1 = tex2Dlod(s1, r1);
        r0.z = r1.x;
        r5.w = dot(r0, c3.wwww);
        if ((c1.x) < (v4.w))
        {
            r4.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
            r0.xy = (r4.xy) + (c0.ww);
            r0.zw = (v4.zx) * (c0.yz);
            r0 = tex2Dlod(s1, r0);
            r1.xy = (r4.xy) + (-(c0.ww));
            r1.zw = (v4.zx) * (c0.yz);
            r3 = tex2Dlod(s1, r1);
            r1.xy = (r4.xy) + (c3.xy);
            r1.zw = (v4.zx) * (c0.yz);
            r2 = tex2Dlod(s1, r1);
            r1.xy = (r4.xy) + (-(c3.xy));
            r1.zw = (v4.zx) * (c0.yz);
            r1 = tex2Dlod(s1, r1);
            r0.y = r3.x;
            r0.z = r2.x;
            r0.w = r1.x;
            r0.w = dot(r0, c3.wwww);
            r0.z = (-(r5.w)) + (r0.w);
            r0.w = (v4.w) * (c1.y) + (c1.z);
            r5.w = (r0.w) * (r0.z) + (r5.w);
        }
    }
    else
    {
        r0.z = (v4.w) + (c1.w);
        r0.z = ((r0.z) >= 0.0f ? (c0.z) : (c0.y));
        if ((r0.z) != (-(r0.z)))
        {
            r0.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
            r1.xy = (r0.xy) + (c0.ww);
            r1.zw = (v4.zz) * (c0.yz);
            r1 = tex2Dlod(s1, r1);
            r2.xy = (r0.xy) + (-(c0.ww));
            r2.zw = (v4.zz) * (c0.yz);
            r4 = tex2Dlod(s1, r2);
            r2.xy = (r0.xy) + (c3.xy);
            r2.zw = (v4.zz) * (c0.yz);
            r3 = tex2Dlod(s1, r2);
            r2.xy = (r0.xy) + (-(c3.xy));
            r2.zw = (v4.zz) * (c0.yz);
            r2 = tex2Dlod(s1, r2);
            r1.y = r4.x;
            r1.z = r3.x;
            r1.w = r2.x;
            r0.y = dot(r1, c3.wwww);
            r0.z = saturate((v4.w) + (c1.z));
            r0.w = (r0.w) + (-(r0.y));
            r0.w = (r0.z) * (r0.w) + (r0.y);
        }
        r5.w = r0.w;
    }
    r0.xyz = (-(v5.xyz)) + (c[6].xyz);
    r1.xyz = normalize(r0.xyz);
    r0 = (v5.yyyy) * (c[25]);
    r6.w = saturate(dot(r1.xyz, r7.xyz));
    r0 = (v5.xxxx) * (c[24]) + (r0);
    r1.w = dot(r1.xyz, c[22].xyz);
    r0 = (v5.zzzz) * (c[26]) + (r0);
    r1.w = saturate((r1.w) * (c[23].x) + (c[23].y));
    r3 = (r0) + (c[27]);
    r0.z = (r1.w) * (c4.x) + (c4.y);
    r2.zw = r3.zw;
    r0.w = (r1.w) * (r1.w);
    r4.zw = r2.zw;
    r3.z = (r0.z) * (r0.w);
    r1.zw = r4.zw;
    r0.xy = (r3.ww) * (-(c[29].zw)) + (r3.xy);
    r0.zw = r1.zw;
    r0 = tex2Dproj(s2, r0);
    r0.w = r0.x;
    r4.xy = (r2.ww) * (-(c[29].xy)) + (r3.xy);
    r4 = tex2Dproj(s2, r4);
    r0.y = r4.x;
    r2.xy = (r2.ww) * (c[29].xy) + (r3.xy);
    r4 = tex2Dproj(s2, r2);
    r0.x = r4.x;
    r1.xy = (r2.ww) * (c[29].zw) + (r3.xy);
    r1 = tex2Dproj(s2, r1);
    r0.z = r1.x;
    r1.w = dot(r0, c3.wwww);
    r0 = (v5.xyzx) * (c0.yyyz) + (c0.zzzy);
    r2.xyz = (r6.www) * (c[7].xyz);
    r1.z = dot(r0, c[21]);
    r1.z = 1.0f / (r1.z);
    r3.x = dot(r0, c[20]);
    r1.x = dot(r0, c[10]);
    r3.y = (r3.x) * (r3.x);
    r1.y = dot(r0, c[11]);
    r0.w = dot(c[8].yz, r3.xy) + (c[8].x);
    r0.z = saturate(1.0f / (r0.w));
    r0.xy = saturate((r3.xx) * (c[9].xy) + (c[9].zw));
    r3.xy = (r0.xy) * (c4.xx) + (c4.yy);
    r0.xy = (r0.xy) * (r0.xy);
    r0.w = ((-abs(r0.w)) >= 0.0f ? (c0.z) : (r0.z));
    r0.z = (r3.x) * (r0.x);
    r0.w = (r0.w) * (r0.z);
    r0.z = (r0.y) * (-(r3.y)) + (c0.y);
    r0.xy = (r1.zz) * (r1.xy);
    r0.w = (r0.w) * (r0.z);
    r2.w = (r3.z) * (r0.w);
    r0.xy = (r0.xy) * (c4.zz) + (c4.zz);
    r0 = tex2D(s3, r0.xy);
    r1.xyz = (r0.xyz) * (r0.xyz);
    r0 = tex2D(s0, v1.xy);
    r0 = (r0.wxyz) * (v0.wxyz);
    r3.xyz = (r2.www) * (r1.xyz);
    r1.xyz = (r0.yzw) * (r0.yzw);
    r3.xyz = (r1.www) * (r3.xyz);
    r4.xyz = (r2.xyz) * (r1.xyz);
    r2.xyz = (r5.www) * (r5.xyz) + (r6.xyz);
    r3.xyz = (r3.xyz) * (r4.xyz);
    r1.xyz = (r1.xyz) * (r2.xyz) + (r3.xyz);
    r1.xyz = (r0.xxx) * (r1.xyz);
    r1.w = c0.y;
    r2.z = dot(r1, c[33]);
    r2.x = dot(r1, c[31]);
    r2.y = dot(r1, c[32]);
    r1.xyz = (v3.xyz) * (-(r0.xxx)) + (r2.xyz);
    r1.xyz = (r1.xyz) * (v2.www);
    r1.xyz = (v3.xyz) * (r0.xxx) + (r1.xyz);
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
