// Mechanically reconstructed from 0x840DEB26.ps_3_0.cso.
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
sampler2D s6 : register(s6);
sampler3D s11 : register(s11);
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
    const float4 c0 = float4(-0.5f, 0.5f, 1.10000002f, 10.0f);
    const float4 c1 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c3 = float4(1.0f, 0.0f, 8.0f, 31.875f);
    const float4 c4 = float4(0.797884583f, 1.0f, 0.0009765625f, 0.25f);
    const float4 c12 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c13 = float4(0.125f, 0.25f, 0.000244140625f, 0.0f);
    const float4 c14 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c15 = float4(4.0f, -3.0f, -4.0f, 0.0f);
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
    float4 r13 = 0.0f;
    float4 r14 = 0.0f;
    float4 oC0 = 0.0f;

    r0.w = dot(v7.xyz, v7.xyz);
    r1.w = rsqrt(r0.w);
    r0.xyz = (v7.xyz) * (-(r1.www)) + (c[17].xyz);
    r1.xyz = normalize(r0.xyz);
    r4.w = saturate(dot(r1.xyz, c[17].xyz));
    r0.xy = (v1.xy) + (c0.xx);
    r0.z = c0.y;
    r2.xy = (r0.xy) * (c[21].xx) + (r0.zz);
    r0.xy = (r0.xy) * (c[20].xx) + (r0.zz);
    r0 = tex2D(s4, r0.xy);
    r7.w = (v8.w) * (c0.z) + (-(r0.x));
    r0 = tex2D(s0, v1.xy);
    r3.w = (r0.w) * (v0.w);
    r0.xyz = (r0.xyz) * (v0.xyz);
    r3.xyz = (r0.xyz) * (r0.xyz);
    r8.w = saturate((r7.w) * (c0.w));
    r2 = tex2D(s5, r2.xy);
    r0 = tex2D(s1, v1.xy);
    r5.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r0 = tex2D(s6, v1.xy);
    r0.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r4.xy = lerp(r5.xy, r0.xy, r8.ww);
    r0.xyz = v2.xyz;
    r0.xyz = (r4.xxx) * (v5.xyz) + (r0.xyz);
    r0.xyz = (r4.yyy) * (v4.xyz) + (r0.xyz);
    r9.xyz = normalize(r0.xyz);
    r0.w = (-(r4.w)) + (c3.x);
    r4.z = saturate(dot(r9.xyz, r1.xyz));
    r0.z = (r0.w) * (r0.w);
    r0.z = (r0.z) * (r0.z);
    r10.xyz = (r1.www) * (v7.xyz);
    r0.y = (r0.w) * (r0.z);
    r9.w = saturate(dot(r9.xyz, -(r10.xyz)));
    r1 = tex2D(s3, v1.xy);
    r7.xyz = (r1.xyz) * (-(r1.xyz)) + (c3.xxx);
    r0.w = (r1.w) * (-(c4.x)) + (c4.y);
    r0.x = (r1.w) * (c4.x);
    r8.xyz = (r1.xyz) * (r1.xyz);
    r0.z = (r9.w) * (r0.w) + (r0.x);
    r14.xy = (r1.ww) * (c12.xy) + (c12.zw);
    r4.w = saturate(dot(r9.xyz, c[17].xyz));
    r1.z = exp2(r14.y);
    r0.w = (r4.w) * (r0.w) + (r0.x);
    r0.x = pow(abs(r4.z), r1.z);
    r0.z = (r0.w) * (r0.z) + (c4.z);
    r0.w = (r1.z) * (c13.x) + (c13.y);
    r0.z = 1.0f / (r0.z);
    r0.w = (r0.x) * (r0.w);
    r0.z = (r4.w) * (r0.z);
    r1.xyz = (r7.xyz) * (r0.yyy) + (r8.xyz);
    r4.z = (r0.w) * (r0.z);
    r0 = lerp(r3, r2, r8.wwww);
    r1.xyz = (r1.xyz) * (r4.zzz);
    r2.xyz = (r1.xyz) * (c[7].www);
    r2.w = max(abs(r9.y), abs(r9.z));
    r4.xy = c[6].xy;
    r3.xyz = (r4.yyy) * (c[19].xyz);
    r1.z = max(abs(r9.x), r2.w);
    r2.w = 1.0f / (r1.z);
    r1.xyz = (r9.xyz) * (c[5].xyz);
    r11.xyz = (r2.xyz) * (r3.xyz);
    r1.xyz = (r1.xyz) * (r2.www) + (v8.xyz);
    r2 = tex3D(s11, r1.xyz);
    r1.xyz = (r2.xyz) * (r2.xyz);
    r2.xyz = (r4.xxx) * (c[18].xyz);
    r1.xyz = (r1.xyz) * (c[7].yyy);
    r12.xyz = (r4.www) * (r2.xyz);
    r13.xyz = (r1.xyz) * (c3.www);
    if ((c3.x) >= (v6.w))
    {
        r3 = (v6.xyzx) * (c3.xxxy);
        r2 = (r3) + (-(c14.xyzz));
        r2 = tex2Dlod(s2, r2);
        r2.w = r2.x;
        r4 = (r3) + (c13.zzww);
        r4 = tex2Dlod(s2, r4);
        r2.x = r4.x;
        r4 = (r3) + (-(c13.zzww));
        r4 = tex2Dlod(s2, r4);
        r2.y = r4.x;
        r3 = (r3) + (c14.xyzz);
        r3 = tex2Dlod(s2, r3);
        r2.z = r3.x;
        r1.z = dot(r2, c4.wwww);
        if ((c14.w) < (v6.w))
        {
            r1.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r2.xy = (r1.xy) + (c13.zz);
            r2.zw = (v6.zx) * (c3.xy);
            r2 = tex2Dlod(s2, r2);
            r3.xy = (r1.xy) + (-(c13.zz));
            r3.zw = (v6.zx) * (c3.xy);
            r5 = tex2Dlod(s2, r3);
            r3.xy = (r1.xy) + (c14.xy);
            r3.zw = (v6.zx) * (c3.xy);
            r4 = tex2Dlod(s2, r3);
            r3.xy = (r1.xy) + (-(c14.xy));
            r3.zw = (v6.zx) * (c3.xy);
            r3 = tex2Dlod(s2, r3);
            r2.y = r5.x;
            r2.z = r4.x;
            r2.w = r3.x;
            r1.y = dot(r2, c4.wwww);
            r1.x = (-(r1.z)) + (r1.y);
            r1.y = (v6.w) * (c15.x) + (c15.y);
            r2.w = (r1.y) * (r1.x) + (r1.z);
        }
        else
        {
            r2.w = r1.z;
        }
    }
    else
    {
        r1.z = (v6.w) + (c15.z);
        r1.z = ((r1.z) >= 0.0f ? (c3.y) : (c3.x));
        if ((r1.z) != (-(r1.z)))
        {
            r1.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r3.xy = (r1.xy) + (c13.zz);
            r3.zw = (v6.zz) * (c3.xy);
            r3 = tex2Dlod(s2, r3);
            r4.xy = (r1.xy) + (-(c13.zz));
            r4.zw = (v6.zz) * (c3.xy);
            r6 = tex2Dlod(s2, r4);
            r4.xy = (r1.xy) + (c14.xy);
            r4.zw = (v6.zz) * (c3.xy);
            r5 = tex2Dlod(s2, r4);
            r4.xy = (r1.xy) + (-(c14.xy));
            r4.zw = (v6.zz) * (c3.xy);
            r4 = tex2Dlod(s2, r4);
            r3.y = r6.x;
            r3.z = r5.x;
            r3.w = r4.x;
            r1.x = dot(r3, c4.wwww);
            r1.z = saturate((v6.w) + (c15.y));
            r1.y = (r2.w) + (-(r1.x));
            r1.z = (r1.z) * (r1.y) + (r1.x);
        }
        else
        {
            r1.z = r2.w;
        }
        r2.w = r1.z;
    }
    r1.xyz = (r2.www) * (r12.xyz) + (r13.xyz);
    r2.xyz = (r11.xyz) * (r2.www);
    r2.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
    r3.w = 1.0f / (r14.x);
    r2.w = (-(r9.w)) + (c3.x);
    r0.z = dot(r10.xyz, r9.xyz);
    r3.z = (r2.w) * (r2.w);
    r0.z = (r0.z) + (r0.z);
    r1.w = (r1.w) * (c3.z);
    r1.xyz = (r9.xyz) * (-(r0.zzz)) + (r10.xyz);
    r1 = texCUBElod(s15, r1);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r2.w = (r2.w) * (r3.z);
    r3.xyz = (r0.xyz) * (c3.zzz);
    r1 = tex3D(s11, v8.xyz);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r1.z = (r3.w) * (r2.w);
    r0.xyz = (r3.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c3.www);
    r1.w = (-(r8.w)) + (c3.x);
    r1.xyz = (r7.xyz) * (r1.zzz) + (r8.xyz);
    r1.w = ((r7.w) >= 0.0f ? (r1.w) : (c3.y));
    r0.xyz = (r0.xyz) * (r1.xyz);
    r1.w = (r1.w) * (r1.w);
    r0.xyz = (r0.xyz) * (c[7].xxx) + (r2.xyz);
    r1.w = (r1.w) * (c[22].w);
    r0.xyz = (c[22].xyz) * (r1.www) + (r0.xyz);
    r1.xyz = (r0.www) * (r0.xyz);
    r1.w = c3.x;
    r0.z = dot(r1, c[11]);
    r0.x = dot(r1, c[9]);
    r0.y = dot(r1, c[10]);
    r0.xyz = (v3.xyz) * (-(r0.www)) + (r0.xyz);
    r0.xyz = (r0.xyz) * (v2.www);
    r0.xyz = (v3.xyz) * (r0.www) + (r0.xyz);
    r0.xyz = max(((r0.xyz) * (c[8].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
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
