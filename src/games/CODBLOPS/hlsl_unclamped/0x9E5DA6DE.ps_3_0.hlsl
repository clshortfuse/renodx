// Mechanically reconstructed from 0x9E5DA6DE.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler2D s3 : register(s3);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD3;
    float4 v4 : TEXCOORD4;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(0.5f, 2.0f, -1.0f, 9.99999997e-07f);
    const float4 c2 = float4(0.0f, 1.0f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 oC0 = 0.0f;

    r0.x = dot(v2.xyz, v2.xyz);
    r0.x = rsqrt(r0.x);
    r0.yzw = (r0.xxx) * (v2.xyz);
    r1.xyz = (r0.wyz) * (v3.yzx);
    r0.yzw = (r0.zwy) * (v3.zxy) + (-(r1.xyz));
    r0.yzw = (r0.yzw) * (v3.www);
    r1.xy = (c[10].xx) * (v4.xy);
    r1 = tex2D(s1, r1.xy);
    r1.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r1.xy = (r1.xy) * (c1.xx) + (c1.xx);
    r1.xy = (r1.xy) * (c1.yy) + (c1.zz);
    r0.yzw = (r0.yzw) * (r1.yyy);
    r0.yzw = (r1.xxx) * (v3.xyz) + (r0.yzw);
    r0.xyz = (v2.xyz) * (r0.xxx) + (r0.yzw);
    r1.xyz = normalize(r0.xyz);
    r0.xyz = normalize(v1.xyz);
    r0.y = dot(r0.xyz, r1.xyz);
    r0.y = (r0.y) + (r0.y);
    r0.x = (r1.x) * (-(r0.y)) + (r0.x);
    r0.x = (r0.x) * (c1.w);
    r1 = tex2D(s3, v4.xy);
    r0.yzw = (r1.xyz) * (c[9].xxx);
    r0.xyz = (r0.xxx) * (r0.yzw) + (c[11].yyy);
    r0.xyz = (r0.xyz) * (c[20].xxx);
    r1.xy = ddx(v4.xy);
    r1.zw = ddy(v4.xy);
    r1 = tex2Dgrad(s2, v4.xy, r1.xy, r1.zw);
    r0.w = (r1.w) * (r1.w);
    r1 = max(r0, c2.xxxx);
    r0 = (r1.xyzx) * (c2.yyyx) + (c2.xxxy);
    oC0.w = r1.w;
    r1.x = dot(r0, c[6]);
    r1.y = dot(r0, c[7]);
    r1.z = dot(r0, c[8]);
    r0.w = v1.w;
    r2.xyz = lerp(v0.xyz, r1.xyz, r0.www);
    r0.xyz = max(((r2.xyz) * (c[5].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    oC0.x = 1.0f / (r0.x);
    r0.x = rsqrt(r0.y);
    r0.y = rsqrt(r0.z);
    oC0.z = 1.0f / (r0.y);
    oC0.y = 1.0f / (r0.x);

    return oC0;
}
