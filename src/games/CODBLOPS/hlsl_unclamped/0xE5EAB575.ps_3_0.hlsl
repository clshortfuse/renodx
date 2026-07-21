// Mechanically reconstructed from 0xE5EAB575.ps_3_0.cso.
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
    const float4 c13 = float4(-28.0f, 30.0f, 0.136841998f, 10.0f);
    const float4 c14 = float4(0.38647899f, 0.392856985f, 0.364796013f, 9.99999994e-09f);
    const float4 c15 = float4(9.0f, 15.0f, 4.0f, 11.0f);
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

    r0.xyz = normalize(v2.xyz);
    r1.xy = (v3.xy) * (c[36].xy) + (c[36].zw);
    r1.z = max(abs(r0.y), abs(r0.z));
    r2.x = max(abs(r0.x), r1.z);
    r2.yzw = (r0.xyz) * (c[5].xyz);
    r0.w = 1.0f / (r2.x);
    r2.xyz = (r2.yzw) * (r0.www) + (v4.xyz);
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
    r0.w = dot(r5, c0.yyyy);
    r3.xyz = (c[6].xyz) + (-(v1.xyz));
    r4.xyz = normalize(r3.xyz);
    r3 = (v1.xyzx) * (c0.zzzx) + (c0.xxxz);
    r1.z = dot(r3, c[11]);
    r1.w = dot(r3, c[20]);
    r5.x = dot(r3, c[21]);
    r3.x = dot(r3, c[22]);
    r5.y = (r5.x) * (r5.x);
    r3.y = dot(c[9].yz, r5.xy) + (c[9].x);
    r3.z = saturate(1.0f / (r3.y));
    r3.y = ((-abs(r3.y)) >= 0.0f ? (c0.x) : (r3.z));
    r3.zw = saturate((r5.xx) * (c[10].xy) + (c[10].zw));
    r5.xy = (r3.zw) * (r3.zw);
    r3.zw = (r3.zw) * (c3.xx) + (c3.yy);
    r3.z = (r5.x) * (r3.z);
    r3.y = (r3.y) * (r3.z);
    r3.z = (r5.y) * (-(r3.w)) + (c0.z);
    r3.y = (r3.y) * (r3.z);
    r3.z = dot(r4.xyz, c[23].xyz);
    r3.z = saturate((r3.z) * (c[24].x) + (c[24].y));
    r3.w = (r3.z) * (r3.z);
    r3.z = (r3.z) * (c3.x) + (c3.y);
    r3.z = (r3.w) * (r3.z);
    r3.y = (r3.y) * (r3.z);
    r3.x = 1.0f / (r3.x);
    r1.zw = (r1.zw) * (r3.xx);
    r1.zw = (r1.zw) * (c0.ww) + (c0.ww);
    r5 = tex2D(s3, r1.zw);
    r1.z = (r5.x) * (r5.x);
    r1.z = (r3.y) * (r1.z);
    r0.w = (r0.w) * (r1.z);
    r3.xyz = (r0.www) * (c[7].xyz);
    r5.xyz = (r0.www) * (c[8].xyz);
    if ((c0.z) >= (v5.w))
    {
        r6 = (v5.xyzx) * (c0.zzzx) + (c0.xxxz);
        r6 = (r6) * (c0.zzzx);
        r7 = (r6) + (c3.zzww);
        r7 = tex2Dlod(s1, r7);
        r8 = (r6) + (-(c3.zzww));
        r8 = tex2Dlod(s1, r8);
        r9 = (r6) + (c4.xyzz);
        r9 = tex2Dlod(s1, r9);
        r6 = (r6) + (-(c4.xyzz));
        r6 = tex2Dlod(s1, r6);
        r7.y = r8.x;
        r7.z = r9.x;
        r7.w = r6.x;
        r0.w = dot(r7, c0.yyyy);
        if ((c4.w) < (v5.w))
        {
            r6.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
            r6.zw = (v5.zx) * (c0.zx) + (c0.xz);
            r6 = (r6) * (c0.zzzx);
            r7 = (r6) + (c3.zzww);
            r7 = tex2Dlod(s1, r7);
            r8 = (r6) + (-(c3.zzww));
            r8 = tex2Dlod(s1, r8);
            r9 = (r6) + (c4.xyzz);
            r9 = tex2Dlod(s1, r9);
            r6 = (r6) + (-(c4.xyzz));
            r6 = tex2Dlod(s1, r6);
            r7.y = r8.x;
            r7.z = r9.x;
            r7.w = r6.x;
            r1.z = dot(r7, c0.yyyy);
            r1.w = (v5.w) * (c1.x) + (c1.y);
            r3.w = lerp(r0.w, r1.z, r1.w);
            r0.w = r3.w;
        }
    }
    else
    {
        r1.z = (c1.z) + (v5.w);
        r1.z = ((r1.z) >= 0.0f ? (c0.x) : (c0.z));
        if ((r1.z) != (-(r1.z)))
        {
            r6.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
            r6.zw = (v5.zz) * (c0.zx) + (c0.xz);
            r6 = (r6) * (c0.zzzx);
            r7 = (r6) + (c3.zzww);
            r7 = tex2Dlod(s1, r7);
            r8 = (r6) + (-(c3.zzww));
            r8 = tex2Dlod(s1, r8);
            r9 = (r6) + (c4.xyzz);
            r9 = tex2Dlod(s1, r9);
            r6 = (r6) + (-(c4.xyzz));
            r6 = tex2Dlod(s1, r6);
            r7.y = r8.x;
            r7.z = r9.x;
            r7.w = r6.x;
            r1.z = dot(r7, c0.yyyy);
            r1.w = saturate((-(c3.y)) + (v5.w));
            r0.w = lerp(r1.z, r2.w, r1.w);
        }
        else
        {
            r0.w = r2.w;
        }
    }
    r6.xyz = (r0.www) * (c[18].xyz);
    r7.xyz = (r0.www) * (c[19].xyz);
    r8.xyz = normalize(c[17].xyz);
    r6.xyz = (r6.xyz) * (c[29].xxx);
    r0.w = saturate(dot(r0.xyz, r8.xyz));
    r1.z = saturate(dot(r0.xyz, r4.xyz));
    r3.xyz = (r3.xyz) * (r1.zzz);
    r3.xyz = (r0.www) * (r6.xyz) + (r3.xyz);
    r6.x = c[35].x;
    r9 = (-(r6.xxxx)) + (c12);
    r6.yzw = float3(((-abs(r9.x)) >= 0.0f ? (r3.x) : (c0.x)), ((-abs(r9.x)) >= 0.0f ? (r3.y) : (c0.x)), ((-abs(r9.x)) >= 0.0f ? (r3.z) : (c0.x)));
    r10.x = log2(abs(r3.x));
    r10.y = log2(abs(r3.y));
    r10.z = log2(abs(r3.z));
    r3.xyz = (r10.xyz) * (c4.www);
    r10.x = exp2(r3.x);
    r10.y = exp2(r3.y);
    r10.z = exp2(r3.z);
    r3.xyz = float3(((-abs(r9.y)) >= 0.0f ? (r10.x) : (r6.y)), ((-abs(r9.y)) >= 0.0f ? (r10.y) : (r6.z)), ((-abs(r9.y)) >= 0.0f ? (r10.z) : (r6.w)));
    r2.xyz = (r2.xyz) * (r2.xyz);
    r2.xyz = (r2.xyz) * (c1.www) + (r10.xyz);
    r3.xyz = float3(((-abs(r9.z)) >= 0.0f ? (r2.x) : (r3.x)), ((-abs(r9.z)) >= 0.0f ? (r2.y) : (r3.y)), ((-abs(r9.z)) >= 0.0f ? (r2.z) : (r3.z)));
    r6.yzw = (r7.xyz) * (c[29].yyy);
    r7.xyz = normalize(v1.xyz);
    r0.w = dot(-(r8.xyz), r0.xyz);
    r0.w = (r0.w) + (r0.w);
    r9.xyz = (r0.xyz) * (-(r0.www)) + (-(r8.xyz));
    r0.w = dot(r8.xyz, r7.xyz);
    r0.w = saturate((r0.w) * (c0.w) + (c0.w));
    r1.z = (r0.w) * (c13.x) + (c13.y);
    r0.w = (r0.w) + (c0.z);
    r1.w = saturate(dot(r9.xyz, -(r7.xyz)));
    r2.w = pow(abs(r1.w), r1.z);
    r6.yzw = (r6.yzw) * (r2.www);
    r1.w = dot(-(r4.xyz), r0.xyz);
    r1.w = (r1.w) + (r1.w);
    r8.xyz = (r0.xyz) * (-(r1.www)) + (-(r4.xyz));
    r1.w = dot(r4.xyz, r7.xyz);
    r1.w = saturate((r1.w) * (c0.w) + (c0.w));
    r2.w = lerp(r1.z, -(c3.x), r1.w);
    r3.w = lerp(r0.w, -(c3.x), r1.w);
    r1.z = saturate(dot(r8.xyz, -(r7.xyz)));
    r4.x = pow(abs(r1.z), r2.w);
    r4.xyz = (r5.xyz) * (r4.xxx);
    r4.xyz = (r3.www) * (r4.xyz);
    r4.xyz = (r6.yzw) * (r0.www) + (r4.xyz);
    r3.xyz = float3(((-abs(r9.w)) >= 0.0f ? (r4.x) : (r3.x)), ((-abs(r9.w)) >= 0.0f ? (r4.y) : (r3.y)), ((-abs(r9.w)) >= 0.0f ? (r4.z) : (r3.z)));
    r5.xyz = (r4.xyz) * (c14.xyz);
    r8 = (-(r6.xxxx)) + (c15);
    r3.xyz = float3(((-abs(r8.x)) >= 0.0f ? (r5.x) : (r3.x)), ((-abs(r8.x)) >= 0.0f ? (r5.y) : (r3.y)), ((-abs(r8.x)) >= 0.0f ? (r5.z) : (r3.z)));
    r0.w = dot(r7.xyz, r0.xyz);
    r0.w = (r0.w) + (r0.w);
    r0.xyz = (r0.xyz) * (-(r0.www)) + (r7.xyz);
    r0 = texCUBE(s15, r0.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c12.zzz);
    r5 = tex3D(s11, v4.xyz);
    r5.xyz = (r5.xyz) * (r5.xyz);
    r0.xyz = (r0.xyz) * (r5.xyz);
    r0.xyz = (r0.xyz) * (c1.www);
    r3.xyz = float3(((-abs(r8.y)) >= 0.0f ? (r0.x) : (r3.x)), ((-abs(r8.y)) >= 0.0f ? (r0.y) : (r3.y)), ((-abs(r8.y)) >= 0.0f ? (r0.z) : (r3.z)));
    r0.xyz = (r0.xyz) * (c[37].xxx);
    r3.xyz = float3(((-abs(r8.z)) >= 0.0f ? (r0.x) : (r3.x)), ((-abs(r8.z)) >= 0.0f ? (r0.y) : (r3.y)), ((-abs(r8.z)) >= 0.0f ? (r0.z) : (r3.z)));
    r0.xyz = (r4.xyz) * (c14.xyz) + (r0.xyz);
    r3.xyz = float3(((-abs(r8.w)) >= 0.0f ? (r0.x) : (r3.x)), ((-abs(r8.w)) >= 0.0f ? (r0.y) : (r3.y)), ((-abs(r8.w)) >= 0.0f ? (r0.z) : (r3.z)));
    r0.xyz = (r0.xyz) * (c13.zzz);
    r1 = tex2D(s4, r1.xy);
    r0.xyz = (r2.xyz) * (r1.xyz) + (r0.xyz);
    r1.xyz = max(r0.xyz, c0.xxx);
    r0.x = (-(r6.x)) + (c13.w);
    r0.xyz = float3(((-abs(r0.x)) >= 0.0f ? (r1.x) : (r3.x)), ((-abs(r0.x)) >= 0.0f ? (r1.y) : (r3.y)), ((-abs(r0.x)) >= 0.0f ? (r1.z) : (r3.z)));
    r0.w = abs(c[35].x);
    r0.xyz = float3(((-(r0.w)) >= 0.0f ? (r1.x) : (r0.x)), ((-(r0.w)) >= 0.0f ? (r1.y) : (r0.y)), ((-(r0.w)) >= 0.0f ? (r1.z) : (r0.z)));
    r0.xyz = (r1.xyz) * (c14.www) + (r0.xyz);
    r0.xyz = float3(((c[35].x) >= 0.0f ? (r0.x) : (r1.x)), ((c[35].x) >= 0.0f ? (r0.y) : (r1.y)), ((c[35].x) >= 0.0f ? (r0.z) : (r1.z)));
    r0.w = c0.z;
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
    oC0.w = c0.z;

    return oC0;
}
