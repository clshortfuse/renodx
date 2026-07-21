// Mechanically reconstructed from 0x69125381.ps_3_0.cso.
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
    const float4 c1 = float4(6.28318548f, 0.25f, 3.14159274f, -3.14159274f);
    const float4 c2 = float4(0.159154937f, 0.5f, -0.5f, 9.99999997e-07f);
    const float4 c3 = float4(0.5f, 2.0f, -1.0f, 1.0f);
    const float4 c4 = float4(3.5f, 1.0f, 0.0f, 0.600000024f);
    const float4 c12 = float4(2.5f, -2.5f, 5.0f, 0.833333313f);
    const float4 c13 = float4(1.5f, 0.0f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = tex2D(s3, v4.xy);
    r0.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0.xy = (r0.xy) * (c3.xx) + (c3.xx);
    r0.xy = (r0.xy) * (c3.yy) + (c3.zz);
    r1 = tex2D(s2, v4.xy);
    r0.zw = (r1.wy) * (c0.xy) + (c0.zw);
    r0.zw = (r0.zw) * (c3.xx) + (c3.xx);
    r0.zw = (r0.zw) * (c3.yy) + (c3.zz);
    r1 = tex2D(s1, v4.xy);
    r2.xyz = (r1.xyz) * (c1.xxy);
    r2.w = lerp(r1.x, r1.y, c3.x);
    r1.x = (r2.w) * (c12.x) + (c12.y);
    r1.yw = c3.yw;
    r1.yz = (c[5].ww) * (r1.yy) + (r2.xy);
    r1.z = (r1.z) * (c2.x) + (c2.y);
    r1.y = (r1.y) + (c1.z);
    r1.y = (r1.y) * (c2.x) + (c2.y);
    r1.y = frac(r1.y);
    r1.y = (r1.y) * (c1.x) + (c1.w);
    r3.x = cos(r1.y);
    r1.y = (r3.x) * (c2.y) + (c2.z);
    r1.z = frac(r1.z);
    r1.z = (r1.z) * (c1.x) + (c1.w);
    r3.x = cos(r1.z);
    r1.z = (r3.x) * (c3.x) + (c3.x);
    r1.w = (r1.w) + (-(c[6].y));
    r1.w = saturate(r1.w);
    r1.z = (r1.z) * (r1.w);
    r1.y = (r1.w) * (r1.y) + (c3.w);
    r0.zw = (r0.zw) * (r1.zz);
    r0.xy = (r1.yy) * (r0.xy) + (r0.zw);
    r3 = tex2D(s4, v4.xy);
    r0.zw = (r3.wy) * (c0.xy) + (c0.zw);
    r0.zw = (r0.zw) * (c3.xx) + (c3.xx);
    r0.zw = (r0.zw) * (c3.yy) + (c3.zz);
    r1.yz = lerp(r0.zw, r0.xy, c[6].zz);
    r0.x = dot(v2.xyz, v2.xyz);
    r0.x = rsqrt(r0.x);
    r0.yzw = (r0.xxx) * (v2.xyz);
    r2.xyw = (r0.wyz) * (v3.yzx);
    r0.yzw = (r0.zwy) * (v3.zxy) + (-(r2.xyw));
    r0.yzw = (r0.yzw) * (v3.www);
    r0.yzw = (r1.zzz) * (r0.yzw);
    r0.yzw = (r1.yyy) * (v3.xyz) + (r0.yzw);
    r0.xyz = (v2.xyz) * (r0.xxx) + (r0.yzw);
    r3.xyz = normalize(r0.xyz);
    r0.xyz = normalize(v1.xyz);
    r0.y = dot(r0.xyz, r3.xyz);
    r0.z = (r0.y) + (r0.y);
    r0.y = saturate(r0.y);
    r0.y = (-(r0.y)) + (c3.w);
    r0.x = (r3.x) * (-(r0.z)) + (r0.x);
    r0.x = (r0.x) * (c[11].x);
    r0.x = (r0.x) * (c2.w);
    r0.z = (r0.y) * (r0.y);
    r0.y = (r0.y) * (r0.z);
    r3 = tex2D(s5, v4.xy);
    r0.z = (r3.w) * (c4.x) + (c4.y);
    r0.z = 1.0f / (r0.z);
    r0.y = (r0.y) * (r0.z);
    r1.yzw = lerp(r3.xyz, c3.www, r0.yyy);
    r0.yzw = (r0.xxx) * (r1.yzw);
    r1.yzw = (r0.xxx) * (-(r1.yzw)) + (c3.www);
    r0.xyz = (c[6].xxx) * (r1.yzw) + (r0.yzw);
    r1.yzw = (r2.zzz) * (r0.xyz);
    r0.xyz = (r3.xyz) * (r0.xyz);
    r2.xyz = max(r0.xyz, c4.zzz);
    r0.xyz = max(r1.yzw, c4.zzz);
    r1.yzw = lerp(r2.xyz, r0.xyz, c4.www);
    r1.yzw = (r1.yzw) * (c[20].xyz) + (-(r2.xyz));
    r3.z = c[6].z;
    r3.x = c[21].x;
    r0.w = saturate((r3.z) * (r3.x) + (c[22].x));
    r0.w = (r0.w) * (c12.z) + (r1.x);
    r1.x = saturate((r0.w) * (c12.w));
    r0.w = (r0.w) + (-(c4.w));
    r0.w = saturate((r0.w) * (c13.x));
    r1.x = (r1.x) * (r1.x);
    r1.xyz = (r1.xxx) * (r1.yzw) + (r2.xyz);
    r2.xyz = lerp(r1.xyz, r0.xyz, r0.www);
    r2.w = c3.w;
    r0.x = dot(r2, c[8]);
    r0.y = dot(r2, c[9]);
    r0.z = dot(r2, c[10]);
    r0.w = v1.w;
    r1.xyz = lerp(v0.xyz, r0.xyz, r0.www);
    r0.xyz = max(((r1.xyz) * (c[7].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    oC0.x = 1.0f / (r0.x);
    r0.x = rsqrt(r0.y);
    r0.y = rsqrt(r0.z);
    oC0.z = 1.0f / (r0.y);
    oC0.y = 1.0f / (r0.x);
    oC0.w = c3.w;

    return oC0;
}
