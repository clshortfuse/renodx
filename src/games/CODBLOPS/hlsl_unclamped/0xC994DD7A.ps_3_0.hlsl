// Mechanically reconstructed from 0xC994DD7A.ps_3_0.cso.
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
    const float4 c0 = float4(-2.0f, 3.0f, 0.0f, 0.25f);
    const float4 c1 = float4(7.0f, 0.5f, 2.0f, -1.0f);
    const float4 c2 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c3 = float4(0.142857f, 8.0f, 6.375f, 31.875f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (c[21].xy) * (v6.ww);
    r0.zw = c0.zz;
    r1 = (r0.xyww) + (v6);
    r0 = (-(r0)) + (v6);
    r0 = tex2Dproj(s1, r0);
    r0.y = r0.x;
    r1 = tex2Dproj(s1, r1);
    r0.x = r1.x;
    r1.xy = (c[21].zw) * (v6.ww);
    r1.zw = c0.zz;
    r2 = (r1.xyww) + (v6);
    r1 = (-(r1)) + (v6);
    r1 = tex2Dproj(s1, r1);
    r0.w = r1.x;
    r1 = tex2Dproj(s1, r2);
    r0.z = r1.x;
    r0.x = dot(r0, c0.wwww);
    r0.yzw = (c[6].xyz) + (-(v1.xyz));
    r1.x = dot(r0.yzw, r0.yzw);
    r1.x = rsqrt(r1.x);
    r0.yzw = (r0.yzw) * (r1.xxx);
    r1.x = 1.0f / (r1.x);
    r1.z = dot(r0.yzw, c[9].xyz);
    r1.z = saturate((r1.z) * (c[10].x) + (c[10].y));
    r1.z = (r1.z) * (c[10].w);
    r1.w = dot(v2.xyz, v2.xyz);
    r1.w = rsqrt(r1.w);
    r2.xyz = (r1.www) * (v2.xyz);
    r3.x = max(abs(r2.y), abs(r2.z));
    r4.x = max(abs(r2.x), r3.x);
    r2.w = 1.0f / (r4.x);
    r3.xyz = (r2.xyz) * (c[5].xyz);
    r3.xyz = (r3.xyz) * (r2.www) + (v5.xyz);
    r3 = tex3D(s11, r3.xyz);
    r2.w = lerp(r3.w, r0.x, r1.z);
    r1.y = (r1.x) * (r1.x);
    r0.x = dot(c[11].yz, r1.xy) + (c[11].x);
    r1.xy = saturate((r1.xx) * (c[20].xy) + (c[20].zw));
    r3.xy = (r1.xy) * (r1.xy);
    r1.xy = (r1.xy) * (c0.xx) + (c0.yy);
    r1.xy = (r3.xy) * (r1.xy);
    r0.x = (r0.x) * (r1.x);
    r0.x = (r1.y) * (r0.x);
    r0.x = (r2.w) * (r0.x);
    r1.xyz = (r0.xxx) * (c[7].xyz);
    r1.xyz = (r1.xyz) * (c[8].xxx);
    r3.xyz = (r2.zxy) * (v3.yzx);
    r2.xyz = (r2.yzx) * (v3.zxy) + (-(r3.xyz));
    r2.xyz = (r2.xyz) * (v3.www);
    r3 = tex2D(s3, v4.xy);
    r3.xy = (r3.wy) * (c2.xy) + (c2.zw);
    r3.xy = (r3.xy) * (c1.yy) + (c1.yy);
    r3.xy = (r3.xy) * (c1.zz) + (c1.ww);
    r2.xyz = (r2.xyz) * (r3.yyy);
    r2.xyz = (r3.xxx) * (v3.xyz) + (r2.xyz);
    r2.xyz = (v2.xyz) * (r1.www) + (r2.xyz);
    r3.xyz = normalize(r2.xyz);
    r0.x = saturate(dot(r3.xyz, r0.yzw));
    r0.xyz = (r1.xyz) * (r0.xxx);
    r0.xyz = (r0.xyz) * (c3.xxx);
    r0.w = max(abs(r3.y), abs(r3.z));
    r1.x = max(abs(r3.x), r0.w);
    r0.w = 1.0f / (r1.x);
    r1.xyz = (r3.xyz) * (c[5].xyz);
    r1.xyz = (r1.xyz) * (r0.www) + (v5.xyz);
    r1 = tex3D(s11, r1.xyz);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r0.xyz = (r1.xyz) * (c3.www) + (r0.xyz);
    r1.xyz = normalize(v1.xyz);
    r0.w = dot(r1.xyz, r3.xyz);
    r0.w = (r0.w) + (r0.w);
    r1.xyz = (r3.xyz) * (-(r0.www)) + (r1.xyz);
    r1.w = c3.y;
    r1 = texCUBElod(s15, r1);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r1.xyz = (r1.xyz) * (c3.yyy);
    r2 = tex3D(s11, v5.xyz);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r1.xyz = (r1.xyz) * (r2.xyz);
    r1.xyz = (r1.xyz) * (c3.zzz);
    r2 = tex2D(s4, v4.xy);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r1.xyz = (r1.xyz) * (r2.xyz);
    r2 = tex2D(s5, v4.xy);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r0.xyz = (r0.xyz) * (r2.xyz) + (r1.xyz);
    r1.xyz = max(r0.xyz, c0.zzz);
    r0.w = c[22].w;
    r0.xy = (r0.ww) * (c[28].xy);
    r0.xy = (r0.xy) * (c[27].xx);
    r0.xy = (v4.xy) * (c[27].xx) + (r0.xy);
    r2 = tex2D(s7, r0.xy);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r0.xyz = (r0.xyz) * (v7.xxx);
    r0.xyz = (r0.xyz) * (c1.xxx);
    r2.xy = (r0.ww) * (c[29].xy);
    r2.xy = (r2.xy) * (c[30].xx);
    r2.xy = (v4.xy) * (c[30].xx) + (r2.xy);
    r2 = tex2D(s6, r2.xy);
    r1.xyz = (r0.xyz) * (-(r2.xyz)) + (r1.xyz);
    r0.xyz = (r0.xyz) * (r2.xyz);
    r2 = tex2D(s2, v4.xy);
    r0.w = (-(r2.x)) + (-(c1.w));
    r0.xyz = (r0.www) * (r1.xyz) + (r0.xyz);
    r0.w = -(c1.w);
    r1.x = dot(r0, c[24]);
    r1.y = dot(r0, c[25]);
    r1.z = dot(r0, c[26]);
    r0.w = v1.w;
    r2.xyz = lerp(v0.xyz, r1.xyz, r0.www);
    r0.xyz = max(((r2.xyz) * (c[23].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    oC0.x = 1.0f / (r0.x);
    r0.x = rsqrt(r0.y);
    r0.y = rsqrt(r0.z);
    oC0.z = 1.0f / (r0.y);
    oC0.y = 1.0f / (r0.x);
    oC0.w = -(c1.w);

    return oC0;
}
