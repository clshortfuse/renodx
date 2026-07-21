// Mechanically reconstructed from 0x3C3D33C1.ps_3_0.cso.
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
sampler2D s12 : register(s12);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD3;
    float4 v4 : TEXCOORD4;
    float4 v5 : TEXCOORD6;
    float4 v6 : TEXCOORD7;
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
    const float4 c0 = float4(0.0f, 0.25f, 1.0f, 0.5f);
    const float4 c1 = float4(2.0f, -1.0f, 8.0f, 31.875f);
    const float4 c3 = float4(4.0f, -3.0f, -4.0f, 7.0f);
    const float4 c4 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c12 = float4(-2.0f, 3.0f, 0.000244140625f, 0.0f);
    const float4 c13 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c14 = float4(0.200000003f, 4.0f, -2.0f, 0.142857f);
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
    float4 oC0 = 0.0f;

    r0.x = dot(v2.xyz, v2.xyz);
    r0.x = rsqrt(r0.x);
    r0.yzw = (r0.xxx) * (v2.xyz);
    r1.xyz = (r0.wyz) * (v3.yzx);
    r0.yzw = (r0.zwy) * (v3.zxy) + (-(r1.xyz));
    r0.yzw = (r0.yzw) * (v3.www);
    r1 = (c[24]) * (v1.yyyy);
    r1 = (v1.xxxx) * (c[23]) + (r1);
    r1 = (v1.zzzz) * (c[25]) + (r1);
    r1 = (r1) + (c[26]);
    r2.xy = (r1.ww) * (c[28].xy);
    r2.zw = c0.xx;
    r3 = (r1) + (r2.xyww);
    r3 = tex2Dproj(s2, r3);
    r2 = (r1) + (-(r2));
    r2 = tex2Dproj(s2, r2);
    r4.xy = (r1.ww) * (c[28].zw);
    r4.zw = c0.xx;
    r5 = (r1) + (r4.xyww);
    r5 = tex2Dproj(s2, r5);
    r1 = (r1) + (-(r4));
    r1 = tex2Dproj(s2, r1);
    r3.y = r2.x;
    r3.z = r5.x;
    r3.w = r1.x;
    r1.x = dot(r3, c0.yyyy);
    r1.yzw = (c[5].xyz) + (-(v1.xyz));
    r2.xyz = normalize(r1.yzw);
    r3 = (v1.xyzx) * (c0.zzzx) + (c0.xxxz);
    r1.y = dot(r3, c[9]);
    r1.z = dot(r3, c[10]);
    r4.x = dot(r3, c[11]);
    r1.w = dot(r3, c[20]);
    r4.y = (r4.x) * (r4.x);
    r2.w = dot(c[7].yz, r4.xy) + (c[7].x);
    r3.x = saturate(1.0f / (r2.w));
    r2.w = ((-abs(r2.w)) >= 0.0f ? (c0.x) : (r3.x));
    r3.xy = saturate((r4.xx) * (c[8].xy) + (c[8].zw));
    r3.zw = (r3.xy) * (r3.xy);
    r3.xy = (r3.xy) * (c12.xx) + (c12.yy);
    r3.x = (r3.z) * (r3.x);
    r2.w = (r2.w) * (r3.x);
    r3.x = (r3.w) * (-(r3.y)) + (c0.z);
    r2.w = (r2.w) * (r3.x);
    r3.x = dot(r2.xyz, c[21].xyz);
    r3.x = saturate((r3.x) * (c[22].x) + (c[22].y));
    r3.y = (r3.x) * (r3.x);
    r3.x = (r3.x) * (c12.x) + (c12.y);
    r3.x = (r3.y) * (r3.x);
    r2.w = (r2.w) * (r3.x);
    r1.w = 1.0f / (r1.w);
    r1.yz = (r1.yz) * (r1.ww);
    r1.yz = (r1.yz) * (c0.ww) + (c0.ww);
    r3 = tex2D(s3, r1.yz);
    r1.y = (r3.x) * (r3.x);
    r1.y = (r2.w) * (r1.y);
    r1.x = (r1.x) * (r1.y);
    r1.xyz = (r1.xxx) * (c[6].xyz);
    if ((c0.z) >= (v5.w))
    {
        r3 = (v5.xyzx) * (c0.zzzx) + (c0.xxxz);
        r3 = (r3) * (c0.zzzx);
        r4 = (r3) + (c12.zzww);
        r4 = tex2Dlod(s1, r4);
        r5 = (r3) + (-(c12.zzww));
        r5 = tex2Dlod(s1, r5);
        r6 = (r3) + (c4.xyzz);
        r6 = tex2Dlod(s1, r6);
        r3 = (r3) + (-(c4.xyzz));
        r3 = tex2Dlod(s1, r3);
        r4.y = r5.x;
        r4.z = r6.x;
        r4.w = r3.x;
        r1.w = dot(r4, c0.yyyy);
        if ((c4.w) < (v5.w))
        {
            r3.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
            r3.zw = (v5.zx) * (c0.zx) + (c0.xz);
            r3 = (r3) * (c0.zzzx);
            r4 = (r3) + (c12.zzww);
            r4 = tex2Dlod(s1, r4);
            r5 = (r3) + (-(c12.zzww));
            r5 = tex2Dlod(s1, r5);
            r6 = (r3) + (c4.xyzz);
            r6 = tex2Dlod(s1, r6);
            r3 = (r3) + (-(c4.xyzz));
            r3 = tex2Dlod(s1, r3);
            r4.y = r5.x;
            r4.z = r6.x;
            r4.w = r3.x;
            r2.w = dot(r4, c0.yyyy);
            r3.x = (v5.w) * (c3.x) + (c3.y);
            r4.x = lerp(r1.w, r2.w, r3.x);
            r1.w = r4.x;
        }
    }
    else
    {
        r3 = tex2D(s12, v4.zw);
        r2.w = (c3.z) + (v5.w);
        r2.w = ((r2.w) >= 0.0f ? (c0.x) : (c0.z));
        if ((r2.w) != (-(r2.w)))
        {
            r4.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
            r4.zw = (v5.zz) * (c0.zx) + (c0.xz);
            r4 = (r4) * (c0.zzzx);
            r5 = (r4) + (c12.zzww);
            r5 = tex2Dlod(s1, r5);
            r6 = (r4) + (-(c12.zzww));
            r6 = tex2Dlod(s1, r6);
            r7 = (r4) + (c4.xyzz);
            r7 = tex2Dlod(s1, r7);
            r4 = (r4) + (-(c4.xyzz));
            r4 = tex2Dlod(s1, r4);
            r5.y = r6.x;
            r5.z = r7.x;
            r5.w = r4.x;
            r2.w = dot(r5, c0.yyyy);
            r3.x = saturate((-(c12.y)) + (v5.w));
            r1.w = lerp(r2.w, r3.y, r3.x);
        }
        else
        {
            r1.w = r3.y;
        }
    }
    r3.xyz = (r1.www) * (c[18].xyz);
    r4.xyz = normalize(c[17].xyz);
    r1.w = c[29].w;
    r5.xy = (r1.ww) * (c[35].xy);
    r5.xy = (r5.xy) * (c[34].xx);
    r5.xy = (v4.xy) * (c[34].xx) + (r5.xy);
    r5 = tex2D(s9, r5.xy);
    r5.xyz = (r5.xyz) * (r5.xyz);
    r5.xyz = (r5.xyz) * (v6.xxx);
    r5.xyz = (r5.xyz) * (c3.www);
    r6.xy = (r1.ww) * (c[36].xy);
    r6.xy = (r6.xy) * (c[37].xx);
    r6.xy = (v4.xy) * (c[37].xx) + (r6.xy);
    r6 = tex2D(s8, r6.xy);
    r7.xyz = (r5.xyz) * (r6.xyz);
    r8 = tex2D(s5, v4.xy);
    r8.xy = (r8.wy) * (c13.xy) + (c13.zw);
    r8.xy = (r8.xy) * (c0.ww) + (c0.ww);
    r8.xy = (r8.xy) * (c1.xx) + (c1.yy);
    r8.yzw = (r0.yzw) * (r8.yyy);
    r8.xyz = (r8.xxx) * (v3.xyz) + (r8.yzw);
    r8.xyz = (v2.xyz) * (r0.xxx) + (r8.xyz);
    r0.x = dot(r8.xyz, r8.xyz);
    r0.x = rsqrt(r0.x);
    r9.xyz = (r8.xyz) * (r0.xxx);
    r3.xyz = (r3.xyz) * (c[27].xxx);
    r1.w = saturate(dot(r9.xyz, r4.xyz));
    r2.x = saturate(dot(r9.xyz, r2.xyz));
    r1.xyz = (r1.xyz) * (r2.xxx);
    r1.xyz = (r1.www) * (r3.xyz) + (r1.xyz);
    r2.xyz = normalize(v1.xyz);
    r1.w = dot(r2.xyz, r9.xyz);
    r1.w = (r1.w) + (r1.w);
    r2.xyz = (r9.xyz) * (-(r1.www)) + (r2.xyz);
    r2.w = c1.z;
    r2 = texCUBElod(s15, r2);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r2.xyz = (r2.xyz) * (c1.zzz);
    r3 = tex2D(s14, v4.zw);
    r3.zw = (c0.zw) * (v4.zw);
    r4 = tex2D(s13, r3.zw);
    r3.zw = (r3.xy) * (c1.ww);
    r4.xw = (r4.xz) * (r3.zz);
    r10.xz = (r4.xw) * (c3.xx);
    r1.w = (r3.x) * (c1.w) + (-(r4.x));
    r1.w = (r4.z) * (-(r3.z)) + (r1.w);
    r10.y = (r1.w) + (r1.w);
    r2.xyz = (r2.xyz) * (r10.xyz);
    r2.xyz = (r2.xyz) * (c14.xxx);
    r11.xyz = normalize(v3.xyz);
    r12.xyz = normalize(r0.yzw);
    r0.yz = (v4.zw) * (c0.zw) + (c0.xw);
    r13 = tex2D(s13, r0.yz);
    r0.yz = (r3.ww) * (r13.xz);
    r4.xw = (r0.yz) * (c3.xx);
    r0.y = (r3.y) * (c1.w) + (-(r0.y));
    r0.y = (r13.z) * (-(r3.w)) + (r0.y);
    r4.z = (r0.y) + (r0.y);
    r13.x = r4.y;
    r0.yz = (r13.xy) * (c14.yy) + (c14.zz);
    r3.xyz = (r12.xyz) * (r0.zzz);
    r0.yzw = (r0.yyy) * (r11.xyz) + (r3.xyz);
    r0.xyz = (r8.xyz) * (r0.xxx) + (r0.yzw);
    r3.xyz = normalize(r0.xyz);
    r0.x = dot(r3.xyz, r9.xyz);
    r0.xyz = (r0.xxx) * (r4.xzw) + (r10.xyz);
    r3 = tex2D(s7, v4.xy);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r4 = tex2D(s6, v4.xy);
    r4.xyz = (r4.xyz) * (r4.xyz);
    r0.xyz = (r1.xyz) * (c14.www) + (r0.xyz);
    r1.xyz = (r2.xyz) * (r4.xyz);
    r0.xyz = (r0.xyz) * (r3.xyz) + (r1.xyz);
    r1.xyz = max(r0.xyz, c0.xxx);
    r0 = tex2D(s4, v4.xy);
    r0.x = (-(r0.x)) + (c0.z);
    r0.yzw = (r5.xyz) * (-(r6.xyz)) + (r1.xyz);
    r0.xyz = (r0.xxx) * (r0.yzw) + (r7.xyz);
    r0.w = c0.z;
    r1.x = dot(r0, c[31]);
    r1.y = dot(r0, c[32]);
    r1.z = dot(r0, c[33]);
    r0.w = v1.w;
    r2.xyz = lerp(v0.xyz, r1.xyz, r0.www);
    r0.xyz = max(((r2.xyz) * (c[30].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.z;

    return oC0;
}
