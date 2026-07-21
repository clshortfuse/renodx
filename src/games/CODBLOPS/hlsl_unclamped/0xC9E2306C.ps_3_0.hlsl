// Mechanically reconstructed from 0xC9E2306C.ps_3_0.cso.
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

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD3;
    float4 v4 : TEXCOORD4;
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
    const float4 c0 = float4(0.0f, 0.25f, 1.0f, 0.5f);
    const float4 c1 = float4(2.0f, -1.0f, 1e-15f, 1.44269502f);
    const float4 c3 = float4(-2.0f, 3.0f, 0.000244140625f, 0.0f);
    const float4 c4 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c12 = float4(4.0f, -3.0f, -4.0f, 0.125f);
    const float4 c13 = float4(-0.25f, -0.5f, -0.75f, 9.99999975e-06f);
    const float4 c14 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c15 = float4(0.100000001f, 9.99999997e-07f, 0.0f, 0.0f);
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
    float4 oC0 = 0.0f;

    r0.x = dot(v2.xyz, v2.xyz);
    r0.x = rsqrt(r0.x);
    r0.yzw = (r0.xxx) * (v2.xyz);
    r1.xyz = (r0.wyz) * (v3.yzx);
    r1.xyz = (r0.zwy) * (v3.zxy) + (-(r1.xyz));
    r1.xyz = (r1.xyz) * (v3.www);
    r2 = (c[25]) * (v1.yyyy);
    r2 = (v1.xxxx) * (c[24]) + (r2);
    r2 = (v1.zzzz) * (c[26]) + (r2);
    r2 = (r2) + (c[27]);
    r3.xy = (r2.ww) * (c[29].xy);
    r3.zw = c0.xx;
    r4 = (r2) + (r3.xyww);
    r4 = tex2Dproj(s2, r4);
    r3 = (r2) + (-(r3));
    r3 = tex2Dproj(s2, r3);
    r5.xy = (r2.ww) * (c[29].zw);
    r5.zw = c0.xx;
    r6 = (r2) + (r5.xyww);
    r6 = tex2Dproj(s2, r6);
    r2 = (r2) + (-(r5));
    r2 = tex2Dproj(s2, r2);
    r4.y = r3.x;
    r4.z = r6.x;
    r4.w = r2.x;
    r1.w = dot(r4, c0.yyyy);
    r2.xyz = (c[5].xyz) + (-(v1.xyz));
    r3.xyz = normalize(r2.xyz);
    r2 = (v1.xyzx) * (c0.zzzx) + (c0.xxxz);
    r4.x = dot(r2, c[10]);
    r4.y = dot(r2, c[11]);
    r4.z = dot(r2, c[20]);
    r2.x = dot(r2, c[21]);
    r4.w = (r4.z) * (r4.z);
    r2.y = dot(c[8].yz, r4.zw) + (c[8].x);
    r2.z = saturate(1.0f / (r2.y));
    r2.y = ((-abs(r2.y)) >= 0.0f ? (c0.x) : (r2.z));
    r2.zw = saturate((r4.zz) * (c[9].xy) + (c[9].zw));
    r4.zw = (r2.zw) * (r2.zw);
    r2.zw = (r2.zw) * (c3.xx) + (c3.yy);
    r2.z = (r4.z) * (r2.z);
    r2.y = (r2.y) * (r2.z);
    r2.z = (r4.w) * (-(r2.w)) + (c0.z);
    r2.y = (r2.y) * (r2.z);
    r2.z = dot(r3.xyz, c[22].xyz);
    r2.z = saturate((r2.z) * (c[23].x) + (c[23].y));
    r2.w = (r2.z) * (r2.z);
    r2.z = (r2.z) * (c3.x) + (c3.y);
    r2.z = (r2.w) * (r2.z);
    r2.y = (r2.y) * (r2.z);
    r2.x = 1.0f / (r2.x);
    r2.xz = (r4.xy) * (r2.xx);
    r2.xz = (r2.xz) * (c0.ww) + (c0.ww);
    r4 = tex2D(s3, r2.xz);
    r2.x = (r4.x) * (r4.x);
    r2.x = (r2.y) * (r2.x);
    r1.w = (r1.w) * (r2.x);
    r2.xyz = (r1.www) * (c[6].xyz);
    r4.xyz = (r1.www) * (c[7].xyz);
    if ((c0.z) >= (v5.w))
    {
        r5 = (v5.xyzx) * (c0.zzzx) + (c0.xxxz);
        r5 = (r5) * (c0.zzzx);
        r6 = (r5) + (c3.zzww);
        r6 = tex2Dlod(s1, r6);
        r7 = (r5) + (-(c3.zzww));
        r7 = tex2Dlod(s1, r7);
        r8 = (r5) + (c4.xyzz);
        r8 = tex2Dlod(s1, r8);
        r5 = (r5) + (-(c4.xyzz));
        r5 = tex2Dlod(s1, r5);
        r6.y = r7.x;
        r6.z = r8.x;
        r6.w = r5.x;
        r1.w = dot(r6, c0.yyyy);
        if ((c4.w) < (v5.w))
        {
            r5.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
            r5.zw = (v5.zx) * (c0.zx) + (c0.xz);
            r5 = (r5) * (c0.zzzx);
            r6 = (r5) + (c3.zzww);
            r6 = tex2Dlod(s1, r6);
            r7 = (r5) + (-(c3.zzww));
            r7 = tex2Dlod(s1, r7);
            r8 = (r5) + (c4.xyzz);
            r8 = tex2Dlod(s1, r8);
            r5 = (r5) + (-(c4.xyzz));
            r5 = tex2Dlod(s1, r5);
            r6.y = r7.x;
            r6.z = r8.x;
            r6.w = r5.x;
            r2.w = dot(r6, c0.yyyy);
            r3.w = (v5.w) * (c12.x) + (c12.y);
            r4.w = lerp(r1.w, r2.w, r3.w);
            r1.w = r4.w;
        }
    }
    else
    {
        r2.w = (c12.z) + (v5.w);
        r2.w = ((r2.w) >= 0.0f ? (c0.x) : (c0.z));
        if ((r2.w) != (-(r2.w)))
        {
            r5.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
            r5.zw = (v5.zz) * (c0.zx) + (c0.xz);
            r5 = (r5) * (c0.zzzx);
            r6 = (r5) + (c3.zzww);
            r6 = tex2Dlod(s1, r6);
            r7 = (r5) + (-(c3.zzww));
            r7 = tex2Dlod(s1, r7);
            r8 = (r5) + (c4.xyzz);
            r8 = tex2Dlod(s1, r8);
            r5 = (r5) + (-(c4.xyzz));
            r5 = tex2Dlod(s1, r5);
            r6.y = r7.x;
            r6.z = r8.x;
            r6.w = r5.x;
            r2.w = dot(r6, c0.yyyy);
            r3.w = saturate((-(c3.y)) + (v5.w));
            r1.w = (r3.w) * (-(r2.w)) + (r2.w);
        }
        else
        {
            r1.w = c0.x;
        }
    }
    r5.xyz = (r1.www) * (c[18].xyz);
    r6.xyz = (r1.www) * (c[19].xyz);
    r7.xyz = normalize(c[17].xyz);
    r8.xy = ddx(v4.xy);
    r8.zw = ddy(v4.xy);
    r1.w = (c[30].x) * (v4.x);
    r9.x = c12.x;
    r10.w = (r1.w) * (r9.x) + (c[31].x);
    r9.yzw = (c13.xyz) + (v4.xxx);
    r11.xyz = (r9.yzw) * (c[30].xxx);
    r10.z = (r11.x) * (r9.x) + (c[31].z);
    r12.y = c[30].y;
    r10.xy = (v4.yy) * (r12.yy) + (c[31].yw);
    r11.xy = (r11.yz) * (r9.xx) + (c[32].xz);
    r11.zw = (v4.yy) * (r12.yy) + (c[32].yw);
    r9.xw = float2(((r9.w) >= 0.0f ? (r11.y) : (r11.x)), ((r9.w) >= 0.0f ? (r11.w) : (r11.z)));
    r9.xz = float2(((r9.z) >= 0.0f ? (r9.x) : (r10.z)), ((r9.z) >= 0.0f ? (r9.w) : (r10.y)));
    r9.xy = float2(((r9.y) >= 0.0f ? (r9.x) : (r10.w)), ((r9.y) >= 0.0f ? (r9.z) : (r10.x)));
    r8 = (r8) * (c12.wwww);
    r10 = tex2Dgrad(s5, r9.xy, r8.xy, r8.zw);
    r9.zw = (r10.wy) * (c14.xy) + (c14.zw);
    r9.zw = (r9.zw) * (c0.ww) + (c0.ww);
    r9.zw = (r9.zw) * (c1.xx) + (c1.yy);
    r10.xy = (r9.xy) * (c[38].xx);
    r10 = tex2D(s4, r10.xy);
    r10.xy = (r10.wy) * (c14.xy) + (c14.zw);
    r10.xy = (r10.xy) * (c0.ww) + (c0.ww);
    r9.zw = (r10.xy) * (-(c3.xx)) + (r9.zw);
    r9.zw = (r9.zw) + (-(c0.zz));
    r1.xyz = (r1.xyz) * (r9.www);
    r1.xyz = (r9.zzz) * (v3.xyz) + (r1.xyz);
    r1.xyz = (v2.xyz) * (r0.xxx) + (r1.xyz);
    r10.xyz = normalize(r1.xyz);
    r1.xyz = (r5.xyz) * (c[28].xxx);
    r0.x = saturate(dot(r10.xyz, r7.xyz));
    r1.w = saturate(dot(r10.xyz, r3.xyz));
    r2.xyz = (r2.xyz) * (r1.www);
    r1.xyz = (r0.xxx) * (r1.xyz) + (r2.xyz);
    r2.xyz = (r6.xyz) * (c[28].yyy);
    r2.w = c13.w;
    r3.w = max(r2.w, c[41].x);
    r2.w = dot(-(v1.xyz), -(v1.xyz));
    r2.w = rsqrt(r2.w);
    r5.xyz = (r2.www) * (-(v1.xyz));
    r4.w = saturate(dot(r10.xyz, r5.xyz));
    r3.w = (r3.w) * (r3.w);
    r3.w = 1.0f / (r3.w);
    r6.xyz = (-(v1.xyz)) * (r2.www) + (r7.xyz);
    r7.xyz = normalize(r6.xyz);
    r5.w = saturate(dot(r10.xyz, r7.xyz));
    r6.x = (r5.w) * (r5.w) + (c1.z);
    r6.x = 1.0f / (r6.x);
    r6.y = (-(r6.x)) + (c0.z);
    r6.y = (r3.w) * (r6.y);
    r6.y = (r6.y) * (c1.w);
    r6.y = exp2(r6.y);
    r6.x = (r6.x) * (r6.x);
    r6.x = (r6.y) * (r6.x);
    r5.w = (r5.w) + (r5.w);
    r6.y = 1.0f / (r4.w);
    r5.w = (r5.w) * (r6.y);
    r6.z = min(r4.w, r0.x);
    r5.w = saturate((r5.w) * (r6.z));
    r0.x = (r0.x) * (r5.w);
    r0.x = rsqrt(r0.x);
    r0.x = 1.0f / (r0.x);
    r0.x = (r6.x) * (r0.x);
    r3.xyz = (-(v1.xyz)) * (r2.www) + (r3.xyz);
    r7.xyz = normalize(r3.xyz);
    r2.w = saturate(dot(r10.xyz, r7.xyz));
    r3.x = (r2.w) * (r2.w) + (c1.z);
    r3.x = 1.0f / (r3.x);
    r3.y = (-(r3.x)) + (c0.z);
    r3.y = (r3.w) * (r3.y);
    r3.y = (r3.y) * (c1.w);
    r3.y = exp2(r3.y);
    r3.x = (r3.x) * (r3.x);
    r3.x = (r3.y) * (r3.x);
    r2.w = dot(r6.yy, r2.ww) + (c0.x);
    r3.y = min(r4.w, r1.w);
    r2.w = saturate((r2.w) * (r3.y));
    r1.w = (r1.w) * (r2.w);
    r1.w = rsqrt(r1.w);
    r1.w = 1.0f / (r1.w);
    r1.w = (r3.x) * (r1.w);
    r3.xyz = (r4.xyz) * (r1.www);
    r2.xyz = (r0.xxx) * (r2.xyz) + (r3.xyz);
    r0.x = saturate(dot(r0.yzw, r5.xyz));
    r0.x = (r4.w) + (r0.x);
    r0.x = (r0.x) * (c0.w);
    r1.w = max(c15.x, r0.x);
    r0.x = 1.0f / (r1.w);
    r0.x = rsqrt(r0.x);
    r0.x = 1.0f / (r0.x);
    r0.xyz = (r2.xyz) * (r0.xxx);
    r0.xyz = (r3.www) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c[40].xxx);
    r0.xyz = (r0.xyz) * (c0.yyy) + (c0.zzz);
    r2.x = c0.x;
    r0.w = max(c[39].x, r2.x);
    r0.w = (r0.w) + (-(c0.z));
    r2.x = log2(abs(r0.x));
    r2.y = log2(abs(r0.y));
    r2.z = log2(abs(r0.z));
    r0.xyz = (r0.www) * (r2.xyz);
    r2.x = exp2(r0.x);
    r2.y = exp2(r0.y);
    r2.z = exp2(r0.z);
    r0.xyz = normalize(v1.xyz);
    r0.y = dot(r0.xyz, r10.xyz);
    r0.y = (r0.y) + (r0.y);
    r0.x = (r10.x) * (-(r0.y)) + (r0.x);
    r0.x = (r0.x) * (c[37].x);
    r0.x = (r0.x) * (c15.y);
    r0.xyz = (r2.xyz) * (c[39].yyy) + (r0.xxx);
    r2 = tex2Dgrad(s6, r9.xy, r8.xy, r8.zw);
    r2 = (r2) * (r2);
    r0.xyz = (r0.xyz) * (c[42].xxx);
    r2.xyz = (r1.xyz) * (r2.xyz) + (r0.xyz);
    r0 = max(r2, c0.xxxx);
    r1 = (r0.xyzx) * (c0.zzzx) + (c0.xxxz);
    r0.x = dot(r1, c[34]);
    r0.y = dot(r1, c[35]);
    r0.z = dot(r1, c[36]);
    r1.w = v1.w;
    r2.xyz = lerp(v0.xyz, r0.xyz, r1.www);
    r0.xyz = max(((r2.xyz) * (c[33].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = r0.w;

    return oC0;
}
