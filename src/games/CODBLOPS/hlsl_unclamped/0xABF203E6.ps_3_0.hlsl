// Mechanically reconstructed from 0xABF203E6.ps_3_0.cso.
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

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD4;
    float4 v4 : TEXCOORD5;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c0 = float4(1.0f, 0.0f, 8.0f, 31.875f);
    const float4 c1 = float4(-2.0f, 3.0f, 9.99999975e-06f, 1e-15f);
    const float4 c2 = float4(1.0f, 1.44269502f, 0.100000001f, 0.25f);
    const float4 c3 = float4(1.16412354f, 1.59579468f, -0.87065506f, 0.0f);
    const float4 c4 = float4(1.16412354f, -0.813476562f, -0.391448975f, 0.529705048f);
    const float4 c12 = float4(1.16412354f, 2.01782227f, -1.08166885f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xyz = (c[21].xyz) + (-(v1.xyz));
    r0.w = dot(r0.xyz, r0.xyz);
    r0.w = rsqrt(r0.w);
    r0.xyz = (r0.xyz) * (r0.www);
    r1.x = 1.0f / (r0.w);
    r0.w = dot(-(v1.xyz), -(v1.xyz));
    r0.w = rsqrt(r0.w);
    r2.xyz = (-(v1.xyz)) * (r0.www) + (r0.xyz);
    r3.xyz = (r0.www) * (-(v1.xyz));
    r4.xyz = normalize(r2.xyz);
    r2.xyz = normalize(v2.xyz);
    r0.w = saturate(dot(r2.xyz, r4.xyz));
    r1.z = (r0.w) + (r0.w);
    r0.w = (r0.w) * (r0.w) + (c1.w);
    r0.w = 1.0f / (r0.w);
    r1.w = saturate(dot(r2.xyz, r3.xyz));
    r2.w = 1.0f / (r1.w);
    r1.z = (r1.z) * (r2.w);
    r0.x = saturate(dot(r2.xyz, r0.xyz));
    r2.w = min(r1.w, r0.x);
    r0.y = max(c2.z, r1.w);
    r0.y = 1.0f / (r0.y);
    r0.y = rsqrt(r0.y);
    r0.y = 1.0f / (r0.y);
    r0.z = saturate((r1.z) * (r2.w));
    r0.z = (r0.x) * (r0.z);
    r0.z = rsqrt(r0.z);
    r0.z = 1.0f / (r0.z);
    r3 = tex2D(s6, v3.xy);
    r1.z = (r3.x) * (r3.x);
    r2.w = max(c1.z, r1.z);
    r1.z = (r2.w) * (r2.w);
    r1.z = 1.0f / (r1.z);
    r1.w = (-(r0.w)) + (c2.x);
    r0.w = (r0.w) * (r0.w);
    r1.w = (r1.z) * (r1.w);
    r1.w = (r1.w) * (c2.y);
    r1.w = exp2(r1.w);
    r0.w = (r0.w) * (r1.w);
    r0.z = (r0.z) * (r0.w);
    r1.y = (r1.x) * (r1.x);
    r0.w = dot(c[25].yz, r1.xy) + (c[25].x);
    r1.xy = saturate((r1.xx) * (c[26].xy) + (c[26].zw));
    r3.xy = (r1.xy) * (r1.xy);
    r1.xy = (r1.xy) * (c1.xx) + (c1.yy);
    r1.xy = (r3.xy) * (r1.xy);
    r0.w = (r0.w) * (r1.x);
    r0.w = (r1.y) * (r0.w);
    r1.x = max(abs(r2.y), abs(r2.z));
    r3.x = max(abs(r2.x), r1.x);
    r1.x = 1.0f / (r3.x);
    r3.xyz = (r2.xyz) * (c[5].xyz);
    r1.xyw = (r3.xyz) * (r1.xxx) + (v4.xyz);
    r3 = tex3D(s11, r1.xyw);
    r0.w = (r0.w) * (r3.w);
    r1.xyw = (r3.xyz) * (r3.xyz);
    r3.xyz = (r0.www) * (c[23].xyz);
    r4.xyz = (r0.www) * (c[22].xyz);
    r4.xyz = (r4.xyz) * (c[24].xxx);
    r4.xyz = (r0.xxx) * (r4.xyz);
    r1.xyw = (r1.xyw) * (c0.www) + (r4.xyz);
    r3.xyz = (r3.xyz) * (c[24].yyy);
    r0.xzw = (r0.zzz) * (r3.xyz);
    r0.xyz = (r0.yyy) * (r0.xzw);
    r0.xyz = (r1.zzz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c2.www);
    r3 = tex2D(s4, v3.xy);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r0.xyz = (r0.xyz) * (r3.xyz);
    r3.xy = lerp(c[28].xy, c[28].zw, v3.xy);
    r4 = tex2D(s2, r3.xy);
    r4.y = r4.x;
    r5 = tex2D(s3, r3.xy);
    r3 = tex2D(s1, r3.xy);
    r4.xw = (r3.xx) * (c0.xy) + (c0.yx);
    r4.z = r5.x;
    r3.y = dot(c4, r4);
    r3.x = dot(c3.xyz, r4.xyw);
    r3.z = dot(c12.xyz, r4.xzw);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r3.xyz = (r3.xyz) * (c[30].xxx);
    r4 = tex2D(s5, v3.xy);
    r5 = (r4) * (r4);
    r4.w = (r4.w) * (-(r4.w)) + (c[31].x);
    r4.xyz = (r3.xyz) * (c0.zzz) + (-(r5.xyz));
    r3 = (c[27].xxxx) * (r4) + (r5);
    r0.xyz = (r0.xyz) * (r3.www);
    r3.xyz = (r1.xyw) * (r3.xyz) + (r0.xyz);
    r0 = max(r3, c0.yyyy);
    r1 = (c[7]) + (-(v1.yyyy));
    r3 = (r1) * (r1);
    r4 = (c[6]) + (-(v1.xxxx));
    r3 = (r4) * (r4) + (r3);
    r5 = (c[8]) + (-(v1.zzzz));
    r3 = (r5) * (r5) + (r3);
    r6.x = rsqrt(r3.x);
    r6.y = rsqrt(r3.y);
    r6.z = rsqrt(r3.z);
    r6.w = rsqrt(r3.w);
    r7.x = c2.x;
    r3 = saturate((r3) * (c[9]) + (r7.xxxx));
    r1 = (r1) * (r6);
    r1 = (r2.yyyy) * (r1);
    r4 = (r4) * (r6);
    r5 = (r5) * (r6);
    r1 = (r4) * (r2.xxxx) + (r1);
    r1 = saturate((r5) * (r2.zzzz) + (r1));
    r1 = (r3) * (r1);
    r2.x = dot(c[10], r1);
    r2.y = dot(c[11], r1);
    r2.z = dot(c[20], r1);
    r0.xyz = (r0.xyz) * (r2.xyz) + (r0.xyz);
    oC0.w = r0.w;
    r0.w = v1.w;
    r1.xyz = lerp(v0.xyz, r0.xyz, r0.www);
    r0.xyz = max(((r1.xyz) * (c[29].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    oC0.x = 1.0f / (r0.x);
    r0.x = rsqrt(r0.y);
    r0.y = rsqrt(r0.z);
    oC0.z = 1.0f / (r0.y);
    oC0.y = 1.0f / (r0.x);

    return oC0;
}
