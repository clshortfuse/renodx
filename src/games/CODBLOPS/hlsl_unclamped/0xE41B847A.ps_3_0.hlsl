// Mechanically reconstructed from 0xE41B847A.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler2D s3 : register(s3);
sampler2D s4 : register(s4);
sampler2D s5 : register(s5);
sampler2D s6 : register(s6);
sampler2D s7 : register(s7);
sampler3D s11 : register(s11);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
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
    const float4 c0 = float4(1.16412354f, 1.59579468f, -0.87065506f, 31.875f);
    const float4 c1 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c3 = float4(4.0f, -3.0f, -4.0f, 9.99999975e-06f);
    const float4 c4 = float4(1.0f, 0.0f, 0.000244140625f, 0.25f);
    const float4 c12 = float4(1e-15f, 1.44269502f, 0.100000001f, 8.0f);
    const float4 c13 = float4(1.16412354f, -0.813476562f, -0.391448975f, 0.529705048f);
    const float4 c14 = float4(1.16412354f, 2.01782227f, -1.08166885f, 0.0f);
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

    r0.xyz = normalize(v2.xyz);
    r1.x = max(abs(r0.y), abs(r0.z));
    r2.x = max(abs(r0.x), r1.x);
    r1.xyz = (r0.xyz) * (c[5].xyz);
    r0.w = 1.0f / (r2.x);
    r1.xyz = (r1.xyz) * (r0.www) + (v4.xyz);
    r1 = tex3D(s11, r1.xyz);
    if ((c4.x) >= (v5.w))
    {
        r2 = (v5.xyzx) * (c4.xxxy) + (c4.yyyx);
        r2 = (r2) * (c4.xxxy);
        r3 = (r2) + (c4.zzyy);
        r3 = tex2Dlod(s1, r3);
        r4 = (r2) + (-(c4.zzyy));
        r4 = tex2Dlod(s1, r4);
        r5 = (r2) + (c1.xyzz);
        r5 = tex2Dlod(s1, r5);
        r2 = (r2) + (-(c1.xyzz));
        r2 = tex2Dlod(s1, r2);
        r3.y = r4.x;
        r3.z = r5.x;
        r3.w = r2.x;
        r0.w = dot(r3, c4.wwww);
        if ((c1.w) < (v5.w))
        {
            r2.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
            r2.zw = (v5.zx) * (c4.xy) + (c4.yx);
            r2 = (r2) * (c4.xxxy);
            r3 = (r2) + (c4.zzyy);
            r3 = tex2Dlod(s1, r3);
            r4 = (r2) + (-(c4.zzyy));
            r4 = tex2Dlod(s1, r4);
            r5 = (r2) + (c1.xyzz);
            r5 = tex2Dlod(s1, r5);
            r2 = (r2) + (-(c1.xyzz));
            r2 = tex2Dlod(s1, r2);
            r3.y = r4.x;
            r3.z = r5.x;
            r3.w = r2.x;
            r2.x = dot(r3, c4.wwww);
            r2.y = (v5.w) * (c3.x) + (c3.y);
            r3.x = lerp(r0.w, r2.x, r2.y);
            r0.w = r3.x;
        }
    }
    else
    {
        r2.x = (c3.z) + (v5.w);
        r2.x = ((r2.x) >= 0.0f ? (c4.y) : (c4.x));
        if ((r2.x) != (-(r2.x)))
        {
            r2.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
            r2.zw = (v5.zz) * (c4.xy) + (c4.yx);
            r2 = (r2) * (c4.xxxy);
            r3 = (r2) + (c4.zzyy);
            r3 = tex2Dlod(s1, r3);
            r4 = (r2) + (-(c4.zzyy));
            r4 = tex2Dlod(s1, r4);
            r5 = (r2) + (c1.xyzz);
            r5 = tex2Dlod(s1, r5);
            r2 = (r2) + (-(c1.xyzz));
            r2 = tex2Dlod(s1, r2);
            r3.y = r4.x;
            r3.z = r5.x;
            r3.w = r2.x;
            r2.x = dot(r3, c4.wwww);
            r2.y = saturate((c3.y) + (v5.w));
            r0.w = lerp(r2.x, r1.w, r2.y);
        }
        else
        {
            r0.w = r1.w;
        }
    }
    r2.xyz = (r0.www) * (c[18].xyz);
    r3.xyz = (r0.www) * (c[19].xyz);
    r4.xyz = normalize(c[17].xyz);
    r2.xyz = (r2.xyz) * (c[21].xxx);
    r0.w = saturate(dot(r0.xyz, r4.xyz));
    r2.xyz = (r2.xyz) * (r0.www);
    r3.xyz = (r3.xyz) * (c[21].yyy);
    r5 = tex2D(s7, v3.xy);
    r1.w = (r5.x) * (r5.x);
    r2.w = max(c3.w, r1.w);
    r1.w = dot(-(v1.xyz), -(v1.xyz));
    r1.w = rsqrt(r1.w);
    r5.xyz = (r1.www) * (-(v1.xyz));
    r3.w = saturate(dot(r0.xyz, r5.xyz));
    r2.w = (r2.w) * (r2.w);
    r2.w = 1.0f / (r2.w);
    r4.xyz = (-(v1.xyz)) * (r1.www) + (r4.xyz);
    r5.xyz = normalize(r4.xyz);
    r1.w = saturate(dot(r0.xyz, r5.xyz));
    r4.x = (r1.w) * (r1.w) + (c12.x);
    r4.x = 1.0f / (r4.x);
    r4.y = (-(r4.x)) + (c4.x);
    r4.y = (r2.w) * (r4.y);
    r4.y = (r4.y) * (c12.y);
    r4.y = exp2(r4.y);
    r4.x = (r4.x) * (r4.x);
    r4.x = (r4.y) * (r4.x);
    r1.w = (r1.w) + (r1.w);
    r4.y = 1.0f / (r3.w);
    r1.w = (r1.w) * (r4.y);
    r4.y = min(r3.w, r0.w);
    r1.w = saturate((r1.w) * (r4.y));
    r0.w = (r0.w) * (r1.w);
    r0.w = rsqrt(r0.w);
    r0.w = 1.0f / (r0.w);
    r0.w = (r4.x) * (r0.w);
    r3.xyz = (r3.xyz) * (r0.www);
    r0.w = max(c12.z, r3.w);
    r0.w = 1.0f / (r0.w);
    r0.w = rsqrt(r0.w);
    r0.w = 1.0f / (r0.w);
    r3.xyz = (r3.xyz) * (r0.www);
    r3.xyz = (r2.www) * (r3.xyz);
    r3.xyz = (r3.xyz) * (c4.www);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r4 = tex2D(s6, v3.xy);
    r5 = (r4) * (r4);
    r4.xy = lerp(c[23].xy, c[23].zw, v3.xy);
    r6 = tex2D(s2, r4.xy);
    r7 = tex2D(s3, r4.xy);
    r8 = tex2D(s4, r4.xy);
    r6.xw = (r6.xx) * (c4.xy) + (c4.yx);
    r6.y = r7.x;
    r4.x = dot(c0.xyz, r6.xyw);
    r6.z = r8.x;
    r4.y = dot(c13, r6);
    r4.z = dot(c14.xyz, r6.xzw);
    r4.xyz = (r4.xyz) * (r4.xyz);
    r4.xyz = (r4.xyz) * (c[25].xxx);
    r6.xyz = (r4.xyz) * (c12.www) + (-(r5.xyz));
    r6.w = (r4.w) * (-(r4.w)) + (c[26].x);
    r4 = (c[22].xxxx) * (r6) + (r5);
    r5 = tex2D(s5, v3.xy);
    r5.xyz = (r5.xyz) * (r5.xyz);
    r1.xyz = (r1.xyz) * (c0.www) + (r2.xyz);
    r2.xyz = (r3.xyz) * (r5.xyz);
    r2.xyz = (r4.www) * (r2.xyz);
    r4.xyz = (r1.xyz) * (r4.xyz) + (r2.xyz);
    r1 = max(r4, c4.yyyy);
    r2 = (c[6]) + (-(v1.xxxx));
    r3 = (c[7]) + (-(v1.yyyy));
    r4 = (c[8]) + (-(v1.zzzz));
    r5 = (r3) * (r3);
    r5 = (r2) * (r2) + (r5);
    r5 = (r4) * (r4) + (r5);
    r6.x = rsqrt(r5.x);
    r6.y = rsqrt(r5.y);
    r6.z = rsqrt(r5.z);
    r6.w = rsqrt(r5.w);
    r2 = (r2) * (r6);
    r3 = (r3) * (r6);
    r4 = (r4) * (r6);
    r6.x = c4.x;
    r5 = saturate((r5) * (c[9]) + (r6.xxxx));
    r3 = (r0.yyyy) * (r3);
    r2 = (r2) * (r0.xxxx) + (r3);
    r0 = saturate((r4) * (r0.zzzz) + (r2));
    r0 = (r5) * (r0);
    r2.x = dot(c[10], r0);
    r2.y = dot(c[11], r0);
    r2.z = dot(c[20], r0);
    r0.xyz = (r1.xyz) * (r2.xyz) + (r1.xyz);
    r0.w = v1.w;
    r1.xyz = lerp(v0.xyz, r0.xyz, r0.www);
    r0.xyz = max(((r1.xyz) * (c[24].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = r1.w;

    return oC0;
}
