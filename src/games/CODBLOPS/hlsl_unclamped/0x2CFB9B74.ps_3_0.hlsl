// Mechanically reconstructed from 0x2CFB9B74.ps_3_0.cso.
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
    const float4 c0 = float4(-0.5f, 1.0f, 0.0f, 31.875f);
    const float4 c1 = float4(0.000244140625f, 0.0f, -0.000244140625f, 0.25f);
    const float4 c3 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c4 = float4(4.0f, -3.0f, -4.0f, 2.0f);
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
    float4 oC0 = 0.0f;

    r0 = tex2D(s0, v1.xy);
    r1.w = (r0.w) * (v0.w) + (c0.x);
    r9.xyz = normalize(v2.xyz);
    r0 = (r0.xyzx) * (c0.yyyz) + (c0.zzzy);
    r2.w = max(abs(r9.y), abs(r9.z));
    r0 = float4(((r1.w) >= 0.0f ? (r0.x) : (c0.z)), ((r1.w) >= 0.0f ? (r0.y) : (c0.z)), ((r1.w) >= 0.0f ? (r0.z) : (c0.z)), ((r1.w) >= 0.0f ? (r0.w) : (c0.z)));
    r1.w = max(abs(r9.x), r2.w);
    r1.w = 1.0f / (r1.w);
    r1.xyz = (r9.xyz) * (c[5].xyz);
    r2.xyz = (r0.xyz) * (v0.xyz);
    r0.xyz = (r1.xyz) * (r1.www) + (v6.xyz);
    r1 = tex3D(s11, r0.xyz);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r6.xyz = (r2.xyz) * (r2.xyz);
    r1.xyz = (r0.www) * (r0.xyz);
    r2.w = saturate(dot(c[17].xyz, r9.xyz));
    r0.xyz = c[18].xyz;
    r0.xyz = (r0.xyz) * (c[28].xxx);
    r8.xyz = (r1.xyz) * (c0.www);
    r7.xyz = (r2.www) * (r0.xyz);
    if ((c0.y) >= (v4.w))
    {
        r2 = (v4.xyzx) * (c0.yyyz);
        r1 = (r2) + (-(c3.xyzz));
        r1 = tex2Dlod(s1, r1);
        r1.w = r1.x;
        r3 = (r2) + (c1.xxyy);
        r3 = tex2Dlod(s1, r3);
        r1.x = r3.x;
        r3 = (r2) + (c1.zzyy);
        r3 = tex2Dlod(s1, r3);
        r1.y = r3.x;
        r2 = (r2) + (c3.xyzz);
        r2 = tex2Dlod(s1, r2);
        r1.z = r2.x;
        r6.w = dot(r1, c1.wwww);
        if ((c3.w) < (v4.w))
        {
            r0.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
            r1.xy = (r0.xy) + (c1.xx);
            r1.zw = (v4.zx) * (c0.yz);
            r1 = tex2Dlod(s1, r1);
            r2.xy = (r0.xy) + (c1.zz);
            r2.zw = (v4.zx) * (c0.yz);
            r4 = tex2Dlod(s1, r2);
            r2.xy = (r0.xy) + (c3.xy);
            r2.zw = (v4.zx) * (c0.yz);
            r3 = tex2Dlod(s1, r2);
            r2.xy = (r0.xy) + (-(c3.xy));
            r2.zw = (v4.zx) * (c0.yz);
            r2 = tex2Dlod(s1, r2);
            r1.y = r4.x;
            r1.z = r3.x;
            r1.w = r2.x;
            r0.z = dot(r1, c1.wwww);
            r0.y = (-(r6.w)) + (r0.z);
            r0.z = (v4.w) * (c4.x) + (c4.y);
            r6.w = (r0.z) * (r0.y) + (r6.w);
        }
    }
    else
    {
        r0.z = (v4.w) + (c4.z);
        r0.z = ((r0.z) >= 0.0f ? (c0.z) : (c0.y));
        if ((r0.z) != (-(r0.z)))
        {
            r0.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
            r2.xy = (r0.xy) + (c1.xx);
            r2.zw = (v4.zz) * (c0.yz);
            r2 = tex2Dlod(s1, r2);
            r3.xy = (r0.xy) + (c1.zz);
            r3.zw = (v4.zz) * (c0.yz);
            r5 = tex2Dlod(s1, r3);
            r3.xy = (r0.xy) + (c3.xy);
            r3.zw = (v4.zz) * (c0.yz);
            r4 = tex2Dlod(s1, r3);
            r3.xy = (r0.xy) + (-(c3.xy));
            r3.zw = (v4.zz) * (c0.yz);
            r3 = tex2Dlod(s1, r3);
            r2.y = r5.x;
            r2.z = r4.x;
            r2.w = r3.x;
            r0.x = dot(r2, c1.wwww);
            r0.z = saturate((v4.w) + (c4.y));
            r0.y = (r1.w) + (-(r0.x));
            r0.z = (r0.z) * (r0.y) + (r0.x);
        }
        else
        {
            r0.z = r1.w;
        }
        r6.w = r0.z;
    }
    r1.xyz = (-(v5.xyz)) + (c[6].xyz);
    r0.xyz = normalize(r1.xyz);
    r2.w = saturate(dot(r0.xyz, r9.xyz));
    r1 = (v5.yyyy) * (c[25]);
    r0.z = dot(r0.xyz, c[22].xyz);
    r1 = (v5.xxxx) * (c[24]) + (r1);
    r0.z = saturate((r0.z) * (c[23].x) + (c[23].y));
    r1 = (v5.zzzz) * (c[26]) + (r1);
    r0.y = (r0.z) * (-(c4.w)) + (-(c4.y));
    r4 = (r1) + (c[27]);
    r0.z = (r0.z) * (r0.z);
    r3.zw = r4.zw;
    r4.z = (r0.y) * (r0.z);
    r5.zw = r3.zw;
    r9.xyz = (r2.www) * (c[7].xyz);
    r2.zw = r5.zw;
    r1.xy = (r4.ww) * (-(c[29].zw)) + (r4.xy);
    r1.zw = r2.zw;
    r1 = tex2Dproj(s2, r1);
    r1.w = r1.x;
    r5.xy = (r3.ww) * (-(c[29].xy)) + (r4.xy);
    r5 = tex2Dproj(s2, r5);
    r1.y = r5.x;
    r3.xy = (r3.ww) * (c[29].xy) + (r4.xy);
    r5 = tex2Dproj(s2, r3);
    r1.x = r5.x;
    r2.xy = (r3.ww) * (c[29].zw) + (r4.xy);
    r3 = tex2Dproj(s2, r2);
    r2 = (v5.xyzx) * (c0.yyyz) + (c0.zzzy);
    r1.z = r3.x;
    r0.z = dot(r2, c[21]);
    r3.w = 1.0f / (r0.z);
    r3.x = dot(r2, c[20]);
    r0.x = dot(r2, c[10]);
    r3.y = (r3.x) * (r3.x);
    r0.y = dot(r2, c[11]);
    r0.z = dot(c[8].yz, r3.xy) + (c[8].x);
    r2.w = saturate(1.0f / (r0.z));
    r2.xy = saturate((r3.xx) * (c[9].xy) + (c[9].zw));
    r3.xy = (r2.xy) * (-(c4.ww)) + (-(c4.yy));
    r2.xy = (r2.xy) * (r2.xy);
    r0.z = ((-abs(r0.z)) >= 0.0f ? (c0.z) : (r2.w));
    r2.w = (r3.x) * (r2.x);
    r0.z = (r0.z) * (r2.w);
    r2.w = (r2.y) * (-(r3.y)) + (c0.y);
    r0.xy = (r3.ww) * (r0.xy);
    r0.z = (r0.z) * (r2.w);
    r3.w = (r4.z) * (r0.z);
    r0.xy = (r0.xy) * (-(c0.xx)) + (-(c0.xx));
    r2 = tex2D(s3, r0.xy);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r1.w = dot(r1, c1.wwww);
    r0.xyz = (r3.www) * (r0.xyz);
    r2.xyz = (r6.xyz) * (r9.xyz);
    r1.xyz = (r1.www) * (r0.xyz);
    r0.xyz = (r6.www) * (r7.xyz) + (r8.xyz);
    r1.xyz = (r2.xyz) * (r1.xyz);
    r1.xyz = (r6.xyz) * (r0.xyz) + (r1.xyz);
    r1.w = c0.y;
    r0.z = dot(r1, c[33]);
    r0.x = dot(r1, c[31]);
    r0.y = dot(r1, c[32]);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r1.x = v2.w;
    r0.xyz = (r1.xxx) * (r0.xyz) + (v3.xyz);
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
