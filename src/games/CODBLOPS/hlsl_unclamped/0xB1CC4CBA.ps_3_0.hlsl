// Mechanically reconstructed from 0xB1CC4CBA.ps_3_0.cso.
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
    const float4 c0 = float4(0.0f, 0.25f, 1.0f, -0.0f);
    const float4 c1 = float4(-2.0f, 3.0f, 0.5f, 0.75f);
    const float4 c3 = float4(4.0f, -3.0f, 2.0f, -1.0f);
    const float4 c4 = float4(0.000244140625f, 0.0f, -0.000244140625f, -0.0f);
    const float4 c12 = float4(0.00048828125f, -0.000122070312f, 0.0f, -4.0f);
    const float4 c13 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c14 = float4(9.99999975e-06f, 1e-15f, 1.44269502f, 0.100000001f);
    const float4 c15 = float4(8.0f, 31.875f, 0.0f, 0.0f);
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
    r3 = (c[26]) * (v1.yyyy);
    r3 = (v1.xxxx) * (c[25]) + (r3);
    r3 = (v1.zzzz) * (c[27]) + (r3);
    r3 = (r3) + (c[28]);
    r4.xy = (r3.ww) * (c[30].xy);
    r4.zw = c0.xx;
    r5 = (r3) + (r4.xyww);
    r5 = tex2Dproj(s2, r5);
    r4 = (r3) + (-(r4));
    r4 = tex2Dproj(s2, r4);
    r6.xy = (r3.ww) * (c[30].zw);
    r6.zw = c0.xx;
    r7 = (r3) + (r6.xyww);
    r7 = tex2Dproj(s2, r7);
    r3 = (r3) + (-(r6));
    r3 = tex2Dproj(s2, r3);
    r5.y = r4.x;
    r5.z = r7.x;
    r5.w = r3.x;
    r1.w = dot(r5, c0.yyyy);
    r2.xyz = (c[6].xyz) + (-(v1.xyz));
    r3.xyz = normalize(r2.xyz);
    r4 = (v1.xyzx) * (c0.zzzx) + (c0.wwwz);
    r2.x = dot(r4, c[11]);
    r2.y = dot(r4, c[20]);
    r5.x = dot(r4, c[21]);
    r2.z = dot(r4, c[22]);
    r5.y = (r5.x) * (r5.x);
    r3.w = dot(c[9].yz, r5.xy) + (c[9].x);
    r4.x = saturate(1.0f / (r3.w));
    r3.w = ((-abs(r3.w)) >= 0.0f ? (c0.x) : (r4.x));
    r4.xy = saturate((r5.xx) * (c[10].xy) + (c[10].zw));
    r4.zw = (r4.xy) * (r4.xy);
    r4.xy = (r4.xy) * (c1.xx) + (c1.yy);
    r4.x = (r4.z) * (r4.x);
    r3.w = (r3.w) * (r4.x);
    r4.x = (r4.w) * (-(r4.y)) + (c0.z);
    r3.w = (r3.w) * (r4.x);
    r4.x = dot(r3.xyz, c[23].xyz);
    r4.x = saturate((r4.x) * (c[24].x) + (c[24].y));
    r4.y = (r4.x) * (r4.x);
    r4.x = (r4.x) * (c1.x) + (c1.y);
    r4.x = (r4.y) * (r4.x);
    r3.w = (r3.w) * (r4.x);
    r2.z = 1.0f / (r2.z);
    r2.xy = (r2.xy) * (r2.zz);
    r2.xy = (r2.xy) * (c1.zz) + (c1.zz);
    r4 = tex2D(s3, r2.xy);
    r2.x = (r4.x) * (r4.x);
    r2.x = (r3.w) * (r2.x);
    r1.w = (r1.w) * (r2.x);
    r2.xyz = (r1.www) * (c[7].xyz);
    r4.xyz = (r1.www) * (c[8].xyz);
    if ((c0.z) >= (v6.w))
    {
        r5 = (v6.xyzx) * (c0.zzzx) + (c0.wwwz);
        r5 = (r5) * (c0.zzzx);
        r6 = (r5) + (c4.xxyy);
        r6 = tex2Dlod(s1, r6);
        r7 = (r5) + (c4.zzww);
        r7 = tex2Dlod(s1, r7);
        r8 = (r5) + (c12.xyzz);
        r8 = tex2Dlod(s1, r8);
        r5 = (r5) + (-(c12.xyzz));
        r5 = tex2Dlod(s1, r5);
        r6.y = r7.x;
        r6.z = r8.x;
        r6.w = r5.x;
        r1.w = dot(r6, c0.yyyy);
        if ((c1.w) < (v6.w))
        {
            r5.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r5.zw = (v6.zx) * (c0.zx) + (c0.wz);
            r5 = (r5) * (c0.zzzx);
            r6 = (r5) + (c4.xxyy);
            r6 = tex2Dlod(s1, r6);
            r7 = (r5) + (c4.zzww);
            r7 = tex2Dlod(s1, r7);
            r8 = (r5) + (c12.xyzz);
            r8 = tex2Dlod(s1, r8);
            r5 = (r5) + (-(c12.xyzz));
            r5 = tex2Dlod(s1, r5);
            r6.y = r7.x;
            r6.z = r8.x;
            r6.w = r5.x;
            r3.w = dot(r6, c0.yyyy);
            r4.w = (v6.w) * (c3.x) + (c3.y);
            r5.x = lerp(r1.w, r3.w, r4.w);
            r1.w = r5.x;
        }
    }
    else
    {
        r3.w = (c12.w) + (v6.w);
        r3.w = ((r3.w) >= 0.0f ? (c0.x) : (c0.z));
        if ((r3.w) != (-(r3.w)))
        {
            r5.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r5.zw = (v6.zz) * (c0.zx) + (c0.wz);
            r5 = (r5) * (c0.zzzx);
            r6 = (r5) + (c4.xxyy);
            r6 = tex2Dlod(s1, r6);
            r7 = (r5) + (c4.zzww);
            r7 = tex2Dlod(s1, r7);
            r8 = (r5) + (c12.xyzz);
            r8 = tex2Dlod(s1, r8);
            r5 = (r5) + (-(c12.xyzz));
            r5 = tex2Dlod(s1, r5);
            r6.y = r7.x;
            r6.z = r8.x;
            r6.w = r5.x;
            r3.w = dot(r6, c0.yyyy);
            r4.w = saturate((-(c1.y)) + (v6.w));
            r1.w = lerp(r3.w, r2.w, r4.w);
        }
        else
        {
            r1.w = r2.w;
        }
    }
    r5.xyz = (r1.www) * (c[18].xyz);
    r6.xyz = (r1.www) * (c[19].xyz);
    r7.xyz = normalize(c[17].xyz);
    r8.xy = ddx(v4.xy);
    r8.zw = ddy(v4.xy);
    r9.xy = (c[36].xx) * (v4.xy);
    r9 = tex2D(s4, r9.xy);
    r9.xy = (r9.wy) * (c13.xy) + (c13.zw);
    r9.xy = (r9.xy) * (c1.zz) + (c1.zz);
    r9.xy = (r9.xy) * (c3.zz) + (c3.ww);
    r1.xyz = (r1.xyz) * (r9.yyy);
    r1.xyz = (r9.xxx) * (v3.xyz) + (r1.xyz);
    r1.xyz = (v2.xyz) * (r0.xxx) + (r1.xyz);
    r9.xyz = normalize(r1.xyz);
    r1.xyz = (r5.xyz) * (c[29].xxx);
    r0.x = saturate(dot(r9.xyz, r7.xyz));
    r1.w = saturate(dot(r9.xyz, r3.xyz));
    r2.xyz = (r2.xyz) * (r1.www);
    r1.xyz = (r0.xxx) * (r1.xyz) + (r2.xyz);
    r2.xyz = (r6.xyz) * (c[29].yyy);
    r5 = tex2D(s6, v4.xy);
    r2.w = (r5.x) * (c[39].x);
    r3.w = max(c14.x, r2.w);
    r2.w = dot(-(v1.xyz), -(v1.xyz));
    r2.w = rsqrt(r2.w);
    r6.xyz = (r2.www) * (-(v1.xyz));
    r4.w = saturate(dot(r9.xyz, r6.xyz));
    r3.w = (r3.w) * (r3.w);
    r3.w = 1.0f / (r3.w);
    r7.xyz = (-(v1.xyz)) * (r2.www) + (r7.xyz);
    r10.xyz = normalize(r7.xyz);
    r5.w = saturate(dot(r9.xyz, r10.xyz));
    r6.w = (r5.w) * (r5.w) + (c14.y);
    r6.w = 1.0f / (r6.w);
    r7.x = (-(r6.w)) + (c0.z);
    r7.x = (r3.w) * (r7.x);
    r7.x = (r7.x) * (c14.z);
    r7.x = exp2(r7.x);
    r6.w = (r6.w) * (r6.w);
    r6.w = (r7.x) * (r6.w);
    r5.w = (r5.w) + (r5.w);
    r7.x = 1.0f / (r4.w);
    r5.w = (r5.w) * (r7.x);
    r7.y = min(r4.w, r0.x);
    r5.w = saturate((r5.w) * (r7.y));
    r0.x = (r0.x) * (r5.w);
    r0.x = rsqrt(r0.x);
    r0.x = 1.0f / (r0.x);
    r0.x = (r6.w) * (r0.x);
    r3.xyz = (-(v1.xyz)) * (r2.www) + (r3.xyz);
    r10.xyz = normalize(r3.xyz);
    r2.w = saturate(dot(r9.xyz, r10.xyz));
    r3.x = (r2.w) * (r2.w) + (c14.y);
    r3.x = 1.0f / (r3.x);
    r3.y = (-(r3.x)) + (c0.z);
    r3.y = (r3.w) * (r3.y);
    r3.y = (r3.y) * (c14.z);
    r3.y = exp2(r3.y);
    r3.x = (r3.x) * (r3.x);
    r3.x = (r3.y) * (r3.x);
    r2.w = dot(r7.xx, r2.ww) + (c0.x);
    r3.y = min(r4.w, r1.w);
    r2.w = saturate((r2.w) * (r3.y));
    r1.w = (r1.w) * (r2.w);
    r1.w = rsqrt(r1.w);
    r1.w = 1.0f / (r1.w);
    r1.w = (r3.x) * (r1.w);
    r3.xyz = (r4.xyz) * (r1.www);
    r2.xyz = (r0.xxx) * (r2.xyz) + (r3.xyz);
    r0.x = saturate(dot(r0.yzw, r6.xyz));
    r0.x = (r4.w) + (r0.x);
    r0.x = (r0.x) * (c1.z);
    r1.w = max(c14.w, r0.x);
    r0.x = 1.0f / (r1.w);
    r0.x = rsqrt(r0.x);
    r0.x = 1.0f / (r0.x);
    r0.xyz = (r2.xyz) * (r0.xxx);
    r0.xyz = (r3.www) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c[38].xxx);
    r0.xyz = (r0.xyz) * (c0.yyy) + (c0.zzz);
    r2.x = c0.x;
    r0.w = max(c[37].x, r2.x);
    r0.w = (r0.w) + (-(c0.z));
    r2.x = log2(abs(r0.x));
    r2.y = log2(abs(r0.y));
    r2.z = log2(abs(r0.z));
    r0.xyz = (r0.www) * (r2.xyz);
    r2.x = exp2(r0.x);
    r2.y = exp2(r0.y);
    r2.z = exp2(r0.z);
    r0.xyz = normalize(v1.xyz);
    r0.w = dot(r0.xyz, r9.xyz);
    r0.w = (r0.w) + (r0.w);
    r0.xyz = (r9.xyz) * (-(r0.www)) + (r0.xyz);
    r0 = texCUBE(s15, r0.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c15.xxx);
    r3 = tex3D(s11, v5.xyz);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r0.xyz = (r0.xyz) * (r3.xyz);
    r0.xyz = (r0.xyz) * (c15.yyy);
    r3.xyz = (r5.xyz) * (c[35].xxx);
    r0.xyz = (r0.xyz) * (r3.xyz);
    r0.xyz = (r2.xyz) * (c[37].yyy) + (r0.xyz);
    r0.w = max(abs(r9.y), abs(r9.z));
    r1.w = max(abs(r9.x), r0.w);
    r2.xyz = (r9.xyz) * (c[5].xyz);
    r0.w = 1.0f / (r1.w);
    r2.xyz = (r2.xyz) * (r0.www) + (v5.xyz);
    r2 = tex3D(s11, r2.xyz);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r3 = tex2Dgrad(s5, v4.xy, r8.xy, r8.zw);
    r3 = (r3) * (r3);
    r1.xyz = (r2.xyz) * (c15.yyy) + (r1.xyz);
    r0.xyz = (r0.xyz) * (c[40].xxx);
    r3.xyz = (r1.xyz) * (r3.xyz) + (r0.xyz);
    r0 = max(r3, c0.xxxx);
    r1 = (r0.xyzx) * (c0.zzzx) + (c0.wwwz);
    r0.x = dot(r1, c[32]);
    r0.y = dot(r1, c[33]);
    r0.z = dot(r1, c[34]);
    r1.w = v1.w;
    r2.xyz = lerp(v0.xyz, r0.xyz, r1.www);
    r0.xyz = max(((r2.xyz) * (c[31].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = r0.w;

    return oC0;
}
