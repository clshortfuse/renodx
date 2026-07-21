// Mechanically reconstructed from 0xAD3281D1.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler2D s3 : register(s3);
sampler3D s11 : register(s11);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD3;
    float4 v4 : TEXCOORD4;
    float4 v5 : TEXCOORD5;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    const float4 c0 = float4(31.875f, 0.0f, 0.0f, 0.0f);
    const float4 c1 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c2 = float4(0.5f, 2.0f, -1.0f, 1.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 oC0 = 0.0f;

    r0.x = (c[22].w) + (v4.x);
    r0.y = v4.y;
    r0.zw = frac(abs(r0.xy));
    r0.xy = float2(((r0.x) >= 0.0f ? (r0.z) : (-(r0.z))), ((r0.y) >= 0.0f ? (r0.w) : (-(r0.w))));
    r1 = tex2D(s1, r0.xy);
    r0.zw = (r1.wy) * (c1.xy) + (c1.zw);
    r0.zw = (r0.zw) * (c2.xx) + (c2.xx);
    r0.zw = (r0.zw) * (c2.yy) + (c2.zz);
    r0.zw = (r0.zw) + (r0.zw);
    r1.x = dot(v2.xyz, v2.xyz);
    r1.x = rsqrt(r1.x);
    r1.yzw = (r1.xxx) * (v2.xyz);
    r2.xyz = (r1.wyz) * (v3.yzx);
    r2.xyz = (r1.zwy) * (v3.zxy) + (-(r2.xyz));
    r2.xyz = (r2.xyz) * (v3.www);
    r2.xyz = (r0.www) * (r2.xyz);
    r2.xyz = (r0.zzz) * (v3.xyz) + (r2.xyz);
    r2.xyz = (v2.xyz) * (r1.xxx) + (r2.xyz);
    r3.xyz = normalize(r2.xyz);
    r2.xyz = normalize(c[17].xyz);
    r0.z = dot(-(r2.xyz), r3.xyz);
    r0.z = (r0.z) + (r0.z);
    r4.xyz = (r3.xyz) * (-(r0.zzz)) + (-(r2.xyz));
    r5.xyz = normalize(v1.xyz);
    r0.z = saturate(dot(r4.xyz, -(r5.xyz)));
    r0.w = dot(r2.xyz, r5.xyz);
    r1.x = saturate(dot(r3.xyz, r2.xyz));
    r0.w = saturate((r0.w) * (c2.x) + (c2.x));
    r2.yw = c2.yw;
    r3.w = lerp(c[25].x, r2.y, r0.w);
    r0.w = (r0.w) + (c2.w);
    r2.x = pow(abs(r0.z), r3.w);
    r0.z = max(abs(r1.z), abs(r1.w));
    r2.y = max(abs(r1.y), r0.z);
    r0.z = 1.0f / (r2.y);
    r4.xyz = (r1.yzw) * (c[5].xyz);
    r4.xyz = (r4.xyz) * (r0.zzz) + (v5.xyz);
    r4 = tex3D(s11, r4.xyz);
    r4.xyz = (r4.www) * (c[19].xyz);
    r5.xyz = (r4.www) * (c[18].xyz);
    r5.xyz = (r5.xyz) * (c[21].xxx);
    r5.xyz = (r1.xxx) * (r5.xyz);
    r4.xyz = (r4.xyz) * (c[21].yyy);
    r2.xyz = (r2.xxx) * (r4.xyz);
    r2.xyz = (r0.www) * (r2.xyz);
    r2.xyz = (r2.xyz) * (c[24].xxx);
    r4 = tex2D(s2, r0.xy);
    r0 = tex2D(s3, r0.xy);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r4.xyz = (r4.xyz) * (r4.xyz);
    r2.xyz = (r2.xyz) * (r4.xyz);
    r0.w = max(abs(r3.y), abs(r3.z));
    r1.x = max(abs(r3.x), r0.w);
    r3.xyz = (r3.xyz) * (c[5].xyz);
    r0.w = 1.0f / (r1.x);
    r3.xyz = (r3.xyz) * (r0.www) + (v5.xyz);
    r3 = tex3D(s11, r3.xyz);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r3.xyz = (r3.xyz) * (c0.xxx) + (r5.xyz);
    r0.xyz = (r3.xyz) * (r0.xyz) + (r2.xyz);
    r2.xyz = max(r0.xyz, c0.yyy);
    r0 = (c[7]) + (-(v1.yyyy));
    r3 = (r0) * (r0);
    r4 = (c[6]) + (-(v1.xxxx));
    r3 = (r4) * (r4) + (r3);
    r5 = (c[8]) + (-(v1.zzzz));
    r3 = (r5) * (r5) + (r3);
    r6.x = rsqrt(r3.x);
    r6.y = rsqrt(r3.y);
    r6.z = rsqrt(r3.z);
    r6.w = rsqrt(r3.w);
    r3 = saturate((r3) * (c[9]) + (r2.wwww));
    r0 = (r0) * (r6);
    r0 = (r1.zzzz) * (r0);
    r4 = (r4) * (r6);
    r5 = (r5) * (r6);
    r0 = (r4) * (r1.yyyy) + (r0);
    r0 = saturate((r5) * (r1.wwww) + (r0));
    r0 = (r3) * (r0);
    r1.x = dot(c[10], r0);
    r1.y = dot(c[11], r0);
    r1.z = dot(c[20], r0);
    r0.xyz = (r2.xyz) * (r1.xyz) + (r2.xyz);
    r0.w = v1.w;
    r1.xyz = lerp(v0.xyz, r0.xyz, r0.www);
    r0.xyz = max(((r1.xyz) * (c[23].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    oC0.x = 1.0f / (r0.x);
    r0.x = rsqrt(r0.y);
    r0.y = rsqrt(r0.z);
    oC0.z = 1.0f / (r0.y);
    oC0.y = 1.0f / (r0.x);
    oC0.w = c2.w;

    return oC0;
}
