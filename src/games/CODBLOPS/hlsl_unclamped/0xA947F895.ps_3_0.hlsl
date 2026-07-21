// Mechanically reconstructed from 0xA947F895.ps_3_0.cso.
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
sampler2D s8 : register(s8);
sampler2D s9 : register(s9);
sampler2D s10 : register(s10);
sampler3D s11 : register(s11);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD3;
    float4 v4 : TEXCOORD4;
    float4 v5 : TEXCOORD5;
    float4 v6 : TEXCOORD6;
    float4 v7 : TEXCOORD7;
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
    const float4 c0 = float4(2.0f, -1.0f, 31.875f, 8.0f);
    const float4 c1 = float4(0.0f, 0.25f, 1.0f, 0.5f);
    const float4 c3 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c4 = float4(4.0f, -3.0f, -4.0f, 0.0357140005f);
    const float4 c12 = float4(-2.0f, 3.0f, 0.000244140625f, 0.0f);
    const float4 c13 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c14 = float4(10.0f, 0.107143f, 0.0f, 0.0f);
    const float4 c15 = float4(3.0f, -3.0f, 6.0f, 1.25f);
    const float4 c16 = float4(0.0199999996f, 3.33333325f, -0.600000024f, -0.800000012f);
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
    r3 = (c[25]) * (v1.yyyy);
    r3 = (v1.xxxx) * (c[24]) + (r3);
    r3 = (v1.zzzz) * (c[26]) + (r3);
    r3 = (r3) + (c[27]);
    r4.xy = (r3.ww) * (c[29].xy);
    r4.zw = c1.xx;
    r5 = (r3) + (r4.xyww);
    r5 = tex2Dproj(s2, r5);
    r4 = (r3) + (-(r4));
    r4 = tex2Dproj(s2, r4);
    r6.xy = (r3.ww) * (c[29].zw);
    r6.zw = c1.xx;
    r7 = (r3) + (r6.xyww);
    r7 = tex2Dproj(s2, r7);
    r3 = (r3) + (-(r6));
    r3 = tex2Dproj(s2, r3);
    r5.y = r4.x;
    r5.z = r7.x;
    r5.w = r3.x;
    r0.y = dot(r5, c1.yyyy);
    r2.xyz = (c[6].xyz) + (-(v1.xyz));
    r3.xyz = normalize(r2.xyz);
    r4 = (v1.xyzx) * (c1.zzzx) + (c1.xxxz);
    r0.z = dot(r4, c[10]);
    r0.w = dot(r4, c[11]);
    r2.x = dot(r4, c[20]);
    r1.w = dot(r4, c[21]);
    r2.y = (r2.x) * (r2.x);
    r2.y = dot(c[8].yz, r2.xy) + (c[8].x);
    r2.z = saturate(1.0f / (r2.y));
    r2.y = ((-abs(r2.y)) >= 0.0f ? (c1.x) : (r2.z));
    r2.xz = saturate((r2.xx) * (c[9].xy) + (c[9].zw));
    r4.xy = (r2.xz) * (r2.xz);
    r2.xz = (r2.xz) * (c12.xx) + (c12.yy);
    r2.x = (r4.x) * (r2.x);
    r2.x = (r2.y) * (r2.x);
    r2.y = (r4.y) * (-(r2.z)) + (c1.z);
    r2.x = (r2.x) * (r2.y);
    r2.y = dot(r3.xyz, c[22].xyz);
    r2.y = saturate((r2.y) * (c[23].x) + (c[23].y));
    r2.z = (r2.y) * (r2.y);
    r2.y = (r2.y) * (c12.x) + (c12.y);
    r2.y = (r2.z) * (r2.y);
    r2.x = (r2.x) * (r2.y);
    r1.w = 1.0f / (r1.w);
    r0.zw = (r0.zw) * (r1.ww);
    r0.zw = (r0.zw) * (c1.ww) + (c1.ww);
    r4 = tex2D(s3, r0.zw);
    r0.z = (r4.x) * (r4.x);
    r0.z = (r2.x) * (r0.z);
    r0.y = (r0.y) * (r0.z);
    r0.yzw = (r0.yyy) * (c[7].xyz);
    if ((c1.z) >= (v6.w))
    {
        r4 = (v6.xyzx) * (c1.zzzx) + (c1.xxxz);
        r4 = (r4) * (c1.zzzx);
        r5 = (r4) + (c12.zzww);
        r5 = tex2Dlod(s1, r5);
        r6 = (r4) + (-(c12.zzww));
        r6 = tex2Dlod(s1, r6);
        r7 = (r4) + (c3.xyzz);
        r7 = tex2Dlod(s1, r7);
        r4 = (r4) + (-(c3.xyzz));
        r4 = tex2Dlod(s1, r4);
        r5.y = r6.x;
        r5.z = r7.x;
        r5.w = r4.x;
        r1.w = dot(r5, c1.yyyy);
        if ((c3.w) < (v6.w))
        {
            r4.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r4.zw = (v6.zx) * (c1.zx) + (c1.xz);
            r4 = (r4) * (c1.zzzx);
            r5 = (r4) + (c12.zzww);
            r5 = tex2Dlod(s1, r5);
            r6 = (r4) + (-(c12.zzww));
            r6 = tex2Dlod(s1, r6);
            r7 = (r4) + (c3.xyzz);
            r7 = tex2Dlod(s1, r7);
            r4 = (r4) + (-(c3.xyzz));
            r4 = tex2Dlod(s1, r4);
            r5.y = r6.x;
            r5.z = r7.x;
            r5.w = r4.x;
            r2.x = dot(r5, c1.yyyy);
            r2.y = (v6.w) * (c4.x) + (c4.y);
            r3.w = lerp(r1.w, r2.x, r2.y);
            r1.w = r3.w;
        }
    }
    else
    {
        r2.x = (c4.z) + (v6.w);
        r2.x = ((r2.x) >= 0.0f ? (c1.x) : (c1.z));
        if ((r2.x) != (-(r2.x)))
        {
            r4.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r4.zw = (v6.zz) * (c1.zx) + (c1.xz);
            r4 = (r4) * (c1.zzzx);
            r5 = (r4) + (c12.zzww);
            r5 = tex2Dlod(s1, r5);
            r6 = (r4) + (-(c12.zzww));
            r6 = tex2Dlod(s1, r6);
            r7 = (r4) + (c3.xyzz);
            r7 = tex2Dlod(s1, r7);
            r4 = (r4) + (-(c3.xyzz));
            r4 = tex2Dlod(s1, r4);
            r5.y = r6.x;
            r5.z = r7.x;
            r5.w = r4.x;
            r2.x = dot(r5, c1.yyyy);
            r2.y = saturate((-(c12.y)) + (v6.w));
            r1.w = lerp(r2.x, r2.w, r2.y);
        }
        else
        {
            r1.w = r2.w;
        }
    }
    r2.xyz = (r1.www) * (c[18].xyz);
    r4.xyz = normalize(c[17].xyz);
    r5 = tex2D(s5, v4.xy);
    r5.xy = (r5.wy) * (c13.xy) + (c13.zw);
    r5.xy = (r5.xy) * (c1.ww) + (c1.ww);
    r5.xy = (r5.xy) * (c0.xx) + (c0.yy);
    r6 = tex2D(s4, v4.xy);
    r5.zw = (r6.wy) * (c13.xy) + (c13.zw);
    r5.zw = (r5.zw) * (c1.ww) + (c1.ww);
    r5.zw = (r5.zw) * (c0.xx) + (c0.yy);
    r1.w = saturate((c[36].x) * (v7.z));
    r2.w = (r1.w) * (c[38].x);
    r5.zw = (r5.zw) * (r2.ww);
    r5.xy = (c[37].xx) * (r5.xy) + (r5.zw);
    r1.xyz = (r1.xyz) * (r5.yyy);
    r1.xyz = (r5.xxx) * (v3.xyz) + (r1.xyz);
    r1.xyz = (v2.xyz) * (r0.xxx) + (r1.xyz);
    r5.xyz = normalize(r1.xyz);
    r1.xy = v4.xy;
    r6.xy = (r1.xy) * (c[41].xx) + (v7.xy);
    r6 = tex2D(s10, r6.xy);
    r2.xyz = (r2.xyz) * (c[28].xxx);
    r0.x = saturate(dot(r5.xyz, r4.xyz));
    r1.z = saturate(dot(r5.xyz, r3.xyz));
    r0.yzw = (r0.yzw) * (r1.zzz);
    r0.xyz = (r0.xxx) * (r2.xyz) + (r0.yzw);
    r0.w = max(abs(r5.y), abs(r5.z));
    r1.z = max(abs(r5.x), r0.w);
    r2.xyz = (r5.xyz) * (c[5].xyz);
    r0.w = 1.0f / (r1.z);
    r2.xyz = (r2.xyz) * (r0.www) + (v5.xyz);
    r2 = tex3D(s11, r2.xyz);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r1.xy = (r1.xy) * (c[42].xx) + (v7.xy);
    r3 = tex2D(s10, r1.xy);
    r4 = tex2D(s7, v4.xy);
    r1.xyz = (r4.xyz) * (r4.xyz);
    r3.xzw = (r4.xyz) * (-(r4.xyz)) + (c4.www);
    r3.xyz = (r3.yyy) * (r3.xzw) + (r1.xyz);
    r0.xyz = (r2.xyz) * (c0.zzz) + (r0.xyz);
    r2.xyz = (r3.xyz) * (r0.xyz);
    r3.xyz = max(r2.xyz, c1.xxx);
    r2.xyz = normalize(v1.xyz);
    r0.w = dot(r2.xyz, r5.xyz);
    r0.w = (r0.w) + (r0.w);
    r2.xyz = (r5.xyz) * (-(r0.www)) + (r2.xyz);
    r2.w = c0.w;
    r2 = texCUBElod(s15, r2);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r4.xyz = (r2.xyz) * (c0.www);
    r5 = tex3D(s11, v5.xyz);
    r5.xyz = (r5.xyz) * (r5.xyz);
    r5.xyz = (r5.xyz) * (c0.zzz);
    r4.xyz = (r4.xyz) * (r5.xyz);
    r4.xyz = (r4.xyz) * (c[35].xxx);
    r7 = tex2D(s6, v4.xy);
    r1.xyz = (r1.xyz) * (r0.xyz);
    r4.xyz = (r4.xyz) * (r7.xyz) + (r1.xyz);
    r6.yzw = max(r4.xyz, c1.xxx);
    r0.w = c[30].w;
    r4.xy = (r0.ww) * (c[40].xy);
    r4.xy = (r4.xy) * (c[39].xx);
    r4.xy = (v4.xy) * (c[39].xx) + (r4.xy);
    r4 = tex2D(s9, r4.xy);
    r4.xyz = (r4.xyz) * (r4.xyz);
    r4.xyz = (r4.xyz) * (c[43].xxx);
    r8 = tex2D(s8, v4.xy);
    r8.xyz = saturate((r8.xyz) * (c12.yyy));
    r4.xyz = (r4.xyz) * (r8.xyz);
    r2.xyz = (r2.xyz) * (r5.xyz);
    r2.xyz = (r2.xyz) * (c[35].xxx);
    r2.xyz = (r2.xyz) * (c0.www);
    r1.xyz = (r2.xyz) * (r7.xyz) + (r1.xyz);
    r5.xyz = max(r1.xyz, c1.xxx);
    r0.w = (r6.x) * (c15.x) + (c15.y);
    r1.w = saturate(r1.w);
    r0.w = (r1.w) * (c15.z) + (r0.w);
    r1.x = (-(r0.w)) + (c1.z);
    r1.y = (r1.x) * (c15.w);
    r2.w = min(r1.y, c1.z);
    r1.y = (r2.w) * (r2.w) + (-(c1.z));
    r1.z = ddx(r1.y);
    r1.w = ddy(r1.y);
    r1.y = (r1.y) * (c16.x);
    r2.w = dot(r1.zw, r1.zw) + (c1.x);
    r2.w = rsqrt(r2.w);
    r1.zw = (r1.zw) * (r2.ww);
    r1.yz = (r1.yy) * (r1.zw) + (v4.xy);
    r7 = tex2D(s7, r1.yz);
    r7.xyz = (r7.xyz) * (r7.xyz);
    r8 = tex2D(s6, r1.yz);
    r1.yzw = (r2.xyz) * (r8.xyz);
    r0.xyz = (r0.xyz) * (r7.xyz) + (r1.yzw);
    r1.yzw = max(r0.xyz, c1.xxx);
    r0.x = saturate((r0.w) * (c16.y));
    r0.x = rsqrt(r0.x);
    r0.x = 1.0f / (r0.x);
    r2.xyz = lerp(r1.yzw, r3.xyz, r0.xxx);
    r0.xy = (r0.ww) + (c16.zw);
    r0.xy = saturate((r0.xy) * (c14.xx));
    r0.x = rsqrt(r0.x);
    r0.x = 1.0f / (r0.x);
    r1.yzw = (r6.yzw) * (r4.xyz) + (-(r2.xyz));
    r0.xzw = (r0.xxx) * (r1.yzw) + (r2.xyz);
    r0.y = rsqrt(r0.y);
    r0.y = 1.0f / (r0.y);
    r1.yzw = (r5.xyz) * (c14.yyy) + (-(r0.xzw));
    r0.xyz = (r0.yyy) * (r1.yzw) + (r0.xzw);
    oC0.w = ((r1.x) >= 0.0f ? (c1.z) : (c1.x));
    r0.w = c1.z;
    r1.x = dot(r0, c[32]);
    r1.y = dot(r0, c[33]);
    r1.z = dot(r0, c[34]);
    r0.w = v1.w;
    r2.xyz = lerp(v0.xyz, r1.xyz, r0.www);
    r0.xyz = max(((r2.xyz) * (c[31].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
