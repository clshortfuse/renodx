// Mechanically reconstructed from 0xE1DE4114.ps_3_0.cso.
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
    const float4 c0 = float4(31.875f, 0.0f, 0.0f, 0.0f);
    const float4 c1 = float4(-2.0f, 3.0f, 0.0f, 0.25f);
    const float4 c2 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c3 = float4(0.5f, 2.0f, -1.0f, 1.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xyz = (c[6].xyz) + (-(v1.xyz));
    r0.w = dot(r0.xyz, r0.xyz);
    r0.w = rsqrt(r0.w);
    r1.x = 1.0f / (r0.w);
    r0.xyz = (r0.xyz) * (r0.www);
    r1.y = (r1.x) * (r1.x);
    r0.w = dot(c[20].yz, r1.xy) + (c[20].x);
    r1.xy = saturate((r1.xx) * (c[21].xy) + (c[21].zw));
    r1.zw = (r1.xy) * (r1.xy);
    r1.xy = (r1.xy) * (c1.xx) + (c1.yy);
    r1.xy = (r1.zw) * (r1.xy);
    r0.w = (r0.w) * (r1.x);
    r0.w = (r1.y) * (r0.w);
    r1.xy = (c[22].xy) * (v6.ww);
    r1.zw = c1.zz;
    r2 = (r1.xyww) + (v6);
    r1 = (-(r1)) + (v6);
    r1 = tex2Dproj(s1, r1);
    r1.y = r1.x;
    r2 = tex2Dproj(s1, r2);
    r1.x = r2.x;
    r2.xy = (c[22].zw) * (v6.ww);
    r2.zw = c1.zz;
    r3 = (r2.xyww) + (v6);
    r2 = (-(r2)) + (v6);
    r2 = tex2Dproj(s1, r2);
    r1.w = r2.x;
    r2 = tex2Dproj(s1, r3);
    r1.z = r2.x;
    r1.x = dot(r1, c1.wwww);
    r1.y = dot(v2.xyz, v2.xyz);
    r1.y = rsqrt(r1.y);
    r2.xyz = (r1.yyy) * (v2.xyz);
    r1.z = max(abs(r2.y), abs(r2.z));
    r3.x = max(abs(r2.x), r1.z);
    r1.z = 1.0f / (r3.x);
    r3.xyz = (r2.xyz) * (c[5].xyz);
    r3.xyz = (r3.xyz) * (r1.zzz) + (v5.xyz);
    r3 = tex3D(s11, r3.xyz);
    r1.z = dot(r0.xyz, c[10].xyz);
    r1.z = saturate((r1.z) * (c[11].x) + (c[11].y));
    r1.z = (r1.z) * (c[11].w);
    r2.w = lerp(r3.w, r1.x, r1.z);
    r0.w = (r0.w) * (r2.w);
    r1.xzw = (r0.www) * (c[8].xyz);
    r3.xyz = (r0.www) * (c[7].xyz);
    r3.xyz = (r3.xyz) * (c[9].xxx);
    r1.xzw = (r1.xzw) * (c[9].yyy);
    r4.xyz = (r2.zxy) * (v3.yzx);
    r2.xyz = (r2.yzx) * (v3.zxy) + (-(r4.xyz));
    r2.xyz = (r2.xyz) * (v3.www);
    r4.x = (c[23].w) + (v4.x);
    r4.y = v4.y;
    r4.zw = frac(abs(r4.xy));
    r4.xy = float2(((r4.x) >= 0.0f ? (r4.z) : (-(r4.z))), ((r4.y) >= 0.0f ? (r4.w) : (-(r4.w))));
    r5 = tex2D(s2, r4.xy);
    r4.zw = (r5.wy) * (c2.xy) + (c2.zw);
    r4.zw = (r4.zw) * (c3.xx) + (c3.xx);
    r4.zw = (r4.zw) * (c3.yy) + (c3.zz);
    r4.zw = (r4.zw) + (r4.zw);
    r2.xyz = (r2.xyz) * (r4.www);
    r2.xyz = (r4.zzz) * (v3.xyz) + (r2.xyz);
    r2.xyz = (v2.xyz) * (r1.yyy) + (r2.xyz);
    r5.xyz = normalize(r2.xyz);
    r0.w = dot(-(r0.xyz), r5.xyz);
    r0.w = (r0.w) + (r0.w);
    r2.xyz = (r5.xyz) * (-(r0.www)) + (-(r0.xyz));
    r6.xyz = normalize(v1.xyz);
    r0.w = saturate(dot(r2.xyz, -(r6.xyz)));
    r1.y = dot(r0.xyz, r6.xyz);
    r0.x = saturate(dot(r5.xyz, r0.xyz));
    r0.xyz = (r3.xyz) * (r0.xxx);
    r1.y = saturate((r1.y) * (c3.x) + (c3.x));
    r2.x = c1.x;
    r3.x = lerp(c[26].x, -(r2.x), r1.y);
    r1.y = (r1.y) + (c3.w);
    r2.x = pow(abs(r0.w), r3.x);
    r1.xzw = (r1.xzw) * (r2.xxx);
    r1.xyz = (r1.yyy) * (r1.xzw);
    r1.xyz = (r1.xyz) * (c[25].xxx);
    r2 = tex2D(s3, r4.xy);
    r3 = tex2D(s4, r4.xy);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r1.xyz = (r1.xyz) * (r2.xyz);
    r0.w = max(abs(r5.y), abs(r5.z));
    r1.w = max(abs(r5.x), r0.w);
    r2.xyz = (r5.xyz) * (c[5].xyz);
    r0.w = 1.0f / (r1.w);
    r2.xyz = (r2.xyz) * (r0.www) + (v5.xyz);
    r2 = tex3D(s11, r2.xyz);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r0.xyz = (r2.xyz) * (c0.xxx) + (r0.xyz);
    r0.xyz = (r0.xyz) * (r3.xyz) + (r1.xyz);
    r1.xyz = max(r0.xyz, c1.zzz);
    r0.w = v1.w;
    r2.xyz = lerp(v0.xyz, r1.xyz, r0.www);
    r0.xyz = max(((r2.xyz) * (c[24].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    oC0.x = 1.0f / (r0.x);
    r0.x = rsqrt(r0.y);
    r0.y = rsqrt(r0.z);
    oC0.z = 1.0f / (r0.y);
    oC0.y = 1.0f / (r0.x);
    oC0.w = c3.w;

    return oC0;
}
