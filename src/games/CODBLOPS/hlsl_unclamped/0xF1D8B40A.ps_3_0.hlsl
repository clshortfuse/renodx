// Mechanically reconstructed from 0xF1D8B40A.ps_3_0.cso.
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
sampler3D s11 : register(s11);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD3;
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
    const float4 c0 = float4(0.5f, 2.0f, -1.0f, 31.875f);
    const float4 c1 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.25f);
    const float4 c3 = float4(0.75f, 4.0f, -3.0f, -4.0f);
    const float4 c4 = float4(1.0f, 0.0f, -0.0f, 0.000244140625f);
    const float4 c12 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 oC0 = 0.0f;

    r0.x = dot(v2.xyz, v2.xyz);
    r0.x = rsqrt(r0.x);
    r0.yzw = (r0.xxx) * (v2.xyz);
    r1.xyz = (r0.wyz) * (v3.yzx);
    r1.xyz = (r0.zwy) * (v3.zxy) + (-(r1.xyz));
    r1.xyz = (r1.xyz) * (v3.www);
    r1.w = max(abs(r0.z), abs(r0.w));
    r2.x = max(abs(r0.y), r1.w);
    r2.yzw = (r0.yzw) * (c[5].xyz);
    r1.w = 1.0f / (r2.x);
    r2.xyz = (r2.yzw) * (r1.www) + (v5.xyz);
    r2 = tex3D(s11, r2.xyz);
    if ((c4.x) >= (v6.w))
    {
        r3 = (v6.xyzx) * (c4.xxxy) + (c4.zzzx);
        r3 = (r3) * (c4.xxxy);
        r4 = (r3) + (c4.wwyy);
        r4 = tex2Dlod(s1, r4);
        r5 = (r3) + (-(c4.wwyy));
        r5 = tex2Dlod(s1, r5);
        r6 = (r3) + (c1.xyzz);
        r6 = tex2Dlod(s1, r6);
        r3 = (r3) + (-(c1.xyzz));
        r3 = tex2Dlod(s1, r3);
        r4.y = r5.x;
        r4.z = r6.x;
        r4.w = r3.x;
        r1.w = dot(r4, c1.wwww);
        if ((c3.x) < (v6.w))
        {
            r3.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r3.zw = (v6.zx) * (c4.xy) + (c4.zx);
            r3 = (r3) * (c4.xxxy);
            r4 = (r3) + (c4.wwyy);
            r4 = tex2Dlod(s1, r4);
            r5 = (r3) + (-(c4.wwyy));
            r5 = tex2Dlod(s1, r5);
            r6 = (r3) + (c1.xyzz);
            r6 = tex2Dlod(s1, r6);
            r3 = (r3) + (-(c1.xyzz));
            r3 = tex2Dlod(s1, r3);
            r4.y = r5.x;
            r4.z = r6.x;
            r4.w = r3.x;
            r2.x = dot(r4, c1.wwww);
            r2.y = (v6.w) * (c3.y) + (c3.z);
            r3.x = lerp(r1.w, r2.x, r2.y);
            r1.w = r3.x;
        }
    }
    else
    {
        r2.x = (c3.w) + (v6.w);
        r2.x = ((r2.x) >= 0.0f ? (c4.y) : (c4.x));
        if ((r2.x) != (-(r2.x)))
        {
            r3.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r3.zw = (v6.zz) * (c4.xy) + (c4.zx);
            r3 = (r3) * (c4.xxxy);
            r4 = (r3) + (c4.wwyy);
            r4 = tex2Dlod(s1, r4);
            r5 = (r3) + (-(c4.wwyy));
            r5 = tex2Dlod(s1, r5);
            r6 = (r3) + (c1.xyzz);
            r6 = tex2Dlod(s1, r6);
            r3 = (r3) + (-(c1.xyzz));
            r3 = tex2Dlod(s1, r3);
            r4.y = r5.x;
            r4.z = r6.x;
            r4.w = r3.x;
            r2.x = dot(r4, c1.wwww);
            r2.y = saturate((c3.z) + (v6.w));
            r1.w = lerp(r2.x, r2.w, r2.y);
        }
        else
        {
            r1.w = r2.w;
        }
    }
    r2.xyz = (r1.www) * (c[18].xyz);
    r3.xyz = (r1.www) * (c[19].xyz);
    r4.xyz = normalize(c[17].xyz);
    r5.x = (c[22].w) + (v4.x);
    r5.y = v4.y;
    r5.zw = frac(abs(r5.xy));
    r5.xy = float2(((r5.x) >= 0.0f ? (r5.z) : (-(r5.z))), ((r5.y) >= 0.0f ? (r5.w) : (-(r5.w))));
    r6 = tex2D(s2, r5.xy);
    r5.zw = (r6.wy) * (c12.xy) + (c12.zw);
    r5.zw = (r5.zw) * (c0.xx) + (c0.xx);
    r5.zw = (r5.zw) * (c0.yy) + (c0.zz);
    r5.zw = (r5.zw) + (r5.zw);
    r1.xyz = (r1.xyz) * (r5.www);
    r1.xyz = (r5.zzz) * (v3.xyz) + (r1.xyz);
    r1.xyz = (v2.xyz) * (r0.xxx) + (r1.xyz);
    r6.xyz = normalize(r1.xyz);
    r1.xyz = (r2.xyz) * (c[21].xxx);
    r0.x = saturate(dot(r6.xyz, r4.xyz));
    r1.xyz = (r1.xyz) * (r0.xxx);
    r2.xyz = (r3.xyz) * (c[21].yyy);
    r3.xyz = normalize(v1.xyz);
    r0.x = dot(-(r4.xyz), r6.xyz);
    r0.x = (r0.x) + (r0.x);
    r7.xyz = (r6.xyz) * (-(r0.xxx)) + (-(r4.xyz));
    r0.x = dot(r4.xyz, r3.xyz);
    r0.x = saturate((r0.x) * (c0.x) + (c0.x));
    r4.y = c0.y;
    r1.w = lerp(c[25].x, r4.y, r0.x);
    r0.x = (r0.x) + (c4.x);
    r2.w = saturate(dot(r7.xyz, -(r3.xyz)));
    r3.x = pow(abs(r2.w), r1.w);
    r2.xyz = (r2.xyz) * (r3.xxx);
    r2.xyz = (r0.xxx) * (r2.xyz);
    r2.xyz = (r2.xyz) * (c[24].xxx);
    r0.x = max(abs(r6.y), abs(r6.z));
    r1.w = max(abs(r6.x), r0.x);
    r3.xyz = (r6.xyz) * (c[5].xyz);
    r0.x = 1.0f / (r1.w);
    r3.xyz = (r3.xyz) * (r0.xxx) + (v5.xyz);
    r3 = tex3D(s11, r3.xyz);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r4 = tex2D(s4, r5.xy);
    r4.xyz = (r4.xyz) * (r4.xyz);
    r5 = tex2D(s3, r5.xy);
    r5.xyz = (r5.xyz) * (r5.xyz);
    r1.xyz = (r3.xyz) * (c0.www) + (r1.xyz);
    r2.xyz = (r2.xyz) * (r5.xyz);
    r1.xyz = (r1.xyz) * (r4.xyz) + (r2.xyz);
    r2.xyz = max(r1.xyz, c4.yyy);
    r1 = (c[6]) + (-(v1.xxxx));
    r3 = (c[7]) + (-(v1.yyyy));
    r4 = (c[8]) + (-(v1.zzzz));
    r5 = (r3) * (r3);
    r5 = (r1) * (r1) + (r5);
    r5 = (r4) * (r4) + (r5);
    r6.x = rsqrt(r5.x);
    r6.y = rsqrt(r5.y);
    r6.z = rsqrt(r5.z);
    r6.w = rsqrt(r5.w);
    r1 = (r1) * (r6);
    r3 = (r3) * (r6);
    r4 = (r4) * (r6);
    r0.x = c4.x;
    r5 = saturate((r5) * (c[9]) + (r0.xxxx));
    r3 = (r0.zzzz) * (r3);
    r1 = (r1) * (r0.yyyy) + (r3);
    r0 = saturate((r4) * (r0.wwww) + (r1));
    r0 = (r5) * (r0);
    r1.x = dot(c[10], r0);
    r1.y = dot(c[11], r0);
    r1.z = dot(c[20], r0);
    r0.xyz = (r2.xyz) * (r1.xyz) + (r2.xyz);
    r0.w = v1.w;
    r1.xyz = lerp(v0.xyz, r0.xyz, r0.www);
    r0.xyz = max(((r1.xyz) * (c[23].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c4.x;

    return oC0;
}
