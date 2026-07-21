// Mechanically reconstructed from 0xB606D7B0.ps_3_0.cso.
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
    float4 oC0 = 0.0f;

    r0.x = (c[5].x) * (v4.x);
    r1.x = c0.x;
    r0.w = (r0.x) * (r1.x) + (c[6].x);
    r1.y = c[5].y;
    r2.zw = (v4.yy) * (r1.yy) + (c[7].yw);
    r3.xyz = (c0.yzw) + (v4.xxx);
    r4.xyz = (r3.xyz) * (c[5].xxx);
    r2.xy = (r4.yz) * (r1.xx) + (c[7].xz);
    r0.z = (r4.x) * (r1.x) + (c[6].z);
    r1.xz = float2(((r3.z) >= 0.0f ? (r2.y) : (r2.x)), ((r3.z) >= 0.0f ? (r2.w) : (r2.z)));
    r0.xy = (v4.yy) * (r1.yy) + (c[6].yw);
    r0.yz = float2(((r3.y) >= 0.0f ? (r1.x) : (r0.z)), ((r3.y) >= 0.0f ? (r1.z) : (r0.y)));
    r0.xy = float2(((r3.x) >= 0.0f ? (r0.y) : (r0.w)), ((r3.x) >= 0.0f ? (r0.z) : (r0.x)));
    r0.zw = (r0.xy) * (c[21].xx);
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
    r1.yzw = (r1.zwy) * (v3.zxy) + (-(r2.xyz));
    r1.yzw = (r1.yzw) * (v3.www);
    r1.yzw = (r0.www) * (r1.yzw);
    r1.yzw = (r0.zzz) * (v3.xyz) + (r1.yzw);
    r1.xyz = (v2.xyz) * (r1.xxx) + (r1.yzw);
    r2.xyz = normalize(r1.xyz);
    r1.xyz = normalize(v1.xyz);
    r0.z = dot(r1.xyz, r2.xyz);
    r0.z = (r0.z) + (r0.z);
    r0.z = (r2.x) * (-(r0.z)) + (r1.x);
    r0.z = (r0.z) * (c[20].x);
    r0.w = c1.w;
    r0.z = (r0.z) * (r0.w) + (c[22].y);
    r0.x = (r0.z) * (c[23].x);
    r1.xy = max(r0.xy, c3.xx);
    r1.z = -(c1.z);
    r0.x = dot(r1.xxxz, c[9]);
    r0.y = dot(r1.xxxz, c[10]);
    r0.z = dot(r1.xxxz, c[11]);
    oC0.w = r1.y;
    r0.w = v1.w;
    r1.xyz = lerp(v0.xyz, r0.xyz, r0.www);
    r0.xyz = max(((r1.xyz) * (c[8].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    oC0.x = 1.0f / (r0.x);
    r0.x = rsqrt(r0.y);
    r0.y = rsqrt(r0.z);
    oC0.z = 1.0f / (r0.y);
    oC0.y = 1.0f / (r0.x);

    return oC0;
}
