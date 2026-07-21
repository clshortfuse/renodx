// Mechanically reconstructed from 0x21ABD624.ps_3_0.cso.
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
    const float4 c0 = float4(1.16412354f, 1.59579468f, -0.87065506f, 31.875f);
    const float4 c1 = float4(0.0f, 0.25f, 1.0f, 0.5f);
    const float4 c3 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c4 = float4(4.0f, -3.0f, -4.0f, 8.0f);
    const float4 c12 = float4(-2.0f, 3.0f, 0.000244140625f, 0.0f);
    const float4 c13 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c14 = float4(2.0f, -1.0f, -101.222f, 103.222f);
    const float4 c15 = float4(1.16412354f, -0.813476562f, -0.391448975f, 0.529705048f);
    const float4 c16 = float4(1.16412354f, 2.01782227f, -1.08166885f, 0.0f);
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
    r0.yzw = (r0.yzw) * (c[5].xyz);
    r1.w = 1.0f / (r2.x);
    r0.yzw = (r0.yzw) * (r1.www) + (v5.xyz);
    r2 = tex3D(s11, r0.yzw);
    r3 = (c[26]) * (v1.yyyy);
    r3 = (v1.xxxx) * (c[25]) + (r3);
    r3 = (v1.zzzz) * (c[27]) + (r3);
    r3 = (r3) + (c[28]);
    r4.xy = (r3.ww) * (c[30].xy);
    r4.zw = c1.xx;
    r5 = (r3) + (r4.xyww);
    r5 = tex2Dproj(s2, r5);
    r4 = (r3) + (-(r4));
    r4 = tex2Dproj(s2, r4);
    r6.xy = (r3.ww) * (c[30].zw);
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
    r0.z = dot(r4, c[11]);
    r0.w = dot(r4, c[20]);
    r2.x = dot(r4, c[21]);
    r1.w = dot(r4, c[22]);
    r2.y = (r2.x) * (r2.x);
    r2.y = dot(c[9].yz, r2.xy) + (c[9].x);
    r2.z = saturate(1.0f / (r2.y));
    r2.y = ((-abs(r2.y)) >= 0.0f ? (c1.x) : (r2.z));
    r2.xz = saturate((r2.xx) * (c[10].xy) + (c[10].zw));
    r4.xy = (r2.xz) * (r2.xz);
    r2.xz = (r2.xz) * (c12.xx) + (c12.yy);
    r2.x = (r4.x) * (r2.x);
    r2.x = (r2.y) * (r2.x);
    r2.y = (r4.y) * (-(r2.z)) + (c1.z);
    r2.x = (r2.x) * (r2.y);
    r2.y = dot(r3.xyz, c[23].xyz);
    r2.y = saturate((r2.y) * (c[24].x) + (c[24].y));
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
    r2.xyz = (r0.yyy) * (c[7].xyz);
    r0.yzw = (r0.yyy) * (c[8].xyz);
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
            r3.w = dot(r5, c1.yyyy);
            r4.x = (v6.w) * (c4.x) + (c4.y);
            r5.x = lerp(r1.w, r3.w, r4.x);
            r1.w = r5.x;
        }
    }
    else
    {
        r3.w = (c4.z) + (v6.w);
        r3.w = ((r3.w) >= 0.0f ? (c1.x) : (c1.z));
        if ((r3.w) != (-(r3.w)))
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
            r3.w = dot(r5, c1.yyyy);
            r4.x = saturate((-(c12.y)) + (v6.w));
            r1.w = lerp(r3.w, r2.w, r4.x);
        }
        else
        {
            r1.w = r2.w;
        }
    }
    r4.xyz = (r1.www) * (c[18].xyz);
    r5.xyz = (r1.www) * (c[19].xyz);
    r6.xyz = normalize(c[17].xyz);
    r7 = tex2D(s7, v4.xy);
    r7.xy = (r7.wy) * (c13.xy) + (c13.zw);
    r7.xy = (r7.xy) * (c1.ww) + (c1.ww);
    r7.xy = (r7.xy) * (c14.xx) + (c14.yy);
    r1.xyz = (r1.xyz) * (r7.yyy);
    r1.xyz = (r7.xxx) * (v3.xyz) + (r1.xyz);
    r1.xyz = (v2.xyz) * (r0.xxx) + (r1.xyz);
    r7.xyz = normalize(r1.xyz);
    r1.xyz = (r4.xyz) * (c[29].xxx);
    r0.x = saturate(dot(r7.xyz, r6.xyz));
    r1.w = saturate(dot(r7.xyz, r3.xyz));
    r2.xyz = (r2.xyz) * (r1.www);
    r1.xyz = (r0.xxx) * (r1.xyz) + (r2.xyz);
    r2.xyz = (r5.xyz) * (c[29].yyy);
    r4.xyz = normalize(v1.xyz);
    r0.x = dot(-(r6.xyz), r7.xyz);
    r0.x = (r0.x) + (r0.x);
    r5.xyz = (r7.xyz) * (-(r0.xxx)) + (-(r6.xyz));
    r0.x = dot(r6.xyz, r4.xyz);
    r0.x = saturate((r0.x) * (c1.w) + (c1.w));
    r1.w = (r0.x) * (c14.z) + (c14.w);
    r0.x = (r0.x) + (c1.z);
    r2.w = saturate(dot(r5.xyz, -(r4.xyz)));
    r3.w = pow(abs(r2.w), r1.w);
    r2.xyz = (r2.xyz) * (r3.www);
    r2.w = dot(-(r3.xyz), r7.xyz);
    r2.w = (r2.w) + (r2.w);
    r5.xyz = (r7.xyz) * (-(r2.www)) + (-(r3.xyz));
    r2.w = dot(r3.xyz, r4.xyz);
    r2.w = saturate((r2.w) * (c1.w) + (c1.w));
    r3.x = lerp(r1.w, -(c12.x), r2.w);
    r1.w = lerp(r0.x, -(c12.x), r2.w);
    r2.w = saturate(dot(r5.xyz, -(r4.xyz)));
    r4.x = pow(abs(r2.w), r3.x);
    r0.yzw = (r0.yzw) * (r4.xxx);
    r0.yzw = (r1.www) * (r0.yzw);
    r0.xyz = (r2.xyz) * (r0.xxx) + (r0.yzw);
    r0.xyz = (r0.xyz) * (c[34].xxx);
    r0.w = max(abs(r7.y), abs(r7.z));
    r1.w = max(abs(r7.x), r0.w);
    r2.xyz = (r7.xyz) * (c[5].xyz);
    r0.w = 1.0f / (r1.w);
    r2.xyz = (r2.xyz) * (r0.www) + (v5.xyz);
    r2 = tex3D(s11, r2.xyz);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r3 = tex2D(s8, v4.xy);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r4.xy = lerp(c[32].xy, c[32].zw, v4.xy);
    r5 = tex2D(s4, r4.xy);
    r6 = tex2D(s5, r4.xy);
    r4 = tex2D(s6, r4.xy);
    r5.xw = (r5.xx) * (c1.zx) + (c1.xz);
    r5.y = r6.x;
    r4.y = dot(c0.xyz, r5.xyw);
    r5.z = r4.x;
    r4.z = dot(c15, r5);
    r4.w = dot(c16.xyz, r5.xzw);
    r4.xyz = (r4.yzw) * (r4.yzw);
    r4.xyz = (r4.xyz) * (c4.www);
    r0.w = c1.w;
    r0.w = (-(r0.w)) + (c[31].x);
    r3.xyz = float3(((r0.w) >= 0.0f ? (r4.x) : (r3.x)), ((r0.w) >= 0.0f ? (r4.y) : (r3.y)), ((r0.w) >= 0.0f ? (r4.z) : (r3.z)));
    r1.xyz = (r2.xyz) * (c0.www) + (r1.xyz);
    r0.xyz = (r1.xyz) * (r3.xyz) + (r0.xyz);
    r1.xyz = max(r0.xyz, c1.xxx);
    r0.w = v1.w;
    r2.xyz = lerp(v0.xyz, r1.xyz, r0.www);
    r0.xyz = max(((r2.xyz) * (c[33].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c1.z;

    return oC0;
}
