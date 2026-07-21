// Mechanically reconstructed from 0x5D9B53AD.ps_3_0.cso.
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
sampler3D s11 : register(s11);
samplerCUBE s15 : register(s15);

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
    const float4 c0 = float4(0.0f, 0.25f, 1.0f, 0.5f);
    const float4 c1 = float4(4.0f, -3.0f, -4.0f, 31.875f);
    const float4 c3 = float4(-2.0f, 3.0f, 0.000244140625f, 0.0f);
    const float4 c4 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c12 = float4(6.0f, 13.0f, 8.0f, 12.0f);
    const float4 c13 = float4(-28.0f, 30.0f, 24.0f, 0.0166666675f);
    const float4 c14 = float4(0.38647899f, 0.392856985f, 0.364796013f, 0.419999987f);
    const float4 c15 = float4(9.0f, 14.0f, 4.0f, 11.0f);
    const float4 c16 = float4(-0.589999974f, -0.5f, 0.589999974f, 0.5f);
    const float4 c47 = float4(1.22077894f, 2.0f, 0.857142985f, 9.99999994e-09f);
    const float4 c48 = float4(30.0f, 10.0f, 0.0f, 0.0f);
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

    r0.xyz = normalize(v2.xyz);
    r1.x = max(abs(r0.y), abs(r0.z));
    r2.x = max(abs(r0.x), r1.x);
    r1.xyz = (r0.xyz) * (c[5].xyz);
    r0.w = 1.0f / (r2.x);
    r1.xyz = (r1.xyz) * (r0.www) + (v4.xyz);
    r1 = tex3D(s11, r1.xyz);
    r2 = (c[26]) * (v1.yyyy);
    r2 = (v1.xxxx) * (c[25]) + (r2);
    r2 = (v1.zzzz) * (c[27]) + (r2);
    r2 = (r2) + (c[28]);
    r3.xy = (r2.ww) * (c[30].xy);
    r3.zw = c0.xx;
    r4 = (r2) + (r3.xyww);
    r4 = tex2Dproj(s2, r4);
    r3 = (r2) + (-(r3));
    r3 = tex2Dproj(s2, r3);
    r5.xy = (r2.ww) * (c[30].zw);
    r5.zw = c0.xx;
    r6 = (r2) + (r5.xyww);
    r6 = tex2Dproj(s2, r6);
    r2 = (r2) + (-(r5));
    r2 = tex2Dproj(s2, r2);
    r4.y = r3.x;
    r4.z = r6.x;
    r4.w = r2.x;
    r0.w = dot(r4, c0.yyyy);
    r2.xyz = (c[6].xyz) + (-(v1.xyz));
    r3.xyz = normalize(r2.xyz);
    r2 = (v1.xyzx) * (c0.zzzx) + (c0.xxxz);
    r4.x = dot(r2, c[11]);
    r4.y = dot(r2, c[20]);
    r4.z = dot(r2, c[21]);
    r2.x = dot(r2, c[22]);
    r4.w = (r4.z) * (r4.z);
    r2.y = dot(c[9].yz, r4.zw) + (c[9].x);
    r2.z = saturate(1.0f / (r2.y));
    r2.y = ((-abs(r2.y)) >= 0.0f ? (c0.x) : (r2.z));
    r2.zw = saturate((r4.zz) * (c[10].xy) + (c[10].zw));
    r4.zw = (r2.zw) * (r2.zw);
    r2.zw = (r2.zw) * (c3.xx) + (c3.yy);
    r2.z = (r4.z) * (r2.z);
    r2.y = (r2.y) * (r2.z);
    r2.z = (r4.w) * (-(r2.w)) + (c0.z);
    r2.y = (r2.y) * (r2.z);
    r2.z = dot(r3.xyz, c[23].xyz);
    r2.z = saturate((r2.z) * (c[24].x) + (c[24].y));
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
    r0.w = (r0.w) * (r2.x);
    r2.xyz = (r0.www) * (c[7].xyz);
    r4.xyz = (r0.www) * (c[8].xyz);
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
        r0.w = dot(r6, c0.yyyy);
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
            r3.w = (v5.w) * (c1.x) + (c1.y);
            r4.w = lerp(r0.w, r2.w, r3.w);
            r0.w = r4.w;
        }
    }
    else
    {
        r2.w = (c1.z) + (v5.w);
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
            r0.w = lerp(r2.w, r1.w, r3.w);
        }
        else
        {
            r0.w = r1.w;
        }
    }
    r5.xyz = (r0.www) * (c[18].xyz);
    r6.xyz = (r0.www) * (c[19].xyz);
    r7.xyz = normalize(c[17].xyz);
    r5.xyz = (r5.xyz) * (c[29].xxx);
    r0.w = saturate(dot(r0.xyz, r7.xyz));
    r1.w = saturate(dot(r0.xyz, r3.xyz));
    r2.xyz = (r2.xyz) * (r1.www);
    r2.xyz = (r0.www) * (r5.xyz) + (r2.xyz);
    r5.x = c[36].x;
    r8 = (-(r5.xxxx)) + (c12);
    r5.yzw = float3(((-abs(r8.x)) >= 0.0f ? (r2.x) : (c0.x)), ((-abs(r8.x)) >= 0.0f ? (r2.y) : (c0.x)), ((-abs(r8.x)) >= 0.0f ? (r2.z) : (c0.x)));
    r9.x = log2(abs(r2.x));
    r9.y = log2(abs(r2.y));
    r9.z = log2(abs(r2.z));
    r2.xyz = (r9.xyz) * (c4.www);
    r9.x = exp2(r2.x);
    r9.y = exp2(r2.y);
    r9.z = exp2(r2.z);
    r2.xyz = float3(((-abs(r8.y)) >= 0.0f ? (r9.x) : (r5.y)), ((-abs(r8.y)) >= 0.0f ? (r9.y) : (r5.z)), ((-abs(r8.y)) >= 0.0f ? (r9.z) : (r5.w)));
    r1.xyz = (r1.xyz) * (r1.xyz);
    r1.xyz = (r1.xyz) * (c1.www) + (r9.xyz);
    r2.xyz = float3(((-abs(r8.z)) >= 0.0f ? (r1.x) : (r2.x)), ((-abs(r8.z)) >= 0.0f ? (r1.y) : (r2.y)), ((-abs(r8.z)) >= 0.0f ? (r1.z) : (r2.z)));
    r5.yzw = (r6.xyz) * (c[29].yyy);
    r6.xyz = normalize(v1.xyz);
    r0.w = dot(-(r7.xyz), r0.xyz);
    r0.w = (r0.w) + (r0.w);
    r8.xyz = (r0.xyz) * (-(r0.www)) + (-(r7.xyz));
    r0.w = dot(r7.xyz, r6.xyz);
    r0.w = saturate((r0.w) * (c0.w) + (c0.w));
    r1.w = (r0.w) * (c13.x) + (c13.y);
    r0.w = (r0.w) + (c0.z);
    r2.w = saturate(dot(r8.xyz, -(r6.xyz)));
    r3.w = pow(abs(r2.w), r1.w);
    r5.yzw = (r5.yzw) * (r3.www);
    r2.w = dot(-(r3.xyz), r0.xyz);
    r2.w = (r2.w) + (r2.w);
    r7.xyz = (r0.xyz) * (-(r2.www)) + (-(r3.xyz));
    r2.w = dot(r3.xyz, r6.xyz);
    r2.w = saturate((r2.w) * (c0.w) + (c0.w));
    r3.x = lerp(r1.w, -(c3.x), r2.w);
    r1.w = lerp(r0.w, -(c3.x), r2.w);
    r2.w = saturate(dot(r7.xyz, -(r6.xyz)));
    r4.w = pow(abs(r2.w), r3.x);
    r3.xyz = (r4.xyz) * (r4.www);
    r3.xyz = (r1.www) * (r3.xyz);
    r3.xyz = (r5.yzw) * (r0.www) + (r3.xyz);
    r2.xyz = float3(((-abs(r8.w)) >= 0.0f ? (r3.x) : (r2.x)), ((-abs(r8.w)) >= 0.0f ? (r3.y) : (r2.y)), ((-abs(r8.w)) >= 0.0f ? (r3.z) : (r2.z)));
    r4.xyz = (r3.xyz) * (c14.xyz);
    r7 = (-(r5.xxxx)) + (c15);
    r2.xyz = float3(((-abs(r7.x)) >= 0.0f ? (r4.x) : (r2.x)), ((-abs(r7.x)) >= 0.0f ? (r4.y) : (r2.y)), ((-abs(r7.x)) >= 0.0f ? (r4.z) : (r2.z)));
    r0.w = dot(r6.xyz, r0.xyz);
    r0.w = (r0.w) + (r0.w);
    r0.xyz = (r0.xyz) * (-(r0.www)) + (r6.xyz);
    r0 = texCUBE(s15, r0.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c12.zzz);
    r4 = tex3D(s11, v4.xyz);
    r4.xyz = (r4.xyz) * (r4.xyz);
    r0.xyz = (r0.xyz) * (r4.xyz);
    r0.xyz = (r0.xyz) * (c1.www);
    r2.xyz = float3(((-abs(r7.y)) >= 0.0f ? (r0.x) : (r2.x)), ((-abs(r7.y)) >= 0.0f ? (r0.y) : (r2.y)), ((-abs(r7.y)) >= 0.0f ? (r0.z) : (r2.z)));
    r0.xyz = (r0.xyz) * (c[37].xxx);
    r2.xyz = float3(((-abs(r7.z)) >= 0.0f ? (r0.x) : (r2.x)), ((-abs(r7.z)) >= 0.0f ? (r0.y) : (r2.y)), ((-abs(r7.z)) >= 0.0f ? (r0.z) : (r2.z)));
    r0.xyz = (r3.xyz) * (c14.xyz) + (r0.xyz);
    r2.xyz = float3(((-abs(r7.w)) >= 0.0f ? (r0.x) : (r2.x)), ((-abs(r7.w)) >= 0.0f ? (r0.y) : (r2.y)), ((-abs(r7.w)) >= 0.0f ? (r0.z) : (r2.z)));
    r3 = tex2D(s8, v3.xy);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r4 = tex2D(s7, v3.xy);
    r4.xyz = (r4.xyz) * (r4.xyz);
    r0.w = c[31].w;
    r1.w = (r0.w) * (c13.z);
    r1.w = frac(r1.w);
    r1.w = (r0.w) * (c13.z) + (-(r1.w));
    r5.z = (r1.w) * (c13.w);
    r5.y = c14.w;
    r6 = tex2D(s5, r5.yz);
    r7.xy = c[46].xy;
    r5.yz = (-(r7.xy)) + (c[38].xy);
    r5.yz = (r6.xx) * (r5.yz) + (c[46].xy);
    r6.xy = (c16.xy) + (v3.xy);
    r5.yz = (r6.xy) * (r5.yz) + (c16.zw);
    r5.yz = (r0.ww) * (c[45].xy) + (r5.yz);
    r6 = tex2D(s6, r5.yz);
    r5.yzw = (r6.xyz) * (r6.xyz);
    r5.yzw = (r5.yzw) * (c47.xyz);
    r4.xyz = (r4.xyz) * (c[44].xxx) + (r5.yzw);
    r0.w = (r0.w) * (c[42].x);
    r1.w = frac(abs(r0.w));
    r0.w = ((r0.w) >= 0.0f ? (r1.w) : (-(r1.w)));
    r0.w = (-(r0.w)) + (v3.y);
    r5.z = (r0.w) * (c[43].x);
    r5.y = v3.x;
    r6 = tex2D(s4, r5.yz);
    r0.w = pow(abs(r6.y), c[39].x);
    r5.yzw = (r0.www) * (c[41].xyz);
    r4.xyz = (r5.yzw) * (c[40].xxx) + (r4.xyz);
    r5.xy = (-(r5.xx)) + (c48.xy);
    r2.xyz = float3(((-abs(r5.x)) >= 0.0f ? (r4.x) : (r2.x)), ((-abs(r5.x)) >= 0.0f ? (r4.y) : (r2.y)), ((-abs(r5.x)) >= 0.0f ? (r4.z) : (r2.z)));
    r3.xyz = (r3.xyz) * (r4.xyz);
    r0.xyz = (r1.xyz) * (r3.xyz) + (r0.xyz);
    r1.xyz = max(r0.xyz, c0.xxx);
    r0.xyz = float3(((-abs(r5.y)) >= 0.0f ? (r1.x) : (r2.x)), ((-abs(r5.y)) >= 0.0f ? (r1.y) : (r2.y)), ((-abs(r5.y)) >= 0.0f ? (r1.z) : (r2.z)));
    r0.w = abs(c[36].x);
    r0.xyz = float3(((-(r0.w)) >= 0.0f ? (r1.x) : (r0.x)), ((-(r0.w)) >= 0.0f ? (r1.y) : (r0.y)), ((-(r0.w)) >= 0.0f ? (r1.z) : (r0.z)));
    r0.xyz = (r1.xyz) * (c47.www) + (r0.xyz);
    r0.xyz = float3(((c[36].x) >= 0.0f ? (r0.x) : (r1.x)), ((c[36].x) >= 0.0f ? (r0.y) : (r1.y)), ((c[36].x) >= 0.0f ? (r0.z) : (r1.z)));
    r0.w = c0.z;
    r1.x = dot(r0, c[33]);
    r1.y = dot(r0, c[34]);
    r1.z = dot(r0, c[35]);
    r0.w = v1.w;
    r2.xyz = lerp(v0.xyz, r1.xyz, r0.www);
    r0.xyz = max(((r2.xyz) * (c[32].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.z;

    return oC0;
}
