// Mechanically reconstructed from 0xDFBAF431.ps_3_0.cso.
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
    const float4 c0 = float4(4.0f, -0.25f, -0.5f, -0.75f);
    const float4 c1 = float4(0.125f, 2.0f, -1.0f, 9.99999997e-07f);
    const float4 c2 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c3 = float4(0.0f, 0.0f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 oC0 = 0.0f;

    r0.x = (c[20].x) * (v4.x);
    r1.x = c0.x;
    r0.w = (r0.x) * (r1.x) + (c[21].x);
    r1.y = c[20].y;
    r2.zw = (v4.yy) * (r1.yy) + (c[22].yw);
    r3.xyz = (c0.yzw) + (v4.xxx);
    r4.xyz = (r3.xyz) * (c[20].xxx);
    r2.xy = (r4.yz) * (r1.xx) + (c[22].xz);
    r0.z = (r4.x) * (r1.x) + (c[21].z);
    r1.xz = float2(((r3.z) >= 0.0f ? (r2.y) : (r2.x)), ((r3.z) >= 0.0f ? (r2.w) : (r2.z)));
    r0.xy = (v4.yy) * (r1.yy) + (c[21].yw);
    r0.yz = float2(((r3.y) >= 0.0f ? (r1.x) : (r0.z)), ((r3.y) >= 0.0f ? (r1.z) : (r0.y)));
    r0.xy = float2(((r3.x) >= 0.0f ? (r0.y) : (r0.w)), ((r3.x) >= 0.0f ? (r0.z) : (r0.x)));
    r0.zw = (r0.xy) * (c[28].xx);
    r1 = tex2D(s1, r0.zw);
    r0.zw = (r1.wy) * (c2.xy) + (c2.zw);
    r0.zw = (r0.zw) * (-(c0.zz)) + (-(c0.zz));
    r1.xy = ddx(v4.xy);
    r1.xy = (r1.xy) * (c1.xx);
    r1.zw = ddy(v4.xy);
    r1.zw = (r1.zw) * (c1.xx);
    r2 = tex2Dgrad(s2, r0.xy, r1.xy, r1.zw);
    r1 = tex2Dgrad(s3, r0.xy, r1.xy, r1.zw);
    r0.y = (r1.w) * (r1.w);
    r1.xy = (r2.wy) * (c2.xy) + (c2.zw);
    r1.xy = (r1.xy) * (-(c0.zz)) + (-(c0.zz));
    r1.xy = (r1.xy) * (c1.yy) + (c1.zz);
    r0.zw = (r0.zw) * (c1.yy) + (r1.xy);
    r0.zw = (r0.zw) + (c1.zz);
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
    r2.xyz = normalize(v1.xyz);
    r0.z = dot(r2.xyz, r3.xyz);
    r0.z = (r0.z) + (r0.z);
    r0.z = (r3.x) * (-(r0.z)) + (r2.x);
    r0.z = (r0.z) * (c[27].x);
    r2.zw = c1.zw;
    r0.z = (r0.z) * (r2.w) + (c[29].y);
    r0.x = (r0.z) * (c[30].x);
    r2.xy = max(r0.xy, c3.xx);
    r0 = (c[6]) + (-(v1.yyyy));
    r3 = (r0) * (r0);
    r4 = (c[5]) + (-(v1.xxxx));
    r3 = (r4) * (r4) + (r3);
    r5 = (c[7]) + (-(v1.zzzz));
    r3 = (r5) * (r5) + (r3);
    r6.x = rsqrt(r3.x);
    r6.y = rsqrt(r3.y);
    r6.z = rsqrt(r3.z);
    r6.w = rsqrt(r3.w);
    r3 = saturate((r3) * (c[8]) + (-(r2.zzzz)));
    r0 = (r0) * (r6);
    r0 = (r1.zzzz) * (r0);
    r4 = (r4) * (r6);
    r5 = (r5) * (r6);
    r0 = (r4) * (r1.yyyy) + (r0);
    r0 = saturate((r5) * (r1.wwww) + (r0));
    r0 = (r3) * (r0);
    r1.x = dot(c[9], r0);
    r1.y = dot(c[10], r0);
    r1.z = dot(c[11], r0);
    r0.xyz = (r2.xxx) * (r1.xyz) + (r2.xxx);
    oC0.w = r2.y;
    r0.w = -(c1.z);
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

    return oC0;
}
