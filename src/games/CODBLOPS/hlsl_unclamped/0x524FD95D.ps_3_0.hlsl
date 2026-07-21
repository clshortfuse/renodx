// Mechanically reconstructed from 0x524FD95D.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler2D s12 : register(s12);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD2;
    float4 v5 : TEXCOORD3;
    float4 v6 : TEXCOORD5;
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
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(0.0f, 0.600000024f, 0.400000006f, 31.875f);
    const float4 c2 = float4(4.0f, -2.0f, 2.0f, 0.0f);
    const float4 c3 = float4(1.0f, 0.5f, 0.0f, 4.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 oC0 = 0.0f;

    r1 = (v6.xyzx) * (c3.xxxz) + (c3.zzzx);
    r0.w = dot(r1, c[22]);
    r0.w = 1.0f / (r0.w);
    r0.x = dot(r1, c[11]);
    r0.y = dot(r1, c[20]);
    r0 = (r0.wwww) * (r0.xxyy);
    r2 = (r0) * (c[23].zwxy);
    r2.x = log2(abs(r2.x));
    r2.y = log2(abs(r2.y));
    r2.z = log2(abs(r2.z));
    r2.w = log2(abs(r2.w));
    r2 = (r2) * (c[24].xxxx);
    r2.x = exp2(r2.x);
    r2.y = exp2(r2.y);
    r2.z = exp2(r2.z);
    r2.w = exp2(r2.w);
    r2.xy = (r2.zw) + (r2.xy);
    r2.x = log2(abs(r2.x));
    r2.y = log2(abs(r2.y));
    r2.xy = (r2.xy) * (c[24].yy);
    r2.x = exp2(r2.x);
    r2.y = exp2(r2.y);
    r2.z = dot(r1, c[21]);
    r0.z = (r2.x) * (c[25].x);
    r0.y = (r2.y) * (c[25].y) + (-(r0.z));
    r0.z = c[25].y;
    r0.z = (r2.y) * (r0.z) + (-(c[24].z));
    r0.y = 1.0f / (r0.y);
    r2.xy = abs(r0.xw);
    r3.w = saturate((r0.z) * (r0.y));
    r1 = c[9];
    r1 = saturate((r2.zyxz) * (r1) + (c[10]));
    r3.x = (r1.w) * (r1.x);
    r3.yz = r1.yz;
    r1 = (r3) * (r3);
    r3 = (c[25].zzzz) * (r3) + (c[25].wwww);
    r1 = (r1) * (r3);
    r0.y = (r1.z) * (r1.y);
    r0.z = abs(c[24].w);
    r2.w = (r2.z) * (r2.z);
    r0.y = ((-(r0.z)) >= 0.0f ? (r0.y) : (r1.w));
    r0.z = dot(c[8].yz, r2.zw) + (c[8].x);
    r0.z = (r0.y) * (r0.z);
    r2.w = (r1.x) * (r0.z);
    r1 = c[26];
    r1.x = dot(r0.xw, r1.xy) + (c[7].x);
    r1.y = dot(r0.xw, r1.zw) + (c[7].z);
    r0 = tex2D(s2, r1.xy);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r3.xyz = (r2.www) * (r0.xyz);
    r1 = tex2D(s12, v1.zw);
    r0.xy = (v1.zw) * (c3.xy);
    r0 = tex2D(s13, r0.xy);
    r2.xy = (v1.zw) * (c3.xy) + (c3.zy);
    r2 = tex2D(s13, r2.xy);
    r0.w = r2.y;
    r3.xyz = (r3.xyz) * (r1.yyy);
    r6.xy = (r0.yw) * (c2.xx) + (c2.yy);
    r1 = tex2D(s1, v1.xy);
    r4.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r0.w = dot(r6.xy, r6.xy) + (c1.x);
    r0.y = dot(r4.xy, r4.xy) + (c1.x);
    r0.w = exp2(-(r0.w));
    r0.y = exp2(-(r0.y));
    r0.w = (r0.w) * (c1.y) + (c1.z);
    r2.w = (r0.y) * (c1.y) + (c1.z);
    r1 = tex2D(s14, v1.zw);
    r5.xy = (r1.xy) * (c1.ww);
    r1.w = (r0.w) * (r2.w);
    r2.xy = (r2.xz) * (r5.yy);
    r0.w = dot(r6.xy, r4.xy) + (c1.x);
    r0.y = (r1.y) * (c1.w) + (-(r2.x));
    r0.w = saturate((r0.w) * (r1.w) + (r1.w));
    r0.y = (r2.z) * (-(r5.y)) + (r0.y);
    r2.xz = (r2.xy) * (c3.ww);
    r2.y = (r0.y) + (r0.y);
    r2.xyz = (r0.www) * (r2.xyz);
    r0.xy = (r0.xz) * (r5.xx);
    r0.w = (r1.x) * (c1.w) + (-(r0.x));
    r1.xz = (r2.ww) * (r0.xy);
    r0.w = (r0.z) * (-(r5.x)) + (r0.w);
    r0.xyz = v2.xyz;
    r0.xyz = (r4.xxx) * (v5.xyz) + (r0.xyz);
    r0.xyz = (r4.yyy) * (v4.xyz) + (r0.xyz);
    r5.xyz = (-(v6.xyz)) + (c[5].xyz);
    r4.xyz = normalize(r0.xyz);
    r0.xyz = normalize(r5.xyz);
    r1.y = (r2.w) * (r0.w);
    r0.w = saturate(dot(r0.xyz, r4.xyz));
    r2.xyz = (r1.xyz) * (c2.xzx) + (r2.xyz);
    r1.xyz = (r0.www) * (c[6].xyz);
    r0 = tex2D(s0, v1.xy);
    r0 = (r0.wxyz) * (v0.wxyz);
    r2.xyz = (r3.xyz) * (r1.xyz) + (r2.xyz);
    r1.xyz = (r0.yzw) * (r0.yzw);
    r1.xyz = (r2.xyz) * (r1.xyz);
    r2.xyz = (r0.xxx) * (v3.xyz);
    r1.xyz = (r1.xyz) * (r0.xxx) + (-(r2.xyz));
    r1.xyz = (v2.www) * (r1.xyz) + (r2.xyz);
    r0.w = (r0.x) * (c[27].w);
    r0.xyz = max(((r1.xyz) * (c[28].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    r0.w = rsqrt(r0.w);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = 1.0f / (r0.w);

    return oC0;
}
