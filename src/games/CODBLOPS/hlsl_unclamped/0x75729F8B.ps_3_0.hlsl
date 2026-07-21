// Mechanically reconstructed from 0x75729F8B.ps_3_0.cso.
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
    const float4 c0 = float4(2.0f, -1.0f, 31.875f, 0.0f);
    const float4 c1 = float4(1.0f, 0.0f, 0.000244140625f, 0.25f);
    const float4 c3 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c4 = float4(4.0f, -3.0f, -4.0f, 0.5f);
    const float4 c11 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 oC0 = 0.0f;

    r0.x = dot(v2.xyz, v2.xyz);
    r0.x = rsqrt(r0.x);
    r0.yzw = (r0.xxx) * (v2.xyz);
    r1.xyz = (r0.wyz) * (v3.yzx);
    r1.xyz = (r0.zwy) * (v3.zxy) + (-(r1.xyz));
    r1.xyz = (r1.xyz) * (v3.www);
    r1.w = max(abs(r0.z), abs(r0.w));
    r2.x = max(abs(r0.y), r1.w);
    r0.yzw = (r0.yzw) * (c[5].xyz);
    r1.w = 1.0f / (r2.x);
    r0.yzw = (r0.yzw) * (r1.www) + (v5.xyz);
    r2 = tex3D(s11, r0.yzw);
    if ((c1.x) >= (v6.w))
    {
        r3 = (v6.xyzx) * (c1.xxxy) + (c1.yyyx);
        r3 = (r3) * (c1.xxxy);
        r4 = (r3) + (c1.zzyy);
        r4 = tex2Dlod(s1, r4);
        r5 = (r3) + (-(c1.zzyy));
        r5 = tex2Dlod(s1, r5);
        r6 = (r3) + (c3.xyzz);
        r6 = tex2Dlod(s1, r6);
        r3 = (r3) + (-(c3.xyzz));
        r3 = tex2Dlod(s1, r3);
        r4.y = r5.x;
        r4.z = r6.x;
        r4.w = r3.x;
        r0.y = dot(r4, c1.wwww);
        if ((c3.w) < (v6.w))
        {
            r3.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r3.zw = (v6.zx) * (c1.xy) + (c1.yx);
            r3 = (r3) * (c1.xxxy);
            r4 = (r3) + (c1.zzyy);
            r4 = tex2Dlod(s1, r4);
            r5 = (r3) + (-(c1.zzyy));
            r5 = tex2Dlod(s1, r5);
            r6 = (r3) + (c3.xyzz);
            r6 = tex2Dlod(s1, r6);
            r3 = (r3) + (-(c3.xyzz));
            r3 = tex2Dlod(s1, r3);
            r4.y = r5.x;
            r4.z = r6.x;
            r4.w = r3.x;
            r0.z = dot(r4, c1.wwww);
            r0.w = (v6.w) * (c4.x) + (c4.y);
            r1.w = lerp(r0.y, r0.z, r0.w);
            r0.y = r1.w;
        }
    }
    else
    {
        r0.z = (c4.z) + (v6.w);
        r0.z = ((r0.z) >= 0.0f ? (c1.y) : (c1.x));
        if ((r0.z) != (-(r0.z)))
        {
            r3.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r3.zw = (v6.zz) * (c1.xy) + (c1.yx);
            r3 = (r3) * (c1.xxxy);
            r4 = (r3) + (c1.zzyy);
            r4 = tex2Dlod(s1, r4);
            r5 = (r3) + (-(c1.zzyy));
            r5 = tex2Dlod(s1, r5);
            r6 = (r3) + (c3.xyzz);
            r6 = tex2Dlod(s1, r6);
            r3 = (r3) + (-(c3.xyzz));
            r3 = tex2Dlod(s1, r3);
            r4.y = r5.x;
            r4.z = r6.x;
            r4.w = r3.x;
            r1.w = dot(r4, c1.wwww);
            r2.x = saturate((c4.y) + (v6.w));
            r0.y = lerp(r1.w, r2.w, r2.x);
        }
        else
        {
            r0.y = r2.w;
        }
    }
    r2.xyz = (r0.yyy) * (c[18].xyz);
    r0.yzw = (r0.yyy) * (c[19].xyz);
    r3.xyz = normalize(c[17].xyz);
    r4.x = (c[7].w) + (v4.x);
    r4.y = v4.y;
    r4.zw = frac(abs(r4.xy));
    r4.xy = float2(((r4.x) >= 0.0f ? (r4.z) : (-(r4.z))), ((r4.y) >= 0.0f ? (r4.w) : (-(r4.w))));
    r5 = tex2D(s2, r4.xy);
    r4.zw = (r5.wy) * (c11.xy) + (c11.zw);
    r4.zw = (r4.zw) * (c4.ww) + (c4.ww);
    r4.zw = (r4.zw) * (c0.xx) + (c0.yy);
    r4.zw = (r4.zw) + (r4.zw);
    r1.xyz = (r1.xyz) * (r4.www);
    r1.xyz = (r4.zzz) * (v3.xyz) + (r1.xyz);
    r1.xyz = (v2.xyz) * (r0.xxx) + (r1.xyz);
    r5.xyz = normalize(r1.xyz);
    r1.xyz = (r2.xyz) * (c[6].xxx);
    r0.x = saturate(dot(r5.xyz, r3.xyz));
    r1.xyz = (r1.xyz) * (r0.xxx);
    r0.xyz = (r0.yzw) * (c[6].yyy);
    r2.xyz = normalize(v1.xyz);
    r0.w = dot(-(r3.xyz), r5.xyz);
    r0.w = (r0.w) + (r0.w);
    r6.xyz = (r5.xyz) * (-(r0.www)) + (-(r3.xyz));
    r0.w = dot(r3.xyz, r2.xyz);
    r0.w = saturate((r0.w) * (c4.w) + (c4.w));
    r3.x = c0.x;
    r1.w = lerp(c[10].x, r3.x, r0.w);
    r0.w = (r0.w) + (c1.x);
    r2.x = saturate(dot(r6.xyz, -(r2.xyz)));
    r3.x = pow(abs(r2.x), r1.w);
    r0.xyz = (r0.xyz) * (r3.xxx);
    r0.xyz = (r0.www) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c[9].xxx);
    r0.w = max(abs(r5.y), abs(r5.z));
    r1.w = max(abs(r5.x), r0.w);
    r2.xyz = (r5.xyz) * (c[5].xyz);
    r0.w = 1.0f / (r1.w);
    r2.xyz = (r2.xyz) * (r0.www) + (v5.xyz);
    r2 = tex3D(s11, r2.xyz);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r3 = tex2D(s4, r4.xy);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r4 = tex2D(s3, r4.xy);
    r4.xyz = (r4.xyz) * (r4.xyz);
    r1.xyz = (r2.xyz) * (c0.zzz) + (r1.xyz);
    r0.xyz = (r0.xyz) * (r4.xyz);
    r0.xyz = (r1.xyz) * (r3.xyz) + (r0.xyz);
    r1.xyz = max(r0.xyz, c1.yyy);
    r0.w = v1.w;
    r2.xyz = lerp(v0.xyz, r1.xyz, r0.www);
    r0.xyz = max(((r2.xyz) * (c[8].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c1.x;

    return oC0;
}
