// Mechanically reconstructed from 0x01106331.ps_3_0.cso.
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
    const float4 c1 = float4(-0.5f, 1.0f, 0.0f, 31.875f);
    const float4 c3 = float4(0.000244140625f, 0.0f, -0.000244140625f, 0.25f);
    const float4 c4 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c12 = float4(4.0f, -3.0f, -4.0f, 2.0f);
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

    r5.z = c1.y;
    r0 = tex2D(s1, v1.xy);
    r1 = (v7.yyyy) * (c[32]);
    r1 = (v7.xxxx) * (c[31]) + (r1);
    r1 = (v7.zzzz) * (c[33]) + (r1);
    r3 = (r1) + (c[34]);
    r1.zw = r3.zw;
    r4.zw = r1.zw;
    r5.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0.zw = r4.zw;
    r2.xy = (r3.ww) * (-(c[36].zw)) + (r3.xy);
    r2.zw = r0.zw;
    r2 = tex2Dproj(s3, r2);
    r2.w = r2.x;
    r4.xy = (r1.ww) * (-(c[36].xy)) + (r3.xy);
    r4 = tex2Dproj(s3, r4);
    r2.y = r4.x;
    r1.xy = (r1.ww) * (c[36].xy) + (r3.xy);
    r4 = tex2Dproj(s3, r1);
    r2.x = r4.x;
    r0.xy = (r1.ww) * (c[36].zw) + (r3.xy);
    r3 = tex2Dproj(s3, r0);
    r0 = tex2D(s0, v1.xy);
    r3.w = (r0.w) * (v0.w) + (c1.x);
    r4.xyz = float3(((r3.w) >= 0.0f ? (r5.x) : (c1.z)), ((r3.w) >= 0.0f ? (r5.y) : (c1.z)), ((r3.w) >= 0.0f ? (r5.z) : (c1.z)));
    r1 = v2;
    r1.xyz = (r4.xxx) * (v5.xyz) + (r1.xyz);
    r2.z = r3.x;
    r1.xyz = (r4.yyy) * (v4.xyz) + (r1.xyz);
    r7.w = dot(r2, c3.wwww);
    r9.xyz = normalize(r1.xyz);
    r0 = (r0.xyzx) * (c1.yyyz) + (c1.zzzy);
    r2.w = max(abs(r9.y), abs(r9.z));
    r0 = float4(((r3.w) >= 0.0f ? (r0.x) : (c1.z)), ((r3.w) >= 0.0f ? (r0.y) : (c1.z)), ((r3.w) >= 0.0f ? (r0.z) : (c1.z)), ((r3.w) >= 0.0f ? (r0.w) : (c1.z)));
    r1.z = max(abs(r9.x), r2.w);
    r2.w = 1.0f / (r1.z);
    r2.xyz = (r9.xyz) * (c[5].xyz);
    r1.xyz = (r0.xyz) * (v0.xyz);
    r0.xyz = (r2.xyz) * (r2.www) + (v8.xyz);
    r2 = tex3D(s11, r0.xyz);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r2.xyz = (r4.zzz) * (r0.xyz);
    r3.w = saturate(dot(c[17].xyz, r9.xyz));
    r0.xyz = c[18].xyz;
    r0.xyz = (r0.xyz) * (c[35].xxx);
    r8.xyz = (r2.xyz) * (c1.www);
    r7.xyz = (r3.www) * (r0.xyz);
    if ((c1.y) >= (v6.w))
    {
        r3 = (v6.xyzx) * (c1.yyyz);
        r2 = (r3) + (-(c4.xyzz));
        r2 = tex2Dlod(s2, r2);
        r2.w = r2.x;
        r4 = (r3) + (c3.xxyy);
        r4 = tex2Dlod(s2, r4);
        r2.x = r4.x;
        r4 = (r3) + (c3.zzyy);
        r4 = tex2Dlod(s2, r4);
        r2.y = r4.x;
        r3 = (r3) + (c4.xyzz);
        r3 = tex2Dlod(s2, r3);
        r2.z = r3.x;
        r0.z = dot(r2, c3.wwww);
        if ((c4.w) < (v6.w))
        {
            r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r2.xy = (r0.xy) + (c3.xx);
            r2.zw = (v6.zx) * (c1.yz);
            r2 = tex2Dlod(s2, r2);
            r3.xy = (r0.xy) + (c3.zz);
            r3.zw = (v6.zx) * (c1.yz);
            r5 = tex2Dlod(s2, r3);
            r3.xy = (r0.xy) + (c4.xy);
            r3.zw = (v6.zx) * (c1.yz);
            r4 = tex2Dlod(s2, r3);
            r3.xy = (r0.xy) + (-(c4.xy));
            r3.zw = (v6.zx) * (c1.yz);
            r3 = tex2Dlod(s2, r3);
            r2.y = r5.x;
            r2.z = r4.x;
            r2.w = r3.x;
            r0.y = dot(r2, c3.wwww);
            r0.x = (-(r0.z)) + (r0.y);
            r0.y = (v6.w) * (c12.x) + (c12.y);
            r3.z = (r0.y) * (r0.x) + (r0.z);
        }
        else
        {
            r3.z = r0.z;
        }
    }
    else
    {
        r0.z = (v6.w) + (c12.z);
        r0.z = ((r0.z) >= 0.0f ? (c1.z) : (c1.y));
        if ((r0.z) != (-(r0.z)))
        {
            r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r3.xy = (r0.xy) + (c3.xx);
            r3.zw = (v6.zz) * (c1.yz);
            r3 = tex2Dlod(s2, r3);
            r4.xy = (r0.xy) + (c3.zz);
            r4.zw = (v6.zz) * (c1.yz);
            r6 = tex2Dlod(s2, r4);
            r4.xy = (r0.xy) + (c4.xy);
            r4.zw = (v6.zz) * (c1.yz);
            r5 = tex2Dlod(s2, r4);
            r4.xy = (r0.xy) + (-(c4.xy));
            r4.zw = (v6.zz) * (c1.yz);
            r4 = tex2Dlod(s2, r4);
            r3.y = r6.x;
            r3.z = r5.x;
            r3.w = r4.x;
            r0.x = dot(r3, c3.wwww);
            r0.z = saturate((v6.w) + (c12.y));
            r0.y = (r2.w) + (-(r0.x));
            r0.z = (r0.z) * (r0.y) + (r0.x);
        }
        else
        {
            r0.z = r2.w;
        }
        r3.z = r0.z;
    }
    r0.xyz = (-(v7.xyz)) + (c[21].xyz);
    r6.xyz = normalize(r0.xyz);
    r0.z = dot(r6.xyz, c[29].xyz);
    r0.z = saturate((r0.z) * (c[30].x) + (c[30].y));
    r0.y = (r0.z) * (-(c12.w)) + (-(c12.y));
    r0.z = (r0.z) * (r0.z);
    r2 = (v7.xyzx) * (c1.yyyz) + (c1.zzzy);
    r3.w = (r0.y) * (r0.z);
    r0.z = dot(r2, c[28]);
    r4.w = 1.0f / (r0.z);
    r3.x = dot(r2, c[27]);
    r0.x = dot(r2, c[25]);
    r3.y = (r3.x) * (r3.x);
    r0.y = dot(r2, c[26]);
    r0.z = dot(c[23].yz, r3.xy) + (c[23].x);
    r2.w = saturate(1.0f / (r0.z));
    r2.xy = saturate((r3.xx) * (c[24].xy) + (c[24].zw));
    r3.xy = (r2.xy) * (-(c12.ww)) + (-(c12.yy));
    r2.xy = (r2.xy) * (r2.xy);
    r0.z = ((-abs(r0.z)) >= 0.0f ? (c1.z) : (r2.w));
    r2.w = (r3.x) * (r2.x);
    r0.z = (r0.z) * (r2.w);
    r2.w = (r2.y) * (-(r3.y)) + (c1.y);
    r0.xy = (r4.ww) * (r0.xy);
    r0.z = (r0.z) * (r2.w);
    r3.w = (r3.w) * (r0.z);
    r0.xy = (r0.xy) * (-(c1.xx)) + (-(c1.xx));
    r2 = tex2D(s4, r0.xy);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r0.xyz = (r3.zzz) * (r7.xyz) + (r8.xyz);
    r2.xyz = (r3.www) * (r2.xyz);
    r7.xyz = (r7.www) * (r2.xyz);
    r5 = (-(v7.yyyy)) + (c[7]);
    r4 = (-(v7.xxxx)) + (c[6]);
    r2 = (r5) * (r5);
    r2 = (r4) * (r4) + (r2);
    r3 = (-(v7.zzzz)) + (c[8]);
    r6.w = saturate(dot(r6.xyz, r9.xyz));
    r2 = (r3) * (r3) + (r2);
    r8.xyz = (r6.www) * (c[22].xyz);
    r6.x = rsqrt(r2.x);
    r6.y = rsqrt(r2.y);
    r6.z = rsqrt(r2.z);
    r6.w = rsqrt(r2.w);
    r8.xyz = (r1.xyz) * (r8.xyz);
    r5 = (r5) * (r6);
    r5 = (r9.yyyy) * (r5);
    r4 = (r4) * (r6);
    r3 = (r3) * (r6);
    r4 = (r4) * (r9.xxxx) + (r5);
    r3 = saturate((r3) * (r9.zzzz) + (r4));
    r4.z = c1.y;
    r2 = saturate((r2) * (c[9]) + (r4.zzzz));
    r4.xyz = (r7.xyz) * (r8.xyz);
    r2 = (r3) * (r2);
    r3.xyz = (r1.xyz) * (r0.xyz) + (r4.xyz);
    r0.z = dot(c[20], r2);
    r0.x = dot(c[10], r2);
    r0.y = dot(c[11], r2);
    r2.xyz = (r1.xyz) * (r0.xyz) + (r3.xyz);
    r2.w = c1.y;
    r0.z = dot(r2, c[40]);
    r0.x = dot(r2, c[38]);
    r0.y = dot(r2, c[39]);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r1.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[37].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
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
