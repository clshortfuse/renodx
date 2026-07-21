// Mechanically reconstructed from 0xAD49F667.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler2D s3 : register(s3);
sampler2D s4 : register(s4);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD2;
    float4 v4 : TEXCOORD3;
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
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(1.0f, 0.797884583f, 0.0009765625f, -0.0f);
    const float4 c2 = float4(-13.0f, 13.0f, 0.125f, 0.25f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (v1.xy) * (c[28].xy);
    r0 = tex2D(s4, r0.xy);
    r1.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0 = tex2D(s1, v1.xy);
    r0.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r1.xy = (c[28].zz) * (r1.xy) + (r0.xy);
    r0.xyz = v4.xyz;
    r0.xyz = (r1.xxx) * (r0.xyz) + (v2.xyz);
    r0.xyz = (r1.yyy) * (v3.xyz) + (r0.xyz);
    r4.xyz = normalize(r0.xyz);
    r1.xyz = normalize(v5.xyz);
    r4.w = saturate(dot(r4.xyz, -(r1.xyz)));
    r2 = tex2D(s3, v1.xy);
    r0.xyz = (-(v5.xyz)) + (c[5].xyz);
    r0.w = dot(r0.xyz, r0.xyz);
    r3.w = rsqrt(r0.w);
    r5.w = (r2.w) * (c1.y);
    r3.xyz = (r0.xyz) * (r3.www);
    r1.w = (r2.w) * (-(c1.y)) + (c1.x);
    r0.w = saturate(dot(r3.xyz, r4.xyz));
    r4.w = (r4.w) * (r1.w) + (r5.w);
    r1.w = (r0.w) * (r1.w) + (r5.w);
    r1.w = (r1.w) * (r4.w) + (c1.z);
    r1.xyz = (r0.xyz) * (r3.www) + (-(r1.xyz));
    r0.z = 1.0f / (r1.w);
    r5.w = (r0.w) * (r0.z);
    r5.xyz = (r0.www) * (c[6].xyz);
    r0.xyz = normalize(r1.xyz);
    r1 = (v5.xyzx) * (c1.xxxw) + (c1.wwwx);
    r4.z = saturate(dot(r4.xyz, r0.xyz));
    r0.w = dot(r1, c[23]);
    r4.w = saturate(dot(r0.xyz, r3.xyz));
    r0.w = 1.0f / (r0.w);
    r0.x = dot(r1, c[20]);
    r0.y = dot(r1, c[21]);
    r2.w = (r2.w) * (c2.x) + (c2.y);
    r0 = (r0.wwww) * (r0.xxyy);
    r2.w = exp2(r2.w);
    r3 = (r0) * (c[24].zwxy);
    r0.y = pow(abs(r4.z), r2.w);
    r3.x = log2(abs(r3.x));
    r3.y = log2(abs(r3.y));
    r3.z = log2(abs(r3.z));
    r3.w = log2(abs(r3.w));
    r0.z = (r2.w) * (c2.z) + (c2.w);
    r3 = (r3) * (c[25].xxxx);
    r0.z = (r0.y) * (r0.z);
    r3.x = exp2(r3.x);
    r3.y = exp2(r3.y);
    r3.z = exp2(r3.z);
    r3.w = exp2(r3.w);
    r5.w = (r5.w) * (r0.z);
    r3.xy = (r3.zw) + (r3.xy);
    r0.z = (-(r4.w)) + (c1.x);
    r3.x = log2(abs(r3.x));
    r3.y = log2(abs(r3.y));
    r0.y = (r0.z) * (r0.z);
    r3.xy = (r3.xy) * (c[25].yy);
    r0.y = (r0.y) * (r0.y);
    r3.x = exp2(r3.x);
    r3.y = exp2(r3.y);
    r3.z = dot(r1, c[22]);
    r1.w = (r3.x) * (c[26].x);
    r1.z = (r3.y) * (c[26].y) + (-(r1.w));
    r1.y = c[26].y;
    r1.w = (r3.y) * (r1.y) + (-(c[25].z));
    r1.z = 1.0f / (r1.z);
    r3.xy = abs(r0.xw);
    r4.w = saturate((r1.w) * (r1.z));
    r1 = c[10];
    r1 = saturate((r3.zyxz) * (r1) + (c[11]));
    r4.x = (r1.w) * (r1.x);
    r4.yz = r1.yz;
    r1 = (r4) * (r4);
    r4 = (c[26].zzzz) * (r4) + (c[26].wwww);
    r2.w = (r0.z) * (r0.y);
    r1 = (r1) * (r4);
    r4.xyz = (r2.xyz) * (-(r2.xyz)) + (c1.xxx);
    r0.y = (r1.z) * (r1.y);
    r0.z = abs(c[25].w);
    r3.w = (r3.z) * (r3.z);
    r0.y = ((-(r0.z)) >= 0.0f ? (r0.y) : (r1.w));
    r0.z = dot(c[9].yz, r3.zw) + (c[9].x);
    r3.xyz = (r2.www) * (r4.xyz);
    r0.z = (r0.y) * (r0.z);
    r2.xyz = (r2.xyz) * (r2.xyz) + (r3.xyz);
    r2.w = (r1.x) * (r0.z);
    r1 = c[27];
    r1.x = dot(r0.xw, r1.xy) + (c[8].x);
    r1.y = dot(r0.xw, r1.zw) + (c[8].z);
    r0 = tex2D(s2, r1.xy);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r3.xyz = (r5.www) * (r2.xyz);
    r2.xyz = (r2.www) * (r0.xyz);
    r0 = tex2D(s0, v1.xy);
    r0.xyz = (r0.xyz) * (v0.xyz);
    r1.xyz = (r2.xyz) * (c[7].xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1.xyz = (r3.xyz) * (r1.xyz);
    r0.xyz = (r2.xyz) * (r0.xyz);
    r0.w = (r0.w) * (v0.w);
    r0.xyz = (r0.xyz) * (r5.xyz) + (r1.xyz);
    r0.xyz = (r0.www) * (r0.xyz);
    r0.xyz = max(((r0.xyz) * (c[29].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = r0.w;
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
